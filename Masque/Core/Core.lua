--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Core.lua
	* Author.: StormFX

	Core Functions

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local _G, type = _G, type

----------------------------------------
-- Internal
---

local BaseTypes, RegTypes = Core.BaseTypes, Core.RegTypes

----------------------------------------
-- Frame Type
---

-- Frame Types
local oTypes = {
	Button = true,
	CheckButton = true,
	Frame = true,
}

-- Validates and returns the frame type.
local function GetFrameType(Button)
	if type(Button) ~= "table" then return end

	local oType = Button.__MSQ_oType

	if not oType then
		oType = Button.GetObjectType and Button:GetObjectType()
	end

	-- Validate the frame type.
	if not oType or not oTypes[oType] then
		oType = nil
	end

	Button.__MSQ_oType = oType
	return oType
end

-- Returns a sub-type, if applicable.
local function GetSubType(Button, bType)
	local Name = Button.GetName and Button:GetName()
	local SubType = bType

	if bType == "Action" then
		if Name then
			if Name:find("Stance") then
				SubType = "Stance"
			elseif Name:find("Possess") then
				SubType = "Possess"
			elseif Name:find("Pet") then
				SubType = "Pet"
			end
		end

	elseif bType == "Item" then
		if Name then
			-- Retail Bag Buttons
			if Button.SlotHighlightTexture then
				if Name:find("Backpack") then
					SubType = "Backpack"
				elseif Name:find("CharacterBag") then
					SubType = "BagSlot"
				elseif Name:find("ReagentBag") then
					SubType = "ReagentBag"
				end

			-- Classic Bag Buttons
			elseif Button.__MSQ_oType == "CheckButton" then
				if Name:find("Backpack") then
					SubType = "Backpack"
				elseif Name:find("CharacterBag") then
					SubType = "BagSlot"
				end
			end
		end

	elseif bType == "Aura" then
		if Button.DebuffBorder then
			SubType = Button.auraType or "Aura"

			if SubType == "DeadlyDebuff" then
				SubType = "Debuff"
			elseif SubType == "TempEnchant" then
				SubType = "Enchant"
			end
		else
			local Border = Button.Border or (Name and _G[Name.."Border"])

			if Border then
				SubType = (Button.symbol and "Debuff") or "Enchant"
			end
		end
	end

	return SubType
end

-- Returns a button's internal type.
function Core.GetType(Button, bType)
	local oType = GetFrameType(Button)

	-- Exit if the frame type is invalid.
	if not oType then return end

	bType = bType or Button.__MSQ_bType

	-- Invalid/unspecified type.
	if not bType or not RegTypes[bType] then
		bType = bType or "Legacy"

		if oType == "CheckButton" then
			-- Action
			if Button.HotKey then
				bType = GetSubType(Button, "Action")

			-- Item
			-- * Classic bag buttons are CheckButtons.
			elseif Button.IconBorder then
				bType = GetSubType(Button, "Item")
			end

		elseif oType == "Button" then
			-- Item
			if Button.IconBorder then
				bType = GetSubType(Button, "Item")

			-- Aura
			elseif Button.duration or Button.Duration then
				bType = GetSubType(Button, "Aura")
			end
		end

	-- Declared as a base type.
	elseif BaseTypes[bType] then
		bType = GetSubType(Button, bType)
	end

	Button.__MSQ_bType = bType
	return oType, bType
end

----------------------------------------
-- Group Queue
---

-- Self-destructing table to skin groups created prior to PLAYER_LOGIN.
Core.Queue = {
	Cache = {},

	-- Adds a group to the queue.
	Add = function(self, obj)
		self.Cache[#self.Cache + 1] = obj
		obj.Queued = true
	end,

	-- Re-Skins all queued groups.
	ReSkin = function(self)
		for i = 1, #self.Cache do
			local obj = self.Cache[i]

			obj:ReSkin(true)
			obj.Queued = nil
		end

		-- GC
		self.Cache = nil
		Core.Queue = nil
	end,
}

setmetatable(Core.Queue, {__call = Core.Queue.Add})

----------------------------------------
-- Region Finder
---

-- Returns a region for a button based on a template.
function Core.GetRegion(Button, Info)
	local Key, Region = Info.Key, nil

	if Key then
		local Obj = Key and Button[Key]

		if Obj and type(Obj) == "table" then
			local Type = Obj.GetObjectType and Obj:GetObjectType()

			if Type == Info.Type then
				Region = Obj
			end
		end
	end

	if not Region then
		local Func, Name = Info.Func, Info.Name

		if Func then
			local f = Func and Button[Func]
			Region = f and f(Button)
		elseif Name then
			local n = Button.GetName and Button:GetName()
			Region = n and _G[n..Name]
		end
	end

	return Region
end

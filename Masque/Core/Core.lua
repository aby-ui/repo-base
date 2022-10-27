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
-- Region Finder
---

-- Gets a button region.
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

----------------------------------------
-- Type Validator
---

do
	-- Valid Types
	local oTypes = {
		Button = true,
		CheckButton = true,
		Frame = true,
	}

	-- Function to check for a sub-type.
	local function GetSubType(Button, bType, oType)
		if not Button then return end

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
			local Border = Button.Border or (Name and _G[Name.."Border"])

			if Border then
				SubType = (Button.symbol and "Debuff") or "Enchant"
			end
		end
		return SubType
	end

	Core.GetSubType = GetSubType

	-- Returns a button's object or internal type.
	function Core.GetType(Button, oType)
		local Type

		if not oType then
			if type(Button) == "table" then
				Type = Button.GetObjectType and Button:GetObjectType()

				if not Type or not oTypes[Type] then
					Type = nil
				end

				Button.__MSQ_oType = Type
			end
		else
			Type = "Legacy"

			if oType == "CheckButton" then
				-- Action
				if Button.HotKey then
					Type = GetSubType(Button, "Action", oType)

				-- Item
				-- * Classic bag buttons are CheckButtons.
				elseif Button.IconBorder then
					Type = GetSubType(Button, "Item", oType)
				end
			elseif oType == "Button" then
				-- Item
				if Button.IconBorder then
					Type = GetSubType(Button, "Item", oType)

				-- Aura
				elseif Button.duration then
					Type = GetSubType(Button, "Aura", oType)
				end
			end
		end
		return Type
	end
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

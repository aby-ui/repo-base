--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Core.lua
	* Author.: StormFX

	Core Functions

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local _G, setmetatable, type = _G, setmetatable, type

----------------------------------------
-- Locals
---

-- Valid Types
local oTypes = {
	Button = true,
	CheckButton = true,
	Frame = true,
}

----------------------------------------
-- Type Validator
---

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
			if Button.HotKey then
				Type = "Action"

				local bName = Button.GetName and Button:GetName()

				if bName and bName:find("Pet") then
					Type = "Pet"
				end
			end
		elseif oType == "Button" then
			if Button.IconBorder then
				Type = "Item"
			elseif Button.duration then
				Type = "Aura"

				local bName = Button.GetName and Button:GetName()
				local Border = bName and _G[bName.."Border"]

				if Border then
					Type = (Button.symbol and "Debuff") or "Enchant"
				end
			end
		end
	end

	return Type
end

----------------------------------------
-- Region Retriever
---

-- Gets a button region.
function Core.GetRegion(Button, Info)
	local Key, Region = Info.Key, nil

	if Key then
		local Value = Key and Button[Key]

		if Value and type(Value) == "table" then
			local Type = Value.GetObjectType and Value:GetObjectType()

			if Type == Info.Type then
				Region = Value
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

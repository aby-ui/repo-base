--[[
	misc things I need to get my widget framework workingish
--]]

local _, Addon = ...

Addon.Classy = {
	New = function(self, frameType, parentClass)
		local class = CreateFrame(frameType)
		class.mt = {__index = class}

		if parentClass then
			class = setmetatable(class, {__index = parentClass})
			class.super = parentClass
		end

		class.Bind = function(c, obj)
			return setmetatable(obj, c.mt)
		end

		return class
	end
}
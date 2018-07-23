--[[
	Classy.lua
		A wrapper for defining classes that inherit from widgets
--]]

local Classy = LibStub:NewLibrary('Classy-1.0', 0)
if not Classy then return end

function Classy:New(frameType, parentClass)
	local class = CreateFrame(frameType)
	class.mt = {__index = class}

	if parentClass then
		class = setmetatable(class, {__index = parentClass})
		
		class.super = function(self, method, ...)
			parentClass[method](self, ...)
		end
	end

	class.Bind = function(self, obj)
		return setmetatable(obj, self.mt)
	end

	return class
end
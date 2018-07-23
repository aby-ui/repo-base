--[[
Copyright 2011-2017 João Cardoso
Poncho is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of EmbedHandler.

Poncho is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Poncho is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Poncho. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub:NewLibrary('Poncho-1.0', 1)
if not Lib then
	return
end

local rawget = rawget
local function IndexClass (class, key)
	if class then
		return class[key] or IndexClass( rawget(class, '__super'), key )
	end
end

local Types, Empty = {}, {}
local Meta = {
	__index = function(class, key)
		return IndexClass( rawget(class, '__super'), key ) or rawget(class, '__type')[key]
	end,
	__call = function(class, ...)
		return class:GetFrame(...)
	end
}


--[[ The Method ]]--

function Lib:NewClass (type, name, parent, templates, super)
	if type and not Types[type] then
		local proxy = CreateFrame(type); proxy:Hide()
		Types[type] = getmetatable(proxy).__index
	end
	
	local class = setmetatable( UIFrameCache:New (type, name, parent, templates), Meta )
	class.__type = type and Types[type] or Empty
	class.__super = super or self.Base
	class.__index = class
	
	if name then
		_G[name] = class
	end
	return class
end

setmetatable(Lib, Lib)
Lib.__call = Lib.NewClass
Lib.Base = nil
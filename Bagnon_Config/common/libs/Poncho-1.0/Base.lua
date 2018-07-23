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

local Lib = LibStub('Poncho-1.0')
if Lib.Base then
	return
end

local Base = Lib(nil, nil, nil, nil, UIFrameCache)
local Safecall = function(frame, key)
	if type(frame[key]) == 'function' then
		return frame[key](frame)
	end
end

function Base:GetFrame (parent)
	local isNew = not self.frames[1]
	local frame = UIFrameCache.GetFrame(self)
	
	if isNew then
		setmetatable(frame, self)
		Safecall(frame, 'OnCreate')
	end
	
	if parent then
		frame:SetParent(parent)
	end
	
	Safecall(frame, 'OnAcquire')
	return frame
end

function Base:ReleaseFrame (frame)
	UIFrameCache.ReleaseFrame(self, frame)
	Safecall(frame, 'OnRelease')
end

function Base:Release ()
	self.__index:ReleaseFrame(self)
end

Lib.Base = Base
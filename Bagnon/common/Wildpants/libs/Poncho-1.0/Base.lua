--[[
Copyright 2011-2019 João Cardoso
Poncho is distributed under the terms of the GNU General Public License (Version 3).

As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of Poncho.
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

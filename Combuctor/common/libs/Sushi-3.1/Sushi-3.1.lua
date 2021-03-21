--[[
Copyright 2008-2021 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub:NewLibrary('Sushi-3.1', 4)
if not Lib then return end

local Base = Lib.Base or LibStub('Poncho-2.0')()
local Install = debugstack(1,1,0):match('^(.+)\\Sushi[%d\.\-]+\.lua') or ''
local Root = 'Interface\\AddOns\\'

if Install:sub(1,3) == '...' then
	Install = Install:sub(4)

	for i = strlen(Install), 0, -1 do
		if Root:find(Install:sub(1, i) .. '$') then
			Install = Root .. Install:sub(i+1)
			break
		end
	end
else
	Install = Install:match('Interface\\AddOns\\.+') or ''
end

function Base:NewSushi(name, version, type, template, global)
	local class = Lib[name] or self:NewClass(type, (global or self:GetClassName()) and ('Sushi-3.1-' .. name), template)
	local old = rawget(class, '__version') or 0
	if old >= version then
		return
	end

	class.__version = version
	Lib[name] = class
	return class, old
end

Lib.Base = Base
Lib.InstallLocation = Install

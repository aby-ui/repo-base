--[[
Copyright 2008-2019 João Cardoso
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

function MakeSushi(version, type, name, ...)
	local name = 'Sushi' .. name
	local class = _G[name] or LibStub('Poncho-1.0')(type, name, ...)
	local old = rawget(class, 'version')

	if not old or version > old then
		class.version = version
		return class, old
	end
end

local location = debugstack(1,1,0):match('^(.+)\\Sushi[%d\.\-]+\.lua')
local best = strlen(location)

for k = 1, GetNumAddOns() do
	local addon = GetAddOnInfo(k)
	local root = 'Interface\\AddOns\\' .. addon .. '\\'

	if location:sub(1,3) == '...' then
		for i = 4, best do
			if root:find(location:sub(4, i) .. '$') then
				location = root .. location:sub(i+1)
				best = i
				break
			end
		end
	end
end

Sushi_Directory = location

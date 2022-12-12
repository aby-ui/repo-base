--[[
Copyright 2008-2022 João Cardoso
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

local Box = LibStub('Sushi-3.1').Editable:NewSushi('BoxEdit', 1, 'EditBox', 'InputBoxTemplate')
if not Box then return end

function Box:Construct()
	local f = self:Super(Box):Construct()
	f.Label:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', -7, -4)
	f:SetSize(150, 35)
	return f
end

Box.bottom = 6
Box.right = 20
Box.left = 25
Box.top = 10

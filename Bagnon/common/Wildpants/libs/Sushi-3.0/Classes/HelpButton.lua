--[[
Copyright 2008-2019 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi List.

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

local Help = MakeSushi(1, 'Button', 'HelpButton', nil, false, SushiButtonBase)
if not Help then
	return
end

function Help:OnCreate()
	SushiButtonBase.OnCreate(self)
	
	self:SetHighlightTexture('Interface\\FriendsFrame\\InformationIcon-Highlight')
	self:SetNormalTexture('Interface\\FriendsFrame\\InformationIcon')
	self:SetSize(16, 16)
end
--[[
Copyright 2008-2022 João Cardoso
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

local Help = LibStub('Sushi-3.1').Clickable:NewSushi('HelpButton', 1, 'Button')
if not Help then return end

function Help:Construct()
	local b = self:Super(Help):Construct()
	b:SetHighlightTexture('Interface/FriendsFrame/InformationIcon-Highlight')
	b:SetNormalTexture('Interface/FriendsFrame/InformationIcon')
	b:SetSize(16, 16)
	return b
end

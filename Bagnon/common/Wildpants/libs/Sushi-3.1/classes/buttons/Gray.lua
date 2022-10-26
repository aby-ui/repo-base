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

local Gray = LibStub('Sushi-3.1').RedButton:NewSushi('GrayButton', 1)
if not Gray then return end

function Gray:Construct()
	local b = self:Super(Gray):Construct()
	b:SetScript('OnMouseDown', b.OnMouseDown)
	b:SetScript('OnMouseUp', b.OnMouseUp)
	b:SetScript('OnShow', b.OnMouseUp)

	if b:IsVisible() then
		b:OnMouseUp()
	end
	return b
end

function Gray:OnMouseDown()
	self.Left:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
	self.Middle:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
	self.Right:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
end

Gray.NormalFont = 'GameFontHighlight'
Gray.OnMouseUp = UIPanelButton_OnDisable

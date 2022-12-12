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

local Icon = LibStub('Sushi-3.1').Check:NewSushi('IconCheck', 1, 'CheckButton')
if not Icon then return end

function Icon:Construct()
	local b = self:Super(Icon):Construct()
	local icon = b:CreateTexture(nil, 'BACKGROUND')
	icon:SetPoint('LEFT', 2, 2)
	icon:SetSize(37, 37)

	local normal = b:GetNormalTexture()
	normal:ClearAllPoints()
	normal:SetPoint('BOTTOMRIGHT', icon, 10, -10)

	b.Icon = icon
	b:SetHeight(45)
	b:GetFontString():SetPoint('LEFT', 52, 1)
	return b
end

function Icon:New(parent, icon, text)
	local b = self:Super(Icon):New(parent, text)
	b:SetIcon(icon)
	return b
end

function Icon:SetIcon(icon)
	self.Icon:SetTexture(icon)
end

function Icon:GetIcon()
	return self.Icon:GetTexture()
end

Icon.WidthOff = 52
Icon.bottom = 10
Icon.top = 2

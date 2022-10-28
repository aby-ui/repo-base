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

local Check = LibStub('Sushi-3.1').TextedClickable:NewSushi('Check', 1, 'CheckButton')
if not Check then return end


--[[ Construct ]]--

function Check:Construct()
	local b = self:Super(Check):Construct()
	local text = b:CreateFontString(nil, nil, self.NormalFont)
	text:SetPoint('LEFT', 28, 1)

	local normal = b:CreateTexture()
	normal:SetTexture('Interface/Buttons/UI-CheckBox-Up')
	normal:SetPoint('LEFT')
	normal:SetSize(26, 26)

	local pushed = b:CreateTexture()
	pushed:SetTexture('Interface/Buttons/UI-CheckBox-Down')
	pushed:SetAllPoints(normal)

	local checked = b:CreateTexture()
	checked:SetTexture('Interface/Buttons/UI-CheckBox-Check')
	checked:SetAllPoints(normal)

	local disabled = b:CreateTexture()
	disabled:SetTexture('Interface/Buttons/UI-CheckBox-Check-Disabled')
	disabled:SetAllPoints(normal)

	local highlight = b:CreateTexture()
	highlight:SetTexture('Interface/Buttons/UI-CheckBox-Highlight')
	highlight:SetAllPoints(normal)
	highlight:SetBlendMode('ADD')

	b:SetHeight(26)
	b:SetFontString(text)
	b:SetNormalTexture(normal)
	b:SetPushedTexture(pushed)
	b:SetCheckedTexture(checked)
	b:SetHighlightTexture(highlight)
	b:SetDisabledCheckedTexture(disabled)
	return b
end

function Check:Reset()
	self:Super(Check):Reset()
	self:SetChecked(false)
end


--[[ Proprieties ]]--

Check.NormalFont = 'GameFontHighlight'
Check.SetValue = Check.SetChecked
Check.GetValue = Check.GetChecked
Check.MinWidth = 150
Check.WidthOff = 28
Check.bottom = 8
Check.right = 10
Check.left = 10

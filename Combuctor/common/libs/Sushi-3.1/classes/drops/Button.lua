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

local Button = LibStub('Sushi-3.1').Clickable:NewSushi('DropButton', 1, 'CheckButton', 'UIDropDownMenuButtonTemplate', true)
if not Button then return end


--[[ Construct ]]--

function Button:Construct()
	local b = self:Super(Button):Construct()
	local name = b:GetName()

	--b.Arrow = _G[name .. 'ExpandArrow']
	--b.Color = _G[name .. 'ColorSwatch']
	--b.Color.Bg = _G[name .. 'ColorSwatchSwatchBG']

	b:SetScript('OnEnable', nil)
	b:SetScript('OnDisable', nil)
	b:SetHighlightTexture(b.Highlight)
	b:SetCheckedTexture(_G[name .. 'Check'])
	b:SetNormalTexture(_G[name .. 'UnCheck'])
	return b
end

function Button:New(parent, info)
	local info = info or {}
	local b = self:Super(Button):New(parent)

	--b.Color:SetShown(info.hasColorSwatch)
	--b.Arrow:SetEnabled(not info.disabled)
	--b.Arrow:SetShown(info.menuTable or info.hasArrow)

	b.info = info
	b:SetText(info.text)
	b:SetChecked(info.checked)
	b:SetTip(info.tooltipTitle, info.tooltipText)
	b:SetEnabled(not info.disabled and not info.isTitle)
	b:SetCall('OnClick', info.func and function() info:func() end)
	b:SetCheckable(not info.isTitle and not info.notCheckable, not info.isNotRadio)
	b:SetNormalFontObject(info.fontObject or info.isTitle and GameFontNormalSmallLeft or GameFontHighlightSmallLeft)
	b:SetDisabledFontObject(info.fontObject or info.isTitle and GameFontNormalSmallLeft or GameFontDisableSmallLeft)

	if parent.SetCall then
		parent:SetCall('OnResize', function() b:UpdateWidth() end)
	end

	return b
end

function Button:OnClick()
	self.info.checked = self:GetChecked()
	self:Super(Button):OnClick()
end


--[[ API ]]--

function Button:SetText(text)
	self:Super(Button):SetText(text)
	self:UpdateWidth()
end

function Button:SetCheckable(checkable, radio)
	local uv = radio and 0.5 or 0

	self.left = checkable and 10 or 16
	self:GetNormalTexture():SetTexCoord(0.5, 1, uv, uv+0.5)
	self:GetNormalTexture():SetAlpha(checkable and 1 or 0)
	self:GetCheckedTexture():SetTexCoord(0, 0.5, uv, uv+0.5)
	self:GetCheckedTexture():SetAlpha(checkable and 1 or 0)
	self:GetFontString():SetPoint('LEFT', checkable and 20 or 0, 0)
	self:UpdateWidth()
end

function Button:IsCheckable()
	local normal = self:GetNormalTexture()
	return normal:GetAlpha() > 0, select(3, normal:GetTexCoord()) > 0
end

function Button:UpdateWidth()
	self:SetWidth(max(
		self:GetParent():GetWidth() - self.left - self.right,
		self:GetTextWidth() + (self:IsCheckable() and 24 or 4)
	))
end


--[[ Proprieties ]]--

Button.SetLabel, Button.GetLabel = Button.SetText, Button.GetText
Button.left, Button.right = 16, 16
Button.top, Button.bottom = 1, 1

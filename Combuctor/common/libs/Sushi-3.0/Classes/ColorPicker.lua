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

local Check = SushiCheck
local Color = MakeSushi(5, 'CheckButton', 'ColorPicker', nil, nil, Check)
if not Color then
	return
end


--[[ Builder ]]--

function Color:OnCreate ()
	local Border = self:CreateTexture(nil, 'BORDER')
	Border:SetTexture('Interface\\ChatFrame\\ChatFrameColorSwatch')
	Border:SetWidth(23) Border:SetHeight(23)
	Border:SetPoint('Center')

	local Color = self:CreateTexture(nil, 'OVERLAY')
	Color:SetTexture('Interface\\ChatFrame\\ChatFrameColorSwatch')
	Color:SetWidth(19) Color:SetHeight(19)
	Color:SetPoint('Center')
	self.Color = Color

	local Glow = self:CreateTexture()
	Glow:SetTexture('Interface\\Buttons\\UI-CheckBox-Highlight')
	Glow:SetWidth(21) Glow:SetHeight(23)
	Glow:SetPoint('Center')

	self:SetHighlightTexture(Glow)
	self:SetDisabledTexture(nil)
	self:SetCheckedTexture(nil)
	self:SetPushedTexture(nil)
	self:SetNormalTexture(nil)
	Check.OnCreate(self)
end

function Color:OnRelease ()
	Check.OnRelease(self)
	self:SetColor(1, 1, 1)
	self:EnableAlpha(nil)
end


--[[ Scripts ]]--

function Color:OnClick ()
	local r, g, b, a = self:GetColor()
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc = nil
	ColorPickerFrame:SetColorRGB(r or 1, g or 1, b or 1)
	ColorPickerFrame.hasOpacity = self:HasAlpha()
	ColorPickerFrame.opacity = 1 - (a or 1)

	ColorPickerFrame.func = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		self:SaveColor(r, g, b, 1 - OpacitySliderFrame:GetValue())

		if not ColorPickerFrame:IsVisible() then
			self:FireCall('OnUpdate')
		end
	end

	ColorPickerFrame.opacityFunc = ColorPickerFrame.func
	ColorPickerFrame.cancelFunc = function()
		self:SaveColor(r, g, b, a)
	end

	ColorPickerFrame:Show() --ShowUIPanel(ColorPickerFrame)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end


--[[ Color ]]--

function Color:SetColor (...)
	self.r, self.g, self.b, self.a = ...
	self.Color:SetVertexColor(self.r or 1, self.g or 1, self.b or 1)
end

function Color:SaveColor (...)
	self:SetColor(...)
	self:FireCall('OnColorChanged', ...)
	self:FireCall('OnInput', ...)
end

function Color:GetColor ()
	return self.r, self.g, self.b, self.a
end


--[[ Alpha ]]--

function Color:EnableAlpha (enable)
	self.hasAlpha = enable
end

function Color:HasAlpha ()
	return self.hasAlpha
end


Color.SetValue = Color.SetColor
Color.GetValue = Color.GetColor

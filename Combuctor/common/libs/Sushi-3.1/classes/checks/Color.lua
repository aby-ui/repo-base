--[[
Copyright 2008-2022 João Cardoso
Sushi is distributed under the terms of the GNU General Public License(or the Lesser GPL).
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

local Color = LibStub('Sushi-3.1').TextedClickable:NewSushi('ColorPicker', 2, 'Button')
if not Color then	return end


--[[ Overrides ]]--

function Color:Construct()
	local b = self:Super(Color):Construct()
	local text = b:CreateFontString(nil, nil, self.NormalFont)
	text:SetPoint('LEFT', 28, 1)

	local swatch = b:CreateTexture(nil, 'BACKGROUND')
	swatch:SetAtlas('Forge-ColorSwatch')
	swatch:SetPoint('LEFT', 2, 1)
	swatch:SetSize(20, 19)

	local bg = b:CreateTexture(nil, 'BORDER')
	bg:SetAtlas('Forge-ColorSwatchBackground')
	bg:SetAllPoints(swatch)
	bg:SetAlpha(.2)

	local border = b:CreateTexture(nil, 'ARTWORK')
	border:SetAtlas('Forge-ColorSwatchBorder')
	border:SetAllPoints(swatch)

	local glow = b:CreateTexture()
	glow:SetAtlas('Forge-ColorSwatchHighlight')
	glow:SetAllPoints(swatch)

	local pushed = b:CreateTexture()
	pushed:SetAtlas('Forge-ColorSwatchSelection')
	pushed:SetAllPoints(swatch)

	b.Swatch = swatch
	b:SetHeight(26)
	b:SetFontString(text)
	b:SetNormalTexture(border)
	b:SetHighlightTexture(glow)
	b:SetPushedTexture(pushed)
	return b
end

function Color:New(parent, text, color)
	local b = self:Super(Color):New(parent, text)
	b:SetValue(color)
	return b
end

function Color:OnClick()
	local color = self:GetValue()
	local set = function(color)
		self:SetValue(color)
		self:FireCalls('OnColor', color)
		self:FireCalls('OnInput', color)

		if not ColorPickerFrame:IsShown() then
			self:SetButtonState('NORMAL')
			self:FireCalls('OnUpdate')
		end
	end

	-- order of these lines is important
	ColorPickerFrame.func = function()
		local a = self:HasAlpha() and (1 - OpacitySliderFrame:GetValue())
		local r,g,b = ColorPickerFrame:GetColorRGB()
		set(CreateColor(r,g,b,a))
	end
	ColorPickerFrame.cancelFunc = function() set(color) end
	ColorPickerFrame.opacityFunc = ColorPickerFrame.func
	ColorPickerFrame.opacity = 1 - (color.a or 1)
	ColorPickerFrame.hasOpacity = self:HasAlpha()
	ColorPickerFrame.target = self
	ColorPickerFrame:Show()
	ColorPickerFrame:SetColorRGB(color:GetRGB())

	self:SetButtonState('PUSHED', true)
	PlaySound(self.Sound)
end


--[[ API ]]--

function Color:SetValue(color)
	self.color = color
	self.Swatch:SetVertexColor(self.color:GetRGB())
end

function Color:GetValue()
	return self.color
end

function Color:HasAlpha()
	return type(self.color.a) == 'number'
end


--[[ Proprieties ]]--

Color.NormalFont = 'GameFontHighlight'
Color.SetColor = Color.SetValue
Color.GetColor = Color.GetValue
Color.MinWidth = 150
Color.WidthOff = 28

Color.color = CreateColor(1,1,1)
Color.bottom = 8
Color.right = 10
Color.left = 10

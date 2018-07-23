--[[
	font.lua: the OmniCC font styles panel
--]]

local FontOptions = CreateFrame('Frame', 'OmniCCOptions_Font')
local Timer = OmniCC.Timer
local L = OMNICC_LOCALS
local BUTTON_SPACING = 24


--[[ Events ]]--

function FontOptions:AddWidgets()
	self.Sliders = {}

	self.Fonts = self:CreateFontSelector(L.Font)
	self.Fonts:SetPoint('TOPLEFT', self, 'TOPLEFT', 12, -20)
	self.Fonts:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -16, 240)

	self.Styles = self:CreateColorPickerFrame(L.ColorAndScale)
	self.Styles:SetPoint('TOPLEFT', self.Fonts, 'BOTTOMLEFT', 0, -16)
	self.Styles:SetPoint('TOPRIGHT', self.Fonts, 'BOTTOMRIGHT', 0, -16)
	self.Styles:SetHeight(BUTTON_SPACING*6 - 4)

	self.Outline = self:CreateFontOutlinePicker()
	self.Outline:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 16, 10)
	self.Outline:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -16, 10)

	self.FontSize = self:CreateFontSizeSlider()
	self.FontSize:SetPoint('BOTTOMLEFT', self.Outline, 'TOPLEFT', 0, 20)
	self.FontSize:SetPoint('BOTTOMRIGHT', self.Outline, 'TOPRIGHT', 0, 20)
end

function FontOptions:UpdateValues()
	for i, slider in ipairs(self.Sliders) do
		slider:UpdateValue()
	end

	self.Fonts:UpdateSelected()
end


--[[ Frames ]]--

function FontOptions:CreateFontSelector(name)
	local f = OmniCCOptions.FontSelector:New(name, self, 552, 232)

	f.SetSavedValue = function(self, value)
		OmniCCOptions:GetGroupSets().fontFace = value
		Timer:ForAll('UpdateText', true)
	end

	f.GetSavedValue = function(self)
		return OmniCCOptions:GetGroupSets().fontFace
	end

	return f
end

function FontOptions:CreateColorPickerFrame(name)
	local f = OmniCCOptions.Group:New(name, self)

	local soon = self:CreateStylePicker('soon', f)
	soon:SetPoint('TOPLEFT', 8, -(BUTTON_SPACING + 4))
	soon:SetPoint('TOPRIGHT', f, 'TOP', -4, -(BUTTON_SPACING + 4))

	local seconds = self:CreateStylePicker('seconds', f)
	seconds:SetPoint('TOPLEFT', f, 'TOP', 4,  -(BUTTON_SPACING + 4))
	seconds:SetPoint('TOPRIGHT', -8, -(BUTTON_SPACING + 4))

	local minutes = self:CreateStylePicker('minutes', f)
	minutes:SetPoint('TOPLEFT', soon, 'BOTTOMLEFT', 0, -BUTTON_SPACING)
	minutes:SetPoint('TOPRIGHT', soon, 'BOTTOMRIGHT', 0, -BUTTON_SPACING)

	local hours = self:CreateStylePicker('hours', f)
	hours:SetPoint('TOPLEFT', seconds, 'BOTTOMLEFT', 0, -BUTTON_SPACING)
	hours:SetPoint('TOPRIGHT', seconds, 'BOTTOMRIGHT', 0, -BUTTON_SPACING)

	local charging = self:CreateStylePicker('charging', f)
	charging:SetPoint('TOPLEFT', minutes, 'BOTTOMLEFT', 0, -BUTTON_SPACING)
	charging:SetPoint('TOPRIGHT', minutes, 'BOTTOMRIGHT', 0, -BUTTON_SPACING)

	local controlled = self:CreateStylePicker('controlled', f)
	controlled:SetPoint('TOPLEFT', hours, 'BOTTOMLEFT', 0, -BUTTON_SPACING)
	controlled:SetPoint('TOPRIGHT', hours, 'BOTTOMRIGHT', 0, -BUTTON_SPACING)

	return f
end


--[[ Style Picker ]]--

function FontOptions:CreateStylePicker(timePeriod, parent)
	local slider = FontOptions:NewSlider(L['Color_' .. timePeriod], parent, 0.5, 2, 0.05)

	 _G[slider:GetName() .. 'Text']:Hide()

	slider.SetSavedValue = function(self, value)
		OmniCCOptions:GetGroupSets().styles[timePeriod].scale = value
		Timer:ForAll('UpdateText', true)
	end

	slider.GetSavedValue = function(self)
		return OmniCCOptions:GetGroupSets().styles[timePeriod].scale
	end

	slider.GetFormattedText = function(self, value)
		return floor(value * 100 + 0.5) .. '%'
	end

	--color picker
	local picker = OmniCCOptions.ColorSelector:New(L['Color_' .. timePeriod], slider, true)
	picker:SetPoint('BOTTOMLEFT', slider, 'TOPLEFT')

	picker.OnSetColor = function(self, r, g, b, a)
		local style = OmniCCOptions:GetGroupSets().styles[timePeriod]
		style.r, style.g, style.b, style.a = r, g, b, a
		Timer:ForAll('UpdateText', true)
	end

	picker.GetColor = function(self)
		local style = OmniCCOptions:GetGroupSets().styles[timePeriod]
		return style.r, style.g, style.b, style.a
	end

	picker.text:ClearAllPoints()
	picker.text:SetPoint('BOTTOMLEFT', picker, 'BOTTOMRIGHT', 4, 0)

	return slider
end



--[[ Sliders ]]--

function FontOptions:CreateFontSizeSlider()
	local s = self:NewSlider(L.FontSize, self, 2, 48, 1)

	s.SetSavedValue = function(self, value)
		OmniCCOptions:GetGroupSets().fontSize = value
		Timer:ForAll('UpdateText', true)
	end

	s.GetSavedValue = function(self)
		return OmniCCOptions:GetGroupSets().fontSize
	end

	s.tooltip = L.FontSizeTip

	return s
end

do
	local fontOutlines = {'NONE', 'OUTLINE', 'THICKOUTLINE', 'OUTLINEMONOCHROME'}
	local function toIndex(fontOutline)
		for i, outline in pairs(fontOutlines) do
			if outline == fontOutline then
				return i
			end
		end
	end

	local function toOutline(index)
		return fontOutlines[index]
	end

	function FontOptions:CreateFontOutlinePicker()
		local s = self:NewSlider(L.FontOutline, self, 1, #fontOutlines, 1)

		s.SetSavedValue = function(self, value)
			OmniCCOptions:GetGroupSets().fontOutline = toOutline(value)
			Timer:ForAll('UpdateText', true)
		end

		s.GetSavedValue = function(self)
			return toIndex(OmniCCOptions:GetGroupSets().fontOutline) or 1
		end

		s.GetFormattedText = function(self, value)
			return L['Outline_' .. toOutline(value or 1)]
		end

		s.tooltip = L.FontOutlineTip

		return s
	end
end

function FontOptions:NewSlider(name, parent, low, high, step)
	local s = OmniCCOptions.Slider:New(name, parent, low, high, step)
	tinsert(self.Sliders, s)
	return s
end


--[[ Load the thing ]]--

FontOptions:AddWidgets()
OmniCCOptions:AddTab('font', L.FontSettings, FontOptions)
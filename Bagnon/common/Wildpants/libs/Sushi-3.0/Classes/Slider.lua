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

--[[
API Explained
	:SetRange (maxValue, minValue)
	:SetStep (step, [minStep]) -- if minStep is set, step is only used for the mousewheel
	:SetPattern (pattern) -- where %s is the value
	
	:SetText/:SetLabel (label)
	:SetRangeText (minText, maxText)
	:SetValueText (valueText)  -- replaces the pattern with the given text
]]--

local TipOwner = SushiTipOwner
local Slider = MakeSushi(2, 'Slider', 'Slider', nil, 'OptionsSliderTemplate', TipOwner)
if not Slider then
	return
end

local TestString = UIParent:CreateFontString()
TestString:SetFontObject('GameFontHighlightSmall')


--[[ Builder ]]--

function Slider:OnCreate()
	local name = self:GetName()
	TipOwner.OnCreate(self)
	
	local Label = _G[name .. 'Text']
	Label:SetPoint('BOTTOM',  self, 'TOP')
	
	local High = _G[name .. 'High']
	High:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, 1)
	
	local Low = _G[name .. 'Low']
	Low:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, 1)
	
	local EditBox = CreateFrame('EditBox', nil, self)
	EditBox:SetJustifyH('CENTER')
	EditBox:SetAutoFocus(false)
	EditBox:SetHeight(18)
	
	EditBox:SetScript('OnTextChanged', function() self:UpdateEditWidth() end)
	EditBox:SetScript('OnEnter', function() self:OnEnter() end)
	EditBox:SetScript('OnLeave', function() self:OnLeave() end)
	EditBox:SetScript('OnEscapePressed', self.OnEscapePressed)
	EditBox:SetScript('OnEnterPressed', self.OnEnterPressed)
	
	local EditBG = CreateFrame('Frame', nil, EditBox)
	EditBG:SetPoint('TOP', self, 'BOTTOM', 0, 3)
	EditBG:SetHeight(18)
	EditBG:SetBackdrop({
		bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
		edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
		insets = {left = 2, right = 2, top = 2, bottom = 2},
		edgeSize = 11,
	})
	
	EditBG:SetBackdropBorderColor(0,0,0, 0.3)
	EditBG:SetBackdropColor(0,0,0, 0.25)
	
	local Prefix = EditBox:CreateFontString()
	Prefix:SetPoint('LEFT', EditBG, 3, 0)
	Prefix:SetFontObject(GameFontHighlightSmall)

	local Suffix = EditBox:CreateFontString()
	Suffix:SetPoint('RIGHT', EditBG, -3, 0)
	Suffix:SetFontObject(GameFontHighlightSmall)
	
	self:SetScript('OnValueChanged', self.OnValueChanged)
	self:SetScript('OnShow', self.UpdateEditBackground)
	self:SetScript('OnMouseWheel', self.OnMouseWheel)
	self:SetScript('OnHide', self.StopUpdate)
	self:EnableMouseWheel(true)
	
	self.EditBox = EditBox
	self.EditBG = EditBG
	self.Suffix = Suffix
	self.Prefix = Prefix
	self.Label = Label
	self.High = High
	self.Low = Low
end

function Slider:OnAcquire()
	TipOwner.OnAcquire(self)
	self:UpdateFonts()
	self:SetPattern('%s')
	self:SetRange(1, 100)
	self:SetStep(1)
	self:SetValue(1)
end

function Slider:OnRelease()
	TipOwner.OnRelease(self)
	self.valueText, self.lowText, self.highText, self.disabled, self.small = nil
	self:SetWidth(144)
	self:SetLabel(nil)
end


--[[ Slider Events ]]--

function Slider:OnValueChanged(value, dragged)
	if dragged then
		self:SetScript('OnUpdate', self.OnDelayedUpdate)
		self:SetValue(value)
	end
end

function Slider:OnMouseWheel(direction)
	self:SetValue(self:GetValue() + self:GetValueStep() * direction, true)
end

function Slider:OnEnter()
	TipOwner.OnEnter(self)
	self:UpdateEditBackground()
end

function Slider:OnLeave()
	TipOwner.OnLeave(self)
	self:UpdateEditBackground()
end


--[[ Update ]]--

function Slider:OnDelayedUpdate()
	if not IsMouseButtonDown() then
		self:Update()
	end
end

function Slider:Update()
	self:StopUpdate()
	self:FireCall('OnUpdate')
end

function Slider:StopUpdate()
	self:SetScript('OnUpdate', nil)
end


--[[ Editbox ]]--

function Slider:OnEnterPressed()
	local value = tonumber(self:GetText():gsub(',', '.'), nil) --2º arg required!
	if value then
		self:GetParent():SetValue(value, true)
	end
	self:ClearFocus()
end

function Slider:OnEscapePressed()
	self:GetParent():UpdateValueText()
	self:ClearFocus()
end

function Slider:UpdateEditWidth()
	local low = self.Low:GetWidth()
	local high = self.High:GetWidth()
	local prefix = self.Prefix:GetWidth()
	local suffix = self.Suffix:GetWidth()
	
	TestString:SetText(self.EditBox:GetText())
	local width = TestString:GetStringWidth()
	local maxWidth = self:GetWidth() - max(low, high) * 2
	local off = prefix + suffix + 6
	
	self.EditBG:SetWidth(max(min(width + off, maxWidth), 15))
	self.EditBox:SetPoint('TOP', self.EditBG, (prefix - suffix) / 2, 0)
	self.EditBox:SetWidth(min(width + 15, maxWidth - off))
end

function Slider:UpdateEditBackground(focusLost)
	local focus = GetMouseFocus()
	local hasFocus = (focus == self or focus == self.EditBox) or (self.EditBox:HasFocus() and not focusLost)
	
	if not hasFocus or self.valueText or self:IsDisabled() then
		self.EditBG:Hide()
	else
		self.EditBG:Show()
	end
end


--[[ Value ]]--

function Slider:SetValue(value, update)
	local minV, maxV = self:GetMinMaxValues()
	local value = self:GetRoundedValue(max(min(value, maxV), minV))
	
	if self.value ~= value then
		self.value = value
		self.__type.SetValue(self, value)
		self:UpdateValueText()
		
		self:FireCall('OnValueChanged', value)
		self:FireCall('OnInput', value)
		
		if update then
			self:Update()
		end
	end
end

function Slider:GetRoundedValue(value)
	local step = self.minStep or self.step
	return floor((value or 0) / step + 0.5) * step
end


--[[ Value Text ]]--

function Slider:SetValueText(text)
	self.valueText = text
	self:UpdateValueText()
	
	if text then
		self.EditBox:SetCursorPosition(0)
	end
end

function Slider:UpdateValueText()
	self.EditBox:SetText(self.valueText or self:GetRoundedValue(self.value))
end

function Slider:GetValueText()
	return self.valueText
end


--[[ Range ]]--

function Slider:SetRange(min, max)
	self:SetMinMaxValues(min, max)
	self:UpdateRangeText()
end

function Slider:SetRangeText(low, high)
	self.lowText, self.highText = low, high
	self:UpdateRangeText()
end

function Slider:UpdateRangeText()
	local min, max = self:GetMinMaxValues()
	
	self.High:SetText(self.highText or max)
	self.Low:SetText(self.lowText or min)
	self:UpdateEditWidth()
end

function Slider:GetRangeText()
	return self.lowText, self.highText
end


--[[ Step ]]--

function Slider:SetStep(step, minStep)
	self.step, self.minStep = step, minStep
	self:SetValueStep(step)
	self:UpdateValueText()
end

function Slider:GetStep()
	return self.step, self.minStep
end


--[[ Pattern ]]--

function Slider:SetPattern(pattern)
	local prefix, suffix = strmatch(pattern, '(.*)%%s(.*)')
	self.Prefix:SetText(prefix)
	self.Suffix:SetText(suffix)
	
	self.pattern = pattern
	self:UpdateEditWidth()
end

function Slider:GetPattern()
	return self.pattern
end


--[[ Label ]]--

function Slider:SetLabel(label)
	self.Label:SetText(label)
end

function Slider:GetLabel()
	return self.Label:GetText()
end


--[[ Font ]]--

function Slider:SetDisabled(disabled)
	if disabled then
		self.EditBox:ClearFocus()
		self:Disable()
	else
		self:Enable()
	end
	
	self.disabled = disabled
	self:UpdateFonts()
end

function Slider:IsDisabled()
	return self.disabled
end

function Slider:SetSmall(small)
	self.small = small
	self:UpdateFonts()
end

function Slider:IsSmall()
	return self.small
end

function Slider:UpdateFonts()
	local font
	if not self:IsDisabled() then
		font = 'GameFont%s'
	else
		font = 'GameFontDisable'
	end
	
	self.Label:SetFontObject(font:format('Normal') .. (self:IsSmall() and 'Small' or ''))
	
	font = font:format('Highlight') .. 'Small'
	self.EditBox:SetFontObject(font)
	self.High:SetFontObject(font)
	self.Low:SetFontObject(font)
end


--[[ Finish ]]--

Slider.GetRange = Slider.SetMinMaxValues
Slider.SetText = Slider.SetLabel
Slider.GetText = Slider.GetLabel
Slider.bottom = 7
Slider.right = 16
Slider.left = 14
Slider.top = 17
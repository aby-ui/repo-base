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

local Sushi = LibStub('Sushi-3.1')
local Slider = Sushi.Labeled:NewSushi('Slider', 2, 'Slider', 'OptionsSliderTemplate', true)
if not Slider then return end


--[[ Construct ]]--

function Slider:Construct()
	local f = self:Super(Slider):Construct()
	f:SetScript('OnValueChanged', f.OnValueChanged)
	f:SetScript('OnMouseWheel', f.OnMouseWheel)
	f:SetScript('OnMouseUp', f.OnMouseUp)
	f.Text:SetFontObject(f.NormalFont)
	f:SetObeyStepOnDrag(true)
	f:EnableMouseWheel(true)
	f.Label = f.Text
	return f
end

function Slider:New(parent, label, value, min,max, step)
	local f = self:Super(Slider):New(parent, label)
	f.Edit = Sushi.DarkEdit(f)
	f.Edit:SetPoint('TOP', f, 'BOTTOM', 0, 7)
	f.Edit:SetCall('OnInput', function(edit, value)
		if tonumber(value) then
			f:SetValue(value, true)
		else
			f.Edit:SetValue(f:GetValue())
		end
	end)

	f:SetRange(min or 1, max or 100)
	f:SetValue(value or 1)
	f:SetStep(step or 1)
	return f
end

function Slider:Reset()
	self:Super(Slider):Reset()
	self.Edit:Release()
	self:SetWidth(144)
end


--[[ Events ]]--

function Slider:OnMouseWheel(direction)
	self:SetValue(self:GetValue() + self:GetStep() * direction, true)
	self:FireCalls('OnUpdate')
end

function Slider:OnValueChanged(value, manual)
	self.Edit:SetValue(value)

	if manual then
		self:FireCalls('OnValue', value)
		self:FireCalls('OnInput', value)
	end
end

function Slider:OnMouseUp()
	self:FireCalls('OnUpdate')
end


--[[ API ]]--

function Slider:SetRange(min, max, minText, maxText)
	self:SetMinMaxValues(min, max)
	self.Low:SetText(minText or min)
	self.High:SetText(maxText or max)
end

function Slider:GetRange()
	local min, max = self:GetMinMaxValues()
	return min, max, self.Low:GetText(), self.High:GetText()
end

function Slider:SetEnabled(enabled)
	self:Super(Slider):SetEnabled(enabled)
	self.Edit:SetEnabled(enabled)
	self.High:SetFontObject(self.Edit:GetFontObject())
	self.Low:SetFontObject(self.Edit:GetFontObject())
end

function Slider:SetPattern(...)
	self.Edit:SetPattern(...)
end

function Slider:GetPattern()
	return self.Edit:GetPattern()
end


--[[ Proprieties ]]--

Slider.NormalFont = 'GameFontNormal'
Slider.DisabledFont = 'GameFontDisable'
Slider.SetStep = Slider.SetValueStep
Slider.GetStep = Slider.GetValueStep
Slider.SetText = Slider.SetLabel
Slider.GetText = Slider.GetLabel
Slider.bottom = 7
Slider.right = 16
Slider.left = 14
Slider.top = 17

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

local EditBox = MakeSushi(1, 'EditBox', 'EditBox', nil, 'InputBoxTemplate', SushiTipOwner)
if not EditBox then
	return
end

EditBox.SetValue = EditBox.SetText
EditBox.GetValue = EditBox.GetText
EditBox.bottom = 6
EditBox.right = 20
EditBox.left = 25
EditBox.top = 10


--[[ Builder ]]--

function EditBox:OnCreate()
	local Label = self:CreateFontString()
	Label:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', -7, -4)
	Label:SetJustifyH('Left')
	
	self:SetScript('OnEditFocusGained', self.OnEditFocusGained)
	self:SetScript('OnEscapePressed', self.OnEscapePressed)
	self:SetScript('OnEnterPressed', self.OnEnterPressed)
	self:SetAltArrowKeyMode(false)
	self:SetAutoFocus(false)
	self:SetHeight(35)
	self.Label = Label
	
	SushiTipOwner.OnCreate(self)
end

function EditBox:OnAcquire()
	SushiTipOwner.OnAcquire(self)
	self:SetWidth(150)
	self:UpdateFonts()
end

function EditBox:OnRelease()
	self.disabled, self.small = nil
	self:SetPassword(nil)
	self:SetNumeric(nil)
	self:SetLabel(nil)
	self:SetValue('')
	self:ClearFocus()
	
	SushiTipOwner.OnRelease(self)
end


--[[ Events ]]--

function EditBox:OnEditFocusGained()
	self.value = self:GetValue()
end

function EditBox:OnEnterPressed()
	local value = self:GetValue()
	self:FireCall('OnTextChanged', value)
	self:FireCall('OnInput', value)
	self:FireCall('OnUpdate')
	self:ClearFocus()
end

function EditBox:OnEscapePressed()
	self:SetValue(self.value or '')
	self:ClearFocus()
end


--[[ Label ]]--

function EditBox:SetLabel(label)
	self.Label:SetText(label)
end

function EditBox:GetLabel()
	return self.Label:GetText()
end


--[[ Font ]]--

function EditBox:SetDisabled(disabled)
	if disabled then
		self:ClearFocus()
	end
	
	self.disabled = disabled
	self:EnableMouse(not disabled)
	self:UpdateFonts()
end

function EditBox:IsDisabled()
	return self.disabled
end

function EditBox:SetSmall(small)
	self.small = small
	self:UpdateFonts()
end

function EditBox:IsSmall()
	return self.small
end

function EditBox:UpdateFonts()
	local font = 'GameFont'
	if not self:IsDisabled() then
		font = font .. '%s'
	else
		font = font .. 'Disable'
	end
	
	self.Label:SetFontObject(font:format('Normal') .. (self:IsSmall() and 'Small' or ''))
	self:SetFontObject(font:format('Highlight') .. 'Small')
end
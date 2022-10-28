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

local Editable = LibStub('Sushi-3.1').Labeled:NewSushi('Editable', 1)
if not Editable then return end


--[[ Construct ]]--

function Editable:Construct()
	local f = self:Super(Editable):Construct()
	f.Label = f:CreateFontString(nil, nil, self.LabelFont)
  f:SetScript('OnEditFocusLost', f.OnEditFocusLost)
  f:SetScript('OnEnterPressed', f.OnEnterPressed)
  f:SetFontObject(f.NormalFont)
  f:SetAltArrowKeyMode(false)
  f:SetAutoFocus(false)
  return f
end

function Editable:New(parent, label, value)
	local f = self:Super(Editable):New(parent, label)
	f:SetValue(value)
	return f
end

function Editable:Reset()
	self:Super(Editable):Reset()
	self:SetEnabled(true)
	self:SetPassword(nil)
	self:SetNumeric(nil)
	self:ClearFocus()
end


--[[ Events ]]--

function Editable:OnEditFocusLost()
	self:SetText(self:GetValue())
	self:HighlightText(0, 0)
end

function Editable:OnEnterPressed()
	self:SetValue(self:GetText())
	self:FireCalls('OnText', self:GetValue())
	self:FireCalls('OnInput', self:GetValue())
	self:FireCalls('OnUpdate')
	self:ClearFocus()
end


--[[ API ]]--

function Editable:SetEnabled(enabled)
	self:Super(Editable):SetEnabled(enabled)
	self:SetFontObject(self:IsEnabled() and self.NormalFont or self.DisabledFont)
end

function Editable:SetValue(value)
	self.value = value

	if not self:HasFocus() then
		self:SetText(self:GetValue())
		self:SetCursorPosition(0)
	end
end

function Editable:GetValue()
	return self.value
end


--[[ Proprieties ]]--

Editable.NormalFont = 'GameFontHighlightSmall'
Editable.DisabledFont = 'GameFontDisableSmall'
Editable.value = ''

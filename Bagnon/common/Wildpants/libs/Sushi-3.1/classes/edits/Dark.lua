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

local Dark = LibStub('Sushi-3.1').Editable:NewSushi('DarkEdit', 2, 'EditBox', 'InputBoxScriptTemplate')
if not Dark then return end


--[[ Construct ]]--

function Dark:Construct()
  local f = self:Super(Dark):Construct()
  local bg = CreateFrame('Frame', nil, f, BackdropTemplateMixin and 'BackdropTemplate')
  bg:SetBackdrop(f.Backdrop)
  bg:SetBackdropColor(0,0,0, 0.25)
  bg:SetBackdropBorderColor(0,0,0, 0.3)
  bg:SetFrameLevel(f:GetFrameLevel())
  bg:Hide()

  local left = f:CreateFontString(nil, nil, self.NormalFont)
  left:SetPoint('LEFT', bg, 3, 0)
  local right = f:CreateFontString(nil, nil, self.NormalFont)
  right:SetPoint('RIGHT', bg, -3, 0)

  f:SetHeight(18)
  f:SetJustifyH('CENTER')
  f:SetScript('OnTextChanged', f.OnTextChanged)
  f.Label:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 5, 0)
  f.Bg, f.Left, f.Right = bg, left, right
  return f
end

function Dark:New(parent, value, pattern)
	local f = self:Super(Dark):New(parent, nil, value)
	f:SetPattern(pattern or '%s')
	return f
end


--[[ API ]]--

function Dark:OnEnter()
  self:Super(Dark):OnEnter()
  self.Bg:SetShown(self:IsEnabled())
end

function Dark:OnLeave()
  self:Super(Dark):OnLeave()
  self.Bg:Hide()
end

function Dark:OnTextChanged()
  self.Ruler:SetFontObject(self:GetFontObject())
  self.Ruler:SetText(self:GetText())
  self:SetWidth(min(self.Ruler:GetStringWidth() + self.WidthOff, self.MaxWidth))
end

function Dark:SetFontObject(font)
	self:Super(Dark):SetFontObject(font)

  if self.Right then
    self.Right:SetFontObject(font)
    self.Left:SetFontObject(font)
  end
end

function Dark:SetPattern(pattern)
  local left, right = strmatch(pattern, '(.*)%%s(.*)')

  self.Left:SetText(left)
  self.Right:SetText(right)
  self.Bg:SetPoint('BOTTOMRIGHT', self.Right:GetWidth(), 0)
  self.Bg:SetPoint('TOPLEFT', -self.Left:GetWidth(), 0)
end

function Dark:GetPattern()
  return self.Left:GetText() .. '%s' .. self.Right:GetText()
end


--[[ Proprieties ]]--

Dark.Ruler = Dark.Ruler or UIParent:CreateFontString()
Dark.MaxWidth = 150
Dark.WidthOff = 10
Dark.Backdrop = {
	bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
	edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
	insets = {left = 2, right = 2, top = 2, bottom = 2},
	edgeSize = 11,
}

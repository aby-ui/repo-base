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

local Labeled = LibStub('Sushi-3.1').Tipped:NewSushi('Labeled', 1)
if not Labeled then return end


--[[ Construct ]]--

function Labeled:New(parent, label)
	local f = self:Super(Labeled):New(parent)
	f:SetLabel(label)
	return f
end

function Labeled:Reset()
	self:Super(Labeled):Reset()
	self:SetEnabled(true)
end


--[[ API ]]--

function Labeled:SetLabel(label)
	self.Label:SetText(label)
end

function Labeled:GetLabel()
	return self.Label:GetText()
end

function Labeled:SetEnabled(enabled)
	self:Super(Labeled):SetEnabled(enabled)
	self:UpdateFont()
end

function Labeled:SetSmall(small)
	self.small = small
	self:UpdateFont()
end

function Labeled:IsSmall()
	return self.small
end

function Labeled:UpdateFont()
  local font = self:IsEnabled() and self.LabelFont or self.LabelDisabledFont
  local small = self:IsSmall() and 'Small' or ''

  self.Label:SetFontObject(font .. small)
end


--[[ Proprieties ]]--

Labeled.LabelFont = 'GameFontNormal'
Labeled.LabelDisabledFont = 'GameFontDisable'

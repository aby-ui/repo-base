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

local Texted = LibStub('Sushi-3.1').Clickable:NewSushi('TextedClickable', 1)
if not Texted then return end


--[[ API ]]--

function Texted:New(parent, text)
  local b = self:Super(Texted):New(parent)
	b:SetText(text)
	return b
end

function Texted:Reset()
	self:Super(Texted):Reset()
	self:SetSmall(nil)
end

function Texted:SetText(text)
	self:GetFontString():SetText(text)
	self:SetWidth(max(self.MinWidth, self:GetTextWidth() + self.WidthOff))
end

function Texted:SetLabel(label)
  self:SetText(label)
end

function Texted:GetLabel()
  return self:GetText()
end

function Texted:SetSmall(small)
	local suffix = small and 'Small' or ''

	self:SetHighlightFontObject(self.HighlightFont .. suffix)
	self:SetDisabledFontObject(self.DisableFont .. suffix)
	self:SetNormalFontObject(self.NormalFont .. suffix)
end

function Texted:IsSmall()
	return self:GetNormalFontObject() == self.NormalFont
end


--[[ Proprieties ]]--

Texted.HighlightFont = 'GameFontHighlight'
Texted.DisableFont = 'GameFontDisable'
Texted.NormalFont = 'GameFontNormal'
Texted.MinWidth = 0

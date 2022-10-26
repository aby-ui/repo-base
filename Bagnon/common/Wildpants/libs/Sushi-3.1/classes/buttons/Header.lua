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

local Header = LibStub('Sushi-3.1').Clickable:NewSushi('Header', 1, 'Button')
if not Header then return end


--[[ Construct ]]--

function Header:Construct()
	local b = self:Super(Header):Construct()
	local string = b:CreateFontString()
	string:SetJustifyH('LEFT')
	string:SetPoint('TOPLEFT')

	local line = b:CreateTexture()
	line:SetColorTexture(1,1,1, .2)
	line:SetPoint('BOTTOMRIGHT')
	line:SetPoint('BOTTOMLEFT')
	line:SetHeight(1.2)

	b.Line = line
	b:SetFontString(string)
	return b
end

function Header:New(parent, text, font, underlined)
	local b = self:Super(Header):New(parent)
	b:SetUnderlined(underlined)
	b:SetNormalFontObject(font)
	b:SetText(text)
	b:UpdateWidth()

	if parent.SetCall then
		parent:SetCall('OnResize', function() b:UpdateWidth() end)
	end

	return b
end

function Header:OnEnter()
	self:Super(Header):OnEnter()
	self:GetFontString():SetText(self:GetText():gsub('|c(' .. strrep('%x', 8) .. ')', function(value)
		return '|c' .. value:gsub('(%x%x)', function(v) return format('%x', min(255, tonumber(v, 16) * self:GetHighlightFactor())) end)
	end))
end

function Header:OnLeave()
	self:Super(Header):OnLeave()
	self:GetFontString():SetText(self:GetText())
end


--[[ API ]]--

function Header:SetWidth(width)
	self.manual = true
	self:Super(Header):SetWidth(width)
	self:UpdateHeight()
end

function Header:SetText(text)
	self.text = text
	self:Super(Header):SetText(text)
	self:UpdateHeight()
end

function Header:GetText()
	return self.text
end

function Header:SetNormalFontObject(font)
	self:Super(Header):SetNormalFontObject(font or GameFontNormal)
	self:UpdateHeight()
end

function Header:SetUnderlined(enable)
	self.Line:SetShown(enable)
	self:UpdateHeight()
end

function Header:IsUnderlined()
	return self.Line:IsShown()
end

function Header:SetHighlightFactor(factor)
	self.highlight = factor
end

function Header:GetHighlightFactor()
	return self.highlight
end


--[[ Resize ]]--

function Header:UpdateWidth()
	if not self.manual and self:GetParent() then
		self:Super(Header):SetWidth(self:GetParent():GetWidth() - self.left - self.right)
		self:UpdateHeight()
	end
end

function Header:UpdateHeight()
	self:GetFontString():SetWidth(self:GetWidth())
	self:SetHeight(self:GetTextHeight() + (self:IsUnderlined() and 3 or 0))
end


--[[ Proprieties ]]--

Header.SetLabel = Header.SetText
Header.GetLabel = Header.GetText
Header.highlight = 1
Header.bottom = 5
Header.right = 12
Header.left = 12
Header.top = 5

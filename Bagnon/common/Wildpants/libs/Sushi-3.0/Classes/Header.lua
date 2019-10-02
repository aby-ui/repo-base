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

local CallHandler = SushiCallHandler
local Header = MakeSushi(4, 'Frame', 'Header', nil, nil, CallHandler)
if not Header then
	return
end


--[[ Events ]]--

function Header:OnCreate ()
	local Text = self:CreateFontString()
	Text:SetPoint('TOPLEFT')
	Text:SetJustifyH('LEFT')

	local Underline = self:CreateTexture()
	Underline:SetPoint('BOTTOMRIGHT')
	Underline:SetPoint('BOTTOMLEFT')
	Underline:SetColorTexture(1,1,1, .2)
	Underline:SetHeight(1.2)

	self:SetScript('OnSizeChanged', self.OnSizeChanged)
	self:SetScript('OnMouseDown', self.OnClick)
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
	self.Underline = Underline
	self.Text = Text
end

function Header:OnAcquire ()
	CallHandler.OnAcquire (self)
	self:SetCall('OnParentResize', self.OnParentResize)
	self:SetFont('GameFontNormal')
	self:SetHighlightFactor(1)
	self:SetUnderlined(nil)
	self:OnParentResize()
	self:SetText(nil)
end

function Header:OnSizeChanged ()
	self.Text:SetWidth(self:GetWidth())
	self:SetHeight(self.Text:GetHeight() + (self:IsUnderlined() and 3 or 0))
end

function Header:OnParentResize ()
	local parent = self:GetParent()
	if parent then
		self:SetWidth(parent:GetWidth() - 20)
	end
end

function Header:OnEnter ()
	self.Text:SetText(self:GetText():gsub('|c(' .. strrep('%x', 8) .. ')', function(value)
		return '|c' .. value:gsub('(%x%x)', function(v) return format('%x', min(255, tonumber(v, 16) * self:GetHighlightFactor())) end)
	end))
end

function Header:OnLeave ()
	self.Text:SetText(self:GetText())
end

function Header:OnClick ()
	self:FireCall('OnClick')
end


--[[ API ]]--

function Header:SetText (text)
	self.content = text
	self.Text:SetText(text)
	self:OnSizeChanged()
end

function Header:GetText ()
	return self.content
end

function Header:SetFont (font)
	self.Text:SetFontObject(font)
	self:OnSizeChanged()
end

function Header:GetFont ()
	return self.Text:GetFontObject()
end

function Header:SetUnderlined (enable)
	if enable then
		self.Underline:Show()
	else
		self.Underline:Hide()
	end
	self:OnSizeChanged()
end

function Header:IsUnderlined ()
	return self.Underline:IsShown()
end

function Header:SetHighlightFactor (factor)
	self.highlightFactor = factor
end

function Header:GetHighlightFactor ()
	return self.highlightFactor
end


--[[ Values ]]--

Header.SetLabel = Header.SetText
Header.GetLabel = Header.GetText
Header.bottom = 5
Header.right = 12
Header.left = 12
Header.top = 5

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

local Button = MakeSushi(3, 'Button', 'TextButton', nil, 'UIPanelButtonTemplate', SushiButtonBase)
if not Button then
	return
end


--[[ Events ]]--

function Button:OnRelease ()
	SushiButtonBase.OnRelease (self)
	self:SetSmall(nil)
	self:SetText(nil)
end


--[[ API ]]--

function Button:SetText (text)
	self:GetFontString():SetText(text)
	self:SetWidth(self:GetTextWidth() + 20)
end

function Button:SetSmall (small)
	if small then
		self:SetHighlightFontObject('GameFontHighlightSmall')
		self:SetDisabledFontObject('GameFontDisableSmall')
		self:SetNormalFontObject('GameFontNormalSmall')
	else
		self:SetHighlightFontObject('GameFontHighlight')
		self:SetDisabledFontObject('GameFontDisable')
		self:SetNormalFontObject('GameFontNormal')
	end
end

function Button:IsSmall ()
	return self:GetNormalFontObject() == 'GameFontNormalSmall'
end


--[[ Properties ]]--

SushiButton = Button
Button.SetLabel = Button.SetText
Button.GetLabel = Button.GetText
Button.bottom = 5
Button.right = 11
Button.left = 11
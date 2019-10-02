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

local Button = MakeSushi(1, 'Button', 'GrayButton', nil, nil, SushiButton)
if not Button then
	return
end


--[[ Events ]]--

function Button:OnCreate()
	local name = self:GetName()
	self.Left = _G[name..'Left']
	self.Middle = _G[name..'Middle']
	self.Right = _G[name..'Right']
	
	self:SetScript('OnMouseDown', self.OnMouseDown)
	self:SetScript('OnMouseUp', self.OnMouseUp)
	self:SetScript('OnDisable', nil)
	self:SetScript('OnEnable', nil)
	self:SetSmall(nil)
	self:OnMouseUp()
	
	SushiButton.OnCreate(self)
end

function Button:OnMouseUp()
	self.Left:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled')
	self.Middle:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled')
	self.Right:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled')
end

function Button:OnMouseDown()
	self.Left:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
	self.Middle:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
	self.Right:SetTexture('Interface/Buttons/UI-Panel-Button-Disabled-Down')
end


--[[ API ]]--

function Button:SetSmall(small)
	if small then
		self:SetHighlightFontObject('GameFontHighlightSmall')
		self:SetDisabledFontObject('GameFontDisableSmall')
		self:SetNormalFontObject('GameFontHighlightSmall')
	else
		self:SetHighlightFontObject('GameFontHighlight')
		self:SetDisabledFontObject('GameFontDisable')
		self:SetNormalFontObject('GameFontHighlight')
	end
end
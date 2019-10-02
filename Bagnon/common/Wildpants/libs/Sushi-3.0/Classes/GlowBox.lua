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

local Sides = {'BOTTOM', 'LEFT', 'TOP', 'RIGHT'}
local GlowBox = MakeSushi(3, 'Frame', 'GlowBox', nil, 'GlowBoxTemplate', SushiCallHandler)
if not GlowBox then
	return
end


--[[ Builder ]]--

function GlowBox:OnCreate()
	self:CreatePointers()
	
	local text = self:CreateFontString(nil, nil, 'GameFontHighlightLeft')
	text:SetPoint('TOPLEFT', 15, -15)
	text:SetWidth(200)
	text:SetSpacing(4)
	
	local close = CreateFrame('Button', nil, self, 'UIPanelCloseButton')
	close:SetPoint('TOPRIGHT', 6, 5)
	close:SetScript('OnClick', function()
		self:FireCall('OnClose')
		self:Hide()
	end)
	
	self:SetFrameStrata('DIALOG')
	self:SetSize(220, 100)
	self:EnableMouse(true)
	self.text = text
end

function GlowBox:OnAcquire()
	SushiCallHandler.OnAcquire(self)
	self:SetDirection('BOTTOM')
	self:SetText('')
end

function GlowBox:CreatePointers()
	for i, side in ipairs(Sides) do
		local direction = ceil(i / 2) % 2 * 2 - 1
		local off = direction * 3
		local y = (i + 1) % 2
		local x = i % 2
		
		local pointer = CreateFrame('Frame', '$parent' .. side, self, 'GlowBoxArrowTemplate')
		pointer:SetPoint(Sides[i + direction * 2], self, side, x * off, y * off)
		pointer:SetSize(21 + 32 * x, 21 + 32 * y)
		
		self.RotateTexture(pointer, 'Arrow', i)
		self.RotateTexture(pointer, 'Glow', i)
	end
end

function GlowBox:RotateTexture(texture, i)
	texture = _G[self:GetName() .. texture]
	texture:SetAllPoints()
	
	SetClampedTextureRotation(texture, (i-1) * 90)
end


--[[ Methods ]]--

function GlowBox:SetDirection(direction)
	for _, side in pairs(Sides) do
		_G[self:GetName() .. side]:SetShown(side  == direction)
	end
	
	self.direction = direction
end

function GlowBox:GetDirection()
	return self.direction
end

function GlowBox:SetText(text)
	self.text:SetText(text)
	self:SetHeight(self.text:GetHeight() + 30)
end

function GlowBox:GetText()
	self.text:GetText()
end
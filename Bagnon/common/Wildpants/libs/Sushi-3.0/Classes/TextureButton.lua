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

local Base = SushiButtonBase
local Button = MakeSushi(1, 'Button', 'TextureButton', nil, nil, Base)
if not Button then
	return
end

Button.bottom = 10
Button.right = 10
Button.left = 10
Button.top = 10


--[[ Events ]]--

function Button:OnCreate()
	local Normal = self:CreateTexture()
	Normal:SetNonBlocking(true)
	Normal:SetAllPoints()
	self:SetNormalTexture(Normal)
	
	local Pushed = self:CreateTexture()
	Pushed:SetPoint('BOTTOMRIGHT', 2, -2)
	Pushed:SetPoint('TOPLEFT', 2, -2)
	Pushed:SetNonBlocking(true)
	self:SetPushedTexture(Pushed)
	
	local Highlight = self:CreateTexture()
	Highlight:SetTexture('Interface\\BUTTONS\\UI-Common-MouseHilight')
	Highlight:SetTexCoord(0.15, 0.85, 0.15, 0.85)
	Highlight:SetBlendMode('ADD')
	self:SetHighlightTexture(Highlight)
	
	Base.OnCreate(self)
end

function Button:OnRelease()
	Base.OnRelease(self)
	self:SetTexture(nil)
end


--[[ API ]]--

function Button:SetTexture(file)
	local kind = type(file)
	local isTexture = kind == 'string' and file
	local Highlight = self:GetHighlightTexture()
	
	if isTexture then
		Highlight:SetPoint('BOTTOMRIGHT', 10, -10)
		Highlight:SetPoint('TOPLEFT', -10, 10)
	else
		Highlight:SetPoint('BOTTOMRIGHT')
		Highlight:SetPoint('TOPLEFT')
	end
	
	self:SetBackdrop(not isTexture and file or nil)
	self:GetNormalTexture():SetTexture(file)
	self:GetPushedTexture():SetTexture(file)
end

function Button:GetTexture()
	return self:GetBackdrop() or self:GetNormalTexture():GetTexture() or nil
end
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

local Dropdown = SushiDropdown
local TexDrop = MakeSushi(2, 'Frame', 'TextureDropdown', nil, nil, Dropdown)
if not TexDrop then
	return
end

local DropList = TexDrop.List or SushiGroup()
DropList:SetParent(UIParent)
DropList:SetFrameStrata('FULLSCREEN_DIALOG')
DropList:SetOrientation('HORIZONTAL')
DropList:SetResizing('VERTICAL')
DropList:SetToplevel(1)
DropList:Hide()

local BG = DropList.BG or CreateFrame('Frame', nil, DropList)
BG:SetFrameLevel(DropList:GetFrameLevel())
BG:SetPoint('BOTTOMLEFT', -11, -11)
BG:SetPoint('TOPRIGHT', 11, 11)
BG:SetBackdrop({
	bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background-Dark',
	edgeFile = 'Interface\\DialogFrame\\UI-DialogBox-Border',
	insets = {left = 11, right = 11, top = 11, bottom = 9},
	edgeSize = 32, tileSize = 32, tile = true
})

DropList:SetContent(function()
	local self = DropList.parent
	local width, height = self:GetButtonSize()

	for value, image, tip in self:IterateLines() do
		local button = DropList:Create('TextureButton')
		button:SetCall('OnUpdate', nil)
		button:SetSize(width, height)
		button:SetTexture(image)
		button:SetTip(tip)

		button:SetCall('OnInput', function()
			self:FireCall('OnLineSelected', value)
			self:FireCall('OnSelection', value)
			self:FireCall('OnInput', value)
			self:FireCall('OnUpdate')
			CloseDropDownMenus()
		end)
	end
end)


--[[ Constructor ]]--

function TexDrop:OnCreate()
	local name = self:GetName()
	Dropdown.OnCreate (self)

	-- Left
	local TopLeft = _G[name .. 'Left']
	TopLeft:SetTexCoord(0, 0.1953125, 0, 0.4)
	TopLeft:SetPoint('TOPLEFT', 0, 13)
	TopLeft:SetHeight(19.2)

	local BotLeft = self:CreateTexture()
	BotLeft:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	BotLeft:SetHeight(15) BotLeft:SetWidth(25)
	BotLeft:SetTexCoord(0, 0.1953125, 0.5, 1)
	BotLeft:SetPoint('BOTTOMLEFT')

	local Left = self:CreateTexture()
	Left:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Left:SetTexCoord(0, 0.1953125, 0.5, 0.5)
	Left:SetPoint('TOP', TopLeft, 'BOTTOM')
	Left:SetPoint('BOTTOM', BotLeft, 'TOP')
	Left:SetWidth(25)

	-- Right
	local TopRight = _G[name .. 'Right']
	TopRight:SetTexCoord(0.8046875, 1, 0, 0.4)
	TopRight:SetPoint('TOPRIGHT', 0, 13)
	TopRight:SetHeight(19.2)

	local BotRight = self:CreateLabelTexture()
	BotRight:SetHeight(15) BotRight:SetWidth(25)
	BotRight:SetTexCoord(0.8046875, 1, 0.5, 1)
	BotRight:SetPoint('BOTTOMRIGHT')

	local Right = self:CreateLabelTexture()
	Right:SetTexCoord(0.8046875, 1, 0.5, 0.5)
	Right:SetPoint('TOP', TopRight, 'BOTTOM')
	Right:SetPoint('BOTTOM', BotRight, 'TOP')
	Right:SetWidth(25)

	-- Middle
	local TopMiddle = _G[name .. 'Middle']
	TopMiddle:SetTexCoord(0.1953125, 0.8046875, 0, 0.4)
	TopMiddle:SetHeight(19.2)

	local BotMiddle = self:CreateLabelTexture()
	BotMiddle:SetTexCoord(0.1953125, 0.8046875, 0.5, 1)
	BotMiddle:SetPoint('RIGHT', BotRight, 'LEFT')
	BotMiddle:SetPoint('LEFT', BotLeft, 'RIGHT')
	BotMiddle:SetHeight(15)

	local Middle = self:CreateTexture()
	Middle:SetTexture('Interface\\FrameGeneral\\UI-Background-Marble')
	Middle:SetPoint('BOTTOM', BotMiddle, 'TOP', 0, -3)
	Middle:SetPoint('TOP', TopMiddle, 'BOTTOM', 0, 1)
	Middle:SetPoint('RIGHT', Right, 'LEFT', 4, 0)
	Middle:SetPoint('LEFT', Left, 'RIGHT', -2, 0)
	Middle:SetHorizTile(true)
	Middle:SetVertTile(true)

	-- Ohter
	self.Button:ClearAllPoints()
	self.Button:SetPoint('TOPRIGHT', -16, 0)
	self.Button:SetScript('OnClick', function() self:OnClick() end)

	self.Display = SushiTextureButton(self)
	self.Display:SetPoint('BOTTOMRIGHT', Middle, -15, 5)
	self.Display:SetPoint('TOPLEFT', Middle, 15, -5)
	self.Display:EnableMouse(false)
end

function TexDrop:CreateLabelTexture()
	local t = self:CreateTexture()
	t:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	return t
end

function TexDrop:OnAcquire()
	Dropdown.OnAcquire(self)
	self:SetSize(120, 70)
	self:UpdateFonts()
end


--[[ Other ]]--

function TexDrop:OnClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	DropList:ClearAllPoints()

	if not DropList:IsShown() or DropList.parent ~= self then
		CloseDropDownMenus()

		DropList.parent = self
		DropList:SetWidth(min(self:NumLines(), 3) * (self:GetButtonSize() + 20))
		DropList:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 16, -4)
		DropList:Show()
	else
		DropList:Hide()
	end
end

function TexDrop:SetValue(value)
	self.Display:SetTexture(self.linesName[value])
	self.selectedValue = value
end

function TexDrop:GetButtonSize()
	local width, height = self:GetSize()
	return width - 57, height - 7
end


--[[ Hooks ]]

local hide = function()
	DropList:Hide()
end

hooksecurefunc('ToggleDropDownMenu', hide)
hooksecurefunc('CloseDropDownMenus', hide)
SushiTextureDrop = TexDrop
TexDrop.List = DropList
DropList.BG = BG

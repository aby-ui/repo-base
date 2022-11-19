--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local format = _G.format
local pairs = _G.pairs
local tonumber = _G.tonumber
local tostring = _G.tostring
local wipe = _G.wipe
--GLOBALS>

local mod = addon:NewModule('ChangeHighlight', 'ABEvent-1.0')
mod.uiName = L['Highlight changes']
mod.uiDesc = L['Highlight what changes in bags with a little sparkle.']

local states = {}
local glows = {}
local knownContainers = {}
local knownButtons = {}

local glowClass, glowProto = addon:NewClass("ChangeHighlightGlow", "Frame")
local glowPool = addon:CreatePool(glowClass)

function mod:OnEnable()
	self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
	self:RegisterMessage('AdiBags_PreContentUpdate', 'PreContentUpdate')
end

function mod:OnDisable()
	for _, glow in pairs(glows) do
		glowPool:Release(glow)
	end
	wipe(states)
end

function mod:PreContentUpdate(event, container, _, removed)
	if knownContainers[container] == nil then
		knownContainers[container] = false
	elseif knownContainers[container] == false then
		knownContainers[container] = true
	end
	for slotId in pairs(removed) do
		local button = container.buttons[slotId]
		if button and glows[button] then
			glowPool:Release(glows[button])
		end
	end
end

local function Button_OnHide(button)
	mod:HideGlow(button)
end

function mod:UpdateButton(event, button)
	if not knownButtons[button] then
		button:HookScript('OnHide', Button_OnHide)
		knownButtons[button] = true
	end
	local state = format('%s:%d:%s',
		tostring(button.IconTexture:GetTexture() or "nil"),
		tonumber(button.Count:GetText()) or 1,
		tostring(button.Stock:GetText() or "-")
	)
	if states[button] == state then
		return
	end
	states[button] = state
	if not knownContainers[button.container] then
		return
	end
	self:ShowGlow(button)
end

function mod:ShowGlow(button)
	if not glows[button] and button.hasItem then
		glowPool:Acquire(button)
	end
end

function mod:HideGlow(button)
	if glows[button] then
		glowPool:Release(glows[button])
	end
end

function glowProto:OnCreate()
	self:Hide()

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:SetSize(addon.ITEM_SIZE, addon.ITEM_SIZE)

	local tex = self:CreateTexture("OVERLAY")
	tex:SetTexture([[Interface\Cooldown\star4]])
	tex:SetBlendMode("ADD")
	tex:SetAllPoints(self)
	self.Texture = tex

	local group = self:CreateAnimationGroup()
	group:SetScript('OnFinished', function()
		mod:HideGlow(self.button)
	end)
	self.Group = group

	local rotation = group:CreateAnimation("Rotation")
	rotation:SetOrder(1)
	rotation:SetDuration(0.5)
	rotation:SetDegrees(90)
	rotation:SetOrigin("CENTER", 0, 0)

	local scale = group:CreateAnimation("Scale")
	scale:SetOrder(1)
	scale:SetDuration(0.5)
	scale:SetScale(3, 3)
	scale:SetOrigin("CENTER", 0, 0)

	local alpha = group:CreateAnimation("Alpha")
	alpha:SetOrder(1)
	alpha:SetDuration(0.5)
	alpha:SetFromAlpha(1)
	alpha:SetToAlpha(0)
end

function glowProto:OnAcquire(button)
	self.button = button
	glows[button] = self
	self:SetParent(button)
	self:SetPoint("CENTER")
	self:SetFrameLevel(button:GetFrameLevel()+15)
	self:Show()
end

function glowProto:OnRelease()
	glows[self.button] = nil
	self.button = nil
end

function glowProto:OnShow()
	if not self.Group:IsPlaying() then
		self.Group:Play()
	end
end

function glowProto:OnHide()
	if self.Group:IsPlaying() then
		self.Group:Stop()
	end
end

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
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
--GLOBALS>

--------------------------------------------------------------------------------
-- Basic anchor
--------------------------------------------------------------------------------

local anchorClass, anchorProto, anchorParentProto = addon:NewClass("Anchor", "Button", "ABEvent-1.0")

function addon:CreateAnchorWidget(...) return anchorClass:Create(...) end

local function Corner_OnUpdate(self)
	local x, y = self.anchor:GetCenter()
	if x ~= self.anchorX or y ~= self.anchorY then
		self.anchorX, self.anchorY = x, y
		local point = self.anchor:GetPosition()
		if point ~= self:GetPoint() then
			self:ClearAllPoints()
			self:SetPoint(point, self.anchor.target, 0, 0)
		end
	end
end

function anchorProto:OnCreate(parent, name, label, target)
	self:SetParent(parent or UIParent)
	target = target or self

	self.name = name
	self.label = label
	self.target = target
	self:EnableMouse(true)
	self:SetScript('OnMouseDown', self.StartMoving)
	self:SetScript('OnMouseUp', self.StopMoving)
	self:SetScript('OnHide', self.StopMoving)

	local corner = CreateFrame("Frame", nil, self, "BackdropTemplate")
	corner:SetFrameStrata("TOOLTIP")
	corner:SetBackdrop({ bgFile = [[Interface\Buttons\WHITE8X8]], tile = true, tileSize = 8 })
	corner:SetBackdropColor(1, 1, 0.5, 0.8)
	corner:SetBackdropBorderColor(0, 0, 0, 0)
	corner:SetSize(16, 16)
	corner:Hide()
	corner:SetScript('OnUpdate', Corner_OnUpdate)
	corner.anchor = self
	self.corner = corner
end

function anchorProto:GetPosition()
	local target = self.target
	local scale = target:GetScale()
	local w, h = UIParent:GetWidth(), UIParent:GetHeight()

	local x, y = target:GetCenter()
	x, y = x * scale, y * scale

	local vPos, hPos
	if x > w/2 then
		hPos, x = "RIGHT", target:GetRight()*scale - w
	else
		hPos, x = "LEFT", target:GetLeft()*scale
	end
	if y > h/2 then
		vPos, y = "TOP", target:GetTop()*scale - h
	else
		vPos, y = "BOTTOM", target:GetBottom()*scale
	end

	return vPos .. hPos, x, y
end

function anchorProto:ApplySettings()
	local db = addon.db.profile.positions[self.name]
	if db then
		local target = self.target
		local scale = target:GetScale()
		target:ClearAllPoints()
		target:SetPoint(db.point, db.xOffset / scale, db.yOffset / scale)
	end
end

function anchorProto:SaveSettings()
	local db = addon.db.profile.positions[self.name]
	db.point, db.xOffset, db.yOffset = self:GetPosition()
end

function anchorProto:StartMoving(button)
	if self.moving or button ~= "LeftButton" then return end
	self.moving = true
	local target = self.target
	if not target:IsMovable() then
		self.toggleMovable = true
		target:SetMovable(true)
	end
	if target == self then
		anchorParentProto.StartMoving(self)
	else
		target:StartMoving()
	end
	if not addon.db.profile.hideAnchor then
		self.corner:Show()
	end
	if self.OnMovingStarted then
		self:OnMovingStarted()
	end
end

function anchorProto:StopMoving()
	if not self.moving then return end
	self.moving = nil
	local target = self.target
	if self.toggleMovable then
		self.toggleMovable = nil
		target:SetMovable(false)
	end
	self.corner:Hide()
	if target == self then
		anchorParentProto.StopMovingOrSizing(self)
	else
		target:StopMovingOrSizing()
	end
	self:SaveSettings()
	if self.OnMovingStopped then
		self:OnMovingStopped()
	end
end

--------------------------------------------------------------------------------
-- Bag anchor
--------------------------------------------------------------------------------

local bagAnchorClass, bagAnchorProto, bagAnchorParentProto = addon:NewClass("BagAnchor", "Anchor")

function bagAnchorProto:OnCreate(parent, name, label)
	bagAnchorParentProto.OnCreate(self, parent, name, label, parent)

	self:RegisterForClicks("RightButtonUp")
	self:SetScript('OnShow', self.UpdateOperatingMode)
	self:SetScript('OnClick', self.OnClick)
	addon.SetupTooltip(self, self.OnTooltipUpdate, "ANCHOR_TOPRIGHT", 0, 8)

	self:RegisterMessage('AdiBags_ConfigChanged')

	self:Show()
end

function bagAnchorProto:UpdateOperatingMode()
	if addon.db.profile.positionMode == "manual" then
		self:SetScript('OnMouseDown', self.StartMoving)
		self:SetScript('OnMouseUp', self.StopMoving)
		self:SetScript('OnHide', self.StopMoving)
	else
		self:StopMoving()
		self:SetScript('OnMouseDown', nil)
		self:SetScript('OnMouseUp', nil)
		self:SetScript('OnHide', nil)
	end
end

function bagAnchorProto:AdiBags_ConfigChanged(_, name)
	if name == "positionMode" then
		self:UpdateOperatingMode()
	end
end

function bagAnchorProto:OnClick(mouseButton)
	if mouseButton == "RightButton" then
		if IsAltKeyDown() then
			if addon.db.profile.positionMode == "anchored" then
				addon.db.profile.positionMode = "manual"
			else
				addon.db.profile.positionMode = "anchored"
			end
			addon:SendMessage('AdiBags_ConfigChanged', 'positionMode')
		elseif addon.db.profile.positionMode == "anchored" then
			addon:ToggleAnchor()
		end
	end
end

function bagAnchorProto:OnTooltipUpdate(tooltip)
	tooltip:AddLine(self.label, 1, 1, 1)
	if addon.db.profile.positionMode == "manual" then
		tooltip:AddLine(L['Drag to move this bag.'])
		tooltip:AddLine(L['Alt-right-click to switch to anchored placement.'])
	else
		tooltip:AddLine(L['Right-click to (un)lock the bag anchor.'])
		tooltip:AddLine(L['Alt-right-click to switch to manual placement.'])
	end
end

function addon:CreateBagAnchorWidget(...) return bagAnchorClass:Create(...) end

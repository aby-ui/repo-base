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
local pairs = _G.pairs
local type = _G.type
local UIParent = _G.UIParent
local wipe = _G.wipe
--GLOBALS>

function addon:CreateBagAnchor()
	local anchor = self:CreateAnchorWidget(UIParent, "anchor", L["AdiBags Anchor"])
	Mixin(anchor, BackdropTemplateMixin)
	anchor:SetSize(80, 80)
	anchor:SetFrameStrata("TOOLTIP")
	anchor:SetBackdrop({ bgFile = [[Interface\Tooltips\UI-Tooltip-Background]] })
	anchor:SetBackdropColor(0, 1, 0, 1)
	anchor:SetBackdropBorderColor(0, 0, 0, 0)
	anchor:EnableMouse(true)
	anchor:SetClampedToScreen(true)
	anchor:SetMovable(true)
	anchor.OnMovingStopped = function() addon:LayoutBags() end
	anchor:SetScript('OnMouseDown', anchor.StartMoving)
	anchor:SetScript('OnMouseUp', anchor.StopMoving)
	anchor:Hide()

	local text = anchor:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	text:SetAllPoints(anchor)
	text:SetText(L["AdiBags Anchor"])
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	text:SetShadowColor(0,0,0,1)
	text:SetShadowOffset(1, -1)
	anchor.text = text

	self.anchor = anchor
end

local function AnchoredBagLayout(self)
	self.anchor:ApplySettings()
	self:Debug("Anchor Bag Layout")

	local nextBag, data, firstIndex = self:IterateBags(true)
	local index, bag = nextBag(data, firstIndex)
	if not bag then return end

	local anchor = self.anchor
	local anchorPoint = anchor:GetPosition()

	local frame = bag:GetFrame()
	frame:ClearAllPoints()
	self:Debug('AnchoredBagLayout', anchorPoint)
	frame:SetPoint(anchorPoint, anchor, anchorPoint, 0, 0)

	local lastFrame = frame
	index, bag = nextBag(data, index)
	if not bag then return end

	local vPart = anchorPoint:match("TOP") or anchorPoint:match("BOTTOM") or ""
	local hFrom, hTo, x = "LEFT", "RIGHT", 10
	if anchorPoint:match("RIGHT") then
		hFrom, hTo, x = "RIGHT", "LEFT", -10
	end
	local fromPoint = vPart..hFrom
	local toPoint = vPart..hTo

	while bag do
		local frame = bag:GetFrame()
		frame:ClearAllPoints()
		frame:SetPoint(fromPoint, lastFrame, toPoint, x / frame:GetScale(), 0)
		lastFrame, index, bag = frame, nextBag(data, index)
	end
end

local function ManualBagLayout(self)
	for index, bag in self:IterateBags(true) do
		bag:GetFrame().Anchor:ApplySettings()
	end
end

function addon:LayoutBags()
	local scale = self.db.profile.scale
	for index, bag in self:IterateBags() do
		if bag:HasFrame() then
			bag:GetFrame():SetScale(scale)
		end
	end
	if self.db.profile.positionMode == 'anchored' then
		AnchoredBagLayout(self)
	else
		ManualBagLayout(self)
	end
	self:SendMessage('AdiBags_ForceFullLayout')
end

function addon:ToggleAnchor()
	if self.db.profile.positionMode == 'anchored' and not self.anchor:IsShown() then
		self.anchor:Show()
	else
		self.anchor:Hide()
	end
end

function addon:UpdatePositionMode()
	if self.db.profile.positionMode ~= 'anchored' then
		self.anchor:Hide()
	end
	self:LayoutBags()
end

local function copytable(dst, src)
	wipe(dst)
	for k, v in pairs(src) do
		if type(v) == "table" then
			if type(dst[k]) ~= "table" then
				dst[k] = {}
			end
			copytable(dst[k], v)
		else
			dst[k] = v
		end
	end
end

function addon:ResetBagPositions()
	self.db.profile.scale = self.DEFAULT_SETTINGS.profile.scale
	copytable(self.db.profile.positions, self.DEFAULT_SETTINGS.profile.positions)
	self:LayoutBags()
end

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
local safecall = addon.safecall

--<GLOBALS
local _G = _G
local assert = _G.assert
local ipairs = _G.ipairs
local max = _G.max
local pairs = _G.pairs
local tinsert = _G.tinsert
local tsort = _G.table.sort
local type = _G.type
local unpack = _G.unpack
--GLOBALS>

--------------------------------------------------------------------------------
-- Abstract layered region
--------------------------------------------------------------------------------

local layeredRegionClass, layeredRegionProto = addon:NewClass("LayeredRegion", "Frame")

function layeredRegionProto:OnCreate(parent)
	if parent then
		self:SetParent(parent)
	end

	self:SetWidth(0.1)
	self:SetHeight(0.1)
	self.widgets = {}

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
end

function layeredRegionProto:SetContainer(container)
	self.container = container
end

function layeredRegionProto:OnShow()
	if self.container then
		self.container:UpdateVisibility()
	else
		self:RequestLayout()
	end
end
layeredRegionProto.OnHide = layeredRegionProto.OnShow

function layeredRegionProto:AddWidget(widget, ...)
	self:Debug('Adding widget', widget, ...)

	local data = { widget = widget }
	tinsert(self.widgets, data)
	safecall(self, "OnWidgetAdded", data, ...)
	widget:SetFrameLevel(self:GetFrameLevel()+1)

	if type(widget.SetContainer) == "function" and type(widget.Layout) == "function" then
		data.layered = true
		widget:SetContainer(self)
	else
		data.width = widget:GetWidth()
		data.height = widget:GetHeight()

		local resize_callback = function()
			local width, height = widget:GetWidth(), widget:GetHeight()
			if width and height and (data.width ~= width or data.height ~= height) then
				data.width, data.height = width, height
				self:RequestLayout()
			end
		end

		local visibility_callback = function()
			self:UpdateVisibility()
			if widget:IsShown() then
				self:RequestLayout()
			end
		end

		widget:HookScript('OnShow', visibility_callback)
		widget:HookScript('OnHide', visibility_callback)
		widget:HookScript('OnSizeChanged', resize_callback)
	end

	self:UpdateVisibility()
end

function layeredRegionProto:Layout()
	local wasDirty = self.dirtyLayout
	self.dirtyLayout = nil
	for i, data in pairs(self.widgets) do
		if data.layered then
			data.widget:Layout()
		end
	end
	self:SetScript('OnUpdate', nil)
	if self.dirtyLayout or wasDirty then
		self.dirtyLayout = nil
		safecall(self, "OnLayout")
	end
end

function layeredRegionProto:RequestLayout()
	self.dirtyLayout = true
	if self.container then
		self.container:RequestLayout()
	else
		self:SetScript('OnUpdate', self.Layout)
	end
end

-- Default UpdateVisibility does nothing more than RequestLayout
layeredRegionProto.UpdateVisibility = layeredRegionProto.RequestLayout

--------------------------------------------------------------------------------
-- Simple layered region
--------------------------------------------------------------------------------

local simpleLayeredRegionClass, simpleLayeredRegionProto = addon:NewClass("SimpleLayeredRegion", "LayeredRegion")

local DIRECTIONS = {
	UP    = {  0,  1, 1, 0 },
	DOWN  = {  0, -1, 1, 0 },
	LEFT  = { -1,  0, 0, 1 },
	RIGHT = {  1,  0, 0, 1 },
}

function simpleLayeredRegionProto:OnCreate(parent, anchorPoint, direction, spacing)
	layeredRegionProto.OnCreate(self, parent)
	self:Show()
	self:SetAnchorPoint(anchorPoint)
	self:SetDirection(direction)
	self:SetSpacing(spacing)
end

function simpleLayeredRegionProto:SetDirection(direction)
	if self.direction ~= direction then
		local dirData = direction and DIRECTIONS[direction]
		assert(dirData, "Invalid direction for SimpleLayeredRegion: "..direction)
		self.direction = direction
		self.dx, self.dy, self.sx, self.sy = unpack(dirData)
		self:RequestLayout()
	end
end

function simpleLayeredRegionProto:SetAnchorPoint(anchorPoint)
	if self.anchorPoint ~= anchorPoint then
		self.anchorPoint = anchorPoint
		self:RequestLayout()
	end
end

function simpleLayeredRegionProto:SetSpacing(spacing)
	if self.spacing ~= spacing then
		self.spacing = spacing or 0
		self:RequestLayout()
	end
end

local function CompareWidgets(a, b)
	return a.order > b.order
end

function simpleLayeredRegionProto:OnWidgetAdded(data, order, size, xOffset, yOffset)
	data.order = order or 0
	data.size = size or nil
	data.xOffset = xOffset or 0
	data.yOffset = yOffset or 0
	tsort(self.widgets, CompareWidgets)
end

function simpleLayeredRegionProto:UpdateVisibility()
	local num = 0
	for index, data in ipairs(self.widgets) do
		if data.widget:IsShown() then
			num = num + 1
		end
	end
	if num > 0 and not self:IsShown() then
		self:Show()
	elseif num == 0 and self:IsShown() then
		self:Hide()
	else
		self:RequestLayout()
	end
end

function simpleLayeredRegionProto:OnLayout()
	local dx, dy, sx, sy = self.dx, self.dy, self.sx, self.sy
	local anchorPoint, spacing = self.anchorPoint, self.spacing
	local x, y, width, height = 0, 0, 0.1, 0.1
	local num = 0
	for index, data in ipairs(self.widgets) do
		if data.widget:IsShown() then
			local widget = data.widget
			widget:ClearAllPoints()
			if num > 0 then
				x = x + dx * spacing
				y = y + dy * spacing
			end
			widget:SetPoint(anchorPoint, self, x + data.xOffset, y + data.yOffset)
			local w, h = widget:GetWidth(), widget:GetHeight()
			x = x + dx * (data.size or w)
			y = y + dy * (data.size or h)
			width = max(width, x * dx, w * sx)
			height = max(height, y * dy, h * sy)
			num = num + 1
		end
	end
	self:SetSize(width, height)
end

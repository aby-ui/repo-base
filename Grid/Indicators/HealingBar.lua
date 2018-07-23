--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
----------------------------------------------------------------------]]

local _, Grid = ...
local GridFrame = Grid:GetModule("GridFrame")
local Media = LibStub("LibSharedMedia-3.0")
local L = Grid.L

GridFrame:RegisterIndicator("healingBar", L["Healing Bar"],
	-- New
	function(frame)
		local bar = CreateFrame("StatusBar", nil, frame)
		bar:Hide()

		bar:SetStatusBarTexture("Interface\\Addons\\Grid\\gradient32x32")
		bar.texture = bar:GetStatusBarTexture()

		return bar
	end,

	-- Reset
	function(self)
		if self.__owner.unit then
			--print("Reset", self.__id, self.__owner.unit)
		end

		local profile = GridFrame.db.profile
		local texture = Media:Fetch("statusbar", profile.texture) or "Interface\\Addons\\Grid\\gradient32x32"

		local frame = self.__owner
		self:SetAllPoints(frame.indicators.bar)
	--	self:SetPoint("BOTTOMLEFT", frame.indicators.bar.texture, "TOPLEFT")
	--	self:SetPoint("BOTTOMRIGHT", frame.indicators.bar.texture, "TOPRIGHT")

		local level, sublevel = self.texture:GetDrawLayer()
		frame.indicators.bar.texture:SetDrawLayer(level, sublevel + 2)

		self:SetAlpha(profile.healingBar_intensity)
		self:SetOrientation(profile.orientation)
		-- TODO: does changing orientation reset the value?

		local r, g, b = self:GetStatusBarColor()
		self:SetStatusBarTexture(texture)
		self.texture:SetHorizTile(false)
		self.texture:SetVertTile(false)
		self:SetStatusBarColor(r, g, b)
	end,

	-- SetStatus
	function(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
		if not value or not maxValue or value == 0 or maxValue == 0 then
			return self:Hide()
		end
		--print("SetStatus", self.__id, self.__owner.unit, value, maxValue, format("%0.2f%%", value / maxValue * 100))

		local profile = GridFrame.db.profile
		local frame = self.__owner

		self:SetMinMaxValues(0, maxValue)
		self:SetValue(value)

		local perc = value / maxValue
		local coord = (perc > 0 and perc <= 1) and perc or 1
		if profile.orientation == "VERTICAL" then
			self.texture:SetTexCoord(0, 1, 1 - coord, 1)
		else
			self.texture:SetTexCoord(0, coord, 0, 1)
		end

		if profile.healingBar_useStatusColor then
			if profile.invertBarColor then
				self:SetStatusBarColor(color.r, color.g, color.b)
			else
				local mu = profile.healingBar_intensity
				self:SetStatusBarColor(color.r * mu, color.g * mu, color.b * mu)
			end
		else
			local r, g, b = frame.indicators.bar:GetStatusBarColor()
			if profile.invertBarColor then
				self:SetStatusBarColor(r, g, b)
			else
				local mu = profile.healingBar_intensity
				self:SetStatusBarColor(r * mu, g * mu, b * mu)
			end
		end

		self:Show()
	end,

	-- ClearStatus
	function(self)
		local profile = GridFrame.db.profile

		self:Hide()
		self:SetValue(0)

		if profile.healingBar_useStatusColor then
			self:SetStatusBarColor(0, 1, 0, 0.5)
		end
	end
)

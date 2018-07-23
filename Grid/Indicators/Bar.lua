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

local function SetBarColor(bar, r, g, b, invert)
    if not r then return end
	--print("SetBarColor", invert)
	if invert then
		bar:SetStatusBarColor(r, g, b, 1)
		bar.bg:SetVertexColor(r * 0.2, g * 0.2, b * 0.2, 1)
	else
		bar:SetStatusBarColor(r * 0.2, g * 0.2, b * 0.2, 1)
		bar.bg:SetVertexColor(r, g, b, 1)
	end

	local profile = GridFrame.db.profile
	if not profile.healingBar_useStatusColor then
		local healingBar = bar.__owner.indicators.healingBar
		if invert then
			healingBar:SetStatusBarColor(r, g, b)
		else
			local mu = GridFrame.db.profile.healingBar_intensity
			healingBar:SetStatusBarColor(r * mu, g * mu, b * mu)
		end
	end
end

local function ClearBarColor(bar, invert)
	--print("ClearBarColor")
	bar:SetStatusBarColor(0, 0, 0, 1)
	bar.bg:SetVertexColor(0, 0, 0, 1)

	local profile = GridFrame.db.profile
	if not profile.healingBar_useStatusColor then
		local healingBar = bar.__owner.indicators.healingBar
		healingBar:SetStatusBarColor(0, 1, 0, 0.5)
	end
end

GridFrame:RegisterIndicator("bar", L["Health Bar"],
	-- New
	function(frame)
		local bar = CreateFrame("StatusBar", nil, frame)
		bar:SetPoint("BOTTOMLEFT")
		bar:SetPoint("TOPRIGHT")

		local bg = bar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(true)
		bar.bg = bg

		bar:SetStatusBarTexture("Interface\\Addons\\Grid\\gradient32x32")
		bar.texture = bar:GetStatusBarTexture() -- nil if no texture has been set

		return bar
	end,

	-- Reset
	function(self)
		if self.__owner.unit then
			--print("Reset", self.__id, self.__owner.unit)
		end

		local profile = GridFrame.db.profile
		local texture = Media:Fetch("statusbar", profile.texture) or "Interface\\Addons\\Grid\\gradient32x32"
		local offset = profile.borderSize + 1

		self:SetPoint("BOTTOMLEFT", offset, offset)
		self:SetPoint("TOPRIGHT", -offset, -offset)
		self:SetOrientation(profile.orientation)

		local r, g, b, a = self:GetStatusBarColor()
		self:SetStatusBarTexture(texture)
		self.texture:SetHorizTile(false)
		self.texture:SetVertTile(false)
		self:SetStatusBarColor(r, g, b, a)

		r, g, b, a = self.bg:GetVertexColor()
		self.bg:SetTexture(texture)
		self.bg:SetHorizTile(false)
		self.bg:SetVertTile(false)
		self.bg:SetVertexColor(r, g, b, a)
	end,

	-- SetStatus
	function(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
		if not value or not maxValue then return end

		local profile = GridFrame.db.profile
		local frame = self.__owner

		self:SetMinMaxValues(0, maxValue)
		self:SetValue(value)

		local perc = value / maxValue
		local coord = (perc > 0 and perc <= 1) and perc or 1
        coord = (coord > 1 and 1) or (coord < 0 and 0) or coord
		if profile.orientation == "VERTICAL" then
			self.texture:SetTexCoord(0, 1, 1 - coord, 1)
		else
			self.texture:SetTexCoord(0, coord, 0, 1)
		end

		if color and not profile.enableBarColor then
			--print("SetStatus", self.__id, frame.unit)
			SetBarColor(self, color.r, color.g, color.b, profile.invertBarColor)
		end
	end,

	-- ClearStatus
	function(self)
		local profile = GridFrame.db.profile
		local frame = self.__owner

		self:SetMinMaxValues(0, 100)
		self:SetValue(100)
		self.texture:SetTexCoord(0, 1, 0, 1)

		if not profile.enableBarColor then
			ClearBarColor(self, profile.invertBarColor)
		end
	end
)

GridFrame:RegisterIndicator("barcolor", L["Health Bar Color"],
	-- New
	nil,

	-- Reset
	nil,

	-- SetStatus
	function(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
		local profile = GridFrame.db.profile
		if not color or not profile.enableBarColor then return end

		local frame = self.__owner

		--print("SetStatus", self.__id, frame.unit)
		SetBarColor(frame.indicators.bar, color.r, color.g, color.b, profile.invertBarColor)
	end,

	-- ClearStatus
	function(self)
		local profile = GridFrame.db.profile
		if not profile.enableBarColor then return end
		ClearBarColor(self.__owner.indicators.bar, profile.invertBarColor)
	end
)

--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
---------------------------------------------------------------------]]

local _, Grid = ...
local GridFrame = Grid:GetModule("GridFrame")
local Media = LibStub("LibSharedMedia-3.0")
local L = Grid.L

local BACKDROP = {
	bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true, tileSize = 8,
	edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1},
}

local anchor = {
	corner3 = { "TOPLEFT", -1, 1 },
	corner4 = { "TOPRIGHT", 1, 1 },
	corner1 = { "BOTTOMLEFT", -1, -1 },
	corner2 = { "BOTTOMRIGHT", 1, -1 },
}

local function New(frame)
	local square = CreateFrame("Frame", nil, frame)
	square:SetBackdrop(BACKDROP)
	square:SetBackdropBorderColor(0, 0, 0, 1)
	return square
end

local function Reset(self)
	local profile = GridFrame.db.profile

	self:SetWidth(profile.cornerSize)
	self:SetHeight(profile.cornerSize)
	self:SetParent(self.__owner.indicators.bar)
	self:SetFrameLevel(self.__owner.indicators.bar:GetFrameLevel() + 1)

	self:ClearAllPoints()
	self:SetPoint(unpack(anchor[self.__id]))
end

local function SetStatus(self, color, text, value, maxValue, texture, texCoords, count, start, duration)
	if not color then return end
	self:SetBackdropColor(color.r, color.g, color.b, color.a or 1)
	self:Show()
end

local function Clear(self)
	self:SetBackdropColor(1, 1, 1, 1)
	self:Hide()
end

GridFrame:RegisterIndicator("corner3",  L["Top Left Corner"],     New, Reset, SetStatus, Clear)
GridFrame:RegisterIndicator("corner4",  L["Top Right Corner"],    New, Reset, SetStatus, Clear)
GridFrame:RegisterIndicator("corner1",  L["Bottom Left Corner"],  New, Reset, SetStatus, Clear)
GridFrame:RegisterIndicator("corner2",  L["Bottom Right Corner"], New, Reset, SetStatus, Clear)

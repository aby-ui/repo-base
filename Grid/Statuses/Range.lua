--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	Range.lua
	Grid status module for unit range.
	Created by neXter, modified by Pastamancer, modified by Phanx.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusRange = Grid:NewStatusModule("GridStatusRange", "AceTimer-3.0")
GridStatusRange.menuName = L["Out of Range"]

GridStatusRange.defaultDB = {
	alert_range = {
		enable = true,
		text = L["Range"],
		color = { r = 0.8, g = 0.2, b = 0.2, a = 0.5 },
		priority = 80,
		range = false,
		frequency = 0.2,
	}
}

local extraOptions = {
	frequency = {
		name = L["Range check frequency"],
		desc = L["Seconds between range checks"],
		order = -1,
		width = "double",
		type = "range", min = 0.1, max = 5, step = 0.1,
		get = function()
			return GridStatusRange.db.profile.alert_range.frequency
		end,
		set = function(_, v)
			GridStatusRange.db.profile.alert_range.frequency = v
			GridStatusRange:OnStatusDisable("alert_range")
			GridStatusRange:OnStatusEnable("alert_range")
		end,
	},
	text = {
		name = L["Text"],
		desc = L["Text to display on text indicators"],
		order = 113,
		type = "input",
		get = function()
			return GridStatusRange.db.profile.alert_range.text
		end,
		set = function(_, v)
			GridStatusRange.db.profile.alert_range.text = v
		end,
	},
	range = false,
}

function GridStatusRange:PostInitialize()
	self:RegisterStatus("alert_range", L["Out of Range"], extraOptions, true)
end

function GridStatusRange:OnStatusEnable(status)
	self:RegisterMessage("Grid_PartyTransition", "PartyTransition")
	self:PartyTransition("OnStatusEnable", GridRoster:GetPartyState())
end

function GridStatusRange:OnStatusDisable(status)
	self:StopTimer("CheckRange")
	self.core:SendStatusLostAllUnits("alert_range")
end

local resSpell
do
	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		resSpell = GetSpellInfo(61999)  -- Raise Ally
	elseif class == "DRUID" then
		resSpell = GetSpellInfo(50769)  -- Revive
	elseif class == "MONK" then
		resSpell = GetSpellInfo(115178) -- Resuscitate
	elseif class == "PALADIN" then
		resSpell = GetSpellInfo(7328)   -- Redemption
	elseif class == "PRIEST" then
		resSpell = GetSpellInfo(2006)   -- Resurrection
	elseif class == "SHAMAN" then
		resSpell = GetSpellInfo(2008)   -- Ancestral Spirit
	elseif class == "WARLOCK" then
		resSpell = GetSpellInfo(20707)  -- Soulstone
	end
end

local IsSpellInRange, UnitInRange, UnitIsDead, UnitIsVisible, UnitIsUnit, UnitInPhase, UnitIsWarModePhased, UnitIsConnected
    = IsSpellInRange, UnitInRange, UnitIsDead, UnitIsVisible, UnitIsUnit, UnitInPhase, UnitIsWarModePhased, UnitIsConnected

local function GroupRangeCheck(self, unit)
	if UnitIsUnit(unit, "player") then
		return true
    elseif (UnitIsWarModePhased(unit) or not UnitInPhase(unit)) and UnitIsConnected(unit) then
        return false --abyui
	elseif resSpell and UnitIsDead(unit) and not UnitIsDead("player") then
		return IsSpellInRange(resSpell, unit) == 1
	else
		local inRange, checkedRange = UnitInRange(unit)
		if checkedRange then
			return inRange
		else
			return true
		end
	end
end

local function SoloRangeCheck(self, unit)
	-- This is a workaround for the bug in WoW 5.0.4 in which UnitInRange
	-- returns *false* for player/pet while solo.
	return true
end

GridStatusRange.UnitInRange = GroupRangeCheck

function GridStatusRange:CheckRange()
	local settings = self.db.profile.alert_range
	for guid, unit in GridRoster:IterateRoster() do
		if self:UnitInRange(unit) then
			self.core:SendStatusLost(guid, "alert_range")
		else
			self.core:SendStatusGained(guid, "alert_range",
				settings.priority,
				false,
				settings.color,
				settings.text)
		end
	end
end

function GridStatusRange:PartyTransition(message, state, oldstate)
	self:Debug("PartyTransition", message, state, oldstate)
	if state == "solo" then
		self:StopTimer("CheckRange")
		self.UnitInRange = SoloRangeCheck
		self.core:SendStatusLostAllUnits("alert_range")
	else
		self:StartTimer("CheckRange", self.db.profile.alert_range.frequency, true)
		self.UnitInRange = GroupRangeCheck
	end
end

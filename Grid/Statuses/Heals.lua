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
	Heals.lua
	Grid status module for incoming heals.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local settings

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusHeals = Grid:NewStatusModule("GridStatusHeals")
GridStatusHeals.menuName = L["Heals"]
GridStatusHeals.options = false

GridStatusHeals.defaultDB = {
	alert_heals = {
		enable = true,
		priority = 50,
		color = { r = 0, g = 1, b = 0, a = 1 },
		text = "+%s",
		icon = nil,
		ignore_self = false,
		minimumValue = 0.05,
	},
}

local healsOptions = {
	ignoreSelf = {
		type = "toggle", width = "double",
		name = L["Ignore Self"],
		desc = L["Ignore heals cast by you."],
		get = function()
			return GridStatusHeals.db.profile.alert_heals.ignore_self
		end,
		set = function(_, v)
			GridStatusHeals.db.profile.alert_heals.ignore_self = v
			GridStatusHeals:UpdateAllUnits()
		end,
	},
	minimumValue = {
		width = "double",
		type = "range", min = 0, max = 0.5, step = 0.05, isPercent = true,
		name = L["Minimum Value"],
		desc = L["Only show incoming heals greater than this percent of the unit's maximum health."],
		get = function()
			return GridStatusHeals.db.profile.alert_heals.minimumValue
		end,
		set = function(_, v)
			GridStatusHeals.db.profile.alert_heals.minimumValue = v
		end,
	},
}

function GridStatusHeals:PostInitialize()
	settings = GridStatusHeals.db.profile.alert_heals
	self:RegisterStatus("alert_heals", L["Incoming heals"], healsOptions, true)
end

function GridStatusHeals:OnStatusEnable(status)
	if status == "alert_heals" then
		self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_HEAL_PREDICTION", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusHeals:OnStatusDisable(status)
	if status == "alert_heals" then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_MAXHEALTH")
		self:UnregisterEvent("UNIT_HEAL_PREDICTION")
		self.core:SendStatusLostAllUnits("alert_heals")
	end
end

function GridStatusHeals:PostReset()
	settings = GridStatusHeals.db.profile.alert_heals
end

function GridStatusHeals:UpdateAllUnits()
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

local UnitGetIncomingHeals, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible
    = UnitGetIncomingHeals, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible

function GridStatusHeals:UpdateUnit(event, unit)
	if not unit then return end

	local guid = UnitGUID(unit)
	if not GridRoster:IsGUIDInRaid(guid) then return end

	if UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		local incoming = UnitGetIncomingHeals(unit) or 0
		if incoming > 0 then
			self:Debug("UpdateUnit", unit, incoming, UnitGetIncomingHeals(unit, "player") or 0, format("%.2f%%", incoming / UnitHealthMax(unit) * 100))
		end
		if settings.ignore_self then
			incoming = incoming - (UnitGetIncomingHeals(unit, "player") or 0)
		end
		if incoming > 0 then
			local maxHealth = UnitHealthMax(unit)
			if (incoming / maxHealth) > settings.minimumValue then
				return self:SendIncomingHealsStatus(guid, incoming, UnitHealth(unit) + incoming, maxHealth)
			end
		end
	end
	self.core:SendStatusLost(guid, "alert_heals")
end

function GridStatusHeals:SendIncomingHealsStatus(guid, incoming, estimatedHealth, maxHealth)
	local incomingText = incoming
	if incoming > 9999 then
		incomingText = format("%.0fk", incoming / 1000)
	elseif incoming > 999 then
		incomingText = format("%.1fk", incoming / 1000)
	end
	self.core:SendStatusGained(guid, "alert_heals",
		settings.priority,
		settings.range,
		settings.color,
		format(settings.text, incomingText),
		estimatedHealth,
		maxHealth,
		settings.icon)
end

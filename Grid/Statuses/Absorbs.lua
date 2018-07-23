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
	Absorbs.lua
	Grid status module for absorption effects.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local settings

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusAbsorbs = Grid:NewStatusModule("GridStatusAbsorbs")
GridStatusAbsorbs.menuName = L["Absorbs"]
GridStatusAbsorbs.options = false

GridStatusAbsorbs.defaultDB = {
	alert_absorbs = {
		enable = true,
		priority = 40,
		color = { r = 1, g = 1, b = 0, a = 1 },
		text = "+%s",
		minimumValue = 0.1,
	},
}

local extraOptionsForStatus = {
	minimumValue = {
		width = "double",
		type = "range", min = 0, max = 0.5, step = 0.05, isPercent = true,
		name = L["Minimum Value"],
		desc = L["Only show total absorbs greater than this percent of the unit's maximum health."],
		get = function()
			return GridStatusAbsorbs.db.profile.alert_absorbs.minimumValue
		end,
		set = function(_, v)
			GridStatusAbsorbs.db.profile.alert_absorbs.minimumValue = v
		end,
	},
}

function GridStatusAbsorbs:PostInitialize()
	self:RegisterStatus("alert_absorbs", L["Absorbs"], extraOptionsForStatus, true)
	settings = self.db.profile.alert_absorbs
end

function GridStatusAbsorbs:OnStatusEnable(status)
	if status == "alert_absorbs" then
		self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusAbsorbs:OnStatusDisable(status)
	if status == "alert_absorbs" then
		self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_MAXHEALTH")
		self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		self.core:SendStatusLostAllUnits("alert_absorbs")
	end
end

function GridStatusAbsorbs:PostReset()
	settings = self.db.profile.alert_absorbs
end

function GridStatusAbsorbs:UpdateAllUnits()
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

local UnitGetTotalAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible
    = UnitGetTotalAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible

function GridStatusAbsorbs:UpdateUnit(event, unit)
	if not unit then return end

	local guid = UnitGUID(unit)
	if not GridRoster:IsGUIDInRaid(guid) then return end

	local amount = UnitIsVisible(unit) and UnitGetTotalAbsorbs(unit) or 0
	if amount > 0 then
		local maxHealth = UnitHealthMax(unit)
		if (amount / maxHealth) > settings.minimumValue then
			local text = amount
			if amount > 9999 then
				text = format("%.0fk", amount / 1000)
			elseif amount > 999 then
				text = format("%.1fk", amount / 1000)
			end
			self.core:SendStatusGained(guid, "alert_absorbs",
				settings.priority,
				nil,
				settings.color,
				format(settings.text, text),
				UnitHealth(unit) + amount,
				UnitHealthMax(unit),
				settings.icon
			)
		end
	else
		self.core:SendStatusLost(guid, "alert_absorbs")
	end
end

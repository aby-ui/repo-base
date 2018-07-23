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
	Health.lua
	Grid status module for unit health.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusHealth = Grid:NewStatusModule("GridStatusHealth")
GridStatusHealth.menuName = L["Health and Death"]

GridStatusHealth.defaultDB = {
	unit_health = {
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 30,
		range = false,
		deadAsFullHealth = true,
		useClassColors = true,
	},
	unit_healthDeficit = {
		enable = false,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 30,
		threshold = 80,
		range = false,
		useClassColors = true,
	},
	alert_lowHealth = {
		text = L["Low HP"],
		enable = false,
		color = { r = 1, g = 1, b = 1, a = 1 },
		priority = 30,
		threshold = 80,
		range = false,
	},
	alert_death = {
		text = L["DEAD"],
		enable = true,
		color = { r = 0.5, g = 0.5, b = 0.5, a = 1, ignore = true },
		icon = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
		priority = 95,
		range = false,
	},
    alert_ghost = {
   		text = GetSpellInfo(8326),
   		enable = true,
   		color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
   		icon = "Interface\\Icons\\Ability_Vanish",
   		priority = 95,
   		range = false,
   	},
	alert_feignDeath = {
		text = L["FD"],
		enable = false,
		color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		icon = "Interface\\Icons\\Ability_Rogue_FeignDeath",
		priority = 55,
		range = false,
	},
	alert_offline = {
		text = L["Offline"],
		enable = true,
		color = { r = 0.5, g = 0.5, b = 0.5, a = 0.7, ignore = true },
		icon = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
		priority = 99,
		range = false,
	},
}

local ICON_TEX_COORDS = { left = 0.06, right = 0.94, top = 0.06, bottom = 0.94 }

GridStatusHealth.extraOptions = {
	deadAsFullHealth = {
		order = 101, width = "double",
		name = L["Show dead as full health"],
		desc = L["Treat dead units as being full health."],
		type = "toggle",
		get = function()
			return GridStatusHealth.db.profile.unit_health.deadAsFullHealth
		end,
		set = function(_, v)
			GridStatusHealth.db.profile.unit_health.deadAsFullHealth = v
			GridStatusHealth:UpdateAllUnits()
		end,
	},
}

local healthOptions = {
	enable = false, -- you can't disable this
	useClassColors = {
		name = L["Use class color"],
		desc = L["Color health based on class."],
		type = "toggle", width = "double",
		get = function()
			return GridStatusHealth.db.profile.unit_health.useClassColors
		end,
		set = function(_, v)
			GridStatusHealth.db.profile.unit_health.useClassColors = v
			GridStatusHealth:UpdateAllUnits()
		end,
	},
}

local healthDeficitOptions = {
	threshold = {
		name = L["Health threshold"],
		desc = L["Only show deficit above % damage."],
		type = "range", min = 0, max = 100, step = 1, width = "double",
		get = function()
			return GridStatusHealth.db.profile.unit_healthDeficit.threshold
		end,
		set = function(_, v)
			GridStatusHealth.db.profile.unit_healthDeficit.threshold = v
			GridStatusHealth:UpdateAllUnits()
		end,
	},
	useClassColors = {
		name = L["Use class color"],
		desc = L["Color deficit based on class."],
		type = "toggle", width = "double",
		get = function()
			return GridStatusHealth.db.profile.unit_healthDeficit.useClassColors
		end,
		set = function(_, v)
			GridStatusHealth.db.profile.unit_healthDeficit.useClassColors = v
			GridStatusHealth:UpdateAllUnits()
		end,
	},
}

local low_healthOptions = {
	threshold = {
		name = L["Low HP threshold"],
		desc = L["Set the HP % for the low HP warning."],
		type = "range", min = 0, max = 100, step = 1, width = "double",
		get = function()
			return GridStatusHealth.db.profile.alert_lowHealth.threshold
		end,
		set = function(_, v)
			GridStatusHealth.db.profile.alert_lowHealth.threshold = v
			GridStatusHealth:UpdateAllUnits()
		end,
	},
}

function GridStatusHealth:PostInitialize()
	self:RegisterStatus("unit_health", L["Unit health"], healthOptions)
	self:RegisterStatus("unit_healthDeficit", L["Health deficit"], healthDeficitOptions)
	self:RegisterStatus("alert_lowHealth", L["Low HP warning"], low_healthOptions)
	self:RegisterStatus("alert_death", L["Death warning"], nil, nil)
    self:RegisterStatus("alert_ghost", GridStatusHealth.defaultDB.alert_ghost.text, nil, nil)
	--self:RegisterStatus("alert_feignDeath", L["Feign Death warning"], nil, true)
	self:RegisterStatus("alert_offline", L["Offline warning"], nil, nil)
end

-- you can't disable the unit_health status, so no need to ever unregister
function GridStatusHealth:PostEnable()
	self:RegisterMessage("Grid_UnitJoined")

	self:RegisterEvent("UNIT_AURA", "UpdateUnit")
	self:RegisterEvent("UNIT_CONNECTION", "UpdateUnit")
	self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
	self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
	self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateUnit")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateAllUnits")

	self:RegisterMessage("Grid_ColorsChanged", "UpdateAllUnits")
end

function GridStatusHealth:OnStatusEnable(status)
	self:UpdateAllUnits()
end

function GridStatusHealth:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
end

function GridStatusHealth:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:Grid_UnitJoined("UpdateAllUnits", guid, unitid)
	end
end

function GridStatusHealth:Grid_UnitJoined(event, guid, unitid)
	if unitid then
		self:UpdateUnit(event, unitid, true)
		self:UpdateUnit(event, unitid)
	end
end

local UnitGUID, UnitHealth, UnitHealthMax, UnitIsConnected, UnitIsDeadOrGhost, UnitIsFeignDeath = UnitGUID, UnitHealth, UnitHealthMax, UnitIsConnected, UnitIsDeadOrGhost, UnitIsFeignDeath

function GridStatusHealth:UpdateUnit(event, unitid, ignoreRange)
	if not unitid then
		-- 7.1: UNIT_HEALTH and UNIT_MAXHEALTH sometimes fire with no unit token
		-- https://wow.curseforge.com/addons/grid/tickets/859
		return
	end

	local guid = UnitGUID(unitid)

	if not GridRoster:IsGUIDInRaid(guid) then
		return
	end

	local cur, max = UnitHealth(unitid), UnitHealthMax(unitid)
	if max == 0 then
		-- fix for 4.3 division by zero
		cur, max = 100, 100
	end

	local healthSettings = self.db.profile.unit_health
	local deficitSettings = self.db.profile.unit_healthDeficit
	local healthPriority = healthSettings.priority
	local deficitPriority = deficitSettings.priority

	if UnitIsDeadOrGhost(unitid) then
		self:StatusDeath(guid, true)
        self:StatusGhost(guid, UnitIsGhost(unitid))
		self:StatusFeignDeath(guid, false)
		self:StatusLowHealth(guid, false)
		if healthSettings.deadAsFullHealth then
			cur = max
		end
	else
		self:StatusDeath(guid, false)
        self:StatusGhost(guid, false)
		self:StatusFeignDeath(guid, UnitIsFeignDeath(unitid))
		self:StatusLowHealth(guid, (cur / max * 100) <= self.db.profile.alert_lowHealth.threshold)
	end

	self:StatusOffline(guid, not UnitIsConnected(unitid))

	local healthText
	local deficitText

	if cur < max then
		if cur > 999 then
			healthText = format("%.1fk", cur / 1000)
		else
			healthText = format("%d", cur)
		end

		local deficit = max - cur
		if deficit > 999 then
			deficitText = format("-%.1fk", deficit / 1000)
		else
			deficitText = format("-%d", deficit)
		end
	else
		healthPriority = 1
		deficitPriority = 1
	end

	if (cur / max * 100) <= deficitSettings.threshold then
		self.core:SendStatusGained(guid, "unit_healthDeficit",
			deficitPriority,
			deficitSettings.range,
			(deficitSettings.useClassColors and self.core:UnitColor(guid) or deficitSettings.color),
			deficitText,
			cur,
			max,
			deficitSettings.icon)
	else
		self.core:SendStatusLost(guid, "unit_healthDeficit")
	end

	self.core:SendStatusGained(guid, "unit_health",
		healthPriority,
		(not ignoreRange and healthSettings.range),
		(healthSettings.useClassColors and self.core:UnitColor(guid) or healthSettings.color),
		healthText,
		cur,
		max,
		healthSettings.icon)
end

function GridStatusHealth:IsLowHealth(cur, max)
	return (cur / max * 100) <= self.db.profile.alert_lowHealth.threshold
end

function GridStatusHealth:StatusLowHealth(guid, gained)
	local settings = self.db.profile.alert_lowHealth

	-- return if this option isn't enabled
	if not settings.enable then return end

	if gained then
		self.core:SendStatusGained(guid, "alert_lowHealth",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	else
		self.core:SendStatusLost(guid, "alert_lowHealth")
	end
end

function GridStatusHealth:StatusDeath(guid, gained)
	local settings = self.db.profile.alert_death

	if not guid then return end

	-- return if this option isnt enabled
	if not settings.enable then return end

	if gained then
		-- trigger death event for other modules as wow isnt firing a death event
		self:SendMessage("Grid_UnitDeath", guid)
		self.core:SendStatusGained(guid, "alert_death",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			(self.db.profile.unit_health.deadAsFullHealth and 100 or 0),
			100,
			settings.icon)
	else
		self.core:SendStatusLost(guid, "alert_death")
	end
end

function GridStatusHealth:StatusGhost(guid, gained)
	local settings = self.db.profile.alert_ghost

	if not guid then return end

	-- return if this option isnt enabled
	if not settings.enable then return end

	if gained then
		-- trigger death event for other modules as wow isnt firing a death event
		self.core:SendStatusGained(guid, "alert_ghost",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			(self.db.profile.unit_health.deadAsFullHealth and 100 or 0),
			100,
			settings.icon, nil, nil, nil, ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, "alert_ghost")
	end
end

function GridStatusHealth:StatusFeignDeath(guid, gained)
	local settings = self.db.profile.alert_feignDeath

	if not guid then return end

	-- return if this option isnt enabled
	if not settings.enable then return end

	if gained then
		self.core:SendStatusGained(guid, "alert_feignDeath",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			(self.db.profile.unit_health.deadAsFullHealth and 100 or 0),
			100,
			settings.icon, nil, nil, nil, ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, "alert_feignDeath")
	end
end

function GridStatusHealth:StatusOffline(guid, gained)
	local settings = self.db.profile.alert_offline

	if not guid then return end

	if gained then
		-- trigger offline event for other modules
		self:SendMessage("Grid_UnitOffline", guid)
		self.core:SendStatusGained(guid, "alert_offline",
			settings.priority,
			settings.range,
			settings.color,
			settings.text,
			nil,
			nil,
			settings.icon)
	else
		self.core:SendStatusLost(guid, "alert_offline")
	end
end

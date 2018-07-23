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
	Aggro.lua
	Grid status module for aggro/threat.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local GridStatus = Grid:GetModule("GridStatus")
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusAggro = Grid:NewStatusModule("GridStatusAggro")
GridStatusAggro.menuName = L["Aggro Status"]

local function getthreatcolor(status)
	local r, g, b = GetThreatStatusColor(status)
	return { r = r, g = g, b = b, a = 1 }
end

GridStatusAggro.defaultDB = {
	alert_aggro = {
		text =  L["Aggro Status"],
		enable = true,
		color = { r = 1, g = 0, b = 0, a = 1 },
		priority = 99,
		range = false,
		threat = false,
		threatcolors = {
			[1] = getthreatcolor(1),
			[2] = getthreatcolor(2),
			[3] = getthreatcolor(3),
		},
		threattexts = {
			[1] = L["High"],
			[2] = L["Aggro"],
			[3] = L["Tank"]
		},
	},
}

GridStatusAggro.options = false

local function getstatuscolor(status)
	local color = GridStatusAggro.db.profile.alert_aggro.threatcolors[status]
	return color.r, color.g, color.b, color.a
end

local function setstatuscolor(status, r, g, b, a)
	local color = GridStatusAggro.db.profile.alert_aggro.threatcolors[status]
	color.r = r
	color.g = g
	color.b = b
	color.a = a or 1
end

local aggroDynamicOptions = {
	["threat_colors"] = {
		type = "group",
		dialogInline = true,
		name = L["Color"],
		order = 87,
		args = {
			["1"] = {
				type = "color",
				name = L["High State"],
                desc = L["not tanking, higher threat than tank."],
				order = 100,
				width = "double",
				hasAlpha = true,
				get = function() return getstatuscolor(1) end,
				set = function(_, r, g, b, a) setstatuscolor(1, r, g, b, a) end,
			},
			["2"] = {
				type = "color",
				name = L["Aggro State"],
                desc = L["insecurely tanking, another unit have higher threat but not tanking."],
				order = 101,
				width = "double",
				hasAlpha = true,
				get = function() return getstatuscolor(2) end,
				set = function(_, r, g, b, a) setstatuscolor(2, r, g, b, a) end,
			},
			["3"] = {
				type = "color",
				name = L["Tanking State"],
                desc = L["securely tanking, highest threat."],
				order = 102,
				width = "double",
				hasAlpha = true,
				get = function() return getstatuscolor(3) end,
				set = function(_, r, g, b, a) setstatuscolor(3, r, g, b, a) end,
			},
		},
	},
}

local function setupmenu()
	local args = GridStatus.options.args["alert_aggro"].args
	local threat = GridStatusAggro.db.profile.alert_aggro.threat

	if not aggroDynamicOptions.aggroColor then
		aggroDynamicOptions.aggroColor = args.color
	end

	if threat then
		args.color = nil
		args.threat_colors = aggroDynamicOptions.threat_colors
	else
		args.color = aggroDynamicOptions.aggroColor
		args.threat_colors = nil
	end
end

local aggroOptions = {
	threat = {
		type = "toggle",
		name = L["Threat levels"],
		desc = L["Show more detailed threat levels."],
		width = "full",
		get = function() return GridStatusAggro.db.profile.alert_aggro.threat end,
		set = function()
			GridStatusAggro.db.profile.alert_aggro.threat = not GridStatusAggro.db.profile.alert_aggro.threat
			GridStatusAggro.UpdateAllUnits(GridStatusAggro)
			setupmenu()
		end,
	},
}

function GridStatusAggro:PostInitialize()
	self:RegisterStatus("alert_aggro", L["Aggro Status"], aggroOptions, true)
	setupmenu()
end

function GridStatusAggro:OnStatusEnable(status)
	if status == "alert_aggro" then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", "UpdateUnit")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateAllUnits")
		self:UpdateAllUnits()
	end
end

function GridStatusAggro:OnStatusDisable(status)
	if status == "alert_aggro" then
		self:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.core:SendStatusLostAllUnits("alert_aggro")
	end
end

function GridStatusAggro:PostReset()
	setupmenu()
end

function GridStatusAggro:UpdateAllUnits()
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

------------------------------------------------------------------------

local UnitGUID, UnitIsVisible, UnitThreatSituation
	 = UnitGUID, UnitIsVisible, UnitThreatSituation

function GridStatusAggro:UpdateUnit(event, unit, guid)
	local guid = guid or unit and UnitGUID(unit)
	if not guid or not GridRoster:IsGUIDInRaid(guid) then return end -- sometimes unit can be nil or invalid, wtf?

	local status = UnitIsVisible(unit) and UnitThreatSituation(unit) or 0

	local settings = self.db.profile.alert_aggro
	local threat = settings.threat

	if status and ((threat and (status > 0)) or (status > 1)) then
		GridStatusAggro.core:SendStatusGained(guid, "alert_aggro",
			settings.priority,
			settings.range,
			(threat and settings.threatcolors[status] or settings.color),
			(threat and settings.threattexts[status] or settings.text),
			nil,
			nil,
			settings.icon)
	else
		GridStatusAggro.core:SendStatusLost(guid, "alert_aggro")
	end
end

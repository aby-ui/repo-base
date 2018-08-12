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
	Resurrect.lua
	Grid status module for resurrections.
----------------------------------------------------------------------]]

local IS_WOW_8 = GetBuildInfo():match("^8")

local _, Grid = ...
local L = Grid.L

local LibResInfo
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusResurrect = Grid:NewStatusModule("GridStatusResurrect", "AceTimer-3.0")
GridStatusResurrect.menuName = L["Resurrection"]
GridStatusResurrect.options = false

GridStatusResurrect.defaultDB = {
	alert_resurrect = {
		enable = true,
		text = L["RES"],
		color = { r = 0.8, g = 1, b = 0, a = 1 },
		color2 = { r = 0.2, g = 1, b = 0, a = 1 },
		color3 = { r = 0.8, g = 0, b = 0.8, a = 1 },
		priority = 50,
		showUntilUsed = true,
	},
}

local extraOptionsForStatus = {
	color = false,
	showUntilUsed = {
		name = L["Show until used"],
		desc = L["Show the status until the resurrection is accepted or expires, instead of only while it is being cast."],
		type = "toggle",
		width = "double",
		get = function(t)
			return GridStatusResurrect.db.profile.alert_resurrect.showUntilUsed
		end,
		set = function(t, v)
			GridStatusResurrect.db.profile.alert_resurrect.showUntilUsed = v
			GridStatusResurrect:UpdateAllUnits()
		end,
	},
	colors = {
		type = "group",
		dialogInline = true,
		name = L["Resurrection colors"],
		order = 86,
		args = {
			color1 = {
				order = 100,
				name = L["Casting color"],
				desc = L["Use this color for resurrections that are currently being cast."],
				type = "color",
				hasAlpha = true,
				get = function(t)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color
					return color.r, color.g, color.b, color.a or 1
				end,
				set = function(t, r, g, b, a)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color
					color.r, color.g, color.b, color.a = r, g, b, a or 1
				end,
			},
			color2 = {
				order = 101,
				name = L["Pending color"],
				desc = L["Use this color for resurrections that have finished casting and are waiting to be accepted."],
				type = "color",
				hasAlpha = true,
				get = function(t)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color2
					return color.r, color.g, color.b, color.a or 1
				end,
				set = function(t, r, g, b, a)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color2
					color.r, color.g, color.b, color.a = r, g, b, a or 1
				end,
			},
			color3 = {
				order = 102,
				name = L["Soulstone color"],
				desc = L["Use this color for pre-cast Soulstones that are waiting to be accepted."],
				type = "color",
				hasAlpha = true,
				get = function(t)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color3
					return color.r, color.g, color.b, color.a or 1
				end,
				set = function(t, r, g, b, a)
					local color = GridStatusResurrect.db.profile.alert_resurrect.color3
					color.r, color.g, color.b, color.a = r, g, b, a or 1
				end,
			},
		},
	},
}

------------------------------------------------------------------------

function GridStatusResurrect:PostInitialize()
	self:Debug("PostInitialize")

	self:RegisterStatus("alert_resurrect", L["Resurrection"], extraOptionsForStatus, true)

	self.core.options.args.alert_resurrect.args.range = nil
end

function GridStatusResurrect:OnStatusEnable(status)
	self:Debug("OnStatusEnable", status)

	LibResInfo = LibStub("LibResInfo-1.0")
	LibResInfo.RegisterAllCallbacks(self, "HandleCallback", true)

	self:RegisterMessage("Grid_RosterUpdated", "UpdateAllUnits")
end

function GridStatusResurrect:OnStatusDisable(status)
	self:Debug("OnStatusDisable", status)

	LibResInfo.UnregisterAllCallbacks(self)

	self.core:SendStatusLostAllUnits("alert_resurrect")
end

------------------------------------------------------------------------

function GridStatusResurrect:UpdateAllUnits(event)
	self:Debug("UpdateAllUnits", event)
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit(unit, guid)
	end
end

function GridStatusResurrect:HandleCallback(callback, targetUnit, targetGUID, casterUnit, casterGUID, endTime)
	if strsub(callback, 1, 18) == "LibResInfo_MassRes" then
		self:Debug(callback, casterUnit)
		self:UpdateAllUnits()
	else
		self:Debug(callback, targetUnit, casterUnit)
		self:UpdateUnit(targetUnit, targetGUID)
	end
end

function GridStatusResurrect:UpdateUnit(unit, guid)
	if not unit then return end
	if not guid then guid = UnitGUID(unitid) end
	if not GridRoster:IsGUIDInRaid(guid) then return end

	local db = self.db.profile.alert_resurrect
	local hasRes, endTime, casterUnit, casterGUID = LibResInfo:UnitHasIncomingRes(guid)

	if not hasRes or (hasRes == "PENDING" and not db.showUntilUsed) then
		return self.core:SendStatusLost(guid, "alert_resurrect")
	end

	local icon, startTime, duration, _
	if hasRes == "PENDING" then
		icon = "Interface\\Icons\\Spell_Nature_Reincarnation"
		startTime = endTime - 60
		duration = 60
	elseif hasRes == "SELFRES" then
		icon = "Interface\\ICONS\\Spell_Shadow_Soulgem"
		startTime = endTime - 360
		duration = 360
	else -- CASTING or PENDING
		if IS_WOW_8 then
			_, _, icon, startTime = UnitCastingInfo(casterUnit)
		else
			_, _, _, icon, startTime = UnitCastingInfo(casterUnit)
		end
		if not startTime then
			-- ignore instant casts
			return
		end
		startTime = startTime / 1000
		duration = endTime - startTime
	end

	self.core:SendStatusGained(guid, "alert_resurrect",
		db.priority,
		nil,
		hasRes == "SELFRES" and db.color3 or hasRes == "PENDING" and db.color2 or db.color,
		db.text,
		nil,
		nil,
		icon,
		startTime,
		duration)
end

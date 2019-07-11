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
	Role.lua
	Grid status module for tank/healer/damager roles.
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusRole = Grid:NewStatusModule("GridStatusRole", "AceBucket-3.0")
GridStatusRole.menuName = L["Role"]
GridStatusRole.options = false
GridStatusRole.defaultDB = {
	role = {
		enable = true, -- not exposed in the UI
		priority = 35,
		TANK = {
			enable = true,
			hideInCombat = false,
			text = string.utf8sub(TANK, 1, 1),
			color = { r = 1, g = 1, b = 0, a = 1, ignore = true },
		},
		HEALER = {
			enable = true,
			hideInCombat = false,
			text = string.utf8sub(HEALER, 1, 1),
			color = { r = 0, g = 1, b = 0, a = 1, ignore = true },
		},
		DAMAGER = {
			enable = false,
			hideInCombat = false,
			text = string.utf8sub(DAMAGER, 1, 1),
			color = { r = 1, g = 0, b = 0, a = 1, ignore = true },
		},
	},
}

local ROLE_TEXTURE = "Interface\\LFGFRAME\\LFGROLE"
local ROLE_TEXCOORDS = {
	TANK    = { left = 33/64, right = 47/64, top = 1/16, bottom = 15/16 },
	HEALER  = { left = 49/64, right = 63/64, top = 1/16, bottom = 15/16 },
	DAMAGER = { left = 17/64, right = 31/64, top = 1/16, bottom = 15/16 },
}

--163ui
local darkness, alpha = 0.6, 0.9
for _, v in pairs(ROLE_TEXCOORDS) do
    v.left = v.left - 1/64
    v.right = v.right + 1/64
    v.top = v.top - 1/64
    v.bottom = v.bottom + 1/64
    v.r = darkness
    v.g = darkness
    v.b = darkness
    v.a = alpha
end

function GridStatusRole:PostInitialize()
	self:Debug("PostInitialize")

	local optionsForStatus = {
		enable = false,
		color = false,
	}

	local function getSetting(info)
		local t = info[#info-1]
		local k = info[#info]
		local v = self.db.profile.role[t][k]
		if type(v) == "table" then
			self:Debug("get", t, k, v.r, v.g, v.b, v.a)
			return v.r, v.g, v.b, v.a
		else
			self:Debug("get", t, k, v)
			return v
		end
	end

	local function setSetting(info, r, g, b, a)
		local t = info[#info-1]
		local k = info[#info]
		local v = self.db.profile.role[t][k]
		self:Debug("set", t, r, g, b, a)
		if type(v) == "table" then
			v.r, v.g, v.b, v.a = r, g, b, a
		else
			self.db.profile.role[t][k] = r
		end
		if k == "enable" then
			local v2 = false
			for k2 in pairs(ROLE_TEXCOORDS) do
				if self.db.profile.role[k2].enable then
					v2 = true
					break
				end
			end
			if v2 ~= self.db.profile.role.enable then
				self.db.profile.role.enable = v2
				if v2 then
					self:OnStatusEnable("role")
				else
					self:OnStatusDisable("role")
				end
			end
		end
	end

	for role in pairs(ROLE_TEXCOORDS) do
		local roleName = role
		optionsForStatus[roleName] = {
			name = _G[roleName],
			type = "group",
			dialogInline = true,
			get = getSetting,
			set = setSetting,
			args = {
				enable = {
					name = L["Enable"],
					order = 1,
					type = "toggle",
				},
				hideInCombat = {
					name = L["Hide in combat"],
					order = 1,
					type = "toggle",
				},
				color = {
					name = L["Color"],
					order = 10,
					type = "color",
					hasAlpha = true,
				},
				text = {
					name = L["Text"],
					order = 20,
					type = "input",
				},
			}
		}
	end

	self:RegisterStatus("role", L["Role"], optionsForStatus, true)
end

function GridStatusRole:OnStatusEnable(status)
	if status ~= "role" then return end
	self:Debug("OnStatusEnable", status)

	self:RegisterEvent("ROLE_CHANGED_INFORM", "UpdateAllUnits")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateAllUnits")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateAllUnits")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateAllUnits")
    self:RegisterBucketEvent("GROUP_ROSTER_UPDATE", 0.5, "UpdateAllUnits")
    self:RegisterBucketEvent("PLAYER_ENTERING_WORLD", 0.5, "UpdateAllUnits")

	self:RegisterMessage("Grid_RosterUpdate", "UpdateAllUnits")
end

function GridStatusRole:OnStatusDisable(status)
	if status ~= "role" then return end
	self:Debug("OnStatusDisable", status)

	self:UnregisterEvent("ROLE_CHANGED_INFORM")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    self:UnregisterAllBuckets()

	self:UnregisterMessage("Grid_PartyTransition")

	self.core:SendStatusLostAllUnits("role")
end

--/dump Grid:GetModule("GridStatus"):GetModule("GridStatusRole"):UpdateAllUnits()
function GridStatusRole:UpdateAllUnits(event)
	self:Debug("UpdateAllUnits", event)
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit, guid)
	end
end

function GridStatusRole:UpdateUnit(event, unit, guid)
	local role = UnitGroupRolesAssigned(unit) or "NONE"
	self:Debug("UpdateUnit", event, unit, role)

	local settings = self.db.profile.role
	local roleSettings = settings[role]

	if roleSettings and roleSettings.enable and not (roleSettings.hideInCombat and UnitAffectingCombat("player")) then
		self.core:SendStatusGained(guid, "role",
			settings.priority,
			nil, -- range
			roleSettings.color,
			roleSettings.text,
			nil, -- value
			nil, -- maxValue
			ROLE_TEXTURE,
			nil, -- start
			nil, -- duration
			nil, -- count
			ROLE_TEXCOORDS[role]
		)
	else
		self.core:SendStatusLost(guid, "role")
	end
end

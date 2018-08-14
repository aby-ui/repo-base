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
local L = Grid.L
local Layout = Grid:GetModule("GridLayout")
local Roster = Grid:GetModule("GridRoster")

-- nameList = "",
-- groupFilter = "",
-- sortMethod = "INDEX", -- or "NAME"
-- sortDir = "ASC", -- or "DESC"
-- strictFiltering = false,
-- unitsPerColumn = 5, -- treated specifically to do the right thing when available
-- maxColumns = 5, -- mandatory if unitsPerColumn is set, or defaults to 1
-- isPetGroup = true, -- special case, not part of the Header API

local Layouts = {
	None = {
		name = L["None"],
	},
	ByGroup = {
		name = L["By Group"],
		defaults = {
			sortMethod = "INDEX",
			unitsPerColumn = 5,
			maxColumns = 1,
		},
		[1] = {
			groupFilter = "1",
		},
		-- additional groups added/removed dynamically
	},
	ByClass = {
		name = L["By Class"],
		defaults = {
			groupBy = "CLASS",
			groupingOrder = "WARRIOR,DEATHKNIGHT,DEMONHUNTER,ROGUE,MONK,PALADIN,DRUID,SHAMAN,PRIEST,MAGE,WARLOCK,HUNTER",
			sortMethod = "NAME",
			unitsPerColumn = 5,
		},
		[1] = {
			groupFilter = "1", -- updated dynamically
		},
	},
	ByRole = {
		name = L["By Role"],
		defaults = {
			groupBy = "ASSIGNEDROLE",
			groupingOrder = "TANK,HEALER,DAMAGER,NONE",
			sortMethod = "NAME",
			unitsPerColumn = 5,
		},
		[1] = {
			groupFilter = "1", -- updated dynamically
		},
	}
}
--[===[@debug@
GRIDLAYOUTS = Layouts
--@end-debug@]===]

Layout._defaultLayouts = Layouts --163ui

--------------------------------------------------------------------------------

local Manager = Layout:NewModule("GridLayoutManager", "AceEvent-3.0")
Manager.Debug = Grid.Debug -- GridLayout doesn't have a module prototype

function Manager:OnInitialize()
	self:Debug("OnInitialize")

	Grid:SetDebuggingEnabled(self.moduleName)

	for k, v in pairs(Layouts) do
		Layout:AddLayout(k, v)
	end

	self:RegisterMessage("Grid_RosterUpdated", "UpdateLayouts")
end

--------------------------------------------------------------------------------

local function AddPetGroup(t, groupFilter, numGroups)
--[===[@debug@
	assert(t == nil or type(t) == "table")
	assert(type(groupFilter) == "string")
	assert(string.len(groupFilter) > 0 and string.len(groupFilter) % 2 == 1)
	assert(type(numGroups) == "number")
	assert(numGroups == (1 + string.len(groupFilter)) / 2)
--@end-debug@]===]
	t = t or {}
	t.groupFilter = groupFilter
	t.maxColumns = numGroups

	t.isPetGroup = true
	t.groupBy = "CLASS"
	t.groupingOrder = "HUNTER,WARLOCK,MAGE,DEATHKNIGHT,DRUID,PRIEST,SHAMAN,MONK,PALADIN,DEMONHUNTER,ROGUE,WARRIOR"
	-- t.sortMethod = "NAME"

	return t
end


local function UpdateSplitGroups(layout, groupFilter, numGroups, showPets)
--[===[@debug@
	assert(type(layout) == "table")
	assert(type(groupFilter) == "string")
	assert(string.len(groupFilter) > 0 and string.len(groupFilter) % 2 == 1)
	assert(type(numGroups) == "number")
	assert(numGroups == (1 + string.len(groupFilter)) / 2)
--@end-debug@]===]

	for i = 1, numGroups do
		local t = layout[i] or {}
		layout[i] = t

		t.groupFilter = string.sub(groupFilter, i * 2 - 1, i * 2)

		-- Reset attributes from merged layout
		t.maxColumns = 1

		-- Remove attributes for pet group
		t.isPetGroup = nil
		t.groupBy = nil
		t.groupingOrder = nil
	end

	if showPets then
		local i = numGroups + 1
		layout[i] = AddPetGroup(layout[i], groupFilter, numGroups)
		numGroups = i
	end

	for i = numGroups + 1, #layout do
		layout[i] = nil
	end
end


local function UpdateMergedGroups(layout, groupFilter, numGroups, showPets)
--[===[@debug@
	assert(type(layout) == "table")
	assert(type(groupFilter) == "string")
	assert(string.len(groupFilter) > 0 and string.len(groupFilter) % 2 == 1)
	assert(type(numGroups) == "number")
	assert(numGroups == (1 + string.len(groupFilter)) / 2)
--@end-debug@]===]

	layout[1].groupFilter = groupFilter
	layout[1].maxColumns = numGroups

	layout[2] = showPets and AddPetGroup(layout[2], groupFilter, numGroups) or nil

	for i = 3, numGroups do
		layout[i] = nil
	end
end


local hideGroup = {}

function Manager:GetGroupFilter()
	local groupType, maxPlayers = Roster:GetPartyState()
	self:Debug("groupType", groupType, "maxPlayers", maxPlayers)

	if groupType ~= "raid" and groupType ~= "bg" then
		return "1", 1
	end

	local showOffline = Layout.db.profile.showOffline
	local showWrongZone = Layout:ShowWrongZone()
	local curMapID = C_Map.GetBestMapForUnit("player")

	for i = 1, MAX_RAID_GROUPS do
		hideGroup[i] = ""
	end

	for i = 1, GetNumGroupMembers() do
		local name, _, subgroup, _, _, _, _, online = GetRaidRosterInfo(i)
		local mapID = C_Map.GetBestMapForUnit("raid" .. i)
		if (showOffline or online) and (showWrongZone or curMapID == mapID) then
			hideGroup[subgroup] = nil
--[===[@debug@
		elseif curMapID ~= mapID and not showWrongZone then
			hideGroup[subgroup] = (hideGroup[subgroup] or "") .. " ZONE"
		elseif not online and not showOffline then
			hideGroup[subgroup] = (hideGroup[subgroup] or "") .. " OFFLINE"
--@end-debug@]===]
		end
	end

	local groupFilter, numGroups = "", 0
	for i = 1, MAX_RAID_GROUPS do
		if not hideGroup[i] then
			groupFilter = groupFilter .. "," .. i
			numGroups = numGroups + 1
--[===[@debug@
		else
			self:Debug("Group", i, "hidden:", hideGroup[i])
--@end-debug@]===]
		end
	end
	return groupFilter:sub(2), numGroups
end


local lastNumGroups, lastGroupFilter, lastShowPets

function Manager:UpdateLayouts(event)
	self:Debug("UpdateLayouts", event)

	local groupFilter, numGroups = self:GetGroupFilter()
	local showPets = Layout.db.profile.showPets
	local splitGroups = Layout.db.profile.splitGroups

	self:Debug("groupFilter", groupFilter, "numGroups", numGroups, "showPets", showPets, "splitGroups", splitGroups)

	if lastGroupFilter == groupFilter and lastShowPets == showPets then
		self:Debug("No changes necessary")
		return false
	end

	lastGroupFilter = groupFilter
	lastShowPets = showPets

	-- Update class and role layouts
	if splitGroups then
		UpdateSplitGroups(Layouts.ByClass,  groupFilter, numGroups, showPets)
		UpdateSplitGroups(Layouts.ByRole,   groupFilter, numGroups, showPets)
	else
		UpdateMergedGroups(Layouts.ByClass, groupFilter, numGroups, showPets)
		UpdateMergedGroups(Layouts.ByRole,  groupFilter, numGroups, showPets)
	end

	-- Update group layout (always split)
	UpdateSplitGroups(Layouts.ByGroup, groupFilter, numGroups, showPets)

	-- Apply changes
	Layout:ReloadLayout()

	return true
end

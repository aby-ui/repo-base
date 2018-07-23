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

local lastNumGroups, lastUsedGroups, lastShowPets

local function AddPetGroup(t, numGroups, groupFilter)
	t = t or {}
	t.groupFilter = groupFilter
	t.maxColumns = numGroups

	t.isPetGroup = true
	t.groupBy = "CLASS"
	t.groupingOrder = "HUNTER,WARLOCK,MAGE,DEATHKNIGHT,DRUID,PRIEST,SHAMAN,MONK,PALADIN,DEMONHUNTER,ROGUE,WARRIOR"
	-- t.sortMethod = "NAME"

	return t
end

local function UpdateSplitGroups(layout, numGroups, showPets)
	for i = 1, numGroups do
		local t = layout[i] or {}
		t.groupFilter = tostring(i)
		-- Reset attributes from merged layout
		t.maxColumns = 1
		-- Remove attributes for pet group
		t.isPetGroup = nil
		t.groupBy = nil
		t.groupingOrder = nil
		layout[i] = t
	end
	if showPets then
		local i = numGroups + 1
		layout[i] = AddPetGroup(layout[i], numGroups, groupFilter)
		numGroups = i
	end
	for i = numGroups + 1, #layout do
		layout[i] = nil
	end
end

local function UpdateMergedGroups(layout, numGroups, showPets)
	layout[1].groupFilter = groupFilter
	layout[1].maxColumns = numGroups
	if showPets then
		layout[2] = AddPetGroup(layout[2], numGroups, groupFilter)
	else
		layout[2] = nil
	end
	for i = 3, numGroups do
		layout[i] = nil
	end
end

-- These are the number of groups actually used
local function UpdateNumGroups()
	local groupType, maxPlayers = Roster:GetPartyState()
	local usedGroups = {}
	local numGroups = 0
	local realGroups = 1
	-- local curZone = GetRealZoneText()
	-- GetCurrentMapAreaID does not match the mapID from UnitPosition
	-- local curMapID = GetCurrentMapAreaID()
	local _, _, _, curMapID = UnitPosition("player")
	local showOffline = Layout.db.profile.showOffline -- Show Offline groups
	-- Debug
	local offlineGroups = {}
	local zoneGroups = {}
	local showWrongZone = Layout:ShowWrongZone()

	-- Manager:Debug("Layout.db.profile.showWrongZone ", Layout.db.profile.showWrongZone, ", showWrongZone ", showWrongZone, ", groupType ", groupType) 

	if groupType == "raid" or groupType == "bg" then
		if maxPlayers then
			numGroups = ceil(maxPlayers / 5)
		else
			numGroups = 1
		end

		for i = 1, 8 do
			usedGroups[i] = false
		end
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, zone, online = GetRaidRosterInfo(i);
			local unitid = "raid" .. i
			local _, _, _, mapID = UnitPosition(unitid)
			-- If the highest group only has offline players it will not be shown
			-- if name and online then
			-- usedGroups[subgroup] = true
			if name then
				-- GetRaidRosterInfo zone comparison can show players in the same instance
				-- when they are not.  For example, outside Hellfire Citadel still shows
				-- "Hellfire Citadel" as the zone text.
				-- if (showOffline or online) and (showWrongZone or curZone == zone) then
				-- Manager:Debug("curMapID ", curMapID, " name ", name, " mapID ", mapID)
				if (showOffline or online) and (showWrongZone or curMapID == mapID) then
					usedGroups[subgroup] = true
				else
					if (not online) then
					   offlineGroups[subgroup] = true
					end
					-- if (curZone ~= zone) then
					if (curMapID ~= mapID) then
					   zoneGroups[subgroup] = true
					end
				end
			end
		end
		for i = 1, 8 do
			if usedGroups[i] and i > realGroups then
				-- realGroups = numGroups + 1
				realGroups = i
			end
			-- Debug
			if not usedGroups[i] and offlineGroups[i] then
				Manager:Debug("Group ", i, "is not used because players were offline.")
			elseif not usedGroups[i] and zoneGroups[i] then
				Manager:Debug("Group ", i, "is not used because players were in wrong zone.")
			end
		end
	else
		numGroups = 1
 	end
	return numGroups, realGroups
end


function Manager:UpdateLayouts(event)
	self:Debug("UpdateLayouts", event)

	local groupType, maxPlayers = Roster:GetPartyState()
	local showPets = Layout.db.profile.showPets -- Show Pets
	local splitGroups = Layout.db.profile.splitGroups -- Keep Groups Together

	-- local numGroups, groupFilter = ceil(maxPlayers / 5), "1"
	-- for i = 2, numGroups do
	-- 	groupFilter = groupFilter .. "," .. i
	-- end
	local numGroups = 1
	local usedGroups = 1

	if groupType == "raid" or groupType == "bg" then
		numGroups, usedGroups = UpdateNumGroups()
	elseif maxPlayers then
		numGroups = ceil(maxPlayers / 5)
		usedGroups = numGroups
	end

	self:Debug("maxPlayers", maxPlayers, "numGroups", numGroups, "usedGroups", usedGroups, "showPets", showPets, "splitGroups", splitGroups)

	if lastNumGroups == numGroups and lastUsedGroups == usedGroups and lastShowPets == showPets then
		self:Debug("no changes necessary")
		return false
	end

	lastNumGroups = numGroups
	lastUsedGroups = usedGroups
	lastShowPets = showPets

	-- Update class and role layouts
--[===[@debug@
	if splitGroups then
		UpdateSplitGroups(Layouts.ByClass,  numGroups, showPets)
		UpdateSplitGroups(Layouts.ByRole,   numGroups, showPets)
	else
--@end-debug@]===]
		UpdateMergedGroups(Layouts.ByClass, numGroups, showPets)
		UpdateMergedGroups(Layouts.ByRole,  numGroups, showPets)
--[===[@debug@
	end
--@end-debug@]===]

	-- By group should always be split group
	UpdateSplitGroups(Layouts.ByGroup, usedGroups, showPets)

	-- Apply changes
	Layout:ReloadLayout()

	return true
end



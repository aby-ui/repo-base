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
	GridRoster.lua
	Keeps track of GUID <-> name <-> unitID mappings for party/raid members.
----------------------------------------------------------------------]]

local GRID, Grid = ...
local L = Grid.L

local GridRoster = Grid:NewModule("GridRoster")

GridRoster.defaultDB = {
	party_state = "solo",
}

------------------------------------------------------------------------

local UnitExists = UnitExists
local UnitName = UnitName
local UnitGUID = UnitGUID

local _, my_realm = UnitFullName("player")

------------------------------------------------------------------------

-- roster[attribute_name][guid] = value
local roster = {
	name = {},
	realm = {},
	unitid = {},
	guid = {},
}

-- for debugging
GridRoster.roster = roster

------------------------------------------------------------------------

-- unit tables
local party_units = {}
local raid_units = {}
local pet_of_unit = {}
local owner_of_unit = {}

do
	-- populate unit tables
	local function register_unit(tbl, unit, pet)
		tinsert(tbl, unit)
		pet_of_unit[unit] = pet
		owner_of_unit[pet] = unit
	end

	register_unit(party_units, "player", "pet")

	for i = 1, MAX_PARTY_MEMBERS do
		register_unit(party_units, "party"..i, "partypet"..i)
	end

	for i = 1, MAX_RAID_MEMBERS do
		register_unit(raid_units, "raid"..i, "raidpet"..i)
	end
end

------------------------------------------------------------------------

function GridRoster:PostInitialize()
	for attr, attr_tbl in pairs(roster) do
		for k in pairs(attr_tbl) do
			attr_tbl[k] = nil
		end
	end
end

function GridRoster:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self:RegisterEvent("UNIT_PET", "UpdateRoster")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateRoster")
	self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateRoster")
    self:RegisterEvent("PARTY_MEMBER_ENABLE", "UpdateRoster")
    self:RegisterEvent("PARTY_MEMBER_DISABLE", "UpdateRoster")
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdateRoster")
    self:RegisterEvent("GROUP_JOINED", "UpdateRoster")
    self:RegisterEvent("GROUP_LEFT", "UpdateRoster")
    self:RegisterEvent("UNIT_OTHER_PARTY_CHANGED", "UpdateRoster")

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "PartyTransitionCheck")

	self:UpdateRoster()
end

------------------------------------------------------------------------

function GridRoster:GetGUIDByName(name, realm)
	if realm == my_realm or realm == "" then realm = nil end
	for guid, unit_name in pairs(roster.name) do
		if name == unit_name and roster.realm[guid] == realm then
			return guid
		end
	end
end

function GridRoster:GetNameByGUID(guid)
	return roster.name[guid], roster.realm[guid]
end

function GridRoster:GetGUIDByFullName(full_name)
	local name, realm = full_name:match("^([^%-]+)%-(.*)$")
	return self:GetGUIDByName(name or full_name, realm)
end

function GridRoster:GetFullNameByGUID(guid)
	local name, realm = self:GetNameByGUID(guid)

	if realm then
		return name .. "-" .. realm
	else
		return name
	end
end

function GridRoster:GetUnitidByGUID(guid)
	return roster.unitid[guid]
end

function GridRoster:GetOwnerUnitidByGUID(guid)
	local unitid = roster.unitid[guid]
	return owner_of_unit[unitid]
end

function GridRoster:GetPetUnitidByUnitid(unitid)
	return pet_of_unit[unitid]
end

function GridRoster:GetOwnerUnitidByUnitid(unitid)
	return owner_of_unit[unitid]
end

function GridRoster:IsGUIDInGroup(guid)
	return roster.guid[guid] ~= nil
end
GridRoster.IsGUIDInRaid = GridRoster.IsGUIDInGroup -- deprecated

function GridRoster:IterateRoster()
	return pairs(roster.unitid)
end

------------------------------------------------------------------------

-- roster updating
do
	local units_to_remove = {}
	local units_added = {}
	local units_updated = {}

	local function UpdateUnit(unit)
		local name, realm = UnitName(unit)
		local guid = UnitGUID(unit)

		if guid then
			if realm == "" then realm = nil end

			if units_to_remove[guid] then
				units_to_remove[guid] = nil

				local old_name = roster.name[guid]
				local old_realm = roster.realm[guid]
				local old_unitid = roster.unitid[guid]

				if old_name ~= name or old_realm ~= realm or
					old_unitid ~= unit then
					units_updated[guid] = true
				end
			else
				units_added[guid] = true
			end

			roster.name[guid] = name
			roster.realm[guid] = realm
			roster.unitid[guid] = unit
			roster.guid[guid] = guid
		end
	end

	function GridRoster:PLAYER_ENTERING_WORLD()
		local old_state = self.db.profile.party_state
		-- handle jumping from one BG to another
		-- arenas too, just to be safe
		if old_state == "bg" or old_state == "arena" then
			self.db.profile.party_state = "solo"
		end

		return self:UpdateRoster()
	end

	function GridRoster:UpdateRoster()
		for guid, unit in pairs(roster.unitid) do
			units_to_remove[guid] = true
		end

		local units = IsInRaid() and raid_units or party_units

		for i = 1, #units do
			local unit = units[i]
			if unit and UnitExists(unit) then
				UpdateUnit(unit)

				local unitpet = pet_of_unit[unit]
				if unitpet and UnitExists(unitpet) then
					UpdateUnit(unitpet)
				end
			end
		end

		local updated = false

		for guid in pairs(units_to_remove) do
			updated = true
			self:SendMessage("Grid_UnitLeft", guid)

			for attr, attr_tbl in pairs(roster) do
				attr_tbl[guid] = nil
			end

			units_to_remove[guid] = nil
		end

		self:PartyTransitionCheck()

		for guid in pairs(units_added) do
			updated = true
			self:SendMessage("Grid_UnitJoined", guid, roster.unitid[guid])

			units_added[guid] = nil
		end

		for guid in pairs(units_updated) do
			updated = true
			self:SendMessage("Grid_UnitChanged", guid, roster.unitid[guid])

			units_updated[guid] = nil
		end

		if updated then
			self:SendMessage("Grid_RosterUpdated")
		end
	end
end

------------------------------------------------------------------------

-- Party transitions
do
	GridRoster.party_states = {
		"solo",
		"party",
		"raid",
		"arena",
		"bg",
	}

	local function GetPartyState()
		local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
		if maxPlayers == 0 then
			maxPlayers = nil
		end
		if instanceType == "arena" then
			return "arena", maxPlayers or 5
		elseif instanceType == "pvp" or (instanceType == "none" and GetZonePVPInfo() == "combat") then
			return "bg", maxPlayers or 40
		elseif maxPlayers == 1 or not IsInGroup() then -- treat solo scenarios as solo, not party or raid
			return "solo", 1
		elseif IsInRaid() then
			if instanceType == "none" then
				-- GetInstanceInfo reports maxPlayers = 5 in Broken Isles
				maxPlayers = 40
			end
			return "raid",  maxPlayers and maxPlayers > 5 and maxPlayers or 40
		else
			return "party", 5
		end
	end

	local last_maxPlayers

	function GridRoster:PartyTransitionCheck()
		local current_state, maxPlayers = GetPartyState()
		local old_state = self.db.profile.party_state
		if current_state ~= old_state or last_maxPlayers ~= maxPlayers then
			self.db.profile.party_state = current_state
			last_maxPlayers = maxPlayers
			self:SendMessage("Grid_PartyTransition", current_state, old_state)
		end
	end

	function GridRoster:GetPartyState()
		if last_maxPlayers then
			return self.db.profile.party_state, last_maxPlayers
		else
			return GetPartyState()
		end
	end
end

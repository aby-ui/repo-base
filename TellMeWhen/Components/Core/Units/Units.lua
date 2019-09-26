-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L

local print = TMW.print
local strlowerCache = TMW.strlowerCache

local tonumber, pairs, ipairs, wipe, assert =
      tonumber, pairs, ipairs, wipe, assert
local strfind, strmatch, strtrim, gsub, gmatch, strsplit, abs =
      strfind, strmatch, strtrim, gsub, gmatch, strsplit, abs
local GetNumRaidMembers, GetNumPartyMembers =
      GetNumRaidMembers, GetNumPartyMembers
local UnitName, UnitExists =
      UnitName, UnitExists
local GetPartyAssignment, GetNumGroupMembers, GetNumSubgroupMembers, IsInRaid =
      GetPartyAssignment, GetNumGroupMembers, GetNumSubgroupMembers, IsInRaid

local _, pclass = UnitClass("Player")
local pname = UnitName("player")


local UNITS = TMW:NewModule("Units", "AceEvent-3.0")

TMW.UNITS = UNITS

UNITS.mtMap, UNITS.maMap = {}, {}
UNITS.gpMap = {}
UNITS.unitsWithExistsEvent = {}
local unitsWithExistsEvent = UNITS.unitsWithExistsEvent
UNITS.unitsWithBaseExistsEvent = {}

UNITS.Units = {
	{ value = "player",				text = PLAYER, 											desc = L["PLAYER_DESC"] },
	{ value = "target",				text = TARGET														},
	{ value = "targettarget",		text = L["ICONMENU_TARGETTARGET"]									},
	{ value = "focus",				text = L["ICONMENU_FOCUS"]											},
	{ value = "focustarget",		text = L["ICONMENU_FOCUSTARGET"]									},
	{ value = "pet",				text = PET 															},
	{ value = "pettarget",			text = L["ICONMENU_PETTARGET"]										},
	{ value = "mouseover",			text = L["ICONMENU_MOUSEOVER"]										},
	{ value = "mouseovertarget",	text = L["ICONMENU_MOUSEOVERTARGET"]								},
	{ value = "vehicle",			text = L["ICONMENU_VEHICLE"]										},
	{ value = "nameplate",			text = L["ICONMENU_NAMEPLATE"],	range = 30							},
	{ value = "party",				text = PARTY,				range = MAX_PARTY_MEMBERS				},
	{ value = "raid",				text = RAID,				range = MAX_RAID_MEMBERS				},
	{ value = "group",				text = GROUP,				range = MAX_RAID_MEMBERS,	desc = L["ICONMENU_GROUPUNIT_DESC"]	},
	{ value = "arena",				text = ARENA,				range = 5								},
	{ value = "boss",				text = BOSS,				range = MAX_BOSS_FRAMES					},
	{ value = "maintank",			text = L["MAINTANK"],		range = MAX_RAID_MEMBERS,	desc = L["MAINTANK_DESC"]			},
	{ value = "mainassist",			text = L["MAINASSIST"],		range = MAX_RAID_MEMBERS,	desc = L["MAINASSIST_DESC"]				},
}


local TEMP_conditionsSettingSource
local TEMP_conditionsParents


-- Public Methods/Stuff:
function TMW:GetUnits(icon, setting, Conditions)
	local iconName = (icon and icon:GetName() or "<icon>")
	assert(setting, "Setting was nil for TMW:GetUnits(" .. iconName .. ", setting)")
	
	-- Dirty, dirty hack to make sure the function cacher generates new UnitSets for any changes in conditions
	TEMP_conditionsSettingSource = Conditions
	
	local serializedConditions
	if Conditions then
		serializedConditions = TMW:Serialize(Conditions)
		if serializedConditions:find("thisobj") then
			serializedConditions = serializedConditions .. iconName
			TEMP_conditionsParents = icon
		end
	end

	local UnitSet = UNITS:GetUnitSet(setting, serializedConditions)
	
	TEMP_conditionsSettingSource = nil
	TEMP_conditionsParents = nil
	
	if UnitSet.ConditionObjects then
		for i, ConditionObject in ipairs(UnitSet.ConditionObjects) do
			ConditionObject:RequestAutoUpdates(UnitSet, true)
		end

		-- Register for state changes AFTER requesting updates.
		-- Requesting updates will trigger checks on all the objects.
		-- We don't want each check to update the unit set one by one.
		-- We'll update after they're all registered.
		TMW:RegisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", UnitSet)
	end

	-- Perform an update now that all of the conditions (if any) are in their initial state.
	UnitSet:Update()

	return UnitSet.exposedUnits, UnitSet
end


-- Private Methods/Stuff:
local UnitSet = TMW:NewClass("UnitSet"){
	UnitExists = function(self, unit)
		return unitsWithExistsEvent[unit] or UnitExists(unit)
	end,

	OnNewInstance = function(self, unitSettings, Conditions, parent)
		self.Conditions = Conditions
		self.parent = parent
		
		self.UnitsLookup = {}
		self.unitSettings = unitSettings
		self.originalUnits = UNITS:GetOriginalUnitTable(unitSettings)
		self.updateEvents = {PLAYER_ENTERING_WORLD = true,}
		self.exposedUnits = {}
		self.translatedUnits = {}
		self.allUnitsChangeOnEvent = true

		-- determine the operations that the set needs to stay updated
		for k, unit in ipairs(self.originalUnits) do
			unit = tostring(unit)

			if unit == "player" then
				--UNITS.unitsWithExistsEvent[unit] = true -- doesnt really have an event, 
				-- but do this for external checks of unitsWithExistsEvent to increase efficiency.
				-- if someone legitimately entered "playertarget" then they probably dont deserve to have increased eficiency... 
				-- dont bother handling player as a base unit

			elseif unit == "target" then -- the unit exactly
				self.updateEvents.PLAYER_TARGET_CHANGED = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^target") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.PLAYER_TARGET_CHANGED = true
				UNITS.unitsWithBaseExistsEvent[unit] = "target"
				self.allUnitsChangeOnEvent = false

			elseif unit == "pet" then -- the unit exactly
				self.updateEvents.UNIT_PET = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^pet") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.UNIT_PET = true
				UNITS.unitsWithBaseExistsEvent[unit] = "pet"
				self.allUnitsChangeOnEvent = false

			elseif unit == "focus" then -- the unit exactly
				self.updateEvents.PLAYER_FOCUS_CHANGED = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^focus") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.PLAYER_FOCUS_CHANGED = true
				UNITS.unitsWithBaseExistsEvent[unit] = "focus"
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^raid%d+$") then -- the unit exactly
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^raid%d+") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true
				UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(raid%d+)")
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^party%d+$") then -- the unit exactly
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^party%d+") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true
				UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(party%d+)")
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^boss%d+$") then -- the unit exactly
				self.updateEvents.INSTANCE_ENCOUNTER_ENGAGE_UNIT = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^boss%d+") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.INSTANCE_ENCOUNTER_ENGAGE_UNIT = true
				UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(boss%d+)")
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^arena%d+$") then -- the unit exactly
				self.updateEvents.ARENA_OPPONENT_UPDATE = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^arena%d+") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.ARENA_OPPONENT_UPDATE = true
				UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(arena%d+)")
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^nameplate%d+$") then -- the unit exactly
				self.updateEvents.NAME_PLATE_UNIT_ADDED = true
				self.updateEvents.NAME_PLATE_UNIT_REMOVED = true
				UNITS.unitsWithExistsEvent[unit] = true
			elseif unit:find("^nameplate%d+") then -- the unit as a base, with something else tacked onto it.
				self.updateEvents.NAME_PLATE_UNIT_ADDED = true
				self.updateEvents.NAME_PLATE_UNIT_REMOVED = true
				UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(nameplate%d+)")
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^maintank") or unit:find("^mainassist") then
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true

				UNITS:UpdateTankAndAssistMap()
				self.hasSpecialUnitRefs = true
				UNITS.doTankAndAssistMap = true

				if (unit:find("^maintank%d+$") or unit:find("^mainassist%d+$")) then
					UNITS.unitsWithExistsEvent[unit] = true
				else
					self.allUnitsChangeOnEvent = false
					UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(main[a-z]+d+)")
				end


			elseif unit:find("^group%d+") then
				self.updateEvents["GROUP_ROSTER_UPDATE"] = true

				self.hasSpecialUnitRefs = true

				if unit:find("^group%d+$") then
					UNITS.unitsWithExistsEvent[unit] = true
				else
					self.allUnitsChangeOnEvent = false
					UNITS.unitsWithBaseExistsEvent[unit] = unit:match("^(group%d+)")
				end

			elseif unit:find("^vehicle") then
				-- TODO: This isn't strictly true.
				-- There might actually be events that work, but I don't feel like finding them at the moment.
				self.allUnitsChangeOnEvent = false

			elseif unit:find("^mouseover") then
				-- There is a unit when you gain a mouseover, but there isn't one when you lose it, so we can't have events for this one.
				self.allUnitsChangeOnEvent = false
				
			else
				-- we found a unit and we dont really know what the fuck it is.
				-- it MIGHT be a player name (or a derrivative thereof),
				-- so register some events so that we can exchange it out with a real unitID when possible.

				self.updateEvents["GROUP_ROSTER_UPDATE"] = true
				self.updateEvents.UNIT_PET = true
				UNITS.doGroupedPlayersMap = true

				self.mightHaveWackyUnitRefs = true
				UNITS:UpdateGroupedPlayersMap()

				self.allUnitsChangeOnEvent = false
			end
		end

		-- Setup conditions
		if Conditions and Conditions.n > 0 then
			for k, unit in ipairs(self.originalUnits) do
				-- Get a constructor to make the ConditionObject
				local ConditionObjectConstructor = self:Conditions_GetConstructor(Conditions)

				-- Override the parent used for the conditions (for Lua conditions mainly)
				ConditionObjectConstructor.parent = parent or self
				
				-- Modify the conditions:
				-- Add a UnitExists condition to the beginning, so the rest of the conditions
				-- will short circuit to false if the unit being checked doesn't exist.
				local ModifiableConditions = ConditionObjectConstructor:GetPostUserModifiableConditions()
				local exists = ConditionObjectConstructor:Modify_WrapExistingAndPrependNew()
				exists.Type = "EXISTS"
				exists.Unit = "unit" -- this will get replaced momentarily
				ModifiableConditions[2].AndOr = "AND" -- AND together the exists condition and all subsequent conditions.

				-- Substitute out "unit" with the actual unit being checked.
				for _, condition in TMW:InNLengthTable(ModifiableConditions) do
					condition.Unit = condition.Unit
					:gsub("^unit", unit .. "-")
					:gsub("%-%-", "-")
					:gsub("%-%-", "-")
					:trim("-")
				end

				-- Modifications are done. Construct the ConditionObject
				local ConditionObject = ConditionObjectConstructor:Construct()

				if ConditionObject then
					self.ConditionObjects = self.ConditionObjects or {}
					self.ConditionObjects[k] = ConditionObject
					self.ConditionObjects[ConditionObject] = k
				end
			end
		end

		for event in pairs(self.updateEvents) do
			UNITS:RegisterEvent(event, "OnEvent")
		end

		-- This call will end up being redundant
		-- with the update done in TMW:GetUnits(), 
		-- but I'm leaving it here in case anyone
		-- was manually creating a UnitSet.
		self:Update()
	end,

	TMW_CNDT_OBJ_PASSING_CHANGED = function(self, event, ConditionObject, failed)
		if self.ConditionObjects[ConditionObject] then
			self:Update()
		end
	end,

	Update = function(self, forceNoExists)
		local originalUnits,      exposedUnits,      translatedUnits =
		      self.originalUnits, self.exposedUnits, self.translatedUnits
		local UnitsLookup = self.UnitsLookup
		local hasSpecialUnitRefs = self.hasSpecialUnitRefs
		local mightHaveWackyUnitRefs = self.mightHaveWackyUnitRefs

		local ConditionObjects = self.ConditionObjects


		local old_len = #exposedUnits
		local exposed_len = 0
		local changed = false
		
		-- We must wipe UnitsLookup because we can't surgically update it
		-- as we iterate. Attempts to do so in the past (before the commit that added this comment)
		-- caused a bug that led to units being removed from UnitsLookup when in fact they still 
		-- should have been there. This was triggered when lower-index units would become no longer exposed,
		-- shifting all units downwards in the exposedUnits table, leading to an issue when clearing out any
		-- units past the new maximum index of exposedUnits.
		wipe(UnitsLookup)

		for k = 1, #originalUnits do
			local unit = originalUnits[k]

			local subbedUnit

			-- Handles maintank and mainassist units.
			if hasSpecialUnitRefs then
				-- Try to sub it out for a real unitID.
				subbedUnit = UNITS:SubstituteSpecialUnit(unit)
			end

			-- Wacky units are the ones that we don't know anything about.
			-- These include player names and anything else that has no known base unit.
			if subbedUnit == nil and mightHaveWackyUnitRefs then
				-- Try to sub a player name with a unitID.
				subbedUnit = UNITS:SubstituteGroupedUnit(unit)
			end

			if subbedUnit then
				unit = subbedUnit
			end

			if subbedUnit ~= false then
				-- If subbedUnit isn't false, then the unit didn't need to be subbed,
				-- or it was successfully subbed.
				translatedUnits[k] = unit
			else
				translatedUnits[k] = nil
			end

			local hasExistsEvent = UNITS.unitsWithExistsEvent[unit]
			local baseUnit = UNITS.unitsWithBaseExistsEvent[unit]

			if
					-- Don't expose the unit if it was supposed to be subbed,
					-- but didn't get subbed because it didn't exist. 
					-- subbedUnit will be false if this is what happened.
					-- If it was subbed, its a string, and if it didnt need to be subbed, it will be nil.
					subbedUnit ~= false

					-- Don't expose the unit if the caller knows that this unit actually doesn't exist.
				and forceNoExists ~= unit
				
					-- Don't expose the unit if it has conditions and those conditions failed
				and (not ConditionObjects or not ConditionObjects[k] or not ConditionObjects[k].Failed)

					-- Don't expose the unit if it (doesnt exist and has events that fire when it starts to exist)
					-- or if (it has a base unit and its base unit doesn't exist -- all base units have exists events)
				and ((baseUnit and UnitExists(baseUnit)) or (not baseUnit and (not hasExistsEvent or UnitExists(unit))))

			then
				UnitsLookup[unit] = true
				if exposedUnits[exposed_len+1] ~= unit then
					exposedUnits[exposed_len+1] = unit
					changed = true
				end
				exposed_len = exposed_len + 1
			end
		end

		-- Clear out the rest of the table.
		for k = exposed_len+1, #exposedUnits do
			exposedUnits[k] = nil
		end

		-- This should only happen if exposed_len < old_len, i.e. we are now exposing less units
		if old_len ~= exposed_len then
			changed = true
		end
		
		if changed then
			TMW:Fire("TMW_UNITSET_UPDATED", self)
		end

		return changed
	end,
}

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	for i, unitSet in ipairs(UnitSet.instances) do
		if unitSet.ConditionObjects then
			for i, ConditionObject in ipairs(unitSet.ConditionObjects) do
				ConditionObject:RequestAutoUpdates(unitSet, false)
			end
			TMW:UnregisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", unitSet)
		end
	end
end)

function UNITS:GetUnitSet(unitSettings, SerializedConditions)
	-- This is just a hack for the function cacher. Need a unique UnitSet for any variations in conditions.
	-- This value isn't actually used, so discard it.
	SerializedConditions = nil

	unitSettings = TMW:CleanString(unitSettings):
	lower(): -- all units should be lowercase
	gsub("[\r\n\t]", ""):
	gsub("|cffff0000", ""): -- strip color codes (NOTE LOWERCASE)
	gsub("|r", ""):
	gsub("#", "") -- strip the # from the dropdown
	
	return UnitSet:New(unitSettings, TEMP_conditionsSettingSource, TEMP_conditionsParents)
end
TMW:MakeNArgFunctionCached(2, UNITS, "GetUnitSet")

function UNITS:GetOriginalUnitTable(unitSettings)
	unitSettings = TMW:CleanString(unitSettings)
		:lower() -- all units should be lowercase
		-- Stripping color codes doesn't matter now since they aren't inserted now ("#" isnt inserted either)
		-- but keep this here for compatibility with old setups.
		:gsub("|cffff0000", "") -- strip color codes (NOTE LOWERCASE)
		:gsub("|r", "")
		:gsub("#", "") -- strip the # from the dropdown 
		.. " "


	--SUBSTITUTE "party" with "party1-4", etc
	--also handles conversion of "party 1" into "party1"
	local unitSettings_new = ""
	for _, wholething in TMW:Vararg(strsplit(";", unitSettings)) do
		local added = false

		local unit = strtrim(wholething)
		for k, unitData in pairs(UNITS.Units) do
			if unitData.value == unit and unitData.range then
				unitSettings_new = unitSettings_new .. "; " .. unit .. "1-" .. unitData.range
				added = true
				break
			end
		end

		if not added then
			
			-- This handles the conversion from "party 1" into "party1"
			-- we only do this if the unit has digits at the end because otherwise 
			-- it could break valid units that have spaces in them (i.e. checking by name).
			unit = unit:gsub(" +(%d+)$", "%1")

			unitSettings_new = unitSettings_new .. "; " .. unit
		end
	end
	unitSettings = TMW:CleanString(unitSettings_new)



	--SUBSTITUTE RAID1-10 WITH RAID1;RAID2;RAID3;...RAID10
	for wholething, unit, firstnum, lastnum, append in gmatch(unitSettings, "(([%a%d]+) ?(%d+) ?%- ?(%d+) ?([%a%d]*)) ?;?") do
		if unit and firstnum and lastnum then

			if abs(lastnum - firstnum) > 100 then
				TMW:Print("You can't track more than 100", unit, "units.")
			else
				local str = ""
				local order = firstnum > lastnum and -1 or 1
				
				for i = firstnum, lastnum, order do
					str = str .. unit .. i .. append .. ";"
				end
				
				str = strtrim(str, " ;")
				wholething = gsub(wholething, "%-", "%%-") -- need to escape the dash for it to work
				unitSettings = gsub(unitSettings, wholething, str, 1)
			end
		end
	end

	local Units = TMW:SplitNames(unitSettings, true) -- get a table of everything

	-- REMOVE DUPLICATES
	TMW.tRemoveDuplicates(Units)

	return Units
end
TMW:MakeSingleArgFunctionCached(UNITS, "GetOriginalUnitTable")

function UNITS:UpdateTankAndAssistMap()
	local mtMap, maMap = UNITS.mtMap, UNITS.maMap

	wipe(mtMap)
	wipe(maMap)

	-- setup a table with (key, value) pairs as (oldnumber, newnumber)
	-- oldnumber is 7 for raid7
	-- newnumber is 1 for raid7 when the current maintank/assist is the 1st one found, 2 for the 2nd one found, etc)
	
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local raidunit = "raid" .. i
			if GetPartyAssignment("MAINTANK", raidunit) then
				mtMap[#mtMap + 1] = i
			elseif GetPartyAssignment("MAINASSIST", raidunit) then
				maMap[#maMap + 1] = i
			end
		end
	end
end

function UNITS:UpdateGroupedPlayersMap()
	local gpMap = UNITS.gpMap

	wipe(gpMap)

	gpMap[strlowerCache[pname]] = "player"
	local petname = UnitName("pet")
	if petname then
		gpMap[strlowerCache[petname]] = "pet"
	end

	-- setup a table with (key, value) pairs as (name, unitID)
	
	if IsInRaid() then
		-- Raid Players
		local numRaidMembers = GetNumGroupMembers()
		for i = 1, numRaidMembers do
			local raidunit = "raid" .. i
			local name = UnitName(raidunit)
			gpMap[strlowerCache[name]] = raidunit
		end
	
		-- Raid Pets (Process after raid players so that players with names the same as pets dont get overwritten)
		for i = 1, numRaidMembers do
			local petunit = "raidpet" .. i
			local name = UnitName(petunit)
			if name then
				-- dont overwrite a player with a pet
				gpMap[strlowerCache[name]] = gpMap[strlowerCache[name]] or petunit
			end
		end
	end
	
	-- Party Players
	local numPartyMembers = GetNumSubgroupMembers()
	for i = 1, numPartyMembers do
		local raidunit = "party" .. i
		local name = UnitName(raidunit)
		gpMap[strlowerCache[name]] = raidunit
	end
	
	-- Party Pets (Process after party players so that players with names the same as pets dont get overwritten)
	for i = 1, numPartyMembers do
		local petunit = "party" .. i
		local name = UnitName(petunit)
		if name then
			-- dont overwrite a player with a pet
			gpMap[strlowerCache[name]] = gpMap[strlowerCache[name]] or petunit
		end
	end
end

function UNITS:OnEvent(event, arg1)

	if (event == "GROUP_ROSTER_UPDATE" or event == "RAID_ROSTER_UPDATE") and UNITS.doTankAndAssistMap then
		UNITS:UpdateTankAndAssistMap()
	end
	if UNITS.doGroupedPlayersMap
	and (
		event == "GROUP_ROSTER_UPDATE"
		or event == "RAID_ROSTER_UPDATE"
		or event == "PARTY_MEMBERS_CHANGED"
		or event == "UNIT_PET"
	) then
		UNITS:UpdateGroupedPlayersMap()
	end

	-- NAME_PLATE_UNIT_REMOVED fires while UnitExists is still true for the unit.
	-- We will pass this to Update() to force it to be treated as not existing.
	local forceNoExists = event == "NAME_PLATE_UNIT_REMOVED" and arg1

	local instances = UnitSet.instances
	for i = 1, #instances do
		local unitSet = instances[i]
		if unitSet.updateEvents[event] then
			if not unitSet:Update(forceNoExists) then
				-- If the units in the UnitSet didn't change, still fire a TMW_UNITSET_UPDATED to signal that they may have shuffled around a bit
				-- (for example, the player changed target, or raid members moved around)
				TMW:Fire("TMW_UNITSET_UPDATED", unitSet)
			end
		end
	end
end

function UNITS:SubstituteSpecialUnit(oldunit)
	if strfind(oldunit, "^group") then -- the old unit (group1)

		local newunit
		if IsInRaid() then
			newunit = gsub(oldunit, "group", "raid") -- the new unit (raid1) (number not changed yet)
		else
			local oldnumber = tonumber(strmatch(oldunit, "(%d+)")) -- the old number (1)
			if oldnumber == 1 then
				newunit = gsub(oldunit, "group", "player") -- the new unit (party1) (number not changed yet)
				newunit = gsub(newunit, oldnumber, "", 1)
			else
				newunit = gsub(oldunit, "group", "party") -- the new unit (party1) (number not changed yet)
				newunit = gsub(newunit, oldnumber, oldnumber - 1, 1)
			end
		end

		if UnitExists(newunit) then
			return newunit
		end

		-- Return false to signal it was in a form that should be replaced, but was not replaced.
		return false

	elseif strfind(oldunit, "^maintank") then -- the old unit (maintank1)
		local newunit = gsub(oldunit, "maintank", "raid") -- the new unit (raid1) (number not changed yet)
		local oldnumber = tonumber(strmatch(newunit, "(%d+)")) -- the old number (1)
		local newnumber = oldnumber and UNITS.mtMap[oldnumber] -- the new number(7)
		if newnumber then
			return gsub(newunit, oldnumber, newnumber, 1)
		end


		-- Return false to signal it was in a form that should be replaced, but was not replaced.
		return false

	elseif strfind(oldunit, "^mainassist") then
		local newunit = gsub(oldunit, "mainassist", "raid")
		local oldnumber = tonumber(strmatch(newunit, "(%d+)"))
		local newnumber = oldnumber and UNITS.maMap[oldnumber]
		if newnumber then
			return gsub(newunit, oldnumber, newnumber, 1)
		end

		
		-- Return false to signal it was in a form that should be replaced, but was not replaced.
		return false
	end

	-- nil is returned if the unit was not in the form that should be replaced.
	return nil
end

function UNITS:SubstituteGroupedUnit(oldunit)
	for groupedName, groupedUnitID in pairs(UNITS.gpMap) do
		local atBeginning = "^" .. groupedName
		if strfind(oldunit, atBeginning .. "$") or strfind(oldunit, atBeginning .. "%-.") then
			return gsub(oldunit, atBeginning .. "%-?", groupedUnitID)
		end
	end

	-- nil is returned if oldunit was not a grouped unit
	return nil
end


do--function UNITS:TestUnit(unit)
	local TestTooltip = CreateFrame("GameTooltip")
	local name, unitID
	TestTooltip:SetScript("OnTooltipSetUnit", function(self)
		name, unitID = self:GetUnit()
	end)

	function UNITS:TestUnit(unit)
		name, unitID = nil
		
		TestTooltip:SetUnit(unit)
		
		return unitID
	end
end


do
	local CNDT = TMW.CNDT
	CNDT:RegisterConditionSetImplementingClass("UnitSet")
	
	TMW:RegisterUpgrade(60344, {
		icon = function(self, ics)
			for n, condition in TMW:InNLengthTable(ics.UnitConditions) do
				condition.Unit = "unit"
			end
		end,
	})

	local ConditionSet = {
		parentSettingType = "icon",
		parentDefaults = TMW.Icon_Defaults,
		modifiedDefaults = {
			Unit = "unit",
		},
		
		settingKey = "UnitConditions",
		GetSettings = function(self)
			return TMW.CI.ics and TMW.CI.ics.UnitConditions
		end,
		
		iterFunc = TMW.InIconSettings,
		iterArgs = {
			[1] = TMW,
		},

		useDynamicTab = true,
		ShouldShowTab = function(self)
			return TellMeWhen_Unit and TellMeWhen_Unit:IsShown()
		end,
		tabText = L["UNITCONDITIONS"],
		tabTooltip = L["UNITCONDITIONS_TAB_DESC"],
		
		ConditionTypeFilter = function(self, conditionData)
			if conditionData.unit == nil then
				return true
			elseif conditionData.identifier == "LUA" then
				return true
			end
		end,
		TMW_CNDT_GROUP_DRAWGROUP = function(self, event, conditionGroup, conditionData, conditionSettings)
			if CNDT.CurrentConditionSet == self then
				TMW.SUG:EnableEditBox(conditionGroup.Unit, "unitconditionunits", true)
				TMW:TT(conditionGroup.Unit, "CONDITIONPANEL_UNIT", "ICONMENU_UNIT_DESC_UNITCONDITIONUNIT")
			end
		end,
	}
	CNDT:RegisterConditionSet("Unit", ConditionSet)

	TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
		-- This can't happen until after TMW_OPTIONS_LOADED because it has to be registered
		-- after the default callbacks are registered
		TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", ConditionSet)
	end)
end

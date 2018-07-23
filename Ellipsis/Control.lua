local Ellipsis		= _G['Ellipsis']
local L				= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')

local anchors		= Ellipsis.anchors
local activeAuras	= Ellipsis.activeAuras
local activeUnits	= Ellipsis.activeUnits

local controlDB
local Aura, Unit
local anchorLookup, priorityLookup, blacklist, whitelist, filterByBlacklist
local noTargetFake, noTargetFakeHasted, noTargetRedirect
local isUniqueAura

local durationMin, durationMax, blockPassive
local trackPlayer, trackPet

local opacityFaded

local UnitAura			= UnitAura
local UnitCanAttack		= UnitCanAttack
local UnitClass			= UnitClass
local UnitExists		= UnitExists
local UnitGUID			= UnitGUID
local UnitLevel			= UnitLevel
local UnitName			= UnitName

local GetSpellInfo		= GetSpellInfo
local GetSpellTexture	= GetSpellTexture
local GetTotemInfo		= GetTotemInfo

local GetTime			= GetTime


local playerGUID, petGUID, targetGUID, focusGUID

local blacklistByGUID = {}	-- 'minions' have no death event, this list filters out minion GUIDS to never show auras (to avoid persisting auras)

local summonSpellID		= false
local summonWildImps	= 0
local summonSoulEffigy	= false

local totemID	= -1	-- fake totem spellID used to catch blizzard triggering the event for non-totems
local totemData	= {}	-- reference to active totems to cleanse 'old' auras


-- ------------------------
-- CONTROL INITIALIZATION
-- ------------------------
function Ellipsis:InitializeControl()
	controlDB		= self.db.profile.control

	Aura			= self.Aura
	Unit			= self.Unit

	noTargetFake, noTargetFakeHasted, noTargetRedirect = self:GetDataNoTarget()
	isUniqueAura = self:GetDataUniqueAuras()

	anchorLookup		= self.anchorLookup
	priorityLookup		= self.priorityLookup
	blacklist			= controlDB.blacklist
	whitelist			= controlDB.whitelist

	playerGUID			= UnitGUID('player')
	petGUID				= UnitExists('pet') and UnitGUID('pet') or false

	self:ConfigureControl()
end

function Ellipsis:ConfigureControl()
	-- update aura limits
	durationMin			= (controlDB.timeMinLimit) and controlDB.timeMinValue or -1			-- to make sure we don't block passives due to being to short
	durationMax			= (controlDB.timeMaxLimit) and controlDB.timeMaxValue or 2764800	-- 32 days, anything longer than this is not likely to be an issue
	blockPassive		= (not controlDB.showPassiveAuras)
	filterByBlacklist	= controlDB.filterByBlacklist

	for group, options in pairs(controlDB.unitGroups) do
		anchorLookup[group]		= options.anchor and self.anchors[options.anchor] or false
		priorityLookup[group]	= (controlDB.unitPrioritize) and options.priority or 0	-- if not prioritizing, give all units the same priority
	end

	trackPlayer		= (anchorLookup['player'])	and true or false
	trackPet		= (anchorLookup['pet'])		and true or false

	opacityFaded	= self.db.profile.units.opacityFaded
end


-- ------------------------
-- OPTION UPDATE FUNCTIONS
-- ------------------------
function Ellipsis:ApplyOptionsAuraRestrictions()
	for _, aura in pairs(activeAuras) do
		if (aura.duration == 0) then -- passive aura
			if (blockPassive) then -- blocking passives
				aura:Release()
			end
		else -- timed auras
			if (durationMin > 0) then -- minimum duration is set
				if (aura.duration <= durationMin) then
					aura:Release()
				end
			end

			if (durationMax < 2764800) then -- maximum duration is set
				if (aura.duration >= durationMax) then
					aura:Release()
				end
			end
		end

		if (filterByBlacklist) then
			if (blacklist[aura.spellID]) then -- filtering by blacklist, and on the list, remove
				aura:Release()
			end
		else
			if (not whitelist[aura.spellID]) then -- filtering by whitelist and NOT on the list, remove
				aura:Release()
			end
		end
	end
end

function Ellipsis:ApplyOptionsUnitGroups()
	local anchor

	for _, unit in pairs(activeUnits) do
		unit.priority	= priorityLookup[unit.group] -- update unit priority

		if (not anchorLookup[unit.groupBase]) then -- no longer tracking this base group (player and pet)
			unit:Release()
		else
			anchor = anchorLookup[unit.group]

			if (anchor ~= unit.parentAnchor) then -- anchor has been changed for this unit, move it
				unit.parentAnchor:RemoveUnit(unit.guid)
				anchor:AddUnit(unit)
			end
		end
	end

	for _, anchor in pairs(anchors) do
		anchor:UpdateDisplay(true) -- update display of all anchors
	end

	-- if tracking them, make sure we update auras on player|pet after a config change
	if (trackPlayer) then self:UNIT_AURA('player') end
	if (trackPet) then self:UNIT_AURA('pet') end
end


-- ------------------------
-- COMBAT_LOG_EVENT_UNFILTERED
do ------------------------
	local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE

	local UnitSpellHaste	= UnitSpellHaste
	local GetTime			= GetTime
	local GetSpellTexture	= GetSpellTexture
	local bit_band			= bit.band

	local deathEvents = {
		['UNIT_DIED']		= true,
		['UNIT_DESTROYED']	= true,
		['UNIT_DISSIPATES']	= true,
		['PARTY_KILL']		= true,
	}

	function Ellipsis:COMBAT_LOG_EVENT_UNFILTERED()
        local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, arg1 = CombatLogGetCurrentEventInfo()
		if (deathEvents[subEvent]) then
			if (activeUnits[destGUID]) then -- an active unit just died, destroy it and its auras
				activeUnits[destGUID]:Release()
			end
		else
			if (not destGUID or bit_band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) == 0) then return end -- abort if no target, or we're not the source

			if (subEvent == 'SPELL_CAST_SUCCESS') then -- used for tracking notarget spell casts
				if (noTargetFake[arg1] and ((filterByBlacklist and not blacklist[spellID]) or (not filterByBlacklist and whitelist[spellID]))) then
					local duration = noTargetFake[arg1]

					if (duration <= durationMin or duration >= durationMax) then return end -- abort if duration is restricted

					if (noTargetFakeHasted[arg1]) then -- duration is modified by current haste, recalculate
						duration = duration / ((UnitSpellHaste('player') / 100) + 1)
					end

					local currentTime = GetTime()

					local unit = activeUnits['notarget'] or Unit:New(GetTime(), 'notarget', false, 'notarget', L.UnitName_NoTarget, false, 0)

					if (unit.auras[arg1]) then -- aura already exists, update it
						unit.auras[arg1]:Update(currentTime, duration, currentTime + duration, 0)
					else -- no aura, create one
						local name = GetSpellInfo(arg1)

						unit:AddAura(Aura:New(currentTime, unit, arg1, name, GetSpellTexture(arg1), duration, currentTime + duration, 0))
					end

					unit:UpdateDisplay(true)
				end
			elseif (subEvent == 'SPELL_SUMMON') then
				summonSpellID = arg1 -- hacky, used to grab the most recent spellID summoned for faking totem data

				if (arg1 == 104317) then -- Wild Imps: track count of how many were summoned in each batch
					summonWildImps = summonWildImps + 1
				end

				if (bit_band(destFlags, COMBATLOG_OBJECT_TYPE_PET) == 0) then -- the summon is not an actual pet, blacklist it
					if (arg1 == 205178) then -- Soul Effigy: we want a 'unit' for Effigy but need a way to kill it on despawn
						if (summonSoulEffigy and activeUnits[summonSoulEffigy]) then -- active Effigy, clear old unit
							activeUnits[summonSoulEffigy]:Release()
						end

						summonSoulEffigy = destGUID -- record guid so we can track (and kill) it later
					else
						blacklistByGUID[destGUID] = timestamp
					end
				end
			end

			--[[
			-- DEBUG FOR WATCHING ALL USEFUL CLEU SUBEVENTS (add varArgs back to function header to use)
			if (string.find(subEvent, 'DAMAGE') or string.find(subEvent, 'HEAL') or string.find(subEvent, 'ENERGIZE')) then return end

			local s = ' id: ' .. arg1
			local v

			for x = 1, select('#', ...) do
				v = select(x, ...)

				if (type(v) == 'string' or type(v) == 'number') then
					s = s .. ', ' .. v
				elseif (type(v) == 'boolean') then
					s = s .. ', ' .. (v and 'TRUE' or 'FALSE')
				else
					s = s .. ', nil'
				end
			end

			sourceName = sourceName or 'nil'
			sourceFlags = sourceFlags or '-16'
			destName = destName or 'nil'
			destFlags = destFlags or '-16'


			Ellipsis:Printf('%.3f [|cff00ff00%s|r] %s (%d) > %s (%d - %d - %d)%s', GetTime(), subEvent, sourceName, sourceFlags, destName, destFlags, destRaidFlags, raidIcon, s)
			]]
		end
	end
end


-- ------------------------
-- PLAYER_REGEN_ENABLED
-- ------------------------
function Ellipsis:PLAYER_REGEN_ENABLED()
	local ageCheck = time() - 600 -- cleanse entries older than 10 minutes so we don't end up with a huge table of (now useless) entries

	for guid, timestamp in pairs(blacklistByGUID) do
		if (timestamp < ageCheck) then
			blacklistByGUID[guid] = nil
		end
	end

	if (totemID < -10000) then
		totemID = -1 -- prevent our 'fake totem' spellID from getting out of hand if it ever gets this high
	end

	-- remove all unit data for hostile targets on combat end (either reset or dead), used for Absolute Corruption mostly
	for _, unit in pairs(activeUnits) do
		if (unit.unitHostile) then -- hostile mob, no longer in combat, so no longer relevant
			unit:Release()
		end
	end
end


-- ------------------------
-- PLAYER_TOTEM_UPDATE
-- ------------------------
function Ellipsis:PLAYER_TOTEM_UPDATE(slot)
	local _, totemName, startTime, duration = GetTotemInfo(slot)
	local _, _, _, _, _, _, spellID = GetSpellInfo(totemName)
	local totemTexture

	if (spellID) then -- proper totem
		totemTexture = GetSpellTexture(spellID)
	else
		if (not summonSpellID) then return end -- not even enough info to fake it

		totemTexture	= GetSpellTexture(summonSpellID)
		spellID			= summonSpellID -- still needed for filter list lookup
	end

	if (((filterByBlacklist and blacklist[spellID]) or (not filterByBlacklist and not whitelist[spellID])) or
		(duration < durationMin or duration >= durationMax)) then return end

	if (startTime > 0) then -- totem in this slot
		if (duration == 0) then return end -- totem in this slot, but no duration (nothing to track)

		local unit			= activeUnits['notarget'] or false
		local toRelease		= false -- tracking active 'totem' in this slot (dont want to release til replacement is ready)
		local currentTime	= GetTime()

		if (unit) then
			if (totemData[slot]) then -- exising totem in this slot, queue for clear
				toRelease = totemData[slot] -- release after new totem made or 'notarget' unit might Release
			end
		else -- need to create notarget unit
			unit = Unit:New(currentTime, 'notarget', false, 'notarget', L.UnitName_NoTarget, false, 0)
		end

		-- create the aura for this totem (new or otherwise)
		if (spellID == 104317) then -- this summon is Wild Imps (special case)
			totemData[slot] = unit:AddAura(Aura:New(currentTime, unit, totemID, totemName, totemTexture, duration, startTime + duration, summonWildImps))
			summonWildImps = 0
		else
			totemData[slot] = unit:AddAura(Aura:New(currentTime, unit, totemID, totemName, totemTexture, duration, startTime + duration, 0))
		end

		totemID = totemID - 1

		if (toRelease) then
			toRelease:Release()
		end

		unit:UpdateDisplay(true)
	else -- no totem in this slot, clear totem aura if present
		if (totemData[slot]) then
			if (activeAuras[totemData[slot].auraID]) then -- active aura (handles user clicking aura off, or 'malformed' spawns)
				totemData[slot]:Release()
			end

			totemData[slot] = nil
		end

		if (summonSoulEffigy) then -- special case for Soul Effigy, clear unit if present
			if (activeUnits[summonSoulEffigy]) then
				activeUnits[summonSoulEffigy]:Release()
			end

			summonSoulEffigy = false
		end
	end
end


-- ------------------------
-- UNIT_PET
-- ------------------------
function Ellipsis:UNIT_PET(unit)
	if (UnitExists('pet')) then
		local currentGUID = UnitGUID('pet')

		if (currentGUID ~= petGUID) then -- no longer the same pet, remove the old one (if it exists)
			if (activeUnits[petGUID]) then
				activeUnits[petGUID]:Release()
			end
		end

		petGUID = currentGUID
	else
		if (activeUnits[petGUID]) then -- no pet currently, remove the old one (if it exists)
			activeUnits[petGUID]:Release()
		end

		petGUID = nil
	end
end


-- ------------------------
-- PLAYER_TARGET_CHANGED
-- ------------------------
function Ellipsis:PLAYER_TARGET_CHANGED()
	local unit

	if (targetGUID) then -- we had a previous target
		unit = activeUnits[targetGUID] or false

		if (unit) then -- we have auras on the previous target
			unit.group		= (unit.guid == focusGUID) and 'focus' or unit.groupBase -- new group is either focus or its base grouping
			unit.priority	= priorityLookup[unit.group]

			local anchor = anchorLookup[unit.group]

			if (anchor ~= unit.parentAnchor) then -- unit needs to be moved to a new anchor
				unit.parentAnchor:RemoveUnit(targetGUID)
				anchor:AddUnit(unit)
			else
				anchor:UpdateDisplay(true) -- update display of its current anchor
			end

			unit:SetAlpha(opacityFaded)
		end
	end

	if (UnitExists('target')) then -- we have a new target
		targetGUID = UnitGUID('target')

		unit = activeUnits[targetGUID] or false

		if (unit) then -- we have auras on this unit
			unit.group		= 'target'
			unit.priority	= priorityLookup['target']

			local anchor = anchorLookup['target']

			if (anchor ~= unit.parentAnchor) then -- unit needs to be moved to a new anchor
				unit.parentAnchor:RemoveUnit(targetGUID)
				anchor:AddUnit(unit)
			else
				anchor:UpdateDisplay(true) -- update display on its current anchor
			end

			unit:SetAlpha(1)
		end

		self:UNIT_AURA('target') -- scan new target
	else
		targetGUID = false
	end
end


-- ------------------------
-- PLAYER_FOCUS_CHANGED
-- ------------------------
function Ellipsis:PLAYER_FOCUS_CHANGED()
	local unit

	if (focusGUID) then -- we had a previous focus
		unit = activeUnits[focusGUID] or false

		if (unit) then -- we have auras on the previous focus
			unit.group		= (unit.guid == targetGUID) and 'target' or unit.groupBase -- new group is either target or its base grouping
			unit.priority	= priorityLookup[unit.group]

			local anchor = anchorLookup[unit.group]

			if (anchor ~= unit.parentAnchor) then -- unit needs to be moved to a new anchor
				unit.parentAnchor:RemoveUnit(focusGUID)
				anchor:AddUnit(unit)
			else
				anchor:UpdateDisplay(true) -- update display of its current anchor
			end
		end
	end

	if (UnitExists('focus')) then -- we have a new focus
		focusGUID = UnitGUID('focus')

		if (focusGUID == targetGUID) then return end -- we don't update the data if the focus is the target (it has precedence)

		unit = activeUnits[focusGUID] or false

		if (unit) then -- we have auras on this unit
			unit.group		= 'focus'
			unit.priority	= priorityLookup['focus']

			local anchor = anchorLookup['focus']

			if (anchor ~= unit.parentAnchor) then -- unit needs to be moved to a new anchor
				unit.parentAnchor:RemoveUnit(focusGUID)
				anchor:AddUnit(unit)
			else
				anchor:UpdateDisplay(true) -- update display on its current anchor
			end
		end

		self:UNIT_AURA('focus') -- scan new focus

	else
		focusGUID = false
	end
end


-- ------------------------
-- UNIT_AURA
-- ------------------------
function Ellipsis:UNIT_AURA(unitTag)
	local filter = UnitCanAttack('player', unitTag) and 'HARMFUL|PLAYER' or 'HELPFUL|PLAYER'
	local spellName, _, stackCount, _, duration, expireTime, unitCaster, _, _, spellID = UnitAura(unitTag, 1, filter) --aby8

	local guid	= UnitGUID(unitTag)
	local unit	= activeUnits[guid]

	if (not spellName and not unit) then return end -- none of our auras here, and not already tracking this unit, bailout

	local currentTime = GetTime()

	-- check for quick bailout conditions
	if (unit and currentTime == unit.updated) then return end	-- unit exists, but was updated already this frame
	if (not trackPlayer and guid == playerGUID) then return end	-- unit is player, but not tracking player (done here because is a common event source)
	if (not trackPet and guid == petGUID) then return end		-- unit is pet, but not tracking pet (done here because is a common event source)
	if (blacklistByGUID[guid]) then return end					-- unit is blacklisted from display (temporary minion with no death 'event')

	local changed	= false -- keep track of whether anything major changes that requires the unit to UpdateDisplay
	local index		= 1
	local aura

	while (spellName) do -- only scanning our auras on target
		if (unitCaster == 'player' or unitCaster == 'pet') then -- make sure player (or their pet) cast this aura
			-- handle aura limitations, bit chunky due to special handling of passive auras and their limits as well as filter lists
			if (((filterByBlacklist and not blacklist[spellID]) or (not filterByBlacklist and whitelist[spellID])) and
				((duration > 0 and (duration > durationMin and duration < durationMax)) or (duration == 0 and not blockPassive))) then

				-- handle notarget redirects for auras that appear on the player but make more sense to appear in notarget
				if (noTargetRedirect[spellID]) then -- spell needs to be redirected to notarget unit
					local noTarget = activeUnits['notarget'] or Unit:New(currentTime, 'notarget', false, 'notarget', L.UnitName_NoTarget, false, 0)
					local noTargetChanged = false -- same as the global 'changed' (unlikely to be more than one redirected aura per unit)

					aura = noTarget.auras[spellID]

					if (not aura) then -- no aura exists yet, create one
						aura = noTarget:AddAura(Aura:New(currentTime, noTarget, spellID, spellName, GetSpellTexture(spellID), duration, expireTime, stackCount))
						noTargetChanged = true
					elseif (expireTime ~= aura.expireTime) then -- something major has changed, perform a full update
						aura:Update(currentTime, duration, expireTime, stackCount)
						noTargetChanged = true
					end -- assuming no redirected auras have stacks (proven true as of Legion release)

					if (noTargetChanged) then
						noTarget:UpdateDisplay(true)
					end
				else -- all other auras that are not a redirect
					if (not unit) then -- got this far, we'll (soon) have an aura to add, make a unit to place it on
						local group		= (guid == playerGUID) and 'player' or (guid == petGUID) and 'pet' or (filter == 'HARMFUL|PLAYER') and 'harmful' or 'helpful'
						local override	= (guid == targetGUID) and 'target' or (guid == focusGUID) and 'focus' or false

						unit = Unit:New(currentTime, group, override, guid, UnitName(unitTag), select(2, UnitClass(unitTag)), UnitLevel(unitTag))
					end

					aura = unit.auras[spellID] or false

					if (not aura) then -- no aura exists yet, create one
						if (isUniqueAura[spellID]) then -- this is a unique spell, cleanout all other instances
							for _, active in pairs(activeAuras) do
								if (active.spellID == spellID) then
									active:Release() -- release, no expiration or alerts (user should be aware they are breaking existing aura)
								end
							end
						end

						aura	= unit:AddAura(Aura:New(currentTime, unit, spellID, spellName, GetSpellTexture(spellID), duration, expireTime, stackCount))
						changed	= true -- adding a new aura, will need to UpdateDisplay
					else -- existing aura
						if (expireTime ~= aura.expireTime) then -- something major has changed, perform a full update
							aura:Update(currentTime, duration, expireTime, stackCount)
							changed = true
						elseif (stackCount ~= aura.stackCount) then -- check if stacks have changed, perform minor stack update
							aura.stackCount = stackCount
							aura.stacks:SetText((stackCount > 1) and stackCount or '')
						end

						aura.updated = currentTime
					end
				end
			end
		end

		index = index + 1
		spellName, _, stackCount, _, duration, expireTime, unitCaster, _, _, spellID = UnitAura(unitTag, index, filter) --aby8
	end

	if (not unit) then return end -- no auras (and thus no units) passed the filters, we're done here

	if (changed) then -- if anything major has changed, update the unit display
		unit:UpdateDisplay(true)
	end

	unit.updated = currentTime -- unit has been scanned in this frame, make sure it doesn't happen again

	-- check for any auras that are still being shown, but have actually expired
	for _, aura in pairs(unit.auras) do
		if (not aura.expired and (aura.updated < currentTime)) then
			aura:SetExpired()
		end
	end
end

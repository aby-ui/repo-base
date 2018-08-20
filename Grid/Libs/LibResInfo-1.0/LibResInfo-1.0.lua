--[[--------------------------------------------------------------------
	LibResInfo-1.0
	Library to provide information about resurrections in your group.
	Copyright 2012-2018 Phanx <addons@phanx.net> / zlib License
	https://github.com/Phanx/LibResInfo
------------------------------------------------------------------------
	TODO:
	* Handle Reincarnation with some guesswork?
	* Clear data when releasing spirit
----------------------------------------------------------------------]]

local IS_WOW_8 = GetBuildInfo():match("^8")

local MAJOR, MINOR = "LibResInfo-1.0", 27
assert(LibStub, MAJOR.." requires LibStub")
assert(LibStub("CallbackHandler-1.0", true), MAJOR.." requires CallbackHandler-1.0")
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

------------------------------------------------------------------------

local DEBUG_LEVEL = GetAddOnMetadata("LibResInfo-1.0", "Version") and 1 or 0
local DEBUG_FRAME = ChatFrame3

------------------------------------------------------------------------

local callbacks        = lib.callbacks        or LibStub("CallbackHandler-1.0"):New(lib)
local eventFrame       = lib.eventFrame       or CreateFrame("Frame")

local guidFromUnit     = lib.guidFromUnit     or {} -- t[unit] = guid -- table lookup is faster than calling UnitGUID
local nameFromGUID     = lib.nameFromGUID     or {} -- t[guid] = name
local unitFromGUID     = lib.unitFromGUID     or {} -- t[guid] = unit

local castingSingle    = lib.castingSingle    or {} -- t[casterGUID] = { startTime = <number>, endTime = <number>, target = <guid> }
local castingMass      = lib.castingMass      or {} -- t[casterGUID] = endTime
local hasPending       = lib.hasPending       or {} -- t[targetGUID] = endTime

local hasSoulstone     = lib.hasSoulstone     or {} -- t[targetGUID] = <boolean>
local hasReincarnation = lib.hasReincarnation or {} -- t[targetGUID] = <boolean>
local isDead           = lib.isDead           or {} -- t[targetGUID] = <boolean>
local isGhost          = lib.isGhost          or {} -- t[targetGUID] = <boolean>

------------------------------------------------------------------------

lib.callbacks          = callbacks
lib.eventFrame         = eventFrame

lib.guidFromUnit       = guidFromUnit
lib.nameFromGUID       = nameFromGUID
lib.unitFromGUID       = unitFromGUID

lib.castingSingle      = castingSingle
lib.castingMass        = castingMass
lib.hasPending         = hasPending

lib.hasSoulstone       = hasSoulstone
lib.hasReincarnation   = hasReincarnation
lib.isDead             = isDead
lib.isGhost            = isGhost

------------------------------------------------------------------------

local RESURRECT_PENDING_TIME = 60
local RELEASE_PENDING_TIME = 360
local SOULSTONE = GetSpellInfo(20707)
local REINCARNATION = GetSpellInfo(225080)
local RESURRECTING = GetSpellInfo(160029)

local singleSpells = {
	-- Class Abilities
	[2008]   = GetSpellInfo(2008),   -- Ancestral Spirit (Shaman)
	[7328]   = GetSpellInfo(7328),   -- Redemption (Paladin)
	[2006]   = GetSpellInfo(2006),   -- Resurrection (Priest)
	[115178] = GetSpellInfo(115178), -- Resuscitate (Monk)
	[50769]  = GetSpellInfo(50769),  -- Revive (Druid)
	[982]    = GetSpellInfo(982),    -- Revive Pet (Hunter)
	-- Items
	[8342]   = GetSpellInfo(8342),   -- Defibrillate (Goblin Jumper Cables)
	[22999]  = GetSpellInfo(22999),  -- Defibrillate (Goblin Jumper Cables XL)
	[54732]  = GetSpellInfo(54732),  -- Defibrillate (Gnomish Army Knife)
	[164729] = GetSpellInfo(164729), -- Defibrillate (Ultimate Gnomish Army Knife)
	[199119] = GetSpellInfo(199119), -- Failure Detection Aura (Failure Detection Pylon) -- NEEDS CHECK
	[187777] = GetSpellInfo(187777), -- Reawaken (Brazier of Awakening)
}

local massSpells = {
	[212056] = GetSpellInfo(212056), -- Absolution (Holy Paladin)
	[212048] = GetSpellInfo(212048), -- Ancestral Vision (Restoration Shaman)
	[212036] = GetSpellInfo(212036), -- Mass Resurrection (Discipline/Holy Priest)
	[212051] = GetSpellInfo(212051), -- Reawaken (Mistweaver Monk)
	[212040] = GetSpellInfo(212040), -- Revitalize (Restoration Druid)
}

------------------------------------------------------------------------

local next, pairs, GetNumGroupMembers, GetTime, IsInGroup, IsInRaid, UnitAura, UnitCastingInfo, UnitGUID, UnitHasIncomingResurrection, UnitHealth, UnitIsConnected, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost, UnitName
    = next, pairs, GetNumGroupMembers, GetTime, IsInGroup, IsInRaid, UnitAura, UnitCastingInfo, UnitGUID, UnitHasIncomingResurrection, UnitHealth, UnitIsConnected, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost, UnitName

------------------------------------------------------------------------

local function debug(level, text, ...)
	if level <= DEBUG_LEVEL then
		if ... then
			if type(text) == "string" and strfind(text, "%%[dfqsx%d%.]") then
				text = format(text, ...)
			else
				text = strjoin(" ", tostringall(text, ...))
			end
		else
			text = tostring(text)
		end
		DEBUG_FRAME:AddMessage("|cff00ddba[LRI]|r " .. text)
	end
end

local newTable, remTable
do
	local pool = {}
	function newTable()
		local t = next(pool)
		if t then
			pool[t] = nil
			return t
		end
		return {}
	end
	function remTable(t)
		pool[wipe(t)] = true
		return nil
	end
end

local function UnitAuraByName(unit, searchName, filter)
	-- Helper function to accommodate changes in WoW 8.0:
	-- UnitAura no longer accepts an aura name, so we have to scan all auras and check their names to find the one we want
	-- UnitAura no longer returns a spell rank (arg2)
	for i = 1, 40 do
		local name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod
		if IS_WOW_8 then
			-- rank removed, other args shifted left
			name, texture, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, filter)
		else
			name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, filter)
		end

		if not name then
			break
		elseif name == searchName then
			-- rank excluded in either case
			return name, texture, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod
		end
	end
end

------------------------------------------------------------------------

lib.callbacksInUse = lib.callbacksInUse or {}

eventFrame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

function callbacks:OnUsed(lib, callback)
	if not next(lib.callbacksInUse) then
		debug(1, "Callbacks in use! Starting up...")
		eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		eventFrame:RegisterEvent("INCOMING_RESURRECT_CHANGED")
		eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		eventFrame:RegisterEvent("RESURRECT_REQUEST")
		eventFrame:RegisterEvent("UNIT_AURA")
		eventFrame:RegisterEvent("UNIT_CONNECTION")
		eventFrame:RegisterEvent("UNIT_FLAGS")
		eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
		eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
		eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		eventFrame:GROUP_ROSTER_UPDATE("OnUsed")
	end
	lib.callbacksInUse[callback] = true
end

function callbacks:OnUnused(lib, callback)
	lib.callbacksInUse[callback] = nil
	if not next(lib.callbacksInUse) then
		debug(1, "No callbacks in use. Shutting down...")
		eventFrame:UnregisterAllEvents()
		eventFrame:Hide()
		wipe(guidFromUnit)
		wipe(nameFromGUID)
		wipe(unitFromGUID)
		for caster, data in pairs(castingSingle) do
			castingSingle[caster] = remTable(data)
		end
		wipe(castingMass)
		wipe(hasPending)
		wipe(hasSoulstone)
		wipe(hasReincarnation)
		wipe(isDead)
		wipe(isGhost)
	end
end

------------------------------------------------------------------------

function lib.RegisterAllCallbacks(handler, method, includeMassRes)
	lib.RegisterCallback(handler, "LibResInfo_ResCastStarted", method)
	lib.RegisterCallback(handler, "LibResInfo_ResCastCancelled", method)
	lib.RegisterCallback(handler, "LibResInfo_ResCastFinished", method)

	if includeMassRes then
		lib.RegisterCallback(handler, "LibResInfo_MassResStarted", method)
		lib.RegisterCallback(handler, "LibResInfo_MassResCancelled", method)
		lib.RegisterCallback(handler, "LibResInfo_MassResFinished", method)
		lib.RegisterCallback(handler, "LibResInfo_UnitUpdate", method)
	end

	lib.RegisterCallback(handler, "LibResInfo_ResPending", method)
	lib.RegisterCallback(handler, "LibResInfo_ResUsed", method)
	lib.RegisterCallback(handler, "LibResInfo_ResExpired", method)
end

------------------------------------------------------------------------
--	Returns information about the res being cast on the specified unit.
--	Arguments: unit (unitID or GUID)
--	Returns: resType (string), endTime (number), caster (unitID), casterGUID
--	* All returns are nil if no res is being cast on the unit.
--	* resType is one of:
--   - SELFRES if the unit has a Soulstone or other self-res ability available,
--   - PENDING if the unit already has a res available to accept,
--   - CASTING if a res is being cast on the unit, or
--   - MASSRES if a mass res is being cast.
--	* caster and casterGUID are nil if the unit is being mass-ressed.
------------------------------------------------------------------------

function lib:UnitHasIncomingRes(unit)
	if type(unit) ~= "string" then return end
	local guid
	if strmatch(unit, "^Player%-") then
		guid = unit
		unit = unitFromGUID[guid]
	else
		guid = UnitGUID(unit)
		unit = unitFromGUID[guid]
	end
	if not guid or not unit or not UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return
	end
	if hasPending[guid] then
		local state = (hasSoulstone[guid] or hasReincarnation[guid]) and "SELFRES" or "PENDING"
		debug(2, "UnitHasIncomingRes", nameFromGUID[guid], state)
		return state, hasPending[guid]
	end

	local state, firstCaster, firstEnd
	for caster, data in pairs(castingSingle) do
		if data.target == guid then
			if not firstEnd or data.endTime < firstEnd then
				state, firstCaster, firstEnd = "CASTING", caster, data.endTime
			end
		end
	end
	for caster, endTime in pairs(castingMass) do
		if not firstEnd or endTime < firstEnd then
			state, firstCaster, firstEnd = "MASSRES", caster, endTime
		end
	end
	if state and firstCaster and firstEnd then
		debug(2, "UnitHasIncomingRes", nameFromGUID[guid], state, nameFromGUID[firstCaster])
		return state, firstEnd, unitFromGUID[firstCaster], firstCaster
	end
	--debug(3, "UnitHasIncomingRes", nameFromGUID[guid], "nil")
end

------------------------------------------------------------------------
--	Return information about the res being cast by the specified unit.
--	Arguments: unit (unitID or GUID)
--	Returns: endTime (number), target (unitID), targetGUID (guid), isFirst (boolean)
--	* all returns are nil if the unit is not casting a res
--	* target and targetGUID are nil if the unit is casting a mass res
------------------------------------------------------------------------

function lib:UnitIsCastingRes(unit)
	if type(unit) ~= "string" then return end
	local guid
	if strmatch(unit, "^Player%-") then
		guid = unit
		unit = unitFromGUID[guid]
	else
		guid = UnitGUID(unit)
		unit = unitFromGUID[guid]
	end
	if not guid or not unit then
		return
	end

	local casting = castingMass[guid]
	if casting then
		local endTime, isFirst = casting, true
		for caster, endTime2 in pairs(castingMass) do
			if endTime2 < endTime then
				isFirst = false
				break
			end
		end
		debug(2, "UnitIsCastingRes", nameFromGUID[guid], "casting mass res", isFirst and "(first)" or "(duplicate)")
		return endTime, nil, nil, isFirst
	end

	casting = castingSingle[guid]
	if casting then
		local endTime, target, isFirst = casting.endTime, casting.target, true
		-- TODO: Handle edge case where this function is called in between the cast start and the target identification?
		for caster, data in pairs(castingSingle) do
			if data.target == target and data.endTime < endTime then
				isFirst = false
				break
			end
		end
		debug(2, "UnitIsCastingRes", nameFromGUID[guid], "casting on", nameFromGUID[casting.target], isFirst and "(first)" or "(duplicate)")
		return endTime, unitFromGUID[casting.target], casting.target, isFirst
	end

	--debug(3, "UnitIsCastingRes", nameFromGUID[guid], "nil")
end

------------------------------------------------------------------------
--	Handle group changes:

local function AddUnit(unit)
	local guid = UnitGUID(unit)
	if not guid then return end
	guidFromUnit[unit] = guid
	nameFromGUID[guid] = UnitName(unit)
	unitFromGUID[guid] = unit
	-- Check for soulstones:
	eventFrame:UNIT_AURA("AddUnit", unit)
end

function eventFrame:GROUP_ROSTER_UPDATE(event)
	debug(3, event)

	-- Update guid <==> unit mappings:
	wipe(guidFromUnit)
	wipe(unitFromGUID)
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			AddUnit("raid"..i)
			AddUnit("raidpet"..i)
		end
	else
		AddUnit("player")
		AddUnit("pet")
		if IsInGroup() then
			for i = 1, GetNumGroupMembers() - 1 do
				AddUnit("party"..i)
				AddUnit("partypet"..i)
			end
		end
	end

	-- Remove data for single casters no longer in the group:
	for caster, data in pairs(castingSingle) do
		if not unitFromGUID[caster] then
			local target = data.target
			castingSingle[caster] = remTable(data)
			debug(1, ">> ResCastCancelled on", nameFromGUID[target], "by", nameFromGUID[caster], "(caster left group)")
			callbacks:Fire("LibResInfo_ResCastCancelled", unitFromGUID[target], target, nil, caster)
		end
	end

	-- Remove data for mass casters no longer in the group:
	for caster in pairs(castingMass) do
		if not unitFromGUID[caster] then
			castingMass[caster] = nil
			debug(1, ">> MassResCancelled by", nameFromGUID[caster], "(left group)")
			callbacks:Fire("LibResInfo_MassResCancelled", nil, caster)
		end
	end

	-- Remove data for targets no longer in the group:
	for caster, data in pairs(castingSingle) do
		local target = data.target
		if not unitFromGUID[target] then
			castingSingle[caster] = remTable(data)
			-- TODO: Is this callback needed, or will the cast cancel on its own?
			debug(1, ">> ResCastCancelled on", nameFromGUID[target], "by", nameFromGUID[caster], "(target left group)")
			callbacks:Fire("LibResInfo_ResCastCancelled", nil, target, unitFromGUID[caster], caster)
		end
	end

	-- Remove data for waiters no longer in the group:
	for target in pairs(hasPending) do
		if not unitFromGUID[target] then
			hasPending[target] = nil
			debug(1, ">> ResExpired on", nameFromGUID[target], "(left group)")
			callbacks:Fire("LibResInfo_ResExpired", nil, target)
		end
	end

	-- Unregister unit events and stop the timer if there are no waiters:
	if not next(hasPending) then
		debug(3, "Nobody pending, stop timer")
		self:Hide()
	end

	-- Unregister CLEU if there are no casts:
	if not next(castingSingle) and not next(castingMass) then
		debug(3, "Nobody casting, unregistering CLEU")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end

	-- Remove names no longer in the group:
	for guid, name in pairs(nameFromGUID) do
		if not unitFromGUID[guid] then
			debug(4, name, "is no longer in the group")
			nameFromGUID[guid] = nil
		end
	end
end

eventFrame.PLAYER_ENTERING_WORLD = eventFrame.GROUP_ROSTER_UPDATE

------------------------------------------------------------------------

function eventFrame:INCOMING_RESURRECT_CHANGED(event, unit)
	local guid = guidFromUnit[unit]
	if not guid then return end

	local hasRes = UnitHasIncomingResurrection(unit)
	debug(3, event, nameFromGUID[guid], hasRes)

	if hasRes then
		-- Unit has a res incoming. Match it to a spell.
		local now = GetTime()
		for caster, data in pairs(castingSingle) do
			if not data.target and data.startTime - now < 10 then
				-- Found it!
				data.target = guid
				debug(1, ">> ResCastStarted on", nameFromGUID[guid], "by", nameFromGUID[caster], "in", event)
				callbacks:Fire("LibResInfo_ResCastStarted", unit, guid, unitFromGUID[caster], caster, data.endTime)
				break
			end
		end
		-- TODO: Why was I searching for finished casts here???
	else
		-- Check if unit previously had any resses.
		for caster, data in pairs(castingSingle) do
			if data.target == guid then
				debug(4, nameFromGUID[caster], "was casting...")
				if data.startTime then
					debug(4, "...and stopped.")
					castingSingle[caster] = remTable(data)
					debug(1, ">> ResCastCancelled", "on", nameFromGUID[guid], "by", nameFromGUID[casterGUID], "in", event)
					callbacks:Fire("LibResInfo_ResCastCancelled", unit, guid, unitFromGUID[casterGUID], casterGUID)
				else
					debug(4, "...and finished.")
					castingSingle[caster] = remTable(data)
					hasPending[guid] = nil
					debug(1, ">> ResCastFinished", "on", nameFromGUID[guid], "by", nameFromGUID[casterGUID], "in", event)
					callbacks:Fire("LibResInfo_ResCastFinished", unit, guid, unitFromGUID[casterGUID], casterGUID)
					self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				end
			end
		end
	end
end

------------------------------------------------------------------------

function eventFrame:UNIT_SPELLCAST_START(event, unit, ...)
	local spellID, _
	if IS_WOW_8 then
		_, spellID = ...
	else
		_, _, _, spellID = ...
	end

	local resType = massSpells[spellID] and "mass" or singleSpells[spellID] and "single"
	if not resType then return end

	local guid = guidFromUnit[unit]
	if not guid then return end
	debug(3, event, nameFromGUID[guid], "casting", (GetSpellInfo(spellID)))

	local startTime, endTime, _
	if IS_WOW_8 then
		_, _, _, startTime, endTime = UnitCastingInfo(unit)
	else
		_, _, _, _, startTime, endTime = UnitCastingInfo(unit)
	end

	if resType == "mass" then
		castingMass[guid] = endTime / 1000
		debug(1, ">> MassResStarted", nameFromGUID[guid])
		callbacks:Fire("LibResInfo_MassResStarted", unit, guid, endTime / 1000)
		return
	else
		local data = newTable()
		data.startTime = startTime / 1000
		data.endTime = endTime / 1000
		castingSingle[guid] = data
	end
end

function eventFrame:UNIT_SPELLCAST_SUCCEEDED(event, unit, ...)
	local spellID, _
	if IS_WOW_8 then
		_, spellID = ...
	else
		_, _, _, spellID = ...
	end

	local resType = massSpells[spellID] and "mass" or singleSpells[spellID] and "single"
	if not resType then return end

	local guid = guidFromUnit[unit]
	if not guid then return end

	debug(3, event, nameFromGUID[guid], "finished", (GetSpellInfo(spellID)))

	if resType == "mass" then
		castingMass[guid] = nil
		debug(1, ">> MassResFinished", nameFromGUID[guid])
		callbacks:Fire("LibResInfo_MassResFinished", unit, guid)
	else
		local data = castingSingle[guid]
		if data then -- No START event for instant cast spells.
			local target = data.target
			if not target then
				-- Probably Soulstone precast on a live target.
				return
			end
			data.finished = true -- Flag so STOP can ignore this.
			debug(1, ">> ResCastFinished", "on", nameFromGUID[target], "by", nameFromGUID[guid], "in", event)
			callbacks:Fire("LibResInfo_ResCastFinished", unitFromGUID[target], target, unit, guid)
		end
	end

	debug(3, "Registering CLEU")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function eventFrame:UNIT_SPELLCAST_STOP(event, unit, ...)
	local spellID, _
	if IS_WOW_8 then
		_, spellID = ...
	else
		_, _, _, spellID = ...
	end

	local resType = massSpells[spellID] and "mass" or singleSpells[spellID] and "single"
	if not resType then return end

	local guid = guidFromUnit[unit]
	if not guid then return end

	debug(3, event, nameFromGUID[guid], "stopped", (GetSpellInfo(spellID)))

	if resType == "mass" then
		if not castingMass[guid] then return end -- already SUCCEEDED
		castingMass[guid] = nil
		debug(1, ">> MassResCancelled", nameFromGUID[guid])
		callbacks:Fire("LibResInfo_MassResCancelled", unit, guid)
	else
		local data = castingSingle[guid]
		if data then
			local target = data.target
			local finished = data.finished
			castingSingle[guid] = remTable(data)
			if finished or not target then
				-- no target = Probably Soulstone precast on a live target.
				-- finished = Cast finished. Don't fire a callback or unregister CLEU.
				return
			end
			debug(1, ">> ResCastCancelled", "on", nameFromGUID[target], "by", nameFromGUID[guid])
			callbacks:Fire("LibResInfo_ResCastCancelled", unitFromGUID[target], target, unit, guid)
		end
	end

	-- Unregister CLEU if there are no casts:
	if not next(castingSingle) and not next(castingMass) then
		debug(3, "Nobody casting, unregistering CLEU")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

eventFrame.UNIT_SPELLCAST_INTERRUPTED = eventFrame.UNIT_SPELLCAST_STOP

------------------------------------------------------------------------

function eventFrame:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool)
	if combatEvent ~= "SPELL_RESURRECT" then return end

	if IS_WOW_8 then
		timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool = CombatLogGetCurrentEventInfo()
	end

	local destUnit = unitFromGUID[destGUID]
	if not destUnit then return end
	debug(3, combatEvent, "on", destName, "by", sourceName)

	local now = GetTime()
	local endTime = now + RESURRECT_PENDING_TIME

	hasPending[destGUID] = endTime

	self:Show()

	debug(1, ">> ResPending", "on", strmatch(destName, "[^%-]+"), "by", strmatch(sourceName, "[^%-]+"))
	callbacks:Fire("LibResInfo_ResPending", destUnit, destGUID, endTime)

	-- Unregister CLEU if there are no casts:
	if not next(castingSingle) and not next(castingMass) then
		-- TODO: Keep track of number of instant casts?
		-- Seems unlikely that multiple casts would end so close together that this would be an issue.
		debug(3, "Nobody casting, unregistering CLEU")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function eventFrame:RESURRECT_REQUEST(event, casterName)
	local caster = UnitGUID(casterName)
	if castingMass[caster] then
		castingMass[caster] = nil
		debug(1, ">> MassResFinished", nameFromGUID[caster])
		callbacks:Fire("LibResInfo_MassResFinished", unitFromGUID[caster], caster)
	end

	local target = UnitGUID("player") -- guidFromUnit["player"] will be nil in a raid
	local endTime = GetTime() + RESURRECT_PENDING_TIME
	hasPending[target] = endTime

	self:Show()

	debug(1, ">> ResPending", "on", nameFromGUID[target], "by", nameFromGUID[caster])
	callbacks:Fire("LibResInfo_ResPending", "player", target, endTime)

	-- UNIT_FLAGS doesn't fire for the player when accepting a resurrect after releasing
	self:RegisterEvent("UNIT_HEALTH")
end

function eventFrame:UNIT_HEALTH(event, unit)
	local guid = unit and guidFromUnit[unit] -- UNIT_HEALTH can fire with nil unit in 7.1
	if hasPending[guid] and not UnitIsDeadOrGhost(unit) then
		hasPending[guid] = nil
		debug(1, ">> ResUsed", nameFromGUID[guid])
		callbacks:Fire("LibResInfo_ResUsed", unit, guid)

		self:UnregisterEvent(event)
	end
end

------------------------------------------------------------------------

function eventFrame:UNIT_AURA(event, unit)
	local guid = guidFromUnit[unit]
	if not guid then return end
	--debug(5, event, unit)
	if not isDead[guid] then
		local stoned = UnitAuraByName(unit, SOULSTONE)
		if stoned ~= hasSoulstone[guid] then
			if not stoned and UnitHealth(unit) <= 1 then
				return
			end
			hasSoulstone[guid] = stoned
			debug(2, nameFromGUID[guid], stoned and "gained" or "lost", SOULSTONE)
		end
	else
		local reincarnation = UnitAuraByName(unit, REINCARNATION, "HARMFUL")
		if reincarnation ~= hasReincarnation[guid] then
			local endTime = GetTime() + RELEASE_PENDING_TIME
			hasReincarnation[guid] = reincarnation
			hasPending[guid] = endTime
			debug(1, ">> ResPending", nameFromGUID[guid], REINCARNATION)
			callbacks:Fire("LibResInfo_ResPending", unit, guid, endTime, true)
		else
			-- Rebirth, Raise Dead, Soulstone and Eternal Guardian leaves a debuff on the resurrected target
			local resurrecting, _, _, _, _, expires = UnitAuraByName(unit, RESURRECTING, "HARMFUL")
			if resurrecting ~= hasPending[guid] then
				hasPending[guid] = expires
				debug(1, ">> ResPending", nameFromGUID[guid], RESURRECTING)
				callbacks:Fire("LibResInfo_ResPending", unit, guid, expires)
			end
		end
	end
end

function eventFrame:UNIT_CONNECTION(event, unit)
	local guid = guidFromUnit[unit]
	if not guid then return end
	--debug(4, event, unit)
	if hasPending[unit] and not UnitIsConnected(unit) then
		hasPending[guid] = nil
		debug(1, ">> ResExpired", nameFromGUID[guid], "(offline)")
		callbacks:Fire("LibResInfo_ResExpired", unit, guid)
	elseif next(castingMass) then
		for caster, data in pairs(castingSingle) do
			if data.target == guid then
				return
			end
		end
		debug(1, ">> UnitUpdate", nameFromGUID[guid], "(offline)")
		callbacks:Fire("LibResInfo_UnitUpdate", unit, guid)
	end
end

function eventFrame:UNIT_FLAGS(event, unit)
	local guid = guidFromUnit[unit]
	if not guid then return end
	--debug(5, event, unit)
	local dead = UnitIsDead(unit)
	if not dead then
		if isDead[guid] then
			debug(2, nameFromGUID[guid], "is now alive")
			isDead[guid] = nil
			if hasPending[guid] then
				isGhost[guid] = nil
				hasPending[guid] = nil
				debug(1, ">> ResUsed", nameFromGUID[guid])
				callbacks:Fire("LibResInfo_ResUsed", unit, guid)
			elseif next(castingMass) then
				for caster, data in pairs(castingSingle) do
					if data.target == guid then
						return
					end
				end
				debug(1, ">> UnitUpdate", nameFromGUID[guid], "(alive)")
				callbacks:Fire("LibResInfo_UnitUpdate", unit, guid)
			end
		elseif hasPending[guid] or hasReincarnation[guid] then
			hasPending[guid] = nil
			hasReincarnation[guid] = nil

			debug(1, ">> UnitUpdate", nameFromGUID[guid], "(alive)")
			callbacks:Fire("LibResInfo_UnitUpdate", unit, guid)
		end
	elseif not isDead[guid] then
		debug(2, nameFromGUID[guid], "is now dead")
		isDead[guid] = true
		if hasSoulstone[guid] then
			local endTime = GetTime() + RELEASE_PENDING_TIME
			hasPending[guid] = endTime
			debug(1, ">> ResPending", nameFromGUID[guid], SOULSTONE)
			callbacks:Fire("LibResInfo_ResPending", unit, guid, endTime, true)
		elseif next(castingMass) then
			debug(1, ">> UnitUpdate", nameFromGUID[guid], "(dead)")
			callbacks:Fire("LibResInfo_UnitUpdate", unit, guid)
		end
	elseif not isGhost[guid] and UnitIsGhost(unit) then
		isGhost[guid] = true
		if hasPending[guid] then
			hasPending[guid] = nil
			debug(1, ">> ResExpired", nameFromGUID[guid], "(released)")
			callbacks:Fire("LibResInfo_ResExpired", unit, guid)
		end
		-- No need to check next(castingMass) and fire a UnitUpdate here
		-- since Mass Resurrection will still hit units who released.
	end
end

------------------------------------------------------------------------

eventFrame:Hide()

local timer, INTERVAL = 0, 0.5
eventFrame:SetScript("OnUpdate", function(self, elapsed)
	timer = timer + elapsed
	if timer >= INTERVAL then
		--debug(6, "Timer update")
		if not next(hasPending) then
			debug(4, "Nobody pending, stop timer")
			return self:Hide()
		end
		local now = GetTime()
		for guid, endTime in pairs(hasPending) do
			if endTime - now < INTERVAL then -- It will expire before the next update.
				local unit = unitFromGUID[guid]
				hasPending[guid] = nil
				debug(1, ">> ResExpired", nameFromGUID[guid])
				callbacks:Fire("LibResInfo_ResExpired", unit, guid, true)
			end
		end
		timer = 0
	end
end)

eventFrame:SetScript("OnShow", function()
	--debug(4, "Timer start")
end)

eventFrame:SetScript("OnHide", function()
	--debug(4, "Timer stop")
	timer = 0
end)

------------------------------------------------------------------------

if GetAddOnMetadata("LibResInfo-1.0", "Version") then
	SLASH_LIBRESINFO1 = "/lri"
	SlashCmdList.LIBRESINFO = function(input)
		input = tostring(input or "")

		local CURRENT_CHAT_FRAME
		for i = 1, 10 do
			local cf = _G["ChatFrame"..i]
			if cf and cf:IsVisible() then
				CURRENT_CHAT_FRAME = cf
				break
			end
		end

		local of = DEBUG_FRAME
		DEBUG_FRAME = CURRENT_CHAT_FRAME

		if string.match(input, "^%s*[0-9]%s*$") then
			local v = tonumber(input)
			debug(0, "Debug level set to", input)
			DEBUG_LEVEL = v
			DEBUG_FRAME = of
			return
		end

		local f = _G[input]
		if type(f) == "table" and type(f.AddMessage) == "function" then
			debug(0, "Debug frame set to", input)
			DEBUG_FRAME = f
			return
		end

		debug(0, "Version " .. MINOR .. " loaded. Usage:")
		debug(0, NORMAL_FONT_COLOR_CODE .. "/lri " .. DEBUG_LEVEL .. "|r - change debug verbosity, valid range is 0-6")
		debug(0, NORMAL_FONT_COLOR_CODE .. "/lri " .. of:GetName() .. "|r - change debug output frame")

		DEBUG_FRAME = of
	end
end

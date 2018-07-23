------------------------------------------------------------------------
-- LibPlayerSpells-1.0

-- A library for maintaining player spells.

-- Abin (2012/9/09)

------------------------------------------------------------------------
-- API Documentation
------------------------------------------------------------------------

-- lib:HookObject(object)

-- Hooks an object so object:OnSpellsChanged() or object:OnTalentsChanged() will be called whenever the player spells or talents change.
------------------------------------------------------------------------

-- lib:PlayerHasSpell("spell")

-- Returns querying result in format of: (bookId, bookType) or (spellName) in case of flyout spells
------------------------------------------------------------------------

-- lib:GetSpellCooldown("spell")

-- Get spell cooldown, returns cooldown, start, duration, enabled
------------------------------------------------------------------------

-- lib:IsSpellInRange("spell" [, "unit"])

-- Checks whether the spell is in range against the specified unit("target" by default), returns false if out of range (Unlike the native IsSpellInRange!)
------------------------------------------------------------------------

-- lib:IsUsableSpell("spell" [, checkCooldown [, checkMana [, "checkRange"]]])

-- Checks whether a spell is usable at the moment, returns spell id if the spell is usable,
-- or nil if it's unavailable, in which case the 2nd return value indicates the error types:
-- nil: Invalid spell name
-- 1: Spell is in cooldown, the 3rd return value is time left of the cooldown, in seconds
-- 2: Spell is not castable
-- 3: Out of mana
-- 4: Out of range against the unit specified by "checkRange" ("target", "focus", "pet", etc)
------------------------------------------------------------------------

--lib:PlayerHasTalent("talent")

-- Checks whether the player has spent point on the given talent
------------------------------------------------------------------------

-- lib:PlayerHasGlyph("glyph")

-- Checks whether the given gylph is installed
------------------------------------------------------------------------

-- lib:GetSpellCastTime("spell", useRecord)

-- Returns casting or channeling time of a spell, if useRecord is specified, DPSCycle searches internal
-- records if it was previously cast, if not found and type of useRecord is number, it returns useRecord.
-------------------------------------------------------------------------------------

-- lib:WasSpellSent("spell" [, elapsed])

-- Checks whether a spell was previously cast, if "elapsed" is specified, the function will
-- returns true only if the spell was cast within that time span, in seconds.
-------------------------------------------------------------------------------------

-- lib:GetLastSentSpell()

-- Retrives the last spell the player cast, and the time when it was cast
-------------------------------------------------------------------------------------

-- lib:GetCastingSpell()

-- Retrives the current casting/channeling spell
-------------------------------------------------------------------------------------

local GetTime = GetTime
local GetSpellTabInfo = GetSpellTabInfo
local GetSpellInfo = GetSpellInfo
local IsPassiveSpell = IsPassiveSpell
local GetSpellBookItemInfo = GetSpellBookItemInfo
local wipe = wipe
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local IsUsableSpell = IsUsableSpell
local GetSpellCooldown = GetSpellCooldown
local IsSpellInRange = IsSpellInRange
local HasPetSpells = HasPetSpells
local select = select
local type = type
local pairs = pairs
local ipairs = ipairs
local GetTalentInfo = GetTalentInfo
local strfind = strfind
local GetGlyphSocketInfo = GetGlyphSocketInfo
local GetFlyoutInfo = GetFlyoutInfo
local GetFlyoutSlotInfo = GetFlyoutSlotInfo
local _

local BOOKTYPE_PET = BOOKTYPE_PET
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local NUM_GLYPH_SLOTS = NUM_GLYPH_SLOTS
local FLYOUT_FACTOR = 10000000

local LIBNAME = "LibPlayerSpells-1.0"
local VERSION = 1.40

local lib = _G[LIBNAME]
if lib and lib.version >= VERSION then return end

if not lib then
	lib = {}
	_G[LIBNAME] = lib
end

_G.LibPlayerSpells = lib

lib.version = VERSION

--------------------------------------------------------
-- Hook Process
--------------------------------------------------------

local hookList = lib.hookList
if not hookList then
	hookList = {}
	lib.hookList = hookList
end

function lib:HookObject(object)
	if type(object) ~= "table" then
		object = {}
	end
	tinsert(hookList, object)
	return object
end

local function CallHooks(method)
	local i
	for i = 1, #hookList do
		local object = hookList[i]
		local func = object[method]
		if type(func) == "function" then
			func(object)
		end
	end
end

--------------------------------------------------------
-- Spell Process
--------------------------------------------------------

local spellList = {}

function lib:PlayerHasSpell(spell)
	local id = spellList[spell]
	if id then
		if id > FLYOUT_FACTOR then
			return spell
		end

		if id < 0 then
			return -id, BOOKTYPE_PET
		end

		return id, BOOKTYPE_SPELL
	end
end

function lib:GetSpellCooldown(spell)
	local start, duration, enabled
	local id, bookType = lib:PlayerHasSpell(spell)
	if id then
		start, duration, enabled = GetSpellCooldown(id, bookType)
	end

	if not start then
		return 0, 0, 0
	end

	return duration - GetTime() + start, start, duration, enabled
end

function lib:IsSpellInRange(spell, unit)
	local id, bookType = lib:PlayerHasSpell(spell)
	if not id then
		return 1
	end

	if type(unit) ~= "string" then
		unit = "target"
	end

	if bookType then
		return IsSpellInRange(id, bookType, unit) ~= 0
	end

	return IsSpellInRange(id, unit) ~= 0
end

function lib:IsUsableSpell(spell, checkCooldown, checkMana, checkRange)
	local id, bookType = lib:PlayerHasSpell(spell)
	if not id then
		return
	end

	local usable, oom = IsUsableSpell(id, bookType)
	if not usable then
		if not oom then
			return nil, 2
		elseif checkMana then
			return nil, 3
		end
	end

	if checkCooldown then
		local start, duration, enabled = GetSpellCooldown(id, bookType)
		local timeLeft = start and (duration - GetTime() + start) or 0
		if timeLeft > 0 and duration > 1.5 then
			return nil, 1, timeLeft, start, duration, enabled
		end
	end

	if checkRange and not lib:IsSpellInRange(spell, checkRange) then
		return nil, 4
	end

	return 1
end

local function AddFlyouts(id)
	if not id then
		return
	end

	local _, _, numSlots, isKnown = GetFlyoutInfo(id)
	if not isKnown then
		return
	end

	local i
	for i = 1, numSlots do
		local _, _, isKnown, name = GetFlyoutSlotInfo(id, i)
		if isKnown and name then
			spellList[name] = id + FLYOUT_FACTOR
		end
	end
end

local function VerifySpell(id, bookType)
	local info, fid = GetSpellBookItemInfo(id, bookType)
	if info == "FLYOUT" then
		AddFlyouts(fid)
	elseif info == "SPELL" then
		local name = GetSpellInfo(id, bookType)
		if name then
			if bookType == BOOKTYPE_PET then
				id = -id
			end
			spellList[name] = id
		end
	end
end

local function UpdateTabSpells(tab)
	local _, _, offset, count = GetSpellTabInfo(tab)
	if offset and count then
		local i
		for i = 1, count do
			VerifySpell(offset + i, BOOKTYPE_SPELL)
		end
	end
end

local function UpdateSpellData()
	wipe(spellList)
	local num = HasPetSpells()
	if type(num) == "number" and num > 0 then
		local id
		for id = 1, num do
			VerifySpell(id, BOOKTYPE_PET)
		end
	end

	UpdateTabSpells(1)
	UpdateTabSpells(2)
	CallHooks("OnSpellsChanged")
end

--------------------------------------------------------
-- Talent Process
--------------------------------------------------------

local talentList = {}

local function UpdateTalentData()
	wipe(talentList)
	local row, col
	for row = 1, 7 do
		for col = 1, 3 do
			local id, name, _, learned = GetTalentInfo(row, col, 1)
			if name and learned then
				talentList[name] = i
			end
		end
	end
	CallHooks("OnTalentsChanged")
end

function lib:PlayerHasTalent(talent)
	return talentList[talent]
end

--------------------------------------------------------
-- Glyph Process
--------------------------------------------------------

local glyphList = {}

local function UpdateGlyphs()
	local i
	for i = 1, NUM_GLYPH_SLOTS do
		local _, _, _, id = GetGlyphSocketInfo(i)
		if id then
			local name = GetSpellInfo(id)
			if name then
				glyphList[name] = i
			end
		end
	end
end

function lib:PlayerHasGlyph(glyph)
    if(true) then return false end --fix7
	return glyphList[glyph]
end

--------------------------------------------------------
-- Spell Cast Recording
--------------------------------------------------------

local spellSentList = {}
local castTimeRecords = {}

local function UpdateCastingTime(spell, func)
	local _, _, _, startTime, endTime = func("player")
	if startTime and endTime then
		castTimeRecords[spell] = (endTime - startTime) / 1000
	end
end

function lib:GetSpellCastTime(spell, useRecord)
	if not self:PlayerHasSpell(spell) then
		return
	end

	local castTime
	if useRecord then
		castTime = castTimeRecords[spell]
	else
		castTime = select(7, GetSpellInfo(spell))
		if castTime then
			castTime = castTime / 1000
		end
	end

	if not castTime and type(useRecord) == "number" then
		castTime = useRecord
	end
	return castTime
end

function lib:WasSpellSent(spell, elapsed)
	local sentTime = spellSentList[spell]
	if sentTime then
		local timeSpan = GetTime() - sentTime
		if type(elapsed) == "number" then
			return timeSpan <= elapsed, timeSpan
		else
			return true, timeSpan
		end
	end
end

function lib:GetLastSentSpell()
	return self.lastSentSpell, self.lastSentTime
end

function lib:GetCastingSpell()
	return self.castingSpell
end

--------------------------------------------------------
-- Internal frame
--------------------------------------------------------

local frame = lib.frame
if not frame then
	frame = CreateFrame("Frame")
	lib.frame = frame
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("PLAYER_TALENT_UPDATE");

frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
frame:RegisterEvent("UNIT_SPELLCAST_STOP")
frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

local isLengthy

frame:SetScript("OnEvent", function(self, event, unit, spell)
	if event == "PLAYER_LOGIN" then
		UpdateSpellData()
		--fix7 UpdateGlyphs()

	elseif event == "SPELLS_CHANGED" then
		if not unit then
			UpdateSpellData()
			--fix7 UpdateGlyphs()
		end

	elseif event == "PLAYER_TALENT_UPDATE" then
		UpdateTalentData()

	elseif strfind(event, "UNIT_SPELLCAST_") == 1 and unit == "player" and spell and not IsAutoRepeatSpell(spell) then

		-- WOW's internal spell-casting events precedence:

		-- instant-casting:	UNIT_SPELLCAST_SENT -> UNIT_SPELLCAST_SUCCEEDED
		-- lenthy-casting:	UNIT_SPELLCAST_SENT -> UNIT_SPELLCAST_START -> [UNIT_SPELLCAST_SUCCEEDED ->] UNIT_SPELLCAST_STOP
		-- channeling:		UNIT_SPELLCAST_SENT -> UNIT_SPELLCAST_SUCCEEDED [-> UNIT_SPELLCAST_CHANNEL_START -> UNIT_SPELLCAST_CHANNEL_STOP]

		local now = GetTime()
		if event == "UNIT_SPELLCAST_SENT" then
			isLengthy = nil
		elseif event == "UNIT_SPELLCAST_START" then
			isLengthy = 1
			spellSentList[spell] = now
			lib.castingSpell = spell
			lib.lastSentSpell, lib.lastSentTime = spell, now
			UpdateCastingTime(spell, UnitCastingInfo)
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			isLengthy = 1
			spellSentList[spell] = now
			lib.castingSpell = spell
			lib.lastSentSpell, lib.lastSentTime = spell, now
			UpdateCastingTime(spell, UnitChannelInfo)
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			spellSentList[spell] = now
			lib.lastSentSpell, lib.lastSentTime = spell, now
			if not isLengthy then
				lib.castingSpell = nil
			end
		elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			isLengthy = nil
			lib.castingSpell = nil
		end
	end
end)
------------------------------------------------------------
-- LibAuraGroups-1.0.lua
--
-- A library for maintaining "aura groups", that is, buffs/debuffs those provide similar
-- effects, for example, Druid spell "Mark of the Wild" and Paladin spell "Blessing of Kings"
-- both provide "+5% to all stats", so they belong to the same aura group called "STATS".
--
-- Abin
-- 2012/9/08
--
------------------------------------------------------------
-- API documentation:
------------------------------------------------------------

-- lib = _G["LibAuraGroups-1.0"]
--
-- Get an object handle of the library.
------------------------------------------------------------

-- lib:GetAuraGroup("aura")
--
-- Returns name of the group to which the given aura belongs, if one exists.
------------------------------------------------------------

-- lib:GetGroupAuras("group")
--
-- Returns a table contains all auras belong to the given group, in format of { ["aura"] = spellId, ... },
-- or nil if the group does not exist.
------------------------------------------------------------

-- lib:UnitAura("unit", "aura" [, "group"])
--
-- Find the first aura that belongs to the same group with the given aura, if "group" is not
-- specified, the function searches for all groups until a match is found. Return values are:
-- name, icon, count, dispelType, duration, expires, caster, harmful.
------------------------------------------------------------

-- lib:AuraSameGroup("aura1", "aura2")
--
-- Returns name of the group to which both of the 2 given auras belong to.
------------------------------------------------------------

-- lib:UnitAffectDebuff("unit", "group")
--
-- Checks whether an unit is affected by the given debuff group.  Return values are:
-- name, icon, count, dispelType, duration, expires, caster.

------------------------------------------------------------
-- Group names & contents:
------------------------------------------------------------
--
-- STATS
-- Mark of the Wild, Legacy of the Emperor, Blessing of Kings, Embrace of the Shale Spider

-- STAMINA
-- Power Word: Fortitude, Imp: Blood Pact, Commanding Shout, Qiraji Fortitude, Dark Intent

-- ATTACK_POWER
-- Horn of the Winter, Trueshot Aura, Battle Shout

-- SPELL_POWER
-- Arcane Brilliance, Burning Wrath, Dark Intent, Dalaran Brilliance

-- ATTACK_HASTE
-- Unholy Aura, Swiftblade's Cunning, Unleashed Rage, Serpent's Swiftness

-- SPELL_HASTE
-- Moonkin Aura, Shadowform, Elemental Oath

-- CRITICAL_STRIKE
-- Leader of the Pack, Arcane Brilliance, Legacy of the White Tiger, Furious Howl, Dalaran Brilliance

--- MASTERY
-- Legacy of the White Tiger, Blessing of Might, Grace of Air, Roar of Courage

-- COOLDOWN_HASTE
-- Heroism, Exhausted, Bloodlust, Sated, Time Warp, Temporal Displacement, Ancient Hysteria

-- MAGE_ICE_BLOCK
-- Ice Block, Hypothermia

-- PALADIN_PROTECTION
-- Divine Shield, Hand of Protection, Forbearance

-- PRIEST_SHIELD
-- Power Word: Shield, Weakened Soul

-- MAGIC_VULNERABILITY
-- Master Poisoner, Curse of the Elements, Fire Breath, Lightning Breath

-- SLOW_CASTING
-- Necrotic Strike, Mind-numbing Poison, Curse of Enfeeblement, Slow, Spore Cloud, Tailspin, Lava Breath

------------------------------------------------------------
-- Debuff Effects:
------------------------------------------------------------

-- WEAKENED_ARMOR
-- Weaken Armor (Brought by: Faerie Fire, Expose Armor, Sunder Armor)

-- PHYSICAL_VULNERABILITY
-- Physical Vulnerability (Brought by: Brittle Bones, Ebon Plaguebringer, Judgments of the Bold, Colossus Smash)

-- MAGIC_VULNERABILITY
-- Master Poisoner, Curse of the Elements, Fire Breath, Lightning Breath

-- WEAKENED_BLOWS
-- Weakened Blows (Brought by: Scarlet Fever, Thrash, Hammer of the Righteous, Thunder Clap, Keg Smash, Earth Shock)

-- SLOW_CASTING
-- Necrotic Strike, Mind-numbing Poison, Curse of Enfeeblement, Slow, Spore Cloud, Tailspin, Lava Breath

-- MORTAL_WOUNDS
-- Mortal Wounds (Brought by: Mortal Strike, Wild Strike, Wound Poison, Widow Venom, Rising Sun Kick)
------------------------------------------------------------

local type = type
local select = select
local GetSpellInfo = GetSpellInfo
local pairs = pairs
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local _

local LIBNAME = "LibBuffGroups-1.0"
local VERSION = 1.06

local lib = _G[LIBNAME]
if lib and lib.version >= VERSION then return end

if not lib then
	lib = {}
	_G[LIBNAME] = lib
end
lib.version = VERSION
_G.LibBuffGroups = lib

local auraGroupList = {} -- Aura groups
local debuffGroupList = {} -- Debuff effect groups

local function AddGroup(groupList, group, ...)
	if type(group) ~= "string" then
		return
	end

	local count = select("#", ...)
	if count < 1 then
		return
	end

	local list = groupList[group]
	if not list then
		list = {}
		groupList[group] = list
	end

	local i
	for i = 1, count do
		local id = select(i, ...)
		local name = GetSpellInfo(id)
		if name then
			list[name] = id
		end
	end
end

local function AddAuraGroup(group, ...)
	AddGroup(auraGroupList, group, ...)
end

local function AddDebuffGroup(group, ...)
	AddGroup(debuffGroupList, group, ...)
end

------------------------------------------------------------
-- Initialize aura groups
------------------------------------------------------------

-- STATS
AddAuraGroup("STATS", 1126, 115921, 20217, 90363) -- Mark of the Wild, Legacy of the Emperor, Blessing of Kings, Embrace of the Shale Spider

-- STAMINA
AddAuraGroup("STAMINA", 109773, 21562, 103127, 469, 90364) -- Dark Intent, Power Word: Fortitude, Imp: Blood Pact, Commanding Shout, Qiraji Fortitude

-- ATTACK_POWER
AddAuraGroup("ATTACK_POWER", 57330, 19506, 6673) -- Horn of the Winter, Trueshot Aura, Battle Shout

-- SPELL_POWER
AddAuraGroup("SPELL_POWER", 109773, 1459, 77747, 61316) -- Dark Intent, Arcane Brilliance, Burning Wrath, Dalaran Brilliance

-- ATTACK_HASTE
AddAuraGroup("ATTACK_HASTE", 55610, 113742, 30809, 128433) -- Unholy Aura, Swiftblade's Cunning, Unleashed Rage, Serpent's Swiftness

-- SPELL_HASTE
AddAuraGroup("SPELL_HASTE", 24907, 15473, 51470) -- Moonkin Aura, Shadowform, Elemental Oath

-- CRITICAL_STRIKE
AddAuraGroup("CRITICAL_STRIKE", 17007, 1459, 116781, 24604, 61316) -- Leader of the Pack, Arcane Brilliance, Legacy of the White Tiger, Furious Howl, Dalaran Brilliance

--- MASTERY
AddAuraGroup("MASTERY", 116781, 19740, 116956, 93435) -- Legacy of the White Tiger, Blessing of Might, Grace of Air, Roar of Courage

-- COOLDOWN_HASTE
AddAuraGroup("COOLDOWN_HASTE", 32182, 57723, 2825, 57724, 80353, 80354, 90355) -- Heroism, Exhausted, Bloodlust, Sated, Time Warp, Temporal Displacement, Ancient Hysteria

-- MAGE_ICE_BLOCK
AddAuraGroup("MAGE_ICE_BLOCK", 27619, 41425) -- Ice Block, Hypothermia

-- PALADIN_PROTECTION
AddAuraGroup("PALADIN_PROTECTION", 642, 1022, 25771) -- Divine Shield, Hand of Protection, Forbearance

-- PRIEST_SHIELD
AddAuraGroup("PRIEST_SHIELD", 17, 6788) -- Power Word: Shield, Weakened Soul

-- MAGIC_VULNERABILITY
AddAuraGroup("MAGIC_VULNERABILITY", 58410, 1490, 34889, 24844) -- Master Poisoner, Curse of the Elements, Fire Breath, Lightning Breath

-- SLOW_CASTING
AddAuraGroup("SLOW_CASTING", 73975, 5761, 109466, 79880, 50274, 90314, 58604) -- Necrotic Strike, Mind-numbing Poison, Curse of Enfeeblement, Slow, Spore Cloud, Tailspin, Lava Breath


------------------------------------------------------------
-- Initialize debuff effect groups
------------------------------------------------------------

-- WEAKENED_ARMOR
AddDebuffGroup("WEAKENED_ARMOR", 113746) -- Faerie Fire, Expose Armor, Sunder Armor

-- PHYSICAL_VULNERABILITY
AddDebuffGroup("PHYSICAL_VULNERABILITY", 81326) -- Brittle Bones, Ebon Plaguebringer, Judgments of the Bold, Colossus Smash

-- MAGIC_VULNERABILITY
AddDebuffGroup("MAGIC_VULNERABILITY", 58410, 1490, 34889, 24844) -- Master Poisoner, Curse of the Elements, Fire Breath, Lightning Breath

-- WEAKENED_BLOWS
AddDebuffGroup("WEAKENED_BLOWS", 115798) -- Scarlet Fever, Thrash, Hammer of the Righteous, Thunder Clap, Keg Smash, Earth Shock

-- SLOW_CASTING
AddDebuffGroup("SLOW_CASTING", 73975, 5761, 109466, 79880, 50274, 90314, 58604) -- Necrotic Strike, Mind-numbing Poison, Curse of Enfeeblement, Slow, Spore Cloud, Tailspin, Lava Breath

-- MORTAL_WOUNDS
AddDebuffGroup("MORTAL_WOUNDS", 115804) -- Mortal Strike, Wild Strike, Wound Poison, Widow Venom, Rising Sun Kick


function lib:GetAuraGroup(aura)
	if not aura then
		return
	end

	local group
	for group, list in pairs(auraGroupList) do
		if list[aura] then
			return group
		end
	end
end

local function InternalGetGroupAuras(group)
	return auraGroupList[group]
end

function lib:GetGroupAuras(group)
	local list = InternalGetGroupAuras(group)
	if not list then
		return
	end

	local temp = {}
	local k, v
	for k, v in pairs(list) do
		temp[k] = v
	end
	return temp
end

local function FindAura(list, unit, exclude)
	if not list then
		return
	end

	local aura, name, icon, count, dispelType, duration, expires, caster
	for aura in pairs(list) do
		if aura ~= exclude then
			name, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster
			end

			name, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster, 1
			end
		end
	end
end

function lib:UnitAura(unit, aura, group)
	if type(unit) ~= "string" then
		return
	end

	if type(aura) ~= "string" then
		return FindAura(InternalGetGroupAuras(group), unit)
	end

	local name, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster
	end

	name, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster, 1
	end

	local list = InternalGetGroupAuras(group)
	if not list then
		local v
		for _, v in pairs(auraGroupList) do
			if v[aura] then
				list = v
				break
			end
		end
	end

	return FindAura(list, unit, aura)
end

function lib:AuraSameGroup(aura1, aura2)
	if aura1 and aura2 and aura1 ~= aura2 then
		local group, list
		for group, list in pairs(auraGroupList) do
			if list[aura1] and list[aura2] then
				return group
			end
		end
	end
end

function lib:UnitAffectDebuff(unit, group)
	if type(unit) ~= "string" then
		return
	end

	local list = debuffGroupList[group]
	if not list then
		return
	end

	local aura, name, icon, count, dispelType, duration, expires, caster
	for aura in pairs(list) do
		name, _, icon, count, dispelType, duration, expires, caster = Aby_UnitDebuff(unit, aura)
		if name then
			return name, icon, count, dispelType, duration, expires, caster
		end
	end
end
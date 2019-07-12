local Parrot = Parrot
local mod = Parrot:NewModule("CombatEventsData")

local Parrot_CombatEvents = Parrot:GetModule("CombatEvents")

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_CombatEvents_Data")
local deformat = LibStub("LibDeformat-3.0")
local db1

-- recycle and debug-stuff
local newList, del = Parrot.newList, Parrot.del
local newDict = Parrot.newDict
local unpackDictAndDel = Parrot.unpackDictAndDel
local debug = Parrot.debug

--[[============================================================================
-- local globals for faster access
--============================================================================]]
local bit_bor = bit.bor
local bit_band = bit.band
local UnitGUID = _G.UnitGUID
local GetComboPoints = _G.GetComboPoints

local PET = _G.PET
local INTERRUPT = _G.INTERRUPT
local HONOR_CONTRIBUTION_POINTS = _G.HONOR_CONTRIBUTION_POINTS
local REPUTATION = _G.REPUTATION
local FACTION_STANDING_INCREASED = _G.FACTION_STANDING_INCREASED
local FACTION_STANDING_DECREASED = _G.FACTION_STANDING_DECREASED
local SKILL_RANK_UP = _G.SKILL_RANK_UP
local XP = _G.XP

--[[============================================================================
-- some parser-lookup-tables
--============================================================================]]

local SchoolParser = {
	[1] = "Physical",
	[2] = "Holy",
	[4] = "Fire",
	[8] = "Nature",
	[16] = "Frost",
	[20] = "FrostFire",
	[24] = "Froststorm",
	[32] = "Shadow",
	[40] = "Shadowstorm",
	[64] = "Arcane"
}

local function retrieveAlternatePowerName(self, key)
	if key == ALTERNATE_POWER_INDEX then
		return select(10, UnitAlternatePowerInfo("player"))
	end
end

local PowerTypeParser = setmetatable({
		[-2] = HEALTH,
		[0] = MANA,
		[1] = RAGE,
		[2] = FOCUS,
		[3] = ENERGY,
		[4] = COMBO_POINTS,
		[5] = RUNES,
		[6] = RUNIC_POWER,
		[7] = SOUL_SHARDS,
		[8] = LUNAR_POWER,
		[9] = HOLY_POWER,
		[11] = MAELSTROM,
		[12] = CHI,
		[13] = INSANITY,
		[15] = DEMONIC_FURY,
		[16] = ARCANE_CHARGES,
		[17] = FURY,
		[18] = PAIN
	}, { __index = retrieveAlternatePowerName, })

-- lookup-table for damage-types
local LS = {
	["Physical"] = STRING_SCHOOL_PHYSICAL,
	["Holy"] = STRING_SCHOOL_HOLY,
	["Fire"] = STRING_SCHOOL_FIRE,
	["Nature"] = STRING_SCHOOL_NATURE,
	["Frost"] = STRING_SCHOOL_FROST,
	["Frostfire"] = STRING_SCHOOL_FROSTFIRE,
	["Froststorm"] = STRING_SCHOOL_FROSTSTORM,
	["Shadow"] = STRING_SCHOOL_SHADOW,
	["Shadowstorm"] = STRING_SCHOOL_SHADOWSTORM,
	["Arcane"] = STRING_SCHOOL_ARCANE,
}

--[[============================================================================
-- on enable
--============================================================================]]
local onEnableFuncs = {}
function mod:OnEnable()
	db1 = Parrot:GetModule("CombatEvents").db1
	for _,v in ipairs(onEnableFuncs) do
		v()
	end
end

--[[============================================================================
-- start helper-functions
--============================================================================]]

local coloredDamageAmount = function(info)
	local db = db1.profile.damageTypes
	local damageType = SchoolParser[info.damageType or 1]
	local amount = Parrot_CombatEvents:ShortenAmount(info.amount)

	if db.color and db[damageType] then
		return "|cff" .. db[damageType] .. amount .. "|r"
	else
		return amount
	end
end

local damageTypeString = function(info)
	local damageType = SchoolParser[info.damageType]
	if damageType then
		return LS[damageType] or tostring(damageType)
	else
		return ""
	end
end

local classColorStrings = {}
for k,v in pairs(RAID_CLASS_COLORS) do
	local r = v.r*255
	local g = v.g*255
	local b = v.b*255
	classColorStrings[k] = ("|cff%02x%02x%02x%%s|r"):format(r,g,b)
end

local powerTypeString = function(info)
	local powerType = PowerTypeParser[info.powerType] or UNKNOWN
	return powerType
end

--[[
-- functions to retrieve player-names (to hide realm-names)
--]]
local function retrieveSourceName(info)
	if not info.sourceName or not info.sourceID then return end
	if db1.profile.hideUnitNames == true then
		return "__NONAME__"
	end
	local result = info.sourceName
	if Parrot_CombatEvents.db1.profile.hideRealm and GetPlayerInfoByGUID(info.sourceID) then -- it's a player
		result = result:gsub("-.*", "")
	end
	if UnitIsPlayer(result) and db1.profile.classcolor then
		local _, class = UnitClass(result)
		result = classColorStrings[class]:format(result)
	end
	return result
end

local function retrieveDestName(info)
	if not info.recipientName then return end
	if db1.profile.hideUnitNames == true then
		return "__NONAME__"
	end
	local result = info.recipientName
	if Parrot_CombatEvents.db1.profile.hideRealm and GetPlayerInfoByGUID(info.recipientID) then -- it's a player
		result = result:gsub("-.*", "")
	end
	if UnitIsPlayer(result) and db1.profile.classcolor then
		local _, class = UnitClass(result)
		result = classColorStrings[class]:format(result)
	end
	return result
end

--[[
-- functions to retrieve abbrivated spellnames
--]]
local function retrieveAbilityName(info)
	return Parrot:GetModule("CombatEvents"):GetAbbreviatedSpell(info.abilityName)
end

local function retrieveExtraAbilityName(info)
	return Parrot:GetModule("CombatEvents"):GetAbbreviatedSpell(info.extraAbilityName)
end


--[[
-- Some spells emit Spellids to the combatlog that have icons different from
-- the ones in the spellbook. This table maps the spellid emitted by the
-- comabatlog to the spellID with the expected icon (spellbook, talent-tree)
--]]
local dumbIconOverride = {
	[31818] = GetSpellTexture(27222), -- Life Tap
	[22482] = GetSpellTexture(13877), -- Blade Flurry
	[48665] = GetSpellTexture(34411), -- Mutilate
	[48664] = GetSpellTexture(34411), -- Mutilate
	[53254] = GetSpellTexture(53217), -- Wild Quiver
	[52042] = GetSpellTexture(58757), -- Healing Stream Totem
}

--[[
-- helperfunction to retrieve an icon
--]]
local function retrieveIconFromAbilityName(info)
	local icon
	if(info.spellID) then
		icon = dumbIconOverride[info.spellID] or GetSpellTexture(info.spellID)
	elseif info.abilityName then
		--shouldn't be needed though, but to be sure
		icon = GetSpellTexture(info.abilityName)
	end
	return icon
end

--[[
-- list all missType. used to automatically register one CombatEvent for each
-- missType with Parrot
--]]
local missTypes = {
	ABSORB = "absorbs",
	BLOCK = "blocks",
	DODGE = "dodges",
	EVADE = "evades",
	IMMUNE = "immunes",
	MISS = "misses",
	PARRY = "parries",
	REFLECT = "reflects",
	RESIST = "resists",
	DEFLECT = "deflects",
}

--[[
-- localisations for missTypes
--]]
local LM = {
	ABSORB = _G.ABSORB,
	BLOCK = _G.BLOCK,
	DODGE = _G.DODGE,
	EVADE = _G.EVADE,
	IMMUNE = _G.IMMUNE,
	MISS = _G.MISS,
	PARRY = _G.PARRY,
	REFLECT = _G.REFLECT,
	RESIST = _G.RESIST,
	DEFLECT = _G.DEFLECT,
}

local defaultMissColor = {
	ABSORB = "ffff00", -- yellow
	BLOCK = "0000ff", -- blue
	DODGE = "0000ff", -- blue
	EVADE = "ff7fff", -- pink
	IMMUNE = "ffff00", -- yellow
	MISS = "0000ff", -- blue
	PARRY = "0000ff", -- blue
	REFLECT = "7f007f", -- purple
	RESIST = "7f007f", -- purple
	DEFLECT = "cccccc", -- light-grey
}

--[[============================================================================
-- some common check-functions
--============================================================================]]

-- first some flags
local TYPE_GUARDIAN = _G.COMBATLOG_OBJECT_TYPE_GUARDIAN
local TYPE_PET = _G.COMBATLOG_OBJECT_TYPE_PET
local TYPE_NPC = _G.COMBATLOG_OBJECT_TYPE_NPC
local TYPE_PLAYER = _G.COMBATLOG_OBJECT_TYPE_PLAYER

local CONTROL_NPC = _G.COMBATLOG_OBJECT_CONTROL_NPC
local CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER

local HOSTILE = _G.COMBATLOG_OBJECT_REACTION_HOSTILE
local NEUTRAL = _G.COMBATLOG_OBJECT_REACTION_NEUTRAL
local FRIENDLY = _G.COMBATLOG_OBJECT_REACTION_FRIENDLY

local AFFILIATION_OUTSIDER = _G.COMBATLOG_OBJECT_AFFILIATION_OUTSIDER
local AFFILIATION_RAID = _G.COMBATLOG_OBJECT_AFFILIATION_RAID
local AFFILIATION_PARTY = _G.COMBATLOG_OBJECT_AFFILIATION_PARTY
local AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE

-- now some flag-combos that are needed later
local PET_FLAGS = bit_bor(
	TYPE_PET,
	CONTROL_PLAYER,
	FRIENDLY,
	AFFILIATION_MINE
)

local GUARDIAN_FLAGS = bit_bor(
	TYPE_GUARDIAN,
	CONTROL_PLAYER,
	FRIENDLY,
	AFFILIATION_MINE
)

-- generic function to match 2 sets of flags
local function checkFlags(flags1, flags2)
	return bit_band(flags1, flags2) == flags2
end

--[[
-- The player is identified by GUID because it doesn't change ever.
-- All other units (pet, target, totems) are identified by flag-matching
--]]

-- cache the playerGUID onEnable
local playerGUID
table.insert(onEnableFuncs, function() playerGUID = UnitGUID("player") end)

local function checkPlayerInc(_, _, _, dstGUID, _, dstFlags)
	return dstGUID == playerGUID
end
local function checkPlayerOut(srcGUID, _, srcFlags)
	return srcGUID == playerGUID
end

-- check pet damage
local function checkPetInc(_, _, _, dstGUID, _, dstFlags)
	local good = checkFlags(dstFlags, PET_FLAGS)
	if not good and db1.profile.totemEvents then
		good = checkFlags(dstFlags, GUARDIAN_FLAGS)
	end
	return good
end
local function checkPetOut(srcGUID, _, srcFlags)
	local good = checkFlags(srcFlags, PET_FLAGS)
	if not good and db1.profile.totemEvents then
		good = checkFlags(srcFlags, GUARDIAN_FLAGS)
	end
	return good
end

-- check if the it's a full overheal and should be hidden
local function checkFullOverheal(t, amount, overheal)
	return bit_band(db1.profile.hideFullOverheals, t) == 0 or (amount - overheal) > 0
end

-- check player's heals
local function checkPlayerIncHeal(srcGUID, _, srcFlags, dstGUID, _, dstFlags,_, _, _, amount, overheal)
	return srcGUID ~= dstGUID and dstGUID == playerGUID and checkFullOverheal(2, amount, overheal)
end
local function checkPlayerIncHoT(srcGUID, _, srcFlags, dstGUID, _, dstFlags,_, _, _, amount, overheal)
	return srcGUID ~= dstGUID and dstGUID == playerGUID and checkFullOverheal(1, amount, overheal)
end

local function checkPlayerOutHeal(srcGUID, _, _, dstGUID, _, dstFlags, _, _, _, amount,
	overheal)
	return srcGUID ~= dstGUID and srcGUID == playerGUID and not checkFlags(dstFlags, PET_FLAGS) and checkFullOverheal(2, amount, overheal)
end
local function checkPlayerOutHoT(srcGUID, _, srcFlags, dstGUID, _, dstFlags,_, _, _, amount, overheal)
	return srcGUID ~= dstGUID and srcGUID == playerGUID and not checkFlags(dstFlags, PET_FLAGS) and checkFullOverheal(1, amount, overheal)
end

local function checkPlayerSelfHeal(srcGUID, _, _, dstGUID, _, _,_, _, _, amount,
	overheal)
	return srcGUID == dstGUID and dstGUID == playerGUID and checkFullOverheal(2, amount, overheal)
end
local function checkPlayerSelfHoT(srcGUID, _, srcFlags, dstGUID, _, dstFlags,_, _, _, amount, overheal)
	return srcGUID == dstGUID and dstGUID == playerGUID and checkFullOverheal(1, amount, overheal)
end

-- check pet heal
local function checkPetIncHeal(srcGUID, _, _, dstGUID, _, dstFlags,_, _, _,
	amount,	overheal)
	local good = checkFlags(dstFlags, PET_FLAGS)
	if not good and db1.profile.totemEvents then
		good = checkFlags(dstFlags, GUARDIAN_FLAGS)
	end
	return good
end
local function checkPetOutHeal(srcGUID, _, srcFlags, dstGUID, _, _,_, _, _,
	amount,	overheal)
	local good = srcGUID ~= dstGUID and dstGUID ~= playerGUID
	if not good then return false end
	good = checkFlags(srcFlags, PET_FLAGS)
	if not good and db1.profile.totemEvents then
		good = checkFlags(srcFlags, GUARDIAN_FLAGS)
	end
	return good
end

-- check for PvP
local function checkKillPvP(srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
	return srcGUID == playerGUID and checkFlags(dstFlags, CONTROL_PLAYER)
end
local function checkKillNPC(srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
	return srcGUID == playerGUID and checkFlags(dstFlags, CONTROL_NPC)
end

--[[============================================================================
-- functions to parse throttled data to one combat-message.
--============================================================================]]

local long_format_texts = {
	[" (%d hit, %d crit)"] = L[" (%d hit, %d crit)"],
	[" (%d hit, %d crits)"] = L[" (%d hit, %d crits)"],
	[" (%d hits, %d crit)"] = L[" (%d hits, %d crit)"],
	[" (%d hits, %d crits)"] = L[" (%d hits, %d crits)"],
	[" (%d hits)"] = L[" (%d hits)"],
	[" (%d crits)"] = L[" (%d crits)"],

	[" (%d heal, %d crit)"] = L[" (%d heal, %d crit)"],
	[" (%d heal, %d crits)"] = L[" (%d heal, %d crits)"],
	[" (%d heals, %d crit)"] = L[" (%d heals, %d crit)"],
	[" (%d heals, %d crits)"] = L[" (%d heals, %d crits)"],
	[" (%d heals)"] = L[" (%d heals)"],
	[" (%d crits)"] = L[" (%d crits)"],
}

local short_format_texts = {
	[" (%d hit, %d crit)"] = " (%dx, %d++)",
	[" (%d hit, %d crits)"] = " (%dx, %d++)",
	[" (%d hits, %d crit)"] = " (%dx, %d++)",
	[" (%d hits, %d crits)"] = " (%dx, %d++)",
	[" (%d hits)"] = " (%dx)",
	[" (%d crits)"] = " (%d++)",

	[" (%d heal, %d crit)"] = " (%dx, %d++)",
	[" (%d heal, %d crits)"] = " (%dx, %d++)",
	[" (%d heals, %d crit)"] = " (%dx, %d++)",
	[" (%d heals, %d crits)"] = " (%dx, %d++)",
	[" (%d heals)"] = " (%dx)",
	[" (%d crits)"] = " (%d++)",
}

local empty_format_texts = setmetatable({}, { __index = function(k) return "" end })

local function damageThrottleFunc(info)
	local L = db1.profile.useShortThrottleText and short_format_texts or long_format_texts
    if db1.profile.hideThrottleText then L = empty_format_texts end
	local numNorm = info.throttleCount_isCrit_false or 0
	local numCrit = info.throttleCount_isCrit_true or 0
	info.isCrit = numCrit > 0
	if numNorm == 1 then
		if numCrit == 1 then
			return L[" (%d hit, %d crit)"]:format(1, 1)
		elseif numCrit == 0 then
			-- just one hit
			return nil
		else -- >= 2
			return L[" (%d hit, %d crits)"]:format(1, numCrit)
		end
	elseif numNorm == 0 then
		if numCrit < 2 then
			-- just one crit
			return nil
		else -- >= 2
			return L[" (%d crits)"]:format(numCrit)
		end
	else -- >= 2
		if numCrit == 1 then
			return L[" (%d hits, %d crit)"]:format(numNorm, 1)
		elseif numCrit == 0 then
			-- just one hit
			return L[" (%d hits)"]:format(numNorm)
		else -- >= 2
			return L[" (%d hits, %d crits)"]:format(numNorm, numCrit)
		end
	end
end

local function missThrottleFunc(info)
	local num = info.throttleCount or 0
	if num > 1 then
		return db1.profile.hideThrottleText and "" or (" (%dx)"):format(num)
	else
		return ""
	end
end

local healThrottleFunc = function(info)
	local L = db1.profile.useShortThrottleText and short_format_texts or long_format_texts
    if db1.profile.hideThrottleText then L = empty_format_texts end
	local numNorm = info.throttleCount_isCrit_false or 0
	local numCrit = info.throttleCount_isCrit_true or 0
	info.isCrit = numCrit > 0
	if numNorm == 1 then
		if numCrit == 1 then
			return L[" (%d heal, %d crit)"]:format(1, 1)
		elseif numCrit == 0 then
			-- just one hit
			return nil
		else -- >= 2
			return L[" (%d heal, %d crits)"]:format(1, numCrit)
		end
	elseif numNorm == 0 then
		if numCrit < 2 then
			-- just one crit
			return nil
		else -- >= 2
			return L[" (%d crits)"]:format(numCrit)
		end
	else -- >= 2
		if numCrit == 1 then
			return L[" (%d heals, %d crit)"]:format(numNorm, 1)
		elseif numCrit == 0 then
			-- just one hit
			return L[" (%d heals)"]:format(numNorm)
		else -- >= 2
			return L[" (%d heals, %d crits)"]:format(numNorm, numCrit)
		end
	end
end

local function killingBlowThrottleFunc(info)
	local numNorm = info.throttleCount or 0
	if numNorm == 1 then
		-- just one hit
		return nil
	else -- >= 2
		return string.format(" (%d)",format(numNorm))
	end
end

local function repThrottleFunc(info)
	local num = info.throttleCount or 0
	if num > 1 then
		return db1.profile.hideThrottleText and "" or (" (%dx)"):format(num)
	end
	return nil
end

--[[============================================================================
-- Register Filtertypes
--============================================================================]]

Parrot:RegisterFilterType("Incoming damage", L["Incoming damage"], 0)
Parrot:RegisterFilterType("Incoming heals", L["Incoming heals"], 0)
Parrot:RegisterFilterType("Outgoing damage", L["Outgoing damage"], 0)
Parrot:RegisterFilterType("Outgoing heals", L["Outgoing heals"], 0)
Parrot:RegisterFilterType("Power gain", L["Power gain"], 0)

--[[============================================================================
-- Register ThrottleTypes
--============================================================================]]

Parrot:RegisterThrottleType("Melee damage", L["Melee damage"], 0.1, true)
Parrot:RegisterThrottleType("Avoids", L["Avoids"], 1.0, true)
Parrot:RegisterThrottleType("Skill damage", L["Skill damage"], 0.1, true)
Parrot:RegisterThrottleType("DoTs and HoTs", L["DoTs and HoTs"], 2)
Parrot:RegisterThrottleType("Heals", L["Heals"], 0.1, true)
Parrot:RegisterThrottleType("Power gain/loss", L["Power gain/loss"], 3)
Parrot:RegisterThrottleType("Killing blows", L["Killing blows"], 0.1, true)
Parrot:RegisterThrottleType("Reputation gains", L["Reputation gains"], 0.1, true)

--[[============================================================================
-- Tables that describe throttle-data for several combat-events
--============================================================================]]
local meleeThrottle = {
	"Melee damage",
	'recipientID',
	{ 'throttleCount', 'isCrit', damageThrottleFunc, },
	sourceName = L["Multiple"],
}

local missThrottle = {
	"Avoids",
	'missType',
	{ 'throttleCount', missThrottleFunc, },
	sourceName = L["Multiple"],
}

local skillThrottle = {
	"Skill damage",
	'abilityName',
	{ 'throttleCount', 'isCrit', damageThrottleFunc },
	sourceName = L["Multiple"]
}

local dotThrottle = {
	"DoTs and HoTs",
	'abilityName',
	{ 'throttleCount', 'isCrit', damageThrottleFunc },
	sourceName = L["Multiple"]
}

local hotThrottle = {
	"DoTs and HoTs",
	'abilityName',
	{ 'throttleCount', 'isCrit', healThrottleFunc },
	sourceName = L["Multiple"]
}

local healThrottle = {
	"Heals",
	'abilityName',
	{ 'throttleCount', 'isCrit', healThrottleFunc },
	sourceName = L["Multiple"]
}

local killingBlowThrottle = {
	"Killing blows",
	'sourceID',
	{ 'throttleCount', killingBlowThrottleFunc, },
	recipientName = L["Multiple"]
}

local repGainsThrottle = {
	"Reputation gains",
	'faction',
	{ 'throttleCount', repThrottleFunc, },
}

--[[============================================================================
-- often used tagtranslation-tables
--============================================================================]]

-- Incoming Skill damage
local incSkillDamageTagTranslations = {
	Name = retrieveSourceName,
	Amount = coloredDamageAmount,
	Type = damageTypeString,
	Skill = retrieveAbilityName,
	Icon = retrieveIconFromAbilityName,
}
local incSkillDamageTagTranslationsHelp = {
	Name = L["The name of the enemy that attacked you."],
	Amount = L["The amount of damage done."],
	Type = L["The type of damage done."],
	Skill = L["The spell or ability that the enemy attacked you with."],
}
local petIncSkillDamageTagTranslationsHelp = {
	Name = L["The name of the enemy that attacked your pet."],
	Amount = L["The amount of damage done."],
	Type = L["The type of damage done."],
	Skill = L["The spell or ability that the enemy attacked your pet with."],
}

-- Incoming Heals
local incHealTagTranslations = {
	Name = retrieveSourceName,
	Skill = retrieveAbilityName,
	Amount = "realAmount",
	Icon = retrieveIconFromAbilityName,
}
local incHealTagTranslationsHelp = {
	Name = L["The name of the ally that healed you."],
	Skill = L["The spell or ability that the ally healed you with."],
	Amount = L["The amount of healing done."],
}
local petIncHealTagTranslationsHelp = {
	Name = L["The name of the ally that healed your pet."],
	Skill = L["The spell or ability that the ally healed your pet with."],
	Amount = L["The amount of healing done."],
}

-- Incoming Melee-miss
local incMissTagTranslations = {
	Name = retrieveSourceName,
	Amount = "amount",
}
local incMissTagTranslationHelp = {
	Name = L["The name of the enemy that attacked you."],
	Amount = L["Amount of the damage that was missed."],
}
local petIncMissTagTranslationsHelp = {
	Name = L["The name of the enemy that attacked your pet."],
	Amount = L["Amount of the damage that was missed."],
}

-- Incoming Spell-miss
local incSpellMissTagTranslations = {
	Name = retrieveSourceName,
	Skill = retrieveAbilityName,
	Icon = retrieveIconFromAbilityName,
	Amount = "amount",
}
local incSpellMissTagTranslationsHelp = {
	Name = L["The name of the enemy that attacked you."],
	Skill = L["The spell or ability that the enemy attacked you with."],
	Amount = L["Amount of the damage that was missed."],
}
local incPetSpellMissTagTranslationsHelp = {
	Name = L["The name of the enemy that attacked you."],
	Skill = L["The spell or ability that the enemy attacked you with."],
	Amount = L["Amount of the damage that was missed."],
}

-- Outgoing skill damage
local outSkillDamageTagTranslations = {
	Name = retrieveDestName,
	Amount = coloredDamageAmount,
	Type = damageTypeString,
	Skill = retrieveAbilityName,
	Icon = retrieveIconFromAbilityName,
}
local outSkillDamageTagTranslationsHelp = {
	Name = L["The name of the enemy you attacked."],
	Amount = L["The amount of damage done."],
	Type = L["The type of damage done."],
	Skill = L["The spell or ability that you used."],
}
local petOutSkillDamageTagTranslationsHelp = {
	Name = L["The name of the enemy your pet attacked."],
	Amount = L["The amount of damage done."],
	Type = L["The type of damage done."],
	Skill = L["The ability or spell your pet used."],
}

-- Outgoing heal
local outHealTagTranslations = {
	Name = retrieveDestName,
	Skill = retrieveAbilityName,
	Amount = "realAmount",
	Icon = retrieveIconFromAbilityName,
}
local outHealTagTranslationsHelp = {
	Name = L["The name of the ally you healed."],
	Skill = L["The spell or ability that you used."],
	Amount = L["The amount of healing done."],
}
local petOutHealTagTranslationsHelp = {
	Name = L["The name of the unit that your pet healed."],
	Skill = L["The spell or ability that the pet used to heal."],
	Amount = L["The amount of healing done."],
}

-- Outgoing melee-miss
local outMissTagTranslations = {
	Name = retrieveDestName,
	Amount = "amount",
}
local outMissTagTranslationHelp = {
	Name = L["The name of the enemy you attacked."],
	Amount = L["Amount of the damage that was missed."],
}
--[[local petOutSpellMissTagTranslationsHelp = {
	Name = L["The name of the enemy your pet attacked."],
	Amount = L["Amount of the damage that was missed."],
}--]]

-- Outgoing spell-miss
local outSpellMissTagTranslations = {
	Name = retrieveDestName,
	Skill = retrieveAbilityName,
	Icon = retrieveIconFromAbilityName,
	Amount = "amount",
}
local outSpellMissTagTranslationsHelp = {
	Name = L["The name of the enemy you attacked."],
	Skill = L["The spell or ability that you used."],
	Amount = L["Amount of the damage that was missed."],
}
local petOutSpellMissTagTranslationsHelp = {
	Name = L["The name of the enemy your pet attacked."],
	Skill = L["The ability or spell your pet used."],
	Amount = L["Amount of the damage that was missed."],
}

-- for Dispel and Interrupt-events (using the ExtraSkill field)
local incDispelTagTranslations = {
	Name = retrieveSourceName,
	Skill = retrieveAbilityName,
	ExtraSkill = retrieveExtraAbilityName,
	Icon = retrieveIconFromAbilityName,
}
local outDispelTagTranslations = {
	Name = retrieveDestName,
	Skill = retrieveAbilityName,
	ExtraSkill = retrieveExtraAbilityName,
	Icon = retrieveIconFromAbilityName,
}


--[[============================================================================
-- #############################################################################
-- Incoming Events: ############################################################
-- #############################################################################
--============================================================================]]

--[[============================================================================
-- Incoming Events:
-- Damage
--===
=========================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Damage"],
	name = "Melee damage",
	localName = L["Melee damage"],
	defaultTag = "([Name]) -[Amount]",
	combatLogEvents = {
		SWING_DAMAGE = { check = checkPlayerInc, },
	},
	tagTranslations = {
		Name = retrieveSourceName,
		Amount = coloredDamageAmount,
	},
	tagTranslationsHelp = {
		Name = L["The name of the enemy that attacked you."],
		Amount = L["The amount of damage done."],
	},
	color = "ff0000", -- red
	canCrit = true,
	filterType = { "Incoming damage", 'amount' },
	throttle = meleeThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Damage"],
	name = "Reactive skills",
	localName = L["Reactive skills"],
	defaultTag = "([Name]) -[Amount]",
	combatLogEvents = {
		DAMAGE_SHIELD = { check = checkPlayerInc, },
	},
	tagTranslations = incSkillDamageTagTranslations,
	tagTranslationsHelp = incSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Incoming damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Damage"],
	name = "Skill damage",
	localName = L["Skill damage"],
	defaultTag = "([Name]) -[Amount]",
	combatLogEvents = {
		SPELL_DAMAGE = { check = checkPlayerInc, },
		RANGE_DAMAGE = { check = checkPlayerInc, },
		DAMAGE_SPLIT = { check = checkPlayerInc, },
	},
	tagTranslations = incSkillDamageTagTranslations,
	tagTranslationsHelp = incSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Incoming damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Damage"],
	name = "Skill DoTs",
	localName = L["Skill DoTs"],
	defaultTag = "([Name]) -[Amount]",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_DAMAGE = { check = checkPlayerInc, },
	},
	tagTranslations = incSkillDamageTagTranslations,
	tagTranslationsHelp = incSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	throttle = dotThrottle,
}

--[[============================================================================
-- Incoming Events:
-- Melee-misses
--============================================================================]]

--[[
locales for Babelfish.lua to catch
L["Melee absorbs"]
L["Melee blocks"]
L["Melee dodges"]
L["Melee evades"]
L["Melee immunes"]
L["Melee misses"]
L["Melee parries"]
L["Melee reflects"]
L["Melee resists"]
L["Melee deflects"]
--]]

for k,v in pairs(missTypes) do
	local name = "Melee " .. v
	local tag = k == "ABSORB" and "%s [Amount]!" or "%s!"
	local tag = tag:format(LM[k])
	local function check( _, _, _, dstGUID, _, _, missType)
		return (dstGUID == playerGUID and missType == k)
	end
	Parrot:RegisterCombatEvent{
		category = "Incoming",
		subCategory = L["Misses"],
		name = name ,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SWING_MISSED = { check = check, },
		},
		tagTranslations = incMissTagTranslations,
		tagTranslationsHelp = incMissTagTranslationHelp,
		throttle = missThrottle,
		color = defaultMissColor[k],
	}
end

--[[============================================================================
-- Incoming Events:
-- Spell-misses
--============================================================================]]
--[[
locales for Babelfish.lua to catch
L["Skill absorbs"]
L["Skill blocks"]
L["Skill dodges"]
L["Skill evades"]
L["Skill immunes"]
L["Skill misses"]
L["Skill parries"]
L["Skill reflects"]
L["Skill resists"]
L["Skill deflects"]
--]]

for k,v in pairs(missTypes) do
	local name = "Skill " .. v
	local tag = k == "ABSORB" and "([Skill]) %s [Amount]!" or "([Skill]) %s!"
	local tag = tag:format(LM[k])

	local function check(_, _, _, dstGUID, _, _,_, _, _, missType)
		return (dstGUID == playerGUID and missType == k)
	end

	Parrot:RegisterCombatEvent{
		category = "Incoming",
		subCategory = L["Misses"],
		name = name ,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SPELL_MISSED = { check = check, },
			SPELL_PERIODIC_MISSED = { check = check, },
			RANGE_MISSED = { check = check, },
		},
		tagTranslations = incSpellMissTagTranslations,
		tagTranslationsHelp = incSpellMissTagTranslationsHelp,
		throttle = missThrottle,
		color = defaultMissColor[k],
	}
end

--[[============================================================================
-- Incoming Events:
-- Heals
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Heals"],
	name = "Heals",
	localName = L["Heals"],
	defaultTag = "([Skill] - [Name]) +[Amount]",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPlayerIncHeal, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = incHealTagTranslationsHelp,
	color = "00ff00", -- green
	canCrit = true,
	filterType = { "Incoming heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Heals"],
	name = "Self heals",
	localName = L["Self heals"],
	defaultTag = "([Skill]) +[Amount]",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPlayerSelfHeal, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = incHealTagTranslationsHelp,
	color = "00ff00", -- green
	canCrit = true,
	filterType = { "Incoming heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Heals"],
	name = "Heals over time",
	localName = L["Heals over time"],
	defaultTag = "([Skill] - [Name]) +[Amount]",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPlayerIncHoT, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = incHealTagTranslationsHelp,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Incoming heals", 'realAmount' },
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Heals"],
	name = "Self heals over time",
	localName = L["Self heals over time"],
	defaultTag = "([Skill]) +[Amount]",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPlayerSelfHoT, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = incHealTagTranslationsHelp,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Incoming heals", 'realAmount' },
}

--[[============================================================================
-- Incoming Events:
-- Dispel
--============================================================================]]


Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Dispel"],
	name = "Dispel",
	localName = L["Dispel"],
	defaultTag = "[Skill] -[ExtraSkill]",
	combatLogEvents = {
		SPELL_DISPEL = { check = checkPlayerInc, },
	},
	tagTranslations = incDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit that dispelled the spell from you"],
		Skill = L["The name of the spell that has been used for dispelling."],
		ExtraSkill = L["The name of the spell that has been dispelled."],
	},
	color = "ffffff" -- white
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Dispel"],
	name = "Dispel fail",
	localName = L["Dispel fail"],
	defaultTag = L["%s failed"]:format("[Skill]"),
	combatLogEvents = {
		SPELL_DISPEL_FAILED = { check = checkPlayerInc, },
	},
	tagTranslations = incDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit that failed dispelling the spell from you"],
		Skill = L["The name of the spell that has been used for dispelling."],
		ExtraSkill = L["The name of the spell that has not been dispelled."],
	},
	sticky = true,
	color = "ffffff" -- white
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Dispel"],
	name = "Spell steal",
	localName = L["Spell steal"],
	defaultTag = L["%s stole %s"]:format("[Skill]", "[ExtraSkill]"),
	combatLogEvents = {
		SPELL_STOLEN = { check = checkPlayerInc, },
	},
	tagTranslations = incDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit that stole the spell from you"],
		Skill = L["The name of the spell that has been used for stealing."],
		ExtraSkill = L["The name of the spell that has been stolen."],
	},
	color = "ffffff" -- white
}

--[[============================================================================
-- Incoming Events:
-- Other incoming combat-stuff
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Other"],
	name = "Skill interrupts",
	localName = L["Skill interrupts"],
	defaultTag = "([Skill]) " .. INTERRUPT .. "! {[ExtraSkill]}",
	combatLogEvents = {
		SPELL_INTERRUPT = { check = checkPlayerInc, },
	},
	tagTranslations = incDispelTagTranslations,
	tagTranslationsHelp = {
		Name = L["The name of the enemy that attacked you."],
		Skill = L["The spell or ability that the enemy attacked you with."],
		ExtraSkill = L["Skill you were interrupted in casting"]
	},
	color = "ffff00", -- yellow
}

local function parseEnvironmentalDamage(info)
	return _G["ACTION_ENVIRONMENTAL_DAMAGE_" .. string.upper(info.environmentalType)]
end

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Other"],
	name = "Environmental damage",
	localName = L["Environmental damage"],
	defaultTag = "-[Amount] [Type]",
	combatLogEvents = {
		ENVIRONMENTAL_DAMAGE = { check = checkPlayerInc, },
	},
	tagTranslations = {
		Amount = "amount",
		Type = parseEnvironmentalDamage,
	},
	tagTranslationsHelp = {
		Amount = L["The amount of damage done."],
		Type = L["The type of damage done."],
	},
	color = "ff0000", -- red
}

--[[============================================================================
-- #############################################################################
-- Incoming Pet Events: ########################################################
-- #############################################################################
--============================================================================]]

--[[============================================================================
-- Incoming Pet Events:
-- Damage
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Pet damage"],
	name = "Pet melee damage",
	localName = L["Pet melee damage"],
	defaultTag = PET .. " -[Amount]",
	combatLogEvents = {
		SWING_DAMAGE = { check = checkPetInc, },
	},
	tagTranslations = {
		Name = retrieveSourceName,
		Amount = coloredDamageAmount,
	},
	tagTranslationsHelp = {
		Name = L["The name of the enemy that attacked your pet."],
		Amount = L["The amount of damage done."],
	},
	color = "ff0000", -- red
	canCrit = true,
	filterType = { "Incoming damage", 'amount' },
	throttle = meleeThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Pet damage"],
	name = "Pet skill damage",
	localName = L["Pet skill damage"],
	defaultTag = PET .. " -[Amount]",
	combatLogEvents = {
		SPELL_DAMAGE = { check = checkPetInc, },
		RANGE_DAMAGE = { check = checkPetInc, },
		DAMAGE_SPLIT = { check = checkPetInc, },
		DAMAGE_SHIELD = { check = checkPetInc, },
	},
	tagTranslations = incSkillDamageTagTranslations,
	tagTranslationsHelp = petIncSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Incoming damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Pet damage"],
	name = "Pet skill DoTs",
	localName = L["Pet skill DoTs"],
	defaultTag = PET .. " -[Amount]",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_DAMAGE = { check = checkPetInc, },
	},
	tagTranslations = incSkillDamageTagTranslations,
	tagTranslationsHelp = petIncSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	throttle = dotThrottle,
}

--[[============================================================================
-- Incoming Pet Events:
-- Melee miss
--============================================================================]]

local petMissColor = {
	RESIST = "7f7fb2", -- blue-gray
	EVADE = "7f7fff", -- light blue
}
--[[
locales for Babelfish.lua to catch
L["Pet melee absorbs"]
L["Pet melee blocks"]
L["Pet melee dodges"]
L["Pet melee evades"]
L["Pet melee immunes"]
L["Pet melee misses"]
L["Pet melee parries"]
L["Pet melee reflects"]
L["Pet melee resists"]
L["Pet melee deflects"]
--]]
for k,v in pairs(missTypes) do
	local name = "Pet melee " .. v
	local tag = k == "ABSORB" and "%s %s [Amount]!" or "%s %s!"
	local tag = tag:format(PET, LM[k])
	local function check(srcGUID, _, _, dstGUID, _, dstFlags, missType)
		return missType == k and checkPetInc(nil, nil, nil, dstGUID, nil, dstFlags)
	end
	Parrot:RegisterCombatEvent{
		category = "Incoming",
		subCategory = L["Pet misses"],
		name = name,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SWING_MISSED = { check = check, },
		},
		tagTranslations = incMissTagTranslations,
		tagTranslationsHelp = petIncMissTagTranslationsHelp,
		throttle = missThrottle,
		color = petMissColor[k] or defaultMissColor[k],
	}
end

--[[============================================================================
-- Incoming Pet Events:
-- Spell-misses
--============================================================================]]

--[[
locales for Babelfish.lua to catch
L["Pet skill absorbs"]
L["Pet skill blocks"]
L["Pet skill dodges"]
L["Pet skill evades"]
L["Pet skill immunes"]
L["Pet skill misses"]
L["Pet skill parries"]
L["Pet skill reflects"]
L["Pet skill resists"]
L["Pet skill deflects"]
--]]

for k,v in pairs(missTypes) do
	local name = "Pet skill " .. v
	local tag = k == "ABSORB" and "%s %s [Amount]! ([Skill])" or "%s %s! ([Skill])"
	local tag = tag:format(PET, LM[k])

	local function check(srcGUID, _, _, dstGUID, _, dstFlags, _, _, _, missType)
		return missType == k and checkPetInc(nil, nil, nil, dstGUID, nil, dstFlags)
	end

	Parrot:RegisterCombatEvent{
		category = "Incoming",
		subCategory = L["Pet misses"],
		name = name,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SPELL_MISSED = { check = check, },
			SPELL_PERIODIC_MISSED = { check = check, },
			RANGE_MISSED = { check = check, },
		},
		tagTranslations = incSpellMissTagTranslations,
		tagTranslationsHelp = incPetSpellMissTagTranslationsHelp,
		throttle = missThrottle,
		color = petMissColor[k] or defaultMissColor[k],
	}
end

--[[============================================================================
-- Incoming Pet Events:
-- Heals
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Pet heals"],
	name = "Pet heals",
	localName = L["Pet heals"],
	defaultTag = PET .. " +[Amount]",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPetIncHeal, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = petIncHealTagTranslationsHelp,
	color = "00ff00", -- green
	canCrit = true,
	filterType = { "Incoming heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Pet heals"],
	name = "Pet heals over time",
	localName = L["Pet heals over time"],
	defaultTag = PET .. " ([Skill] - [Name]) +[Amount]",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPetIncHeal, },
	},
	tagTranslations = incHealTagTranslations,
	tagTranslationsHelp = petIncHealTagTranslationsHelp,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Incoming heals", 'realAmount' },
}

--[[============================================================================
-- Incoming Pet Events:
-- Other
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Incoming",
	subCategory = L["Other"],
	name = "Pet Skill interrupts",
	localName = L["Pet skill interrupts"],
	defaultTag = PET .. " ([Skill]) " .. INTERRUPT .. "! {[ExtraSkill]}",
	combatLogEvents = {
		SPELL_INTERRUPT = { check = checkPetInc, },
	},
	tagTranslations = incDispelTagTranslations,
	tagTranslationsHelp = {
		Name = L["The name of the enemy that attacked your pet."],
		Skill = L["The spell or ability that the enemy attacked your pet with."],
		ExtraSkill = L["Skill your pet was interrupted in casting"]
	},
	color = "ffff00", -- yellow
}

--[[============================================================================
-- #############################################################################
-- Outgoing Events: ############################################################
-- #############################################################################
--============================================================================]]

--[[============================================================================
-- Outgoing Events:
-- Damage
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Damage"],
	name = "Melee damage",
	localName = L["Melee damage"],
	defaultTag = "[Amount]",
	combatLogEvents = {
		SWING_DAMAGE = { check = checkPlayerOut, },
	},
	tagTranslations = {
		Name = retrieveDestName,
		Amount = coloredDamageAmount,
	},
	tagTranslationsHelp = {
		Name = L["The name of the enemy you attacked."],
		Amount = L["The amount of damage done."],
	},
	color = "ffffff", -- white
	canCrit = true,
	filterType = { "Outgoing damage", 'amount' },
	throttle = meleeThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Damage"],
	name = "Reactive skills",
	localName = L["Reactive skills"],
	defaultTag = "[Amount] ([Skill])",
	combatLogEvents = {
		DAMAGE_SHIELD = { check = checkPlayerOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = outSkillDamageTagTranslationsHelp,
	color = "ffff00", -- yellow
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Outgoing damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Damage"],
	name = "Skill damage",
	localName = L["Skill damage"],
	defaultTag = "[Amount] ([Skill])",
	combatLogEvents = {
		SPELL_DAMAGE = { check = checkPlayerOut,	},
		RANGE_DAMAGE = { check = checkPlayerOut, },
		DAMAGE_SPLIT = { check = checkPlayerOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = outSkillDamageTagTranslationsHelp,
	color = "ffff00", -- yellow
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Outgoing damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Damage"],
	name = "Skill DoTs",
	localName = L["Skill DoTs"],
	defaultTag = "[Amount] ([Skill])",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_DAMAGE = { check = checkPlayerOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = outSkillDamageTagTranslationsHelp,
	color = "ffff00", -- yellow
	throttle = dotThrottle,
	filterType = { "Outgoing damage", 'amount' },
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Damage"],
	name = "Siege damage",
	localName = L["Siege damage"],
	defaultTag = "[Amount] ([Skill])",
	canCrit = true,
	combatLogEvents = {
		SPELL_BUILDING_DAMAGE = { check = checkPlayerOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = outSkillDamageTagTranslationsHelp,
	color = "ff0000", -- red
	throttle = skillThrottle,
	filterType = { "Outgoing damage", 'amount' },
}

--[[============================================================================
-- Outgoing Events:
-- Melee-misses
--============================================================================]]

for k,v in pairs(missTypes) do
	local name = "Melee " .. v
	local tag = k == "ABSORB" and "%s [Amount]!" or "%s!"
	local tag = tag:format(LM[k])
	local function check( srcGUID, _, _, _, _, _, missType)
		return (srcGUID == playerGUID and missType == k)
	end
	Parrot:RegisterCombatEvent{
		category = "Outgoing",
		subCategory = L["Misses"],
		name = name ,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SWING_MISSED = { check = check, },
		},
		tagTranslations = outMissTagTranslations,
		tagTranslationsHelp = outMissTagTranslationHelp,
		throttle = missThrottle,
		color = defaultMissColor[k],
	}
end

--[[============================================================================
-- Outgoing Events:
-- Spell-misses
--============================================================================]]

for k,v in pairs(missTypes) do
	local name = "Skill " .. v
	local tag = k == "ABSORB" and "%s [Amount]! ([Skill])" or "%s! ([Skill])"
	local tag = tag:format(LM[k])
	local function check( srcGUID, _, _, _, _, _,_, _, _, missType)
		return (srcGUID == playerGUID and missType == k)
	end
	Parrot:RegisterCombatEvent{
		category = "Outgoing",
		subCategory = L["Misses"],
		name = name,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SPELL_MISSED = { check = check, },
			SPELL_PERIODIC_MISSED = { check = check, },
			RANGE_MISSED = { check = check, },
		},
		tagTranslations = outSpellMissTagTranslations,
		tagTranslationsHelp = outSpellMissTagTranslationsHelp,
		throttle = missThrottle,
		color = defaultMissColor[k],
	}
end

--[[============================================================================
-- Outgoing Events:
-- Heals
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Heals"],
	name = "Heals",
	localName = L["Heals"],
	defaultTag = "+[Amount] ([Skill] - [Name])",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPlayerOutHeal, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = outHealTagTranslationsHelp,
	color = "00ff00", -- green
	canCrit = true,
	filterType = { "Outgoing heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Heals"],
	name = "Self heals",
	localName = L["Self heals"],
	defaultTag = "+[Amount] ([Skill])",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPlayerSelfHeal, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = outHealTagTranslationsHelp,
	color = "00ff00", -- green
	canCrit = true,
	defaultDisabled = true,
	filterType = { "Outgoing heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Heals"],
	name = "Heals over time",
	localName = L["Heals over time"],
	defaultTag = "+[Amount] ([Skill] - [Name])",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPlayerOutHoT, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = outHealTagTranslationsHelp,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Outgoing heals", 'realAmount' },
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Heals"],
	name = "Self heals over time",
	localName = L["Self heals over time"],
	defaultTag = "+[Amount] ([Skill])",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPlayerSelfHoT, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = outHealTagTranslationsHelp,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Outgoing heals", 'realAmount' },
	defaultDisabled = true,
}

--[[============================================================================
-- Outgoing Events:
-- Dispel
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Dispel"],
	name = "Dispel",
	localName = L["Dispel"],
	defaultTag = "[Skill] -[ExtraSkill]",
	combatLogEvents = {
		SPELL_DISPEL = { check = checkPlayerOut, },
	},
	tagTranslations = outDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit from which the spell has been removed."],
		Skill = L["The name of the spell that has been used for dispelling."],
		ExtraSkill = L["The name of the spell that has been dispelled."],
	},
	color = "ffffff" -- white
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Dispel"],
	name = "Dispel fail",
	localName = L["Dispel fail"],
	defaultTag = L["%s failed"]:format("[Skill]"),
	combatLogEvents = {
		SPELL_DISPEL_FAILED = { check = checkPlayerOut, },
	},
	tagTranslations = outDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit from which the spell has not been removed."],
		Skill = L["The name of the spell that has been used for dispelling."],
		ExtraSkill = L["The name of the spell that has not been dispelled."],
	},
	sticky = true,
	color = "ffffff" -- white
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Dispel"],
	name = "Spell steal",
	localName = L["Spell steal"],
	defaultTag = L["%s stole %s"]:format("[Skill]", "[ExtraSkill]"),
	combatLogEvents = {
		SPELL_STOLEN = { check = checkPlayerOut, },
	},
	tagTranslations = outDispelTagTranslations,
	tagTranslationHelp = {
		Name = L["The name of the unit from which the spell has been stolen."],
		Skill = L["The name of the spell that has been used for stealing."],
		ExtraSkill = L["The name of the spell that has been stolen."],
	},
	color = "ffffff" -- white
}

--[[============================================================================
-- Outgoing Events:
-- Other
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Other"],
	name = "Spell interrupts",
	localName = L["Skill interrupts"],
	defaultTag = "([Skill]) " .. INTERRUPT .. "! {[ExtraSkill]}",
	combatLogEvents = {
		SPELL_INTERRUPT = { check = checkPlayerOut, },
	},
	tagTranslations = outDispelTagTranslations,
	tagTranslationsHelp = {
		Name = L["The name of the enemy you attacked."],
		Skill = L["The spell or ability that you used."],
		ExtraSkill = L["The spell you interrupted"]
	},
	color = "ffff00", -- yellow
}

--[[============================================================================
-- #############################################################################
-- Outgoing Pet Events: ########################################################
-- #############################################################################
--============================================================================]]

--[[============================================================================
-- Outgoing Pet Events:
-- Damage
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet damage"],
	name = "Pet melee damage",
	localName = L["Pet melee damage"],
	defaultTag = PET .. " [Amount]",
	combatLogEvents = {
		SWING_DAMAGE = { check = checkPetOut, },
	},
	tagTranslations = {
		Name = retrieveDestName,
		Amount = "amount",
	},
	tagTranslationsHelp = {
		Name = L["The name of the enemy your pet attacked."],
		Amount = L["The amount of damage done."],
	},
	color = "ff7f00", -- orange
	canCrit = true,
	throttle = meleeThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet damage"],
	name = "Pet skill damage",
	localName = L["Pet skill damage"],
	defaultTag = PET .. " [Amount] ([Skill])",
	combatLogEvents = {
		SPELL_DAMAGE = { check = checkPetOut, },
		RANGE_DAMAGE = { check = checkPetOut, },
		DAMAGE_SPLIT = { check = checkPetOut, },
		DAMAGE_SHIELD = { check = checkPetOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = petOutSkillDamageTagTranslationsHelp,
	color = "0000ff", -- blue
	canCrit = true,
	throttle = skillThrottle,
	filterType = { "Outgoing damage", 'amount' },

}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet damage"],
	name = "Pet skill DoTs",
	localName = L["Pet skill DoTs"],
	defaultTag = PET .. " [Amount] ([Skill])",
	canCrit = true,
	combatLogEvents = {
		SPELL_PERIODIC_DAMAGE = { check = checkPetOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = petOutSkillDamageTagTranslationsHelp,
	throttle = dotThrottle,
	color = "ffff00", -- yellow
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet damage"],
	name = "Pet siege damage",
	localName = L["Pet siege damage"],
	defaultTag = PET .. " [Amount] ([Skill])",
	canCrit = true,
	combatLogEvents = {
		SPELL_BUILDING_DAMAGE = { check = checkPetOut, },
	},
	tagTranslations = outSkillDamageTagTranslations,
	tagTranslationsHelp = petOutSkillDamageTagTranslationsHelp,
	color = "ff7f00", -- orange
	throttle = skillThrottle,
}

--[[============================================================================
-- Outgoing Pet Events:
-- Melee misses
--============================================================================]]

for k,v in pairs(missTypes) do
	local name = "Pet melee " .. v
	local tag = k == "ABSORB" and "%s %s [Amount]!" or "%s %s!"
	local tag = tag:format(PET, LM[k])

	local function check(srcGUID, _, srcFlags, _, _, _, missType)
		return missType == k and checkPetOut(srcGUID, nil, srcFlags)
	end

	Parrot:RegisterCombatEvent{
		category = "Outgoing",
		subCategory = L["Pet misses"],
		name = name,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SWING_MISSED = { check = check, },
		},
		tagTranslations = outMissTagTranslations,
		tagTranslationsHelp = {
			Name = L["The name of the enemy your pet attacked."],
		},
		color = petMissColor[k] or defaultMissColor[k],
		throttle = missThrottle,
	}
end

--[[============================================================================
-- Outgoing Pet Events:
-- Spell misses
--============================================================================]]

for k,v in pairs(missTypes) do
	local name = "Pet skill " .. v
	local tag = k == "ABSORB" and "%s %s [Amount]! ([Skill])" or "%s %s! ([Skill])"
	local tag = tag:format(PET, LM[k])

	local function check(srcGUID, _, srcFlags, _, _, _, _, _, _, missType)
		return missType == k and checkPetOut(srcGUID, nil, srcFlags)
	end

	Parrot:RegisterCombatEvent{
		category = "Outgoing",
		subCategory = L["Pet misses"],
		name = name,
		localName = L[name],
		defaultTag = tag,
		combatLogEvents = {
			SPELL_MISSED = { check = check, },
			SPELL_PERIODIC_MISSED = { check = check, },
			RANGE_MISSED = { check = check, },
		},
		tagTranslations = outSpellMissTagTranslations,
		tagTranslationsHelp = petOutSpellMissTagTranslationsHelp,
		throttle = missThrottle,
		color = petMissColor[k] or defaultMissColor[k],
	}
end

--[[============================================================================
-- Outgoing Pet Events:
-- Heals
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet heals"],
	name = "Pet heals",
	localName = L["Pet heals"],
	defaultTag = PET .. " +[Amount]",
	combatLogEvents = {
		SPELL_HEAL = { check = checkPetOutHeal, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = petOutHealTagTranslations,
	color = "00ff00", -- green
	canCrit = true,
	filterType = { "Outgoing heals", 'realAmount' },
	throttle = healThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Pet heals"],
	name = "Pet heals over time",
	localName = L["Pet heals over time"],
	defaultTag = PET .. " ([Skill] - [Name]) +[Amount]",
	canCrit = true, -- Pets cannot crit-heal (or can they?)
	combatLogEvents = {
		SPELL_PERIODIC_HEAL = { check = checkPetOutHeal, },
	},
	tagTranslations = outHealTagTranslations,
	tagTranslationsHelp = petOutHealTagTranslations,
	throttle = hotThrottle,
	color = "00ff00", -- green
	filterType = { "Incoming heals", 'realAmount' },
}

--[[============================================================================
-- Outgoing Pet Events:
-- Other
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Outgoing",
	subCategory = L["Other"],
	name = "Pet spell interrupts",
	localName = L["Pet skill interrupts"],
	defaultTag = "([Skill]) " .. INTERRUPT .. "! {[ExtraSkill]}",
	combatLogEvents = {
		SPELL_INTERRUPT = { check = checkPetOut, },
	},
	tagTranslations = outDispelTagTranslations,
	tagTranslationsHelp = {
		Name = L["The name of the enemy your pet attacked."],
		Skill = L["The spell or ability that your pet used."],
		ExtraSkill = L["The spell your pet interrupted"]
	},
	color = "ffff00", -- yellow
}

--[[============================================================================
-- #############################################################################
-- Notification Events: ########################################################
-- #############################################################################
--============================================================================]]

local function powerGainThrottleFunc(info)
	local numNorm = info.throttleCount or 0
	if numNorm == 1 then
		-- just one gain
		return nil
	else -- >= 2
		return L[" (%d gains)"]:format(numNorm)
	end
end

local powerGainThrottle = {
	"Power gain/loss",
	'abilityName',
	{ 'throttleCount', powerGainThrottleFunc, },
	sourceName = L["Multiple"],
	recipientName = L["Multiple"],
}

--[[============================================================================
-- Notification Events:
-- Power change
--============================================================================]]
Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Power change"],
	name = "Power gain",
	localName = L["Power gain"],
	defaultTag = "+[Amount] [Type]",
	combatLogEvents = {
		SPELL_ENERGIZE = { check = checkPlayerInc, },
		SPELL_PERIODIC_ENERGIZE = { check = checkPlayerInc, },
		SPELL_LEECH = { check = checkPlayerOut, },
		SPELL_PERIODIC_LEECH = { check = checkPlayerOut, },
	},
	tagTranslations = {
		Amount = "amount",
		Type = powerTypeString,
		Skill = retrieveAbilityName,
		Name = function(info)
			return info.recipientName or info.sourceName
		end,
		Icon = retrieveIconFromAbilityName,
	},
	tagTranslationsHelp = {
		Amount = L["The amount of power gained."],
		Type = L["The type of power gained (Mana, Rage, Energy)."],
		Skill = L["The ability or spell used to gain power."],
		Name = L["The character that the power comes from."],
	},
	color = "ffff00", -- yellow
	throttle = powerGainThrottle,
	filterType = { "Power gain", function(info)
			return info.amountGained or info.amount
	end}
}

local function powerLossThrottleFunc(info)
	local numNorm = info.throttleCount or 0
	if numNorm == 1 then
		-- just one gain
		return nil
	else -- >= 2
		return L[" (%d gains)"]:format(numNorm)
	end
end

local powerLossThrottle = {
	"Power gain/loss",
	'abilityName',
	{ 'throttleCount', powerLossThrottleFunc, },
	sourceName = L["Multiple"],
}

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Power change"],
	name = "Power loss",
	localName = L["Power loss"],
	defaultTag = "-[Amount] [Type]",
	combatLogEvents = {
		SPELL_DRAIN = { check = checkPlayerInc, },
		SPELL_LEECH = { check = checkPlayerInc, },
		SPELL_PERIODIC_LEECH = { check = checkPlayerInc, },
	},
	tagTranslations = {
		Amount = "amount",
		Type = powerTypeString,
		Skill = retrieveAbilityName,
		Name = retrieveSourceName,
		Icon = retrieveIconFromAbilityName,
	},
	tagTranslationsHelp = {
		Amount = L["The amount of power lost."],
		Type = L["The type of power lost (Mana, Rage, Energy)."],
		Skill = L["The ability or spell take away your power."],
		Name = L["The character that caused the power loss."],
	},
	color = "ffff00", -- yellow
	throttle = powerLossThrottle,
}

--[[============================================================================
-- Notification Events:
-- Combo points
--============================================================================]]

-- local variable to prevent double-combo-point-messages (?)
local cur = 0
local function parseCPGain()
	local num = GetComboPoints("player", "target")
	if cur == num then return end
	cur = num
	if num > 0 and num < 5 then
		return newList(num)
	end
end

local function parseCPFull()
	local num = GetComboPoints("player", "target")
	if num == 5 then
		return newList(num)
	end
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Combo points"],
	name = "Combo point gain",
	localName = L["Combo point gain"],
	defaultTag = L["[Num] CP"],
	blizzardEvents = {
		--UNIT_COMBO_POINTS = { parse = parseCPGain, }, --TODO aby8
	},
	tagTranslations = {
		Num = 1
	},
	tagTranslationHelp = {
		Num = L["The current number of combo points."]
	},
	color = "ff7f00", -- orange
}

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Combo points"],
	name = "Combo points full",
	localName = L["Combo points full"],
	defaultTag = L["[Num] CP Finish It!"],
	blizzardEvents = {
		--UNIT_COMBO_POINTS = { parse = parseCPFull, },
	},
	tagTranslations = {
		Num = 1
	},
	tagTranslationHelp = {
		Num = L["The current number of combo points."]
	},
	color = "ff7f00", -- orange
}

--[[============================================================================
-- Notification Events:
-- Point gains
--============================================================================]]

local currencies = { 241, 402, 390, 81, 61, 398, 384, 393, 392, 361, 395, 400, 394, 397, 391, 401, 385, 396, 399, }
local currencyIcons = {}
for _,v in ipairs(currencies) do
	local name, amount, icon = GetCurrencyInfo(v)
    if icon then currencyIcons[name] = [[Interface\Icons\]] .. icon end
end

local function parseCurrencyUpdate(message)
	local currency, amount = deformat(message, CURRENCY_GAINED_MULTIPLE)
	if not currency then
		currency = deformat(message, CURRENCY_GAINED)
		if not currency then
			return
		end
		amount = 1
	end
	local icon = currencyIcons[currency]
	return newDict("currency", currency, "amount", amount, "icon", icon)
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	name = "Currency gains",
	localName = L["Currency gains"],
	defaultTag = "+[Amount] [Currency]",
	tagTranslations = {
		Amount = "amount",
		Currency = "currency",
		Icon = "icon",
	},
	tagTranslationHelp = {
		Amount = L["The amount of currency gained."],
		Name = L["Name of the currency"],
		
	},
	color = "7f7fb2", -- blue-gray
	blizzardEvents = {
		CHAT_MSG_CURRENCY = { parse = parseCurrencyUpdate, },
	}
}--]]

-- Reputation
function parseRepGain(chatmsg)
	local faction, amount = deformat(chatmsg, FACTION_STANDING_INCREASED)
	if faction and amount then
		local info = newList()
		info.amount = amount
		info.faction = faction
		return info
	end
	return nil
end

function parseRepLoss(chatmsg)
	local faction, amount = deformat(chatmsg, FACTION_STANDING_DECREASED)
	if faction and amount then
		local info = newList()
		info.amount = amount
		info.faction = faction
		return info
	end
	return nil
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Reputation"],
	name = "Reputation gains",
	localName = L["Reputation gains"],
	defaultTag = "+[Amount] " .. REPUTATION .. " ([Faction])",
	blizzardEvents = {
		CHAT_MSG_COMBAT_FACTION_CHANGE = { parse = parseRepGain, },
	},
	tagTranslations = {
		Amount = "amount",
		Faction = "faction",
	},
	tagTranslationHelp = {
		Amount = L["The amount of reputation gained."],
		Faction = L["The name of the faction."],
	},
	color = "7f7fb2", -- blue-gray
	throttle = repGainsThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Reputation"],
	name = "Reputation losses",
	localName = L["Reputation losses"],
	defaultTag = "-[Amount] " .. REPUTATION .. " ([Faction])",
	blizzardEvents = {
		CHAT_MSG_COMBAT_FACTION_CHANGE = { parse = parseRepLoss, },
	},
	tagTranslations = {
		Amount = function(info) return info.amount end,
		Faction = "faction",
	},
	tagTranslationHelp = {
		Amount = L["The amount of reputation lost."],
		Faction = L["The name of the faction."],
	},
	color = "7f7fb2", -- blue-gray
}

-- Skill gains
local function parseSkillGain(chatmsg)
	local skill, amount = deformat(chatmsg, SKILL_RANK_UP)
	if skill and amount then
		local info = newList()
		info.abilityName = skill
		info.amount = amount
		return info
	end
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	name = "Skill gains",
	localName = L["Skill gains"],
	defaultTag = "[Skillname]: [Amount]",
	blizzardEvents = {
		CHAT_MSG_SKILL = { parse = parseSkillGain, },
	},
	tagTranslations = {
		Skillname = retrieveAbilityName,
		Amount = "amount",
	},
	tagTranslationHelp = {
		Skill = L["The skill which experienced a gain."],
		Amount = L["The amount of skill points currently."]
	},
	color = "5555ff", -- semi-light blue
}

-- XP gains
local currentXP = 0
table.insert(onEnableFuncs, function() currentXP = UnitXP("player") end)

local function parseXPUpdate()
	local newXP = UnitXP("player")
	local info = newDict(
		"amount", newXP - currentXP
	)
	currentXP = newXP
	return info
end

Parrot:RegisterCombatEvent{
	category = "Notification",
	name = "Experience gains",
	localName = L["Experience gains"],
	defaultTag = "[Amount] " .. XP,
	tagTranslations = {
		-- Name = retrieveSourceName, -- not supported anymore by the event
		Amount = "amount",
	},
	tagTranslationHelp = {
		-- Name = L["The name of the enemy slain."], not supported anymore by the event
		Amount = L["The amount of experience points gained."]
	},
	color = "bf4ccc", -- magenta
	sticky = true,
	defaultDisabled = true,
	blizzardEvents = {
		PLAYER_XP_UPDATE = { parse = parseXPUpdate, },
	},
}

--[[============================================================================
-- Notification Events:
-- Killing blows
--============================================================================]]

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Killing blows"],
	name = "Player killing blows",
	localName = L["Player killing blows"],
	defaultTag = L["Killing Blow!"] .. " ([Name])",
	combatLogEvents = {
		PARTY_KILL = { check = checkKillPvP, },
	},
	tagTranslations = {
		Name = retrieveDestName,
		Skill = function(info) return info.abilityName or PLAYERSTAT_MELEE_COMBAT end,
	},
	tagTranslationHelp = {
		Name = L["The name of the enemy slain."],
		Skill = L["The spell or ability used to slay the enemy."],
	},
	color = "5555ff", -- semi-light blue
	sticky = true,
	throttle = killingBlowThrottle,
}

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Killing blows"],
	name = "NPC killing blows",
	localName = L["NPC killing blows"],
	defaultTag = L["Killing Blow!"] .. " ([Name])",
	combatLogEvents = {
		PARTY_KILL = { check = checkKillNPC, },
	},
	tagTranslations = {
		Name = retrieveDestName,
		Skill = function(info) return info.abilityName or PLAYERSTAT_MELEE_COMBAT end,
	},
	tagTranslationHelp = {
		Name = L["The name of the enemy slain."],
		Skill = L["The spell or ability used to slay the enemy."],
	},
	color = "5555ff", -- semi-light blue
	sticky = true,
	throttle = killingBlowThrottle,
}

--[[============================================================================
-- Notification Events:
-- Extra attacks
--============================================================================]]
Parrot:RegisterCombatEvent{
	category = "Notification",
	name = "Extra attacks",
	localName = L["Extra attacks"],
	defaultTag = L["%s!"]:format("[Skill]"),
	combatLogEvents = {
		SPELL_EXTRA_ATTACKS = { check = checkPlayerOut, },
	},
	tagTranslations = {
		Skill = retrieveAbilityName,
		Icon = retrieveIconFromAbilityName,
	},
	tagTranslationHelp = {
		Skill = L["The name of the spell or ability which provided the extra attacks."],
	},
	color = "ffff00", -- yellow
	sticky = true,
}


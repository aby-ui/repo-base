local major = "DRData-1.0"
local minor = 1048
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)
if( not Data ) then return end

--local wow_700 = select(4, GetBuildInfo()) >= 70000

local L = {
	-- WoD
	["Roots"]              = "Roots",
	["Stuns"]              = "Stuns",
	["Silences"]           = "Silences",
	["Taunts"]             = "Taunts",
	["Knockbacks"]         = "Knockbacks",
	["Incapacitates"]      = "Incapacitates",
	["Disorients"]         = "Disorients",
}

local locale = GetLocale()
if locale == "deDE" then
	L["Cyclone"] = "Wirbelsturm" -- Needs review
	L["Disarms"] = "Entwaffnungseffekte" -- Needs review
	L["Fears"] = "Furchteffekte" -- Needs review
	L["Horrors"] = "Horroreffekte" -- Needs review
	L["Knockbacks"] = "Rückstoßeffekte" -- Needs review
	L["Mesmerizes"] = "Mesmerisiereneffekte" -- Needs review
	L["Mesmerizes (short)"] = "Mesmerisiereneffekte (kurz)" -- Needs review
	L["Mind Control"] = "Gedankenkontrolle" -- Needs review
	L["Roots"] = "Bewegungsunfähigkeitseffekte" -- Needs review
	L["Roots (short)"] = "Bewegungsunfähigkeitseffekte (kurz)" -- Needs review
	L["Silences"] = "Stilleeffekte" -- Needs review
	L["Stuns"] = "Betäubungseffekte" -- Needs review
	L["Stuns (short)"] = "Betäubungseffekte (kurz)" -- Needs review
	L["Taunts"] = "Spotteffekte" -- Needs review
elseif locale == "esES" then
	L["Cyclone"] = "Ciclón"
	L["Disarms"] = "Desarmes"
	L["Fears"] = "Miedos"
	L["Horrors"] = "Horrores"
	L["Knockbacks"] = "Derribos"
	L["Mesmerizes"] = "Hipnotizaciones"
	L["Mesmerizes (short)"] = "Hipnotizaciones (cortas)"
	L["Mind Control"] = "Control Mental"
	L["Roots"] = "Raíces"
	L["Roots (short)"] = "Raíces (cortas)"
	L["Silences"] = "SIlencios"
	L["Stuns"] = "Aturdimientos"
	L["Stuns (short)"] = "Aturdimientos (cortos)"
	L["Taunts"] = "Provocaciones"
elseif locale == "esMX" then
	L["Cyclone"] = "Ciclón"
	L["Disarms"] = "Desarmes"
	L["Fears"] = "Miedos"
	L["Horrors"] = "Horrores"
	L["Knockbacks"] = "Derribos"
	L["Mesmerizes"] = "Hipnotizaciones"
	L["Mesmerizes (short)"] = "Hipnotizaciones (cortas)"
	L["Mind Control"] = "Control Mental"
	L["Roots"] = "Raíces"
	L["Roots (short)"] = "Raíces (cortas)"
	L["Silences"] = "SIlencios"
	L["Stuns"] = "Aturdimientos"
	L["Stuns (short)"] = "Aturdimientos (cortos)"
	L["Taunts"] = "Provocaciones"
elseif locale == "frFR" then
	L["Cyclone"] = "Cyclone"
	L["Disarms"] = "Désarmements"
	L["Fears"] = "Peurs"
	L["Horrors"] = "Horreurs"
	L["Knockbacks"] = "Projections"
	L["Mesmerizes"] = "Désorientations"
	L["Mesmerizes (short)"] = "Désorientations (courtes)"
	L["Mind Control"] = "Contrôle mental"
	L["Roots"] = "Immobilisations"
	L["Roots (short)"] = "Immobilisations (courtes)"
	L["Silences"] = "Silences"
	L["Stuns"] = "Etourdissements"
	L["Stuns (short)"] = "Etourdissements (courts)"
	L["Taunts"] = "Provocations"

elseif locale == "itIT" then

elseif locale == "koKR" then

elseif locale == "ptBR" then

elseif locale == "ruRU" then

elseif locale == "zhCN" then

elseif locale == "zhTW" then
	L["Cyclone"] = "颶風術"
	L["Disarms"] = "繳械"
	L["Fears"] = "恐懼"
	L["Horrors"] = "恐慌"
	L["Knockbacks"] = "擊退"
	L["Mesmerizes"] = "迷惑"
	L["Mesmerizes (short)"] = "迷惑(短)"
	L["Mind Control"] = "心靈控制"
	L["Roots"] = "定身"
	L["Roots (short)"] = "定身(短)"
	L["Silences"] = "沉默"
	L["Stuns"] = "昏迷"
	L["Stuns (short)"] = "昏迷(短)"
	L["Taunts"] = "嘲諷"
end

-- How long before DR resets ?
Data.resetTimes = {
	-- As of 6.1, this is always 18 seconds, and no longer has a range between 15 and 20 seconds.
	default   = 18,
	-- Knockbacks are a special case
	knockback = 10,
}
Data.RESET_TIME = Data.resetTimes.default

-- Successives diminished durations
Data.diminishedDurations = {
	-- Decreases by 50%, immune at the 4th application
	default   = { 0.50, 0.25 },
	-- Decreases by 35%, immune at the 5th application
	taunt     = { 0.65, 0.42, 0.27 },
	-- Immediately immune
	knockback = {},
}

-- Spells and providers by categories
--[[ Generic format:
	category = {
		-- When the debuff and the spell that applies it are the same:
		debuffId = true
		-- When the debuff and the spell that applies it differs:
		debuffId = spellId
		-- When several spells apply the debuff:
		debuffId = {spellId1, spellId2, ...}
	}
--]]

-- See http://eu.battle.net/wow/en/forum/topic/11267997531
-- or http://blue.mmo-champion.com/topic/326364-diminishing-returns-in-warlords-of-draenor/
local spellsAndProvidersByCategory = {

	--[[ TAUNT ]]--
	taunt = {
		-- Death Knight
		[ 56222] = true, -- Dark Command
		[ 57603] = true, -- Death Grip
		-- I have also seen this spellID used for the Death Grip debuff in MoP:
		[ 51399] = true, -- Death Grip
		-- Demon Hunter
		[185245] = true, -- Torment
		-- Druid
		[  6795] = true, -- Growl
		-- Hunter
		[ 20736] = true, -- Distracting Shot
		-- Monk
		[116189] = 115546, -- Provoke
		[118635] = 115546, -- Provoke via the Black Ox Statue -- NEED TESTING
		-- Paladin
		[ 62124] = true, -- Reckoning
		-- Warlock
		[ 17735] = true, -- Suffering (Voidwalker)
		-- Warrior
		[   355] = true, -- Taunt
		-- Shaman
		[ 36213] = true, -- Angered Earth (Earth Elemental)
	},

	--[[ INCAPACITATES ]]--
	incapacitate = {
		-- Druid
		[    99] = true, -- Incapacitating Roar (talent)
		[203126] = true, -- Maim (with blood trauma pvp talent)
		-- Hunter
		[  3355] = 187650, -- Freezing Trap
		[ 19386] = true, -- Wyvern Sting
		[209790] = true, -- Freezing Arrow
		[213691] = true, -- Scatter Shot
		-- Mage
		[   118] = true, -- Polymorph
		[ 28272] = true, -- Polymorph (pig)
		[ 28271] = true, -- Polymorph (turtle)
		[ 61305] = true, -- Polymorph (black cat)
		[ 61721] = true, -- Polymorph (rabbit)
		[ 61780] = true, -- Polymorph (turkey)
		[126819] = true, -- Polymorph (procupine)
		[161353] = true, -- Polymorph (bear cub)
		[161354] = true, -- Polymorph (monkey)
		[161355] = true, -- Polymorph (penguin)
		[161372] = true, -- Polymorph (peacock)
		[ 82691] = true, -- Ring of Frost
		-- Monk
		[115078] = true, -- Paralysis
		-- Paladin
		[ 20066] = true, -- Repentance
		-- Priest
		[   605] = true, -- Dominate Mind
		[  9484] = true, -- Shackle Undead
		[ 64044] = true, -- Psychic Horror (Horror effect)
		[ 200196] = true, -- Holy Word: Chastise
		-- Rogue
		[  1776] = true, -- Gouge
		[  6770] = true, -- Sap
		-- Shaman
		[ 51514] = true, -- Hex
		[211004] = true, -- Hex (spider)
		[210873] = true, -- Hex (raptor)
		[211015] = true, -- Hex (cockroach)
		[211010] = true, -- Hex (snake)
		-- Warlock
		[   710] = true, -- Banish
		[  6789] = true, -- Mortal Coil
		-- Pandaren
		[107079] = true, -- Quaking Palm
		-- Demon Hunter
		[217832] = true, -- Imprison
		[221527] = true, -- Improve Imprison
	},

	--[[ SILENCES ]]--
	silence = {
		-- Death Knight
		[ 47476] = true, -- Strangulate
		-- Demon Hunter
		[204490] = true, -- Sigil of Silence
		-- Druid
		-- Hunter
		[202933] = true, -- Spider Sting (pvp talent)
		-- Mage
		-- Paladin
		[ 31935] = true, -- Avenger's Shield
		-- Priest
		[ 15487] = true, -- Silence
		[199683] = true, -- Last Word (SW: Death silence)
		-- Rogue
		[  1330] = true, -- Garrote
		-- Blood Elf
		[ 25046] = true, -- Arcane Torrent (Energy version)
		[ 28730] = true, -- Arcane Torrent (Priest/Mage/Lock version)
		[ 50613] = true, -- Arcane Torrent (Runic power version)
		[ 69179] = true, -- Arcane Torrent (Rage version)
		[ 80483] = true, -- Arcane Torrent (Focus version)
		[129597] = true, -- Arcane Torrent (Monk version)
		[155145] = true, -- Arcane Torrent (Paladin version)
		[202719] = true, -- Arcane Torrent (DH version)
	},

	--[[ DISORIENTS ]]--
	disorient = {
		-- Death Knight
		[207167] = true, -- Blinding Sleet (talent) -- FIXME: is this the right category?
		-- Demon Hunter
		[207685] = true, -- Sigil of Misery
		-- Druid
		[ 33786] = true, -- Cyclone
		[209753] = true, -- Cyclone (Balance)
		-- Hunter
		[186387] = true, -- Bursting Shot
		[224729] = true, -- Bursting Shot
		-- Mage
		[ 31661] = true, -- Dragon's Breath
		-- Monk
		[198909] = true, -- Song of Chi-ji -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
		[202274] = true, -- Incendiary Brew -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
		-- Paladin
		[105421] = true, -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
		-- Priest
		[  8122] = true, -- Psychic Scream
		-- Rogue
		[  2094] = true, -- Blind
		-- Warlock
		[  5782] = true, -- Fear -- probably unused
		[118699] = 5782, -- Fear -- new debuff ID since MoP
		[130616] = 5782, -- Fear (with Glyph of Fear)
		[  5484] = true, -- Howl of Terror (talent)
		[115268] = true, -- Mesmerize (Shivarra)
		[  6358] = true, -- Seduction (Succubus)
		-- Warrior
		[  5246] = true, -- Intimidating Shout (main target)
	},

	--[[ STUNS ]]--
	stun = {
		-- Death Knight
		-- Abomination's Might note: 207165 is the stun, but is never applied to players,
		-- so I haven't included it.
		[108194] = true, -- Asphyxiate (talent for unholy)
		[221562] = true, -- Asphyxiate (baseline for blood)
		[ 91800] = true, -- Gnaw (Ghoul)
		[ 91797] = true, -- Monstrous Blow (Dark Transformation Ghoul)
		[207171] = true, -- Winter is Coming (Remorseless winter stun)
		-- Demon Hunter
		[179057] = true, -- Chaos Nova
		[200166] = true, -- Metamorphosis
		[205630] = true, -- Illidan's Grasp, primary effect
		[208618] = true, -- Illidan's Grasp, secondary effect
		[211881] = true, -- Fel Eruption
		-- Druid
		[203123] = true, -- Maim
		[236025] = true, -- Maim (Honor talent)
		[236026] = true, -- Maim (Honor talent)
		[22570] = true, -- Maim (Honor talent)
		[  5211] = true, -- Mighty Bash
		[163505] = 1822, -- Rake (Stun from Prowl)
		-- Hunter
		[117526] = 109248, -- Binding Shot
		[ 24394] = 19577, -- Intimidation
		-- Mage

		-- Monk
		[120086] =   true, -- Fists of Fury (with Heavy-Handed Strikes, pvp talent)
		[232055] =   true, -- Fists of Fury (new ID in 7.1)
		[119381] =   true, -- Leg Sweep
		-- Paladin
		[   853] = true, -- Hammer of Justice
		-- Priest
		[200200] = true, -- Holy word: Chastise
		[226943] = true, -- Mind Bomb
		-- Rogue
		-- Shadowstrike note: 196958 is the stun, but it never applies to players,
		-- so I haven't included it.
		[  1833] = true, -- Cheap Shot
		[   408] = true, -- Kidney Shot
		[199804] = true, -- Between the Eyes
		-- Shaman
		[118345] = true, -- Pulverize (Primal Earth Elemental)
		[118905] = true, -- Static Charge (Capacitor Totem)
		--[204399] = true, -- Earthfury (pvp talent)
		-- Warlock
		[ 89766] = true, -- Axe Toss (Felguard)
		[ 30283] = true, -- Shadowfury
		[ 22703] = 1122, -- Summon Infernal
		-- Warrior
		[132168] = true, -- Shockwave
		[132169] = true, -- Storm Bolt
		[237744] = true, -- Warbringer
		-- Tauren
		[ 20549] = true, -- War Stomp
	},

	--[[ ROOTS ]]--
	root = {
		-- Death Knight
		[ 96294] = true, -- Chains of Ice (Chilblains Root)
		[204085] = true, -- Deathchill (pvp talent)
		-- Druid
		[   339] = true, -- Entangling Roots
		[102359] = true, -- Mass Entanglement (talent)
		[ 45334] = true, -- Immobilized (wild charge, bear form)
		-- Hunter
		[ 53148] = 61685, -- Charge (Tenacity pet)
		[162480] = true, -- Steel Trap
		[190927] = true, -- Harpoon
		[200108] = true, -- Ranger's Net
		[212638] = true, -- tracker's net
		[201158] = true, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
		-- Mage
		[   122] = true, -- Frost Nova
		[ 33395] = true, -- Freeze (Water Elemental)
		-- [157997] = true, -- Ice Nova -- since 6.1, ice nova doesn't DR with anything
		[228600] = true, -- Glacial spike (talent)
		-- Monk
		[116706] = 116095, -- Disable
		-- Priest
		-- Shaman
		[ 64695] = true, -- Earthgrab Totem
	},

	--[[ KNOCKBACK ]]--
	knockback = {
		-- Death Knight
		[108199] = true, -- Gorefiend's Grasp
		-- Druid
		[102793] = true, -- Ursol's Vortex
		[132469] = true, -- Typhoon
		-- Hunter
		-- Shaman
		[ 51490] = true, -- Thunderstorm
		-- Warlock
		[  6360] = true, -- Whiplash
		[115770] = true, -- Fellash
	},
}

-- Map deprecatedCategories to the new ones
local deprecatedCategories = {
	ctrlroot       = true,
	shortroot      = true,
	ctrlstun       = true,
	rndstun        = true,
	cyclone        = true,
	shortdisorient = true,
	fear           = true,
	horror         = true,
	mc             = true,
	disarm         = true,
}

Data.categoryNames = {
	root           = L["Roots"],
	stun           = L["Stuns"],
	disorient      = L["Disorients"],
	silence        = L["Silences"],
	taunt          = L["Taunts"],
	incapacitate   = L["Incapacitates"],
	knockback      = L["Knockbacks"],
}

Data.pveDR = {
	stun     = true,
	taunt    = true,
}

--- List of spellID -> DR category
Data.spells = {}

--- List of spellID => ProviderID
Data.providers = {}

-- Dispatch the spells in the final tables
for category, spells in pairs(spellsAndProvidersByCategory) do

	for spell, provider in pairs(spells) do
		Data.spells[spell] = category
		if provider == true then -- "== true" is really needed
			Data.providers[spell] = spell
			spells[spell] = spell
		else
			Data.providers[spell] = provider
		end
	end
end

-- Warn about deprecated categories
local function CheckDeprecatedCategory(cat)
	if cat and deprecatedCategories[cat] then
		geterrorhandler()(format("Diminishing return category '%s' does not exist anymore. The addon using DRData-1.0 may be outdated. Please consider upgrading it.", cat))
		deprecatedCategories[cat] = nil -- Warn once
	end
end

-- Public APIs
-- Category name in something usable
function Data:GetCategoryName(cat)
	CheckDeprecatedCategory(cat)
	return cat and Data.categoryNames[cat] or nil
end

-- Spell list
function Data:GetSpells()
	return Data.spells
end

-- Provider list
function Data:GetProviders()
	return Data.providers
end

-- Seconds before DR resets
function Data:GetResetTime(category)
	CheckDeprecatedCategory(cat)
	return Data.resetTimes[category or "default"] or Data.resetTimes.default
end

-- Get the category of the spellID
function Data:GetSpellCategory(spellID)
	return spellID and Data.spells[spellID] or nil
end

-- Does this category DR in PvE?
function Data:IsPVE(cat)
	CheckDeprecatedCategory(cat)
	return cat and Data.pveDR[cat] or nil
end

-- List of categories
function Data:GetCategories()
	return Data.categoryNames
end

-- Next DR
function Data:NextDR(diminished, category)
	CheckDeprecatedCategory(category)
	local durations = Data.diminishedDurations[category or "default"] or Data.diminishedDurations.default
	for i = 1, #durations do
		if diminished > durations[i] then
			return durations[i]
		end
	end
	return 0
end

-- Iterate through the spells of a given category.
-- Pass "nil" to iterate through all spells.
do
	local function categoryIterator(id, category)
		local newCat
		repeat
			id, newCat = next(Data.spells, id)
			if id and newCat == category then
				return id, category
			end
		until not id
	end

	function Data:IterateSpells(category)
		if category then
			CheckDeprecatedCategory(category)
			return categoryIterator, category
		else
			return next, Data.spells
		end
	end
end

-- Iterate through the spells and providers of a given category.
-- Pass "nil" to iterate through all spells.
function Data:IterateProviders(category)
	if category then
		CheckDeprecatedCategory(category)
		return next, spellsAndProvidersByCategory[category] or {}
	else
		return next, Data.providers
	end
end

--[[ EXAMPLES ]]--
-- This is how you would track DR easily, you're welcome to do whatever you want with the below functions

--[[
local trackedPlayers = {}
local function debuffGained(spellID, destName, destGUID, isEnemy, isPlayer)
	-- Not a player, and this category isn't diminished in PVE, as well as make sure we want to track NPCs
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	-- See if we should reset it back to undiminished
	local tracked = trackedPlayers[destGUID][drCat]
	if( tracked and tracked.reset <= GetTime() ) then
		tracked.diminished = 1.0
	end
end

local function debuffFaded(spellID, destName, destGUID, isEnemy, isPlayer)
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	if( not trackedPlayers[destGUID][drCat] ) then
		trackedPlayers[destGUID][drCat] = { reset = 0, diminished = 1.0 }
	end

	local time = GetTime()
	local tracked = trackedPlayers[destGUID][drCat]

	tracked.reset = time + DRData:GetResetTime(drCat)
	tracked.diminished = DRData:NextDR(tracked.diminished, drCat)

	-- Diminishing returns changed, now you can do an update
end

local function resetDR(destGUID)
	-- Reset the tracked DRs for this person
	if( trackedPlayers[destGUID] ) then
		for cat in pairs(trackedPlayers[destGUID]) do
			trackedPlayers[destGUID][cat].reset = 0
			trackedPlayers[destGUID][cat].diminished = 1.0
		end
	end
end

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER

local eventRegistered = {["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true, ["PARTY_KILL"] = true, ["UNIT_DIED"] = true}
local function COMBAT_LOG_EVENT_UNFILTERED(self, event, timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, auraType)
	if( not eventRegistered[eventType] ) then
		return
	end

	-- Enemy gained a debuff
	if( eventType == "SPELL_AURA_APPLIED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffGained(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
	elseif( eventType == "SPELL_AURA_REFRESH" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			local isHostile = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
			debuffFaded(spellID, destName, destGUID, isHostile, isPlayer)
			debuffGained(spellID, destName, destGUID, isHostile, isPlayer)
		end

	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffFaded(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
	elseif( ( eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena" ) or eventType == "PARTY_KILL" ) then
		resetDR(destGUID)
	end
end]]

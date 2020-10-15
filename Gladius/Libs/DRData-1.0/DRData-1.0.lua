local major = "DRData-1.0"
local minor = 1048
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)
if( not Data ) then return end

local L = {
	-- WoD
	["Roots"] = "Roots",
	["Stuns"] = "Stuns",
	["Silences"] = "Silences",
	["Taunts"] = "Taunts",
	["Knockbacks"] = "Knockbacks",
	["Incapacitates"] = "Incapacitates",
	["Disorients"] = "Disorients",
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
	default = 18,
	-- Knockbacks are a special case
	knockback = 10,
}
Data.RESET_TIME = Data.resetTimes.default

-- Successives diminished durations
Data.diminishedDurations = {
	-- Decreases by 50%, immune at the 4th application
	default = { 0.50, 0.25 },
	-- Decreases by 35%, immune at the 5th application
	taunt = { 0.65, 0.42, 0.27 },
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
		-- Demon Hunter
		[185245] = true, -- Torment
		-- Druid
		[  6795] = true, -- Growl
		-- Hunter
		[  2649] = true, -- Growl (Hunter Pet)
		[ 20736] = true, -- Distracting Shot
		-- Monk
		[116189] = 115546, -- Provoke
		[118635] = 115546, -- Provoke (Black Ox Statue)
		[196727] = 115546, -- Provoke (Niuzao)
		-- Paladin
		[ 62124] = true, -- Hand of Reckoning
		[204079] = true, -- Final Stand
		-- Warlock
		[ 17735] = true, -- Suffering (Voidwalker)
		-- Warrior
		[   355] = true, -- Taunt
		-- Shaman
		[ 36213] = true, -- Angered Earth (Earth Elemental)
	},

	--[[ INCAPACITATES ]]--
	incapacitate = {
		-- Demon Hunter
		[217832] = true, -- Imprison
		[221527] = true, -- Imprison (Honor Talent)
		-- Druid
		[    99] = true, -- Incapacitating Roar
		[  2637] = true, -- Hibernate
		[236025] = true, -- Maim incap
		-- Hunter
		[  3355] = 187650, -- Freezing Trap
		[203337] = 187650, -- Freezing Trap (Honor Talent)
		[209790] = true, -- Freezing Arrow
		[213691] = true, -- Scatter Shot
		-- Mage
		[   118] = true, -- Polymorph
		[ 28271] = true, -- Polymorph (Turtle)
		[ 28272] = true, -- Polymorph (Pig)
		[ 61305] = true, -- Polymorph (Black Cat)
		[ 61721] = true, -- Polymorph (Rabbit)
		[ 61780] = true, -- Polymorph (Turkey)
		[126819] = true, -- Polymorph (Procupine)
		[161353] = true, -- Polymorph (Polar Bear Cub)
		[161354] = true, -- Polymorph (Monkey)
		[161355] = true, -- Polymorph (Penguin)
		[161372] = true, -- Polymorph (Peacock)
		[277787] = true, -- Polymorph (Direhorn)
		[277792] = true, -- Polymorph (Bumblebee)
		[ 82691] = 113724, -- Ring of Frost
		-- Monk
		[115078] = true, -- Paralysis
		-- Paladin
		[ 20066] = true, -- Repentance
		-- Priest
		[   9484] = true, -- Shackle Undead
		[ 200196] = 88625, -- Holy Word: Chastise
		-- Rogue
		[  1776] = true, -- Gouge
		[  6770] = true, -- Sap
		-- Shaman
		[ 51514] = true, -- Hex
		[196942] = true, -- Hex (Voodoo Totem)
		[210873] = true, -- Hex (Raptor)
		[211004] = true, -- Hex (Spider)
		[211010] = true, -- Hex (Snake)
		[211015] = true, -- Hex (Cockroach)
		[269352] = true, -- Hex (Skeletal Hatchling)
		[277784] = true, -- Hex (Wicker Mongrel)
		[277778] = true, -- Hex (Zandalari Tendonripper)
		[309328] = true, -- Hex (Living Honey)
		[197214] = true, -- Sundering
		-- Warlock
		[   710] = true, -- Banish
		[  6789] = true, -- Mortal Coil
		-- Pandaren
		[107079] = true, -- Quaking Palm (Racial)
	},

	--[[ SILENCES ]]--
	silence = {
		-- Death Knight
		[ 47476] = true, -- Strangulate
		-- Demon Hunter
		[204490] = 202137, -- Sigil of Silence
		-- Druid
		--[81261] = true, -- Solar Beam (No DR)
		-- Hunter
		[202933] = 202914, -- Spider Sting
		-- Paladin
		[ 31935] = true, -- Avenger's Shield
		[217824] = 31935, -- Shield of Virtue
		-- Priest
		[ 15487] = true, -- Silence
		[199683] = true, -- Last Word
		-- Rogue
		[  1330] = 703, -- Garrote
		-- Warlock
		[196364] = true, -- Unstable Affliction
	},

	--[[ DISORIENTS ]]--
	disorient = {
		-- Death Knight
		[207167] = true, -- Blinding Sleet
		-- Demon Hunter
		[207685] = 207684, -- Sigil of Misery
		-- Druid
		[ 33786] = true, -- Cyclone
		[209753] = true, -- Cyclone (Balance Honor Talent)
		-- Mage
		[ 31661] = true, -- Dragon's Breath
		-- Monk
		[198909] = 198898, -- Song of Chi-ji
		[202274] = 115181, -- Incendiary Brew
		-- Paladin
		[105421] = 115750, -- Blinding Light
		-- Priest
		[   605] = true, -- Dominate Mind
		[  8122] = true, -- Psychic Scream
		[226943] = 205369, -- Mind Bomb
		-- Rogue
		[  2094] = true, -- Blind
		-- Warlock
		[  6358] = true, -- Seduction (Succubus)
		[118699] = 5782, -- Fear
		[261589] = 261589, -- Seduction (Grimoire of Sacrifice)
		-- Warrior
		[  5246] = true, -- Intimidating Shout
	},

	--[[ STUNS ]]--
	stun = {
		-- Death Knight
		[ 91797] = 47481, -- Monstrous Blow (Mutated Ghoul)
		[ 91800] = 47481, -- Gnaw (Ghoul)
		[108194] = true, -- Asphyxiate (Unholy/Frost)
		[221562] = true, -- Asphyxiate (Blood)
		[210141] = 210128, -- Zombie Explosion
		[287254] = 196770, -- Dead of Winter
		-- Demon Hunter
		[179057] = true, -- Chaos Nova
		[205630] = true, -- Illidan's Grasp (Primary effect)
		[208618] = true, -- Illidan's Grasp (Secondary effect)
		[211881] = true, -- Fel Eruption
		-- Druid
		[  5211] = true, -- Mighty Bash
		[203123] = true, -- Maim
		[163505] = 1822, -- Rake (Prowl)
		[202244] = 202246, -- Overrun
		-- Hunter
		[ 24394] = 19577, -- Intimidation
		-- Monk
		[119381] = true, -- Leg Sweep
		[202346] = 121253, -- Double Barrel
		-- Paladin
		[   853] = true, -- Hammer of Justice
		-- Priest
		[ 64044] = true, -- Psychic Horror
		[200200] = 88625, -- Holy word: Chastise Censure
		-- Rogue
		[   408] = true, -- Kidney Shot
		[  1833] = true, -- Cheap Shot
		[199804] = true, -- Between the Eyes
		-- Shaman
		[118345] = true, -- Pulverize (Primal Earth Elemental)
		[118905] = 192058, -- Static Charge (Capacitor Totem)
		[305485] = true, -- Lightning Lasso
		-- Warlock
		[ 30283] = true, -- Shadowfury
		[ 89766] = true, -- Axe Toss (Felguard)
		[171017] = true, -- Meteor Strike (Infernal)
        [171018] = true, -- Meteor Strike (Abyssal)
		-- Warrior
		[46968] = true, -- Shockwave
		[132168] = 46968, -- Shockwave (Protection)
		[132169] = 107570, -- Storm Bolt
		[199085] = 6544, -- Warpath
		-- Tauren
		[ 20549] = true, -- War Stomp
		[255723] = true, -- Bull Rush
		-- Kul Tiran
		[287712] = true, -- Haymaker
	},

	--[[ ROOTS ]]--
	root = {
		-- Death Knight
		[204085] = 45524, -- Deathchill (Chains of Ice)
		[233395] = 196770, -- Deathchill (Remorseless Winter)
		-- Druid
		[   339] = true, -- Entangling Roots
		[170855] = 102342, -- Entangling Roots (Nature's Grasp)
		[102359] = true, -- Mass Entanglement
		[ 45334] = 16979, -- Immobilized (wild charge, bear form)
		-- Hunter
		[ 53148] = 61685, -- Charge (Tenacity Pet)
		[162480] = 162488, -- Steel Trap
		[117526] = 109248, -- Binding Shot
		[190927] = 190925, -- Harpoon
		[201158] = true, -- Super Sticky Tar
		[200108] = true, -- Ranger's Net
		[212638] = true, -- Tracker's Net
		-- Mage
		[   122] = true, -- Frost Nova
		[ 33395] = true, -- Freeze (Water Elemental)
		[198121] = true, -- Frostbite
		[220107] = true, -- Frostbite (Water Elemental)
		[228600] = 199786, -- Glacial Spike
		-- Monk
		[116706] = 116095, -- Disable
		-- Priest
		-- Warlock
		[233582] = 17962, -- Entrenched in Flame
		-- Shaman
		[ 64695] = 51485, -- Earthgrab Totem
	},

	--[[ KNOCKBACK ]]--
	knockback = {
		-- Death Knight
		[108199] = true, -- Gorefiend's Grasp
		-- Druid
		[102793] = true, -- Ursol's Vortex
		[132469] = true, -- Typhoon
		-- Hunter
		[186387] = true, -- Bursting Shot
		[224729] = true, -- Bursting Shot
		[238559] = true, -- Bursting Shot
		[236775] = true, -- Hi-Explosive Trap
		-- Mage
		[157981] = true, -- Blast Wave
		-- Priest
		[204263] = true, -- Shining Force
		-- Shaman
		[ 51490] = true, -- Thunderstorm
		-- Warlock
		[  6360] = true, -- Whiplash
		[115770] = true, -- Fellash
	},

	--[[ DISARM ]]--
	disarm = {
		[207777] = true, -- Dismantle
		[209749] = true, -- Faerie Swarm (Balance Honor Talent)
		[233759] = true, -- Grapple Weapon
		[236077] = true, -- Disarm
	},
}

-- Map deprecatedCategories to the new ones
local deprecatedCategories = {
	ctrlroot = true,
	shortroot = true,
	ctrlstun = true,
	rndstun = true,
	cyclone = true,
	shortdisorient = true,
	fear = true,
	horror = true,
	mc = true,
	--disarm = true,
}

Data.categoryNames = {
	root = L["Roots"],
	stun = L["Stuns"],
	disorient = L["Disorients"],
	silence = L["Silences"],
	taunt = L["Taunts"],
	incapacitate = L["Incapacitates"],
	knockback = L["Knockbacks"],
	disarm = L["Disarms"],
}

Data.pveDR = {
	stun = true,
	taunt = true,
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

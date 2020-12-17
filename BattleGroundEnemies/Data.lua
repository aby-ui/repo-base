local addonName, Data = ...

local L = LibStub("AceLocale-3.0"):GetLocale("BattleGroundEnemies")
local DRList = LibStub("DRList-1.0")

local GetClassInfo = GetClassInfo
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture

Data.CyrillicToRomanian = { -- source Wikipedia: https://en.wikipedia.org/wiki/Romanization_of_Russian
	["А"] = "a",
	["а"] = "a",
	["Б"] = "b",
	["б"] = "b",
	["В"] = "v",
	["в"] = "v",
	["Г"] = "g",
	["г"] = "g",
	["Д"] = "d",
	["д"] = "d",
	["Е"] = "e",
	["е"] = "e",
	["Ё"] = "e",
	["ё"] = "e",
	["Ж"] = "zh",
	["ж"] = "zh",
	["З"] = "z",
	["з"] = "z",
	["И"] = "i",
	["и"] = "i",
	["Й"] = "i",
	["й"] = "i",
	["К"] = "k",
	["к"] = "k",
	["Л"] = "l",
	["л"] = "l",
	["М"] = "m",
	["м"] = "m",
	["Н"] = "n",
	["н"] = "n",
	["О"] = "o",
	["о"] = "o",
	["П"] = "p",
	["п"] = "p",
	["Р"] = "r",
	["р"] = "r",
	["С"] = "s",
	["с"] = "s",
	["Т"] = "t",
	["т"] = "t",
	["У"] = "u",
	["у"] = "u",
	["Ф"] = "f",
	["ф"] = "f",
	["Х"] = "kh",
	["х"] = "kh",
	["Ц"] = "ts",
	["ц"] = "ts",
	["Ч"] = "ch",
	["ч"] = "ch",
	["Ш"] = "sh",
	["ш"] = "sh",
	["Щ"] = "shch",
	["щ"] = "shch",
	["Ъ"] = "ie",
	["ъ"] = "ie",
	["Ы"] = "y",
	["ы"] = "y",
	["Ь"] = "",
	["ь"] = "",
	["Э"] = "e",
	["э"] = "e",
	["Ю"] = "iu",
	["ю"] = "iu",
	["Я"] = "ia",
	["я"] = "ia"   
}

Data.FontOutlines = {
    [""] = L["None"],
    ["OUTLINE"] = L["Normal"],
    ["THICKOUTLINE"] = L["Thick"],
}

Data.Buttons = {
    Target = TARGET,
	Focus = SET_FOCUS,
	Custom = L.UserDefined
}

Data.ObjectiveAndRespawnPosition = {
	Left = L.LEFT,
	Right = L.RIGHT,
	LeftToTargetCounter = L.LeftToTargetCounter
}

Data.DisplayType = {
	Frame = L.Frame,
	Countdowntext = L.Countdowntext,
}

Data.DrCategorys = {
	disorient = L.DR_Disorient,
	incapacitate = L.DR_Incapacitate,
	knockback = L.DR_Knockback,
	root = L.DR_Root,
	silence  = L.DR_Silence,
	stun = L.DR_Stun
}

Data.DebuffTypes = {
	Magic = L.Magic,
	Disease = L.Disease,
	Poison = L.Poison,
	Curse = L.Curse
}
Data.RandomDebuffType =  {} -- for testmode

do
	local i = 1
	for engName, color in pairs(DebuffTypeColor) do
		Data.RandomDebuffType[i] = engName
		i = i + 1
	end
end


Data.Frames = {
	ObjectiveAndRespawn = L.ObjectiveAndRespawnSettings,
	Racial = L.RacialSettings,
	Trinket = L.TrinketSettings,
	Power = L.HealthBarSettings.." "..L.AND.." "..L.PowerBarSettings,
	Spec = L.SpecSettings,
	BuffContainer = L.BuffContainer,
	DebuffContainer = L.DebuffContainer,
	DRContainer = L.DRContainer,
	NumericTargetindicator = L.NumericTargetindicator,
	Button = L.Button
}

Data.RangeFrames = {
	ObjectiveAndRespawn = L.ObjectiveAndRespawnSettings,
	Racial = L.RacialSettings,
	Trinket = L.TrinketSettings,
	Power = L.HealthBarSettings.." "..L.AND.." "..L.PowerBarSettings,
	Spec = L.SpecSettings,
	BuffContainer = L.BuffContainer,
	DebuffContainer = L.DebuffContainer,
	DRContainer = L.DRContainer,
}

Data.AllPositions = {
	TOPLEFT = L.TOPLEFT,
	TOP = L.TOP,
	TOPRIGHT = L.TOPRIGHT,
	LEFT = L.LEFT,
	CENTER = L.CENTER,
	RIGHT = L.RIGHT,
	BOTTOMLEFT = L.BOTTOMLEFT,
	BOTTOM = L.BOTTOM,
	BOTTOMRIGHT = L.BOTTOMRIGHT
}

Data.BasicPositions = {
	LEFT = L.LEFT,
	RIGHT = L.RIGHT
}

Data.HorizontalDirections = {
	leftwards = L.Leftwards, 
	rightwards = L.Rightwards
}
Data.VerticalDirections = {
	upwards = L.Upwards, 
	downwards = L.Downwards
}




Data.Interruptdurations = {
    [6552] = 4,   -- [Warrior] Pummel
    [96231] = 4,  -- [Paladin] Rebuke
    [231665] = 3, -- [Paladin] Avengers Shield
    [147362] = 3, -- [Hunter] Countershot
    [187707] = 3, -- [Hunter] Muzzle
    [1766] = 5,   -- [Rogue] Kick
    [183752] = 3, -- [DH] Consume Magic
    [47528] = 3,  -- [DK] Mind Freeze
    [91802] = 2,  -- [DK] Shambling Rush
    [57994] = 3,  -- [Shaman] Wind Shear
    [115781] = 6, -- [Warlock] Optical Blast
    [19647] = 6,  -- [Warlock] Spell Lock
    [212619] = 6, -- [Warlock] Call Felhunter
    [132409] = 6, -- [Warlock] Spell Lock
    [171138] = 6, -- [Warlock] Shadow Lock
    [2139] = 6,   -- [Mage] Counterspell
    [116705] = 4, -- [Monk] Spear Hand Strike
    [106839] = 4, -- [Feral] Skull Bash
	[93985] = 4,  -- [Feral] Skull Bash
}

-- for spellID, lockoutDuration in pairs(Data.Interruptdurations) do
	-- Data.SpellPriorities[spellID] = 4
-- end


-- pvp talents that reduce lockouts by 70%
Data.PvPTalentsReducingInterruptTime = { 
	[GetSpellInfo(221404)] = 0.7, --  [Mage] Burning Determination, 70% reduction
	[GetSpellInfo(221677)] = 0.5, --  [Shaman] Calming Waters, 50% reduction
	[GetSpellInfo(221660)] = 0.7, --  [Priest] Holy Concentration, 70% reduction
}

Data.RandomDrCategory = {} --key = number, value = categorieName, used for Testmode
Data.DrCategoryToSpell = {} --key = categorieName, value = table with key = number and value = spellID
Data.SpellPriorities = {}

local i = 1
for categorieName, localizedCategoryName in pairs(DRList:GetCategories()) do
	Data.RandomDrCategory[i] = categorieName
	Data.DrCategoryToSpell[categorieName] = {}
	i = i + 1
end

do
	local drCategoryToPriority = {
		stun = 8,
		disorient = 7,
		incapacitate = 6,
		silence = 5,
		root = 3,
		knockback = 2,
		taunt = 1
	}


	for spellID, categorieName in pairs(DRList.spells) do
		tinsert(Data.DrCategoryToSpell[categorieName], spellID)
		Data.SpellPriorities[spellID] = drCategoryToPriority[categorieName]
	end
end

		
Data.cCduration = {	-- this is basically data from DRList-1 with durations, used for Relentless check
	--[[ INCAPACITATES ]]--
	incapacitate = {
		-- Druid
		[    99] = 3, -- Incapacitating Roar (talent)
		[236025] = 6, -- Main (Honor talent)
		[236026] = 6, -- Main (Honor talent)
		-- Hunter
		[213691] = 4, -- Scatter Shot
		-- Mage
		[   118] = 8, -- Polymorph
		[ 28272] = 8, -- Polymorph (pig)
		[ 28271] = 8, -- Polymorph (turtle)
		[ 61305] = 8, -- Polymorph (black cat)
		[277792] = 8, -- Polymorph (Bumblebee)
		[277787] = 8, -- Polymorph (Direhorn)
		[ 61721] = 8, -- Polymorph (rabbit)
		[ 61780] = 8, -- Polymorph (turkey)
		[126819] = 8, -- Polymorph (procupine)
		[161353] = 8, -- Polymorph (bear cub)
		[161354] = 8, -- Polymorph (monkey)
		[321395] = 8, -- Polymorph (Mawrat)
		[161355] = 8, -- Polymorph (penguin)
		[161372] = 8, -- Polymorph (peacock)
		[126819] = 8, -- Polymorph (Porcupine)
		[ 82691] = 8, -- Ring of Frost
		-- Monk
		[115078] = 4, -- Paralysis
		-- Paladin
		[ 20066] = 8, -- Repentance
		-- Priest
		[ 64044] = 4, -- Psychic Horror (Horror effect)
		-- Rogue
		[  1776] = 4, -- Gouge
		[  6770] = 8, -- Sap
		-- Shaman
		[ 51514] = 8, -- Hex
		[211004] = 8, -- Hex (spider)
		[210873] = 8, -- Hex (raptor)
		[211015] = 8, -- Hex (cockroach)
		[211010] = 8, -- Hex (snake)
		-- Warlock
		[  6789] = 3, -- Mortal Coil
		-- Pandaren
		[107079] = 4 -- Quaking Palm
	},

	--[[ SILENCES ]]--
	silence = {
		-- Death Knight
		[ 47476] = 5, -- Strangulate
		-- Hunter
		[202933] = 4, -- Spider Sting (pvp talent)
		-- Mage
		-- Paladin
		[ 31935] = 3, -- Avenger's Shield
		-- Priest
		[ 15487] = 4, -- Silence
		-- Rogue
		[  1330] = 3, -- Garrote
		-- Blood Elf
		[ 25046] = 2, -- Arcane Torrent (Energy version)
		[ 28730] = 2, -- Arcane Torrent (Priest/Mage/Lock version)
		[ 50613] = 2, -- Arcane Torrent (Runic power version)
		[ 69179] = 2, -- Arcane Torrent (Rage version)
		[ 80483] = 2, -- Arcane Torrent (Focus version)
		[129597] = 2, -- Arcane Torrent (Monk version)
		[155145] = 2, -- Arcane Torrent (Paladin version)
		[202719] = 2  -- Arcane Torrent (DH version)
	},

	--[[ DISORIENTS ]]--
	disorient = {
		-- Druid
		[ 33786] = 6, -- Cyclone
		-- Mage
		[ 31661] = 3, -- Dragon's Breath
		-- Paladin
		[105421] = 6, -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
		-- Priest
		[  8122] = 6, -- Psychic Scream
		-- Rogue
		[  2094] = 8, -- Blind
		-- Warlock
		[  5782] = 6, -- Fear -- probably unused
		[118699] = 6, -- Fear -- new debuff ID since MoP
		-- Warrior
		[  5246] = 5 -- Intimidating Shout (main target)
	},

	--[[ STUNS ]]--
	stun = {
		-- Death Knight
		[108194] = 4, -- Asphyxiate (talent for unholy)
		[221562] = 5, -- Asphyxiate (baseline for blood)
		[207171] = 4, -- Winter is Coming (Remorseless winter stun)
		-- Demon Hunter
		[179057] = 2, -- Chaos Nova
		[200166] = 3, -- Metamorphosis
		[205630] = 3, -- Illidan's Grasp, primary effect
		[211881] = 4, -- Fel Eruption
		-- Druid
		[  5211] = 4, -- Mighty Bash
		[163505] = 4, -- Rake (Stun from Prowl)
		-- Monk
		[120086] = 4, -- Fists of Fury (with Heavy-Handed Strikes, pvp talent)
		[232055] = 3, -- Fists of Fury (new ID in 7.1)
		[119381] = 3, -- Leg Sweep
		-- Paladin
		[   853] = 6, -- Hammer of Justice
		-- Priest
		[200200] = 4, -- Holy word: Chastise
		[226943] = 6, -- Mind Bomb
		-- Rogue
		[  1833] = 4, -- Cheap Shot
	--	[   408] = true, -- Kidney Shot, variable duration
	  --[199804] = true, -- Between the Eyes, variable duration
		-- Shaman
		[118345] = 4, -- Pulverize (Primal Earth Elemental)
		[118905] = 5, -- Static Charge (Capacitor Totem)
		[204399] = 2, -- Earthfury (pvp talent)
		-- Warlock
		[ 89766] = 4, -- Axe Toss (Felguard)
		[ 30283] = 3, -- Shadowfury
		-- Warrior
		[132168] = 2, -- Shockwave
		[132169] = 4, -- Storm Bolt
		-- Tauren
		[ 20549] = 2 -- War Stomp
	},

	--[[ ROOTS ]]--
	root = {
		-- Death Knight
		[ 96294] = 4, -- Chains of Ice (Chilblains Root)
		[204085] = 4, -- Deathchill (pvp talent)
		-- Druid
		[   339] = 8, -- Entangling Roots
		[102359] = 8, -- Mass Entanglement (talent)
		[ 45334] = 4, -- Immobilized (wild charge, bear form)
		-- Hunter
		[200108] = 3, -- Ranger's Net
		[212638] = 6, -- tracker's net
		[201158] = 4, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
		-- Mage
		[   122] = 8, -- Frost Nova
		[ 33395] = 8, -- Freeze (Water Elemental)
		[228600] = 4, -- Glacial spike (talent)
		-- Shaman
		[ 64695] = 8 -- Earthgrab Totem
	}
}

Data.cCdurationBySpellID = {}
for category, spellIDs in pairs(Data.cCduration) do
	for spellID, duration in pairs(spellIDs) do
		Data.cCdurationBySpellID[spellID] = duration
	end
end	
		

Data.BattlegroundspezificBuffs = { --key = mapID, value = table with key = faction(0 for hode, 1 for alliance) value spellID of the flag, minecart
	[1339] = {						-- Warsong Gulch, used to be mapID 443 before BFA
		[0] = 156621, 					-- Alliance Flag
		[1] = 156618 					-- Horde Flag	
	}, 
	[112] = {						-- Eye of the Storm, used to be mapID 482 before BFA
		[0] = 34976,  					-- Netherstorm Flag
		[1] = 34976						-- Netherstorm Flag
	},	
	[397] = {						-- Eye of the Storm (mapID RBG only? Not sure why there are two map IDs for Eye of the Storm), used to be mapID 813 before BFA
		[0] = 34976,  					-- Netherstorm Flag
		[1] = 34976						-- Netherstorm Flag
	},
	[206] = {						-- Twin Peaks, used to be mapID 626 before BFA
		[0] = 156621, 					-- Alliance Flag
		[1] = 156618 					-- Horde Flag
	}
}

		
Data.BattlegroundspezificDebuffs = { --key = mapID, value = table with key = number and value = debuff name
	[1339] = {						-- Warsong Gulch, used to be mapID 443 before BFA
		46392,						-- Focused Assault
		46393						-- Brutal Assault								
	},
	[112] = {						-- Eye of the Storm, used to be mapID 482 before BFA
		46392,						-- Focused Assault
		46393						-- Brutal Assault							
	},
	[397] = {						-- Eye of the Storm (mapID RBG only? Not sure why there are two map IDs for Eye of the Storm), used to be mapID 813 before BFA 
		46392,						-- Focused Assault
		46393						-- Brutal Assault							
	},
	[206] = {						-- Twin Peaks, used to be mapID 626 before BFA 
		46392,						-- Focused Assault
		46393						-- Brutal Assault					
	},	
	[417] = {						-- Temple of Kotmogu, used to be mapID 856 before BFA
		121164, 					-- Orb of Power, Blue
		121175, 					-- Orb of Power, Purple
		121177, 					-- Orb of Power, Orange
		121176 						-- Orb of Power, Green
	} 
}
		
		

Data.TriggerSpellIDToTrinketnumber = {--key = which first row honor talent, value = fileID(used for SetTexture())
	[195710] = 1, 	-- 1: Honorable Medallion, 3. min. CD, detected by Combatlog
	[208683] = 2, 	-- 2: Gladiator's Medallion, 2 min. CD, detected by Combatlog
	[336126] = 2,   -- 2: Gladiator's Medallion, 2 min. CD, Shadowlands Update
	[195901] = 3, 	-- 3: Adaptation, 1 min. CD, detected by Aura 195901
	[214027] = 3, 	-- 3: Adaptation, 1 min. CD, detected by Aura 195901, for the Arena_cooldownupdate
	[336135] = 3, 	-- 3: Adaptation, 1 min. CD, Shadowlands Update
	[196029] = 4, 	-- 4: Relentless, passive, no CD
	[336128] = 4 	-- 4: Relentless, passive, no CD, Shadowlands Update
}
		
	
local TrinketTriggerSpellIDtoDisplayspellID = {
	[195901] = 214027 --Adapted, should display as Adaptation
}

Data.RacialSpellIDtoCooldown = {
	 [7744] = 120,	--Will of the Forsaken, Undead Racial, 30 sec cooldown trigger on trinket
	[20594] = 120,	--Stoneform, Dwarf Racial
	[58984] = 120,	--Shadowmeld, Night Elf Racial
	[59752] = 180,  --Every Man for Himself, Human Racial, 90 sec cooldown trigger on trinket
	[28730] = 90,	--Arcane Torrent, Blood Elf Racial, Mage and Warlock, 
	[50613] = 90,	--Arcane Torrent, Blood Elf Racial, Death Knight, 
   [202719] = 90,	--Arcane Torrent, Blood Elf Racial, Demon Hunter, 
	[80483] = 90,	--Arcane Torrent, Blood Elf Racial, Hunter,
   [129597] = 90,	--Arcane Torrent, Blood Elf Racial, Monk,
   [155145] = 90,	--Arcane Torrent, Blood Elf Racial, Paladin,
   [232633] = 90,	--Arcane Torrent, Blood Elf Racial, Priest,
	[25046] = 90,	--Arcane Torrent, Blood Elf Racial, Rogue,
	[69179] = 90,	--Arcane Torrent, Blood Elf Racial, Warrior,
	[20589] = 90, 	--Escape Artist, Gnome Racial
	[26297] = 180,	--Berserkering, Troll Racial
	[33702] = 120,	--Blood Fury, Orc Racial, Mage,  Warlock
	[20572]	= 120,	--Blood Fury, Orc Racial, Warrior, Hunter, Rogue, Death Knight
	[33697] = 120,	--Blood Fury, Orc Racial, Shaman, Monk
	[20577] = 120, 	--Cannibalize, Undead Racial
	[68992]	= 120,	--Darkflight, Worgen Racial
	[59545] = 180,	--Gift of the Naaru, Draenei Racial, Death Knight
	[59543] = 180,	--Gift of the Naaru, Draenei Racial, Hunter
	[59548] = 180,	--Gift of the Naaru, Draenei Racial, Mage
   [121093]	= 180,	--Gift of the Naaru, Draenei Racial, Monk
	[59542] = 180,	--Gift of the Naaru, Draenei Racial, Paladin
	[59544] = 180,	--Gift of the Naaru, Draenei Racial, Priest
	[59547] = 180,	--Gift of the Naaru, Draenei Racial, Shaman
	[28880] = 180,	--Gift of the Naaru, Draenei Racial, Warrior
   [107079] = 120,	--Quaking Palm, Pandaren Racial
	[69041] = 90,	--Rocket Barrage, Goblin Racial
	[69070] = 90,	--Rocket Jump, Goblin Racial
	[20549] = 90	--War Stomp, Tauren Racial 
}

Data.TriggerSpellIDToDisplayFileId = {}
for triggerSpellID in pairs(Data.TriggerSpellIDToTrinketnumber) do
	if TrinketTriggerSpellIDtoDisplayspellID[triggerSpellID] then
		Data.TriggerSpellIDToDisplayFileId[triggerSpellID] = GetSpellTexture(TrinketTriggerSpellIDtoDisplayspellID[triggerSpellID])
	else
		Data.TriggerSpellIDToDisplayFileId[triggerSpellID] = GetSpellTexture(triggerSpellID)
	end
end

Data.RacialNameToSpellIDs = {}
Data.Racialnames = {}
for spellID in pairs(Data.RacialSpellIDtoCooldown) do
	Data.TriggerSpellIDToDisplayFileId[spellID] = GetSpellTexture(spellID)
	local racialName = GetSpellInfo(spellID)
	if not Data.RacialNameToSpellIDs[racialName] then
		Data.RacialNameToSpellIDs[racialName] = {}
		Data.Racialnames[GetSpellInfo(spellID)] = GetSpellInfo(spellID)
	end
	Data.RacialNameToSpellIDs[racialName][spellID] = true
end

Data.TrinketTriggerSpellIDtoCooldown = {
	[195710] = 180,	-- Honorable Medallion, 3 min. CD
	[208683] = 120,	-- Gladiator's Medallion, 2 min. CD
	[336126] = 120, -- Gladiator's Medallion, 2 min. CD, Shadowlands Update
	[195901] = 60, 	-- Adaptation PvP Talent
	[336135] = 60   -- Adapation, Shadowlands Update
}

Data.RacialSpellIDtoCooldownTrigger = {
	 [7744] = 30, 	--Will of the Forsaken, Undead Racial, 30 sec cooldown trigger on trinket
	[59752] = 90  	--Every Man for Himself, Human Racial, 30 sec cooldown trigger on trinket
}



Data.EnemiesRangeToRange = {}
Data.EnemiesItemIDToRange = {}
Data.EnemiesRangeToItemID	= {
	[5] = 37727, -- Ruby Acorn --works, also for allies,
	[6] = 63427, -- Worgsaw --works, also for allies,
	[8] = 34368, -- Attuned Crystal Cores --works, also for allies,
	[10] = 32321, -- Sparrowhawk Net
	[15] = 33069, -- Sturdy Rope --doesn't work on allies
	[20] = 10645, -- Gnomish Death Ray --doesn't work on allies
	[25] = 24268, -- Netherweave Net --doesn't work on allies
	[30] = 34191, -- Handful of Snowflakes
	[35] = 18904, -- Zorbin's Ultra-Shrinker
	[40] = 28767, -- The Decapitator --doesn't work on allies
	[45] = 32698, -- Wrangling Rope
	[50] = 116139, -- Haunting Memento
	[60] = 32825, -- Soul Cannon
	[70] = 41265, -- Eyesore Blaster
	[80] = 35278, -- Reinforced Net
	[100] = 33119, -- Malister's Frost Wand --doesn't work on allies
}
Data.AlliesRangeToRange = {}
Data.AlliesItemIDToRange = {}
Data.AlliesRangeToItemID	= {
	[5] = 37727, -- Ruby Acorn
	[6] = 63427, -- Worgsaw
	[8] = 34368, -- Attuned Crystal Cores
	[10] = 32321, -- Sparrowhawk Net
	[15] = 6450, -- Silk Bandage
	[20] = 21519, -- Mistletoe
	[25] = 31463, -- Zezzak's Shard
	[30] = 34191, -- Handful of Snowflakes
	[35] = 18904, -- Zorbin's Ultra-Shrinker
	[40] = 34471, -- Vial of the Sunwell
	[45] = 32698, -- Wrangling Rope
	[50] = 116139, -- Haunting Memento
	[60] = 32825, -- Soul Cannon
	[70] = 41265, -- Eyesore Blaster
	[80] = 35278, -- Reinforced Net
}

for range, itemID in next, Data.EnemiesRangeToItemID do
	Data.EnemiesRangeToRange[range] = range
	Data.EnemiesItemIDToRange[itemID] = range
end 

for range, itemID in next, Data.AlliesRangeToItemID do
	Data.AlliesRangeToRange[range] = range
	Data.AlliesItemIDToRange[itemID] = range
end 


Data.Classes = {}
Data.RolesToSpec = {HEALER = {}, TANK = {}, DAMAGER = {}} --for Testmode only

do
	local roleNameToRoleNumber = {
		["DAMAGER"] = 3,
		["HEALER"] = 1,
		["TANK"] = 2
	}
	local specIdToRessource = {
		--Death Knight
		[250] = "RUNIC_POWER",	--Blood
		[251] = "RUNIC_POWER",	--Frost
		[252] = "RUNIC_POWER",	--Unholy
		--Demon Hunter
		[577] = "FURY",			--Havoc
		[581] = "PAIN",			--Vengeance
		--Druid 
		[102] = "LUNAR_POWER",	--Balance
		[103] = "ENERGY",		--Feral Combat
		[104] = "RAGE",			--Guardian
		[105] = "MANA",			--Restoration
		--Hunter 
		[253] = "FOCUS",		--Beast Mastery
		[254] = "FOCUS",		--Marksmanship
		[255] = "FOCUS",		--Survival
		--Mage
		[62] = "MANA",			--Arcane
		[63] = "MANA",			--Fire
		[64] = "MANA",			--Frost
		--Monk
		[268] = "ENERGY",		--Brewmaster
		[269] = "ENERGY",		--Windwalker
		[270] = "MANA",			--Mistweaver
		--Paladin
		[65] = "MANA",			--Holy
		[66] = "MANA",			--Protection
		[70] = "MANA",			--Retribution
		--Priest
		[256] = "MANA",			--Discipline
		[257] = "MANA",			--Holy
		[258] = "INSANITY",		--Shadow
		--Rogue
		[259] = "ENERGY",		--Assassination
		[260] = "ENERGY",		--Outlaw
		[261] = "ENERGY",		--Subtlety
		--Shaman,
		[262] = "MAELSTROM",	--Elemental
		[263] = "MAELSTROM",	--Enhancement
		[264] = "MANA",			--Restoration
		--Warlock
		[265] = "MANA",			--Affliction
		[266] = "MANA",			--Demonology
		[267] = "MANA",			--Destruction
		--Warrior
		[71] = "RAGE",			--Arms
		[72] = "RAGE",			--Fury
		[73] = "RAGE"			--Protection
	}
	
	
	for classID = 1, MAX_CLASSES do --example classes[EnglishClass][SpecName].
		local _, classTag = GetClassInfo(classID)
		Data.Classes[classTag] = {}
		for i = 1, GetNumSpecializationsForClassID(classID) do
			
			local specID,maleSpecName,_,icon,role = GetSpecializationInfoForClassID(classID, i, 2) -- male version
			Data.Classes[classTag][maleSpecName] = {roleNumber = roleNameToRoleNumber[role], roleID = role, specID = specID, specIcon = icon, Ressource = specIdToRessource[specID]}
			table.insert(Data.RolesToSpec[role], {classTag = classTag, specName = maleSpecName}) --for testmode
			
			--if specName == "Танцующий с ветром" then specName = "Танцующая с ветром" end -- fix for russian bug, fix added on 2017.08.27
			local specID,specName,_,icon,role = GetSpecializationInfoForClassID(classID, i, 3) -- female version	
			if not Data.Classes[classTag][specName] then --there is a female version of that specName
				Data.Classes[classTag][specName] = Data.Classes[classTag][maleSpecName]
			end
		end
	end
end

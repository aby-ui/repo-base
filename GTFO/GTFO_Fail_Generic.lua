--------------------------------------------------------------------------
-- GTFO_Fail_Generic.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Generic
Author: Zensunim of Malygos
]]--

GTFO.SpellID["82691"] = {
	--desc = "Ring of Frost (PvP)";
	sound = 3;
};

GTFO.SpellID["19983"] = {
	--desc = "Cleave (Dragon Bosses)";
	tankSound = 0;
	sound = 3;
	trivialPercent = .5;
};

GTFO.SpellID["15284"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 5;
	specificMobs = { 
		28586, -- General Bjarngrim, HoL
		12017, -- Broodlord Lashlayer, BWL
		12129, -- Onyxian Warder, Onyxia's Lair
		10363, -- General Drakkisath, UBRS
		39698, -- Karsh Steelbender, BRC
		9568, -- Overlord Wyrmthalak, LBRS
		10433, -- Marduk Blackpool, Scholomance
		9237, -- War Master Voone, LBRS
		10429, -- Warchief Rend Blackhand, UBRS
		16216, -- Unholy Swords, Naxx
		35309, -- Argent Lightwielder, ToC5
		8893, -- Anvilrage Soldier, BRD
		22844, -- Ashtongue Battlelord, BT
		26734, -- Azure Enforcer, Nexus
		14456, -- Blackwing Guardsman, BWL
		12416, -- Blackwing Legionnaire, BWL
		20031, -- Bloodwarder Legionnaire, TK
		40419, -- Charscale Assaulter, RS
		10447, -- Chromatic Dragonspawn, UBRS
		17957, -- Coilfang Champion, SP
		22877, -- Coilskar Wrangler, BT
		12422, -- Death Talon Dragonspawn, BT
		12461, -- Death Talon Overseer, BT
		19512, -- Nethervine Reaper, Bot
		10366, -- Rage Talon Dragon Guard, UBRS
		9200, -- Spirestone Reaver, LBRS
	};
};

GTFO.SpellID["15496"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 3;
	specificMobs = { 
		20923, -- Blood Guard Porung, SH
		7267, -- Chief Ukorz Sandscalp, ZF
		3975, -- Herod, SM
		24180, -- Amani'shi Protector, ZA
		47232, -- Ghostly Cook, SFK (Heroic)
		42696, -- Stonecore Warbringer, SC
		16984, -- Plagued Warrior, Naxx
		45412, -- Lord Aurius Rivendare, Strat
		7797, -- Ruuzlu, ZF
		7274, -- Sandfury Executioner, ZF
		6211, -- Caverndeep Reaver, Gnom
		6488, -- Fallen Champion, SM
		10391, -- Skeletal Berserker, Strat
		7328, -- Withered Reaver, RFD
		14351, -- Gordok Bushwacker, DM
		11450, -- Gordok Reaver, DM
		10394, -- Black Guard Sentry, Strat
		14445, -- Captain Wyrmak, ST
		8899, -- Doomforge Dragoon, BRD
		9097, -- Scarshield Legionnarie, UBRS
		9692, -- Bloodaxe Raider, LBRS
		12467, -- Death Talon Captain, BWL
		16699, -- Shattered Hand Reaver, SH
		17800, -- Coilfang Myrmidon, SV
		17819, -- Durnholde Sentry, CoT:OH
	};
};

GTFO.SpellID["40504"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 5;
	specificMobs = { 
		17881, -- Aeonus, BM
		9037, -- Gloom'rel, BRD
		9028, -- Grizzle, BRD
		15511, -- Lord Kri, AQ40
		17942, -- Quagmirran, Slave Pens
		12258, -- Razorlash, Maur
		10507, -- The Ravenian, Scholo
		37022, -- Blighted Abomination, ICC
		15538, -- Anubisath Swarmguard, AQ40
		39899, -- Baltharus the Warborn (Clone), RS
		39751, -- Baltharus the Warborn, RS
		15389, -- Captain Drenn, AQ20
		15391, -- Captain Qeez, AQ20
		15392, -- Captain Tuubid, AQ20
		15390, -- Captain Xurrem, AQ20
		15385, -- Colonel Zerran, AQ20
		16573, -- Crypt Guard, Naxx
		15978, -- Crypt Reaver, Naxx
		8926, -- Deep Stinger, BRD
		49813, -- Evolved Drakonaar, BoT
		44708, -- Forsaken Flesh Ripper, SM
		15388, -- Major Pakkon, AQ20
		15386, -- Major Yeggeth, AQ20
		15312, -- Obsidian Nullifier, AQ40
		15252, -- Qiraji Champion, AQ40
		15344, -- Swarmguard Needler, AQ20
		15229, -- Vekniss Soldier, AQ40
		26624, -- Wretched Belcher, DTK
		54499, -- The Abominable Greench, Winter Veil
	};
};

GTFO.SpellID["40505"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 5;
	specificMobs = { 
		11517, -- Oggleflint, RFC
		23223, -- Bonechewer Spectator, BT
		7347, -- Boneflayer Ghoul, RFD
		21338, -- Coilfang Leper, SV
		37534, -- Spinestalker, ICC
		37069, -- Lumbering Abomination, HoR
		42975, -- Plague Ghoul, Strat
		10405, -- Plague Ghoul, Strat
	};
};

GTFO.SpellID["42724"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 5;
	specificMobs = { 
		23954, -- Ingvar the Plunderer, Utgarde Keep
		27983, -- Dark Rune Protector, HoS
		27960, -- Dark Rune Warrior, HoS
		26550, -- Dragonflayer Deathseeker, UP
		24080, -- Dragonflayer Weaponsmith, UK
		28578, -- Hardened Steel Reaver, HoS
		33125, -- Iron Honor Guard, Ulduar
		32875, -- Iron Honor Guard, Ulduar
	};
	trivialLevel = 85;
};

GTFO.SpellID["15576"] = {
	--desc = "Whirlwind";
	sound = 3;
	tankSound = 0;
	trivialPercent = 5;
	specificMobs = { 
		23863, -- Daakara, Zul'Aman
	};
};

GTFO.SpellID["115519"] = {
	--desc = "Cleave";
	tankSound = 0;
	sound = 3;
	trivialPercent = 5;
	specificMobs = { 
		59746, -- Scarlet Centurion
	};
};

GTFO.SpellID["79860"] = {
	--desc = "Blizzard";
	sound = 2;
	trivialPercent = 1;
	specificMobs = { 
		65444, -- Captain Mousson, Theramore's Fall
	};
};

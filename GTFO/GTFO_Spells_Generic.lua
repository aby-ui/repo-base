--------------------------------------------------------------------------
-- GTFO_Spells_Generic.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Generic List
Author: Zensunim of Malygos

Sample:
	GTFO.SpellID["12345"] = {
		--desc = "Spell of Awesomeness (PvP)";
		sound = 1;
		tankSound = 2;
		soundHeroic = 1;
		tankSoundHeroic = 2;
		soundChallenge = 1;
		tankSoundChallenge = 2;
		ignoreSelfInflicted = true;
		trivialLevel = 80;
		trivialPercent = 0;
		alwaysAlert = true;
		applicationOnly = true;
		ignoreApplication = true;
		minimumStacks = 1;
		maximumStacks = 5;
		specificMobs = { 123, 234, 345 };
		test = true;
		vehicle = true;
		affirmingDebuffSpellID = 12345;
		negatingBuffSpellID = 12345;
		negatingDebuffSpellID = 12345;
		negatingIgnoreTime = 1;
		damageMinimum = 50000;
		ignoreEvent = "IgnoreSpell";
		category = "TestSpell";
		casterOnly = true;
		meleeOnly = true;
		spellType = "SPELL_AURA_REFRESH";
	};
		
]]--

GTFO.SpellID["46264"] = {
	--desc = "Void Zone Effect (Generic - Unknown)";
	trivialPercent = 0;
	sound = 1;
};

GTFO.SpellID["49699"] = {
	--desc = "Consumption (Generic)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["39004"] = {
	--desc = "Consumption (Generic)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["30538"] = {
	--desc = "Consumption (Generic)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["30498"] = {
	--desc = "Consumption (Generic)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["35951"] = {
	--desc = "Consumption (Generic)";
	sound = 1;
	trivialPercent = 0;
};

-- Paladin
GTFO.SpellID["81297"] = {
	--desc = "Consecration (PvP)";
	trivialPercent = 0;
	sound = 2;
};

-- Mage
GTFO.SpellID["2120"] = {
	--desc = "Flamestrike (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["10"] = {
	--desc = "Blizzard (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["42208"] = {
	--desc = "Blizzard (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["82739"] = {
	--desc = "Flame Orb (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["84721"] = {
	--desc = "Frostfire Orb (PvP)";
	trivialPercent = 0;
	sound = 2;
};

-- Warlock
GTFO.SpellID["5740"] = {
	--desc = "Rain of Fire (PvP)";
	trivialPercent = 0;
	sound = 2;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["42223"] = {
	--desc = "Rain of Fire (PvP)";
	trivialPercent = 0;
	sound = 2;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["5857"] = {
	--desc = "Hellfire Effect (PvP)";
	sound = 2;
	trivialPercent = 0;
	ignoreSelfInflicted = true;
};

-- Druid
GTFO.SpellID["50288"] = {
	--desc = "Starfall (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["16914"] = {
	--desc = "Hurricane (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["42231"] = {
	--desc = "Hurricane (PvP)";
	trivialPercent = 0;
	sound = 2;
};

-- Death Knight
GTFO.SpellID["43265"] = {
	--desc = "Death and Decay (PvP)";
	ignoreSelfInflicted = true;
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["52212"] = {
	--desc = "Death and Decay (PvP)";
	ignoreSelfInflicted = true;
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["68766"] = {
	--desc = "Desecration (PvP)";
	trivialPercent = 0;
	sound = 2;
};

-- Shaman
GTFO.SpellID["8187"] = {
	--desc = "Magma Totem (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["8349"] = {
	--desc = "Fire Nova (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["77478"] = {
	--desc = "Earthquake (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["20754"] = {
	--desc = "Rain of Fire (Generic)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["36808"] = {
	--desc = "Rain of Fire (Generic)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["76055"] = {
	--desc = "Flame Patch (Generic)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["13812"] = {
	--desc = "Explosive Trap (PvP)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["33239"] = {
	--desc = "Whirlwind (Generic)";
	sound = 1;
	trivialPercent = 0;
	specificMobs = { 
		18831, -- High King Maulgar - Gruul's Lair
		46944, -- Hurp'Derp, Twilight Highlands
	};
};

GTFO.SpellID["15578"] = {
	--desc = "Whirlwind";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
	specificMobs = { 
		3975,	-- Herod - Scarlet Monastery
		24239, -- Hex Lord Malacrass - ZA
	};
};

GTFO.SpellID["114919"] = {
	--desc = "Arcing Light (PvP)";
	sound = 2;
};


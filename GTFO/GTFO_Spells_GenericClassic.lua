--------------------------------------------------------------------------
-- GTFO_Spells_GenericClassic.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Generic List (Classic version)

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
		trivialLevelApplication = 90;
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

if (GTFO.ClassicMode or GTFO.BurningCrusadeMode) then

-- Paladin
GTFO.SpellID["26573"] = {
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

-- Warlock
GTFO.SpellID["5740"] = {
	--desc = "Rain of Fire (PvP)";
	trivialPercent = 0;
	sound = 2;
};

GTFO.SpellID["5857"] = {
	--desc = "Hellfire Effect (PvP)";
	sound = 2;
	trivialPercent = 0;
	ignoreSelfInflicted = true;
};

-- Druid
GTFO.SpellID["16914"] = {
	--desc = "Hurricane (PvP)";
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

GTFO.SpellID["13812"] = {
	--desc = "Explosive Trap (PvP)";
	sound = 2;
	trivialPercent = 0;
};

end

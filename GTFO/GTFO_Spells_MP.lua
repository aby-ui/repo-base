--------------------------------------------------------------------------
-- GTFO_Spells_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Mists of Pandaria
Author: Zensunim of Malygos
]]--

-- ***************
-- * Scholomance *
-- ***************

GTFO.SpellID["120027"] = {
	--desc = "Burn (Instructor Chillheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120037"] = {
	--desc = "Ice Wave (Instructor Chillheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111616"] = {
	--desc = "Ice Wrath (Instructor Chillheart)";
	sound = 4;
	trivialPercent = 0;
};

GTFO.SpellID["114061"] = {
	--desc = "Wondrous Rapidity (Jandice Barov)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111628"] = {
	--desc = "Dark Blaze (Lilian Voss)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114009"] = {
	--desc = "Soulflame (Rattlegore)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114873"] = {
	--desc = "Toxic Potion (Professor Slate)";
	sound = 1;
	trivialPercent = 0;
};

-- **********************
-- * Stormstout Brewery *
-- **********************

GTFO.SpellID["112993"] = {
	--desc = "Furlwind (Hoptallus)";
	sound = 1;
	tankSound = 2;
	tankSoundHeroic = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112945"] = {
	--desc = "Carrot Breath (Hoptallus)";
	sound = 1;
};

GTFO.SpellID["116170"] = {
	--desc = "Carbonation (Fizzy Brew Alemental)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106851"] = {
	--desc = "Blackout Brew (Yan-Zhu the Uncasked)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 4;
};

GTFO.SpellID["114386"] = {
	--desc = "Carbonation (Yan-Zhu the Uncasked)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106560"] = {
	--desc = "Gushing Brew (Yan-Zhu the Uncasked)";
	sound = 4;
	trivialPercent = 0;
	damageMinimum = 1;
};

GTFO.SpellID["107046"] = {
	--desc = "Water Strike (Sodden Hozen Brawler)";
	sound = 2;
	soundHeroic = 1;
	tankSound = 0;
	tankSoundHeroic = 0;
	trivialPercent = 0;
};

GTFO.SpellID["107176"] = {
	--desc = "Fire Strike (Inflamed Hozen Brawler)";
	sound = 2;
	soundHeroic = 1;
	tankSound = 0;
	tankSoundHeroic = 0;
	trivialPercent = 0;
};

GTFO.SpellID["116182"] = {
	--desc = "Suds (Sudsy Brew Alemental)";
	sound = 1;
	trivialPercent = 0;
};

-- ******************************
-- * Temple of the Jade Serpent *
-- ******************************

GTFO.SpellID["110099"] = {
	--desc = "Shadow of Doubt (Minion of Doubt)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118540"] = {
	--desc = "Jade Serpent Wave (Liu Flameheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107110"] = {
	--desc = "Jade Fire (Liu Flameheart)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["115167"] = {
	--desc = "Corrupted Waters (Wise Mari)";
	sound = 1;
};

GTFO.SpellID["111720"] = {
	--desc = "Swirling Sunfire (Loremaster Stonestep)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106653"] = {
	--desc = "Sha Residue (Corrupt Living Water)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106228"] = {
	--desc = "Nothingness (Sha of Doubt)";
	sound = 4;
	negatingDebuffSpellID = 106113; -- Touch of Nothingness
	trivialPercent = 0;
	negatingIgnoreTime = 2;
};

GTFO.SpellID["145888"] = {
	--desc = "Boiling Broth (Ghost of Lin Da-Gu)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["146919"] = {
	--desc = "Dash of Spice (Ghost of Lin Da-Gu)";
	sound = 1;
	trivialPercent = 0;
};

-- *********************
-- * Scarlet Cathedral *
-- *********************

GTFO.SpellID["115507"] = {
	--desc = "Flamethrower (Scarlet Flamethrower)";
	sound = 2;
	tankSound = 0;
	soundChallenge = 1;
	tankSoundChallenge = 0;
	trivialPercent = 0;
};

GTFO.SpellID["114465"] = {
	--desc = "Scorched Earth (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113766"] = {
	--desc = "Firestorm Kick (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114808"] = {
	--desc = "Blazing Fists (Brother Korloff)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["115291"] = {
	--desc = "Spirit Gale (Thalnos the Soulrender)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["110963"] = {
	--desc = "Flamestrike (High Inquisitor Whitemane)";
	sound = 2;
	soundChallenge = 1;
	trivialPercent = 0;
};

-- *****************
-- * Scarlet Halls *
-- *****************

GTFO.SpellID["114863"] = {
	--desc = "Exploding Shot (Commander Lindon)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113620"] = {
	--desc = "Burning Books (Flameweaver Koegler)";
	sound = 1;
	trivialPercent = 0;
};

-- ***************************
-- * Gate of the Setting Sun *
-- ***************************

GTFO.SpellID["115458"] = {
	--desc = "Acid Bomb (Striker Ga'dok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["116297"] = {
	--desc = "Strafing Run (Striker Ga'dok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106874"] = {
	--desc = "Fire Bomb";
	sound = 1;
};

GTFO.SpellID["107122"] = {
	--desc = "Viscous Fluid (Commander Ri'mok)";
	sound = 1;
};

GTFO.SpellID["107121"] = {
	--desc = "Frenzied Assault (Commander Ri'mok)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["111735"] = {
	--desc = "Tar (Raigonn)";
	sound = 2;
	applicationOnly = true;
};

GTFO.SpellID["107279"] = {
	--desc = "Engulfing Winds (Raigonn)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107275"] = {
	--desc = "Engulfing Winds (Raigonn)";
	sound = 1;
	trivialPercent = 0;
	test = true; -- Verify correct spell IDs and avoidability
};

GTFO.SpellID["111644"] = {
	--desc = "Screeching Swarm (Raigonn)";
	sound = 2;
	tankSound = 0;
	trivialPercent = 0;
};


-- ********************
-- * Mogu'shan Palace *
-- ********************

GTFO.SpellID["120101"] = {
	--desc = "Magnetic Field (Ming the Cunning)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["123651"] = {
	--desc = "Whirlwind (Kargesh Ribcrusher)";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["120562"] = {
	--desc = "Lightning Storm (Harthak Stormcaller)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119374"] = {
	--desc = "Whirlwind (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119573"] = {
	--desc = "Ring of Fire - Flames (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119311"] = {
	--desc = "Stream of Blades (Xin the Weaponmaster)";
	sound = 1;
	trivialPercent = 0;
};

-- ***********************
-- * Shado-Pan Monastery *
-- ***********************
-- TODO: Invoke Lightning (Gu Cloudstrike) (possibly FF?, benign for normal, must test for heroic/chal?)

GTFO.SpellID["128889"] = {
	--desc = "Static Field (Gu Cloudstrike)";
	sound = 1;
};

GTFO.SpellID["102572"] = {
	--desc = "Lightning Breath (Gu Cloudstrike)";
	soundChallenge = 1;
	tankSoundChallenge = 0; -- TODO: Verify the tank for avoiding this in challenge mode (?)
	test = true;
};

GTFO.SpellID["106645"] = {
	--desc = "Whirling Steel (Flying Snow)";
	sound = 1;
	tankSound = 2;
	soundHeroic = 1;
	tankSoundHeroic = 1;
};

GTFO.SpellID["106854"] = {
	--desc = "Fists of Fury Strike (Master Snowdrift)";
	sound = 1;
};

GTFO.SpellID["106944"] = {
	--desc = "Shadows of Destruction (Destroying Sha)";
	sound = 1;
	tankSound = 0; -- TODO: Verify the tank can avoid this in challenge mode by moving
};

GTFO.SpellID["131241"] = {
	--desc = "Fire Arrow (Shado-Pan Fire Archer)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112933"] = {
	--desc = "Ring of Malice (Taran Zhu)";
	sound = 1;
};

GTFO.SpellID["131522"] = {
	--desc = "Ring of Malice (Taran Zhu)";
	sound = 1;
};

GTFO.SpellID["112918"] = {
	--desc = "Pool of Shadows (Taran Zhu)";
	sound = 2;
	soundChallenge = 1;
};

-- **************************
-- * Siege of Nivzao Temple *
-- **************************

GTFO.SpellID["120593"] = {
	--desc = "Sap Puddle";
	sound = 2;
	applicationOnly = true;
};

GTFO.SpellID["119941"] = {
	--desc = "Sap Residue (Vizier Jin'bak)";
	sound = 1; -- Modify to do low-damage alert when below minimum stacks?
	applicationOnly = true;
	minimumStacks = 9; -- This amount may need to be adjusted based on gear, challenge modes, etc.
	test = true;
};

GTFO.SpellID["128359"] = {
	--desc = "Caustic Tar (Commander Vo'jak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120760"] = {
	--desc = "Thousand Blades (Commander Vo'jak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121443"] = {
	--desc = "Caustic Pitch (Wing Leader Ner'onok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121447"] = {
	--desc = "Quick-Dry Resin (Wing Leader Ner'onok)";
	soundFunction = function() 
		local power = UnitPower("player", ALTERNATE_POWER_INDEX) or 0;
		-- Alert only when gaining net power over time, not when the player is actively jumping
		if (power > ((GTFO.VariableStore.QuickDryResin or 0) + 5)) then
			GTFO.VariableStore.QuickDryResin = power;
			return 1;
		elseif (power < (GTFO.VariableStore.QuickDryResin or 0)) then
			-- Player is jumping, set a new baseline
			GTFO.VariableStore.QuickDryResin = power;
			return 0;
		else
			return 0;
		end
	end;
	alwaysAlert = true;
};

-- *****************
-- * Heart of Fear *
-- *****************

GTFO.SpellID["123812"] = {
	--desc = "Pheromones of Zeal (Imperial Vizier Zor'lok)";
	-- Alert once and then ignore briefly to allow the player to run through the stuff
	-- before yelling at the player for being too slow
	soundFunction = function() 
		if (not GTFO_FindEvent("ZorlokZealStart")) then
			GTFO_AddEvent("ZorlokZealIgnore", 8);
		end
		GTFO_AddEvent("ZorlokZealStart", 15);
		return 1;
	end;
	ignoreEvent = "ZorlokZealIgnore";
	alwaysAlert = true;
};

GTFO.SpellID["122336"] = {
	--desc = "Sonic Ring (Imperial Vizier Zor'lok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["122760"] = {
	--desc = "Exhale (Imperial Vizier Zor'lok)";
	sound = 1;
	tankSound = 0;
	negatingDebuffSpellID = 122761; -- Exhale
	negatingIgnoreTime = 2;
};

GTFO.SpellID["122718"] = {
	--desc = "Force and Verve (Imperial Vizier Zor'lok)";
	sound = 1;
	trivialPercent = 0;
	negatingDebuffSpellID = 122706; -- Noise Cancelling
};

GTFO.SpellID["125312"] = {
	--desc = "Blade Tempest (Blade Lord Ta'yak)";
	sound = 1;
};

GTFO.SpellID["123120"] = {
	--desc = "Pheromone Trail (Garalon)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["122064"] = {
	--desc = "Corrosive Resin (Wind Lord Mel'jarak)";
	alwaysAlert = true;
	soundFunction = function() 
		local resin = GTFO_DebuffStackCount("player", 122064) or 0;
		local equal = (resin == GTFO.VariableStore.StackCounter);
		GTFO.VariableStore.StackCounter = resin;
		if (resin > 0 and equal) then
			return 1;
		end
	end;
};

GTFO.SpellID["122125"] = {
	--desc = "Corrosive Resin Pool (Wind Lord Mel'jarak)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126912"] = {
	--desc = "Grievous Whirl (Kor'thik Fleshrender)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
	trivialPercent = 0;
};

GTFO.SpellID["122784"] = {
	--desc = "Reshape Life (Amber-Shaper Un'sok)";
	soundFunction = function() 
		GTFO_AddEvent("ReshapeLife", 5);
		GTFO.VariableStore.DisableGTFO = true;
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["122005"] = {
	--desc = "Molten Amber (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["121995"] = {
	--desc = "Amber Scalpel (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["122504"] = {
	--desc = "Burning Amber (Amber-Shaper Un'sok)";
	sound = 1;
	trivialPercent = 0;
	ignoreEvent = "ReshapeLife";
};

-- TODO: Stick Resin (Grand Empress Shek'zeer)

GTFO.SpellID["124868"] = {
	--desc = "Visions of Demise (Grand Empress Shek'zeer)";
	sound = 4;
	trivialPercent = 0;
	ignoreSelfInflicted = true;
};

-- ********************
-- * Mogu'shan Vaults *
-- ********************

GTFO.SpellID["116060"] = {
	--desc = "Amethyst Petrification (Stone Guard)";
	-- Drives the Amethyst Pool alert being set to low
	soundFunction = function() 
		GTFO_AddEvent("AmethystPool", 5);
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["130774"] = {
	--desc = "Amethyst Pool (Stone Guard)";
	soundFunction = function() 
		if (GTFO_FindEvent("AmethystPool")) then
			return 2;
		else
			return 1;
		end
	end;
	alwaysAlert = true;
};

GTFO.SpellID["116038"] = {
	--desc = "Jasper Petrification (Stone Guard)";
	-- Drives the Jasper Chains alert being turned off
	soundFunction = function() 
		GTFO_AddEvent("JasperChains", 5);
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["130404"] = {
	--desc = "Jasper Chains (Stone Guard)";
	sound = 4;
	ignoreEvent = "JasperChains";
};

GTFO.SpellID["116793"] = {
	--desc = "Wildfire (Feng the Accursed)";
	sound = 1;
};

GTFO.SpellID["116040"] = {
	--desc = "Epicenter (Feng the Accursed)";
	sound = 1;
	damageMinimum = 100000;
	test = true; -- TODO: Need adjustments for different difficulty levels
};

GTFO.SpellID["116434"] = {
	--desc = "Arcane Resonance (Feng the Accursed)";
	sound = 4;
};

GTFO.SpellID["116365"] = {
	--desc = "Arcane Velocity (Feng the Accursed)";
	sound = 1;
	negatingDebuffSpellID = 116417; -- Arcane Resonance (TODO: there are 4 types, but 116417 is used for normal 10/25, need more info on other difficulties)
	negatingIgnoreTime = 2;
	damageMinimum = 85000; -- TODO: Might need adjustments for Heroic
	test = true; -- TODO: This is a complicated alert, needs to be adjusted by damage amount and arcane resonance debuff
};

GTFO.SpellID["118094"] = {
	--desc = "Volley - First Shot (The Spirit Kings)";
	sound = 2;
	soundHeroic = 1;
};

GTFO.SpellID["118105"] = {
	--desc = "Volley - Second Shot (The Spirit Kings)";
	sound = 1;
};

GTFO.SpellID["117558"] = {
	--desc = "Coalescing Shadows (The Spirit Kings)";
	sound = 1;
};

-- TODO: Undying Shadow (The Spirit Kings) (Needs more information on this one)

GTFO.SpellID["124947"] = {
	--desc = "Celestial Breath (Elegon)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["116661"] = {
	--desc = "Energy Conduit (Elegon)";
	sound = 1;
};

-- TODO: Overcharged (Elegon) (Stack count varies by strategy, research needed for highest limit)

GTFO.SpellID["118529"] = {
	--desc = "Stone Block (Mogu'shan Secret-Keeper)";
	sound = 1;
	tankSound = 0;
};

-- TODO: Energy of Creation (Will of the Emperor) (Heroic only, FF too?)

-- *****************************
-- * Terrace of Endless Spring *
-- *****************************

GTFO.SpellID["117988"] = {
	--desc = "Defiled Ground - Damage (Protector Kaolan)";
	sound = 1;
};

GTFO.SpellID["118091"] = {
	--desc = "Defiled Ground - Debuff (Protector Kaolan)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["117955"] = {
	--desc = "Expelled Corruption (Protector Kaolan)";
	sound = 1;
};

GTFO.SpellID["117398"] = {
	--desc = "Lightning Prison (Elder Regail)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["123121"] = {
	--desc = "Spray (Lei Shi)";
	soundFunction = function() 
		-- Don't alert during Hide special
		if UnitExists("Boss1Target") then
			if (GTFO.TankMode) then
				if (not UnitIsUnit("Boss1Target", "player")) then
					if (GTFO_FindEvent("LeiShiSpray")) then
						-- Tanks that don't have aggro should avoid spray
						return 1;
					else
						-- Ignore first spray to give the tank a chance to get into/out of position
						GTFO_AddEvent("LeiShiSpray", 5);
					end
					return 0;
				end
			else
				return 1;
			end
		end
	end;
};

-- TODO: Scary Fog (Lei Shi)

GTFO.SpellID["119887"] = {
	--desc = "Death Blossom (Sha of Fear)";
	sound = 1;
	tankSound = 2;
};

-- ****************
-- * World Bosses *
-- ****************

GTFO.SpellID["119610"] = {
	--Doesn't work anyway, no combat log info for this debuff
	--desc = "Bitter Thoughts (Sha of Anger)";
	soundFunction = function() 
		-- Reduce the spam
		GTFO_AddEvent("BitterThoughts", .75);
		return 1;
	end;
	ignoreEvent = "BitterThoughts";
};

-- ********************
-- * Theramore's Fall *
-- ********************

GTFO.SpellID["128880"] = {
	--desc = "Crackling Flames";
	sound = 1;
};

GTFO.SpellID["15577"] = {
	--desc = "Whirlwind (Captains)";
	sound = 1;
};

-- *******************
-- * A Brewing Storm *
-- *******************

GTFO.SpellID["142561"] = {
	--desc = "Venom Cloud (Huntmaster S'thoc)";
	sound = 1;
};

GTFO.SpellID["142562"] = {
	--desc = "Torch Toss (Viletongue Raider)";
	sound = 1;
};

-- ********************************
-- * Crypt of the Forgotten Kings *
-- ********************************

GTFO.SpellID["120742"] = {
	--desc = "Anger (Cloud of Anger)";
	sound = 1;
};

GTFO.SpellID["128970"] = {
	--desc = "Bladestorm (Crypt Guardian)";
	sound = 2;
	soundHeroic = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120223"] = {
	--desc = "Breath of Hate (Seething Sha)";
	sound = 2;
	soundHeroic = 1;
	trivialPercent = 0;
};

GTFO.SpellID["119667"] = {
	--desc = "Fire Trap";
	sound = 1;
	applicationOnly = true;
};


-- *************************
-- * Arena of Annihilation *
-- *************************

GTFO.SpellID["123929"] = {
	--desc = "Stone Spin (Scar-Shell)";
	sound = 1;
};

GTFO.SpellID["123959"] = {
	--desc = "Flameline (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123967"] = {
	--desc = "Lava Pool (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123965"] = {
	--desc = "Flame Wall (Little Liuyang)";
	sound = 1;
};

GTFO.SpellID["123976"] = {
	--desc = "Trailblaze (Chagan Firehoof)";
	sound = 1;
};

GTFO.SpellID["125566"] = {
	--desc = "Whirlpool (Maki Waterblade)";
	sound = 1;
};

GTFO.SpellID["125626"] = {
	--desc = "Jade Lightning Strike (Cloudbender Kobo)";
	sound = 1;
};

GTFO.SpellID["131694"] = {
	--desc = "Twister (Cloudbender Kobo)";
	sound = 1;
};

GTFO.SpellID["125580"] = {
	--desc = "Cyclone Kick (Cloudbender Kobo)";
	sound = 2;
};

-- *********************
-- * Brewmoon Festival *
-- *********************

GTFO.SpellID["124380"] = {
	--desc = "Twirlwind (Den Mother Moof)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125405"] = {
	--desc = "Fire Lines (Warbringer Qobi)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["125428"] = {
	--desc = "Burning Oil (Warbringer Qobi)";
	sound = 1;
	trivialPercent = 0;
};

-- **********************
-- * Greenstone Village *
-- **********************

GTFO.SpellID["119402"] = {
	--desc = "Terror Shards (Greenstone Terrorizer)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["118819"] = {
	--desc = "Pollen Puff (Belligerent Blossom)";
	sound = 1;
};

GTFO.SpellID["122211"] = {
	--desc = "Jade Burn (Jade Destroyer)";
	sound = 1;
};

-- ***********************
-- * Assault on Zan'vess *
-- ***********************

GTFO.SpellID["133847"] = {
	--desc = "Whirlwind (Team Leader Scooter)";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
};

-- ***********************
-- * Dagger in the Dark *
-- ***********************

GTFO.SpellID["133001"] = {
	--desc = "Gas Bomb (Rak'gor Bloodrazor)";
	sound = 1;
	trivialPercent = 0;
	negatingDebuffSpellID = 133002; -- Cheap Shot
};

GTFO.SpellID["132758"] = {
	--desc = "Whirlwind (Darkhatched Lizard-Lord)";
	sound = 1;
	tankSound = 0;
	trivialPercent = 0;
};

-- *********************
-- * A Little Patience *
-- *********************

GTFO.SpellID["135496"] = {
	--desc = "Swamp Gas (Bogrot)";
	sound = 1;
	trivialPercent = 0;
};

-- *******************
-- * Brawler's Guild *
-- *******************

GTFO.SpellID["133610"] = {
	--desc = "Fire Lines - Impact (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133611"] = {
	--desc = "Fire Lines - Residue (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133303"] = {
	--desc = "Volatile Flames (Vian the Volatile)";
	sound = 1;
};

GTFO.SpellID["133287"] = {
	--desc = "Heated Pokers (Dungeon Master Vishas)";
	sound = 1;
};

GTFO.SpellID["133236"] = {
	--desc = "Explosion (Fran and Riddoh)";
	sound = 1;
};

GTFO.SpellID["132661"] = {
	--desc = "Firewall (Sanoriak)";
	sound = 1;
};

GTFO.SpellID["129888"] = {
	--desc = "Solar Beam (Leona Earthwind)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["133156"] = {
	--desc = "Shock Field (Deekan)";
	sound = 1;
};

GTFO.SpellID["133576"] = {
	--desc = "Electric Dynamite (Millie Watt)";
	sound = 1;
};

GTFO.SpellID["133289"] = {
	--desc = "Flames of Fallen Glory (Fjoll)";
	sound = 1;
};

GTFO.SpellID["133157"] = {
	--desc = "Leperous Spew (Leper Gnome Quintet)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 12;
};

GTFO.SpellID["141417"] = {
	--desc = "Artillery Strike (T440 Dual-Mode Robot)";
	sound = 1;
};

GTFO.SpellID["141393"] = {
	--desc = "Fire Patch (Anthracite)";
	sound = 1;
};

GTFO.SpellID["141001"] = {
	--desc = "Dreadful Poison (Nibbleh)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["133231"] = {
	--desc = "Destructolaser (Epicus Maximus)";
	sound = 1;
};

GTFO.SpellID["132724"] = {
	--desc = "Lightning Field (Disruptron)";
	sound = 1;
};

-- *****************************
-- * Trove of the Thunder King *
-- *****************************

GTFO.SpellID["139805"] = {
	--desc = "Lightning Surge";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["127473"] = {
	--desc = "Arrow Trap (Trap)";
	sound = 1;
	trivialPercent = .5;
};

-- *********************
-- * Throne of Thunder *
-- *********************

GTFO.SpellID["136989"] = {
	--desc = "Throw Spear (Zandalari Spear-Shaper)";
	sound = 1;
};

GTFO.SpellID["137088"] = {
	--desc = "Deluge (Zandalari Storm-Caller)";
	sound = 1;
};

GTFO.SpellID["139321"] = {
	--desc = "Storm Energy (Crazed Storm-Caller)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["138006"] = {
	--desc = "Electrified Waters (Jin'rokh the Breaker)";
	sound = 1;
};

GTFO.SpellID["139210"] = {
	--desc = "Focused Lightning - Pulse (Jin'rokh the Breaker)";
	sound = 1;
	negatingDebuffSpellID = 137422; -- Focused Lightning
};

GTFO.SpellID["137423"] = {
	--desc = "Focused Lightning - Pulse (Jin'rokh the Breaker)";
	sound = 1;
	negatingDebuffSpellID = 137422; -- Focused Lightning
};

GTFO.SpellID["137485"] = {
	--desc = "Lightning Fissure (Jin'rokh the Breaker)";
	sound = 1;
};

GTFO.SpellID["139461"] = {
	--desc = "Spirit Light (Spirit Flayer)";
	sound = 1;
};

GTFO.SpellID["139901"] = {
	--desc = "Stormcloud (Strombringer Draz'kil)";
	sound = 4;
	negatingDebuffSpellID = 139900; -- Stormcloud
	negatingIgnoreTime = 2;
};

GTFO.SpellID["136723"] = {
	--desc = "Sand Trap (Horridon)";
	sound = 1;
};

GTFO.SpellID["136646"] = {
	--desc = "Living Poison (Horridon)";
	sound = 1;
};

GTFO.SpellID["136573"] = {
	--desc = "Frozen Bolt (Horridon)";
	sound = 1;
};

GTFO.SpellID["136490"] = {
	--desc = "Lightning Nova Totem (Horridon)";
	sound = 1;
};

GTFO.SpellID["139467"] = {
	--desc = "Lightning Fissure (No'ku Stormsayer)";
	sound = 1;
};

GTFO.SpellID["139425"] = {
	--desc = "Waves of Fury (No'ku Stormsayer)";
	sound = 1;
	tankSound = 0; -- Not sure if this is necessary
};

GTFO.SpellID["136991"] = {
	--desc = "Biting Cold (Frost King Malakk)";
	sound = 4;
	negatingDebuffSpellID = 136992; -- Biting Cold
	negatingIgnoreTime = 2;
};

GTFO.SpellID["136937"] = {
	--desc = "Frostbite (Frost King Malakk)";
	soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 136922);
		if (stacks > 3) then
			return 1;
		elseif (stacks > 1) then
			return 2;
		end
		return 0;
	end;
	affirmingDebuffSpellID = 136922; -- Biting Cold (Frostbite stacks)
};

GTFO.SpellID["136860"] = {
	--desc = "Quicksand (Sul the Sandcrawler)";
	sound = 1;
};

GTFO.SpellID["136878"] = {
	--desc = "Ensnared (Sul the Sandcrawler)";
	sound = 1;
};

GTFO.SpellID["140685"] = {
	--desc = "Corrosive Breath (Mist Lurker)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["140621"] = {
	--desc = "Fungi Spores (Fungal Growth)";
	sound = 4;
};

GTFO.SpellID["137730"] = {
	--desc = "Ignite Flesh (Megaera)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["139842"] = {
	--desc = "Arctic Freeze (Megaera)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["139839"] = {
	--desc = "Rot Armor (Megaera)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["139836"] = {
	--desc = "Cinders (Megaera)";
	sound = 1;
};

GTFO.SpellID["139889"] = {
	--desc = "Torrent of Ice (Megaera)";
	sound = 1;
};

GTFO.SpellID["139909"] = {
	--desc = "Icy Ground (Megaera)";
	sound = 1;
};

GTFO.SpellID["139470"] = {
	--desc = "Choking Gas";
	sound = 1;
	soundLFR = 2;
};

GTFO.SpellID["134398"] = {
	--desc = "Slime Trail";
	sound = 1;
};

GTFO.SpellID["138319"] = {
	--desc = "Feed Pool (Ji-Kun)";
	soundFunction = function()
		local debuffCount = 0;
		for i = 1, 40 do
			local _, _, _, _, _, _, expirationTime, _, _, _, debuffSpellId = UnitDebuff("player", i);
			if (debuffSpellId == 134256) then
				return 1; -- Standing in a pool with the residual debuff
			end
			if (debuffSpellId == 138319) then
				debuffCount = debuffCount + 1;
			end
		end
		if (debuffCount > 1) then
			return 1; -- Standing in more than 1 pool at the same time
		end
		return 2; -- Standing in a pool without the residual debuff
	end;
};

GTFO.SpellID["140502"] = {
	--desc = "Eye Sore (Roaming Fog)";
	sound = 1;
	soundLFR = 2;
};

GTFO.SpellID["134755"] = {
	--desc = "Eye Sore (Durumu the Forgotten)";
	sound = 1;
};

-- TODO: Stern Gaze (Durumu the Forgotten) -- Alert based on damage amount?

GTFO.SpellID["134044"] = {
	--desc = "Lingering Gaze (Pool) (Durumu the Forgotten)";
	sound = 1;
};

GTFO.SpellID["138485"] = {
	--desc = "Crimson Wake (Large Anima Golem)";
	sound = 1;
};

GTFO.SpellID["139313"] = {
	--desc = "Frenzied Consumption (Rotting Scavenger)";
	sound = 1;
};

GTFO.SpellID["138707"] = {
	--desc = "Anima Font (Dark Animus)";
	sound = 4;
	soundLFR = 0;
	tankSound = 0;
};

--[[
-- Disabled, doesn't work right on final phase
GTFO.SpellID["134926"] = {
	--desc = "Throw Spear (Iron Qon)";
	sound = 1;
	test = true;
};
]]--

GTFO.SpellID["137668"] = {
	--desc = "Burning Cinders (Iron Qon)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["137669"] = {
	--desc = "Storm Cloud (Iron Qon)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["137664"] = {
	--desc = "Frozen Blood (Iron Qon)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["136261"] = {
	--desc = "Burning Winds (Iron Qon)";
	sound = 1;
};

GTFO.SpellID["137417"] = {
	--desc = "Flames of Passion (Suen)";
	sound = 1;
};

GTFO.SpellID["137440"] = {
	--desc = "Icy Shadows (Lu'lin)";
	sound = 1;
	tankSound = 0;
	soundHeroic = 0;
};

GTFO.SpellID["138178"] = {
	--desc = "Thunder Trap";
	sound = 1;
};

GTFO.SpellID["138234"] = {
	--desc = "Lightning Storm (Lightning Guardian)";
	sound = 1;
};

GTFO.SpellID["137176"] = {
	--desc = "Overloaded Circuits (Lei Shen)";
	sound = 1;
};

GTFO.SpellID["136853"] = {
	--desc = "Lightning Bolt (Lei Shen)";
	sound = 1;
};

GTFO.SpellID["135150"] = {
	--desc = "Crashing Thunder (Lei Shen)";
	sound = 1;
};

GTFO.SpellID["135153"] = {
	--desc = "Crashing Thunder (Lei Shen)";
	sound = 1;
};

-- *********************
-- * Blood in the Snow *
-- *********************

GTFO.SpellID["141379"] = {
	--desc = "Blizzard (Frostmane Bonechiller)";
	sound = 1;
};

GTFO.SpellID["141428"] = {
	--desc = "Bonechilling Blizzard (Bonechiller Barafu)";
	sound = 1;
};

GTFO.SpellID["133837"] = {
	--desc = "Hekima's Scorn (Hekima the Wise)";
	sound = 1;
};

-- ***************************
-- * The Secrets of Ragefire *
-- ***************************

GTFO.SpellID["142413"] = {
	--desc = "Pool of Embers (Kor'kron Emberguard)";
	sound = 1;
};

GTFO.SpellID["142413"] = {
	--desc = "Ruined Earth (Dark Shaman Xorenth)";
	sound = 1;
};

GTFO.SpellID["142311"] = {
	--desc = "Ruined Earth (Dark Shaman Xorenth - Heroic)";
	sound = 1;
};

GTFO.SpellID["142692"] = {
	--desc = "Burning Embers (Embercore)";
	sound = 1;
};

GTFO.SpellID["142768"] = {
	--desc = "Shattered Earth (Overseer Elaglo)";
	sound = 1;
};

-- **************************
-- * Dark Heart of Pandaria *
-- **************************

GTFO.SpellID["142139"] = {
	--desc = "Stone Rain (Earthborn Hatred)";
	sound = 1;
};

GTFO.SpellID["142202"] = {
	--desc = "Malevolent Force (Heart of Y'Shaarj)";
	sound = 1;
};

GTFO.SpellID["142154"] = {
	--desc = "Echo of Y'Shaarj (Heart of Y'Shaarj)";
	sound = 1;
};

-- ***************************
-- * Battle on the High Seas *
-- ***************************

GTFO.SpellID["143219"] = {
	--desc = "Fire (Barrel Explosion)";
	sound = 1;
};

GTFO.SpellID["142225"] = {
	--desc = "Shark Hunt (Whale Shark)";
	sound = 1;
};

-- *******************
-- * Proving Grounds *
-- *******************

GTFO.SpellID["145403"] = {
	--desc = "Lava Burns (Illusionary Flamecaller, Healing)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["144383"] = {
	--desc = "Lava Burns (Illusionary Flamecaller, Tanking)";
	sound = 1;
	applicationOnly = true;
};

-- **********************
-- * Siege of Orgrimmar *
-- **********************

GTFO.SpellID["149164"] = {
	--desc = "Rushing Waters (Aqeuous Defender)";
	sound = 1;
};

GTFO.SpellID["147213"] = {
	--desc = "Rushing Waters (Aqeuous Defender)";
	sound = 1;
};

GTFO.SpellID["147321"] = {
	--desc = "Vortex (Aqeuous Defender)";
	sound = 1;
};

GTFO.SpellID["143297"] = {
	--desc = "Sha Splash (Immerseus)";
	damageMinimum = 1;
	soundFunction = function() -- Warn only if you get hit more than once to reduce spamming
		if (GTFO_FindEvent("ShaSplash")) then
			GTFO_AddEvent("ShaSplash", 3);
			return 1;
		end
		GTFO_AddEvent("ShaSplash", 3);
		return 0;
	end
};

GTFO.SpellID["143460"] = {
	--desc = "Sha Pool (Immerseus - Heroic)";
	soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 143460);
		if ((stacks > 1 and not GTFO.TankMode) or (stacks > 4)) then
			return 1;
		else
			return 2;
		end
	end;
	applicationOnly = true;
};

GTFO.SpellID["143959"] = {
	--desc = "Defiled Ground (Rook Stonetoe)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["144357"] = {
	--desc = "Defiled Ground (Rook Stonetoe)";
	sound = 1;
};

GTFO.SpellID["143010"] = {
	--desc = "Corruption Kick (Rook Stonetoe)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["144397"] = {
	--desc = "Vengeful Strikes (Rook Stonetoe)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["144367"] = {
	--desc = "Noxious Poison (He Softfoot)";
	sound = 1;
};

GTFO.SpellID["143559"] = {
	--desc = "Dark Meditation (Sun Tenderheart)";
	sound = 1;
	tankSound = 2;
	tankSoundHeroic = 0;
	negatingDebuffSpellID = 143564; -- Meditative Field
};

GTFO.SpellID["143424"] = {
	--desc = "Sha Sear (Sun Tenderheart)";
	sound = 4;
	negatingDebuffSpellID = 143423; -- Sha Sear
	negatingIgnoreTime = 1;
};

GTFO.SpellID["145227"] = {
	--desc = "Blind Hatred (Amalgam of Corruption)";
	sound = 1;
};

GTFO.SpellID["146703"] = {
	--desc = "Bottomless Pit (Greater Corruption)";
	sound = 1;
};

GTFO.SpellID["146818"] = {
	--desc = "Aura of Pride (Sha of Pride)";
	sound = 4;
};

GTFO.SpellID["144774"] = {
	--desc = "Reaching Attack (Sha of Pride)";
	sound = 0;
	tankSound = 1;
};

GTFO.SpellID["145219"] = {
	--desc = "Corruption (Sha of Pride - Heroic)";
	sound = 1;
};

GTFO.SpellID["147705"] = {
	--desc = "Poison Cloud (Korgra the Snake)";
	sound = 1;
};

GTFO.SpellID["147705"] = {
	--desc = "Poison Cloud (Korgra the Snake)";
	sound = 1;
};

GTFO.SpellID["146872"] = {
	--desc = "Shadow Assault (Dragonmaw Ebon Stalker)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["146779"] = {
	--desc = "Flame Breath (Dragonmaw Proto-Drake)";
	sound = 1;
};

GTFO.SpellID["147824"] = {
	--desc = "Muzzle Spray (Master Cannoneer Dagryn)";
	sound = 1;
};

GTFO.SpellID["144218"] = {
	--desc = "Borer Drill (Iron Juggernaut)";
	sound = 1;
};

GTFO.SpellID["144918"] = {
	--desc = "Cutter Laser (Iron Juggernaut)";
	sound = 1;
};

GTFO.SpellID["144498"] = {
	--desc = "Explosive Tar (Iron Juggernaut)";
	sound = 1;
};

GTFO.SpellID["144017"] = {
	--desc = "Toxic Storm (Wavebinder Kardris)";
	sound = 1;
};

GTFO.SpellID["143993"] = {
	--desc = "Foul Geyser (Wavebinder Kardris)";
	sound = 1;
};

GTFO.SpellID["144066"] = {
	--desc = "Foulness (Foul Slime)";
	sound = 2;
};

GTFO.SpellID["145563"] = {
	--desc = "Magistrike (Kor'kron Arcweaver)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["145562"] = {
	--desc = "Backstab (Kor'kron Assassin)";
	sound = 1;
};

GTFO.SpellID["143481"] = {
	--desc = "Backstab (Kor'kron Assassin)";
	sound = 1;
};

GTFO.SpellID["143873"] = {
	--desc = "Ravager (General Nazgrim)";
	sound = 1;
};

GTFO.SpellID["143421"] = {
	--desc = "Ironstorm (Kor'kron Ironblade)";
	sound = 2;
	tankSound = 0;
};

GTFO.SpellID["143431"] = {
	--desc = "Magistrike (Kor'kron Arcweaver)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["145908"] = {
	--desc = "Serrated Rampage (Kor'kron Skullsplitter)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["146228"] = {
	--desc = "Scorched Earth (Hellscream Annihilator)";
	sound = 1;
};

GTFO.SpellID["142759"] = {
	--desc = "Pulse (Spark of Life)";
	sound = 1;
};

GTFO.SpellID["145999"] = {
	--desc = "Deteriorate (Arcweaver Reinforcements)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["149280"] = {
	--desc = "Crimson Acid (Modified Anima Golem)";
	sound = 1;
};


GTFO.SpellID["145716"] = {
	--desc = "Gusting Bomb (Sri'thik Bombardier)";
	sound = 1;
};

GTFO.SpellID["145747"] = {
	--desc = "Encapsulated Pheromones (Amber-Encased Kunchong)";
	sound = 1;
};

GTFO.SpellID["145748"] = {
	--desc = "Encapsulated Pheromones (Amber-Encased Kunchong)";
	sound = 1;
};

GTFO.SpellID["146182"] = {
	--desc = "Gusting Crane Kick (Wise Mistweaver Spirit)";
	sound = 1;
};

GTFO.SpellID["146257"] = {
	--desc = "Path of Blossoms (Nameless Windwalker Spirit)";
	sound = 1;
};

GTFO.SpellID["146226"] = {
	--desc = "Breath of Fire (Ancient Brewmaster Spirit)";
	sound = 1;
};

GTFO.SpellID["145817"] = {
	--desc = "Windstorm (Set'thik the Windwalker)";
	soundHeroic = 1;
};

GTFO.SpellID["143784"] = {
	--desc = "Burning Blood - Pool (Thok the Bloodthirsty)";
	sound = 1;
};

GTFO.SpellID["146470"] = {
	--desc = "Drillstorm (Goro'dan)";
	sound = 1;
	tankSound = 0;
};

-- TODO: Overload (Siegecrafter Blackfuse) 145444 - Avoidable at all?

GTFO.SpellID["144335"] = {
	--desc = "Matter Purification Beam (Siegecrafter Blackfuse)";
	sound = 1;
	soundHeroic = 3;
};

GTFO.SpellID["143856"] = {
	--desc = "Superheated (Siegecrafter Blackfuse)"; - Vehicle dmg too? 
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["143327"] = {
	--desc = "Serrated Slash (Siegecrafter Blackfuse)"; 
	sound = 1;
	vehicle = true;
};

GTFO.SpellID["146535"] = {
	--desc = "Frenzied Assault (Kor'thik Honor Guard)"; 
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["146452"] = {
	--desc = "Resonating Amber (Kor'thik Honor Guard)"; 
	sound = 1;
};

-- TODO: Reave (Kil'ruk the Wind-Reaver) xxxx
-- TODO: Catalytic Reaction: Yellow (Toxic Cloud) (Xaril the Poisoned Mind) xxxx
-- TODO: Whirling (Ka'roz the Locust) 143701 -- Avoidable?  How about when stunned?

GTFO.SpellID["142945"] = {
  --desc = "Eerie Fog (Xaril the Poisoned Mind)";
  sound = 1;
};

GTFO.SpellID["142803"] = {
  --desc = "Explosive Ring (Xaril the Poisoned Mind)";
  sound = 1;
};

GTFO.SpellID["146452"] = {
	--desc = "Resonating Amber (Xaril the Poisoned Mind)"; 
	sound = 1;
};

GTFO.SpellID["142809"] = {
	--desc = "Fiery Edge (Iyyokuk the Lucid)"; 
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 142808; -- Fiery Edge
	negatingIgnoreTime = 1;
};

GTFO.SpellID["143735"] = {
	--desc = "Caustic Amber (Ka'roz the Locust)"; 
	sound = 1;
};

-- TODO: Rapid Fire (Hisek the Swarmkeeper) 143243

GTFO.SpellID["143980"] = {
	--desc = "Vicious Assault (Korven the Prime)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["143981"] = {
	--desc = "Vicious Assault (Korven the Prime)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["143982"] = {
	--desc = "Vicious Assault (Korven the Prime)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["143984"] = {
	--desc = "Vicious Assault (Korven the Prime)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["143985"] = {
	--desc = "Vicious Assault (Korven the Prime)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["143576"] = {
	--desc = "Canned Heat (Xaril the Poisoned Mind)"; 
	sound = 1;
};

GTFO.SpellID["144762"] = {
	--desc = "Desecrated (Garrosh Hellscream)"; 
	sound = 1;
};

GTFO.SpellID["144817"] = {
	--desc = "Empowered Desecrated (Garrosh Hellscream)"; 
	sound = 1;
};

-- TODO: Whirling Corruption (Garrosh Hellscream) 144989 - Less damage further away, need to find threshold

GTFO.SpellID["148718"] = {
	--desc = "Fire Pit (Garrosh Hellscream)"; 
	sound = 1;
};

GTFO.SpellID["147136"] = {
	--desc = "Napalm (Garrosh Hellscream)"; 
	sound = 1;
};

-- ************
-- * Pandaria *
-- ************

GTFO.SpellID["131107"] = {
	--desc = "Creeping Doubt (Koukou)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["131492"] = {
	--desc = "Rain of Fire (Gatrul'lon Flamecaller)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["117718"] = {
	--desc = "Incinerate (Gormali Incinerator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125403"] = {
	--desc = "Harsh Winds (Torik-Ethis)";
	sound = 1;
};

GTFO.SpellID["130289"] = {
	--desc = "Gloom Whirl (Sha of Despair)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["129930"] = {
	--desc = "Torrent of Despair (Maw of Despair)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["125800"] = {
	--desc = "Spinning Crane Kick (Nasra Spothide)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118441"] = {
	--desc = "Freezing Winds";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125241"] = {
	--desc = "Voidcloud (Borginn Darkfist)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120331"] = {
	--desc = "Emperor's Brand";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["116076"] = {
	--desc = "Burning Stare of the Angry Monkey! (Monkey Idol Target)";
	sound = 1;
};

GTFO.SpellID["110295"] = {
	--desc = "Noxious Fumes";
	sound = 2;
};

GTFO.SpellID["126065"] = {
	--desc = "Consuming Rune";
	sound = 1;
};

GTFO.SpellID["126625"] = {
	--desc = "Sha Corruption (Spirit of Hatred)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126632"] = {
	--desc = "Whirlwind of Anger (Spirit of Hatred)";
	sound = 1;
};

GTFO.SpellID["128099"] = {
	--desc = "Sha Corruption (Wake of Horror)";
	sound = 1;
};

GTFO.SpellID["126792"] = {
	--desc = "Sha Spit (Adjunct Kree'zot)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125321"] = {
	--desc = "Bananarang (Various Monkey Rare Mobs)";
	sound = 1;
};

GTFO.SpellID["129729"] = {
	--desc = "Creeping Fog (Shuffling Mistlurker)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["125372"] = {
	--desc = "Blade Flurry (Gar'lok)";
	sound = 1;
};

GTFO.SpellID["128097"] = {
	--desc = "Blade Flurry (Vor'thik Dreadsworn)";
	sound = 1;
};

GTFO.SpellID["129657"] = {
	--desc = "Lightning Pool (Subjugated Serpent)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114685"] = {
	--desc = "Flame Spout";
	sound = 1;
};

GTFO.SpellID["126913"] = {
	--desc = "Thunder's Call";
	sound = 2;
};

GTFO.SpellID["126910"] = {
	--desc = "Molten Fists";
	sound = 2;
};

GTFO.SpellID["126916"] = {
	--desc = "Shadow's Fury";
	sound = 2;
};

GTFO.SpellID["128517"] = {
	--desc = "Firewall (Hozen Chiefs)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["130069"] = {
	--desc = "Sha Eruption (Adjunct Zet'uk)";
	sound = 1;
};

GTFO.SpellID["126336"] = {
	--desc = "Caustic Pitch (Vyraxxis)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["126394"] = {
	--desc = "Crow Storm (Prophet Khar'zul)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126443"] = {
	--desc = "Shadow Fog (Prophet Khar'zul)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["128385"] = {
	--desc = "Sonic Field (Kor'thik Resonator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["128385"] = {
	--desc = "Sonic Field (Kor'thik Resonator)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["126285"] = {
	--desc = "Freezing Water (Huo-Shuang)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["132020"] = {
	--desc = "Lightning Pool (Zhao-Ren)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["128421"] = {
	--desc = "Shadow Geyser (Darkened Horrors)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["128428"] = {
	--desc = "Corrosive Resin (Karanosh)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126976"] = {
	--desc = "Liquid Jade (Jade Construct)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["127467"] = {
	--desc = "Lightning Crash (Trap)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["127252"] = {
	--desc = "Lightning Crash (Zhao-Jin the Bloodletter)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135868"] = {
	--desc = "Ignite Fuel (Shredmaster Packle)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118260"] = {
	--desc = "Steaming Puddle (Brewmaster Chani)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["133800"] = {
	--desc = "Heavy Metal (Mercurial Visage)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126573"] = {
	--desc = "Burning! (Shonuf)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["124866"] = {
	--desc = "Rain Dance (Cournith Waterstrider)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135784"] = {
	--desc = "Infinite Sadness (Ishi)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["135060"] = {
	--desc = "Cave In";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["134771"] = {
	--desc = "Mortal Throw (Ubunti the Shade)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["131340"] = {
	--desc = "Xaril's Fire Potion (Xaril the Poisoned Mind)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["131356"] = {
	--desc = "Congealed Terror (Manifestation of Terror)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["126018"] = {
	--desc = "Harsh Winds (Aetha)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["140315"] = {
	--desc = "Hymn of Silence (Spirit Mask)";
	sound = 1;
};

GTFO.SpellID["140675"] = {
	--desc = "Spirit Gaze (Spirit Mask)";
	sound = 2;
	negatingDebuffSpellID = 140661; -- Arcanital's Barrier
};

GTFO.SpellID["138015"] = {
	--desc = "Ancient Flames";
	sound = 1;
};

GTFO.SpellID["139971"] = {
	--desc = "Thermal Expansion, Pulse (Horgak the Enslaver)";
	sound = 1;
};

GTFO.SpellID["139970"] = {
	--desc = "Thermal Collapse, Pulse (Horgak the Enslaver)";
	sound = 1;
};

GTFO.SpellID["140244"] = {
	--desc = "Lightning Crack (Zandalari Colossus)";
	sound = 1;
};

GTFO.SpellID["140460"] = {
	--desc = "Vile Spit (Mighty Devilsaur)";
	sound = 1;
};

GTFO.SpellID["140424"] = {
	--desc = "Acidic Regurgitation (Mighty Devilsaur)";
	sound = 1;
};

GTFO.SpellID["139185"] = {
	--desc = "Lightning Pole (War-God Al'chukla)";
	sound = 1;
};

GTFO.SpellID["140550"] = {
	--desc = "Rivers of Blood (Fleshcrafter Hoku)";
	sound = 1;
};

GTFO.SpellID["137115"] = {
	--desc = "Lightning Surge (Ball Lightning)";
	sound = 2;
};

GTFO.SpellID["137604"] = {
	--desc = "Electrocution";
	sound = 1;
};

GTFO.SpellID["137509"] = {
	--desc = "Hail of Arrows (Beastmaster Horaki)";
	sound = 1;
	negatingDebuffSpellID = 137434; -- Frost Shot
};

GTFO.SpellID["135160"] = {
	--desc = "Cannonball Spin (High Marshal Twinbraid)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["135318"] = {
	--desc = "Powder Burn (High Marshal Twinbraid)";
	sound = 1;
};

GTFO.SpellID["135470"] = {
	--desc = "Chaingun (High Marshal Twinbraid)";
	sound = 1;
};

GTFO.SpellID["131555"] = {
	--desc = "Blizzard (Dmong Naruuk)";
	sound = 2;
};

GTFO.SpellID["131274"] = {
	--desc = "Bug Swarm (Sra'thik Hivelord)";
	sound = 2;
};

GTFO.SpellID["126435"] = {
	--desc = "Mist (Wulon)";
	sound = 2;
};

GTFO.SpellID["140223"] = {
	--desc = "Earth Shatter (Anki)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["139625"] = {
	--desc = "Arcane Strom (Arcweaver Jor'guva)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["136813"] = {
	--desc = "Static Shock (Gura the Reclaimed)";
	sound = 1;
};

GTFO.SpellID["138469"] = {
	--desc = "Forge Fire (Forgemaster Deng)";
	sound = 1;
};

GTFO.SpellID["126557"] = {
	--desc = "Cave In (Spider Cave)";
	sound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["137328"] = {
	--desc = "Double-Edged Thrash (Back) (Cera)";
	sound = 1;
};

GTFO.SpellID["137330"] = {
	--desc = "Double-Edged Thrash (Front) (Cera)";
	sound = 1;
};

GTFO.SpellID["138479"] = {
	--desc = "Flurry of Teeth (Skumblade Saur-Priest)";
	sound = 2;
};

GTFO.SpellID["140851"] = {
	--desc = "Lightning Barrier (Shan Bu)";
	sound = 1;
};

GTFO.SpellID["136345"] = {
	--desc = "Stormcloud (Nalak)";
	sound = 4;
	negatingDebuffSpellID = 136340; -- Stormcloud
	negatingIgnoreTime = 4;
};

GTFO.SpellID["140560"] = {
	--desc = "Lightning Storm (Hu'seng the Gatekeeper)";
	sound = 1;
};

GTFO.SpellID["140393"] = {
	--desc = "Bubbling Brew (Captain Halu'kal)";
	sound = 2;
};

GTFO.SpellID["137542"] = {
	--desc = "Charged Bolt (Metal Lord Mono-Han)";
	sound = 2;
};

GTFO.SpellID["136905"] = {
	--desc = "Whirling Attack (Metal Lord Mono-Han)";
	sound = 1;
};

GTFO.SpellID["138190"] = {
	--desc = "Lightning Whirlwind (Shan'ze Battlemaster)";
	sound = 1;
};

GTFO.SpellID["138720"] = {
	--desc = "Lightning Strike (Forgemaster Vul'kon)";
	sound = 1;
};

GTFO.SpellID["139445"] = {
	--desc = "Meteor Storm (Sha Amalgamation)";
	sound = 1;
};

GTFO.SpellID["139353"] = {
	--desc = "Shadow Crash (Sha Amalgamation)";
	sound = 1;
};

GTFO.SpellID["138539"] = {
	--desc = "Stormbreath (Sparkmancer Vu)";
	sound = 1;
};

GTFO.SpellID["138539"] = {
	--desc = "Stormbreath (Sparkmancer Vu)";
	sound = 1;
};

GTFO.SpellID["142403"] = {
	--desc = "Ruin (Wavebinder Se'sha)";
	sound = 1;
};

GTFO.SpellID["142123"] = {
	--desc = "Whirling Axe (Commander Ag'troz)";
	sound = 1;
};

GTFO.SpellID["142043"] = {
	--desc = "Burnin' (Hoff Greasegun)";
	sound = 1;
};

GTFO.SpellID["142448"] = {
	--desc = "Ruin (Augur Narali)";
	sound = 1;
};

GTFO.SpellID["142208"] = {
	--desc = "Airborne Toxin (Ruskan Goreblade)";
	sound = 1;
};

GTFO.SpellID["141469"] = {
	--desc = "Blood of the Deathborn (Wrathion)";
	sound = 1;
};

GTFO.SpellID["116575"] = {
	--desc = "Darkness (Zhao-Jin the Bloodletter)";
	sound = 1;
};

GTFO.SpellID["116713"] = {
	--desc = "Lightning Wave (Zhao-Jin the Bloodletter)";
	sound = 1;
};

GTFO.SpellID["144462"] = {
	--desc = "Firestorm (Chi-Ji)";
	sound = 1;
};

GTFO.SpellID["144472"] = {
	--desc = "Blazing Song (Chi-Ji)";
	sound = 1;
	negatingDebuffSpellID = 144475; -- Beacon of Hope
	test = true;
};

GTFO.SpellID["144462"] = {
	--desc = "Firestorm (Chi-Ji)";
	sound = 1;
};

GTFO.SpellID["144494"] = {
	--desc = "Blazing Nova (Chi-Ji)";
	sound = 1;
};

GTFO.SpellID["144538"] = {
	--desc = "Jadefire Blaze (Yu'lon)";
	sound = 1;
};

GTFO.SpellID["144693"] = {
	--desc = "Pool of Fire - Debuff (Ordos)";
	sound = 1;
};

GTFO.SpellID["144694"] = {
	--desc = "Pool of Fire - Residual (Ordos)";
	sound = 1;
	damageMinimum = 20000;
};

-- TODO: Ancient Flame (Ordos) -- Stack warning?

GTFO.SpellID["147558"] = {
	--desc = "Claw Flurry (Ancient Spineclaw)";
	sound = 1;
};

GTFO.SpellID["147807"] = {
	--desc = "Murky Cloud (Damp Shambler)";
	sound = 2;
};

GTFO.SpellID["148208"] = {
	--desc = "Burning Pitch (Dread Ship Vazuvius)";
	sound = 1;
};

GTFO.SpellID["147822"] = {
	--desc = "Fire Blossom (Crimsonscale Firestorm)";
	sound = 1;
};

GTFO.SpellID["147829"] = {
	--desc = "Storm Blossom (Huolon)";
	sound = 1;
};

GTFO.SpellID["147826"] = {
	--desc = "Lightning Breath (Huolon)";
	sound = 1;
};

GTFO.SpellID["148731"] = {
	--desc = "Spinning Crane Kick (Spectral Brewmaster)";
	sound = 1;
};

GTFO.SpellID["148586"] = {
	--desc = "Skunky Suds (Skunky Brew Alemental)";
	sound = 1;
};

GTFO.SpellID["142629"] = {
	--desc = "Bananastorm";
	sound = 1;
	negatingDebuffSpellID = 142191; -- Amber Globule Detonation
};

GTFO.SpellID["128141"] = {
	--desc = "Lightning Pool (Milau)";
	sound = 1;
};

GTFO.SpellID["122976"] = {
	--desc = "Celestial Storm (Shan Bu)";
	sound = 1;
};

GTFO.SpellID["133710"] = {
	--desc = "Flak Fire Impact";
	sound = 1;
};

GTFO.SpellID["135868"] = {
	--desc = "Ignite Fuel";
	sound = 2;
};

GTFO.SpellID["131831"] = {
	--desc = "Fiery Keg Smash (Master Cheng)";
	sound = 1;
};

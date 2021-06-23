--------------------------------------------------------------------------
-- GTFO_Fail_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Mists of Pandaria
]]--

if (not (GTFO.ClassicMode or GTFO.BurningCrusadeMode)) then

-- ***************
-- * Scholomance *
-- ***************

GTFO.SpellID["111231"] = {
	--desc = "Ice Wall (Instructor Chillheart)";
	sound = 3;
};

GTFO.SpellID["114886"] = {
	--desc = "Frigid Grasp (Instructor Chillheart)";
	sound = 3;
};

GTFO.SpellID["113859"] = {
	--desc = "Arcane Bomb (Instructor Chillheart)";
	sound = 3;
};

GTFO.SpellID["114038"] = {
	--desc = "Gravity Flux (Jandice Barov, Heroic)";
	sound = 3;
};

GTFO.SpellID["114872"] = {
	--desc = "Fire Breath Potion (Professor Slate)";
	sound = 3;
	tankSound = 0;
};

-- **********************
-- * Stormstout Brewery *
-- **********************

GTFO.SpellID["107205"] = {
	--desc = "Spicy Explosion";
	sound = 3;
};

GTFO.SpellID["106648"] = {
	--desc = "Brew Explosion (Ook-Ook)";
	sound = 3;
};

GTFO.SpellID["106808"] = {
	--desc = "Ground Pound (Ook-Ook)";
	soundFunction = function() 
		-- Only alert the first failed one per volley
		GTFO_AddEvent("GroundPound", 4);
		return 3;
	end;
	ignoreEvent = "GroundPound";	
	alwaysAlert = true;
};

GTFO.SpellID["114291"] = {
	--desc = "Explosive Brew (Hopper)";
	sound = 3;
	test = true; -- Might be spammy, don't know if these are avoidable or not
};

GTFO.SpellID["114466"] = {
	--desc = "Wall of Suds (Yan-Zhu the Uncasked)";
	sound = 3;
};

-- ******************************
-- * Temple of the Jade Serpent *
-- ******************************

GTFO.SpellID["106938"] = {
	--desc = "Serpent Wave (Liu Flameheart)";
	sound = 3;
};

GTFO.SpellID["107053"] = {
	--desc = "Jade Serpent Wave (Liu Flameheart)";
	sound = 3;
};

GTFO.SpellID["106334"] = {
	--desc = "Wash Away (Wise Mari)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["106104"] = {
	--desc = "Hydrolance Pulse (Wise Mari)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["106105"] = {
	--desc = "Hydrolance Pulse (Wise Mari)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["106267"] = {
	--desc = "Hydrolance Pulse (Wise Mari)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["106319"] = {
	--desc = "Hydrolance Pulse (Wise Mari)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["145886"] = {
	--desc = "Bowls (Ghost of Lin Da-Gu)";
	sound = 3;
	trivialPercent = 0;
};

-- *****************
-- * Scarlet Halls *
-- *****************

GTFO.SpellID["111217"] = {
	--desc = "Cannon Blast (Scarlet Cannon)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["111217"] = {
	--desc = "Dragon's Reach (Armsmaster Harlan)";
	sound = 3;
	tankSound = 0;
	trivialPercent = 0;
};

GTFO.SpellID["112955"] = {
	--desc = "Blades of Light (Armsmaster Harlan)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["113653"] = {
	--desc = "Greater Dragon's Breath (Flameweaver Koegler)";
	sound = 3;
	trivialPercent = 0;
	applicationOnly = true;
};

-- ***************************
-- * Gate of the Setting Sun *
-- ***************************

GTFO.SpellID["107215"] = {
	--desc = "Mantid Munition Explosion (Saboteur Kip'tilak)";
	sound = 3;
	trivialPercent = 0;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["113645"] = {
	--desc = "Sabotage (Saboteur Kip'tilak)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["111671"] = {
	--desc = "Battering Headbutt (Raigonn)";
	sound = 3;
};

-- ********************
-- * Mogu'shan Palace *
-- ********************

GTFO.SpellID["119922"] = {
	-- Currently broken because Blizzard's combat log doesn't pick this up
	--desc = "Shockwave (Kuai the Brute)";
	sound = 3;
};

GTFO.SpellID["120087"] = {
	--desc = "Whirling Dervish (Ming the Cunning)";
	sound = 3;
};

GTFO.SpellID["119684"] = {
	--desc = "Ground Slam (Xin the Weaponmaster)";
	sound = 3;
};

GTFO.SpellID["119590"] = {
	--desc = "Ring of Fire - Explosion (Xin the Weaponmaster)";
	sound = 3;
	trivialPercent = 0;
};

-- ***********************
-- * Shado-Pan Monastery *
-- ***********************

GTFO.SpellID["106932"] = {
	--desc = "Static Field (Gu Cloudstrike)";
	sound = 3;
};

GTFO.SpellID["106871"] = {
	--desc = "Sha Spike (Sha of Violence)";
	sound = 3;
};

GTFO.SpellID["106433"] = {
	--desc = "Tornado Kick (Master Snowdrift)";
	soundHeroic = 3;
	tankSoundHeroic = 0;
	tankSoundChallenge = 3;
};

GTFO.SpellID["106470"] = {
	--desc = "Ball of Fire - Blue (Master Snowdrift)";
	sound = 3;
};

GTFO.SpellID["106413"] = {
	--desc = "Ball of Fire - Red (Master Snowdrift)";
	sound = 3;
};

-- **************************
-- * Siege of Nivzao Temple *
-- **************************

GTFO.SpellID["120200"] = {
	--desc = "Bombard (Sik'thik Amberwing)";
	sound = 3;
	tankSound = 0;
};

-- TODO: Unstable Blast (Sik'thik Demolisher) (avoidable)

GTFO.SpellID["124317"] = {
	--desc = "Blade Rush (General Pa'valak)";
	sound = 3;
};

GTFO.SpellID["119703"] = {
	--desc = "Detonate (General Pa'valak)";
	sound = 3;
};

-- *****************
-- * Heart of Fear *
-- *****************

GTFO.SpellID["123490"] = {
	--desc = "Jawbone Slam (Enslaved Bonesmasher)";
	sound = 3;
	tankSound = 0;
	trivialPercent = 0;
};

GTFO.SpellID["124673"] = {
	--desc = "Sonic Pulse (Imperial Vizier Zor'lok)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["122853"] = {
	--desc = "Tempest Slash (Blade Lord Ta'yak)";
	sound = 3;
	trivialPercent = 0;
};

-- TODO: Wind Step (Blade Lord Ta'yak) (fail if player wasn't the intended target)

GTFO.SpellID["124089"] = {
	--desc = "Zephyr (Set'thik Gustwing)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["122735"] = {
	--desc = "Furious Swipe (Garalon)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["122774"] = {
	--desc = "Crush (Garalon)";
	sound = 3;
	trivialPercent = 0;
	damageMinimum = 300000;
};

GTFO.SpellID["121898"] = {
	--desc = "Whirling Blade (Wind Lord Mel'jarak)";
	sound = 3;
	tankSound = 0;
};

-- TODO: Wind Bomb (Wind Lord Mel'jarak) (impact)
-- TODO: Wind Bomb (Wind Lord Mel'jarak) (detonation, caused by a player getting too close, need to determine who did it, probably raid wiper)
-- TODO: Amber Prison (Wind Lord Mel'jarak) (fail if player wasn't the intended target, doesn't apply in LFR)

GTFO.SpellID["126939"] = {
	--desc = "Amber Volley (Sra'thik Ambercaller)";
	sound = 3;
	tankSound = 0;
};

-- TODO: Living Amber (Amber-Shaper Un'sok) (explosion? avoidable?)

GTFO.SpellID["122457"] = {
	--desc = "Rough Landing (Amber Monstrosity)";
	sound = 3;
	test = true; -- Verify the tank being thrown isn't setting off this alert
};

-- TODO: Amber Globule (Amber-Shaper Un'sok) (only warn if the player was the intended target)
-- TODO: Sonic Discharge (Grand Empress Shek'zeer) (only fail if the player was in a dissonance field at the time, maybe)
-- TODO: Dread Screech (Grand Empress Shek'zeer) (fail if the players weren't the intended targets)
-- TODO: Amber Trap (Grand Empress Shek'zeer) (fail when afflicated)

GTFO.SpellID["124807"] = {
	--desc = "Toxic Slime (Kor'thik Reaver)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["124849"] = {
	--desc = "Consuming Terror (Grand Empress Shek'zeer)";
	sound = 3;
};

-- ********************
-- * Mogu'shan Vaults *
-- ********************

GTFO.SpellID["115861"] = {
	--desc = "Cobalt Petrification (Stone Guard)";
	-- Drives the Cobalt Mine alert
	soundFunction = function() 
		GTFO_AddEvent("CobaltMine", 5);
		return 0;
	end;
	alwaysAlert = true;
};

GTFO.SpellID["116281"] = {
	--desc = "Cobalt Mine (Stone Guard)";
	sound = 3; 
	ignoreEvent = "CobaltMine";
};

GTFO.SpellID["121087"] = {
	--desc = "Ground Slam (Cursed Mogu Sculpture)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["116374"] = {
	--desc = "Lightning Charge (Feng the Accursed)";
	sound = 3;
};

GTFO.SpellID["116510"] = {
	--desc = "Explosion (Troll Explosives)";
	sound = 3;
};

GTFO.SpellID["117455"] = {
	--desc = "Suicide (Gara'jal the Spiritbinder) (+30 seconds in spirit world)";
	sound = 3;
};

-- TODO: Frail Soul (Gara'jal the Spiritbinder) (Death from crossing over with debuff, "Frail Soul" is the debuff but not the actual damage/death event)

GTFO.SpellID["117918"] = {
	--desc = "Overhand Strike (The Spirit Kings)";
	sound = 3;
};

GTFO.SpellID["119521"] = {
	--desc = "Annihilate (Qiang the Merciless - Trash)";
	sound = 3;
};

GTFO.SpellID["117948"] = {
	--desc = "Annihilate (The Spirit Kings)";
	sound = 3;
};

GTFO.SpellID["118106"] = {
	--desc = "Volley - Third Shot (The Spirit Kings)";
	sound = 3;
};

GTFO.SpellID["118048"] = {
	--desc = "Pillaged (The Spirit Kings)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["126955"] = {
	--desc = "Forceful Swing (Mogu'shan Warden)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["119722"] = {
	--desc = "Energy Cascade (Elegon)";
	sound = 3;
};

GTFO.SpellID["132275"] = {
	--desc = "Obliteration (Elegon)";
	sound = 3;
};

GTFO.SpellID["116550"] = {
	--desc = "Energizing Smash (Will of the Emperor)";
	sound = 3;
};

GTFO.SpellID["116835"] = {
	--desc = "Devastating Arc (Will of the Emperor)";
	sound = 3;
};

GTFO.SpellID["132425"] = {
	--desc = "Stomp (Qin-xi, Will of the Emperor)";
	sound = 3;
};

GTFO.SpellID["116969"] = {
	--desc = "Stomp (Jan-xi, Will of the Emperor)";
	sound = 3;
};

-- *****************************
-- * Terrace of Endless Spring *
-- *****************************

-- TODO: Water Bolt (Elder Asani) (See if it's possible to avoid)

GTFO.SpellID["118003"] = {
	--desc = "Lightning Storm - Origin (Elder Regail)";
	sound = 3;
};

GTFO.SpellID["118004"] = {
	--desc = "Lightning Storm - 20 Yards (Elder Regail)";
	sound = 3;
};

GTFO.SpellID["118005"] = {
	--desc = "Lightning Storm - 40 Yards (Elder Regail)";
	sound = 3;
};

GTFO.SpellID["118007"] = {
	--desc = "Lightning Storm - 60 Yards (Elder Regail)";
	sound = 3;
};

GTFO.SpellID["118008"] = {
	--desc = "Lightning Storm - 80 Yards (Elder Regail)";
	sound = 3;
};

GTFO.SpellID["122777"] = {
	--desc = "Nightmares (Tsulong)";
	sound = 3;
};

GTFO.SpellID["122752"] = {
	--desc = "Shadow Breath (Tsulong)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["122752"] = {
	--desc = "Shadow Breath (Tsulong)";
	damageMinimum = 1;
	soundFunction = function() -- Fail for non-tanks, fail for tanks after more than 1 stack
		if (GTFO.TankMode) then
			if (GTFO_HasDebuff("player", 122752)) then
				return 3;
			end
			return 0;
		else
			return 3;
		end
	end
};

GTFO.SpellID["125786"] = {
	--desc = "Breath of Fear (Sha of Fear)";
	sound = 3;
	applicationOnly = true;
};

-- TODO: Eerie Skull (Sha of Fear) (Avoidable?)

GTFO.SpellID["119086"] = {
	--desc = "Penetrating Bolt (Sha of Fear)";
	sound = 3;
	damageMinimum = 1;
	applicationOnly = true;
	minimumStacks = 3;
	test = true; -- Need to turn this off in LFR (trivial)
};

-- TODO: Dread Spray (Sha of Fear)
-- TODO: Waterspout (Sha of Fear)
-- TODO: Submerge (Sha of Fear) (Avoidable?)

-- ****************
-- * World Bosses *
-- ****************

GTFO.SpellID["121600"] = {
	--desc = "Cannon Barrage (Salyis's Warband)";
	sound = 3;
};

-- ********************
-- * Theramore's Fall *
-- ********************

GTFO.SpellID["114568"] = {
	--desc = "Big Bessa's Cannon (Big Bessa)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["125915"] = {
	--desc = "Demolisher Shot (Gatecrusher)";
	sound = 3;
	applicationOnly = true;
};

-- *******************
-- * A Brewing Storm *
-- *******************

GTFO.SpellID["111544"] = {
	--desc = "Lightning Impact (Blanche's Lightning Rod)";
	sound = 3;
};

GTFO.SpellID["131595"] = {
	--desc = "Wind Slash (Viletongue Decimator)";
	sound = 3;
};

GTFO.SpellID["115013"] = {
	--desc = "Swamp Smash (Borokhula the Destroyer)";
	sound = 3;
};

GTFO.SpellID["122144"] = {
	--desc = "Earth Shattering (Borokhula the Destroyer)";
	sound = 3;
};

-- **************
-- * Unga Ingoo *
-- **************

GTFO.SpellID["121879"] = {
	--desc = "BA-BAM! (Ba-Bam)";
	sound = 3;
	applicationOnly = true;
};

-- ********************************
-- * Crypt of the Forgotten Kings *
-- ********************************

GTFO.SpellID["120783"] = {
	--desc = "Deathforce (Abomination of Anger)";
	sound = 3;
};

GTFO.SpellID["121029"] = {
	--desc = "Air Vent (Air Trap)";
	sound = 3;
};

-- ***********************
-- * Assault on Zan'vess *
-- ***********************

GTFO.SpellID["133925"] = {
	--desc = "Bomb! (Commander Tel'vrak)";
	sound = 3;
	trivialPercent = 0;	
};

GTFO.SpellID["133902"] = {
	--desc = "Cannon Fire (Gunship Cannon)";
	sound = 3;
	trivialPercent = 0;	
};

GTFO.SpellID["133820"] = {
	--desc = "Devastating Smash (Team Leader Scooter)";
	sound = 3;
	trivialPercent = 0;	
};

-- ******************
-- * Lion's Landing *
-- ******************

GTFO.SpellID["135616"] = {
	--desc = "Demolisher Shot";
	sound = 3;
	trivialPercent = 0;	
};

-- ********************
-- * Domination Point *
-- ********************

GTFO.SpellID["133197"] = {
	--desc = "High-Explosive Bomb";
	sound = 3;
	trivialPercent = 0;	
};

-- ***********************
-- * Dagger in the Dark *
-- ***********************

GTFO.SpellID["133804"] = {
	--desc = "Death Nova (Broodmaster Noshi)";
	sound = 3;
};

GTFO.SpellID["133387"] = {
	--desc = "Stalactite (Broodmaster Noshi)";
	sound = 3;
	applicationOnly = true;
};

-- *******************
-- * Brawler's Guild *
-- *******************

GTFO.SpellID["135341"] = {
	--desc = "Chomp (Bruce)";
	sound = 3;
};

GTFO.SpellID["134526"] = {
	--desc = "Lumbering Charge (Goredome)";
	sound = 3;
};

GTFO.SpellID["134537"] = {
	--desc = "Peck (Dippy)";
	sound = 3;
};

GTFO.SpellID["132668"] = {
	--desc = "Twisting Winds (Kirrawk)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["134777"] = {
	--desc = "Devastating Thrust (Ixx)";
	sound = 3;
};

GTFO.SpellID["133254"] = {
	--desc = "Collision (Crush)";
	sound = 3;
};

GTFO.SpellID["133362"] = {
	--desc = "Megafantastic Discombobumorphanator (Millie Watt)";
	sound = 3;
	applicationOnly = true;
	negatingDebuffSpellID = 133576; -- Electric Dynamite
};

GTFO.SpellID["133349"] = {
	--desc = "Darkzone (Fjoll)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["134623"] = {
	--desc = "Hoof Stomp (Smash Hoofstomp)";
	sound = 3;
};

GTFO.SpellID["133234"] = {
	--desc = "Goblin Rocket Barrage (Max Megablast)";
	sound = 3;
};

GTFO.SpellID["140833"] = {
	--desc = "Death Plane (Hexos)";
	sound = 3;
};
GTFO.SpellID["140834"] = GTFO.SpellID["140833"];
GTFO.SpellID["140835"] = GTFO.SpellID["140833"];
GTFO.SpellID["140836"] = GTFO.SpellID["140833"];
GTFO.SpellID["140837"] = GTFO.SpellID["140833"];
GTFO.SpellID["140838"] = GTFO.SpellID["140833"];

GTFO.SpellID["134772"] = {
	--desc = "Get Off! (Millhouse Manastorm)";
	sound = 3;
};

GTFO.SpellID["133199"] = {
	--desc = "Optic Blast (Zen'shar)";
	sound = 3;
};

GTFO.SpellID["133211"] = {
	--desc = "Evil Glare (Zen'shar)";
	sound = 3;
};

GTFO.SpellID["135621"] = {
	--desc = "Static Charge (Disruptron)";
	sound = 3;
};

GTFO.SpellID["133082"] = {
	--desc = "Disruption (Disruptron)";
	sound = 1;
};

GTFO.SpellID["133203"] = {
	--desc = "Pure Rock'n Roll (Epicus Maximus)";
	sound = 3;
};

GTFO.SpellID["140868"] = {
	--desc = "Left Hook (Ty'thar)";
	sound = 3;
};

GTFO.SpellID["140862"] = {
	--desc = "Right Hook (Ty'thar)";
	sound = 3;
};

GTFO.SpellID["140886"] = {
	--desc = "Slam (Ty'thar)";
	sound = 3;
};

GTFO.SpellID["141038"] = {
	--desc = "Feathery Detonation (Tyson Sanders)";
	sound = 3;
};

GTFO.SpellID["141041"] = {
	--desc = "Left Hook (Doctor FIST)";
	sound = 3;
};

GTFO.SpellID["141100"] = {
	--desc = "Right Hook (Doctor FIST)";
	sound = 3;
};

GTFO.SpellID["141102"] = {
	--desc = "Body Blow (Doctor FIST)";
	sound = 3;
};

GTFO.SpellID["141103"] = {
	--desc = "Uppercut (Doctor FIST)";
	sound = 3;
};

GTFO.SpellID["141104"] = {
	--desc = "Hammer Fist (Doctor FIST)";
	sound = 3;
};

GTFO.SpellID["141190"] = {
	--desc = "Swift Strike";
	sound = 3;
	specificMobs = { 
		70794, -- Blind Hero
	};	
};

GTFO.SpellID["141189"] = {
	--desc = "Blind Strike";
	sound = 3;
	specificMobs = { 
		70794, -- Blind Hero
	};	
};

GTFO.SpellID["141192"] = {
	--desc = "Blind Cleave";
	sound = 3;
	specificMobs = { 
		70794, -- Blind Hero
	};	
};

GTFO.SpellID["138802"] = {
	--desc = "Point of Light (Ahoo'ru)";
	sound = 3;
};

GTFO.SpellID["138847"] = {
	--desc = "Charge Impact (Ahoo'ru)";
	sound = 3;
};

GTFO.SpellID["133017"] = {
  --desc = "Explode (Battletron)";
  sound = 3;
};


-- *****************************
-- * Trove of the Thunder King *
-- *****************************

GTFO.SpellID["139777"] = {
	--desc = "Stone Smash (Stone Sentinel)";
	sound = 3;
};

GTFO.SpellID["139798"] = {
	--desc = "Rune Trap";
	sound = 3;
};

GTFO.SpellID["139799"] = {
	--desc = "Flame Tile";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["139800"] = {
	--desc = "Cloud Tile";
	sound = 3;
};

GTFO.SpellID["139801"] = {
	--desc = "Lightning Tile";
	sound = 3;
};

-- *********************
-- * Throne of Thunder *
-- *********************

-- TODO: Focused Lightning [Detonation] (Jin'rokh the Breaker) -- Fail for non-targets, but unable to accurately detect this? :/

GTFO.SpellID["138990"] = {
	--desc = "Violent Detonation (Jin'rokh the Breaker)";
	sound = 3;
};

GTFO.SpellID["137167"] = {
	--desc = "Thundering Throw (Jin'rokh the Breaker)";
	sound = 3;
	tankSound = 0;
};

-- TODO: Ionization (Jin'rokh the Breaker) -- Fail when standing near the explosion

GTFO.SpellID["137905"] = {
	--desc = "Lightning Strike [Diffusion] (Jin'rokh the Breaker)";
	sound = 3;
};

GTFO.SpellID["136739"] = {
	--desc = "Double Swipe - Front (Horridon)";
	sound = 3;
};

GTFO.SpellID["136740"] = {
	--desc = "Double Swipe - Back (Horridon)";
	sound = 3;
};

GTFO.SpellID["140414"] = {
	--desc = "Cleave (Zandalari Warlord)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["138658"] = {
	--desc = "Eruption";
	sound = 3;
};

GTFO.SpellID["137390"] = {
	--desc = "Shadowed Gift (High Priestess Mar'li)";
	sound = 3;
};

GTFO.SpellID["137133"] = {
	--desc = "Reckless Charge (Kazra'jin)";
	sound = 3;
	soundLFR = 0;
};

GTFO.SpellID["134539"] = {
	--desc = "Rockfall (Tortos)";
	sound = 3;
};

GTFO.SpellID["134011"] = {
	--desc = "Spinning Shell (Tortos)";
	sound = 3;
	soundLFR = 0;
};

-- TODO: Shell Concussion (Tortos)

GTFO.SpellID["140598"] = {
	--desc = "Fungal Explosion";
	sound = 3;
};

-- TODO: Acid Rain (Megaera) -- Fail based on damage amount

GTFO.SpellID["139992"] = {
	--desc = "Diffusion (Megaera)";
	sound = 3;
	tankSound = 0;
	test = true; -- Verify, tactic may include giving this to a non-tank?
};

GTFO.SpellID["134510"] = {
	--desc = "Web Spray (Corpse Spider)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["134415"] = {
	--desc = "Devoured (Gastropod)";
	sound = 3;
};

GTFO.SpellID["139100"] = {
	--desc = "Talon Strike (Ji-Kun)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["134375"] = {
	--desc = "Caw (Ji-Kun)"; -- Check to see if you should completely avoid this in normal/heroic
	soundFunction = function() -- Warn only if you get hit more than once within 5 seconds
		if (GTFO_FindEvent("JiKunCaw")) then
			return 3;
		end
		GTFO_AddEvent("JiKunCaw", 5);
		return 0;
	end
};

GTFO.SpellID["133778"] = {
	--Doesn't work, no combat log entry for this one! >:(
	--desc = "Disintegration Beam (Durumu the Forgotten)";
	sound = 3;
};

-- TODO: Force of Will (Durumu the Forgotten) -- No combat log entry for this one :(

GTFO.SpellID["137663"] = {
	--desc = "Acidic Splash (Durumu the Forgotten)";
	sound = 3;
};

-- TODO: Acidic Spines (Primordius) -- Avoidable?
-- TODO: Erupting Pustules (Primordius) -- Avoidable?

GTFO.SpellID["136185"] = {
	--desc = "Fragile Bones (Primordius)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["136187"] = {
	--desc = "Clouded Mind (Primordius)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["136183"] = {
	--desc = "Dulled Synapses (Primordius)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["136181"] = {
	--desc = "Impaired Eyesight (Primordius)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["140508"] = {
	--desc = "Volatile Mutation (Primordius)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["136037"] = {
	--desc = "Primordial Strike (Primordius)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["139215"] = {
	--desc = "Shockwave (Ritual Guard)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["138569"] = {
	--desc = "Explosive Slam (Massive Anima Golem)";
	sound = 3;
	tankSound = 0;
};

-- TODO: Anima Ring (Dark Animus) -- Tank fail (non-LFR only)

-- TODO: Unleashed Flame (Iron Qon) -- Fail when "Scorched" debuff is up

GTFO.SpellID["137654"] = {
	--desc = "Rushing Winds (Iron Qon)";
	applicationOnly = true;
	soundFunction = function() 
		-- Only alert on the first wind hit, ignore until thrown
		GTFO_AddEvent("RushingWinds", 4);
		return 3;
	end;
	ignoreEvent = "RushingWinds";
};

GTFO.SpellID["134759"] = {
	--desc = "Ground Rupture (Iron Qon)";
	sound = 3;
};

GTFO.SpellID["136498"] = {
	--desc = "Storm Surge (Iron Qon)";
	sound = 3;
};


-- TODO: Whirling Winds (Iron Qon)
-- TODO: Frost Spike (Iron Qon) -- Avoidable?
-- TODO: Freeze Spear (Iron Qon) -- Avoidable?

GTFO.SpellID["136892"] = {
	--desc = "Frozen Solid (Iron Qon)";
	sound = 3;
};

GTFO.SpellID["138688"] = {
	--desc = "Tidal Force (Lu'lin)";
	sound = 3;
	affirmingDebuffSpellID = 138855; -- Xuen's Blessed Alacrity
};

GTFO.SpellID["136722"] = {
	--desc = "Slumber Spores (Lu'lin)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["138273"] = {
	--desc = "Lightning Crash (Zao'cho)";
	sound = 3;
};

GTFO.SpellID["134916"] = {
	--desc = "Decapitate (Lei Shen)";
	sound = 3;
	soundLFR = 0;
	damageMinimum = 300000;
};

GTFO.SpellID["135096"] = {
	--desc = "Thunderstruck (Lei Shen)";
	sound = 3;
	damageMinimum = 300000; -- Adjust for heroics?
};

GTFO.SpellID["136543"] = {
	--desc = "Summon Ball Lightning (Lei Shen)";
	soundFunction = function() 
		if (GTFO_FindEvent("LeiShenBallLightning")) then
			-- Multiple hits = fail
			return 3;
		else
			-- Ignore first ball lightning, but fail on future ones
			GTFO_AddEvent("LeiShenBallLightning", 5);
			return 0;
		end
	end;
};

GTFO.SpellID["136850"] = {
	--desc = "Lightning Whip (Lei Shen)";
	sound = 3;
};

GTFO.SpellID["136326"] = {
	--desc = "Overcharged (Lei Shen)";
	sound = 3;
	tankSound = 0;
};

-- *********************
-- * Blood in the Snow *
-- *********************

GTFO.SpellID["34779"] = {
	--desc = "Freezing Circle (Bonechiller Barafu)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["141413"] = {
	--desc = "Ice Spike (Farastu)";
	sound = 3;
	negatingDebuffSpellID = 141410; -- Freeze Solid
};

-- ***************************
-- * The Secrets of Ragefire *
-- ***************************

GTFO.SpellID["142329"] = {
	--desc = "Electrified Ground (Kor'kron Dark Shaman)";
	sound = 3;
};

-- ***************************
-- * Battle on the High Seas *
-- ***************************

GTFO.SpellID["141846"] = {
	--desc = "Fire (Ship Explosion)";
	sound = 3;
};

GTFO.SpellID["141465"] = {
	--desc = "Barrel Explosion (Lieutenants)";
	sound = 3;
};

GTFO.SpellID["132993"] = {
	--desc = "Bomb (Lieutenants)";
	sound = 3;
};

GTFO.SpellID["132938"] = {
	--desc = "Bombs Away! (Cannon)";
	sound = 3;
};

GTFO.SpellID["132998"] = {
	--desc = "Sticky Bomb (Lieutenants)";
	sound = 4;
};

GTFO.SpellID["142293"] = {
	--desc = "Shark Bite (Whale Shark)";
	sound = 3;
};

-- *******************
-- * Proving Grounds *
-- *******************

GTFO.SpellID["145208"] = {
	--desc = "Aqua Bomb (Illusionary Aqualyte, Healing)";
	sound = 3;
	test = true;
};

GTFO.SpellID["144401"] = {
	--desc = "Powerful Slam (Illusionary Conquerer, Tanking)";
	sound = 3;
};

GTFO.SpellID["142191"] = {
	--desc = "Amber Globule Detonation (Illusionary Conquerer, Damage)";
	sound = 3;
};

-- **********************
-- * Siege of Orgrimmar *
-- **********************

GTFO.SpellID["143413"] = {
	--desc = "Swirl (Immerseus)";
	soundFunction = function() 
		-- Only alert on the first hit, ignore for a second
		GTFO_AddEvent("ImmerseusSwirl", 1);
		return 3;
	end;
	ignoreEvent = "ImmerseusSwirl";
};
GTFO.SpellID["143412"] = GTFO.SpellID["143413"];

GTFO.SpellID["143437"] = {
	--desc = "Corrosive Blast (Immerseus)";
	sound = 3;
	tankSound = 0;
};
GTFO.SpellID["143436"] = GTFO.SpellID["143436"];

GTFO.SpellID["143286"] = {
	--desc = "Seeping Sha (Immerseus)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["144018"] = {
	--desc = "Corruption Shock (Rook Stonetoe)";
	sound = 3;
};

GTFO.SpellID["143023"] = {
	--desc = "Corrupted Brew (Rook Stonetoe)";
	sound = 3;
};

GTFO.SpellID["143301"] = {
	--desc = "Gouge (He Softfoot)";
	sound = 3;
};

GTFO.SpellID["143023"] = {
	--desc = "Tear Reality (Manifestation of Corruption)";
	sound = 3;
};

GTFO.SpellID["144480"] = {
	--desc = "Expel Corruption (Essence of Corruption)";
	sound = 3;
};

GTFO.SpellID["144628"] = {
	--desc = "Titantic Smash (Titanic Corruption)";
	sound = 3;
};

GTFO.SpellID["146037"] = {
	--desc = "Sha Vortex (Sha of Pride)";
	sound = 3;
};

GTFO.SpellID["144911"] = {
	--desc = "Bursting Pride (Sha of Pride)";
	sound = 3;
};

GTFO.SpellID["144788"] = {
	--desc = "Self-Reflection (Sha of Pride)";
	sound = 3;
};

GTFO.SpellID["144615"] = {
	--desc = "Corrupted Prison (Sha of Pride)";
	sound = 3;
};

GTFO.SpellID["149031"] = {
	--desc = "Ethereal Corruption (Sha of Pride - Heroic)";
	sound = 3;
};

GTFO.SpellID["147198"] = {
	--desc = "Unstable Corruption (Sha of Pride - Heroic)";
	sound = 3;
};

GTFO.SpellID["146743"] = {
	--desc = "Sniped! (Kor'kron Elite Sniper)";
	sound = 3;
};

GTFO.SpellID["148506"] = {
	--desc = "Spike Mine Detonation (Pressure Mine)";
	sound = 3;
};

GTFO.SpellID["145752"] = {
	--desc = "Spike Mine Detonation (Cannon Mine)";
	sound = 3;
};

GTFO.SpellID["146848"] = {
	--desc = "Skull Cracker (High Enforcer Thranok)";
	sound = 3;
};

GTFO.SpellID["146849"] = {
	--desc = "Shattering Cleave (High Enforcer Thranok)";
	soundHeroic = 3;
	tankSound = 0;
	tankSoundHeroic = 0;
};

GTFO.SpellID["147688"] = {
	--desc = "Arcing Smash (Lieutenant Krugruk)";
	sound = 3;
};

GTFO.SpellID["148310"] = {
	--desc = "Bombard (Kor'kron Demolisher)";
	sound = 3;
};

GTFO.SpellID["144316"] = {
	--desc = "Mortar Blast (Iron Juggernaut)";
	sound = 3;
};

-- TODO: Ricochet (Iron Juggernaut) - Avoidable?

GTFO.SpellID["144464"] = {
	--desc = "Flame Vents (Iron Juggernaut)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["144919"] = {
	--desc = "Tar Explosion (Iron Juggernaut)";
	sound = 3;
	affirmingDebuffSpellID = 146325; -- Cutter Laser Target
};

-- TODO: Demolisher Cannons (Iron Juggernaut) - Avoidable group AOE? Like Jikun Caw?

GTFO.SpellID["144303"] = {
	--desc = "Swipe (Darkfang/Bloodclaw)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["144334"] = {
	--desc = "Iron Tomb (Earthbreaker Haromm)";
	sound = 3;
};

GTFO.SpellID["144030"] = {
	--desc = "Toxic Tornado (Wavebinder Kardris)";
	sound = 3;
};

GTFO.SpellID["143987"] = {
	--desc = "Falling Ash (Wavebinder Kardris)";
	sound = 3;
	damageMinimum = 400000;
};

GTFO.SpellID["145570"] = {
	--desc = "Boulder (Hellscream Demolisher)";
	sound = 3;
};

GTFO.SpellID["143712"] = {
	--desc = "Aftershock (General Nazgrim)";
	sound = 3;
};

GTFO.SpellID["143481"] = {
	--desc = "Backstab (Kor'kron Assassin)";
	sound = 3;
};

GTFO.SpellID["143887"] = {
	--desc = "Multi-Shot (Kor'kron Sniper)";
	sound = 3;
	negatingDebuffSpellID = 143882; -- Hunter's Mark
};

GTFO.SpellID["148785"] = {
	--desc = "Obliterate (War Master Kragg)";
	sound = 3;
};

GTFO.SpellID["148576"] = {
	--desc = "Shredding Blast (War Master Kragg)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["146225"] = {
	--desc = "Scorched Earth (Hellscream Annihilator)";
	sound = 3;
};

GTFO.SpellID["142815"] = {
	--desc = "Arcing Smash (Malkorok)";
	sound = 3;
};

GTFO.SpellID["142816"] = {
	--desc = "Breath of Y'Shaarj (Malkorok)";
	sound = 3;
};

GTFO.SpellID["142928"] = {
	--desc = "Displaced Energy (Malkorok)";
	sound = 3;
};

GTFO.SpellID["143857"] = {
	--desc = "Essence of Y'Shaarj (Malkorok)";
	sound = 3;
	affirmingDebuffSpellID = 142861; -- Ancient Miasma
};

-- TODO: Seismic Slam (Malkorok) 142849 - Only fail if you weren't the intended target, way to detect this?

GTFO.SpellID["142775"] = {
	--desc = "Nova (Spark of Life)";
	sound = 3;
};

GTFO.SpellID["147607"] = {
	--desc = "Wrecking Ball (Starved Yeti)";
	sound = 3;
};

GTFO.SpellID["146908"] = {
	--desc = "Slow and Steady (Brute Reinforcements)";
	sound = 3;
	tankSound = 0; -- Verify unavoidable by tank
};

GTFO.SpellID["145993"] = {
	--desc = "Set to Blow (Commander Na'kaz)";
	sound = 3;
};

GTFO.SpellID["145523"] = {
	--desc = "Animated Strike (Stone Statue)";
	sound = 3;
};

-- TODO: Return to Stone (Mogu) - Non-tank fail
-- TODO: Shadow Volley (Jun-Wei) - Ranged avoidable?
-- TODO: Molten Fist (Zu Yin) - Avoidable?
-- TODO: Jade Tempest (Xiang-Lin) - Avoidable?
-- TODO: Fracture (Kun-Da) - Avoidable?
-- TODO: Throw Explosives (Sri'thik Bombardier)

GTFO.SpellID["143428"] = {
	--desc = "Tail Lash (Thok the Bloodthirsty)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["143426"] = {
	--desc = "Fearsome Roar (Thok the Bloodthirsty)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["143780"] = {
	--desc = "Acid Breath (Thok the Bloodthirsty)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["143773"] = {
	--desc = "Freezing Breath (Thok the Bloodthirsty)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["143767"] = {
	--desc = "Scorching Breath (Thok the Bloodthirsty)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["143465"] = {
	--desc = "Chomp (Thok the Bloodthirsty)";
	sound = 3;
};

GTFO.SpellID["147906"] = {
	--desc = "Wrecking Ball (Starved Yeti)";
	sound = 3;
};

GTFO.SpellID["146534"] = {
	--desc = "Vivisection (Aggron)";
	sound = 3;
	tankSound = 0; -- Avoidable for tanks too?
};

GTFO.SpellID["149146"] = {
	--desc = "Detonate (Crawler Mine)";
	sound = 3;
};

GTFO.SpellID["143002"] = {
	--desc = "Detonate (Crawler Mine)";
	sound = 3;
};

GTFO.SpellID["144210"] = {
	--desc = "Death From Above (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["143641"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["144641"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["144661"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["144663"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["144664"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["146152"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["144658"] = {
	--desc = "Shockwave Missile (Siegecrafter Blackfuse)";
	sound = 3;
};

GTFO.SpellID["146605"] = {
	--desc = "Mighty Cleave (Kovok)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["142232"] = {
    --desc = "Death from Above (Kil'ruk the Wind-Reaver)";
    sound = 3;
};

-- TODO: Catalytic Reaction: Red (Xaril the Poisoned Mind) - Friendly Fire fail
-- TODO: Swipe (Mature Kunchong) - Avoidable?
-- TODO: Swipe (Amber Scorpion) 143378 - Fail for non-tanks or just fail for anyone with Sting 143376 ?

GTFO.SpellID["143240"] = {
	--desc = "Sonic Pulse (Hisek the Swarmkeeper)";
	soundHeroic = 3;
};

GTFO.SpellID["144094"] = {
	--desc = "Sonic Resonance (Hisek the Swarmkeeper)";
	soundFunction = function() -- Warn only if you get hit more than once
		if (GTFO_FindEvent("SonicBlast")) then
			return 3;
		end
		GTFO_AddEvent("SonicBlast", 5);
		return 0;
	end
};

GTFO.SpellID["144650"] = {
	--desc = "Iron Star Impact (Iron Star)";
	sound = 3;
};

GTFO.SpellID["144969"] = {
	--desc = "Annihilate (Garrosh Hellscream)";
	soundFunction = function() -- Warn only if you get hit more than once within 2 seconds
		if (GTFO_FindEvent("GarroshAnnihilate")) then
			return 3;
		end
		GTFO_AddEvent("GarroshAnnihilate", 2);
		return 0;
	end
};

-- TODO: Exploding Iron Star (Iron Star) 144798 - Lesser damage further away, research minimum damage threshold

GTFO.SpellID["145033"] = {
	--desc = "Empowered Whirling Corruption (Garrosh)";
	sound = 3;
};


-- ************
-- * Pandaria *
-- ************

GTFO.SpellID["131090"] = {
	--desc = "Face Smash (Koukou)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["130850"] = {
	--desc = "Rain of Meteors (Ga'trul)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["113119"] = {
	--desc = "Arcanic Oubliette";
	sound = 3;
};

GTFO.SpellID["116474"] = {
	--desc = "Riverblade Spike Trap";
	sound = 3;
};

GTFO.SpellID["124289"] = {
	--desc = "Yaungol Stomp (Go-Kan)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["124946"] = {
	--desc = "Devastating Arc (Jonn-Dar)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["129499"] = {
	--desc = "Far Reaching Fear (Manifestation of Fear)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["115186"] = {
	--desc = "Fear (Fear Sphere)";
	sound = 3;
};

GTFO.SpellID["118537"] = {
	--desc = "Sha Eruption (Orachi)";
	sound = 3;
};

GTFO.SpellID["118629"] = {
	--desc = "Sha Eruption (Shai Hu)";
	sound = 3;
};

GTFO.SpellID["120353"] = {
	--desc = "Flame Spout";
	sound = 3;
};

GTFO.SpellID["123798"] = {
	--desc = "Lightning Crash";
	sound = 3;
};

GTFO.SpellID["129024"] = {
	--desc = "Ancient Rune of Striking";
	sound = 3;
};

GTFO.SpellID["126631"] = {
	--desc = "Devastation (Spirit of Anger)";
	sound = 3;
};

GTFO.SpellID["124781"] = {
	--desc = "Mantid Mine (Kz'Kzik)";
	sound = 3;
};

GTFO.SpellID["131043"] = {
	--desc = "Thundering Slam (Shao-Tien Behemoth)";
	sound = 3;
};

GTFO.SpellID["131046"] = {
	--desc = "Crushing Stomp (Shao-Tien Behemoth)";
	sound = 3;
};

GTFO.SpellID["129612"] = {
	--desc = "Bombardment";
	sound = 3;
};

GTFO.SpellID["131801"] = {
	--desc = "Water Spout (Thousand-Year Guardian)";
	sound = 3;
};

GTFO.SpellID["126822"] = {
	--desc = "Jade Smash (Jade Sentinel)";
	sound = 3;
};

GTFO.SpellID["127393"] = {
	--desc = "Twirling Blades";
	sound = 3;
};

GTFO.SpellID["128550"] = {
	--desc = "Forceful Throw (Jokka-Jokka)";
	sound = 3;
};

GTFO.SpellID["112041"] = {
	--desc = "Shadowpan Firework Explosion (Shado-Pan Trainer)";
	sound = 3;
};

GTFO.SpellID["128121"] = {
	--desc = "Raise Earth (Kypa'rak)";
	sound = 3;
};

GTFO.SpellID["127189"] = {
	--desc = "Crushing Strike (Jade Guardian)";
	sound = 3;
};

GTFO.SpellID["127468"] = {
	--desc = "Flame Spout (Trap)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["118905"] = {
	--desc = "Static Charge (Dominance Shaman)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["136312"] = {
	--desc = "Unlit Torch of Strength";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["134251"] = {
	--desc = "Shadow Crash (Spiritbound Arcanist)";
	sound = 3;
	trivialPercent = 0;	
};

GTFO.SpellID["133567"] = {
	--desc = "Sha Eruption (Korune Spellweaver)";
	sound = 3;
	trivialPercent = 0;	
};

GTFO.SpellID["128961"] = {
	--desc = "Explosive Trap Effect (Hawkmaster Nurong)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["128121"] = {
	--desc = "Raise Earth (Kypa'rak)";
	sound = 3;
};

GTFO.SpellID["120871"] = {
	--desc = "Utter Despair (Dreadweaver Avartu)";
	damageMinimum = 10000;
	sound = 3;
};

GTFO.SpellID["135841"] = {
	--desc = "Utter Despair (Varatus the Conquerer)";
	damageMinimum = 10000;
	sound = 3;
};

GTFO.SpellID["134767"] = {
	--desc = "Chains of Faith (Muerta)";
	sound = 3;
};

GTFO.SpellID["134788"] = {
	--desc = "Cracking Blow (Kar Warmaker)";
	sound = 3;
};

GTFO.SpellID["134829"] = {
	--desc = "Sha Crash (Korune Sha-weaver/Shan Kien)";
	sound = 3;
};

GTFO.SpellID["131383"] = {
	--desc = "Pool of Pheromones (Akkolon)";
	sound = 3;
};

GTFO.SpellID["128022"] = {
	--desc = "Dread Slash (Akkolon)";
	sound = 3;
};

GTFO.SpellID["137685"] = {
	--desc = "Impale (Zandalari Spearthrower)";
	sound = 3;
};

GTFO.SpellID["140081"] = {
	--desc = "Wild Leap (Kresh the Ripper)";
	sound = 3;
};

GTFO.SpellID["140079"] = {
	--desc = "Berserker Rush (Kresh the Ripper)";
	sound = 3;
};

GTFO.SpellID["139645"] = {
	--desc = "Thermal Collapse, Explosion (Horgak the Enslaver)";
	sound = 3;
};

GTFO.SpellID["139921"] = {
	--desc = "Thermal Expansion, Explosion (Horgak the Enslaver)";
	sound = 3;
};

GTFO.SpellID["140257"] = {
	--desc = "Wave of Might (Zandalari Colossus)";
	sound = 3;
};

GTFO.SpellID["140221"] = {
	--desc = "Reverberating Smash, Close (Zandalari Colossus)";
	sound = 3;
	tank
};

GTFO.SpellID["140224"] = {
	--desc = "Reverberating Smash, Mid (Zandalari Colossus)";
	sound = 3;
};

GTFO.SpellID["140225"] = {
	--desc = "Reverberating Smash, Far (Zandalari Colossus)";
	sound = 3;
};

GTFO.SpellID["136730"] = {
	--desc = "Lightning Strike (Shan'ze Thundercaller)";
	sound = 3;
};

GTFO.SpellID["140405"] = {
	--desc = "Fetid Quake (Might Devilsaur)";
	sound = 3;
};

GTFO.SpellID["140406"] = {
	--desc = "Fetid Quake (Might Devilsaur)";
	sound = 3;
};

GTFO.SpellID["140407"] = {
	--desc = "Fetid Quake (Might Devilsaur)";
	sound = 3;
};

GTFO.SpellID["137132"] = {
	--desc = "Column of Thunder (Itoka)";
	sound = 3;
};

GTFO.SpellID["137142"] = {
	--desc = "Ring of Thunder (Itoka)";
	sound = 3;
};

GTFO.SpellID["137434"] = {
	--desc = "Frost Shot (Beastmaster Horaki)";
	sound = 3;
};

GTFO.SpellID["126001"] = {
	--desc = "Air Strike (Jack Arrow)";
	sound = 3;
};

GTFO.SpellID["131377"] = {
	--desc = "Crushing Slam (Voress'thalik)";
	sound = 3;
};

GTFO.SpellID["129244"] = {
	--desc = "Bombard";
	sound = 3;
};

GTFO.SpellID["140202"] = {
	--desc = "Body Slam (Animated Warrior)";
	sound = 3;
};

GTFO.SpellID["136964"] = {
	--desc = "Thrown Axe";
	sound = 3;
};

GTFO.SpellID["137140"] = {
	--desc = "Spirit Slash (Spirit of Warlord Teng)";
	sound = 3;
};

GTFO.SpellID["136439"] = {
	--desc = "Lightning Strike (Shan'ze Electrocutioner)";
	sound = 3;
};

GTFO.SpellID["137300"] = {
	--desc = "Electrical Storm (Shan Bu)";
	sound = 3;
};

GTFO.SpellID["138863"] = {
	--desc = "Shadow Crash (Shan Bu)";
	sound = 3;
};

GTFO.SpellID["139281"] = {
	--desc = "Boulder Impact (Palace Gatekeeper)";
	sound = 3;
};

GTFO.SpellID["140531"] = {
	--desc = "Desist (Hu'seng the Gatekeeper)";
	sound = 3;
};

GTFO.SpellID["136338"] = {
	--desc = "Arc Nova (Nalak)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["138826"] = {
	--desc = "Lightning Strike (Forgemaster Vul'kon)";
	sound = 3;
};

GTFO.SpellID["138832"] = {
	--desc = "Lightning Smash (Forgemaster Vul'kon)";
	sound = 3;
};

GTFO.SpellID["139351"] = {
	--desc = "Shadow Crash (Sha Amalgamation)";
	sound = 3;
};

GTFO.SpellID["139375"] = {
	--desc = "Shadow Burst (Sha Amalgamation)";
	sound = 3;
};

GTFO.SpellID["138512"] = {
	--desc = "Volt Fissure (Sparkmancer Vu)";
	sound = 3;
};

GTFO.SpellID["142327"] = {
	--desc = "Crackling Fury (Wavebinder Se'sha)";
	sound = 3;
	damageMinimum = 300000;
};

GTFO.SpellID["142385"] = {
	--desc = "Dark Twister (Wavebinder Se'sha)";
	sound = 3;
};

GTFO.SpellID["142346"] = {
	--desc = "Unstable Magma Totem (Jessina the Blazing)";
	sound = 3;
};

GTFO.SpellID["142108"] = {
	--desc = "Titanic Thunderclap (Commander Ag'troz)";
	sound = 3;
};

GTFO.SpellID["141487"] = {
	--desc = "Mortar Rocket (Kor'kron Mortar)";
	sound = 3;
};

GTFO.SpellID["142146"] = {
	--desc = "Rocket Swarm (Speegle Blasttorch)";
	sound = 3;
};

GTFO.SpellID["136844"] = {
	--desc = "Mighty Crash (God-Hulk Gulkan)";
	sound = 3;
	specificMobs = { 
		70400, -- God-Hulk Gulkan
	};	
};

GTFO.SpellID["138632"] = {
	--desc = "Deadly Kick (Slavemaster Shiaxu)";
	sound = 3;
};

GTFO.SpellID["141512"] = {
	--desc = "Reign of Fire (Wrathion)";
	sound = 3;
};

GTFO.SpellID["141653"] = {
	--desc = "Crumbling Arc (Wrathion)";
	sound = 3;
};

GTFO.SpellID["142387"] = {
	--desc = "Molten Arc (Vision of Deathwing)";
	sound = 3;
};

GTFO.SpellID["144530"] = {
	--desc = "Jadefire Breath (Yu'lon)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["144539"] = {
	--desc = "Jadefire Wall (Yu'lon)";
	sound = 3;
};

-- TODO: Spectral Swipe (Xuen) - non-tank fail, multiple stack fail?
-- TODO: Chi Barrage (Xuen) - avoidable?

GTFO.SpellID["144609"] = {
	--desc = "Charge (Niuzao)";
	sound = 3;
};

GTFO.SpellID["147674"] = {
	--desc = "Cracking Blow (Ordon Deathguard)";
	sound = 3;
};

GTFO.SpellID["148000"] = {
	--desc = "Fire Storm (Blazebound Chanter)";
	sound = 3;
};

GTFO.SpellID["147866"] = {
	--desc = "Steam Vent";
	sound = 3;
};

GTFO.SpellID["147448"] = {
	--desc = "Spiritflame Strike (Foreboding Flame)";
	sound = 3;
};

GTFO.SpellID["147878"] = {
	--desc = "Molten Inferno (Molten Guardian)";
	sound = 3;
};

GTFO.SpellID["147881"] = {
	--desc = "Molten Inferno (Molten Guardian)";
	sound = 3;
};

GTFO.SpellID["147310"] = {
	--desc = "Gust of Wind (Brilliant Windfeather)";
	sound = 3;
};

GTFO.SpellID["147386"] = {
	--desc = "Ox Charge (Ironfur Great Bull)";
	sound = 3;
};

GTFO.SpellID["144690"] = {
	--desc = "Burning Soul (Ordos)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["148003"] = {
	--desc = "Blazing Blow (Eternal Kilnmaster)";
	sound = 3;
};

GTFO.SpellID["147422"] = {
	--desc = "Burning Sacrifice (Ordon Candlekeeper)";
	sound = 3;
};

GTFO.SpellID["147961"] = {
	--desc = "Devour (Evermaw)";
	sound = 3;
};

GTFO.SpellID["147702"] = {
	--desc = "Blazing Cleave (Burning Berserker)";
	sound = 3;
};

GTFO.SpellID["147724"] = {
	--desc = "Watcher Osu (Falling Flames)";
	sound = 3;
};

GTFO.SpellID["147512"] = {
	--desc = "Stomp (Eroded Cliffdweller)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["147544"] = {
	--desc = "Stomp (Golganarr)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["147517"] = {
	--desc = "Boulder (Eroded Cliffdweller)";
	sound = 3;
};

GTFO.SpellID["147646"] = {
	--desc = "Rending Swipe (Crag Stalker)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["147599"] = {
	--desc = "Depth Charge (Cursed Hozen Swabby)";
	sound = 3;
};

GTFO.SpellID["147599"] = {
	--desc = "Depth Charge (Cursed Hozen Swabby)";
	sound = 3;
};

GTFO.SpellID["144059"] = {
	--desc = "Spirit Strangle (Timeless Spirit)";
	sound = 3;
};

GTFO.SpellID["138044"] = {
	--desc = "Thunder Crash (Zandalari Warbringer)";
	sound = 3;
};

GTFO.SpellID["132702"] = {
	--desc = "Slipping on Oil";
	sound = 3;
};

GTFO.SpellID["147335"] = {
	--desc = "Furious Splash (Zesqua)";
	sound = 3;
};

end

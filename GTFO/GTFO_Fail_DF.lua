--------------------------------------------------------------------------
-- GTFO_Fail_DF.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Dragonflight
]]--

if (not (GTFO.ClassicMode or GTFO.BurningCrusadeMode or GTFO.WrathMode)) then

--- ************************
--- * Dragon Isles (World) *
--- ************************

GTFO.SpellID["372139"] = {
  --desc = "Lightning Strike (Lightning Storm)";
  sound = 3;
};

GTFO.SpellID["397110"] = {
  --desc = "Crashing Thunder (Air Revenant)";
  sound = 3;
  applicationOnly = true;
};

GTFO.SpellID["390361"] = {
  --desc = "Lightning Crash (Primalist Stormslinger)";
  sound = 3;
  applicationOnly = true;
};

GTFO.SpellID["369928"] = {
	--desc = "Collapsing Boulder";
	sound = 3;
};

GTFO.SpellID["369107"] = {
	--desc = "Golem Smash (Ancient Construct)";
	applicationOnly = true;
	sound = 3;
};

GTFO.SpellID["376982"] = {
	--desc = "Unstable Explosion (Volatile Remnant)";
	sound = 3;
};

GTFO.SpellID["370072"] = {
	--desc = "Frozen Breath (Lapisagos)";
	applicationOnly = true;
	sound = 3;
};

GTFO.SpellID["381362"] = {
	--desc = "Earthspike (Tazenrath)";
	sound = 3;
};

GTFO.SpellID["390327"] = {
  --desc = "Frigid Geysers (Glacial Ice Lord)";
  sound = 3;
};

GTFO.SpellID["390431"] = {
  --desc = "Hail Decimation (Glacial Ice Lord)";
  sound = 3;
};

GTFO.SpellID["374401"] = {
  --desc = "Frozen Solid (Glacial Ice Lord)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["378397"] = {
  --desc = "Slam (Primal Earth Elemental)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["307315"] = {
  --desc = "Recovering";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393836"] = {
  --desc = "Smothering Seashell (Sogglmoggl)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393819"] = {
  --desc = "Gusting Vortex (Whirglgurgl)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393998"] = {
  --desc = "Circuit Crash (Discordant Watcher)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393910"] = {
  --desc = "Titanic Fragmentation (Discordant Watcher)";
  sound = 3;
};

GTFO.SpellID["387683"] = {
  --desc = "Snow Crash (Frozen Revenant)";
  sound = 3;
};

GTFO.SpellID["396423"] = {
  --desc = "Crashing Thunder (Galestrike Proto-Dragon)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["386700"] = {
  --desc = "Crashing Ice (Winter Conqueror)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["370056"] = {
  --desc = "Magma Gout (Olphis the Molten)";
  sound = 3;
};

GTFO.SpellID["394464"] = {
  --desc = "Burning Roar (Piercer Gigra)";
  sound = 3;
};

GTFO.SpellID["393747"] = {
  --desc = "Searing Hammer (Champion Choruk)";
  sound = 3;
};

GTFO.SpellID["395854"] = {
  --desc = "Stonefall (Qalashi Stonebinder)";
  sound = 3;
};

GTFO.SpellID["393478"] = {
  --desc = "Bulldoze (Penumbrus)";
  sound = 3;
};

GTFO.SpellID["394616"] = {
  --desc = "Erupting Lava (Captain Lancer)";
  sound = 3;
};

GTFO.SpellID["395201"] = {
  --desc = "Supernova (Blazing Proto-Dragon)";
  sound = 3;
};

GTFO.SpellID["374029"] = {
  --desc = "Pounce (Skaara)";
  sound = 3;
};

GTFO.SpellID["393148"] = {
  --desc = "Mud Eruption (Maneet)";
  sound = 3;
};

GTFO.SpellID["393209"] = {
  --desc = "Mud Eruption - Projectile (Maneet)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["387012"] = {
  --desc = "Corrosive Spew (Nightrot)";
  applicationOnly = true;
  sound = 1;
};

GTFO.SpellID["393384"] = {
  --desc = "Entangling Roots (Nightrot)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393522"] = {
  --desc = "Heated Stomp (Ceeqa the Peacetaker)";
  sound = 3;
};

GTFO.SpellID["369232"] = {
  --desc = "Demoralizing Howl (Ceeqa the Peacetaker)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393753"] = {
  --desc = "Languid Bloom (Taresh)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393598"] = {
  --desc = "Storm Wing (Gethrel the South Wind)";
  sound = 3;
};

GTFO.SpellID["393596"] = {
  --desc = "Storm Wing (Gethrel the South Wind)";
  sound = 3;
};

GTFO.SpellID["393662"] = {
  --desc = "Lava Breath (Rakkesh of the Flow)";
  sound = 3;
};

GTFO.SpellID["393601"] = {
  --desc = "Spear of the Mountain (Huntmaster Amaa)";
  sound = 3;
};

GTFO.SpellID["393687"] = {
  --desc = "Mountainous Rupture (Huntmaster Amaa)";
  sound = 3;
};

GTFO.SpellID["396344"] = {
  --desc = "Thundering Stomp (Warmonger Kharad)";
  sound = 3;
};

GTFO.SpellID["393087"] = {
  --desc = "Stormcall (Koroleth)";
  sound = 3;
};

GTFO.SpellID["391346"] = {
  --desc = "The Boulder (Honmor)";
  sound = 3;
};

GTFO.SpellID["391326"] = {
  --desc = "Seismic Volley (Honmor)";
  applicationOnly = true;
  tankSound = 2;
  sound = 3;
};

GTFO.SpellID["376752"] = {
  --desc = "Drake Blast (Fire)";
  sound = 3;
};

GTFO.SpellID["391454"] = {
  --desc = "Drake Blast (Nature)";
  sound = 3;
};

GTFO.SpellID["391424"] = {
  --desc = "Drake Blast (Frost)";
  sound = 3;
};

GTFO.SpellID["371610"] = {
  --desc = "Arcane Detonation";
  sound = 3;
};

GTFO.SpellID["372560"] = {
  --desc = "Poison Trap (Shadepaw Hunter)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["393867"] = {
  --desc = "Tooth Trap (Trap-Layer Kerwal)";
  sound = 3;
};

GTFO.SpellID["372529"] = {
  --desc = "Hideous Laughter (Shadepaw Thief)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["396078"] = {
  --desc = "Explosive Blast (Summoned Destroyer)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["372728"] = {
  --desc = "Lava Burst";
  sound = 3;
};

GTFO.SpellID["378793"] = {
  --desc = "Storm Strike (Lightning Strike)";
  sound = 3;
};

GTFO.SpellID["389534"] = {
  --desc = "Fire Stomp (Korthrox the Destroyer)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["391855"] = {
  --desc = "Magma Blast (Korthrox the Destroyer)";
  sound = 3;
};

GTFO.SpellID["394903"] = {
  --desc = "Burning Slam (Lookout Mordren)";
  sound = 3;
};

GTFO.SpellID["396836"] = {
  --desc = "Glacial Destruction (Colossal Glacier)";
  sound = 3;
};

GTFO.SpellID["387762"] = {
  --desc = "Murglrn Flame";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["376472"] = {
  --desc = "Overhead Smash (Qalashi Skirmisher)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["391295"] = {
  --desc = "Slipped";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["372310"] = {
  --desc = "Glacier Crush (Jadzigeth)";
  sound = 3;
};

GTFO.SpellID["387718"] = {
  --desc = "This Is Gonna Hurt (Therazane)";
  sound = 3;
};

GTFO.SpellID["396360"] = {
  --desc = "Blinding Slash (Tarasek Marauder)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["384261"] = {
  --desc = "Arcane Detonation (Arcane Elemental)";
  sound = 3;
};

--- *******************
--- * Ruby Life Pools *
--- *******************

GTFO.SpellID["372696"] = {
  --desc = "Excavating Blast (Primal Juggernaut)";
  sound = 3;
};

GTFO.SpellID["373458"] = {
  --desc = "Stone Missile (Primal Terrasentry)";
  sound = 3;
};

GTFO.SpellID["385292"] = {
  --desc = "Molten Steel (Defier Draghar)";
  sound = 3;
};

GTFO.SpellID["372796"] = {
  --desc = "Blazing Rush (Defier Draghar)";
  applicationOnly = true;
  sound = 3;
  tankSound = 0; -- TODO: Is this avoidable by the tank?
};

GTFO.SpellID["384024"] = {
  --desc = "Hailbombs (Melidrussa Chillworn)";
  sound = 3;
};

GTFO.SpellID["373614"] = {
  --desc = "Burnout (Blazebound Destroyer)";
  sound = 3;
};

GTFO.SpellID["373977"] = {
  --desc = "Blaze of Glory (Primalist Flamedancer)";
  sound = 3;
};

GTFO.SpellID["372863"] = {
  --desc = "Ritual of Blazebinding (Kokia Blazehoof)";
  sound = 3;
};

GTFO.SpellID["372811"] = {
  --desc = "Molten Boulder (Kokia Blazehoof)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["373087"] = {
  --desc = "Burnout (Blazebound Firestorm)";
  sound = 3;
};

GTFO.SpellID["392399"] = {
  --desc = "Crackling Detonation (Primal Thundercloud)";
  sound = 3;
};

GTFO.SpellID["391967"] = {
  --desc = "Electrical Overload (The Raging Tempest)";
  sound = 3;
};

GTFO.SpellID["391353"] = {
  --desc = "Plowed";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["391301"] = {
  --desc = "Wind Barrage (Boolk)";
  sound = 3;
};

GTFO.SpellID["391308"] = {
  --desc = "Rending Swoop (Boolk)";
  sound = 3;
};

GTFO.SpellID["390834"] = {
  --desc = "Primal Rend (Sarana)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["390778"] = {
  --desc = "Mammoth Charge (Blitztusk)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["390766"] = {
  --desc = "Mammoth Crush (Blitztusk)";
  applicationOnly = true;
  sound = 3;
};

--- ************************
--- * The Nokhud Offensive *
--- ************************

GTFO.SpellID["384479"] = {
  --desc = "Rain of Arrows (Nokhud Longbow)";
  sound = 3;
};

GTFO.SpellID["385916"] = {
  --desc = "Tectonic Stomp (Granyth)";
  sound = 3;
};

GTFO.SpellID["384882"] = {
  --desc = "Stormsurge Lightning (Stormsurge Totem)";
  sound = 3;
  test = true;
};

GTFO.SpellID["386694"] = {
  --desc = "Stormsurge (Stormsurge Totem)";
  sound = 3;
};

GTFO.SpellID["386920"] = {
  --desc = "Raging Lightning (The Raging Tempest)";
  sound = 3;
};

GTFO.SpellID["384186"] = {
  --desc = "Lightning Strike (The Raging Tempest)";
  soundFunction = function() -- Warn only if you get hit more than once
	if (GTFO_FindEvent("LSRagingTemp")) then
		return 3;
	end
	GTFO_AddEvent("LSRagingTemp", 3);
	return 0;
  end
};

GTFO.SpellID["387629"] = {
  --desc = "Rotting Wind (Desecrated Ohuna)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["396376"] = {
  --desc = "Chant of the Dead (Ukhel Deathspeaker)";
  sound = 3;
};

GTFO.SpellID["387611"] = {
  --desc = "Necrotic Eruption (Ukhel Corruptor)";
  sound = 3;
};

GTFO.SpellID["386037"] = {
  --desc = "Gale Arrow (Teera)";
  sound = 3;
};

GTFO.SpellID["386063"] = {
  --desc = "Frightful Roar (Maruuk)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["385193"] = {
  --desc = "Earthsplitter (Maruuk)";
  sound = 3;
};

GTFO.SpellID["388451"] = {
  --desc = "Stormcaller's Fury";
  sound = 3;
};

GTFO.SpellID["384336"] = {
  --desc = "War Stomp (Nokhud Defender)";
  sound = 3;
};

GTFO.SpellID["374711"] = {
  --desc = "Ravaging Spear (Balara)";
  sound = 3;
};

GTFO.SpellID["382233"] = {
  --desc = "Broad Stomp (Batak)";
  sound = 3;
};

GTFO.SpellID["376660"] = {
  --desc = "Iron Spear (Balakar Khan)";
  sound = 4;
  test = true;
};

GTFO.SpellID["376737"] = {
  --desc = "Lightning (Balakar Khan)";
  sound = 3;
};

--- **********************
--- * Brackenhide Hollow *
--- **********************

GTFO.SpellID["368297"] = {
  --desc = "Toxic Trap (Bonebolt Hunter)";
  sound = 3;
};

GTFO.SpellID["385303"] = {
  --desc = "Teeth Trap";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["385524"] = {
  --desc = "Sentry Fire (Rotbow Sentry)";
  sound = 3;
};

GTFO.SpellID["385356"] = {
  --desc = "Ensnaring Trap (Gutshot)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["385185"] = {
  --desc = "Disoriented (Stinkbreath)";
  applicationOnly = true;
  sound = 3;
  tankSound = 0; -- Is this avoidable by the tank?
};

GTFO.SpellID["385805"] = {
  --desc = "Violent Whirlwind (Stinkbreath)";
  sound = 3;
};

GTFO.SpellID["377559"] = {
  --desc = "Vine Whip (Treemouth)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["381770"] = {
  --desc = "Gushing Ooze (Decaying Slime)";
  sound = 3;
};

GTFO.SpellID["383392"] = {
  --desc = "Rotting Surge (Filth Caller)";
  sound = 3;
};

GTFO.SpellID["373943"] = {
  --desc = "Stomp (Wilted Oak)";
  applicationOnly = true;
  sound = 3;
};

--- *********************
--- * Halls of Infusion *
--- *********************

GTFO.SpellID["374075"] = {
  --desc = "Seismic Slam (Primalist Geomancer)";
  sound = 3;
};

GTFO.SpellID["384524"] = {
  --desc = "Titanic Fist (Watcher Irideus)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["389446"] = {
  --desc = "Nullifying Pulse (Nullification Device)";
  sound = 3;
};

GTFO.SpellID["383935"] = {
  --desc = "Spark Volley (Watcher Irideus)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["375215"] = {
  --desc = "Cave In (Curious Swoglet)";
  sound = 3;
};

GTFO.SpellID["374563"] = {
  --desc = "Dazzle (Dazzling Dragonfly)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["374741"] = {
  --desc = "Magma Crush (Flamecaller Aymi)";
  sound = 3;
};

GTFO.SpellID["375384"] = {
  --desc = "Rumbling Earth (Primalist Earthshaker)";
  sound = 3;
  test = true; -- Avoidable by tank?
};

GTFO.SpellID["386295"] = {
  --desc = "Avalanche (Khajin the Unyielding)";
  sound = 3;
};

GTFO.SpellID["386562"] = {
  --desc = "Glacial Surge (Khajin the Unyielding)";
  sound = 3;
};

GTFO.SpellID["386757"] = {
  --desc = "Hailstorm (Khajin the Unyielding)";
  sound = 3;
};

GTFO.SpellID["390118"] = {
  --desc = "Frost Cyclone (Khajin the Unyielding)";
  sound = 3;
};

GTFO.SpellID["383204"] = {
  --desc = "Crashing Tsunami (Infuser Sariya)";
  sound = 3;
};

GTFO.SpellID["390290"] = {
  --desc = "Flash Flood (Infuser Sariya)";
  sound = 3;
};

GTFO.SpellID["387474"] = {
  --desc = "Infused Globule (Primal Tsunami)";
  sound = 3;
};

GTFO.SpellID["387359"] = {
  --desc = "Waterlogged (Primal Tsunami)";
  applicationOnly = true;
  sound = 3;
};

--- *********************
--- * Algeth'ar Academy *
--- *********************

GTFO.SpellID["388868"] = {
  --desc = "Mana Void (Corrupted Manafiend)";
  negatingDebuffSpellID = 388866; -- Mana Void debuff
  negatingIgnoreTime = 6;
  sound = 4;
};

GTFO.SpellID["388884"] = {
  --desc = "Arcane Rain (Spellbound Scepter)";
  sound = 3;
};

GTFO.SpellID["385958"] = {
  --desc = "Arcane Expulsion (Vexamus)";
  sound = 3;
  tankSound = 0; -- Avoidable by tank?
};

GTFO.SpellID["378011"] = {
  --desc = "Deadly Winds (Guardian Sentry)";
  sound = 3;
};

GTFO.SpellID["377516"] = {
  --desc = "Dive Bomb (Territorial Eagle)";
  sound = 3;
};

GTFO.SpellID["377524"] = {
  --desc = "Dive Bomb (Alpha Eagle)";
  sound = 3;
};

GTFO.SpellID["377383"] = {
  --desc = "Gust (Alpha Eagle)";
  sound = 3;
};

GTFO.SpellID["376449"] = {
  --desc = "Firestorm (Goal of the Searing Blaze)";
  sound = 3;
};

GTFO.SpellID["377009"] = {
	--desc = "Deafening Screech (Crawth)";
	soundFunction = function() -- Warn only if you get hit more than once within 2 seconds
		if (GTFO_FindEvent("AADeafeningScreech")) then
			return 3;
		end
		GTFO_AddEvent("AADeafeningScreech", 2);
		return 0;
	end
};

GTFO.SpellID["377034"] = {
  --desc = "Overpowering Gust (Crawth)";
  sound = 3;
};

GTFO.SpellID["393122"] = {
  --desc = "Roving Cyclone (Crawth)";
  sound = 3;
};

GTFO.SpellID["390918"] = {
  --desc = "Seed Detonation (Vile Lasher)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["388799"] = {
  --desc = "Germinate (Overgrown Ancient)";
  sound = 3;
};

GTFO.SpellID["374352"] = {
  --desc = "Energy Bomb (Echo of Doragosa)";
  sound = 3;
};

GTFO.SpellID["388822"] = {
  --desc = "Power Vacuum (Echo of Doragosa)";
  sound = 3;
};

GTFO.SpellID["374361"] = {
  --desc = "Astral Breath (Echo of Doragosa)";
  sound = 3;
};

GTFO.SpellID["388996"] = {
  --desc = "Energy Eruption (Echo of Doragosa)";
  sound = 3;
};

GTFO.SpellID["377912"] = {
  --desc = "Expel Intruders (Guardian Sentry)";
  sound = 3;
};

--- *************
--- * Neltharus *
--- *************

GTFO.SpellID["376186"] = {
	--desc = "Eruptive Crush - First wave (Overseer Lahar)";
	sound = 3;
};

GTFO.SpellID["383928"] = {
	--desc = "Eruptive Crush - Second wave (Overseer Lahar)";
	sound = 3;
};

GTFO.SpellID["372542"] = {
	--desc = "Scorching Fusillade";
	soundFunction = function() -- Warn only if you get hit more than once within 2 seconds
		if (GTFO_FindEvent("ScorchingFusillade")) then
			return 3;
		end
		GTFO_AddEvent("ScorchingFusillade", 2);
		return 0;
	end
};

GTFO.SpellID["372293"] = {
	--desc = "Conflagrant Battery (Irontorch Commander)";
	sound = 3;
};

GTFO.SpellID["375241"] = {
	--desc = "Forgestorm (Forgemaster Gorek)";
	sound = 3;
};

GTFO.SpellID["375071"] = {
	--desc = "Magma Lob (Magmatusk)";
	sound = 3;
};

GTFO.SpellID["375449"] = {
	--desc = "Blazing Charge (Magmatusk)";
	sound = 3;
};

GTFO.SpellID["382708"] = {
	--desc = "Volcanic Guard (Qalashi Warden)";
	sound = 3;
};

GTFO.SpellID["377204"] = {
	--desc = "The Dragon's Kiln (Warlord Sargha)";
	sound = 3;
	tankSound = 2;
	test = true; -- Tank avoidable?
};

GTFO.SpellID["395427"] = {
  --desc = "Burning Roar (Overseer Lahar)";
  sound = 3;
};

GTFO.SpellID["373540"] = {
  --desc = "Binding Spear (Qalashi Hunter)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["375397"] = {
  --desc = "Lava Splash (Chargath, Bane of Scales)";
  sound = 3;
};

GTFO.SpellID["375061"] = {
  --desc = "Blazing Eruption (Forgemaster Gorek)";
  sound = 3;
};

GTFO.SpellID["374397"] = {
  --desc = "Heated Swings (Forgemaster Gorek)";
  sound = 3;
};

GTFO.SpellID["378831"] = {
  --desc = "Explosive Concoction (Qalashi Plunderer)";
  sound = 3;
};

GTFO.SpellID["377477"] = {
  --desc = "Burning Ember (Warlord Sargha)";
  sound = 3;
};

GTFO.SpellID["391773"] = {
  --desc = "The Dragon's Eruption (Dragon's Eruption)";
  sound = 3;
};

--- *******************
--- * The Azure Vault *
--- *******************

GTFO.SpellID["370766"] = {
  --desc = "Crystalline Rupture (Crystal Thrasher)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["375591"] = {
  --desc = "Sappy Burst (Bubbling Sapling)";
  sound = 3;
};

GTFO.SpellID["386660"] = {
  --desc = "Erupting Fissure (Leymor)";
  sound = 3;
};

GTFO.SpellID["386368"] = {
  --desc = "Polymorphed (Polymorphic Rune)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["371352"] = {
  --desc = "Forbidden Knowledge (Unstable Curator)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["387067"] = {
  --desc = "Arcane Bash (Arcane Construct)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["374868"] = {
  --desc = "Unstable Power (Astral Attendant)";
  sound = 3;
};

GTFO.SpellID["372222"] = {
  --desc = "Arcane Cleave (Azureblade)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["385579"] = {
  --desc = "Ancient Orb (Azureblade)";
  sound = 3;
};

GTFO.SpellID["390462"] = {
  --desc = "Ancient Orb Fragment (Azureblade)";
  sound = 3;
};

GTFO.SpellID["389855"] = {
  --desc = "Unstable Magic (Azureblade)";
  sound = 3;
};

GTFO.SpellID["386536"] = {
  --desc = "Null Stomp (Nullmagic Hornswog)";
  sound = 3;
};

GTFO.SpellID["396722"] = {
  --desc = "Absolute Zero (Telash Greywing)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["386910"] = {
  --desc = "Frost Bomb (Telash Greywing)";
  soundFunction = function() -- Warn only if you get hit more than once
	if (GTFO_FindEvent("AVFrostBomb")) then
		return 3;
	end
	GTFO_AddEvent("AVFrostBomb", 3);
	return 0;
  end
};

GTFO.SpellID["384699"] = {
  --desc = "Crystalline Roar (Umbrelskul)";
  sound = 3;
};

GTFO.SpellID["385078"] = {
  --desc = "Arcane Eruption (Umbrelskul)";
  sound = 3;
};

--- **************************
--- * Uldaman: Legacy of Tyr *
--- **************************

GTFO.SpellID["369563"] = {
  --desc = "Wild Cleave (Baelog)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["375286"] = {
  --desc = "Searing Cannonfire (Longboat Raid)";
  sound = 3;
  applicationOnly = true;
};

GTFO.SpellID["369811"] = {
  --desc = "Brutal Slam (Hulking Berserker)";
  sound = 3;
};

GTFO.SpellID["369854"] = {
  --desc = "Throw Rock (Burly Rock-Thrower)";
  sound = 3;
};

GTFO.SpellID["369703"] = {
  --desc = "Thundering Slam (Bromach)";
  sound = 3;
};

GTFO.SpellID["372652"] = {
  --desc = "Resonating Orb (Sentinel Talondras)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["369052"] = {
  --desc = "Seeking Flame (Vault Keeper)";
  sound = 3;
};

GTFO.SpellID["369061"] = {
  --desc = "Searing Clap (Emberon)";
  sound = 3;
  tankSound = 0;
};

GTFO.SpellID["369029"] = {
  --desc = "Heat Engine (Emberon)";
  sound = 3;
};

GTFO.SpellID["369116"] = {
  --desc = "Unstable Embers (Emberon)";
  soundFunction = function() -- Warn only if you get hit more than once
	if (GTFO_FindEvent("UnstableEmbers")) then
		return 3;
	end
	GTFO_AddEvent("UnstableEmbers", 3);
	return 0;
  end
};

GTFO.SpellID["375727"] = {
  --desc = "Sand Breath (Chrono-Lord Deios)";
  sound = 3;
  tankSound = 0;
};


--- ***************************
--- * Vault of the Incarnates *
--- ***************************

end


--------------------------------------------------------------------------
-- GTFO_Spells_DF.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Dragonflight
]]--

if (not (GTFO.ClassicMode or GTFO.BurningCrusadeMode or GTFO.WrathMode)) then

--- ************************
--- * Dragon Isles (World) *
--- ************************

GTFO.SpellID["362970"] = {
	--desc = "Electified Water";
	sound = 2;
};

GTFO.SpellID["376052"] = {
	--desc = "Aura of the Tempest (Avatar of the Storm)";
	sound = 1;
};

GTFO.SpellID["376069"] = {
	--desc = "Smite of the Tempest (Avatar of the Storm)";
	sound = 1;
};

GTFO.SpellID["390326"] = {
  --desc = "Frigid Glaze (Glacial Ice Lord)";
  sound = 1;
};

GTFO.SpellID["372339"] = {
  --desc = "Lava";
  sound = 1;
};

GTFO.SpellID["393577"] = {
  --desc = "Path of Fire (Champion Choruk)";
  sound = 1;
};

GTFO.SpellID["382753"] = {
  --desc = "In Their Sights";
  applicationOnly = true;
  soundFunction = function() 
	local stacks = GTFO_DebuffStackCount("player", 382753);
	if (stacks > 6) then
		return 1;
	else
		return 2;
	end
  end;
};

GTFO.SpellID["393707"] = {
  --desc = "Lava Breath (Rakkesh of the Flow)";
  sound = 1;
};

GTFO.SpellID["374873"] = {
  --desc = "Lightning Rod (Nokhud Marauder)";
  sound = 1;
};

GTFO.SpellID["372839"] = {
  --desc = "Lightning Rod (Nokhud Marauder)";
  sound = 1;
};

GTFO.SpellID["392953"] = {
  --desc = "Reaping Flame (Korthrox the Destroyer)";
  sound = 1;
};

GTFO.SpellID["393043"] = {
  --desc = "Unstable Sands (Colossal Causality)";
  sound = 1;
};

GTFO.SpellID["373643"] = {
  --desc = "Primal Lava Conduit (Primalist Lava Conduit)";
  sound = 2;
};

GTFO.SpellID["393528"] = {
  --desc = "Magma Fist (Ceeqa the Peacetaker)";
  sound = 1;
};

GTFO.SpellID["370042"] = {
  --desc = "Lava Pool (Primal Lava Elemental)";
  sound = 1;
};

GTFO.SpellID["388759"] = {
  --desc = "Blazing Trail (Cobalt Assembly)";
  sound = 1;
};

--- *******************
--- * Ruby Life Pools *
--- *******************

GTFO.SpellID["372697"] = {
  --desc = "Jagged Earth (Primal Juggernaut)";
  sound = 1;
};

GTFO.SpellID["372963"] = {
  --desc = "Chillstorm (Melidrussa Chillworn)";
  applicationOnly = true;
  sound = 1;
};

GTFO.SpellID["397077"] = {
  --desc = "Chillstorm (Melidrussa Chillworn)";
  sound = 1;
  affirmingDebuffSpellID = 372963; -- Chillstorm inner circle
};

GTFO.SpellID["374927"] = {
  --desc = "Wall of Flames (Kokia Blazehoof)";
  sound = 1;
};

GTFO.SpellID["392452"] = {
  --desc = "Flashfire (Flame Channeler)";
  sound = 4;
  negatingDebuffSpellID = 392451; -- Flashfire debuff
  negatingIgnoreTime = 2;
};

GTFO.SpellID["384773"] = {
  --desc = "Flaming Embers (Kyrakka)";
  sound = 1;
};

GTFO.SpellID["381526"] = {
  --desc = "Roaring Firebreath (Kyrakka)";
  sound = 1;
};

GTFO.SpellID["391727"] = {
  --desc = "Storm Breath (Thunderhead)";
  sound = 1;
};

GTFO.SpellID["391724"] = {
  --desc = "Flame Breath (Flamegullet)";
  sound = 1;
};

GTFO.SpellID["373973"] = {
  --desc = "Blaze of Glory (Primalist Flamedancer)";
  sound = 1;
};

GTFO.SpellID["372820"] = {
  --desc = "Scorched Earth (Kokia Blazehoof)";
  sound = 1;
};

--- ************************
--- * The Nokhud Offensive *
--- ************************

GTFO.SpellID["386912"] = {
  --desc = "Stormsurge Cloud (Stormsurge Totem)";
  sound = 1;
};

GTFO.SpellID["395680"] = {
  --desc = "Ritual of Desecration (Gravelord Monkh)";
  sound = 1;
};

GTFO.SpellID["388104"] = {
  --desc = "Ritual of Desecration (Gravelord Monkh)";
  sound = 1;
};

GTFO.SpellID["384512"] = {
  --desc = "Cleaving Strikes (Nokhud Defender)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["386916"] = {
  --desc = "The Raging Tempest (The Raging Tempest)";
  sound = 1;
};

GTFO.SpellID["395669"] = {
  --desc = "Aftershock (Maruuk)";
  sound = 1;
};

--- **********************
--- * Brackenhide Hollow *
--- **********************

GTFO.SpellID["382556"] = {
  --desc = "Ragestorm (Bracken Warscourge)";
  sound = 2;
  soundHeroic = 1;
  soundMythic = 1;
  SoundChallenge = 1;
  tankSound = 2;
  soundHeroic = 2;
  soundMythic = 2;
  tankSoundChallenge = 1; -- Probably hurts a lot on M+, need to confirm next season
};

GTFO.SpellID["368299"] = {
  --desc = "Toxic Trap - Pool (Bonebolt Hunter)";
  sound = 1;
};

GTFO.SpellID["377807"] = {
  --desc = "Cleave (Rira Hackclaw)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["377830"] = {
  --desc = "Bladestorm (Rira Hackclaw)";
  sound = 1;
  test = true; -- Need more info about this one
};

GTFO.SpellID["374245"] = {
  --desc = "Rotting Creek";
  sound = 1;
};

GTFO.SpellID["383399"] = {
  --desc = "Rotting Surge (Treemouth)";
  sound = 1;
};

GTFO.SpellID["379425"] = {
  --desc = "Decaying Fog (Decatriarch Wratheye)";
  sound = 1;
};

GTFO.SpellID["376170"] = {
  --desc = "Choking Rotcloud - Pool (Decatriarch Wratheye)";
  sound = 1;
};

GTFO.SpellID["376149"] = {
  --desc = "Choking Rotcloud - Initial Blast";
  sound = 1;
};

GTFO.SpellID["372141"] = {
  --desc = "Withering Away! (Wilted Oak)";
  sound = 1;
};

GTFO.SpellID["378054"] = {
  --desc = "Withering Away! (Treemouth)";
  sound = 1;
};


--- *********************
--- * Halls of Infusion *
--- *********************

GTFO.SpellID["393444"] = {
  --desc = "Gushing Wound (Refti Defender)";
  applicationOnly = true;
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["389181"] = {
  --desc = "Power Field (Watcher Irideus)";
  sound = 1;
};

GTFO.SpellID["375080"] = {
  --desc = "Whirling Fury (Squallbringer Cyraz)";
  sound = 1;
};

GTFO.SpellID["375349"] = {
  --desc = "Gusting Breath (Gusting Proto-Dragon)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["375341"] = {
  --desc = "Tectonic Breath (Subterranean Proto-Dragon)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["375353"] = {
  --desc = "Oceanic Breath (Glacial Proto-Dragon)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["385168"] = {
  --desc = "Thunderstorm (Primalist Galesinger)";
  sound = 1;
};

--- *********************
--- * Algeth'ar Academy *
--- *********************

GTFO.SpellID["388957"] = {
  --desc = "Riftbreath (Arcane Ravager)";
  sound = 1;
};

GTFO.SpellID["386201"] = {
  --desc = "Corrupted Mana (Vexamus)";
  sound = 1;
};

GTFO.SpellID["388546"] = {
  --desc = "Arcane Fissure (Vexamus)";
  sound = 1;
  test = true;
};

GTFO.SpellID["387932"] = {
  --desc = "Astral Whirlwind (Algeth'ar Echoknight)";
  applicationOnly = true;
  sound = 1;
};

GTFO.SpellID["389007"] = {
  --desc = "Wild Energy (Echo of Doragosa)";
  applicationOnly = true;
  sound = 1;
};

--- *************
--- * Neltharus *
--- *************

GTFO.SpellID["372372"] = {
	--desc = "Magma Fist (Qalashi Trainee)";
	sound = 1;
};

GTFO.SpellID["372208"] = {
	--desc = "Djaradin Lava";
	sound = 1;
};

GTFO.SpellID["372203"] = {
	--desc = "Scorching Breath (Qalashi Irontorch)";
	sound = 1;
};

GTFO.SpellID["372459"] = {
	--desc = "Burning";
	sound = 1;
};

GTFO.SpellID["375204"] = {
	--desc = "Liquid Hot Magma (Magmatusk)";
	sound = 1;
};

GTFO.SpellID["375535"] = {
  --desc = "Lava Wave (Magmatusk)";
  sound = 1;
};

GTFO.SpellID["377542"] = {
	--desc = "Burning Ground (Warlord Sargha)";
	sound = 1;
};

GTFO.SpellID["373756"] = {
  --desc = "Magma Wave (Chargath, Bane of Scales)";
  sound = 1;
};

GTFO.SpellID["374854"] = {
  --desc = "Erupted Ground (Chargath, Bane of Scales)";
  sound = 1;
};

GTFO.SpellID["381482"] = {
  --desc = "Forgefire (Forgemaster Gorek)";
  sound = 1;
};


--- *******************
--- * The Azure Vault *
--- *******************

GTFO.SpellID["375649"] = {
  --desc = "Infused Ground (Arcane Tender)";
  sound = 1;
};

GTFO.SpellID["371021"] = {
  --desc = "Splintering Shards (Crystal Thrasher)";
  sound = 4;
  negatingDebuffSpellID = 371007; -- Splintering Shards
  test = true; -- Does this work?
};

GTFO.SpellID["374523"] = {
  --desc = "Stinging Sap (Ley-Line Sprout)";
  sound = 1;
};

GTFO.SpellID["391120"] = {
  --desc = "Spellfrost Breath (Scalebane Lieutenant)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["387150"] = {
  --desc = "Frozen Ground (Telash Greywing)";
  sound = 1;
};

GTFO.SpellID["385267"] = {
  --desc = "Crackling Vortex (Umbrelskul)";
  sound = 1;
};

GTFO.SpellID["387152"] = {
  --desc = "Icy Devastator (Telash Greywing)";
  sound = 4;
  negatingDebuffSpellID = 387151; -- Icy Devastator
  negatingIgnoreTime = 4;
};

--- **************************
--- * Uldaman: Legacy of Tyr *
--- **************************

GTFO.SpellID["377825"] = {
  --desc = "Burning Pitch";
  sound = 1;
};

GTFO.SpellID["369610"] = {
  --desc = "Shocking Quake (Quaking Totem)";
  sound = 2;
};

GTFO.SpellID["369337"] = {
  --desc = "Difficult Terrain (Runic Protector)";
  applicationOnly = true;
  sound = 2;
};

GTFO.SpellID["382576"] = {
  --desc = "Scorn of Tyr (Earthen Guardian)";
  sound = 1;
};

GTFO.SpellID["368996"] = {
  --desc = "Purging Flames (Emberon)";
  sound = 1;
};

GTFO.SpellID["376325"] = {
  --desc = "Eternity Zone (Chrono-Lord Deios)";
  sound = 1;
};

--- ***************************
--- * Vault of the Incarnates *
--- ***************************



end

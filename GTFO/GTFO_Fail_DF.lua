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

--- *******************
--- * Ruby Life Pools *
--- *******************


--- ************************
--- * The Nokhud Offensive *
--- ************************

--- **********************
--- * Brackenhide Hollow *
--- **********************

--- *********************
--- * Halls of Infusion *
--- *********************

--- *********************
--- * Algeth'ar Academy *
--- *********************

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
	sound = 3;
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
	test = true; -- Avoidable by tank or targetted player?
};

GTFO.SpellID["382708"] = {
	--desc = "Volcanic Guard (Qalashi Warden)";
	sound = 3;
};

GTFO.SpellID["377204"] = {
	--desc = "The Dragon's Kiln (Warlord Sargha)";
	sound = 3;
	test = true; -- Tank avoidable?
};


--- *******************
--- * The Azure Vault *
--- *******************

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

GTFO.SpellID["375727"] = {
  --desc = "Sand Breath (Chrono-Lord Deios)";
  sound = 3;
  tankSound = 0;
};


--- ***************************
--- * Vault of the Incarnates *
--- ***************************

end


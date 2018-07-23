--------------------------------------------------------------------------
-- GTFO_Fail_Classic.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Classic
Author: Zensunim of Malygos
]]--

GTFO.SpellID["20476"] = {
	--desc = "Explosion (Baron Geddon, Molten Core)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["95495"] = {
	--desc = "Cannonball (Defias Cannon - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88177"] = {
	--desc = "Frost Blossom (Glubtok - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88173"] = {
	--desc = "Fire Blossom (Glubtok - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88321"] = {
	--desc = "Explode (Helix Gearbreaker - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88490"] = {
	--desc = "Reaper Strike (Foe Reaper 5000 - Deadmines)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 40;
};

GTFO.SpellID["88521"] = {
	--desc = "Harvest Sweep (Foe Reaper 5000 - Deadmines)";
	sound = 3;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["92552"] = {
	--desc = "Detonation (Dark Iron Land Mine - Gnomeregan)";
	sound = 3;
	trivialLevel = 45;
};

GTFO.SpellID["9435"] = {
	--desc = "Detonation (Arcanist Doan - Scarlet Monastery)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 45;
};

GTFO.SpellID["19272"] = {
	--desc = "Lava Breath (Magmadar - Molten Core)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["19272"] = {
	--desc = "Flame Breath (Gyth - Blackrock Spire)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["19272"] = {
	--desc = "Acid Breath (Drakes - Sunken Temple)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 65;
	applicationOnly = true;
};

GTFO.SpellID["79728"] = {
	--desc = "Explosion (Nethergarde Miner, BL)";
	sound = 3;
	trivialLevel = 60;
};

GTFO.SpellID["25656"] = {
	--desc = "Sand Trap (Kurinnaxx, AQ10)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["168338"] = {
	--desc = "Artillery Blast";
	sound = 3;
};

GTFO.SpellID["248320"] = {
  --desc = "Lethargy (Ysondre)";
  applicationOnly = true;
  sound = 3;
};

GTFO.SpellID["243401"] = {
  --desc = "Noxious Breath (Ysondre)";
  soundFunction = function() -- Fail for non-tanks, fail for tanks after more than 1 stack
		if (GTFO.TankMode) then
			local stacks = GTFO_DebuffStackCount("player", 243401); 
			if (stacks > 1) then
				return 3;
			end
			return 0;
		else
			return 3;
		end
	end
};

GTFO.SpellID["243411"] = {
  --desc = "Tail Sweep (Ysondre)";
  sound = 3;
};

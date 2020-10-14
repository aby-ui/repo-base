--------------------------------------------------------------------------
-- GTFO_Spells_SL.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Shadowlands
]]--

if (not GTFO.ClassicMode) then

--- ***********************
--- * Shadowlands (World) *
--- ***********************

--- **********************
--- * Halls of Atonement *
--- **********************

GTFO.SpellID["323001"] = {
  --desc = "Glass Shards (Halkias)";
  sound = 1;
};

GTFO.SpellID["324044"] = {
  --desc = "Refracted Sinlight (Halkias)";
  sound = 1;
};

GTFO.SpellID["319703"] = {
  --desc = "Blood Torrent (Echelon)";
  sound = 1;
};

GTFO.SpellID["323853"] = {
  --desc = "Pulse from Beyond (Ghastly Parishioner) -- Area damage version";
  sound = 0;
};

GTFO.SpellID["326891"] = {
  --desc = "Anguish (Inquisitor Sigar)";
  sound = 1;
};

--- **************
--- * Plaguefall *
--- **************

GTFO.SpellID["330069"] = {
  --desc = "Concentrated Plague";
  applicationOnly = true;
  soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 330069);
		if (stacks >= 3) then
			return 1;
		elseif (stacks > 1) then
			return 2;
		end
		return 0;
	end;
};

GTFO.SpellID["327552"] = {
  --desc = "Doom Shroom (Doom Shroom) - AOE Explosion - Unavoidable";
  sound = 0;
};

GTFO.SpellID["330513"] = {
  --desc = "Doom Shroom (Doom Shroom)";
  sound = 1;
};

GTFO.SpellID["320072"] = {
  --desc = "Toxic Pool (Decaying Flesh Giant)";
  sound = 1;
};

GTFO.SpellID["319120"] = {
  --desc = "Putrid Bile (Gushing Slime)";
  sound = 1;
};

GTFO.SpellID["330135"] = {
  --desc = "Fount of Pestilence (Margrave Stradama)";
  applicationOnly = true;
  sound = 1;
};

--- *******************
--- * Sanguine Depths *
--- *******************

GTFO.SpellID["334676"] = {
  --desc = "Sanctified Mists";
  sound = 1;
};

GTFO.SpellID["323573"] = {
  --desc = "Residue (Fleeting Manifestation)";
  sound = 1;
};

--- ***********************
--- * Spires of Ascension *
--- ***********************

GTFO.SpellID["324662"] = {
  --desc = "Charged Spear (Kin-Tara)";
  sound = 1;
};

GTFO.SpellID["317626"] = {
  --desc = "Maw-Touched Venom";
  sound = 1;
};

GTFO.SpellID["323739"] = {
  --desc = "Residual Impact (Forsworn Squad-Leader)";
  sound = 1;
};

GTFO.SpellID["323792"] = {
  --desc = "Volatile Anima";
  sound = 1;
};

GTFO.SpellID["339080"] = {
  --desc = "Surging Anima";
  sound = 1;
};

--- *************************
--- * Mists of Tirna Scithe *
--- *************************

GTFO.SpellID["325027"] = {
  --desc = "Bramble Burst (Drust Boughbreaker)";
  sound = 1;
};

GTFO.SpellID["323250"] = {
  --desc = "Anima Puddle (Droman Oulfarran)";
  sound = 1;
};

GTFO.SpellID["331721"] = {
  --desc = "Spear Flurry";
  sound = 1;
};

GTFO.SpellID["326017"] = {
  --desc = "Decomposing Acid (Spinemaw Larva)";
  sound = 1;
};

GTFO.SpellID["326309"] = {
  --desc = "Decomposing Acid (Tred'ova)";
  sound = 1;
};

--- *******************
--- * Theater of Pain *
--- *******************

GTFO.SpellID["320180"] = {
  --desc = "Noxious Spore (Paceran the Virulent)";
  sound = 1;
};


GTFO.SpellID["323130"] = {
  --desc = "Coagulating Ooze (Gorechop)";
  sound = 1;
};

GTFO.SpellID["323681"] = {
  --desc = "Dark Devastation (Mordretha, the Endless Empress)";
  sound = 1;
};

--- *********************
--- * The Necrotic Wake *
--- *********************

GTFO.SpellID["320646"] = {
  --desc = "Fetid Gas (Blightbone)";
  sound = 1;
};

GTFO.SpellID["320573"] = {
  --desc = "Shadow Well";
  sound = 1;
};

GTFO.SpellID["320574"] = {
  --desc = "Shadow Well";
  sound = 1;
};

GTFO.SpellID["327100"] = {
  --desc = "Noxious Fog";
  sound = 1;
};

--- *****************
--- * De Other Side *
--- *****************

GTFO.SpellID["333250"] = {
  --desc = "Reaver (Risen Warlord)";
  sound = 1;
};

GTFO.SpellID["332729"] = {
  --desc = "Malefic Blast (Malefic Spirit)";
  sound = 1;
};

GTFO.SpellID["332332"] = {
  --desc = "Spilled Essence (Son of Hakkar)";
  sound = 1;
};

GTFO.SpellID["332672"] = {
  --desc = "Bladestorm (Atal'ai Deathwalker)";
  sound = 1;
  tankSound = 0;
  test = true;
};



end

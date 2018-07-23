--------------------------------------------------------------------------
-- GTFO_FF_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Friendly Fire List - Mists of Pandaria
Author: Zensunim of Malygos
]]--

-- ***************
-- * Scholomance *
-- ***************

GTFO.FFSpellID["111616"] = {
	--desc = "Ice Wrath (Instructor Chillheart)";
	sound = 1;
	tankSound = 0; -- TODO: Find out if people need to get away from the tank?
	trivialPercent = 0;
};

-- ********************
-- * Mogu'shan Vaults *
-- ********************

GTFO.FFSpellID["116434"] = {
	--desc = "Arcane Resonance (Feng the Accursed)";
	sound = 1;
};

-- ***************************
-- * Gate of the Setting Sun *
-- ***************************

GTFO.FFSpellID["113645"] = {
	--desc = "Sabotage (Saboteur Kip'tilak)";
	sound = 3;
	ignoreSelfInflicted = true;
};

-- ********************
-- * Throne of Thunder *
-- ********************
GTFO.FFSpellID["139321"] = {
	--desc = "Storm Energy (Crazed Storm-Caller)";
	sound = 1;
	soundLFR = 2;
};

GTFO.FFSpellID["137530"] = {
	--desc = "Focused Lightning Conduction (Jin'rokh the Breaker)";
	sound = 3;
};

-- TODO: Biting Cold (Frost King Malakk) (Is the player stunned?  If so, this alert is unnecessary) -- Biting Cold is not FF damage, so not detectable
-- TODO: Frostbite (Frost King Malakk) (Alert when only 1 stack is left)

GTFO.FFSpellID["140621"] = {
	--desc = "Fungi Spores (Fungal Growth)";
	sound = 2;
};

-- **********************
-- * Siege of Orgrimmar *
-- **********************

GTFO.FFSpellID["146818"] = {
	--desc = "Aura of Pride (Sha of Pride)";
	sound = 1;
};

GTFO.FFSpellID["142928"] = {
	--desc = "Displaced Energy (Malkorok)";
	sound = 3;
};

--------------------------------------------------------------------------
-- GTFO_Spells_Classic.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Classic
]]--

if (GTFO.ClassicMode) then

GTFO.SpellID["17742"] = {
	--desc = "Cloud of Disease (Scholomance - Old)";
	sound = 2;
};

GTFO.SpellID["19428"] = {
	--desc = "Conflagration (Magmadar, Molten Core)";
	sound = 1;
	applicationOnly = true;
};

--[[
GTFO.SpellID["19717"] = {
	--desc = "Rain of Fire (Gehennas, Molten Core)";
	sound = 1;
};
]]--

GTFO.SpellID["19698"] = {
	--desc = "Inferno (Baron Geddon, Molten Core)";
	sound = 1;
	tankSound = 2;
};

--[[
GTFO.SpellID["18399"] = {
	--desc = "Flamestrike (Vectus - Scholomance)";
	sound = 2;
	trivialLevel = 80;
};

GTFO.SpellID["8364"] = {
	--desc = "Blizzard (Skeletal Guardian - Stratholme)";
	sound = 2;
	trivialLevel = 60;
};

GTFO.SpellID["12468"] = {
	--desc = "Flamestrike (Jammal'an the Prophet - Sunken Temple)";
	sound = 2;
	trivialLevel = 60;
	specificMobs = { 3975 };
};
]]--

GTFO.SpellID["8814"] = {
	--desc = "Flame Spike (Bloodmage Thalnos - Scarlet Monastery)";
	sound = 2;
};

GTFO.SpellID["21910"] = {
	--desc = "Goblin Dragon Gun (Tinkerer Gizlock - Maraudon)";
	sound = 2;
	tankSound = 0;
};

GTFO.SpellID["10341"] = {
	--desc = "Radiation Cloud (Irradiated Slime - Gnomeregan)";
	sound = 2;
};

GTFO.SpellID["15578"] = {
	--desc = "Poison Shock (Creeping Sludge - Maraudon)";
	sound = 2;
	tankSound = 0;
};

GTFO.SpellID["25989"] = {
	--desc = "Toxin (Viscidus)";
	sound = 2;
};

GTFO.SpellID["17086"] = {
	--desc = "Breath (Onyxia)";
	sound = 1;
};

end

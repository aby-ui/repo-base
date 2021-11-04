--------------------------------------------------------------------------
-- GTFO_Spells_Vanilla.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Vanilla
]]--

if (not GTFO.ClassicMode) then

GTFO.SpellID["21070"] = {
  --desc = "Noxious Cloud (Noxious Slime - Maraudon)";
  applicationOnly = true;
  sound = 2;
  trivialLevel = 60;
};

GTFO.SpellID["17742"] = {
	--desc = "Cloud of Disease (Scholomance - Old)";
	sound = 2;
	trivialLevel = 70;
};

GTFO.SpellID["19428"] = {
	--desc = "Conflagration (Magmadar, Molten Core)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["19717"] = {
	--desc = "Rain of Fire (Gehennas, Molten Core)";
	sound = 2;
};

GTFO.SpellID["19698"] = {
	--desc = "Inferno (Baron Geddon, Molten Core)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["10363"] = {
	--desc = "Conflagration (General Drakkisath, UBRS)";
	sound = 4;
	ignoreSelfInflicted = true;
	trivialLevel = 70;
};

GTFO.SpellID["86633"] = {
	--desc = "Rain of Fire (Lord Overheat - Stockades)";
	sound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["88484"] = {
	--desc = "Overdrive (Foe Reaper 5000 - Deadmines)";
	sound = 1;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["88501"] = {
	--desc = "Harvest (Foe Reaper 5000 - Deadmines)";
	sound = 1;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["89735"] = {
	--desc = "Rotten Aura ("Captain" Cookie - Deadmines)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["81285"] = {
	--desc = "Cloud of Disease (Diseased Ghoul - Scholomance)";
	sound = 1;
	trivialLevel = 60;
};

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

GTFO.SpellID["93691"] = {
	--desc = "Desecration (Commander Springvale - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["93535"] = {
	--desc = "Ice Shards (Lord Walden - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["93564"] = {
	--desc = "Pistol Barrage (Lord Godfrey - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["8814"] = {
	--desc = "Flame Spike (Bloodmage Thalnos - Scarlet Monastery)";
	sound = 2;
	trivialLevel = 45;
};

GTFO.SpellID["21910"] = {
	--desc = "Goblin Dragon Gun (Tinkerer Gizlock - Maraudon)";
	sound = 2;
	tankSound = 0;
	trivialLevel = 60;
};

GTFO.SpellID["10341"] = {
	--desc = "Radiation Cloud (Irradiated Slime - Gnomeregan)";
	sound = 2;
	trivialLevel = 45;
};

GTFO.SpellID["15578"] = {
	--desc = "Poison Shock (Creeping Sludge - Maraudon)";
	sound = 2;
	tankSound = 0;
	trivialLevel = 50;
};

GTFO.SpellID["12468"] = {
	--desc = "Flamestrike (Jammal'an the Prophet - Sunken Temple)";
	sound = 2;
	trivialLevel = 60;
	specificMobs = { 3975 };
};

GTFO.SpellID["89529"] = {
	--desc = "Sea Cyclone (Sea Cyclone - Thousand Needles)";
	sound = 2;
	trivialLevel = 50;
};

GTFO.SpellID["83019"] = {
	--desc = "Toxic Waste (Death's Step Miscreation - Eastern Plaguelands)";
	sound = 2;
	trivialLevel = 50;
};

GTFO.SpellID["25989"] = {
	--desc = "Toxin (Viscidus)";
	sound = 2;
	trivialLevel = 61;
};

GTFO.SpellID["176369"] = {
	--desc = "Lava Barrage (Ironmarch Scorcher)";
	sound = 1;
};

GTFO.SpellID["176338"] = {
	--desc = "Lava Blast (Ironmarch Scorcher)";
	sound = 1;
};

GTFO.SpellID["150549"] = {
  --desc = "Crushing Singularity (Voidwalker Minion)";
  sound = 1;
  trivialLevel = 70;
};

GTFO.SpellID["149894"] = {
  --desc = "Maw of Death (Domina)";
  sound = 1;
  trivialLevel = 70;
};

GTFO.SpellID["152592"] = {
  --desc = "Executioner's Strike (Executioner Gore)";
  sound = 1;
  trivialLevel = 70;
};

GTFO.SpellID["151268"] = {
  --desc = "Toxic Bile (Aku'mai the Venomous)";
  sound = 1;
  trivialLevel = 70;
};

end

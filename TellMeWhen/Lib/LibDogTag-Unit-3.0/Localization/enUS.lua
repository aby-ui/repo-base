local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION

_G.DogTag_Unit_funcs = {}

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

DogTag_Unit.L = {
	-- races
	["Blood Elf"] = "Blood Elf",
	["Draenei"] = "Draenei",
	["Dwarf"] = "Dwarf",
	["Gnome"] = "Gnome",
	["Human"] = "Human",
	["Night Elf"] = "Night Elf",
	["Orc"] = "Orc",
	["Tauren"] = "Tauren",
	["Troll"] = "Troll",
	["Undead"] = "Undead",
	["Blood Elf_female"] = "Blood Elf",
	["Draenei_female"] = "Draenei",
	["Dwarf_female"] = "Dwarf",
	["Gnome_female"] = "Gnome",
	["Human_female"] = "Human",
	["Night Elf_female"] = "Night Elf",
	["Orc_female"] = "Orc",
	["Tauren_female"] = "Tauren",
	["Troll_female"] = "Troll",
	["Undead_female"] = "Undead",
	
	-- short races
	["Blood Elf_short"] = "BE",
	["Draenei_short"] = "Dr",
	["Dwarf_short"] = "Dw",
	["Gnome_short"] = "Gn",
	["Human_short"] = "Hu",
	["Night Elf_short"] = "NE",
	["Orc_short"] = "Or",
	["Tauren_short"] = "Ta",
	["Troll_short"] = "Tr",
	["Undead_short"] = "Ud",

	-- classes
	["Death Knight"] = "Death Knight",
	["Warrior"] = "Warrior",
	["Priest"] = "Priest",
	["Mage"] = "Mage",
	["Shaman"] = "Shaman",
	["Paladin"] = "Paladin",
	["Warlock"] = "Warlock",
	["Druid"] = "Druid",
	["Rogue"] = "Rogue",
	["Hunter"] = "Hunter",
	["Death Knight_female"] = "Death Knight",
	["Warrior_female"] = "Warrior",
	["Priest_female"] = "Priest",
	["Mage_female"] = "Mage",
	["Shaman_female"] = "Shaman",
	["Paladin_female"] = "Paladin",
	["Warlock_female"] = "Warlock",
	["Druid_female"] = "Druid",
	["Rogue_female"] = "Rogue",
	["Hunter_female"] = "Hunter",
	
	-- short classes
	["Death Knight_short"] = "DK",
	["Warrior_short"] = "Wr",
	["Priest_short"] = "Pr",
	["Mage_short"] = "Ma",
	["Shaman_short"] = "Sh",
	["Paladin_short"] = "Pa",
	["Warlock_short"] = "Wl",
	["Druid_short"] = "Dr",
	["Rogue_short"] = "Ro",
	["Hunter_short"] = "Hu",

	["Player"] = PLAYER,
	["Target"] = TARGET,
	["Focus-target"] = FOCUS,
	["Mouse-over"] = "Mouse-over",
	["%s's pet"] = "%s's pet",
	["%s's target"] = "%s's target",
	["%s's %s"] = "%s's %s",
	["Party member #%d"] = "Party member #%d",
	["Raid member #%d"] = "Raid member #%d",
	["Boss #%d"] = "Boss #%d",
	["Arena enemy #%d"] = "Arena enemy #%d",

	-- classifications
	["Rare"] = ITEM_QUALITY3_DESC,
	["Rare-Elite"] = ITEM_QUALITY3_DESC and ELITE and ITEM_QUALITY3_DESC .. "-" .. ELITE,
	["Elite"] = ELITE,
	["Boss"] = BOSS,
	-- short classifications
	["Rare_short"] = "r",
	["Rare-Elite_short"] = "r+",
	["Elite_short"] = "+",
	["Boss_short"] = "b",

	["Feigned Death"] = "Feigned Death",
	["Stealthed"] = "Stealthed",
	["Soulstoned"] = "Soulstoned",

	["Dead"] = DEAD,
	["Ghost"] = "Ghost",
	["Offline"] = PLAYER_OFFLINE,
	["Online"] = "Online",
	["Combat"] = "Combat",
	["Resting"] = "Resting",
	["Tapped"] = "Tapped",
	["AFK"] = "AFK",
	["DND"] = "DND",

	["Rage"] = RAGE,
	["Focus"] = FOCUS,
	["Energy"] = ENERGY,
	["Mana"] = MANA,
	["Runic Power"] = RUNIC_POWER,

	["PvP"] = PVP,
	["FFA"] = "FFA",

	-- genders
	["Male"] = MALE,
	["Female"] = FEMALE,

	-- forms
	["Bear"] = "Bear",
	["Cat"] = "Cat",
	["Moonkin"] = "Moonkin",
	["Aquatic"] = "Aquatic",
	["Flight"] = "Flight",
	["Travel"] = "Travel",
	["Tree"] = "Tree",

	["Bear_short"] = "Be",
	["Cat_short"] = "Ca",
	["Moonkin_short"] = "Mk",
	["Aquatic_short"] = "Aq",
	["Flight_short"] = "Fl",
	["Travel_short"] = "Tv",
	["Tree_short"] = "Tr",

	-- shortgenders
	["Male_short"] = "m",
	["Female_short"] = "f",

	["Leader"] = "Leader",
	
	-- dispel types
	["Magic"] = "Magic",
	["Curse"] = "Curse",
	["Poison"] = "Poison",
	["Disease"] = "Disease",
	
	["Vehicle"] = "Vehicle",
}
for k,v in pairs(DogTag_Unit.L) do
	if type(v) ~= "string" then -- some evil addon messed it up
		DogTag_Unit.L[k] = k
	end
end
setmetatable(DogTag_Unit.L, {__index = function(self, key)
--	local _, ret = pcall(error, ("Error indexing L[%q]"):format(tostring(key)), 2)
--	geterrorhandler()(ret)
	self[key] = key
	return key
end})

end
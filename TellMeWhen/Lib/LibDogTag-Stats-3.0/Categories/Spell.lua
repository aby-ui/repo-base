local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 33 $"):match("%d+")) or 0

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "SpellDamage", {
	alias = "[SpellPower]",
	noDoc = true,
})
DogTag:AddTag("Stats", "SpellHealing", {
	alias = "[SpellPower]",
	noDoc = true,
})

DogTag:AddTag("Stats", "SpellPower", {
	code = function(school)
		if not school then
			return min(
				GetSpellBonusDamage(2),
				GetSpellBonusDamage(3),
				GetSpellBonusDamage(4),
				GetSpellBonusDamage(5),
				GetSpellBonusDamage(6),
				GetSpellBonusDamage(7)
			)
		else
			return GetSpellBonusDamage(school)
		end
	end,
	arg = {
		'school', 'number;undef', "@undef",
	},
	ret = "number",
	events = "PLAYER_DAMAGE_DONE_MODS;SPELL_POWER_CHANGED",
	doc = L["Returns your spellpower. School can be blank/nil for the lowest of all schools, 2 for Holy, 3 for Fire, 4 for Nature, 5 for Frost, 6 for Shadow, or 7 for Arcane."],
	example = '[SpellPower] => "8476"',
	category = L["Spell"],
})


DogTag:AddTag("Stats", "SpellCrit", {
	code = function(school)
		return GetSpellCritChance()
	end,
	ret = "number",
	events = "PLAYER_DAMAGE_DONE_MODS;COMBAT_RATING_UPDATE",
	doc = L["Returns your spell crit chance."],
	example = '[SpellCrit:Round(1)] => "41.8"; [SpellCrit:Round(1):Percent] => "41.8%"',
	category = L["Spell"],
})

DogTag:AddTag("Stats", "SpellHaste", {
	alias = "[Haste]",
	noDoc = true,
})


end
local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "ArmorRating", {
	code = function()
		return select(2, UnitArmor("player"))
	end,
	ret = "number",
	events = "UNIT_RESISTANCES#player",
	doc = L["Returns your armor value."],
	example = '[ArmorRating] => "23651"',
	category = L["Defense"],
})

DogTag:AddTag("Stats", "ArmorReduction", {
	code = function(level)
		local base, effectiveArmor = UnitArmor("player");
		if PaperDollFrame_GetArmorReduction then
			-- Supports WoW BFA+
			level = level or UnitLevel("player")
			return PaperDollFrame_GetArmorReduction(effectiveArmor, level);
		else
			-- Supports WoW Classic
			level = level or UnitLevel("player")
			local armorReduction = effectiveArmor/((85 * level) + 400);
			return 100 * (armorReduction/(armorReduction + 1));
		end
	end,
	arg = {
		'level', 'number;undef', "@undef",
	},
	ret = "number",
	events = "UNIT_RESISTANCES#player",
	doc = L["Returns your percentage of damage reduction from armor. Pass in a level as a parameter to calculate damage reduction against that level enemy."],
	example = ('[ArmorReduction:Round(1)] => "35.7"; [ArmorReduction:Round(1):Percent] => "35.7%%"; [ArmorReduction(%d):Round(1):Percent] => "31.1%%"')
		:format(GetMaxPlayerLevel() + 3),
	category = L["Defense"],
})

DogTag:AddTag("Stats", "DodgeChance", {
	code = GetDodgeChance,
	ret = "number",
	-- PLAYER_DAMAGE_DONE_MODS is needed for Elusive Brew, and possibly others.
	events = "COMBAT_RATING_UPDATE;PLAYER_DAMAGE_DONE_MODS",
	doc = L["Returns your dodge chance."],
	example = '[DodgeChance:Round(1)] => "13.2"; [DodgeChance:Round(1):Percent] => "13.2%"',
	category = L["Defense"],
})

DogTag:AddTag("Stats", "ParryChance", {
	code = GetParryChance,
	ret = "number",
	events = "COMBAT_RATING_UPDATE;PLAYER_DAMAGE_DONE_MODS",
	doc = L["Returns your parry chance."],
	example = '[ParryChance:Round(1)] => "13.2"; [ParryChance:Round(1):Percent] => "13.2%"',
	category = L["Defense"],
})

DogTag:AddTag("Stats", "BlockChance", {
	code = GetBlockChance,
	ret = "number",
	events = "COMBAT_RATING_UPDATE;UNIT_RESISTANCES#player;PLAYER_DAMAGE_DONE_MODS",
	doc = L["Returns your block chance."],
	example = '[BlockChance:Round(1)] => "13.2"; [BlockChance:Round(1):Percent] => "13.2%"',
	category = L["Defense"],
})

DogTag:AddTag("Stats", "BlockAmount", {
	code = GetShieldBlock,
	ret = "number",
	events = "COMBAT_RATING_UPDATE;UNIT_RESISTANCES#player",
	doc = L["Returns your block amount percentage."],
	example = '[BlockAmount:Round(1)] => "32.2"; [BlockAmount:Round(1):Percent] => "32.2%"',
	category = L["Defense"],
})



end
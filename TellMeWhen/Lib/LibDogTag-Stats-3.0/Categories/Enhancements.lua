local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 19 $"):match("%d+")) or 0

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


if GetMasteryEffect then
	DogTag:AddTag("Stats", "Mastery", {
		code = GetMasteryEffect,
		ret = "number",
		events = "MASTERY_UPDATE",
		doc = L["Returns your Mastery effect percentage"],
		example = '[Mastery:Round(1)] => "17.2"; [Mastery:Round(1):Percent] => "17.2%"',
		category = L["Enhancements"],
	})
end


DogTag:AddTag("Stats", "Spirit", {
	code = function()
		return UnitStat("player", 5)
	end,
	ret = "number",
	events = "UNIT_STATS#player",
	doc = L["Returns your Spirit"],
	example = '[Spirit] => "1234"',
	category = L["Enhancements"],
})


DogTag:AddTag("Stats", "CriticalStrike", {
	code = GetCritChance,
	ret = "number",
	events = "PLAYER_DAMAGE_DONE_MODS;COMBAT_RATING_UPDATE",
	doc = L["Returns your crit chance"],
	example = '[CriticalStrike:Round(1)] => "23.4"; [CriticalStrike:Round(1):Percent] => "23.4%"',
	category = L["Enhancements"],
})

DogTag:AddTag("Stats", "Haste", {
	code = GetHaste,
	ret = "number",
	events = "UNIT_ATTACK_SPEED#player",
	doc = L["Returns your haste percentage"],
	example = '[Haste:Round(1)] => "32.7"; [Haste:Round(1):Percent] => "32.7%"',
	category = L["Enhancements"],
})


if GetMultistrike then
	DogTag:AddTag("Stats", "Multistrike", {
		code = GetMultistrike,
		ret = "number",
		events = "MULTISTRIKE_UPDATE",
		doc = L["Returns your Multistrike percentage"],
		example = '[Multistrike:Round(1)] => "17.2"; [Multistrike:Round(1):Percent] => "17.2%"',
		category = L["Enhancements"],
	})
end

if GetLifesteal then
	DogTag:AddTag("Stats", "Leech", {
		code = GetLifesteal,
		ret = "number",
		events = "LIFESTEAL_UPDATE",
		doc = L["Returns your Leech percentage"],
		example = '[Leech:Round(1)] => "1.2"; [Leech:Round(1):Percent] => "1.2%"',
		category = L["Enhancements"],
	})

	-- The leech tag was originally called Lifesteel. Make an alias so it still works for people who were using it.
	DogTag:AddTag("Stats", "Lifesteal", {
		alias = "[Leech]",
		noDoc = true,
	})
end

if GetVersatilityBonus then
	DogTag:AddTag("Stats", "Versatility", {
		code = function()
			return GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
		end,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your Versatility damage and healing increase percentage."],
		example = '[Versatility] => "3.6"; [Versatility:Round(1):Percent] => "3.6%"',
		category = L["Enhancements"],
	})
end

if GetAvoidance then
	DogTag:AddTag("Stats", "Avoidance", {
		code = GetAvoidance,
		ret = "number",
		events = "AVOIDANCE_UPDATE",
		doc = L["Returns your Avoidance percentage"],
		example = '[Avoidance:Round(1)] => "2.2"; [Avoidance:Round(1):Percent] => "2.2%"',
		category = L["Enhancements"],
	})
end


end
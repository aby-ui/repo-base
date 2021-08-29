local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L

if COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN then
	DogTag:AddTag("Stats", "ResilienceRating", {
		code = function()
			return GetCombatRating(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
		end,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your resilience rating."],
		example = '[ResilienceRating] => "4235"',
		category = L["PvP"],
	})

	DogTag:AddTag("Stats", "ResilienceReduction", {
		code = function()
			local ratingBonus = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
			return ratingBonus + GetModResilienceDamageReduction()
		end,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your damage reduction percentage from resilience."],
		example = '[ResilienceReduction:Round(1)] => "61.5"; [ResilienceReduction:Round(1):Percent] => "61.5%"',
		category = L["PvP"],
	})
end

if GetPvpPowerDamage and GetPvpPowerHealing then
	DogTag:AddTag("Stats", "PvPPowerDamage", {
		code = GetPvpPowerDamage,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your damage increase percentage from PvP power."],
		example = '[PvPPowerDamage:Round(1)] => "37.9"; [PvPPowerDamage:Round(1):Percent] => "37.9%"',
		category = L["PvP"],
	})
	
	DogTag:AddTag("Stats", "PvPPowerHealing", {
		code = GetPvpPowerHealing,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your healing increase percentage from PvP power."],
		example = '[PvPPowerHealing:Round(1)] => "37.8"; [PvPPowerHealing:Round(1):Percent] => "37.8%"',
		category = L["PvP"],
	})

	DogTag:AddTag("Stats", "PvPPower", {
		alias = [=[Max(PvPPowerDamage, PvPPowerHealing)]=],
		ret = "number",
		doc = L["Returns your damage or healing increase percentage from PvP power (whichever is greater)."],
		example = '[PvPPower:Round(1)] => "37.9"; [PvPPower:Round(1):Percent] => "37.9%"',
		category = L["PvP"],
	})

	DogTag:AddTag("Stats", "PvPPowerRating", {
		code = function()
			return GetCombatRating(CR_PVP_POWER)
		end,
		ret = "number",
		events = "COMBAT_RATING_UPDATE",
		doc = L["Returns your PvP power rating."],
		example = '[PvPPowerRating] => "2354"',
		category = L["PvP"],
	})
end


end
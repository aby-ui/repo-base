local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "AttackPower", {
	code = function()
		local base, pos, neg = UnitAttackPower("player")
		return base + pos + neg
	end,
	ret = "number",
	events = "UNIT_ATTACK_POWER#player",
	doc = L["Returns your Attack Power"],
	example = '[AttackPower] => "21345"',
	category = L["Melee"],
})

DogTag:AddTag("Stats", "MeleeAP", {
	alias = "[AttackPower]",
	noDoc = true,
})

DogTag:AddTag("Stats", "MeleeCrit", {
	alias = "[CriticalStrike]",
	noDoc = true,
})

DogTag:AddTag("Stats", "MeleeHaste", {
	alias = "[Haste]",
	noDoc = true,
})


end
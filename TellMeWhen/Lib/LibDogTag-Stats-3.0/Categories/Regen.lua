local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "ManaRegen", {
	code = GetManaRegen,
	ret = "number",
	events = "Update",
	doc = L["Returns your out-of-combat mana regen (mana per second)."],
	example = '[ManaRegen] => "421"; [ManaRegen * 5] => "2105"',
	category = L["Regen"],
})

DogTag:AddTag("Stats", "CombatManaRegen", {
	code = function()
		return select(2, GetManaRegen())
	end,
	ret = "number",
	events = "UNIT_STATS#player;Update",
	doc = L["Returns your in-combat mana regen (mana per second)."],
	example = '[CombatManaRegen] => "123"; [CombatManaRegen * 5] => "615"',
	category = L["Regen"],
})

DogTag:AddTag("Stats", "PowerRegen", {
	code = GetPowerRegen,
	ret = "number",
	events = "UNIT_RANGEDDAMAGE#player;UNIT_ATTACK_SPEED#player;Update",
	doc = L["Returns your energy regeneration or focus regeneration rate (per second)."],
	example = '[PowerRegen:Round(1)] => "4.9"',
	category = L["Regen"],
})


end
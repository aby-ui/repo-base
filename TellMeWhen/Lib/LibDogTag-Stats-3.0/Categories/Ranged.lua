local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "RangedAP", {
	alias = "[AttackPower]",
	noDoc = true,
})

DogTag:AddTag("Stats", "RangedCrit", {
	alias = "[CriticalStrike]",
	noDoc = true,
})

DogTag:AddTag("Stats", "RangedHaste", {
	alias = "[Haste]",
	noDoc = true,
})



end
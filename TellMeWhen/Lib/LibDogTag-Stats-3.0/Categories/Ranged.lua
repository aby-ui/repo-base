local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 28 $"):match("%d+")) or 0

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
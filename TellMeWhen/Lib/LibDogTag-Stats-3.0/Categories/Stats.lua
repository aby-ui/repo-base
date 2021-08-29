local MAJOR_VERSION = "LibDogTag-Stats-3.0"
local MINOR_VERSION = tonumber(("20210821035043"):match("%d+")) or 33333333333333

if MINOR_VERSION > _G.DogTag_Stats_MINOR_VERSION then
	_G.DogTag_Stats_MINOR_VERSION = MINOR_VERSION
end

DogTag_Stats_funcs[#DogTag_Stats_funcs+1] = function(DogTag_Stats, DogTag)

local L = DogTag_Stats.L


DogTag:AddTag("Stats", "Strength", {
	code = function()
		return UnitStat("player", 1)
	end,
	ret = "number",
	events = "UNIT_STATS#player",
	doc = L["Returns your Strength"],
	example = '[Strength] => "1234"',
	category = L["Stats"],
})

DogTag:AddTag("Stats", "Agility", {
	code = function()
		return UnitStat("player", 2)
	end,
	ret = "number",
	events = "UNIT_STATS#player",
	doc = L["Returns your Agility"],
	example = '[Agility] => "1234"',
	category = L["Stats"],
})

DogTag:AddTag("Stats", "Stamina", {
	code = function()
		return UnitStat("player", 3)
	end,
	ret = "number",
	events = "UNIT_STATS#player",
	doc = L["Returns your Stamina"],
	example = '[Stamina] => "1234"',
	category = L["Stats"],
})

DogTag:AddTag("Stats", "Intellect", {
	code = function()
		return UnitStat("player", 4)
	end,
	ret = "number",
	events = "UNIT_STATS#player",
	doc = L["Returns your Intellect"],
	example = '[Intellect] => "1234"',
	category = L["Stats"],
})


DogTag:AddTag("Stats", "CurrentSpeed", {
	code = function()
		return floor(GetUnitSpeed("player") / BASE_MOVEMENT_SPEED * 100 + 0.5)
	end,
	ret = "number",
	events = "Update;UNIT_AURA#player",
	doc = L["Returns your current movement speed. If you are not moving, this value is 0."],
	example = '[CurrentSpeed] => "100"; [CurrentSpeed:Percent] => "100%"',
	category = L["Stats"],
})

DogTag:AddTag("Stats", "GroundSpeed", {
	code = function()
		local _, groundSpeed = GetUnitSpeed("player")
		return floor(groundSpeed / BASE_MOVEMENT_SPEED * 100 + 0.5)
	end,
	ret = "number",
	events = "Update;UNIT_AURA#player",
	doc = L["Returns your maximum ground movement speed. This will reflect any movement speed debuffs."],
	example = '[GroundSpeed] => "50"; [GroundSpeed:Percent] => "50%"',
	category = L["Stats"],
})


end
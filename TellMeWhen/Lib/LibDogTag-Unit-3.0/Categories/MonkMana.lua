local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Revision: 225 $"):match("%d+")) or 0

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, select = _G, select
local UnitClass, UnitPowerMax, UnitPower = 
	  UnitClass, UnitPowerMax, UnitPower

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local isMonk = select(2, UnitClass("player")) == "MONK"

local function MonkMP_func(unit)
	return nil
end
local MaxMonkMP_func = MonkMP_func

if isMonk then
	function MonkMP_func(unit)
		if unit == "player" then
			return UnitPower(unit,0)
		end
	end
	function MaxMonkMP_func(unit)
		if unit == "player" then
			return UnitPowerMax(unit,0)
		end
	end
end

local mpEvents = "MonkMana;UNIT_POWER_UPDATE#$unit;UNIT_MAXPOWER#$unit"

DogTag:AddTag("Unit", "MonkMP", {
	code = function(args)
		return MonkMP_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = mpEvents,
	doc = L["Return the current mana of unit if unit is you and you are a monk"],
	example = ('[MonkMP] => "%d"'):format(UnitPowerMax("player",0)*.632),
	category = L["Monk"],
})

DogTag:AddTag("Unit", "MaxMonkMP", {
	code = function(args)
		return MaxMonkMP_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = mpEvents,
	doc = L["Return the maximum mana of unit if unit is you and you are a monk"],
	example = ('[MaxMonkMP] => "%d"'):format(UnitPowerMax("player",0)),
	category = L["Monk"],
})

DogTag:AddTag("Unit", "PercentMonkMP", {
	alias = "[MonkMP(unit=unit) / MaxMonkMP(unit=unit) * 100]:Round(1)",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the percentage mana of unit if unit is you and you are a monk"],
	example = '[PercentMonkMP] => "63.2"; [PercentMonkMP:Percent] => "63.2%"',
	category = L["Monk"],
})

DogTag:AddTag("Unit", "MissingMonkMP", {
	alias = "MaxMonkMP(unit=unit) - MonkMP(unit=unit)",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the missing mana of unit if unit is you and you are a monk"],
	example = ('[MissingMonkMP] => "%d"'):format(UnitPowerMax("player",0)*.368),
	category = L["Monk"]
})

DogTag:AddTag("Unit", "FractionalMonkMP", {
	alias = "Concatenate(MonkMP(unit=unit), '/', MaxMonkMP(unit=unit))",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the current and maximum mana of unit if unit is you and you are a monk"],
	example = ('[FractionalMonkMP] => "%d/%d"'):format(UnitPowerMax("player",0)*.632, UnitPowerMax("player",0)),
	category = L["Monk"]
})

DogTag:AddTag("Unit", "IsMaxMonkMP", {
	alias = "Boolean(MonkMP(unit=unit) = MaxMonkMP(unit=unit))",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if at max mana, unit is you, and you are a monk"],
	example = ('[IsMaxMonkMP] => %q; [IsMaxMonkMP] => ""'):format(L["True"]),
	category = L["Monk"]
})

end

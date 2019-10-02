local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, select = _G, select
local UnitClass, UnitPowerMax, UnitPower = 
	  UnitClass, UnitPowerMax, UnitPower

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local isDruid = select(2, UnitClass("player")) == "DRUID"

local function DruidMP_func(unit)
	return nil
end
local MaxDruidMP_func = DruidMP_func

if isDruid then
	function DruidMP_func(unit)
		if unit == "player" then
			return UnitPower(unit,0)
		end
	end
	function MaxDruidMP_func(unit)
		if unit == "player" then
			return UnitPowerMax(unit,0)
		end
	end
end

local mpEvents = "DruidMana;UNIT_POWER_UPDATE#$unit;UNIT_MAXPOWER#$unit"

DogTag:AddTag("Unit", "DruidMP", {
	code = function(args)
		return DruidMP_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = mpEvents,
	doc = L["Return the current mana of unit if unit is you and you are a druid"],
	example = ('[DruidMP] => "%d"'):format(UnitPowerMax("player",0)*.632),
	category = L["Druid"],
})

DogTag:AddTag("Unit", "MaxDruidMP", {
	code = function(args)
		return MaxDruidMP_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = mpEvents,
	doc = L["Return the maximum mana of unit if unit is you and you are a druid"],
	example = ('[MaxDruidMP] => "%d"'):format(UnitPowerMax("player",0)),
	category = L["Druid"],
})

DogTag:AddTag("Unit", "PercentDruidMP", {
	alias = "[DruidMP(unit=unit) / MaxDruidMP(unit=unit) * 100]:Round(1)",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the percentage mana of unit if unit is you and you are a druid"],
	example = '[PercentDruidMP] => "63.2"; [PercentDruidMP:Percent] => "63.2%"',
	category = L["Druid"],
})

DogTag:AddTag("Unit", "MissingDruidMP", {
	alias = "MaxDruidMP(unit=unit) - DruidMP(unit=unit)",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the missing mana of unit if unit is you and you are a druid"],
	example = ('[MissingDruidMP] => "%d"'):format(UnitPowerMax("player",0)*.368),
	category = L["Druid"]
})

DogTag:AddTag("Unit", "FractionalDruidMP", {
	alias = "Concatenate(DruidMP(unit=unit), '/', MaxDruidMP(unit=unit))",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the current and maximum mana of unit if unit is you and you are a druid"],
	example = ('[FractionalDruidMP] => "%d/%d"'):format(UnitPowerMax("player",0)*.632, UnitPowerMax("player",0)),
	category = L["Druid"]
})

DogTag:AddTag("Unit", "IsMaxDruidMP", {
	alias = "Boolean(DruidMP(unit=unit) = MaxDruidMP(unit=unit))",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if at max mana, unit is you, and you are a druid"],
	example = ('[IsMaxDruidMP] => %q; [IsMaxDruidMP] => ""'):format(L["True"]),
	category = L["Druid"]
})

end

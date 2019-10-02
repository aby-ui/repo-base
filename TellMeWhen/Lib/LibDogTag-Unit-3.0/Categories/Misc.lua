local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G = _G
local GetComboPoints, GetPetTimeRemaining, UnitHasVehicleUI, UnitPower =
	  GetComboPoints, GetPetTimeRemaining, UnitHasVehicleUI, UnitPower

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L
local wow_ver = select(4, GetBuildInfo())
local wow_600 = wow_ver >= 60000
local wow_700 = wow_ver >= 70000

DogTag:AddTag("Unit", "Combos", {
	code = function (unit, target)
		if unit and target then
			if wow_600 then
				return UnitPower(unit, 4)
			else
				return GetComboPoints(unit, target)
			end
		else
			if wow_600 then
				return UnitPower((UnitHasVehicleUI and UnitHasVehicleUI("player")) and "vehicle" or "player", 4)
			else
				return GetComboPoints((UnitHasVehicleUI and UnitHasVehicleUI("player")) and "vehicle" or "player", "target")
			end
		end
	end,
	arg = {
		'unit', 'string;undef', '@undef',
		'target', 'string;undef', '@undef'
	},
	ret = "number",
	events = wow_700 and "UNIT_POWER_FREQUENT#$unit" or "UNIT_COMBO_POINTS",
	doc = L["Return the number of combo points you have"],
	example = '[Combos] => "5"; [Combos("pet"))] => "5"; [Combos("vehicle", "target"))] => "5"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Unit", "ComboSymbols", {
	alias = [=[symbol:Repeat(Combos)]=],
	arg = {
		'symbol', 'string', '@'
	},
	doc = L["Return @ or argument repeated by the number of combo points you have"],
	example = '[ComboSymbols] => "@@@@@"; [ComboSymbols(X)] => "XXX"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Unit", "PetRemainingTime", {
	code = function()
		local t = GetPetTimeRemaining()
		if t then
			return t/1000
		end
		return nil
	end,
	events = "Update",
	ret = "number;nil",
	doc = L["Return the time until the pet disappears"],
	example = '[PetRemainingTime] => "10.135123"',
	category = L["Miscellaneous"],
})
end

local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G = _G
local UnitXP, UnitXPMax, GetPetExperience, GetXPExhaustion = 
	  UnitXP, UnitXPMax, GetPetExperience, GetXPExhaustion

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

DogTag:AddEventHandler("Unit", "UNIT_PET_EXPERIENCE", function(event, ...)
	DogTag:FireEvent("UpdateExperience", "pet")
	DogTag:FireEvent("UpdateExperience", "playerpet")
end)

DogTag:AddEventHandler("Unit", "PLAYER_XP_UPDATE", function(event, ...)
	DogTag:FireEvent("UpdateExperience", "player")
end)

DogTag:AddTag("Unit", "XP", {
	code = function(unit)
		if unit == "player" then
		 	return UnitXP(unit)
		elseif unit == "pet" or unit == "playerpet" then
			return GetPetExperience()
		else
			return 0
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "UpdateExperience#$unit",
	doc = L["Return the current experience of unit"],
	example = '[XP] => "8540"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "MaxXP", {
	code = function(unit)
		if unit == "player" then
		 	return UnitXPMax(unit)
		elseif unit == "pet" or unit == "playerpet" then
			local _, max = GetPetExperience()
			return max
		else
			return 0
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "UpdateExperience#$unit",
	doc = L["Return the current experience of unit"],
	example = '[MaxXP] => "10000"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "FractionalXP", {
	alias = [[XP(unit=unit) "/" MaxXP(unit=unit)]],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the current and maximum experience of unit"],
	example = '[FractionalXP] => "8540/10000"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "PercentXP", {
	alias = [[(XP(unit=unit) / MaxXP(unit=unit) * 100):Round(1)]],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the percentage experience of unit"],
	example = '[PercentXP] => "85.4"; [PercentXP:Percent] => "85.4%"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "MissingXP", {
	alias = [[MaxXP(unit=unit) - XP(unit=unit)]],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the missing experience of unit"],
	example = '[MissingXP] => "1460"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "RestXP", {
	code = function(unit)
		if unit == "player" then
		 	return GetXPExhaustion() or 0
		else
			return 0
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "UpdateExperience#$unit",
	doc = L["Return the accumulated rest experience of unit"],
	example = '[RestXP] => "5000"',
	category = L["Experience"]
})

DogTag:AddTag("Unit", "PercentRestXP", {
	alias = [[(RestXP(unit=unit) / MaxXP(unit=unit) * 100):Round(1)]],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the percentage accumulated rest experience of unit"],
	example = '[PercentRestXP] => "50"; [PercentRestXP:Percent] => "50%"',
	category = L["Experience"]
})

end
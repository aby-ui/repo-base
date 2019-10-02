local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, unpack = _G, unpack
local UnitHealth, UnitHealthMax, UnitIsGhost, UnitGetTotalAbsorbs = 
	  UnitHealth, UnitHealthMax, UnitIsGhost, UnitGetTotalAbsorbs

-- Support for new UnitGetTotalAbsorbs functionality
local wow_502 = select(4, GetBuildInfo()) >= 50200

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

DogTag:AddTag("Unit", "HP", {
	code = function(unit)
		local hp = UnitHealth(unit)
		if hp == 1 and UnitIsGhost(unit) then
			return 0
		end
		return hp
	end,
	arg = {
		'unit', 'string;undef', 'player',
		'known', 'boolean', false,
	},
	ret = 'number',
	events = "UNIT_HEALTH#$unit;UNIT_MAXHEALTH#$unit",
	doc = L["Return the current health of unit"],
	example = ('[HP] => "%d"'):format(UnitHealthMax("player")*.758),
	category = L["Health"],
})

DogTag:AddTag("Unit", "MaxHP", {
	code = function(unit)
		return UnitHealthMax(unit)
	end,
	arg = {
		'unit', 'string;undef', 'player',
		'known', 'boolean', false,
	},
	ret = 'number',
	events = "UNIT_HEALTH#$unit;UNIT_MAXHEALTH#$unit",
	doc = L["Return the maximum health of unit"],
	example = ('[MaxHP] => "%d"'):format(UnitHealthMax("player")),
	category = L["Health"],
})

DogTag:AddTag("Unit", "PercentHP", {
	alias = [=[[HP(unit=unit) / MaxHP(unit=unit) * 100]:Round(1)]=],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the percentage health of unit"],
	example = '[PercentHP] => "75.8"; [PercentHP:Percent] => "75.8%"',
	category = L["Health"],
})

DogTag:AddTag("Unit", "MissingHP", {
	alias = [=[MaxHP(unit=unit) - HP(unit=unit)]=],
	arg = {
		'unit', 'string;undef', 'player',
		'known', 'boolean', false,
	},
	ret = "number",
	doc = L["Return the missing health of unit"],
	example = ('[MissingHP] => "%d"'):format(UnitHealthMax("player")*.242),
	category = L["Health"]
})

DogTag:AddTag("Unit", "FractionalHP", {
	alias = [=[Concatenate(HP(unit=unit), "/", MaxHP(unit=unit))]=],
	arg = {
		'unit', 'string;undef', 'player',
		'known', 'boolean', false,
	},
	ret = "string",
	doc = L["Return the current health and maximum health of unit"],
	example = ('[FractionalHP] => "%d/%d"'):format(UnitHealthMax("player")*.758, UnitHealthMax("player")),
	category = L["Health"]
})

DogTag:AddTag("Unit", "IsMaxHP", {
	alias = [=[Boolean(HP(unit=unit) = MaxHP(unit=unit))]=],
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if unit is at full health"],
	example = ('[IsMaxHP] => %q; [IsMaxHP] => ""'):format(L["True"]),
	category = L["Health"]
})

if wow_502 then
	DogTag:AddTag("Unit", "TotalAbsorb", {
		code = UnitGetTotalAbsorbs,
		arg = {
			'unit', 'string;undef', 'player',
		},
		ret = 'number',
		events = "UNIT_ABSORB_AMOUNT_CHANGED#$unit",
		doc = L["Return the total amount of damage the unit can take without losing health"],
		example = ('[TotalAbsorb] => "%d"'):format(UnitHealthMax("player")*.258),
		category = L["Health"],
	})
end

DogTag:AddTag("Unit", "IncomingHeal", {
	code = function(unit)
		return UnitGetIncomingHeals(unit) or 0
	end,
	arg = {
		'unit', 'string;undef', 'player',
	},
	ret = 'number',
	events = "UNIT_HEAL_PREDICTION#$unit",
	doc = L["Return the estimated total amount of healing pending on the unit, such as incomplete casts"],
	example = ('[IncomingHeal] => "%d"'):format(UnitHealthMax("player")*.258),
	category = L["Health"],
})

DogTag:AddTag("Unit", "HPColor", {
	code = function(value, unit)
		local perc = UnitHealth(unit) / UnitHealthMax(unit)
		local r1, g1, b1
		local r2, g2, b2
		if perc <= 0.5 then
			perc = perc * 2
			r1, g1, b1 = unpack(DogTag.__colors.minHP)
			r2, g2, b2 = unpack(DogTag.__colors.midHP)
		else
			perc = perc * 2 - 1
			r1, g1, b1 = unpack(DogTag.__colors.midHP)
			r2, g2, b2 = unpack(DogTag.__colors.maxHP)
		end
		local r, g, b = r1 + (r2 - r1)*perc, g1 + (g2 - g1)*perc, b1 + (b2 - b1)*perc
		if r < 0 then
			r = 0
		elseif r > 1 then
			r = 1
		end
		if g < 0 then
			g = 0
		elseif g > 1 then
			g = 1
		end
		if b < 0 then
			b = 0
		elseif b > 1 then
			b = 1
		end
		if value then
			return ("|cff%02x%02x%02x%s|r"):format(r*255, g*255, b*255, value)
		else
			return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
		end
	end,
	arg = {
		'value', 'string;undef', "@undef",
		'unit', 'string;undef', 'player'
	},
	ret = "string",
	events = "UNIT_HEALTH#$unit;UNIT_MAXHEALTH#$unit",
	doc = L["Return the color or wrap value with the health color of unit"],
	example = '["Hello":HPColor] => "|cffff7f00Hello|r"; [HPColor "Hello"] => "|cffff7f00Hello"',
	category = L["Health"]
})

end

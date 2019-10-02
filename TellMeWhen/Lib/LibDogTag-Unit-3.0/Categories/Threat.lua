local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, select = _G, select
local UnitIsFriend, UnitExists, UnitDetailedThreatSituation, GetThreatStatusColor = 
	  UnitIsFriend, UnitExists, UnitDetailedThreatSituation, GetThreatStatusColor

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

-- Unfortunatelly there is no way to determine the pair mob/unit who's threat changed,
-- so we just fire Threat event for now to update all tags.

-- Fired when mob's threat list changed
DogTag:AddEventHandler( "Unit", "UNIT_THREAT_LIST_UPDATE", function( event, mobId )
	DogTag:FireEvent( "Threat" )
end )

-- Fired when unit's threat situation changed, not on raw threat value changes
DogTag:AddEventHandler( "Unit", "UNIT_THREAT_SITUATION_UPDATE", function( event, unitId )
	DogTag:FireEvent( "Threat" )
end )

DogTag:AddTag( "Unit", "IsTanking", {
	code = function( unit )
		if UnitIsFriend( "player", unit ) then
			if UnitExists( "target" ) then
				return select( 1, UnitDetailedThreatSituation( "player", unit ) ) and true or false
			else
				return false
			end
		else
			return select( 1, UnitDetailedThreatSituation( "player", unit ) ) and true or false
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "nil;number",
	events = "Threat",
	doc = L["Return True if you are the primary tank of the enemy unit or if friendly unit is the primary tank of your target."],
	example = ('[IsTanking] => %q; [IsTanking] => ""'):format(L["True"]),
	category = L["Threat"]
})

DogTag:AddTag( "Unit", "ThreatStatus", {
	code = function( unit )
		if UnitIsFriend( "player", unit ) then
			if UnitExists( "target" ) then
				return select( 2, UnitDetailedThreatSituation( unit, "target" ) )
			else
				return 0
			end
		else
			return select( 2, UnitDetailedThreatSituation( "player", unit ) )
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "nil;number",
	events = "Threat",
	doc = L["Return your threat status for enemy unit or threat status of friendly unit for your target as integer number (3 = securely tanking, 2 = insecurely tanking, 1 = not tanking but higher threat than tank, 0 = not tanking and lower threat than tank)."],
	example = '[ThreatStatus] => "2"; [ThreatStatus] => ""',
	category = L["Threat"]
})

DogTag:AddTag( "Unit", "ThreatStatusColor", {
	code = function( value, status )
		local r, g, b = GetThreatStatusColor( status )
		
		if r then
			if value then
				return ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, value)
			else
				return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
			end
		else
			return value
		end
	end,
	arg = {
		'value', 'string;undef', '@undef',
		'status', 'number;undef', '@req'
	},
	ret = "string;nil",
	doc = L["Return the color or wrap value with the color associated with provided threat status."],
	example = '["100%":ThreatStatusColor( 1 )] => "|cffff0000100%|r"; [ThreatStatusColor( "50%", 0 )] => "|cffffffff50%"',
	category = L["Threat"]
})

DogTag:AddTag( "Unit", "UnitThreatStatusColor", {
	code = function( value, unit )
		local status
		
		if UnitIsFriend( "player", unit ) then
			if UnitExists( "target" ) then
				status = select( 2, UnitDetailedThreatSituation( unit, "target" ) )
			end
		else
			status = select( 2, UnitDetailedThreatSituation( "player", unit ) )
		end
		
		if status then
			local r, g, b = GetThreatStatusColor( status )
			
			if r then
				if value then
					return ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, value)
				else
					return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
				end
			end
		else
			return value
		end
	end,
	arg = {
		'value', 'string;undef', '@undef',
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return the color or wrap value with the color associated with unit's threat status."],
	example = '["100%":UnitThreatStatusColor] => "|cffff0000100%|r"; [UnitThreatStatusColor( "50%" )] => "|cffffffff50%"',
	category = L["Threat"]
})

DogTag:AddTag( "Unit", "PercentThreat", {
	code = function( unit )
		if UnitIsFriend( "player", unit ) then
			if UnitExists( "target" ) then
				return select( 3, UnitDetailedThreatSituation( unit, "target" ) )
			else
				return 0
			end
		else
			return select( 3, UnitDetailedThreatSituation( "player", unit ) )
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "nil;number",
	events = "Threat",
	doc = L["Return the current threat that you have against enemy unit or that friendly unit has against your target as a percentage of the amount required to pull aggro, scaled according to the range from the mob."],
	example = '[PercentThreat] => "50"',
	category = L["Threat"]
})

DogTag:AddTag( "Unit", "RawPercentThreat", {
	code = function( unit )
		if UnitIsFriend( "player", unit ) then
			if UnitExists( "target" ) then
				return select( 4, UnitDetailedThreatSituation( unit, "target" ) )
			else
				return 0
			end
		else
			return select( 4, UnitDetailedThreatSituation( "player", unit ) )
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "nil;number",
	events = "Threat",
	doc = L["Return the current threat that you have against enemy unit or that friendly unit has against your target as a percentage of tank's current threat."],
	example = '[RawPercentThreat] => "115"',
	category = L["Threat"]
})
end
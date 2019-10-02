local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local function MinRange_func(unit) return nil end
local function MaxRange_func(unit) return nil end
local function MinMaxRange_func(unit) return nil end

local function formatMinMax(min, max) 
	if min then
		if max then
			return min .. " - " .. max
		else
			return min .. "+"
		end
	end
	return nil
end

local found = false
DogTag:AddAddonFinder("Unit", "LibStub", "LibRangeCheck-2.0", function(RangeCheckLib)
	found = true
	function MinRange_func(unit)
		return (RangeCheckLib:getRange(unit))
	end
	function MaxRange_func(unit)
		local _, max = RangeCheckLib:getRange(unit)
		return max
	end
	function MinMaxRange_func(unit)
		return formatMinMax(RangeCheckLib:getRange(unit))
	end
end)

DogTag:AddAddonFinder("Unit", "AceLibrary", "RangeCheck-1.0", function(RangeCheckLib)
	if found then
		return
	end
	function MinRange_func(unit)
		return (RangeCheckLib:getRange(unit))
	end
	function MaxRange_func(unit)
		local _, max = RangeCheckLib:getRange(unit)
		return max
	end
	function MinMaxRange_func(unit)
		return formatMinMax(RangeCheckLib:getRange(unit))
	end
end)

DogTag:AddTag("Unit", "Range", {
	code = function(data)
		return MinMaxRange_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return the approximate range of unit, if RangeCheck-1.0 is available"],
	ret = function()
		if found then
			return "nil;string"
		else
			return "nil"
		end
	end,
	events = function()
		if found then
			return "Update"
		else
			return nil
		end
	end,
	example = '[Range] => "5 - 15"; [Range] => "30+"; [Range] => ""',
	category = L["Range"]
})

DogTag:AddTag("Unit", "MinRange", {
	code = function(data)
		return MinRange_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = function()
		if found then
			return "nil;number"
		else
			return "nil"
		end
	end,
	events = function()
		if found then
			return "Update"
		else
			return nil
		end
	end,
	doc = L["Return the approximate minimum range of unit, if RangeCheck-1.0 is available"],
	example = '[MinRange] => "5"; [MinRange] => ""',
	category = L["Range"]
})

DogTag:AddTag("Unit", "MaxRange", {
	code = function(data)
		return MaxRange_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = function()
		if found then
			return "nil;number"
		else
			return "nil"
		end
	end,
	events = function()
		if found then
			return "Update"
		else
			return nil
		end
	end,
	doc = L["Return the approximate maximum range of unit, if RangeCheck-1.0 is available"],
	example = '[MaxRange] => "15"; [MaxRange] => ""',
	category = L["Range"]
})

end

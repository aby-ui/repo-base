local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, math = _G, math

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

DogTag:AddTag("Base", "Round", {
	code = function(number, digits)
		local mantissa = 10^digits
		local norm = number*mantissa + 0.5
		local norm_floor = math.floor(norm)
		if norm == norm_floor and (norm_floor % 2) == 1 then
			return (norm_floor-1) / mantissa
		else
			return norm_floor / mantissa
		end
	end,
	arg = {
		'number', "number", "@req",
		'digits', "number", 0,
	},
	ret = "number",
	static = true,
	doc = L["Round number to the one's place or the place specified by digits"],
	example = '[1234.5:Round] => "1234"; [1234:Round(-2)] => "1200"; [Round(1235.5)] => "1236"; [Round(1234, -2)] => "1200"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Floor", {
	code = function(number)
		return math.floor(number)
	end,
	arg = {
		'number', "number", "@req",
	},
	ret = "number",
	static = true,
	doc = L["Take the floor of number"],
	example = '[9.876:Floor] => "9"; [Floor(9.876)] => "9"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Ceil", {
	code = function(number)
		return math.ceil(number)
	end,
	arg = {
		'number', "number", "@req",
	},
	ret = "number",
	static = true,
	doc = L["Take the ceiling of number"],
	example = '[1.234:Ceil] => "2"; [Ceil(1.234)] => "2"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Abs", {
	code = function(number)
		return math.abs(number)
	end,
	arg = {
		'number', "number", "@req",
	},
	ret = "number",
	static = true,
	doc = L["Take the absolute value of number"],
	example = '[5:Abs] => "5"; [-5:Abs] => "5"; [Abs(5)] => "5"; [Abs(-5)] => "5"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Sign", {
	code = function(number)
		if number < 0 then
		 	return -1
		elseif number == 0 then
			return 0
		else
			return 1
		end
	end,
	arg = {
		'number', "number", "@req",
	},
	ret = "number",
	static = true,
	doc = L["Take the signum of number"],
	example = '[5:Sign] => "1"; [-5:Sign] => "-1"; [0:Sign] => "0"; [Sign(5)] => "1"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Max", {
	code = function(number, ...)
		return math.max(number, ...)
	end,
	arg = {
		'number', 'number', "@req",
		'...', 'tuple-number', false
	},
		static = true,
	ret = "number",
	doc = L["Return the greatest value of the given arguments"],
	example = '[1:Max(2)] => "2"; [Max(3, 2, 1)] => "3"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Min", {
	code = function(number, ...)
		return math.min(number, ...)
	end,
	arg = {
		'number', 'number', "@req",
		'...', 'tuple-number', false
	},
	static = true,
	ret = "number",
	doc = L["Return the smallest value of the given arguments"],
	example = '[1:Min(2)] => "1"; [Min(3, 2, 1)] => "1"',
	category = L["Mathematics"],
})

DogTag:AddTag("Base", "Pi", {
	code = function()
		return math.pi
	end,
	ret = "number",
	static = true,
	doc = (L["Return the mathematical number π, or %s"]):format(math.pi),
	example = ('[Pi] => "%s"'):format(math.pi),
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Deg", {
	code = function(radian)
		return math.deg(radian)
	end,
	fakeAlias = "radian * 180 / Pi",
	arg = {
		'radian', 'number', "@req"
	},
	ret = "number",
	static = true,
	doc = L["Convert radian into degrees"],
	example = '[0:Deg] => "0"; [Pi:Deg] => "180"; [Deg(Pi/2)] => "90"',
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Rad", {
	code = function(degree)
		return math.rad(degree)
	end,
	fakeAlias = "degree * Pi / 180",
	arg = {
		'degree', 'number', "@req"
	},
	ret = "number",
	static = true,
	doc = L["Convert degree into radians"],
	example = ('[0:Rad] => "0"; [180:Rad] => "%s"; [Rad(90)] => "%s"'):format(math.pi, math.pi/2),
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Cos", {
	code = function(radian)
		return math.cos(radian)
	end,
	arg = {
		'radian', 'number', "@req"
	},
	ret = "number",
	static = true,
	doc = L["Return the cosine of radian"],
	example = ('[0:Cos] => "1"; [(Pi/4):Cos] => "%s"; [Cos(Pi/2)] => "0"'):format(math.cos(math.pi/4)),
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Sin", {
	code = function(radian)
		return math.sin(radian)
	end,
	arg = {
		'radian', 'number', "@req"
	},
	ret = "number",
	static = true,
	doc = L["Return the sin of radian"],
	example = ('[0:Sin] => "0"; [(Pi/4):Sin] => "%s"; [Sin(Pi/2)] => "1"'):format(math.cos(math.pi/4)),
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "E", {
	code = function()
		return math.exp(1)
	end,
	ret = "number",
	static = true,
	doc = (L["Return the mathematical number e, or %s"]):format(math.exp(1)),
	example = ('[E] => "%s"'):format(math.exp(1)),
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Ln", {
	code = function(number)
		return math.log(number)
	end,
	arg = {
		'number', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Return the natural log of number"],
	example = '[1:Ln] => "0"; [E:Ln] => "1"; [Ln(E^2)] => "2"',
	category = L["Mathematics"]
})

DogTag:AddTag("Base", "Log", {
	code = function(number)
		return math.log10(number)
	end,
	arg = {
		'number', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Return the log base 10 of number"],
	example = '[1:Log] => "0"; [10:Log] => "1"; [Log(100)] => "2"',
	category = L["Mathematics"]
})

end

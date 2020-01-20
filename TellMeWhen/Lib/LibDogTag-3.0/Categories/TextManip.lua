local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, math, type, tostring, tonumber, ipairs, table, select = _G, math, type, tostring, tonumber, ipairs, table, select

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

DogTag:AddTag("Base", "Percent", {
	code = function(number)
		return number .. "%"
	end,
	arg = {
		'number', 'number', '@req'
	},
	ret = "string",
	static = true,
	doc = L["Append a percentage sign to the end of number"],
	example = '[50:Percent] => "50%"; [Percent(50)] => "50%"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Short", {
	code = function(value)
		if type(value) == "number" then
			if abs(value) >= 10000000000 then
				return ("%.1fb"):format(value / 1000000000)
			elseif abs(value) >= 1000000000 then
				return ("%.2fb"):format(value / 1000000000)
			elseif value >= 10000000 or value <= -10000000 then
				return ("%.1fm"):format(value / 1000000)
			elseif value >= 1000000 or value <= -1000000 then
				return ("%.2fm"):format(value / 1000000)
			elseif value >= 100000 or value <= -100000 then
				return ("%.0fk"):format(value / 1000)
			elseif value >= 10000 or value <= -10000 then
				return ("%.1fk"):format(value / 1000)
			else
				return math.floor(value+0.5)..''
			end
		else
			local a,b = value:match("^(%d+)/(%d+)$")
			if a then
				a, b = tonumber(a), tonumber(b)
				if abs(a) >= 10000000000 then
					a = ("%.1fb"):format(a / 1000000000)
				elseif abs(a) >= 1000000000 then
					a = ("%.2fb"):format(a / 1000000000)
				elseif a >= 10000000 or a <= -10000000 then
					a = ("%.1fm"):format(a / 1000000)
				elseif a >= 1000000 or a <= -1000000 then
					a = ("%.2fm"):format(a / 1000000)
				elseif a >= 100000 or a <= -100000 then
					a = ("%.0fk"):format(a / 1000)
				elseif a >= 10000 or a <= -10000 then
					a = ("%.1fk"):format(a / 1000)
				end
				if abs(b) >= 10000000000 then
					b = ("%.1fb"):format(b / 1000000000)
				elseif abs(b) >= 1000000000 then
					b = ("%.2fb"):format(b / 1000000000)
				elseif b >= 10000000 or b <= -10000000 then
					b = ("%.1fm"):format(b / 1000000)
				elseif b >= 1000000 or b <= -1000000 then
					b = ("%.2fm"):format(b / 1000000)
				elseif b >= 100000 or b <= -100000 then
					b = ("%.0fk"):format(b / 1000)
				elseif b >= 10000 or b <= -10000 then
					b = ("%.1fk"):format(b / 1000)
				end
				return a.."/"..b
			else
				return value
			end
		end
	end,
	arg = {
		'value', 'number;string', '@req'
	},
	ret = "string",
	static = true,
	doc = L["Shorten value to have at maximum 3 decimal places showing"],
	example = '[1234:Short] => "1.23k"; [12345678:Short] => "12.3m"; ["1234/2345":Short] => "1.23k/2.35k"',
	category = L["Text manipulation"],
})

DogTag:AddTag("Base", "VeryShort", {
	code = function(value)
		if type(value) == "number" then
			if abs(value) >= 1000000000 then
				return ("%.0fb"):format(value / 1000000000)
			elseif value >= 1000000 or value <= -1000000 then
				return ("%.0fm"):format(value / 1000000)
			elseif value >= 1000 or value <= -1000 then
				return ("%.0fk"):format(value / 1000)
			else
				return ("%.0f"):format(value)
			end
		else
			local a,b = value:match("^(%d+)/(%d+)")
			if a then
				a, b = tonumber(a), tonumber(b)
				if abs(b) >= 1000000000 then
					b = ("%.0fb"):format(b / 1000000000)
				elseif b >= 1000000 or b <= -1000000 then
					b = ("%.0fm"):format(b / 1000000)
				elseif b >= 1000 or b <= -1000 then
					b = ("%.0fk"):format(b / 1000)
				end
				if abs(a) >= 1000000000 then
					a = ("%.0fb"):format(a / 1000000000)
				elseif a >= 1000000 or a <= -1000000 then
					a = ("%.0fm"):format(a / 1000000)
				elseif a >= 1000 or a <= -1000 then
					a = ("%.0fk"):format(a / 1000)
				end
				return a.."/"..b
			else
				return value
			end
		end
	end,
	arg = {
		'value', 'number;string', "@req"
	},
	ret = "number;string",
	static = true,
	doc = L["Shorten value to its closest denomination"],
	example = '[1234:VeryShort] => "1k"; [123456:VeryShort] => "123k"; ["12345/23456":VeryShort] => "12k/23k"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Upper", {
	code = function(value)
		return value:upper()
	end,
	arg = {
		'value', 'string', '@req'
	},
	static = true,
	ret = "string",
	doc = L["Turn value into an uppercase string"],
	example = '["Hello":Upper] => "HELLO"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Lower", {
	code = function(value)
		return value:lower()
	end,
	arg = {
		'value', 'string', '@req'
	},
	static = true,
	ret = "string",
	doc = L["Turn value into an lowercase string"],
	example = '["Hello":Lower] => "hello"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Bracket", {
	code = function(value)
		return "[" .. value .. "]"
	end,
	arg = {
		'value', 'string', '@req'
	},
	static = true,
	ret = "string",
	doc = L["Wrap value with square brackets"],
	example = '["Hello":Bracket] => "[Hello]"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Angle", {
	code = function(value)
		return "<" .. value .. ">"
	end,
	arg = {
		'value', 'string', '@req'
	},
	ret = "string",
	static = true,
	doc = L["Wrap value with angle brackets"],
	example = '["Hello":Angle] => "<Hello>"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Brace", {
	code = function(value)
		return "{" .. value .. "}"
	end,
	arg = {
		'value', 'string', '@req'
	},
	ret = "string",
	static = true,
	doc = L["Wrap value with braces"],
	example = '["Hello":Brace] => "{Hello}"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Paren", {
	code = function(value)
		return "(" .. value .. ")"
	end,
	arg = {
		'value', 'string', '@req'
	},
	ret = "string",
	static = true,
	doc = L["Wrap value with parentheses"],
	example = '["Hello":Paren] => "(Hello)"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Truncate", {
	code = function(value, number, ellipses)
		local len = 0
		for i = 1, number do
			local b = value:byte(len+1)
			if not b then
				break
			elseif b <= 127 then
				len = len + 1
			elseif b <= 223 then
				len = len + 2
			elseif b <= 239 then
				len = len + 3
			else
				len = len + 4
			end
		end
		local val = value:sub(1, len)
		if ellipses and value:byte(len+1) then
			val = val .. "..."
		end
		return val
	end,
	arg = {
		'value', 'string', '@req',
		'number', 'number', '@req',
		'ellipses', 'boolean', true,
	},
	ret = "string",
	static = true,
	doc = L["Truncate value to the length specified by number, adding ellipses by default"],
	example = '["Hello":Truncate(3)] => "Hel..."; ["Hello":Truncate(3, nil)] => "Hel"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Substring", {
	code = function(value, start, finish)
		if start < 0 or finish < 0 then
			local length = 0
			local i = 0
			while i < #value do
				local b = value:byte(i+1)
				if not b then
					break
				elseif b <= 127 then
					i = i + 1
				elseif b <= 223 then
					i = i + 2
				elseif b <= 239 then
					i = i + 3
				else
					i = i + 4
				end
				length = length + 1
			end
			if start < 0 then
				start = start + length + 1
			end
			if finish < 0 then
				finish = finish + length + 1
			end
		end
		if finish < start then
			return nil
		else
			local finishByte = 0
			local startByte
			for i = 1, finish do
				if i == start then
					startByte = finishByte+1
				end
				local b = value:byte(finishByte+1)
				if not b then
					break
				elseif b <= 127 then
					finishByte = finishByte + 1
				elseif b <= 223 then
					finishByte = finishByte + 2
				elseif b <= 239 then
					finishByte = finishByte + 3
				else
					finishByte = finishByte + 4
				end
			end
			if not startByte then
				return value
			else
				return value:sub(startByte, finishByte)
			end
		end
	end,
	arg = {
		'value', 'string', '@req',
		'start', 'number', '@req',
		'finish', 'number', -1,
	},
	ret = "nil;string",
	static = true,
	doc = L["Return the characters specified by start and finish. If either are negative, it means take from the end instead of the beginning"],
	example = '["Hello":Sub(2, 4)] => "ell"; ["Hello":Sub(2, -2)] => "ell"; ["Hello":Sub(3)] => "llo"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Repeat", {
	code = function(value, number)
		local val = value:rep(number)
		if val == "" then
			val = nil
		end
		return val
	end,
	arg = {
		'value', 'string', '@req',
		'number', 'number', '@req',
	},
	ret = "string;nil",
	static = true,
	doc = L["Repeat value number times"],
	example = '["Hello":Rep(3)] => "HelloHelloHello"',
	category = L["Text manipulation"]
})

DogTag:AddTag("Base", "Length", {
	code = function(value)
		local len = 0
		local num = 0
		while true do
			local b = value:byte(len+1)
			if not b then
				break
			elseif b <= 127 then
				len = len + 1
			elseif b <= 223 then
				len = len + 2
			elseif b <= 239 then
			 	len = len + 3
			else
				len = len + 4
			end
			num = num + 1
		end
		return num
	end,
	arg = {
		'value', 'string', "@req"
	},
	ret = "number",
	static = true,
	doc = L["Return the length of value"],
	example = '["Hello":Length] => "5"; ["Hi guys":Length] => "7"',
	category = L["Text manipulation"]
})

local romanizationData = {
	{"M", 1000},
	{"CM", 900},
	{"D", 500},
	{"CD", 400},
	{"C", 100},
	{"XC", 90},
	{"L", 50},
	{"XL", 40},
	{"X", 10},
	{"IX", 9},
	{"V", 5},
	{"IV", 4},
	{"I", 1}
}
local tmp = {}
local function romanize(value)
	if value >= 5000000 or value <= -5000000 then
		return tostring(value)
	end
	
	value = math.floor(value + 0.5)
	if value == 0 then
		return "N"
	end
	
	local neg = value < 0
	if neg then
		value = -value
		tmp[1] = "-"
	end
	
	if value >= 5000 then
		tmp[#tmp+1] = "("
		for i = 1, #romanizationData-2 do
			local v = romanizationData[i]
			while value >= v[2]*1000 do
				tmp[#tmp+1] = v[1]
				value = value - v[2]*1000
			end
		end
		tmp[#tmp+1] = ")"
	end
	
	for i,v in ipairs(romanizationData) do
		while value >= v[2] do
			tmp[#tmp+1] = v[1]
			value = value - v[2]
		end
	end
	local result = table.concat(tmp)
	for i = 1, #tmp do
		tmp[i] = nil
	end
	return result
end
DogTag:AddTag("Base", "Romanize", {
	code = romanize,
	arg = {
		'value', 'number', "@req",
	},
	ret = "string",
	static = true,
	doc = L["Turn number_value into a roman numeral."],
	example = '[1666:Romanize] => "MDCLXVI"',
	category = L["Text manipulation"]
})

local function abbreviate(text)
	local b = text:byte(1)
	if b <= 127 then
		return text:sub(1, 1)
	elseif b <= 223 then
		return text:sub(1, 2)
	elseif b <= 239 then
		return text:sub(1, 3)
	else
		return text:sub(1, 4)
	end
end
DogTag:AddTag("Base", "Abbreviate", {
	code = function(value)
		if value:find(" ") then
			return value:gsub(" *([^ ]+) *", abbreviate)
		else
			return value
		end
	end,
	arg = {
		'value', 'string', "@req"
	},
	ret = "string",
	static = true,
	doc = L["Abbreviate value if a space is found"],
	example = '["Hello":Abbreviate] => "Hello"; ["Hello World":Abbreviate] => "HW"',
	category = L["Text manipulation"],
})

DogTag:AddTag("Base", "Concatenate", {
	code = function(...)
		local n = select('#', ...)
		if n == 0 then
			return nil
		end
		for i = 1, n do
			if not select(i, ...) then
				return nil
			end
		end
		return (""):join(...)
	end,
	arg = {
		'...', 'tuple-string;nil', false,
	},
	ret = "string;nil",
	static = true,
	doc = L["Concatenate the values of ... as long as they are all non-blank"],
	example = '[Concatenate("Hello", " ", "World")] => "Hello World"; [Concatenate(nil, " ", World")] => ""; [Concatenate("Hello", nil)] => ""',
	category = L["Text manipulation"],
})

DogTag:AddTag("Base", "Append", {
	code = function(left, right)
		if right then
			return left .. right
		else
			return left
		end
	end,
	arg = {
		'left', 'string', "@req",
		'right', 'string;nil', false,
	},
	ret = "string",
	static = true,
	doc = L["Append right to left if right exists"],
	example = '["Hello":Append(" There")] => "Hello There"; ["Hello":Append(nil)] => "Hello"',
	category = L["Text manipulation"],
})

DogTag:AddTag("Base", "Prepend", {
	code = function(right, left)
		if left then
			return left .. right
		else
			return right
		end
	end,
	arg = {
		'right', 'string', "@req",
		'left', 'string;nil', false,
	},
	ret = "string",
	static = true,
	doc = L["Prepend left to right if right exists"],
	example = '["There":Prepend("Hello ")] => "Hello There"; ["There":Prepend(nil)] => "There"',
	category = L["Text manipulation"],
})

DogTag:AddTag("Base", "Replace", {
	code = function(value, pattern, replacement)
		pattern = pattern:gsub("([%%%[%]%^%$%.%+%*%?%(%)])", "%%%1")
		value = value:gsub(pattern, replacement)
		if value == '' then
			return nil
		else
			return value
		end
	end,
	arg = {
		'value', 'string', '@req',
		'pattern', 'string', '@req',
		'replacement', 'string', '@req',
	},
	ret = "string;nil",
	static = true,
	doc = L["Replace all the instances of pattern in value with replacement"],
	example = '["Hello there, Hello":Replace("Hello", "Stop")] => "Stop there, Stop"',
	category = L["Text manipulation"],
})

local default_thousands_separator
local default_decimal_separator
do
	local tmp = tostring(1.1)
	if tmp == "1,1" then
		default_thousands_separator = " "
		default_decimal_separator = ","
	else
		default_thousands_separator = ","
		default_decimal_separator = "."
	end
end

local t = {}
DogTag:AddTag("Base", "SeparateDigits", {
	code = function(number, thousands, decimal)
		local int = math.floor(number)
		local rest = number % 1
		if int == 0 then
			t[#t+1] = 0
		else
			local digits = math.log10(int)
			local segments = math.floor(digits / 3)
			t[#t+1] = math.floor(int / 1000^segments)
			for i = segments-1, 0, -1 do
				t[#t+1] = thousands
				t[#t+1] = ("%03d"):format(math.floor(int / 1000^i) % 1000)
			end
		end
		if rest ~= 0 then
			t[#t+1] = decimal
			rest = math.floor(rest * 10^6)
			while rest % 10 == 0 do
				rest = rest / 10
			end
			t[#t+1] = rest
		end
		local s = table.concat(t)
		for i = 1, #t do
			t[i] = nil
		end
		return s
	end,
	arg = {
		'number', 'number', '@req',
		'thousands', 'string', default_thousands_separator,
		'decimal', 'string', default_decimal_separator,
	},
	ret = "string",
	static = true,
	doc = L["Separate the digits of number into a more human-readable manner"],
	example = ('[1234567.89:SeparateDigits] => "1%s234%s567%s89"'):format(default_thousands_separator, default_thousands_separator, default_decimal_separator),
	category = L["Text manipulation"],
})

end

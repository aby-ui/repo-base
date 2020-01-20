local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, type, tostring = _G, type, tostring

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

DogTag:AddTag("Base", "+", {
	code = function(left, right)
		return left + right
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Add left and right together"],
	example = '[1 + 2] => "3"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "-", {
	code = function(left, right)
		return left - right
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Subtract right from left"],
	example = '[1 - 2] => "-1"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "*", {
	code = function(left, right)
		return left * right
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Multiple left and right together"],
	example = '[1 * 2] => "2"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "/", {
	code = function(left, right)
		if left == 0 then
			return 0
		else
			return left / right
		end
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Divide left by right"],
	example = '[1 / 2] => "0.5"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "%", {
	code = function(left, right)
		return left % right
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Take the modulus of left and right"],
	example = '[5 % 3] => "2"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "^", {
	code = function(left, right)
		return left ^ right
	end,
	arg = {
		'left', 'number', "@req",
		'right', 'number', "@req",
	},
	ret = "number",
	doc = L["Raise left to the right power"],
	example = '[5 ^ 3] => "125"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "<", {
	code = function(left, right)
		if type(left) == type(right) then
			if left < right then
				return left
			else
				return nil
			end
		else
			if tostring(left) < tostring(right) then
				return left
			else
				return nil
			end
		end
	end,
	arg = {
		'left', 'number;string', "@req",
		'right', 'number;string', "@req",
	},
	ret = function(args)
		return "nil;" .. args.left.types
	end,
	static = true,
	doc = L["Check if left is less than right, if so, return left"],
	example = '[5 < 3] => ""; [3 < 5] => "3"; [3 < 3] => ""',
	category = L["Operators"]
})

DogTag:AddTag("Base", ">", {
	code = function(left, right)
		if type(left) == type(right) then
			if left > right then
				return left
			else
				return nil
			end
		else
			if tostring(left) > tostring(right) then
				return left
			else
				return nil
			end
		end
	end,
	arg = {
		'left', 'number;string', "@req",
		'right', 'number;string', "@req",
	},
	ret = function(args)
		return "nil;" .. args.left.types
	end,
	static = true,
	doc = L["Check if left is greater than right, if so, return left"],
	example = '[5 > 3] => "5"; [3 > 5] => ""; [3 > 3] => ""',
	category = L["Operators"]
})

DogTag:AddTag("Base", "<=", {
	alias = [=[not (left > right)]=],
	arg = {
		'left', 'number;string', "@req",
		'right', 'number;string', "@req",
	},
	doc = L["Check if left is less than or equal to right, if so, return left"],
	example = '[5 <= 3] => ""; [3 <= 5] => "3"; [3 <= 3] => "3"',
	category = L["Operators"]
})

DogTag:AddTag("Base", ">=", {
	alias = [=[not (left < right)]=],
	arg = {
		'left', 'number;string', "@req",
		'right', 'number;string', "@req",
	},
	doc = L["Check if left is greater than or equal to right, if so, return left"],
	example = '[5 >= 3] => "5"; [3 >= 5] => ""; [3 >= 3] => "3"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "=", {
	code = function(left, right)
		if left == right or tostring(left) == tostring(right) then
			return left or L["True"]
		else
			return nil
		end
	end,
	arg = {
		'left', 'nil;number;string', "@req",
		'right', 'nil;number;string', "@req",
	},
	ret = function(args)
		return "nil;" .. args.left.types
	end,
	static = true,
	doc = L["Check if left is equal to right, if so, return left"],
	example = '[1 = 2] => ""; [1 = 1] => "1"',
	category = L["Operators"]
})

DogTag:AddTag("Base", "~=", {
	alias = [=[not (left = right)]=],
	arg = {
		'left', 'nil;number;string', "@req",
		'right', 'nil;number;string', "@req",
	},
	doc = L["Check if left is not equal to right, if so, return left"],
	example = '[1 ~= 2] => "1"; [1 ~= 1] => ""',
	category = L["Operators"]
})

DogTag:AddTag("Base", "unm", {
	code = function(number)
		return -number
	end,
	arg = {
		'number', 'number', "@req",
	},
	ret = "number",
	static = true,
	doc = L["Return the negative of number"],
	example = '[-1] => "-1"; [-(-1)] => "1"',
	category = L["Operators"]
})

end

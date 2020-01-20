local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local math, type, tostring, select, pcall, string, table, pairs, GetTime = math, type, tostring, select, pcall, string, table, pairs, GetTime
local IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown = IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

DogTag:AddTag("Base", "Alt", {
	code = IsAltKeyDown,
	ret = "boolean",
	events = "MODIFIER_STATE_CHANGED#ALT;MODIFIER_STATE_CHANGED#LALT;MODIFIER_STATE_CHANGED#RALT",
	globals = "IsAltKeyDown",
	doc = L["Return True if the Alt key is held down"],
	example = ('[Alt] => %q; [Alt] => ""'):format(L["True"]),
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Shift", {
	code = IsShiftKeyDown,
	ret = "boolean",
	events = "MODIFIER_STATE_CHANGED#SHIFT;MODIFIER_STATE_CHANGED#LSHIFT;MODIFIER_STATE_CHANGED#RSHIFT",
	globals = "IsShiftKeyDown",
	doc = L["Return True if the Shift key is held down"],
	example = ('[Shift] => %q; [Shift] => ""'):format(L["True"]),
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Ctrl", {
	code = IsControlKeyDown,
	ret = "boolean",
	events = "MODIFIER_STATE_CHANGED#CTRL;MODIFIER_STATE_CHANGED#LCTRL;MODIFIER_STATE_CHANGED#RCTRL",
	globals = "IsControlKeyDown",
	doc = L["Return True if the Ctrl key is held down"],
	example = ('[Ctrl] => %q; [Ctrl] => ""'):format(L["True"]),
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "CurrentTime", {
	code = GetTime,
	ret = "number",
	events = "FastUpdate",
	globals = "GetTime",
	doc = L["Return the current time in seconds, specified by WoW's internal format"],
	example = ('[CurrentTime] => "%s"'):format(GetTime()),
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Alpha", {
	code = function(number)
		if number > 1 then
			number = 1
		elseif number < 0 then
			number = 0
		end
		DogTag.opacity = number
	end,
	arg = {
		'number', 'number', "@req"
	},
	ret = "nil",
	doc = L["Set the transparency of the FontString according to argument"],
	example = '[Alpha(1)] => "Bright"; [Alpha(0)] => "Dim"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Monochrome", {
	code = function(number)
		DogTag.outline = "MONOCHROME"
	end,
	ret = "nil",
	doc = L["Set the FontString to be monochrome"],
	example = '[Monochrome "Hello"] => "Monochrome"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Outline", {
	code = function(number)
		DogTag.outline = "OUTLINE"
	end,
	ret = "nil",
	doc = L["Set the FontString to be outlined"],
	example = '[Outline "Hello"] => "Bold"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "ThickOutline", {
	code = function(number)
		DogTag.outline = "OUTLINE, THICKOUTLINE"
	end,
	ret = "nil",
	doc = L["Set the FontString to be outlined thickly"],
	example = '[ThickOutline "Hello"] => "Very Bold"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "IsMouseOver", {
	code = function()
		return DogTag.__isMouseOver
	end,
	ret = "boolean",
	events = "Mouseover",
	doc = L["Return True if currently mousing over the Frame the FontString is harbored in"],
	example = ('[IsMouseOver] => %q; [IsMouseOver] => ""'):format(L["True"]),
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Color", {
	code = function(value, red, green, blue)
		local val, color, r, g, b
		if value and (not red or (type(red) == "number" and not blue)) then
			-- tag
			if type(value) == "string" then
				color = value
			else
				r, g, b = value, red, green
			end
		else
			-- modifier
			val = value and tostring(value)
			if type(red) == "string" then
				color = red
			else
				r, g, b = red, green, blue
			end
		end
		
		if r then
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
			if val then
				return ("|cff%02x%02x%02x%s|r"):format(r*255, g*255, b*255, val)
			else
				return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
			end
		elseif color then
			if not color:match("^%x%x%x%x%x%x$") then
				color = "ffffff"
			end
			if val then
				return "|cff" .. color .. val .. "|r"
			else
				return "|cff" .. color
			end
		else
			return "|r"
		end
	end,
	arg = {
		'value', 'string;number;undef', '@undef',
		'red', 'string;number;nil', false,
		'green', 'number;nil', false,
		'blue', 'number;nil', false,
	},
	ret = "string",
	static = true,
	doc = L["Return the color or wrap value with the rrggbb color of argument"],
	example = '["Hello":Color("00ff00")] => "|cff00ff00Hello|r"; ["Hello":Color(0, 1, 0)] => "|cff00ff00Hello|r"',
	category = L["Miscellaneous"]
})

for name, color in pairs({
	White = "ffffff",
	Red = "ff0000",
	Green = "00ff00",
	Blue = "0000ff",
	Cyan = "00ffff",
	Fuchsia = "ff00ff",
	Yellow = "ffff00",
	Gray = "afafaf",
	Black = "000000",
}) do
	DogTag:AddTag("Base", name, {
		alias = ([=[Color(value, %q)]=]):format(color),
		arg = {
			'value', 'string;undef', "@undef",
		},
		doc = L["Return the color or wrap value with %s color"]:format(L[name]),
		example = ('["Hello":%s] => "|cff%sHello|r"; [%s "Hello"] => "|cff%sHello"'):format(name, color, name, color),
		category = L["Miscellaneous"]
	})
end

DogTag:AddTag("Base", "IsIn", {
	code = function(value, ...)
		local good = false
		for i = 1, select('#', ...) do
			if value == select(i, ...) then
				good = true
				break
			end
		end
		if good then
			return value
		else
			return nil
		end
	end,
	arg = {
		'value', 'number;string', "@req",
		'...', 'tuple-number;string;nil', "@req",
	},
	ret = function(args)
		return "nil;" .. args.value.types
	end,
	static = true,
	doc = L["Return value if value is within ..."],
	example = '[1:IsIn(1, 2, 3)] => "1"; ["Alpha":IsIn("Bravo", "Charlie")] => ""',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Hide", {
	alias = [=[not IsIn(value, ...)]=],
	arg = {
		'value', 'number;string', "@req",
		'...', 'tuple-number;string;nil', "@req",
	},
	doc = L["Hide value if value is within ..."],
	example = '[1:Hide(1, 2, 3)] => ""; ["Alpha":Hide("Bravo", "Charlie")] => "Alpha"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Contains", {
	code = function(left, right)
		if left:match(right) then
			return left
		else
			return nil
		end
	end,
	arg = {
		'left', 'string', '@req',
		'right', 'string', '@req',
	},
	ret = "string;nil",
	static = true,
	doc = L["Return left if left contains right"],
	example = '["Hello":Contains("There")] => ""; ["Hello":Contains("ello")] => "Hello"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Boolean", {
	code = function(value)
		return value
	end,
	arg = {
		'value', 'boolean', "@req"
	},
	ret = "boolean",
	static = true,
	doc = L["Return True if non-blank"],
	example = '[Boolean("Hello")] => "True"; [Boolean(nil)] => ""',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Format", {
	code = function(format, ...)
		local ret, err = pcall(string.format, format, ...)
		return err
	end,
	arg = {
		'format', 'string', "@req",
		'...', 'tuple-number;string', false,
	},
	ret = "string",
	static = true,
	doc = L["Return a string formatted by format"],
	example = '["%.3f":Format(1)] => "1.000"; ["%s %s":Format("Hello", "There")] => "Hello There"',
	category = L["Miscellaneous"]
})

local L_DAY_ONELETTER_ABBR    = DAY_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_HOUR_ONELETTER_ABBR   = HOUR_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_MINUTE_ONELETTER_ABBR = MINUTE_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_SECOND_ONELETTER_ABBR = SECOND_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_DAYS_ABBR = DAYS_ABBR:gsub("%s*%%d%s*", "")
local L_HOURS_ABBR = HOURS_ABBR:gsub("%s*%%d%s*", "")
local L_MINUTES_ABBR = MINUTES_ABBR:gsub("%s*%%d%s*", "")
local L_SECONDS_ABBR = SECONDS_ABBR:gsub("%s*%%d%s*", "")

local t = {}
DogTag:AddTag("Base", "FormatDuration", {
	code = function(number, format)
		local negative = ""
		if number < 0 then
			number = -number
			negative = "-"
		end
		format = format:sub(1, 1):lower()
		if format == "e" then
			if number == math.huge then
				return negative .. "***"
			end
			
			t[#t+1] = negative
			
			number = math.floor(number + 0.5)
			
			local first = true
			
			if number >= 60*60*24 then
				local days = math.floor(number / (60*60*24))
				number = number % (60*60*24)
				t[#t+1] = ("%.0f"):format(days)
				t[#t+1] = " "
				t[#t+1] = L_DAYS_ABBR
				first = false
			end
			
			if number >= 60*60 then
				local hours = math.floor(number / (60*60))
				number = number % (60*60)
				if not first then
					t[#t+1] = " "
				else
					first = false
				end
				t[#t+1] = hours
				t[#t+1] = " "
				t[#t+1] = L_HOURS_ABBR
			end
			
			if number >= 60 then
				local minutes = math.floor(number / 60)
				number = number % 60
				if not first then
					t[#t+1] = " "
				else
					first = false
				end
				t[#t+1] = minutes
				t[#t+1] = " "
				t[#t+1] = L_MINUTES_ABBR
			end
			
			if number >= 1 or first then
				local seconds = number
				if not first then
					t[#t+1] = " "
				else
					first = false
				end
				t[#t+1] = seconds
				t[#t+1] = " "
				t[#t+1] = L_SECONDS_ABBR
			end
			local s = table.concat(t)
			for k in pairs(t) do
				t[k] = nil
			end
			return s
		elseif format == "f" then
			if number == math.huge then
				return negative .. "***"
			elseif number >= 60*60*24 then
				return ("%s%.0f%s %02d%s %02d%s %02d%s"):format(negative, math.floor(number/86400), L_DAY_ONELETTER_ABBR, number/3600 % 24, L_HOUR_ONELETTER_ABBR, number/60 % 60, L_MINUTE_ONELETTER_ABBR, number % 60, L_SECOND_ONELETTER_ABBR)
			elseif number >= 60*60 then
				return ("%s%d%s %02d%s %02d%s"):format(negative, number/3600, L_HOUR_ONELETTER_ABBR, number/60 % 60, L_MINUTE_ONELETTER_ABBR, number % 60, L_SECOND_ONELETTER_ABBR)
			elseif number >= 60 then
				return ("%s%d%s %02d%s"):format(negative, number/60, L_MINUTE_ONELETTER_ABBR, number % 60, L_SECOND_ONELETTER_ABBR)
			else
				return ("%s%d%s"):format(negative, number, L_SECOND_ONELETTER_ABBR)
			end
		elseif format == "s" then
			if number == math.huge then
				return negative .. "***"
			elseif number >= 2*60*60*24 then
				return ("%s%.1f %s"):format(negative, number/86400, L_DAYS_ABBR)
			elseif number >= 2*60*60 then
				return ("%s%.1f %s"):format(negative, number/3600, L_HOURS_ABBR)
			elseif number >= 2*60 then
				return ("%s%.1f %s"):format(negative, number/60, L_MINUTES_ABBR)
			elseif number >= 3 then
				return ("%s%.0f %s"):format(negative, number, L_SECONDS_ABBR)
			else
				return ("%s%.1f %s"):format(negative, number, L_SECONDS_ABBR)
			end
		else
			if number == math.huge then
				return ("%s**%d **:**:**"):format(negative, L_DAY_ONELETTER_ABBR)
			elseif number >= 60*60*24 then
				return ("%s%.0f%s %d:%02d:%02d"):format(negative, math.floor(number/86400), L_DAY_ONELETTER_ABBR, number/3600 % 24, number/60 % 60, number % 60)
			elseif number >= 60*60 then
				return ("%s%d:%02d:%02d"):format(negative, number/3600, number/60 % 60, number % 60)
			else
				return ("%s%d:%02d"):format(negative, number/60 % 60, number % 60)
			end
		end
	end,
	arg = {
		'number', 'number', "@req",
		'format', 'string', "c",
	},
	globals = "pcall;string.format",
	ret = "string",
	static = true,
	doc = L["Return a string formatted by format. Use 'e' for extended, 'f' for full, 's' for short, 'c' for compressed."],
	example = '[1000:FormatDuration] => "16:40"; [1000:FormatDuration("s")] => "16.7 Mins"; [1000:FormatDuration("f")] => "16m 40s"; [1000:FormatDuration("e")] => "16 Mins 40 Secs"',
	category = L["Miscellaneous"]
})

DogTag:AddTag("Base", "Icon", {
	code = function(data, size)
		return "|T" .. data .. ":" .. size .. "|t"
	end,
	arg = {
		'data', 'string', '@req',
		'size', 'number', 0,
	},
	ret = 'string',
	static = true,
	doc = L["Return an icon using the given path"],
	example = '["Interface\\Buttons\\WHITE8X8":Icon] => "|TInterface\\Buttons\\WHITE8X8:0|t"',
	category = L["Miscellaneous"]
})

if _G.C_ArtifactUI then
	local GetEquippedArtifactInfo = _G.C_ArtifactUI.GetEquippedArtifactInfo
	local GetCostForPointAtRank = _G.C_ArtifactUI.GetCostForPointAtRank

	local function GetCurrentArtifactPowerRank()
		return select(6, GetEquippedArtifactInfo()) or 0
	end

	DogTag:AddTag("Base", "ArtifactPower", {
		code = function()
			return select(5, GetEquippedArtifactInfo()) or 0
		end,
		ret = "number",
		doc = L["Gets current artifact power"],
		example = ('[ArtifactPower] => "%d"'):format(500),
		category = L["Miscellaneous"]
	})

	DogTag:AddTag("Base", "MaxArtifactPower", {
		code = function()
			return GetCostForPointAtRank(GetCurrentArtifactPowerRank())
		end,
		ret = "number",
		doc = L["Gets artifact power required for the current rank to unlock"],
		example = ('[MaxArtifactPower] => "%d"'):format(400),
		category = L["Miscellaneous"]
	})

	DogTag:AddTag("Base", "ArtifactPointsSpent", {
		code = GetCurrentArtifactPowerRank,
		ret = "number",
		doc = L["Gets number of artifact points spent"],
		example = ('[ArtifactPointsSpent] => "%d"'):format(3),
		category = L["Miscellaneous"]
	})

	DogTag:AddTag("Base", "ArtifactPointsSpendable", {
		code = function()
			local _, _, _, _, totalXP, pointsSpent = GetEquippedArtifactInfo()
			if pointsSpent == nil or totalXP == nil then
				return 0
			end
			local pointsAvailable = 0
			local nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0

			while totalXP >= nextRankCost  do
				totalXP = totalXP - nextRankCost
				pointsAvailable = pointsAvailable + 1
				nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0
			end

			return pointsAvailable
		end,
		ret = "number",
		doc = L["Gets number of artifact points the player has available to spend"],
		example = ('[GetArtifactPointsSpendable] => "%d"'):format(1),
		category = L["Miscellaneous"]
	})

	DogTag:AddTag("Base", "ArtifactPowerForCurrentLevel", {
		code = function()
			local _, _, _, _, totalXP, pointsSpent = GetEquippedArtifactInfo()
			if pointsSpent == nil or totalXP == nil then
				return 0
			end
			local pointsAvailable = 0
			local nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0

			while totalXP >= nextRankCost  do
				totalXP = totalXP - nextRankCost
				pointsAvailable = pointsAvailable + 1
				nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0
			end

			return totalXP
		end,
		ret = "number",
		doc = L["Gets artifact power toward next rank"],
		example = ('[ArtifactPowerForCurrentLevel] => "%d"'):format(125),
		category = L["Miscellaneous"]
	})

	DogTag:AddTag("Base", "MaxArtifactPowerForCurrentLevel", {
		code = function()
			local _, _, _, _, totalXP, pointsSpent = GetEquippedArtifactInfo()
			if pointsSpent == nil or totalXP == nil then
				return 0
			end
			local pointsAvailable = 0
			local nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0

			while totalXP >= nextRankCost  do
				totalXP = totalXP - nextRankCost
				pointsAvailable = pointsAvailable + 1
				nextRankCost = GetCostForPointAtRank(pointsSpent + pointsAvailable) or 0
			end

			return nextRankCost
		end,
		ret = "number",
		doc = L["Gets artifact power required for the next rank to unlock"],
		example = ('[MaxArtifactPowerForCurrentLevel] => "%d"'):format(425),
		category = L["Miscellaneous"]
	})
end

if C_ChallengeMode then
	DogTag:AddTag("Base", "KeystoneLevel", {
		code = function()
			return C_ChallengeMode.GetActiveKeystoneInfo() or 0
		end,
		ret = "number",
		doc = L["Gets the level of the currently active Mythic+ Keystone."],
		example = '[KeystoneLevel] => "10"',
		events = "SCENARIO_CRITERIA_UPDATE;CHALLENGE_MODE_START",
		category = L["Miscellaneous"]
	})
end


end

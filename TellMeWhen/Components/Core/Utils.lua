-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print


local tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, select, wipe, next, rawget, rawset, assert, pcall, error, getmetatable, setmetatable, unpack =
	  tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, select, wipe, next, rawget, rawset, assert, pcall, error, getmetatable, setmetatable, unpack
local strfind, strmatch, format, gsub, gmatch, strsub, strtrim, strsplit, strlower, strrep, strchar, strconcat, strjoin =
	  strfind, strmatch, format, gsub, gmatch, strsub, strtrim, strsplit, strlower, strrep, strchar, strconcat, strjoin
local math, max, ceil, floor, random, abs =
	  math, max, ceil, floor, random, abs
local _G, coroutine, table, GetTime, CopyTable, tostringall, geterrorhandler, C_Timer =
	  _G, coroutine, table, GetTime, CopyTable, tostringall, geterrorhandler, C_Timer

local UnitAura, IsUsableSpell, GetSpecialization, GetSpecializationInfo, GetFramerate =
	  UnitAura, IsUsableSpell, GetSpecialization, GetSpecializationInfo, GetFramerate

local debugprofilestop = debugprofilestop_SAFE




---------------------------------
-- TMW.Class.Formatter
---------------------------------

local Formatter = TMW:NewClass("Formatter"){
	OnNewInstance = function(self, fmt)
		self.fmt = fmt
	end,

	Format = function(self, value)
		local type = type(self.fmt)

		if type == "string" then
			return format(self.fmt, value)
		elseif type == "table" then
			return self.fmt[value]
		elseif type == "function" then
			return self.fmt(value)
		else
			return value
		end
	end,

	SetFormattedText = function(self, frame, value)
		frame:SetText(self:Format(value))
	end,
}
Formatter:MakeInstancesWeak()

-- Some commonly used formatters.
Formatter{
	NONE = Formatter:New(TMW.NULLFUNC),
	PASS = Formatter:New(tostring),


	F_0 = Formatter:New("%.0f"),
	F_1 = Formatter:New("%.1f"),
	F_2 = Formatter:New("%.2f"),

	PERCENT = Formatter:New("%s%%"),
	PERCENT100 = Formatter:New(function(value)
		return ("%s%%"):format(value*100)
	end),
	PERCENT100_F0 = Formatter:New(function(value)
		return ("%.0f%%"):format(value*100)
	end),

	PLUSPERCENT = Formatter:New("+%s%%"),

	D_SECONDS = Formatter:New(D_SECONDS),
	S_SECONDS = Formatter:New(L["ANIM_SECONDS"]),

	PIXELS = Formatter:New(L["ANIM_PIXELS"]),

	COMMANUMBER = Formatter:New(function(k)
		k = gsub(k, "(%d)(%d%d%d)$", "%1,%2", 1)
		local found
		repeat
			k, found = gsub(k, "(%d)(%d%d%d),", "%1,%2,", 1)
		until found == 0

		return k
	end),


	TIME_COLONS = Formatter:New(function(value)
		return TMW:FormatSeconds(value, nil, 1)
	end),

	TIME_COLONS_FORCEMINS = Formatter:New(function(seconds)
		if abs(seconds) == math.huge then
			return tostring(seconds)
		end

		if seconds < 0 then
			error("This function doesn't support negative seconds")
		end
		
		local y =  seconds / 31556925
		local d = (seconds % 31556925) / 86400
		local h = (seconds % 31556925  % 86400) / 3600
		local m = (seconds % 31556925  % 86400  % 3600) / 60
		local s = (seconds % 31556925  % 86400  % 3600  % 60)

		if y >= 0x7FFFFFFE then
			return "OVERFLOW"
		end

		s = tonumber(format("%.1f", s))
		if s < 10 then
			s = "0" .. s
		end


		if y >= 1 then return format("%d:%d:%02d:%02d:%s", y, d, h, m, s) end
		if d >= 1 then return format("%d:%02d:%02d:%s", d, h, m, s) end
		if h >= 1 then return format("%d:%02d:%s", h, m, s) end
		return format("%d:%s", m, s)
	end),

	-- GLOBALS: DAY_ONELETTER_ABBR, HOUR_ONELETTER_ABBR, MINUTE_ONELETTER_ABBR, SECOND_ONELETTER_ABBR, SECONDS_ABBR
	TIME_YDHMS = Formatter:New(function(seconds)
		if abs(seconds) == math.huge then
			return tostring(seconds)
		end

		if seconds < 0 then
			error("This function doesn't support negative seconds")
		end
		
		local y =  seconds / 31556926
		local d = (seconds % 31556926) / 86400
		local h = (seconds % 31556926  % 86400) / 3600
		local m = (seconds % 31556926  % 86400  % 3600) / 60
		local s = (seconds % 31556926  % 86400  % 3600  % 60)
		
		if y >= 0x7FFFFFFE then
			return "OVERFLOW"
		end
		
		
		local str = ""
		
		if y >= 1 then 
			str = str .. format("%dy", y)
		end
		if d >= 1 then 
			local fmt = DAY_ONELETTER_ABBR:gsub(" ", "")
			str = str .. " " .. format(fmt, d)
		end
		if h >= 1 then 
			local fmt = HOUR_ONELETTER_ABBR:gsub(" ", "")
			str = str .. " " .. format(fmt, h)
		end
		if m >= 1 then 
			local fmt = MINUTE_ONELETTER_ABBR:gsub(" ", "")
			str = str .. " " .. format(fmt, m)
		end

		if tonumber(format("%.1f", s)) == s then
			s = tostring(s)
		else
			s = format("%0.1f", s)
		end
		
		local fmt
		if str == "" then
			fmt = SECONDS_ABBR:gsub("%%d", "%%s"):lower()
		else
			fmt = SECOND_ONELETTER_ABBR:gsub("%%d ", "%%s"):lower()
		end
		str = str .. " " .. format(fmt, s)
		
		return str:trim()
	end),

	TIME_0ABSENT = Formatter:New(function(value)
		local s = Formatter.TIME_YDHMS:Format(value)
		if value == 0 then
			s = s .. " ("..L["ICONMENU_ABSENT"]..")"
		end
		return s
	end),
	TIME_0USABLE = Formatter:New(function(value)
		local s = Formatter.TIME_YDHMS:Format(value)
		if value == 0 then
			s = s .. " ("..L["ICONMENU_USABLE"]..")"
		end
		return s
	end),

	BOOL = Formatter:New{[0]=L["TRUE"], [1]=L["FALSE"]},
	BOOL_USABLEUNUSABLE = Formatter:New{[0]=L["ICONMENU_USABLE"], [1]=L["ICONMENU_UNUSABLE"]},
	BOOL_PRESENTABSENT = Formatter:New{[0]=L["ICONMENU_PRESENT"], [1]=L["ICONMENU_ABSENT"]},
}







---------------------------------
-- Function Caching
---------------------------------

local cacheMetatable = {
	__mode = 'kv'
}

function TMW:MakeFunctionCached(obj, method)
	local func
	if type(obj) == "table" and type(method) == "string" then
		func = obj[method]
	elseif type(obj) == "function" then
		func = obj
	else
		error("Usage: TMW:MakeFunctionCached(object/function [, method])")
	end

	local cache = setmetatable({}, cacheMetatable)
	local wrapper = function(...)
		local cachestring = strjoin("\031", tostringall(...))
		
		if cache[cachestring] then
			return cache[cachestring]
		end

		local ret1, ret2 = func(...)
		if ret2 ~= nil then
			error("Cannot cache functions with more than 1 return arg")
		end

		cache[cachestring] = ret1

		return ret1
	end

	if type(obj) == "table" then
		obj[method] = wrapper
	end

	return wrapper, cache
end

function TMW:MakeNArgFunctionCached(argCount, obj, method)
	local func
	if type(obj) == "table" and type(method) == "string" then
		func = obj[method]
		argCount = argCount + 1 -- account for self
	elseif type(obj) == "function" then
		func = obj
	else
		error("Usage: TMW:MakeNArgFunctionCached(argCount, object/function [, method])")
	end

	-- Build up a function that works on the exact number of args expected.
	-- This function stores the return value in a series of nested tables,
	-- thereby requiring no string coersions or concatenations
	-- to form a cache key, making this a fair bit faster
	-- than the more general MakeFunctionCached.
	--[[
		In the following test, NArgFunctionCached performed 3.5x faster than MakeFunctionCached.
		At a 100% hit rate, it was about 3.6x better.
		At a very high miss rate (index = 10000000000), it was 3x better.
		With 4 arguments at high miss rate, it was 2.4x better.
		With 4 arguments at 100% hit rate, it was 4.3x better.


		function Baseline()
			return 1
		end

		local index = 10000
		local f1 = TMW:MakeFunctionCached(Baseline)
		local f2 = TMW:MakeNArgFunctionCached(1, Baseline)

		function Test1()
			f1(floor(random()*index))
		end
		function Test2()
			f2(floor(random()*index))
		end

	]]

	local funcStr = [[
			local cachemeta = { __mode = 'kv' }
			local cache = setmetatable({}, cachemeta)
			local nilKey = {}
			local func = ...
			return function(]]

	for i = 1, argCount do
		if i > 1 then funcStr = funcStr .. "," end
		funcStr = funcStr .. "arg" .. i
	end

	funcStr = funcStr .. [[)
	local next, prev, key = cache
	]]

	for i = 1, argCount do
		funcStr = funcStr .. "\n key = arg" .. i .. " == nil and nilKey or arg" .. i
		funcStr = funcStr .. "\n prev = next; next = prev[key]"
		if i < argCount then
			funcStr = funcStr .. "\n if not next then next = setmetatable({}, cachemeta) prev[key] = next end"
		end
	end

	funcStr = funcStr .. [[
	if next ~= nil then return next end
	local ret = func(]]
	for i = 1, argCount do
		if i > 1 then funcStr = funcStr .. "," end
		funcStr = funcStr .. "arg" .. i
	end
	funcStr = funcStr .. [[)
		prev[key] = ret
		return ret;
	end, cache
	]]

	local wrapper, cache = loadstring(funcStr)(func)

	if type(obj) == "table" then
		obj[method] = wrapper
	end

	return wrapper, cache
end

function TMW:MakeSingleArgFunctionCached(obj, method)
	-- MakeSingleArgFunctionCached is MUCH more efficient than MakeFunctionCached
	-- and should be used whenever there is only 1 input arg
	local func, firstarg
	if type(obj) == "table" and type(method) == "string" then
		func = obj[method]
		firstarg = obj
	elseif type(obj) == "function" then
		func = obj
	else
		error("Usage: TMW:MakeFunctionCached(object/function [, method])", 2)
	end

	local cache = setmetatable({}, cacheMetatable)
	local wrapper = function(arg1In, arg2In)
		local param1, param2 = arg1In, arg2In
		if firstarg and firstarg == arg1In then
			arg1In = arg2In
		elseif arg2In ~= nil then
			error("Cannot MakeSingleArgFunctionCached functions with more than 1 arg", 2)
		end
		
		if cache[arg1In] then
			return cache[arg1In]
		end

		local ret1, ret2 = func(param1, param2)
		if ret2 ~= nil then
			error("Cannot cache functions with more than 1 return arg", 2)
		end

		cache[arg1In] = ret1

		return ret1
	end

	if type(obj) == "table" then
		obj[method] = wrapper
	end

	return wrapper
end







---------------------------------
-- Output & Errors
---------------------------------

local warn = {}
function TMW:ResetWarn()
	for k, v in pairs(warn) do
		-- reset warnings so they can happen again
		if type(k) == "string" then
			warn[k] = nil
		end
	end
end
function TMW:DoInitialWarn()
	for k, v in ipairs(warn) do
		TMW:Print(v)
		warn[k] = true
	end
	
	TMW.Warned = true
	TMW.DoInitialWarn = TMW.NULLFUNC
end

function TMW:Warn(text)
	if warn[text] then
		return
	elseif TMW.Warned then
		TMW:Print(text)
		warn[text] = true
	elseif not TMW.tContains(warn, text) then
		tinsert(warn, text)
	end
end

function TMW:Debug(...)
	if TMW.debug or not TMW.Initialized then
		TMW.print(format(...))
	end
end

function TMW:Error(text, ...)
	text = text or ""
	local success, result = pcall(format, text, ...)
	if success then
		text = result
	end
	geterrorhandler()("TellMeWhen: " .. text)
end

function TMW:Assert(statement, text, ...)
	if not statement then
		text = text or "Assertion Failed!"
		local success, result = pcall(format, text, ...)
		if success then
			text = result
		end
		geterrorhandler()("TellMeWhen: " .. text)
	end
end







---------------------------------
-- Generic String Utilities
---------------------------------

local mult = {
	1,						-- seconds per second
	60,						-- seconds per minute
	60*60,					-- seconds per hour
	60*60*24,				-- seconds per day
	60*60*24*365.242199,	-- seconds per year
}
function TMW.toSeconds(str)
	-- converts a string (e.g. "1:45:37") into the number of seconds that it represents (eg. 6337)
	str = ":" .. str:trim(": ") -- a colon is needed at the beginning so that gmatch will catch the first unit of time in the string (minutes, hours, etc)
	local _, numcolon = str:gsub(":", ":") -- count the number of colons in the string so that we can keep track of what multiplier we are on (since we start with the highest unit of time)
	local seconds = 0
	
	for num in str:gmatch(":([0-9%.]*)") do -- iterate over all units of time and their value
		if tonumber(num) and mult[numcolon] then -- make sure that it is valid (there is a number and it isnt a unit of time higher than a year)
			seconds = seconds + mult[numcolon]*num -- multiply the number of units by the number of seconds in that unit and add the appropriate amount of time to the running count
		end
		numcolon = numcolon - 1 -- decrease the current unit of time that is being worked with (even if it was an invalid unit and failed the above check)
	end
	
	return seconds
end

local function replace(text, find, rep)
	-- using this allows for the replacement of ";	   " to "; " in one external call
	assert(not strfind(rep, find), "RECURSION DETECTED: FIND=".. find.. " REP=".. rep)
	while strfind(text, find) do
		text = gsub(text, find, rep)
	end
	return text
end
function TMW:CleanString(text)
	local frame
	if type(text) == "table" and text.GetText then
		frame = text
		text = text:GetText()
	end
	if not text then error("No text to clean!") end
	text = strtrim(text, "; \t\r\n")-- remove all leading and trailing semicolons, spaces, tabs, and newlines
	text = replace(text, "[^:] ;", "; ") -- remove all spaces before semicolons
	text = replace(text, "; ", ";") -- remove all spaces after semicolons
	text = replace(text, ";;", ";") -- remove all double semicolons

	-- Don't do this on the French client.
	-- https://www.iwillteachyoualanguage.com/learn/french/french-tips/french-punctuation
	if GetLocale() ~= "frFR" then
		text = replace(text, " :", ":") -- remove all single spaces before colons
	end

	text = replace(text, ":  ", ": ") -- remove all double spaces after colons (DONT REMOVE ALL DOUBLE SPACES EVERYWHERE, SOME SPELLS HAVE TYPO'd NAMES WITH 2 SPACES!)
	text = gsub(text, ";", "; ") -- add spaces after all semicolons. Never used to do this, but it just looks so much better (DONT USE replace!).
	if frame then
		frame:SetText(text)
	end
	return text
end

function TMW:CleanPath(path)
	if not path then
		return ""
	end
	
	return path:trim():gsub("\\\\", "/"):gsub("\\", "/"), nil
end

function TMW:SplitNames(input, stringsOnly)
	input = TMW:CleanString(input)
	local tbl = { strsplit(";", input) }
	if #tbl == 1 and tbl[1] == "" then
		tbl[1] = nil
	end

	for a, b in ipairs(tbl) do
		local new = strtrim(b) --remove spaces from the beginning and end of each name
		if not stringsOnly then
			new = tonumber(new) or new -- turn it into a number if it is one
		end
		tbl[a] = new
	end
	return tbl
end

TMW.SplitNamesCached = TMW.SplitNames
TMW:MakeSingleArgFunctionCached(TMW, "SplitNamesCached")


function TMW:FormatSeconds(seconds, skipSmall, keepTrailing)
	local ret = ""

	if abs(seconds) == math.huge then
		return tostring(seconds)
	elseif seconds < 0 then
		ret = "-"
		seconds = -seconds
	end

	local y =  seconds / 31556926
	local d = (seconds % 31556926) / 86400
	local h = (seconds % 31556926  % 86400) / 3600
	local m = (seconds % 31556926  % 86400  % 3600) / 60
	local s = (seconds % 31556926  % 86400  % 3600  % 60)

	local ns
	if skipSmall then
		ns = format("%d", s)
	else
		ns = format("%.1f", s)
		if not keepTrailing then
			ns = tonumber(ns)
		end
	end
	if s < 10 and seconds >= 60 then
		ns = "0" .. ns
	end

	if y >= 0x7FFFFFFE then
		ret = ret .. format("OVERFLOW:%d:%02d:%02d:%s", d, h, m, ns)
	elseif y >= 1 then
		ret = ret .. format("%d:%d:%02d:%02d:%s", y, d, h, m, ns)
	elseif d >= 1 then
		ret = ret .. format("%d:%02d:%02d:%s", d, h, m, ns)
	elseif h >= 1 then
		ret = ret .. format("%d:%02d:%s", h, m, ns)
	elseif m >= 1 then
		ret = ret .. format("%d:%s", m, ns)
	else
		ret = ret .. ns
	end

	return ret
end







---------------------------------
-- Color Utilities
---------------------------------

local flagMap = {
	d = "desaturate"
}

local function parseFlagString(flagString)
	if not flagString or #flagString == 0 then
		return nil
	end
	
	local ret = {}
	for i = 1, #flagString do
		local f = flagString:sub(i,i)
		ret[flagMap[f] or f] = true
	end
	return ret
end

local function parseFlagTable(tbl)
	if not tbl then return "" end
	local ret = ""
	for k, v in pairs(tbl) do
		if v then
			local f = TMW.tContains(flagMap, k)
			if f or #k == 1 then
				ret = ret .. (f or k)
			end
		end
	end
	return ret
end

function TMW:RGBATableToStringWithoutFlags(table)
	if type(table) == "string" then
		return table
	end

	return TMW:RGBAToString(table.r, table.g, table.b, table.a)
end

function TMW:RGBATableToStringWithFallback(table, fallbackStr)
	if type(table) == "string" then
		return table
	elseif not table then
		return fallbackStr
	end

	local r, g, b, a, flags = TMW:StringToRGBA(fallbackStr)
	
	return TMW:RGBAToString(table.r or r, table.g or g, table.b or b, table.a or a, table.flags or flags)
end

local function to8Bit(v)
	return floor(v * 0xFF + 0.5)
end
function TMW:RGBAToString(r, g, b, a, flags)
	return format("%02x%02x%02x%02x%s", to8Bit(a or 1), to8Bit(r), to8Bit(g), to8Bit(b), parseFlagTable(flags))
end

function TMW:StringToRGBA(str)
	local a, r, g, b, flagString = str:match("(%x%x)(%x%x)(%x%x)(%x%x)(.*)")

	return tonumber(r, 0x10) / 0xFF, tonumber(g, 0x10) / 0xFF, tonumber(b, 0x10) / 0xFF, tonumber(a, 0x10) / 0xFF, parseFlagString(flagString)
end

function TMW:StringToCachedRGBATable(str)
	if type(str) == "table" then
		return str
	end

	local r, g, b, a, flags = TMW:StringToRGBA(str)
	return {r=r,g=g,b=b,a=a, flags=flags}
end
TMW:MakeSingleArgFunctionCached(TMW, "StringToCachedRGBATable")


-- Adapted from https://github.com/mjackson/mjijackson.github.com/blob/master/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript.txt
function TMW:RGBToHSV(r, g, b)
	local max, min = max(r, g, b), min(r, g, b)
	local h, s, v
	v = max

	local d = max - min
	if max == 0 then
		s = 0 else s = d / max
	end

	if max == min then
		h = 0 -- achromatic
	else
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h, s, v
end

function TMW:HSVToRGB(h, s, v)
	local r, g, b

	local i = floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r, g, b
end

local getColorsTemp = {}
function TMW:GetColors(colorSettings, enableSetting, ...)
	if not colorSettings then
		error("colorSettings missing")
	end
	for n, settings, length in TMW:Vararg(...) do
		if n == length or settings[enableSetting] then
			if type(colorSettings) == "table" then
				for i = 1, #colorSettings do
					getColorsTemp[i] = settings[colorSettings[i]]
				end

				return unpack(getColorsTemp, 1, #colorSettings)
			else
				return settings[colorSettings]
			end
		end
	end
end

function TMW:ColorStringToCachedHSVATable(str)
	local r, g, b, a, flags = TMW:StringToRGBA(str)
	local h, s, v = TMW:RGBToHSV(r, g, b)
	return {h=h, s=s, v=v, a=a, flags=flags}
end
TMW:MakeSingleArgFunctionCached(TMW, "ColorStringToCachedHSVATable")

function TMW:HSVAToColorString(h, s, v, a, flags)
	local r, g, b = TMW:HSVToRGB(h, s, v)
	return TMW:RGBAToString(r, g, b, a, flags)
end





---------------------------------
-- Table Utilities
---------------------------------

function TMW.map(t, func)
	local new = {}
	for k, v in pairs(t) do
		local newV, newK = func(v, k, t)
		new[newK or k] = newV or v
	end
	return new
end

function TMW.approachTable(t, ...)
	for i=1, select("#", ...) do
		local k = select(i, ...)
		if type(k) == "function" then
			t = k(t)
		else
			t = t[k]
		end
		if not t then return end
	end
	return t
end

function TMW.shallowCopy(t)
	local new = {}
	for k, v in pairs(t) do
		new[k] = v
	end
	return new
end

function TMW.tContains(table, item, returnNum)
	local firstkey
	local num = 0
	for k, v in pairs(table) do
		if v == item then
			if not returnNum then
				-- Return only the key of the first match
				return k
			else
				num = num + 1
				firstkey = firstkey or k
			end
		end
	end

	-- Return the key of the first match and also the total number of matches
	return firstkey, num
end

function TMW.tDeleteItem(table, item, onlyOne)
	local i = 1
	local removed
	while table[i] do
		if item == table[i] then
			tremove(table, i)
			if onlyOne then
				return true
			end
			removed = true
		else
			i = i + 1
		end
	end

	return removed
end

function TMW.tRemoveDuplicates(table)

	local offs = 0

	-- Start at the end of the table so that we don't remove duplicates from the beginning
	for k = #table, 1, -1 do

		-- offs is adjusted each time something is removed so that we don't waste time
		-- searching for nil values when the table is shifted by a duplicate removal
		k = k + offs

		-- If we have reached the beginning of the table, we are done.
		if k <= 0 then
			return table
		end
		
		-- item is the value being searched for
		local item = table[k]

		-- prevIndex tracks the last index where the searched-for value was found
		local prevIndex

		-- Once again start the iteration from the end because we don't want to have to 
		-- deal with index shifting when we remove a value
		for i = #table, 1, -1 do
			if table[i] == item then

				-- We found a match. If there has already been another match, remove that match 
				-- and record this match as being the first one (closes to index 0) in the table.
				if prevIndex then
					tremove(table, prevIndex)
					offs = offs - 1
				end

				-- Queue this match for removal should we find another match closer to the beginning.
				prevIndex = i
			end
		end
	end

	-- Done. Return the table for ease-of-use.
	return table
end

local comp_default = function(a,b) return a < b end
function TMW.binaryInsert(table, value, comp)
	-- http://lua-users.org/wiki/BinaryInsert
	comp = comp or comp_default

	local iStart, iEnd, iMid, iState =
		  1, #table, 1, 0

	while iStart <= iEnd do
		iMid = floor((iStart+iEnd) / 2)

		if comp(value, table[iMid]) then
			iEnd, iState = iMid-1, 0
		else
			iStart, iState = iMid+1, 1
		end
	end
	tinsert(table, iMid + iState, value)
	return (iMid+iState)
end

function TMW.OrderSort(a, b)
	a = a.Order or a.order
	b = b.Order or b.order
	if a and b then
		return a < b
	else
		error("Missing 'order' or 'Order' key for values of OrderedTable")
	end
end
function TMW:SortOrderedTables(parentTable)
	sort(parentTable, TMW.OrderSort)
	return parentTable
end

function TMW:CopyWithMetatable(source, blocker)	
	local dest = {}
	
	for k, v in pairs(source) do
		local keyBlocker = blocker and blocker[k]

		if keyBlocker ~= true then
			if type(v) == "table" then
				dest[k] = TMW:CopyWithMetatable(v, keyBlocker)
			else
				dest[k] = v
			end
		end
	end

	return setmetatable(dest, getmetatable(source))
end

function TMW:CopyInPlaceWithMetatable(source, dest, blocker)
	setmetatable(dest, getmetatable(source))

	for key in pairs(source) do
		local keyBlocker = blocker and blocker[key]

		if keyBlocker ~= true then
			if type(source[key]) == "table" then
				if type(dest[key]) ~= "table" then
					dest[key] = {}
				end

				TMW:CopyInPlaceWithMetatable(source[key], dest[key], keyBlocker)
			else
				dest[key] = source[key]
			end
		end
	end
end

function TMW:CopyTableInPlaceUsingDestinationMeta(src, dest, allowUnmatchedSourceTables)
	-- src and dest must have congruent data structure.
	-- There are no safety checks to ensure this.

	-- Save the original metatable so it doesn't get overwritten.
	local metatemp = getmetatable(src) 
	setmetatable(src, getmetatable(dest))

	for k in pairs(src) do
		if type(dest[k]) == "table" and type(src[k]) == "table" then
			TMW:CopyTableInPlaceUsingDestinationMeta(src[k], dest[k], allowUnmatchedSourceTables)
		elseif allowUnmatchedSourceTables and type(dest[k]) ~= "table" and type(src[k]) == "table" then
			dest[k] = {}
			TMW:CopyTableInPlaceUsingDestinationMeta(src[k], dest[k], allowUnmatchedSourceTables)
		elseif type(src[k]) ~= "table" then
			dest[k] = src[k]
		end
	end

	-- Restore the old metatable
	setmetatable(src, metatemp) 

	return dest
end

function TMW:DeepCompare(t1, t2)
	-- heavily modified version of http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3

	-- attempt direct comparison
	if t1 == t2 then
		return true
	end

	-- if the values are not the same (they made it through the check above) AND they are not both tables, then they cannot be the same, so exit.
	local ty1 = type(t1)
	if ty1 ~= "table" or ty1 ~= type(t2) then
		return false
	end

	-- compare table values

	-- compare table 1 with table 2
	for k1, v1 in pairs(t1) do
		local v2 = t2[k1]

		-- don't bother calling DeepCompare on the values if they are the same - it will just return true.
		-- Only call it if the values are different (they are either 2 tables, or they actually are different non-table values)
		-- by adding the (v1 ~= v2) check, efficiency is increased by about 300%.
		if v1 ~= v2 and not TMW:DeepCompare(v1, v2) then
			return false
		end
	end

	-- compare table 2 with table 1
	for k2, v2 in pairs(t2) do
		local v1 = t1[k2]

		-- see comments for t1
		if v1 ~= v2 and not TMW:DeepCompare(v1, v2) then
			return false
		end
	end

	return true
end

do	-- TMW.shellsortDeferred
	-- From http://lua-users.org/wiki/LuaSorting - shellsort
	-- Written by Rici Lake. The author disclaims all copyright and offers no warranty.
	--
	-- This module returns a single function (not a table) whose interface is upwards-
	-- compatible with the interface to table.sort:
	--
	-- array = shellsort(array, before, n)
	-- array is an array of comparable elements to be sorted in place
	-- before is a function of two arguments which returns true if its first argument
	--    should be before the second argument in the second result. It must define
	--    a total order on the elements of array.
	--      Alternatively, before can be one of the strings "<" or ">", in which case
	--    the comparison will be done with the indicated operator.
	--    If before is omitted, the default value is "<"
	-- n is the number of elements in the array. If it is omitted, #array will be used.
	-- For convenience, shellsort returns its first argument.

	-- A036569
	local incs = { 8382192, 3402672, 1391376,
		463792, 198768, 86961, 33936,
		13776, 4592, 1968, 861, 336, 
	112, 48, 21, 7, 3, 1 }

	local execCap = 17
	local start = 0
	
	local function ssup(v, testval)
		return v < testval
	end
	
	local function ssdown(v, testval)
		return v > testval
	end
	
	local function ssgeneral(t, n, before, progressCallback, progressCallbackArg)
		local lastProgress = 100

		for idx, h in ipairs(incs) do
			local count = 1
			for i = h + 1, n do
				local v = t[i]
				for j = i - h, 1, -h do
					local testval = t[j]
					if not before(v, testval) then break end
					t[i] = testval; i = j
				end
				t[i] = v

				count = count + 1

				if (count % 200 == 0) and debugprofilestop() - start > execCap then
					local progress = #incs - idx + 1

					if progressCallback and progress ~= lastProgress then
						if progressCallbackArg then
							progressCallback(progressCallbackArg, progress)
						else
							progressCallback(progress)
						end
						lastProgress = progress
					end
					
					coroutine.yield()
				end
			end
		end
		return t
	end
	
	local coroutines = {}
	local function shellsort(t, before, n, callback, callbackArg, progressCallback, progressCallbackArg)
		n = n or #t
		if not before or before == "<" then
			ssgeneral(t, n, ssup, progressCallback, progressCallbackArg)
		elseif before == ">" then
			ssgeneral(t, n, ssdown, progressCallback, progressCallbackArg)
		else
			ssgeneral(t, n, before, progressCallback, progressCallbackArg)
		end

		if callbackArg ~= nil then
			callback(callbackArg)
		else
			callback()
		end

		coroutines[t] = nil
	end
	
	local timer

	local function OnUpdate()
		local table, co = next(coroutines)

		if table then
			if coroutine.status(co) == "dead" then
				-- This might happen if there was an error thrown before the coroutine could finish.
				coroutines[table] = nil
				return
			end
			-- dynamic execution cap based on framerate.
			-- this will keep us from dropping the user's framerate too much
			-- without doing so little sorting that the process goes super slowly.
			-- subtract a little bit to account for CPU usage for other things, like the game itself.
			execCap = 1000/max(20, GetFramerate()) - 5

			start = debugprofilestop()
			assert(coroutine.resume(co))
		end

		if not next(coroutines) then
			timer:Cancel()
			timer = nil
		end
	end

	-- The purpose of shellSortDeferred is to have a sort that won't
	-- lock up the game when we sort huge things.
	function TMW.shellsortDeferred(t, before, n, callback, callbackArg, progressCallback, progressCallbackArg)
		local co = coroutine.create(shellsort)
		coroutines[t] = co
		start = debugprofilestop()

		if not timer then
			timer = C_Timer.NewTicker(0.001, OnUpdate)
		end

		assert(coroutine.resume(co, t, before, n, callback, callbackArg, progressCallback, progressCallbackArg))
	end
end







---------------------------------
-- Iterator Functions
---------------------------------

do -- InNLengthTable
	local states = {}
	local function getstate(k, t)
		local state = wipe(tremove(states) or {})

		state.k = k
		state.t = t

		return state
	end

	local function iter(state)
		state.k = state.k + 1

		if state.k > (state.t.n or #state.t) then -- #t enables iteration over tables that have not yet been upgraded with an n key (i.e. imported data from old versions)
			tinsert(states, state)
			return
		end
	--	return state.t[state.k], state.k --OLD, STUPID IMPLEMENTATION
		return state.k, state.t[state.k]
	end

	--- Iterates over an array-style table that has a key "n" to indicate the length of the table.
	-- Returns (key, value) pairs for each iteration.
	function TMW:InNLengthTable(arg)
		if arg then
			return iter, getstate(0, arg)
		else
			error("Bad argument #1 to 'TMW:InNLengthTable(arg)'. Expected table, got nil.", 2)
		end
	end
end

do -- ordered pairs

	local sortByValues, compareFunc, reverse

	-- An alternative comparison function that can handle mismatched types.
	local function betterCompare(a, b)
		local ta, tb = type(a), type(b)
		if ta ~= tb then
			if reverse then
				return ta > tb
			end
			return ta < tb
		elseif ta == "number" or ta == "string" then
			if reverse then
				return a > b
			end
			return a < b
		elseif ta == "boolean" then
			if reverse then
				return b == true
			end
			return a == true
		else
			if reverse then
				return tostring(a) > tostring(b)
			end
			return tostring(a) < tostring(b)
		end
	end

	local function sorter(a, b)
		if sortByValues then
			a, b = sortByValues[a], sortByValues[b]
		end

		if compareFunc then
			return compareFunc(a, b)
		end

		if reverse then
			return a > b
		end
		return a < b

		--return compare(a, b)
	end

	local iterIndexes = {}
	local tables = {}
	local unused = {}

	local function orderedNext(orderedIndex)
		local t = tables[orderedIndex]

		local i = iterIndexes[orderedIndex]
		local key = orderedIndex[i]
		iterIndexes[orderedIndex] = i + 1

		if key then
			return key, t[key]
		end

		unused[#unused+1] = wipe(orderedIndex)
		tables[orderedIndex] = nil
		iterIndexes[orderedIndex] = nil
		return
	end

	--- Iterates over the table in an ordered fashion, without modifying the table.
	-- @param t [table] The table to iterate over
	-- @param compare [function|nil] The comparison function that will be used for sorting the keys or values of the table. Defaults to regular ascending order.
	-- @param byValues [boolean|nil] True to have the iteration order based on values (values will be passed to the compare function if defined), false/nil to sort by keys.
	-- @param rev [boolean|nil] True to reverse the sorted order of the iteration.
	-- @return Iterator that will return (key, value) for each iteration.
	function TMW:OrderedPairs(t, compare, byValues, rev)
		if not next(t) then
			return TMW.NULLFUNC
		end

		local orderedIndex = tremove(unused) or {}
		local prevType = nil
		for key, value in pairs(t) do
			orderedIndex[#orderedIndex + 1] = key

			-- Determine the types of what we're comparing by.
			-- If we find more than one type, use betterCompare since it handles type mismatches.
			if compare == nil then
				local comparandType = byValues and type(value) or type(key)
				if prevType and prevType ~= comparandType then
					compare = betterCompare
				end
				prevType = comparandType
			end
		end

		reverse = rev
		compareFunc = compare

		if byValues then
			sortByValues = t
		else
			sortByValues = nil
		end

		sort(orderedIndex, sorter)
		tables[orderedIndex] = t
		iterIndexes[orderedIndex] = 1

		return orderedNext, orderedIndex
	end
end







---------------------------------
-- Tooltips
---------------------------------

local function TTOnEnter(self)
	-- GLOBALS: GameTooltip, HIGHLIGHT_FONT_COLOR, NORMAL_FONT_COLOR

	if  (not self.__ttshowchecker or TMW.get(self[self.__ttshowchecker], self))
	and (self.__title or self.__text)
	then
		TMW:TT_Anchor(self)
		if self.__ttMinWidth then
			GameTooltip:SetMinimumWidth(self.__ttMinWidth)
		end

		GameTooltip:AddLine(TMW.get(self.__title, self), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, false)
		local text = TMW.get(self.__text, self)
		if text then
			GameTooltip:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, not self.__noWrapTooltipText)
		end
		GameTooltip:Show()
	end
end
local function TTOnLeave(self)
	GameTooltip:Hide()
end

function TMW:TT_Anchor(f)
	GameTooltip:SetOwner(f, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, 0)
end

function TMW:TT(f, title, text, actualtitle, actualtext, showchecker)
	-- setting actualtitle or actualtext true cause it to use exactly what is passed in for title or text as the text in the tooltip
	-- if these variables arent set, then it will attempt to see if the string is a global variable (e.g. "MAXIMUM")
	-- if they arent set and it isnt a global, then it must be a TMW localized string, so use that

	TMW:ValidateType(2, "TMW:TT()", f, "frame")
	
	f.__title = TMW:TT_Parse(title, actualtitle)
	f.__text = TMW:TT_Parse(text, actualtext)
	
	f.__ttshowchecker = showchecker

	if not f.__ttHooked then
		f.__ttHooked = 1
		f:HookScript("OnEnter", TTOnEnter)
		f:HookScript("OnLeave", TTOnLeave)
	else
		if not f:GetScript("OnEnter") then
			f:HookScript("OnEnter", TTOnEnter)
		end
		if not f:GetScript("OnLeave") then
			f:HookScript("OnLeave", TTOnLeave)
		end
	end
end

function TMW:TT_Parse(text, literal)
	if text then
		return (literal and text) or _G[text] or L[text]
	else
		return text
	end
end

function TMW:TT_Copy(src, dest)
	TMW:TT(dest, src.__title, src.__text, 1, 1, src.__ttshowchecker)
end

function TMW:TT_Update(f)
	if GetMouseFocus() == f and f:IsMouseOver() and f:IsVisible() then
		f:GetScript("OnLeave")(f)
		if not f.IsEnabled or f:IsEnabled() or (f:IsObjectType("Button") and f:GetMotionScriptsWhileDisabled()) then
			f:GetScript("OnEnter")(f)
		end
	end
end







---------------------------------
-- Misc. Utilities
---------------------------------

function TMW.get(value, ...)
	local type = type(value)
	if type == "function" then
		return value(...)
	elseif type == "table" then
		return value[...]
	else
		return value
	end
end

function TMW.NULLFUNC()
	-- Do nothing
end

function TMW.oneUpString(string)
	if string:find("%d+") then
		local num = tonumber(string:match("(%d+)"))
		if num then
			string = string:gsub(("(%d+)"), num + 1, 1)
			return string
		end
	end
	return string .. " 2"
end

TMW.CompareFuncs = {
	-- more efficient than a big elseif chain.
	["=="] = function(a, b) return a == b  end,
	["~="] = function(a, b) return a ~= b end,
	[">="] = function(a, b) return a >= b end,
	["<="] = function(a, b) return a <= b  end,
	["<"] = function(a, b) return a < b  end,
	[">"] = function(a, b) return a > b end,
}

local animator = CreateFrame("Frame")
animator.frames = {}
animator.OnUpdate = function()
	for f in pairs(animator.frames) do
		if TMW.time - f.__animateHeight_startTime > f.__animateHeight_duration then
			animator.frames[f] = nil
			f:SetClipsChildren(f.__animateHeight_wasClipping)
			f:SetHeight(f.__animateHeight_end)
		else
			local pct = (TMW.time - f.__animateHeight_startTime)/f.__animateHeight_duration
			
			f:SetHeight((pct*f.__animateHeight_delta)+f.__animateHeight_start)
		end
	end

	if not next(animator.frames) then
		animator:SetScript("OnUpdate", nil)
	end
end

function TMW:AnimateHeightChange(f, endHeight, duration)
	f.__animateHeight_start = f:GetHeight()
	f.__animateHeight_end = endHeight
	f.__animateHeight_delta = f.__animateHeight_end - f.__animateHeight_start
	f.__animateHeight_startTime = TMW.time
	f.__animateHeight_duration = duration
	f.__animateHeight_wasClipping = f:DoesClipChildren()
	f:SetClipsChildren(true)
	animator.frames[f] = true

	animator:SetScript("OnUpdate", animator.OnUpdate)
end





---------------------------------
-- WoW API Helpers
---------------------------------

function TMW.SpellHasNoMana(spell)
	-- TODO: in warlords, you can't determine spell costs anymore. Thanks, blizzard!
	-- This function used to get the spell cost, and determine usability from that, 
	-- but we can't do that anymore. It was a more reliable method because IsUsableSpell
	-- was broken for some abilities (like Jab)

	local _, nomana = IsUsableSpell(spell)
	return nomana
end

function TMW.GetRuneCooldownDuration()
	-- Round to a precision of 3 decimal points for comparison with returns from GetSpellCooldown
	local _, duration = GetRuneCooldown(1)
	if not duration then return 0 end
	return floor(duration * 1e3 + 0.5) / 1e3
end

local function spellCostSorter(a, b)
	local hasA = a.requiredAuraID ~= 0 and a.hasRequiredAura
	local hasB = b.requiredAuraID ~= 0 and b.hasRequiredAura
	if hasA ~= hasB then
		return hasA
	end

	hasA = a.hasRequiredAura
	hasB = b.hasRequiredAura
	if hasA ~= hasB then
		return hasA
	end

	return a.requiredAuraId == 0
end

function TMW.GetSpellCost(spell)
	local costs = GetSpellPowerCost(spell)
	if not costs or #costs == 0 then
		return nil, nil
	end

	local cost
	if #costs == 1 then
		cost = costs[1]
	else
		sort(costs, spellCostSorter)

		cost = costs[1]
	end

	if cost.requiredAuraID ~= 0 and not cost.hasRequiredAura then
		return nil, cost
	end

	if cost.cost == 0 and cost.costPercent > 0 then
		return UnitPower("player", cost.type) * cost.costPercent / 100, cost
	else
		return cost.cost, cost
	end
end

function TMW.GetCurrentSpecializationRole()
	-- Watch for PLAYER_SPECIALIZATION_CHANGED for changes to this func's return, and to
	-- UPDATE_SHAPESHIFT_FORM if the player is a warrior.
	local currentSpec = GetSpecialization()
	if not currentSpec then
		return nil
	end

	local _, _, _, _, role = GetSpecializationInfo(currentSpec)
	return role
end

do	-- TMW:GetParser()
	local Parser, LT1, LT2, LT3, RT1, RT2, RT3
	function TMW:GetParser()
		if not Parser then
			Parser = CreateFrame("GameTooltip")

			LT1 = Parser:CreateFontString()
			RT1 = Parser:CreateFontString()
			Parser:AddFontStrings(LT1, RT1)

			LT2 = Parser:CreateFontString()
			RT2 = Parser:CreateFontString()
			Parser:AddFontStrings(LT2, RT2)

			LT3 = Parser:CreateFontString()
			RT3 = Parser:CreateFontString()
			Parser:AddFontStrings(LT3, RT3)
		end
		return Parser, LT1, LT2, LT3, RT1, RT2, RT3
	end
end


-- From Interface/GlueXML/CharacterCreate
local fixedRaceAtlasNames = {
	["highmountaintauren"] = "highmountain",
	["lightforgeddraenei"] = "lightforged",
	["scourge"] = "undead"
};
function TMW:GetRaceIconInfo(race)
	race = race:lower()
	race = fixedRaceAtlasNames[race] or race
	local gender = UnitSex('player') == 2 and "male" or "female"
	return ("raceicon-%s-%s"):format(race, gender)
end
TMW:MakeSingleArgFunctionCached(TMW, "GetRaceIconInfo")

function TMW:TryGetNPCName(id)
    local tooltip, LT1 = TMW:GetParser()
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetHyperlink( string.format( "unit:Creature-0-0-0-0-%d:0000000000", id))
    
    return LT1:GetText()
end

-- From Blizzard_TutorialLogic.lua
function TMW:FormatAtlasString(atlasName, trimPercent)
	local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(atlasName);
	trimPercent = trimPercent or 0

	if (not filename) then return; end

	local atlasWidth = width / (txRight - txLeft);
	local atlasHeight = height / (txBottom - txTop);

	local pxLeft	= atlasWidth	* txLeft + (width * trimPercent);
	local pxRight	= atlasWidth	* txRight - (width * trimPercent);
	local pxTop		= atlasHeight	* txTop + (height * trimPercent);
	local pxBottom	= atlasHeight	* txBottom - (height * trimPercent);

	return string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom);
end

---------------------------------
-- User-Defined Lua Import Detection
---------------------------------

local detectors = {}
function TMW:RegisterLuaImportDetector(func)
	detectors[func] = true
end

local function recursivelyDetectLua(results, table, ...)
	if type(table) == "table" then
		for func in pairs(detectors) do
			local success, code, name = TMW.safecall(func, table, ...)

			if success and code then
				tinsert(results, {code = code, name = name})
			end
		end

		for a, b in pairs(table) do
			recursivelyDetectLua(results, b, a, ...)
		end
	end
end
function TMW:DetectImportedLua(table)
	local results = {}

	recursivelyDetectLua(results, table)

	if #results == 0 then
		return nil
	end

	return results
end


function TMW:ClickSound()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
end

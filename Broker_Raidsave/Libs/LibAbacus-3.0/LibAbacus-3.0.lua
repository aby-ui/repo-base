--[[
Name: LibAbacus-3.0
Revision: $Rev: 46 $
Author(s): ckknight (ckknight@gmail.com)
Website: http://ckknight.wowinterface.com/
Documentation: http://www.wowace.com/wiki/LibAbacus-3.0
SVN: http://svn.wowace.com/wowace/trunk/LibAbacus-3.0
Description: A library to provide tools for formatting money and time.
License: LGPL v2.1
]]

local MAJOR_VERSION = "LibAbacus-3.0"
local MINOR_VERSION = tonumber(("$Revision: 46 $"):match("(%d+)")) + 90000

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end
local Abacus, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not Abacus then
	return
end

local gsub = string.gsub

local COPPER_ABBR
local SILVER_ABBR
local GOLD_ABBR
local GOLD, SILVER, COPPER = GOLD, SILVER, COPPER

if not COPPER and COPPER_AMOUNT then
	GOLD = GOLD_AMOUNT:gsub("%s*%%d%s*", "")
	SILVER = SILVER_AMOUNT:gsub("%s*%%d%s*", "")
	COPPER = COPPER_AMOUNT:gsub("%s*%%d%s*", "")
end

if (COPPER:byte(1) or 128) > 127 then
	-- non-western
	COPPER_ABBR = COPPER
	SILVER_ABBR = SILVER
	GOLD_ABBR = GOLD
else
	COPPER_ABBR = COPPER:sub(1, 1):lower()
	SILVER_ABBR = SILVER:sub(1, 1):lower()
	GOLD_ABBR = GOLD:sub(1, 1):lower()
end

local DAYS_ABBR_S1, HOURS_ABBR_S1, MINUTES_ABBR_S1, SECONDS_ABBR_S1
local DAYS_ABBR_P1, HOURS_ABBR_P1, MINUTES_ABBR_P1, SECONDS_ABBR_P1 = DAYS_ABBR_P1, HOURS_ABBR_P1, MINUTES_ABBR_P1, SECONDS_ABBR_P1

if not DAYS_ABBR_P1 then
	DAYS_ABBR_S1 = gsub(DAYS_ABBR, ".*|4(.-):.-;.*", "%1")
	DAYS_ABBR_P1 = gsub(DAYS_ABBR, ".*|4.-:(.-);.*", "%1")

	HOURS_ABBR_S1 = gsub(HOURS_ABBR, ".*|4(.-):.-;.*", "%1")
	HOURS_ABBR_P1 = gsub(HOURS_ABBR, ".*|4.-:(.-);.*", "%1")

	MINUTES_ABBR_S1 = gsub(MINUTES_ABBR, ".*|4(.-):.-;.*", "%1")
	MINUTES_ABBR_P1 = gsub(MINUTES_ABBR, ".*|4.-:(.-);.*", "%1")

	SECONDS_ABBR_S1 = gsub(SECONDS_ABBR, ".*|4(.-):.-;.*", "%1")
	SECONDS_ABBR_P1 = gsub(SECONDS_ABBR, ".*|4.-:(.-);.*", "%1")
else
	DAYS_ABBR_S1 = DAYS_ABBR 
	HOURS_ABBR_S1 = HOURS_ABBR
	MINUTES_ABBR_S1 = MINUTES_ABBR
	SECONDS_ABBR_S1 = SECONDS_ABBR
end


local COLOR_WHITE = "ffffff"
local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_COPPER = "eda55f"
local COLOR_SILVER = "c7c7cf"
local COLOR_GOLD = "ffd700"

local L_DAY_ONELETTER_ABBR    = DAY_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_HOUR_ONELETTER_ABBR   = HOUR_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_MINUTE_ONELETTER_ABBR = MINUTE_ONELETTER_ABBR:gsub("%s*%%d%s*", "")
local L_SECOND_ONELETTER_ABBR = SECOND_ONELETTER_ABBR:gsub("%s*%%d%s*", "")

local L_UNDETERMINED = "Undetermined"

if ( GetLocale() =="koKR" ) then
	L_UNDETERMINED = "측정불가"
elseif ( GetLocale() == "zhTW" ) then
	COPPER_ABBR = "銅"
	SILVER_ABBR = "銀"
	GOLD_ABBR = "金"

	L_UNDETERMINED = "未定義的"
	
--***************************************
-- zhCN Chinese Simplify
-- 2007/09/19 CN3羽月 雪夜之狼
-- 请保留本翻译作者名 谢谢
-- E=mail:xionglingfeng@Gmail.com
-- Website:http://www.wowtigu.org  (Chs)
--***************************************
elseif ( GetLocale() == "zhCN" ) then
	COPPER_ABBR = "铜"
	SILVER_ABBR = "银"
	GOLD_ABBR = "金"

	L_UNDETERMINED = "未定义的"
--***************************************
-- ruRU Russian, 2008-08-04
-- Author: SLA80, sla80x at Gmail com
--***************************************
elseif ( GetLocale() == "ruRU" ) then
	GOLD, SILVER, COPPER = "золота", "серебра", "меди"
	GOLD_ABBR, SILVER_ABBR, COPPER_ABBR = "з", "с", "м"
	DAYS_ABBR_P1 = "дней"
	HOURS_ABBR_S1, HOURS_ABBR_P1 = "ч.", "ч."
	MINUTES_ABBR_S1, MINUTES_ABBR_P1 = "мин.", "мин."
	SECONDS_ABBR_S1, SECONDS_ABBR_P1 = "сек.", "сек."
	L_UNDETERMINED = "Неопределено"
end

local inf = math.inf

function Abacus:FormatMoneyExtended(value, colorize, textColor)
	local gold = abs(value / 10000)
	local silver = abs(mod(value / 100, 100))
	local copper = abs(mod(value, 100))
	
	local negl = ""
	local color = COLOR_WHITE
	if value > 0 then
		if textColor then
			color = COLOR_GREEN
		end
	elseif value < 0 then
		negl = "-"
		if textColor then
			color = COLOR_RED
		end
	end
	if colorize then
		if value == inf or value == -inf then
			return format("|cff%s%s|r", color, value)
		elseif value ~= value then
			return format("|cff%s0|r|cff%s %s|r", COLOR_WHITE, COLOR_COPPER, COPPER)
		elseif value >= 10000 or value <= -10000 then
			return format("|cff%s%s%d|r|cff%s %s|r |cff%s%d|r|cff%s %s|r |cff%s%d|r|cff%s %s|r", color, negl, gold, COLOR_GOLD, GOLD, color, silver, COLOR_SILVER, SILVER, color, copper, COLOR_COPPER, COPPER)
		elseif value >= 100 or value <= -100 then
			return format("|cff%s%s%d|r|cff%s %s|r |cff%s%d|r|cff%s %s|r", color, negl, silver, COLOR_SILVER, SILVER, color, copper, COLOR_COPPER, COPPER)
		else
			return format("|cff%s%s%d|r|cff%s %s|r", color, negl, copper, COLOR_COPPER, COPPER)
		end
	else
		if value == inf or value == -inf then
			return format("%s", value)
		elseif value ~= value then
			return format("0 %s", COPPER)
		elseif value >= 10000 or value <= -10000 then
			return format("%s%d %s %d %s %d %s", negl, gold, GOLD, silver, SILVER, copper, COPPER)
		elseif value >= 100 or value <= -100 then
			return format("%s%d %s %d %s", negl, silver, SILVER, copper, COPPER)
		else
			return format("%s%d %s", negl, copper, COPPER)
		end
	end
end

function Abacus:FormatMoneyFull(value, colorize, textColor)
	local gold = abs(value / 10000)
	local silver = abs(mod(value / 100, 100))
	local copper = abs(mod(value, 100))
	
	local negl = ""
	local color = COLOR_WHITE
	if value > 0 then
		if textColor then
			color = COLOR_GREEN
		end
	elseif value < 0 then
		negl = "-"
		if textColor then
			color = COLOR_RED
		end
	end
	if colorize then
		if value == inf or value == -inf then
			return format("|cff%s%s|r", color, value)
		elseif value ~= value then
			return format("|cff%s0|r|cff%s%s|r", COLOR_WHITE, COLOR_COPPER, COPPER_ABBR)
		elseif value >= 10000 or value <= -10000 then
			return format("|cff%s%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r", color, negl, gold, COLOR_GOLD, GOLD_ABBR, color, silver, COLOR_SILVER, SILVER_ABBR, color, copper, COLOR_COPPER, COPPER_ABBR)
		elseif value >= 100 or value <= -100 then
			return format("|cff%s%s%d|r|cff%s%s|r |cff%s%d|r|cff%s%s|r", color, negl, silver, COLOR_SILVER, SILVER_ABBR, color, copper, COLOR_COPPER, COPPER_ABBR)
		else
			return format("|cff%s%s%d|r|cff%s%s|r", color, negl, copper, COLOR_COPPER, COPPER_ABBR)
		end
	else
		if value == inf or value == -inf then
			return format("%s", value)
		elseif value ~= value then
			return format("0%s", COPPER_ABBR)
		elseif value >= 10000 or value <= -10000 then
			return format("%s%d%s %d%s %d%s", negl, gold, GOLD_ABBR, silver, SILVER_ABBR, copper, COPPER_ABBR)
		elseif value >= 100 or value <= -100 then
			return format("%s%d%s %d%s", negl, silver, SILVER_ABBR, copper, COPPER_ABBR)
		else
			return format("%s%d%s", negl, copper, COPPER_ABBR)
		end
	end
end

function Abacus:FormatMoneyShort(copper, colorize, textColor)
	local color = COLOR_WHITE
	if textColor then
		if copper > 0 then
			color = COLOR_GREEN
		elseif copper < 0 then
			color = COLOR_RED
		end
	end
	if colorize then
		if copper == inf or copper == -inf then
			return format("|cff%s%s|r", color, copper)
		elseif copper ~= copper then
			return format("|cff%s0|r|cff%s%s|r", COLOR_WHITE, COLOR_COPPER, COPPER_ABBR)
		elseif copper >= 10000 or copper <= -10000 then
			return format("|cff%s%.1f|r|cff%s%s|r", color, copper / 10000, COLOR_GOLD, GOLD_ABBR)
		elseif copper >= 100 or copper <= -100 then
			return format("|cff%s%.1f|r|cff%s%s|r", color, copper / 100, COLOR_SILVER, SILVER_ABBR)
		else
			return format("|cff%s%d|r|cff%s%s|r", color, copper, COLOR_COPPER, COPPER_ABBR)
		end
	else
		if value == copper or value == -copper then
			return format("%s", copper)
		elseif copper ~= copper then
			return format("0%s", COPPER_ABBR)
		elseif copper >= 10000 or copper <= -10000 then
			return format("%.1f%s", copper / 10000, GOLD_ABBR)
		elseif copper >= 100 or copper <= -100 then
			return format("%.1f%s", copper / 100, SILVER_ABBR)
		else
			return format("%.0f%s", copper, COPPER_ABBR)
		end
	end
end

function Abacus:FormatMoneyCondensed(value, colorize, textColor)
	local negl = ""
	local negr = ""
	if value < 0 then
		if colorize and textColor then
			negl = "|cffff0000-(|r"
			negr = "|cffff0000)|r"
		else
			negl = "-("
			negr = ")"
		end
	end
	local gold = floor(math.abs(value) / 10000)
	local silver = mod(floor(math.abs(value) / 100), 100)
	local copper = mod(floor(math.abs(value)), 100)
	if colorize then
		if value == inf or value == -inf then
			return format("%s|cff%s%s|r%s", negl, COLOR_COPPER, math.abs(value), negr)
		elseif value ~= value then
			return format("|cff%s0|r", COLOR_COPPER)
		elseif gold ~= 0 then
			return format("%s|cff%s%d|r.|cff%s%02d|r.|cff%s%02d|r%s", negl, COLOR_GOLD, gold, COLOR_SILVER, silver, COLOR_COPPER, copper, negr)
		elseif silver ~= 0 then
			return format("%s|cff%s%d|r.|cff%s%02d|r%s", negl, COLOR_SILVER, silver, COLOR_COPPER, copper, negr)
		else
			return format("%s|cff%s%d|r%s", negl, COLOR_COPPER, copper, negr)
		end
	else
		if value == inf or value == -inf then
			return tostring(value)
		elseif value ~= value then
			return "0"
		elseif gold ~= 0 then
			return format("%s%d.%02d.%02d%s", negl, gold, silver, copper, negr)
		elseif silver ~= 0 then
			return format("%s%d.%02d%s", negl, silver, copper, negr)
		else
			return format("%s%d%s", negl, copper, negr)
		end
	end
end

local t = {}
function Abacus:FormatDurationExtended(duration, colorize, hideSeconds)
	local negative = ""
	if duration ~= duration then
		duration = 0
	end
	if duration < 0 then
		negative = "-"
		duration = -duration
	end
	local days = floor(duration / 86400)
	local hours = mod(floor(duration / 3600), 24)
	local mins = mod(floor(duration / 60), 60)
	local secs = mod(floor(duration), 60)
	for k in pairs(t) do
		t[k] = nil
	end
	if not colorize then
		if not duration or duration > 86400*36500 then -- 100 years
			return L_UNDETERMINED
		end
		if days > 1 then
			table.insert(t, format("%d %s", days, DAYS_ABBR_P1))
		elseif days == 1 then
			table.insert(t, format("%d %s", days, DAYS_ABBR_S1))
		end
		if hours > 1 then
			table.insert(t, format("%d %s", hours, HOURS_ABBR_P1))
		elseif hours == 1 then
			table.insert(t, format("%d %s", hours, HOURS_ABBR_S1))
		end
		if mins > 1 then
			table.insert(t, format("%d %s", mins, MINUTES_ABBR_P1))
		elseif mins == 1 then
			table.insert(t, format("%d %s", mins, MINUTES_ABBR_S1))
		end
		if not hideSeconds then
			if secs > 1 then
				table.insert(t, format("%d %s", secs, SECONDS_ABBR_P1))
			elseif secs == 1 then
				table.insert(t, format("%d %s", secs, SECONDS_ABBR_S1))
			end
		end
		if table.getn(t) == 0 then
			if not hideSeconds then
				return "0 " .. SECONDS_ABBR_P1
			else
				return "0 " .. MINUTES_ABBR_P1
			end
		else
			return negative .. table.concat(t, " ")
		end
	else
		if not duration or duration > 86400*36500 then -- 100 years
			return "|cffffffff"..L_UNDETERMINED.."|r"
		end
		if days > 1 then
			table.insert(t, format("|cffffffff%d|r %s", days, DAYS_ABBR_P1))
		elseif days == 1 then
			table.insert(t, format("|cffffffff%d|r %s", days, DAYS_ABBR_S1))
		end
		if hours > 1 then
			table.insert(t, format("|cffffffff%d|r %s", hours, HOURS_ABBR_P1))
		elseif hours == 1 then
			table.insert(t, format("|cffffffff%d|r %s", hours, HOURS_ABBR_S1))
		end
		if mins > 1 then
			table.insert(t, format("|cffffffff%d|r %s", mins, MINUTES_ABBR_P1))
		elseif mins == 1 then
			table.insert(t, format("|cffffffff%d|r %s", mins, MINUTES_ABBR_S1))
		end
		if not hideSeconds then
			if secs > 1 then
				table.insert(t, format("|cffffffff%d|r %s", secs, SECONDS_ABBR_P1))
			elseif secs == 1 then
				table.insert(t, format("|cffffffff%d|r %s", secs, SECONDS_ABBR))
			end
		end
		if table.getn(t) == 0 then
			if not hideSeconds then
				return "|cffffffff0|r " .. SECONDS_ABBR_P1
			else
				return "|cffffffff0|r " .. MINUTES_ABBR_P1
			end
		elseif negative == "-" then
			return "|cffffffff-|r" .. table.concat(t, " ")
		else
			return table.concat(t, " ")
		end
	end
end

function Abacus:FormatDurationFull(duration, colorize, hideSeconds)
	local negative = ""
	if duration ~= duration then
		duration = 0
	end
	if duration < 0 then
		negative = "-"
		duration = -duration
	end
	if not colorize then
		if not hideSeconds then
			if not duration or duration > 86400*36500 then -- 100 years
				return L_UNDETERMINED
			elseif duration >= 86400 then
				return format("%s%d%s %02d%s %02d%s %02d%s", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			elseif duration >= 3600 then
				return format("%s%d%s %02d%s %02d%s", negative, duration/3600, L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			elseif duration >= 120 then
				return format("%s%d%s %02d%s", negative, duration/60, L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			else
				return format("%s%d%s", negative, duration, L_SECOND_ONELETTER_ABBR)
			end
		else
			if not duration or duration > 86400*36500 then -- 100 years
				return L_UNDETERMINED
			elseif duration >= 86400 then
				return format("%s%d%s %02d%s %02d%s", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR)
			elseif duration >= 3600 then
				return format("%s%d%s %02d%s", negative, duration/3600, L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR)
			else
				return format("%s%d%s", negative, duration/60, L_MINUTE_ONELETTER_ABBR)
			end
		end
	else
		if not hideSeconds then
			if not duration or duration > 86400*36500 then -- 100 years
				return "|cffffffff"..L_UNDETERMINED.."|r"
			elseif duration >= 86400 then
				return format("|cffffffff%s%d|r%s |cffffffff%02d|r%s |cffffffff%02d|r%s |cffffffff%02d|r%s", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			elseif duration >= 3600 then
				return format("|cffffffff%s%d|r%s |cffffffff%02d|r%s |cffffffff%02d|r%s", negative, duration/3600, L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			elseif duration >= 120 then
				return format("|cffffffff%s%d|r%s |cffffffff%02d|r%s", negative, duration/60, L_MINUTE_ONELETTER_ABBR, mod(duration, 60), L_SECOND_ONELETTER_ABBR)
			else
				return format("|cffffffff%s%d|r%s", negative, duration, L_SECOND_ONELETTER_ABBR)
			end
		else
			if not duration or duration > 86400*36500 then -- 100 years
				return "|cffffffff"..L_UNDETERMINED.."|r"
			elseif duration >= 86400 then
				return format("|cffffffff%s%d|r%s |cffffffff%02d|r%s |cffffffff%02d|r%s", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR)
			elseif duration >= 3600 then
				return format("|cffffffff%s%d|r%s |cffffffff%02d|r%s", negative, duration/3600, L_HOUR_ONELETTER_ABBR, mod(duration/60, 60), L_MINUTE_ONELETTER_ABBR)
			else
				return format("|cffffffff%s%d|r%s", negative, duration/60, L_MINUTE_ONELETTER_ABBR)
			end
		end
	end
end

function Abacus:FormatDurationShort(duration, colorize, hideSeconds)
	local negative = ""
	if duration ~= duration then
		duration = 0
	end
	if duration < 0 then
		negative = "-"
		duration = -duration
	end
	if not colorize then
		if not duration or duration >= 86400*36500 then -- 100 years
			return "***"
		elseif duration >= 172800 then
			return format("%s%.1f %s", negative, duration/86400, DAYS_ABBR_P1)
		elseif duration >= 7200 then
			return format("%s%.1f %s", negative, duration/3600, HOURS_ABBR_P1)
		elseif duration >= 120 or not hideSeconds then
			return format("%s%.1f %s", negative, duration/60, MINUTES_ABBR_P1)
		else
			return format("%s%.0f %s", negative, duration, SECONDS_ABBR_P1)
		end
	else
		if not duration or duration >= 86400*36500 then -- 100 years
			return "|cffffffff***|r"
		elseif duration >= 172800 then
			return format("|cffffffff%s%.1f|r %s", negative, duration/86400, DAYS_ABBR_P1)
		elseif duration >= 7200 then
			return format("|cffffffff%s%.1f|r %s", negative, duration/3600, HOURS_ABBR_P1)
		elseif duration >= 120 or not hideSeconds then
			return format("|cffffffff%s%.1f|r %s", negative, duration/60, MINUTES_ABBR_P1)
		else
			return format("|cffffffff%s%.0f|r %s", negative, duration, SECONDS_ABBR_P1)
		end
	end
end

function Abacus:FormatDurationCondensed(duration, colorize, hideSeconds)
	local negative = ""
	if duration ~= duration then
		duration = 0
	end
	if duration < 0 then
		negative = "-"
		duration = -duration
	end
	if not colorize then
		if hideSeconds then
			if not duration or duration >= 86400*36500 then -- 100 years
				return format("%s**%s **:**", negative, L_DAY_ONELETTER_ABBR)
			elseif duration >= 86400 then
				return format("%s%d%s %d:%02d", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), mod(duration/60, 60))
			else
				return format("%s%d:%02d", negative, duration/3600, mod(duration/60, 60))
			end
		else
			if not duration or duration >= 86400*36500 then -- 100 years
				return negative .. "**:**:**:**"
			elseif duration >= 86400 then
				return format("%s%d%s %d:%02d:%02d", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), mod(duration/60, 60), mod(duration, 60))
			elseif duration >= 3600 then
				return format("%s%d:%02d:%02d", negative, duration/3600, mod(duration/60, 60), mod(duration, 60))
			else
				return format("%s%d:%02d", negative, duration/60, mod(duration, 60))
			end
		end
	else
		if hideSeconds then
			if not duration or duration >= 86400*36500 then -- 100 years
				return format("|cffffffff%s**|r%s |cffffffff**|r:|cffffffff**|r", negative, L_DAY_ONELETTER_ABBR)
			elseif duration >= 86400 then
				return format("|cffffffff%s%d|r%s |cffffffff%d|r:|cffffffff%02d|r", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), mod(duration/60, 60))
			else
				return format("|cffffffff%s%d|r:|cffffffff%02d|r", negative, duration/3600, mod(duration/60, 60))
			end
		else
			if not duration or duration >= 86400*36500 then -- 100 years
				return format("|cffffffff%s**|r%s |cffffffff**|r:|cffffffff**|r:|cffffffff**|r", negative, L_DAY_ONELETTER_ABBR)
			elseif duration >= 86400 then
				return format("|cffffffff%s%d|r%s |cffffffff%d|r:|cffffffff%02d|r:|cffffffff%02d|r", negative, duration/86400, L_DAY_ONELETTER_ABBR, mod(duration/3600, 24), mod(duration/60, 60), mod(duration, 60))
			elseif duration >= 3600 then
				return format("|cffffffff%s%d|r:|cffffffff%02d|r:|cffffffff%02d|r", negative, duration/3600, mod(duration/60, 60), mod(duration, 60))
			else
				return format("|cffffffff%s%d|r:|cffffffff%02d|r", negative, duration/60, mod(duration, 60))
			end
		end
	end
end

local function compat()
	local Abacus20 = setmetatable({}, {__index = function(self, key)
		if type(Abacus[key]) == "function" then
			self[key] = function(self, ...)
				return Abacus[key](Abacus, ...)
			end
		else
			self[key] = Abacus[key]
		end
		return self[key]
	end})
	AceLibrary:Register(Abacus20, "Abacus-2.0", MINOR_VERSION*1000)
end
if AceLibrary then
	compat()
elseif Rock then
	function Abacus:OnLibraryLoad(major, instance)
		if major == "AceLibrary" then
			compat()
		end
	end
end

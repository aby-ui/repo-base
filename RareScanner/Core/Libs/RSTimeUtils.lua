-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local RSTimeUtils = private.NewLib("RareScannerTimeUtils")

---============================================================================
-- Function to calculate next covenant assault reset time
--- US: Tuesdays at 9am and on Fridays at 9pm.
--- EU: Wednesdays at 9am and on Saturdays at 9pm.
--- KR, TW, CH: Thrusday at 9am and on Sunday at 9pm.
---============================================================================

local RESET_FIRST_HOUR = 9
local RESET_SECOND_HOUR = 21
local WEEKDAYS = { SUNDAY = 1, MONDAY = 2, TUESDAY = 3, WEDNESDAY = 4, THURSDAY = 5, FRIDAY = 6, SATURDAY = 7 }

local function CalculateAssaultResetTime(days, initHour, weekley)
	local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
   	local finalDate
   	if (not weekley) then
   		finalDate = C_DateAndTime.AdjustTimeByDays(currentCalendarTime, days)
   		return time({year = finalDate.year, month = finalDate.month, day = finalDate.monthDay, hour = initHour, minute = 0, sec = 0}) - time()
    elseif (initHour == RESET_FIRST_HOUR) then
   		finalDate = C_DateAndTime.AdjustTimeByDays(currentCalendarTime, days + 7 + 3)
   		return time({year = finalDate.year, month = finalDate.month, day = finalDate.monthDay, hour = RESET_SECOND_HOUR, minute = 0, sec = 0}) - time()
    else
   		finalDate = C_DateAndTime.AdjustTimeByDays(currentCalendarTime, days + 7 + 4)
   		return time({year = finalDate.year, month = finalDate.month, day = finalDate.monthDay, hour = RESET_FIRST_HOUR, minute = 0, sec = 0}) - time()
    end
end

function RSTimeUtils.GetCovenantAssaultResetTime(weekley)
	local c = C_DateAndTime.GetCurrentCalendarTime()
	local regionID = GetCurrentRegion()
	if (regionID == 2 or regionID == 4 or regionID == 5) then --KR, TW, CH
		-- If Thrusday 9am or after
		if (c.weekday == WEEKDAYS.THURSDAY and c.hour >= RESET_FIRST_HOUR) then
			return CalculateAssaultResetTime((WEEKDAYS.SATURDAY - c.weekday) + WEEKDAYS.SUNDAY, RESET_SECOND_HOUR, weekley)
		-- If Thrusday - Saturday (included)
		elseif (c.weekday > WEEKDAYS.THURSDAY and c.weekday <= WEEKDAYS.SATURDAY) then
			return CalculateAssaultResetTime((WEEKDAYS.SATURDAY - c.weekday) + WEEKDAYS.SUNDAY, RESET_SECOND_HOUR, weekley)
		-- If Sunday before 21pm
		elseif (c.weekday == WEEKDAYS.SUNDAY and c.hour < RESET_SECOND_HOUR) then
			return CalculateAssaultResetTime(0, RESET_SECOND_HOUR, weekley)
		else
			if (c.weekday > WEEKDAYS.THURSDAY) then
				return CalculateAssaultResetTime((WEEKDAYS.SATURDAY - c.weekday) + WEEKDAYS.THURSDAY, RESET_FIRST_HOUR, weekley)
			else
				return CalculateAssaultResetTime(WEEKDAYS.THURSDAY - c.weekday, RESET_FIRST_HOUR, weekley)
			end
		end
	elseif (regionID == 3) then --EU
		-- If Wednesday 9am or after
		if (c.weekday == WEEKDAYS.WEDNESDAY and c.hour >= RESET_FIRST_HOUR) then
			return CalculateAssaultResetTime(WEEKDAYS.SATURDAY - c.weekday, RESET_SECOND_HOUR, weekley)
		-- If Wednesday - Saturday
		elseif (c.weekday > WEEKDAYS.WEDNESDAY and c.weekday < WEEKDAYS.SATURDAY) then
			return CalculateAssaultResetTime(WEEKDAYS.SATURDAY - c.weekday, RESET_SECOND_HOUR, weekley)
		-- If Saturday before 21pm
		elseif (c.weekday == WEEKDAYS.SATURDAY and c.hour < RESET_SECOND_HOUR) then
			return CalculateAssaultResetTime(0, RESET_SECOND_HOUR, weekley)
		else
			if (c.weekday > WEEKDAYS.WEDNESDAY) then
				return CalculateAssaultResetTime((WEEKDAYS.SATURDAY - c.weekday) + WEEKDAYS.WEDNESDAY, RESET_FIRST_HOUR, weekley)
			else
				return CalculateAssaultResetTime(WEEKDAYS.WEDNESDAY - c.weekday, RESET_FIRST_HOUR, weekley)
			end
		end
	else --US
		-- If Tuesday 9am or after
		if (c.weekday == WEEKDAYS.TUESDAY and c.hour >= RESET_FIRST_HOUR) then
			return CalculateAssaultResetTime(WEEKDAYS.FRIDAY - c.weekday, RESET_SECOND_HOUR, weekley)
		-- If Tuesday - Friday
		elseif (c.weekday > WEEKDAYS.TUESDAY and c.weekday < WEEKDAYS.FRIDAY) then
			return CalculateAssaultResetTime(WEEKDAYS.FRIDAY - c.weekday, RESET_SECOND_HOUR, weekley)
		-- If Friday before 21pm
		elseif (c.weekday == WEEKDAYS.FRIDAY and c.hour < RESET_SECOND_HOUR) then
			return CalculateAssaultResetTime(0, RESET_SECOND_HOUR, weekley)
		else
			if (c.weekday > WEEKDAYS.TUESDAY) then
				return CalculateAssaultResetTime((WEEKDAYS.SATURDAY - c.weekday) + WEEKDAYS.TUESDAY, RESET_FIRST_HOUR, weekley)
			else
				return CalculateAssaultResetTime(WEEKDAYS.TUESDAY - c.weekday, RESET_FIRST_HOUR, weekley)
			end
		end
	end
end

---============================================================================
-- Function to transform a timeStamp into a formatted time
---============================================================================

function RSTimeUtils.TimeStampToClock(seconds, countUp)
	if (not seconds) then
		return AL["UNKNOWN"]
	elseif (countUp) then
		seconds = tonumber(time() - seconds)
	end

	if seconds <= 0 then
		return "00:00:00";
	else
		local minutes = math.floor(seconds / 60);
		local hours = math.floor(minutes / 60);
		local days = math.floor(hours / 24);
		return days.." "..AL["MAP_TOOLTIP_DAYS"].." "..string.format("%02.f", hours%24)..":"..string.format("%02.f", minutes%60)..":"..string.format("%02.f", seconds%60)
	end
end

---============================================================================
-- Auxiliar
---============================================================================

function RSTimeUtils.DaysToSeconds(days)
	if (days) then
		return days * RSTimeUtils.HoursToSeconds(24)
	else
		return 0
	end
end

function RSTimeUtils.HoursToSeconds(hours)
	if (hours) then
		return hours * RSTimeUtils.MinutesToSeconds(60)
	else
		return 0
	end
end

function RSTimeUtils.MinutesToSeconds(minutes)
	if (minutes) then
		return minutes * 60
	else
		return 0
	end
end

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local RSTimeUtils = private.NewLib("RareScannerTimeUtils")

---============================================================================
-- Function to calculate next server reset
---============================================================================

local function GetServerOffset()
	local serverDate = C_DateAndTime.GetCurrentCalendarTime()
	local serverDay, serverWeekday, serverMonth, serverMinute, serverHour, serverYear = serverDate.monthDay, serverDate.weekday, serverDate.month, serverDate.minute, serverDate.hour, serverDate.year
	local localDay = tonumber(date("%w")) -- 0-based starts on Sun
	local localHour, localMinute = tonumber(date("%H")), tonumber(date("%M"))
	if (serverDay == (localDay + 1)%7) then -- server is a day ahead
		serverHour = serverHour + 24
	elseif (localDay == (serverDay + 1)%7) then -- local is a day ahead
		localHour = localHour + 24
	end

	local server = serverHour + serverMinute / 60
	local localT = localHour + localMinute / 60
	local offset = floor((server - localT) * 2 + 0.5) / 2
	return offset
end

local resetDays

function RSTimeUtils.GetServerResetTime()
	if (not resetDays) then
		local regionID = GetCurrentRegion()
		resetDays = {}
		resetDays.DLHoffset = 0
		if (regionID == 2 or regionID == 4 or regionID == 5) then --KR, TW, CH
			resetDays["4"] = true -- thursday
		elseif (regionID == 3) then --EU
			resetDays["3"] = true -- wednesday
		else --US
			resetDays["2"] = true -- tuesday
			resetDays.DLHoffset = -3
		end
	end

	local offset = (GetServerOffset() + resetDays.DLHoffset) * 3600
	local nightlyReset = time() + GetQuestResetTime()
	while (not resetDays[date("%w",nightlyReset+offset)]) do
		nightlyReset = nightlyReset + 24 * 3600
	end

	return nightlyReset
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

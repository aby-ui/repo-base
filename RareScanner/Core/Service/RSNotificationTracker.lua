-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSNotificationTracker = private.NewLib("RareScannerNotificationTracker")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")

-- Timers
local RESET_NOTIFICATIONS_TIMER

---============================================================================
-- Tracks notifications
---============================================================================

local current_notifications = {}
local VIGNETTE_ID_SEPARATOR = "-"

local function InitResetNotificationsTimer()
	if (RESET_NOTIFICATIONS_TIMER) then
		return
	end
	
	RESET_NOTIFICATIONS_TIMER = C_Timer.NewTicker(RSConstants.CHECK_RESET_NOTIFICATIONS_TIMER, function()
		for notificationID, notificationTime in pairs (current_notifications) do
			local currenTime = time()
			if (currenTime > (notificationTime + (RSConfigDB.GetRescanTimer() * 60))) then
				-- Removes notification
				current_notifications[notificationID] = nil
				
				-- If it is a vignetteID
				if (RSUtils.Contains(notificationID, VIGNETTE_ID_SEPARATOR)) then
					local _, _, _, _, _, entityID, _ = strsplit(VIGNETTE_ID_SEPARATOR, notificationID);
					RSLogger:PrintDebugMessage(string.format("RemovedNotification[%s] at [%s]", entityID, RSTimeUtils.TimeStampToClock(currenTime)))
				-- If it is an entityID
				else
					RSLogger:PrintDebugMessage(string.format("RemovedNotification[%s] at [%s]", notificationID, RSTimeUtils.TimeStampToClock(currenTime)))
				end
			end
		end
	end)
end

function RSNotificationTracker.AddNotification(vignetteID, isNavigating, entityID)	
	-- When navigating never check notifications
	if (isNavigating) then
		return
	end
	
	-- Initializes timer
	InitResetNotificationsTimer()
	
	local currentTime = time()
	
	-- If not spawning in multiple places at the same time stores entityID
	if (entityID and not RSUtils.Contains(RSConstants.NPCS_WITH_MULTIPLE_SPAWNS, entityID) and not RSUtils.Contains(RSConstants.CONTAINERS_WITH_MULTIPLE_SPAWNS, entityID)) then
		current_notifications[entityID] = currentTime
		RSLogger:PrintDebugMessage(string.format("AddNotification[%s] at [%s]", entityID, RSTimeUtils.TimeStampToClock(currentTime)))
	-- Otherwise vignetteID
	else
		current_notifications[vignetteID] = currentTime
		RSLogger:PrintDebugMessage(string.format("AddNotification[%s] at [%s]", vignetteID, RSTimeUtils.TimeStampToClock(currentTime)))
	end
end

function RSNotificationTracker.IsAlreadyNotificated(vignetteID, isNavigating, entityID)	
	-- When navigating never check notifications
	if (isNavigating) then
		return false
	end
	
	if (current_notifications[vignetteID] or (entityID and current_notifications[entityID])) then
		return true
	end

	-- Avoids showing alert if user is targeting that NPC already
	-- This will avoid getting constant alerts for the same rare NPC if the user takes a while to start combat
	-- and the vignettes is removed from the alreadyFound list
	if (UnitExists("target")) then
		local targetUid = UnitGUID("target")
		local _, _, _, _, _, targetNpcID = strsplit(VIGNETTE_ID_SEPARATOR, targetUid)
		if (tonumber(targetNpcID) == entityID) then
			return true
		end
	end

	-- Check whether the vignetteID is real or fake
	local fake = false
	local vignetteGUID, _, _, _, _, _ = strsplit(VIGNETTE_ID_SEPARATOR, vignetteID)
	if (vignetteGUID == "a") then
		fake = true
	end

	-- If the vignette is fake it has to check through all the real vignettes to find out if its being found already
	if (fake and entityID) then
		for alreadyNotifiedVignetteId, _ in pairs (current_notifications) do
			if (RSUtils.Contains(alreadyNotifiedVignetteId, VIGNETTE_ID_SEPARATOR)) then
				local _, _, _, _, _, alreadyNotifiedNpcID, _ = strsplit(VIGNETTE_ID_SEPARATOR, alreadyNotifiedVignetteId);
				if (tonumber(alreadyNotifiedNpcID) == entityID) then
					return true
				end
			end
		end
	end

	return false
end
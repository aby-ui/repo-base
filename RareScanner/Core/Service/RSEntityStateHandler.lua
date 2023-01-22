-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSEntityStateHandler = private.NewLib("RareScannerEntityStateHandler")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")

-- RareScanner services
local RSQuestTracker = private.ImportLib("RareScannerQuestTracker")
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSRecentlySeenTracker = private.ImportLib("RareScannerRecentlySeenTracker")

---============================================================================
-- Handle NPC state
---============================================================================

-- While loadding the addon there is no need to check all the dead NPCs by quest because
-- when loading the addon will check every NPC
function RSEntityStateHandler.SetDeadNpcByZone(npcID, mapID, loadingAddon)
	if (not npcID or not mapID) then
		return
	end

	-- Remove recently seen
	RSRecentlySeenTracker.RemoveRecentlySeen(npcID)
	
	local alreadyFoundInfo = RSGeneralDB.GetAlreadyFoundEntity(npcID)
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)

	-- If we know for sure it remains dead
	if (npcInfo and npcInfo.reset ~= nil and npcInfo.reset == false) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC.", npcID))
		RSNpcDB.SetNpcKilled(npcID)
	-- If we know for sure it remains being a rare
	elseif (npcInfo and npcInfo.reset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Siempre es un rare NPC.", npcID))
	-- If we know for sure it resets with quests
	elseif (npcInfo and npcInfo.questReset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con las misiones del mundo", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + GetQuestResetTime())
	-- If we know for sure it resets with every server restart
	elseif (npcInfo and npcInfo.weeklyReset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con el reinicio del servidor", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + C_DateAndTime.GetSecondsUntilWeeklyReset())
	-- If we know the exact reset timer
	elseif (npcInfo and npcInfo.resetTimer) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea pasados [%s]segundos", npcID, npcInfo.resetTimer))
		RSNpcDB.SetNpcKilled(npcID, time() + npcInfo.resetTimer)
	-- If its a world quest reseteable rare
	elseif (RSMapDB.IsEntityInReseteableZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + GetQuestResetTime())
	-- If its a warfront reseteable rare
	elseif (RSMapDB.IsEntityInWarfrontZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea cada 2 semanas (Warfront)", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + C_DateAndTime.GetSecondsUntilWeeklyReset() + RSTimeUtils.DaysToSeconds(7))
	-- If it wont ever be a rare anymore
	elseif (RSMapDB.IsEntityInPermanentZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC", npcID))
		RSNpcDB.SetNpcKilled(npcID)
	-- If it has an associated quest and if its completed
	elseif (npcInfo and npcInfo.questID) then
		for i, questID in ipairs (npcInfo.questID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
				RSNpcDB.SetNpcKilled(npcID)
				RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC (por haber completado su mision)", npcID))
				break
			end
		end
	else
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Siempre es un rare NPC (por descarte)", npcID))
	end

	-- Looks for other NPCs with the same questID
	if (not loadingAddon and RSNpcDB.IsNpcKilled(npcID) and npcInfo and npcInfo.questID) then
		-- Checks if quest completed
		C_Timer.After(2, function()
			for internalNpcID, internalNpcInfo in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
				if (internalNpcInfo.questID and internalNpcID ~= npcID and RSUtils.Contains(internalNpcInfo.questID, npcInfo.questID)) then
					for i, questID in ipairs (internalNpcInfo.questID) do
						if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
							RSNpcDB.SetNpcKilled(internalNpcID, RSNpcDB.GetNpcKilledRespawnTime(npcID))
							RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC por compartir mision con otro rare NPC muerto [%s]", internalNpcID, npcID))
							RSRecentlySeenTracker.RemoveRecentlySeen(internalNpcID)
						end
					end
				end
			end
		end)
	end
end

-- While loadding the addon there are several checkings that aren't required
-- This flag can be also used to skip all those checking when needed
function RSEntityStateHandler.SetDeadNpc(npcID, loadingAddon)
	if (not npcID) then
		return
	end
	
	-- Ignore if already dead
	if (RSNpcDB.IsNpcKilled(npcID)) then
		return
	end
	
	-- Mark as killed
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	if (npcInfo) then
		-- Remove recently seen
		local x, y = RSRecentlySeenTracker.RemoveRecentlySeen(npcID)
	
		-- If the npc belongs to several zones we have to use the players zone
		if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
			local playerZoneID = C_Map.GetBestMapForUnit("player")
			if (not playerZoneID) then
				return
			end

			for zoneID, zoneInfo in pairs (npcInfo.zoneID) do
				if (loadingAddon) then
					RSEntityStateHandler.SetDeadNpcByZone(npcID, zoneID, loadingAddon)
					break
				elseif (playerZoneID == zoneID) then
					RSEntityStateHandler.SetDeadNpcByZone(npcID, zoneID, loadingAddon)
					break
				end
			end
		else
			RSEntityStateHandler.SetDeadNpcByZone(npcID, npcInfo.zoneID, loadingAddon)
		end

		-- Extracts quest id if we don't have it
		if (not loadingAddon and RSConstants.DEBUG_MODE) then
			if (not npcInfo.questID and not RSNpcDB.GetNpcQuestIdFound(npcID)) then
				RSLogger:PrintDebugMessage(string.format("NPC [%s]. Buscando questID...", npcID))
				RSQuestTracker.FindCompletedHiddenQuestID(npcID, function(npcID, newQuestID) 
					RSNpcDB.SetNpcQuestIdFound(npcID, newQuestID) 
				end)
			elseif (npcInfo.questID) then
				RSLogger:PrintDebugMessage(string.format("El NPC [%s] ya dispone de questID [%s]", npcID, unpack(npcInfo.questID)))
			end
		end
	
		-- Disable guideance icons if enabled
		if (RSGeneralDB.HasGuideActive(npcID) and RSNpcDB.IsNpcKilled(npcID)) then
			RSGeneralDB.RemoveGuideActive()
			RSMinimap.RemoveGuide(npcID)
		end
	
		-- Disable overlay icons if enabled
		if (RSGeneralDB.HasOverlayActive(npcID) and RSNpcDB.IsNpcKilled(npcID)) then
			RSGeneralDB.RemoveOverlayActive(npcID)
			RSMinimap.RemoveOverlay(npcID)
		end
		
		-- Refresh minimap
		if (not loadingAddon) then
			RSMinimap.HideIcon(npcID, x, y)
		end
		
	-- If we dont have this entity in our database we can ignore it
	elseif (RSGeneralDB.GetAlreadyFoundEntity(npcID)) then
		RSNpcDB.SetNpcKilled(npcID)
	end
end

---============================================================================
-- Handle Container state
---============================================================================

local function SetContainerOpenByZone(containerID, mapID, loadingAddon)
	if (not containerID or not mapID) then
		return
	end

	local containerAlreadyFoundInfo = RSGeneralDB.GetAlreadyFoundEntity(containerID)
	local containerInternalInfo = RSContainerDB.GetInternalContainerInfo(containerID)

	-- It it is a part of an achievement it won't come back
	local containerWithAchievement = false;
	if (private.ACHIEVEMENT_ZONE_IDS[mapID]) then
		for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
			for _, objectiveID in ipairs(private.ACHIEVEMENT_TARGET_IDS[achievementID]) do
				if (objectiveID == containerID) then
					RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo (por formar parte de un logro)", containerID))
					RSContainerDB.SetContainerOpened(containerID)
					containerWithAchievement = true;
					break;
				end
			end
		end
	end

	if (not containerWithAchievement) then
		-- If we know for sure it remains opened
		if (containerInternalInfo and containerInternalInfo.reset ~= nil and containerInternalInfo.reset == false) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo.", containerID))
			RSContainerDB.SetContainerOpened(containerID)
		-- If we know for sure it remains showing up along the day
		elseif (containerInternalInfo and containerInternalInfo.reset) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Vuelve a aparecer en el mismo día.", containerID))
		-- If we know for sure it resets with quests
		elseif (containerInternalInfo and containerInternalInfo.questReset) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo", containerID))
			RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
		-- If we know for sure it resets with every server restart
		elseif (containerInternalInfo and containerInternalInfo.weeklyReset) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con el reinicio del servidor", containerID))
			RSContainerDB.SetContainerOpened(containerID, time() + C_DateAndTime.GetSecondsUntilWeeklyReset())
		-- If we know for sure it resets every two weeks
		elseif (containerInternalInfo and containerInternalInfo.covenantAssaultReset) then
			if (containerInternalInfo.covenantAssaultReset == 0) then
				local assaultResetTime = RSTimeUtils.GetCovenantAssaultResetTime(true)
				RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea en %s por pertenecer a un asalto de curia", containerID, RSTimeUtils.TimeStampToClock(assaultResetTime)))
				RSContainerDB.SetContainerOpened(containerID, time() + assaultResetTime)
			else
				local assaultResetTime = RSTimeUtils.GetCovenantAssaultResetTime()
				RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea en %s por pertenecer a un cualquier asalto de curia", containerID, RSTimeUtils.TimeStampToClock(assaultResetTime)))
				RSContainerDB.SetContainerOpened(containerID, time() + assaultResetTime)
			end
		-- If we know the exact reset timer
		elseif (containerInternalInfo and containerInternalInfo.resetTimer) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea pasados [%s]segundos", containerID, containerInternalInfo.resetTimer))
			RSContainerDB.SetContainerOpened(containerID, time() + containerInternalInfo.resetTimer)
		-- If its a world quest reseteable container
		elseif (RSMapDB.IsEntityInReseteableZone(containerID, mapID, containerAlreadyFoundInfo)) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", containerID))
			RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
		-- If its a world quest reseteable container (detected while playing)
		elseif (RSContainerDB.IsContainerReseteable(containerID)) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo (detectado al haberse encontrado por segunda vez)", containerID))
			RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
		-- If its a warfront reseteable container
		elseif (RSMapDB.IsEntityInWarfrontZone(containerID, mapID, containerAlreadyFoundInfo)) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea cada 2 semanas (Warfront)", containerID))
			RSContainerDB.SetContainerOpened(containerID, time() + C_DateAndTime.GetSecondsUntilWeeklyReset() + RSTimeUtils.DaysToSeconds(7))
		-- If it wont ever be open anymore
		elseif (RSMapDB.IsEntityInPermanentZone(containerID, mapID, containerAlreadyFoundInfo)) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo", containerID))
			RSContainerDB.SetContainerOpened(containerID)
		-- If it has an associated quest and if its completed
		elseif (containerInternalInfo and containerInternalInfo.questID) then
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Detectado que tiene mision asociada, buscando si esta completada", containerID))
			for _, questID in ipairs (containerInternalInfo.questID) do
				if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
					RSContainerDB.SetContainerOpened(containerID)
					RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo (por haber completado su mision)", containerID))
					break
				end
			end
		else
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Vuelve a reaparecer (por descarte)", containerID))
		end
	end

	-- There are some containers that share the same questID
	if (not loadingAddon and RSContainerDB.IsContainerOpened(containerID) and containerInternalInfo and containerInternalInfo.questID) then
		-- Checks if quest completed
		C_Timer.After(2, function()
			for internalContainerID, internalContainerInfo in pairs (RSContainerDB.GetAllInternalContainerInfo()) do
				if (internalContainerInfo.questID and RSUtils.Contains(internalContainerInfo.questID, containerInternalInfo.questID)) then
					for i, questID in ipairs (internalContainerInfo.questID) do
						if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
							RSContainerDB.SetContainerOpened(internalContainerID, RSContainerDB.GetContainerOpenedRespawnTime(containerID))
							RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. El contenedor ahora está cerrado por compartir questID con otro contenedor cerrado [%s]", internalContainerID, containerID))
							RSRecentlySeenTracker.RemoveRecentlySeen(internalContainerID)
						end
					end
				end
			end
		end)
	end
end

-- While loadding the addon there are several checkings that aren't required
-- This flag can be also used to skip all those checking when needed
function RSEntityStateHandler.SetContainerOpen(containerID, loadingAddon)
	if (not containerID) then
		return
	end
	
	-- Ignore if already opened
	if (RSContainerDB.IsContainerOpened(containerID)) then
		return
	end
	
	-- Mark as opened
	local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
	if (containerInfo) then
		-- Remove recently seen
		local x, y = RSRecentlySeenTracker.RemoveRecentlySeen(containerID)
	
		-- If the container belongs to several zones we have to use the players zone
		if (RSContainerDB.IsInternalContainerMultiZone(containerID)) then
			local playerZoneID = C_Map.GetBestMapForUnit("player")
			if (not playerZoneID) then
				return
			end

			for zoneID, zoneInfo in pairs (containerInfo.zoneID) do
				-- If the checking is loadingAddon it means that its a opened detected while loading the addon
				-- and the playerZoneID doesn't have to match the Containers, so take whatever zone
				if (loadingAddon) then
					SetContainerOpenByZone(containerID, zoneID, loadingAddon)
					break
				elseif (playerZoneID == zoneID) then
					SetContainerOpenByZone(containerID, zoneID, loadingAddon)
					break
				end
			end
		else
			SetContainerOpenByZone(containerID, containerInfo.zoneID, loadingAddon)
		end

		-- Extracts quest id if we don't have it
		-- Avoids shift-left-click events
		if (not loadingAddon and RSConstants.DEBUG_MODE) then
			if (not containerInfo.questID and not RSContainerDB.GetContainerQuestIdFound(containerID)) then
				RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Buscando questID...", containerID))
				RSQuestTracker.FindCompletedHiddenQuestID(containerID, function(containerID, newQuestID) 
					RSContainerDB.SetContainerQuestIdFound(containerID, newQuestID) 
				end)
			elseif (containerInfo.questID) then
				RSLogger:PrintDebugMessage(string.format("El Contenedor [%s] ya dispone de questID [%s]", containerID, unpack(containerInfo.questID)))
			else
				RSLogger:PrintDebugMessage(string.format("El Contenedor [%s] ya dispone de questID [%s]", containerID, unpack(RSContainerDB.GetContainerQuestIdFound(containerID))))
			end
		end
	
		-- Disable guideance icons if enabled
		if (RSGeneralDB.HasGuideActive(containerID) and RSContainerDB.IsContainerOpened(containerID)) then
			RSGeneralDB.RemoveGuideActive()
			RSMinimap.RemoveGuide(containerID)
		end
	
		-- Disable overlay icons if enabled
		if (RSGeneralDB.HasOverlayActive(containerID) and RSContainerDB.IsContainerOpened(containerID)) then
			RSGeneralDB.RemoveOverlayActive(containerID)
			RSMinimap.RemoveOverlay(containerID)
		end
		
		-- Refresh minimap
		if (not loadingAddon) then
			RSMinimap.HideIcon(containerID, x, y)
		end
		
	-- If we dont have this entity in our database we can ignore it
	elseif (RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
		RSContainerDB.SetContainerOpened(containerID)
	end
end

---============================================================================
-- Handle Event state
---============================================================================

-- While loadding the addon there are several checkings that aren't required
-- This flag can be also used to skip all those checking when needed
function RSEntityStateHandler.SetEventCompleted(eventID, loadingAddon)
	if (not eventID) then
		return
	end
	
	-- Ignore if already completed
	if (RSEventDB.IsEventCompleted(eventID)) then
		return
	end

	-- Remove recently seen
	local x, y = RSRecentlySeenTracker.RemoveRecentlySeen(eventID)

	local eventAlreadyFound = RSGeneralDB.GetAlreadyFoundEntity(eventID)
	local eventInternalInfo = RSEventDB.GetInternalEventInfo(eventID)
	local mapID = eventAlreadyFound and eventAlreadyFound.mapID or eventInternalInfo and eventInternalInfo.zoneID

	-- If we know for sure it remains completed
	if (eventInternalInfo and eventInternalInfo.reset ~= nil and eventInternalInfo.reset == false) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. No se puede completar de nuevo", eventID))
		RSEventDB.SetEventCompleted(eventID)
		-- If we know for sure it remains showing up along the day
	elseif (eventInternalInfo and eventInternalInfo.reset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Vuelve a aparecer en el mismo día.", eventID))
		-- If we know for sure it resets with quests
	elseif (eventInternalInfo and eventInternalInfo.questReset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con las misiones del mundo", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + GetQuestResetTime())
		-- If we know for sure it resets with every server restart
	elseif (eventInternalInfo and eventInternalInfo.weeklyReset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con el reinicio del servidor", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + C_DateAndTime.GetSecondsUntilWeeklyReset())
		-- If we know the exact reset timer
	elseif (eventInternalInfo and eventInternalInfo.resetTimer) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea pasados [%s]segundos", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + eventInternalInfo.resetTimer)
		-- If its a world quest reseteable event
	elseif (RSMapDB.IsEntityInReseteableZone(eventID, mapID, eventAlreadyFound)) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + GetQuestResetTime())
		-- If it wont ever be available anymore
	elseif (RSMapDB.IsEntityInPermanentZone(eventID, mapID, eventAlreadyFound)) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. No se puede completar de nuevo", eventID))
		RSEventDB.SetEventCompleted(eventID)
		-- If it has an associated quest and if its completed
	elseif (eventInternalInfo and eventInternalInfo.questID) then
		for _, questID in ipairs (eventInternalInfo.questID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
				RSEventDB.SetEventCompleted(eventID)
				RSLogger:PrintDebugMessage(string.format("Evento [%s]. No se puede completar de nuevo (por haber completado su mision)", eventID))
				break
			end
		end
	else
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Vuelve a estar disponible (por descarte)", eventID))
	end

	-- Extracts quest id if we don't have it
	-- Avoids shift-left-click events
	if (not loadingAddon and RSConstants.DEBUG_MODE) then
		if ((not eventInternalInfo or not eventInternalInfo.questID) and not RSEventDB.GetEventQuestIdFound(eventID)) then
			RSLogger:PrintDebugMessage(string.format("Evento [%s]. Buscando questID...", eventID))
			RSQuestTracker.FindCompletedHiddenQuestID(eventID, function(eventID, newQuestID) 
				RSEventDB.SetEventQuestIdFound(eventID, newQuestID) 
			end)
		else
			RSLogger:PrintDebugMessage(string.format("El Evento [%s] ya dispone de questID [%s]", eventID, unpack(eventInternalInfo.questID)))
		end
	end

	-- Disable guideance icons if enabled
	if (RSGeneralDB.HasGuideActive(eventID) and RSEventDB.IsEventCompleted(eventID)) then
		RSGeneralDB.RemoveGuideActive()
		RSMinimap.RemoveGuide(eventID)
	end

	-- Disable overlay icons if enabled
	if (RSGeneralDB.HasOverlayActive(eventID) and RSEventDB.IsEventCompleted(eventID)) then
		RSGeneralDB.RemoveOverlayActive(eventID)
		RSMinimap.RemoveOverlay(eventID)
	end
		
	-- Refresh minimap
	if (not loadingAddon) then
		RSMinimap.HideIcon(eventID, x, y)
	end
end
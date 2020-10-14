-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSRespawnTracker = private.NewLib("RareScannerRespawnTracker")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")

-- Timers
local CHECK_RESPAWN_TIMER

---============================================================================
-- Tracks respawning
---============================================================================

local currentReCheckTickers = {
  npcs = {},
  containers = {},
  events = {}
}

local function ReCheckRespawnTimers()
  -- Check for the lists
	for npcID, info in pairs (currentReCheckTickers.npcs) do
  	if (C_QuestLog.IsQuestFlaggedCompleted(info.q)) then
  		if (info.n == 0) then
  			RSNpcDB.SetNpcKilled(npcID)
        currentReCheckTickers.npcs[npcID] = nil
        RSLogger:PrintDebugMessageEntityID(npcID, string.format("ReCheckRespawnTimers [NPC: %s]. Muerto para siempre!", npcID))
        RSLogger:PrintDebugMessageEntityID(npcID, string.format("- Quest [%s] asociada.", info.q))
  		else
  			currentReCheckTickers.npcs[npcID].n = (info.n - 1)
        RSLogger:PrintDebugMessageEntityID(npcID, string.format("ReCheckRespawnTimers [info.n: %s].", info.n))
  		end
  	-- Otherwise it has respawn
  	else
  		RSLogger:PrintDebugMessageEntityID(npcID, string.format("ReCheckRespawnTimers [NPC: %s]. Respawn!", npcID))
  		RSNpcDB.DeleteNpcKilled(npcID)
      currentReCheckTickers.npcs[npcID] = nil
  	end
  end
  
  for containerID, info in pairs (currentReCheckTickers.containers) do
		-- If it remains opened the container is not coming back
		if (C_QuestLog.IsQuestFlaggedCompleted(info.q)) then
			if (info.n == 0) then
				RSContainerDB.SetContainerOpened(containerID)
        currentReCheckTickers.containers[containerID] = nil
        RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [Contenedor: %s]. Abierto para siempre!", containerID))
        RSLogger:PrintDebugMessage(string.format("- Quest [%s] asociada.", info.q))
			else
				currentReCheckTickers.containers[containerID].n = (info.n - 1)
        RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [numOfTries: %s].", info.n))
			end
		-- Otherwise it has respawn
		else
			RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [Contenedor: %s]. Respawn!", containerID))
			RSContainerDB.DeleteContainerOpened(containerID)
      currentReCheckTickers.containers[containerID] = nil
		end
	end
  
  for eventID, info in pairs (currentReCheckTickers.events) do
		-- If it remains opened the container is not coming back
		if (C_QuestLog.IsQuestFlaggedCompleted(info.q)) then
			if (info.n == 0) then
				RSEventDB.SetEventCompleted(eventID)
        currentReCheckTickers.events[eventID] = nil
        RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [Evento: %s]. Completo para siempre!", eventID))
        RSLogger:PrintDebugMessage(string.format("- Quest [%s] asociada.", info.q))
			else
				currentReCheckTickers.containers[eventID].n = (info.n - 1)
        RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [numOfTries: %s].", info.n))
			end
		-- Otherwise it has respawn
		else
			RSLogger:PrintDebugMessage(string.format("ReCheckRespawnTimers [Evento: %s]. Respawn!", eventID))
			RSEventDB.DeleteEventCompleted(eventID)
			currentReCheckTickers[info.q] = nil
		end
	end
end

local function CheckRespawnTimers()
	-- Look for NPCs that have already respawn 
	for npcID, respawnTime in pairs (RSNpcDB.GetAllNpcsKilledRespawnTimes()) do
		if (respawnTime > 0 and respawnTime < time()) then
			-- If the associated quest is completed it means that this rare NPC is still dead
			-- It's possible that the quest takes a little bit longer to reset, so check for this NPC later
			local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
			local hasRespawn = true
			if (npcInfo and npcInfo.questID and not npcInfo.reset and not npcInfo.questReset and not npcInfo.weeklyReset and not npcInfo.resetTimer) then  
				for _, questID in ipairs (npcInfo.questID) do
					if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
						-- Check this same NPC every 5 minutes during the next 15
            RSLogger:PrintDebugMessageEntityID(npcID, string.format("CheckRespawnTimers [NPC: %s], sigue muerto acorde a su quest [%s]", npcID, questID))
            if (not currentReCheckTickers.npcs[npcID]) then
              currentReCheckTickers.npcs[npcID] = { q = questID, n = 3 }
						end
						hasRespawn = false
						break
					end
				end
			end
			
			if (hasRespawn) then
        RSLogger:PrintDebugMessageEntityID(npcID, string.format("CheckRespawnTimers [NPC: %s]. Respawn!", npcID))
        RSNpcDB.DeleteNpcKilled(npcID)
      end
		end
	end
	
	-- Look for containers that have already respawn
	for containerID, respawnTime in pairs (RSContainerDB.GetAllContainersOpenedRespawnTimes()) do
		if (respawnTime > 0 and respawnTime < time()) then
			-- If the associated quest is completed it means that this container is still closed
			-- It's possible that the quest takes a little bit longer to reset, so check for this container later
			local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
      local hasRespawn = true
			if (containerInfo and containerInfo.questID and not containerInfo.reset and not containerInfo.questReset and not containerInfo.weeklyReset and not containerInfo.resetTimer) then
				for _, questID in ipairs (containerInfo.questID) do
					if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
            RSLogger:PrintDebugMessage(string.format("CheckRespawnTimers [Contenedor: %s], sigue cerrado acorde a su quest [%s]", containerID, questID))
            if (not currentReCheckTickers.containers[containerID]) then
              currentReCheckTickers.containers[containerID] = { q = questID, n = 3 }
						end
            hasRespawn = false
						break
					end
				end
			end
			
      if (hasRespawn) then
        RSLogger:PrintDebugMessage(string.format("CheckRespawnTimers [Contenedor: %s]. Respawn!", containerID))
        RSContainerDB.DeleteContainerOpened(containerID)
      end
		end
	end
	
	-- Look for events that have already respawn
	for eventID, respawnTime in pairs (RSEventDB.GetAllEventsCompletedRespawnTimes()) do
		if (respawnTime > 0 and respawnTime < time()) then
			-- If the associated quest is completed it means that this event is still completed
			-- It's possible that the quest takes a little bit longer to reset, so check for this event later
			local eventInfo = RSEventDB.GetInternalEventInfo(eventID)
      local hasRespawn = true
			if (eventInfo and eventInfo.questID and not eventInfo.reset and not eventInfo.questReset and not eventInfo.weeklyReset and not eventInfo.resetTimer) then
				for _, questID in ipairs (eventInfo.questID) do
					if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
            RSLogger:PrintDebugMessage(string.format("CheckRespawnTimers [Evento: %s], sigue completo acorde a su quest [%s]", eventID, questID))
						-- Check this same event every 5 minutes during the next 15
						if (not currentReCheckTickers.events[eventID]) then
              currentReCheckTickers.containers[eventID] = { q = questID, n = 3 }
						end
            hasRespawn = false
						break
          end
				end
			end
			
      if (hasRespawn) then
        RSLogger:PrintDebugMessage(string.format("CheckRespawnTimers [Evento: %s]. Respawn!", eventID))
        RSEventDB.DeleteEventCompleted(eventID)
      end
		end
	end
end

function RSRespawnTracker.Init()
  if (not CHECK_RESPAWN_TIMER) then
    CheckRespawnTimers()
    
    CHECK_RESPAWN_TIMER = C_Timer.NewTicker(RSConstants.CHECK_RESPAWNING_BY_LASTSEEN_TIMER, function() 
      CheckRespawnTimers()
    end)
    
    C_Timer.NewTicker(RSConstants.CHECK_RESPAWN_BY_QUEST_TIMER, function() 
      ReCheckRespawnTimers()
    end)
  end
end
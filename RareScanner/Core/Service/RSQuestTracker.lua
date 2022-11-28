-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSQuestTracker = private.NewLib("RareScannerQuestTracker")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")


---============================================================================
-- Cache all the quests completed by the player
---============================================================================

function RSQuestTracker.CacheAllCompletedQuestIDs()
	if (not RSConstants.DEBUG_MODE) then
		return
	end
	
	for _, questID in ipairs (C_QuestLog.GetAllCompletedQuestIDs()) do
		RSGeneralDB.SetCompletedQuest(questID)
	end
	C_Timer.After(RSConstants.CACHE_ALL_COMPLETED_QUEST_IDS_TIMER , function()
		RSQuestTracker.CacheAllCompletedQuestIDs()
	end)
end

---============================================================================
-- Finds hidden completed quest IDs
---============================================================================

function RSQuestTracker.FindCompletedHiddenQuestID(entityID, callbackOnFound)
	if (not RSConstants.DEBUG_MODE) then
		return
	end
	
	C_Timer.After(RSConstants.FIND_HIDDEN_QUESTS_TIMER, function()
		local newQuestID
		for i, questID in ipairs (C_QuestLog.GetAllCompletedQuestIDs()) do
			if (not RSGeneralDB.IsCompletedQuestInCache(questID)) then
				RSGeneralDB.SetCompletedQuest(questID)
				if (not newQuestID) then
					RSLogger:PrintDebugMessage(string.format("Misión oculta [%s]. Encontrada.", questID))
					newQuestID = questID
				elseif (newQuestID) then
					RSLogger:PrintDebugMessage(string.format("Misión oculta [%s]. Encontrada (no sabemos cual es la buena).", questID))
					break;
				end
			end
		end

		if (newQuestID) then
			callbackOnFound(entityID, newQuestID)
		else
			RSLogger:PrintDebugMessage("No se ha encontrado misión.")
		end
	end)
end

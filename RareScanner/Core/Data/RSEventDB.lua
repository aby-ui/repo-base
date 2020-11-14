-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSEventDB = private.NewLib("RareScannerEventDB")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")

---============================================================================
-- Completed events database
---============================================================================

function RSEventDB.InitEventCompletedDB()
	if (not private.dbchar.events_completed) then
		private.dbchar.events_completed = {}
	end
end

function RSEventDB.IsEventCompleted(eventID)
	if (eventID and private.dbchar.events_completed[eventID]) then
		return true;
	end

	return false
end

function RSEventDB.GetAllEventsCompletedRespawnTimes()
	return private.dbchar.events_completed
end

function RSEventDB.GetEventCompletedRespawnTime(eventID)
	if (RSEventDB.IsEventCompleted(eventID)) then
		return private.dbchar.events_completed[eventID]
	end

	return 0
end

function RSEventDB.SetEventCompleted(eventID, respawnTime)
	if (eventID) then
		if (not respawnTime) then
			private.dbchar.events_completed[eventID] = RSConstants.ETERNAL_COMPLETED
		else
			private.dbchar.events_completed[eventID] = respawnTime
		end
	end
end

function RSEventDB.DeleteEventCompleted(eventID)
	if (eventID) then
		private.dbchar.events_completed[eventID] = nil
	end
end

---============================================================================
-- Event internal database
----- Stores events information included with the addon
---============================================================================

function RSEventDB.GetAllInternalEventInfo()
	return private.EVENT_INFO
end

function RSEventDB.GetInternalEventInfo(eventID)
	if (eventID) then
		return private.EVENT_INFO[eventID]
	end

	return nil
end

function RSEventDB.IsInternalEventInMap(eventID, mapID)
	if (eventID and mapID) then
		local eventInfo = RSEventDB.GetInternalEventInfo(eventID)
		if (eventInfo.zoneID == mapID) then
			return true;
		end
	end

	return false;
end

---============================================================================
-- Event quest IDs database
----- Stores Events hidden quest IDs
---============================================================================

function RSEventDB.InitEventQuestIdFoundDB()
	if (not private.dbglobal.event_quest_ids) then
		private.dbglobal.event_quest_ids = {}
	end
end

function RSEventDB.GetAllEventQuestIdsFound()
	return private.dbglobal.event_quest_ids
end

function RSEventDB.SetEventQuestIdFound(eventID, questID)
	if (eventID and questID) then
		private.dbglobal.event_quest_ids[eventID] = { questID }
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Calculado questID [%s]", eventID, questID))
	end
end

function RSEventDB.GetEventQuestIdFound(eventID)
	if (eventID and private.dbglobal.event_quest_ids[eventID]) then
		return private.dbglobal.event_quest_ids[eventID]
	end

	return nil
end

function RSEventDB.RemoveEventQuestIdFound(eventID)
	if (eventID) then
		private.dbglobal.event_quest_ids[eventID] = nil
	end
end

---============================================================================
-- Events names database
----- Stores names of events included with the addon
---============================================================================

function RSEventDB.InitEventNamesDB()
	if (not private.dbglobal.event_names) then
		private.dbglobal.event_names = {}
	end

	if (not private.dbglobal.event_names[GetLocale()]) then
		private.dbglobal.event_names[GetLocale()] = {}
	end
end

function RSEventDB.SetEventName(eventID, name)
	if (eventID and name) then
		private.dbglobal.event_names[GetLocale()][eventID] = name
	end
end

function RSEventDB.GetEventName(eventID)
	if (eventID and private.dbglobal.event_names[GetLocale()][eventID]) then
		return private.dbglobal.event_names[GetLocale()][eventID]
	end

	return nil
end

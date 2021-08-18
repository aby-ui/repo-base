-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSEventPOI = private.NewLib("RareScannerEventPOI")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSAchievementDB = private.ImportLib("RareScannerAchievementDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")


---============================================================================
-- Not discovered entities
--- In order to avoid long process time, it caches these list on load
---============================================================================

local notDiscoveredEventIDs = {}

function RSEventPOI.InitializeNotDiscoveredEvents()
	for eventID, _ in pairs (RSEventDB.GetAllInternalEventInfo()) do
		if (not RSGeneralDB.GetAlreadyFoundEntity(eventID)) then
			notDiscoveredEventIDs[eventID] = true
		end
	end
end

local function RemoveNotDiscoveredEvent(eventID)
	if (eventID) then
		notDiscoveredEventIDs[eventID] = nil
	end
end

---============================================================================
-- Event POIs
---- Manage adding Event icons to the world map and minimap
---============================================================================

local function GetEventPOI(eventID, mapID, eventInfo, alreadyFoundInfo)
	local POI = {}
	POI.entityID = eventID
	POI.isEvent = true
	POI.name = RSEventDB.GetEventName(eventID) or AL["EVENT"]
	POI.mapID = mapID
	if (alreadyFoundInfo) then
		POI.x = alreadyFoundInfo.coordX
		POI.y = alreadyFoundInfo.coordY
	else
		POI.x = eventInfo.x
		POI.y = eventInfo.y
	end
	POI.foundTime = alreadyFoundInfo and alreadyFoundInfo.foundTime
	POI.isCompleted = RSEventDB.IsEventCompleted(eventID)
	POI.isDiscovered = POI.isCompleted or alreadyFoundInfo ~= nil
	POI.achievementLink = RSAchievementDB.GetNotCompletedAchievementLink(eventID, mapID)
	if (eventInfo) then
		POI.worldmap = eventInfo.worldmap
	end
	
	-- Textures
	if (POI.isCompleted) then
		POI.Texture = RSConstants.BLUE_EVENT_TEXTURE
	elseif (RSGeneralDB.IsRecentlySeen(eventID)) then
		POI.Texture = RSConstants.PINK_EVENT_TEXTURE
	elseif (not POI.isDiscovered and not POI.achievementLink) then
		POI.Texture = RSConstants.RED_EVENT_TEXTURE
	elseif (not POI.isDiscovered and POI.achievementLink) then
		POI.Texture = RSConstants.YELLOW_EVENT_TEXTURE
	elseif (POI.achievementLink) then
		POI.Texture = RSConstants.GREEN_EVENT_TEXTURE
	else
		POI.Texture = RSConstants.NORMAL_EVENT_TEXTURE
	end

	return POI
end

local function IsEventPOIFiltered(eventID, mapID, zoneQuestID, vignetteGUIDs, onWorldMap, onMinimap)
	local name = RSEventDB.GetEventName(eventID) or AL["EVENT"]
	-- Skip if filtering by name in the world map search box
	if (name and RSGeneralDB.GetWorldMapTextFilter() and not RSUtils.Contains(name, RSGeneralDB.GetWorldMapTextFilter())) then
		RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Filtrado por nombre [%s][%s].", eventID, name, RSGeneralDB.GetWorldMapTextFilter()))
		return true
	end

	-- Skip if the entity appears only while a quest event is going on and it isnt active
	if (zoneQuestID) then
		local active = false
		for _, questID in ipairs(zoneQuestID) do
			if (C_TaskQuest.IsActive(questID) or C_QuestLog.IsQuestFlaggedCompleted(questID)) then
				active = true
				break
			end
		end

		if (not active) then
			RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Evento asociado no esta activo.", eventID))
			return true
		end
	end

	-- A 'not discovered' event will be setted as completed when the action is detected while loading the addon and its questID is completed
	local eventCompleted = RSEventDB.IsEventCompleted(eventID)

	-- Skip if completed and not showing completed entities
	if (eventCompleted and not RSConfigDB.IsShowingCompletedEvents()) then
		RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Esta completado.", eventID))
		return true
	end

	-- Skip if an ingame vignette is already showing this entity (on Vignette)
	for _, vignetteGUID in ipairs(vignetteGUIDs) do
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID);
		if (vignetteInfo and vignetteInfo.objectGUID) then
			local _, _, _, _, _, vignetteNPCID, _ = strsplit("-", vignetteInfo.objectGUID);
			if (tonumber(vignetteNPCID) == eventID and onWorldMap and vignetteInfo.onWorldMap) then
				RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Hay un vignette del juego mostrándolo (Vignette onWorldmap).", eventID))
				return true
			end
			if (tonumber(vignetteNPCID) == eventID and onMinimap and vignetteInfo.onMinimap) then
				RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Hay un vignette del juego mostrándolo (Vignette onMinimap).", eventID))
				return true
			end
		end
	end

	return false
end

function RSEventPOI.GetMapNotDiscoveredEventPOIs(mapID, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing event icons
	if (not RSConfigDB.IsShowingEvents()) then
		return
	end

	local POIs = {}
	for eventID, _ in pairs(notDiscoveredEventIDs) do
		local filtered = false
		local eventInfo = RSEventDB.GetInternalEventInfo(eventID)

		-- Skip if it was discovered in this session
		if (RSGeneralDB.GetAlreadyFoundEntity(eventID)) then
			RemoveNotDiscoveredEvent(eventID)
			RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento N/D [%s]: Ya no es 'no descubierto'.", eventID))
			filtered = true
		end

		-- Skip if the entity belong to a different mapID/artID that the one displaying
		if (not filtered and not RSEventDB.IsInternalEventInMap(eventID, mapID)) then
			RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento N/D [%s]: En distinta zona.", eventID))
			filtered = true
		end

		-- Skip if common filters
		if (not filtered and not IsEventPOIFiltered(eventID, mapID, eventInfo.zoneQuestId, vignetteGUIDs, onWorldMap, onMinimap)) then
			tinsert(POIs, GetEventPOI(eventID, mapID, eventInfo))
		end
	end

	return POIs
end

function RSEventPOI.GetMapAlreadyFoundEventPOI(eventID, alreadyFoundInfo, mapID, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing events icons
	if (not RSConfigDB.IsShowingEvents()) then
		RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Iconos de eventos deshabilitado.", eventID))
		return
	end

	local eventInfo = RSEventDB.GetInternalEventInfo(eventID)
	local eventCompleted = RSEventDB.IsEventCompleted(eventID)

	-- Skip if the entity has been seen before the max amount of time that the player want to see the icon on the map
	-- This filter doesnt apply to completed entities
	if (not eventCompleted and RSConfigDB.IsMaxSeenTimeEventFilterEnabled() and time() - alreadyFoundInfo.foundTime > RSTimeUtils.MinutesToSeconds(RSConfigDB.GetMaxSeenEventTimeFilter())) then
		RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltado Evento [%s]: Visto hace demasiado tiempo.", eventID))
		return
	end

	-- Skip if the entity belongs to a different map that the one displaying
	-- First checks with the already found information
	local correctMap = false
	if (RSGeneralDB.IsAlreadyFoundEntityInZone(eventID, mapID)) then
		correctMap = true
	end

	-- Then checks with the internal found information just in case its a multizone
	-- Its possible that the player is opening a map where this NPC can show up, but the last time seen was in a different map
	if (not correctMap and (not eventInfo or not RSEventDB.IsInternalEventInMap(eventID, mapID))) then
		RSLogger:PrintDebugMessageEntityID(eventID, string.format("Saltando Evento [%s]: En distinta zona.", eventID))
		return
	end

	-- Skip if common filters
	local zoneQuestID
	if (eventInfo) then
		zoneQuestID = eventInfo.zoneQuestId
	end

	if (not IsEventPOIFiltered(eventID, mapID, zoneQuestID, vignetteGUIDs, onWorldMap, onMinimap)) then
		return GetEventPOI(eventID, mapID, eventInfo, alreadyFoundInfo)
	end
end

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSContainerPOI = private.NewLib("RareScannerContainerPOI")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSAchievementDB = private.ImportLib("RareScannerAchievementDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")

-- RareScanner services
local RSRecentlySeenTracker = private.ImportLib("RareScannerRecentlySeenTracker")


---============================================================================
-- Not discovered entities
--- In order to avoid long process time, it caches this list on load
---============================================================================

local notDiscoveredContainerIDs = {}

function RSContainerPOI.InitializeNotDiscoveredContainers()
	for containerID, _ in pairs (RSContainerDB.GetAllInternalContainerInfo()) do
		if (not RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
			notDiscoveredContainerIDs[containerID] = true
		end
	end
end

local function RemoveNotDiscoveredContainer(containerID)
	if (containerID) then
		notDiscoveredContainerIDs[containerID] = nil
	end
end

---============================================================================
-- Container Map POIs
---- Manage adding Container icons to the world map and minimap
---============================================================================

function RSContainerPOI.GetContainerPOI(containerID, mapID, containerInfo, alreadyFoundInfo)
	local POI = {}
	POI.entityID = containerID
	POI.isContainer = true
	POI.grouping = true
	POI.name = RSContainerDB.GetContainerName(containerID) or AL["CONTAINER"]
	POI.mapID = mapID
	if (alreadyFoundInfo and alreadyFoundInfo.mapID == mapID) then
		POI.x = alreadyFoundInfo.coordX
		POI.y = alreadyFoundInfo.coordY
	else
		POI.x, POI.y = RSContainerDB.GetInternalContainerCoordinates(containerID, mapID)
	end
	POI.foundTime = alreadyFoundInfo and alreadyFoundInfo.foundTime
	POI.isOpened = RSContainerDB.IsContainerOpened(containerID)
	POI.isDiscovered = POI.isOpened or alreadyFoundInfo ~= nil
	POI.achievementIDs = RSAchievementDB.GetNotCompletedAchievementIDsByMap(containerID, mapID)
	if (containerInfo) then
		POI.worldmap = containerInfo.worldmap
		POI.factionID = containerInfo.factionID
	end

	-- Textures
	if (POI.isOpened) then
		POI.Texture = RSConstants.BLUE_CONTAINER_TEXTURE
	elseif (RSRecentlySeenTracker.IsRecentlySeen(containerID, POI.x, POI.y)) then
		POI.Texture = RSConstants.PINK_CONTAINER_TEXTURE
	elseif (not POI.isDiscovered and RSUtils.GetTableLength(POI.achievementIDs) == 0) then
		POI.Texture = RSConstants.RED_CONTAINER_TEXTURE
	elseif (not POI.isDiscovered and RSUtils.GetTableLength(POI.achievementIDs) > 0) then
		POI.Texture = RSConstants.YELLOW_CONTAINER_TEXTURE
	elseif (RSUtils.GetTableLength(POI.achievementIDs) > 0) then
		POI.Texture = RSConstants.GREEN_CONTAINER_TEXTURE
	else
		POI.Texture = RSConstants.NORMAL_CONTAINER_TEXTURE
	end

	return POI
end

local function IsContainerPOIFiltered(containerID, mapID, zoneQuestID, prof, vignetteGUIDs, onWorldMap, onMinimap)
	local name = RSContainerDB.GetContainerName(containerID) or AL["CONTAINER"]
	-- Skip if filtering by name in the world map search box
	if (name and RSGeneralDB.GetWorldMapTextFilter() and not RSUtils.Contains(name, RSGeneralDB.GetWorldMapTextFilter())) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Filtrado por nombre [%s][%s].", containerID, name, RSGeneralDB.GetWorldMapTextFilter()))
		return true
	end

	-- Skip it it is the garrison cache and its disabled
	if (not RSConfigDB.IsShowingGarrisonCache()) then
		-- check if the container is the garrison cache
		if (RSUtils.Contains(RSConstants.GARRISON_CACHE_IDS, containerID)) then
			return
		end
	end

	-- Skip if the entity is filtered
	if (RSConfigDB.IsContainerFiltered(containerID) or RSConfigDB.IsContainerFilteredOnlyWorldmap(containerID)) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Filtrado en opciones (filtro completo o mapa del mundo).", containerID))
		return true
	end
	
	-- Skip if not trackeable and filtered
	if (not RSConfigDB.IsShowingNotTrackeableContainers() and RSUtils.Contains(RSConstants.CONTAINERS_WITHOUT_VIGNETTE, containerID)) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Filtrado contenedor no rastreable.", containerID))
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
			RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Evento asociado no esta activo.", containerID))
			return true
		end
	end

	-- A 'not discovered' container will be setted as opened when the action is detected while loading the addon and its questID is completed
	local containerOpened = RSContainerDB.IsContainerOpened(containerID)

	-- Skip if opened and not showing opened entities
	if (containerOpened and not RSConfigDB.IsShowingOpenedContainers()) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Esta abierto.", containerID))
		return true
	end
	
	-- Skip if wrong profession
	if (prof) then
		local pindex1, pindex2, _, _, _, _ = GetProfessions();
		local matches
		if (pindex1) then
			local _, _, _, _, _, _, skillLine, _, _, _ = GetProfessionInfo(pindex1)
			matches = skillLine and skillLine == prof
		end
		if (not matches and pindex2) then
			local _, _, _, _, _, _, skillLine, _, _, _ = GetProfessionInfo(pindex2)
			matches = skillLine and skillLine == prof
		end
		
		if (not matches) then
			RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Profesión incorrecta.", containerID))
			return true
		end
	end

	-- Skip if an ingame vignette is already showing this entity (on Vignette)
	-- We do it only in the world map
	if (onWorldMap) then
		for _, vignetteGUID in ipairs(vignetteGUIDs) do
			local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID);
			if (vignetteInfo and vignetteInfo.objectGUID) then
				local _, _, _, _, _, vignetteNPCID, _ = strsplit("-", vignetteInfo.objectGUID);
				if (tonumber(vignetteNPCID) == containerID and onWorldMap and vignetteInfo.onWorldMap) then
					RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Hay un vignette del juego mostrándolo (Vignette onWorldmap).", containerID))
					return true
				end
				--if (tonumber(vignetteNPCID) == containerID and onMinimap and vignetteInfo.onMinimap) then
				--	RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Hay un vignette del juego mostrándolo (Vignette onMinimap).", containerID))
				--	return true
				--end
			end
		end
	end

	return false
end

function RSContainerPOI.GetMapNotDiscoveredContainerPOIs(mapID, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing container icons
	if (not RSConfigDB.IsShowingContainers()) then
		return
	end

	local POIs = {}
	for containerID, _ in pairs(notDiscoveredContainerIDs) do
		local filtered = false
		local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)

		-- Skip if it was discovered in this session
		if (RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
			RemoveNotDiscoveredContainer(containerID)
			RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor N/D [%s]: Ya no es 'no descubierto'.", containerID))
			filtered = true
		end

		-- Skip if the entity belong to a different mapID/artID that the one displaying
		if (not filtered and not RSContainerDB.IsInternalContainerInMap(containerID, mapID)) then
			RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor N/D [%s]: En distinta zona (no descubierto).", containerID))
			filtered = true
		end

		-- Skip if common filters
		if (not filtered and not IsContainerPOIFiltered(containerID, mapID, containerInfo.zoneQuestId, containerInfo.prof, vignetteGUIDs, onWorldMap, onMinimap)) then
			tinsert(POIs, RSContainerPOI.GetContainerPOI(containerID, mapID, containerInfo))
		end
	end

	return POIs
end

function RSContainerPOI.GetMapAlreadyFoundContainerPOI(containerID, alreadyFoundInfo, mapID, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing container icons
	if (not RSConfigDB.IsShowingContainers()) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Iconos de contenedores deshabilitado.", containerID))
		return
	end

	local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
	local containerOpened = RSContainerDB.IsContainerOpened(containerID)

	-- Skip if the entity has been seen before the max amount of time that the player want to see the icon on the map
	-- This filter doesnt apply to opened entities or worldmap containers
	if (not containerOpened and (containerInfo and not containerInfo.worldmap) and RSConfigDB.IsMaxSeenTimeContainerFilterEnabled() and time() - alreadyFoundInfo.foundTime > RSTimeUtils.MinutesToSeconds(RSConfigDB.GetMaxSeenContainerTimeFilter())) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltado Contenedor [%s]: Visto hace demasiado tiempo.", containerID))
		return
	end

	-- Skip if the entity belongs to a different map that the one displaying
	-- First checks with the already found information
	local correctMap = false
	if (RSGeneralDB.IsAlreadyFoundEntityInZone(containerID, mapID)) then
		correctMap = true
	end

	-- Then checks with the internal found information just in case its a multizone
	-- Its possible that the player is opening a map where this container can show up, but the last time seen was in a different map
	if (not correctMap and (not containerInfo or not RSContainerDB.IsInternalContainerInMap(containerID, mapID))) then
		RSLogger:PrintDebugMessageEntityID(containerID, string.format("Saltando Contenedor [%s]: En distinta zona.", containerID))
		return
	end

	-- Skip if common filters
	local zoneQuestID
	local prof
	if (containerInfo) then
		zoneQuestID = containerInfo.zoneQuestId
		prof = containerInfo.prof
	end

	if (not IsContainerPOIFiltered(containerID, mapID, zoneQuestID, prof, vignetteGUIDs, onWorldMap, onMinimap)) then
		return RSContainerPOI.GetContainerPOI(containerID, mapID, containerInfo, alreadyFoundInfo)
	end
end

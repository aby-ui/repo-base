-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSNpcPOI = private.NewLib("RareScannerNpcPOI")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSAchievementDB = private.ImportLib("RareScannerAchievementDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")

-- RareScanner services
local RSRecentlySeenTracker = private.ImportLib("RareScannerRecentlySeenTracker")

---============================================================================
-- Not discovered entities
--- In order to avoid long process time, it caches these list on load
---============================================================================

local notDiscoveredNpcIDs = {}

function RSNpcPOI.InitializeNotDiscoveredNpcs()
	for npcID, _ in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
		if (not RSGeneralDB.GetAlreadyFoundEntity(npcID)) then
			notDiscoveredNpcIDs[npcID] = true
		end
	end
end

local function RefreshNotDiscoveredNpcs(npcID)
	if (not RSGeneralDB.GetAlreadyFoundEntity(npcID) and not notDiscoveredNpcIDs[npcID]) then
		notDiscoveredNpcIDs[npcID] = true
	end
end

local function RemoveNotDiscoveredNpc(npcID)
	if (npcID) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("RemoveNotDiscoveredNpc. NPC [%s] pasa a estar 'descubierto'", npcID))
		notDiscoveredNpcIDs[npcID] = nil
	end
end

---============================================================================
-- Storm invasion NOCs POIs
---- NPCs that are part of a storm invasion event (Dragonflight)
---============================================================================

local function GetStormInvasionAtlasName(npcID, mapID)
  if (RSUtils.Contains(RSConstants.FIRE_STORM_EVENTS_NPCS, npcID)) then
    return RSConstants.FIRE_STORM_ATLAS 
  elseif (RSUtils.Contains(RSConstants.WATER_STORM_EVENTS_NPCS, npcID)) then
    return RSConstants.WATER_STORM_ATLAS 
  elseif (RSUtils.Contains(RSConstants.EARTH_STORM_EVENTS_NPCS, npcID)) then
    return RSConstants.EARTH_STORM_ATLAS 
  elseif (RSUtils.Contains(RSConstants.AIR_STORM_EVENTS_NPCS, npcID)) then
    return RSConstants.AIR_STORM_ATLAS
  end
  
  return nil
end

local function GetStormInvasionXY(npcID, mapID)
  local npcStormAtlasName = GetStormInvasionAtlasName(npcID, mapID) 
  if (not npcStormAtlasName) then
    return nil
  end
   
  local areaPOIs = GetAreaPOIsForPlayerByMapIDCached(mapID);
  for _, areaPoiID in ipairs(areaPOIs) do
    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapID, areaPoiID);
    if (poiInfo and poiInfo.atlasName == npcStormAtlasName) then
      local x, y = poiInfo.position:GetXY()
      local mapNpcInfo = RSNpcDB.GetInternalNpcInfoByMapID(npcID, mapID)
      if (not mapNpcInfo or not mapNpcInfo.overlay) then
        return x, y
      else
        local xyDistances = {}
        for _, coordinatePair in ipairs (mapNpcInfo.overlay) do
          local coordx, coordy =  strsplit("-", coordinatePair)
          local distance = RSUtils.DistanceBetweenCoords(coordx, x, coordy, y)
          if (distance > 0.01) then
            xyDistances[coordinatePair] = distance
          end
        end
  
        if (RSUtils.GetTableLength(xyDistances) == 0) then
          return x, y
        end
  
        local distances = {}
        for xy, distance in pairs (xyDistances) do
          table.insert(distances, distance)
        end
        
        local min = math.min(unpack(distances))
        for xy, distance in pairs (xyDistances) do
          if (distance == min) then
            local xo, yo = strsplit("-", xy)
            return xo, yo
          end
        end
      end
    end
  end
end

---============================================================================
-- NPC Map POIs
---- Manage adding NPC icons to the world map and minimap
---============================================================================

function RSNpcPOI.GetNpcPOI(npcID, mapID, npcInfo, alreadyFoundInfo)
	local POI = {}
	POI.entityID = npcID
	POI.isNpc = true
	POI.grouping = true
	POI.name = RSNpcDB.GetNpcName(npcID)
	POI.mapID = mapID
	if (alreadyFoundInfo and alreadyFoundInfo.mapID == mapID) then
		POI.x = alreadyFoundInfo.coordX
		POI.y = alreadyFoundInfo.coordY
	else
	  if (GetStormInvasionAtlasName(npcID, mapID)) then
	    POI.x, POI.y = GetStormInvasionXY(npcID, mapID)
	  else
		  POI.x, POI.y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
		end
	end
	POI.foundTime = alreadyFoundInfo and alreadyFoundInfo.foundTime
	POI.isDead = RSNpcDB.IsNpcKilled(npcID)
	POI.isDiscovered = POI.isDead or alreadyFoundInfo ~= nil
	POI.isFriendly = RSNpcDB.IsInternalNpcFriendly(npcID)
	POI.achievementIDs = RSAchievementDB.GetNotCompletedAchievementIDsByMap(npcID, mapID)
	if (npcInfo) then
		POI.worldmap = npcInfo.worldmap
	end
	
	-- Textures
	if (POI.isDead) then
		POI.Texture = RSConstants.BLUE_NPC_TEXTURE
	elseif (POI.isFriendly) then
		POI.Texture = RSConstants.LIGHT_BLUE_NPC_TEXTURE
	elseif (RSRecentlySeenTracker.IsRecentlySeen(npcID, POI.x, POI.y)) then
		POI.Texture = RSConstants.PINK_NPC_TEXTURE
	elseif (not POI.isDiscovered and RSUtils.GetTableLength(POI.achievementIDs) == 0) then
		POI.Texture = RSConstants.RED_NPC_TEXTURE
	elseif (not POI.isDiscovered and RSUtils.GetTableLength(POI.achievementIDs) > 0) then
		POI.Texture = RSConstants.YELLOW_NPC_TEXTURE
	elseif (RSUtils.GetTableLength(POI.achievementIDs) > 0) then
		POI.Texture = RSConstants.GREEN_NPC_TEXTURE
	else
		POI.Texture = RSConstants.NORMAL_NPC_TEXTURE
	end

	return POI
end

local function IsNpcPOIFiltered(npcID, mapID, artID, zoneQuestID, questTitles, vignetteGUIDs, onWorldMap, onMinimap)
	local name = RSNpcDB.GetNpcName(npcID)
	
	-- Skip if part of a disabled event
	if (RSNpcDB.IsDisabledEvent(npcID)) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Parte de un evento desactivado.", npcID))
		return true
	end
	
	-- Skip if filtering by name in the world map search box
	if (name and RSGeneralDB.GetWorldMapTextFilter() and not RSUtils.Contains(name, RSGeneralDB.GetWorldMapTextFilter())) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Filtrado por nombre [%s][%s].", npcID, name, RSGeneralDB.GetWorldMapTextFilter()))
		return true
	end

	-- Skip if the entity is filtered
	if (RSConfigDB.IsNpcFiltered(npcID) and not RSNpcDB.IsWorldMap(npcID) and (not RSConfigDB.IsNpcFilteredOnlyOnWorldMap() or (RSConfigDB.IsNpcFilteredOnlyOnWorldMap() and not RSGeneralDB.IsRecentlySeen(npcID)))) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Filtrado en opciones.", npcID))
		return true
	end

	-- Skip if not showing friendly NPCs and this one is friendly
	if (not RSConfigDB.IsShowingFriendlyNpcs() and RSNpcDB.IsInternalNpcFriendly(npcID)) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Es amistoso.", npcID))
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
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Evento asociado no esta activo.", npcID))
			return true
		end
	end

	-- Skip if for whatever reason we don't have its name (this shouldnt happend)
	local npcName = RSNpcDB.GetNpcName(npcID)
	if (not npcName) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Le falta el nombre!.", npcID))
		return true
	end

	-- Skip if this NPC has a world quest active right now
	-- We don't want to show our icon on top of the quest one
	if (RSUtils.Contains(questTitles, npcName)) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Tiene misión del mundo activa.", npcID))
		return true
	end
	
	-- Skip if storm NPC and the event isn't up
	if (GetStormInvasionAtlasName(npcID, mapID) and not GetStormInvasionXY(npcID, mapID)) then
    RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Invasión de tormentas que no esta activa.", npcID))
    return true
	end

	-- A 'not discovered' NPC will be setted as killed when the kill is detected while loading the addon and its questID is completed
	local npcDead = RSNpcDB.IsNpcKilled(npcID)

	-- Skip if dead 
	if (npcDead) then
		-- and not showing dead entities in 'not reseteable' maps
		if (RSConfigDB.IsShowingDeadNpcsInReseteableZones() and not RSMapDB.IsReseteableKillMapID(mapID, artID)) then
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Esta muerto (zona no reseteable).", npcID))
			return true
		--  and not showing dead entities
		elseif (not RSConfigDB.IsShowingDeadNpcsInReseteableZones() and not RSConfigDB.IsShowingDeadNpcs()) then
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Esta muerto.", npcID))
			return true
		end
	end

	-- Skip if an ingame vignette is already showing this entity (on Vignette)
	for _, vignetteGUID in ipairs(vignetteGUIDs) do
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID);
		if (vignetteInfo and vignetteInfo.objectGUID) then
			local _, _, _, _, _, vignetteNPCID, _ = strsplit("-", vignetteInfo.objectGUID);
			if (onWorldMap and vignetteInfo.onWorldMap and (tonumber(vignetteNPCID) == npcID or RSConstants.NPCS_WITH_PRE_EVENT[tonumber(vignetteNPCID)] == npcID)) then
				RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Hay un vignette del juego mostrándolo (Vignette onWorldmap).", npcID))
				return true
			end
			if (onMinimap and vignetteInfo.onMinimap and (tonumber(vignetteNPCID) == npcID or RSConstants.NPCS_WITH_PRE_EVENT[tonumber(vignetteNPCID)] == npcID)) then
				RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Hay un vignette del juego mostrándolo (Vignette onMinimap).", npcID))
				return true
			end
		end
	end

	return false
end

function RSNpcPOI.GetMapNotDiscoveredNpcPOIs(mapID, questTitles, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing NPC icons
	if (not RSConfigDB.IsShowingNpcs()) then
		return
	end
	
	-- Refresh custom NPCs, just in case they were added after the list of not discovered was loaded
	for npcID, _ in pairs (RSNpcDB.GetAllCustomNpcInfo()) do
		RefreshNotDiscoveredNpcs(npcID)
	end

	local POIs = {}
	for npcID, _ in pairs(notDiscoveredNpcIDs) do
		local filtered = false
		local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
		
		-- It it was a custom NPC and has being deleted it could be unsynchronized
		if (npcInfo == nil) then
			RemoveNotDiscoveredNpc(npcID)
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC N/D [%s]: Era un NPC personalizado y ya no existe.", npcID))
			filtered = true
		end

		-- Skip if it was discovered in this session
		if (not filtered and RSGeneralDB.GetAlreadyFoundEntity(npcID)) then
			RemoveNotDiscoveredNpc(npcID)
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC N/D [%s]: Ya no es 'no descubierto'.", npcID))
			filtered = true
		end

		-- Skip if the entity belong to a different mapID/artID that the one displaying
		if (not filtered and not RSNpcDB.IsInternalNpcInMap(npcID, mapID)) then
			RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC N/D [%s]: En distinta zona.", npcID))
			filtered = true
		end
		
		-- Skip if it doesnt have coordinates. This could happend if it is a custom NPC
		if (not filtered and (not npcInfo.x or not npcInfo.y)) then
			local x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
			if (not x or not y) then
				RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC N/D [%s]: No disponía de coordenadas.", npcID))
				filtered = true
			end
		end

		-- Skip if common filters
		if (not filtered and not IsNpcPOIFiltered(npcID, mapID, RSNpcDB.GetInternalNpcArtID(npcID, mapID), npcInfo.zoneQuestId, questTitles, vignetteGUIDs, onWorldMap, onMinimap)) then
			tinsert(POIs, RSNpcPOI.GetNpcPOI(npcID, mapID, npcInfo))
		end
	end

	return POIs
end

function RSNpcPOI.GetMapAlreadyFoundNpcPOI(npcID, alreadyFoundInfo, mapID, questTitles, vignetteGUIDs, onWorldMap, onMinimap)
	-- Skip if not showing NPC icons
	if (not RSConfigDB.IsShowingNpcs()) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Iconos de NPCs deshabilitado.", npcID))
		return
	end

	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	local npcDead = RSNpcDB.IsNpcKilled(npcID)

	-- Skip if the entity has been seen before the max amount of time that the player want to see the icon on the map
	-- This filter doesnt apply to dead entities or worldmap npcs
	if (not npcDead and (npcInfo and not npcInfo.worldmap) and RSConfigDB.IsMaxSeenTimeFilterEnabled() and time() - alreadyFoundInfo.foundTime > RSTimeUtils.MinutesToSeconds(RSConfigDB.GetMaxSeenTimeFilter())) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltado NPC [%s]: Visto hace demasiado tiempo.", npcID))
		return
	end

	-- Skip if the entity belongs to a different map that the one displaying
	-- First checks with the already found information
	local correctMap = false
	if (RSGeneralDB.IsAlreadyFoundEntityInZone(npcID, mapID)) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("GetMapAlreadyFoundNpcPOI. NPC [%s] en zona correcta [alreadyFound].", npcID))
		correctMap = true
	end

	-- Then checks with the internal found information just in case its a multizone
	-- Its possible that the player is opening a map where this NPC can show up, but the last time seen was in a different map
	if (not correctMap and (not npcInfo or not RSNpcDB.IsInternalNpcInMap(npcID, mapID))) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("Saltando NPC [%s]: En distinta zona.", npcID))
		return
	end

	-- Skip if common filters
	local zoneQuestID
	if (npcInfo) then
		zoneQuestID = npcInfo.zoneQuestId
	end

	if (not IsNpcPOIFiltered(npcID, mapID, alreadyFoundInfo.artID, zoneQuestID, questTitles, vignetteGUIDs, onWorldMap, onMinimap)) then
		return RSNpcPOI.GetNpcPOI(npcID, mapID, npcInfo, alreadyFoundInfo)
	end
end

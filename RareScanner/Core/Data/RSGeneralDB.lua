-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSGeneralDB = private.NewLib("RareScannerGeneralDB")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")


---============================================================================
-- Already found entities
----- Stores entities information found while playing
---============================================================================

function RSGeneralDB.InitAlreadyFoundEntitiesDB()
	if (not private.dbglobal.rares_found) then
		private.dbglobal.rares_found = {}
	end
end

function RSGeneralDB.RemoveAlreadyFoundEntity(entityID)
	if (entityID and private.dbglobal.rares_found[entityID]) then
		private.dbglobal.rares_found[entityID] = nil
	end
end

function RSGeneralDB.GetAlreadyFoundEntities()
	return private.dbglobal.rares_found
end

function RSGeneralDB.GetAlreadyFoundEntity(entityID)
	if (entityID) then
		return private.dbglobal.rares_found[entityID]
	end

	return nil
end

function RSGeneralDB.IsAlreadyFoundEntityInZone(entityID, mapID)
	if (entityID and mapID and private.dbglobal.rares_found[entityID]) then
		local entityInfo = RSGeneralDB.GetAlreadyFoundEntity(entityID)
		if (entityInfo.mapID == mapID and (not entityInfo.artID or RSUtils.Contains(entityInfo.artID, C_Map.GetMapArtID(mapID)))) then
			return true
		end
	end

	return false
end

function RSGeneralDB.AddAlreadyFoundNpcWithoutVignette(npcID)
	-- Extract position from player
	local mapID = C_Map.GetBestMapForUnit("player")
	if (mapID) then
		local mapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
		local artID = C_Map.GetMapArtID(mapID)
		if (mapPosition) then
			local x, y = mapPosition:GetXY()
			RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundNpcWithoutVignette[%s]. Usada la posicion del jugador", npcID))
			return RSGeneralDB.AddAlreadyFoundEntity(npcID, mapID, x, y, artID, RSConstants.NPC_VIGNETTE)
		end
	end

	-- If it couldnt get the position from player extract it from the internal database
	-- If its a multizone NPC we cannot know what zone the player is at
	if (RSNpcDB.IsInternalNpcMonoZone(npcID)) then
		local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
		if (npcInfo.zoneID ~= RSConstants.UNKNOWN_ZONE_ID) then
			RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundNpcWithoutVignette[%s]. Usada la informacion interna", npcID))
			return RSGeneralDB.AddAlreadyFoundEntity(npcID, npcInfo.zoneID, npcInfo.x, npcInfo.y, npcInfo.artID, RSConstants.NPC_VIGNETTE)
		end
	end

	return nil
end

function RSGeneralDB.AddAlreadyFoundContainerWithoutVignette(containerID)
	-- Extract position from player
	local mapID = C_Map.GetBestMapForUnit("player")
	if (mapID) then
		local mapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
		local artID = C_Map.GetMapArtID(mapID)
		if (mapPosition) then
			local x, y = mapPosition:GetXY()
			RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundContainerWithoutVignette[%s]. Usada la posicion del jugador", containerID))
			return RSGeneralDB.AddAlreadyFoundEntity(containerID, mapID, x, y, artID, RSConstants.CONTAINER_VIGNETTE)
		end
	end

	-- If it couldnt get the position from player extract it from the internal database
	local containerInfo = RSGeneralDB.GetInternalContainerInfo(containerID)
	if (containerInfo and containerInfo.zoneID ~= RSConstants.UNKNOWN_ZONE_ID) then
		RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundContainerWithoutVignette[%s]. Usada la informacion interna", containerID))
		return RSGeneralDB.AddAlreadyFoundEntity(containerID, containerInfo.zoneID, containerInfo.x, containerInfo.y, containerInfo.artID, RSConstants.CONTAINER_VIGNETTE)
	end

	return nil
end

function RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(entityID)
	if (entityID and private.dbglobal.rares_found[entityID]) then
		local mapID = C_Map.GetBestMapForUnit("player")
		if (mapID) then
			local mapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
			local artID = C_Map.GetMapArtID(mapID)
			if (mapPosition) then
				local x, y = mapPosition:GetXY()
				RSGeneralDB.UpdateAlreadyFoundEntity(entityID, mapID, x, y, artID)
			end
		end
	end
end

function RSGeneralDB.UpdateAlreadyFoundEntityTime(entityID)
	if (entityID and private.dbglobal.rares_found[entityID]) then
		private.dbglobal.rares_found[entityID].foundTime = time();
		RSLogger:PrintDebugMessage(string.format("UpdateAlreadyFoundEntityTime[%s]. Nueva estampa de tiempo (%s)", entityID, RSGeneralDB.GetAlreadyFoundEntity(entityID).foundTime))
	end
end

local function PrintAlreadyFoundTable(raresFound)
	if (raresFound) then
		return string.format("mapID:%s,artID:%s,x:%s,y:%s,atlasName:%s,foundTime:%s", raresFound.mapID or "", ((type(raresFound.artID) == "table" and unpack(raresFound.artID)) or raresFound.artID or ""), raresFound.coordX or "", raresFound.coordY or "", raresFound.atlasName, raresFound.foundTime)
	end

	return ""
end

function RSGeneralDB.UpdateAlreadyFoundEntity(entityID, mapID, x, y, artID, atlasName)
	if (entityID and private.dbglobal.rares_found[entityID] and mapID and x and y and artID) then
		-- If the map is the same, check if different artID
		local currentMapID = private.dbglobal.rares_found[entityID].mapID;
		local currentArtID = private.dbglobal.rares_found[entityID].artID;
		if (currentMapID == mapID and currentArtID) then
			if (type(currentArtID) == "table" and not RSUtils.Contains(currentArtID, artID)) then
				table.insert(currentArtID, artID)
				private.dbglobal.rares_found[entityID].artID = currentArtID
			elseif (type(currentArtID) ~= "table" and currentArtID ~= artID) then
				private.dbglobal.rares_found[entityID].artID = { artID };
			end
			-- Otherwise override
		else
			private.dbglobal.rares_found[entityID].artID = { artID };
		end

		private.dbglobal.rares_found[entityID].mapID = mapID
		private.dbglobal.rares_found[entityID].coordX = x;
		private.dbglobal.rares_found[entityID].coordY = y;
		private.dbglobal.rares_found[entityID].foundTime = time();
		if (atlasName) then
			private.dbglobal.rares_found[entityID].atlasName = atlasName;
		end

		RSLogger:PrintDebugMessage(string.format("UpdateAlreadyFoundEntity[%s]: %s", entityID, PrintAlreadyFoundTable(RSGeneralDB.GetAlreadyFoundEntity(entityID))))
	end
end

function RSGeneralDB.AddAlreadyFoundEntity(entityID, mapID, x, y, artID, atlasName)
	if (entityID and mapID and x and y and artID and atlasName) then
		private.dbglobal.rares_found[entityID] = {};
		private.dbglobal.rares_found[entityID].mapID = mapID;
		if (type(artID) == "table") then
			private.dbglobal.rares_found[entityID].artID = artID;
		else
			private.dbglobal.rares_found[entityID].artID = { artID };
		end
		private.dbglobal.rares_found[entityID].coordX = x;
		private.dbglobal.rares_found[entityID].coordY = y;
		private.dbglobal.rares_found[entityID].atlasName = atlasName;
		private.dbglobal.rares_found[entityID].foundTime = time();

		RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundEntity[%s]: %s", entityID, PrintAlreadyFoundTable(RSGeneralDB.GetAlreadyFoundEntity(entityID))))
		return RSGeneralDB.GetAlreadyFoundEntity(entityID)
	end

	RSLogger:PrintDebugMessage(string.format("AddAlreadyFoundEntity[%s]: No añadido! faltaban parametros!", entityID))
	return nil
end


---============================================================================
-- Not discovored entities
----- Stores entities not found. This lists are used to display non discovered
----- entities in the map in a faster way
---============================================================================

function RSGeneralDB.InitNotDiscoveredListsDB()

end

---============================================================================
-- Loot info cache database
----- Stores information of items to avoid requesting the server too often
---============================================================================

function RSGeneralDB.InitItemInfoDB()
	if (not private.dbglobal.loot_info) then
		private.dbglobal.loot_info = {}
	end
end

function RSGeneralDB.GetItemName(itemID)
	if (not itemID) then
		return
	end

	-- The first time request the server for the information
	local retOk, itemName, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _ = pcall(GetItemInfo, itemID)
	return itemName
end

function RSGeneralDB.GetItemInfo(itemID)
	if (not itemID) then
		return
	end

	-- The first time request the server for the information
	if (not private.dbglobal.loot_info[itemID]) then
		local retOk, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = pcall(GetItemInfo, itemID)
		if (itemLink and itemRarity and itemEquipLoc and iconFileDataID and itemClassID and itemSubClassID) then
			RSGeneralDB.SetItemInfo(itemID, itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID)
			return unpack(private.dbglobal.loot_info[itemID])
		end
		return itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID
			-- Next time return cache
	else
		return unpack(private.dbglobal.loot_info[itemID])
	end
end

function RSGeneralDB.SetItemInfo(itemID, itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID)
	if (itemID) then
		private.dbglobal.loot_info[itemID] = { itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID }
	end
end

---============================================================================
-- Completed quests cache database
----- Stores information of completed quests
---============================================================================

function RSGeneralDB.InitCompletedQuestDB()
	if (not private.dbchar.quests_completed) then
		private.dbchar.quests_completed = {}
	end
end

function RSGeneralDB.IsCompletedQuestInCache(questID)
	return questID and private.dbchar.quests_completed[questID]
end

function RSGeneralDB.SetCompletedQuest(questID)
	if (questID) then
		private.dbchar.quests_completed[questID] = true
	end
end

---============================================================================
-- Recently seen entities database
---============================================================================

function RSGeneralDB.InitRecentlySeenDB()
	private.dbglobal.recentlySeen = {}
end

function RSGeneralDB.DeleteRecentlySeen(npcID)
	if (npcID and private.dbglobal.recentlySeen[npcID]) then
		private.dbglobal.recentlySeen[npcID] = nil
		RSLogger:PrintDebugMessage(string.format("DeleteRecentlySeen[%s]", npcID))
	end
end

function RSGeneralDB.SetRecentlySeen(npcID)
	if (npcID) then
		private.dbglobal.recentlySeen[npcID] = true
		RSLogger:PrintDebugMessage(string.format("SetRecentlySeen[%s]", npcID))

		C_Timer.After(RSConstants.RECENTLY_SEEN_ENTITIES_RESET_TIMER, function()
			RSGeneralDB.DeleteRecentlySeen(npcID)
		end)
	end
end

function RSGeneralDB.IsRecentlySeen(npcID)
	if (npcID and private.dbglobal.recentlySeen[npcID]) then
		return true
	end

	return false
end

---============================================================================
-- Overlay database
---============================================================================

function RSGeneralDB.HasOverlayActive(npcID)
	return private.dbchar.overlayActive and private.dbchar.overlayActive == npcID
end

function RSGeneralDB.SetOverlayActive(npcID)
	private.dbchar.overlayActive = npcID
end

function RSGeneralDB.GetOverlayActive()
	return private.dbchar.overlayActive
end

function RSGeneralDB.RemoveOverlayActive()
	private.dbchar.overlayActive = nil
end

---============================================================================
-- Guide database
---============================================================================

function RSGeneralDB.HasGuideActive(entityID)
	return private.dbchar.guideActive and private.dbchar.guideActive == entityID
end

function RSGeneralDB.SetGuideActive(entityID)
	private.dbchar.guideActive = entityID
end

function RSGeneralDB.GetGuideActive()
	return private.dbchar.guideActive
end

function RSGeneralDB.RemoveGuideActive()
	private.dbchar.guideActive = nil
end

---============================================================================
-- Help database
---============================================================================

function RSGeneralDB.GetHelpActive()
	return private.dbchar.helpActive
end

function RSGeneralDB.RemoveHelpActive()
	private.dbchar.helpActive = nil
end

---============================================================================
-- Button position
---============================================================================

function RSGeneralDB.SetButtonPositionCoordinates(x, y)
	if (x and y) then
		private.db.scannerXPos = x
		private.db.scannerYPos = y
	end
end

function RSGeneralDB.GetButtonPositionCoordinates()
	-- Previous settings based on character database
	if (private.dbchar.scannerXPos and private.dbchar.scannerYPos) then
		if (not private.db.scannerXPos or not private.db.scannerYPos) then
			RSGeneralDB.SetButtonPositionCoordinates(private.dbchar.scannerXPos, private.dbchar.scannerYPos)
		end
		private.dbchar.scannerXPos = nil
		private.dbchar.scannerYPos = nil
	end
	
	-- Current settings based on profiles database
	if (private.db.scannerXPos and private.db.scannerYPos) then
		return private.db.scannerXPos, private.db.scannerYPos
	end

	return nil
end

---============================================================================
-- Version control database
---============================================================================

function RSGeneralDB.InitDbVersionDB()
	if (not private.dbglobal.dbversion) then
		private.dbglobal.dbversion = {}
	end
end

function RSGeneralDB.GetAllDbVersions()
	return private.dbglobal.dbversion
end

function RSGeneralDB.GetDbVersion()
	for _, dbversion in ipairs(RSGeneralDB.GetAllDbVersions()) do
		if (dbversion.locale == GetLocale()) then
			return dbversion
		end
	end

	return nil
end

function RSGeneralDB.AddDbVersion(newVersion)
	if (newVersion and private.dbglobal.dbversion) then
		local localeExisting = false;
		for i = #private.dbglobal.dbversion, 1, -1 do
			if (not localeExisting and private.dbglobal.dbversion[i].locale == GetLocale()) then
				localeExisting = true
				private.dbglobal.dbversion[i].version = newVersion
				private.dbglobal.dbversion[i].sync = nil
				RSLogger:PrintDebugMessage(string.format("Idioma [%s]. Actualizando BD a version [%s]", GetLocale(), newVersion))
			elseif (localeExisting and private.dbglobal.dbversion[i].locale == GetLocale()) then
				-- Fix issue with versions multiplicating
				tremove(private.dbglobal.dbversion, i)
				RSLogger:PrintDebugMessage(string.format("Idioma [%s]. Eliminado por estar repetido", GetLocale()))
			end
		end
		if (not localeExisting) then
			tinsert(private.dbglobal.dbversion, { locale = GetLocale(), version = newVersion })
			RSLogger:PrintDebugMessage(string.format("Idioma [%s]. Insertado version [%s] por primera vez para este idioma.", GetLocale(), newVersion))
		end
	end
end

function RSGeneralDB.GetLootDbVersion()
	return private.dbglobal.lootdbversion
end

function RSGeneralDB.SetLootDbVersion(version)
	private.dbglobal.lootdbversion = version
end

---============================================================================
-- Search plugin integration
---============================================================================

function RSGeneralDB.ClearWorldMapTextFilter()
	private.dbchar.worldMapTextFilter = nil
end

function RSGeneralDB.GetWorldMapTextFilter()
	return private.dbchar.worldMapTextFilter
end

function RSGeneralDB.SetWorldMapTextFilter(text)
	if (text == '') then
		RSGeneralDB.ClearWorldMapTextFilter()
	else
		private.dbchar.worldMapTextFilter = text
	end
end

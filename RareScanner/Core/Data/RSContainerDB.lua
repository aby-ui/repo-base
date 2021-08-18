-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...
local LibStub = _G.LibStub

local RSContainerDB = private.NewLib("RareScannerContainerDB")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSConstants = private.ImportLib("RareScannerConstants")


---============================================================================
-- Opened containers database
---============================================================================

function RSContainerDB.InitContainerOpenedDB()
	if (not private.dbchar.containers_opened) then
		private.dbchar.containers_opened = {}
	end
end

function RSContainerDB.GetAllContainersOpenedRespawnTimes()
	return private.dbchar.containers_opened
end

function RSContainerDB.IsContainerOpened(containerID)
	if (containerID and private.dbchar.containers_opened[containerID]) then
		return true;
	end

	return false
end

function RSContainerDB.GetContainerOpenedRespawnTime(containerID)
	if (RSContainerDB.IsContainerOpened(containerID)) then
		return private.dbchar.containers_opened[containerID]
	end

	return 0
end

function RSContainerDB.SetContainerOpened(containerID, respawnTime)
	if (containerID) then
		if (not respawnTime) then
			private.dbchar.containers_opened[containerID] = RSConstants.ETERNAL_OPENED
		else
			private.dbchar.containers_opened[containerID] = respawnTime
		end
	end
end

function RSContainerDB.DeleteContainerOpened(containerID)
	if (containerID) then
		private.dbchar.containers_opened[containerID] = nil
	end
end

---============================================================================
-- Container internal database
----- Stores containers information included with the addon
---============================================================================

function RSContainerDB.GetAllInternalContainerInfo()
	return private.CONTAINER_INFO
end

function RSContainerDB.GetInternalContainerInfo(containerID)
	if (containerID) then
		return private.CONTAINER_INFO[containerID]
	end

	return nil
end



local function GetInternalContainerInfoByMapID(containerID, mapID)
	if (containerID and mapID) then
		if (RSContainerDB.IsInternalContainerMultiZone(containerID)) then
			for internalMapID, containerInfo in pairs (RSContainerDB.GetInternalContainerInfo(containerID).zoneID) do
				if (internalMapID == mapID) then
					return containerInfo
				end
			end
		elseif (RSContainerDB.IsInternalContainerMonoZone(containerID)) then
			local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
			return containerInfo
		end
	end

	return nil
end

function RSContainerDB.GetInternalContainerArtID(containerID, mapID)
	if (containerID and mapID) then
		local containerInfo = GetInternalContainerInfoByMapID(containerID, mapID)
		if (containerInfo) then
			return containerInfo.artID
		end
	end

	return nil
end

function RSContainerDB.GetInternalContainerCoordinates(containerID, mapID)
	if (containerID and mapID) then
		local containerInfo = GetInternalContainerInfoByMapID(containerID, mapID)
		if (containerInfo) then
			return containerInfo.x, containerInfo.y
		end
	end

	return nil
end

function RSContainerDB.GetInternalContainerOverlay(containerID, mapID)
	if (containerID and mapID) then
		local containerInfo = GetInternalContainerInfoByMapID(containerID, mapID)
		if (containerInfo) then
			return containerInfo.overlay
		end
	end

	return nil
end

function RSContainerDB.IsInternalContainerMultiZone(containerID)
	local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
	return containerInfo and type(containerInfo.zoneID) == "table"
end

function RSContainerDB.IsInternalContainerMonoZone(containerID)
	local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
	return containerInfo and type(containerInfo.zoneID) ~= "table"
end

function RSContainerDB.IsInternalContainerInMap(containerID, mapID)
	if (containerID and mapID) then
		if (RSContainerDB.IsInternalContainerMultiZone(containerID)) then
			for internalMapID, internalContainerInfo in pairs(RSContainerDB.GetInternalContainerInfo(containerID).zoneID) do
				if (internalMapID == mapID and (not internalContainerInfo.artID or RSUtils.Contains(internalContainerInfo.artID, C_Map.GetMapArtID(mapID)))) then
					return true;
				end
			end
		elseif (RSContainerDB.IsInternalContainerMonoZone(containerID)) then
			local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
			if (containerInfo.zoneID == mapID and (not containerInfo.artID or RSUtils.Contains(containerInfo.artID, C_Map.GetMapArtID(mapID)))) then
				return true;
			end
		end
	end

	return false;
end

function RSContainerDB.IsWorldMap(containerID)
	if (containerID) then
		local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
		return containerInfo and containerInfo.worldmap
	end
end

---============================================================================
-- Container Loot internal database
----- Stores Container loot included with the addon
---============================================================================

function RSContainerDB.GetContainerLoot(containerID)
	if (containerID) then
		return RSUtils.JoinTables(RSContainerDB.GetInteralContainerLoot(containerID), RSContainerDB.GetContainerLootFound(containerID))
	end

	return nil
end

function RSContainerDB.GetAllInteralContainerLoot()
	return private.CONTAINER_LOOT
end

function RSContainerDB.GetInteralContainerLoot(containerID)
	if (containerID) then
		return RSContainerDB.GetAllInteralContainerLoot()[containerID]
	end

	return nil
end

---============================================================================
-- Container Loot database
----- Stores Container loot found while playing
---============================================================================

function RSContainerDB.InitContainerLootFoundDB()
	if (not private.dbglobal.containers_loot) then
		private.dbglobal.containers_loot = {}
	end
end

function RSContainerDB.GetAllContainersLootFound()
	return private.dbglobal.containers_loot
end

function RSContainerDB.GetContainerLootFound(containerID)
	if (containerID and private.dbglobal.containers_loot[containerID]) then
		return private.dbglobal.containers_loot[containerID]
	end

	return nil
end

function RSContainerDB.SetContainerLootFound(containerID, loot)
	if (containerID and loot) then
		private.dbglobal.containers_loot[containerID] = loot
	end
end

function RSContainerDB.AddItemToContainerLootFound(containerID, itemID)
	if (containerID and itemID) then
		if (not private.dbglobal.containers_loot[containerID]) then
			private.dbglobal.containers_loot[containerID] = {}
		end

		-- If its in the internal database ignore it
		local internalLoot = RSContainerDB.GetInteralContainerLoot(containerID)
		if (internalLoot and RSUtils.Contains(internalLoot, itemID)) then
			return
		end

		-- If its not in the loot found DB adds it
		if (not RSUtils.Contains(private.dbglobal.containers_loot[containerID], itemID)) then
			tinsert(private.dbglobal.containers_loot[containerID], itemID)
			RSLogger:PrintDebugMessage(string.format("AddItemToContainerLootFound[%s]: Añadido nuevo loot [%s]", containerID, itemID))
		end
	end
end

function RSContainerDB.RemoveContainerLootFound(containerID)
	if (containerID) then
		private.dbglobal.containers_loot[containerID] = nil
	end
end

---============================================================================
-- Container quest IDs database
----- Stores Containers hidden quest IDs
---============================================================================

function RSContainerDB.InitContainerQuestIdFoundDB()
	if (not private.dbglobal.container_quest_ids) then
		private.dbglobal.container_quest_ids = {}
	end
end

function RSContainerDB.GetAllContainerQuestIdsFound()
	return private.dbglobal.container_quest_ids
end

function RSContainerDB.SetContainerQuestIdFound(containerID, questID)
	if (containerID and questID) then
		private.dbglobal.container_quest_ids[containerID] = { questID }
		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Calculado questID [%s]", containerID, questID))
	end
end

function RSContainerDB.GetContainerQuestIdFound(containerID)
	if (containerID and private.dbglobal.container_quest_ids[containerID]) then
		return private.dbglobal.container_quest_ids[containerID]
	end

	return nil
end

function RSContainerDB.RemoveContainerQuestIdFound(containerID)
	if (containerID) then
		private.dbglobal.container_quest_ids[containerID] = nil
	end
end

---============================================================================
-- Containers names database
----- Stores names of containers included with the addon
---============================================================================

function RSContainerDB.InitContainerNamesDB()
	if (not private.dbglobal.object_names) then
		private.dbglobal.object_names = {}
	end

	if (not private.dbglobal.object_names[GetLocale()]) then
		private.dbglobal.object_names[GetLocale()] = {}
	end
end

function RSContainerDB.GetAllContainerNames()
	return private.dbglobal.object_names[GetLocale()]
end

function RSContainerDB.SetContainerName(containerID, name)
	if (containerID and name) then
		private.dbglobal.object_names[GetLocale()][containerID] = name
	end
end

function RSContainerDB.GetContainerName(containerID)
	if (containerID) then
		if (RSUtils.Contains(RSConstants.RELIC_CACHE, containerID)) then
			private.dbglobal.object_names[GetLocale()][containerID] = AL["RELIC_CACHE"]
			return AL["RELIC_CACHE"]
		elseif (RSUtils.Contains(RSConstants.PILE_BONES, containerID)) then
			private.dbglobal.object_names[GetLocale()][containerID] = AL["PILE_BONES"]
			return AL["PILE_BONES"]
		elseif (RSUtils.Contains(RSConstants.SHARDHIDE_STASH, containerID)) then
			private.dbglobal.object_names[GetLocale()][containerID] = AL["SHARDHIDE_STASH"]
			return AL["SHARDHIDE_STASH"]
		elseif (RSUtils.Contains(RSConstants.STOLEN_ANIMA_VESSEL, containerID) or RSUtils.Contains(RSConstants.STOLEN_ANIMA_VESSEL_RIFT, containerID)) then
			private.dbglobal.object_names[GetLocale()][containerID] = AL["STOLEN_ANIMA_VESSEL"]
			return AL["STOLEN_ANIMA_VESSEL"]
		elseif (private.dbglobal.object_names[GetLocale()][containerID]) then
			return private.dbglobal.object_names[GetLocale()][containerID]
		end
	end

	return nil
end

---============================================================================
-- Reseteable containers database
---- Stores containers that in theory cannot be opened again, but that they are
---- detected again
---============================================================================

function RSContainerDB.InitReseteableContainersDB()
	if (not private.dbglobal.containers_reseteable) then
		private.dbglobal.containers_reseteable = {}
	end
end

function RSContainerDB.IsContainerReseteable(containerID)
	return containerID and private.dbglobal.containers_reseteable[containerID]
end

function RSContainerDB.SetContainerReseteable(containerID)
	if (containerID) then
		private.dbglobal.containers_reseteable[containerID] = true
	end
end

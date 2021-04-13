-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSNpcDB = private.NewLib("RareScannerNpcDB")

-- RareScanner database libraries
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTooltipScanners = private.ImportLib("RareScannerTooltipScanners")

---============================================================================
-- Killed NPCs database
---============================================================================

function RSNpcDB.InitNpcKilledDB()
	if (not private.dbchar.rares_killed) then
		private.dbchar.rares_killed = {}
	end
end

function RSNpcDB.IsNpcKilled(npcID)
	if (npcID and private.dbchar.rares_killed[npcID]) then
		return true;
	end

	return false
end

function RSNpcDB.GetAllNpcsKilledRespawnTimes()
	return private.dbchar.rares_killed
end

function RSNpcDB.GetNpcKilledRespawnTime(npcID)
	if (RSNpcDB.IsNpcKilled(npcID)) then
		return private.dbchar.rares_killed[npcID]
	end

	return 0
end

function RSNpcDB.SetNpcKilled(npcID, respawnTime)
	if (npcID) then
		if (not respawnTime) then
			private.dbchar.rares_killed[npcID] = RSConstants.ETERNAL_DEATH
		else
			private.dbchar.rares_killed[npcID] = respawnTime
		end
	end
end

function RSNpcDB.DeleteNpcKilled(npcID)
	if (npcID) then
		private.dbchar.rares_killed[npcID] = nil
	end
end

---============================================================================
-- Custom NPC database
----- Stores custom NPCs information
---============================================================================

function RSNpcDB.InitCustomNpcDB()
	if (not private.dbglobal.custom_npcs) then
		private.dbglobal.custom_npcs = {}
	end
end

function RSNpcDB.GetAllCustomNpcInfo()
	return private.dbglobal.custom_npcs
end

function RSNpcDB.GetCustomNpcInfo(npcID)
	if (npcID) then
		return private.dbglobal.custom_npcs[npcID]
	end

	return nil
end

function RSNpcDB.SetCustomNpcInfo(npcID, info)
	if (not npcID or not info or not info.zones or next(info.zones) == nil) then
		RSLogger:PrintDebugMessage(string.format("SetCustomNpcInfo[%s]: Ignorado por no tener todos los datos rellenos", npcID))
		return
	end
	
	local zones = {}
	local completedZonesCounter = 0
	for zoneID, _ in pairs (info.zones) do
		if (info.coordinates and info.coordinates[zoneID] and info.coordinates[zoneID] ~= "") then
			string.format("Coordenadas %s", info.coordinates[zoneID]);
			local mapID = tonumber(zoneID)
			zones[mapID] = {}
			zones[mapID].artID = { C_Map.GetMapArtID(mapID) }
			zones[mapID].overlay = {}
			
			local coordinatePairs = { strsplit(",", info.coordinates[zoneID]) }
			for i, coordinatePair in ipairs(coordinatePairs) do
				local coordx, coordy = 	strsplit("-", coordinatePair)
				if (i == 1) then
					zones[mapID].x = tonumber("0."..coordx)
					zones[mapID].y = tonumber("0."..coordy)
				end
					
				table.insert(zones[mapID].overlay, string.format("0.%s-0.%s", coordx, coordy))
			end
			
			completedZonesCounter = completedZonesCounter + 1
		elseif (zoneID == RSConstants.ALL_ZONES_CUSTOM_NPC) then
			local mapID = tonumber(zoneID)
			zones[mapID] = {}			
			completedZonesCounter = completedZonesCounter + 1
		end
	end
	
	if (completedZonesCounter == 0) then
		RSLogger:PrintDebugMessage(string.format("SetCustomNpcInfo[%s]: Ignorado por no tener coordenadas en ninguna de sus zonas", npcID))
		return
	end
	
	local npcIDnumber = tonumber(npcID)
	private.dbglobal.custom_npcs[npcIDnumber] = {}
	private.dbglobal.custom_npcs[npcIDnumber].displayID = tonumber(info.displayID or "0")
	private.dbglobal.custom_npcs[npcIDnumber].reset = true
	private.dbglobal.custom_npcs[npcIDnumber].nameplate = true
	
	-- If it spawns in several zones
	if (completedZonesCounter > 1) then
		private.dbglobal.custom_npcs[npcIDnumber].zoneID = zones
		
		for mapID, zoneInfo in pairs (zones) do
			RSLogger:PrintDebugMessage(string.format("SetCustomNpcInfo[%s]: %s", npcIDnumber, string.format("zoneID:%s,artID:%s,x:%s,y:%s,displayID:%s", mapID or "", ((type(zoneInfo.artID) == "table" and unpack(zoneInfo.artID)) or zoneInfo.artID or "") or "", zoneInfo.x or "", zoneInfo.y or "", private.dbglobal.custom_npcs[npcIDnumber].displayID or "")))
		end
	-- If it spawns in one zone
	else
		for mapID, zoneInfo in pairs (zones) do
			private.dbglobal.custom_npcs[npcIDnumber].zoneID = mapID
			private.dbglobal.custom_npcs[npcIDnumber].artID = zoneInfo.artID
			private.dbglobal.custom_npcs[npcIDnumber].x = zoneInfo.x
			private.dbglobal.custom_npcs[npcIDnumber].y = zoneInfo.y
			private.dbglobal.custom_npcs[npcIDnumber].overlay = zoneInfo.overlay
		end
		
		RSLogger:PrintDebugMessage(string.format("SetCustomNpcInfo[%s]: %s", npcIDnumber, string.format("zoneID:%s,artID:%s,x:%s,y:%s,displayID:%s", private.dbglobal.custom_npcs[npcIDnumber].zoneID or "", ((type(private.dbglobal.custom_npcs[npcIDnumber].artID) == "table" and unpack(private.dbglobal.custom_npcs[npcIDnumber].artID)) or private.dbglobal.custom_npcs[npcIDnumber].artID or "") or "", private.dbglobal.custom_npcs[npcIDnumber].x or "", private.dbglobal.custom_npcs[npcIDnumber].y or "", private.dbglobal.custom_npcs[npcIDnumber].displayID or "")))
	end
	
	-- Merge internal database with custom
	private.NPC_INFO[npcIDnumber] = private.dbglobal.custom_npcs[npcIDnumber]
	
	-- Just in case is tagged as dead for whatever reason
	RSNpcDB.DeleteNpcKilled(npcIDnumber)
end

function RSNpcDB.DeleteCustomNpcInfo(npcID)
	if (not npcID) then
		return
	end
	
	private.dbglobal.custom_npcs[tonumber(npcID)] = nil
	private.NPC_INFO[tonumber(npcID)] = nil
	
	RSNpcDB.DeleteCustomNpcLoot(npcID)
end

function RSNpcDB.DeleteCustomNpcZone(npcID, zoneID)
	if (not npcID or not zoneID) then
		return false
	end
	
	local npcIDnumber = tonumber(npcID)
	local mapID = tonumber(zoneID)
	
	if (not private.dbglobal.custom_npcs[npcIDnumber]) then
		return false
	else
		-- If it has multiple zones
		if (type(private.dbglobal.custom_npcs[npcIDnumber].zoneID) == "table") then
			private.dbglobal.custom_npcs[npcIDnumber].zoneID[mapID] = nil
			
			-- If after removing it only contains one zone, transform to unimap
			if (RSUtils.GetTableLength(private.dbglobal.custom_npcs[npcIDnumber].zoneID) == 1) then
				for lastMapID, zoneInfo in pairs (private.dbglobal.custom_npcs[npcIDnumber].zoneID) do
					private.dbglobal.custom_npcs[npcIDnumber].zoneID = lastMapID
					private.dbglobal.custom_npcs[npcIDnumber].artID = zoneInfo.artID
					private.dbglobal.custom_npcs[npcIDnumber].x = zoneInfo.x
					private.dbglobal.custom_npcs[npcIDnumber].y = zoneInfo.y
					private.dbglobal.custom_npcs[npcIDnumber].overlay = zoneInfo.overlay
					
					-- Merge internal database with custom
					private.NPC_INFO[npcIDnumber] = private.dbglobal.custom_npcs[npcIDnumber]
					
					RSLogger:PrintDebugMessage(string.format("RSNpcDB.DeleteCustomNpcZone[%s]: Eliminada zona %s", npcIDnumber, mapID))
					return false
				end
			end
		-- If it has only one zone then remove it from the NPC custom database
		else
			RSNpcDB.DeleteCustomNpcInfo(npcID)
			RSLogger:PrintDebugMessage(string.format("RSNpcDB.DeleteCustomNpcZone[%s]: Eliminado NPC por no contener mas zonas", npcIDnumber))
			return true
		end
	end
end

---============================================================================
-- NPC internal database (included with the addon and custom NPCs)
----- Stores NPCs information included with the addon and custom NPCs
---============================================================================

local internalNpcsMerged = false
function RSNpcDB.GetAllInternalNpcInfo()
	-- Merge internal database with custom
	if (not internalNpcsMerged) then
		for npcID, customNpcID in pairs(RSNpcDB.GetAllCustomNpcInfo()) do
			private.NPC_INFO[npcID] = customNpcID
		end
		internalNpcsMerged = true
		RSLogger:PrintDebugMessage("GetAllInternalNpcInfo: Mezclada la tabla de NPCs internos con la de personalizados.")
	end
	
	return private.NPC_INFO
end

function RSNpcDB.GetInternalNpcInfo(npcID)
	if (npcID) then
		return private.NPC_INFO[npcID]
	end

	return nil
end

local function GetInternalNpcInfoByMapID(npcID, mapID)
	if (npcID and mapID) then
		if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
			for internalMapID, npcInfo in pairs (RSNpcDB.GetInternalNpcInfo(npcID).zoneID) do
				if (internalMapID == mapID) then
					return npcInfo
				end
			end
		elseif (RSNpcDB.IsInternalNpcMonoZone(npcID)) then
			local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
			return npcInfo
		end
	end

	return nil
end

function RSNpcDB.GetInternalNpcArtID(npcID, mapID)
	if (npcID and mapID) then
		local npcInfo = GetInternalNpcInfoByMapID(npcID, mapID)
		if (npcInfo) then
			return npcInfo.artID
		end
	end

	return nil
end

function RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
	if (npcID and mapID) then
		local npcInfo = GetInternalNpcInfoByMapID(npcID, mapID)
		if (npcInfo) then
			return npcInfo.x, npcInfo.y
		end
	end

	return nil
end

function RSNpcDB.GetInternalNpcOverlay(npcID, mapID)
	if (npcID and mapID) then
		local npcInfo = GetInternalNpcInfoByMapID(npcID, mapID)
		if (npcInfo) then
			return npcInfo.overlay
		end
	end

	return nil
end

function RSNpcDB.IsInternalNpcMultiZone(npcID)
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	return npcInfo and type(npcInfo.zoneID) == "table"
end

function RSNpcDB.IsInternalNpcMonoZone(npcID)
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	return npcInfo and type(npcInfo.zoneID) ~= "table"
end

function RSNpcDB.IsInternalNpcInMap(npcID, mapID, checkSubzones)
	if (npcID and mapID) then
		if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
			for internalMapID, internalNpcInfo in pairs(RSNpcDB.GetInternalNpcInfo(npcID).zoneID) do
				if (internalMapID == mapID and (not internalNpcInfo.artID or RSUtils.Contains(internalNpcInfo.artID, C_Map.GetMapArtID(mapID)))) then
					return true;
				elseif (checkSubzones and RSMapDB.IsMapInParentMap(mapID, internalMapID)) then
					return true;
				end
			end
		elseif (RSNpcDB.IsInternalNpcMonoZone(npcID)) then
			local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
			if (npcInfo.zoneID == mapID and (not npcInfo.artID or RSUtils.Contains(npcInfo.artID, C_Map.GetMapArtID(mapID)))) then
				return true;
			elseif (checkSubzones and RSMapDB.IsMapInParentMap(mapID, npcInfo.zoneID)) then
				return true;
			end
		end
	end

	return false;
end

function RSNpcDB.IsInternalNpcFriendly(npcID)
	if (npcID and RSNpcDB.GetInternalNpcInfo(npcID)) then
		local faction, _ = UnitFactionGroup("player")
		if (RSUtils.Contains(RSNpcDB.GetInternalNpcInfo(npcID).friendly, string.sub(faction, 1, 1))) then
			return true
		end
	end

	return false
end

function RSNpcDB.IsWorldMap(npcID)
	if (npcID) then
		local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
		return npcInfo and npcInfo.worldmap
	end
end

---============================================================================
-- NPC Loot internal database
----- Stores NPC loot included with the addon
---============================================================================

function RSNpcDB.GetAllInteralNpcLoot()
	return private.NPC_LOOT
end

function RSNpcDB.GetInteralNpcLoot(npcID)
	if (npcID) then
		return RSNpcDB.GetAllInteralNpcLoot()[npcID]
	end

	return nil
end

function RSNpcDB.GetNpcLoot(npcID)
	if (npcID) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("NPC [%s]: Obeniendo su loot.", npcID))
		return RSUtils.JoinTables(RSUtils.JoinTables(RSNpcDB.GetInteralNpcLoot(npcID), RSNpcDB.GetNpcLootFound(npcID)), RSNpcDB.GetCustomNpcLoot(npcID))
	end

	return nil
end

---============================================================================
-- Custom NPC loot database
----- Stores custom NPC loot
---============================================================================

function RSNpcDB.GetCustomNpcLoot(npcID)
	if (npcID and private.dbglobal.custom_loot) then
		return private.dbglobal.custom_loot[npcID]
	end

	return nil
end

function RSNpcDB.SetCustomNpcLoot(npcID, loot)
	if (not private.dbglobal.custom_loot) then
		private.dbglobal.custom_loot = {}
	end
	
	private.dbglobal.custom_loot[tonumber(npcID)] = loot
	RSLogger:PrintDebugMessage(string.format("RSNpcDB.SetCustomNpcLoot[%s]: Añadido loot", npcID))
end

function RSNpcDB.DeleteCustomNpcLoot(npcID)
	if (npcID and private.dbglobal.custom_loot) then
		private.dbglobal.custom_loot[tonumber(npcID)] = nil
		RSLogger:PrintDebugMessage(string.format("RSNpcDB.DeleteCustomNpcLoot[%s]: Eliminado loot", npcID))
	end
end

---============================================================================
-- NPC Loot database
----- Stores NPC loot found while playing
---============================================================================

function RSNpcDB.InitNpcLootFoundDB()
	if (not private.dbglobal.rares_loot) then
		private.dbglobal.rares_loot = {}
	end
end

function RSNpcDB.GetAllNpcsLootFound()
	return private.dbglobal.rares_loot
end

function RSNpcDB.GetNpcLootFound(npcID)
	if (npcID and private.dbglobal.rares_loot[containerID]) then
		return private.dbglobal.rares_loot[npcID]
	end

	return nil
end

function RSNpcDB.SetNpcLootFound(npcID, loot)
	if (npcID and loot) then
		private.dbglobal.rares_loot[npcID] = loot
	end
end

function RSNpcDB.AddItemToNpcLootFound(npcID, itemID)
	if (npcID and itemID) then
		if (not private.dbglobal.rares_loot[npcID]) then
			private.dbglobal.rares_loot[npcID] = {}
		end

		-- If its in the internal database ignore it
		local internalLoot = RSNpcDB.GetInteralNpcLoot(npcID)
		if (internalLoot and RSUtils.Contains(internalLoot, itemID)) then
			return
		end

		-- If its not in the loot found DB adds it
		if (not RSUtils.Contains(private.dbglobal.rares_loot[npcID], itemID)) then
			tinsert(private.dbglobal.rares_loot[npcID], itemID)
			RSLogger:PrintDebugMessage(string.format("AddItemToNpcLootFound[%s]: Añadido nuevo loot [%s]", npcID, itemID))
		end
	end
end

function RSNpcDB.RemoveNpcLootFound(npcID)
	if (npcID) then
		private.dbglobal.rares_loot[npcID] = nil
	end
end

---============================================================================
-- NPC quest IDs database
----- Stores NPC hidden quest IDs
---============================================================================

function RSNpcDB.InitNpcQuestIdFoundDB()
	if (not private.dbglobal.npc_quest_ids) then
		private.dbglobal.npc_quest_ids = {}
	end
end

function RSNpcDB.GetAllNpcQuestIdsFound()
	return private.dbglobal.npc_quest_ids
end

function RSNpcDB.SetNpcQuestIdFound(npcID, questID)
	if (npcID and questID) then
		private.dbglobal.npc_quest_ids[npcID] = { questID }
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Calculado questID [%s]", npcID, questID))
	end
end

function RSNpcDB.GetNpcQuestIdFound(npcID)
	if (npcID and private.dbglobal.npc_quest_ids[npcID]) then
		return private.dbglobal.npc_quest_ids[npcID]
	end

	return nil
end

function RSNpcDB.RemoveNpcQuestIdFound(npcID)
	if (npcID) then
		private.dbglobal.npc_quest_ids[npcID] = nil
	end
end

---============================================================================
-- NPC names database
----- Stores names of NPCs included with the addon
---============================================================================

function RSNpcDB.InitNpcNamesDB()
	if (not private.dbglobal.rare_names) then
		private.dbglobal.rare_names = {}
	end

	if (not private.dbglobal.rare_names[GetLocale()]) then
		private.dbglobal.rare_names[GetLocale()] = {}
	end
end

function RSNpcDB.GetAllNpcNames()
	return private.dbglobal.rare_names[GetLocale()]
end

function RSNpcDB.SetNpcName(npcID, name)
	if (npcID and name) then
		private.dbglobal.rare_names[GetLocale()][npcID] = name
	end
end

function RSNpcDB.GetNpcName(npcID)
	if (npcID) then
		if (private.dbglobal.rare_names[GetLocale()][npcID]) then
			return private.dbglobal.rare_names[GetLocale()][npcID]
		else
			RSTooltipScanners.ScanNpcName(npcID)
		end
	end

	return nil
end

function RSNpcDB.GetNpcId(name, mapID)
	for npcID, npcName in pairs(RSNpcDB.GetAllNpcNames()) do
		if (RSUtils.Contains(npcName, name) and RSNpcDB.IsInternalNpcInMap(npcID, mapID, true)) then
			return npcID;
		end
	end
end

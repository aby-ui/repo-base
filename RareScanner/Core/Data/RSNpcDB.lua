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
-- NPC internal database
----- Stores NPCs information included with the addon
---============================================================================

function RSNpcDB.GetAllInternalNpcInfo()
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

---============================================================================
-- NPC Loot internal database
----- Stores NPC loot included with the addon
---============================================================================

function RSNpcDB.GetInteralNpcLoot(npcID)
	if (npcID) then
		return private.NPC_LOOT[npcID]
	end
	
	return nil
end

function RSNpcDB.GetNpcLoot(npcID)
	if (npcID) then
		RSLogger:PrintDebugMessageEntityID(npcID, string.format("NPC [%s]: Obeniendo su loot.", npcID))
		return RSUtils.JoinTables(RSNpcDB.GetInteralNpcLoot(npcID), RSNpcDB.GetNpcLootFound(npcID))
	end
	
	return nil
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
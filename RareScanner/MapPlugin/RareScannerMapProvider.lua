-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Constants
local ETERNAL_DEATH = -1
local ETERNAL_COLLECTED = -1

RareScannerDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function RareScannerDataProviderMixin:OnAdded(mapCanvas)
	MapCanvasDataProviderMixin.OnAdded(self, mapCanvas);
	self:InitializeAllTrackingTables();
end

function RareScannerDataProviderMixin:OnShow()

end
 
function RareScannerDataProviderMixin:OnHide()
	self:RemoveAllData()
end
 
function RareScannerDataProviderMixin:OnEvent(event, ...)

end
 
function RareScannerDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate("RSRarePinTemplate");
	self:InitializeAllTrackingTables();
end
 
function RareScannerDataProviderMixin:InitializeAllTrackingTables()
	self.rareNpcToPins = {};
end

local function AddNotDiscoveredIcons(mixin, entities, mapID, atlasName)
	if (private.db.map.displayNotDiscoveredMapIcons and entities[mapID]) then
		-- Skip if old expansion
		if (not private.db.map.displayOldNotDiscoveredMapIcons) then
			for continentID, continent in pairs (private.CONTINENT_ZONE_IDS) do
				-- check if the current continent contents the mapID
				local zoneFound = RS_tContains(continent.zones, mapID)
				
				-- check subzones
				if (not zoneFound) then
					for i, zoneID in ipairs (continent.zones) do
						if (private.SUBZONES_IDS[zoneID] and RS_tContains(private.SUBZONES_IDS[zoneID], mapID)) then
							zoneFound = true
							break
						end
					end
				end
				
				if (zoneFound) then
					if (not continent.current or (not RS_tContains(continent.current, "all") and not RS_tContains(continent.current, mapID))) then
						return
					end
				end
			end
		end
		for npcID, coords in pairs (entities[mapID]) do
			-- Delete already found, opened without vignette or ignored
			if (private.dbglobal.rares_found[npcID] or (private.dbchar.rares_not_discovered_ignored and private.dbchar.rares_not_discovered_ignored[npcID]) or private.dbchar.containers_opened[npcID] or private.dbchar.rares_killed[npcID]) then
				entities[mapID][npcID] = nil
			else
				local npcInfo = {}
				npcInfo.coordX = coords.x
				npcInfo.coordY = coords.y
				npcInfo.mapID = mapID
				npcInfo.atlasName = atlasName
				npcInfo.notDiscovered = true
				mixin:AddPin(npcID, npcInfo, mapID);
			end
		end
	end
end
 
function RareScannerDataProviderMixin:RefreshAllData(fromOnShow)
	self:RemoveAllData()

	if (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) then
		return
	end
	
	local mapID = self:GetMap():GetMapID();
	RareScanner:PrintDebugMessage("DEBUG: MAPID actual "..mapID.." ARTID actual "..C_Map.GetMapArtID(mapID))

	-- don't show if map filtered
	if (private.db.general.filteredZones[mapID] ~= false) then
		-- Extract world quest in the area
		local quests = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
		self.questTitles = {}
		if (quests) then
			for i, quest in ipairs (quests) do
				if (HaveQuestData(quest.questId)) then
					local title, _, _ = C_TaskQuest.GetQuestInfoByQuestID(quest.questId)
					table.insert(self.questTitles, title)
				end
			end
		end
		
		-- Show new pins
		if (private.dbglobal.rares_found) then
			for npcID, npcInfo in pairs (private.dbglobal.rares_found) do
				if (npcInfo.atlasName ~= RareScanner.NPC_LEGION_VIGNETTE) then
					if (private.db.map.displayNpcIcons and npcInfo.atlasName == RareScanner.NPC_VIGNETTE) then
						self:AddPin(npcID, npcInfo, mapID);
					elseif (private.db.map.displayContainerIcons and npcInfo.atlasName == RareScanner.CONTAINER_VIGNETTE) then
						self:AddPin(npcID, npcInfo, mapID);
					elseif (private.db.map.displayEventIcons and npcInfo.atlasName == RareScanner.EVENT_VIGNETTE) then
						self:AddPin(npcID, npcInfo, mapID);
					end
				end
			end
		end
		
		-- Show pins in our database not discovered by the player
		if (private.db.map.displayNpcIcons) then
			AddNotDiscoveredIcons(self, private.RARES_NOT_DISCOVERED, mapID, RareScanner.NPC_VIGNETTE)
		end

		if (private.db.map.displayContainerIcons) then
			AddNotDiscoveredIcons(self, private.CONTAINERS_NOT_DISCOVERED, mapID, RareScanner.CONTAINER_VIGNETTE)
		end
		
		if (private.db.map.displayEventIcons) then
			AddNotDiscoveredIcons(self, private.EVENTS_NOT_DISCOVERED, mapID, RareScanner.EVENT_VIGNETTE)
		end
	end
end
 
function RareScannerDataProviderMixin:OnMapChanged()
	self:RefreshAllData();
end
 
function RareScannerDataProviderMixin:AddPin(npcID, npcInfo, mapID)
	local npcInfoBak = nil
	
	-- If its an npc that can show up in more than one place, we adjust its data so it displays in other available places
	if (npcInfo.mapID ~= mapID and private.ZONE_IDS[npcID] and type(private.ZONE_IDS[npcID].zoneID) == "table") then
		for zoneID, zoneInfo in pairs (private.ZONE_IDS[npcID].zoneID) do
			if (zoneID == mapID) then
				npcInfoBak = {}
				npcInfoBak.coordX  = private.dbglobal.rares_found[npcID].coordX
				npcInfoBak.coordY  = private.dbglobal.rares_found[npcID].coordY
				npcInfoBak.mapID  = private.dbglobal.rares_found[npcID].mapID
				npcInfoBak.artID  = private.dbglobal.rares_found[npcID].artID
				npcInfo.mapID = mapID
				npcInfo.coordX = zoneInfo.x
				npcInfo.coordY = zoneInfo.y
				npcInfo.artID = C_Map.GetMapArtID(mapID)
				break;
			end
		end
	end

	-- if belongs to another map
	if (npcInfo.mapID ~= mapID) then
		--RareScanner:PrintDebugMessage("DEBUG: Ignorado por pertenecer a otro mapa")
		return false
	end
	
	-- If the map is being filtered
	if (private.db.general.filteredZones and private.db.general.filteredZones[mapID] == false) then
		--RareScanner:PrintDebugMessage("DEBUG: Ignorado por pertenecer a una zona filtrada")
		return false
	end
	
	-- If the map is in a different phase
	if ((npcInfo.artID and npcInfo.artID ~= C_Map.GetMapArtID(mapID)) or (private.ZONE_IDS[npcID] and private.ZONE_IDS[npcID].artID and private.ZONE_IDS[npcID].artID ~= C_Map.GetMapArtID(mapID))) then
		--RareScanner:PrintDebugMessage("DEBUG: Ignorado por pertenecer a una fase del mapa distinta a la actual")
		return false
	end

	---If its an NPC
	if (npcInfo.atlasName == RareScanner.NPC_VIGNETTE or npcInfo.atlasName == RareScanner.NPC_LEGION_VIGNETTE) then
		-- If the NPC doesnt exist delete it
		local npcName = RareScanner:GetNpcName(npcID)
		if (not npcName) then
			private.dbglobal.rares_found[npcID] = nil
			--RareScanner:PrintDebugMessage("DEBUG: Eliminado de la tabla de rares_found el NPC con ID "..npcID.." dado que no existe en nuestra base de datos")
			return false
		end
		
		-- If world quest ignore it
		if (RS_tContains(self.questTitles, npcName)) then
			--RareScanner:PrintDebugMessage("DEBUG: Ignorado por ser una misión del mundo")
			return false
		end
		
		-- If killed ignore it
		local keepShowingAfterDead = false
		if (private.dbchar.rares_killed[npcID]) then
			if (not private.db.map.keepShowingAfterDead and not private.db.map.keepShowingAfterDeadReseteable) then
				return false
			elseif (private.db.map.keepShowingAfterDead) then
				--RareScanner:PrintDebugMessage("DEBUG: Mostrandose por keepShowingAfterDead")
				keepShowingAfterDead = true
			elseif (private.db.map.keepShowingAfterDeadReseteable and private.RESETABLE_KILLS_ZONE_IDS[npcInfo.mapID] and (RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[npcInfo.mapID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[npcInfo.mapID],npcInfo.artID))) then
				--RareScanner:PrintDebugMessage("DEBUG: Mostrandose por keepShowingAfterDeadReseteable")
				keepShowingAfterDead = true
			else
				return false
			end
		end
		
		-- If filtered we dont show either
		if (next(private.db.general.filteredRares) ~= nil and private.db.general.filteredRares[npcID] == false) then
			--RareScanner:PrintDebugMessage("DEBUG: Ignorado porque este NPC esta siendo filtrado")
			return false
		end

		-- If its been seen after our max show time
		-- Ignore if its killed and we want to keep showing its icon
		if (not npcInfo.notDiscovered and not keepShowingAfterDead and private.db.map.maxSeenTime ~= 0 and time() - npcInfo.foundTime > private.db.map.maxSeenTime * 3600) then
			return false
		end
	-- If its a container
	elseif (npcInfo.atlasName == RareScanner.CONTAINER_VIGNETTE or npcInfo.atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE) then
		-- if its a garrison cache and its disabled
		if (not private.db.general.scanGarrison) then
			-- check if the container is the garrison cache
			if (RS_tContains(RareScanner.GARRISON_CACHE_IDS, npcID)) then
				return
			end
		end
		
		-- If opened ignore it
		local keepShowingAfterCollected = false
		if (private.dbchar.containers_opened[npcID] and not private.db.map.keepShowingAfterCollected) then
			--RareScanner:PrintDebugMessage("DEBUG: Ignorado por estar abierto")
			return false
		elseif (private.dbchar.containers_opened[npcID] and private.db.map.keepShowingAfterCollected) then
			keepShowingAfterCollected = true
		end
		
		-- If its been seen after our max show time
		-- Ignore if its opened and we want to keep showing its icon
		if (not npcInfo.notDiscovered and not keepShowingAfterCollected and private.db.map.maxSeenTimeContainer ~= 0 and time() - npcInfo.foundTime > private.db.map.maxSeenTimeContainer * 60) then
			-- If its an achievement icon it doesn't make sence to hide it because timing
			if (private.ACHIEVEMENT_ZONE_IDS[mapID]) then
				local hasAchievement = false
				for i, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
					if (RS_tContains(private.ACHIEVEMENT_TARGET_IDS[achievementID], npcID)) then
						hasAchievement = true
						break
					end
				end
				
				if (not hasAchievement) then
					--RareScanner:PrintDebugMessage("DEBUG: Ignorado contenedor por haberle visto hace mas tiempo del configurado")
					return false
				end
			else
				--RareScanner:PrintDebugMessage("DEBUG: Ignorado contenedor por haberle visto hace mas tiempo del configurado")
				return false
			end
		end
	-- If its an event
	elseif (npcInfo.atlasName == RareScanner.EVENT_VIGNETTE) then
		-- If compelted ignore it
		if (private.dbchar.events_completed[npcID]) then
			--RareScanner:PrintDebugMessage("DEBUG: Ignorado por estar completado")
			return false
		end
	end
	
	-- If coordinates not properly calculated ignore it
	if (not npcInfo or not npcInfo.coordX or not npcInfo.coordY or not npcInfo.mapID or not tonumber(npcInfo.coordY) or not tonumber(npcInfo.coordX) or not (tonumber(npcInfo.coordY) < 1 and tonumber(npcInfo.coordY) > 0) or not (tonumber(npcInfo.coordX) < 1 and tonumber(npcInfo.coordX) > 0)) then
		-- and delete it
		private.dbglobal.rares_found[npcID] = nil
		--RareScanner:PrintDebugMessage("DEBUG: Eliminado de la tabla de rares_found el NPC con ID "..npcID.." dado que alguna de sus coordenadas se ha grabado incorrectamente ")
		return false
	end
	
	-- If last time seen wrong, fix it
	if (not npcInfo.notDiscovered and (not npcInfo.foundTime or (time() - npcInfo.foundTime <= 0))) then
		private.dbglobal.rares_found[npcID].foundTime = time()
		--RareScanner:PrintDebugMessage("DEBUG: La hora de ultimo avistamiento estaba corrupta, arreglado!")
	end

	local pin = self:GetMap():AcquirePin("RSRarePinTemplate", npcID, npcInfo);
	self.rareNpcToPins[npcID] = pin;
	
	-- Avoids overriding the recorded value
	if (npcInfoBak) then
		private.dbglobal.rares_found[npcID].coordX = npcInfoBak.coordX
		private.dbglobal.rares_found[npcID].coordY = npcInfoBak.coordY
		private.dbglobal.rares_found[npcID].mapID = npcInfoBak.mapID
		private.dbglobal.rares_found[npcID].artID = npcInfoBak.artID
		npcInfoBak = nil
	end
	
	return true
end
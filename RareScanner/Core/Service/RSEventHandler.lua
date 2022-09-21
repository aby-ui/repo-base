-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner
local ADDON_NAME, private = ...

-- Range checker
local rc = LibStub("LibRangeCheck-2.0")

local RSEventHandler = private.NewLib("RareScannerEventHandler")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSCollectionsDB = private.ImportLib("RareScannerCollectionsDB")

-- RareScanner services
local RSMinimap = private.ImportLib("RareScannerMinimap")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")


---============================================================================
-- Handle entities without vignette
---============================================================================

local function HandleEntityWithoutVignette(rareScannerButton, unitID)
	if (not unitID) then
		return
	end
	
	local unitGuid = UnitGUID(unitID)
	if (not unitGuid) then
		return
	end
	
	local unitType, _, _, _, _, entityID = strsplit("-", unitGuid)
	if (unitType == "Creature") then
		local npcID = entityID and tonumber(entityID) or nil
	
		-- If player in a zone with vignettes ignore it
		local mapID = C_Map.GetBestMapForUnit("player")
		if (not mapID) then
			return
		end
	
		if (mapID and not RSMapDB.IsZoneWithoutVignette(mapID)) then
			-- Continue if its an NPC that doesnt have vignette in a newer zone
			if (not RSNpcDB.GetInternalNpcInfo(npcID) or not RSNpcDB.GetInternalNpcInfo(npcID).nameplate) then
				return
			end
		end
	
		-- If its a supported NPC and its not killed
		if ((RSGeneralDB.GetAlreadyFoundEntity(npcID) or RSNpcDB.GetInternalNpcInfo(npcID)) and not RSNpcDB.IsNpcKilled(npcID)) then			
			local nameplateUnitName, _ = UnitName(unitID)
			local x, y
			
			-- It uses the player position in first instance
			local playerMapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
			if (playerMapPosition) then
				x, y = playerMapPosition:GetXY()
			end
	
			-- Otherwise uses the internal coordinates
			-- In dungeons and such its not possible to get the player position
			if (not x or not y) then
				x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
			end
	
			rareScannerButton:SimulateRareFound(npcID, unitGuid, nameplateUnitName, x, y, RSConstants.NPC_VIGNETTE)
	
			-- And then try to find better coordinates while the player approaches
			local minRange, maxRange = rc:GetRange(unitID)
			if (playerMapPosition and (minRange or maxRange)) then
				C_Timer.NewTicker(RSConstants.FIND_BETTER_COORDINATES_WITH_RANGE_TIMER, function()
					local minRange, maxRange = rc:GetRange(unitID)
					if (minRange and minRange < 10) then
						RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(npcID)
						RSMinimap.RefreshEntityState(npcID)
					end
				end, 15)
			end
		end
	end
end

---============================================================================
-- Event: PLAYER_LOGIN
-- Fired when the player logs in the game
---============================================================================

local function OnPlayerLogin(rareScannerButton)
	local x, y = RSGeneralDB.GetButtonPositionCoordinates()
	if (x and y) then
		rareScannerButton:ClearAllPoints()
		rareScannerButton:SetPoint("BOTTOMLEFT", x, y)
	end
end

---============================================================================
-- Event: VIGNETTE_MINIMAP_UPDATED
-- Fired when a vignette appears in the minimap
---============================================================================

local function OnVignetteMinimapUpdated(rareScannerButton, vignetteID)
	-- Get viggnette data
	local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteID)
	if (not vignetteInfo) then
		return
	else
		vignetteInfo.id = vignetteID
		rareScannerButton:DetectedNewVignette(rareScannerButton, vignetteInfo)
	end
end

---============================================================================
-- Event: VIGNETTES_UPDATED
-- Fired when a vignette appears in the worldmap
---============================================================================

local function OnVignettesUpdated(rareScannerButton)
	if (not RSConfigDB.IsScanningWorldMapVignettes()) then
		return
	end

	local vignetteGUIDs = C_VignetteInfo.GetVignettes();
	for _, vignetteGUID in ipairs(vignetteGUIDs) do
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID);
		if (vignetteInfo and vignetteInfo.onWorldMap) then
			vignetteInfo.id = vignetteGUID
			rareScannerButton:DetectedNewVignette(rareScannerButton, vignetteInfo)
		elseif (vignetteInfo and vignetteInfo.onMinimap and vignetteInfo.objectGUID) then
			local _, _, _, _, _, vignetteEntityID, _ = strsplit("-", vignetteInfo.objectGUID);
			RSMinimap.HideIcon(vignetteEntityID)
		end
	end
end

---============================================================================
-- Event: NAME_PLATE_UNIT_ADDED
-- Fired when a nameplate appears
---============================================================================

local function OnNamePlateUnitAdded(rareScannerButton, namePlateID)
	if (namePlateID and not UnitIsUnit("player", namePlateID)) then
		HandleEntityWithoutVignette(rareScannerButton, namePlateID)
	end
end

---============================================================================
-- Event: UPDATE_MOUSEOVER_UNIT
-- Fired when mouseovering a unit
---============================================================================

local function OnUpdateMouseoverUnit(rareScannerButton)
	if (not UnitIsUnit("player", "mouseover")) then
		HandleEntityWithoutVignette(rareScannerButton, "mouseover")
	end
end

---============================================================================
-- Event: PLAYER_REGEN_ENABLED
-- Fired when the player leaves combat
---============================================================================

local function OnPlayerRegenEnabled(rareScannerButton)
	if (rareScannerButton.pendingToShow) then
		rareScannerButton.pendingToShow = nil
		rareScannerButton.pendingToHide = nil -- just in case it was pending too
		rareScannerButton:ShowButton()
	elseif (rareScannerButton.pendingToHide) then
		rareScannerButton.pendingToHide = nil
		rareScannerButton:HideButton()
	end
end

---============================================================================
-- Event: COMBAT_LOG_EVENT_UNFILTERED
-- Fired with every event on the target
---============================================================================

local function OnCombatLogEventUnfiltered()
	local _, eventType, _, _, _, _, _, destGUID, _, _, _ = CombatLogGetCurrentEventInfo()
	if (eventType == "PARTY_KILL") then
		local _, _, _, _, _, id = strsplit("-", destGUID)
		local npcID = id and tonumber(id) or nil
		RareScanner:ProcessKill(npcID)
	elseif (eventType == "UNIT_DIED") then
		local _, _, _, _, _, id = strsplit("-", destGUID)
		local npcID = id and tonumber(id) or nil

		-- Set it as dead if the target is already found and doesn't have the silver dragon anymore
		if (RSGeneralDB.GetAlreadyFoundEntity(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
			if (UnitExists("target") and destGUID == UnitGUID("target")) then
				local unitClassification = UnitClassification("target")
				if (unitClassification ~= "rare" and unitClassification ~= "rareelite") then
					RareScanner:ProcessKill(npcID)
				end
			end
		end
	end
end

---============================================================================
-- Event: PLAYER_TARGET_CHANGED
-- Fired when changing the target
---============================================================================

local function OnPlayerTargetChanged()
	if (UnitExists("target")) then
		local targetUid = UnitGUID("target")
		local npcType, _, _, _, _, id = strsplit("-", targetUid)

		-- Ignore rare hunter pets
		if (npcType == "Pet") then
			return
		end

		local unitClassification = UnitClassification("target")
		local npcID = id and tonumber(id) or nil
		local playerMapID = C_Map.GetBestMapForUnit("player")

		-- Check if we have the NPC in our database but the addon didnt detect it
		-- This will happend in the case where the NPC is a rare, but it doesnt have a vignette
		if (not RSGeneralDB.GetAlreadyFoundEntity(npcID) and RSNpcDB.GetInternalNpcInfo(npcID)) then
			RSGeneralDB.AddAlreadyFoundNpcWithoutVignette(npcID)
		end

		-- check if killed
		if (RSGeneralDB.GetAlreadyFoundEntity(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
			-- Update coordinates (if zone doesnt use vignettes)
			if (RSMapDB.IsZoneWithoutVignette(playerMapID)) then
				RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(npcID)
			end

			if (unitClassification ~= "rare" and unitClassification ~= "rareelite") then
				-- In WOD some of the NPCs don't have the silver dragon but they are still rare NPCs
				-- Check the questID asociated to see if its dead
				local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
				if (npcInfo and npcInfo.questID) then
					local completed = false
					for i, questID in ipairs (npcInfo.questID) do
						if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
							completed = true
							break
						end
					end

					if (completed) then
						RSLogger:PrintDebugMessage(string.format("Encontrado NPC [%s] sin dragon plateado que se ha detectado como muerto gracias a su mision completada.", npcID))
						RareScanner:ProcessKill(npcID)
					else
						RSLogger:PrintDebugMessage(string.format("Encontrado NPC [%s] sin dragon plateado que sigue siendo rare NPC (por no haber completado su mision asociada).", npcID))
						RSGeneralDB.UpdateAlreadyFoundEntityTime(npcID)
					end
				else
					RareScanner:ProcessKill(npcID)
				end
			else
				RSGeneralDB.UpdateAlreadyFoundEntityTime(npcID)
			end
		end
	end	
end

---============================================================================
-- Event: LOOT_OPENED
-- Fired when looting some entity
---============================================================================

local function OnLootOpened()
	local numItems = GetNumLootItems()
	if (not numItems or numItems <= 0) then
		return
	end

	local containerLooted = false
	for i = 1, numItems do
		if (LootSlotHasItem(i)) then
			local destGUID = GetLootSourceInfo(i)
			local unitType, _, _, _, _, id = strsplit("-", destGUID)

			-- If the loot comes from a container that we support
			if (unitType == "GameObject") then
				local containerID = id and tonumber(id) or nil

				-- We support all the containers with vignette plus those ones that are part of achievements (without vignette)
				if (RSGeneralDB.GetAlreadyFoundEntity(containerID) or RSContainerDB.GetInternalContainerInfo(containerID)) then
					-- Sets the container as opened
					-- We are looping through all the items looted, we dont want to call this method with every item
					if (not containerLooted) then
						RSLogger:PrintDebugMessage(string.format("Abierto [%s].", containerID or ""))
				
						-- Check if we have the Container in our database but the addon didnt detect it
						-- This will happend in the case where the container doesnt have a vignette
						if (not RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
							RSGeneralDB.AddAlreadyFoundContainerWithoutVignette(containerID)
						else
							RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(containerID)
						end
					
						RareScanner:ProcessOpenContainer(containerID)
						containerLooted = true
					end

					-- Records the loot obtained
					local itemLink = GetLootSlotLink(i)
					if (itemLink) then
						local _, _, _, lootType, id, _, _, _, _, _, _, _, _, _, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
						if (lootType == "item") then
							local itemID = id and tonumber(id) or nil
							RSContainerDB.AddItemToContainerLootFound(containerID, itemID)
						end
					end
				end
			-- If the loot comes from a creature that we support
			elseif (unitType == "Creature") then
				local npcID = id and tonumber(id) or nil
				
				-- If its a supported NPC
				if (RSGeneralDB.GetAlreadyFoundEntity(npcID)) then
					local itemLink = GetLootSlotLink(i)
					if (itemLink) then
						local _, _, _, lootType, id, _, _, _, _, _, _, _, _, _, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
						if (lootType == "item") then
							local itemID = id and tonumber(id) or nil
							RSNpcDB.AddItemToNpcLootFound(npcID, itemID)
						end
					end
				end
			end
		end
	end
end

---============================================================================
-- Event: CHAT_MSG_MONSTER_YELL
-- Fired when a monster yells (red message on chat)
---============================================================================

local function OnChatMsgMonsterYell(rareScannerButton, message, name)
	-- If not disabled
	if (not RSConfigDB.IsScanningChatAlerts()) then
		return
	end

	if (name) then
		RSLogger:PrintDebugMessage(string.format("CHAT_MSG_MONSTER_YELL name: [%s]", name))
		
		local mapID = C_Map.GetBestMapForUnit("player")
		if (not mapID) then
			return
		end
		RSLogger:PrintDebugMessage(string.format("CHAT_MSG_MONSTER_YELL mapID: [%s]", mapID))
		
		local npcID = RSNpcDB.GetNpcId(name, mapID)
		if (not npcID) then
			return
		end
		RSLogger:PrintDebugMessage(string.format("CHAT_MSG_MONSTER_YELL npcID: [%s]", npcID))
		
		-- Enabled in Mechagon and Tanaan Jungle for every NPC
		if (mapID == RSConstants.MECHAGON_MAPID or mapID == RSConstants.TANAAN_JUNGLE_MAPID) then
			-- Arachnoid Harvester fix
			if (npcID == 154342) then
				npcID = 151934
			end

			-- The Scrap King fix
			if ((npcID == 151623 or npcID == 151625) and (RSNpcDB.IsNpcKilled(151623) or RSNpcDB.IsNpcKilled(151625))) then
				return
			end

			-- Simulates vignette event
			if (RSNpcDB.GetInternalNpcInfo(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
				local x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
				rareScannerButton:SimulateRareFound(npcID, nil, name, x, y, RSConstants.NPC_VIGNETTE)
			end
		-- If not in Mechagon check only for NPCs without vignette and scanneable with nameplates
		elseif (RSNpcDB.GetInternalNpcInfo(npcID) and RSNpcDB.GetInternalNpcInfo(npcID).nameplate and not RSNpcDB.IsNpcKilled(npcID)) then
			local x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
			rareScannerButton:SimulateRareFound(npcID, nil, name, x, y, RSConstants.NPC_VIGNETTE)
		end
	end
end

---============================================================================
-- Event: CHAT_MSG_MONSTER_EMOTE
-- Fired when a monster emotes (brown message on chat)
---============================================================================

local function OnChatMsgMonsterEmote(rareScannerButton, message, name)
	-- If not disabled
	if (not RSConfigDB.IsScanningChatAlerts()) then
		return
	end

	-- Check for Mechagon Construction Projects
	local mapID = C_Map.GetBestMapForUnit("player")
	if (mapID and mapID == RSConstants.MECHAGON_MAPID) then
		for constructionProject, npcID in pairs(private.CONSTRUCTION_PROJECTS) do
			if (RSUtils.Contains(message, constructionProject)) then
				-- Simulates vignette event
				if (RSNpcDB.GetInternalNpcInfo(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
					local x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
					rareScannerButton:SimulateRareFound(npcID, nil, RSNpcDB.GetNpcName(npcID), x, y, RSConstants.NPC_VIGNETTE)
				end

				return
			end
		end
	end
end

---============================================================================
-- Event: QUEST_TURNED_IN
-- Fired when a quest is turned in
---============================================================================

local function OnQuestTurnedIn(rareScannerButton, questID, xpReward, moneyReward)
	RSLogger:PrintDebugMessage(string.format("Misión [%s]. Completada.", questID))
	RSGeneralDB.SetCompletedQuest(questID)

	-- Checks if its an event
	local foundDebug = false
	for eventID, eventInfo in pairs (private.EVENT_INFO) do
		if (eventInfo.questID and RSUtils.Contains(eventInfo.questID, questID)) then
			RareScanner:ProcessCompletedEvent(eventID)
			foundDebug = true
			return
		end
	end

	if (RSConstants.DEBUG_MODE and not foundDebug) then
		RSLogger:PrintDebugMessage("DEBUG: Mision completada que no existe en EVENT_QUEST_IDS "..questID)
	end
end

---============================================================================
-- Event: CINEMATIC_START
-- Fired when a cinematic starts
---============================================================================

local isCinematicPlaying = false
local function OnCinematicStart(rareScannerButton)
	isCinematicPlaying = true
	if (rareScannerButton:IsVisible()) then
		rareScannerButton:HideButton()
	end
end

---============================================================================
-- Event: CINEMATIC_STOP
-- Fired when a cinematic stops
---============================================================================

local function OnCinematicStop(rareScannerButton)
	isCinematicPlaying = false
end

function RSEventHandler.IsCinematicPlaying()
	return isCinematicPlaying
end

---============================================================================
-- Event: NEW_MOUNT_ADDED
-- Fired when a new mount is added to the collection
---============================================================================

local function OnNewMountAdded(mountID)
	RSCollectionsDB.RemoveNotCollectedMount(mountID, function()
		RSExplorerFrame:Refresh()
	end)
end

---============================================================================
-- Event: NEW_PET_ADDED
-- Fired when a new pet is added to the collection
---============================================================================

local function OnNewPetAdded(petGUID)
	RSCollectionsDB.RemoveNotCollectedPet(petGUID, function()
		RSExplorerFrame:Refresh()
	end)
end

---============================================================================
-- Event: NEW_TOY_ADDED
-- Fired when a new toy is added to the collection
---============================================================================

local function OnNewToyAdded(itemID)
	RSCollectionsDB.RemoveNotCollectedToy(itemID, function()
		RSExplorerFrame:Refresh()
	end)
end

---============================================================================
-- Event: TRANSMOG_COLLECTION_UPDATED
-- Fired when a new appearance is added to the collection
---============================================================================

local function OnTransmogCollectionUpdated()
	local latestAppearanceID, _ = C_TransmogCollection.GetLatestAppearance();
	RSCollectionsDB.RemoveNotCollectedAppearance(latestAppearanceID, function()
		RSExplorerFrame:Refresh()
	end)
end

---============================================================================
-- Event handler
---============================================================================

local function HandleEvent(rareScannerButton, event, ...) 
	if (event == "PLAYER_LOGIN") then
		OnPlayerLogin(rareScannerButton)
	elseif (event == "VIGNETTE_MINIMAP_UPDATED") then
		OnVignetteMinimapUpdated(rareScannerButton, ...)
	elseif (event == "VIGNETTES_UPDATED") then
		OnVignettesUpdated(rareScannerButton)
	elseif (event == "NAME_PLATE_UNIT_ADDED") then
		OnNamePlateUnitAdded(rareScannerButton, ...)
	elseif (event == "UPDATE_MOUSEOVER_UNIT") then
		OnUpdateMouseoverUnit(rareScannerButton)
	elseif (event == "PLAYER_REGEN_ENABLED") then
		OnPlayerRegenEnabled(rareScannerButton)
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		OnCombatLogEventUnfiltered()
	elseif (event == "PLAYER_TARGET_CHANGED") then
		OnPlayerTargetChanged()
	elseif (event == "LOOT_OPENED") then
		OnLootOpened()
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
		OnChatMsgMonsterYell(rareScannerButton, ...)
	elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
		OnChatMsgMonsterEmote(rareScannerButton, ...)
	elseif (event == "QUEST_TURNED_IN") then
		OnQuestTurnedIn(rareScannerButton, ...)
	elseif (event == "CINEMATIC_START") then
		OnCinematicStart(rareScannerButton)
	elseif (event == "CINEMATIC_STOP") then
		OnCinematicStop()
	elseif (event == "NEW_MOUNT_ADDED") then
		OnNewMountAdded(...)
	elseif (event == "NEW_PET_ADDED") then
		OnNewPetAdded(...)
	elseif (event == "NEW_TOY_ADDED") then
		OnNewToyAdded(...)
	elseif (event == "TRANSMOG_COLLECTION_UPDATED") then
		OnTransmogCollectionUpdated()
	end
end

function RSEventHandler.RegisterEvents(rareScannerButton, addon)
	RareScanner = addon
	rareScannerButton:RegisterEvent("PLAYER_LOGIN")
	rareScannerButton:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	rareScannerButton:RegisterEvent("VIGNETTES_UPDATED")
	rareScannerButton:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	rareScannerButton:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	rareScannerButton:RegisterEvent("PLAYER_REGEN_ENABLED")
	rareScannerButton:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	rareScannerButton:RegisterEvent("PLAYER_TARGET_CHANGED")
	rareScannerButton:RegisterEvent("LOOT_OPENED")
	rareScannerButton:RegisterEvent("CINEMATIC_START")
	rareScannerButton:RegisterEvent("CINEMATIC_STOP")
	rareScannerButton:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	rareScannerButton:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	rareScannerButton:RegisterEvent("QUEST_TURNED_IN")
	rareScannerButton:RegisterEvent("NEW_MOUNT_ADDED")
	rareScannerButton:RegisterEvent("NEW_PET_ADDED")
	rareScannerButton:RegisterEvent("NEW_TOY_ADDED")
	rareScannerButton:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")

	-- Captures all events
	rareScannerButton:SetScript("OnEvent", function(self, event, ...)
		HandleEvent(self, event, ...) 
	end)
end
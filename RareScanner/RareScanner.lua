-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):NewAddon("RareScanner")

local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Range checker
local rc = LibStub("LibRangeCheck-2.0")

-- LibAbout frames
local LibAboutPanel = LibStub:GetLibrary("LibAboutPanel", true)

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSQuestTracker = private.ImportLib("RareScannerQuestTracker")

-- RareScanner services
local RSRespawnTracker = private.ImportLib("RareScannerRespawnTracker")
local RSMap = private.ImportLib("RareScannerMap")
local RSWorldMapHooks = private.ImportLib("RareScannerWorldMapHooks")
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSWaypoints = private.ImportLib("RareScannerWaypoints")

-- RareScanner other addons integration services
local RSTomtom = private.ImportLib("RareScannerTomtom")

-- Main button
local scanner_button = CreateFrame("Button", "scanner_button", UIParent, BackdropTemplateMixin and "BackdropTemplate,SecureActionButtonTemplate")
scanner_button:Hide();
scanner_button:SetIgnoreParentScale(true)
scanner_button:SetFrameStrata("MEDIUM")
scanner_button:SetFrameLevel(200)
scanner_button:SetSize(200, 50)
scanner_button:SetScale(0.8)
scanner_button:SetAttribute("type", "macro")
scanner_button:SetNormalTexture([[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal-Desaturated]])
scanner_button:SetBackdrop({ tile = true, edgeSize = 16, edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]] })
scanner_button:SetBackdropBorderColor(0, 0, 0)
scanner_button:SetPoint("BOTTOM", UIParent, 0, 128)
scanner_button:SetMovable(true)
scanner_button:SetUserPlaced(true)
scanner_button:SetClampedToScreen(true)
scanner_button:RegisterForDrag("LeftButton")

scanner_button:SetScript("OnDragStart", function(self)
	if (not RSConfigDB.IsLockingPosition()) then
		self:StartMoving()
	end
end)
scanner_button:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	RSGeneralDB.SetButtonPositionCoordinates(self:GetLeft(), self:GetBottom())
end)
scanner_button:SetScript("OnEnter", function(self)
	self:SetBackdropBorderColor(0.9, 0.9, 0.9)
end)
scanner_button:SetScript("OnLeave", function(self)
	self:SetBackdropBorderColor(0, 0, 0)
end)
scanner_button:SetScript("OnHide", function(self)
	self.npcID = nil
	self.name = nil
	self.NextButton:Reset()
	self.PreviousButton:Reset()
end)

-- Model view
scanner_button.ModelView = CreateFrame("PlayerModel", "mxpplayermodel", scanner_button)
scanner_button.ModelView:ClearAllPoints()
scanner_button.ModelView:SetPoint("TOP", 0 , 122) -- bottom left corner 2px separation from scanner_button's top left corner
scanner_button.ModelView:SetSize(120, 120)
scanner_button.ModelView:SetScale(1.25)

local Background = scanner_button:GetNormalTexture()
Background:SetDrawLayer("BACKGROUND")
Background:ClearAllPoints()
Background:SetPoint("BOTTOMLEFT", 3, 3)
Background:SetPoint("TOPRIGHT", -3, -3)
Background:SetTexCoord(0, 1, 0, 0.25)

-- Title
local TitleBackground = scanner_button:CreateTexture(nil, "BORDER")
TitleBackground:SetTexture([[Interface\AchievementFrame\UI-Achievement-RecentHeader]])
TitleBackground:SetPoint("TOPRIGHT", -5, -7)
TitleBackground:SetPoint("LEFT", 5, 0)
TitleBackground:SetSize(180, 10)
TitleBackground:SetTexCoord(0, 1, 0, 1)
TitleBackground:SetAlpha(0.8)

scanner_button.Title = scanner_button:CreateFontString(nil, "OVERLAY", "GameFontNormal", 1)
scanner_button.Title:SetNonSpaceWrap(true)
scanner_button.Title:SetPoint("TOPLEFT", TitleBackground, 0, 0)
scanner_button.Title:SetPoint("RIGHT", TitleBackground)
scanner_button.Title:SetTextColor(1, 1, 1, 1)
scanner_button:SetFontString(scanner_button.Title)

local Description = scanner_button:CreateFontString(nil, "OVERLAY", "SystemFont_Tiny")
Description:SetPoint("BOTTOMLEFT", TitleBackground, 0, -12)
Description:SetPoint("RIGHT", -8, 0)
Description:SetTextHeight(6)
Description:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

scanner_button.Description_text = scanner_button:CreateFontString(nil, "OVERLAY", "GameFontWhiteTiny")
scanner_button.Description_text:SetPoint("TOPLEFT", Description, "BOTTOMLEFT", 0, -4)
scanner_button.Description_text:SetPoint("RIGHT", Description)

-- Close button
scanner_button.CloseButton = CreateFrame("Button", "CloseButton", scanner_button, "UIPanelCloseButton")
scanner_button.CloseButton:SetPoint("BOTTOMRIGHT")
scanner_button.CloseButton:SetSize(32, 32)
scanner_button.CloseButton:SetScale(0.8)
scanner_button.CloseButton:SetHitRectInsets(8, 8, 8, 8)

-- Filter disabled button
scanner_button.FilterDisabledButton = CreateFrame("Button", "FilterDisabledButton", scanner_button, "GameMenuButtonTemplate")
scanner_button.FilterDisabledButton:SetPoint("BOTTOMLEFT", 5, 5)
scanner_button.FilterDisabledButton:SetSize(16, 16)
scanner_button.FilterDisabledButton:SetNormalTexture([[Interface\WorldMap\Dash_64]])
scanner_button.FilterDisabledButton:SetScript("OnClick", function(self)
	local npcID = self:GetParent().npcID
	if (npcID) then
		RSConfigDB.SetNpcFiltered(npcID, false)
		RSLogger:PrintMessage(AL["DISABLED_SEARCHING_RARE"]..self:GetParent().Title:GetText())
		self:Hide()
		self:GetParent().FilterEnabledButton:Show()
	end
end)
scanner_button.FilterDisabledButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(AL["DISABLE_SEARCHING_RARE_TOOLTIP"])
	GameTooltip:Show()
end)

scanner_button.FilterDisabledButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

-- Filter enabled button
scanner_button.FilterEnabledButton = CreateFrame("Button", "FilterEnabledButton", scanner_button, "GameMenuButtonTemplate")
scanner_button.FilterEnabledButton:SetPoint("BOTTOMLEFT", 5, 5)
scanner_button.FilterEnabledButton:SetSize(16, 16)
scanner_button.FilterEnabledButton:SetScript("OnClick", function(self)
	local npcID = self:GetParent().npcID
	if (npcID) then
		RSConfigDB.SetNpcFiltered(npcID, true)
		RSLogger:PrintMessage(AL["ENABLED_SEARCHING_RARE"]..self:GetParent().Title:GetText())
		self:Hide()
		self:GetParent().FilterDisabledButton:Show()
	end
end)
scanner_button.FilterEnabledButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(AL["ENABLE_SEARCHING_RARE_TOOLTIP"])
	GameTooltip:Show()
end)

scanner_button.FilterEnabledButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

scanner_button.FilterEnabledTexture = scanner_button.FilterEnabledButton:CreateTexture()
scanner_button.FilterEnabledTexture:SetTexture([[Interface\WorldMap\Skull_64]])
scanner_button.FilterEnabledTexture:SetSize(12, 12)
scanner_button.FilterEnabledTexture:SetTexCoord(0,0.5,0,0.5)
scanner_button.FilterEnabledTexture:SetPoint("CENTER")
scanner_button.FilterEnabledButton:SetNormalTexture(scanner_button.FilterEnabledTexture)
scanner_button.FilterEnabledButton:Hide()

-- Loot bar
scanner_button.LootBar = CreateFrame("Frame", "LootBar", scanner_button)
scanner_button.LootBar.itemFramesPool = CreateFramePool("FRAME", scanner_button.LootBar, "RSLootTemplate");
scanner_button.LootBar.LootBarToolTip = CreateFrame("GameTooltip", "LootBarToolTip", scanner_button, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp1 = CreateFrame("GameTooltip", "LootBarToolTipComp1", nil, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp1:SetScale(0.8)
scanner_button.LootBar.LootBarToolTipComp2 = CreateFrame("GameTooltip", "LootBarToolTipComp2", nil, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp2:SetScale(0.8)
scanner_button.LootBar.LootBarToolTip.shoppingTooltips = { scanner_button.LootBar.LootBarToolTipComp1, scanner_button.LootBar.LootBarToolTipComp2 }

-- Show navigation buttons
scanner_button.NextButton = CreateFrame("Frame", "NextButton", scanner_button, "RSRightNavTemplate")
scanner_button.NextButton:Hide()
scanner_button.PreviousButton = CreateFrame("Frame", "PreviousButton", scanner_button, "RSLeftNavTemplate")
scanner_button.PreviousButton:Hide()

-- Player login
scanner_button:RegisterEvent("PLAYER_LOGIN")

-- Vignette events
scanner_button:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
scanner_button:RegisterEvent("VIGNETTES_UPDATED")

-- Nameplates events
scanner_button:RegisterEvent("NAME_PLATE_UNIT_ADDED")

-- Out of combat events
scanner_button:RegisterEvent("PLAYER_REGEN_ENABLED")

-- Unit deaths
scanner_button:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
scanner_button:RegisterEvent("PLAYER_TARGET_CHANGED")

-- Items events
scanner_button:RegisterEvent("GET_ITEM_INFO_RECEIVED")
scanner_button:RegisterEvent("LOOT_OPENED")

-- Avoid addon on cinematics
scanner_button:RegisterEvent("CINEMATIC_START")
scanner_button:RegisterEvent("CINEMATIC_STOP")

-- Chat messages
scanner_button:RegisterEvent("CHAT_MSG_MONSTER_YELL")
scanner_button:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

-- Quest events
scanner_button:RegisterEvent("QUEST_TURNED_IN")

-- Captures all events
local isCinematicPlaying = false
local hasLoadedCompletely = false
scanner_button:SetScript("OnEvent", function(self, event, ...)
	-- Player login
	if (event == "PLAYER_LOGIN") then
		local x, y = RSGeneralDB.GetButtonPositionCoordinates()
		if (x and y) then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT", x, y)
		end
	-- Vignette added to mini map
	elseif (event == "VIGNETTE_MINIMAP_UPDATED") then
		-- Get viggnette data
		local id = ...
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
		if (not vignetteInfo) then
			return
		else
			vignetteInfo.id = id
			self:DetectedNewVignette(self, vignetteInfo)
		end
		
		-- Update minimap to hide/show vignettes that are already displayed ingame
		RSMinimap.RefreshAllData(true)
	-- Vignette added to world map
	elseif (event == "VIGNETTES_UPDATED") then
	  if (not RSConfigDB.IsScanningWorldMapVignettes()) then
	     return
	  end
	  
		local vignetteGUIDs = C_VignetteInfo.GetVignettes();
		for _, vignetteGUID in ipairs(vignetteGUIDs) do
			local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignetteGUID);
			if (vignetteInfo and vignetteInfo.onWorldMap) then
				-- This event fires several times, avoid to capture it in 10 seconds
				if (not self.lastTimeVignetteUpdated or self.lastTimeVignetteUpdated < time()) then
					self.lastTimeVignetteUpdated = time() + 10 --wait 10 seconds
				else
					return
				end
				
				vignetteInfo.id = vignetteGUID
				self:DetectedNewVignette(self, vignetteInfo)
			end
		end
	-- Nameplates
	elseif (event == "NAME_PLATE_UNIT_ADDED") then
		local nameplateid = ...
		if (nameplateid and not UnitIsUnit("player", nameplateid) and not UnitIsFriend("player", nameplateid)) then
			local nameplateUnitGuid = UnitGUID(nameplateid)
			if (nameplateUnitGuid) then
			  local _, _, _, _, _, id = strsplit("-", nameplateUnitGuid)
				local npcID = id and tonumber(id) or nil
				
				-- If player in a zone with vignettes ignore it
				local mapID = C_Map.GetBestMapForUnit("player")
				if (mapID and not RSMapDB.IsZoneWithoutVignette(mapID)) then
				  return
				end
        
				-- If its a supported NPC and its not killed
				if ((RSGeneralDB.GetAlreadyFoundEntity(npcID) or RSNpcDB.GetInternalNpcInfo(npcID)) and not RSNpcDB.IsNpcKilled(npcID)) then
					local nameplateUnitName, _ = UnitName(nameplateid)
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

					self:SimulateRareFound(npcID, nameplateUnitGuid, nameplateUnitName, x, y, RSConstants.NPC_VIGNETTE)
					
					-- And then try to find better coordinates
					local minRange, maxRange = rc:GetRange(nameplateid)
					if (playerMapPosition and (minRange or maxRange)) then
						C_Timer.NewTicker(RSConstants.FIND_BETTER_COORDINATES_WITH_RANGE_TIMER, function() 
							local minRange, maxRange = rc:GetRange(nameplateid)
							if (minRange and minRange < 10) then
								RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(npcID)
								RSMinimap.RefreshAllData(true)
							end
						end, 15)
					end
				end
			end
		end
	-- Out of combat actions
	elseif (event == "PLAYER_REGEN_ENABLED") then
		if (self.pendingToShow) then
			self.pendingToShow = nil
			self.pendingToHide = nil -- just in case it was pending too
			self:ShowButton()
		elseif (self.pendingToHide) then
			self.pendingToHide = nil
			self:HideButton()
		end
	-- Target death
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _, eventType, _, _, _, _, _, destGUID, _, _, _ = CombatLogGetCurrentEventInfo()
		if (eventType == "PARTY_KILL") then
			local _, _, _, _, _, id = strsplit("-", destGUID)
			local npcID = id and tonumber(id) or nil
			RareScanner:ProcessKill(npcID)
		elseif (eventType == "UNIT_DIED") then
			local _, _, _, _, _, id = strsplit("-", destGUID)
			local npcID = id and tonumber(id) or nil
			
			-- Set is as dead if the target is already found and doesn't have the silver dragon anymore
			if (RSGeneralDB.GetAlreadyFoundEntity(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
				if (UnitExists("target") and destGUID == UnitGUID("target")) then
					local unitClassification = UnitClassification("target")
					if (unitClassification ~= "rare" and unitClassification ~= "rareelite") then
						RareScanner:ProcessKill(npcID)
					end
				end
			end
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
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
			
			-- if (npcID and RSGeneralDB.GetAlreadyFoundEntity(npcID) and RSConstants.DEBUG_MODE) then
				-- StaticPopupDialogs["UPDATE_COORDS"] = {
					-- text = "¿Quieres actualizar las coordenadas?",
					-- button1 = "Si",
					-- button2 = "No",
					-- OnAccept = function()
						--RSGeneralDB.UpdateAlreadyFoundEntityPlayerPosition(npcID)
					-- end,
					-- timeout = 0,
					-- whileDead = true,
					-- hideOnEscape = true,
					-- preferredIndex = 3,
				-- }
				-- StaticPopup_Show("UPDATE_COORDS")
			-- end
		end
	-- Loot info
	elseif (event == "GET_ITEM_INFO_RECEIVED") then
		local itemID = ...
		for itemFrame in self.LootBar.itemFramesPool:EnumerateActive() do
			if (itemFrame.itemID == itemID) then
				local added = itemFrame:AddItem(itemID, self.LootBar.itemFramesPool:GetNumActive())
				if (added == false) then
					self.LootBar.itemFramesPool:Release(itemFrame)
				end
				break;
			end
		end
	elseif (event == "LOOT_OPENED") then
		local numItems = GetNumLootItems()
		if (not numItems or numItems <= 0) then
			return
		end
		
		local containerLooted = false
		for i = 1, numItems do
			if (LootSlotHasItem(i)) then
				local destGUID = GetLootSourceInfo(i)
				local npcType, _, _, _, _, id = strsplit("-", destGUID)
				
				-- If the loot comes from a container that we support
				if (npcType == "GameObject") then
					local containerID = id and tonumber(id) or nil
			
					-- We support all the containers with vignette plus those ones that are part of achievements (without vignette)
					if (RSGeneralDB.GetAlreadyFoundEntity(containerID) or RSContainerDB.GetInternalContainerInfo(containerID)) then
						-- Check if we have the Container in our database but the addon didnt detect it
						-- This will happend in the case where the container doesnt have a vignette
						if (not RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
							RSGeneralDB.AddAlreadyFoundContainerWithoutVignette(containerID)
						end
						
						-- Sets the container as opened
						-- We are looping through all the items looted, we dont want to call this method with every item
						if (not containerLooted) then
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
				elseif (npcType == "Creature") then
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
				-- else
					-- local containerID = id and tonumber(id) or nil
					-- if (RSConstants.DEBUG_MODE) then
						-- StaticPopupDialogs["RS_CHECK_NEW"] = {
							-- text = "¿Quieres procesar el NPC/contenedor que acabas de localizar?",
							-- button1 = "Si",
							-- button2 = "No",
							-- OnAccept = function()
								-- -- Emulate vignette found
								-- if (not RSGeneralDB.GetAlreadyFoundEntity(containerID)) then
									-- RSGeneralDB.AddAlreadyFoundContainerWithoutVignette(containerID)
								-- end
								
								-- -- If its a cointainer check it as opened
								-- RareScanner:ProcessOpenContainer(containerID)
							-- end,
							-- timeout = 0,
							-- whileDead = true,
							-- hideOnEscape = true,
							-- preferredIndex = 3,
						-- }
						-- StaticPopup_Show("RS_CHECK_NEW")
						
						-- if (not private.dbglobal.temp_loot) then
							-- private.dbglobal.temp_loot = {}
						-- end
									
						-- RSLogger:PrintDebugMessage("DEBUG: Obtenido loot de "..destGUID)
						-- local itemLink = GetLootSlotLink(i)
						-- if (itemLink) then
							-- local _, _, _, ltype, id, _, _, _, _, _, _, _, _, _, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
							-- if (ltype == "item") then
								-- local itemID = id and tonumber(id) or nil
								-- if (itemID and (not private.dbglobal.temp_loot[npcID] or not RSUtils.Contains(private.dbglobal.temp_loot[npcID], itemID)) and (not private.NPC_LOOT[npcID] or not RSUtils.Contains(private.NPC_LOOT[npcID], itemID))) then
									-- RSLogger:PrintDebugMessage("DEBUG: Añadido nuevo botin "..itemID.." para el npcID "..npcID)
									-- if (not private.dbglobal.temp_loot[npcID]) then
										-- private.dbglobal.temp_loot[npcID] = {}
									-- end
									-- tinsert(private.dbglobal.temp_loot[npcID], itemID)
								-- end
							-- end
						-- end
					-- end
				-- end
			end
		end
	-- Chat
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
		-- If not disabled
		if (not RSConfigDB.IsScanningChatAlerts()) then
			return
		end
		
		-- Only for Mechagon
		local mapID = C_Map.GetBestMapForUnit("player")
		if (mapID and mapID == RSConstants.MECHAGON_MAPID) then
			local message, name = ...
			if (name) then
				local npcID = RSNpcDB.GetNpcId(name, mapID)
				if (not npcID) then
					return
				end
				
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
					self:SimulateRareFound(npcID, nil, name, x, y, RSConstants.NPC_VIGNETTE)
				end
			end
		end
	elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
		-- If not disabled
		if (not RSConfigDB.IsScanningChatAlerts()) then
			return
		end
		
		-- Check for Mechagon Construction Projects
		local mapID = C_Map.GetBestMapForUnit("player")
		if (mapID and mapID == RSConstants.MECHAGON_MAPID) then
			local message, name = ...
			for constructionProject, npcID in pairs(private.CONSTRUCTION_PROJECTS) do
				if (RSUtils.Contains(message, constructionProject)) then
					-- Simulates vignette event
					if (RSNpcDB.GetInternalNpcInfo(npcID) and not RSNpcDB.IsNpcKilled(npcID)) then
						local x, y = RSNpcDB.GetInternalNpcCoordinates(npcID, mapID)
						self:SimulateRareFound(npcID, nil, RSNpcDB.GetNpcName(npcID), x, y, RSConstants.NPC_VIGNETTE)
					end
					
					return
				end
			end
		end
	-- Quests
	elseif (event == "QUEST_TURNED_IN") then
		local questID, xpReward, moneyReward = ...
		
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
	-- Others
	elseif (event == "CINEMATIC_START") then
		isCinematicPlaying = true
		if (self:IsVisible()) then
			self:HideButton()
		end
	elseif (event == "CINEMATIC_STOP") then
		isCinematicPlaying = false
	else
		return
	end
end)

function scanner_button:SimulateRareFound(npcID, objectGUID, name, x, y, atlasName)
	local vignetteInfo = {}
	vignetteInfo.atlasName = atlasName
	vignetteInfo.id = "NPC"..npcID
	vignetteInfo.name = name
	vignetteInfo.objectGUID = objectGUID or string.format("a-a-a-a-a-%s-a", npcID)
	vignetteInfo.x = x
	vignetteInfo.y = y
	self:DetectedNewVignette(self, vignetteInfo)
end

function RareScanner:ProcessKill(npcID, forzed)
	-- Mark as killed
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	if (npcInfo) then
		-- If the npc belongs to several zones we have to use the players zone
		if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
			local playerZoneID = C_Map.GetBestMapForUnit("player")
			if (not playerZoneID) then
				return
			end
			
			for zoneID, zoneInfo in pairs (npcInfo.zoneID) do
				-- If the checking is forzed it means that its a kill detected while loading the addon
				-- and the playerZoneID doesn't have to match the NPCs, so take whatever zone
				if (forzed) then
					RareScanner:ProcessKillByZone(npcID, zoneID, forzed)
					break
				elseif (playerZoneID == zoneID) then
					RareScanner:ProcessKillByZone(npcID, zoneID, forzed)
					break
				end
			end
		else
			RareScanner:ProcessKillByZone(npcID, npcInfo.zoneID, forzed)
		end
		
		-- Extracts quest id if we don't have it
		-- Avoids shift-left-click events
		if (not forzed) then
			if (not npcInfo.questID and not RSNpcDB.GetNpcQuestIdFound(npcID)) then
				RSLogger:PrintDebugMessage(string.format("NPC [%s]. Buscando questID...", npcID))
				RSQuestTracker.FindCompletedHiddenQuestID(npcID, function(npcID, newQuestID) RSNpcDB.SetNpcQuestIdFound(npcID, newQuestID) end)
			elseif (npcInfo.questID) then
				RSLogger:PrintDebugMessage(string.format("El NPC [%s] ya dispone de questID [%s]", npcID, unpack(npcInfo.questID)))
			end
		end
	-- If we dont have this entity in our database we can ignore it
	else
		RSNpcDB.SetNpcKilled(npcID)
	end
	
	-- Refresh minimap
	if (not forzed) then
		RSMinimap.RefreshAllData(true)
	end
end

function RareScanner:ProcessKillByZone(npcID, mapID, forzed)
  local alreadyFoundInfo = RSGeneralDB.GetAlreadyFoundEntity(npcID)
	local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
	RSLogger:PrintDebugMessage(string.format("ProcessKillByZone[%s, %s]", npcID, mapID))
	
	-- If we know for sure it remains being a rare
	if (npcInfo and npcInfo.reset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Siempre es un rare NPC.", npcID))
	-- If we know for sure it resets with quests
	elseif (npcInfo and npcInfo.questReset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con las misiones del mundo", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + GetQuestResetTime())
	-- If we know for sure it resets with every server restart
	elseif (npcInfo and npcInfo.weeklyReset) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con el reinicio del servidor", npcID))
		RSNpcDB.SetNpcKilled(npcID, RSTimeUtils.GetServerResetTime())
	-- If we know the exact reset timer
	elseif (npcInfo and npcInfo.resetTimer) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea pasados [%s]segundos", npcID, npcInfo.resetTimer))
		RSNpcDB.SetNpcKilled(npcID, time() + npcInfo.resetTimer)
	-- If its a world quest reseteable rare
	elseif (RSMapDB.IsEntityInReseteableZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", npcID))
		RSNpcDB.SetNpcKilled(npcID, time() + GetQuestResetTime())
	-- If its a warfront reseteable rare
	elseif (RSMapDB.IsEntityInWarfrontZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Resetea cada 2 semanas (Warfront)", npcID))
		RSNpcDB.SetNpcKilled(npcID, RSTimeUtils.GetServerResetTime() + RSTimeUtils.DaysToSeconds(7))
	-- If it wont ever be a rare anymore
	elseif (RSMapDB.IsEntityInPermanentZone(npcID, mapID, alreadyFoundInfo)) then
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC", npcID))
		RSNpcDB.SetNpcKilled(npcID)
	-- If it has an associated quest and if its completed
	elseif (npcInfo and npcInfo.questID) then
		for i, questID in ipairs (npcInfo.questID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
				RSNpcDB.SetNpcKilled(npcID)
				RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC (por haber completado su mision)", npcID))
				break
			end
		end
	else
		RSLogger:PrintDebugMessage(string.format("NPC [%s]. Siempre es un rare NPC (por descarte)", npcID))
	end
	
	-- Looks for other NPCs with the same questID
	if (not forzed and RSNpcDB.IsNpcKilled(npcID) and npcInfo and npcInfo.questID) then
		-- Checks if quest completed
		C_Timer.After(2, function() 
			for internalNpcID, internalNpcInfo in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
				if (internalNpcInfo.questID and internalNpcID ~= npcID and RSUtils.Contains(internalNpcInfo.questID, npcInfo.questID)) then
					for i, questID in ipairs (internalNpcInfo.questID) do
						if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
							RSNpcDB.SetNpcKilled(internalNpcID, RSNpcDB.GetNpcKilledRespawnTime(npcID))
							RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC por compartir mision con otro rare NPC muerto [%s]", internalNpcID, npcID))
							RSGeneralDB.DeleteRecentlySeen(internalNpcID)
						end
					end
				end
			end
		end)
	end
	
	RSGeneralDB.DeleteRecentlySeen(npcID)
end

function RareScanner:ProcessOpenContainer(containerID, forzed)
  -- Mark as opened
  local containerInfo = RSContainerDB.GetInternalContainerInfo(containerID)
  if (containerInfo) then
    -- If the container belongs to several zones we have to use the players zone
    if (RSContainerDB.IsInternalContainerMultiZone(containerID)) then
      local playerZoneID = C_Map.GetBestMapForUnit("player")
      if (not playerZoneID) then
        return
      end
      
      for zoneID, zoneInfo in pairs (containerInfo.zoneID) do
        -- If the checking is forzed it means that its a opened detected while loading the addon
        -- and the playerZoneID doesn't have to match the Containers, so take whatever zone
        if (forzed) then
          RareScanner:ProcessOpenContainerByZone(containerID, zoneID, forzed)
          break
        elseif (playerZoneID == zoneID) then
          RareScanner:ProcessOpenContainerByZone(containerID, zoneID, forzed)
          break
        end
      end
    else
      RareScanner:ProcessOpenContainerByZone(containerID, containerInfo.zoneID, forzed)
    end
    
    -- Extracts quest id if we don't have it
    -- Avoids shift-left-click events
    if (not forzed) then
      if (not containerInfo.questID and not RSContainerDB.GetContainerQuestIdFound(containerID)) then
        RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Buscando questID...", containerID))
        RSQuestTracker.FindCompletedHiddenQuestID(containerID, function(containerID, newQuestID) RSContainerDB.SetContainerQuestIdFound(containerID, newQuestID) end)
      else
        RSLogger:PrintDebugMessage(string.format("El Contenedor [%s] ya dispone de questID [%s]", containerID, unpack(containerInfo.questID)))
      end
    end
  -- If we dont have this entity in our database we can ignore it
  else
    RSContainerDB.SetContainerOpened(containerID)
  end
  
  -- Refresh minimap
  if (not forzed) then
    RSMinimap.RefreshAllData(true)
  end
end

function RareScanner:ProcessOpenContainerByZone(containerID, mapID, forzed)
  local containerAlreadyFoundInfo = RSGeneralDB.GetAlreadyFoundEntity(containerID)
  local containerInternalInfo = RSNpcDB.GetInternalNpcInfo(containerID)
  RSLogger:PrintDebugMessage(string.format("ProcessOpenContainerByZone[%s, %s]", containerID, mapID))
  
  -- It it is a part of an achievement it won't come back
  local containerWithAchievement = false;
  if (private.ACHIEVEMENT_ZONE_IDS[mapID]) then
    for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
      for _, objectiveID in ipairs(private.ACHIEVEMENT_TARGET_IDS[achievementID]) do
        if (objectiveID == containerID) then
          RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo (por formar parte de un logro)", containerID))
          RSContainerDB.SetContainerOpened(containerID)
          containerWithAchievement = true;
          break;
        end
      end
    end
  end
  
  if (not containerWithAchievement) then  
    -- If we know for sure it remains showing up along the day
    if (containerInternalInfo and containerInternalInfo.reset) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Vuelve a aparecer en el mismo día.", containerID))
  	-- If we know for sure it resets with quests
  	elseif (containerInternalInfo and containerInternalInfo.questReset) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo", containerID))
  		RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
  	-- If we know for sure it resets with every server restart
  	elseif (containerInternalInfo and containerInternalInfo.weeklyReset) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con el reinicio del servidor", containerID))
  		RSContainerDB.SetContainerOpened(containerID, RSTimeUtils.GetServerResetTime())
  	-- If we know the exact reset timer
  	elseif (containerInternalInfo and containerInternalInfo.resetTimer) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea pasados [%s]segundos", containerID, containerInternalInfo.resetTimer))
  		RSContainerDB.SetContainerOpened(containerID, time() + containerInternalInfo.resetTimer)
  	-- If its a world quest reseteable container
  	elseif (RSMapDB.IsEntityInReseteableZone(containerID, mapID, containerAlreadyFoundInfo)) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", containerID))
  		RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
  	-- If its a world quest reseteable container (detected while playing)
  	elseif (RSContainerDB.IsContainerReseteable(containerID)) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea con las misiones del mundo (detectado al haberse encontrado por segunda vez)", containerID))
  		RSContainerDB.SetContainerOpened(containerID, time() + GetQuestResetTime())
  	-- If its a warfront reseteable container
  	elseif (RSMapDB.IsEntityInWarfrontZone(containerID, mapID, containerAlreadyFoundInfo)) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Resetea cada 2 semanas (Warfront)", containerID))
  		RSContainerDB.SetContainerOpened(containerID, RSTimeUtils.GetServerResetTime() + RSTimeUtils.DaysToSeconds(7))
  	-- If it wont ever be open anymore
  	elseif (RSMapDB.IsEntityInPermanentZone(containerID, mapID, containerAlreadyFoundInfo)) then
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo", containerID))
  		RSContainerDB.SetContainerOpened(containerID)
  	-- If it has an associated quest and if its completed
  	elseif (containerInternalInfo and containerInternalInfo.questID) then
      RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Detectado que tiene mision asociada, buscando si esta completada", containerID))
  		for _, questID in ipairs (containerInternalInfo.questID) do
  			if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
  				RSContainerDB.SetContainerOpened(containerID)
  				RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. No se puede abrir de nuevo (por haber completado su mision)", containerID))
  				break
  			end
  		end
  	else
  		RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Vuelve a reaparecer (por descarte)", containerID))
  	end
  end
	
  -- There are some containers that share the same questID
  if (not forzed and RSContainerDB.IsContainerOpened(containerID) and containerInternalInfo and containerInternalInfo.questID) then
    -- Checks if quest completed
    C_Timer.After(2, function() 
      for internalNpcID, internalNpcInfo in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
        if (internalNpcInfo.questID and RSUtils.Contains(internalNpcInfo.questID, containerInternalInfo.questID)) then
          for i, questID in ipairs (internalNpcInfo.questID) do
            if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
              RSNpcDB.SetNpcKilled(internalNpcID, RSContainerDB.GetContainerOpenedRespawnTime(containerID))
              RSLogger:PrintDebugMessage(string.format("NPC [%s]. Deja de ser un rare NPC por compartir mision con otro contenedor abierto [%s]", internalNpcID, containerID))
              RSGeneralDB.DeleteRecentlySeen(internalNpcID)
            end
          end
        end
      end
    end)
  end
  
	RSGeneralDB.DeleteRecentlySeen(containerID)
end

function RareScanner:ProcessCompletedEvent(eventID, forzed)
	if (not eventID) then
		return
	end
	
	RSLogger:PrintDebugMessage(string.format("ProcessCompletedEvent[%s]", eventID))
	
	local eventAlreadyFound = RSGeneralDB.GetAlreadyFoundEntity(eventID)
	local eventInternalInfo = RSEventDB.GetInternalEventInfo(eventID)
	local mapID = eventAlreadyFound and eventAlreadyFound.mapID or eventInternalInfo and eventInternalInfo.zoneID
	
	-- If we know for sure it remains showing up along the day
	if (eventInternalInfo and eventInternalInfo.reset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Vuelve a aparecer en el mismo día.", eventID))
	-- If we know for sure it resets with quests
	elseif (eventInternalInfo and eventInternalInfo.questReset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con las misiones del mundo", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + GetQuestResetTime())
	-- If we know for sure it resets with every server restart
	elseif (eventInternalInfo and eventInternalInfo.weeklyReset) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con el reinicio del servidor", eventID))
		RSEventDB.SetEventCompleted(eventID, RSTimeUtils.GetServerResetTime())
	-- If we know the exact reset timer
	elseif (eventInternalInfo and eventInternalInfo.resetTimer) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea pasados [%s]segundos", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + eventInternalInfo.resetTimer)
	-- If its a world quest reseteable event
	elseif (RSMapDB.IsEntityInReseteableZone(eventID, mapID, eventAlreadyFound)) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Resetea con las misiones del mundo (por pertenecer a una zona reseteable)", eventID))
		RSEventDB.SetEventCompleted(eventID, time() + GetQuestResetTime())
	-- If it wont ever be available anymore
	elseif (RSMapDB.IsEntityInPermanentZone(eventID, mapID, eventAlreadyFound)) then
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. No se puede abrir de nuevo", eventID))
		RSEventDB.SetEventCompleted(eventID)
	-- If it has an associated quest and if its completed
	elseif (eventInternalInfo and eventInternalInfo.questID) then
		for _, questID in ipairs (eventInternalInfo.questID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then
				RSEventDB.SetEventCompleted(eventID)
				RSLogger:PrintDebugMessage(string.format("Evento [%s]. No se puede completar de nuevo (por haber completado su mision)", eventID))
				break
			end
		end
	else
		RSLogger:PrintDebugMessage(string.format("Evento [%s]. Vuelve a estar disponible (por descarte)", eventID))
	end
		
	-- Extracts quest id if we don't have it
	-- Avoids shift-left-click events
	if (not forzed) then
		if ((not eventInternalInfo or not eventInternalInfo.questID) and not RSEventDB.GetEventQuestIdFound(containerID)) then
			RSLogger:PrintDebugMessage(string.format("Evento [%s]. Buscando questID...", eventID))
			RSQuestTracker.FindCompletedHiddenQuestID(eventID, function(eventID, newQuestID) RSEventDB.SetEventQuestIdFound(eventID, newQuestID) end)
		else
			RSLogger:PrintDebugMessage(string.format("El Evento [%s] ya dispone de questID [%s]", eventID, unpack(eventInternalInfo.questID)))
		end
	end
	
	RSGeneralDB.DeleteRecentlySeen(containerID)
	
	-- Refresh minimap
	if (not forzed) then
		RSMinimap.RefreshAllData(true)
	end
end

-- Checks if the rare has been found already in the last 5 minutes
function scanner_button:DetectedNewVignette(self, vignetteInfo, isNavigating)
	local _, _, _, _, _, id, _ = strsplit("-", vignetteInfo.objectGUID);
	local npcID = tonumber(id)
	
	-- Check it it is an entity that use a vignette but it isn't a rare, event or treasure
	if (RSUtils.Contains(RSConstants.INGNORED_VIGNETTES, npcID)) then
	 return
	end
	
	-- Check if we have already found this vignette in a short period of time
	if (RareScanner:IsVignetteAlreadyFound(vignetteInfo.id, isNavigating, npcID)) then
		return
	end
	
	local mapID = C_Map.GetBestMapForUnit("player")
	
	-- In Uldum and Valley of eternal Blossoms the icon for elite NPC is used for events
	if (mapID and vignetteInfo.atlasName == RSConstants.NPC_VIGNETTE_ELITE and (mapID == RSConstants.VALLEY_OF_ETERNAL_BLOSSOMS_MAPID or mapID == RSConstants.ULDUM_MAPID)) then
		vignetteInfo.atlasName = RSConstants.EVENT_VIGNETTE
	end

	-- In Tanaan jungle the icon for elite EVENTs is used for the rare NPCs Deathtalon, Doomroller, Terrorfist, and Vengeance 
	if (vignetteInfo.atlasName == RSConstants.EVENT_ELITE_VIGNETTE and (npcID == RSConstants.DOOMROLLER_ID or npcID == RSConstants.DEATHTALON or npcID == RSConstants.TERRORFIST or npcID == RSConstants.VENGEANCE)) then
		vignetteInfo.atlasName = RSConstants.NPC_VIGNETTE
	end
	
	-- These NPCs are tagged with events
	if (npcID == RSConstants.MYSTIC_RAINBOWHORN or npcID == RSConstants.DEATHBINDER_HROTH or npcID == RSConstants.BAEDOS) then
	  vignetteInfo.atlasName = RSConstants.NPC_VIGNETTE
	end
	
	-- These containers are tagged with rare NPCs
	if (npcID == RSConstants.CATACOMBS_CACHE) then
	 vignetteInfo.atlasName = RSConstants.CONTAINER_VIGNETTE
	end
	
	if (not isNavigating) then
		-- If the vignette is simulated
		if (vignetteInfo.x and vignetteInfo.y) then
			local coordinates = {}
			coordinates.x = vignetteInfo.x
			coordinates.y = vignetteInfo.y
			RareScanner:UpdateRareFound(npcID, vignetteInfo, coordinates)
		else
			RareScanner:UpdateRareFound(npcID, vignetteInfo)
		end
		
		-- If we have it as dead but we got a notification it means that the restart time is wrong (this happends mostly with war fronts)
		if (RSNpcDB.IsNpcKilled(npcID)) then
			RSLogger:PrintDebugMessage(string.format("El NPC [%s] estaba marcado como muerto, pero lo acabamos de detectar vivo, resucitado!", npcID))
			RSNpcDB.DeleteNpcKilled(npcID)
		end
	end
	
	local isInstance, instanceType = IsInInstance()
	
	-- disable ALL alerts while cinematic is playing
	if (isCinematicPlaying) then
		return
	-- disable ALL alerts in instances
	elseif (isInstance == true and not RSConfigDB.IsScanningInInstances()) then
		return
	-- disable alerts while flying
	elseif (UnitOnTaxi("player") and not RSConfigDB.IsScanningWhileOnTaxi()) then
		return
	-- disable scanning for every entity that is not treasure, event or rare
	elseif (not RSConstants.IsScanneableAtlas(vignetteInfo.atlasName)) then
		return
	-- disable ALL alerts for containers
	elseif (RSConstants.IsContainerAtlas(vignetteInfo.atlasName) and not RSConfigDB.IsScanningForContainers()) then
		return
	-- disable alerts for rares NPCs
	elseif (RSConstants.IsNpcAtlas(vignetteInfo.atlasName) and not RSConfigDB.IsScanningForNpcs()) then
		return
	-- disable alerts for events
	elseif (RSConstants.IsEventAtlas(vignetteInfo.atlasName) and not RSConfigDB.IsScanningForEvents()) then
		return
	-- disable alerts for filtered zones
	elseif (not RSConfigDB.IsZoneFilteredOnlyOnWorldMap() and (RSConfigDB.IsZoneFiltered(mapID) or RSConfigDB.IsEntityZoneFiltered(npcID, vignetteInfo.atlasName))) then
		return
	-- extra checkings for containers
	elseif (RSConstants.IsContainerAtlas(vignetteInfo.atlasName)) then
		-- save containers to show it on the world map
		RSContainerDB.SetContainerName(npcID, vignetteInfo.name)
		
		-- some containers belong to places where rares die forever
		-- and anyway, this containers can respawn every day
		-- so if this is the case, mark it as an exception
		if (RSContainerDB.IsContainerOpened(npcID)) then
			RSContainerDB.SetContainerReseteable(npcID)
			RSContainerDB.DeleteContainerOpened(npcID)
			RSLogger:PrintDebugMessage(string.format("Contenedor [%s]. Detectado como reseteable (cuando no lo estaba)", npcID))
		end
		
		-- disable garrison container alert
		if (not RSConfigDB.IsShowingGarrisonCache()) then
			-- check if the container is the garrison cache
			if (RSUtils.Contains(RSConstants.GARRISON_CACHE_IDS, npcID)) then
				RSLogger:PrintDebugMessage("DEBUG: Detectado cofre de la ciudadela filtrado")
				return
			end
		end
		
		-- disable button alert for containers
		if (not RSConfigDB.IsButtonDisplayingForContainers()) then
			RSGeneralDB.SetRecentlySeen(npcID)
			
			-- If navigation disabled, control Tomtom waypoint externally
			if (not RSConfigDB.IsDisplayingNavigationArrows()) then
				RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo)
        RSWaypoints.AddWaypointFromVignette(vignetteInfo)
			end
				
			if (RareScanner:IsVignetteAlreadyFound(vignetteInfo.id, false)) then
				return
			else
				RareScanner:SetVignetteFound(vignetteInfo.id, false)
				
				-- flashes the wow icon in windows bar
				FlashClientIcon()
				self:PlaySoundAlert(vignetteInfo.atlasName)
				self:DisplayMessages(vignetteInfo.name)
				return
			end
		end
	-- extra checkings for events
	elseif (RSConstants.IsEventAtlas(vignetteInfo.atlasName)) then
		-- check just in case its an NPC
		if (not RSNpcDB.GetNpcName(npcID)) then
			RSEventDB.SetEventName(npcID, vignetteInfo.name)
		end
	end
	
	-- Check if we have already found this vignette in a short period of time
	-- We checked this already at the beggining, but check again just in case two alerts where received at the same time
	if (RareScanner:IsVignetteAlreadyFound(vignetteInfo.id, isNavigating, npcID)) then
		return
	end
	
	-- Sets the current vignette as new found
	RareScanner:SetVignetteFound(vignetteInfo.id, isNavigating, npcID)
	
	-- Check if the NPC is filtered, in which case we don't show anything
	if (npcID and not RSConfigDB.IsNpcFilteredOnlyOnWorldMap() and RSConfigDB.IsNpcFiltered(npcID)) then
		return
	end
	
	--------------------------------
	-- show messages and play alarm
	--------------------------------
	if (not isNavigating) then
		self:DisplayMessages(vignetteInfo.name)
		self:PlaySoundAlert(vignetteInfo.atlasName)
	end
	
	------------------------
	-- set up new button
	------------------------
	if (RSConfigDB.IsButtonDisplaying()) then
		-- Adds the new NPCID to the navigation list
		if (RSConfigDB.IsDisplayingNavigationArrows() and not isNavigating) then
			self.NextButton:AddNext(vignetteInfo)
		end
		
		-- Show the button
		if (not self:IsShown() or isNavigating or not RSConfigDB.IsDisplayingNavigationArrows() or not RSConfigDB.IsNavigationLockEnabled()) then		
			self.npcID = npcID
			self.name = vignetteInfo.name
			self.atlasName = vignetteInfo.atlasName
			
			local npcInfo = RSNpcDB.GetInternalNpcInfo(npcID)
			self.displayID = npcInfo and npcInfo.displayID or nil
			
			-- Show button / miniature / loot bar if not in combat
			if (not InCombatLockdown()) then
				-- Wow API doesnt allow to call Show() (protected function) if you are under attack, so
				-- we check if this is the situation to avoid it and show the frames
				-- once the battle is over (pendingToShow)
				self:ShowButton()
			else
				-- Mark to show after combat
				self.pendingToShow = true
			end
		elseif (RSConfigDB.IsDisplayingNavigationArrows() and RSConfigDB.IsNavigationLockEnabled()) then
			-- reset the time to auto hide (so it takes into account the new entity found)
			self:StartHideTimer()
	
			-- Refresh the navigation arrows
			if (self.NextButton:EnableNextButton()) then
				self.NextButton:Show()
			else
				self.NextButton:Hide()
			end
			
			if (self.PreviousButton:EnablePreviousButton()) then
				self.PreviousButton:Show()
			else
				self.PreviousButton:Hide()
			end
		end
	end
	
	-- If navigation disabled, control Tomtom waypoint externally
	if (not RSConfigDB.IsButtonDisplaying() or not RSConfigDB.IsDisplayingNavigationArrows()) then
		RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo)
    RSWaypoints.AddWaypointFromVignette(vignetteInfo)
	end
	
	if (not isNavigating) then
		RSGeneralDB.SetRecentlySeen(npcID)
	end

	-- timer to reset already found NPC
	C_Timer.After(RSConstants.CLEAR_ALREADY_FOUND_VIGNETTE_TIMER, function() 
		RareScanner:RemoveVignetteFound(vignetteInfo.id, npcID)
		RSMinimap.RefreshAllData(true)
	end)
	
	-- Refresh minimap
	RSMinimap.RefreshAllData(true)
end

function RareScanner:RemoveVignetteFound(vignetteID, npcID)
	if (self.already_notified) then
		self.already_notified[vignetteID] = nil
		self.already_notified["NPC"..npcID] = nil
	end
end

function RareScanner:SetVignetteFound(vignetteID, isNavigating, npcID)
	if (not self.already_notified) then
		self.already_notified = {}
	end
	
	if (not isNavigating) then
		self.already_notified[vignetteID] = true
		
		-- FIX Blubbery Blobule/Unstable Glob (NPCID = 160841/161407) multipoping
		if (npcID == 160841) then
			self.already_notified["NPC160841"] = true
		elseif (npcID == 161407) then
			self.already_notified["NPC161407"] = true
		end
	end
end

function RareScanner:IsVignetteAlreadyFound(vignetteID, isNavigating, npcID)
	if (not isNavigating and self.already_notified) then
		if (self.already_notified[vignetteID] or (npcID and self.already_notified["NPC"..npcID])) then
			return true
		end
		
		-- Avoids showing alert if user is targeting that NPC already
		-- This will avoid getting constant alerts for the same rare NPC if the user takes a while to start combat 
		-- and the vignettes is removed from the alreadyFound list
		if (UnitExists("target")) then
			local targetUid = UnitGUID("target")
			local _, _, _, _, _, targetNpcID = strsplit("-", targetUid)
			if (tonumber(targetNpcID) == npcID) then
				return true
			end
		end
		
		-- Check whether the vignetteID is real or fake
		local fake = false
		local vignetteGUID, _, _, _, _, _ = strsplit("-", vignetteID)
		if (vignetteGUID == "a") then
			fake = true
		end
		
		-- If the vignette is fake it has to check through all the real vignettes to find out if its being found already
		if (fake and npcID) then
			for alreadyNotifiedVignetteId, _ in pairs (self.already_notified) do
				if (RSUtils.Contains(alreadyNotifiedVignetteId, "-")) then
					local _, _, _, _, _, alreadyNotifiedNpcID, _ = strsplit("-", alreadyNotifiedVignetteId);
					if (tonumber(alreadyNotifiedNpcID) == npcID) then
						return true
					end
				end
			end
		end
	end
	
	return false
end

function RareScanner:UpdateRareFound(entityID, vignetteInfo, coordinates)
	-- Calculates all the parameters
	local atlasName
	
	-- If its a NPC
	local mapID = nil
	if (RSConstants.IsNpcAtlas(vignetteInfo.atlasName)) then
		atlasName = RSConstants.NPC_VIGNETTE
		
		-- MapID always try to get it first from the internal database
		-- GetBestMapForUnit not always returns the expected value!
		local npcInfo = RSNpcDB.GetInternalNpcInfo(entityID)
		if (RSNpcDB.IsInternalNpcMonoZone(entityID) and npcInfo.zoneID ~= 0) then
			mapID = npcInfo.zoneID
		else
			mapID = C_Map.GetBestMapForUnit("player")
		end
	-- If its a container
	elseif (RSConstants.IsContainerAtlas(vignetteInfo.atlasName)) then 
		atlasName = RSConstants.CONTAINER_VIGNETTE
		
		-- MapID always try to get it first from the internal database
		-- GetBestMapForUnit not always returns the expected value!
		local containerInfo = RSContainerDB.GetInternalContainerInfo(entityID)
		if (RSContainerDB.IsInternalContainerMonoZone(entityID) and containerInfo.zoneID ~= 0) then
			mapID = containerInfo.zoneID
		else
			mapID = C_Map.GetBestMapForUnit("player")
		end
	-- If its an event
	elseif (RSConstants.IsEventAtlas(vignetteInfo.atlasName)) then 
		atlasName = RSConstants.EVENT_VIGNETTE
		
		-- MapID always try to get it first from the internal database
		-- GetBestMapForUnit not always returns the expected value!
		local eventInfo = RSEventDB.GetInternalEventInfo(entityID)
		if (eventInfo and eventInfo.zoneID ~= 0) then
			mapID = eventInfo.zoneID
		else
			mapID = C_Map.GetBestMapForUnit("player")
		end
	else
		return
	end
	
    if (not mapID or mapID == 0) then
		RSLogger:PrintDebugMessage(string.format("UpdateRareFound[%s]: Error! No se ha podido calcular el mapID para la entidad recien encontrada!", entityID))
		return
	end

	-- Extract the coordinates from the parameter if we are simulating a vignette, or from a real vignette info
	local vignettePosition = nil
	if (coordinates and coordinates.x and coordinates.y) then
		vignettePosition = coordinates
	else
		vignettePosition = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, mapID)
	end
	
	if (not vignettePosition) then
		RSLogger:PrintDebugMessage(string.format("UpdateRareFound[%s]: Error! No se han podido calcular las coordenadas para la entidad recien encontrada!", entityID))
		return
	end
	
	local artID = C_Map.GetMapArtID(mapID)
	
	-- Updates if it was found before
	if (RSGeneralDB.GetAlreadyFoundEntity(entityID)) then
		RSGeneralDB.UpdateAlreadyFoundEntity(entityID, mapID, vignettePosition.x, vignettePosition.y, artID)
	-- Adds if its the first time found
	else
		RSGeneralDB.AddAlreadyFoundEntity(entityID, mapID, vignettePosition.x, vignettePosition.y, artID, atlasName)
	end
end

function scanner_button:PlaySoundAlert(atlasName)
	if (not RSConfigDB.IsPlayingSound()) then
		if (RSConstants.IsContainerAtlas(atlasName) or RSConstants.IsEventAtlas(atlasName)) then
			--PlaySoundFile(string.gsub(private.SOUNDS[RSConfigDB.GetSoundPlayedWithObjects()], "-4", "-"..RSConfigDB.GetSoundVolume()), "Master")
            PlaySound(private.SOUNDS[RSConfigDB.GetSoundPlayedWithObjects()], "Master", false)
		else
			--PlaySoundFile(string.gsub(private.SOUNDS[RSConfigDB.GetSoundPlayedWithNpcs()], "-4", "-"..RSConfigDB.GetSoundVolume()), "Master")
			PlaySound(private.SOUNDS[RSConfigDB.GetSoundPlayedWithNpcs()], "Master", false)
		end
	end
end

function scanner_button:DisplayMessages(name)
	if (name) then
		if (RSConfigDB.IsDisplayingRaidWarning()) then
			RaidNotice_AddMessage(RaidWarningFrame, string.format(AL["JUST_SPAWNED"], name), ChatTypeInfo["RAID_WARNING"], RSConstants.RAID_WARNING_SHOWING_TIME)
		end
		
		-- Print message in chat if user wants
		if (RSConfigDB.IsDisplayingChatMessages()) then
			RSLogger:PrintMessage(string.format(AL["JUST_SPAWNED"], name))
		end
	else
		if (RSConfigDB.IsDisplayingRaidWarning()) then
			RaidNotice_AddMessage(RaidWarningFrame, AL["ALARM_MESSAGE"], ChatTypeInfo["RAID_WARNING"], RSConstants.RAID_WARNING_SHOWING_TIME)
		end
	end
end

-- Hide action
function scanner_button:HideButton() 
	if (not InCombatLockdown()) then
		GameTooltip:Hide()
		scanner_button.ModelView:ClearModel()
		scanner_button.ModelView:Hide()
		scanner_button:Hide()
	else
		scanner_button.pendingToHide = true
	end
end

-- Show action
function scanner_button:ShowButton()
	-- Resizes the button
	self:SetScale(RSConfigDB.GetButtonScale())

	-- Sets the name
	self.Title:SetText(self.name)
			
	-- show loot bar
	if (RSConfigDB.IsDisplayingLootBar()) then
		self:LoadLootBar()
		-- call a second time just in case the game took
		-- too long to fetch their data and they rendered 
		-- acuardly
		C_Timer.After(2, function() 
			self:LoadLootBar()
		end)
	end
	
	-- show navigation arrows
	if (RSConfigDB.IsDisplayingNavigationArrows()) then
		if (self.NextButton:EnableNextButton()) then
			self.NextButton:Show()
		else
			self.NextButton:Hide()
		end
		
		if (self.PreviousButton:EnablePreviousButton()) then
			self.PreviousButton:Show()
		else
			self.PreviousButton:Hide()
		end
	end

	-- Show button, model and loot panel
	if (self.npcID and RSConstants.IsNpcAtlas(self.atlasName)) then
		self.Description_text:SetText(AL["CLICK_TARGET"])
		
		local macrotext = "/cleartarget\n/targetexact "..self.name
		if (RSConfigDB.IsDisplayingMarkerOnTarget()) then
			macrotext = string.format("%s\n/tm %s",macrotext, RSConfigDB.GetMarkerOnTarget())
		end
		
		macrotext = string.format("%s\n/rarescanner %s;%s;%s",macrotext, RSConstants.CMD_TOMTOM_WAYPOINT, self.npcID, self.name)
		
		self:SetAttribute("macrotext", macrotext)
		
		-- show button
		self:Show()
	
		-- show model
		if (self.displayID and RSConfigDB.IsDisplayingModel()) then
			self.ModelView:SetDisplayInfo(self.displayID)
			self.ModelView:Show()
		else
			self.ModelView:Hide()
		end
		
		-- Hide reset filter if it was shown
		self.FilterEnabledButton:Hide()
				
		-- Show filter button
		self.FilterDisabledButton:Show()
	else
		self.Description_text:SetText(AL["NOT_TARGETEABLE"])
		self:SetAttribute("macrotext", string.format("\n/rarescanner %s;%s;%s", RSConstants.CMD_TOMTOM_WAYPOINT, self.npcID, self.name))
		
		-- hide model if displayed
		self.ModelView:ClearModel()
		self.ModelView:Hide()
		
		-- hide filter button if displayed
		self.FilterDisabledButton:Hide()
		self.FilterEnabledButton:Hide()
		
		-- show button
		self:Show()
	end
	
	-- set the time to auto hide
	self:StartHideTimer()
end

function scanner_button:LoadLootBar() 
	self.LootBar.itemFramesPool:ReleaseAll()
	if (not self.npcID) then
		return
	end

	-- Extract NPC loot
	local itemIDs
	if (RSConstants.IsNpcAtlas(self.atlasName)) then
		itemIDs = RSNpcDB.GetNpcLoot(self.npcID)
	elseif (RSConstants.IsContainerAtlas(self.atlasName)) then
		itemIDs = RSContainerDB.GetContainerLoot(self.npcID)
	end

	if (itemIDs) then
		local numItems = RSConfigDB.GetMaxNumItemsToShow()
		for i, itemID in ipairs(itemIDs) do
			if (i <= numItems) then
				local itemFrame = self.LootBar.itemFramesPool:Acquire()
				local added = itemFrame:AddItem(itemID, self.LootBar.itemFramesPool:GetNumActive())
				if (added == false) then
					self.LootBar.itemFramesPool:Release(itemFrame)
					numItems = numItems + 1
				end
			else 
				break
			end
		end
	end
end

function scanner_button:StartHideTimer()
	if (RSConfigDB.GetAutoHideButtonTime() > 0) then
		if (AUTOHIDING_TIMER) then
			AUTOHIDING_TIMER:Cancel()
		end
		AUTOHIDING_TIMER = C_Timer.NewTimer(RSConfigDB.GetAutoHideButtonTime(), function() 
			scanner_button:HideButton() 
		end)
	end
end

----------------------------------------------
-- Testing
----------------------------------------------
function RareScanner:Test() 
	local npcTestName = "Time-Lost Proto-Drake"
	local npcTestID = 32491
	local npcTestDisplayID = 26711
	
	scanner_button.npcID = npcTestID
	scanner_button.name = npcTestName
	scanner_button.displayID = npcTestDisplayID
	scanner_button.atlasName = RSConstants.NPC_VIGNETTE
	scanner_button.Title:SetText(npcTestName)
	scanner_button:DisplayMessages(npcTestName)
	scanner_button:PlaySoundAlert(RSConstants.NPC_VIGNETTE)
	scanner_button.Description_text:SetText(AL["CLICK_TARGET"])
	
	if (not InCombatLockdown()) then	
		scanner_button:ShowButton()
		scanner_button.FilterDisabledButton:Hide()
	end
	
	RSLogger:PrintMessage("test launched")
end

function RareScanner:ResetPosition()
	scanner_button:ClearAllPoints()
	scanner_button:SetPoint("BOTTOM", UIParent, 0, 128)
	RSGeneralDB.SetButtonPositionCoordinates(scanner_button:GetLeft(), scanner_button:GetBottom())
end

----------------------------------------------
-- Loading addon methods
----------------------------------------------
function RareScanner:OnInitialize() 	
	-- Init database
	self:InitializeDataBase()
	
	-- Adds about panel to wow options
	if (LibAboutPanel) then
		self.optionsFrame = LibAboutPanel.new(nil, "RareScanner")
	end
	
	-- Initialize setup panels
	self:SetupOptions()
	
	-- Initialize not discovered lists
	RSMap.InitializeNotDiscoveredLists()
	
	-- Setup our map provider
	WorldMapFrame:AddDataProvider(CreateFromMixins(RareScannerDataProviderMixin));
	WorldMapFrame:AddOverlayFrame("WorldMapRSSearchTemplate", "FRAME", "CENTER", WorldMapFrame:GetCanvasContainer(), "TOP", 0, 0);
	
	-- Add options to the world map menu
	RSWorldMapHooks.HookDropDownMenu()
	
	-- Load completed quests
	RSQuestTracker.CacheAllCompletedQuestIDs()
	
	-- Initialize special events
	self:InitializeSpecialEvents()
	
	-- Refresh minimap
	C_Timer.NewTicker(2, function()
		RSMinimap.RefreshAllData()
	end)

	--RSLogger:PrintMessage("loaded")
end

function RareScanner:InitializeSpecialEvents()
	RareScanner:ShadowlandsPrePatch_Initialize()
end

local function DumpRepeatedLoot()
  for npcID, npcLootFound in pairs(RSNpcDB.GetAllNpcsLootFound()) do
    local cleanItemsList = RSUtils.FilterRepeated(npcLootFound, RSNpcDB.GetInteralNpcLoot(npcID))
    if (cleanItemsList) then
      RSNpcDB.SetNpcLootFound(npcID, cleanItemsList)
    else
      RSNpcDB.RemoveNpcLootFound(npcID)
    end
  end
  for containerID, containerLootFound in pairs(RSContainerDB.GetAllContainersLootFound()) do
    local cleanItemsList = RSUtils.FilterRepeated(containerLootFound, RSNpcDB.GetInteralNpcLoot(containerID))
    if (cleanItemsList) then
      RSContainerDB.SetContainerLootFound(containerID, cleanItemsList)
    else
      RSContainerDB.RemoveContainerLootFound(containerID)
    end
  end
end

local function RefreshDatabaseData()
	-- Checks again if the rare names DB is totally updated
	-- It could fail if a "script run too long" exception was launched on the first login
	local currentDbVersion = RSGeneralDB.GetDbVersion()
	local sync = true
	if (not currentDbVersion.sync) then
		for npcID, _ in pairs(RSNpcDB.GetAllInternalNpcInfo()) do
			if (not RSNpcDB.GetNpcName(npcID)) then
				RSLogger:PrintDebugMessage(string.format("NPC [%s]. Sin nombre, reintantando obtenerlo.", npcID))
				RSNpcDB.GetNpcName(npcID);
				sync = false
			end
		end
		
		RSLogger:PrintDebugMessage(string.format("Version sincronizada: [%s]", (sync and 'true' or 'false')))
		currentDbVersion.sync = sync
	end

	-- Initialize rare filter list
	for npcIDwithName, _ in pairs(RSNpcDB.GetAllNpcNames()) do 
		RSConstants.PROFILE_DEFAULTS.profile.general.filteredRares[npcIDwithName] = true
	end
	RareScanner.db:RegisterDefaults(RSConstants.PROFILE_DEFAULTS)
	
	-- Sync loot found with internal database and remove duplicates
	local lootDbVersion = RSGeneralDB.GetLootDbVersion()
	if (not lootDbVersion or lootDbVersion < RSConstants.CURRENT_LOOT_DB_VERSION) then
		RSGeneralDB.SetLootDbVersion(RSConstants.CURRENT_LOOT_DB_VERSION)
		DumpRepeatedLoot()
	end
	
	-- Initialize respawning tracker and scan the first time
	RSRespawnTracker.Init()
	
	-- Sync NPC quests ids with internal database and remove duplicates and
	-- Set already killed NPCs checking questID (internal database)
	for npcID, npcInfo in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
		if (npcInfo.questID) then
			RSNpcDB.RemoveNpcQuestIdFound(npcID)
			for _, questID in ipairs (npcInfo.questID) do
				if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSNpcDB.IsNpcKilled(npcID)) then
					RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El NPC[%s] no esta marcado como muerto, pero su mision (BD addon) esta completada", npcID))
					-- The NPC will be tagged as dead as usual, it won't be until the next world quest reset
					-- when the RespawnTracker will decide if this NPC died forever
					RareScanner:ProcessKill(npcID, true)
					break
				end
			end
		end
	end
	
	-- Set already killed NPCs checking questID (local database)
	for npcID, questsID in pairs (RSNpcDB.GetAllNpcQuestIdsFound()) do
		for _, questID in ipairs(questsID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSNpcDB.IsNpcKilled(npcID)) then
				RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El NPC[%s] no esta marcado como muerto, pero su mision (BD capturada) esta completada", npcID))
        -- The NPC will be tagged as dead as usual, it won't be until the next world quest reset
        -- when the RespawnTracker will decide if this NPC died forever
				RareScanner:ProcessKill(npcID, true)
				break
			end
		end
	end
	
	-- Sync event quests ids with internal database and remove duplicates and
	-- Set already completed events checking questID (internal database)
	for eventID, eventInfo in pairs (RSEventDB.GetAllInternalEventInfo()) do
		if (eventInfo.questID) then
			RSEventDB.RemoveEventQuestIdFound(eventID)
			for _, questID in ipairs(eventInfo.questID) do
				if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSEventDB.IsEventCompleted(eventID)) then
					RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El Evento[%s] no esta marcado como completado, pero su mision (BD addon) esta completada", eventID))
          -- The Event will be tagged as completed as usual, it won't be until the next world quest reset
          -- when the RespawnTracker will decide if this event is completed forever
					RareScanner:ProcessCompletedEvent(eventID, true)
					break
				end
			end
		end
	end
	
	-- Set already completed events checking questID (local database)
	for eventID, questsID in pairs (RSEventDB.GetAllEventQuestIdsFound()) do
		for _, questID in ipairs(questsID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSEventDB.IsEventCompleted(eventID)) then
				RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El Evento[%s] no esta marcado como completado, pero su mision (BD capturada) esta completada", eventID))
				-- The Event will be tagged as completed as usual, it won't be until the next world quest reset
        -- when the RespawnTracker will decide if this event is completed forever
				RareScanner:ProcessCompletedEvent(eventID, true)
				break
			end
		end
	end
	
	-- Sync container quests ids with internal database and remove duplicates and
	-- Set already opened containers checking questID (internal database)
	for containerID, containerInfo in pairs (RSContainerDB.GetAllInternalContainerInfo()) do
		if (containerInfo.questID) then
			RSContainerDB.RemoveContainerQuestIdFound(containerID)
			for _, questID in ipairs(containerInfo.questID) do
				if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSContainerDB.IsContainerOpened(containerID)) then
					RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El Contenedor[%s] no esta marcado como cerrado, pero su mision (BD addon) esta completada", containerID))
					-- The Container will be tagged as opened as usual, it won't be until the next world quest reset
          -- when the RespawnTracker will decide if this container is opened forever
					RareScanner:ProcessOpenContainer(containerID, true)
					break
				end
			end
		end
	end
	
	-- Set already completed events checking questID (local database)
	for containerID, questsID in pairs (RSContainerDB.GetAllContainerQuestIdsFound()) do
		for _, questID in ipairs(questsID) do
			if (C_QuestLog.IsQuestFlaggedCompleted(questID) and not RSContainerDB.IsContainerOpened(containerID)) then
				RSLogger:PrintDebugMessage(string.format("RefreshDatabaseData. El Contenedor[%s] no esta marcado como cerrado, pero su mision (BD capturada) esta completada", containerID))
        -- The Container will be tagged as opened as usual, it won't be until the next world quest reset
        -- when the RespawnTracker will decide if this container is opened forever
				RareScanner:ProcessOpenContainer(containerID, true)
				break
			end
		end
	end
	
	-- Clear previous overlay if active when closed the game
	RSGeneralDB.RemoveOverlayActive()
end

local function UpdateRareNamesDB()
	RSGeneralDB.AddDbVersion(RSConstants.CURRENT_DB_VERSION)
	
	local ITERATIONS = 3
	local current_iteration = 0
	
	-- The addon read the names from the NPCs tooltips
	-- This process doesn't respond always the firs time
	-- so we call the process 3 times to be sure
	local ticker = C_Timer.NewTicker(1, function()
		for npcID, _ in pairs(RSNpcDB.GetAllInternalNpcInfo()) do
			RSNpcDB.GetNpcName(npcID);
		end
		current_iteration = current_iteration + 1
		
		if (current_iteration == ITERATIONS) then					
			RefreshDatabaseData();
		end
	end, ITERATIONS);
end

function RareScanner:InitializeDataBase()
	--============================================
	-- Initialize default profiles
	--============================================
	
	-- Initialize zone filter list
	for k, v in pairs(private.CONTINENT_ZONE_IDS) do 
		table.foreach(v.zones, function(index, zoneID)
			RSConstants.PROFILE_DEFAULTS.profile.general.filteredZones[zoneID] = true
		end)
	end
	
	-- Initialize loot filter list
	for categoryID, subcategories in pairs(private.ITEM_CLASSES) do 
		table.foreach(subcategories, function(index, subcategoryID)
			if (not RSConstants.PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID]) then
				RSConstants.PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID] = {}
			end
			
			RSConstants.PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID][subcategoryID] = true
		end)
	end
	
	--============================================
	-- Initialize database
	--============================================
	
	self.db = LibStub("AceDB-3.0"):New("RareScannerDB", RSConstants.PROFILE_DEFAULTS)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshOptions")
	private.db = self.db.profile
	private.dbchar = self.db.char
	private.dbglobal = self.db.global
		
	-- Initialize char database
	RSGeneralDB.InitCompletedQuestDB()
	RSNpcDB.InitNpcKilledDB()
	RSContainerDB.InitContainerOpenedDB()
	RSEventDB.InitEventCompletedDB()
	
	-- Initialize global database
	RSGeneralDB.InitItemInfoDB()
	RSGeneralDB.InitAlreadyFoundEntitiesDB()
	RSGeneralDB.InitRecentlySeenDB()
	RSGeneralDB.InitDbVersionDB()
	RSNpcDB.InitNpcNamesDB()
	RSNpcDB.InitNpcLootFoundDB()
	RSNpcDB.InitNpcQuestIdFoundDB()
	RSContainerDB.InitContainerNamesDB()
	RSContainerDB.InitContainerLootFoundDB()
	RSContainerDB.InitContainerQuestIdFoundDB()
	RSContainerDB.InitReseteableContainersDB()
	RSEventDB.InitEventNamesDB()
	RSEventDB.InitEventQuestIdFoundDB()
	
	-- Check if rare NPC names database is updated
	local currentDbVersion = RSGeneralDB.GetDbVersion()
	local databaseUpdated = currentDbVersion and currentDbVersion.version == RSConstants.CURRENT_DB_VERSION
	if (not databaseUpdated) then
		UpdateRareNamesDB(); -- Internally calls to RefreshDatabaseData once its done
	else
		RefreshDatabaseData()
	end
end

function RareScanner:GetOptionsTable()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db, RSConstants.PROFILE_DEFAULTS)
end

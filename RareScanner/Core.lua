-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):NewAddon("RareScanner")

local ADDON_NAME, private = ...
RareScanner.GARRISON_CACHE_IDS = { 236916, 237191, 237724, 237722, 237723, 237720 }
RareScanner.NPC_VIGNETTE = "VignetteKill"
RareScanner.NPC_VIGNETTE_ELITE = "VignetteKillElite"
RareScanner.NPC_LEGION_VIGNETTE = "DemonInvasion5"
RareScanner.CONTAINER_VIGNETTE = "VignetteLoot"
RareScanner.CONTAINER_ELITE_VIGNETTE = "VignetteLootElite"
RareScanner.EVENT_VIGNETTE = "VignetteEvent"
RareScanner.EVENT_ELITE_VIGNETTE = "VignetteEventElite"
local RESCAN_TIMER = 120; -- 2 minutes to rescan for the same NPC

-- Timers
local CLEAN_RARES_FOUND_TIMER
local CLEAN_RARES_FOUND_DELAY = 120
local DEFAULT_RAID_NOTICE_TIME = 3

-- Constants
local ETERNAL_DEATH = -1
local ETERNAL_COLLECTED = -1
local ETERNAL_COMPLETED = -1

-- Debug
local DEBUG_MODE = false

-- Config constants
local CURRENT_DB_VERSION = 8
local CURRENT_LOOT_DB_VERSION = 23

-- Hard reset versions
local CURRENT_ADDON_VERSION = 600
local HARD_RESET = {
	[500] = true
}

-- Command line input
SLASH_RARESCANNER_CMD1 = "/rarescanner"
local CMD_HELP = "help"
local CMD_SHOW = "show"
local CMD_HIDE = "hide"
local CMD_TOGGLE = "toggle"
local CMD_TOGGLE_RARES = "rares"
local CMD_TOGGLE_EVENTS = "events"
local CMD_TOGGLE_TREASURES = "treasures"
local CMD_TOGGLE_RARES_SHORT = "tr"
local CMD_TOGGLE_EVENTS_SHORT = "te"
local CMD_TOGGLE_TREASURES_SHORT = "tt"

-- Textures
local NORMAL_NEXT_ARROW_TEXTURE = "Interface\\AddOns\\RareScanner\\Media\\Icons\\RightArrowBlue.blp"
local HIGHLIGHT_NEXT_ARROW_TEXTURE = "Interface\\AddOns\\RareScanner\\Media\\Icons\\RightArrowYellow.blp"
local NORMAL_BACK_ARROW_TEXTURE = "Interface\\AddOns\\RareScanner\\Media\\Icons\\LeftArrowBlue.blp"
local HIGHLIGHT_BACK_ARROW_TEXTURE = "Interface\\AddOns\\RareScanner\\Media\\Icons\\LeftArrowYellow.blp"

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Settings
local PROFILE_DEFAULTS = {
	profile = {
		general = {
			scanRares = true,
			scanContainers = true,
			scanEvents = true,
			scanChatAlerts = true,
			scanGarrison = false,
			scanInstances = true,
			scanOnTaxi = true,
			filteredRares = {},
			filteredZones = {},
			enableTomtomSupport = false,
			showMaker = true,
			marker = 8
		},
		sound = {
			soundPlayed = "Horn",
			soundObjectPlayed = "PVP Horde",
			soundDisabled = false,
			soundVolume = 4
		},
		display = {
			displayButton = true,
			displayMiniature = true,
			displayButtonContainers = true,
			scale = 0.85,
			autoHideButton = 0,
			displayRaidWarning = true,
			displayChatMessage = true,
			displayLogWindow = false,
			autoHideLogWindow = 0,
			enableNavigation = true,
			navigationLockEntity = false
		},
		rareFilters = {
			filtersToggled = true,
			filterOnlyMap = false
			
		},
		zoneFilters = {
			filtersToggled = true,
			filterOnlyMap = false
		},
		map = {
			displayNpcIcons = false,
			displayContainerIcons = false,
			displayEventIcons = true,
			disableLastSeenFilter = false,
			displayNotDiscoveredMapIcons = true,
			displayOldNotDiscoveredMapIcons = false,
			keepShowingAfterDead = false,
			keepShowingAfterDeadReseteable = false,
			keepShowingAfterCollected = false,
			keepShowingAfterCompleted = false,
			maxSeenTime = 0,
			maxSeenTimeContainer = 5,
			maxSeenTimeEvent = 5,
			scale = 1.0
		},
		loot = {
			filteredLootCategories = {},
			displayLoot = true,
			displayLootOnMap = true,
			lootTooltipPosition = "ANCHOR_LEFT",
			lootMinQuality = 0,
			filterNotEquipableItems = false,
			showOnlyTransmogItems = false,
			filterCollectedItems = true,
			filterItemsCompletedQuest = true,
			filterNotMatchingClass = false,
			numItems = 10,
			numItemsPerRow = 10
		}
	}
}

-- Main button
local scanner_button = _G.CreateFrame("Button", "scanner_button", nil, "SecureActionButtonTemplate")
scanner_button:Hide();
scanner_button:SetFrameStrata("MEDIUM")
scanner_button:SetSize(200, 50)
scanner_button:SetScale(0.85)
scanner_button:SetAttribute("type", "macro")
scanner_button:SetNormalTexture([[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal-Desaturated]])
scanner_button:SetBackdrop({ tile = true, edgeSize = 16, edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]] })
scanner_button:SetBackdropBorderColor(0, 0, 0)
scanner_button:SetPoint("BOTTOM", UIParent, 0, 128)
scanner_button:SetMovable(true)
scanner_button:SetUserPlaced(true)
scanner_button:SetClampedToScreen(true)
scanner_button:RegisterForDrag("LeftButton")

scanner_button:SetScript("OnDragStart", scanner_button.StartMoving)
scanner_button:SetScript("OnDragStop",function(self)
	self:StopMovingOrSizing()
	private.dbchar.scannerXPos = self:GetLeft()
	private.dbchar.scannerYPos = self:GetBottom()
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
scanner_button.ModelView = _G.CreateFrame("PlayerModel", "mxpplayermodel", scanner_button)
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
scanner_button.CloseButton = _G.CreateFrame("Button", "CloseButton", scanner_button, "UIPanelCloseButton")
scanner_button.CloseButton:SetPoint("BOTTOMRIGHT")
scanner_button.CloseButton:SetSize(32, 32)
scanner_button.CloseButton:SetScale(0.8)
scanner_button.CloseButton:SetHitRectInsets(8, 8, 8, 8)

-- Filter disabled button
scanner_button.FilterDisabledButton = _G.CreateFrame("Button", "FilterDisabledButton", scanner_button, "GameMenuButtonTemplate")
scanner_button.FilterDisabledButton:SetPoint("BOTTOMLEFT", 5, 5)
scanner_button.FilterDisabledButton:SetSize(16, 16)
scanner_button.FilterDisabledButton:SetNormalTexture([[Interface\WorldMap\Dash_64]])
scanner_button.FilterDisabledButton:SetScript("OnClick", function(self)
	npcID = self:GetParent().npcID
	if (npcID) then
		private.db.general.filteredRares[npcID] = false
		RareScanner:PrintMessage(AL["DISABLED_SEARCHING_RARE"]..self:GetParent().Title:GetText())
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
scanner_button.FilterEnabledButton = _G.CreateFrame("Button", "FilterEnabledButton", scanner_button, "GameMenuButtonTemplate")
scanner_button.FilterEnabledButton:SetPoint("BOTTOMLEFT", 5, 5)
scanner_button.FilterEnabledButton:SetSize(16, 16)
scanner_button.FilterEnabledButton:SetScript("OnClick", function(self)
	npcID = self:GetParent().npcID
	if (npcID) then
		private.db.general.filteredRares[npcID] = true
		RareScanner:PrintMessage(AL["ENABLED_SEARCHING_RARE"]..self:GetParent().Title:GetText())
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
scanner_button.LootBar = _G.CreateFrame("Frame", "LootBar", scanner_button)
scanner_button.LootBar.itemFramesPool = _G.CreateFramePool("FRAME", scanner_button.LootBar, "RSLootTemplate");
scanner_button.LootBar.LootBarToolTip = _G.CreateFrame("GameTooltip", "LootBarToolTip", scanner_button, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp1 = _G.CreateFrame("GameTooltip", "LootBarToolTipComp1", nil, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp1:SetScale(0.8)
scanner_button.LootBar.LootBarToolTipComp2 = _G.CreateFrame("GameTooltip", "LootBarToolTipComp2", nil, "GameTooltipTemplate")
scanner_button.LootBar.LootBarToolTipComp2:SetScale(0.8)
scanner_button.LootBar.LootBarToolTip.shoppingTooltips = { scanner_button.LootBar.LootBarToolTipComp1, scanner_button.LootBar.LootBarToolTipComp2 }

-- Show navigation buttons
scanner_button.NextButton = _G.CreateFrame("Frame", "NextButton", scanner_button, "RSRightNavTemplate")
scanner_button.NextButton:Hide()
scanner_button.PreviousButton = _G.CreateFrame("Frame", "PreviousButton", scanner_button, "RSLeftNavTemplate")
scanner_button.PreviousButton:Hide()

-- Player login
scanner_button:RegisterEvent("PLAYER_LOGIN")

-- Vignette events
scanner_button:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")

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
scanner_button:SetScript("OnEvent", function(self, event, ...)
	-- Playe login
	if (event == "PLAYER_LOGIN") then
		if (private.dbchar.scannerXPos and private.dbchar.scannerYPos) then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT",private.dbchar.scannerXPos,private.dbchar.scannerYPos)
		end
	-- Vignette info
	elseif (event == "VIGNETTE_MINIMAP_UPDATED") then
		-- Get viggnette data
		local id = ...
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo(id)
		if (not vignetteInfo) then
			return
		else
			vignetteInfo.id = id
			self:CheckNotificationCache(self, vignetteInfo)
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
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
		if (eventType == "PARTY_KILL") then
			local _, _, _, _, _, id = strsplit("-", destGUID)
			local npcID = id and tonumber(id) or nil
			RareScanner:ProcessKill(npcID)
		elseif (eventType == "UNIT_DIED") then
			-- It needs to find the target dead in order to mark it as dead, otherwise it could be a fake
			local _, _, _, _, _, id = strsplit("-", destGUID)
			local npcID = id and tonumber(id) or nil
			if (npcID and private.dbglobal.rares_found[npcID] and not private.dbchar.rares_killed[npcID]) then
				if (UnitExists("target") and destGUID == UnitGUID("target")) then
					local unitClassification = UnitClassification("target")
					if (unitClassification ~= "rare" and unitClassification ~= "rareelite") then
						-- properly killed
						--RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC raro muerto por medio de UNIT_DIED")
						RareScanner:ProcessKill(npcID)
					else
						--RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC muerto por medio de UNIT_DIED que no hemos matado nosotros")
					end
				end
			end
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		if (UnitExists("target")) then
			local targetUid = UnitGUID("target")
			local unitClassification = UnitClassification("target")
			local _, _, _, _, _, id = strsplit("-", targetUid)
			local npcID = id and tonumber(id) or nil
			
			-- check if rare but no viggnette
			if (npcID and not private.dbglobal.rares_found[npcID] and private.ZONE_IDS[npcID]) then
				local npcInfo = private.ZONE_IDS[npcID]
				if (npcInfo.zoneID ~= 0) then
					RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC raro que no tiene viggnete y que vamos a volcar a rares_found desde nuestra base de datos ZONE_IDS.")
					private.dbglobal.rares_found[npcID] = { mapID = npcInfo.zoneID, artID = npcInfo.artID or C_Map.GetMapArtID(npcInfo.zoneID), coordX = npcInfo.x, coordY = npcInfo.y, atlasName = RareScanner.NPC_VIGNETTE, foundTime = time() }
				else
					RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC raro que no tiene viggnete y que vamos a calcular sus datos para guardarlo en rares_found")
					RareScanner:PrintDebugMessage("DEBUG: NPCID "..npcID)
					RareScanner:PrintDebugMessage("DEBUG: ZONA "..C_Map.GetBestMapForUnit("player"))
					RareScanner:PrintDebugMessage("DEBUG: COORDS "..C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY())
					local playerCoordX, playerCoordY = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
					local playerMapID = C_Map.GetBestMapForUnit("player")
					if (playerMapID and playerMapID ~= 0) then
						private.dbglobal.rares_found[npcID] = { mapID = playerMapID, artID = C_Map.GetMapArtID(playerMapID), coordX = playerCoordX, coordY = playerCoordY, atlasName = RareScanner.NPC_VIGNETTE, foundTime = time() }
					end
				end
			end
			-- check if killed
			if (npcID and private.dbglobal.rares_found[npcID] and not private.dbchar.rares_killed[npcID]) then
				if (unitClassification ~= "rare" and unitClassification ~= "rareelite") then
					-- properly killed
					--RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC raro muerto porque ha dejado de ser raro en algun momento de la historia y nos habiamos enterado.")
					RareScanner:ProcessKill(npcID)
				else
					--RareScanner:PrintDebugMessage("DEBUG: Identificado un NPC raro muerto que sigue siendo raro, por lo tanto no lo hemos debido de matar nosotros.")
					private.dbglobal.rares_found[npcID].foundTime = time()
				end
			-- Debug tools
			elseif (npcID and not private.dbglobal.rares_found[npcID] and DEBUG_MODE) then
				local npcInfo = private.ZONE_IDS[npcID]
				if (npcInfo and npcInfo.zoneID == 0) then
					if (not private.dbglobal.missing_rares) then
						private.dbglobal.missing_rares = {}
					end
					print("|cFFDC143C[RareScanner]: |cFFDC143CDEBUG: ENCONTRADO RARO QUE NO TENIAMOS LOCALIZADO, AUNQUE NO PRESENTA UN VIGNETTE.")
					print("|cFFDC143C[RareScanner]: |cFFDC143CDEBUG: NPCID "..npcID)
					print("|cFFDC143C[RareScanner]: |cFFDC143CDEBUG: ZONA "..C_Map.GetBestMapForUnit("player"))
					print("|cFFDC143C[RareScanner]: |cFFDC143CDEBUG: COORDS "..C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY())
					local xx, yy = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
					private.dbglobal.missing_rares[npcID] = { zoneID = C_Map.GetBestMapForUnit("player"), x = xx, y = yy }
				elseif (npcInfo and npcInfo.zoneID ~= 0 and npcInfo.x and npcInfo.y) then
					-- Add it to rares_found
					private.dbglobal.rares_found[npcID] = { mapID = npcInfo.zoneID, artID = npcInfo.artID or C_Map.GetMapArtID(npcInfo.zoneID) , coordX = npcInfo.x, coordY = npcInfo.y, atlasName = RareScanner.NPC_VIGNETTE, foundTime = time() }
				end
			end
			
			-- if (npcID and private.dbglobal.rares_found[npcID] and DEBUG_MODE) then
				-- StaticPopupDialogs["UPDATE_COORDS"] = {
					-- text = "¿Quieres actualizar las coordenadas?",
					-- button1 = "Si",
					-- button2 = "No",
					-- OnAccept = function()
						-- local xx, yy = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
						-- private.dbglobal.rares_found[npcID].coordX = xx
						-- private.dbglobal.rares_found[npcID].coordY = yy
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
		
		for i = 1, numItems do
			if (LootSlotHasItem(i)) then
				local destGUID = GetLootSourceInfo(i)
				local _, _, _, _, _, id = strsplit("-", destGUID)
				local npcID = id and tonumber(id) or nil
				
				if (not npcID) then
					return
				end
				
				if (private.dbglobal.rares_found[npcID] or RS_tContains(private.CONTAINER_LIST, npcID)) then
					if (not private.dbglobal.rares_loot[npcID]) then
						private.dbglobal.rares_loot[npcID] = {}
					end
					
					-- If its a cointainer check it as opened
					if (RS_tContains(private.CONTAINER_LIST, npcID) or private.dbglobal.rares_found[npcID].atlasName == RareScanner.CONTAINER_VIGNETTE or private.dbglobal.rares_found[npcID].atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE) then
						RareScanner:ProcessOpenContainer(npcID)
					end
					
					-- If its in the container list but we dont have its position
					if (RS_tContains(private.CONTAINER_LIST, npcID) and not private.dbglobal.rares_found[npcID]) then
						RareScanner:PrintDebugMessage("DEBUG: Detectado contenedor que tenemos en base de datos pero no tiene vignette "..npcID.. ". Añadido a la lista de rares_found.")
						if (private.CONTAINER_ZONE_IDS[npcID]) then
							private.dbglobal.rares_found[npcID] = { artID = C_Map.GetMapArtID(private.CONTAINER_ZONE_IDS[npcID].zoneID), mapID = private.CONTAINER_ZONE_IDS[npcID].zoneID, coordX = private.CONTAINER_ZONE_IDS[npcID].x, coordY = private.CONTAINER_ZONE_IDS[npcID].y, atlasName = RareScanner.CONTAINER_VIGNETTE, foundTime = time() }
						else
							local xx, yy = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
							private.dbglobal.rares_found[npcID] = { artID = C_Map.GetMapArtID(C_Map.GetBestMapForUnit("player")), mapID = C_Map.GetBestMapForUnit("player"), coordX = xx, coordY = yy, atlasName = RareScanner.CONTAINER_VIGNETTE, foundTime = time() }
						end
					end
					
					local itemLink = GetLootSlotLink(i)
					if (itemLink) then
						local _, _, _, ltype, id, _, _, _, _, _, _, _, _, _, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
						if (ltype == "item") then
							local itemID = id and tonumber(id) or nil
							if (itemID and (not private.dbglobal.rares_loot[npcID] or not RS_tContains(private.dbglobal.rares_loot[npcID], itemID)) and (not private.LOOT_TABLE_IDS[npcID] or not RS_tContains(private.LOOT_TABLE_IDS[npcID], itemID))) then
								RareScanner:PrintDebugMessage("DEBUG: Añadido nuevo botin "..itemID.." para el NPC/contenedor "..npcID)
								tinsert(private.dbglobal.rares_loot[npcID], itemID)
							end
						end
					end
				else
					-- if (DEBUG_MODE) then
						-- StaticPopupDialogs["RS_CHECK_NEW"] = {
							-- text = "¿Quieres procesar el NPC/contenedor que acabas de localizar?",
							-- button1 = "Si",
							-- button2 = "No",
							-- OnAccept = function()
								-- -- Emulate vignette found
								-- if (not private.dbglobal.rares_found[npcID]) then
									-- RareScanner:PrintDebugMessage("DEBUG: Detectado contenedor que tenemos en base de datos pero no tiene vignette "..npcID.. ". Añadido a la lista de rares_found.")
									-- if (private.CONTAINER_ZONE_IDS[npcID]) then
										-- private.dbglobal.rares_found[npcID] = { artID = C_Map.GetMapArtID(private.CONTAINER_ZONE_IDS[npcID].zoneID), mapID = private.CONTAINER_ZONE_IDS[npcID].zoneID, coordX = private.CONTAINER_ZONE_IDS[npcID].x, coordY = private.CONTAINER_ZONE_IDS[npcID].y, atlasName = RareScanner.CONTAINER_VIGNETTE, foundTime = time() }
									-- else
										-- local xx, yy = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
										-- private.dbglobal.rares_found[npcID] = { artID = C_Map.GetMapArtID(C_Map.GetBestMapForUnit("player")), mapID = C_Map.GetBestMapForUnit("player"), coordX = xx, coordY = yy, atlasName = RareScanner.CONTAINER_VIGNETTE, foundTime = time() }
									-- end
								-- end
								
								-- -- If its a cointainer check it as opened
								-- if (private.dbglobal.rares_found[npcID].atlasName == RareScanner.CONTAINER_VIGNETTE or private.dbglobal.rares_found[npcID].atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE) then
									-- RareScanner:ProcessOpenContainer(npcID)
								-- end
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
									
						-- RareScanner:PrintDebugMessage("DEBUG: Obtenido loot de "..destGUID)
						-- local itemLink = GetLootSlotLink(i)
						-- if (itemLink) then
							-- local _, _, _, ltype, id, _, _, _, _, _, _, _, _, _, name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
							-- if (ltype == "item") then
								-- local itemID = id and tonumber(id) or nil
								-- if (itemID and (not private.dbglobal.temp_loot[npcID] or not RS_tContains(private.dbglobal.temp_loot[npcID], itemID)) and (not private.LOOT_TABLE_IDS[npcID] or not RS_tContains(private.LOOT_TABLE_IDS[npcID], itemID))) then
									-- RareScanner:PrintDebugMessage("DEBUG: Añadido nuevo botin "..itemID.." para el npcID "..npcID)
									-- if (not private.dbglobal.temp_loot[npcID]) then
										-- private.dbglobal.temp_loot[npcID] = {}
									-- end
									-- tinsert(private.dbglobal.temp_loot[npcID], itemID)
								-- end
							-- end
						-- end
					-- end
				end
			end
		end
	-- Chat
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
		-- If not disabled
		if (not private.db.general.scanChatAlerts) then
			return
		end
		
		-- Only for Mechagon (lets don't support everywhere yet to see its performance)
		local currentMap = C_Map.GetBestMapForUnit("player")
		if (currentMap and currentMap == 1462) then
			local message, name = ...
			if (name) then
				local npcID = RareScanner:GetNpcId(name)
				-- Arachnoid Harvester fix
				if (npcID and npcID == 154342) then
					npcID = 151934
				end
				
				-- The Scrap King fix
				if ((npcID == 151623 or npcID == 151625) and (private.dbchar.rares_killed[151623] or private.dbchar.rares_killed[151625])) then
					return
				end
				
				-- Simulates vignette event
				if (npcID and private.ZONE_IDS[npcID] and not private.dbchar.rares_killed[npcID]) then
					local vignetteInfo = {}
					vignetteInfo.atlasName = RareScanner.NPC_VIGNETTE
					vignetteInfo.id = "NPC"..npcID
					vignetteInfo.name = name
					vignetteInfo.objectGUID = "a-a-a-a-a-"..npcID.."-a"
					vignetteInfo.x = private.ZONE_IDS[npcID].x
					vignetteInfo.y = private.ZONE_IDS[npcID].y
					self:CheckNotificationCache(self, vignetteInfo)
				end
			end
		end
	elseif (event == "CHAT_MSG_MONSTER_EMOTE") then
		-- If not disabled
		if (not private.db.general.scanChatAlerts) then
			return
		end
		
		-- Only for Mechagon Construction Projects
		local currentMap = C_Map.GetBestMapForUnit("player")
		if (currentMap and currentMap == 1462) then
			local message, name = ...
			for k, npcID in pairs(private.CONSTRUCTION_PROJECTS) do
				if (RS_tContains(message, k)) then
					-- Simulates vignette event
					if (npcID and private.ZONE_IDS[npcID] and not private.dbchar.rares_killed[npcID]) then
						local vignetteInfo = {}
						vignetteInfo.atlasName = RareScanner.NPC_VIGNETTE
						vignetteInfo.id = "NPC"..npcID
						vignetteInfo.name = RareScanner:GetNpcName(npcID)
						vignetteInfo.objectGUID = "a-a-a-a-a-"..npcID.."-a"
						vignetteInfo.x = private.ZONE_IDS[npcID].x
						vignetteInfo.y = private.ZONE_IDS[npcID].y
						self:CheckNotificationCache(self, vignetteInfo)
					end
					
					return
				end
			end
		end
	-- Quests
	elseif (event == "QUEST_TURNED_IN") then
		local questID, xpReward, moneyReward = ...
		private.dbchar.quests_completed[questID] = true
		RareScanner:PrintDebugMessage("DEBUG: Mision completada "..questID)	
		
		-- Checks if its an event
		local foundDebug = false
		for npcID, questsID in pairs (private.EVENT_QUEST_IDS) do
			if (RS_tContains(questsID, questID)) then
				RareScanner:ProcessCompletedEvent(npcID)
				foundDebug = true
				return	
			end
		end
		
		if (DEBUG_MODE and not foundDebug) then
			RareScanner:PrintDebugMessage("DEBUG: Mision completada que no existe en EVENT_QUEST_IDS "..questID)
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

function RareScanner:ProcessKill(npcID, forzed)
	-- Mark as killed
	if (npcID and private.dbglobal.rares_found[npcID] and private.ZONE_IDS[npcID]) then
		-- If the npc belongs to several zones we have to use the players zone
		if (type(private.ZONE_IDS[npcID].zoneID) == "table") then
			local playerZoneID = C_Map.GetBestMapForUnit("player")
			if (not playerZoneID) then
				return
			end
			
			for zoneID, zoneInfo in pairs (private.ZONE_IDS[npcID].zoneID) do
				if (playerZoneID == zoneID) then
					RareScanner:ProcessKillByZone(npcID, zoneID)
					break
				end
			end
		else
			RareScanner:ProcessKillByZone(npcID, private.ZONE_IDS[npcID].zoneID)
		end
		
		-- Extracts quest id if we don't have it
		-- Avoids shift-left-click events
		if (not forzed) then
			if (not private.QUEST_IDS[npcID] and not private.dbglobal.quest_ids[npcID]) then
				C_Timer.After(5, function() 
					RareScanner:PrintDebugMessage("Buscando quest id...")
					local newQuests = {}
					local newQuests = GetQuestsCompleted(newQuests)
					local newQuestIds = {}
					local alreadyFound = false
					for k, v in pairs (newQuests) do
						if (not private.dbchar.quests_completed[k]) then
							private.dbchar.quests_completed[k] = true
							
							-- Checks if the quest has a title, in which case is a wrong one
							-- Sometimes the first call to GetQuestsCompleted doesn't return anything, 
							-- so here we could have every single completed quest
							local questText, _, _ = GetQuestObjectiveInfo(k, 0, true)
							if (not alreadyFound and not questText) then
								table.insert(newQuestIds, k)
								RareScanner:PrintDebugMessage("Se ha detectado que el rare matado con ID "..npcID.." esta asociado a la mision "..k)
								alreadyFound = true
							else
								RareScanner:PrintDebugMessage("ERROR. No se ha encontrado una coincidencia segura para el ID "..npcID)
								newQuestIds = {}
							end
						end
					end
					
					if (next(newQuestIds) ~= nil) then
						private.dbglobal.quest_ids[npcID] = newQuestIds
					end
				end)
			elseif (private.QUEST_IDS[npcID] or private.dbglobal.quest_ids[npcID]) then
				RareScanner:PrintDebugMessage("Se ha detectado que ya disponemos de questID para el rare matado con ID "..npcID)
			end
		end
	-- Mark as killed (ignored NPC)
	elseif (npcID and private.ZONE_IDS[npcID]) then
		-- If its a world quest reseteable rare
		if (private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], C_Map.GetMapArtID(private.ZONE_IDS[npcID].zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado con ID "..npcID.." pertenece a una zona reseteable con las misiones del mundo")
			private.dbchar.rares_killed[npcID] = time() + GetQuestResetTime()
		-- If its a warfront reseteable rare
		elseif (private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID] and RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], "all") or RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], C_Map.GetMapArtID(private.ZONE_IDS[npcID].zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado con ID "..npcID.." pertenece a una zona reseteable cada 2 semanas")
			private.dbchar.rares_killed[npcID] = RareScanner:GetWarFrontResetTime()
		-- If it wont ever be a rare anymore
		elseif (private.PERMANENT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID], C_Map.GetMapArtID(private.ZONE_IDS[npcID].zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado deja de ser rare eternamente")
			private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
		end
	-- Just in case we dont have this element in our zone ids (some vignettes with wrong names or double vignette)
	-- We can ignore this ones
	elseif (npcID) then
		private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
	end
end

function RareScanner:ProcessKillByZone(npcID, zoneID)
	-- If its a world quest reseteable rare
	if ((private.RESETABLE_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID)))
		or (private.RESETABLE_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], C_Map.GetMapArtID(private.dbglobal.rares_found[npcID].mapID)))) then
		RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado con ID "..npcID.." pertenece a una zona reseteable con las misiones del mundo")
		private.dbchar.rares_killed[npcID] = time() + GetQuestResetTime()
	-- If its a warfront reseteable rare
	elseif ((private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID)))
		or (private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID] and RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], "all") or RS_tContains(private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], C_Map.GetMapArtID(private.dbglobal.rares_found[npcID].mapID)))) then
		RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado con ID "..npcID.." pertenece a una zona reseteable cada 2 semanas")
		private.dbchar.rares_killed[npcID] = RareScanner:GetWarFrontResetTime()
	-- If it wont ever be a rare anymore
	elseif ((private.PERMANENT_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID)))
		or (private.PERMANENT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[private.dbglobal.rares_found[npcID].mapID], C_Map.GetMapArtID(private.dbglobal.rares_found[npcID].mapID)))) then
		RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado deja de ser rare eternamente")
		private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
	-- If it respawns after a while we dont need to keep track of death
	else
		RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el rare matado con ID "..npcID.." pertenece a una zona donde permanece siendo rare")
	end
	
	if (private.dbglobal.recentlySeen[npcID]) then
		private.dbglobal.recentlySeen[npcID] = nil
	end
end

function RareScanner:ProcessOpenContainer(npcID)
	-- Mark as opened
	if (npcID and private.dbglobal.rares_found[npcID]) then
		local zoneID = private.dbglobal.rares_found[npcID].mapID
			
		-- if its part of an achievement it won't come back
		local opened = false;
		if (private.ACHIEVEMENT_ZONE_IDS[zoneID]) then
			for i, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[zoneID]) do
				for j, ID in ipairs(private.ACHIEVEMENT_TARGET_IDS[achievementID]) do
					if (ID == npcID) then
						private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
						opened = true;
						break;
					end
				end
			end
		end
		
		if (opened) then
			return
		end
		
		-- some containers have special timers
		if (private.CONTAINER_TIMER[npcID]) then
			if (private.CONTAINER_TIMER[npcID] == -1) then
				private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
			else
				private.dbchar.containers_opened[npcID] = time() + private.CONTAINER_TIMER[npcID]
			end
		-- If its a container that belong to a place with reseteable rares/containers
		elseif (private.RESETABLE_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID)) or (private.dbglobal.containers_reseteable and private.dbglobal.containers_reseteable[npcID])) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el contenedor abierto con ID "..npcID.." pertenece a una zona reseteable con las misiones del mundo")
			private.dbchar.containers_opened[npcID] = time() + GetQuestResetTime()
		-- If it disapears once its opened
		elseif (private.PERMANENT_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el contenedor abierto no se puede volver a abrir")
			private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
		end
		-- Otherwise let it be
	-- Mark as opened (ignored container)
	elseif (npcID) then
		-- If its a container that belong to a place with reseteable rares/containers
		local zoneID = C_Map.GetBestMapForUnit("player")
		if (private.RESETABLE_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID)) or (private.dbglobal.containers_reseteable and private.dbglobal.containers_reseteable[npcID])) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el contenedor abierto con ID "..npcID.." pertenece a una zona reseteable con las misiones del mundo")
			private.dbchar.containers_opened[npcID] = time() + GetQuestResetTime()
		-- If it disapears once its opened
		elseif (private.PERMANENT_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el contenedor abierto no se puede volver a abrir")
			private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
		end
	end
end

function RareScanner:ProcessCompletedEvent(npcID)
	if (npcID) then
		-- If its a container that belong to a place with reseteable rares/containers
		local zoneID = C_Map.GetBestMapForUnit("player")
		if (private.RESETABLE_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.RESETABLE_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el evento completado con ID "..npcID.." pertenece a una zona reseteable con las misiones del mundo")
			private.dbchar.events_completed[npcID] = time() + GetQuestResetTime()
		-- If it disapears once its opened
		elseif (private.PERMANENT_KILLS_ZONE_IDS[zoneID] and RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[zoneID], C_Map.GetMapArtID(zoneID))) then
			RareScanner:PrintDebugMessage("DEBUG: Se ha detectado que el evento completado no se puede completar otra vez")
			private.dbchar.events_completed[npcID] = ETERNAL_COMPLETED
		end
	end
end

-- Checks if the rare has been found already in the last 5 minutes
local already_notified = {}
function scanner_button:CheckNotificationCache(self, vignetteInfo, isNavigating)
	local zone_id = C_Map.GetBestMapForUnit("player")
	
	-- In Uldum and Valley of eternal Blossoms the icon for elite NPC is used for events
	if (zone_id and vignetteInfo.atlasName == RareScanner.NPC_VIGNETTE_ELITE and (zone_id == 1530 or zone_id == 1527)) then
		vignetteInfo.atlasName = RareScanner.EVENT_VIGNETTE
	end
	
	local iconid = vignetteInfo.atlasName	
	local name = vignetteInfo.name
	local _, _, _, _, _, npcID, _ = strsplit("-", vignetteInfo.objectGUID);
	
	if (npcID) then
		npcID = tonumber(npcID)
		
		if (not isNavigating) then
			if (vignetteInfo.x and vignetteInfo.y) then
				local coordinates = {}
				coordinates.x = vignetteInfo.x
				coordinates.y = vignetteInfo.y
				RareScanner:UpdateRareFound(npcID, vignetteInfo, coordinates)
			else
				RareScanner:UpdateRareFound(npcID, vignetteInfo)
			end
			
			-- If we have it as dead but we got a notification it means that the restart time is wrong (this happends mostly with war fronts)
			if (private.dbchar.rares_killed[npcID]) then
				RareScanner:PrintDebugMessage("DEBUG: Detectado rare como muerto en base de datos, pero que hemos encontrado al pasar cerca de el")
				private.dbchar.rares_killed[npcID] = nil
			end
		end
	end
	
	-- Options disabled/enabled
	if (iconid) then
		local isInstance, instanceType = IsInInstance()
		
		-- disable ALL alerts while cinematic is playing
		if (isCinematicPlaying) then
			return
		-- disable ALL alerts in instances
		elseif (isInstance == true and not private.db.general.scanInstances) then
			return
		-- disable alerts while flying
		elseif (UnitOnTaxi("player") and not private.db.general.scanOnTaxi) then
			return
		-- disable every iconid that is not treasure, event or rare
		elseif (iconid ~= RareScanner.CONTAINER_VIGNETTE and iconid ~= RareScanner.CONTAINER_ELITE_VIGNETTE and iconid ~= RareScanner.NPC_VIGNETTE and iconid ~= RareScanner.NPC_VIGNETTE_ELITE and iconid ~= RareScanner.EVENT_ELITE_VIGNETTE and iconid ~= RareScanner.EVENT_VIGNETTE and iconid ~= RareScanner.NPC_LEGION_VIGNETTE) then
			return
		-- disable ALL alerts for containers
		elseif ((iconid == RareScanner.CONTAINER_VIGNETTE or iconid == RareScanner.CONTAINER_ELITE_VIGNETTE) and not private.db.general.scanContainers) then
			return
		-- disable alerts for rares NPCs
		elseif ((iconid == RareScanner.NPC_VIGNETTE or iconid == RareScanner.NPC_LEGION_VIGNETTE or iconid == RareScanner.NPC_VIGNETTE_ELITE) and not private.db.general.scanRares) then
			return
		-- disable alerts for events
		elseif ((iconid == RareScanner.EVENT_VIGNETTE or iconid == RareScanner.EVENT_ELITE_VIGNETTE) and not private.db.general.scanEvents) then
			return
		-- disable zones alerts if the player is in that zone
		elseif (not private.db.zoneFilters.filterOnlyMap and next(private.db.general.filteredZones) ~= nil and private.db.general.filteredZones[zone_id] == false) then
			return
		-- disable alerts for containers
		elseif (iconid == RareScanner.CONTAINER_VIGNETTE or iconid == RareScanner.CONTAINER_ELITE_VIGNETTE) then
			-- save object name just in case we need it in the future
			RareScanner:SetObjectName(npcID, name)
			
			-- disable garrison container alert
			if (not private.db.general.scanGarrison) then
				-- check if the container is the garrison cache
				if (RS_tContains(RareScanner.GARRISON_CACHE_IDS, npcID)) then
					RareScanner:PrintDebugMessage("DEBUG: Detectado cofre de la ciudadela filtrado")
					return
				end
			end
			
			-- disable button alert for containers
			if (not private.db.display.displayButtonContainers) then
				-- sets recently seen
				private.dbglobal.recentlySeen[npcID] = true
				
				-- If navigation disabled, control Tomtom waypoint externally
				if (not private.db.display.enableNavigation) then
					RareScanner:AddTomtomWaypoint(vignetteInfo)
				end
	
				if (already_notified[vignetteInfo.id]) then
					return
				else
					already_notified[vignetteInfo.id] = true
					
					-- flashes the wow icon in windows bar
					FlashClientIcon()
					self:PlaySoundAlert(iconid)
					self:DisplayMessages(name)
					return
				end
			end
			
			-- some containers belong to places where rares die forever
			-- and anyway, this containers can respawn every day
			-- so if this is the case, mark it as an exception
			if (private.dbchar.containers_opened[npcID] and private.dbchar.containers_opened[npcID] == ETERNAL_COLLECTED) then
				if (not private.dbglobal.containers_reseteable) then
					private.dbglobal.containers_reseteable = {}
				end
				
				RareScanner:PrintDebugMessage("DEBUG: Detectado un cofre que estaba marcado como que no se puede volver a abrir, y sin embargo nos lo hemos vuelto a encontrar")
				private.dbglobal.containers_reseteable[npcID] = true
				private.dbchar.containers_opened[npcID] = nil
			end
			
		-- saves event name
		elseif (iconid == RareScanner.EVENT_VIGNETTE or iconid == RareScanner.EVENT_ELITE_VIGNETTE) then
			-- check just in case its an NPC
			if (not RareScanner:GetNpcName(npcID)) then
				RareScanner:SetEventName(npcID, name)
			end
		end
	else
		return
	end
	
	-- Check if we have found the NPC in the last 5 minutes
	if (not isNavigating) then
		-- FIX Blubbery Blobule (NPCID = 160841) multipoping
		if (already_notified[vignetteInfo.id] or (npcID == 160841 and already_notified[160841])) then
			return
		else
			already_notified[vignetteInfo.id] = true
			if (npcID == 160841) then
				already_notified[160841] = true
			end
		end
	end

	-- Filters NPC by zone just in case it belong to a different are from the current player's position
	if (npcID and RareScanner:ZoneFiltered(npcID)) then
		return
	end
	
	-- Check if the NPC is filtered, in which case we don't show anything
	if (npcID and not private.db.rareFilters.filterOnlyMap and next(private.db.general.filteredRares) ~= nil and private.db.general.filteredRares[npcID] == false) then
		return
	end
	
	---------------------------------------
	-- log previous button if it was a NPC
	---------------------------------------
	if (self.npcID and self.npcID ~= npcID and not isNavigating) then
		RareScanner:RegisterPreviousButton(self.npcID, self.name, self.iconid)
	end
	
	--------------------------------
	-- show messages and play alarm
	--------------------------------
	if (not isNavigating) then
		self:DisplayMessages(name)
		self:PlaySoundAlert(iconid)
	end
	
	------------------------
	-- set up new button
	------------------------
	if (private.db.display.displayButton) then
		-- Adds the new NPCID to the navigation list
		if (private.db.display.enableNavigation and not isNavigating) then
			self.NextButton:AddNext(vignetteInfo)
		end
		
		-- Show the button
		if (not self:IsShown() or isNavigating or not private.db.display.enableNavigation or not private.db.display.navigationLockEntity) then		
			self.npcID = npcID
			self.name = name
			self.iconid = iconid
			
			-- If NPC identified properly load its model
			if (npcID) then			
				local displayID = private.NPC_DISPLAY_IDS[npcID]
				if (displayID and displayID ~= 0) then
					self.displayID = displayID
				else
					self.displayID = nil
				end
			else
				self.displayID = nil
			end
			
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
		elseif (private.db.display.enableNavigation and private.db.display.navigationLockEntity) then
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
	if (not private.db.display.enableNavigation) then
		RareScanner:AddTomtomWaypoint(vignetteInfo)
	end
	
	-- sets recently seen
	private.dbglobal.recentlySeen[npcID] = true

	-- timer to reset already found NPC
	C_Timer.After(RESCAN_TIMER, function() 
		already_notified[vignetteInfo.id] = false
		-- FIX Blubbery Blobule (NPCID = 160841) multipoping
		if (npcID == 160841) then
			already_notified[160841] = false
		end
		private.dbglobal.recentlySeen[npcID] = nil
	end)
end

function RareScanner:UpdateRareFound(npcID, vignetteInfo, coordinates)
	local currentMap
	
	-- If its a NPC
	if (vignetteInfo.atlasName == RareScanner.NPC_VIGNETTE or vignetteInfo.atlasName == RareScanner.NPC_LEGION_VIGNETTE or vignetteInfo.atlasName == RareScanner.NPC_VIGNETTE_ELITE) then
		vignetteInfo.atlasName = RareScanner.NPC_VIGNETTE
	
		-- Extracts zoneID from database that its more accurate
		if (private.ZONE_IDS[npcID] and type(private.ZONE_IDS[npcID].zoneID) == "number" and private.ZONE_IDS[npcID].zoneID ~= 0) then
			currentMap = private.ZONE_IDS[npcID].zoneID
		-- If it shows up in different places, be sure that we got a good one
		elseif (private.ZONE_IDS[npcID] and type(private.ZONE_IDS[npcID].zoneID) == "table") then
			local playerCurrentMap = C_Map.GetBestMapForUnit("player")
			for zoneID, zoneInfo in pairs (private.ZONE_IDS[npcID].zoneID) do
				if (zoneID == playerCurrentMap) then
					currentMap = playerCurrentMap
					break
				end
			end
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	-- If its a container
	elseif (vignetteInfo.atlasName == RareScanner.CONTAINER_VIGNETTE or vignetteInfo.atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE) then 
		vignetteInfo.atlasName = RareScanner.CONTAINER_VIGNETTE
		
		-- Extracts zoneID from database that its more accurate
		if (private.CONTAINER_ZONE_IDS[npcID]) then
			currentMap = private.CONTAINER_ZONE_IDS[npcID].zoneID
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	-- If its an event
	elseif (vignetteInfo.atlasName == RareScanner.EVENT_VIGNETTE or vignetteInfo.atlasName == RareScanner.EVENT_ELITE_VIGNETTE) then 
		vignetteInfo.atlasName = RareScanner.EVENT_VIGNETTE
		
		-- Extracts zoneID from database that its more accurate
		if (private.EVENT_ZONE_IDS[npcID]) then
			currentMap = private.EVENT_ZONE_IDS[npcID].zoneID
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	end
	
	-- Ignore if incorrect mapID
	if (not currentMap or currentMap == 0) then
		return
	end

	local vignettePosition = nil
	if (coordinates and coordinates.x and coordinates.y) then
		vignettePosition = coordinates
	else
		vignettePosition = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, currentMap)
	end
	
	if (not vignettePosition) then
		return
	end
	
	local mapX = vignettePosition.x
	local mapY = vignettePosition.y
	local atlas = vignetteInfo.atlasName
	local art = C_Map.GetMapArtID(currentMap)
	
	-- If its already in our database, just update the timestamp and the new position
	if (private.dbglobal.rares_found[npcID]) then
		private.dbglobal.rares_found[npcID].foundTime = time()
		private.dbglobal.rares_found[npcID].coordX = mapX
		private.dbglobal.rares_found[npcID].coordY = mapY
		private.dbglobal.rares_found[npcID].mapID = currentMap
		private.dbglobal.rares_found[npcID].artID = art
		private.dbglobal.rares_found[npcID].atlasName = atlas
			
		RareScanner:PrintDebugMessage("DEBUG: Detectado NPC que ya habiamos localizado, se actualiza la fecha y sus coordenadas")
	else	
		private.dbglobal.rares_found[npcID] = { mapID = currentMap, coordX = mapX, coordY = mapY, atlasName = atlas, artID = art, foundTime = time() }
		RareScanner:PrintDebugMessage("DEBUG: Guardado en private.dbglobal.rares_found (ID: "..npcID.." MAPID: "..currentMap.." COORDX: "..mapX.." COORDY: "..mapY.." TIMESTAMP: "..time().." ATLASNAME: "..atlas.." ARTID: "..art)
	end
end

function RareScanner:ZoneFiltered(npcID)
	if (not private.ZONE_IDS[npcID] and not private.CONTAINER_ZONE_IDS[npcID] and not private.EVENT_ZONE_IDS[npcID]) then
		RareScanner:PrintDebugMessage("DEBUG: Se ha detectado un NPC sin zona asignada "..npcID)
		return false
	end
	if (next(private.db.general.filteredZones) ~= nil) then
		-- If npc
		if (private.ZONE_IDS[npcID]) then
			-- if the npc shows up in more than one place
			if (type(private.ZONE_IDS[npcID].zoneID) == "table") then
				local found = false;
				for i, v in ipairs(private.ZONE_IDS[npcID].zoneID) do
					if (private.db.general.filteredZones[v] == false) then
						found = true;
						break;
					end
				end
				
				if (found) then
					return true
				end
			-- if the npc shows up only in one place
			elseif (private.db.general.filteredZones[private.ZONE_IDS[npcID].zoneID] == false) then
				return true
			end
		-- If container
		elseif (private.CONTAINER_ZONE_IDS[npcID] and private.db.general.filteredZones[private.CONTAINER_ZONE_IDS[npcID].zoneID] == false) then
			return true
		-- If event
		elseif (private.EVENT_ZONE_IDS[npcID] and private.db.general.filteredZones[private.EVENT_ZONE_IDS[npcID].zoneID] == false) then
			return true
		end
	end
	
	return false
end

function scanner_button:PlaySoundAlert(iconid)
	if (not private.db.sound.soundDisabled) then
		if (iconid == RareScanner.CONTAINER_VIGNETTE or iconid == RareScanner.EVENT_VIGNETTE or iconid == RareScanner.CONTAINER_ELITE_VIGNETTE or iconid == RareScanner.EVENT_ELITE_VIGNETTE) then
			--PlaySoundFile(string.gsub(private.SOUNDS[private.db.sound.soundObjectPlayed], "-4", "-"..private.db.sound.soundVolume), "Master")
            PlaySound(private.SOUNDS[private.db.sound.soundObjectPlayed], "Master", false)
		else
			--PlaySoundFile(string.gsub(private.SOUNDS[private.db.sound.soundPlayed], "-4", "-"..private.db.sound.soundVolume), "Master")
            PlaySound(private.SOUNDS[private.db.sound.soundPlayed], "Master", false)
		end
	end
end

function scanner_button:DisplayMessages(name)
	if (name) then
		if (private.db.display.displayRaidWarning) then
			RaidNotice_AddMessage(RaidWarningFrame, string.format(AL["JUST_SPAWNED"], name), ChatTypeInfo["RAID_WARNING"], DEFAULT_RAID_NOTICE_TIME)
		end
		
		-- Print message in chat if user wants
		if (private.db.display.displayChatMessage) then
			RareScanner:PrintMessage(string.format(AL["JUST_SPAWNED"], name))
		end
	else
		if (private.db.display.displayRaidWarning) then
			RaidNotice_AddMessage(RaidWarningFrame, AL["ALARM_MESSAGE"], ChatTypeInfo["RAID_WARNING"], DEFAULT_RAID_NOTICE_TIME)
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
	self:SetScale(private.db.display.scale)

	-- Sets the name
	self.Title:SetText(self.name)
			
	-- show loot bar
	if (private.db.loot.displayLoot) then
		self:LoadLootBar()
		-- call a second time just in case the game took
		-- too long to fetch their data and they rendered 
		-- acuardly
		C_Timer.After(2, function() 
			self:LoadLootBar()
		end)
	end
	
	-- show navigation arrows
	if (private.db.display.enableNavigation) then
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
	if (self.npcID and (self.iconid == RareScanner.NPC_VIGNETTE or self.iconid == RareScanner.NPC_LEGION_VIGNETTE or self.iconid == RareScanner.NPC_VIGNETTE_ELITE)) then
		self.Description_text:SetText(AL["CLICK_TARGET"])
		
		if (private.db.general.showMaker) then
			self:SetAttribute("macrotext", "/cleartarget\n/targetexact "..self.name.."\n/tm "..private.db.general.marker)
		else
			self:SetAttribute("macrotext", "/cleartarget\n/targetexact "..self.name)
		end
		
		-- show button
		self:Show()
	
		-- show model
		if (self.displayID and private.db.display.displayMiniature) then
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
		
		-- hide model if displayed
		self:SetAttribute("macrotext", private.macrotext)
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

	-- Extract NPC loot
	if (self.npcID) then
		local itemIDs = RareScanner:GetNpcLoot(self.npcID)

		if (itemIDs) then
			local numItems = private.db.loot.numItems
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
end

function RareScanner:GetNpcLoot(npcID)
	local itemIDs
	if (private.LOOT_TABLE_IDS[npcID]) then
		itemIDs = private.LOOT_TABLE_IDS[npcID]
		if (private.dbglobal.rares_loot[npcID]) then
			for _,v in ipairs(private.dbglobal.rares_loot[npcID]) do 
				if (not RS_tContains(itemIDs, v)) then
					table.insert(itemIDs, v)
				end
			end
		end
	elseif (private.dbglobal.rares_loot[npcID]) then
		itemIDs = private.dbglobal.rares_loot[npcID]
	end
	
	return itemIDs
end

function scanner_button:StartHideTimer()
	if (private.db.display.autoHideButton ~= 0) then
		if (AUTOHIDING_TIMER) then
			AUTOHIDING_TIMER:Cancel()
		end
		AUTOHIDING_TIMER = C_Timer.NewTimer(private.db.display.autoHideButton, function() 
			RareScanner:RegisterPreviousButton(scanner_button.npcID, scanner_button.name, scanner_button.iconid)
			scanner_button:HideButton() 
		end)
	end
end

function RareScanner:RefreshRaresFoundList()
	if (not private.dbglobal.rares_found) then
		private.dbglobal.rares_found = {}
	end
	
	-- resets killed timer
	for k, v in pairs (private.dbchar.rares_killed) do
		if (v and v ~= ETERNAL_DEATH and v < time()) then
			private.dbchar.rares_killed[k] = nil
		end
	end
	
	-- resets opened timer
	for k, v in pairs (private.dbchar.containers_opened) do
		if (v and v ~= ETERNAL_COLLECTED and v < time()) then
			private.dbchar.containers_opened[k] = nil
		end
	end
	
	-- resets completed timer
	for k, v in pairs (private.dbchar.events_completed) do
		if (v and v ~= ETERNAL_COMPLETED and v < time()) then
			private.dbchar.events_completed[k] = nil
		end
	end
	
	if (not CLEAN_RARES_FOUND_TIMER) then
		CLEAN_RARES_FOUND_TIMER = C_Timer.NewTicker(CLEAN_RARES_FOUND_DELAY, function() 
			RareScanner:RefreshRaresFoundList()
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
	scanner_button.iconid = RareScanner.NPC_VIGNETTE
	scanner_button.Title:SetText(npcTestName)
	scanner_button:DisplayMessages(npcTestName)
	scanner_button:PlaySoundAlert(RareScanner.NPC_VIGNETTE)
	scanner_button.Description_text:SetText(AL["CLICK_TARGET"])
	
	if (not InCombatLockdown()) then	
		scanner_button:ShowButton()
		scanner_button.FilterDisabledButton:Hide()
	end
	
	RareScanner:PrintMessage("test launched")
end

----------------------------------------------
-- Loading addon methods
----------------------------------------------
function RareScanner:OnInitialize() 	
	-- Init database
	self:InitializeDataBase()
	
	-- Initialize setup panels
	self:SetupOptions()
	
	-- Setup our map provider
	WorldMapFrame:AddDataProvider(CreateFromMixins(RareScannerDataProviderMixin));
	
	-- Internal not discovered lists
	self:LoadNotDiscoveredLists()
	
	-- Adds new menu to world map
	RareScanner:HookDropDownMenu()
	
	-- Load completed quests
	RareScanner:LoadCompletedQuestTracking()

	--self:PrintMessage("loaded")
end

function RareScanner:InitializeDataBase()
	-- Initialize zone filter list
	for k, v in pairs(private.CONTINENT_ZONE_IDS) do 
		table.foreach(v.zones, function(index, zoneID)
			PROFILE_DEFAULTS.profile.general.filteredZones[zoneID] = true
		end)
	end
	
	-- Initialize loot filter list
	for categoryID, subcategories in pairs(private.ITEM_CLASSES) do 
		table.foreach(subcategories, function(index, subcategoryID)
			if (not PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID]) then
				PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID] = {}
			end
			
			PROFILE_DEFAULTS.profile.loot.filteredLootCategories[categoryID][subcategoryID] = true
		end)
	end
	
	-- Initialize database
	self.db = LibStub("AceDB-3.0"):New("RareScannerDB", PROFILE_DEFAULTS)
	
	-- Reset entire database
	if (not self.db.global.addonVersion or (self.db.global.addonVersion ~= CURRENT_ADDON_VERSION and HARD_RESET[CURRENT_ADDON_VERSION])) then
		self.db:ResetDB()
		self.db.global.addonVersion = CURRENT_ADDON_VERSION
		self:PrintMessage(AL["DATABASE_HARD_RESET"])
		
		-- Reload database
		RareScanner:InitializeDataBase()	
	-- Loads normally database
	else
		self.db.RegisterCallback(self, "OnProfileChanged", "RefreshOptions")
		self.db.RegisterCallback(self, "OnProfileCopied", "RefreshOptions")
		self.db.RegisterCallback(self, "OnProfileReset", "RefreshOptions")
		private.db = self.db.profile
		private.dbchar = self.db.char
		private.dbglobal = self.db.global
		
		-- Initialize char database
		if (not private.dbchar.rares_killed) then
			private.dbchar.rares_killed = {}
		end
		
		if (not private.dbchar.containers_opened) then
			private.dbchar.containers_opened = {}
		end
		
		if (not private.dbchar.events_completed) then
			private.dbchar.events_completed = {}
		end
		
		if (not private.dbglobal.quest_ids) then
			private.dbglobal.quest_ids = {}
		end
		
		-- Initialize global database
		if (not private.dbglobal.rares_found) then
			private.dbglobal.rares_found = {}
		end
		
		if (not private.dbglobal.rares_loot) then
			private.dbglobal.rares_loot = {}
		end
		
		-- Initialize recently seen (resets previous values)
		private.dbglobal.recentlySeen = {}
	  
		-- Adds about panel to wow options
		local about_panel = LibStub:GetLibrary("LibAboutPanel", true)
		if (about_panel) then
			self.optionsFrame = about_panel.new(nil, "RareScanner")
		end
		
		-- Refresh rare sharing variables
		self:RefreshRaresFoundList()
		
		-- Cache names and initialize filter list
		if (not private.dbglobal.dbversion) then
			private.dbglobal.dbversion = {}
			self:LoadRareNames(self.db)
		else
			local dbversionFound = false
			for i, dbversion in ipairs(private.dbglobal.dbversion) do
				if (dbversion.locale == GetLocale() and dbversion.version == CURRENT_DB_VERSION) then
					dbversionFound = true
					break;
				end
			end

			if (not dbversionFound) then
				self:LoadRareNames(self.db)
			else
				-- Initialize rare filter list
				for k, v in pairs(private.dbglobal.rare_names[GetLocale()]) do 
					PROFILE_DEFAULTS.profile.general.filteredRares[k] = true
				end

				self:PrintDebugMessage("DEBUG: Base de datos actualizada...")
				self.db:RegisterDefaults(PROFILE_DEFAULTS)
			end
		end
		
		-- Sync loot found with internal database and clear mistakes
		if (not private.dbglobal.lootdbversion or private.dbglobal.lootdbversion < CURRENT_LOOT_DB_VERSION) then
			private.dbglobal.lootdbversion = CURRENT_LOOT_DB_VERSION
			self:DumpRepeatedLoot()
		end
		
		-- Sync quests ids with internal database and remove duplicates
		for npcID, questsID in pairs (private.QUEST_IDS) do
			if (questsID) then
				if (private.dbglobal.quest_ids[npcID]) then
					private.dbglobal.quest_ids[npcID] = nil
				end
				for i, questID in ipairs (questsID) do
					-- Set already killed NPCs checking quest id (internal database)
					if (IsQuestFlaggedCompleted(questID) and not private.dbchar.rares_killed[npcID]) then
						self:ProcessKill(npcID, true)
					end
				end
			end
		end
		
		-- Set already killed NPCs checking quest id (local database)
		for npcID, questsID in pairs (private.dbglobal.quest_ids) do
			for i, questID in ipairs(questsID) do
				if (IsQuestFlaggedCompleted(questID) and not private.dbchar.rares_killed[npcID]) then
					self:ProcessKill(npcID, true)
				end
			end
		end
		
		-- Set already completed EVENTS checking quest id
		for npcID, questsID in pairs (private.EVENT_QUEST_IDS) do
			for i, questID in ipairs(questsID) do
				if (IsQuestFlaggedCompleted(questID) and not private.dbchar.events_completed[npcID]) then
					self:ProcessCompletedEvent(npcID)
				end
			end
		end
		
		-- Fix possible errors in database
		self:DumpBrokenData()
	end
end

function RareScanner:DumpBrokenData()
	if (private.dbglobal.rares_found and next(private.dbglobal.rares_found) ~= nil) then
		for npcID, npcInfo in pairs(private.dbglobal.rares_found) do
			-- Delete rare NPCs without map or coordinates
			if (not npcInfo.mapID or npcInfo.mapID == 0 or not npcInfo.coordY or not npcInfo.coordX) then
				private.dbglobal.rares_found[npcID] = nil
			end
		end
	end
	
	if (private.dbchar.rares_killed and next(private.dbchar.rares_killed) ~= nil) then
		for npcID, timestamp in pairs(private.dbchar.rares_killed) do
			-- If the NPC belongs to Mechagon or Nazjatar and its set as eternal death, reset it
			if (timestamp == ETERNAL_DEATH and private.ZONE_IDS[npcID] and (private.ZONE_IDS[npcID].zoneID == 1462 or private.ZONE_IDS[npcID].zoneID == 1355)) then
				private.dbchar.rares_killed[npcID] = nil
			end
		end
	end
	
	if (private.dbchar.events_completed and next(private.dbchar.events_completed) ~= nil) then
		for npcID, timestamp in pairs(private.dbchar.events_completed) do
			-- If the NPC belongs to Mechagon or Nazjatar and its set as eternal death, reset it
			if (timestamp == ETERNAL_COMPLETED and private.ZONE_IDS[npcID] and (private.ZONE_IDS[npcID].zoneID == 1462 or private.ZONE_IDS[npcID].zoneID == 1355)) then
				private.dbchar.events_completed[npcID] = nil
			end
		end
	end
end

function RareScanner:DumpRepeatedLoot()
	-- With version 13 we disabled loot sharing
	-- It seems some loot was being spoofed producing errors
	if (CURRENT_LOOT_DB_VERSION == 13) then
		private.dbglobal.rares_loot = {}
	else
		if (private.dbglobal.rares_loot and next(private.dbglobal.rares_loot) ~= nil) then
			for npcID, items in pairs(private.dbglobal.rares_loot) do
				local cleanItemsList = {}
				
				if (private.LOOT_TABLE_IDS[npcID]) then
					for _, itemID in ipairs(items) do
						if (not RS_tContains(private.LOOT_TABLE_IDS[npcID], itemID) and not RS_tContains(cleanItemsList, itemID)) then
							table.insert(cleanItemsList, itemID)
						end
					end
				elseif (private.dbglobal.rares_loot[npcID]) then
					for _, itemID in ipairs(items) do
						if (not RS_tContains(cleanItemsList, itemID)) then
							table.insert(cleanItemsList, itemID)
						end
					end
				end
				
				if (next(cleanItemsList) ~= nil) then
					private.dbglobal.rares_loot[npcID] = cleanItemsList
				else
					private.dbglobal.rares_loot[npcID] = nil
				end
			end
		end
	end
end

function RareScanner:MarkCompletedAchievements()
	for achievementID, entities in pairs(private.ACHIEVEMENT_TARGET_IDS) do
		local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(achievementID)
		if (completed and wasEarnedByMe) then
			for i, npcID in ipairs(entities) do
				if (private.ZONE_IDS[npcID] and not private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID] and not private.dbchar.rares_killed[npcID]) then
					private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
				elseif (private.CONTAINER_ZONE_IDS[npcID] and not private.dbchar.containers_opened[npcID]) then
					private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
				elseif (private.EVENT_ZONE_IDS[npcID] and not private.dbchar.events_completed[npcID]) then
					private.dbchar.events_completed[npcID] = ETERNAL_COMPLETED
				end
			end
		elseif (not completed) then
			local numCriteria = GetAchievementNumCriteria(achievementID);
			if (numCriteria > 0) then
				for criteriaIndex = 1, numCriteria do
					local criteriaString, _, criteriaCompleted, _, _, _, _, npcID, _, _, _, _, _ = GetAchievementCriteriaInfo(achievementID, criteriaIndex);
					if (criteriaCompleted) then
						if (private.ZONE_IDS[npcID] and not private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID] and not private.dbchar.rares_killed[npcID]) then
							private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
						elseif (private.CONTAINER_ZONE_IDS[npcID] and not private.dbchar.containers_opened[npcID]) then
							private.dbchar.containers_opened[npcID] = ETERNAL_COLLECTED
						elseif (private.EVENT_ZONE_IDS[npcID] and not private.dbchar.events_completed[npcID]) then
							private.dbchar.events_completed[npcID] = ETERNAL_COMPLETED
						else
							for npcID, name in pairs (private.dbglobal.rare_names[GetLocale()]) do
								if (RS_tContains(name, criteriaString) and private.ZONE_IDS[npcID] and not private.RESETABLE_KILLS_ZONE_IDS[private.ZONE_IDS[npcID].zoneID]) then
									private.dbchar.rares_killed[npcID] = ETERNAL_DEATH
									break
								end
							end
						end
					end
				end
			end
		end
	end
	
	RareScanner:PrintMessage(AL["SYNCRONIZATION_COMPLETED"])
end

function RareScanner:LoadNotDiscoveredList(originList, destinyList)
	for k, v in pairs (originList) do
		-- if the entity has a list of zones associated
		if (v.zoneID and type(v.zoneID) == "table") then
			for zoneID, zoneInfo in pairs (v.zoneID) do
				if (not private.dbglobal.rares_found[k] and (not private.dbglobal.rares_not_discovered_ignored or not private.dbglobal.rares_not_discovered_ignored[k])) then
					if (not destinyList[zoneID]) then
						destinyList[zoneID] = {}
					end
					
					destinyList[zoneID][k] = {}
					destinyList[zoneID][k].x = zoneInfo.x
					destinyList[zoneID][k].y = zoneInfo.y
				end
			end
		else
			if (v.zoneID ~= 0 and v.x and v.y and not private.dbglobal.rares_found[k] and (not private.dbglobal.rares_not_discovered_ignored or not private.dbglobal.rares_not_discovered_ignored[k])) then
				if (not destinyList[v.zoneID]) then
					destinyList[v.zoneID] = {}
				end
				
				destinyList[v.zoneID][k] = {}
				destinyList[v.zoneID][k].x = v.x
				destinyList[v.zoneID][k].y = v.y
			end
		end
	end
end

function RareScanner:LoadNotDiscoveredLists()
	private.RARES_NOT_DISCOVERED = {}
	self:LoadNotDiscoveredList(private.ZONE_IDS, private.RARES_NOT_DISCOVERED)
	
	private.CONTAINERS_NOT_DISCOVERED = {}
	self:LoadNotDiscoveredList(private.CONTAINER_ZONE_IDS, private.CONTAINERS_NOT_DISCOVERED)
	
	private.EVENTS_NOT_DISCOVERED = {}
	self:LoadNotDiscoveredList(private.EVENT_ZONE_IDS, private.EVENTS_NOT_DISCOVERED)
end

function RareScanner:LoadCompletedQuestTracking()
	private.dbchar.quests_completed = GetQuestsCompleted(private.dbchar.quests_completed)
	C_Timer.After(60, function() 
		RareScanner:LoadCompletedQuestTracking()
	end)
end

function RareScanner:LoadRareNames(db)
	if (not private.dbglobal.rare_names) then
		private.dbglobal.rare_names = {}
	end
	
	self:PrintDebugMessage("DEBUG: No existe una base de datos de nombres actualizada para el idioma "..GetLocale()..". Actualizando datos...")
	local localeFound = false
	for i, dbversion in ipairs(private.dbglobal.dbversion) do
		if (dbversion.locale == GetLocale()) then
			dbversion.version = CURRENT_DB_VERSION
			localeFound = true
			break;
		end
	end

	if (not localeFound) then
		tinsert(private.dbglobal.dbversion, { locale = GetLocale(), version = CURRENT_DB_VERSION })
	end

	private.dbglobal.rare_names[GetLocale()] = {}
	
	local ITERATIONS = 5
	current_iteration = 0
	local ticker = C_Timer.NewTicker(1, function()
		for i, npcID in ipairs(private.RARE_LIST) do
			RareScanner:GetNpcName(npcID);
		end
		current_iteration = current_iteration + 1
		
		if (current_iteration == ITERATIONS) then					
			-- Initialize rare filter list
			for k, v in pairs(private.dbglobal.rare_names[GetLocale()]) do 
				PROFILE_DEFAULTS.profile.general.filteredRares[k] = true
			end

			RareScanner:PrintDebugMessage("DEBUG: Base de datos actualizada...")
			db:RegisterDefaults(PROFILE_DEFAULTS)
			
			-- Mark as killed or collected achievement entities
			-- We might need the rare names, so we have to do it here
			self:MarkCompletedAchievements()
		end
	end, ITERATIONS);
end

SlashCmdList["RARESCANNER_CMD"] = function(msg)
	local command, entity = strsplit(" ", msg)
	if (command == CMD_SHOW) then
		RareScanner:CmdShow()	
	elseif (command == CMD_HIDE) then
		RareScanner:CmdHide()
	elseif (command == CMD_TOGGLE) then
		if (not entity) then
			if (not private.db.map.cmdToggle) then
				RareScanner:CmdHide()
				private.db.map.cmdToggle = true
			else
				RareScanner:CmdShow()
				private.db.map.cmdToggle = false
			end
		elseif (entity == CMD_TOGGLE_RARES) then
			RareScanner:CmdToggleRares()
		elseif (entity == CMD_TOGGLE_EVENTS) then
			RareScanner:CmdToggleEvents()
		elseif (entity == CMD_TOGGLE_TREASURES) then
			RareScanner:CmdToggleTreasures()
		end
	elseif (command == CMD_TOGGLE_RARES_SHORT) then
		RareScanner:CmdToggleRares()
	elseif (command == CMD_TOGGLE_EVENTS_SHORT) then
		RareScanner:CmdToggleEvents()
	elseif (command == CMD_TOGGLE_TREASURES_SHORT) then
		RareScanner:CmdToggleTreasures()
	else
		RareScanner:PrintMessage(AL["CMD_HELP1"])
		RareScanner:PrintMessage(AL["CMD_HELP2"])
		RareScanner:PrintMessage(AL["CMD_HELP3"])
		RareScanner:PrintMessage(AL["CMD_HELP4"])
		RareScanner:PrintMessage(AL["CMD_HELP5"])
		RareScanner:PrintMessage(AL["CMD_HELP6"])
		RareScanner:PrintMessage(AL["CMD_HELP7"])
	end
end

function RareScanner:CmdHide()
	private.db.map.displayNpcIcons = false
	private.db.map.displayContainerIcons = false
	private.db.map.displayEventIcons = false
	RareScanner:PrintMessage(AL["CMD_HIDE"])
end

function RareScanner:CmdShow()
	private.db.map.displayNpcIcons = true
	private.db.map.displayContainerIcons = true
	private.db.map.displayEventIcons = true
	RareScanner:PrintMessage(AL["CMD_SHOW"])	
end

function RareScanner:CmdToggleRares()
	if (private.db.map.displayNpcIcons) then
		private.db.map.displayNpcIcons = false
		RareScanner:PrintMessage(AL["CMD_HIDE_RARES"])
	else
		private.db.map.displayNpcIcons = true
		RareScanner:PrintMessage(AL["CMD_SHOW_RARES"])
	end
end

function RareScanner:CmdToggleEvents()
	if (private.db.map.displayEventIcons) then
		private.db.map.displayEventIcons = false
		RareScanner:PrintMessage(AL["CMD_HIDE_EVENTS"])
	else
		private.db.map.displayEventIcons = true
		RareScanner:PrintMessage(AL["CMD_SHOW_EVENTS"])
	end
end

function RareScanner:CmdToggleTreasures()
	if (private.db.map.displayContainerIcons) then
		private.db.map.displayContainerIcons = false
		RareScanner:PrintMessage(AL["CMD_HIDE_TREASURES"])
	else
		private.db.map.displayContainerIcons = true
		RareScanner:PrintMessage(AL["CMD_SHOW_TREASURES"])
	end
end

function RareScanner:PrintMessage(message) 
	print("|cFF00FF00[RareScanner]: |cFFFFFFFF"..message)
end

function RareScanner:PrintDebugMessage(message) 
	if (DEBUG_MODE) then
		print("|cFFDC143C[RareScanner]: |cFFFFFFFF"..tostring(message))
	end
end

function RareScanner:GetOptionsTable()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db, PROFILE_DEFAULTS)
end

function RS_tContains(cTable, item)
	if (not cTable or not item) then
		return false
	end

	if (type(cTable) == "table") then
		for k, v in pairs(cTable) do
			if (type(v) == "table") then
				return RS_tContains(v, item)
			elseif (type(item) == "table") then
				return RS_tContains(item, v)
			elseif (type(v) == "string" and string.find(string.upper(v), string.upper(item))) then
				return true;
			elseif (v == item) then
				return true;
			end
		end
	else
		if (type(item) == "table") then
			return RS_tContains(item, cTable)
		elseif (type(cTable) == "string" and string.find(string.upper(cTable), string.upper(item))) then
			return true;
		elseif (cTable == item) then
			return true;
		end
	end
	
	return false;
end

local QTips = {}

local QUEST_TIMEOUT = 0.3
local function GetQTip()
	local now = GetTime()
	for i, tip in ipairs(QTips) do
		if not tip.npcID or now - tip.lastUpdate > QUEST_TIMEOUT + 0.2 then
			tip.lastUpdate = now
			return tip
		end
	end
	local tip = CreateFrame('GameTooltip',  'SemlarsQTip' .. (#QTips + 1), WorldFrame, 'GameTooltipTemplate')
	tip:Show()
	tip:SetHyperlink('unit:')
	tip.lastUpdate = now
	tinsert(QTips, tip)
	return tip
end

function RareScanner:GetObjectName(objectID)
	if (private.dbglobal.object_names and private.dbglobal.object_names[GetLocale()]) then
		return private.dbglobal.object_names[GetLocale()][objectID]
	end
end

function RareScanner:SetObjectName(objectID, name)
	if (not private.dbglobal.object_names) then
		private.dbglobal.object_names = {}
	end
	if (not private.dbglobal.object_names[GetLocale()]) then
		private.dbglobal.object_names[GetLocale()] = {}
	end
	if (not private.dbglobal.object_names[GetLocale()][objectID]) then
		private.dbglobal.object_names[GetLocale()][objectID] = name
	end
end

function RareScanner:GetEventName(eventID)
	if (private.dbglobal.event_names and private.dbglobal.event_names[GetLocale()]) then
		return private.dbglobal.event_names[GetLocale()][eventID]
	end
end

function RareScanner:SetEventName(eventID, name)
	if (not private.dbglobal.event_names) then
		private.dbglobal.event_names = {}
	end
	if (not private.dbglobal.event_names[GetLocale()]) then
		private.dbglobal.event_names[GetLocale()] = {}
	end
	if (not private.dbglobal.event_names[GetLocale()][eventID]) then
		private.dbglobal.event_names[GetLocale()][eventID] = name
	end
end

function RareScanner:GetNpcId(name) 
	if (private.dbglobal.rare_names[GetLocale()]) then
		for k, v in pairs(private.dbglobal.rare_names[GetLocale()]) do
			if (RS_tContains(v, name)) then
				return k;
			end
		end
	end
end

function RareScanner:GetNpcName(npcID)
	if (private.dbglobal.rare_names[GetLocale()][npcID]) then
		return private.dbglobal.rare_names[GetLocale()][npcID]
	end
	
	local tip = GetQTip()
	tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
	tip.npcID = npcID or 0
	tip:SetScript('OnTooltipSetUnit', function(self) 
		local tipName = self:GetName()
		local name, description = _G[tipName .. 'TextLeft1']:GetText(), _G[tipName ..'TextLeft2']:GetText()
		if name then
			private.dbglobal.rare_names[GetLocale()][self.npcID] = name
		end
		self:SetScript('OnTooltipSetUnit', nil)
		self.npcID = nil
	end)
	tip:SetHyperlink('unit:Creature-0-0-0-0-' .. npcID .. '-0')
end

function RareScanner:GetServerOffset()
	local serverDate = C_Calendar.GetDate()
	local serverDay, serverWeekday, serverMonth, serverMinute, serverHour, serverYear = serverDate.monthDay, serverDate.weekday, serverDate.month, serverDate.minute, serverDate.hour, serverDate.year
	local localDay = tonumber(date("%w")) -- 0-based starts on Sun
	local localHour, localMinute = tonumber(date("%H")), tonumber(date("%M"))
	if (serverDay == (localDay + 1)%7) then -- server is a day ahead
		serverHour = serverHour + 24
	elseif (localDay == (serverDay + 1)%7) then -- local is a day ahead
		localHour = localHour + 24
	end
	
	local server = serverHour + serverMinute / 60
	local localT = localHour + localMinute / 60
	local offset = floor((server - localT) * 2 + 0.5) / 2
	return offset
end

function RareScanner:GetWarFrontResetTime()
	if (not self.resetDays) then
		local regionID = GetCurrentRegion()
		self.resetDays = {}  
		self.resetDays.DLHoffset = 0
		if (regionID == 2 or regionID == 4 or regionID == 5) then --KR, TW, CH
			self.resetDays["4"] = true -- thursday
		elseif (regionID == 3) then --EU
			self.resetDays["3"] = true -- wednesday
		else --US
			self.resetDays["2"] = true -- tuesday
			self.resetDays.DLHoffset = -3
		end
	end
	
	local offset = (self:GetServerOffset() + self.resetDays.DLHoffset) * 3600
	local nightlyReset = time() + GetQuestResetTime()
	while (not self.resetDays[date("%w",nightlyReset+offset)]) do
		nightlyReset = nightlyReset + 24 * 3600
	end

	return nightlyReset + (7 * 24 * 60 * 60) -- every 2 weeks
end

-- Tomtom support
local tomtom_waypoint
function RareScanner:AddTomtomWaypoint(vignetteInfo)
	if (TomTom and private.db.general.enableTomtomSupport and vignetteInfo) then
		local _, _, _, _, _, npcID, _ = strsplit("-", vignetteInfo.objectGUID);
		
		if (npcID) then
			npcID = tonumber(npcID)
		else
			return
		end
		
		if (tomtom_waypoint) then
			TomTom:RemoveWaypoint(tomtom_waypoint)
		end
		local npcInfo = private.dbglobal.rares_found[npcID]
		if (npcInfo and npcInfo.coordX and npcInfo.coordY) then
			tomtom_waypoint = TomTom:AddWaypoint(npcInfo.mapID, tonumber(npcInfo.coordX), tonumber(npcInfo.coordY), {
				title = vignetteInfo.name,                
				persistent = false,
				minimap = false,
				world = false,
				cleardistance = 25
			})
		end
    end
end

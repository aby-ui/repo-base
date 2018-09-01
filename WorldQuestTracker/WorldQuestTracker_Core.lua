

--world quest tracker object
local WorldQuestTracker = WorldQuestTrackerAddon
if (not WorldQuestTracker) then
	return
end

--framework
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00World Quest Tracker: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end

--localization
local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
if (not L) then
	return
end

local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame

local anchorFrame = WorldMapFrame.ScrollContainer
local worldFramePOIs = WorldQuestTrackerWorldMapPOI

local _
local QuestMapFrame_IsQuestWorldQuest = QuestMapFrame_IsQuestWorldQuest or QuestUtils_IsQuestWorldQuest
local GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local GetQuestTagInfo = GetQuestTagInfo
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID
local GetQuestTimeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

local GameCooltip = GameCooltip2

local LibWindow = LibStub ("LibWindow-1.1")
if (not LibWindow) then
	print ("|cFFFFAA00World Quest Tracker|r: libwindow not found, did you just updated the addon? try reopening the client.|r")
end

--on hover over an icon on the world map (possivle deprecated on 8.0)
hooksecurefunc ("TaskPOI_OnEnter", function (self)
	--WorldMapTooltip:AddLine ("quest ID: " .. self.questID)
	--print (self.questID)
	WorldQuestTracker.CurrentHoverQuest = self.questID
	if (self.Texture and self.IsZoneQuestButton) then
		self.Texture:SetBlendMode ("ADD")
	end
end)

--on leave the hover over of an icon in the world map (possivle deprecated on 8.0)
hooksecurefunc ("TaskPOI_OnLeave", function (self)
	WorldQuestTracker.CurrentHoverQuest = nil
	if (self.Texture and self.IsZoneQuestButton) then
		self.Texture:SetBlendMode ("BLEND")
	end
end)

--update the zone which the player are current placed (possivle deprecated on 8.0)
function WorldQuestTracker:UpdateCurrentStandingZone()
	if (WorldMapFrame:IsShown()) then
		return
	end

	if (WorldQuestTracker.ScheduledMapFrameShownCheck and not WorldQuestTracker.ScheduledMapFrameShownCheck._cancelled) then
		WorldQuestTracker.ScheduledMapFrameShownCheck:Cancel()
	end
	
	local mapID = WorldQuestTracker.GetCurrentMapAreaID()	
	if (mapID == 1080 or mapID == 1072) then
		mapID = 1024
	end
	WorldMapFrame.currentStandingZone = mapID
	WorldQuestTracker:FullTrackerUpdate()
end

--i'm not sure what this is for
function WorldQuestTracker:WaitUntilWorldMapIsClose()
	if (WorldQuestTracker.ScheduledMapFrameShownCheck and not WorldQuestTracker.ScheduledMapFrameShownCheck._cancelled) then
		WorldQuestTracker.ScheduledMapFrameShownCheck:Cancel()
	end
	WorldQuestTracker.ScheduledMapFrameShownCheck = C_Timer.NewTicker (1, WorldQuestTracker.UpdateCurrentStandingZone)
end

local check_for_quests_on_unknown_map = function()
	local mapID = WorldMapFrame.mapID
	
	if (not WorldQuestTracker.MapData.WorldQuestZones [mapID] and not WorldQuestTracker.IsWorldQuestHub (mapID)) then
		local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID (mapID, mapID)
		if (taskInfo and #taskInfo > 0) then
			--> there's quests on this map
			--print ("found map with quests", mapID)
			WorldQuestTracker.MapData.WorldQuestZones [mapID] = true
			WorldQuestTracker.OnMapHasChanged (WorldMapFrame)
		end
	end
	
end

WorldQuestTracker.OnMapHasChanged = function (self)
	
	local mapID = WorldMapFrame.mapID
	WorldQuestTracker.InitializeWorldWidgets()
	
	--set the current map in the addon
	WorldQuestTracker.LastMapID = WorldQuestTracker.CurrentMapID
	WorldQuestTracker.CurrentMapID = mapID
	
	--update the status bar
	WorldQuestTracker.RefreshStatusBarVisibility()
	
	--check if quest summary is shown and if can hide it
	if (WorldQuestTracker.QuestSummaryShown and not WorldQuestTracker.CanShowZoneSummaryFrame()) then
		WorldQuestTracker.ClearZoneSummaryButtons()
	end
	
	--> clear custom map pins
	local map = WorldQuestTrackerDataProvider:GetMap()
	for pin in map:EnumeratePinsByTemplate ("WorldQuestTrackerRarePinTemplate") do
		pin.RareWidget:Hide()
		map:RemovePin (pin)
	end
	
	if (not WorldQuestTracker.MapData.WorldQuestZones [mapID] and not WorldQuestTracker.IsWorldQuestHub (mapID)) then
		C_Timer.After (0.5, check_for_quests_on_unknown_map)
	end
	
	if (not WorldQuestTracker.IsWorldQuestHub (mapID)) then
		local map = WorldQuestTrackerDataProvider:GetMap()
		for pin in map:EnumeratePinsByTemplate ("WorldQuestTrackerWorldMapPinTemplate") do
			map:RemovePin (pin)
		end
	end
	
	--is the map a zone map with world quests?
	if (WorldQuestTracker.MapData.WorldQuestZones [mapID]) then
		--hide the toggle world quests button
		if (WorldQuestTrackerToggleQuestsButton) then
			WorldQuestTrackerToggleQuestsButton:Hide()
		end
		
		--update widgets
		WorldQuestTracker.UpdateZoneWidgets (true)
		
		--hide world quest
		if (WorldQuestTracker.WorldMapFrameReference:IsShown()) then
			WorldQuestTracker.HideWorldQuestsOnWorldMap()
		end
	else
		--is zone widgets shown?
		if (WorldQuestTracker.ZoneWidgetPool[1] and WorldQuestTracker.ZoneWidgetPool[1]:IsShown()) then
			--hide zone widgets
			WorldQuestTracker.HideZoneWidgets()
		end
		
		--check if is a hub map
		if (WorldQuestTracker.IsWorldQuestHub (mapID)) then
			--show the toggle world quests button
			if (WorldQuestTrackerToggleQuestsButton) then
				WorldQuestTrackerToggleQuestsButton:Show()
			end
			
			--is there at least one world widget created?
			if (WorldQuestTracker.WorldMapFrameReference) then
				if (not WorldQuestTracker.WorldMapFrameReference:IsShown() or WorldQuestTracker.LatestQuestHub ~= WorldQuestTracker.CurrentMapID) then
					WorldQuestTracker.LatestQuestHub = WorldQuestTracker.CurrentMapID
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				end
				
			end
		else
			--hide zone quest pins
			if (WorldQuestTracker.ZoneWidgetPool[1] and WorldQuestTracker.ZoneWidgetPool[1]:IsShown()) then
				WorldQuestTracker.HideWorldQuestsOnWorldMap()
			end
			
			--hide world quest squares
			if (WorldQuestTracker.WorldMapFrameReference:IsShown()) then
				WorldQuestTracker.HideWorldQuestsOnWorldMap()
			end
		end
	end

end

hooksecurefunc (WorldMapFrame, "OnMapChanged", WorldQuestTracker.OnMapHasChanged)

-- default world quest pins from the map
hooksecurefunc (WorldMap_WorldQuestPinMixin, "RefreshVisuals", function (self)
	if (self.questID) then
		WorldQuestTracker.DefaultWorldQuestPin [self.questID] = self
		
		if (not WorldQuestTracker.ShowDefaultWorldQuestPin [self.questID]) then
			self:Hide()
		end
	end
end)

--OnTick
local OnUpdateDelay = .5
WorldMapFrame:HookScript ("OnUpdate", function (self, deltaTime)

	-- todo: need to get the world map Pins from blizzard
	--[=[
	if (WorldQuestTracker.HideZoneWidgetsOnNextTick and not (WorldQuestTracker.Temp_HideZoneWidgets > GetTime())) then
		for i = 1, #WorldQuestTracker.AllTaskPOIs do
			if (WorldQuestTracker.CurrentZoneQuests [WorldQuestTracker.AllTaskPOIs [i].questID]) then
				WorldQuestTracker.AllTaskPOIs [i]:Hide()
			end
		end
		WorldQuestTracker.HideZoneWidgetsOnNextTick = false
	end
	--]=]
	
	--todo: summary frame need a new anchor location
	--[=[
	if (WorldQuestTracker.CanShowZoneSummaryFrame()) then
		WorldMapFrame.UIElementsFrame.BountyBoard:ClearAllPoints()
		WorldMapFrame.UIElementsFrame.BountyBoard:SetPoint ("bottomright", WorldMapFrame.UIElementsFrame, "bottomright", -18, 15)
	end
	--]=]
	
	--mouse hover over a quest in the summary frame, showing the tooltip
	--todo: check if this still work on 8.0
	--[=[
	if (WorldQuestTracker.HaveZoneSummaryHover) then
		WorldMapTooltip:ClearAllPoints()
		WorldMapTooltip:SetPoint ("bottomleft", WorldQuestTracker.HaveZoneSummaryHover, "bottomright", 2, 0) -- + diff
	end
	--]=]
	
	if (OnUpdateDelay < 0) then
	
		--todo: check if map locker is still viable in 8.0
		--[=[
		if (WorldQuestTracker.db.profile.map_lock and (GetCurrentMapContinent() == 8 or WorldQuestTracker.WorldQuestButton_Click+30 > GetTime())) then
			if (WorldQuestTracker.CanChangeMap) then
				WorldQuestTracker.CanChangeMap = nil
				WorldQuestTracker.LastMapID = WorldQuestTracker.GetCurrentMapAreaID()
			else
				if (WorldQuestTracker.LastMapID ~= WorldQuestTracker.GetCurrentMapAreaID() and WorldQuestTracker.LastMapID and not InCombatLockdown()) then
					WorldMapFrame:NavigateToMap (WorldQuestTracker.LastMapID)
					WorldQuestTracker.UpdateZoneWidgets()
				end
			end
		end
		--]=]
		
		--is there at least one world widget created?
		if (WorldQuestTracker.WorldMapFrameReference) then
			--current map is a quest hub
			if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
				if (not WorldQuestTracker.WorldMapFrameReference:IsShown()) then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				end
			else
				--current map is a zone, check if world widgets are shown
				if (WorldQuestTracker.WorldMapFrameReference:IsShown()) then
					--hide world widgets
					WorldQuestTracker.HideWorldQuestsOnWorldMap()
				end
			end
		end
		
		OnUpdateDelay = .5
	else
		OnUpdateDelay = OnUpdateDelay - deltaTime
	end
end)

-- ?
local currentMap
local deny_auto_switch = function()
	WorldQuestTracker.NoAutoSwitchToWorldMap = true
	currentMap = WorldQuestTracker.GetCurrentMapAreaID()
end

--apos o click, verifica se pode mostrar os widgets e permitir que o mapa seja alterado no proximo tick
local allow_map_change = function (...)
	if (currentMap == WorldQuestTracker.GetCurrentMapAreaID()) then
		WorldQuestTracker.CanShowWorldMapWidgets (true)
	else
		WorldQuestTracker.CanShowWorldMapWidgets (false)
	end
	WorldQuestTracker.CanChangeMap = true
	WorldQuestTracker.LastMapID = WorldQuestTracker.GetCurrentMapAreaID()
	WorldQuestTracker.UpdateZoneWidgets (true)
	
	if (not WorldQuestTracker.MapData.QuestHubs [WorldQuestTracker.LastMapID] and WorldQuestTracker.IsPlayingLoadAnimation()) then
		WorldQuestTracker.StopLoadingAnimation()
	end
end

-- 8.0 is this still applied? - argus button is nameless in 8.0
if (BrokenIslesArgusButton) then
	--> at the current PTR state, goes directly to argus map
	BrokenIslesArgusButton:HookScript ("OnClick", function (self)
		if (not BrokenIslesArgusButton:IsProtected() and WorldQuestTracker.db.profile.rarescan.autosearch and WorldQuestTracker.db.profile.rarescan.add_from_premade and WorldQuestTracker.LastGFSearch + WorldQuestTracker.db.profile.rarescan.autosearch_cooldown < time()) then
			C_LFGList.Search (6, LFGListSearchPanel_ParseSearchTerms (""))
			WorldQuestTracker.LastGFSearch = time()
		end
		allow_map_change()
	end)
	--> argus map zone use an overlaied button for each of its three zones
	MacAreeButton:HookScript ("OnClick", function (self)
		allow_map_change()
	end)
	AntoranWastesButton:HookScript ("OnClick", function (self)
		allow_map_change()
	end)
	KrokuunButton:HookScript ("OnClick", function (self)
		allow_map_change()
	end)
end

--8.0 doesnt work:

--WorldMapButton:HookScript ("PreClick", deny_auto_switch)
--WorldMapButton:HookScript ("PostClick", allow_map_change)


--[=[
hooksecurefunc ("WorldMap_CreatePOI", function (index, isObjectIcon, atlasIcon)
	local POI = _G [ "WorldMapFramePOI"..index]
	if (POI) then
		POI:HookScript ("PreClick", deny_auto_switch)
		POI:HookScript ("PostClick", allow_map_change)
	end
end)
--]=]

--troca a fun��o de click dos bot�es de quest no mapa da zona
--[=[
hooksecurefunc ("WorldMap_GetOrCreateTaskPOI", function (index)
	local button = _G ["WorldMapFrameTaskPOI" .. index]
	if (button:GetScript ("OnClick") ~= WorldQuestTracker.OnQuestButtonClick) then
		--button:SetScript ("OnClick", WorldQuestTracker.OnQuestButtonClick)
		tinsert (WorldQuestTracker.AllTaskPOIs, button)
	end
end)
--]=]


WorldMapActionButtonPressed = function()
	WorldQuestTracker.Temp_HideZoneWidgets = GetTime() + 5
	WorldQuestTracker.UpdateZoneWidgets (true)
	WorldQuestTracker.ScheduleZoneMapUpdate (6)
end
hooksecurefunc ("ClickWorldMapActionButton", function()
	--WorldMapActionButtonPressed()
end)

WorldMapFrame:HookScript ("OnHide", function()
	C_Timer.After (0.2, WorldQuestTracker.RefreshTrackerWidgets)
end)

WorldQuestTracker.OnToggleWorldMap = function (self)

	if (not WorldMapFrame:IsShown()) then
		--closed
		C_Timer.After (0.2, WorldQuestTracker.RefreshTrackerWidgets)
	else
		--opened
		C_Timer.After (0.2, WorldQuestTracker.RefreshStatusBarVisibility)
		WorldQuestTrackerAddon.CatchMapProvider (true)
		WorldQuestTracker.InitializeWorldWidgets()
	end
	
	WorldQuestTracker.IsLoaded = true
	
	WorldMapFrame.currentStandingZone = WorldQuestTracker.GetCurrentMapAreaID()
	
	if (WorldMapFrame:IsShown()) then
		WorldQuestTracker.MapSeason = WorldQuestTracker.MapSeason + 1
		WorldQuestTracker.MapOpenedAt = GetTime()
	else
		for mapId, configTable in pairs (WorldQuestTracker.mapTables) do --WorldQuestTracker.SetIconTexture
			for i, f in ipairs (configTable.widgets) do
				--f:Hide()
			end
		end
	end
	
	WorldQuestTracker.lastMapTap = GetTime()
	
	WorldQuestTracker.LastMapID = WorldMapFrame.mapID
	
	if (WorldMapFrame:IsShown()) then
		--� a primeira vez que � mostrado?

		if (not WorldMapFrame.firstRun and not InCombatLockdown()) then
		
			local currentMapId = WorldMapFrame.mapID

			WorldMapFrame.firstRun = true
			
			--> some addon is adding these words on the global namespace.
			--> I trully believe that it's not intended at all, so let's just clear.
			--> it is messing with the framework.
			_G ["left"] = nil
			_G ["right"] = nil
			_G ["topleft"] = nil
			_G ["topright"] = nil

			function WorldQuestTracker.OpenSharePanel()
				if (WorldQuestTrackerSharePanel) then
					WorldQuestTrackerSharePanel:Show()
					return
				end
				
				local f = DF:CreateSimplePanel (UIParent, 460, 90, L["S_SHAREPANEL_TITLE"], "WorldQuestTrackerSharePanel")
				f:SetFrameStrata ("TOOLTIP")
				f:SetPoint ("center", WorldMapScrollFrame, "center")
				
				DF:CreateBorder (f)
				
				local text1 = DF:CreateLabel (f, L["S_SHAREPANEL_THANKS"])
				text1:SetPoint ("center", f, "center", 0, -0)
				text1:SetJustifyH ("center")
				
				local LinkBox = DF:CreateTextEntry (f, function()end, 380, 20, "ExportLinkBox", _, _, DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
				LinkBox:SetPoint ("center", f, "center", 0, -30)
				
				f:SetScript ("OnShow", function()
					LinkBox:SetText ([[https://mods.curse.com/addons/wow/world-quest-tracker]])
					C_Timer.After (1, function()
						LinkBox:SetFocus (true)
						LinkBox:HighlightText()
					end)
				end)
				
				f:Hide()
				f:Show()
			end
			
			--go to broken isles button ~worldquestbutton ~worldmapbutton ~worldbutton
			
			--create two world quest button, for alliance and horde
			
			local toggleButtonsAlpha = 0.75
			
			--user reported on this line "attempt to index a nil value": The following error message appears ONCE when opening the world map after logging in. It appears regardless of windowed or full screen world map. It does not appear again after closing and reopening the world map:
			--looks like ElvUI removes the highlight texture from the button
			local closeButtonHighlightTexture = WorldMapFrame.SidePanelToggle.CloseButton:GetHighlightTexture()
			if (closeButtonHighlightTexture) then
				closeButtonHighlightTexture:SetAlpha (toggleButtonsAlpha)
			end
			
			local openButtonHighlightTexture = WorldMapFrame.SidePanelToggle.OpenButton:GetHighlightTexture()
			if (openButtonHighlightTexture) then
				openButtonHighlightTexture:SetAlpha (toggleButtonsAlpha)
			end
			
			WorldMapFrame.SidePanelToggle.CloseButton:SetFrameLevel (anchorFrame:GetFrameLevel()+2)
			WorldMapFrame.SidePanelToggle.OpenButton:SetFrameLevel (anchorFrame:GetFrameLevel()+2)
			
			--Alliance
				local AllianceWorldQuestButton = CreateFrame ("button", "WorldQuestTrackerGoToAllianceButton", anchorFrame)
				AllianceWorldQuestButton:SetSize (44, 32)
				AllianceWorldQuestButton:SetFrameLevel (WorldMapFrame.SidePanelToggle.CloseButton:GetFrameLevel())
				AllianceWorldQuestButton:SetPoint ("right", WorldMapFrame.SidePanelToggle, "left", -48, 0)
				AllianceWorldQuestButton.Background = AllianceWorldQuestButton:CreateTexture (nil, "background")
				AllianceWorldQuestButton.Background:SetSize (44, 32)
				AllianceWorldQuestButton.Background:SetAtlas ("MapCornerShadow-Right")
				AllianceWorldQuestButton.Background:SetPoint ("bottomright", 2, -1)
				AllianceWorldQuestButton:SetNormalTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button_alliance_normal]])
				AllianceWorldQuestButton:GetNormalTexture():SetTexCoord (0, 44/64, 0, .5)
				AllianceWorldQuestButton:SetPushedTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button_alliance_pushed]])
				AllianceWorldQuestButton:GetPushedTexture():SetTexCoord (0, 44/64, 0, .5)
				
				AllianceWorldQuestButton.Highlight = AllianceWorldQuestButton:CreateTexture (nil, "highlight")
				AllianceWorldQuestButton.Highlight:SetTexture ([[Interface\Buttons\UI-Common-MouseHilight]])
				AllianceWorldQuestButton.Highlight:SetBlendMode ("ADD")
				AllianceWorldQuestButton.Highlight:SetAlpha (toggleButtonsAlpha)
				AllianceWorldQuestButton.Highlight:SetSize (44*1.5, 32*1.5)
				AllianceWorldQuestButton.Highlight:SetPoint ("center")
				
				AllianceWorldQuestButton:SetScript ("OnClick", function()
					if (GetExpansionLevel() == 6 or UnitLevel ("player") == 110) then --legion
						WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.BROKENISLES)
						
					elseif (GetExpansionLevel() == 7) then --bfa
						WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.KULTIRAS)
						--WorldQuestTracker.DoAnimationsOnWorldMapWidgets = true
						WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
					end
					WorldQuestTracker.AllianceWorldQuestButton_Click = GetTime()
				end)
			
			--Horde
				local HordeWorldQuestButton = CreateFrame ("button", "WorldQuestTrackerGoToHordeButton", anchorFrame)
				HordeWorldQuestButton:SetSize (44, 32)
				HordeWorldQuestButton:SetFrameLevel (WorldMapFrame.SidePanelToggle.CloseButton:GetFrameLevel())
				HordeWorldQuestButton:SetPoint ("right", WorldMapFrame.SidePanelToggle, "left", -2, 0)
				HordeWorldQuestButton.Background = HordeWorldQuestButton:CreateTexture (nil, "background")
				HordeWorldQuestButton.Background:SetSize (44, 32)
				HordeWorldQuestButton.Background:SetAtlas ("MapCornerShadow-Right")
				HordeWorldQuestButton.Background:SetPoint ("bottomright", 2, -1)
				HordeWorldQuestButton:SetNormalTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button_horde_normal]])
				HordeWorldQuestButton:GetNormalTexture():SetTexCoord (0, 44/64, 0, .5)
				HordeWorldQuestButton:SetPushedTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button_horde_pushed]])
				HordeWorldQuestButton:GetPushedTexture():SetTexCoord (0, 44/64, 0, .5)
				
				HordeWorldQuestButton.Highlight = HordeWorldQuestButton:CreateTexture (nil, "highlight")
				HordeWorldQuestButton.Highlight:SetTexture ([[Interface\Buttons\UI-Common-MouseHilight]])
				HordeWorldQuestButton.Highlight:SetBlendMode ("ADD")
				HordeWorldQuestButton.Highlight:SetAlpha (toggleButtonsAlpha)
				HordeWorldQuestButton.Highlight:SetSize (44*1.5, 32*1.5)
				HordeWorldQuestButton.Highlight:SetPoint ("center")
				
				HordeWorldQuestButton:SetScript ("OnClick", function()
					if (GetExpansionLevel() == 6 or UnitLevel ("player") == 110) then --legion
						WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.BROKENISLES)
						
					elseif (GetExpansionLevel() == 7) then --bfa
						WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.ZANDALAR)
						--WorldQuestTracker.DoAnimationsOnWorldMapWidgets = true
						WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
					end
					WorldQuestTracker.HordeWorldQuestButton_Click = GetTime()
				end)

		--[=[
			local WorldQuestButton = CreateFrame ("button", "WorldQuestTrackerGoToBIButton", anchorFrame)
			WorldQuestButton:SetSize (64, 32)
			WorldQuestButton:SetPoint ("right", WorldMapFrame.SidePanelToggle, "left", -2, 0)
			WorldQuestButton.Background = WorldQuestButton:CreateTexture (nil, "background")
			WorldQuestButton.Background:SetSize (64, 32)
			WorldQuestButton.Background:SetAtlas ("MapCornerShadow-Right")
			WorldQuestButton.Background:SetPoint ("bottomright", 2, -1)
			WorldQuestButton:SetNormalTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button]])
			WorldQuestButton:GetNormalTexture():SetTexCoord (0, 1, 0, .5)
			WorldQuestButton:SetPushedTexture ([[Interface\AddOns\WorldQuestTracker\media\world_quest_button_pushed]])
			WorldQuestButton:GetPushedTexture():SetTexCoord (0, 1, 0, .5)
			
			WorldQuestButton.Highlight = WorldQuestButton:CreateTexture (nil, "highlight")
			WorldQuestButton.Highlight:SetTexture ([[Interface\Buttons\UI-Common-MouseHilight]])
			WorldQuestButton.Highlight:SetBlendMode ("ADD")
			WorldQuestButton.Highlight:SetSize (64*1.5, 32*1.5)
			WorldQuestButton.Highlight:SetPoint ("center")
			
			WorldQuestButton:SetScript ("OnClick", function()
				
				if (GetExpansionLevel() == 6 or UnitLevel ("player") == 110) then --legion
					WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.BROKENISLES)
					
				elseif (GetExpansionLevel() == 7) then --bfa
					WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.ZANDALAR)
					--SetMapByID (WorldQuestTracker.MapData.ZoneIDs.KULTIRAS)
					--SetMapID
					--NavigateToMap
					
				end
				
				--PlaySound ("igMainMenuOptionCheckBoxOn")
				WorldQuestTracker.WorldQuestButton_Click = GetTime()
				
			end)
			
			WorldQuestButton:HookScript ("PreClick", deny_auto_switch)
			WorldQuestButton:HookScript ("PostClick", allow_map_change)
		--]=]
			
			
			local ToggleQuestsButton = CreateFrame ("button", "WorldQuestTrackerToggleQuestsButton", anchorFrame)
			ToggleQuestsButton:SetSize (128, 20)
			ToggleQuestsButton:SetFrameLevel (1025)
			ToggleQuestsButton:SetPoint ("bottomleft", AllianceWorldQuestButton, "topleft", 0, 1)
			ToggleQuestsButton.Background = ToggleQuestsButton:CreateTexture (nil, "background")
			ToggleQuestsButton.Background:SetSize (98, 20)
			ToggleQuestsButton.Background:SetAtlas ("MapCornerShadow-Right")
			ToggleQuestsButton.Background:SetPoint ("bottomright", 2, -1)
			ToggleQuestsButton:SetNormalTexture ([[Interface\AddOns\WorldQuestTracker\media\toggle_quest_button]])
			ToggleQuestsButton:GetNormalTexture():SetTexCoord (0, 0.7890625, 0, .5)
			ToggleQuestsButton:SetPushedTexture ([[Interface\AddOns\WorldQuestTracker\media\toggle_quest_button_pushed]])
			ToggleQuestsButton:GetPushedTexture():SetTexCoord (0, 0.7890625, 0, .5)
			
			ToggleQuestsButton.Highlight = ToggleQuestsButton:CreateTexture (nil, "highlight")
			ToggleQuestsButton.Highlight:SetTexture ([[Interface\Buttons\UI-Common-MouseHilight]])
			ToggleQuestsButton.Highlight:SetBlendMode ("ADD")
			ToggleQuestsButton.Highlight:SetAlpha (toggleButtonsAlpha)
			ToggleQuestsButton.Highlight:SetSize (128*1.5, 20*1.5)
			ToggleQuestsButton.Highlight:SetPoint ("center")

			ToggleQuestsButton.TextLabel = DF:CreateLabel (ToggleQuestsButton, "切换世界任务总览", DF:GetTemplate ("font", "WQT_TOGGLEQUEST_TEXT"))
			ToggleQuestsButton.TextLabel:SetPoint ("center", ToggleQuestsButton, "center")
			
			ToggleQuestsButton:SetScript ("OnClick", function()
				WorldQuestTracker.db.profile.disable_world_map_widgets = not WorldQuestTracker.db.profile.disable_world_map_widgets
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					WorldQuestTracker.DoAnimationsOnWorldMapWidgets = true
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				end
				
				WorldQuestTracker.db.profile.TutorialToggleButton = (WorldQuestTracker.db.profile.TutorialToggleButton or 0) + 1
				if (WorldQuestTracker.db.profile.TutorialToggleButton > 3 and ToggleQuestsButton.PulseAnimation) then
					ToggleQuestsButton.PulseAnimation:Stop()
					ToggleQuestsButton.WhiteTexture:Hide()
				end
			end)
			
			ToggleQuestsButton:SetScript ("OnMouseDown", function()
				ToggleQuestsButton.TextLabel:SetPoint ("center", ToggleQuestsButton, "center", -1, -1)
			end)
			
			ToggleQuestsButton:SetScript ("OnMouseUp", function()
				ToggleQuestsButton.TextLabel:SetPoint ("center", ToggleQuestsButton, "center")
			end)
			
			ToggleQuestsButton:Hide()
			
			if (not WorldQuestTracker.db.profile.TutorialToggleButton or WorldQuestTracker.db.profile.TutorialToggleButton < 3) then
				local white_texture = ToggleQuestsButton:CreateTexture (nil, "background")
				white_texture:SetPoint ("topleft", ToggleQuestsButton, "topleft", 6, 0)
				white_texture:SetPoint ("bottomright", ToggleQuestsButton, "bottomright", -6, 0)
				white_texture:SetColorTexture (1, 1, 1)
				
				local pulseAnimation = DF:CreateAnimationHub (white_texture)
				pulseAnimation:SetLooping ("REPEAT")
				DF:CreateAnimation (pulseAnimation, "ALPHA", 1, 2, 0, 1)
				DF:CreateAnimation (pulseAnimation, "ALPHA", 2, 2, 1, 0)
				
				ToggleQuestsButton.PulseAnimation = pulseAnimation
				ToggleQuestsButton.WhiteTexture = white_texture
				pulseAnimation:Play()
			end
			
			-- �ptionsfunc ~optionsfunc
			local options_on_click = function (_, _, option, value, value2, mouseButton)
			
				if (option == "world_map_config") then
					WorldQuestTracker.db.profile.worldmap_widgets [value] = value2
					if (value == "textsize") then
						WorldQuestTracker.SetTextSize ("WorldMap", value2)
					elseif (value == "scale") then
						if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
							WorldQuestTracker.UpdateWorldQuestsOnWorldMap()
						end
					elseif (value == "disable_world_map_widgets") then
						WorldQuestTracker.db.profile.disable_world_map_widgets = value2
						if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
							WorldQuestTracker.UpdateWorldQuestsOnWorldMap()
							GameCooltip:Close()
						end
					end
					return
					
				elseif (option == "zone_map_config") then
					WorldQuestTracker.db.profile.zonemap_widgets [value] = value2
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
						WorldQuestTracker.UpdateZoneWidgets (true)
					end
					return
				end
				
				if (option == "rarescan") then
					WorldQuestTracker.db.profile.rarescan [value] = value2
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
						WorldQuestTracker.UpdateZoneWidgets()
					end
					GameCooltip:Close()
					return
				end

				if (option:find ("tomtom")) then
					local option = option:gsub ("tomtom%-", "")
					WorldQuestTracker.db.profile.tomtom [option] = value
					GameCooltip:Hide()
					
					if (option == "enabled") then
						if (value) then
							--adiciona todas as quests to tracker no tomtom
							for i = #WorldQuestTracker.QuestTrackList, 1, -1 do
								local quest = WorldQuestTracker.QuestTrackList [i]
								local questID = quest.questID
								local mapID = quest.mapID
								WorldQuestTracker.AddQuestTomTom (questID, mapID, true)
							end
							WorldQuestTracker.RemoveAllQuestsFromTracker()
						else
							--desligou o tracker do tomtom
							for questID, t in pairs (WorldQuestTracker.db.profile.tomtom.uids) do
								if (type (questID) == "number" and QuestMapFrame_IsQuestWorldQuest (questID)) then
									--procura o bot�o da quest
									for _, widget in ipairs (WorldQuestTracker.WorldMapWidgets) do
										if (widget.questID == questID) then
											WorldQuestTracker.AddQuestToTracker (widget)
											TomTom:RemoveWaypoint (t)
											break
										end
									end
								end
							end
							wipe (WorldQuestTracker.db.profile.tomtom.uids)
							
							if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
								WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true, false, false, true)
							end
						end
					end
					
					return
				end
			
				if (option == "share_addon") then
					WorldQuestTracker.OpenSharePanel()
					GameCooltip:Hide()
					return
					
				elseif (option == "tracker_scale") then
					WorldQuestTracker.db.profile [option] = value
					WorldQuestTracker.UpdateTrackerScale()
				
				elseif (option == "clear_quest_cache") then
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
						WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true, true, false, true)
					else
						
					end
					
				elseif (option == "arrow_update_speed") then
					WorldQuestTracker.db.profile.arrow_update_frequence = value
					WorldQuestTracker.UpdateArrowFrequence()
					GameCooltip:Hide()
					return
				
				elseif (option == "untrack_quests") then
					WorldQuestTracker.RemoveAllQuestsFromTracker()
					
					if (TomTom and IsAddOnLoaded ("TomTom")) then
						for questID, t in pairs (WorldQuestTracker.db.profile.tomtom.uids) do
							TomTom:RemoveWaypoint (t)
						end
						wipe (WorldQuestTracker.db.profile.tomtom.uids)
					end
					
					GameCooltip:Hide()
					return
				
				elseif (option == "use_quest_summary") then
					WorldQuestTracker.db.profile [option] = value
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
						WorldQuestTracker.UpdateZoneWidgets()
					end
				else
					WorldQuestTracker.db.profile [option] = value
					
					if (option == "bar_anchor") then
						WorldQuestTracker:SetStatusBarAnchor()
					
					elseif (option == "use_old_icons") then
						if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
							WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true, true, false, true)
						else
							WorldQuestTracker.UpdateZoneWidgets()
						end
						
					elseif (option == "tracker_textsize") then
						WorldQuestTracker.RefreshTrackerWidgets()
						
					end
				end
				
				if (option == "zone_only_tracked") then
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
						WorldQuestTracker.UpdateZoneWidgets()
					end
				end
			
				if (option == "tracker_is_locked") then
					--> s� aparece esta op��o quando o tracker esta m�vel
					if (WorldQuestTracker.db.profile.tracker_is_movable) then
						if (value) then
							--> o tracker agora esta trancado - desliga o mouse
							WorldQuestTrackerScreenPanel:EnableMouse (false)
							--LibWindow.MakeDraggable (WorldQuestTrackerScreenPanel)
						else
							--> o tracker agora est� movel - liga o mouse
							WorldQuestTrackerScreenPanel:EnableMouse (true)
							LibWindow.MakeDraggable (WorldQuestTrackerScreenPanel)
						end
					end
				end
				
				if (option == "tracker_is_movable") then
				
					if (not LibWindow) then
						print ("|cFFFFAA00World Quest Tracker|r: libwindow not found, did you just updated the addon? try reopening the client.|r")
					end
				
					if (value) then
						--> o tracker agora � m�vel
						--verificar a op��o se esta locked
						if (LibWindow and not WorldQuestTrackerScreenPanel.RegisteredForLibWindow) then
							LibWindow.RestorePosition (WorldQuestTrackerScreenPanel)
							WorldQuestTrackerScreenPanel.RegisteredForLibWindow = true
						end
						if (not WorldQuestTracker.db.profile.tracker_is_locked) then
							WorldQuestTrackerScreenPanel:EnableMouse (true)
							LibWindow.MakeDraggable (WorldQuestTrackerScreenPanel)
						end
					else
						--> o tracker agora auto alinha com o objective tracker
						WorldQuestTrackerScreenPanel:EnableMouse (false)
					end
					
					WorldQuestTracker.RefreshTrackerAnchor()
				end
				
				if (option == "tracker_is_locked") then
					WorldQuestTracker.RefreshTrackerAnchor()
				end
			
				if (option ~= "show_timeleft" and option ~= "alpha_time_priority" and option ~= "force_sort_by_timeleft") then
					GameCooltip:ExecFunc (WorldQuestTrackerOptionsButton)
				else
					--> se for do painel de tempo, dar refresh no world map
					if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
						WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true, true, false, true)
					end
					GameCooltip:Close()
				end
			end

			-- ~bar ~statusbar
			WorldQuestTracker.DoubleTapFrame = CreateFrame ("frame", "WorldQuestTrackerDoubleTapFrame", anchorFrame)
			WorldQuestTracker.DoubleTapFrame:SetHeight (18)
			WorldQuestTracker.DoubleTapFrame:SetFrameLevel (WorldMapFrame.SidePanelToggle.CloseButton:GetFrameLevel()-1)

			--background
			local doubleTapBackground = WorldQuestTracker.DoubleTapFrame:CreateTexture (nil, "artwork")
			doubleTapBackground:SetColorTexture (0, 0, 0, 0.5)
			doubleTapBackground:SetHeight (18)
			WorldQuestTracker.DoubleTapFrame.Background = doubleTapBackground
			
			--border
			local doubleTapBorder = WorldQuestTracker.DoubleTapFrame:CreateTexture (nil, "overlay")
			doubleTapBorder:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\golden_line]])
			doubleTapBorder:SetHorizTile (true)
			doubleTapBorder:SetPoint ("topleft", doubleTapBackground, "topleft")
			doubleTapBorder:SetPoint ("topright", doubleTapBackground, "topright")
			
			WorldQuestTracker.DoubleTapFrame.BackgroundTexture = doubleTapBackground
			WorldQuestTracker.DoubleTapFrame.BackgroundBorder = doubleTapBorder
			
			function WorldQuestTracker:SetStatusBarAnchor (anchor)
				anchor = anchor or WorldQuestTracker.db.profile.bar_anchor
				WorldQuestTracker.db.profile.bar_anchor = anchor
				WorldQuestTracker.UpdateStatusBarAnchors()
			end
		
			---------------------------------------------------------
			
			local SummaryFrame = CreateFrame ("frame", "WorldQuestTrackerSummaryPanel", WorldQuestTrackerWorldMapPOI)
			SummaryFrame:SetPoint ("topleft", WorldQuestTrackerWorldMapPOI, "topleft", 0, 0)
			SummaryFrame:SetPoint ("bottomright", WorldQuestTrackerWorldMapPOI, "bottomright", 0, 0)
			SummaryFrame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
			SummaryFrame:SetBackdropColor (0, 0, 0, 1)
			SummaryFrame:SetBackdropBorderColor (0, 0, 0, 1)
			SummaryFrame:SetFrameStrata ("DIALOG")
			SummaryFrame:SetFrameLevel (3500)
			SummaryFrame:EnableMouse (true)
			SummaryFrame:Hide()
			
			SummaryFrame.RightBorder = SummaryFrame:CreateTexture (nil, "overlay")
			SummaryFrame.RightBorder:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
			SummaryFrame.RightBorder:SetTexCoord (1, 0, 0, 1)
			SummaryFrame.RightBorder:SetPoint ("topright")
			SummaryFrame.RightBorder:SetPoint ("bottomright")
			SummaryFrame.RightBorder:SetPoint ("topleft")
			SummaryFrame.RightBorder:SetPoint ("bottomleft")
			SummaryFrame.RightBorder:SetWidth (125)
			SummaryFrame.RightBorder:SetDesaturated (true)
			SummaryFrame.RightBorder:SetDrawLayer ("background", -7)
			
			local SummaryFrameUp = CreateFrame ("frame", "WorldQuestTrackerSummaryUpPanel", SummaryFrame)
			SummaryFrameUp:SetPoint ("topleft", WorldQuestTrackerWorldMapPOI, "topleft", 0, 0)
			SummaryFrameUp:SetPoint ("bottomright", WorldQuestTrackerWorldMapPOI, "bottomright", 0, 0)
			SummaryFrameUp:SetFrameLevel (3501)
			SummaryFrameUp:Hide()
			
			local SummaryFrameDown = CreateFrame ("frame", "WorldQuestTrackerSummaryDownPanel", SummaryFrame)
			SummaryFrameDown:SetPoint ("topleft", WorldQuestTrackerWorldMapPOI, "topleft", 0, 0)
			SummaryFrameDown:SetPoint ("bottomright", WorldQuestTrackerWorldMapPOI, "bottomright", 0, 0)
			SummaryFrameDown:SetFrameLevel (3499)
			SummaryFrameDown:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
			SummaryFrameDown:SetBackdropColor (0, 0, 0, 1)
			SummaryFrameDown:SetBackdropBorderColor (0, 0, 0, 1)
			SummaryFrameDown:Hide()
			
			local CloseSummaryPanel = CreateFrame ("button", "WorldQuestTrackerCloseSummaryButton", SummaryFrameUp)
			CloseSummaryPanel:SetSize (64, 32)
			CloseSummaryPanel:SetPoint ("right", WorldMapFrame.SidePanelToggle, "left", -2, 0)
			CloseSummaryPanel.Background = CloseSummaryPanel:CreateTexture (nil, "background")
			CloseSummaryPanel.Background:SetSize (64, 32)
			CloseSummaryPanel.Background:SetAtlas ("MapCornerShadow-Right")
			CloseSummaryPanel.Background:SetPoint ("bottomright", 2, -1)
			CloseSummaryPanel:SetNormalTexture ([[Interface\AddOns\WorldQuestTracker\media\close_summary_button]])
			CloseSummaryPanel:GetNormalTexture():SetTexCoord (0, 1, 0, .5)
			CloseSummaryPanel:SetPushedTexture ([[Interface\AddOns\WorldQuestTracker\media\close_summary_button_pushed]])
			CloseSummaryPanel:GetPushedTexture():SetTexCoord (0, 1, 0, .5)
			
			CloseSummaryPanel.Highlight = CloseSummaryPanel:CreateTexture (nil, "highlight")
			CloseSummaryPanel.Highlight:SetTexture ([[Interface\Buttons\UI-Common-MouseHilight]])
			CloseSummaryPanel.Highlight:SetBlendMode ("ADD")
			CloseSummaryPanel.Highlight:SetSize (64*1.5, 32*1.5)
			CloseSummaryPanel.Highlight:SetPoint ("center")
			
			CloseSummaryPanel:SetScript ("OnClick", function()
				SummaryFrame.HideAnimation:Play()
				SummaryFrameUp.HideAnimation:Play()
				SummaryFrameDown.HideAnimation:Play()
			end)			
			
			SummaryFrame:SetScript ("OnMouseDown", function (self, button)
				if (button == "RightButton") then
					--SummaryFrame:Hide()
					--SummaryFrameUp:Hide()
					SummaryFrame.HideAnimation:Play()
					SummaryFrameUp.HideAnimation:Play()
					SummaryFrameDown.HideAnimation:Play()
				end
			end)
			
			local x = 10
			
			local TitleTemplate = DF:GetTemplate ("font", "WQT_SUMMARY_TITLE")
			
			local accountLifeTime_Texture = DF:CreateImage (SummaryFrameUp, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 16, 16, "artwork", {5/32, 27/32, 5/32, 27/32})
			accountLifeTime_Texture:SetPoint (x, -10)
			accountLifeTime_Texture:SetAlpha (.7)
			
			local characterLifeTime_Texture = DF:CreateImage (SummaryFrameUp, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 16, 16, "artwork", {5/32, 27/32, 5/32, 27/32})
			characterLifeTime_Texture:SetPoint (x, -97)
			characterLifeTime_Texture:SetAlpha (.7)
			
			local graphicTime_Texture = DF:CreateImage (SummaryFrameUp, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 16, 16, "artwork", {5/32, 27/32, 5/32, 27/32})
			graphicTime_Texture:SetPoint (x, -228)
			graphicTime_Texture:SetAlpha (.7)
			
			local otherCharacters_Texture = DF:CreateImage (SummaryFrameUp, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 16, 16, "artwork", {5/32, 27/32, 5/32, 27/32})
			otherCharacters_Texture:SetPoint ("topleft", SummaryFrameUp, "topright", -220, -10)
			otherCharacters_Texture:SetAlpha (.7)			

			local accountLifeTime = DF:CreateLabel (SummaryFrameUp, L["S_SUMMARYPANEL_LIFETIMESTATISTICS_ACCOUNT"] .. ":", TitleTemplate)
			accountLifeTime:SetPoint ("left", accountLifeTime_Texture, "right", 2, 1)
			SummaryFrameUp.AccountLifeTime_Gold = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_GOLD"] .. ": %s")
			SummaryFrameUp.AccountLifeTime_Resources = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_RESOURCE"] .. ": %s")
			SummaryFrameUp.AccountLifeTime_APower = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_ARTIFACTPOWER"] .. ": %s")
			SummaryFrameUp.AccountLifeTime_QCompleted = DF:CreateLabel (SummaryFrameUp, L["S_QUESTSCOMPLETED"] .. ": %s")
			SummaryFrameUp.AccountLifeTime_Gold:SetPoint (x, -30)
			SummaryFrameUp.AccountLifeTime_Resources:SetPoint (x, -45)
			SummaryFrameUp.AccountLifeTime_APower:SetPoint (x, -60)
			SummaryFrameUp.AccountLifeTime_QCompleted:SetPoint (x, -75)
			
			local characterLifeTime = DF:CreateLabel (SummaryFrameUp, L["S_SUMMARYPANEL_LIFETIMESTATISTICS_CHARACTER"] .. ":", TitleTemplate)
			characterLifeTime:SetPoint ("left", characterLifeTime_Texture, "right", 2, 1)
			SummaryFrameUp.CharacterLifeTime_Gold = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_GOLD"] .. ": %s")
			SummaryFrameUp.CharacterLifeTime_Resources = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_RESOURCE"] .. ": %s")
			SummaryFrameUp.CharacterLifeTime_APower = DF:CreateLabel (SummaryFrameUp, L["S_QUESTTYPE_ARTIFACTPOWER"] .. ": %s")
			SummaryFrameUp.CharacterLifeTime_QCompleted = DF:CreateLabel (SummaryFrameUp, L["S_QUESTSCOMPLETED"] .. ": %s")
			SummaryFrameUp.CharacterLifeTime_Gold:SetPoint (x, -120)
			SummaryFrameUp.CharacterLifeTime_Resources:SetPoint (x, -135)
			SummaryFrameUp.CharacterLifeTime_APower:SetPoint (x, -150)
			SummaryFrameUp.CharacterLifeTime_QCompleted:SetPoint (x, -165)
			
			function WorldQuestTracker.UpdateSummaryFrame()
				
				local acctLifeTime = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_REWARD, WQT_QUERYDB_ACCOUNT)
				acctLifeTime = acctLifeTime or {}
				local questsLifeTime = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_QUEST, WQT_QUERYDB_ACCOUNT)
				questsLifeTime = questsLifeTime or {}
				
				SummaryFrameUp.AccountLifeTime_Gold.text = format (L["S_QUESTTYPE_GOLD"] .. ": %s", (acctLifeTime.gold or 0) > 0 and GetCoinTextureString (acctLifeTime.gold) or 0)
				SummaryFrameUp.AccountLifeTime_Resources.text = format (L["S_QUESTTYPE_RESOURCE"] .. ": %s", WorldQuestTracker.ToK (acctLifeTime.resource or 0))
				SummaryFrameUp.AccountLifeTime_APower.text = format (L["S_QUESTTYPE_ARTIFACTPOWER"] .. ": %s", WorldQuestTracker.ToK (acctLifeTime.artifact or 0))
				SummaryFrameUp.AccountLifeTime_QCompleted.text = format (L["S_QUESTSCOMPLETED"] .. ": %s", DF:CommaValue (questsLifeTime.total or 0))
				
				local chrLifeTime = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_REWARD, WQT_QUERYDB_LOCAL)
				chrLifeTime = chrLifeTime or {}
				local questsLifeTime = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_QUEST, WQT_QUERYDB_LOCAL)
				questsLifeTime = questsLifeTime or {}
				
				SummaryFrameUp.CharacterLifeTime_Gold.text = format (L["S_QUESTTYPE_GOLD"] .. ": %s", (chrLifeTime.gold or 0) > 0 and GetCoinTextureString (chrLifeTime.gold) or 0)
				SummaryFrameUp.CharacterLifeTime_Resources.text = format (L["S_QUESTTYPE_RESOURCE"] .. ": %s", WorldQuestTracker.ToK (chrLifeTime.resource or 0))
				SummaryFrameUp.CharacterLifeTime_APower.text = format (L["S_QUESTTYPE_ARTIFACTPOWER"] .. ": %s", WorldQuestTracker.ToK (chrLifeTime.artifact or 0))
				SummaryFrameUp.CharacterLifeTime_QCompleted.text = format (L["S_QUESTSCOMPLETED"] .. ": %s", DF:CommaValue (questsLifeTime.total or 0))
				
			end
			
			----------
			
			SummaryFrameUp.ShowAnimation = DF:CreateAnimationHub (SummaryFrameUp, 
			function() 
				SummaryFrameUp:Show();
				WorldQuestTracker.UpdateSummaryFrame(); 
				SummaryFrameUp.CharsQuestsScroll:Refresh();
			end,
			function()
				SummaryFrameDown.ShowAnimation:Play();
			end)
			DF:CreateAnimation (SummaryFrameUp.ShowAnimation, "Alpha", 1, .15, 0, 1)
			
			SummaryFrame.ShowAnimation = DF:CreateAnimationHub (SummaryFrame, 
				function() 
					SummaryFrame:Show()
					if (WorldQuestTracker.db.profile.sound_enabled) then
						if (math.random (5) == 1) then
							PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\swap_panels1.mp3")
						else
							PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\swap_panels2.mp3")	
						end
					end
				end, 
				function() 
					SummaryFrameUp.ShowAnimation:Play()
				end)
			DF:CreateAnimation (SummaryFrame.ShowAnimation, "Scale", 1, .1, .1, 1, 1, 1, "left", 0, 0)
			
			SummaryFrame.HideAnimation = DF:CreateAnimationHub (SummaryFrame, function()
				--PlaySound ("igMainMenuOptionCheckBoxOn")
			end, 
				function() 
					SummaryFrame:Hide() 
				end)
			DF:CreateAnimation (SummaryFrame.HideAnimation, "Scale", 1, .1, 1, 1, .1, 1, "left", 1, 0)
			
			SummaryFrameUp.HideAnimation = DF:CreateAnimationHub (SummaryFrameUp, _, 
				function() 
					SummaryFrameUp:Hide() 
				end)
			DF:CreateAnimation (SummaryFrameUp.HideAnimation, "Alpha", 1, .1, 1, 0)
			
			SummaryFrameDown.ShowAnimation = DF:CreateAnimationHub (SummaryFrameDown,
				function()
					SummaryFrameDown:Show()
				end,
				function()
					SummaryFrameDown:SetAlpha (.7)
				end
			)
			DF:CreateAnimation (SummaryFrameDown.ShowAnimation, "Alpha", 1, 3, 0, .7)
			
			SummaryFrameDown.HideAnimation = DF:CreateAnimationHub (SummaryFrameDown, function()
				SummaryFrameDown.ShowAnimation:Stop()
			end, 
			function()
				SummaryFrameDown:Hide()
			end)
			DF:CreateAnimation (SummaryFrameDown.HideAnimation, "Alpha", 1, .1, 1, 0)
			-----------
			
			local scroll_refresh = function()
				
			end
			
			local AllQuests = WorldQuestTracker.db.profile.quests_all_characters
			local formated_quest_table = {}
			local chrGuid = UnitGUID ("player")
			for guid, questTable in pairs (AllQuests or {}) do
				if (guid ~= chrGuid) then
					tinsert (formated_quest_table, {"blank"})
					tinsert (formated_quest_table, {true, guid})
					tinsert (formated_quest_table, {"blank"})
					for questID, questInfo in pairs (questTable or {}) do
						tinsert (formated_quest_table, {questID, questInfo})
					end
				end
			end
			
			local scroll_line_height = 14
			local scroll_line_amount = 26
			local scroll_width = 195
			
			local line_onenter = function (self)
				if (self.questID) then
					self.numObjectives = 10
					self.UpdateTooltip = TaskPOI_OnEnter
					TaskPOI_OnEnter (self)
					self:SetBackdropColor (.5, .50, .50, 0.75)
				end
			end
			local line_onleave = function (self)
				TaskPOI_OnLeave (self)
				self:SetBackdropColor (0, 0, 0, 0.2)
			end
			local line_onclick = function()
				
			end
			
			local scroll_createline = function (self, index)
				local line = CreateFrame ("button", "$parentLine" .. index, self)
				line:SetPoint ("topleft", self, "topleft", 0, -((index-1)*(scroll_line_height+1)))
				line:SetSize (scroll_width, scroll_line_height)
				line:SetScript ("OnEnter", line_onenter)
				line:SetScript ("OnLeave", line_onleave)
				line:SetScript ("OnClick", line_onclick)
				
				line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				line:SetBackdropColor (0, 0, 0, 0.2)
				
				local icon = line:CreateTexture ("$parentIcon", "overlay")
				icon:SetSize (scroll_line_height, scroll_line_height)
				local name = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
				DF:SetFontSize (name, 9)
				icon:SetPoint ("left", line, "left", 2, 0)
				name:SetPoint ("left", icon, "right", 2, 0)
				local timeleft = line:CreateFontString ("$parentTimeLeft", "overlay", "GameFontNormal")
				DF:SetFontSize (timeleft, 9)
				timeleft:SetPoint ("right", line, "right", -2, 0)
				line.icon = icon
				line.name = name
				line.timeleft = timeleft
				name:SetHeight (10)
				name:SetJustifyH ("left")
				
				return line
			end
			
			local scroll_refresh = function (self, data, offset, total_lines)
				for i = 1, total_lines do
					local index = i + offset
					local quest = data [index]
					
					if (quest) then
						local line = self:GetLine (i)
						line:SetAlpha (1)
						line.questID = nil
						if (quest [1] == "blank") then
							line.name:SetText ("")
							line.timeleft:SetText ("")
							line.icon:SetTexture (nil)
							
						elseif (quest [1] == true) then
							local name, realm, class = WorldQuestTracker.GetCharInfo (quest [2])
							local color = RAID_CLASS_COLORS [class]
							local name = name .. " - " .. realm
							if (color) then
								name = "|c" .. color.colorStr .. name .. "|r"
							end
							line.name:SetText (name)
							line.timeleft:SetText ("")
							line.name:SetWidth (180)
							
							if (class) then
								line.icon:SetTexture ([[Interface\WORLDSTATEFRAME\Icons-Classes]])
								line.icon:SetTexCoord (unpack (CLASS_ICON_TCOORDS [class]))
							else
								line.icon:SetTexture (nil)
							end
						else
							local questInfo = quest [2]
							local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (quest [1])

							title = title or L["S_UNKNOWNQUEST"]
							
							local rewardAmount = questInfo.rewardAmount
							if (questInfo.questType == QUESTTYPE_GOLD) then
								rewardAmount = floor (questInfo.rewardAmount / 10000)
							end
							
							local colorByRarity = ""

							if (rarity  == LE_WORLD_QUEST_QUALITY_EPIC) then
								colorByRarity = "FFC845F9"
							elseif (rarity  == LE_WORLD_QUEST_QUALITY_RARE) then
								colorByRarity = "FF0091F2"
							else
								colorByRarity = "FFFFFFFF"
							end
							
							local timeLeft = ((questInfo.expireAt - time()) / 60) --segundos / 60
							local color
							if (timeLeft > 120) then
								color = "FFFFFFFF"
							elseif (timeLeft > 45) then
								color = "FFFFAA22"
							else
								color = "FFFF3322"
							end
							
							if (type (questInfo.rewardTexture) == "string" and questInfo.rewardTexture:find ("icon_artifactpower")) then
								--for�ando sempre mostrar icone vermelho
								line.icon:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_blueT]])
								
								--format the artifact power amount
								if (rewardAmount > 100000) then
									rewardAmount = WorldQuestTracker.ToK (rewardAmount)
								end
								
							else
								line.icon:SetTexture (questInfo.rewardTexture)
							end
							
							line.name:SetText ("|cFFFFDD00[" .. rewardAmount .. "]|r |c" .. colorByRarity .. title .. "|r")
							line.timeleft:SetText (timeLeft > 0 and "|c" .. color .. SecondsToTime (timeLeft * 60) .. "|r" or "|cFFFF5500" .. L["S_SUMMARYPANEL_EXPIRED"] .. "|r")
							
							line.icon:SetTexCoord (5/64, 59/64, 5/64, 59/64)
							line.name:SetWidth (100)
							
							if (timeLeft <= 0) then
								line:SetAlpha (.5)
							end
							
							line.questID = quest [1]
						end
					end
				end
			end

			local ScrollTitle = DF:CreateLabel (SummaryFrameUp, L["S_SUMMARYPANEL_OTHERCHARACTERS"] .. ":", TitleTemplate)
			ScrollTitle:SetPoint ("left", otherCharacters_Texture, "right", 2, 1)
			
			local CharsQuestsScroll = DF:CreateScrollBox (SummaryFrameUp, "$parentChrQuestsScroll", scroll_refresh, formated_quest_table, scroll_width, 400, scroll_line_amount, scroll_line_height)
			CharsQuestsScroll:SetPoint ("topright", SummaryFrameUp, "topright", -25, -30)
			for i = 1, scroll_line_amount do 
				CharsQuestsScroll:CreateLine (scroll_createline)
			end
			SummaryFrameUp.CharsQuestsScroll = CharsQuestsScroll
			CharsQuestsScroll:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			CharsQuestsScroll:SetBackdropColor (0, 0, 0, .4)

			-----------
			
			local GF_LineOnEnter = function (self)
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("ButtonsYMod", -2)
				GameCooltip:SetOption ("YSpacingMod", 1)
				GameCooltip:SetOption ("FixedHeight", 95)
				
				local today = self.data.table
				
				local t = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_GOLD]
				GameCooltip:AddLine (t.name .. ":", today.gold and today.gold > 0 and GetCoinTextureString (today.gold) or 0, 1, "white", "orange")
				GameCooltip:AddIcon (t.icon, 1, 1, 16, 16)
				
				local t = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_RESOURCE]
				GameCooltip:AddLine (t.name .. ":", DF:CommaValue (today.resource or 0), 1, "white", "orange")
				GameCooltip:AddIcon (t.icon, 1, 1, 14, 14)
				
				local t = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_APOWER]
				GameCooltip:AddLine (t.name .. ":", DF:CommaValue (today.artifact or 0), 1, "white", "orange")
				GameCooltip:AddIcon (t.icon, 1, 1, 16, 16)
				
				local t = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_TRADE]
				GameCooltip:AddLine (t.name .. ":", DF:CommaValue (today.blood or 0), 1, "white", "orange")
				GameCooltip:AddIcon (t.icon, 1, 1, 16, 16, unpack (t.coords))
				
				GameCooltip:AddLine (L["S_QUESTSCOMPLETED"] .. ":", today.quest or 0, 1, "white", "orange")
				GameCooltip:AddIcon ([[Interface\GossipFrame\AvailableQuestIcon]], 1, 1, 16, 16)
				
				GameCooltip:ShowCooltip (self)
			end
			local GF_LineOnLeave = function (self)
				GameCooltip:Hide()
			end

			-- ~gframe
			local GoldGraphic = DF:CreateGFrame (SummaryFrameUp, 422, 160, 28, GF_LineOnEnter, GF_LineOnLeave, "GoldGraphic", "WorldQuestTrackerGoldGraphic")
			GoldGraphic:SetPoint ("topleft", 40, -248)
			GoldGraphic:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			GoldGraphic:SetBackdropColor (0, 0, 0, .6)
			
			local GoldGraphicTextBg = CreateFrame ("frame", nil, GoldGraphic)
			GoldGraphicTextBg:SetPoint ("topleft", GoldGraphic, "bottomleft", 0, -2)
			GoldGraphicTextBg:SetPoint ("topright", GoldGraphic, "bottomright", 0, -2)
			GoldGraphicTextBg:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			GoldGraphicTextBg:SetBackdropColor (0, 0, 0, .4)
			GoldGraphicTextBg:SetHeight (20)
			--DF:CreateBorder (GoldGraphic, .4, .2, .05)
			
			local leftLine = DF:CreateImage (GoldGraphic)
			leftLine:SetColorTexture (1, 1, 1, .35)
			leftLine:SetSize (1, 160)
			leftLine:SetPoint ("topleft", GoldGraphic, "topleft", -1, 0)
			leftLine:SetPoint ("bottomleft", GoldGraphic, "bottomleft", -1, -20)
			
			local bottomLine = DF:CreateImage (GoldGraphic)
			bottomLine:SetColorTexture (1, 1, 1, .35)
			bottomLine:SetSize (422, 1)
			bottomLine:SetPoint ("bottomleft", GoldGraphic, "bottomleft", -35, -2)
			bottomLine:SetPoint ("bottomright", GoldGraphic, "bottomright", 0, -2)
			
			GoldGraphic.AmountIndicators = {}
			for i = 0, 5 do
				local text = DF:CreateLabel (GoldGraphic, "")
				text:SetPoint ("topright", GoldGraphic, "topleft", -4, -(i*32) - 2)
				text.align = "right"
				text.textcolor = "silver"
				tinsert (GoldGraphic.AmountIndicators, text)
				local line = DF:CreateImage (GoldGraphic)
				line:SetColorTexture (1, 1, 1, .05)
				line:SetSize (420, 1)
				line:SetPoint (0, -(i*32))
			end
			
			local GoldGraphicTitle = DF:CreateLabel (SummaryFrameUp, L["S_SUMMARYPANEL_LAST15DAYS"] .. ":", TitleTemplate)
			--GoldGraphicTitle:SetPoint ("bottomleft", GoldGraphic, "topleft", 0, 6)
			GoldGraphicTitle:SetPoint ("left", graphicTime_Texture, "right", 2, 1)
			
			local GraphicDataToUse = 1
			local OnSelectGraphic = function (_, _, value)
				GraphicDataToUse = value
				SummaryFrameUp.RefreshGraphic()
			end
			
			local class = select (2, UnitClass ("player"))
			local color = RAID_CLASS_COLORS [class] and RAID_CLASS_COLORS [class].colorStr or "FFFFFFFF"
			local graphic_options = {
				{label = L["S_OVERALL"] .. " [|cFFC0C0C0" .. L["S_MAPBAR_SUMMARYMENU_ACCOUNTWIDE"] .. "|r]", value = 1, onclick = OnSelectGraphic,
				icon = [[Interface\GossipFrame\BankerGossipIcon]], iconsize = {14, 14}}, --texcoord = {3/32, 29/32, 3/32, 29/32}
				{label = L["S_QUESTTYPE_GOLD"] .. " [|cFFC0C0C0" .. L["S_MAPBAR_SUMMARYMENU_ACCOUNTWIDE"] .. "|r]", value = 2, onclick = OnSelectGraphic,
				icon = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_GOLD].icon, iconsize = {14, 14}},
				{label = L["S_QUESTTYPE_RESOURCE"] .. " [|c" .. color .. UnitName ("player") .. "|r]", value = 3, onclick = OnSelectGraphic,
				icon = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_RESOURCE].icon, iconsize = {14, 14}},
				{label = L["S_QUESTTYPE_ARTIFACTPOWER"] .. " [|c" .. color .. UnitName ("player") .. "|r]", value = 4, onclick = OnSelectGraphic,
				icon = WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_APOWER].icon, iconsize = {14, 14}}
			}
			local graphic_options_func = function()
				return graphic_options
			end
			
			local dropdown_diff = DF:CreateDropDown (SummaryFrameUp, graphic_options_func, 1, 180, 20, "dropdown_graphic", _, DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			dropdown_diff:SetPoint ("left", GoldGraphicTitle, "right", 4, 0)

			local empty_day = {
				["artifact"] = 0,
				["resource"] = 0,
				["quest"] = 0,
				["gold"] = 0,
				["blood"] = 0,
			}
	
			SummaryFrameUp.RefreshGraphic = function()
				GoldGraphic:Reset()

				local twoWeeks
				local dateString
				
				if (GraphicDataToUse == 1 or GraphicDataToUse == 2) then --account overall
					twoWeeks = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_ACCOUNT, WQT_DATE_2WEEK)
					dateString = WorldQuestTracker.GetDateString (WQT_DATE_2WEEK)
				elseif (GraphicDataToUse == 3 or GraphicDataToUse == 4) then
					twoWeeks = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_LOCAL, WQT_DATE_2WEEK)
					dateString = WorldQuestTracker.GetDateString (WQT_DATE_2WEEK)
				end
				
				local data = {}
				for i = 1, #dateString do
					local hadTable = false
					twoWeeks = twoWeeks or {}
					for o = 1, #twoWeeks do
						if (twoWeeks[o].day == dateString[i]) then
							if (GraphicDataToUse == 1) then
								local gold = (twoWeeks[o].table.gold and twoWeeks[o].table.gold/10000) or 0
								local resource = twoWeeks[o].table.resource or 0
								local artifact = twoWeeks[o].table.artifact or 0
								local blood = (twoWeeks[o].table.blood and twoWeeks[o].table.blood*300) or 0
								
								local total = gold + resource + artifact + blood

								data [#data+1] = {value = total or 0, text = dateString[i]:gsub ("^%d%d%d%d", ""), table = twoWeeks[o].table}
								hadTable = true
								
							elseif (GraphicDataToUse == 2) then
								local gold = (twoWeeks[o].table.gold and twoWeeks[o].table.gold/10000) or 0
								data [#data+1] = {value = gold, text = dateString[i]:gsub ("^%d%d%d%d", ""), table = twoWeeks[o].table}
								hadTable = true
								
							elseif (GraphicDataToUse == 3) then
								local resource = twoWeeks[o].table.resource or 0
								data [#data+1] = {value = resource, text = dateString[i]:gsub ("^%d%d%d%d", ""), table = twoWeeks[o].table}
								hadTable = true
								
							elseif (GraphicDataToUse == 4) then
								local artifact = twoWeeks[o].table.artifact or 0
								data [#data+1] = {value = artifact, text = dateString[i]:gsub ("^%d%d%d%d", ""), table = twoWeeks[o].table}
								hadTable = true
							end
							break
						end
					end
					if (not hadTable) then
						data [#data+1] = {value = 0, text = dateString[i]:gsub ("^%d%d%d%d", ""), table = empty_day}
					end
					
				end
				
				data = DF.table.reverse (data)
				GoldGraphic:UpdateLines (data)
				
				for i = 1, 5 do
					local text = GoldGraphic.AmountIndicators [i]
					local percent = 20 * abs (i - 6)
					local total = GoldGraphic.MaxValue / 100 * percent
					text.text = WorldQuestTracker.ToK (total)
				end
				
				--customize text anchor
				for _, line in ipairs (GoldGraphic._lines) do
					line.timeline:SetPoint ("bottomright", line, "bottomright", -2, -18)
				end
			end
	
			GoldGraphic:SetScript ("OnShow", function (self)
				SummaryFrameUp.RefreshGraphic()
			end)
			
			-----------
			
			local buttons_width = 70
			
			local setup_button = function (button, name)
				button:SetSize (buttons_width, 16)
			
				button.Text = button:CreateFontString (nil, "overlay", "GameFontNormal")
				button.Text:SetText (name)
			
				WorldQuestTracker:SetFontSize (button.Text, 10)
				WorldQuestTracker:SetFontColor (button.Text, "orange")
				button.Text:SetPoint ("center")
				
				local shadow = button:CreateTexture (nil, "background")
				shadow:SetPoint ("center")
				shadow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
				shadow:SetSize (buttons_width+10, 10)
				shadow:SetAlpha (.3)
			end
			
			local button_onenter = function (self)
				WorldQuestTracker:SetFontColor (self.Text, "WQT_ORANGE_ON_ENTER")
			end
			local button_onleave = function (self)
				WorldQuestTracker:SetFontColor (self.Text, "orange")
			end
			
			--reward history / summary
			local rewardButton = CreateFrame ("button", "WorldQuestTrackerRewardHistoryButton", WorldQuestTracker.DoubleTapFrame)
			rewardButton:SetPoint ("bottomleft", WorldQuestTracker.DoubleTapFrame, "bottomleft", 0, 2)
			setup_button (rewardButton, L["S_MAPBAR_SUMMARY"])
			rewardButton:SetScript ("OnClick", function() SummaryFrame.ShowAnimation:Play() end)

			---------------------------------------------------------
			--options button
			local optionsButton = CreateFrame ("button", "WorldQuestTrackerOptionsButton", WorldQuestTracker.DoubleTapFrame)
			optionsButton:SetPoint ("left", rewardButton, "right", 2, 0)
			setup_button (optionsButton, L["S_MAPBAR_OPTIONS"]) --~options
			
			---------------------------------------------------------
			
			--sort options
			local sortButton = CreateFrame ("button", "WorldQuestTrackerSortButton", WorldQuestTracker.DoubleTapFrame)
			sortButton:SetPoint ("left", optionsButton, "right", 2, 0)
			setup_button (sortButton, L["S_MAPBAR_SORTORDER"])
			
			-- ~sort
			local change_sort_mode = function (a, b, questType, _, _, mouseButton)
				local currentIndex = WorldQuestTracker.db.profile.sort_order [questType]
				if (currentIndex < WQT_QUESTTYPE_MAX) then
					for type, order in pairs (WorldQuestTracker.db.profile.sort_order) do
						if (WorldQuestTracker.db.profile.sort_order [type] == currentIndex+1) then
							WorldQuestTracker.db.profile.sort_order [type] = currentIndex
							break
						end
					end
					
					WorldQuestTracker.db.profile.sort_order [questType] = WorldQuestTracker.db.profile.sort_order [questType] + 1
				end
				
				GameCooltip:ExecFunc (sortButton)
				
				--atualiza as quests
				if (WorldQuestTracker.IsWorldQuestHub (WorldQuestTracker.GetCurrentMapAreaID())) then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				end
			end
			
			local change_sort_timeleft_mode = function (_, _, amount)
				if (WorldQuestTracker.db.profile.sort_time_priority == amount) then
					WorldQuestTracker.db.profile.sort_time_priority = false
				else
					WorldQuestTracker.db.profile.sort_time_priority = amount
				end
				
				GameCooltip:Hide()
				
				--atualiza as quests
				
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					WorldQuestTracker.UpdateZoneWidgets()
				end
			end
			
			local overlayColor = {.5, .5, .5, 1}
			local BuildSortMenu = function()
				local t = {}
				for type, order in pairs (WorldQuestTracker.db.profile.sort_order) do
					tinsert (t, {type, order})
				end
				table.sort (t, function(a, b) return a[2] > b[2] end)
				
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 180)
				
				for i, questType in ipairs (t) do
					local type = questType [1]
					local info = WorldQuestTracker.MapData.QuestTypeIcons [type]
					local isEnabled = WorldQuestTracker.db.profile.filters [WorldQuestTracker.QuestTypeToFilter [type]]
					if (isEnabled) then
						GameCooltip:AddLine (info.name)
						GameCooltip:AddIcon (info.icon, 1, 1, 16, 16, unpack (info.coords))
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-MicroStream-Yellow]], 1, 2, 16, 16, 0, 1, 1, 0, overlayColor, nil, true)
					else
						GameCooltip:AddLine (info.name, _, _, "silver")
						local l, r, t, b = unpack (info.coords)
						GameCooltip:AddIcon (info.icon, 1, 1, 16, 16, l, r, t, b, _, _, true)
					end
					
					GameCooltip:AddMenu (1, change_sort_mode, type)
				end

			end
			
			sortButton.CoolTip = {
				Type = "menu",
				BuildFunc = BuildSortMenu, --> called when user mouse over the frame
				OnEnterFunc = function (self) 
					sortButton.button_mouse_over = true
					button_onenter (self)
				end,
				OnLeaveFunc = function (self) 
					sortButton.button_mouse_over = false
					button_onleave (self)
				end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = function()
				
					if (WorldQuestTracker.db.profile.bar_anchor == "top") then
						GameCooltip:SetOption ("MyAnchor", "top")
						GameCooltip:SetOption ("RelativeAnchor", "bottom")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", -10)
					else
						GameCooltip:SetOption ("MyAnchor", "bottom")
						GameCooltip:SetOption ("RelativeAnchor", "top")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", 0)
					end				
				
				end
			}
			
			GameCooltip:CoolTipInject (sortButton, openOnClick)
			
			---------------------------------------------------------
			
			-- ~filter
			local filterButton = CreateFrame ("button", "WorldQuestTrackerFilterButton", WorldQuestTracker.DoubleTapFrame)
			filterButton:SetPoint ("left", sortButton, "right", 2, 0)
			setup_button (filterButton, L["S_MAPBAR_FILTER"])
			
			local filter_quest_type = function (_, _, questType, _, _, mouseButton)
				WorldQuestTracker.db.profile.filters [questType] = not WorldQuestTracker.db.profile.filters [questType]
			
				GameCooltip:ExecFunc (filterButton)
				
				--atualiza as quests
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					WorldQuestTracker.UpdateZoneWidgets()
				end				
			end
			
			local toggle_faction_objectives = function()
				WorldQuestTracker.db.profile.filter_always_show_faction_objectives = not WorldQuestTracker.db.profile.filter_always_show_faction_objectives
				GameCooltip:ExecFunc (filterButton)
				
				--atualiza as quests
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					WorldQuestTracker.UpdateZoneWidgets()
				end	
			end
			
			local toggle_brokenshore_bypass = function()
				WorldQuestTracker.db.profile.filter_force_show_brokenshore = not WorldQuestTracker.db.profile.filter_force_show_brokenshore
				GameCooltip:ExecFunc (filterButton)
				--atualiza as quests
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					WorldQuestTracker.UpdateZoneWidgets()
				end
			end
			
			local BuildFilterMenu = function()
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 180)
				GameCooltip:SetOption ("FixedWidthSub", 200)
				GameCooltip:SetOption ("SubMenuIsTooltip", true)
				GameCooltip:SetOption ("IgnoreArrows", true)

				local t = {}
				for filterType, canShow in pairs (WorldQuestTracker.db.profile.filters) do
					local sortIndex = WorldQuestTracker.db.profile.sort_order [WorldQuestTracker.FilterToQuestType [filterType]]
					tinsert (t, {filterType, sortIndex})
				end
				table.sort (t, function(a, b) return a[2] > b[2] end)
				
				for i, filter in ipairs (t) do
					local filterType = filter [1]
					local info = WorldQuestTracker.MapData.QuestTypeIcons [WorldQuestTracker.FilterToQuestType [filterType]]
					local isEnabled = WorldQuestTracker.db.profile.filters [filterType]
					if (isEnabled) then
						GameCooltip:AddLine (info.name)
						GameCooltip:AddIcon (info.icon, 1, 1, 16, 16, unpack (info.coords))
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 2, 16, 16, 0, 1, 0, 1, overlayColor, nil, true)
					else
						GameCooltip:AddLine (info.name, _, _, "silver")
						local l, r, t, b = unpack (info.coords)
						GameCooltip:AddIcon (info.icon, 1, 1, 16, 16, l, r, t, b, _, _, true)
					end
					GameCooltip:AddMenu (1, filter_quest_type, filterType)
				end
				
				GameCooltip:AddLine ("$div")
				
				local l, r, t, b = unpack (WorldQuestTracker.MapData.GeneralIcons.CRITERIA.coords)
				
				if (WorldQuestTracker.db.profile.filter_always_show_faction_objectives) then
					GameCooltip:AddLine (L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES"])
					GameCooltip:AddLine (L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES_DESC"], "", 2)
					GameCooltip:AddIcon (WorldQuestTracker.MapData.GeneralIcons.CRITERIA.icon, 1, 1, 23*.54, 37*.40, l, r, t, b)
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 2, 16, 16, 0, 1, 0, 1, overlayColor, nil, true)
				else
					GameCooltip:AddLine (L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES"], "", 1, "silver")
					GameCooltip:AddLine (L["S_MAPBAR_FILTERMENU_FACTIONOBJECTIVES_DESC"], "", 2)
					GameCooltip:AddIcon (WorldQuestTracker.MapData.GeneralIcons.CRITERIA.icon, 1, 1, 23*.54, 37*.40, l, r, t, b, nil, nil, true)
				end
				GameCooltip:AddMenu (1, toggle_faction_objectives)
				
				GameCooltip:AddLine ("$div")
				
				--[=[ --this is deprecated at the moment, but might be needed again in the future
				if (WorldQuestTracker.db.profile.filter_force_show_brokenshore) then
					GameCooltip:AddLine ("Ignore Argus")
					GameCooltip:AddLine ("World quets on Argus map will always be shown.", "", 2)
					GameCooltip:AddIcon ([[Interface\ICONS\70_inscription_vantus_rune_tomb]], 1, 1, 23*.54, 37*.40, 0, 1, 0, 1)
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 2, 16, 16, 0, 1, 0, 1, overlayColor, nil, true)
				else
					GameCooltip:AddLine ("Ignore Argus", "", 1, "silver")
					GameCooltip:AddLine ("World quets on Argus map will always be shown.", "", 2)
					GameCooltip:AddIcon (WQT_GENERAL_STRINGS_AND_ICONS.criteria.icon, 1, 1, 23*.54, 37*.40, l, r, t, b, nil, nil, true)
				end
				GameCooltip:AddMenu (1, toggle_brokenshore_bypass)
				--]=]
			end
			
			filterButton.CoolTip = {
				Type = "menu",
				BuildFunc = BuildFilterMenu, --> called when user mouse over the frame
				OnEnterFunc = function (self) 
					filterButton.button_mouse_over = true
					button_onenter (self)
				end,
				OnLeaveFunc = function (self) 
					filterButton.button_mouse_over = false
					button_onleave (self)
				end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = function()
				
					if (WorldQuestTracker.db.profile.bar_anchor == "top") then
						GameCooltip:SetOption ("MyAnchor", "top")
						GameCooltip:SetOption ("RelativeAnchor", "bottom")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", -10)
					else
						GameCooltip:SetOption ("MyAnchor", "bottom")
						GameCooltip:SetOption ("RelativeAnchor", "top")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", 0)
					end				
				
				end,
			}
			
			GameCooltip:CoolTipInject (filterButton)
			
			---------------------------------------------------------
			-- ~time left
			
			local timeLeftButton = CreateFrame ("button", "WorldQuestTrackerTimeLeftButton", WorldQuestTracker.DoubleTapFrame)
			timeLeftButton:SetPoint ("left", filterButton, "right", 2, 0)
			setup_button (timeLeftButton, L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_TITLE"])
			
			
			local BuildTimeLeftMenu = function()
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 180)
				GameCooltip:SetOption ("FixedWidthSub", 200)
				GameCooltip:SetOption ("SubMenuIsTooltip", true)
				GameCooltip:SetOption ("IgnoreArrows", true)
				
				GameCooltip:AddLine (format (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"], 4))
				GameCooltip:AddMenu (1, change_sort_timeleft_mode, 4)
				if (WorldQuestTracker.db.profile.sort_time_priority == 4) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (format (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"], 8), "", 1)
				GameCooltip:AddMenu (1, change_sort_timeleft_mode, 8)
				if (WorldQuestTracker.db.profile.sort_time_priority == 8) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (format (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"], 12), "", 1)
				GameCooltip:AddMenu (1, change_sort_timeleft_mode, 12)
				if (WorldQuestTracker.db.profile.sort_time_priority == 12) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end

				GameCooltip:AddLine (format (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"], 16), "", 1)
				GameCooltip:AddMenu (1, change_sort_timeleft_mode, 16)
				if (WorldQuestTracker.db.profile.sort_time_priority == 16) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (format (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_OPTION"], 24), "", 1)
				GameCooltip:AddMenu (1, change_sort_timeleft_mode, 24)
				if (WorldQuestTracker.db.profile.sort_time_priority == 24) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine ("$div", nil, 1, nil, -5, -11)

				GameCooltip:AddLine (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_SHOWTEXT"], "", 1)
				GameCooltip:AddMenu (1, options_on_click, "show_timeleft", not WorldQuestTracker.db.profile.show_timeleft)
				if (WorldQuestTracker.db.profile.show_timeleft) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_FADE"], "", 1)
				GameCooltip:AddMenu (1, options_on_click, "alpha_time_priority", not WorldQuestTracker.db.profile.alpha_time_priority)
				if (WorldQuestTracker.db.profile.alpha_time_priority) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_SORTBYTIME"], "", 1)
				GameCooltip:AddMenu (1, options_on_click, "force_sort_by_timeleft", not WorldQuestTracker.db.profile.force_sort_by_timeleft)
				if (WorldQuestTracker.db.profile.force_sort_by_timeleft) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				
			end
			
			timeLeftButton.CoolTip = {
				Type = "menu",
				BuildFunc = BuildTimeLeftMenu, --> called when user mouse over the frame
				OnEnterFunc = function (self) 
					timeLeftButton.button_mouse_over = true
					button_onenter (self)
				end,
				OnLeaveFunc = function (self) 
					timeLeftButton.button_mouse_over = false
					button_onleave (self)
				end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = function()
				
					if (WorldQuestTracker.db.profile.bar_anchor == "top") then
						GameCooltip:SetOption ("MyAnchor", "top")
						GameCooltip:SetOption ("RelativeAnchor", "bottom")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", -10)
					else
						GameCooltip:SetOption ("MyAnchor", "bottom")
						GameCooltip:SetOption ("RelativeAnchor", "top")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", 0)
					end				
				
				end,
			}
			
			GameCooltip:CoolTipInject (timeLeftButton)			
			
			---------------------------------------------------------
			
			function WorldQuestTracker.ShowHistoryTooltip (self)
				local _
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("ButtonsYMod", -2)
				GameCooltip:SetOption ("YSpacingMod", 3)
				GameCooltip:SetOption ("FixedHeight", 185)
				GameCooltip:AddLine (" ")
				GameCooltip:AddLine (L["S_MAPBAR_SUMMARYMENU_TODAYREWARDS"] .. ":", _, _, _, _, 12)
				
					if (WorldQuestTracker.db.profile.bar_anchor == "top") then
						GameCooltip:SetOption ("MyAnchor", "top")
						GameCooltip:SetOption ("RelativeAnchor", "bottom")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", -29)
					else
						GameCooltip:SetOption ("MyAnchor", "bottom")
						GameCooltip:SetOption ("RelativeAnchor", "top")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", 0)
					end				
				
				--~sumary
				button_onenter (self)
				
				local today = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_LOCAL, WQT_DATE_TODAY)
				today = today or {}
				
				GameCooltip:AddLine (L["S_QUESTTYPE_GOLD"] .. ":", today.gold and today.gold > 0 and GetCoinTextureString (today.gold) or 0, 1, "white", "orange")
				local texture, coords = WorldQuestTracker.GetGoldIcon()
				GameCooltip:AddIcon (texture, 1, 1, 16, 16)
				
				GameCooltip:AddLine (L["S_QUESTTYPE_RESOURCE"] .. ":", DF:CommaValue (today.resource or 0), 1, "white", "orange")
				GameCooltip:AddIcon ([[Interface\AddOns\WorldQuestTracker\media\resource_iconT]], 1, 1, 14, 14)
				
				local artifactIcon = WorldQuestTracker.GetArtifactPowerIcon (100000, true)
				GameCooltip:AddLine (L["S_QUESTTYPE_ARTIFACTPOWER"] ..":", DF:CommaValue (today.artifact or 0), 1, "white", "orange")
				GameCooltip:AddIcon (artifactIcon, 1, 1, 16, 16)
				
				local quests_completed = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_LOCAL, WQT_DATE_TODAY, WQT_QUESTS_PERIOD)
				GameCooltip:AddLine (L["S_QUESTSCOMPLETED"] .. ":", quests_completed or 0, 1, "white", "orange")
				GameCooltip:AddIcon ([[Interface\GossipFrame\AvailableQuestIcon]], 1, 1, 16, 16)
				--
				GameCooltip:AddLine (" ")
				GameCooltip:AddLine (L["S_MAPBAR_SUMMARYMENU_ACCOUNTWIDE"] .. ":", _, _, _, _, 12)
				--GameCooltip:AddLine (" ")
				
				local today_account = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_ACCOUNT, WQT_DATE_TODAY)-- or {}
				today_account = today_account or {}
				
				GameCooltip:AddLine (L["S_QUESTTYPE_GOLD"] .. ":", today_account.gold and today_account.gold > 0 and GetCoinTextureString (today_account.gold) or 0, 1, "white", "orange")
				local texture, coords = WorldQuestTracker.GetGoldIcon()
				GameCooltip:AddIcon (texture, 1, 1, 16, 16)
				
				GameCooltip:AddLine (L["S_QUESTTYPE_RESOURCE"] .. ":", DF:CommaValue (today_account.resource or 0), 1, "white", "orange")
				GameCooltip:AddIcon ([[Interface\AddOns\WorldQuestTracker\media\resource_iconT]], 1, 1, 14, 14)
				
				local artifactIcon = WorldQuestTracker.GetArtifactPowerIcon (100000, true)
				GameCooltip:AddLine (L["S_QUESTTYPE_ARTIFACTPOWER"] ..":", DF:CommaValue (today_account.artifact or 0), 1, "white", "orange")
				GameCooltip:AddIcon (artifactIcon, 1, 1, 16, 16)
				
				local quests_completed = WorldQuestTracker.QueryHistory (WQT_QUERYTYPE_PERIOD, WQT_QUERYDB_ACCOUNT, WQT_DATE_TODAY, WQT_QUESTS_PERIOD)
				GameCooltip:AddLine (L["S_QUESTSCOMPLETED"] .. ":", quests_completed or 0, 1, "white", "orange")
				GameCooltip:AddIcon ([[Interface\GossipFrame\AvailableQuestIcon]], 1, 1, 16, 16)

				GameCooltip:AddLine (" ", "", 1, "green", _, 10)
				GameCooltip:AddLine (L["S_MAPBAR_SUMMARYMENU_MOREINFO"], "", 1, "green", _, 10)
				
				--WorldQuestTracker.GetCharInfo (guid)
				--lista de outros personagems:
				
				GameCooltip:AddLine (L["S_MAPBAR_SUMMARYMENU_REQUIREATTENTION"] .. ":", "", 2, _, _, 12)
				GameCooltip:AddLine (" ", "", 2, _, _, 12)
				
				local chrGuid = UnitGUID ("player")
				local timeCutOff = time() + (60*60*2.2)
				local subLines = 1
				--[
				for guid, trackTable in pairs (WorldQuestTracker.db.profile.quests_tracked) do
					if (chrGuid ~= guid) then
						local requireAttention = false
						for i, questInfo in ipairs (trackTable) do
							if (timeCutOff > questInfo.expireAt) then
							
								local timeLeft = ((questInfo.expireAt - time()) / 60) --segundos / 60
								
								if (timeLeft > 0) then
									if (not requireAttention) then
										local name, realm, class = WorldQuestTracker.GetCharInfo (guid)
										local color = RAID_CLASS_COLORS [class]
										local name = name .. " - " .. realm
										if (color) then
											name = "|c" .. color.colorStr .. name .. "|r"
										end
										GameCooltip:AddLine (name, "", 2, _, _, 12)
										subLines = subLines + 1
										requireAttention = true
									end
									
									local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questInfo.questID)

									local rewardAmount = questInfo.rewardAmount
									if (questInfo.questType == QUESTTYPE_GOLD) then
										rewardAmount = floor (questInfo.rewardAmount / 10000)
									end
									local colorByRarity = ""

									if (rarity  == LE_WORLD_QUEST_QUALITY_EPIC) then
										colorByRarity = "FFC845F9"
									elseif (rarity  == LE_WORLD_QUEST_QUALITY_RARE) then
										colorByRarity = "FF0091F2"
									else
										colorByRarity = "FFFFFFFF"
									end
									GameCooltip:AddLine ("|cFFFFDD00[" .. rewardAmount .. "]|r |c" .. colorByRarity.. title .. "|r", SecondsToTime (timeLeft * 60), 2, "white", "orange", 10)-- .. "M" --(timeLeft > 60 and 60 or 1)
									GameCooltip:AddIcon (questInfo.rewardTexture, 2, 1)

									subLines = subLines + 1
								end
							end
						end
					end
				end
				--]]
				if (subLines == 1) then
					GameCooltip:AddLine (L["S_MAPBAR_SUMMARYMENU_NOATTENTION"], " ", 2, "gray", _, 10)
					GameCooltip:AddLine (" ", " ", 2)
				else
					GameCooltip:SetOption ("HeighModSub", max (185 - (subLines * 20), 0))
				end

				GameCooltip:SetOption ("SubMenuIsTooltip", true)
				GameCooltip:SetOption ("NoLastSelectedBar", true)
				
				GameCooltip:SetLastSelected ("main", 1)
				
				GameCooltip:SetOwner (rewardButton)
				GameCooltip:Show()
				
				GameCooltip:ShowSub (GameCooltip.Indexes)
			end
			
			local button_onLeave = function (self)
				GameCooltip:Hide()
				button_onleave (self)
			end
			
			--build option menu
			
			local BuildOptionsMenu = function() -- �ptions ~options
				GameCooltip:Preset (2)
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 160)
				
				local IconSize = 14
				
				--all tracker options ~tracker config
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKERCONFIG"])
				GameCooltip:AddIcon ([[Interface\AddOns\WorldQuestTracker\media\ArrowGridT]], 1, 1, IconSize, IconSize, 944/1024, 993/1024, 272/1024, 324/1024)
				
				--use quest tracker
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_QUESTTRACKER"], "", 2)
				if (WorldQuestTracker.db.profile.use_tracker) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "use_tracker", not WorldQuestTracker.db.profile.use_tracker)
				--
				GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
				--
				
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "0.8"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 0.8)				
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "1.0"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 1)
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "1.1"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 1.1)
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "1.2"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 1.2)
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "1.3"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 1.3)
				GameCooltip:AddLine (format (L["S_MAPBAR_OPTIONSMENU_TRACKER_SCALE"], "1.5"), "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_scale", 1.5)
				
				--
				GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
				--
				
				GameCooltip:AddLine ("Small Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_textsize", 12)
				GameCooltip:AddLine ("Medium Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_textsize", 13)
				GameCooltip:AddLine ("Large Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "tracker_textsize", 14)
				
				--
				GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
				--
				
				-- tracker movable
				--automatic
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_AUTO"], "", 2)
				if (not WorldQuestTracker.db.profile.tracker_is_movable) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "tracker_is_movable", false)
				--manual
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_CUSTOM"], "", 2)
				if (WorldQuestTracker.db.profile.tracker_is_movable) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "tracker_is_movable", true)
				--locked
				if (WorldQuestTracker.db.profile.tracker_is_movable) then
					GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_LOCKED"], "", 2)
				else
					GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKERMOVABLE_LOCKED"], "", 2, "gray")
				end
				if (WorldQuestTracker.db.profile.tracker_is_locked) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "tracker_is_locked", not WorldQuestTracker.db.profile.tracker_is_locked)
				--reset pos
				GameCooltip:AddLine ("Reset Position", "", 2)
				GameCooltip:AddMenu (2, function()
					options_on_click (_, _, "tracker_is_movable", false)
					C_Timer.After (0.5, function()
						options_on_click (_, _, "tracker_is_movable", true)
						LibWindow.SavePosition (WorldQuestTrackerScreenPanel)
					end)
				end)
				
				--				
				GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
				--
				
				--show yards distance on the tracker
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_YARDSDISTANCE"], "", 2)
				if (WorldQuestTracker.db.profile.show_yards_distance) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "show_yards_distance", not WorldQuestTracker.db.profile.show_yards_distance)				
				
				--only show quests on the current zone
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TRACKER_CURRENTZONE"], "", 2)
				if (WorldQuestTracker.db.profile.tracker_only_currentmap) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "tracker_only_currentmap", not WorldQuestTracker.db.profile.tracker_only_currentmap)

				GameCooltip:AddLine (L["S_MAPBAR_SORTORDER_TIMELEFTPRIORITY_TITLE"], "", 2)
				if (WorldQuestTracker.db.profile.tracker_show_time) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "tracker_show_time", not WorldQuestTracker.db.profile.tracker_show_time)

				--

				--World Map Config
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_WORLDMAPCONFIG"])
				GameCooltip:AddIcon ([[Interface\Worldmap\UI-World-Icon]], 1, 1, IconSize, IconSize)

				GameCooltip:AddLine ("Disable Icons on World Map", "", 2)
				if (WorldQuestTracker.db.profile.disable_world_map_widgets) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "disable_world_map_widgets", not WorldQuestTracker.db.profile.disable_world_map_widgets)
				GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
				
				
				GameCooltip:AddLine ("Small Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "textsize", 9)
				GameCooltip:AddLine ("Medium Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "textsize",  10)
				GameCooltip:AddLine ("Large Text Size", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "textsize",  11)
				
				GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
				
				GameCooltip:AddLine ("Scale - Small", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "scale", 1)
				GameCooltip:AddLine ("Scale - Medium", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "scale",  1.2)
				GameCooltip:AddLine ("Scale - Big", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "scale",  1.4)
				GameCooltip:AddLine ("Scale - Very Big", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "world_map_config", "scale",  1.6)
				
				--Zone Map Config
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ZONEMAPCONFIG"])
				GameCooltip:AddIcon ([[Interface\Worldmap\WorldMap-Icon]], 1, 1, IconSize, IconSize)
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ZONE_QUESTSUMMARY"], "", 2)
				if (WorldQuestTracker.db.profile.use_quest_summary) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "use_quest_summary", not WorldQuestTracker.db.profile.use_quest_summary)
				
				GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
				
				GameCooltip:AddLine ("Small Quest Icons", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "zone_map_config", "scale", 1)
				GameCooltip:AddLine ("Medium Quest Icons", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "zone_map_config", "scale",  1.15)
				GameCooltip:AddLine ("Large Quest Icons", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "zone_map_config", "scale",  1.23)
				GameCooltip:AddLine ("Very Large Quest Icons", "", 2)
				GameCooltip:AddMenu (2, options_on_click, "zone_map_config", "scale",  1.35)
				
				GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
				
				GameCooltip:AddLine ("Only Tracked", "", 2)
				if (WorldQuestTracker.db.profile.zone_only_tracked) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (2, options_on_click, "zone_only_tracked", not WorldQuestTracker.db.profile.zone_only_tracked)
				
				do
					--group finder config
					GameCooltip:AddLine (L["S_GROUPFINDER_TITLE"])
					GameCooltip:AddIcon ([[Interface\LFGFRAME\BattlenetWorking1]], 1, 1, IconSize, IconSize, .22, .78, .22, .78)
					
					--enabled
					GameCooltip:AddLine (L["S_GROUPFINDER_ENABLED"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.enabled) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetEnabledFunc, not WorldQuestTracker.db.profile.groupfinder.enabled)
					
					--find group for rares
					GameCooltip:AddLine (L["S_GROUPFINDER_AUTOOPEN_RARENPC_TARGETED"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.search_group) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetFindGroupForRares, not WorldQuestTracker.db.profile.rarescan.search_group)						

					--uses buttons on the quest tracker
					GameCooltip:AddLine (L["S_GROUPFINDER_OT_ENABLED"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.tracker_buttons) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetOTButtonsFunc, not WorldQuestTracker.db.profile.groupfinder.tracker_buttons)					
					
					--
					GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
					
					GameCooltip:AddLine ("Send Invite Whispers", "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.send_whispers) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SendWhispersFunc, not WorldQuestTracker.db.profile.groupfinder.send_whispers)
					
					GameCooltip:AddLine ("Don't Show if Already in Group", "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.dont_open_in_group) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.AlreadyInGroupFunc, not WorldQuestTracker.db.profile.groupfinder.dont_open_in_group)
					
					--
					GameCooltip:AddLine ("$div", nil, 2, nil, -7, -14)
					
					--leave group
					GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_IMMEDIATELY"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave, "autoleave")
					
					GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_AFTERX"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.autoleave_delayed) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave_delayed, "autoleave_delayed")
					
					GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_ASKX"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.askleave_delayed) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.askleave_delayed, "askleave_delayed")
					
					GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_DONTLEAVE"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.noleave) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.noleave, "noleave")					
					
					--
					GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
					--ask to leave with timeout
					GameCooltip:AddLine ("10 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 10) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 10)
					
					GameCooltip:AddLine ("15 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 15) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 15)
					
					GameCooltip:AddLine ("20 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 20) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 20)
					
					GameCooltip:AddLine ("30 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 30) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 30)
					
					GameCooltip:AddLine ("60 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
					if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 60) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 60)
					
					GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
					
				end
				
				--rare finder
					GameCooltip:AddLine (L["S_RAREFINDER_TITLE"])
					GameCooltip:AddIcon ([[Interface\Collections\Collections]], 1, 1, IconSize, IconSize, 101/512, 116/512, 12/512, 26/512)

					--enabled
					GameCooltip:AddLine (L["S_RAREFINDER_OPTIONS_SHOWICONS"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.show_icons) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "show_icons", not WorldQuestTracker.db.profile.rarescan.show_icons)	

					--english only
					GameCooltip:AddLine (L["S_RAREFINDER_OPTIONS_ENGLISHSEARCH"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.always_use_english) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "always_use_english", not WorldQuestTracker.db.profile.rarescan.always_use_english)	
					 
					GameCooltip:AddLine (L["S_RAREFINDER_ADDFROMPREMADE"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.add_from_premade) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "add_from_premade", not WorldQuestTracker.db.profile.rarescan.add_from_premade)	

					GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
					
					--play audion on spot a rare
					GameCooltip:AddLine (L["S_RAREFINDER_SOUND_ENABLED"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.playsound) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "playsound", not WorldQuestTracker.db.profile.rarescan.playsound)
					
					GameCooltip:AddLine ("Volume: 100%", "", 2)
					if (WorldQuestTracker.db.profile.rarescan.playsound_volume == 1) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "playsound_volume", 1)
					
					GameCooltip:AddLine ("Volume: 50%", "", 2)
					if (WorldQuestTracker.db.profile.rarescan.playsound_volume == 2) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "playsound_volume", 2)

					GameCooltip:AddLine ("Volume: 30%", "", 2)
					if (WorldQuestTracker.db.profile.rarescan.playsound_volume == 3) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "playsound_volume", 3)
					
					GameCooltip:AddLine (L["S_RAREFINDER_SOUND_ALWAYSPLAY"], "", 2)
					if (WorldQuestTracker.db.profile.rarescan.use_master) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					GameCooltip:AddMenu (2, options_on_click, "rarescan", "use_master", not WorldQuestTracker.db.profile.rarescan.use_master)

				-- other options
				GameCooltip:AddLine ("$div")
				--
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_SOUNDENABLED"])
				if (WorldQuestTracker.db.profile.sound_enabled) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (1, options_on_click, "sound_enabled", not WorldQuestTracker.db.profile.sound_enabled)
				--
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_EQUIPMENTICONS"])
				if (WorldQuestTracker.db.profile.use_old_icons) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (1, options_on_click, "use_old_icons", not WorldQuestTracker.db.profile.use_old_icons)
				--
				GameCooltip:AddLine (L["S_MAPBAR_AUTOWORLDMAP"])
				if (WorldQuestTracker.db.profile.enable_doubletap) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (1, options_on_click, "enable_doubletap", not WorldQuestTracker.db.profile.enable_doubletap)
				--
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_STATUSBARANCHOR"])
				if (WorldQuestTracker.db.profile.bar_anchor == "top") then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
				end
				GameCooltip:AddMenu (1, options_on_click, "bar_anchor", WorldQuestTracker.db.profile.bar_anchor == "bottom" and "top" or "bottom")
				--

				GameCooltip:AddLine ("$div")
				--
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ARROWSPEED"])
				GameCooltip:AddIcon ([[Interface\AddOns\WorldQuestTracker\media\ArrowFrozen]], 1, 1, IconSize, IconSize, .15, .8, .15, .80)
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_REALTIME"], "", 2)
				GameCooltip:AddMenu (2, options_on_click, "arrow_update_speed", 0.016)
				if (WorldQuestTracker.db.profile.arrow_update_frequence < 0.017) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_HIGH"], "", 2)
				GameCooltip:AddMenu (2, options_on_click, "arrow_update_speed", 0.03)
				if (WorldQuestTracker.db.profile.arrow_update_frequence < 0.032 and WorldQuestTracker.db.profile.arrow_update_frequence > 0.029) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_MEDIUM"], "", 2)
				GameCooltip:AddMenu (2, options_on_click, "arrow_update_speed", 0.075)
				if (WorldQuestTracker.db.profile.arrow_update_frequence < 0.076 and WorldQuestTracker.db.profile.arrow_update_frequence > 0.074) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_ARROWSPEED_SLOW"], "", 2)
				GameCooltip:AddMenu (2, options_on_click, "arrow_update_speed", 0.1)
				if (WorldQuestTracker.db.profile.arrow_update_frequence < 0.11 and WorldQuestTracker.db.profile.arrow_update_frequence > 0.099) then
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
				else
					GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
				end
				
				--
				if (TomTom and IsAddOnLoaded ("TomTom")) then
					GameCooltip:AddLine ("$div")
					
					GameCooltip:AddLine ("TomTom")
					GameCooltip:AddIcon ([[Interface\AddOns\TomTom\Images\Arrow.blp]], 1, 1, 16, 14, 0, 56/512, 0, 43/512, "lightgreen")
					
					GameCooltip:AddLine (L["S_ENABLED"], "", 2)
					GameCooltip:AddMenu (2, options_on_click, "tomtom-enabled", not WorldQuestTracker.db.profile.tomtom.enabled)
					if (WorldQuestTracker.db.profile.tomtom.enabled) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
					
					GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_TOMTOM_WPPERSISTENT"], "", 2)
					GameCooltip:AddMenu (2, options_on_click, "tomtom-persistent", not WorldQuestTracker.db.profile.tomtom.persistent)
					if (WorldQuestTracker.db.profile.tomtom.persistent) then
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
					else
						GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
					end
				end
				--
				
				GameCooltip:AddLine ("$div")
				
				--
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_REFRESH"])
				GameCooltip:AddMenu (1, options_on_click, "clear_quest_cache", true)
				GameCooltip:AddIcon ([[Interface\GLUES\CharacterSelect\CharacterUndelete]], 1, 1, IconSize, IconSize, .2, .8, .2, .8)
				--
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_UNTRACKQUESTS"])
				GameCooltip:AddMenu (1, options_on_click, "untrack_quests", true)
				GameCooltip:AddIcon ([[Interface\BUTTONS\UI-GROUPLOOT-PASS-HIGHLIGHT]], 1, 1, IconSize, IconSize)
				
				GameCooltip:AddLine ("$div")
			
				GameCooltip:AddLine (L["S_MAPBAR_OPTIONSMENU_SHARE"])
				GameCooltip:AddIcon ("Interface\\FriendsFrame\\WowshareTextures.BLP", nil, 1, 14, 11, 122/256, 138/256, 167/256, 180/256)
				GameCooltip:AddMenu (1, options_on_click, "share_addon", true)
				--
				
				GameCooltip:SetOption ("IconBlendMode", "ADD")
				GameCooltip:SetOption ("SubFollowButton", true)

				--
			end
			
			optionsButton.CoolTip = {
				Type = "menu",
				BuildFunc = BuildOptionsMenu, --> called when user mouse over the frame
				OnEnterFunc = function (self) 
					optionsButton.button_mouse_over = true
					button_onenter (self)
				end,
				OnLeaveFunc = function (self) 
					optionsButton.button_mouse_over = false
					button_onleave (self)
				end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = function()
					if (WorldQuestTracker.db.profile.bar_anchor == "top") then
						GameCooltip:SetOption ("MyAnchor", "top")
						GameCooltip:SetOption ("RelativeAnchor", "bottom")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", -10)
					else
						GameCooltip:SetOption ("MyAnchor", "bottom")
						GameCooltip:SetOption ("RelativeAnchor", "top")
						GameCooltip:SetOption ("WidthAnchorMod", 0)
						GameCooltip:SetOption ("HeightAnchorMod", 0)
					end
				end
			}
			
			GameCooltip:CoolTipInject (optionsButton)
			
			--> options on the interface menu
			WorldQuestTracker.OptionsInterfaceMenu = CreateFrame ("frame", "WorldQuestTrackerInterfaceOptionsPanel", UIParent)
			WorldQuestTracker.OptionsInterfaceMenu.name = L["World Quest Tracker"]
			InterfaceOptions_AddCategory (WorldQuestTracker.OptionsInterfaceMenu)
			
			WorldQuestTracker.OptionsInterfaceMenu.options_button = CreateFrame ("button", nil, WorldQuestTracker.OptionsInterfaceMenu, "OptionsButtonTemplate")
			WorldQuestTracker.OptionsInterfaceMenu.options_button:SetText ("Hover Over Me: Options Menu")
			WorldQuestTracker.OptionsInterfaceMenu.options_button:SetPoint ("topleft", WorldQuestTracker.OptionsInterfaceMenu, "topleft", 100, -300)
			WorldQuestTracker.OptionsInterfaceMenu.options_button:SetWidth (270)
			
			WorldQuestTracker.OptionsInterfaceMenu.options_button.CoolTip = {
				Type = "menu",
				BuildFunc = BuildOptionsMenu, --> called when user mouse over the frame
				OnEnterFunc = function (self) 
					WorldQuestTracker.OptionsInterfaceMenu.options_button.button_mouse_over = true
					button_onenter (self)
				end,
				OnLeaveFunc = function (self) 
					WorldQuestTracker.OptionsInterfaceMenu.options_button.button_mouse_over = false
					button_onleave (self)
				end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = function()
				
				
				
				end
			}
			
			GameCooltip:CoolTipInject (WorldQuestTracker.OptionsInterfaceMenu.options_button)			
			
			
			rewardButton:SetScript ("OnEnter", WorldQuestTracker.ShowHistoryTooltip)
			rewardButton:SetScript ("OnLeave", button_onLeave)
			
			local ResourceFontTemplate = DF:GetTemplate ("font", "WQT_RESOURCES_AVAILABLE")	

			--> party members ~party
			
		-----------
			--recursos dispon�veis
			local xOffset = 35
			
			-- ~resources ~recursos
			local resource_GoldIcon = DF:CreateImage (WorldQuestTracker.DoubleTapFrame, [[Interface\AddOns\WorldQuestTracker\media\icons_resourcesT]], 16, 16, "overlay", {64/128, 96/128, 0, .25})
			resource_GoldIcon:SetDrawLayer ("overlay", 7)
			resource_GoldIcon:SetAlpha (.78)
			local resource_GoldText = DF:CreateLabel (WorldQuestTracker.DoubleTapFrame, "", ResourceFontTemplate)
			
			local resource_ResourcesIcon = DF:CreateImage (WorldQuestTracker.DoubleTapFrame, [[Interface\AddOns\WorldQuestTracker\media\icons_resourcesT]], 16, 16, "overlay", {0, 32/128, 0, .25})
			resource_ResourcesIcon:SetDrawLayer ("overlay", 7)
			resource_ResourcesIcon:SetAlpha (.78)
			local resource_ResourcesText = DF:CreateLabel (WorldQuestTracker.DoubleTapFrame, "", ResourceFontTemplate)

			local resource_APowerIcon = DF:CreateImage (WorldQuestTracker.DoubleTapFrame, [[Interface\AddOns\WorldQuestTracker\media\icons_resourcesT]], 16, 16, "overlay", {32/128, 64/128, 0, .25})
			resource_APowerIcon:SetDrawLayer ("overlay", 7)
			resource_APowerIcon:SetAlpha (.78)
			local resource_APowerText = DF:CreateLabel (WorldQuestTracker.DoubleTapFrame, "", ResourceFontTemplate)
		
			--resource_APowerText:SetPoint ("bottomright", WorldQuestButton, "bottomleft", -10, 2)
			resource_APowerText:SetPoint ("bottomright", AllianceWorldQuestButton, "bottomleft", -10, 3)
			resource_APowerIcon:SetPoint ("right", resource_APowerText, "left", -2, 0)
			resource_ResourcesText:SetPoint ("right", resource_APowerIcon, "left", -10, 0)
			resource_ResourcesIcon:SetPoint ("right", resource_ResourcesText, "left", -2, 0)
			resource_GoldText:SetPoint ("right", resource_ResourcesIcon, "left", -10, 0)
			resource_GoldIcon:SetPoint ("right", resource_GoldText, "left", -2, 0)

			WorldQuestTracker.IndicatorsAnchor = resource_APowerText
			WorldQuestTracker.WorldMap_GoldIndicator = resource_GoldText
			WorldQuestTracker.WorldMap_ResourceIndicator = resource_ResourcesText
			WorldQuestTracker.WorldMap_APowerIndicator = resource_APowerText

			-- ~trackall
			local TrackAllFromType = function (self)
				local mapID
				if (mapType == "zone") then
					mapID = WorldQuestTracker.GetCurrentMapAreaID()
				end
			
				local mapType = WorldQuestTrackerAddon.GetCurrentZoneType()
				if (mapType == "zone") then
					local qType = self.QuestType
					if (qType == "gold") then
						qType = QUESTTYPE_GOLD
					elseif (qType == "resource") then
						qType = QUESTTYPE_RESOURCE
					elseif (qType == "apower") then
						qType = QUESTTYPE_ARTIFACTPOWER
					end

					local widgets = WorldQuestTracker.Cache_ShownWidgetsOnZoneMap
					for _, widget in ipairs (widgets) do
						if (widget.QuestType == qType) then
							WorldQuestTracker.AddQuestToTracker (widget)
							if (widget.onEndTrackAnimation:IsPlaying()) then
								widget.onEndTrackAnimation:Stop()
							end
							widget.onStartTrackAnimation:Play()
						end
					end

					if (WorldQuestTracker.db.profile.sound_enabled) then
						if (math.random (2) == 1) then
							PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker_mass1.mp3")
						else
							PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker_mass2.mp3")
						end
					end
					WorldQuestTracker.UpdateZoneWidgets()
				end
				
				if (mapType == "world") then
					local questType = self.QuestType
					local questsAvailable = WorldQuestTracker.Cache_ShownQuestOnWorldMap [questType]

					if (questsAvailable) then
						for i = 1, #questsAvailable do
							local questID = questsAvailable [i]
							--> track this quest
							local widget = WorldQuestTracker.GetWorldWidgetForQuest (questID)
							
							if (widget) then
								WorldQuestTracker.AddQuestToTracker (widget)
								if (widget.onEndTrackAnimation:IsPlaying()) then
									widget.onEndTrackAnimation:Stop()
								end
								widget.onStartTrackAnimation:Play()
							end
						end
						
						if (WorldQuestTracker.db.profile.sound_enabled) then
							if (math.random (2) == 1) then
								PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker_mass1.mp3")
							else
								PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker_mass2.mp3")
							end
						end
						WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true, false)
					end
				end
			end
			
			local resource_GoldFrame = CreateFrame ("button", nil, WorldQuestTracker.DoubleTapFrame)
			resource_GoldFrame.QuestType = WQT_QUESTTYPE_GOLD
			resource_GoldFrame:SetScript ("OnClick", TrackAllFromType)
			
			local resource_ResourcesFrame = CreateFrame ("button", nil, WorldQuestTracker.DoubleTapFrame)
			resource_ResourcesFrame.QuestType = WQT_QUESTTYPE_RESOURCE
			resource_ResourcesFrame:SetScript ("OnClick", TrackAllFromType)
			
			local resource_APowerFrame = CreateFrame ("button", nil, WorldQuestTracker.DoubleTapFrame)
			resource_APowerFrame.QuestType = WQT_QUESTTYPE_APOWER
			resource_APowerFrame:SetScript ("OnClick", TrackAllFromType)
			
			local shadow = WorldQuestTracker.DoubleTapFrame:CreateTexture (nil, "background")
			shadow:SetPoint ("left", resource_GoldIcon.widget, "left", 2, 0)
			shadow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
			shadow:SetSize (58, 10)
			shadow:SetAlpha (.3)
			local shadow = WorldQuestTracker.DoubleTapFrame:CreateTexture (nil, "background")
			shadow:SetPoint ("left", resource_ResourcesIcon.widget, "left", 2, 0)
			shadow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
			shadow:SetSize (58, 10)
			shadow:SetAlpha (.3)
			local shadow = WorldQuestTracker.DoubleTapFrame:CreateTexture (nil, "background")
			shadow:SetPoint ("left", resource_APowerIcon.widget, "left", 2, 0)
			shadow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
			shadow:SetSize (58, 10)
			shadow:SetAlpha (.3)
			
			resource_GoldFrame:SetSize (55, 20)
			resource_ResourcesFrame:SetSize (55, 20)
			resource_APowerFrame:SetSize (55, 20)
			
			resource_GoldFrame:SetPoint ("left", resource_GoldIcon.widget, "left", -2, 0)
			resource_ResourcesFrame:SetPoint ("left", resource_ResourcesIcon.widget, "left", -2, 0)
			resource_APowerFrame:SetPoint ("left", resource_APowerIcon.widget, "left", -2, 0)
			
			resource_GoldFrame:SetScript ("OnEnter", function (self)
				resource_GoldText.textcolor = "WQT_ORANGE_ON_ENTER"

				GameCooltip:Preset (2)
				GameCooltip:SetType ("tooltip")
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 220)
				
				if (WorldQuestTracker.db.profile.bar_anchor == "top") then
					GameCooltip:SetOption ("MyAnchor", "top")
					GameCooltip:SetOption ("RelativeAnchor", "bottom")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", -29)
				else
					GameCooltip:SetOption ("MyAnchor", "bottom")
					GameCooltip:SetOption ("RelativeAnchor", "top")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", 0)
				end
				
				GameCooltip:AddLine (L["S_QUESTTYPE_GOLD"])
				GameCooltip:AddIcon (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_GOLD].icon, 1, 1, 20, 20)
				
				GameCooltip:AddLine ("", "", 1, "green", _, 10)
				GameCooltip:AddLine (format (L["S_MAPBAR_RESOURCES_TOOLTIP_TRACKALL"], L["S_QUESTTYPE_GOLD"]), "", 1, "green", _, 10)
				
				GameCooltip:SetOwner (self)
				GameCooltip:Show(self)
			end)
			
			resource_ResourcesFrame:SetScript ("OnEnter", function (self)
				resource_ResourcesText.textcolor = "WQT_ORANGE_ON_ENTER"
				
				GameCooltip:Preset (2)
				GameCooltip:SetType ("tooltip")
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 220)
				
				if (WorldQuestTracker.db.profile.bar_anchor == "top") then
					GameCooltip:SetOption ("MyAnchor", "top")
					GameCooltip:SetOption ("RelativeAnchor", "bottom")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", -29)
				else
					GameCooltip:SetOption ("MyAnchor", "bottom")
					GameCooltip:SetOption ("RelativeAnchor", "top")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", 0)
				end				
				
				GameCooltip:AddLine (L["S_QUESTTYPE_RESOURCE"])
				GameCooltip:AddIcon (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_RESOURCE].icon, 1, 1, 20, 20)
				
				GameCooltip:AddLine ("", "", 1, "green", _, 10)
				GameCooltip:AddLine (format (L["S_MAPBAR_RESOURCES_TOOLTIP_TRACKALL"], L["S_QUESTTYPE_RESOURCE"]), "", 1, "green", _, 10)
				
				GameCooltip:SetOwner (self)
				GameCooltip:Show(self)
			end)
			
			resource_APowerFrame:SetScript ("OnEnter", function (self)
				resource_APowerText.textcolor = "WQT_ORANGE_ON_ENTER"
				
				GameCooltip:Preset (2)
				GameCooltip:SetType ("tooltipbar")
				GameCooltip:SetOption ("TextSize", 10)
				GameCooltip:SetOption ("FixedWidth", 220)
				GameCooltip:SetOption ("StatusBarTexture", [[Interface\RaidFrame\Raid-Bar-Hp-Fill]])
				
				if (WorldQuestTracker.db.profile.bar_anchor == "top") then
					GameCooltip:SetOption ("MyAnchor", "top")
					GameCooltip:SetOption ("RelativeAnchor", "bottom")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", -29)
				else
					GameCooltip:SetOption ("MyAnchor", "bottom")
					GameCooltip:SetOption ("RelativeAnchor", "top")
					GameCooltip:SetOption ("WidthAnchorMod", 0)
					GameCooltip:SetOption ("HeightAnchorMod", 0)
				end
				
				GameCooltip:AddLine (L["S_QUESTTYPE_ARTIFACTPOWER"])
				GameCooltip:AddIcon (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_APOWER].icon, 1, 1, 20, 20)
				
				--8.0 deprecated
				--local itemID, altItemID, name, icon, totalXP, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop = C_ArtifactUI.GetEquippedArtifactInfo()
				--if (itemID and WorldQuestTracker.WorldMap_APowerIndicator.Amount) then
				
					--7.2 need to get the artifact tier
					--local artifactItemID, _, _, _, artifactTotalXP, artifactPointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
					--then request the xp details
					--local numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP (pointsSpent, totalXP, artifactTier)

					--local Available_APower = WorldQuestTracker.WorldMap_APowerIndicator.Amount / xpForNextPoint * 100
					--local diff = xpForNextPoint - xp
					--local Diff_APower = WorldQuestTracker.WorldMap_APowerIndicator.Amount / diff * 100
					
					--GameCooltip:AddLine (L["S_APOWER_AVAILABLE"], L["S_APOWER_NEXTLEVEL"], 1, 1, 1, 1, 1, 1, 1, 1, 1, nil, nil, "OUTLINE")
					
					--GameCooltip:AddStatusBar (math.min (Available_APower, 100), 1, 0.9019, 0.7999, 0.5999, .85, true, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture = [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]]})
					--GameCooltip:AddStatusBar (math.min (Diff_APower, 100), 1, 0.9019, 0.7999, 0.5999, .85, true, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture = [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]]})
					--GameCooltip:AddLine (DF:CommaValue (WorldQuestTracker.WorldMap_APowerIndicator.Amount), DF:CommaValue (xpForNextPoint), 1, "white", "white")
					--GameCooltip:AddLine (DF:CommaValue (WorldQuestTracker.WorldMap_APowerIndicator.Amount), "", 1, "white", "white")
					--statusbarValue, frame, ColorR, ColorG, ColorB, ColorA, statusbarGlow, backgroundBar, barTexture
					--print (xp, xpForNextPoint)
				--end

				GameCooltip:AddLine ("", "", 1, "green", _, 10)
				GameCooltip:AddLine (format (L["S_MAPBAR_RESOURCES_TOOLTIP_TRACKALL"], L["S_QUESTTYPE_ARTIFACTPOWER"]), "", 1, "green", _, 10)
				GameCooltip:SetOption ("LeftTextHeight", 22)
				GameCooltip:SetOwner (self)
				GameCooltip:Show(self)
			end)
			
			local resource_IconsOnLeave = function (self)
				GameCooltip:Hide()
				resource_GoldText.textcolor = "WQT_ORANGE_RESOURCES_AVAILABLE"
				resource_ResourcesText.textcolor = "WQT_ORANGE_RESOURCES_AVAILABLE"
				resource_APowerText.textcolor = "WQT_ORANGE_RESOURCES_AVAILABLE"
			end
			
			resource_GoldFrame:SetScript ("OnLeave", resource_IconsOnLeave)
			resource_ResourcesFrame:SetScript ("OnLeave", resource_IconsOnLeave)
			resource_APowerFrame:SetScript ("OnLeave", resource_IconsOnLeave)
			
			--------------
			
			--anima��o
			worldFramePOIs:SetScript ("OnShow", function()
				worldFramePOIs.fadeInAnimation:Play()
			end)
		end
	
		if (WorldQuestTracker.IsWorldQuestHub (WorldMapFrame.mapID)) then
			WorldQuestTracker.UpdateWorldQuestsOnWorldMap (false, true)
			
		else
			WorldQuestTracker.HideWorldQuestsOnWorldMap()
			
			--is zone map?
			if (WorldQuestTracker.ZoneHaveWorldQuest (WorldMapFrame.mapID)) then
				--roda nosso custom update e cria nossos proprios widgets
				WorldQuestTracker.UpdateZoneWidgets (true)
				C_Timer.After (1.35, function()
					if (WorldQuestTracker.ZoneHaveWorldQuest (WorldMapFrame.mapID)) then
						WorldQuestTracker.UpdateZoneWidgets (true)
					end
				end)
			end
			
		end

		-- ~tutorial
		WorldQuestTracker.ShowTutorialAlert()
		
	else
		WorldQuestTracker.NoAutoSwitchToWorldMap = nil
	end
end

hooksecurefunc ("ToggleWorldMap", WorldQuestTracker.OnToggleWorldMap)

WorldQuestTracker.CheckIfLoaded = function (self)
	if (not WorldQuestTracker.IsLoaded) then
		if (WorldMapFrame:IsShown()) then
			WorldQuestTracker.OnToggleWorldMap()
		end
	end
end

WorldMapFrame:HookScript ("OnShow", function()
	if (not WorldQuestTracker.IsLoaded) then
		C_Timer.After (0.5, WorldQuestTracker.CheckIfLoaded)
	end
end)



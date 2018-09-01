

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

local _

local p = math.pi/2
local pi = math.pi
local pipi = math.pi*2
local GetPlayerFacing = GetPlayerFacing

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

local LibWindow = LibStub ("LibWindow-1.1")
if (not LibWindow) then
	print ("|cFFFFAA00World Quest Tracker|r: libwindow not found, did you just updated the addon? try reopening the client.|r")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> tracker quest --~tracker

local TRACKER_TITLE_TEXT_SIZE_INMAP = 12
local TRACKER_TITLE_TEXT_SIZE_OUTMAP = 10
local TRACKER_TITLE_TEXTWIDTH_MAX = 185
local TRACKER_ARROW_ALPHA_MAX = 1
local TRACKER_ARROW_ALPHA_MIN = .75
local TRACKER_BACKGROUND_ALPHA_MIN = .35
local TRACKER_BACKGROUND_ALPHA_MAX = .75
local TRACKER_FRAME_ALPHA_INMAP = 1
local TRACKER_FRAME_ALPHA_OUTMAP = .75

local worldFramePOIs = WorldQuestTrackerWorldMapPOI

--verifica se a quest ja esta na lista de track
function WorldQuestTracker.IsQuestBeingTracked (questID)
	for _, quest in ipairs (WorldQuestTracker.QuestTrackList) do
		if (quest.questID == questID) then
			return true
		end
	end
	return
end


function WorldQuestTracker.AddQuestTomTom (questID, mapID, noRemove)
	local x, y = C_TaskQuest.GetQuestLocation (questID, mapID)
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
	
	--
	
	local alreadyExists = TomTom:WaypointExists (mapID, x, y, title)
	
	if (alreadyExists and WorldQuestTracker.db.profile.tomtom.uids [questID]) then
		if (noRemove) then
			return
		end
		TomTom:RemoveWaypoint (WorldQuestTracker.db.profile.tomtom.uids [questID])
		WorldQuestTracker.db.profile.tomtom.uids [questID] = nil
		return
	end
	
	if (not alreadyExists) then
		local uid = TomTom:AddWaypoint (mapID, x, y, {title = title, persistent=WorldQuestTracker.db.profile.tomtom.persistent})
		WorldQuestTracker.db.profile.tomtom.uids [questID] = uid
	end
	return
end

--adiciona uma quest ao tracker
function WorldQuestTracker.AddQuestToTracker (self, questID, mapID)
	
	questID = self.questID or questID
	
	if (not HaveQuestData (questID)) then
		WorldQuestTracker:Msg (L["S_ERROR_NOTLOADEDYET"])
		return
	end
	
	if (WorldQuestTracker.db.profile.tomtom.enabled and TomTom and IsAddOnLoaded ("TomTom")) then
		WorldQuestTracker.AddQuestTomTom (self.questID, self.mapID or mapID)
		return true
	end
	
	if (WorldQuestTracker.IsQuestBeingTracked (questID)) then
		return
	end
	
	local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
	if (timeLeft and timeLeft > 0) then
		local mapID = self.mapID
		local iconTexture = self.IconTexture
		local iconText = self.IconText
		local questType = self.QuestType
		local numObjectives = self.numObjectives
		
--		if (type (iconText) == "string") then --no good
--			iconText = iconText:gsub ("|c%x?%x?%x?%x?%x?%x?%x?%x?", "")
--			iconText = iconText:gsub ("|r", "")
--			iconText = tonumber (iconText)
--		end
--removing this, the reward amount can now be a number or a string, we cannot check for amount without checking first if is a number (on tracker only)
		
		if (iconTexture) then
			tinsert (WorldQuestTracker.QuestTrackList, {
				questID = questID, 
				mapID = mapID, 
				mapIDSynthetic = WorldQuestTracker.db.profile.syntheticMapIdList [mapID] or 0,
				timeAdded = time(), 
				timeFraction = GetTime(), 
				timeLeft = timeLeft, 
				expireAt = time() + (timeLeft*60), 
				rewardTexture = iconTexture, 
				rewardAmount = iconText, 
				index = #WorldQuestTracker.QuestTrackList,
				questType = questType,
				numObjectives = numObjectives,
			})
			WorldQuestTracker.JustAddedToTracker [questID] = true
		else
			WorldQuestTracker:Msg (L["S_ERROR_NOTLOADEDYET"])
		end
		
		--atualiza os widgets para adicionar a quest no frame do tracker
		WorldQuestTracker.RefreshTrackerWidgets()
	else
		WorldQuestTracker:Msg (L["S_ERROR_NOTIMELEFT"])
	end
end

--remove uma quest que ja esta no tracker
--quando o addon iniciar e fazer a primeira chacagem de quests desatualizadas, mandar noUpdate = true
function WorldQuestTracker.RemoveQuestFromTracker (questID, noUpdate)
	for index, quest in ipairs (WorldQuestTracker.QuestTrackList) do
		if (quest.questID == questID) then
			--remove da tabela
			tremove (WorldQuestTracker.QuestTrackList, index)
			--atualiza os widgets para remover a quest do frame do tracker
			if (not noUpdate) then
				WorldQuestTracker.RefreshTrackerWidgets()
			end
			return true
		end
	end
end

--remove todas as quests do tracker
function WorldQuestTracker.RemoveAllQuestsFromTracker()
	for i = #WorldQuestTracker.QuestTrackList, 1, -1 do
		local quest = WorldQuestTracker.QuestTrackList [i]
		local questID = quest.questID
		local widget = WorldQuestTracker.GetWorldWidgetForQuest (questID)
		if (widget) then
			if (widget.onStartTrackAnimation:IsPlaying()) then
				widget.onStartTrackAnimation:Stop()
			end
			widget.onEndTrackAnimation:Play()
		end
		--remove da tabela
		tremove (WorldQuestTracker.QuestTrackList, i)
	end
	
	WorldQuestTracker.RefreshTrackerWidgets()
	
	if (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
		WorldQuestTracker.UpdateWorldQuestsOnWorldMap()
	elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
		WorldQuestTracker.UpdateZoneWidgets()
	end
end

--o cliente n�o tem o tempo restante da quest na primeira execu��o
function WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load()
	for i = #WorldQuestTracker.QuestTrackList, 1, -1 do
		local quest = WorldQuestTracker.QuestTrackList [i]
		--if (HaveQuestData (quest.questID)) then
			local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (quest.questID)
		--end
	end
end

--verifica o tempo restante de cada quest no tracker e a remove se o tempo estiver terminado
function WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker()
	local now = time()
	local gotRemoval
	
	for i = #WorldQuestTracker.QuestTrackList, 1, -1 do
		local quest = WorldQuestTracker.QuestTrackList [i]
		local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (quest.questID)
		
		if (quest.expireAt < now or not timeLeft or timeLeft <= 0) then -- or not allQuests [quest.questID]
			--print ("removing", quest.expireAt, now, quest.expireAt < now, select (1, C_TaskQuest.GetQuestInfoByQuestID(quest.questID)))
			WorldQuestTracker.RemoveQuestFromTracker (quest.questID, true)
			gotRemoval = true
		end
	end
	if (gotRemoval) then
		WorldQuestTracker.RefreshTrackerWidgets()
	end
end



--organiza as quest para as quests do mapa atual serem jogadas para cima
local Sort_currentMapID = 0
local Sort_QuestsOnTracker = function (t1, t2)
	if (t1.mapID == Sort_currentMapID and t2.mapID == Sort_currentMapID) then
		return t1.LastDistance > t2.LastDistance
		--return t1.timeFraction > t2.timeFraction
	elseif (t1.mapID == Sort_currentMapID) then
		return true
	elseif (t2.mapID == Sort_currentMapID) then
		return false
	else
		if (t1.mapIDSynthetic == t2.mapIDSynthetic) then
			return t1.timeFraction > t2.timeFraction
		else
			return t1.mapIDSynthetic > t2.mapIDSynthetic
		end
	end
end

--poe as quests em ordem de acordo com o mapa atual do jogador?
function WorldQuestTracker.ReorderQuestsOnTracker()
	--joga as quests do mapa atual pra cima
	Sort_currentMapID = WorldQuestTracker.GetCurrentStandingMapAreaID()
	
--	if (Sort_currentMapID == 1080 or Sort_currentMapID == 1072) then
--		--Thunder Totem or Trueshot Lodge
--		Sort_currentMapID = 1024
--	end

	for index, quest in ipairs (WorldQuestTracker.QuestTrackList) do
		quest.LastDistance = quest.LastDistance or 0
	end
	table.sort (WorldQuestTracker.QuestTrackList, Sort_QuestsOnTracker)
end

--parent frame na UIParent ~trackerframe
--esse frame � quem vai ser anexado ao tracker da blizzard
--this is the main frame for the quest tracker, every thing on the tracker is parent of this frame
-- ~trackerframe
local WorldQuestTrackerFrame = CreateFrame ("frame", "WorldQuestTrackerScreenPanel", UIParent)
WorldQuestTrackerFrame:SetSize (235, 500)
WorldQuestTrackerFrame:SetFrameStrata ("LOW") --thanks @p3lim on curseforge

--debug tracker size
--WorldQuestTrackerFrame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})


local WorldQuestTrackerFrame_QuestHolder = CreateFrame ("frame", "WorldQuestTrackerScreenPanel_QuestHolder", WorldQuestTrackerFrame)
WorldQuestTrackerFrame_QuestHolder:SetAllPoints()
WorldQuestTrackerFrame_QuestHolder:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
WorldQuestTrackerFrame_QuestHolder.MoveMeLabel = WorldQuestTracker:CreateLabel (WorldQuestTrackerFrame_QuestHolder, "== Move Me ==")

local lock_window = function()
	WorldQuestTracker.db.profile.tracker_is_locked = true
	WorldQuestTracker.RefreshTrackerAnchor()
end
WorldQuestTrackerFrame_QuestHolder.LockButton = WorldQuestTracker:CreateButton (WorldQuestTrackerFrame_QuestHolder, lock_window, 120, 24, "Lock Window", nil, nil, nil, nil, "WorldQuestTrackerLockTrackerButton", nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))

WorldQuestTrackerFrame_QuestHolder.MoveMeLabel:SetPoint ("center", 0, 3)
WorldQuestTrackerFrame_QuestHolder.LockButton:SetPoint ("center", 0, -16)
WorldQuestTrackerFrame_QuestHolder.MoveMeLabel:Hide()
WorldQuestTrackerFrame_QuestHolder.LockButton:Hide()

function WorldQuestTracker.UpdateTrackerScale()
	WorldQuestTrackerFrame:SetScale (WorldQuestTracker.db.profile.tracker_scale)
	--WorldQuestTrackerFrame_QuestHolder:SetScale (WorldQuestTracker.db.profile.tracker_scale) --aumenta s� as quests sem mexer no cabe�alho
end

--cria o header
local WorldQuestTrackerHeader = CreateFrame ("frame", "WorldQuestTrackerQuestsHeader", WorldQuestTrackerFrame, "ObjectiveTrackerHeaderTemplate") -- "ObjectiveTrackerHeaderTemplate"
WorldQuestTrackerHeader.Text:SetText (L["World Quest Tracker"])
local minimizeButton = CreateFrame ("button", "WorldQuestTrackerQuestsHeaderMinimizeButton", WorldQuestTrackerFrame)
local minimizeButtonText = minimizeButton:CreateFontString (nil, "overlay", "GameFontNormal")
minimizeButtonText:SetText (L["S_WORLDQUESTS"])
minimizeButtonText:SetPoint ("right", minimizeButton, "left", -3, 1)
minimizeButtonText:Hide()

WorldQuestTrackerFrame.MinimizeButton = minimizeButton
minimizeButton:SetSize (16, 16)
minimizeButton:SetPoint ("topright", WorldQuestTrackerHeader, "topright", 0, -4)
minimizeButton:SetScript ("OnClick", function()
	if (WorldQuestTrackerFrame.collapsed) then
		WorldQuestTrackerFrame.collapsed = false
		minimizeButton:GetNormalTexture():SetTexCoord (0, 0.5, 0.5, 1)
		minimizeButton:GetPushedTexture():SetTexCoord (0.5, 1, 0.5, 1)
		WorldQuestTrackerFrame_QuestHolder:Show()
		WorldQuestTrackerHeader:Show()
		minimizeButtonText:Hide()
	else
		WorldQuestTrackerFrame.collapsed = true
		minimizeButton:GetNormalTexture():SetTexCoord (0, 0.5, 0, 0.5)
		minimizeButton:GetPushedTexture():SetTexCoord (0.5, 1, 0, 0.5)
		WorldQuestTrackerFrame_QuestHolder:Hide()
		WorldQuestTrackerHeader:Hide()
		minimizeButtonText:Show()
		minimizeButtonText:SetText (L["World Quest Tracker"])
	end
end)
minimizeButton:SetNormalTexture ([[Interface\Buttons\UI-Panel-QuestHideButton]])
minimizeButton:GetNormalTexture():SetTexCoord (0, 0.5, 0.5, 1)
minimizeButton:SetPushedTexture ([[Interface\Buttons\UI-Panel-QuestHideButton]])
minimizeButton:GetPushedTexture():SetTexCoord (0.5, 1, 0.5, 1)
minimizeButton:SetHighlightTexture ([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
minimizeButton:SetDisabledTexture ([[Interface\Buttons\UI-Panel-QuestHideButton-disabled]])

--armazena todos os widgets
local TrackerWidgetPool = {}
--inicializa a variavel que armazena o tamanho do quest frame
WorldQuestTracker.TrackerHeight = 0

--move anything
C_Timer.After (10, function()
	if (MAOptions) then
		MAOptions:HookScript ("OnUpdate", function()
			WorldQuestTracker.RefreshTrackerAnchor()
		end)

		--ObjectiveTrackerFrameMover:CreateTexture("AA", "overlay")
		--AA:SetAllPoints()
		--AA:SetColorTexture (1, 1, 1, .3)
	end
end)

--da refresh na ancora do screen panel
--enUS - refresh the track positioning on the player screen
function WorldQuestTracker.RefreshTrackerAnchor()

	--automatic calculate the tracker position
	if (not WorldQuestTracker.db.profile.tracker_is_movable) then
		WorldQuestTrackerScreenPanel:ClearAllPoints()

		for i = 1, ObjectiveTrackerFrame:GetNumPoints() do
			local point, relativeTo, relativePoint, xOfs, yOfs = ObjectiveTrackerFrame:GetPoint (i)
			
			--note: we're probably missing something here, when the frame anchors to MoveAnything frame 'ObjectiveTrackerFrameMover', 
			--it automatically anchors to MinimapCluster frame.
			--so the solution we've found was to get the screen position of the MoveAnything frame and anchor our frame to UIParent.
			
			--if (relativeTo:GetName() == "ObjectiveTrackerFrameMover") then
			if (IsAddOnLoaded("MoveAnything") and relativeTo and (relativeTo:GetName() == "ObjectiveTrackerFrameMover")) then -- (check if MA is lodaded - thanks @liquidbase on WoWUI)
				local top, left = ObjectiveTrackerFrameMover:GetTop(), ObjectiveTrackerFrameMover:GetLeft()
				WorldQuestTrackerScreenPanel:SetPoint ("top", UIParent, "top", 0, (yOfs - WorldQuestTracker.TrackerHeight - 20) - abs (top-GetScreenHeight()))
				WorldQuestTrackerScreenPanel:SetPoint ("left", UIParent, "left", -10 + xOfs + left, 0)
			else
				WorldQuestTrackerScreenPanel:SetPoint (point, relativeTo, relativePoint, -10 + xOfs, yOfs - WorldQuestTracker.TrackerHeight - 20)
			end
			
			--print where the frame is setting its potision
			--print ("SETTING POS ON:", point, relativeTo:GetName(), relativePoint, -10 + xOfs, yOfs - WorldQuestTracker.TrackerHeight - 20)
		end

		--print where the frame was anchored, weird thing happens if we set the anchor to a MoveAnything frame
		--local point, relativeTo, relativePoint, xOfs, yOfs = WorldQuestTrackerScreenPanel:GetPoint (1)
		--print ("SETTED AT", point, relativeTo:GetName(), relativePoint, xOfs, yOfs)

		WorldQuestTrackerHeader:ClearAllPoints()
		WorldQuestTrackerHeader:SetPoint ("bottom", WorldQuestTrackerFrame, "top", 0, -20)
	
		--remove the unlocked widgets
		WorldQuestTrackerFrame_QuestHolder.LockButton:Hide()
		WorldQuestTrackerFrame_QuestHolder.MoveMeLabel:Hide()
		WorldQuestTrackerFrame_QuestHolder:SetBackdrop (nil)
	
	--the track position is placed by the player
	else
		--> se estiver destrancado, ativar o mouse
		if (not WorldQuestTracker.db.profile.tracker_is_locked and WorldQuestTrackerScreenPanel.RegisteredForLibWindow) then
			WorldQuestTrackerScreenPanel:EnableMouse (true)
			LibWindow.MakeDraggable (WorldQuestTrackerScreenPanel)
			
			--show the unlocked widgets
			WorldQuestTrackerFrame_QuestHolder:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			WorldQuestTrackerFrame_QuestHolder:SetBackdropColor (0, 0, 0, 0.75)
			WorldQuestTrackerFrame_QuestHolder.LockButton:Show()
			WorldQuestTrackerFrame_QuestHolder.MoveMeLabel:Show()
		else
			WorldQuestTrackerScreenPanel:EnableMouse (false)
			
			--remove the unlocked widgets
			WorldQuestTrackerFrame_QuestHolder.LockButton:Hide()
			WorldQuestTrackerFrame_QuestHolder.MoveMeLabel:Hide()
			WorldQuestTrackerFrame_QuestHolder:SetBackdrop (nil)
		end
		
		WorldQuestTrackerHeader:ClearAllPoints()
		WorldQuestTrackerHeader:SetPoint ("bottom", WorldQuestTrackerFrame, "top", 0, -20)
	end
end

--quando um widget for clicado, mostrar painel com op��o para parar de trackear
local TrackerFrameOnClick = function (self, button)
	--ao clicar em cima de uma quest mostrada no tracker
	--??--
	if (button == "RightButton") then
		WorldQuestTracker.RemoveQuestFromTracker (self.questID)
		---se o worldmap estiver aberto, dar refresh
		if (WorldMapFrame:IsShown()) then
			if (WorldQuestTracker.IsCurrentMapQuestHub()) then
				--refresh no world map
				WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
			elseif (WorldQuestTracker.ZoneHaveWorldQuest()) then
				--refresh nos widgets
				WorldQuestTracker.UpdateZoneWidgets (true)
				WorldQuestTracker.WorldWidgets_NeedFullRefresh = true
			end
		else
			WorldQuestTracker.WorldWidgets_NeedFullRefresh = true
		end
	else
		if (button == "MiddleButton") then
			--was middle button and our group finder is enabled
			if (WorldQuestTracker.db.profile.groupfinder.enabled) then
				WorldQuestTracker.FindGroupForQuest (self.questID)
				return
			end
			
			--middle click without our group finder enabled, check for other addons
			if (WorldQuestGroupFinderAddon) then
				WorldQuestGroupFinder.HandleBlockClick (self.questID)
				return
			end
		end
	
		WorldQuestTracker.CanLinkToChat (self, button)
	end
end


local buildTooltip = function (self)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint ("TOPRIGHT", self, "TOPLEFT", -20, 0)
	GameTooltip:SetOwner (self, "ANCHOR_PRESERVE")
	local questID = self.questID
	
	if ( not HaveQuestData (questID) ) then
		GameTooltip:SetText (RETRIEVING_DATA, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		GameTooltip:Show()
		return
	end

	local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (questID)

	local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo (questID)
	local color = WORLD_QUEST_QUALITY_COLORS [rarity]
	GameTooltip:SetText (title, color.r, color.g, color.b)

	--belongs to what faction
	if (factionID) then
		local factionName = GetFactionInfoByID (factionID)
		if (factionName) then
			if (capped) then
				GameTooltip:AddLine (factionName, GRAY_FONT_COLOR:GetRGB())
			else
				GameTooltip:AddLine (factionName, 0.4, 0.733, 1.0)
			end
			GameTooltip:AddLine (" ")
		end
	end

	--time left
	local timeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes (questID)
	if (timeLeftMinutes) then
		local color = NORMAL_FONT_COLOR
		local timeString
		if (timeLeftMinutes <= WORLD_QUESTS_TIME_CRITICAL_MINUTES) then
			color = RED_FONT_COLOR
			timeString = SecondsToTime (timeLeftMinutes * 60)
		elseif (timeLeftMinutes <= 60 + WORLD_QUESTS_TIME_CRITICAL_MINUTES) then
			timeString = SecondsToTime ((timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) * 60)
		elseif (timeLeftMinutes < 24 * 60 + WORLD_QUESTS_TIME_CRITICAL_MINUTES) then
			timeString = D_HOURS:format (math.floor(timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) / 60)
		else
			local days = math.floor(timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) / 1440
			local hours = math.floor(timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) / 60
			timeString = D_DAYS:format (days) .. " " .. D_HOURS:format (hours - (floor (days)*24))
		end
		GameTooltip:AddLine (BONUS_OBJECTIVE_TIME_LEFT:format (timeString), color.r, color.g, color.b)
	end

	--all objectives
	for objectiveIndex = 1, self.numObjectives do
		local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(questID, objectiveIndex, false);
		if ( objectiveText and #objectiveText > 0 ) then
			local color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			GameTooltip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true);
		end
	end
	
	--percentage bar
	local percent = C_TaskQuest.GetQuestProgressBarInfo (questID)
	if ( percent ) then
	-- WorldMapTaskTooltipStatusBar removed on 8.0
	--	GameTooltip_InsertFrame(GameTooltip, WorldMapTaskTooltipStatusBar);
	--	WorldMapTaskTooltipStatusBar.Bar:SetValue(percent);
	--	WorldMapTaskTooltipStatusBar.Bar.Label:SetFormattedText(PERCENTAGE_STRING, percent);
	end

	-- rewards
	if ( GetQuestLogRewardXP(questID) > 0 or GetNumQuestLogRewardCurrencies(questID) > 0 or GetNumQuestLogRewards(questID) > 0 or GetQuestLogRewardMoney(questID) > 0 or GetQuestLogRewardArtifactXP(questID) > 0 ) then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(QUEST_REWARDS, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
		local hasAnySingleLineRewards = false;
		-- xp
		local xp = GetQuestLogRewardXP(questID);
		if ( xp > 0 ) then
			GameTooltip:AddLine(BONUS_OBJECTIVE_EXPERIENCE_FORMAT:format(xp), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			hasAnySingleLineRewards = true;
		end
		-- money
		local money = GetQuestLogRewardMoney(questID);
		if ( money > 0 ) then
			SetTooltipMoney(GameTooltip, money, nil);
			hasAnySingleLineRewards = true;
		end	
		local artifactXP = GetQuestLogRewardArtifactXP(questID);
		if ( artifactXP > 0 ) then
			GameTooltip:AddLine(BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT:format(artifactXP), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			hasAnySingleLineRewards = true;
		end
		-- currency		
		local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID);
		for i = 1, numQuestCurrencies do
			local name, texture, numItems = GetQuestLogRewardCurrencyInfo(i, questID);
			local text = BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(texture, numItems, name);
			GameTooltip:AddLine(text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			hasAnySingleLineRewards = true;
		end
		-- items
		local numQuestRewards = GetNumQuestLogRewards (questID)
		for i = 1, numQuestRewards do
			local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, questID);
			local text;
			if ( numItems > 1 ) then
				text = string.format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, numItems, name);
			elseif( texture and name ) then
				text = string.format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name);			
			end
			if( text ) then
				local color = ITEM_QUALITY_COLORS[quality];
				GameTooltip:AddLine(text, color.r, color.g, color.b);
			end
		end
		
	end	

	GameTooltip:Show()
--	if (GameTooltip.ItemTooltip) then
--		GameTooltip:SetHeight (GameTooltip:GetHeight() + GameTooltip.ItemTooltip:GetHeight())
--	end
end
WorldQuestTracker.BuildTooltip = buildTooltip

local TrackerFrameOnEnter = function (self)
	local color = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]
	self.Title:SetTextColor (color.r, color.g, color.b)

	local color = OBJECTIVE_TRACKER_COLOR["NormalHighlight"]
	self.Zone:SetTextColor (color.r, color.g, color.b)
	
	self.RightBackground:SetAlpha (TRACKER_BACKGROUND_ALPHA_MAX)
	self.Arrow:SetAlpha (TRACKER_ARROW_ALPHA_MAX)
	buildTooltip (self)
	
	self.HasOverHover = true
end

local TrackerFrameOnLeave = function (self)
	local color = OBJECTIVE_TRACKER_COLOR["Header"]
	self.Title:SetTextColor (color.r, color.g, color.b)
	
	local color = OBJECTIVE_TRACKER_COLOR["Normal"]
	self.Zone:SetTextColor (color.r, color.g, color.b)

	self.RightBackground:SetAlpha (TRACKER_BACKGROUND_ALPHA_MIN)
	self.Arrow:SetAlpha (TRACKER_ARROW_ALPHA_MIN)
	GameTooltip:Hide()
	
	self.HasOverHover = nil
	self.QuestInfomation.text = ""
end

local TrackerIconButtonOnEnter = function (self)
	
end
local TrackerIconButtonOnLeave = function (self)
	
end
local TrackerIconButtonOnClick = function (self, button)
	if (button == "MiddleButton") then
		--was middle button and our group finder is enabled
		if (WorldQuestTracker.db.profile.groupfinder.enabled) then
			WorldQuestTracker.FindGroupForQuest (self.questID)
			return
		end
		
		--middle click without our group finder enabled, check for other addons
		if (WorldQuestGroupFinderAddon) then
			WorldQuestGroupFinder.HandleBlockClick (self.questID)
			return
		end
	end

	if (self.questID == GetSuperTrackedQuestID()) then
		WorldQuestTracker.SuperTracked = nil
		QuestSuperTracking_ChooseClosestQuest()
		return
	end
	
	if (HaveQuestData (self.questID)) then
		WorldQuestTracker.SelectSingleQuestInBlizzardWQTracker (self.questID) --thanks @ilintar on CurseForge
		--SetSuperTrackedQuestID (self.questID)
		WorldQuestTracker.RefreshTrackerWidgets()
		WorldQuestTracker.SuperTracked = self.questID
	end
end

-- �rrow ~arrow

--from the user @ilintar on CurseForge
--Doing that instead of just SetSuperTrackedQuestID(questID) will make the arrow stay. The code also ensures that only the selected world quest is present in the Blizzard window, as to not make it cluttered.
	function WorldQuestTracker.SelectSingleQuestInBlizzardWQTracker (questID)
		for i = 1, GetNumWorldQuestWatches() do
			local watchedWorldQuestID = GetWorldQuestWatchInfo(i);
			if (watchedWorldQuestID) then
				BonusObjectiveTracker_UntrackWorldQuest(watchedWorldQuestID)
			end
		end
		BonusObjectiveTracker_TrackWorldQuest(questID, true)
		SetSuperTrackedQuestID (questID)
	end
--

--> overwriting this was causing taint issues	
--[=[
--rewrite QuestSuperTracking_IsSuperTrackedQuestValid to avoid conflict with World Quest Tracker
function QuestSuperTracking_IsSuperTrackedQuestValid()
	local trackedQuestID = GetSuperTrackedQuestID();
	if trackedQuestID == 0 then
		return false;
	end

	if GetQuestLogIndexByID(trackedQuestID) == 0 then
		-- Might be a tracked world quest that isn't in our log yet (blizzard)
		-- adding here if the quest is tracked by World Quest Tracker (tercio)
		if (QuestUtils_IsQuestWorldQuest(trackedQuestID) and WorldQuestTracker.SuperTracked == trackedQuestID) then
			return true
		end
		if QuestUtils_IsQuestWorldQuest(trackedQuestID) and IsWorldQuestWatched(trackedQuestID) then
			return C_TaskQuest.IsActive(trackedQuestID);
		end
		return false;
	end

	return true;
end
--]=]

--> thise functions isn't being used at the moment
--[=[
local UpdateSuperQuestTracker = function()
	if (WorldQuestTracker.SuperTracked and HaveQuestData (WorldQuestTracker.SuperTracked)) then
		--verifica se a quest esta sendo mostrada no tracker
		for i = 1, #TrackerWidgetPool do
			if (TrackerWidgetPool[i]:IsShown() and TrackerWidgetPool[i].questID == WorldQuestTracker.SuperTracked) then
				SetSuperTrackedQuestID (WorldQuestTracker.SuperTracked)
				return
			end
		end
		WorldQuestTracker.SuperTracked = nil
	end
end
--]=]
--[=[
hooksecurefunc ("QuestSuperTracking_ChooseClosestQuest", function()
	if (WorldQuestTracker.SuperTracked) then
		--delay increased from 20ms to 200ms to avoid lag spikes
		C_Timer.After (.2, UpdateSuperQuestTracker)
	end
end)
--]=]


local TrackerIconButtonOnMouseDown = function (self, button)
	self.Icon:SetPoint ("topleft", self:GetParent(), "topleft", -12, -3)
end
local TrackerIconButtonOnMouseUp = function (self, button)
	self.Icon:SetPoint ("topleft", self:GetParent(), "topleft", -13, -2)
end


--pega um widget j� criado ou cria um novo ~trackercreate ~trackerwidget
function WorldQuestTracker.GetOrCreateTrackerWidget (index)
	if (TrackerWidgetPool [index]) then
		return TrackerWidgetPool [index]
	end
	
	local f = CreateFrame ("button", "WorldQuestTracker_Tracker" .. index, WorldQuestTrackerFrame_QuestHolder)
	--f:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
	--f:SetBackdropColor (0, 0, 0, .2)
	f:SetSize (235, 30)
	f:SetScript ("OnClick", TrackerFrameOnClick)
	f:SetScript ("OnEnter", TrackerFrameOnEnter)
	f:SetScript ("OnLeave", TrackerFrameOnLeave)
	f:RegisterForClicks ("LeftButtonDown", "MiddleButtonDown", "RightButtonDown")
	
	f.RightBackground = f:CreateTexture (nil, "background")
	f.RightBackground:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
	f.RightBackground:SetTexCoord (1, 61/128, 0, 1)
	f.RightBackground:SetDesaturated (true)
	f.RightBackground:SetPoint ("topright", f, "topright")
	f.RightBackground:SetPoint ("bottomright", f, "bottomright")
	f.RightBackground:SetWidth (200)
	f.RightBackground:SetAlpha (TRACKER_BACKGROUND_ALPHA_MIN)
	
	--f.module = _G ["WORLD_QUEST_TRACKER_MODULE"]
	f.worldQuest = true
	
	f.Title = DF:CreateLabel (f)
	f.Title.textsize = TRACKER_TITLE_TEXT_SIZE_INMAP
	--f.Title = f:CreateFontString (nil, "overlay", "ObjectiveFont")
	f.Title:SetPoint ("topleft", f, "topleft", 10, -1)
	local titleColor = OBJECTIVE_TRACKER_COLOR["Header"]
	f.Title:SetTextColor (titleColor.r, titleColor.g, titleColor.b)
	f.Zone = DF:CreateLabel (f)
	f.Zone.textsize = TRACKER_TITLE_TEXT_SIZE_INMAP
	--f.Zone = f:CreateFontString (nil, "overlay", "ObjectiveFont")
	f.Zone:SetPoint ("topleft", f, "topleft", 10, -17)
	
	f.QuestInfomation = DF:CreateLabel (f)
	f.QuestInfomation:SetPoint ("topleft", f, "topright", 2, 0)
	
	f.YardsDistance = f:CreateFontString (nil, "overlay", "GameFontNormal")
	f.YardsDistance:SetPoint ("left", f.Zone.widget, "right", 2, 0)
	f.YardsDistance:SetJustifyH ("left")
	DF:SetFontColor (f.YardsDistance, "white")
	DF:SetFontSize (f.YardsDistance, 12)
	f.YardsDistance:SetAlpha (.5)
	
	f.TimeLeft = f:CreateFontString (nil, "overlay", "GameFontNormal")
	f.TimeLeft:SetPoint ("left", f.YardsDistance, "right", 2, 0)
	f.TimeLeft:SetJustifyH ("left")
	DF:SetFontColor (f.TimeLeft, "white")
	DF:SetFontSize (f.TimeLeft, 12)
	f.TimeLeft:SetAlpha (.5)
	
	f.Icon = f:CreateTexture (nil, "artwork")
	f.Icon:SetPoint ("topleft", f, "topleft", -13, -2)
	f.Icon:SetSize (16, 16)
	f.Icon:SetMask ([[Interface\CharacterFrame\TempPortraitAlphaMask]])
	
	local IconButton = CreateFrame ("button", "$parentIconButton", f)
	IconButton:SetSize (18, 18)
	IconButton:SetPoint ("center", f.Icon, "center")
	IconButton:SetScript ("OnEnter", TrackerIconButtonOnEnter)
	IconButton:SetScript ("OnLeave", TrackerIconButtonOnLeave)
	IconButton:SetScript ("OnClick", TrackerIconButtonOnClick)
	IconButton:SetScript ("OnMouseDown", TrackerIconButtonOnMouseDown)
	IconButton:SetScript ("OnMouseUp", TrackerIconButtonOnMouseUp)
	IconButton:RegisterForClicks ("LeftButtonDown", "MiddleButtonDown")
	IconButton.Icon = f.Icon
	f.IconButton = IconButton
--
	f.Circle = f:CreateTexture (nil, "overlay")
	f.Circle:SetTexture ([[Interface\Transmogrify\Transmogrify]])
	f.Circle:SetTexCoord (381/512, 405/512, 93/512, 117/512)
	f.Circle:SetSize (18, 18)
	--f.Circle:SetPoint ("center", f.Icon, "center")
	f.Circle:SetPoint ("topleft", f, "topleft", -14, -1)
	f.Circle:SetDesaturated (true)
	f.Circle:SetAlpha (.7)
	
	f.RewardAmount = f:CreateFontString (nil, "overlay", "ObjectiveFont")
	f.RewardAmount:SetTextColor (titleColor.r, titleColor.g, titleColor.b)
	f.RewardAmount:SetPoint ("top", f.Circle, "bottom", 0, -2)
	DF:SetFontSize (f.RewardAmount, 10)	
	
	f.Shadow = f:CreateTexture (nil, "BACKGROUND")
	f.Shadow:SetSize (26, 26)
	f.Shadow:SetPoint ("center", f.Circle, "center")
	f.Shadow:SetTexture ([[Interface\PETBATTLES\BattleBar-AbilityBadge-Neutral]])
	f.Shadow:SetAlpha (.3)
	f.Shadow:SetDrawLayer ("BACKGROUND", -5)
	
	f.SuperTracked = f:CreateTexture (nil, "background")
	f.SuperTracked:SetPoint ("center", f.Circle, "center")
	f.SuperTracked:SetAlpha (1)
	f.SuperTracked:SetTexture ([[Interface\Worldmap\UI-QuestPoi-IconGlow]])
	f.SuperTracked:SetBlendMode ("ADD")
	f.SuperTracked:SetSize (42, 42)
	f.SuperTracked:SetDrawLayer ("BACKGROUND", -6)
	f.SuperTracked:Hide()
	
	local highlight = IconButton:CreateTexture (nil, "highlight")
	highlight:SetPoint ("center", f.Circle, "center")
	highlight:SetAlpha (1)
	highlight:SetTexture ([[Interface\Worldmap\UI-QuestPoi-NumberIcons]])
	--highlight:SetTexCoord (167/256, 185/256, 103/256, 121/256) --low light
	highlight:SetTexCoord (167/256, 185/256, 231/256, 249/256)
	highlight:SetBlendMode ("ADD")
	highlight:SetSize (14, 14)
	
	f.Arrow = f:CreateTexture (nil, "overlay")
	f.Arrow:SetPoint ("right", f, "right", 0, 0)
	f.Arrow:SetSize (32, 32)
	f.Arrow:SetAlpha (.6)
	--f.Arrow:SetAlpha (1)
	f.Arrow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\ArrowGridT]])
	
	f.ArrowDistance = f:CreateTexture (nil, "overlay")
	--f.ArrowDistance:SetPoint ("center", f.Arrow, "center", -5, 0)
	f.ArrowDistance:SetPoint ("center", f.Arrow, "center", 0, 0)
	f.ArrowDistance:SetSize (34, 34)
	f.ArrowDistance:SetAlpha (.5)
	f.ArrowDistance:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\ArrowGridTGlow]])

	f.ArrowDistance:SetDrawLayer ("overlay", 4)
	f.Arrow:SetDrawLayer ("overlay", 5)
	
	------------------------
	
	f.AnimationFrame = CreateFrame ("frame", "$parentAnimation", f)
	f.AnimationFrame:SetAllPoints()
	f.AnimationFrame:SetFrameLevel (f:GetFrameLevel()-1)
	f.AnimationFrame:Hide()
	
	local star = f.AnimationFrame:CreateTexture (nil, "overlay")
	star:SetTexture ([[Interface\Cooldown\star4]])
	star:SetSize (168, 168)
	star:SetPoint ("center", f.Icon, "center", 1, -1)
	star:SetBlendMode ("ADD")
	star:Hide()
	
	local flash = f.AnimationFrame:CreateTexture (nil, "overlay")
	flash:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Alert-Glow]])
	flash:SetTexCoord (0, 400/512, 0, 170/256)
	flash:SetPoint ("topleft", -60, 30)
	flash:SetPoint ("bottomright", 40, -30)
	flash:SetBlendMode ("ADD")
	
	local spark = f.AnimationFrame:CreateTexture (nil, "overlay")
	spark:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Alert-Glow]])
	spark:SetTexCoord (400/512, 470/512, 0, 70/256)
	spark:SetSize (50, 34)
	spark:SetBlendMode ("ADD")
	spark:SetPoint ("left")
	
	local iconoverlay = f:CreateTexture (nil, "overlay")
	iconoverlay:SetTexture ([[Interface\COMMON\StreamBackground]])
	iconoverlay:SetPoint ("center", f.Icon, "center", 0, 0)
	iconoverlay:Hide()
	--iconoverlay:SetSize (256, 256)
	iconoverlay:SetDrawLayer ("overlay", 7)
	
	--iconoverlay:SetSize (50, 34)
	--iconoverlay:SetBlendMode ("ADD")
	
	
	local StarShowAnimation = DF:CreateAnimationHub (star, function() star:Show() end, function() star:Hide() end)
	DF:CreateAnimation (StarShowAnimation, "alpha", 1, .3, 0, .2)
	DF:CreateAnimation (StarShowAnimation, "rotation", 1, .3, 90)
	DF:CreateAnimation (StarShowAnimation, "scale", 1, .3, 0, 0, 1.2, 1.2)
	DF:CreateAnimation (StarShowAnimation, "alpha", 2, .3, .2, 0)
	DF:CreateAnimation (StarShowAnimation, "rotation", 2, .3, .8)
	DF:CreateAnimation (StarShowAnimation, "scale", 1, .3, 1.2, 1.2, 0, 0)
	
	local FlashAnimation = DF:CreateAnimationHub (flash, function() flash:Show() end, function() flash:Hide() end)
	DF:CreateAnimation (FlashAnimation, "alpha", 1, .05, 0, .3)
	DF:CreateAnimation (FlashAnimation, "alpha", 2, .5, .3, 0)
	
	local SparkAnimation = DF:CreateAnimationHub (spark, function() spark:Show() end, function() spark:Hide() end)
	DF:CreateAnimation (SparkAnimation, "alpha", 1, .2, 0, .1)
	DF:CreateAnimation (SparkAnimation, "translation", 2, .3, 255, 0)
	
	local CircleOverlayAnimation = DF:CreateAnimationHub (iconoverlay, function() iconoverlay:Show() end, function() iconoverlay:Hide() end)
	DF:CreateAnimation (CircleOverlayAnimation, "alpha", 1, .05, 0, 1)
	DF:CreateAnimation (CircleOverlayAnimation, "alpha", 2, .5, 1, 0)
	
	f.AnimationFrame.ShowAnimation = function()
		f.AnimationFrame:Show()
		StarShowAnimation:Play()
		spark:SetPoint ("left", -40, 0)
		SparkAnimation:Play()
		FlashAnimation:Play()
		CircleOverlayAnimation:Play()
	end
	
	------------------------
	
	TrackerWidgetPool [index] = f
	return f
end

local zoneXLength, zoneYLength = 0, 0
local playerIsMoving = true

function WorldQuestTracker:PLAYER_STARTED_MOVING()
	playerIsMoving = true
end
function WorldQuestTracker:PLAYER_STOPPED_MOVING()
	playerIsMoving = false
end

-- ~trackertick ~trackeronupdate ~tick ~onupdate ~ontick �ntick �nupdate
local TrackerOnTick = function (self, deltaTime)
	if (self.NextPositionUpdate < 0) then
		if (Sort_currentMapID ~= WorldQuestTracker.GetCurrentStandingMapAreaID()) then
			self.Arrow:SetAlpha (.3)
			self.Arrow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\ArrowFrozen]])
			self.Arrow:SetTexCoord (0, 1, 0, 1)
			self.ArrowDistance:Hide()
			self.Arrow.Frozen = true
			return
		elseif (self.Arrow.Frozen) then
			self.Arrow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\ArrowGridT]])
			self.ArrowDistance:Show()
			self.Arrow.Frozen = nil
		end
	end
	
	local mapPosition = C_Map.GetPlayerMapPosition (WorldQuestTracker.GetCurrentStandingMapAreaID(), "player")
	if (not mapPosition) then
		return
	end
	local x, y = mapPosition.x, mapPosition.y
	
	if (self.NextArrowUpdate < 0) then
		local questYaw = (FindLookAtRotation (_, x, y, self.questX, self.questY) + p)%pipi
		local playerYaw = GetPlayerFacing()
		local angle = (((questYaw + playerYaw)%pipi)+pi)%pipi
		local imageIndex = 1+(floor (MapRangeClamped (_, 0, pipi, 1, 144, angle)) + 48)%144 --48� quadro � o que aponta para o norte
		local line = ceil (imageIndex / 12)
		local coord = (imageIndex - ((line-1) * 12)) / 12
		self.Arrow:SetTexCoord (coord-0.0833, coord, 0.0833 * (line-1), 0.0833 * line)
		--self.ArrowDistance:SetTexCoord (coord-0.0905, coord-0.0160, 0.0833 * (line-1), 0.0833 * line) -- 0.0763
		self.ArrowDistance:SetTexCoord (coord-0.0833, coord, 0.0833 * (line-1), 0.0833 * line) -- 0.0763
		
		self.NextArrowUpdate = ARROW_UPDATE_FREQUENCE
	else
		self.NextArrowUpdate = self.NextArrowUpdate - deltaTime
	end
	
	self.NextPositionUpdate = self.NextPositionUpdate - deltaTime
	
	if ((playerIsMoving or self.ForceUpdate) and self.NextPositionUpdate < 0) then
		local distance = GetDistance_Point (_, x, y, self.questX, self.questY)
		local x = zoneXLength * distance
		local y = zoneYLength * distance
		local yards = (x*x + y*y) ^ 0.5
		self.YardsDistance:SetText ("[|cFFC0C0C0" .. floor (yards) .. "|r]")

		distance = abs (distance - 1)
		self.info.LastDistance = distance
		
		distance = Saturate (distance - 0.75) * 4
		local alpha = MapRangeClamped (_, 0, 1, 0, 0.5, distance)
		self.Arrow:SetAlpha (.5 + (alpha))
		self.ArrowDistance:SetVertexColor (distance, distance, distance)
		
		self.NextPositionUpdate = .5
		self.ForceUpdate = nil
		
		if (self.HasOverHover) then
			if (IsAltKeyDown()) then
				self.QuestInfomation.text = "ID: " .. self.questID .. "\nMapID: " .. self.info.mapID .. "\nTimeLeft: " .. self.info.timeLeft .. "\nType: " .. self.info.questType .. "\nNumObjetives: " .. self.info.numObjectives
			else
				self.QuestInfomation.text = ""
			end
		end
	end
	
	self.NextTimeUpdate = self.NextTimeUpdate - deltaTime
	
	if (self.NextTimeUpdate < 0) then
		if (HaveQuestData (self.questID)) then
			local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (self.questID)
			if (timeLeft and timeLeft > 0) then
				local timeLeft2 =  WorldQuestTracker.GetQuest_TimeLeft (self.questID, true)
				--local str = timeLeft > 1440 and floor (timeLeft/1440) .. "d" or timeLeft > 60 and floor (timeLeft/60) .. "h" or timeLeft .. "m"
				local color = "FFC0C0C0"
				if (timeLeft < 30) then
					color = "FFFF2200"
				elseif (timeLeft < 60) then
					color = "FFFF9900"
				end
				self.TimeLeft:SetText ("[|c" .. color .. timeLeft2 .. "|r]")
			else
				self.TimeLeft:SetText ("[0m]")
			end
		end
		self.NextTimeUpdate = 60
	end

end

local TrackerOnTick_TimeLeft = function (self, deltaTime)
	self.NextTimeUpdate = self.NextTimeUpdate - deltaTime
	
	if (self.NextTimeUpdate < 0) then
		if (HaveQuestData (self.questID)) then
			local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (self.questID)
			if (timeLeft and timeLeft > 0) then
				local timeLeft2 =  WorldQuestTracker.GetQuest_TimeLeft (self.questID, true)
				--local str = timeLeft > 1440 and floor (timeLeft/1440) .. "d" or timeLeft > 60 and floor (timeLeft/60) .. "h" or timeLeft .. "m"
				local color = "FFC0C0C0"
				if (timeLeft < 30) then
					color = "FFFF2200"
				elseif (timeLeft < 60) then
					color = "FFFF9900"
				end
				self.TimeLeft:SetText ("[|c" .. color .. timeLeft2 .. "|r]")
			else
				self.TimeLeft:SetText ("[0m]")
			end
		end
		self.NextTimeUpdate = 60
	end
end


function WorldQuestTracker.SortTrackerByQuestDistance()
	WorldQuestTracker.ReorderQuestsOnTracker()
	WorldQuestTracker.RefreshTrackerWidgets()
end

--atualiza os widgets e reajusta a ancora
function WorldQuestTracker.RefreshTrackerWidgets()
	--under development
	--if (true) then return end

	if (WorldQuestTracker.LastTrackerRefresh and WorldQuestTracker.LastTrackerRefresh+0.2 > GetTime()) then
		return
	end
	WorldQuestTracker.LastTrackerRefresh = GetTime()

	--reordena as quests
	WorldQuestTracker.ReorderQuestsOnTracker()
	--atualiza as quest no tracker
	local y = -30
	local nextWidget = 1
	local needSortByDistance = 0
	local onlyCurrentMap = WorldQuestTracker.db.profile.tracker_only_currentmap
	
	for index, quest in ipairs (WorldQuestTracker.QuestTrackList) do
		--verifica se a quest esta ativa, ela pode ser desativada se o jogador estiver dentro da area da quest
		if (HaveQuestData (quest.questID)) then
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (quest.questID)
			--print (quest.questID)
			if (not quest.isDisabled and title and (not onlyCurrentMap or (onlyCurrentMap and Sort_currentMapID == quest.mapID))) then
				local widget = WorldQuestTracker.GetOrCreateTrackerWidget (nextWidget)
				widget:ClearAllPoints()
				widget:SetPoint ("topleft", WorldQuestTrackerFrame, "topleft", 0, y)
				widget.questID = quest.questID
				widget.info = quest
				widget.numObjectives = quest.numObjectives

				widget.Title:SetText (title)
				while (widget.Title:GetStringWidth() > TRACKER_TITLE_TEXTWIDTH_MAX) do
					title = strsub (title, 1, #title-1)
					widget.Title:SetText (title)
				end
				
				local color = OBJECTIVE_TRACKER_COLOR["Header"]
				widget.Title:SetTextColor (color.r, color.g, color.b)
				
				widget.Zone:SetText ("- " .. WorldQuestTracker.GetZoneName (quest.mapID))
				local color = OBJECTIVE_TRACKER_COLOR["Normal"]
				widget.Zone:SetTextColor (color.r, color.g, color.b)
				
				widget.Icon:SetTexture (quest.rewardTexture)
				widget.IconButton.questID = quest.questID
				
				if (GetSuperTrackedQuestID() == quest.questID) then
					widget.SuperTracked:Show()
					widget.Circle:SetDesaturated (false)
				else
					widget.SuperTracked:Hide()
					widget.Circle:SetDesaturated (true)
				end
				
				if (type (quest.rewardAmount) == "number" and quest.rewardAmount >= 1000) then --erro compare number witrh string
					widget.RewardAmount:SetText (WorldQuestTracker.ToK (quest.rewardAmount))
				else
					widget.RewardAmount:SetText (quest.rewardAmount)
				end
				
				widget:Show()
				
				WorldQuestTracker.db.profile.TutorialTracker = WorldQuestTracker.db.profile.TutorialTracker or 1

				if (WorldQuestTracker.db.profile.TutorialTracker == 1) then
					WorldQuestTracker.db.profile.TutorialTracker = WorldQuestTracker.db.profile.TutorialTracker + 1
					local alert = CreateFrame ("frame", "WorldQuestTrackerTrackerTutorialAlert1", worldFramePOIs, "MicroButtonAlertTemplate")
					alert:SetFrameLevel (302)
					alert.label = "Tracked quests are shown here!"
					alert.Text:SetSpacing (4)
					alert:SetPoint ("bottom", widget, "top", 0, 28)
					
					MicroButtonAlert_SetText (alert, alert.label)
					alert:Show()
				end
				
				if (WorldQuestTracker.JustAddedToTracker [quest.questID]) then
					widget.AnimationFrame.ShowAnimation()
					WorldQuestTracker.JustAddedToTracker [quest.questID] = nil
				end
				
				if (Sort_currentMapID == quest.mapID) then
					local x, y = C_TaskQuest.GetQuestLocation (quest.questID, quest.mapID)
					widget.questX, widget.questY = x or 0, y or 0
					
					local HereBeDragons = LibStub ("HereBeDragons-2.0")
					zoneXLength, zoneYLength = HereBeDragons:GetZoneSize (quest.mapID)

					widget.NextPositionUpdate = -1
					widget.NextArrowUpdate = -1
					widget.NextTimeUpdate = -1
					
					widget.ForceUpdate = true
					
					widget:SetScript ("OnUpdate", TrackerOnTick)
					widget.Arrow:Show()
					widget.ArrowDistance:Show()
					widget.RightBackground:Show()
					widget:SetAlpha (TRACKER_FRAME_ALPHA_INMAP)
					widget.Title.textsize = WorldQuestTracker.db.profile.tracker_textsize --TRACKER_TITLE_TEXT_SIZE_INMAP
					widget.Zone.textsize = WorldQuestTracker.db.profile.tracker_textsize --TRACKER_TITLE_TEXT_SIZE_INMAP
					needSortByDistance = needSortByDistance + 1
					
					if (WorldQuestTracker.db.profile.show_yards_distance) then
						DF:SetFontSize (widget.TimeLeft, TRACKER_TITLE_TEXT_SIZE_INMAP)
						widget.YardsDistance:Show()
					else
						widget.YardsDistance:Hide()
					end
					
					if (WorldQuestTracker.db.profile.tracker_show_time) then
						widget.TimeLeft:Show()
					else
						widget.TimeLeft:Hide()
					end
				else
					widget.Arrow:Hide()
					widget.ArrowDistance:Hide()
					widget.RightBackground:Hide()
					widget:SetAlpha (TRACKER_FRAME_ALPHA_OUTMAP)
					widget.Title.textsize = TRACKER_TITLE_TEXT_SIZE_OUTMAP
					widget.Zone.textsize = TRACKER_TITLE_TEXT_SIZE_OUTMAP
					widget.YardsDistance:SetText ("")
					widget:SetScript ("OnUpdate", nil)
					
					if (WorldQuestTracker.db.profile.tracker_show_time) then
						widget.TimeLeft:Show()
						DF:SetFontSize (widget.TimeLeft, TRACKER_TITLE_TEXT_SIZE_OUTMAP)
						widget.NextTimeUpdate = -1
						widget:SetScript ("OnUpdate", TrackerOnTick_TimeLeft)
					else
						widget.TimeLeft:Hide()
					end
				end
				
				y = y - 35
				nextWidget = nextWidget + 1
			end
		end
	end
	
	if (IsInInstance()) then
		nextWidget = 1
	end
	
	--se n�o h� nenhuma quest sendo mostrada, hidar o cabe�alho
	if (nextWidget == 1) then
		WorldQuestTrackerHeader:Hide()
		minimizeButton:Hide()
	else
		if (not WorldQuestTrackerFrame.collapsed) then
			WorldQuestTrackerHeader:Show()
		end
		minimizeButton:Show()
		WorldQuestTracker.UpdateTrackerScale()
	end
	
	if (WorldQuestTracker.SortingQuestByDistance) then
		WorldQuestTracker.SortingQuestByDistance:Cancel()
		WorldQuestTracker.SortingQuestByDistance = nil
	end
	if (needSortByDistance >= 2 and not IsInInstance()) then
		WorldQuestTracker.SortingQuestByDistance = C_Timer.NewTicker (10, WorldQuestTracker.SortTrackerByQuestDistance)
	end
	
	--esconde os widgets n�o usados
	for i = nextWidget, #TrackerWidgetPool do
		TrackerWidgetPool [i]:SetScript ("OnUpdate", nil)
		TrackerWidgetPool [i]:Hide()
	end
	
	WorldQuestTracker.RefreshTrackerAnchor()
end



local TrackerAnimation_OnAccept = CreateFrame ("frame", nil, UIParent)
TrackerAnimation_OnAccept:SetSize (235, 30)
TrackerAnimation_OnAccept.Title = DF:CreateLabel (TrackerAnimation_OnAccept)
TrackerAnimation_OnAccept.Title.textsize = TRACKER_TITLE_TEXT_SIZE_INMAP
TrackerAnimation_OnAccept.Title:SetPoint ("topleft", TrackerAnimation_OnAccept, "topleft", 10, -1)
local titleColor = OBJECTIVE_TRACKER_COLOR["Header"]
TrackerAnimation_OnAccept.Title:SetTextColor (titleColor.r, titleColor.g, titleColor.b)
TrackerAnimation_OnAccept.Zone = DF:CreateLabel (TrackerAnimation_OnAccept)
TrackerAnimation_OnAccept.Zone.textsize = TRACKER_TITLE_TEXT_SIZE_INMAP
TrackerAnimation_OnAccept.Zone:SetPoint ("topleft", TrackerAnimation_OnAccept, "topleft", 10, -17)
TrackerAnimation_OnAccept.Icon = TrackerAnimation_OnAccept:CreateTexture (nil, "artwork")
TrackerAnimation_OnAccept.Icon:SetPoint ("topleft", TrackerAnimation_OnAccept, "topleft", -13, -2)
TrackerAnimation_OnAccept.Icon:SetSize (16, 16)
TrackerAnimation_OnAccept.RewardAmount = TrackerAnimation_OnAccept:CreateFontString (nil, "overlay", "ObjectiveFont")
TrackerAnimation_OnAccept.RewardAmount:SetTextColor (titleColor.r, titleColor.g, titleColor.b)
TrackerAnimation_OnAccept.RewardAmount:SetPoint ("top", TrackerAnimation_OnAccept.Icon, "bottom", 0, -2)
DF:SetFontSize (TrackerAnimation_OnAccept.RewardAmount, 10)
TrackerAnimation_OnAccept:Hide()

TrackerAnimation_OnAccept.FlashTexture = TrackerAnimation_OnAccept:CreateTexture (nil, "background")
TrackerAnimation_OnAccept.FlashTexture:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-Alert-Glow]])
TrackerAnimation_OnAccept.FlashTexture:SetTexCoord (0, 400/512, 0, 168/256)
TrackerAnimation_OnAccept.FlashTexture:SetBlendMode ("ADD")
TrackerAnimation_OnAccept.FlashTexture:SetPoint ("topleft", -60, 40)
TrackerAnimation_OnAccept.FlashTexture:SetPoint ("bottomright", 40, -35)

local TrackerAnimation_OnAccept_MoveAnimation = DF:CreateAnimationHub (TrackerAnimation_OnAccept, function (self)
	-- 3 movement started
		--seta textos e texturas
		local quest = self.QuestObject
		local widget = self.WidgetObject
		TrackerAnimation_OnAccept.Title.text = widget.Title.text
		TrackerAnimation_OnAccept.Zone.text = widget.Zone.text
		if (quest.questType == QUESTTYPE_ARTIFACTPOWER) then
			TrackerAnimation_OnAccept.Icon:SetMask (nil)
		else
			TrackerAnimation_OnAccept.Icon:SetMask ([[Interface\CharacterFrame\TempPortraitAlphaMask]])
		end
		TrackerAnimation_OnAccept.Icon:SetTexture (quest.rewardTexture)
		TrackerAnimation_OnAccept.RewardAmount:SetText (widget.RewardAmount:GetText())	
	end, 
	function (self) 
	-- 4 movement end
		TrackerAnimation_OnAccept:Hide()
	end)
local ScreenWidth = -(floor (GetScreenWidth() / 2) - 200)
TrackerAnimation_OnAccept_MoveAnimation.Translation = DF:CreateAnimation (TrackerAnimation_OnAccept_MoveAnimation, "translation", 1, 2, ScreenWidth, 270)
DF:CreateAnimation (TrackerAnimation_OnAccept_MoveAnimation, "alpha", 1, 1.6, 1, 0)
--DF:CreateAnimation (TrackerAnimation_OnAccept_MoveAnimation, "scale", 1, 1.6, 1, 1, 0, 0)

local TrackerAnimation_OnAccept_FlashAnimation = DF:CreateAnimationHub (TrackerAnimation_OnAccept.FlashTexture, 
	function (self) 
		-- 1 Playing Flash
		TrackerAnimation_OnAccept.Title.text = ""
		TrackerAnimation_OnAccept.Zone.text = ""
		TrackerAnimation_OnAccept.Icon:SetTexture (nil)
		TrackerAnimation_OnAccept.RewardAmount:SetText ("")
		TrackerAnimation_OnAccept:Show()
		TrackerAnimation_OnAccept.FlashTexture:Show()
		TrackerAnimation_OnAccept:SetPoint ("topleft", self.WidgetObject, "topleft", 0, 0)
	end, 
	function (self) 
		-- 2 Flash Finished
		local quest = self.QuestObject
		local widget = self.WidgetObject
		
		self.QuestObject.isDisabled = true
		self.QuestObject.enteringZone = nil
		
		local top = widget:GetTop()
		local distance = GetScreenHeight() - top - 150
		TrackerAnimation_OnAccept_MoveAnimation.Translation:SetOffset (ScreenWidth, distance)
		TrackerAnimation_OnAccept_MoveAnimation:Play()
		
		TrackerAnimation_OnAccept.FlashTexture:Hide()
		WorldQuestTracker.UpdateQuestsInArea()
	end)
DF:CreateAnimation (TrackerAnimation_OnAccept_FlashAnimation, "alpha", 1, 0.15, 0, .68)
DF:CreateAnimation (TrackerAnimation_OnAccept_FlashAnimation, "scale", 1, 0.1, .1, .1, 1, 1, "center")
DF:CreateAnimation (TrackerAnimation_OnAccept_FlashAnimation, "alpha", 2, 0.15, .68, 0)

local get_widget_from_questID = function (questID)
	for i = 1, #TrackerWidgetPool do
		if (TrackerWidgetPool[i].questID == questID) then
			return TrackerWidgetPool[i]
		end
	end
end

--quando o tracker da interface atualizar, atualizar tbm o nosso tracker
--verifica se o jogador esta na area da quest
function WorldQuestTracker.UpdateQuestsInArea()
	for index, quest in ipairs (WorldQuestTracker.QuestTrackList) do
		if (HaveQuestData (quest.questID)) then
			local questIndex = GetQuestLogIndexByID (quest.questID)
			local isInArea, isOnMap, numObjectives = GetTaskInfo (quest.questID)
			if ((questIndex and questIndex ~= 0) or isInArea) then
				--desativa pois o jogo ja deve estar mostrando a quest
				if (not quest.isDisabled and not quest.enteringZone) then
					local widget = get_widget_from_questID (quest.questID)
					if (widget and not WorldQuestTracker.IsQuestOnObjectiveTracker (widget.Title:GetText())) then
						--acabou de aceitar a quest
						quest.enteringZone = true
						TrackerAnimation_OnAccept:Show()
						TrackerAnimation_OnAccept_MoveAnimation.QuestObject = quest
						TrackerAnimation_OnAccept_FlashAnimation.QuestObject = quest
						
						TrackerAnimation_OnAccept_MoveAnimation.WidgetObject = widget
						TrackerAnimation_OnAccept_FlashAnimation.WidgetObject = widget
						
						TrackerAnimation_OnAccept_FlashAnimation:Play()
					else
						quest.isDisabled = true
					end
				end
				--quest.isDisabled = true
			else
				quest.isDisabled = nil
			end
		end
	end
	WorldQuestTracker.RefreshTrackerWidgets()
end


--ao completar uma world quest remover a quest do tracker e da refresh nos widgets
hooksecurefunc ("BonusObjectiveTracker_OnTaskCompleted", function (questID, xp, money)
	for i = #WorldQuestTracker.QuestTrackList, 1, -1 do
		if (WorldQuestTracker.QuestTrackList[i].questID == questID) then
			tremove (WorldQuestTracker.QuestTrackList, i)
			WorldQuestTracker.RefreshTrackerWidgets()
			break
		end
	end
end)




-- ~blizzard objective tracker
function WorldQuestTracker.IsQuestOnObjectiveTracker (quest)
	local tracker = ObjectiveTrackerFrame
	
	if (not tracker.initialized) then
		return
	end
	
	local CheckByType = type (quest)
	
	for i = 1, #tracker.MODULES do
		local module = tracker.MODULES [i]
		for blockName, usedBlock in pairs (module.usedBlocks) do
		
			local questID = usedBlock.id
			if (questID) then
				if (CheckByType == "string") then
					if (HaveQuestData (questID)) then
						local thisQuestName = GetQuestInfoByQuestID (questID)
						if (thisQuestName and thisQuestName == quest) then
							return true
						end
					end
				elseif (CheckByType == "number") then
					if (quest == questID) then
						return true
					end
				end
			end
		end
	end
end

--dispara quando o tracker da interface � atualizado, precisa dar refresh na nossa ancora
local On_ObjectiveTracker_Update = function()
	local tracker = ObjectiveTrackerFrame
	
	if (not tracker.initialized) then
		return
	end

	WorldQuestTracker.UpdateQuestsInArea()

	--pega a altura do tracker de quests
	local y = 0
	for i = 1, #tracker.MODULES do
		local module = tracker.MODULES [i]
		if (module.Header:IsShown()) then
			y = y + module.contentsHeight
			
			if (WorldQuestTracker.db.profile.groupfinder.tracker_buttons) then
				for questID, block in pairs (module.usedBlocks) do
					ff.HandleBTrackerBlock (questID, block)
				end
			end
			
			--> is a module for world quests?
			--if (module.DefaultHeaderText == TRACKER_HEADER_WORLD_QUESTS) then
				--> which blocks are active showing a world quest
			--		if (type (questID) == "number" and HaveQuestData (questID) and QuestMapFrame_IsQuestWorldQuest (questID)) then
			
			--		end
			--	end
			--end

		end
	end
	
	--usado na fun��o da ancora
	if (ObjectiveTrackerFrame.collapsed) then
		WorldQuestTracker.TrackerHeight = 20
	else
		WorldQuestTracker.TrackerHeight = y
	end
	
	-- atualiza a ancora do nosso tracker
	WorldQuestTracker.RefreshTrackerAnchor()
	
end

--quando houver uma atualiza��o no quest tracker, atualizar as ancores do nosso tracker
hooksecurefunc ("ObjectiveTracker_Update", function (reason, id)
	On_ObjectiveTracker_Update()
end)
--quando o jogador clicar no bot�o de minizar o quest tracker, atualizar as ancores do nosso tracker
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:HookScript ("OnClick", function()
	On_ObjectiveTracker_Update()
end)

function WorldQuestTracker:FullTrackerUpdate()
	On_ObjectiveTracker_Update()
end






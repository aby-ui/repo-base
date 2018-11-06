

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

local _
local GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsForPlayerByMapID
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

local worldFramePOIs = WorldQuestTrackerWorldMapPOI
local worldFramePOIs = WorldMapFrame.BorderFrame

local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame

local UpdateDebug = false

local ZoneWidgetPool = WorldQuestTracker.ZoneWidgetPool

local clear_widget = function (self)
	self.Glow:Hide()
	self.highlight:Hide()
	self.IsTrackingGlow:Hide()
	self.IsTrackingRareGlow:Hide()
	self.SelectedGlow:Hide()
	self.CriteriaMatchGlow:Hide()
	self.SpellTargetGlow:Hide()
	self.rareSerpent:Hide()
	self.rareGlow:Hide()
	self.blackBackground:Hide()
	self.circleBorder:Hide()
	self.squareBorder:Hide()
	self.timeBlipRed:Hide()
	self.timeBlipOrange:Hide()
	self.timeBlipYellow:Hide()
	self.timeBlipGreen:Hide()
	self.bgFlag:Hide()
	self.blackGradient:Hide()
	self.flagText:Hide()
	self.criteriaIndicator:Hide()
	self.criteriaIndicatorGlow:Hide()
	self.questTypeBlip:Hide()
	self.flagCriteriaMatchGlow:Hide()
	self.TextureCustom:Hide()
	self.RareOverlay:Hide()
end


-- ~zoneicon ~create
function WorldQuestTracker.CreateZoneWidget (index, name, parent, pinTemplate) --~zone

	local anchorFrame
	
	if (pinTemplate) then
		anchorFrame = CreateFrame ("frame", name .. index .. "Anchor", parent, pinTemplate)
		anchorFrame.dataProvider = WorldQuestTracker.DataProvider
		anchorFrame.worldQuest = true
		anchorFrame.owningMap = WorldQuestTracker.DataProvider:GetMap()
	else
		anchorFrame = CreateFrame ("frame", name .. index .. "Anchor", parent, WorldQuestTracker.DataProvider:GetPinTemplate())
		anchorFrame.dataProvider = WorldQuestTracker.DataProvider
		anchorFrame.worldQuest = true
		anchorFrame.owningMap = WorldQuestTracker.DataProvider:GetMap()
	end
	
	local button = CreateFrame ("button", name .. index, parent)
	button:SetPoint ("center", anchorFrame, "center", 0, 0)
	button.AnchorFrame = anchorFrame
	
	button:SetSize (20, 20)
	
	button:SetScript ("OnEnter", TaskPOI_OnEnter)
	button:SetScript ("OnLeave", TaskPOI_OnLeave)
	button:SetScript ("OnClick", WorldQuestTracker.OnQuestButtonClick)
    button:RegisterForClicks("AnyUp")
	
	button:RegisterForClicks ("LeftButtonDown", "MiddleButtonDown", "RightButtonDown")
	
	local supportFrame = CreateFrame ("frame", nil, button)
	supportFrame:SetPoint ("center")
	supportFrame:SetSize (20, 20)
	button.SupportFrame = supportFrame
	
	button.UpdateTooltip = TaskPOI_OnEnter
	--> looks like something is triggering the tooltip to update on tick
	button.UpdateTooltip = TaskPOI_OnEnter
	button.worldQuest = true
	button.ClearWidget = clear_widget
	
	button.RareOverlay = CreateFrame ("button", button:GetName() .. "RareOverlay", button)
	button.RareOverlay:SetAllPoints()
	button.RareOverlay:SetScript ("OnEnter", WorldQuestTracker.RareWidgetOnEnter)
	button.RareOverlay:SetScript ("OnLeave", WorldQuestTracker.RareWidgetOnLeave)
	button.RareOverlay:SetScript ("OnClick", WorldQuestTracker.RareWidgetOnClick)
	button.RareOverlay:RegisterForClicks ("LeftButtonDown", "RightButtonDown")
	button.RareOverlay:Hide()
	
	button.Texture = supportFrame:CreateTexture (button:GetName() .. "Texture", "BACKGROUND")
	button.Texture:SetPoint ("center", button, "center")
	button.Texture:SetMask ([[Interface\CharacterFrame\TempPortraitAlphaMask]])
	
	button.TextureCustom = supportFrame:CreateTexture (button:GetName() .. "TextureCustom", "BACKGROUND")
	button.TextureCustom:SetPoint ("center", button, "center")
	button.TextureCustom:Hide()
	
	button.Glow = supportFrame:CreateTexture(button:GetName() .. "Glow", "BACKGROUND", -6)
	button.Glow:SetSize (50, 50)
	button.Glow:SetPoint ("center", button, "center")
	button.Glow:SetTexture ([[Interface/WorldMap/UI-QuestPoi-IconGlow]])
	button.Glow:SetBlendMode ("ADD")
	button.Glow:Hide()
	
	button.highlight = supportFrame:CreateTexture (nil, "highlight")
	button.highlight:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\highlight_circleT]])
	button.highlight:SetPoint ("center")
	button.highlight:SetSize (16, 16)
	button.highlight:Hide()
	
	button.IsTrackingGlow = supportFrame:CreateTexture(button:GetName() .. "IsTrackingGlow", "BACKGROUND", -6)
	button.IsTrackingGlow:SetPoint ("center", button, "center")
	button.IsTrackingGlow:SetBlendMode ("ADD")
	button.IsTrackingGlow:SetAlpha (1)
	button.IsTrackingGlow:Hide()
	button.IsTrackingGlow:SetDesaturated (nil)
	--testing another texture
	button.IsTrackingGlow:SetTexture ([[Interface\Calendar\EventNotificationGlow]])
	button.IsTrackingGlow:SetSize (31, 31)
	
	button.IsTrackingRareGlow = supportFrame:CreateTexture(button:GetName() .. "IsTrackingRareGlow", "BACKGROUND", -6)
	button.IsTrackingRareGlow:SetSize (44*0.7, 44*0.7)
	button.IsTrackingRareGlow:SetPoint ("center", button, "center")
	button.IsTrackingRareGlow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\rare_dragon_TrackingT]])
	--button.IsTrackingRareGlow:SetBlendMode ("ADD")
	button.IsTrackingRareGlow:Hide()
	
	button.Shadow = supportFrame:CreateTexture(button:GetName() .. "Shadow", "BACKGROUND", -8)
	button.Shadow:SetSize (24, 24)
	button.Shadow:SetPoint ("center", button, "center")
	button.Shadow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\glow_yellow_roundT]])
	button.Shadow:SetTexture ([[Interface\PETBATTLES\BattleBar-AbilityBadge-Neutral]])
	button.Shadow:SetAlpha (1)
	
	local smallFlashOnTrack = supportFrame:CreateTexture (nil, "overlay", 7)
	smallFlashOnTrack:Hide()
	smallFlashOnTrack:SetTexture ([[Interface\CHARACTERFRAME\TempPortraitAlphaMask]])
	smallFlashOnTrack:SetAllPoints()
	
	local onFlashTrackAnimation = DF:CreateAnimationHub (smallFlashOnTrack, nil, function(self) self:GetParent():Hide() end)
	onFlashTrackAnimation.FlashTexture = smallFlashOnTrack
	WorldQuestTracker:CreateAnimation (onFlashTrackAnimation, "Alpha", 1, .10, 0, 1)
	WorldQuestTracker:CreateAnimation (onFlashTrackAnimation, "Alpha", 2, .10, 1, 0)
	
	local buttonFullAnimation = DF:CreateAnimationHub (button)
	WorldQuestTracker:CreateAnimation (buttonFullAnimation, "Scale", 1, .05, 1, 1, 1.03, 1.03)
	WorldQuestTracker:CreateAnimation (buttonFullAnimation, "Scale", 2, .05, 1.03, 1.03, 1, 1)
	
	local onStartTrackAnimation = DF:CreateAnimationHub (button.IsTrackingGlow, WorldQuestTracker.OnStartClickAnimation)
	onStartTrackAnimation.OnFlashTrackAnimation = onFlashTrackAnimation
	onStartTrackAnimation.ButtonFullAnimation = buttonFullAnimation
	WorldQuestTracker:CreateAnimation (onStartTrackAnimation, "Scale", 1, .05, .9, .9, 1.1, 1.1)
	WorldQuestTracker:CreateAnimation (onStartTrackAnimation, "Scale", 2, .05, 1.2, 1.2, 1, 1)
	
	local onEndTrackAnimation = DF:CreateAnimationHub (button.IsTrackingGlow, WorldQuestTracker.OnStartClickAnimation, WorldQuestTracker.OnEndClickAnimation)
	WorldQuestTracker:CreateAnimation (onEndTrackAnimation, "Scale", 1, .5, 1, 1, .1, .1)
	WorldQuestTracker:CreateAnimation (onEndTrackAnimation, "Alpha", 1, .3, 1, 0)
	button.onStartTrackAnimation = onStartTrackAnimation
	button.onEndTrackAnimation = onEndTrackAnimation
	
	button.SelectedGlow = supportFrame:CreateTexture (button:GetName() .. "SelectedGlow", "OVERLAY", 2)
	button.SelectedGlow:SetBlendMode ("ADD")
	button.SelectedGlow:SetPoint ("center", button, "center")
	
	button.CriteriaMatchGlow = supportFrame:CreateTexture(button:GetName() .. "CriteriaMatchGlow", "BACKGROUND", -1)
	button.CriteriaMatchGlow:SetAlpha (.6)
	button.CriteriaMatchGlow:SetBlendMode ("ADD")
	button.CriteriaMatchGlow:SetPoint ("center", button, "center")
		local w, h = button.CriteriaMatchGlow:GetSize()
		button.CriteriaMatchGlow:SetAlpha (1)
		button.flagCriteriaMatchGlow = supportFrame:CreateTexture (nil, "background")
		button.flagCriteriaMatchGlow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flag_criteriamatchT]])
		button.flagCriteriaMatchGlow:SetPoint ("top", button, "bottom", 0, 3)
		button.flagCriteriaMatchGlow:SetSize (64, 32)
	
	button.SpellTargetGlow = supportFrame:CreateTexture(button:GetName() .. "SpellTargetGlow", "OVERLAY", 1)
	button.SpellTargetGlow:SetAtlas ("worldquest-questmarker-abilityhighlight", true)
	button.SpellTargetGlow:SetAlpha (.6)
	button.SpellTargetGlow:SetBlendMode ("ADD")
	button.SpellTargetGlow:SetPoint ("center", button, "center")
	
	button.rareSerpent = supportFrame:CreateTexture (button:GetName() .. "RareSerpent", "OVERLAY")
	button.rareSerpent:SetWidth (34 * 1.1)
	button.rareSerpent:SetHeight (34 * 1.1)
	button.rareSerpent:SetPoint ("CENTER", 1, 0)
	
	-- � a sombra da serpente no fundo, pode ser na cor azul ou roxa
	button.rareGlow = supportFrame:CreateTexture (nil, "background")
	button.rareGlow:SetPoint ("CENTER", 1, -2)
	button.rareGlow:SetSize (48, 48)
	button.rareGlow:SetAlpha (.85)
	
	--fundo preto
	button.blackBackground = supportFrame:CreateTexture (nil, "background")
	button.blackBackground:SetPoint ("center")
	button.blackBackground:Hide()
	
	--borda circular - nao da scala por causa do set point! 
	button.circleBorder = supportFrame:CreateTexture (nil, "OVERLAY")
	button.circleBorder:SetPoint ("topleft", supportFrame, "topleft", -1, 1)
	button.circleBorder:SetPoint ("bottomright", supportFrame, "bottomright", 1, -1)
	button.circleBorder:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_zone_browT]])
	button.circleBorder:SetTexCoord (0, 1, 0, 1)
	--problema das quests de profiss�o com verde era a circleBorder
	
	button.glassTransparence = supportFrame:CreateTexture (nil, "OVERLAY", 1)
	button.glassTransparence:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_transparency_overlay]])
	button.glassTransparence:SetPoint ("topleft", button, "topleft", -1, 1)
	button.glassTransparence:SetPoint ("bottomright", button, "bottomright", 1, -1)
	button.glassTransparence:SetAlpha (.5)
	button.glassTransparence:Hide()
	
	--borda quadrada
	button.squareBorder = supportFrame:CreateTexture (nil, "OVERLAY", 1)
	button.squareBorder:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_whiteT]])
	button.squareBorder:SetPoint ("topleft", button, "topleft", -1, 1)
	button.squareBorder:SetPoint ("bottomright", button, "bottomright", 1, -1)

	--blip do tempo restante
	button.timeBlipRed = supportFrame:CreateTexture (nil, "OVERLAY")
	button.timeBlipRed:SetPoint ("bottomright", button, "bottomright", 4, -4)
	button.timeBlipRed:SetSize (WorldQuestTracker.Constants.TimeBlipSize, WorldQuestTracker.Constants.TimeBlipSize)
	button.timeBlipRed:SetTexture ([[Interface\COMMON\Indicator-Red]])
	button.timeBlipRed:SetVertexColor (1, 1, 1)
	button.timeBlipRed:SetAlpha (1)
	
	button.timeBlipOrange = supportFrame:CreateTexture (nil, "OVERLAY")
	button.timeBlipOrange:SetPoint ("bottomright", button, "bottomright", 4, -4)
	button.timeBlipOrange:SetSize (WorldQuestTracker.Constants.TimeBlipSize, WorldQuestTracker.Constants.TimeBlipSize)
	button.timeBlipOrange:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
	button.timeBlipOrange:SetVertexColor (1, .7, 0)
	button.timeBlipOrange:SetAlpha (.9)
	
	button.timeBlipYellow = supportFrame:CreateTexture (nil, "OVERLAY")
	button.timeBlipYellow:SetPoint ("bottomright", button, "bottomright", 4, -4)
	button.timeBlipYellow:SetSize (WorldQuestTracker.Constants.TimeBlipSize, WorldQuestTracker.Constants.TimeBlipSize)
	button.timeBlipYellow:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
	button.timeBlipYellow:SetVertexColor (1, 1, 1)
	button.timeBlipYellow:SetAlpha (.8)
	
	button.timeBlipGreen = supportFrame:CreateTexture (nil, "OVERLAY")
	button.timeBlipGreen:SetPoint ("bottomright", button, "bottomright", 4, -4)
	button.timeBlipGreen:SetSize (WorldQuestTracker.Constants.TimeBlipSize, WorldQuestTracker.Constants.TimeBlipSize)
	button.timeBlipGreen:SetTexture ([[Interface\COMMON\Indicator-Green]])
	button.timeBlipGreen:SetVertexColor (1, 1, 1)
	button.timeBlipGreen:SetAlpha (.6)
	
	--blip do indicador de tipo da quest (zone)
	button.questTypeBlip = supportFrame:CreateTexture (nil, "OVERLAY", 2)
	button.questTypeBlip:SetPoint ("topright", button, "topright", 3, 1)
	button.questTypeBlip:SetSize (10, 10)
	button.questTypeBlip:SetAlpha (.8)
	
	--faixa com o tempo
	button.bgFlag = supportFrame:CreateTexture (nil, "OVERLAY", 5)
	button.bgFlag:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flagT]])
	button.bgFlag:SetPoint ("top", button, "bottom", 0, 3)
	button.bgFlag:SetSize (64, 64)
	
	button.blackGradient = supportFrame:CreateTexture (nil, "OVERLAY")
	button.blackGradient:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
	button.blackGradient:SetPoint ("top", button.bgFlag, "top", 0, -1)
	button.blackGradient:SetSize (32, 10)
	button.blackGradient:SetAlpha (.7)
	
	--string da flag
	button.flagText = supportFrame:CreateFontString (nil, "OVERLAY", "GameFontNormal")
	button.flagText:SetText ("13m")
	button.flagText:SetPoint ("top", button.bgFlag, "top", 0, -2)
	DF:SetFontSize (button.flagText, 8)
	
	local criteriaFrame = CreateFrame ("frame", nil, supportFrame)
	local criteriaIndicator = criteriaFrame:CreateTexture (nil, "OVERLAY", 4)
	criteriaIndicator:SetPoint ("bottomleft", button, "bottomleft", -2, -2)
	criteriaIndicator:SetSize (23*.3, 34*.3)  --original sizes: 23 37
	criteriaIndicator:SetAlpha (.8)
	
	criteriaIndicator:SetTexture (WorldQuestTracker.MapData.GeneralIcons.CRITERIA.icon)
	criteriaIndicator:SetTexCoord (unpack (WorldQuestTracker.MapData.GeneralIcons.CRITERIA.coords))
	
	criteriaIndicator:Hide()
	local criteriaIndicatorGlow = criteriaFrame:CreateTexture (nil, "OVERLAY", 3)
	criteriaIndicatorGlow:SetPoint ("center", criteriaIndicator, "center")
	criteriaIndicatorGlow:SetSize (13, 13)
	criteriaIndicatorGlow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\criteriaIndicatorGlowT]])
	criteriaIndicatorGlow:SetTexCoord (0, 1, 0, 1)
	criteriaIndicatorGlow:Hide()
	
	local criteriaAnimation = DF:CreateAnimationHub (criteriaFrame)
	DF:CreateAnimation (criteriaAnimation, "Scale", 1, .15, 1, 1, 1.1, 1.1)
	DF:CreateAnimation (criteriaAnimation, "Scale", 2, .15, 1.2, 1.2, 1, 1)
	criteriaAnimation.LastPlay = 0
	button.CriteriaAnimation = criteriaAnimation
	
	button.Shadow:SetDrawLayer ("BACKGROUND", -8)
	button.blackBackground:SetDrawLayer ("BACKGROUND", -7)
	button.IsTrackingGlow:SetDrawLayer ("BACKGROUND", -6)
	button.Glow:SetDrawLayer ("BACKGROUND", -6)
	button.Texture:SetDrawLayer ("BACKGROUND", -5)
	button.glassTransparence:SetDrawLayer ("BACKGROUND", -4)

	button.IsTrackingRareGlow:SetDrawLayer ("overlay", 0)
	button.circleBorder:SetDrawLayer ("overlay", 1)
	button.squareBorder:SetDrawLayer ("overlay", 1)
	
	button.rareSerpent:SetDrawLayer ("overlay", 3)
	button.rareSerpent:SetDrawLayer ("BACKGROUND", -6)
	button.rareGlow:SetDrawLayer ("BACKGROUND", -7)
	
	button.bgFlag:SetDrawLayer ("overlay", 4)
	button.blackGradient:SetDrawLayer ("overlay", 5)
	button.flagText:SetDrawLayer ("overlay", 6)
	criteriaIndicator:SetDrawLayer ("overlay", 6)
	criteriaIndicatorGlow:SetDrawLayer ("overlay", 7)
	button.timeBlipRed:SetDrawLayer ("overlay", 7)
	button.timeBlipOrange:SetDrawLayer ("overlay", 7)
	button.timeBlipYellow:SetDrawLayer ("overlay", 7)
	button.timeBlipGreen:SetDrawLayer ("overlay", 7)
	button.questTypeBlip:SetDrawLayer ("overlay", 7)

	button.criteriaIndicator = criteriaIndicator
	button.criteriaIndicatorGlow = criteriaIndicatorGlow
	
	button.bgFlag:Hide()
	
	return button
end

--cria os widgets no mapa da zona
function WorldQuestTracker.GetOrCreateZoneWidget (info, index)
	local taskPOI = ZoneWidgetPool [index]
	
	if (not taskPOI) then
		taskPOI = WorldQuestTracker.CreateZoneWidget (index, "WorldQuestTrackerZonePOIWidget", WorldQuestTracker.AnchoringFrame)
		taskPOI.IsZoneQuestButton = true
		ZoneWidgetPool [index] = taskPOI
	end

	taskPOI.Texture:Show()
	return taskPOI
end

--esconde todos os widgets de zona
function WorldQuestTracker.HideZoneWidgets()
	for i = 1, #ZoneWidgetPool do
		ZoneWidgetPool [i]:Hide()
		ZoneWidgetPool [i].AnchorFrame:Hide()
	end
end

--update anchors when zoomed
function WorldQuestTracker.UpdateZoneWidgetAnchors()
	for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
		local widget = WorldQuestTracker.Cache_ShownWidgetsOnZoneMap [i]
		WorldMapPOIFrame_AnchorPOI (widget, widget.PosX, widget.PosY, WORLD_MAP_POI_FRAME_LEVEL_OFFSETS.WORLD_QUEST)
	end
end

local quest_bugged = {}

--atualiza as quest do mapa da zona ~updatezone ~zoneupdate
function WorldQuestTracker.UpdateZoneWidgets (forceUpdate)
	
	--get the map shown in the map frame
	local mapID = WorldQuestTracker.GetCurrentMapAreaID()
	
	WorldQuestTracker.UpdateRareIcons (mapID)
	
	-- or (mapID ~= WorldQuestTracker.LastMapID and not WorldQuestTracker.IsArgusZone (mapID)) -- 8.0 removed
	if (WorldQuestTracker.IsWorldQuestHub (mapID)) then
		return WorldQuestTracker.HideZoneWidgets()
	
	elseif (not WorldQuestTracker.ZoneHaveWorldQuest (mapID)) then
		--print (2)
		return WorldQuestTracker.HideZoneWidgets()
	
	elseif (WorldQuestTracker.IsASubLevel()) then
		--print (3)
		return WorldQuestTracker.HideZoneWidgets()
	end
	
	WorldQuestTracker.RefreshStatusBarVisibility()
	
	WorldQuestTracker.lastZoneWidgetsUpdate = GetTime() --why there's two timers?
	
	--stop the update if it already updated on this tick
	if (WorldQuestTracker.LastZoneUpdate and WorldQuestTracker.LastZoneUpdate == GetTime()) then
		--print (4)
		return
	end
	
	--local taskInfo = GetQuestsForPlayerByMapID (mapID, 1007)
	local taskInfo
	if (mapID == WorldQuestTracker.MapData.ZoneIDs.DALARAN) then
		--taskInfo = GetQuestsForPlayerByMapID (mapID, 1007)
		taskInfo = GetQuestsForPlayerByMapID (mapID) --fix from @legowxelab2z8 from curse
	else
		taskInfo = GetQuestsForPlayerByMapID (mapID, mapID)
	end
	
	local index = 1

	--parar a anima��o de loading
	if (WorldQuestTracker.IsPlayingLoadAnimation()) then
		WorldQuestTracker.StopLoadingAnimation()
	end	
	
	local filters = WorldQuestTracker.db.profile.filters
	local forceShowBrokenShore = WorldQuestTracker.db.profile.filter_force_show_brokenshore
	
	wipe (WorldQuestTracker.Cache_ShownQuestOnZoneMap)
	wipe (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap)
	
	local total_Gold, total_Resources, total_APower = 0, 0, 0
	local scale = WorldQuestTracker.db.profile.zonemap_widgets.scale
	
	local questFailed = false
	local showBlizzardWidgets = WorldQuestTracker.Temp_HideZoneWidgets > GetTime()
	wipe (WorldQuestTracker.CurrentZoneQuests)
	wipe (WorldQuestTracker.ShowDefaultWorldQuestPin)
	
	local bountyQuestId = WorldQuestTracker.GetCurrentBountyQuest()
	
	--print (WorldQuestTracker.GetMapName (mapID), #taskInfo) --DEBUG: amount of quests on the map
	
	local testCounter = 0
	
	-- "Supplies Needed"
	
	if (taskInfo and #taskInfo > 0) then
	
		local needAnotherUpdate = false
	
		for i, info  in ipairs (taskInfo) do
			local questID = info.questId

			if (HaveQuestData (questID)) then
				local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
				if (isWorldQuest and WorldQuestTracker.CanShowQuest (info)) then

					local isSuppressed = WorldQuestTracker.DataProvider:IsQuestSuppressed (questID)
					local passFilters = WorldQuestTracker.DataProvider:DoesWorldQuestInfoPassFilters (info)

					local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
					
					if (timeLeft == 0) then
						timeLeft = 1
					end
					
					if (timeLeft > 0) then --not isSuppressed and passFilters and timeLeft and 
						
						local can_cache = true
						if (not HaveQuestRewardData (questID)) then
							C_TaskQuest.RequestPreloadRewardData (questID)
							can_cache = false
							needAnotherUpdate = true
						end
						WorldQuestTracker.CurrentZoneQuests [questID] = true
						
						local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount = WorldQuestTracker.GetOrLoadQuestData (questID, can_cache)
						local filter, order = WorldQuestTracker.GetQuestFilterTypeAndOrder (worldQuestType, gold, rewardName, itemName, isArtifact, stackAmount, numRewardItems, rewardTexture)
						
						local passFilter = filters [filter]
						
						if (not passFilter) then
							if (rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
								passFilter = true
							elseif (WorldQuestTracker.db.profile.filter_always_show_faction_objectives) then
								local isCriteria = IsQuestCriteriaForBounty (questID, bountyQuestId)

								if (isCriteria) then
									passFilter = true
								end
							end
							
						elseif (WorldQuestTracker.db.profile.zone_only_tracked) then
							if (not WorldQuestTracker.IsQuestBeingTracked (questID)) then
								passFilter = false
							end
						end

						--todo: broken shore is outdated, as well as argus
						if (passFilter or (forceShowBrokenShore and WorldQuestTracker.IsArgusZone (mapID))) then
							local widget = WorldQuestTracker.GetOrCreateZoneWidget (info, index)
							
							if (widget.questID ~= questID or forceUpdate or not widget.Texture:GetTexture()) then
							
								local selected = questID == GetSuperTrackedQuestID()
								
								local isCriteria = IsQuestCriteriaForBounty (questID, bountyQuestId)
								
								local isSpellTarget = SpellCanTargetQuest() and IsQuestIDValidSpellTarget (questID)
								
								widget.mapID = mapID
								widget.questID = questID
								widget.numObjectives = info.numObjectives
								widget.questName = title
								widget.Order = order or 1
								
								--> cache reward amount
								widget.Currency_Gold = gold or 0
								widget.Currency_ArtifactPower = artifactPower or 0
								widget.Currency_Resources = numRewardItems or 0
								
								widget.PosX = info.x
								widget.PosY = info.y

								local inProgress
								
								WorldQuestTracker.SetupWorldQuestButton (widget, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, mapID)
								
								widget.AnchorFrame.questID = questID
								widget.AnchorFrame.numObjectives = widget.numObjectives
								
								WorldQuestTrackerAddon.DataProvider:GetMap():SetPinPosition (widget.AnchorFrame, widget.PosX, widget.PosY)
								
								widget.AnchorFrame:Show()
								widget:SetFrameLevel (WorldQuestTracker.DefaultFrameLevel + floor (random (1, 30)))
								
								widget:Show()

								tinsert (WorldQuestTracker.Cache_ShownQuestOnZoneMap, questID)
								tinsert (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap, widget)
								
								widget:SetScale (scale)
								--widget.SupportFrame:SetScale (scale)
								--widget.circleBorder:SetScale (1.3)

								if (gold) then
									total_Gold = total_Gold + gold
								end
								if (numRewardItems) then
									total_Resources = total_Resources + numRewardItems
								end
								if (isArtifact) then
									total_APower = total_APower + artifactPower
								end
								
								if (showBlizzardWidgets) then
									widget:Hide()
									for _, button in ipairs (WorldQuestTracker.AllTaskPOIs) do
										if (button.questID == questID) then
											button:Show()
										end
									end
								else
									widget:Show()
								end
								
								if (timeLeft == 1) then
									--let the default UI show the icon if the time is mess off
									widget:Hide()
									WorldQuestTracker.ShowDefaultPinForQuest (questID)
								end
								
							else
							
								if (showBlizzardWidgets) then
									widget:Hide()
									for _, button in ipairs (WorldQuestTracker.AllTaskPOIs) do
										if (button.questID == questID) then
											button:Show()
										end
									end
								else
									widget:Show()
									
									--> sum totals for the statusbar
									if (widget.Currency_Gold) then
										total_Gold = total_Gold + widget.Currency_Gold
									end
									if (widget.Currency_Resources) then
										total_Resources = total_Resources + widget.Currency_Resources
									end
									if (widget.Currency_ArtifactPower) then
										total_APower = total_APower + widget.Currency_ArtifactPower
									end
									
									--> add the widget to cache tables
									tinsert (WorldQuestTracker.Cache_ShownQuestOnZoneMap, questID)
									tinsert (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap, widget)
								end
							end
							
							index = index + 1
						
						else
							if (not filter) then
								--> if WTQ didn't identify the quest type, allow the default interface to show this quest
								--> this is a safety measure with bugs or new quest types
								WorldQuestTracker.ShowDefaultPinForQuest (questID)
								
							end
						end --pass filters
						
					else
						--show blizzard pin if the quest has an invalid time left
						WorldQuestTracker.ShowDefaultPinForQuest (questID)
					end --time left
					
				end --is world quest
				
			else --have quest data
				if (UpdateDebug) then print ("NeedUpdate 1") end
				quest_bugged [questID] = (quest_bugged [questID] or 0) + 1
				
				if (quest_bugged [questID] <= 2) then
					questFailed = true
					C_TaskQuest.RequestPreloadRewardData (questID)
					WorldQuestTracker.ScheduleZoneMapUpdate (1, true)
				end
				
				--show blizzard pin if the client doesn't have the quest data yet
				WorldQuestTracker.ShowDefaultPinForQuest (questID)
			end
			
		end --end foreach taskinfo
		
		if (needAnotherUpdate) then
			if (UpdateDebug) then print ("NeedUpdate 2") end
			WorldQuestTracker.ScheduleZoneMapUpdate (0.5, true)
		end
		
		if (not WorldQuestTracker.CanCacheQuestData) then
			if (not WorldQuestTracker.PrepareToAllowCachedQuestData) then
				WorldQuestTracker.PrepareToAllowCachedQuestData = C_Timer.NewTimer (10, function()
					WorldQuestTracker.CanCacheQuestData = true
				end)
			end
		end
		
		if (not questFailed) then
			WorldQuestTracker.HideZoneWidgetsOnNextTick = true
			WorldQuestTracker.LastZoneUpdate = GetTime()
		end
	else
		if (UpdateDebug) then print ("NeedUpdate 3") end
		WorldQuestTracker.ScheduleZoneMapUpdate (3)
	end
	
	for i = index, #ZoneWidgetPool do
		ZoneWidgetPool [i]:Hide()
	end
	
	if (WorldQuestTracker.WorldMap_GoldIndicator) then
		WorldQuestTracker.WorldMap_GoldIndicator.text = floor (total_Gold / 10000)
		if (total_Resources >= 1000) then
			WorldQuestTracker.WorldMap_ResourceIndicator.text = WorldQuestTracker.ToK (total_Resources)
		else
			WorldQuestTracker.WorldMap_ResourceIndicator.text = total_Resources
		end
		if (total_APower >= 1000) then
			WorldQuestTracker.WorldMap_APowerIndicator.text = WorldQuestTracker.ToK_FormatBigger (total_APower)
		else
			WorldQuestTracker.WorldMap_APowerIndicator.text = total_APower
		end
		WorldQuestTracker.WorldMap_APowerIndicator.Amount = total_APower
	end
	
	WorldQuestTracker.UpdateZoneSummaryFrame()
	
end

--reset the button
function WorldQuestTracker.ResetWorldQuestZoneButton (self)
	self.isArtifact = nil
	self.circleBorder:Hide()
	self.squareBorder:Hide()
	self.flagText:SetText ("")
	self.Glow:Hide()
	self.SelectedGlow:Hide()
	self.CriteriaMatchGlow:Hide()
	self.SpellTargetGlow:Hide()
	self.IsTrackingGlow:Hide()
	self.IsTrackingRareGlow:Hide()
	self.rareSerpent:Hide()
	self.rareGlow:Hide()
	self.blackBackground:Hide()
	
	self.criteriaIndicator:Hide()
	self.criteriaIndicatorGlow:Hide()
	
	self.flagCriteriaMatchGlow:Hide()
	self.questTypeBlip:Hide()
	self.timeBlipRed:Hide()
	self.timeBlipOrange:Hide()
	self.timeBlipYellow:Hide()
	self.timeBlipGreen:Hide()
	self.blackGradient:Hide()
	self.Shadow:Hide()
	self.TextureCustom:Hide()
	
	self.RareOverlay:Hide()
	self.bgFlag:Hide()
	
	self.IsRare = nil
	self.RareName = nil
	self.RareSerial = nil	
	self.RareTime = nil
	self.RareOwner = nil
end


function WorldQuestTracker.SetupWorldQuestButton (self, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, mapID)
	local questID = self.questID
	if (not questID) then
		return
	end
	
	self.worldQuestType = worldQuestType
	self.rarity = rarity
	self.isElite = isElite
	self.tradeskillLineIndex = tradeskillLineIndex
	self.inProgress = inProgress
	self.selected = selected
	self.isCriteria = isCriteria
	self.isSpellTarget = isSpellTarget
	
	WorldQuestTracker.ResetWorldQuestZoneButton (self)
	
	self.isSelected = selected
	self.isCriteria = isCriteria
	self.isSpellTarget = isSpellTarget
	
	self.flagText:Show()
	self.blackGradient:Show()
	self.Shadow:Show()

	if (HaveQuestData (questID)) then
		local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
	
		--default alpha
		self:SetAlpha (WQT_ZONEWIDGET_ALPHA)
	
		if (self.isCriteria) then
			if (not self.criteriaIndicator:IsShown() and self.CriteriaAnimation.LastPlay + 60 < time()) then
				self.CriteriaAnimation:Play()
				self.CriteriaAnimation.LastPlay = time()
			end
			--self.flagCriteriaMatchGlow:Show()
			self.criteriaIndicator:Show()
			self.criteriaIndicatorGlow:Show()
		else
			self.flagCriteriaMatchGlow:Hide()
			self.criteriaIndicator:Hide()
			self.criteriaIndicatorGlow:Hide()
		end
		
		if (not WorldQuestTracker.db.profile.use_tracker) then
			if (WorldQuestTracker.IsQuestOnObjectiveTracker (questID)) then
				if (rarity == LE_WORLD_QUEST_QUALITY_RARE or rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
					self.IsTrackingRareGlow:Show()
				end
				self.IsTrackingGlow:Show()
			end
		else
			if (WorldQuestTracker.IsQuestBeingTracked (questID)) then
				if (rarity == LE_WORLD_QUEST_QUALITY_RARE or rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
					if (mapID ~= suramar_mapId) then
						self.IsTrackingRareGlow:Show()
					end
				end
				self.IsTrackingGlow:Show()
				self:SetAlpha (1)
			end
		end		

		if (worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
			self.questTypeBlip:Show()
			self.questTypeBlip:SetTexture ([[Interface\PVPFrame\Icon-Combat]])
			self.questTypeBlip:SetTexCoord (0, 1, 0, 1)
			self.questTypeBlip:SetAlpha (1)
			--self.questTypeBlip:SetTexture ([[Interface\PVPFrame\Icons\prestige-icon-2]])
			--self.questTypeBlip:SetTexture ([[Interface\PvPRankBadges\PvPRank01]])
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
			self.questTypeBlip:Show()
			self.questTypeBlip:SetTexture ([[Interface\MINIMAP\ObjectIconsAtlas]])
			--self.questTypeBlip:SetTexCoord (172/512, 201/512, 273/512, 301/512) -- left right    top botton  --7.1.0
			--self.questTypeBlip:SetTexCoord (219/512, 246/512, 478/512, 502/512) -- left right    top botton  --7.2.5
			--self.questTypeBlip:SetTexCoord (387/512, 414/512, 378/512, 403/512) -- left right    top botton  --7.3
			self.questTypeBlip:SetTexCoord (unpack (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_PETBATTLE].coords)) -- left right    top botton  --7.3.5
			self.questTypeBlip:SetAlpha (1)
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
			
		else
			self.questTypeBlip:Hide()
		end
		
		-- tempo restante
		local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
		if (timeLeft and timeLeft > 0) then
			WorldQuestTracker.SetTimeBlipColor (self, timeLeft)
			local okay = false
			
			-- gold
			local goldReward, goldFormated = WorldQuestTracker.GetQuestReward_Gold (questID)
			if (goldReward > 0) then
				local texture = WorldQuestTracker.GetGoldIcon()
				
				WorldQuestTracker.SetIconTexture (self.Texture, texture, false, false)
				
				--self.Texture:SetTexCoord (0, 1, 0, 1)
				self.Texture:SetSize (16, 16)
				self.IconTexture = texture
				self.IconText = goldFormated
				self.flagText:SetText (goldFormated)
				self.circleBorder:Show()
				self.QuestType = QUESTTYPE_GOLD
				
				WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID)
				okay = true
			end
			
			-- poder de artefato
			local artifactXP = GetQuestLogRewardArtifactXP(questID)
			if ( artifactXP > 0 ) then
				--seta icone de poder de artefato
				--return
			end
			
			-- resource
			local name, texture, numRewardItems = WorldQuestTracker.GetQuestReward_Resource (questID)
			if (name and not okay) then
				if (texture) then
				
					self.Texture:SetTexture (WorldQuestTracker.MapData.ReplaceIcon [texture] or texture)

					self.circleBorder:Show()
					self.Texture:SetSize (16, 16)
					self.IconTexture = texture
					self.IconText = numRewardItems
					self.QuestType = QUESTTYPE_RESOURCE
					
					if (numRewardItems >= 1000) then
						self.flagText:SetText (format ("%.1fK", numRewardItems/1000))
						--self.flagText:SetText (comma_value (numRewardItems))
					else
						self.flagText:SetText (numRewardItems)
					end
					
					WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID)
					
					if (self:GetHighlightTexture()) then
						self:GetHighlightTexture():SetTexture ([[Interface\Store\store-item-highlight]])
						self:GetHighlightTexture():SetTexCoord (0, 1, 0, 1)
					end
					okay = true
				end
			end

			-- items
			local itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable = WorldQuestTracker.GetQuestReward_Item (questID)
		
			if (itemName) then
			
				if (isArtifact) then
					local texture = WorldQuestTracker.GetArtifactPowerIcon (artifactPower, true, questID)
					self.Texture:SetSize (16, 16)
					self.Texture:SetTexture (texture)
					
					if (artifactPower >= 1000) then
						if (artifactPower > 999999999) then -- 1B
							self.flagText:SetText (WorldQuestTracker.ToK_FormatBigger (artifactPower))
							
						elseif (artifactPower > 999999) then -- 1M
							--self.flagText:SetText (WorldQuestTracker.ToK (artifactPower))
							self.flagText:SetText (WorldQuestTracker.ToK_FormatBigger (artifactPower))
						elseif (artifactPower > 9999) then
							self.flagText:SetText (WorldQuestTracker.ToK (artifactPower))
						else
							self.flagText:SetText (format ("%.1fK", artifactPower/1000))
						end
					else
						self.flagText:SetText (artifactPower)
					end					

					self.isArtifact = true
					self.IconTexture = texture
					self.IconText = artifactPower
					self.QuestType = QUESTTYPE_ARTIFACTPOWER
				else
					self.Texture:SetSize (16, 16)
					self.Texture:SetTexture (itemTexture) -- 1387639 slice of bacon
					--self.Texture:SetTexCoord (0, 1, 0, 1)
					if (itemLevel > 600 and itemLevel < 780) then
						itemLevel = 810
					end

					local color = ""
					if (quality == 4 or quality == 3) then
						color =  WorldQuestTracker.RarityColors [quality]
					end
					
					self.flagText:SetText ((isStackable and quantity and quantity >= 1 and quantity or false) or (itemLevel and itemLevel > 5 and (color) .. itemLevel) or "")
					-- /run local f=CreateFrame("frame");f:SetPoint("center");f:SetSize(100,100);local t=f:CreateTexture(nil,"overlay");t:SetSize(100,100);t:SetPoint("center");t:SetTexture(1387639)
					
					self.IconTexture = itemTexture
					self.IconText = self.flagText:GetText()
					self.QuestType = QUESTTYPE_ITEM
				end

				if (self:GetHighlightTexture()) then
					self:GetHighlightTexture():SetTexture ([[Interface\Store\store-item-highlight]])
					self:GetHighlightTexture():SetTexCoord (0, 1, 0, 1)
				end

				--self.squareBorder:Show()
				self.circleBorder:Show()
				
				WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID)
				okay = true
			end
			
			if (not okay) then
				if (UpdateDebug) then print ("NeedUpdate 4") end
				WorldQuestTracker.ScheduleZoneMapUpdate()
			end
		else
		--	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
		--	print ("no time left:", title, timeLeft)
			--self:Hide()
		end
		
	else
		if (UpdateDebug) then print ("NeedUpdate 5") end
		WorldQuestTracker.ScheduleZoneMapUpdate()
	end
end

--agenda uma atualiza��o se algum dado de alguma quest n�o estiver dispon�vel ainda
local do_zonemap_update = function (self)
	WorldQuestTracker.UpdateZoneWidgets (self.IsForceUpdate)
end
function WorldQuestTracker.ScheduleZoneMapUpdate (seconds, isForceUpdate)
	if (WorldQuestTracker.ScheduledZoneUpdate and not WorldQuestTracker.ScheduledZoneUpdate._cancelled) then
		--> if the previous schedule was a force update, make the new schedule be be a force update too
		if (WorldQuestTracker.ScheduledZoneUpdate.IsForceUpdate) then
			isForceUpdate = true
		end
		WorldQuestTracker.ScheduledZoneUpdate:Cancel()
	end
	WorldQuestTracker.ScheduledZoneUpdate = C_Timer.NewTimer (seconds or 1, do_zonemap_update)
	WorldQuestTracker.ScheduledZoneUpdate.IsForceUpdate = isForceUpdate
end




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> zone summary  ~summaryframe

local ZoneSumaryFrame = CreateFrame ("frame", "WorldQuestTrackerZoneSummaryFrame", worldFramePOIs)
--ZoneSumaryFrame:SetPoint ("bottomleft", worldFramePOIs, "bottomleft", 0, 210)
ZoneSumaryFrame:SetPoint ("topleft", worldFramePOIs, "topleft", 2, -380)
ZoneSumaryFrame:SetSize (200, 400)

ZoneSumaryFrame.WidgetHeight = 20
ZoneSumaryFrame.WidgetWidth = 160
ZoneSumaryFrame.WidgetBackdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16}
ZoneSumaryFrame.WidgetBackdropColor = {0, 0, 0, 0}
ZoneSumaryFrame.IconSize = 20
ZoneSumaryFrame.IconTextureSize = 16
ZoneSumaryFrame.IconTimeSize = 20

WorldQuestTracker.ZoneSumaryWidgets = {}

ZoneSumaryFrame.Header = CreateFrame ("frame", "WorldQuestTrackerSummaryHeader", ZoneSumaryFrame, "ObjectiveTrackerHeaderTemplate")
ZoneSumaryFrame.Header.Title = ZoneSumaryFrame.Header:CreateFontString (nil, "overlay", "GameFontNormal")
ZoneSumaryFrame.Header.Title:SetText ("Quest Summary")
ZoneSumaryFrame.Header.Desc = ZoneSumaryFrame.Header:CreateFontString (nil, "overlay", "GameFontNormal")
ZoneSumaryFrame.Header.Desc:SetText ("Click to Add to Tracker")
ZoneSumaryFrame.Header.Desc:SetAlpha (.7)
ZoneSumaryFrame.Header:SetPoint ("bottomleft", ZoneSumaryFrame, "topleft", 20, 0)

DF:SetFontSize (ZoneSumaryFrame.Header.Title, 10)
DF:SetFontSize (ZoneSumaryFrame.Header.Desc, 8)

ZoneSumaryFrame.Header.Title:SetPoint ("topleft", ZoneSumaryFrame.Header, "topleft", -9, -2)
ZoneSumaryFrame.Header.Desc:SetPoint ("bottomleft", ZoneSumaryFrame.Header, "bottomleft", -9, 4)
ZoneSumaryFrame.Header.Background:SetWidth (150)
ZoneSumaryFrame.Header.Background:SetHeight (ZoneSumaryFrame.Header.Background:GetHeight()*0.45)
ZoneSumaryFrame.Header.Background:SetTexCoord (0, 1, 0, .45)
ZoneSumaryFrame.Header:Hide()
ZoneSumaryFrame.Header.BlackBackground = ZoneSumaryFrame.Header:CreateTexture (nil, "background")
ZoneSumaryFrame.Header.BlackBackground:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_summaryzoneT]])
ZoneSumaryFrame.Header.BlackBackground:SetAlpha (.8)
ZoneSumaryFrame.Header.BlackBackground:SetSize (150, ZoneSumaryFrame.Header.Background:GetHeight())
ZoneSumaryFrame.Header.BlackBackground:SetPoint ("topleft", ZoneSumaryFrame.Header.Background, "topleft", 8, -14)
ZoneSumaryFrame.Header.BlackBackground:SetPoint ("bottomright", ZoneSumaryFrame.Header.Background, "bottomright", 0, 0)

local GetOrCreateZoneSummaryWidget = function (index)

	local widget = WorldQuestTracker.ZoneSumaryWidgets [index]
	if (widget) then
		return widget
	end
	
	
	local button = CreateFrame ("button", "WorldQuestTrackerZoneSummaryFrame_Widget" .. index, ZoneSumaryFrame)
	
	--button:SetPoint ("bottomleft", ZoneSumaryFrame, "bottomleft", 0, ((index-1)* (ZoneSumaryFrame.WidgetHeight + 1)) -2) --grow bottom to top
	button:SetPoint ("topleft", ZoneSumaryFrame, "topleft", 0, (((index-1) * (ZoneSumaryFrame.WidgetHeight + 1)) -2) * -1) --grow top to bottom
	
	button:SetSize (ZoneSumaryFrame.WidgetWidth, ZoneSumaryFrame.WidgetHeight)
	button:SetFrameLevel (WorldQuestTracker.DefaultFrameLevel + 1)
	
	
	local buttonIcon = WorldQuestTracker.CreateZoneWidget (index, "WorldQuestTrackerZoneSummaryFrame_WidgetIcon", button)
	buttonIcon:SetPoint ("left", button, "left", 2, 0)
	buttonIcon:SetSize (ZoneSumaryFrame.IconSize, ZoneSumaryFrame.IconSize)
	buttonIcon:SetFrameLevel (WorldQuestTracker.DefaultFrameLevel + 2)
	button.Icon = buttonIcon
	
	local art = button:CreateTexture (nil, "border")
	art:SetAllPoints()
	art:SetTexture ([[Interface\ARCHEOLOGY\ArchaeologyParts]])
	art:SetTexCoord (73/512, 320/512, 15/256, 65/256)
	art:SetAlpha (1)
	
	local art2 = button:CreateTexture (nil, "artwork")
	art2:SetAllPoints()
	art2:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_summaryzoneT]])
	art2:SetAlpha (.4)
	button.BlackBackground = art2
	
	local highlight = button:CreateTexture (nil, "highlight")
	highlight:SetAllPoints()
	highlight:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_pixel_whiteT.blp]])
	highlight:SetAlpha (.2)
	button.Highlight = highlight
	
	--border lines
	local lineUp = button:CreateTexture (nil, "overlay")
	lineUp:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_pixel_whiteT.blp]])
	lineUp:SetPoint ("bottomleft", button, "topleft", 0, -1)
	lineUp:SetPoint ("bottomright", button, "topright", 0, -1)
	lineUp:SetHeight (1)
	lineUp:SetVertexColor (0, 0, 0)
	lineUp:SetAlpha (.3)
	
	--border lines
	local lineDown = button:CreateTexture (nil, "overlay")
	lineDown:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_pixel_whiteT.blp]])
	lineDown:SetPoint ("topleft", button, "bottomleft", 0, 1)
	lineDown:SetPoint ("topright", button, "bottomright", 0, 1)
	lineDown:SetHeight (1)
	lineDown:SetVertexColor (0, 0, 0)
	lineDown:SetAlpha (.3)
	button.LineDown = lineDown
	button.LineUp = lineUp
	--

	local x = 75
	buttonIcon.timeBlipRed:ClearAllPoints()
	buttonIcon.timeBlipRed:SetPoint ("left", buttonIcon, "right", x, 0)
	buttonIcon.timeBlipRed:SetSize (ZoneSumaryFrame.IconTimeSize, ZoneSumaryFrame.IconTimeSize)
	buttonIcon.timeBlipRed:SetAlpha (1)
	buttonIcon.timeBlipOrange:ClearAllPoints()
	buttonIcon.timeBlipOrange:SetPoint ("left", buttonIcon, "right", x, 0)
	buttonIcon.timeBlipOrange:SetSize (ZoneSumaryFrame.IconTimeSize, ZoneSumaryFrame.IconTimeSize)
	buttonIcon.timeBlipOrange:SetAlpha (.8)
	buttonIcon.timeBlipYellow:ClearAllPoints()
	buttonIcon.timeBlipYellow:SetPoint ("left", buttonIcon, "right", x, 0)
	buttonIcon.timeBlipYellow:SetSize (ZoneSumaryFrame.IconTimeSize, ZoneSumaryFrame.IconTimeSize)
	buttonIcon.timeBlipYellow:SetAlpha (.6)
	buttonIcon.timeBlipGreen:ClearAllPoints()
	buttonIcon.timeBlipGreen:SetPoint ("left", buttonIcon, "right", x, 0)
	buttonIcon.timeBlipGreen:SetSize (ZoneSumaryFrame.IconTimeSize, ZoneSumaryFrame.IconTimeSize)
	buttonIcon.timeBlipGreen:SetAlpha (.3)
	--
	buttonIcon.criteriaIndicator:ClearAllPoints()
	buttonIcon.criteriaIndicator:SetPoint ("left", buttonIcon, "right", 50, 0)
	buttonIcon.criteriaIndicator:SetSize (23*.4, 37*.4)
	--
	button.Text = DF:CreateLabel (button)
	button.Text:SetPoint ("left", buttonIcon, "right", 3, 0)
	DF:SetFontSize (button.Text, 10)
	DF:SetFontColor (button.Text, "orange")
	--
	
	button.OnTracker = button:CreateTexture (nil, "overlay")
	button.OnTracker:SetPoint ("left", buttonIcon, "right", 63, 0)
	button.OnTracker:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\ArrowFrozen]])
	button.OnTracker:SetAlpha (.65)
	button.OnTracker:SetSize (14, 14)
	button.OnTracker:SetTexCoord (.15, .8, .15, .80)
	
	--
	--animations
	local on_enter_animation = DF:CreateAnimationHub (button, nil, function()
		--button:SetScale (1.1, 1.1)
	end)
	on_enter_animation.Step1 = DF:CreateAnimation (on_enter_animation, "scale", 1, 0.05, 1, 1, 1.05, 1.05)
	on_enter_animation.Step2 = DF:CreateAnimation (on_enter_animation, "scale", 2, 0.05, 1.05, 1.05, 1.0, 1.0)
	button.OnEnterAnimation = on_enter_animation
	
	local on_leave_animation = DF:CreateAnimationHub (button, nil, function()
		--button:SetScale (1.0, 1.0)
	end)
	on_leave_animation.Step1 = DF:CreateAnimation (on_leave_animation, "scale", 1, 0.1, 1.1, 1.1, 1, 1)
	button.OnLeaveAnimation = on_leave_animation
	
	local mouseoverHighlight = WorldQuestTracker.AnchoringFrame:CreateTexture (nil, "overlay")
	mouseoverHighlight:SetTexture ([[Interface\Worldmap\QuestPoiGlow]])
	mouseoverHighlight:SetSize (80, 80)
	mouseoverHighlight:SetBlendMode ("ADD")
	
	button:SetScript ("OnClick", function (self)
		--WorldQuestTracker.AddQuestToTracker (self.Icon)
		for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
			if (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i].questID == self.Icon.questID) then
				WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i]:GetScript ("OnClick")(WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i])
				break
			end
		end
	end)
	
	button:SetScript ("OnEnter", function (self)
		--print ("enter", self:GetScale())
		--self.OnEnterAnimation.Step1:SetFromScale (self.OnEnterAnimation.Step1:GetScale())
		--self.OnLeaveAnimation:Stop()
		--self.OnEnterAnimation:Play()
		--WorldQuestTracker.HaveZoneSummaryHover = self._Twin
		WorldQuestTracker.HaveZoneSummaryHover = self
		self.Icon:GetScript ("OnEnter")(self.Icon)
		WorldMapTooltip:SetPoint ("bottomleft", WorldQuestTracker.HaveZoneSummaryHover, "bottomright", 2, 0)
		
		--GameCooltip:Hide()
		--procura o icone da quest no mapa e indica ele
		for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
			if (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i].questID == self.Icon.questID) then
				mouseoverHighlight:SetPoint ("center", WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i], "center")
				mouseoverHighlight:Show()
				break
			end
		end

	end)
	button:SetScript ("OnLeave", function (self)
		--print ("enter", self:GetScale())
		--self.OnLeaveAnimation.Step1:SetFromScale (self.OnLeaveAnimation.Step1:GetScale())
		--self.OnEnterAnimation:Stop()
		--self.OnLeaveAnimation:Play()
		self.Icon:GetScript ("OnLeave")(self.Icon)
		WorldQuestTracker.HaveZoneSummaryHover = nil
		mouseoverHighlight:Hide()
	end)
	
	WorldQuestTracker.ZoneSumaryWidgets [index] = button
	return button
end

function WorldQuestTracker.ClearZoneSummaryButtons()
	for _, button in ipairs (WorldQuestTracker.ZoneSumaryWidgets) do
		button:Hide()
	end
	WorldQuestTracker.QuestSummaryShown = true
	ZoneSumaryFrame.Header:Hide()
end

function WorldQuestTracker.SetupZoneSummaryButton (summaryWidget, zoneWidget)
	local Icon = summaryWidget.Icon
	
	Icon.mapID = zoneWidget.mapID
	Icon.questID = zoneWidget.questID
	Icon.numObjectives = zoneWidget.numObjectives
	
	WorldQuestTracker.SetupWorldQuestButton (Icon, zoneWidget.worldQuestType, zoneWidget.rarity, zoneWidget.isElite, zoneWidget.tradeskillLineIndex, zoneWidget.inProgress, zoneWidget.selected, zoneWidget.isCriteria, zoneWidget.isSpellTarget)
	
	--Icon.Shadow:Hide()
	Icon.blackGradient:Hide()
	Icon.rareSerpent:Hide()
	Icon.rareGlow:Hide()
	Icon.bgFlag:Hide()
	Icon.IsTrackingRareGlow:Hide()
	Icon.flagCriteriaMatchGlow:Hide()
	Icon.flagText:Hide()
	
	Icon.IsTrackingGlow:SetSize (30, 30)
	Icon.IsTrackingGlow:Hide()
	Icon.criteriaIndicatorGlow:Hide()
	
	Icon.Texture:SetSize (ZoneSumaryFrame.IconTextureSize, ZoneSumaryFrame.IconTextureSize)
	Icon.Texture:SetAlpha (.75)
	Icon.circleBorder:SetAlpha (.75)
	
	if (zoneWidget.rarity == LE_WORLD_QUEST_QUALITY_COMMON) then
		summaryWidget.LineUp:SetAlpha (.3)
		summaryWidget.LineDown:SetAlpha (.3)
		summaryWidget.LineUp:SetVertexColor (0, 0, 0)
		summaryWidget.LineDown:SetVertexColor (0, 0, 0)
		
	elseif (zoneWidget.rarity == LE_WORLD_QUEST_QUALITY_RARE) then
		local color = BAG_ITEM_QUALITY_COLORS [LE_ITEM_QUALITY_RARE]
		summaryWidget.LineUp:SetAlpha (.8)
		summaryWidget.LineDown:SetAlpha (.8)
		summaryWidget.LineUp:SetVertexColor (color.r, color.g, color.b)
		summaryWidget.LineDown:SetVertexColor (color.r, color.g, color.b)
		
	elseif (zoneWidget.rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
		local color = BAG_ITEM_QUALITY_COLORS [LE_ITEM_QUALITY_EPIC]
		summaryWidget.LineUp:SetAlpha (.8)
		summaryWidget.LineDown:SetAlpha (.8)
		summaryWidget.LineUp:SetVertexColor (color.r, color.g, color.b)
		summaryWidget.LineDown:SetVertexColor (color.r, color.g, color.b)
		
	end
	
	Icon.flagText:SetText (zoneWidget.IconText)
	summaryWidget.Text:SetText (type (zoneWidget.IconText) == "number" and WorldQuestTracker.ToK (zoneWidget.IconText) or zoneWidget.IconText)

	summaryWidget.BlackBackground:SetAlpha (.4)
	summaryWidget.Highlight:SetAlpha (.2)
	
	summaryWidget:Show()
end

-- ~summary
function WorldQuestTracker.CanShowZoneSummaryFrame()
	return WorldQuestTracker.db.profile.use_quest_summary and WorldQuestTracker.ZoneHaveWorldQuest() and WorldMapFrame.isMaximized
end

function WorldQuestTracker.UpdateZoneSummaryFrame()
	if (not WorldQuestTracker.CanShowZoneSummaryFrame()) then
		if (WorldQuestTracker.QuestSummaryShown) then
			WorldQuestTracker.ClearZoneSummaryButtons()
		end
		return
	end
	
	local index = 1
	WorldQuestTracker.ClearZoneSummaryButtons()
	
	table.sort (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap, function (t1, t2)
		return t1.Order < t2.Order
	end)
	
	local LastWidget
	for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
		local zoneWidget = WorldQuestTracker.Cache_ShownWidgetsOnZoneMap [i]
		local summaryWidget = GetOrCreateZoneSummaryWidget (index)
		summaryWidget._Twin = zoneWidget
		WorldQuestTracker.SetupZoneSummaryButton (summaryWidget, zoneWidget)
		LastWidget = summaryWidget
		
		if (WorldQuestTracker.IsQuestBeingTracked (zoneWidget.questID)) then
			summaryWidget.OnTracker:Show()
		else
			summaryWidget.OnTracker:Hide()
		end
		
		index = index + 1
	end
	
	--attach the header to the last widget
	if (LastWidget) then
		ZoneSumaryFrame.Header:Show()
		--ZoneSumaryFrame.Header:SetPoint ("bottomleft", LastWidget, "topleft", 20, 0)
	end
	
	WorldQuestTracker.QuestSummaryShown = true
end




-- ~bounty
local bountyBoard = WorldQuestTracker.GetOverlay ("IsWorldQuestCriteriaForSelectedBounty")
if (bountyBoard) then
	hooksecurefunc (bountyBoard, "OnTabClick", function (self, mapID)
		for i = 1, #ZoneWidgetPool do 
			local widgetButton = ZoneWidgetPool [i]
			widgetButton.CriteriaAnimation.LastPlay = 0
		end
	end)
	
	local UpdateBountyBoard = function (self, mapID)
		local tabs = self.bountyTabPool
		
		for bountyIndex, bounty in ipairs(self.bounties) do
			local bountyButton
			for button, _ in pairs (tabs.activeObjects) do
				if (button.bountyIndex == bountyIndex) then
					bountyButton = button
					break
				end
			end
			
			--create wtq amount indicator
			if (not bountyButton.objectiveCompletedText) then
				bountyButton.objectiveCompletedText = bountyButton:CreateFontString (nil, "overlay", "GameFontNormal")
				bountyButton.objectiveCompletedText:SetPoint ("bottom", bountyButton, "top", 1, 0)
				bountyButton.objectiveCompletedBackground = bountyButton:CreateTexture (nil, "background")
				bountyButton.objectiveCompletedBackground:SetPoint ("bottom", bountyButton, "top", 0, -1)
				bountyButton.objectiveCompletedBackground:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
				bountyButton.objectiveCompletedBackground:SetSize (42, 12)
				
				bountyButton.objectiveCompletedText:Hide()
				bountyButton.objectiveCompletedBackground:Hide()
				
				local animationHub = WorldQuestTracker:CreateAnimationHub (bountyButton, function() bountyButton.objectiveCompletedText:Show(); bountyButton.objectiveCompletedBackground:Show() end)
				local a = WorldQuestTracker:CreateAnimation (animationHub, "ALPHA", 1, .4, 0, 1)
				a:SetTarget (bountyButton.objectiveCompletedText)
				local b = WorldQuestTracker:CreateAnimation (animationHub, "ALPHA", 1, .4, 0, 0.4)
				b:SetTarget (bountyButton.objectiveCompletedBackground)
				bountyButton.objectiveCompletedAnimation = animationHub
			end
			
			local numCompleted, numTotal = self:CalculateBountySubObjectives (bounty)
			
			if (numCompleted) then
				bountyButton.objectiveCompletedText:SetText (numCompleted .. "/" .. numTotal)
				bountyButton.objectiveCompletedBackground:SetAlpha (.4)
				
				if (not bountyButton.objectiveCompletedText:IsShown()) then
					bountyButton.objectiveCompletedAnimation:Play()
				end
			else
				bountyButton.objectiveCompletedText:SetText ("")
				bountyButton.objectiveCompletedBackground:SetAlpha (0)
			end
			
			bountyButton.lastUpdateByWQT = GetTime()
		end
		
		for button, _ in pairs (tabs.activeObjects) do
			--> check if the button got an update on this execution
			if (not button.lastUpdateByWQT or button.lastUpdateByWQT+1 < GetTime()) then
				--> check if the button was been customized by WQT
				if (button.objectiveCompletedBackground) then
					button.objectiveCompletedText:SetText ("")
					button.objectiveCompletedBackground:SetAlpha (0)
				end
			end
		end
		
	end
	
	hooksecurefunc (bountyBoard, "RefreshBountyTabs", function (self, mapID)
		C_Timer.After (1, function() UpdateBountyBoard (self, mapID) end)
	end)
end

--doo

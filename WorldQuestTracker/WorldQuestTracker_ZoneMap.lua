

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

local on_show_alpha_animation = function (self)
	self:GetParent():Show()
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
	
	if (anchorFrame.Glow) then
		anchorFrame.Glow:Hide()
	end
	
	--/dump WorldQuestTrackerZonePOIWidget5Anchor.Glow
	local button = CreateFrame ("button", name .. index, parent)
	button:SetPoint ("center", anchorFrame, "center", 0, 0)
	button.AnchorFrame = anchorFrame
	
	button:SetSize (20, 20)
	
	button:SetScript ("OnEnter", TaskPOI_OnEnter)
	button:SetScript ("OnLeave", TaskPOI_OnLeave)
	button:SetScript ("OnClick", WorldQuestTracker.OnQuestButtonClick)
	
	button:RegisterForClicks ("LeftButtonDown", "MiddleButtonDown", "RightButtonDown")
	
	--show animation
	button.OnShowAlphaAnimation = DF:CreateAnimationHub (button, on_show_alpha_animation)
	DF:CreateAnimation (button.OnShowAlphaAnimation, "ALPHA", 1, 0.075, 0, 1)
	
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
	
	button.highlight = supportFrame:CreateTexture (nil, "highlight")
	button.highlight:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\highlight_circleT]])
	button.highlight:SetPoint ("center")
	button.highlight:SetSize (16, 16)
	button.highlight:SetAlpha (0.35)
	button.highlight:Hide()
	
	button.IsTrackingGlow = supportFrame:CreateTexture(button:GetName() .. "IsTrackingGlow", "BACKGROUND", -6)
	button.IsTrackingGlow:SetPoint ("center", button, "center")
	button.IsTrackingGlow:SetTexture ([[Interface\Calendar\EventNotificationGlow]])
	button.IsTrackingGlow:SetBlendMode ("ADD")
	button.IsTrackingGlow:SetVertexColor (unpack (WorldQuestTracker.ColorPalette.orange))
	button.IsTrackingGlow:SetSize (31, 31)
	button.IsTrackingGlow:Hide()
	
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
	
	--create the on enter/leave scale mini animation
	
		--animations
		local animaSettings = {
			scaleZone = 0.10, --used when the widget is placed in a zone map
			scaleWorld = 0.10, --used when the widget is placed in the world
			speed = WQT_ANIMATION_SPEED,
		}
		
		do 
			button.OnEnterAnimation = DF:CreateAnimationHub (button, function() end, function() end)
			local anim = WorldQuestTracker:CreateAnimation (button.OnEnterAnimation, "Scale", 1, animaSettings.speed, 1, 1, animaSettings.scaleZone, animaSettings.scaleZone, "center", 0, 0)
			anim:SetEndDelay (60) --this fixes the animation going back to 1 after it finishes
			button.OnEnterAnimation.ScaleAnimation = anim
			
			button.OnLeaveAnimation = DF:CreateAnimationHub (button, function() end, function() end)
			local anim = WorldQuestTracker:CreateAnimation (button.OnLeaveAnimation, "Scale", 2, animaSettings.speed, animaSettings.scaleZone, animaSettings.scaleZone, 1, 1, "center", 0, 0)
			button.OnLeaveAnimation.ScaleAnimation = anim
		end
	
		button:HookScript ("OnEnter", function (self)
		
			button.OriginalFrameLevel = button:GetFrameLevel()
			button:SetFrameLevel (button.OriginalFrameLevel + 50)
		
			if (self.OnEnterAnimation) then
			
				if (not WorldQuestTracker.db.profile.hoverover_animations) then
					return
				end
			
				if (self.OnLeaveAnimation:IsPlaying()) then
					self.OnLeaveAnimation:Stop()
				end
			
				self.OriginalScale = self:GetScale()
				
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					self.ModifiedScale = self.OriginalScale + animaSettings.scaleZone
					self.OnEnterAnimation.ScaleAnimation:SetFromScale (self.OriginalScale, self.OriginalScale)
					self.OnEnterAnimation.ScaleAnimation:SetToScale (self.ModifiedScale, self.ModifiedScale)
					self.OnEnterAnimation:Play()
					
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					self.ModifiedScale = 1 + animaSettings.scaleWorld
					self.OnEnterAnimation.ScaleAnimation:SetFromScale (1, 1)
					self.OnEnterAnimation.ScaleAnimation:SetToScale (self.ModifiedScale, self.ModifiedScale)
					self.OnEnterAnimation:Play()
				end

			end
		end)
		
		button:HookScript ("OnLeave", function (self)
		
			if (button.OriginalFrameLevel) then
				button:SetFrameLevel (button.OriginalFrameLevel)
			end		
		
			if (self.OnLeaveAnimation) then
				if (not WorldQuestTracker.db.profile.hoverover_animations) then
					return
				end
			
				if (self.OnEnterAnimation:IsPlaying()) then
					self.OnEnterAnimation:Stop()
				end
				
				local currentScale = self.ModifiedScale
				local originalScale = self.OriginalScale
				
				if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
					self.OnLeaveAnimation.ScaleAnimation:SetFromScale (currentScale, currentScale)
					self.OnLeaveAnimation.ScaleAnimation:SetToScale (originalScale, originalScale)
				
				elseif (WorldQuestTrackerAddon.GetCurrentZoneType() == "world") then
					self.OnLeaveAnimation.ScaleAnimation:SetFromScale (currentScale, currentScale)
					self.OnLeaveAnimation.ScaleAnimation:SetToScale (1, 1)
				end
				
				self.OnLeaveAnimation:Play()
			end
		end)
	
	WorldQuestTracker.CreateStartTrackingAnimation (button, nil, 5)
	
	local smallFlashOnTrack = supportFrame:CreateTexture (nil, "overlay", 7)
	smallFlashOnTrack:Hide()
	smallFlashOnTrack:SetTexture ([[Interface\CHARACTERFRAME\TempPortraitAlphaMask]])
	smallFlashOnTrack:SetAllPoints()
	
	--make the highlight for faction indicator
		local factionPulseAnimationTexture = button:CreateTexture (nil, "background", 6)
		factionPulseAnimationTexture:SetPoint ("center", button, "center")
		factionPulseAnimationTexture:SetTexture ([[Interface\CHARACTERFRAME\TempPortraitAlphaMaskSmall]])
		factionPulseAnimationTexture:SetSize (WorldQuestTracker.Constants.WorldMapSquareSize * 1.3, WorldQuestTracker.Constants.WorldMapSquareSize * 1.3)
		factionPulseAnimationTexture:Hide()
		
		button.FactionPulseAnimation = DF:CreateAnimationHub (factionPulseAnimationTexture, function() factionPulseAnimationTexture:Show() end, function() factionPulseAnimationTexture:Hide() end)
		local anim = WorldQuestTracker:CreateAnimation (button.FactionPulseAnimation, "Alpha", 1, .35, 0, .5)
		anim:SetSmoothing ("OUT")
		local anim = WorldQuestTracker:CreateAnimation (button.FactionPulseAnimation, "Alpha", 2, .35, .5, 0)
		anim:SetSmoothing ("OUT")
		button.FactionPulseAnimation:SetLooping ("REPEAT")
	
	local onFlashTrackAnimation = DF:CreateAnimationHub (smallFlashOnTrack, nil, function(self) self:GetParent():Hide() end)
	onFlashTrackAnimation.FlashTexture = smallFlashOnTrack
	WorldQuestTracker:CreateAnimation (onFlashTrackAnimation, "Alpha", 1, .1, 0, 1)
	WorldQuestTracker:CreateAnimation (onFlashTrackAnimation, "Alpha", 2, .1, 1, 0)
	
	local buttonFullAnimation = DF:CreateAnimationHub (button)
	WorldQuestTracker:CreateAnimation (buttonFullAnimation, "Scale", 1, .1, 1, 1, 1.03, 1.03)
	WorldQuestTracker:CreateAnimation (buttonFullAnimation, "Scale", 2, .1, 1.03, 1.03, 1, 1)
	
	local onStartTrackAnimation = DF:CreateAnimationHub (button.IsTrackingGlow, WorldQuestTracker.OnStartClickAnimation)
	onStartTrackAnimation.OnFlashTrackAnimation = onFlashTrackAnimation
	onStartTrackAnimation.ButtonFullAnimation = buttonFullAnimation
	WorldQuestTracker:CreateAnimation (onStartTrackAnimation, "Scale", 1, .1, .9, .9, 1.1, 1.1)
	WorldQuestTracker:CreateAnimation (onStartTrackAnimation, "Scale", 2, .1, 1.2, 1.2, 1, 1)
	
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
	button.rareSerpent:SetPoint ("CENTER", 1, -1)
	
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
	
	local bountyRingPadding = 5
	local bountyRing = supportFrame:CreateTexture (nil, "overlay")
	bountyRing:SetPoint ("topleft", button.circleBorder, "topleft", 0, 0)
	bountyRing:SetPoint ("bottomright", button.circleBorder, "bottomright", 0, 0)
	--bountyRing:SetPoint ("topleft", supportFrame, "topleft", -2.5, 2.5)
	--bountyRing:SetPoint ("bottomright", supportFrame, "bottomright", 2.5, -2.5)
	bountyRing:SetAtlas ("worldquest-emissary-ring")
	bountyRing:SetAlpha (0.92)
	bountyRing:Hide()
	button.BountyRing = bountyRing
	
	local criteriaAnimation = DF:CreateAnimationHub (criteriaFrame)
	DF:CreateAnimation (criteriaAnimation, "Scale", 1, .10, 1, 1, 1.1, 1.1)
	DF:CreateAnimation (criteriaAnimation, "Scale", 2, .10, 1.2, 1.2, 1, 1)
	criteriaAnimation.LastPlay = 0
	button.CriteriaAnimation = criteriaAnimation
	
	local colorBlindTrackerIcon = supportFrame:CreateTexture (nil, "overlay")
	colorBlindTrackerIcon:SetTexture ([[Interface\WORLDSTATEFRAME\ColumnIcon-FlagCapture2]])
	colorBlindTrackerIcon:SetSize (24, 24)
	colorBlindTrackerIcon:SetPoint ("bottom", button, "top", 0, -5)
	colorBlindTrackerIcon:SetVertexColor (1, .2, .2)
	colorBlindTrackerIcon:Hide()
	button.colorBlindTrackerIcon = colorBlindTrackerIcon
	
	button.Shadow:SetDrawLayer ("BACKGROUND", -8)
	button.blackBackground:SetDrawLayer ("BACKGROUND", -7)
	button.IsTrackingGlow:SetDrawLayer ("BACKGROUND", -6)
	button.Texture:SetDrawLayer ("BACKGROUND", -5)
	
	button.IsTrackingRareGlow:SetDrawLayer ("overlay", 0)
	button.circleBorder:SetDrawLayer ("overlay", 1)
	bountyRing:SetDrawLayer ("overlay", 7)
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
function WorldQuestTracker.GetOrCreateZoneWidget (index)
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
local dazaralor_quests = {
	{0.441, 0.322},
	{0.441, 0.362},
	{0.441, 0.402},
	{0.441, 0.442},
	{0.441, 0.482},
	{0.441, 0.522},
}

--atualiza as quest do mapa da zona ~updatezone ~zoneupdate
function WorldQuestTracker.UpdateZoneWidgets (forceUpdate)
	
	--get the map shown in the map frame
	local mapID = WorldQuestTracker.GetCurrentMapAreaID()
	
	WorldQuestTracker.UpdateRareIcons (mapID)
	
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
	
	local total_Gold, total_Resources, total_APower, total_Pet = 0, 0, 0, 0
	local scale = WorldQuestTracker.db.profile.zone_map_config.scale
	
	local questFailed = false
	local showBlizzardWidgets = WorldQuestTracker.Temp_HideZoneWidgets > GetTime()
	if (not showBlizzardWidgets) then
		--if not suppresss regular widgets, see if not showing from the profile
		showBlizzardWidgets = not WorldQuestTracker.db.profile.zone_map_config.show_widgets
	end
	
	wipe (WorldQuestTracker.CurrentZoneQuests)
	wipe (WorldQuestTracker.ShowDefaultWorldQuestPin)
	
	local bountyQuestId = WorldQuestTracker.GetCurrentBountyQuest()
	
	--print (WorldQuestTracker.GetMapName (mapID), #taskInfo) --DEBUG: amount of quests on the map
	
	local testCounter = 0
	local workerQuestIndex = 1
	local bannedQuests = WorldQuestTracker.db.profile.banned_quests
	
	WorldQuestTracker.CurrentZoneQuestsMapID = mapID

	if (taskInfo and #taskInfo > 0) then
	
		local needAnotherUpdate = false
	
		for i, info  in ipairs (taskInfo) do
			local questID = info.questId

			if (HaveQuestData (questID)) then
			
				local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
				local isNotBanned = not bannedQuests [questID]
				
				if (isWorldQuest and isNotBanned and WorldQuestTracker.CanShowQuest (info)) then

					local isSuppressed = WorldQuestTracker.DataProvider:IsQuestSuppressed (questID)
					local passFilters = WorldQuestTracker.DataProvider:DoesWorldQuestInfoPassFilters (info)

					local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
					
					if (not timeLeft or timeLeft == 0) then
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
								
							elseif (worldQuestType == LE_QUEST_TAG_TYPE_FACTION_ASSAULT) then 
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
						if (passFilter or (forceShowBrokenShore and WorldQuestTracker.IsNewEXPZone (mapID))) then
							local widget = WorldQuestTracker.GetOrCreateZoneWidget (index)
							
							if (widget.questID ~= questID or forceUpdate or not widget.Texture:GetTexture()) then
							
								local selected = questID == GetSuperTrackedQuestID()
								
								local isCriteria = IsQuestCriteriaForBounty (questID, bountyQuestId)
								
								local isSpellTarget = SpellCanTargetQuest() and IsQuestIDValidSpellTarget (questID)
								
								if (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
									total_Pet = total_Pet + 1
								end
							
								widget.mapID = mapID
								widget.questID = questID
								widget.numObjectives = info.numObjectives
								widget.questName = title
								widget.Order = order or 1
								
								--> cache reward amount
								widget.Currency_Gold = gold or 0
								widget.Currency_ArtifactPower = artifactPower or 0
								widget.Currency_Resources = 0
								
								if (WorldQuestTracker.MapData.ResourceIcons [rewardTexture]) then
									widget.Currency_Resources = numRewardItems or 0
								end
								
								local xPos, yPos = info.x, info.y
								
								--dazralon
								if (mapID == 1165) then
									--detect if the quest is a worker quest --0.44248777627945 0.32204276323318
									if (xPos >= 0.43 and xPos <= 0.45) then
										if (yPos >= 0.31 and yPos <= 0.33) then
											local newPos = dazaralor_quests [workerQuestIndex]
											xPos, yPos = newPos[1], newPos[2]
											workerQuestIndex = workerQuestIndex + 1
										end
									end
	
									widget.PosX = xPos
									widget.PosY = yPos
								else
									widget.PosX = info.x
									widget.PosY = info.y
								end

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

								if (gold) then
									total_Gold = total_Gold + gold
								end
								if (numRewardItems and WorldQuestTracker.MapData.ResourceIcons [rewardTexture]) then
									total_Resources = total_Resources + numRewardItems
								end
								if (isArtifact) then
									total_APower = total_APower + artifactPower
								end
								
								if (showBlizzardWidgets) then
									widget:Hide()
									for _, button in WorldQuestTracker.GetDefaultPinIT() do
										if (button.questID == questID) then
											button:Show()
										end
									end
								else
									widget:Show()
									--[=[
									widget:Hide()
									for _, button in WorldQuestTracker.GetDefaultPinIT() do
									print (button)
										if (button.questID == questID) then
											button:Show()
										end
									end
									--]=]
								end
								
								if (timeLeft == 1) then
									--let the default UI show the icon if the time is mess off
									widget:Hide()
									WorldQuestTracker.ShowDefaultPinForQuest (questID)
								end
							else
								if (showBlizzardWidgets) then
									widget:Hide()
									for _, button in WorldQuestTracker.GetDefaultPinIT() do
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
			
				local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
				if (title) then
					if (UpdateDebug) then print ("NeedUpdate 1") end
					quest_bugged [questID] = (quest_bugged [questID] or 0) + 1
					
					if (quest_bugged [questID] <= 2) then
						questFailed = true
						C_TaskQuest.RequestPreloadRewardData (questID)
						WorldQuestTracker.ScheduleZoneMapUpdate (1, true)
					end
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
		
		WorldQuestTracker.WorldMap_PetIndicator.text = total_Pet
	end
	
	WorldQuestTracker.UpdateZoneSummaryFrame()
	
end

--reset the button
function WorldQuestTracker.ResetWorldQuestZoneButton (self)
	self.isArtifact = nil
	self.circleBorder:Hide()
	self.squareBorder:Hide()
	self.flagText:SetText ("")
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
	
	self.BountyRing:Hide()
	
	self.RareOverlay:Hide()
	self.bgFlag:Hide()
	
	self.colorBlindTrackerIcon:Hide()
	
	self.IsRare = nil
	self.RareName = nil
	self.RareSerial = nil	
	self.RareTime = nil
	self.RareOwner = nil
	self.QuestType = nil
	self.Amount = nil
end

--this function does not check if the quest reward is in the client cache
function WorldQuestTracker.SetupWorldQuestButton (self, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, mapID)

	if (type (worldQuestType) == "boolean" and worldQuestType) then
		--quick refresh
		worldQuestType = self.worldQuestType
		rarity = self.rarity
		isElite = self.isElite
		tradeskillLineIndex = self.tradeskillLineIndex
		inProgress = self.inProgress
		selected = self.selected
		isCriteria = self.isCriteria
		isSpellTarget = self.isSpellTarget
		mapID = self.mapID
	end

	local questID = self.questID
	if (not questID) then
		return
	end
	
	WorldQuestTracker.ResetWorldQuestZoneButton (self)
	
	self.worldQuestType = worldQuestType
	self.rarity = rarity
	self.isElite = isElite
	self.tradeskillLineIndex = tradeskillLineIndex
	self.inProgress = inProgress
	self.selected = selected
	self.isCriteria = isCriteria
	self.isSpellTarget = isSpellTarget
	self.mapID = mapID
	
	self.isSelected = selected
	self.isCriteria = isCriteria
	self.isSpellTarget = isSpellTarget
	
	self.flagText:Show()
	self.blackGradient:Show()
	self.Shadow:Show()

	if (HaveQuestData (questID)) then
		local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
	
		--default alpha
		self:SetAlpha (WQT_ZONEWIDGET_ALPHA - 0.05)
		self.FactionID = factionID
	
		if (self.isCriteria) then
			if (WorldQuestTracker.db.profile.accessibility.use_bounty_ring) then
				self.BountyRing:Show()
			end
			
			--if (not self.criteriaIndicator:IsShown() and self.CriteriaAnimation.LastPlay + 60 < time()) then
			--	self.CriteriaAnimation:Play()
			--	self.CriteriaAnimation.LastPlay = time()
			--end
			self.criteriaIndicator:Show()
			self.criteriaIndicator:SetAlpha (1)
			self.criteriaIndicatorGlow:Show()
			self.criteriaIndicatorGlow:SetAlpha (0.7)
		else
			self.flagCriteriaMatchGlow:Hide()
			self.criteriaIndicator:Hide()
			self.criteriaIndicatorGlow:Hide()
			self.BountyRing:Hide()
		end
		
		if (not WorldQuestTracker.db.profile.use_tracker) then
			if (WorldQuestTracker.IsQuestOnObjectiveTracker (questID)) then
				if (rarity == LE_WORLD_QUEST_QUALITY_RARE or rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
					self.IsTrackingRareGlow:Show()
				end
				self.IsTrackingGlow:Show()
				
				if (WorldQuestTracker.db.profile.accessibility.extra_tracking_indicator) then
					self.colorBlindTrackerIcon:Show()
				end
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
				
				if (WorldQuestTracker.db.profile.accessibility.extra_tracking_indicator) then
					self.colorBlindTrackerIcon:Show()
				end
			end
		end		

		if (worldQuestType == LE_QUEST_TAG_TYPE_PVP or worldQuestType == LE_QUEST_TAG_TYPE_FACTION_ASSAULT) then
			self.questTypeBlip:Show()
			self.questTypeBlip:SetTexture ([[Interface\PVPFrame\Icon-Combat]])
			self.questTypeBlip:SetTexCoord (.05, .95, .05, .95)
			self.questTypeBlip:SetAlpha (1)
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
			self.questTypeBlip:Show()
			self.questTypeBlip:SetTexture (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_PETBATTLE].icon)
			self.questTypeBlip:SetTexCoord (unpack (WorldQuestTracker.MapData.QuestTypeIcons [WQT_QUESTTYPE_PETBATTLE].coords))
			self.questTypeBlip:SetAlpha (1)
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
			
		else
			self.questTypeBlip:Hide()
		end
		
		-- tempo restante
		local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
		if (timeLeft < 1) then
			timeLeft = 1
		end
		
		if (timeLeft and timeLeft > 0) then
		
			self.TimeLeft = timeLeft
		
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
				self.Amount = goldReward
				
				WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID, self.isCriteria, isElite)
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
					
					if (WorldQuestTracker.MapData.ResourceIcons [texture]) then
						self.QuestType = QUESTTYPE_RESOURCE
						self.Amount = numRewardItems
					end
					
					if (numRewardItems >= 1000) then
						self.flagText:SetText (format ("%.1fK", numRewardItems/1000))
					else
						self.flagText:SetText (numRewardItems)
					end
					
					WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID, self.isCriteria, isElite)
					
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
					self.Amount = artifactPower
				else
					self.Texture:SetSize (16, 16)
					self.Texture:SetTexture (itemTexture)
					
					local color = ""
					if (quality == 4 or quality == 3) then
						color =  WorldQuestTracker.RarityColors [quality]
					end
					
					self.flagText:SetText ((isStackable and quantity and quantity >= 1 and quantity or false) or (itemLevel and itemLevel > 5 and (color) .. itemLevel) or "")
					self.IconTexture = itemTexture
					self.IconText = self.flagText:GetText()
					self.QuestType = QUESTTYPE_ITEM
				end

				if (self:GetHighlightTexture()) then
					self:GetHighlightTexture():SetTexture ([[Interface\Store\store-item-highlight]])
					self:GetHighlightTexture():SetTexCoord (0, 1, 0, 1)
				end

				--self.circleBorder:Show()
				
				WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID, self.isCriteria, isElite)
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
ZoneSumaryFrame:SetPoint ("topleft", worldFramePOIs, "topleft", 2, -380)
ZoneSumaryFrame:SetSize (200, 400)

ZoneSumaryFrame.WidgetHeight = 20
ZoneSumaryFrame.WidgetWidth = 140
ZoneSumaryFrame.WidgetBackdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16}
ZoneSumaryFrame.WidgetBackdropColor = {0, 0, 0, 0}
ZoneSumaryFrame.IconSize = 20
ZoneSumaryFrame.IconTextureSize = 16
ZoneSumaryFrame.IconTimeSize = 20

WorldQuestTracker.ZoneSumaryWidgets = {}

ZoneSumaryFrame.Header = CreateFrame ("frame", "WorldQuestTrackerSummaryHeader", ZoneSumaryFrame, "ObjectiveTrackerHeaderTemplate")
ZoneSumaryFrame.Header:SetAlpha (0)
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
	button:SetAlpha (WQT_ZONEWIDGET_ALPHA)
	
	--button:SetPoint ("bottomleft", ZoneSumaryFrame, "bottomleft", 0, ((index-1)* (ZoneSumaryFrame.WidgetHeight + 1)) -2) --grow bottom to top
	button:SetPoint ("topleft", ZoneSumaryFrame, "topleft", 0, (((index-1) * (ZoneSumaryFrame.WidgetHeight + 1)) -2) * -1) --grow top to bottom
	button:SetSize (ZoneSumaryFrame.WidgetWidth, ZoneSumaryFrame.WidgetHeight)
	button:SetFrameLevel (WorldQuestTracker.DefaultFrameLevel + 1)
	
	--create a square icon
	local squareIcon = WorldQuestTracker.CreateWorldMapWidget ("ZoneWidget", index, button)
	squareIcon.IsWorldQuestButton = false
	--squareIcon.isWorldMapWidget = false --required when updating borders
	squareIcon.IsZoneSummaryQuestButton = true
	squareIcon:SetPoint ("left", button, "left", 2, 0)
	squareIcon:SetSize (ZoneSumaryFrame.IconSize, ZoneSumaryFrame.IconSize)
	squareIcon:SetFrameLevel (WorldQuestTracker.DefaultFrameLevel + 2)
	squareIcon.IsZoneSummaryButton = true
	button.Icon = squareIcon
	
	local buttonIcon = squareIcon
	buttonIcon.commonBorder:SetPoint ("bottomright", squareIcon, "bottomright")
	buttonIcon.rareBorder:SetPoint ("bottomright", squareIcon, "bottomright")
	buttonIcon.epicBorder:SetPoint ("bottomright", squareIcon, "bottomright")
	buttonIcon.invasionBorder:SetPoint ("bottomright", squareIcon, "bottomright")
	buttonIcon.trackingBorder:SetPoint ("bottomright", squareIcon, "bottomright", 6, -5)
	
	--background
	local art2 = button:CreateTexture (nil, "artwork")
	art2:SetAllPoints()
	art2:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_summaryzoneT]])
	art2:SetAlpha (.5)
	button.BlackBackground = art2
	
	--hover over highlight
	local highlight = button:CreateTexture (nil, "highlight")
	highlight:SetAllPoints()
	highlight:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\border_pixel_whiteT.blp]])
	highlight:SetAlpha (.4)
	button.Highlight = highlight
	
	--resource amount text
	button.Text = DF:CreateLabel (button)
	button.Text:SetPoint ("left", buttonIcon, "right", 3, 0)
	DF:SetFontSize (button.Text, 10)
	DF:SetFontColor (button.Text, "orange")
	
	--faction icon
	local factionIcon = button:CreateTexture (nil, "overlay")
	factionIcon:SetSize (18, 18)
	factionIcon:SetAlpha (.9314)
	factionIcon:SetTexCoord (.1, .9, .1, .9)
	factionIcon:SetPoint ("left", buttonIcon, "right", 30, 0)
	button.factionIcon = factionIcon
	
	--time left text
	local timeLeftText = button:CreateFontString (nil, "overlay", "GameFontNormal")
	timeLeftText:SetPoint ("left", buttonIcon, "right", 66, 0)
	button.timeLeftText = timeLeftText
	
	--transfers the criteria icon from the icon to the button line
	buttonIcon.criteriaIndicator:ClearAllPoints()
	buttonIcon.criteriaIndicator:SetPoint ("left", buttonIcon, "right", 54, 0)
	buttonIcon.criteriaIndicator:SetSize (23*.4, 37*.4)
	
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
	
	--clicking is disable at the moment
	--[=[
	button:SetScript ("OnClick", function (self)
		--WorldQuestTracker.AddQuestToTracker (self.Icon)
		for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
			if (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i].questID == self.Icon.questID) then
				WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i]:GetScript ("OnClick")(WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i])
				break
			end
		end
		print ("click")
	end)
	--]=]
	
	
	button:SetScript ("OnEnter", function (self)
		WorldQuestTracker.HaveZoneSummaryHover = self
		self.Icon:GetScript ("OnEnter")(self.Icon)
		WorldQuestTracker.HighlightOnZoneMap (self.Icon.questID, 1.2, "orange")
		
		--procura o icone da quest no mapa e indica ele
		--[=[
		for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
			if (WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i].questID == self.Icon.questID) then
				mouseoverHighlight:SetPoint ("center", WorldQuestTracker.Cache_ShownWidgetsOnZoneMap[i], "center")
				mouseoverHighlight:Show()
				break
			end
		end
		--]=]
	end)
	
	button:SetScript ("OnLeave", function (self)
		self.Icon:GetScript ("OnLeave")(self.Icon)
		WorldQuestTracker.HaveZoneSummaryHover = nil
		
		WorldQuestTracker.HideMapQuestHighlight()
		
		--mouseoverHighlight:Hide()
	end)
	
	WorldQuestTracker.ZoneSumaryWidgets [index] = button

	--disable mouse click
	button:SetMouseClickEnabled (false)
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
	
	--setup the world quest button within the summary line
	local widget = Icon
	local isCriteria, isNew, isUsingTracker, timeLeft, artifactPowerIcon = zoneWidget.isCriteria, false, false, zoneWidget.TimeLeft, WorldQuestTracker.MapData.ItemIcons ["BFA_ARTIFACT"]
	local questID, numObjectives, mapID = zoneWidget.questID, zoneWidget.numObjectives, zoneWidget.mapID
	
	--update the quest icon
	local okay, gold, resource, apower = WorldQuestTracker.UpdateWorldWidget (widget, questID, numObjectives, mapID, isCriteria, isNew, isUsingTracker, timeLeft, artifactPowerIcon)
	widget.texture:SetTexCoord (.1, .9, .1, .9)
	widget:SetAlpha (WQT_ZONEWIDGET_ALPHA)
	
	widget.background:Hide()
	widget.factionBorder:Hide()
	widget.commonBorder:Hide()
	widget.amountText:Hide()
	widget.amountBackground:Hide()	
	widget.timeBlipRed:Hide()
	widget.timeBlipOrange:Hide()
	widget.timeBlipYellow:Hide()
	widget.timeBlipGreen:Hide()
	widget.trackingGlowBorder:Hide()
	
	--set the amount text
	summaryWidget.Text:SetText (type (zoneWidget.IconText) == "number" and floor (zoneWidget.IconText) or zoneWidget.IconText)
	
	if (widget.criteriaIndicator:IsShown()) then
		summaryWidget.timeLeftText:SetPoint ("left", widget, "right", 66, 0)
		summaryWidget:SetWidth (ZoneSumaryFrame.WidgetWidth)
	else
		summaryWidget.timeLeftText:SetPoint ("left", widget, "right", 54, 0)
		summaryWidget:SetWidth (ZoneSumaryFrame.WidgetWidth - 12)
	end
	
	--set the time left
	local timePriority = WorldQuestTracker.db.profile.sort_time_priority
	local alphaAmount = WQT_WORLDWIDGET_BLENDED + 0.06
	
	if (timePriority and timePriority > 0) then
		if (timePriority < 4) then
			timePriority = 4
		end
		timePriority = timePriority * 60 --4 8 12 16 24
		
		if (timePriority) then
			if (timeLeft <= timePriority) then
				DF:SetFontColor (summaryWidget.timeLeftText, "yellow")
				summaryWidget:SetAlpha (alphaAmount)
				summaryWidget.timeLeftText:SetAlpha (1)
			else
				DF:SetFontColor (summaryWidget.timeLeftText, "white")
				summaryWidget.timeLeftText:SetAlpha (0.8)
				
				if (WorldQuestTracker.db.profile.alpha_time_priority) then
					summaryWidget:SetAlpha (ALPHA_BLEND_AMOUNT - 0.50) --making quests be faded out by default
				else
					summaryWidget:SetAlpha (alphaAmount)
				end
			end
		else
			DF:SetFontColor (summaryWidget.timeLeftText, "white")
			summaryWidget.timeLeftText:SetAlpha (1)
		end
	else
		DF:SetFontColor (summaryWidget.timeLeftText, "white")
		summaryWidget.timeLeftText:SetAlpha (1)
		summaryWidget:SetAlpha (alphaAmount)
	end
	
	if (zoneWidget.worldQuestType == LE_QUEST_TAG_TYPE_FACTION_ASSAULT) then
		summaryWidget:SetAlpha (1)
	end

	summaryWidget.timeLeftText:SetText (timeLeft > 1440 and floor (timeLeft/1440) .. "d" or timeLeft > 60 and floor (timeLeft/60) .. "h" or timeLeft .. "m")
	summaryWidget.timeLeftText:SetJustifyH ("center")
	summaryWidget.timeLeftText:Show()
	
	summaryWidget.factionIcon:SetTexture (WorldQuestTracker.MapData.FactionIcons [widget.FactionID])

	summaryWidget:Show()
end

-- ~summary

function WorldQuestTracker.UpdateZoneSummaryToggleButton (canShow)

	if (not WorldQuestTracker.ZoneSummaryToogleButton) then
		local button = CreateFrame ("button", nil, ZoneSumaryFrame)
		button:SetSize (12, 12)
		button:SetAlpha (.60)
		button:SetPoint ("bottomleft", ZoneSumaryFrame, "topleft", 2, 2)
		
		button:SetScript ("OnClick", function (self)
			WorldQuestTracker.db.profile.quest_summary_minimized = not WorldQuestTracker.db.profile.quest_summary_minimized
			WorldQuestTracker.UpdateZoneSummaryFrame()
		end)
		
		WorldQuestTracker.ZoneSummaryToogleButton = button
	end
	
	local button = WorldQuestTracker.ZoneSummaryToogleButton
	
	--check if can show the minimize button
	local canShowButton = WorldQuestTracker.db.profile.show_summary_minimize_button
	if (not canShowButton) then
		button:Hide()
		return
	else
		button:Show()
	end
	
	local isMinimized = WorldQuestTracker.db.profile.quest_summary_minimized
	
	--change the appearance of the minimize button
	if (not isMinimized) then
		--is showing the summary, not minimized
		button:SetNormalTexture ([[Interface\BUTTONS\UI-SpellbookIcon-PrevPage-Up]])
		button:SetPushedTexture ([[Interface\BUTTONS\UI-SpellbookIcon-PrevPage-Down]])
		button:SetHighlightTexture ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Highlight]])
	else
		--the summary is minimized
		button:SetNormalTexture ([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Up]])
		button:SetPushedTexture ([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Down]])
		button:SetHighlightTexture ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Highlight]])
	end

	local normalTexture = button:GetNormalTexture()
	normalTexture:SetTexCoord (.25, .75, .25, .75)
	local pushedTexture = button:GetPushedTexture()
	pushedTexture:SetTexCoord (.25, .75, .28, .75)
	
	local isZoneMap = WorldQuestTrackerAddon.GetCurrentZoneType() == "zone"
	
	if (not canShow) then
		button:Hide()
		
	elseif (canShow and not isZoneMap) then
		button:Hide()
		
	else
		button:Show()
	end
	
end

function WorldQuestTracker.CanShowZoneSummaryFrame()
	local canShow = WorldQuestTracker.db.profile.use_quest_summary and WorldQuestTracker.ZoneHaveWorldQuest() and (WorldMapFrame.isMaximized or true)
	if (canShow) then
		if (WorldMapFrame.isMaximized) then
			ZoneSumaryFrame:SetPoint ("topleft", worldFramePOIs, "topleft", 2, -380) --380
		else
			ZoneSumaryFrame:SetPoint ("topleft", worldFramePOIs, "topleft", 2, -105) --380
		end
		ZoneSumaryFrame:SetScale (WorldQuestTracker.db.profile.zone_map_config.quest_summary_scale)
	end

	WorldQuestTracker.UpdateZoneSummaryToggleButton (canShow)
	
	return canShow
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
		return t1.Order > t2.Order
	end)
	
	local LastWidget
	local isSummaryMinimized = WorldQuestTracker.db.profile.quest_summary_minimized
	
	if (not isSummaryMinimized) then
		for i = 1, #WorldQuestTracker.Cache_ShownWidgetsOnZoneMap do
			local zoneWidget = WorldQuestTracker.Cache_ShownWidgetsOnZoneMap [i]
			local summaryWidget = GetOrCreateZoneSummaryWidget (index)
			
			summaryWidget._Twin = zoneWidget
			WorldQuestTracker.SetupZoneSummaryButton (summaryWidget, zoneWidget)
			LastWidget = summaryWidget
			
			index = index + 1
		end
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
		
		if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
			WorldQuestTracker.UpdateZoneWidgets (true)
		end
	end)
	
	local UpdateBountyBoard = function (self, mapID)
	
		if (WorldMapFrame.mapID == 905) then --argus
			--the bounty board in argus is above the world quest tracker widgets
			C_Timer.After (0.5, function()
				bountyBoard:ClearAllPoints()
				bountyBoard:SetPoint ("bottomright", WorldQuestTrackerToggleQuestsButton, "bottomright", 0, 45)
			end)
		end
	
		self:SetAlpha (WQT_WORLDWIDGET_ALPHA + 0.02) -- + 0.06
	
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
				
				--increasing the height for the background to also fill the time left text
				bountyButton.objectiveCompletedBackground:SetSize (42, 26) --default height: 12
				
				--show the time left for the bounty
				bountyButton.timeLeftText = bountyButton:CreateFontString (nil, "overlay", "GameFontNormal")
				bountyButton.timeLeftText:SetPoint ("bottom", bountyButton.objectiveCompletedText, "top", 0, 2)
				bountyButton.timeLeftText.DefaultColor = {bountyButton.timeLeftText:GetTextColor()}
				
				bountyButton.objectiveCompletedText:Hide()
				bountyButton.objectiveCompletedBackground:Hide()
				
				local animationHub = WorldQuestTracker:CreateAnimationHub (bountyButton, function() bountyButton.objectiveCompletedText:Show(); bountyButton.objectiveCompletedBackground:Show() end)
				local a = WorldQuestTracker:CreateAnimation (animationHub, "ALPHA", 1, .4, 0, 1)
				a:SetTarget (bountyButton.objectiveCompletedText)
				local b = WorldQuestTracker:CreateAnimation (animationHub, "ALPHA", 1, .4, 0, 0.4)
				b:SetTarget (bountyButton.objectiveCompletedBackground)
				bountyButton.objectiveCompletedAnimation = animationHub
				
				--create reward preview
				local rewardPreview = WorldQuestTracker:CreateImage (bountyButton, "", 16, 16, "overlay")
				rewardPreview:SetPoint ("bottomright", bountyButton, "bottomright", -4, 4)
				rewardPreview:SetMask ([[Interface\CHARACTERFRAME\TempPortraitAlphaMaskSmall]])
				local rewardPreviewBorder = WorldQuestTracker:CreateImage (bountyButton, [[Interface\AddOns\WorldQuestTracker\media\border_zone_browT]], 22, 22, "overlay")
				rewardPreviewBorder:SetVertexColor (.9, .9, .8)
				rewardPreviewBorder:SetPoint ("center", rewardPreview, "center")
				
				--artwork is shared with the blizzard art
				rewardPreview:SetDrawLayer ("overlay", 4)
				rewardPreviewBorder:SetDrawLayer ("overlay", 5)
				--blend
				--rewardPreview:SetAlpha (ALPHA_BLEND_AMOUNT)
				rewardPreviewBorder:SetAlpha (ALPHA_BLEND_AMOUNT)
				
				bountyButton.RewardPreview = rewardPreview
				
			end
			
			local numCompleted, numTotal = self:CalculateBountySubObjectives (bounty)
			
			if (WorldQuestTracker.db.profile.show_emissary_info) then
				if (numCompleted) then
					bountyButton.objectiveCompletedText:SetText (numCompleted .. "/" .. numTotal)
					bountyButton.objectiveCompletedText:SetAlpha (.92)
					bountyButton.objectiveCompletedBackground:SetAlpha (.4)
					
					if (not bountyButton.objectiveCompletedText:IsShown()) then
						bountyButton.objectiveCompletedAnimation:Play()
					end
				else
					bountyButton.objectiveCompletedText:SetText ("")
					bountyButton.objectiveCompletedBackground:SetAlpha (0)
				end
			else
				bountyButton.objectiveCompletedText:SetText ("")
				bountyButton.objectiveCompletedBackground:SetAlpha (0)
			end
			
			
			local bountyQuestID = bounty.questID
			if (bountyQuestID and HaveQuestData (bountyQuestID) and WorldQuestTracker.db.profile.show_emissary_info) then
				local questIndex = GetQuestLogIndexByID (bountyQuestID)
				local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle (questIndex)
			
				--attempt to get the time left on this quest
				local timeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes (questID)
				if (timeLeftMinutes) then
					local inHours = floor (timeLeftMinutes/60)
					bountyButton.timeLeftText:SetText (inHours > 23 and floor (inHours / 24) .. "d" or inHours .. "h")
					if (inHours < 12) then
						bountyButton.timeLeftText:SetTextColor (1, .2, .1)
					elseif (inHours < 24) then
						bountyButton.timeLeftText:SetTextColor (1, .5, .1)
					else
						bountyButton.timeLeftText:SetTextColor (unpack (bountyButton.timeLeftText.DefaultColor))
					end
				else
					bountyButton.timeLeftText:SetText ("?")
				end
			
				if (not HaveQuestRewardData (bountyQuestID)) then
					C_TaskQuest.RequestPreloadRewardData (bountyQuestID)
					WorldQuestTracker.ForceRefreshBountyBoard()
				else
					
					--the current priority order is: item > currency with biggest amount
					--all emisary quests gives gold and artifact power, some gives 400 gold others give 2000
					--same thing for artifact power
					
					local itemName, itemTexture, quantity, quality, isUsable, itemID = GetQuestLogRewardInfo (1, bountyQuestID)
					if (itemName) then
						bountyButton.RewardPreview.texture = itemTexture
						bountyButton.Icon:SetTexture (bounty.icon)
					else
						--> currencies
						local currencies = {}
						
						local numQuestCurrencies = GetNumQuestLogRewardCurrencies (bountyQuestID)
						if (numQuestCurrencies and numQuestCurrencies > 0) then
							local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo (1, bountyQuestID)
							if (name and texture) then
								tinsert (currencies, {name, texture, numItems, 0x1}) --0x1 means is a currency
							end
						end

						local goldReward = WorldQuestTracker.GetQuestReward_Gold (bountyQuestID)
						if (goldReward) then
							local texture, coords = WorldQuestTracker.GetGoldIcon()
							tinsert (currencies, {"gold", texture, goldReward, 0x2}) --0x2 means is gold
						end

						if (currencies [1]) then
							table.sort (currencies, DF.SortOrder3)
							bountyButton.RewardPreview.texture = currencies [1] [2]
							bountyButton.Icon:SetTexture (bounty.icon)
						end
					end

				end
			else
				bountyButton.timeLeftText:SetText ("")
				--bountyButton.Icon:SetTexture (nil)
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
		UpdateBountyBoard (self, mapID)
		--don't remmember why I added a delay, using a direct call now
		--C_Timer.After (0.1, function() UpdateBountyBoard (self, mapID) end)
	end)
		
	function WorldQuestTracker.ForceRefreshBountyBoard()
		if (WorldQuestTracker.RefreshBountyBoardTimer and not WorldQuestTracker.RefreshBountyBoardTimer._cancelled) then
			WorldQuestTracker.RefreshBountyBoardTimer:Cancel()
		end
		
		local bountyBoard = WorldQuestTracker.GetOverlay ("IsWorldQuestCriteriaForSelectedBounty")
		if (bountyBoard) then
			WorldQuestTracker.RefreshBountyBoardTimer = C_Timer.NewTimer (1, function() UpdateBountyBoard (bountyBoard, WorldMapFrame.mapID) end)
		end
	end
end

--doo



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

--debug: print to the chat all quests being tracked
function WorldQuestTracker.DumpTrackingList()
	local t = WorldQuestTracker.table.dump (WorldQuestTracker.QuestTrackList)
	print (t)
end

--return if the quest clicked can be linked to the chat window
function WorldQuestTracker.CanLinkToChat (object, button)
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			
			local questID = (object.questID) or (object.info and object.info.questID)
			
			if (questID) then
				local questName = GetQuestInfoByQuestID (questID)
				local link = [=[|cffffff00|Hquest:@QUESTID:110|h[@QUESTNAME]|h|r]=]
				link = link:gsub ("@QUESTID", questID)
				link = link:gsub ("@QUESTNAME", questName)

				return ChatEdit_InsertLink (link)
			end
		end
	end
end

--> force to show a blizzard pin in the zone map
function WorldQuestTracker.ShowDefaultPinForQuest (questID)
	local defaultPin = WorldQuestTracker.GetDefaultPinForQuest (questID)
	if (defaultPin) then
		defaultPin:Show()
	end
	WorldQuestTracker.ShowDefaultWorldQuestPin [questID] = true
end

--return the red and green color for the given percent, zero = green, one = red
--expect a normalized float 0 ... 1
function WorldQuestTracker.ColorScaleByPercent (percent_scaled)
	local r, g
	percent_scaled = percent_scaled * 100
	if (percent_scaled < 50) then
		r = 255
	else
		r = math.floor ( 255 - (percent_scaled * 2 - 100) * 255 / 100)
	end
	
	if (percent_scaled > 50) then
		g = 255
	else
		g = math.floor ( (percent_scaled * 2) * 255 / 100)
	end
	
	return r, g
end

--update the freresh rate of the arrow in the tracker window
function WorldQuestTracker.UpdateArrowFrequence()
	ARROW_UPDATE_FREQUENCE = WorldQuestTracker.db.profile.arrow_update_frequence
end

--http://richard.warburton.it
local function comma_value (n)
	if (not n) then return "0" end
	n = floor (n)
	if (n == 0) then
		return "0"
	end
	local left,num,right = string.match (n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local symbol_1K, symbol_10K, symbol_1B
if (GetLocale() == "koKR") then
	symbol_1K, symbol_10K, symbol_1B = "천", "만", "억"
elseif (GetLocale() == "zhCN") then
	symbol_1K, symbol_10K, symbol_1B = "千", "万", "亿"
elseif (GetLocale() == "zhTW") then
	symbol_1K, symbol_10K, symbol_1B = "千", "萬", "億"
end

if (symbol_1K) then

	--> replace the To "K" functions if the client is running with asian languages

	--> @yuk6196 (updated on 12 october 2017)
	function WorldQuestTracker.ToK (numero)
		if (numero > 99999999) then
			return format ("%.1f", numero/100000000) .. symbol_1B
		elseif (numero > 999999) then
			return format ("%d", numero/10000) .. symbol_10K
		elseif (numero > 99999) then
			return floor (numero/10000) .. symbol_10K
		elseif (numero > 9999) then
			return format ("%.1f", (numero/10000)) .. symbol_10K
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. symbol_1K
		end
		return format ("%.1f", numero)
	end
	
	WorldQuestTracker.ToK_FormatBigger = WorldQuestTracker.ToK
else

	--> To "K" functions for western clients
	
	--> used on the world map small squares, there's not much space there since patch 7.3, so we are formating them on billions to preserve space
	function WorldQuestTracker.ToK (numero)
		if (numero > 99999999) then
			return format ("%.1f", numero/1000000000) .. "B"
		elseif (numero > 999999) then
			return format ("%.0f", numero/1000000) .. "M"
		elseif (numero > 99999) then
			return floor (numero/1000) .. "K"
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. "K"
		end
		return format ("%.1f", numero)
	end
	
	--> used on zone maps and the on the statusbar where there is more space for numbers
	function WorldQuestTracker.ToK_FormatBigger (numero)
		if (numero > 999999999) then
			return format ("%.0f", numero/1000000000) .. "B"
		elseif (numero > 999999) then
			return format ("%.0f", numero/1000000) .. "M"
		elseif (numero > 99999) then
			return floor (numero/1000) .. "K"
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. "K"
		end
		return format ("%.1f", numero)
	end
end

--return the default pin for the quest
function WorldQuestTracker.GetDefaultPinForQuest (questID)

	--WorldQuestTracker.DefaultWorldQuestPin
	--WorldQuestTracker.DefaultWorldQuestPin [self.questID] = self

	return WorldQuestTracker.DefaultWorldQuestPin [questID]
end

--return the artifact icon
function WorldQuestTracker.GetArtifactPowerIcon (artifactPower, rounded, questID)

	if (questID) then
		return WorldQuestTracker.MapData.ItemIcons ["BFA_ARTIFACT"]
	end

	if (true or artifactPower >= 250) then --for�ando sempre o mesmo icone
		if (rounded) then
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_red_roundT]]
		else
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_redT]]
		end
	elseif (artifactPower >= 120) then
		if (rounded) then
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_yellow_roundT]]
		else	
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_yellowT]]
		end
	else
		if (rounded) then
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_blue_roundT]]
		else	
			return [[Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_blueT]]
		end
	end
end

--return the border texture name by the quest type
function WorldQuestTracker.GetBorderByQuestType (self, rarity, worldQuestType)
	if (worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
		--return "border_zone_browT"
		return "border_zone_redT"
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
		return "border_zone_greenT"
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
		return "border_zone_browT"
	elseif (rarity == LE_WORLD_QUEST_QUALITY_COMMON) then
		if (worldQuestType == LE_QUEST_TAG_TYPE_INVASION) then
			return "border_zone_legionT"
		else
			return "border_zone_whiteT"
		end
	elseif (rarity == LE_WORLD_QUEST_QUALITY_RARE) then
		return "border_zone_blueT"
	elseif (rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
		return "border_zone_pinkT"
	end
end

--try to find the overlay based on the member name
function WorldQuestTracker.GetOverlay (memberName)
	for i = 1, #WorldMapFrame.overlayFrames do
		local overlay = WorldMapFrame.overlayFrames [i]
		if (overlay [memberName]) then
			return overlay
		end
	end
end

--update the anchor of buttons and indicators in the status bar based on if is in fulklscreen or windowed mode
function WorldQuestTracker.UpdateStatusBarAnchors()
	local anchor = WorldQuestTracker.db.profile.bar_anchor
	
	local statusBar = WorldQuestTracker.DoubleTapFrame
	local backgroundTexture = statusBar.BackgroundTexture
	local backgroundBorder = statusBar.BackgroundBorder

	--clear points
	statusBar:ClearAllPoints()
	backgroundTexture:ClearAllPoints()
	backgroundBorder:ClearAllPoints()
	WorldQuestTrackerRewardHistoryButton:ClearAllPoints()
	WorldQuestTracker.IndicatorsAnchor:ClearAllPoints()
	
	if (anchor == "bottom") then
		
		statusBar:SetPoint ("bottomleft", WorldMapFrame.BorderFrame, "bottomleft", 0, 0)
		statusBar:SetPoint ("bottomright", WorldMapFrame.BorderFrame, "bottomright", 0, 0)

		backgroundTexture:SetPoint ("bottomleft", WorldQuestTrackerWorldMapPOI, "bottomleft", 0, 0)
		backgroundTexture:SetPoint ("bottomright", WorldQuestTrackerWorldMapPOI, "bottomright", 0, 0)

		backgroundBorder:SetPoint ("topleft", backgroundTexture, "topleft")
		backgroundBorder:SetPoint ("topright", backgroundTexture, "topright")
		backgroundBorder:SetTexCoord (0, 1, 0, 1)
	
		if (WorldMapFrame.isMaximized) then
			WorldQuestTrackerRewardHistoryButton:SetPoint ("bottomleft", statusBar, "bottomleft", 0, 3)
			WorldQuestTracker.IndicatorsAnchor:SetPoint ("bottomright", WorldQuestTrackerGoToAllianceButton, "bottomleft", -10, 3)
		else
			WorldQuestTrackerRewardHistoryButton:SetPoint ("bottomleft", statusBar, "bottomleft", 0, 2)
			WorldQuestTracker.IndicatorsAnchor:SetPoint ("bottomright", WorldQuestTrackerGoToAllianceButton, "bottomleft", -10, 2)
		end
		
	elseif (anchor == "top") then

		statusBar:SetPoint ("topleft", WorldQuestTrackerWorldMapPOI, "topleft", 0, 0)
		statusBar:SetPoint ("topright", WorldQuestTrackerWorldMapPOI, "topright", 0, 0)

		backgroundTexture:SetPoint ("topleft", statusBar, "topleft", 0, 0)
		backgroundTexture:SetPoint ("topright", statusBar, "topright", 0, 0)

		backgroundBorder:SetPoint ("bottomleft", backgroundTexture, "bottomleft")
		backgroundBorder:SetPoint ("bottomright", backgroundTexture, "bottomright")
		backgroundBorder:SetTexCoord (0, 1, 1, 0)
	
		if (WorldMapFrame.isMaximized) then
			WorldQuestTrackerRewardHistoryButton:SetPoint ("topleft", statusBar, "topleft", 2, -0)
			WorldQuestTracker.IndicatorsAnchor:SetPoint ("topright", statusBar, "topright", -40, -3)
		else
			WorldQuestTrackerRewardHistoryButton:SetPoint ("bottomleft", statusBar, "bottomleft", 0, 2)
			WorldQuestTracker.IndicatorsAnchor:SetPoint ("topright", statusBar, "topright", -40, -3)
		end
	
	end
end

--atualiza a borda nas squares do world map e no mapa da zona ~border
function WorldQuestTracker.UpdateBorder (self, rarity, worldQuestType, mapID)
	if (self.isWorldMapWidget) then
		self.commonBorder:Hide()
		self.rareBorder:Hide()
		self.epicBorder:Hide()
		self.invasionBorder:Hide()
		
		if (WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
			self.borderAnimation:Show()
			self.trackingBorder:Show()
		else
			self.borderAnimation:Hide()
			self.trackingBorder:Hide()
		end
		
		self.shineAnimation:Hide()
		AnimatedShine_Stop (self)
		
		if (rarity == LE_WORLD_QUEST_QUALITY_COMMON and worldQuestType ~= LE_QUEST_TAG_TYPE_INVASION) then
			if (self.isArtifact) then
				self.commonBorder:Show()
			else
				self.commonBorder:Show()
			end
			
			if (worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
				self.commonBorder:SetVertexColor (1, .7, .2)
				
			elseif (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
				self.commonBorder:SetVertexColor (.4, 1, .4)
				
			elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			
			else
				self.commonBorder:SetVertexColor (1, 1, 1)
			end
			
		elseif (rarity == LE_WORLD_QUEST_QUALITY_RARE) then
			self.rareBorder:Show()
			
		elseif (rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
			self.epicBorder:Show()

			self.shineAnimation:Show()
			AnimatedShine_Start (self, 1, 1, 1);
			
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_INVASION) then
			self.invasionBorder:Show()
			
		end

	else
		local borderTextureFile = WorldQuestTracker.GetBorderByQuestType (self, rarity, worldQuestType)
		self.circleBorder:Show()
		self.circleBorder:SetTexture ("Interface\\AddOns\\WorldQuestTracker\\media\\" .. borderTextureFile)
		
		if (rarity == LE_WORLD_QUEST_QUALITY_COMMON) then
			self.bgFlag:Hide()
			self.blackGradient:SetWidth (40)
			self.flagText:SetPoint ("top", self.bgFlag, "top", 0, -2)

		elseif (rarity == LE_WORLD_QUEST_QUALITY_RARE) then
		
			if (mapID ~= WorldQuestTracker.MapData.ZoneIDs.SURAMAR) then
		
				self.rareSerpent:Show()
				self.rareSerpent:SetSize (48, 52)
				self.rareSerpent:SetSize (48*0.7, 52*0.7)
				self.rareSerpent:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\rare_dragon_curveT]])
				
				self.rareGlow:Show()
				self.rareGlow:SetVertexColor (0, 0.36863, 0.74902)
				self.rareGlow:SetSize (48*0.7, 52*0.7)
				self.rareGlow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\rare_dragonT]])
				
				--se estiver sendo trackeada, trocar o banner
				if (WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
					self.bgFlag:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flag_criteriamatchT]])
				else
					self.bgFlag:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flagT]])
				end

				--self.bgFlag:Show()
				self.flagText:SetPoint ("top", self.bgFlag, "top", 0, -3)
				--self.glassTransparence:Show()
			end
			
		elseif (rarity == LE_WORLD_QUEST_QUALITY_EPIC) then
			self.rareSerpent:Show()
			self.rareSerpent:SetSize (48, 52)
			self.rareSerpent:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\rare_dragon_curveT]])
			self.rareGlow:Show()
			self.rareGlow:SetVertexColor (0.58431, 0.07059, 0.78039)
			self.rareGlow:SetSize (48, 52)
			self.rareGlow:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\rare_dragonT]])
			
			--se estiver sendo trackeada, trocar o banner
			if (WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
				self.bgFlag:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flag_criteriamatchT]])
			else
				self.bgFlag:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flagT]])
			end
			
			self.bgFlag:Show()
			self.flagText:SetPoint ("top", self.bgFlag, "top", 0, -3)
		end
		
	end
	
end


--seta a cor do blip do tempo de acordo com o tempo restante da quert
function WorldQuestTracker.SetTimeBlipColor (self, timeLeft)

	local bracket_low = 30
	local bracket_medium = 90
	local bracket_high = 240

	local timePriority = WorldQuestTracker.db.profile.sort_time_priority
	if (timePriority) then
		if (timePriority == 4) then
			bracket_low = 120 --2hrs
			bracket_medium = 180 --3hrs
			bracket_high = 240 --4hrs
		elseif (timePriority == 8) then
			bracket_low = 180 --3hrs
			bracket_medium = 360 --6hrs
			bracket_high = 480 --8hrs
		elseif (timePriority == 12) then
			bracket_low = 240 --4hrs
			bracket_medium = 480 --8hrs
			bracket_high = 720 --12hrs
		elseif (timePriority == 16) then
			bracket_low = 480 --8hrs
			bracket_medium = 720 --12hrs
			bracket_high = 960 --16hrs
		elseif (timePriority == 24) then
			bracket_low = 480 --8hrs
			bracket_medium = 720 --12hrs
			bracket_high = 1440 --24hrs
		end
	end

	if (timeLeft < bracket_low) then
		self.timeBlipRed:Show()
		--blip:SetTexture ([[Interface\COMMON\Indicator-Red]])
		--blip:SetVertexColor (1, 1, 1)
		--blip:SetAlpha (1)
	elseif (timeLeft < bracket_medium) then
		self.timeBlipOrange:Show()
		--blip:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
		--blip:SetVertexColor (1, .7, 0)
		--blip:SetAlpha (.9)
	elseif (timeLeft < bracket_high) then
		self.timeBlipYellow:Show()
		--blip:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
		--blip:SetVertexColor (1, 1, 1)
		--blip:SetAlpha (.8)
	else
		self.timeBlipGreen:Show()

		--blip:SetTexture ([[Interface\COMMON\Indicator-Green]])
		--blip:SetVertexColor (1, 1, 1)
		--blip:SetAlpha (.6)
	end
end


--set the file for the texture
function WorldQuestTracker.SetIconTexture (texture, file, coords, color)
	if (file) then
		texture:SetTexture (file)
	end
	if (coords) then
		texture:SetTexCoord (unpack (coords))
	end
	if (color) then
		texture:SetVertexColor (unpack (color))
	end
end

--refresh the statusbar at the bottom of the map frame
function WorldQuestTracker.RefreshStatusBarVisibility()
	if (not WorldMapFrame:IsShown()) then
		return
	end

	if (WorldQuestTracker.DoubleTapFrame and not InCombatLockdown()) then
		if (WorldQuestTracker.IsWorldQuestHub (WorldQuestTracker.GetCurrentMapAreaID()) or WorldQuestTracker.ZoneHaveWorldQuest (WorldQuestTracker.GetCurrentMapAreaID())) then
			WorldQuestTracker.DoubleTapFrame:Show()
			WorldQuestTracker.DoubleTapFrame.Background:Show()
			WorldQuestTracker.DoubleTapFrame.BackgroundTexture:Show()
			WorldQuestTracker.DoubleTapFrame.BackgroundBorder:Show()
			
			WorldQuestTracker.UpdateStatusBarAnchors()
		else
			WorldQuestTracker.DoubleTapFrame:Hide()
			WorldQuestTracker.DoubleTapFrame.Background:Hide()
			WorldQuestTracker.DoubleTapFrame.BackgroundTexture:Hide()
			WorldQuestTracker.DoubleTapFrame.BackgroundBorder:Hide()
		end
	end
end

--when a button is clicked check if it can add or remove the quest on the tracker
function WorldQuestTracker.CheckAddToTracker (self, button)
	--button � o frame que foi precionado
	local questID = self.questID
	local mapID = self.mapID
	
	--verifica se a quest ja esta sendo monitorada
	if (WorldQuestTracker.IsQuestBeingTracked (questID)) then
		--remover a quest do track
		WorldQuestTracker.RemoveQuestFromTracker (questID)
	else
		--adicionar a quest ao track
		WorldQuestTracker.AddQuestToTracker (self, questID, mapID)
	end
	
	if (self.IsZoneQuestButton) then
		WorldQuestTracker.UpdateZoneWidgets()
	elseif (self.IsWorldQuestButton) then
		WorldQuestTracker.UpdateWorldQuestsOnWorldMap()
	end
end

--when the user clicks on a quest button -- �nclick ~onclick ~click
function WorldQuestTracker.OnQuestButtonClick (self, button)

	if (not self.questID) then
		return
	end

	local TaskPOI_OnClick = WorldMapFrameTaskPOI1 and WorldMapFrameTaskPOI1:GetScript("OnClick") or _G.TaskPOI_OnClick
	if button == "RightButton" and TaskPOI_OnClick then return TaskPOI_OnClick(self, button) end

	if (not HaveQuestData (self.questID)) then
		WorldQuestTracker:Msg (L["S_ERROR_NOTLOADEDYET"])
		return
	end
	
	local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes (self.questID)
	if (not timeLeft or timeLeft <= 0) then
		WorldQuestTracker:Msg (L["S_ERROR_NOTIMELEFT"])
	end
	
--chat link
	if (WorldQuestTracker.CanLinkToChat (self, button)) then
		return
	end

	--was middle button and our group finder is enabled
	if (button == "MiddleButton" and WorldQuestTracker.db.profile.groupfinder.enabled) then
		--WorldQuestTracker.FindGroupForQuest (self.questID)
		
		--> simulate entering a quest to show the group finder window
		ff:PlayerEnteredWorldQuestZone (self.questID)
		return
	end
	
	--middle click without our group finder enabled, check for other addons
	if (button == "MiddleButton" and WorldQuestGroupFinderAddon) then
		WorldQuestGroupFinder.HandleBlockClick (self.questID)
		return
	end
	
--isn't using the tracker
	if (not WorldQuestTracker.db.profile.use_tracker or IsShiftKeyDown()) then
		local defaultPin = WorldQuestTracker.GetDefaultPinForQuest (self.questID)
		if (defaultPin) then
			defaultPin:OnClick()
		end

		if (self.IsZoneQuestButton) then
			WorldQuestTracker.UpdateZoneWidgets()
		else
			WorldQuestTracker.CanShowWorldMapWidgets (true)
		end
		return
	end

--> add the quest to the tracker	
	WorldQuestTracker.CheckAddToTracker (self, button)
	
--animations and sounds
	if (WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
		--widget in the world map
		if (self.trackingGlowBorder) then
			self.trackingGlowBorder:Show()
		end
	else
		--widget in the world map
		if (self.trackingGlowBorder) then
			self.trackingGlowBorder:Hide()
		end
	end

	if (WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
		--zone and world widgets have
		if (self.onEndTrackAnimation:IsPlaying()) then
			self.onEndTrackAnimation:Stop()
		end
		
		self.onStartTrackAnimation:Play()
		
		if (self.OnClickAnimation) then
			self.OnClickAnimation:Play()
		end
		
		if (WorldQuestTracker.db.profile.sound_enabled) then
			if (math.random (5) == 1) then
				PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker1.mp3")
			else
				PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\quest_added_to_tracker2.mp3")	
			end
		end
		
		--if have a anchor frame is a zone widget
		if (self.AnchorFrame) then
			self:SetAlpha (1)
		else
			--otherwise is a world widget
			self:SetAlpha (1)
		end
	else
		if (self.onStartTrackAnimation) then
			if (self.onStartTrackAnimation:IsPlaying()) then
				self.onStartTrackAnimation:Stop()
			end
			self.onEndTrackAnimation:Play()
		end
		
		--if have a anchor frame is a zone widget
		if (self.AnchorFrame) then
			self:SetAlpha (WQT_ZONEWIDGET_ALPHA)
		else
			self:SetAlpha (WQT_WORLDWIDGET_ALPHA)
		end
	end
	
	if (not self.IsWorldQuestButton) then
		WorldQuestTracker.WorldWidgets_NeedFullRefresh = true
	end
end

function WorldQuestTracker.OnStartClickAnimation (self)
	if (self.OnFlashTrackAnimation) then
		self.OnFlashTrackAnimation:GetParent():Show()
		self.OnFlashTrackAnimation:Play()
	end
	
	if (self.ButtonFullAnimation) then
		self.ButtonFullAnimation:Play()
	end
	
	self:GetParent():Show()
end

function WorldQuestTracker.OnEndClickAnimation (self)
	self:GetParent():Hide()
end


--	/run WorldQuestTrackerAddon.SetTextSize ("WorldMap", 10)
function WorldQuestTracker.SetTextSize (MapType, Size)
	if (not WorldQuestTracker.db) then
		C_Timer.After (2, function() WorldQuestTracker.SetTextSize ("WorldMap") end)
	end
	if (MapType == "WorldMap") then
		Size = Size or WorldQuestTracker.db.profile.worldmap_widgets.textsize
		WorldQuestTracker.db.profile.worldmap_widgets.textsize = Size
		local ShadowSizeH, ShadowSizeV = 32, 11
		if (Size == 10) then
			ShadowSizeH, ShadowSizeV = 36, 13
		elseif (Size == 11) then
			ShadowSizeH, ShadowSizeV = 40, 14
		end
		--
		for mapId, configTable in pairs (WorldQuestTracker.mapTables) do
			for _, widget in ipairs (configTable.widgets) do
				DF:SetFontSize (widget.amountText, Size)
				widget.amountBackground:SetSize (ShadowSizeH, ShadowSizeV)
			end
		end
		return
	end
	if (MapType == "ZoneMap") then
		
		return
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> pin mixin

function WorldQuestTrackerPinMixin:OnLoad()
	self:UseFrameLevelType ("PIN_FRAME_LEVEL_AREA_POI")
end

function WorldQuestTrackerPinMixin:OnAcquired (...)
	return self
end

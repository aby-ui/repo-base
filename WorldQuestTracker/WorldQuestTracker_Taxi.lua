

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

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> taxy map widgets ~taxy ~fly
local taxyMapWidgets = {}

--
--WorldQuestTracker.db.profile.taxy_trackedonly

--fazer os blips para o mapa sem zoom
--fazer os blips deseparecerem quando o mapa tiver zoom
--quando pasasr o mouse no blip, mostrar qual quest que �
--quando dar zoom mostrar o icone do reward no lugar da exclama��o

function WorldQuestTracker:GetQuestFullInfo (questID)

	--> attempt to get the quest information from the cache
	--[=[
	local can_cache = true
	if (not HaveQuestRewardData (questID)) then
		C_TaskQuest.RequestPreloadRewardData (questID)
		can_cache = false
	end
	--]=]
	
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount = WorldQuestTracker.GetOrLoadQuestData (questID, false, true)
	--local filter, order = WorldQuestTracker.GetQuestFilterTypeAndOrder (worldQuestType, gold, rewardName, itemName, isArtifact, stackAmount, numRewardItems, rewardTexture)

	return title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount
	
	--[=[
	
	--info
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
	--tempo restante
	local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
	--se � da faction selecionada
	
	local bountyQuestID = WorldQuestTracker.GetCurrentBountyQuest()
	local isCriteria = IsQuestCriteriaForBounty (questID, bountyQuestID)
	
	local selected = questID == GetSuperTrackedQuestID()
	local isSpellTarget = SpellCanTargetQuest() and IsQuestIDValidSpellTarget (questID)
	
	--gold
	local gold, goldFormated = WorldQuestTracker.GetQuestReward_Gold (questID)
	--class hall resource
	local rewardName, rewardTexture, numRewardItems = WorldQuestTracker.GetQuestReward_Resource (questID)
	--item
	local itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable = WorldQuestTracker.GetQuestReward_Item (questID)
	local questType = 0x0
	local texture
	
	if (gold > 0) then
		questType = QUESTTYPE_GOLD
		texture = WorldQuestTracker.GetGoldIcon()
	end
	
	if (rewardName) then
		questType = QUESTTYPE_RESOURCE
		texture = rewardTexture
	end
	
	if (itemName) then
		if (isArtifact) then
			questType = QUESTTYPE_ARTIFACTPOWER
			local artifactIcon = WorldQuestTracker.GetArtifactPowerIcon (artifactPower)
			texture = artifactIcon .. "_round"
		else
			questType = QUESTTYPE_ITEM
			texture = itemTexture
		end
	end
	
	return title, questType, texture, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, selected, isSpellTarget, timeLeft, isCriteria, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable
	
	--]=]
end

function WorldQuestTracker.TaxyFrameHasZoom()
	return true
	--return not FlightMapFrame.ScrollContainer:IsZoomedOut()
end

local TaxyPOIIndex, TaxyPOIContainer = 1, {}
function WorldQuestTracker:GetOrCreateTaxyPOI (parent)
	local button = WorldQuestTracker.CreateZoneWidget (TaxyPOIIndex, "WorldQuestTrackerTaxyPOI", parent)
	button.IsTaxiQuestButton = true
	tinsert (TaxyPOIContainer, button)
	TaxyPOIIndex = TaxyPOIIndex + 1
	return button
end

local onTaxyWidgetClick = function (self, button)
	--se tiver zoom, tratar o clique como qualquer outro
	if (WorldQuestTracker.TaxyFrameHasZoom()) then
		WorldQuestTracker.CheckAddToTracker (self, button)
	else
		--se n�o tiver zoom, ver se a quest esta sendo trackeada
		if (not WorldQuestTracker.IsQuestBeingTracked (self.questID)) then
			--se n�o estiver, adicionar ela ao tracker
			WorldQuestTracker.CheckAddToTracker (self, button)
		else
			--se ela ja estaver sendo trackeada, verificar se foi clique com o botao direito
			if (button == "RightButton") then
				WorldQuestTracker.CheckAddToTracker (self, button)
			end
		end
	end
end
local format_for_taxy_zoom_allquests = function (button)
	button:SetScale (1.3)
	button:SetWidth (20)
	button:SetAlpha (1)
end
local format_for_taxy_nozoom_tracked = function (button, isOnlyTracked)
	button:ClearWidget()
	
	if (isOnlyTracked) then
		button:SetScale (WorldQuestTracker.db.profile.taxy_tracked_scale * 1.4)
	else
		button:SetScale (WorldQuestTracker.db.profile.taxy_tracked_scale)
	end
	
	button:SetWidth (20)
	button:SetAlpha (1)
	
	button.circleBorder:Show()
	
	button.IsTrackingGlow:Show()
	button.IsTrackingGlow:SetAlpha (.4)
end

--this function format quest pins on the taxy map (I know, taxy is with I: taxi)
local format_for_taxy_nozoom_all = function (button)
	button:ClearWidget()

	button:SetScale (WorldQuestTracker.db.profile.taxy_tracked_scale + 0.5)
	button:SetWidth (20)
	button:SetAlpha (.75)
	
	button.circleBorder:Show()
	
	if (WorldQuestTracker.IsQuestBeingTracked (button.questID)) then
		button:SetAlpha (1)
		button.IsTrackingGlow:Show()
		button.IsTrackingGlow:SetAlpha (.5)
	end
end

WorldQuestTracker.TaxyZoneWidgets = {}

function WorldQuestTracker.UpdatePinAfterZoom (timerObject)
	local pin = timerObject.Pin
	pin._UpdateTimer = nil
	pin:SetAlpha (1)
	pin:Show()
end

function WorldQuestTracker:TAXIMAP_OPENED()
	
	--testing FlightMapFrame ~= WorldMapFrame for some addons modifying the flymap
	if (not WorldQuestTracker.FlyMapHook and FlightMapFrame and FlightMapFrame ~= WorldMapFrame) then

		for dataProvider, isInstalled in pairs (FlightMapFrame.dataProviders) do
			if (dataProvider.DoesWorldQuestInfoPassFilters) then
				C_Timer.After (1, function() dataProvider.RefreshAllData (dataProvider) end)
				C_Timer.After (2, function() dataProvider.RefreshAllData (dataProvider) end)
				break
			end
		end

		WorldQuestTracker.Taxy_CurrentShownBlips = WorldQuestTracker.Taxy_CurrentShownBlips or {}
	
		_G ["left"] = nil
		_G ["right"] = nil
		_G ["topleft"] = nil
		_G ["topright"] = nil
	
		--tracking options
		FlightMapFrame.WorldQuestTrackerOptions = CreateFrame ("frame", "WorldQuestTrackerTaxyMapFrame", FlightMapFrame.BorderFrame)
		FlightMapFrame.WorldQuestTrackerOptions:SetSize (1, 1)
		FlightMapFrame.WorldQuestTrackerOptions:SetPoint ("bottomleft", FlightMapFrame.BorderFrame, "bottomleft", 3, 3)
		local doubleTapBackground = FlightMapFrame.WorldQuestTrackerOptions:CreateTexture (nil, "overlay")
		doubleTapBackground:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
		doubleTapBackground:SetPoint ("bottomleft", FlightMapFrame.WorldQuestTrackerOptions, "bottomleft", 0, 0)
		doubleTapBackground:SetSize (630, 18)
		
		local checkboxShowAllQuests_func = function (self, actorTypeIndex, value) 
			WorldQuestTracker.db.profile.taxy_showquests = value
		end
		local checkboxShowAllQuests = DF:CreateSwitch (FlightMapFrame.WorldQuestTrackerOptions, checkboxShowAllQuests_func, WorldQuestTracker.db.profile.taxy_showquests, _, _, _, _, "checkboxShowAllQuests", _, _, _, _, _, DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		checkboxShowAllQuests:SetAsCheckBox()
		checkboxShowAllQuests:SetSize (16, 16)
		checkboxShowAllQuests.tooltip = L["S_FLYMAP_SHOWWORLDQUESTS"]
		checkboxShowAllQuests:SetPoint ("bottomleft", FlightMapFrame.WorldQuestTrackerOptions, "bottomleft", 0, 0)
		local checkboxShowAllQuestsString = DF:CreateLabel (checkboxShowAllQuests, L["S_FLYMAP_SHOWWORLDQUESTS"], 12, "orange", nil, "checkboxShowAllQuestsLabel", nil, "overlay")
		checkboxShowAllQuestsString:SetPoint ("left", checkboxShowAllQuests, "right", 2, 0)
		
		local checkboxShowTrackedOnly_func = function (self, actorTypeIndex, value) 
			WorldQuestTracker.db.profile.taxy_trackedonly = value
		end
		local checkboxShowTrackedOnly = DF:CreateSwitch (FlightMapFrame.WorldQuestTrackerOptions, checkboxShowTrackedOnly_func, WorldQuestTracker.db.profile.taxy_trackedonly, _, _, _, _, "checkboxShowTrackedOnly", _, _, _, _, _, DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		checkboxShowTrackedOnly:SetAsCheckBox()
		checkboxShowTrackedOnly:SetSize (16, 16)
		checkboxShowTrackedOnly.tooltip = L["S_FLYMAP_SHOWTRACKEDONLY_DESC"]
		checkboxShowTrackedOnly:SetPoint ("left", checkboxShowAllQuestsString, "right", 4, 0)
		local checkboxShowTrackedOnlyString = DF:CreateLabel (checkboxShowTrackedOnly, L["S_FLYMAP_SHOWTRACKEDONLY"], 12, "orange", nil, "checkboxShowTrackedOnlyLabel", nil, "overlay")
		checkboxShowTrackedOnlyString:SetPoint ("left", checkboxShowTrackedOnly, "right", 2, 0)
		
		if (not WorldQuestTracker.db.profile.TutorialTaxyMap) then
			local alert = CreateFrame ("frame", "WorldQuestTrackerTaxyTutorial", checkboxShowTrackedOnly.widget, "MicroButtonAlertTemplate")
			alert:SetFrameLevel (302)
			alert.label = "Options are here, show all quests or only those being tracked"
			alert.Text:SetSpacing (4)
			MicroButtonAlert_SetText (alert, alert.label)
			alert:SetPoint ("bottom", checkboxShowTrackedOnly.widget, "top", 0, 30)
			alert:Show()
			WorldQuestTracker.db.profile.TutorialTaxyMap = true
		end
		
		local filters = WorldQuestTracker.db.profile.filters
		
		hooksecurefunc (FlightMapFrame.ScrollContainer, "ZoomIn", function()
			WorldQuestTracker.FlightMapZoomAt = GetTime()
		end)
		hooksecurefunc (FlightMapFrame.ScrollContainer, "ZoomOut", function()
			WorldQuestTracker.FlightMapZoomAt = GetTime()
		end)
		
		FlightMapFrame.ScrollContainer:HookScript ("OnUpdate", function (self, deltaTime)
			if (self.currentScale ~= self.targetScale) then
				local scale = FlightMapFrame.ScrollContainer:GetCanvasScale()
				local pinScale = DF:MapRangeClamped (.6, .2, 1.5, 3, scale)
				
				local defaultScale = WorldQuestTracker.db.profile.taxy_tracked_scale + 0.5
				
				if (scale < 0.3) then
					for _, pin in ipairs (WorldQuestTracker.TaxyZoneWidgets) do
						pin:SetScale (defaultScale)
					end
				else
					for _, pin in ipairs (WorldQuestTracker.TaxyZoneWidgets) do
						pin:SetScale (pinScale)
					end
				end
			end
		end)
		
		local lazy_refresh_frame = CreateFrame ("frame")
		WorldQuestTracker.QueuedPinsToRefresh = {}
		
		local refresh_quest_pin = function (timerObject)
			lazy_refresh_frame:SetScript ("OnUpdate", function (self, deltaTime)
				if (#WorldQuestTracker.QueuedPinsToRefresh > 0 and FlightMapFrame:IsShown()) then
					local questTable = tremove (WorldQuestTracker.QueuedPinsToRefresh)
					if (questTable) then
						local questID, _WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget = unpack (questTable)
						if (questID == _WQT_Twin.questID) then
							WorldQuestTracker.SetupWorldQuestButton (_WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget)
						end
					end
				else
					lazy_refresh_frame:SetScript ("OnUpdate", nil)
				end
			end)
		end
		
		hooksecurefunc (FlightMapFrame, "ApplyPinPosition", function (self, pin, normalizedX, normalizedY, insetIndex)
			
			if (pin.questID and QuestMapFrame_IsQuestWorldQuest (pin.questID)) then
				--> setting a pin for a world quest
				
				
				
			end
			
			
			--if true then return end
			
			if (not pin.questID or not QuestMapFrame_IsQuestWorldQuest (pin.questID)) then
			
				--> invasion point (disable due to the end of Legion)
				--[=[
				if (pin.Texture and pin.Texture:GetTexture() == 1121272) then
					pin:SetAlpha (1)
					pin:Show()
					
					if (not pin._UpdateTimer) then
						pin._UpdateTimer = C_Timer.NewTimer (1, WorldQuestTracker.UpdatePinAfterZoom)
						pin._UpdateTimer.Pin = pin
					end
				end
				--]=]
				
				--fly map icons (feet with the wings)
				if (pin.Icon and pin.Icon:GetTexture() == 1455734) then
					if (not pin.Icon.ExtraShadow) then
						pin.Icon:SetDrawLayer ("overlay")
						pin.Icon.ExtraShadow = pin:CreateTexture (nil, "background")
						pin.Icon.ExtraShadow:SetSize (19, 19)
						pin.Icon.ExtraShadow:SetTexture (1455734)
						pin.Icon.ExtraShadow:SetTexCoord (4/128, 71/128, 36/512, 108/512)
						pin.Icon.ExtraShadow:SetPoint ("center")
					end
				end
				return
			end

			if (not pin._WQT_Twin) then
				pin._WQT_Twin = WorldQuestTracker:GetOrCreateTaxyPOI (pin:GetParent())
				
				pin._WQT_Twin:RegisterForClicks ("LeftButtonUp", "RightButtonUp")
				pin._WQT_Twin:SetFrameStrata (pin:GetFrameStrata())
				pin._WQT_Twin:SetFrameLevel (pin:GetFrameLevel()+100)
				pin._WQT_Twin:SetScale (1.3)
				pin._WQT_Twin:SetScript ("OnClick", onTaxyWidgetClick)
				pin._WQT_Twin.AnchorFrame:SetPoint ("center", pin, "center")
				
				--mixin
				for member, func in pairs (pin) do
					if (type (func) == "function") then
						pin._WQT_Twin.AnchorFrame [member] = func
					end
				end
				
				pin._WQT_Twin:SetScript ("OnEnter", function (self)
					TaskPOI_OnEnter (pin._WQT_Twin)
					pin._WQT_Twin.Texture:SetBlendMode ("ADD")
				end)
				
				pin._WQT_Twin:SetScript ("OnLeave", function()
					TaskPOI_OnLeave (pin._WQT_Twin)
					pin._WQT_Twin.Texture:SetBlendMode ("BLEND")
				end)
				
				tinsert (WorldQuestTracker.TaxyZoneWidgets, pin._WQT_Twin)
			end
			
			local mapID, zoneID = C_TaskQuest.GetQuestZoneID (pin.questID)
			
			pin._WQT_Twin.questID = pin.questID
			pin._WQT_Twin.numObjectives = pin.numObjectives or 1
			pin._WQT_Twin.mapID = mapID
			
			pin._WQT_Twin.AnchorFrame.mapID = mapID
			pin._WQT_Twin.questID = pin.questID
			pin._WQT_Twin.AnchorFrame.numObjectives = pin.numObjectives or 1
			
			local isShowingQuests = WorldQuestTracker.db.profile.taxy_showquests
			local isShowingOnlyTracked = WorldQuestTracker.db.profile.taxy_trackedonly
			local hasZoom = WorldQuestTracker.TaxyFrameHasZoom()
			
			--n�o esta mostrando as quests e o mapa n�o tem zoom
			if (not isShowingQuests) then -- and not hasZoom
				pin._WQT_Twin:Hide()
				WorldQuestTracker.Taxy_CurrentShownBlips [pin._WQT_Twin] = nil
				pin._WQT_Twin.questID = nil
				pin._WQT_Twin.LastUpdate = nil
				return
			end
			
			--esta mostrando apenas quests que est�o sendo trackeadas
			if (isShowingOnlyTracked) then
				if ((not WorldQuestTracker.IsQuestBeingTracked (pin.questID) and not WorldQuestTracker.IsQuestOnObjectiveTracker (pin.questID))) then -- and not hasZoom
					pin._WQT_Twin:Hide()
					WorldQuestTracker.Taxy_CurrentShownBlips [pin._WQT_Twin] = nil
					pin._WQT_Twin.questID = nil
					pin._WQT_Twin.LastUpdate = nil
					return
				end
			end

			pin._WQT_Twin:Show()
			
			WorldQuestTracker.Taxy_CurrentShownBlips [pin._WQT_Twin] = true
			
			--esta linha esta dando problemas de travamento, a dica de ferramenta come�a a dar altos problemas
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount = WorldQuestTracker:GetQuestFullInfo (pin.questID)
			
			--n�o mostrar quests que foram filtradas
			local filter = WorldQuestTracker.GetQuestFilterTypeAndOrder (worldQuestType, gold, rewardName, itemName, isArtifact, quantity, numRewardItems, rewardTexture)
			
			if (not filters [filter] and rarity ~= LE_WORLD_QUEST_QUALITY_EPIC) then
				pin._WQT_Twin:Hide()
				WorldQuestTracker.Taxy_CurrentShownBlips [pin._WQT_Twin] = nil
				pin._WQT_Twin.questID = nil
				pin._WQT_Twin.LastUpdate = nil
				return
			end

			local inProgress, questIDChanged
			
			if (pin._WQT_Twin.questID ~= pin.questID) then
				questIDChanged = true
			end
			pin._WQT_Twin.questID = pin.questID
			pin._WQT_Twin.numObjectives = pin.numObjectives or 1
			local mapID, zoneID = C_TaskQuest.GetQuestZoneID (pin.questID)
			pin._WQT_Twin.mapID = mapID
			
			pin._WQT_Twin.AnchorFrame.questID = pin.questID
			pin._WQT_Twin.AnchorFrame.numObjectives = pin.numObjectives or 1
			
			local nextZoomOutScale, nextZoomInScale = FlightMapFrame.ScrollContainer:GetCurrentZoomRange()
			
			--local nextZoomOutScale, nextZoomInScale = FlightMapFrame.ScrollContainer:GetCurrentZoomRange() --only updates when the map finishes the zoom animation
			--print (nextZoomOutScale, nextZoomInScale, minX, maxX, minY, maxY)
			
			local scale = FlightMapFrame.ScrollContainer:GetCanvasScale()
			local pinScale = DF:MapRangeClamped (.2, .6, 2, 1, scale)
			
			--print ("newScale:", pinScale)
			--print (scale)
			--local minX, maxX, minY, maxY = FlightMapFrame.ScrollContainer:CalculateScrollExtentsAtScale (nextZoomInScale)
			--print (minX, maxX, minY, maxY)
			--/dump FlightMapFrame.ScrollContainer.Child:GetScale()

			--FlightMapFrame:ZoomOut()
			if (scale < 0.3) then
				--n�o tem zoom
				if (isShowingOnlyTracked) then
					if (questIDChanged or pin._WQT_Twin.zoomState or not pin._WQT_Twin.LastUpdate or pin._WQT_Twin.LastUpdate+20 < GetTime()) then
						WorldQuestTracker.SetupWorldQuestButton (pin._WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget)
						format_for_taxy_nozoom_tracked (pin._WQT_Twin, true)
						pin._WQT_Twin.LastUpdate = GetTime()
						pin._WQT_Twin.zoomState = nil
						--print ("UPDATED")
					end
				else
					if (questIDChanged or pin._WQT_Twin.zoomState or not pin._WQT_Twin.LastUpdate or pin._WQT_Twin.LastUpdate+20 < GetTime()) then
						WorldQuestTracker.SetupWorldQuestButton (pin._WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget)
						format_for_taxy_nozoom_all (pin._WQT_Twin)
						pin._WQT_Twin.LastUpdate = GetTime()
						pin._WQT_Twin.zoomState = nil
						--print ("atualizando", GetTime())
					end
				end
			else
				--tem zoom
				if (questIDChanged or not pin._WQT_Twin.zoomState or not pin._WQT_Twin.LastUpdate or pin._WQT_Twin.LastUpdate+20 < GetTime()) then
					WorldQuestTracker.SetupWorldQuestButton (pin._WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget)
					format_for_taxy_zoom_allquests (pin._WQT_Twin)
					pin._WQT_Twin.LastUpdate = GetTime()
					pin._WQT_Twin.zoomState = true
					--pin._WQT_Twin:SetScale (2.2)
					pin._WQT_Twin:SetScale (pinScale);-- print ("using scale", pinScale)
					pin:SetAlpha (0)
					--pin.TimeLowFrame:SetAlpha (0)
					if (pin.Underlay) then
						pin.Underlay:SetAlpha (0)
					end
					--print ("UPDATED")
				end
			end

			if (not WorldQuestTracker.TaxiQueueTimer or WorldQuestTracker.TaxiQueueTimer._cancelled) then
				WorldQuestTracker.TaxiQueueTimer = C_Timer.NewTimer (2, refresh_quest_pin)
				wipe (WorldQuestTracker.QueuedPinsToRefresh)
			end
			tinsert (WorldQuestTracker.QueuedPinsToRefresh, {pin.questID, pin._WQT_Twin, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget})
			
		end)
		
		WorldQuestTracker.FlyMapHook = true
	end
	
	if (WorldQuestTracker.Taxy_CurrentShownBlips) then
		for _WQT_Twin, isShown in pairs (WorldQuestTracker.Taxy_CurrentShownBlips) do
			if (_WQT_Twin:IsShown() and not WorldQuestTracker.IsQuestBeingTracked (_WQT_Twin.questID)) then
				_WQT_Twin:Hide()
				WorldQuestTracker.Taxy_CurrentShownBlips [_WQT_Twin] = nil
				--local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (_WQT_Twin.questID)
				--print ("Taxy Hide", title)
			end
		end
	end
end



function WorldQuestTracker:TAXIMAP_CLOSED()
	for _, widget in ipairs (WorldQuestTracker.TaxyZoneWidgets) do
		widget.LastUpdate = nil
		widget.questID = nil
	end
end




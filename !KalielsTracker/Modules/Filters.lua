--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_Filters")
KT.Filters = M

local L = KT.L

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local ipairs = ipairs
local pairs = pairs
local strfind = string.find

-- WoW API
local _G = _G

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"

local KTF = KT.frame
local OTF = ObjectiveTrackerFrame
local OTFHeader = OTF.HeaderMenu

local continents = KT.GetMapContinents()
local achievCategory = GetCategoryList()
local instanceQuestDifficulty = {
	[DIFFICULTY_DUNGEON_NORMAL] = { Enum.QuestTag.Dungeon },
	[DIFFICULTY_DUNGEON_HEROIC] = { Enum.QuestTag.Dungeon, Enum.QuestTag.Heroic },
	[DIFFICULTY_RAID10_NORMAL] = { Enum.QuestTag.Raid, Enum.QuestTag.Raid10 },
	[DIFFICULTY_RAID25_NORMAL] = { Enum.QuestTag.Raid, Enum.QuestTag.Raid25 },
	[DIFFICULTY_RAID10_HEROIC] = { Enum.QuestTag.Raid, Enum.QuestTag.Raid10 },
	[DIFFICULTY_RAID25_HEROIC] = { Enum.QuestTag.Raid, Enum.QuestTag.Raid25 },
	[DIFFICULTY_RAID_LFR] = { Enum.QuestTag.Raid },
	[DIFFICULTY_DUNGEON_CHALLENGE] = { Enum.QuestTag.Dungeon },
	[DIFFICULTY_RAID40] = { Enum.QuestTag.Raid },
	[DIFFICULTY_PRIMARYRAID_NORMAL] = { Enum.QuestTag.Raid },
	[DIFFICULTY_PRIMARYRAID_HEROIC] = { Enum.QuestTag.Raid },
	[DIFFICULTY_PRIMARYRAID_MYTHIC] = { Enum.QuestTag.Raid },
	[DIFFICULTY_PRIMARYRAID_LFR] = { Enum.QuestTag.Raid },
}

local eventFrame

--------------
-- Internal --
--------------

local function SetHooks()
	local bck_ObjectiveTracker_OnEvent = OTF:GetScript("OnEvent")
	OTF:SetScript("OnEvent", function(self, event, ...)
		if event == "QUEST_ACCEPTED" then
			local _, questID = ...
			if not IsQuestBounty(questID) and not IsQuestTask(questID) and db.filterAuto[1] then
				return
			end
		end
		bck_ObjectiveTracker_OnEvent(self, event, ...)
	end)

	-- Quests
	local bck_QuestObjectiveTracker_UntrackQuest = QuestObjectiveTracker_UntrackQuest
	QuestObjectiveTracker_UntrackQuest = function(dropDownButton, questID)
		if not db.filterAuto[1] then
			bck_QuestObjectiveTracker_UntrackQuest(dropDownButton, questID)
		end
	end
	
	local bck_QuestMapQuestOptions_TrackQuest = QuestMapQuestOptions_TrackQuest
	QuestMapQuestOptions_TrackQuest = function(questID)
		if not db.filterAuto[1] then
			bck_QuestMapQuestOptions_TrackQuest(questID)
		end
	end
	
	-- Achievements
	local bck_AchievementObjectiveTracker_UntrackAchievement = AchievementObjectiveTracker_UntrackAchievement
	AchievementObjectiveTracker_UntrackAchievement = function(dropDownButton, achievementID)
		if not db.filterAuto[2] then
			bck_AchievementObjectiveTracker_UntrackAchievement(dropDownButton, achievementID)
		end
	end
	
	-- Quest Log
	hooksecurefunc("QuestMapFrame_UpdateQuestDetailsButtons", function()
		if db.filterAuto[1] then
			QuestMapFrame.DetailsFrame.TrackButton:Disable()
			QuestLogPopupDetailFrame.TrackButton:Disable()
		else
			QuestMapFrame.DetailsFrame.TrackButton:Enable()
			QuestLogPopupDetailFrame.TrackButton:Enable()
		end
	end)

	-- POI
	local bck_QuestPOIButton_OnClick = QuestPOIButton_OnClick
	QuestPOIButton_OnClick = function(self)
		if not IsQuestWatched(GetQuestLogIndexByID(self.questID)) and db.filterAuto[1] then
			return
		end
		bck_QuestPOIButton_OnClick(self)
	end
end

local function SetHooks_AchievementUI()
	local bck_AchievementButton_ToggleTracking = AchievementButton_ToggleTracking
	AchievementButton_ToggleTracking = function(id)
		if not db.filterAuto[2] then
			return bck_AchievementButton_ToggleTracking(id)
		end
	end
	
	hooksecurefunc("AchievementButton_DisplayAchievement", function(button, category, achievement, selectionID, renderOffScreen)
		if not button.completed then
			if db.filterAuto[2] then
				button.tracked:Disable()
			else
				button.tracked:Enable()
			end
		end
	end)
end

local function GetActiveWorldEvents()
	local events = ""
	local date = C_Calendar.GetDate()
	C_Calendar.SetAbsMonth(date.month, date.year)
	local numEvents = C_Calendar.GetNumDayEvents(0, date.monthDay)
	for i=1, numEvents do
		local title, hour, minute, calendarType, sequenceType = C_Calendar.GetDayEvent(0, date.monthDay, i)
		if calendarType == "HOLIDAY" then
			local gameHour, gameMinute = GetGameTime()
			if sequenceType == "START" then
				if gameHour >= hour and gameMinute >= minute then
					events = events..title.." "
				end
			elseif sequenceType == "END" then
				if gameHour <= hour and gameMinute <= minute then
					events = events..title.." "
				end
			else
				events = events..title.." "
			end
		end
	end
	return events
end

local function IsInstanceQuest(questID)
	local _, _, difficulty, _ = GetInstanceInfo()
	local difficultyTags = instanceQuestDifficulty[difficulty]
	if difficultyTags then
		local tagID, tagName = GetQuestTagInfo(questID)
		for _, tag in ipairs(difficultyTags) do
			_DBG(difficulty.." ... "..tag, true)
			if tag == tagID then
				return true
			end
		end
	end
	return false
end

local function Filter_Quests(self, spec, idx)
	if not spec then return end
	local numEntries, _ = GetNumQuestLogEntries()

	KT.stopUpdate = true
	--KTF.Buttons.reanchor = (KTF.Buttons.num > 0)
	if GetNumQuestWatches() > 0 then
		for i=1, numEntries do
			local _, _, _, isHeader, _, _, _, _, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty then
				RemoveQuestWatch(i)
			end
		end
	end

	if spec == "all" then
		for i=numEntries, 1, -1 do
			local _, _, _, isHeader, _, _, _, _, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty then
				AddQuestWatch(i, true)
			end
		end
	elseif spec == "group" then
		for i=idx, 1, -1 do
			local _, _, _, isHeader, _, _, _, _, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty then
				AddQuestWatch(i, true)
			else
				break
			end
		end
		MSA_CloseDropDownMenus()
	elseif spec == "zone" then
		local mapID = KT.GetCurrentMapAreaID()
		if C_Map.GetMapGroupID(mapID) then
			local mapInfo = C_Map.GetMapInfo(mapID)
			OpenQuestLog(mapInfo.parentMapID)
		else
			KT.SetMapToCurrentZone()
		end
		for i=numEntries, 1, -1 do
			local _, _, _, isHeader, _, _, _, questID, _, _, isOnMap, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty and isOnMap then
				if KT.inInstance then
					if IsInstanceQuest(questID) then
						AddQuestWatch(i, true)
					end
				else
					AddQuestWatch(i, true)
				end
			end
		end
		HideUIPanel(WorldMapFrame)
	elseif spec == "daily" then
		for i=numEntries, 1, -1 do
			local _, _, _, isHeader, _, _, frequency, _, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty and frequency >= 2 then
				AddQuestWatch(i, true)
			end
		end
	elseif spec == "instance" then
		for i=numEntries, 1, -1 do
			local _, _, _, isHeader, _, _, _, questID, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty then
				local tagID, _ = GetQuestTagInfo(questID)
				if tagID == Enum.QuestTag.Dungeon or
					tagID == Enum.QuestTag.Heroic or
					tagID == Enum.QuestTag.Raid or
					tagID == Enum.QuestTag.Raid10 or
					tagID == Enum.QuestTag.Raid25 then
					AddQuestWatch(i, true)
				end
			end
		end
	elseif spec == "complete" then
		for i=numEntries, 1, -1 do
			local _, _, _, isHeader, _, _, _, questID, _, _, _, _, isTask, isBounty = GetQuestLogTitle(i)
			if not isHeader and not isTask and not isBounty and IsQuestComplete(questID) then
				AddQuestWatch(i, true)
			end
		end
	end
	KT.stopUpdate = false

	ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST)
	QuestSuperTracking_ChooseClosestQuest()
end

local function Filter_Achievements(self, spec)
	if not spec then return end
	local trackedAchievements = { GetTrackedAchievements() }

	KT.stopUpdate = true
	if GetNumTrackedAchievements() > 0 then
		for i=1, #trackedAchievements do
			RemoveTrackedAchievement(trackedAchievements[i])
		end
	end
	
	if spec == "zone" then
		local continentName = KT.GetCurrentMapContinent().name
		local zoneName = GetRealZoneText() or ""
		local categoryName = continentName
		if KT.GetCurrentMapContinent().mapID == 619 then
			categoryName = EXPANSION_NAME6	-- Legion
		elseif KT.GetCurrentMapContinent().mapID == 875 then
			categoryName = EXPANSION_NAME7	-- Battle for Azeroth
		end
		local instance = KT.inInstance and 168 or nil
		_DBG(zoneName.." ... "..KT.GetCurrentMapAreaID(), true)

		-- Dungeons & Raids
		if instance and db.filterAchievCat[instance] then
			local _, type, difficulty, difficultyName = GetInstanceInfo()
			local _, _, sufix = strfind(difficultyName, "^.* %((.*)%)$")
			if sufix then
				difficultyName = sufix
			end
			_DBG(type.." ... "..difficulty.." ... "..difficultyName, true)
		end
		
		-- World Events
		local events = ""
		if db.filterAchievCat[155] then
			events = GetActiveWorldEvents()
		end
		
		for i=1, #achievCategory do
			local category = achievCategory[i]
			local name, parentID, _ = GetCategoryInfo(category)

			if db.filterAchievCat[parentID] then
				if (parentID == 92) or	-- Character
					(parentID == 96 and name == categoryName) or	-- Quests
					(parentID == 97 and name == categoryName) or	-- Exploration
					(parentID == 95 and strfind(zoneName, name)) or	-- Player vs. Player
					(category == instance or parentID == instance) or	-- Dungeons & Raids
					(parentID == 169) or	-- Professions
					(parentID == 201) or	-- Reputation
					(parentID == 155 and strfind(events, name)) or	-- World Events
					(category == 15117 or parentID == 15117) or	-- Pet Battles
					(category == 15246 or parentID == 15246) or	-- Collections
					(parentID == 15301) then	-- Expansion Features
					local aNumItems, _ = GetCategoryNumAchievements(category)
					for i=1, aNumItems do
						local track = false
						local aId, aName, _, aCompleted, _, _, _, aDescription = GetAchievementInfo(category, i)
						if aId and not aCompleted then
							--_DBG(aId.." ... "..aName, true)
							if parentID == 95 or category == 15237 or parentID == 15237 or
								(not instance and (category == 15117 or parentID == 15117) and strfind(aName.." - "..aDescription, continentName)) then
								track = true
							elseif strfind(aName.." - "..aDescription, zoneName) then
								if category == instance or parentID == instance then
									if strfind(strlower(aName.." - "..aDescription), strlower(difficultyName)) or
										strfind(aName.." - "..aDescription, "difficulty or higher") then	-- TODO: other languages
										track = true
									end
								else
									track = true
								end
							elseif strfind(aDescription, " capita") then	-- capital city (TODO: de, ru strings)
								local cNumItems = GetAchievementNumCriteria(aId)
								for i=1, cNumItems do
									local cDescription, _, cCompleted = GetAchievementCriteriaInfo(aId, i)
									if not cCompleted and strfind(cDescription, zoneName) then
										track = true
										break
									end
								end
							end
							if track then
								AddTrackedAchievement(aId)
							end
						end
						if GetNumTrackedAchievements() == MAX_TRACKED_ACHIEVEMENTS then
							break
						end
					end
				end
			end
			if GetNumTrackedAchievements() == MAX_TRACKED_ACHIEVEMENTS then
				break
			end
			if parentID == -1 then
				--_DBG(category.." ... "..name, true)
			end
		end
	elseif spec == "wevent" then
		local events = GetActiveWorldEvents()
		local eventName = ""
		
		for i=1, #achievCategory do
			local category = achievCategory[i]
			local name, parentID, _ = GetCategoryInfo(category)
			
			if parentID == 155 and strfind(events, name) then	-- World Events
				eventName = eventName..(eventName ~= "" and ", " or "")..name
				local aNumItems, _ = GetCategoryNumAchievements(category)
				for i=1, aNumItems do
					local aId, aName, _, aCompleted, _, _, _, aDescription = GetAchievementInfo(category, i)
					if aId and not aCompleted then					
						AddTrackedAchievement(aId)
					end
					if GetNumTrackedAchievements() == MAX_TRACKED_ACHIEVEMENTS then
						break
					end
				end
			end
			if GetNumTrackedAchievements() == MAX_TRACKED_ACHIEVEMENTS then
				break
			end
			if parentID == -1 then
				--_DBG(category.." ... "..name, true)
			end
		end

		if db.messageAchievement then
			local numTracked = GetNumTrackedAchievements()
			if numTracked == 0 then
				KT:SetMessage(L"There is currently no World Event.", 1, 1, 0)
			elseif numTracked > 0 then
				KT:SetMessage(L"World Event - "..eventName, 1, 1, 0)
			end
		end
	end
	KT.stopUpdate = false
	
	if AchievementFrame then
		AchievementFrameAchievements_ForceUpdate()
	end
	ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_ACHIEVEMENT)
end

local DropDown_Initialize	-- function

local function DropDown_Toggle(level, button)
	local dropDown = KT.DropDown
	if dropDown.activeFrame ~= KTF.FilterButton then
		MSA_CloseDropDownMenus()
	end
	dropDown.activeFrame = KTF.FilterButton
	dropDown.initialize = DropDown_Initialize
	MSA_ToggleDropDownMenu(level or 1, button and MSA_DROPDOWNMENU_MENU_VALUE or nil, dropDown, KTF.FilterButton, -15, -1, nil, button or nil, MSA_DROPDOWNMENU_SHOW_TIME)
	if button then
		_G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL].showTimer = nil
	end
end

local function Filter_AutoTrack(self, id, spec)
	db.filterAuto[id] = (db.filterAuto[id] ~= spec) and spec or nil
	if db.filterAuto[id] then
		if id == 1 then
			Filter_Quests(self, spec)
		elseif id == 2 then
			Filter_Achievements(self, spec)
		end
		KTF.FilterButton:GetNormalTexture():SetVertexColor(0, 1, 0)
	else
		if id == 1 then
			QuestMapFrame_UpdateQuestDetailsButtons()
		elseif id == 2 and AchievementFrame then
			AchievementFrameAchievements_ForceUpdate()
		end
		if not (db.filterAuto[1] or db.filterAuto[2]) then
			KTF.FilterButton:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
		end
	end
	DropDown_Toggle()
end

local function Filter_AchievCat_CheckAll(self, state)
	for id, _ in pairs(db.filterAchievCat) do
		db.filterAchievCat[id] = state
	end
	if db.filterAuto[2] then
		Filter_Achievements(_, db.filterAuto[2])
		MSA_CloseDropDownMenus()
	else
		local listFrame = _G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL]
		DropDown_Toggle(MSA_DROPDOWNMENU_MENU_LEVEL, _G["MSA_DropDownList"..listFrame.parentLevel.."Button"..listFrame.parentID])
	end
end

function DropDown_Initialize(self, level)
	local numEntries, numQuests = GetNumQuestLogEntries()
	local info = MSA_DropDownMenu_CreateInfo()
	info.isNotRadio = true

	if level == 1 then
		info.notCheckable = true

		-- Quests
		info.text = TRACKER_HEADER_QUESTS
		info.isTitle = true
		MSA_DropDownMenu_AddButton(info)

		info.isTitle = false
		info.disabled = (db.filterAuto[1])
		info.func = Filter_Quests

		info.text = L"All".." ("..numQuests..")"
		info.hasArrow = not (db.filterAuto[1])
		info.value = 1
		info.arg1 = "all"
		MSA_DropDownMenu_AddButton(info)

		info.hasArrow = false

		info.text = L"Zone"
		info.arg1 = "zone"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"Daily"
		info.arg1 = "daily"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"Instance"
		info.arg1 = "instance"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"Complete"
		info.arg1 = "complete"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"Untrack All"
		info.disabled = (db.filterAuto[1] or GetNumQuestWatches() == 0)
		info.arg1 = ""
		MSA_DropDownMenu_AddButton(info)

		info.text = L"|cff00ff00Auto|r Zone"
		info.notCheckable = false
		info.disabled = false
		info.arg1 = 1
		info.arg2 = "zone"
		info.checked = (db.filterAuto[info.arg1] == info.arg2)
		info.func = Filter_AutoTrack
		MSA_DropDownMenu_AddButton(info)

		MSA_DropDownMenu_AddSeparator(info)

		-- Achievements
		info.text = TRACKER_HEADER_ACHIEVEMENTS
		info.isTitle = true
		MSA_DropDownMenu_AddButton(info)

		info.isTitle = false
		info.disabled = false

		info.text = L"Categories"
		info.keepShownOnClick = true
		info.hasArrow = true
		info.value = 2
		info.func = nil
		MSA_DropDownMenu_AddButton(info)

		info.keepShownOnClick = false
		info.hasArrow = false
		info.disabled = (db.filterAuto[2])
		info.func = Filter_Achievements

		info.text = L"Zone"
		info.arg1 = "zone"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"World Event"
		info.arg1 = "wEvent"
		MSA_DropDownMenu_AddButton(info)

		info.text = L"Untrack All"
		info.disabled = (db.filterAuto[2] or GetNumTrackedAchievements() == 0)
		info.arg1 = ""
		MSA_DropDownMenu_AddButton(info)

		info.text = L"|cff00ff00Auto|r Zone"
		info.notCheckable = false
		info.disabled = false
		info.arg1 = 2
		info.arg2 = "zone"
		info.checked = (db.filterAuto[info.arg1] == info.arg2)
		info.func = Filter_AutoTrack
		MSA_DropDownMenu_AddButton(info)

		-- Addon - PetTracker
		if KT.AddonPetTracker.isLoaded then
			MSA_DropDownMenu_AddSeparator(info)

			info.text = PETS
			info.isTitle = true
			MSA_DropDownMenu_AddButton(info)

			info.isTitle = false
			info.disabled = false
			info.notCheckable = false

			info.text = PetTracker.Locals.TrackPets
			info.checked = (not PetTracker.Sets.HideTracker)
			info.func = function()
				PetTracker.Tracker.Toggle()
				if dbChar.collapsed and not PetTracker.Sets.HideTracker then
					ObjectiveTracker_MinimizeButton_OnClick()
				end
			end
			MSA_DropDownMenu_AddButton(info)

			info.text = PetTracker.Locals.CapturedPets
			info.checked = (PetTracker.Sets.CapturedPets)
			info.func = function()
				PetTracker.Sets.CapturedPets = not PetTracker.Sets.CapturedPets
				PetTracker:ForAllModules("TrackingChanged")
			end
			MSA_DropDownMenu_AddButton(info)
		end
	elseif level == 2 then
		info.notCheckable = true

		if MSA_DROPDOWNMENU_MENU_VALUE == 1 then
			info.arg1 = "group"
			info.func = Filter_Quests

			if numEntries > 0 then
				local headerTitle, headerOnMap, headerShown
				for i=1, numEntries do
					local title, _, _, isHeader, _, _, _, questID, _, _, isOnMap, _, isTask, isBounty, _, isHidden = GetQuestLogTitle(i)
					if isHeader then
						if headerShown and i > 1 then
							info.arg2 = i - 1
							MSA_DropDownMenu_AddButton(info, level)
						end
						headerTitle = title
						headerOnMap = isOnMap
						headerShown = false
					elseif not isTask and not isBounty and not isHidden then
						if not headerShown then
							if C_CampaignInfo.IsCampaignQuest(questID) then
								local warCampaignID = C_CampaignInfo.GetCurrentCampaignID()
								if warCampaignID then
									local warCampaignInfo = C_CampaignInfo.GetCampaignInfo(warCampaignID)
									headerTitle = warCampaignInfo.name
								end
							end
							info.text = (headerOnMap and "|cff00ff00" or "")..headerTitle
							headerShown = true
						end
					end
				end
				if headerShown then
					info.arg2 = numEntries
					MSA_DropDownMenu_AddButton(info, level)
				end
			end
		elseif MSA_DROPDOWNMENU_MENU_VALUE == 2 then
			info.func = Filter_AchievCat_CheckAll

			info.text = L"Check All"
			info.arg1 = true
			MSA_DropDownMenu_AddButton(info, level)

			info.text = L"Uncheck All"
			info.arg1 = false
			MSA_DropDownMenu_AddButton(info, level)

			info.keepShownOnClick = true
			info.notCheckable = false

			for i=1, #achievCategory do
				local id = achievCategory[i]
				local name, parentID, _ = GetCategoryInfo(id)
				if parentID == -1 and id ~= 15234 and id ~= 81 then		-- Skip "Legacy" and "Feats of Strength"
					info.text = name
					info.checked = (db.filterAchievCat[id])
					info.arg1 = id
					info.func = function(_, arg)
						db.filterAchievCat[arg] = not db.filterAchievCat[arg]
						if db.filterAuto[2] then
							Filter_Achievements(_, db.filterAuto[2])
							MSA_CloseDropDownMenus()
						end
					end
					MSA_DropDownMenu_AddButton(info, level)
				end
			end
		end
	end
end

local function SetFrames()
	-- Event frame
	if not eventFrame then
		eventFrame = CreateFrame("Frame")
		eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
			_DBG("Event - "..event.." - "..(arg1 or ""), true)
			if event == "ADDON_LOADED" and arg1 == "Blizzard_AchievementUI" then
				SetHooks_AchievementUI()
				self:UnregisterEvent(event)
			elseif event == "QUEST_ACCEPTED" then
				local questID = ...
				if not IsQuestBounty(questID) and not IsQuestTask(questID) and db.filterAuto[1] then
					self:RegisterEvent("QUEST_POI_UPDATE")
				end
			elseif event == "QUEST_POI_UPDATE" then
				KT.questStateStopUpdate = true
				Filter_Quests(_, "zone")
				KT.questStateStopUpdate = false
				self:UnregisterEvent(event)
			elseif event == "ZONE_CHANGED_NEW_AREA" then
				if db.filterAuto[1] == "zone" then
					Filter_Quests(_, "zone")
				end
				if db.filterAuto[2] == "zone" then
					Filter_Achievements(_, "zone")
				end
			end
		end)
	end
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("QUEST_ACCEPTED")
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	-- Filter button
	local button = CreateFrame("Button", addonName.."FilterButton", KTF)
	button:SetSize(16, 16)
	button:SetPoint("TOPRIGHT", KTF.MinimizeButton, "TOPLEFT", -4, 0)
	button:SetFrameLevel(KTF:GetFrameLevel() + 10)
	button:SetNormalTexture(mediaPath.."UI-KT-HeaderButtons")
	button:GetNormalTexture():SetTexCoord(0.5, 1, 0.5, 0.75)
	
	button:RegisterForClicks("AnyDown")
	button:SetScript("OnClick", function(self, btn)
		DropDown_Toggle()
	end)
	button:SetScript("OnEnter", function(self)
		self:GetNormalTexture():SetVertexColor(1, 1, 1)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L"Filter", 1, 1, 1)
		GameTooltip:AddLine(db.filterAuto[1] and L[db.filterAuto[1]]..L" Quests", 0, 1, 0)
		GameTooltip:AddLine(db.filterAuto[2] and L[db.filterAuto[2]]..L" Achievements", 0, 1, 0)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function(self)
		if db.filterAuto[1] or db.filterAuto[2] then
			self:GetNormalTexture():SetVertexColor(0, 1, 0)
		else
			self:GetNormalTexture():SetVertexColor(KT.hdrBtnColor.r, KT.hdrBtnColor.g, KT.hdrBtnColor.b)
		end
		GameTooltip:Hide()
	end)
	KTF.FilterButton = button

	OTFHeader.Title:SetWidth(OTFHeader.Title:GetWidth() - 20)

	-- Move other buttons
	if KTF.AchievementsButton and db.hdrOtherButtons then
		local point, _, relativePoint, xOfs, yOfs = KTF.AchievementsButton:GetPoint()
		KTF.AchievementsButton:SetPoint(point, KTF.FilterButton, relativePoint, xOfs, yOfs)
	end
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	dbChar = KT.db.char

    local defaults = KT:MergeTables({
        profile = {
            filterAuto = {
				nil,	-- [1] Quests
				nil,	-- [2] Achievements
			},
			filterAchievCat = {
				[92] = true,	-- Character
				[96] = true,	-- Quests
				[97] = true,	-- Exploration
				[95] = true,	-- Player vs. Player
				[168] = true,	-- Dungeons & Raids
				[169] = true,	-- Professions
				[201] = true,	-- Reputation
				[155] = true,	-- World Events
				[15117] = true,	-- Pet Battles
				[15246] = true,	-- Collections
				[15301] = true,	-- Expansion Features
			},
			filterWQTimeLeft = nil,
        }
    }, KT.db.defaults)
	KT.db:RegisterDefaults(defaults)
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetHooks()
	SetFrames()
end

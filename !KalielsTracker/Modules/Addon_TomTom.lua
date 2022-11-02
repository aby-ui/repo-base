--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_AddonTomTom")
KT.AddonTomTom = M

local ACD = LibStub("MSA-AceConfigDialog-3.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local questWaypoints = {}
local superTrackedQuestID = 0

local eventFrame

--------------
-- Internal --
--------------

local function SetupOptions()
	KT.options.args.tomtom = {
		name = "TomTom",
		type = "group",
		args = {
			tomtomDesc1 = {
				name = "TomTom support combined Blizzard's POI and TomTom's Arrow.\n\n"..
						"|cffff7f00Warning:|r Original \"TomTom > Quest Objectives\" options are ignored!\n\n\n"..
						"|TInterface\\WorldMap\\UI-QuestPoi-NumberIcons:32:32:-2:10:256:256:128:160:96:128|t+"..
						"|T"..mediaPath.."KT-TomTomTag:32:32:-8:10|t...   Active POI button of quest with TomTom Waypoint.",
				type = "description",
				order = 1,
			},
			tomtomArrival = {
				name = "Arrival distance",
				type = "range",
				min = 0,
				max = 150,
				step = 5,
				set = function(_, value)
					db.tomtomArrival = value
				end,
				order = 2,
			},
			tomtomAnnounce = {
				name = "Waypoint announcement",
				desc = "Show announcement when add/remove quest waypoint, inside the chat frame. When disable this option, you always see messages \"No data for quest waypoint\".",
				type = "toggle",
				width = 1.1,
				set = function()
					db.tomtomAnnounce = not db.tomtomAnnounce
				end,
				order = 3,
			},
		},
	}
	
	KT.optionsFrame.tomtom = ACD:AddToBlizOptions(addonName, "Addon - "..KT.options.args.tomtom.name, KT.title, "tomtom")

	-- Reverts the option to display Quest Objectives
	if not GetCVarBool("questPOI") then
		SetCVar("questPOI", 1)
	end
end

local function Announce(msg, force)
	if db.tomtomAnnounce or force then
		ChatFrame1:AddMessage("|cff33ff99"..KT.title..":|r "..msg)
	end
end

local function WorldQuestPOIGetIconInfo(mapAreaID, questID)
	local x, y
	local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID)
	if taskInfo then
		for _, info  in ipairs(taskInfo) do
			if HaveQuestData(info.questId) then
				if info.questId == questID then
					x = info.x
					y = info.y
					break
				end
			end
		end
	end
	return x, y
end

local function SetWaypointTag(button, show)
	if show then
		if button.KTtomtom then
			button.KTtomtom:Show()
		else
			button.KTtomtom = button:CreateTexture(nil, "OVERLAY", nil, 3)
			button.KTtomtom:SetTexture(mediaPath.."KT-TomTomTag")
			button.KTtomtom:SetSize(32, 32)
			button.KTtomtom:SetPoint("CENTER")
		end
	else
		if button.KTtomtom then
			button.KTtomtom:Hide()
		end
	end
end

local function AddWaypoint(questID, isSilent)
	if C_QuestLog.IsQuestCalling(questID) then
		return false
	end

	local title, mapID
	local x, y, completed
	if QuestUtils_IsQuestWorldQuest(questID) then
		title = C_TaskQuest.GetQuestInfoByQuestID(questID)
		mapID = C_TaskQuest.GetQuestZoneID(questID)
		if mapID and KT.GetCurrentMapContinent().mapID == KT.GetMapContinent(mapID).mapID then
			x, y = WorldQuestPOIGetIconInfo(mapID, questID)
		end
	else
		title = C_QuestLog.GetTitleForQuestID(questID)
		mapID = GetQuestUiMapID(questID)
		if mapID ~= 0 and KT.GetCurrentMapContinent().mapID == KT.GetMapContinent(mapID).mapID then
			completed, x, y = QuestPOIGetIconInfo(questID)
		end
	end

	if not title then
		return false
	end

	if completed then
		title = "|TInterface\\GossipFrame\\ActiveQuestIcon:0:0:0:0|t"..title
	else
		title = "|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:0:0|t"..title
	end

	if mapID == 0 or not x or not y then
		if not isSilent then
			Announce("|cffff0000No data for quest waypoint|r ..."..title, true)
		end
		return false
	end
	
	local uid = TomTom:AddWaypoint(mapID, x, y, {
		title = title,
		silent = true,
		world = false,
		minimap = false,
		persistent = false,
		arrivaldistance = db.tomtomArrival,
	})
	uid["questID"] = questID
	questWaypoints[questID] = uid

	if not isSilent then
		Announce("Added a quest waypoint ..."..title)
	end

	return true
end

local function RemoveWaypoint(questID)
	local uid = questWaypoints[questID]
	if uid then
		TomTom:RemoveWaypoint(uid)
	end
end

local function ReAddWaipoint(questID, isSilent)
	RemoveWaypoint(questID)
	if AddWaypoint(questID, isSilent) then
		superTrackedQuestID = questID
	end
end

local function SetHooks()
	-- TomTom
	local bck_TomTom_EnableDisablePOIIntegration = TomTom.EnableDisablePOIIntegration
	function TomTom:EnableDisablePOIIntegration()
		TomTom.profile.poi.enable = false
		TomTom.profile.poi.modifier = "A"
		TomTom.profile.poi.setClosest = false
		TomTom.profile.poi.arrival = 0
		bck_TomTom_EnableDisablePOIIntegration(self)
	end
	
	hooksecurefunc(TomTom, "ClearWaypoint", function(self, uid)
		local questID = uid.questID
		if questWaypoints[questID] then
			questWaypoints[questID] = nil
			if not KT.stopUpdate then
				superTrackedQuestID = 0
			end
			ObjectiveTracker_Update()
			QuestMapFrame_UpdateAll()
		end
	end)
	
	-- Blizzard
	hooksecurefunc(C_SuperTrack, "SetSuperTrackedQuestID", function(questID)
		local isSilent = (questID == superTrackedQuestID)
		RemoveWaypoint(superTrackedQuestID)
		if QuestUtils_IsQuestWatched(questID) or KT.activeTasks[questID] then
			if AddWaypoint(questID, isSilent) then
				superTrackedQuestID = questID
			end
		end
	end)

	hooksecurefunc(C_QuestLog, "RemoveQuestWatch", function(questID)
		if not KT.stopUpdate then
			RemoveWaypoint(questID)
		end
	end)

	hooksecurefunc(C_QuestLog, "AbandonQuest", function()
		local questID = QuestMapFrame.DetailsFrame.questID or QuestLogPopupDetailFrame.questID or QuestMapFrame.questID
		RemoveWaypoint(questID)
	end)

	hooksecurefunc("BonusObjectiveTracker_OnTaskCompleted", function(questID, xp, money)
		RemoveWaypoint(questID)
	end)

	local bck_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock = WORLD_QUEST_TRACKER_MODULE.OnFreeBlock
	function WORLD_QUEST_TRACKER_MODULE:OnFreeBlock(block)
		SetWaypointTag(block.TrackedQuest)	-- hide tag for hard watched WQ
		bck_WORLD_QUEST_TRACKER_MODULE_OnFreeBlock(self, block)
	end

	-- TODO: 9.x.x - need update (removed)
	local bck_GetQuestWatchInfo = GetQuestWatchInfo
	GetQuestWatchInfo = function(idx)
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isBounty, isStory, isOnMap, hasLocalPOI, isHidden, isWarCampaign = bck_GetQuestWatchInfo(idx)
		if not hasLocalPOI then
			hasLocalPOI = (questWaypoints[questID])
		end
		return questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isBounty, isStory, isOnMap, hasLocalPOI, isHidden, isWarCampaign
	end

	local bck_QuestPOI_GetButton = QuestPOI_GetButton
	QuestPOI_GetButton = function(parent, questID, style, index)
		local poiButton = bck_QuestPOI_GetButton(parent, questID, style, index)
		if poiButton then
			SetWaypointTag(poiButton, questWaypoints[questID])
		end
		return poiButton
	end

	hooksecurefunc(QuestUtil, "SetupWorldQuestButton", function(button, worldQuestType, rarity, isElite, tradeskillLineIndex, inProgress, selected, isCriteria, isSpellTarget, isEffectivelyTracked)
		SetWaypointTag(button, questWaypoints[button.questID])
	end)

	hooksecurefunc("QuestPOIButton_OnClick", function(self)
		QuestMapFrame_UpdateAll()
	end)

	hooksecurefunc("KT_WorldQuestPOIButton_OnClick", function(self)
		ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_WORLD_QUEST)
	end)

	hooksecurefunc("QuestMapQuestOptions_TrackQuest", function(questID)
		QuestMapFrame_UpdateAll()
	end)
end

local function SetFrames()
	-- Event frame
	if not eventFrame then
		eventFrame = CreateFrame("Frame")
		eventFrame:SetScript("OnEvent", function(self, event, ...)
			_DBG("Event - "..event, true)
			if event == "QUEST_WATCH_UPDATE" then
				local questID = ...
				if questID == superTrackedQuestID then
					self:RegisterEvent("QUEST_LOG_UPDATE")
				end
			elseif event == "QUEST_LOG_UPDATE" then
				ReAddWaipoint(superTrackedQuestID, true)
				self:UnregisterEvent(event)
			end
		end)
	end
	eventFrame:RegisterEvent("QUEST_WATCH_UPDATE")
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	self.isLoaded = (KT:CheckAddOn("TomTom", "v3.3.2-release") and db.addonTomTom)

	if self.isLoaded then
		KT:Alert_IncompatibleAddon("TomTom", "v3.3.0-release")
	end

	local defaults = KT:MergeTables({
		profile = {
			tomtomArrival = 20,
			tomtomAnnounce = true,
		}
	}, KT.db.defaults)
	KT.db:RegisterDefaults(defaults)
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetupOptions()
	SetFrames()
	SetHooks()
end

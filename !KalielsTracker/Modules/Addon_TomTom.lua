--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
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
local modifiers = {
	["ALT"] = "Alt",
	["CTRL"] = "Ctrl",
	["ALT-CTRL"] = "Alt+Ctrl",
	["ALT-SHIFT"] = "Alt+Shift",
	["CTRL-SHIFT"] = "Ctrl+Shift",
	["ALT-CTRL-SHIFT"] = "Alt+Ctrl+Shift"
}

--------------
-- Internal --
--------------

local function SetupOptions()
	KT.options.args.tomtom = {
		name = "TomTom",
		type = "group",
		args = {
			tomtomDesc = {
				name = "TomTom support combined Blizzard's POI and TomTom's Arrow.\n\n"..
					"|cffff7f00Warning:|r Original \"TomTom > Quest Objectives\" options are ignored!\n",
				type = "description",
				order = 1,
			},
			tomtomModifier = {
				name = "Waypoint modifier",
				type = "select",
				values = modifiers,
				get = function()
					for k, v in pairs(modifiers) do
						if db.tomtomModifier == k then
							return k
						end
					end
				end,
				set = function(_, value)
					db.tomtomModifier = value
				end,
				order = 2,
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
				order = 3,
			},
			tomtomAnnounce = {
				name = "Waypoint announcement",
				desc = "Show announcement when add/remove quest waypoint, inside the chat frame. When disable this option, you always see messages \"No data for quest waypoint\".",
				type = "toggle",
				set = function()
					db.tomtomAnnounce = not db.tomtomAnnounce
				end,
				order = 4,
			},
			tomtomHelp = {
				name = "\n |TInterface\\WorldMap\\UI-QuestPoi-NumberIcons:28:28:-2:7:256:256:224:256:224:256|t"..
						" |TInterface\\WorldMap\\UI-QuestPoi-NumberIcons:28:28:-2:7:256:256:128:160:96:128|t"..
						"...  Default Blizzard POI button\n"..
						" |T"..mediaPath.."UI-QuestPoi-NumberIcons:28:28:-2:7:256:256:224:256:224:256|t"..
						" |T"..mediaPath.."UI-QuestPoi-NumberIcons:28:28:-2:7:256:256:128:160:96:128|t"..
						"...  POI button of quest with TomTom Waypoint",
				type = "description",
				fontSize = "medium",
				order = 5,
			},
		},
	}
	
	KT.optionsFrame.tomtom = ACD:AddToBlizOptions(addonName, "Addon - "..KT.options.args.tomtom.name, KT.title, "tomtom")
end

local function Announce(msg, force)
	if db.tomtomAnnounce or force then
		ChatFrame1:AddMessage("|cff33ff99TomTom:|r "..msg)
	end
end

local function AddWaypoint(questID)
	local title = GetQuestLogTitle(GetQuestLogIndexByID(questID))
	local mapID, floorNumber = GetQuestWorldMapAreaID(questID)
	if mapID ~= 0 then
		if IsMapGarrisonMap(mapID) then
			KT.SetMapByID(mapID)	-- fix
			local parentData = GetMapHierarchy()
			if parentData then
				mapID = parentData[1].id
			end
		end
		
		KT.SetMapByID(mapID)
		if floorNumber ~= 0 then
			SetDungeonMapLevel(floorNumber)
		end
	else
		Announce("|cffff0000No data for quest waypoint|r - "..title, true)
		return
	end
	
	local completed, x, y, _ = QuestPOIGetIconInfo(questID)
	if not x or not y then
		Announce("|cffff0000No data for quest waypoint|r - "..title, true)
		return
	end
	
	if completed then
		title = "|TInterface\\GossipFrame\\ActiveQuestIcon:0:0:-2:0|t"..title
	else
		title = "|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:-2:0|t"..title
	end
	
	local uid = TomTom:AddMFWaypoint(mapID, floorNumber, x, y, {
		title = title,
		silent = true,
		world = false,
		persistent = false,
		arrivaldistance = db.tomtomArrival,
	})
	uid["questID"] = questID
	questWaypoints[questID] = uid

	KT:MoveButtons()	-- For addon PetTracker
	KT.SetMapToCurrentZone()	-- fire WORLD_MAP_UPDATE event
	Announce("Added a quest waypoint - "..title)
end

local function RemoveWaypoint(questID)
	local uid = questWaypoints[questID]
	if uid then
		TomTom:RemoveWaypoint(uid)
	end
end

local function SetHooks()
	-- TomTom
	function TomTom:EnableDisablePOIIntegration()
		TomTom.profile.poi.enable = false
		TomTom.profile.poi.modifier = "A"
		TomTom.profile.poi.setClosest = false
		TomTom.profile.poi.arrival = 0
	end
	
	hooksecurefunc(TomTom, "ClearWaypoint", function(self, uid)
		if questWaypoints[uid.questID] then
			questWaypoints[uid.questID] = nil
			QuestMapFrame_UpdateAll()
			Announce("Removed a quest waypoint - "..uid.title)
		end
	end)
	
	-- Blizzard	
	hooksecurefunc("QuestObjectiveTracker_OnOpenDropDown", function(self)
		local block = self.activeFrame
		local info = MSA_DropDownMenu_CreateInfo()
		local text = "|cff33ff99TomTom|r - %s Waypoint"
		
		info.notCheckable = true
		info.noClickSound = true
		
		if questWaypoints[block.id] then
			info.text = text:format("Remove")
			info.func = function(_, arg)
				RemoveWaypoint(arg)
			end
		else
			info.text = text:format("Add")
			info.func = function(_, arg)
				SetSuperTrackedQuestID(arg)
			end
		end
		info.arg1 = block.id
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL)
	end)
	
	local bck_QUEST_TRACKER_MODULE_OnBlockHeaderClick = QUEST_TRACKER_MODULE.OnBlockHeaderClick
	function QUEST_TRACKER_MODULE:OnBlockHeaderClick(block, mouseButton)
		if mouseButton ~= "RightButton" and IsModifiedClick(db.tomtomModifier) then
			MSA_CloseDropDownMenus()
			if questWaypoints[block.id] then
				RemoveWaypoint(block.id)
			else
				SetSuperTrackedQuestID(block.id)
			end
			return
		end
		bck_QUEST_TRACKER_MODULE_OnBlockHeaderClick(self, block, mouseButton)
	end
	
	hooksecurefunc("SetSuperTrackedQuestID", function(questID)
		if IsQuestWatched(GetQuestLogIndexByID(questID)) then
			local uid = questWaypoints[questID]
			if uid and TomTom:IsValidWaypoint(uid) then
				TomTom:SetCrazyArrow(uid, db.tomtomArrival, uid.title)
			else
				AddWaypoint(questID)
			end
		end
	end)
	
	hooksecurefunc("RemoveQuestWatch", function(questLogIndex)
		local questID = select(8, GetQuestLogTitle(questLogIndex))
		RemoveWaypoint(questID)
	end)
	
	hooksecurefunc("AbandonQuest", function()
		RemoveWaypoint(KT.selectedQuest)
	end)
	
	local bck_GetQuestWatchInfo = GetQuestWatchInfo
	GetQuestWatchInfo = function(idx)
		local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isBounty, isStory, isOnMap, hasLocalPOI, isHidden = bck_GetQuestWatchInfo(idx)
		if not hasLocalPOI then
			hasLocalPOI = (questWaypoints[questID])
		end
		return questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isBounty, isStory, isOnMap, hasLocalPOI, isHidden
	end
	
	local bck_QuestPOI_GetButton = QuestPOI_GetButton
	QuestPOI_GetButton = function(parent, questID, style, index)
		local poiButton = bck_QuestPOI_GetButton(parent, questID, style, index)
		local tex = (questWaypoints[questID] and mediaPath or "Interface\\WorldMap\\").."UI-QuestPoi-NumberIcons"
		poiButton:SetNormalTexture(tex)
		poiButton:SetPushedTexture(tex)
		return poiButton
	end
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	self.isLoaded = (KT:CheckAddOn("TomTom", "v70300-1.0.0") and db.addonTomTom)

	local defaults = KT:MergeTables({
		profile = {
			tomtomModifier = "ALT",
			tomtomArrival = 0,
			tomtomAnnounce = true,
		}
	}, KT.db.defaults)
	KT.db:RegisterDefaults(defaults)
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetupOptions()
	SetHooks()
end

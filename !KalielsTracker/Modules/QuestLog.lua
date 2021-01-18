--- Kaliel's Tracker
--- Copyright (c) 2012-2021, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_QuestLog")
KT.QuestLog = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db

local dropDownFrame

--------------
-- Internal --
--------------

local function SetHooks()
	-- DropDown
	function QuestMapQuestOptionsDropDown_Initialize(self)	-- R
		local info = MSA_DropDownMenu_CreateInfo();
		info.isNotRadio = true;
		info.notCheckable = true;

		info.text = TRACK_QUEST;
		if ( QuestUtils_IsQuestWatched(self.questID) ) then
			info.text = UNTRACK_QUEST;
		end
		info.disabled = (db.filterAuto[1])
		info.func =function(_, questID) QuestMapQuestOptions_TrackQuest(questID) end;
		info.arg1 = self.questID;
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWNMENU_MENU_LEVEL);

		info.disabled = false;

		info.text = SHARE_QUEST;
		info.func = function(_, questID) QuestMapQuestOptions_ShareQuest(questID) end;
		info.arg1 = self.questID;
		if ( not C_QuestLog.IsPushableQuest(self.questID) or not IsInGroup() ) then
			info.disabled = 1;
		end
		MSA_DropDownMenu_AddButton(info, MSA_DROPDOWNMENU_MENU_LEVEL);

		info.disabled = false;

		if C_QuestLog.CanAbandonQuest(self.questID) then
			info.text = ABANDON_QUEST;
			info.func = function(_, questID) QuestMapQuestOptions_AbandonQuest(questID) end;
			info.arg1 = self.questID;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWNMENU_MENU_LEVEL);
		end

		if db.menuWowheadURL then
			info.text = "|cff33ff99Wowhead|r URL";
			info.func = KT.Alert_WowheadURL;
			info.arg1 = "quest";
			info.arg2 = self.questID;
			MSA_DropDownMenu_AddButton(info, MSA_DROPDOWN_MENU_LEVEL);
		end
	end

	function QuestMapLogTitleButton_OnClick(self, button)	-- R
		if ( ChatEdit_TryInsertQuestLinkForQuestID(self.questID) ) then
			return;
		end

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

		local isDisabledQuest = C_QuestLog.IsQuestDisabledForSession(self.questID);
		if not isDisabledQuest and IsShiftKeyDown() then
			QuestMapQuestOptions_TrackQuest(self.questID);
		else
			if not isDisabledQuest and button == "RightButton" then
				if ( self.questID ~= dropDownFrame.questID ) then
					MSA_CloseDropDownMenus();
				end
				dropDownFrame.questID = self.questID;
				QuestMapFrame.questID = self.questID;	-- for Abandon
				MSA_ToggleDropDownMenu(1, nil, dropDownFrame, "cursor", 6, -6, nil, nil, MSA_DROPDOWNMENU_SHOW_TIME);
			elseif button == "LeftButton" then
				if IsModifiedClick(db.menuWowheadURLModifier) then
					KT:Alert_WowheadURL("quest", self.questID)
				else
					QuestMapFrame_ShowQuestDetails(self.questID);
				end
			end
		end
	end
end

local function SetFrames()
	-- DropDown frame
	dropDownFrame = MSA_DropDownMenu_Create(addonName.."QuestLogDropDown", QuestMapFrame)
	dropDownFrame.questID = 0	-- for QuestMapQuestOptionsDropDown_Initialize
	MSA_DropDownMenu_Initialize(dropDownFrame, QuestMapQuestOptionsDropDown_Initialize, "MENU")
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetHooks()
	SetFrames()
end

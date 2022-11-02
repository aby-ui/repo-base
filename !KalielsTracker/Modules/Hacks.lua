--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_Hacks")
KT.Hacks = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db

-- LFGList.lua
-- Affects the small Eye buttons for finding groups inside the tracker. When the hack is active,
-- the buttons work without errors. When hack is inactive, the buttons are not available.
-- Negative impacts:
-- - Inside the dialog for create Premade Group is hidden item "Goal".
-- - Tooltips of items in the list of Premade Groups have a hidden 2nd (green) row with "Goal".
-- - Inside the dialog for create Premade Group, no automatically set the "Title", e.g. keystone level for Mythic+.
local function Hack_LFG()
    if db.hackLFG then
        local bck_C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
        function C_LFGList.GetSearchResultInfo(resultID)
            local searchResultInfo = bck_C_LFGList_GetSearchResultInfo(resultID)
            if searchResultInfo then
                searchResultInfo.playstyle = 0
            end
            return searchResultInfo
        end

        local bck_C_LFGList_GetLfgCategoryInfo = C_LFGList.GetLfgCategoryInfo
        function C_LFGList.GetLfgCategoryInfo(categoryID)
            local categoryInfo = bck_C_LFGList_GetLfgCategoryInfo(categoryID)
            if categoryInfo then
                categoryInfo.showPlaystyleDropdown = false
            end
            return categoryInfo
        end

        LFGListEntryCreation_OnPlayStyleSelected = function() end

        LFGListEntryCreation_SetTitleFromActivityInfo = function() end
    else
        function QuestObjectiveSetupBlockButton_FindGroup(block, questID)
            return false
        end
    end
end

-- Edit Mode
-- Affects Edit Mode and remove errors. But if you want to edit Target or Focus frames, you have to display them manually by chat command.
-- - For Target frame use command ... /target player
-- - For Focus frame use command ... /focus player
-- Negative impacts:
-- - Item "Target and Focus" is always enabled, but Target and Focus frames are not displayed.
-- - Target or Focus frames you display by chat command (see above).
-- - Tracker perform Reload UI when exiting Edit Mode.
local function Hack_EditMode()
    hooksecurefunc(ObjectiveTrackerFrame, "HighlightSystem", function(self)
        self.Selection:Hide()
    end)

    hooksecurefunc(ObjectiveTrackerFrame, "OnEditModeEnter", function(self)
        ObjectiveTracker_Update()
    end)

    hooksecurefunc(ObjectiveTrackerFrame, "OnEditModeExit", function(self)
        if EditModeManagerFrame:IsEditModeLocked() then
            ObjectiveTracker_Update()
        else
            ReloadUI()
        end
    end)

    function EditModeManagerFrame.AccountSettings.Settings.TargetAndFocus:ShouldEnable()
        return false
    end

    hooksecurefunc(EditModeManagerFrame.AccountSettings, "OnEditModeEnter", function(self)
        print("EditModeManagerFrame.AccountSettings ... OnEditModeEnter")
        if not self.KTinfo then
            print(".....")
            self.Settings.TargetAndFocus.Button:SetPoint("TOPLEFT")
            local infoText = self.Settings.TargetAndFocus:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
            infoText:SetWidth(180)
            infoText:SetPoint("TOPLEFT", self.Settings.TargetAndFocus.Label, "BOTTOMLEFT",  0, 6)
            infoText:SetJustifyH("LEFT")
            infoText:SetText("|cff00ffffDisabled by "..KT.title..".\n\nFor display use commands:\n- Target frame ... |cffffffff/target player\n|cff00ffff- Focus frame ... |cffffffff/focus player")
            self.KTinfo = true
        end
    end)

    function EditModeManagerFrame.AccountSettings:RefreshTargetAndFocus()  -- R
        print("EditModeManagerFrame.AccountSettings ... RefreshTargetAndFocus")
        self.Settings.TargetAndFocus:SetControlChecked(true)

        TargetFrame:HighlightSystem()
        FocusFrame:HighlightSystem()

        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self:RegisterEvent("PLAYER_FOCUS_CHANGED")
    end

    function EditModeManagerFrame.AccountSettings:ResetTargetAndFocus()  -- R
        self:UnregisterEvent("PLAYER_TARGET_CHANGED")
        self:UnregisterEvent("PLAYER_FOCUS_CHANGED")

        TargetFrame:ClearHighlight()
        FocusFrame:ClearHighlight()
    end
end

function M:OnInitialize()
    _DBG("|cffffff00Init|r - "..self:GetName(), true)
    db = KT.db.profile
end

function M:OnEnable()
    _DBG("|cff00ff00Enable|r - "..self:GetName(), true)
    Hack_LFG()
    Hack_EditMode()
end
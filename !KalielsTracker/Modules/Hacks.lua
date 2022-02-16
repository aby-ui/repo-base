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

function M:OnInitialize()
    _DBG("|cffffff00Init|r - "..self:GetName(), true)
    db = KT.db.profile
end

function M:OnEnable()
    _DBG("|cff00ff00Enable|r - "..self:GetName(), true)
    Hack_LFG()
end
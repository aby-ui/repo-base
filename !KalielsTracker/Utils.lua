--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local L = KT.L
KT.title = GetAddOnMetadata(addonName, "Title")

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local next = next
local strfind = string.find
local strlen = string.len
local strsub = string.sub
local tonumber = tonumber

local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"

-- Version
function KT.IsHigherVersion(newVersion, oldVersion)
    local result = false
    local _, _, nV1, nV2, nV3, nBuild = strfind(newVersion, "(%d+)%.(%d+)%.(%d+)(.*)")
    local _, _, oV1, oV2, oV3, oBuild = strfind(oldVersion, "(%d+)%.(%d+)%.(%d+)(.*)")
    local _, _, nBuildType, nBuildNumber = strfind(nBuild, "%-(%w+)%.(%d+)")
    local _, _, oBuildType, oBuildNumber = strfind(oBuild, "%-(%w+)%.(%d+)")
    nV1, nV2, nV3, nBuildNumber = tonumber(nV1), tonumber(nV2), tonumber(nV3), tonumber(nBuildNumber)
    oV1, oV2, oV3, oBuildNumber = tonumber(oV1), tonumber(oV2), tonumber(oV3), tonumber(oBuildNumber)
    if nV1 == oV1 then
        if nV2 == oV2 then
            if nV3 == oV3 then
                -- no support for alpha vs beta builds
                if nBuildType == nil then
                    result = true
                elseif nBuildType == oBuildType then
                    if nBuildNumber and nBuildNumber >= oBuildNumber then
                        result = true
                    end
                end
            elseif nV3 > oV3 then
                result = true
            end
        elseif nV2 > oV2 then
            result = true
        end
    elseif nV1 > oV1 then
        result = true
    end
    return result
end

-- Table
function KT.IsTableEmpty(table)
    return (next(table) == nil)
end

-- Map
function KT.GetMapContinents()
    return C_Map.GetMapChildrenInfo(946, Enum.UIMapType.Continent, true)
end

function KT.GetCurrentMapAreaID()
    return C_Map.GetBestMapForUnit("player")
end

function KT.GetMapContinent(mapID)
    if mapID then
        if mapID == 1355 then   -- Nazjatar
            return C_Map.GetMapInfo(mapID) or {}
        else
            return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
        end
    end
    return {}
end

function KT.GetCurrentMapContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    return KT.GetMapContinent(mapID)
end

function KT.GetMapNameByID(mapID)
    if mapID then
        local mapInfo = C_Map.GetMapInfo(mapID) or {}
        return mapInfo.name
    end
    return nil
end

function KT.SetMapToCurrentZone()
    local mapID = C_Map.GetBestMapForUnit("player")
    WorldMapFrame:SetMapID(mapID)
end

function KT.GetMapID()
    return WorldMapFrame:GetMapID()
end

function KT.SetMapID(mapID)
    WorldMapFrame:SetMapID(mapID)
end

function KT.IsInBetween()  -- Shadowlands
    return (UnitOnTaxi("player") and KT.GetCurrentMapAreaID() == 1550)
end

-- RGB to Hex
local function DecToHex(num)
    local b, k, hex, d = 16, "0123456789abcdef", "", 0
    while num > 0 do
        d = fmod(num, b) + 1
        hex = strsub(k, d, d)..hex
        num = floor(num/b)
    end
    hex = (hex == "") and "0" or hex
    return hex
end

function KT.RgbToHex(color)
    local r, g, b = DecToHex(color.r*255), DecToHex(color.g*255), DecToHex(color.b*255)
    r = (strlen(r) < 2) and "0"..r or r
    g = (strlen(g) < 2) and "0"..g or g
    b = (strlen(b) < 2) and "0"..b or b
    return r..g..b
end

-- GameTooltip
local colorNotUsable = { r = 1, g = 0, b = 0 }
function KT.GameTooltip_AddQuestRewardsToTooltip(tooltip, questID, isBonus)
    local bckSelectedQuestID = C_QuestLog.GetSelectedQuest()  -- backup selected Quest
    C_QuestLog.SetSelectedQuest(questID)  -- for num Choices

    local xp = GetQuestLogRewardXP(questID)
    local money = GetQuestLogRewardMoney(questID)
    local artifactXP = GetQuestLogRewardArtifactXP(questID)
    local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
    local numQuestRewards = GetNumQuestLogRewards(questID)
    local numQuestSpellRewards = GetNumQuestLogRewardSpells(questID)
    local numQuestChoices = GetNumQuestLogChoices(questID)
    local honor = GetQuestLogRewardHonor(questID)
    if xp > 0 or
            money > 0 or
            artifactXP > 0 or
            numQuestCurrencies > 0 or
            numQuestRewards > 0 or
            numQuestSpellRewards > 0 or
            numQuestChoices > 0 or
            honor > 0 then
        local isQuestWorldQuest = QuestUtils_IsQuestWorldQuest(questID)
        local isWarModeDesired = C_PvP.IsWarModeDesired()
        local questHasWarModeBonus = C_QuestLog.QuestCanHaveWarModeBonus(questID)
        tooltip:AddLine(" ")
        tooltip:AddLine(REWARDS..":")
        -- xp
        if xp > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, FormatLargeNumber(xp).."|c0000ff00"), 1, 1, 1)
            if isWarModeDesired and isQuestWorldQuest and questHasWarModeBonus then
                tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_XP_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
            end
        end
        -- honor
        if honor > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, "Interface\\ICONS\\Achievement_LegionPVPTier4", honor, HONOR), 1, 1, 1)
        end
        -- money
        if money > 0 then
            tooltip:AddLine(GetCoinTextureString(money, 12), 1, 1, 1)
            if isWarModeDesired and isQuestWorldQuest and questHasWarModeBonus then
                tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
            end
        end
        if not isBonus then
            -- choices
            for i = 1, numQuestChoices do
                local name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i)
                local text
                if numItems > 1 then
                    text = format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(numItems), name)
                elseif texture and name then
                    text = format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
                end
                if text then
                    local color = isUsable and ITEM_QUALITY_COLORS[quality] or colorNotUsable
                    tooltip:AddLine(text, color.r, color.g, color.b)
                end
            end
        end
        -- spells
        for i = 1, numQuestSpellRewards do
            local texture, name = GetQuestLogRewardSpell(i, questID)
            if name and texture then
                tooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name), 1, 1, 1)
            end
        end
        -- items
        for i = 1, numQuestRewards do
            local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, questID)
            local text
            if numItems > 1 then
                text = format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(numItems), name)
            elseif texture and name then
                text = format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
            end
            if text then
                local color = isUsable and ITEM_QUALITY_COLORS[quality] or colorNotUsable
                tooltip:AddLine(text, color.r, color.g, color.b)
            end
        end
        -- artifact power
        if artifactXP > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT, FormatLargeNumber(artifactXP)), 1, 1, 1)
        end
        -- currencies
        if numQuestCurrencies > 0 then
            QuestUtils_AddQuestCurrencyRewardsToTooltip(questID, tooltip)
        end
        -- war mode bonus (quest only)
        if isWarModeDesired and not isQuestWorldQuest and questHasWarModeBonus then
            tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
        end
    end

    C_QuestLog.SetSelectedQuest(bckSelectedQuestID)  -- restore selected Quest
end

-- Quest
function KT.GetQuestTagInfo(questID)
    return C_QuestLog.GetQuestTagInfo(questID) or {}
end

function KT.GetQuestLogSpecialItemInfo(questLogIndex)
    local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex)
    if charges and charges <= 0 then
        charges = GetItemCount(link)
    end
    return link, item, charges, showItemWhenComplete
end

function KT.GetNumQuests()
    local numQuests = 0
    local numEntries = C_QuestLog.GetNumQuestLogEntries()
    for i = 1, numEntries do
        local info = C_QuestLog.GetInfo(i)
        if not info.isHidden and not info.isHeader and not C_QuestLog.IsQuestCalling(info.questID) then
            numQuests = numQuests + 1
        end
    end
    return numQuests
end

function KT.GetNumQuestWatches()
    local numWatches = C_QuestLog.GetNumQuestWatches()
    for i = 1, C_QuestLog.GetNumQuestWatches() do
        local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
        if questID then
            local quest = QuestCache:Get(questID)
            if quest:IsDisabledForSession() then
                numWatches = numWatches - 1
            end
        end
    end
    return numWatches
end

-- Scenario
function KT.IsScenarioHidden()
    local _, _, numStages = C_Scenario.GetInfo()
    return numStages == 0 or IsOnGroundFloorInJailersTower()
end

-- Time
function KT.SecondsToTime(seconds, noSeconds, maxCount, roundUp)
    local time = "";
    local count = 0;
    local tempTime;
    seconds = roundUp and ceil(seconds) or floor(seconds);
    maxCount = maxCount or 2;
    if ( seconds >= 86400  ) then
        count = count + 1;
        if ( count == maxCount and roundUp ) then
            tempTime = ceil(seconds / 86400);
        else
            tempTime = floor(seconds / 86400);
        end
        time = tempTime..L" Day";
        seconds = mod(seconds, 86400);
    end
    if ( count < maxCount and seconds >= 3600  ) then
        count = count + 1;
        if ( time ~= "" ) then
            time = time..TIME_UNIT_DELIMITER;
        end
        if ( count == maxCount and roundUp ) then
            tempTime = ceil(seconds / 3600);
        else
            tempTime = floor(seconds / 3600);
        end
        time = time..tempTime..L" Hr";
        seconds = mod(seconds, 3600);
    end
    if ( count < maxCount and seconds >= 60  ) then
        count = count + 1;
        if ( time ~= "" ) then
            time = time..TIME_UNIT_DELIMITER;
        end
        if ( count == maxCount and roundUp ) then
            tempTime = ceil(seconds / 60);
        else
            tempTime = floor(seconds / 60);
        end
        time = time..tempTime..L" Min";
        seconds = mod(seconds, 60);
    end
    if ( count < maxCount and seconds > 0 and not noSeconds ) then
        if ( time ~= "" ) then
            time = time..TIME_UNIT_DELIMITER;
        end
        time = time..seconds..L" Sec";
    end
    return time;
end

-- =====================================================================================================================

local function StatiPopup_OnShow(self)
    if self.text.text_arg1 then
        self.text:SetText(self.text:GetText().." - "..self.text.text_arg1)
    end
    if self.text.text_arg2 then
        if self.data then
            self.SubText:SetFormattedText(self.text.text_arg2, unpack(self.data))
        else
            self.SubText:SetText(self.text.text_arg2)
        end
        self.SubText:SetTextColor(1, 1, 1)
    else
        self.SubText:Hide()
    end
end

StaticPopupDialogs[addonName.."_Info"] = {
    text = "|T"..mediaPath.."KT_logo:22:22:0:0|t"..NORMAL_FONT_COLOR_CODE..KT.title.."|r",
    subText = "...",
    button2 = CLOSE,
    OnShow = StatiPopup_OnShow,
    timeout = 0,
    whileDead = 1
}

StaticPopupDialogs[addonName.."_ReloadUI"] = {
    text = "|T"..mediaPath.."KT_logo:22:22:0:0|t"..NORMAL_FONT_COLOR_CODE..KT.title.."|r",
    subText = "...",
    button1 = RELOADUI,
    OnShow = StatiPopup_OnShow,
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1
}

StaticPopupDialogs[addonName.."_LockUI"] = {
    text = "|T"..mediaPath.."KT_logo:22:22:0:0|t"..NORMAL_FONT_COLOR_CODE..KT.title.."|r",
    subText = "...",
    button1 = LOCK,
    OnShow = StatiPopup_OnShow,
    OnAccept = function()
        local overlay = KT.frame.ActiveFrame.overlay
        overlay:Hide()
    end,
    timeout = 0,
    whileDead = 1
}

StaticPopupDialogs[addonName.."_WowheadURL"] = {
    text = "|T"..mediaPath.."KT_logo:22:22:0:-1|t"..NORMAL_FONT_COLOR_CODE..KT.title.."|r - Wowhead URL",
    button2 = CLOSE,
    hasEditBox = 1,
    editBoxWidth = 300,
    EditBoxOnTextChanged = function(self)
        self:SetText(self.text)
        self:HighlightText()
    end,
    EditBoxOnEnterPressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    OnShow = function(self)
        local name = "..."
        if self.text.text_arg1 == "quest" then
            name = QuestUtils_GetQuestName(self.text.text_arg2)
        elseif self.text.text_arg1 == "achievement" then
            name = select(2, GetAchievementInfo(self.text.text_arg2))
        end
        local www = KT.locale:sub(1, 2)
        if www == "zh" then www = "cn" end
        self.text:SetText(self.text:GetText().."\n|cffff7f00"..name.."|r")
        self.editBox.text = "http://"..www..".wowhead.com/"..self.text.text_arg1.."="..self.text.text_arg2
        self.editBox:SetText(self.editBox.text)
        self.editBox:SetFocus()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
}

function KT:Alert_ResetIncompatibleProfiles(version)
    if self.db.global.version and not self.IsHigherVersion(self.db.global.version, version) then
        local profile
        for _, v in ipairs(self.db:GetProfiles()) do
            profile = self.db.profiles[v]
            for k, _ in pairs(profile) do
                profile[k] = nil
            end
        end
		StaticPopup_Show(addonName.."_Info", nil, "任务增强的设置已经重置，因为新版本 %s 无法使用老版本的设置.", { self.version })
    end
end

function KT:Alert_IncompatibleAddon(addon, version)
    if not self.IsHigherVersion(GetAddOnMetadata(addon, "Version"), version) then
        self.db.profile["addon"..addon] = false
        StaticPopup_Show(addonName.."_ReloadUI", nil, "|cff00ffe3%s|r support has been disabled. Please install version |cff00ffe3%s|r or later and enable addon support.", { GetAddOnMetadata(addon, "Title"), version })
    end
end

function KT:Alert_WowheadURL(type, id)
    StaticPopup_Show(addonName.."_WowheadURL", type, id)
end

--- Kaliel's Tracker
--- Copyright (c) 2012-2020, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local next = next
local strfind = string.find
local strlen = string.len
local strsub = string.sub
local tonumber = tonumber

-- Version
function KT.IsHigherVersion(newVersion, oldVersion)
    local result = false
    local _, _, nV1, nV2, nV3 = strfind(newVersion, "(%d+)%.(%d+)%.(%d+)")
    local _, _, oV1, oV2, oV3 = strfind(oldVersion, "(%d+)%.(%d+)%.(%d+)")
    nV1, nV2, nV3 = tonumber(nV1), tonumber(nV2), tonumber(nV3)
    oV1, oV2, oV3 = tonumber(oV1), tonumber(oV2), tonumber(oV3)
    if nV1 == oV1 then
        if nV2 == oV2 then
            if nV3 > oV3 then
                result = true
            end
        else
            if nV2 > oV2 then
                result = true
            end
        end
    else
        if nV1 > oV1 then
            result = true
        end
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

function KT.GetCurrentMapContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID == 1355 then   -- Nazjatar
        return C_Map.GetMapInfo(mapID) or {}
    else
        return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
    end
end

function KT.GetMapContinent(mapID)
    if mapID == 1355 then   -- Nazjatar
        return C_Map.GetMapInfo(mapID) or {}
    else
        return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
    end
end

function KT.GetMapNameByID(mapID)
    local mapInfo = C_Map.GetMapInfo(mapID) or {}
    return mapInfo.name
end

function KT.SetMapToCurrentZone()
    local mapID = C_Map.GetBestMapForUnit("player")
    WorldMapFrame:SetMapID(mapID)
end

function KT.SetMapByID(mapID)
    WorldMapFrame:SetMapID(mapID)
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
    local bckQuestLogSelection = GetQuestLogSelection()  -- backup Quest Log selection
    local questLogIndex = GetQuestLogIndexByID(questID)
    SelectQuestLogEntry(questLogIndex)	-- for num Choices

    local xp = GetQuestLogRewardXP(questID)
    local money = GetQuestLogRewardMoney(questID)
    local artifactXP = GetQuestLogRewardArtifactXP(questID)
    local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
    local numQuestRewards = GetNumQuestLogRewards(questID)
    local numQuestSpellRewards = GetNumQuestLogRewardSpells(questID)
    local numQuestChoices = GetNumQuestLogChoices()
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
        local questHasWarModeBonus = C_QuestLog.QuestHasWarModeBonus(questID)
        tooltip:AddLine(" ")
        tooltip:AddLine(REWARDS..":")
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
        -- xp
        if xp > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, FormatLargeNumber(xp).."|c0000ff00"), 1, 1, 1)
            if isWarModeDesired and isQuestWorldQuest and questHasWarModeBonus then
                tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_XP_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
            end
        end
        -- money
        if money > 0 then
            tooltip:AddLine(GetCoinTextureString(money, 12), 1, 1, 1)
            if isWarModeDesired and isQuestWorldQuest and questHasWarModeBonus then
                tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
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
        -- honor
        if honor > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, "Interface\\ICONS\\Achievement_LegionPVPTier4", honor, HONOR), 1, 1, 1)
        end
        -- war mode bonus (quest only)
        if isWarModeDesired and not isQuestWorldQuest and questHasWarModeBonus then
            tooltip:AddLine(WAR_MODE_BONUS_PERCENTAGE_FORMAT:format(C_PvP.GetWarModeRewardBonus()))
        end
    end

    SelectQuestLogEntry(bckQuestLogSelection)  -- restore Quest Log selection
end
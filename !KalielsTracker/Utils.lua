--- Kaliel's Tracker
--- Copyright (c) 2012-2019, Marouan Sabbagh <mar.sabbagh@gmail.com>
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
    return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
end

function KT.GetMapContinent(mapID)
    return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
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
function KT.GameTooltip_AddQuestRewardsToTooltip(tooltip, questID, isBonus)
    local questLogIndex = GetQuestLogIndexByID(questID)
    SelectQuestLogEntry(questLogIndex)	-- for num Choices
    if GetQuestLogRewardXP(questID) > 0 or
            GetQuestLogRewardMoney(questID) > 0 or
            GetQuestLogRewardArtifactXP(questID) > 0 or
            GetNumQuestLogRewardCurrencies(questID) > 0 or
            GetQuestLogRewardHonor(questID) > 0 or
            GetNumQuestLogRewards(questID) > 0 or
            GetNumQuestLogChoices() > 0 then
        tooltip:AddLine(" ")
        tooltip:AddLine(REWARDS..":")
        if not isBonus then
            -- choices
            local numQuestChoices = GetNumQuestLogChoices()
            for i = 1, numQuestChoices do
                local name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i)
                local text
                if numItems > 1 then
                    text = format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(numItems), name)
                elseif texture and name then
                    text = format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
                end
                if text then
                    local color = ITEM_QUALITY_COLORS[quality]
                    tooltip:AddLine(text, color.r, color.g, color.b)
                end
            end
        end
        -- items
        local numQuestRewards = GetNumQuestLogRewards(questID)
        for i = 1, numQuestRewards do
            local name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i, questID)
            local text
            if numItems > 1 then
                text = format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, texture, HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(numItems), name)
            elseif texture and name then
                text = format(BONUS_OBJECTIVE_REWARD_FORMAT, texture, name)
            end
            if text then
                local color = ITEM_QUALITY_COLORS[quality]
                tooltip:AddLine(text, color.r, color.g, color.b)
            end
        end
        -- xp
        local xp = GetQuestLogRewardXP(questID)
        if xp > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_EXPERIENCE_FORMAT, FormatLargeNumber(xp).."|c0000ff00"), 1, 1, 1)
        end
        -- money
        local money = GetQuestLogRewardMoney(questID)
        if money > 0 then
            --SetTooltipMoney(tooltip, money, nil)
            tooltip:AddLine(GetCoinTextureString(money, 12), 1, 1, 1)
        end
        -- artifact power
        local artifactXP = GetQuestLogRewardArtifactXP(questID)
        if artifactXP > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT, FormatLargeNumber(artifactXP)).."xx", 1, 1, 1)
        end
        -- currencies
        QuestUtils_AddQuestCurrencyRewardsToTooltip(questID, tooltip)
        -- honor
        local honorAmount = GetQuestLogRewardHonor(questID)
        if honorAmount > 0 then
            tooltip:AddLine(format(BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT, "Interface\\ICONS\\Achievement_LegionPVPTier4", honorAmount, HONOR), 1, 1, 1)
        end
    end
end
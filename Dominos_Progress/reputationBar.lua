local _, Addon = ...
local Dominos = _G.Dominos
local ReputationBar = Dominos:CreateClass("Frame", Addon.ProgressBar)
local FRIEND_FACTION_COLOR_INDEX = 5
local PARAGON_FACTION_COLOR_INDEX = #FACTION_BAR_COLORS
local MAX_REPUTATION_REACTION = _G.MAX_REPUTATION_REACTION
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')

local GetFriendshipReputation = GetFriendshipReputation
if not GetFriendshipReputation then
    GetFriendshipReputation = function()
        return
    end
end

local IsFactionParagon = C_Reputation and C_Reputation.IsFactionParagon
if not IsFactionParagon then
    IsFactionParagon = function()
        return false
    end
end

function ReputationBar:Init()
    self:Update()
end

function ReputationBar:Update()
    local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
    if not name then
        local color = FACTION_BAR_COLORS[1]
        self:SetColor(color.r, color.g, color.b)
        self:SetValues()
        self:SetText(_G.REPUTATION)
        return
    end

    local description, colorIndex, capped

    if IsFactionParagon(factionID) then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
        min, max, value = 0, threshold, currentValue % threshold

        colorIndex = PARAGON_FACTION_COLOR_INDEX
        description = L.Paragon
        capped = false
    else
        local friendID, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)

        if friendID then
            if nextFriendThreshold then
                min, max, value = friendThreshold, nextFriendThreshold, friendRep
            else
                min, max, value = 0, 1, 1
                capped = true
            end

            colorIndex = FRIEND_FACTION_COLOR_INDEX
            description = friendTextLevel
        else
            if reaction == MAX_REPUTATION_REACTION then
                min, max, value = 0, 1, 1
                capped = true
            end

            colorIndex = reaction
            description = GetText("FACTION_STANDING_LABEL" .. reaction, UnitSex("player"))
        end
    end

    max = max - min
    value = value - min

    local color = FACTION_BAR_COLORS[colorIndex]
    self:SetColor(color.r, color.g, color.b)
    self:SetValues(value, max)
    self:UpdateText(name, value, max, description, capped)
end

function ReputationBar:IsModeActive()
    return GetWatchedFactionInfo() ~= nil
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes["reputation"] = ReputationBar
Addon.ReputationBar = ReputationBar

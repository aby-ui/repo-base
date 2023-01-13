local _, Addon = ...
local Dominos = _G.Dominos
local ReputationBar = Dominos:CreateClass("Frame", Addon.ProgressBar)
local PARAGON_FACTION_COLOR_INDEX = #FACTION_BAR_COLORS

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

local IsMajorFaction = C_Reputation and C_Reputation.IsMajorFaction
if not IsMajorFaction then
    IsMajorFaction = function()
        return false
    end
end

local function IsFriendshipFaction(factionID)
    if factionID then
        local getRep = C_GossipInfo and C_GossipInfo.GetFriendshipReputation
        if type(getRep) == "function" then
            local info = getRep(factionID)

            if type(info) == "table" then
                return info.friendshipFactionID > 0
            end
        end
    end

    return false
end

function ReputationBar:Init()
    self:Update()
end

function ReputationBar:Update()
    local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
    local capped = false
    local factionStandingText, color

    if not name then
        min = 0
        max = 1
        value = 0

        factionStandingText = REPUTATION
        color = FACTION_BAR_COLORS[1]
    elseif IsFactionParagon(factionID) then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)

        min = 0
        max = threshold
        value = currentValue % threshold

        color = FACTION_BAR_COLORS[PARAGON_FACTION_COLOR_INDEX]
        factionStandingText = GetText("FACTION_STANDING_LABEL" .. reaction, UnitSex("player"))
    elseif IsFriendshipFaction(factionID) then
        local info = C_GossipInfo.GetFriendshipReputation(factionID)

		if info.nextThreshold then
            min = info.reactionThreshold
            max =  info.nextThreshold
            value = info.standing
        else
            min = 0
            max = 1
            value = 1
            capped = true
		end

        color = FACTION_BAR_COLORS[reaction]
        factionStandingText = info.reaction
    elseif IsMajorFaction(factionID) then
        local info = C_MajorFactions.GetMajorFactionData(factionID)

        capped  = C_MajorFactions.HasMaximumRenown(factionID)
        min = 0
        max = info.renownLevelThreshold
        value = capped and info.renownLevelThreshold or info.renownReputationEarned or 0;

        color = BLUE_FONT_COLOR
        factionStandingText = RENOWN_LEVEL_LABEL .. info.renownLevel
    else
        if reaction == MAX_REPUTATION_REACTION then
            min = 0
            max = 1
            value = 1
            capped = true
        end

        color = FACTION_BAR_COLORS[reaction]
        factionStandingText = GetText("FACTION_STANDING_LABEL" .. reaction, UnitSex("player"))
    end

    max = max - min
    value = value - min

    self:SetColor(color.r, color.g, color.b)
    self:SetValues(value, max)
    self:UpdateText(name, value, max, factionStandingText, capped)
end

function ReputationBar:IsModeActive()
    return GetWatchedFactionInfo() ~= nil
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes["reputation"] = ReputationBar
Addon.ReputationBar = ReputationBar

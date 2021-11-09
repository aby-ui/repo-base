local _, dc = ...

dc.oribos = {}

local oribos = dc.oribos
oribos.emptyCovenants = {}
oribos.covenants = {}

local _, ownClass = UnitClass("player")

function oribos:getCovenantIcon(covenantID)
    if covenantID > 0 and covenantID < 5 then
        local covenantMap = {
            [1] = "kyrian",
            [2] = "venthyr",
            [3] = "night_fae",
            [4] = "necrolord",
        }

        return "|T".."Interface\\AddOns\\Details_Covenants\\resources\\"..covenantMap[covenantID]..".tga:"..DCovenant["iconSize"]..":"..DCovenant["iconSize"].."|t"
    end

    return ""
end

function oribos:fillCovenants()
    local numGroupMembers = GetNumGroupMembers()
    for groupindex = 1, numGroupMembers do
        local name = GetRaidRosterInfo(groupindex)

        if name and not oribos.covenants[name] and not oribos.emptyCovenants[name] then
            oribos.emptyCovenants[name] = 0
            oribos:askCovenantInfo(name)
        end
    end
end

function oribos:addCovenantForPlayer(covenantID, playerName, playerClass)
    if covenantID then
        local playerData = {}
        playerData.covenantID = covenantID
        playerData.class = playerClass
        oribos.covenants[playerName] = playerData
        oribos.emptyCovenants[playerName] = nil
    end
end

function oribos:askCovenantInfo(playerName)
    local message = dc.askMessage..":"..playerName
    C_ChatInfo.SendAddonMessage(dc.addonPrefix, message, "RAID")
end

function oribos:sendCovenantInfo(playerName)
    if playerName then
        if playerName == UnitName("player") then
            local message = playerName..":"..C_Covenants.GetActiveCovenantID()..":"..ownClass
            C_ChatInfo.SendAddonMessage(dc.addonPrefix, message, "RAID")
        elseif oribos.covenants[playerName] then
            local message = playerName..":"..oribos.covenants[playerName].covenantID..":"..oribos.covenants[playerName].class
            C_ChatInfo.SendAddonMessage(dc.addonPrefix, message, "RAID")
        end
    end
end

function oribos:hasPlayerWithEmptyCovenant()
    return not dc.utils:isEmpty(oribos.emptyCovenants)
end

-- Loggers
function oribos:logNewPlayer(covenantID, playerName, playerClass, spellID)
    if DCovenantLog and covenantID and playerName ~= UnitName("player") and (not oribos.covenants[playerName] or oribos.covenants[playerName].covenantID ~= covenantID) then
        local coloredName = "|CFFe5a472Details_Covenants|r"
        local _, _, _, classColor = GetClassColor(playerClass)
        local byMessage = ""

        if spellID then
            local link = GetSpellLink(spellID)
            byMessage = " (使用技能: "..link..")"
        end

        print("检测到玩家盟约: "..oribos:getCovenantIcon(covenantID).." |C"..classColor..playerName.."|r"..byMessage)
    end
end

function oribos:log()
    print("|CFFe5a472Details_Covenants|r List of logged characters:")

    for key, data in pairs(oribos.covenants) do
        local _, _, _, classColor = GetClassColor(data.class)
        print(oribos:getCovenantIcon(data.covenantID).." |C"..classColor..key.."|r")
    end
end

function oribos:logParty()
    local numGroupMembers = GetNumGroupMembers()
    if numGroupMembers > 0 then
        print("|CFFe5a472Details_Covenants|r Party covenants:")

        for groupindex = 1, numGroupMembers do
            local name = GetRaidRosterInfo(groupindex)

            local playerData = oribos.covenants[name]
            if name and playerData then
                local _, _, _, classColor = GetClassColor(playerData.class)
                print(oribos:getCovenantIcon(playerData.covenantID).." |C"..classColor..name.."|r")
            end
        end
    else
        print("|CFFe5a472Details_Covenants|r You are not currently in group.")
    end
end


-- Public
_G.Oribos = {}
local publicOribos = _G.Oribos

function publicOribos:getCovenantIconForPlayer(playerName)
    local covenantID = 0

    if playerName == UnitName("player") then
        covenantID = C_Covenants.GetActiveCovenantID()
    else
        local covenantData = oribos.covenants[playerName]

        if covenantData and covenantData.covenantID then
            covenantID = covenantData.covenantID
        else
            return ""
        end
    end

    return oribos:getCovenantIcon(covenantID)
end

local _, dc = ...

dc.addonPrefix = "DCOribos"
dc.askMessage = "ASK"
DCovenant = {
    ["iconSize"] = 16,
}
DCovenantLog = false

local isAsked = false

local playerName = UnitName("player")
local realmName = ""

local frame = CreateFrame("FRAME", "DetailsCovenantFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("ADDON_LOADED");

local function registerCombatEvent()
    if dc.oribos:hasPlayerWithEmptyCovenant() then 
        frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    else
        frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    end
end

local function updateGroupRoster()
    dc.oribos:fillCovenants()

    registerCombatEvent()
end

local function init()
    local _, playerClass = UnitClass("player")
    realmName = GetNormalizedRealmName()
    dc.oribos:addCovenantForPlayer(C_Covenants.GetActiveCovenantID(), UnitName("player"), playerClass)

    frame:RegisterEvent("GROUP_ROSTER_UPDATE");
    frame:RegisterEvent("CHAT_MSG_ADDON")
    C_ChatInfo.RegisterAddonMessagePrefix(dc.addonPrefix)

    updateGroupRoster()
end

local function eventHandler(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subevent, _, sourceGUID, sourceName = CombatLogGetCurrentEventInfo()

        if dc.oribos:hasPlayerWithEmptyCovenant() and dc.oribos.emptyCovenants[sourceName] then
            if subevent == "SPELL_CAST_SUCCESS" then
                local _, englishClass = GetPlayerInfoByGUID(sourceGUID)
                local classAbilityMap = dc.spellMaps.abilityMap[englishClass]

                if classAbilityMap then
                    local spellID = select(12, CombatLogGetCurrentEventInfo())
                    local covenantIDByAbility = classAbilityMap[spellID]
                    local covenantIDByUtility = dc.spellMaps.utilityMap[spellID]

                    dc.oribos:logNewPlayer(covenantIDByAbility, sourceName, englishClass, spellID)
                    dc.oribos:addCovenantForPlayer(covenantIDByAbility, sourceName, englishClass)

                    dc.oribos:logNewPlayer(covenantIDByUtility, sourceName, englishClass, spellID)
                    dc.oribos:addCovenantForPlayer(covenantIDByUtility, sourceName, englishClass)
                    registerCombatEvent()
                end
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        updateGroupRoster()
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, messageText, _, sender = ...

        if prefix == dc.addonPrefix then
            if string.match(messageText, dc.askMessage) then
                local _, askForName = dc.utils:splitMessage(messageText)

                if string.match(askForName, playerName) then 
                    dc.oribos:sendCovenantInfo(playerName)
                end 
            elseif dc.oribos:hasPlayerWithEmptyCovenant() then
                local senderName, senderRealm = dc.utils:splitName(sender)
                if senderName ~= playerName then
                    local name, covenantID, playerClass = dc.utils:splitMessage(messageText)

                    if realmName ~= senderRealm then
                        name = name.."-"..senderRealm
                    end

                    dc.oribos:logNewPlayer(tonumber(covenantID), name, playerClass)
                    dc.oribos:addCovenantForPlayer(tonumber(covenantID), name, playerClass)
                end
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        init()
        dc:replaceDetailsImplmentation()
        dc:replaceSkadaImplmentation()
        frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
    elseif event == "ADDON_LOADED" then
        if ... == "Details" then
            dc:replaceDetailsImplmentation()
        elseif ... == "Skada" then
            dc:replaceSkadaImplmentation()
        end
    end
end

frame:SetScript("OnEvent", eventHandler);

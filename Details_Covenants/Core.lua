local _, dc = ...

dc.addonPrefix = "DCOribos"
dc.askMessage = "ASK"
DCovenant = {
    ["iconSize"] = 16,
}
DCovenantLog = false

local playerName = UnitName("player")
local realmName = ""

local frame = CreateFrame("FRAME", "DetailsCovenantFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("ADDON_LOADED");


local function init()
    realmName = GetNormalizedRealmName()

    frame:RegisterEvent("GROUP_ROSTER_UPDATE");
    frame:RegisterEvent("CHAT_MSG_ADDON")
    C_ChatInfo.RegisterAddonMessagePrefix(dc.addonPrefix)

    dc.oribos:fillCovenants()
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

---@diagnostic disable-next-line: unused-local
local function eventHandler(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subevent, _, sourceGUID, sourceName = CombatLogGetCurrentEventInfo()

        if dc.oribos.emptyCovenants[sourceName] or dc.oribos.covenants[sourceName] then
            if subevent == "SPELL_CAST_SUCCESS" and dc.utils:isValidGUID(sourceGUID) then
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
                end
            end
        end
    elseif event == "GROUP_ROSTER_UPDATE" then
        dc.oribos:fillCovenants()
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

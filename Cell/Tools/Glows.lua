-- /script SetAllowDangerousScripts(true)
local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs

local LCG = LibStub("LibCustomGlow-1.0")
local Comm = LibStub:GetLibrary("AceComm-3.0")

local function HideGlow(glowFrame)
    LCG.ButtonGlow_Stop(glowFrame)
    LCG.PixelGlow_Stop(glowFrame)
    LCG.AutoCastGlow_Stop(glowFrame)
    
    if glowFrame.timer then
        glowFrame.timer:Cancel()
        glowFrame.timer = nil
    end
end

local function ShowGlow(glowFrame, glowType, glowOptions, timeout, callback)
    F:Debug("SHOW_GLOW:", glowFrame:GetName())
    
    if glowType == "normal" then
        LCG.PixelGlow_Stop(glowFrame)
        LCG.AutoCastGlow_Stop(glowFrame)
        LCG.ButtonGlow_Start(glowFrame, glowOptions[1])
    elseif glowType == "pixel" then
        LCG.ButtonGlow_Stop(glowFrame)
        LCG.AutoCastGlow_Stop(glowFrame)
        -- color, N, frequency, length, thickness, x, y
        LCG.PixelGlow_Start(glowFrame, glowOptions[1], glowOptions[4], glowOptions[5], glowOptions[6], glowOptions[7], glowOptions[2], glowOptions[3])
    elseif glowType == "shine" then
        LCG.ButtonGlow_Stop(glowFrame)
        LCG.PixelGlow_Stop(glowFrame)
        -- color, N, frequency, scale, x, y
        LCG.AutoCastGlow_Start(glowFrame, glowOptions[1], glowOptions[4], glowOptions[5], glowOptions[6], glowOptions[2], glowOptions[3])
    end

    if glowFrame.timer then
        glowFrame.timer:Cancel()
    end
    glowFrame.timer = C_Timer.NewTimer(timeout, function()
        glowFrame.timer = nil
        HideGlow(glowFrame)
        if callback then
            callback()
        end
    end)
end

-------------------------------------------------
-- spell request
-------------------------------------------------
local srEnabled, srExists, srKnown, srFreeCD, srReplyCD, srType, srTimeout, srCastMsg
local srSpells = {
    -- [spellId] = {buffId, keywords, glowOptions}
}
local srUnits = {
    -- [unit] = {spellId, buffId, glowFrame}
}
local requestedSpells = {
    -- [spellId] = unit
}

local SR = CreateFrame("Frame")

local COOLDOWN_TIME = _G.ITEM_COOLDOWN_TIME
local function CheckSRConditions(spellId, unit, sender)
    F:Debug("CheckSRConditions:", spellId, unit, sender)

    if not srSpells[spellId] then return end

    -- can't find unit
    if not unit or not UnitIsVisible(unit) then return end

    -- already has this buff
    if srExists and F:FindAuraById(unit, "BUFF", srSpells[spellId][1]) then return end

    if srKnown then
        if IsSpellKnown(spellId) then
            -- if srDeadMsg and UnitIsDeadOrGhost("player") then
            --     SendChatMessage(srDeadMsg, "WHISPER", nil, sender)
            -- end

            local start, duration, enabled, modRate = GetSpellCooldown(spellId)
            local cdLeft = start + duration - GetTime()

            if srFreeCD then -- NOTE: require free cd
                if start == 0 or duration == 0 then
                    return true
                else
                    local _, gcd = GetSpellCooldown(61304) --! check gcd
                    if duration == gcd then -- spell ready
                        return true
                    else
                        if srReplyCD then -- reply cooldown
                            SendChatMessage(GetSpellLink(spellId).." "..format(COOLDOWN_TIME, F:SecondsToTime(cdLeft)), "WHISPER", nil, sender)
                        end
                        return false
                    end
                end
            else -- NOTE: no require free cd
                if srReplyCD then -- reply cd if cd
                    if start > 0 and duration > 0 then
                        local _, gcd = GetSpellCooldown(61304) --! check gcd
                        if duration ~= gcd then
                            SendChatMessage(GetSpellLink(spellId).." "..format(COOLDOWN_TIME, F:SecondsToTime(cdLeft)), "WHISPER", nil, sender)
                        end
                    end
                end
                return true
            end
        else
            return false
        end
    else
        return true
    end
end

local function ShowSRGlow(spellId, button)
    if button then
        local unit = button.state.unit

        -- check if has previous request
        if srUnits[unit] then
            -- remove previous request
            requestedSpells[srUnits[unit][1]] = nil
        end
        
        --! save {spellId, buffId, button} for hiding
        srUnits[unit] = {spellId, srSpells[spellId][1], button.widget.srGlowFrame} 
        requestedSpells[spellId] = unit
        
        ShowGlow(button.widget.srGlowFrame, srSpells[spellId][3][1], srSpells[spellId][3][2], srTimeout, function()
            srUnits[unit] = nil
            requestedSpells[spellId] = nil
        end)

        -- notify
        F:Notify("SPELL_REQ_RECEIVED", unit, spellId, srSpells[spellId][1], srTimeout)
    end
end

--! glow on addon message
Comm:RegisterComm("CELL_REQ_S", function(prefix, message, channel, sender)
    if srEnabled and srType ~= "whisper" then
        local spellId, target = strsplit(":", message)
        spellId = tonumber(spellId)

        if spellId and CheckSRConditions(spellId, Cell.vars.names[sender], sender) then
            local me = GetUnitName("player")
            -- NOTE: to all provider / to me
            if (srType == "all" and (not target or target == me)) or (srType == "me" and target == me) then
                ShowSRGlow(spellId, F:GetUnitButtonByName(sender))
            end
        end
    end
end)

--! glow on whisper
-- NOTE: playerName always contains SERVER name!
function SR:CHAT_MSG_WHISPER(text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons)
    -- NOTE: filter cd reply
    if strmatch(text, "^|c.+|H.+|h%[.+%]|h|r.+") then return end

    for spellId, t in pairs(srSpells) do
        if strfind(strlower(text), strlower(t[2])) then
            if CheckSRConditions(spellId, Cell.vars.guids[guid], playerName) then
                ShowSRGlow(spellId, F:GetUnitButtonByGUID(guid))
            end
            break
        end
    end
end

--! hide glow when aura changes
if Cell.isRetail then
    function SR:UNIT_AURA(unit, updatedAuras)
        local srUnit = srUnits[unit] -- {spellId, buffId, button}
        if not srUnit then return end
        
        if updatedAuras and updatedAuras.addedAuras then
            for _, aura in pairs(updatedAuras.addedAuras) do
                if srUnit[2] == aura.spellId then
                    F:Debug("SR_HIDE [UNIT_AURA]:", unit, srUnit[1])
                    HideGlow(srUnit[3])
                    -- notify
                    F:Notify("SPELL_REQ_APPLIED", unit, srUnit[1], srUnit[2])
                    -- clear
                    srUnits[unit] = nil
                    requestedSpells[srUnit[1]] = nil
                    break
                end
            end
        end
    end
else
    function SR:UNIT_AURA(unit)
        local srUnit = srUnits[unit] -- {spellId, buffId, button}
        if not srUnit then return end
        
        if F:FindAuraById(unit, "BUFF", srUnit[2]) then
            F:Debug("SR_HIDE [UNIT_AURA]:", unit, srUnit[1])
            HideGlow(srUnit[3])
            -- notify
            F:Notify("SPELL_REQ_APPLIED", unit, srUnit[1], srUnit[2])
            -- clear
            srUnits[unit] = nil
            requestedSpells[srUnit[1]] = nil
        end
    end
end

--! hide glow when player spell cd
function SR:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellId)
    if unit == "player" and requestedSpells[spellId] then
        if not F:FindAuraById(unit, "BUFF", spellId) then return end

        local requester = requestedSpells[spellId]
        F:Debug("SR_HIDE [UNIT_SPELLCAST_SUCCEEDED]:", requester, spellId)
        if srCastMsg then
            SendChatMessage(srCastMsg, "WHISPER", nil, GetUnitName(requester, true))
        end
        
        if srUnits[requester] then
            HideGlow(srUnits[requester][3])
        end

        -- notify
        F:Notify("SPELL_REQ_CAST", requester, srUnits[requester][1], srUnits[requester][2])
        -- clear
        srUnits[requester] = nil
        requestedSpells[spellId] = nil
    end
end

SR:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

-- CELL_SR_SPELLS = srSpells
-- CELL_SR_UNITS = srUnits
local function SR_UpdateGlows(which)
    F:Debug("|cffBBFFFFUpdateGlows:|r", which)

    if not which or which == "spellRequest" then
        -- NOTE: hide all
        for _, t in pairs(srUnits) do
            HideGlow(t[3])
        end
        wipe(srUnits)
        wipe(srSpells)
        wipe(requestedSpells)

        srEnabled = CellDB["glows"]["spellRequest"]["enabled"]
        
        if srEnabled then
            srExists = CellDB["glows"]["spellRequest"]["checkIfExists"]
            srKnown = CellDB["glows"]["spellRequest"]["knownSpellsOnly"]
            srFreeCD = CellDB["glows"]["spellRequest"]["freeCooldownOnly"]
            srType = CellDB["glows"]["spellRequest"]["responseType"]
            srReplyCD = CellDB["glows"]["spellRequest"]["replyCooldown"] and srType ~= "all"
            srTimeout = CellDB["glows"]["spellRequest"]["timeout"]
            
            if srType ~= "all" then
                srCastMsg = CellDB["glows"]["spellRequest"]["replyAfterCast"]
            else
                srCastMsg = nil
            end
            
            for _, t in pairs(CellDB["glows"]["spellRequest"]["spells"]) do
                srSpells[t["spellId"]] = {t["buffId"], t["keywords"], t["glowOptions"]} -- [spellId] = {buffId, keywords, glowOptions}
            end

            if srType == "whisper" then
                SR:RegisterEvent("CHAT_MSG_WHISPER")
            else
                SR:UnregisterEvent("CHAT_MSG_WHISPER")
            end

            SR:RegisterEvent("UNIT_AURA")
            SR:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        else
            SR:UnregisterAllEvents()
        end
        -- texplore(requestedSpells)
    end
end
Cell:RegisterCallback("UpdateGlows", "SR_UpdateGlows", SR_UpdateGlows)

-------------------------------------------------
-- dispel request
-------------------------------------------------
local drEnabled, drDispellable, drType, drTimeout, drDebuffs
local drUnits = {}
local DR = CreateFrame("Frame")

-- hide all
local function HideAllDRGlows()
    -- NOTE: hide all
    for unit in pairs(drUnits) do
        local button = F:GetUnitButtonByUnit(unit)
        if button then
            HideGlow(button.widget.drGlowFrame)
        end
    end
    wipe(drUnits)
end

-- hide glow if removed
DR:SetScript("OnEvent", function(self, event)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = CombatLogGetCurrentEventInfo()
        if subEvent == "SPELL_AURA_REMOVED" then
            local unit = Cell.vars.guids[destGUID]
            if unit and drUnits[unit] and drUnits[unit][spellID] then
                -- NOTE: one of debuffs removed, hide glow
                drUnits[unit] = nil
                local button = F:GetUnitButtonByGUID(destGUID)
                if button then
                    HideGlow(button.widget.drGlowFrame)
                end
            end
        end
    else
        HideAllDRGlows()
    end
end)

-- glow on addon message
Comm:RegisterComm("CELL_REQ_D", function(prefix, message, channel, sender)
    if drEnabled then
        local unit = Cell.vars.names[sender]
        if not unit or not UnitIsVisible(unit) then return end

        if drType == "all" then
            -- NOTE: get all dispellable debuffs on unit
            drUnits[unit] = F:FindAuraByDebuffTypes(unit, "all")
        else -- specific debuff
            -- NOTE: get specific dispellable debuffs on unit
            drUnits[unit] = F:FindDebuffByIds(unit, drDebuffs)
        end
       
        -- NOTE: filter dispellable by me
        if drDispellable then
            for spellId, debuffType in pairs(drUnits[unit]) do
                if not I:CanDispel(debuffType) then
                    drUnits[unit][spellId] = nil
                end
            end
        end

        if F:Getn(drUnits[unit]) ~= 0 then -- found
            local button = F:GetUnitButtonByName(sender)
            if button then
                ShowGlow(button.widget.drGlowFrame, CellDB["glows"]["dispelRequest"]["glowOptions"][1], CellDB["glows"]["dispelRequest"]["glowOptions"][2], drTimeout, function()
                    drUnits[unit] = nil
                end)
            end
        else
            drUnits[unit] = nil
        end
    end
end)

local function DR_UpdateGlows(which)
    if not which or which == "dispelRequest" then
        HideAllDRGlows()
        
        drEnabled = CellDB["glows"]["dispelRequest"]["enabled"]

        if drEnabled then
            drDispellable = CellDB["glows"]["dispelRequest"]["dispellableByMe"]
            drType = CellDB["glows"]["dispelRequest"]["responseType"]
            drTimeout = CellDB["glows"]["dispelRequest"]["timeout"]
            drDebuffs = F:ConvertTable(CellDB["glows"]["dispelRequest"]["debuffs"])

            DR:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            DR:RegisterEvent("ENCOUNTER_START")
            DR:RegisterEvent("ENCOUNTER_END")
        else
            DR:UnregisterAllEvents()
        end
        -- texplore(drUnits)
        -- texplore(drDebuffs)
    end
end
Cell:RegisterCallback("UpdateGlows", "DR_UpdateGlows", DR_UpdateGlows)
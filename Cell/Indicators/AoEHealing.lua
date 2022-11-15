local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs

-------------------------------------------------
-- CreateAoEHealing -- not support for npc
-------------------------------------------------
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local playerSummoned = {}
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function()
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
    -- if subevent == "SPELL_SUMMON" then print(subevent, sourceName, sourceGUID, destName, destGUID, spellName) end
    if subevent == "SPELL_SUMMON" then
        -- print(sourceGUID == Cell.vars.playerGUID, destGUID, spellName, spellId)
        if sourceGUID == Cell.vars.playerGUID and destGUID and (I:IsAoEHealing(spellName) or I:IsAoEHealing(spellId)) then
            local duration = I:GetSummonDuration(spellName)
            if duration then
                playerSummoned[destGUID] = GetTime() + duration -- expirationTime
                C_Timer.After(duration, function()
                    playerSummoned[destGUID] = nil
                end)
            end
        end
        -- texplore(playerSummoned)
    end
    -- if (subevent == "SPELL_HEAL" or subevent == "SPELL_PERIODIC_HEAL") then print(subevent, sourceName, sourceGUID, destName, spellId, spellName) end
    if subevent == "SPELL_HEAL" or subevent == "SPELL_PERIODIC_HEAL" then
        if destGUID then
            -- print(sourceGUID, playerSummoned[sourceGUID])
            if (sourceGUID == Cell.vars.playerGUID and (I:IsAoEHealing(spellName) or I:IsAoEHealing(spellId))) or playerSummoned[sourceGUID] then
                local b1, b2 = F:GetUnitButtonByGUID(destGUID)
                if b1 then b1.indicators.aoeHealing:ShowUp() end
                if b2 then b2.indicators.aoeHealing:ShowUp() end
            end
        end
    end
end)

function I:CreateAoEHealing(parent)
    local aoeHealing = CreateFrame("Frame", parent:GetName().."AoEHealing", parent.widget.healthBar)
    parent.indicators.aoeHealing = aoeHealing
    aoeHealing:SetPoint("TOPLEFT", parent.widget.healthBar)
    aoeHealing:SetPoint("TOPRIGHT", parent.widget.healthBar)
    aoeHealing:SetFrameLevel(parent.widget.healthBar:GetFrameLevel()+1)
    -- aoeHealing:SetHeight(15)
    aoeHealing:Hide()

    aoeHealing.tex = aoeHealing:CreateTexture(nil, "ARTWORK")
    aoeHealing.tex:SetAllPoints(aoeHealing)
    aoeHealing.tex:SetTexture("Interface\\Buttons\\WHITE8x8")
    
    local ag = aoeHealing:CreateAnimationGroup()
    local a1 = ag:CreateAnimation("Alpha")
    a1:SetFromAlpha(0)
    a1:SetToAlpha(1)
    a1:SetDuration(0.5)
    a1:SetOrder(1)
    a1:SetSmoothing("OUT")
    local a2 = ag:CreateAnimation("Alpha")
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetDuration(0.5)
    a2:SetOrder(2)
    a2:SetSmoothing("IN")

    ag:SetScript("OnPlay", function()
        aoeHealing:Show()
    end)
    ag:SetScript("OnFinished", function()
        aoeHealing:Hide()
    end)

    if Cell.isRetail then
        function aoeHealing:SetColor(r, g, b)
            aoeHealing.tex:SetGradient("VERTICAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 0.77))
        end
    else
        function aoeHealing:SetColor(r, g, b)
            aoeHealing.tex:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, 0.77)
        end
    end

    function aoeHealing:ShowUp()
        -- if ag:IsPlaying() then
        --     ag:Restart()
        -- else
            ag:Play()
        -- end
    end
end

function I:EnableAoEHealing(enabled)
    if enabled then
        eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end
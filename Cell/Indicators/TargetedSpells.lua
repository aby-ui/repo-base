local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs
local LCG = LibStub("LibCustomGlow-1.0")

local UnitIsVisible = UnitIsVisible
local UnitGUID = UnitGUID
local UnitIsUnit = UnitIsUnit
local UnitIsEnemy = UnitIsEnemy
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

-------------------------------------------------
-- targeted spells
-------------------------------------------------
local casts, castsOnUnit = {}, {}

local function GetCastsOnUnit(guid)
    if castsOnUnit[guid] then
        wipe(castsOnUnit[guid])
    else
        castsOnUnit[guid] = {}
    end

    for sourceGUID, castInfo in pairs(casts) do
        if guid == castInfo["targetGUID"] then
            if castInfo["endTime"] > GetTime() then -- not expired
                tinsert(castsOnUnit[guid], castInfo)
            else
                casts[sourceGUID] = nil
            end
        end
    end

    return castsOnUnit[guid]
end

local function UpdateCastsOnUnit(guid)
    local b1, b2 = F:GetUnitButtonByGUID(guid)
    if not (b1 or b2) then return end

    local allCasts = 0
    local startTime, endTime, spellId, icon
    for _, castInfo in pairs(GetCastsOnUnit(guid)) do
        allCasts = allCasts + 1
        if not endTime then
            startTime, endTime, spellId, icon = castInfo["startTime"], castInfo["endTime"], castInfo["spellId"], castInfo["icon"]
        elseif endTime > castInfo["endTime"] then -- always show spell with min endTime
            startTime, endTime, spellId, icon = castInfo["startTime"], castInfo["endTime"], castInfo["spellId"], castInfo["icon"]
        end
    end

    if allCasts == 0 then
        if b1 then b1.indicators.targetedSpells:Hide() end
        if b2 then b2.indicators.targetedSpells:Hide() end
    else
        if b1 then
            b1.indicators.targetedSpells:SetCooldown(startTime, endTime-startTime, icon, allCasts)
            b1.indicators.targetedSpells:ShowGlow(unpack(Cell.vars.targetedSpellsGlow))
        end
        if b2 then
            b2.indicators.targetedSpells:SetCooldown(startTime, endTime-startTime, icon, allCasts)
            b2.indicators.targetedSpells:ShowGlow(unpack(Cell.vars.targetedSpellsGlow))
        end
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(_, event, sourceUnit)
    if event == "ENCOUNTER_END" then
        wipe(casts)
        wipe(castsOnUnit)
        F:IterateAllUnitButtons(function(b)
            b.indicators.targetedSpells:Hide()
        end)
        return
    end

    if sourceUnit and UnitIsEnemy(sourceUnit, "player") then
        local sourceGUID = UnitGUID(sourceUnit)
        local cast = casts[sourceGUID]
        local previousTarget

        -- check if expired
        if cast and cast["endTime"] <= GetTime() then
            previousTarget = cast["targetGUID"]
            casts[sourceGUID] = nil
            UpdateCastsOnUnit(previousTarget)
        end

        if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED"  or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" or event == "UNIT_TARGET" or event == "NAME_PLATE_UNIT_ADDED" then
            -- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId
            local name, _, texture, startTimeMS, endTimeMS, _, _, notInterruptible, spellId = UnitCastingInfo(sourceUnit)
            if not name then
                -- name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId
                name, _, texture, startTimeMS, endTimeMS, _, notInterruptible, spellId = UnitChannelInfo(sourceUnit)
            end

            if cast then previousTarget = cast["targetGUID"] end

            if spellId and Cell.vars.targetedSpellsList[spellId] then
                local targetUnit = sourceUnit.."target"
                if UnitIsVisible(targetUnit) then
                    for member in F:IterateGroupMembers() do
                        if UnitIsUnit(targetUnit, member) then
                            local targetGUID = UnitGUID(member)
                            casts[sourceGUID] = {
                                ["startTime"] = startTimeMS/1000,
                                ["endTime"] = endTimeMS/1000,
                                ["spellId"] = spellId,
                                ["icon"] = texture,
                                ["targetGUID"] = targetGUID,
                            }
                            UpdateCastsOnUnit(targetGUID)
                            break
                        end
                    end
                end
            end
            if previousTarget then UpdateCastsOnUnit(previousTarget) end

        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "NAME_PLATE_UNIT_REMOVED" then
            if cast then
                previousTarget = cast["targetGUID"]
                casts[sourceGUID] = nil
                UpdateCastsOnUnit(previousTarget)
            end
        end
    end
end)

function I:CreateTargetedSpells(parent)
    local frame = I:CreateAura_BorderIcon(parent:GetName().."TargetedSpells", parent.widget.overlayFrame, 2)
    parent.indicators.targetedSpells = frame
    frame:Hide()

    -- frame.spellId
    -- frame.spellCount

    function frame:SetCooldown(start, duration, icon, count)
        frame.duration:Hide()

        if count ~= 1 then
            frame.stack:Show()
            frame.stack:SetText(count)
        else
            frame.stack:Hide()
        end

        frame.border:Show()
        frame.cooldown:Show()
        frame.cooldown:SetSwipeColor(unpack(Cell.vars.targetedSpellsGlow[2]))
        frame.cooldown:SetCooldown(start, duration)
        frame.icon:SetTexture(icon)
        frame:Show()
    end

    function frame:SetFont(font, size, flags, horizontalOffset)
        if not string.find(strlower(font), ".ttf") then font = F:GetFont(font) end

        if flags == "Shadow" then
            frame.stack:SetFont(font, size, "")
            frame.stack:SetShadowOffset(1, -1)
            frame.stack:SetShadowColor(0, 0, 0, 1)
        else
            if flags == "None" then
                flags = ""
            elseif flags == "Outline" then
                flags = "OUTLINE"
            else
                flags = "OUTLINE, MONOCHROME"
            end
            frame.stack:SetFont(font, size, flags)
            frame.stack:SetShadowOffset(0, 0)
            frame.stack:SetShadowColor(0, 0, 0, 0)
        end
        frame.stack:ClearAllPoints()
        frame.stack:SetPoint("TOPRIGHT", horizontalOffset, 1)
    end

    function frame:ShowGlow(glowType, color, arg1, arg2, arg3, arg4)
        if glowType == "Normal" then
            LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
            LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
            LCG.ButtonGlow_Start(parent.widget.tsGlowFrame, color)
        elseif glowType == "Pixel" then
            LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
            LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
            -- color, N, frequency, length, thickness
            LCG.PixelGlow_Start(parent.widget.tsGlowFrame, color, arg1, arg2, arg3, arg4)
        elseif glowType == "Shine" then
            LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
            LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
            -- color, N, frequency, scale
            LCG.AutoCastGlow_Start(parent.widget.tsGlowFrame, color, arg1, arg2, arg3)
        else
            LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
            LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
            LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
        end
    end

    -- function frame:HideGlow(glowType)
    --     if glowType == "Normal" then
    --         LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
    --     elseif glowType == "Pixel" then
    --         LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
    --     elseif glowType == "Shine" then
    --         LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
    --     end
    -- end

    frame:SetScript("OnHide", function()
        LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
        LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
        LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
    end)

    function frame:ShowGlowPreview()
        frame:ShowGlow(unpack(Cell.vars.targetedSpellsGlow))
    end

    function frame:HideGlowPreview()
        LCG.ButtonGlow_Stop(parent.widget.tsGlowFrame)
        LCG.PixelGlow_Stop(parent.widget.tsGlowFrame)
        LCG.AutoCastGlow_Stop(parent.widget.tsGlowFrame)
    end
end

function I:EnableTargetedSpells(enabled)
    if enabled then
        -- UNIT_SPELLCAST_DELAYED UNIT_SPELLCAST_FAILED UNIT_SPELLCAST_FAILED_QUIET UNIT_SPELLCAST_INTERRUPTED UNIT_SPELLCAST_START UNIT_SPELLCAST_STOP
        -- UNIT_SPELLCAST_CHANNEL_START UNIT_SPELLCAST_CHANNEL_STOP UNIT_SPELLCAST_CHANNEL_UPDATE
        -- UNIT_TARGET ENCOUNTER_END

        eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
        eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")

        eventFrame:RegisterEvent("UNIT_TARGET")
        eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        eventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        
        eventFrame:RegisterEvent("ENCOUNTER_END")
    else
        eventFrame:UnregisterAllEvents()
        F:IterateAllUnitButtons(function(b)
            b.indicators.targetedSpells:Hide()
        end)
    end
end
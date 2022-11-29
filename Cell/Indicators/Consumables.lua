local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local B = Cell.bFuncs
local I = Cell.iFuncs

local orientation

-------------------------------------------------
-- events
-------------------------------------------------
-- CLEU: subevent, source, target, spellId, spellName
-- [15:10] SPELL_HEAL 秋静葉 秋静葉 6262 治疗石 
-- [15:10] SPELL_CAST_SUCCESS 秋静葉 nil 6262 治疗石
-- [15:13] SPELL_HEAL 秋静葉 秋静葉 307192 灵魂治疗药水 
-- [15:13] SPELL_CAST_SUCCESS 秋静葉 nil 307192 灵魂治疗药水 

-- UNIT_SPELLCAST_SUCCEEDED
-- unit, castGUID, spellID

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, unit, castGUID, spellID)
    -- filter out players not in your group
    if not (UnitInRaid(unit) or UnitInParty(unit) or unit == "player" or unit == "pet") then return end

    if Cell.vars.consumablesDebugModeEnabled then
        local name = GetSpellInfo(spellID)
        print("|cFFFF3030[Cell]|r |cFFB2B2B2"..event..":|r", unit, "|cFF00FF00"..(spellID or "nil").."|r", name)
    end

    if Cell.vars.consumables[spellID] then
        local b1, b2 = F:GetUnitButtonByUnit(unit)
        if b1 then b1.indicators.consumables:ShowUp(unpack(Cell.vars.consumables[spellID])) end
        if b2 then b2.indicators.consumables:ShowUp(unpack(Cell.vars.consumables[spellID])) end
    end
end)

-- local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
-- eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- eventFrame:SetScript("OnEvent", function()
--     local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
--     print(subevent, sourceName, destName, spellId, spellName)
-- end)

-------------------------------------------------
-- animations
-------------------------------------------------
--! Type A
local function CreateAnimationGroup_TypeA(parent)
    -- frame
    local f = CreateFrame("Frame", parent:GetName().."_TypeA", parent)
    f:Hide()
    
    -- texture
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints(f)
    tex:SetTexture("Interface\\Buttons\\WHITE8x8")

    tex:AddMaskTexture(parent.mask)

    -- animation
    local ag = f:CreateAnimationGroup()

    local a1 = ag:CreateAnimation("Alpha")
    a1.duration = 0.6
    a1:SetFromAlpha(0)
    a1:SetToAlpha(1)
    a1:SetOrder(1)
    a1:SetDuration(a1.duration)
    a1:SetSmoothing("OUT")

    local t1 = ag:CreateAnimation("Translation")
    t1.duration = 0.6
    t1:SetOrder(1)
    t1:SetSmoothing("OUT")
    t1:SetDuration(t1.duration)
    
    local a2 = ag:CreateAnimation("Alpha")
    a2.duration = 0.5
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetDuration(a2.duration)
    a2:SetOrder(2)
    -- a2:SetSmoothing("IN")

    ag:SetScript("OnPlay", function()
        f:Show()
    end)

    ag:SetScript("OnFinished", function()
        f:Hide()
    end)

    function ag:ShowUp(r, g, b)
        if orientation == "horizontal" then
            t1:SetOffset(parent:GetWidth(), 0)
            if Cell.isRetail then
                tex:SetGradient("HORIZONTAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 1))
            else
                tex:SetGradientAlpha("HORIZONTAL", r, g, b, 0, r, g, b, 1)
            end
        else
            t1:SetOffset(0, parent:GetHeight())
            if Cell.isRetail then
                tex:SetGradient("VERTICAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 1))
            else
                tex:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, 1)
            end
        end

        if ag:IsPlaying() then
            ag:Restart()
        else
            ag:Play()
        end
    end

    function ag:UpdateOrientation()
        if orientation == "horizontal" then
            f:ClearAllPoints()
            f:SetPoint("TOPRIGHT", parent, "TOPLEFT")
            f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT")
            f:SetWidth(15)
        else
            f:ClearAllPoints()
            f:SetPoint("TOPLEFT", parent, "BOTTOMLEFT")
            f:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT")
            f:SetHeight(15)
        end
    end

    function ag:SetSpeedMultiplier(s)
        a1:SetDuration(a1.duration/s)
        t1:SetDuration(t1.duration/s)
        a2:SetDuration(a2.duration/s)
    end

    return ag
end

--! Type B
local function CreateAnimationGroup_TypeB(parent)
    local WIDTH = 10

    -- frame
    local f = CreateFrame("Frame", parent:GetName().."_TypeB", parent)
    f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT")
    f:SetPoint("TOPRIGHT", parent, "TOPLEFT")
    f:SetWidth(WIDTH)
    f:Hide()
    
    -- texture
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("BOTTOMRIGHT")
    tex:SetWidth(WIDTH)
    if Cell.isRetail then
        tex:SetRotation(45 * math.pi / 180, CreateVector2D(1, 0))
    else
        tex:SetRotation(45 * math.pi / 180, 1, 0)
    end

    tex:AddMaskTexture(parent.mask)

    -- animation
    local ag = f:CreateAnimationGroup()

    local a1 = ag:CreateAnimation("Alpha")
    a1.duration = 0.35
    a1:SetFromAlpha(0)
    a1:SetToAlpha(0.7)
    a1:SetDuration(a1.duration)
    -- a1:SetSmoothing("IN")

    local t1 = ag:CreateAnimation("Translation")
    t1.duration = 0.7
    t1:SetSmoothing("IN_OUT")
    t1:SetDuration(t1.duration)
    
    -- local a2 = ag:CreateAnimation("Alpha")
    -- a2.duration = 0.3
    -- a2:SetFromAlpha(0.7)
    -- a2:SetToAlpha(0)
    -- a2:SetDuration(a2.duration)
    -- a2:SetStartDelay(t1.duration - a2.duration)

    ag:SetScript("OnPlay", function()
        f:Show()
    end)

    ag:SetScript("OnFinished", function()
        f:Hide()
    end)

    function ag:ShowUp(r, g, b)
        t1:SetOffset(parent:GetWidth() + math.tan(math.pi/4)*parent:GetHeight() + WIDTH/math.cos(math.pi/4), 0)
        tex:SetHeight(parent:GetHeight()/math.sin(math.pi/4) + WIDTH)
        tex:SetColorTexture(r, g, b)

        if ag:IsPlaying() then
            ag:Restart()
        else
            ag:Play()
        end
    end

    function ag:UpdateOrientation()
        -- do nothing
    end

    function ag:SetSpeedMultiplier(s)
        a1:SetDuration(a1.duration/s)
        t1:SetDuration(t1.duration/s)
        -- a2:SetDuration(a2.duration/s)
        -- a2:SetStartDelay((t1.duration-a2.duration)/s)
    end

    return ag
end

--! Type C
local function CreateAnimationGroup_TypeC(parent, subType)
    -- frame
    local f = CreateFrame("Frame", parent:GetName().."_TypeC"..subType, parent)
    f:Hide()
    if subType == 1 then
        f:SetPoint("BOTTOMLEFT")
        f:SetPoint("TOPLEFT", parent, "LEFT")
    elseif subType == 2 then
        f:SetPoint("BOTTOM")
        f:SetPoint("TOP", parent, "CENTER")
    else
        f:SetPoint("BOTTOMRIGHT")
        f:SetPoint("TOPRIGHT", parent, "RIGHT")

    end
    
    -- texture
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints(f)
    tex:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\upgrade.tga")

    -- tex:AddMaskTexture(parent.mask)

    -- animation
    local ag = f:CreateAnimationGroup()

    local a1 = ag:CreateAnimation("Alpha")
    a1.duration = 0.5
    a1:SetFromAlpha(0)
    a1:SetToAlpha(1)
    a1:SetOrder(1)
    a1:SetDuration(a1.duration)
    a1:SetSmoothing("OUT")

    local t1 = ag:CreateAnimation("Translation")
    t1.duration = 0.5
    t1:SetOrder(1)
    t1:SetSmoothing("OUT")
    t1:SetDuration(t1.duration)
    
    local a2 = ag:CreateAnimation("Alpha")
    a2.duration = 0.5
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetDuration(a2.duration)
    a2:SetOrder(2)
    a2:SetSmoothing("IN")

    ag:SetScript("OnPlay", function()
        f:Show()
    end)

    ag:SetScript("OnFinished", function()
        f:Hide()
    end)

    function ag:ShowUp(r, g, b)
        f:SetWidth(parent:GetParent():GetHeight()/2)
        t1:SetOffset(0, parent:GetHeight()/2)
        if Cell.isRetail then
            tex:SetGradient("VERTICAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 1))
        else
            tex:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, 1)
        end

        if ag:IsPlaying() then
            ag:Restart()
        else
            ag:Play()
        end
    end

    function ag:UpdateOrientation()
        -- f:SetWidth(parent:GetParent():GetHeight()/2)
    end

    function ag:SetSpeedMultiplier(s)
        a1:SetDuration(a1.duration/s)
        t1:SetDuration(t1.duration/s)
        a2:SetDuration(a2.duration/s)
    end

    return ag
end

--! Type D
local function CreateAnimationGroup_TypeD(parent)
    -- frame
    local f = CreateFrame("Frame", parent:GetName().."_TypeD", parent)
    f:SetAllPoints(parent)
    f:Hide()

    -- texture
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("CENTER")

    local mask = f:CreateMaskTexture()
    mask:SetAllPoints(tex)
    mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    tex:AddMaskTexture(mask)

    tex:AddMaskTexture(parent.mask)
    
    -- animation
    local ag = f:CreateAnimationGroup()

    local a1 = ag:CreateAnimation("Alpha")
    a1.duration = 0.5
    a1:SetFromAlpha(0)
    a1:SetToAlpha(1)
    a1:SetOrder(1)
    a1:SetDuration(a1.duration)
    a1:SetSmoothing("OUT")

    local s1 = ag:CreateAnimation("Scale")
    s1.duration = 0.5
    if Cell.isRetail then
        s1:SetScaleFrom(0,0)
        s1:SetScaleTo(1,1)
    else
        s1:SetFromScale(0,0)
        s1:SetToScale(1,1)
    end
    s1:SetOrder(1)
    s1:SetDuration(s1.duration)

    local a2 = ag:CreateAnimation("Alpha")
    a2.duration = 0.5
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetDuration(a2.duration)
    a2:SetOrder(2)
    a2:SetSmoothing("IN")

    ag:SetScript("OnPlay", function()
        f:Show()
    end)

    ag:SetScript("OnFinished", function()
        f:Hide()
    end)

    function ag:ShowUp(r, g, b)
        local l = math.sqrt((parent:GetHeight()/2)^2 + (parent:GetWidth()/2)^2) * 2
        tex:SetSize(l, l)
        tex:SetColorTexture(r, g, b, 0.5)

        if ag:IsPlaying() then
            ag:Restart()
        else
            ag:Play()
        end
    end

    function ag:UpdateOrientation()
        -- do nothing
    end

    function ag:SetSpeedMultiplier(s)
        a1:SetDuration(a1.duration/s)
        s1:SetDuration(s1.duration/s)
        a2:SetDuration(a2.duration/s)
    end

    return ag
end

--! Type E
local function CreateAnimationGroup_TypeE(parent)
    -- frame
    local f = CreateFrame("Frame", parent:GetName().."_TypeE", parent)
    f:SetPoint("TOPRIGHT", parent, "TOPLEFT")
    f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT")
    f:Hide()
    
    -- texture
    local tex = f:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints(f)
    tex:SetTexture("Interface/AddOns/Cell/Media/Icons/arrow.tga")

    tex:AddMaskTexture(parent.mask)

    -- animation
    local ag = f:CreateAnimationGroup()

    -- local a1 = ag:CreateAnimation("Alpha")
    -- a1:SetFromAlpha(0)
    -- a1:SetToAlpha(0.7)
    -- a1:SetDuration(0.3)
    -- a1:SetSmoothing("OUT")

    local t1 = ag:CreateAnimation("Translation")
    t1.duration = 0.8
    t1:SetSmoothing("IN_OUT")
    t1:SetDuration(t1.duration)
    
    -- local a2 = ag:CreateAnimation("Alpha")
    -- a2:SetFromAlpha(0.7)
    -- a2:SetToAlpha(0)
    -- a2:SetDuration(0.3)
    -- a2:SetStartDelay(0.5)
    -- a2:SetSmoothing("IN")

    ag:SetScript("OnPlay", function()
        f:Show()
    end)

    ag:SetScript("OnFinished", function()
        f:Hide()
    end)

    function ag:ShowUp(r, g, b)
        local l = parent:GetHeight()*2
        f:SetWidth(l)
        t1:SetOffset(l+parent:GetWidth(), 0)

        tex:SetVertexColor(r, g, b, 0.5)

        if ag:IsPlaying() then
            ag:Restart()
        else
            ag:Play()
        end
    end

    function ag:UpdateOrientation()
    end

    function ag:SetSpeedMultiplier(s)
        t1:SetDuration(t1.duration/s)
    end

    return ag
end

-------------------------------------------------
-- indicator
-------------------------------------------------
local previews = {}
local previewOrientation

function I:CreateConsumables(parent, isPreview)
    local consumables = CreateFrame("Frame", parent:GetName().."ConsumablesParent", parent)
    
    -- mask
    local mask = consumables:CreateMaskTexture()
    consumables.mask = mask
    mask:SetTexture("Interface/Tooltips/UI-Tooltip-Background", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(consumables)
    mask:SetSnapToPixelGrid(true)
    
    -- animation groups
    local animations = {}
    consumables.animations = animations
    animations.A = CreateAnimationGroup_TypeA(consumables)
    animations.B = CreateAnimationGroup_TypeB(consumables)
    animations.C1 = CreateAnimationGroup_TypeC(consumables, 1)
    animations.C2 = CreateAnimationGroup_TypeC(consumables, 2)
    animations.C3 = CreateAnimationGroup_TypeC(consumables, 3)
    animations.D = CreateAnimationGroup_TypeD(consumables)
    animations.E = CreateAnimationGroup_TypeE(consumables)

    if isPreview then
        parent.consumables = consumables
        tinsert(previews, parent)
        consumables:SetPoint("TOPLEFT", 1, -1)
        consumables:SetPoint("BOTTOMRIGHT", -1, 1)
        for _, a in pairs(animations) do
            a:UpdateOrientation()
        end
    else
        parent.indicators.consumables = consumables
        consumables:SetFrameLevel(parent.widget.healthBar:GetFrameLevel()+1)
        consumables:SetAllPoints(parent.widget.healthBar)
    end

    -- speed
    function consumables:SetSpeed(speed)
        for _, a in pairs(animations) do
            a:SetSpeedMultiplier(speed)
        end
    end

    -- show
    function consumables:ShowUp(animationType, color)
        animations[animationType]:ShowUp(unpack(color))
    end
end

function I:UpdateConsumablesOrientation(parent, barOrientation)
    orientation = barOrientation
    for _, a in pairs(parent.indicators.consumables.animations) do
        a:UpdateOrientation()
    end

    if previewOrientation ~= barOrientation then
        previewOrientation = barOrientation
        for _, p in pairs(previews) do
            for _, a in pairs(p.consumables.animations) do
                a:UpdateOrientation()
            end
        end
    end
end

function I:EnableConsumables(enabled)
    if enabled then
        eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    else
        eventFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    end
end
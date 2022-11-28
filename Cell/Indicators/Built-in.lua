local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs
local LCG = LibStub("LibCustomGlow-1.0")
local P = Cell.pixelPerfectFuncs

-------------------------------------------------
-- CreateDefensiveCooldowns
-------------------------------------------------
function I:CreateDefensiveCooldowns(parent)
    local defensiveCooldowns = CreateFrame("Frame", parent:GetName().."DefensiveCooldownParent", parent.widget.overlayFrame)
    parent.indicators.defensiveCooldowns = defensiveCooldowns
    -- defensiveCooldowns:SetSize(20, 10)
    defensiveCooldowns:Hide()

    defensiveCooldowns.OriginalSetSize = defensiveCooldowns.SetSize

    function defensiveCooldowns:SetSize(width, height)
        -- defensiveCooldowns:OriginalSetSize(width, height)
        defensiveCooldowns.width = width
        defensiveCooldowns.height = height

        for i = 1, 5 do
            defensiveCooldowns[i]:SetSize(width, height)
        end

        defensiveCooldowns:UpdateSize()
    end

    function defensiveCooldowns:UpdateSize(iconsShown)
        if not (defensiveCooldowns.width and defensiveCooldowns.height and defensiveCooldowns.orientation) then return end -- not init
        if iconsShown then -- call from I:UnitButton_UpdateBuffs or preview
            if defensiveCooldowns.orientation == "horizontal" then
                defensiveCooldowns:OriginalSetSize(defensiveCooldowns.width*iconsShown-P:Scale(iconsShown-1), defensiveCooldowns.height)
            else
                defensiveCooldowns:OriginalSetSize(defensiveCooldowns.width, defensiveCooldowns.height*iconsShown-P:Scale(iconsShown-1))
            end
        else
            for i = 1, 5 do
                if defensiveCooldowns[i]:IsShown() then
                    if defensiveCooldowns.orientation == "horizontal" then
                        defensiveCooldowns:OriginalSetSize(defensiveCooldowns.width*i-P:Scale(i-1), defensiveCooldowns.height)
                    else
                        defensiveCooldowns:OriginalSetSize(defensiveCooldowns.width, defensiveCooldowns.height*i-P:Scale(i-1))
                    end
                end
            end
        end
    end

    function defensiveCooldowns:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, 5 do
            defensiveCooldowns[i]:SetFont(font, ...)
        end
    end

    function defensiveCooldowns:SetOrientation(orientation)
        local point1, point2, x, y
        if orientation == "left-to-right" then
            point1 = "TOPLEFT"
            point2 = "TOPRIGHT"
            defensiveCooldowns.orientation = "horizontal"
            x = -1
            y = 0
        elseif orientation == "right-to-left" then
            point1 = "TOPRIGHT"
            point2 = "TOPLEFT"
            defensiveCooldowns.orientation = "horizontal"
            x = 1
            y = 0
        elseif orientation == "top-to-bottom" then
            point1 = "TOPLEFT"
            point2 = "BOTTOMLEFT"
            defensiveCooldowns.orientation = "vertical"
            x = 0
            y = 1
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOMLEFT"
            point2 = "TOPLEFT"
            defensiveCooldowns.orientation = "vertical"
            x = 0
            y = -1
        end
        
        for i = 1, 5 do
            P:ClearPoints(defensiveCooldowns[i])
            if i == 1 then
                P:Point(defensiveCooldowns[i], point1)
            else
                P:Point(defensiveCooldowns[i], point1, defensiveCooldowns[i-1], point2, x, y)
            end
        end

        defensiveCooldowns:UpdateSize()
    end

    for i = 1, 5 do
        local name = parent:GetName().."DefensiveCooldown"..i
        local frame = I:CreateAura_BarIcon(name, defensiveCooldowns)
        tinsert(defensiveCooldowns, frame)

        -- if i == 1 then
        --     P:Point(frame, "TOPLEFT")
        -- else
        --     P:Point(frame, "LEFT", defensiveCooldowns[i-1], "RIGHT", -1, 0)
        -- end
    end

    function defensiveCooldowns:ShowDuration(show)
        for i = 1, 5 do
            defensiveCooldowns[i]:ShowDuration(show)
        end
    end

    function defensiveCooldowns:UpdatePixelPerfect()
        -- P:Resize(defensiveCooldowns)
        P:Repoint(defensiveCooldowns)
        for i = 1, 5 do
            defensiveCooldowns[i]:UpdatePixelPerfect()
        end
    end
end

-------------------------------------------------
-- CreateExternalCooldowns
-------------------------------------------------
function I:CreateExternalCooldowns(parent)
    local externalCooldowns = CreateFrame("Frame", parent:GetName().."ExternalCooldownParent", parent.widget.overlayFrame)
    parent.indicators.externalCooldowns = externalCooldowns
    externalCooldowns:Hide()

    externalCooldowns.OriginalSetSize = externalCooldowns.SetSize

    function externalCooldowns:SetSize(width, height)
        -- externalCooldowns:OriginalSetSize(width, height)
        externalCooldowns.width = width
        externalCooldowns.height = height

        for i = 1, 5 do
            externalCooldowns[i]:SetSize(width, height)
        end

        externalCooldowns:UpdateSize()
    end

    function externalCooldowns:UpdateSize(iconsShown)
        if not (externalCooldowns.width and externalCooldowns.height and externalCooldowns.orientation) then return end -- not init
        if iconsShown then -- call from I:UnitButton_UpdateBuffs or preview
            if externalCooldowns.orientation == "horizontal" then
                externalCooldowns:OriginalSetSize(externalCooldowns.width*iconsShown-P:Scale(iconsShown-1), externalCooldowns.height)
            else
                externalCooldowns:OriginalSetSize(externalCooldowns.width, externalCooldowns.height*iconsShown-P:Scale(iconsShown-1))
            end
        else
            for i = 1, 5 do
                if externalCooldowns[i]:IsShown() then
                    if externalCooldowns.orientation == "horizontal" then
                        externalCooldowns:OriginalSetSize(externalCooldowns.width*i-P:Scale(i-1), externalCooldowns.height)
                    else
                        externalCooldowns:OriginalSetSize(externalCooldowns.width, externalCooldowns.height*i-P:Scale(i-1))
                    end
                end
            end
        end
    end

    function externalCooldowns:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, 5 do
            externalCooldowns[i]:SetFont(font, ...)
        end
    end

    function externalCooldowns:SetOrientation(orientation)
        local point1, point2, x, y
        if orientation == "left-to-right" then
            point1 = "TOPLEFT"
            point2 = "TOPRIGHT"
            externalCooldowns.orientation = "horizontal"
            x = -1
            y = 0
        elseif orientation == "right-to-left" then
            point1 = "TOPRIGHT"
            point2 = "TOPLEFT"
            externalCooldowns.orientation = "horizontal"
            x = 1
            y = 0
        elseif orientation == "top-to-bottom" then
            point1 = "TOPLEFT"
            point2 = "BOTTOMLEFT"
            externalCooldowns.orientation = "vertical"
            x = 0
            y = 1
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOMLEFT"
            point2 = "TOPLEFT"
            externalCooldowns.orientation = "vertical"
            x = 0
            y = -1
        end
        
        for i = 1, 5 do
            P:ClearPoints(externalCooldowns[i])
            if i == 1 then
                P:Point(externalCooldowns[i], point1)
            else
                P:Point(externalCooldowns[i], point1, externalCooldowns[i-1], point2, x, y)
            end
        end

        externalCooldowns:UpdateSize()
    end

    for i = 1, 5 do
        local name = parent:GetName().."ExternalCooldown"..i
        local frame = I:CreateAura_BarIcon(name, externalCooldowns)
        tinsert(externalCooldowns, frame)
    end

    function externalCooldowns:ShowDuration(show)
        for i = 1, 5 do
            externalCooldowns[i]:ShowDuration(show)
        end
    end

    function externalCooldowns:UpdatePixelPerfect()
        -- P:Resize(externalCooldowns)
        P:Repoint(externalCooldowns)
        for i = 1, 5 do
            externalCooldowns[i]:UpdatePixelPerfect()
        end
    end
end

-------------------------------------------------
-- CreateAllCooldowns
-------------------------------------------------
function I:CreateAllCooldowns(parent)
    local allCooldowns = CreateFrame("Frame", parent:GetName().."AllCooldownParent", parent.widget.overlayFrame)
    parent.indicators.allCooldowns = allCooldowns
    allCooldowns:Hide()

    allCooldowns.OriginalSetSize = allCooldowns.SetSize

    function allCooldowns:SetSize(width, height)
        -- allCooldowns:OriginalSetSize(width, height)
        allCooldowns.width = width
        allCooldowns.height = height

        for i = 1, 5 do
            allCooldowns[i]:SetSize(width, height)
        end

        allCooldowns:UpdateSize()
    end

    function allCooldowns:UpdateSize(iconsShown)
        if not (allCooldowns.width and allCooldowns.height and allCooldowns.orientation) then return end -- not init
        if iconsShown then -- call from I:UnitButton_UpdateBuffs or preview
            if allCooldowns.orientation == "horizontal" then
                allCooldowns:OriginalSetSize(allCooldowns.width*iconsShown-P:Scale(iconsShown-1), allCooldowns.height)
            else
                allCooldowns:OriginalSetSize(allCooldowns.width, allCooldowns.height*iconsShown-P:Scale(iconsShown-1))
            end
        else
            for i = 1, 5 do
                if allCooldowns[i]:IsShown() then
                    if allCooldowns.orientation == "horizontal" then
                        allCooldowns:OriginalSetSize(allCooldowns.width*i-P:Scale(i-1), allCooldowns.height)
                    else
                        allCooldowns:OriginalSetSize(allCooldowns.width, allCooldowns.height*i-P:Scale(i-1))
                    end
                end
            end
        end
    end

    function allCooldowns:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, 5 do
            allCooldowns[i]:SetFont(font, ...)
        end
    end

    function allCooldowns:SetOrientation(orientation)
        local point1, point2, x, y
        if orientation == "left-to-right" then
            point1 = "TOPLEFT"
            point2 = "TOPRIGHT"
            allCooldowns.orientation = "horizontal"
            x = -1
            y = 0
        elseif orientation == "right-to-left" then
            point1 = "TOPRIGHT"
            point2 = "TOPLEFT"
            allCooldowns.orientation = "horizontal"
            x = 1
            y = 0
        elseif orientation == "top-to-bottom" then
            point1 = "TOPLEFT"
            point2 = "BOTTOMLEFT"
            allCooldowns.orientation = "vertical"
            x = 0
            y = 1
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOMLEFT"
            point2 = "TOPLEFT"
            allCooldowns.orientation = "vertical"
            x = 0
            y = -1
        end
        
        for i = 1, 5 do
            P:ClearPoints(allCooldowns[i])
            if i == 1 then
                P:Point(allCooldowns[i], point1)
            else
                P:Point(allCooldowns[i], point1, allCooldowns[i-1], point2, x, y)
            end
        end

        allCooldowns:UpdateSize()
    end

    for i = 1, 5 do
        local name = parent:GetName().."ExternalCooldown"..i
        local frame = I:CreateAura_BarIcon(name, allCooldowns)
        tinsert(allCooldowns, frame)
    end

    function allCooldowns:ShowDuration(show)
        for i = 1, 5 do
            allCooldowns[i]:ShowDuration(show)
        end
    end

    function allCooldowns:UpdatePixelPerfect()
        -- P:Resize(allCooldowns)
        P:Repoint(allCooldowns)
        for i = 1, 5 do
            allCooldowns[i]:UpdatePixelPerfect()
        end
    end
end

-------------------------------------------------
-- CreateTankActiveMitigation
-------------------------------------------------
function I:CreateTankActiveMitigation(parent)
    local bar = Cell:CreateStatusBar(parent:GetName().."TanckActiveMitigation", parent.widget.overlayFrame, 18, 4, 100)
    parent.indicators.tankActiveMitigation = bar
    bar:Hide()
    
    bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    bar:GetStatusBarTexture():SetAlpha(0)
    bar:SetReverseFill(true)

    local tex = bar:CreateTexture(nil, "ARTWORK")
    tex:SetColorTexture(0.7, 0.7, 0.7)
    tex:SetPoint("TOPLEFT")
    tex:SetPoint("BOTTOMRIGHT", bar:GetStatusBarTexture(), "BOTTOMLEFT")

    local elapsedTime = 0
    bar:SetScript("OnUpdate", function(self, elapsed)
        if elapsedTime >= 0.1 then
            bar:SetValue(bar:GetValue() + elapsedTime)
            elapsedTime = 0
        end
        elapsedTime = elapsedTime + elapsed
    end)

    function bar:SetCooldown(start, duration)
        if not parent.state.class then parent.state.class = select(2, UnitClass(parent.state.unit)) end --? why sometimes parent.state.class == nil ???
        tex:SetColorTexture(F:GetClassColor(parent.state.class))
        bar:SetMinMaxValues(0, duration)
        bar:SetValue(GetTime()-start)
        bar:Show()
    end
end

-------------------------------------------------
-- CreateDebuffs
-------------------------------------------------
function I:CreateDebuffs(parent)
    local debuffs = CreateFrame("Frame", parent:GetName().."DebuffParent", parent.widget.overlayFrame)
    parent.indicators.debuffs = debuffs
    -- debuffs:SetSize(11, 11)
    debuffs:Hide()

    debuffs.OriginalSetSize = debuffs.SetSize
    function debuffs:SetSize(normalSize, bigSize)
        for i = 1, 10 do
            P:Size(debuffs[i], normalSize[1], normalSize[2])
        end
        -- store sizes for SetCooldown
        debuffs.normalSize = normalSize
        debuffs.bigSize = bigSize
        -- remove wrong data from PixelPerfect
        debuffs.width = nil
        debuffs.height = nil

        debuffs:UpdateSize()
    end

    function debuffs:UpdateSize()
        if not (debuffs.normalSize and debuffs.bigSize and debuffs.orientation) then return end -- not init

        local size = 0
        for i = 1, 10 do
            if debuffs[i]:IsShown() then
                size = size + debuffs[i].width
            end
        end
        if debuffs.orientation == "left-to-right" or debuffs.orientation == "right-to-left"  then
            debuffs:OriginalSetSize(P:Scale(size), P:Scale(debuffs.normalSize[2]))
        else
            debuffs:OriginalSetSize(P:Scale(debuffs.normalSize[1]), P:Scale(size))
        end
    end

    function debuffs:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, 10 do
            debuffs[i]:SetFont(font, ...)
        end
    end

    debuffs.hAlignment = ""
    debuffs.vAlignment = ""
    debuffs.OriginalSetPoint = debuffs.SetPoint
    function debuffs:SetPoint(point, relativeTo, relativePoint, x, y)
        debuffs:OriginalSetPoint(point, relativeTo, relativePoint, x, y)

        if string.find(point, "LEFT$") then
            debuffs.hAlignment = "LEFT"
        elseif string.find(point, "RIGHT$") then
            debuffs.hAlignment = "RIGHT"
        else
            debuffs.hAlignment = ""
        end

        if string.find(point, "^TOP") then
            debuffs.vAlignment = "TOP"
        elseif string.find(point, "^BOTTOM") then
            debuffs.vAlignment = "BOTTOM"
        else
            debuffs.vAlignment = ""
        end

        if debuffs.hAlignment == "" and debuffs.vAlignment == "" then
            debuffs.vAlignment = "CENTER"
        end

        -- debuffs[1]:ClearAllPoints()
        -- debuffs[1]:SetPoint(debuffs.vAlignment..debuffs.hAlignment)
        -- --! update icons
        debuffs:SetOrientation(debuffs.orientation or "left-to-right")
    end

    --! NOTE: SetPoint must be invoked before SetOrientation
    function debuffs:SetOrientation(orientation)
        debuffs.orientation = orientation
        local point1, point2, v, h
        v = debuffs.vAlignment == "CENTER" and "" or debuffs.vAlignment
        h = debuffs.hAlignment
        if orientation == "left-to-right" then
            point1 = v.."LEFT"
            point2 = v.."RIGHT"
        elseif orientation == "right-to-left" then
            point1 = v.."RIGHT"
            point2 = v.."LEFT"
        elseif orientation == "top-to-bottom" then
            point1 = "TOP"..h
            point2 = "BOTTOM"..h
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOM"..h
            point2 = "TOP"..h
        end
        
        for i = 1, 10 do
            P:ClearPoints(debuffs[i])
            if i == 1 then
                P:Point(debuffs[i], point1)
            else
                P:Point(debuffs[i], point1, debuffs[i-1], point2)
            end
        end

        debuffs:UpdateSize()
    end

    for i = 1, 10 do
        local name = parent:GetName().."Debuff"..i
        local frame = I:CreateAura_BarIcon(name, debuffs)
        tinsert(debuffs, frame)

        frame.OriginalSetCooldown = frame.SetCooldown
        function frame:SetCooldown(start, duration, debuffType, texture, count, refreshing, isBigDebuff)
            frame:OriginalSetCooldown(start, duration, debuffType, texture, count, refreshing)
            if isBigDebuff then
                P:Size(frame, debuffs.bigSize[1], debuffs.bigSize[2])
            else
                P:Size(frame, debuffs.normalSize[1], debuffs.normalSize[2])
            end
        end
    end

    function debuffs:ShowDuration(show)
        for i = 1, 10 do
            debuffs[i]:ShowDuration(show)
        end
    end

    function debuffs:ShowTooltip(show)
        for i = 1, 10 do
            if show then
                debuffs[i]:SetScript("OnEnter", function()
                    F:ShowTooltips(parent, "spell", parent.state.displayedUnit, debuffs[i].index, "HARMFUL")
                end)
                debuffs[i]:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            else
                debuffs[i]:SetScript("OnEnter", nil)
                debuffs[i]:SetScript("OnLeave", nil)
                debuffs[i]:EnableMouse(false)
            end
        end
    end

    function debuffs:UpdatePixelPerfect()
        P:Repoint(debuffs)
        for i = 1, 10 do
            debuffs[i]:UpdatePixelPerfect()
        end
    end
end

-------------------------------------------------
-- CreateDispels
-------------------------------------------------
function I:CreateDispels(parent)
    local dispels = CreateFrame("Frame", parent:GetName().."DispelParent", parent.widget.overlayFrame)
    parent.indicators.dispels = dispels
    dispels:Hide()

    dispels.highlight = parent.widget.healthBar:CreateTexture(parent:GetName().."DispelHighlight", "OVERLAY")
    -- dispels.highlight:SetAllPoints(parent.widget.healthBar)
    -- dispels.highlight:SetPoint("BOTTOMLEFT", parent.widget.healthBar)
    -- dispels.highlight:SetPoint("BOTTOMRIGHT", parent.widget.healthBar)
    -- dispels.highlight:SetPoint("TOP", parent.widget.healthBar)
    -- dispels.highlight:SetTexture("Interface\\Buttons\\WHITE8x8")
    -- dispels.highlight:SetVertexColor(0, 0, 0, 0)
    dispels.highlight:Hide()

    dispels.OriginalSetSize = dispels.SetSize

    function dispels:SetSize(width, height)
        dispels:OriginalSetSize(width, height)
        for i = 1, 4 do
            dispels[i]:SetSize(width, height)
        end
    end

    function dispels:SetDispels(dispelTypes)
        local r, g, b, a = 0, 0, 0, 0

        local i = 1
        for dispelType, _ in pairs(dispelTypes) do
            if a == 0 and dispelType then
                r, g, b, a = DebuffTypeColor[dispelType].r, DebuffTypeColor[dispelType].g, DebuffTypeColor[dispelType].b, 1
            end
            if dispels.showIcons then
                dispels[i]:SetDispel(dispelType)
                i = i + 1
            end
        end

        -- hide unused
        for j = i, 4 do
            dispels[j]:Hide()
        end

        -- highlight
        if dispels.highlightType == "entire" then
            dispels.highlight:SetVertexColor(r, g, b, a ~= 0 and 0.5 or 0)
        elseif dispels.highlightType == "current" then
            dispels.highlight:SetVertexColor(r, g, b, a)
        else
            if Cell.isRetail then
                dispels.highlight:SetGradient("VERTICAL", CreateColor(r, g, b, a), CreateColor(r, g, b, 0))
            else
                dispels.highlight:SetGradientAlpha("VERTICAL", r, g, b, a, r, g, b, 0)
            end
        end
    end

    function dispels:UpdateHighlight(highlightType)
        dispels.highlightType = highlightType

        if highlightType == "none" then
            dispels.highlight:Hide()
        elseif highlightType == "gradient" then
            dispels.highlight:ClearAllPoints()
            dispels.highlight:SetAllPoints(parent.widget.healthBar)
            dispels.highlight:SetTexture("Interface\\Buttons\\WHITE8x8")
            dispels.highlight:Show()
        elseif highlightType == "entire" then
            dispels.highlight:ClearAllPoints()
            dispels.highlight:SetAllPoints(parent.widget.healthBar)
            dispels.highlight:SetTexture("Interface\\Buttons\\WHITE8x8")
            dispels.highlight:Show()
        elseif highlightType == "current" then
            dispels.highlight:ClearAllPoints()
            dispels.highlight:SetAllPoints(parent.widget.healthBar:GetStatusBarTexture())
            dispels.highlight:SetTexture(Cell.vars.texture)
            dispels.highlight:Show()
        end
    end

    function dispels:ShowIcons(show)
        dispels.showIcons = show
    end

    for i = 1, 4 do
        local icon = dispels:CreateTexture(parent:GetName().."Dispel"..i, "ARTWORK")
        tinsert(dispels, icon)
        icon:Hide()

        if i == 1 then
            icon:SetPoint("TOPLEFT")
        else
            icon:SetPoint("RIGHT", dispels[i-1], "LEFT", 7, 0)
        end

        icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        icon:SetDrawLayer("ARTWORK", i)

        function icon:SetDispel(dispelType)
            icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff"..dispelType)
            icon:Show()
        end
    end
end

-------------------------------------------------
-- CreateRaidDebuffs
-------------------------------------------------
local currentAreaDebuffs = {}
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function UpdateDebuffsForCurrentZone(instanceName)
    wipe(currentAreaDebuffs)
    local iName = F:GetInstanceName()
    if iName == "" then return end
    
    if iName == instanceName or instanceName == nil then
        currentAreaDebuffs = F:GetDebuffList(iName)
        F:Debug("|cffff77AARaidDebuffsChanged:|r", iName)
    end
end
Cell:RegisterCallback("RaidDebuffsChanged", "UpdateDebuffsForCurrentZone", UpdateDebuffsForCurrentZone)
eventFrame:SetScript("OnEvent", function()
    UpdateDebuffsForCurrentZone()
end)

local function CheckCondition(operator, checkedValue, currentValue)
    if operator == "=" then
        if currentValue == checkedValue then return true end
    elseif operator == ">" then
        if currentValue > checkedValue then return true end
    elseif operator == ">=" then
        if currentValue >= checkedValue then return true end
    elseif operator == "<" then
        if currentValue < checkedValue then return true end
    elseif operator == "<=" then
        if currentValue <= checkedValue then return true end
    else -- ~=
        if currentValue ~= checkedValue then return true end
    end
end

function I:GetDebuffOrder(spellName, spellId, count)
    local t = currentAreaDebuffs[spellId] or currentAreaDebuffs[spellName]
    if not t then return end

    -- check condition
    local show
    if t["condition"][1] == "Stack" then
        show = CheckCondition(t["condition"][2], t["condition"][3], count)
    else -- no condition
        show = true
    end

    if show then return t["order"] end
end

function I:GetDebuffGlow(spellName, spellId, count)
    local t = currentAreaDebuffs[spellId] or currentAreaDebuffs[spellName]
    if not t then return end

    local showGlow
    if t["glowCondition"] then
        if t["glowCondition"][1] == "Stack" then
            showGlow = CheckCondition(t["glowCondition"][2], t["glowCondition"][3], count)
        end
    else
        showGlow = true
    end

    if showGlow then
        return t["glowType"], t["glowOptions"]
    else
        return "None", nil
    end
end

function I:CreateRaidDebuffs(parent)
    local raidDebuffs = CreateFrame("Frame", parent:GetName().."RaidDebuffParent", parent.widget.overlayFrame)
    parent.indicators.raidDebuffs = raidDebuffs
    raidDebuffs:Hide()

    function raidDebuffs:ShowGlow(glowType, glowOptions, noHiding)
        if glowType == "Normal" then
            if not noHiding then
                LCG.PixelGlow_Stop(parent)
                LCG.AutoCastGlow_Stop(parent)
            end
            LCG.ButtonGlow_Start(parent, glowOptions[1])
        elseif glowType == "Pixel" then
            if not noHiding then
                LCG.ButtonGlow_Stop(parent)
                LCG.AutoCastGlow_Stop(parent)
            end
            -- color, N, frequency, length, thickness
            LCG.PixelGlow_Start(parent, glowOptions[1], glowOptions[2], glowOptions[3], glowOptions[4], glowOptions[5])
        elseif glowType == "Shine" then
            if not noHiding then
                LCG.ButtonGlow_Stop(parent)
                LCG.PixelGlow_Stop(parent)
            end
            -- color, N, frequency, scale
            LCG.AutoCastGlow_Start(parent, glowOptions[1], glowOptions[2], glowOptions[3], glowOptions[4])
        else
            LCG.ButtonGlow_Stop(parent)
            LCG.PixelGlow_Stop(parent)
            LCG.AutoCastGlow_Stop(parent)
        end
    end

    function raidDebuffs:HideGlow(glowType)
        if glowType == "Normal" then
            LCG.ButtonGlow_Stop(parent)
        elseif glowType == "Pixel" then
            LCG.PixelGlow_Stop(parent)
        elseif glowType == "Shine" then
            LCG.AutoCastGlow_Stop(parent)
        end
    end

    raidDebuffs:SetScript("OnHide", function()
        LCG.ButtonGlow_Stop(parent)
        LCG.PixelGlow_Stop(parent)
        LCG.AutoCastGlow_Stop(parent)
    end)

    function raidDebuffs:SetBorder(border)
        for i = 1, 3 do
            raidDebuffs[i]:SetBorder(border)
        end
    end

    -- update parent size to make position right
    function raidDebuffs:UpdateSize(iconsShown)
        if not (raidDebuffs.orientation and raidDebuffs.width and raidDebuffs.height) then return end
        
        local width, height = raidDebuffs.width, raidDebuffs.height
        if iconsShown then -- call from UnitButton_UpdateDebuffs or preview
            if raidDebuffs.orientation == "horizontal"  then
                width = raidDebuffs.width * iconsShown + P:Scale(iconsShown - 1) 
                height = raidDebuffs.height
            else
                width = raidDebuffs.width
                height = raidDebuffs.height * iconsShown + P:Scale(iconsShown - 1)
            end
        else
            for i = 1, 3 do
                if raidDebuffs[i]:IsShown() then
                    if raidDebuffs.orientation == "horizontal"  then
                        width = raidDebuffs.width * i + P:Scale(i - 1) 
                        height = raidDebuffs.height
                    else
                        width = raidDebuffs.width
                        height = raidDebuffs.height * i + P:Scale(i - 1)
                    end
                end
            end
        end

        raidDebuffs:OriginalSetSize(width, height)
    end

    raidDebuffs.OriginalSetSize = raidDebuffs.SetSize
    function raidDebuffs:SetSize(width, height)
        raidDebuffs.width = width
        raidDebuffs.height = height
        
        for i = 1, 3 do
            raidDebuffs[i]:SetSize(width, height)
        end

        raidDebuffs:UpdateSize()
    end

    function raidDebuffs:SetOrientation(orientation)
        local point1, point2, xOff, yOff

        if orientation == "left-to-right" then
            point1 = "TOPLEFT"
            point2 = "TOPRIGHT"
            raidDebuffs.orientation = "horizontal"
            xOff = 1
            yOff = 0
        elseif orientation == "right-to-left" then
            point1 = "TOPRIGHT"
            point2 = "TOPLEFT"
            raidDebuffs.orientation = "horizontal"
            xOff = -1
            yOff = 0
        elseif orientation == "top-to-bottom" then
            point1 = "TOPLEFT"
            point2 = "BOTTOMLEFT"
            raidDebuffs.orientation = "vertical"
            xOff = 0
            yOff = -1
        elseif orientation == "bottom-to-top" then
            point1 = "BOTTOMLEFT"
            point2 = "TOPLEFT"
            raidDebuffs.orientation = "vertical"
            xOff = 0
            yOff = 1
        end
        
        for i = 1, 3 do
            P:ClearPoints(raidDebuffs[i])
            if i == 1 then
                P:Point(raidDebuffs[i], point1)
            else
                P:Point(raidDebuffs[i], point1, raidDebuffs[i-1], point2, xOff, yOff)
            end
        end

        raidDebuffs:UpdateSize()
    end

    function raidDebuffs:SetFont(font, ...)
        font = F:GetFont(font)
        for i = 1, 3 do
            raidDebuffs[i]:SetFont(font, ...)
        end
    end

    function raidDebuffs:ShowTooltip(show)
        for i = 1, 3 do
            if show then
                raidDebuffs[i]:SetScript("OnEnter", function()
                    F:ShowTooltips(parent, "spell", parent.state.displayedUnit, raidDebuffs[i].index, "HARMFUL")
                end)
                raidDebuffs[i]:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            else
                raidDebuffs[i]:SetScript("OnEnter", nil)
                raidDebuffs[i]:SetScript("OnLeave", nil)
                raidDebuffs[i]:EnableMouse(false)
            end
        end
    end

    for i = 1, 3 do
        local frame = I:CreateAura_BorderIcon(parent:GetName().."RaidDebuff"..i, raidDebuffs, 2)
        tinsert(raidDebuffs, frame)
        frame:SetScript("OnShow", raidDebuffs.UpdateSize)
        frame:SetScript("OnHide", raidDebuffs.UpdateSize)
    end

    function raidDebuffs:UpdatePixelPerfect()
        P:Repoint(raidDebuffs)
        for i = 1, 3 do
            raidDebuffs[i]:UpdatePixelPerfect()
        end
    end
end

-------------------------------------------------
-- player raid icon
-------------------------------------------------
function I:CreatePlayerRaidIcon(parent)
    -- local playerRaidIcon = parent.widget.overlayFrame:CreateTexture(parent:GetName().."PlayerRaidIcon", "ARTWORK", nil, -7)
    -- parent.indicators.playerRaidIcon = playerRaidIcon
    -- playerRaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    local playerRaidIcon = CreateFrame("Frame", parent:GetName().."PlayerRaidIcon", parent.widget.overlayFrame)
    parent.indicators.playerRaidIcon = playerRaidIcon
    playerRaidIcon.tex = playerRaidIcon:CreateTexture(nil, "ARTWORK")
    playerRaidIcon.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    playerRaidIcon.tex:SetAllPoints(playerRaidIcon)
    playerRaidIcon:Hide()
end

-------------------------------------------------
-- target raid icon
-------------------------------------------------
function I:CreateTargetRaidIcon(parent)
    local targetRaidIcon = CreateFrame("Frame", parent:GetName().."TargetRaidIcon", parent.widget.overlayFrame)
    parent.indicators.targetRaidIcon = targetRaidIcon
    targetRaidIcon.tex = targetRaidIcon:CreateTexture(nil, "ARTWORK")
    targetRaidIcon.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
    targetRaidIcon.tex:SetAllPoints(targetRaidIcon)
    targetRaidIcon:Hide()
end

-------------------------------------------------
-- name text
-------------------------------------------------
local font_name = CreateFont("CELL_FONT_NAME")
font_name:SetFont(GameFontNormal:GetFont(), 13, "")

local font_status = CreateFont("CELL_FONT_STATUS")
font_status:SetFont(GameFontNormal:GetFont(), 11, "")

function I:CreateNameText(parent)
    local nameText = CreateFrame("Frame", parent:GetName().."NameText", parent.widget.overlayFrame)
    parent.indicators.nameText = nameText
    nameText:Hide()

    nameText.name = nameText:CreateFontString(parent:GetName().."NameText_Name", "OVERLAY", "CELL_FONT_NAME")
    
    nameText.vehicle = nameText:CreateFontString(parent:GetName().."NameText_Vehicle", "OVERLAY", "CELL_FONT_STATUS")
    nameText.vehicle:SetTextColor(0.8, 0.8, 0.8, 1)
    nameText.vehicle:Hide()

    nameText:SetScript("OnShow", function()
        if nameText.vehicleEnabled then
            nameText.vehicle:Show()
        end
    end)
    nameText:SetScript("OnHide", function()
        nameText.vehicle:Hide()
    end)

    function nameText:SetFont(font, size, flags)
        if not string.find(strlower(font), ".ttf") then font = F:GetFont(font) end

        if flags == "Shadow" then
            nameText.name:SetFont(font, size, "")
            nameText.name:SetShadowOffset(1, -1)
            nameText.name:SetShadowColor(0, 0, 0, 1)
            nameText.vehicle:SetFont(font, size-2, "")
            nameText.vehicle:SetShadowOffset(1, -1)
            nameText.vehicle:SetShadowColor(0, 0, 0, 1)
        else
            if flags == "None" then
                flags = ""
            elseif flags == "Outline" then
                flags = "OUTLINE"
            else
                flags = "OUTLINE, MONOCHROME"
            end
            nameText.name:SetFont(font, size, flags)
            nameText.name:SetShadowOffset(0, 0)
            nameText.name:SetShadowColor(0, 0, 0, 0)
            nameText.vehicle:SetFont(font, size-2, flags)
            nameText.vehicle:SetShadowOffset(0, 0)
            nameText.vehicle:SetShadowColor(0, 0, 0, 0)
        end
        nameText:UpdateName()
        if parent.state.inVehicle or nameText.isPreview then
            nameText:UpdateVehicleName()
        end
    end

    nameText.OriginalSetPoint = nameText.SetPoint
    function nameText:SetPoint(point, relativeTo, relativePoint, x, y)
        -- override relativeTo
        nameText:OriginalSetPoint(point, parent.widget.healthBar, relativePoint, x, y)

        -- update name
        nameText.name:ClearAllPoints()
        nameText.name:SetPoint(point)

        -- update vehicle
        local vp, _, vrp, _, vy = nameText.vehicle:GetPoint(1)
        if vp and vrp and vy then
            if string.find(vp, "TOP") then
                vp, vrp = "TOP", "BOTTOM"
            else -- BOTTOM
                vp, vrp = "BOTTOM", "TOP"
            end

            nameText.vehicle:ClearAllPoints()
            if string.find(point, "LEFT") then
                nameText.vehicle:SetPoint(vp.."LEFT", nameText.name, vrp.."LEFT", 0, vy)
            elseif string.find(point, "RIGHT") then
                nameText.vehicle:SetPoint(vp.."RIGHT", nameText.name, vrp.."RIGHT", 0, vy)
            else -- "CENTER"
                nameText.vehicle:SetPoint(vp, nameText.name, vrp, 0, vy)
            end
        end
    end

    function nameText:UpdateName()
        local name

        -- patron rainbow
        if nameText.name.rainbow then
            nameText.name.updater:SetScript("OnUpdate", nil)
            if nameText.name.timer then
                nameText.name.timer:Cancel()
                nameText.name.timer = nil
            end
        end
        
        -- only check nickname for players
        if parent.state.isPlayer then
            if Cell.vars.nicknameCustomEnabled then
                name = Cell.vars.nicknameCustoms[parent.state.fullName] or Cell.vars.nicknameCustoms[parent.state.name] or Cell.vars.nicknames[parent.state.fullName] or Cell.vars.nicknames[parent.state.name] or parent.state.name
            else
                name = Cell.vars.nicknames[parent.state.fullName] or Cell.vars.nicknames[parent.state.name] or parent.state.name
            end
        else
            name = parent.state.name
        end

        F:UpdateTextWidth(nameText.name, name, nameText.width, parent.widget.healthBar)

        if nameText.name:GetText() then
            if nameText.isPreview then
                if nameText.showGroupNumber then
                    nameText.name:SetText("|cffbbbbbb7-|r"..nameText.name:GetText())
                end
            else
                if IsInRaid() and nameText.showGroupNumber then
                    local raidIndex = UnitInRaid(parent.state.unit)
                    if raidIndex then
                        local subgroup = select(3, GetRaidRosterInfo(raidIndex))
                        -- nameText.name:SetText("|TInterface\\AddOns\\Cell\\Media\\Icons\\group"..subgroup..":0:0:0:-1:64:64:6:58:6:58|t"..nameText.name:GetText())
                        nameText.name:SetText("|cffbbbbbb"..subgroup.."-|r"..nameText.name:GetText())
                    end
                end
            end
        end

        nameText:SetSize(nameText.name:GetWidth(), nameText.name:GetHeight())
    end

    function nameText:UpdateVehicleName()
        F:UpdateTextWidth(nameText.vehicle, nameText.isPreview and L["vehicle name"] or UnitName(parent.state.displayedUnit), nameText.width, parent.widget.healthBar)
    end

    function nameText:UpdateVehicleNamePosition(pTable)
        local p = nameText:GetPoint(1) or ""
        if string.find(p, "LEFT") then
            p = "LEFT"
        elseif string.find(p, "RIGHT") then
            p = "RIGHT"
        else -- "CENTER"
            p = ""
        end

        nameText.vehicle:ClearAllPoints()
        if pTable[1] == "TOP" then
            nameText.vehicle:Show()
            nameText.vehicle:SetPoint("BOTTOM"..p, nameText.name, "TOP"..p, 0, pTable[2])
            nameText.vehicleEnabled = true
        elseif pTable[1] == "BOTTOM" then
            nameText.vehicle:Show()
            nameText.vehicle:SetPoint("TOP"..p, nameText.name, "BOTTOM"..p, 0, pTable[2])
            nameText.vehicleEnabled = true
        else -- Hide
            nameText.vehicle:Hide()
            nameText.vehicleEnabled = false
        end
    end

    function nameText:UpdateTextWidth(width)
        nameText.width = width
        
        nameText:UpdateName()

        if parent.state.inVehicle or nameText.isPreview then
            F:UpdateTextWidth(nameText.vehicle, nameText.isPreview and L["Vehicle Name"] or UnitName(parent.state.displayedUnit), width, parent.widget.healthBar)
        end
    end

    function nameText:UpdatePreviewColor(color)
        if color[1] == "class_color" then
            nameText.name:SetTextColor(F:GetClassColor(Cell.vars.playerClass))
        else
            nameText.name:SetTextColor(unpack(color[2]))
        end
    end

    function nameText:SetColor(r, g, b)
        nameText.name:SetTextColor(r, g, b)
    end

    function nameText:ShowGroupNumber(show)
        nameText.showGroupNumber = show
        nameText:UpdateName()
    end

    parent.widget.healthBar:SetScript("OnSizeChanged", function()
        if parent.state.name then
            nameText:UpdateName()
            
            if parent.state.inVehicle or nameText.isPreview then
                nameText:UpdateVehicleName()
            end
        end
    end)
end

-------------------------------------------------
-- status text
-------------------------------------------------
local startTimeCache = {}
function I:CreateStatusText(parent)
    local statusText = CreateFrame("Frame", parent:GetName().."StatusText", parent.widget.overlayFrame)
    parent.indicators.statusText = statusText
    statusText:Hide()

    local text = statusText:CreateFontString(nil, "ARTWORK", "CELL_FONT_STATUS")
    statusText.text = text

    local timer = statusText:CreateFontString(nil, "ARTWORK", "CELL_FONT_STATUS")
    statusText.timer = timer
    
    function statusText:GetStatus()
        return statusText.status
    end

    function statusText:SetStatus(status)
        -- print("status: " .. (status or "nil"))
        statusText.status = status
        text:SetText(L[status])
        if status then
            text:SetTextColor(unpack(statusText.colors[status]))
            timer:SetTextColor(unpack(statusText.colors[status]))
            statusText:SetHeight(text:GetHeight()+1)
        end
    end

    function statusText:SetColors(colors)
        statusText.colors = colors
    end
    
    statusText.OriginalSetPoint = statusText.SetPoint
    function statusText:SetPoint(point, _, yOffset)
        statusText:ClearAllPoints()
        statusText:OriginalSetPoint("LEFT", parent.widget.healthBar)
        statusText:OriginalSetPoint("RIGHT", parent.widget.healthBar)
        statusText:OriginalSetPoint(point, parent.widget.healthBar, 0, yOffset)

        text:ClearAllPoints()
        text:SetPoint(point.."LEFT")
        timer:ClearAllPoints()
        timer:SetPoint(point.."RIGHT")

        statusText:SetHeight(text:GetHeight()+1)
    end
    
    function statusText:SetFont(font, size, flags)
        if not string.find(strlower(font), ".ttf") then font = F:GetFont(font) end

        if flags == "Shadow" then
            text:SetFont(font, size, "")
            text:SetShadowOffset(1, -1)
            text:SetShadowColor(0, 0, 0, 1)
            timer:SetFont(font, size, "")
            timer:SetShadowOffset(1, -1)
            timer:SetShadowColor(0, 0, 0, 1)
        else
            if flags == "None" then
                flags = ""
            elseif flags == "Outline" then
                flags = "OUTLINE"
            else
                flags = "OUTLINE, MONOCHROME"
            end
            text:SetFont(font, size, flags)
            text:SetShadowOffset(0, 0)
            text:SetShadowColor(0, 0, 0, 0)
            timer:SetFont(font, size, flags)
            timer:SetShadowOffset(0, 0)
            timer:SetShadowColor(0, 0, 0, 0)
        end
    end

    function statusText:ShowTimer()
        timer:Show()
        if not startTimeCache[parent.state.guid] then startTimeCache[parent.state.guid] = GetTime() end
        
        statusText.ticker = C_Timer.NewTicker(1, function()
            if not parent.state.guid and parent.state.unit then -- ElvUI AFK mode
                parent.state.guid = UnitGUID(parent.state.unit)
            end
            if parent.state.guid and startTimeCache[parent.state.guid] then
                timer:SetFormattedText(F:FormatTime(GetTime() - startTimeCache[parent.state.guid]))
            else
                timer:SetText("")
            end
        end)
    end

    function statusText:HideTimer(reset)
        timer:Hide()
        timer:SetText("")
        if reset then
            if statusText.ticker then statusText.ticker:Cancel() end
            startTimeCache[parent.state.guid] = nil
        end
    end
end

-------------------------------------------------
-- health text
-------------------------------------------------
function I:CreateHealthText(parent)
    local healthText = CreateFrame("Frame", parent:GetName().."HealthText", parent.widget.overlayFrame)
    parent.indicators.healthText = healthText
    healthText:Hide()

    local text = healthText:CreateFontString(nil, "OVERLAY", "CELL_FONT_STATUS")
    healthText.text = text

    function healthText:SetFont(font, size, flags)
        if not string.find(strlower(font), ".ttf") then font = F:GetFont(font) end

        if flags == "Shadow" then
            text:SetFont(font, size, "")
            text:SetShadowOffset(1, -1)
            text:SetShadowColor(0, 0, 0, 1)
        else
            if flags == "None" then
                flags = ""
            elseif flags == "Outline" then
                flags = "OUTLINE"
            else
                flags = "OUTLINE, MONOCHROME"
            end
            text:SetFont(font, size, flags)
            text:SetShadowOffset(0, 0)
            text:SetShadowColor(0, 0, 0, 0)
        end
        healthText:SetSize(text:GetStringWidth()+3, size+3)
    end

    healthText.OriginalSetPoint = healthText.SetPoint
    function healthText:SetPoint(point, relativeTo, relativePoint, x, y)
        text:ClearAllPoints()
        if string.find(point, "LEFT") then
            text:SetPoint("LEFT")
        elseif string.find(point, "RIGHT") then
            text:SetPoint("RIGHT")
        else
            text:SetPoint("CENTER")
        end
        healthText:OriginalSetPoint(point, relativeTo, relativePoint, x, y)
    end

    function healthText:SetFormat(format)
        healthText.format = format
    end

    function healthText:SetColor(r, g, b)
        text:SetTextColor(r, g, b)
    end

    function healthText:SetHealth(current, max)
        if healthText.format == "percentage" then
            text:SetText(string.format("%d%%", current/max*100))
        elseif healthText.format == "percentage-deficit" then
            text:SetText(string.format("%d%%", (current-max)/max*100))
        elseif healthText.format == "number" then
            text:SetText(current)
        elseif healthText.format == "number-short" then
            text:SetText(F:FormatNumber(current))
        elseif healthText.format == "number-deficit" then
            text:SetText(current-max)
        elseif healthText.format == "number-deficit-short" then
            text:SetText(F:FormatNumber(current-max))
        end
        healthText:SetWidth(text:GetStringWidth()+3)
    end
end

-------------------------------------------------
-- role icon
-------------------------------------------------
function I:CreateRoleIcon(parent)
    local roleIcon = parent.widget.overlayFrame:CreateTexture(parent:GetName().."RoleIcon", "ARTWORK", nil, -7)
    parent.indicators.roleIcon = roleIcon
    -- roleIcon:SetPoint("TOPLEFT", overlayFrame)
    -- roleIcon:SetSize(11, 11)
    
    function roleIcon:SetRole(role)
        if role == "TANK" or role == "HEALER" or (not roleIcon.hideDamager and role == "DAMAGER") then
            if roleIcon.texture == "default" then
                roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\UI-LFG-ICON-PORTRAITROLES.blp")
                roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
            elseif roleIcon.texture == "default2" then
                roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\UI-LFG-ICON-ROLES.blp")
                roleIcon:SetTexCoord(GetTexCoordsForRole(role))
            elseif roleIcon.texture == "blizzard" then
                roleIcon:SetTexture("Interface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES.blp")
                roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
            elseif roleIcon.texture == "blizzard2" then
                roleIcon:SetTexture("Interface\\LFGFRAME\\UI-LFG-ICON-ROLES.blp")
                roleIcon:SetTexCoord(GetTexCoordsForRole(role))
            elseif roleIcon.texture == "ffxiv" then
                roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\FFXIV\\"..role)
                roleIcon:SetTexCoord(0, 1, 0, 1)
            elseif roleIcon.texture == "miirgui" then
                roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\MiirGui\\"..role)
                roleIcon:SetTexCoord(0, 1, 0, 1)
            elseif roleIcon.texture == "mattui" then
                roleIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Roles\\MattUI.blp")
                roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
            elseif roleIcon.texture == "custom" then
                roleIcon:SetTexture(roleIcon[role])
                roleIcon:SetTexCoord(0, 1, 0, 1)
            end
            roleIcon:Show()
        else
            roleIcon:Hide()
        end
    end

    function roleIcon:SetRoleTexture(t)
        roleIcon.texture = t[1]
        roleIcon.TANK = t[2]
        roleIcon.HEALER = t[3]
        roleIcon.DAMAGER = t[4]
    end

    function roleIcon:HideDamager(hide)
        roleIcon.hideDamager = hide
    end
end

-------------------------------------------------
-- leader icon
-------------------------------------------------
function I:CreateLeaderIcon(parent)
    local leaderIcon = parent.widget.overlayFrame:CreateTexture(parent:GetName().."LeaderIcon", "ARTWORK", nil, -7)
    parent.indicators.leaderIcon = leaderIcon
    -- leaderIcon:SetPoint("TOPLEFT", roleIcon, "BOTTOM")
    -- leaderIcon:SetPoint("TOPLEFT", 0, -11)
    -- leaderIcon:SetSize(11, 11)
    leaderIcon:Hide()
    
    function leaderIcon:SetIcon(isLeader, isAssistant)
        if isLeader then
            leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
            leaderIcon:Show()
        elseif isAssistant then
            leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
            leaderIcon:Show()
        else
            leaderIcon:Hide()
        end
    end
end

-------------------------------------------------
-- ready check icon
-------------------------------------------------
function I:CreateReadyCheckIcon(parent)
    local readyCheckIcon = CreateFrame("Frame", parent:GetName().."ReadyCheckIcon", parent.widget.overlayFrame)
    parent.indicators.readyCheckIcon = readyCheckIcon
    -- readyCheckIcon:SetSize(16, 16)
    readyCheckIcon:SetPoint("CENTER", parent.widget.healthBar)
    readyCheckIcon:Hide()
    readyCheckIcon:SetIgnoreParentAlpha(true)
    
    readyCheckIcon.tex = readyCheckIcon:CreateTexture(nil, "ARTWORK")
    readyCheckIcon.tex:SetAllPoints(readyCheckIcon)
    
    function readyCheckIcon:SetTexture(tex)
        readyCheckIcon.tex:SetTexture(tex)
    end
end

-------------------------------------------------
-- aggro border
-------------------------------------------------
function I:CreateAggroBorder(parent)
    local aggroBorder = CreateFrame("Frame", parent:GetName().."AggroBorder", parent, "BackdropTemplate")
    parent.indicators.aggroBorder = aggroBorder
    P:Point(aggroBorder, "TOPLEFT", parent, "TOPLEFT", 1, -1)
    P:Point(aggroBorder, "BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)
    aggroBorder:Hide()

    local top = aggroBorder:CreateTexture(nil, "BORDER")
    local bottom = aggroBorder:CreateTexture(nil, "BORDER")
    local left = aggroBorder:CreateTexture(nil, "BORDER")
    local right = aggroBorder:CreateTexture(nil, "BORDER")

    top:SetTexture("Interface\\Buttons\\WHITE8x8")
    top:SetPoint("TOPLEFT")
    top:SetPoint("TOPRIGHT")
    top:SetHeight(5)
    
    bottom:SetTexture("Interface\\Buttons\\WHITE8x8")
    bottom:SetPoint("BOTTOMLEFT")
    bottom:SetPoint("BOTTOMRIGHT")
    bottom:SetHeight(5)
    
    left:SetTexture("Interface\\Buttons\\WHITE8x8")
    left:SetPoint("TOPLEFT")
    left:SetPoint("BOTTOMLEFT")
    left:SetWidth(5)
    
    right:SetTexture("Interface\\Buttons\\WHITE8x8")
    right:SetPoint("TOPRIGHT")
    right:SetPoint("BOTTOMRIGHT")
    right:SetWidth(5)
    
    if Cell.isRetail then
        top:SetGradient("VERTICAL", CreateColor(1, 0.1, 0.1, 0), CreateColor(1, 0.1, 0.1, 1))
        bottom:SetGradient("VERTICAL", CreateColor(1, 0.1, 0.1, 1), CreateColor(1, 0.1, 0.1, 0))
        left:SetGradient("HORIZONTAL", CreateColor(1, 0.1, 0.1, 1), CreateColor(1, 0.1, 0.1, 0))
        right:SetGradient("HORIZONTAL", CreateColor(1, 0.1, 0.1, 0), CreateColor(1, 0.1, 0.1, 1))

        function aggroBorder:ShowAggro(r, g, b)
            top:SetGradient("VERTICAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 1))
            bottom:SetGradient("VERTICAL", CreateColor(r, g, b, 1), CreateColor(r, g, b, 0))
            left:SetGradient("HORIZONTAL", CreateColor(r, g, b, 1), CreateColor(r, g, b, 0))
            right:SetGradient("HORIZONTAL", CreateColor(r, g, b, 0), CreateColor(r, g, b, 1))
            aggroBorder:Show()
        end
    else
        top:SetGradientAlpha("VERTICAL", 1, 0.1, 0.1, 0, 1, 0.1, 0.1, 1)
        bottom:SetGradientAlpha("VERTICAL", 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 0)
        left:SetGradientAlpha("HORIZONTAL", 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 0)
        right:SetGradientAlpha("HORIZONTAL", 1, 0.1, 0.1, 0, 1, 0.1, 0.1, 1)

        function aggroBorder:ShowAggro(r, g, b)
            top:SetGradientAlpha("VERTICAL", r, g, b, 0, r, g, b, 1)
            bottom:SetGradientAlpha("VERTICAL", r, g, b, 1, r, g, b, 0)
            left:SetGradientAlpha("HORIZONTAL", r, g, b, 1, r, g, b, 0)
            right:SetGradientAlpha("HORIZONTAL", r, g, b, 0, r, g, b, 1)
            aggroBorder:Show()
        end
    end

    function aggroBorder:SetThickness(n)
        top:SetHeight(n)
        bottom:SetHeight(n)
        left:SetWidth(n)
        right:SetWidth(n)
    end
end

-------------------------------------------------
-- aggro blink
-------------------------------------------------
function I:CreateAggroBlink(parent)
    local aggroBlink = CreateFrame("Frame", parent:GetName().."AggroBlink", parent.widget.overlayFrame, "BackdropTemplate")
    parent.indicators.aggroBlink = aggroBlink
    -- aggroBlink:SetPoint("TOPLEFT")
    -- aggroBlink:SetSize(10, 10)
    aggroBlink:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    aggroBlink:SetBackdropColor(1, 0, 0, 1)
    aggroBlink:SetBackdropBorderColor(0, 0, 0, 1)
    aggroBlink:Hide()

    local blink = aggroBlink:CreateAnimationGroup()
    aggroBlink.blink = blink
    blink:SetLooping("REPEAT")

    local alpha = blink:CreateAnimation("Alpha")
    blink.alpha = alpha
    alpha:SetFromAlpha(1)
    alpha:SetToAlpha(0)
    alpha:SetDuration(0.5)
    
    aggroBlink:SetScript("OnShow", function(self)
        self.blink:Play()
    end)
    
    aggroBlink:SetScript("OnHide", function(self)
        self.blink:Stop()
    end)

    function aggroBlink:ShowAggro(r, g, b)
        aggroBlink:SetBackdropColor(r, g, b)
        aggroBlink:Show()
    end

    function aggroBlink:UpdatePixelPerfect()
        P:Resize(aggroBlink)
        P:Repoint(aggroBlink)
        aggroBlink:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
        aggroBlink:SetBackdropColor(1, 0, 0, 1)
        aggroBlink:SetBackdropBorderColor(0, 0, 0, 1)
    end
end

-------------------------------------------------
-- shield bar
-------------------------------------------------
function I:CreateShieldBar(parent)
    local shieldBar = CreateFrame("Frame", parent:GetName().."ShieldBar", parent.widget.overlayFrame, "BackdropTemplate")
    parent.indicators.shieldBar = shieldBar
    -- shieldBar:SetSize(4, 4)
    shieldBar:Hide()
    shieldBar:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
    shieldBar:SetBackdropColor(0, 0, 0, 1)

    local tex = shieldBar:CreateTexture(nil, "ARTWORK")
    P:Point(tex, "TOPLEFT", shieldBar, "TOPLEFT", 1, -1)
    P:Point(tex, "BOTTOMRIGHT", shieldBar, "BOTTOMRIGHT", -1, 1)

    function shieldBar:SetColor(r, g, b, a)
        tex:SetColorTexture(r, g, b)
        shieldBar:SetAlpha(a)
    end

    function shieldBar:SetValue(percent)
        local maxWidth = parent.widget.healthBar:GetWidth()
        local barWidth
        if percent >= 1 then
            barWidth = maxWidth
        else
            barWidth = maxWidth * percent
        end
        P:Width(shieldBar, barWidth)
    end

    function shieldBar:UpdatePixelPerfect()
        P:Resize(shieldBar)
        P:Repoint(shieldBar)
        P:Repoint(tex)
    end
end

-------------------------------------------------
-- health threshold
-------------------------------------------------
function I:CreateHealthThresholds(parent)
    local healthThresholds = CreateFrame("Frame", parent:GetName().."HealthThresholds", parent.widget.healthBar)
    parent.indicators.healthThresholds = healthThresholds
    healthThresholds:SetAllPoints(parent.widget.healthBar)
    healthThresholds:SetFrameLevel(parent.widget.healthBar:GetFrameLevel()+1)
    
    healthThresholds.tex = healthThresholds:CreateTexture(nil, "ARTWORK")
    
    function healthThresholds:SetThickness(thickness)
        healthThresholds.thickness = thickness
        P:Size(healthThresholds.tex, thickness, thickness)
    end

    function healthThresholds:SetOrientation(orientation)
        healthThresholds.orientation = orientation
        healthThresholds.tex:ClearAllPoints()
        if orientation == "horizontal" then
            healthThresholds.tex:SetPoint("TOP")
            healthThresholds.tex:SetPoint("BOTTOM")
        else
            healthThresholds.tex:SetPoint("LEFT")
            healthThresholds.tex:SetPoint("RIGHT")
        end
    end
    
    function healthThresholds:CheckThreshold(percent)
        local found
        for i, t in ipairs(Cell.vars.healthThresholds) do
            if percent < t[1] then
                found = i
                break
            end
        end
        if found then
            if healthThresholds.orientation == "horizontal" then
                healthThresholds.tex:SetPoint("LEFT", Cell.vars.healthThresholds[found][1] * parent.widget.healthBar:GetWidth(), 0)
            else
                healthThresholds.tex:SetPoint("BOTTOM", 0, Cell.vars.healthThresholds[found][1] * parent.widget.healthBar:GetHeight())
            end
            healthThresholds.tex:SetColorTexture(unpack(Cell.vars.healthThresholds[found][2]))
            healthThresholds:Show()
        else
            healthThresholds:Hide()
        end
    end

    if parent == CellIndicatorsPreviewButton then
        healthThresholds.tex:Hide()

        function healthThresholds:UpdateThresholdsPreview()
            for i, t in ipairs(Cell.vars.healthThresholds) do
                healthThresholds[i] = healthThresholds[i] or healthThresholds:CreateTexture(nil, "ARTWORK")
                P:Size(healthThresholds[i], healthThresholds.thickness, healthThresholds.thickness)
                healthThresholds[i]:SetColorTexture(unpack(t[2]))
                -- healthThresholds[i]:SetBlendMode("ADD")
                
                healthThresholds[i]:ClearAllPoints()
                if healthThresholds.orientation == "horizontal" then
                    healthThresholds[i]:SetPoint("TOP")
                    healthThresholds[i]:SetPoint("BOTTOM")
                    healthThresholds[i]:SetPoint("LEFT", t[1] * parent.widget.healthBar:GetWidth(), 0)
                else
                    healthThresholds[i]:SetPoint("LEFT")
                    healthThresholds[i]:SetPoint("RIGHT")
                    healthThresholds[i]:SetPoint("BOTTOM", 0, t[1] * parent.widget.healthBar:GetHeight())
                end
                healthThresholds[i]:Show()
            end
            -- hide unused
            for i = #Cell.vars.healthThresholds+1, #healthThresholds do
                if healthThresholds[i] then
                    healthThresholds[i]:Hide()
                end
            end
        end
    end
end

-- sort and save
function I:UpdateHealthThresholds()
    Cell.vars.healthThresholds = Cell.vars.currentLayoutTable.indicators[Cell.defaults.indicatorIndices.healthThresholds].thresholds
    F:Sort(Cell.vars.healthThresholds, 1, "ascending")
end
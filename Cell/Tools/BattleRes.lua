local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

-------------------------------------------------
-- battle res
-------------------------------------------------
local battleResFrame = CreateFrame("Frame", "CellBattleResFrame", Cell.frames.mainFrame, "BackdropTemplate")
Cell.frames.battleResFrame = battleResFrame
-- battleResFrame:SetPoint("BOTTOMLEFT", Cell.frames.mainFrame, "TOPLEFT", 0, 17)
P:Size(battleResFrame, 75, 20)
battleResFrame:Hide()
Cell:StylizeFrame(battleResFrame, {0.1, 0.1, 0.1, 0.7}, {0, 0, 0, 0.5})

---------------------------------
-- Animation
---------------------------------
local point, relativePoint, onShow, onHide
local loaded = false

battleResFrame.onMenuShow = battleResFrame:CreateAnimationGroup()
battleResFrame.onMenuShow.trans = battleResFrame.onMenuShow:CreateAnimation("translation")
battleResFrame.onMenuShow.trans:SetDuration(0.3)
battleResFrame.onMenuShow.trans:SetSmoothing("OUT")
battleResFrame.onMenuShow:SetScript("OnPlay", function()
    battleResFrame.onMenuHide:Stop()
end)
battleResFrame.onMenuShow:SetScript("OnFinished", function()
    battleResFrame:ClearAllPoints()
    battleResFrame:SetPoint(point, CellAnchorFrame, relativePoint, 0, onShow)
end)

function battleResFrame:OnMenuShow()
    if not loaded then return end

    if not battleResFrame:IsShown() then
        battleResFrame.onMenuShow:GetScript("OnFinished")()
        return
    end

    local currentY = select(5, battleResFrame:GetPoint(1))
    if type(currentY) ~= "number" then return end
    currentY = math.floor(currentY+.5)

    if onShow ~= currentY then
        local offset = onShow-currentY
        battleResFrame.onMenuShow.trans:SetOffset(0, offset)
        battleResFrame.onMenuShow:Play()
    end
end

battleResFrame.onMenuHide = battleResFrame:CreateAnimationGroup()
battleResFrame.onMenuHide.trans = battleResFrame.onMenuHide:CreateAnimation("translation")
battleResFrame.onMenuHide.trans:SetDuration(0.3)
battleResFrame.onMenuHide.trans:SetSmoothing("OUT")
battleResFrame.onMenuHide:SetScript("OnPlay", function()
    battleResFrame.onMenuShow:Stop()
end)
battleResFrame.onMenuHide:SetScript("OnFinished", function()
    battleResFrame:ClearAllPoints()
    battleResFrame:SetPoint(point, CellAnchorFrame, relativePoint, 0, onHide)
end)

function battleResFrame:OnMenuHide()
    if not loaded then return end

    if not battleResFrame:IsShown() then
        battleResFrame.onMenuHide:GetScript("OnFinished")()
        return
    end

    local currentY = select(5, battleResFrame:GetPoint(1))
    if type(currentY) ~= "number" then return end
    currentY = math.floor(currentY+.5)

    if onHide ~= currentY then
        local offset = onHide-currentY
        battleResFrame.onMenuHide.trans:SetOffset(0, offset)
        battleResFrame.onMenuHide:Play()
    end
end

---------------------------------
-- Bar
---------------------------------
local bar = Cell:CreateStatusBar("CellBattleResBar", battleResFrame, 10, 2, 100, false, nil, false, "Interface\\AddOns\\Cell\\Media\\statusbar", Cell:GetAccentColorTable())
P:Point(bar, "BOTTOMLEFT", battleResFrame, "BOTTOMLEFT", 1, 1)
P:Point(bar, "BOTTOMRIGHT", battleResFrame, "BOTTOMRIGHT", -1, 1)
-- bar:SetMinMaxValues(0, 100)
-- bar:SetValue(50)

---------------------------------
-- String
---------------------------------
local title = battleResFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
local stack = battleResFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
local rTime = battleResFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
local dummy = battleResFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET") -- used for updating width of battleResFrame
dummy:Hide()

title:SetFont(title:GetFont(), 13, "")
stack:SetFont(stack:GetFont(), 13, "")
rTime:SetFont(rTime:GetFont(), 13, "")
dummy:SetFont(dummy:GetFont(), 13, "")

title:SetJustifyH("LEFT")
stack:SetJustifyH("LEFT")
rTime:SetJustifyH("RIGHT")

P:Point(title, "BOTTOMLEFT", bar, "TOPLEFT", 0, 2)
stack:SetPoint("LEFT", title, "RIGHT")
rTime:SetPoint("LEFT", stack, "RIGHT")
dummy:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 22)

title:SetTextColor(0.66, 0.66, 0.66)
rTime:SetTextColor(0.66, 0.66, 0.66)

title:SetText(L["BR"]..": ")
stack:SetText("")
rTime:SetText("")
dummy:SetText(L["BR"]..": |cffff00000|r  00:00 ")

battleResFrame:SetScript("OnShow", function()
    P:Width(battleResFrame, math.floor(dummy:GetWidth()+.5))
end)

battleResFrame:SetScript("OnHide", function()
    stack:SetText("")
    rTime:SetText("")
end)

---------------------------------
-- Update
---------------------------------
local total = 0
-- local isMovable = false

battleResFrame:SetScript("OnUpdate", function(self, elapsed)
    -- if isMovable then return end --设置位置

    total = total + elapsed
    if total >= 0.25 then
        total = 0
        
        -- Upon engaging a boss, all combat resurrection spells will have their cooldowns reset and begin with 1 charge.
        -- Charges will accumulate at a rate of 1 per (90/RaidSize) minutes.
        local charges, _, started, duration = GetSpellCharges(20484)
        if not charges then
            -- hide out of encounter
            battleResFrame:Hide()
            battleResFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
            return
        end
        
        local color = (charges > 0) and "|cffffffff" or "|cffff0000"
        local remaining = duration - (GetTime() - started)
        local m = floor(remaining / 60)
        local s = mod(remaining, 60)

        stack:SetText(("%s%d|r  "):format(color, charges))
        rTime:SetText(("%d:%02d"):format(m, s))
        
        bar:SetMinMaxValues(0, duration)
        bar:SetValue(duration - remaining)
    end
end)

function battleResFrame:SPELL_UPDATE_CHARGES()
    local charges = GetSpellCharges(20484)
    if charges then
        battleResFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
        -- isMovable = false
        battleResFrame:Show()
    end
end

function battleResFrame:PLAYER_ENTERING_WORLD()
    battleResFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
    battleResFrame:Hide()
    
    local _, instanceType, difficulty = GetInstanceInfo()

    if instanceType == "raid" then -- raid
        if IsEncounterInProgress() then --如果 上线时/重载界面后 已在boss战中
            battleResFrame:Show()
        else
            battleResFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
        end
    
    elseif difficulty == 8 then -- challenge mode
        battleResFrame:Show()
    end
end

function battleResFrame:CHALLENGE_MODE_START()
    battleResFrame:Show()
end

battleResFrame:SetScript("OnEvent", function(self, event, ...)
    battleResFrame[event](self, ...)
end)

local function UpdateTools(which)
    if not which or which == "battleRes" then
        if CellDB["tools"]["showBattleRes"] then
            battleResFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            battleResFrame:RegisterEvent("CHALLENGE_MODE_START")
            battleResFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
        else
            battleResFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
            battleResFrame:UnregisterEvent("CHALLENGE_MODE_START")
            battleResFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
        end
    end
end
Cell:RegisterCallback("UpdateTools", "BattleRes_UpdateTools", UpdateTools)


local function UpdatePosition()
    local anchor = Cell.vars.currentLayoutTable["anchor"]
    battleResFrame:ClearAllPoints()

    if anchor == "BOTTOMLEFT" then
        point, relativePoint = "TOPLEFT", "BOTTOMLEFT"
        onShow, onHide = -4, 10
        
    elseif anchor == "BOTTOMRIGHT" then
        point, relativePoint = "TOPRIGHT", "BOTTOMRIGHT"
        onShow, onHide = -4, 10
        
    elseif anchor == "TOPLEFT" then
        point, relativePoint = "BOTTOMLEFT", "TOPLEFT"
        onShow, onHide = 4, -10
        
    elseif anchor == "TOPRIGHT" then
        point, relativePoint = "BOTTOMRIGHT", "TOPRIGHT"
        onShow, onHide = 4, -10
    end

    if CellDB["general"]["menuPosition"] == "top_bottom" then
        if CellDB["general"]["fadeOut"] then
            battleResFrame:SetPoint(point, CellAnchorFrame, relativePoint, 0, onHide)
        else
            battleResFrame:SetPoint(point, CellAnchorFrame, relativePoint, 0, onShow)
        end
    else
        battleResFrame:SetPoint(point, CellMainFrame, relativePoint, 0, onShow)
    end
end

local function UpdateMenu(which)
    if which == "position" then
        UpdatePosition()
    end
end
Cell:RegisterCallback("UpdateMenu", "BattleRes_UpdateMenu", UpdateMenu)

local function UpdateLayout(layout, which)
    if not loaded or which == "anchor" then
        UpdatePosition()
        loaded = true
    end
end
Cell:RegisterCallback("UpdateLayout", "BattleRes_UpdateLayout", UpdateLayout)

local function UpdatePixelPerfect()
    P:Resize(battleResFrame)
    -- P:Repoint(battleResFrame)
    Cell:StylizeFrame(battleResFrame, {0.1, 0.1, 0.1, 0.7}, {0, 0, 0, 0.5})
    bar:UpdatePixelPerfect()
    P:Repoint(title)
end
Cell:RegisterCallback("UpdatePixelPerfect", "BattleRes_UpdatePixelPerfect", UpdatePixelPerfect)
local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local marks, worldMarks

local marksFrame = CreateFrame("Frame", "CellRaidMarksFrame", Cell.frames.mainFrame, "BackdropTemplate")
Cell.frames.raidMarksFrame = marksFrame
P:Size(marksFrame, 196, 40)
marksFrame:SetPoint("BOTTOMRIGHT", UIParent, "CENTER")
marksFrame:SetClampedToScreen(true)
marksFrame:SetMovable(true)
marksFrame:RegisterForDrag("LeftButton")
marksFrame:SetScript("OnDragStart", function()
    marksFrame:StartMoving()
    marksFrame:SetUserPlaced(false)
end)
marksFrame:SetScript("OnDragStop", function()
    marksFrame:StopMovingOrSizing()
    P:SavePosition(marksFrame, CellDB["tools"]["marks"][3])
end)

-------------------------------------------------
-- mover
-------------------------------------------------
marksFrame.moverText = marksFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
marksFrame.moverText:SetPoint("TOP", 0, -3)
marksFrame.moverText:SetText(L["Mover"])
marksFrame.moverText:Hide()

local function ShowMover(show)
    if show then
        if not CellDB["tools"]["marks"][1] then return end
        marksFrame:EnableMouse(true)
        marksFrame.moverText:Show()
        Cell:StylizeFrame(marksFrame, {0, 1, 0, 0.4}, {0, 0, 0, 0})
        if not F:HasPermission(true) then -- button not shown
            if strfind(CellDB["tools"]["marks"][2], "^target") then
                marks:Show()
            elseif strfind(CellDB["tools"]["marks"][2], "^world") then
                worldMarks:Show()
            else
                marks:Show()
                worldMarks:Show()
            end
        end
    else
        marksFrame:EnableMouse(false)
        marksFrame.moverText:Hide()
        Cell:StylizeFrame(marksFrame, {0, 0, 0, 0}, {0, 0, 0, 0})
        if not F:HasPermission(true) then -- button should not shown
            marks:Hide()
            worldMarks:Hide()
        end
    end
end
Cell:RegisterCallback("ShowMover", "RaidMarks_ShowMover", ShowMover)

-------------------------------------------------
-- colors
-------------------------------------------------
local markColors = {
    {1, 1, 0}, -- star
    {1, 0.5, 0}, -- circle
    {0.5, 0, 1}, -- diamond
    {0, 1, 0.2}, -- triangle
    {0.5, 0.5, 0.5}, -- moon
    {0, 0.5, 1}, -- square
    {1, 0, 0}, -- cross
    {1, 1, 1}, -- skull
    {1, 0.19, 0.19}, -- clear
}

-------------------------------------------------
-- marks
-------------------------------------------------
marks = Cell:CreateFrame("CellRaidMarksFrame_Marks", marksFrame, 196, 20, true)
marks:SetPoint("BOTTOMLEFT")
marks:Hide()

local ticker
local markButtons = {}
for i = 1, 9 do
    markButtons[i] = Cell:CreateButton(marks, "", "accent-hover", {20, 20})
    markButtons[i].texture = markButtons[i]:CreateTexture(nil, "ARTWORK")
    P:Point(markButtons[i].texture, "TOPLEFT", markButtons[i], "TOPLEFT", 2, -2)
    P:Point(markButtons[i].texture, "BOTTOMRIGHT", markButtons[i], "BOTTOMRIGHT", -2, 2)
    
    if i == 9 then
        -- clear all marks
        markButtons[i].texture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        markButtons[i]:SetScript("OnClick", function()
            markButtons[i]:SetEnabled(false)
            markButtons[i].texture:SetDesaturated(true)
            for j = 1, 8 do
                SetRaidTarget("player", j)
            end
            C_Timer.After(0.5, function()
                SetRaidTarget("player", 0)
                markButtons[i]:SetEnabled(true)
                markButtons[i].texture:SetDesaturated(false)
            end)
        end)
    else
        markButtons[i].texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
        SetRaidTargetIconTexture(markButtons[i].texture, i)
        markButtons[i]:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        markButtons[i]:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                -- set raid target icon
                if GetRaidTargetIndex("target") == i then
                    SetRaidTarget("target", 0)
                else
                    SetRaidTarget("target", i)
                end
            elseif button == "RightButton" then
                -- lock raid target icon
                local unit, name, class = F:GetTargetUnitInfo()
                if unit and name then
                    if markButtons[i].locked then
                        F:NotifyMarkUnlock(i, name, class)
                        SetRaidTarget(markButtons[i].locked, 0)
                        markButtons[i]:SetBackdropBorderColor(0, 0, 0, 1)
                        markButtons[i].locked = nil
                        if markButtons[i].ticker then
                            markButtons[i].ticker:Cancel()
                            markButtons[i].ticker = nil
                        end
                    else
                        F:NotifyMarkLock(i, name, class)
                        SetRaidTarget(unit, i)
                        markButtons[i]:SetBackdropBorderColor(markColors[i][1], markColors[i][2], markColors[i][3], 1)
                        markButtons[i].locked = unit
                        markButtons[i].ticker = C_Timer.NewTicker(1.5, function()
                            if UnitName(unit) == name then
                                if GetRaidTargetIndex(unit) ~= i then
                                    SetRaidTarget(unit, i)
                                end
                            else
                                markButtons[i].locked = nil
                                markButtons[i].ticker:Cancel()
                                markButtons[i].ticker = nil
                                markButtons[i]:SetBackdropBorderColor(0, 0, 0, 1)
                            end
                        end)
                    end
                end
            end
        end)
    end

    markButtons[i].bg:SetColorTexture(0.1, 0.1, 0.1, 0.7)
    markButtons[i]:SetBackdropColor(0, 0, 0, 0)
    markButtons[i].color = {0, 0, 0, 0}
    markButtons[i].hoverColor = {markColors[i][1], markColors[i][2], markColors[i][3], 0.35}

    -- if i == 1 then
    --     P:Point(markButtons[i], "TOPLEFT")
    -- else
    --     P:Point(markButtons[i], "LEFT", markButtons[i-1], "RIGHT", 2, 0)
    -- end
end

marks:SetScript("OnHide", function()
    for i = 1, 8 do
        markButtons[i].locked = nil
        if markButtons[i].ticker then
            markButtons[i].ticker:Cancel()
            markButtons[i].ticker = nil
        end
        markButtons[i]:SetBackdropBorderColor(0, 0, 0, 1)
    end
end)

-------------------------------------------------
-- world marks
-------------------------------------------------
worldMarks = Cell:CreateFrame("CellRaidMarksFrame_WorldMarks", marksFrame, 196, 20, true)
worldMarks:SetPoint("BOTTOMLEFT")
worldMarks:Hide()

local worldMarkIndices = {5, 6, 3, 2, 7, 1, 4, 8}
local worldMarkButtons = {}
for i = 1, 9 do
    worldMarkButtons[i] = Cell:CreateButton(worldMarks, "", "accent-hover", {20, 20}, false, false, nil, nil, "SecureActionButtonTemplate")
    worldMarkButtons[i]:RegisterForClicks("LeftButtonUp", "LeftButtonDown") -- NOTE: ActionButtonUseKeyDown will affect this
    worldMarkButtons[i].texture = worldMarkButtons[i]:CreateTexture(nil, "ARTWORK")
    
    if i == 9 then
        -- clear all marks
        P:Point(worldMarkButtons[i].texture, "TOPLEFT", worldMarkButtons[i], "TOPLEFT", 2, -2)
        P:Point(worldMarkButtons[i].texture, "BOTTOMRIGHT", worldMarkButtons[i], "BOTTOMRIGHT", -2, 2)
        worldMarkButtons[i].texture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        worldMarkButtons[i]:SetAttribute("type", "worldmarker")
        worldMarkButtons[i]:SetAttribute("action", "clear")
    else
        P:Point(worldMarkButtons[i].texture, "TOPLEFT", worldMarkButtons[i], "TOPLEFT", 1, -1)
        P:Point(worldMarkButtons[i].texture, "BOTTOMRIGHT", worldMarkButtons[i], "BOTTOMRIGHT", -1, 1)
        worldMarkButtons[i].texture:SetColorTexture(markColors[i][1], markColors[i][2], markColors[i][3], 0.4)
        worldMarkButtons[i]:SetAttribute("type", "worldmarker")
        worldMarkButtons[i]:SetAttribute("marker", worldMarkIndices[i])
        -- worldMarkButtons[i]:SetAttribute("type", "macro")
        -- worldMarkButtons[i]:SetAttribute("macrotext", "/wm "..worldMarkIndices[i])
    end

    worldMarkButtons[i].bg:SetColorTexture(0.1, 0.1, 0.1, 0.7)
    worldMarkButtons[i]:SetBackdropColor(0, 0, 0, 0)
    worldMarkButtons[i].color = {0, 0, 0, 0}
    worldMarkButtons[i].hoverColor = {markColors[i][1], markColors[i][2], markColors[i][3], 0.35}

    -- if i == 1 then
    --     P:Point(worldMarkButtons[i], "TOPLEFT")
    -- else
    --     P:Point(worldMarkButtons[i], "LEFT", worldMarkButtons[i-1], "RIGHT", 2, 0)
    -- end
end

local worldMarksTimer
worldMarks:SetScript("OnShow", function()
    worldMarksTimer = C_Timer.NewTicker(0.5, function()
        for i = 1, 8 do
            if IsRaidMarkerActive(worldMarkIndices[i]) then
                worldMarkButtons[i]:SetBackdropBorderColor(markColors[i][1], markColors[i][2], markColors[i][3], 1)
            else
                worldMarkButtons[i]:SetBackdropBorderColor(0, 0, 0, 1)
            end
        end
    end)
end)
worldMarks:SetScript("OnHide", function()
    if worldMarksTimer then
        worldMarksTimer:Cancel()
        worldMarksTimer = nil
    end
end)

-------------------------------------------------
-- functions
-------------------------------------------------
local function Rearrange(marksConfig)
    if strfind(marksConfig, "_h$") then
        P:Size(marks, 196, 20)
        P:Size(worldMarks, 196, 20)

        if strfind(marksConfig, "^target") then
            P:Size(marksFrame, 196, 40)
            worldMarks:Hide()
            P:ClearPoints(marks)
            P:Point(marks, "BOTTOMLEFT")
        elseif strfind(marksConfig, "^world") then
            P:Size(marksFrame, 196, 40)
            marks:Hide()
            P:ClearPoints(worldMarks)
            P:Point(worldMarks, "BOTTOMLEFT")
        else -- both
            P:Size(marksFrame, 196, 60)
            P:ClearPoints(worldMarks)
            P:Point(worldMarks, "BOTTOMLEFT")
            P:ClearPoints(marks)
            P:Point(marks, "BOTTOMLEFT", worldMarks, "TOPLEFT", 0, 2)
        end

        -- repoint each button
        for i = 1, 9 do
            P:ClearPoints(markButtons[i])
            P:ClearPoints(worldMarkButtons[i])
            if i == 1 then
                P:Point(markButtons[i], "TOPLEFT")
                P:Point(worldMarkButtons[i], "TOPLEFT")
            else
                P:Point(markButtons[i], "TOPLEFT", markButtons[i-1], "TOPRIGHT", 2, 0)
                P:Point(worldMarkButtons[i], "TOPLEFT", worldMarkButtons[i-1], "TOPRIGHT", 2, 0)
            end
        end
    elseif strfind(marksConfig, "_v$") then
        P:Size(marks, 20, 196)
        P:Size(worldMarks, 20, 196)

        if strfind(marksConfig, "^target") then
            P:Size(marksFrame, 20, 216)
            worldMarks:Hide()
            P:ClearPoints(marks)
            P:Point(marks, "BOTTOMLEFT")
        elseif strfind(marksConfig, "^world") then
            P:Size(marksFrame, 20, 216)
            marks:Hide()
            P:ClearPoints(worldMarks)
            P:Point(worldMarks, "BOTTOMLEFT")
        else -- both
            P:Size(marksFrame, 42, 216)
            P:ClearPoints(worldMarks)
            P:Point(worldMarks, "BOTTOMLEFT")
            P:ClearPoints(marks)
            P:Point(marks, "BOTTOMLEFT", worldMarks, "BOTTOMRIGHT", 2, 0)
        end
        
        -- repoint each button
        for i = 1, 9 do
            P:ClearPoints(markButtons[i])
            P:ClearPoints(worldMarkButtons[i])
            if i == 1 then
                P:Point(markButtons[i], "TOPLEFT")
                P:Point(worldMarkButtons[i], "TOPLEFT")
            else
                P:Point(markButtons[i], "TOPLEFT", markButtons[i-1], "BOTTOMLEFT", 0, -2)
                P:Point(worldMarkButtons[i], "TOPLEFT", worldMarkButtons[i-1], "BOTTOMLEFT", 0, -2)
            end
        end
    end
end

local function CheckPermission()
    if InCombatLockdown() then
        marksFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        marksFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        if CellDB["tools"]["marks"][1] then
            if strfind(CellDB["tools"]["marks"][2], "^target") then
                if marksFrame.moverText:IsShown() or Cell.vars.hasPartyMarkPermission then
                    marks:Show()
                else
                    marks:Hide()
                end
                
            elseif strfind(CellDB["tools"]["marks"][2], "^world") then
                if marksFrame.moverText:IsShown() or Cell.vars.hasPartyMarkPermission then
                    worldMarks:Show()
                else
                    worldMarks:Hide()
                end

            else -- both
                if marksFrame.moverText:IsShown() or Cell.vars.hasPartyMarkPermission then
                    marks:Show()
                    worldMarks:Show()
                else
                    marks:Hide()
                    worldMarks:Hide()
                end
            end
            Rearrange(CellDB["tools"]["marks"][2])
        else
            marks:Hide()
            worldMarks:Hide()
        end
    end
end

marksFrame:SetScript("OnEvent", function()
    CheckPermission()
end)

Cell:RegisterCallback("PermissionChanged", "RaidMarks_PermissionChanged", CheckPermission)

local function UpdateTools(which)
    F:Debug("|cffBBFFFFUpdateTools:|r", which)
    if not which or which == "marks" then
        CheckPermission()
        ShowMover(Cell.vars.showMover and CellDB["tools"]["marks"][1])
    end

    if not which then -- position
        P:LoadPosition(marksFrame, CellDB["tools"]["marks"][3])
    end
end
Cell:RegisterCallback("UpdateTools", "RaidMarks_UpdateTools", UpdateTools)

local function UpdatePixelPerfect()
    P:Resize(marksFrame)
    P:Resize(marks)
    P:Repoint(marks) -- only marks needs to repoint
    P:Resize(worldMarks)

    for i = 1, 9 do
        markButtons[i]:UpdatePixelPerfect()
        worldMarkButtons[i]:UpdatePixelPerfect()
        P:Repoint(markButtons[i].texture)
        P:Repoint(worldMarkButtons[i].texture)
    end
end
Cell:RegisterCallback("UpdatePixelPerfect", "Marks_UpdatePixelPerfect", UpdatePixelPerfect)
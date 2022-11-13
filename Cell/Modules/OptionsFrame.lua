local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local lastShownTab

local optionsFrame = Cell:CreateFrame("CellOptionsFrame", Cell.frames.mainFrame, 432, 401)
Cell.frames.optionsFrame = optionsFrame
-- optionsFrame:SetPoint("BOTTOMLEFT", Cell.frames.mainFrame, "TOPLEFT", 0, 16)
optionsFrame:SetPoint("CENTER", UIParent)
optionsFrame:SetFrameStrata("HIGH")
optionsFrame:SetClampedToScreen(true)
optionsFrame:SetClampRectInsets(0, 0, 40, 0)
optionsFrame:SetMovable(true)

local function RegisterDragForOptionsFrame(frame)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        optionsFrame:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        optionsFrame:StopMovingOrSizing()
        P:PixelPerfectPoint(optionsFrame)
        -- optionsFrame:ClearAllPoints()
        -- optionsFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", optionsFrame:GetLeft(), optionsFrame:GetTop())
        -- print( optionsFrame:GetLeft(), optionsFrame:GetTop())
    end)
end

-------------------------------------------------
-- button group
-------------------------------------------------
local generalBtn, appearanceBtn, clickCastingsBtn, aboutBtn, layoutsBtn, indicatorsBtn, debuffsBtn, glowsBtn, closeBtn

local function CreateTabButtons()
    generalBtn = Cell:CreateButton(optionsFrame, L["General"], "accent-hover", {105, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    appearanceBtn = Cell:CreateButton(optionsFrame, L["Appearance"], "accent-hover", {105, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    layoutsBtn = Cell:CreateButton(optionsFrame, L["Layouts"], "accent-hover", {105, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    clickCastingsBtn = Cell:CreateButton(optionsFrame, L["Click-Castings"], "accent-hover", {120, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    indicatorsBtn = Cell:CreateButton(optionsFrame, L["Indicators"], "accent-hover", {105, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    debuffsBtn = Cell:CreateButton(optionsFrame, L["Raid Debuffs"], "accent-hover", {120, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    glowsBtn = Cell:CreateButton(optionsFrame, L["Glows"], "accent-hover", {105, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    aboutBtn = Cell:CreateButton(optionsFrame, L["About"], "accent-hover", {86, 20}, false, false, "CELL_FONT_WIDGET_TITLE", "CELL_FONT_WIDGET_TITLE_DISABLE")
    closeBtn = Cell:CreateButton(optionsFrame, "×", "red", {20, 20}, false, false, "CELL_FONT_SPECIAL", "CELL_FONT_SPECIAL")
    closeBtn:SetScript("OnClick", function()
        optionsFrame:Hide()
    end)
    
    -- line 1
    layoutsBtn:SetPoint("BOTTOMLEFT", optionsFrame, "TOPLEFT", 0, P:Scale(-1))
    indicatorsBtn:SetPoint("BOTTOMLEFT", layoutsBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    debuffsBtn:SetPoint("BOTTOMLEFT", indicatorsBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    glowsBtn:SetPoint("BOTTOMLEFT", debuffsBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    glowsBtn:SetPoint("BOTTOMRIGHT", optionsFrame, "TOPRIGHT", 0, P:Scale(-1))
    -- line 2
    generalBtn:SetPoint("BOTTOMLEFT", layoutsBtn, "TOPLEFT", 0, P:Scale(-1))
    appearanceBtn:SetPoint("BOTTOMLEFT", generalBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    clickCastingsBtn:SetPoint("BOTTOMLEFT", appearanceBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    aboutBtn:SetPoint("BOTTOMLEFT", clickCastingsBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    closeBtn:SetPoint("BOTTOMLEFT", aboutBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    closeBtn:SetPoint("BOTTOMRIGHT", glowsBtn, "TOPRIGHT", 0, P:Scale(-1))
    
    RegisterDragForOptionsFrame(generalBtn)
    RegisterDragForOptionsFrame(appearanceBtn)
    RegisterDragForOptionsFrame(layoutsBtn)
    RegisterDragForOptionsFrame(clickCastingsBtn)
    RegisterDragForOptionsFrame(indicatorsBtn)
    RegisterDragForOptionsFrame(debuffsBtn)
    RegisterDragForOptionsFrame(glowsBtn)
    RegisterDragForOptionsFrame(aboutBtn)
    
    generalBtn.id = "general"
    appearanceBtn.id = "appearance"
    layoutsBtn.id = "layouts"
    clickCastingsBtn.id = "clickCastings"
    indicatorsBtn.id = "indicators"
    debuffsBtn.id = "debuffs"
    glowsBtn.id = "glows"
    aboutBtn.id = "about"
    
    local tabHeight = {
        ["general"] = 450,
        ["appearance"] = 532,
        ["layouts"] = 570,
        ["clickCastings"] = 526,
        ["indicators"] = 512,
        ["debuffs"] = 497,
        ["glows"] = 459,
        ["about"] = 555,
    }
    
    local function ShowTab(tab)
        if lastShownTab ~= tab then
            P:Height(optionsFrame, tabHeight[tab])
            Cell:Fire("ShowOptionsTab", tab)
            lastShownTab = tab
        end
    end
    
    Cell:CreateButtonGroup({generalBtn, appearanceBtn, layoutsBtn, clickCastingsBtn, indicatorsBtn, debuffsBtn, glowsBtn, aboutBtn}, ShowTab)
end

-------------------------------------------------
-- show & hide
-------------------------------------------------
local init
function F:ShowOptionsFrame()
    if InCombatLockdown() then
        F:Print(L["Can't change options in combat."])
        return
    end
    
    if not init then
        init = true
        P:Resize(optionsFrame)
        P:Reborder(optionsFrame)
        CreateTabButtons()
    end

    if optionsFrame:IsShown() then
        optionsFrame:Hide()
        return
    end

    if not lastShownTab then
        generalBtn:Click()
    end
    
    P:PixelPerfectPoint(optionsFrame)
    optionsFrame:Show()
end

optionsFrame:SetScript("OnHide", function()
    -- stolen from dbm
    if not InCombatLockdown() and not UnitAffectingCombat("player") and not IsFalling() then
        F:Debug("|cffff7777collectgarbage")
        collectgarbage("collect")
        -- UpdateAddOnMemoryUsage() -- stuck like hell
    end
end)

optionsFrame:SetScript("OnShow", function()
    P:PixelPerfectPoint(optionsFrame)
end)

optionsFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
optionsFrame:SetScript("OnEvent", function()
    optionsFrame:Hide()
end)

-- for Raid Debuffs import
function F:ShowRaidDebuffsTab()
    optionsFrame:Show()
    debuffsBtn:Click()
end

-- for layout import
function F:ShowLayousTab()
    optionsFrame:Show()
    layoutsBtn:Click()
end
local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local placeholders, assignmentButtons = {}, {}
local tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY
local NONE = strlower(_G.NONE)
-------------------------------------------------
-- spotlightFrame
-------------------------------------------------
local spotlightFrame = CreateFrame("Frame", "CellSpotlightFrame", Cell.frames.mainFrame, "SecureFrameTemplate")
Cell.frames.spotlightFrame = spotlightFrame

local anchorFrame = CreateFrame("Frame", "CellSpotlightAnchorFrame", spotlightFrame)
Cell.frames.spotlightFrameAnchor = anchorFrame
anchorFrame:SetPoint("TOPLEFT", UIParent, "CENTER")
anchorFrame:SetMovable(true)
anchorFrame:SetClampedToScreen(true)

local hoverFrame = CreateFrame("Frame", nil, spotlightFrame, "BackdropTemplate")
hoverFrame:SetPoint("TOP", anchorFrame, 0, 1)
hoverFrame:SetPoint("BOTTOM", anchorFrame, 0, -1)
hoverFrame:SetPoint("LEFT", anchorFrame, -1, 0)
hoverFrame:SetPoint("RIGHT", anchorFrame, 1, 0)
-- Cell:StylizeFrame(hoverFrame, {1,0,0,0.3}, {0,0,0,0})

local config = Cell:CreateButton(anchorFrame, nil, "accent", {20, 10}, false, true, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
config:SetFrameStrata("MEDIUM")
config:SetAllPoints(anchorFrame)
config:RegisterForDrag("LeftButton")
config:SetScript("OnDragStart", function()
    anchorFrame:StartMoving()
    anchorFrame:SetUserPlaced(false)
end)
config:SetScript("OnDragStop", function()
    anchorFrame:StopMovingOrSizing()
    P:SavePosition(anchorFrame, Cell.vars.currentLayoutTable["spotlight"][3])
end)
config:SetAttribute("_onclick", [[
    for i = 1, 5 do
        local b = self:GetFrameRef("assignment"..i)
        if b:IsShown() then
            b:Hide()
        else
            b:Show()
        end
    end

    self:GetFrameRef("menu"):Hide()
]])
config:HookScript("OnEnter", function()
    hoverFrame:GetScript("OnEnter")(hoverFrame)
    CellTooltip:SetOwner(config, "ANCHOR_NONE")
    CellTooltip:SetPoint(tooltipPoint, config, tooltipRelativePoint, tooltipX, tooltipY)
    CellTooltip:AddLine(L["Spotlight Frame"])
    CellTooltip:Show()
end)
config:HookScript("OnLeave", function()
    hoverFrame:GetScript("OnLeave")(hoverFrame)
    CellTooltip:Hide()
end)

-------------------------------------------------
-- fadeIn & fadeOut
-------------------------------------------------
local fadingIn, fadedIn, fadingOut, fadedOut
anchorFrame.fadeIn = anchorFrame:CreateAnimationGroup()
anchorFrame.fadeIn.alpha = anchorFrame.fadeIn:CreateAnimation("alpha")
anchorFrame.fadeIn.alpha:SetFromAlpha(0)
anchorFrame.fadeIn.alpha:SetToAlpha(1)
anchorFrame.fadeIn.alpha:SetDuration(0.5)
anchorFrame.fadeIn.alpha:SetSmoothing("OUT")
anchorFrame.fadeIn:SetScript("OnPlay", function()
    anchorFrame.fadeOut:Finish()
    fadingIn = true
end)
anchorFrame.fadeIn:SetScript("OnFinished", function()
    fadingIn = false
    fadingOut = false
    fadedIn = true
    fadedOut = false
    anchorFrame:SetAlpha(1)

    if CellDB["general"]["fadeOut"] and not hoverFrame:IsMouseOver() then
        anchorFrame.fadeOut:Play()
    end
end)

anchorFrame.fadeOut = anchorFrame:CreateAnimationGroup()
anchorFrame.fadeOut.alpha = anchorFrame.fadeOut:CreateAnimation("alpha")
anchorFrame.fadeOut.alpha:SetFromAlpha(1)
anchorFrame.fadeOut.alpha:SetToAlpha(0)
anchorFrame.fadeOut.alpha:SetDuration(0.5)
anchorFrame.fadeOut.alpha:SetSmoothing("OUT")
anchorFrame.fadeOut:SetScript("OnPlay", function()
    anchorFrame.fadeIn:Finish()
    fadingOut = true
end)
anchorFrame.fadeOut:SetScript("OnFinished", function()
    fadingIn = false
    fadingOut = false
    fadedIn = false
    fadedOut = true
    anchorFrame:SetAlpha(0)

    if hoverFrame:IsMouseOver() then
        anchorFrame.fadeIn:Play()
    end
end)

hoverFrame:SetScript("OnEnter", function()
    if not CellDB["general"]["fadeOut"] then return end
    if not (fadingIn or fadedIn) then
        anchorFrame.fadeIn:Play()
    end
end)
hoverFrame:SetScript("OnLeave", function()
    if not CellDB["general"]["fadeOut"] then return end
    if hoverFrame:IsMouseOver() then return end
    if not (fadingOut or fadedOut) then
        anchorFrame.fadeOut:Play()
    end
end)

-------------------------------------------------
-- assignment buttons
-------------------------------------------------
local function CreateAssignmentButton(index)
    local b = Cell:CreateButton(spotlightFrame, NONE, "accent-hover", {20, 20}, false, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
    b:GetFontString():SetNonSpaceWrap(true)
    b:GetFontString():SetWordWrap(true)
    b:SetFrameStrata("MEDIUM")
    b:SetAttribute("index", index)
    b:Hide()

    b:SetAttribute("_onclick", [[
        local menu = self:GetFrameRef("menu")
        menu:ClearAllPoints()
        menu:SetPoint(menu:GetAttribute("point"), self, menu:GetAttribute("anchorPoint"), menu:GetAttribute("xOffset"), menu:GetAttribute("yOffset"))
        menu:Show()

        -- print(self:GetAttribute("index"))
        menu:SetAttribute("index", self:GetAttribute("index"))
    ]])

    b:SetScript("OnAttributeChanged", function(self, name, value)
        if name ~= "text" then return end
        b:SetText(value == "none" and NONE or value)
    end)

    return b
end

-------------------------------------------------
-- placeholders
-------------------------------------------------
local function CreatePlaceHolder(index)
    local placeholder = CreateFrame("Frame", "CellSpotlightFramePlaceholder"..index, spotlightFrame, "BackdropTemplate")
    placeholder:Hide()
    Cell:StylizeFrame(placeholder, {0, 0, 0, 0.27})

    placeholder.text = placeholder:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    placeholder.text:SetPoint("LEFT")
    placeholder.text:SetPoint("RIGHT")
    placeholder.text:SetWordWrap(true)
    placeholder.text:SetNonSpaceWrap(true)

    return placeholder
end

-------------------------------------------------
-- unitbuttons
-------------------------------------------------
local wrapFrame = CreateFrame("Frame", "CellSpotlightWrapFrame", nil, "SecureHandlerBaseTemplate")

for i = 1, 5 do
    -- placeholder
    placeholders[i] = CreatePlaceHolder(i)

    -- assignment button
    assignmentButtons[i] = CreateAssignmentButton(i)
    assignmentButtons[i]:SetAllPoints(placeholders[i])
    SecureHandlerSetFrameRef(config, "assignment"..i, assignmentButtons[i])
    
    -- unit button
    local b = CreateFrame("Button", "CellSpotlightFrameUnitButton"..i, spotlightFrame, "CellUnitButtonTemplate")
    Cell.unitButtons.spotlight[i] = b
    -- b:SetAttribute("unit", "player")
    -- RegisterUnitWatch(b)
    b:SetAllPoints(placeholders[i])
    b.isSpotlight = true --! NOTE: prevent overwrite Cell.vars.guids and Cell.vars.names

    --! 天杀的 Secure Codes
    SecureHandlerSetFrameRef(b, "placeholder", placeholders[i])
    wrapFrame:WrapScript(b, "OnShow", [[
        self:GetFrameRef("placeholder"):Hide()
    ]])
    wrapFrame:WrapScript(b, "OnHide", [[
        if self:GetAttribute("unit") then
            self:GetFrameRef("placeholder"):Show()
        end
    ]])
    wrapFrame:WrapScript(b, "OnAttributeChanged", [[
        if name ~= "unit" then return end
        if self:GetAttribute("unit") and not self:IsShown() then
            self:GetFrameRef("placeholder"):Show()
        else
            self:GetFrameRef("placeholder"):Hide()
        end
    ]])

    b:HookScript("OnAttributeChanged", function(self, name, value)
        if name ~= "unit" then return end
        if type(value) == "string" then
            placeholders[i].text:SetText("|cffA7A7A7"..value)
        else
            placeholders[i].text:SetText("|cffA7A7A7"..NONE)
        end
    end)
end

-------------------------------------------------
-- menu
-------------------------------------------------
local menu = CreateFrame("Frame", "CellSpotlightAssignmentMenu", spotlightFrame, "BackdropTemplate,SecureHandlerAttributeTemplate,SecureHandlerShowHideTemplate")
menu:SetFrameStrata("TOOLTIP")
menu:SetClampedToScreen(true)
menu:Hide()

--! assignmentBtn -> spotlightButton
for i = 1, 5 do
    -- assignmentBtn -> menu
    SecureHandlerSetFrameRef(assignmentButtons[i], "menu", menu)
    -- menu -> spotlightButton
    SecureHandlerSetFrameRef(menu, "spotlight"..i, Cell.unitButtons.spotlight[i])
    -- menu -> assignmentBtn
    SecureHandlerSetFrameRef(menu, "assignment"..i, assignmentButtons[i])
end

-- hide
SecureHandlerSetFrameRef(menu, "config", config)
SecureHandlerSetFrameRef(config, "menu", menu)
-- menu:SetAttribute("_onhide", [[
--     for i = 1, 5 do
--         self:GetFrameRef("assignment"..i):Hide()
--     end
-- ]])

-- menu items
local target = Cell:CreateButton(menu, L["Target"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(target, "TOPLEFT", menu, "TOPLEFT", 1, -1)
P:Point(target, "RIGHT", menu, "RIGHT", -1, 0)
target:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    local spotlight = menu:GetFrameRef("spotlight"..index)
    spotlight:SetAttribute("unit", "target")
    spotlight:SetAttribute("refreshOnUpdate", nil)
    menu:GetFrameRef("assignment"..index):SetAttribute("text", "target")
    menu:Hide()

    menu:CallMethod("Save", index, "target")
]])

-- NOTE: no EVENT for this kind of targets， use OnUpdate
local targettarget = Cell:CreateButton(menu, L["Target of Target"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(targettarget, "TOPLEFT", target, "BOTTOMLEFT")
P:Point(targettarget, "TOPRIGHT", target, "BOTTOMRIGHT")
targettarget:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    local spotlight = menu:GetFrameRef("spotlight"..index)
    spotlight:SetAttribute("unit", "targettarget")
    spotlight:SetAttribute("refreshOnUpdate", true)
    menu:GetFrameRef("assignment"..index):SetAttribute("text", "targettarget")
    menu:Hide()

    menu:CallMethod("Save", index, "targettarget")
]])

local focus = Cell:CreateButton(menu, L["Focus"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(focus, "TOPLEFT", targettarget, "BOTTOMLEFT")
P:Point(focus, "TOPRIGHT", targettarget, "BOTTOMRIGHT")
focus:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    local spotlight = menu:GetFrameRef("spotlight"..index)
    spotlight:SetAttribute("unit", "focus")
    spotlight:SetAttribute("refreshOnUpdate", nil)
    menu:GetFrameRef("assignment"..index):SetAttribute("text", "focus")
    menu:Hide()

    menu:CallMethod("Save", index, "focus")
]])

local unit = Cell:CreateButton(menu, L["Unit"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(unit, "TOPLEFT", focus, "BOTTOMLEFT")
P:Point(unit, "TOPRIGHT", focus, "BOTTOMRIGHT")
unit:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    menu:GetFrameRef("spotlight"..index):SetAttribute("refreshOnUpdate", nil)
    self:CallMethod("SetUnit", index)
    menu:Hide()
]])
function unit:SetUnit(index)
    local unit = F:GetTargetUnitID()
    if unit then
        Cell.unitButtons.spotlight[index]:SetAttribute("unit", unit)
        assignmentButtons[index]:SetText(unit)
        menu:Save(index, unit)
    else
        F:Print(L["Invalid unit."])
    end
end

local pet = Cell:CreateButton(menu, L["Unit's Pet"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(pet, "TOPLEFT", unit, "BOTTOMLEFT")
P:Point(pet, "TOPRIGHT", unit, "BOTTOMRIGHT")
pet:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    menu:GetFrameRef("spotlight"..index):SetAttribute("refreshOnUpdate", nil)
    self:CallMethod("SetUnit", index)
    menu:Hide()
]])
function pet:SetUnit(index)
    local unit = F:GetTargetPetID()
    if unit then
        Cell.unitButtons.spotlight[index]:SetAttribute("unit", unit)
        assignmentButtons[index]:SetText(unit)
        menu:Save(index, unit)
    else
        F:Print(L["Invalid unit."])
    end
end

local clear = Cell:CreateButton(menu, L["Clear"], "transparent-accent", {20, 20}, true, false, nil, nil, "SecureHandlerAttributeTemplate,SecureHandlerClickTemplate")
P:Point(clear, "TOPLEFT", pet, "BOTTOMLEFT")
P:Point(clear, "TOPRIGHT", pet, "BOTTOMRIGHT")
clear:SetAttribute("_onclick", [[
    local menu = self:GetParent()
    local index = menu:GetAttribute("index")
    local spotlight = menu:GetFrameRef("spotlight"..index)
    spotlight:SetAttribute("unit", nil)
    spotlight:SetAttribute("refreshOnUpdate", nil)
    menu:GetFrameRef("assignment"..index):SetAttribute("text", "none")
    menu:Hide()

    menu:CallMethod("Save", index, nil)
]])

menu:RegisterEvent("PLAYER_REGEN_ENABLED")
menu:RegisterEvent("PLAYER_REGEN_DISABLED")
menu:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
        unit:SetEnabled(false)
        pet:SetEnabled(false)
    else
        unit:SetEnabled(true)
        pet:SetEnabled(true)
    end
end)

function menu:Save(index, unit)
    Cell.vars.currentLayoutTable["spotlight"][2][index] = unit
end

-- update width to show full text
local dumbFS1 = menu:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
dumbFS1:SetText(L["Target of Target"])
local dumbFS2 = menu:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
dumbFS2:SetText(L["Unit's Pet"])

function menu:UpdatePixelPerfect()
    P:Size(menu, ceil(max(dumbFS1:GetStringWidth(), dumbFS2:GetStringWidth())) + 13, 122)

    Cell:StylizeFrame(menu, nil, Cell:GetAccentColorTable())
    target:UpdatePixelPerfect()
    focus:UpdatePixelPerfect()
    targettarget:UpdatePixelPerfect()
    unit:UpdatePixelPerfect()
    pet:UpdatePixelPerfect()
    clear:UpdatePixelPerfect()
end

-------------------------------------------------
-- functions
-------------------------------------------------
local function UpdatePosition()
    local anchor = Cell.vars.currentLayoutTable["anchor"]
    
    spotlightFrame:ClearAllPoints()
    -- NOTE: detach from spotlightPreviewAnchor
    P:LoadPosition(anchorFrame, Cell.vars.currentLayoutTable["spotlight"][3])

    if CellDB["general"]["menuPosition"] == "top_bottom" then
        P:Size(anchorFrame, 20, 10)
        
        if anchor == "BOTTOMLEFT" then
            spotlightFrame:SetPoint("BOTTOMLEFT", anchorFrame, "TOPLEFT", 0, 4)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "TOPLEFT", "BOTTOMLEFT", 0, -3
        elseif anchor == "BOTTOMRIGHT" then
            spotlightFrame:SetPoint("BOTTOMRIGHT", anchorFrame, "TOPRIGHT", 0, 4)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "TOPRIGHT", "BOTTOMRIGHT", 0, -3
        elseif anchor == "TOPLEFT" then
            spotlightFrame:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -4)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "BOTTOMLEFT", "TOPLEFT", 0, 3
        elseif anchor == "TOPRIGHT" then
            spotlightFrame:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -4)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "BOTTOMRIGHT", "TOPRIGHT", 0, 3
        end
    else -- left_right
        P:Size(anchorFrame, 10, 20)

        if anchor == "BOTTOMLEFT" then
            spotlightFrame:SetPoint("BOTTOMLEFT", anchorFrame, "BOTTOMRIGHT", 4, 0)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "BOTTOMRIGHT", "BOTTOMLEFT", -3, 0
        elseif anchor == "BOTTOMRIGHT" then
            spotlightFrame:SetPoint("BOTTOMRIGHT", anchorFrame, "BOTTOMLEFT", -4, 0)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "BOTTOMLEFT", "BOTTOMRIGHT", 3, 0
        elseif anchor == "TOPLEFT" then
            spotlightFrame:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 4, 0)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "TOPRIGHT", "TOPLEFT", -3, 0
        elseif anchor == "TOPRIGHT" then
            spotlightFrame:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -4, 0)
            tooltipPoint, tooltipRelativePoint, tooltipX, tooltipY = "TOPLEFT", "TOPRIGHT", 3, 0
        end
    end
end

local function UpdateMenu(which)
    if not which or which == "lock" then
        if CellDB["general"]["locked"] then
            config:RegisterForDrag()
        else
            config:RegisterForDrag("LeftButton")
        end
    end

    if not which or which == "fadeOut" then
        if CellDB["general"]["fadeOut"] then
            anchorFrame.fadeOut:Play()
        else
            anchorFrame.fadeIn:Play()
        end
    end

    if which == "position" then
        UpdatePosition()
    end
end
Cell:RegisterCallback("UpdateMenu", "SpotlightFrame_UpdateMenu", UpdateMenu)

local function UpdateLayout(layout, which)
    layout = Cell.vars.currentLayoutTable

    if not which or which == "size" or which == "spotlightSize" then
        local width, height
        if layout["spotlight"][4] then
            width, height = unpack(layout["spotlight"][5])
        else
            width, height = unpack(layout["size"])
        end

        P:Size(spotlightFrame, width, height)

        for _, f in pairs(placeholders) do
            P:Size(f, width, height)
        end
    end

    if not which or which == "spacing" or which == "orientation" or which == "anchor" then
        -- anchors
        local point, anchorPoint, unitSpacing
        local menuAnchorPoint, menuX, menuY
        
        if layout["orientation"] == "vertical" then
            if layout["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint = "BOTTOMLEFT", "TOPLEFT"
                unitSpacing = layout["spacingX"]
                menuAnchorPoint = "BOTTOMRIGHT"
                menuX, menuY = 4, 0
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint = "BOTTOMRIGHT", "TOPRIGHT"
                unitSpacing = layout["spacingX"]
                menuAnchorPoint = "BOTTOMLEFT"
                menuX, menuY = -4, 0
            elseif layout["anchor"] == "TOPLEFT" then
                point, anchorPoint = "TOPLEFT", "BOTTOMLEFT"
                unitSpacing = -layout["spacingX"]
                menuAnchorPoint = "TOPRIGHT"
                menuX, menuY = 4, 0
            elseif layout["anchor"] == "TOPRIGHT" then
                point, anchorPoint = "TOPRIGHT", "BOTTOMRIGHT"
                unitSpacing = -layout["spacingX"]
                menuAnchorPoint = "TOPLEFT"
                menuX, menuY = -4, 0
            end
        else
            if layout["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT"
                unitSpacing = layout["spacingX"]
                menuAnchorPoint = "TOPLEFT"
                menuX, menuY = 0, 4
            elseif layout["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT"
                unitSpacing = -layout["spacingX"]
                menuAnchorPoint = "TOPRIGHT"
                menuX, menuY = 0, 4
            elseif layout["anchor"] == "TOPLEFT" then
                point, anchorPoint = "TOPLEFT", "TOPRIGHT"
                unitSpacing = layout["spacingX"]
                menuAnchorPoint = "BOTTOMLEFT"
                menuX, menuY = 0, -4
            elseif layout["anchor"] == "TOPRIGHT" then
                point, anchorPoint = "TOPRIGHT", "TOPLEFT"
                unitSpacing = -layout["spacingX"]
                menuAnchorPoint = "BOTTOMRIGHT"
                menuX, menuY = 0, -4
            end
        end

        menu:SetAttribute("point", point)
        menu:SetAttribute("anchorPoint", menuAnchorPoint)
        menu:SetAttribute("xOffset", menuX)
        menu:SetAttribute("yOffset", menuY)
        menu:Hide()

        local last
        for i, f in pairs(placeholders) do
            f:ClearAllPoints()
            if last then
                if layout["orientation"] == "vertical" then
                    f:SetPoint(point, last, anchorPoint, 0, unitSpacing)
                else
                    f:SetPoint(point, last, anchorPoint, unitSpacing, 0)
                end
            else
                f:SetPoint("TOPLEFT", spotlightFrame)
            end
            last = f
        end
    end

    if not which or which == "anchor" then
        UpdatePosition()
    end

    -- NOTE: SetOrientation BEFORE SetPowerSize
    if not which or which == "barOrientation" then
        for _, b in pairs(Cell.unitButtons.spotlight) do
            b.func.SetOrientation(unpack(layout["barOrientation"]))
        end
    end
    
    if not which or which == "power" or which == "barOrientation" then
        for _, b in pairs(Cell.unitButtons.spotlight) do
            b.func.SetPowerSize(layout["powerSize"])
        end
    end

    if not which or which == "spotlight" then
        if layout["spotlight"][1] then
            for i = 1, 5 do
                local unit = layout["spotlight"][2][i]
                Cell.unitButtons.spotlight[i]:SetAttribute("unit", unit)
                if unit == "targettarget" then
                    Cell.unitButtons.spotlight[i]:SetAttribute("refreshOnUpdate", true)
                end
                RegisterUnitWatch(Cell.unitButtons.spotlight[i])
                assignmentButtons[i]:SetText(unit or NONE)
            end
            spotlightFrame:Show()
        else
            for i = 1, 5 do
                Cell.unitButtons.spotlight[i]:SetAttribute("unit", nil)
                Cell.unitButtons.spotlight[i]:SetAttribute("refreshOnUpdate", nil)
                UnregisterUnitWatch(Cell.unitButtons.spotlight[i])
                assignmentButtons[i]:SetText(NONE)
                Cell.unitButtons.spotlight[i]:Hide()
            end
            spotlightFrame:Hide()
            menu:Hide()
        end
    end

    -- load position
    if not P:LoadPosition(anchorFrame, layout["spotlight"][3]) then
        P:ClearPoints(anchorFrame)
        -- no position, use default
        anchorFrame:SetPoint("TOPLEFT", UIParent, "CENTER")
    end
end
Cell:RegisterCallback("UpdateLayout", "SpotlightFrame_UpdateLayout", UpdateLayout)

local function UpdatePixelPerfect()
    P:Resize(spotlightFrame)
    P:Resize(anchorFrame)
    config:UpdatePixelPerfect()
    menu:UpdatePixelPerfect()

    for _, p in pairs(placeholders) do
        Cell:StylizeFrame(p, {0, 0, 0, 0.27})
    end

    for _, b in pairs(assignmentButtons) do
        b:UpdatePixelPerfect()
    end
end
Cell:RegisterCallback("UpdatePixelPerfect", "SpotlightFrame_UpdatePixelPerfect", UpdatePixelPerfect)
local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local layoutsTab = Cell:CreateFrame("CellOptionsFrame_LayoutsTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.layoutsTab = layoutsTab
layoutsTab:SetAllPoints(Cell.frames.optionsFrame)
layoutsTab:Hide()

local selectedRole, selectedLayout, selectedLayoutTable
-------------------------------------------------
-- preview frame
-------------------------------------------------
local previewButton

local function CreatePreviewButton()
    previewButton = CreateFrame("Button", "CellLayoutsPreviewButton", layoutsTab, "CellPreviewButtonTemplate")
    previewButton:SetPoint("TOPRIGHT", layoutsTab, "TOPLEFT", -5, -20)
    previewButton:UnregisterAllEvents()
    previewButton:SetScript("OnEnter", nil)
    previewButton:SetScript("OnLeave", nil)
    previewButton:SetScript("OnShow", nil)
    previewButton:SetScript("OnHide", nil)
    previewButton:SetScript("OnUpdate", nil)
    previewButton:Show()
    
    local previewButtonBG = Cell:CreateFrame("CellLayoutsPreviewButtonBG", layoutsTab)
    previewButtonBG:SetPoint("TOPLEFT", previewButton, 0, 20)
    previewButtonBG:SetPoint("BOTTOMRIGHT", previewButton, "TOPRIGHT")
    previewButtonBG:SetFrameStrata("HIGH")
    Cell:StylizeFrame(previewButtonBG, {0.1, 0.1, 0.1, 0.77}, {0, 0, 0, 0})
    previewButtonBG:Show()
    
    local previewText = previewButtonBG:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    previewText:SetPoint("TOP", 0, -3)
    previewText:SetText(Cell:GetAccentColorString()..L["Preview"])

    Cell:Fire("CreatePreview", previewButton)
end

local function UpdatePreviewButton(which, value)
    if not previewButton then
        CreatePreviewButton()
    end

    if not which or which == "nameText" then
        local iTable = selectedLayoutTable["indicators"][1]
        if iTable["enabled"] then
            previewButton.indicators.nameText:Show()
            previewButton.indicators.nameText.isPreview = true
            previewButton.state.name = UnitName("player")
            previewButton.indicators.nameText:UpdateName()
            previewButton.indicators.nameText:UpdatePreviewColor(iTable["nameColor"])
            previewButton.indicators.nameText:UpdateTextWidth(iTable["textWidth"])
            previewButton.indicators.nameText:SetFont(unpack(iTable["font"]))
            previewButton.indicators.nameText:ClearAllPoints()
            previewButton.indicators.nameText:SetPoint(unpack(iTable["position"]))

            -- previewButton.indicators.nameText:UpdateVehicleName()
            -- previewButton.indicators.nameText:UpdateVehicleNamePosition(iTable["vehicleNamePosition"])
        else
            previewButton.indicators.nameText:Hide()
        end
    end

    -- if not which or which == "statusText" then
    --     local iTable = selectedLayoutTable["indicators"][2]
    --     if iTable["enabled"] then
    --         previewButton.indicators.statusText:Show()
    --         previewButton.indicators.statusText:SetFont(unpack(iTable["font"]))
    --         previewButton.indicators.statusText:ClearAllPoints()
    --         previewButton.indicators.statusText:SetPoint(iTable["position"][1], nil, iTable["position"][2])
    --         previewButton.indicators.statusText.text:SetText(L["OFFLINE"])
    --         previewButton.indicators.statusText.timer:SetText("13m")
    --     else
    --         previewButton.indicators.statusText:Hide()
    --     end
    -- end

    if not which or which == "appearance" then
        previewButton.widget.healthBar:SetStatusBarTexture(Cell.vars.texture)
        previewButton.widget.powerBar:SetStatusBarTexture(Cell.vars.texture)

        -- health color
        local r, g, b = F:GetHealthColor(1, false, F:GetClassColor(Cell.vars.playerClass))
        previewButton.widget.healthBar:SetStatusBarColor(r, g, b, CellDB["appearance"]["barAlpha"])
        
        -- power color
        r, g, b = F:GetPowerColor("player", Cell.vars.playerClass)
        previewButton.widget.powerBar:SetStatusBarColor(r, g, b)

        -- alpha
        previewButton:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
    end
    
    if not which or which == "size" then
        P:Size(previewButton, selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
    end

    if not which or which == "barOrientation" then
        previewButton.func.SetOrientation(unpack(selectedLayoutTable["barOrientation"]))
    end

    if not which or which == "power" or which == "barOrientation" then
        previewButton.func.SetPowerSize(selectedLayoutTable["powerSize"])
    end

    Cell:Fire("UpdatePreview", previewButton)
end

-------------------------------------------------
-- layout preview
-------------------------------------------------
local previewMode = 0
local layoutPreview, layoutPreviewAnchor, layoutPreviewName
local function CreateLayoutPreview()
    layoutPreview = Cell:CreateFrame("CellLayoutPreviewFrame", Cell.frames.mainFrame, nil, nil, true)
    layoutPreview:EnableMouse(false)
    layoutPreview:SetFrameStrata("MEDIUM")
    layoutPreview:SetToplevel(true)
    layoutPreview:Hide()

    layoutPreviewAnchor = CreateFrame("Frame", "CellLayoutPreviewAnchorFrame", layoutPreview, "BackdropTemplate")
    -- layoutPreviewAnchor:SetPoint("TOPLEFT", UIParent, "CENTER")
    P:Size(layoutPreviewAnchor, 20, 10)
    layoutPreviewAnchor:SetMovable(true)
    layoutPreviewAnchor:EnableMouse(true)
    layoutPreviewAnchor:RegisterForDrag("LeftButton")
    layoutPreviewAnchor:SetClampedToScreen(true)
    Cell:StylizeFrame(layoutPreviewAnchor, {0, 1, 0, 0.4})
    layoutPreviewAnchor:Hide()
    layoutPreviewAnchor:SetScript("OnDragStart", function()
        layoutPreviewAnchor:StartMoving()
        layoutPreviewAnchor:SetUserPlaced(false)
    end)
    layoutPreviewAnchor:SetScript("OnDragStop", function()
        layoutPreviewAnchor:StopMovingOrSizing()
        P:SavePosition(layoutPreviewAnchor, selectedLayoutTable["position"])
    end)

    layoutPreviewName = layoutPreviewAnchor:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS_TITLE")

    -- init raid preview
    layoutPreview.fadeIn = layoutPreview:CreateAnimationGroup()
    local fadeIn = layoutPreview.fadeIn:CreateAnimation("alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.5)
    fadeIn:SetSmoothing("OUT")
    fadeIn:SetScript("OnPlay", function()
        layoutPreview:Show()
    end)
    
    layoutPreview.fadeOut = layoutPreview:CreateAnimationGroup()
    local fadeOut = layoutPreview.fadeOut:CreateAnimation("alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.5)
    fadeOut:SetSmoothing("IN")
    fadeOut:SetScript("OnFinished", function()
        layoutPreview:Hide()
    end)

    local desaturation = {
        [1] = 1,
        [2] = 0.85,
        [3] = 0.7,
        [4] = 0.55,
        [5] = 0.4,
    }

    -- headers
    layoutPreview.headers = {}
    for i = 1, 8 do
        local header = CreateFrame("Frame", "CellLayoutPreviewFrameHeader"..i, layoutPreview)
        layoutPreview.headers[i] = header

        for j = 1, 5 do
            header[j] = header:CreateTexture(nil, "BACKGROUND")
            header[j]:SetColorTexture(0, 0, 0)
            header[j]:SetAlpha(0.555)
            -- header[j]:SetSize(30, 20)

            header[j].tex = header:CreateTexture(nil, "ARTWORK")
            header[j].tex:SetTexture("Interface\\Buttons\\WHITE8x8")
    
            header[j].tex:SetPoint("TOPLEFT", header[j], "TOPLEFT", P:Scale(1), P:Scale(-1))
            header[j].tex:SetPoint("BOTTOMRIGHT", header[j], "BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

            if i == 1 then
                header[j].tex:SetVertexColor(F:ConvertRGB(255, 0, 0, desaturation[j])) -- Red
            elseif i == 2 then
                header[j].tex:SetVertexColor(F:ConvertRGB(255, 127, 0, desaturation[j])) -- Orange
            elseif i == 3 then
                header[j].tex:SetVertexColor(F:ConvertRGB(255, 255, 0, desaturation[j])) -- Yellow
            elseif i == 4 then
                header[j].tex:SetVertexColor(F:ConvertRGB(0, 255, 0, desaturation[j])) -- Green
            elseif i == 5 then
                header[j].tex:SetVertexColor(F:ConvertRGB(0, 127, 255, desaturation[j])) -- Blue
            elseif i == 6 then
                header[j].tex:SetVertexColor(F:ConvertRGB(127, 0, 255, desaturation[j])) -- Indigo
            elseif i == 7 then
                header[j].tex:SetVertexColor(F:ConvertRGB(238, 130, 238, desaturation[j])) -- Violet
            elseif i == 8 then
                header[j].tex:SetVertexColor(F:ConvertRGB(0, 255, 255, desaturation[j])) -- Cyan
            end
            header[j].tex:SetAlpha(0.5)
        end
    end
end

local function UpdateLayoutPreview()
    if not layoutPreview then
        CreateLayoutPreview()
    end

    -- update layoutPreview point
    P:Size(layoutPreview, selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
    layoutPreview:ClearAllPoints()
    layoutPreviewName:ClearAllPoints()
    if CellDB["general"]["menuPosition"] == "top_bottom" then
        P:Size(layoutPreviewAnchor, 20, 10)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            layoutPreview:SetPoint("BOTTOMLEFT", layoutPreviewAnchor, "TOPLEFT", 0, 4)
            layoutPreviewName:SetPoint("LEFT", layoutPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            layoutPreview:SetPoint("BOTTOMRIGHT", layoutPreviewAnchor, "TOPRIGHT", 0, 4)
            layoutPreviewName:SetPoint("RIGHT", layoutPreviewAnchor, "LEFT", -5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            layoutPreview:SetPoint("TOPLEFT", layoutPreviewAnchor, "BOTTOMLEFT", 0, -4)
            layoutPreviewName:SetPoint("LEFT", layoutPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            layoutPreview:SetPoint("TOPRIGHT", layoutPreviewAnchor, "BOTTOMRIGHT", 0, -4)
            layoutPreviewName:SetPoint("RIGHT", layoutPreviewAnchor, "LEFT", -5, 0)
        end
    else
        P:Size(layoutPreviewAnchor, 10, 20)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            layoutPreview:SetPoint("BOTTOMLEFT", layoutPreviewAnchor, "BOTTOMRIGHT", 4, 0)
            layoutPreviewName:SetPoint("TOPLEFT", layoutPreviewAnchor, "BOTTOMLEFT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            layoutPreview:SetPoint("BOTTOMRIGHT", layoutPreviewAnchor, "BOTTOMLEFT", -4, 0)
            layoutPreviewName:SetPoint("TOPRIGHT", layoutPreviewAnchor, "BOTTOMRIGHT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            layoutPreview:SetPoint("TOPLEFT", layoutPreviewAnchor, "TOPRIGHT", 4, 0)
            layoutPreviewName:SetPoint("BOTTOMLEFT", layoutPreviewAnchor, "TOPLEFT", 0, 5)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            layoutPreview:SetPoint("TOPRIGHT", layoutPreviewAnchor, "TOPLEFT", -4, 0)
            layoutPreviewName:SetPoint("BOTTOMRIGHT", layoutPreviewAnchor, "TOPRIGHT", 0, 5)
        end
    end

    -- update layoutPreviewAnchor point
    if selectedLayout == Cell.vars.currentLayout then
        layoutPreviewAnchor:SetAllPoints(Cell.frames.anchorFrame)
        layoutPreviewAnchor:Hide()
        layoutPreviewName:Hide()
    else
        if #selectedLayoutTable["position"] == 2 then
            P:LoadPosition(layoutPreviewAnchor, selectedLayoutTable["position"])
        else
            layoutPreviewAnchor:ClearAllPoints()
            layoutPreviewAnchor:SetPoint("TOPLEFT", UIParent, "CENTER")
        end
        layoutPreviewAnchor:Show()
        layoutPreviewName:SetText(L["Layout"]..": "..selectedLayout)
        layoutPreviewName:Show()
    end

    -- re-arrange
    local shownGroups = {}
    for i, isShown in ipairs(selectedLayoutTable["groupFilter"]) do
        if isShown then
            tinsert(shownGroups, i)
        end
    end

    for i, group in ipairs(shownGroups) do
        local header = layoutPreview.headers[group]
        local spacingX = selectedLayoutTable["spacingX"]
        local spacingY = selectedLayoutTable["spacingY"]
        
        header:ClearAllPoints()

        if selectedLayoutTable["orientation"] == "vertical" then
            -- anchor
            local point, anchorPoint, groupAnchorPoint, unitSpacing, groupSpacing, verticalSpacing
            if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT"
                unitSpacing = spacingY
                groupSpacing = spacingX
                verticalSpacing = spacingY+selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT"
                unitSpacing = spacingY
                groupSpacing = -spacingX
                verticalSpacing = spacingY+selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
                point, anchorPoint, groupAnchorPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT"
                unitSpacing = -spacingY
                groupSpacing = spacingX
                verticalSpacing = -spacingY-selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
                point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT"
                unitSpacing = -spacingY
                groupSpacing = -spacingX
                verticalSpacing = -spacingY-selectedLayoutTable["groupSpacing"]
            end

            P:Size(header, selectedLayoutTable["size"][1], selectedLayoutTable["size"][2]*5+abs(unitSpacing)*4)
            for j = 1, 5 do
                P:Size(header[j], selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
                header[j]:ClearAllPoints()

                if j == 1 then
                    header[j]:SetPoint(point)
                else
                    header[j]:SetPoint(point, header[j-1], anchorPoint, 0, unitSpacing)
                end
            end

            if i == 1 then
                header:SetPoint(point)
            else
                if i / selectedLayoutTable["columns"] > 1 then -- not the first row
                    header:SetPoint(point, layoutPreview.headers[shownGroups[i-selectedLayoutTable["columns"]]], anchorPoint, 0, verticalSpacing)
                else
                    header:SetPoint(point, layoutPreview.headers[shownGroups[i-1]], groupAnchorPoint, groupSpacing, 0)
                end
            end
        else
            -- anchor
            local point, anchorPoint, groupAnchorPoint, unitSpacing, groupSpacing, horizontalSpacing
            if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT"
                unitSpacing = spacingX
                groupSpacing = spacingY
                horizontalSpacing = spacingX+selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT"
                unitSpacing = -spacingX
                groupSpacing = spacingY
                horizontalSpacing = -spacingX-selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
                point, anchorPoint, groupAnchorPoint = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT"
                unitSpacing = spacingX
                groupSpacing = -spacingY
                horizontalSpacing = spacingX+selectedLayoutTable["groupSpacing"]
            elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
                point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "TOPLEFT", "BOTTOMRIGHT"
                unitSpacing = -spacingX
                groupSpacing = -spacingY
                horizontalSpacing = -spacingX-selectedLayoutTable["groupSpacing"]
            end

            P:Size(header, selectedLayoutTable["size"][1]*5+abs(unitSpacing)*4, selectedLayoutTable["size"][2])
            for j = 1, 5 do
                P:Size(header[j], selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
                header[j]:ClearAllPoints()

                if j == 1 then
                    header[j]:SetPoint(point)
                else
                    header[j]:SetPoint(point, header[j-1], anchorPoint, unitSpacing, 0)
                end
            end

            if i == 1 then
                header:SetPoint(point)
            else
                if i / selectedLayoutTable["rows"] > 1 then -- not the first column
                    header:SetPoint(point, layoutPreview.headers[shownGroups[i-selectedLayoutTable["rows"]]], anchorPoint, horizontalSpacing, 0)
                else
                    header:SetPoint(point, layoutPreview.headers[shownGroups[i-1]], groupAnchorPoint, 0, groupSpacing)
                end
            end
        end
    end

    -- update group filter
    if previewMode ~= 1 then
        for i = 1, 8 do
            if selectedLayoutTable["groupFilter"][i] then
                layoutPreview.headers[i]:Show()
            else
                layoutPreview.headers[i]:Hide()
            end
        end
    else -- party
        layoutPreview.headers[1]:Show()
        for i = 2, 8 do
            layoutPreview.headers[i]:Hide()
        end
    end

    if not layoutPreview:IsShown() then
        layoutPreview.fadeIn:Play()
    end
    
    if layoutPreview.fadeOut:IsPlaying() then
        layoutPreview.fadeOut:Stop()
    end

    if layoutPreview.timer then
        layoutPreview.timer:Cancel()
    end

    if previewMode == 0 then
        layoutPreview.timer = C_Timer.NewTimer(1, function()
            layoutPreview.fadeOut:Play()
            layoutPreview.timer = nil
        end)
    end
end

-------------------------------------------------
-- npc preview
-------------------------------------------------
local npcPreview, npcPreviewAnchor, npcPreviewName
local function CreateNPCPreview()
    npcPreview = Cell:CreateFrame("CellNPCPreviewFrame", Cell.frames.mainFrame, nil, nil, true)
    npcPreview:EnableMouse(false)
    npcPreview:SetFrameStrata("MEDIUM")
    npcPreview:SetToplevel(true)
    npcPreview:Hide()

    npcPreviewAnchor = CreateFrame("Frame", "CellNPCPreviewAnchorFrame", npcPreview, "BackdropTemplate")
    P:Size(npcPreviewAnchor, 20, 10)
    npcPreviewAnchor:SetMovable(true)
    npcPreviewAnchor:EnableMouse(true)
    npcPreviewAnchor:RegisterForDrag("LeftButton")
    npcPreviewAnchor:SetClampedToScreen(true)
    Cell:StylizeFrame(npcPreviewAnchor, {0, 1, 0, 0.4})
    npcPreviewAnchor:Hide()
    npcPreviewAnchor:SetScript("OnDragStart", function()
        npcPreviewAnchor:StartMoving()
        npcPreviewAnchor:SetUserPlaced(false)
    end)
    npcPreviewAnchor:SetScript("OnDragStop", function()
        npcPreviewAnchor:StopMovingOrSizing()
        P:SavePosition(npcPreviewAnchor, selectedLayoutTable["friendlyNPC"][3])
    end)

    npcPreviewName = npcPreviewAnchor:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS_TITLE")

    npcPreview.fadeIn = npcPreview:CreateAnimationGroup()
    local fadeIn = npcPreview.fadeIn:CreateAnimation("alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.5)
    fadeIn:SetSmoothing("OUT")
    fadeIn:SetScript("OnPlay", function()
        npcPreview:Show()
    end)
    
    npcPreview.fadeOut = npcPreview:CreateAnimationGroup()
    local fadeOut = npcPreview.fadeOut:CreateAnimation("alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.5)
    fadeOut:SetSmoothing("IN")
    fadeOut:SetScript("OnFinished", function()
        npcPreview:Hide()
    end)

    local desaturation = {
        [1] = 1,
        [2] = 0.85,
        [3] = 0.7,
        [4] = 0.55,
        [5] = 0.4,
    }

    npcPreview.header = CreateFrame("Frame", "CellNPCPreviewFrameHeader", npcPreview)
    for i = 1, 5 do
        npcPreview.header[i] = npcPreview.header:CreateTexture(nil, "BACKGROUND")
        npcPreview.header[i]:SetColorTexture(0, 0, 0)
        npcPreview.header[i]:SetAlpha(0.555)

        npcPreview.header[i].tex = npcPreview.header:CreateTexture(nil, "ARTWORK")
        npcPreview.header[i].tex:SetTexture("Interface\\Buttons\\WHITE8x8")

        npcPreview.header[i].tex:SetPoint("TOPLEFT", npcPreview.header[i], "TOPLEFT", P:Scale(1), P:Scale(-1))
        npcPreview.header[i].tex:SetPoint("BOTTOMRIGHT", npcPreview.header[i], "BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

        npcPreview.header[i].tex:SetVertexColor(F:ConvertRGB(255, 255, 255, desaturation[i])) -- White
        npcPreview.header[i].tex:SetAlpha(0.555)
    end
end

local function UpdateNPCPreview()
    if not npcPreview then
        CreateNPCPreview()
    end

    if not selectedLayoutTable["friendlyNPC"][1] or not selectedLayoutTable["friendlyNPC"][2] then
        if npcPreview.timer then
            npcPreview.timer:Cancel()
            npcPreview.timer = nil
        end
        if npcPreview.fadeIn:IsPlaying() then
            npcPreview.fadeIn:Stop()
        end
        if not npcPreview.fadeOut:IsPlaying() then
            npcPreview.fadeOut:Play()
        end
        return
    end

    -- update npcPreview point
    P:Size(npcPreview, selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
    npcPreview:ClearAllPoints()
    npcPreviewName:ClearAllPoints()
    
    if CellDB["general"]["menuPosition"] == "top_bottom" then
        P:Size(npcPreviewAnchor, 20, 10)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            npcPreview:SetPoint("BOTTOMLEFT", npcPreviewAnchor, "TOPLEFT", 0, 4)
            npcPreviewName:SetPoint("LEFT", npcPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            npcPreview:SetPoint("BOTTOMRIGHT", npcPreviewAnchor, "TOPRIGHT", 0, 4)
            npcPreviewName:SetPoint("RIGHT", npcPreviewAnchor, "LEFT", -5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            npcPreview:SetPoint("TOPLEFT", npcPreviewAnchor, "BOTTOMLEFT", 0, -4)
            npcPreviewName:SetPoint("LEFT", npcPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            npcPreview:SetPoint("TOPRIGHT", npcPreviewAnchor, "BOTTOMRIGHT", 0, -4)
            npcPreviewName:SetPoint("RIGHT", npcPreviewAnchor, "LEFT", -5, 0)
        end
    else
        P:Size(npcPreviewAnchor, 10, 20)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            npcPreview:SetPoint("BOTTOMLEFT", npcPreviewAnchor, "BOTTOMRIGHT", 4, 0)
            npcPreviewName:SetPoint("TOPLEFT", npcPreviewAnchor, "BOTTOMLEFT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            npcPreview:SetPoint("BOTTOMRIGHT", npcPreviewAnchor, "BOTTOMLEFT", -4, 0)
            npcPreviewName:SetPoint("TOPRIGHT", npcPreviewAnchor, "BOTTOMRIGHT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            npcPreview:SetPoint("TOPLEFT", npcPreviewAnchor, "TOPRIGHT", 4, 0)
            npcPreviewName:SetPoint("BOTTOMLEFT", npcPreviewAnchor, "TOPLEFT", 0, 5)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            npcPreview:SetPoint("TOPRIGHT", npcPreviewAnchor, "TOPLEFT", -4, 0)
            npcPreviewName:SetPoint("BOTTOMRIGHT", npcPreviewAnchor, "TOPRIGHT", 0, 5)
        end
    end

    -- update npcAnchor point
    if selectedLayout == Cell.vars.currentLayout then
        -- NOTE: move separate npc anchor with preview
        Cell.frames.separateNpcFrameAnchor:SetAllPoints(npcPreviewAnchor)
    else
        P:LoadPosition(Cell.frames.separateNpcFrameAnchor, Cell.vars.currentLayoutTable["friendlyNPC"][3])
    end

    if #selectedLayoutTable["friendlyNPC"][3] == 2 then
        P:LoadPosition(npcPreviewAnchor, selectedLayoutTable["friendlyNPC"][3])
    else
        npcPreviewAnchor:ClearAllPoints()
        npcPreviewAnchor:SetPoint("TOPLEFT", UIParent, "CENTER")
    end
    npcPreviewAnchor:Show()
    npcPreviewName:SetText(L["Layout"]..": "..selectedLayout.." (NPC)")
    npcPreviewName:Show()

    -- re-arrange
    local header = npcPreview.header
    header:ClearAllPoints()

    local spacingX = selectedLayoutTable["spacingX"]
    local spacingY = selectedLayoutTable["spacingY"]

    if selectedLayoutTable["orientation"] == "vertical" then
        -- anchor
        local point, anchorPoint, unitSpacing
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "TOPLEFT"
            unitSpacing = spacingY
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "TOPRIGHT"
            unitSpacing = spacingY
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "BOTTOMLEFT"
            unitSpacing = -spacingY
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "BOTTOMRIGHT"
            unitSpacing = -spacingY
        end

        P:Size(header, selectedLayoutTable["size"][1], selectedLayoutTable["size"][2]*5+abs(unitSpacing)*4)
        header:SetPoint(point)
        
        for i = 1, 5 do
            P:Size(header[i], selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, 0, unitSpacing)
            end
        end
    else
        -- anchor
        local point, anchorPoint, unitSpacing
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT"
            unitSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT"
            unitSpacing = -spacingX
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "TOPRIGHT"
            unitSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "TOPLEFT"
            unitSpacing = -spacingX
        end

        P:Size(header, selectedLayoutTable["size"][1]*5+abs(unitSpacing)*4, selectedLayoutTable["size"][2])
        header:SetPoint(point)

        for i = 1, 5 do
            P:Size(header[i], selectedLayoutTable["size"][1], selectedLayoutTable["size"][2])
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, unitSpacing, 0)
            end
        end
    end

    if not npcPreview:IsShown() then
        npcPreview.fadeIn:Play()
    end
    
    if npcPreview.fadeOut:IsPlaying() then
        npcPreview.fadeOut:Stop()
    end

    if npcPreview.timer then
        npcPreview.timer:Cancel()
    end

    if previewMode == 0 then
        npcPreview.timer = C_Timer.NewTimer(1, function()
            npcPreview.fadeOut:Play()
            npcPreview.timer = nil
        end)
    end
end

-------------------------------------------------
-- raidpet preview
-------------------------------------------------
local raidPetPreview, raidPetPreviewAnchor, raidPetPreviewName
local function CreateRaidPetPreview()
    raidPetPreview = Cell:CreateFrame("CellRaidPetPreviewFrame", Cell.frames.mainFrame, nil, nil, true)
    raidPetPreview:EnableMouse(false)
    raidPetPreview:SetFrameStrata("MEDIUM")
    raidPetPreview:SetToplevel(true)
    raidPetPreview:Hide()

    raidPetPreviewAnchor = CreateFrame("Frame", "CellRaidPetPreviewAnchorFrame", raidPetPreview, "BackdropTemplate")
    P:Size(raidPetPreviewAnchor, 20, 10)
    raidPetPreviewAnchor:SetMovable(true)
    raidPetPreviewAnchor:EnableMouse(true)
    raidPetPreviewAnchor:RegisterForDrag("LeftButton")
    raidPetPreviewAnchor:SetClampedToScreen(true)
    Cell:StylizeFrame(raidPetPreviewAnchor, {0, 1, 0, 0.4})
    raidPetPreviewAnchor:Hide()
    raidPetPreviewAnchor:SetScript("OnDragStart", function()
        raidPetPreviewAnchor:StartMoving()
        raidPetPreviewAnchor:SetUserPlaced(false)
    end)
    raidPetPreviewAnchor:SetScript("OnDragStop", function()
        raidPetPreviewAnchor:StopMovingOrSizing()
        P:SavePosition(raidPetPreviewAnchor, selectedLayoutTable["pet"][3])
    end)

    raidPetPreviewName = raidPetPreviewAnchor:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS_TITLE")

    raidPetPreview.fadeIn = raidPetPreview:CreateAnimationGroup()
    local fadeIn = raidPetPreview.fadeIn:CreateAnimation("alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.5)
    fadeIn:SetSmoothing("OUT")
    fadeIn:SetScript("OnPlay", function()
        raidPetPreview:Show()
    end)
    
    raidPetPreview.fadeOut = raidPetPreview:CreateAnimationGroup()
    local fadeOut = raidPetPreview.fadeOut:CreateAnimation("alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.5)
    fadeOut:SetSmoothing("IN")
    fadeOut:SetScript("OnFinished", function()
        raidPetPreview:Hide()
    end)

    local desaturation = {
        [1] = 1,
        [2] = 0.85,
        [3] = 0.7,
        [4] = 0.55,
        [0] = 0.4,
    }

    raidPetPreview.header = CreateFrame("Frame", "CellRaidPetPreviewFrameHeader", raidPetPreview)
    for i = 1, 20 do
        raidPetPreview.header[i] = raidPetPreview.header:CreateTexture(nil, "BACKGROUND")
        raidPetPreview.header[i]:SetColorTexture(0, 0, 0)
        raidPetPreview.header[i]:SetAlpha(0.555)

        raidPetPreview.header[i].tex = raidPetPreview.header:CreateTexture(nil, "ARTWORK")
        raidPetPreview.header[i].tex:SetTexture("Interface\\Buttons\\WHITE8x8")

        raidPetPreview.header[i].tex:SetPoint("TOPLEFT", raidPetPreview.header[i], "TOPLEFT", P:Scale(1), P:Scale(-1))
        raidPetPreview.header[i].tex:SetPoint("BOTTOMRIGHT", raidPetPreview.header[i], "BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

        raidPetPreview.header[i].tex:SetVertexColor(F:ConvertRGB(127, 127, 255, desaturation[i%5]))
        raidPetPreview.header[i].tex:SetAlpha(0.555)
    end
end

local function UpdateRaidPetPreview()
    if not raidPetPreview then
        CreateRaidPetPreview()
    end

    if not selectedLayoutTable["pet"][2] then
        if raidPetPreview.timer then
            raidPetPreview.timer:Cancel()
            raidPetPreview.timer = nil
        end
        if raidPetPreview.fadeIn:IsPlaying() then
            raidPetPreview.fadeIn:Stop()
        end
        if not raidPetPreview.fadeOut:IsPlaying() then
            raidPetPreview.fadeOut:Play()
        end
        return
    end

    local width, height
    if selectedLayoutTable["pet"][4] then
        width, height = unpack(selectedLayoutTable["pet"][5])
    else
        width, height = unpack(selectedLayoutTable["size"])
    end
    P:Size(raidPetPreview, width, height)

    -- update raidPetPreview point
    raidPetPreview:ClearAllPoints()
    raidPetPreviewName:ClearAllPoints()
    
    if CellDB["general"]["menuPosition"] == "top_bottom" then
        P:Size(raidPetPreviewAnchor, 20, 10)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            raidPetPreview:SetPoint("BOTTOMLEFT", raidPetPreviewAnchor, "TOPLEFT", 0, 4)
            raidPetPreviewName:SetPoint("LEFT", raidPetPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            raidPetPreview:SetPoint("BOTTOMRIGHT", raidPetPreviewAnchor, "TOPRIGHT", 0, 4)
            raidPetPreviewName:SetPoint("RIGHT", raidPetPreviewAnchor, "LEFT", -5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            raidPetPreview:SetPoint("TOPLEFT", raidPetPreviewAnchor, "BOTTOMLEFT", 0, -4)
            raidPetPreviewName:SetPoint("LEFT", raidPetPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            raidPetPreview:SetPoint("TOPRIGHT", raidPetPreviewAnchor, "BOTTOMRIGHT", 0, -4)
            raidPetPreviewName:SetPoint("RIGHT", raidPetPreviewAnchor, "LEFT", -5, 0)
        end
    else
        P:Size(raidPetPreviewAnchor, 10, 20)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            raidPetPreview:SetPoint("BOTTOMLEFT", raidPetPreviewAnchor, "BOTTOMRIGHT", 4, 0)
            raidPetPreviewName:SetPoint("TOPLEFT", raidPetPreviewAnchor, "BOTTOMLEFT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            raidPetPreview:SetPoint("BOTTOMRIGHT", raidPetPreviewAnchor, "BOTTOMLEFT", -4, 0)
            raidPetPreviewName:SetPoint("TOPRIGHT", raidPetPreviewAnchor, "BOTTOMRIGHT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            raidPetPreview:SetPoint("TOPLEFT", raidPetPreviewAnchor, "TOPRIGHT", 4, 0)
            raidPetPreviewName:SetPoint("BOTTOMLEFT", raidPetPreviewAnchor, "TOPLEFT", 0, 5)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            raidPetPreview:SetPoint("TOPRIGHT", raidPetPreviewAnchor, "TOPLEFT", -4, 0)
            raidPetPreviewName:SetPoint("BOTTOMRIGHT", raidPetPreviewAnchor, "TOPRIGHT", 0, 5)
        end
    end

    -- update anchor point
    if selectedLayout == Cell.vars.currentLayout then
        -- NOTE: move anchor with preview
        CellRaidPetAnchorFrame:SetAllPoints(raidPetPreviewAnchor)
    else
        P:LoadPosition(CellRaidPetAnchorFrame, Cell.vars.currentLayoutTable["pet"][3])
    end

    if #selectedLayoutTable["pet"][3] == 2 then
        P:LoadPosition(raidPetPreviewAnchor, selectedLayoutTable["pet"][3])
    else
        raidPetPreviewAnchor:ClearAllPoints()
        raidPetPreviewAnchor:SetPoint("TOPLEFT", UIParent, "CENTER")
    end
    raidPetPreviewAnchor:Show()
    raidPetPreviewName:SetText(L["Layout"]..": "..selectedLayout.." ("..L["Raid Pets"]..")")
    raidPetPreviewName:Show()

    -- re-arrange
    local header = raidPetPreview.header
    header:ClearAllPoints()

    local spacingX = selectedLayoutTable["spacingX"]
    local spacingY = selectedLayoutTable["spacingY"]

    if selectedLayoutTable["orientation"] == "vertical" then
        -- anchor
        local point, anchorPoint, groupAnchorPoint, unitSpacing, groupSpacing
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT"
            unitSpacing = spacingY
            groupSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT"
            unitSpacing = spacingY
            groupSpacing = -spacingX
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            point, anchorPoint, groupAnchorPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT"
            unitSpacing = -spacingY
            groupSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT"
            unitSpacing = -spacingY
            groupSpacing = -spacingX
        end

        P:Size(header, width*4+abs(unitSpacing)*3, height*5+abs(unitSpacing)*4)
        header:SetPoint(point)
        
        for i = 1, 20 do
            P:Size(header[i], width, height)
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            elseif i % 5 == 1 then
                header[i]:SetPoint(point, header[i-5], groupAnchorPoint, groupSpacing, 0)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, 0, unitSpacing)
            end
        end
    else
        -- anchor
        local point, anchorPoint, groupAnchorPoint, unitSpacing, groupSpacing
            if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT", "TOPLEFT"
                unitSpacing = spacingX
                groupSpacing = spacingY
            elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
                point, anchorPoint, groupAnchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT"
                unitSpacing = -spacingX
                groupSpacing = spacingY
            elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
                point, anchorPoint, groupAnchorPoint = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT"
                unitSpacing = spacingX
                groupSpacing = -spacingY
            elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
                point, anchorPoint, groupAnchorPoint = "TOPRIGHT", "TOPLEFT", "BOTTOMRIGHT"
                unitSpacing = -spacingX
                groupSpacing = -spacingY
            end

        P:Size(header, width*5+abs(unitSpacing)*4, height*4+abs(unitSpacing)*3)
        header:SetPoint(point)

        for i = 1, 20 do
            P:Size(header[i], width, height)
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            elseif i % 5 == 1 then
                header[i]:SetPoint(point, header[i-5], groupAnchorPoint, 0, groupSpacing)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, unitSpacing, 0)
            end
        end
    end

    if not raidPetPreview:IsShown() then
        raidPetPreview.fadeIn:Play()
    end
    
    if raidPetPreview.fadeOut:IsPlaying() then
        raidPetPreview.fadeOut:Stop()
    end

    if raidPetPreview.timer then
        raidPetPreview.timer:Cancel()
    end

    if previewMode == 0 then
        raidPetPreview.timer = C_Timer.NewTimer(1, function()
            raidPetPreview.fadeOut:Play()
            raidPetPreview.timer = nil
        end)
    end
end

-------------------------------------------------
-- spotlight preview
-------------------------------------------------
local spotlightPreview, spotlightPreviewAnchor, spotlightPreviewName
local function CreateSpotlightPreview()
    spotlightPreview = Cell:CreateFrame("CellSpotlightPreviewFrame", Cell.frames.mainFrame, nil, nil, true)
    spotlightPreview:EnableMouse(false)
    spotlightPreview:SetFrameStrata("MEDIUM")
    spotlightPreview:SetToplevel(true)
    spotlightPreview:Hide()

    spotlightPreviewAnchor = CreateFrame("Frame", "CellSpotlightPreviewAnchorFrame", spotlightPreview, "BackdropTemplate")
    P:Size(spotlightPreviewAnchor, 20, 10)
    spotlightPreviewAnchor:SetMovable(true)
    spotlightPreviewAnchor:EnableMouse(true)
    spotlightPreviewAnchor:RegisterForDrag("LeftButton")
    spotlightPreviewAnchor:SetClampedToScreen(true)
    Cell:StylizeFrame(spotlightPreviewAnchor, {0, 1, 0, 0.4})
    spotlightPreviewAnchor:Hide()
    spotlightPreviewAnchor:SetScript("OnDragStart", function()
        spotlightPreviewAnchor:StartMoving()
        spotlightPreviewAnchor:SetUserPlaced(false)
    end)
    spotlightPreviewAnchor:SetScript("OnDragStop", function()
        spotlightPreviewAnchor:StopMovingOrSizing()
        P:SavePosition(spotlightPreviewAnchor, selectedLayoutTable["spotlight"][3])
    end)

    spotlightPreviewName = spotlightPreviewAnchor:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS_TITLE")

    spotlightPreview.fadeIn = spotlightPreview:CreateAnimationGroup()
    local fadeIn = spotlightPreview.fadeIn:CreateAnimation("alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.5)
    fadeIn:SetSmoothing("OUT")
    fadeIn:SetScript("OnPlay", function()
        spotlightPreview:Show()
    end)
    
    spotlightPreview.fadeOut = spotlightPreview:CreateAnimationGroup()
    local fadeOut = spotlightPreview.fadeOut:CreateAnimation("alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.5)
    fadeOut:SetSmoothing("IN")
    fadeOut:SetScript("OnFinished", function()
        spotlightPreview:Hide()
    end)

    local desaturation = {
        [1] = 1,
        [2] = 0.85,
        [3] = 0.7,
        [4] = 0.55,
        [5] = 0.4,
    }

    spotlightPreview.header = CreateFrame("Frame", "CellSpotlightPreviewFrameHeader", spotlightPreview)
    for i = 1, 5 do
        spotlightPreview.header[i] = spotlightPreview.header:CreateTexture(nil, "BACKGROUND")
        spotlightPreview.header[i]:SetColorTexture(0, 0, 0)
        spotlightPreview.header[i]:SetAlpha(0.555)

        spotlightPreview.header[i].tex = spotlightPreview.header:CreateTexture(nil, "ARTWORK")
        spotlightPreview.header[i].tex:SetTexture("Interface\\Buttons\\WHITE8x8")

        spotlightPreview.header[i].tex:SetPoint("TOPLEFT", spotlightPreview.header[i], "TOPLEFT", P:Scale(1), P:Scale(-1))
        spotlightPreview.header[i].tex:SetPoint("BOTTOMRIGHT", spotlightPreview.header[i], "BOTTOMRIGHT", P:Scale(-1), P:Scale(1))

        spotlightPreview.header[i].tex:SetVertexColor(F:ConvertRGB(255, 0, 102, desaturation[i])) -- cyan
        spotlightPreview.header[i].tex:SetAlpha(0.555)
    end
end

local function UpdateSpotlightPreview()
    if not spotlightPreview then
        CreateSpotlightPreview()
    end

    if not selectedLayoutTable["spotlight"][1] then
        if spotlightPreview.timer then
            spotlightPreview.timer:Cancel()
            spotlightPreview.timer = nil
        end
        if spotlightPreview.fadeIn:IsPlaying() then
            spotlightPreview.fadeIn:Stop()
        end
        if not spotlightPreview.fadeOut:IsPlaying() then
            spotlightPreview.fadeOut:Play()
        end
        return
    end

    local width, height
    if selectedLayoutTable["spotlight"][4] then
        width, height = unpack(selectedLayoutTable["spotlight"][5])
    else
        width, height = unpack(selectedLayoutTable["size"])
    end

    -- update spotlightPreview point
    P:Size(spotlightPreview, width, height)
    spotlightPreview:ClearAllPoints()
    spotlightPreviewName:ClearAllPoints()
    
    if CellDB["general"]["menuPosition"] == "top_bottom" then
        P:Size(spotlightPreviewAnchor, 20, 10)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            spotlightPreview:SetPoint("BOTTOMLEFT", spotlightPreviewAnchor, "TOPLEFT", 0, 4)
            spotlightPreviewName:SetPoint("LEFT", spotlightPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            spotlightPreview:SetPoint("BOTTOMRIGHT", spotlightPreviewAnchor, "TOPRIGHT", 0, 4)
            spotlightPreviewName:SetPoint("RIGHT", spotlightPreviewAnchor, "LEFT", -5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            spotlightPreview:SetPoint("TOPLEFT", spotlightPreviewAnchor, "BOTTOMLEFT", 0, -4)
            spotlightPreviewName:SetPoint("LEFT", spotlightPreviewAnchor, "RIGHT", 5, 0)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            spotlightPreview:SetPoint("TOPRIGHT", spotlightPreviewAnchor, "BOTTOMRIGHT", 0, -4)
            spotlightPreviewName:SetPoint("RIGHT", spotlightPreviewAnchor, "LEFT", -5, 0)
        end
    else
        P:Size(spotlightPreviewAnchor, 10, 20)
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            spotlightPreview:SetPoint("BOTTOMLEFT", spotlightPreviewAnchor, "BOTTOMRIGHT", 4, 0)
            spotlightPreviewName:SetPoint("TOPLEFT", spotlightPreviewAnchor, "BOTTOMLEFT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            spotlightPreview:SetPoint("BOTTOMRIGHT", spotlightPreviewAnchor, "BOTTOMLEFT", -4, 0)
            spotlightPreviewName:SetPoint("TOPRIGHT", spotlightPreviewAnchor, "BOTTOMRIGHT", 0, -5)
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            spotlightPreview:SetPoint("TOPLEFT", spotlightPreviewAnchor, "TOPRIGHT", 4, 0)
            spotlightPreviewName:SetPoint("BOTTOMLEFT", spotlightPreviewAnchor, "TOPLEFT", 0, 5)
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            spotlightPreview:SetPoint("TOPRIGHT", spotlightPreviewAnchor, "TOPLEFT", -4, 0)
            spotlightPreviewName:SetPoint("BOTTOMRIGHT", spotlightPreviewAnchor, "TOPRIGHT", 0, 5)
        end
    end

    -- update preview anchor
    spotlightPreviewAnchor:ClearAllPoints()
    if selectedLayout == Cell.vars.currentLayout then
        spotlightPreviewAnchor:EnableMouse(false)
        spotlightPreviewAnchor:SetAllPoints(Cell.frames.spotlightFrameAnchor)
    else
        spotlightPreviewAnchor:EnableMouse(true)
        if not P:LoadPosition(spotlightPreviewAnchor, selectedLayoutTable["spotlight"][3]) then
            spotlightPreviewAnchor:SetPoint("TOPLEFT", UIParent, "CENTER")
        end
    end
    spotlightPreviewAnchor:Show()
    spotlightPreviewName:SetText(L["Layout"]..": "..selectedLayout.." ("..L["Spotlight Frame"]..")")
    spotlightPreviewName:Show()

    -- re-arrange
    local header = spotlightPreview.header
    header:ClearAllPoints()

    local spacingX = selectedLayoutTable["spacingX"]
    local spacingY = selectedLayoutTable["spacingY"]

    if selectedLayoutTable["orientation"] == "vertical" then
        -- anchor
        local point, anchorPoint, unitSpacing
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "TOPLEFT"
            unitSpacing = spacingY
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "TOPRIGHT"
            unitSpacing = spacingY
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "BOTTOMLEFT"
            unitSpacing = -spacingY
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "BOTTOMRIGHT"
            unitSpacing = -spacingY
        end

        P:Size(header, width, height*5+abs(unitSpacing)*4)
        header:SetPoint(point)
        
        for i = 1, 5 do
            P:Size(header[i], width, height)
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, 0, unitSpacing)
            end
        end
    else
        -- anchor
        local point, anchorPoint, unitSpacing
        if selectedLayoutTable["anchor"] == "BOTTOMLEFT" then
            point, anchorPoint = "BOTTOMLEFT", "BOTTOMRIGHT"
            unitSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "BOTTOMRIGHT" then
            point, anchorPoint = "BOTTOMRIGHT", "BOTTOMLEFT"
            unitSpacing = -spacingX
        elseif selectedLayoutTable["anchor"] == "TOPLEFT" then
            point, anchorPoint = "TOPLEFT", "TOPRIGHT"
            unitSpacing = spacingX
        elseif selectedLayoutTable["anchor"] == "TOPRIGHT" then
            point, anchorPoint = "TOPRIGHT", "TOPLEFT"
            unitSpacing = -spacingX
        end

        P:Size(header, width*5+abs(unitSpacing)*4, height)
        header:SetPoint(point)

        for i = 1, 5 do
            P:Size(header[i], width, height)
            header[i]:ClearAllPoints()

            if i == 1 then
                header[i]:SetPoint(point)
            else
                header[i]:SetPoint(point, header[i-1], anchorPoint, unitSpacing, 0)
            end
        end
    end

    if not spotlightPreview:IsShown() then
        spotlightPreview.fadeIn:Play()
    end
    
    if spotlightPreview.fadeOut:IsPlaying() then
        spotlightPreview.fadeOut:Stop()
    end

    if spotlightPreview.timer then
        spotlightPreview.timer:Cancel()
    end

    if previewMode == 0 then
        spotlightPreview.timer = C_Timer.NewTimer(1, function()
            spotlightPreview.fadeOut:Play()
            spotlightPreview.timer = nil
        end)
    end
end

-------------------------------------------------
-- OnHide
-------------------------------------------------
layoutsTab:SetScript("OnHide", function()
    if layoutPreview.timer then
        layoutPreview.timer:Cancel()
        layoutPreview.timer = nil
    end
    if layoutPreview.fadeIn:IsPlaying() then
        layoutPreview.fadeIn:Stop()
    end
    if not layoutPreview.fadeOut:IsPlaying() then
        layoutPreview.fadeOut:Play()
    end
   
    if npcPreview.timer then
        npcPreview.timer:Cancel()
        npcPreview.timer = nil
    end
    if npcPreview.fadeIn:IsPlaying() then
        npcPreview.fadeIn:Stop()
    end
    if not npcPreview.fadeOut:IsPlaying() then
        npcPreview.fadeOut:Play()
    end

    if raidPetPreview.timer then
        raidPetPreview.timer:Cancel()
        raidPetPreview.timer = nil
    end
    if raidPetPreview.fadeIn:IsPlaying() then
        raidPetPreview.fadeIn:Stop()
    end
    if not raidPetPreview.fadeOut:IsPlaying() then
        raidPetPreview.fadeOut:Play()
    end
    
    if spotlightPreview.timer then
        spotlightPreview.timer:Cancel()
        spotlightPreview.timer = nil
    end
    if spotlightPreview.fadeIn:IsPlaying() then
        spotlightPreview.fadeIn:Stop()
    end
    if not spotlightPreview.fadeOut:IsPlaying() then
        spotlightPreview.fadeOut:Play()
    end
end)

-------------------------------------------------
-- layout
-------------------------------------------------
local layoutDropdown, roleDropdown, partyDropdown, raidOutdoorDropdown, raidInstanceDropdown, raidMythicDropdown, arenaDropdown, bg15Dropdown, bg40Dropdown
local raid10Dropdown, raid25Dropdown -- wrath
local LoadLayoutDropdown, LoadAutoSwitchDropdowns
local LoadLayoutDB, UpdateButtonStates, LoadLayoutAutoSwitchDB

-- local enabledLayoutText
-- local function UpdateEnabledLayoutText()
--     enabledLayoutText:SetText("|cFF777777"..L["Current"]..": "..(Cell.vars.currentLayout == "default" and _G.DEFAULT or Cell.vars.currentLayout))
-- end

local function CreateLayoutPane()
    local layoutPane = Cell:CreateTitledPane(layoutsTab, L["Layout"], 205, 80)
    layoutPane:SetPoint("TOPLEFT", 5, -5)

    -- enabledLayoutText = layoutPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    -- enabledLayoutText:SetPoint("BOTTOMRIGHT", layoutPane.line, "TOPRIGHT", 0, P:Scale(2))
    -- enabledLayoutText:SetPoint("LEFT", layoutPane.title, "RIGHT", 5, 0)
    -- enabledLayoutText:SetWordWrap(false)
    -- enabledLayoutText:SetJustifyH("LEFT")

    layoutDropdown = Cell:CreateDropdown(layoutPane, 193)
    layoutDropdown:SetPoint("TOPLEFT", 5, -27)

    -- new
    local newBtn = Cell:CreateButton(layoutPane, nil, "green-hover", {33, 20}, nil, nil, nil, nil, nil, L["New"])
    newBtn:SetPoint("TOPLEFT", layoutDropdown, "BOTTOMLEFT", 0, -10)
    newBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\create", {16, 16}, {"CENTER", 0, 0})
    newBtn:SetScript("OnClick", function()
        local popup = Cell:CreateConfirmPopup(layoutsTab, 200, L["Create new layout"], function(self)
            local name = strtrim(self.editBox:GetText())
            local inherit = self.dropdown1:GetSelected()

            if name ~= "" and strlower(name) ~= "default" and name ~= _G.DEFAULT and strlower(name) ~= "none" and not CellDB["layouts"][name] then
                -- update db copy current layout
                if inherit == "cell-default-layout" then
                    CellDB["layouts"][name] = F:Copy(Cell.defaults.layout)
                else
                    CellDB["layouts"][name] = F:Copy(CellDB["layouts"][inherit])
                end
                -- update dropdown
                layoutDropdown:AddItem({
                    ["text"] = name,
                    ["value"] = name,
                    ["onClick"] = function()
                        LoadLayoutDB(name)
                        UpdateButtonStates()
                    end,
                })
                layoutDropdown:SetSelected(name)
                LoadAutoSwitchDropdowns()
                LoadLayoutDB(name)
                UpdateButtonStates()
                F:Print(L["Layout added: "]..name..".")
            else
                F:Print(L["Invalid layout name."])
            end
        end, nil, true, true, 1)
        popup:SetPoint("TOPLEFT", 117, -70)

        -- layout inherits
        local inherits = {
            {
                ["text"] = L["Default layout"],
                ["value"] = "cell-default-layout",
            }
        }

        -- add "Inherit: default" to second
        tinsert(inherits, {
            ["text"] = L["Inherit: "] .. _G.DEFAULT,
            ["value"] = "default",
        })

        for name in pairs(CellDB["layouts"]) do
            if name ~= "default" then
                tinsert(inherits, {
                    ["text"] = L["Inherit: "] .. name,
                    ["value"] = name, 
                })
            end
        end

        popup.dropdown1:SetItems(inherits)
        popup.dropdown1:SetSelectedItem(1)
    end)
    Cell:RegisterForCloseDropdown(newBtn)

    -- rename
    local renameBtn = Cell:CreateButton(layoutPane, nil, "blue-hover", {33, 20}, nil, nil, nil, nil, nil, L["Rename"])
    renameBtn:SetPoint("TOPLEFT", newBtn, "TOPRIGHT", P:Scale(-1), 0)
    renameBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\rename", {16, 16}, {"CENTER", 0, 0})
    renameBtn:SetScript("OnClick", function()
        local popup = Cell:CreateConfirmPopup(layoutsTab, 200, L["Rename layout"].." "..selectedLayout, function(self)
            local name = strtrim(self.editBox:GetText())
            if name ~= "" and strlower(name) ~= "default" and name ~= _G.DEFAULT and not CellDB["layouts"][name] then
                -- update db
                CellDB["layouts"][name] = CellDB["layouts"][selectedLayout]
                CellDB["layouts"][selectedLayout] = nil
                F:Print(L["Layout renamed: "].." "..selectedLayout.." "..L["to"].." "..name..".")
                
                -- update auto switch dropdowns
                LoadAutoSwitchDropdowns()
                for role, t in pairs(CellLayoutAutoSwitchTable) do
                    for groupType, layout in pairs(t) do
                        if layout == selectedLayout then
                            -- NOTE: rename
                            CellLayoutAutoSwitchTable[role][groupType] = name
                            -- update its dropdown selection
                            if groupType == "party" then
                                partyDropdown:SetSelected(name)
                            elseif groupType == "raid_outdoor" then
                                raidOutdoorDropdown:SetSelected(name)
                            elseif groupType == "raid_instance" then
                                raidInstanceDropdown:SetSelected(name)
                            elseif groupType == "raid_mythic" then
                                raidMythicDropdown:SetSelected(name)
                            elseif groupType == "raid10" then
                                raid10Dropdown:SetSelected(name)
                            elseif groupType == "raid25" then
                                raid25Dropdown:SetSelected(name)
                            elseif groupType == "arena" then
                                arenaDropdown:SetSelected(name)
                            elseif groupType == "battleground15" then
                                bg15Dropdown:SetSelected(name)
                            elseif groupType == "battleground40" then
                                bg40Dropdown:SetSelected(name)
                            end
                        end
                    end
                end

                -- update master-slave
                for layout, t in pairs(CellDB["layouts"]) do
                    if t["syncWith"] == selectedLayout then
                        t["syncWith"] = name
                    end
                end

                -- update if current
                if selectedLayout == Cell.vars.currentLayout then
                    -- update vars
                    Cell.vars.currentLayout = name
                    Cell.vars.currentLayoutTable = CellDB["layouts"][name]
                    -- update text
                    -- UpdateEnabledLayoutText()
                end

                -- update dropdown
                layoutDropdown:SetCurrentItem({
                    ["text"] = name,
                    ["value"] = name,
                    ["onClick"] = function()
                        LoadLayoutDB(name)
                        UpdateButtonStates()
                    end,
                })
                layoutDropdown:SetSelected(name)

                -- reload
                LoadLayoutDB(name)
            else
                F:Print(L["Invalid layout name."])
            end
        end, nil, true, true)
        popup:SetPoint("TOPLEFT", 117, -97)
    end)
    Cell:RegisterForCloseDropdown(renameBtn)

    -- delete
    local deleteBtn = Cell:CreateButton(layoutPane, nil, "red-hover", {33, 20}, nil, nil, nil, nil, nil, L["Delete"])
    deleteBtn:SetPoint("TOPLEFT", renameBtn, "TOPRIGHT", P:Scale(-1), 0)
    deleteBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\trash", {16, 16}, {"CENTER", 0, 0})
    deleteBtn:SetScript("OnClick", function()
        local popup = Cell:CreateConfirmPopup(layoutsTab, 200, L["Delete layout"].." "..selectedLayout.."?", function(self)
            -- update db
            CellDB["layouts"][selectedLayout] = nil
            F:Print(L["Layout deleted: "]..selectedLayout..".")

            -- update auto switch dropdowns
            LoadAutoSwitchDropdowns()
            for role, t in pairs(CellLayoutAutoSwitchTable) do
                for groupType, layout in pairs(t) do
                    if layout == selectedLayout then
                        -- NOTE: set to default
                        CellLayoutAutoSwitchTable[role][groupType] = "default"
                        -- update its dropdown selection
                        if groupType == "party" then
                            partyDropdown:SetSelectedValue("default")
                        elseif groupType == "raid_outdoor" then
                            raidOutdoorDropdown:SetSelectedValue("default")
                        elseif groupType == "raid_instance" then
                            raidInstanceDropdown:SetSelectedValue("default")
                        elseif groupType == "raid_mythic" then
                            raidMythicDropdown:SetSelectedValue("default")
                        elseif groupType == "raid10" then
                            raid10Dropdown:SetSelectedValue("default")
                        elseif groupType == "raid25" then
                            raid25Dropdown:SetSelectedValue("default")
                        elseif groupType == "arena" then
                            arenaDropdown:SetSelectedValue("default")
                        elseif groupType == "battleground15" then
                            bg15Dropdown:SetSelectedValue("default")
                        elseif groupType == "battleground40" then
                            bg40Dropdown:SetSelectedValue("default")
                        end
                    end
                end
            end

            -- update master-slave
            for layout, t in pairs(CellDB["layouts"]) do
                if t["syncWith"] == selectedLayout then
                    t["syncWith"] = nil
                end
            end

            -- set current to default
            if selectedLayout == Cell.vars.currentLayout then
                -- update vars
                Cell.vars.currentLayout = "default"
                Cell.vars.currentLayoutTable = CellDB["layouts"]["default"]
                Cell:Fire("UpdateLayout", "default")
                -- update text
                -- UpdateEnabledLayoutText()
            end

            -- update dropdown
            layoutDropdown:RemoveCurrentItem()
            layoutDropdown:SetSelectedValue("default")

            -- reload
            LoadLayoutDB("default")
            UpdateButtonStates()
        end, nil, true)
        popup:SetPoint("TOPLEFT", 117, -97)
    end)
    Cell:RegisterForCloseDropdown(deleteBtn)

    -- import
    local importBtn = Cell:CreateButton(layoutPane, nil, "accent-hover", {33, 20}, nil, nil, nil, nil, nil, L["Import"])
    importBtn:SetPoint("TOPLEFT", deleteBtn, "TOPRIGHT", P:Scale(-1), 0)
    importBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\import", {16, 16}, {"CENTER", 0, 0})
    importBtn:SetScript("OnClick", function()
        F:ShowLayoutImportFrame()
    end)

    -- export
    local exportBtn = Cell:CreateButton(layoutPane, nil, "accent-hover", {33, 20}, nil, nil, nil, nil, nil, L["Export"])
    exportBtn:SetPoint("TOPLEFT", importBtn, "TOPRIGHT", P:Scale(-1), 0)
    exportBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\export", {16, 16}, {"CENTER", 0, 0})
    exportBtn:SetScript("OnClick", function()
        F:ShowLayoutExportFrame(selectedLayout, selectedLayoutTable)
    end)

    UpdateButtonStates = function()
        if selectedLayout == "default" then
            deleteBtn:SetEnabled(false)
            renameBtn:SetEnabled(false)
        else
            deleteBtn:SetEnabled(true)
            renameBtn:SetEnabled(true)
        end
    end

    -- copy & paste
    local shareBtn = Cell:CreateButton(layoutPane, nil, "accent-hover", {33, 20}, nil, nil, nil, nil, nil, L["Share"])
    shareBtn:SetPoint("TOPLEFT", exportBtn, "TOPRIGHT", P:Scale(-1), 0)
    shareBtn:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\share", {16, 16}, {"CENTER", 0, 0})
    shareBtn:SetScript("OnClick", function()
        local editbox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editbox)
        editbox:SetText("[Cell:Layout: "..selectedLayout.." - "..Cell.vars.playerNameFull.."]")
    end)
end

-- drop down
LoadLayoutDropdown = function()
    local indices = {}
    for name, _ in pairs(CellDB["layouts"]) do
        if name ~= "default" then
            tinsert(indices, name)
        end
    end
    table.sort(indices)
    tinsert(indices, 1, "default") -- make default first

    local items = {}
    for _, value in pairs(indices) do
        table.insert(items, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                LoadLayoutDB(value)
                UpdateButtonStates()
            end,
        })
    end
    layoutDropdown:SetItems(items)
end

-------------------------------------------------
-- layout auto switch
-------------------------------------------------
local partyText, raidOutdoorText, raidInstanceText, raidMythicText, arenaText, bg15Text, bg40Text
local raid10Text, raid25Text

local raidOutdoor = L["Raid"].." "..L["Outdoor"]
local raidInstance = L["Raid"].." ".._G.INSTANCE
local raidMythic = L["Raid"].." ".._G.PLAYER_DIFFICULTY6

local function CreateAutoSwitchPane()
    local autoSwitchFrame = Cell:CreateFrame("CellLayoutAutoSwitchFrame", layoutsTab, 160, 410)
    autoSwitchFrame:SetPoint("TOPLEFT", layoutsTab, "TOPRIGHT", 5, 0)
    autoSwitchFrame:Show()

    local autoSwitchPane = Cell:CreateTitledPane(autoSwitchFrame, L["Layout Auto Switch"], 150, 400)
    autoSwitchPane:SetPoint("TOPLEFT", 5, -5)

    -- role
    roleDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    roleDropdown:SetPoint("TOPLEFT", 5, -27)

    if Cell.isRetail then
        roleDropdown:SetItems({
            {
                ["text"] = "|TInterface\\AddOns\\Cell\\Media\\Roles\\TANK:11|t "..TANK,
                ["value"] = "TANK",
                ["onClick"] = function()
                    selectedRole = "TANK"
                    LoadLayoutAutoSwitchDB(selectedRole)
                end,
            },
            {
                ["text"] = "|TInterface\\AddOns\\Cell\\Media\\Roles\\HEALER:11|t "..HEALER,
                ["value"] = "HEALER",
                ["onClick"] = function()
                    selectedRole = "HEALER"
                    LoadLayoutAutoSwitchDB(selectedRole)
                end,
            },
            {
                ["text"] = "|TInterface\\AddOns\\Cell\\Media\\Roles\\DAMAGER:11|t "..DAMAGER,
                ["value"] = "DAMAGER",
                ["onClick"] = function()
                    selectedRole = "DAMAGER"
                    LoadLayoutAutoSwitchDB(selectedRole)
                end,
            },
        })
    else
        roleDropdown:SetItems({
            {
                ["text"] = "|TInterface\\AddOns\\Cell\\Media\\Icons\\1:13|t "..L["Primary Talents"],
                ["value"] = 1,
                ["onClick"] = function()
                    selectedRole = 1
                    LoadLayoutAutoSwitchDB(selectedRole)
                end,
            },
            {
                ["text"] = "|TInterface\\AddOns\\Cell\\Media\\Icons\\2:13|t "..L["Secondary Talents"],
                ["value"] = 2,
                ["onClick"] = function()
                    selectedRole = 2
                    LoadLayoutAutoSwitchDB(selectedRole)
                end,
            },
        })
    end
    
    -- party
    partyDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    partyDropdown:SetPoint("TOPLEFT", roleDropdown, "BOTTOMLEFT", 0, -25)
    
    partyText = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    partyText:SetPoint("BOTTOMLEFT", partyDropdown, "TOPLEFT", 0, 1)
    partyText:SetText(L["Solo/Party"])
    
    -- outdoor
    raidOutdoorDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    raidOutdoorDropdown:SetPoint("TOPLEFT", partyDropdown, "BOTTOMLEFT", 0, -30)
    
    raidOutdoorText = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    raidOutdoorText:SetPoint("BOTTOMLEFT", raidOutdoorDropdown, "TOPLEFT", 0, 1)
    raidOutdoorText:SetText(raidOutdoor)

    if Cell.isRetail then
        -- instance
        raidInstanceDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
        raidInstanceDropdown:SetPoint("TOPLEFT", raidOutdoorDropdown, "BOTTOMLEFT", 0, -30)
        
        raidInstanceText = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
        raidInstanceText:SetPoint("BOTTOMLEFT", raidInstanceDropdown, "TOPLEFT", 0, 1)
        raidInstanceText:SetText(raidInstance)

        -- mythic
        raidMythicDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
        raidMythicDropdown:SetPoint("TOPLEFT", raidInstanceDropdown, "BOTTOMLEFT", 0, -30)
        
        raidMythicText = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
        raidMythicText:SetPoint("BOTTOMLEFT", raidMythicDropdown, "TOPLEFT", 0, 1)
        raidMythicText:SetText(raidMythic)
    else
        -- raid10
        raid10Dropdown = Cell:CreateDropdown(autoSwitchPane, 140)
        raid10Dropdown:SetPoint("TOPLEFT", raidOutdoorDropdown, "BOTTOMLEFT", 0, -30)
        
        raid10Text = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
        raid10Text:SetPoint("BOTTOMLEFT", raid10Dropdown, "TOPLEFT", 0, 1)
        raid10Text:SetText(L["Raid"].." 10")
        
        -- raid25
        raid25Dropdown = Cell:CreateDropdown(autoSwitchPane, 140)
        raid25Dropdown:SetPoint("TOPLEFT", raid10Dropdown, "BOTTOMLEFT", 0, -30)
        
        raid25Text = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
        raid25Text:SetPoint("BOTTOMLEFT", raid25Dropdown, "TOPLEFT", 0, 1)
        raid25Text:SetText(L["Raid"].." 25")
    end
    
    -- arena
    arenaDropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    if Cell.isRetail then
        arenaDropdown:SetPoint("TOPLEFT", raidMythicDropdown, "BOTTOMLEFT", 0, -30)
    else
        arenaDropdown:SetPoint("TOPLEFT", raid25Dropdown, "BOTTOMLEFT", 0, -30)
    end
    
    arenaText = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    arenaText:SetPoint("BOTTOMLEFT", arenaDropdown, "TOPLEFT", 0, 1)
    arenaText:SetText(L["Arena"])
    
    -- battleground 15
    bg15Dropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    bg15Dropdown:SetPoint("TOPLEFT", arenaDropdown, "BOTTOMLEFT", 0, -30)
    
    bg15Text = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    bg15Text:SetPoint("BOTTOMLEFT", bg15Dropdown, "TOPLEFT", 0, 1)
    bg15Text:SetText(L["BG 1-15"])
    
    -- battleground 40
    bg40Dropdown = Cell:CreateDropdown(autoSwitchPane, 140)
    bg40Dropdown:SetPoint("TOPLEFT", bg15Dropdown, "BOTTOMLEFT", 0, -30)
    
    bg40Text = autoSwitchPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    bg40Text:SetPoint("BOTTOMLEFT", bg40Dropdown, "TOPLEFT", 0, 1)
    bg40Text:SetText(L["BG 16-40"])
end

LoadAutoSwitchDropdowns = function()
    local indices = {}
    for name, _ in pairs(CellDB["layouts"]) do
        if name ~= "default" then
            tinsert(indices, name)
        end
    end
    table.sort(indices)
    tinsert(indices, 1, "default") -- make default first

    -- partyDropdown
    local partyItems = {}
    for _, value in pairs(indices) do
        table.insert(partyItems, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                CellLayoutAutoSwitchTable[selectedRole]["party"] = value
                if not Cell.vars.inBattleground and (Cell.vars.groupType == "solo" or Cell.vars.groupType == "party") and (selectedRole == Cell.vars.playerSpecRole) then
                    F:UpdateLayout("party")
                    Cell:Fire("UpdateIndicators")
                    LoadLayoutDB(Cell.vars.currentLayout)
                    UpdateButtonStates()
                    -- UpdateEnabledLayoutText()
                end
            end,
        })
    end
    partyDropdown:SetItems(partyItems)

    -- raidOutdoorDropdown
    local raidItems = {}
    for _, value in pairs(indices) do
        table.insert(raidItems, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                CellLayoutAutoSwitchTable[selectedRole]["raid_outdoor"] = value
                if not Cell.vars.inBattleground and not Cell.vars.inInstance and Cell.vars.groupType == "raid" and selectedRole == Cell.vars.playerSpecRole then
                    F:UpdateLayout("raid_outdoor")
                    Cell:Fire("UpdateIndicators")
                    LoadLayoutDB(Cell.vars.currentLayout)
                    UpdateButtonStates()
                    -- UpdateEnabledLayoutText()
                end
            end,
        })
    end
    raidOutdoorDropdown:SetItems(raidItems)

    if Cell.isRetail then
        -- raidInstanceDropdown
        local raidInstanceItems = {}
        for _, value in pairs(indices) do
            table.insert(raidInstanceItems, {
                ["text"] = value == "default" and _G.DEFAULT or value,
                ["value"] = value,
                ["onClick"] = function()
                    CellLayoutAutoSwitchTable[selectedRole]["raid_instance"] = value
                    if Cell.vars.inInstance and not Cell.vars.inMythic and Cell.vars.groupType == "raid" and selectedRole == Cell.vars.playerSpecRole then
                        F:UpdateLayout("raid_instance")
                        Cell:Fire("UpdateIndicators")
                        LoadLayoutDB(Cell.vars.currentLayout)
                        UpdateButtonStates()
                        -- UpdateEnabledLayoutText()
                    end
                end,
            })
        end
        raidInstanceDropdown:SetItems(raidInstanceItems)

        -- raidMythicDropdown
        local raidMythicItems = {}
        for _, value in pairs(indices) do
            table.insert(raidMythicItems, {
                ["text"] = value == "default" and _G.DEFAULT or value,
                ["value"] = value,
                ["onClick"] = function()
                    CellLayoutAutoSwitchTable[selectedRole]["raid_mythic"] = value
                    if Cell.vars.inMythic and Cell.vars.groupType == "raid" and selectedRole == Cell.vars.playerSpecRole then
                        F:UpdateLayout("raid_mythic")
                        Cell:Fire("UpdateIndicators")
                        LoadLayoutDB(Cell.vars.currentLayout)
                        UpdateButtonStates()
                        -- UpdateEnabledLayoutText()
                    end
                end,
            })
        end
        raidMythicDropdown:SetItems(raidMythicItems)

    else
        -- raid10Dropdown
        local raid10Items = {}
        for _, value in pairs(indices) do
            table.insert(raid10Items, {
                ["text"] = value == "default" and _G.DEFAULT or value,
                ["value"] = value,
                ["onClick"] = function()
                    CellLayoutAutoSwitchTable[selectedRole]["raid10"] = value
                    if not Cell.vars.inBattleground and Cell.vars.groupType == "raid" and  Cell.vars.raidType == "raid10" and selectedRole == Cell.vars.playerSpecRole then
                        F:UpdateLayout("raid10")
                        Cell:Fire("UpdateIndicators")
                        LoadLayoutDB(Cell.vars.currentLayout)
                        UpdateButtonStates()
                        -- UpdateEnabledLayoutText()
                    end
                end,
            })
        end
        raid10Dropdown:SetItems(raid10Items)

        -- raid25Dropdown
        local raid25Items = {}
        for _, value in pairs(indices) do
            table.insert(raid25Items, {
                ["text"] = value == "default" and _G.DEFAULT or value,
                ["value"] = value,
                ["onClick"] = function()
                    CellLayoutAutoSwitchTable[selectedRole]["raid25"] = value
                    if not Cell.vars.inBattleground and Cell.vars.groupType == "raid" and  Cell.vars.raidType == "raid25" and selectedRole == Cell.vars.playerSpecRole then
                        F:UpdateLayout("raid25")
                        Cell:Fire("UpdateIndicators")
                        LoadLayoutDB(Cell.vars.currentLayout)
                        UpdateButtonStates()
                        -- UpdateEnabledLayoutText()
                    end
                end,
            })
        end
        raid25Dropdown:SetItems(raid25Items)
    end

    -- arenaDropdown
    local arenaItems = {}
    for _, value in pairs(indices) do
        table.insert(arenaItems, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                CellLayoutAutoSwitchTable[selectedRole]["arena"] = value
                if Cell.vars.inBattleground == 5 and selectedRole == Cell.vars.playerSpecRole then
                    F:UpdateLayout("arena")
                    Cell:Fire("UpdateIndicators")
                    LoadLayoutDB(Cell.vars.currentLayout)
                    UpdateButtonStates()
                    -- UpdateEnabledLayoutText()
                end
            end,
        })
    end
    arenaDropdown:SetItems(arenaItems)

    -- bg15Dropdown
    local bg15Items = {}
    for _, value in pairs(indices) do
        table.insert(bg15Items, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                CellLayoutAutoSwitchTable[selectedRole]["battleground15"] = value
                if Cell.vars.inBattleground == 15 and selectedRole == Cell.vars.playerSpecRole then
                    F:UpdateLayout("battleground15")
                    Cell:Fire("UpdateIndicators")
                    LoadLayoutDB(Cell.vars.currentLayout)
                    UpdateButtonStates()
                    -- UpdateEnabledLayoutText()
                end
            end,
        })
    end
    bg15Dropdown:SetItems(bg15Items)

    -- bg40Dropdown
    local bg40Items = {}
    for _, value in pairs(indices) do
        table.insert(bg40Items, {
            ["text"] = value == "default" and _G.DEFAULT or value,
            ["value"] = value,
            ["onClick"] = function()
                CellLayoutAutoSwitchTable[selectedRole]["battleground40"] = value
                if Cell.vars.inBattleground == 40 and selectedRole == Cell.vars.playerSpecRole then
                    F:UpdateLayout("battleground40")
                    Cell:Fire("UpdateIndicators")
                    LoadLayoutDB(Cell.vars.currentLayout)
                    UpdateButtonStates()
                    -- UpdateEnabledLayoutText()
                end
            end,
        })
    end
    bg40Dropdown:SetItems(bg40Items)
end

-------------------------------------------------
-- group filter
-------------------------------------------------
local function UpdateButtonBorderColor(flag, b)
    local borderColor 
    if flag then
        borderColor = {b.hoverColor[1], b.hoverColor[2], b.hoverColor[3], 1}
    else
        borderColor = {0, 0, 0, 1}
    end
    b:SetBackdropBorderColor(unpack(borderColor))
end

local groupButtons = {}
local function CreateGroupFilterPane()
    local groupFilterPane = Cell:CreateTitledPane(layoutsTab, L["Group Filter"], 205, 80)
    groupFilterPane:SetPoint("TOPLEFT", 222, -5)

    for i = 1, 8 do
        groupButtons[i] = Cell:CreateButton(groupFilterPane, i, "accent-hover", {20, 20})
        groupButtons[i]:SetScript("OnClick", function()
            selectedLayoutTable["groupFilter"][i] = not selectedLayoutTable["groupFilter"][i]
            UpdateButtonBorderColor(selectedLayoutTable["groupFilter"][i], groupButtons[i])
    
            if selectedLayout == Cell.vars.currentLayout then
                Cell:Fire("UpdateLayout", selectedLayout, "groupFilter")
            end
            UpdateLayoutPreview()
        end)
        
        if i == 1 then
            groupButtons[i]:SetPoint("TOPLEFT", 5, -27)
        -- elseif i == 5 then
        --     groupButtons[i]:SetPoint("TOPLEFT", groupButtons[1], "BOTTOMLEFT", 0, -3)
        else
            groupButtons[i]:SetPoint("TOPLEFT", groupButtons[i-1], "TOPRIGHT", 5, 0)
        end
    end

    -- preview mode
    local previewModeButton = Cell:CreateButton(groupFilterPane, L["Preview"]..": |cff777777"..L["OFF"], "accent", {195, 20})
    previewModeButton:SetPoint("TOPLEFT", groupButtons[1], "BOTTOMLEFT", 0, -10)
    previewModeButton:SetScript("OnClick", function()
        previewMode = (previewMode == 2) and 0 or (previewMode + 1)
    
        if previewMode == 0 then
            previewModeButton:SetText(L["Preview"]..": |cff777777"..L["OFF"])
            layoutPreview.fadeOut:Play()
            if npcPreview:IsShown() then
                npcPreview.fadeOut:Play()
            end
            if raidPetPreview:IsShown() then
                raidPetPreview.fadeOut:Play()
            end
            if spotlightPreview:IsShown() then
                spotlightPreview.fadeOut:Play()
            end
        elseif previewMode == 1 then
            previewModeButton:SetText(L["Preview"]..": "..L["Party"])
            UpdateLayoutPreview()
            UpdateNPCPreview()
            if raidPetPreview:IsShown() then
                raidPetPreview.fadeOut:Play()
            end
            UpdateSpotlightPreview()
        else
            previewModeButton:SetText(L["Preview"]..": "..L["Raid"])
            UpdateLayoutPreview()
            UpdateNPCPreview()
            UpdateRaidPetPreview()
            UpdateSpotlightPreview()
        end
    end)
    previewModeButton:SetScript("OnHide", function()
        previewMode = 0
        previewModeButton:SetText(L["Preview"]..": |cff777777"..L["OFF"])
    end)
end

local function UpdateGroupFilter()
    for i = 1, 8 do
        UpdateButtonBorderColor(selectedLayoutTable["groupFilter"][i], groupButtons[i])
    end
end

-------------------------------------------------
-- button size
-------------------------------------------------
local widthSlider, heightSlider, powerSizeSlider, petSizeCB, petWidthSlider, petHeightSlider, spotlightSizeCB, spotlightWidthSlider, spotlightHeightSlider, switch

local function CreateButtonSizePane()
    local buttonSizePane = Cell:CreateTitledPane(layoutsTab, L["Button Size"], 139, 170)
    buttonSizePane:SetPoint("TOPLEFT", 5, -105)
    
    --* page1 -----------------------------------
    local page1 = CreateFrame("Frame", nil, layoutsTab)
    page1:SetAllPoints(buttonSizePane)
    page1:Hide()

    -- width
    widthSlider = Cell:CreateSlider(L["Width"], page1, 20, 300, 117, 2, function(value)
        selectedLayoutTable["size"][1] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "size")
        end
        UpdatePreviewButton("size")
        UpdateLayoutPreview()
        UpdateNPCPreview()
        if not selectedLayoutTable["pet"][4] then
            UpdateRaidPetPreview()
        end
        if not selectedLayoutTable["spotlight"][4] then
            UpdateSpotlightPreview()
        end
    end)
    widthSlider:SetPoint("TOPLEFT", 5, -40)
    
    -- height
    heightSlider = Cell:CreateSlider(L["Height"], page1, 20, 300, 117, 2, function(value)
        selectedLayoutTable["size"][2] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "size")
        end
        UpdatePreviewButton("size")
        UpdateLayoutPreview()
        UpdateNPCPreview()
        if not selectedLayoutTable["pet"][4] then
            UpdateRaidPetPreview()
        end
        if not selectedLayoutTable["spotlight"][4] then
            UpdateSpotlightPreview()
        end
    end)
    heightSlider:SetPoint("TOPLEFT", widthSlider, 0, -50)
    
    -- power height
    powerSizeSlider = Cell:CreateSlider(L["Power Size"], page1, 0, 20, 117, 1, function(value)
        selectedLayoutTable["powerSize"] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "power")
        end
        UpdatePreviewButton("power")
    end)
    powerSizeSlider:SetPoint("TOPLEFT", heightSlider, 0, -50)

    --* page2 -----------------------------------
    local page2 = CreateFrame("Frame", nil, layoutsTab)
    page2:SetAllPoints(buttonSizePane)
    page2:Hide()

    -- petSize
    petSizeCB = Cell:CreateCheckButton(page2, L["Pet Button"], function(checked, self)
        if checked then
            petWidthSlider:SetEnabled(true)
            petHeightSlider:SetEnabled(true)
        else
            petWidthSlider:SetEnabled(false)
            petHeightSlider:SetEnabled(false)
        end
        selectedLayoutTable["pet"][4] = checked
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "petSize")
        end
        UpdateRaidPetPreview()
    end)
    petSizeCB:SetPoint("TOPLEFT", 5, -40)
    
    -- petWidth
    petWidthSlider = Cell:CreateSlider(L["Width"], page2, 40, 300, 117, 2, function(value)
        selectedLayoutTable["pet"][5][1] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "petSize")
        end
        UpdateRaidPetPreview()
    end)
    petWidthSlider:SetPoint("TOPLEFT", 5, -90)
    
    -- petHeight
    petHeightSlider = Cell:CreateSlider(L["Height"], page2, 20, 300, 117, 2, function(value)
        selectedLayoutTable["pet"][5][2] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "petSize")
        end
        UpdateRaidPetPreview()
    end)
    petHeightSlider:SetPoint("TOPLEFT", petWidthSlider, 0, -50)

    --* page3 -----------------------------------
    local page3 = CreateFrame("Frame", nil, layoutsTab)
    page3:SetAllPoints(buttonSizePane)
    page3:Hide()

    -- spotlightSize
    spotlightSizeCB = Cell:CreateCheckButton(page3, L["Spotlight Button"], function(checked, self)
        if checked then
            spotlightWidthSlider:SetEnabled(true)
            spotlightHeightSlider:SetEnabled(true)
        else
            spotlightWidthSlider:SetEnabled(false)
            spotlightHeightSlider:SetEnabled(false)
        end

        selectedLayoutTable["spotlight"][4] = checked
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spotlightSize")
        end
        UpdateSpotlightPreview()
    end)
    spotlightSizeCB:SetPoint("TOPLEFT", 5, -40)

    -- spotlightWidth
    spotlightWidthSlider = Cell:CreateSlider(L["Width"], page3, 40, 300, 117, 2, function(value)
        selectedLayoutTable["spotlight"][5][1] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spotlightSize")
        end
        UpdateSpotlightPreview()
    end)
    spotlightWidthSlider:SetPoint("TOPLEFT", 5, -90)
    
    -- spotlightHeight
    spotlightHeightSlider = Cell:CreateSlider(L["Height"], page3, 20, 300, 117, 2, function(value)
        selectedLayoutTable["spotlight"][5][2] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spotlightSize")
        end
        UpdateSpotlightPreview()
    end)
    spotlightHeightSlider:SetPoint("TOPLEFT", spotlightWidthSlider, 0, -50)

    -- switch
    switch = Cell:CreateTripleSwitch(buttonSizePane, {32, 10}, function(which)
        if which == "LEFT" then
            page1:Show()
            page2:Hide()
            page3:Hide()
        elseif which == "CENTER" then
            page1:Hide()
            page2:Show()
            page3:Hide()
        else
            page1:Hide()
            page2:Hide()
            page3:Show()
        end
    end)
    switch:SetPoint("BOTTOMRIGHT", buttonSizePane.line, "TOPRIGHT", 0, P:Scale(2))
    switch:SetSelected("LEFT", true)
end

-------------------------------------------------
-- group arrangement
-------------------------------------------------
local orientationDropdown, anchorDropdown, spacingXSlider, rcSlider, groupSpacingSlider

local function CreateGroupArrangementPane()
    local groupArrangementPane = Cell:CreateTitledPane(layoutsTab, L["Group Arrangement"], 271, 170)
    groupArrangementPane:SetPoint("TOPLEFT", 156, -105)

    -- orientation
    orientationDropdown = Cell:CreateDropdown(groupArrangementPane, 117)
    orientationDropdown:SetPoint("TOPLEFT", 5, -40)
    orientationDropdown:SetItems({
        {
            ["text"] = L["Vertical"],
            ["value"] = "vertical",
            ["onClick"] = function()
                selectedLayoutTable["orientation"] = "vertical"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "orientation")
                end
                rcSlider:SetName(L["Group Columns"])
                rcSlider:SetValue(selectedLayoutTable["columns"])
                if selectedLayoutTable["columns"] == 8 then
                    groupSpacingSlider:SetEnabled(false)
                else
                    groupSpacingSlider:SetEnabled(true)
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
        {
            ["text"] = L["Horizontal"],
            ["value"] = "horizontal",
            ["onClick"] = function()
                selectedLayoutTable["orientation"] = "horizontal"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "orientation")
                end
                rcSlider:SetName(L["Group Rows"])
                rcSlider:SetValue(selectedLayoutTable["rows"])
                if selectedLayoutTable["rows"] == 8 then
                    groupSpacingSlider:SetEnabled(false)
                else
                    groupSpacingSlider:SetEnabled(true)
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
    })
    
    local orientationText = groupArrangementPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    orientationText:SetPoint("BOTTOMLEFT", orientationDropdown, "TOPLEFT", 0, 1)
    orientationText:SetText(L["Orientation"])
    
    -- anchor
    anchorDropdown = Cell:CreateDropdown(groupArrangementPane, 117)
    anchorDropdown:SetPoint("TOPLEFT", orientationDropdown, 0, -50)
    anchorDropdown:SetItems({
        {
            ["text"] = L["BOTTOMLEFT"],
            ["value"] = "BOTTOMLEFT",
            ["onClick"] = function()
                selectedLayoutTable["anchor"] = "BOTTOMLEFT"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "anchor")
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
        {
            ["text"] = L["BOTTOMRIGHT"],
            ["value"] = "BOTTOMRIGHT",
            ["onClick"] = function()
                selectedLayoutTable["anchor"] = "BOTTOMRIGHT"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "anchor")
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
        {
            ["text"] = L["TOPLEFT"],
            ["value"] = "TOPLEFT",
            ["onClick"] = function()
                selectedLayoutTable["anchor"] = "TOPLEFT"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "anchor")
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
        {
            ["text"] = L["TOPRIGHT"],
            ["value"] = "TOPRIGHT",
            ["onClick"] = function()
                selectedLayoutTable["anchor"] = "TOPRIGHT"
                if selectedLayout == Cell.vars.currentLayout then
                    Cell:Fire("UpdateLayout", selectedLayout, "anchor")
                end
                UpdateLayoutPreview()
                UpdateNPCPreview()
                UpdateRaidPetPreview()
                UpdateSpotlightPreview()
            end,
        },
    })
    
    local anchorText = groupArrangementPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    anchorText:SetPoint("BOTTOMLEFT", anchorDropdown, "TOPLEFT", 0, 1)
    anchorText:SetText(L["Anchor Point"])
    
    -- spacing
    spacingXSlider = Cell:CreateSlider(L["Unit Spacing"].." X", groupArrangementPane, 0, 50, 117, 1, function(value)
        selectedLayoutTable["spacingX"] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spacing")
        end
        -- preview
        UpdateLayoutPreview()
        UpdateNPCPreview()
        UpdateRaidPetPreview()
        UpdateSpotlightPreview()
    end)
    spacingXSlider:SetPoint("TOPLEFT", orientationDropdown, "TOPRIGHT", 23, 0)

    spacingYSlider = Cell:CreateSlider(L["Unit Spacing"].." Y", groupArrangementPane, 0, 50, 117, 1, function(value)
        selectedLayoutTable["spacingY"] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spacing")
        end
        -- preview
        UpdateLayoutPreview()
        UpdateNPCPreview()
        UpdateRaidPetPreview()
        UpdateSpotlightPreview()
    end)
    spacingYSlider:SetPoint("TOPLEFT", spacingXSlider, 0, -50)
    
    -- rows/columns
    rcSlider = Cell:CreateSlider("", groupArrangementPane, 1, 8, 117, 1, function(value)
        if selectedLayoutTable["orientation"] == "vertical" then
            selectedLayoutTable["columns"] = value
        else -- horizontal
            selectedLayoutTable["rows"] = value
        end
        if value == 8 then
            groupSpacingSlider:SetEnabled(false)
        else
            groupSpacingSlider:SetEnabled(true)
        end
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "rows_columns")
        end
        -- preview
        UpdateLayoutPreview()
    end)
    rcSlider:SetPoint("TOPLEFT", anchorDropdown, 0, -50)
    
    -- group spacing
    groupSpacingSlider = Cell:CreateSlider(L["Group Spacing"], groupArrangementPane, 0, 50, 117, 1, function(value)
        selectedLayoutTable["groupSpacing"] = value
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "groupSpacing")
        end
        -- preview
        UpdateLayoutPreview()
    end)
    groupSpacingSlider:SetPoint("TOPLEFT", spacingYSlider, 0, -50)
end

-------------------------------------------------
-- bar orientation
-------------------------------------------------
local orientationSwitch, rotateTexCB

local function CreateBarOrientationPane()
    local barOrientationPane = Cell:CreateTitledPane(layoutsTab, L["Bar Orientation"], 205, 80)
    barOrientationPane:SetPoint("TOPLEFT", 5, -295)

    orientationSwitch = Cell:CreateSwitch(barOrientationPane, {163, 20}, L["Horizontal"], "horizontal", L["Vertical"], "vertical", function(which)
        selectedLayoutTable["barOrientation"][1] = which
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "barOrientation")
        end
        UpdatePreviewButton("barOrientation")
    end)
    orientationSwitch:SetPoint("TOPLEFT", 5, -27)
    
    rotateTexCB = Cell:CreateCheckButton(barOrientationPane, L["Rotate Texture"], function(checked)
        selectedLayoutTable["barOrientation"][2] = checked
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "barOrientation")
        end
        UpdatePreviewButton("barOrientation")
    end)
    rotateTexCB:SetPoint("TOPLEFT", orientationSwitch, "BOTTOMLEFT", 0, -10)
end

-------------------------------------------------
-- other frames
-------------------------------------------------
local separateNPCCB, showNPCCB, spotlightCB, partyPetsCB, raidPetsCB

local function CreateOthersPane()
    local othersPane = Cell:CreateTitledPane(layoutsTab, L["Other Frames"], 205, 145)
    othersPane:SetPoint("TOPLEFT", 222, -295)

    showNPCCB = Cell:CreateCheckButton(othersPane, L["Show NPC Frame"], function(checked)
        selectedLayoutTable["friendlyNPC"][1] = checked
        if checked then
            if previewMode ~= 0 then
                UpdateNPCPreview()
            end
        else
            if npcPreview:IsShown() then
                UpdateNPCPreview()
            end
        end
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "npc")
        end
    end)
    showNPCCB:SetPoint("TOPLEFT", 5, -27)

    separateNPCCB = Cell:CreateCheckButton(othersPane, L["Separate NPC Frame"], function(checked)
        selectedLayoutTable["friendlyNPC"][2] = checked
        if checked then
            UpdateNPCPreview()
        else
            if npcPreview:IsShown() then
                UpdateNPCPreview()
            end
        end
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "npc")
        end
    end, L["Separate NPC Frame"], L["Show friendly NPCs in a separate frame"], L["You can move it in Preview mode"])
    separateNPCCB:SetPoint("TOPLEFT", showNPCCB, "BOTTOMLEFT", 0, -8)

    partyPetsCB = Cell:CreateCheckButton(othersPane, L["Show Party/Arena Pets"], function(checked)
        selectedLayoutTable["pet"][1] = checked
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "pet")
        end
    end)
    partyPetsCB:SetPoint("TOPLEFT", separateNPCCB, "BOTTOMLEFT", 0, -14)

    raidPetsCB = Cell:CreateCheckButton(othersPane, L["Show Raid Pets"], function(checked)
        selectedLayoutTable["pet"][2] = checked
        if checked then
            UpdateRaidPetPreview()
        else
            if raidPetPreview:IsShown() then
                UpdateRaidPetPreview()
            end
        end
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "pet")
        end
    end, L["Show Raid Pets"], L["You can move it in Preview mode"])
    raidPetsCB:SetPoint("TOPLEFT", partyPetsCB, "BOTTOMLEFT", 0, -8)

    spotlightCB = Cell:CreateCheckButton(othersPane, L["Spotlight Frame"], function(checked)
        selectedLayoutTable["spotlight"][1] = checked
        if checked then
            UpdateSpotlightPreview()
        else
            if spotlightPreview:IsShown() then
                UpdateSpotlightPreview()
            end
        end
        if selectedLayout == Cell.vars.currentLayout then
            Cell:Fire("UpdateLayout", selectedLayout, "spotlight")
        end
    end, L["Spotlight Frame"], L["Show units you care about more in a separate frame"],
    "|cffffb5c5"..L["Target"]..", "..L["Target of Target"]..", "..L["Focus"],
    "|cffffb5c5"..L["Unit"]..", "..L["Unit's Pet"])
    spotlightCB:SetPoint("TOPLEFT", raidPetsCB, "BOTTOMLEFT", 0, -14)
end

-------------------------------------------------
-- misc
-------------------------------------------------
local function CreateMiscPane()
    local miscPane = Cell:CreateTitledPane(layoutsTab, L["Misc"], 205, 50)
    miscPane:SetPoint("TOPLEFT", 5, -390)

    local powerFilterBtn = Cell:CreateButton(miscPane, L["Power Bar Filters"], "accent-hover", {163, 20})
    Cell.frames.layoutsTab.powerFilterBtn = powerFilterBtn
    powerFilterBtn:SetPoint("TOPLEFT", 5, -27)
    powerFilterBtn:SetScript("OnClick", function ()
        F:ShowPowerFilters(selectedLayout, selectedLayoutTable)
    end)

    Cell.frames.powerFilters:SetPoint("BOTTOMLEFT", powerFilterBtn, "TOPLEFT", 0, P:Scale(5))
end

-------------------------------------------------
-- tips
-------------------------------------------------
local tips = layoutsTab:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
tips:SetPoint("BOTTOMLEFT", 5, 5)
tips:SetJustifyH("LEFT")
tips:SetText("|cffababab"..L["Tip: Every layout has its own position setting"])

-------------------------------------------------
-- functions
-------------------------------------------------
local init
LoadLayoutDB = function(layout)
    F:Debug("LoadLayoutDB: "..layout)

    selectedLayout = layout
    selectedLayoutTable = CellDB["layouts"][layout]

    layoutDropdown:SetSelectedValue(selectedLayout)

    widthSlider:SetValue(selectedLayoutTable["size"][1])
    heightSlider:SetValue(selectedLayoutTable["size"][2])
    powerSizeSlider:SetValue(selectedLayoutTable["powerSize"])

    petSizeCB:SetChecked(selectedLayoutTable["pet"][4])
    petWidthSlider:SetValue(selectedLayoutTable["pet"][5][1])
    petHeightSlider:SetValue(selectedLayoutTable["pet"][5][2])
    petWidthSlider:SetEnabled(selectedLayoutTable["pet"][4])
    petHeightSlider:SetEnabled(selectedLayoutTable["pet"][4])

    spotlightSizeCB:SetChecked(selectedLayoutTable["spotlight"][4])
    spotlightWidthSlider:SetValue(selectedLayoutTable["spotlight"][5][1])
    spotlightHeightSlider:SetValue(selectedLayoutTable["spotlight"][5][2])
    spotlightWidthSlider:SetEnabled(selectedLayoutTable["spotlight"][4])
    spotlightHeightSlider:SetEnabled(selectedLayoutTable["spotlight"][4])

    spacingXSlider:SetValue(selectedLayoutTable["spacingX"])
    spacingYSlider:SetValue(selectedLayoutTable["spacingY"])
    
    if selectedLayoutTable["orientation"] == "vertical" then
        rcSlider:SetName(L["Group Columns"])
        rcSlider:SetValue(selectedLayoutTable["columns"])
        if selectedLayoutTable["columns"] == 8 then
            groupSpacingSlider:SetEnabled(false)
        else
            groupSpacingSlider:SetEnabled(true)
        end
    else
        rcSlider:SetName(L["Group Rows"])
        rcSlider:SetValue(selectedLayoutTable["rows"])
        if selectedLayoutTable["rows"] == 8 then
            groupSpacingSlider:SetEnabled(false)
        else
            groupSpacingSlider:SetEnabled(true)
        end
    end
    groupSpacingSlider:SetValue(selectedLayoutTable["groupSpacing"])

    -- group arrangement
    orientationDropdown:SetSelectedValue(selectedLayoutTable["orientation"])
    anchorDropdown:SetSelectedValue(selectedLayoutTable["anchor"])

    -- bar orientation
    orientationSwitch:SetSelected(selectedLayoutTable["barOrientation"][1])
    rotateTexCB:SetChecked(selectedLayoutTable["barOrientation"][2])

    -- other frames
    showNPCCB:SetChecked(selectedLayoutTable["friendlyNPC"][1])
    separateNPCCB:SetChecked(selectedLayoutTable["friendlyNPC"][2])
    partyPetsCB:SetChecked(selectedLayoutTable["pet"][1])
    raidPetsCB:SetChecked(selectedLayoutTable["pet"][2])
    spotlightCB:SetChecked(selectedLayoutTable["spotlight"][1])

    UpdateGroupFilter()
    UpdatePreviewButton()
    UpdateLayoutPreview()
    UpdateNPCPreview()
    UpdateRaidPetPreview()
    UpdateSpotlightPreview()
end

LoadLayoutAutoSwitchDB = function(role)
    selectedRole = role

    roleDropdown:SetSelectedValue(role)
    partyDropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["party"])
    raidOutdoorDropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["raid_outdoor"])
    arenaDropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["arena"])
    bg15Dropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["battleground15"])
    bg40Dropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["battleground40"])

    if Cell.isRetail then
        raidInstanceDropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["raid_instance"])
        raidMythicDropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["raid_mythic"])
    else
        raid10Dropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["raid10"])
        raid25Dropdown:SetSelectedValue(CellLayoutAutoSwitchTable[role]["raid25"])
    end
end

local function UpdateLayoutAutoSwitchText()
    if not init then return end
    if Cell.vars.inBattleground then
        if Cell.vars.inBattleground == 15 then
            partyText:SetText(L["Solo/Party"])
            raidOutdoorText:SetText(raidOutdoor)
            if raidInstanceText then raidInstanceText:SetText(raidInstance) end
            if raidMythicText then raidMythicText:SetText(raidMythic) end
            if raid10Text then raid10Text:SetText(L["Raid"].." 10") end
            if raid25Text then raid25Text:SetText(L["Raid"].." 25") end
            arenaText:SetText(L["Arena"])
            bg15Text:SetText(Cell:GetAccentColorString()..L["BG 1-15"].."*")
            bg40Text:SetText(L["BG 16-40"])
        elseif Cell.vars.inBattleground == 40 then
            partyText:SetText(L["Solo/Party"])
            raidOutdoorText:SetText(raidOutdoor)
            if raidInstanceText then raidInstanceText:SetText(raidInstance) end
            if raidMythicText then raidMythicText:SetText(raidMythic) end
            if raid10Text then raid10Text:SetText(L["Raid"].." 10") end
            if raid25Text then raid25Text:SetText(L["Raid"].." 25") end
            arenaText:SetText(L["Arena"])
            bg15Text:SetText(L["BG 1-15"])
            bg40Text:SetText(Cell:GetAccentColorString()..L["BG 16-40"].."*")
        else -- 5 arena
            partyText:SetText(L["Solo/Party"])
            raidOutdoorText:SetText(raidOutdoor)
            if raidInstanceText then raidInstanceText:SetText(raidInstance) end
            if raidMythicText then raidMythicText:SetText(raidMythic) end
            if raid10Text then raid10Text:SetText(L["Raid"].." 10") end
            if raid25Text then raid25Text:SetText(L["Raid"].." 25") end
            arenaText:SetText(Cell:GetAccentColorString()..L["Arena"].."*")
            bg15Text:SetText(L["BG 1-15"])
            bg40Text:SetText(L["BG 16-40"])
        end
    else
        if Cell.vars.groupType == "solo" or Cell.vars.groupType == "party" then
            partyText:SetText(Cell:GetAccentColorString()..L["Solo/Party"].."*")
            raidOutdoorText:SetText(raidOutdoor)
            if raidInstanceText then raidInstanceText:SetText(raidInstance) end
            if raidMythicText then raidMythicText:SetText(raidMythic) end
            if raid10Text then raid10Text:SetText(L["Raid"].." 10") end
            if raid25Text then raid25Text:SetText(L["Raid"].." 25") end
            arenaText:SetText(L["Arena"])
            bg15Text:SetText(L["BG 1-15"])
            bg40Text:SetText(L["BG 16-40"])
        else
            partyText:SetText(L["Solo/Party"])
            if Cell.vars.inInstance then
                raidOutdoorText:SetText(raidOutdoor)
                if Cell.isRetail then
                    if Cell.vars.inMythic then
                        raidInstanceText:SetText(raidInstance)
                        raidMythicText:SetText(Cell:GetAccentColorString()..raidMythic.."*")
                    else
                        raidInstanceText:SetText(Cell:GetAccentColorString()..raidInstance.."*")
                        raidMythicText:SetText(raidMythic)
                    end
                else
                    if Cell.vars.raidType == "raid10" then
                        raid10Text:SetText(Cell:GetAccentColorString()..L["Raid"].." 10*")
                        raid25Text:SetText(L["Raid"].." 25")
                    else
                        raid10Text:SetText(L["Raid"].." 10")
                        raid25Text:SetText(Cell:GetAccentColorString()..L["Raid"].." 25*")
                    end
                end
            else
                raidOutdoorText:SetText(Cell:GetAccentColorString()..raidOutdoor.."*")
                if raidInstanceText then raidInstanceText:SetText(raidInstance) end
                if raidMythicText then raidMythicText:SetText(raidMythic) end
                if raid10Text then raid10Text:SetText(L["Raid"].." 10") end
                if raid25Text then raid25Text:SetText(L["Raid"].." 25") end
            end

            arenaText:SetText(L["Arena"])
            bg15Text:SetText(L["BG 1-15"])
            bg40Text:SetText(L["BG 16-40"])
        end
    end
end
Cell:RegisterCallback("UpdateLayout", "LayoutsTab_UpdateLayout", UpdateLayoutAutoSwitchText)

local function UpdateAppearance()
    if previewButton and selectedLayout == Cell.vars.currentLayout then
        UpdatePreviewButton("appearance")
    end
end
Cell:RegisterCallback("UpdateAppearance", "LayoutsTab_UpdateAppearance", UpdateAppearance)

local function UpdateIndicators(layout, indicatorName, setting, value)
    if previewButton and selectedLayout == Cell.vars.currentLayout then
        if not layout or indicatorName == "nameText" then
            UpdatePreviewButton("nameText")
        end
        if not layout or indicatorName == "statusText" then
            UpdatePreviewButton("statusText")
        end
    end
end
Cell:RegisterCallback("UpdateIndicators", "LayoutsTab_UpdateIndicators", UpdateIndicators)

local function LayoutImported(name)
    if Cell.vars.currentLayout == name then -- update overwrite
        if Cell.vars.inBattleground then 
            if Cell.vars.inBattleground == 5 then
                F:UpdateLayout("arena")
            elseif Cell.vars.inBattleground == 15 then
                F:UpdateLayout("battleground15")
            elseif Cell.vars.inBattleground == 40 then
                F:UpdateLayout("battleground40")
            end
        else 
            if Cell.vars.groupType == "solo" or Cell.vars.groupType == "party" then
                F:UpdateLayout("party")
            elseif Cell.vars.groupType == "raid" then
                F:UpdateLayout("raid")
            end
        end
        Cell:Fire("UpdateIndicators")
        LoadLayoutDB(name)
        UpdateButtonStates()

    else -- load new
        -- update dropdown
        layoutDropdown:AddItem({
            ["text"] = name,
            ["onClick"] = function()
                LoadLayoutDB(name)
                UpdateButtonStates()
            end,
        })
        LoadAutoSwitchDropdowns()
        LoadLayoutDB(name)
        UpdateButtonStates()
    end
end
Cell:RegisterCallback("LayoutImported", "LayoutsTab_LayoutImported", LayoutImported)

local function ShowTab(tab)
    if tab == "layouts" then
        if not init then
            init = true

            CreateLayoutPane()
            CreateAutoSwitchPane()
            UpdateLayoutAutoSwitchText()
            CreateGroupFilterPane()
            CreateButtonSizePane()
            CreateGroupArrangementPane()
            CreateBarOrientationPane()
            CreateOthersPane()
            CreateMiscPane()

            LoadLayoutDropdown()
            LoadAutoSwitchDropdowns()

            -- mask
            F:ApplyCombatFunctionToTab(layoutsTab)
            Cell:CreateMask(layoutsTab, nil, {1, -1, -1, 1})
            layoutsTab.mask:Hide()
        end
        
        -- UpdateEnabledLayoutText()
        
        if selectedLayout ~= Cell.vars.currentLayout then
            LoadLayoutDB(Cell.vars.currentLayout)
        end
        if selectedRole ~= Cell.vars.playerSpecRole then
            LoadLayoutAutoSwitchDB(Cell.vars.playerSpecRole)
        end
        UpdateButtonStates()
        
        layoutsTab:Show()
    else
        layoutsTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "LayoutsTab_ShowTab", ShowTab)

-------------------------------------------------
-- sharing functions
-------------------------------------------------
function F:ShowLayout(name)
    F:Print(L["Layout imported: %s."]:format(name))
    F:ShowLayousTab()
    LoadLayoutDropdown()
    LoadAutoSwitchDropdowns()
    LoadLayoutDB(name)
    UpdateButtonStates()
end
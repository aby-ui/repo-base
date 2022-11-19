local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local LCG = LibStub("LibCustomGlow-1.0")

local key -- NOTE: key is used for identifying what the glow options belongs to
local glowOptionsTable
local glowOptionsFrame, previewButton

--------------------------------------------------
-- glow preview
--------------------------------------------------
local function CreatePreviewButton()
    previewButton = CreateFrame("Button", "CellGlowsPreviewButton", glowOptionsFrame, "CellPreviewButtonTemplate")
    previewButton:SetPoint("BOTTOMLEFT", glowOptionsFrame, "TOPLEFT", 0, 5)
    previewButton:UnregisterAllEvents()
    previewButton:SetScript("OnEnter", nil)
    previewButton:SetScript("OnLeave", nil)
    previewButton:SetScript("OnShow", nil)
    previewButton:SetScript("OnHide", nil)
    previewButton:SetScript("OnUpdate", nil)
    
    local previewButtonBG = Cell:CreateFrame("CellGlowsPreviewButtonBG", previewButton)
    previewButtonBG:SetPoint("TOPLEFT", previewButton, 0, 20)
    previewButtonBG:SetPoint("BOTTOMRIGHT", previewButton, "TOPRIGHT")
    previewButtonBG:SetFrameStrata("HIGH")
    Cell:StylizeFrame(previewButtonBG, {0.1, 0.1, 0.1, 0.77}, {0, 0, 0, 0})
    previewButtonBG:Show()
    
    local previewText = previewButtonBG:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    previewText:SetPoint("TOP", 0, -3)
    previewText:SetText(Cell:GetAccentColorString()..L["Preview"])
end

local function UpdatePreviewButton()
    if not previewButton then
        CreatePreviewButton()
    end

    local iTable = Cell.vars.currentLayoutTable["indicators"][1]
    if iTable["enabled"] then
        previewButton.indicators.nameText:Show()
        previewButton.state.name = UnitName("player")
        previewButton.indicators.nameText:UpdateName()
        previewButton.indicators.nameText:UpdatePreviewColor(iTable["nameColor"])
        previewButton.indicators.nameText:UpdateTextWidth(iTable["textWidth"])
        previewButton.indicators.nameText:SetFont(unpack(iTable["font"]))
        previewButton.indicators.nameText:ClearAllPoints()
        previewButton.indicators.nameText:SetPoint(unpack(iTable["position"]))
    else
        previewButton.indicators.nameText:Hide()
    end

    P:Size(previewButton, Cell.vars.currentLayoutTable["size"][1], Cell.vars.currentLayoutTable["size"][2])
    previewButton.func.SetOrientation(unpack(Cell.vars.currentLayoutTable["barOrientation"]))
    previewButton.func.SetPowerSize(Cell.vars.currentLayoutTable["powerSize"])

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

    previewButton:Show()
end

-------------------------------------------------
-- glow options
-------------------------------------------------
local glowTypeDropdown, glowColor, glowLines, glowParticles, glowFrequency, glowLength, glowThickness, glowScale, glowOffsetX, glowOffsetY

local function ShowGlowPreview(refresh)
    local glowType, glowOptions = unpack(glowOptionsTable)

    if glowType == "normal" then
        LCG.PixelGlow_Stop(previewButton)
        LCG.AutoCastGlow_Stop(previewButton)
        LCG.ButtonGlow_Start(previewButton, glowOptions[1])
    elseif glowType == "pixel" then
        LCG.ButtonGlow_Stop(previewButton)
        LCG.AutoCastGlow_Stop(previewButton)
        -- color, N, frequency, length, thickness, x, y
        LCG.PixelGlow_Start(previewButton, glowOptions[1], glowOptions[4], glowOptions[5], glowOptions[6], glowOptions[7], glowOptions[2], glowOptions[3])
    elseif glowType == "shine" then
        LCG.ButtonGlow_Stop(previewButton)
        LCG.PixelGlow_Stop(previewButton)
        if refresh then LCG.AutoCastGlow_Stop(previewButton) end
        -- color, N, frequency, scale, x, y
        LCG.AutoCastGlow_Start(previewButton, glowOptions[1], glowOptions[4], glowOptions[5], glowOptions[6], glowOptions[2], glowOptions[3])
    end
end

local function LoadGlowOptions()
    ShowGlowPreview()

    local glowType, glowOptions = unpack(glowOptionsTable)
    glowTypeDropdown:SetSelectedValue(glowType)
    glowColor:SetColor(glowOptions[1])

    if glowType == "normal" then
        glowLines:Show()
        glowLength:Show()
        glowThickness:Show()
        glowParticles:Hide()
        glowScale:Hide()
        glowOffsetX:SetEnabled(false)
        glowOffsetY:SetEnabled(false)
        glowLines:SetEnabled(false)
        glowFrequency:SetEnabled(false)
        glowParticles:SetEnabled(false)
        glowScale:SetEnabled(false)
        glowLength:SetEnabled(false)
        glowThickness:SetEnabled(false)
    elseif glowType == "pixel" then
        glowLines:Show()
        glowLength:Show()
        glowThickness:Show()
        glowParticles:Hide()
        glowScale:Hide()
        glowOffsetX:SetEnabled(true)
        glowOffsetY:SetEnabled(true)
        glowLines:SetEnabled(true)
        glowFrequency:SetEnabled(true)
        glowLength:SetEnabled(true)
        glowThickness:SetEnabled(true)
        glowOffsetX:SetValue(glowOptions[2])
        glowOffsetY:SetValue(glowOptions[3])
        glowLines:SetValue(glowOptions[4])
        glowFrequency:SetValue(glowOptions[5])
        glowLength:SetValue(glowOptions[6])
        glowThickness:SetValue(glowOptions[7])
    elseif glowType == "shine" then
        glowParticles:Show()
        glowScale:Show()
        glowLines:Hide()
        glowLength:Hide()
        glowThickness:Hide()
        glowOffsetX:SetEnabled(true)
        glowOffsetY:SetEnabled(true)
        glowFrequency:SetEnabled(true)
        glowParticles:SetEnabled(true)
        glowScale:SetEnabled(true)
        glowOffsetX:SetValue(glowOptions[2])
        glowOffsetY:SetValue(glowOptions[3])
        glowParticles:SetValue(glowOptions[4])
        glowFrequency:SetValue(glowOptions[5])
        glowScale:SetValue(glowOptions[6]*100)
    end
end

local function UpdateGlowType(glowType)
    glowOptionsTable[1] = glowType

    if glowType == "normal" then
        glowOptionsTable[2] = {glowOptionsTable[2][1]}
    elseif glowType == "pixel" then
        glowOptionsTable[2] = {glowOptionsTable[2][1], 0, 0, 9, 0.25, 8, 2}
    elseif glowType == "shine" then
        glowOptionsTable[2] = {glowOptionsTable[2][1], 0, 0, 9, 0.5, 1}
    end

    LoadGlowOptions()
end

local function SliderValueChanged(index, value, refresh)
    -- update db
    glowOptionsTable[2][index] = value
    -- update preview
    ShowGlowPreview(refresh)
end

local function CreateGlowOptionsFrame()
    glowOptionsFrame = Cell:CreateFrame("CellOptionsFrame_GlowOptions", Cell.frames.optionsFrame, 127, 371)
    Cell.frames.options = glowOptionsFrame
    glowOptionsFrame:SetPoint("BOTTOMLEFT", Cell.frames.optionsFrame, "BOTTOMRIGHT", 5, 0)

    local glowTypeText = glowOptionsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    glowTypeText:SetText(L["Glow Type"])
    glowTypeText:SetPoint("TOPLEFT", 5, -5)

    glowTypeDropdown = Cell:CreateDropdown(glowOptionsFrame, 117)
    glowTypeDropdown:SetPoint("TOPLEFT", 5, -22)
    glowTypeDropdown:SetItems({
        {
            ["text"] = L["Normal"],
            ["value"] = "normal",
            ["onClick"] = function()
                UpdateGlowType("normal")
            end,
        },
        {
            ["text"] = L["Pixel"],
            ["value"] = "pixel",
            ["onClick"] = function()
                UpdateGlowType("pixel")
            end,
        },
        {
            ["text"] = L["Shine"],
            ["value"] = "shine",
            ["onClick"] = function()
                UpdateGlowType("shine")
            end,
        },
    })

    -- glowColor
    glowColor = Cell:CreateColorPicker(glowOptionsFrame, L["Glow Color"], false, function(r, g, b)
        -- update db
        glowOptionsTable[2][1][1] = r
        glowOptionsTable[2][1][2] = g
        glowOptionsTable[2][1][3] = b
        glowOptionsTable[2][1][4] = 1
        -- update preview
        ShowGlowPreview()
    end)
    -- glowColor:SetPoint("TOPLEFT", glowOptionsFrame, 5, 0)
    glowColor:SetPoint("TOPLEFT", glowTypeDropdown, "BOTTOMLEFT", 0, -10)

    -- x
    glowOffsetX = Cell:CreateSlider(L["X Offset"], glowOptionsFrame, -100, 100, 117, 1, function(value)
        SliderValueChanged(2, value)
    end)
    glowOffsetX:SetPoint("TOPLEFT", glowColor, "BOTTOMLEFT", 0, -25)
    
    -- y
    glowOffsetY = Cell:CreateSlider(L["Y Offset"], glowOptionsFrame, -100, 100, 117, 1, function(value)
        SliderValueChanged(3, value)
    end)
    glowOffsetY:SetPoint("TOPLEFT", glowOffsetX, "BOTTOMLEFT", 0, -40)
    
    -- glowNumber
    glowLines = Cell:CreateSlider(L["Lines"], glowOptionsFrame, 1, 30, 117, 1, function(value)
        SliderValueChanged(4, value)
    end)
    glowLines:SetPoint("TOPLEFT", glowOffsetY, "BOTTOMLEFT", 0, -40)

    glowParticles = Cell:CreateSlider(L["Particles"], glowOptionsFrame, 1, 30, 117, 1, function(value)
        SliderValueChanged(4, value, true)
    end)
    glowParticles:SetPoint("TOPLEFT", glowOffsetY, "BOTTOMLEFT", 0, -40)

    -- glowFrequency
    glowFrequency = Cell:CreateSlider(L["Frequency"], glowOptionsFrame, -2, 2, 117, 0.05, function(value)
        SliderValueChanged(5, value)
    end)
    glowFrequency:SetPoint("TOPLEFT", glowLines, "BOTTOMLEFT", 0, -40)

    -- glowLength
    glowLength = Cell:CreateSlider(L["Length"], glowOptionsFrame, 1, 20, 117, 1, function(value)
        SliderValueChanged(6, value)
    end)
    glowLength:SetPoint("TOPLEFT", glowFrequency, "BOTTOMLEFT", 0, -40)

    -- glowThickness
    glowThickness = Cell:CreateSlider(L["Thickness"], glowOptionsFrame, 1, 20, 117, 1, function(value)
        SliderValueChanged(7, value)
    end)
    glowThickness:SetPoint("TOPLEFT", glowLength, "BOTTOMLEFT", 0, -40)

    -- glowScale
    glowScale = Cell:CreateSlider(L["Scale"], glowOptionsFrame, 50, 500, 117, 1, function(value)
        SliderValueChanged(6, value/100)
    end, nil, true)
    glowScale:SetPoint("TOPLEFT", glowFrequency, "BOTTOMLEFT", 0, -40)

    glowOptionsFrame:SetScript("OnHide", function()
        key = nil
        glowOptionsFrame:Hide()
    end)
end

-------------------------------------------------
-- functions
-------------------------------------------------
function F:ShowGlowOptions(parent, k, gTable)
    if not glowOptionsFrame then
        CreateGlowOptionsFrame()
    end

    glowOptionsFrame:SetParent(parent)

    
    if key == k then
        key = nil
        glowOptionsFrame:Hide()
    else
        glowOptionsTable = gTable
        key = k
        UpdatePreviewButton()
        LoadGlowOptions()
        glowOptionsFrame:Show()
    end
end

function F:HideGlowOptions()
    key = nil
    glowOptionsFrame:Hide()
end

-------------------------------------------------
-- callbacks
-------------------------------------------------
local function UpdateLayout()
    if previewButton then
        UpdatePreviewButton()
    end
end
Cell:RegisterCallback("UpdateLayout", "GlowOptions_UpdateLayout", UpdateLayout)

local function UpdateAppearance()
    if previewButton then
        UpdatePreviewButton()
    end
end
Cell:RegisterCallback("UpdateAppearance", "GlowOptions_UpdateAppearance", UpdateAppearance)
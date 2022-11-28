local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs
local P = Cell.pixelPerfectFuncs

local LoadData

local appearanceTab = Cell:CreateFrame("CellOptionsFrame_AppearanceTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.appearanceTab = appearanceTab
appearanceTab:SetAllPoints(Cell.frames.optionsFrame)
appearanceTab:Hide()

-------------------------------------------------
-- cell
-------------------------------------------------
local scaleSlider, accentColorDropdown, accentColorPicker, optionsFontSizeOffset, useGameFontCB

local function CreateCellPane()
    local cellPane = Cell:CreateTitledPane(appearanceTab, "Cell", 422, 120)
    cellPane:SetPoint("TOPLEFT", appearanceTab, "TOPLEFT", 5, -5)
    
    -- global scale
    scaleSlider = Cell:CreateSlider(L["Scale"], cellPane, 0.5, 4, 160, 0.05, nil, nil, nil, L["Scale"], L["Non-integer scaling may result in abnormal display of options UI"])
    scaleSlider:SetPoint("TOPLEFT", cellPane, "TOPLEFT", 5, -40)
    scaleSlider.afterValueChangedFn = function(value)
        CellDB["appearance"]["scale"] = value
        Cell:Fire("UpdateAppearance", "scale")
        Cell:Fire("UpdatePixelPerfect")
    
        local popup = Cell:CreateConfirmPopup(appearanceTab, 200, L["A UI reload is required.\nDo it now?"], function()
            ReloadUI()
        end, nil, true)
        popup:SetPoint("TOPLEFT", appearanceTab, "TOPLEFT", 117, -70)
    end
    Cell:RegisterForCloseDropdown(scaleSlider)

    -- accent color
    accentColorDropdown = Cell:CreateDropdown(cellPane, 141)
    accentColorDropdown:SetPoint("TOPLEFT", 222, -40)
    accentColorDropdown:SetItems({
        {
            ["text"] = L["Class Color"],
            ["value"] = "class_color",
            ["onClick"] = function()
                if CellDB["appearance"]["accentColor"][1] ~= "class_color" then
                    local popup = Cell:CreateConfirmPopup(appearanceTab, 200, L["A UI reload is required.\nDo it now?"], function()
                        ReloadUI()
                    end, nil, true)
                    popup:SetPoint("TOPLEFT", appearanceTab, 117, -77)
                end
                CellDB["appearance"]["accentColor"][1] = "class_color"
                accentColorPicker:SetEnabled(false)
            end
        },
        {
            ["text"] = L["Custom Color"],
            ["value"] = "custom",
            ["onClick"] = function()
                if CellDB["appearance"]["accentColor"][1] ~= "custom" then
                    local popup = Cell:CreateConfirmPopup(appearanceTab, 200, L["A UI reload is required.\nDo it now?"], function()
                        ReloadUI()
                    end, nil, true)
                    popup:SetPoint("TOPLEFT", appearanceTab, 117, -77)
                end
                CellDB["appearance"]["accentColor"][1] = "custom"
                accentColorPicker:SetEnabled(true)
            end
        },
    })

    local accentColorText = cellPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    accentColorText:SetPoint("BOTTOMLEFT", accentColorDropdown, "TOPLEFT", 0, 1)
    accentColorText:SetText(L["Options UI Accent Color"])

    accentColorPicker = Cell:CreateColorPicker(cellPane, "", false, nil, function(r, g, b)
        if CellDB["appearance"]["accentColor"][2][1] ~= r or CellDB["appearance"]["accentColor"][2][2] ~= g or CellDB["appearance"]["accentColor"][2][3] ~= b then
            local popup = Cell:CreateConfirmPopup(appearanceTab, 200, L["A UI reload is required.\nDo it now?"], function()
                ReloadUI()
            end, nil, true)
            popup:SetPoint("TOPLEFT", appearanceTab, 117, -77)
        end

        CellDB["appearance"]["accentColor"][2][1] = r
        CellDB["appearance"]["accentColor"][2][2] = g
        CellDB["appearance"]["accentColor"][2][3] = b
    end)
    accentColorPicker:SetPoint("LEFT", accentColorDropdown, "RIGHT", 5, 0)
    Cell:RegisterForCloseDropdown(accentColorPicker)

    -- options ui font size
    optionsFontSizeOffset = Cell:CreateSlider(L["Options UI Font Size"], cellPane, -5, 5, 160, 1)
    optionsFontSizeOffset:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -40)
    
    optionsFontSizeOffset.afterValueChangedFn = function(value)
        CellDB["appearance"]["optionsFontSizeOffset"] = value
        Cell:UpdateOptionsFont(value, CellDB["appearance"]["useGameFont"])
        Cell:UpdateAboutFont(value)
    end
    
    -- use game font
    useGameFontCB = Cell:CreateCheckButton(cellPane, "Use Game Font", function(checked)
        CellDB["appearance"]["useGameFont"] = checked
        Cell:UpdateOptionsFont(CellDB["appearance"]["optionsFontSizeOffset"], checked)
    end)
    useGameFontCB:SetPoint("TOPLEFT", accentColorDropdown, "BOTTOMLEFT", 0, -30)
    if Cell.isAsian then
        useGameFontCB:Hide()
    end
end

-------------------------------------------------
-- preview icons
-------------------------------------------------
local previewIconsBG, borderIcon1, borderIcon2, barIcon1, barIcon2

local function SetOnUpdate(indicator, type, icon, stack)
    indicator.preview = indicator.preview or CreateFrame("Frame", nil, indicator)
    indicator.preview:SetScript("OnUpdate", function(self, elapsed)
        self.elapsedTime = (self.elapsedTime or 0) + elapsed
        if self.elapsedTime >= 13 then
            self.elapsedTime = 0
            indicator:SetCooldown(GetTime(), 13, type, icon, stack)
        end
    end)
    indicator:SetScript("OnShow", function()
        indicator.preview.elapsedTime = 0
        indicator:SetCooldown(GetTime(), 13, type, icon, stack)
    end)
end

local function SetOnUpdate_Refresh(indicator, type, icon, stack)
    indicator.preview = indicator.preview or CreateFrame("Frame", nil, indicator)
    indicator.preview:SetScript("OnUpdate", function(self, elapsed)
        self.elapsedTime = (self.elapsedTime or 0) + elapsed
        if self.elapsedTime >= 5 then
            self.elapsedTime = 0
            indicator:SetCooldown(GetTime(), 13, type, icon, stack, true)
        end
    end)
    indicator:SetScript("OnShow", function()
        indicator.preview.elapsedTime = 0
        indicator:SetCooldown(GetTime(), 13, type, icon, stack)
    end)
end

--[=[ update font
local function UpdatePreviewIcons(layout, indicatorName, setting, value, value2)
    if not indicatorName or indicatorName == "raidDebuffs" then
        borderIcon1:SetFont(unpack(Cell.vars.currentLayoutTable.indicators[Cell.defaults.indicatorIndices["raidDebuffs"]].font))
        borderIcon2:SetFont(unpack(Cell.vars.currentLayoutTable.indicators[Cell.defaults.indicatorIndices["raidDebuffs"]].font))
    end
    if not indicatorName or indicatorName == "debuffs" then
        barIcon1:SetFont(unpack(Cell.vars.currentLayoutTable.indicators[Cell.defaults.indicatorIndices["debuffs"]].font))
        barIcon2:SetFont(unpack(Cell.vars.currentLayoutTable.indicators[Cell.defaults.indicatorIndices["debuffs"]].font))
    end
end]=]

local function CreatePreviewIcons()
    previewIconsBG = Cell:CreateFrame("CellAppearancePreviewIconsBG", appearanceTab)
    previewIconsBG:SetPoint("TOPLEFT", appearanceTab, "TOPRIGHT", 5, -160)
    P:Size(previewIconsBG, 95, 45)
    previewIconsBG:SetFrameStrata("HIGH")
    Cell:StylizeFrame(previewIconsBG, {0.1, 0.1, 0.1, 0.77}, {0, 0, 0, 0})
    previewIconsBG:Show()

    local previewText = previewIconsBG:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    previewText:SetPoint("TOP", 0, -3)
    previewText:SetText(Cell:GetAccentColorString()..L["Preview"].." 1")

    borderIcon1 = I:CreateAura_BorderIcon("CellAppearancePreviewIcon1", previewIconsBG, 2)
    borderIcon1:SetFont("Cell ".._G.DEFAULT, 11, "Outline", 2, 1)
    P:Size(borderIcon1, 22, 22)
    borderIcon1:SetPoint("BOTTOMLEFT")
    SetOnUpdate(borderIcon1, "Magic", 135819, 0)
    borderIcon1:Show()

    borderIcon2 = I:CreateAura_BorderIcon("CellAppearancePreviewIcon2", previewIconsBG, 2)
    borderIcon2:SetFont("Cell ".._G.DEFAULT, 11, "Outline", 2, 1)
    P:Size(borderIcon2, 22, 22)
    borderIcon2:SetPoint("BOTTOMLEFT", borderIcon1, "BOTTOMRIGHT", P:Scale(1), 0)
    borderIcon2.preview = CreateFrame("Frame", nil, borderIcon2)
    borderIcon2.preview:SetScript("OnUpdate", function(self, elapsed)
        self.elapsedTime = (self.elapsedTime or 0) + elapsed
        if self.elapsedTime >= 6 then
            self.elapsedTime = 0
            self.stack = self.stack + 1
            borderIcon2:SetCooldown(GetTime(), 13, "", 135718, self.stack, Cell.vars.iconAnimation ~= "never")
        end
    end)
    borderIcon2:SetScript("OnShow", function()
        borderIcon2.preview.stack = 1
        borderIcon2.preview.elapsedTime = 0
        borderIcon2:SetCooldown(GetTime(), 13, "", 135718, 1)
    end)
    borderIcon2:Show()

    barIcon2 = I:CreateAura_BarIcon("CellAppearancePreviewIcon4", previewIconsBG)
    barIcon2:SetFont("Cell ".._G.DEFAULT, 11, "Outline", 2, 1)
    P:Size(barIcon2, 22, 22)
    barIcon2:SetPoint("BOTTOMRIGHT")
    barIcon2.preview = CreateFrame("Frame", nil, barIcon2)
    barIcon2.preview:SetScript("OnUpdate", function(self, elapsed)
        self.elapsedTime = (self.elapsedTime or 0) + elapsed
        if self.elapsedTime >= 6 then
            self.elapsedTime = 0
            barIcon2:SetCooldown(GetTime(), 13, nil, 136085, 0, Cell.vars.iconAnimation == "duration")
        end
    end)
    barIcon2:SetScript("OnShow", function()
        barIcon2.preview.elapsedTime = 0
        barIcon2:SetCooldown(GetTime(), 13, nil, 136085, 0)
    end)
    barIcon2:Show()

    barIcon1 = I:CreateAura_BarIcon("CellAppearancePreviewIcon3", previewIconsBG)
    barIcon1:SetFont("Cell ".._G.DEFAULT, 11, "Outline", 2, 1)
    P:Size(barIcon1, 22, 22)
    barIcon1:SetPoint("BOTTOMRIGHT", barIcon2, "BOTTOMLEFT", P:Scale(-1), 0)
    barIcon1:ShowDuration(true)
    SetOnUpdate(barIcon1, "", 132155, 5)
    barIcon1:Show()

    -- UpdatePreviewIcons()
end

-------------------------------------------------
-- preview button
-------------------------------------------------
local previewButton, previewButton2

local function CreatePreviewButtons()
    previewButton = CreateFrame("Button", "CellAppearancePreviewButton", appearanceTab, "CellPreviewButtonTemplate")
    previewButton:SetPoint("TOPLEFT", previewIconsBG, "BOTTOMLEFT", 0, -50)
    previewButton:UnregisterAllEvents()
    previewButton:SetScript("OnEnter", nil)
    previewButton:SetScript("OnLeave", nil)
    previewButton:SetScript("OnUpdate", nil)
    previewButton:Show()

    previewButton.previewHealthText = previewButton.widget.overlayFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    previewButton.previewHealthText:SetPoint("CENTER")
    
    local previewButtonBG = Cell:CreateFrame("CellAppearancePreviewButtonBG", appearanceTab)
    previewButtonBG:SetPoint("TOPLEFT", previewButton, 0, 20)
    previewButtonBG:SetPoint("BOTTOMRIGHT", previewButton, "TOPRIGHT")
    previewButtonBG:SetFrameStrata("HIGH")
    Cell:StylizeFrame(previewButtonBG, {0.1, 0.1, 0.1, 0.77}, {0, 0, 0, 0})
    previewButtonBG:Show()
    
    local previewText = previewButtonBG:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    previewText:SetPoint("TOP", 0, -3)
    previewText:SetText(Cell:GetAccentColorString()..L["Preview"].." 2")
    
    previewButton2 = CreateFrame("Button", "CellAppearancePreviewButton2", appearanceTab, "CellPreviewButtonTemplate")
    previewButton2:SetPoint("TOPLEFT", previewButton, "BOTTOMLEFT", 0, -50)
    previewButton2:UnregisterAllEvents()
    previewButton2:SetScript("OnEnter", nil)
    previewButton2:SetScript("OnLeave", nil)
    previewButton2:SetScript("OnUpdate", nil)
    previewButton2:Show()

    local previewButtonBG2 = Cell:CreateFrame("CellAppearancePreviewButtonBG2", appearanceTab)
    previewButtonBG2:SetPoint("TOPLEFT", previewButton2, 0, 20)
    previewButtonBG2:SetPoint("BOTTOMRIGHT", previewButton2, "TOPRIGHT")
    previewButtonBG2:SetFrameStrata("HIGH")
    Cell:StylizeFrame(previewButtonBG2, {0.1, 0.1, 0.1, 0.77}, {0, 0, 0, 0})
    previewButtonBG2:Show()
    
    local previewText2 = previewButtonBG2:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    previewText2:SetPoint("TOP", 0, -3)
    previewText2:SetText(Cell:GetAccentColorString()..L["Preview"].." 3")

    -- animation
    local states = {-20, -30, -40, 50, -60, 0, 100, 0}
    local ticker
    previewButton:SetScript("OnShow", function()
        previewButton.perc = 1
        previewButton.widget.healthBar:SetSmoothedValue(100)
        previewButton.widget.healthBar:SetValue(100)
        previewButton.previewHealthText:SetText("100%")

        local health, healthPercent, healthPercentOld, currentState = 100, 1, 1, 1

        ticker = C_Timer.NewTicker(1, function()
            health = health + states[currentState]
            healthPercent = health / 100
            previewButton.perc = healthPercent

            if CellDB["appearance"]["barAnimation"] == "Flash" then
                previewButton.widget.healthBar:SetValue(health)

                local diff = healthPercent - (healthPercentOld or healthPercent)
                if diff >= 0 then
                    previewButton.func.HideFlash()
                    -- previewButton.widget.damageFlashTex:Hide()
                elseif diff <= -0.05 and diff >= -1 then
                    previewButton.func.ShowFlash(abs(diff))
                    -- print(abs(diff))
                    -- previewButton.widget.damageFlashTex:SetWidth((Cell.vars.currentLayoutTable["size"][1] - 2) * abs(diff))
                    -- previewButton.widget.damageFlashTex:Show()
                end
            elseif CellDB["appearance"]["barAnimation"] == "Smooth" then
                previewButton.widget.healthBar:SetSmoothedValue(health)
            else
                previewButton.widget.healthBar:SetValue(health)
            end

            -- update text
            if health == 0 then
                previewButton.previewHealthText:SetText(L["DEAD"])
            else
                previewButton.previewHealthText:SetText(health.."%")
            end

            -- update color
            local r, g, b, lossR, lossG, lossB = F:GetHealthColor(healthPercent, health == 0, F:GetClassColor(Cell.vars.playerClass))
            previewButton.widget.healthBar:SetStatusBarColor(r, g, b, CellDB["appearance"]["barAlpha"])
            previewButton.widget.healthBarLoss:SetVertexColor(lossR, lossG, lossB, CellDB["appearance"]["lossAlpha"])

            healthPercentOld = healthPercent
            currentState = currentState == 8 and 1 or (currentState + 1)
        end)
    end)

    previewButton:SetScript("OnHide", function()
        previewButton.perc = 100
        ticker:Cancel()
        ticker = nil
    end)

    Cell:Fire("CreatePreview", previewButton, previewButton2)
end

local function UpdatePreviewShields(r, g, b)
    if CellDB["appearance"]["healPrediction"][1] then
        previewButton2.widget.incomingHeal:SetValue(0.2)
        if CellDB["appearance"]["healPrediction"][2] then
            previewButton2.widget.incomingHeal:SetVertexColor(CellDB["appearance"]["healPrediction"][3][1], CellDB["appearance"]["healPrediction"][3][2], CellDB["appearance"]["healPrediction"][3][3], CellDB["appearance"]["healPrediction"][3][4])
        else
            previewButton2.widget.incomingHeal:SetVertexColor(r, g, b, 0.4)
        end
    else
        previewButton2.widget.incomingHeal:Hide()
    end

    if Cell.isRetail then
        if CellDB["appearance"]["healAbsorb"][1] then
            previewButton2.widget.absorbsBar:SetValue(0.3)
            previewButton2.widget.absorbsBar:SetVertexColor(CellDB["appearance"]["healAbsorb"][2][1], CellDB["appearance"]["healAbsorb"][2][2], CellDB["appearance"]["healAbsorb"][2][3], CellDB["appearance"]["healAbsorb"][2][4])
        else
            previewButton2.widget.absorbsBar:Hide()
        end
    end

    if CellDB["appearance"]["shield"][1] then
        previewButton2.widget.shieldBar:SetValue(0.4)
        previewButton2.widget.shieldBar:SetVertexColor(CellDB["appearance"]["shield"][2][1], CellDB["appearance"]["shield"][2][2], CellDB["appearance"]["shield"][2][3], CellDB["appearance"]["shield"][2][4])
    else
        previewButton2.widget.shieldBar:Hide()
    end

    if CellDB["appearance"]["overshield"] then
        previewButton2.widget.overShieldGlow:Show()
    else
        previewButton2.widget.overShieldGlow:Hide()
    end
end

local function UpdatePreviewButton()
    previewButton.widget.healthBar:SetStatusBarTexture(Cell.vars.texture)
    previewButton.widget.healthBarLoss:SetTexture(Cell.vars.texture)
    previewButton.widget.powerBar:SetStatusBarTexture(Cell.vars.texture)
    previewButton.widget.powerBarLoss:SetTexture(Cell.vars.texture)
    previewButton.widget.incomingHeal:SetTexture(Cell.vars.texture)
    previewButton.widget.damageFlashTex:SetTexture(Cell.vars.texture)

    previewButton2.widget.healthBar:SetStatusBarTexture(Cell.vars.texture)
    previewButton2.widget.healthBarLoss:SetTexture(Cell.vars.texture)
    previewButton2.widget.powerBar:SetStatusBarTexture(Cell.vars.texture)
    previewButton2.widget.powerBarLoss:SetTexture(Cell.vars.texture)
    previewButton2.widget.incomingHeal:SetTexture(Cell.vars.texture)
    previewButton2.widget.damageFlashTex:SetTexture(Cell.vars.texture)

    -- power color
    local r, g, b = F:GetPowerColor("player", Cell.vars.playerClass)
    previewButton.widget.powerBar:SetStatusBarColor(r, g, b)
    previewButton2.widget.powerBar:SetStatusBarColor(r, g, b)

    -- alpha
    previewButton:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
    previewButton2:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
    
    -- barOrientation
    previewButton.func.SetOrientation(unpack(Cell.vars.currentLayoutTable["barOrientation"]))
    previewButton2.func.SetOrientation(unpack(Cell.vars.currentLayoutTable["barOrientation"]))

    -- size
    P:Size(previewButton, Cell.vars.currentLayoutTable["size"][1], Cell.vars.currentLayoutTable["size"][2])
    previewButton.func.SetPowerSize(Cell.vars.currentLayoutTable["powerSize"])
    P:Size(previewButton2, Cell.vars.currentLayoutTable["size"][1], Cell.vars.currentLayoutTable["size"][2])
    previewButton2.func.SetPowerSize(Cell.vars.currentLayoutTable["powerSize"])

    -- value
    if CellDB["appearance"]["barAnimation"] == "Smooth" then
        previewButton.widget.healthBar:SetMinMaxSmoothedValue(0, 100)
    else
        previewButton.widget.healthBar:SetMinMaxValues(0, 100)
    end
    
    previewButton2.widget.healthBar:SetMinMaxValues(0, 100)
    previewButton2.widget.healthBar:SetValue(60)
    previewButton2.state.healthMax = 100
    previewButton2.state.healthPercent = 0.6


    -- health color
    local r, g, b, lossR, lossG, lossB 
    r, g, b, lossR, lossG, lossB = F:GetHealthColor(previewButton.perc or 1, previewButton.perc == 0, F:GetClassColor(Cell.vars.playerClass))
    previewButton.widget.healthBar:SetStatusBarColor(r, g, b, CellDB["appearance"]["barAlpha"])
    previewButton.widget.healthBarLoss:SetVertexColor(lossR, lossG, lossB, CellDB["appearance"]["lossAlpha"])

    r, g, b, lossR, lossG, lossB = F:GetHealthColor(0.6, false, F:GetClassColor(Cell.vars.playerClass))
    previewButton2.widget.healthBar:SetStatusBarColor(r, g, b, CellDB["appearance"]["barAlpha"])
    previewButton2.widget.healthBarLoss:SetVertexColor(lossR, lossG, lossB, CellDB["appearance"]["lossAlpha"])

    UpdatePreviewShields(r, g, b)

    previewButton.loaded = true

    Cell:Fire("UpdatePreview", previewButton, previewButton2)
end

-------------------------------------------------
-- unitbutton
-------------------------------------------------
local textureDropdown, barColorDropdown, barColorPicker, lossColorDropdown, lossColorPicker, deathColorCB, deathColorPicker, powerColorDropdown, powerColorPicker, barAnimationDropdown, targetColorPicker, mouseoverColorPicker, highlightSize
local barAlpha, lossAlpha, bgAlpha, oorAlpha, predCB, useLibCB, absorbCB, shieldCB, oversCB, resetBtn
local predCustomCB, predColorPicker, absorbColorPicker, shieldColorPicker
local iconOptionsBtn, iconOptionsFrame, iconAnimationDropdown, durationRoundUpCB, durationDecimalText1, durationDecimalText2, durationDecimalDropdown, durationColorCB, durationNormalCP, durationPercentCP, durationSecondCP, durationPercentDD, durationSecondEB, durationSecondText

local LSM = LibStub("LibSharedMedia-3.0", true)
local function CheckTextures()
    local items = {}
    local textures, textureNames
    local defaultTexture, defaultTextureName = "Interface\\AddOns\\Cell\\Media\\statusbar.tga", "Cell ".._G.DEFAULT
    
    -- if LSM then
        textures, textureNames = F:Copy(LSM:HashTable("statusbar")), F:Copy(LSM:List("statusbar"))
       
        -- make default texture first
        F:TRemove(textureNames, defaultTextureName)
        tinsert(textureNames, 1, defaultTextureName)

        for _, name in pairs(textureNames) do
            tinsert(items, {
                ["text"] = name,
                ["texture"] = textures[name],
                ["onClick"] = function()
                    CellDB["appearance"]["texture"] = name
                    F:GetBarTexture() -- update Cell.vars.texture NOW
                    Cell:Fire("UpdateAppearance", "texture")
                end,
            })
        end
    -- else
    --     textureNames = {defaultTextureName}
    --     textures = {[defaultTextureName] = defaultTexture}

    --     tinsert(items, {
    --         ["text"] = defaultTextureName,
    --         ["texture"] = defaultTexture,
    --         ["onClick"] = function()
    --             CellDB["appearance"]["texture"] = defaultTextureName
    --             F:GetBarTexture() -- update Cell.vars.texture NOW
    --             Cell:Fire("UpdateAppearance", "texture")
    --         end,
    --     })
    -- end
    textureDropdown:SetItems(items)

    -- validation
    if textures[CellDB["appearance"]["texture"]] then
        textureDropdown:SetSelected(CellDB["appearance"]["texture"], textures[CellDB["appearance"]["texture"]])
    else
        textureDropdown:SetSelected(defaultTextureName, defaultTexture)
    end
end

local function CreateIconOptionsFrame()
    if not appearanceTab.mask then
        Cell:CreateMask(appearanceTab, nil, {1, -1, -1, 1})
        appearanceTab.mask:Hide()
    end

    iconOptionsFrame = Cell:CreateFrame("CellOptionsFrame_IconOptions", appearanceTab, 230, 235)
    iconOptionsFrame:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
    iconOptionsFrame:SetPoint("TOP", iconOptionsBtn, "BOTTOM", 0, -5)
    iconOptionsFrame:SetPoint("RIGHT", -5, 0)
    iconOptionsFrame:SetFrameStrata("DIALOG")
    iconOptionsFrame:SetFrameLevel(50)

    iconOptionsFrame:SetScript("OnShow", function()
        appearanceTab.mask:Show()
        iconOptionsBtn:SetFrameStrata("DIALOG")
    end)
    iconOptionsFrame:SetScript("OnHide", function()
        iconOptionsFrame:Hide()
        appearanceTab.mask:Hide()
        iconOptionsBtn:SetFrameStrata("HIGH")
    end)

    -- icon animation
    iconAnimationDropdown = Cell:CreateDropdown(iconOptionsFrame, 180)
    iconAnimationDropdown:SetPoint("TOPLEFT", iconOptionsFrame, 10, -25)
    iconAnimationDropdown:SetItems({
        {
            ["text"] = L["+ Stack & Duration"],
            ["value"] = "duration",
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["animation"] = "duration"
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
        {
            ["text"] = L["+ Stack"],
            ["value"] = "stack",
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["animation"] = "stack"
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
        {
            ["text"] = L["Never"],
            ["value"] = "never",
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["animation"] = "never"
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
    })
    
    local iconAnimationText = iconOptionsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    iconAnimationText:SetPoint("BOTTOMLEFT", iconAnimationDropdown, "TOPLEFT", 0, 1)
    iconAnimationText:SetText(L["Play Icon Animation When"])

    -- duration round up
    durationRoundUpCB = Cell:CreateCheckButton(iconOptionsFrame, L["Round Up Duration Text"], function(checked, self)
        CellDropdownList:Hide()

        CellDB["appearance"]["auraIconOptions"]["durationRoundUp"] = checked
        Cell:SetEnabled(not checked, durationDecimalText1, durationDecimalText2, durationDecimalDropdown)
        
        Cell:Fire("UpdateAppearance", "icon")
    end)
    durationRoundUpCB:SetPoint("TOPLEFT", iconAnimationDropdown, "BOTTOMLEFT", 0, -22)

    -- duration decimal
    durationDecimalText1 = iconOptionsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    durationDecimalText1:SetPoint("TOPLEFT", durationRoundUpCB, "BOTTOMLEFT", 0, -10)
    durationDecimalText1:SetText(L["Display One Decimal Place When"])

    durationDecimalText2 = iconOptionsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    durationDecimalText2:SetPoint("TOPLEFT", durationDecimalText1, "BOTTOMLEFT", 0, -5)
    durationDecimalText2:SetText(L["Remaining Time <"])

    durationDecimalDropdown = Cell:CreateDropdown(iconOptionsFrame, 60)
    durationDecimalDropdown:SetPoint("LEFT", durationDecimalText2, "RIGHT", 5, 0)

    local items = {}
    for i = 5, 0, -1 do
        tinsert(items, {
            ["text"] = i == 0 and _G.NONE or i,
            ["value"] = i,
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["durationDecimal"] = i
                Cell:Fire("UpdateAppearance", "icon")
            end
        })
    end
    durationDecimalDropdown:SetItems(items)
    
    -- duration text color
    durationColorCB = Cell:CreateCheckButton(iconOptionsFrame, L["Color Duration Text"], function(checked, self)
        CellDropdownList:Hide()

        -- restore sec
        durationSecondEB:SetText(CellDB["appearance"]["auraIconOptions"]["durationColors"][3][4])
        durationSecondEB.confirmBtn:Hide()

        CellDB["appearance"]["auraIconOptions"]["durationColorEnabled"] = checked
        Cell:SetEnabled(checked, durationNormalCP, durationPercentCP, durationPercentDD, durationSecondCP, durationSecondEB, durationSecondText)
        
        Cell:Fire("UpdateAppearance", "icon")
    end)
    durationColorCB:SetPoint("TOPLEFT", durationRoundUpCB, "BOTTOMLEFT", 0, -63)

    durationNormalCP = Cell:CreateColorPicker(iconOptionsFrame, L["Normal"], false, function(r, g, b)
        CellDB["appearance"]["auraIconOptions"]["durationColors"][1][1] = r
        CellDB["appearance"]["auraIconOptions"]["durationColors"][1][2] = g
        CellDB["appearance"]["auraIconOptions"]["durationColors"][1][3] = b
        Cell:Fire("UpdateAppearance", "icon")
    end)
    durationNormalCP:SetPoint("TOPLEFT", durationColorCB, "BOTTOMLEFT", 0, -8)
    
    durationPercentCP = Cell:CreateColorPicker(iconOptionsFrame, L["Remaining Time <"], false, function(r, g, b)
        CellDB["appearance"]["auraIconOptions"]["durationColors"][2][1] = r
        CellDB["appearance"]["auraIconOptions"]["durationColors"][2][2] = g
        CellDB["appearance"]["auraIconOptions"]["durationColors"][2][3] = b
        Cell:Fire("UpdateAppearance", "icon")
    end)
    durationPercentCP:SetPoint("TOPLEFT", durationNormalCP, "BOTTOMLEFT", 0, -8)
    
    durationSecondCP = Cell:CreateColorPicker(iconOptionsFrame, L["Remaining Time <"], false, function(r, g, b)
        CellDB["appearance"]["auraIconOptions"]["durationColors"][3][1] = r
        CellDB["appearance"]["auraIconOptions"]["durationColors"][3][2] = g
        CellDB["appearance"]["auraIconOptions"]["durationColors"][3][3] = b
        Cell:Fire("UpdateAppearance", "icon")
    end)
    durationSecondCP:SetPoint("TOPLEFT", durationPercentCP, "BOTTOMLEFT", 0, -8)

    durationPercentDD = Cell:CreateDropdown(iconOptionsFrame, 60)
    durationPercentDD:SetPoint("LEFT", durationPercentCP.label, "RIGHT", 5, 0)
    durationPercentDD:SetItems({
        {
            ["text"] = "75%",
            ["value"] = 0.75,
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["durationColors"][2][4] = 0.75
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
        {
            ["text"] = "50%",
            ["value"] = 0.5,
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["durationColors"][2][4] = 0.5
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
        {
            ["text"] = "25%",
            ["value"] = 0.25,
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["durationColors"][2][4] = 0.25
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
        {
            ["text"] = _G.NONE,
            ["value"] = 0,
            ["onClick"] = function()
                CellDB["appearance"]["auraIconOptions"]["durationColors"][2][4] = 0
                Cell:Fire("UpdateAppearance", "icon")
            end,
        },
    })
    
    durationSecondEB = Cell:CreateEditBox(iconOptionsFrame, 43, 20, false, false, true)
    durationSecondEB:SetPoint("LEFT", durationSecondCP.label, "RIGHT", 5, 0)
    durationSecondEB:SetMaxLetters(4)

    durationSecondEB.confirmBtn = Cell:CreateButton(iconOptionsFrame, "OK", "accent", {27, 20})
    durationSecondEB.confirmBtn:SetPoint("LEFT", durationSecondEB, "RIGHT", -1, 0)
    durationSecondEB.confirmBtn:Hide()
    durationSecondEB.confirmBtn:SetScript("OnHide", function()
        durationSecondEB.confirmBtn:Hide()
    end)
    durationSecondEB.confirmBtn:SetScript("OnClick", function()
        local newSec = tonumber(durationSecondEB:GetText())
        durationSecondEB:SetText(newSec)
        durationSecondEB.confirmBtn:Hide()

        CellDB["appearance"]["auraIconOptions"]["durationColors"][3][4] = newSec

        Cell:Fire("UpdateAppearance", "icon")
    end)

    durationSecondEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            local newSec = tonumber(self:GetText())
            if newSec and newSec ~= "" then
                durationSecondEB.confirmBtn:Show()
            else
                durationSecondEB.confirmBtn:Hide()
            end
        end
    end)

    durationSecondText = iconOptionsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    durationSecondText:SetPoint("LEFT", durationSecondEB, "RIGHT", 5, 0)
    durationSecondText:SetText(L["sec"])
end

local function CreateUnitButtonStylePane()
    local unitButtonPane = Cell:CreateTitledPane(appearanceTab, L["Unit Button Style"], 422, 410)
    unitButtonPane:SetPoint("TOPLEFT", appearanceTab, "TOPLEFT", 5, -140)
    
    -- texture
    textureDropdown = Cell:CreateDropdown(unitButtonPane, 160, "texture")
    textureDropdown:SetPoint("TOPLEFT", unitButtonPane, "TOPLEFT", 5, -42)
    
    local textureText = unitButtonPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    textureText:SetPoint("BOTTOMLEFT", textureDropdown, "TOPLEFT", 0, 1)
    textureText:SetText(L["Texture"])
    
    -- bar color
    barColorDropdown = Cell:CreateDropdown(unitButtonPane, 141)
    barColorDropdown:SetPoint("TOPLEFT", textureDropdown, "BOTTOMLEFT", 0, -30)
    barColorDropdown:SetItems({
        {
            ["text"] = L["Class Color"],
            ["value"] = "class_color",
            ["onClick"] = function()
                CellDB["appearance"]["barColor"][1] = "class_color"
                barColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Class Color (dark)"],
            ["value"] = "class_color_dark",
            ["onClick"] = function()
                CellDB["appearance"]["barColor"][1] = "class_color_dark"
                barColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Gradient"],
            ["value"] = "gradient",
            ["onClick"] = function()
                CellDB["appearance"]["barColor"][1] = "gradient"
                barColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Gradient"].." 2",
            ["value"] = "gradient2",
            ["onClick"] = function()
                CellDB["appearance"]["barColor"][1] = "gradient2"
                barColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Custom Color"],
            ["value"] = "custom",
            ["onClick"] = function()
                CellDB["appearance"]["barColor"][1] = "custom"
                barColorPicker:SetEnabled(true)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
    })
    
    local barColorText = unitButtonPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    barColorText:SetPoint("BOTTOMLEFT", barColorDropdown, "TOPLEFT", 0, 1)
    barColorText:SetText(L["Health Bar Color"])
    
    barColorPicker = Cell:CreateColorPicker(unitButtonPane, "", false, function(r, g, b)
        CellDB["appearance"]["barColor"][2][1] = r
        CellDB["appearance"]["barColor"][2][2] = g
        CellDB["appearance"]["barColor"][2][3] = b
        if CellDB["appearance"]["barColor"][1] == "custom" then
            Cell:Fire("UpdateAppearance", "color")
        end
    end)
    barColorPicker:SetPoint("LEFT", barColorDropdown, "RIGHT", 5, 0)
    
    -- loss color
    lossColorDropdown = Cell:CreateDropdown(unitButtonPane, 141)
    lossColorDropdown:SetPoint("TOPLEFT", barColorDropdown, "BOTTOMLEFT", 0, -30)
    lossColorDropdown:SetItems({
        {
            ["text"] = L["Class Color"],
            ["value"] = "class_color",
            ["onClick"] = function()
                CellDB["appearance"]["lossColor"][1] = "class_color"
                lossColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Class Color (dark)"],
            ["value"] = "class_color_dark",
            ["onClick"] = function()
                CellDB["appearance"]["lossColor"][1] = "class_color_dark"
                lossColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Gradient"],
            ["value"] = "gradient",
            ["onClick"] = function()
                CellDB["appearance"]["lossColor"][1] = "gradient"
                lossColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Gradient"].." 2",
            ["value"] = "gradient2",
            ["onClick"] = function()
                CellDB["appearance"]["lossColor"][1] = "gradient2"
                lossColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Custom Color"],
            ["value"] = "custom",
            ["onClick"] = function()
                CellDB["appearance"]["lossColor"][1] = "custom"
                lossColorPicker:SetEnabled(true)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
    })
    
    local lossColorText = unitButtonPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    lossColorText:SetPoint("BOTTOMLEFT", lossColorDropdown, "TOPLEFT", 0, 1)
    lossColorText:SetText(L["Health Loss Color"])
    
    lossColorPicker = Cell:CreateColorPicker(unitButtonPane, "", false, function(r, g, b)
        CellDB["appearance"]["lossColor"][2][1] = r
        CellDB["appearance"]["lossColor"][2][2] = g
        CellDB["appearance"]["lossColor"][2][3] = b
        if CellDB["appearance"]["lossColor"][1] == "custom" then
            Cell:Fire("UpdateAppearance", "color")
        end
    end)
    lossColorPicker:SetPoint("LEFT", lossColorDropdown, "RIGHT", 5, 0)

    -- death color
    deathColorCB = Cell:CreateCheckButton(unitButtonPane, "", function(checked, self)
        CellDB["appearance"]["deathColor"][1] = checked
        deathColorPicker:SetEnabled(checked)
        Cell:Fire("UpdateAppearance", "deathColor")
    end, L["Enable Death Color"])
    deathColorCB:SetPoint("TOPLEFT", lossColorPicker, "TOPRIGHT", 2, 0)

    deathColorPicker = Cell:CreateColorPicker(unitButtonPane, "", false, function(r, g, b)
        CellDB["appearance"]["deathColor"][2][1] = r
        CellDB["appearance"]["deathColor"][2][2] = g
        CellDB["appearance"]["deathColor"][2][3] = b
        if CellDB["appearance"]["deathColor"][1] then
            Cell:Fire("UpdateAppearance", "deathColor")
        end
    end)
    deathColorPicker:SetPoint("TOPLEFT", deathColorCB, "TOPRIGHT", 2, 0)
    
    -- power color
    powerColorDropdown = Cell:CreateDropdown(unitButtonPane, 141)
    powerColorDropdown:SetPoint("TOPLEFT", lossColorDropdown, "BOTTOMLEFT", 0, -30)
    powerColorDropdown:SetItems({
        {
            ["text"] = L["Power Color"],
            ["value"] = "power_color",
            ["onClick"] = function()
                CellDB["appearance"]["powerColor"][1] = "power_color"
                powerColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Power Color (dark)"],
            ["value"] = "power_color_dark",
            ["onClick"] = function()
                CellDB["appearance"]["powerColor"][1] = "power_color_dark"
                powerColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Class Color"],
            ["value"] = "class_color",
            ["onClick"] = function()
                CellDB["appearance"]["powerColor"][1] = "class_color"
                powerColorPicker:SetEnabled(false)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
        {
            ["text"] = L["Custom Color"],
            ["value"] = "custom",
            ["onClick"] = function()
                CellDB["appearance"]["powerColor"][1] = "custom"
                powerColorPicker:SetEnabled(true)
                Cell:Fire("UpdateAppearance", "color")
            end,
        },
    })
    
    local powerColorText = unitButtonPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    powerColorText:SetPoint("BOTTOMLEFT", powerColorDropdown, "TOPLEFT", 0, 1)
    powerColorText:SetText(L["Power Color"])
    
    powerColorPicker = Cell:CreateColorPicker(unitButtonPane, "", false, function(r, g, b)
        CellDB["appearance"]["powerColor"][2][1] = r
        CellDB["appearance"]["powerColor"][2][2] = g
        CellDB["appearance"]["powerColor"][2][3] = b
        if CellDB["appearance"]["powerColor"][1] == "custom" then
            Cell:Fire("UpdateAppearance", "color")
        end
    end)
    powerColorPicker:SetPoint("LEFT", powerColorDropdown, "RIGHT", 5, 0)
    
    -- bar animation
    barAnimationDropdown = Cell:CreateDropdown(unitButtonPane, 141)
    barAnimationDropdown:SetPoint("TOPLEFT", powerColorDropdown, "BOTTOMLEFT", 0, -30)
    barAnimationDropdown:SetItems({
        {
            ["text"] = L["Flash"],
            ["onClick"] = function()
                CellDB["appearance"]["barAnimation"] = "Flash"
                Cell:Fire("UpdateAppearance", "animation")
            end,
        },
        {
            ["text"] = L["Smooth"],
            ["onClick"] = function()
                CellDB["appearance"]["barAnimation"] = "Smooth"
                Cell:Fire("UpdateAppearance", "animation")
            end,
        },
        {
            ["text"] = L["None"],
            ["onClick"] = function()
                CellDB["appearance"]["barAnimation"] = "None"
                Cell:Fire("UpdateAppearance", "animation")
            end,
        },
    })
    
    local barAnimationText = unitButtonPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    barAnimationText:SetPoint("BOTTOMLEFT", barAnimationDropdown, "TOPLEFT", 0, 1)
    barAnimationText:SetText(L["Bar Animation"])
    
    -- target highlight
    targetColorPicker = Cell:CreateColorPicker(unitButtonPane, L["Target Highlight Color"], true, function(r, g, b, a)
        CellDB["appearance"]["targetColor"][1] = r
        CellDB["appearance"]["targetColor"][2] = g
        CellDB["appearance"]["targetColor"][3] = b
        CellDB["appearance"]["targetColor"][4] = a
        Cell:Fire("UpdateAppearance", "highlightColor")
    end)
    targetColorPicker:SetPoint("TOPLEFT", barAnimationDropdown, "BOTTOMLEFT", 0, -30)
    
    -- mouseover highlight
    mouseoverColorPicker = Cell:CreateColorPicker(unitButtonPane, L["Mouseover Highlight Color"], true, function(r, g, b, a)
        CellDB["appearance"]["mouseoverColor"][1] = r
        CellDB["appearance"]["mouseoverColor"][2] = g
        CellDB["appearance"]["mouseoverColor"][3] = b
        CellDB["appearance"]["mouseoverColor"][4] = a
        Cell:Fire("UpdateAppearance", "highlightColor")
    end)
    mouseoverColorPicker:SetPoint("TOPLEFT", targetColorPicker, "BOTTOMLEFT", 0, -10)
    
    -- highlight size
    highlightSize = Cell:CreateSlider(L["Highlight Size"], unitButtonPane, -5, 5, 141, 1)
    highlightSize:SetPoint("TOPLEFT", mouseoverColorPicker, "BOTTOMLEFT", 0, -25)
    highlightSize.afterValueChangedFn = function(value)
        CellDB["appearance"]["highlightSize"] = value
        Cell:Fire("UpdateAppearance", "highlightSize")
    end
    
    -- icon options
    iconOptionsBtn = Cell:CreateButton(unitButtonPane, L["Aura Icon Options"], "accent-hover", {160, 20})
    iconOptionsBtn:SetPoint("TOPLEFT", unitButtonPane, "TOPLEFT", 222, -42)
    iconOptionsBtn:SetScript("OnClick", function()
        if iconOptionsFrame:IsShown() then
            iconOptionsFrame:Hide()
        else
            iconOptionsFrame:Show()
        end
    end)
    
    -- bar alpha
    barAlpha = Cell:CreateSlider(L["Health Bar Alpha"], unitButtonPane, 0, 100, 141, 5, function(value)
        CellDB["appearance"]["barAlpha"] = value/100
        Cell:Fire("UpdateAppearance", "alpha")
    end, nil, true)
    barAlpha:SetPoint("TOPLEFT", iconOptionsBtn, "BOTTOMLEFT", 0, -30)
    
    -- loss alpha
    lossAlpha = Cell:CreateSlider(L["Health Loss Alpha"], unitButtonPane, 0, 100, 141, 5, function(value)
        CellDB["appearance"]["lossAlpha"] = value/100
        Cell:Fire("UpdateAppearance", "alpha")
    end, nil, true)
    lossAlpha:SetPoint("TOPLEFT", barAlpha, "BOTTOMLEFT", 0, -40)
    
    -- bg alpha
    bgAlpha = Cell:CreateSlider(L["Background Alpha"], unitButtonPane, 0, 100, 141, 5, function(value)
        CellDB["appearance"]["bgAlpha"] = value/100
        Cell:Fire("UpdateAppearance", "alpha")
    end, nil, true)
    bgAlpha:SetPoint("TOPLEFT", lossAlpha, "BOTTOMLEFT", 0, -40)
    
    -- out of range alpha
    oorAlpha = Cell:CreateSlider(L["Out of Range Alpha"], unitButtonPane, 0, 100, 141, 5, function(value)
        CellDB["appearance"]["outOfRangeAlpha"] = value/100
        Cell:Fire("UpdateAppearance", "outOfRangeAlpha")
    end, nil, true)
    oorAlpha:SetPoint("TOPLEFT", bgAlpha, "BOTTOMLEFT", 0, -40)
    
    -- heal prediction
    predCB = Cell:CreateCheckButton(unitButtonPane, L["Heal Prediction"], function(checked, self)
        CellDB["appearance"]["healPrediction"][1] = checked
        predCustomCB:SetEnabled(checked)
        if checked then
            predColorPicker:SetEnabled(CellDB["appearance"]["healPrediction"][2])
        else
            predColorPicker:SetEnabled(false)
        end
        Cell:Fire("UpdateAppearance", "shields")
    end)
    predCB:SetPoint("TOPLEFT", oorAlpha, "BOTTOMLEFT", 0, -35)

    -- heal prediction custom color
    predCustomCB = Cell:CreateCheckButton(unitButtonPane, "", function(checked, self)
        CellDB["appearance"]["healPrediction"][2] = checked
        predColorPicker:SetEnabled(checked)
        Cell:Fire("UpdateAppearance", "shields")
    end)
    predCustomCB:SetPoint("TOPLEFT", predCB, "BOTTOMLEFT", 14, -7)

    predColorPicker = Cell:CreateColorPicker(unitButtonPane, L["Custom Color"], true, function(r, g, b, a)
        CellDB["appearance"]["healPrediction"][3][1] = r
        CellDB["appearance"]["healPrediction"][3][2] = g
        CellDB["appearance"]["healPrediction"][3][3] = b
        CellDB["appearance"]["healPrediction"][3][4] = a
        Cell:Fire("UpdateAppearance", "shields")
    end)
    predColorPicker:SetPoint("TOPLEFT", predCustomCB, "TOPRIGHT", 5, 0)

    -- heal prediction use LibHealComm
    useLibCB = Cell:CreateCheckButton(unitButtonPane, _G.USE.." LibHealComm", function(checked, self)
        CellDB["appearance"]["useLibHealComm"] = checked
        F:EnableLibHealComm(checked)
    end)
    useLibCB:SetPoint("TOPLEFT", predCustomCB, "BOTTOMLEFT", 0, -7)
    useLibCB:SetEnabled(Cell.isWrath)
    
    -- heal absorb
    absorbCB = Cell:CreateCheckButton(unitButtonPane, "", function(checked, self)
        CellDB["appearance"]["healAbsorb"][1] = checked
        absorbColorPicker:SetEnabled(checked)
        Cell:Fire("UpdateAppearance", "shields")
    end)
    absorbCB:SetPoint("TOPLEFT", predCB, "BOTTOMLEFT", 0, -49)
    absorbCB:SetEnabled(Cell.isRetail)

    absorbColorPicker = Cell:CreateColorPicker(unitButtonPane, L["Heal Absorb"], true, function(r, g, b, a)
        CellDB["appearance"]["healAbsorb"][2][1] = r
        CellDB["appearance"]["healAbsorb"][2][2] = g
        CellDB["appearance"]["healAbsorb"][2][3] = b
        CellDB["appearance"]["healAbsorb"][2][4] = a
        Cell:Fire("UpdateAppearance", "shields")
    end)
    absorbColorPicker:SetPoint("TOPLEFT", absorbCB, "TOPRIGHT", 5, 0)
    
    -- shield
    shieldCB = Cell:CreateCheckButton(unitButtonPane, "", function(checked, self)
        CellDB["appearance"]["shield"][1] = checked
        shieldColorPicker:SetEnabled(checked)
        Cell:Fire("UpdateAppearance", "shields")
    end)
    shieldCB:SetPoint("TOPLEFT", absorbCB, "BOTTOMLEFT", 0, -7)

    shieldColorPicker = Cell:CreateColorPicker(unitButtonPane, L["Shield Texture"], true, function(r, g, b, a)
        CellDB["appearance"]["shield"][2][1] = r
        CellDB["appearance"]["shield"][2][2] = g
        CellDB["appearance"]["shield"][2][3] = b
        CellDB["appearance"]["shield"][2][4] = a
        Cell:Fire("UpdateAppearance", "shields")
    end)
    shieldColorPicker:SetPoint("TOPLEFT", shieldCB, "TOPRIGHT", 5, 0)
    
    -- overshield
    oversCB = Cell:CreateCheckButton(unitButtonPane, L["Overshield Texture"], function(checked, self)
        CellDB["appearance"]["overshield"] = checked
        Cell:Fire("UpdateAppearance", "shields")
    end)
    oversCB:SetPoint("TOPLEFT", shieldCB, "BOTTOMLEFT", 0, -7)
    
    -- reset
    resetBtn = Cell:CreateButton(unitButtonPane, L["Reset All"], "accent", {77, 17}, nil, nil, nil, nil, nil, L["Reset All"], L["[Ctrl+LeftClick] to reset these settings"])
    resetBtn:SetPoint("TOPRIGHT")
    resetBtn:SetScript("OnClick", function()
        if IsControlKeyDown() then
            Cell:ResetButtonStyle()
    
            -- load data
            textureDropdown:SetSelected("Cell ".._G.DEFAULT, "Interface\\AddOns\\Cell\\Media\\statusbar.tga")
            LoadData()
    
            Cell:Fire("UpdateAppearance", "reset")
        end
    end)
    Cell:RegisterForCloseDropdown(resetBtn) -- close dropdown
end

-------------------------------------------------
-- functions
-------------------------------------------------
local init
LoadData = function()
    scaleSlider:SetValue(CellDB["appearance"]["scale"])
    accentColorDropdown:SetSelectedValue(CellDB["appearance"]["accentColor"][1])
    accentColorPicker:SetColor(CellDB["appearance"]["accentColor"][2])
    accentColorPicker:SetEnabled(CellDB["appearance"]["accentColor"][1] == "custom")
    optionsFontSizeOffset:SetValue(CellDB["appearance"]["optionsFontSizeOffset"])
    useGameFontCB:SetChecked(CellDB["appearance"]["useGameFont"])
    
    if not init then CheckTextures() end
    barColorDropdown:SetSelectedValue(CellDB["appearance"]["barColor"][1])
    barColorPicker:SetColor(CellDB["appearance"]["barColor"][2])
    barColorPicker:SetEnabled(CellDB["appearance"]["barColor"][1] == "custom")

    lossColorDropdown:SetSelectedValue(CellDB["appearance"]["lossColor"][1])
    lossColorPicker:SetColor(CellDB["appearance"]["lossColor"][2])
    lossColorPicker:SetEnabled(CellDB["appearance"]["lossColor"][1] == "custom")

    deathColorCB:SetChecked(CellDB["appearance"]["deathColor"][1])
    deathColorPicker:SetColor(CellDB["appearance"]["deathColor"][2])
    deathColorPicker:SetEnabled(CellDB["appearance"]["deathColor"][1])

    powerColorDropdown:SetSelectedValue(CellDB["appearance"]["powerColor"][1])
    powerColorPicker:SetColor(CellDB["appearance"]["powerColor"][2])
    powerColorPicker:SetEnabled(CellDB["appearance"]["powerColor"][1] == "custom")

    barAnimationDropdown:SetSelected(L[CellDB["appearance"]["barAnimation"]])

    targetColorPicker:SetColor(CellDB["appearance"]["targetColor"])
    mouseoverColorPicker:SetColor(CellDB["appearance"]["mouseoverColor"])
    highlightSize:SetValue(CellDB["appearance"]["highlightSize"])
    oorAlpha:SetValue(CellDB["appearance"]["outOfRangeAlpha"]*100)
    barAlpha:SetValue(CellDB["appearance"]["barAlpha"]*100)
    lossAlpha:SetValue(CellDB["appearance"]["lossAlpha"]*100)
    bgAlpha:SetValue(CellDB["appearance"]["bgAlpha"]*100)

    predCB:SetChecked(CellDB["appearance"]["healPrediction"][1])
    useLibCB:SetChecked(CellDB["appearance"]["useLibHealComm"])
    absorbCB:SetChecked(CellDB["appearance"]["healAbsorb"][1])
    shieldCB:SetChecked(CellDB["appearance"]["shield"][1])
    oversCB:SetChecked(CellDB["appearance"]["overshield"])

    predCustomCB:SetChecked(CellDB["appearance"]["healPrediction"][2])
    predCustomCB:SetEnabled(CellDB["appearance"]["healPrediction"][1])
    predColorPicker:SetEnabled(CellDB["appearance"]["healPrediction"][1] and CellDB["appearance"]["healPrediction"][2])
    predColorPicker:SetColor(unpack(CellDB["appearance"]["healPrediction"][3]))
    absorbColorPicker:SetEnabled(CellDB["appearance"]["healAbsorb"][1])
    absorbColorPicker:SetColor(unpack(CellDB["appearance"]["healAbsorb"][2]))
    shieldColorPicker:SetEnabled(CellDB["appearance"]["shield"][1])
    shieldColorPicker:SetColor(unpack(CellDB["appearance"]["shield"][2]))

    -- icon options
    iconAnimationDropdown:SetSelectedValue(CellDB["appearance"]["auraIconOptions"]["animation"])
    durationRoundUpCB:SetChecked(CellDB["appearance"]["auraIconOptions"]["durationRoundUp"])
    Cell:SetEnabled(not CellDB["appearance"]["auraIconOptions"]["durationRoundUp"], durationDecimalText1, durationDecimalText2, durationDecimalDropdown)
    durationDecimalDropdown:SetSelectedValue(CellDB["appearance"]["auraIconOptions"]["durationDecimal"])
    durationColorCB:SetChecked(CellDB["appearance"]["auraIconOptions"]["durationColorEnabled"])
    Cell:SetEnabled(CellDB["appearance"]["auraIconOptions"]["durationColorEnabled"], durationNormalCP, durationPercentCP, durationPercentDD, durationSecondCP, durationSecondEB, durationSecondText)
    durationNormalCP:SetColor(CellDB["appearance"]["auraIconOptions"]["durationColors"][1])
    durationPercentCP:SetColor(CellDB["appearance"]["auraIconOptions"]["durationColors"][2][1], CellDB["appearance"]["auraIconOptions"]["durationColors"][2][2], CellDB["appearance"]["auraIconOptions"]["durationColors"][2][3])
    durationPercentDD:SetSelectedValue(CellDB["appearance"]["auraIconOptions"]["durationColors"][2][4])
    durationSecondCP:SetColor(CellDB["appearance"]["auraIconOptions"]["durationColors"][3][1], CellDB["appearance"]["auraIconOptions"]["durationColors"][3][2], CellDB["appearance"]["auraIconOptions"]["durationColors"][3][3])
    durationSecondEB:SetText(CellDB["appearance"]["auraIconOptions"]["durationColors"][3][4])
end

local function ShowTab(tab)
    if tab == "appearance" then
        if not init then
            CreatePreviewIcons()
            CreatePreviewButtons()
            CreateCellPane()
            CreateUnitButtonStylePane()
            CreateIconOptionsFrame()
            F:ApplyCombatFunctionToWidget(scaleSlider)
        end

        appearanceTab:Show()
        
        if init then return end

        UpdatePreviewButton()
        LoadData()
        init = true
    else
        appearanceTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "AppearanceTab_ShowTab", ShowTab)

-------------------------------------------------
-- update preivew
-------------------------------------------------
local function UpdateLayout()
    if init and previewButton.loaded then
        UpdatePreviewButton()
    end
end
Cell:RegisterCallback("UpdateLayout", "AppearanceTab_UpdateLayout", UpdateLayout)

--[[
local function UpdateIndicators(...)
    if init then
        UpdatePreviewIcons(...)
    end
end
Cell:RegisterCallback("UpdateIndicators", "AppearanceTab_UpdateIndicators", UpdateIndicators)
]]

-------------------------------------------------
-- update appearance
-------------------------------------------------
local function UpdateAppearance(which)
    F:Debug("|cff7f7fffUpdateAppearance:|r "..(which or "all"))
    
    if not which or which == "texture" or which == "color" or which == "deathColor" or which == "alpha" or which == "outOfRangeAlpha" or which == "shields" or which == "animation" or which == "highlightColor" or which == "highlightSize" or which == "reset" then
        local tex
        if not which or which == "texture" or which == "reset" then tex = F:GetBarTexture() end

        if not which or which == "color" or which == "reset" then
            if strfind(CellDB["appearance"]["barColor"][1], "gradient") or strfind(CellDB["appearance"]["lossColor"][1], "gradient") then
                Cell.vars.useGradientColor = true
            else
                Cell.vars.useGradientColor = nil
            end
        end

        if not which or which == "deathColor" or which == "reset" then
            Cell.vars.useDeathColor = CellDB["appearance"]["deathColor"][1] and true or nil
        end

        F:IterateAllUnitButtons(function(b)
            -- texture
            if not which or which == "texture" or which == "reset" then
                b.func.SetTexture(tex)
            end
            -- color
            if not which or which == "color" or which == "deathColor" or which == "alpha" or which == "shields" or which == "reset" then
                b.func.UpdateColor()
            end
            -- outOfRangeAlpha
            if which == "outOfRangeAlpha" or which == "reset" then
                b.state.wasInRange = nil
            end
            -- shields
            if not which or which == "shields" or which == "reset" then
                b.func.UpdateShields()
            end
            -- animation
            if not which or which == "animation" or which == "reset" then
                b.func.UpdateAnimation()
            end
            -- highlightColor
            if not which or which == "highlightColor" or which == "reset" then
                b.func.UpdateHighlightColor()
            end
            -- highlightColor
            if not which or which == "highlightSize" or which == "reset" then
                b.func.UpdateHighlightSize()
            end
        end)
    end

    -- icon options
    if not which or which == "icon" or which == "reset" then
        -- animation
        Cell.vars.iconAnimation = CellDB["appearance"]["auraIconOptions"]["animation"]

        -- round up
        Cell.vars.iconDurationRoundUp = CellDB["appearance"]["auraIconOptions"]["durationRoundUp"]

        -- decimal
        Cell.vars.iconDurationDecimal = CellDB["appearance"]["auraIconOptions"]["durationDecimal"]

        -- color
        if CellDB["appearance"]["auraIconOptions"]["durationColorEnabled"] then
            Cell.vars.iconDurationColors = CellDB["appearance"]["auraIconOptions"]["durationColors"]
        else
            Cell.vars.iconDurationColors = nil
        end
    end

    -- scale
    if not which or which == "scale" then
        P:SetRelativeScale(CellDB["appearance"]["scale"])
        P:SetEffectiveScale(Cell.frames.mainFrame)
        if Cell.frames.changelogsFrame then P:SetEffectiveScale(Cell.frames.changelogsFrame) end
        if Cell.frames.codeSnippetsFrame then P:SetEffectiveScale(Cell.frames.codeSnippetsFrame) end
        P:SetEffectiveScale(CellTooltip)
        P:SetEffectiveScale(CellSpellTooltip)
        -- P:SetEffectiveScale(CellScanningTooltip)
        CellTooltip:UpdatePixelPerfect()
        CellSpellTooltip:UpdatePixelPerfect()
        -- CellScanningTooltip:UpdatePixelPerfect()
        Cell.menu:UpdatePixelPerfect()
    end

    -- preview
    if which ~= "highlightColor" and which ~= "highlightSize" and init and previewButton:IsVisible() then
        UpdatePreviewButton()
    end
end
Cell:RegisterCallback("UpdateAppearance", "UpdateAppearance", UpdateAppearance)
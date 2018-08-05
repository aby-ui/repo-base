--[[ 
  @file       comergyopt.lua
  @brief      config window for Comergy Redux

  @author     robfaie
  @date       2015-01-01T07:58:42Z
]]--
local sliders = {}
local checkButtons = {}
local colorButtons = {}
local editBoxes = {}
local clickables = {}

local i, j

local playerClass
-- class constants GetClassInfo()
local WARRIOR       = 1
local PALADIN       = 2
local HUNTER        = 3
local ROGUE         = 4
local PRIEST        = 5
local DEATHKNIGHT   = 6
local SHAMAN        = 7
local MAGE          = 8
local WARLOCK       = 9
local MONK          = 10
local DRUID         = 11
local DEMONHUNTER   = 12

local comboText
local isFiveTabs = false

local SliderOnValueChanged, CheckButtonOnClick
local CreateSlider, CreateCheckButton, CreateEditBox, QuitColor, QuitAlpha, CreateColorButton
local DisableWidget, EnableWidget, SetCheckBox, SetClickables, ChooseTexture, ChooseFont
local Check, Slide, Color, Text, ClearEditBoxFocus, StringToColor

function StringToColor(str)
    local color = { }
    local number = tonumber(str, 16)
    if (not number) then
        return nil
    else
        color.r = floor(number / 65536) % 256 / 256
        color.g = floor(number / 256) % 256 / 256
        color.b = number % 256 / 256
    end
    return color
end

function SliderOnValueChanged(self, value)
    local _, _, name = string.find(self:GetName(),"ComergyOptSlider(.+)")
    Comergy_Settings[name] = self:GetValue()
    if (self.editBox) then
        self.editBox:SetText(value)
    end
    ComergyOnConfigChange()
end

function CheckButtonOnClick(button)
    local _, _, name = string.find(button:GetName(),"ComergyOptCheckButton(.+)")
    
    Comergy_Settings[name] = (button:GetChecked() and true or false)
    PlaySound163(button:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
    SetCheckBox()
    ComergyOnConfigChange()

    ComergyOptEditBoxEnergyThreshold1:ClearFocus()
end

function CreateSlider(type, name, min, max, parent, x, y, width, valueStep, title, editBox, minText, maxText)
    local extension = ""
    if (type == "energy") then
        if (playerClass == HUNTER) then
            extension = "_FOCUS"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNIC"
        elseif (playerClass == WARRIOR) then
            extension = "_RAGE"
        elseif (playerClass == PRIEST) then
            extension = "_INSANITY"
        else
            extension = "_ENERGY"
        end
    elseif (type == "combo") then
        if (playerClass == MONK) then
            extension = "_CHI"
        elseif (playerClass == PALADIN) then
            extension = "_HOLY_POWER"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNE"
        else
            extension = "_COMBO"
        end
    elseif (type == "mana") then
        extension = "_MANA"
    end
    local slider = CreateFrame("Slider", "ComergyOptSlider"..name, parent, "OptionsSliderTemplate")
    slider:SetMinMaxValues(min, max)
    slider:SetWidth(width)
    slider:SetHeight(16)
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetValueStep(valueStep)
    if (getglobal("COMERGY_SLIDERINFO"..extension)[name]) then
        getglobal(slider:GetName().."Text"):SetText(getglobal("COMERGY_SLIDERINFO"..extension)[name])
    end
    if (minText) then
        getglobal(slider:GetName().."Low"):SetText(minText)
        getglobal(slider:GetName().."High"):SetText(maxText)
    else
        getglobal(slider:GetName().."Low"):SetText(min)
        getglobal(slider:GetName().."High"):SetText(max)
    end

    if (editBox) then
        slider.editBox = CreateFrame("EditBox", slider:GetName().."EditBox", slider, "ComergyOptEditBoxTemplate")
        slider.editBox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
        slider.editBox:SetNumeric(true)
        slider.editBox:SetMaxLetters(4)
        slider.editBox:SetWidth(40)

        tinsert(editBoxes, slider.editBox)
    end
    slider:SetScript("OnValueChanged", function(self, value)
        SliderOnValueChanged(self, value)
    end)

    tinsert(sliders, slider)
    tinsert(clickables, slider)
end

function CreateCheckButton(name, parent, x, y, type)
    local checkButton
    local extension = ""
    if (type == "energy") then
        if (playerClass == HUNTER) then
            extension = "_FOCUS"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNIC"
        elseif (playerClass == WARRIOR) then
            extension = "_RAGE"
        elseif (playerClass == PRIEST) then
            extension = "_INSANITY"
        else
            extension = "_ENERGY"
        end
    elseif (type == "combo") then
        if (playerClass == MONK) then
            extension = "_CHI"
        elseif (playerClass == PALADIN) then
            extension = "_HOLY_POWER"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNE"
        else
            extension = "_COMBO"
        end
    elseif (type == "mana") then
        extension = "_MANA"
    end
    if (getglobal("COMERGY_CHECKOPTINFO"..extension)[name]) then
        checkButton = CreateFrame("CheckButton", "ComergyOptCheckButton"..name, parent, "OptionsCheckButtonTemplate")
        getglobal(checkButton:GetName().."Text"):SetTextColor(1, 1, 1)
        getglobal(checkButton:GetName().."Text"):SetText(getglobal("COMERGY_CHECKOPTINFO"..extension)[name]) --
    else
        checkButton = CreateFrame("CheckButton", "ComergyOptCheckButton"..name, parent, "UICheckButtonTemplate")
        checkButton:SetWidth(24)
        checkButton:SetHeight(24)
    end
    checkButton:SetPoint("TOPLEFT", x, y)
    checkButton:SetScript("OnClick", function(self)
        CheckButtonOnClick(self)
    end)

    tinsert(checkButtons, checkButton)
    tinsert(clickables, checkButton)
end

function CreateEditBox(name, parent, x, y)
    local editBox = CreateFrame("EditBox", "ComergyOptEditBox"..name, parent, "ComergyOptEditBoxTemplate")
    editBox:SetPoint("TOPLEFT", x, y)

    tinsert(editBoxes, editBox)
    tinsert(clickables, editBox)
end

function QuitColor(issave, name)
    local r, g, b, a
    if issave then
        r, g, b = ColorPickerFrame:GetColorRGB()
        a = OpacitySliderFrame:GetValue()
    else
        local c = ColorPickerFrame.previousValues
        r, g, b, a = c[1], c[2], c[3], c[4]
    end
    Comergy_Settings[name][1] = r
    Comergy_Settings[name][2] = g
    Comergy_Settings[name][3] = b
    Comergy_Settings[name][4] = a 

    ColorPickerFrame.button:GetNormalTexture():SetVertexColor(r, g, b)
    ComergyOnConfigChange()

    Text()
end

function QuitAlpha(name)
    Comergy_Settings[name][4] = OpacitySliderFrame:GetValue()
    ComergyOnConfigChange()
end

function CreateColorButton(name, parent, x, y, type, editBox)
    local extension = ""
    if (type == "energy") then
        if (playerClass == HUNTER) then
            extension = "_FOCUS"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNIC"
        elseif (playerClass == WARRIOR) then
            extension = "_RAGE"
        elseif (playerClass == PRIEST) then
            extension = "_INSANITY"
        else
            extension = "_ENERGY"
        end
    elseif (type == "combo") then
        if (playerClass == MONK) then
            extension = "_CHI"
        elseif (playerClass == PALADIN) then
            extension = "_HOLY_POWER"
        elseif (playerClass == DEATHKNIGHT) then
            extension = "_RUNE"
        else
            extension = "_COMBO"
        end
    elseif (type == "mana") then
        extension = "_MANA"
    end
    local colorButton = CreateFrame("Button", "ComergyOptColor"..name, parent)
    colorButton:SetNormalTexture("Interface/ChatFrame/ChatFrameColorSwatch")

    local bg = colorButton:CreateTexture(nil, "BACKGROUND")
    bg:SetWidth(14)
    bg:SetHeight(14)
    bg:SetTexture(0, 0, 0)
    bg:SetPoint("CENTER")

    if (editBox) then
        colorButton.editBox = CreateFrame("EditBox", colorButton:GetName().."EditBox", colorButton, "ComergyOptEditBoxTemplate")
        colorButton.editBox:SetPoint("LEFT", colorButton, "RIGHT", 10, 0)
        colorButton.editBox:SetMaxLetters(6)
        colorButton.editBox:SetWidth(60)
        colorButton.editBox:SetNumeric(false)

        tinsert(editBoxes, colorButton.editBox)
    end
    
    local label = colorButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    label:SetPoint("RIGHT", colorButton, "LEFT")
    if (getglobal("COMERGY_COLORPICKERINFO"..extension)[name]) then
        label:SetText(getglobal("COMERGY_COLORPICKERINFO"..extension)[name])
    end
    colorButton:SetWidth(24)
    colorButton:SetHeight(24)
    
    colorButton:RegisterForClicks("LeftButtonUp")
    colorButton:SetScript("OnClick", function(self)
        if ColorPickerFrame:IsShown() then
            ColorPickerFrame:Hide()
        else
            local r, g, b, a = Comergy_Settings[name][1], Comergy_Settings[name][2], Comergy_Settings[name][3], Comergy_Settings[name][4]
            ColorPickerFrame.button = self
            ColorPickerFrame.previousValues = {r, g, b, a}
            
            ColorPickerFrame.func = function() QuitColor(true, name) end
            ColorPickerFrame.cancelFunc = function() QuitColor(false, name) end

            ColorPickerFrame.hasOpacity = true
            if (a) then
                ColorPickerFrame.opacity = a
            else
                ColorPickerFrame.opacity = 1
            end
            ColorPickerFrame.opacityFunc = function() QuitAlpha(name) end
            
            ColorPickerFrame:SetColorRGB(r, g, b)

            ShowUIPanel(ColorPickerFrame)
        end
    end)

    colorButton:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    colorButton:Show()

    tinsert(colorButtons, colorButton)
    tinsert(clickables, colorButton)
end

function DisableWidget(widget)
    widget:Disable()
    widget:SetAlpha(0.5)
end

function EnableWidget(widget)
    widget:Enable()
    widget:SetAlpha(1)
end

function SetCheckBox()
    if (ComergyOptCheckButtonShowOnlyInCombat:GetChecked()) then
        EnableWidget(ComergyOptCheckButtonShowWhenEnergyNotFull)
        EnableWidget(ComergyOptCheckButtonShowInStealth)
    else
        DisableWidget(ComergyOptCheckButtonShowWhenEnergyNotFull)
        DisableWidget(ComergyOptCheckButtonShowInStealth)
    end

    if (ComergyOptCheckButtonManaText:GetChecked()) then
        EnableWidget(ComergyOptCheckButtonManaShortText)
    else
        DisableWidget(ComergyOptCheckButtonManaShortText)
    end

    if (ComergyOptCheckButtonShowPlayerHealthBar:GetChecked()) then
        EnableWidget(ComergyOptSliderPlayerHeight)
    else
        DisableWidget(ComergyOptSliderPlayerHeight)
    end

    if (ComergyOptCheckButtonShowTargetHealthBar:GetChecked()) then
        EnableWidget(ComergyOptSliderTargetHeight)
    else
        DisableWidget(ComergyOptSliderTargetHeight)
    end

    if (ComergyOptCheckButtonTextCenter:GetChecked()) then
        EnableWidget(ComergyOptCheckButtonTextCenterUp)
    else
        DisableWidget(ComergyOptCheckButtonTextCenterUp)
    end

    if (ComergyOptCheckButtonAnticipation:GetChecked()) then
        EnableWidget(ComergyOptCheckButtonAnticipationCombo)
    else
        DisableWidget(ComergyOptCheckButtonAnticipationCombo)
    end

    for i = 1, 4 do
        if (getglobal("ComergyOptCheckButtonSplitEnergy"..i):GetChecked()) then
            local color = getglobal("ComergyOptColorEnergyColor"..i)
            EnableWidget(color)
        else
            local color = getglobal("ComergyOptColorEnergyColor"..i)
            DisableWidget(color)
        end
    end

    for i = 1, 4 do
        if (getglobal("ComergyOptCheckButtonSplitMana"..i):GetChecked()) then
            local color = getglobal("ComergyOptColorManaColor"..i)
            EnableWidget(color)
        else
            local color = getglobal("ComergyOptColorManaColor"..i)
            DisableWidget(color)
        end
    end

    if (ComergyOptCheckButtonEnergyFlash:GetChecked()) then
        EnableWidget(ComergyOptColorEnergyFlashColor)
    else
        DisableWidget(ComergyOptColorEnergyFlashColor)
    end

    if (ComergyOptCheckButtonGradientEnergyColor:GetChecked()) then
        EnableWidget(ComergyOptColorEnergyColor0)
    else
        DisableWidget(ComergyOptColorEnergyColor0)
    end
end

function SetClickables()
    for i = 1, #(clickables) do
        clickables[i]:SetScript("OnMouseDown", function()
            ClearEditBoxFocus()
        end)
    end
end

function ChooseTexture(i)
    Comergy_Settings.BarTexture = i
    ComergyTextureDropdownText:SetText(ComergyBarTextures[i][1])
    ComergyOnConfigChange()
end

function ChooseFont(i)
    Comergy_Settings.TextFont = i
    ComergyTextDropdownText:SetText(ComergyTextFonts[i][1])
    ComergyOnConfigChange()
end

function Check()
    for i = 1, #(checkButtons) do
        local _, _, name = string.find(checkButtons[i]:GetName(), "ComergyOptCheckButton(.+)")
        checkButtons[i]:SetChecked(Comergy_Settings[name])
    end
    SetCheckBox()
end

function Slide()
    for i = 1, #(sliders) do
        local _, _, name = string.find(sliders[i]:GetName(), "ComergyOptSlider(.+)")
        sliders[i]:SetValue(Comergy_Settings[name])
    end
end

function Color()
    for i = 1, #(colorButtons) do
        local _, _, name = string.find(colorButtons[i]:GetName(), "ComergyOptColor(.+)")
        local color = Comergy_Settings[name]
        colorButtons[i]:GetNormalTexture():SetVertexColor(color[1], color[2], color[3])
    end
end

function Text()
    for i = 1, #(editBoxes) do
        local _, _, name = string.find(editBoxes[i]:GetName(), "ComergyOptEditBox(.+)")
        if (name) then
            editBoxes[i]:SetText(Comergy_Settings[name])
        else
            _, _, name = string.find(editBoxes[i]:GetName(), "ComergyOptSlider(.+)")
            if (name) then
                editBoxes[i]:SetText(editBoxes[i]:GetParent():GetValue())
            else
                _, _, name = string.find(editBoxes[i]:GetName(), "ComergyOptColor(.+)")
                if (name) then
                    local color = { }
                    color[1], color[2], color[3] = editBoxes[i]:GetParent():GetNormalTexture():GetVertexColor()
                    for j = 1, 3 do
                        color[j] = floor(color[j] * 256 + .1)
                        if (color[j] > 255) then
                            color[j] = 255
                        end
                    end
                    editBoxes[i]:SetText(string.format("%.2X%.2X%.2X", color[1], color[2], color[3]))
                end
            end
        end
    end
end

function ComergyOptReadSettings()
    Check()
    Slide()
    Color()
    Text()

    ComergyTextureDropdownText:SetText(ComergyBarTextures[Comergy_Settings.BarTexture][1])
    ComergyTextDropdownText:SetText(ComergyTextFonts[Comergy_Settings.TextFont][1])

    local talent, name = ComergyGetTalent()
    if (talent == 1) then
        talent = COMERGY_TALENT_PRIMARY
    else
        talent = COMERGY_TALENT_SECONDARY
    end
    ComergyOptTitle:SetText("Comergy "..Comergy_Settings.Version.." - "..talent..COMERGY_TALENT.." ("..name..")")
end

function ComergyOptOnLoad()
    -- Options Frame needs to be UISpecialFrame

    playerClass = select(3, UnitClass("player"))

    SetOrHookScript(ComergyOptFrame, "OnShow", function()
        if playerClass == DEMONHUNTER then
            ComergyOptTab3:SetText(GetSpecialization()==1 and FURY or PAIN)
        end
    end)

    tinsert(UISpecialFrames,"ComergyOptFrame")

    CreateSlider("", "Y", -(floor((UIParent:GetHeight() - ComergyMainFrame:GetHeight()) / 2)), floor((UIParent:GetHeight() - ComergyMainFrame:GetHeight()) / 2), ComergyOptGeneralFrame, 20, -120, 200, 1, COMERGY_VERTICAL_POSITION, true)
    CreateSlider("", "X", -(floor((UIParent:GetWidth() - ComergyMainFrame:GetWidth()) / 2)), floor((UIParent:GetWidth() - ComergyMainFrame:GetWidth()) / 2), ComergyOptGeneralFrame, 20, -155, 200, 1, COMERGY_HORIZONTAL_POSITION, true)
    getglobal("ComergyOptSliderY").editBox:SetNumeric(false)
    getglobal("ComergyOptSliderX").editBox:SetNumeric(false)

    CreateSlider("", "Width",              20, floor(UIParent:GetWidth()), ComergyOptGeneralFrame, 20, -185, 200, 1, COMERGY_WIDTH, true)
    CreateSlider("", "Spacing",            0,  15,    ComergyOptGeneralFrame, 70, -260, 110, 1, COMERGY_SPACING, true)
    CreateSlider("", "DurationScale",      0,  2,     ComergyOptGeneralFrame, 155, -300, 110, 0.2, COMERGY_DURATION_SCALE, false, COMERGY_LOW, COMERGY_HIGH)
    CreateSlider("", "FrameStrata",        0,  7,     ComergyOptGeneralFrame, 20, -300, 110, 1, COMERGY_FRAME_STRATA, false, COMERGY_LOW, COMERGY_HIGH)

    CreateSlider("", "PlayerHeight",       1, 20,     ComergyOptBarFrame,     85, -20,  135, 1, COMERGY_PLAYER_HEALTH, true)
    CreateSlider("", "TargetHeight",       1, 20,     ComergyOptBarFrame,     85, -55,  135, 1, COMERGY_TARGET_HEALTH, true)
    CreateSlider("", "TextHeight",         6, 26,     ComergyOptBarFrame,     20, -210, 110, 1, COMERGY_FONT_SIZE,     true)

    CreateSlider("energy", "EnergyHeight", 0, 50,     ComergyOptEnergyFrame,  20, -220, 110, 1, COMERGY_ENERGY_HEIGHT, false)
    CreateSlider("mana",   "ManaHeight",   0, 50,     ComergyOptManaFrame,    20, -220, 110, 1, COMERGY_MANA_HEIGHT,   false)

    CreateSlider("combo", "ChiHeight",     0,    50,  ComergyOptComboFrame,   25,  -260, 110, 1,    COMERGY_COMBO_HEIGHT,   false)
    CreateSlider("combo", "ChiBGAlpha",    0,    0.3, ComergyOptComboFrame,   160, -260, 110, 0.02, COMERGY_COMBO_BG_ALPHA, false)
    CreateSlider("combo", "ChiDiff",       -0.3, 0.3, ComergyOptComboFrame,   160, -295, 110, 0.02, COMERGY_COMBO_FANCY,    false, COMERGY_LEFT, COMERGY_RIGHT)

    -- try and fix this -- what's broken about it?
    CreateSlider("combo", "RuneHeight",    0, 50,     ComergyOptRuneFrame,    25,  -166, 110, 1,    COMERGY_COMBO_HEIGHT,   false)
    --CreateSlider("combo", "RuneBGAlpha",   0, 1,      ComergyOptRuneFrame,    160, -166, 110, 0.02, COMERGY_COMBO_BG_ALPHA, false)


    CreateCheckButton("Enabled", ComergyOptGeneralFrame, 13, -10)
    CreateCheckButton("ShowOnlyInCombat", ComergyOptGeneralFrame, 13, -30)
    CreateCheckButton("ShowWhenEnergyNotFull", ComergyOptGeneralFrame, 23, -50)
    CreateCheckButton("Locked", ComergyOptGeneralFrame, 13, -80)
    CreateCheckButton("CritSound", ComergyOptGeneralFrame, 163, -80)
    
    CreateCheckButton("ShowInStealth", ComergyOptRogueFrame, 13, -10)
    CreateCheckButton("StealthSound", ComergyOptRogueFrame, 13, -35)
    CreateCheckButton("EnergyFlash", ComergyOptRogueFrame, 25, -80)
    CreateCheckButton("Anticipation", ComergyOptRogueFrame, 25, -130)
    CreateCheckButton("AnticipationCombo", ComergyOptRogueFrame, 35, -150)
    getglobal("ComergyOptCheckButtonAnticipationCombo"):Hide()

    CreateCheckButton("ShowPlayerHealthBar", ComergyOptBarFrame, 13, -15)
    CreateCheckButton("ShowTargetHealthBar", ComergyOptBarFrame, 13, -50)
    CreateCheckButton("FlipBars", ComergyOptBarFrame, 13, -90)
    CreateCheckButton("FlipOrientation", ComergyOptBarFrame, 13, -110)
    CreateCheckButton("VerticalBars", ComergyOptBarFrame, 13, -130)
    CreateCheckButton("TextCenter", ComergyOptBarFrame, 13, -235)
    CreateCheckButton("TextCenterUp", ComergyOptBarFrame, 23, -255)

    CreateCheckButton("SoundEnergy1", ComergyOptEnergyFrame, 80, -60)
    CreateCheckButton("SoundEnergy2", ComergyOptEnergyFrame, 80, -90)
    CreateCheckButton("SoundEnergy3", ComergyOptEnergyFrame, 80, -120)
    CreateCheckButton("SoundEnergy4", ComergyOptEnergyFrame, 80, -150)
    CreateCheckButton("SoundEnergy5", ComergyOptEnergyFrame, 80, -180)
    CreateCheckButton("SplitEnergy1", ComergyOptEnergyFrame, 130, -60)
    CreateCheckButton("SplitEnergy2", ComergyOptEnergyFrame, 130, -90)
    CreateCheckButton("SplitEnergy3", ComergyOptEnergyFrame, 130, -120)
    CreateCheckButton("SplitEnergy4", ComergyOptEnergyFrame, 130, -150)

    CreateCheckButton("EnergyBGFlash", ComergyOptEnergyFrame, 20, -245, "energy")
    CreateCheckButton("EnergyText", ComergyOptEnergyFrame, 20, -265, "energy")
    CreateCheckButton("UnifiedEnergyColor", ComergyOptEnergyFrame, 150, -265, "energy")
    CreateCheckButton("GradientEnergyColor", ComergyOptEnergyFrame, 150, -285, "energy")

    CreateCheckButton("SoundMana1", ComergyOptManaFrame, 80, -60)
    CreateCheckButton("SoundMana2", ComergyOptManaFrame, 80, -90)
    CreateCheckButton("SoundMana3", ComergyOptManaFrame, 80, -120)
    CreateCheckButton("SoundMana4", ComergyOptManaFrame, 80, -150)
    CreateCheckButton("SoundMana5", ComergyOptManaFrame, 80, -180)
    CreateCheckButton("SplitMana1", ComergyOptManaFrame, 130, -60)
    CreateCheckButton("SplitMana2", ComergyOptManaFrame, 130, -90)
    CreateCheckButton("SplitMana3", ComergyOptManaFrame, 130, -120)
    CreateCheckButton("SplitMana4", ComergyOptManaFrame, 130, -150)

    CreateCheckButton("ManaBGFlash", ComergyOptManaFrame, 20, -245, "mana")
    CreateCheckButton("ManaText", ComergyOptManaFrame, 20, -265, "mana")
    CreateCheckButton("ManaShortText", ComergyOptManaFrame, 30, -285, "mana")
    CreateCheckButton("UnifiedManaColor", ComergyOptManaFrame, 150, -265, "mana")
    CreateCheckButton("GradientManaColor", ComergyOptManaFrame, 150, -285, "mana")

    CreateCheckButton("SoundChi1", ComergyOptComboFrame, 100, -60)
    CreateCheckButton("SoundChi2", ComergyOptComboFrame, 100, -90)
    CreateCheckButton("SoundChi3", ComergyOptComboFrame, 100, -120)
    CreateCheckButton("SoundChi4", ComergyOptComboFrame, 100, -150)
    CreateCheckButton("SoundChi5", ComergyOptComboFrame, 100, -180)

    CreateCheckButton("ChiText", ComergyOptComboFrame, 20, -295, "combo")
    CreateCheckButton("UnifiedChiColor", ComergyOptComboFrame, 20, -315, "combo")
    CreateCheckButton("ChiFlash", ComergyOptComboFrame, 20, -335, "combo")

    --CreateCheckButton("SoundRune1", ComergyOptRuneFrame, 120, -30)
    --CreateCheckButton("SoundRune2", ComergyOptRuneFrame, 120, -60)
    --CreateCheckButton("SoundRune3", ComergyOptRuneFrame, 120, -90)
    --CreateCheckButton("SoundRune4", ComergyOptRuneFrame, 120, -120)

    --try and fix this
    CreateCheckButton("RuneText", ComergyOptRuneFrame, 20, -196, "combo")
    CreateCheckButton("RuneFlash", ComergyOptRuneFrame, 130, -196, "combo")

    CreateEditBox("EnergyThreshold1", ComergyOptEnergyFrame, 30, -53)
    CreateEditBox("EnergyThreshold2", ComergyOptEnergyFrame, 30, -83)
    CreateEditBox("EnergyThreshold3", ComergyOptEnergyFrame, 30, -113)
    CreateEditBox("EnergyThreshold4", ComergyOptEnergyFrame, 30, -143)

    CreateEditBox("ManaThreshold1", ComergyOptManaFrame, 20, -53)
    CreateEditBox("ManaThreshold2", ComergyOptManaFrame, 20, -83)
    CreateEditBox("ManaThreshold3", ComergyOptManaFrame, 20, -113)
    CreateEditBox("ManaThreshold4", ComergyOptManaFrame, 20, -143)

    for i = 1, 4 do
        getglobal("ComergyOptEditBoxManaThreshold"..i):SetMaxLetters(6)  --mana pools are so big!
        getglobal("ComergyOptEditBoxManaThreshold"..i):SetWidth(50)
    end

    CreateColorButton("BGColorAlpha", ComergyOptGeneralFrame, 130, -215, "", true)
    CreateColorButton("TextColor", ComergyOptBarFrame, 190, -235, "", true)

    CreateColorButton("EnergyColor0", ComergyOptEnergyFrame, 170, -30, "energy", true)
    CreateColorButton("EnergyColor1", ComergyOptEnergyFrame, 170, -60, "energy", true)
    CreateColorButton("EnergyColor2", ComergyOptEnergyFrame, 170, -90, "energy", true)
    CreateColorButton("EnergyColor3", ComergyOptEnergyFrame, 170, -120, "energy", true)
    CreateColorButton("EnergyColor4", ComergyOptEnergyFrame, 170, -150, "energy", true)
    CreateColorButton("EnergyColor5", ComergyOptEnergyFrame, 170, -180, "energy", true)

    CreateColorButton("EnergyBGColorAlpha", ComergyOptEnergyFrame, 190, -215, "energy", true)
    CreateColorButton("EnergyFlashColor", ComergyOptRogueFrame, 175, -80, "energy", true)
    CreateColorButton("AnticipationColor", ComergyOptRogueFrame, 175, -130, "energy", true)

    CreateColorButton("ManaColor0", ComergyOptManaFrame, 170, -30, "mana", true)
    CreateColorButton("ManaColor1", ComergyOptManaFrame, 170, -60, "mana", true)
    CreateColorButton("ManaColor2", ComergyOptManaFrame, 170, -90, "mana", true)
    CreateColorButton("ManaColor3", ComergyOptManaFrame, 170, -120, "mana", true)
    CreateColorButton("ManaColor4", ComergyOptManaFrame, 170, -150, "mana", true)
    CreateColorButton("ManaColor5", ComergyOptManaFrame, 170, -180, "mana", true)

    CreateColorButton("ManaBGColorAlpha", ComergyOptManaFrame, 190, -215, "mana", true)

    CreateColorButton("ChiColor0", ComergyOptComboFrame, 150, -30, "", true)
    CreateColorButton("ChiColor1", ComergyOptComboFrame, 150, -60, "", true)
    CreateColorButton("ChiColor2", ComergyOptComboFrame, 150, -90, "", true)
    CreateColorButton("ChiColor3", ComergyOptComboFrame, 150, -120, "", true)
    CreateColorButton("ChiColor4", ComergyOptComboFrame, 150, -150, "", true)
    CreateColorButton("ChiColor5", ComergyOptComboFrame, 150, -180, "", true)

    CreateColorButton("RuneColor1", ComergyOptRuneFrame, 170, -30, "", true)
    CreateColorButton("RuneColor2", ComergyOptRuneFrame, 170, -60, "", true)
    --CreateColorButton("RuneColor3", ComergyOptRuneFrame, 170, -90, "", true)
    --CreateColorButton("RuneColor4", ComergyOptRuneFrame, 170, -120, "", true)

    CreateColorButton("RuneBGColorAlpha", ComergyOptRuneFrame, 190, -215, "", true)

    ComergyOptTab1:SetText(COMERGY_GENERAL)
    ComergyOptTab2:SetText(COMERGY_BAR)
    ComergyOptTab1:Show()
    ComergyOptTab2:Show()
    comboText = COMERGY_COMBO

    if (playerClass == DEATHKNIGHT) then
        ComergyOptTab3:SetText(COMERGY_RUNIC_POWER)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_RUNE)
        ComergyOptTab4:Show()
        ComergyOptTab5:Hide()
        comboText = COMERGY_RUNE
    elseif (playerClass == DRUID) then
        ComergyOptTab3:SetText(COMERGY_ENERGY)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_COMBO)
        ComergyOptTab4:Show()
        ComergyOptTab5:SetText(COMERGY_MANA)
        ComergyOptTab5:Show()
        isFiveTabs = true
    elseif (playerClass == HUNTER) then
        ComergyOptTab3:SetText(COMERGY_FOCUS)
        ComergyOptTab3:Show()
        ComergyOptTab4:Hide()
        ComergyOptTab5:Hide()
    elseif (playerClass == MAGE) then
        ComergyOptTab3:SetText(COMERGY_MANA)
        ComergyOptTab3:Show()
        ComergyOptTab4:Hide()
        ComergyOptTab5:Hide()
    elseif (playerClass == MONK) then
        ComergyOptTab3:SetText(COMERGY_ENERGY)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_CHI)
        ComergyOptTab4:Show()
        ComergyOptTab5:SetText(COMERGY_MANA)
        ComergyOptTab5:Show()
        comboText = COMERGY_CHI
        isFiveTabs = true
    elseif (playerClass == PALADIN) then
        ComergyOptTab3:SetText(COMERGY_MANA)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_HOLY_POWER)
        ComergyOptTab4:Show()
        ComergyOptTab5:Hide()
        comboText = COMERGY_HOLY_POWER
    elseif (playerClass == PRIEST) then
        ComergyOptTab3:SetText(COMERGY_MANA)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_INSANITY)
        ComergyOptTab4:Show()
        ComergyOptTab5:Hide()
    elseif (playerClass == ROGUE) then
        ComergyOptTab3:SetText(COMERGY_ENERGY)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_COMBO)
        ComergyOptTab4:Show()
        ComergyOptTab5:SetText(COMERGY_ROGUE)
        ComergyOptTab5:Show()
        isFiveTabs = true
    elseif (playerClass == SHAMAN) then
        ComergyOptTab3:SetText(COMERGY_MANA)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_MAELSTROM)
        ComergyOptTab4:Show()
        ComergyOptTab5:Hide()
    elseif (playerClass == WARLOCK) then
        ComergyOptTab3:SetText(COMERGY_MANA)
        ComergyOptTab3:Show()
        ComergyOptTab4:SetText(COMERGY_SOUL_SHARD)
        ComergyOptTab4:Show()
        ComergyOptTab5:Hide()
        comboText = COMERGY_SOUL_SHARD
        --isFiveTabs = true
    elseif (playerClass == WARRIOR) then
        ComergyOptTab3:SetText(COMERGY_RAGE)
        ComergyOptTab3:Show()
        ComergyOptTab4:Hide()
        ComergyOptTab5:Hide()
    elseif (playerClass == DEMONHUNTER) then
        ComergyOptTab3:SetText(COMERGY_ENERGY)
        ComergyOptTab3:Show()
        ComergyOptTab4:Hide()
        ComergyOptTab5:Hide()
    end

    if (isFiveTabs) then -- for classes with both mana and energy
        ComergyOptTab3:SetWidth(96)
        ComergyOptTab4:SetWidth(96)
        ComergyOptTab5:SetWidth(96)
    end

    ComergyOptComboText0:SetText(comboText .. " 0")
    ComergyOptComboText1:SetText(comboText .. " 1")
    ComergyOptComboText2:SetText(comboText .. " 2")
    ComergyOptComboText3:SetText(comboText .. " 3")
    ComergyOptComboText4:SetText(comboText .. " 4")
    ComergyOptComboText5:SetText(comboText .. " 5")

    ComergyOptRuneText1:SetText(COMERGY_BLOOD .. " " .. COMERGY_RUNE)
    ComergyOptRuneText2:SetText(COMERGY_UNHOLY .. " " .. COMERGY_RUNE)
    ComergyOptRuneText3:SetText(COMERGY_FROST .. " " .. COMERGY_RUNE) ComergyOptRuneText3:Hide()
    ComergyOptRuneText4:SetText(COMERGY_DEATH .. " " .. COMERGY_RUNE) ComergyOptRuneText4:Hide()

    ComergyOptEnergyTextSound:SetText(COMERGY_TEXT_SOUND)
    ComergyOptEnergyTextSplit:SetText(COMERGY_TEXT_SPLIT)
    ComergyOptEnergyTextColor:SetText(COMERGY_TEXT_COLOR)
    ComergyOptRogueTextFlash:SetText(COMERGY_TEXT_FLASH)
    ComergyOptRogueTextAnticipation:SetText(COMERGY_TEXT_ANTICIPATION)
    ComergyOptRogueTextAnticipation2:SetText("More Anticipation settings coming soon")
    ComergyOptManaTextSound:SetText(COMERGY_TEXT_SOUND)
    ComergyOptManaTextSplit:SetText(COMERGY_TEXT_SPLIT)
    ComergyOptManaTextColor:SetText(COMERGY_TEXT_COLOR)
    ComergyOptComboTextSound:SetText(COMERGY_TEXT_SOUND)
    ComergyOptComboTextColor:SetText(COMERGY_TEXT_COLOR)
    ComergyOptRuneTextSound:SetText(COMERGY_TEXT_SOUND) ComergyOptRuneTextSound:Hide()
    ComergyOptRuneTextColor:SetText(COMERGY_TEXT_COLOR)
    ComergyOptBarTextTargetHealth:SetText(COMERGY_TARGET_HEALTH_WARNING)
    ComergyOptBarTextTargetHealth:SetPoint("TOP", ComergyOptSliderTargetHeight, "BOTTOM", 0, -8)

    if (playerClass == MONK) then
        CreateColorButton("ChiColor6", ComergyOptComboFrame, 150, -210, "", true)
        CreateCheckButton("SoundChi6", ComergyOptComboFrame, 100, -210)
        ComergyOptComboText6:SetText(comboText .. " 6")
    end

    local tdd = CreateFrame("Frame", "ComergyTextureDropdown", ComergyOptBarFrame, "UIDropDownMenuTemplate")
    ComergyTextureDropdownMiddle:SetWidth(60)
    tdd:SetPoint("TOPLEFT", 190, -110)

    ComergyTextureDropdownButton:SetScript("OnClick", function(self)
        if (DropDownList1:IsShown()) then
            DropDownList1:Hide()
        else
            local texturesList = {}
            for i = 1, #(ComergyBarTextures) do
                tinsert(texturesList,
                    { text = ComergyBarTextures[i][1], func = function() ChooseTexture(i) end, checked = false })
            end
            texturesList[Comergy_Settings.BarTexture].checked = true
            EasyMenu(texturesList, ComergyTextureDropdown, self, 0 , 0, nil)
        end
    end)
    ComergyOptBarTextTexture:SetJustifyH("RIGHT")
    ComergyOptBarTextTexture:SetPoint("BOTTOMRIGHT", ComergyTextureDropdownButton, "BOTTOMLEFT", -55, 0)
    ComergyOptBarTextTexture:SetPoint("TOPLEFT", ComergyTextureDropdownButton, "TOPLEFT", -135, 0)
    ComergyOptBarTextTexture:SetText(COMERGY_TEXTURE)
    tinsert(clickables, tdd)
    tinsert(clickables, ComergyTextureDropdownButton)

    tdd = CreateFrame("Frame", "ComergyTextDropdown", ComergyOptBarFrame, "UIDropDownMenuTemplate")
    ComergyTextDropdownMiddle:SetWidth(70)
    tdd:SetPoint("TOPLEFT", 180, -260)

    ComergyTextDropdownButton:SetScript("OnClick", function()
        if (DropDownList1:IsShown()) then
            DropDownList1:Hide()
        else
            local fontsList = {}
            for i = 1, #(ComergyTextFonts) do
                tinsert(fontsList,
                    { text = ComergyTextFonts[i][1], func = function() ChooseFont(i) end, checked = false })
            end
            fontsList[Comergy_Settings.TextFont].checked = true
            EasyMenu(fontsList, ComergyTextDropdown, ComergyTextDropdown, 0 , 0, nil)
        end
    end)
    ComergyOptGeneralTextText:SetJustifyH("RIGHT")
    ComergyOptGeneralTextText:SetPoint("BOTTOMRIGHT", ComergyTextDropdownButton, "BOTTOMLEFT", -65, 0)
    ComergyOptGeneralTextText:SetPoint("TOPLEFT", ComergyTextDropdownButton, "TOPLEFT", -145, 0)
    ComergyOptGeneralTextText:SetText(COMERGY_FONT)
    tinsert(clickables, tdd)
    tinsert(clickables, ComergyTextDropdownButton)

    tinsert(clickables, ComergyOptTab1)
    tinsert(clickables, ComergyOptTab2)
    tinsert(clickables, ComergyOptTab3)
    tinsert(clickables, ComergyOptTab4)
    tinsert(clickables, ComergyOptTab5)
    SetClickables()

    ComergyOptReadSettings()

    ComergyOptTabOnClick(1)

    ComergyOptFrame:Hide()
end

function ComergyOptToggle()
    if (ComergyOptFrame:IsShown()) then
        ComergyOptFrame:Hide()
    else
        ComergyOptReadSettings()
        ComergyOptFrame:Show()
    end
end

function ComergyOptTabOnClick(id)
    PlaySound163("GAMEGENERICBUTTONPRESS")
    local tab
    for i = 1, 5 do
        tab = getglobal("ComergyOptTab"..i)
        if (tab) then
            tab:UnlockHighlight()
        end
    end
    getglobal("ComergyOptTab"..id):LockHighlight()
    ComergyOptGeneralFrame:Hide()
    ComergyOptBarFrame:Hide()
    ComergyOptEnergyFrame:Hide()
    ComergyOptComboFrame:Hide()
    ComergyOptManaFrame:Hide()
    ComergyOptRogueFrame:Hide()
    ComergyOptRuneFrame:Hide()

    if (id == 1) then
        ComergyOptGeneralFrame:Show()
    elseif (id == 2) then
        ComergyOptBarFrame:Show()
    elseif (id == 3) then
        if (playerClass == DEATHKNIGHT or playerClass == DRUID or playerClass == HUNTER or 
            playerClass == MONK or playerClass == ROGUE or playerClass == WARRIOR or playerClass == DEMONHUNTER) then
            ComergyOptEnergyFrame:Show()
        else
            ComergyOptManaFrame:Show()
        end
    elseif (id == 4) then
        if (playerClass == DRUID or playerClass == MONK or playerClass == PALADIN or
            playerClass == ROGUE or playerClass == WARLOCK) then
            ComergyOptComboFrame:Show()
        elseif (playerClass == PRIEST or playerClass == SHAMAN) then
            ComergyOptEnergyFrame:Show()
        elseif (playerClass == DEATHKNIGHT) then
            ComergyOptRuneFrame:Show()
        end
    elseif (id == 5) then
        if (playerClass == ROGUE) then
            ComergyOptRogueFrame:Show()
        elseif (playerClass == DRUID or playerClass == MONK) then
            ComergyOptManaFrame:Show()
        end
    end
end

function ComergyOptEditBoxOnTextChanged(self)
    local _, _, name = string.find(self:GetName(), "ComergyOptEditBox(.+)")
    if (name) then
        if ((self:GetNumber() > 0) and (self:GetNumber() < UnitPowerMax("player"))) then
            Comergy_Settings[name] = self:GetNumber()
        else
            self:SetNumber(Comergy_Settings[name])
        end
    else
        _, _, name = string.find(self:GetName(), "ComergyOptSlider(.+)")
        if (name) then
            local parent = self:GetParent()
            local min, max = parent:GetMinMaxValues()
            local value = self:GetNumber()
            if ((value >= min) and (value <= max)) then
                parent:SetValue(value)
            else
                self:SetText(parent:GetValue())
            end
        else
            _, _, name = string.find(self:GetName(), "ComergyOptColor(.+)")
            if (name) then
                local color = StringToColor(self:GetText())
                if (color) then
                    local parent = self:GetParent()
                    local _, _, settingName = string.find(parent:GetName(), "ComergyOptColor(.+)")
                    parent:GetNormalTexture():SetVertexColor(color.r, color.g, color.b)
                    Comergy_Settings[settingName][1] = color.r
                    Comergy_Settings[settingName][2] = color.g
                    Comergy_Settings[settingName][3] = color.b
                else
                    Text()
                end
            end
        end
    end
    ComergyOnConfigChange()
end

function ClearEditBoxFocus()
    for i = 1, #(editBoxes) do
        editBoxes[i]:ClearFocus()
    end
end

local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local aboutTab = Cell:CreateFrame("CellOptionsFrame_AboutTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.aboutTab = aboutTab
aboutTab:SetAllPoints(Cell.frames.optionsFrame)
aboutTab:Hide()

local authorText, translatorsText, specialThanksText, patronsText
local UpdateFont

-------------------------------------------------
-- description
-------------------------------------------------
local descriptionPane
local function CreateDescriptionPane()
    descriptionPane = Cell:CreateTitledPane(aboutTab, "Cell", 422, 170)
    descriptionPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -5)

    local changelogsBtn = Cell:CreateButton(descriptionPane, L["Changelogs"], "accent", {100, 17})
    changelogsBtn:SetPoint("TOPRIGHT")
    changelogsBtn:SetScript("OnClick", function()
        F:CheckWhatsNew(true)
    end)

    local snippetsBtn = Cell:CreateButton(descriptionPane, L["Code Snippets"], "accent", {120, 17})
    snippetsBtn:SetPoint("TOPRIGHT", changelogsBtn, "TOPLEFT", 1, 0)
    snippetsBtn:SetScript("OnClick", function()
        F:ShowCodeSnippets()
    end)

    local descText = descriptionPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    descText:SetPoint("TOPLEFT", 5, -27)
    descText:SetPoint("RIGHT", -10, 0)
    descText:SetJustifyH("LEFT")
    descText:SetSpacing(5)
    descText:SetText(L["ABOUT"])
end



-------------------------------------------------
-- author
-------------------------------------------------
local function CreateAuthorPane()
    local authorPane = Cell:CreateTitledPane(aboutTab, L["Author"], 205, 50)
    authorPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -190)
    
    authorText = authorPane:CreateFontString(nil, "OVERLAY")
    authorText:SetPoint("TOPLEFT", 5, -27)
    authorText.font = "Interface\\AddOns\\Cell\\Media\\font.ttf"
    authorText.size = 12
    UpdateFont(authorText)

    authorText:SetText("篠崎-影之哀伤 (CN)")
end

-------------------------------------------------
-- slash
-------------------------------------------------
local function CreateSlashPane()
    local slashPane = Cell:CreateTitledPane(aboutTab, L["Slash Commands"], 205, 50)
    slashPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 222, -190)
    
    local commandText = slashPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    commandText:SetPoint("TOPLEFT", 5, -27)
    commandText:SetText("/cell")
end

-------------------------------------------------
-- translators
-------------------------------------------------
local function CreateTranslatorsPane()
    local translatorsPane = Cell:CreateTitledPane(aboutTab, L["Translators"], 205, 112)
    translatorsPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -255)

    translatorsText = translatorsPane:CreateFontString(nil, "OVERLAY")
    translatorsText.font = UNIT_NAME_FONT_KOREAN
    translatorsText.size = 12
    UpdateFont(translatorsText)

    translatorsText:SetPoint("TOPLEFT", 5, -27)
    translatorsText:SetPoint("TOPRIGHT", -5, -27)
    translatorsText:SetSpacing(5)
    translatorsText:SetJustifyH("LEFT")
    translatorsText:SetText("zhTW: RainbowUI, BNS333\nkoKR: naragok79, netaras, 부패질")
end

-------------------------------------------------
-- special thanks
-------------------------------------------------
local function CreateSpecialThanksPane()
    local specialThanksPane = Cell:CreateTitledPane(aboutTab, L["Special Thanks"], 205, 112)
    specialThanksPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 222, -255)

    specialThanksText = specialThanksPane:CreateFontString(nil, "OVERLAY")
    if LOCALE_zhCN then
        specialThanksText.font = GameFontNormal:GetFont()
    else
        specialThanksText.font = UNIT_NAME_FONT_CHINESE
    end
    specialThanksText.size = 13
    UpdateFont(specialThanksText)

    specialThanksText:SetPoint("TOPLEFT", 5, -27)
    specialThanksText:SetSpacing(5)
    specialThanksText:SetJustifyH("LEFT")
    specialThanksText:SetText("warbaby (爱不易)\n夕曦 (NGA)\nguesswhoiam (NGA)")
end

-------------------------------------------------
-- patrons
-------------------------------------------------
local function CreateAnimation(frame)
    local fadeOut = frame:CreateAnimationGroup()
    frame.fadeOut = fadeOut
    fadeOut.alpha = fadeOut:CreateAnimation("Alpha")
    fadeOut.alpha:SetFromAlpha(1)
    fadeOut.alpha:SetToAlpha(0)
    fadeOut.alpha:SetDuration(0.3)
    fadeOut:SetScript("OnFinished", function()
        frame:Hide()
    end)

    local fadeIn = frame:CreateAnimationGroup()
    frame.fadeIn = fadeIn
    fadeIn.alpha = fadeIn:CreateAnimation("Alpha")
    fadeIn.alpha:SetFromAlpha(0)
    fadeIn.alpha:SetToAlpha(1)
    fadeIn.alpha:SetDuration(0.3)
    fadeIn:SetScript("OnPlay", function()
        frame:Show()
    end)
end

local function CreateButton(w, h, tex)
    local patronsBtn = Cell:CreateButton(aboutTab, L["Patrons"], "accent", {w, h})
    patronsBtn:SetPushedTextOffset(0, 0)

    Cell:StartRainbowText(patronsBtn:GetFontString())

    local iconSize = min(w, h) - 2

    local icon1 = patronsBtn:CreateTexture(nil, "ARTWORK")
    patronsBtn.icon1 = icon1
    P:Point(patronsBtn.icon1, "TOPLEFT", 1, -1)
    P:Size(icon1, iconSize, iconSize)
    icon1:SetTexture(tex)
    icon1:SetVertexColor(0.5, 0.5, 0.5)
    
    local icon2 = patronsBtn:CreateTexture(nil, "ARTWORK")
    patronsBtn.icon2 = icon2
    P:Point(patronsBtn.icon2, "BOTTOMRIGHT", -1, 1)
    P:Size(icon2, iconSize, iconSize)
    icon2:SetTexture(tex)
    icon2:SetVertexColor(0.5, 0.5, 0.5)

    CreateAnimation(patronsBtn)

    return patronsBtn
end

local function CreatePatronsPane()
    -- pane
    local patronsPane = Cell:CreateTitledPane(aboutTab, "", 100, 100)
    patronsPane:SetFrameStrata("LOW")
    patronsPane:SetPoint("TOPLEFT", aboutTab, "TOPRIGHT", 6, -5)
    patronsPane:SetPoint("BOTTOMLEFT", aboutTab, "BOTTOMRIGHT", 6, 5)
    patronsPane:Hide()

    CreateAnimation(patronsPane)

    local sortIcon = patronsPane:CreateTexture(nil, "OVERLAY")
    sortIcon:SetPoint("TOPRIGHT")
    sortIcon:SetSize(16, 16)
    sortIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\alphabetical_sorting")

    local bgTex = patronsPane:CreateTexture(nil, "BACKGROUND")
    bgTex:SetPoint("TOPLEFT", -5, 5)
    bgTex:SetPoint("BOTTOMRIGHT", 5, -5)
    bgTex:SetTexture("Interface\\Buttons\\WHITE8x8")
    if Cell.isRetail then
        bgTex:SetGradient("HORIZONTAL", CreateColor(0.1, 0.1, 0.1, 1), CreateColor(0.1, 0.1, 0.1, 0.25))
    else
        bgTex:SetGradientAlpha("HORIZONTAL", 0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1, 0.25)
    end

    local patronsScroll = Cell:CreateScrollFrame(patronsPane, -27, 0)
    patronsScroll:SetScrollStep(27)

    patronsText = patronsScroll.content:CreateFontString(nil, "OVERLAY")
    if LOCALE_zhCN then
        patronsText.font = GameFontNormal:GetFont()
    else
        patronsText.font = UNIT_NAME_FONT_CHINESE
    end
    patronsText.size = 12
    UpdateFont(patronsText)

    patronsText:SetPoint("TOPLEFT")
    patronsText:SetSpacing(5)
    patronsText:SetJustifyH("LEFT")
    patronsText:SetText(F:GetPatrons())

    -- update width
    local elapsedTime = 0
    local function updateFunc(self, elapsed)
        elapsedTime = elapsedTime + elapsed
        
        patronsPane:SetWidth(patronsText:GetWidth() + 10)
        patronsScroll:SetContentHeight(patronsText:GetHeight() + 5)
        
        if elapsedTime >= 0.5 then
            patronsPane:SetScript("OnUpdate", nil)
        end
    end
    patronsPane:SetScript("OnShow", function()
        elapsedTime = 0
        patronsPane:SetScript("OnUpdate", updateFunc)
    end)

    -- button
    local patronsBtn1 = CreateButton(17, 100, [[Interface\AddOns\Cell\Media\Icons\right]])
    patronsBtn1:SetPoint("TOPLEFT", aboutTab, "TOPRIGHT", 1, -5)
    
    local label = patronsBtn1:GetFontString()
    label:ClearAllPoints()
    label:SetPoint("CENTER", 6, -5)
    label:SetRotation(-math.pi/2)
    
    local patronsBtn2 = CreateButton(100, 17, [[Interface\AddOns\Cell\Media\Icons\left]])
    patronsBtn2:SetPoint("TOPLEFT", aboutTab, "TOPRIGHT", 6, -5)
    patronsBtn2:Hide()

    patronsBtn1:SetScript("OnClick", function()
        if patronsBtn1.fadeOut:IsPlaying() or patronsBtn1.fadeIn:IsPlaying() then return end
        patronsBtn1.fadeOut:Play()
        patronsBtn2.fadeIn:Play()
        patronsPane.fadeIn:Play()
    end)
    
    patronsBtn2:SetScript("OnClick", function()
        if patronsBtn2.fadeOut:IsPlaying() or patronsBtn2.fadeIn:IsPlaying() then return end
        patronsBtn1.fadeIn:Play()
        patronsBtn2.fadeOut:Play()
        patronsPane.fadeOut:Play()
    end)
end

-------------------------------------------------
-- bugreport
-------------------------------------------------
local function CreateBugReportPane()
    local bugReportPane = Cell:CreateTitledPane(aboutTab, L["Bug Report & Suggestion"], 422, 100)
    bugReportPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -385)

    local bugReportEB = Cell:CreateEditBox(bugReportPane, 412, 20)
    bugReportEB:SetPoint("TOPLEFT", 5, -27)
    bugReportEB:SetText("https://github.com/enderneko/Cell/issues")
    bugReportEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            bugReportEB:SetText("https://github.com/enderneko/Cell/issues")
            bugReportEB:HighlightText()
        end
    end)
    
    local cnBugReportEB = Cell:CreateEditBox(bugReportPane, 412, 20)
    cnBugReportEB:SetPoint("TOPLEFT", bugReportEB, "BOTTOMLEFT", 0, -5)
    cnBugReportEB:SetText("https://kook.top/q4T7yp")
    cnBugReportEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            cnBugReportEB:SetText("https://kook.top/q4T7yp")
            cnBugReportEB:HighlightText()
        end
    end)

    local text = cnBugReportEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    text:SetPoint("RIGHT", -5, 0)
    text:SetText("|cff777777CN|r")
    
    local cnBugReportEB2 = Cell:CreateEditBox(bugReportPane, 204, 20)
    cnBugReportEB2:SetPoint("TOPLEFT", cnBugReportEB, "BOTTOMLEFT", 0, -5)
    cnBugReportEB2:SetText("https://bbs.nga.cn/read.php?tid=23488341")
    cnBugReportEB2:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            cnBugReportEB2:SetText("https://bbs.nga.cn/read.php?tid=23488341")
            cnBugReportEB2:HighlightText()
        end
    end)
        
    local text2 = cnBugReportEB2:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    text2:SetPoint("RIGHT", -5, 0)
    text2:SetText("|cff777777CN|r")

    local cnBugReportEB3 = Cell:CreateEditBox(bugReportPane, 203, 20)
    cnBugReportEB3:SetPoint("TOPLEFT", cnBugReportEB2, "TOPRIGHT", 5, 0)
    cnBugReportEB3:SetText("https://bbs.nga.cn/read.php?tid=32921170")
    cnBugReportEB3:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            cnBugReportEB3:SetText("https://bbs.nga.cn/read.php?tid=32921170")
            cnBugReportEB3:HighlightText()
        end
    end)
        
    local text3 = cnBugReportEB3:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    text3:SetPoint("RIGHT", -5, 0)
    text3:SetText("|cff777777CN|r")
end

-------------------------------------------------
-- import & export
-------------------------------------------------
local function CreateImportExportPane()
    local iePane = Cell:CreateTitledPane(aboutTab, L["Import & Export All Settings"], 422, 50)
    iePane:SetPoint("TOPLEFT", 5, -500)

    local importBtn = Cell:CreateButton(iePane, L["Import"], "accent-hover", {200, 20})
    importBtn:SetPoint("TOPLEFT", 5, -27)
    importBtn:SetScript("OnClick", F.ShowImportFrame)
    
    local exportBtn = Cell:CreateButton(iePane, L["Export"], "accent-hover", {200, 20})
    exportBtn:SetPoint("TOPRIGHT", -5, -27)
    exportBtn:SetScript("OnClick", F.ShowExportFrame)
end

-------------------------------------------------
-- functions
-------------------------------------------------
local init
local function ShowTab(tab)
    if tab == "about" then
        if not init then
            init = true
            CreateDescriptionPane()
            CreateAuthorPane()
            CreateSlashPane()
            CreateSpecialThanksPane()
            CreateTranslatorsPane()
            CreateBugReportPane()
            CreateImportExportPane()
            CreatePatronsPane()
        end
        aboutTab:Show()
        descriptionPane:SetTitle("Cell "..Cell.version)
    else
        aboutTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "AboutTab_ShowTab", ShowTab)

UpdateFont = function(fs)
    if not fs then return end
    
    fs:SetFont(fs.font, fs.size + CellDB["appearance"]["optionsFontSizeOffset"], "")
    fs:SetTextColor(1, 1, 1, 1)
    fs:SetShadowColor(0, 0, 0)
    fs:SetShadowOffset(1, -1)
end

function Cell:UpdateAboutFont()
    UpdateFont(authorText)
    UpdateFont(translatorsText)
    UpdateFont(specialThanksText)
    UpdateFont(patronsText)
end
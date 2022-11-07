local _, Cell = ...
local L = Cell.L
local F = Cell.funcs

local aboutTab = Cell:CreateFrame("CellOptionsFrame_AboutTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.aboutTab = aboutTab
aboutTab:SetAllPoints(Cell.frames.optionsFrame)
aboutTab:Hide()

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
    
    local authorNameText = authorPane:CreateFontString(nil, "OVERLAY")
    authorNameText:SetPoint("TOPLEFT", 5, -27)
    authorNameText:SetFont("Interface\\AddOns\\Cell\\Media\\font.ttf", 12, "")
    authorNameText:SetText("篠崎-影之哀伤 (CN)")
end

-------------------------------------------------
-- slash
-------------------------------------------------
local function CreateSlashPane()
    local slashPane = Cell:CreateTitledPane(aboutTab, L["Slash Commands"], 205, 50)
    slashPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -260)
    
    local commandText = slashPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    commandText:SetPoint("TOPLEFT", 5, -27)
    commandText:SetText("/cell")
end

-------------------------------------------------
-- translators
-------------------------------------------------
local function CreateTranslatorsPane()
    local translatorsPane = Cell:CreateTitledPane(aboutTab, L["Translators"], 205, 112)
    translatorsPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 222, -190)

    local translatorsText = translatorsPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    translatorsText:SetPoint("TOPLEFT", 5, -27)
    translatorsText:SetSpacing(5)
    translatorsText:SetJustifyH("LEFT")
    translatorsText:SetText("RainbowUI (zhTW)\nnaragok79 (koKR)\nBNS333 (zhTW)")
end

-------------------------------------------------
-- special thanks
-------------------------------------------------
local function CreateSpecialThanksPane()
    local specialThanksPane = Cell:CreateTitledPane(aboutTab, L["Special Thanks"].." |TInterface\\AddOns\\Cell\\Media\\heart:16:16|t ", 100, 100)
    specialThanksPane:SetPoint("TOPLEFT", aboutTab, "TOPRIGHT", 6, -5)

    local bgTex = specialThanksPane:CreateTexture(nil, "BACKGROUND")
    bgTex:SetPoint("TOPLEFT", -5, 5)
    bgTex:SetPoint("BOTTOMRIGHT", 5, -5)
    bgTex:SetTexture("Interface\\Buttons\\WHITE8x8")
    if Cell.isRetail then
        bgTex:SetGradient("HORIZONTAL", CreateColor(0.1, 0.1, 0.1, 1), CreateColor(0.1, 0.1, 0.1, 0.25))
    else
        bgTex:SetGradientAlpha("HORIZONTAL", 0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1, 0.25)
    end

    local thanksText = specialThanksPane:CreateFontString(nil, "OVERLAY")
    local font
    if LOCALE_zhCN then
        font = GameFontNormal:GetFont()
    else
        font = UNIT_NAME_FONT_CHINESE
    end
    thanksText:SetFont(font, 12, "")
    thanksText:SetTextColor(1, 1, 1, 1)
    thanksText:SetShadowColor(0, 0, 0)
    thanksText:SetShadowOffset(1, -1)

    thanksText:SetPoint("TOPLEFT", 5, -27)
    thanksText:SetSpacing(5)
    thanksText:SetJustifyH("LEFT")
    thanksText:SetText(
        "夕曦 (NGA)\n"..
        "黑色之城 (NGA)\n"..
        "夏木沐-伊森利恩 (CN)\n"..
        "flappysmurf (爱发电)\n"..
        "七月核桃丶-白银之手 (CN)\n"..
        "Smile (爱发电)\n"..
        "青乙-影之哀伤 (CN)\n"..
        "黑诺-影之哀伤 (CN)\n"..
        "Mike (爱发电)\n"..
        "大领主王大发-莫格莱尼 (CN)\n"..
        "古月文武 (爱发电)\n"..
        "CC (爱发电)\n"..
        "蓝色-理想 (NGA)\n"..
        "席慕容 (NGA)\n"..
        "星空 (爱发电)\n"..
        "年复一年路西法 (爱发电)\n"..
        "阿哲 (爱发电)\n"..
        "北方 (爱发电)"
    )

    local elapsedTime = 0

    local function updateFunc(self, elapsed)
        elapsedTime = elapsedTime + elapsed
        
        specialThanksPane:SetHeight(thanksText:GetHeight() + 35)
        specialThanksPane:SetWidth(thanksText:GetWidth() + 10)
        
        if elapsedTime >= 0.5 then
            specialThanksPane:SetScript("OnUpdate", nil)
        end
    end

    specialThanksPane:SetScript("OnShow", function()
        elapsedTime = 0
        specialThanksPane:SetScript("OnUpdate", updateFunc)
    end)
end

-------------------------------------------------
-- bugreport
-------------------------------------------------
local function CreateBugReportPane()
    local bugReportPane = Cell:CreateTitledPane(aboutTab, L["Bug Report & Suggestion"], 422, 73)
    bugReportPane:SetPoint("TOPLEFT", aboutTab, "TOPLEFT", 5, -330)

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
    cnBugReportEB:SetText("https://kook.top/w6uvTN")
    cnBugReportEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            cnBugReportEB:SetText("https://kook.top/w6uvTN")
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
    iePane:SetPoint("TOPLEFT", 5, -455)

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
        end
        aboutTab:Show()
        descriptionPane:SetTitle("Cell "..Cell.version)
    else
        aboutTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "AboutTab_ShowTab", ShowTab)
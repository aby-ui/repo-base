local _, Cell = ...
local L = Cell.L
local F = Cell.funcs

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
local function CreatePatronsPane()
    local patronsPane = Cell:CreateTitledPane(aboutTab, L["Patrons"], 100, 100)
    patronsPane:SetPoint("TOPLEFT", aboutTab, "TOPRIGHT", 6, -5)

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

    patronsText = patronsPane:CreateFontString(nil, "OVERLAY")
    if LOCALE_zhCN then
        patronsText.font = GameFontNormal:GetFont()
    else
        patronsText.font = UNIT_NAME_FONT_CHINESE
    end
    patronsText.size = 12
    UpdateFont(patronsText)

    patronsText:SetPoint("TOPLEFT", 5, -27)
    patronsText:SetSpacing(5)
    patronsText:SetJustifyH("LEFT")
    patronsText:SetText(
        "CC (爱发电)\n"..
        "flappysmurf (爱发电)\n"..
        "Mike (爱发电)\n"..
        "Sjerry-死亡之翼 (CN)\n"..
        "Smile (爱发电)\n"..
        "阿哲 (爱发电)\n"..
        "北方 (爱发电)\n"..
        "大领主王大发-莫格莱尼 (CN)\n"..
        "古月文武 (爱发电)\n"..
        "黑丨诺-影之哀伤 (CN)\n"..
        "黑色之城 (NGA)\n"..
        "蓝色-理想 (NGA)\n"..
        "年复一年路西法 (爱发电)\n"..
        "七月核桃丶-白银之手 (CN)\n"..
        "青乙-影之哀伤 (CN)\n"..
        "貼饼子-匕首岭 (CN)\n"..
        "席慕容 (NGA)\n"..
        "夏木沐-伊森利恩 (CN)\n"..
        "星空 (爱发电)"
    )

    local elapsedTime = 0

    local function updateFunc(self, elapsed)
        elapsedTime = elapsedTime + elapsed
        
        patronsPane:SetHeight(patronsText:GetHeight() + 35)
        patronsPane:SetWidth(patronsText:GetWidth() + 10)
        
        if elapsedTime >= 0.5 then
            patronsPane:SetScript("OnUpdate", nil)
        end
    end

    patronsPane:SetScript("OnShow", function()
        elapsedTime = 0
        patronsPane:SetScript("OnUpdate", updateFunc)
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
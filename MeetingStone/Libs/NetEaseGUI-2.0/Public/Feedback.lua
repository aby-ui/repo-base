
local GUI = LibStub('NetEaseGUI-2.0')

local Feedback = LibStub:NewLibrary('NetEaseGUI-2.0.Feedback', 1)
if not Feedback then
    return
end

local L = LibStub('AceLocale-3.0'):GetLocale('NetEaseGUI-2.0')

local Feedback = GUI.Feedback or GUI:GetClass('TitlePanel'):New(UIParent) do
    Feedback:Hide()
    GUI.Feedback = Feedback
end

function Feedback:OnLoad()
    self:SetSize(420, 400)
    self:SetPoint('CENTER')
    self:SetText(L.FeedbackTitle)
    self:SetFrameStrata('DIALOG')

    local bottomBackground = self:CreateTexture(nil, 'ARTWORK') do
        bottomBackground:SetTexture([[Interface\Buttons\UI-Button-Borders]])
        bottomBackground:SetTexCoord(0, 1.0, 0.59375, 1.0)
        bottomBackground:SetSize(256, 26)
        bottomBackground:SetPoint('BOTTOMLEFT', 11, 9)
        bottomBackground:SetPoint('BOTTOMRIGHT', -11, 9)
    end

    local SummaryHtml = GUI:GetClass('SummaryHtml'):New(self) do
        SummaryHtml:SetSize(380, 120)
        SummaryHtml:SetPoint('TOP', 0, -30)
    end
    
    local Text = GUI:GetClass('EditBox'):New(self) do
        Text:SetPoint('TOPLEFT', SummaryHtml, 'BOTTOMLEFT', 0, -20)
        Text:SetPoint('BOTTOMRIGHT', -20, 85)
        Text:SetPrompt(L.FeedbackPrompt)
        Text:SetMaxBytes(255)
    end

    local Label = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight') do
        Label:SetPoint('BOTTOMLEFT', 20, 45)
        Label:SetText(L.FeedbackMail)
    end

    local SendButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        SendButton:SetPoint('BOTTOMRIGHT', -20, 12)
        SendButton:SetSize(72, 22)
        SendButton:SetText(SUBMIT)
        SendButton:SetScript('OnClick', function()
            self:Send(strtrim(Text:GetText()))
        end)
    end

    self.Text = Text
    self.SummaryHtml = SummaryHtml
    self.SendButton = SendButton

    self.loaded = true
    self:SetScript('OnShow', self.OnShow)
    self:OnShow()
end

Feedback:SetScript('OnShow', Feedback.OnLoad)

function Feedback:OnShow()
    self.SummaryHtml:SetText(format(L.FeedbackSummary, self.title, self.version))
    self.Text:SetText()
    self.Text:SetFocus(true)
end

function Feedback:Send(text)
    if #text > 0 and type(self.callback) == 'function' then
        self.callback(true, text)
    end
    self:Hide()
end

function Feedback:Open(addonName, callback)
    local title = select(2, GetAddOnInfo(addonName))
    local version = GetAddOnMetadata(addonName, 'Version')

    self.title = title
    self.addonName = addonName
    self.version = version
    self.callback = callback
    self:Show()
end

function GUI:CallFeedbackDialog(addonName, callback)
    Feedback:Open(addonName, callback)
end

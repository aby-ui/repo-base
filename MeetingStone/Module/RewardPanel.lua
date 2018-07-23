
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local RewardPanel = Addon:NewModule(CreateFrame('Frame', nil, ExchangePanel), 'RewardPanel', 'AceEvent-3.0')

function RewardPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    ExchangePanel:RegisterPanel(L['兑换平台'], self, 8)

    local CodeWidget = GUI:GetClass('TitleWidget'):New(self) do
        CodeWidget:SetPoint('TOPLEFT')
        CodeWidget:SetPoint('TOPRIGHT')
        CodeWidget:SetHeight(205)
        CodeWidget:SetText(L['输入兑换码：'])
    end

    local SummaryWidget = GUI:GetClass('TitleWidget'):New(self) do
        SummaryWidget:SetPoint('TOPLEFT', CodeWidget, 'BOTTOMLEFT', 0, -5)
        SummaryWidget:SetPoint('BOTTOMRIGHT')
        SummaryWidget:SetText(L['兑换说明：'])
    end

    local InputBox = GUI:GetClass('EditBox'):New(CodeWidget) do
        InputBox:SetPoint('TOPLEFT', 158.5, -50)
        InputBox:SetSize(533, 50)
        InputBox:SetPrompt(L['请在这里输入兑换码'])
        InputBox:SetSinglelLine()
        InputBox:SetMaxLetters(16)
        local EditBox = InputBox:GetEditBox()
        EditBox:SetFontObject(GameFontNormalHugeOutline)
        EditBox:SetTextColor(1, 1, 1)
        InputBox:SetCallback('OnTextChanged', function(InputBox, userInput)
            if not userInput then
                return
            end
            local text = InputBox:GetText()
            local nText = select(2, text:find('%w+'))
            local isTextOK = not text:find('%W+')
            if isTextOK then
                if nText == 16 then
                    self.ErrorLabel:SetText(L['格式正确，请点击[确认兑换]按钮'])
                    self.ErrorLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                    InputBox:ClearFocus()
                else
                    self.ErrorLabel:SetText()
                end
                InputBox:SetText(text:upper())
            else
                EditBox:HighlightText()
                self.ErrorLabel:SetText(#text > 0 and L['兑换码格式错误'] or nil)
                self.ErrorLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
            end
            self.ConfirmButton:SetEnabled(isTextOK and nText == 16)
        end)
    end

    local InputBoxLabel = InputBox:CreateFontString(nil, 'OVERLAY', 'GameFontNormal') do
        InputBoxLabel:SetPoint('TOPLEFT', InputBox, 'BOTTOMLEFT', 0, -5)
        InputBoxLabel:SetText(L['不区分大小写，无需输入空格或连字符。'])
    end

    local ErrorLabel = InputBox:CreateFontString(nil, 'OVERLAY', 'GameFontNormalHugeOutline') do
        ErrorLabel:SetPoint('TOP', InputBox, 'BOTTOM', 0, -50)
    end

    local RewardSummary = GUI:GetClass('SummaryHtml'):New(SummaryWidget) do
        RewardSummary:SetPoint('TOP', 0, -30)
        RewardSummary:SetSize(650, 100)
        RewardSummary:SetText(L.RewardSummary)
    end

    local ConfirmButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        ConfirmButton:SetPoint('BOTTOM', self:GetOwner():GetOwner(), 'BOTTOM', 0, 4)
        ConfirmButton:SetSize(120, 22)
        ConfirmButton:SetText(L['确认兑换'])
        ConfirmButton:Disable()
        ConfirmButton:SetScript('OnClick', function()
            self:Purchase()
        end)
        MagicButton_OnLoad(ConfirmButton)
    end

    self.InputBox = InputBox
    self.ConfirmButton = ConfirmButton
    self.ErrorLabel = ErrorLabel

    self:RegisterMessage('MEETINGSTONE_REWARD_RESULT', 'Result')
end

function RewardPanel:Result(event, result)
    self:SetBlocker(false)

    if result then
        System:Error(result)
    end
end

function RewardPanel:SetBlocker(enable)
    if enable then
        ExchangePanel:SetCover(true, L.RewardPurchaseSummary,
            function()
                RewardPanel:Result(nil, L['兑换失败：处理超时，请稍后再试。'])
            end)
    else
        ExchangePanel:SetCover(false)
    end
end

function RewardPanel:Purchase()
    GUI:CallMessageDialog(L['确认使用兑换码？'], function(result)
        if result then
            Logic:Exchange(self.InputBox:GetText())
            self.ConfirmButton:Disable()
            self.ErrorLabel:SetText()
            self:SetBlocker(true)
        end
        end)
    self.InputBox:ClearFocus()
end

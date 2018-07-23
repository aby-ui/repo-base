
BuildEnv(...)

local InputDialog = Addon:NewClass('InputDialog', 'Frame')

function InputDialog:Constructor()
    self:Hide()
    self:SetFrameStrata('DIALOG')
    self:SetSize(320, 116)
    self:SetBackdrop({
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        edgeSize = 32, tileSize = 32, tile = true,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })

    local Label = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Label:SetPoint('TOP', 0, -15)
    end

    local Error = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Error:SetPoint('TOP', Label, 'BOTTOM', 0, -5)
        Error:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
    end

    local Input = GUI:GetClass('InputBox'):New(self) do
        Input:SetPoint('BOTTOM', 0, 45)
        Input:SetSize(200, 32)
        Input:SetAutoFocus(true)
        Input:SetScript('OnEscapePressed', function()
            self:Close()
        end)
        Input:SetScript('OnEnterPressed', function()
            self:Submit()
        end)
    end

    local CheckBox = GUI:GetClass('CheckBox'):New(self) do
        CheckBox:SetPoint('LEFT', Input, 'RIGHT', 0, 0)
        CheckBox:Hide()
    end

    local Submit = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        Submit:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -6, 16)
        Submit:SetSize(100, 22)
        Submit:SetText(OKAY)
        Submit:SetScript('OnClick', function()
            self:Submit()
        end)
    end

    local Cancel = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        Cancel:SetPoint('BOTTOMLEFT', self, 'BOTTOM', 6, 16)
        Cancel:SetSize(100, 22)
        Cancel:SetText(CANCEL)
        Cancel:SetScript('OnClick', function()
            self:Close()
        end)
    end

    self.Input = Input
    self.CheckBox = CheckBox
    self.Error = Error
    self.Label = Label
end

function InputDialog:SetMaxLetters(maxLetters)
    self.Input:SetMaxLetters(maxLetters)
end

function InputDialog:SetError(text)
    local enable = text and text ~= ''
    self.Error:SetShown(enable)
    self:SetHeight(enable and 126 or 116)
    self.Error:SetText(text)
end

function InputDialog:SetCheckBoxLabel(text)
    if text then
        self.CheckBox:SetText(text)
        self.Input:SetPoint('BOTTOM', -25, 45)
    else
        self.Input:SetPoint('BOTTOM', 0, 45)
    end
    self.CheckBox:SetShown(text)
end

function InputDialog:SetTitle(text)
    self.Label:SetText(text)
end

function InputDialog:Close()
    StaticPopupSpecial_Hide(self)
end

function InputDialog:Open(text, enable)
    StaticPopupSpecial_Show(self)

    self.Input:SetText(text)
    self.CheckBox:SetChecked(enable)
    self:SetError(nil)
end

function InputDialog:SetErrorHandler(handler)
    if type(handler) == 'function' then
        self.handler = handler
    end
end

function InputDialog:Submit()
    local text = self.Input:GetText()

    if text ~= '' then
        local checked = self.CheckBox:GetChecked()
        if self.handler and checked and not self.handler(text) then
            self:Fire('OnError')
            return
        end
        self:Fire('OnSubmit', text, checked)
    end

    self:Close()
end


BuildEnv(...)

local EditDialog = Addon:NewClass('EditDialog', GUI:GetClass('TitlePanel'))

function EditDialog:Constructor()
    self:Hide()
    self:SetFrameStrata('DIALOG')
    self:SetSize(320, 400)
    self:SetBackdrop({
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        edgeSize = 32, tileSize = 32, tile = true,
        insets = {left = 11, right = 12, top = 12, bottom = 11},
    })

    local Label = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Label:SetPoint('TOPLEFT', 30, -35)
    end

    local Text = GUI:GetClass('EditBox'):New(self) do
        Text:SetPoint('TOPLEFT', Label, 'BOTTOMLEFT', 0, -10)
        Text:SetPoint('BOTTOM', 0, 50)
        Text:GetEditBox():SetAutoFocus(true)
        Text:SetMaxLetters(1024000)
    end

    local Submit = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        Submit:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -6, 16)
        Submit:SetSize(100, 22)
        Submit:SetText(OKAY)
        Submit:SetScript('OnClick', function()

            self:Close()

            local text = Text:GetText():trim()

            if text ~= '' then
                self:Fire('OnSubmit', text)
            end
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

    self.CloseButton:SetScript('OnClick', function()
        self:Close()
    end)

    self.Label = Label
    self.Text = Text
    self.Submit = Submit
    self.Cancel = Cancel
    self.exclusive = true
end

function EditDialog:Close()
    StaticPopupSpecial_Hide(self)
end

function EditDialog:Open(title, description, default, enable)
    self:SetText(title)
    self.Label:SetText(description)
    self.Text:SetText(default or '')
    self.Text:GetEditBox():HighlightText(0)

    if enable == nil then
        enable = true
    end

    self.Submit:SetShown(enable)
    self.Cancel:SetShown(enable)
 
    StaticPopupSpecial_Show(self)
end

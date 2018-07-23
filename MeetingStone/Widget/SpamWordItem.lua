
BuildEnv(...)

local SpamWordItem = Addon:NewClass('SpamWordItem', GUI:GetClass('ItemButton'))

function SpamWordItem:Constructor(parent)
    local Text = self:CreateFontString(nil, 'OVERLAY')
    Text:SetPoint('LEFT')
    Text:SetPoint('RIGHT')
    self:SetFontString(Text)
    self:SetNormalFontObject('GameFontHighlightSmallLeft')
    self:SetHighlightTexture([[INTERFACE\QUESTFRAME\UI-QuestTitleHighlight]], 'ADD')
    self:SetCheckedTexture([[INTERFACE\QUESTFRAME\UI-QuestTitleHighlight]])

    local SpamWordDel = GUI:GetClass('ClearButton'):New(self) do
        SpamWordDel:SetPoint('RIGHT', -5, 0)
        SpamWordDel:SetScript('OnClick', function(SpamWordDel)
            Profile:DelSpamWord(self.data)
        end)
    end

    local IsPain = self:CreateTexture(nil, 'ARTWORK') do
        IsPain:SetTexture([[INTERFACE\WorldStateFrame\ColumnIcon-FlagCapture2]])
        IsPain:SetSize(16, 16)
        IsPain:SetPoint('RIGHT', SpamWordDel, 'LEFT', -5, 0)
        IsPain:Hide()
    end

    self.IsPain = IsPain
end

function SpamWordItem:SetPain(enable)
    self.IsPain:SetShown(enable)
end

function SpamWordItem:SetData(data)
    self.data = data
    if type(data) == 'table' then
        self:SetText(data.text)
        self:SetPain(not data.pain)
    else
        self:SetText(nil)
        self:SetPain(false)
    end
end

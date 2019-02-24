-- FilterBox.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 10/29/2018, 7:02:40 PM

BuildEnv(...)

FilterBox = Addon:NewClass('FilterBox', 'Frame')

function FilterBox:Constructor()
    local Check = CreateFrame('CheckButton', nil, self) do
        Check:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
        Check:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
        Check:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
        Check:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
        Check:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
        Check:SetSize(22, 22)
        Check:SetPoint('TOPLEFT')
        Check:SetFontString(Check:CreateFontString(nil, 'ARTWORK'))
        Check:GetFontString():SetPoint('LEFT', Check, 'RIGHT', 2, 0)
        Check:SetNormalFontObject('GameFontHighlightSmall')
        Check:SetHighlightFontObject('GameFontNormalSmall')
        Check:SetDisabledFontObject('GameFontDisableSmall')
        Check:SetScript('OnClick', function()
            self:OnCheckClick()
        end)
    end

    local MinBox = GUI:GetClass('NumericBox'):New(self) do
        MinBox:SetSize(60, 20)
        MinBox:SetPoint('TOPLEFT', Check, 'BOTTOMRIGHT', 0, -5)
    end

    local Text = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Text:SetPoint('LEFT', MinBox, 'RIGHT', 5, 0)
        Text:SetText('-')
    end

    local MaxBox = GUI:GetClass('NumericBox'):New(self) do
        MaxBox:SetSize(60, 20)
        MaxBox:SetPoint('LEFT', Text, 'RIGHT', 5, 0)
    end

    local function UpdateCheck()
        self:UpdateCheck()
    end

    MinBox:SetCallback('OnValueChanged', UpdateCheck)
    MaxBox:SetCallback('OnValueChanged', UpdateCheck)

    self:SetHeight(60)

    self.MinBox = MinBox
    self.MaxBox = MaxBox
    self.Check = Check
end

function FilterBox:UpdateCheck()
    if self.key ~= 'BossKilled' then
        self.Check:SetChecked(self.MinBox:GetNumber() ~= 0 or self.MaxBox:GetNumber() ~= 0)
    end
    self:Fire('OnChanged')
end

function FilterBox:OnCheckClick()
    self:Fire('OnChanged')
end

function FilterBox:Clear()
    self.MinBox:SetText('')
    self.MaxBox:SetText('')
end

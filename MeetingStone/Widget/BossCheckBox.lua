
BuildEnv(...)

BossCheckBox = Addon:NewClass('BossCheckBox', 'Button')

local TEXTURE_NIL = [[]]
local TEXTURE_TRUE = [[Interface\BUTTONS\UI-CheckBox-Check]]
local TEXTURE_FALSE = [[Interface\BUTTONS\UI-MultiCheck-Up]]

function BossCheckBox:Constructor()
    self:SetNormalTexture([[Interface\BUTTONS\UI-CheckBox-Up]])
    self:SetPushedTexture([[Interface\BUTTONS\UI-CheckBox-Down]])
    self:SetHighlightTexture([[Interface\BUTTONS\UI-CheckBox-Highlight]], 'ADD')

    self.CheckedTexture = self:CreateTexture(nil, 'OVERLAY') do
        self.CheckedTexture:SetAllPoints(self)
    end

    self.Text = self:CreateFontString(nil, 'ARTWORK', 'GameFontDisable') do
        self.Text:SetPoint('LEFT', self, 'RIGHT', 5, 0)
        self:SetFontString(self.Text)
    end

    self:SetScript('OnClick', self.OnClick)
end

function BossCheckBox:OnClick()
    local checked = self:GetChecked()
    if checked == nil then
        self:SetChecked(true)
    elseif checked == true then
        self:SetChecked(false)
    else
        self:SetChecked(nil)
    end
end

function BossCheckBox:SetChecked(flag)
    self.checked = flag and true or flag
    self:Update()
    self:Fire('OnCheckChanged', flag)
end

function BossCheckBox:GetChecked()
    return self.checked
end

function BossCheckBox:Update()
    local checked = self:GetChecked()
    if checked == true then
        self.CheckedTexture:SetTexture(TEXTURE_TRUE)
        self.Text:SetFontObject('GameFontGreen')
    elseif checked == false then
        self.CheckedTexture:SetTexture(TEXTURE_FALSE)
        self.Text:SetFontObject('GameFontRed')
    else
        -- self.CheckedTexture:SetTexture(TEXTURE_NIL)
        self.Text:SetFontObject('GameFontDisable')
    end
    self.CheckedTexture:SetShown(checked ~= nil)
end

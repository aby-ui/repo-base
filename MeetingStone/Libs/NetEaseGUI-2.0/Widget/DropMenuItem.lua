
local WIDGET, VERSION = 'DropMenuItem', 3

local GUI = LibStub('NetEaseGUI-2.0')
local DropMenuItem = GUI:NewClass('DropMenuItem', GUI:GetClass('ItemButton'), VERSION)
if not DropMenuItem then
    return
end

local CHECK_COORDS = {
    MULTI_NORMAL  = {0.5, 1,   0,   0.5},
    MULTI_CHECKED = {0,   0.5, 0,   0.5},
    RADIO_NORMAL  = {0.5, 1,   0.5, 1  },
    RADIO_CHECKED = {0,   0.5, 0.5, 1  },
}

function DropMenuItem:Constructor()
    local CheckBox = self:CreateTexture(nil, 'OVERLAY') do
        CheckBox:SetTexture([[INTERFACE\COMMON\UI-DropDownRadioChecks]])
        CheckBox:SetSize(16, 16)
        CheckBox:SetPoint('LEFT')
    end

    local Arrow = self:CreateTexture(nil, 'OVERLAY') do
        Arrow:SetTexture([[Interface\ChatFrame\ChatFrameExpandArrow]])
        Arrow:SetSize(16, 16)
        Arrow:SetPoint('RIGHT')
    end

    local Text = self:CreateFontString(nil, 'OVERLAY') do
        Text:SetPoint('LEFT', CheckBox, 'RIGHT', 2, 0)
    end
    
    local Separator = self:CreateTexture(nil, 'BACKGROUND') do
        Separator:SetTexture([[Interface\Common\UI-TooltipDivider-Transparent]])
        Separator:SetHeight(8)
        Separator:SetPoint('LEFT')
        Separator:SetPoint('RIGHT')
        Separator:Hide()
    end

    self:SetFontString(Text)
    self:SetNormalFontObject('GameFontHighlightSmallLeft')
    self:SetDisabledFontObject('GameFontNormalSmallLeft')

    self:SetHighlightTexture([[INTERFACE\QUESTFRAME\UI-QuestTitleHighlight]], 'ADD')

    self.Separator = Separator
    self.CheckBox = CheckBox
    self.Text = Text
    self.Arrow = Arrow

    self:SetScript('OnClick', self.OnClick)
    self:SetScript('OnDoubleClick', nil)
    self:RegisterForClicks('LeftButtonUp')
end

function DropMenuItem:SetCheckState(checkable, isNotRadio, checked)
    if checkable then
        if isNotRadio then
            self.CheckBox:SetTexCoord(unpack(CHECK_COORDS[checked and 'MULTI_CHECKED' or 'MULTI_NORMAL']))
        else
            self.CheckBox:SetTexCoord(unpack(CHECK_COORDS[checked and 'RADIO_CHECKED' or 'RADIO_NORMAL']))
        end
        self.Text:SetPoint('LEFT', self.CheckBox, 'RIGHT', 2, 0)
        self.CheckBox:Show()
    else
        self.Text:SetPoint('LEFT')
        self.CheckBox:Hide()
    end
    self:SetChecked(checked)
    self.checkable = checkable or nil
    self.isNotRadio = isNotRadio or nil
end

function DropMenuItem:SetHasArrow(hasArrow)
    self.Arrow:SetShown(hasArrow)
end

function DropMenuItem:GetAutoWidth()
    return self.Text:GetStringWidth() + 
        (self.Arrow:IsShown() and 18 or 0) +
        (self.CheckBox:IsShown() and 18 or 0)
end

function DropMenuItem:OnClick()
    self:SetCheckState(self.checkable, self.isNotRadio, self:GetChecked())
    self:FireHandler('OnItemClick')
end

function DropMenuItem:SetSeparator(flag)
    self.Separator:SetShown(flag)
end

function DropMenuItem:SetFontObject(fontObject)
    self:SetNormalFontObject(fontObject or 'GameFontHighlightSmallLeft')
end
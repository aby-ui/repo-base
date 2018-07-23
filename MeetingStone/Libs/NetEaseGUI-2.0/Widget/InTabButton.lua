
local WIDGET, VERSION = 'InTabButton', 1

local GUI = LibStub('NetEaseGUI-2.0')
local InTabButton = GUI:NewClass(WIDGET, GUI:GetClass('ItemButton'), VERSION)
if not InTabButton then
    return
end

function InTabButton:Constructor()
    self:SetHeight(22)
    self:SetWidth(100)

    self.tLeft = self:CreateTexture(nil, 'BACKGROUND')
    self.tLeft:SetSize(16, 32)
    self.tLeft:SetPoint('BOTTOMLEFT')
    self.tLeft:SetTexture([[Interface\HelpFrame\HelpFrameTab-Inactive]])
    self.tLeft:SetTexCoord(0, 0.25, 0, 1.0)

    self.tRight = self:CreateTexture(nil, 'BACKGROUND')
    self.tRight:SetSize(16, 32)
    self.tRight:SetPoint('BOTTOMRIGHT')
    self.tRight:SetTexture([[Interface\HelpFrame\HelpFrameTab-Inactive]])
    self.tRight:SetTexCoord(0.75, 1.0, 0, 1.0)

    self.tMid = self:CreateTexture(nil, 'BACKGROUND')
    self.tMid:SetPoint('TOPLEFT', self.tLeft, 'TOPRIGHT')
    self.tMid:SetPoint('BOTTOMRIGHT', self.tRight, 'BOTTOMLEFT')
    self.tMid:SetTexture([[Interface\HelpFrame\HelpFrameTab-Inactive]])
    self.tMid:SetTexCoord(0.25, 0.75, 0, 1.0)

    self.tActiveLeft = self:CreateTexture(nil, 'BACKGROUND')
    self.tActiveLeft:SetSize(16, 32)
    self.tActiveLeft:SetPoint('BOTTOMLEFT', 0, -3)
    self.tActiveLeft:SetTexture([[Interface\HelpFrame\HelpFrameTab-Active]])
    self.tActiveLeft:SetTexCoord(0, 0.25, 0, 1.0)

    self.tActiveRight = self:CreateTexture(nil, 'BACKGROUND')
    self.tActiveRight:SetSize(16, 32)
    self.tActiveRight:SetPoint('BOTTOMRIGHT', 0, -3)
    self.tActiveRight:SetTexture([[Interface\HelpFrame\HelpFrameTab-Active]])
    self.tActiveRight:SetTexCoord(0.75, 1.0, 0, 1.0)

    self.tActiveMid = self:CreateTexture(nil, 'BACKGROUND')
    self.tActiveMid:SetPoint('TOPLEFT', self.tActiveLeft, 'TOPRIGHT')
    self.tActiveMid:SetPoint('BOTTOMRIGHT', self.tActiveRight, 'BOTTOMLEFT')
    self.tActiveMid:SetTexture([[Interface\HelpFrame\HelpFrameTab-Active]])
    self.tActiveMid:SetTexCoord(0.25, 0.75, 0, 1.0)

    self:SetNormalFontObject('GameFontNormalSmall')
    self:SetDisabledFontObject('GameFontHighlightSmall')
    self:SetHighlightFontObject('GameFontHighlightSmall')

    self:SetHighlightTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]], 'ADD')
    self:GetHighlightTexture():SetHeight(32)
    self:GetHighlightTexture():SetPoint('BOTTOM', 2, -8)
end

function InTabButton:SetStatus(status)
    if status == 'SELECTED' then
        self.tActiveLeft:Show()
        self.tActiveRight:Show()
        self.tActiveMid:Show()
        self.tLeft:Hide()
        self.tRight:Hide()
        self.tMid:Hide()
        self:Disable()
        self:SetDisabledFontObject('GameFontHighlightSmall')
    elseif status == 'NORMAL' then
        self.tActiveLeft:Hide()
        self.tActiveRight:Hide()
        self.tActiveMid:Hide()
        self.tLeft:Show()
        self.tRight:Show()
        self.tMid:Show()
        self:Enable()
    elseif status == 'DISABLED' then
        self.tActiveLeft:Hide()
        self.tActiveRight:Hide()
        self.tActiveMid:Hide()
        self.tLeft:Show()
        self.tRight:Show()
        self.tMid:Show()
        self:Disable()
        self:SetDisabledFontObject('GameFontDisableSmall')
    end

    self:SetWidth(self:GetTextWidth() + 30)
end

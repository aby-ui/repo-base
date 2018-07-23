
BuildEnv(...)

local ApplicantItem = Addon:NewClass('ApplicantItem', GUI:GetClass('ItemButton'))

function ApplicantItem:Constructor()
    self:SetCheckedTexture([[Interface\HelpFrame\HelpFrameButton-Highlight]])
    self:GetCheckedTexture():SetTexCoord(0, 1, 0, 0.57)

    self:SetHighlightTexture([[Interface\HelpFrame\HelpFrameButton-Highlight]], 'ADD')
    self:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.57)

    local bg = self:CreateTexture(nil, 'BACKGROUND') do
        bg:SetPoint('TOPLEFT', 0, -1)
        bg:SetPoint('BOTTOMRIGHT', 0, 1)
        bg:SetColorTexture(1, 1, 1)
        bg:Hide()
    end

    self.bg = bg
end

function ApplicantItem:SetAlpha(alpha, button)
    self.bg:SetAlpha(alpha)
    self.bg:SetPoint('BOTTOMRIGHT', button)
    self.bg:Show()
end

function ApplicantItem:SetBackground(enable)
    self.bg:SetShown(enable)
end

function ApplicantItem:IsBackgroundShown()
    return self.bg:IsShown()
end

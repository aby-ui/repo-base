
BuildEnv(...)

local BrowseItem = Addon:NewClass('BrowseItem', GUI:GetClass('ItemButton'))

function BrowseItem:Constructor()
    self:SetCheckedTexture([[Interface\HelpFrame\HelpFrameButton-Highlight]])
    self:GetCheckedTexture():SetTexCoord(0, 1, 0, 0.57)

    self:SetHighlightTexture([[Interface\HelpFrame\HelpFrameButton-Highlight]], 'ADD')
    self:GetHighlightTexture():SetTexCoord(0, 1, 0, 0.57)

    local tLeft = self:CreateTexture(nil, 'BACKGROUND') do
        tLeft:SetTexture([[Interface\AuctionFrame\UI-AuctionItemNameFrame]])
        tLeft:SetTexCoord(0, 0.078125, 0, 1)
        tLeft:SetWidth(10)
        tLeft:SetPoint('TOPLEFT')
        tLeft:SetPoint('BOTTOMLEFT')
    end

    local tRight = self:CreateTexture(nil, 'BACKGROUND') do
        tRight:SetTexture([[Interface\AuctionFrame\UI-AuctionItemNameFrame]])
        tRight:SetTexCoord(0.75, 0.828125, 0, 1)
        tRight:SetWidth(10)
        tRight:SetPoint('TOPRIGHT')
        tRight:SetPoint('BOTTOMRIGHT')
    end

    local tMid = self:CreateTexture(nil, 'BACKGROUND') do
        tMid:SetTexture([[Interface\AuctionFrame\UI-AuctionItemNameFrame]])
        tMid:SetTexCoord(0.078125, 0.75, 0, 1)
        tMid:SetPoint('TOPLEFT', tLeft, 'TOPRIGHT')
        tMid:SetPoint('BOTTOMRIGHT', tRight, 'BOTTOMLEFT')
    end
end

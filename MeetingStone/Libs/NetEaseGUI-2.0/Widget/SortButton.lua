
local WIDGET, VERSION = 'SortButton', 1

local GUI = LibStub('NetEaseGUI-2.0')
local SortButton = GUI:NewClass(WIDGET, 'Button', VERSION)
if not SortButton then
    return
end

function SortButton:Constructor()
    local tLeft = self:CreateTexture(nil, 'BACKGROUND')
    tLeft:SetTexture([[Interface\FriendsFrame\WhoFrame-ColumnTabs]])
    tLeft:SetTexCoord(0, 0.078125, 0, 0.59375)
    tLeft:SetSize(5, 19)
    tLeft:SetPoint('TOPLEFT')

    local tRight = self:CreateTexture(nil, 'BACKGROUND')
    tRight:SetTexture([[Interface\FriendsFrame\WhoFrame-ColumnTabs]])
    tRight:SetTexCoord(0.90625, 0.96875, 0, 0.59375)
    tRight:SetSize(4, 19)
    tRight:SetPoint('TOPRIGHT')

    local tMid = self:CreateTexture(nil, 'BACKGROUND')
    tMid:SetTexture([[Interface\FriendsFrame\WhoFrame-ColumnTabs]])
    tMid:SetTexCoord(0.078125, 0.90625, 0, 0.59375)
    tMid:SetPoint('TOPLEFT', tLeft, 'TOPRIGHT')
    tMid:SetPoint('BOTTOMRIGHT', tRight, 'BOTTOMLEFT')

    local Text = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
    Text:SetPoint('LEFT', 8, 0)
    self:SetFontString(Text)

    local Arrow = self:CreateTexture(nil, 'OVERLAY')
    Arrow:SetTexture([[Interface\Buttons\UI-SortArrow]])
    Arrow:SetTexCoord(0, 0.5625, 0, 1.0)
    Arrow:SetSize(9, 8)
    Arrow:SetPoint('LEFT', Text, 'RIGHT', 3, -2)
    Arrow:Hide()

    self:SetHighlightTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]], 'ADD')
    self:GetHighlightTexture():SetHeight(24)
    self:GetHighlightTexture():ClearAllPoints()
    self:GetHighlightTexture():SetPoint('LEFT')
    self:GetHighlightTexture():SetPoint('RIGHT', 4, 0)

    self.Arrow = Arrow

    self:SetScript('OnClick', self.OnClick)
end

function SortButton:SetArrowStyle(style)
    if style == 'NONE' then
        self.Arrow:Hide()
    elseif style == 'UP' then
        self.Arrow:SetTexCoord(0, 0.5625, 1, 0)
        self.Arrow:Show()
    elseif style == 'DOWN' then
        self.Arrow:SetTexCoord(0, 0.5625, 0, 1)
        self.Arrow:Show()
    end
end

function SortButton:OnClick()
    if self.sortHandler then
        self:GetParent():SetSortHandler(self.sortHandler)
    end
end

--[[
@Date    : 2016-06-15 18:28:49
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

local FollowQueryCard = Addon:NewClass('FollowQueryCard', GUI:GetClass('ItemButton'))

function FollowQueryCard:Constructor()
    local Background = self:CreateTexture(nil, 'BACKGROUND') do
        Background:SetAllPoints(self)
        Background:SetTexture([[Interface\Store\Store-Splash]])
        Background:SetTexCoord(0.00097656, 0.28027344, 0.77441406, 0.91699219)
    end

    local Name = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Name:SetPoint('TOP', 10, -22)
    end

    local ClassIcon = self:CreateTexture(nil, 'ARTWORK') do
        ClassIcon:SetPoint('RIGHT', Name, 'LEFT', -5, 0)
        ClassIcon:SetSize(16, 16)
        -- ClassIcon:SetBlendMode('ADD')
        ClassIcon:SetTexture([[Interface\WorldStateFrame\ICONS-CLASSES]])
    end

    local function MakeLabel(w, ...)
        local MT = self:CreateTexture(nil, 'BORDER') do
            MT:SetTexture([[Interface\COMMON\StreamBackground]])
            MT:SetTexCoord(0.5, 0.51, 0.1875, 0.8125)
            MT:SetVertexColor(0, 0, 0)
            MT:SetSize(w, 20)
            MT:SetPoint(...)
        end

        local LT = self:CreateTexture(nil, 'BORDER') do
            LT:SetTexture([[Interface\COMMON\StreamBackground]])
            LT:SetTexCoord(0.125, 0.5, 0.1875, 0.8125)
            LT:SetVertexColor(0, 0, 0)
            LT:SetSize(10, 20)
            LT:SetPoint('RIGHT', MT, 'LEFT')
        end

        local RT = self:CreateTexture(nil, 'BORDER') do
            RT:SetTexture([[Interface\COMMON\StreamBackground]])
            RT:SetTexCoord(0.5, 0.8125, 0.1875, 0.8125)
            RT:SetVertexColor(0, 0, 0)
            RT:SetSize(10, 20)
            RT:SetPoint('LEFT', MT, 'RIGHT')
        end

        local Label = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormal') do
            Label:SetPoint('CENTER', MT, 'CENTER')
            Label:SetFont(Label:GetFont(), 12)
        end
        return Label
    end

    local IgnoreButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        IgnoreButton:SetSize(80, 18)
        IgnoreButton:SetPoint('BOTTOMLEFT', self, 'BOTTOM', 2, 18)
        IgnoreButton:SetText(L['忽略'])
        IgnoreButton.Left:SetVertexColor(0.6, 0.6, 0.6)
        IgnoreButton.Middle:SetVertexColor(0.6, 0.6, 0.6)
        IgnoreButton.Right:SetVertexColor(0.6, 0.6, 0.6)
        IgnoreButton:SetNormalFontObject(NetEaseFontDisableSmall)
        IgnoreButton:SetHighlightFontObject(NetEaseFontHighlightSmall)
        IgnoreButton:GetFontString():SetTextColor(0.67, 0.67, 0.67)
        self:BindScript(IgnoreButton, 'OnClick', 'OnCancelClick')
    end

    local AcceptButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        AcceptButton:SetSize(80, 18)
        AcceptButton:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -2, 18)
        AcceptButton:SetText(L['接受'])
        AcceptButton:SetNormalFontObject(NetEaseFontHighlightSmall)
        AcceptButton:SetHighlightFontObject(NetEaseFontHighlightSmall)
        self:BindScript(AcceptButton, 'OnClick', 'OnAcceptClick')
    end

    local Level = MakeLabel(50, 'BOTTOMLEFT', AcceptButton, 'TOPLEFT', 8, 13)
    local ItemLevel = MakeLabel(75, 'BOTTOMRIGHT', IgnoreButton, 'TOPRIGHT', -8, 13)

    self.ClassIcon = ClassIcon
    self.Name = Name
    self.Level = Level
    self.ItemLevel = ItemLevel
    self.AcceptButton = AcceptButton
    self.IgnoreButton = IgnoreButton
end

function FollowQueryCard:SetFollowQuery(followQuery)
    self.Name:SetText(followQuery:GetNameText())
    self.Level:SetText(L['等级:'] .. followQuery:GetLevel())
    self.ItemLevel:SetText(L['物品等级:'] .. followQuery:GetItemLevel())
    self.ClassIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[followQuery:GetClass()]))
end

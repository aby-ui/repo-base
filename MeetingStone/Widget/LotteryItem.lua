
BuildEnv(...)

LotteryItem = Addon:NewClass('LotteryItem', 'Button')

GUI:Embed(LotteryItem, 'Refresh')

function LotteryItem:Constructor()
    local Background = self:CreateTexture(nil, 'BACKGROUND') do
        Background:SetTexture([[Interface\Store\Store-Main]])
        Background:SetTexCoord(0.18457031, 0.32714844, 0.64550781, 0.84960938)
        Background:SetAllPoints(true)
    end

    local Icon = self:CreateTexture(nil, 'ARTWORK') do
        Icon:SetSize(63, 63)
        Icon:SetPoint('CENTER', 0, 8)
        local IconBorder = self:CreateTexture(nil, 'ARTWORK', nil, 2)
        IconBorder:SetTexture([[Interface\Store\Store-Main]])
        IconBorder:SetTexCoord(0.84375000, 0.92187500, 0.37207031, 0.45117188)
        IconBorder:SetSize(80, 81)
        IconBorder:SetPoint('CENTER', Icon, 0, -3)

        local org_SetShown = Icon.SetShown
        Icon.SetShown = function(_, enable)
            org_SetShown(Icon, enable)
            IconBorder:SetShown(enable)
        end
    end

    local Model = CreateFrame('PlayerModel', nil, self) do
        Model:SetSize(80, 80)
        Model:SetPoint('CENTER', 0, 10)
    end

    local Name = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall') do
        Name:SetPoint('BOTTOMLEFT', 5, 5)
        Name:SetPoint('BOTTOMRIGHT', -5, 5)
        Name:SetWordWrap(false)
    end

    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', GameTooltip_Hide)

    self.Model = Model
    self.Icon = Icon
    self.Name = Name
end

function LotteryItem:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    GameTooltip:SetText(self.Name:GetText())
    GameTooltip:Show()
end

function LotteryItem:SetText(text)
    self.Name:SetText(text)
end

function LotteryItem:SetIcon(icon)
    self.Icon:SetTexture(tonumber(icon) or icon)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())
end

function LotteryItem:SetModel(model)
    self.model = model
    self:Refresh()
end

function LotteryItem:Update()
    self.Model:SetShown(self.model)
    self.Icon:SetShown(not self.model)

    if self.model then
        self.Model:SetDisplayInfo(self.model)
        self.Model:SetDoBlend(false)
        self.Model:SetAnimation(0, -1)
        self.Model:SetRotation(0.61)
        self.Model:SetPosition(0, 0, 0)
        self.Model:SetPortraitZoom(0)
    end
end

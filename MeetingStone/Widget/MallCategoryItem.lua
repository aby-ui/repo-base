
BuildEnv(...)

local MallCategoryItem = Addon:NewClass('MallCategoryItem', GUI:GetClass('ItemButton'))

function MallCategoryItem:Constructor()
    local bg = self:CreateTexture(nil, 'BACKGROUND') do
        bg:SetTexture([[Interface\Store\Store-Main]])
        bg:SetTexCoord(0.56542969, 0.73730469, 0.41992188, 0.45703125)
        bg:SetAllPoints(true)
    end

    local Text = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormal') do
        Text:SetJustifyH('LEFT')
        Text:SetPoint('LEFT', 48, 4)
    end

    local hasNew = self:CreateTexture(nil, 'ARTWORK') do
        hasNew:SetTexture([[Interface\Store\Store-Main]])
        hasNew:SetTexCoord(0.93457031, 0.97265625, 0.23437500, 0.27734375)
        hasNew:SetSize(39, 44)
        hasNew:SetPoint('RIGHT', 0, 2)
        hasNew:Hide()
    end

    local HighlightTexture = self:CreateTexture(nil, 'ARTWORK') do
        HighlightTexture:SetTexture([[Interface\Store\Store-Main]])
        HighlightTexture:SetBlendMode('ADD')
        HighlightTexture:SetTexCoord(0.00097656, 0.16894531, 0.93847656, 0.97167969)
        HighlightTexture:SetSize(172, 34)
        HighlightTexture:SetPoint('CENTER', 0, 2)
        HighlightTexture:Hide()
        self:SetHighlightTexture(HighlightTexture, 'ADD')
    end

    local CheckedTexture = self:CreateTexture(nil, 'ARTWORK') do
        CheckedTexture:SetTexture([[Interface\Store\Store-Main]])
        CheckedTexture:SetBlendMode('ADD')
        CheckedTexture:SetTexCoord(0.73535156, 0.90332031, 0.46289063, 0.49609375)
        CheckedTexture:SetSize(172, 34)
        CheckedTexture:SetPoint('CENTER', 0, 2)
        CheckedTexture:Hide()
        self:SetCheckedTexture(CheckedTexture)
    end

    local Icon = self:CreateTexture(nil, 'OVERLAY') do
        Icon:SetTexture([[Interface\AddOns\MeetingStone\Media\MallIcons]])
        Icon:SetSize(32, 32)
        Icon:SetPoint('CENTER', self, 'LEFT', 15, 2)
    end

    self.Text = Text
    self.hasNew = hasNew
    self.Icon = Icon
    self.HighlightTexture = HighlightTexture
    self.CheckedTexture = CheckedTexture
    self.bg = bg
end

function MallCategoryItem:SetText(text)
    self.HighlightTexture:SetWidth(self:GetWidth() - 4)
    self.CheckedTexture:SetWidth(self:GetWidth() - 4)
    self.Text:SetText(text)
end

function MallCategoryItem:SetNew(enable)
    self.hasNew:SetShown(enable)
end

function MallCategoryItem:SetIcon(coord)
    self.Icon:SetTexCoord(unpack(coord))
end

function MallCategoryItem:SetBlue(enable)
    self.bg:ClearAllPoints()
    if enable then
        self.bg:SetTexCoord(0, 1, 0, 1)
        self.bg:SetAtlas('token-button-category')
        self.bg:SetPoint('TOPLEFT', 3, 0)
        self.bg:SetPoint('BOTTOMRIGHT', -3, 3)
    else
        self.bg:SetTexture([[Interface\Store\Store-Main]])
        self.bg:SetTexCoord(0.56542969, 0.73730469, 0.41992188, 0.45703125)
        self.bg:SetAllPoints(true)
    end
end
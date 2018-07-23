
BuildEnv(...)

local MallItem = Addon:NewClass('MallItem', GUI:GetClass('ItemButton'))

GUI:Embed(MallItem, 'Refresh')
LibStub('AceTimer-3.0'):Embed(MallItem)

function MallItem:Constructor()
    local Background = self:CreateTexture(nil, 'BACKGROUND') do
        Background:SetTexture([[Interface\Store\Store-Main]])
        Background:SetTexCoord(0.18457031, 0.32714844, 0.64550781, 0.84960938)
        Background:SetAllPoints(true)
    end

    local Shadows = self:CreateTexture(nil, 'BACKGROUND', nil, 2) do
        Shadows:SetTexture([[Interface\Store\Store-Main]])
        Shadows:SetTexCoord(0.84375000, 0.97851563, 0.29980469, 0.37011719)
        Shadows:SetSize(138, 72)
        Shadows:SetPoint('CENTER')
    end

    local Icon = self:CreateTexture(nil, 'ARTWORK') do
        Icon:SetSize(63, 63)
        Icon:SetPoint('TOP', 0, -36)
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

    local Title = self:CreateFontString(nil, 'OVERLAY') do
        Title:SetPoint('CENTER', Icon, 'CENTER', 0, -10)
        Title:SetFont(STANDARD_TEXT_FONT, 26)
        Title:SetShadowOffset(2, -2)
    end

    local Price = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall2', 3) do
        Price:SetPoint('BOTTOM', 0, 30)
    end

    local SalePrice = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall2', 3) do
        SalePrice:SetPoint('BOTTOMLEFT', self, 'BOTTOM', 2, 30)
        SalePrice:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        SalePrice:Hide()
    end

    local Strikethrough = self:CreateTexture(nil, 'OVERLAY') do
        Strikethrough:SetTexture([[Interface\Store\Store-Main]])
        Strikethrough:SetTexCoord(0.93457031, 0.96582031, 0.14257813, 0.15234375)
        Strikethrough:SetSize(32, 10)
        Strikethrough:SetPoint('TOPLEFT', Price, -2, 0)
        Strikethrough:SetPoint('BOTTOMRIGHT', Price, 2, 0)
        Strikethrough:Hide()
    end

    local Name = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalMed3') do
        Name:SetSize(120, 40)
        Name:SetPoint('BOTTOM', 0, 42)
        Name:SetTextColor(1, 1, 1, 1)
    end

    local CheckedTexture = self:CreateTexture(nil, 'ARTWORK', nil, 1) do
        CheckedTexture:SetTexture([[Interface\Store\Store-Main]])
        CheckedTexture:SetTexCoord(0.37011719, 0.50683594, 0.74218750, 0.94042969)
        CheckedTexture:SetBlendMode('ADD')
        CheckedTexture:SetPoint('CENTER')
        CheckedTexture:Hide()
    end

    local HighlightTexture = self:CreateTexture(nil, 'ARTWORK', nil, 2) do
        HighlightTexture:SetTexture([[Interface\Store\Store-Main]])
        HighlightTexture:SetTexCoord(0.37011719, 0.50683594, 0.54199219, 0.74023438)
        HighlightTexture:SetBlendMode('ADD')
        HighlightTexture:SetPoint('CENTER')
        HighlightTexture:Hide()
    end

    local Model = CreateFrame('PlayerModel', nil, self) do
        Model:SetSize(126, 124)
        Model:SetPoint('BOTTOM', 0, 80)
        Model:SetDoBlend(false)
        Model:SetAnimation(0, -1)
        Model:SetRotation(0.61)
        Model:SetPosition(0, 0, 0)
        Model:SetPortraitZoom(0)
    end

    local Magnifier = CreateFrame('Button', nil, self) do
        Magnifier:SetSize(31, 35)
        Magnifier:SetPoint('TOPLEFT', 8, -8)
        Magnifier:SetNormalTexture([[Interface\Store\Store-Main]])
        Magnifier:GetNormalTexture():SetSize(31, 35)
        Magnifier:GetNormalTexture():SetTexCoord(0.32910156, 0.35937500, 0.72363281, 0.75781250)
        Magnifier:SetHighlightTexture([[Interface\Store\Store-Main]], 'ADD')
        Magnifier:GetHighlightTexture():SetSize(31, 35)
        Magnifier:GetHighlightTexture():SetTexCoord(0.32910156, 0.35937500, 0.72363281, 0.75781250)
        Magnifier:Hide()
        Magnifier:SetScript('OnEnter', function()
            self:SetMagnifier(true)
        end)
        Magnifier:SetScript('OnLeave', function()
            self:SetMagnifier(false)
        end)
        Magnifier:SetScript('OnClick', function()
            if not self.model then
                return
            end
            local frame = ModelPreviewFrame
            ModelPreviewFrame_ShowModel(self.model, 10, true)
            frame.Display.Name:SetText(self.text)
        end)
    end

    local Discount = CreateFrame('Frame', nil, self) do
        Discount:SetFrameLevel(Model:GetFrameLevel() + 1)
        Discount:SetPoint('TOPRIGHT', 1, -2)
        Discount:SetSize(32,32)
        Discount:Hide()

        local DiscountRight = Discount:CreateTexture(nil, 'ARTWORK', nil, 3)
        DiscountRight:SetTexture([[Interface\Store\Store-Main]])
        DiscountRight:SetTexCoord(0.98828125, 0.99609375, 0.19921875, 0.23046875)
        DiscountRight:SetSize(8, 32)
        DiscountRight:SetPoint('TOPRIGHT', 1, -2)

        local DiscountLeft = Discount:CreateTexture(nil, 'ARTWORK', nil, 3)
        DiscountLeft:SetTexture([[Interface\Store\Store-Main]])
        DiscountLeft:SetTexCoord(0.98828125, 0.99609375, 0.10546875, 0.13671875)
        DiscountLeft:SetSize(8, 32)
        DiscountLeft:SetPoint('TOPLEFT', -1, -2)

        local DiscountMiddle = Discount:CreateTexture(nil, 'ARTWORK', nil, 3)
        DiscountMiddle:SetTexture([[Interface\Store\Store-Main]])
        DiscountMiddle:SetTexCoord(0.32910156, 0.36230469, 0.69042969, 0.72167969)
        DiscountMiddle:SetSize(34, 32)
        DiscountMiddle:SetPoint('RIGHT', DiscountRight, 'LEFT', 0, 0)
        DiscountMiddle:SetPoint('LEFT', DiscountLeft, 'RIGHT', 0, 0)

        local Text = Discount:CreateFontString(nil, 'OVERLAY', 'GameFontNormalMed2')
        Text:SetPoint('CENTER', DiscountMiddle, 1, 2)
        Text:SetTextColor(1, 1, 1)

        Discount.SetText = function(_, text)
            Text:SetText(text)
            Discount:SetWidth(Text:GetStringWidth() + 20)
        end
    end

    local CheckMark = CreateFrame('Frame', nil, self) do
        CheckMark:SetFrameLevel(Model:GetFrameLevel() + 1)
        CheckMark:SetPoint('TOPRIGHT', -8, -8)
        CheckMark:SetSize(27, 27)
        CheckMark:Hide()

        local bg = CheckMark:CreateTexture(nil, 'OVERLAY')
        bg:SetAllPoints(true)
        bg:SetTexture([[Interface\Store\Store-Main]])
        bg:SetTexCoord(0.81347656, 0.83984375, 0.41992188, 0.44628906)

        CheckMark:SetScript('OnEnter', function()
            GameTooltip:SetOwner(CheckMark, 'ANCHOR_TOP')
            GameTooltip:SetText(L['你已经拥有了该物品！'], 1, 1, 1)
            GameTooltip:Show()
        end)
        CheckMark:SetScript('OnLeave', GameTooltip_Hide)
    end

    self:SetScript('OnEvent', self.Refresh)

    self:SetCheckedTexture(CheckedTexture)
    self:SetHighlightTexture(HighlightTexture)

    self.Price         = Price
    self.Icon          = Icon
    self.Shadows       = Shadows
    self.Model         = Model
    self.Magnifier     = Magnifier
    self.Name          = Name
    self.Strikethrough = Strikethrough
    self.SalePrice     = SalePrice
    self.Discount      = Discount
    self.CheckMark     = CheckMark
    self.Title         = Title

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
    self:SetScript('OnShow', self.OnShow)
    self:SetScript('OnHide', self.OnHide)
end

function MallItem:OnSizeChanged(width, height)
    self:GetHighlightTexture():SetSize(width-6, height-6)
    self:GetCheckedTexture():SetSize(width-6, height-6)
end

function MallItem:IsMagnifierShown()
    return self.model
end

function MallItem:SetMagnifier(enable)
    if self:IsMagnifierShown() then
        self.Magnifier:SetShown(enable)
    else
        self.Magnifier:SetShown(false)
    end
end

function MallItem:SetPrice(price, originalPrice)
    self.price, self.originalPrice = price, originalPrice
    self:Refresh()
end

function MallItem:SetText(text)
    self.text = text
    self:Refresh()
end

function MallItem:SetModel(id)
    self.model = id
    self:Refresh()
end

function MallItem:SetItem(id)
    self.item = id
    self:Refresh()
end

function MallItem:SetIcon(icon)
    self.icon = icon
    self:Refresh()
end

function MallItem:SetStartTime(hour)
    self.hour = hour
    self:Refresh()
end

function MallItem:SetCurrency(currency)
    self.currency = currency
    self:Refresh()
end

function MallItem:SetSmallText(text)
    self.smallText = text
    self:Refresh()
end

function MallItem:SetTitle(title)
    self.title = title
    self:Refresh()
end

function MallItem:Update()
    if self.item then
        local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon = GetItemInfo(self.item)
        if name then
            self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')
            self.text = name
            self.icon = icon
        else
            self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
            self.text = RED_FONT_COLOR_CODE .. RETRIEVING_ITEM_INFO .. '|r'
            self.icon = GetItemIcon(self.item)
        end
    end

    self.Model:SetShown(self.model)
    self.Icon:SetShown(not self.model and self.icon)
    self.Title:SetShown(not self.model and not self.icon and self.title)

    if self.model then
        if self.Model:GetID() ~= self.model then
            self.Model:SetDisplayInfo(self.model)
            self.Model:SetID(self.model)
        end
    elseif self.icon then
        self.Icon:SetTexture(tonumber(self.icon) or self.icon)
        SetPortraitToTexture(self.Icon, self.icon)
    elseif self.title then
        self.Title:SetText(self.title)
    end

    if self.price then
        self.Shadows:Show()
        self.Price:Show()
        self.Price:ClearAllPoints()
        self.SalePrice:SetShown(self.originalPrice)
        self.Strikethrough:SetShown(self.originalPrice)

        if self.originalPrice then
            self.SalePrice:SetText(self.price .. (self.currency or '*'))
            self.Price:SetText(self.originalPrice .. (self.currency or '*'))
            self.Price:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -2, 30)
        else
            if type(self.price) == 'function' then
                local price = self.price()
                if price and self.data.status() then
                    self.Price:SetText(GetMoneyString(price, true))
                else
                    self.Price:SetText(TOKEN_MARKET_PRICE_NOT_AVAILABLE)
                end
            else
                self.Price:SetText(self.price .. (self.currency or '*'))
            end
            self.Price:SetPoint('BOTTOM', self, 0, 30)
        end
    else
        self.Price:Hide()
        self.SalePrice:Hide()
        self.Strikethrough:Hide()
        self.Shadows:Hide()
    end

    if self.hour then
        self.Discount:SetText(format('%d:00 秒杀', self.hour))
        self.Discount:Show()
    elseif self.price and self.originalPrice then
        self.Discount:SetText(format(L['%.1f折'], ceil(self.price/self.originalPrice*100)/10))
        self.Discount:Show()
    elseif self.smallText then
        self.Discount:SetText(self.smallText)
        self.Discount:Show()
    else
        self.Discount:Hide()
    end

    if self.text then
        self.Name:SetText(self.text)
    end

    if not self:IsWowToken() and self.item and (PlayerHasToy(self.item) or PlayerHasMount(self.model) or PlayerHasPet(self.text) or PlayerHasItem(self.item)) then
        self.Discount:Hide()
        self.CheckMark:Show()
    else
        self.CheckMark:Hide()
    end
end

function MallItem:Clear()
    self.title = nil
    self.data = nil
    self.item = nil
    self.model = nil
    self.price = nil
    self.originalPrice = nil
    self.hour = nil
    self.icon = nil
    self.currency = nil
    self.smallText = nil
    self.isToken = nil
end

local orig_FireFormat = MallItem.FireFormat
function MallItem:FireFormat()
    self:Clear()
    orig_FireFormat(self)
end

function MallItem:SetToken(data)
    self:SetItem(data.itemId)
    self:SetPrice(data.price)
end

function MallItem:UpdateToken()
    if type(self.data.update) == 'function' then
        self.data.update()
    end
end

function MallItem:SetAutoUpdate(enable)
    self.isToken = enable
    if enable then
        self.event = self.data.event
        self:RegisterEvent(self.event)
        self.timer = self:ScheduleTimer('UpdateToken', 300)
    else
        if self.timer then
            self:CancelTimer(self.timer)
            self.timer = nil
        end
        if self.event then
            self:UnregisterEvent(self.event)
            self.event = nil
        end
    end
end

function MallItem:IsWowToken()
    return self.isToken
end

function MallItem:GetData()
    return self.data
end

function MallItem:SetData(data)
    self.data = data
    if data.itemId == WOW_TOKEN_ITEM_ID then
        self:SetToken(data)
        self:SetAutoUpdate(true)
    else
        self:SetItem(data.itemId)
        self:SetModel(data.model)
        self:SetText(data.name)
        self:SetIcon(data.icon)
        self:SetPrice(data.price, data.originalPrice)
        self:SetStartTime(data.startTime)
        self:SetAutoUpdate(false)
        self:SetSmallText(data.smallText)
        self:SetTitle(data.title)
    end
end

function MallItem:OnShow()
    if self:IsWowToken() then
        self.event = self.data.event
        self:RegisterEvent(self.event)
        if self.timer then
            self:CancelTimer(self.timer)
        end
        self.timer = self:ScheduleTimer('UpdateToken', 300)
        self:UpdateToken()
    end
end

function MallItem:OnHide()
    if self.timer then
        self:CancelTimer(self.timer)
        self.timer = nil
    end
    if self.event then
        self:UnregisterEvent(self.event)
        self.event = nil
    end
end


BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local MallPanel = Addon:NewModule(CreateFrame('Frame', nil, ExchangePanel), 'MallPanel', 'AceEvent-3.0', 'AceTimer-3.0', 'AceSerializer-3.0')

function MallPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    ExchangePanel:RegisterPanel(L['兑换列表'], self, 8)

    local CategoryWidget = GUI:GetClass('TitleWidget'):New(self) do
        CategoryWidget:SetPoint('TOPLEFT')
        CategoryWidget:SetPoint('BOTTOMLEFT')
        CategoryWidget:SetWidth(186)
        local bg = CategoryWidget:CreateTexture(nil, 'BACKGROUND')
        bg:SetTexture([[Interface\Store\Store-Main]])
        bg:SetAllPoints(true)
        bg:SetTexCoord(0.00097656, 0.18261719, 0.5898437525, 0.93652344)
    end

    local CategoryList = GUI:GetClass('GridView'):New(CategoryWidget) do
        CategoryList:SetPoint('TOPLEFT', 5, -20)
        CategoryList:SetPoint('BOTTOMLEFT', -5, 20)
        CategoryList:SetWidth(176)
        CategoryList:SetItemClass(Addon:GetClass('MallCategoryItem'))
        CategoryList:SetItemHeight(38)
        CategoryList:SetItemSpacing(2)
        CategoryList:SetSelectMode('RADIO')
        CategoryList:SetItemHighlightWithoutChecked(true)
        CategoryList:SetDescription(L['|cffffffff*战网积分价格|r'])
        CategoryList:SetCallback('OnItemFormatted', function(CategoryList, button, data)
            button:SetText(data.text)
            button:SetIcon(data.coord)
            button:SetNew(data.new)
            button:SetBlue(data.text == TOKEN_FILTER_LABEL)
        end)
        CategoryList:SetCallback('OnSelectChanged', function(CategoryList, index, data)
            self:UpdateWindow()
            self.ItemList:SetItemList(data.item)
            self.ItemList:Refresh()
            if type(data.update) == 'function' then
                data.update()
            end
        end)
    end

    local ItemWidget = GUI:GetClass('TitleWidget'):New(self) do
        ItemWidget:SetPoint('TOPLEFT', CategoryWidget, 'TOPRIGHT', 5, 0)
        ItemWidget:SetPoint('BOTTOMRIGHT', 0, 100)
    end

    local ItemList = GUI:GetClass('GridView'):New(ItemWidget) do
        ItemList:SetPoint('TOPLEFT', 5, -15)
        ItemList:SetSize(1, 1)
        ItemList:SetItemClass(Addon:GetClass('MallItem'))
        ItemList:SetItemWidth(146)
        ItemList:SetItemHeight(209)
        ItemList:SetColumnCount(4)
        ItemList:SetRowCount(1)
        ItemList:SetItemSpacing(2)
        ItemList:SetAutoSize(true)
        ItemList:SetSelectMode('RADIO')
        ItemList:SetItemHighlightWithoutChecked(true)
        ItemList:SetCallback('OnItemFormatted', function(ItemList, button, data)
            button:SetData(data)
        end)
        ItemList:SetCallback('OnItemEnter', function(ItemList, button, data)
            button:SetMagnifier(true)
            self:OpenTooltip(button, data)
        end)
        ItemList:SetCallback('OnItemLeave', function(ItemList, button)
            button:SetMagnifier(false)
            GameTooltip:Hide()
        end)
        ItemList:SetCallback('OnSelectChanged', function(ItemList, index, data)
            self:UpdateWindow(data)
        end)
    end

    local SummaryWidget = GUI:GetClass('TitleWidget'):New(self) do
        SummaryWidget:SetPoint('TOPLEFT', ItemWidget, 'BOTTOMLEFT', 0, -5)
        SummaryWidget:SetPoint('BOTTOMRIGHT')
        SummaryWidget:SetText(L['兑换说明'])
    end

    local MallSummary = GUI:GetClass('SummaryHtml'):New(SummaryWidget) do
        MallSummary:SetPoint('CENTER', 10, -10)
        MallSummary:SetSize(600, 70)
        MallSummary:SetText(L.MallSummary)
    end

    local QueryPointButton = Addon:GetClass('Button'):New(self) do
        QueryPointButton:SetIcon([[INTERFACE\ICONS\INV_MISC_NOTE_02]])
        QueryPointButton:SetPoint('TOPRIGHT', self:GetParent():GetOwner(), 'TOPRIGHT', -130, -30)
        QueryPointButton:SetText(L['查询我的积分'])
        QueryPointButton:SetTooltip(L['查看您当前账号的可用积分'], L['查询间隔120秒'])
        QueryPointButton:Disable()
        QueryPointButton:SetScript('OnClick', function()
            self:QueryPoint()
        end)
    end

    local PurchaseButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        PurchaseButton:SetPoint('BOTTOM', self:GetOwner():GetOwner(), 'BOTTOM', 0, 4)
        PurchaseButton:SetSize(120, 22)
        PurchaseButton:SetText(L['立即兑换'])
        PurchaseButton:Disable()
        PurchaseButton:SetScript('OnClick', function()
            self:Purchase()
        end)
        MagicButton_OnLoad(PurchaseButton)

        local PurchaseButtonFlashFrame = CreateFrame('Frame', nil, PurchaseButton)
        PurchaseButtonFlashFrame:SetAllPoints(true)
        PurchaseButtonFlashFrame:SetAlpha(0)
        local PurchaseButtonFlash = PurchaseButtonFlashFrame:CreateTexture(nil, 'OVERLAY')
        PurchaseButtonFlash:SetTexture([[Interface\Buttons\UI-Panel-Button-Glow]])
        PurchaseButtonFlash:SetBlendMode('ADD')
        PurchaseButtonFlash:SetTexCoord(0, 0.75, 0, 0.609375)
        PurchaseButtonFlash:SetPoint('CENTER')
        PurchaseButtonFlash:SetSize(141, 30)

        local PurchaseButtonFlashAnimGroup = PurchaseButtonFlashFrame:CreateAnimationGroup()
        local anim = PurchaseButtonFlashAnimGroup:CreateAnimation('Alpha')
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
        anim:SetDuration(0.5)
        anim:SetOrder(1)
        local anim = PurchaseButtonFlashAnimGroup:CreateAnimation('Alpha')
        anim:SetFromAlpha(0)
        anim:SetToAlpha(1)
        anim:SetDuration(0.5)
        anim:SetOrder(2)

        PurchaseButton:HookScript('OnEnable', function()
            PurchaseButtonFlashAnimGroup:Play()
        end)
        PurchaseButton:HookScript('OnDisable', function()
            PurchaseButtonFlashAnimGroup:Stop()
        end)
    end


    local HowToGetPoint = Addon:GetClass('Button'):New(self) do
        HowToGetPoint:SetPoint('RIGHT', QueryPointButton, 'RIGHT', -150, 0)
        HowToGetPoint:SetText(L['如何获取积分?'])
        HowToGetPoint:SetIcon([[INTERFACE\ICONS\INV_MISC_NOTE_01]])
        HowToGetPoint:SetScript('OnClick', function()
            GUI:CallUrlDialog('http://reward.battlenet.com.cn/',
                L.HowToGetPoints,
                true)
        end)
    end

    self.ItemList = ItemList
    self.PurchaseButton = PurchaseButton
    self.QueryPointButton = QueryPointButton
    self.CategoryList = CategoryList

    self:RegisterMessage('MEETINGSTONE_MALLQUERY_RESULT', 'QueryResult')
    self:RegisterMessage('MEETINGSTONE_MALLPURCHASE_RESULT', 'PurchaseResult')
    self:RegisterMessage('MEETINGSTONE_MALL_LIST_UPDATED', 'MallDataUpdated')
    self:RegisterMessage('MEETINGSTONE_SERVER_STATUS_UPDATED', function(event, enable)
        self:CancelTimer(self.queryTimeout)
        QueryPointButton:SetEnabled(enable)
    end)

    ExchangePanel:SetCover(true, L.GoodsLoadingSummary)
end

function MallPanel:UpdateWindow(data)
    if data and data.itemId == WOW_TOKEN_ITEM_ID then
        if data.status() then
            local price = data.price()
            local enable = price and GetMoney() >= price
            self.PurchaseButton:SetEnabled(enable)
            self.PurchaseButton:SetText(enable and L['立即兑换'] or ERR_NOT_ENOUGH_GOLD)
            self.PurchaseButton:SetScript('OnClick', data.buyout)
        else
            self.PurchaseButton:Disable()
            self.PurchaseButton:SetText(TOKEN_MARKET_PRICE_NOT_AVAILABLE)
        end
    else
        self.PurchaseButton:SetEnabled(self:GetItem())
        self.PurchaseButton:SetText(L['立即兑换'])
        self.PurchaseButton:SetScript('OnClick', function()
            self:Purchase()
        end)
    end
end

function MallPanel:UnlockQueryButton()
    self.QueryPointButton:Enable()
    self.QueryPointButton:SetText(L['查询我的积分'])
end

function MallPanel:QueryPoint()
    self.QueryPointButton:Disable()
    self.QueryPointButton:SetText(L['查询中，请稍候 ...'])
    self:ScheduleTimer('UnlockQueryButton', 120)
    Logic:MallQueryPoint()
    self.queryTimeout = self:ScheduleTimer('QueryResult', 120, nil, -1)
end

function MallPanel:QueryResult(event, result)
    self.QueryPointButton:SetText(L['查询我的积分'])
    local text = result == -1 and L['积分查询失败：请稍后再试。'] or format(L['您当前可用积分为：%d'], result)
    GUI:CallWarningDialog(text)

    System:Logf(L['兑换平台%s'], text)

    if self.queryTimeout then
        self:CancelTimer(self.queryTimeout)
        self.queryTimeout = nil
    end
end

function MallPanel:OpenTooltip(frame, data)
    if data.tip then
        GameTooltip:SetOwner(frame, 'ANCHOR_RIGHT')
        for i = 1, #data.tip do
            if i == 1 then
                GameTooltip:SetText(data.tip[i], 1, 1, 1)
            elseif i == 2 then
                GameTooltip:AddLine(data.tip[i], 1, 1, 1)
            else
                GameTooltip:AddLine(data.tip[i])
            end
        end
        GameTooltip:Show()
    elseif data.itemId then
        GameTooltip:SetOwner(frame, 'ANCHOR_RIGHT')
        GameTooltip:SetHyperlink('item:'..data.itemId)
        GameTooltip:Show()
    end
end

function MallPanel:GetItem()
    return self.ItemList:GetSelectedItem()
end

function MallPanel:Purchase()
    local item = self:GetItem()
    if not item then
        return
    end

    if item.web then
        GUI:CallUrlDialog(item.web, L.MallOtherGameTip)
        return
    end

    local name = GetItemInfo(item.itemId)
    if not name then
        return
    end

    GUI:CallMessageDialog(format(L['确认消耗 |cff00ff00%d|r 积分购买 |cff00ff00%s|r 吗？'], item.price, name), function(result)
        if result then
            self.PurchaseButton:Disable()
            self:SetCover(true)
            Logic:MallPurchase(item.id, item.price)
        end
    end)
end

function MallPanel:SetCover(enable)
    if enable then
        local item = self:GetItem() or {}
        ExchangePanel:SetCover(true, format(L.MallPurchaseSummary, GetItemInfo(item.itemId), item.price),
            function()
                MallPanel:PurchaseResult(nil, L['操作超时，请|cff00ff00查询积分|r，如果积分|cffff0000已经扣除|r，请留意当前角色游戏邮箱，如果|cff00ff00积分未扣除|r，请稍后再尝试购买。'])
            end)
    else
        ExchangePanel:SetCover(false)
    end
end

function MallPanel:PurchaseResult(event, result, reply)
    local item = self:GetItem()

    if reply then
        if item then
            GUI:CallMessageDialog(result, function(ok)
                if ok then
                    Logic:MallPurchase(item.id, item.price, ok)
                else
                    self:SetCover(false)
                    System:Logf(L['购买失败：用户取消购买商品。'])
                end
            end)
        else
            System:Error(L['购买失败：未选择商品，请重试。'])
            System:Logf(L['购买失败：未选择商品，请重试。'])
        end
    else
        self:SetCover(false)
        System:Error(result)

        if item then
            System:Logf(L['兑换平台购买%s，%s'], GetItemInfo(item.itemId), result)
        end
    end
end

local WOWTOKEN = {
    text = TOKEN_FILTER_LABEL,
    new = true,
    coord = MALL_CATEGORY_ICON_LIST[6],
    update = C_WowTokenPublic.UpdateMarketPrice,
    item = {
        {
            itemId = WOW_TOKEN_ITEM_ID,
            price = C_WowTokenPublic.GetCurrentMarketPrice,
            status = C_WowTokenPublic.GetCommerceSystemStatus,
            buyout = function(button)
                AuctionFrame_LoadUI()
                C_WowTokenPublic.BuyToken()
                button:Disable()
            end,
            update = C_WowTokenPublic.UpdateMarketPrice,
            event = 'TOKEN_MARKET_PRICE_UPDATED',
        },
    },
}

function MallPanel:MallDataUpdated(event, list, isNew)
    -- if type(list) == 'table' then
    --     tinsert(list, WOWTOKEN)
    -- end

    self.CategoryList:SetItemList(list)
    self.CategoryList:SetSelected(1)
    self:SetCover(false)

    if isNew then
        System:Log(L['兑换平台商品列表已更新。'])
    end
end

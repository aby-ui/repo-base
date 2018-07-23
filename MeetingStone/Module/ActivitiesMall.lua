
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

ActivitiesMall = Addon:NewModule(CreateFrame('Frame'), 'ActivitiesMall', 'AceEvent-3.0')

function ActivitiesMall:OnInitialize()
    self:Hide()
    GUI:Embed(self, 'Owner')

    local ItemWidget = GUI:GetClass('TitleWidget'):New(self) do
        ItemWidget:SetPoint('TOPLEFT')
        ItemWidget:SetPoint('TOPRIGHT')
        ItemWidget:SetHeight(220)
    end

    local ItemList = GUI:GetClass('GridView'):New(self) do
        ItemList:SetPoint('TOP', 8, -3)
        ItemList:SetSize(1, 1)
        ItemList:SetAutoSize(true)
        ItemList:SetItemClass(Addon:GetClass('MallItem'))
        ItemList:SetItemWidth(146)
        ItemList:SetItemHeight(209)
        ItemList:SetColumnCount(3)
        ItemList:SetRowCount(1)
        ItemList:SetItemSpacing(5)
        ItemList:SetSelectMode('RADIO')
        ItemList:SetItemHighlightWithoutChecked(true)
        ItemList:SetScrollStep(4)
        ItemList:SetCallback('OnItemFormatted', function(_, button, data)
            button:SetItem(data.itemId)
            button:SetModel(data.model)
            button:SetText(data.name)
            button:SetIcon(data.icon)
            button:SetPrice(data.price, data.originalPrice)
            button:SetStartTime(data.startTime)
            button:SetCurrency([[ |TInterface\ICONS\Racial_Dwarf_FindTreasure:0|t]])
        end)
        ItemList:SetCallback('OnSelectChanged', function(_, index, data)
            local score = Activities:GetScore()
            if not index then
                self.BuyButton:Disable()
                self.BuyButton:SetText(L['立即兑换'])
            elseif not score or score < data.price then
                self.BuyButton:Disable()
                self.BuyButton:SetText(L['点数不足'])
            else
                self.BuyButton:Enable()
                self.BuyButton:SetText(L['立即兑换'])
            end
        end)

        local ScrollBar = CreateFrame('Slider', nil, ItemList) do
            local _ScrollBar = GUI:GetClass('ScrollBar')

            ScrollBar:EnableMouse(false)
            ScrollBar.UpdateButton = _ScrollBar.UpdateButton
            ScrollBar.UpdateShown = nop
            ScrollBar.AtTop = _ScrollBar.AtTop
            ScrollBar.AtBottom = _ScrollBar.AtBottom
            ScrollBar.ScrollToTop = _ScrollBar.ScrollToTop
            ScrollBar.ScrollToBottom = _ScrollBar.ScrollToBottom

            local function buttonOnEnable(self)
                self:GetNormalTexture():SetDesaturated(false)
            end
            local function buttonOnDisable(self)
                self:GetNormalTexture():SetDesaturated(true)
            end
            local function buttonOnClick(self)
                self:GetParent():SetValue(self:GetParent():GetValue()+self.delta)
            end

            local UpButton = CreateFrame('Button', nil, ScrollBar) do
                UpButton:SetPoint('TOPLEFT', ItemWidget, 'TOPLEFT', 15, -15)
                UpButton:SetPoint('BOTTOMLEFT', ItemWidget, 'BOTTOMLEFT', 15, 15)
                UpButton:SetWidth(40)

                local  Normal = UpButton:CreateTexture(nil, 'BACKGROUND', 'HelpPlateArrowDOWN') do
                    SetClampedTextureRotation(Normal, 90)
                    Normal:ClearAllPoints()
                    Normal:SetSize(21, 53)
                    Normal:SetPoint('CENTER')
                end

                local Highlight = UpButton:CreateTexture(nil, 'HIGHLIGHT', 'HelpPlateArrowDOWN') do
                    SetClampedTextureRotation(Highlight, 90)
                    Highlight:ClearAllPoints()
                    Highlight:SetSize(25, 60)
                    Highlight:SetPoint('CENTER')
                    Highlight:SetBlendMode('ADD')
                end

                UpButton:SetNormalTexture(Normal)

                UpButton:SetScript('OnEnable', buttonOnEnable)
                UpButton:SetScript('OnDisable', buttonOnDisable)
                UpButton:SetScript('OnClick', buttonOnClick)
                UpButton.delta = -1
            end

            local DownButton = CreateFrame('Button', nil, ScrollBar) do
                DownButton:SetPoint('TOPRIGHT', ItemWidget, 'TOPRIGHT', -15, -15)
                DownButton:SetPoint('BOTTOMRIGHT', ItemWidget, 'BOTTOMRIGHT', -15, 15)
                DownButton:SetWidth(40)

                local  Normal = DownButton:CreateTexture(nil, 'BACKGROUND', 'HelpPlateArrowDOWN') do
                    SetClampedTextureRotation(Normal, 270)
                    Normal:ClearAllPoints()
                    Normal:SetSize(21, 53)
                    Normal:SetPoint('CENTER')
                end

                local Highlight = DownButton:CreateTexture(nil, 'HIGHLIGHT', 'HelpPlateArrowDOWN') do
                    SetClampedTextureRotation(Highlight, 270)
                    Highlight:ClearAllPoints()
                    Highlight:SetSize(25, 60)
                    Highlight:SetPoint('CENTER')
                    Highlight:SetBlendMode('ADD')
                end

                DownButton:SetNormalTexture(Normal)

                DownButton:SetScript('OnEnable', buttonOnEnable)
                DownButton:SetScript('OnDisable', buttonOnDisable)
                DownButton:SetScript('OnClick', buttonOnClick)
                DownButton.delta = 1
            end

            ScrollBar.ScrollUpButton = UpButton
            ScrollBar.ScrollDownButton = DownButton
            ScrollBar:SetScript('OnValueChanged', _ScrollBar.OnValueChanged)
            ScrollBar:SetScript('OnMinMaxChanged', _ScrollBar.OnMinMaxChanged)

            ItemList.ScrollBar = ScrollBar
            ItemList:SetScript('OnMouseWheel', function(self, delta)
                self.ScrollBar:SetValue(self.ScrollBar:GetValue() - delta)
            end)
        end
    end

    local SummaryWidget = GUI:GetClass('TitleWidget'):New(self) do
        SummaryWidget:SetPoint('TOPLEFT', ItemWidget, 'BOTTOMLEFT', 0, -3)
        SummaryWidget:SetPoint('BOTTOMRIGHT')
        SummaryWidget:SetText(L['兑换说明'])
    end

    local Summary = GUI:GetClass('ScrollSummaryHtml'):New(self) do
        SummaryWidget:SetObject(Summary, 20, 5, 10, 0)
        Summary:SetSpacing('p', 3)
    end

    local BuyButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        BuyButton:SetPoint('BOTTOM', MainPanel, 'BOTTOM', 104, 4)
        BuyButton:SetSize(120, 22)
        BuyButton:SetText(L['立即兑换'])
        BuyButton:Disable()
        BuyButton:SetScript('OnClick', function()
            self:Buy()
        end)
        MagicButton_OnLoad(BuyButton)
    end

    self.BuyButton = BuyButton
    self.ItemList = ItemList
    self.Summary = Summary

    self:SetScript('OnShow', self.OnShow)
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED')
end

function ActivitiesMall:OnShow()
    self.ItemList:SetSelected(nil)
end

function ActivitiesMall:MEETINGSTONE_ACTIVITIES_DATA_UPDATED(_, data)
    if data.noScore then
        return
    end
    self.Summary:SetText(FormatActivitiesSummaryUrl(L.ActivitiesMallSummary, data.url))
    self.ItemList:SetItemList(data.mallList)
    self.ItemList:Refresh()
end

function ActivitiesMall:Buy()
    local item = self.ItemList:GetSelectedItem()
    if not item then
        return
    end

    GUI:CallMessageDialog(
        format(L['确认消耗 |cff00ff00%d|r 活动点数购买 |cff00ff00%s|r 吗？'], item.price, item.name),
        function(result)
            if result then
                Activities:Buy(item.id)
            end
        end)
end

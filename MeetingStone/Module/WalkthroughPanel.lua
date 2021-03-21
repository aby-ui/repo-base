
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local WalkthroughPanel = Addon:NewModule(GUI:GetClass('InTabPanel'):New(MainPanel), 'WalkthroughPanel', 'AceEvent-3.0', 'AceTimer-3.0', 'AceSerializer-3.0')

function WalkthroughPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    MainPanel:RegisterPanel(L['攻略'], self, 0, 70)

    local CategoryWidget = GUI:GetClass('TitleWidget'):New(self) do
        CategoryWidget:SetPoint('TOPLEFT', 5, -5)
        CategoryWidget:SetPoint('BOTTOMLEFT', 0, 5)
        CategoryWidget:SetWidth(200)
    end

    local CategoryList = GUI:GetClass('GridView'):New(CategoryWidget) do
        CategoryList:SetPoint('TOPLEFT', 0, -20)
        CategoryList:SetPoint('BOTTOMRIGHT', 0, 0)
        CategoryList:SetItemClass(Addon:GetClass('WalkthroughModeItem'))
        CategoryList:SetItemHeight(20)
        CategoryList:SetItemSpacing(5)
        CategoryList:SetSelectMode('RADIO')
        CategoryList:SetItemHighlightWithoutChecked(true)
        CategoryList:SetCallback('OnItemFormatted', function(CategoryList, button, data)
            button:SetText(data.title)
            button:SetIcon(data.icon)
        end)
        CategoryList:SetCallback('OnSelectChanged', function(CategoryList, index, data)
            self.SummaryHtml:SetText(format('<html><body>%s</body></html>', data.content))
            self.SummaryHtml.ScrollBar:SetValue(0)
        end)
    end

    local ItemWidget = GUI:GetClass('TitleWidget'):New(self) do
        ItemWidget:SetPoint('TOPLEFT', CategoryWidget, 'TOPRIGHT', 2, 0)
        ItemWidget:SetPoint('BOTTOMRIGHT', -5, 5)
    end

    local SummaryHtml = GUI:GetClass('ScrollSummaryHtml'):New(ItemWidget) do
        SummaryHtml:SetPoint('TOPLEFT', 5, -5)
        SummaryHtml:SetPoint('BOTTOMRIGHT', -5, 5)
    end

    self.CategoryList = CategoryList
    self.SummaryHtml = SummaryHtml

    self:Update()
end

function WalkthroughPanel:Update()
    
    self.CategoryList:SetItemList({
        {title = L.WalkthroughItem1.title, content = L.WalkthroughItem1.content, icon = 3},
        {title = L.WalkthroughItem2.title, content = L.WalkthroughItem2.content, icon = 3},
    })
    self.CategoryList:SetSelected(1)
end

local WalkthroughModeItem = Addon:NewClass('WalkthroughModeItem', GUI:GetClass('ItemButton'))

function WalkthroughModeItem:Constructor()


    local Icon = self:CreateTexture(nil, 'ARTWORK')
    Icon:SetSize(16, 16)
    Icon:SetPoint('LEFT', 5, 0)

    local Text = self:CreateFontString(nil, 'OVERLAY')
    Text:SetPoint('LEFT', Icon, 'RIGHT', 2, 0)
    Text:SetJustifyH('LEFT')
    self:SetFontString(Text)
    
    self:SetCheckedTexture("Interface\\Buttons\\UI-RadioButton")
    local radio = self:GetCheckedTexture()
    radio:SetTexCoord(0.25, 0.5, 0, 1)
    radio:ClearAllPoints()
    radio:SetPoint('LEFT', Text, 'RIGHT', 0, 0)
    radio:SetSize(16, 16)

    self:SetNormalFontObject('GameFontNormalSmall')
    self:SetHighlightFontObject('GameFontHighlightSmall')
    self:SetDisabledFontObject('GameFontDisableSmall')

    self.Text = Text
    self.Icon = Icon
end

function WalkthroughModeItem:SetIcon(id)
    local tex
    if id == 1 then
        tex = [[Interface\GossipFrame\AvailableQuestIcon]]
    elseif id == 2 then
        tex = [[Interface\GossipFrame\AvailableLegendaryQuestIcon]]
    elseif id == 3 then
        tex = [[Interface\GossipFrame\DailyQuestIcon]]
    else
        tex = [[Interface\GossipFrame\DailyActiveQuestIcon]]
    end
    self.Icon:SetTexture(tex)
end

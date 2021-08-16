
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local WalkthroughPanel = Addon:NewModule(GUI:GetClass('InTabPanel'):New(MainPanel), 'WalkthroughPanel', 'AceEvent-3.0', 'AceTimer-3.0', 'AceSerializer-3.0')

function WalkthroughPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')
    MainPanel:RegisterPanel(L['攻略'], self, 0, 70,nil,true)

    local CategoryWidget = GUI:GetClass('TitleWidget'):New(self) do
        CategoryWidget:SetPoint('TOPLEFT', 5, -5)
        CategoryWidget:SetPoint('BOTTOMLEFT', 0, 5)
        CategoryWidget:SetWidth(195)

        CategoryWidget.Bg:SetAtlas("questlogbackground",false)
        
        local backdrop = CreateFrame("Frame",nil, CategoryWidget, "InsetFrameTemplate") do
            backdrop:SetAllPoints(CategoryWidget.Bg)
        end

        local imageTitle = CategoryWidget:CreateTexture(nil, "ARTWORK") do
            imageTitle:SetTexture(894600)
            imageTitle:SetSize(190,36)
            imageTitle:SetTexCoord(5.0/1024,260.0/1024,932.0/1024,991.0/1024)
            imageTitle:SetPoint("TOP",0,-6)
        end

        local txtTitle = CategoryWidget:CreateFontString(nil, "OVERLAY", "GameFontNormalLeft") do
            txtTitle:SetText("攻略")
            txtTitle:SetTextColor(1,174.0/255,0)
            txtTitle:SetPoint("TOPLEFT", 20,-13)
        end
    end

    local CategoryList = GUI:GetClass('GridView'):New(CategoryWidget) do

        CategoryList:SetPoint('TOPLEFT', 0, -40)
        CategoryList:SetPoint('BOTTOMRIGHT', 0, 0)
        CategoryList:SetItemClass(Addon:GetClass('WalkthroughModeItem'))
        CategoryList:SetItemHeight(20)
        CategoryList:SetItemSpacing(5)
        CategoryList:SetSelectMode('RADIO')
        CategoryList:SetItemHighlightWithoutChecked(true)
        CategoryList:SetCallback('OnItemFormatted', function(CategoryList, button, data)
            button:SetNormalFontObject(CategoryList:IsSelected(button:GetID()) and 'GameFontHighlightSmall' or 'GameFontDisableSmall')
            button:SetText(data.title)
            button:SetIcon(data.icon)
        end)
        CategoryList:SetCallback('OnSelectChanged', function(CategoryList, index, data)
            self.SummaryHtml:SetText(format('<html><body>%s</body></html>', data.content))
            self.SummaryHtml.ScrollBar:SetValue(0)
        end)
    end

    local ItemWidget = GUI:GetClass('TitleWidget'):New(self) do
        ItemWidget:SetPoint('TOPLEFT', CategoryWidget, 'TOPRIGHT', 5, 0)
        ItemWidget:SetPoint('BOTTOMRIGHT', -5, 5)
        ItemWidget.Bg:SetAlpha(0)
        local backdrop = CreateFrame("Frame",nil, ItemWidget, "InsetFrameTemplate") do
            backdrop:SetAllPoints(ItemWidget.Bg)
        end
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
        {title = L.WalkthroughItem1.title, content = L.WalkthroughItem1.content, icon = 4},
        {title = L.WalkthroughItem2.title, content = L.WalkthroughItem2.content, icon = 4},
    })
    self.CategoryList:SetSelected(1)
end

local WalkthroughModeItem = Addon:NewClass('WalkthroughModeItem', GUI:GetClass('ItemButton'))

function WalkthroughModeItem:Constructor()

    local Icon = self:CreateTexture(nil, 'ARTWORK')
    Icon:SetSize(16, 16)
    Icon:SetPoint('LEFT', 5, 0)

    local Text = self:CreateFontString(nil, 'OVERLAY',"GameFontHighlight")
    Text:SetPoint('LEFT', Icon, 'RIGHT', 2, 0)
    Text:SetJustifyH('LEFT')
    self:SetFontString(Text)

    
    self:SetCheckedTexture("Interface/QuestFrame/QuestMapLogAtlas")
    local radio = self:GetCheckedTexture()
    -- radio:SetTexCoord(300.0/1024,530.0/1024,770.0/1024,793.0/1024)
    radio:SetAtlas("campaignheader_selectedglow")
    radio:SetSize(260,10)
    radio:ClearAllPoints()
    radio:SetPoint('LEFT', Text, 'BOTTOMLEFT', 0, 0)
    radio:SetPoint('RIGHT', Text, 'BOTTOMRIGHT', 0, 0)
    radio:SetPoint('BOTTOM', Text, 'BOTTOM', 0,-5)

    self:SetNormalFontObject('GameFontDisableSmall')
    self:SetHighlightFontObject('GameFontHighlightSmall')
    self:SetDisabledFontObject('GameFontHighlightSmall')

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
    elseif id == 4 then
        tex = [[Interface\questframe\ui-questlog-bookicon]]
    else
        tex = [[Interface\GossipFrame\DailyActiveQuestIcon]]
    end
    self.Icon:SetTexture(tex)
end

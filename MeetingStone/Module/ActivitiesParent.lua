BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

ActivitiesParent = Addon:NewModule(GUI:GetClass('LeftTabPanel'):New(MainPanel), 'ActivitiesParent', 'AceEvent-3.0',
                                   'AceTimer-3.0')
GUI:Embed(ActivitiesParent, 'Refresh')

function ActivitiesParent:OnInitialize()
    MainPanel:RegisterPanel(L['最新活动'], self)

    local ScoreButton = Addon:GetClass('Button'):New(self)
    do
        ScoreButton:Hide()
        ScoreButton:SetPoint('TOPRIGHT', MainPanel, 'TOPRIGHT', -130, -30)
        ScoreButton:SetText(L['活动点数：'] .. 'NaN')
        ScoreButton:SetIcon([[Interface\ICONS\Racial_Dwarf_FindTreasure]])
        ScoreButton:SetCooldown(SERVER_TIMEOUT)
        ScoreButton:SetTooltip(L['查询活动点数'], L['查询间隔120秒'])
        ScoreButton:SetScript('OnClick', function()
            Activities:QueryPersonInfo()
        end)
        ScoreButton:SetScript('OnShow', function(ScoreButton)
            self.PlayerInfoButton:ClearAllPoints()
            self.PlayerInfoButton:SetPoint('RIGHT', ScoreButton, 'RIGHT', -110, 0)
        end)
        ScoreButton:SetScript('OnHide', function(ScoreButton)
            self.PlayerInfoButton:ClearAllPoints()
            self.PlayerInfoButton:SetPoint('TOPRIGHT', MainPanel, 'TOPRIGHT', -90, -30)
        end)
    end

    local PlayerInfoButton = Addon:GetClass('Button'):New(self)
    do
        PlayerInfoButton:SetPoint('TOPRIGHT', MainPanel, 'TOPRIGHT', -90, -30)
        PlayerInfoButton:SetText(L['联系方式'])
        PlayerInfoButton:SetIcon([[Interface\ICONS\INV_Letter_05]])
        PlayerInfoButton:SetScript('OnClick', function()
            PlayerInfoDialog:Open(L['填写你的联系方式'], L['联系方式'])
        end)
    end

    local Blocker = MainPanel:NewBlocker('ActivitiesWaitConnect', 3)
    do
        Blocker:SetParent(self)
        Blocker:Show()
        Blocker:Hide()
        Blocker.SetText = nop

        Blocker:SetCallback('OnCheck', function()
            if not Activities:IsConnected() or not QuestServies:IsConnected() then
                return true
            elseif not Activities:IsReady() then
                return true
            elseif not Activities:GetScore() then
                return true
            elseif Activities:GetBuyingItem() then
                return true
            end
        end)
        Blocker:SetCallback('OnFormat', function(Blocker)
            if not Activities:IsConnected() or not QuestServies:IsConnected() then
                Blocker:SetText(L['服务器连线中，请稍候'])
            elseif not Activities:IsReady() then
                Blocker:SetText(L['正在获取活动信息，请稍候'])
            elseif not Activities:GetScore() then
                Blocker:SetText(L['正在获取个人信息，请稍候'])
            else
                local item = Activities:GetBuyingItem()
                if item then
                    Blocker:SetText(format(L.ActivitiesBuyingSummary, item.name, item.price))
                end
            end
        end)
        Blocker:SetCallback('OnInit', function(Blocker)
            local Html = GUI:GetClass('SummaryHtml'):New(Blocker)
            do
                Html:SetPoint('CENTER', 0, 20)
                Html:SetSize(500, 40)
            end

            local Text = Blocker:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
            do
                Text:Hide()
                Text:SetWidth(500)
                Text:SetWordWrap(true)
            end

            local Spinner = CreateFrame('Frame', nil, Blocker, 'LoadingSpinnerTemplate')
            do
                Spinner:SetPoint('BOTTOM', Html, 'TOP', 0, 16)
                Spinner.Anim:Play()
            end

            Blocker.SetText = Addon:GetClass('Cover').SetText
            Blocker.Html = Html
            Blocker.Spinner = Spinner
            Blocker.Text = Text
            Blocker.Icon = Spinner
        end)
    end

    MainPanel:FlashTabByPanel(self, true)

    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_BUY_TIMEOUT', 'Refresh')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_BUY_RESULT', 'Refresh')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_BUY_SENDING', 'Refresh')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_QUERY_SENDING')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_QUERY_TIMEOUT', 'OnShow')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_SERVER_CONNECTED', 'OnShow')
    self:RegisterMessage('MEETINGSTONE_QUEST_CONNECTED', 'OnShow')
    self:RegisterMessage('MEETINGSTONE_QUEST_FETCHED')

    self.Blocker = Blocker
    self.ScoreButton = ScoreButton
    self.PlayerInfoButton = PlayerInfoButton
    self:SetScript('OnShow', self.OnShow)

    self.lockPanels = {}
    self.subTitles = {}

    local onChange = self.TabFrame.events.OnSelectChanged
    self.TabFrame:SetCallback('OnSelectChanged', function(t, index, data)
        onChange(t, index, data)

        local subTitle = self.subTitles[data.name]
        if subTitle then
            self.Title:SetText(subTitle)
        end
    end)
end

function ActivitiesParent:Update()
    self.Blocker:Hide()

    if not self:IsVisible() then
        return
    end
    MainPanel:UpdateBlockers()
end

local orig_RegisterPanel = ActivitiesParent.RegisterPanel
function ActivitiesParent:RegisterPanel(name, icon, panel, data)
    if not self:IsPanelRegistered(name) then
        orig_RegisterPanel(self, name, icon, panel, data)

        self.subTitles[name] = nil

        if data then
            if data.lock  then
                tinsert(self.lockPanels, {name = name, icon = icon, panel = panel, data = data})
            end

            self.subTitles[name] = data.subTitle
        end
    end
end

function ActivitiesParent:ClearPanels()
    local lockPanels = self.lockPanels
    self.subTitles = {}
    self.lockPanels = {}

    self:UnregisterAllPanels()

    for _, v in ipairs(lockPanels) do
        self:RegisterPanel(v.name, v.icon, v.panel, v.data)
    end

    self:SelectTab(1)
end

function ActivitiesParent:MEETINGSTONE_QUEST_FETCHED()
    self:ClearPanels()

    if QuestServies:IsActive() then
        local localQuestData = QUEST_GROUP_DATA[QuestServies.questGroup.id]
        if localQuestData then
            self:RegisterPanel(localQuestData.title or L['个人地下城周常'],
                               [[Interface\ICONS\ACHIEVEMENT_GUILDPERK_HONORABLEMENTION_RANK2]], QuestPanel,
                               {before = L['最新活动'], subTitle = localQuestData.subTitle})
            self:SelectPanel(QuestPanel)
        end
    end
end

function ActivitiesParent:MEETINGSTONE_ACTIVITIES_QUERY_SENDING()
    self.ScoreButton:Disable()
    self:Refresh()
end

function ActivitiesParent:OnShow()
    if not self:IsVisible() then
        return
    end
    if Activities:IsConnected() and not Activities:GetPersonInfo() then
        Activities:QueryPersonInfo()
    end
    if QuestServies:IsConnected() then
        QuestServies:QueryQuestList()
    end
    self:Refresh()
    DataCache:GetObject('ActivitiesData'):SetIsNew(false)

    if not self.isFlash then
        MainPanel:FlashTabByPanel(self, false)
        self.isFlash = true
    end
end

function ActivitiesParent:MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE()
    self.ScoreButton:SetShown(Activities:IsActivityHasScore())
    self.ScoreButton:SetText(L['活动点数：'] .. Activities:GetScore())
    self.queryTimer = nil
    self:SetScript('OnShow', self.Refresh)
    self:UnregisterMessage('MEETINGSTONE_ACTIVITIES_QUERY_TIMEOUT')
    self:UnregisterMessage('MEETINGSTONE_SERVER_STATUS_UPDATED')
    self:Refresh()
end

function ActivitiesParent:MEETINGSTONE_ACTIVITIES_DATA_UPDATED(_, data)
    -- if data.tabMall then
    --     if not self:IsPanelRegistered(L['限时秒杀']) then
    --         self:RegisterPanel(L['限时秒杀'], [[Interface\ICONS\SPELL_HOLY_BORROWEDTIME]], ActivitiesMall, 6)
    --     end
    -- else
    --     self:UnregisterPanel(L['限时秒杀'])
    -- end
    -- if data.tabLottery then
    --     if not self:IsPanelRegistered(L['活动抽奖']) then
    --         self:RegisterPanel(L['活动抽奖'], [[Interface\ICONS\INV_Misc_Gift_01]], ActivitiesLottery, 6)
    --     end
    -- else
    --     self:UnregisterPanel(L['活动抽奖'])
    -- end
    self.TabFrame:Refresh()
    self:Refresh()
end

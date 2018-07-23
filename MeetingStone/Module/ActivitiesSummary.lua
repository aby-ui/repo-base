
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

ActivitiesSummary = Addon:NewModule(CreateFrame('Frame'), 'ActivitiesSummary', 'AceEvent-3.0')

function ActivitiesSummary:OnInitialize()
    GUI:Embed(self, 'Owner', 'Refresh')
    ActivitiesParent:RegisterPanel(L['活动简介'], [[Interface\ICONS\ACHIEVEMENT_GUILDPERK_HONORABLEMENTION_RANK2]], self, 6)

    local Banner = CreateFrame('Frame', nil, self) do
        Banner:SetPoint('TOPLEFT')
        Banner:SetPoint('TOPRIGHT')
        Banner:SetHeight(220)
    end

    local Background = Banner:CreateTexture(nil, 'BACKGROUND') do
        Background:SetAllPoints(Banner)
    end

    local Title = Banner:CreateFontString(nil, 'ARTWORK', 'QuestFont_Super_Huge') do
        Title:SetPoint('TOPLEFT', 20, -20)
        Title:SetTextColor(1, 1, 1)
    end

    local Target = Banner:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
        Target:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -30)
    end

    local GiftButton = Addon:GetClass('Button'):New(Banner) do
        GiftButton:SetText(L['每日礼包'])
        GiftButton:SetIcon([[Interface\ICONS\INV_Misc_Gift_02]])
        GiftButton:SetCooldown(SERVER_TIMEOUT)
        GiftButton:Hide()
        GiftButton:SetScript('OnClick', function()
            Activities:SignIn()
            GiftButton:Disable()
        end)
    end

    local MemberButton = Addon:GetClass('Button'):New(Banner) do
        MemberButton:SetText(L['我想了解'])
        MemberButton:SetIcon([[Interface\ICONS\Raf-Icon]])
        MemberButton:Hide()
        MemberButton:SetScript('OnClick', function()
            Activities:SignUp(false, Activities:GetActivitiesId(self.ScrollControl:GetSelected()))
        end)
    end

    local LeaderButton = Addon:GetClass('Button'):New(Banner) do
        LeaderButton:SetText(L['团长申请'])
        LeaderButton:SetIcon([[Interface\ICONS\Spell_Holy_ReviveChampion]])
        LeaderButton:Hide()
        LeaderButton:SetScript('OnClick', function()
            Activities:SignUp(true, Activities:GetActivitiesId(self.ScrollControl:GetSelected()))
        end)
    end

    local SummaryWidget = GUI:GetClass('TitleWidget'):New(self) do
        SummaryWidget:SetPoint('BOTTOMLEFT')
        SummaryWidget:SetPoint('BOTTOMRIGHT')
        SummaryWidget:SetPoint('TOP', Banner, 'BOTTOM', 0, -3)
        SummaryWidget:SetText(L['活动说明'])
    end

    local Summary = GUI:GetClass('ScrollSummaryHtml'):New(SummaryWidget) do
        SummaryWidget:SetObject(Summary, 20, 5, 10, 0)
        Summary:SetSpacing('p', 3)
    end

    local ScrollTimerBar = CreateFrame('StatusBar', nil, Banner) do
        ScrollTimerBar:SetPoint('BOTTOMLEFT')
        ScrollTimerBar:SetPoint('BOTTOMRIGHT')
        ScrollTimerBar:SetHeight(2)
        ScrollTimerBar:SetStatusBarTexture(0, 1, 1, 0.5)
        ScrollTimerBar:SetMinMaxValues(0, 5)
    end

    local ScrollControl = GUI:GetClass('GridView'):New(self) do
        ScrollControl:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, -26)
        ScrollControl:SetSize(16, 16)
        ScrollControl:SetAutoSize(true)
        ScrollControl:SetItemWidth(16)
        ScrollControl:SetItemHeight(16)
        ScrollControl:SetRowCount(1)
        ScrollControl:SetItemSpacing(1)
        ScrollControl:SetSelectMode('RADIO')
        ScrollControl:SetCallback('OnItemCreated', function(ScrollControl, button)
            button:SetNormalTexture([[Interface\COMMON\Indicator-Gray]])
            button:SetCheckedTexture([[Interface\COMMON\Indicator-Green]])
        end)
        ScrollControl:SetCallback('OnSelectChanged', function(ScrollControl, ...)
            self.ScrollTimer.timer = 5
            self:Refresh()
            ScrollTimerBar:SetValue(0)
        end)
    end

    local ScrollTimer = CreateFrame('Frame', nil, self) do
        ScrollTimer:Hide()
        ScrollTimer.timer = 5
        ScrollTimer:SetScript('OnUpdate', function(timer, elapsed)
            if self:IsMouseOver() or ScrollControl:IsMouseOver() then
                return
            end

            timer.timer = ScrollTimer.timer - elapsed
            if timer.timer < 0 then
                timer.timer = 5
                ScrollControl:SetSelected(ScrollControl:GetSelected() % ScrollControl:GetItemCount() + 1)
            end
            ScrollTimerBar:SetValue(5 - timer.timer)
        end)
        ScrollTimer:SetScript('OnHide', function()
            ScrollTimerBar:SetValue(0)
        end)
    end

    self.Title = Title
    self.Target = Target
    self.Summary = Summary
    self.GiftButton = GiftButton
    self.MemberButton = MemberButton
    self.LeaderButton = LeaderButton
    self.Background = Background
    self.ScrollTimer = ScrollTimer
    self.ScrollControl = ScrollControl

    self.buttons = {self.GiftButton, self.MemberButton, self.LeaderButton}

    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE', 'Refresh')
end

function ActivitiesSummary:MEETINGSTONE_ACTIVITIES_DATA_UPDATED(_, data)
    local activityCount = #data.activities
    self.ScrollControl:SetItemList(data.activities)
    self.ScrollControl:SetColumnCount(activityCount)
    self.ScrollControl:SetSelected(1)
    self.ScrollTimer:SetShown(activityCount > 1)
    self:Refresh()
end

function ActivitiesSummary:Update()
    local index = self.ScrollControl:GetSelected()
    local title, subtitle, summary, bg = Activities:GetActivitiesInfo(index)
    if not title then
        return
    end

    self.Title:SetText(title)
    self.Summary:SetText(summary)
    self.Target:SetText(subtitle)
    if tonumber(bg) <= ACTIVITY_BG_COUNT then
        self.Background:SetTexture([[Interface\AddOns\MeetingStone\Media\Activities\]] .. bg)
    else
        self.Background:SetTexture([[Interface\AddOns\MeetingStone\Media\Activities\1]])
    end

    self.GiftButton:SetShown(Activities:CanSignIn(index))
    self.MemberButton:SetShown(Activities:CanMemberSignUp(index))
    self.LeaderButton:SetShown(Activities:CanLeaderSignUp(index))

    local prevButton
    local count = 0
    for i, button in ipairs(self.buttons) do
        if button:IsShown() then
            button:ClearAllPoints()
            if not prevButton then
                button:SetPoint('BOTTOMLEFT', 20, 10)
            else
                button:SetPoint('BOTTOMLEFT', prevButton, 'TOPLEFT', 0, 5)
            end
            prevButton = button
            count = count + 1
        end
    end
    self.Target:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, count < 3 and -30 or -10)
end
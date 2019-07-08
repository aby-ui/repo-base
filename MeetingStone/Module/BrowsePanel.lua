
BuildEnv(...)

BrowsePanel = Addon:NewModule(CreateFrame('Frame'), 'BrowsePanel', 'AceEvent-3.0', 'AceTimer-3.0', 'AceSerializer-3.0', 'AceBucket-3.0')

function BrowsePanel:OnInitialize()
    MainPanel:RegisterPanel(L['查找活动'], self, 5, 100)

    self.filters = {}

    local ActivityList = GUI:GetClass('DataGridView'):New(self) do
        ActivityList:SetAllPoints(self)
        ActivityList:SetItemHighlightWithoutChecked(true)
        ActivityList:SetItemHeight(32)
        ActivityList:SetItemSpacing(1)
        ActivityList:SetItemClass(Addon:GetClass('BrowseItem'))
        ActivityList:SetSelectMode('RADIO')
        ActivityList:SetScrollStep(9)
        ActivityList:SetItemList(LfgService:GetActivityList())
        ActivityList:SetSortHandler(function(activity)
            return activity:BaseSortHandler()
        end)
        ActivityList:RegisterFilter(function(activity, ...)
            return activity:Match(...)
        end)
        ActivityList:InitHeader{
            {
                key = '@',
                text = '@',
                style = 'ICON:20:20',
                width = 30,
                iconHandler = function(activity)
                    if activity:IsUnusable() then
                        return
                    elseif activity:IsSelf() then
                        return [[Interface\AddOns\MeetingStone\Media\Icons]], 0.25, 0.375, 0, 1
                    elseif activity:IsInActivity() then
                        return [[Interface\AddOns\MeetingStone\Media\Icons]], 0.375, 0.5, 0, 1
                    elseif activity:IsApplication() then
                        return [[Interface\AddOns\MeetingStone\Media\Icons]], 0.5, 0.625, 0, 1
                    elseif activity:IsAnyFriend() then
                        return [[Interface\AddOns\MeetingStone\Media\Icons]], 0, 0.125, 0, 1
                    end
                end,
                sortHandler = ActivityList:GetSortHandler(),
            },
            {
                key = 'Title',
                text = L['活动标题'],
                style = 'LEFT',
                width = 170,
                showHandler = function(activity)
                    if activity:IsUnusable() then
                        return activity:GetSummary(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
                    elseif activity:IsAnyFriend() then
                        return activity:GetSummary(), BATTLENET_FONT_COLOR.r, BATTLENET_FONT_COLOR.g, BATTLENET_FONT_COLOR.b
                    else
                        return activity:GetSummary(), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
                    end
                end
            },
            {
                key = 'ActivityName',
                text = L['活动类型'],
                style = 'LEFT',
                width = 170,
                showHandler = function(activity)
                    if activity:IsUnusable() then
                        return activity:GetName(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
                    elseif activity:IsAnyFriend() then
                        return activity:GetName(), BATTLENET_FONT_COLOR.r, BATTLENET_FONT_COLOR.g, BATTLENET_FONT_COLOR.b
                    else
                        return activity:GetName(), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
                    end
                end,
                sortHandler = function(activity)
                    return activity:GetTypeSortValue()
                end,
                formatHandler = function(grid, activity)
                    if activity:IsDelisted() or activity:IsApplication() then
                        grid:GetParent():SetSelectable(false)

                        if activity == ActivityList:GetSelectedItem() then
                            ActivityList:SetSelected(nil)
                        end
                    else
                        grid:GetParent():SetSelectable(true)
                    end
                end
            },
            -- {
            --     key = 'ActivityLoot',
            --     text = L['拾取'],
            --     style = 'LEFT',
            --     width = 50,
            --     showHandler = function(activity)
            --         if activity:IsUnusable() then
            --             return activity:GetLootShortText(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            --         else
            --             return activity:GetLootShortText()
            --         end
            --     end,
            --     sortHandler = function(activity)
            --         return activity:GetLoot()
            --     end
            -- },
            -- {
            --     key = 'ActivityMode',
            --     text = L['形式'],
            --     style = 'LEFT',
            --     width = 50,
            --     showHandler = function(activity)
            --         if activity:IsUnusable() then
            --             return activity:GetModeText(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            --         else
            --             return activity:GetModeText()
            --         end
            --     end,
            --     sortHandler = function(activity)
            --         return activity:GetMode()
            --     end,
            -- },
            {
                key = 'MemberRole',
                text = L['成员'],
                width = 125,
                class = Addon:GetClass('MemberDisplay'),
                formatHandler = function(grid, activity)
                    grid:SetActivity(activity)
                end,
                sortHandler = function(activity)
                    return activity:GetMaxMembers() - activity:GetNumMembers()
                end
            },
            -- {
            --     key = 'Level',
            --     text = L['等级'],
            --     width = 60,
            --     textHandler = function(activity)
            --         local minLevel = activity:GetMinLevel()
            --         local maxLevel = activity:GetMaxLevel()
            --         local isMax = maxLevel >= MAX_PLAYER_LEVEL
            --         local isMin = minLevel <= 1

            --         if isMax and isMin then
            --             return NONE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            --         else
            --             local text = minLevel == maxLevel and minLevel or isMax and '≥' .. minLevel or minLevel .. '-' .. maxLevel
            --             local color = activity:IsUnusable() and GRAY_FONT_COLOR or activity:IsLevelValid() and GREEN_FONT_COLOR or RED_FONT_COLOR
            --             return text, color.r, color.g, color.b
            --         end
            --     end,
            --     sortHandler = function(activity)
            --         return 0xFFFF - activity:GetMinLevel()
            --     end
            -- },
            {
                key = 'ItemLeave',
                text = L['要求'],
                width = 60,
                textHandler = function(activity)
                    if activity:IsArenaActivity() then
                        local pvpRating = activity:GetPvPRating()
                        if pvpRating == 0 then
                            return NONE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
                        else
                            local color = activity:IsUnusable() and GRAY_FONT_COLOR or activity:IsPvPRatingValid() and GREEN_FONT_COLOR or RED_FONT_COLOR
                            return floor(pvpRating), color.r, color.g, color.b
                        end
                    else
                        local itemLevel = activity:GetItemLevel()
                        if itemLevel == 0 then
                            return NONE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
                        else
                            local color = activity:IsUnusable() and GRAY_FONT_COLOR or activity:IsItemLevelValid() and GREEN_FONT_COLOR or RED_FONT_COLOR
                            return floor(itemLevel), color.r, color.g, color.b
                        end
                    end
                end,
                sortHandler = function(activity)
                    return 0xFFFF - activity:GetItemLevel()
                end
            },
            {
                key = 'Leader',
                text = L['团长'],
                style = 'LEFT',
                width = 100,
                showHandler = function(activity)
                    if activity:IsUnusable() then
                        return activity:GetLeaderShort(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
                    else
                        return activity:GetLeaderShortText(), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b
                    end
                end,
            },
            {
                key = 'Summary',
                text = L['说明'],
                width = 170,
                class = Addon:GetClass('SummaryGrid'),
                formatHandler = function(grid, activity)
                    grid:SetActivity(activity)
                end
                -- showHandler = function(activity)
                --     return activity:GetTitle()
                -- end,
            }
        }
        ActivityList:SetHeaderPoint('BOTTOMLEFT', ActivityList, 'TOPLEFT', -2, 2)

        ActivityList:SetCallback('OnItemDecline', function(_, _, activity)
            C_LFGList.CancelApplication(activity:GetID())
        end)
        ActivityList:SetCallback('OnSelectChanged', function(_, _, activity)
            self:UpdateSignUpButton(activity)


        end)
        ActivityList:SetCallback('OnRefresh', function(ActivityList)
            local shownCount = ActivityList:GetShownCount()
            if shownCount > 0 then
                self.NoResultBlocker:SetPoint('TOP', ActivityList:GetButton(shownCount), 'BOTTOM')
            else
                self.NoResultBlocker:SetPoint('TOP')
            end
            self.ActivityTotals:SetFormattedText(L['活动总数：%d/%d'], ActivityList:GetItemCount(), LfgService:GetActivityCount())
        end)
        ActivityList:SetCallback('OnItemEnter', function(_, _, activity)
            MainPanel:OpenActivityTooltip(activity)
        end)
        ActivityList:SetCallback('OnItemLeave', function()
            MainPanel:CloseTooltip()
        end)
        ActivityList:SetCallback('OnItemMenu', function(_, itemButton, activity)
            self:ToggleActivityMenu(itemButton, activity)
        end)
    end

    local SearchingBlocker = CreateFrame('Frame', nil, self) do
        SearchingBlocker:Hide()
        SearchingBlocker:SetAllPoints(self)
        SearchingBlocker:SetScript('OnShow', function()
            ActivityList:GetScrollChild():Hide()
        end)
        SearchingBlocker:SetScript('OnHide', function(SearchingBlocker)
            ActivityList:GetScrollChild():Show()
            SearchingBlocker:Hide()
        end)

        local Spinner = CreateFrame('Frame', nil, SearchingBlocker, 'LoadingSpinnerTemplate') do
            Spinner:SetPoint('CENTER')
            Spinner.Anim:Play()
        end

        local Label = SearchingBlocker:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
            Label:SetPoint('BOTTOM', Spinner, 'TOP')
            Label:SetText(SEARCHING)
        end
    end

    local NoResultBlocker = CreateFrame('Frame', nil, self) do
        NoResultBlocker:SetPoint('BOTTOMLEFT')
        NoResultBlocker:SetPoint('BOTTOMRIGHT')
        NoResultBlocker:SetPoint('TOP')
        NoResultBlocker:Hide()

        local Label = NoResultBlocker:CreateFontString(nil, 'ARTWORK', 'GameFontDisable') do
            Label:SetPoint('CENTER', 0, 20)
        end

        local Button = CreateFrame('Button', nil, NoResultBlocker, 'UIPanelButtonTemplate') do
            Button:SetPoint('CENTER', 0, -20)
            Button:SetSize(120, 22)
            Button:SetText(L['创建活动'])
            Button:SetScript('OnClick', function()
                ToggleCreatePanel(self.ActivityDropdown:GetValue())
            end)
        end

        NoResultBlocker.Label = Label
        NoResultBlocker.Button = Button
    end

    local SignUpButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        GUI:Embed(SignUpButton, 'Tooltip')
        SignUpButton:SetTooltipAnchor('ANCHOR_TOP')
        SignUpButton:SetSize(120, 22)
        SignUpButton:SetPoint('BOTTOM', MainPanel, 'BOTTOM', 0, 4)
        SignUpButton:SetText(L['申请加入'])
        SignUpButton:Disable()
        SignUpButton:SetMotionScriptsWhileDisabled(true)
        SignUpButton:SetScript('OnClick', function()
            self:SignUp(self.ActivityList:GetSelectedItem())
        end)
        SignUpButton:SetScript('OnShow', function()
            self:UpdateSignUpButton(self.ActivityList:GetSelectedItem())
        end)
        MagicButton_OnLoad(SignUpButton)
    end

    local ActivityLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        ActivityLabel:SetPoint('TOPLEFT', MainPanel, 'TOPLEFT', 70, -30)
        ActivityLabel:SetText(L['活动类型'])
    end

    local ActivityDropdown = GUI:GetClass('Dropdown'):New(self) do
        ActivityDropdown:SetPoint('TOPLEFT', ActivityLabel, 'BOTTOMLEFT', 0, -5)
        ActivityDropdown:SetSize(170, 26)
        ActivityDropdown:SetMaxItem(20)
        ActivityDropdown:SetDefaultValue(0)
        ActivityDropdown:SetDefaultText(L['请选择活动类型'])
        ActivityDropdown:SetCallback('OnSelectChanged', function(_, data, ...)
            if not self:InSet() then
                
                if data.activityId then
                    C_LFGList.SetSearchToActivity(data.activityId)
                else
                    C_LFGList.ClearSearchTextFields()
                end
            end
            self:StartSet()
            --self.ActivityDropdown:SetValue(GetActivityCode(nil, nil, data.categoryId))
            self:EndSet()
        end)
    end

    local AdvFilterPanel = CreateFrame('Frame', nil, self, 'SimplePanelTemplate') do
        GUI:Embed(AdvFilterPanel, 'Refresh')
        AdvFilterPanel:SetSize(200, 320)
        AdvFilterPanel:SetPoint('TOPLEFT', MainPanel, 'TOPRIGHT', -2, -30)
        AdvFilterPanel:SetFrameLevel(ActivityList:GetFrameLevel()+5)
        AdvFilterPanel:EnableMouse(true)
        AdvFilterPanel:Hide()

        local closeButton = CreateFrame('Button', nil, AdvFilterPanel, 'UIPanelCloseButton') do
            closeButton:SetPoint('TOPRIGHT', 0, -1)
        end

        local Label = AdvFilterPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal') do
            Label:SetPoint('TOPLEFT', 5, -10)
            Label:SetText(L['高级过滤'])
        end
    end

    local filters = {
        {
            key = 'ItemLevel',
            text = L['装备等级'],
            min = 0,
            max = 500,
            step = 10,
        },
        {
            key = 'BossKilled',
            text = L['Boss击杀数量'],
            min = 0,
            max = 15,
            step = 1,
        },
        {
            key = 'Age',
            text = L['活动创建时长'],
            min = 0,
            max = 1440,
            step = 10,
        },
        {
            key = 'Members',
            text = L['队伍人数'],
            min = 0,
            max = 40,
            step = 1,
        },
    }

    local function RefreshFilter()
        local item = self.ActivityDropdown:GetItem()
        if not self.inUpdateFilters and item and item.categoryId then
            
            Profile:SetFilters(item.categoryId, self:GetFilters())
        end
    end

    for i, v in ipairs(filters) do
        local Box = Addon:GetClass('FilterBox'):New(AdvFilterPanel.Inset)
        Box.Check:SetText(v.text)
        Box.MinBox:SetMinMaxValues(v.min, v.max)
        Box.MaxBox:SetMinMaxValues(v.min, v.max)
        Box.MinBox:SetValueStep(v.step)
        Box.MaxBox:SetValueStep(v.step)
        Box.key = v.key
        Box:SetCallback('OnChanged', RefreshFilter)

        if i == 1 then
            Box:SetPoint('TOPLEFT', 10, -10)
            Box:SetPoint('TOPRIGHT', -10, -10)
        else
            Box:SetPoint('TOPLEFT', self.filters[i-1], 'BOTTOMLEFT')
            Box:SetPoint('TOPRIGHT', self.filters[i-1], 'BOTTOMRIGHT')
        end

        table.insert(self.filters, Box)
    end

    local ResetFilterButton = CreateFrame('Button', nil, AdvFilterPanel, 'UIPanelButtonTemplate') do
        ResetFilterButton:SetSize(80, 22)
        ResetFilterButton:SetPoint('BOTTOMRIGHT', AdvFilterPanel, 'BOTTOM', 0, 3)
        ResetFilterButton:SetText(RESET)
        ResetFilterButton:SetScript('OnClick', function()
            for i, box in ipairs(self.filters) do
                box:Clear()
            end
        end)
    end

    local RefreshFilterButton = CreateFrame('Button', nil, AdvFilterPanel, 'UIPanelButtonTemplate') do
        RefreshFilterButton:SetSize(80, 22)
        RefreshFilterButton:SetPoint('BOTTOMLEFT', AdvFilterPanel, 'BOTTOM', 0, 3)
        RefreshFilterButton:SetText(REFRESH)
        RefreshFilterButton:SetScript('OnClick', function()
            self:DoSearch()
        end)
    end

    local RefreshButton = Addon:GetClass('RefreshButton'):New(self) do
        RefreshButton:SetPoint('TOPRIGHT', MainPanel, 'TOPRIGHT', -90, -38)
        RefreshButton:SetTooltip(LFG_LIST_SEARCH_AGAIN)
        RefreshButton:SetScript('OnClick', function()
            self:DoSearch()
        end)
        RefreshButton:HookScript('OnEnable', function(RefreshButton)
            RefreshButton:SetScript('OnUpdate', nil)
            RefreshButton:SetText(REFRESH)
        end)
        RefreshButton:HookScript('OnDisable', function(RefreshButton)
            RefreshButton:SetScript('OnUpdate', RefreshButton.OnUpdate)
        end)
        RefreshButton.OnUpdate = function(RefreshButton, elasped)
            RefreshButton:SetText(format(D_SECONDS, ceil(self:TimeLeft(self.disableRefreshTimer))))
        end
    end

    local AdvButton = CreateFrame('Button', nil, self, 'UIMenuButtonStretchTemplate') do
        GUI:Embed(AdvButton, 'Tooltip')
        AdvButton:SetTooltipAnchor('ANCHOR_RIGHT')
        AdvButton:SetTooltip(L['高级过滤'])
        AdvButton:SetSize(83, 31)
        AdvButton:SetPoint('LEFT', RefreshButton, 'RIGHT', 0, 0)
        AdvButton:SetText(L['高级过滤'])
        AdvButton:SetNormalFontObject('GameFontNormal')
        AdvButton:SetHighlightFontObject('GameFontHighlight')
        AdvButton:SetDisabledFontObject('GameFontDisable')

        if Profile:IsProfileKeyNew('advShine', 60200.09) then
            local Shine = GUI:GetClass('ShineWidget'):New(AdvButton) do
                Shine:SetPoint('TOPLEFT', 5, -5)
                Shine:SetPoint('BOTTOMRIGHT', -5, 5)
                Shine:Start()
            end
            AdvButton.Shine = Shine
            AdvButton:SetScript('OnClick', function()
                Profile:ClearProfileKeyNew('advShine')
                Shine:Stop()
                Shine:Hide()
                AdvButton:SetScript('OnClick', function()
                    self.AdvFilterPanel:SetShown(not self.AdvFilterPanel:IsShown())
                end)
                AdvButton:GetScript('OnClick')(AdvButton)
            end)
        else
            AdvButton:SetScript('OnClick', function()
                self.AdvFilterPanel:SetShown(not self.AdvFilterPanel:IsShown())
            end)
        end

    end

    local ActivityTotals = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightRight') do
        ActivityTotals:SetPoint('BOTTOMRIGHT', MainPanel, -7, 7)
        ActivityTotals:SetFormattedText(L['活动总数：%d/%d'], 0, 0)
    end

    local IconSummary = CreateFrame('Button', nil, self) do
        IconSummary:SetSize(50, 20)
        IconSummary:SetPoint('BOTTOMLEFT', MainPanel, 10, 5)

        local icon = IconSummary:CreateTexture(nil, 'OVERLAY') do
            icon:SetSize(20, 20)
            icon:SetPoint('LEFT')
            icon:SetTexture([[Interface\AddOns\MeetingStone\Media\Icons]])
            icon:SetTexCoord(0, 32/256, 0, 1)
        end

        local label = IconSummary:CreateFontString(nil, 'OVERLAY') do
            label:SetPoint('LEFT', icon, 'RIGHT', 2, 0)
        end

        IconSummary:SetFontString(label)
        IconSummary:SetNormalFontObject('GameFontHighlightSmall')
        IconSummary:SetHighlightFontObject('GameFontNormalSmall')
        IconSummary:SetText(L['图示'])
        IconSummary:SetScript('OnEnter', function(button)
            GameTooltip:SetOwner(button, 'ANCHOR_RIGHT')
            GameTooltip:SetText(L['图示'])
            GameTooltip:AddLine(format([[|TInterface\AddOns\MeetingStone\Media\Icons:20:20:0:0:256:32:64:96:0:32|t %s]], L['我的活动']), 1, 1, 1)
            GameTooltip:AddLine(format([[|TInterface\AddOns\MeetingStone\Media\Icons:20:20:0:0:256:32:96:128:0:32|t %s]], L['已加入活动']), 1, 1, 1)
            GameTooltip:AddLine(format([[|TInterface\AddOns\MeetingStone\Media\Icons:20:20:0:0:256:32:128:160:0:32|t %s]], L['申请中活动']), 1, 1, 1)
            GameTooltip:AddLine(format([[|TInterface\AddOns\MeetingStone\Media\Icons:20:20:0:0:256:32:0:32:0:32|t %s]], L['好友或公会成员参与的活动']), 1, 1, 1)
            GameTooltip:Show()
        end)
        IconSummary:SetScript('OnLeave', GameTooltip_Hide)
    end

    local FilterButton
    if not NO_SCAN_WORD then
        FilterButton = CreateFrame('Button', nil, self) do
            FilterButton:SetNormalFontObject('GameFontNormalSmall')
            FilterButton:SetHighlightFontObject('GameFontHighlightSmall')
            FilterButton:SetSize(70, 22)
            FilterButton:SetPoint('BOTTOMRIGHT', MainPanel, -140, 3)
            FilterButton:SetText(L['过滤器'])
            FilterButton:RegisterForClicks('anyUp')
            FilterButton:SetScript('OnClick', function()
                self:OnFilterButtonClicked()
            end)
        end
    end

    -- local HelpPlate = {
    --     FramePos = { x = -10,          y = 85 },
    --     FrameSize = { width = 1030, height = 425 },
    --     {
    --         ButtonPos = { x = 330,   y = -5 },
    --         HighLightBox = { x = 60, y = -5, width = 640, height = 55 },
    --         ToolTipDir = 'DOWN',
    --         ToolTipText = L.BrowseHelpFilter,
    --     },  -- 过滤器
    --     {
    --         ButtonPos = { x = 715, y = -5 },
    --         HighLightBox = { x = 705, y = -5, width = 120, height = 55 },
    --         ToolTipDir = 'DOWN',
    --         ToolTipText = L.BrowseHelpRefresh,
    --     },  -- 刷新
    --     {
    --         ButtonPos = { x = 370,  y = -190 },
    --         HighLightBox = { x = 5, y = -65, width = 820, height = 328 },
    --         ToolTipDir = 'RIGHT',
    --         ToolTipText = L.BrowseHelpList,
    --     },  -- 活动列表
    --     {
    --         ButtonPos = { x = 180,  y = -389 },
    --         HighLightBox = { x = 5, y = -397, width = 220, height = 28 },
    --         ToolTipDir = 'UP',
    --         ToolTipText = L.BrowseHelpMisc,
    --     },  --
    --     {
    --         ButtonPos = { x = 300,  y = -389 },
    --         HighLightBox = { x = 300, y = -397, width = 200, height = 28 },
    --         ToolTipDir = 'UP',
    --         ToolTipText = L.BrowseHelpApply,
    --     },  -- 申请
    --     {
    --         ButtonPos = { x = 720,  y = -389 },
    --         HighLightBox = { x = 705, y = -397, width = 120, height = 28 },
    --         ToolTipDir = 'UP',
    --         ToolTipText = L.BrowseHelpStatus,
    --     },  -- 状态
    --     {
    --         ButtonPos = { x = 570,  y = -389 },
    --         HighLightBox = { x = 570, y = -397, width = 130, height = 28 },
    --         ToolTipDir = 'UP',
    --         ToolTipText = L.BrowseHelpSpamWord,
    --     },  -- 关键字
    --     {
    --         ButtonPos = { x = 900, y = -45 },
    --         HighLightBox = { x = 830, y = -15, width = 200, height = 240 },
    --         ToolTipDir = 'DOWN',
    --         ToolTipText = L.BrowseHelpBossFilter,
    --     },
    --     {
    --         ButtonPos = { x = 900, y = -290 },
    --         HighLightBox = { x = 830, y = -260, width = 200, height = 90 },
    --         ToolTipDir = 'DOWN',
    --         ToolTipText = L.BrowseHelpSearchProfile,
    --     }
    -- }

    -- MainPanel:AddHelpButton(self, HelpPlate, function(shown)
    --     if shown then
    --         self.AdvFilterPanel:Show()
    --     end
    -- end)

    local SearchBox = LFGListFrame.SearchPanel.SearchBox

    local AutoCompleteFrame = GUI:GetClass('AutoCompleteFrame'):New(self) do
        AutoCompleteFrame:Hide()
        AutoCompleteFrame:SetPoint('TOPLEFT', SearchBox, 'BOTTOMLEFT', 5, 0)
        AutoCompleteFrame:SetPoint('TOPRIGHT', SearchBox, 'BOTTOMRIGHT', -10, 0)
        AutoCompleteFrame:SetHeight(1)
        AutoCompleteFrame:SetColumnCount(1)
        AutoCompleteFrame:SetRowCount(10)
        AutoCompleteFrame:SetScrollStep(9)
        AutoCompleteFrame:SetSelectMode('RADIO')
        AutoCompleteFrame:SetCallback('OnItemFormatted', function(_, button, item)
            button:SetText(item.name)
        end)
        AutoCompleteFrame:SetCallback('OnItemClick', function(AutoCompleteFrame, _, item)

            self.ActivityDropdown:SetValue(item.code)
            self.SearchBox:ClearFocus()
        end)
        AutoCompleteFrame:SetFrameLevel(self:GetFrameLevel() + 50)
    end

    self.AutoCompleteFrame     = AutoCompleteFrame
    self.ActivityList          = ActivityList
    self.ActivityDropdown      = ActivityDropdown
    self.SignUpButton          = SignUpButton
    self.SearchingBlocker      = SearchingBlocker
    self.NoResultBlocker       = NoResultBlocker
    self.SearchInput           = SearchInput
    self.ActivityTotals        = ActivityTotals
    self.RefreshButton         = RefreshButton
    self.AdvFilterPanel        = AdvFilterPanel
    self.AdvButton             = AdvButton
    self.FilterButton          = FilterButton
    self.SearchProfileDropdown = SearchProfileDropdown
    self.DeleteButton          = DeleteButton
    self.SearchBox             = SearchBox
    self.RefreshFilterButton   = RefreshFilterButton
    self.ResetFilterButton     = ResetFilterButton

    self:RegisterEvent('LFG_LIST_AVAILABILITY_UPDATE')

    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_RESULT_RECEIVED')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_RESULT_UPDATED')

    self:RegisterMessage('MEETINGSTONE_SETTING_CHANGED_packedPvp', 'LFG_LIST_AVAILABILITY_UPDATE')

    self:RegisterMessage('MEETINGSTONE_FILTERS_UPDATE', 'UpdateFilters')

    self:RegisterMessage('MEETINGSTONE_OPEN')

    self:SetScript('OnShow', self.OnShow)

    self.SearchBox:SetScript('OnEnterPressed', function(SearchBox)
        local item = self.AutoCompleteFrame:IsShown() and self.AutoCompleteFrame:GetSelectedItem()
        if item then
            self.ActivityDropdown:SetValue(item.code)
        else
            self:DoSearch()
        end
        SearchBox:ClearFocus()
    end)
    self.SearchBox:SetScript('OnTextChanged', function(SearchBox)
        SearchBoxTemplate_OnTextChanged(SearchBox)

        local text = SearchBox:GetText():trim()
        local list = text ~= '' and SearchBox:HasFocus() and C_LFGList.GetAvailableActivities(nil, nil, nil, text)
        if not list or #list == 0 then
            self.AutoCompleteFrame:Hide()
        else
            for i, v in ipairs(list) do
                list[i] = GetAutoCompleteItem(v)
            end
            table.sort(list, function(lhs, rhs)
                return lhs.order < rhs.order
            end)
            self.AutoCompleteFrame:SetItemList(list)
            self.AutoCompleteFrame:Refresh()
            self.AutoCompleteFrame:Show()
        end
    end)
    self.SearchBox:SetScript('OnEditFocusGained', function(SearchBox)
        SearchBox:GetScript('OnTextChanged')(SearchBox, true)
    end)
    self.SearchBox:SetScript('OnEditFocusLost', function()
        self.AutoCompleteFrame:Hide()
    end)
    self.SearchBox:SetScript('OnArrowPressed', function(SearchBox, key)
        if not self.AutoCompleteFrame:IsShown() then
            return
        end
        local delta = key == 'UP' and -1 or 1
        local index = self.AutoCompleteFrame:GetSelected()
        local count = self.AutoCompleteFrame:GetItemCount()

        if not index then
            index = delta == 1 and 1 or count
        else
            index = (index + delta - 1) % count + 1
        end

        local offset = self.AutoCompleteFrame:GetOffset()
        local maxCount = self.AutoCompleteFrame:GetMaxCount()

        if index < offset then
            offset = index
        elseif index >= offset + maxCount then
            offset = index - maxCount + 1
        end

        self.AutoCompleteFrame:SetOffset(offset)
        self.AutoCompleteFrame:SetSelected(index)
    end)

    self.SearchBox.clearButton:SetScript('OnClick', function(btn)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        C_LFGList.ClearSearchTextFields()
        btn:GetParent():ClearFocus()
        self:DoSearch()
    end)

    LFGListFrame.SearchPanel.AutoCompleteFrame:Hide()

    -- LFGListApplicationDialog.SignUpButton:SetScript('OnClick', function(self)
    --     local dialog = self:GetParent()
    --     PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 'igMainMenuOptionCheckBoxOn')
    --     local id = dialog.resultID
    --     local comment = format('%s%s', dialog.Description.EditBox:GetText(), dialog.playerData or '')
    --     local tank = dialog.TankButton:IsShown() and dialog.TankButton.CheckButton:GetChecked()
    --     local healer = dialog.HealerButton:IsShown() and dialog.HealerButton.CheckButton:GetChecked()
    --     local damager = dialog.DamagerButton:IsShown() and dialog.DamagerButton.CheckButton:GetChecked()

    --     C_LFGList.ApplyToGroup(id, comment, tank, healer, damager)
    --     if dialog.playerData then
    --         Logic:SEJ(dialog.activityData, dialog.Description.EditBox:GetText(), tank, healer, damager, dialog.isBlizzard)
    --     end
    --     StaticPopupSpecial_Hide(dialog)
    -- end)

    -- LFGListApplicationDialog:HookScript('OnHide', function(self)
    --     self.isBlizzard = nil
    --     self.playerData = nil
    --     self.activityData = nil
    --     self.Description.EditBox:SetMaxLetters(60)
    -- end)

end

function BrowsePanel:OnShow()
    -- self.AutoCompleteFrame:SetParent(self)
    -- self.AutoCompleteFrame:SetFrameLevel(self:GetFrameLevel() + 100)

    self.SearchBox:ClearAllPoints()
    self.SearchBox:SetParent(self)
    self.SearchBox:SetPoint('LEFT', self.ActivityDropdown, 'RIGHT', 20, 0)
    self.SearchBox:SetWidth(220)

end

function BrowsePanel:OnEnable()
    self:UpdateFilters()
end

function BrowsePanel:LFG_LIST_AVAILABILITY_UPDATE()
    self.ActivityDropdown:SetMenuTable(GetActivitesMenuTable(ACTIVITY_FILTER_BROWSE))
    self.ActivityDropdown:SetValue(Profile:GetLastSearchCode())
    -- self:Refresh()
end

function BrowsePanel:MEETINGSTONE_ACTIVITIES_RESULT_UPDATED()
    self.ActivityList:Refresh()
end

function BrowsePanel:MEETINGSTONE_ACTIVITIES_RESULT_RECEIVED(event, isFailed)
    self.lastReceived = time()
    self.SearchingBlocker:Hide()

    local resultCount = LfgService:GetActivityCount()

    self.NoResultBlocker:SetShown(resultCount == 0)
    self.NoResultBlocker.Label:SetText(isFailed and [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:30|t  ]] .. LFG_LIST_SEARCH_FAILED or LFG_LIST_NO_RESULTS_FOUND)
    self.NoResultBlocker.Button:SetShown(not isFailed)
    self.ActivityList:Refresh()
end

function BrowsePanel:CheckSignUpStatus(activity, noCheckActivity)
    local numApplications, numActiveApplications = C_LFGList.GetNumApplications()
    local messageApply = LFGListUtil_GetActiveQueueMessage(true)
    local availTank, availHealer, availDPS = C_LFGList.GetAvailableRoles()
    if messageApply then
        return false, messageApply
    elseif not LFGListUtil_IsAppEmpowered() then
        return false, LFG_LIST_APP_UNEMPOWERED
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) and C_LFGList.IsCurrentlyApplying() then
        return false, LFG_LIST_APP_CURRENTLY_APPLYING
    elseif numActiveApplications >= MAX_LFG_LIST_APPLICATIONS then
        return false, string.format(LFG_LIST_HIT_MAX_APPLICATIONS, MAX_LFG_LIST_APPLICATIONS)
    elseif GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > MAX_PARTY_MEMBERS + 1 then
        return false, LFG_LIST_MAX_MEMBERS
    elseif not (availTank or availHealer or availDPS) then
        return false, LFG_LIST_MUST_CHOOSE_SPEC
    elseif GroupHasOfflineMember(LE_PARTY_CATEGORY_HOME) then
        return false, LFG_LIST_OFFLINE_MEMBER
    elseif activity or noCheckActivity then
        return true, nil
    else
        return false, LFG_LIST_SELECT_A_SEARCH_RESULT
    end
end

function BrowsePanel:UpdateSignUpButton(activity)
    local usable, reason = self:CheckSignUpStatus(activity)

    self.SignUpButton:SetEnabled(usable)
    self.SignUpButton:SetTooltip(reason)
end

function BrowsePanel:SignUp(activity)
    if activity then
        LFGListApplicationDialog_Show(LFGListApplicationDialog, activity:GetID())
    end
end

function BrowsePanel:DoSearch()
    self.SearchingBlocker:Show()
    self.NoResultBlocker:Hide()
    self.RefreshButton:Disable()
    self.RefreshFilterButton:Disable()
    self:Search()
    self:CancelTimer(self.disableRefreshTimer)
    self.disableRefreshTimer = self:ScheduleTimer('OnRefreshTimer', 3)
end

function BrowsePanel:Search()
    if self:InSet() then
        return
    end
    if self.searchedInFrame then
        return
    end
    local activityItem = self.ActivityDropdown:GetItem()
    if not activityItem then
        return
    end

    local categoryId = activityItem.categoryId
    local baseFilter = activityItem.baseFilter
    local searchCode = activityItem.value
    local activityId = activityItem.activityId

    if not categoryId or not MainPanel:IsVisible() then
        return
    end

    if self.SearchBox:GetText() ~= activityItem.fullName then
        activityId = nil
    end

    Profile:SetLastSearchCode(searchCode)
    LfgService:Search(categoryId, baseFilter, activityId)
    self:UpdateFilters()

    self.searchTimer = nil
    self.searchedInFrame = true

    C_Timer.After(0, function()
        self.searchedInFrame = nil
    end)
end

function BrowsePanel:UpdateFilters()
    local item = self.ActivityDropdown:GetItem()
    if not item or not item.categoryId then
        return
    end

    self.inUpdateFilters = true

    local filters = Profile:GetFilters(item.categoryId)

    for _, box in ipairs(self.filters) do
        local key = box.key
        local filter = filters[key] or {}

        box.MinBox:SetText(filter.min or '')
        box.MaxBox:SetText(filter.max or '')
        box.Check:SetChecked(filter.enable)
    end

    self.ActivityList:SetFilterText(filters)

    C_Timer.After(0, function()
        self.inUpdateFilters = false
    end)
end

function BrowsePanel:GetSearchCode(fullName, mode, loot, customId)
    if loot == 0 then
        loot = nil
    end
    if mode == 0 then
        mode = nil
    end
    if customId == 0 then
        customId = nil
    end
    if fullName and fullName:trim() == '' then
        fullName = nil
    end
    loot = loot and rawget(ACTIVITY_LOOT_LONG_NAMES, loot)
    mode = mode and rawget(ACTIVITY_MODE_NAMES, mode)

    return format('%s %s %s',
        fullName and format('%s%s', customId and '-' or '', fullName) or '',
        loot and format('-%s-', loot) or '',
        mode and format('-%s-', mode) or ''
    )
end

function BrowsePanel:OnRefreshTimer()
    self.RefreshButton:Enable()
    self.RefreshFilterButton:Enable()
end

function BrowsePanel:OnFilterButtonClicked()
    GUI:ToggleMenu(self.FilterButton, {
        {
            text = L['关键字过滤'],
            checkable = true,
            isNotRadio = true,
            keepShownOnClick = true,
            checked = function()
                return Profile:GetSetting('spamWord')
            end,
            func = function(_, _, _, checked)
                Profile:SetSetting('spamWord', checked)
            end,
        },
        {
            text = L['活动说明字数过滤'],
            checkable = true,
            isNotRadio = true,
            keepShownOnClick = true,
            checked = function()
                return Profile:GetSetting('spamLengthEnabled')
            end,
            func = function(_, _, _, checked)
                Profile:SetSetting('spamLengthEnabled', checked)
            end
        },
        {
            text = CANCEL
        }
    })
end

function BrowsePanel:ToggleActivityMenu(anchor, activity)
    local usable, reason = self:CheckSignUpStatus(activity)

    GUI:ToggleMenu(anchor, {
        {
            text = activity:GetName(),
            isTitle = true,
            notCheckable = true,
        },
        {
            text = L['申请加入'],
            func = function() self:SignUp(activity) end,
            disabled = not usable or activity:IsDelisted() or activity:IsApplication(),
            tooltipTitle = not (activity:IsDelisted() or activity:IsApplication()) and L['申请加入'],
            tooltipText = reason,
            tooltipWhileDisabled = true,
            tooltipOnButton = true,
        },
        {
            text = WHISPER_LEADER,
            func = function() ChatFrame_SendTell(activity:GetLeader()) end,
            disabled = not activity:GetLeader(),-- or not activity:IsApplication(),
            tooltipTitle = not activity:IsApplication() and WHISPER,
            tooltipText = not activity:IsApplication() and LFG_LIST_MUST_SIGN_UP_TO_WHISPER,
            tooltipOnButton = true,
            tooltipWhileDisabled = true,
        },
        {
            text = LFG_LIST_REPORT_GROUP_FOR,
            hasArrow = true,
            menuTable = {
                {
                    text = L['不当的说明'],
                    func = function() C_LFGList.ReportSearchResult(activity:GetID(), activity:IsMeetingStone() and 'lfglistcomment' or 'lfglistname') end,
                },
                {
                    text = LFG_LIST_BAD_DESCRIPTION,
                    func = function() C_LFGList.ReportSearchResult(activity:GetID(), 'lfglistcomment') end,
                    disabled = activity:IsMeetingStone() or not activity:GetComment(),
                },
                {
                    text = LFG_LIST_BAD_VOICE_CHAT_COMMENT,
                    func = function() C_LFGList.ReportSearchResult(activity:GetID(), 'lfglistvoicechat') end,
                    disabled = not activity:GetVoiceChat(),
                },
                {
                    text = LFG_LIST_BAD_LEADER_NAME,
                    func = function() C_LFGList.ReportSearchResult(activity:GetID(), 'badplayername') end,
                    disabled = not activity:GetLeader()
                },
            },
        },
        {
            text = L['加入关键字过滤'],
            func = function()
                SettingPanel:AddSpamWord(activity:GetSummary() or activity:GetComment())
            end,
        },
        {
            text = CANCEL,
        },
    }, 'cursor')
end

function BrowsePanel:GetCurrentActivity()
    return self.ActivityDropdown:GetItem()
end

function BrowsePanel:MEETINGSTONE_OPEN()
    if not LfgService:IsDirty() and self.lastReceived and time() - self.lastReceived < 300 then
        return
    end
    self:DoSearch()
end

local function tooltipMore(tip, data)
    local function color(value)
        if value == true then
            return GREEN_FONT_COLOR
        elseif value == false then
            return RED_FONT_COLOR
        else
            return GRAY_FONT_COLOR
        end
    end

    tip:AddSepatator()
    tip:AddLine(format(L['活动类型：|cffffffff%s|r'], data.name))
    tip:AddLine(format(L['活动形式：|cffffffff%s|r'], GetModeName(data.mode)))
    tip:AddLine(format(L['拾取方式：|cffffffff%s|r'], GetLootName(data.loot)))
end

function BrowsePanel:GetSearchProfileMenuTable()
    local menuTable = {}
    for name, v in Profile:IterateSearchProfiles() do
        tinsert(menuTable, {
            value = name,
            text = name,
            name = v.name,
            code = v.code,
            mode = v.mode,
            loot = v.loot,
            activityId = v.activityId,
            customId = v.customId,
            tooltipOnButton = true,
            tooltipTitle = name,
            tooltipMore = tooltipMore,
            checked = function(data)
                return self.SearchProfileDropdown:GetItem() == data
            end,
            checkable = true,
        })
    end
    sort(menuTable, function(a, b)
        return a.text < b.text
    end)
    return menuTable
end

function BrowsePanel:SaveSearchProfile()
    local activityItem = self.ActivityDropdown:GetItem()
    local profile = {
        code = activityItem.value,
        name = activityItem.text,
        activityId = activityItem.activityId,
        customId = activityItem.customId,
    }

    GUI:CallInputDialog(
        L['请输入搜索配置名称：'],
        function(result, name)
            if not result then
                return
            end
            if not Profile:GetSearchProfile(name) then
                Profile:AddSearchProfile(name, profile)
            else
                System:Errorf(L['搜索配置“%s”已存在。'], name)
            end
        end,
        self,
        format('%s %s %s', activityItem.text, GetLootName(profile.loot), GetModeName(profile.mode)),
        255,
        250
    )
end

function BrowsePanel:StartSet()
    self.inSet = true
end

function BrowsePanel:EndSet()
    self.inSet = nil
    self:DoSearch()
end

function BrowsePanel:InSet()
    return self.inSet
end

function BrowsePanel:QuickSearch(activityCode, mode, loot, searchText)
    self:StartSet()
    Profile:SetLastSearchCode(activityCode)
    self.ActivityDropdown:SetValue(activityCode)
    if not NO_SCAN_WORD then
        self.SearchInput:SetText(searchText or '')
    end
    self:EndSet()
end

function BrowsePanel:GetFilters()
    local filters = {}
    for _, box in ipairs(self.filters) do
        filters[box.key] = {
            min = box.MinBox:GetNumber(),
            max = box.MaxBox:GetNumber(),
            enable = not not box.Check:GetChecked(),
        }
    end
    return filters
end

_G.MeetingStone_BrowsePanel = BrowsePanel

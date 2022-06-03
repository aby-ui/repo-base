
BuildEnv(...)

CreatePanel = Addon:NewModule(CreateFrame('Frame', nil, ManagerPanel), 'CreatePanel', 'AceEvent-3.0')

function CreatePanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    self:SetPoint('TOPLEFT')
    self:SetPoint('BOTTOMLEFT')
    self:SetWidth(219)

    local line = GUI:GetClass('VerticalLine'):New(self) do
        line:SetPoint('TOPLEFT', self, 'TOPRIGHT', -3, 5)
        line:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT', -3, -5)
    end
    -- view board
    local ViewBoardWidget = CreateFrame('Frame', nil, self) do
        ViewBoardWidget:SetAllPoints(true)
        ViewBoardWidget:Hide()
        ViewBoardWidget:SetScript('OnShow', function()
            self:UpdateActivityView()
        end)
    end

    --- frames
    local InfoWidget = CreateFrame('Frame', nil, ViewBoardWidget) do
        InfoWidget:SetPoint('TOPLEFT')
        InfoWidget:SetSize(219, 120)

        local bg = InfoWidget:CreateTexture(nil, 'BACKGROUND', nil, 1)
        bg:SetPoint('TOPLEFT', -2, 2)
        bg:SetPoint('BOTTOMRIGHT', 2, 2)

        local icon = InfoWidget:CreateTexture(nil, 'ARTWORK')
        icon:SetTexture([[INTERFACE\GROUPFRAME\UI-GROUP-MAINTANKICON]])
        icon:SetPoint('TOPLEFT', 10, -8)
        icon:SetSize(16, 16)

        local title = InfoWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLargeLeft')
        title:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 3, 0)
        title:SetPoint('RIGHT', -10, 0)

        local summary = CreateFrame('Frame', nil, InfoWidget)
        summary:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', -5, -3)
        summary:SetPoint('RIGHT', -5, 0)
        summary:SetPoint('BOTTOM', 0, 26)
        summary:EnableMouse(true)
        local summaryLabel = summary:CreateFontString(nil, 'OVERLAY', 'GameFontDisableSmallLeft')
        summaryLabel:SetAllPoints(summary)
        summaryLabel:SetJustifyV('TOP')
        summary:SetScript('OnEnter', function(summary)
            if (summaryLabel:GetStringWidth() or 0) > summaryLabel:GetWidth() then
                GameTooltip:SetOwner(summary, 'ANCHOR_RIGHT')
                GameTooltip:SetText(title:GetText() or '')
                GameTooltip:AddLine(summaryLabel:GetText() or '', GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
                GameTooltip:Show()
            end
        end)
        summary:SetScript('OnLeave', GameTooltip_Hide)

        local privateGroupLabel = InfoWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft') do
            privateGroupLabel:SetPoint('TOPLEFT', summary, 'BOTTOMLEFT', -10, -4)
            privateGroupLabel:SetText(L['仅战网好友和公会成员可见'])
            privateGroupLabel:SetTextColor(0.51, 0.77, 1)
        end

        local mode = InfoWidget:CreateTexture(nil, 'ARTWORK')
        mode:SetTexture([[INTERFACE\GROUPFRAME\UI-GROUP-MAINASSISTICON]])
        mode:SetPoint('BOTTOMLEFT', 10, 10)
        mode:SetSize(16, 16)
        local modeText = InfoWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        modeText:SetPoint('LEFT', mode, 'RIGHT', 3, 0)
        modeText:SetWidth(60)

        local loot = InfoWidget:CreateTexture(nil, 'ARTWORK')
        loot:SetTexture([[INTERFACE\GROUPFRAME\UI-Group-MasterLooter]])
        loot:SetPoint('LEFT', modeText, 'RIGHT', 10, 0)
        loot:SetSize(16, 16)
        local lootText = InfoWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        lootText:SetPoint('LEFT', loot, 'RIGHT', 3, 0)
        lootText:SetWidth(100)

        InfoWidget.Title = title
        InfoWidget.Mode = modeText
        InfoWidget.Loot = lootText
        InfoWidget.Background = bg
        InfoWidget.Summary = summaryLabel
        InfoWidget.PrivateGroup = privateGroupLabel
    end

    local MemberWidget = GUI:GetClass('TitleWidget'):New(ViewBoardWidget) do
        MemberWidget:SetPoint('TOPLEFT', InfoWidget, 'BOTTOMLEFT', 2, -3)
        MemberWidget:SetPoint('TOPRIGHT', InfoWidget, 'BOTTOMRIGHT', -2, -3)
        MemberWidget:SetHeight(70)

        local icon = MemberWidget:CreateTexture(nil, 'ARTWORK')
        icon:SetTexture([[INTERFACE\CHATFRAME\UI-ChatConversationIcon]])
        icon:SetPoint('TOPLEFT', 10, -5)
        icon:SetSize(16, 16)
        local text = MemberWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLargeLeft')
        text:SetPoint('LEFT', icon, 'RIGHT', 3, 0)
        text:SetText(L['队伍配置'])

        local member = CreateFrame('Frame', nil, MemberWidget, 'LFGListGroupDataDisplayTemplate')
        member:SetPoint('TOPLEFT', icon, 'BOTTOMLEFT', 10, -10)
        member:SetSize(150, 20)

        MemberWidget.Member = member
        MemberWidget.Member.SetMember = function(self, activity)
            local activityID = activity:GetActivityID()
            if activityID then
                local data = GetGroupMemberCounts()
                data.DAMAGER = data.DAMAGER + data.NOROLE
                LFGListGroupDataDisplay_Update(self, activityID, data)
                return true
            end
        end
    end

    local MiscWidget = GUI:GetClass('TitleWidget'):New(ViewBoardWidget) do
        MiscWidget:SetPoint('TOPLEFT', MemberWidget, 'BOTTOMLEFT', 0, -3)
        MiscWidget:SetPoint('BOTTOMRIGHT', -2, 0)
        MiscWidget:SetHeight(150)

        local icon = MiscWidget:CreateTexture(nil, 'ARTWORK')
        icon:SetTexture([[INTERFACE\CHATFRAME\UI-ChatWhisperIcon]])
        icon:SetPoint('TOPLEFT', 10, -5)
        icon:SetSize(16, 16)
        local text = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLargeLeft')
        text:SetPoint('LEFT', icon, 'RIGHT', 3, 0)
        text:SetText(L['队伍需求'])

        local pvpRatingLabel = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft')
        pvpRatingLabel:SetPoint('BOTTOMLEFT', 20, 20)
        pvpRatingLabel:SetText(L['PvP 等级：'])
        local pvpRatingText = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        pvpRatingText:SetPoint('LEFT', pvpRatingLabel, 'RIGHT', 3, 0)

        local lvlLabel = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft')
        lvlLabel:SetPoint('BOTTOMLEFT', pvpRatingLabel, 'TOPLEFT', 0, 10)
        lvlLabel:SetText(L['角色等级：'])
        local lvlText = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        lvlText:SetPoint('LEFT', lvlLabel, 'RIGHT', 3, 0)

        local voiceLabel = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft')
        voiceLabel:SetPoint('BOTTOMLEFT', lvlLabel, 'TOPLEFT', 0, 10)
        voiceLabel:SetText(L['语音聊天：'])
        local voiceText = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        voiceText:SetPoint('LEFT', voiceLabel, 'RIGHT', 3, 0)

        local itemLevelLabel = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft')
        itemLevelLabel:SetPoint('BOTTOMLEFT', voiceLabel, 'TOPLEFT', 0, 10)
        itemLevelLabel:SetText(L['最低装等：'])
        local itemLevelText = MiscWidget:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLeft')
        itemLevelText:SetPoint('LEFT', itemLevelLabel, 'RIGHT', 3, 0)
        itemLevelText:SetText('665')

        MiscWidget.Voice = voiceText
        MiscWidget.ItemLevel = itemLevelText
        MiscWidget.Level = lvlText
    end

    -- widgets
    local CreateWidget = CreateFrame('Frame', nil, self) do
        CreateWidget:SetAllPoints(true)
        CreateWidget:Hide()
        CreateWidget:SetScript('OnShow', function()
            self:UpdateActivity()
            self:UpdateControlState()
        end)
    end

    --- options
    local ActivityOptions = GUI:GetClass('TitleWidget'):New(CreateWidget) do
        ActivityOptions:SetPoint('TOPLEFT')
        ActivityOptions:SetSize(219, 66)
        ActivityOptions:SetText(L['请选择活动属性'])
    end

    local ActivityType = GUI:GetClass('Dropdown'):New(ActivityOptions) do
        ActivityType:SetPoint('TOP', 0, -30)
        ActivityType:SetSize(170, 26)
        ActivityType:SetDefaultText(L['请选择活动类型'])
        ActivityType:SetMaxItem(20)
        ActivityType:SetCallback('OnSelectChanged', function(_, item)
            self:InitProfile()
            self:UpdateControlState()
        end)
    end

    local TitleBox = LFGListFrame.EntryCreation.Name
    local TitleWidget = GUI:GetClass('TitleWidget'):New(CreateWidget) do
        TitleWidget:SetPoint('TOPLEFT', ActivityOptions, 'BOTTOMLEFT', 0, -3)
        TitleWidget:SetPoint('TOPRIGHT', ActivityOptions, 'BOTTOMRIGHT', 0, -3)
        TitleWidget:SetHeight(56)
        TitleWidget:SetText(L['活动标题'])
        TitleWidget:SetScript('OnShow', function(TitleWidget)
            TitleWidget:SetObject(TitleBox, 10, 5, 10, 10)
        end)
        TitleBox:SetScript('OnTextChanged', function(TitleBox)
            InputBoxInstructions_OnTextChanged(TitleBox)
            self:UpdateControlState()
        end)
    end

    --- voice and item level
    local VoiceItemLevelWidget = GUI:GetClass('TitleWidget'):New(CreateWidget) do
        VoiceItemLevelWidget:SetPoint('BOTTOMLEFT')
        VoiceItemLevelWidget:SetSize(219, 100)
    end

    local ItemLevel = GUI:GetClass('NumericBox'):New(VoiceItemLevelWidget) do
        ItemLevel:SetPoint('TOP', VoiceItemLevelWidget, 30, -3)
        ItemLevel:SetSize(108, 23)
        ItemLevel:SetLabel(L['最低装等'])
        ItemLevel:SetValueStep(10)
        ItemLevel:SetMinMaxValues(0, 2000)
    end

    local MythicPlusRating = GUI:GetClass('NumericBox'):New(VoiceItemLevelWidget) do
        MythicPlusRating:SetPoint('TOP', ItemLevel, 'BOTTOM', 0, -1)
        MythicPlusRating:SetSize(108, 23)
        MythicPlusRating:SetLabel(L['最低评分'])
        MythicPlusRating:SetValueStep(1)
        MythicPlusRating:SetMinMaxValues(0, 4000)
        GUI:Embed(MythicPlusRating, 'Tooltip')
        MythicPlusRating:SetTooltip(GROUP_FINDER_MYTHIC_RATING_REQ_LABEL)
    end

    local PVPRating = GUI:GetClass('NumericBox'):New(VoiceItemLevelWidget) do
        PVPRating:SetPoint('TOP', ItemLevel, 'BOTTOM', 0, -1)
        PVPRating:SetSize(108, 23)
        PVPRating:SetLabel(L['最低评分'])
        PVPRating:SetValueStep(1)
        PVPRating:SetMinMaxValues(0, 4000)
        GUI:Embed(PVPRating, 'Tooltip')
        PVPRating:SetTooltip(GROUP_FINDER_PVP_RATING_REQ_LABEL)
    end
    PVPRating:Hide()
    PVPRating:HookScript("OnTextChanged", function(self)
        if self.activityId then
            if not C_LFGList.ValidateRequiredPvpRatingForActivity(self.activityId, tonumber(self:GetText()) or 0) then
                DEFAULT_CHAT_FRAME:AddMessage("|cffcd1a1c【爱不易】|r- ".."输入的最低评分" .. (tonumber(self:GetText()) or 0) .. "不能超过你自身的评级分数。")
                self:SetText("")
            end
        end
    end)

    local HonorLevel = GUI:GetClass('NumericBox'):New(VoiceItemLevelWidget) do
        HonorLevel:SetPoint('TOP', ItemLevel, 'BOTTOM', 0, -1)
        HonorLevel:SetSize(108, 23)
        HonorLevel:SetLabel(L['荣誉等级'])
        HonorLevel:SetValueStep(1)
        HonorLevel:SetMinMaxValues(0, 2000)
    end
    HonorLevel:Hide()

    local VoiceBox = LFGListFrame.EntryCreation.VoiceChat.EditBox do
        VoiceItemLevelWidget:SetScript('OnShow', function(VoiceItemLevelWidget)
            VoiceBox:ClearAllPoints()
            VoiceBox:SetParent(VoiceItemLevelWidget)
            VoiceBox:SetPoint('TOP', MythicPlusRating, 'BOTTOM', 2, -1)
            VoiceBox:SetSize(103, 23)
        end)
        VoiceBox:SetScript('OnTextChanged', nil)
        VoiceBox:SetScript('OnEditFocusLost', nil)

        local label = VoiceBox:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
        label:SetPoint('RIGHT', VoiceBox, 'LEFT', -11, 0)
        label:SetText(L['语音聊天'])

        VoiceBox:SetScript('OnEnable', function()
            label:SetAlpha(1)
        end)
        VoiceBox:SetScript('OnDisable', function()
            label:SetAlpha(0.5)
        end)

        VoiceBox.Instructions:Hide()
        VoiceBox.Instructions.Show = nop
    end

    local CrossFactionGroup = CreateFrame('CheckButton', nil, VoiceItemLevelWidget) do
        CrossFactionGroup:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
        CrossFactionGroup:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
        CrossFactionGroup:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
        CrossFactionGroup:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
        CrossFactionGroup:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
        CrossFactionGroup:SetSize(22, 22)
        CrossFactionGroup:SetPoint('TOPLEFT', VoiceBox, 'BOTTOMLEFT', -77, 0)
        local text = CrossFactionGroup:CreateFontString(nil, 'ARTWORK')
        text:SetPoint('LEFT', CrossFactionGroup, 'RIGHT', 2, 0)
        CrossFactionGroup:SetFontString(text)
        CrossFactionGroup:SetNormalFontObject('GameFontHighlightSmall')
        CrossFactionGroup:SetHighlightFontObject('GameFontNormalSmall')
        CrossFactionGroup:SetDisabledFontObject('GameFontDisableSmall')

        local _, localizedFaction = UnitFactionGroup("player");
        CrossFactionGroup:SetText(LFG_LIST_CROSS_FACTION:format(localizedFaction))
        GUI:Embed(CrossFactionGroup, 'Tooltip')
        CrossFactionGroup:SetTooltip(LFG_LIST_CROSS_FACTION_TOOLTIP:format(localizedFaction), " ", "爱不易备注：暴雪的系统目前有BUG, 即使选了这个选项, 对面阵营的也能看到并申请。等哪天暴雪修复了，自然就好使了")
    end

    local PrivateGroup = CreateFrame('CheckButton', nil, VoiceItemLevelWidget) do
        PrivateGroup:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
        PrivateGroup:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
        PrivateGroup:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
        PrivateGroup:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
        PrivateGroup:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
        PrivateGroup:SetSize(22, 22)
        PrivateGroup:SetPoint('TOPLEFT', CrossFactionGroup, 'TOPLEFT', 120, 0)
        local text = PrivateGroup:CreateFontString(nil, 'ARTWORK')
        text:SetPoint('LEFT', PrivateGroup, 'RIGHT', 2, 0)
        PrivateGroup:SetFontString(text)
        PrivateGroup:SetNormalFontObject('GameFontHighlightSmall')
        PrivateGroup:SetHighlightFontObject('GameFontNormalSmall')
        PrivateGroup:SetDisabledFontObject('GameFontDisableSmall')
        PrivateGroup:SetText(L['个人'])

        GUI:Embed(PrivateGroup, 'Tooltip')
        PrivateGroup:SetTooltip("私人队伍", LFG_LIST_PRIVATE_TOOLTIP)
    end

    --- summary
    local SummaryWidget = GUI:GetClass('TitleWidget'):New(CreateWidget) do
        SummaryWidget:SetPoint('TOPLEFT', TitleWidget, 'BOTTOMLEFT', 0, -3)
        SummaryWidget:SetPoint('BOTTOMRIGHT', VoiceItemLevelWidget, 'TOPRIGHT', 0, 3)
        SummaryWidget:SetText(L['活动说明'])
        SummaryWidget:SetScript('OnShow', function(SummaryWidget)
            SummaryWidget:SetObject(LFGListFrame.EntryCreation.Description, 10, 10, 15, 10)
            InputScrollFrame_OnLoad(LFGListFrame.EntryCreation.Description)
        end)
    end

    -- buttons
    local DisbandButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        DisbandButton:SetPoint('BOTTOM', ManagerPanel:GetOwner(), 'BOTTOM', 60, 4)
        DisbandButton:SetSize(120, 22)
        DisbandButton:SetText(L['解散活动'])
        DisbandButton:Disable()
        DisbandButton:SetScript('OnClick', function()
            self:DisbandActivity()
        end)
        MagicButton_OnLoad(DisbandButton)
    end

    local CreateButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        CreateButton:SetPoint('RIGHT', DisbandButton, 'LEFT')
        CreateButton:SetSize(120, 22)
        CreateButton:SetText(L['创建活动'])
        CreateButton:Disable()
        CreateButton:SetScript('OnClick', function(CreateButton)
            self:CreateActivity()
        end)
        MagicButton_OnLoad(CreateButton)
    end

    -- local CreateHelpPlate do
    --     CreateHelpPlate = {
    --         FramePos = { x = -10,          y = 55 },
    --         FrameSize = { width = 830, height = 415 },
    --         {
    --             ButtonPos = { x = 755, y = 10 },
    --             HighLightBox = { x = 735, y = 5, width = 95, height = 35 },
    --             ToolTipDir = 'DOWN',
    --             ToolTipText = L.CreateHelpRefresh,
    --         },
    --         {
    --             ButtonPos = { x = 400,  y = -170 },
    --             HighLightBox = { x = 230, y = -35, width = 600, height = 350 },
    --             ToolTipDir = 'RIGHT',
    --             ToolTipText = L.CreateHelpList,
    --         },
    --         {
    --             ButtonPos = { x = 90,  y = -80 },
    --             HighLightBox = { x = 5, y = -35, width = 220, height = 150 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.CreateHelpOptions,
    --         },
    --         {
    --             ButtonPos = { x = 90,  y = -220 },
    --             HighLightBox = { x = 5, y = -190, width = 220, height = 195 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.CreateHelpSummary,
    --         },
    --         {
    --             ButtonPos = { x = 370,  y = -380 },
    --             HighLightBox = { x = 280, y = -390, width = 270, height = 28 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.CreateHelpButtons,
    --         },
    --     }
    --     MainPanel:AddHelpButton(CreateWidget, CreateHelpPlate)
    -- end

    -- local ViewHelpPlate do
    --     ViewHelpPlate = {
    --         FramePos = { x = -10,          y = 55 },
    --         FrameSize = { width = 830, height = 415 },
    --         {
    --             ButtonPos = { x = 755, y = 10 },
    --             HighLightBox = { x = 735, y = 5, width = 95, height = 35 },
    --             ToolTipDir = 'DOWN',
    --             ToolTipText = L.CreateHelpRefresh,
    --         },
    --         {
    --             ButtonPos = { x = 400,  y = -170 },
    --             HighLightBox = { x = 230, y = -35, width = 600, height = 350 },
    --             ToolTipDir = 'RIGHT',
    --             ToolTipText = L.CreateHelpList,
    --         },
    --         {
    --             ButtonPos = { x = 90,  y = -80 },
    --             HighLightBox = { x = 5, y = -35, width = 220, height = 120 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.ViewboardHelpOptions,
    --         },
    --         {
    --             ButtonPos = { x = 90,  y = -220 },
    --             HighLightBox = { x = 5, y = -160, width = 220, height = 225 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.ViewboardHelpSummary,
    --         },
    --         {
    --             ButtonPos = { x = 370,  y = -380 },
    --             HighLightBox = { x = 280, y = -390, width = 270, height = 28 },
    --             ToolTipDir = 'UP',
    --             ToolTipText = L.CreateHelpButtons,
    --         },
    --     }
    --     MainPanel:AddHelpButton(ViewBoardWidget, ViewHelpPlate)
    -- end

    self.TitleBox = TitleBox
    self.SummaryBox = LFGListFrame.EntryCreation.Description.EditBox
    self.VoiceBox = VoiceBox
    self.ItemLevel = ItemLevel
    self.CreateButton = CreateButton
    self.DisbandButton = DisbandButton
    self.ActivityType = ActivityType
    self.HonorLevel = HonorLevel
    self.PrivateGroup = PrivateGroup
    self.MythicPlusRating = MythicPlusRating
    self.PVPRating = PVPRating
    self.CrossFactionGroup = CrossFactionGroup

    self.ViewBoardWidget = ViewBoardWidget
    self.InfoWidget = InfoWidget
    self.MemberWidget = MemberWidget
    self.MiscWidget = MiscWidget
    self.CreateWidget = CreateWidget

    self:RegisterInputBox(TitleBox)
    self:RegisterInputBox(self.SummaryBox)
    self:RegisterInputBox(ItemLevel)
    self:RegisterInputBox(HonorLevel)
    self:RegisterInputBox(VoiceBox)
    self:RegisterInputBox(MythicPlusRating)
    self:RegisterInputBox(PVPRating)

    self:RegisterEvent('LFG_LIST_ACTIVE_ENTRY_UPDATE')
    self:RegisterEvent('LFG_LIST_AVAILABILITY_UPDATE')
    self:RegisterEvent('LFG_LIST_ENTRY_CREATION_FAILED')
    -- self:RegisterEvent('PARTY_LEADER_CHANGED')
    self:RegisterMessage('MEETINGSTONE_PERMISSION_UPDATE', 'ChooseWidget')

    self:RegisterMessage('MEETINGSTONE_SETTING_CHANGED_packedPvp', 'LFG_LIST_AVAILABILITY_UPDATE')

    self:SetScript('OnShow', self.ChooseWidget)
end

function CreatePanel:OnEnable()
    -- self:PARTY_LEADER_CHANGED()
end

function CreatePanel:UpdateControlState()
    if not self.CreateWidget:IsVisible() then
        return
    end

    local activityItem = self.ActivityType:GetItem()

    local isSolo = activityItem and IsSoloCustomID(activityItem.customId)
    local isCreated = self:IsActivityCreated()
    local isLeader = IsGroupLeader()
    local enable = activityItem
    local editable = enable and not isSolo

    local activityInfo = activityItem and activityItem.activityId and C_LFGList.GetActivityInfoTable(activityItem.activityId) or {};
    self.MythicPlusRating:SetShown(not enable or activityInfo.isMythicPlusActivity)
    if not self.MythicPlusRating:IsShown() then self.MythicPlusRating:SetText("") end
    self.PVPRating:SetShown(activityInfo.isRatedPvpActivity)
    if not self.PVPRating:IsShown() then self.PVPRating:SetText("") end

    local categoryInfo = activityItem and activityItem.categoryId and C_LFGList.GetLfgCategoryInfo(activityItem.categoryId) or {};
    local shouldShowCrossFactionToggle = (categoryInfo.allowCrossFaction);
    local shouldDisableCrossFactionToggle = (categoryInfo.allowCrossFaction) and not (activityInfo.allowCrossFaction);
    self.CrossFactionGroup:SetShown(shouldShowCrossFactionToggle)
    self.CrossFactionGroup:SetEnabled(not shouldDisableCrossFactionToggle);
    if shouldDisableCrossFactionToggle then
   	    self.CrossFactionGroup:SetChecked(true);
    end

    self.ActivityType:SetEnabled(isLeader and not isCreated)

    self.PrivateGroup:SetEnabled(editable)
    self.ItemLevel:SetEnabled(editable)
    self.VoiceBox:SetEnabled(editable)
    self.TitleBox:SetEnabled(editable)
    self.SummaryBox:SetEnabled(editable)
    self.HonorLevel:SetEnabled(editable and IsUseHonorLevel(activityItem and activityItem.activityId))
    self.MythicPlusRating:SetEnabled(editable)
    self.PVPRating:SetEnabled(editable)

    self.DisbandButton:SetEnabled(isCreated and isLeader)
    self.CreateButton:SetEnabled(enable and isLeader and self.TitleBox:GetText():trim() ~= '')

    if enable then
        self.ItemLevel:SetMinMaxValues(0, GetPlayerItemLevel())
        self.HonorLevel:SetMinMaxValues(0, UnitHonorLevel('player'))
        self.MythicPlusRating:SetMinMaxValues(0, C_ChallengeMode.GetOverallDungeonScore() or 0)
        self.PVPRating.activityId = activityItem and activityItem.activityId --因为没有API知道上限, 所以用 OnTextChanged 超过限制则设置为0
    end

    self.CreateButton:SetText(isCreated and L['更新活动'] or L['创建活动'])
end

function CreatePanel:InitProfile()
    local activityItem = self.ActivityType:GetItem()
    if not activityItem then
        return
    end

    local activityId = activityItem.activityId
    local customId = activityItem.customId

    local profile, voice = Profile:GetActivityProfile(activityItem.text)
    local iLvl, summary, minLvl, maxLvl, pvpRating, honorLevel = 0, '', 10, MAX_PLAYER_LEVEL, 0, 0
    local mythicPlusRating, pvpRating2, crossFactionListing = 0, 0, true

    if IsSoloCustomID(customId) then
        iLvl = min(100, GetPlayerItemLevel())
        summary = L['我只是想要单刷，请不要申请']
    elseif profile then
        iLvl = profile.ItemLevel
        summary = profile.Summary
        honorLevel = profile.HonorLevel or 0
        mythicPlusRating = profile.RequiredDungeonScore or mythicPlusRating
        pvpRating2 = profile.RequiredPvpRating or pvpRating2
        crossFactionListing = profile.CrossFactionListing or crossFactionListing
    else
        local fullName, shortName, categoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType = C_LFGList.GetActivityInfo(activityId)
        iLvl = min(iLevel, GetPlayerItemLevel())
        minLvl = minLevel == 0 and MIN_PLAYER_LEVEL or minLevel
        maxLvl = MAX_PLAYER_LEVEL
    end

    self.ItemLevel:SetText(iLvl)
    self.HonorLevel:SetText(honorLevel)
    self.MythicPlusRating:SetText(mythicPlusRating)
    self.PVPRating:SetText(pvpRating2)
    self.CrossFactionGroup:SetChecked(not crossFactionListing)
end

function CreatePanel:ChooseWidget()
    local isLeader = IsGroupLeader()
    local isCreated = self:IsActivityCreated()

    self.CreateWidget:Hide()
    self.ViewBoardWidget:Hide()
    self.CreateWidget:SetShown(isLeader or not isCreated)
    self.ViewBoardWidget:SetShown(not isLeader and isCreated)
end

function CreatePanel:CreateActivity()
    -- if CheckContent(self.SummaryBox:GetText()) then
    --     System:Error(self:IsActivityCreated() and L['更新活动失败：包含非法关键字。'] or L['创建活动失败，包含非法关键字。'])
    --     return
    -- end
    self:ClearInputBoxFocus()

    local activityItem = self.ActivityType:GetItem()

    local activity = CurrentActivity:FromAddon({
        ActivityID = activityItem.activityId,
        CustomID = activityItem.customId or 0,

        ItemLevel = self.ItemLevel:GetNumber(),

        HonorLevel = self.HonorLevel:GetNumber(),
        PrivateGroup = self.PrivateGroup:GetChecked(),

        RequiredDungeonScore = self.MythicPlusRating:GetNumber(),
        RequiredPvpRating = self.PVPRating:GetNumber(),
        CrossFactionListing = self.CrossFactionGroup:IsShown() and not self.CrossFactionGroup:GetChecked(), --注意是not
    })
    if self:Create(activity, true) then
        self.CreateButton:Disable()
    else
        self:ChooseWidget()
    end
end

function CreatePanel:Create(activity, isSelf)
    local isCreated = self:IsActivityCreated()
    local handler = isCreated and C_LFGList.UpdateListing or C_LFGList.CreateListing
    local autoAccept = C_LFGList:HasActiveEntryInfo() and C_LFGList.GetActiveEntryInfo().autoAccept

    if handler(activity:GetCreateArguments(autoAccept)) then
        if isSelf then
            Profile:SaveActivityProfile(activity)
            Profile:SaveCreateHistory(activity:GetCode())
        end
        if not isCreated then
            Logic:SEI(activity, self.TitleBox:GetText(), self.SummaryBox:GetText())
        end
        self:SendMessage('MEETINGSTONE_CREATING_ACTIVITY', true)
        return true
    else
        return false
    end
end

function CreatePanel:IsActivityCreated()
    return C_LFGList.HasActiveEntryInfo()
end

function CreatePanel:ClearAllContent()
    self.ItemLevel:SetNumber(0)
    self.HonorLevel:SetNumber(0)
    self.ActivityType:SetValue(nil)
    self.PrivateGroup:SetChecked(false)
    self.MythicPlusRating:SetNumber(0)
    self.PVPRating:SetNumber(0)
    self.CrossFactionGroup:SetChecked(false)
end

function CreatePanel:UpdateActivity()
    if not self.CreateWidget:IsVisible() then
        return
    end

    local activity = self:GetCurrentActivity()
    if not activity then
        return
    end

    self.ActivityType:SetValue(activity:GetCode())
    self.ItemLevel:SetText(activity:GetItemLevel())
    self.HonorLevel:SetText(activity:GetHonorLevel() or '')
    self.PrivateGroup:SetChecked(activity:GetPrivateGroup())
    self.MythicPlusRating:SetText(activity:GetRequiredDungeonScore())
    self.PVPRating:SetText(activity:GetRequiredPvpRating())
    self.CrossFactionGroup:SetChecked(not activity:GetCrossFactionListing())
end

function CreatePanel:UpdateActivityView()
    if not self.ViewBoardWidget:IsVisible() then
        return
    end

    local activity = self:GetCurrentActivity()
    if not activity then
        return
    end

    local minLevel = activity:GetMinLevel()
    local maxLevel = activity:GetMaxLevel()

    self.InfoWidget.Title:SetText(activity:GetName())
    self.InfoWidget.Mode:SetText(activity:GetModeText() or UNKNOWN)
    self.InfoWidget.Loot:SetText(activity:GetLootText() or UNKNOWN)
    self.InfoWidget.Summary:SetText(activity:GetSummary() or '')
    self.MemberWidget.Member:SetShown(self.MemberWidget.Member:SetMember(activity))
    self.MiscWidget.Voice:SetText(activity:GetVoiceChat())
    self.MiscWidget.ItemLevel:SetText(activity:GetItemLevel())
    self.MiscWidget.Level:SetText(minLevel == maxLevel and minLevel or isMax and '≥' .. minLevel or minLevel .. '-' .. maxLevel)

    if activity:GetPrivateGroup() then
        self.InfoWidget.PrivateGroup:Show()
    else
        self.InfoWidget.PrivateGroup:Hide()
    end

    local atlasName, suffix do
        local fullName, shortName, categoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType = C_LFGList.GetActivityInfo(activity:GetActivityID())
        local _, separateRecommended = C_LFGList.GetCategoryInfo(categoryID)
        if separateRecommended and bit.band(filters, Enum.LFGListFilter.Recommended) ~= 0 then
            atlasName = 'groupfinder-background-'..(LFG_LIST_CATEGORY_TEXTURES[categoryID] or 'raids')..'-'..LFG_LIST_PER_EXPANSION_TEXTURES[LFGListUtil_GetCurrentExpansion()]
        elseif separateRecommended and bit.band(filters, Enum.LFGListFilter.NotRecommended) ~= 0 then
            atlasName = 'groupfinder-background-'..(LFG_LIST_CATEGORY_TEXTURES[categoryID] or 'raids')..'-'..LFG_LIST_PER_EXPANSION_TEXTURES[math.max(0,LFGListUtil_GetCurrentExpansion() - 1)]
        else
            atlasName = 'groupfinder-background-'..(LFG_LIST_CATEGORY_TEXTURES[categoryID] or 'questing')
        end

        if bit.band(filters, Enum.LFGListFilter.PvE) ~= 0 then
            suffix = '-pve'
        elseif bit.band(filters, Enum.LFGListFilter.PvP) ~= 0 then
            suffix = '-pvp'
        end
    end

    if not self.InfoWidget.Background:SetAtlas(atlasName..suffix, true) then
        self.InfoWidget.Background:SetAtlas(atlasName, true)
    end
end

function CreatePanel:GetCurrentActivity()
    if C_LFGList.HasActiveEntryInfo() then
        self.Activity = CurrentActivity:FromSystem(C_LFGList.GetActiveEntryInfo())
        return self.Activity
    else
        self.Activity = nil
    end
end

function CreatePanel:LFG_LIST_AVAILABILITY_UPDATE()
    self:UpdateMenu()
    self:ChooseWidget()
end

function CreatePanel:LFG_LIST_ACTIVE_ENTRY_UPDATE(_, isCreated)
    if not isCreated then
        self:ClearAllContent()
    end
    self:ChooseWidget()
    C_LFGList.CopyActiveEntryInfoToCreationFields()
end

function CreatePanel:PARTY_LEADER_CHANGED()
    if not IsGroupLeader() then
        return
    end

    local activity = self:GetCurrentActivity()
    if not activity or not activity:IsMeetingStone() then
        return
    end

    activity:SetItemLevel(min(activity:GetItemLevel(), GetPlayerItemLevel(activity:IsUseHonorLevel())))
    activity:SetHonorLevel(min(activity:GetHonorLevel(), 0))

    self:Create(activity)
end

function CreatePanel:LFG_LIST_ENTRY_CREATION_FAILED()
    System:Error(L['活动创建失败，请重试。'])
end

function CreatePanel:UpdateMenu()
    self.ActivityType:SetMenuTable(GetActivitesMenuTable(ACTIVITY_FILTER_CREATE))
end

function CreatePanel:DisbandActivity()
    if not IsGroupLeader() then
        return
    end
    C_LFGList.RemoveListing()
end

function CreatePanel:SelectActivity(value, summary)
    if not self:IsActivityCreated() then
        self.ActivityType:SetValue(value)
    end
end

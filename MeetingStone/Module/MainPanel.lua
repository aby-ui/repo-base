BuildEnv(...)

MainPanel = Addon:NewModule(GUI:GetClass('Panel'):New(UIParent), 'MainPanel', 'AceEvent-3.0', 'AceBucket-3.0')
_G.MeetingStone_MainPanel_AbyUI = MainPanel
table.insert(UISpecialFrames, 'MeetingStone_MainPanel_AbyUI')

function MainPanel:OnInitialize()
    GUI:Embed(self, 'Refresh', 'Help', 'Blocker')

    self:SetSize(832, 447)
    self:SetText(L['集合石'] .. ' Beta ' .. ADDON_VERSION)
    self:SetIcon(ADDON_LOGO)
    self:EnableUIPanel(true)
    self:SetTabStyle('BOTTOM')
    self:SetTopHeight(80)
    self:RegisterForDrag('LeftButton')
    self:SetMovable(true)
    self:SetScript('OnDragStart', self.StartMoving)
    self:SetScript('OnDragStop', self.StopMovingOrSizing)
    self:SetClampedToScreen(true)

    self:HookScript('OnShow', function()
        C_LFGList.RequestAvailableActivities()
        self:UpdateBlockers()
        self:SendMessage('MEETINGSTONE_OPEN')
    end)

    self:RegisterMessage('MEETINGSTONE_NEW_VERSION')
    self:RegisterEvent('AJ_PVE_LFG_ACTION')
    self:RegisterEvent('AJ_PVP_LFG_ACTION', 'AJ_PVE_LFG_ACTION')

    PVEFrame:UnregisterEvent('AJ_PVE_LFG_ACTION')
    PVEFrame:UnregisterEvent('AJ_PVP_LFG_ACTION')

    local AnnBlocker = self:NewBlocker('AnnBlocker', 1)
    do
        self.AnnBlocker = AnnBlocker
        AnnBlocker:SetCallback('OnCheck', function()
            return DataCache:GetObject('AnnList'):IsNew()
        end)
        AnnBlocker:SetCallback('OnInit', function(AnnBlocker)
            local width, height = AnnBlocker:GetSize()
            local topWidth, topHeight = width / 3, width / 3;
            local botWidth, botHeight = topWidth, height - topHeight;

            local BTLT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BTLT:SetSize(topWidth, topHeight)
                BTLT:SetPoint('TOPLEFT')
                BTLT:SetTexture([[Interface\GLUES\CREDITS\gatetga1]])
                BTLT:SetAlpha(0.4)
            end

            local BTT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BTT:SetSize(topWidth, topHeight)
                BTT:SetPoint('LEFT', BTLT, 'RIGHT')
                BTT:SetTexture([[Interface\GLUES\CREDITS\gatetga2]])
                BTT:SetAlpha(0.4)
            end

            local BTRT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BTRT:SetSize(topWidth, topHeight)
                BTRT:SetPoint('LEFT', BTT, 'RIGHT')
                BTRT:SetTexture([[Interface\GLUES\CREDITS\gatetga3]])
                BTRT:SetAlpha(0.4)
            end

            local BBLT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BBLT:SetSize(botWidth, botHeight)
                BBLT:SetPoint('TOP', BTLT, 'BOTTOM')
                BBLT:SetTexture([[Interface\GLUES\CREDITS\gatetga5]])
                BBLT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBLT:SetAlpha(0.4)
            end

            local BBT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BBT:SetSize(botWidth, botHeight)
                BBT:SetPoint('LEFT', BBLT, 'RIGHT')
                BBT:SetTexture([[Interface\GLUES\CREDITS\gatetga6]])
                BBT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBT:SetAlpha(0.4)
            end

            local BBRT = AnnBlocker:CreateTexture(nil, 'BORDER', nil, 1)
            do
                BBRT:SetSize(botWidth, botHeight)
                BBRT:SetPoint('LEFT', BBT, 'RIGHT')
                BBRT:SetTexture([[Interface\GLUES\CREDITS\gatetga7]])
                BBRT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBRT:SetAlpha(0.4)
            end

            local NoticeFrame = CreateFrame('Frame', nil, AnnBlocker, 'MeetingStoneNoticeTemplate')
            NoticeFrame.btnKnow:SetScript('OnClick', function()
                DataCache:GetObject('AnnList'):SetIsNew(false)
                AnnBlocker:Hide()
            end)
            AnnBlocker.NoticeContainer = NoticeFrame.NoticeContainer

            self:RegisterMessage('MEETINGSTONE_ANNOUNCEMENT_UPDATED', function(_, isNew)
                if isNew then
                    AnnBlocker:Fire('OnFormat')
                end
            end)
        end)

        AnnBlocker:SetCallback('OnFormat', function(AnnBlocker)
            local annData = DataCache:GetObject('AnnList'):GetData() or {}
            local NoticeContainer = AnnBlocker.NoticeContainer

            local width = NoticeContainer.notices[1]:GetWidth()
            NoticeContainer:SetWidth((width + 10) * #annData - 10)

            for i, notice in ipairs(NoticeContainer.notices) do
                local v = annData[i]
                if v then
                    notice.Text:SetText(v.t or '')
                    notice.LookDetail:SetShown(v.u)
                    ApplyUrlButton(notice.LookDetail, v.u)
                else
                    notice:Hide()
                end
            end
        end)
    end

    local HelpBlocker = self:NewBlocker('HelpBlocker', 2)
    do
        HelpBlocker:SetCallback('OnCheck', function()
            return Profile:IsNewVersion() or (self.newVersion and not self.newVersionReaded)
        end)
        HelpBlocker:SetCallback('OnFormat', function(HelpBlocker)
            if self.newVersion then
                HelpBlocker.NewVersion:SetFormattedText('%s|cff00ffff%s|r', L['最新版本：'], self.newVersion)
                HelpBlocker.NewVersion:Show()
                HelpBlocker.NewVersionFlash:Show()
            else
                HelpBlocker.NewVersion:Hide()
                HelpBlocker.NewVersionFlash:Hide()
            end
        end)
        HelpBlocker:SetCallback('OnInit', function(HelpBlocker)
            local Icon = HelpBlocker:CreateTexture(nil, 'ARTWORK')
            do
                Icon:SetPoint('TOPLEFT', 50, -50)
                Icon:SetSize(64, 64)
                Icon:SetTexture([[Interface\AddOns\MeetingStone\Media\Mark\0]])
            end

            local Label = HelpBlocker:CreateFontString(nil, 'ARTWORK')
            do
                Label:SetFont(STANDARD_TEXT_FONT, 32, 'OUTLINE')
                Label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
                Label:SetPoint('LEFT', Icon, 'RIGHT', 0, 0)
                Label:SetText(L['集合石'])
            end

            local Content = HelpBlocker:CreateFontString(nil, 'ARTWORK', 'GameFontDisableLarge')
            do
                Content:SetPoint('TOPLEFT', Icon, 'BOTTOMLEFT', 10, -20)
                Content:SetJustifyH('LEFT')
                Content:SetJustifyV('TOP')
                Content:SetText(L['当前版本：'] .. ADDON_VERSION)
            end

            local NewVersion = HelpBlocker:CreateFontString(nil, 'ARTWORK', 'GameFontDisableLarge')
            do
                NewVersion:SetPoint('TOPLEFT', Content, 'BOTTOMLEFT', 0, -10)
                NewVersion:SetJustifyH('LEFT')
                NewVersion:SetJustifyV('TOP')
                NewVersion:SetText('N/A')
                NewVersion:Hide()
            end

            local NewVersionFlash = GUI:GetClass('AlphaFlash'):New(HelpBlocker)
            do
                NewVersionFlash:Hide()
                NewVersionFlash:SetPoint('BOTTOM', NewVersion, 'BOTTOM', 0, -5)
                NewVersionFlash:SetPoint('LEFT', NewVersion)
                NewVersionFlash:SetPoint('RIGHT', NewVersion)
                NewVersionFlash:SetHeight(20)
                NewVersionFlash:SetTexture([[INTERFACE\CHATFRAME\ChatFrameTab-NewMessage]])
                NewVersionFlash:SetVertexColor(1.00, 0.89, 0.18, 0.5)
                NewVersionFlash:SetBlendMode('ADD')
            end

            local SummaryHtml = GUI:GetClass('ScrollSummaryHtml'):New(HelpBlocker)
            do
                SummaryHtml:SetPoint('TOPLEFT', 360, -15)
                SummaryHtml:SetPoint('BOTTOMRIGHT', -20, 20)
                SummaryHtml:SetSpacing('h2', 20)
                SummaryHtml:SetSpacing('h1', 10)
                SummaryHtml:SetText(ADDON_SUMMARY)
            end

            local EnterButton = CreateFrame('Button', nil, HelpBlocker, 'UIPanelButtonTemplate')
            do
                EnterButton:SetPoint('BOTTOMLEFT', 50, 30)
                EnterButton:SetSize(120, 26)
                EnterButton:SetText(L['开始体验'])
                EnterButton:SetScript('OnClick', function()
                    self.newVersionReaded = true
                    Profile:SaveVersion()
                    HelpBlocker:Hide()
                end)
            end

            local HelpButton = CreateFrame('Button', nil, HelpBlocker, 'UIPanelButtonTemplate')
            do
                HelpButton:SetPoint('BOTTOMLEFT', EnterButton, 'TOPLEFT', 0, 10)
                HelpButton:SetSize(120, 26)
                HelpButton:SetText(L['新手指引'])
                HelpButton:SetScript('OnClick', function()
                    self.newVersionReaded = true
                    Profile:SaveVersion()
                    HelpBlocker:Hide()
                    self:SelectPanel(BrowsePanel)
                    self:ShowHelpPlate(BrowsePanel)
                end)
            end

            local ChangeLogButton = CreateFrame('Button', nil, HelpBlocker, 'UIPanelButtonTemplate')
            do
                ChangeLogButton:SetPoint('BOTTOMLEFT', HelpButton, 'TOPLEFT', 0, 10)
                ChangeLogButton:SetSize(120, 26)
                ChangeLogButton:SetText(L['更新日志'])
                ChangeLogButton:SetScript('OnClick', function()
                    SummaryHtml:SetText(ADDON_CHANGELOG)
                end)
            end

            local SummaryButton = CreateFrame('Button', nil, HelpBlocker, 'UIPanelButtonTemplate')
            do
                SummaryButton:SetPoint('BOTTOMLEFT', ChangeLogButton, 'TOPLEFT', 0, 10)
                SummaryButton:SetSize(120, 26)
                SummaryButton:SetText(L['插件简介'])
                SummaryButton:SetScript('OnClick', function()
                    SummaryHtml:SetText(ADDON_SUMMARY)
                end)
            end

            HelpBlocker.NewVersion = NewVersion
            HelpBlocker.NewVersionFlash = NewVersionFlash
        end)
    end

    if ADDON_REGIONSUPPORT then
        self:CreateTitleButton{
            title = L['意见建议'],
            texture = [[Interface\AddOns\MeetingStone\Media\RaidbuilderIcons]],
            coords = {0, 32 / 256, 0, 0.5},
            callback = function()
                GUI:CallFeedbackDialog(ADDON_NAME, function(result, text)
                    Logic:SendServer('SFEEDBACK', ADDON_NAME, ADDON_VERSION, text)
                end)
            end,
        }

        self:CreateTitleButton{
            title = L['公告'],
            texture = [[Interface\AddOns\MeetingStone\Media\RaidbuilderIcons]],
            coords = {96 / 256, 128 / 256, 0, 0.5},
            callback = function()
                self:ToggleBlocker('AnnBlocker')
            end,
        }
    end

    self:CreateTitleButton{
        title = L['插件简介'],
        texture = [[Interface\AddOns\MeetingStone\Media\RaidbuilderIcons]],
        coords = {224 / 256, 1, 0.5, 1},
        callback = function()
            self:ToggleBlocker('HelpBlocker')
        end,
    }

    self.GameTooltip = GUI:GetClass('Tooltip'):New(self)
end

function MainPanel:OnEnable()
    C_LFGList.RequestAvailableActivities()
end

function MainPanel:AJ_PVE_LFG_ACTION()
    Addon:ShowModule('MainPanel')
    MainPanel:SelectPanel(BrowsePanel)
end

function MainPanel:MEETINGSTONE_NEW_VERSION(_, version)
    self.newVersion = version
    self.newVersionReaded = nil
    self:UpdateBlockers()
end

function MainPanel:OpenActivityTooltip(activity, tooltip)
    -- local tooltip = self.tooltip
    if not tooltip then
        tooltip = self.GameTooltip
        tooltip:SetOwner(self, 'ANCHOR_NONE')
        tooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, -10)
    end
    -- tooltip:SetOwner(self, 'ANCHOR_NONE')
    -- tooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, -10)
    tooltip:AddHeader(activity:GetName(), 1, 1, 1)
    tooltip:AddLine(activity:GetSummary(), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)

    if activity:GetComment() then
        tooltip:AddLine(activity:GetComment(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
    end

    tooltip:AddSepatator()

    if activity:GetLeader() then
        tooltip:AddLine(format(LFG_LIST_TOOLTIP_LEADER, activity:GetLeaderText()))

        if activity:GetLeaderItemLevel() then
            tooltip:AddLine(format(L['队长物品等级：|cffffffff%s|r'], activity:GetLeaderItemLevel()))
        end
        if activity:GetLeaderHonorLevel() then
            tooltip:AddLine(format(L['队长荣誉等级：|cffffffff%s|r'], activity:GetLeaderHonorLevel()))
        end
        if activity:GetLeaderPvPRating() then
            tooltip:AddLine(format(L['队长PvP 等级：|cffffffff%s|r'], activity:GetLeaderPvPRating()))
        end

        local score = activity:GetLeaderOverallDungeonScore() or 0
        if activity:IsMythicPlusActivity() or score > 0 then
            local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
            tooltip:AddLine(format(L['队长大秘评分：%s'], color:WrapTextInColorCode(score)))
            local info = activity:GetLeaderDungeonScoreInfo()
            if info and info.mapScore and info.mapScore > 0 then
                local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(info.mapScore) or HIGHLIGHT_FONT_COLOR
                local levelText = format(info.finishedSuccess and "|cff00ff00%d层|r" or "|cff7f7f7f%d层|r", info.bestRunLevel or 0)
                tooltip:AddLine(format("队长当前副本: %s / %s", color:WrapTextInColorCode(info.mapScore), levelText))
            else
                tooltip:AddLine(format("队长当前副本: |cff7f7f7f 无信息|r"))
            end
        end
        tooltip:AddSepatator()
    end

    if activity:GetItemLevel() > 0 then
        tooltip:AddLine(format(LFG_LIST_TOOLTIP_ILVL, activity:GetItemLevel()))
    end
    if activity:IsUseHonorLevel() and activity:GetHonorLevel() > 0 then
        tooltip:AddLine(format(LFG_LIST_TOOLTIP_HONOR_LEVEL, activity:GetHonorLevel()))
    end
    if activity:GetVoiceChat() then
        tooltip:AddLine(format(L['语音聊天：|cffffffff%s|r'], activity:GetVoiceChat()), nil, nil, nil, true)
    end
    if activity:GetAge() > 0 then
        tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_AGE, SecondsToTime(activity:GetAge(), false, false, 1, false)))
    end

    if activity:GetDisplayType() == LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then
        tooltip:AddSepatator()
        tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_MEMBERS_SIMPLE, activity:GetNumMembers()))
        for i = 1, activity:GetNumMembers() do
            local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(activity:GetID(), i)
            local classColor = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
            tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_CLASS_ROLE, classLocalized, _G[role]), classColor.r,
                            classColor.g, classColor.b)
        end
    else
        --[[ Added
        tooltip:AddSepatator()
        tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_MEMBERS_SIMPLE, activity:GetNumMembers()))
        for i = 1, activity:GetNumMembers() do
            local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(activity:GetID(), i)
            local classColor = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
            tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_CLASS_ROLE, classLocalized, _G[role]), classColor.r, classColor.g, classColor.b)
        end
        --Added end--]]
        --Added Style2
        local roles = {}
        local classInfo = {}
        for i = 1, activity:GetNumMembers() do
            local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(activity:GetID(), i)
            if (class) then
                classInfo[class] = {
                    name = classLocalized,
                    color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
                }
                if not roles[role] then roles[role] = {} end
                if not roles[role][class] then roles[role][class] = 0 end
                roles[role][class] = roles[role][class] + 1
            end
        end
    
        for role, classes in pairs(roles) do
            tooltip:AddLine(_G[role]..": ")
            for class, count in pairs(classes) do
                local text = "   "
                if count > 1 then text = text .. count .. " " else text = text .. "   " end
                text = text .. "|c" .. classInfo[class].color.colorStr ..  classInfo[class].name .. "|r "
                tooltip:AddLine(text)
            end
        end
        --Added Style2 End
        local memberCounts = C_LFGList.GetSearchResultMemberCounts(activity:GetID())
        if memberCounts then
            tooltip:AddSepatator()
            tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_MEMBERS, activity:GetNumMembers(), memberCounts.TANK,
                                          memberCounts.HEALER, memberCounts.DAMAGER))
        end
    end

    if activity:IsAnyFriend() then
        tooltip:AddSepatator()
        tooltip:AddLine(LFG_LIST_TOOLTIP_FRIENDS_IN_GROUP)
        tooltip:AddLine(LFGListSearchEntryUtil_GetFriendList(activity:GetID()), 1, 1, 1, true)
    end

    local progressions = GetRaidProgressionData(activity:GetActivityID(), activity:GetCustomID())
    local progressionValue = activity:GetLeaderProgression()
    local completedEncounters = C_LFGList.GetSearchResultEncounterInfo(activity:GetID())
    if progressions and progressionValue then
        tooltip:AddSepatator()
        tooltip:AddDoubleLine(L['副本进度/经验：'], activity:GetShortName())
        for i, v in ipairs(progressions) do
            local color = activity:IsBossKilled(v.name) and RED_FONT_COLOR or GREEN_FONT_COLOR
            tooltip:AddDoubleLine(v.name, GetProgressionTex(progressionValue, i), color.r, color.g, color.b)
        end
    elseif completedEncounters and #completedEncounters > 0 then
        tooltip:AddSepatator()
        tooltip:AddLine(LFG_LIST_BOSSES_DEFEATED)
        for i = 1, #completedEncounters do
            tooltip:AddLine(completedEncounters[i], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        end
    end

    if activity:IsDelisted() then
        tooltip:AddSepatator()
        tooltip:AddLine(LFG_LIST_ENTRY_DELISTED, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
    end

    local version = activity:GetVersion()
    if version then
        tooltip:AddDoubleLine(' ', GetFullVersion(version), 1, 1, 1, 0.5, 0.5, 0.5)
    end

    --[===[@debug@
    if activity:IsMeetingStone() then
        local source = activity:GetSource() or 1
        tooltip:AddLine(
            source == 0 and '单体' or source == 1 and '大脚' or source == 2 and '有爱' or source == 4 and '多玩' or
                source == 8 and 'EUI')
    end

    tooltip:AddLine('ID: ' .. activity:GetID())
    tooltip:AddLine('Loot: ' .. tostring(activity:GetLoot()))
    tooltip:AddLine('Mode: ' .. tostring(activity:GetMode()))
    --@end-debug@]===]

    tooltip:Show()
end

function MainPanel:OpenApplicantTooltip(applicant)
    local GameTooltip = self.GameTooltip
    local name = applicant:GetName()
    local class = applicant:GetClass()
    local level = applicant:GetLevel()
    local localizedClass = applicant:GetLocalizedClass()
    local itemLevel = applicant:GetItemLevel()
    local comment = applicant:GetMsg()
    local useHonorLevel = applicant:IsUseHonorLevel()

    GameTooltip:SetOwner(self, 'ANCHOR_NONE')
    GameTooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 0, 0)

    if name then
        local classTextColor = RAID_CLASS_COLORS[class]
        GameTooltip:AddHeader(name, classTextColor.r, classTextColor.g, classTextColor.b)
        GameTooltip:AddLine(string.format(UNIT_TYPE_LEVEL_TEMPLATE, level, localizedClass), 1, 1, 1)
    else
        GameTooltip:AddHeader(UnitName('none'), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
    GameTooltip:AddLine(string.format(LFG_LIST_ITEM_LEVEL_CURRENT, itemLevel), 1, 1, 1)

    if useHonorLevel then
        GameTooltip:AddLine(string.format(LFG_LIST_HONOR_LEVEL_CURRENT_PVP, applicant:GetHonorLevel()), 1, 1, 1)
    end

    local score = applicant:GetDungeonScore() or 0
    if applicant:IsMythicPlusActivity() or score > 0 then
        local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
        GameTooltip:AddLine(format(L['大秘评分：%s'], color:WrapTextInColorCode(score)))
        local info = applicant:GetBestDungeonScore()
        if info and info.mapScore and info.mapScore > 0 then
            local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(info.mapScore) or HIGHLIGHT_FONT_COLOR
            local levelText = format(info.finishedSuccess and "|cff00ff00%d层|r" or "|cff7f7f7f%d层|r", info.bestRunLevel or 0)
            GameTooltip:AddLine(format("当前副本: %s / %s", color:WrapTextInColorCode(info.mapScore), levelText))
        else
            GameTooltip:AddLine(format("当前副本: |cff7f7f7f 无信息|r"))
        end
    end

    if comment and comment ~= '' then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(comment, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
    end

    -- Add statistics
    local stats = C_LFGList.GetApplicantMemberStats(applicant:GetID(), applicant:GetIndex()) or {}
    do
        for k, v in pairs(stats) do
            if v == 0 then
                stats[k] = nil
            end
        end
    end

    if next(stats) then
        GameTooltip:AddSepatator()
        GameTooltip:AddLine(LFG_LIST_PROVING_GROUND_TITLE)

        for _, _v in ipairs(PROVING_GROUND_DATA) do
            for i, v in ipairs(_v) do
                if stats[v.id] then
                    GameTooltip:AddLine(v.text)
                    break
                end
            end
        end
    end

    -- Add Progression
    local activityID = applicant:GetActivityID()
    local progressions = RAID_PROGRESSION_LIST[activityID]
    local progressionValue = applicant:GetProgression()
    local activity = CreatePanel:GetCurrentActivity()
    if progressions and progressionValue then
        GameTooltip:AddSepatator()
        GameTooltip:AddDoubleLine(L['副本经验：'], activity:GetName())
        for i, v in ipairs(progressions) do
            GameTooltip:AddDoubleLine(v.name, GetProgressionTex(progressionValue, i), 1, 1, 1)
        end
    end
    GameTooltip:Show()
end

function MainPanel:CloseTooltip()
    self.GameTooltip:Hide()
end

function MainPanel:OpenRecentPlayerTooltip(player)
    local manager = player:GetManager()
    local tooltip = self.GameTooltip
    tooltip:SetOwner(self, 'ANCHOR_NONE')
    tooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, -10)

    tooltip:SetText(manager:GetName())
    tooltip:AddLine(player:GetNameText())
    tooltip:AddLine(player:GetNotes(), 1, 1, 1, true)
    tooltip:Show()
end

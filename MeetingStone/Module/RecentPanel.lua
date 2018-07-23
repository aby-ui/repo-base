--[[
RecentPanel.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

RecentPanel = Addon:NewModule(CreateFrame('Frame', nil, MainPanel), 'RecentPanel', 'AceEvent-3.0')

function RecentPanel:OnInitialize()
    GUI:Embed(self, 'Refresh')

    MainPanel:RegisterPanel([[|TInterface\ChatFrame\UI-ChatConversationIcon:16|t ]] .. L['最近玩友'], self, 5, 100, 5)

    local function UpdateFilter()
        local class  = self.ClassDropdown:GetValue()
        local role   = self.RoleDropdown:GetValue()
        local search = self.SearchInput:GetText()

        self.MemberList:SetFilterText(search, class, role)
        self.MemberList:Refresh()
    end

    local ActivityLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        ActivityLabel:SetPoint('TOPLEFT', MainPanel, 'TOPLEFT', 70, -30)
        ActivityLabel:SetText(L['活动类型'])
    end

    local ActivityDropdown = GUI:GetClass('Dropdown'):New(self) do
        ActivityDropdown:SetPoint('TOPLEFT', ActivityLabel, 'BOTTOMLEFT', 0, -5)
        ActivityDropdown:SetSize(180, 26)
        ActivityDropdown:SetMaxItem(20)
        ActivityDropdown:SetDefaultValue(0)
        ActivityDropdown:SetDefaultText(L['请选择活动类型'])
        ActivityDropdown:SetCallback('OnSelectChanged', function(_, data)
            self:SetActivity(data.value)
        end)
    end

    local ClassLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        ClassLabel:SetPoint('LEFT', ActivityLabel, 'LEFT', ActivityDropdown:GetWidth() + 10, 0)
        ClassLabel:SetText(L['职业'])
    end

    local ClassDropdown = GUI:GetClass('Dropdown'):New(self) do
        ClassDropdown:SetPoint('TOPLEFT', ClassLabel, 'BOTTOMLEFT', 0, -5)
        ClassDropdown:SetSize(100, 26)
        ClassDropdown:SetDefaultValue(0)
        ClassDropdown:SetDefaultText(L['全部'])

        local list = {} do
            local function checked(item, owner)
                return owner:GetValue() == item.value
            end

            tinsert(list, {
                text      = L['全部'],
                value     = 0,
                checkable = true,
                checked   = checked,
            })
            tinsert(list, { isSeparator = true })

            for i = 1, GetNumClasses() do
                local text, _, id = GetClassInfo(i)

                tinsert(list, {
                    text      = WrapTextInColorCode(text, RAID_CLASS_COLORS[id].colorStr),
                    value     = id,
                    checkable = true,
                    checked   = checked,
                })
            end
        end

        ClassDropdown:SetMenuTable(list)
        ClassDropdown:SetCallback('OnSelectChanged', UpdateFilter)
    end

    local RoleLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        RoleLabel:SetPoint('LEFT', ClassLabel, 'LEFT', ClassDropdown:GetWidth() + 10, 0)
        RoleLabel:SetText(L['职责'])
    end

    local RoleDropdown = GUI:GetClass('Dropdown'):New(self) do
        RoleDropdown:SetPoint('TOPLEFT', RoleLabel, 'BOTTOMLEFT', 0, -5)
        RoleDropdown:SetSize(100, 26)
        RoleDropdown:SetDefaultValue(0)
        RoleDropdown:SetDefaultText(L['全部'])

        local function checked(item, owner)
            return owner:GetValue() == item.value
        end

        RoleDropdown:SetCallback('OnSelectChanged', UpdateFilter)
        RoleDropdown:SetMenuTable({
            {
                text      = L['全部'],
                value     = 0,
                checkable = true,
                checked   = checked,
            },
            {
                isSeparator = true,
            },
            {
                text      = TANK,
                value     = 'TANK',
                checkable = true,
                checked   = checked,
            },
            {
                text      = HEALER,
                value     = 'HEALER',
                checkable = true,
                checked   = checked,
            },
            {
                text      = DAMAGER,
                value     = 'DAMAGER',
                checkable = true,
                checked   = checked,
            },
            {
                text      = NONE,
                value     = 'NONE',
                checkable = true,
                checked   = checked,
            },
        })
    end

    local SearchLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        SearchLabel:SetPoint('LEFT', RoleLabel, 'LEFT', RoleDropdown:GetWidth() + 10, 0)
        SearchLabel:SetText(L['搜索'])
    end

    local SearchInput = GUI:GetClass('SearchBox'):New(self) do
        SearchInput:SetPoint('TOPLEFT', SearchLabel, 'BOTTOMLEFT', 10, -10)
        SearchInput:SetSize(150, 15)
        SearchInput:SetCallback('OnTextChanged', UpdateFilter)
    end

    local BatchDeleteButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        BatchDeleteButton:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 30)
        BatchDeleteButton:SetSize(80, 22)
        BatchDeleteButton:SetText(L['批量删除'])
        BatchDeleteButton:Disable()
        BatchDeleteButton:SetScript('OnClick', function()
            GUI:CallMessageDialog(L['你确定要删除当前列表里的全部玩友吗？'], function(result)
                if result then
                    self:BatchDelete()
                    self:Refresh()
                end
            end)
        end)
    end

    local MemberList = GUI:GetClass('DataGridView'):New(self) do
        MemberList:SetAllPoints(self)
        -- MemberList:SetItemHighlightWithoutChecked(true)
        MemberList:SetItemHeight(32)
        MemberList:SetItemSpacing(1)
        MemberList:SetScrollStep(9)
        -- MemberList:SetSelectMode('MULTI')
        MemberList:SetItemClass(Addon:GetClass('RecentItem'))
        MemberList:SetSortHandler(function(player)
            return player:BaseSortHandler()
        end)
        MemberList:InitHeader{
            {
                key         = 'Flag',
                text        = '@',
                width       = 30,
                style       = 'ICON',
                iconHandler = function(player)
                    return player:IsLeader() and [[Interface\GROUPFRAME\UI-Group-LeaderIcon]] or nil
                end,
                sortHandler = function(player)
                    return player:IsLeader() and 1 or 2
                end
            },
            {
                key         = 'Name',
                text        = L['角色'],
                width       = 150,
                style       = 'LEFT',
                textHandler = function(player)
                    return ' ' .. player:GetNameText()
                end,
                sortHandler = function(player)
                    return player:GetName()
                end
            },
            {
                key         = 'Class',
                text        = L['职业'],
                width       = 50,
                style       = 'ICON',
                iconHandler = function(player)
                    return [[INTERFACE\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]], CLASS_ICON_TCOORDS[player:GetClass()]
                end,
                sortHandler = function(player)
                    return player:GetClass()
                end
            },
            {
                key         = 'Role',
                text        = L['职责'],
                width       = 50,
                style       = 'ICON',
                showHandler = function(player)
                    local ok,l,r,t,b = pcall(GetTexCoordsForRoleSmallCircle, player:GetRole())
                    if not ok then
                        return NONE
                    else
                        return '', 1, 1, 1, [[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]], GetTexCoordsForRoleSmallCircle(player:GetRole())
                    end
                end,
                sortHandler = function(player)
                    return player:GetRole()
                end,
            },
            {
                key         = 'ItemLevel',
                text        = L['装等'],
                width       = 50,
                textHandler = function(player)
                    return player:GetItemLevel()
                end,
                sortHandler = function(player)
                    return 9999 - (player:GetItemLevel() or 0)
                end
            },
            {
                key = 'Activity',
                text = L['活动'],
                width = 150,
                style = 'LEFT',
                textHandler = function(player)
                    return player:GetManager():GetName(), NORMAL_FONT_COLOR:GetRGB()
                end,
                sortHandler = function(player)
                    return player:GetManager():GetCode()
                end
            },
            {
                key         = 'Time',
                text        = L['时间'],
                width       = 150,
                textHandler = function(player)
                    return player:GetTimeText()
                end,
                sortHandler = MemberList:GetSortHandler(),
            },
            {
                key         = 'Notes',
                text        = L['备注'],
                width       = 120,
                style       = 'LEFT',
                enableMouse = true,
                textHandler = function(player)
                    local notes = player:GetNotes()
                    if notes then
                        return notes, HIGHLIGHT_FONT_COLOR:GetRGB()
                    else
                        return L['点击添加备注'], GRAY_FONT_COLOR:GetRGB()
                    end
                end
            },
        }
        MemberList:SetHeaderPoint('BOTTOMLEFT', MemberList, 'TOPLEFT', -2, 2)
        MemberList:SetCallback('OnItemMenu', function(_, anchor, player)
            self:ToggleUnitMenu(anchor, player)
        end)
        MemberList:SetCallback('OnRefresh', function(MemberList)
            return self.BatchDeleteButton:SetEnabled(MemberList:GetItemCount() > 0)
        end)
        MemberList:SetCallback('OnGridClick_Notes', function(_, _, player)
            GUI:CallInputDialog(L['修改备注'], function(result, text)
                if result then
                    self:SetPlayerNotes(player, text)
                end
            end, 'Notes', player:GetNotes(), 64, 260)
        end)
        MemberList:SetCallback('OnItemEnter', function(_, _, player)
            MainPanel:OpenRecentPlayerTooltip(player)
        end)
        MemberList:SetCallback('OnItemLeave', function()
            MainPanel:CloseTooltip()
        end)
        MemberList:RegisterFilter(function(player, ...)
            return player:Match(...)
        end)

        MemberList:Refresh()
    end

    self.ActivityDropdown  = ActivityDropdown
    self.MemberList        = MemberList
    self.BatchDeleteButton = BatchDeleteButton
    self.SearchInput       = SearchInput
    self.ClassDropdown     = ClassDropdown
    self.RoleDropdown      = RoleDropdown

    self:SetScript('OnShow', self.Refresh)
end

function RecentPanel:OnEnable()
    self:RegisterEvent('LFG_LIST_AVAILABILITY_UPDATE')
    self:RegisterMessage('MEETINGSTONE_SETTING_CHANGED_packedPvp', 'LFG_LIST_AVAILABILITY_UPDATE')
end

function RecentPanel:Update()
    if not self.code then
        return
    end

    self.MemberList:SetItemList(Recent:GetRecentList(self.code))
    self.MemberList:Refresh()
end

function RecentPanel:SetActivity(code)
    self.code = code
    self:Refresh()
end

function RecentPanel:SetPlayerNotes(player, notes)
    notes = notes:trim()
    if notes == '' then
        notes = nil
    end

    player:SetNotes(notes)
    self:Refresh()
end

function RecentPanel:LFG_LIST_AVAILABILITY_UPDATE()
    self.ActivityDropdown:SetMenuTable(GetActivitesMenuTable(ACTIVITY_FILTER_OTHER))
end

function RecentPanel:BatchDelete()
    for i = 1, self.MemberList:GetItemCount() do
        local player = self.MemberList:GetItem(i)
        if player then
            player:GetManager():RemoveUnit(player)
        end
    end
end

function RecentPanel:ToggleUnitMenu(anchor, player)
    GUI:ToggleMenu(anchor, {
        {
            isTitle = true,
            text = player:GetNameText(),
        },
        {
            text            = L['修改备注'],
            confirm         = L['修改备注'],
            confirmMaxBytes = 64,
            confirmInput    = 260,
            confirmDefault  = player:GetNotes(),
            func            = function(result, text)
                if result then
                    self:SetPlayerNotes(player, text)
                end
            end,
        },
        {
            text = L['添加好友'],
            func = function(result)
                BNSendFriendInvite(player:GetBattleTag())
            end,
            disabled = not player:GetBattleTag(),
        },
        {
            text = DELETE,
            confirm = L['你确定要删除这条记录吗？'],
            func = function(result)
                if result then
                    player:GetManager():RemoveUnit(player)
                    self:Refresh()
                end
            end
        },
        {
            text = CANCEL,
        }
    }, 'cursor')
end

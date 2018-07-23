--[[
@Date    : 2016-06-06 09:56:06
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

AppFollowQueryPanel = Addon:NewModule(CreateFrame('Frame'), 'AppFollowQueryPanel', 'AceEvent-3.0')

function AppFollowQueryPanel:OnInitialize()
    AppParent:RegisterPanel(L['申请列表'], [[Interface\ICONS\Warlock_GrimoireofService]], self, 6)

    local QueryList = GUI:GetClass('GridView'):New(self) do
        QueryList:SetAllPoints(true)
        QueryList:SetPadding(54, 55, 0, 0)
        QueryList:SetItemHeight(120)
        QueryList:SetColumnCount(2)
        QueryList:SetRowCount(3)
        QueryList:SetScrollStep(6)
        QueryList:SetItemSpacing(2)
        QueryList:SetItemClass(Addon:GetClass('FollowQueryCard'))
        QueryList:SetCallback('OnItemFormatted', function(QueryList, button, data)
            button:SetFollowQuery(data)
        end)

        local ScrollBar = GUI:GetClass('PageScrollBar'):New(QueryList) do
            ScrollBar:SetPoint('BOTTOMRIGHT', MainPanel, 'BOTTOMRIGHT', -10, 3)
        end
        QueryList:SetScrollBar(ScrollBar)
        QueryList:SetCallback('OnAcceptClick', function(_, _, followQuery)
            App:Follow(followQuery:GetName(), followQuery:GetGuid())
        end)
        QueryList:SetCallback('OnCancelClick', function(_, _, followQuery)
            App:FollowIgnore(followQuery:GetName(), followQuery:GetGuid())
        end)
        QueryList:SetCallback('OnRefresh', function(QueryList)
            self.EmptyBlocker:SetShown(QueryList:GetShownCount() == 0)
        end)
    end

    local EmptyBlocker = Addon:GetClass('AppEmptyBlocker'):New(self) do
        EmptyBlocker:SetAllPoints(self)
        EmptyBlocker:SetTextureGroup{
            [[Interface\GLUES\CREDITS\Illidan1]],
            [[Interface\GLUES\CREDITS\Illidan2]],
            [[Interface\GLUES\CREDITS\Illidan3]],
            [[Interface\GLUES\CREDITS\Illidan5]],
            [[Interface\GLUES\CREDITS\Illidan6]],
            [[Interface\GLUES\CREDITS\Illidan7]],
        }
        EmptyBlocker:SetFrameLevel(QueryList:GetFrameLevel() + 10)

        local Title = EmptyBlocker:CreateFontString(nil, 'ARTWORK', 'QuestFont_Super_Huge') do
            Title:SetPoint('TOP', EmptyBlocker, 'TOPRIGHT', -133, -143)
            Title:SetSpacing(9)
            Title:SetTextColor(1, 1, 1)
            Title:SetText(L['没人关注我\n他们这是自寻死路'])
        end
        local SubTitle = EmptyBlocker:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med2') do
            SubTitle:SetPoint('TOP', Title, 'BOTTOM', 0, -25)
            SubTitle:SetText(L['（右击目标头像关注即可添加关注）'])
        end
    end

    self.QueryList = QueryList
    self.EmptyBlocker = EmptyBlocker

    self:RegisterMessage('MEETINGSTONE_APP_FOLLOWQUERYLIST_UPDATE')

    self:SetScript('OnShow', self.OnShow)
end

function AppFollowQueryPanel:OnShow()
    return App:ClearNewFollower()
end

function AppFollowQueryPanel:MEETINGSTONE_APP_FOLLOWQUERYLIST_UPDATE()
    self.QueryList:SetItemList(App:GetFollowQueryList())
    self.QueryList:Refresh()
end

--[[
@Date    : 2016-06-16 19:42:53
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

AppFollowPanel = Addon:NewModule(CreateFrame('Frame'), 'AppFollowPanel', 'AceEvent-3.0')

function AppFollowPanel:OnInitialize()
    GUI:Embed(self, 'Refresh')
    AppParent:RegisterPanel(L['关注记录'], [[Interface\ICONS\TRADE_ARCHAEOLOGY]], self, 6)

    local BgFrame = CreateFrame('Frame', nil, self) do
        BgFrame:SetAllPoints(self)

        local LeftBg = BgFrame:CreateTexture(nil, 'BACKGROUND') do
            LeftBg:SetTexture([[Interface\Store\Store-Main]])
            LeftBg:SetPoint('TOPLEFT', 20, 2)
            LeftBg:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -13, -1)
            LeftBg:SetTexCoord(0.00097656, 0.18261719, 0.6698437525, 0.93652344)
        end

        local LeftName = BgFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
            LeftName:SetFont(LeftName:GetFont(), 19)
            LeftName:SetText(L['角色名'])
        end

        local LeftRealm = BgFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
            LeftRealm:SetFont(LeftRealm:GetFont(), 19)
            LeftRealm:SetText(L['服务器'])
        end

        local RightBg = BgFrame:CreateTexture(nil, 'BACKGROUND') do
            RightBg:SetTexture([[Interface\Store\Store-Main]])
            RightBg:SetPoint('TOPRIGHT', -20, 2)
            RightBg:SetPoint('BOTTOMLEFT', self, 'BOTTOM', 13, -1)
            RightBg:SetTexCoord(0.00097656, 0.18261719, 0.6698437525, 0.93652344)
        end

        local RightName = BgFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
            RightName:SetFont(RightName:GetFont(), 19)
            RightName:SetText(L['角色名'])
        end

        local RightRealm = BgFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
            RightRealm:SetFont(RightRealm:GetFont(), 19)
            RightRealm:SetText(L['服务器'])
        end

        BgFrame.LeftBg     = LeftBg
        BgFrame.LeftName   = LeftName
        BgFrame.LeftRealm  = LeftRealm
        BgFrame.RightBg    = RightBg
        BgFrame.RightName  = RightName
        BgFrame.RightRealm = RightRealm
    end

    local FollowList = GUI:GetClass('GridView'):New(self) do
        FollowList:SetAllPoints(true)
        FollowList:SetPadding(20, 20, 62, 0)
        FollowList:SetItemHeight(24)
        FollowList:SetColumnCount(2)
        FollowList:SetRowCount(10)
        FollowList:SetScrollStep(20)
        FollowList:SetItemSpacing(0, 26)
        FollowList:SetItemClass(Addon:GetClass('FollowItem'))

        local ScrollBar = GUI:GetClass('PageScrollBar'):New(FollowList) do
            ScrollBar:SetPoint('BOTTOMRIGHT', MainPanel, 'BOTTOMRIGHT', -10, 3)
        end
        FollowList:SetScrollBar(ScrollBar)

        FollowList:SetCallback('OnItemFormatted', function(FollowList, button, data)
            button:SetData(data)
        end)

        -- FollowList:SetCallback('OnItemClick', function(FollowList, button, data)
        --     ChatFrame_SendTell(ChatTargetSystemToApp(data.name))
        -- end)

        FollowList:SetCallback('OnRefresh', function(FollowList)
            local empty = FollowList:GetShownCount() == 0
            self.BgFrame:SetShown(not empty)
            self.EmptyBlocker:SetShown(empty)
        end)

        FollowList:SetCallback('OnItemMenu', function(FollowList, button, data)
            self:ToggleFollowMenu(button, data)
        end)

        FollowList:SetItemList(Profile:GetFollowList())
        FollowList:Refresh()
    end

    local EmptyBlocker = Addon:GetClass('AppEmptyBlocker'):New(self) do
        EmptyBlocker:SetAllPoints(self)
        EmptyBlocker:SetTextureGroup{
            [[Interface\GLUES\CREDITS\LichKingTGA1]],
            [[Interface\GLUES\CREDITS\LichKingTGA2]],
            [[Interface\GLUES\CREDITS\LichKingTGA3]],
            [[Interface\GLUES\CREDITS\LichKingTGA5]],
            [[Interface\GLUES\CREDITS\LichKingTGA6]],
            [[Interface\GLUES\CREDITS\LichKingTGA7]],
        }
        EmptyBlocker:SetFrameLevel(FollowList:GetFrameLevel() + 10)
    end

    local SubTitle = EmptyBlocker:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med2') do
        SubTitle:SetPoint('TOP', EmptyBlocker, 'TOPRIGHT', -133, -137)
        SubTitle:SetSpacing(7)
        SubTitle:SetText(L['记住，凡人\n现在我给你一个机会'])
    end

    local Title = EmptyBlocker:CreateFontString(nil, 'ARTWORK', 'QuestFont_Super_Huge') do
        Title:SetPoint('TOP', SubTitle, 'BOTTOM', 0, -22)
        Title:SetSpacing(9)
        Title:SetTextColor(1, 1, 1)
        Title:SetText(L['我将允许你关注他人！'])
    end

    local SubTitle = EmptyBlocker:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med2') do
        SubTitle:SetPoint('TOP', Title, 'BOTTOM', 0, -7)
        SubTitle:SetText(L['（右击目标头像关注即可添加关注）'])
    end

    self.EmptyBlocker = EmptyBlocker
    self.FollowList = FollowList
    self.BgFrame = BgFrame

    self:SetScript('OnSizeChanged', self.OnSizeChanged)

    self:RegisterMessage('MEETINGSTONE_FOLLOWMEMBERLIST_UPDATE', 'Refresh')
end

function AppFollowPanel:OnSizeChanged()
    self.BgFrame.LeftName:SetPoint('TOP', self.BgFrame.LeftBg, 'TOPLEFT', self.BgFrame.LeftBg:GetWidth()/4, -30)
    self.BgFrame.LeftRealm:SetPoint('TOP', self.BgFrame.LeftBg, 'TOPRIGHT', -self.BgFrame.LeftBg:GetWidth()/4, -30)
    self.BgFrame.RightName:SetPoint('TOP', self.BgFrame.RightBg, 'TOPLEFT', self.BgFrame.RightBg:GetWidth()/4, -30)
    self.BgFrame.RightRealm:SetPoint('TOP', self.BgFrame.RightBg, 'TOPRIGHT', -self.BgFrame.RightBg:GetWidth()/4, -30)
end

function AppFollowPanel:Update()
    self.FollowList:Refresh()
end

function AppFollowPanel:ToggleFollowMenu(button, data)
    GUI:ToggleMenu(button, {
        {
            text = data.name,
            isTitle = true,
        },
        -- {
        --     text = L['密语'],
        --     func = function()
        --         ChatFrame_SendTell(ChatTargetSystemToApp(data.name))
        --     end
        -- },
        {
            text = L['关注'],
            func = function()
                App:Follow(data.name, data.guid)
            end
        },
        {
            text = CANCEL
        }
    }, 'cursor')
end

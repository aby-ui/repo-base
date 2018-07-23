--[[
@Date    : 2016-06-08 14:14:39
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

AppParent = Addon:NewModule(GUI:GetClass('LeftTabPanel'):New(MainPanel), 'AppParent', 'AceEvent-3.0', 'AceHook-3.0', 'LibInvoke-1.0')
AppParent:Disable()
AppParent:Hide()

function AppParent:OnInitialize()
    GUI:Embed(self, 'Refresh')

    -- MainPanel:RegisterPanel(L['随身集合石'], self)

    self:SetTopHeight(5)
    self:SetBottomHeight(33)
    self.Title:Hide()

    local Blocker = MainPanel:NewBlocker('AppPanelBlocker', 4) do
        Blocker:SetParent(self)
        Blocker:Show()
        Blocker:Hide()

        Blocker:SetCallback('OnCheck', function()
            return not App:IsConnected() or not App:HasApp()
        end)

        Blocker:SetCallback('OnInit', function(Blocker)
            local Label = Blocker:CreateFontString(nil, 'ARTWORK') do
                Label:SetFont(STANDARD_TEXT_FONT, 32)
                Label:SetShadowColor(0, 0, 0)
                Label:SetShadowOffset(2, -2)
                Label:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
                Label:SetPoint('TOP', 0, -50)
                Label:SetText(L['随身集合石APP'])
            end

            local Connecting = Blocker:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall') do
                Connecting:SetPoint('TOPLEFT', Label, 'BOTTOMRIGHT', 5, -5)
                Connecting:SetText(L['正在连接中，请稍候……'])
                Blocker.Connecting = Connecting
            end

            local QrCode = GUI:GetClass('QRCodeWidget'):New(Blocker) do
                QrCode:SetNoSmall(true)
                QrCode:SetSize(100, 100)
                QrCode:SetPoint('CENTER', 0, 18)
                QrCode:SetMargin(3)
                QrCode:SetValue(APP_DOWNLOAD_URL)
                QrCode:Show()
            end

            local width, height = Blocker:GetSize()
            local topWidth, topHeight = width / 3, width / 3;
            local botWidth, botHeight = topWidth, height - topHeight;

            local BTLT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BTLT:SetSize(topWidth, topHeight)
                BTLT:SetPoint('TOPLEFT')
                BTLT:SetTexture([[Interface\GLUES\CREDITS\Azol01]])
                BTLT:SetAlpha(0.4)
            end

            local BTT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BTT:SetSize(topWidth, topHeight)
                BTT:SetPoint('LEFT', BTLT, 'RIGHT')
                BTT:SetTexture([[Interface\GLUES\CREDITS\Azol02]])
                BTT:SetAlpha(0.4)
            end

            local BTRT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BTRT:SetSize(topWidth, topHeight)
                BTRT:SetPoint('LEFT', BTT, 'RIGHT')
                BTRT:SetTexture([[Interface\GLUES\CREDITS\Azol03]])
                BTRT:SetAlpha(0.4)
            end

            local BBLT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BBLT:SetSize(botWidth, botHeight)
                BBLT:SetPoint('TOP', BTLT, 'BOTTOM')
                BBLT:SetTexture([[Interface\GLUES\CREDITS\Azol05]])
                BBLT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBLT:SetAlpha(0.4)
            end

            local BBT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BBT:SetSize(botWidth, botHeight)
                BBT:SetPoint('LEFT', BBLT, 'RIGHT')
                BBT:SetTexture([[Interface\GLUES\CREDITS\Azol06]])
                BBT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBT:SetAlpha(0.4)
            end

            local BBRT = Blocker:CreateTexture(nil, 'BORDER', nil, 1) do
                BBRT:SetSize(botWidth, botHeight)
                BBRT:SetPoint('LEFT', BBT, 'RIGHT')
                BBRT:SetTexture([[Interface\GLUES\CREDITS\Azol07]])
                BBRT:SetTexCoord(0, 1, 0, botHeight / topHeight)
                BBRT:SetAlpha(0.4)
            end

            local CTLT = Blocker:CreateTexture(nil, 'BORDER', nil, 2) do
                CTLT:SetSize(36, 36)
                CTLT:SetPoint('TOPLEFT', QrCode, 'TOPLEFT', -27, 27)
                CTLT:SetTexture([[Interface\Scenarios\ScenariosParts]])
                CTLT:SetTexCoord(312/512, 344/512, 133/512, 165/512)
            end

            local CTRT = Blocker:CreateTexture(nil, 'BORDER', nil, 2) do
                CTRT:SetSize(36, 36)
                CTRT:SetPoint('TOPRIGHT', QrCode, 'TOPRIGHT', 27, 27)
                CTRT:SetTexture([[Interface\Scenarios\ScenariosParts]])
                CTRT:SetTexCoord(476/512, 508/512, 133/512, 165/512)
            end

            local CBLT = Blocker:CreateTexture(nil, 'BORDER', nil, 2) do
                CBLT:SetSize(36, 36)
                CBLT:SetPoint('BOTTOMLEFT', QrCode, 'BOTTOMLEFT', -27, -27)
                CBLT:SetTexture([[Interface\Scenarios\ScenariosParts]])
                CBLT:SetTexCoord(312/512, 344/512, 172/512, 204/512)
            end

            local CBRT = Blocker:CreateTexture(nil, 'BORDER', nil, 2) do
                CBRT:SetSize(36, 36)
                CBRT:SetPoint('BOTTOMRIGHT', QrCode, 'BOTTOMRIGHT', 27, -27)
                CBRT:SetTexture([[Interface\Scenarios\ScenariosParts]])
                CBRT:SetTexCoord(476/512, 508/512, 172/512, 204/512)
            end

            local function MakeIcon(text, icon, size)
                local Icon = Blocker:CreateTexture(nil, 'ARTWORK') do
                    SetPortraitToTexture(Icon, icon)
                    Icon:SetSize(size, size)
                end

                local Ring = Blocker:CreateTexture(nil, 'ARTWORK', nil, 1) do
                    Ring:SetPoint('CENTER', Icon, 'CENTER')
                    Ring:SetSize(size * 1.25, size * 1.25)
                    Ring:SetTexture([[Interface\TalentFrame\spec-filagree]])
                    Ring:SetTexCoord(0.00390625, 0.27734375, 0.48437500, 0.75781250)
                end

                local Label = Blocker:CreateFontString(nil, 'ARTWORK', nil, 1) do
                    Label:SetPoint('TOP', Icon, 'BOTTOM', 0, -10)
                    Label:SetFont(STANDARD_TEXT_FONT, 21)
                    Label:SetShadowColor(0, 0, 0)
                    Label:SetShadowOffset(2, -2)
                    Label:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
                    Label:SetText(text)
                end
                return Icon
            end

            MakeIcon(L['与游戏聊天互通'], [[Interface\ICONS\TEMP]], 36):SetPoint('BOTTOMRIGHT', Blocker, 'BOTTOM', -240, 86)
            MakeIcon(L['地区排行榜'], [[Interface\ICONS\Trade_Alchemy_DPotion_A22]], 36):SetPoint('BOTTOMRIGHT', Blocker, 'BOTTOM', -67, 86)
            MakeIcon(L['寻找附近玩家'], [[Interface\ICONS\Trade_Archaeology_TheInnkeepersDaughter]], 36):SetPoint('BOTTOMLEFT', Blocker, 'BOTTOM', 67, 86)
            MakeIcon(L['掌上公会'], [[Interface\ICONS\Warrior_talent_icon_SingleMindedFury]], 36):SetPoint('BOTTOMLEFT', Blocker, 'BOTTOM', 240, 86)
        end)

        Blocker:SetCallback('OnFormat', function(Blocker)
            Blocker.Connecting:SetShown(not App:IsConnected())
        end)
    end

    self:SetScript('OnShow', self.Refresh)

    self.Blocker = Blocker
end

function AppParent:OnEnable()
    local FollowButton = CreateFrame('Button', nil, UIParent) do
        FollowButton:SetNormalTexture([[Interface\AddOns\MeetingStone\Media\ButtonUp]])
        FollowButton:SetPushedTexture([[Interface\AddOns\MeetingStone\Media\ButtonDown]])
        FollowButton:SetNormalFontObject('NetEaseFontHighlightSmall')
        FollowButton:SetHighlightFontObject('NetEaseFontNormalSmall')
        FollowButton:SetHitRectInsets(0, 0, 4, 4)
        FollowButton:SetSize(64, 32)
        FollowButton:SetText(L['关注'])
        FollowButton:SetScript('OnEnter', function()
            if PlayerLinkList then
                PlayerLink_StopCount()
            else
                UIDropDownMenu_StopCounting(DropDownList1)
            end
        end)
        FollowButton:SetScript('OnLeave', function()
            if PlayerLinkList then
                PlayerLink_StartCount()
            else
                UIDropDownMenu_StartCounting(DropDownList1)
            end
        end)
        FollowButton:SetScript('OnClick', function(FollowButton)
            App:Follow(FollowButton.name, FollowButton.guid)
            CloseMenus()
        end)
        FollowButton:SetScript('OnHide', FollowButton.Hide)
    end

    self:SecureHook('UnitPopup_ShowMenu')
    self:SecureHook('FriendsFrame_ShowDropdown')
    self:SecureHook('FriendsFrame_ShowBNDropdown')

    self:RegisterMessage('MEETINGSTONE_APP_READY', 'Refresh')

    self.FollowButton = FollowButton
end

function AppParent:Update()
    self.Blocker:Hide()
    MainPanel:UpdateBlockers()
    Profile:ClearProfileKeyNew('appShine')
    if App:HasNewFollower() then
        self:SelectPanel(AppFollowQueryPanel)
    end
end

function AppParent:UnitPopup_ShowMenu(dropdownMenu, which, unit)
    if not UnitIsPlayer(unit) then
        return
    end
    if UnitIsUnit('player', unit) then
        return
    end
    if UnitFactionGroup('player') ~= UnitFactionGroup(unit) then
        return
    end
    self:OpenFollowButton(UnitFullName(unit), UnitGUID(unit))
end

function AppParent:FriendsFrame_ShowDropdown(name, ...)
    if IsChatTargetApp(name) then
        return
    end
    name = GetFullName(name)

    if name == UnitFullName('player') then
        return
    end
    self:OpenFollowButton(name)
end

function AppParent:FriendsFrame_ShowBNDropdown(_, connected, _, _, _, _, bnetIDAccount)
    if not connected then
        return
    end
    local _, _, _, _, _, bnetIDGameAccount, client, isOnline = BNGetFriendInfoByID(bnetIDAccount)
    if not isOnline or client ~= BNET_CLIENT_WOW then
        return
    end
    local _, characterName, client, realmName, _, faction = BNGetGameAccountInfo(bnetIDGameAccount)
    if client ~= BNET_CLIENT_WOW then
        return
    end
    if faction ~= UnitFactionGroup('player') then
        return
    end
    self:OpenFollowButton(GetFullName(characterName, realmName))
end

function AppParent.Invoke:OpenFollowButton(name, guid)
    local parent = PlayerLinkList and PlayerLinkList:IsVisible() and PlayerLinkList or DropDownList1

    self.FollowButton.name = name
    self.FollowButton.guid = guid
    self.FollowButton:SetParent(parent)
    self.FollowButton:SetPoint('CENTER', parent, 'TOPRIGHT', -20, -5)
    self.FollowButton:SetFrameLevel(parent:GetFrameLevel() + 10)
    self.FollowButton:Show()

    if Profile:IsFollowed(name) then
        self.FollowButton:SetText(L['已关注'])
        self.FollowButton:GetNormalTexture():SetDesaturated(true)
        self.FollowButton:GetPushedTexture():SetDesaturated(true)
    else
        self.FollowButton:SetText(L['关注'])
        self.FollowButton:GetNormalTexture():SetDesaturated(false)
        self.FollowButton:GetPushedTexture():SetDesaturated(false)
    end
end

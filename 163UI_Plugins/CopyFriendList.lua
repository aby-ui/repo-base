U1PLUG["CopyFriendList"] = function()

local menu = CreateFrame'Frame'
local btn = WW:Button(nil, FriendsListFrame):ALL(FriendsFrameIcon)
:AddFrameLevel(2, FriendsListFrame)
:RegisterForClicks'AnyUp'
:SetScript('OnClick', function(self, key) ToggleDropDownMenu(1, nil, menu, self, 0, 0) end)
:CreateTexture():SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]]):TL(-10,8):BR(8,-10):ToTexture("Highlight"):up()
:un()

CoreUIEnableTooltip(btn, "点击复制同帐号好友", "点击鼠标按钮会弹出已记录好友的同帐号角色，选中可将其好友复制到本角色中。\n \n撤销上次复制功能可用来删除刚刚复制的好友。")

local curent_user = ('%s - %s'):format(GetRealmName(), UnitName'player')
local waiting = {}

local function copyfriends(_, name)
    wipe(waiting)

    local source = U1DBG.friendlist[curent_user]
    local target = U1DBG.friendlist[name]

    for n in next, target do
        if(not source[n]) then
            tinsert(waiting, n)
        end
    end

    local cur_num = GetNumFriends()
    local fut_num = #waiting

    StaticPopupDialogs.U1_COPY_FRIEND_LIST_CONFIRM.text = '将要添加 <'..
        name .. '> 下 ' .. fut_num .. ' 位好友\n完成后你将会有 '..
        (cur_num + fut_num) .. ' 位好友'

    StaticPopup_Show'U1_COPY_FRIEND_LIST_CONFIRM'
end

local function restore()
    for _, v in next, waiting do
        RemoveFriend(v)
    end
end

local myrealm = GetRealmName()
local myself = string.format('%s - %s', myrealm, UnitName'player')
local function should_show(k)
    if(k == myself) then return false end

    local realm, player = k:match'^(.*) %- (.*)$'
    if(realm and realm == myrealm) then
        return player
    end
end

local info = {}
menu.displayMode = 'MENU'
menu.initialize = function()
    wipe(info)
    info.isTitle = true
    info.notCheckable = true
    info.isNotRadio = true
    info.text = '好友复制'
    UIDropDownMenu_AddButton(info)
    info.isTitle = nil

    wipe(info)
    info.notCheckable = true
    info.isNotRadio = true

    for k, v in next, U1DBG.friendlist do
        local showPlayer = should_show(k)
        if(showPlayer) then
            info.text = showPlayer
            info.func = copyfriends
            info.arg1 = k
            UIDropDownMenu_AddButton(info)
        end
    end

    wipe(info)
    info.isNotRadio = true
    info.notCheckable = true

    info.text = ''
    UIDropDownMenu_AddButton(info)

    info.isNotRadio = true
    info.notCheckable = true
    info.text = '撤销上次复制'
    info.func = restore
    UIDropDownMenu_AddButton(info)
end

StaticPopupDialogs.U1_COPY_FRIEND_LIST_CONFIRM = {preferredIndex = 3,
	--text = '确认将添加选中人物下的所有好友',
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
        for _, v in next, waiting do
            AddFriend(v)
        end
    end,
	--OnCancel = function(self) _copy_id = nil end,
	--OnHide = function(self) _copy_id = nil end,

	hideOnEscape = 1,
	timeout = 0,
	--exclusive = 0,
	whileDead = 1,
}


local function FRIENDLIST_UPDATE()
    U1DBG.friendlist[myself] = U1DBG.friendlist[myself] or {}
    local list = U1DBG.friendlist[myself]

    wipe(list)
    local numFriends = GetNumFriends()
    if(numFriends == 0) then return end

    for i = 1, numFriends do
        local name = GetFriendInfo(i)
        if(name) then
            list[name] = true
        end
    end
end


local init = function()
    U1DBG = U1DBG or {}
    U1DBG.friendlist = U1DBG.friendlist or {}

    CoreOnEvent('FRIENDLIST_UPDATE', FRIENDLIST_UPDATE)
    CoreScheduleTimer(nil, 10, ShowFriends)
    return true
end

if IsLoggedIn() then
    init()
else
    CoreOnEvent('PLAYER_ENTERING_WORLD', init)
end

end
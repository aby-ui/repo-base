U1PLUG["FriendsMenuXPSimple"] = function()
    local currChatType, currChatTarget, currChatFrame --聊天链接点击时的lineID, 用于标记来自聊天链接, 仅当前frame有效

    function UnitPopup_ShowMenu_Hook(dropdownMenu, which, unit, name, userData)
        if which == "PVP_SCOREBOARD" then return end

        if ( UIDROPDOWNMENU_MENU_LEVEL ~= 1 ) then
            do return end

        else
            local notSelf = (name ~= U1UnitFullName("player") and name ~= UnitName("player")) and unit ~= "player"
            local listFrame = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL];
            if listFrame then listFrame.numButtons = listFrame.numButtons - 1; end

            UIDropDownMenu_AddSeparator(UIDROPDOWNMENU_MENU_LEVEL)

            name = name or unit and UnitFullName(unit)
            local isSameRealm = (not name:find("-") or name:find("-"..GetRealmName()))
            local isPlayer = (not unit or UnitIsPlayer(unit))

            if notSelf and CanGuildInvite() and isPlayer and isSameRealm then
                UIDropDownMenu_AddButton({
                    text = LOCALE_zhCN and "邀请入会" or "Guild Invite",
                    func = function() GuildInvite(name) end,
                    notCheckable = true,
                })
            end

            if notSelf and isPlayer and isSameRealm then
                UIDropDownMenu_AddButton({
                    text = LOCALE_zhCN and "查询详情" or "Send Who",
                    func = function() C_FriendList.SendWho(WHO_TAG_EXACT..name) end,
                    notCheckable = true,
                })
            end

            if notSelf and isSameRealm and not unit then
                local nameOnly = name:gsub("%-"..GetRealmName(), "")
                if C_FriendList.GetFriendInfo(nameOnly) then
                    UIDropDownMenu_AddButton({
                        text = REMOVE_FRIEND,
                        func = function()
                            C_FriendList.RemoveFriend(nameOnly)
                            U1Message(format("|Hplayer:%s|h[%s]|h已从好友名单中删除", nameOnly, nameOnly))
                        end,
                        notCheckable = true,
                    })
                elseif isPlayer then
                    UIDropDownMenu_AddButton({
                        text = ADD_FRIEND,
                        func = function() C_FriendList.AddFriend(nameOnly) end,
                        notCheckable = true,
                    })
                end
            end

            if not currChatType then
                UIDropDownMenu_AddButton({
                    text = LOCALE_zhCN and "获取名字" or "Get Name",
                    func = function()
                        CoreUIChatEdit_Insert(unit and UnitFullName(unit) or name, false)
                    end,
                    notCheckable = true,
                })
            end

            if notSelf and currChatType then
                UIDropDownMenu_AddButton({
                    text = "@" .. name:gsub("%-.+", ""),
                    func = function()
                        local chatType = dropdownMenu.chatType
                        currChatFrame.editBox:SetAttribute("chatType", chatType);
                        currChatFrame.editBox:SetAttribute("channelTarget", currChatTarget);
                        ChatFrame_OpenChat("@" .. name:gsub("%-.+", "") .. " ", currChatFrame)
                        --ChatEdit_UpdateHeader(currChatFrame.editBox);
                    end,
                    notCheckable = true,
                })
            end

            UIDropDownMenu_AddButton({ text = CANCEL, notCheckable = true, })
            listFrame:SetClampedToScreen(true)
            --listFrame:SetHeight(listFrame:GetHeight()+150)
        end
    end

    --[[------------------------------------------------------------
    为了得到chatTarget(channelID), 必须在SetItemRef的地方处理
    ---------------------------------------------------------------]]
    local function clear() currChatType = nil  end
    hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, ...)
        --print("UnitPopup_ShowMenu", dropdownMenu == FriendsDropDown, dropdownMenu.lineID, dropdownMenu.chatType, which)
        if dropdownMenu == FriendsDropDown and dropdownMenu.chatType and which == "FRIEND" then
            currChatType = dropdownMenu.chatType
            C_Timer.After(0, clear)
        else
            UnitPopup_ShowMenu_Hook(dropdownMenu, which, ...)
        end
    end)

    hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
        if currChatType then
            local namelink = strsub(link, 8);
            local name, lineID, chatType, chatTarget = strsplit(":", namelink);
            --print("chatLineID", currChatType, name, lineID, chatType, chatTarget)
            if chatType == currChatType then
                currChatTarget = chatTarget
                currChatFrame = chatFrame
                UnitPopup_ShowMenu_Hook(UIDROPDOWNMENU_OPEN_MENU, "FRIEND", nil, FriendsDropDown.friendsDropDownName)
            end
        end
    end)
end
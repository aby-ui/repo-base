local _, U1 = ...

--[=[
local fm = CreateFrame("Frame")
for k, _ in pairs(U1.captureEvents) do fm:RegisterEvent(k) end
fm:SetScript("OnEvent", function(self, event, ...) print(event, ...) end)
--]=]

--[[
--/run C_LFGList.Search(3, {{matches={"王座"}}}, 1, 4, {})

_G.HLFG = function(catId, terms, filter, prefer, language) 
    print("Search =========== catId", catId)
    print("terms:", (Stringfy(terms, "", -1, true, true):gsub("\n", "")))
    print("filter:", (Stringfy(filter, "", -1, true, true):gsub("\n", "")), "prefered:", (Stringfy(prefer, "", -1, true, true):gsub("\n", "")))
    if language then print("language:", (Stringfy(language, "", -1, true, true):gsub("\n", ""))) end
end

hooksecurefunc(C_LFGList, "Search", _G.HLFG);
--]]

CoreRegisterEvent("INIT_COMPLETED", {
    INIT_COMPLETED = function()
        if not U1DBG then return end
        local now = date("%Y%m%d")
        if now >= "20210211" and now <= "20210217" then
            local greetings = {
                {"大年三十啦，愿大家身体健康，万事如意"}, {"初一", "首胜顺利"}, {"初二", "大帝一把过"}, {"初三", "骑上粉火箭"}, {"初四", "进组顺利"}, {"初五", "开出幽灵虎"}, {"初六", "低保到手"}
            }
            if U1DBG.GreetingCNY ~= now then
                U1DBG.GreetingCNY = now
                local day = tonumber(now) - 20210211 + 1
                if greetings[day] then
                    C_Timer.After(3, function()
                        U1Message(#greetings[day] == 1 and greetings[day][1] or "大年"..greetings[day][1].."，爱不易祝您牛年大吉，"..greetings[day][2].."！", 1, 1, 0)
                    end)
                end
            end
        end
    end
})

--[[------------------------------------------------------------
掉线后上线可能看不到释放框，好像是8.0奥迪尔
---------------------------------------------------------------]]
CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = function()
    if ( UnitIsDead("player") and not StaticPopup_Visible("DEATH") ) then
        if ( GetReleaseTimeRemaining() == 0 ) then
            StaticPopup_Show("DEATH");
            local name = StaticPopup_Visible("DEATH")
            if name then _G[name].text:SetText(DEATH_RELEASE_NOTIMER) end
        end
    end
end})

--[[
UnitPopupMenuCommunitiesWowMember COMMUNITIES_WOW_MEMBER
UnitPopupMenuCommunitiesGuildMember COMMUNITIES_GUILD_MEMBER
UnitPopupMenuRaid RAID
UnitPopupMenuBnFriend BN_FRIEND
UnitPopupMenuFriend FRIEND
只有这5个菜单里有安全选项 另外打开DuowanChat会导致好友菜单里没有目标
--]]

hooksecurefunc(UnitPopupManager, "OnUpdate", function(self, elapsed)

    if ( not DropDownList1:IsShown() ) then
        return;
    end

    if ( not UnitPopup_HasVisibleMenu() ) then
        return;
    end

    local tempCount, count;
    for level, dropdownFrame in pairs(OPEN_DROPDOWNMENUS) do
        if(dropdownFrame) then
            count = 0;
            local menu = self:GetMenu(dropdownFrame.which);
            local topLevelButtons = menu:GetButtons();
            local menuButtons;
            if(level == 2) then
                local nestedMenu = topLevelButtons[UIDROPDOWNMENU_MENU_VALUE];
                local nestedMenusButtons = nestedMenu and nestedMenu:GetButtons();
                menuButtons = nestedMenusButtons;
            else
                menuButtons =  topLevelButtons;
            end
            if (menuButtons) then
                local index = 1
                local listId = (level > 1) and 0 or 1; --top level buton 1 is name
                while true do
                    listId = listId + 1
                    local btn = _G["DropDownList"..level.."Button".. listId]
                    if not btn or not btn:IsShown() then
                        break
                    end
                    if btn.iconOnly then --and btn.icon == "Interface\\Common\\UI-TooltipDivider-Transparent" then
                        --seperator continue
                    else
                        local name = btn:GetText()
                        local button
                        while index <= #menuButtons do
                            if menuButtons[index]:GetText() == name then
                                button = menuButtons[index]
                                index = index + 1
                                break
                            end
                            index = index + 1
                        end
                        if button then
                            local shown = button:CanShow();
                            if not shown then
                                --算出来不显示, 实际显示了, 八成是 issecure(), 直接启用不管了
                                --UIDropDownMenu_EnableButton(level, listId)
                            else
                                local enable = UnitPopupSharedUtil:IsEnabled(button);
                                if(button.isSubsectionTitle) then
                                    UIDropDownMenu_DisableButton(level, listId);
                                elseif (not button.isSubsection) then
                                    if (enable) then
                                        UIDropDownMenu_EnableButton(level, listId);
                                    else
                                        UIDropDownMenu_DisableButton(level, listId);
                                    end
                                else
                                    UIDropDownMenu_DisableButton(level, listId);
                                end
                            end
                        else
                            --maybe custom added
                            break
                        end
                    end
                end
            end
        end
    end
end)
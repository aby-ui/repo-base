U1PLUG["FriendsGuildTab"] = function()

local tabs = FriendsFrame.numTabs
local name = "FriendsFrameTab_OpenGuild"
WW:Button(name, FriendsFrame, "FriendsFrameTabTemplate"):SetText(GUILD):LEFT("$parentTab"..tabs, "RIGHT", -14, 0)
:SetScript("OnClick", function()
    if not GuildFrame or not GuildFrame:IsVisible() then
        ToggleFriendsFrame()
        ToggleGuildFrame()
    end
end):un()
_G[name.."Left"]:SetVertexColor(0,1,0) _G[name.."Middle"]:SetVertexColor(0,1,0) _G[name.."Right"]:SetVertexColor(0,1,0)
PanelTemplates_DeselectTab(FriendsFrameTab_OpenGuild)
PanelTemplates_TabResize(FriendsFrameTab_OpenGuild, 0)
--PanelTemplates_SetNumTabs(FriendsFrame, tabs+1) --污染
--PanelTemplates_UpdateTabs(FriendsFrame)

local QUICK_JOIN_SHORT = GetLocale():sub(1,2)=="zh" and "加入" or QUICK_JOIN
hooksecurefunc("FriendsFrame_UpdateQuickJoinTab", function(numGroups)
    FriendsFrameTab4:SetText(QUICK_JOIN_SHORT .. " "..string.format(NUMBER_IN_PARENTHESES, numGroups));
    PanelTemplates_TabResize(FriendsFrameTab4, 0);
end)

CoreDependCall("Blizzard_GuildUI", function()
    GuildFrameTab1:SetPoint("BOTTOMLEFT", -7, -30)
    local tabs = GuildFrame.numTabs
    for i=2, tabs do WW(_G["GuildFrameTab"..i]):LEFT("$parentTab"..(i-1), "RIGHT", -19, 0):un() end
    local name = "GuildFrameTab_OpenFriend"
    WW:Button(name, GuildFrame, "GuildFrameTabButtonTemplate"):SetText(FRIENDS):LEFT("$parentTab"..tabs, "RIGHT", -18, 0)
    :SetScript("OnClick", function()
        if InCombatLockdown() then
            U1Message("战斗中切换窗体会出错，请用热键或暴雪按钮。")
            return
        end
        if not FriendsFrame:IsVisible() then
            ToggleGuildFrame()
            ToggleFriendsFrame(1)
        end
    end):un()
    _G[name.."Left"]:SetVertexColor(0,1,0) _G[name.."Middle"]:SetVertexColor(0,1,0) _G[name.."Right"]:SetVertexColor(0,1,0)
    PanelTemplates_DeselectTab(GuildFrameTab_OpenFriend);
    --PanelTemplates_SetNumTabs(GuildFrame, tabs+1)
    --PanelTemplates_UpdateTabs(GuildFrame)
    return 1
end)

end
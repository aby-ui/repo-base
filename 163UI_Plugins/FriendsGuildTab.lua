--[[------------------------------------------------------------
旧公会界面
---------------------------------------------------------------]]
do
    SLASH_OLD_GUILD1 = "/oldguild"
    SlashCmdList["OLD_GUILD"] = function(msg)
        local n = "Blizzard_GuildUI"
        if not IsAddOnLoaded(n) and GuildFrame_LoadUI then
            GuildFrame_LoadUI()
        end

        if GuildFrame then
            CoreUIToggleFrame(GuildFrame)
        end
    end
end

U1PLUG["FriendsGuildTab"] = function()
    local tabs = FriendsFrame.numTabs
    local name = "FriendsFrameTab_OpenGuild"
    local button = WW:Button(name, FriendsFrame, "MainMenuBarMicroButton"):LEFT("$parentTab"..tabs, "RIGHT", 4, 0)
            :SetScript("OnClick", function() if IsControlKeyDown() then SlashCmdList["OLD_GUILD"]() else ToggleGuildFrame() end end)
            :SetScript("OnShow", MicroButton_KioskModeDisable)
            :un()

    --GuildMicroButtonMixin:OnLoad()
    LoadMicroButtonTextures(button, "GuildCommunities");
    button.tooltipAnchorPoint = "ANCHOR_BOTTOMLEFT"
    CoreUIEnableTooltip(button, MicroButtonTooltipText(LOOKINGFORGUILD, "TOGGLEGUILDTAB"), "爱不易小功能: 好友面板工会按钮\n按住CTRL点击可以打开旧工会界面")

    if ( IsCommunitiesUIDisabledByTrialAccount() ) then
        button:Disable();
        button.disabledTooltip = ERR_RESTRICTED_ACCOUNT_TRIAL;
    end
    if (Kiosk.IsEnabled()) then
        button:Disable();
    end
end
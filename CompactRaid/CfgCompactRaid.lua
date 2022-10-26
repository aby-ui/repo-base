U1RegisterAddon("CompactRaid", {
    temporarilyForceDisable = 1,
    title = "团队框架CR",
    defaultEnable = 0,
    load = "NORMAL",
    optionsAfterLogin = 1,
    tags = { TAG_RAID, TAG_BIG },
    icon = [[Interface\Icons\Achievement_BG_3flagcap_nodeaths]],
    desc = "此团队框架已经很久没有维护了，准备从整合包中移除，推荐使用功能强大的Cell",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if justload then
            if U1IsInitComplete() then
                LibAddonManager._eventFrame:GetScript("OnEvent")(LibAddonManager._eventFrame, "PLAYER_LOGIN")
            end
        end
    end,
});

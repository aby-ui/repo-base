U1RegisterAddon("CompactRaid", {
    title = "团队框架CR",
    defaultEnable = 0,
    load = "NORMAL",
    optionsAfterLogin = 1,
    tags = { TAG_RAID, TAG_BIG },
    icon = [[Interface\Icons\Achievement_BG_3flagcap_nodeaths]],
    desc = "美化和增强暴雪自带的团队框架，与GIRD功能重复，建议开启后关闭GRID",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if justload then
            if U1IsInitComplete() then
                LibAddonManager._eventFrame:GetScript("OnEvent")(LibAddonManager._eventFrame, "PLAYER_LOGIN")
            end
        end
    end,
});

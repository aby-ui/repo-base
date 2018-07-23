U1RegisterAddon("ErrorFilter", {
    title = "失败消息屏蔽",
    defaultEnable = 1,

    tags = { TAG_MANAGEMENT },
    icon = [[Interface\Icons\inv_misc_thornnecklace]],
    desc = "屏蔽屏幕中央上方的部分红字提示，防止一些不必要的提示遮挡视线。可以选择要屏蔽那些信息，比如'距离太远','技能还没有准备好'等等，详细内容参见'配置选项'",

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["ErrorFilter"]() end,
    },
});

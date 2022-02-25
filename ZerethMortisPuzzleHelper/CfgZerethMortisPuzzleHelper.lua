U1RegisterAddon("ZerethMortisPuzzleHelper", {
    title = "源锁解谜助手",
    defaultEnable = 1,
    load = "LATER",

    tags = { TAG_MAPQUEST },
    icon = [[Interface\Icons\inv_trinket_80_titan02c]],

    desc = "9.2扎雷殁提斯源锁解谜助手，源锁解谜界面自动启用",

    {
        text = "设置选项",
        callback = function(cfg, v, loading) SlashCmdList["zmph"]("") end,
    },
});
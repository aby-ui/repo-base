U1RegisterAddon("TomTom", {
    title = "目标点路径指示",
    defaultEnable = 0,
    load = "LOGIN", --later的话，POI点击会没有hook
    frames = { "TomTomBlock", "TomTomCrazyArrow" },
    nopic = true,

    desc = "目标路径点指示器",
    tags = { TAG_MAPQUEST },
    icon = [[Interface\Icons\misc_arrowlup]],

    {
        text = "配置选项",
        callback = function() SlashCmdList["TOMTOM"]("") end
    }
});

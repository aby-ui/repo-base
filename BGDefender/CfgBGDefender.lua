U1RegisterAddon("BGDefender", {
    title = "PVP战场求助",
    defaultEnable = 0,
    load = "LATER",
    frames = {"BGDefenderFrame"},

    tags = { TAG_PVP },
    icon = [[Interface\Icons\Ability_Physical_Taunt]],
    desc = "一个小框架方便跟对战场内的其他玩家交流或求助.``显示通报窗口：/bgd",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if U1IsInitComplete() and enable then
            BGD_Toggle(true)
        elseif not enable then
            BGD_Toggle(false)
        end
    end,

    {
        text = "显示/隐藏界面",
        tip = "说明`快捷命令 /bgd",
        callback = function(cfg, v, loading)
            SlashCmdList["BGDefender"]("")
        end,
    },

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            BGD_Options_Open()
        end,
    },

    {
        text = "重置所有控制台设定",
        confirm = "是否确定？",
        callback = function(cfg, v, loading)
            BGD_Prefs = nil;
            ReloadUI();
        end,
    },

});

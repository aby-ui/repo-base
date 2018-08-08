U1RegisterAddon("GearHUD", {
    title = "齿轮血量提示",
    tags = {TAG_COMBATINFO, },
    icon = [[Interface\Icons\INV_Misc_Gear_01]],
    desc = "当血量危急时，在屏幕中央显示红色齿轮警示（模仿单机游戏战争机器），防止在紧张的战斗中忘记自身的血量信息。`运行/gh解锁框体可缩放和拖动，运行/gh debug可显示各种警告程度的演示。",
    author = "|cffcd1a1c[爱不易原创]|r",

    frames = {"GearHud"},
    defaultEnable  = 1,
    
    toggle = function(name, info, enable, justload)
        togglehook(nil, "GearHud_OnEvent", noop, not enable);
        if not enable then
            GearHud:Hide()
        else
            GearHud:Show()
            GearHud_Update(0);
        end
    end,

    {
        type="button",
        text="锁定/解锁",
        tip="快捷命令`/gh",
        tip="可拖动右下边角进行缩放",
        callback = function(cfg, v, loading)
            SlashCmdList["GEARHUD"]()
        end
    },
    {
        type="button",
        text="效果测试",
        tip="快捷命令`/gh debug",
        callback = function(cfg, v, loading)
            SlashCmdList["GEARHUD"]("debug")
        end,
    },
    {
        type="button",
        text="重置位置",
        tip="快捷命令`/gh reset",
        callback = function(cfg, v, loading)
            SlashCmdList["GEARHUD"]("reset")
            SlashCmdList["GEARHUD"]("debug")
        end,
    },
});

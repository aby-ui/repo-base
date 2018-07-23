U1RegisterAddon("BattlegroundTargets", {
    title = "PVP战场框体",
    defaultEnable = 0,
    load = "LOGIN",

    tags = { TAG_PVP },
    icon = [[Interface\Icons\INV_Gizmo_Poltryiser_01]],
    desc = "显示全部战场敌人。战场简洁敌对单位框体.`` 设置方法： 点选开启后，点击信息条上的红色靶标图形，叫出设置。",
    nopic = 1,

    {
        text = "显示设置界面",
        tip = "说明`快捷命令 /bgt",
        callback = function(cfg, v, loading)
            SlashCmdList["BATTLEGROUNDTARGETS"]("")
        end,
    },

    {
        text = "重置所有控制台设定",
        confirm = "是否确定？",
        callback = function(cfg, v, loading)
            BattlegroundTargets_Options = nil;
            ReloadUI();
        end,
    },

});

U1RegisterAddon("BattleGroundEnemies", {
    title = "PVP战场框体",
    defaultEnable = 0,
    load = "LOGIN",

    tags = { TAG_PVP },
    icon = [[Interface\Icons\INV_Gizmo_Poltryiser_01]],
    desc = "显示全部战场敌人。战场简洁敌对单位框体.",
    nopic = 1,

    {
        text = "显示设置界面",
        tip = "说明`快捷命令 /bge",
        callback = function(cfg, v, loading)
            SlashCmdList["BattleGroundEnemies"]("")
        end,
    },

    {
        text = "测试模式",
        callback = function(cfg, v, loading)
            if BattleGroundEnemies.TestmodeActive then --disable testmode
                BattleGroundEnemies.BGSize = false
                BattleGroundEnemies:DisableTestMode()
            else --enable Testmode
                BattleGroundEnemies:BGSizeCheck(15)
                BattleGroundEnemies:EnableTestMode()
            end
        end
    },

    {
        text = "重置所有设定",
        confirm = "是否确定？",
        callback = function(cfg, v, loading)
            BattleGroundEnemiesDB = nil;
            ReloadUI();
        end,
    },

});

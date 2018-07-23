U1RegisterAddon("TrufiGCD", {
    title = "技能序列提示",
    defaultEnable = 0,

    tags = { TAG_COMBATINFO },
    icon = "Interface\\Icons\\ABILITY_MONK_PATHOFMISTS",
    nopic = 1,
    desc = "显示你施放的所有技能，以序列方式滚动，给游戏多一点点动态，多一点点激情。``支持按钮皮肤美化, 拖动第一个图标可以改变位置``也可以设置显示小队队员、竞技场对手、目标或焦点使用的技能，需要在设置里打开",

    {
        text = "配置选项",
        callback = function(info, v, loading)
            U1Frame:Hide()
            SlashCmdList.TRUFI("")
        end
    },
    {
        text = '重置配置',
        confirm = "本插件所有设置将清除，无法恢复。请问您是否确定？",
        callback = function()
            TrufiGCDGlSave, TrufiGCDChSave = nil, nil
            ReloadUI();
        end
    },
})
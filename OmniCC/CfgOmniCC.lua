
U1RegisterAddon("OmniCC", {
    title = "技能冷却计时",
    defaultEnable = 1,
    load = "LOGIN",

    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\INV_Qiraj_JewelGlyphed]],
    desc = "给所有的技能冷却动画添加文字显示及冷却后的效果。",
    nopic = 1,

    {
        text="配置选项",
        callback = function(cfg, v, loading)
            SlashCmdList["OmniCC"]()
        end,
    },
});

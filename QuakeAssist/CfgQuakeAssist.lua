U1RegisterAddon("QuakeAssist", {
    title = "震荡助手",
    defaultEnable = 1,
    load = 'LOGIN',

    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\Spell_Nature_Earthquake]],
    desc = "大秘境震荡词缀触发时，对比当前施法进度和震荡触发进度，必要时会提示‘停止施法’，设置命令/qa",
    nopic = 1,
    toggle = function(name, info, enable, justload) end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList.QUAKEASSIST("") end,
    },

});
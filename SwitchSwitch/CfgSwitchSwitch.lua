U1RegisterAddon("SwitchSwitch", {
    temporarilyForceDisable = 1,
    title = "天赋方案切换",
    defaultEnable = 1,

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\inv_7xp_inscription_talenttome02]],
    desc = "在天赋面板上方增加一个预设方案的下拉菜单，可以保存天赋方案快速切换",

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList.SwitchSwitch("config") end,
    },
});

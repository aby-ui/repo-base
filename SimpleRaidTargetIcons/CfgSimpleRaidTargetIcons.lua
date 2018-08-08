U1RegisterAddon("SimpleRaidTargetIcons", {
    title = "快速标记助手",
    defaultEnable = 1,
    --optionsAfterVar = 1,

    tags = { TAG_RAID },
    icon = [[Interface\Icons\Ability_Xaril_MasterPoisoner_White]],
    desc = "双击任意单位或者目标头像，会弹出圆形排列的标记按钮，可用来快速标记团队目标。`也可按住Ctrl键（可配置）单击鼠标进行标记。`运行'/srti'，可开启配置界面。",

    --author = "|cffcd1a1c[爱不易原创]|r",
    --modifier = "|cffcd1a1c[爱不易]|r",

    --toggle = function(name, info, enable, justload) end,

    {
        text = "配置选项",
        tip = "快捷命令`/srti",
        callback = function(cfg, v, loading) SlashCmdList["SRTI"]("") end,
    },
    --[[------ Options --------
    {
        var = "",
        default = "",
        text = "",
        callback = function(cfg, v, loading) end,
    },
    --]]
});

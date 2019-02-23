U1RegisterAddon("Decursive", {
    title = "一键驱散",
    defaultEnable = 0,
    load = "LOGIN",

    tags = { TAG_RAID, TAG_CLASS, TAG_MAGE, TAG_PALADIN, TAG_PRIEST, TAG_SHAMAN, TAG_DRUID, TAG_MONK, TAG_WARLOCK },
    icon = [[Interface\Icons\inv_misc_cat_trinket05]],
    desc = "方便驱散自身和队友负面状态的插件。启用后会在屏幕右侧显示一个个小方格，如果对应的团员中了可驱散的状态，会用显著的颜色标示，点击即可驱散该状态。`框体的左上角有一个小方块可以用来拖动位置及打开设置菜单等。`插件有很多命令，都是以dcr开头的：`/dcr`/dcrshow`/dcrreset`/dcrshoworder 等等",

    toggle = function(name, info, enable, justload)
        if not justload then
            if enable then
                SlashCmdList["ACECONSOLE_DCR"]("enable");
            else
                SlashCmdList["ACECONSOLE_DCR"]("disable");
                StaticPopup1:Hide()
            end
        end
    end,
    -------- Options --------
    {
        text = "运行命令/dcrshow",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DCRSHOW"]() end,
    },
    {
        text = "配置选项",
        tip = "快捷命令`/decursive",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_DECURSIVE"]() end,
    },
    --]]
});

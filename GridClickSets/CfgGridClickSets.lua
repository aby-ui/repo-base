U1RegisterAddon("GridClickSets", {
    title = "点击施法",
    defaultEnable = 1,
    load = "NORMAL", --否则无法hook compact raid

    tags = { TAG_RAID },
    icon = [[Interface\Icons\INV_Pet_LilSmoky]],
    desc = "给团队面板或Grid团队框架增加点击施法的设置，提供各职业的默认设置，基本不需配置即可使用。`通过配置界面可以给各个鼠标按键配置预设技能、技能名称、甚至是宏，支持鼠标滚轮施法。`设置宏时，用##代替对应单位，例如/cast [target=##]治疗波。`配置界面入口可以在Grid设置页和暴雪团队控制界面中找到，也可以直接运行快捷命令：/cs。",

    author = "|cffcd1a1c[爱不易原创]|r",

    --toggle = function(name, info, enable, justload) end,

    -------- Options --------
    {
        text = "配置修改点击操作",
        tip = "快捷命令`/cs或/clickset",
        callback = function(cfg, v, loading) SlashCmdList["CLICKSET"]() end,
    },

    {
        text = '清除所有配置',
        tip = "说明`清除当前角色所有专精的配置，恢复成预设方案",
        confirm = "本插件所有设置将清除，无法恢复。请问您是否确定？",
        callback = function()
            GridClickSetsForTalents = {}
        end
    },
    --]]
});
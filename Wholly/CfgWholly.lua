U1RegisterAddon("Wholly", {
    title = "可接任务查询",
    tags = {TAG_MAPQUEST, TAG_BIG},
    load = "NORMAL",
    parent = "",
    defaultEnable = 0,
    ignoreLoadAll = 1,

    author = "Scott M Harrison",
    desc = "Wholly & Grail``(请手工启用, 加载时间较长)``在大地图上显示'可接任务'按钮, 可以显示任务给予人的位置, 右键点击可以显示过滤设置。``/wholly可以在单独的窗口中显示当前地图可接任务列表。",
    nopic = 1,
    icon = [[Interface\AddOns\Wholly\exclamation.blp]],

    runBeforeLoad = function() EnableAddOn("Grail-Quests-zhCN") end,

    {
        type="button",
        text="配置选项",
        callback = function() InterfaceOptionsFrame_OpenToCategory("Wholly") end
    },
    {
        type="button",
        text="任务列表窗口",
        callback = function() SlashCmdList["WHOLLY"]() end
    },
});

--依赖的Grail库, 不再单独写Cfg
U1RegisterAddon("Grail", { parent = "Wholly", load = "DEMAND", protected = 1, ignoreLoadAll = 1, title = "库:任务数据", }) --需要在toc里设置## LoadOnDemand: 1
U1RegisterAddon("Grail-Achievements", { load = "DEMAND", protected = 1, hide = 1, })
U1RegisterAddon("Grail-Reputations", { load = "DEMAND", protected = 1, hide = 1, })
U1RegisterAddon("Grail-When", { load = "DEMAND", protected = 1, hide = 1, })
U1RegisterAddon("Grail-Rewards", { load = "DEMAND", protected = 1, hide = 1, })
U1RegisterAddon("Grail-Quests-zhCN", { title = "任务名称本地化-简中", load = "DEMAND", defaultEnable = 1, })
U1RegisterAddon("Grail-Quests-zhTW", { title = "任务名称本地化-繁中", load = "DEMAND", defaultEnable = 0, })
U1RegisterAddon("Grail-Quests-enUS", { title = "任务名称本地化-英文", load = "DEMAND", defaultEnable = 0, })

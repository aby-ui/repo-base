U1RegisterAddon("Cell", {
    title = "Cell团队框架",
    load = "NORMAL",
    tags = { TAG_RAID, TAG_BIG },
    icon = "Interface\\Icons\\ability_racial_combatanalysis",
    nopic = 1,
    author = "篠崎-影之哀伤",
    defaultEnable = 0,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "冷却动画使用暴雪样式",
        tip = "说明`Cell默认的小图标冷却动画是自上而下的独创效果，如果不习惯可以打开此选项，此功能为Cell内置的代码片段，爱不易将其内置，方便大家使用。",
        var = "cdBlizStyle",
        reload = 1,
    },

    {
        text = "打开设置窗口",
        callback = function(cfg, v, loading)
            Cell.funcs:ShowOptionsFrame()
        end,
    },
})
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
        text = "损失血量条始终作为背景",
        tip = "说明`Cell默认损失血量条是拼接在血条后面，打开这个选项可以按照之前Grid等方式，损失血量条始终覆盖整个单位背景，这样超出距离会有一些颜色的变化，但是会和非100%的血条透明度冲突，请按自己习惯选择。",
        var = "LossBarBG",
        reload = 1,
    },

    {
        text = "打开设置窗口",
        callback = function(cfg, v, loading)
            Cell.funcs:ShowOptionsFrame()
        end,
    },
})
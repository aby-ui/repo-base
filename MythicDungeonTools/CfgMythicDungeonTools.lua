U1RegisterAddon("MythicDungeonTools", {
    title = "大秘路线",
    defaultEnable = 0,
    load = "NORMAL",
    minimap = "LibDBIcon10_MythicDungeonTools",

    tags = { TAG_RAID, },
    icon = "Interface\\ICONS\\inv_relics_hourglass",
    desc = "用于规划大秘境小怪进度的强力插件，命令： /mdt``可以访问国外网站`    https://wago.io/mdt `导入一些预案",
    pics = 0,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "开启窗口",
        callback = function(cfg, v, loading) MDT:ShowInterface() end,
    },
})

U1RegisterAddon("MethodDungeonTools", { title = "大秘路线旧版本兼容", load = "NORMAL", protected = 1, hide = 1 })
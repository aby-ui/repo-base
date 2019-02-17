U1RegisterAddon("MethodDungeonTools", {
    title = "大秘路线",
    defaultEnable = 0,
    load = "NORMAL",
    minimap = "LibDBIcon10_MethodDungeonTools",

    tags = { TAG_RAID, },
    icon = "Interface\\AddOns\\MethodDungeonTools\\Textures\\MethodMinimap",
    desc = "用于规划大秘境小怪进度的强力插件，命令： /mdt``可以访问国外网站`    https://wago.io/mdt `导入一些预案",
    pics = 0,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "开启窗口",
        callback = function(cfg, v, loading) MethodDungeonTools:ShowInterface() end,
    },
})
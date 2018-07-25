U1RegisterAddon("WeakAuras", {
    title = "WeakAuras2",
    defaultEnable = 0,
    load = "NORMAL",

    tags = { TAG_BIG, TAG_COMBATINFO, },
    icon = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\icon.blp",
    desc = "简单又强大的状态监控模块，和TellMeWhen任选一个喜欢的就好，https://wago.io/weakauras 有一些字符串可以导入",

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList.WEAKAURAS("") end,
    },
});

U1RegisterAddon("WeakAurasModelPaths", {title = "WeakAuras:材质路径库", protected = nil, hide = nil });
U1RegisterAddon("WeakAurasOptions", {title = "WeakAuras:配置界面", protected = nil, hide = nil });
U1RegisterAddon("WeakAurasTemplates", {title = "WeakAuras：预设模板", protected = nil, hide = nil });

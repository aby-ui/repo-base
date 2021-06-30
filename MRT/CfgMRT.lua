U1RegisterAddon("MRT", {
    title = "团长工具",
    tags = { TAG_GOOD, TAG_RAID, TAG_BIG },
    desc = "强大的团队副本工具",
    load = "NORMAL",
    defaultEnable = 0,
    nopic = 1,
    icon = [[Interface\AddOns\MRT\media\MiniMap]],

    toggle = function(name, info, enable, justload)
        return true
    end,

    { text = "主界面", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("set") end },
    { text = "团员检查", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("raid") end },
    { text = "战术板", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("note") end },
    { text = "编辑战术板", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("edit note") end },
    { text = "标记助手", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("mm") end },
    { text = "切换小地图按钮", callback = function(cfg, v, loading) SlashCmdList["mrtSlash"]("icon") end },
});

U1RegisterAddon("ExRT", { title = "团长工具兼容", load = "NORMAL", protected = 1, hide = 1 })

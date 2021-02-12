U1RegisterAddon("OmniCD", {
    title = "队友冷却监控",
    defaultEnable = 1,
    load = "LOGIN",

    tags = { TAG_COMBATINFO, },
    icon = [[Interface\AddOns\OmniCD\Media\logo64]],

    desc = "在小队框架或独立显示队友的打断爆发等重要技能冷却计时，部分功能和ExRT重复。",
    toggle = function(name, info, enable, justload)
    end,

    {
        text = "配置选项",
        tip = "快捷命令`/omnicd",
        callback = function(cfg, v, loading) SlashCmdList["OmniCD"]("") end,
    },
});
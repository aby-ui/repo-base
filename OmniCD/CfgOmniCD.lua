U1RegisterAddon("OmniCD", {
    title = "队友技能监控",
    defaultEnable = 0,
    load = "LATER",
    --optdeps = { "Grid", "CompactRaid", "ShadowedUnitFrames" },

    tags = { TAG_COMBATINFO, },
    icon = [[Interface\AddOns\OmniCD\Media\omnicd-logo64]],

    desc = "在小队框架或独立显示队友的打断爆发等重要技能冷却计时，部分功能和ExRT重复。",
    toggle = function(name, info, enable, justload)
    end,

    {
        text = "配置选项",
        tip = "快捷命令`/omnicd",
        callback = function(cfg, v, loading) SlashCmdList["OmniCD"]("") end,
    },
});
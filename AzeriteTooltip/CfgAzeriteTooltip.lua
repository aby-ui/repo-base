U1RegisterAddon("AzeriteTooltip", {
    title = "装备特质显示",
    defaultEnable = 1,
    load = "LATER",
    tags = {TAG_ITEM, TAG_GOOD},
    icon = 1869493,
    {
        text = "配置选项",
        callback = function() SlashCmdList["AZERITETOOLTIP"]() end,
    },
    {
        var = "OnlySpec",
        text = '仅显示当前专精适用的特质',
        getvalue = function() return AzeriteTooltipDB.OnlySpec end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.OnlySpec = v
        end,
    },
    {
        var = "Compact",
        text = '简洁模式（仅显示图标）',
        getvalue = function() return AzeriteTooltipDB.Compact end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.Compact = v
        end,
    },
})
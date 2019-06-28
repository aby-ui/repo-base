U1RegisterAddon("AzeriteTooltip", {
    title = "装备特质显示",
    defaultEnable = 1,
    load = "LATER",
    tags = {TAG_ITEM, TAG_GOOD},
    optionsAfterVar = 1,
    icon = 1869493,
    {
        text = "配置选项",
        callback = function() SlashCmdList["AZERITETOOLTIP"]() end,
    },
    {
        var = "OnlySpec",
        text = '仅显示当前专精适用的特质',
        default = false,
        getvalue = function() return AzeriteTooltipDB.OnlySpec end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.OnlySpec = v
            if AzeriteTooltipOptions and AzeriteTooltipOptions.Refresh then AzeriteTooltipOptions:Refresh() end
        end,
    },
    {
        var = "HideBliz",
        text = '移除暴雪默认说明文字',
        default = true,
        getvalue = function() return AzeriteTooltipDB.RemoveBlizzard ~= false end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.RemoveBlizzard = v
            if AzeriteTooltipOptions and AzeriteTooltipOptions.Refresh then AzeriteTooltipOptions:Refresh() end
        end,
    },
    {
        var = "Bags",
        text = '背包物品显示特质图标',
        default = true,
        getvalue = function() return AzeriteTooltipDB.Bags ~= false end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.Bags = v
            if AzeriteTooltipOptions and AzeriteTooltipOptions.Refresh then AzeriteTooltipOptions:Refresh() end
            AzeriteTooltipRefreshTextures("Bags", v)
        end,
    },
    {
        var = "Flyout",
        text = '角色装备栏显示特质图标',
        default = true,
        getvalue = function() return AzeriteTooltipDB.Flyout ~= false end,
        callback = function(cfg, v, loading)
            AzeriteTooltipDB.Flyout = v
            if AzeriteTooltipOptions and AzeriteTooltipOptions.Refresh then AzeriteTooltipOptions:Refresh() end
            AzeriteTooltipRefreshTextures("Flyout", v)
        end,
    },
})
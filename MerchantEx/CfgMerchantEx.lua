U1RegisterAddon("MerchantEx", {
    title = "自动修理贩卖",
    defaultEnable = 1,
    optionsAfterVar = 1,

    tags = { TAG_TRADING, },
    icon = [[Interface\Icons\INV_GIZMO_MANAPOTIONPACK]],
    desc = "商人助手插件，在商人面板右上有设置按钮，提供自动出售灰色物品、自动修理、自动购入施法材料等功能。`快捷命令：/merchantex",

    --toggle = function(name, info, enable, justload) end,

    ---[[------ Options --------
    {
        var = "repair",
        default = 1,
        text = "自动修理",
        getvalue = function() return MerchantExDB.option.repair end,
        callback = function(cfg, v, loading) MerchantExDB.option.repair = v end,
        {
            var = "guild",
            default = 1,
            text = "尽可能使用公会资金",
            getvalue = function() return MerchantExDB.option.guild end,
            callback = function(cfg, v, loading) MerchantExDB.option.guild = v end,
        }
    },
    {
        var = "sell",
        default = 1,
        text = "自动出售灰色物品",
        tip = "说明`可进一步设置要出售的白色物品, 请通过配置选项增加列表",
        getvalue = function() return MerchantExDB.option.sell end,
        callback = function(cfg, v, loading) MerchantExDB.option.sell = v end,
        {
            var = "details",
            default = nil,
            text = "显示出售物品列表",
            getvalue = function() return MerchantExDB.option.details end,
            callback = function(cfg, v, loading) MerchantExDB.option.details = v end,
        }
    },
    {
        var = "buy",
        default = 1,
        text = "自动补购材料",
        tip = "说明`请通过配置选项设置需要购买的材料及数量",
        getvalue = function() return MerchantExDB.option.buy end,
        callback = function(cfg, v, loading) MerchantExDB.option.buy = v end,
    },
    {
        text = "配置选项",
        tip = "快捷命令`/merchantex",
        callback = function(cfg, v, loading) SlashCmdList["MERCHANTEX"]() end,
    },

    --]]
});

U1RegisterAddon("BuyEmAll", {
    parent = "MerchantEx",
    title = "批量购买助手",
    defaultEnable = 1,
    desc = "提供比默认批量购买更方便的批量购买界面，并且支持金币之外的购买，使用时请小心，有些货物无法退换。",
})
U1RegisterAddon("AuctionLite", {
    title = "拍卖助手",
    defaultEnable = 1,

    tags = { TAG_TRADING },
    icon = [[Interface\Icons\INV_Misc_Coin_02]],
    desc = "在拍卖行界面中增加|cffffffff'竞标助手'|r和|cffffffff'拍卖助手'|r两个扩展页，在'竞标助手'中可以搜索要购买的物品及数量后，批量购买（需多次点击确认）；拍卖时可以自动比价，并根据预设的压价方案（百分比或固定值）进行压价。`此外还可保存物品的拍卖价格并显示在鼠标提示中。``配置的快捷命令：`/auctionlite config",
    pics = 2,

    --toggle = function(name, info, enable, justload) end,
    {
        text = "配置选项",
        tip = "快捷命令`/auctionlite config",
        callback = function(cfg, v, loading) CoreIOF_OTC(AuctionLite.optionFrames.sell) end,
    },
});

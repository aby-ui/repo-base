U1RegisterAddon("Auctionator", {
    title = "拍卖小助手",
    load = "NORMAL",
    defaultEnable = 1,

    tags = { TAG_TRADING },
    desc = "老牌拍卖助手，功能较多，爱不易作者只会用拍卖行价格扫描功能，其他的请自行研究。",
    icon = [[Interface\Icons\INV_Misc_Coin_16]],

    ------- Options --------
    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            AuctionatorConfigTabMixin:OpenOptions()
        end
    }
});

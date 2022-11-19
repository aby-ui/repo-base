U1RegisterAddon("AdiBags", {
    title = "阿迪背包整合",
    load = "LOGIN",
    defaultEnable = 0,
    conflicts = { "Bagnon", "Combuctor" },

    tags = {TAG_ITEM},
    desc = "一体式分类整合背包插件，自动将玩家的装备分类显示出来，并且能够自动列出新物品，功能强大但是需要稍微习惯一下",
    icon = [[Interface\Icons\INV_Misc_Bag_29]],

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            LibStub('AceAddon-3.0'):GetAddon("AdiBags"):OpenOptions()
        end
    }
});

U1RegisterAddon("AdiBags_Config", { protected = 1, hide = 1, });
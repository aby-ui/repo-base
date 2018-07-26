U1RegisterAddon("Combuctor", {
    title = "分类背包整合",
    load = "LOGIN",
    defaultEnable = 0,
    conflicts = { "Bagnon" },

    tags = {TAG_ITEM},
    desc = "经典的整合背包插件，支持分类和搜索功能。开启离线银行子模块后，右键点击搜索栏后的按钮，可以随时查看上次打开银行时记录的物品。`点击整合背包界面左上角的人物头像，可以查看已记录的同帐号角色的背包和银行，并且在物品的鼠标提示中，可以看到各个角色的银行和背包里各有多少件。（此功能也需要开启'离线银行'子模块)",
    icon = [[Interface\Icons\INV_Misc_Bag_29]],
    optdeps = { "BagBrother" },

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            Combuctor:ShowOptions()
        end
    }
});

U1RegisterAddon("Combuctor_Config", { protected = 1, hide = 1, });
U1RegisterAddon("Combuctor_Sets", { protected = 1, hide = 1, });

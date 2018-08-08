U1RegisterAddon("Bagnon", {
    title = "简约背包整合",
    defaultEnable = 1,
    load = "LOGIN", --注意要和BagBrother统一
    nopic = true,
    conflicts = { "Combuctor" },

    tags = {TAG_ITEM},
    desc = "整合背包/银行/公会银行/虚空储存，并支持离线查看。与分类背包整合（Combuctor）功能重复，建议只开启一个背包整合插件。",
    icon = [[Interface\Icons\INV_Misc_Bag_13]],
    optdeps = { "BagBrother" },

    modifier = "|cffcd1a1c[爱不易]|r",

    {
        text = "打开设置界面",
        callback = function()
            Bagnon:ShowOptions()
        end,
    },

    {
        text = "重置所有设置",
        confirm = "设置将无法恢复！\n确认重置并自动重载界面？",
        callback = function()
            Bagnon_Sets = nil
            ReloadUI()
        end
    },
});

U1RegisterAddon("Bagnon_Config", {
    parent = "Bagnon",
    protected = 1,
    hide = 1,
});

U1RegisterAddon("Bagnon_GuildBank", {
    parent = "Bagnon",
    --load = "NORMAL",
    title = "公会银行",
    desc = "暂时不能更改权限, 如有需要请关闭该子插件",
});

U1RegisterAddon("Bagnon_VoidStorage", {
    parent = "Bagnon",
    --load = "NORMAL",
    title = "虚空储存",
});
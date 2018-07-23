U1RegisterAddon("Fizzle", {
    title = "装备耐久",
    defaultEnable = 1,
    load = "LOGIN",
    tags = { TAG_ITEM },
    nopic = true,
    icon = [[Interface\Icons\INV_BLACKSMITH_ANVIL]],
    desc = "边框品质着色、人物界面耐久度显示。",
    {
        var = "glow",
        default = false,
        text = "人物装备按品质着色",
        tip = "说明`除了此插件还有oglow等其他插件也可以着色，都开启的话更亮一些"
    },
});

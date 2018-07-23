U1RegisterAddon("LegiondarySwitch", {
    title = "橙装闪换",
    defaultEnable = 1,

    tags = { TAG_ITEM, TAG_GOOD },
    icon = [[Interface\Icons\VAS_AppearanceChange]],
    nopic = 1,

    author = "|cffcd1a1c[有爱]|r",

    desc = "有爱原创插件，当玩家已经装备两件橙装后，再尝试装备第三件橙装时，不再提示仅能装备2件，而是智能替换原来的一件橙装。"
            .."`这样就可以在角色面板里快速更换橙装，也可以做宏或者将橙装拖到动作条进行快速切换。"
            .."`同时插件还提供 |cff00ff00/ls|r 命令，可以切换回10秒钟之前的橙装状态。"
            .."``举例来说，可以做一个宏:`　|cff00ff00/equip 滑板鞋`　/equip 制造橙腰带|r`再做一个宏:`　|cff00ff00/ls|r"
            .."`把这两个宏拖到动作条上，就可一键切换，再也不用维护多套套装了。"
});

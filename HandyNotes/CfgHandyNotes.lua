U1RegisterAddon("HandyNotes", {
    title = "地图标记",
    tags = { TAG_MAPQUEST, TAG_BIG },
    defaultEnable = 0,
    load = "LATER",
    optionsAfterLogin = 1,

    icon = [[Interface\Icons\Ability_Hunter_MarkedForDeath]],
    desc = "一个小巧且全能的地图标记注释功能类插件.``ALT+右键 添加一个注释标记`Ctrl+Shift+拖拽 移动已经添加的注释标记```设置口令：/handynotes",

    nopic = 1,
    {
        text = "配置选项",
        callback = function()
            LibStub("AceConfigDialog-3.0"):Open("HandyNotes")
            LibStub("AceConfigDialog-3.0"):SelectGroup("HandyNotes", "plugins")
        end
    },
    {
        text = "重置数据",
        tip = "说明`为了加快载入速度，爱不易修改HandyNotes每个版本只查询一次数据，把数据保存起来，如果有问题请重置一下",
        reload = 1,
        callback = function()
            HandyNotesDB._mapData = nil
            U1Message("数据已重置，请重载界面")
        end
    }
});

U1RegisterAddon("HandyNotes_DraenorTreasures", {
    title = "德拉诺地图宝箱",
    defaultEnable = 0,
    load = "LATER",
    desc = "在德拉诺地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_LegionRaresTreasures", {
    title = "军团再临地图宝箱",
    defaultEnable = 0,
    load = "LATER",
    desc = "在军团再临地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_BattleForAzerothTreasures", {
    title = "争霸艾酱地图宝箱",
    defaultEnable = 1,
    load = "LATER",
    desc = "在8.0新地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
})

U1RegisterAddon("HandyNotes_SuramarTelemancy", {
    title = "苏拉玛传送门",
    desc = "苏拉玛传送门及魔网标记, NGA网友karlock汉化补充",
    modifier = "karlock",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_HallowsEnd", {
    title = "万圣节糖罐位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_SummerFestival", {
    title = "仲夏节篝火位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_Argus", {
    title = "阿古斯地图宝箱",
    defaultEnable = 0,
    load = "LATER",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_LunarFestival", {
    title = "春节长者位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_Arathi", {
    title = "阿拉希稀有位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_WarfrontRares", {
    title = "战争前线稀有位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_DungeonLocations", {
    title = "老地图副本入口",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("TomCats-DarkshoreRares", {
    title = "黑海岸稀有",
    defaultEnable = 1,
    minimap = "TomCats-DarkshoreRaresMinimapButtonButton",
    tags = { TAG_MAPQUEST, },
    icon = "Interface\\AddOns\\TomCats-DarkshoreRares\\images\\darnassus-icon",
    desc = "在黑海岸战争前线大地图上显示稀有精英图标及掉落",
    pics = 2,
    { text = "HandyNotes插件设置", callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end },
});

U1RegisterAddon("TomCats-Nazjatar", {
    title = "纳沙塔尔稀有",
    defaultEnable = 1,
    --minimap = "TomCats-NazjatarMinimapButton",
    tags = { TAG_MAPQUEST, },
    icon = "Interface\\AddOns\\TomCats-Nazjatar\\images\\nazjatar-icon",
    desc = "在纳沙塔尔地图上显示稀有精英图标及掉落，也可以作为HandyNotes插件",
    pics = 2,
    { text = "HandyNotes插件设置", callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end },
});

U1RegisterAddon("TomCats-Mechagon", {
    title = "麦卡贡稀有",
    defaultEnable = 1,
    --minimap = "TomCats-MechagonMinimapButton",
    tags = { TAG_MAPQUEST, },
    icon = "Interface\\AddOns\\TomCats-Mechagon\\images\\mechagon-icon",
    desc = "在麦卡贡地图上显示稀有精英图标及掉落，也可以作为HandyNotes插件",
    pics = 2,
    { text = "HandyNotes插件设置", callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end },
});
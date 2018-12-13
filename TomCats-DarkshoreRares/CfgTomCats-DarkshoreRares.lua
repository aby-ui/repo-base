U1RegisterAddon("TomCats-DarkshoreRares", {
    title = "黑海岸稀有",
    defaultEnable = 1,
    minimap = "TomCats-DarkshoreRaresMinimapButtonButton",

    tags = { TAG_MAPQUEST, },
    icon = "Interface\\AddOns\\TomCats-DarkshoreRares\\images\\darnassus-icon",
    desc = "说明`黑海岸战争前线显示稀有精英图标及掉落",
    pics = 2,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "HandyNotes插件设置",
        callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end,
    },
    --]]
});
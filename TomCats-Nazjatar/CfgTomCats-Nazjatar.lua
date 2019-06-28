U1RegisterAddon("TomCats-Nazjatar", {
    title = "纳沙塔尔稀有",
    defaultEnable = 1,
    minimap = "TomCats-NazjatarMinimapButton",

    tags = { TAG_MAPQUEST, },
    icon = "Interface\\AddOns\\TomCats-Nazjatar\\images\\nazjatar-icon",
    desc = "在纳沙塔尔地图上显示稀有精英图标及掉落，也可以作为HandyNotes插件",
    pics = 2,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "HandyNotes插件设置",
        callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end,
    },
    --]]
});
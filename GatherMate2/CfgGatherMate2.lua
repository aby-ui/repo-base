U1RegisterAddon("GatherMate2", {
    title = "采集助手",
    defaultEnable = 0,
    load = "LATER",

    tags = { TAG_TRADING, TAG_BIG },
    icon = "Interface\\Icons\\Trade_Mining",
    desc = "在大地图和小地图上标记之前采集过的位置，也可以从数据包中直接导入各类采集点的位置。",
    nopic = 1,

    --toggle = function(name, info, enable, justload) end,

    -------- Options --------
    {
        text = "显示小地图图标",
        var = "showMinimap",
        default = 0,
        getvalue = function() return GatherMate2.db.profile.showMinimap end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            GatherMate2.db.profile.showMinimap = v
            GatherMate2:GetModule('Config'):UpdateConfig()
        end,

        {
            text = "显示边界指示图标",
            var = "showMinimap",
            default = 0,
            getvalue = function() return GatherMate2.db.profile.nodeRange end,
            callback = function(cfg, v, loading)
                if(loading) then return end
                GatherMate2.db.profile.nodeRange = v
                GatherMate2:GetModule('Config'):UpdateConfig()
            end
        },
    },

    {
        text = "导入数据",
        callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("GM2/Import") end,
    },

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList.GatherMate2("") end,
    },
});

U1RegisterAddon("GatherMate2_Data", { parent = "GatherMate2", hide = 1, protected = 1 })
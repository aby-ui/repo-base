U1RegisterAddon("163UI_TeamStats", {
    title = "团员信息统计",
    defaultEnable = 1,
    --minimap = "LibDBIcon10_TeamStats", --默认不收集
    frames = {"TeamStatsFrame"}, --需要保存位置的框体

    tags = { TAG_RAID, },
    icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
    desc = "自动获取全团成员的平均装备等级/韧性/副本击杀次数统计,以列表的方式集中呈现。`- 战斗外可以点击人名选为目标`- 可选中团员发布到聊天频道`- 具有观察间隔保护机制`- 每条玩家记录约占1K内存`- 记录保留两天,可以强制清除",

    author = "|cffcd1a1c[爱不易原创]|r",

    --toggle = function(name, info, enable, justload) end, --如果未开插件，则初始不会调用。

    {
        text = "打开统计窗口",
        callback = function(cfg, v, loading) CoreUIShowOrHide(TeamStatsFrame, not TeamStatsFrame:IsVisible()) end,
    },
    {
        text = "清除缓存数据",
        callback = function(cfg, v, loading)
            TeamStatsDB = nil
            TeamStats:VARIABLES_LOADED()
        end,
    },
});

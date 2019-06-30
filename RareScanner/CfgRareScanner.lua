U1RegisterAddon("RareScanner", {
    title = "稀有精英探测",
    defaultEnable = 0,
    load = 'NORMAL',
    secure = 1,

    tags = { TAG_MAPQUEST, TAG_BIG },
    icon = [[Interface\Icons\ABILITY_HUNTER_HUNTERVSWILD]],
    desc = "搜寻小地图标识，当发现稀有精英或宝箱的时候给出提示。",

    toggle = function(name, info, enable, justload)
        if justload then
        end
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading) CoreIOF_OTC("RareScanner") end,
    },
});
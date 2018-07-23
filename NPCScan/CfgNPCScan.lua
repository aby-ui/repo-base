U1RegisterAddon("NPCScan", {
    title = "稀有精英探测",
    defaultEnable = 0,
    load = 'NORMAL',
    secure = 1, --_NPCScanButton

    tags = { TAG_MAPQUEST, TAG_BIG },
    icon = [[Interface\Icons\ABILITY_HUNTER_HUNTERVSWILD]],
    desc = "搜寻附近的NPC，当发现稀有精英的时候给出提示。",

    toggle = function(name, info, enable, justload)
        if justload then
            --if GetModifiedClick( "_NPCSCAN_BUTTONDRAG" ) == "NONE" then
            --    SetModifiedClick( "_NPCSCAN_BUTTONDRAG", "CTRL" )
            --end
        end
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_NPCSCAN"]("") end,
    },
    --[[
    {
        text = "测试警报",
        tip = "说明`模拟一次|cff808080“发现 NPC”|r警报让你知道它看起来什么样子。",
        callback = function(cfg, v, loading) _NPCScanTest:Click() end,
    },
    {
        text = "列出已缓存怪物",
        callback = function(cfg, v, loading) SlashCmdList[ "_NPCSCAN" ]("cache") end,
    },
    --]]
});

U1RegisterAddon("_NPCScan.Overlay", {
    title = "稀有精英路径",
    desc = "在地图上标记出稀有精英的活动范围",
    parent="NPCScan",
    defaultEnable = 1,
    protected = nil,
    hide = nil,
    minimap = "LibDBIcon10__NPCScan.Overlay",
    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["_NPCSCAN_OVERLAY"]("") end,
    },
});

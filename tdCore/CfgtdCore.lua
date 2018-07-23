
U1RegisterAddon("tdCore", {
    title = "背包整理依赖库",
    -- defaultEnable  = 1,
    hide = 1,
    load = 'DEMAND',
    -- load = "LOGIN", --LATER会导致屏幕大闪
})


U1RegisterAddon('tdPack', {
    title = '背包整理',
    defaultEnable = 1,
    deps = { 'tdcore' },
    tags = {TAG_ITEM},
    desc = "在背包窗口上显示背包整理按钮，可以按照预订顺序快速整理物品。`ctrl或shift右键点击整理按钮可以设置正序或逆序（背包的空格在前还是在后），下次整理只需要左键单击就能使用之前设置的顺序。",
    icon = [[Interface\Icons\INV_Misc_Bag_10_Green]],

    {
        text="配置选项",
        callback = function(cfg, v, loading)
            if(tdCore) then
                tdCore('tdPack'):ToggleOption()
            end
        end,

    },

    {
        text = "恢复默认整理顺序",
        tip = "说明`有时会调整默认的整理顺序，使其更适应当前版本，使用此按钮会覆盖当前设置，且无法恢复。",
        confirm = "会清除当前设置并重新加载界面\n是否确定？",
        callback = function(cfg, v, loading)
            for k,v in pairs(TDDB_TDPACK) do
                if v.Orders then
                    v.Orders.CustomOrder = {}
                    v.Orders.EquipLocOrder = {}
                end
            end
            ReloadUI()
        end,
    },

    {
        text = "整理时忽略背包（左起顺序）", type = "text",
        { text = "背包1 - 未知", var = "bag4", default = false},
        { text = "背包2 - 未知", var = "bag3", default = false },
        { text = "背包3 - 未知", var = "bag2", default = false },
        { text = "背包4 - 未知", var = "bag1", default = false },
        { text = "行囊", var = "bag0", default = false },
    },

    {
        text = "忽略银行背包（左起顺序）", type = "text",
        { text = "银行自带背包", var = "bag-1", default = false },
        { text = "背包1 - 未知", var = "bag5",  default = false },
        { text = "背包2 - 未知", var = "bag6",  default = false },
        { text = "背包3 - 未知", var = "bag7",  default = false },
        { text = "背包4 - 未知", var = "bag8",  default = false },
        { text = "背包5 - 未知", var = "bag9",  default = false },
        { text = "背包6 - 未知", var = "bag10", default = false },
        { text = "背包7 - 未知", var = "bag11", default = false },
    }
})

--[[------------------------------------------------------------
更新背包名称
---------------------------------------------------------------]]
local updateBagNames = function(bank)
    for i = 1, 11 do
        local cfg = U1CfgFindChild("tdpack", "bag"..i)
        if i <= 4 or bank == "BANK" then
            cfg.text = cfg.text:gsub(" - .+$", " - ") .. (GetBagName(i) or "未知")
        end
    end
end

CoreOnEvent("BANKFRAME_OPENED", function() updateBagNames("BANK") end)
CoreOnEvent("BAG_UPDATE_DELAYED", updateBagNames)

--[[------------------------------------------------------------
更新tdPack的背包表
---------------------------------------------------------------]]
--[[tdPack_BAGS = {
    bag = {0, 1, 2, 3, 4},
    bank = {-1, 5, 6, 7, 8, 9, 10, 11},
}]]
local function updateIgnoreBags(cfg, v, loading)
    if loading and cfg.var ~= "bag0" then return end
    table.wipe(tdPack_BAGS.bag)  --不能赋值新表，必须wipe
    table.wipe(tdPack_BAGS.bank)
    for i = -1, 11 do
        local tbl = (i>=0 and i<=4) and tdPack_BAGS.bag or tdPack_BAGS.bank
        if (not U1GetCfgValue("tdpack/bag"..tostring(i))) then
            table.insert(tbl, i)
        end
    end
end

--设置callback函数
for i = -1, 11 do
    local cfg = U1CfgFindChild("tdpack", "bag"..tostring(i))
    cfg.callback = updateIgnoreBags
end

U1RegisterAddon("tdCore", {
    title = "背包整理依赖库",
    -- defaultEnable  = 1,
    hide = 1,
    load = 'DEMAND',
    -- load = "LOGIN", --LATER会导致屏幕大闪
})


U1RegisterAddon('tdPack', {
    title = '背包整理',
    defaultEnable = 0,
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
        text = "恢复默认排列方案",
        tip = "说明`有时开发者会调整默认的物品排列顺序，使其更适应当前版本，使用此按钮会覆盖当前设置，且无法恢复。",
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
        text = "设置整合背包排列和整理方案", type = "text", alwaysEnable = true,
        --正背包 正物品 暴雪正，先行囊 -> 从上到下，贴（td正），td逆，则下到上，离
        --正背包 反物品 暴雪反，后行囊 -> 从下到上，贴（td无办法）
        --反背包 反物品 暴雪正，先行囊 -> 从下到上，贴（td正），td逆，则上到下，离

        {
            text = "从上向下放置物品",
            tip = "说明`暴雪有两个决定物品拾取和整理的设置，整合背包有排列顺序的设置，配置错误会导致背包整理后不连续。` `爱不易归纳了两种方案，统一修改这些设置，方便大家使用。` `从上向下的设置为：` - SetSortBagsRightToLeft(true)` - SetInsertItemsLeftToRight(false)` - 插件正向排列背包` - 插件正向排列物品` - tdPack正序整理` `（如果tdPack逆序整理，则从下向上放置，且新物品从前面单放）",
            confirm = "是否确定？（不修改整合银行的排列方式，请自行在整合背包插件里调整）",
            callback = function(cfg, v, loading)
                SetSortBagsRightToLeft(true)
                SetInsertItemsLeftToRight(false)
                if Bagnon and Bagnon.profile and Bagnon.profile.inventory then
                    Bagnon.profile.inventory.reverseBags = false
                    Bagnon.profile.inventory.reverseSlots = false
                end
                if Combuctor and Combuctor.profile and Combuctor.profile.inventory then
                    Combuctor.profile.inventory.reverseBags = false
                    Combuctor.profile.inventory.reverseSlots = false
                end
                if tdCore and tdCore('tdPack') then
                    tdCore('tdPack'):SetReversePack(false)
                end
            end
        },
        {
            text = "从下向上放置物品",
            tip = "说明`从下向上的设置为：` - SetSortBagsRightToLeft(true)` - SetInsertItemsLeftToRight(false)` - 插件反向排列背包` - 插件反向排列物品` - tdPack正序整理` `（如果tdPack逆序整理，则从上向下放置，且新物品从后面单放）",
            confirm = "是否确定？（不修改整合银行的排列方式，请自行在整合背包插件里调整）",
            callback = function(cfg, v, loading)
                SetSortBagsRightToLeft(true)
                SetInsertItemsLeftToRight(false)
                if Bagnon and Bagnon.profile and Bagnon.profile.inventory then
                    Bagnon.profile.inventory.reverseBags = true
                    Bagnon.profile.inventory.reverseSlots = true
                end
                if Combuctor and Combuctor.profile and Combuctor.profile.inventory then
                    Combuctor.profile.inventory.reverseBags = true
                    Combuctor.profile.inventory.reverseSlots = true
                end
                if tdCore and tdCore('tdPack') then
                    tdCore('tdPack'):SetReversePack(false)
                end
            end
        }
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
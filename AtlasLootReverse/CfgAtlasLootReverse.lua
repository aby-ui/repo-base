U1RegisterAddon("AtlasLootReverse", {
    title = "物品来源查询",
    tags = {TAG_ITEM, },
    defaultEnable = 1,
    modifier = "|cffcd1a1c[爱不易]|r",

    icon = [[Interface\Icons\Ability_Hunter_SilentHunter]],
    desc = "利用副本掉落插件的数据，查询某件物品的来源。当鼠标指向一件物品时，可以在提示中显示'来源：'信息。` `占用约1.9M。",

    toggle = function(name, info, enable, justload)
        if(not justload) then
            if(enable) then
                return AtlasLootReverse:Enable()
            else
                return AtlasLootReverse:Disable()
            end
        end
    end,

});

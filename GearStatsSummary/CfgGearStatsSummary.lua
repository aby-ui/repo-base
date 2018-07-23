U1RegisterAddon("GearStatsSummary", {
    title = "装备统计对比",
    tags = {TAG_ITEM, },
    author = "zhengruiw02原创",
    modifier = "EUI",

    icon = [[Interface\Icons\INV_Shoulder_02]],
    desc = "在玩家面板或观察面板旁边显示自己与对方的装备统计对比，并可显示装等和天赋，以及宝石和附魔缺失情况的功能。",

    defaultEnable  = 1,

    toggle = function(name, info, enable, justload)
        if(justload and IsAddOnLoaded("Blizzard_InspectUI")) then
            GearStatsSummary_SetupHook();
        end
        togglehook(nil, "GearStatsSummary_ShowFrame", noop, not enable);
        return true;
    end,
});

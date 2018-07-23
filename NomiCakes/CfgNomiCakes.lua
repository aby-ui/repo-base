U1RegisterAddon("NomiCakes", {
    title = "诺米大厨",
    load = "LATER",
    defaultEnable = 1,
    tags = { TAG_TRADING, },
    icon = [[Interface\Icons\Achievement_Cooking_PandarianMasterChef]],
    desc = "在达拉然诺米大厨的对话框里显示所需材料及可能学到的食谱，或者通过/nomi命令显示缺失的军团烹饪食谱",
    nopic = 1,

    {
        text = "显示缺失食谱",
        callback = function(cfg, v, loading) SlashCmdList.NOMICAKES("") end,
    },
})
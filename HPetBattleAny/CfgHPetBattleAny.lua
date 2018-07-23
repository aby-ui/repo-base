U1RegisterAddon("HPetBattleAny", {
    title = "宠物对战增强",
    defaultEnable = 0,
    nopic = true,

    tags = { TAG_MAPQUEST, },

    desc = "在宠物对战界面提醒野生宠物品质,技能,属性等等信息.",
    icon = [[Interface\Icons\PetJournalPortrait]],

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["HPETBATTLEANY"]("") end
    },

    {
        text = "当前地图收集情况",
        callback = function(cfg, v, loading) SlashCmdList["HPETBATTLEANY"]("s") end
    },

    {
        text = "清除宠物技能保存记录",
        callback = function(cfg, v, loading) SlashCmdList["HPETBATTLEANY"]("cc") end
    },
})

U1RegisterAddon("TipTac", {
    title = "鼠标提示增强",
    load = "NORMAL",
    defaultEnable = 1,

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\INV_Misc_Toy_08]],
    desc = "高度可定制的提示信息增强插件。",
    nopic = 1,

    {
        text="配置选项",
        callback = function(cfg, v, loading)
            SlashCmdList["TipTac"]("")
        end,
    },

    {
        text = "重置所有设置",
        confirm = "设置将无法恢复！\n确认重置并自动重载界面？",
        callback = function()
            TipTac_Config = nil
            ReloadUI()
        end
    },

    {
        var="disableMouseFollowWhenCombat",
        text="战斗时禁止鼠标跟随",
        tip="说明`在战斗时禁止提示框跟随鼠标，以避免造成视觉干扰，提示框会固定显示在屏幕的右下角（和魔兽原生机制一致）。",
        default=true,
    },

    {
        var="showAchvId",
        text="成就链接中显示ID和分类ID",
        getvalue = function() if TipTac_Config then return TipTac_Config.if_showAchievementIdAndCategory end end,
        callback = function(cfg, v, loading)
            if not loading and TipTac_Config then
                TipTac_Config.if_showAchievementIdAndCategory = not not v
            end
        end
    },

    --TODO wanyi 选项

});

U1RegisterAddon("TipTacItemRef", { title = "TipTac 物品链接模块", parent = "TipTac", defaultEnable = 1 })
U1RegisterAddon("TipTacTalents", { title = "TipTac 天赋专精模块", parent = "TipTac", defaultEnable = 1 })
--[[------------------------------------------------------------
Dummy的插件默认值：
- defaultEnable = 1
- desc = "此项功能为一系列小插件的组合……"
---------------------------------------------------------------]]
U1RegisterAddon("!!Forwarder", { dummy = 1,
    title = "频道转发",
    tags = { TAG_CHAT },
    icon = [[Interface\Icons\ACHIEVEMENT_GUILDPERK_HONORABLEMENTION_RANK2]],
    desc = "在野外也可以看到组队频道和交易频道的信息，插件由爱不易warbaby原创奉献",
    author = "|cffcd1a1c[爱不易原创]|r",
    defaultEnable = 0,

    children = {"LFGForwarder", "TradeForwarder"},
})

--[[
U1RegisterAddon("!!UnitFrames", { dummy = 1,
    title = "头像增强",
    tags = { TAG_INTERFACE },
    icon = "Interface\\Icons\\Achievement_Reputation_Ogre",

    children = {"EN_UnitFrames", "ToTxp", "TargetButton", },
})
]]

U1RegisterAddon("!!TradeSkill", { dummy = 1,
    title = "专业技能助手",
    tags = { TAG_TRADING },
    icon = [[Interface\Icons\Ability_Racial_BetterLivingThroughChemistry]],
    desc = "对系统专业技能面板的增强",

    children = {"EnhancedTradeSkillUI", "TradeTabs", "WarbabyTradeLink", },
    {
        var = "knownRecipes",
        text = "启用已学配方染色",
        tip = "说明`将拍卖行和商人等处已学会的配方染为绿色.",
        default = 1,
        alwaysEnable = 1,
    },
})

-- U1RegisterAddon("LibMapData-1.0", {
--     title = "库：地图数据",
--     load = "NORMAL",
--     icon = "Interface\\HelpFrame\\HelpIcon-ReportAbuse",
--     desc = "很多单体插件使用了地图数据（LibMapData）这个库，但由于更新不及时，玩家到新地图上时会不停的刷屏。`爱不易特别制作了一个最新版的库，当遇到插件刷MapData Missing的时候启用即可。`如果没有单体插件或没有使用这个库的单体插件，可以完全关闭或删除此插件。",
--     alwaysRegister = 1,
--     defaultEnable = 1,
--     tags = { TAG_MANAGEMENT }
-- })

U1RegisterAddon("TradeSkillInfo", {
    title = "商业技能百科",
    defaultEnable = 0,
    minimap = "LibDBIcon10_TradeSkillInfo",

    tags = { TAG_TRADING, TAG_BIG },
    modifier = "|cffcd1a1c[爱不易]|r",
    desc = "商业技能资料库插件，全商业技能查看，材料用途，商业技能配方出处，拍卖行里通过染色提示配方是否可学",
    icon = [[Interface\Icons\INV_Enchant_FormulaGood_01]],

      --toggle = function(name, info, enable, justload) end,
    {
        text = "配置选项",
        tip = "快捷命令`/auctionlite config",
        callback = function(cfg, v, loading) 
        	InterfaceOptionsFrame_OpenToCategory("TradeSkillInfo")
        	InterfaceOptionsFrame_OpenToCategory("TradeSkillInfo")
        end,
    },
});

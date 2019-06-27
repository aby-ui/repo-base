U1RegisterAddon("Accountant_Classic", { 
    title = "收支统计",
    tags = {TAG_TRADING},
    defaultEnable = 0,

    minimap = "AccountantButton",

    icon = [[Interface\Icons\INV_Misc_Coin_01]],
    iconTip = "$title`查看统计表格",
    iconFunc = function() HideUIPanel(GameMenuFrame); AccountantButton_OnClick() end,

    desc = "追踪每个角色的所有收入与支出状况，并可显示当日小计、当周小计、以及自有记录起的总计。并可显示所有角色的总金额。``快捷命令：/accountant",

    modifier = "|cffcd1a1c[爱不易]|r",

    ------- Options --------
    {
        type="button",
        text="查看统计表格",
        tip="快捷命令`/accountant",
        always = 1,
        callback = function(cfg, v, loading)
            if not IsAddOnLoaded("Accountant_Classic") then U1LoadAddOn("Accountant_Classic"); end
            AccountantButton_OnClick() end,
    },
    {
        type="button",
        text="配置选项",
        callback = function(cfg, v, loading) HideUIPanel(GameMenuFrame); AccountantOptions_Toggle() end,
    },
});
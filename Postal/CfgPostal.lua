U1RegisterAddon("Postal", {
    title = "邮件增强",
    defaultEnable = 1,

    tags = { TAG_TRADING },
    icon = [[Interface\Icons\INV_Letter_06]],
    desc = "强化邮箱面板功能，支持批量收取全部邮件、计算所有邮件的金币收入总和、自动填写收件人等等功能。``在邮箱面板的右上角有设置菜单。",

    -------- Options --------
    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            if Postal_DropDownMenu.initialize ~= Postal.Menu then
                CloseDropDownMenus()
                Postal_DropDownMenu.initialize = Postal.Menu
            end
            ToggleDropDownMenu(1, nil, Postal_DropDownMenu, Minimap:GetName(), 0, 0)
        end,
    },
    --]]
});

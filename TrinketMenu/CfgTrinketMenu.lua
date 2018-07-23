U1RegisterAddon("TrinketMenu", {
    title = "饰品增强",
    defaultEnable = 0,
    load = "LOGIN",
    secure = 1,
    minimap = "TrinketMenu_IconFrame",

    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\INV_Jewelry_Talisman_13]],
    desc = "显示两个饰品按钮，可以快速选择饰品。右键点击小地图按钮可以打开配置窗口（快捷命令为/trinketmenu opt），可以配置自动更换饰品及各个饰品的优先级，每次脱离战斗好，插件会判断饰品是否可用，智能更换饰品。`按住Alt点击饰品按钮可以快速设置是否自动更换。",

    toggle = function(name, info, enable, justload)
        if U1IsInitComplete() then
            if not InCombatLockdown() then
                local frame = TrinketMenu_MainFrame
                if not enable then
                    TrinketMenuPerOptions.userHide = false;
                    frame:Hide()
                else
                    frame:Show()
                    PlaySound163("GAMEGENERICBUTTONPRESS")
                end
            end
        end
    end,
    {
        var = "masque",
        text = "支持按钮美化",
        default = 1,
        callback = function(cfg, v, loading)
            local Masque = LibStub and LibStub('Masque', true)
            if Masque then
                local group  = Masque:Group("饰品增强", "饰品按钮")
                if loading then
                    group:AddButton(TrinketMenu_Trinket0)
                    group:AddButton(TrinketMenu_Trinket1)
                end
                if v then group:Enable() else group:Disable() end
                group = Masque:Group("饰品增强", "饰品选择菜单")
                for i=1, 30 do
                    if loading then group:AddButton(_G["TrinketMenu_Menu"..i]) end
                    if v then group:Enable() else group:Disable() end
                end
            end
        end
    },
    {
        text = "配置选项",
        tip = "快捷命令`/trinketmenu opt",
        callback = function(cfg, v, loading) SlashCmdList["TrinketMenuCOMMAND"]("opt") end,
    },
    {
        text = "重置位置",
        tip = "快捷命令`/trinketmenu reset",
        callback = function(cfg, v, loading) SlashCmdList["TrinketMenuCOMMAND"]("reset") end,
    },
});

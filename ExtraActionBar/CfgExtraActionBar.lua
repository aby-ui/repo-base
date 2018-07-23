U1RegisterAddon("ExtraActionBar", {
    title = "额外动作条",
    tags = { TAG_COMBATINFO, },
    load = "NORMAL",
    optionsAfterLogin = 1,
    defaultEnable = 0,
    icon = [[Interface\Icons\INV_Misc_PunchCards_Prismatic]],
    desc = "显示额外的动作条，支持横向、纵向、趣味等排列方式。请不要在战斗中调整样式。`如果需要关闭最后一个动作条，请在控制台中隐藏。`注意：此动作条使用系统自带的按钮，按钮位置会被保存在服务器上，所以某些多姿态的职业可能会跟系统动作条冲突。",

    author = "大脚", modifier = "蘑菇",

    toggle = function(name, info, enable, justload)
        MOGUBar_Toggle(1);
        local needShowFirst = false
        for i = 1,10 do
            if(enable)then
                needShowFirst = true
                if U1DB.configs["ExtraActionBar/bar"..i] and _G["U1BAR"..i] then
                    _G["U1BAR"..i]:Show();
                    needShowFirst = false;
                end
            else
                if _G["U1BAR"..i] then
                    U1DB.configs["ExtraActionBar/bar"..i] = _G["U1BAR"..i]:IsShown()
                    _G["U1BAR"..i]:Hide();
                end
            end
        end
        if needShowFirst and _G["U1BAR1"] then _G["U1BAR1"]:Show() end
    end,
    {
        text = "创建新的动作条",
        callback = function() U1BAR_CreateNewActionBar() end,
    },
    {
        text = "设置按键绑定",
        callback = function() CoreUIShowKeyBindingFrame("HEADER_MOGUBAR1") end,
    },
    {
        var = "showgrid",
        text = "总是显示全部按钮",
        default = 1,
        callback = function(cfg, v, loading)
            MOGUBar_ToggleShowGrid(v);
        end,
    },
    {
        var = "showtab",
        text = "显示动作条标题头",
        default = 1,
        callback = function(cfg, v, loading)
            for i=1, 10 do
                local tab = _G["U1BAR"..i.."Tab"]
                if tab then
                    if v then tab:Show() else tab:Hide(); end
                else
                    break
                end
            end
        end,
    },
});

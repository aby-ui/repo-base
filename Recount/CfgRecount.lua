U1RegisterAddon("Recount", {
    title = "Recount伤害统计",
    tags = { TAG_RAID, TAG_BIG },
    defaultEnable = 0,
    load = "LOGIN", --5.0 script ran too long

    minimap = 'LibDBIcon10_Recount', 
    icon = [[Interface\ICONS\ACHIEVEMENT_GUILDPERK_FASTTRACK_RANK2]],
    desc = "老牌的伤害统计插件，可以用来统计DPS、治疗量、驱散次数、承受伤害、死亡记录等等，是团队不可缺少的数据分析工具。支持图形化显示、信息广播等功能。",
    iconTip = "$title``显示/隐藏统计窗口",
    iconText = "显示/隐藏",

    iconFunc = function(self, ...)
        if Recount.MainWindow:IsShown() then Recount.MainWindow:Hide() else Recount.MainWindow:Show();Recount:RefreshMainWindow() end
    end,

    toggle = function(name, info, enable, justload)
        --if(justload) then return end
        if U1IsInitComplete() then
            if(enable) then
                Recount.MainWindow:Show();
                Recount:RefreshMainWindow();
            else
                Recount.MainWindow:Hide();
            end
        end
        Recount:SetGlobalDataCollect(enable);
    end,

    children = {"Recount.+"},

    ------- 配置项 --------
    {
        type = "button",
        tip = "重置位置`当找不到窗口时使用",
        text = "重置窗口位置",
        callback = function() SlashCmdList["ACECONSOLE_RECOUNT"]("resetpos"); Recount.MainWindow:Show();Recount:RefreshMainWindow(); end,
    },
    {
        type = "button",
        text = "打开设置界面",
        callback = function() InterfaceOptionsFrame_OpenToCategory("Recount") end,
    },
    {
        var = "FilterBoss",
        text = "列表中显示怪物",
        type = "checkbox",
        getvalue = function() return Recount.db.profile.Filters.Show.Boss end,
        callback = function(cfg, v, loading)
            Recount.db.profile.Filters.Show.Boss = v;
            Recount.db.profile.Filters.Show.Nontrivial = v;
            if loading then return end
            Recount:IsTimeDataActive()
            Recount:FullRefreshMainWindow()
        end,
    }
});

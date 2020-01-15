U1RegisterAddon("DBM-Core", {
    title = "首领模块DBM",
    defaultEnable = 1,
    load = "NORMAL", --很奇怪的问题, DBM-Core.lua:1142
    minimap = "DBMMinimapButton",
    frames = {"DBMMinimapButton"},
    tags = { TAG_RAID, TAG_BIG },
    icon = [[Interface\Icons\INV_Helmet_06]],
    desc = "DBM是一款强大的老牌首领报警插件，让你在RAID副本中游刃有余。可以在屏幕上显示各种计时条，BOSS血量、警报信息等；团长使用时还可以自动对怪物标记团队目标。同时提供距离监视模块，可以选择文字框架和雷达框架。``注：各个子模块不要手工启用/停用，会根据当前副本自动加载。",
    pics = 3,

    --设置语音包默认值, /run DBM_AllSavedOptions=nil;U1DB.configs["dbm-core/voice"]=nil;ReloadUI()
    --[[ 不需要这里设置，因为增加了一个选项
    runBeforeLoad = function(info, name)
        DBM.DefaultOptions.CountdownVoice = "VP:Yike"
        DBM.DefaultOptions.ChosenVoicePack = "Yike"
    end,
    ]]

    iconTip = "$title`显示距离提示窗",
    iconFunc = function()
        if DBM.RangeCheck:IsShown() then DBM.RangeCheck:Hide() else DBM.RangeCheck:Show() end
    end,
    --children = {"^DBM%-*"},

    --[------ Options --------
    {
        var="range",
        text="显示DBM距离提示窗",
        tip="说明`显示一个窗口显示和其他团员之间的距离。右键点击窗口可以设置距离、雷达模式等选项。",
        callback = function(cfg, v, loading) if(v)then DBM.RangeCheck:Show(nil, nil, true) else DBM.RangeCheck:Hide(true) end end,
    },
    {
        var="hugebar",
        text="开启大型计时条",
        default = nil,
        tip="说明`临近结束时计时条会放大并移动到屏幕中间位置。",
        getvalue = function() return DBM.Bars:GetOption("HugeBarsEnabled") end,
        callback = function(cfg, v, loading)
            DBM.Bars:SetOption("HugeBarsEnabled", not not v)
        end,
    },
    {
        var="voice",
        text="使用额外语音包",
        default = 1,
        tip="说明`使用额外的语音提示，一般使用夏一可普通话女声。",
        getvalue = function() return DBM.Options.ChosenVoicePack == "Yike" end,
        callback = function(cfg, v, loading)
            if (v) then
                if DBM.Options.ChosenVoicePack == "None" then
                    DBM.Options.ChosenVoicePack = "Yike"
                    DBM.Options.CountdownVoice = "VP:Yike"
                end
            else
                if DBM.Options.ChosenVoicePack == "Yike" then
                    DBM.Options.ChosenVoicePack = "None"
                end
            end
        end,
    },
    --[[
    {
        var="movie",
        text="禁用所有过场电影",
        getvalue = function() return DBM.Options.DisableCinematics end,
        callback = function(cfg, v, loading) DBM.Options.DisableCinematics = not not v end,
    },
    ]]
    {
        text="测试计时条",
        callback = function(cfg, v, loading) DBM:DemoMode() end,
    },
    {
        text="配置选项",
        callback = function(cfg, v, loading) SlashCmdList["DEADLYBOSSMODS"]("") end,
    },
    --]]
});

--可以考虑加一个属性, hideAndDisable
--模块插件必须设置成protected否则加载DBM时如果模块未启用，则无法显示选项
U1RegisterAddon("DBM-StatusBarTimers", { title = "状态条计时器", load = "NORMAL", protected = nil, defaultEnable = 1, hide = 1, });
U1RegisterAddon("DBM-GUI", { title = "配置选项模块", });
U1RegisterAddon("DBM-DefaultSkin", { title = "默认皮肤", load = "NORMAL" });
U1RegisterAddon("DBM-Brawlers", { title = '搏击俱乐部', });
U1RegisterAddon("DBM-DMF", { title = '暗月马戏团', });
U1RegisterAddon("DBM-WorldEvents", { title = "世界事件模块", });

U1RegisterAddon("DBM-VPYike", { title = "夏一可語音包", load = "NORMAL", protected = 1 });
U1RegisterAddon("DBM-Azeroth-BfA", { title = "争霸艾泽拉斯世界BOSS", });
U1RegisterAddon("DBM-Party-BfA", { title = "争霸艾泽拉斯5人副本", });
U1RegisterAddon("DBM-Uldir", { title = "奥迪尔副本模块", });
U1RegisterAddon("DBM-ZuldazarRaid", { title = "达萨罗之战模块", });
U1RegisterAddon("DBM-CrucibleofStorms", { title = "风暴熔炉模块", });
U1RegisterAddon("DBM-EternalPalace", { title = "永恒王宫模块", });
U1RegisterAddon("DBM-Nyalotha", { title = "尼奥罗萨模块", });

--第三方开发的
U1RegisterAddon("DBM-SpellTimers", { title = "冷却监控", load = "NORMAL", defaultEnable = 0 });
U1RegisterAddon("DBM-PvP", { title = "PVP模块", });

--U1RegisterAddon("DBM-RaidLeadTools", { title = "团长工具箱", });

CoreDependCall("DBM-GUI", function()
    table.insert(UISpecialFrames, "DBM_GUI_OptionsFrame")
end)
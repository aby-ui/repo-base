U1RegisterAddon("Gladius", {
    title = "竞技场头像",
    defaultEnable = 0,
    load = "NORMAL",
    optionsAfterLogin = 1,

    tags = { TAG_PVP, },
    icon = [[Interface\Icons\achievement_pvp_h_07]],
    desc = "强大的竞技场敌队监视插件，可以显示对手成员的职业、血量、正在施放的技能等信息，可以根据其施放的特定法术判断其天赋，可以记录并显示对方收到的控制技能递减情况。`可以点击选中对方为目标显示对方，并可以设置按住功能键点击时直接对其施放法术。`配置选项很多，选中'一般'里的'进阶选项'可以查看更多的高级配置项目。",

    runBeforeLoad = function(info, name)
        Gladius.defaults.profile.x.arena1 = GetScreenWidth()/2;
        Gladius.defaults.profile.y.arena1 = GetScreenHeight()/2;
    end,

    toggle = function(name, info, enable, justload)
        if(not justload) then
            if(enable) then
                Gladius:OnEnable()
                if GladiusButtonAnchor then
                    GladiusButtonAnchor:EnableMouse(true);
                end
            else
                Gladius:OnDisable()
                for i=1, 5 do
                    local frame = _G[format("GladiusButtonFramearena%d", i)]
                    if frame then frame:Hide(); end
                end
                if GladiusButtonAnchor then
                    GladiusButtonAnchor:EnableMouse(false);
                end
            end
        end
        if enable then
            if U1IsInitComplete() then
                if UUI and UUI.loadTimer then return end --全部启用
                SlashCmdList["GLADIUS"]("test 5")
            end
        end
    end,

    {
        type = 'button',
        text = '显示测试框架',
        callback = function()
            SlashCmdList["GLADIUS"]("test 5")
        end,
    },

    {
        type = 'button',
        text = '配置选项',
        callback = function()
            SlashCmdList["GLADIUS"]("config")
        end
    },

    {
        var = "lock",
        text = "锁定/解锁位置",
        getvalue = function() return Gladius.db.locked and 1 end,
        callback = function(cfg, v, loading)
            Gladius.db.locked = not not v
            Gladius:UpdateFrame()
        end,
    },

    {
        text = "重置所有设置",
        confirm = "本插件的当前设置将全部丢失，您是否确定？",
        callback = function(cfg, v, loading)
            SlashCmdList["GLADIUS"]("reset")
        end,
    },

});

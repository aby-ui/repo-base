U1RegisterAddon("CastDelayBar", { 
    title = "施法条延迟",
    defaultEnable  = 1,

    tags = {TAG_INTERFACE},
    icon = [[Interface\Icons\Spell_ChargeNegative]],

    desc = "在系统默认的施法条上显示剩余时间，并在施法条末端以红色方式显示延迟时间，可用来判断手工中断施法的时机。",

    toggle = function(name, info, enable, justload)
        CastDelayBar:Toggle(enable and 1);
    end,

    {
        var = "showtotal",
        text = "显示总施法时间",
        tip = "说明`选中此项则显示已施法时间和总施法时间，否则只显示剩余施法时间。",
        callback = function(cfg, v, loading)
            CastDelayBar.showremain = not v
            CastDelayBar.delayText:ClearAllPoints()
            if v then
                CastDelayBar.delayText:SetPoint("LEFT", CastingBarFrame, "RIGHT", 8, 3);
            else
                CastDelayBar.delayText:SetPoint("RIGHT", CastingBarFrame, "RIGHT", -4, 3);
            end
        end,
    }
});

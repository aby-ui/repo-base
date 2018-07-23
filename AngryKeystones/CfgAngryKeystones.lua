U1RegisterAddon("AngryKeystones", {
    title = "秘境计时增强",
    defaultEnable = 1,
    tags = { TAG_MAPQUEST },
    icon = [[Interface\Icons\INV_Relics_Hourglass]],
    desc = "说明`显示大秘境的时间消耗情况。取代之前的GottaGoFast",
    nopic = 1,

    --[[toggle = function(name, info, enable, justload)
        local count = ScenarioChallengeModeBlock and ScenarioChallengeModeBlock.DeathCount
        if count then
            if enable then count:SetAlpha(0) else count:SetAlpha(1) end
        end
        return true
    end,--]]

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            SlashCmdList.AngryKeystones("")
        end
    }
});

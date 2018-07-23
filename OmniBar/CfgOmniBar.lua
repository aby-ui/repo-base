U1RegisterAddon("OmniBar", {
    title = "敌方冷却监控",
    defaultEnable = 0,

    tags = { TAG_PVP, },
    icon = [[Interface\Icons\Achievement_BG_grab_cap_flagunderXseconds]],
    desc = "显示对手技能的冷却时间。",
    nopic = 1,

    modifier = "NGA-伊甸外",

    toggle = function(name, info, enable, justload)
        if(not justload) then
        end
        return true
    end,

    {
        type = 'button',
        text = '显示效果测试',
        callback = function()
            OmniBar:Test()
        end,
    },

    {
        type = 'button',
        text = '配置选项',
        callback = function()
            SlashCmdList.OmniBar("")
        end,
    },

});

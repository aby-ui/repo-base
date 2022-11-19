U1RegisterAddon("BigDebuffs", {
    title = "控制技能提示",
    defaultEnable = 0,
    loadConfirm = U1_LOAD_CONFIRM_TAINT,

    tags = { TAG_PVP, },
    icon = [[Interface\Icons\Spell_Nature_HeavyPolymorph2]],
    desc = "在头像上提示控制技能图标及其剩余时间。",
    nopic = 1,

    modifier = "伊甸外@NGA",

    toggle = function(name, info, enable, justload)
        if(not justload) then
        end
        return true
    end,

    {
        type = 'button',
        text = '配置选项',
        callback = function()
            SlashCmdList.BigDebuffs("")
        end,
    },

});

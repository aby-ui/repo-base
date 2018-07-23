U1RegisterAddon("HHTD", {
    title = "治疗必须死",
    defaultEnable = 0,

    tags = { TAG_PVP, },
    icon = [[Interface\Icons\Achievement_Guild_DoctorIsIn]],
    desc = "在敌方治疗玩家的头上显示标记。",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if(not justload) then
        end
        return true
    end,

    {
        type = 'button',
        text = '配置选项',
        callback = function()
            LibStub("AceConfigDialog-3.0"):Open("H.H.T.D.")
        end,
    },

});

U1RegisterAddon("Healers-Have-To-Die", { hide = true, protected = true })
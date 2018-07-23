U1RegisterAddon("TellMeWhen", {
    title = "Tell Me When",
    defaultEnable = 0,
    load = "NORMAL",

    tags = { TAG_BIG, TAG_COMBATINFO },
    icon = [[Interface\Icons\INV_Jewelry_Ring_ZulGurub_02]],
    nopic = 1,

    toggle = function(name, info, enable, justload)
        return true
    end,

    {
        text = "切换锁定/解锁",
        tip = "快捷命令:`/tmw",
        callback = function()
            TMW:SlashCommand("")
        end
    },

    {
        text = "TMW选项",
        tip = "快捷命令:`/tmw options",
        callback = function()
            TMW:SlashCommand("options")
        end
    },
});

U1RegisterAddon("TellMeWhen_Options", { parent = "TellMeWhen", hide = 1, protected = 1 })
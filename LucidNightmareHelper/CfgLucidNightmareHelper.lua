U1RegisterAddon("LucidNightmareHelper", {
    title = "清醒梦魇助手",
    defaultEnable = 0,

    tags = { TAG_MAPQUEST, },
    icon = [[Interface\Icons\Spell_Shadow_MindTwisting]],
    nopic = 1,
    toggle = function(name, info, enable, justload)
    end,

    {
        text = "命令 /lucid",
        callback = function()
            SlashCmdList["LUCIDNIGHTMAREHELPER"]()
        end,
    }
});
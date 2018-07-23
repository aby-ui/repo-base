U1RegisterAddon("RangeDisplay", {
    title = "距离提示",
    defaultEnable = 0,
    optionsAfterVar = 1,

    tags = { TAG_COMBATINFO, },
    icon = [[Interface\Icons\INV_Misc_Spyglass_02]],
    desc = "提示目标、焦点目标，以及鼠标指向单位和玩家的距离，距离用两个数字表示其估计范围。在控制台中可以解锁文字调整位置。`配置选项的快捷命令为：/rangedisplay。",

    --toggle = function(name, info, enable, justload) end,

    ---[[------ Options --------
    {
        var = "locked",
        default = true,
        text = "锁定/解锁文字位置",
        callback = function(cfg, v, loading)
            if not loading then
                RangeDisplay.db.profile["locked"] = not not v
                RangeDisplay:applySettings()
            end
        end,
    },
    {
        text = "配置选项",
        tip = "快捷命令`/rangedisplay",
        callback = function(cfg, v, loading) SlashCmdList["RANGEDISPLAY"]() end,
    },
    --]]
});

U1RegisterAddon("RangeDisplay_Options", {title = "RangeDisplay_Options", protected = 1, hide = 1, });
U1RegisterAddon("BFAInvasionTimer", {
    title = "入侵时刻表",
    defaultEnable = 1,

    tags = { TAG_MAPQUEST, },
    icon = "Interface\\ICONS\\Achievement_Garrison_Invasion",
    desc = "争霸艾泽拉斯8.1入侵计时，可以选择显示方式（单独的计时条还是在信息条里），注意需要经历一次入侵才能正确计时，配置命令 /bit",
    pics = 2,

    toggle = function(name, info, enable, justload)
    end,

    {
        var = "type",
        type = "drop",
        options = {"独立计时条", 1, "嵌入信息条", 2},
        text = "显示方式",
        confirm = "修改此选项会重载界面",
        getvalue = function() return BFAInvasionTimer.db.profile.mode end,
        callback = function(cfg, v, loading)
            if loading then return end
            local bit = BFAInvasionTimer
            bit.db.profile.mode = v
            if v == 2 then
                if not bit.db.profile.lock then
                    bit.db.profile.lock = true
                end
                if bit.db.profile.hideInRaid then
                    bit.db.profile.hideInRaid = false
                end
            end
            ReloadUI()
        end,
    },
    {
        text = "详细设置",
        callback = function(cfg, v, loading) BFAInvasionTimer:GetScript("OnMouseUp")(BFAInvasionTimer, "RightButton") end,
    },
});

U1RegisterAddon("BFAInvasionTimer_Options", {title = "入侵计时选项", protected = nil, hide = 1, load="DEMAND",});

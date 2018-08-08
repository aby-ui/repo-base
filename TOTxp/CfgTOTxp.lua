U1RegisterAddon("TOTxp", {
    title = "目标的目标增强",
    defaultEnable = 0,
    load = "LOGIN", --login无法记录框体位置
    secure = 1,

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\INV_Gizmo_Scope02]],
    desc = "目标的目标框体增强，可以给系统自带的目标的目标框体增加伤害提示和文字、显示仇恨百分比、并且可以按住SHIFT拖动位置。`插件整合了仇恨警报的功能，会根据当前选择的模式显示OT警报。可以运行/tot mode命令在坦克、治疗、输出三个模式之间切换。`其他功能参见/tot帮助。",

    author = "|cffcd1a1c[爱不易原创]|r",

    frames = {"TargetFrameToT"},

    toggle = function(name, info, enable, justload)
        if justload then return end
        if enable then
            TOTxp_Command("rr");
            TOTxpFrame:Show();
            TOTxpOverTextFrame:Show();
            TOTxpFrame_Info:Show();
        else
            TOTxp_Command("reset");
            TOTxpFrame:Hide();
            TOTxpOverTextFrame:Hide();
            TOTxpFrame_Info:Hide();
        end
        togglehook(nil, "TOTxpFrame_OnEvent", noop, not v);
    end,

    -------- Options --------
    {
        text = "恢复原始位置",
        secure = 1,
        callback = function() if(not InCombatLockdown()) then TOTxp_Command("reset") end end,
    },
    {
        text = "移动至中心左上位置",
        secure = 1,
        callback = function() if(not InCombatLockdown()) then TOTxp_Command("rr") end end,
    },
    {
        var = "mode",
        default = 1,
        type = "radio",
        options = {"DPS", 0, "坦克", 1, "治疗", 2, },
        cols = 3,
        text = "仇恨警报模式",
        tip = "说明`在人物右上有OT提示，根据不同团队角色有不同的方式。",
        getvalue = function() return TOTxpAggroMode[UnitName("player")] end,
        callback = function(cfg, v, loading) if loading then return end TOTxp_Command(tostring(v)) end,
    },
    {
        var = "threat",
        default = "percent",
        type = "radio",
        options = {"仇恨数值", "value", "仇恨百分比", "percent" },
        cols = 2,
        text = "仇恨显示方式",
        tip = "说明`在人物左下角有仇恨显示",
        getvalue = function() return TOTxpThreatMode and TOTxpThreatMode or "percent" end,
        callback = function(cfg, v, loading) if true or not loading then TOTxpThreatMode = v end end,
    },
    {
        text = "向团队发送怪物目标切换提示",
        tip = "说明`打BOSS的时候使用，可以把BOSS目标切换的时刻标记出来。开启前请先征求团长同意。快捷命令是/totxp info。",
        type = "checkbox",
        getvalue = function() return TOTxp_GetShowInfo() end,
        callback = function(cfg, v, loading) if loading then return end TOTxp_Command("info") end,
    },
    --]]
});

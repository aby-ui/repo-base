U1RegisterAddon("Comergy_Redux", {
    title = "能量监控",
    defaultEnable = 1,
    load = "LOGIN",
    --frames = { "ComergyOptFrame" }, --no use

    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\INV_Artifact_XP04]],
    nopic = 1,

    modifier = "|cffcd1a1c[爱不易]|r",

    desc = "轻量美观的能量及资源点数监控插件。``可以作为潜行者和死亡骑士的连击点/符文监控，也支持神圣能量、灵魂碎片、奥术冲能、真气的显示，适用于各个职业。",

    toggle = function(name, info, enable, justload)
        if justload then
            if Comergy_Settings.Enabled == false then
                Comergy_Settings.Enabled = true
                CoreScheduleTimer(false, 0.1, ComergyOnConfigChange)
            end
            hooksecurefunc("ComergyOnConfigChange", function()
                if Comergy_Settings.Enabled then
                    EnableAddOn("Comergy_Redux")
                else
                    DisableAddOn("Comergy_Redux")
                end
            end)
            CoreHideOnPetBattle(ComergyMainFrame)
        else
            Comergy_Settings.Enabled = enable
            ComergyOnConfigChange()
            return false
        end
    end,

    {
        text = "配置选项",
        callback = function()
            SlashCmdList["COMERGY"]()
        end
    },

    {
        text = "锁定框体位置",
        var = "Locked",
        getvalue = function() return Comergy_Settings.Locked end,
        callback = function(cfg, v, loading)
            Comergy_Settings.Locked = v
            if not loading then ComergyOnConfigChange() end
        end
    },

    {
        text = "垂直显示模式",
        var = "VerticalBars",
        getvalue = function() return Comergy_Settings.VerticalBars end,
        callback = function(cfg, v, loading)
            Comergy_Settings.VerticalBars = v
            if not loading then ComergyOnConfigChange() end
        end
    },

    {
        text = "显示玩家血条",
        var = "ShowPlayerHealthBar",
        default = 1,
        getvalue = function() return Comergy_Settings.ShowPlayerHealthBar end,
        callback = function(cfg, v, loading)
            if loading then return end
            Comergy_Settings.ShowPlayerHealthBar = v
            ComergyOnConfigChange()
        end
    },

    {
        text = "显示目标血条",
        var = "ShowTargetHealthBar",
        default = 1,
        getvalue = function() return Comergy_Settings.ShowTargetHealthBar end,
        callback = function(cfg, v, loading)
            if loading then return end
            Comergy_Settings.ShowTargetHealthBar = v
            ComergyOnConfigChange()
        end
    },

    {
        text = "重置所有设置为默认",
        confirm = "设置将无法恢复！\n确认重置并自动重载界面？",
        callback = function()
            Comergy_Config = nil
            ReloadUI()
        end
    },

});

U1RegisterAddon("Comergy_Redux_Options", { protected = 1, hide = 1 })


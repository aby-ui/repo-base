U1RegisterAddon("Details", {
    title = "Details伤害统计",
    defaultEnable = 0,
    load = "NORMAL",
    minimap = "LibDBIcon10_Details",

    tags = { TAG_RAID, TAG_BIG },
    icon = [[Interface\AddOns\Details\images\minimap]],
    desc = "强大的伤害统计插件，https://wow.curseforge.com/projects/details",
    pics = 0,

    toggle = function(name, info, enable, justload)
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            local _detalhes = _G._detalhes
            local lower_instance = _detalhes:GetLowerInstanceNumber()
            if (not lower_instance) then
                local instance = _detalhes:GetInstance (1)
                _detalhes.CriarInstancia (_, _, 1)
                _detalhes:OpenOptionsWindow (instance)
            else
                _detalhes:OpenOptionsWindow (_detalhes:GetInstance (lower_instance))
            end
        end,
    },

    {
        text = "切换窗口显示",
        callback = function(cfg, v, loading)
            local _detalhes = _G._detalhes
            _detalhes:ToggleWindows()
        end,
    },
})

U1RegisterAddon("Details_3DModelsPaths", { title = "3D模型列表模块", protected = 1, hide = 1 });
U1RegisterAddon("Details_DataStorage", { title = "信息存储模块", protected = 1, hide = 1 });
U1RegisterAddon("Details_EncounterDetails", { title = "首领模块", });
U1RegisterAddon("Details_RaidCheck", { title = "团队检查模块", });
U1RegisterAddon("Details_Streamer", { title = "主播模块", });
U1RegisterAddon("Details_TinyThreat", { title = "威胁值模块", });
U1RegisterAddon("Details_Vanguard", { title = "坦克模块", });
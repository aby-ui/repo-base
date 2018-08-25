U1RegisterAddon("Skada", {
    title = "Skada伤害统计",
    tags = { TAG_RAID },
	defaultEnable = 1,
    icon = [[Interface\ICONS\Spell_Lightning_LightningBolt01]],
    desc = "老牌的伤害统计插件，可以用来统计DPS、治疗量、驱散次数、承受伤害、死亡记录等等，是团队不可缺少的数据分析工具。支持图形化显示、信息广播等功能。",
	minimap = "LibDBIcon10_Skada",
    load = "NORMAL",
    nopic = 1,

    runBeforeLoad = function()
        local def = Skada.defaults.profile.windows[1]
        def.barwidth = 240
        def.background.height = 150
        def.point = "BOTTOMRIGHT"
        def.x = -200
        def.y = 1
    end,

    {
        var = "chinese_number",
        text = "数值缩写为万/亿",
        default = 1,
        callback = function(cfg, v, loading)
            if loading then
                Skada.originFormatNumber = Skada.FormatNumber
                function Skada:FormatNumber(number)
                    if number and self.db.profile.numberformat == 1 then
                        if U1GetCfgValue("Skada", "chinese_number") then
                            if number <= 9999 then
                                return n2s(number, nil, true);
                            elseif number <= 999999 then
                                return f2s(number/1e4, 1).."万"
                            elseif number <= 99999999 then
                                return n2s(number/1e4, nil, true).."万"
                            else
                                return f2s(number/1e8, 2).."亿"
                            end
                        end
                    end
                    return Skada:originFormatNumber(number)
                end
            end
        end
    },

    {
        type = 'button', 
        text = '配置模块', 
        callback = function() 
            InterfaceOptionsFrame_OpenToCategory("Skada")
            InterfaceOptionsFrame_OpenToCategory("Skada")
        end 
    }, 
});

-- U1RegisterAddon("SkadaFriendlyFire", { title = "Skada模块-友军误伤", load = "LATER" });
U1RegisterAddon("SkadaExplosiveOrbs", { title = "Skada模块-易爆打球" });
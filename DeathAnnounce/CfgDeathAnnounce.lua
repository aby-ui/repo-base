U1RegisterAddon("DeathAnnounce", {
    title = "阵亡通知",
    defaultEnable = 1,
    optionsAfterVar = 1,

    tags = { TAG_RAID, },
    icon = [[Interface\Icons\Ability_Hunter_RapidKilling]],
    desc = "在队员死亡时显示最终致死的技能、伤害量、攻击者、死亡时间、以及死亡时目标的血量百分比。` `'/da on'开启或'/da off'关闭自动发送功能。另外放弃战斗后，可以通过/da命令临时屏蔽自动发送，防止无意义的刷屏。",

    --author = "|cffcd1a1c[爱不易原创]|r",
    modifier = "|cffcd1a1c[爱不易]|r",

    toggle = function(name, info, enable, justload)
        if not justload then
            if enable then
                DEATH_ANNOUNCE_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            else
                DEATH_ANNOUNCE_Frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            end
        end
    end,

    {
        var = "auto",
        default = false,
        text = "自动开启发送阵亡通知",
        tip = "说明：`开启后，每次进战斗都会打开自动发送功能。` `建议：放弃战斗后，可以通过/da命令临时屏蔽自动发送，防止无意义的刷屏（后面死的都是自杀速死）。",
        getvalue = function() return not DEATH_ANNOUNCE_OFF end,
        callback = function(cfg, v, loading)
            if loading then
                DEATH_ANNOUNCE_OFF = not v
            else
                if v then DEATH_ANNOUNCE_Opts("on") else DEATH_ANNOUNCE_Opts("off") end
            end
        end,
    },

    {
        var = "sound",
        type = "radio",
        options = {
            "职业挂了", "death_someone",
            "不……", "death_no",
            "啊哦不", "death_ahoh",
            "女声1", "death_girl1",
            "女声2", "death_girl2",
            "无", false },
        default = "death_someone",
        text = "队友死亡时播放音效",
        callback = function(cfg, v, loading)
            if not loading then
                if v then PlaySoundFile("Interface\\AddOns\\DeathAnnounce\\sound\\"..v..".ogg") end
            end
        end
    },

    {
        var = "yell",
        default = 1,
        text = "打断施法喊话",
    },

    {
        var = "othersir",
        default = false,
        text = "显示队友的打断信息",
    },

    {
        var = "yell_spell",
        default = 1,
        text = "重要技能喊话",
        tip = "说明`目前仅支持圣疗/守护之魂/激活/作茧缚命`如有其他长CD技能，请与爱不易作者联系",
    },

});

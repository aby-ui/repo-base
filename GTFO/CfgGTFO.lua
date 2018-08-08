local lastPlayTime, enabled

U1RegisterAddon("GTFO", {
    title = "站位提醒",
    defaultEnable = 1,

    toggle = function(name, info, enable, justload)
        enabled = enable
        if justload then
            CoreOnEvent("COMBAT_LOG_EVENT_UNFILTERED", function(event, ...)
                if not enabled then return end
                if not U1GetCfgValue("GTFO", "mythic_blood", true) then return end
                if lastPlayTime and GetTime() - lastPlayTime < 1.5 then return end
                if not InCombatLockdown() then return end
                if UnitExists("boss1") then return end
                local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = CombatLogGetCurrentEventInfo()
                if spellID == 226510 and (subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_PERIODIC_HEAL") then
                    if subEvent == "SPELL_PERIODIC_HEAL" or bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0 then --and bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_NPC) > 0 and (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 or bit.band(destFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) > 0) then
                        PlaySoundFile("Interface\\AddOns\\GTFO\\Sounds\\mythic_blood.ogg")
                        lastPlayTime = GetTime()
                    end
                end
            end)
        end
    end,

    tags = { TAG_RAID,},
    icon = [[Interface\Icons\inv_misc_pyriumgrenade]],
    desc = "自动声音提示站位危险插件.``修改部分：已修改为中文语音版``设置口令：/GTFO",
    nopic = true,

    {
        var = "mythic_blood",
        text = "提醒史诗秘钥的血池位置",
        tip = "说明`当怪物站在血池里时发出声音报警",
        default = true,
        callback = function(cfg, v, loading)
            if not loading and v then
                PlaySoundFile("Interface\\AddOns\\GTFO\\Sounds\\mythic_blood.ogg")
            end
        end,
    }
});

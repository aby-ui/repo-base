local lastPlayTime, enabled, _, play_handler

U1RegisterAddon("GTFO", {
    title = "站位提醒",
    defaultEnable = 1,

    toggle = function(name, info, enable, justload)
        enabled = enable
        if justload then
            CoreOnEvent("COMBAT_LOG_EVENT_UNFILTERED", function(event, ...)
                if not enabled then return end
                -- 血池拉走
                if U1GetCfgValue("GTFO", "mythic_blood", true) then
                    if lastPlayTime and GetTime() - lastPlayTime < 3 then return end
                    if not InCombatLockdown() then return end
                    if UnitExists("boss1") then return end
                    local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = CombatLogGetCurrentEventInfo()
                    if spellID == 226510 and (subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_PERIODIC_HEAL") then
                        if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0 and bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 and not sourceGUID:find('-141851-') then -- 忽略中立小动物和中立敌人，141851是戈霍恩之子 --and bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_NPC) > 0 and (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 or bit.band(destFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) > 0) then
                            PlaySoundFile("Interface\\AddOns\\GTFO\\Sounds\\mythic_blood.ogg", "MASTER")
                            lastPlayTime = GetTime()
                        end
                    end
                end

                -- 紫圈快躲 3/3 01:31:26.500  SPELL_CAST_START,Creature-0-3911-1864-10934-148894-00007ABE3C,"失落的灵魂",0xa48,0x0,0000000000000000,nil,0x80000000,0x80000000,288694,"暗影碎击",0x20
                if U1GetCfgValue("GTFO", "purple_circle", true) then
                    local timestamp, subEvent, _, _, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
                    if (spellID == 288694 or spellID == 296142) and subEvent == "SPELL_CAST_START" then
                        if play_handler then
                            StopSound(play_handler)
                            play_handler = nil
                        end
                        _, play_handler = PlaySoundFile("Interface\\AddOns\\GTFO\\Sounds\\purple_circle.mp3", "MASTER")
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
    },

    {
        var = "purple_circle",
        text = "提醒史诗秘钥收割时地板紫圈",
        tip = "说明`史诗秘境第2赛季，收割怪地上出紫圈时发出语音提醒",
        default = true,
        callback = function(cfg, v, loading)
            if not loading and v then
                PlaySoundFile("Interface\\AddOns\\GTFO\\Sounds\\purple_circle.mp3")
            end
        end,
    }
});

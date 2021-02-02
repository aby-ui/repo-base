
local Details = _G.Details


--> get the total of damage and healing of a phase of an encounter
function Details:OnCombatPhaseChanged()

    local current_combat = Details:GetCurrentCombat()
    local current_phase = current_combat.PhaseData [#current_combat.PhaseData][1]
    
    local phase_damage_container = current_combat.PhaseData.damage [current_phase]
    local phase_healing_container = current_combat.PhaseData.heal [current_phase]
    
    local phase_damage_section = current_combat.PhaseData.damage_section
    local phase_healing_section = current_combat.PhaseData.heal_section
    
    if (not phase_damage_container) then
        phase_damage_container = {}
        current_combat.PhaseData.damage [current_phase] = phase_damage_container
    end
    if (not phase_healing_container) then
        phase_healing_container = {}
        current_combat.PhaseData.heal [current_phase] = phase_healing_container
    end
    
    for index, damage_actor in ipairs (Details.cache_damage_group) do
        local phase_damage = damage_actor.total - (phase_damage_section [damage_actor.nome] or 0)
        phase_damage_section [damage_actor.nome] = damage_actor.total
        phase_damage_container [damage_actor.nome] = (phase_damage_container [damage_actor.nome] or 0) + phase_damage
    end
    
    for index, healing_actor in ipairs (Details.cache_healing_group) do
        local phase_heal = healing_actor.total - (phase_healing_section [healing_actor.nome] or 0)
        phase_healing_section [healing_actor.nome] = healing_actor.total
        phase_healing_container [healing_actor.nome] = (phase_healing_container [healing_actor.nome] or 0) + phase_heal
    end
end

function Details:BossModsLink()
    if (_G.DBM) then
        local dbm_callback_phase = function (event, msg, ...)

            --print("D!", event, msg, ...)
            local mod = Details.encounter_table.DBM_Mod
            
            if (not mod) then
                local id = Details:GetEncounterIdFromBossIndex (Details.encounter_table.mapid, Details.encounter_table.id)
                if (id) then
                    for index, tmod in ipairs (DBM.Mods) do
                        if (tmod.id == id) then
                            Details.encounter_table.DBM_Mod = tmod
                            mod = tmod
                        end
                    end
                end
            end
            
            local newPhase = 1

            --D! DBM_Announce Stage 3 136116 stagechange 0 2429 false

            if (event == "DBM_Announce") then
                if (msg:find("Stage")) then
                    msg = msg:gsub("%a", "")
                    msg = msg:gsub("%s+", "")
                    newPhase = tonumber(msg)
                    --print("New Phase: ", newPhase)

                    local ID, msg2, someId, someNumber, aBool = ...

                    if (msg2 == "stagechange") then
                        --print("D! yeash", msg2)
                    end

                    local phase = newPhase

                    if (phase and Details.encounter_table.phase ~= phase) then
                        Details:Msg ("Current phase is now:", phase)
                        
                        Details:OnCombatPhaseChanged()
                        
                        Details.encounter_table.phase = phase
                        
                        local cur_combat = Details:GetCurrentCombat()
                        local time = cur_combat:GetCombatTime()
                        if (time > 5) then
                            tinsert (cur_combat.PhaseData, {phase, time})
                        end
                        
                        Details:SendEvent ("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
                    end
                end
            end
        end
        
        local dbm_callback_pull = function (event, mod, delay, synced, startHp)
            Details.encounter_table.DBM_Mod = mod
            Details.encounter_table.DBM_ModTime = time()
        end
        
        DBM:RegisterCallback ("DBM_Announce", dbm_callback_phase)
        DBM:RegisterCallback ("pull", dbm_callback_pull)
    end
    
    if (BigWigsLoader and not _G.DBM) then

        function Details:BigWigs_SetStage (event, module, phase)
            --print(" ===== BigWigs_SetStage ===== ", event, module, phase)
            phase = tonumber(phase)

            if (phase and type (phase) == "number" and Details.encounter_table.phase ~= phase) then
                Details:OnCombatPhaseChanged()
                
                Details.encounter_table.phase = phase
                
                local cur_combat = Details:GetCurrentCombat()
                local time = cur_combat:GetCombatTime()
                if (time > 5) then
                    tinsert (cur_combat.PhaseData, {phase, time})
                end
                
                Details:SendEvent ("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
                Details:Msg ("Current phase is now:", phase)
            end
        end

        function Details:BigWigs_Message (event, module, key, text, ...)
            
            if (key == "stages") then

                local phase = module:GetStage()
                --print("BW new stage:", phase)

                --local phase = text:gsub (".*%s", "")
                --phase = tonumber (phase)
                
                if (phase and type (phase) == "number" and Details.encounter_table.phase ~= phase) then
                    Details:OnCombatPhaseChanged()
                    
                    Details.encounter_table.phase = phase
                    
                    local cur_combat = Details:GetCurrentCombat()
                    local time = cur_combat:GetCombatTime()
                    if (time > 5) then
                        tinsert (cur_combat.PhaseData, {phase, time})
                    end
                    
                    Details:SendEvent ("COMBAT_ENCOUNTER_PHASE_CHANGED", nil, phase)
                end
            end
        end

        if (BigWigsLoader.RegisterMessage) then
            BigWigsLoader.RegisterMessage (Details, "BigWigs_Message")
            BigWigsLoader.RegisterMessage (Details, "BigWigs_SetStage")
        end
    end

    Details:CreateCallbackListeners()
end


function Details:CreateCallbackListeners()

    Details.DBM_timers = {}
    
    local current_encounter = false
    local current_table_dbm = {}
    local current_table_bigwigs = {}

    local event_frame = CreateFrame ("frame", nil, UIParent, "BackdropTemplate")
    event_frame:SetScript ("OnEvent", function (self, event, ...)
        if (event == "ENCOUNTER_START") then
            local encounterID, encounterName, difficultyID, raidSize = select (1, ...)
            current_encounter = encounterID
            
        elseif (event == "ENCOUNTER_END" or event == "PLAYER_REGEN_ENABLED") then
            if (current_encounter) then
                if (_G.DBM) then
                    local db = Details.boss_mods_timers
                    for spell, timer_table in pairs (current_table_dbm) do
                        if (not db.encounter_timers_dbm [timer_table[1]]) then
                            timer_table.id = current_encounter
                            db.encounter_timers_dbm [timer_table[1]] = timer_table
                        end
                    end
                end
                if (BigWigs) then
                    local db = Details.boss_mods_timers
                    for timer_id, timer_table in pairs (current_table_bigwigs) do
                        if (not db.encounter_timers_bw [timer_id]) then
                            timer_table.id = current_encounter
                            db.encounter_timers_bw [timer_id] = timer_table
                        end
                    end
                end
            end	
            
            current_encounter = false
            wipe (current_table_dbm)
            wipe (current_table_bigwigs)
        end
    end)
    event_frame:RegisterEvent ("ENCOUNTER_START")
    event_frame:RegisterEvent ("ENCOUNTER_END")
    event_frame:RegisterEvent ("PLAYER_REGEN_ENABLED")

    if (_G.DBM) then
        local dbm_timer_callback = function (bar_type, id, msg, timer, icon, bartype, spellId, colorId, modid)
            local spell = tostring (spellId)
            if (spell and not current_table_dbm [spell]) then
                current_table_dbm [spell] = {spell, id, msg, timer, icon, bartype, spellId, colorId, modid}
            end
        end
        DBM:RegisterCallback ("DBM_TimerStart", dbm_timer_callback)
    end
    function Details:RegisterBigWigsCallBack()
        if (BigWigsLoader) then
            function Details:BigWigs_StartBar (event, module, spellid, bar_text, time, icon, ...)
                spellid = tostring (spellid)
                if (not current_table_bigwigs [spellid]) then
                    current_table_bigwigs [spellid] = {(type (module) == "string" and module) or (module and module.moduleName) or "", spellid or "", bar_text or "", time or 0, icon or ""}
                end
            end
            if (BigWigsLoader.RegisterMessage) then
                BigWigsLoader.RegisterMessage (Details, "BigWigs_StartBar")
            end
        end
    end

    Details.Schedules.NewTimer(5, Details.RegisterBigWigsCallBack, Details)
    --Details:ScheduleTimer ("RegisterBigWigsCallBack", 5)
end

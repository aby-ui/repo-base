
local Details = _G.Details


function Details:TestBarsUpdate()
    local current_combat = Details:GetCombat ("current")
    for index, actor in current_combat[1]:ListActors() do
        actor.total = actor.total + (actor.total / 100 * math.random (1, 10))
        actor.total = actor.total - (actor.total / 100 * math.random (1, 10))
    end
    for index, actor in current_combat[2]:ListActors() do
        actor.total = actor.total + (actor.total / 100 * math.random (1, 10))
        actor.total = actor.total - (actor.total / 100 * math.random (1, 10))
    end
    current_combat[1].need_refresh = true
    current_combat[2].need_refresh = true
end

function Details:StartTestBarUpdate()
    if (Details.test_bar_update) then
        Details:CancelTimer (Details.test_bar_update)
    end
    Details.test_bar_update = Details:ScheduleRepeatingTimer ("TestBarsUpdate", 0.1)
end
function Details:StopTestBarUpdate()
    if (Details.test_bar_update) then
        Details:CancelTimer (Details.test_bar_update)
    end
    Details.test_bar_update = nil
end

function Details:CreateTestBars (alphabet)
    local current_combat = Details:GetCombat ("current")
    local pclass = select (2, UnitClass ("player"))
    
    local actors_name = {
            {"Ragnaros", "MAGE", 63},
            {"The Lich King", "DEATHKNIGHT", }, 
            {"Your Neighbor", "SHAMAN", }, 
            {"Your Raid Leader", "MONK", }, 
            {"Huffer", "HUNTER", }, 
            {"Your Internet Girlfriend", "SHAMAN", }, 
            {"Mr. President", "WARRIOR", }, 
            {"Antonidas", "MAGE"}, 
            {"Your Math Teacher", "SHAMAN", }, 
            {"King Djoffrey", "PALADIN", }, 
            {UnitName ("player") .. " Snow", pclass, }, 
            {"A Drunk Dawrf", "MONK", },
            {"Low Dps Guy", "MONK", }, 
            {"Helvis Phresley", "DEATHKNIGHT", }, 
            {"Stormwind Guard", "WARRIOR", }, 
            {"A PvP Player", "ROGUE", 260}, 
            {"Bolvar Fordragon", "PALADIN", },
            {"Malygos", "MAGE", },
            {"Akama", "ROGUE", },
            {"Nozdormu", "MAGE", },
            {"Lady Blaumeux", "DEATHKNIGHT", },
            {"Cairne Bloodhoof", "WARRIOR", },
            {"Borivar", "ROGUE", 260},
            {"C'Thun", "WARLOCK", },
            {"Drek'Thar", "DEATHKNIGHT", },
            {"Durotan", "WARRIOR", },
            {"Eonar", "DRUID", },
            {"Malfurion Stormrage", "DRUID", },
            {"Footman Malakai", "WARRIOR", },
            {"Bolvar Fordragon", "PALADIN", },
            {"Fritz Fizzlesprocket", "HUNTER", },
            {"Lisa Gallywix", "ROGUE", },
            {"M'uru", "WARLOCK", },
            {"Priestess MacDonnell", "PRIEST", },
            {"Elune", "PRIEST", },
            {"Nazgrel", "WARRIOR", },
            {"Ner'zhul", "WARLOCK", },
            {"Saria Nightwatcher", "PALADIN", },
            {"Kael'thas Sunstrider", "MAGE", 63},
            {"Velen", "PRIEST"},
            {"Tyrande Whisperwind", "PRIEST", 257},
            {"Sargeras", "WARLOCK", 267},
            {"Arthas", "PALADIN", },
            {"Orman of Stromgarde", "WARRIOR", },
            {"General Rajaxx", "WARRIOR", },
            {"Baron Rivendare", "DEATHKNIGHT", },
            {"Roland", "MAGE", },
            {"Archmage Trelane", "MAGE", },
            {"Lilian Voss", "ROGUE", },
        }
        
    local russian_actors_name = { --arial narrow
        {"Экспортировать", "MAGE", 63},
        {"Готово", "DEATHKNIGHT", },
        {"Создать", "SHAMAN", },
        {"Текущий", "MONK", },
        {"список команд", "HUNTER", },
        {"центр", "SHAMAN", },
        {"Разное", "WARRIOR", },
    }
    
    local tw_actor_name = { --GBK
        {"造成傷害目標", "ROGUE", },
        {"怒氣生�", "DEATHKNIGHT", },
        {"承受治療", "WARLOCK", },
        {"格檔", "PRIEST", },
        {"中央", "MAGE", },
        {"傷害", "SHAMAN", },
        {"建立", "MONK", },
        {"編輯", "WARRIOR", },
        {"儲存變更", "ROGUE", },
        {"刪除", "DEATHKNIGHT", },
        {"從", "WARLOCK", },
        {"吸收", "PRIEST", },
        {"加到書籤", "MAGE", },
        {"最大化", "SHAMAN", },
        {"未命中", "MONK", },
        {"�進階", "WARRIOR", },
    }
    
    local cn_actor_name = { --GBK
        {"打断", "PRIEST"},
        {"恢复", "PRIEST", 257},
        {"自动射击", "WARLOCK", 267},
        {"平均", "PALADIN", },
        {"团队", "WARRIOR", },
        {"当前", "WARRIOR", },
        {"完毕", "DEATHKNIGHT", },
        {"存储变更", "MAGE", },
        {"闪避", "MAGE", },
        {"空的片段", "ROGUE", },
        {"删除", "ROGUE", },
        {"治疗暴击", "ROGUE", },
    }
    
    local korean_actor_name = { --2002
        {"적이 받은 피해", "ROGUE", },
        {"초과 치유", "DEATHKNIGHT", },
        {"자동 사격", "WARLOCK", },
        {"시전", "PRIEST", },
        {"현재", "MAGE", },
        {"취소", "SHAMAN", },
        {"내보내기", "MONK", },
        {"(사용자 설정)", "WARRIOR", },
        {"방어", "ROGUE", },
        {"예제", "DEATHKNIGHT", },
        {"특화", "WARLOCK", },
        {"최소", "PRIEST", },
        {"미러 이미지", "MAGE", },
        {"가장자리", "SHAMAN", },
        {"외형", "MONK", },
        {"아바타 선택", "WARRIOR", },
    }

    if (not alphabet or alphabet == "en") then
        actors_name = actors_name
        
    elseif (alphabet == "ru") then
        actors_name = russian_actors_name
        
    elseif (alphabet == "cn") then
        actors_name = cn_actor_name
        
    elseif (alphabet == "ko") then
        actors_name = korean_actor_name

    elseif (alphabet == "tw") then
        actors_name = tw_actor_name
        
    end
    
    local actors_classes = CLASS_SORT_ORDER
    
    local total_damage = 0
    local total_heal = 0
    
    for i = 1, 10 do
    
        local who = actors_name [math.random (1, #actors_name)]
    
        local robot = current_combat[1]:PegarCombatente ("0x0000-0000-0000", who[1], 0x114, true)
        robot.grupo = true
        
        robot.classe = who [2]
        
        if (who[3]) then
            robot.spec = who[3]
        elseif (robot.classe == "DEATHKNIGHT") then
            local specs = {250, 251, 252}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "DRUID") then
            local specs = {102, 103, 104, 105}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "HUNTER") then
            local specs = {253, 254, 255}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "MAGE") then
            local specs = {62, 63, 64}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "MONK") then
            local specs = {268, 269, 270}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "PALADIN") then
            local specs = {65, 66, 70}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "PRIEST") then
            local specs = {256, 257, 258}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "ROGUE") then
            local specs = {259, 260, 261}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "SHAMAN") then
            local specs = {262, 263, 264}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "WARLOCK") then
            local specs = {265, 266, 267}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "WARRIOR") then
            local specs = {71, 72, 73}
            robot.spec = specs [math.random (1, #specs)]
        end
        
        robot.total = math.random (10000000, 60000000)
        robot.damage_taken = math.random (10000000, 60000000)
        robot.friendlyfire_total = math.random (10000000, 60000000)
        
        total_damage = total_damage + robot.total
        
        if (robot.nome == "King Djoffrey") then
            local robot_death = current_combat[4]:PegarCombatente ("0x0000-0000-0000", robot.nome, 0x114, true)
            robot_death.grupo = true
            robot_death.classe = robot.classe
            local esta_morte = {{true, 96648, 100000, time(), 0, "Lady Holenna"}, {true, 96648, 100000, time()-52, 100000, "Lady Holenna"}, {true, 96648, 100000, time()-86, 200000, "Lady Holenna"}, {true, 96648, 100000, time()-101, 300000, "Lady Holenna"}, {false, 55296, 400000, time()-54, 400000, "King Djoffrey"}, {true, 14185, 0, time()-59, 400000, "Lady Holenna"}, {false, 87351, 400000, time()-154, 400000, "King Djoffrey"}, {false, 56236, 400000, time()-158, 400000, "King Djoffrey"} } 
            local t = {esta_morte, time(), robot.nome, robot.classe, 400000, "52m 12s",  ["dead"] = true}
            table.insert (current_combat.last_events_tables, #current_combat.last_events_tables+1, t)
            
        elseif (robot.nome == "Mr. President") then	
            rawset (Details.spellcache, 56488, {"Nuke", 56488, [[Interface\ICONS\inv_gizmo_supersappercharge]]})
            robot.spells:PegaHabilidade (56488, true, "SPELL_DAMAGE")
            robot.spells._ActorTable [56488].total = robot.total
        end
        
        local who = actors_name [math.random (1, #actors_name)]
        local robot = current_combat[2]:PegarCombatente ("0x0000-0000-0000", who[1], 0x114, true)
        robot.grupo = true
        robot.classe = who[2]
        
        if (who[3]) then
            robot.spec = who[3]
        elseif (robot.classe == "DEATHKNIGHT") then
            local specs = {250, 251, 252}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "DRUID") then
            local specs = {102, 103, 104, 105}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "HUNTER") then
            local specs = {253, 254, 255}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "MAGE") then
            local specs = {62, 63, 64}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "MONK") then
            local specs = {268, 269, 270}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "PALADIN") then
            local specs = {65, 66, 70}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "PRIEST") then
            local specs = {256, 257, 258}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "ROGUE") then
            local specs = {259, 260, 261}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "SHAMAN") then
            local specs = {262, 263, 264}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "WARLOCK") then
            local specs = {265, 266, 267}
            robot.spec = specs [math.random (1, #specs)]
        elseif (robot.classe == "WARRIOR") then
            local specs = {71, 72, 73}
            robot.spec = specs [math.random (1, #specs)]
        end
        
        robot.total = math.random (10000000, 60000000)
        robot.totalover = math.random (10000000, 60000000)
        robot.totalabsorb = math.random (10000000, 60000000)
        robot.healing_taken = math.random (10000000, 60000000)
        
        total_heal = total_heal + robot.total
        
    end
    
    --current_combat.start_time = time()-360
    current_combat.start_time = GetTime() - 360
    --current_combat.end_time = time()
    current_combat.end_time = GetTime()
    
    current_combat.totals_grupo [1] = total_damage
    current_combat.totals_grupo [2] = total_heal
    current_combat.totals [1] = total_damage
    current_combat.totals [2] = total_heal
    
    for _, instance in ipairs (Details.tabela_instancias) do 
        if (instance:IsEnabled()) then
            instance:InstanceReset()
        end
    end
    
    current_combat.enemy = "Illidan Stormrage"
end
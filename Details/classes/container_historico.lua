local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

--lua api
local _table_remove = table.remove
local _table_insert = table.insert
local _setmetatable = setmetatable
local _table_wipe = table.wipe

local _detalhes = 		_G._detalhes
local gump = 			_detalhes.gump

local combate =			_detalhes.combate
local historico = 			_detalhes.historico
local barra_total =		_detalhes.barra_total
local container_pets =		_detalhes.container_pets
local timeMachine =		_detalhes.timeMachine

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> API

--> reset only the overall data
function _detalhes:ResetSegmentOverallData()
	return historico:resetar_overall()
end

--> reset segments and overall data
function _detalhes:ResetSegmentData()
	return historico:resetar()
end

--> returns the current active segment
function _detalhes:GetCurrentCombat()
	return _detalhes.tabela_vigente
end

--> returns a private table containing all stored segments
function _detalhes:GetCombatSegments()
	return _detalhes.tabela_historico.tabelas
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal

function historico:NovoHistorico()
	local esta_tabela = {tabelas = {}}
	_setmetatable (esta_tabela, historico)
	return esta_tabela
end

function historico:adicionar_overall (tabela)

	local zoneName, zoneType = GetInstanceInfo()
	if (zoneType ~= "none" and tabela:GetCombatTime() <= _detalhes.minimum_overall_combat_time) then
		return
	end

	if (_detalhes.overall_clear_newboss) then
		--> only for raids
		if (tabela.instance_type == "raid" and tabela.is_boss) then
			if (_detalhes.last_encounter ~= _detalhes.last_encounter2) then
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) new boss detected 'overall_clear_newboss' is true, cleaning overall data.")
				end
				for index, combat in ipairs (_detalhes.tabela_historico.tabelas) do 
					combat.overall_added = false
				end
				historico:resetar_overall()
			end
		end
	end
	
	if (tabela.overall_added) then
		_detalhes:Msg ("error > attempt to add a segment already added > func historico:adicionar_overall()")
		return
	end
	local mythicInfo = tabela.is_mythic_dungeon
	if (mythicInfo) then
		--> do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			_detalhes:Msg ("error > attempt to add a TrashOverallSegment > func historico:adicionar_overall()")
			return
		elseif (mythicInfo.OverallSegment) then
			_detalhes:Msg ("error > attempt to add a OverallSegment > func historico:adicionar_overall()")
			return
		end
	end
	
	--> store the segments added to the overall data
	_detalhes.tabela_overall.segments_added = _detalhes.tabela_overall.segments_added or {}
	local this_clock = tabela.data_inicio
	
	local combatName = tabela:GetCombatName (true)
	local combatTime = tabela:GetCombatTime()
	local combatType = tabela:GetCombatType()
	
	tinsert (_detalhes.tabela_overall.segments_added, 1, {name = combatName, elapsed = combatTime, clock = this_clock, type = combatType})

	if (#_detalhes.tabela_overall.segments_added > 30) then
		tremove (_detalhes.tabela_overall.segments_added, 31)
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) adding the segment to overall data: " .. (tabela:GetCombatName (true) or "no name") .. " with time of: " .. (tabela:GetCombatTime() or "no time"))
	end
	
	_detalhes.tabela_overall = _detalhes.tabela_overall + tabela
	tabela.overall_added = true
	
	if (not _detalhes.tabela_overall.overall_enemy_name) then
		_detalhes.tabela_overall.overall_enemy_name = tabela.is_boss and tabela.is_boss.name or tabela.enemy
	else
		if (_detalhes.tabela_overall.overall_enemy_name ~= (tabela.is_boss and tabela.is_boss.name or tabela.enemy)) then
			_detalhes.tabela_overall.overall_enemy_name = "-- x -- x --"
		end
	end
	
	--
		if (_detalhes.tabela_overall.start_time == 0) then
			--print ("start_time == 0 NO!")
			_detalhes.tabela_overall:SetStartTime (tabela.start_time)
			_detalhes.tabela_overall:SetEndTime (tabela.end_time)
		else
			--print ("start_time ~= 0 OKAY", tabela.start_time, _detalhes.tabela_overall:GetCombatTime(), tabela.start_time - _detalhes.tabela_overall:GetCombatTime())
			_detalhes.tabela_overall:SetStartTime (tabela.start_time - _detalhes.tabela_overall:GetCombatTime())
			_detalhes.tabela_overall:SetEndTime (tabela.end_time)
		end
		
		if (_detalhes.tabela_overall.data_inicio == 0) then
			_detalhes.tabela_overall.data_inicio = _detalhes.tabela_vigente.data_inicio or 0
		end
	--
	
	_detalhes.tabela_overall:seta_data (_detalhes._detalhes_props.DATA_TYPE_END)
	
	_detalhes:ClockPluginTickOnSegment()
	
	for id, instance in _detalhes:ListInstances() do
		if (instance:IsEnabled()) then
			if (instance:GetSegment() == -1) then
				instance:ForceRefresh()
				--instance:AtualizaGumpPrincipal (true)
				--print ("isntance", id, "overall updated.")
			end
		end
	end
	
end

function _detalhes:ScheduleAddCombatToOverall (combat) --deprecated (15/03/2019)
	local canAdd = _detalhes:CanAddCombatToOverall (combat)
	if (canAdd) then
		_detalhes.schedule_add_to_overall = _detalhes.schedule_add_to_overall or {}
		tinsert (_detalhes.schedule_add_to_overall, combat)
	end
end

function _detalhes:CanAddCombatToOverall (tabela)

	--> already added
	if (tabela.overall_added) then
		return false
	end
	
	--> already scheduled to add
	if (_detalhes.schedule_add_to_overall) then --deprecated
		for _, combat in ipairs (_detalhes.schedule_add_to_overall) do
			if (combat == tabela) then
				return false
			end
		end
	end

	--> special cases
	local mythicInfo = tabela.is_mythic_dungeon
	if (mythicInfo) then
		--> do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			return false
		elseif (mythicInfo.OverallSegment) then
			return false
		end
	end

	--> raid boss - flag 0x1
	if (bit.band (_detalhes.overall_flag, 0x1) ~= 0) then 
		if (tabela.is_boss and tabela.instance_type == "raid" and not tabela.is_pvp) then
			if (tabela:GetCombatTime() >= 30) then
				return true
			end
		end
	end
	
	--> raid trash - flag 0x2
	if (bit.band (_detalhes.overall_flag, 0x2) ~= 0) then 
		if (tabela.is_trash and tabela.instance_type == "raid") then
			return true
		end
	end
	
	--> dungeon boss - flag 0x4
	if (bit.band (_detalhes.overall_flag, 0x4) ~= 0) then 
		if (tabela.is_boss and tabela.instance_type == "party" and not tabela.is_pvp) then
			return true
		end
	end
	
	--> dungeon trash - flag 0x8
	if (bit.band (_detalhes.overall_flag, 0x8) ~= 0) then 
		if ((tabela.is_trash or tabela.is_mythic_dungeon_trash) and tabela.instance_type == "party") then
			return true
		end
	end
	
	--> any combat
	if (bit.band (_detalhes.overall_flag, 0x10) ~= 0) then 
		return true
	end
	
	--> is a PvP combat
	if (tabela.is_pvp or tabela.is_arena) then 
		return true
	end
	
	return false
end

--> sai do combate, chamou adicionar a tabela ao hist�rico
function historico:adicionar (tabela)

	local tamanho = #self.tabelas
	
	--> verifica se precisa dar UnFreeze()
	if (tamanho < _detalhes.segments_amount) then --> vai preencher um novo index vazio
		local ultima_tabela = self.tabelas[tamanho]
		if (not ultima_tabela) then --> n�o ha tabelas no historico, esta ser� a #1
			--> pega a tabela do combate atual
			ultima_tabela = tabela
		end
		_detalhes:InstanciaCallFunction (_detalhes.CheckFreeze, tamanho+1, ultima_tabela)
	end

	--> add to history table
	_table_insert (self.tabelas, 1, tabela)
	
	--> count boss tries
	local boss = tabela.is_boss and tabela.is_boss.name
	if (boss) then
		local try_number = _detalhes.encounter_counter [boss]
		
		if (not try_number) then
			local previous_combat
			for i = 2, #self.tabelas do
				previous_combat = self.tabelas [i]
				if (previous_combat and previous_combat.is_boss and previous_combat.is_boss.name and previous_combat.is_boss.try_number and previous_combat.is_boss.name == boss and not previous_combat.is_boss.killed) then
					try_number = previous_combat.is_boss.try_number + 1
					break
				end
			end
			
			if (not try_number) then
				try_number = 1
			end
		else
			try_number = _detalhes.encounter_counter [boss] + 1
		end
		
		_detalhes.encounter_counter [boss] = try_number
		tabela.is_boss.try_number = try_number
	end
	
	--> see if can add the encounter to overall data
	local canAddToOverall = _detalhes:CanAddCombatToOverall (tabela)
	
	if (canAddToOverall) then
		--if (InCombatLockdown()) then
		--	_detalhes:ScheduleAddCombatToOverall (tabela)
		--	if (_detalhes.debug) then
		--		_detalhes:Msg ("(debug) overall data flag match > in combat scheduling overall addition.")
		--	end
		--else
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) overall data flag match addind the combat to overall data.")
			end
			historico:adicionar_overall (tabela)
		--end
	end
	
	--> erase trash segments
	if (self.tabelas[2]) then
		local _segundo_combate = self.tabelas[2]
		local container_damage = _segundo_combate [1]
		local container_heal = _segundo_combate [2]
		
		--regular cleanup
		for _, jogador in ipairs (container_damage._ActorTable) do 
			--> remover a tabela de last events
			jogador.last_events_table =  nil
			--> verifica se ele ainda esta registrado na time machine
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		for _, jogador in ipairs (container_heal._ActorTable) do 
			--> remover a tabela de last events
			jogador.last_events_table =  nil
			--> verifica se ele ainda esta registrado na time machine
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		
		if (_detalhes.trash_auto_remove) then
		
			local _terceiro_combate = self.tabelas[3]
		
			if (_terceiro_combate and not _terceiro_combate.is_mythic_dungeon_segment) then
			
				if ((_terceiro_combate.is_trash and not _terceiro_combate.is_boss) or (_terceiro_combate.is_temporary)) then
					--> verificar novamente a time machine
					for _, jogador in ipairs (_terceiro_combate [1]._ActorTable) do --> damage
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					for _, jogador in ipairs (_terceiro_combate [2]._ActorTable) do --> heal
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					--> remover
					_table_remove (self.tabelas, 3)
					_detalhes:SendEvent ("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
				
			end

		end
		
	end

	--> verifica se precisa apagar a �ltima tabela do hist�rico
	if (#self.tabelas > _detalhes.segments_amount) then
		
		local combat_removed, combat_index
		
		--> verifica se est�o dando try em um boss e remove o combate menos relevante
		local bossid = tabela.is_boss and tabela.is_boss.id
		
		local last_segment = self.tabelas [#self.tabelas]
		local last_bossid = last_segment.is_boss and last_segment.is_boss.id
		
		if (_detalhes.zone_type == "raid" and bossid and last_bossid and bossid == last_bossid) then
		
			local shorter_combat
			local shorter_id
			local min_time = 99999
			
			for i = 4, #self.tabelas do
				local combat = self.tabelas [i]
				if (combat.is_boss and combat.is_boss.id == bossid and combat:GetCombatTime() < min_time and not combat.is_boss.killed) then
					shorter_combat = combat
					shorter_id = i
					min_time = combat:GetCombatTime()
				end
			end
			
			if (shorter_combat) then
				combat_removed = shorter_combat
				combat_index = shorter_id
			end
		end
		
		if (not combat_removed) then
			combat_removed = self.tabelas [#self.tabelas]
			combat_index = #self.tabelas
		end

		--> verificar novamente a time machine
		for _, jogador in ipairs (combat_removed [1]._ActorTable) do --> damage
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		for _, jogador in ipairs (combat_removed [2]._ActorTable) do --> heal
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		
		--> remover
		_table_remove (self.tabelas, combat_index)
		_detalhes:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
		
	end
	
	--> chama a fun��o que ir� atualizar as inst�ncias com segmentos no hist�rico
	_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos_AfterCombat, self)
	--_detalhes:InstanciaCallFunction (_detalhes.AtualizarJanela)
end

--> verifica se tem alguma instancia congelada mostrando o segmento rec�m liberado
function _detalhes:CheckFreeze (instancia, index_liberado, tabela)
	if (instancia.freezed) then --> esta congelada
		if (instancia.segmento == index_liberado) then
			instancia.showing = tabela
			instancia:UnFreeze()
		end
	end
end

function _detalhes:OverallOptions (reset_new_boss, reset_new_challenge, reset_on_logoff)
	if (reset_new_boss == nil) then
		reset_new_boss = _detalhes.overall_clear_newboss
	end
	if (reset_new_challenge == nil) then
		reset_new_challenge = _detalhes.overall_clear_newchallenge
	end
	if (reset_on_logoff == nil) then
		reset_on_logoff = _detalhes.overall_clear_logout
	end
	
	_detalhes.overall_clear_newboss = reset_new_boss
	_detalhes.overall_clear_newchallenge = reset_new_challenge
	_detalhes.overall_clear_logout = reset_on_logoff
end

function historico:resetar_overall()
	--if (InCombatLockdown()) then
	--	_detalhes:Msg (Loc ["STRING_ERASE_IN_COMBAT"])
	--	_detalhes.schedule_remove_overall = true
	--else
		--> fecha a janela de informa��es do jogador
		_detalhes:FechaJanelaInfo()
		
		_detalhes.tabela_overall = combate:NovaTabela()
		
		for index, instancia in ipairs (_detalhes.tabela_instancias) do 
			if (instancia.ativa and instancia.segmento == -1) then
				instancia:InstanceReset()
				instancia:ReajustaGump()
			end
		end
		
		if (_detalhes.schedule_add_to_overall) then --deprecated
			wipe (_detalhes.schedule_add_to_overall)
		end
	--end
	
	--> stop bar testing if any
	_detalhes:StopTestBarUpdate()
	
	_detalhes:ClockPluginTickOnSegment()
end

function historico:resetar()

	if (_detalhes.bosswindow) then
		_detalhes.bosswindow:Reset()
	end
	
	--> stop bar testing if any
	_detalhes:StopTestBarUpdate()
	
	if (_detalhes.tabela_vigente.verifica_combate) then --> finaliza a checagem se esta ou n�o no combate
		_detalhes:CancelTimer (_detalhes.tabela_vigente.verifica_combate)
	end
	
	_detalhes.last_closed_combat = nil
	
	--> remove mythic dungeon schedules if any
	_detalhes.schedule_mythicdungeon_trash_merge = nil
	_detalhes.schedule_mythicdungeon_endtrash_merge = nil
	_detalhes.schedule_mythicdungeon_overallrun_merge = nil
	
	--> clear other schedules
	_detalhes.schedule_flag_boss_components = nil
	_detalhes.schedule_store_boss_encounter = nil
	--_detalhes.schedule_remove_overall = nil
	
	--> fecha a janela de informa��es do jogador
	_detalhes:FechaJanelaInfo()
	
	--> empty temporary tables
	_detalhes.atributo_damage:ClearTempTables()
	
	for _, combate in ipairs (_detalhes.tabela_historico.tabelas) do 
		_table_wipe (combate)
	end
	_table_wipe (_detalhes.tabela_vigente)
	_table_wipe (_detalhes.tabela_overall)
	_table_wipe (_detalhes.spellcache)
	
	if (_detalhes.schedule_add_to_overall) then --deprecated
		wipe (_detalhes.schedule_add_to_overall)
	end
	
	_detalhes:LimparPets()
	_detalhes:ResetSpecCache (true) --> for�ar
	
	-- novo container de historico
	_detalhes.tabela_historico = historico:NovoHistorico() --joga fora a tabela antiga e cria uma nova
	--novo container para armazenar pets
	_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
	_detalhes:UpdateContainerCombatentes()
	_detalhes.container_pets:BuscarPets()
	-- nova tabela do overall e current
	_detalhes.tabela_overall = combate:NovaTabela() --joga fora a tabela antiga e cria uma nova
	-- cria nova tabela do combate atual
	_detalhes.tabela_vigente = combate:NovaTabela (nil, _detalhes.tabela_overall)
	
	--marca o addon como fora de combate
	_detalhes.in_combat = false
	--zera o contador de combates
	_detalhes:NumeroCombate (0)
	
	--> limpa o cache de magias
	_detalhes:ClearSpellCache()
	
	--> limpa a tabela de escudos
	_table_wipe (_detalhes.escudos)
	
	--> reinicia a time machine
	timeMachine:Reiniciar()
	
	_table_wipe (_detalhes.cache_damage_group)
	_table_wipe (_detalhes.cache_healing_group)
	_detalhes:UpdateParserGears()

	if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
		--> workarround for the "script run too long" issue while outside the combat lockdown
		local cleargarbage = function()
			collectgarbage()
		end
		local successful, errortext = pcall (cleargarbage)
		if (not successful) then
			_detalhes:Msg ("couldn't call collectgarbage()")
		end
	else
		_detalhes.schedule_hard_garbage_collect = true
	end
	
	_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
	_detalhes:InstanciaCallFunction (_detalhes.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
	_detalhes:InstanciaCallFunction (_detalhes.ResetaGump) --_detalhes:ResetaGump ("de todas as instancias")
	_detalhes:InstanciaCallFunction (gump.Fade, "in", nil, "barras")
	
	_detalhes:AtualizaGumpPrincipal (-1) --atualiza todas as instancias
	
	_detalhes:SendEvent ("DETAILS_DATA_RESET", nil, nil)
	
end

function _detalhes.refresh:r_historico (este_historico)
	_setmetatable (este_historico, historico)
	--este_historico.__index = historico
end

--[[
		elseif (_detalhes.trash_concatenate) then
			
			if (true) then
				return
			end
			
			if (_terceiro_combate) then
				if (_terceiro_combate.is_trash and _segundo_combate.is_trash and not _terceiro_combate.is_boss and not _segundo_combate.is_boss) then
					--> tabela 2 deve ser deletada e somada a tabela 1
					if (_detalhes.debug) then
						detalhes:Msg ("(debug) concatenating two trash segments.")
					end
					
					_segundo_combate = _segundo_combate + _terceiro_combate
					_detalhes.tabela_overall = _detalhes.tabela_overall - _terceiro_combate
					
					_segundo_combate.is_trash = true

					--> verificar novamente a time machine
					for _, jogador in ipairs (_terceiro_combate [1]._ActorTable) do --> damage
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					for _, jogador in ipairs (_terceiro_combate [2]._ActorTable) do --> heal
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					--> remover
					_table_remove (self.tabelas, 3)
					_detalhes:SendEvent ("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
			end
--]]

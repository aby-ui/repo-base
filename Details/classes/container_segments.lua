local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )

--lua api
local tremove = table.remove
local tinsert = table.insert
local wipe = table.wipe

local Details = _G._detalhes
local _
local addonName, Details222 = ...

local combatClass = Details.combate
local segmentClass = Details.historico
local timeMachine = Details.timeMachine

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--API

--reset only the overall data
function Details:ResetSegmentOverallData()
	return segmentClass:resetar_overall()
end

--reset segments and overall data
function Details:ResetSegmentData()
	return segmentClass:resetar()
end

--returns the current active segment
function Details:GetCurrentCombat()
	return Details.tabela_vigente
end

--returns a private table containing all stored segments
function Details:GetCombatSegments()
	return Details.tabela_historico.tabelas
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--internal

function segmentClass:NovoHistorico()
	local esta_tabela = {tabelas = {}}
	setmetatable(esta_tabela, segmentClass)
	return esta_tabela
end

function segmentClass:adicionar_overall (tabela)
	local zoneName, zoneType = GetInstanceInfo()
	if (zoneType ~= "none" and tabela:GetCombatTime() <= Details.minimum_overall_combat_time) then
		return
	end

	if (Details.overall_clear_newboss) then
		--only for raids
		if (tabela.instance_type == "raid" and tabela.is_boss) then
			if (Details.last_encounter ~= Details.last_encounter2) then
				if (Details.debug) then
					Details:Msg("(debug) new boss detected 'overall_clear_newboss' is true, cleaning overall data.")
				end
				for index, combat in ipairs(Details.tabela_historico.tabelas) do
					combat.overall_added = false
				end
				segmentClass:resetar_overall()
			end
		end
	end

	if (tabela.overall_added) then
		Details:Msg("error > attempt to add a segment already added > func historico:adicionar_overall()")
		return
	end

	local mythicInfo = tabela.is_mythic_dungeon
	if (mythicInfo) then
		--do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			Details:Msg("error > attempt to add a TrashOverallSegment > func historico:adicionar_overall()")
			return
		elseif (mythicInfo.OverallSegment) then
			Details:Msg("error > attempt to add a OverallSegment > func historico:adicionar_overall()")
			return
		end
	end

	--store the segments added to the overall data
	Details.tabela_overall.segments_added = Details.tabela_overall.segments_added or {}
	local this_clock = tabela.data_inicio

	local combatName = tabela:GetCombatName(true)
	local combatTime = tabela:GetCombatTime()
	local combatType = tabela:GetCombatType()

	tinsert(Details.tabela_overall.segments_added, 1, {name = combatName, elapsed = combatTime, clock = this_clock, type = combatType})

	if (#Details.tabela_overall.segments_added > 40) then
		tremove(Details.tabela_overall.segments_added, 41)
	end

	if (Details.debug) then
		Details:Msg("(debug) adding the segment to overall data: " .. (tabela:GetCombatName(true) or "no name") .. " with time of: " .. (tabela:GetCombatTime() or "no time"))
	end

	Details.tabela_overall = Details.tabela_overall + tabela
	tabela.overall_added = true

	if (not Details.tabela_overall.overall_enemy_name) then
		Details.tabela_overall.overall_enemy_name = tabela.is_boss and tabela.is_boss.name or tabela.enemy
	else
		if (Details.tabela_overall.overall_enemy_name ~= (tabela.is_boss and tabela.is_boss.name or tabela.enemy)) then
			Details.tabela_overall.overall_enemy_name = "-- x -- x --"
		end
	end

	if (Details.tabela_overall.start_time == 0) then
		Details.tabela_overall:SetStartTime (tabela.start_time)
		Details.tabela_overall:SetEndTime (tabela.end_time)
	else
		Details.tabela_overall:SetStartTime (tabela.start_time - Details.tabela_overall:GetCombatTime())
		Details.tabela_overall:SetEndTime (tabela.end_time)
	end

	if (Details.tabela_overall.data_inicio == 0) then
		Details.tabela_overall.data_inicio = Details.tabela_vigente.data_inicio or 0
	end

	Details.tabela_overall:seta_data (Details._detalhes_props.DATA_TYPE_END)
	Details:ClockPluginTickOnSegment()

	for id, instance in Details:ListInstances() do
		if (instance:IsEnabled()) then
			if (instance:GetSegment() == -1) then
				instance:ForceRefresh()
			end
		end
	end
end

function Details:ScheduleAddCombatToOverall (combat) --deprecated (15/03/2019)
	local canAdd = Details:CanAddCombatToOverall (combat)
	if (canAdd) then
		Details.schedule_add_to_overall = Details.schedule_add_to_overall or {}
		tinsert(Details.schedule_add_to_overall, combat)
	end
end

function Details:CanAddCombatToOverall (tabela)
	--already added
	if (tabela.overall_added) then
		return false
	end

	--already scheduled to add
	if (Details.schedule_add_to_overall) then --deprecated
		for _, combat in ipairs(Details.schedule_add_to_overall) do
			if (combat == tabela) then
				return false
			end
		end
	end

	--special cases
	local mythicInfo = tabela.is_mythic_dungeon
	if (mythicInfo) then
		--do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			return false

		elseif (mythicInfo.OverallSegment) then
			return false
		end
	end

	--raid boss - flag 0x1
	if (bit.band(Details.overall_flag, 0x1) ~= 0) then
		if (tabela.is_boss and tabela.instance_type == "raid" and not tabela.is_pvp) then
			if (tabela:GetCombatTime() >= 30) then
				return true
			end
		end
	end

	--raid trash - flag 0x2
	if (bit.band(Details.overall_flag, 0x2) ~= 0) then
		if (tabela.is_trash and tabela.instance_type == "raid") then
			return true
		end
	end

	--dungeon boss - flag 0x4
	if (bit.band(Details.overall_flag, 0x4) ~= 0) then
		if (tabela.is_boss and tabela.instance_type == "party" and not tabela.is_pvp) then
			return true
		end
	end

	--dungeon trash - flag 0x8
	if (bit.band(Details.overall_flag, 0x8) ~= 0) then
		if ((tabela.is_trash or tabela.is_mythic_dungeon_trash) and tabela.instance_type == "party") then
			return true
		end
	end

	--any combat
	if (bit.band(Details.overall_flag, 0x10) ~= 0) then
		return true
	end

	--is a PvP combat
	if (tabela.is_pvp or tabela.is_arena) then
		return true
	end

	return false
end

--sai do combate, chamou adicionar a tabela ao hist�rico
function segmentClass:adicionar (tabela)

	local tamanho = #self.tabelas

	--verifica se precisa dar UnFreeze()
	if (tamanho < Details.segments_amount) then --vai preencher um novo index vazio
		local ultima_tabela = self.tabelas[tamanho]
		if (not ultima_tabela) then --n�o ha tabelas no historico, esta ser� a #1
			--pega a tabela do combate atual
			ultima_tabela = tabela
		end
		Details:InstanciaCallFunction(Details.CheckFreeze, tamanho+1, ultima_tabela)
	end

	--add to history table
	tinsert(self.tabelas, 1, tabela)

	--count boss tries
	local boss = tabela.is_boss and tabela.is_boss.name
	if (boss) then
		local try_number = Details.encounter_counter [boss]

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
			try_number = Details.encounter_counter [boss] + 1
		end

		Details.encounter_counter [boss] = try_number
		tabela.is_boss.try_number = try_number
	end

	--see if can add the encounter to overall data
	local canAddToOverall = Details:CanAddCombatToOverall (tabela)

	if (canAddToOverall) then
		--if (InCombatLockdown()) then
		--	_detalhes:ScheduleAddCombatToOverall (tabela)
		--	if (_detalhes.debug) then
		--		_detalhes:Msg("(debug) overall data flag match > in combat scheduling overall addition.")
		--	end
		--else
			if (Details.debug) then
				Details:Msg("(debug) overall data flag match addind the combat to overall data.")
			end
			segmentClass:adicionar_overall (tabela)
		--end
	end

	--erase trash segments
	if (self.tabelas[2]) then
		local _segundo_combate = self.tabelas[2]
		local container_damage = _segundo_combate [1]
		local container_heal = _segundo_combate [2]

		--regular cleanup
		for _, jogador in ipairs(container_damage._ActorTable) do
			--remover a tabela de last events
			jogador.last_events_table =  nil
			--verifica se ele ainda esta registrado na time machine
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		for _, jogador in ipairs(container_heal._ActorTable) do
			--remover a tabela de last events
			jogador.last_events_table =  nil
			--verifica se ele ainda esta registrado na time machine
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end

		if (Details.trash_auto_remove) then
			local _terceiro_combate = self.tabelas[3]

			if (_terceiro_combate and not _terceiro_combate.is_mythic_dungeon_segment) then

				if ((_terceiro_combate.is_trash and not _terceiro_combate.is_boss) or (_terceiro_combate.is_temporary)) then
					--verificar novamente a time machine
					for _, jogador in ipairs(_terceiro_combate [1]._ActorTable) do --damage
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					for _, jogador in ipairs(_terceiro_combate [2]._ActorTable) do --heal
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					--remover
					tremove(self.tabelas, 3)
					Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end

			end

		end

	end

	--verifica se precisa apagar a �ltima tabela do hist�rico
	if (#self.tabelas > Details.segments_amount) then

		local combat_removed, combat_index

		--verifica se est�o dando try em um boss e remove o combate menos relevante
		local bossid = tabela.is_boss and tabela.is_boss.id

		local last_segment = self.tabelas [#self.tabelas]
		local last_bossid = last_segment.is_boss and last_segment.is_boss.id

		if (Details.zone_type == "raid" and bossid and last_bossid and bossid == last_bossid) then

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

		--verificar novamente a time machine
		for _, jogador in ipairs(combat_removed [1]._ActorTable) do --damage
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end
		for _, jogador in ipairs(combat_removed [2]._ActorTable) do --heal
			if (jogador.timeMachine) then
				jogador:DesregistrarNaTimeMachine()
			end
		end

		--remover
		tremove(self.tabelas, combat_index)
		Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
	end

	--chama a fun��o que ir� atualizar as inst�ncias com segmentos no hist�rico
	Details:InstanciaCallFunction(Details.AtualizaSegmentos_AfterCombat, self)
	--_detalhes:InstanciaCallFunction(_detalhes.AtualizarJanela)
end

--verifica se tem alguma instancia congelada mostrando o segmento rec�m liberado
function Details:CheckFreeze (instancia, index_liberado, tabela)
	if (instancia.freezed) then --esta congelada
		if (instancia.segmento == index_liberado) then
			instancia.showing = tabela
			instancia:UnFreeze()
		end
	end
end

function Details:SetOverallResetOptions (reset_new_boss, reset_new_challenge, reset_on_logoff, reset_new_pvp)
	if (reset_new_boss == nil) then
		reset_new_boss = Details.overall_clear_newboss
	end
	if (reset_new_challenge == nil) then
		reset_new_challenge = Details.overall_clear_newchallenge
	end
	if (reset_on_logoff == nil) then
		reset_on_logoff = Details.overall_clear_logout
	end
	if (reset_new_pvp == nil) then
		reset_new_pvp = Details.overall_clear_pvp
	end

	Details.overall_clear_newboss = reset_new_boss
	Details.overall_clear_newchallenge = reset_new_challenge
	Details.overall_clear_logout = reset_on_logoff
	Details.overall_clear_pvp	 = reset_new_pvp
end

function segmentClass:resetar_overall()
	--if (InCombatLockdown()) then
	--	_detalhes:Msg(Loc ["STRING_ERASE_IN_COMBAT"])
	--	_detalhes.schedule_remove_overall = true
	--else
		--fecha a janela de informa��es do jogador
		Details:FechaJanelaInfo()

		Details.tabela_overall = combatClass:NovaTabela()

		for index, instancia in ipairs(Details.tabela_instancias) do
			if (instancia.ativa and instancia.segmento == -1) then
				instancia:InstanceReset()
				instancia:ReajustaGump()
			end
		end

		if (Details.schedule_add_to_overall) then --deprecated
			wipe (Details.schedule_add_to_overall)
		end
	--end

	--stop bar testing if any
	Details:StopTestBarUpdate()

	Details:ClockPluginTickOnSegment()
end

function segmentClass:resetar()
	if (Details.bosswindow) then
		Details.bosswindow:Reset()
	end

	--stop bar testing if any
	Details:StopTestBarUpdate()

	if (Details.tabela_vigente.verifica_combate) then --finaliza a checagem se esta ou n�o no combate
		Details:CancelTimer(Details.tabela_vigente.verifica_combate)
	end

	Details.last_closed_combat = nil

	--remove mythic dungeon schedules if any
	Details.schedule_mythicdungeon_trash_merge = nil
	Details.schedule_mythicdungeon_endtrash_merge = nil
	Details.schedule_mythicdungeon_overallrun_merge = nil

	--clear other schedules
	Details.schedule_flag_boss_components = nil
	Details.schedule_store_boss_encounter = nil
	--_detalhes.schedule_remove_overall = nil

	--fecha a janela de informa��es do jogador
	Details:FechaJanelaInfo()

	--empty temporary tables
	Details.atributo_damage:ClearTempTables()

	for _, combate in ipairs(Details.tabela_historico.tabelas) do
		wipe(combate)
	end
	wipe(Details.tabela_vigente)
	wipe(Details.tabela_overall)
	wipe(Details.spellcache)

	if (Details.schedule_add_to_overall) then --deprecated
		wipe (Details.schedule_add_to_overall)
	end

	Details:LimparPets()
	Details:ResetSpecCache (true) --for�ar

	-- novo container de historico
	Details.tabela_historico = segmentClass:NovoHistorico() --joga fora a tabela antiga e cria uma nova
	--novo container para armazenar pets
	Details.tabela_pets = Details.container_pets:NovoContainer()
	Details:UpdateContainerCombatentes()
	Details.container_pets:BuscarPets()
	-- nova tabela do overall e current
	Details.tabela_overall = combatClass:NovaTabela() --joga fora a tabela antiga e cria uma nova
	-- cria nova tabela do combate atual
	Details.tabela_vigente = combatClass:NovaTabela (nil, Details.tabela_overall)

	--marca o addon como fora de combate
	Details.in_combat = false
	--zera o contador de combates
	Details:NumeroCombate (0)

	--limpa o cache de magias
	Details:ClearSpellCache()

	--limpa a tabela de escudos
	wipe(Details.escudos)

	--reinicia a time machine
	timeMachine:Reiniciar()

	wipe(Details.cache_damage_group)
	wipe(Details.cache_healing_group)
	Details:UpdateParserGears()

	if (not InCombatLockdown() and not UnitAffectingCombat("player")) then
		--workarround for the "script run too long" issue while outside the combat lockdown
		local cleargarbage = function()
			collectgarbage()
		end
		local successful, errortext = pcall(cleargarbage)
		if (not successful) then
			Details:Msg("couldn't call collectgarbage()")
		end
	else
		Details.schedule_hard_garbage_collect = true
	end

	Details:InstanciaCallFunction(Details.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
	Details:InstanciaCallFunction(Details.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
	Details:InstanciaCallFunction(Details.ResetaGump) --_detalhes:ResetaGump ("de todas as instancias")
	Details:InstanciaCallFunction(Details.FadeHandler.Fader, "IN", nil, "barras")

	Details:RefreshMainWindow(-1) --atualiza todas as instancias

	Details:SendEvent("DETAILS_DATA_RESET", nil, nil)
end

function Details.refresh:r_historico (este_historico)
	setmetatable(este_historico, segmentClass)
	--este_historico.__index = historico
end

--[[
		elseif (_detalhes.trash_concatenate) then

			if (true) then
				return
			end

			if (_terceiro_combate) then
				if (_terceiro_combate.is_trash and _segundo_combate.is_trash and not _terceiro_combate.is_boss and not _segundo_combate.is_boss) then
					--tabela 2 deve ser deletada e somada a tabela 1
					if (_detalhes.debug) then
						detalhes:Msg("(debug) concatenating two trash segments.")
					end

					_segundo_combate = _segundo_combate + _terceiro_combate
					_detalhes.tabela_overall = _detalhes.tabela_overall - _terceiro_combate

					_segundo_combate.is_trash = true

					--verificar novamente a time machine
					for _, jogador in ipairs(_terceiro_combate [1]._ActorTable) do --damage
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					for _, jogador in ipairs(_terceiro_combate [2]._ActorTable) do --heal
						if (jogador.timeMachine) then
							jogador:DesregistrarNaTimeMachine()
						end
					end
					--remover
					_table_remove(self.tabelas, 3)
					_detalhes:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
			end
--]]

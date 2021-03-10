-- combat class object

	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	
--[[global]] DETAILS_TOTALS_ONLYGROUP = true

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable -- lua local
	local _ipairs = ipairs -- lua local
	local _pairs = pairs -- lua local
	local _bit_band = bit.band -- lua local
	local _date = date -- lua local
	local _table_remove = table.remove -- lua local
	local _rawget = rawget
	local _math_max = math.max
	local _math_floor = math.floor
	local _GetTime = GetTime

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local combate 	=	_detalhes.combate
	local container_combatentes = _detalhes.container_combatentes
	local class_type_dano 	= _detalhes.atributos.dano
	local class_type_cura		= _detalhes.atributos.cura
	local class_type_e_energy 	= _detalhes.atributos.e_energy
	local class_type_misc 	= _detalhes.atributos.misc
	
	local REACTION_HOSTILE =	0x00000040
	local CONTROL_PLAYER =		0x00000100

	--local _tempo = time()
	local _tempo = _GetTime()
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> api functions

	--combat (container type, actor name)
	_detalhes.call_combate = function (self, class_type, name)
		local container = self[class_type]
		local index_mapa = container._NameIndexTable [name]
		local actor = container._ActorTable [index_mapa]
		return actor
	end
	combate.__call = _detalhes.call_combate

	--get the start date and end date
	function combate:GetDate()
		return self.data_inicio, self.data_fim
	end
	
	--set the combat date
	function combate:SetDate (started, ended)
		if (started and type (started) == "string") then
			self.data_inicio = started
		end
		if (ended and type (ended) == "string") then
			self.data_fim = ended
		end		
	end
	
	--return data for charts
	function combate:GetTimeData (name)
		return self.TimeData [name]
	end
	
	function combate:GetContainer (attribute)
		return self [attribute]
	end
	
	function combate:GetRoster()
		return self.raid_roster
	end
	
	function combate:InstanceType()
		return _rawget (self, "instance_type")
	end
	
	function combate:IsTrash()
		return _rawget (self, "is_trash")
	end
	
	function combate:GetDifficulty()
		return self.is_boss and self.is_boss.diff
	end
	
	function combate:GetBossInfo()
		return self.is_boss
	end
	
	function combate:GetPhases()
		return self.PhaseData
	end
	
	function combate:GetPvPInfo()
		return self.is_pvp
	end
	
	function combate:GetMythicDungeonInfo()
		return self.is_mythic_dungeon
	end

	function combate:GetMythicDungeonTrashInfo()
		return self.is_mythic_dungeon_trash
	end
	
	function combate:IsMythicDungeon()
		local is_segment = self.is_mythic_dungeon_segment
		local run_id = self.is_mythic_dungeon_run_id
		return is_segment, run_id
	end
	
	function combate:IsMythicDungeonOverall()
		return self.is_mythic_dungeon and self.is_mythic_dungeon.OverallSegment
	end
	
	function combate:GetArenaInfo()
		return self.is_arena
	end
	
	function combate:GetDeaths()
		return self.last_events_tables
	end
	
	function combate:GetCombatId()
		return self.combat_id
	end
	
	function combate:GetCombatNumber()
		return self.combat_counter
	end
	
	function combate:GetAlteranatePower()
		return self.alternate_power
	end
	
	--return the name of the encounter or enemy
	function combate:GetCombatName (try_find)
		if (self.is_pvp) then
			return self.is_pvp.name
			
		elseif (self.is_boss) then
			return self.is_boss.encounter
			
		elseif (self.is_mythic_dungeon_trash) then
			return self.is_mythic_dungeon_trash.ZoneName .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")"
			
		elseif (_rawget (self, "is_trash")) then
			return Loc ["STRING_SEGMENT_TRASH"]
			
		else
			if (self.enemy) then
				return self.enemy
			end
			if (try_find) then
				return _detalhes:FindEnemy()
			end
		end
		return Loc ["STRING_UNKNOW"]
	end
	
	--[[global]] DETAILS_SEGMENTID_OVERALL = -1
	--[[global]] DETAILS_SEGMENTID_CURRENT = 0
	
	--enum segments type
	--[[global]] DETAILS_SEGMENTTYPE_GENERIC = 0
	
	--[[global]] DETAILS_SEGMENTTYPE_OVERALL = 1
	
	--[[global]] DETAILS_SEGMENTTYPE_DUNGEON_TRASH = 5
	--[[global]] DETAILS_SEGMENTTYPE_DUNGEON_BOSS = 6
	
	--[[global]] DETAILS_SEGMENTTYPE_RAID_TRASH = 7
	--[[global]] DETAILS_SEGMENTTYPE_RAID_BOSS = 8
	
	--[[global]] DETAILS_SEGMENTTYPE_MYTHICDUNGEON_GENERIC = 10
	--[[global]] DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASH = 11
	--[[global]] DETAILS_SEGMENTTYPE_MYTHICDUNGEON_OVERALL = 12
	--[[global]] DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASHOVERALL = 13
	--[[global]] DETAILS_SEGMENTTYPE_MYTHICDUNGEON_BOSS = 14
	
	--[[global]] DETAILS_SEGMENTTYPE_PVP_ARENA = 20
	--[[global]] DETAILS_SEGMENTTYPE_PVP_BATTLEGROUND = 21

	function combate:GetCombatType()
		--> mythic dungeon
		local isMythicDungeon = is_mythic_dungeon_segment
		if (isMythicDungeon) then
			local isMythicDungeonTrash = self.is_mythic_dungeon_trash
			if (isMythicDungeonTrash) then
				return DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASH
			else
				local isMythicDungeonOverall = self.is_mythic_dungeon and self.is_mythic_dungeon.OverallSegment
				local isMythicDungeonTrashOverall = self.is_mythic_dungeon and self.is_mythic_dungeon.TrashOverallSegment
				if (isMythicDungeonOverall) then
					return DETAILS_SEGMENTTYPE_MYTHICDUNGEON_OVERALL
				elseif (isMythicDungeonTrashOverall) then
					return DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASHOVERALL
				end
				
				local bossEncounter =  self.is_boss
				if (bossEncounter) then
					return DETAILS_SEGMENTTYPE_MYTHICDUNGEON_BOSS
				end
				
				return DETAILS_SEGMENTTYPE_MYTHICDUNGEON_GENERIC
			end
		end
		
		--> arena
		local arenaInfo = self.is_arena
		if (arenaInfo) then
			return DETAILS_SEGMENTTYPE_PVP_ARENA
		end
		
		--> battleground
		local battlegroundInfo = self.is_pvp
		if (battlegroundInfo) then
			return DETAILS_SEGMENTTYPE_PVP_BATTLEGROUND
		end
		
		--> dungeon or raid
		local instanceType = self.instance_type
		
		if (instanceType == "party") then
			local bossEncounter =  self.is_boss
			if (bossEncounter) then
				return DETAILS_SEGMENTTYPE_DUNGEON_BOSS
			else
				return DETAILS_SEGMENTTYPE_DUNGEON_TRASH
			end
			
		elseif (instanceType == "raid") then
			local bossEncounter =  self.is_boss
			if (bossEncounter) then
				return DETAILS_SEGMENTTYPE_RAID_BOSS
			else
				return DETAILS_SEGMENTTYPE_RAID_TRASH
			end
		end
		
		--> overall data
		if (self == _detalhes.tabela_overall) then
			return DETAILS_SEGMENTTYPE_OVERALL
		end
		
		return DETAILS_SEGMENTTYPE_GENERIC
	end

	--return a numeric table with all actors on the specific containter
	function combate:GetActorList (container)
		return self [container]._ActorTable
	end

	function combate:GetActor (container, name)
		local index = self [container] and self [container]._NameIndexTable [name]
		if (index) then
			return self [container]._ActorTable [index]
		end
		return nil
	end
	
	--return the combat time in seconds
	function combate:GetFormatedCombatTime()
		local time = self:GetCombatTime()
		local m, s = _math_floor (time/60), _math_floor (time%60)
		return m, s
	end
	
	function combate:GetCombatTime()
		if (self.end_time) then
			return _math_max (self.end_time - self.start_time, 0.1)
		elseif (self.start_time and _detalhes.in_combat and self ~= _detalhes.tabela_overall) then
			return _math_max (_GetTime() - self.start_time, 0.1)
		else
			return 0.1
		end
	end
	
	function combate:GetStartTime()
		return self.start_time
	end
	function combate:SetStartTime (t)
		self.start_time = t
	end
	
	function combate:GetEndTime()
		return self.end_time
	end
	function combate:SetEndTime (t)
		self.end_time = t
	end

	--return the total of a specific attribute
	local power_table = {0, 1, 3, 6, 0, "alternatepower"}
	
	function combate:GetTotal (attribute, subAttribute, onlyGroup)
		if (attribute == 1 or attribute == 2) then
			if (onlyGroup) then
				return self.totals_grupo [attribute]
			else
				return self.totals [attribute]
			end
			
		elseif (attribute == 3) then
			if (subAttribute == 5) then --> resources
				return self.totals.resources or 0
			end
			if (onlyGroup) then
				return self.totals_grupo [attribute] [power_table [subAttribute]]
			else
				return self.totals [attribute] [power_table [subAttribute]]
			end
			
		elseif (attribute == 4) then
			local subName = _detalhes:GetInternalSubAttributeName (attribute, subAttribute)
			if (onlyGroup) then
				return self.totals_grupo [attribute] [subName]
			else
				return self.totals [attribute] [subName]
			end
		end
		
		return 0
	end
	
	function combate:CreateAlternatePowerTable (actorName)
		local t = {last = 0, total = 0}
		self.alternate_power [actorName] = t
		return t
	end

	local tremove = _G.tremove

	--delete an actor from the combat ~delete ~erase ~remove
	function combate:DeleteActor(attribute, actorName, removeDamageTaken)
		local container = self[attribute]
		if (container) then

			local actorTable = container._ActorTable

			--store the index it was found
			local indexToDelete

			--get the object for the deleted actor
			local deletedActor = self(attribute, actorName)
			if (not deletedActor) then
				return
			else
				for i = 1, #actorTable do
					local actor = actorTable[i]
					if (actor.nome == actorName) then
						--print ("Details: found the actor: ", actorName, actor.nome, i)
						indexToDelete = i
						break
					end
				end
			end

			for i = 1, #actorTable do
				--is this not the actor we want to remove?
				if (i ~= indexToDelete) then

					local actor = actorTable[i]
					if (not actor.isTank) then
						--get the damage dealt and remove
						local damageDoneToRemovedActor = (actor.targets[actorName]) or 0
						actor.targets[actorName] = nil
						actor.total = actor.total - damageDoneToRemovedActor
						actor.total_without_pet = actor.total_without_pet - damageDoneToRemovedActor

						--damage taken
						if (removeDamageTaken) then
							local hadDamageTaken = actor.damage_from[actorName]
							if (hadDamageTaken) then
								--query the deleted actor to know how much damage it applied to this actor
								local damageDoneToActor = (deletedActor.targets[actor.nome]) or 0
								actor.damage_taken = actor.damage_taken - damageDoneToActor
							end
						end

						--spells
						local spellsTable = actor.spells._ActorTable
						for spellId, spellTable in pairs(spellsTable) do
							local damageDoneToRemovedActor = (spellTable.targets[actorName]) or 0
							spellTable.targets[actorName] = nil
							spellTable.total = spellTable.total - damageDoneToRemovedActor
						end
					end
				end
			end

			if (indexToDelete) then
				local actorToDelete = self(attribute, actorName)
				local actorToDelete2 = container._ActorTable[indexToDelete]
				
				if (actorToDelete ~= actorToDelete2) then
					Details:Msg("error 0xDE8745")
				end

				local index = container._NameIndexTable[actorName]
				if (indexToDelete ~= index) then
					Details:Msg("error 0xDE8751")
				end

				--remove actor
				tremove(container._ActorTable, index)

				--remap
				container:Remap()
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function combate:CreateNewCombatTable()
		return combate:NovaTabela()
	end

	--class constructor
	function combate:NovaTabela (iniciada, _tabela_overall, combatId, ...)

		local esta_tabela = {true, true, true, true, true}
		
		esta_tabela [1] = container_combatentes:NovoContainer (_detalhes.container_type.CONTAINER_DAMAGE_CLASS, esta_tabela, combatId) --> Damage
		esta_tabela [2] = container_combatentes:NovoContainer (_detalhes.container_type.CONTAINER_HEAL_CLASS, esta_tabela, combatId) --> Healing
		esta_tabela [3] = container_combatentes:NovoContainer (_detalhes.container_type.CONTAINER_ENERGY_CLASS, esta_tabela, combatId) --> Energies
		esta_tabela [4] = container_combatentes:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS, esta_tabela, combatId) --> Misc
		esta_tabela [5] = container_combatentes:NovoContainer (_detalhes.container_type.CONTAINER_DAMAGE_CLASS, esta_tabela, combatId) --> place holder for customs
		
		_setmetatable (esta_tabela, combate)
		
		_detalhes.combat_counter = _detalhes.combat_counter + 1
		esta_tabela.combat_counter = _detalhes.combat_counter
		
		--> try discover if is a pvp combat
		local who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags = ...
		if (who_serial) then --> aqui ir� identificar o boss ou o oponente
			if (alvo_name and _bit_band (alvo_flags, REACTION_HOSTILE) ~= 0) then --> tentando pegar o inimigo pelo alvo
				esta_tabela.contra = alvo_name
				if (_bit_band (alvo_flags, CONTROL_PLAYER) ~= 0) then
					esta_tabela.pvp = true --> o alvo � da fac��o oposta ou foi dado mind control
				end
			elseif (who_name and _bit_band (who_flags, REACTION_HOSTILE) ~= 0) then --> tentando pegar o inimigo pelo who caso o mob � quem deu o primeiro hit
				esta_tabela.contra = who_name
				if (_bit_band (who_flags, CONTROL_PLAYER) ~= 0) then
					esta_tabela.pvp = true --> o who � da fac��o oposta ou foi dado mind control
				end
			else
				esta_tabela.pvp = true --> se ambos s�o friendly, seria isso um PVP entre jogadores da mesma fac��o?
			end
		end

		--> start/end time (duration)
		esta_tabela.data_fim = 0
		esta_tabela.data_inicio = 0
		esta_tabela.tempo_start = _tempo
		
		--> record deaths
		esta_tabela.last_events_tables = {}
		
		--> last events from players
		esta_tabela.player_last_events = {}
		
		--> players in the raid
		esta_tabela.raid_roster = {}
		esta_tabela.raid_roster_indexed = {}
		
		--> frags
		esta_tabela.frags = {}
		esta_tabela.frags_need_refresh = false
		
		--> alternate power
		esta_tabela.alternate_power = {}
		
		--> time data container
		esta_tabela.TimeData = _detalhes:TimeDataCreateCombatTables()
		esta_tabela.PhaseData = {{1, 1}, damage = {}, heal = {}, damage_section = {}, heal_section = {}} --[1] phase number [2] phase started
		
		--> for external plugin usage, these tables are guaranteed to be saved with the combat
		esta_tabela.spells_cast_timeline = {}
		esta_tabela.aura_timeline = {}
		esta_tabela.cleu_timeline = {}
		
		--> cleu events
		esta_tabela.cleu_events = {
			n = 1 --event counter
		}
		
		--> Skill cache (not used)
		esta_tabela.CombatSkillCache = {}

		-- a tabela sem o tempo de inicio � a tabela descartavel do inicio do addon
		if (iniciada) then
			--esta_tabela.start_time = _tempo
			esta_tabela.start_time = _GetTime()
			esta_tabela.end_time = nil
		else
			esta_tabela.start_time = 0
			esta_tabela.end_time = nil
		end

		-- o container ir� armazenar as classes de dano -- cria um novo container de indexes de seriais de jogadores --par�metro 1 classe armazenada no container, par�metro 2 = flag da classe
		esta_tabela[1].need_refresh = true
		esta_tabela[2].need_refresh = true
		esta_tabela[3].need_refresh = true
		esta_tabela[4].need_refresh = true
		esta_tabela[5].need_refresh = true
		
		if (_tabela_overall) then --> link � a tabela de combate do overall
			esta_tabela[1].shadow = _tabela_overall[1]
			esta_tabela[2].shadow = _tabela_overall[2]
			esta_tabela[3].shadow = _tabela_overall[3]
			esta_tabela[4].shadow = _tabela_overall[4]
		end

		esta_tabela.totals = {
			0, --> dano
			0, --> cura
			{--> e_energy
				[0] = 0, --> mana
				[1] = 0, --> rage
				[3] = 0, --> energy (rogues cat)
				[6] = 0, --> runepower (dk)
				alternatepower = 0,
			},
			{--> misc
				cc_break = 0, --> armazena quantas quebras de CC
				ress = 0, --> armazena quantos pessoas ele reviveu
				interrupt = 0, --> armazena quantos interrupt a pessoa deu
				dispell = 0, --> armazena quantos dispell esta pessoa recebeu
				dead = 0, --> armazena quantas vezes essa pessia morreu
				cooldowns_defensive = 0, --> armazena quantos cooldowns a raid usou
				buff_uptime = 0, --> armazena quantos cooldowns a raid usou
				debuff_uptime = 0 --> armazena quantos cooldowns a raid usou
			},
			
			--> avoid using this values bellow, they aren't updated by the parser, only on demand by a user interaction.
				voidzone_damage = 0,
				frags_total = 0,
			--> end
		}
		
		esta_tabela.totals_grupo = {
			0, --> dano
			0, --> cura
			{--> e_energy
				[0] = 0, --> mana
				[1] = 0, --> rage
				[3] = 0, --> energy (rogues cat)
				[6] = 0, --> runepower (dk)
				alternatepower = 0,
			}, 
			{--> misc
				cc_break = 0, --> armazena quantas quebras de CC
				ress = 0, --> armazena quantos pessoas ele reviveu
				interrupt = 0, --> armazena quantos interrupt a pessoa deu
				dispell = 0, --> armazena quantos dispell esta pessoa recebeu
				dead = 0, --> armazena quantas vezes essa oessia morreu		
				cooldowns_defensive = 0, --> armazena quantos cooldowns a raid usou
				buff_uptime = 0,
				debuff_uptime = 0
			}
		}

		return esta_tabela
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function combate:CreateLastEventsTable (player_name)
		local t = {}
		for i = 1, _detalhes.deadlog_events do
			t [i] = {}
		end
		t.n = 1
		self.player_last_events [player_name] = t
		return t
	end

	--trava o tempo dos jogadores ap�s o t�rmino do combate.
	function combate:TravarTempos()
		if (self [1]) then
			for _, jogador in _ipairs (self [1]._ActorTable) do --> damage
				if (jogador:Iniciar()) then -- retorna se ele esta com o dps ativo
					jogador:TerminarTempo()
					jogador:Iniciar (false) --trava o dps do jogador
				else
					if (jogador.start_time == 0) then
						jogador.start_time = _tempo
					end
					if (not jogador.end_time) then
						jogador.end_time = _tempo
					end
				end
			end
		end
		if (self [2]) then
			for _, jogador in _ipairs (self [2]._ActorTable) do --> healing
				if (jogador:Iniciar()) then -- retorna se ele esta com o dps ativo
					jogador:TerminarTempo()
					jogador:Iniciar (false) --trava o dps do jogador
				else
					if (jogador.start_time == 0) then
						jogador.start_time = _tempo
					end
					if (not jogador.end_time) then
						jogador.end_time = _tempo
					end
				end
			end
		end
	end

	function combate:seta_data (tipo)
		if (tipo == _detalhes._detalhes_props.DATA_TYPE_START) then
			self.data_inicio = _date ("%H:%M:%S")
		elseif (tipo == _detalhes._detalhes_props.DATA_TYPE_END) then
			self.data_fim = _date ("%H:%M:%S")
		end
	end

	function combate:seta_tempo_decorrido()
		--self.end_time = _tempo
		self.end_time = _GetTime()
	end

	function _detalhes.refresh:r_combate (tabela_combate, shadow)
		_setmetatable (tabela_combate, _detalhes.combate)
		tabela_combate.__index = _detalhes.combate
		tabela_combate.shadow = shadow
	end

	function _detalhes.clear:c_combate (tabela_combate)
		--tabela_combate.__index = {}
		tabela_combate.__index = nil
		tabela_combate.__call = {}
		tabela_combate._combat_table = nil
		tabela_combate.shadow = nil
	end

	combate.__sub = function (combate1, combate2)

		if (combate1 ~= _detalhes.tabela_overall) then
			return
		end

		--> sub dano
			for index, actor_T2 in _ipairs (combate2[1]._ActorTable) do
				local actor_T1 = combate1[1]:PegarCombatente (actor_T2.serial, actor_T2.nome, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total (combate1)
			end
			combate1 [1].need_refresh = true
			
		--> sub heal
			for index, actor_T2 in _ipairs (combate2[2]._ActorTable) do
				local actor_T1 = combate1[2]:PegarCombatente (actor_T2.serial, actor_T2.nome, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total (combate1)
			end
			combate1 [2].need_refresh = true
			
		--> sub energy
			for index, actor_T2 in _ipairs (combate2[3]._ActorTable) do
				local actor_T1 = combate1[3]:PegarCombatente (actor_T2.serial, actor_T2.nome, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total (combate1)
			end
			combate1 [3].need_refresh = true
			
		--> sub misc
			for index, actor_T2 in _ipairs (combate2[4]._ActorTable) do
				local actor_T1 = combate1[4]:PegarCombatente (actor_T2.serial, actor_T2.nome, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total (combate1)
			end
			combate1 [4].need_refresh = true

		--> reduz o tempo 
			combate1.start_time = combate1.start_time + combate2:GetCombatTime()
			
		--> apaga as mortes da luta diminuida
			local amt_mortes =  #combate2.last_events_tables --> quantas mortes teve nessa luta
			if (amt_mortes > 0) then
				for i = #combate1.last_events_tables, #combate1.last_events_tables-amt_mortes, -1 do 
					_table_remove (combate1.last_events_tables, #combate1.last_events_tables)
				end
			end
			
		--> frags
			for fragName, fragAmount in pairs (combate2.frags) do 
				if (fragAmount) then
					if (combate1.frags [fragName]) then
						combate1.frags [fragName] = combate1.frags [fragName] - fragAmount
					else
						combate1.frags [fragName] = fragAmount
					end
				end
			end
			combate1.frags_need_refresh = true
		
		--> alternate power
			local overallPowerTable = combate1.alternate_power
			for actorName, powerTable in pairs (combate2.alternate_power) do 
				local power = overallPowerTable [actorName]
				if (power) then
					power.total = power.total - powerTable.total
				end
				combate2.alternate_power [actorName].last = 0
			end
		
		return combate1
		
	end

	combate.__add = function (combate1, combate2)

		local all_containers = {combate2 [class_type_dano]._ActorTable, combate2 [class_type_cura]._ActorTable, combate2 [class_type_e_energy]._ActorTable, combate2 [class_type_misc]._ActorTable}
		local custom_combat
		if (combate1 ~= _detalhes.tabela_overall) then
			custom_combat = combate1
		end
		
		for class_type, actor_container in ipairs (all_containers) do
			for _, actor in ipairs (actor_container) do
				local shadow
				
				if (class_type == class_type_dano) then
					shadow = _detalhes.atributo_damage:r_connect_shadow (actor, true, custom_combat)
				elseif (class_type == class_type_cura) then
					shadow = _detalhes.atributo_heal:r_connect_shadow (actor, true, custom_combat)
				elseif (class_type == class_type_e_energy) then
					shadow = _detalhes.atributo_energy:r_connect_shadow (actor, true, custom_combat)
				elseif (class_type == class_type_misc) then
					shadow = _detalhes.atributo_misc:r_connect_shadow (actor, true, custom_combat)
				end
				
				shadow.boss_fight_component = actor.boss_fight_component or shadow.boss_fight_component
				shadow.fight_component = actor.fight_component or shadow.fight_component
				shadow.grupo = actor.grupo or shadow.grupo
			end
		end
		
		--> alternate power
			local overallPowerTable = combate1.alternate_power
			for actorName, powerTable in pairs (combate2.alternate_power) do 
				local power = overallPowerTable [actorName]
				if (not power) then
					power = combate1:CreateAlternatePowerTable (actorName)
				end
				power.total = power.total + powerTable.total
				combate2.alternate_power [actorName].last = 0
			end

		return combate1
	end

	function _detalhes:UpdateCombat()
		_tempo = _detalhes._tempo
	end

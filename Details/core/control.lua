	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	local _tempo = time()
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	
	local _math_floor = math.floor --lua local
	local _math_max = math.max --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _table_wipe = table.wipe --lua local
	local _bit_band = bit.band --lua local
	
	local _GetInstanceInfo = GetInstanceInfo --wow api local
	local _UnitExists = UnitExists --wow api local
	local _UnitGUID = UnitGUID --wow api local
	local _UnitName = UnitName --wow api local
	local _GetTime = GetTime
	
	local _IsAltKeyDown = IsAltKeyDown
	local _IsShiftKeyDown = IsShiftKeyDown
	local _IsControlKeyDown = IsControlKeyDown
	
	local atributo_damage = _detalhes.atributo_damage --details local
	local atributo_heal = _detalhes.atributo_heal --details local
	local atributo_energy = _detalhes.atributo_energy --details local
	local atributo_misc = _detalhes.atributo_misc --details local
	local atributo_custom = _detalhes.atributo_custom --details local
	local info = _detalhes.janela_info --details local
	
	local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local modo_GROUP = _detalhes.modos.group
	local modo_ALL = _detalhes.modos.all
	local class_type_dano = _detalhes.atributos.dano
	local OBJECT_TYPE_PETS = 0x00003000
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> try to find the opponent of last fight, can be called during a fight as well
		function _detalhes:FindEnemy()
			
			local ZoneName, InstanceType, DifficultyID, _, _, _, _, ZoneMapID = _GetInstanceInfo()
			local in_instance = IsInInstance() --> garrison returns party as instance type.
			
			if ((InstanceType == "party" or InstanceType == "raid") and in_instance) then
				if (InstanceType == "party") then
					if (_detalhes:GetBossNames (_detalhes.zone_id)) then
						return Loc ["STRING_SEGMENT_TRASH"]
					end
				else
					return Loc ["STRING_SEGMENT_TRASH"]
				end
			end
			
			for _, actor in _ipairs (_detalhes.tabela_vigente[class_type_dano]._ActorTable) do 
			
				if (not actor.grupo and not actor.owner and not actor.nome:find ("[*]") and _bit_band (actor.flag_original, 0x00000060) ~= 0) then --> 0x20+0x40 neutral + enemy reaction
					for name, _ in _pairs (actor.targets) do
						if (name == _detalhes.playername) then
							return actor.nome
						else
							local _target_actor = _detalhes.tabela_vigente (class_type_dano, name)
							if (_target_actor and _target_actor.grupo) then 
								return actor.nome
							end
						end
					end
				end
				
			end
			
			for _, actor in _ipairs (_detalhes.tabela_vigente[class_type_dano]._ActorTable) do 
			
				if (actor.grupo and not actor.owner) then
					for target_name, _ in _pairs (actor.targets) do 
						return target_name
					end
				end
				
			end
			
			return Loc ["STRING_UNKNOW"]
		end
	
	-- try get the current encounter name during the encounter
	
		local boss_found_not_registered = function (t, ZoneName, ZoneMapID, DifficultyID)
			
			local boss_table = {
				index = 0,
				name = t[1],
				encounter = t[1],
				zone = ZoneName,
				mapid = ZoneMapID,
				diff = DifficultyID,
				diff_string = select (4, GetInstanceInfo()),
				ej_instance_id = t[5],
				id = t[2],
				bossimage = t[4],
			}
			
			_detalhes.tabela_vigente.is_boss = boss_table
		end
	
		local boss_found = function (index, name, zone, mapid, diff, encounterid)
		
			local mapID = C_Map.GetBestMapForUnit ("player")
			local ejid
			if (mapID) then
				ejid = DetailsFramework.EncounterJournal.EJ_GetInstanceForMap (mapID)
			end
			
			if (not mapID) then
				--print ("Details! exeption handled: zone has no map")
				return
			end
		
			if (ejid == 0) then
				ejid = _detalhes:GetInstanceEJID()
			end
		
			local boss_table = {
				index = index,
				name = name,
				encounter = name,
				zone = zone,
				mapid = mapid,
				diff = diff,
				diff_string = select (4, GetInstanceInfo()),
				ej_instance_id = ejid,
				id = encounterid,
			}
			
			if (not _detalhes:IsRaidRegistered (mapid) and _detalhes.zone_type == "raid") then
				local boss_list = _detalhes:GetCurrentDungeonBossListFromEJ()
				if (boss_list) then
					local ActorsContainer = _detalhes.tabela_vigente [class_type_dano]._ActorTable
					if (ActorsContainer) then
						for index, Actor in _ipairs (ActorsContainer) do 
							if (not Actor.grupo) then
								if (boss_list [Actor.nome]) then
									Actor.boss = true
									boss_table.bossimage = boss_list [Actor.nome][4]
									break
								end
							end
						end
					end
				end
			end

			_detalhes.tabela_vigente.is_boss = boss_table
			
			if (_detalhes.in_combat and not _detalhes.leaving_combat) then
			
				--> catch boss function if any
				local bossFunction, bossFunctionType = _detalhes:GetBossFunction (ZoneMapID, BossIndex)
				if (bossFunction) then
					if (_bit_band (bossFunctionType, 0x1) ~= 0) then --realtime
						_detalhes.bossFunction = bossFunction
						_detalhes.tabela_vigente.bossFunction = _detalhes:ScheduleTimer ("bossFunction", 1)
					end
				end
				
				if (_detalhes.zone_type ~= "raid") then
					local endType, endData = _detalhes:GetEncounterEnd (ZoneMapID, BossIndex)
					if (endType and endData) then
					
						if (_detalhes.debug) then
							_detalhes:Msg ("(debug) setting boss end type to:", endType)
						end
					
						_detalhes.encounter_end_table.type = endType
						_detalhes.encounter_end_table.killed = {}
						_detalhes.encounter_end_table.data = {}
						
						if (type (endData) == "table") then
							if (_detalhes.debug) then
								_detalhes:Msg ("(debug) boss type is table:", endType)
							end
							if (endType == 1 or endType == 2) then
								for _, npcID in ipairs (endData) do 
									_detalhes.encounter_end_table.data [npcID] = false
								end
							end
						else
							if (endType == 1 or endType == 2) then
								_detalhes.encounter_end_table.data [endData] = false
							end
						end
					end
				end
			end
			
			--> we the boss was found during the combat table creation, we must postpone the event trigger
			if (not _detalhes.tabela_vigente.IsBeingCreated) then
				_detalhes:SendEvent ("COMBAT_BOSS_FOUND", nil, index, name)
				_detalhes:CheckFor_SuppressedWindowsOnEncounterFound()
			end
			
			return boss_table
		end
	
		function _detalhes:ReadBossFrames()
		
			if (_detalhes.tabela_vigente.is_boss) then
				return --no need to check
			end
		
			if (_detalhes.encounter_table.name) then
				local encounter_table = _detalhes.encounter_table
				return boss_found (encounter_table.index, encounter_table.name, encounter_table.zone, encounter_table.mapid, encounter_table.diff, encounter_table.id)
			end
		
			for index = 1, 5, 1 do 
				if (_UnitExists ("boss"..index)) then 
					local guid = _UnitGUID ("boss"..index)
					if (guid) then
						local serial = _detalhes:GetNpcIdFromGuid (guid)

						if (serial) then
						
							local ZoneName, _, DifficultyID, _, _, _, _, ZoneMapID = _GetInstanceInfo()
						
							local BossIds = _detalhes:GetBossIds (ZoneMapID)
							if (BossIds) then
								local BossIndex = BossIds [serial]

								if (BossIndex) then 
									if (_detalhes.debug) then
										_detalhes:Msg ("(debug) boss found:",_detalhes:GetBossName (ZoneMapID, BossIndex))
									end
									
									return boss_found (BossIndex, _detalhes:GetBossName (ZoneMapID, BossIndex), ZoneName, ZoneMapID, DifficultyID)
								end
							end
						end
					end
				end
			end
		end	
	
	--try to get the encounter name after the encounter (can be called during the combat as well)
		function _detalhes:FindBoss (noJournalSearch)

			if (_detalhes.encounter_table.name) then
				local encounter_table = _detalhes.encounter_table
				return boss_found (encounter_table.index, encounter_table.name, encounter_table.zone, encounter_table.mapid, encounter_table.diff, encounter_table.id)
			end
		
			local ZoneName, InstanceType, DifficultyID, _, _, _, _, ZoneMapID = _GetInstanceInfo()
			local BossIds = _detalhes:GetBossIds (ZoneMapID)
			
			if (BossIds) then
				local BossIndex = nil
				local ActorsContainer = _detalhes.tabela_vigente [class_type_dano]._ActorTable
				
				if (ActorsContainer) then
					for index, Actor in _ipairs (ActorsContainer) do 
						if (not Actor.grupo) then
							local serial = _detalhes:GetNpcIdFromGuid (Actor.serial)
							if (serial) then
								BossIndex = BossIds [serial]
								if (BossIndex) then
									Actor.boss = true
									return boss_found (BossIndex, _detalhes:GetBossName (ZoneMapID, BossIndex), ZoneName, ZoneMapID, DifficultyID)
								end
							end
						end
					end
				end
			end
			
			noJournalSearch = true --> disabling the scan on encounter journal
			
			if (not noJournalSearch) then
				local in_instance = IsInInstance() --> garrison returns party as instance type.
				if ((InstanceType == "party" or InstanceType == "raid") and in_instance) then
					local boss_list = _detalhes:GetCurrentDungeonBossListFromEJ()
					if (boss_list) then
						local ActorsContainer = _detalhes.tabela_vigente [class_type_dano]._ActorTable
						if (ActorsContainer) then
							for index, Actor in _ipairs (ActorsContainer) do 
								if (not Actor.grupo) then
									if (boss_list [Actor.nome]) then
										Actor.boss = true
										return boss_found_not_registered (boss_list [Actor.nome], ZoneName, ZoneMapID, DifficultyID)
									end
								end
							end
						end
					end
				end
			end
			return false
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
-- _detalhes.statistics = {container_calls = 0, container_pet_calls = 0, container_unknow_pet = 0, damage_calls = 0, heal_calls = 0, absorbs_calls = 0, energy_calls = 0, pets_summons = 0}
		function _detalhes:StartCombat(...)
			return _detalhes:EntrarEmCombate (...)
		end

		-- ~start ~inicio ~novo �ovo
		function _detalhes:EntrarEmCombate (...)
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) |cFFFFFF00started a new combat|r|cFFFF7700", _detalhes.encounter_table and _detalhes.encounter_table.name or "")
				--local from = debugstack (2, 1, 0)
				--print (from)
			end

			if (not _detalhes.tabela_historico.tabelas[1]) then 
				_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
				
				_detalhes:InstanciaCallFunction (_detalhes.ResetaGump, nil, -1) --> reseta scrollbar, iterators, rodap�, etc
				_detalhes:InstanciaCallFunction (_detalhes.InstanciaFadeBarras, -1) --> esconde todas as barras
				_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos) --> atualiza o showing
			end
			
			--> re-lock nos tempos da tabela passada -- lock again last table times
			_detalhes.tabela_vigente:TravarTempos()
			
			local n_combate = _detalhes:NumeroCombate (1) --aumenta o contador de combates -- combat number up
			
			--> cria a nova tabela de combates -- create new table
			local ultimo_combate = _detalhes.tabela_vigente
			_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (true, _detalhes.tabela_overall, n_combate, ...) --cria uma nova tabela de combate
			
			--> flag this combat as being created
			_detalhes.tabela_vigente.IsBeingCreated = true
			
			_detalhes.tabela_vigente.previous_combat = ultimo_combate
			
			_detalhes.tabela_vigente:seta_data (_detalhes._detalhes_props.DATA_TYPE_START) --seta na tabela do combate a data do inicio do combate -- setup time data
			_detalhes.in_combat = true --sinaliza ao addon que h� um combate em andamento -- in combat flag up
			_detalhes.tabela_vigente.combat_id = n_combate --> grava o n�mero deste combate na tabela atual -- setup combat id on new table
			_detalhes.last_combat_pre_pot_used = nil
			
			_detalhes:FlagCurrentCombat()
			
			--> � o timer que ve se o jogador ta em combate ou n�o -- check if any party or raid members are in combat
			_detalhes.tabela_vigente.verifica_combate = _detalhes:ScheduleRepeatingTimer ("EstaEmCombate", 1) 
			
			_detalhes:ClearCCPetsBlackList()
			
			_table_wipe (_detalhes.encounter_end_table)
			
			_table_wipe (_detalhes.pets_ignored)
			_table_wipe (_detalhes.pets_no_owner)
			_detalhes.container_pets:BuscarPets()
			
			_table_wipe (_detalhes.cache_damage_group)
			_table_wipe (_detalhes.cache_healing_group)
			_detalhes:UpdateParserGears()
			
			--> get all buff already applied before the combat start
			_detalhes:CatchRaidBuffUptime ("BUFF_UPTIME_IN")
			_detalhes:CatchRaidDebuffUptime ("DEBUFF_UPTIME_IN")
			_detalhes:UptadeRaidMembersCache()
			
			--> we already have boss information? build .is_boss table
			if (_detalhes.encounter_table.id and _detalhes.encounter_table ["start"] >= GetTime() - 3 and not _detalhes.encounter_table ["end"]) then
				local encounter_table = _detalhes.encounter_table
				--> boss_found will trigger "COMBAT_BOSS_FOUND" event, but at this point of the combat creation is safe to send it
				boss_found (encounter_table.index, encounter_table.name, encounter_table.zone, encounter_table.mapid, encounter_table.diff, encounter_table.id)
			else
				--> if we don't have this infor right now, lets check in few seconds dop
				if (_detalhes.EncounterInformation [_detalhes.zone_id]) then 
					_detalhes:ScheduleTimer ("ReadBossFrames", 1)
					_detalhes:ScheduleTimer ("ReadBossFrames", 30)
				end
			end
			
			--> if the window is showing current segment, switch it for the new combat
			--> also if the window has auto current, jump to current segment
			_detalhes:InstanciaCallFunction (_detalhes.TrocaSegmentoAtual, _detalhes.tabela_vigente.is_boss and true)			
			
			--> clear hosts and make the cloud capture stuff
			_detalhes.host_of = nil
			_detalhes.host_by = nil			
			
			if (_detalhes.in_group and _detalhes.cloud_capture) then
				if (_detalhes:IsInInstance() or _detalhes.debug) then
					if (not _detalhes:CaptureIsAllEnabled()) then
						_detalhes:ScheduleSendCloudRequest()
						--if (_detalhes.debug) then
						--	_detalhes:Msg ("(debug) requesting a cloud server.")
						--end
					end
				else
					--if (_detalhes.debug) then
					--	_detalhes:Msg ("(debug) isn't inside a registred instance", _detalhes:IsInInstance())
					--end
				end
			else
				--if (_detalhes.debug) then
				--	_detalhes:Msg ("(debug) isn't in group or cloud is turned off", _detalhes.in_group, _detalhes.cloud_capture)
				--end
			end
		
			--> hide / alpha / switch in combat
			for index, instancia in ipairs (_detalhes.tabela_instancias) do 
				if (instancia.ativa) then
					--instancia:SetCombatAlpha (nil, nil, true) --passado para o regen disable
					instancia:CheckSwitchOnCombatStart (true)
				end
			end
			
			_detalhes:InstanceCall (_detalhes.CheckPsUpdate)
			
			--> combat creation is completed, remove the flag
			_detalhes.tabela_vigente.IsBeingCreated = nil
	
			_detalhes:SendEvent ("COMBAT_PLAYER_ENTER", nil, _detalhes.tabela_vigente, _detalhes.encounter_table and _detalhes.encounter_table.id)
			if (_detalhes.tabela_vigente.is_boss) then
				--> the encounter was found through encounter_start event
				_detalhes:SendEvent ("COMBAT_BOSS_FOUND", nil, _detalhes.tabela_vigente.is_boss.index, _detalhes.tabela_vigente.is_boss.name)
			end
			
			_detalhes:CheckSwitchToCurrent()
			_detalhes:CheckForTextTimeCounter (true)
			
			--> stop bar testing if any
			_detalhes:StopTestBarUpdate()
		end
		
		function _detalhes:DelayedSyncAlert()
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _detalhes:GetInstance (lower_instance)
				if (lower_instance) then
					if (not lower_instance:HaveInstanceAlert()) then
						lower_instance:InstanceAlert (Loc ["STRING_EQUILIZING"], {[[Interface\COMMON\StreamCircle]], 22, 22, true}, 5, {function() end})
					end
				end
			end
		end
		
		function _detalhes:ScheduleSyncPlayerActorData()
			if ((IsInGroup() or IsInRaid()) and (_detalhes.zone_type == "party" or _detalhes.zone_type == "raid")) then
				--> do not sync if in battleground or arena
				_detalhes:SendCharacterData()
			end
		end
		
		function _detalhes:EndCombat()
			if (_detalhes.in_combat) then
				_detalhes:SairDoCombate()
			end
		end
		
		-- ~end ~leave
		function _detalhes:SairDoCombate (bossKilled, from_encounter_end)
		
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) |cFFFFFF00ended a combat|r|cFFFF7700", _detalhes.encounter_table and _detalhes.encounter_table.name or "")
			end
			
			--> in case of something somehow someway call to close the same combat a second time.
			if (_detalhes.tabela_vigente == _detalhes.last_closed_combat) then
				return
			end
			_detalhes.last_closed_combat = _detalhes.tabela_vigente
			
			--if (_detalhes.statistics) then
			--	for k, v in pairs (_detalhes.statistics) do
			--		print (k, v)
			--	end
			--end
			
			_detalhes.leaving_combat = true
			_detalhes.last_combat_time = _tempo
			
			--deprecated (combat are now added immediatelly since there's no script run too long)
			--if (_detalhes.schedule_remove_overall and not from_encounter_end and not InCombatLockdown()) then
			--	if (_detalhes.debug) then
			--		_detalhes:Msg ("(debug) found schedule overall data deletion.")
			--	end
			--	_detalhes.schedule_remove_overall = false
			--	_detalhes.tabela_historico:resetar_overall()
			--end
			
			_detalhes:CatchRaidBuffUptime ("BUFF_UPTIME_OUT")
			_detalhes:CatchRaidDebuffUptime ("DEBUFF_UPTIME_OUT")
			_detalhes:CloseEnemyDebuffsUptime()
			
			--> check if this isn't a boss and try to find a boss in the segment
			if (not _detalhes.tabela_vigente.is_boss) then 
				
				--> if this is a mythic+ dungeon, do not scan for encounter journal boss names in the actor list
				_detalhes:FindBoss()
				
				--> still didn't find the boss
				if (not _detalhes.tabela_vigente.is_boss) then
					local ZoneName, _, DifficultyID, _, _, _, _, ZoneMapID = _GetInstanceInfo()
					local findboss = _detalhes:GetRaidBossFindFunction (ZoneMapID)
					if (findboss) then
						local BossIndex = findboss()
						if (BossIndex) then
							boss_found (BossIndex, _detalhes:GetBossName (ZoneMapID, BossIndex), ZoneName, ZoneMapID, DifficultyID)
						end
					end
				end
			end
			
			if (_detalhes.tabela_vigente.bossFunction) then
				_detalhes:CancelTimer (_detalhes.tabela_vigente.bossFunction)
				_detalhes.tabela_vigente.bossFunction = nil
			end

			--> finaliza a checagem se esta ou n�o no combate -- finish combat check
			if (_detalhes.tabela_vigente.verifica_combate) then 
				_detalhes:CancelTimer (_detalhes.tabela_vigente.verifica_combate)
				_detalhes.tabela_vigente.verifica_combate = nil
			end

			--> lock timers
			_detalhes.tabela_vigente:TravarTempos() 
			
			--> get waste shields
			if (_detalhes.close_shields) then
				_detalhes:CloseShields (_detalhes.tabela_vigente)
			end
			
			--> salva hora, minuto, segundo do fim da luta
			_detalhes.tabela_vigente:seta_data (_detalhes._detalhes_props.DATA_TYPE_END) 
			_detalhes.tabela_vigente:seta_tempo_decorrido()
			
			--> drop last events table to garbage collector
			_detalhes.tabela_vigente.player_last_events = {}
			
			--> flag instance type
			local _, InstanceType = _GetInstanceInfo()
			_detalhes.tabela_vigente.instance_type = InstanceType
			
			if (not _detalhes.tabela_vigente.is_boss and from_encounter_end and type (from_encounter_end) == "table") then
				local encounterID, encounterName, difficultyID, raidSize, endStatus = unpack (from_encounter_end)
				if (encounterID) then
					local ZoneName, InstanceType, DifficultyID, DifficultyName, _, _, _, ZoneMapID = GetInstanceInfo()
					
					local mapID = C_Map.GetBestMapForUnit ("player")
					
					if (not mapID) then
						mapID = 0
					end
					
					local ejid = DetailsFramework.EncounterJournal.EJ_GetInstanceForMap (mapID)
					
					if (ejid == 0) then
						ejid = _detalhes:GetInstanceEJID()
					end
					local _, boss_index = _detalhes:GetBossEncounterDetailsFromEncounterId (ZoneMapID, encounterID)

					_detalhes.tabela_vigente.is_boss = {
						index = boss_index or 0,
						name = encounterName,
						encounter = encounterName,
						zone = ZoneName,
						mapid = ZoneMapID,
						diff = DifficultyID,
						diff_string = DifficultyName,
						ej_instance_id = ejid or 0,
						id = encounterID,
					}
				end
			end		
			
			--> tag as a mythic dungeon segment, can be any type of segment, this tag also avoid the segment to be tagged as trash
			local mythicLevel = C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo()
			if (mythicLevel and mythicLevel >= 2) then
				_detalhes.tabela_vigente.is_mythic_dungeon_segment = true
				_detalhes.tabela_vigente.is_mythic_dungeon_run_id = _detalhes.mythic_dungeon_id
			end
			
			--> send item level after a combat if is in raid or party group
			C_Timer.After (1, _detalhes.ScheduleSyncPlayerActorData)
			
			--if this segment isn't a boss fight
			if (not _detalhes.tabela_vigente.is_boss) then

				if (_detalhes.tabela_vigente.is_pvp or _detalhes.tabela_vigente.is_arena) then
					_detalhes:FlagActorsOnPvPCombat()
				end
			
				if (_detalhes.tabela_vigente.is_arena) then
					_detalhes.tabela_vigente.enemy = "[" .. ARENA .. "] " ..  _detalhes.tabela_vigente.is_arena.name
				end

				local in_instance = IsInInstance() --> garrison returns party as instance type.
				if ((InstanceType == "party" or InstanceType == "raid") and in_instance) then
					if (InstanceType == "party") then
						if (_detalhes.tabela_vigente.is_mythic_dungeon_segment) then --setted just above
							--is inside a mythic+ dungeon and this is not a boss segment, so tag it as a dungeon mythic+ trash segment
							local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
							_detalhes.tabela_vigente.is_mythic_dungeon_trash = {
								ZoneName = zoneName,
								MapID = instanceMapID,
								Level = _detalhes.MythicPlus.Level,
								EJID = _detalhes.MythicPlus.ejID,
							}
						else
							--> tag the combat as trash clean up
							_detalhes.tabela_vigente.is_trash = true
						end
					else
						_detalhes.tabela_vigente.is_trash = true
					end
				else
					if (not in_instance) then
						if (_detalhes.world_combat_is_trash) then
							_detalhes.tabela_vigente.is_temporary = true
						end
					end
				end
				
				if (not _detalhes.tabela_vigente.enemy) then
					local enemy = _detalhes:FindEnemy()
					
					if (enemy and _detalhes.debug) then
						_detalhes:Msg ("(debug) enemy found", enemy)
					end
					
					_detalhes.tabela_vigente.enemy = enemy
				end
				
				if (_detalhes.debug) then
				--	_detalhes:Msg ("(debug) forcing equalize actors behavior.")
				--	_detalhes:EqualizeActorsSchedule (_detalhes.host_of)
				end
				
				--> verifica memoria
				_detalhes:FlagActorsOnCommonFight() --fight_component
				--_detalhes:CheckMemoryAfterCombat() -- 7.2.5 is doing some weird errors even out of combat
			else
				
				--this segment is a boss fight
				if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
					
				else
					--_detalhes.schedule_flag_boss_components = true
				end
				
				--calling here without checking for combat since the does not ran too long for scripts
				_detalhes:FlagActorsOnBossFight()
				
				local boss_id = _detalhes.encounter_table.id

				if (bossKilled) then
					_detalhes.tabela_vigente.is_boss.killed = true
					
					--> add to storage
					if (not InCombatLockdown() and not UnitAffectingCombat ("player") and not _detalhes.logoff_saving_data) then
						--_detalhes.StoreEncounter()
						local successful, errortext = pcall (_detalhes.StoreEncounter)
						if (not successful) then
							_detalhes:Msg ("error occurred on StoreEncounter():", errortext)
						end
					else
						_detalhes.schedule_store_boss_encounter = true
					end
					
					_detalhes:SendEvent ("COMBAT_BOSS_DEFEATED", nil, _detalhes.tabela_vigente)
					
					_detalhes:CheckFor_TrashSuppressionOnEncounterEnd()
				else
					_detalhes:SendEvent ("COMBAT_BOSS_WIPE", nil, _detalhes.tabela_vigente)
				end

				--if (_detalhes:GetBossDetails (_detalhes.tabela_vigente.is_boss.mapid, _detalhes.tabela_vigente.is_boss.index) or ) then
					
					_detalhes.tabela_vigente.is_boss.index = _detalhes.tabela_vigente.is_boss.index or 1
					
					_detalhes.tabela_vigente.enemy = _detalhes.tabela_vigente.is_boss.encounter

					if (_detalhes.tabela_vigente.instance_type == "raid") then
					
						_detalhes.last_encounter2 = _detalhes.last_encounter
						_detalhes.last_encounter = _detalhes.tabela_vigente.is_boss.name

						if (_detalhes.pre_pot_used) then
							_detalhes.last_combat_pre_pot_used = table_deepcopy (_detalhes.pre_pot_used)
						end
						
						if (_detalhes.pre_pot_used and _detalhes.announce_prepots.enabled) then
							_detalhes:Msg (_detalhes.pre_pot_used or "")
							_detalhes.pre_pot_used = nil
						end
					end

					if (from_encounter_end) then
						if (_detalhes.encounter_table.start) then
							_detalhes.tabela_vigente:SetStartTime (_detalhes.encounter_table.start)
						end
						_detalhes.tabela_vigente:SetEndTime (_detalhes.encounter_table ["end"] or GetTime())
					end

					--> encounter boss function
					local bossFunction, bossFunctionType = _detalhes:GetBossFunction (_detalhes.tabela_vigente.is_boss.mapid or 0, _detalhes.tabela_vigente.is_boss.index or 0)
					if (bossFunction) then
						if (_bit_band (bossFunctionType, 0x2) ~= 0) then --end of combat
							if (not _detalhes.logoff_saving_data) then
								local successful, errortext = pcall (bossFunction, _detalhes.tabela_vigente)
								if (not successful) then
									_detalhes:Msg ("error occurred on Encounter Boss Function:", errortext)
								end
							end
						end
					end
					
					if (_detalhes.tabela_vigente.instance_type == "raid") then
						--> schedule captures off
						
						_detalhes:CaptureSet (false, "damage", false, 15)
						_detalhes:CaptureSet (false, "energy", false, 15)
						_detalhes:CaptureSet (false, "aura", false, 15)
						_detalhes:CaptureSet (false, "energy", false, 15)
						_detalhes:CaptureSet (false, "spellcast", false, 15)
						
						if (_detalhes.debug) then
							_detalhes:Msg ("(debug) freezing parser for 15 seconds.")
						end
					end
					
					--> schedule sync
					_detalhes:EqualizeActorsSchedule (_detalhes.host_of)
					if (_detalhes:GetEncounterEqualize (_detalhes.tabela_vigente.is_boss.mapid, _detalhes.tabela_vigente.is_boss.index)) then
						_detalhes:ScheduleTimer ("DelayedSyncAlert", 3)
					end
					
				--else
				--	if (_detalhes.debug) then
				--		_detalhes:EqualizeActorsSchedule (_detalhes.host_of)
				--	end
				--end
			end

			if (_detalhes.solo) then
				--> debuffs need a checkup, not well functional right now
				_detalhes.CloseSoloDebuffs()
			end
			
			local tempo_do_combate = _detalhes.tabela_vigente:GetCombatTime()
			local invalid_combat
			
			local zoneName, zoneType = GetInstanceInfo()
			if (not _detalhes.tabela_vigente.discard_segment and (zoneType == "none" or tempo_do_combate >= _detalhes.minimum_combat_time or not _detalhes.tabela_historico.tabelas[1])) then
				_detalhes.tabela_historico:adicionar (_detalhes.tabela_vigente) --move a tabela atual para dentro do hist�rico
				--8.0.1 miss data isn't required at the moment, spells like akari's soul has been removed from the game
				--_detalhes:CanSendMissData()
				
				if (_detalhes.tabela_vigente.is_boss) then
					if (IsInRaid()) then
						local cleuID = _detalhes.tabela_vigente.is_boss.id
						local diff = _detalhes.tabela_vigente.is_boss.diff
						if (cleuID and diff == 16) then -- 16 mythic
							local raidData = _detalhes.raid_data
							
							--get or build mythic raid data table
							local mythicRaidData = raidData.mythic_raid_data
							if (not mythicRaidData) then
								mythicRaidData = {}
								raidData.mythic_raid_data = mythicRaidData
							end
							
							--get or build a table for this cleuID
							mythicRaidData [cleuID] = mythicRaidData [cleuID] or {wipes = 0, kills = 0, best_try = 1, longest = 0, try_history = {}}
							local cleuIDData = mythicRaidData [cleuID]
							
							--store encounter data for plugins and weakauras
							if (_detalhes.tabela_vigente:GetCombatTime() > cleuIDData.longest) then
								cleuIDData.longest = _detalhes.tabela_vigente:GetCombatTime()
							end
							
							if (_detalhes.tabela_vigente.is_boss.killed) then
								cleuIDData.kills = cleuIDData.kills + 1
								cleuIDData.best_try = 0
								tinsert (cleuIDData.try_history, {0, _detalhes.tabela_vigente:GetCombatTime()})
								--print ("KILL", "best try", cleuIDData.best_try, "amt kills", cleuIDData.kills, "wipes", cleuIDData.wipes, "longest", cleuIDData.longest)
							else
								cleuIDData.wipes = cleuIDData.wipes + 1
								if (_detalhes.boss1_health_percent and _detalhes.boss1_health_percent < cleuIDData.best_try) then
									cleuIDData.best_try = _detalhes.boss1_health_percent
									tinsert (cleuIDData.try_history, {_detalhes.boss1_health_percent, _detalhes.tabela_vigente:GetCombatTime()})
								end
								--print ("WIPE", "best try", cleuIDData.best_try, "amt kills", cleuIDData.kills, "wipes", cleuIDData.wipes, "longest", cleuIDData.longest)
							end
						end
					end
					--
				end
				
				--the combat is valid, see if the user is sharing data with somebody
				if (_detalhes.shareData) then
					local zipData = Details:CompressData (_detalhes.tabela_vigente, "comm")
					if (zipData) then
						print ("has zip data")
					end
				end
				
			else
				invalid_combat = _detalhes.tabela_vigente
				
				--> tutorial about the combat time < then 'minimum_combat_time'
				local hasSeenTutorial = _detalhes:GetTutorialCVar ("MIN_COMBAT_TIME")
				if (not hasSeenTutorial) then
					local lower_instance = _detalhes:GetLowerInstanceNumber()
					if (lower_instance) then
						lower_instance = _detalhes:GetInstance (lower_instance)
						if (lower_instance) then
							lower_instance:InstanceAlert ("combat ignored: less than 5 seconds.", {[[Interface\BUTTONS\UI-GROUPLOOT-PASS-DOWN]], 18, 18, false, 0, 1, 0, 1}, 20, {function() Details:Msg ("combat ignored: elapsed time less than 5 seconds."); Details:Msg ("add '|cFFFFFF00Details.minimum_combat_time = 2;|r' on Auto Run Code to change the minimum time.") end})
							_detalhes:SetTutorialCVar ("MIN_COMBAT_TIME", true)
						end
					end
				end
				
				--in case of a forced discard segment, just check a second time if we have a previous combat.
				if (not _detalhes.tabela_historico.tabelas[1]) then
					_detalhes.tabela_vigente = _detalhes.tabela_vigente
				else
					_detalhes.tabela_vigente = _detalhes.tabela_historico.tabelas[1] --> pega a tabela do ultimo combate
				end

				if (_detalhes.tabela_vigente:GetStartTime() == 0) then
					--_detalhes.tabela_vigente.start_time = _detalhes._tempo
					_detalhes.tabela_vigente:SetStartTime (_GetTime())
					--_detalhes.tabela_vigente.end_time = _detalhes._tempo
					_detalhes.tabela_vigente:SetEndTime (_GetTime())
				end
				
				_detalhes.tabela_vigente.resincked = true
				
				--> tabela foi descartada, precisa atualizar os baseframes // precisa atualizer todos ou apenas o overall?
				_detalhes:InstanciaCallFunction (_detalhes.AtualizarJanela)
				
				if (_detalhes.solo) then
					local esta_instancia = _detalhes.tabela_instancias[_detalhes.solo]
					if (_detalhes.SoloTables.CombatID == _detalhes:NumeroCombate()) then --> significa que o solo mode validou o combate, como matar um bixo muito low level com uma s� porrada
						if (_detalhes.SoloTables.CombatIDLast and _detalhes.SoloTables.CombatIDLast ~= 0) then --> volta os dados da luta anterior
						
							_detalhes.SoloTables.CombatID = _detalhes.SoloTables.CombatIDLast
						
						else
							if (_detalhes.RefreshSolo) then
								_detalhes:RefreshSolo()
							end
							_detalhes.SoloTables.CombatID = nil
						end
					end
				end
				
				_detalhes:NumeroCombate (-1)
			end
			
			_detalhes.host_of = nil
			_detalhes.host_by = nil
			
			if (_detalhes.cloud_process) then
				_detalhes:CancelTimer (_detalhes.cloud_process)
			end
			
			_detalhes.in_combat = false
			_detalhes.leaving_combat = false
			
			_detalhes:OnCombatPhaseChanged()
			_table_wipe (_detalhes.tabela_vigente.PhaseData.damage_section)
			_table_wipe (_detalhes.tabela_vigente.PhaseData.heal_section)
			
			_table_wipe (_detalhes.cache_damage_group)
			_table_wipe (_detalhes.cache_healing_group)
			
			_detalhes:UpdateParserGears()
			
			--> hide / alpha in combat
			for index, instancia in ipairs (_detalhes.tabela_instancias) do 
				if (instancia.ativa) then
					--instancia:SetCombatAlpha (nil, nil, true) --passado para o regen enabled
					if (instancia.auto_switch_to_old) then
						instancia:CheckSwitchOnCombatEnd()
					end
				end
			end
			
			_detalhes.pre_pot_used = nil
			
			--> do not wipe the encounter table if is in the argus encounter ~REMOVE on 8.0
			if (_detalhes.encounter_table and _detalhes.encounter_table.id ~= 2092) then
				_table_wipe (_detalhes.encounter_table)
			else
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) in argus encounter, cannot wipe the encounter table.")
				end
			end

			_detalhes:InstanceCall (_detalhes.CheckPsUpdate)
			
			if (invalid_combat) then
				_detalhes:SendEvent ("COMBAT_INVALID")
				_detalhes:SendEvent ("COMBAT_PLAYER_LEAVE", nil, invalid_combat)
			else
				_detalhes:SendEvent ("COMBAT_PLAYER_LEAVE", nil, _detalhes.tabela_vigente)
			end
			
			_detalhes:CheckForTextTimeCounter()
			_detalhes.StoreSpells()
			_detalhes:RunScheduledEventsAfterCombat()
		end

		function _detalhes:GetPlayersInArena()
			local aliados = GetNumGroupMembers() -- LE_PARTY_CATEGORY_HOME
			for i = 1, aliados-1 do
				local role = UnitGroupRolesAssigned ("party" .. i)
				if (role ~= "NONE") then
					local name = GetUnitName ("party" .. i, true)
					_detalhes.arena_table [name] = {role = role}
				end
			end
			
			local role = UnitGroupRolesAssigned ("player")
			if (role ~= "NONE") then
				local name = GetUnitName ("player", true)
				_detalhes.arena_table [name] = {role = role}
			end
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) Found", oponentes, "enemies and", aliados, "allies")
			end
		end
		
		local string_arena_enemyteam_damage = [[
			local combat = _detalhes:GetCombat ("current")
			local total = 0
			
			for _, actor in combat[1]:ListActors() do
				if (actor.arena_enemy) then
					total = total + actor.total
				end
			end
			
			return total
		]]
		
		local string_arena_myteam_damage = [[
			local combat = _detalhes:GetCombat ("current")
			local total = 0
			
			for _, actor in combat[1]:ListActors() do
				if (actor.arena_ally) then
					total = total + actor.total
				end
			end
			
			return total
		]]
		
		local string_arena_enemyteam_heal = [[
			local combat = _detalhes:GetCombat ("current")
			local total = 0
			
			for _, actor in combat[2]:ListActors() do
				if (actor.arena_enemy) then
					total = total + actor.total
				end
			end
			
			return total
		]]

		local string_arena_myteam_heal = [[
			local combat = _detalhes:GetCombat ("current")
			local total = 0
			
			for _, actor in combat[2]:ListActors() do
				if (actor.arena_ally) then
					total = total + actor.total
				end
			end
			
			return total
		]]
		
		function _detalhes:CreateArenaSegment()
		
			_detalhes:GetPlayersInArena()
		
			_detalhes.arena_begun = true
			_detalhes.start_arena = nil
		
			if (_detalhes.in_combat) then
				_detalhes:SairDoCombate()
			end
		
			--> registra os gr�ficos
			_detalhes:TimeDataRegister ("Your Team Damage", string_arena_myteam_damage, nil, "Details!", "v1.0", [[Interface\ICONS\Ability_DualWield]], true, true)
			_detalhes:TimeDataRegister ("Enemy Team Damage", string_arena_enemyteam_damage, nil, "Details!", "v1.0", [[Interface\ICONS\Ability_DualWield]], true, true)
		
			_detalhes:TimeDataRegister ("Your Team Healing", string_arena_myteam_heal, nil, "Details!", "v1.0", [[Interface\ICONS\Ability_DualWield]], true, true)
			_detalhes:TimeDataRegister ("Enemy Team Healing", string_arena_enemyteam_heal, nil, "Details!", "v1.0", [[Interface\ICONS\Ability_DualWield]], true, true)
		
			--> inicia um novo combate
			_detalhes:EntrarEmCombate()
		
			--> sinaliza que esse combate � arena
			_detalhes.tabela_vigente.arena = true
			_detalhes.tabela_vigente.is_arena = {name = _detalhes.zone_name, zone = _detalhes.zone_name, mapid = _detalhes.zone_id}
		
			_detalhes:SendEvent ("COMBAT_ARENA_START")
		end
		
		function _detalhes:StartArenaSegment (...)
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) starting a new arena segment.")
			end
			
			local timerType, timeSeconds, totalTime = select (1, ...)
			
			if (_detalhes.start_arena) then
				_detalhes:CancelTimer (_detalhes.start_arena, true)
			end
			_detalhes.start_arena = _detalhes:ScheduleTimer ("CreateArenaSegment", timeSeconds)
			_detalhes:GetPlayersInArena()
		end

		function _detalhes:EnteredInArena()

			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) the player EnteredInArena().")
			end
		
			_detalhes.arena_begun = false

			_detalhes:GetPlayersInArena()
		end
		
		function _detalhes:LeftArena()
		
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) player LeftArena().")
			end
		
			_detalhes.is_in_arena = false
			_detalhes.arena_begun = false
		
			if (_detalhes.start_arena) then
				_detalhes:CancelTimer (_detalhes.start_arena, true)
			end
			
			_detalhes:TimeDataUnregister ("Your Team Damage")
			_detalhes:TimeDataUnregister ("Enemy Team Damage")
			
			_detalhes:TimeDataUnregister ("Your Team Healing")
			_detalhes:TimeDataUnregister ("Enemy Team Healing")
			
			_detalhes:SendEvent ("COMBAT_ARENA_END")
		end
		
		local validSpells = {
			[220893] = {class = "ROGUE", spec = 261, maxPercent = 0.075, container = 1, commID = "MISSDATA_ROGUE_SOULRIP"},
			--[11366] = {class = "MAGE", spec = 63, maxPercent = 0.9, container = 1, commID = "MISSDATA_ROGUE_SOULRIP"},
		}
		function _detalhes:CanSendMissData()
			if (not IsInRaid() and not IsInGroup()) then
				return
			end
			local _, playerClass = UnitClass ("player")
			local specIndex = DetailsFramework.GetSpecialization()
			local playerSpecID
			if (specIndex) then
				playerSpecID = DetailsFramework.GetSpecializationInfo (specIndex)
			end

			if (playerSpecID and playerClass) then
				for spellID, t in pairs (validSpells) do
					if (playerClass == t.class and playerSpecID == t.spec) then
						_detalhes:SendMissData (spellID, t.container, _detalhes.network.ids [t.commID])
					end
				end
			end
			return false
		end
		
		function _detalhes:SendMissData (spellID, containerType, commID)
			local combat = _detalhes.tabela_vigente
			if (combat) then
				local damageActor = combat (containerType, _detalhes.playername)
				if (damageActor) then
					local spell = damageActor.spells:GetSpell (spellID)
					if (spell) then
						local data = {
							[1] = containerType,
							[2] = spellID,
							[3] = spell.total,
							[4] = spell.counter
						}
						
						if (_detalhes.debug) then
							_detalhes:Msg ("(debug) sending miss data packet:", spellID, containerType, commID)
						end
						
						_detalhes:SendRaidOrPartyData (commID, data)
					end
				end
			end
		end
		
		function _detalhes.HandleMissData (playerName, data)
			local combat = _detalhes.tabela_vigente
			
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) miss data received from:", playerName, "spellID:", data [2], data [3], data [4])
			end
			
			if (combat) then
				local containerType = data[1]
				if (type (containerType) ~= "number" or containerType < 1 or containerType > 4) then
					return
				end

				local damageActor = combat (containerType, playerName)
				if (damageActor) then
					local spellID = data[2] --a spellID has been passed?
					if (not spellID or type (spellID) ~= "number") then
						return
					end

					local validateSpell = validSpells [spellID]
					if (not validateSpell) then --is a valid spell?
						return
					end

					--does the target player fit in the spell requirement on OUR end?
					local class, spec, maxPercent = validateSpell.class, validateSpell.spec, validateSpell.maxPercent
					if (class ~= damageActor.classe or spec ~= damageActor.spec) then
						return
					end

					local total, counter = data[3], data[4]
					if (type (total) ~= "number" or type (counter) ~= "number") then
						return
					end

					if (total > (damageActor.total * maxPercent)) then
						return
					end

					local spellObject = damageActor.spells:PegaHabilidade (spellID, true)
					if (spellObject) then
						if (spellObject.total < total and total > 0 and damageActor.nome ~= _detalhes.playername) then
							local difference = total - spellObject.total
							if (difference > 0) then
								spellObject.total = total
								spellObject.counter = counter
								damageActor.total = damageActor.total + difference
								
								combat [containerType].need_refresh = true
								
								if (_detalhes.debug) then
									_detalhes:Msg ("(debug) miss data successful added from:", playerName, data [2], "difference:", difference)
								end
							end
						end
					end
				end
			end
		end
		
		function _detalhes:MakeEqualizeOnActor (player, realm, receivedActor)
		
			if (true) then --> disabled for testing
				return
			end
		
			local combat = _detalhes:GetCombat ("current")
			local damage, heal, energy, misc = _detalhes:GetAllActors ("current", player)
			
			if (not damage and not heal and not energy and not misc) then
			
				--> try adding server name
				damage, heal, energy, misc = _detalhes:GetAllActors ("current", player.."-"..realm)
				
				if (not damage and not heal and not energy and not misc) then
					--> not found any actor object, so we need to create
					
					local actorName
					
					if (realm ~= GetRealmName()) then
						actorName = player.."-"..realm
					else
						actorName = player
					end
					
					local guid = _detalhes:FindGUIDFromName (player)
					
					-- 0x512 normal party
					-- 0x514 normal raid
					
					if (guid) then
						damage = combat [1]:PegarCombatente (guid, actorName, 0x514, true)
						heal = combat [2]:PegarCombatente (guid, actorName, 0x514, true)
						energy = combat [3]:PegarCombatente (guid, actorName, 0x514, true)
						misc = combat [4]:PegarCombatente (guid, actorName, 0x514, true)
						
						if (_detalhes.debug) then
							_detalhes:Msg ("(debug) equalize received actor:", actorName, damage, heal)
						end
					else
						if (_detalhes.debug) then
							_detalhes:Msg ("(debug) equalize couldn't get guid for player ",player)
						end
					end
				end
			end
			
			combat[1].need_refresh = true
			combat[2].need_refresh = true
			combat[3].need_refresh = true
			combat[4].need_refresh = true
			
			if (damage) then
				if (damage.total < receivedActor [1][1]) then
					if (_detalhes.debug) then
						_detalhes:Msg (player .. " damage before: " .. damage.total .. " damage received: " .. receivedActor [1][1])
					end
					damage.total = receivedActor [1][1]
				end
				if (damage.damage_taken < receivedActor [1][2]) then
					damage.damage_taken = receivedActor [1][2]
				end
				if (damage.friendlyfire_total < receivedActor [1][3]) then
					damage.friendlyfire_total = receivedActor [1][3]
				end
			end
			
			if (heal) then
				if (heal.total < receivedActor [2][1]) then
					heal.total = receivedActor [2][1]
				end
				if (heal.totalover < receivedActor [2][2]) then
					heal.totalover = receivedActor [2][2]
				end
				if (heal.healing_taken < receivedActor [2][3]) then
					heal.healing_taken = receivedActor [2][3]
				end
			end
			
			if (energy) then
				if (energy.mana and (receivedActor [3][1] > 0 and energy.mana < receivedActor [3][1])) then
					energy.mana = receivedActor [3][1]
				end
				if (energy.e_rage and (receivedActor [3][2] > 0 and energy.e_rage < receivedActor [3][2])) then
					energy.e_rage = receivedActor [3][2]
				end
				if (energy.e_energy and (receivedActor [3][3] > 0 and energy.e_energy < receivedActor [3][3])) then
					energy.e_energy = receivedActor [3][3]
				end
				if (energy.runepower and (receivedActor [3][4] > 0 and energy.runepower < receivedActor [3][4])) then
					energy.runepower = receivedActor [3][4]
				end
			end
			
			if (misc) then
				if (misc.interrupt and (receivedActor [4][1] > 0 and misc.interrupt < receivedActor [4][1])) then
					misc.interrupt = receivedActor [4][1]
				end
				if (misc.dispell and (receivedActor [4][2] > 0 and misc.dispell < receivedActor [4][2])) then
					misc.dispell = receivedActor [4][2]
				end
			end
		end
		
		function _detalhes:EqualizePets()
			--> check for pets without owner
			for _, actor in _ipairs (_detalhes.tabela_vigente[1]._ActorTable) do 
				--> have flag and the flag tell us he is a pet
				if (actor.flag_original and bit.band (actor.flag_original, OBJECT_TYPE_PETS) ~= 0) then
					--> do not have owner and he isn't on owner container
					if (not actor.owner and not _detalhes.tabela_pets.pets [actor.serial]) then
						_detalhes:SendPetOwnerRequest (actor.serial, actor.nome)
					end
				end
			end
		end
		
		function _detalhes:EqualizeActorsSchedule (host_of)
		
			--> store pets sent through 'needpetowner'
			_detalhes.sent_pets = _detalhes.sent_pets or {n = time()}
			if (_detalhes.sent_pets.n+20 < time()) then
				_table_wipe (_detalhes.sent_pets)
				_detalhes.sent_pets.n = time()
			end
			
			--> pet equilize disabled on details 1.4.0
			--_detalhes:ScheduleTimer ("EqualizePets", 1+math.random())

			--> do not equilize if there is any disabled capture
			--if (_detalhes:CaptureIsAllEnabled()) then
				_detalhes:ScheduleTimer ("EqualizeActors", 2+math.random()+math.random() , host_of)
			--end
		end
		
		function _detalhes:EqualizeActors (host_of)
		
			--> Disabling the sync. Since WoD combatlog are sent between player on phased zones during encounters.
			if (not host_of or true) then --> full disabled for testing
				return
			end
		
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sending equilize actor data")
			end
		
			local damage, heal, energy, misc
		
			if (host_of) then
				damage, heal, energy, misc = _detalhes:GetAllActors ("current", host_of)
			else
				damage, heal, energy, misc = _detalhes:GetAllActors ("current", _detalhes.playername)
			end
			
			if (damage) then
				damage = {damage.total or 0, damage.damage_taken or 0, damage.friendlyfire_total or 0}
			else
				damage = {0, 0, 0}
			end
			
			if (heal) then
				heal = {heal.total or 0, heal.totalover or 0, heal.healing_taken or 0}
			else
				heal = {0, 0, 0}
			end
			
			if (energy) then
				energy = {energy.mana or 0, energy.e_rage or 0, energy.e_energy or 0, energy.runepower or 0}
			else
				energy = {0, 0, 0, 0}
			end
			
			if (misc) then
				misc = {misc.interrupt or 0, misc.dispell or 0}
			else
				misc = {0, 0}
			end
			
			local data = {damage, heal, energy, misc}

			--> envia os dados do proprio host pra ele antes
			if (host_of) then
				_detalhes:SendRaidDataAs (_detalhes.network.ids.CLOUD_EQUALIZE, host_of, nil, data)
				_detalhes:EqualizeActors()
			else
				_detalhes:SendRaidData (_detalhes.network.ids.CLOUD_EQUALIZE, data)
			end
			
		end
		
		function _detalhes:FlagActorsOnPvPCombat()
			for class_type, container in _ipairs (_detalhes.tabela_vigente) do 
				for _, actor in _ipairs (container._ActorTable) do 
					actor.pvp_component = true
				end
			end
		end
		
		function _detalhes:FlagActorsOnBossFight()
			for class_type, container in _ipairs (_detalhes.tabela_vigente) do 
				for _, actor in _ipairs (container._ActorTable) do 
					actor.boss_fight_component = true
				end
			end
		end
		
		local fight_component = function (energy_container, misc_container, name)
			local on_energy = energy_container._ActorTable [energy_container._NameIndexTable [name]]
			if (on_energy) then
				on_energy.fight_component = true
			end
			local on_misc = misc_container._ActorTable [misc_container._NameIndexTable [name]]
			if (on_misc) then
				on_misc.fight_component = true
			end
		end
		
		function _detalhes:FlagActorsOnCommonFight()
		
			local damage_container = _detalhes.tabela_vigente [1]
			local healing_container = _detalhes.tabela_vigente [2]
			local energy_container = _detalhes.tabela_vigente [3]
			local misc_container = _detalhes.tabela_vigente [4]
			
			local mythicDungeonRun = _detalhes.tabela_vigente.is_mythic_dungeon_segment
			
			for class_type, container in _ipairs ({damage_container, healing_container}) do 
			
				for _, actor in _ipairs (container._ActorTable) do 
				
					if (mythicDungeonRun) then
						actor.fight_component = true
					end
					
					if (actor.grupo) then
						if (class_type == 1 or class_type == 2) then
							for target_name, amount in _pairs (actor.targets) do 
								local target_object = container._ActorTable [container._NameIndexTable [target_name]]
								if (target_object) then
									target_object.fight_component = true
									fight_component (energy_container, misc_container, target_name)
								end
							end
							if (class_type == 1) then
								for damager_actor, _ in _pairs (actor.damage_from) do 
									local target_object = container._ActorTable [container._NameIndexTable [damager_actor]]
									if (target_object) then
										target_object.fight_component = true
										fight_component (energy_container, misc_container, damager_actor)
									end
								end
							elseif (class_type == 2) then
								for healer_actor, _ in _pairs (actor.healing_from) do 
									local target_object = container._ActorTable [container._NameIndexTable [healer_actor]]
									if (target_object) then
										target_object.fight_component = true
										fight_component (energy_container, misc_container, healer_actor)
									end
								end
							end
						end
					end
				end
				
			end
		end

		function _detalhes:AtualizarJanela (instancia, _segmento)
			if (_segmento) then --> apenas atualizar janelas que estejam mostrando o segmento solicitado
				if (_segmento == instancia.segmento) then
					instancia:TrocaTabela (instancia, instancia.segmento, instancia.atributo, instancia.sub_atributo, true)
				end
			else
				if (instancia.modo == modo_GROUP or instancia.modo == modo_ALL) then
					instancia:TrocaTabela (instancia, instancia.segmento, instancia.atributo, instancia.sub_atributo, true)
				end
			end
		end

		function _detalhes:PostponeInstanceToCurrent (instance)
			if (
				not instance.last_interaction or 
				(
					(instance.ativa) and
					(instance.last_interaction+3 < _tempo) and 
					(not DetailsReportWindow or not DetailsReportWindow:IsShown()) and 
					(not _detalhes.janela_info:IsShown())
				)
			) then
				instance._postponing_current = nil
				if (instance.segmento == 0) then
					return _detalhes:TrocaSegmentoAtual (instance)
				else
					return
				end
			end
			if (instance.is_interacting and instance.last_interaction < _tempo) then
				instance.last_interaction = _tempo
			end
			instance._postponing_current = _detalhes:ScheduleTimer ("PostponeInstanceToCurrent", 1, instance)
		end
		
		function _detalhes:TrocaSegmentoAtual (instancia, is_encounter)
			if (instancia.segmento == 0 and instancia.baseframe and instancia.ativa) then
			
				if (not is_encounter) then
					if (instancia.is_interacting) then
						if (not instancia.last_interaction or instancia.last_interaction < _tempo) then
							instancia.last_interaction = _tempo or time()
						end
					end
					
					if ((instancia.last_interaction and (instancia.last_interaction+3 > _detalhes._tempo)) or (DetailsReportWindow and DetailsReportWindow:IsShown()) or (_detalhes.janela_info:IsShown())) then
						--> postpone
						instancia._postponing_current = _detalhes:ScheduleTimer ("PostponeInstanceToCurrent", 1, instancia)
						return
					end
				end
				
				--print ("==> Changing the Segment now! - control.lua 1220")
				
				instancia.last_interaction = _tempo - 4 --pode setar, completou o ciclo
				instancia._postponing_current = nil
				instancia.showing = _detalhes.tabela_vigente
				instancia:ResetaGump()
				_detalhes.gump:Fade (instancia, "in", nil, "barras")
			end
		end
		
		function _detalhes:SetTrashSuppression (n)
			assert (type (n) == "number", "SetTrashSuppression expects a number on index 1.")
			if (n < 0) then
				n = 0
			end
			_detalhes.instances_suppress_trash = n
		end
		function _detalhes:CheckFor_SuppressedWindowsOnEncounterFound()
			for _, instance in _detalhes:ListInstances() do
				if (instance.ativa and instance.baseframe and (not instance.last_interaction or instance.last_interaction > _tempo) and instance.segmento == 0) then
					_detalhes:TrocaSegmentoAtual (instance, true)
				end
			end
		end
		function _detalhes:CheckFor_EnabledTrashSuppression()
			if (_detalhes.HasTrashSuppression and _detalhes.HasTrashSuppression > _tempo) then
				self.last_interaction = _detalhes.HasTrashSuppression
			end
		end
		function _detalhes:SetTrashSuppressionAfterEncounter()
			_detalhes:InstanceCall ("CheckFor_EnabledTrashSuppression")
		end
		function _detalhes:CheckFor_TrashSuppressionOnEncounterEnd()
			if (_detalhes.instances_suppress_trash > 0) then
				_detalhes.HasTrashSuppression = _tempo + _detalhes.instances_suppress_trash
				--> delaying in 3 seconds for other stuff like auto open windows after combat.
				_detalhes:ScheduleTimer ("SetTrashSuppressionAfterEncounter", 3)
			end
		end

	--> internal GetCombatId() version
		function _detalhes:NumeroCombate (flag)
			if (flag == 0) then
				_detalhes.combat_id = 0
			elseif (flag) then
				_detalhes.combat_id = _detalhes.combat_id + flag
			end
			return _detalhes.combat_id
		end

	--> tooltip fork / search key: ~tooltip
		local avatarPoint = {"bottomleft", "topleft", -3, -4}
		local backgroundPoint = {{"bottomleft", "topleft", 0, -3}, {"bottomright", "topright", 0, -3}}
		local textPoint = {"left", "right", -11, -5}
		local avatarTexCoord = {0, 1, 0, 1}
		local backgroundColor = {0, 0, 0, 0.6}
		local avatarTextColor = {1, 1, 1, 1}
		
		function _detalhes:AddTooltipReportLineText()
			GameCooltip:AddLine (Loc ["STRING_CLICK_REPORT_LINE1"], Loc ["STRING_CLICK_REPORT_LINE2"])
			GameCooltip:AddStatusBar (100, 1, 0, 0, 0, 0.8)
		end
		
		function _detalhes:AddTooltipBackgroundStatusbar (side, value, useSpark)
			_detalhes.tooltip.background [4] = 0.8
			_detalhes.tooltip.icon_size.W = _detalhes.tooltip.line_height
			_detalhes.tooltip.icon_size.H = _detalhes.tooltip.line_height
			
			value = value or 100
			
			if (not side) then
				local r, g, b, a = unpack (_detalhes.tooltip.background)
				GameCooltip:AddStatusBar (value, 1, r, g, b, a, useSpark, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
				
			else
				GameCooltip:AddStatusBar (value, 2, unpack (_detalhes.tooltip.background))
			end
		end
		
		function _detalhes:AddTooltipHeaderStatusbar (r, g, b, a)
			local r, g, b, a, statusbarGlow, backgroundBar = unpack (_detalhes.tooltip.header_statusbar)
			GameCooltip:AddStatusBar (100, 1, r, g, b, a, statusbarGlow, backgroundBar, "Skyline")
		end
		
-- /run local a,b=_detalhes.tooltip.header_statusbar,0.3;a[1]=b;a[2]=b;a[3]=b;a[4]=0.8;
		
		function _detalhes:AddTooltipSpellHeaderText (headerText, headerColor, amount, iconTexture, L, R, T, B, separator)

			if (separator and separator == true) then
				GameCooltip:AddLine ("", "", nil, nil, 1, 1, 1, 1, 8)
				
				return
			end

			if (_detalhes.tooltip.show_amount) then
				GameCooltip:AddLine (headerText, "x" .. amount .. "", nil, headerColor, 1, 1, 1, .4, _detalhes.tooltip.fontsize_title)
			else
				GameCooltip:AddLine (headerText, nil, nil, headerColor, nil, _detalhes.tooltip.fontsize_title)
			end

			if (iconTexture) then
				GameCooltip:AddIcon (iconTexture, 1, 1, 14, 14, L or 0, R or 1, T or 0, B or 1)
			end
		end
		
		local bgColor, borderColor = {0, 0, 0, 0.8}, {0, 0, 0, 0} --{0.37, 0.37, 0.37, .75}, {.30, .30, .30, .3}
		
		function _detalhes:FormatCooltipForSpells()
			local GameCooltip = GameCooltip

			GameCooltip:Reset()
			GameCooltip:SetType ("tooltip")

			GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\bar_background]])
			
			GameCooltip:SetOption ("TextSize", _detalhes.tooltip.fontsize)
			GameCooltip:SetOption ("TextFont",  _detalhes.tooltip.fontface)
			GameCooltip:SetOption ("TextColor", _detalhes.tooltip.fontcolor)
			GameCooltip:SetOption ("TextColorRight", _detalhes.tooltip.fontcolor_right)
			GameCooltip:SetOption ("TextShadow", _detalhes.tooltip.fontshadow and "OUTLINE")
			
			GameCooltip:SetOption ("LeftBorderSize", -5)
			GameCooltip:SetOption ("RightBorderSize", 5)
			GameCooltip:SetOption ("RightTextMargin", 0)
			GameCooltip:SetOption ("VerticalOffset", 9)
			GameCooltip:SetOption ("AlignAsBlizzTooltip", true)
			GameCooltip:SetOption ("AlignAsBlizzTooltipFrameHeightOffset", -8)
			GameCooltip:SetOption ("LineHeightSizeOffset", 4)
			GameCooltip:SetOption ("VerticalPadding", -4)

			GameCooltip:SetBackdrop (1, _detalhes.cooltip_preset2_backdrop, bgColor, borderColor)
		end

		function _detalhes:BuildInstanceBarTooltip (frame)
			local GameCooltip = GameCooltip
			_detalhes:FormatCooltipForSpells()
			GameCooltip:SetOption ("MinWidth", _math_max (230, self.baseframe:GetWidth()*0.98))
			
			local myPoint = _detalhes.tooltip.anchor_point
			local anchorPoint = _detalhes.tooltip.anchor_relative
			local x_Offset = _detalhes.tooltip.anchor_offset[1]
			local y_Offset = _detalhes.tooltip.anchor_offset[2]
			
			if (_detalhes.tooltip.anchored_to == 1) then
				
				GameCooltip:SetHost (frame, myPoint, anchorPoint, x_Offset, y_Offset)
			else
				GameCooltip:SetHost (DetailsTooltipAnchor, myPoint, anchorPoint, x_Offset, y_Offset)
			end
		end
		
		function _detalhes:MontaTooltip (frame, qual_barra, keydown)
		
			self:BuildInstanceBarTooltip (frame)
			
			local GameCooltip = GameCooltip
		
			local esta_barra = self.barras [qual_barra] --> barra que o mouse passou em cima e ir� mostrar o tooltip
			local objeto = esta_barra.minha_tabela --> pega a referencia da tabela --> retorna a classe_damage ou classe_heal
			if (not objeto) then --> a barra n�o possui um objeto
				return false
			end

			--verifica por tooltips especiais:
			if (objeto.dead) then --> � uma barra de dead
				return _detalhes:ToolTipDead (self, objeto, esta_barra, keydown) --> inst�ncia, [morte], barra
			elseif (objeto.byspell) then
				return _detalhes:ToolTipBySpell (self, objeto, esta_barra, keydown)
			elseif (objeto.frags) then
				return _detalhes:ToolTipFrags (self, objeto, esta_barra, keydown)
			elseif (objeto.boss_debuff) then
				return _detalhes:ToolTipVoidZones (self, objeto, esta_barra, keydown)
			end
			
			local t = objeto:ToolTip (self, qual_barra, esta_barra, keydown) --> inst�ncia, n� barra, objeto barra, keydown
			
			if (t) then
			
				if (objeto.serial and objeto.serial ~= "") then
					local avatar = NickTag:GetNicknameTable (objeto.serial, true)
					if (avatar and not _detalhes.ignore_nicktag) then
						if (avatar [2] and avatar [4] and avatar [1]) then
							GameCooltip:SetBannerImage (1, avatar [2], 80, 40, avatarPoint, avatarTexCoord, nil) --> overlay [2] avatar path
							GameCooltip:SetBannerImage (2, avatar [4], 200, 55, backgroundPoint, avatar [5], avatar [6]) --> background
							GameCooltip:SetBannerText (1, (not _detalhes.ignore_nicktag and avatar [1]) or objeto.nome, textPoint, avatarTextColor, 14, SharedMedia:Fetch ("font", _detalhes.tooltip.fontface)) --> text [1] nickname
						end
					else
						--if (_detalhes.remove_realm_from_name and objeto.displayName:find ("%*")) then
						--	GameCooltip:SetBannerImage (1, [[Interface\AddOns\Details\images\background]], 20, 30, avatarPoint, avatarTexCoord, {0, 0, 0, 0}) --> overlay [2] avatar path
						--	GameCooltip:SetBannerImage (2, [[Interface\PetBattles\Weather-BurntEarth]], 160, 30, {{"bottomleft", "topleft", 0, -5}, {"bottomright", "topright", 0, -5}}, {0.12, 0.88, 1, 0}, {0, 0, 0, 0.1}) --> overlay [2] avatar path {0, 0, 0, 0}
						--	GameCooltip:SetBannerText (1, objeto.nome, {"left", "left", 11, -8}, {1, 1, 1, 0.7}, 10, SharedMedia:Fetch ("font", _detalhes.tooltip.fontface)) --> text [1] nickname
						--end
					end
				end

				GameCooltip:ShowCooltip()
			end
		end
		
		function _detalhes.gump:UpdateTooltip (qual_barra, esta_barra, instancia)
			if (_IsShiftKeyDown()) then
				return instancia:MontaTooltip (esta_barra, qual_barra, "shift")
			elseif (_IsControlKeyDown()) then
				return instancia:MontaTooltip (esta_barra, qual_barra, "ctrl")
			elseif (_IsAltKeyDown()) then
				return instancia:MontaTooltip (esta_barra, qual_barra, "alt")
			else
				return instancia:MontaTooltip (esta_barra, qual_barra)
			end
		end
		
		function _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing)
			_detalhes:EsconderBarrasNaoUsadas (instancia, showing)
		end
		
		function _detalhes:EsconderBarrasNaoUsadas (instancia, showing)
			--> primeira atualiza��o ap�s uma mudan�a de segmento -->  verifica se h� mais barras sendo mostradas do que o necess�rio	
			--------------------
				if (instancia.v_barras) then
					--print ("mostrando", instancia.rows_showing, instancia.rows_created)
					for barra_numero = instancia.rows_showing+1, instancia.rows_created do
						_detalhes.gump:Fade (instancia.barras[barra_numero], "in")
					end
					instancia.v_barras = false
					
					if (instancia.rows_showing == 0 and instancia:GetSegment() == -1) then -- -1 overall data
						if (not instancia:IsShowingOverallDataWarning()) then
							local tutorial = _detalhes:GetTutorialCVar ("OVERALLDATA_WARNING1") or 0
							if ((type (tutorial) == "number") and (tutorial < 60)) then
								_detalhes:SetTutorialCVar ("OVERALLDATA_WARNING1", tutorial + 1)
								instancia:ShowOverallDataWarning (true)
							end
						end
					else
						if (instancia:IsShowingOverallDataWarning()) then
							instancia:ShowOverallDataWarning (false)
						end
					end
				end

			return showing
		end

	--> call update functions
		function _detalhes:AtualizarALL (forcar)

			local tabela_do_combate = self.showing

			--> confere se a inst�ncia possui uma tabela v�lida
			if (not tabela_do_combate) then
				if (not self.freezed) then
					return self:Freeze()
				end
				return
			end

			local need_refresh = tabela_do_combate[self.atributo].need_refresh
			if (not need_refresh and not forcar) then
				return --> n�o precisa de refresh
			--else
				--tabela_do_combate[self.atributo].need_refresh = false
			end
			
			if (self.atributo == 1) then --> damage
				return atributo_damage:RefreshWindow (self, tabela_do_combate, forcar, nil, need_refresh)
			elseif (self.atributo == 2) then --> heal
				return atributo_heal:RefreshWindow (self, tabela_do_combate, forcar, nil, need_refresh)
			elseif (self.atributo == 3) then --> energy
				return atributo_energy:RefreshWindow (self, tabela_do_combate, forcar, nil, need_refresh)
			elseif (self.atributo == 4) then --> outros
				return atributo_misc:RefreshWindow (self, tabela_do_combate, forcar, nil, need_refresh)
			elseif (self.atributo == 5) then --> ocustom
				return atributo_custom:RefreshWindow (self, tabela_do_combate, forcar, nil, need_refresh)
			end

		end

		function _detalhes:ForceRefresh()
			self:AtualizaGumpPrincipal (true)
		end
		
		function _detalhes:AtualizaGumpPrincipal (instancia, forcar)
			
			if (not instancia or type (instancia) == "boolean") then --> o primeiro par�metro n�o foi uma inst�ncia ou ALL
				forcar = instancia
				instancia = self
			end
			
			if (not forcar) then
				_detalhes.LastUpdateTick = _detalhes._tempo
			end
			
			if (instancia == -1) then
	
				--> update
				for index, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
					if (esta_instancia.ativa) then
						if (esta_instancia.modo == modo_GROUP or esta_instancia.modo == modo_ALL) then
							esta_instancia:AtualizarALL (forcar)
						end
					end
				end
				
				--> marcar que n�o precisa ser atualizada
				for index, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
					if (esta_instancia.ativa and esta_instancia.showing) then
						if (esta_instancia.modo == modo_GROUP or esta_instancia.modo == modo_ALL) then
							if (esta_instancia.atributo <= 4) then
								esta_instancia.showing [esta_instancia.atributo].need_refresh = false
							end
						end
					end
				end

				if (not forcar) then --atualizar o gump de detalhes tamb�m se ele estiver aberto
					if (info.ativo) then
						return info.jogador:MontaInfo()
					end
				end
				
				return
				
			else
				if (not instancia.ativa) then
					return
				end
			end
			
			if (instancia.modo == modo_ALL or instancia.modo == modo_GROUP) then
				return instancia:AtualizarALL (forcar)
			end
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _detalhes:AutoEraseConfirm()
	
		local panel = _G.DetailsEraseDataConfirmation
		if (not panel) then
			
			panel = CreateFrame ("frame", "DetailsEraseDataConfirmation", UIParent)
			panel:SetSize (400, 85)
			panel:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
			edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize = 12})
			panel:SetPoint ("center", UIParent)
			panel:SetBackdropColor (0, 0, 0, 0.4)
			
			panel:SetScript ("OnMouseDown", function (self, button)
				if (button == "RightButton") then
					panel:Hide()
				end
			end)
			
			--local icon = _detalhes.gump:CreateImage (panel, [[Interface\AddOns\Details\images\logotipo]], 512*0.4, 256*0.4)
			--icon:SetPoint ("bottomleft", panel, "topleft", -10, -11)
			
			local text = _detalhes.gump:CreateLabel (panel, Loc ["STRING_OPTIONS_CONFIRM_ERASE"], nil, nil, "GameFontNormal")
			text:SetPoint ("center", panel, "center")
			text:SetPoint ("top", panel, "top", 0, -10)
			
			local no = _detalhes.gump:CreateButton (panel, function() panel:Hide() end, 90, 20, Loc ["STRING_NO"])
			no:SetPoint ("bottomleft", panel, "bottomleft", 30, 10)
			no:InstallCustomTexture (nil, nil, nil, nil, true)
			
			local yes = _detalhes.gump:CreateButton (panel, function() panel:Hide(); _detalhes.tabela_historico:resetar() end, 90, 20, Loc ["STRING_YES"])
			yes:SetPoint ("bottomright", panel, "bottomright", -30, 10)
			yes:InstallCustomTexture (nil, nil, nil, nil, true)
		end
		
		panel:Show()
	end

	function _detalhes:CheckForAutoErase (mapid)
		if (_detalhes.last_instance_id ~= mapid) then
			_detalhes.tabela_historico:resetar_overall()
		
			if (_detalhes.segments_auto_erase == 2) then
				--ask
				_detalhes:ScheduleTimer ("AutoEraseConfirm", 1)
			elseif (_detalhes.segments_auto_erase == 3) then
				--erase
				_detalhes.tabela_historico:resetar()
			end
		else
			if (_tempo > _detalhes.last_instance_time + 21600) then --6 hours
				if (_detalhes.segments_auto_erase == 2) then
					--ask
					_detalhes:ScheduleTimer ("AutoEraseConfirm", 1)
				elseif (_detalhes.segments_auto_erase == 3) then
					--erase
					_detalhes.tabela_historico:resetar()
				end
			end
		end
		
		_detalhes.last_instance_id = mapid
		_detalhes.last_instance_time = _tempo
		--_detalhes.last_instance_time = 0 --debug
	end

	function _detalhes:UpdateControl()
		_tempo = _detalhes._tempo
	end			


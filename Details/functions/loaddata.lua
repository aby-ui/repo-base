	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load default keys into the main object

function _detalhes:ApplyBasicKeys()

	--> we are not in debug mode
		self.debug = false
		
	--> connected to realm channel
		self.is_connected = false

	--> who is
		self.playername = UnitName ("player")
		self.playerserial = UnitGUID ("player")
		
	--> player faction and enemy faction
		self.faction = UnitFactionGroup ("player")
		if (self.faction == PLAYER_FACTION_GROUP[0]) then --> player is horde
			self.faction_against = PLAYER_FACTION_GROUP[1] --> ally
			self.faction_id = 0
		elseif (self.faction == PLAYER_FACTION_GROUP[1]) then --> player is alliance
			self.faction_against = PLAYER_FACTION_GROUP[0] --> horde
			self.faction_id = 1
		end
		
		self.zone_type = nil
		_detalhes.temp_table1 = {}
		
	--> combat
		self.encounter = {}
		self.in_combat = false
		self.combat_id = 0

	--> instances (windows)
		self.solo = self.solo or nil 
		self.raid = self.raid or nil 
		self.opened_windows = 0
		
		self.default_texture = [[Interface\AddOns\Details\images\bar4]]
		self.default_texture_name = "Details D'ictum"

		self.class_coords_version = 1
		self.class_colors_version = 1
		
		self.school_colors = {
			[1] = {1.00, 1.00, 0.00},
			[2] = {1.00, 0.90, 0.50},
			[4] = {1.00, 0.50, 0.00},
			[8] = {0.30, 1.00, 0.30},
			[16] = {0.50, 1.00, 1.00},
			[32] = {0.50, 0.50, 1.00},
			[64] = {1.00, 0.50, 1.00},
			["unknown"] = {0.5, 0.75, 0.75, 1}
		}
		
	--> load default profile keys
		for key, value in pairs (_detalhes.default_profile) do 
			if (type (value) == "table") then
				local ctable = table_deepcopy (value)
				self [key] = ctable
			else
				self [key] = value
			end
		end
	
	--> end
		return true

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> check if this is a first run, reset, or just load the saved data.

function _detalhes:LoadGlobalAndCharacterData()

	--> check and build the default container for character database
	
		--> it exists?
		if (not _detalhes_database) then
			_detalhes_database = table_deepcopy (_detalhes.default_player_data)
		end

		--> load saved values
		for key, value in pairs (_detalhes.default_player_data) do
		
			--> check if key exists, e.g. a new key was added
			if (_detalhes_database [key] == nil) then
				if (type (value) == "table") then
					_detalhes_database [key] = table_deepcopy (_detalhes.default_player_data [key])
				else
					_detalhes_database [key] = value
				end
				
			elseif (type (_detalhes_database [key]) == "table") then
				for key2, value2 in pairs (_detalhes.default_player_data [key]) do 
					if (_detalhes_database [key] [key2] == nil) then
						if (type (value2) == "table") then
							_detalhes_database [key] [key2] = table_deepcopy (_detalhes.default_player_data [key] [key2])
						else
							_detalhes_database [key] [key2] = value2
						end
					end
				end
			end
			
			--> copy the key from saved table to details object
			if (type (value) == "table") then
				_detalhes [key] = table_deepcopy (_detalhes_database [key])
			else
				_detalhes [key] = _detalhes_database [key]
			end
			
		end
	
	--> check and build the default container for account database
		if (not _detalhes_global) then
			_detalhes_global = table_deepcopy (_detalhes.default_global_data)
		end
		
		for key, value in pairs (_detalhes.default_global_data) do 
		
			--> check if key exists
			if (_detalhes_global [key] == nil) then
				if (type (value) == "table") then
					_detalhes_global [key] = table_deepcopy (_detalhes.default_global_data [key])
				else
					_detalhes_global [key] = value
				end
				
			elseif (type (_detalhes_global [key]) == "table") then
				for key2, value2 in pairs (_detalhes.default_global_data [key]) do 
					if (_detalhes_global [key] [key2] == nil) then
						if (type (value2) == "table") then
							_detalhes_global [key] [key2] = table_deepcopy (_detalhes.default_global_data [key] [key2])
						else
							_detalhes_global [key] [key2] = value2
						end
					end
				end
			end
			
			--> copy the key from saved table to details object
			if (type (value) == "table") then
				_detalhes [key] = table_deepcopy (_detalhes_global [key])
			else
				_detalhes [key] = _detalhes_global [key]
			end

		end
		
	--> end
		return true
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load previous saved combat data

function _detalhes:LoadCombatTables()

	--> if isn't nothing saved, build a new one
		if (not _detalhes_database.tabela_historico) then
			_detalhes.tabela_historico = _detalhes.historico:NovoHistorico()
			_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
			_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
			_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
			_detalhes:UpdateContainerCombatentes()
		else

			--> build basic containers
				-- segments
				_detalhes.tabela_historico = _detalhes_database.tabela_historico or _detalhes.historico:NovoHistorico()
				-- overall
				_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
				
				-- pets
				_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
				if (_detalhes_database.tabela_pets) then
					_detalhes.tabela_pets.pets = table_deepcopy (_detalhes_database.tabela_pets)
				end
				_detalhes:UpdateContainerCombatentes()
				
			--> if the core revision was incremented, reset all combat data
				if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < _detalhes.realversion) then
					--> details was been hard upgraded
					_detalhes.tabela_historico = _detalhes.historico:NovoHistorico()
					_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
					_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
					_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
					_detalhes:UpdateContainerCombatentes()
					
					_detalhes_database.tabela_historico = nil
					_detalhes_database.tabela_overall = nil
				else
					--> check integrity
					local combat = _detalhes.tabela_historico.tabelas [1]
					if (combat) then
						if (not combat[1] or not combat[2] or not combat[3] or not combat[4]) then
							--> something went wrong in last logon, let's just reset and we are good to go
							_detalhes.tabela_historico = _detalhes.historico:NovoHistorico()
							_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
							_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
							_detalhes:UpdateContainerCombatentes()
						end
					end
				end

				if (not _detalhes.overall_clear_logout) then
					if (_detalhes_database.tabela_overall) then
						_detalhes.tabela_overall = _detalhes_database.tabela_overall
						_detalhes:RestauraOverallMetaTables()
					end
				end
				
			--> re-build all indexes and metatables
				_detalhes:RestauraMetaTables()

			--> get last combat table
				local historico_UM = _detalhes.tabela_historico.tabelas[1]
				
				if (historico_UM) then
					_detalhes.tabela_vigente = historico_UM --> significa que elas eram a mesma tabela, ent�o aqui elas se tornam a mesma tabela
				else
					_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
				end
				
			--> need refresh for all containers
				for _, container in ipairs (_detalhes.tabela_overall) do 
					container.need_refresh = true
				end
				for _, container in ipairs (_detalhes.tabela_vigente) do 
					container.need_refresh = true
				end
			
			--> erase combat data from the database
				_detalhes_database.tabela_vigente = nil
				_detalhes_database.tabela_historico = nil
				_detalhes_database.tabela_pets = nil
				
				-- double check for pet container
				if (not _detalhes.tabela_pets or not _detalhes.tabela_pets.pets) then
					_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
				end
				_detalhes:UpdateContainerCombatentes()
		
		end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load the saved config on the addon

function _detalhes:LoadConfig()

	--> plugins data
		_detalhes.plugin_database = _detalhes_database.plugin_database or {}

	--> startup
	
		--> set the nicktag cache host
			_detalhes:NickTagSetCache (_detalhes_database.nick_tag_cache)
			
		--> count data
			_detalhes:CountDataOnLoad()
			
		--> solo e raid plugin
			if (_detalhes_database.SoloTablesSaved) then
				if (_detalhes_database.SoloTablesSaved.Mode) then
					_detalhes.SoloTables.Mode = _detalhes_database.SoloTablesSaved.Mode
					_detalhes.SoloTables.LastSelected = _detalhes_database.SoloTablesSaved.LastSelected
				else
					_detalhes.SoloTables.Mode = 1
				end
			end
			
		--> switch tables
			_detalhes.switch.slots = _detalhes_global.switchSaved.slots
			_detalhes.switch.table = _detalhes_global.switchSaved.table
		
			if (_detalhes.switch.table) then
				for i = 1, #_detalhes.switch.table do
					if (not _detalhes.switch.table [i]) then
						_detalhes.switch.table [i] = {}
					end
				end
			end
		
		--> last boss
			_detalhes.last_encounter = _detalhes_database.last_encounter
		
		--> buffs
			_detalhes.savedbuffs = _detalhes_database.savedbuffs
			_detalhes.Buffs:BuildTables()
		
		--> initialize parser
			_detalhes.capture_current = {}
			for captureType, captureValue in pairs (_detalhes.capture_real) do 
				_detalhes.capture_current [captureType] = captureValue
			end
			
		--> row animations
			_detalhes:SetUseAnimations()

		--> initialize spell cache
			_detalhes:ClearSpellCache() 
			
		--> version first run
			if (not _detalhes_database.last_version or _detalhes_database.last_version ~= _detalhes.userversion) then
				_detalhes.is_version_first_run = true
			end
			--_detalhes.is_version_first_run = true
			--_detalhes_database.last_realversion = 126
			
	--> profile
	
		local unitname = UnitName ("player")
	
		--> fix for old versions
		if (type (_detalhes.always_use_profile) == "string") then
			_detalhes.always_use_profile_name = _detalhes.always_use_profile
			_detalhes.always_use_profile = true
		end
		
		--> check for "always use this profile"
			if (_detalhes.always_use_profile and not _detalhes.always_use_profile_exception [unitname]) then
				local profile_name = _detalhes.always_use_profile_name
				if (profile_name and _detalhes:GetProfile (profile_name)) then
					_detalhes_database.active_profile = profile_name
				end
			end
		
		--> old version
		--	if (_detalhes.always_use_profile and type (_detalhes.always_use_profile) == "string") then
		--		_detalhes_database.active_profile = _detalhes.always_use_profile
		--	end
	
		--> character first run
			if (_detalhes_database.active_profile == "") then
				_detalhes.character_first_run = true
				--> � a primeira vez que este character usa profiles,  precisa copiar as keys existentes
				local current_profile_name = _detalhes:GetCurrentProfileName()
				_detalhes:GetProfile (current_profile_name, true)
				_detalhes:SaveProfileSpecial()
			end
	
		--> load profile and active instances
			local current_profile_name = _detalhes:GetCurrentProfileName()
		--> check if exists, if not, create one
			local profile = _detalhes:GetProfile (current_profile_name, true)
		
		--> instances
			_detalhes.tabela_instancias = _detalhes_database.tabela_instancias or {}
			
			--> fix for version 1.21.0
			if (#_detalhes.tabela_instancias > 0) then --> only happens once after the character logon
				--if (current_profile_name:find (UnitName ("player"))) then
					for index, saved_skin in ipairs (profile.instances) do
						local instance = _detalhes.tabela_instancias [index]
						if (instance) then
							saved_skin.__was_opened = instance.ativa
							saved_skin.__pos = table_deepcopy (instance.posicao)
							saved_skin.__locked = instance.isLocked
							saved_skin.__snap = table_deepcopy (instance.snap)
							saved_skin.__snapH = instance.horizontalSnap
							saved_skin.__snapV = instance.verticalSnap
							
							for key, value in pairs (instance) do
								if (_detalhes.instance_defaults [key] ~= nil) then	
									if (type (value) == "table") then
										saved_skin [key] = table_deepcopy (value)
									else
										saved_skin [key] = value
									end
								end
							end
						end
					end
					
					for index, instance in _detalhes:ListInstances() do
						_detalhes.local_instances_config [index] = {
							pos = table_deepcopy (instance.posicao),
							is_open = instance.ativa,
							attribute = instance.atributo,
							sub_attribute = instance.sub_atributo,
							mode = instance.modo,
							segment = instance.segmento,
							snap = table_deepcopy (instance.snap),
							horizontalSnap = instance.horizontalSnap,
							verticalSnap = instance.verticalSnap,
							sub_atributo_last = instance.sub_atributo_last,
							isLocked = instance.isLocked
						}
						
						if (_detalhes.local_instances_config [index].isLocked == nil) then
							_detalhes.local_instances_config [index].isLocked = false
						end
					end
				--end
				
				_detalhes.tabela_instancias = {}
			end
			--_detalhes:ReativarInstancias()
		
		--> apply the profile
			_detalhes:ApplyProfile (current_profile_name, true)
			
		--> custom
			_detalhes.custom = _detalhes_global.custom
			_detalhes.refresh:r_atributo_custom()
			
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> count logons, tutorials, etc

function _detalhes:CountDataOnLoad()
	
	--> basic
		if (not _detalhes_global.got_first_run) then
			_detalhes.is_first_run = true
		end
		
	--> tutorial
		self.tutorial = self.tutorial or {}
		
		self.tutorial.logons = self.tutorial.logons or 0
		self.tutorial.logons = self.tutorial.logons + 1
		
		self.tutorial.unlock_button = self.tutorial.unlock_button or 0
		self.tutorial.version_announce = self.tutorial.version_announce or 0
		self.tutorial.main_help_button = self.tutorial.main_help_button or 0
		self.tutorial.alert_frames = self.tutorial.alert_frames or {false, false, false, false, false, false}
		
		self.tutorial.main_help_button = self.tutorial.main_help_button + 1
		
		self.character_data = self.character_data or {logons = 0}
		self.character_data.logons = self.character_data.logons + 1

end

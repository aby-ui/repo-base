--[[this file save the data when player leave the game]]

local _detalhes = 		_G._detalhes

function _detalhes:WipeConfig()
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	
	local b = CreateFrame ("button", "DetailsResetConfigButton", UIParent, "OptionsButtonTemplate")
	tinsert (UISpecialFrames, "DetailsResetConfigButton")
	
	b:SetSize (250, 40)
	b:SetText (Loc ["STRING_SLASH_WIPECONFIG_CONFIRM"])
	b:SetScript ("OnClick", function() _detalhes.wipe_full_config = true; ReloadUI(); end)
	b:SetPoint ("center", UIParent, "center", 0, 0)
end

local is_exception = {
	["nick_tag_cache"] = true
}

function _detalhes:SaveLocalInstanceConfig()

	for index, instance in _detalhes:ListInstances() do
		--> check for the max size toggle, don't save it
		if (instance.is_in_max_size) then
			instance.is_in_max_size = false
			instance:SetSize (instance.original_width, instance.original_height)
		end
		
		--> save local instance data
		local a1, a2 = instance:GetDisplay()
		
		local t = {
			pos = table_deepcopy (instance:GetPosition()), 
			is_open = instance:IsEnabled(),
			attribute = a1,
			sub_attribute = a2,
			mode = instance:GetMode(),
			segment = instance:GetSegment(),
			snap = table_deepcopy (instance.snap),
			horizontalSnap = instance.horizontalSnap,
			verticalSnap = instance.verticalSnap,
			sub_atributo_last = instance.sub_atributo_last,
			isLocked = instance.isLocked,
			last_raid_plugin = instance.last_raid_plugin
		}
		
		if (t.isLocked == nil) then
			t.isLocked = false
		end
		if (_detalhes.profile_save_pos) then
			local cprofile = _detalhes:GetProfile()
			local skin = cprofile.instances [instance:GetId()]
			if (skin) then
				t.pos = table_deepcopy (skin.__pos)
				t.horizontalSnap = skin.__snapH
				t.verticalSnap = skin.__snapV
				t.snap = table_deepcopy (skin.__snap)
				t.is_open = skin.__was_opened
				t.isLocked = skin.__locked
			end
		end
		
		_detalhes.local_instances_config [index] = t
	end
end

function _detalhes:SaveConfig()

	--> save instance configs localy
	_detalhes:SaveLocalInstanceConfig()
	
	--> cleanup
	
		_detalhes:PrepareTablesForSave()

		_detalhes_database.tabela_instancias = {} --_detalhes.tabela_instancias --[[instances now saves only inside the profile --]]
		_detalhes_database.tabela_historico = _detalhes.tabela_historico
		
		if (not _detalhes.overall_clear_logout) then
			_detalhes_database.tabela_overall = _detalhes.tabela_overall
		end
		
		local name, ttype, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()
		if (ttype == "party" or ttype == "raid") then
			--> salvar container de pet
			_detalhes_database.tabela_pets = _detalhes.tabela_pets.pets
		end
		
		xpcall (_detalhes.TimeDataCleanUpTemporary, _detalhes.saver_error_func)
		
	--> buffs
		xpcall (_detalhes.Buffs.SaveBuffs, _detalhes.saver_error_func)
	
	--> date
		_detalhes.last_day = date ("%d")
	
	--> salva o container do personagem
		for key, value in pairs (_detalhes.default_player_data) do
			if (not is_exception [key]) then
				_detalhes_database [key] = _detalhes [key]
			end
		end
	
	--> salva o container das globais
		for key, value in pairs (_detalhes.default_global_data) do
			if (key ~= "__profiles") then
				_detalhes_global [key] = _detalhes [key]
			end
		end

	--> solo e raid mode
		if (_detalhes.SoloTables.Mode) then
			_detalhes_database.SoloTablesSaved = {}
			_detalhes_database.SoloTablesSaved.Mode = _detalhes.SoloTables.Mode
			if (_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode]) then
				_detalhes_database.SoloTablesSaved.LastSelected = _detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].real_name
			end
		end
		
		_detalhes_database.RaidTablesSaved = nil
		
	--> salva switch tables
		_detalhes_global.switchSaved.slots = _detalhes.switch.slots
		_detalhes_global.switchSaved.table = _detalhes.switch.table
	
	--> last boss
		_detalhes_database.last_encounter = _detalhes.last_encounter
	
	--> last versions
		_detalhes_database.last_realversion = _detalhes.realversion --> core number
		_detalhes_database.last_version = _detalhes.userversion --> version
		_detalhes_global.got_first_run = true
	
end

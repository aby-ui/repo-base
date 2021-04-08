local _detalhes = 		_G._detalhes
local gump = 			_detalhes.gump
local container_pets =		_detalhes.container_pets

-- api locals
local _UnitGUID = _G.UnitGUID
local _UnitName = _G.UnitName
local _GetUnitName = _G.GetUnitName
local _IsInRaid = _G.IsInRaid
local _IsInGroup = _G.IsInGroup
local _GetNumGroupMembers = _G.GetNumGroupMembers

-- lua locals
local _setmetatable = setmetatable
local _bit_band = bit.band --lua local
local _pairs = pairs
local _ipairs = ipairs
local _table_wipe = table.wipe

--details locals
local is_ignored = _detalhes.pets_ignored

function container_pets:NovoContainer()
	local esta_tabela = {}
	_setmetatable (esta_tabela, _detalhes.container_pets)
	esta_tabela.pets = {} --> armazena a pool -> uma dictionary com o [serial do pet] -> nome do dono
	esta_tabela._ActorTable = {} --> armazena os 15 ultimos pets do jogador -> [jogador nome] -> {nil, nil, nil, ...}
	return esta_tabela
end

local OBJECT_TYPE_PET = 0x00001000
local EM_GRUPO = 0x00000007
local PET_EM_GRUPO = 0x00001007

function container_pets:PegaDono (pet_serial, pet_nome, pet_flags)

	--> sair se o pet estiver na ignore
	if (is_ignored [pet_serial]) then
		return
	end

	--> buscar pelo pet no container de pets
	local busca = self.pets [pet_serial]
	if (busca) then
		--in merging operations, make sure to not add the owner name a second time in the name
	
		--check if the pet name already has the owner name in, if not, add it
		if (not pet_nome:find ("<")) then
			--get the owner name
			local ownerName = busca[1]
			--add the owner name to the pet name
			pet_nome = pet_nome .. " <".. ownerName ..">"
		end
		
		return busca[6] or pet_nome, busca[1], busca[2], busca[3] --> [1] dono nome [2] dono serial [3] dono flag
	end
	
	--> buscar pelo pet na raide
	local dono_nome, dono_serial, dono_flags
	
	if (_IsInRaid()) then
		for i = 1, _GetNumGroupMembers() do 
			if (pet_serial == _UnitGUID ("raidpet"..i)) then
				dono_serial = _UnitGUID ("raid"..i)
				dono_flags = 0x00000417 --> emulate sourceflag flag
				
				local nome, realm = _UnitName ("raid"..i)
				if (realm and realm ~= "") then
					nome = nome.."-"..realm
				end
				dono_nome = nome
			end
		end
		
	elseif (_IsInGroup()) then
		for i = 1, _GetNumGroupMembers()-1 do 
			if (pet_serial == _UnitGUID ("partypet"..i)) then
				dono_serial = _UnitGUID ("party"..i)
				dono_flags = 0x00000417 --> emulate sourceflag flag
				
				local nome, realm = _UnitName ("party"..i)
				if (realm and realm ~= "") then
					nome = nome.."-"..realm
				end
				
				dono_nome = nome
			end
		end
	end
	
	if (not dono_nome) then
		if (pet_serial == _UnitGUID ("pet")) then
			dono_nome = _GetUnitName ("player")
			dono_serial = _UnitGUID ("player")
			if (_IsInGroup() or _IsInRaid()) then
				dono_flags = 0x00000417 --> emulate sourceflag flag
			else
				dono_flags = 0x00000411 --> emulate sourceflag flag
			end
		end
	end
	
	if (dono_nome) then
		self.pets [pet_serial] = {dono_nome, dono_serial, dono_flags, _detalhes._tempo, true, pet_nome, pet_serial} --> adicionada a flag emulada
		
		if (not pet_nome:find ("<")) then
			pet_nome = pet_nome .. " <".. dono_nome ..">"
		end
		
		return pet_nome, dono_nome, dono_serial, dono_flags
	else
		
		if (pet_flags and _bit_band (pet_flags, OBJECT_TYPE_PET) ~= 0) then --> � um pet
			if (not _detalhes.pets_no_owner [pet_serial] and _bit_band (pet_flags, EM_GRUPO) ~= 0) then
				_detalhes.pets_no_owner [pet_serial] = {pet_nome, pet_flags}
				_detalhes:Msg ("couldn't find the owner of the pet:", pet_nome)
			end
		else
			is_ignored [pet_serial] = true
		end
	end
	return
end

function container_pets:Unpet (...)
	local unitid = ...

	local owner_serial = _UnitGUID (unitid)
	
	if (owner_serial) then
		--tira o pet existente da tabela de pets e do cache do core
		local existing_pet_serial = _detalhes.pets_players [owner_serial]
		if (existing_pet_serial) then
			_detalhes.parser:RevomeActorFromCache (existing_pet_serial)
			container_pets:Remover (existing_pet_serial)
			_detalhes.pets_players [owner_serial] = nil
		end
		--verifica se h� um pet novo deste jogador
		local pet_serial = _UnitGUID (unitid .. "pet")
		if (pet_serial) then
			if (not _detalhes.tabela_pets.pets [pet_serial]) then
				local nome, realm = _UnitName (unitid)
				if (realm and realm ~= "") then
					nome = nome.."-"..realm
				end
				_detalhes.tabela_pets:Adicionar (pet_serial, _UnitName (unitid .. "pet"), 0x1114, owner_serial, nome, 0x514)
			end
			_detalhes.parser:RevomeActorFromCache (pet_serial)
			container_pets:PlayerPet (owner_serial, pet_serial)
		end
	end
end

function container_pets:PlayerPet (player_serial, pet_serial)
	_detalhes.pets_players [player_serial] = pet_serial
end

function container_pets:BuscarPets()
	if (_IsInRaid()) then
		for i = 1, _GetNumGroupMembers(), 1 do 
			local pet_serial = _UnitGUID ("raidpet"..i)
			if (pet_serial) then
				if (not _detalhes.tabela_pets.pets [pet_serial]) then
					local nome, realm = _UnitName ("raid"..i)
					if (realm and realm ~= "") then
						nome = nome.."-"..realm
					end
					local owner_serial = _UnitGUID ("raid"..i)
					_detalhes.tabela_pets:Adicionar (pet_serial, _UnitName ("raidpet"..i), 0x1114, owner_serial, nome, 0x514)
					_detalhes.parser:RevomeActorFromCache (pet_serial)
					container_pets:PlayerPet (owner_serial, pet_serial)
				end
			end
		end
		
	elseif (_IsInGroup()) then
		for i = 1, _GetNumGroupMembers()-1, 1 do 
			local pet_serial = _UnitGUID ("partypet"..i)
			if (pet_serial) then
				if (not _detalhes.tabela_pets.pets [pet_serial]) then
					local nome, realm = _UnitName ("party"..i)

					if (realm and realm ~= "") then
						nome = nome.."-"..realm
					end
					_detalhes.tabela_pets:Adicionar (pet_serial, _UnitName ("partypet"..i), 0x1114, _UnitGUID ("party"..i), nome, 0x514) 

				end
			end
		end
		
		local pet_serial = _UnitGUID ("pet")
		if (pet_serial) then
			if (not _detalhes.tabela_pets.pets [pet_serial]) then
				_detalhes.tabela_pets:Adicionar (pet_serial, _UnitName ("pet"), 0x1114, _UnitGUID ("player"), _detalhes.playername, 0x514)
			end
		end
		
	else
		local pet_serial = _UnitGUID ("pet")
		if (pet_serial) then
			if (not _detalhes.tabela_pets.pets [pet_serial]) then
				_detalhes.tabela_pets:Adicionar (pet_serial, _UnitName ("pet"), 0x1114, _UnitGUID ("player"), _detalhes.playername, 0x514)
			end
		end
	end
end

function container_pets:Remover (pet_serial)
	if (_detalhes.tabela_pets.pets [pet_serial]) then
		table.wipe (_detalhes.tabela_pets.pets [pet_serial])
	end
	_detalhes.tabela_pets.pets [pet_serial] = nil
end

function container_pets:Adicionar (pet_serial, pet_nome, pet_flags, dono_serial, dono_nome, dono_flags)
	if (pet_flags and _bit_band (pet_flags, OBJECT_TYPE_PET) ~= 0 and _bit_band (pet_flags, EM_GRUPO) ~= 0) then
		self.pets [pet_serial] = {dono_nome, dono_serial, dono_flags, _detalhes._tempo, true, pet_nome, pet_serial}
	else
		self.pets [pet_serial] = {dono_nome, dono_serial, dono_flags, _detalhes._tempo, false, pet_nome, pet_serial}
	end
end

function _detalhes:WipePets()
	return _table_wipe (_detalhes.tabela_pets.pets)
end

function _detalhes:LimparPets()
	--> erase old pet table by creating a new one
	local newPetTable = {}
	--> minimum of 90 minutes to clean a pet from the pet table data
	for PetSerial, PetTable in _pairs (_detalhes.tabela_pets.pets) do 
		if ( (PetTable[4] + 5400 > _detalhes._tempo + 1) or (PetTable[5] and PetTable[4] + 43200 > _detalhes._tempo) ) then
			newPetTable [PetSerial] = PetTable
		end
	end
	_detalhes.tabela_pets.pets = newPetTable
	_detalhes:UpdateContainerCombatentes()
	
end

local have_schedule = false
function _detalhes:UpdatePets()
	have_schedule = false
	return container_pets:BuscarPets()
end
function _detalhes:SchedulePetUpdate (seconds)
	if (have_schedule) then
		return
	end
	have_schedule = true

	--_detalhes:ScheduleTimer ("UpdatePets", seconds or 5)
	Details.Schedules.NewTimer(seconds or 5, Details.UpdatePets, Details)
end

function _detalhes.refresh:r_container_pets (container)
	_setmetatable (container, container_pets)
end


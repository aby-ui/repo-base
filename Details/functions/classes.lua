--[[ Declare all Details classes and container indexes ]]

do
	local _detalhes = 	_G._detalhes
	local addonName, Details222 = ...
	local setmetatable = setmetatable
	-------- container que armazena o cache de pets
		_detalhes.container_pets = {}
		_detalhes.container_pets.__index = _detalhes.container_pets
		setmetatable(_detalhes.container_pets, _detalhes)

	-------- time machine controla o tempo em combate dos jogadores
		_detalhes.timeMachine = {}
		_detalhes.timeMachine.__index = _detalhes.timeMachine
		setmetatable(_detalhes.timeMachine, _detalhes)

	-------- classe da tabela que armazenar� todos os combates efetuados
		_detalhes.historico = {}
		_detalhes.historico.__index = _detalhes.historico
		setmetatable(_detalhes.historico, _detalhes)

	---------------- classe da tabela onde ser�o armazenados cada combate efetuado
			_detalhes.combate = {}
			_detalhes.combate.__index = _detalhes.combate
			setmetatable(_detalhes.combate, _detalhes.historico)

	------------------------ armazenas classes de jogadores ou outros derivados
				_detalhes.container_combatentes = {}
				_detalhes.container_combatentes.__index = _detalhes.container_combatentes
				setmetatable(_detalhes.container_combatentes, _detalhes.combate)

	-------------------------------- dano das habilidades.
					_detalhes.atributo_damage = {}
					_detalhes.atributo_damage.__index = _detalhes.atributo_damage
					setmetatable(_detalhes.atributo_damage, _detalhes.container_combatentes)
					
	-------------------------------- cura das habilidades.
					_detalhes.atributo_heal = {}
					_detalhes.atributo_heal.__index = _detalhes.atributo_heal
					setmetatable(_detalhes.atributo_heal, _detalhes.container_combatentes)

	-------------------------------- e_energy ganha
					_detalhes.atributo_energy = {}
					_detalhes.atributo_energy.__index = _detalhes.atributo_energy
					setmetatable(_detalhes.atributo_energy, _detalhes.container_combatentes)
					
	-------------------------------- outros atributos
					_detalhes.atributo_misc = {}
					_detalhes.atributo_misc.__index = _detalhes.atributo_misc
					setmetatable(_detalhes.atributo_misc, _detalhes.container_combatentes)
					
	-------------------------------- atributos customizados
					_detalhes.atributo_custom = {}
					_detalhes.atributo_custom.__index = _detalhes.atributo_custom
					setmetatable(_detalhes.atributo_custom, _detalhes.container_combatentes)
					
	-------------------------------- armazena as classes de habilidades usadas pelo combatente
					_detalhes.container_habilidades = {}
					_detalhes.container_habilidades.__index = _detalhes.container_habilidades
					setmetatable(_detalhes.container_habilidades, _detalhes.combate)

	---------------------------------------- classe das habilidades que d�o cura
						_detalhes.habilidade_cura = {}
						_detalhes.habilidade_cura.__index = _detalhes.habilidade_cura
						setmetatable(_detalhes.habilidade_cura, _detalhes.container_habilidades)
						
	---------------------------------------- classe das habilidades que d�o danos
						_detalhes.habilidade_dano = {}
						_detalhes.habilidade_dano.__index = _detalhes.habilidade_dano
						setmetatable(_detalhes.habilidade_dano, _detalhes.container_habilidades)
						
	---------------------------------------- classe das habilidades que d�o e_energy
						_detalhes.habilidade_e_energy = {}
						_detalhes.habilidade_e_energy.__index = _detalhes.habilidade_e_energy
						setmetatable(_detalhes.habilidade_e_energy, _detalhes.container_habilidades)

	---------------------------------------- classe das habilidades variadas
						_detalhes.habilidade_misc = {}
						_detalhes.habilidade_misc.__index = _detalhes.habilidade_misc
						setmetatable(_detalhes.habilidade_misc, _detalhes.container_habilidades)
						
		---------------------------------------- classe dos alvos das habilidads
							_detalhes.alvo_da_habilidade = {}
							_detalhes.alvo_da_habilidade.__index = _detalhes.alvo_da_habilidade
							setmetatable(_detalhes.alvo_da_habilidade, _detalhes.container_combatentes)

							

	--[[ Armazena os diferentes tipos de containers ]] --[[ Container Types ]]
	_detalhes.container_type = {
		CONTAINER_PLAYERNPC = 1,
		CONTAINER_DAMAGE_CLASS = 2,
		CONTAINER_HEAL_CLASS = 3,
		CONTAINER_HEALTARGET_CLASS = 4,
		CONTAINER_FRIENDLYFIRE = 5,
		CONTAINER_DAMAGETARGET_CLASS = 6,
		CONTAINER_ENERGY_CLASS = 7,
		CONTAINER_ENERGYTARGET_CLASS = 8,
		CONTAINER_MISC_CLASS = 9,
		CONTAINER_MISCTARGET_CLASS = 10,
		CONTAINER_ENEMYDEBUFFTARGET_CLASS = 11
	}

	local initialSpecListOverride = {
		[1455] = 251, --dk
		[1456] = 577, --demon hunter
		[1447] = 102, --druid
		[1465] = 1467, --evoker
		[1448] = 253, --hunter
		[1449] = 63, --mage
		[1450] = 269, --monk
		[1451] = 70, --paladin
		[1452] = 258, --priest
		[1453] = 260, --rogue
		[1444] = 262, --shaman
		[1454] = 266, --warlock
		[1446] = 71, --warrior
	}

	function Details:SetSpecId(specId)
		self.spec = initialSpecListOverride[specId] or specId
	end

	function _detalhes:Name (actor)
		return self.nome or actor and actor.nome
	end
	function _detalhes:GetName (actor)
		return self.nome or actor and actor.nome
	end

	function _detalhes:GetNameNoRealm(actor)
		local name = self.nome or actor and actor.nome
		return Details:GetOnlyName(name)
	end

	function _detalhes:GetDisplayName (actor)
		return self.displayName or actor and actor.displayName
	end

	function Details:SetDisplayName(actor, newDisplayName)
		if (not newDisplayName) then
			newDisplayName = actor
			self.displayName = newDisplayName
		else
			actor.displayName = newDisplayName
		end
	end

	function _detalhes:GetOnlyName(string)
		if (string) then
			return string:gsub(("%-.*"), "")
		end
		return self.nome:gsub(("%-.*"), "")
	end
	
	function _detalhes:RemoveOwnerName (string)
		if (string) then
			return string:gsub((" <.*"), "")
		end
		return self.nome:gsub((" <.*"), "")
	end
	
	function _detalhes:GetCLName(id)
		local name, realm = UnitName (id)
		if (name) then
			if (realm and realm ~= "") then
				name = name .. "-" .. realm
			end
			return name
		end
	end
	function _detalhes:Class (actor)
		return self.classe or actor and actor.classe
	end
	function _detalhes:GetActorClass (actor)
		return self.classe or actor and actor.classe
	end
	function _detalhes:GetGUID (actor)
		return self.serial or actor and actor.serial
	end
	function _detalhes:GetFlag (actor)
		return self.flag_original or actor and actor.flag_original
	end
	function _detalhes:GetActorSpells()
		return self.spells._ActorTable
	end
	function _detalhes:GetSpell (spellid)
		return self.spells._ActorTable [spellid]
	end
	function _detalhes:Pets()
		return self.pets
	end

	function _detalhes:GetSpec(actor)
		return self.spec or actor and actor.spec
	end

	function _detalhes:Spec(actor)
		return self.spec or actor and actor.spec
	end
	
	--inherits to all actors without placing it on _detalhes namespace.
	_detalhes.container_combatentes.guid = _detalhes.GetGUID
	_detalhes.container_combatentes.name = _detalhes.GetName
	_detalhes.container_combatentes.class = _detalhes.GetActorClass
	_detalhes.container_combatentes.flag = _detalhes.GetFlag

end

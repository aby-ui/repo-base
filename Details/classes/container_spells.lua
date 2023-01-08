-- spells container file

local _detalhes = 		_G._detalhes
local _
local addonName, Details222 = ...

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local pointers

	local setmetatable = setmetatable --lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--constants

	local container_damage	=	_detalhes.container_type.CONTAINER_DAMAGE_CLASS
	local container_heal		= 	_detalhes.container_type.CONTAINER_HEAL_CLASS
	local container_energy 	=	_detalhes.container_type.CONTAINER_ENERGY_CLASS
	local container_misc 		=	_detalhes.container_type.CONTAINER_MISC_CLASS
	local habilidade_dano 	= 	_detalhes.habilidade_dano
	local habilidade_cura 		=	_detalhes.habilidade_cura
	local habilidade_e_energy 	= 	_detalhes.habilidade_e_energy
	local habilidade_misc 	=	_detalhes.habilidade_misc
	local container_habilidades = 	_detalhes.container_habilidades

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--internals

	function container_habilidades:NovoContainer (tipo_do_container)
		local _newContainer = {
			funcao_de_criacao = container_habilidades:FuncaoDeCriacao (tipo_do_container),
			tipo = tipo_do_container,
			_ActorTable = {}
		}

		setmetatable(_newContainer, container_habilidades)

		return _newContainer
	end

	---get the spellTable for the passed spellId
	---@param spellId number
	---@return table
	function container_habilidades:GetSpell (spellId)
		return self._ActorTable[spellId]
	end

	---return the value of the spellTable[key] for the passed spellId
	---@param spellId number
	---@param key string
	---@return any
	function container_habilidades:GetAmount(spellId, key)
		local spell = self._ActorTable[spellId]
		if (spell) then
			return spell[key]
		end
	end

	---return an iterator for all spellTables in this container
	---@return fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>
	function container_habilidades:ListActors()
		return pairs(self._ActorTable)
	end

	--same as the function above, just an alias
	function container_habilidades:ListSpells()
		return pairs(self._ActorTable)
	end

	function container_habilidades:GetOrCreateSpell(id, shouldCreate, token)
		return self:PegaHabilidade (id, shouldCreate, token)
	end

	function container_habilidades:PegaHabilidade (id, criar, token)

		local esta_habilidade = self._ActorTable [id]

		if (esta_habilidade) then
			return esta_habilidade
		else
			if (criar) then

				local novo_objeto = self.funcao_de_criacao (nil, id, nil, token)

				self._ActorTable [id] = novo_objeto

				return novo_objeto
			else
				return nil
			end
		end
	end

	function container_habilidades:FuncaoDeCriacao (tipo)
		if (tipo == container_damage) then
			return habilidade_dano.NovaTabela

		elseif (tipo == container_heal) then
			return habilidade_cura.NovaTabela

		elseif (tipo == container_energy) then
			return habilidade_e_energy.NovaTabela

		elseif (tipo == container_misc) then
			return habilidade_misc.NovaTabela

		end
	end

	function _detalhes.refresh:r_container_habilidades (container, shadow)
		--reconstr�i meta e indexes
			setmetatable(container, _detalhes.container_habilidades)
			container.__index = _detalhes.container_habilidades
			local func_criacao = container_habilidades:FuncaoDeCriacao (container.tipo)
			container.funcao_de_criacao = func_criacao
	end

	function _detalhes.clear:c_container_habilidades (container)
		--container.__index = {}
		container.__index = nil
		container.shadow = nil
		container.funcao_de_criacao = nil
	end

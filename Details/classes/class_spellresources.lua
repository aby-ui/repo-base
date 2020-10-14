-- energy ability file

	local _detalhes = 		_G._detalhes
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _UnitAura = UnitAura --api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local alvo_da_habilidade	=	_detalhes.alvo_da_habilidade
	local habilidade_energy	=	_detalhes.habilidade_e_energy
	local container_combatentes	= _detalhes.container_combatentes
	local container_energy_target	= _detalhes.container_type.CONTAINER_ENERGYTARGET_CLASS
	local container_playernpc		= _detalhes.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function habilidade_energy:NovaTabela (id, link, token)

		local _newEnergySpell = {
			id = id,
			counter = 0,
			total = 0,
			totalover = 0,
			targets = {}
		}
		
		return _newEnergySpell
	end

	function habilidade_energy:Add (serial, nome, flag, amount, who_nome, powertype, overpower)

		self.counter = self.counter + 1
		self.total = self.total + amount
		self.totalover = self.totalover + overpower
		self.targets [nome] = (self.targets [nome] or 0) + amount

	end

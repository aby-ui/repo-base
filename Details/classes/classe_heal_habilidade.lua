-- heal ability file

	local _detalhes = 		_G._detalhes
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local alvo_da_habilidade	=	_detalhes.alvo_da_habilidade
	local habilidade_cura		=	_detalhes.habilidade_cura
	local container_combatentes =	_detalhes.container_combatentes
	local container_heal_target	=	_detalhes.container_type.CONTAINER_HEALTARGET_CLASS
	local container_playernpc	=	_detalhes.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function habilidade_cura:NovaTabela (id, link)

		local _newHealSpell = {

			id = id,
			counter = 0,
			
			--> totals
			total = 0, 
			totalabsorb = 0,
			absorbed = 0,
			overheal = 0,
			totaldenied = 0,
			
			--> multistrike
			m_amt = 0,
			m_healed = 0,
			m_crit = 0,

			--> normal hits		
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_curado = 0,
			
			--> critical hits 		
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_curado = 0,

			--> targets containers
			targets = {},
			targets_overheal = {},
			targets_absorbs = {}
		}
		
		return _newHealSpell
	end

	function habilidade_cura:Add (serial, nome, flag, amount, extraSpellID, absorbed, critical, overhealing, is_shield)

		amount = amount or 0
		self.targets [nome] = (self.targets [nome] or 0) + amount

		if (absorbed == "SPELL_HEAL_ABSORBED") then
			self.counter = self.counter + 1
			self.totaldenied = self.totaldenied + amount
			
			local healerName = critical
			
			--create the denied table spells, on the fly
			if (not self.heal_denied) then
				self.heal_denied = {}
				self.heal_denied_healers = {}
			end
			
			self.heal_denied [extraSpellID] = (self.heal_denied [extraSpellID] or 0) + amount
			self.heal_denied_healers [healerName] = (self.heal_denied_healers [healerName] or 0) + amount
		else
		
			self.total = self.total + amount
			self.counter = self.counter + 1
			
			if (absorbed and absorbed > 0) then
				self.absorbed = self.absorbed + absorbed
			end
			
			if (overhealing and overhealing > 0) then
				self.overheal = self.overheal + overhealing
				self.targets_overheal [nome] = (self.targets_overheal [nome] or 0) + overhealing
			end
			
			if (is_shield) then
				self.totalabsorb = self.totalabsorb + amount
				self.targets_absorbs [nome] = (self.targets_absorbs [nome] or 0) + amount
			end
			
			if (critical) then
				self.c_curado = self.c_curado+amount --> amount � o total de dano
				self.c_amt = self.c_amt+1 --> amount � o total de dano
				if (amount > self.c_max) then
					self.c_max = amount
				end
				if (self.c_min > amount or self.c_min == 0) then
					self.c_min = amount
				end
			else
				self.n_curado = self.n_curado+amount
				self.n_amt = self.n_amt+1
				if (amount > self.n_max) then
					self.n_max = amount
				end
				if (self.n_min > amount or self.n_min == 0) then
					self.n_min = amount
				end
			end
		
		end

	end


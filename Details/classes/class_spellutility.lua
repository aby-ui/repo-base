-- misc ability file
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
	local habilidade_misc		=	_detalhes.habilidade_misc
	local container_combatentes	=	_detalhes.container_combatentes
	local container_misc_target	= 	_detalhes.container_type.CONTAINER_MISCTARGET_CLASS
	local container_playernpc	=	_detalhes.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function habilidade_misc:NovaTabela (id, link, token)

		local _newMiscSpell = {
			id = id,
			counter = 0,
			targets = {}
		}
		
		if (token == "BUFF_UPTIME" or token == "DEBUFF_UPTIME") then
			_newMiscSpell.uptime = 0
			_newMiscSpell.actived = false
			_newMiscSpell.activedamt = 0 --s�o quantos estao ativados no momento
			_newMiscSpell.refreshamt = 0
			_newMiscSpell.appliedamt = 0
			
		elseif (token == "SPELL_INTERRUPT") then
			_newMiscSpell.interrompeu_oque = {}
			
		elseif (token == "SPELL_DISPEL" or token == "SPELL_STOLEN") then
			_newMiscSpell.dispell_oque = {}
			
		elseif (token == "SPELL_AURA_BROKEN" or token == "SPELL_AURA_BROKEN_SPELL") then
			_newMiscSpell.cc_break_oque = {}
			
		end	
		
		return _newMiscSpell
	end

	function habilidade_misc:Add (serial, nome, flag, who_nome, token, spellID, spellName)

		--print (self.id, GetSpellInfo (self.id))
	
		if (spellID == "BUFF_OR_DEBUFF") then
			
			if (spellName == "COOLDOWN") then
				self.counter = self.counter + 1
				--> target
				self.targets [nome] = (self.targets [nome] or 0) + 1
				
			elseif (spellName == "BUFF_UPTIME_REFRESH") then
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _detalhes._tempo - self.actived_at
					self.refreshamt = self.refreshamt + 1
					token.buff_uptime = token.buff_uptime + _detalhes._tempo - self.actived_at --> token = actor misc object
				end
				self.actived_at = _detalhes._tempo
				self.actived = true
				
			elseif (spellName == "BUFF_UPTIME_OUT") then	
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _detalhes._tempo - self.actived_at
					token.buff_uptime = token.buff_uptime + _detalhes._tempo - self.actived_at --> token = actor misc object
				end
				self.actived = false
				self.actived_at = nil
				
			elseif (spellName == "BUFF_UPTIME_IN" or spellName == "DEBUFF_UPTIME_IN") then
				self.actived = true
				self.activedamt = self.activedamt + 1
				self.appliedamt = self.appliedamt + 1
				
				if (self.actived_at and self.actived and spellName == "DEBUFF_UPTIME_IN") then
					--> ja esta ativo em outro mob e jogou num novo
					self.uptime = self.uptime + _detalhes._tempo - self.actived_at
					token.debuff_uptime = token.debuff_uptime + _detalhes._tempo - self.actived_at
				end
				
				self.actived_at = _detalhes._tempo
				
			elseif (spellName == "DEBUFF_UPTIME_REFRESH") then
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _detalhes._tempo - self.actived_at
					self.refreshamt = self.refreshamt + 1
					token.debuff_uptime = token.debuff_uptime + _detalhes._tempo - self.actived_at
				end
				self.actived_at = _detalhes._tempo
				self.actived = true

			elseif (spellName == "DEBUFF_UPTIME_OUT") then	
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _detalhes._tempo - self.actived_at
					token.debuff_uptime = token.debuff_uptime + _detalhes._tempo - self.actived_at --> token = actor misc object
				end
				
				self.activedamt = self.activedamt - 1
				
				if (self.activedamt == 0) then
					self.actived = false
					self.actived_at = nil
				else
					self.actived_at = _detalhes._tempo
				end

			end
			
		elseif (token == "SPELL_INTERRUPT") then
			self.counter = self.counter + 1
			
			if (not self.interrompeu_oque [spellID]) then 
				self.interrompeu_oque [spellID] = 1
			else
				self.interrompeu_oque [spellID] = self.interrompeu_oque [spellID] + 1
			end
			
			--> target
			self.targets [nome] = (self.targets [nome] or 0) + 1
		
		elseif (token == "SPELL_RESURRECT") then
			self.ress = (self.ress or 0) + 1
			--> target
			self.targets [nome] = (self.targets [nome] or 0) + 1	
			
		elseif (token == "SPELL_DISPEL" or token == "SPELL_STOLEN") then
			self.dispell = (self.dispell or 0) + 1
			
			if (not self.dispell_oque [spellID]) then
				self.dispell_oque [spellID] = 1
			else
				self.dispell_oque [spellID] = self.dispell_oque [spellID] + 1
			end

			--> target
			self.targets [nome] = (self.targets [nome] or 0) + 1		
			
		elseif (token == "SPELL_AURA_BROKEN_SPELL" or token == "SPELL_AURA_BROKEN") then
			self.cc_break = (self.cc_break or 0) + 1
			
			if (not self.cc_break_oque [spellID]) then
				self.cc_break_oque [spellID] = 1
			else
				self.cc_break_oque [spellID] = self.cc_break_oque [spellID] + 1
			end
			
			--> target
			self.targets [nome] = (self.targets [nome] or 0) + 1	
		end

	end

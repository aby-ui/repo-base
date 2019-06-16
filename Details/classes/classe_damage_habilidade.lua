-- damage ability file

	local _detalhes = 		_G._detalhes
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	local _ipairs = ipairs--lua local
	local _pairs =  pairs--lua local
	local _UnitAura = UnitAura--api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local alvo_da_habilidade	= 	_detalhes.alvo_da_habilidade
	local habilidade_dano 	= 	_detalhes.habilidade_dano
	local container_combatentes =	_detalhes.container_combatentes
	local container_damage_target = _detalhes.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_playernpc 	=	_detalhes.container_type.CONTAINER_PLAYERNPC

	local _recording_ability_with_buffs = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function habilidade_dano:NovaTabela (id, link, token)

		local _newDamageSpell = {
		
			total = 0, --total damage
			counter = 0, --counter
			id = id, --spellid
			successful_casted = 0, --successful casted times (only for enemies)
			
			--> multistrike
			m_amt = 0,
			m_dmg = 0,
			m_crit = 0,
			--off_amt = 0,
			--off_dmg = 0,
			--main_amt = 0,
			
			--> normal hits
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_dmg = 0,
			
			--> critical hits
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_dmg = 0,

			--> glacing hits
			g_amt = 0,
			g_dmg = 0,
			
			--> resisted
			r_amt = 0,
			r_dmg = 0,
			
			--> blocked
			b_amt = 0,
			b_dmg = 0,

			--> obsorved
			a_amt = 0,
			a_dmg = 0,
			
			targets = {}
		}
		
		if (token == "SPELL_PERIODIC_DAMAGE") then
			_detalhes:SpellIsDot (id)
		end
		
		return _newDamageSpell
	end

	function habilidade_dano:AddMiss (serial, nome, flags, who_nome, missType)
		self.counter = self.counter + 1
		self [missType] = (self [missType] or 0) + 1
		
		self.targets [nome] = self.targets [nome] or 0
	end

	function habilidade_dano:Add (serial, nome, flag, amount, who_nome, resisted, blocked, absorbed, critical, glacing, token, isoffhand)

		self.total = self.total + amount
		
		self.targets [nome] = (self.targets [nome] or 0) + amount
		
		if (multistrike) then
		
			self.m_amt = self.m_amt + 1
			self.m_dmg = self.m_dmg + amount
			
			if (critical) then
				self.m_crit = self.m_crit + 1
			end
			
		else
		
			self.counter = self.counter + 1
		
			if (resisted and resisted > 0) then
				self.r_dmg = self.r_dmg+amount --> tabela.total � o total de dano
				self.r_amt = self.r_amt+1 --> tabela.total � o total de dano
			end
			
			if (blocked and blocked > 0) then
				self.b_dmg = self.b_dmg+amount --> amount � o total de dano
				self.b_amt = self.b_amt+1 --> amount � o total de dano
			end
			
			if (absorbed and absorbed > 0) then
				self.a_dmg = self.a_dmg+amount --> amount � o total de dano
				self.a_amt = self.a_amt+1 --> amount � o total de dano
			end
		
			if (glacing) then
				self.g_dmg = self.g_dmg+amount --> amount � o total de dano
				self.g_amt = self.g_amt+1 --> amount � o total de dano

			elseif (critical) then
				self.c_dmg = self.c_dmg+amount --> amount � o total de dano
				self.c_amt = self.c_amt+1 --> amount � o total de dano
				if (amount > self.c_max) then
					self.c_max = amount
				end
				if (self.c_min > amount or self.c_min == 0) then
					self.c_min = amount
				end
				
			else
				self.n_dmg = self.n_dmg+amount
				self.n_amt = self.n_amt+1
				if (amount > self.n_max) then
					self.n_max = amount
				end
				if (self.n_min > amount or self.n_min == 0) then
					self.n_min = amount
				end
			end
			
		end
		
		if (_recording_ability_with_buffs) then
			if (who_nome == _detalhes.playername) then --aqui ele vai detalhar tudo sobre a magia usada
			
				local buffsNames = _detalhes.SoloTables.BuffsTableNameCache
				
				local SpellBuffDetails = self.BuffTable
				if (not SpellBuffDetails) then
					self.BuffTable = {}
					SpellBuffDetails = self.BuffTable
				end
				
				if (token == "SPELL_PERIODIC_DAMAGE") then
					--> precisa ver se ele tinha na hora que aplicou
					local SoloDebuffPower = _detalhes.tabela_vigente.SoloDebuffPower
					if (SoloDebuffPower) then
						local ThisDebuff = SoloDebuffPower [self.id]
						if (ThisDebuff) then
							local ThisDebuffOnTarget = ThisDebuff [serial]
							if (ThisDebuffOnTarget) then
								for index, buff_name in _ipairs (ThisDebuffOnTarget.buffs) do
									local buff_info = SpellBuffDetails [buff_name] or {["counter"] = 0, ["total"] = 0, ["critico"] = 0, ["critico_dano"] = 0}
									buff_info.counter = buff_info.counter+1
									buff_info.total = buff_info.total+amount
									if (critical ~= nil) then
										buff_info.critico = buff_info.critico+1
										buff_info.critico_dano = buff_info.critico_dano+amount
									end
									SpellBuffDetails [buff_name] = buff_info
								end
							end
						end
					end
					
				else

					for BuffName, _ in _pairs (_detalhes.Buffs.BuffsTable) do
						local name = _UnitAura ("player", BuffName)
						if (name ~= nil) then
							local buff_info = SpellBuffDetails [name] or {["counter"] = 0, ["total"] = 0, ["critico"] = 0, ["critico_dano"] = 0}
							buff_info.counter = buff_info.counter+1
							buff_info.total = buff_info.total+amount
							if (critical ~= nil) then
								buff_info.critico = buff_info.critico+1
								buff_info.critico_dano = buff_info.critico_dano+amount
							end
							SpellBuffDetails [name] = buff_info
						end
					end
				end
			end
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _detalhes:UpdateDamageAbilityGears()
		_recording_ability_with_buffs = _detalhes.RecordPlayerAbilityWithBuffs
	end

--[[
if (isoffhand) then
	self.off_amt = self.off_amt + 1
	self.off_dmg = self.off_dmg + amount
else
	self.main_amt = self.main_amt + 1
end
--]]

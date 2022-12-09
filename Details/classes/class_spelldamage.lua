-- damage ability file
	local _detalhes = 		_G._detalhes
	local _
	local addonName, Details222 = ...

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local pointers
	local ipairs = ipairs
	local pairs =  pairs
	local _UnitAura = UnitAura

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--constants
	local habilidade_dano 	= 	_detalhes.habilidade_dano
	local _recording_ability_with_buffs = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--internals
--_detalhes.habilidade_dano:NovaTabela(spellId)

	function Details222.DamageSpells.CreateSpellTable(spellId, cleuToken)
		return habilidade_dano:NovaTabela(spellId, nil, cleuToken)
	end

	function habilidade_dano:NovaTabela(id, link, token)
		local _newDamageSpell = {
			total = 0, --total damage
			counter = 0, --counter
			id = id, --spellid
			successful_casted = 0, --successful casted times (only for enemies)

			--normal hits
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_dmg = 0,

			--critical hits
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_dmg = 0,

			--glacing hits
			g_amt = 0,
			g_dmg = 0,

			--resisted
			r_amt = 0,
			r_dmg = 0,

			--blocked
			b_amt = 0,
			b_dmg = 0,

			--obsorved
			a_amt = 0,
			a_dmg = 0,

			targets = {},
			extra = {}
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

	function habilidade_dano:Add (serial, nome, flag, amount, who_nome, resisted, blocked, absorbed, critical, glacing, token, isoffhand, isreflected)

		self.total = self.total + amount

		--if is reflected add the spellId into the extra table
		--this is too show which spells has been reflected
		if (isreflected) then
			self.extra [isreflected] = (self.extra [isreflected] or 0) + amount
		end

		self.targets [nome] = (self.targets [nome] or 0) + amount

		self.counter = self.counter + 1

		if (resisted and resisted > 0) then
			self.r_dmg = self.r_dmg+amount --tabela.total � o total de dano
			self.r_amt = self.r_amt+1 --tabela.total � o total de dano
		end

		if (blocked and blocked > 0) then
			self.b_dmg = self.b_dmg+amount --amount � o total de dano
			self.b_amt = self.b_amt+1 --amount � o total de dano
		end

		if (absorbed and absorbed > 0) then
			self.a_dmg = self.a_dmg+amount --amount � o total de dano
			self.a_amt = self.a_amt+1 --amount � o total de dano
		end

		if (glacing) then
			self.g_dmg = self.g_dmg+amount --amount � o total de dano
			self.g_amt = self.g_amt+1 --amount � o total de dano

		elseif (critical) then
			self.c_dmg = self.c_dmg+amount --amount � o total de dano
			self.c_amt = self.c_amt+1 --amount � o total de dano
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


		if (_recording_ability_with_buffs) then
			if (who_nome == _detalhes.playername) then --aqui ele vai detalhar tudo sobre a magia usada

				local buffsNames = _detalhes.SoloTables.BuffsTableNameCache

				local SpellBuffDetails = self.BuffTable
				if (not SpellBuffDetails) then
					self.BuffTable = {}
					SpellBuffDetails = self.BuffTable
				end

				if (token == "SPELL_PERIODIC_DAMAGE") then
					--precisa ver se ele tinha na hora que aplicou
					local SoloDebuffPower = _detalhes.tabela_vigente.SoloDebuffPower
					if (SoloDebuffPower) then
						local ThisDebuff = SoloDebuffPower [self.id]
						if (ThisDebuff) then
							local ThisDebuffOnTarget = ThisDebuff [serial]
							if (ThisDebuffOnTarget) then
								for index, buff_name in ipairs(ThisDebuffOnTarget.buffs) do
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

					for BuffName, _ in pairs(_detalhes.Buffs.BuffsTable) do
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
--core

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

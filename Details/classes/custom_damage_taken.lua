-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> attributes functions for customs
--> DAMAGE TAKEN

--> customized display script

	local _detalhes = 		_G._detalhes
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _cstr = string.format --lua local
	local _math_floor = math.floor --lua local
	local _table_sort = table.sort --lua local
	local _table_insert = table.insert --lua local
	local _table_size = table.getn --lua local
	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _rawget= rawget --lua local
	local _math_min = math.min --lua local
	local _math_max = math.max --lua local
	local _bit_band = bit.band --lua local
	local _unpack = unpack --lua local
	local _type = type --lua local
	
	local _GetSpellInfo = _detalhes.getspellinfo -- api local
	local _IsInRaid = IsInRaid -- api local
	local _IsInGroup = IsInGroup -- api local
	local _GetNumGroupMembers = GetNumGroupMembers -- api local
	local _GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers -- api local
	local _GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers -- api local
	local _GetUnitName = GetUnitName -- api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local atributo_custom = _detalhes.atributo_custom
	
	local ToKFunctions = _detalhes.ToKFunctions
	local SelectedToKFunction = ToKFunctions [1]
	local FormatTooltipNumber = ToKFunctions [8]
	local TooltipMaximizedMethod = 1

	function atributo_custom:UpdateDamageTakenBracket()
		SelectedToKFunction = ToKFunctions [_detalhes.ps_abbreviation]
		FormatTooltipNumber = ToKFunctions [_detalhes.tooltip.abbreviation]
		TooltipMaximizedMethod = _detalhes.tooltip.maximize_method
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> damage done tooltip
	
	function atributo_custom:damagetakenTooltip (actor, target, spellid, combat, instance)
	
		if (spellid) then

			if (instance:GetCustomObject():IsSpellTarget()) then
				local targetname = actor.nome
				local this_actor = combat (1, targetname)
				
				if (this_actor) then
					for name, _ in _pairs (this_actor.damage_from) do 
						local aggressor = combat (1, name)
						if (aggressor) then
							local spell = aggressor.spell_tables._ActorTable [spellid]
							if (spell) then
								local on_me = spell.targets._NameIndexTable [targetname]
								if (on_me) then
									on_me = spell.targets._ActorTable [on_me]
									GameCooltip:AddLine (aggressor.nome, FormatTooltipNumber (_, on_me.total))
								end
							end
						end
					end
				end
				
				return
			else
				local name, _, icon = _GetSpellInfo (spellid)
				GameCooltip:AddLine (name)
				GameCooltip:AddIcon (icon, 1, 1, 14, 14)
				
				GameCooltip:AddLine (Loc ["STRING_DAMAGE"] .. ": ", spell.total)
				GameCooltip:AddLine (Loc ["STRING_HITS"] .. ": ", spell.counter)
				GameCooltip:AddLine (Loc ["STRING_CRITICAL_HITS"] .. ": ", spell.c_amt)
			end
		
		elseif (target) then
			
			if (target == "[all]") then
				actor.targets:SortByKey ("total")
				for _, target_object in _ipairs (actor.targets._ActorTable) do
					GameCooltip:AddLine (target_object.nome, FormatTooltipNumber (_, target_object.total))
					_detalhes:AddTooltipBackgroundStatusbar()
					GameCooltip:AddIcon ([[Interface\FriendsFrame\StatusIcon-Offline]], 1, 1, 14, 14)
				end
				
			elseif (target == "[raid]") then
				local roster = combat.raid_roster
				actor.targets:SortByKey ("total")
				for _, target_object in _ipairs (actor.targets._ActorTable) do
					if (roster [target_object.nome]) then
						GameCooltip:AddLine (target_object.nome, FormatTooltipNumber (_, target_object.total))
					end
				end
				
			elseif (target == "[player]") then
				local targetactor = actor.targets._NameIndexTable [_detalhes.playername]
				if (targetactor) then
					targetactor = actor.targets._ActorTable [targetactor]
					GameCooltip:AddLine (targetactor.nome, FormatTooltipNumber (_, targetactor.total))
				end
			else
				local spells_used = {}
				
				for spellid, spelltable in _pairs (actor.spell_tables._ActorTable) do
					local this_target = spelltable.targets._NameIndexTable [target]
					if (this_target) then
						this_target = spelltable.targets._ActorTable [this_target]
						_table_insert (spells_used, {spellid, this_target.total})
					end
				end
				
				_table_sort (spells_used, _detalhes.Sort2)
				
				for index, spell in _ipairs (spells_used) do
					local name, _, icon = _GetSpellInfo (spell [1])
					GameCooltip:AddLine (name, FormatTooltipNumber (_, spell [2]))
					GameCooltip:AddIcon (icon, 1, 1, 14, 14)
				end
				
				--local targetactor = actor.targets._NameIndexTable [target]
				--if (targetactor) then
				--	targetactor = actor.targets._ActorTable [targetactor]
				--	GameCooltip:AddLine (target, FormatTooltipNumber (_, targetactor.total))
				--end
			end
		
		else
			actor:ToolTip_DamageDone (instance)
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> damage done search
	
	function atributo_custom:damagetaken (actor, source, target, spellid, combat, instance_container)

		if (spellid) then --> spell is always damage done
			local spell = actor.spell_tables._ActorTable [spellid]
			if (spell) then
				if (target) then
					if (target == "[all]") then
						for _, targetactor in _ipairs (spell.targets._ActorTable) do 
							--> add amount
							instance_container:AddValue (targetactor, targetactor.total, true)
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + targetactor.total
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [targetactor.nome]) then
								atributo_custom._TargetActorsProcessed [targetactor.nome] = true
								atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
						
					elseif (target == "[raid]") then
						local roster = combat.raid_roster
						for _, targetactor in _ipairs (spell.targets._ActorTable) do 
							if (roster [targetactor.nome]) then
								--> add amount
								instance_container:AddValue (targetactor, targetactor.total, true)
								atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + targetactor.total
								--> add to processed container
								if (not atributo_custom._TargetActorsProcessed [targetactor.nome]) then
									atributo_custom._TargetActorsProcessed [targetactor.nome] = true
									atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
								end
							end
						end
						return 0, true
						
					elseif (target == "[player]") then
						local targetactor = spell.targets._NameIndexTable [_detalhes.playername]
						if (targetactor) then
							targetactor = spell.targets._ActorTable [targetactor]
							--> add amount
							instance_container:AddValue (targetactor, targetactor.total, true)
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + targetactor.total
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [targetactor.nome]) then
								atributo_custom._TargetActorsProcessed [targetactor.nome] = true
								atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
					
					else
						local targetactor = actor.targets._NameIndexTable [target]
						if (targetactor) then
							targetactor = spell.targets._ActorTable [targetactor]
							--> add amount
							instance_container:AddValue (targetactor, targetactor.total, true)
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + targetactor.total
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [targetactor.nome]) then
								atributo_custom._TargetActorsProcessed [targetactor.nome] = true
								atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
					end
				else
					return spell.total
				end
			else
				return 0
			end

		elseif (target) then

			if (target == "[all]") then
				return actor.targets:GetTotal()
				
			elseif (target == "[raid]") then
				return actor.targets:GetTotalOnRaid (nil, combat)
			
			elseif (target == "[player]") then
				local targetactor = actor.targets._NameIndexTable [_detalhes.playername]
				if (targetactor) then
					return actor.targets._ActorTable [targetactor].total
				else
					return 0
				end

			else
				--> custom target
				local targetactor = actor.targets._NameIndexTable [target]
				if (targetactor) then
					return actor.targets._ActorTable [targetactor].total
				else
					return 0
				end
			end
		else
			return actor.damage_taken or 0
			
		end
		
	end

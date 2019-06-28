-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> attributes functions for customs
--> HEALING DONE

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

	function atributo_custom:UpdateHealingDoneBracket()
		SelectedToKFunction = ToKFunctions [_detalhes.ps_abbreviation]
		FormatTooltipNumber = ToKFunctions [_detalhes.tooltip.abbreviation]
		TooltipMaximizedMethod = _detalhes.tooltip.maximize_method
	end

	local temp_table = {}
	
	local target_func = function (main_table)
		local i = 1
		for name, amount in _pairs (main_table) do
			local t = temp_table [i]
			if (not t) then
				t = {"", 0}
				temp_table [i] = t
			end
			
			t[1] = name
			t[2] = amount
			
			i = i + 1
		end
	end
	
	local spells_used_func = function (main_table, target)
		local i = 1
		for spellid, spell_table in _pairs (main_table) do
			local target_amount = spell_table.targets [target]
			if (target_amount) then
				local t = temp_table [i]
				if (not t) then
					t = {"", 0}
					temp_table [i] = t
				end
				
				t[1] = spellid
				t[2] = target_amount
				
				i = i + 1
			end
		end
	end
	
	local function SortOrder (main_table, func, ...)
		for i = 1, #temp_table do
			temp_table [i][1] = ""
			temp_table [i][2] = 0
		end
		
		func (main_table, ...)
		
		_table_sort (temp_table, _detalhes.Sort2)
		
		return temp_table
	end	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> healing done tooltip
	
	
	function atributo_custom:healdoneTooltip (actor, target, spellid, combat, instance)
	
		if (spellid) then

			if (instance:GetCustomObject():IsSpellTarget()) then
				local targetname = actor.nome
				local this_actor = combat (2, targetname)
				
				if (this_actor) then
					for name, _ in _pairs (this_actor.healing_from) do 
						local healer = combat (2, name)
						if (healer) then
							local spell = healer.spells._ActorTable [spellid]
							if (spell) then
								local on_me = spell.targets [targetname]
								if (on_me) then
									GameCooltip:AddLine (healer.nome, FormatTooltipNumber (_, on_me))
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
				
				GameCooltip:AddLine (Loc ["STRING_HEAL"] .. ": ", spell.total)
				GameCooltip:AddLine (Loc ["STRING_HITS"] .. ": ", spell.counter)
				GameCooltip:AddLine (Loc ["STRING_CRITICAL_HITS"] .. ": ", spell.c_amt)
			end
		
		elseif (target) then
			
			if (target == "[all]") then
				SortOrder (actor.targets, target_func)
				
				for i = 1, #temp_table do
					local t = temp_table [i]
					if (t[2] < 1) then
						break
					end
					
					GameCooltip:AddLine (t[1], FormatTooltipNumber (_, t[2]))
					_detalhes:AddTooltipBackgroundStatusbar()
					GameCooltip:AddIcon ([[Interface\FriendsFrame\StatusIcon-Offline]], 1, 1, 14, 14)
				end
				
			elseif (target == "[raid]") then
				local roster = combat.raid_roster
				
				SortOrder (actor.targets, target_func)
				
				for i = 1, #temp_table do
					local t = temp_table [i]
					
					if (t[2] < 1) then
						break
					end
					
					if (roster [t[1]]) then
						GameCooltip:AddLine (t[1], FormatTooltipNumber (_, t[2]))
					end
				end
				
			elseif (target == "[player]") then
				local target_amount = actor.targets [_detalhes.playername]
				if (target_amount) then
					GameCooltip:AddLine (targetactor.nome, FormatTooltipNumber (_, target_amount))
				end
				
			else
				SortOrder (actor.spells._ActorTable, spells_used_func, target)

				for i = 1, #temp_table do
				
					local t = temp_table [i]
					
					if (t[2] < 1) then
						break
					end
					
					local name, _, icon = _GetSpellInfo (t[1])
					GameCooltip:AddLine (name, FormatTooltipNumber (_, t[2]))
					GameCooltip:AddIcon (icon, 1, 1, 14, 14)
				end
			end
		
		else
			actor:ToolTip_HealingDone (instance)
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> healing done search
	
	function atributo_custom:healdone (actor, source, target, spellid, combat, instance_container)

		if (spellid) then --> spell is always healing done
			local spell = actor.spells._ActorTable [spellid]
			local melee = actor.spells._ActorTable [1]
			if (spell) then
				if (target) then
					if (target == "[all]") then
						for target_name, amount in _pairs (spell.targets) do 
							--> add amount
							
							--> we need to pass a object here in order to get name and class, so we just get the main heal actor from the combat
							instance_container:AddValue (combat (1, target_name), amount, true)
							--
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + amount
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [target_name]) then
								atributo_custom._TargetActorsProcessed [target_name] = true
								atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
						
					elseif (target == "[raid]") then
						local roster = combat.raid_roster
						for target_name, amount in _pairs (spell.targets) do 
							if (roster [target_name]) then
								--> add amount
								instance_container:AddValue (combat (1, target_name), amount, true)
								atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + amount
								--> add to processed container
								if (not atributo_custom._TargetActorsProcessed [target_name]) then
									atributo_custom._TargetActorsProcessed [target_name] = true
									atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
								end
							end
						end
						return 0, true
						
					elseif (target == "[player]") then
						local target_amount = spell.targets [_detalhes.playername]
						if (target_amount) then
							--> add amount
							instance_container:AddValue (combat (1, _detalhes.playername), target_amount, true)
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + target_amount
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [_detalhes.playername]) then
								atributo_custom._TargetActorsProcessed [_detalhes.playername] = true
								atributo_custom._TargetActorsProcessedAmt = atributo_custom._TargetActorsProcessedAmt + 1
							end
						end
						return 0, true
					
					else
						local target_amount = actor.targets [target]
						if (target_amount) then
							--> add amount
							instance_container:AddValue (combat (1, target), target_amount, true)
							atributo_custom._TargetActorsProcessedTotal = atributo_custom._TargetActorsProcessedTotal + target_amount
							--> add to processed container
							if (not atributo_custom._TargetActorsProcessed [target]) then
								atributo_custom._TargetActorsProcessed [target] = true
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
				local total = 0
				for target_name, amount in _pairs (actor.targets) do
					total = total + amount
				end
				return total
				
			elseif (target == "[raid]") then
				local total = 0
				for target_name, amount in _pairs (actor.targets) do
					if (combat.raid_roster [target_name]) then
						total = total + amount
					end
				end
				return total
			
			elseif (target == "[player]") then
				return actor.targets [_detalhes.playername] or 0

			else
				return actor.targets [targetactor] or 0
			end
		else
			return actor.total or 0
			
		end
		
	end	

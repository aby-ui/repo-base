-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _tempo = time()
	local _
	local DetailsFramework = DetailsFramework

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _UnitAffectingCombat = UnitAffectingCombat --wow api local
	local _UnitHealth = UnitHealth --wow api local
	local _UnitHealthMax = UnitHealthMax --wow api local
	local _UnitIsFeignDeath = UnitIsFeignDeath --wow api local
	local _UnitGUID = UnitGUID --wow api local
	local _GetUnitName = GetUnitName --wow api local
	local _GetInstanceInfo = GetInstanceInfo --wow api local
	local _IsInRaid = IsInRaid --wow api local
	local _IsInGroup = IsInGroup --wow api local
	local _GetNumGroupMembers = GetNumGroupMembers --wow api local
	local _UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
	local _GetTime = GetTime
	local _select = select
	local _UnitBuff = UnitBuff
	local _tonumber = tonumber
	
	local _CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

	local _cstr = string.format --lua local
	local _table_insert = table.insert --lua local
	local _select = select --lua local
	local _bit_band = bit.band --lua local
	local _math_floor = math.floor --lua local
	local _table_remove = table.remove --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _table_sort = table.sort --lua local
	local _type = type --lua local
	local _math_ceil = math.ceil --lua local
	local _table_wipe = table.wipe --lua local
	local _strsplit = strsplit

	local _GetSpellInfo = _detalhes.getspellinfo --details api
	local escudo = _detalhes.escudos --details local
	local parser = _detalhes.parser --details local
	local absorb_spell_list = _detalhes.AbsorbSpells --details local
	local arena_enemies = _detalhes.arena_enemies --details local

	local cc_spell_list = DetailsFramework.CrowdControlSpells
	
	local container_combatentes = _detalhes.container_combatentes --details local
	local container_habilidades = _detalhes.container_habilidades --details local
	
	--> localize the cooldown table from the framework
	local defensive_cooldowns = DetailsFramework.CooldownsAllDeffensive
	
	local spell_damage_func = _detalhes.habilidade_dano.Add --details local
	local spell_damageMiss_func = _detalhes.habilidade_dano.AddMiss --details local
	local spell_damageFF_func = _detalhes.habilidade_dano.AddFF --details local

	local spell_heal_func = _detalhes.habilidade_cura.Add --details local
	local spell_energy_func = _detalhes.habilidade_e_energy.Add --details local
	local spell_misc_func = _detalhes.habilidade_misc.Add --details local
	
	--> current combat and overall pointers
		local _current_combat = _detalhes.tabela_vigente or {} --> placeholder table
		local _current_combat_cleu_events = {n = 1} --> placeholder

	--> total container pointers
		local _current_total = _current_combat.totals
		local _current_gtotal = _current_combat.totals_grupo
	--> actors container pointers
		local _current_damage_container = _current_combat [1]
		local _current_heal_container = _current_combat [2]
		local _current_energy_container = _current_combat [3]
		local _current_misc_container = _current_combat [4]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> cache
	--> damage
		local damage_cache = setmetatable ({}, _detalhes.weaktable)
		local damage_cache_pets = setmetatable ({}, _detalhes.weaktable)
		local damage_cache_petsOwners = setmetatable ({}, _detalhes.weaktable)
	--> heaing
		local healing_cache = setmetatable ({}, _detalhes.weaktable)
		local banned_healing_spells = {
			[326514] = true, --remove on 10.0 - Forgeborne Reveries - necrolords ability
		}
	--> energy
		local energy_cache = setmetatable ({}, _detalhes.weaktable)
	--> misc
		local misc_cache = setmetatable ({}, _detalhes.weaktable)
		local misc_cache_pets = setmetatable ({}, _detalhes.weaktable)
		local misc_cache_petsOwners = setmetatable ({}, _detalhes.weaktable)
	--> party & raid members
		local raid_members_cache = setmetatable ({}, _detalhes.weaktable)
	--> tanks
		local tanks_members_cache = setmetatable ({}, _detalhes.weaktable)
	--> auto regen
		local auto_regen_cache = setmetatable ({}, _detalhes.weaktable)
	--> bitfield swap cache
		local bitfield_swap_cache = {}
	--> damage and heal last events
		local last_events_cache = {} --> initialize table (placeholder)
	--> npcId cache
		local npcid_cache = {}
	--> pets
		local container_pets = {} --> initialize table (placeholder)
	--> ignore deaths
		local ignore_death = {}
	--> temp ignored 
		local ignore_actors = {}
	--> druids kyrian bounds
		local druid_kyrian_bounds = {}
	--> spell containers for special cases
		local monk_guard_talent = {} --guard talent for bm monks
	--> spell reflection
		local reflection_damage = {} --self-inflicted damage
		local reflection_debuffs = {} --self-inflicted debuffs
		local reflection_events = {} --spell_missed reflected events
		local reflection_auras = {} --active reflecting auras
		local reflection_dispels = {} --active reflecting dispels
		local reflection_spellid = {
			--> we can track which spell caused the reflection
			--> this is used to credit this aura as the one doing the damage
			[23920] = true, --warrior spell reflection
			[216890] = true, --warrior spell reflection (pvp talent)
			[213915] = true, --warrior mass spell reflection
			[212295] = true, --warlock nether ward
			--check pally legendary
		}
		local reflection_dispelid = {
			--> some dispels also reflect, and we can track them
			[122783] = true, --monk diffuse magic
			
			--[205604] = true, --demon hunter reverse magic
			--> this last one is an odd one, like most dh spells is kindy buggy combatlog wise
			--> for now it doesn't fire SPELL_DISPEL events even when dispelling stuff (thanks blizzard)
			--> maybe someone can figure out something to track it... but for now it doesnt work
		}
		local reflection_ignore = {
			--> common self-harm spells that we know weren't reflected
			--> this list can be expanded
			[111400] = true, --warlock burning rush
			[124255] = true, --monk stagger
			[196917] = true, --paladin light of the martyr
			[217979] = true, --warlock health funnel
			
			--> bugged spells
			[315197] = true, --thing from beyond grand delusions
			--> this corruption when reflected causes insane amounts of damage to the thing from beyond
			--> anywhere from a few hundred thousand damage to over 50 millons
			--> filtering it the best course of action as nobody should care about this damage
		}
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local container_damage_target = _detalhes.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_misc = _detalhes.container_type.CONTAINER_MISC_CLASS
	local duel_candidates = _detalhes.duel_candidates
	
	local _token_ids = _detalhes.TokenID
	
	local OBJECT_TYPE_ENEMY	=	0x00000040
	local OBJECT_TYPE_PLAYER 	=	0x00000400
	local OBJECT_TYPE_PETS 	=	0x00003000
	local AFFILIATION_GROUP 	=	0x00000007
	local REACTION_FRIENDLY 	=	0x00000010 
	local REACTION_MINE 		=	0x00000001 
	
	local ENVIRONMENTAL_FALLING_NAME	= Loc ["STRING_ENVIRONMENTAL_FALLING"]
	local ENVIRONMENTAL_DROWNING_NAME	= Loc ["STRING_ENVIRONMENTAL_DROWNING"]
	local ENVIRONMENTAL_FATIGUE_NAME	= Loc ["STRING_ENVIRONMENTAL_FATIGUE"]
	local ENVIRONMENTAL_FIRE_NAME		= Loc ["STRING_ENVIRONMENTAL_FIRE"]
	local ENVIRONMENTAL_LAVA_NAME		= Loc ["STRING_ENVIRONMENTAL_LAVA"]
	local ENVIRONMENTAL_SLIME_NAME	= Loc ["STRING_ENVIRONMENTAL_SLIME"]
	
	local RAID_TARGET_FLAGS = {
		[128] = true, --0x80 skull
		[64] = true, --0x40 cross
		[32] = true, --0x20 square
		[16] = true, --0x10 moon
		[8] = true, --0x8 triangle
		[4] = true, --0x4 diamond
		[2] = true, --0x2 circle
		[1] = true, --0x1 star
	}
	
	--> spellIds override
	local override_spellId = {
		[184707] = 218617, --warrior rampage
		[184709] = 218617, --warrior rampage
		[201364] = 218617, --warrior rampage
		[201363] = 218617, --warrior rampage
		[85384] = 96103, --warrior raging blow
		[85288] = 96103, --warrior raging blow
		[280849] = 5308, --warrior execute
		[163558] = 5308, --warrior execute
		[217955] = 5308, --warrior execute
		[217956] = 5308, --warrior execute
		[217957] = 5308, --warrior execute
		[224253] = 5308, --warrior execute
		[199850] = 199658, --warrior whirlwind
		[190411] = 199658, --warrior whirlwind
		[44949] = 199658, --warrior whirlwind
		[199667] = 199658, --warrior whirlwind
		[199852] = 199658, --warrior whirlwind
		[199851] = 199658, --warrior whirlwind
		
		[222031] = 199547, --deamonhunter ChaosStrike
		[200685] = 199552, --deamonhunter Blade Dance
		[210155] = 210153, --deamonhunter Death Sweep
		[227518] = 201428, --deamonhunter Annihilation
		[187727] = 178741, --deamonhunter Immolation Aura
		[201789] = 201628, --deamonhunter Fury of the Illidari
		[225921] = 225919, --deamonhunter Fracture talent
		
		[205164] = 205165, --death knight Crystalline Swords
		
		[193315] = 197834, --rogue Saber Slash
		[202822] = 202823, --rogue greed
		[280720] = 282449, --rogue Secret Technique
		[280719] = 282449, --rogue Secret Technique
		[27576] = 5374, --rogue mutilate
		
		[233496] = 233490, --warlock Unstable Affliction
		[233497] = 233490, --warlock Unstable Affliction
		[233498] = 233490, --warlock Unstable Affliction
		[233499] = 233490, --warlock Unstable Affliction
		
		[261947] = 261977, --monk fist of the white tiger talent

		[32175] = 17364, -- shaman Stormstrike (from Turkar on github)
		[32176] = 17364, -- shaman Stormstrike
		[45284] = 188196, --shaman lightining bolt overloaded
		
	}
	
	local bitfield_debuffs_ids = _detalhes.BitfieldSwapDebuffsIDs
	local bitfield_debuffs = {}
	for _, spellid in ipairs (bitfield_debuffs_ids) do
		local spellname = GetSpellInfo (spellid)
		if (spellname) then
			bitfield_debuffs [spellname] = true
		else
			bitfield_debuffs [spellid] = true
		end
	end
	
	--expose the override spells table to external scripts
	_detalhes.OverridedSpellIds = override_spellId

	--> list of ignored npcs by the user
	local ignored_npcids = {}
	
	--> ignore soul link (damage from the warlock on his pet - current to demonology only)
	local SPELLID_WARLOCK_SOULLINK = 108446
	--> when checking if can start a new combat, ignore the damage from warlock's burning rush
	local SPELLID_WARLOCK_BURNINGRUSH = 111400
	--> brewmaster monk guard talent
	local SPELLID_MONK_GUARD = 115295
	--> brewmaster monk stagger mechanics
	local SPELLID_MONK_STAGGER = 124255
	--> restoration shaman spirit link totem
	local SPELLID_SHAMAN_SLT = 98021
	--> holy paladin light of the martyr
	local SPELLID_PALADIN_LIGHTMARTYR = 196917
	--> druid kyrian bound spirits
	local SPELLID_KYRIAN_DRUID = 326434
	--> druid kyrian bound damage, heal
	local SPELLID_KYRIAN_DRUID_DAMAGE = 338411
	local SPELLID_KYRIAN_DRUID_HEAL = 327149
	local SPELLID_KYRIAN_DRUID_TANK = 327037

	local SPELLID_SANGUINE_HEAL = 226510

	local SPELLID_BARGAST_DEBUFF = 334695 --REMOVE ON 10.0
	local bargastBuffs = {}

	local SPELLID_NECROMANCER_CHEAT_DEATH = 327676 --REMOVE ON 10.0
	local necro_cheat_deaths = {}

	local SPELLID_VENTYR_TAME_GARGOYLE = 342171 --REMOVE ON 10.0

	--> spells with special treatment
	local special_damage_spells = {
		[SPELLID_SHAMAN_SLT] = true, --> Spirit Link Toten
		[SPELLID_PALADIN_LIGHTMARTYR] = true, --> Light of the Martyr
		[SPELLID_MONK_STAGGER] = true, --> Stagger
		[315161] = true, --> Eye of Corruption --REMOVE ON 9.0
		[315197] = true, --> Thing From Beyond --REMOVE ON 9.0
	}
	
	--> damage spells to ignore
	local damage_spells_to_ignore = {
		--the damage that the warlock apply to its pet through soullink is ignored
		--it is not useful for damage done or friendly fire
		[SPELLID_WARLOCK_SOULLINK] = true,
	}
	
	--> expose the ignore spells table to external scripts
	_detalhes.SpellsToIgnore = damage_spells_to_ignore
	
	--> is parser allowed to replace spellIDs?
		local is_using_spellId_override = false
	
	--> recording data options flags
		local _recording_self_buffs = false
		local _recording_ability_with_buffs = false
		local _recording_healing = false
		local _recording_buffs_and_debuffs = false
		
	--> in combat flag
		local _in_combat = false
		local _current_encounter_id
		local _is_storing_cleu = false
		local _in_resting_zone = false
		
	--> deathlog
		local _death_event_amt = 16
	
	--> map type
		local _is_in_instance = false
	
	--> hooks
		local _hook_cooldowns = false
		local _hook_deaths = false
		local _hook_battleress = false
		local _hook_interrupt = false
		
		local _hook_cooldowns_container = _detalhes.hooks ["HOOK_COOLDOWN"]
		local _hook_deaths_container = _detalhes.hooks ["HOOK_DEATH"]
		local _hook_battleress_container = _detalhes.hooks ["HOOK_BATTLERESS"]
		local _hook_interrupt_container = _detalhes.hooks ["HOOK_INTERRUPT"]
		
	--> encoutner rules
		local ignored_npc_ids = { --deprecated to be removed
			--amorphous cyst g'huun Uldir - ignore damage done to this npcs
			["138185"] = true, --boss room mythic
			["141264"] = true, --trash
			["134034"] = true, --boss room 
			["138323"] = true,
			["141265"] = true,
		}
		
	--> regen overflow
		local auto_regen_power_specs = {
			[103] = Enum.PowerType.Energy, --druid feral
			[259] = Enum.PowerType.Energy, --rogue ass
			[260] = Enum.PowerType.Energy, --rogue outlaw
			[261] = Enum.PowerType.Energy, --rogue sub
			[254] = Enum.PowerType.Focus, --hunter mm
			[253] = Enum.PowerType.Focus, --hunter bm
			[255] = Enum.PowerType.Focus, --hunter survival
			[268] = Enum.PowerType.Energy, --monk brewmaster
			[269] = Enum.PowerType.Energy, --monk windwalker
		}
		local _auto_regen_thread
		local AUTO_REGEN_PRECISION = 2

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

-----------------------------------------------------------------------------------------------------------------------------------------
	--> DAMAGE 	serach key: ~damage											|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:swing (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
		return parser:spell_dmg (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, 1, "Corpo-a-Corpo", 00000001, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand) --> localize-me
																		--spellid, spellname, spelltype
	end

	function parser:range (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
		return parser:spell_dmg (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)  --> localize-me
	end

--	/run local f=CreateFrame("frame");f:RegisterAllEvents();f:SetScript("OnEvent", function(self, ...)print (...);end)
--	/run local f=CreateFrame("frame");f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");f:SetScript("OnEvent", function(self, ...) print (...) end)
--	/run local f=CreateFrame("frame");f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");f:SetScript("OnE
	
--	/run local f=CreateFrame("frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent", function(self, ...)print (...);end)
--	/run local f=CreateFrame("frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent",function(self, ...) local a = select(6, ...);if (a=="<chr name>")then print (...) end end)
--	/run local f=CreateFrame("frame");f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");f:SetScript("OnEvent",function(self, ...) local a = select(3, ...);print (a);if (a=="SPELL_CAST_SUCCESS")then print (...) end end)
	
	local who_aggro = function (self)
		if ((_detalhes.LastPullMsg or 0) + 30 > time()) then
			_detalhes.WhoAggroTimer = nil
			return
		end
		_detalhes.LastPullMsg = time()

		local hitLine = self.HitBy or "|cFFFFBB00First Hit|r: *?*"
		local targetLine = ""
		
		for i = 1, 5 do
			local boss = UnitExists ("boss" .. i)
			if (boss) then
				local target = UnitName ("boss" .. i .. "target")
				if (target and type (target) == "string") then
					targetLine = " |cFFFFBB00Boss First Target|r: " .. target
					break
				end
			end
		end
		
		_detalhes:Msg (hitLine .. targetLine)
		_detalhes.WhoAggroTimer = nil
	end
	
	local lastRecordFound = {id = 0, diff = 0, combatTime = 0}
	
	_detalhes.PrintEncounterRecord = function (self)
		--> this block won't execute if the storage isn't loaded
		--> self is a timer reference from C_Timer
		
		local encounterID = self.Boss
		local diff = self.Diff
		
		if (diff == 15 or diff == 16) then
		
			local value, rank, combatTime = 0, 0, 0
		
			if (encounterID == lastRecordFound.id and diff == lastRecordFound.diff) then
				--> is the same encounter, no need to find the value again.
				value, rank, combatTime = lastRecordFound.value, lastRecordFound.rank, lastRecordFound.combatTime
			else
				local db = _detalhes.GetStorage()
				
				local role = _UnitGroupRolesAssigned ("player")
				local isDamage = (role == "DAMAGER") or (role == "TANK") --or true
				local bestRank, encounterTable = _detalhes.storage:GetBestFromPlayer (diff, encounterID, isDamage and "damage" or "healing", _detalhes.playername, true)
				
				if (bestRank) then
					local playerTable, onEncounter, rankPosition = _detalhes.storage:GetPlayerGuildRank (diff, encounterID, isDamage and "damage" or "healing", _detalhes.playername, true)

					value = bestRank[1] or 0
					rank = rankPosition or 0
					combatTime = encounterTable.elapsed
					
					--> if found the result, cache the values so no need to search again next pull
					lastRecordFound.value = value
					lastRecordFound.rank = rank
					lastRecordFound.id = encounterID
					lastRecordFound.diff = diff
					lastRecordFound.combatTime = combatTime
				else
					--> if didn't found, no reason to search again on next pull
					lastRecordFound.value = 0
					lastRecordFound.rank = 0
					lastRecordFound.combatTime = 0
					lastRecordFound.id = encounterID
					lastRecordFound.diff = diff
				end
			end
			
			_detalhes:Msg ("|cFFFFBB00Your Best Score|r:", _detalhes:ToK2 ((value) / combatTime) .. " [|cFFFFFF00Guild Rank: " .. rank .. "|r]") --> localize-me
			
			if ((not combatTime or combatTime == 0) and not _detalhes.SyncWarning) then
				_detalhes:Msg ("|cFFFF3300you may need sync the rank within the guild, type '|cFFFFFF00/details rank|r'|r") --> localize-me
				_detalhes.SyncWarning = true
			end
		end
		
	end
	
	function parser:spell_dmg (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand, isreflected)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (who_serial == "") then
			if (who_flags and _bit_band (who_flags, OBJECT_TYPE_PETS) ~= 0) then --> � um pet
				--> pets must have a serial
				return
			end
			--who_serial = nil
		end

		if (not alvo_name) then
			--> no target name, just quit
			return
			
		elseif (not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end
		
		--> check if the spell isn't in the backlist
		if (damage_spells_to_ignore [spellid]) then
			return
		end
		
		--check if the target actor isn't in the temp blacklist
		--if (ignore_actors [alvo_serial]) then
		--	return
		--end

		if (spellid == SPELLID_KYRIAN_DRUID_DAMAGE) then
			local ownerTable = druid_kyrian_bounds[who_name]
			if (ownerTable) then
				who_serial, who_name, who_flags = unpack(ownerTable)
			end
		end

		------------------------------------------------------------------------------------------------
		--> spell reflection
		if (who_serial == alvo_serial and not reflection_ignore[spellid]) then --~reflect

			--> this spell could've been reflected, check it
			if (reflection_events[who_serial] and reflection_events[who_serial][spellid] and time-reflection_events[who_serial][spellid].time > 3.5 and (not reflection_debuffs[who_serial] or (reflection_debuffs[who_serial] and not reflection_debuffs[who_serial][spellid]))) then
				--> here we check if we have to filter old reflection data
				--> we check for two conditions
				--> the first is to see if this is an old reflection
				--> if more than 3.5 seconds have past then we can say that it is old... but!
				--> the second condition is to see if there is an active debuff with the same spellid
				--> if there is one then we ignore the timer and skip this
				--> this should be cleared afterwards somehow... don't know how...
				reflection_events[who_serial][spellid] = nil
				if (next(reflection_events[who_serial]) == nil) then
					--> there should be some better way of handling this kind of filtering, any suggestion?
					reflection_events[who_serial] = nil
				end
			end

			local reflection = reflection_events[who_serial] and reflection_events[who_serial][spellid]
			if (reflection) then
				--> if we still have the reflection data then we conclude it was reflected

				--extend the duration of the timer to catch the rare channelling spells
				reflection_events[who_serial][spellid].time = time
				
				--crediting the source of the reflection aura
				who_serial = reflection.who_serial
				who_name = reflection.who_name
				who_flags = reflection.who_flags
				
				--data of the aura that caused the reflection
				--print("2", spellid, GetSpellInfo(spellid))
				isreflected = spellid --which spell was reflected
				spellid = reflection.spellid --which spell made the reflection
				spellname = reflection.spellname
				spelltype = reflection.spelltype
			
				return parser:spell_dmg(token,time,who_serial,who_name,who_flags,alvo_serial,alvo_name,alvo_flags,alvo_flags2,spellid,spellname,0x400,amount,-1,nil,nil,nil,nil,false,false,false,false, isreflected)
			else
				--> saving information about this damage because it may occurred before a reflect event
				reflection_damage[who_serial] = reflection_damage[who_serial] or {}
				reflection_damage[who_serial][spellid] = {
					amount = amount,
					time = time,
				}
			end
		end
		
		--rules of specific encounters


		
		--> if the parser are allowed to replace spellIDs
		if (is_using_spellId_override) then
			spellid = override_spellId [spellid] or spellid
		end
		
		--> npcId check for ignored npcs
			--target
			local npcId = npcid_cache[alvo_serial]
			if (not npcId) then
				npcId = _tonumber(_select (6, _strsplit ("-", alvo_serial)) or 0)
				npcid_cache[alvo_serial] = npcId
			end
			if (ignored_npcids[npcId]) then
				return
			end
			--source
			npcId = npcid_cache[who_serial]
			if (not npcId) then
				npcId = _tonumber(_select (6, _strsplit ("-", who_serial)) or 0)
				npcid_cache[who_serial] = npcId
			end
			if (ignored_npcids[npcId]) then
				return
			end

		--> avoid doing spellID checks on each iteration
		if (special_damage_spells [spellid]) then
			--> stagger
			if (spellid == SPELLID_MONK_STAGGER) then
				return parser:MonkStagger_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
			
			--> spirit link toten
			elseif (spellid == SPELLID_SHAMAN_SLT) then
				return parser:SLT_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
			
			--> Light of the Martyr - paladin spell which causes damage to the caster it self
			elseif (spellid == SPELLID_PALADIN_LIGHTMARTYR) then -- or spellid == 183998 < healing part
				return parser:LOTM_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
			end
		end


		
	------------------------------------------------------------------------------------------------
	--> check if need start an combat
	
		if (not _in_combat) then
			if (	token ~= "SPELL_PERIODIC_DAMAGE" and
				( 
					(who_flags and _bit_band (who_flags, AFFILIATION_GROUP) ~= 0 and _UnitAffectingCombat (who_name) )
					or 
					(alvo_flags and _bit_band (alvo_flags, AFFILIATION_GROUP) ~= 0 and _UnitAffectingCombat (alvo_name) ) 
					or
					(not _detalhes.in_group and who_flags and _bit_band (who_flags, AFFILIATION_GROUP) ~= 0)
				)
			) then 
				--> n�o entra em combate se for DOT
				if (_detalhes.encounter_table.id and _detalhes.encounter_table ["start"] >= _GetTime() - 3 and _detalhes.announce_firsthit.enabled) then
					local link
					if (spellid <= 10) then
						link = _GetSpellInfo (spellid)
					else
						link = GetSpellLink (spellid)
					end
					
					if (_detalhes.WhoAggroTimer) then
						_detalhes.WhoAggroTimer:Cancel()
					end
					_detalhes.WhoAggroTimer = C_Timer.NewTimer (0.5, who_aggro)
					_detalhes.WhoAggroTimer.HitBy = "|cFFFFFF00First Hit|r: " .. (link or "") .. " from " .. (who_name or "Unknown")
				end
				_detalhes:EntrarEmCombate (who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)
			else
				--> entrar em combate se for dot e for do jogador e o ultimo combate ter sido a mais de 10 segundos atr�s
				if (token == "SPELL_PERIODIC_DAMAGE" and who_name == _detalhes.playername) then
					--> ignora burning rush se o jogador estiver fora de combate
					if (spellid == SPELLID_WARLOCK_BURNINGRUSH) then
						return
					end
					--> faz o calculo dos 10 segundos
					if (_detalhes.last_combat_time+10 < _tempo) then
						_detalhes:EntrarEmCombate (who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)
					end
				end
			end
		end
		
		--[[statistics]]-- _detalhes.statistics.damage_calls = _detalhes.statistics.damage_calls + 1
		
		_current_damage_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
	
		--> source damager
		local este_jogador, meu_dono = damage_cache [who_serial] or damage_cache_pets [who_serial] or damage_cache [who_name], damage_cache_petsOwners [who_serial]
		
		if (not este_jogador) then --> pode ser um desconhecido ou um pet

			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
			
			if (meu_dono) then --> � um pet
				if (who_serial ~= "") then
					damage_cache_pets [who_serial] = este_jogador
					damage_cache_petsOwners [who_serial] = meu_dono
				end
				--conferir se o dono j� esta no cache
				if (not damage_cache [meu_dono.serial] and meu_dono.serial ~= "") then
					damage_cache [meu_dono.serial] = meu_dono
				end
			else
				if (who_flags) then --> ter certeza que n�o � um pet
					if (who_serial ~= "") then
						damage_cache [who_serial] = este_jogador
					else
						if (who_name:find ("%[")) then
							damage_cache [who_name] = este_jogador
							local _, _, icon = _GetSpellInfo (spellid or 1)
							este_jogador.spellicon = icon
							--print ("no serial actor", spellname, who_name, "added to cache.")
						else
							--_detalhes:Msg ("Unknown actor with unknown serial ", spellname, who_name)
						end
					end
				end
			end
			
		elseif (meu_dono) then
			--> � um pet
			who_name = who_name .. " <" .. meu_dono.nome .. ">"
		end

		if (not este_jogador) then
			--print ("no ente_jogador")
			--print (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount)
			return
		end
		
		--> his target
		local jogador_alvo, alvo_dono = damage_cache [alvo_serial] or damage_cache_pets [alvo_serial] or damage_cache [alvo_name], damage_cache_petsOwners [alvo_serial]
		
		if (not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_damage_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			
			if (alvo_dono) then
				if (alvo_serial ~= "") then
					damage_cache_pets [alvo_serial] = jogador_alvo
					damage_cache_petsOwners [alvo_serial] = alvo_dono
				end
				--conferir se o dono j� esta no cache
				if (not damage_cache [alvo_dono.serial] and alvo_dono.serial ~= "") then
					damage_cache [alvo_dono.serial] = alvo_dono
				end
			else
				if (alvo_flags and alvo_serial ~= "") then --> ter certeza que n�o � um pet
					damage_cache [alvo_serial] = jogador_alvo
				end
			end
		
		elseif (alvo_dono) then
			--> � um pet
			alvo_name = alvo_name .. " <" .. alvo_dono.nome .. ">"
		
		end

		if (not jogador_alvo) then
			local instanceName, _, _, _, _, _, _, instanceId = GetInstanceInfo()
			Details:Msg("Report 0x885488", alvo_name, instanceName, instanceId, damage_cache[alvo_serial] and "true")
			return
		end
		
		--> last event
		este_jogador.last_event = _tempo
		
	------------------------------------------------------------------------------------------------
	--> group checks and avoidance

		if (absorbed) then
			amount = absorbed + (amount or 0)
		end

		if (_is_in_instance) then
			if (overkill and overkill > 0) then
				--if enabled it'll cut the amount of overkill from the last hit (which killed the actor)
				--when disabled it'll show the total damage done for the latest hit
				--amount = amount - overkill
			end
		end

		if (bargastBuffs[alvo_serial]) then --REMOVE ON 10.0
			local stacks = bargastBuffs[alvo_serial]
			if (stacks) then
				local newDamage = amount / stacks
				amount = newDamage
			end
		end
		
		if (este_jogador.grupo and not este_jogador.arena_enemy and not este_jogador.enemy) then --> source = friendly player and not an enemy player
			--dano to adversario estava caindo aqui por nao estar checando .enemy
			_current_gtotal [1] = _current_gtotal [1]+amount
			
		elseif (jogador_alvo.grupo) then --> source = arena enemy or friendly player

			--> record avoidance only for tank actors
			if (tanks_members_cache [alvo_serial]) then
			
				--> monk's stagger
				if (jogador_alvo.classe == "MONK") then
					if (absorbed) then
						--> the absorbed amount was staggered and should not be count as damage taken now
						--> this absorbed will hit the player with the stagger debuff
						amount = (amount or 0) - absorbed
					end
				else
					--> advanced damage taken
					--if advanced  damage taken is enabled, the damage taken to tanks acts like the monk stuff above
					if (_detalhes.damage_taken_everything) then
						if (absorbed) then
							amount = (amount or 0) - absorbed
						end
					end
				end
				
				--> avoidance
				local avoidance = jogador_alvo.avoidance
				if (not avoidance) then
					jogador_alvo.avoidance = _detalhes:CreateActorAvoidanceTable()
					avoidance = jogador_alvo.avoidance
				end
				
				local overall = avoidance.overall
				
				local mob = avoidance [who_name]
				if (not mob) then --> if isn't in the table, build on the fly
					mob =  _detalhes:CreateActorAvoidanceTable (true)
					avoidance [who_name] = mob
				end				
				
				overall ["ALL"] = overall ["ALL"] + 1  --> qualtipo de hit ou absorb
				mob ["ALL"] = mob ["ALL"] + 1  --> qualtipo de hit ou absorb
				
				if (spellid < 3) then
					--> overall
					overall ["HITS"] = overall ["HITS"] + 1
					mob ["HITS"] = mob ["HITS"] + 1
				end
				
				if (blocked and blocked > 0) then
					overall ["BLOCKED_HITS"] = overall ["BLOCKED_HITS"] + 1
					mob ["BLOCKED_HITS"] = mob ["BLOCKED_HITS"] + 1
					overall ["BLOCKED_AMT"] = overall ["BLOCKED_AMT"] + blocked
					mob ["BLOCKED_AMT"] = mob ["BLOCKED_AMT"] + blocked
					--print (alvo_name, "block", blocked)
				end
				
				--> absorbs status
				if (absorbed) then
					--> aqui pode ser apenas absorb parcial
					overall ["ABSORB"] = overall ["ABSORB"] + 1
					overall ["PARTIAL_ABSORBED"] = overall ["PARTIAL_ABSORBED"] + 1
					overall ["PARTIAL_ABSORB_AMT"] = overall ["PARTIAL_ABSORB_AMT"] + absorbed
					overall ["ABSORB_AMT"] = overall ["ABSORB_AMT"] + absorbed
					mob ["ABSORB"] = mob ["ABSORB"] + 1
					mob ["PARTIAL_ABSORBED"] = mob ["PARTIAL_ABSORBED"] + 1
					mob ["PARTIAL_ABSORB_AMT"] = mob ["PARTIAL_ABSORB_AMT"] + absorbed
					mob ["ABSORB_AMT"] = mob ["ABSORB_AMT"] + absorbed
				else
					--> adicionar aos hits sem absorbs
					overall ["FULL_HIT"] = overall ["FULL_HIT"] + 1
					overall ["FULL_HIT_AMT"] = overall ["FULL_HIT_AMT"] + amount
					mob ["FULL_HIT"] = mob ["FULL_HIT"] + 1
					mob ["FULL_HIT_AMT"] = mob ["FULL_HIT_AMT"] + amount
				end
			end
			
			--> record death log
			local t = last_events_cache [alvo_name]
			
			if (not t) then
				t = _current_combat:CreateLastEventsTable (alvo_name)
			end

			if (not necro_cheat_deaths[alvo_serial]) then --remove on 10.0
				local i = t.n
				
				local this_event = t [i]
				this_event [1] = true --> true if this is a damage || false for healing
				this_event [2] = spellid --> spellid || false if this is a battle ress line
				this_event [3] = amount --> amount of damage or healing
				this_event [4] = time --> parser time

				--> current unit heal
				if (arena_enemies[alvo_name]) then
					--this is an arena enemy, get the heal with the unit Id
					this_event [5] = _UnitHealth(_detalhes.arena_enemies[alvo_name]) 
				else
					this_event [5] = _UnitHealth(alvo_name)
				end

				this_event [6] = who_name --> source name
				this_event [7] = absorbed
				this_event [8] = spelltype or school
				this_event [9] = false
				this_event [10] = overkill
				
				i = i + 1
				
				if (i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> time start

		if (not este_jogador.dps_started) then
		
			este_jogador:Iniciar (true) --registra na timemachine
			
			if (meu_dono and not meu_dono.dps_started) then
				meu_dono:Iniciar (true)
				if (meu_dono.end_time) then
					meu_dono.end_time = nil
				else
					--meu_dono:IniciarTempo (_tempo)
					meu_dono.start_time = _tempo
				end
			end
			
			if (este_jogador.end_time) then
				este_jogador.end_time = nil
			else
				--este_jogador:IniciarTempo (_tempo)
				este_jogador.start_time = _tempo
			end

			if (este_jogador.nome == _detalhes.playername and token ~= "SPELL_PERIODIC_DAMAGE") then --> iniciando o dps do "PLAYER"
				if (_detalhes.solo) then
					--> save solo attributes
					_detalhes:UpdateSolo()
				end

				if (_UnitAffectingCombat ("player")) then
					_detalhes:SendEvent ("COMBAT_PLAYER_TIMESTARTED", nil, _current_combat, este_jogador)
				end
			end
		end
	
	------------------------------------------------------------------------------------------------
	--> firendly fire ~friendlyfire
		local is_friendly_fire = false
		
		if (_is_in_instance) then
			if (bitfield_swap_cache [who_serial] or meu_dono and bitfield_swap_cache [meu_dono.serial]) then
				if (jogador_alvo.grupo or alvo_dono and alvo_dono.grupo) then
					is_friendly_fire = true
				end
			else
				if (bitfield_swap_cache [alvo_serial] or alvo_dono and bitfield_swap_cache [alvo_dono.serial]) then
				else
					if ((jogador_alvo.grupo or alvo_dono and alvo_dono.grupo) and (este_jogador.grupo or meu_dono and meu_dono.grupo)) then
						is_friendly_fire = true
					end
				end
			end
		else
			if (
				(_bit_band (alvo_flags, REACTION_FRIENDLY) ~= 0 and _bit_band (who_flags, REACTION_FRIENDLY) ~= 0) or --ajdt d' brx
				(raid_members_cache [alvo_serial] and raid_members_cache [who_serial] and alvo_serial:find ("Player") and who_serial:find ("Player")) --amrl
			) then
				is_friendly_fire = true
			end
		end
		
		if (is_friendly_fire and spellid ~= SPELLID_KYRIAN_DRUID_TANK) then
			if (este_jogador.grupo) then --> se tiver ele n�o adiciona o evento l� em cima
				local t = last_events_cache [alvo_name]
				
				if (not t) then
					t = _current_combat:CreateLastEventsTable (alvo_name)
				end
				
				local i = t.n

				local this_event = t [i]
				
				this_event [1] = true --> true if this is a damage || false for healing
				this_event [2] = spellid --> spellid || false if this is a battle ress line
				this_event [3] = amount --> amount of damage or healing
				this_event [4] = time --> parser time
				this_event [5] = _UnitHealth (alvo_name) --> current unit heal
				this_event [6] = who_name --> source name
				this_event [7] = absorbed
				this_event [8] = spelltype or school
				this_event [9] = true
				this_event [10] = overkill
				i = i + 1
				
				if (i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end
			end

			este_jogador.friendlyfire_total = este_jogador.friendlyfire_total + amount
			
			local friend = este_jogador.friendlyfire [alvo_name] or este_jogador:CreateFFTable (alvo_name)

			friend.total = friend.total + amount
			friend.spells [spellid] = (friend.spells [spellid] or 0) + amount
			
			------------------------------------------------------------------------------------------------
			--> damage taken 

				--> target
				jogador_alvo.damage_taken = jogador_alvo.damage_taken + amount - (absorbed or 0) --> adiciona o dano tomado
				if (not jogador_alvo.damage_from [who_name]) then --> adiciona a pool de dano tomado de quem
					jogador_alvo.damage_from [who_name] = true
				end

			return true
		else
			_current_total [1] = _current_total [1]+amount
			
			------------------------------------------------------------------------------------------------
			--> damage taken 

				--> target
				jogador_alvo.damage_taken = jogador_alvo.damage_taken + amount --> adiciona o dano tomado
				if (not jogador_alvo.damage_from [who_name]) then --> adiciona a pool de dano tomado de quem
					jogador_alvo.damage_from [who_name] = true
				end
		end
		
	------------------------------------------------------------------------------------------------
	--> amount add

		--> actor owner (if any)
		if (meu_dono) then --> se for dano de um Pet
			meu_dono.total = meu_dono.total + amount --> e adiciona o dano ao pet
			
			--> add owner targets
			meu_dono.targets [alvo_name] = (meu_dono.targets [alvo_name] or 0) + amount

			meu_dono.last_event = _tempo
			
			if (RAID_TARGET_FLAGS [alvo_flags2]) then
				--> add the amount done for the owner
				meu_dono.raid_targets [alvo_flags2] = (meu_dono.raid_targets [alvo_flags2] or 0) + amount
			end
		end
		
		--> raid targets
		if (RAID_TARGET_FLAGS [alvo_flags2]) then
			este_jogador.raid_targets [alvo_flags2] = (este_jogador.raid_targets [alvo_flags2] or 0) + amount
		end
		
		--> actor
		este_jogador.total = este_jogador.total + amount
		
		--> actor without pets
		este_jogador.total_without_pet = este_jogador.total_without_pet + amount
		
		--> actor targets
		este_jogador.targets [alvo_name] = (este_jogador.targets [alvo_name] or 0) + amount
		
		--> actor spells table
		local spell = este_jogador.spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
			spell.spellschool = spelltype or school
			if (_current_combat.is_boss and who_flags and _bit_band (who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
				_detalhes.spell_school_cache [spellname] = spelltype or school
			end

			if (isreflected) then
				spell.isReflection = true
			end
		end
		
		if (_is_storing_cleu) then
			_current_combat_cleu_events [_current_combat_cleu_events.n] = {_tempo, _token_ids [token] or 0, who_name, alvo_name or "", spellid, amount}
			_current_combat_cleu_events.n = _current_combat_cleu_events.n + 1
		end
		
		return spell_damage_func (spell, alvo_serial, alvo_name, alvo_flags, amount, who_name, resisted, blocked, absorbed, critical, glacing, token, isoffhand, isreflected)
	end

	
	function parser:MonkStagger_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
		--> special behavior for monk stagger debuff periodic damage
		
		
		--> tag the container to refresh
			_current_damage_container.need_refresh = true
		
		--> get the monk damage object
			local este_jogador, meu_dono = damage_cache [who_serial] or damage_cache_pets [who_serial] or damage_cache [who_name], damage_cache_petsOwners [who_serial]
			
			if (not este_jogador) then --> pode ser um desconhecido ou um pet
				este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
				if (meu_dono) then --> � um pet
					if (who_serial ~= "") then
						damage_cache_pets [who_serial] = este_jogador
						damage_cache_petsOwners [who_serial] = meu_dono
					end
					--conferir se o dono j� esta no cache
					if (not damage_cache [meu_dono.serial] and meu_dono.serial ~= "") then
						damage_cache [meu_dono.serial] = meu_dono
					end
				else
					if (who_flags) then --> ter certeza que n�o � um pet
						if (who_serial ~= "") then
							damage_cache [who_serial] = este_jogador
						else
							if (who_name:find ("%[")) then
								damage_cache [who_name] = este_jogador
								local _, _, icon = _GetSpellInfo (spellid or 1)
								este_jogador.spellicon = icon
							end
						end
					end
				end
				
			elseif (meu_dono) then
				--> � um pet
				who_name = who_name .. " <" .. meu_dono.nome .. ">"
			end
		
		--> last event
			este_jogador.last_event = _tempo
		
		--> amount
			amount = (amount or 0)
			local total_amount = amount + (absorbed or 0)
			
		--> damage taken
			este_jogador.damage_taken = este_jogador.damage_taken + amount
			if (not este_jogador.damage_from [who_name]) then --> adiciona a pool de dano tomado de quem
				este_jogador.damage_from [who_name] = true
			end
			
		--> friendly fire
			--total
			este_jogador.friendlyfire_total = este_jogador.friendlyfire_total + amount
			--from who
			local friend = este_jogador.friendlyfire [who_name] or este_jogador:CreateFFTable (who_name)
			friend.total = friend.total + amount
			friend.spells [spellid] = (friend.spells [spellid] or 0) + amount

		--> record death log
			local t = last_events_cache [who_name]
			
			if (not t) then
				t = _current_combat:CreateLastEventsTable (who_name)
			end
			
			local i = t.n
			
			local this_event = t [i]
			
			if (not this_event) then
				return print ("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
			end
			
			this_event [1] = true --> true if this is a damage || false for healing
			this_event [2] = spellid --> spellid || false if this is a battle ress line
			this_event [3] = amount --> amount of damage or healing
			this_event [4] = time --> parser time
			this_event [5] = _UnitHealth (who_name) --> current unit heal
			this_event [6] = who_name --> source name
			this_event [7] = absorbed
			this_event [8] = school
			this_event [9] = true --> friendly fire
			this_event [10] = overkill
			
			i = i + 1
			
			if (i == _death_event_amt+1) then
				t.n = 1
			else
				t.n = i
			end			
			
		--> avoidance
			local avoidance = este_jogador.avoidance
			if (not avoidance) then
				este_jogador.avoidance = _detalhes:CreateActorAvoidanceTable()
				avoidance = este_jogador.avoidance
			end
			
			local overall = avoidance.overall
			
			local mob = avoidance [who_name]
			if (not mob) then --> if isn't in the table, build on the fly
				mob =  _detalhes:CreateActorAvoidanceTable (true)
				avoidance [who_name] = mob
			end				
			
			overall ["ALL"] = overall ["ALL"] + 1  --> qualtipo de hit ou absorb
			mob ["ALL"] = mob ["ALL"] + 1  --> qualtipo de hit ou absorb
			
			if (blocked and blocked > 0) then
				overall ["BLOCKED_HITS"] = overall ["BLOCKED_HITS"] + 1
				mob ["BLOCKED_HITS"] = mob ["BLOCKED_HITS"] + 1
				overall ["BLOCKED_AMT"] = overall ["BLOCKED_AMT"] + blocked
				mob ["BLOCKED_AMT"] = mob ["BLOCKED_AMT"] + blocked
			end
			
			--> absorbs status
			if (absorbed) then
				--> aqui pode ser apenas absorb parcial
				overall ["ABSORB"] = overall ["ABSORB"] + 1
				overall ["PARTIAL_ABSORBED"] = overall ["PARTIAL_ABSORBED"] + 1
				overall ["PARTIAL_ABSORB_AMT"] = overall ["PARTIAL_ABSORB_AMT"] + absorbed
				overall ["ABSORB_AMT"] = overall ["ABSORB_AMT"] + absorbed
				mob ["ABSORB"] = mob ["ABSORB"] + 1
				mob ["PARTIAL_ABSORBED"] = mob ["PARTIAL_ABSORBED"] + 1
				mob ["PARTIAL_ABSORB_AMT"] = mob ["PARTIAL_ABSORB_AMT"] + absorbed
				mob ["ABSORB_AMT"] = mob ["ABSORB_AMT"] + absorbed
			else
				--> adicionar aos hits sem absorbs
				overall ["FULL_HIT"] = overall ["FULL_HIT"] + 1
				overall ["FULL_HIT_AMT"] = overall ["FULL_HIT_AMT"] + amount
				mob ["FULL_HIT"] = mob ["FULL_HIT"] + 1
				mob ["FULL_HIT_AMT"] = mob ["FULL_HIT_AMT"] + amount
			end
		
	end
	
	--special rule for LOTM
	function parser:LOTM_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
	
		if (absorbed) then
			amount = absorbed + (amount or 0)
		end
	
		local healingActor = healing_cache [who_serial]
		if (healingActor and healingActor.spells) then
			healingActor.total = healingActor.total - (amount or 0)
			
			local spellTable = healingActor.spells:GetSpell (183998)
			if (spellTable) then
				spellTable.anti_heal = (spellTable.anti_heal or 0) + amount
			end
		end
		
		local t = last_events_cache [who_name]
		
		if (not t) then
			t = _current_combat:CreateLastEventsTable (who_name)
		end
		
		local i = t.n
		
		local this_event = t [i]
		
		if (not this_event) then
			return print ("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
		end
		
		this_event [1] = true --> true if this is a damage || false for healing
		this_event [2] = spellid --> spellid || false if this is a battle ress line
		this_event [3] = amount --> amount of damage or healing
		this_event [4] = time --> parser time
		this_event [5] = _UnitHealth (who_name) --> current unit heal
		this_event [6] = who_name --> source name
		this_event [7] = absorbed
		this_event [8] = school
		this_event [9] = true --> friendly fire
		this_event [10] = overkill
		
		i = i + 1
		
		if (i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end	
		
		local damageActor = damage_cache [who_serial]
		if (damageActor) then
			--damage taken
			damageActor.damage_taken = damageActor.damage_taken + amount
			if (not damageActor.damage_from [who_name]) then --> adiciona a pool de dano tomado de quem
				damageActor.damage_from [who_name] = true
			end
			
			--friendly fire
			damageActor.friendlyfire_total = damageActor.friendlyfire_total + amount
			local friend = damageActor.friendlyfire [who_name] or damageActor:CreateFFTable (who_name)
			friend.total = friend.total + amount
			friend.spells [spellid] = (friend.spells [spellid] or 0) + amount
		end
	end
	
	--special rule of SLT
	function parser:SLT_damage (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand)
		
		--> damager
		local este_jogador, meu_dono = damage_cache [who_serial] or damage_cache_pets [who_serial] or damage_cache [who_name], damage_cache_petsOwners [who_serial]
		
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
		
			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
			
			if (meu_dono) then --> � um pet
				if (who_serial ~= "") then
					damage_cache_pets [who_serial] = este_jogador
					damage_cache_petsOwners [who_serial] = meu_dono
				end
				--conferir se o dono j� esta no cache
				if (not damage_cache [meu_dono.serial] and meu_dono.serial ~= "") then
					damage_cache [meu_dono.serial] = meu_dono
				end
			else
				if (who_flags) then --> ter certeza que n�o � um pet
					if (who_serial ~= "") then
						damage_cache [who_serial] = este_jogador
					else
						if (who_name:find ("%[")) then
							damage_cache [who_name] = este_jogador
							local _, _, icon = _GetSpellInfo (spellid or 1)
							este_jogador.spellicon = icon
							--print ("no serial actor", spellname, who_name, "added to cache.")
						else
							--_detalhes:Msg ("Unknown actor with unknown serial ", spellname, who_name)
						end
					end
				end
			end
			
		elseif (meu_dono) then
			--> � um pet
			who_name = who_name .. " <" .. meu_dono.nome .. ">"
		end
		
		--> his target
		local jogador_alvo, alvo_dono = damage_cache [alvo_serial] or damage_cache_pets [alvo_serial] or damage_cache [alvo_name], damage_cache_petsOwners [alvo_serial]
		
		if (not jogador_alvo) then
		
			jogador_alvo, alvo_dono, alvo_name = _current_damage_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			
			if (alvo_dono) then
				if (alvo_serial ~= "") then
					damage_cache_pets [alvo_serial] = jogador_alvo
					damage_cache_petsOwners [alvo_serial] = alvo_dono
				end
				--conferir se o dono j� esta no cache
				if (not damage_cache [alvo_dono.serial] and alvo_dono.serial ~= "") then
					damage_cache [alvo_dono.serial] = alvo_dono
				end
			else
				if (alvo_flags and alvo_serial ~= "") then --> ter certeza que n�o � um pet
					damage_cache [alvo_serial] = jogador_alvo
				end
			end
		
		elseif (alvo_dono) then
			--> � um pet
			alvo_name = alvo_name .. " <" .. alvo_dono.nome .. ">"
		end
		
		--> last event
		este_jogador.last_event = _tempo
		
		--> record death log
		local t = last_events_cache [alvo_name]
		
		if (not t) then
			t = _current_combat:CreateLastEventsTable (alvo_name)
		end
		
		local i = t.n
		
		local this_event = t [i]
		
		if (not this_event) then
			return print ("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
		end
		
		this_event [1] = true --> true if this is a damage || false for healing
		this_event [2] = spellid --> spellid || false if this is a battle ress line
		this_event [3] = amount --> amount of damage or healing
		this_event [4] = time --> parser time
		this_event [5] = _UnitHealth (alvo_name) --> current unit heal
		this_event [6] = who_name --> source name
		this_event [7] = absorbed
		this_event [8] = spelltype or school
		this_event [9] = false
		this_event [10] = overkill
		
		i = i + 1
		
		if (i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end
		
	end

	--extra attacks
	function parser:spell_dmg_extra_attacks(token, time, who_serial, who_name, who_flags, _, _, _, _, spellid, spellName, spelltype, arg1)
		local este_jogador = damage_cache [who_serial]
		if (not este_jogador) then
			local meu_dono
			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not este_jogador) then
				return --> just return if actor doen't exist yet
			end
		end

--/dump Details:GetCurrentCombat():GetPlayer("Hetdor").spells:GetSpell(1).extra["extra_attack"]

		--> actor spells table
		local spell = este_jogador.spells._ActorTable[1] --melee damage
		if (not spell) then
			return
		end

		spell.extra["extra_attack"] = (spell.extra["extra_attack"] or 0) + 1
	end
	
	--function parser:swingmissed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, missType, isOffHand, amountMissed)
	function parser:swingmissed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, missType, isOffHand, amountMissed) --, isOffHand, amountMissed, arg1
		return parser:missed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, 1, "Corpo-a-Corpo", 00000001, missType, isOffHand, amountMissed) --, isOffHand, amountMissed, arg1
	end

	function parser:rangemissed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, missType, isOffHand, amountMissed) --, isOffHand, amountMissed, arg1
		return parser:missed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, 2, "Tiro-Autom�tico", 00000001, missType, isOffHand, amountMissed) --, isOffHand, amountMissed, arg1
	end

	-- ~miss
	function parser:missed (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, missType, isOffHand, amountMissed, arg1, arg2, arg3)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (not alvo_name) then
			--> no target name, just quit
			return
			
		elseif (not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end
	
	------------------------------------------------------------------------------------------------
	--> get actors
		--print ("MISS", "|", missType, "|", isOffHand, "|", amountMissed, "|", arg1)
		
	
		--print (missType, who_name,  spellname, amountMissed)
		
		
		--> 'misser'
		local este_jogador = damage_cache [who_serial]
		if (not este_jogador) then
			--este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (nil, who_name)
			local meu_dono
			este_jogador, meu_dono, who_name = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not este_jogador) then
				return --> just return if actor doen't exist yet
			end
		end
		
		este_jogador.last_event = _tempo

		if (tanks_members_cache [alvo_serial]) then --> only track tanks
		
			local TargetActor = damage_cache [alvo_serial]
			if (TargetActor) then
			
				local avoidance = TargetActor.avoidance
				
				if (not avoidance) then
					TargetActor.avoidance = _detalhes:CreateActorAvoidanceTable()
					avoidance = TargetActor.avoidance
				end

				local missTable = avoidance.overall [missType]
				
				if (missTable) then
					--> overall
					local overall = avoidance.overall
					overall [missType] = missTable + 1 --> adicionado a quantidade do miss

					--> from this mob
					local mob = avoidance [who_name]
					if (not mob) then --> if isn't in the table, build on the fly
						mob = _detalhes:CreateActorAvoidanceTable (true)
						avoidance [who_name] = mob
					end
					
					mob [missType] = mob [missType] + 1
					
					if (missType == "ABSORB") then --full absorb
						overall ["ALL"] = overall ["ALL"] + 1 --> qualtipo de hit ou absorb
						overall ["FULL_ABSORBED"] = overall ["FULL_ABSORBED"] + 1 --amount
						overall ["ABSORB_AMT"] = overall ["ABSORB_AMT"] + (amountMissed or 0)
						overall ["FULL_ABSORB_AMT"] = overall ["FULL_ABSORB_AMT"] + (amountMissed or 0)
						
						mob ["ALL"] = mob ["ALL"] + 1  --> qualtipo de hit ou absorb
						mob ["FULL_ABSORBED"] = mob ["FULL_ABSORBED"] + 1 --amount
						mob ["ABSORB_AMT"] = mob ["ABSORB_AMT"] + (amountMissed or 0)
						mob ["FULL_ABSORB_AMT"] = mob ["FULL_ABSORB_AMT"] + (amountMissed or 0)
					end
					
				end

			end
		end
		
	------------------------------------------------------------------------------------------------
	--> amount add
		
		if (missType == "ABSORB") then
		
			if (token == "SWING_MISSED") then
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:swing ("SWING_DAMAGE", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)
				
			elseif (token == "RANGE_MISSED") then
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:range ("RANGE_DAMAGE", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)
				
			else
				este_jogador.totalabsorbed = este_jogador.totalabsorbed + amountMissed
				return parser:spell_dmg (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amountMissed, -1, 1, nil, nil, nil, false, false, false, false)
				
			end
		
	------------------------------------------------------------------------------------------------
	--> spell reflection
		elseif (missType == "REFLECT" and reflection_auras[alvo_serial]) then --~reflect
			--> a reflect event and we have the reflecting aura data
			if (reflection_damage[who_serial] and reflection_damage[who_serial][spellid] and time-reflection_damage[who_serial][spellid].time > 3.5 and (not reflection_debuffs[who_serial] or (reflection_debuffs[who_serial] and not reflection_debuffs[who_serial][spellid]))) then
				--> here we check if we have to filter old damage data
				--> we check for two conditions
				--> the first is to see if this is an old damage
				--> if more than 3.5 seconds have past then we can say that it is old... but!
				--> the second condition is to see if there is an active debuff with the same spellid
				--> if there is one then we ignore the timer and skip this
				--> this should be cleared afterwards somehow... don't know how...
				reflection_damage[who_serial][spellid] = nil
				if (next(reflection_damage[who_serial]) == nil) then
					--> there should be some better way of handling this kind of filtering, any suggestion?
					reflection_damage[who_serial] = nil
				end
			end
			local damage = reflection_damage[who_serial] and reflection_damage[who_serial][spellid]
			local reflection = reflection_auras[alvo_serial]
			if (damage) then
				--> damage ocurred first, so we have its data
				local amount = reflection_damage[who_serial][spellid].amount
				
				--print("1", spellid, GetSpellInfo(spellid))
				local isreflected = spellid --which spell was reflected
				alvo_serial = reflection.who_serial
				alvo_name = reflection.who_name
				alvo_flags = reflection.who_flags
				spellid = reflection.spellid
				spellname = reflection.spellname
				spelltype = reflection.spelltype
				--> crediting the source of the aura that caused the reflection
				--> also saying that the damage came from the aura that reflected the spell
				
				reflection_damage[who_serial][spellid] = nil
				if next(reflection_damage[who_serial]) == nil then
					--> this is so bad at clearing, there should be a better way of handling this
					reflection_damage[who_serial] = nil
				end

				return parser:spell_dmg(token,time,alvo_serial,alvo_name,alvo_flags,who_serial,who_name,who_flags,nil,spellid,spellname,spelltype,amount,-1,nil,nil,nil,nil,false,false,false,false, isreflected)
			else
				--> saving information about this reflect because it occurred before the damage event
				reflection_events[who_serial] = reflection_events[who_serial] or {}
				reflection_events[who_serial][spellid] = reflection
				reflection_events[who_serial][spellid].time = time
			end

		else
			--colocando aqui apenas pois ele confere o override dentro do damage
			if (is_using_spellId_override) then
				spellid = override_spellId [spellid] or spellid
			end
		
			--> actor spells table
			local spell = este_jogador.spells._ActorTable [spellid]
			if (not spell) then
				spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
				spell.spellschool = spelltype
				if (_current_combat.is_boss and who_flags and _bit_band (who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
					_detalhes.spell_school_cache [spellname] = spelltype
				end
			end
			return spell_damageMiss_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, missType)		
		end
		

	end
	
-----------------------------------------------------------------------------------------------------------------------------------------
	--> SUMMON 	serach key: ~summon										|
-----------------------------------------------------------------------------------------------------------------------------------------
	function parser:summon (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellName)
	
		--[[statistics]]-- _detalhes.statistics.pets_summons = _detalhes.statistics.pets_summons + 1

		if (not _detalhes.capture_real ["damage"] and not _detalhes.capture_real ["heal"]) then
			return
		end
		
		if (not who_name) then
			who_name = "[*] " .. spellName
		end
	
		--> pet summon another pet
		local sou_pet = container_pets [who_serial]
		if (sou_pet) then --> okey, ja � um pet
			who_name, who_serial, who_flags = sou_pet[1], sou_pet[2], sou_pet[3]
		end
		
		local alvo_pet = container_pets [alvo_serial]
		if (alvo_pet) then
			who_name, who_serial, who_flags = alvo_pet[1], alvo_pet[2], alvo_pet[3]
		end
		
		--petTable:Add
		_detalhes.tabela_pets:Adicionar (alvo_serial, alvo_name, alvo_flags, who_serial, who_name, who_flags)

		--debug summons:
		--print("summon:", who_name, alvo_serial, alvo_name, alvo_flags, spellid, spellName)
		return
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> HEALING 	serach key: ~healing											|
-----------------------------------------------------------------------------------------------------------------------------------------

	local ignored_shields = {
		[142862] = true, -- Ancient Barrier (Malkorok)
		[114556] = true, -- Purgatory (DK)
		[115069] = true, -- Stance of the Sturdy Ox (Monk)
		[20711] = true, -- Spirit of Redemption (Priest)
		[184553]  = true, --Soul Capacitor
	}
	
	local ignored_overheal = { --during refresh, some shield does not replace the old value for the new one
		[47753] = true, -- Divine Aegis
		[86273] = true, -- Illuminated Healing
		[114908] = true, --Spirit Shell
		[152118] = true, --Clarity of Will
	}
	
	function parser:heal_denied (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellidAbsorb, spellnameAbsorb, spellschoolAbsorb, serialHealer, nameHealer, flagsHealer, flags2Healer, spellidHeal, spellnameHeal, typeHeal, amountDenied)
	
	--	print (who_name, alvo_name, nameHealer, spellidHeal, spellnameHeal, typeHeal, amountDenied)
		if (not _in_combat) then
			return
		end
	
		--> check invalid serial against pets
		if (who_serial == "") then
			if (who_flags and _bit_band (who_flags, OBJECT_TYPE_PETS) ~= 0) then --> � um pet
				return
			end
		end

		--> no name, use spellname
		if (not who_name) then
			if (not spellname) then
				--print ("ERROR:", token, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellidAbsorb, spellnameAbsorb, spellschoolAbsorb, serialHealer, nameHealer, flagsHealer, flags2Healer, spellidHeal, spellnameHeal, typeHeal, amountDenied)
			end
			--who_name = "[*] "..spellname
			who_name = "[*] " .. (spellname or "--unknown spell--")
		end
		
		--> no target, just ignore
		if (not alvo_name) then
			return
		end
		
		--> if no spellid
		if (not spellidAbsorb) then
			spellidAbsorb = 1
			spellnameAbsorb = "unknown"
			spellschoolAbsorb = 1
		end
		
		if (is_using_spellId_override) then
			spellidAbsorb = override_spellId [spellidAbsorb] or spellidAbsorb
			spellidHeal = override_spellId [spellidHeal] or spellidHeal
		end
		
	------------------------------------------------------------------------------------------------
	--> get actors

		local este_jogador, meu_dono = healing_cache [who_serial]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_heal_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono and who_flags and who_serial ~= "") then --> se n�o for um pet, adicionar no cache
				healing_cache [who_serial] = este_jogador
			end
		end
		
		local jogador_alvo, alvo_dono = healing_cache [alvo_serial]
		if (not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_heal_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			if (not alvo_dono and alvo_flags and also_serial ~= "") then
				healing_cache [alvo_serial] = jogador_alvo
			end
		end
		
		este_jogador.last_event = _tempo

		------------------------------------------------
		
		este_jogador.totaldenied = este_jogador.totaldenied + amountDenied

		--> actor spells table
		local spell = este_jogador.spells._ActorTable [spellidAbsorb]
		if (not spell) then
			spell = este_jogador.spells:PegaHabilidade (spellidAbsorb, true, token)
			if (_current_combat.is_boss and who_flags and _bit_band (who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
				_detalhes.spell_school_cache [spellnameAbsorb] = spellschoolAbsorb or 1
			end
		end
		
		--return spell:Add (alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, absorbed, critical, overhealing)
		return spell_heal_func (spell, alvo_serial, alvo_name, alvo_flags, amountDenied, spellidHeal, token, nameHealer, overhealing)

	end
	
	function parser:heal_absorb (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, owner_serial, owner_name, owner_flags, owner_flags2, shieldid, shieldname, shieldtype, amount)
		--[[statistics]]-- _detalhes.statistics.absorbs_calls = _detalhes.statistics.absorbs_calls + 1
		
		if (_type(shieldname) == "boolean") then
			owner_serial, owner_name, owner_flags, owner_flags2, shieldid, shieldname, shieldtype, amount = spellid, spellname, spellschool, owner_serial, owner_name, owner_flags, owner_flags2, shieldid
		end
	
		if (ignored_shields [shieldid]) then
			return
		
		elseif (shieldid == 110913) then
			--dark bargain
			local max_health = _UnitHealthMax (owner_name)
			if ((amount or 0) > (max_health or 1) * 4) then
				return
			end
		end
		
		--> diminuir o escudo nas tabelas de escudos
		local shields_on_target = escudo [alvo_name]
		if (shields_on_target) then
			local shields_by_spell = shields_on_target [shieldid]
			if (shields_by_spell) then
				local owner_shield = shields_by_spell [owner_name]
				if (owner_shield) then
					shields_by_spell [owner_name] = owner_shield - amount
				end
			end
		end
		
		--> chamar a fun��o de cura pra contar a cura
		return parser:heal (token, time, owner_serial, owner_name, owner_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, shieldid, shieldname, shieldtype, amount, 0, 0, nil, true)
		
	end

	function parser:heal (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
	
		--> only capture heal if is in combat
		if (not _in_combat) then
			if (not _in_resting_zone) then
				return
			end
		end
	
		--> check invalid serial against pets
		if (who_serial == "") then
			if (who_flags and _bit_band (who_flags, OBJECT_TYPE_PETS) ~= 0) then --> � um pet
				return
			end
			--who_serial = nil
		end

		--> no name, use spellname
		if (not who_name) then
			--who_name = "[*] " .. (spellname or "--unknown spell--")
			who_name = "[*] "..spellname
		end

		--> no target, just ignore
		if (not alvo_name) then
			return
		end

		--> check for banned spells
		if (banned_healing_spells[spellid]) then
			return
		end
		
		--> spirit link toten
		if (spellid == SPELLID_SHAMAN_SLT) then
			return parser:SLT_healing (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)
		end
		
		if (is_using_spellId_override) then
			spellid = override_spellId [spellid] or spellid
		end

		--sanguine ichor mythic dungeon affix (heal enemies)
		if (spellid == SPELLID_SANGUINE_HEAL) then 
			who_name = GetSpellInfo(SPELLID_SANGUINE_HEAL)
			who_flags = 0x518
			who_serial = "Creature-0-3134-2289-28065-" .. SPELLID_SANGUINE_HEAL .. "-000164C698"
		end
		
		--[[statistics]]-- _detalhes.statistics.heal_calls = _detalhes.statistics.heal_calls + 1
		
		local cura_efetiva = absorbed
		if (is_shield) then 
			--> o shield ja passa o numero exato da cura e o overheal
			cura_efetiva = amount
		else
			--cura_efetiva = absorbed + amount - overhealing
			cura_efetiva = cura_efetiva + amount - overhealing
		end
		
		_current_heal_container.need_refresh = true
	
		if (spellid == SPELLID_KYRIAN_DRUID_HEAL) then
			local ownerTable = druid_kyrian_bounds[who_name]
			if (ownerTable) then
				who_serial, who_name, who_flags = unpack(ownerTable)
			end
		end

	------------------------------------------------------------------------------------------------
	--> get actors

		local este_jogador, meu_dono = healing_cache [who_serial]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_heal_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono and who_flags and who_serial ~= "") then --> se n�o for um pet, adicionar no cache
				healing_cache [who_serial] = este_jogador
			end
		end

		local jogador_alvo, alvo_dono = healing_cache [alvo_serial]
		if (not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_heal_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			if (not alvo_dono and alvo_flags and alvo_serial ~= "") then
				healing_cache [alvo_serial] = jogador_alvo
			end
		end
		
		este_jogador.last_event = _tempo


	------------------------------------------------------------------------------------------------
	--> an enemy healing enemy or an player actor healing a enemy

		if (spellid == SPELLID_SANGUINE_HEAL) then --sanguine ichor (heal enemies)
			este_jogador.grupo = true

		elseif (_bit_band (alvo_flags, REACTION_FRIENDLY) == 0 and not _detalhes.is_in_arena and not _detalhes.is_in_battleground) then
			if (not este_jogador.heal_enemy [spellid]) then 
				este_jogador.heal_enemy [spellid] = cura_efetiva
			else
				este_jogador.heal_enemy [spellid] = este_jogador.heal_enemy [spellid] + cura_efetiva
			end
			
			este_jogador.heal_enemy_amt = este_jogador.heal_enemy_amt + cura_efetiva
			
			return
		end	
		
	------------------------------------------------------------------------------------------------
	--> group checks

		if (este_jogador.grupo) then 
			--_current_combat.totals_grupo[2] = _current_combat.totals_grupo[2] + cura_efetiva
			_current_gtotal [2] = _current_gtotal [2] + cura_efetiva
		end
		
		if (jogador_alvo.grupo) then
			if (not necro_cheat_deaths[alvo_serial]) then --remove on 10.0
				local t = last_events_cache [alvo_name]
				
				if (not t) then
					t = _current_combat:CreateLastEventsTable (alvo_name)
				end
				
				local i = t.n
				
				local this_event = t [i]
				
				this_event [1] = false --> true if this is a damage || false for healing
				this_event [2] = spellid --> spellid || false if this is a battle ress line
				this_event [3] = amount --> amount of damage or healing
				this_event [4] = time --> parser time
				this_event [5] = _UnitHealth (alvo_name) --> current unit heal
				this_event [6] = who_name --> source name
				this_event [7] = is_shield
				this_event [8] = absorbed
				
				i = i + 1
				
				if (i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end
			end
			
		end

	------------------------------------------------------------------------------------------------
	--> timer
		
		if (not este_jogador.iniciar_hps) then
		
			este_jogador:Iniciar (true) --inicia o hps do jogador
			
			if (meu_dono and not meu_dono.iniciar_hps) then
				meu_dono:Iniciar (true)
				if (meu_dono.end_time) then
					meu_dono.end_time = nil
				else
					--meu_dono:IniciarTempo (_tempo)
					meu_dono.start_time = _tempo
				end
			end
			
			if (este_jogador.end_time) then --> o combate terminou, reabrir o tempo
				este_jogador.end_time = nil
			else
				--este_jogador:IniciarTempo (_tempo)
				este_jogador.start_time = _tempo
			end
		end

	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> actor target
	
		if (cura_efetiva > 0) then
		
			--> combat total
			_current_total [2] = _current_total [2] + cura_efetiva
			
			--> actor healing amount
			este_jogador.total = este_jogador.total + cura_efetiva	
			este_jogador.total_without_pet = este_jogador.total_without_pet + cura_efetiva
			
			--> healing taken 
			jogador_alvo.healing_taken = jogador_alvo.healing_taken + cura_efetiva --> adiciona o dano tomado
			if (not jogador_alvo.healing_from [who_name]) then --> adiciona a pool de dano tomado de quem
				jogador_alvo.healing_from [who_name] = true
			end

			if (is_shield) then
				este_jogador.totalabsorb = este_jogador.totalabsorb + cura_efetiva
				este_jogador.targets_absorbs [alvo_name] = (este_jogador.targets_absorbs [alvo_name] or 0) + cura_efetiva
			end

			--> pet
			if (meu_dono) then
				meu_dono.total = meu_dono.total + cura_efetiva --> heal do pet
				meu_dono.targets [alvo_name] = (meu_dono.targets [alvo_name] or 0) + cura_efetiva
			end
			
			--> target amount
			este_jogador.targets [alvo_name] = (este_jogador.targets [alvo_name] or 0) + cura_efetiva
		end
		
		if (meu_dono) then
			meu_dono.last_event = _tempo
		end
		
		if (overhealing > 0) then
			este_jogador.totalover = este_jogador.totalover + overhealing
			este_jogador.targets_overheal [alvo_name] = (este_jogador.targets_overheal [alvo_name] or 0) + overhealing
			
			if (meu_dono) then
				meu_dono.totalover = meu_dono.totalover + overhealing
			end
		end

		--> actor spells table
		local spell = este_jogador.spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
			if (is_shield) then
				spell.is_shield = true
			end
			if (_current_combat.is_boss and who_flags and _bit_band (who_flags, OBJECT_TYPE_ENEMY) ~= 0) then
				_detalhes.spell_school_cache [spellname] = spelltype or school
			end
		end
		
		if (_is_storing_cleu) then
			_current_combat_cleu_events [_current_combat_cleu_events.n] = {_tempo, _token_ids [token] or 0, who_name, alvo_name or "", spellid, amount}
			_current_combat_cleu_events.n = _current_combat_cleu_events.n + 1
		end
		
		if (is_shield) then
			--return spell:Add (alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, 0, 		  nil, 	     overhealing, true)
			return spell_heal_func (spell, alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, 0, 		  nil, 	     overhealing, true)
		else
			--return spell:Add (alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, absorbed, critical, overhealing)
			return spell_heal_func (spell, alvo_serial, alvo_name, alvo_flags, cura_efetiva, who_name, absorbed, critical, overhealing)
		end
	end

	function parser:SLT_healing (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)
	
	--> get actors
		local este_jogador, meu_dono = healing_cache [who_serial]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_heal_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono and who_flags and who_serial ~= "") then --> se n�o for um pet, adicionar no cache
				healing_cache [who_serial] = este_jogador
			end
		end

		local jogador_alvo, alvo_dono = healing_cache [alvo_serial]
		if (not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_heal_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			if (not alvo_dono and alvo_flags and alvo_serial ~= "") then
				healing_cache [alvo_serial] = jogador_alvo
			end
		end
		
		este_jogador.last_event = _tempo	

		local t = last_events_cache [alvo_name]
		
		if (not t) then
			t = _current_combat:CreateLastEventsTable (alvo_name)
		end
		
		local i = t.n
		
		local this_event = t [i]
		
		this_event [1] = false --> true if this is a damage || false for healing
		this_event [2] = spellid --> spellid || false if this is a battle ress line
		this_event [3] = amount --> amount of damage or healing
		this_event [4] = time --> parser time
		this_event [5] = _UnitHealth (alvo_name) --> current unit heal
		this_event [6] = who_name --> source name
		this_event [7] = is_shield
		this_event [8] = absorbed
		
		i = i + 1
		
		if (i == _death_event_amt+1) then
			t.n = 1
		else
			t.n = i
		end
		
		local spell = este_jogador.spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
			spell.neutral = true
		end
		
		return spell_heal_func (spell, alvo_serial, alvo_name, alvo_flags, absorbed + amount - overhealing, who_name, absorbed, critical, overhealing, nil)
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------
	--> BUFFS & DEBUFFS 	search key: ~buff ~aura ~shield								|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:buff (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, tipo, amount, arg1, arg2, arg3)

	--> not yet well know about unnamed buff casters
		if (not alvo_name) then
			alvo_name = "[*] Unknown shield target"

		elseif (not who_name) then 
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end 
		
	------------------------------------------------------------------------------------------------
	--> spell reflection
		if (reflection_spellid[spellid]) then --~reflect
			--> this is a spell reflect aura
			--> we save the info on who received this aura and from whom
			--> this will be used to credit this spell as the one doing the damage
			reflection_auras[alvo_serial] = {
				who_serial = who_serial,
				who_name = who_name,
				who_flags = who_flags,
				spellid = spellid,
				spellname = spellname,
				spelltype = spellschool,
			}
		end

	------------------------------------------------------------------------------------------------
	-->

--[=[
--druid_kyrian_bounds

--damager on damager

SPELL_CAST_SUCCESS,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,326434,"Kindred Spirits",0x40,Player-3209-065BAEDE,0000000000000000,28240,28240,1233,448,472,0,0,10000,10000,200,-3298.34,5440.53,1525,5.8081,177
SPELL_AURA_APPLIED,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,326434,"Kindred Spirits",0x40,BUFF
SPELL_AURA_REMOVED,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,326434,"Kindred Spirits",0x40,BUFF

12/15 10:03:51.702  SPELL_CAST_SUCCESS,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,0000000000000000,nil,0x80000000,0x80000000,326446,"Empower Bond",0x40,Player-3209-065BAEDE,0000000000000000,28240,28240,1234,448,472,0,3,100,100,0,-3294.17,5437.12,1525,0.7611,177

12/15 10:03:51.702  SPELL_AURA_APPLIED,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,327139,"Kindred Empowerment",0x40,BUFF
12/15 10:03:51.702  SPELL_AURA_APPLIED,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,327022,"Kindred Empowerment",0x40,BUFF,1
12/15 10:03:51.702  SPELL_AURA_APPLIED,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,327139,"Kindred Empowerment",0x40,BUFF
12/15 10:03:51.702  SPELL_AURA_APPLIED,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,327022,"Kindred Empowerment",0x40,BUFF,1

SPELL_DAMAGE,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Creature-0-4217-2222-22679-166718-000058B14F,"Manifestation of Envy",0x10a48,0x0,338411,"Kindred Empowerment",0x40,Creature-0-4217-2222-22679-166718-000058B14F,0000000000000000,4218,5895,0,0,651,0,0,2289,2289,0,-3290.46,5445.37,1525,4.1809,58,31,30,-1,64,0,0,0,nil,nil,nil
SPELL_DAMAGE,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,Creature-0-4217-2222-22679-166718-000058B14F,"Manifestation of Envy",0x10a48,0x0,338411,"Kindred Empowerment",0x40,Creature-0-4217-2222-22679-166718-000058B14F,0000000000000000,867,5895,0,0,651,0,0,2289,2289,0,-3289.84,5446.94,1525,4.3379,58,89,89,-1,64,0,0,0,nil,nil,nil

SPELL_HEAL,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x10512,0x0,327149,"Kindred Focus",0x40,Player-3209-065BAEDE,0000000000000000,50058,50058,1575,448,1510,8832,1,1000,1000,0,-2640.65,5656.60,1525,3.3950,177,485,485,485,0,nil

12/15 10:04:01.739  SPELL_AURA_REMOVED,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,327139,"Kindred Empowerment",0x40,BUFF
12/15 10:04:01.739  SPELL_AURA_REMOVED,Player-3209-065BAEDE,"Bullcéfalo-Azralon",0x512,0x0,Player-3209-0A79112C,"Symantec-Azralon",0x511,0x0,327139,"Kindred Empowerment",0x40,BUFF

--]=]

	------------------------------------------------------------------------------------------------
	--> handle shields

		if (tipo == "BUFF") then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				
				if (spellid == 27827) then --> spirit of redemption (holy priest)
					parser:dead ("UNIT_DIED", time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)
					ignore_death [who_name] = true
					return
					
				elseif (spellid == SPELLID_MONK_GUARD) then
					--> BfA monk talent
					monk_guard_talent [who_serial] = amount
				
				elseif (spellid == SPELLID_NECROMANCER_CHEAT_DEATH) then
					necro_cheat_deaths[who_serial] = true
				end

				if (_recording_buffs_and_debuffs) then
					if (who_name == alvo_name and raid_members_cache [who_serial] and _in_combat) then
						--> call record buffs uptime
						parser:add_buff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_IN")
						
					elseif (container_pets [who_serial] and container_pets [who_serial][2] == alvo_serial) then
						--um pet colocando uma aura do dono
						parser:add_buff_uptime (token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_IN")
					end
				end
				
			------------------------------------------------------------------------------------------------
			--> healing done absorbs
				if (absorb_spell_list [spellid] and _recording_healing and amount) then
					if (not escudo [alvo_name]) then 
						escudo [alvo_name] = {}
						escudo [alvo_name] [spellid] = {}
						escudo [alvo_name] [spellid] [who_name] = amount
					elseif (not escudo [alvo_name] [spellid]) then 
						escudo [alvo_name] [spellid] = {}
						escudo [alvo_name] [spellid] [who_name] = amount
					else
						escudo [alvo_name] [spellid] [who_name] = amount
					end
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif (tipo == "DEBUFF") then

			--Eye of Corruption 8.3 REMOVE ON 9.0
			if (spellid == 315161) then
				local enemyName = GetSpellInfo(315161)
				who_serial, who_name, who_flags = "", enemyName, 0xa48

			--3/11 14:08:34.105  SPELL_CAST_START,Player-3676-06D63197,"Clutchdaily-Area52",0x512,0x0,0000000000000000,nil,0x80000000,0x80000000,342171,"Loyal Stoneborn",0x20
			--3/11 14:08:35.690  SPELL_CAST_SUCCESS,Player-3676-06D63197,"Clutchdaily-Area52",0x512,0x0,0000000000000000,nil,0x80000000,0x80000000,342171,"Loyal Stoneborn",0x20,Player-3676-06D63197,0000000000000000,59976,68222,1882,304,3067,0,1,405,1000,0,-2191.13,5230.31,1663,3.1663,218
			elseif (spellid == SPELLID_VENTYR_TAME_GARGOYLE) then --ventyr tame gargoyle on halls of atonement
				--3/11 14:08:35.690  SPELL_AURA_APPLIED,Player-3676-06D63197,"Clutchdaily-Area52",0x512,0x0,Creature-0-4220-2287-20503-174175-0000CA4BDB,"Loyal Stoneborn",0xa48,0x0,342171,"Loyal Stoneborn",0x20,DEBUFF
				--tag the target of this spell as a pet of caster
				_detalhes.tabela_pets:Adicionar(alvo_serial, alvo_name, alvo_flags, who_serial, who_name, 0x00000417)
				--print("D! player", who_name, "tamed a gargoyle in HOA.")
			end
			
		------------------------------------------------------------------------------------------------
		--> spell reflection
			if (who_serial == alvo_serial and not reflection_ignore[spellid]) then
				--> self-inflicted debuff that could've been reflected
				--> just saving it as a boolean to check for reflections
				reflection_debuffs[who_serial] = reflection_debuffs[who_serial] or {}
				reflection_debuffs[who_serial][spellid] = true
			end
			
			if (spellid == SPELLID_BARGAST_DEBUFF) then --REMOVE ON 10.0
				bargastBuffs[alvo_serial] = (bargastBuffs[alvo_serial] or 0) + 1
			end

			if (_in_combat) then

			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
				
					if (cc_spell_list [spellid]) then
						parser:add_cc_done (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname)
					end
					
					if (bitfield_debuffs [spellname] and raid_members_cache [alvo_serial]) then
						bitfield_swap_cache [alvo_serial] = true
					end
				
					if (raid_members_cache [who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "DEBUFF_UPTIME_IN")
	
					elseif (raid_members_cache [alvo_serial] and not raid_members_cache [who_serial]) then --> alvo � da raide e who � alguem de fora da raide
						parser:add_bad_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, "DEBUFF_UPTIME_IN")
					end
				end
			
				if (_recording_ability_with_buffs) then
					if (who_name == _detalhes.playername) then

						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if (not SoloDebuffUptime) then
							SoloDebuffUptime = {}
							_current_combat.SoloDebuffUptime = SoloDebuffUptime
						end
						
						local ThisDebuff = SoloDebuffUptime [spellid]
						
						if (not ThisDebuff) then
							ThisDebuff = {name = spellname, duration = 0, start = _tempo, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true}
							SoloDebuffUptime [spellid] = ThisDebuff
						else
							ThisDebuff.castedAmt = ThisDebuff.castedAmt + 1
							ThisDebuff.start = _tempo
							ThisDebuff.Active = true
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (not SoloDebuffPower) then
							SoloDebuffPower = {}
							_current_combat.SoloDebuffPower = SoloDebuffPower
						end
						
						local ThisDebuff = SoloDebuffPower [spellid]
						if (not ThisDebuff) then
							ThisDebuff = {}
							SoloDebuffPower [spellid] = ThisDebuff
						end
						
						local ThisDebuffOnTarget = ThisDebuff [alvo_serial]
						
						local base, posBuff, negBuff = UnitAttackPower ("player")
						local AttackPower = base+posBuff+negBuff
						local base, posBuff, negBuff = UnitRangedAttackPower ("player")
						local RangedAttackPower = base+posBuff+negBuff
						local SpellPower = GetSpellBonusDamage (3)
						
						--> record buffs active on player when the debuff was applied
						local BuffsOn = {}
						for BuffName, BuffTable in _pairs (_detalhes.Buffs.BuffsTable) do
							if (BuffTable.active) then
								BuffsOn [#BuffsOn+1] = BuffName
							end
						end
						
						if (not ThisDebuffOnTarget) then --> apply
							ThisDebuff [alvo_serial] = {power = math.max (AttackPower, RangedAttackPower, SpellPower), onTarget = true, buffs = BuffsOn}
						else --> re applying
							ThisDebuff [alvo_serial].power = math.max (AttackPower, RangedAttackPower, SpellPower)
							ThisDebuff [alvo_serial].buffs = BuffsOn
							ThisDebuff [alvo_serial].onTarget = true
						end
						
						--> send event for plugins
						_detalhes:SendEvent ("BUFF_UPDATE_DEBUFFPOWER")
						
					end
				end
			end
		end
	end
	
	-- ~crowd control ~ccdone
	function parser:add_cc_done (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
	
		--> main actor
		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not este_jogador.cc_done) then
			este_jogador.cc_done = _detalhes:GetOrderNumber()
			este_jogador.cc_done_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.cc_done_targets = {}
		end	

	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> update last event
		este_jogador.last_event = _tempo
		
		--> add amount
		este_jogador.cc_done = este_jogador.cc_done + 1
		este_jogador.cc_done_targets [alvo_name] = (este_jogador.cc_done_targets [alvo_name] or 0) + 1
		
		--> actor spells table
		local spell = este_jogador.cc_done_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.cc_done_spells:PegaHabilidade (spellid, true)
		end
		
		spell.targets [alvo_name] = (spell.targets [alvo_name] or 0) + 1
		spell.counter = spell.counter + 1
		
		--> add the crowd control for the pet owner
		if (meu_dono) then
		
			if (not meu_dono.cc_done) then
				meu_dono.cc_done = _detalhes:GetOrderNumber()
				meu_dono.cc_done_spells = container_habilidades:NovoContainer (container_misc)
				meu_dono.cc_done_targets = {}
			end
			
			--> add amount
			meu_dono.cc_done = meu_dono.cc_done + 1
			meu_dono.cc_done_targets [alvo_name] = (meu_dono.cc_done_targets [alvo_name] or 0) + 1
			
			--> actor spells table
			local spell = meu_dono.cc_done_spells._ActorTable [spellid]
			if (not spell) then
				spell = meu_dono.cc_done_spells:PegaHabilidade (spellid, true)
			end
			
			spell.targets [alvo_name] = (spell.targets [alvo_name] or 0) + 1
			spell.counter = spell.counter + 1
		end
		
		--> verifica a classe
		if (who_flags and _bit_band (who_flags, OBJECT_TYPE_PLAYER) ~= 0) then
			if (este_jogador.classe == "UNKNOW" or este_jogador.classe == "UNGROUPPLAYER") then
				local damager_object = damage_cache [who_serial]
				if (damager_object and (damager_object.classe ~= "UNKNOW" and damager_object.classe ~= "UNGROUPPLAYER")) then
					este_jogador.classe = damager_object.classe
				else
					local healing_object = healing_cache [who_serial]
					if (healing_object and (healing_object.classe ~= "UNKNOW" and healing_object.classe ~= "UNGROUPPLAYER")) then
						este_jogador.classe = healing_object.classe
					end
				end
			end
		end
	end

	function parser:buff_refresh (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, tipo, amount)

	------------------------------------------------------------------------------------------------
	--> handle shields

		if (tipo == "BUFF") then
		
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (who_name == alvo_name and raid_members_cache [who_serial] and _in_combat) then
						--> call record buffs uptime
						parser:add_buff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_REFRESH")
					elseif (container_pets [who_serial] and container_pets [who_serial][2] == alvo_serial) then
						--um pet colocando uma aura do dono
						parser:add_buff_uptime (token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_REFRESH")
					end
				end
		
			------------------------------------------------------------------------------------------------
			--> healing done (shields)
				if (absorb_spell_list [spellid] and _recording_healing and amount) then
					if (escudo [alvo_name] and escudo [alvo_name][spellid] and escudo [alvo_name][spellid][who_name]) then
						if (ignored_overheal [spellid]) then
							escudo [alvo_name][spellid][who_name] = amount -- refresh j� vem o valor atualizado
							return
						end
						
						--escudo antigo � dropado, novo � posto
						local overheal = escudo [alvo_name][spellid][who_name]
						escudo [alvo_name][spellid][who_name] = amount
						
						if (overheal > 0) then
							return parser:heal (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, nil, 0, _math_ceil (overheal), 0, 0, nil, true)
						end
					end
					
			------------------------------------------------------------------------------------------------
			--> recording buffs

				elseif (_recording_self_buffs) then
					if (who_name == _detalhes.playername or alvo_name == _detalhes.playername) then --> foi colocado pelo player
					
						local bufftable = _detalhes.Buffs.BuffsTable [spellname]
						if (bufftable) then
							return bufftable:UpdateBuff ("refresh")
						else
							return false
						end
					end
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif (tipo == "DEBUFF") then
		--print ("debuff - ", token, spellname)

			--Eye of Corruption 8.3 REMOVE ON 9.0
			if (spellid == 315161) then
				local enemyName = GetSpellInfo(315161)
				who_serial, who_name, who_flags = "", enemyName, 0xa48
			end

			if (spellid == SPELLID_BARGAST_DEBUFF) then
				bargastBuffs[alvo_serial] = (bargastBuffs[alvo_serial] or 0) + 1
			end

			if (_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (raid_members_cache [who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "DEBUFF_UPTIME_REFRESH")
					elseif (raid_members_cache [alvo_serial] and not raid_members_cache [who_serial]) then --> alvo � da raide e o caster � inimigo
						parser:add_bad_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, "DEBUFF_UPTIME_REFRESH", amount)
					end
				end
				
				if (_recording_ability_with_buffs) then
					if (who_name == _detalhes.playername) then
					
						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if (SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime [spellid]
							if (ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.refreshAmt = ThisDebuff.refreshAmt + 1
								ThisDebuff.duration = ThisDebuff.duration + (_tempo - ThisDebuff.start)
								ThisDebuff.start = _tempo
								
								--> send event for plugins
								_detalhes:SendEvent ("BUFF_UPDATE_DEBUFFPOWER")
							end
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower [spellid]
							if (ThisDebuff) then
								local ThisDebuffOnTarget = ThisDebuff [alvo_serial]
								if (ThisDebuffOnTarget) then
									local base, posBuff, negBuff = UnitAttackPower ("player")
									local AttackPower = base+posBuff+negBuff
									local base, posBuff, negBuff = UnitRangedAttackPower ("player")
									local RangedAttackPower = base+posBuff+negBuff
									local SpellPower = GetSpellBonusDamage (3)
									
									local BuffsOn = {}
									for BuffName, BuffTable in _pairs (_detalhes.Buffs.BuffsTable) do
										if (BuffTable.active) then
											BuffsOn [#BuffsOn+1] = BuffName
										end
									end
									
									ThisDebuff [alvo_serial].power = math.max (AttackPower, RangedAttackPower, SpellPower)
									ThisDebuff [alvo_serial].buffs = BuffsOn
									
									--> send event for plugins
									_detalhes:SendEvent ("BUFF_UPDATE_DEBUFFPOWER")
								end
							end
						end
						
					end
				end
			end
		end
	end

	-- ~unbuff
	function parser:unbuff (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, tipo, amount)

	------------------------------------------------------------------------------------------------
	--> handle shields
	
		if (tipo == "BUFF") then

			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (who_name == alvo_name and raid_members_cache [who_serial] and _in_combat) then
						--> call record buffs uptime
						parser:add_buff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_OUT")
					elseif (container_pets [who_serial] and container_pets [who_serial][2] == alvo_serial) then
						--um pet colocando uma aura do dono
						parser:add_buff_uptime (token, time, alvo_serial, alvo_name, alvo_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "BUFF_UPTIME_OUT")
					end
				end
				
				if (spellid == SPELLID_MONK_GUARD) then
					--> BfA monk talent
					if (monk_guard_talent [who_serial]) then
						local damage_prevented = monk_guard_talent [who_serial] - (amount or 0)
						parser:heal (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, damage_prevented, _math_ceil (amount or 0), 0, 0, true)
					end
				
				elseif (spellid == SPELLID_NECROMANCER_CHEAT_DEATH) then --remove on 10.0
					necro_cheat_deaths[who_serial] = nil

				end

				--druid kyrian empower bounds (9.0 kyrian covenant - probably remove on 10.0)
				if (spellid == SPELLID_KYRIAN_DRUID and alvo_name) then
					druid_kyrian_bounds[alvo_name] = nil
				end
				
			------------------------------------------------------------------------------------------------
			--> healing done (shields)
				if (absorb_spell_list [spellid] and _recording_healing) then
					local spellName = GetSpellInfo(spellid)

					if (escudo [alvo_name] and escudo [alvo_name][spellid] and escudo [alvo_name][spellid][who_name]) then
						if (amount) then
							-- o amount � o que sobrou do escudo							
							--local overheal = escudo [alvo_name][spellid][who_name] --usando o 'amount' passado pela função
							--overheal não esta dando refresh quando um valor é adicionado ao escudo
							escudo [alvo_name][spellid][who_name] = 0

							--> can't use monk guard since its overheal is computed inside the unbuff
							if (amount > 0 and spellid ~= SPELLID_MONK_GUARD) then
								--> removing the nil at the end before true for is_shield, I have no documentation change about it, not sure the reason why it was addded
								return parser:heal (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, nil, 0, _math_ceil (amount), 0, 0, true) --0, 0, nil, true
							else
								return
							end
						end

						escudo [alvo_name][spellid][who_name] = 0
					end
				
			------------------------------------------------------------------------------------------------
			--> recording buffs
				elseif (_recording_self_buffs) then
					if (who_name == _detalhes.playername or alvo_name == _detalhes.playername) then --> foi colocado pelo player
					
						local bufftable = _detalhes.Buffs.BuffsTable [spellname]
						if (bufftable) then
							return bufftable:UpdateBuff ("remove")
						else
							return false
						end			
					end			
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player
		elseif (tipo == "DEBUFF") then
		
			--Eye of Corruption 8.3 REMOVE ON 9.0
			if (spellid == 315161) then
				local enemyName = GetSpellInfo(315161)
				who_serial, who_name, who_flags = "", enemyName, 0xa48
			end
			
		------------------------------------------------------------------------------------------------
		--> spell reflection
			if (reflection_dispels[alvo_serial] and reflection_dispels[alvo_serial][spellid]) then
				--> debuff was dispelled by a reflecting dispel and could've been reflected
				--> save the data about whom dispelled who and the spell that was dispelled
				local reflection = reflection_dispels[alvo_serial][spellid]
				reflection_events[who_serial] = reflection_events[who_serial] or {}
				reflection_events[who_serial][spellid] = {
					who_serial = reflection.who_serial,
					who_name = reflection.who_name,
					who_flags = reflection.who_flags,
					spellid = reflection.spellid,
					spellname = reflection.spellname,
					spelltype = reflection.spelltype,
					time = time,
				}
				reflection_dispels[alvo_serial][spellid] = nil
				if (next(reflection_dispels[alvo_serial]) == nil) then
					--suggestion on how to make this better?
					reflection_dispels[alvo_serial] = nil
				end
			end
			
		------------------------------------------------------------------------------------------------
		--> spell reflection
			if (reflection_debuffs[who_serial] and reflection_debuffs[who_serial][spellid]) then
				--> self-inflicted debuff was removed, so we just clear this data
				reflection_debuffs[who_serial][spellid] = nil
				if (next(reflection_debuffs[who_serial]) == nil) then
					--> better way of doing this? accepting suggestions
					reflection_debuffs[who_serial] = nil
				end
			end
		
			if (_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (raid_members_cache [who_serial]) then
						--> call record debuffs uptime
						parser:add_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, "DEBUFF_UPTIME_OUT")
					elseif (raid_members_cache [alvo_serial] and not raid_members_cache [who_serial]) then --> alvo � da raide e o caster � inimigo
						parser:add_bad_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, "DEBUFF_UPTIME_OUT")
					end
				end
				
				if (bitfield_debuffs [spellname] and alvo_serial) then
					bitfield_swap_cache [alvo_serial] = nil
				end
				
				if (_recording_ability_with_buffs) then
			
					if (who_name == _detalhes.playername) then
					
						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						local sendevent = false
						if (SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime [spellid]
							if (ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.duration = ThisDebuff.duration + (_tempo - ThisDebuff.start)
								ThisDebuff.droppedAmt = ThisDebuff.droppedAmt + 1
								ThisDebuff.start = nil
								ThisDebuff.Active = false
								sendevent = true
							end
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower [spellid]
							if (ThisDebuff) then
								ThisDebuff [alvo_serial] = nil
								sendevent = true
							end
						end
						
						if (sendevent) then
							_detalhes:SendEvent ("BUFF_UPDATE_DEBUFFPOWER")
						end
					end
				end
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~buffuptime ~buffsuptime									|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:add_bad_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spellschool, in_out, stack_amount)
		
		if (not alvo_name) then
			--> no target name, just quit
			return
		elseif (not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] "..spellname
		end
		
		------------------------------------------------------------------------------------------------
		--> get actors
			--> nome do debuff ser� usado para armazenar o nome do ator
			local este_jogador = misc_cache [spellname]
			if (not este_jogador) then --> pode ser um desconhecido ou um pet
				este_jogador = _current_misc_container:PegarCombatente (who_serial, spellname, who_flags, true)
				misc_cache [spellname] = este_jogador
			end
		
		------------------------------------------------------------------------------------------------
		--> build containers on the fly
			
			if (not este_jogador.debuff_uptime) then
				este_jogador.boss_debuff = true
				este_jogador.damage_twin = who_name
				este_jogador.spellschool = spellschool
				este_jogador.damage_spellid = spellid
				este_jogador.debuff_uptime = 0
				este_jogador.debuff_uptime_spells = container_habilidades:NovoContainer (container_misc)
				este_jogador.debuff_uptime_targets = {}
			end
		
		------------------------------------------------------------------------------------------------
		--> add amount
			
			--> update last event
			este_jogador.last_event = _tempo
			
			--> actor target
			local este_alvo = este_jogador.debuff_uptime_targets [alvo_name]
			if (not este_alvo) then
				este_alvo = _detalhes.atributo_misc:CreateBuffTargetObject()
				este_jogador.debuff_uptime_targets [alvo_name] = este_alvo
			end
			
			if (in_out == "DEBUFF_UPTIME_IN") then
				este_alvo.actived = true
				este_alvo.activedamt = este_alvo.activedamt + 1
				if (este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at
				end
				este_alvo.actived_at = _tempo
				
				--death log
					--> record death log
					if (not necro_cheat_deaths[alvo_serial]) then --remove on 10.0
						local t = last_events_cache [alvo_name]
						
						if (not t) then
							t = _current_combat:CreateLastEventsTable (alvo_name)
						end
						
						local i = t.n
						
						local this_event = t [i]
						
						if (not this_event) then
							return print ("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
						end
						
						--print ("DebuffIN", ">", "Added to the DeathLog")
						
						this_event [1] = 4 --> 4 = debuff aplication
						this_event [2] = spellid --> spellid
						this_event [3] = 1
						this_event [4] = time --> parser time
						this_event [5] = _UnitHealth (alvo_name) --> current unit heal
						this_event [6] = who_name --> source name
						this_event [7] = false
						this_event [8] = false
						this_event [9] = false
						this_event [10] = false
						
						i = i + 1
						
						if (i == _death_event_amt+1) then
							t.n = 1
						else
							t.n = i
						end				
					end
				
			elseif (in_out == "DEBUFF_UPTIME_REFRESH") then
				if (este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at
				end
				este_alvo.actived_at = _tempo
				este_alvo.actived = true
				
				--death log
					
					--local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitAura (alvo_name, spellname, nil, "HARMFUL")
					--UnitAura ("Kastfall", "Gulp Frog Toxin", nil, "HARMFUL")

					--> record death log
					if (not necro_cheat_deaths[alvo_serial]) then --remove on 10.0
						local t = last_events_cache [alvo_name]
						
						if (not t) then
							t = _current_combat:CreateLastEventsTable (alvo_name)
						end
						
						local i = t.n
						
						local this_event = t [i]
						
						if (not this_event) then
							return print ("Parser Event Error -> Set to 16 DeathLogs and /reload", i, _death_event_amt)
						end
						
						--print ("DebuffRefresh", ">", "Added to the DeathLog", stack_amount)
						
						this_event [1] = 4 --> 4 = debuff aplication
						this_event [2] = spellid --> spellid
						this_event [3] = stack_amount or 1
						this_event [4] = time --> parser time
						this_event [5] = _UnitHealth (alvo_name) --> current unit heal
						this_event [6] = who_name --> source name
						this_event [7] = false
						this_event [8] = false
						this_event [9] = false
						this_event [10] = false
						
						i = i + 1
						
						if (i == _death_event_amt+1) then
							t.n = 1
						else
							t.n = i
						end
					end
				
			elseif (in_out == "DEBUFF_UPTIME_OUT") then
				if (este_alvo.actived_at and este_alvo.actived) then
					este_alvo.uptime = este_alvo.uptime + _detalhes._tempo - este_alvo.actived_at
					este_jogador.debuff_uptime = este_jogador.debuff_uptime + _tempo - este_alvo.actived_at --> token = actor misc object
				end
				
				este_alvo.activedamt = este_alvo.activedamt - 1
				
				if (este_alvo.activedamt == 0) then
					este_alvo.actived = false
					este_alvo.actived_at = nil
				else
					este_alvo.actived_at = _tempo
				end
			end
	end

	-- ~debuff
	function parser:add_debuff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, in_out)
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
		local este_jogador = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			misc_cache [who_name] = este_jogador
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not este_jogador.debuff_uptime) then
			este_jogador.debuff_uptime = 0
			este_jogador.debuff_uptime_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.debuff_uptime_targets = {}
		end
	
	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> update last event
		este_jogador.last_event = _tempo

		--> actor spells table
		local spell = este_jogador.debuff_uptime_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.debuff_uptime_spells:PegaHabilidade (spellid, true, "DEBUFF_UPTIME")
		end
		return spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, este_jogador, "BUFF_OR_DEBUFF", in_out)
		
	end

	function parser:add_buff_uptime (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, in_out)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
		local este_jogador = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			misc_cache [who_name] = este_jogador
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not este_jogador.buff_uptime) then
			este_jogador.buff_uptime = 0
			este_jogador.buff_uptime_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.buff_uptime_targets = {}
		end	

	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> update last event
		este_jogador.last_event = _tempo

		--> actor spells table
		local spell = este_jogador.buff_uptime_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.buff_uptime_spells:PegaHabilidade (spellid, true, "BUFF_UPTIME")
		end
		return spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, este_jogador, "BUFF_OR_DEBUFF", in_out)
		
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> ENERGY	serach key: ~energy												|
-----------------------------------------------------------------------------------------------------------------------------------------

local PowerEnum = Enum and Enum.PowerType

local SPELL_POWER_MANA = SPELL_POWER_MANA or (PowerEnum and PowerEnum.Mana) or 0
local SPELL_POWER_RAGE = SPELL_POWER_RAGE or (PowerEnum and PowerEnum.Rage) or 1
local SPELL_POWER_FOCUS = SPELL_POWER_FOCUS or (PowerEnum and PowerEnum.Focus) or 2
local SPELL_POWER_ENERGY = SPELL_POWER_ENERGY or (PowerEnum and PowerEnum.Energy) or 3
local SPELL_POWER_COMBO_POINTS2 = SPELL_POWER_COMBO_POINTS or (PowerEnum and PowerEnum.ComboPoints) or 4
local SPELL_POWER_RUNES = SPELL_POWER_RUNES or (PowerEnum and PowerEnum.Runes) or 5
local SPELL_POWER_RUNIC_POWER = SPELL_POWER_RUNIC_POWER or (PowerEnum and PowerEnum.RunicPower) or 6
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS or (PowerEnum and PowerEnum.SoulShards) or 7
local SPELL_POWER_LUNAR_POWER = SPELL_POWER_LUNAR_POWER or (PowerEnum and PowerEnum.LunarPower) or 8
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER  or (PowerEnum and PowerEnum.HolyPower) or 9
local SPELL_POWER_ALTERNATE_POWER = SPELL_POWER_ALTERNATE_POWER or (PowerEnum and PowerEnum.Alternate) or 10
local SPELL_POWER_MAELSTROM = SPELL_POWER_MAELSTROM or (PowerEnum and PowerEnum.Maelstrom) or 11
local SPELL_POWER_CHI = SPELL_POWER_CHI or (PowerEnum and PowerEnum.Chi) or 12
local SPELL_POWER_INSANITY = SPELL_POWER_INSANITY or (PowerEnum and PowerEnum.Insanity) or 13
local SPELL_POWER_OBSOLETE = SPELL_POWER_OBSOLETE or (PowerEnum and PowerEnum.Obsolete) or 14
local SPELL_POWER_OBSOLETE2 = SPELL_POWER_OBSOLETE2 or (PowerEnum and PowerEnum.Obsolete2) or 15
local SPELL_POWER_ARCANE_CHARGES = SPELL_POWER_ARCANE_CHARGES or (PowerEnum and PowerEnum.ArcaneCharges) or 16
local SPELL_POWER_FURY = SPELL_POWER_FURY or (PowerEnum and PowerEnum.Fury) or 17
local SPELL_POWER_PAIN = SPELL_POWER_PAIN or (PowerEnum and PowerEnum.Pain) or 18

	local energy_types = {
		[SPELL_POWER_MANA] = true,
		[SPELL_POWER_RAGE] = true,
		[SPELL_POWER_ENERGY] = true,
		[SPELL_POWER_RUNIC_POWER] = true,
	}
	
	local resource_types = {
		[SPELL_POWER_INSANITY] = true, --shadow priest
		[SPELL_POWER_CHI] = true, --monk
		[SPELL_POWER_HOLY_POWER] = true, --paladins
		[SPELL_POWER_LUNAR_POWER] = true, --balance druids
		[SPELL_POWER_SOUL_SHARDS] = true, --warlock affliction
		[SPELL_POWER_COMBO_POINTS2] = true, --combo points
		[SPELL_POWER_MAELSTROM] = true, --shamans
		[SPELL_POWER_PAIN] = true, --demonhunter tank
		[SPELL_POWER_RUNES] = true, --dk
		[SPELL_POWER_ARCANE_CHARGES] = true, --mage
		[SPELL_POWER_FURY] = true, --warrior demonhunter dps
	}
	
	local resource_power_type = {
		[SPELL_POWER_COMBO_POINTS2] = SPELL_POWER_ENERGY, --combo points
		[SPELL_POWER_SOUL_SHARDS] = SPELL_POWER_MANA, --warlock
		[SPELL_POWER_LUNAR_POWER] = SPELL_POWER_MANA, --druid
		[SPELL_POWER_HOLY_POWER] = SPELL_POWER_MANA, --paladin
		[SPELL_POWER_INSANITY] = SPELL_POWER_MANA, --shadowpriest
		[SPELL_POWER_MAELSTROM] = SPELL_POWER_MANA, --shaman
		[SPELL_POWER_CHI] = SPELL_POWER_MANA, --monk
		[SPELL_POWER_PAIN] = SPELL_POWER_ENERGY, --demonhuinter
		[SPELL_POWER_RUNES] = SPELL_POWER_RUNIC_POWER, --dk
		[SPELL_POWER_ARCANE_CHARGES] = SPELL_POWER_MANA, --mage
		[SPELL_POWER_FURY] = SPELL_POWER_RAGE, --warrior
	}
	
	_detalhes.resource_strings = {
		[SPELL_POWER_COMBO_POINTS2] = "Combo Point",
		[SPELL_POWER_SOUL_SHARDS] = "Soul Shard",
		[SPELL_POWER_LUNAR_POWER] = "Lunar Power",
		[SPELL_POWER_HOLY_POWER] = "Holy Power",
		[SPELL_POWER_INSANITY] = "Insanity",
		[SPELL_POWER_MAELSTROM] = "Maelstrom",
		[SPELL_POWER_CHI] = "Chi",
		[SPELL_POWER_PAIN] = "Pain",
		[SPELL_POWER_RUNES] = "Runes",
		[SPELL_POWER_ARCANE_CHARGES] = "Arcane Charge",
		[SPELL_POWER_FURY] = "Rage",
	}
	
	_detalhes.resource_icons = {
		[SPELL_POWER_COMBO_POINTS2] = {file = [[Interface\PLAYERFRAME\ClassOverlayComboPoints]], coords = {58/128, 74/128, 25/64, 39/64}},
		[SPELL_POWER_SOUL_SHARDS] = {file = [[Interface\PLAYERFRAME\UI-WARLOCKSHARD]], coords = {3/64, 17/64, 2/128, 16/128}},
		[SPELL_POWER_LUNAR_POWER] = {file = [[Interface\PLAYERFRAME\DruidEclipse]], coords = {117/256, 140/256, 83/128, 115/128}},
		[SPELL_POWER_HOLY_POWER] = {file = [[Interface\PLAYERFRAME\PALADINPOWERTEXTURES]], coords = {75/256, 94/256, 87/128, 100/128}},
		[SPELL_POWER_INSANITY] = {file = [[Interface\PLAYERFRAME\Priest-ShadowUI]], coords = {119/256, 150/256, 61/128, 94/128}},
		[SPELL_POWER_MAELSTROM] = {file = [[Interface\PLAYERFRAME\MonkNoPower]], coords = {0, 1, 0, 1}},
		[SPELL_POWER_CHI] = {file = [[Interface\PLAYERFRAME\MonkLightPower]], coords = {0, 1, 0, 1}},
		[SPELL_POWER_PAIN] = {file = [[Interface\PLAYERFRAME\Deathknight-Energize-Blood]], coords = {0, 1, 0, 1}},
		[SPELL_POWER_RUNES] = {file = [[Interface\PLAYERFRAME\UI-PlayerFrame-Deathknight-SingleRune]], coords = {0, 1, 0, 1}},
		[SPELL_POWER_ARCANE_CHARGES] = {file = [[Interface\PLAYERFRAME\MageArcaneCharges]], coords = {68/256, 90/256, 68/128, 91/128}},
		[SPELL_POWER_FURY] = {file = [[Interface\PLAYERFRAME\UI-PlayerFrame-Deathknight-Blood-On]], coords = {0, 1, 0, 1}},
	}
	
	local AlternatePowerEnableFrame = CreateFrame ("frame")
	local AlternatePowerMonitorFrame = CreateFrame ("frame")
	
	AlternatePowerEnableFrame:RegisterEvent ("UNIT_POWER_BAR_SHOW")
	--AlternatePowerEnableFrame:RegisterEvent ("UNIT_POWER_BAR_HIDE")
	AlternatePowerEnableFrame:RegisterEvent ("ENCOUNTER_END")
	--AlternatePowerEnableFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
	AlternatePowerEnableFrame.IsRunning = false
	
	AlternatePowerEnableFrame:SetScript ("OnEvent", function (self, event)
		if (event == "UNIT_POWER_BAR_SHOW") then
			AlternatePowerMonitorFrame:RegisterEvent ("UNIT_POWER_UPDATE") -->  8.0
			AlternatePowerEnableFrame.IsRunning = true
		elseif (AlternatePowerEnableFrame.IsRunning and (event == "ENCOUNTER_END" or event == "PLAYER_REGEN_ENABLED")) then -- and not InCombatLockdown()
			AlternatePowerMonitorFrame:UnregisterEvent ("UNIT_POWER_UPDATE")
			AlternatePowerEnableFrame.IsRunning = false
		end
	end)

	AlternatePowerMonitorFrame:SetScript ("OnEvent", function (self, event, unitID, powerType)
		if (powerType == "ALTERNATE") then
			local actorName = _detalhes:GetCLName (unitID)
			if (actorName) then
				local power = _current_combat.alternate_power [actorName]
				if (not power) then
					power = _current_combat:CreateAlternatePowerTable (actorName)
				end
				local currentPower = UnitPower (unitID, 10)
				if (currentPower and currentPower > power.last) then
					local addPower = currentPower - power.last
					power.total = power.total + addPower

					--> main actor
					local este_jogador = energy_cache [actorName]
					if (not este_jogador) then --> pode ser um desconhecido ou um pet
						este_jogador, meu_dono, actorName = _current_energy_container:PegarCombatente (UnitGUID (unitID), actorName, 0x514, true)
						energy_cache [actorName] = este_jogador
					end
					este_jogador.alternatepower = este_jogador.alternatepower + addPower
					
					_current_energy_container.need_refresh = true
				end
				
				power.last = currentPower or 0
			end
		end
	end)

	local regen_power_overflow_check = function()
		if (not _in_combat) then
			return
		end
		
		for playerName, powerType in _pairs (auto_regen_cache) do 
			local currentPower = UnitPower (playerName, powerType) or 0
			local maxPower = UnitPowerMax (playerName, powerType) or 1
			
			if (currentPower == maxPower) then
				--power overflow
				local energyObject = energy_cache [playerName]
				if (energyObject) then
					energyObject.passiveover = energyObject.passiveover + AUTO_REGEN_PRECISION
				end
			end
		end
	end
	
	-- ~energy ~resource
	function parser:energize (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, amount, overpower, powertype, altpower)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		if (not who_name) then
			who_name = "[*] "..spellname
		elseif (not alvo_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> check if is energy or resource
	
		--> get resource type
		local is_resource, resource_amount, resource_id = resource_power_type [powertype], amount, powertype
	
		--> check if is valid
		if (not energy_types [powertype] and not is_resource) then
			return
			
		elseif (is_resource) then
			powertype = is_resource
			amount = 0
		end
		
		overpower = overpower or 0
		
		--[[statistics]]-- _detalhes.statistics.energy_calls = _detalhes.statistics.energy_calls + 1

		_current_energy_container.need_refresh = true

------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = energy_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_energy_container:PegarCombatente (who_serial, who_name, who_flags, true)
			este_jogador.powertype = powertype
			if (meu_dono) then
				meu_dono.powertype = powertype
			end
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				energy_cache [who_name] = este_jogador
			end
		end
		
		if (not este_jogador.powertype) then
			este_jogador.powertype = powertype
		end
		
		--> target
		local jogador_alvo, alvo_dono = energy_cache [alvo_name]
		if (not jogador_alvo) then
			jogador_alvo, alvo_dono, alvo_name = _current_energy_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
			jogador_alvo.powertype = powertype
			if (alvo_dono) then
				alvo_dono.powertype = powertype
			end
			if (not alvo_dono) then
				energy_cache [alvo_name] = jogador_alvo
			end
		end
		
		if (jogador_alvo.powertype ~= este_jogador.powertype) then
			--print ("error: different power types: who -> ", este_jogador.powertype, " target -> ", jogador_alvo.powertype)
			return
		end
		
		este_jogador.last_event = _tempo
		
	------------------------------------------------------------------------------------------------
	--> amount add
	
		if (not is_resource) then
		
			--amount = amount - overpower
		
			--> add to targets
			este_jogador.targets [alvo_name] = (este_jogador.targets [alvo_name] or 0) + amount
		
			--> add to combat total
			_current_total [3] [powertype] = _current_total [3] [powertype] + amount
		
			if (este_jogador.grupo) then 
				_current_gtotal [3] [powertype] = _current_gtotal [3] [powertype] + amount
			end

			--> regen produced amount
			este_jogador.total = este_jogador.total + amount
			este_jogador.totalover = este_jogador.totalover + overpower
	
			--> target regenerated amount
			jogador_alvo.received = jogador_alvo.received + amount
		
			--> owner
			if (meu_dono) then
				meu_dono.total = meu_dono.total + amount
			end

			--> actor spells table
			local spell = este_jogador.spells._ActorTable [spellid]
			if (not spell) then
				spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
			end
		
			--return spell:Add (alvo_serial, alvo_name, alvo_flags, amount, who_name, powertype)
			return spell_energy_func (spell, alvo_serial, alvo_name, alvo_flags, amount, who_name, powertype, overpower)
			
		else
			--> is a resource
			este_jogador.resource = este_jogador.resource + resource_amount
			este_jogador.resource_type = resource_id
		end
	end


	
-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~cooldown											|
-----------------------------------------------------------------------------------------------------------------------------------------
	
	function parser:add_defensive_cooldown (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
	
		--> main actor
		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		if (not este_jogador.cooldowns_defensive) then
			este_jogador.cooldowns_defensive = _detalhes:GetOrderNumber (who_name)
			este_jogador.cooldowns_defensive_targets = {}
			este_jogador.cooldowns_defensive_spells = container_habilidades:NovoContainer (container_misc) --> cria o container das habilidades
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor cooldowns used
		este_jogador.cooldowns_defensive = este_jogador.cooldowns_defensive + 1

		--> combat totals
		_current_total [4].cooldowns_defensive = _current_total [4].cooldowns_defensive + 1
		
		if (este_jogador.grupo) then
			_current_gtotal [4].cooldowns_defensive = _current_gtotal [4].cooldowns_defensive + 1
			
			if (who_name == alvo_name) then
			
				local damage_actor = damage_cache [who_serial]
				if (not damage_actor) then --> pode ser um desconhecido ou um pet
					damage_actor = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
					if (who_flags) then --> se n�o for um pet, adicionar no cache
						damage_cache [who_serial] = damage_actor
					end
				end

				--> last events
				local t = last_events_cache [who_name]
				
				if (not t) then
					t = _current_combat:CreateLastEventsTable (who_name)
				end
			
				local i = t.n
				local this_event = t [i]
				
				this_event [1] = 1 --> true if this is a damage || false for healing || 1 for cooldown
				this_event [2] = spellid --> spellid || false if this is a battle ress line
				this_event [3] = 1 --> amount of damage or healing
				this_event [4] = time --> parser time
				this_event [5] = _UnitHealth (who_name) --> current unit heal
				this_event [6] = who_name --> source name
				
				i = i + 1
				if (i == _death_event_amt+1) then
					t.n = 1
				else
					t.n = i
				end
				
				este_jogador.last_cooldown = {time, spellid}
				
			end
			
		end
		
		--> update last event
		este_jogador.last_event = _tempo
		
		--> actor targets
		este_jogador.cooldowns_defensive_targets [alvo_name] = (este_jogador.cooldowns_defensive_targets [alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.cooldowns_defensive_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.cooldowns_defensive_spells:PegaHabilidade (spellid, true, token)
		end
		
		if (_hook_cooldowns) then
			--> send event to registred functions
			for _, func in _ipairs (_hook_cooldowns_container) do 
				func (nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
			end
		end
		
		return spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, token, "BUFF_OR_DEBUFF", "COOLDOWN")
	end
	
	--serach key: ~interrupts
	function parser:interrupt (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		--quake affix from mythic+
		if (spellid == 240448) then
			return
		end

		if (not who_name) then
			who_name = "[*] "..spellname
		elseif (not alvo_name) then
			return
		end
		
		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not este_jogador.interrupt) then
			este_jogador.interrupt = _detalhes:GetOrderNumber (who_name)
			este_jogador.interrupt_targets = {}
			este_jogador.interrupt_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.interrompeu_oque = {}
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor interrupt amount
		este_jogador.interrupt = este_jogador.interrupt + 1

		--> combat totals
		_current_total [4].interrupt = _current_total [4].interrupt + 1
		
		if (este_jogador.grupo) then
			_current_gtotal [4].interrupt = _current_gtotal [4].interrupt + 1
		end

		--> update last event
		este_jogador.last_event = _tempo

		--> spells interrupted
		este_jogador.interrompeu_oque [extraSpellID] = (este_jogador.interrompeu_oque [extraSpellID] or 0) + 1

		--> actor targets
		este_jogador.interrupt_targets [alvo_name] = (este_jogador.interrupt_targets [alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.interrupt_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.interrupt_spells:PegaHabilidade (spellid, true, token)
		end
		spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, token, extraSpellID, extraSpellName)
		
		--> verifica se tem dono e adiciona o interrupt para o dono
		if (meu_dono) then
			
			if (not meu_dono.interrupt) then
				meu_dono.interrupt = _detalhes:GetOrderNumber (who_name)
				meu_dono.interrupt_targets = {}
				meu_dono.interrupt_spells = container_habilidades:NovoContainer (container_misc)
				meu_dono.interrompeu_oque = {}
			end
			
			-- adiciona ao total
			meu_dono.interrupt = meu_dono.interrupt + 1
			
			-- adiciona aos alvos
			meu_dono.interrupt_targets [alvo_name] = (meu_dono.interrupt_targets [alvo_name] or 0) + 1
			
			-- update last event
			meu_dono.last_event = _tempo
			
			-- spells interrupted
			meu_dono.interrompeu_oque [extraSpellID] = (meu_dono.interrompeu_oque [extraSpellID] or 0) + 1
			
			--> pet interrupt
			if (_hook_interrupt) then
				for _, func in _ipairs (_hook_interrupt_container) do 
					func (nil, token, time, meu_dono.serial, meu_dono.nome, meu_dono.flag_original, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		else
			--> player interrupt
			if (_hook_interrupt) then
				for _, func in _ipairs (_hook_interrupt_container) do 
					func (nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		end

	end
	
	--> search key: ~spellcast ~castspell ~cast
	function parser:spellcast (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype)
		
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
	
		--> only capture if is in combat
		if (not _in_combat) then
			return
		end
		
		if (not who_name) then
			who_name = "[*] " .. spellname
		end

		--druid kyrian empower bounds (9.0 kyrian covenant - probably remove on 10.0)
		if (spellid == SPELLID_KYRIAN_DRUID and alvo_name and who_serial and who_name and who_flags) then
			druid_kyrian_bounds[alvo_name] = {who_serial, who_name, who_flags}
		end

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		
		local este_jogador, meu_dono = misc_cache [who_serial] or misc_cache_pets [who_serial] or misc_cache [who_name], misc_cache_petsOwners [who_serial]
		--local este_jogador = misc_cache [who_name]
		
		if (not este_jogador) then
		
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			
			if (meu_dono) then --> � um pet
				if (who_serial ~= "") then
					misc_cache_pets [who_serial] = este_jogador
					misc_cache_petsOwners [who_serial] = meu_dono
				end
				
				--conferir se o dono j� esta no cache
				if (not misc_cache [meu_dono.serial] and meu_dono.serial ~= "") then
					misc_cache [meu_dono.serial] = meu_dono
				end
			else
				if (who_flags) then
					misc_cache [who_name] = este_jogador
				end
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		local spell_cast = este_jogador.spell_cast
		if (not spell_cast) then
			este_jogador.spell_cast = {[spellid] = 1}
		else
			spell_cast [spellid] = (spell_cast [spellid] or 0) + 1
		end
		
	------------------------------------------------------------------------------------------------
	--> record cooldowns cast which can't track with buff applyed.
	
		--> foi um jogador que castou
		if (raid_members_cache [who_serial]) then
			--> check if is a cooldown :D
			if (defensive_cooldowns [spellid]) then
				--> usou cooldown
				if (not alvo_name) then
					if (DetailsFramework.CooldownsDeffense [spellid]) then
						alvo_name = who_name
						
					elseif (DetailsFramework.CooldownsRaid [spellid]) then
						alvo_name = Loc ["STRING_RAID_WIDE"]
						
					else
						alvo_name = "--x--x--"
					end
				end
				return parser:add_defensive_cooldown (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname)
			end
			
		else
			--> enemy successful casts (not interrupted)
			if (_bit_band (who_flags, 0x00000040) ~= 0 and who_name) then --> byte 2 = 4 (enemy)
				--> damager
				local este_jogador = damage_cache [who_serial]
				if (not este_jogador) then
					este_jogador = _current_damage_container:PegarCombatente (who_serial, who_name, who_flags, true)
				end

				if (este_jogador) then 
					--> actor spells table
					local spell = este_jogador.spells._ActorTable [spellid] --line where the actor was nil
					if (not spell) then
						spell = este_jogador.spells:PegaHabilidade (spellid, true, token)
					end
					spell.successful_casted = spell.successful_casted + 1
				end
			end
			return
		end
	end

	
	--serach key: ~dispell
	function parser:dispell (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)
		
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		--> esta dando erro onde o nome � NIL, fazendo um fix para isso
		if (not who_name) then
			who_name = "[*] "..extraSpellName
		end
		if (not alvo_name) then
			alvo_name = "[*] "..spellid
		end
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors]
		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not este_jogador.dispell) then
			--> constr�i aqui a tabela dele
			este_jogador.dispell = _detalhes:GetOrderNumber (who_name)
			este_jogador.dispell_targets = {}
			este_jogador.dispell_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.dispell_oque = {}
		end
		
	------------------------------------------------------------------------------------------------
	--> spell reflection
		if (reflection_dispelid[spellid]) then
			--> this aura could've been reflected to the caster after the dispel
			--> save data about whom was dispelled by who and what spell it was
			reflection_dispels[alvo_serial] = reflection_dispels[alvo_serial] or {}
			reflection_dispels[alvo_serial][extraSpellID] = {
				who_serial = who_serial,
				who_name = who_name,
				who_flags = who_flags,
				spellid = spellid,
				spellname = spellname,
				spelltype = spelltype,
			}
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> last event update
		este_jogador.last_event = _tempo

		--> total dispells in combat
		_current_total [4].dispell = _current_total [4].dispell + 1
		
		if (este_jogador.grupo) then
			_current_gtotal [4].dispell = _current_gtotal [4].dispell + 1
		end

		--> actor dispell amount
		este_jogador.dispell = este_jogador.dispell + 1
		
		--> dispell what
		if (extraSpellID) then
			este_jogador.dispell_oque [extraSpellID] = (este_jogador.dispell_oque [extraSpellID] or 0) + 1
		end
		
		--> actor targets
		este_jogador.dispell_targets [alvo_name] = (este_jogador.dispell_targets [alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.dispell_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.dispell_spells:PegaHabilidade (spellid, true, token)
		end
		spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, token, extraSpellID, extraSpellName)
		
		--> verifica se tem dono e adiciona o interrupt para o dono
		if (meu_dono) then
			if (not meu_dono.dispell) then
				meu_dono.dispell = _detalhes:GetOrderNumber (who_name)
				meu_dono.dispell_targets = {}
				meu_dono.dispell_spells = container_habilidades:NovoContainer (container_misc)
				meu_dono.dispell_oque = {}
			end
			
			meu_dono.dispell = meu_dono.dispell + 1

			meu_dono.dispell_targets [alvo_name] = (meu_dono.dispell_targets [alvo_name] or 0) + 1

			meu_dono.last_event = _tempo

			if (extraSpellID) then
				meu_dono.dispell_oque [extraSpellID] = (meu_dono.dispell_oque [extraSpellID] or 0) + 1
			end
		end
	end

	--serach key: ~ress
	function parser:ress (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (_bit_band (who_flags, AFFILIATION_GROUP) == 0) then
			return
		end
		
		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not este_jogador.ress) then
			este_jogador.ress = _detalhes:GetOrderNumber (who_name)
			este_jogador.ress_targets = {}
			este_jogador.ress_spells = container_habilidades:NovoContainer (container_misc) --> cria o container das habilidades usadas para interromper
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> combat ress total
		_current_total [4].ress = _current_total [4].ress + 1
		
		if (este_jogador.grupo) then
			_current_combat.totals_grupo[4].ress = _current_combat.totals_grupo[4].ress+1
		end	

		--> add ress amount
		este_jogador.ress = este_jogador.ress + 1
		
		--> add battle ress
		if (_UnitAffectingCombat (who_name)) then 
			--> procura a �ltima morte do alvo na tabela do combate:
			for i = 1, #_current_combat.last_events_tables do 
				if (_current_combat.last_events_tables [i] [3] == alvo_name) then

					local deadLog = _current_combat.last_events_tables [i] [1]
					local jaTem = false
					for _, evento in _ipairs (deadLog) do 
						if (evento [1] and not evento[3]) then
							jaTem = true
						end
					end
					
					if (not jaTem) then 
						_table_insert (_current_combat.last_events_tables [i] [1], 1, {
							2,
							spellid, 
							1, 
							time, 
							_UnitHealth (alvo_name), 
							who_name 
						})
						break
					end
				end
			end
			
			if (_hook_battleress) then
				for _, func in _ipairs (_hook_battleress_container) do 
					func (nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
				end
			end

		end	
		
		--> actor targets
		este_jogador.ress_targets [alvo_name] = (este_jogador.ress_targets [alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.ress_spells._ActorTable [spellid]
		if (not spell) then
			spell = este_jogador.ress_spells:PegaHabilidade (spellid, true, token)
		end
		return spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, token, extraSpellID, extraSpellName)
	end

	--serach key: ~cc
	function parser:break_cc (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		if (not cc_spell_list [spellid]) then
			return 
			--print ("NO CC:", spellid, spellname, extraSpellID, extraSpellName)
		end

		if (_bit_band (who_flags, AFFILIATION_GROUP) == 0) then
			return
		end
		
		if (not spellname) then
			spellname = "Melee"
		end

		if (not alvo_name) then
			--> no target name, just quit
			return
			
		elseif (not who_name) then
			--> no actor name, use spell name instead
			who_name = "[*] " .. spellname
			who_flags = 0xa48
			who_serial = ""
		end

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		local este_jogador, meu_dono = misc_cache [who_name]
		if (not este_jogador) then --> pode ser um desconhecido ou um pet
			este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (who_serial, who_name, who_flags, true)
			if (not meu_dono) then --> se n�o for um pet, adicionar no cache
				misc_cache [who_name] = este_jogador
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not este_jogador.cc_break) then
			--> constr�i aqui a tabela dele
			este_jogador.cc_break = _detalhes:GetOrderNumber (who_name)
			este_jogador.cc_break_targets = {}
			este_jogador.cc_break_spells = container_habilidades:NovoContainer (container_misc)
			este_jogador.cc_break_oque = {}
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		este_jogador.last_event = _tempo

		--> combat cc break total
		_current_total [4].cc_break = _current_total [4].cc_break + 1

		if (este_jogador.grupo) then
			_current_combat.totals_grupo[4].cc_break = _current_combat.totals_grupo[4].cc_break+1
		end	

		--> add amount
		este_jogador.cc_break = este_jogador.cc_break + 1

		--> broke what
		este_jogador.cc_break_oque [spellid] = (este_jogador.cc_break_oque [spellid] or 0) + 1

		--> actor targets
		este_jogador.cc_break_targets [alvo_name] = (este_jogador.cc_break_targets [alvo_name] or 0) + 1

		--> actor spells table
		local spell = este_jogador.cc_break_spells._ActorTable [extraSpellID]
		if (not spell) then
			spell = este_jogador.cc_break_spells:PegaHabilidade (extraSpellID, true, token)
		end
		return spell_misc_func (spell, alvo_serial, alvo_name, alvo_flags, who_name, token, spellid, spellname)
	end

	--serach key: ~dead ~death ~morte
	function parser:dead (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
	
		if (not alvo_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> build dead
		--print("dead", alvo_flags, _bit_band (alvo_flags, 0x00000008) ~= 0, _current_encounter_id)
		
		local damageActor = _current_damage_container:GetActor(alvo_name)
		--check for outsiders
		if (_in_combat and alvo_flags and (not damageActor or (_bit_band (alvo_flags, 0x00000008) ~= 0 and not damageActor.grupo))) then
			--> outsider death while in combat
			
				--rules for specific encounters
				if (_current_encounter_id == 2412) then --> The Council of Blood (REMOVE ON v10.0.1)

					if (not Details.exp90temp.delete_damage_TCOB) then
						return
					end

					--what boss died
					local bossDeadNpcId = Details:GetNpcIdFromGuid(alvo_serial)
					if (bossDeadNpcId ~= 166969 and bossDeadNpcId ~= 166970 and bossDeadNpcId ~= 166971) then
						return
					end

				--[[
					local unitId_BaronessFrieda = alvo_serial:match("166969%-%w+$")
					local unitId_LordStavros = alvo_serial:match("166970%-%w+$")
					local unitId_CastellanNiklaus = alvo_serial:match("166971%-%w+$")
				--]]

					if (bossDeadNpcId) then
						--iterate among boss unit ids
						for i = 1, 5 do
							local unitId = "boss" .. i

							if (_G.UnitExists(unitId)) then
								local bossHealth = _G.UnitHealth(unitId)
								local bossName = _G.UnitName(unitId)
								local bossSerial = _G.UnitGUID(unitId)

								if (bossHealth and bossHealth > 100000) then 
									if (bossSerial) then
										local bossNpcId = Details:GetNpcIdFromGuid(bossSerial)
										if (bossNpcId and bossNpcId ~= bossDeadNpcId) then
											--remove the damage done
											local currentCombat = Details:GetCurrentCombat()
											currentCombat:DeleteActor(DETAILS_ATTRIBUTE_DAMAGE, bossName, false)
										end
									end
								end
							end
						end
					end
				end

			--> frags
			
				if (_detalhes.only_pvp_frags and (_bit_band (alvo_flags, 0x00000400) == 0 or (_bit_band (alvo_flags, 0x00000040) == 0 and _bit_band (alvo_flags, 0x00000020) == 0))) then --byte 2 = 4 (HOSTILE) byte 3 = 4 (OBJECT_TYPE_PLAYER)
					return
				end
			
				if (not _current_combat.frags [alvo_name]) then
					_current_combat.frags [alvo_name] = 1
				else
					_current_combat.frags [alvo_name] = _current_combat.frags [alvo_name] + 1
				end
				
				_current_combat.frags_need_refresh = true

		--> player death
		elseif (not _UnitIsFeignDeath (alvo_name)) then
			if (
				--> player in your group
				(_bit_band (alvo_flags, AFFILIATION_GROUP) ~= 0 or (damageActor and damageActor.grupo)) and 
				--> must be a player
				_bit_band (alvo_flags, OBJECT_TYPE_PLAYER) ~= 0 and 
				--> must be in combat
				_in_combat
			) then

				if (ignore_death [alvo_name]) then
					ignore_death [alvo_name] = nil
					return
				end

				_current_misc_container.need_refresh = true
				
				--> combat totals
				_current_total [4].dead = _current_total [4].dead + 1
				_current_gtotal [4].dead = _current_gtotal [4].dead + 1
				
				--> main actor no container de misc que ir� armazenar a morte
				local este_jogador, meu_dono = misc_cache [alvo_name]
				if (not este_jogador) then --> pode ser um desconhecido ou um pet
					este_jogador, meu_dono, who_name = _current_misc_container:PegarCombatente (alvo_serial, alvo_name, alvo_flags, true)
					if (not meu_dono) then --> se n�o for um pet, adicionar no cache
						misc_cache [alvo_name] = este_jogador
					end
				end
				
				--> objeto da morte
				local esta_morte = {}
				
				--> add events
				local t = last_events_cache [alvo_name]
				if (not t) then
					t = _current_combat:CreateLastEventsTable (alvo_name)
				end
				
				--lesses index = older / higher index = newer
				
				local last_index = t.n --or 'next index'
				if (last_index < _death_event_amt+1 and not t[last_index][4]) then
					for i = 1, last_index-1 do
						if (t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert (esta_morte, t[i])
						end
					end
				else
					for i = last_index, _death_event_amt do --next index to 16
						if (t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert (esta_morte, t[i])
						end
					end
					for i = 1, last_index-1 do --1 to latest index
						if (t[i][4] and t[i][4]+_death_event_amt > time) then
							_table_insert (esta_morte, t[i])
						end
					end
				end

				--if (_detalhes.deadlog_limit and #esta_morte > _detalhes.deadlog_limit) then
				--	while (#esta_morte > _detalhes.deadlog_limit) do
				--		_table_remove (esta_morte, 1)
				--	end
				--end
				
				if (este_jogador.last_cooldown) then
					local t = {}
					t [1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t [2] = este_jogador.last_cooldown[2] --> spellid || false if this is a battle ress line
					t [3] = 1 --> amount of damage or healing
					t [4] = este_jogador.last_cooldown[1] --> parser time
					t [5] = 0 --> current unit heal
					t [6] = alvo_name --> source name
					esta_morte [#esta_morte+1] = t
				else
					local t = {}
					t [1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t [2] = 0 --> spellid || false if this is a battle ress line
					t [3] = 0 --> amount of damage or healing
					t [4] = 0 --> parser time
					t [5] = 0 --> current unit heal
					t [6] = alvo_name --> source name
					esta_morte [#esta_morte+1] = t
				end
				
				local decorrido = _GetTime() - _current_combat:GetStartTime()
				local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
				
				local t = {esta_morte, time, este_jogador.nome, este_jogador.classe, _UnitHealthMax (alvo_name), minutos.."m "..segundos.."s",  ["dead"] = true, ["last_cooldown"] = este_jogador.last_cooldown, ["dead_at"] = decorrido}
				_table_insert (_current_combat.last_events_tables, #_current_combat.last_events_tables+1, t)
				
				if (_hook_deaths) then
					--> send event to registred functions
					local death_at = _GetTime() - _current_combat:GetStartTime()
					local max_health = _UnitHealthMax (alvo_name)

					for _, func in _ipairs (_hook_deaths_container) do 
						local copiedDeathTable = table_deepcopy(t)
						local successful, errortext = pcall(func, nil, token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, copiedDeathTable, este_jogador.last_cooldown, death_at, max_health)
						if (not successful) then
							_detalhes:Msg ("error occurred on a death hook function:", errortext)
						end
					end
				end

				--> check if this is a mythic+ run
				local mythicLevel = C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo() --classic wow doesn't not have C_ChallengeMode API
				if (mythicLevel and type (mythicLevel) == "number" and mythicLevel >= 2) then --several checks to be future proof
					--> more checks for integrity
					if (_detalhes.tabela_overall and _detalhes.tabela_overall.last_events_tables) then
						--> this is a mythi dungeon run, add the death to overall data
						--> need to adjust the time of death, since this will show all deaths in the mythic run
						--> first copy the table
						local overallDeathTable = DetailsFramework.table.copy ({}, t)
						
						--> get the elapsed time
						local decorrido = _GetTime() - _detalhes.tabela_overall:GetStartTime()
						local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
						
						overallDeathTable [6] = minutos.."m "..segundos.."s"
						overallDeathTable.dead_at = decorrido
						
						_table_insert (_detalhes.tabela_overall.last_events_tables, #_detalhes.tabela_overall.last_events_tables + 1, overallDeathTable)
					end
				end

				--> reseta a pool
				last_events_cache [alvo_name] = nil
			end
		end
	end

	function parser:environment (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, env_type, amount)
	
		local spelid
	
		if (env_type == "Falling") then
			who_name = ENVIRONMENTAL_FALLING_NAME
			spelid = 3
		elseif (env_type == "Drowning") then
			who_name = ENVIRONMENTAL_DROWNING_NAME
			spelid = 4
		elseif (env_type == "Fatigue") then
			who_name = ENVIRONMENTAL_FATIGUE_NAME
			spelid = 5
		elseif (env_type == "Fire") then
			who_name = ENVIRONMENTAL_FIRE_NAME
			spelid = 6
		elseif (env_type == "Lava") then
			who_name = ENVIRONMENTAL_LAVA_NAME
			spelid = 7
		elseif (env_type == "Slime") then
			who_name = ENVIRONMENTAL_SLIME_NAME
			spelid = 8
		end
	
		return parser:spell_dmg (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spelid or 1, env_type, 00000003, amount, -1, 1) --> localize-me
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core
	
	function parser:WipeSourceCache()
		wipe (monk_guard_talent)
	end

	local token_list = {
		-- neutral
		["SPELL_SUMMON"] = parser.summon,
		--["SPELL_CAST_FAILED"] = parser.spell_fail
	}

	--serach key: ~capture

	_detalhes.capture_types = {"damage", "heal", "energy", "miscdata", "aura", "spellcast"}
	_detalhes.capture_schedules = {}

	function _detalhes:CaptureIsAllEnabled()
		for _, _thisType in _ipairs (_detalhes.capture_types) do 
			if (not _detalhes.capture_real [_thisType]) then
				return false
			end
		end
		return true
	end
	
	function _detalhes:CaptureIsEnabled (capture)
		if (_detalhes.capture_real [capture]) then
			return true
		end
		return false
	end
	
	function _detalhes:CaptureRefresh()
		for _, _thisType in _ipairs (_detalhes.capture_types) do 
			if (_detalhes.capture_current [_thisType]) then
				_detalhes:CaptureEnable (_thisType)
			else
				_detalhes:CaptureDisable (_thisType)
			end
		end
	end
	
	function _detalhes:CaptureGet (capture_type)
		return _detalhes.capture_real [capture_type]
	end

	function _detalhes:CaptureSet (on_off, capture_type, real, time)

		if (on_off == nil) then
			on_off = _detalhes.capture_real [capture_type]
		end
	
		if (real) then
			--> hard switch
			_detalhes.capture_real [capture_type] = on_off
			_detalhes.capture_current [capture_type] = on_off
		else
			--> soft switch
			_detalhes.capture_current [capture_type] = on_off
			if (time) then
				local schedule_id = math.random (1, 10000000)
				local new_schedule = _detalhes:ScheduleTimer ("CaptureTimeout", time, {capture_type, schedule_id})
				tinsert (_detalhes.capture_schedules, {new_schedule, schedule_id})
			end
		end
		
		_detalhes:CaptureRefresh()
	end

	function _detalhes:CancelAllCaptureSchedules()
		for i = 1, #_detalhes.capture_schedules do
			local schedule_table, schedule_id = unpack (_detalhes.capture_schedules[i])
			_detalhes:CancelTimer (schedule_table)
		end
		_table_wipe (_detalhes.capture_schedules)
	end
	
	function _detalhes:CaptureTimeout (table)
		local capture_type, schedule_id = unpack (table)
		_detalhes.capture_current [capture_type] = _detalhes.capture_real [capture_type]
		_detalhes:CaptureRefresh()
		
		for index, table in ipairs (_detalhes.capture_schedules) do
			local id = table [2]
			if (schedule_id == id) then
				tremove (_detalhes.capture_schedules, index)
				break
			end
		end
	end

	function _detalhes:CaptureDisable (capture_type)

		capture_type = string.lower (capture_type)
		
		if (capture_type == "damage") then
			token_list ["SPELL_PERIODIC_DAMAGE"] = nil
			token_list ["SPELL_EXTRA_ATTACKS"] = nil
			token_list ["SPELL_DAMAGE"] = nil
			token_list ["SWING_DAMAGE"] = nil
			token_list ["RANGE_DAMAGE"] = nil
			token_list ["DAMAGE_SHIELD"] = nil
			token_list ["DAMAGE_SPLIT"] = nil
			token_list ["RANGE_MISSED"] = nil
			token_list ["SWING_MISSED"] = nil
			token_list ["SPELL_MISSED"] = nil
			token_list ["SPELL_BUILDING_MISSED"] = nil
			token_list ["SPELL_PERIODIC_MISSED"] = nil
			token_list ["DAMAGE_SHIELD_MISSED"] = nil
			token_list ["ENVIRONMENTAL_DAMAGE"] = nil
			token_list ["SPELL_BUILDING_DAMAGE"] = nil
		
		elseif (capture_type == "heal") then
			token_list ["SPELL_HEAL"] = nil
			token_list ["SPELL_PERIODIC_HEAL"] = nil
			token_list ["SPELL_HEAL_ABSORBED"] = nil
			token_list ["SPELL_ABSORBED"] = nil
			_recording_healing = false
		
		elseif (capture_type == "aura") then
			token_list ["SPELL_AURA_APPLIED"] = parser.buff
			token_list ["SPELL_AURA_REMOVED"] = parser.unbuff
			token_list ["SPELL_AURA_REFRESH"] = parser.buff_refresh
			token_list ["SPELL_AURA_APPLIED_DOSE"] = parser.buff_refresh
			_recording_buffs_and_debuffs = false
		
		elseif (capture_type == "energy") then
			token_list ["SPELL_ENERGIZE"] = nil
			token_list ["SPELL_PERIODIC_ENERGIZE"] = nil
		
		elseif (capture_type == "spellcast") then
			token_list ["SPELL_CAST_SUCCESS"] = nil
		
		elseif (capture_type == "miscdata") then
			-- dispell
			token_list ["SPELL_DISPEL"] = nil
			token_list ["SPELL_STOLEN"] = nil
			-- cc broke
			token_list ["SPELL_AURA_BROKEN"] = nil
			token_list ["SPELL_AURA_BROKEN_SPELL"] = nil
			-- ress
			token_list ["SPELL_RESURRECT"] = nil
			-- interrupt
			token_list ["SPELL_INTERRUPT"] = nil
			-- dead
			token_list ["UNIT_DIED"] = nil
			token_list ["UNIT_DESTROYED"] = nil
		
		end
	end

	--SPELL_DRAIN --> need research
	--SPELL_LEECH --> need research
	--SPELL_PERIODIC_DRAIN --> need research
	--SPELL_PERIODIC_LEECH --> need research
	--SPELL_DISPEL_FAILED --> need research
	--SPELL_BUILDING_HEAL --> need research
	
	function _detalhes:CaptureEnable (capture_type)

		capture_type = string.lower (capture_type)
		
		if (capture_type == "damage") then
			token_list ["SPELL_PERIODIC_DAMAGE"] = parser.spell_dmg
			token_list ["SPELL_EXTRA_ATTACKS"] = parser.spell_dmg_extra_attacks
			token_list ["SPELL_DAMAGE"] = parser.spell_dmg
			token_list ["SPELL_BUILDING_DAMAGE"] = parser.spell_dmg
			token_list ["SWING_DAMAGE"] = parser.swing
			token_list ["RANGE_DAMAGE"] = parser.range
			token_list ["DAMAGE_SHIELD"] = parser.spell_dmg
			token_list ["DAMAGE_SPLIT"] = parser.spell_dmg
			token_list ["RANGE_MISSED"] = parser.rangemissed
			token_list ["SWING_MISSED"] = parser.swingmissed
			token_list ["SPELL_MISSED"] = parser.missed
			token_list ["SPELL_PERIODIC_MISSED"] = parser.missed
			token_list ["SPELL_BUILDING_MISSED"] = parser.missed
			token_list ["DAMAGE_SHIELD_MISSED"] = parser.missed
			token_list ["ENVIRONMENTAL_DAMAGE"] = parser.environment

		elseif (capture_type == "heal") then
			token_list ["SPELL_HEAL"] = parser.heal
			token_list ["SPELL_PERIODIC_HEAL"] = parser.heal
			token_list ["SPELL_HEAL_ABSORBED"] = parser.heal_denied
			token_list ["SPELL_ABSORBED"] = parser.heal_absorb
			_recording_healing = true

		elseif (capture_type == "aura") then
			token_list ["SPELL_AURA_APPLIED"] = parser.buff
			token_list ["SPELL_AURA_REMOVED"] = parser.unbuff
			token_list ["SPELL_AURA_REFRESH"] = parser.buff_refresh
			token_list ["SPELL_AURA_APPLIED_DOSE"] = parser.buff_refresh
			_recording_buffs_and_debuffs = true

		elseif (capture_type == "energy") then
			token_list ["SPELL_ENERGIZE"] = parser.energize
			token_list ["SPELL_PERIODIC_ENERGIZE"] = parser.energize

		elseif (capture_type == "spellcast") then
			token_list ["SPELL_CAST_SUCCESS"] = parser.spellcast

		elseif (capture_type == "miscdata") then
			-- dispell
			token_list ["SPELL_DISPEL"] = parser.dispell
			token_list ["SPELL_STOLEN"] = parser.dispell
			-- cc broke
			token_list ["SPELL_AURA_BROKEN"] = parser.break_cc
			token_list ["SPELL_AURA_BROKEN_SPELL"] = parser.break_cc
			-- ress
			token_list ["SPELL_RESURRECT"] = parser.ress
			-- interrupt
			token_list ["SPELL_INTERRUPT"] = parser.interrupt
			-- dead
			token_list ["UNIT_DIED"] = parser.dead
			token_list ["UNIT_DESTROYED"] = parser.dead
			
		end

	end

	parser.original_functions = {
		["spell_dmg"] = parser.spell_dmg,
		["spell_dmg_extra_attacks"] = parser.spell_dmg_extra_attacks,
		["swing"] = parser.swing,
		["range"] = parser.range,
		["rangemissed"] = parser.rangemissed,
		["swingmissed"] = parser.swingmissed,
		["missed"] = parser.missed,
		["environment"] = parser.environment,
		["heal"] = parser.heal,
		["heal_absorb"] = parser.heal_absorb,
		["heal_denied"] = parser.heal_denied,
		["buff"] = parser.buff,
		["unbuff"] = parser.unbuff,
		["buff_refresh"] = parser.buff_refresh,
		["energize"] = parser.energize,
		["spellcast"] = parser.spellcast,
		["dispell"] = parser.dispell,
		["break_cc"] = parser.break_cc,
		["ress"] = parser.ress,
		["interrupt"] = parser.interrupt,
		["dead"] = parser.dead,
	}
	
	function parser:SetParserFunction (token, func)
		if (parser.original_functions [token]) then
			if (type (func) == "function") then
				parser [token] = func
			else
				parser [token] = parser.original_functions [token]
			end
			parser:RefreshFunctions()
		else
			return _detalhes:Msg ("Invalid Token for SetParserFunction.")
		end
	end
	
	local all_parser_tokens = {
		["SPELL_PERIODIC_DAMAGE"] = "spell_dmg",
		["SPELL_EXTRA_ATTACKS"] = "spell_dmg_extra_attacks",
		["SPELL_DAMAGE"] = "spell_dmg",
		["SPELL_BUILDING_DAMAGE"] = "spell_dmg",
		["SWING_DAMAGE"] = "swing",
		["RANGE_DAMAGE"] = "range",
		["DAMAGE_SHIELD"] = "spell_dmg",
		["DAMAGE_SPLIT"] = "spell_dmg",
		["RANGE_MISSED"] = "rangemissed",
		["SWING_MISSED"] = "swingmissed",
		["SPELL_MISSED"] = "missed",
		["SPELL_PERIODIC_MISSED"] = "missed",
		["SPELL_BUILDING_MISSED"] = "missed",
		["DAMAGE_SHIELD_MISSED"] = "missed",
		["ENVIRONMENTAL_DAMAGE"] = "environment",

		["SPELL_HEAL"] = "heal",
		["SPELL_PERIODIC_HEAL"] = "heal",
		["SPELL_HEAL_ABSORBED"] = "heal_denied",
		["SPELL_ABSORBED"] = "heal_absorb",

		["SPELL_AURA_APPLIED"] = "buff",
		["SPELL_AURA_REMOVED"] = "unbuff",
		["SPELL_AURA_REFRESH"] = "buff_refresh",
		["SPELL_AURA_APPLIED_DOSE"] = "buff_refresh",
		["SPELL_ENERGIZE"] = "energize",
		["SPELL_PERIODIC_ENERGIZE"] = "energize",
	
		["SPELL_CAST_SUCCESS"] = "spellcast",
		["SPELL_DISPEL"] = "dispell",
		["SPELL_STOLEN"] = "dispell",
		["SPELL_AURA_BROKEN"] = "break_cc",
		["SPELL_AURA_BROKEN_SPELL"] = "break_cc",
		["SPELL_RESURRECT"] = "ress",
		["SPELL_INTERRUPT"] = "interrupt",
		["UNIT_DIED"] = "dead",
		["UNIT_DESTROYED"] = "dead",
	}
	
	function parser:RefreshFunctions()
		for CLUE_ID, token in pairs (all_parser_tokens) do
			if (token_list [CLUE_ID]) then --> not disabled
				token_list [CLUE_ID] = parser [token]
			end
		end
	end
	
	function _detalhes:CallWipe (from_slash)
		if (_detalhes.wipe_called) then
			if (from_slash) then
				return _detalhes:Msg (Loc ["STRING_WIPE_ERROR1"])
			else
				return
			end
		elseif (not _detalhes.encounter_table.id) then
			if (from_slash) then
				return _detalhes:Msg (Loc ["STRING_WIPE_ERROR2"])
			else
				return
			end
		end
		
		local eTable = _detalhes.encounter_table
		
		--> finish the encounter
		local successful_ended = _detalhes.parser_functions:ENCOUNTER_END (eTable.id, eTable.name, eTable.diff, eTable.size, 0)
	
		if (successful_ended) then
			--> we wiped
			_detalhes.wipe_called = true
			
			--> cancel the on going captures schedules
			_detalhes:CancelAllCaptureSchedules()
			
			--> disable it
			_detalhes:CaptureSet (false, "damage", false)
			_detalhes:CaptureSet (false, "energy", false)
			_detalhes:CaptureSet (false, "aura", false)
			_detalhes:CaptureSet (false, "energy", false)
			_detalhes:CaptureSet (false, "spellcast", false)
			
			if (from_slash) then
				if (UnitIsGroupLeader ("player")) then
					_detalhes:SendHomeRaidData ("WI")
				end
			end
			
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _detalhes:GetInstance (lower_instance)
				lower_instance:InstanceAlert (Loc ["STRING_WIPE_ALERT"], {[[Interface\CHARACTERFRAME\UI-StateIcon]], 18, 18, false, 0.5, 1, 0, 0.5}, 4)
			end
		else
			if (from_slash) then
				return _detalhes:Msg (Loc ["STRING_WIPE_ERROR3"])
			else
				return
			end
		end

	end

	-- PARSER
	--serach key: ~parser ~events ~start ~inicio
	
	function _detalhes:FlagCurrentCombat()
		if (_detalhes.is_in_battleground) then
			_detalhes.tabela_vigente.pvp = true
			_detalhes.tabela_vigente.is_pvp = {name = _detalhes.zone_name, mapid = _detalhes.zone_id}
		elseif (_detalhes.is_in_arena) then
			_detalhes.tabela_vigente.arena = true
			_detalhes.tabela_vigente.is_arena = {name = _detalhes.zone_name, zone = _detalhes.zone_name, mapid = _detalhes.zone_id}
		end
	end
	
	function _detalhes:GetZoneType()
		return _detalhes.zone_type
	end
	function _detalhes.parser_functions:ZONE_CHANGED_NEW_AREA (...)
		return _detalhes:ScheduleTimer ("Check_ZONE_CHANGED_NEW_AREA", 0.5)
	end
	
	function _detalhes:Check_ZONE_CHANGED_NEW_AREA (...)
		local zoneName, zoneType, _, _, _, _, _, zoneMapID = _GetInstanceInfo()
		--print (GetInstanceInfo())
		
		_detalhes.zone_type = zoneType
		_detalhes.zone_id = zoneMapID
		_detalhes.zone_name = zoneName

		_in_resting_zone = IsResting()
		
		parser:WipeSourceCache()
		
		_is_in_instance = false
		
		if (zoneType == "party" or zoneType == "raid") then
			_is_in_instance = true
		end
		
		if (_detalhes.last_zone_type ~= zoneType) then
			_detalhes:SendEvent ("ZONE_TYPE_CHANGED", nil, zoneType)
			_detalhes.last_zone_type = zoneType
			
			for index, instancia in ipairs (_detalhes.tabela_instancias) do 
				if (instancia.ativa) then
					instancia:AdjustAlphaByContext(true)
				end
			end
		end
		
		_detalhes.time_type = _detalhes.time_type_original
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) zone change:", _detalhes.zone_name, "is a", _detalhes.zone_type, "zone.")
		end
		
		if (_detalhes.is_in_arena and zoneType ~= "arena") then
			_detalhes:LeftArena()
		end
		if (_detalhes.is_in_battleground and zoneType ~= "pvp") then
			_detalhes.pvp_parser_frame:StopBgUpdater()
			_detalhes.is_in_battleground = nil
			_detalhes.time_type = _detalhes.time_type_original
		end
		
		if (zoneType == "pvp") then --> battlegrounds

			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) zone type is now 'pvp'.")
			end
			
			_detalhes.is_in_battleground = true
			
			if (_in_combat and not _current_combat.pvp) then
				_detalhes:SairDoCombate()
			end
			
			if (not _in_combat) then
				_detalhes:EntrarEmCombate()
			end
			
			_current_combat.pvp = true
			_current_combat.is_pvp = {name = zoneName, mapid = zoneMapID}
			
			if (_detalhes.use_battleground_server_parser) then
				if (_detalhes.time_type == 1) then
					_detalhes.time_type_original = 1
					_detalhes.time_type = 2
				end
				_detalhes.pvp_parser_frame:StartBgUpdater()
			else
				if (_detalhes.force_activity_time_pvp) then
					_detalhes.time_type_original = _detalhes.time_type
					_detalhes.time_type = 1
				end
			end
		
		elseif (zoneType == "arena") then
		
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) zone type is now 'arena'.")
			end
		
			if (_detalhes.force_activity_time_pvp) then
				_detalhes.time_type_original = _detalhes.time_type
				_detalhes.time_type = 1
			end
		
			if (not _detalhes.is_in_arena) then
				--> reset spec cache if broadcaster requested
				if (_detalhes.streamer_config.reset_spec_cache) then
					wipe (_detalhes.cached_specs)
				end
			end
		
			_detalhes.is_in_arena = true
			_detalhes:EnteredInArena()
			
		else
			local inInstance = IsInInstance()
			if ((zoneType == "raid" or zoneType == "party") and inInstance) then
				_detalhes:CheckForAutoErase (zoneMapID)
				
				--> if the current raid is current tier raid, pre-load the storage database
				if (zoneType == "raid") then
					if (_detalhes.InstancesToStoreData [zoneMapID]) then
						_detalhes.ScheduleLoadStorage()
					end
				end
			end
		
			if (_detalhes:IsInInstance()) then
				_detalhes.last_instance = zoneMapID
			end
			
			--if (_current_combat.pvp) then 
			--	_current_combat.pvp = false
			--end
		end
		
		_detalhes:DispatchAutoRunCode ("on_zonechanged")
		
		_detalhes:SchedulePetUpdate (7)
		_detalhes:CheckForPerformanceProfile()
	end
	
	function _detalhes.parser_functions:PLAYER_ENTERING_WORLD (...)
		return _detalhes.parser_functions:ZONE_CHANGED_NEW_AREA (...)
	end
	
	-- ~encounter
	function _detalhes.parser_functions:ENCOUNTER_START (...)
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) |cFFFFFF00ENCOUNTER_START|r event triggered.")
		end
		
		_detalhes.latest_ENCOUNTER_END = _detalhes.latest_ENCOUNTER_END or 0
		if (_detalhes.latest_ENCOUNTER_END + 10 > _GetTime()) then
			return
		end

		--> leave the current combat when the encounter start, if is doing a mythic plus dungeons, check if the options allows to create a dedicated segment for the boss fight
		if ((_in_combat and not _detalhes.tabela_vigente.is_boss) and (not _detalhes.MythicPlus.Started or _detalhes.mythic_plus.boss_dedicated_segment)) then
			_detalhes:SairDoCombate()
		end
		
		local encounterID, encounterName, difficultyID, raidSize = _select (1, ...)
		local zoneName, _, _, _, _, _, _, zoneMapID = _GetInstanceInfo()

		if (_detalhes.InstancesToStoreData[zoneMapID]) then
			Details.current_exp_raid_encounters[encounterID] = true
		end
		
		if (not _detalhes.WhoAggroTimer and _detalhes.announce_firsthit.enabled) then
			_detalhes.WhoAggroTimer = C_Timer.NewTimer (0.5, who_aggro)
		end
		
		if (IsInGuild() and IsInRaid() and _detalhes.announce_damagerecord.enabled and _detalhes.StorageLoaded) then
			_detalhes.TellDamageRecord = C_Timer.NewTimer (0.6, _detalhes.PrintEncounterRecord)
			_detalhes.TellDamageRecord.Boss = encounterID
			_detalhes.TellDamageRecord.Diff = difficultyID
		end

		_current_encounter_id = encounterID
		--Details:Msg("encounter started:", encounterID, encounterName)
		_detalhes.boss1_health_percent = 1
		
		local dbm_mod, dbm_time = _detalhes.encounter_table.DBM_Mod, _detalhes.encounter_table.DBM_ModTime
		_table_wipe (_detalhes.encounter_table)
		
		--print (encounterID, encounterName, difficultyID, raidSize)
		_detalhes.encounter_table.phase = 1
		
		--store the encounter time inside the encounter table for the encounter plugin
		_detalhes.encounter_table.start = GetTime()
		_detalhes.encounter_table ["end"] = nil
--		local encounterID = Details.encounter_table.id
		_detalhes.encounter_table.id = encounterID
		_detalhes.encounter_table.name = encounterName
		_detalhes.encounter_table.diff = difficultyID
		_detalhes.encounter_table.size = raidSize
		_detalhes.encounter_table.zone = zoneName
		_detalhes.encounter_table.mapid = zoneMapID
		
		if (dbm_mod and dbm_time == time()) then --pode ser time() � usado no start pra saber se foi no mesmo segundo.
			_detalhes.encounter_table.DBM_Mod = dbm_mod
		end
		
		local encounter_start_table = _detalhes:GetEncounterStartInfo (zoneMapID, encounterID)
		if (encounter_start_table) then
			if (encounter_start_table.delay) then
				if (type (encounter_start_table.delay) == "function") then
					local delay = encounter_start_table.delay()
					if (delay) then
						--_detalhes.encounter_table ["start"] = time() + delay
						_detalhes.encounter_table ["start"] = _GetTime() + delay
					end
				else
					--_detalhes.encounter_table ["start"] = time() + encounter_start_table.delay
					_detalhes.encounter_table ["start"] = _GetTime() + encounter_start_table.delay
				end
			end
			if (encounter_start_table.func) then
				encounter_start_table:func()
			end
		end

		local encounter_table, boss_index = _detalhes:GetBossEncounterDetailsFromEncounterId (zoneMapID, encounterID)
		if (encounter_table) then
			_detalhes.encounter_table.index = boss_index
		end
		
		_detalhes:SendEvent ("COMBAT_ENCOUNTER_START", nil, ...)

		--print ("encounter staerted at:", _detalhes.encounter_table.start)
	end
	
	function _detalhes.parser_functions:ENCOUNTER_END (...)
	
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) |cFFFFFF00ENCOUNTER_END|r event triggered.")
		end
		
		_current_encounter_id = nil
		
		local _, instanceType = GetInstanceInfo() --> let's make sure it isn't a dungeon
		if (_detalhes.zone_type == "party" or instanceType == "party") then
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) the zone type is 'party', ignoring ENCOUNTER_END.")
			end
		end
	
		local encounterID, encounterName, difficultyID, raidSize, endStatus = _select (1, ...)
	
		if (not _detalhes.encounter_table.start) then
			Details:Msg("encounter table without start time.")
			return
		end
		
		_detalhes.latest_ENCOUNTER_END = _detalhes.latest_ENCOUNTER_END or 0
		if (_detalhes.latest_ENCOUNTER_END + 15 > _GetTime()) then
			return
		end

		_detalhes.latest_ENCOUNTER_END = _GetTime()
		_detalhes.encounter_table ["end"] = _GetTime() -- 0.351
		
		local _, _, _, _, _, _, _, zoneMapID = _GetInstanceInfo()
		
		if (_in_combat) then
			if (endStatus == 1) then
				_detalhes.encounter_table.kill = true
				_detalhes:SairDoCombate (true, {encounterID, encounterName, difficultyID, raidSize, endStatus}) --killed
			else
				_detalhes.encounter_table.kill = false
				_detalhes:SairDoCombate (false, {encounterID, encounterName, difficultyID, raidSize, endStatus}) --wipe
			end
		else
			if ((_detalhes.tabela_vigente:GetEndTime() or 0) + 2 >= _detalhes.encounter_table ["end"]) then
				_detalhes.tabela_vigente:SetStartTime (_detalhes.encounter_table ["start"])
				_detalhes.tabela_vigente:SetEndTime (_detalhes.encounter_table ["end"])
				_detalhes:RefreshMainWindow (-1, true)
			end
		end

		_detalhes:SendEvent ("COMBAT_ENCOUNTER_END", nil, ...)
		
		_table_wipe (_detalhes.encounter_table)
		_table_wipe (bargastBuffs) --remove on 10.0
		_table_wipe (necro_cheat_deaths) --remove on 10.0
		
		return true
	end
	
	function _detalhes.parser_functions:UNIT_PET (...)
		_detalhes.container_pets:Unpet (...)
		_detalhes:SchedulePetUpdate (1)
	end

	function _detalhes.parser_functions:PLAYER_REGEN_DISABLED (...)
		if (_detalhes.zone_type == "pvp" and not _detalhes.use_battleground_server_parser) then
			if (_in_combat) then
				_detalhes:SairDoCombate()
			end
			_detalhes:EntrarEmCombate()
		end
	
		if (not _detalhes:CaptureGet ("damage")) then
			_detalhes:EntrarEmCombate()
		end
	
		--> essa parte do solo mode ainda sera usada?
		if (_detalhes.solo and _detalhes.PluginCount.SOLO > 0) then --> solo mode
			local esta_instancia = _detalhes.tabela_instancias[_detalhes.solo]
			esta_instancia.atualizando = true
		end
		
		for index, instancia in ipairs (_detalhes.tabela_instancias) do 
			if (instancia.ativa) then --> 1 = none, we doesn't need to call
				instancia:AdjustAlphaByContext(true)
			end
		end
		
		_detalhes:DispatchAutoRunCode ("on_entercombat")
		
		_detalhes.tabela_vigente.CombatStartedAt = GetTime()
	end
	
	--in case the player left the raid during the encounter
	local check_for_encounter_end = function()
		if (not _current_encounter_id) then
			return
		end
		
		if (IsInRaid()) then
			--raid
			local inCombat = false
			for i = 1, GetNumGroupMembers() do
				if (UnitAffectingCombat ("raid" .. i)) then
					inCombat = true
					break
				end
			end
			
			if (not inCombat) then
				_current_encounter_id = nil
			end
			
		elseif (IsInGroup()) then
			--party (dungeon)
			local inCombat = false
			for i = 1, GetNumGroupMembers() -1 do
				if (UnitAffectingCombat ("party" .. i)) then
					inCombat = true
					break
				end
			end
			
			if (not inCombat) then
				_current_encounter_id = nil
			end
		
		else
			_current_encounter_id = nil
		end
	end
	
	--> this function is guaranteed to run after a combat is done
	--> can also run when the player leaves combat state (regen enabled)
	function _detalhes:RunScheduledEventsAfterCombat (OnRegenEnabled)
	
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) running scheduled events after combat end.")
		end
	
		--when the user requested data from the storage but is in combat lockdown
		if (_detalhes.schedule_storage_load) then
			_detalhes.schedule_storage_load = nil
			_detalhes.ScheduleLoadStorage()
		end
		
		--store a boss encounter when out of combat since it might need to load the storage
		if (_detalhes.schedule_store_boss_encounter) then
			if (not _detalhes.logoff_saving_data) then
				local successful, errortext = pcall (Details.Database.StoreEncounter)
				if (not successful) then
					_detalhes:Msg ("error occurred on Details.Database.StoreEncounter():", errortext)
				end
			end
			_detalhes.schedule_store_boss_encounter = nil
		end

		if (Details.schedule_store_boss_encounter_wipe) then
			if (not _detalhes.logoff_saving_data) then
				local successful, errortext = pcall (Details.Database.StoreWipe)
				if (not successful) then
					_detalhes:Msg ("error occurred on Details.Database.StoreWipe():", errortext)
				end
			end
			Details.schedule_store_boss_encounter_wipe = nil
		end
		
		--when a large amount of data has been removed and the player is in combat, schedule to run the hard garbage collector (the blizzard one, not the details! internal)
		if (_detalhes.schedule_hard_garbage_collect) then
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) found schedule collectgarbage().")
			end
			_detalhes.schedule_hard_garbage_collect = false
			collectgarbage()
		end
		
		for index, instancia in ipairs (_detalhes.tabela_instancias) do 
			if (instancia.ativa) then --> 1 = none, we doesn't need to call
				instancia:AdjustAlphaByContext(true)
			end
		end
		
		if (not OnRegenEnabled) then
			_table_wipe (bitfield_swap_cache)
			_table_wipe (ignore_actors)
			_detalhes:DispatchAutoRunCode ("on_leavecombat")
		end
		
		if (_detalhes.solo and _detalhes.PluginCount.SOLO > 0) then --code too old and I don't have documentation for it
			if (_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Stop) then
				_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Stop()
			end
		end
	
		--deprecated shcedules
		do
			if (_detalhes.schedule_add_to_overall and #_detalhes.schedule_add_to_overall > 0) then --deprecated (combat are now added immediatelly since there's no script run too long)
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) adding ", #_detalhes.schedule_add_to_overall, "combats in queue to overall data.")
				end
				
				for i = #_detalhes.schedule_add_to_overall, 1, -1 do
					local CombatToAdd = tremove (_detalhes.schedule_add_to_overall, i)
					if (CombatToAdd) then
						_detalhes.historico:adicionar_overall (CombatToAdd)
					end
				end
			end
			
			if (_detalhes.schedule_mythicdungeon_trash_merge) then --deprecated (combat are now added immediatelly since there's no script run too long)
				_detalhes.schedule_mythicdungeon_trash_merge = nil
				DetailsMythicPlusFrame.MergeTrashCleanup (true)
			end
			
			if (_detalhes.schedule_mythicdungeon_endtrash_merge) then --deprecated (combat are now added immediatelly since there's no script run too long)
				_detalhes.schedule_mythicdungeon_endtrash_merge = nil
				DetailsMythicPlusFrame.MergeRemainingTrashAfterAllBossesDone()
			end
			
			if (_detalhes.schedule_mythicdungeon_overallrun_merge) then --deprecated (combat are now added immediatelly since there's no script run too long)
				_detalhes.schedule_mythicdungeon_overallrun_merge = nil
				DetailsMythicPlusFrame.MergeSegmentsOnEnd()
			end
		
			if (_detalhes.schedule_flag_boss_components) then --deprecated (combat are now added immediatelly since there's no script run too long)
				_detalhes.schedule_flag_boss_components = false
				_detalhes:FlagActorsOnBossFight()
			end
			
			if (_detalhes.schedule_remove_overall) then --deprecated (combat are now added immediatelly since there's no script run too long)
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) found schedule overall data clean up.")
				end
				_detalhes.schedule_remove_overall = false
				_detalhes.tabela_historico:resetar_overall()
			end

			if (_detalhes.wipe_called and false) then --disabled
				_detalhes.wipe_called = nil
				_detalhes:CaptureSet (nil, "damage", true)
				_detalhes:CaptureSet (nil, "energy", true)
				_detalhes:CaptureSet (nil, "aura", true)
				_detalhes:CaptureSet (nil, "energy", true)
				_detalhes:CaptureSet (nil, "spellcast", true)
				
				_detalhes:CaptureSet (false, "damage", false, 10)
				_detalhes:CaptureSet (false, "energy", false, 10)
				_detalhes:CaptureSet (false, "aura", false, 10)
				_detalhes:CaptureSet (false, "energy", false, 10)
				_detalhes:CaptureSet (false, "spellcast", false, 10)
			end
		end


	end
	
	function _detalhes.parser_functions:CHALLENGE_MODE_START (...)
		--> send mythic dungeon start event
		local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
		if (difficultyID == 8) then
			_detalhes:SendEvent ("COMBAT_MYTHICDUNGEON_START")
		end
	
	end
	
	function _detalhes.parser_functions:CHALLENGE_MODE_COMPLETED (...)
		--> send mythic dungeon end event
		local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
		if (difficultyID == 8) then
			_detalhes:SendEvent ("COMBAT_MYTHICDUNGEON_END")
		end
		
	end

	function _detalhes.parser_functions:PLAYER_REGEN_ENABLED (...)

		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) |cFFFFFF00PLAYER_REGEN_ENABLED|r event triggered.")

			print ("combat lockdown:", InCombatLockdown())
			print ("affecting combat:", UnitAffectingCombat ("player"))
			
			if (_current_encounter_id and IsInInstance()) then
				print ("has a encounter ID")
				print ("player is dead:", UnitHealth ("player") < 1)
			end
		end

		--elapsed combat time
		_detalhes.LatestCombatDone = GetTime()
		_detalhes.tabela_vigente.CombatEndedAt = GetTime()
		_detalhes.tabela_vigente.TotalElapsedCombatTime = _detalhes.tabela_vigente.CombatEndedAt - (_detalhes.tabela_vigente.CombatStartedAt or 0)
		
		--
		C_Timer.After (10, check_for_encounter_end)

		--> playing alone, just finish the combat right now
		if (not _IsInGroup() and not IsInRaid()) then	
			_detalhes.tabela_vigente.playing_solo = true
			_detalhes:SairDoCombate()
			
		else
			--is in a raid or party group
			C_Timer.After (1, function()
				local inCombat
				if (IsInRaid()) then
					--raid
					local inCombat = false
					for i = 1, GetNumGroupMembers() do
						if (UnitAffectingCombat ("raid" .. i)) then
							inCombat = true
							break
						end
					end
					
					if (not inCombat) then
						_detalhes:RunScheduledEventsAfterCombat (true)
					end
					
				elseif (IsInGroup()) then
					--party (dungeon)
					local inCombat = false
					for i = 1, GetNumGroupMembers() -1 do
						if (UnitAffectingCombat ("party" .. i)) then
							inCombat = true
							break
						end
					end
					
					if (not inCombat) then
						_detalhes:RunScheduledEventsAfterCombat (true)
					end
				end
			end)
		end
		
	end
	
	function _detalhes.parser_functions:PLAYER_TALENT_UPDATE()
		if (IsInGroup() or IsInRaid()) then
			if (_detalhes.SendTalentTimer and not _detalhes.SendTalentTimer._cancelled) then
				_detalhes.SendTalentTimer:Cancel()
			end
			_detalhes.SendTalentTimer = C_Timer.NewTimer (11, function()
				_detalhes:SendCharacterData()
			end)
		end
	end
	
	function _detalhes.parser_functions:PLAYER_SPECIALIZATION_CHANGED()
	
		--some parts of details! does call this function, check first for past expansions
		if (DetailsFramework.IsClassicWow()) then
			return
		end
	
		local specIndex = DetailsFramework.GetSpecialization()
		if (specIndex) then
			local specID = DetailsFramework.GetSpecializationInfo (specIndex)
			if (specID and specID ~= 0) then
				local guid = UnitGUID ("player")
				if (guid) then
					_detalhes.cached_specs [guid] = specID
				end
			end
		end
		
		if (IsInGroup() or IsInRaid()) then
			if (_detalhes.SendTalentTimer and not _detalhes.SendTalentTimer._cancelled) then
				_detalhes.SendTalentTimer:Cancel()
			end
			_detalhes.SendTalentTimer = C_Timer.NewTimer (11, function()
				_detalhes:SendCharacterData()
			end)
		end
	end
	
	--> this is mostly triggered when the player enters in a dual against another player
	function _detalhes.parser_functions:UNIT_FACTION (unit)
	
		if (true) then
			--> disable until figure out how to make this work properlly
			--> at the moment this event is firing at bgs, arenas, etc making horde icons to show at random
			return
		end
	
		--> check if outdoors
		--unit was nil, nameplate might bug here, it should track after the event
		if (_detalhes.zone_type == "none" and unit) then
			local serial = UnitGUID (unit)
			--> the serial is valid and isn't THE player and the serial is from a player?
			if (serial and serial ~= UnitGUID ("player") and serial:find ("Player")) then
				_detalhes.duel_candidates [serial] = GetTime()
				
				local playerName = _detalhes:GetCLName (unit)
				
				--> check if the player is inside the current combat and flag the objects
				if (playerName and _current_combat) then
					local enemyPlayer1 = _current_combat:GetActor (1, playerName)
					local enemyPlayer2 = _current_combat:GetActor (2, playerName)
					local enemyPlayer3 = _current_combat:GetActor (3, playerName)
					local enemyPlayer4 = _current_combat:GetActor (4, playerName)
					if (enemyPlayer1) then
						--> set to show when the player is solo play
						enemyPlayer1.grupo = true
						enemyPlayer1.enemy = true
						if (IsInGroup()) then
							--> broadcast the enemy to group members so they can "watch" the damage
							
						end
					end
					if (enemyPlayer2) then
						enemyPlayer2.grupo = true
						enemyPlayer2.enemy = true
					end
					if (enemyPlayer3) then
						enemyPlayer3.grupo = true
						enemyPlayer3.enemy = true
					end
					if (enemyPlayer4) then
						enemyPlayer4.grupo = true
						enemyPlayer4.enemy = true
					end
				end
			end
		end
	end
	
	function _detalhes.parser_functions:ROLE_CHANGED_INFORM (...)
		if (_detalhes.last_assigned_role ~= _UnitGroupRolesAssigned ("player")) then
			_detalhes:CheckSwitchOnLogon (true)
			_detalhes.last_assigned_role = _UnitGroupRolesAssigned ("player")
		end
	end
	
	function _detalhes.parser_functions:PLAYER_ROLES_ASSIGNED (...)
		if (_detalhes.last_assigned_role ~= _UnitGroupRolesAssigned ("player")) then
			_detalhes:CheckSwitchOnLogon (true)
			_detalhes.last_assigned_role = _UnitGroupRolesAssigned ("player")
		end
	end
	
	function _detalhes:InGroup()
		return _detalhes.in_group
	end
	function _detalhes.parser_functions:GROUP_ROSTER_UPDATE (...)
		if (not _detalhes.in_group) then
			_detalhes.in_group = IsInGroup() or IsInRaid()
			if (_detalhes.in_group) then
				--> entrou num grupo
				_detalhes:IniciarColetaDeLixo (true)
				_detalhes:WipePets()
				_detalhes:SchedulePetUpdate (1)
				_detalhes:InstanceCall (_detalhes.AdjustAlphaByContext)
				
				_detalhes:CheckSwitchOnLogon()
				_detalhes:CheckVersion()
				_detalhes:SendEvent ("GROUP_ONENTER")
				
				_detalhes:DispatchAutoRunCode ("on_groupchange")
				
				wipe (_detalhes.trusted_characters)
				C_Timer.After (5, _detalhes.ScheduleSyncPlayerActorData)
			end
			
		else
			_detalhes.in_group = IsInGroup() or IsInRaid()
			
			if (not _detalhes.in_group) then
				--> saiu do grupo
				_detalhes:IniciarColetaDeLixo (true)
				_detalhes:WipePets()
				_detalhes:SchedulePetUpdate (1)
				_table_wipe (_detalhes.details_users)
				_detalhes:InstanceCall (_detalhes.AdjustAlphaByContext)
				_detalhes:CheckSwitchOnLogon()
				_detalhes:SendEvent ("GROUP_ONLEAVE")
				
				_detalhes:DispatchAutoRunCode ("on_groupchange")
				
				wipe (_detalhes.trusted_characters)
			else
				--> ainda esta no grupo
				_detalhes:SchedulePetUpdate (2)
				
				--> send char data
				if (_detalhes.SendCharDataOnGroupChange and not _detalhes.SendCharDataOnGroupChange._cancelled) then
					return
				end
				_detalhes.SendCharDataOnGroupChange = C_Timer.NewTimer (11, function()
					_detalhes:SendCharacterData()
					_detalhes.SendCharDataOnGroupChange = nil
				end)

			end
		end
		
		_detalhes:SchedulePetUpdate (6)
	end

	function _detalhes.parser_functions:START_TIMER (...)
	
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) found a timer.")
		end
	
		--if (C_Scenario.IsChallengeMode() and _detalhes.overall_clear_newchallenge) then
--		if (_detalhes.overall_clear_newchallenge) then --C_Scenario.IsChallengeMode() and  parece que n�o existe mais
--			_detalhes.historico:resetar_overall()
--			if (_detalhes.debug) then
--				_detalhes:Msg ("(debug) timer is a challenge mode start.")
--			end
		
	
		if (_detalhes.is_in_arena) then
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) timer is an arena countdown.")
			end
			_detalhes:StartArenaSegment (...)
		
		elseif (_detalhes.is_in_battleground) then
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) timer is a battleground countdown.")
			end
			
			local timerType, timeSeconds, totalTime = select (1, ...)
			
			if (_detalhes.start_battleground) then
				_detalhes:CancelTimer (_detalhes.start_battleground, true)
			end
			
			_detalhes.start_battleground = _detalhes:ScheduleTimer ("CreateBattlegroundSegment", timeSeconds)
		end
	end
	
	function _detalhes:CreateBattlegroundSegment()
		if (_in_combat) then
			_detalhes.tabela_vigente.discard_segment = true
			_detalhes:SairDoCombate()
		end
		_detalhes:EntrarEmCombate()
	end

	-- ~load
	local start_details = function()
		if (not _detalhes.gump) then
			--> failed to load the framework.
			
			if (not _detalhes.instance_load_failed) then
				_detalhes:CreatePanicWarning()
			end
			_detalhes.instance_load_failed.text:SetText ("Framework for Details! isn't loaded.\nIf you just updated the addon, please reboot the game client.\nWe apologize for the inconvenience and thank you for your comprehension.")
			
			return
		end
	
		--> cooltip
		if (not _G.GameCooltip) then
			_detalhes.popup = _G.GameCooltip
		else
			_detalhes.popup = _G.GameCooltip
		end
	
		--> check group
		_detalhes.in_group = IsInGroup() or IsInRaid()
	
		--> write into details object all basic keys and default profile
		_detalhes:ApplyBasicKeys()
		--> check if is first run, update keys for character and global data
		_detalhes:LoadGlobalAndCharacterData()
		
		--> details updated and not reopened the game client
		if (_detalhes.FILEBROKEN) then
			return
		end
		
		--> load all the saved combats
		_detalhes:LoadCombatTables()
		--> load the profiles
		_detalhes:LoadConfig()
		
		_detalhes:UpdateParserGears()

		--load auto run code
		Details:StartAutoRun()
	end
	
	function _detalhes.parser_functions:ADDON_LOADED (...)
		local addon_name = _select (1, ...)
		if (addon_name == "Details") then
			start_details()
		end	
	end
	
	local playerLogin = CreateFrame ("frame")
	playerLogin:RegisterEvent("PLAYER_LOGIN")
	playerLogin:SetScript("OnEvent", function()
		Details:StartMeUp()
	end)
	
	function _detalhes.parser_functions:PET_BATTLE_OPENING_START (...)
		_detalhes.pet_battle = true
		for index, instance in _ipairs (_detalhes.tabela_instancias) do
			if (instance.ativa) then
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) hidding windows for Pet Battle.")
				end
				instance:SetWindowAlphaForCombat (true, true, 0)
			end
		end
	end
	
	function _detalhes.parser_functions:PET_BATTLE_CLOSE (...)
		_detalhes.pet_battle = false
		for index, instance in _ipairs (_detalhes.tabela_instancias) do
			if (instance.ativa) then
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) Pet Battle finished, calling AdjustAlphaByContext().")
				end
				instance:AdjustAlphaByContext(true)
			end
		end
	end
	
	function _detalhes.parser_functions:UNIT_NAME_UPDATE (...)
		_detalhes:SchedulePetUpdate (5)
	end
	
	local parser_functions = _detalhes.parser_functions
	
	function _detalhes:OnEvent (evento, ...)
		local func = parser_functions [evento]
		if (func) then
			return func (nil, ...)
		end
	end

	_detalhes.listener:SetScript ("OnEvent", _detalhes.OnEvent)

	--> logout function ~save ~logout
	
	local saver = CreateFrame ("frame", nil, UIParent)
	saver:RegisterEvent ("PLAYER_LOGOUT")
	saver:SetScript ("OnEvent", function (...)
		
		if (not _detalhes.gump) then
			--> failed to load the framework.
			return
		end
		
		local saver_error = function (errortext)
			_detalhes_global = _detalhes_global or {}
			_detalhes_global.exit_errors = _detalhes_global.exit_errors or {}
			
			tinsert (_detalhes_global.exit_errors, 1, _detalhes.userversion .. " " .. errortext)
			tremove (_detalhes_global.exit_errors, 6)
		end
		
		_detalhes_global.exit_log = {}
		
		_detalhes.saver_error_func = saver_error
		
		_detalhes.logoff_saving_data = true
	
		--> close info window
			if (_detalhes.FechaJanelaInfo) then
				tinsert (_detalhes_global.exit_log, "1 - Closing Janela Info.")
				xpcall (_detalhes.FechaJanelaInfo, saver_error)
			end
			
		--> do not save window pos
			if (_detalhes.tabela_instancias) then
				tinsert (_detalhes_global.exit_log, "2 - Clearing user place from instances.")
				for id, instance in _detalhes:ListInstances() do
					if (instance.baseframe) then
						instance.baseframe:SetUserPlaced (false)
						instance.baseframe:SetDontSavePosition (true)
					end
				end
			end

		--> leave combat start save tables
			if (_detalhes.in_combat and _detalhes.tabela_vigente) then 
				tinsert (_detalhes_global.exit_log, "3 - Leaving current combat.")
				xpcall (_detalhes.SairDoCombate, saver_error)
				_detalhes.can_panic_mode = true
			end
			
			if (_detalhes.CheckSwitchOnLogon and _detalhes.tabela_instancias[1] and _detalhes.tabela_instancias and getmetatable (_detalhes.tabela_instancias[1])) then
				tinsert (_detalhes_global.exit_log, "4 - Reversing switches.")
				xpcall (_detalhes.CheckSwitchOnLogon, saver_error)
			end
			
			if (_detalhes.wipe_full_config) then
				tinsert (_detalhes_global.exit_log, "5 - Is a full config wipe.")
				_detalhes_global = nil
				_detalhes_database = nil
				return
			end
		
		--> save the config
			tinsert (_detalhes_global.exit_log, "6 - Saving Config.")
			xpcall (_detalhes.SaveConfig, saver_error)
			tinsert (_detalhes_global.exit_log, "7 - Saving Profiles.")
			xpcall (_detalhes.SaveProfile, saver_error)

		--> save the nicktag cache
			tinsert (_detalhes_global.exit_log, "8 - Saving nicktag cache.")
			_detalhes_database.nick_tag_cache = table_deepcopy (_detalhes_database.nick_tag_cache)
	end)
	
	--> end
	
	-- ~parserstart ~startparser ~cleu

	function _detalhes.OnParserEvent()
		-- 8.0 changed
		local time, token, hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12 = _CombatLogGetCurrentEventInfo()
		
		local funcao = token_list [token]
		if (funcao) then
			return funcao (nil, token, time, who_serial, who_name, who_flags, target_serial, target_name, target_flags, target_flags2, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12)
		else
			return
		end
	end
	
	_detalhes.parser_frame:SetScript ("OnEvent", _detalhes.OnParserEvent)

	function _detalhes:UpdateParser()
		_tempo = _detalhes._tempo
	end
	function _detalhes:UpdatePetsOnParser()
		container_pets = _detalhes.tabela_pets.pets
	end

	function _detalhes:PrintParserCacheIndexes()
	
		local amount = 0
		for n, nn in pairs (damage_cache) do 
			amount = amount + 1
		end
		print ("parser damage_cache", amount)
		
		amount = 0
		for n, nn in pairs (damage_cache_pets) do 
			amount = amount + 1
		end
		print ("parser damage_cache_pets", amount)
		
		amount = 0
		for n, nn in pairs (damage_cache_petsOwners) do 
			amount = amount + 1
		end
		print ("parser damage_cache_petsOwners", amount)
		
		amount = 0
		for n, nn in pairs (healing_cache) do 
			amount = amount + 1
		end
		print ("parser healing_cache", amount)
		
		amount = 0
		for n, nn in pairs (energy_cache) do 
			amount = amount + 1
		end
		print ("parser energy_cache", amount)

		amount = 0
		for n, nn in pairs (misc_cache) do 
			amount = amount + 1
		end
		print ("parser misc_cache", amount)
		print ("group damage", #_detalhes.cache_damage_group)
		print ("group damage", #_detalhes.cache_healing_group)
	end

	function _detalhes:GetActorsOnDamageCache()
		return _detalhes.cache_damage_group
	end
	function _detalhes:GetActorsOnHealingCache()
		return _detalhes.cache_healing_group
	end
	
	function _detalhes:ClearParserCache()
	
		_table_wipe (damage_cache)
		_table_wipe (damage_cache_pets)
		_table_wipe (damage_cache_petsOwners)
		_table_wipe (healing_cache)
		_table_wipe (energy_cache)
		_table_wipe (misc_cache)
		_table_wipe (misc_cache_pets)
		_table_wipe (misc_cache_petsOwners)
		_table_wipe (npcid_cache)
		
		_table_wipe (ignore_death)
		
		_table_wipe (reflection_damage)
		_table_wipe (reflection_debuffs)
		_table_wipe (reflection_events)
		_table_wipe (reflection_auras)
		_table_wipe (reflection_dispels)
	
		damage_cache = setmetatable ({}, _detalhes.weaktable)
		damage_cache_pets = setmetatable ({}, _detalhes.weaktable)
		damage_cache_petsOwners = setmetatable ({}, _detalhes.weaktable)
		
		healing_cache = setmetatable ({}, _detalhes.weaktable)
		
		energy_cache = setmetatable ({}, _detalhes.weaktable)
		
		misc_cache = setmetatable ({}, _detalhes.weaktable)
		misc_cache_pets = setmetatable ({}, _detalhes.weaktable)
		misc_cache_petsOwners = setmetatable ({}, _detalhes.weaktable)
	end
	
	function parser:RevomeActorFromCache (actor_serial, actor_name)
		if (actor_name) then
			damage_cache [actor_name] = nil
			damage_cache_pets [actor_name] = nil
			damage_cache_petsOwners [actor_name] = nil
			healing_cache [actor_serial] = nil
			energy_cache [actor_name] = nil
			misc_cache [actor_name] = nil
			misc_cache_pets [actor_name] = nil
			misc_cache_petsOwners [actor_name] = nil
		end
		if (actor_serial) then
			damage_cache [actor_serial] = nil
			damage_cache_pets [actor_serial] = nil
			damage_cache_petsOwners [actor_serial] = nil
			healing_cache [actor_serial] = nil
			energy_cache [actor_serial] = nil
			misc_cache [actor_serial] = nil
			misc_cache_pets [actor_serial] = nil
			misc_cache_petsOwners [actor_serial] = nil
		end
	end

	function _detalhes:UptadeRaidMembersCache()
	
		_table_wipe (raid_members_cache)
		_table_wipe (tanks_members_cache)
		_table_wipe (auto_regen_cache)
		_table_wipe (bitfield_swap_cache)
		_table_wipe (ignore_actors)
		
		local roster = _detalhes.tabela_vigente.raid_roster
		
		if (_IsInRaid()) then
			for i = 1, _GetNumGroupMembers() do 
				local name = _GetUnitName ("raid"..i, true)
				
				raid_members_cache [_UnitGUID ("raid"..i)] = true
				roster [name] = true
				
				local role = _UnitGroupRolesAssigned (name)
				if (role == "TANK") then
					tanks_members_cache [_UnitGUID ("raid"..i)] = true
				end
				
				if (auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("raid" .. i)]]) then
					auto_regen_cache [name] = auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("raid" .. i)]]
				end
			end
			
		elseif (_IsInGroup()) then
			--party
			for i = 1, _GetNumGroupMembers()-1 do 
				local name = _GetUnitName ("party"..i, true)
				
				raid_members_cache [_UnitGUID ("party"..i)] = true
				roster [name] = true
				
				local role = _UnitGroupRolesAssigned (name)
				if (role == "TANK") then
					tanks_members_cache [_UnitGUID ("party"..i)] = true
				end
				
				if (auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("party" .. i)]]) then
					auto_regen_cache [name] = auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("party" .. i)]]
				end
			end
			
			--player
			local name = GetUnitName ("player", true)
			
			raid_members_cache [_UnitGUID ("player")] = true
			roster [name] = true
			
			local role = _UnitGroupRolesAssigned (name)
			if (role == "TANK") then
				tanks_members_cache [_UnitGUID ("player")] = true
			end
			
			if (auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("player")]]) then
				auto_regen_cache [name] = auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("player")]]
			end
		else
			local name = GetUnitName ("player", true)
			
			raid_members_cache [_UnitGUID ("player")] = true
			roster [name] = true
			
			local role = _UnitGroupRolesAssigned (name)
			if (role == "TANK") then
				tanks_members_cache [_UnitGUID ("player")] = true
			else
				local spec = DetailsFramework.GetSpecialization()
				if (spec and spec ~= 0) then
					if (DetailsFramework.GetSpecializationRole (spec) == "TANK") then
						tanks_members_cache [_UnitGUID ("player")] = true
					end
				end
			end
			
			if (auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("player")]]) then
				auto_regen_cache [name] = auto_regen_power_specs [_detalhes.cached_specs [_UnitGUID ("player")]]
			end
		end

		local orderNames = {}
		for playerName in pairs(roster) do
			orderNames[#orderNames+1] = playerName
		end
		table.sort(orderNames, function(name1, name2)
			return string.len(name1) > string.len(name2)
		end)
		_detalhes.tabela_vigente.raid_roster_indexed = orderNames

		
		if (_detalhes.iam_a_tank) then
			tanks_members_cache [_UnitGUID ("player")] = true
		end
	end

	function _detalhes:IsATank (playerguid)
		return tanks_members_cache [playerguid]
	end
	
	function _detalhes:IsInCache (playerguid)
		return raid_members_cache [playerguid]
	end
	function _detalhes:GetParserPlayerCache()
		return raid_members_cache
	end
	
	--serach key: ~cache
	function _detalhes:UpdateParserGears()
	
		--> refresh combat tables
		_current_combat = _detalhes.tabela_vigente
		_current_combat_cleu_events = _current_combat and _current_combat.cleu_events
		
		--> last events pointer
		last_events_cache = _current_combat.player_last_events
		_death_event_amt = _detalhes.deadlog_events
		
		--> refresh total containers
		_current_total = _current_combat.totals
		_current_gtotal = _current_combat.totals_grupo
		
		--> refresh actors containers
		_current_damage_container = _current_combat [1]

		_current_heal_container = _current_combat [2]
		_current_energy_container = _current_combat [3]
		_current_misc_container = _current_combat [4]
		
		--> refresh data capture options
		_recording_self_buffs = _detalhes.RecordPlayerSelfBuffs
		--_recording_healing = _detalhes.RecordHealingDone
		--_recording_took_damage = _detalhes.RecordRealTimeTookDamage
		_recording_ability_with_buffs = _detalhes.RecordPlayerAbilityWithBuffs
		_in_combat = _detalhes.in_combat

		--> grab the ignored npcid directly from the user profile
		ignored_npcids = _detalhes.npcid_ignored

		if (_in_combat) then
			if (not _auto_regen_thread or _auto_regen_thread._cancelled) then
				_auto_regen_thread = C_Timer.NewTicker (AUTO_REGEN_PRECISION / 10, regen_power_overflow_check)
			end
		else
			if (_auto_regen_thread and not _auto_regen_thread._cancelled) then
				_auto_regen_thread:Cancel()
				_auto_regen_thread = nil
			end
		end
		
		if (_detalhes.hooks ["HOOK_COOLDOWN"].enabled) then
			_hook_cooldowns = true
		else
			_hook_cooldowns = false
		end
		
		if (_detalhes.hooks ["HOOK_DEATH"].enabled) then
			_hook_deaths = true
		else
			_hook_deaths = false
		end
		
		if (_detalhes.hooks ["HOOK_BATTLERESS"].enabled) then
			_hook_battleress = true
		else
			_hook_battleress = false
		end
		
		if (_detalhes.hooks ["HOOK_INTERRUPT"].enabled) then
			_hook_interrupt = true
		else
			_hook_interrupt = false
		end
		
		is_using_spellId_override = _detalhes.override_spellids
		
		return _detalhes:ClearParserCache()
	end
	
	
	
--serach key: ~api
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> number of combat
	function  _detalhes:GetCombatId()
		return _detalhes.combat_id
	end

	--> if in combat
	function _detalhes:IsInCombat()
		return _in_combat
	end
	
	function _detalhes:IsInEncounter()
		return _detalhes.encounter_table.id and true or false
	end

	--> get combat
	function _detalhes:GetCombat (_combat)
		if (not _combat) then
			return _current_combat
		elseif (_type (_combat) == "number") then
			if (_combat == -1) then --> overall
				return _detalhes.tabela_overall
			elseif (_combat == 0) then --> current
				return _current_combat
			else
				return _detalhes.tabela_historico.tabelas [_combat]
			end
		elseif (_type (_combat) == "string") then
			if (_combat == "overall") then
				return _detalhes.tabela_overall
			elseif (_combat == "current") then
				return _current_combat
			end
		end
		
		return nil
	end
	
	function _detalhes:GetAllActors (_combat, _actorname)
		return _detalhes:GetActor (_combat, 1, _actorname), _detalhes:GetActor (_combat, 2, _actorname), _detalhes:GetActor (_combat, 3, _actorname), _detalhes:GetActor (_combat, 4, _actorname)
	end
	
	--> get player
	function _detalhes:GetPlayer (_actorname, _combat, _attribute)
		return _detalhes:GetActor (_combat, _attribute, _actorname)
	end
	
	--> get an actor
	function _detalhes:GetActor (_combat, _attribute, _actorname)

		if (not _combat) then
			_combat = "current" --> current combat
		end
		
		if (not _attribute) then
			_attribute = 1 --> damage
		end
		
		if (not _actorname) then
			_actorname = _detalhes.playername
		end
		
		if (_combat == 0 or _combat == "current") then
			local actor = _detalhes.tabela_vigente (_attribute, _actorname)
			if (actor) then
				return actor
			else
				return nil --_detalhes:NewError ("Current combat doesn't have an actor called ".. _actorname)
			end
			
		elseif (_combat == -1 or _combat == "overall") then
			local actor = _detalhes.tabela_overall (_attribute, _actorname)
			if (actor) then
				return actor
			else
				return nil --_detalhes:NewError ("Combat overall doesn't have an actor called ".. _actorname)
			end
			
		elseif (type (_combat) == "number") then
			local _combatOnHistoryTables = _detalhes.tabela_historico.tabelas [_combat]
			if (_combatOnHistoryTables) then
				local actor = _combatOnHistoryTables (_attribute, _actorname)
				if (actor) then
					return actor
				else
					return nil --_detalhes:NewError ("Combat ".. _combat .." doesn't have an actor called ".. _actorname)
				end
			else
				return nil --_detalhes:NewError ("Combat ".._combat.." not found.")
			end
		else
			return nil --_detalhes:NewError ("Couldn't find a combat object for passed parameters")
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> battleground parser
	
	
	
	_detalhes.pvp_parser_frame:SetScript ("OnEvent", function (self, event)
		self:ReadPvPData()
	end)
	
	function _detalhes:BgScoreUpdate()
		RequestBattlefieldScoreData()
	end
	
	function _detalhes.pvp_parser_frame:StartBgUpdater()
	
		_detalhes.pvp_parser_frame:RegisterEvent ("UPDATE_BATTLEFIELD_SCORE")
		if (_detalhes.pvp_parser_frame.ticker) then
			_detalhes:CancelTimer (_detalhes.pvp_parser_frame.ticker)
		end
		_detalhes.pvp_parser_frame.ticker = _detalhes:ScheduleRepeatingTimer ("BgScoreUpdate", 10)
	end
	
	function _detalhes.pvp_parser_frame:StopBgUpdater()
		_detalhes.pvp_parser_frame:UnregisterEvent ("UPDATE_BATTLEFIELD_SCORE")
		_detalhes:CancelTimer (_detalhes.pvp_parser_frame.ticker)
		_detalhes.pvp_parser_frame.ticker = nil
	end
	
	function _detalhes.pvp_parser_frame:ReadPvPData()
	
		local players = GetNumBattlefieldScores()

		for i = 1, players do
		
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore (i)
			
			local actor = _detalhes.tabela_vigente (1, name)
			if (actor) then
				if (damageDone == 0) then
					damageDone = damageDone + _detalhes:GetOrderNumber()
				end
				actor.total = damageDone
				actor.classe = classToken or "UNKNOW"
				
			elseif (name ~= "Unknown" and type (name) == "string" and string.len (name) > 1) then
				local guid = _UnitGUID (name)
				if (guid) then
					local flag
					if (_detalhes.faction_id == faction) then --> is from the same faction
						flag = 0x514
					else
						flag = 0x548
					end
					actor = _current_damage_container:PegarCombatente (guid, name, flag, true)
					actor.total = _detalhes:GetOrderNumber()
					actor.classe = classToken or "UNKNOW"
					
					if (flag == 0x548) then
						--oponent
						actor.enemy = true
					end
				end
			end
			
			local actor = _detalhes.tabela_vigente (2, name)
			if (actor) then
				if (healingDone == 0) then
					healingDone = healingDone + _detalhes:GetOrderNumber()
				end
				actor.total = healingDone
				actor.classe = classToken or "UNKNOW"
			
			elseif (name ~= "Unknown" and type (name) == "string" and string.len (name) > 1) then
			--elseif (name ~= "Unknown") then
				local guid = _UnitGUID (name)
				if (guid) then
					local flag
					if (_detalhes.faction_id == faction) then --> is from the same faction
						flag = 0x514
					else
						flag = 0x548
					end
					actor = _current_heal_container:PegarCombatente (guid, name, flag, true)
					actor.total = _detalhes:GetOrderNumber()
					actor.classe = classToken or "UNKNOW"
					
					if (flag == 0x548) then
						--oponent
						actor.enemy = true
					end
				end
			end
			
		end
		
	end
	
	

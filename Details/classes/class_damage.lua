
--damage object
	local Details = _G.Details
	local Loc = LibStub("AceLocale-3.0"):GetLocale ( "Details" )
	local Translit = LibStub("LibTranslit-1.0")
	local gump = Details.gump
	local _ = nil
	local addonName, Details222 = ...

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local pointers

	local format = string.format --lua local
	local _math_floor = math.floor --lua local
	local _table_sort = table.sort --lua local
	local tinsert = table.insert --lua local
	local setmetatable = setmetatable --lua local
	local _getmetatable = getmetatable --lua local
	local ipairs = ipairs --lua local
	local pairs = pairs --lua local
	local _math_min = math.min --lua local
	local _math_max = math.max --lua local
	local abs = math.abs --lua local
	local bitBand = bit.band --lua local
	local unpack = unpack --lua local
	local type = type --lua local
	local GameTooltip = GameTooltip --api local
	local IsInRaid = IsInRaid --api local
	local IsInGroup = IsInGroup --api local

	local GetSpellInfo = GetSpellInfo --api local
	local _GetSpellInfo = Details.getspellinfo --details api
	local stringReplace = Details.string.replace --details api

	--show more information about spells
	local debugmode = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--constants

	local container_habilidades	= 	Details.container_habilidades
	local atributo_damage	=	Details.atributo_damage
	local atributo_misc		=	Details.atributo_misc
	local container_damage	=	Details.container_type.CONTAINER_DAMAGE_CLASS

	local modo_GROUP = Details.modos.group
	local modo_ALL = Details.modos.all

	local class_type = Details.atributos.dano

	local ToKFunctions = Details.ToKFunctions
	local SelectedToKFunction = ToKFunctions[1]

	local UsingCustomLeftText = false
	local UsingCustomRightText = false

	local FormatTooltipNumber = ToKFunctions[8]
	local TooltipMaximizedMethod = 1

	--local CLASS_ICON_TCOORDS = _G.CLASS_ICON_TCOORDS
	local is_player_class = Details.player_class

	Details.tooltip_key_overlay1 = {1, 1, 1, .2}
	Details.tooltip_key_overlay2 = {1, 1, 1, .5}

	Details.tooltip_key_size_width = 24
	Details.tooltip_key_size_height = 10

	local enemies_background = {value = 100, color = {0.1960, 0.1960, 0.1960, 0.8697}, texture = "Interface\\AddOns\\Details\\images\\bar_background2"}

	local headerColor = {1, 0.9, 0.0, 1}

	local info = Details.playerDetailWindow
	local keyName

	local OBJECT_TYPE_PLAYER =	0x00000400

	local ntable = {} --temp
	local vtable = {} --temp
	local tooltip_void_zone_temp = {} --temp
	local bs_table = {} --temp
	local bs_index_table = {} --temp
	local bs_tooltip_table
	local frags_tooltip_table

	local tooltip_temp_table = {}

	local OBJECT_TYPE_FRIENDLY_NPC 	=	0x00000A18

	local ignoredEnemyNpcsTable = {
		[31216] = true, --mirror image
		[53006] = true, --spirit link totem
		[63508] = true, --xuen
		[73967] = true, --xuen
	}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--exported functions

function Details:CreateActorLastEventTable() --[[exported]]
		local t = { {}, {}, {}, {}, {}, {}, {}, {} }
		t.n = 1
	return t
end

function atributo_damage:CreateFFTable(targetName) --[[exported]]
	local newTable = {total = 0, spells = {}}
	self.friendlyfire[targetName] = newTable
	return newTable
end

function Details:CreateActorAvoidanceTable(noOverall) --[[exported]]
	if (noOverall) then
		local avoidanceTable = {["ALL"] = 0, ["DODGE"] = 0, ["PARRY"] = 0, ["HITS"] = 0, ["ABSORB"] = 0, --quantas vezes foi dodge, parry, quandos hits tomou, quantos absorbs teve
			["FULL_HIT"] = 0, ["FULL_ABSORBED"] = 0, ["PARTIAL_ABSORBED"] = 0, --full hit full absorbed and partial absortion
			["FULL_HIT_AMT"] = 0, ["PARTIAL_ABSORB_AMT"] = 0, ["ABSORB_AMT"] = 0, ["FULL_ABSORB_AMT"] = 0, --amounts
			["BLOCKED_HITS"] = 0, ["BLOCKED_AMT"] = 0, --amount of hits blocked - amout of damage mitigated
		}
		return avoidanceTable
	else
		local avoidanceTable = {
			overall = {["ALL"] = 0, ["DODGE"] = 0, ["PARRY"] = 0, ["HITS"] = 0, ["ABSORB"] = 0, --quantas vezes foi dodge, parry, quandos hits tomou, quantos absorbs teve
			["FULL_HIT"] = 0, ["FULL_ABSORBED"] = 0, ["PARTIAL_ABSORBED"] = 0, --full hit full absorbed and partial absortion
			["FULL_HIT_AMT"] = 0, ["PARTIAL_ABSORB_AMT"] = 0, ["ABSORB_AMT"] = 0, ["FULL_ABSORB_AMT"] = 0, --amounts
			["BLOCKED_HITS"] = 0, ["BLOCKED_AMT"] = 0, --amount of hits blocked - amout of damage mitigated
		}
		}
		return avoidanceTable
	end
end

function Details.SortGroup(container, keyName2) --[[exported]]
	keyName = keyName2
	return _table_sort(container, Details.SortKeyGroup)
end

function Details.SortKeyGroup (table1, table2) --[[exported]]
	if (table1.grupo and table2.grupo) then
		return table1[keyName] > table2[keyName]

	elseif (table1.grupo and not table2.grupo) then
		return true

	elseif (not table1.grupo and table2.grupo) then
		return false

	else
		return table1[keyName] > table2[keyName]
	end
end


function Details.SortKeySimple(table1, table2) --[[exported]] 	
	return table1[keyName] > table2[keyName]
end


function Details:ContainerSort (container, amount, keyName2) --[[exported]] 	
	keyName = keyName2
	_table_sort(container,  Details.SortKeySimple)

	if (amount) then
		for i = amount, 1, -1 do --de tr�s pra frente
			if (container[i][keyName] < 1) then
				amount = amount-1
			else
				break
			end
		end

		return amount
	end
end

function Details:IsGroupPlayer() --[[exported]]
	return self.grupo
end


function Details:IsPetOrGuardian() --[[exported]]
	return self.owner and true or false
end

function Details:IsPlayer() --[[exported]]
	if (self.flag_original) then
		if (bitBand(self.flag_original, OBJECT_TYPE_PLAYER) ~= 0) then
			return true
		end
	end
	return false
end

function Details:IsNeutralOrEnemy() --[[exported]]
	if (self.flag_original) then
		if (bitBand(self.flag_original, 0x00000060) ~= 0) then
			local npcid1 = Details:GetNpcIdFromGuid(self.serial)
			if (ignoredEnemyNpcsTable[npcid1]) then
				return false
			end
			return true
		end
	end
	return false
end

function Details:IsFriendlyNpc() --[[exported]]
	local flag = self.flag_original
	if (flag) then
		if (bitBand(flag, 0x00000008) ~= 0) then
			if (bitBand(flag, 0x00000010) ~= 0) then
				if (bitBand(flag, 0x00000800) ~= 0) then
					return true
				end
			end
		end
	end
	return false
end

function Details:IsEnemy() --[[exported]]	
	if (self.flag_original) then
		if (bitBand(self.flag_original, 0x00000060) ~= 0) then
			local npcId = Details:GetNpcIdFromGuid(self.serial)
			if (ignoredEnemyNpcsTable[npcId]) then
				return false
			end
			return true
		end
	end
	return false
end
	
function Details:GetSpellList() --[[ exported]]
	return self.spells._ActorTable
end


function Details:GetTimeInCombat(petOwner) --[[exported]]
	if (petOwner) then
		if (Details.time_type == 1 or not petOwner.grupo) then
			return self:Tempo()
		elseif (Details.time_type == 2) then
			return self:GetCombatTime()
		end
	else
		if (Details.time_type == 1) then
			return self:Tempo()
		elseif (Details.time_type == 2) then
			return self:GetCombatTime()
		end
	end
end


--enemies(sort function)
local sortEnemies = function(t1, t2)
	local a = bitBand(t1.flag_original, 0x00000060)
	local b = bitBand(t2.flag_original, 0x00000060)

	if (a ~= 0 and b ~= 0) then
		local npcid1 = Details:GetNpcIdFromGuid(t1.serial)
		local npcid2 = Details:GetNpcIdFromGuid(t2.serial)

		if (not ignoredEnemyNpcsTable[npcid1] and not ignoredEnemyNpcsTable[npcid2]) then
			return t1.damage_taken > t2.damage_taken

		elseif (ignoredEnemyNpcsTable[npcid1] and not ignoredEnemyNpcsTable[npcid2]) then
			return false

		elseif (not ignoredEnemyNpcsTable[npcid1] and ignoredEnemyNpcsTable[npcid2]) then
			return true
		else
			return t1.damage_taken > t2.damage_taken
		end

	elseif (a ~= 0 and b == 0) then
		return true

	elseif (a == 0 and b ~= 0) then
		return false
	end

	return false
end

function Details:ContainerSortEnemies (container, amount, keyName2) --[[exported]]
	keyName = keyName2

	_table_sort(container, sortEnemies)

	local total = 0

	for index, player in ipairs(container) do
		local npcid1 = Details:GetNpcIdFromGuid(player.serial)
		--p rint (player.nome, npcid1, ignored_enemy_npcs [npcid1])
		if (bitBand(player.flag_original, 0x00000060) ~= 0 and not ignoredEnemyNpcsTable [npcid1]) then --� um inimigo
			total = total + player [keyName]
		else
			amount = index-1
			break
		end
	end

	return amount, total
end

function Details:TooltipForCustom (barra) --[[exported]]
	GameCooltip:AddLine(Loc ["STRING_LEFT_CLICK_SHARE"])
	return true
end

--[[ Void Zone Sort]]
local void_zone_sort = function(t1, t2)
	if (t1.damage == t2.damage) then
		return t1.nome <= t2.nome
	else
		return t1.damage > t2.damage
	end
end


function Details.Sort1 (table1, table2) --[[exported]]
	return table1[1] > table2[1]
end

function Details.Sort2 (table1, table2) --[[exported]]
	return table1[2] > table2[2]
end

function Details.Sort3 (table1, table2) --[[exported]]
	return table1[3] > table2[3]
end

function Details.Sort4 (table1, table2) --[[exported]]
	return table1[4] > table2[4]
end

function Details.Sort4Reverse (table1, table2) --[[exported]]
	if (not table2) then
		return true
	end
	return table1[4] < table2[4]
end

function Details:GetBarColor(actor) --[[exported]]
	actor = actor or self

	if (actor.monster) then
		return unpack(Details.class_colors.ENEMY)

	elseif (actor.customColor) then
		return unpack(actor.customColor)

	elseif (actor.spellicon) then
		return 0.729, 0.917, 1

	elseif (actor.owner) then
		return unpack(Details.class_colors[actor.owner.classe or "UNKNOW"])

	elseif (actor.arena_team and Details.color_by_arena_team) then
		if (actor.arena_team == 0) then
			return unpack(Details.class_colors.ARENA_GREEN)
		else
			return unpack(Details.class_colors.ARENA_YELLOW)
		end

	else
		if (not is_player_class[actor.classe] and actor.flag_original and bitBand(actor.flag_original, 0x00000020) ~= 0) then --neutral
			return unpack(Details.class_colors.NEUTRAL)

		elseif (actor.color) then
			return unpack(actor.color)

		else
			return unpack(Details.class_colors[actor.classe or "UNKNOW"])
		end
	end
end

function Details:GetSpellLink(spellid) --[[exported]]
	if (type(spellid) ~= "number") then
		return spellid
	end

	if (spellid == 1) then --melee
		return GetSpellLink(6603)

	elseif (spellid == 2) then --autoshot
		return GetSpellLink(75)

	elseif (spellid > 10) then
		return GetSpellLink(spellid)
	else
		local spellname = _GetSpellInfo(spellid)
		return spellname
	end
end

function Details:GameTooltipSetSpellByID(spellid) --[[exported]]
	if (spellid == 1) then
		GameTooltip:SetSpellByID(6603)

	elseif (spellid == 2) then
		GameTooltip:SetSpellByID(75)

	elseif (spellid > 10) then
		GameTooltip:SetSpellByID(spellid)

	else
		GameTooltip:SetSpellByID(spellid)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--class constructor

	function atributo_damage:NovaTabela (serial, nome, link)

		local alphabetical = Details:GetOrderNumber(nome)

		--constructor
		local _new_damageActor = {

			tipo = class_type,

			total = alphabetical,
			totalabsorbed = alphabetical,
			total_without_pet = alphabetical,
			custom = 0,

			damage_taken = alphabetical,
			damage_from = {},

			dps_started = false,
			last_event = 0,
			on_hold = false,
			delay = 0,
			last_value = nil,
			last_dps = 0,

			end_time = nil,
			start_time = 0,

			pets = {},

			raid_targets = {},

			friendlyfire_total = 0,
			friendlyfire = {},

			targets = {},
			spells = container_habilidades:NovoContainer (container_damage)
		}

		setmetatable(_new_damageActor, atributo_damage)

		return _new_damageActor
	end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--special cases

	-- dps (calculate dps for actors)
	function atributo_damage:ContainerRefreshDps (container, combat_time)

		local total = 0

		if (Details.time_type == 2 or not Details:CaptureGet("damage")) then
			for _, actor in ipairs(container) do
				if (actor.grupo) then
					actor.last_dps = actor.total / combat_time
				else
					actor.last_dps = actor.total / actor:Tempo()
				end
				total = total + actor.last_dps
			end
		else
			for _, actor in ipairs(container) do
				actor.last_dps = actor.total / actor:Tempo()
				total = total + actor.last_dps
			end
		end

		return total
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--damage taken by spell

	local byspell_tooltip_background = {value = 100, color = {0.1960, 0.1960, 0.1960, 0.9097}, texture = [[Interface\AddOns\Details\images\bar_background_dark]]}

	function Details:ToolTipBySpell (instance, tabela, thisLine, keydown)

		local GameCooltip = GameCooltip
		local combat = instance.showing
		local from_spell = tabela [1] --spellid
		local from_spellname
		if (from_spell) then
			from_spellname = select(1, GetSpellInfo(from_spell))
		end

		--get a list of all damage actors
		local AllDamageCharacters = combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)

		--hold the targets
		local Targets = {}
		local total = 0
		local top = 0

		local is_custom_spell = false
		for _, spellcustom in ipairs(Details.savedCustomSpells) do
			if (spellcustom[1] == from_spell) then
				is_custom_spell = true
			end
		end

		for index, character in ipairs(AllDamageCharacters) do

			if (is_custom_spell) then
				for playername, ff_table in pairs(character.friendlyfire) do
					if (ff_table.spells [from_spell]) then
						local damage_actor = combat (1, playername)
						local heal_actor = combat (2, playername)

						if ((damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()))) then

							local got

							for index, t in ipairs(Targets) do
								if (t[1] == playername) then
									t[2] = t[2] + ff_table.spells [from_spell]
									total = total + ff_table.spells [from_spell]
									if (t[2] > top) then
										top = t[2]
									end
									got = true
									break
								end
							end

							if (not got) then
								Targets [#Targets+1] = {playername, ff_table.spells [from_spell]}
								total = total + ff_table.spells [from_spell]
								if (ff_table.spells [from_spell] > top) then
									top = ff_table.spells [from_spell]
								end
							end
						end
					end
				end
			else
				for playername, ff_table in pairs(character.friendlyfire) do
					for spellid, amount in pairs(ff_table.spells) do
						local spellname = select(1, GetSpellInfo(spellid))
						if (spellname == from_spellname) then
							local damage_actor = combat (1, playername)
							local heal_actor = combat (2, playername)
							if ((damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()))) then
								local got
								for index, t in ipairs(Targets) do
									if (t[1] == playername) then
										t[2] = t[2] + amount
										total = total + amount
										if (t[2] > top) then
											top = t[2]
										end
										got = true
										break
									end
								end

								if (not got) then
									Targets [#Targets+1] = {playername, amount}
									total = total + amount
									if (amount > top) then
										top = amount
									end
								end
							end
						end
					end
				end
			end

			--search actors which used the spell shown in the bar
			local spell = character.spells._ActorTable [from_spell]

			if (spell) then
				for targetname, amount in pairs(spell.targets) do

					local got = false
					local damage_actor = combat (1, targetname)
					local heal_actor = combat (2, targetname)

					if ( (damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()) ) ) then
						for index, t in ipairs(Targets) do
							if (t[1] == targetname) then
								t[2] = t[2] + amount
								total = total + amount
								if (t[2] > top) then
									top = t[2]
								end
								got = true
								break
							end
						end

						if (not got) then
							Targets [#Targets+1] = {targetname, amount}
							total = total + amount
							if (amount > top) then
								top = amount
							end
						end
					end
				end
			end

			if (not is_custom_spell) then
				for spellid, spell in pairs(character.spells._ActorTable) do
					if (spellid ~= from_spell) then
						local spellname = select(1, GetSpellInfo(spellid))
						if (spellname == from_spellname) then
							for targetname, amount in pairs(spell.targets) do

								local got = false
								local damage_actor = combat (1, targetname)
								local heal_actor = combat (2, targetname)

								if ( (damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()) ) ) then
									for index, t in ipairs(Targets) do
										if (t[1] == targetname) then
											t[2] = t[2] + amount
											total = total + amount
											if (t[2] > top) then
												top = t[2]
											end
											got = true
											break
										end
									end

									if (not got) then
										Targets [#Targets+1] = {targetname, amount}
										total = total + amount
										if (amount > top) then
											top = amount
										end
									end
								end
							end
						end
					end
				end
			end
		end

		table.sort (Targets, Details.Sort2)
		bs_tooltip_table = Targets
		bs_tooltip_table.damage_total = total

		GameCooltip:SetOption("StatusBarTexture", "Interface\\AddOns\\Details\\images\\bar_serenity")

		local spellname, _, spellicon = select(1, _GetSpellInfo(from_spell))
		GameCooltip:AddLine(spellname .. " " .. Loc ["STRING_CUSTOM_ATTRIBUTE_DAMAGE"], nil, nil, headerColor, nil, 10)
		GameCooltip:AddIcon (spellicon, 1, 1, 14, 14, 0.078125, 0.921875, 0.078125, 0.921875)
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
		Details:AddTooltipHeaderStatusbar (1, 1, 1, 0.5)

		local top = Targets[1] and Targets[1][2]

		local lineHeight = Details.tooltip.line_height

		for index, t in ipairs(Targets) do
			GameCooltip:AddLine(Details:GetOnlyName(t[1]), Details:ToK(t[2]) .. " (" .. format("%.1f", t[2]/total*100) .. "%)")
			local class, _, _, _, _, r, g, b = Details:GetClass(t[1])

			GameCooltip:AddStatusBar (t[2]/top*100, 1, r, g, b, 0.8, false,  byspell_tooltip_background)

			if (class) then
				local specID = Details:GetSpec(t[1])
				if (specID) then
					local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
					GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
				else
					local texture, l, r, t, b = Details:GetClassIcon(class)
					GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small_alpha", 1, 1, lineHeight, lineHeight, l, r, t, b)
				end

			elseif (t[1] == Loc ["STRING_TARGETS_OTHER1"]) then
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small_alpha", 1, 1, lineHeight, lineHeight, 0.25, 0.49609375, 0.75, 1)
			end
		end

		GameCooltip:AddLine(" ")
		Details:AddTooltipReportLineText()

		GameCooltip:SetOption("YSpacingMod", 0)
		GameCooltip:SetOwner(thisLine)
		GameCooltip:Show()

	end

	local function RefreshBarraBySpell (tabela, barra, instancia)
		atributo_damage:AtualizarBySpell (tabela, tabela.minha_barra, barra.colocacao, instancia)
	end

	local on_switch_DTBS_show = function(instance)
		instance:TrocaTabela(instance, true, 1, 8)
		return true
	end

	local DTBS_search_code = [[
		--get the parameters passed
		local combat, instance_container, instance = ...
		--declade the values to return
		local total, top, amount = 0, 0, 0
		--hold the targets
		local Targets = {}

		local from_spell = @SPELLID@
		local from_spellname
		if (from_spell) then
			from_spellname = select(1, GetSpellInfo(from_spell))
		end

		--get a list of all damage actors
		local AllDamageCharacters = combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)

		local is_custom_spell = false
		for _, spellcustom in ipairs(Details.savedCustomSpells) do
		    if (spellcustom[1] == from_spell) then
			is_custom_spell = true
		    end
		end

		for index, character in ipairs(AllDamageCharacters) do

		    if (is_custom_spell) then
			for playername, ff_table in pairs(character.friendlyfire) do
			    if (ff_table.spells [from_spell]) then
				local damage_actor = combat (1, playername)
				local heal_actor = combat (2, playername)

				if ((damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()))) then

				    local got

				    for index, t in ipairs(Targets) do
					if (t[1] == playername) then
					    t[2] = t[2] + ff_table.spells [from_spell]
					    if (t[2] > top) then
						top = t[2]
					    end
					    got = true
					    break
					end
				    end

				    if (not got) then
					Targets [#Targets+1] = {playername, ff_table.spells [from_spell], damage_actor or heal_actor}
					if (ff_table.spells [from_spell] > top) then
					    top = ff_table.spells [from_spell]
					end
				    end
				end
			    end
			end
		    else

			for playername, ff_table in pairs(character.friendlyfire) do
			    for spellid, amount in pairs(ff_table.spells) do
				local spellname = select(1, GetSpellInfo(spellid))
				if (spellname == from_spellname) then
				    local damage_actor = combat (1, playername)
				    local heal_actor = combat (2, playername)
				    if ((damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()))) then
					local got
					for index, t in ipairs(Targets) do
					    if (t[1] == playername) then
						t[2] = t[2] + amount
						if (t[2] > top) then
						    top = t[2]
						end
						got = true
						break
					    end
					end

					if (not got) then
					    Targets [#Targets+1] = {playername, amount, damage_actor or heal_actor}
					    if (amount > top) then
						top = amount
					    end
					end
				    end
				end
			    end
			end
		    end

		    --search actors which used the spell shown in the bar
		    local spell = character.spells._ActorTable [from_spell]

		    if (spell) then
			for targetname, amount in pairs(spell.targets) do

			    local got = false

			    local damage_actor = combat (1, targetname)
			    local heal_actor = combat (2, targetname)

			    if ( (damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()) ) ) then
				for index, t in ipairs(Targets) do
				    if (t[1] == targetname) then
					t[2] = t[2] + amount
					if (t[2] > top) then
					    top = t[2]
					end
					got = true
					break
				    end
				end
				if (not got) then
				    Targets [#Targets+1] = {targetname, amount, damage_actor or heal_actor}
				    if (amount > top) then
					top = amount
				    end
				end
			    end
			end
		    end

		    if (not is_custom_spell) then
			for spellid, spell in pairs(character.spells._ActorTable) do
			    if (spellid ~= from_spell) then
				local spellname = select(1, GetSpellInfo(spellid))
				if (spellname == from_spellname) then
				    for targetname, amount in pairs(spell.targets) do

					local got = false

					local damage_actor = combat (1, targetname)
					local heal_actor = combat (2, targetname)

					if ( (damage_actor or heal_actor) and ( (damage_actor and damage_actor:IsPlayer()) or (heal_actor and heal_actor:IsPlayer()) ) ) then
					    for index, t in ipairs(Targets) do
						if (t[1] == targetname) then
						    t[2] = t[2] + amount
						    if (t[2] > top) then
							top = t[2]
						    end
						    got = true
						    break
						end
					    end
					    if (not got) then
						Targets [#Targets+1] = {targetname, amount, damage_actor or heal_actor}
						if (amount > top) then
						    top = amount
						end
					    end
					end
				    end
				end
			    end
			end
		    end

		end

		table.sort (Targets, Details.Sort2)

		local amount = 0
		for index, t in ipairs(Targets) do
			instance_container:AddValue (t[3], t[2])
			total = total + t[2]
			amount = amount + 1
		end

		return total, top, amount
	]]

	local function ShowDTBSInWindow (spell, instance)

		local spellname, _, icon = _GetSpellInfo(spell [1])
		local custom_name = spellname .. " - " .. Loc ["STRING_CUSTOM_DTBS"] .. ""

		--check if already exists
		for index, CustomObject in ipairs(Details.custom) do
			if (CustomObject:GetName() == custom_name) then
				--fix for not saving funcs on logout
				if (not CustomObject.OnSwitchShow) then
					CustomObject.OnSwitchShow = on_switch_DTBS_show
				end
				return instance:TrocaTabela(instance.segmento, 5, index)
			end
		end

		--create a custom for this spell
		local new_custom_object = {
			name = custom_name,
			icon = icon,
			attribute = false,
			author = Details.playername,
			desc = spellname .. " " .. Loc ["STRING_CUSTOM_DTBS"],
			source = false,
			target = false,
			script = false,
			tooltip = false,
			temp = true,
			notooltip = true,
			OnSwitchShow = on_switch_DTBS_show,
		}

		local new_code = DTBS_search_code
		new_code = new_code:gsub("@SPELLID@", spell [1])
		new_custom_object.script = new_code

		tinsert(Details.custom, new_custom_object)
		setmetatable(new_custom_object, Details.atributo_custom)
		new_custom_object.__index = Details.atributo_custom

		return instance:TrocaTabela(instance.segmento, 5, #Details.custom)
	end

	local DTBS_format_name = function(player_name) return Details:GetOnlyName(player_name) end
	local DTBS_format_amount = function(amount) return Details:ToK(amount) .. " (" .. format("%.1f", amount / bs_tooltip_table.damage_total * 100) .. "%)" end

	function atributo_damage:ReportSingleDTBSLine (spell, instance, ShiftKeyDown, ControlKeyDown)
		if (ControlKeyDown) then
			local spellname, _, spellicon = _GetSpellInfo(spell[1])
			return Details:OpenAuraPanel (spell[1], spellname, spellicon)
		elseif (ShiftKeyDown) then
			return ShowDTBSInWindow (spell, instance)
		end

		local spelllink = Details:GetSpellLink(spell [1])
		local report_table = {"Details!: " .. Loc ["STRING_CUSTOM_DTBS"] .. " " .. spelllink}

		Details:FormatReportLines(report_table, bs_tooltip_table, DTBS_format_name, DTBS_format_amount)

		return Details:Reportar(report_table, {_no_current = true, _no_inverse = true, _custom = true})
	end

	function atributo_damage:AtualizarBySpell(tabela, whichRowLine, colocacao, instance)
		tabela ["byspell"] = true --marca que esta tabela � uma tabela de frags, usado no controla na hora de montar o tooltip
		local thisLine = instance.barras [whichRowLine] --pega a refer�ncia da barra na janela

		if (not thisLine) then
			print("DEBUG: problema com <instance.thisLine> "..whichRowLine .. " " .. colocacao)
			return
		end

		thisLine.minha_tabela = tabela

		local spellName, _, spellIcon = _GetSpellInfo(tabela[1])

		tabela.nome = spellName --evita dar erro ao redimencionar a janela
		tabela.minha_barra = whichRowLine
		thisLine.colocacao = colocacao

		if (not _getmetatable (tabela)) then
			setmetatable(tabela, {__call = RefreshBarraBySpell})
			tabela._custom = true
		end

		local total = instance.showing.totals.by_spell
		local porcentagem

		if (instance.row_info.percent_type == 1) then
			porcentagem = format("%.1f", tabela [2] / total * 100)

		elseif (instance.row_info.percent_type == 2) then
			porcentagem = format("%.1f", tabela [2] / instance.top * 100)
		end

		thisLine.lineText1:SetText(colocacao .. ". " .. spellName)

		local bars_show_data = instance.row_info.textR_show_data

		local spell_damage = tabela[2] -- spell_damage passar por uma ToK function, precisa ser number
		if (not bars_show_data [1]) then
			spell_damage = tabela[2] --damage taken by spell n�o tem PS, ent�o � obrigado a passar o dano total
		end

		if (not bars_show_data[3]) then
			porcentagem = ""
		else
			porcentagem = porcentagem .. "%"
		end

		local bars_brackets = instance:GetBarBracket()

		if (instance.use_multi_fontstrings) then
			instance:SetInLineTexts(thisLine, "", (spell_damage and SelectedToKFunction(_, spell_damage) or ""), porcentagem)
		else
			thisLine.lineText4:SetText((spell_damage and SelectedToKFunction(_, spell_damage) or "") .. bars_brackets[1] .. porcentagem .. bars_brackets[2])
		end

		thisLine.lineText1:SetTextColor(1, 1, 1, 1)
		thisLine.lineText2:SetTextColor(1, 1, 1, 1)
		thisLine.lineText3:SetTextColor(1, 1, 1, 1)
		thisLine.lineText4:SetTextColor(1, 1, 1, 1)

		thisLine.lineText1:SetSize(thisLine:GetWidth() - thisLine.lineText4:GetStringWidth() - 20, 15)

		if (colocacao == 1) then
			thisLine:SetValue(100)
		else
			thisLine:SetValue(tabela[2] / instance.top * 100)
		end

		if (thisLine.hidden or thisLine.fading_in or thisLine.faded) then
			Details.FadeHandler.Fader(thisLine, "out")
		end

		if (instance.row_info.texture_class_colors) then
			if (tabela [3] > 1) then
				local r, g, b = Details:GetSpellSchoolColor(tabela[3])
				thisLine.textura:SetVertexColor(r, g, b)
			else
				local r, g, b = Details:GetSpellSchoolColor(0)
				thisLine.textura:SetVertexColor(r, g, b)
			end
		end

		thisLine.icone_classe:SetTexture(spellIcon)
		thisLine.icone_classe:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)
		thisLine.icone_classe:SetVertexColor(1, 1, 1)
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--frags

	function Details:ToolTipFrags (instancia, frag, thisLine, keydown)

		local name = frag [1]
		local GameCooltip = GameCooltip

		--mantendo a fun��o o mais low level poss�vel
		local damage_container = instancia.showing [1]

		local frag_actor = damage_container._ActorTable [damage_container._NameIndexTable [ name ]]

		if (frag_actor) then

			local damage_taken_table = {}

			local took_damage_from = frag_actor.damage_from
			local total_damage_taken = frag_actor.damage_taken
			local total = 0

			for aggressor, _ in pairs(took_damage_from) do

				local damager_actor = damage_container._ActorTable [damage_container._NameIndexTable [ aggressor ]]

				if (damager_actor and not damager_actor.owner) then --checagem por causa do total e do garbage collector que n�o limpa os names que deram dano
					local target_amount = damager_actor.targets [name]
					if (target_amount) then
						damage_taken_table [#damage_taken_table+1] = {aggressor, target_amount, damager_actor.classe}
						total = total + target_amount
					end
				end
			end

			_table_sort(damage_taken_table, Details.Sort2)

			Details:AddTooltipSpellHeaderText (Loc ["STRING_DAMAGE_FROM"], headerColor, #damage_taken_table, [[Interface\Addons\Details\images\icons]], 0.126953125, 0.1796875, 0, 0.0546875)
			Details:AddTooltipHeaderStatusbar (1, 1, 1, 0.5)
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)

			local min = 6
			local ismaximized = false
			--always maximized
			if (true or keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
				min = 99
				ismaximized = true
			end

			if (ismaximized) then
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
			else
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
			end

			local top = damage_taken_table[1] and damage_taken_table[1][2]
			frags_tooltip_table = damage_taken_table
			frags_tooltip_table.damage_total = total

			local lineHeight = Details.tooltip.line_height

			if (#damage_taken_table > 0) then
				for i = 1, math.min (min, #damage_taken_table) do
					local t = damage_taken_table [i]

					GameCooltip:AddLine(Details:GetOnlyName(t[1]), FormatTooltipNumber (_, t[2]) .. " (" .. format("%.1f", t[2] / total * 100) .. "%)")
					local classe = t[3]
					if (not classe) then
						classe = "UNKNOW"
					end

					if (classe == "UNKNOW") then
						GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, lineHeight, lineHeight, .25, .5, 0, 1)
					else

						local specID = Details:GetSpec(t[1])
						if (specID) then
							local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
							GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
						else
							GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], nil, nil, lineHeight, lineHeight, unpack(Details.class_coords [classe]))
						end
					end

					local _, _, _, _, _, r, g, b = Details:GetClass(t[1])
					GameCooltip:AddStatusBar (t[2] / top * 100, 1, r, g, b, 1, false, enemies_background)
				end
			else
				GameCooltip:AddLine(Loc ["STRING_NO_DATA"], nil, 1, "white")
				GameCooltip:AddIcon (instancia.row_info.icon_file, nil, nil, 14, 14, unpack(Details.class_coords ["UNKNOW"]))
			end

			GameCooltip:AddLine(" ")
			Details:AddTooltipReportLineText()

			GameCooltip:SetOption("StatusBarTexture", "Interface\\AddOns\\Details\\images\\bar_serenity")
			GameCooltip:ShowCooltip()
		end
	end

	local function RefreshBarraFrags (tabela, barra, instancia)
		atributo_damage:AtualizarFrags(tabela, tabela.minha_barra, barra.colocacao, instancia)
	end

	function atributo_damage:AtualizarFrags(tabela, whichRowLine, colocacao, instancia)

		tabela ["frags"] = true --marca que esta tabela � uma tabela de frags, usado no controla na hora de montar o tooltip
		local thisLine = instancia.barras [whichRowLine] --pega a refer�ncia da barra na janela

		if (not thisLine) then
			print("DEBUG: problema com <instancia.thisLine> "..whichRowLine.." "..rank)
			return
		end

		local previousData = thisLine.minha_tabela

		thisLine.minha_tabela = tabela

		tabela.nome = tabela [1] --evita dar erro ao redimencionar a janela
		tabela.minha_barra = whichRowLine
		thisLine.colocacao = colocacao

		if (not _getmetatable (tabela)) then
			setmetatable(tabela, {__call = RefreshBarraFrags})
			tabela._custom = true
		end

		local total = instancia.showing.totals.frags_total
		local porcentagem

		if (instancia.row_info.percent_type == 1) then
			porcentagem = format("%.1f", tabela [2] / total * 100)
		elseif (instancia.row_info.percent_type == 2) then
			porcentagem = format("%.1f", tabela [2] / instancia.top * 100)
		end

		thisLine.lineText1:SetText(colocacao .. ". " .. tabela [1])

		local bars_show_data = instancia.row_info.textR_show_data
		local bars_brackets = instancia:GetBarBracket()

		local total_frags = tabela [2]
		if (not bars_show_data [1]) then
			total_frags = ""
		end
		if (not bars_show_data [3]) then
			porcentagem = ""
		else
			porcentagem = porcentagem .. "%"
		end

		--
		if (instancia.use_multi_fontstrings) then
			instancia:SetInLineTexts(thisLine, "", total_frags, porcentagem)
		else
			thisLine.lineText4:SetText(total_frags .. bars_brackets[1] .. porcentagem .. bars_brackets[2])
		end

		thisLine.lineText1:SetSize(thisLine:GetWidth() - thisLine.lineText4:GetStringWidth() - 20, 15)

		if (colocacao == 1) then
			thisLine:SetValue(100)
		else
			thisLine:SetValue(tabela [2] / instancia.top * 100)
		end

		thisLine.lineText1:SetTextColor(1, 1, 1, 1)
		thisLine.lineText4:SetTextColor(1, 1, 1, 1)

		if (thisLine.hidden or thisLine.fading_in or thisLine.faded) then
			Details.FadeHandler.Fader(thisLine, "out")
		end

		Details:SetBarColors(thisLine, instancia, unpack(Details.class_colors [tabela [3]]))

		if (tabela [3] == "UNKNOW" or tabela [3] == "UNGROUPPLAYER" or tabela [3] == "ENEMY") then
			thisLine.icone_classe:SetTexture([[Interface\AddOns\Details\images\classes_plus]])
			thisLine.icone_classe:SetTexCoord(0.50390625, 0.62890625, 0, 0.125)
			thisLine.icone_classe:SetVertexColor(1, 1, 1)
		else
			thisLine.icone_classe:SetTexture(instancia.row_info.icon_file)
			thisLine.icone_classe:SetTexCoord(unpack(Details.class_coords [tabela [3]]))
			thisLine.icone_classe:SetVertexColor(1, 1, 1)
		end

		if (thisLine.mouse_over and not instancia.baseframe.isMoving) then --precisa atualizar o tooltip
			--gump:UpdateTooltip(whichRowLine, thisLine, instancia)
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--void zones
	local on_switch_AVZ_show = function(instance)
		instance:TrocaTabela(instance, true, 1, 7)
		return true
	end

	local AVZ_search_code = [[
		--get the parameters passed
		local combat, instance_container, instance = ...
		--declade the values to return
		local total, top, amount = 0, 0, 0

		local actor_name = "@ACTORNAME@"
		local actor = combat (4, actor_name)

		if (not actor) then
			return 0, 0, 0
		end

		local damage_actor = combat (1, actor.damage_twin)

		local habilidade
		local alvos

		if (damage_actor) then
			habilidade = damage_actor.spells._ActorTable [actor.damage_spellid]
		end
		if (habilidade) then
			alvos = habilidade.targets
		end

		local container = actor.debuff_uptime_targets
		local tooltip_void_zone_temp = {}

		for target_name, debuff_table in pairs(container) do
			if (alvos) then
				local damage_alvo = alvos [target_name]
				if (damage_alvo) then
					debuff_table.damage = damage_alvo
				else
					debuff_table.damage = 0
				end
			else
				debuff_table.damage = 0
			end
		end

		local i = 1
		for target_name, debuff_table in pairs(container) do
			local t = tooltip_void_zone_temp [i]
			if (not t) then
				t = {}
				tinsert(tooltip_void_zone_temp, t)
			end

			local target_actor = combat (1, target_name) or combat (2, target_name) or combat (4, target_name)
			t[1] = target_name
			t[2] = debuff_table.damage
			t[3] = debuff_table
			t[4] = target_actor

			i = i + 1
		end

		--sort no container:
		table.sort (tooltip_void_zone_temp, Details.sort_tooltip_void_zones)

		for index, t in ipairs(tooltip_void_zone_temp) do
			instance_container:AddValue (t[4], t[2])

			local custom_actor = instance_container:GetActorTable(t[4])
			custom_actor.uptime = t[3].uptime

			total = total + t[2]
			amount = amount + 1
			if (t[2] > top) then
				top = t[2]
			end
		end

		return total, top, amount
	]]

	local AVZ_total_code = [[
		local value, top, total, combat, instance, custom_actor = ...
		local uptime = custom_actor.uptime or 0

		local minutos, segundos = floor(uptime / 60), floor(uptime % 60)
		if (minutos > 0) then
			uptime = "" .. minutos .. "m " .. segundos .. "s" .. ""
		else
			uptime = "" .. segundos .. "s" .. ""
		end

		return Details:ToK2(value) .. " - " .. uptime .. " "
	]]

	local function ShowVoidZonesInWindow (actor, instance)

		local spellid = tooltip_void_zone_temp.spellid

		local spellname, _, icon = _GetSpellInfo(spellid)
		local custom_name = spellname .. " - " .. Loc ["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"] .. ""

		--check if already exists
		for index, CustomObject in ipairs(Details.custom) do
			if (CustomObject:GetName() == custom_name) then
				--fix for not saving funcs on logout
				if (not CustomObject.OnSwitchShow) then
					CustomObject.OnSwitchShow = on_switch_AVZ_show
				end
				return instance:TrocaTabela(instance.segmento, 5, index)
			end
		end

		--create a custom for this spell
		local new_custom_object = {
			name = custom_name,
			icon = icon,
			attribute = false,
			author = Details.playername,
			desc = spellname .. " " .. Loc ["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"],
			source = false,
			target = false,
			script = false,
			tooltip = false,
			temp = true,
			notooltip = true,
			OnSwitchShow = on_switch_AVZ_show,
		}

		local new_code = AVZ_search_code
		new_code = new_code:gsub("@ACTORNAME@", actor.nome)
		new_custom_object.script = new_code

		local new_total_code = AVZ_total_code
		new_total_code = new_total_code:gsub("@ACTORNAME@", actor.nome)
		new_total_code = new_total_code:gsub("@SPELLID@", spellid)
		new_custom_object.total_script = new_total_code

		tinsert(Details.custom, new_custom_object)
		setmetatable(new_custom_object, Details.atributo_custom)
		new_custom_object.__index = Details.atributo_custom

		return instance:TrocaTabela(instance.segmento, 5, #Details.custom)
	end

	function atributo_damage:ReportSingleVoidZoneLine (actor, instance, ShiftKeyDown, ControlKeyDown)

		local spellid = tooltip_void_zone_temp.spellid

		if (ControlKeyDown) then
			local spellname, _, spellicon = _GetSpellInfo(spellid)
			return Details:OpenAuraPanel (spellid, spellname, spellicon)
		elseif (ShiftKeyDown) then
			return ShowVoidZonesInWindow (actor, instance)
		end

		local spelllink = Details:GetSpellLink(spellid)
		local report_table = {"Details!: " .. spelllink .. " " .. Loc ["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"]}

		local t = {}
		for index, void_table in ipairs(tooltip_void_zone_temp) do
			--ir� reportar dano zero tamb�m
			if (void_table[1] and type(void_table[1]) == "string" and void_table[2] and void_table[3] and type(void_table[3]) == "table") then
				local actor_table = {Details:GetOnlyName(void_table[1])}
				local m, s = _math_floor(void_table[3].uptime / 60), _math_floor(void_table[3].uptime % 60)
				if (m > 0) then
					actor_table [2] = FormatTooltipNumber (_, void_table[3].damage) .. " (" .. m .. "m " .. s .. "s" .. ")"
				else
					actor_table [2] = FormatTooltipNumber (_, void_table[3].damage) .. " (" .. s .. "s" .. ")"
				end
				t [#t+1] = actor_table
			end
		end

		Details:FormatReportLines (report_table, t)

		return Details:Reportar (report_table, {_no_current = true, _no_inverse = true, _custom = true})
	end

	local sort_tooltip_void_zones = function(tabela1, tabela2)
		if (tabela1 [2] > tabela2 [2]) then
			return true
		elseif (tabela1 [2] == tabela2 [2]) then
			if (tabela1[1] ~= "" and tabela2[1] ~= "") then
				return tabela1 [3].uptime > tabela2 [3].uptime
			elseif (tabela1[1] ~= "") then
				return true
			elseif (tabela2[1] ~= "") then
				return false
			end
		else
			return false
		end
	end
	Details.sort_tooltip_void_zones = sort_tooltip_void_zones


	function Details:ToolTipVoidZones (instancia, actor, barra, keydown)

		local damage_actor = instancia.showing[1]:PegarCombatente (_, actor.damage_twin)
		local habilidade
		local alvos

		if (damage_actor) then
			habilidade = damage_actor.spells._ActorTable [actor.damage_spellid]
		end

		if (habilidade) then
			alvos = habilidade.targets
		end

		local container = actor.debuff_uptime_targets

		for target_name, debuff_table in pairs(container) do
			if (alvos) then
				local damage_alvo = alvos [target_name]
				if (damage_alvo) then
					debuff_table.damage = damage_alvo
				else
					debuff_table.damage = 0
				end
			else
				debuff_table.damage = 0
			end
		end

		for i = 1, #tooltip_void_zone_temp do
			local t = tooltip_void_zone_temp [i]
			t[1] = ""
			t[2] = 0
			t[3] = 0
		end

		local i = 1
		for target_name, debuff_table in pairs(container) do
			local t = tooltip_void_zone_temp [i]
			if (not t) then
				t = {}
				tinsert(tooltip_void_zone_temp, t)
			end

			t[1] = target_name
			t[2] = debuff_table.damage
			t[3] = debuff_table

			i = i + 1
		end

		--sort no container:
		_table_sort(tooltip_void_zone_temp, sort_tooltip_void_zones)

		--monta o cooltip
		local GameCooltip = GameCooltip

		local spellname, _, spellicon = _GetSpellInfo(actor.damage_spellid)
		Details:AddTooltipSpellHeaderText (spellname .. " " .. Loc ["STRING_VOIDZONE_TOOLTIP"], headerColor, #tooltip_void_zone_temp, spellicon, 0.078125, 0.921875, 0.078125, 0.921875)
		Details:AddTooltipHeaderStatusbar (1, 1, 1, 0.5)
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)

		--for target_name, debuff_table in pairs(container) do
		local first = tooltip_void_zone_temp [1] and tooltip_void_zone_temp [1][3]
		if (type(first) == "table") then
			first = first.damage
		end

		tooltip_void_zone_temp.spellid = actor.damage_spellid
		tooltip_void_zone_temp.current_actor = actor

		local lineHeight = Details.tooltip.line_height

		for index, t in ipairs(tooltip_void_zone_temp) do

			if (t[3] == 0) then
				break
			end

			local debuff_table = t[3]

			local minutos, segundos = _math_floor(debuff_table.uptime / 60), _math_floor(debuff_table.uptime % 60)
			if (minutos > 0) then
				GameCooltip:AddLine(Details:GetOnlyName(t[1]), FormatTooltipNumber (_, debuff_table.damage) .. " (" .. minutos .. "m " .. segundos .. "s" .. ")")
			else
				GameCooltip:AddLine(Details:GetOnlyName(t[1]), FormatTooltipNumber (_, debuff_table.damage) .. " (" .. segundos .. "s" .. ")")
			end

			local classe = Details:GetClass(t[1])
			if (classe) then
				local specID = Details:GetSpec(t[1])
				if (specID) then
					local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
					GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
				else
					GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], nil, nil, lineHeight, lineHeight, unpack(Details.class_coords [classe]))
				end
			else
				GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, lineHeight, lineHeight, .25, .5, 0, 1)
			end

			local _, _, _, _, _, r, g, b = Details:GetClass(t[1])
			if (first == 0) then
				first = 0.0000000001
			end
			GameCooltip:AddStatusBar (debuff_table.damage / first * 100, 1, r, g, b, 1, false, enemies_background)
			--Details:AddTooltipBackgroundStatusbar()

		end

		GameCooltip:AddLine(" ")
		Details:AddTooltipReportLineText()

		GameCooltip:SetOption("StatusBarTexture", "Interface\\AddOns\\Details\\images\\bar_serenity")

		GameCooltip:ShowCooltip()

	end

	local function RefreshBarraVoidZone (tabela, barra, instancia)
		tabela:AtualizarVoidZone (tabela.minha_barra, barra.colocacao, instancia)
	end

	function atributo_misc:AtualizarVoidZone (whichRowLine, colocacao, instancia)
		--pega a refer�ncia da barra na janela
		local thisLine = instancia.barras[whichRowLine]

		if (not thisLine) then
			print("DEBUG: problema com <instancia.thisLine> "..whichRowLine.." "..rank)
			return
		end

		self._refresh_window = RefreshBarraVoidZone

		local previousData = thisLine.minha_tabela

		thisLine.minha_tabela = self

		self.minha_barra = whichRowLine
		thisLine.colocacao = colocacao

		local total = instancia.showing.totals.voidzone_damage

		local combat_time = instancia.showing:GetCombatTime()
		local dps = _math_floor(self.damage / combat_time)

		local formated_damage = SelectedToKFunction(_, self.damage)
		local formated_dps = SelectedToKFunction(_, dps)

		local porcentagem

		if (instancia.row_info.percent_type == 1) then
			total = max(total, 0.0001)
			porcentagem = format("%.1f", self.damage / total * 100)

		elseif (instancia.row_info.percent_type == 2) then
			local top = max(instancia.top, 0.0001)
			porcentagem = format("%.1f", self.damage / top * 100)
		end

		local bars_show_data = instancia.row_info.textR_show_data
		local bars_brackets = instancia:GetBarBracket()
		local bars_separator = instancia:GetBarSeparator()

		if (not bars_show_data [1]) then
			formated_damage = ""
		end

		if (not bars_show_data [2]) then
			formated_dps = ""
		end

		if (not bars_show_data [3]) then
			porcentagem = ""
		else
			porcentagem = porcentagem .. "%"
		end

		local rightText = formated_damage .. bars_brackets[1] .. formated_dps .. bars_separator .. porcentagem .. bars_brackets[2]
		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instancia.row_info.textR_custom_text, formated_damage, formated_dps, porcentagem, self, instancia.showing, instancia, rightText))
		else
			if (instancia.use_multi_fontstrings) then
				instancia:SetInLineTexts(thisLine, formated_damage, formated_dps, porcentagem)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end

		thisLine.lineText1:SetText(colocacao .. ". " .. self.nome)
		thisLine.lineText1:SetSize(thisLine:GetWidth() - thisLine.lineText4:GetStringWidth() - 20, 15)

		thisLine.lineText1:SetTextColor(1, 1, 1, 1)
		thisLine.lineText4:SetTextColor(1, 1, 1, 1)

		thisLine:SetValue(100)

		if (thisLine.hidden or thisLine.fading_in or thisLine.faded) then
			Details.FadeHandler.Fader(thisLine, "out")
		end

		local _, _, icon = GetSpellInfo(self.damage_spellid)
		local school_color = Details.school_colors [self.spellschool]
		if (not school_color) then
			school_color = Details.school_colors ["unknown"]
		end

		Details:SetBarColors(thisLine, instancia, unpack(school_color))

		thisLine.icone_classe:SetTexture(icon)
		thisLine.icone_classe:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)
		thisLine.icone_classe:SetVertexColor(1, 1, 1)

		if (thisLine.mouse_over and not instancia.baseframe.isMoving) then
			--need call a refresh function
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--main refresh function

function atributo_damage:RefreshWindow(instancia, combatObject, forcar, exportar, refreshRequired)
	local showing = combatObject[class_type] --o que esta sendo mostrado -> [1] - dano [2] - cura --pega o container com ._NameIndexTable ._ActorTable

	--not have something to show
	if (#showing._ActorTable < 1) then
		if (Details.debug and false) then
			Details.showing_ActorTable_Timer = Details.showing_ActorTable_Timer or 0
			if (time() > Details.showing_ActorTable_Timer) then
				Details:Msg("(debug) nothing to show -> #showing._ActorTable < 1")
				Details.showing_ActorTable_Timer = time() + 5
			end
		end

		--colocado isso recentemente para fazer as barras de dano sumirem na troca de atributo
		return Details:EsconderBarrasNaoUsadas(instancia, showing), "", 0, 0
	end

	--total
	local total = 0
	--top actor #1
	instancia.top = 0

	local isUsingCache = false
	local subAttribute = instancia.sub_atributo
	local actorTableContent = showing._ActorTable
	local amount = #actorTableContent
	local windowMode = instancia.modo

	--pega qual a sub key que ser� usada --sub keys
	if (exportar) then
		if (type(exportar) == "boolean") then
			if (subAttribute == 1) then --DAMAGE DONE
				keyName = "total"

			elseif (subAttribute == 2) then --DPS
				keyName = "last_dps"

			elseif (subAttribute == 3) then --TAMAGE TAKEN
				keyName = "damage_taken"
				if (Details.damage_taken_everything) then
					windowMode = modo_ALL
				end

			elseif (subAttribute == 4) then --FRIENDLY FIRE
				keyName = "friendlyfire_total"

			elseif (subAttribute == 5) then --FRAGS
				keyName = "frags"

			elseif (subAttribute == 6) then --ENEMIES
				keyName = "enemies"

			elseif (subAttribute == 7) then --AURAS VOIDZONES
				keyName = "voidzones"

			elseif (subAttribute == 8) then --BY SPELL
				keyName = "damage_taken_by_spells"
			end
		else
			keyName = exportar.key
			windowMode = exportar.modo
		end

	elseif (instancia.atributo == 5) then --custom
		keyName = "custom"
		total = combatObject.totals [instancia.customName]

	else
		if (subAttribute == 1) then --DAMAGE DONE
			keyName = "total"

		elseif (subAttribute == 2) then --DPS
			keyName = "last_dps"

		elseif (subAttribute == 3) then --TAMAGE TAKEN
			keyName = "damage_taken"
			if (Details.damage_taken_everything) then
				windowMode = modo_ALL
			end

		elseif (subAttribute == 4) then --FRIENDLY FIRE
			keyName = "friendlyfire_total"

		elseif (subAttribute == 5) then --FRAGS
			keyName = "frags"

		elseif (subAttribute == 6) then --ENEMIES
			keyName = "enemies"

		elseif (subAttribute == 7) then --AURAS VOIDZONES
			keyName = "voidzones"

		elseif (subAttribute == 8) then --BY SPELL
			keyName = "damage_taken_by_spells"
		end
	end

	if (keyName == "frags") then
		local frags = instancia.showing.frags
		local frags_total_kills = 0
		local index = 0

		for fragName, fragAmount in pairs(frags) do

			index = index + 1

			local fragged_actor = showing._NameIndexTable [fragName] --get index
			local actor_classe
			if (fragged_actor) then
				fragged_actor = showing._ActorTable [fragged_actor] --get object
				actor_classe = fragged_actor.classe
			end

			if (fragged_actor and fragged_actor.monster) then
				actor_classe = "ENEMY"
			elseif (not actor_classe) then
				actor_classe = "UNGROUPPLAYER"
			end

			if (ntable [index]) then
				ntable [index] [1] = fragName
				ntable [index] [2] = fragAmount
				ntable [index] [3] = actor_classe
			else
				ntable [index] = {fragName, fragAmount, actor_classe}
			end

			frags_total_kills = frags_total_kills + fragAmount
		end

		local tsize = #ntable
		if (index < tsize) then
			for i = index+1, tsize do
				ntable [i][2] = 0
			end
		end

		instancia.top = 0
		if (tsize > 0) then
			_table_sort(ntable, Details.Sort2)
			instancia.top = ntable [1][2]
		end

		total = index

		if (exportar) then
			local export = {}
			for i = 1, index do
				export [i] = {ntable[i][1], ntable[i][2], ntable[i][3]}
			end
			return export
		end

		if (total < 1) then
			instancia:EsconderScrollBar()
			return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh
		end

		combatObject.totals.frags_total = frags_total_kills

		instancia:RefreshScrollBar(total)

		local whichRowLine = 1
		local lineContainer = instancia.barras

		for i = instancia.barraS[1], instancia.barraS[2], 1 do
			atributo_damage:AtualizarFrags(ntable[i], whichRowLine, i, instancia)
			whichRowLine = whichRowLine+1
		end

		return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh

	elseif (keyName == "damage_taken_by_spells") then

		local bs_index, total = 0, 0
		wipe (bs_index_table)

		local combat = combatObject
		local AllDamageCharacters = combat:GetActorList (DETAILS_ATTRIBUTE_DAMAGE)

		--do a loop amoung the actors
		for index, character in ipairs(AllDamageCharacters) do

			--is the actor a player?
			if (character:IsPlayer()) then

				for source_name, _ in pairs(character.damage_from) do

					local source = combat (1, source_name)

					if (source) then
						--came from an enemy
						if (not source:IsPlayer()) then

							local AllSpells = source:GetSpellList()
							for spellid, spell in pairs(AllSpells) do
								local on_player = spell.targets [character.nome]

								if (on_player and on_player >= 1) then

									local spellname = _GetSpellInfo(spellid)
									if (spellname) then
										local has_index = bs_index_table [spellname]
										local this_spell
										if (has_index) then
											this_spell = bs_table [has_index]
										else
											bs_index = bs_index + 1
											this_spell = bs_table [bs_index]
											if (this_spell) then
												this_spell [1] = spellid
												this_spell [2] = 0
												this_spell [3] = spell.spellschool or Details.spell_school_cache [select(1, GetSpellInfo(spellid))] or 1
												bs_index_table [spellname] = bs_index
											else
												this_spell = {spellid, 0, spell.spellschool or Details.spell_school_cache [select(1, GetSpellInfo(spellid))] or 1}
												bs_table [bs_index] = this_spell
												bs_index_table [spellname] = bs_index
											end
										end
										this_spell [2] = this_spell [2] + on_player
										total = total + on_player
									else
										error("error - no spell id for DTBS " .. spellid)
									end
								end
							end

						elseif (source:IsGroupPlayer()) then -- friendly fire

							local AllSpells = source.friendlyfire [character.nome] and source.friendlyfire [character.nome].spells
							if (AllSpells) then -- se n�o existir pode ter vindo de um pet, talvez
								for spellid, on_player in pairs(AllSpells) do
									if (on_player and on_player >= 1) then

										local spellname = _GetSpellInfo(spellid)
										if (spellname) then
											local has_index = bs_index_table [spellname]
											local this_spell
											if (has_index) then
												this_spell = bs_table [has_index]
											else
												bs_index = bs_index + 1
												this_spell = bs_table [bs_index]
												if (this_spell) then
													this_spell [1] = spellid
													this_spell [2] = 0
													this_spell [3] = Details.spell_school_cache [select(1, GetSpellInfo(spellid))] or 1
													bs_index_table [spellname] = bs_index
												else
													this_spell = {spellid, 0, Details.spell_school_cache [select(1, GetSpellInfo(spellid))] or 1}
													bs_table [bs_index] = this_spell
													bs_index_table [spellname] = bs_index
												end
											end
											this_spell [2] = this_spell [2] + on_player
											total = total + on_player
										else
											error("error - no spell id for DTBS friendly fire " .. spellid)
										end
									end
								end
							end
						end
					end
				end
			end
		end

		local tsize = #bs_table
		if (bs_index < tsize) then
			for i = bs_index+1, tsize do
				bs_table [i][2] = 0
			end
		end

		instancia.top = 0
		if (tsize > 0) then
			_table_sort(bs_table, Details.Sort2)
			instancia.top = bs_table [1][2]
		end

		local total2 = bs_index

		if (exportar) then
			local export = {}
			for i = 1, bs_index do
				-- spellid, total, spellschool
				export [i] = {spellid = bs_table[i][1], damage = bs_table[i][2], spellschool = bs_table[i][3]}
			end
			return total, "damage", instancia.top, bs_index, export
		end

		if (bs_index < 1) then
			instancia:EsconderScrollBar()
			return Details:EndRefresh(instancia, bs_index, combatObject, showing) --retorna a tabela que precisa ganhar o refresh
		end

		combatObject.totals.by_spell = total

		instancia:RefreshScrollBar(bs_index)

		local whichRowLine = 1
		local lineContainer = instancia.barras

		--print(bs_index, #bs_table, instancia.barraS[1], instancia.barraS[2])

		for i = instancia.barraS[1], instancia.barraS[2], 1 do
			atributo_damage:AtualizarBySpell (bs_table[i], whichRowLine, i, instancia)
			whichRowLine = whichRowLine+1
		end

		return Details:EndRefresh(instancia, bs_index, combatObject, showing)

	elseif (keyName == "voidzones") then

		local index = 0
		local misc_container = combatObject [4]
		local voidzone_damage_total = 0

		for _, actor in ipairs(misc_container._ActorTable) do
			if (actor.boss_debuff) then
				index = index + 1

				--pega no container de dano o actor respons�vel por aplicar o debuff
				local twin_damage_actor = showing._NameIndexTable [actor.damage_twin] or showing._NameIndexTable ["[*] " .. actor.damage_twin]

				if (twin_damage_actor) then
					local index = twin_damage_actor
					twin_damage_actor = showing._ActorTable [twin_damage_actor]

					local spell = twin_damage_actor.spells._ActorTable [actor.damage_spellid]

					if (spell) then

						--fix spell, sometimes there is two spells with the same name, one is the cast and other is the debuff
						if (spell.total == 0 and not actor.damage_spellid_fixed) then
							local curname = _GetSpellInfo(actor.damage_spellid)
							for spellid, spelltable in pairs(twin_damage_actor.spells._ActorTable) do
								if (spelltable.total > spell.total) then
									local name = _GetSpellInfo(spellid)
									if (name == curname) then
										actor.damage_spellid = spellid
										spell = spelltable
									end
								end
							end
							actor.damage_spellid_fixed = true
						end

						actor.damage = spell.total
						voidzone_damage_total = voidzone_damage_total + spell.total

					elseif (not actor.damage_spellid_fixed) then --not
						--fix spell, if the spellid passed for debuff uptime is actully the spell id of a ability and not if the aura it self
						actor.damage_spellid_fixed = true
						local found = false
						for spellid, spelltable in pairs(twin_damage_actor.spells._ActorTable) do
							local name = _GetSpellInfo(spellid)
							if (actor.damage_twin:find(name)) then
								actor.damage = spelltable.total
								voidzone_damage_total = voidzone_damage_total + spelltable.total
								actor.damage_spellid = spellid
								found = true
								break
							end
						end

						if (not found) then
							actor.damage = 0
						end
					else
						actor.damage = 0
					end
				else
					actor.damage = 0
				end

				vtable [index] = actor
			end
		end

		local tsize = #vtable
		if (index < tsize) then
			for i = index+1, tsize do
				vtable [i] = nil
			end
		end

		if (tsize > 0 and vtable[1]) then
			_table_sort(vtable, void_zone_sort)
			instancia.top = vtable [1].damage
		end
		total = index

		if (exportar) then
			for _, t in ipairs(vtable) do
				t.report_name = Details:GetSpellLink(t.damage_spellid)
			end
			return voidzone_damage_total, "damage", instancia.top, total, vtable, "report_name"
		end

		if (total < 1) then
			instancia:EsconderScrollBar()
			return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh
		end

		combatObject.totals.voidzone_damage = voidzone_damage_total

		instancia:RefreshScrollBar(total)

		local whichRowLine = 1
		local lineContainer = instancia.barras

		for i = instancia.barraS[1], instancia.barraS[2], 1 do
			vtable[i]:AtualizarVoidZone (whichRowLine, i, instancia)
			whichRowLine = whichRowLine+1
		end

		return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh

	else
	--/run Details:Dump(Details:GetCurrentCombat():GetActor(1, "Injured Steelspine 1"))
		if (keyName == "enemies") then
			amount, total = Details:ContainerSortEnemies (actorTableContent, amount, "damage_taken")

			--remove actors with zero damage taken
			local newAmount = 0
			for i = 1, #actorTableContent do
				if (actorTableContent[i].damage_taken < 1) then
					newAmount = i-1
					break
				end
			end

			--if all units shown are enemies and all have damage taken, check if newAmount is zero and #conteudo has value bigger than 0
			if (newAmount == 0 and #actorTableContent > 0) then
				amount = amount
			else
				amount = newAmount
			end

			--keyName = "damage_taken"
			--result of the first actor
			instancia.top = actorTableContent[1] and actorTableContent[1][keyName]

		elseif (windowMode == modo_ALL) then --mostrando ALL

			--faz o sort da categoria e retorna o amount corrigido
			--print(keyName)
			if (subAttribute == 2) then
				local combat_time = instancia.showing:GetCombatTime()
				total = atributo_damage:ContainerRefreshDps (actorTableContent, combat_time)
			else
				--pega o total ja aplicado na tabela do combate
				total = combatObject.totals [class_type]
			end

			amount = Details:ContainerSort (actorTableContent, amount, keyName)

			--grava o total
			instancia.top = actorTableContent[1][keyName]

		elseif (windowMode == modo_GROUP) then --mostrando GROUP

			--organiza as tabelas

			if (Details.in_combat and instancia.segmento == 0 and not exportar) then
				isUsingCache = true
			end

			if (isUsingCache) then

				actorTableContent = Details.cache_damage_group

				if (subAttribute == 2) then --dps
					local combat_time = instancia.showing:GetCombatTime()
					atributo_damage:ContainerRefreshDps (actorTableContent, combat_time)
				end

				if (#actorTableContent < 1) then
					if (Details.debug and false) then
						Details.showing_ActorTable_Timer2 = Details.showing_ActorTable_Timer2 or 0
						if (time() > Details.showing_ActorTable_Timer2) then
							Details:Msg("(debug) nothing to show -> #conteudo < 1 (using cache)")
							Details.showing_ActorTable_Timer2 = time()+5
						end
					end

					return Details:EsconderBarrasNaoUsadas (instancia, showing), "", 0, 0
				end

				_table_sort(actorTableContent, Details.SortKeySimple)

				if (actorTableContent[1][keyName] < 1) then
					amount = 0
				else
					instancia.top = actorTableContent[1][keyName]
					amount = #actorTableContent
				end

				for i = 1, amount do
					total = total + actorTableContent[i][keyName]
				end
			else
				if (subAttribute == 2) then --dps
					local combat_time = instancia.showing:GetCombatTime()
					atributo_damage:ContainerRefreshDps (actorTableContent, combat_time)
				end

				_table_sort(actorTableContent, Details.SortKeyGroup)
			end
			--
			if (not isUsingCache) then
				for index, player in ipairs(actorTableContent) do
					if (player.grupo) then --� um player e esta em grupo
						if (player[keyName] < 1) then --dano menor que 1, interromper o loop
							amount = index - 1
							break
						end

						total = total + player[keyName]
					else
						amount = index-1
						break
					end
				end

				instancia.top = actorTableContent[1] and actorTableContent[1][keyName]
			end

		end
	end

	--refaz o mapa do container
	if (not isUsingCache) then
		showing:remapear()
	end

	if (exportar) then
		return total, keyName, instancia.top, amount
	end

	if (amount < 1) then --n�o h� barras para mostrar
		if (forcar) then
			if (instancia.modo == 2) then --group
				for i = 1, instancia.rows_fit_in_window  do
					Details.FadeHandler.Fader(instancia.barras [i], "in", Details.fade_speed)
				end
			end
		end
		instancia:EsconderScrollBar() --precisaria esconder a scroll bar

		if (Details.debug and false) then
			Details.showing_ActorTable_Timer2 = Details.showing_ActorTable_Timer2 or 0
			if (time() > Details.showing_ActorTable_Timer2) then
				Details:Msg("(debug) nothing to show -> amount < 1")
				Details.showing_ActorTable_Timer2 = time()+5
			end
		end

		return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh
	end

	instancia:RefreshScrollBar(amount)

	local whichRowLine = 1
	local lineContainer = instancia.barras
	local percentageType = instancia.row_info.percent_type
	local barsShowData = instancia.row_info.textR_show_data
	local barsBrackets = instancia:GetBarBracket()
	local barsSeparator = instancia:GetBarSeparator()
	local baseframe = instancia.baseframe
	local useAnimations = Details.is_using_row_animations and (not baseframe.isStretching and not forcar and not baseframe.isResizing)

	if (total == 0) then
		total = 0.00000001
	end

	local myPos
	local following = instancia.following.enabled and subAttribute ~= 6

	if (following) then
		if (isUsingCache) then
			local pname = Details.playername
			for i, actor in ipairs(actorTableContent) do
				if (actor.nome == pname) then
					myPos = i
					break
				end
			end
		else
			myPos = showing._NameIndexTable [Details.playername]
		end
	end

	local combatTime = instancia.showing:GetCombatTime()
	UsingCustomLeftText = instancia.row_info.textL_enable_custom_text
	UsingCustomRightText = instancia.row_info.textR_enable_custom_text

	local useTotalBar = false
	if (instancia.total_bar.enabled) then
		useTotalBar = true

		if (instancia.total_bar.only_in_group and (not IsInGroup() and not IsInRaid())) then
			useTotalBar = false
		end

		if (subAttribute > 4) then --enemies, frags, void zones
			useTotalBar = false
		end
	end

	if (subAttribute == 2) then --dps
		instancia.player_top_dps = actorTableContent [1].last_dps
		instancia.player_top_dps_threshold = instancia.player_top_dps - (instancia.player_top_dps * 0.65)
	end

	local totalBarIsShown

	if (instancia.bars_sort_direction == 1) then --top to bottom
		if (useTotalBar and instancia.barraS[1] == 1) then
			whichRowLine = 2
			local iterLast = instancia.barraS[2]
			if (iterLast == instancia.rows_fit_in_window) then
				iterLast = iterLast - 1
			end

			local row1 = lineContainer [1]
			row1.minha_tabela = nil
			row1.lineText1:SetText(Loc ["STRING_TOTAL"])

			if (instancia.use_multi_fontstrings) then
				row1.lineText2:SetText("")
				row1.lineText3:SetText(Details:ToK2(total))
				row1.lineText4:SetText(Details:ToK(total / combatTime))
			else
				row1.lineText4:SetText(Details:ToK2(total) .. " (" .. Details:ToK(total / combatTime) .. ")")
			end

			row1:SetValue(100)
			local r, g, b = unpack(instancia.total_bar.color)
			row1.textura:SetVertexColor(r, g, b)
			row1.icone_classe:SetTexture(instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)

			Details.FadeHandler.Fader(row1, "out")
			totalBarIsShown = true

			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], iterLast-1, 1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
				actorTableContent[myPos]:RefreshLine(instancia, lineContainer, whichRowLine, myPos, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
				whichRowLine = whichRowLine+1
			else
				for i = instancia.barraS[1], iterLast, 1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			end

		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], instancia.barraS[2]-1, 1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end

				actorTableContent[myPos]:RefreshLine(instancia, lineContainer, whichRowLine, myPos, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
				whichRowLine = whichRowLine+1
			else
				for i = instancia.barraS[1], instancia.barraS[2], 1 do
					if (actorTableContent[i]) then

						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			end
		end

	elseif (instancia.bars_sort_direction == 2) then --bottom to top
		if (useTotalBar and instancia.barraS[1] == 1) then
			whichRowLine = 2
			local iter_last = instancia.barraS[2]
			if (iter_last == instancia.rows_fit_in_window) then
				iter_last = iter_last - 1
			end

			local row1 = lineContainer [1]
			row1.minha_tabela = nil
			row1.lineText1:SetText(Loc ["STRING_TOTAL"])

			if (instancia.use_multi_fontstrings) then
				row1.lineText2:SetText("")
				row1.lineText3:SetText(Details:ToK2(total))
				row1.lineText4:SetText(Details:ToK(total / combatTime))
			else
				row1.lineText4:SetText(Details:ToK2(total) .. " (" .. Details:ToK(total / combatTime) .. ")")
			end

			row1:SetValue(100)
			local r, g, b = unpack(instancia.total_bar.color)
			row1.textura:SetVertexColor(r, g, b)

			row1.icone_classe:SetTexture(instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)

			Details.FadeHandler.Fader(row1, "out")
			totalBarIsShown = true

			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				actorTableContent[myPos]:RefreshLine(instancia, lineContainer, whichRowLine, myPos, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
				whichRowLine = whichRowLine+1
				for i = iter_last-1, instancia.barraS[1], -1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			else
				for i = iter_last, instancia.barraS[1], -1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			end
		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				actorTableContent[myPos]:RefreshLine(instancia, lineContainer, whichRowLine, myPos, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
				whichRowLine = whichRowLine+1
				for i = instancia.barraS[2]-1, instancia.barraS[1], -1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			else
				-- /run print(Details:GetInstance(1).barraS[2]) -- vai do 5 ao 1 -- qual barra come�a no 1 -- i = 5 at� 1 -- player 5 atualiza na barra 1 / player 1 atualiza na barra 5
				for i = instancia.barraS[2], instancia.barraS[1], -1 do
					if (actorTableContent[i]) then
						actorTableContent[i]:RefreshLine(instancia, lineContainer, whichRowLine, i, total, subAttribute, forcar, keyName, combatTime, percentageType, useAnimations, barsShowData, barsBrackets, barsSeparator)
						whichRowLine = whichRowLine+1
					end
				end
			end
		end

	end

	if (totalBarIsShown) then
		instancia:RefreshScrollBar(amount + 1)
	else
		instancia:RefreshScrollBar(amount)
	end

	if (useAnimations) then
		instancia:PerformAnimations(whichRowLine - 1)
	end

	--beta, hidar barras n�o usadas durante um refresh for�ado
	if (forcar) then
		if (instancia.modo == 2) then --group
			for i = whichRowLine, instancia.rows_fit_in_window  do
				Details.FadeHandler.Fader(instancia.barras [i], "in", Details.fade_speed)
			end
		end
	end

	Details.LastFullDamageUpdate = Details._tempo

	instancia:AutoAlignInLineFontStrings()

	return Details:EndRefresh(instancia, total, combatObject, showing) --retorna a tabela que precisa ganhar o refresh
end

--[[exported]] function Details:AutoAlignInLineFontStrings()

	--if this instance is using in line texts, check the min distance and the length of strings to make them more spread appart
	if (self.use_multi_fontstrings and self.use_auto_align_multi_fontstrings) then
		local maxStringLength_StringFour = 0
		local maxStringLength_StringThree = 0
		local profileOffsetString3 = self.fontstrings_text3_anchor
		local profileOffsetString2 = self.fontstrings_text2_anchor

		Details.CacheInLineMaxDistance = Details.CacheInLineMaxDistance or {}
		Details.CacheInLineMaxDistance[self:GetId()] = Details.CacheInLineMaxDistance[self:GetId()] or {[2] = profileOffsetString2, [3] = profileOffsetString3}

		--space between string4 and string3 (usually dps is 4 and total value is 3)
		for lineId = 1, self:GetNumLinesShown() do
			local thisLine = self:GetLine(lineId)

			--check strings 3 and 4
			if (thisLine.lineText4:GetText() ~= "" and thisLine.lineText3:GetText() ~= "") then
				--the length of the far right string determines the space between it and the next string in the left
				local stringLength = thisLine.lineText4:GetStringWidth()
				maxStringLength_StringFour = stringLength > maxStringLength_StringFour and stringLength or maxStringLength_StringFour
			end

			--check strings 2 and 3
			if (thisLine.lineText2:GetText() ~= "" and thisLine.lineText3:GetText() ~= "") then
				--the length of the middle string determines the space between it and the next string in the left
				local stringLength = thisLine.lineText3:GetStringWidth()
				maxStringLength_StringThree = stringLength > maxStringLength_StringThree and stringLength or maxStringLength_StringThree
			end
		end

		--if the length bigger than the min distance? calculate for string4 to string3 distance
		if ((maxStringLength_StringFour > 0) and (maxStringLength_StringFour + 5 > profileOffsetString3)) then
			local newOffset = maxStringLength_StringFour + 5

			--check if the current needed min distance is bigger than the distance stored in the cache
			local currentCacheMaxValue = Details.CacheInLineMaxDistance[self:GetId()][3]
			if (currentCacheMaxValue < newOffset) then
				currentCacheMaxValue = newOffset
				Details.CacheInLineMaxDistance[self:GetId()][3] = currentCacheMaxValue
			else
				--if not, use the distance value cached to avoid jittering in the string
				newOffset = currentCacheMaxValue
			end

			--update the lines
			for lineId = 1, self:GetNumLinesShown() do
				local thisLine = self:GetLine(lineId)
				thisLine.lineText3:SetPoint("right", thisLine.statusbar, "right", -newOffset, 0)
			end
		end

		--check if there's length in the third string, also the third string cannot have a length if the second string is empty
		if (maxStringLength_StringThree > 0) then
			local newOffset = maxStringLength_StringThree + maxStringLength_StringFour + 14
			if (newOffset >= profileOffsetString2) then
				--check if the current needed min distance is bigger than the distance stored in the cache
				local currentCacheMaxValue = Details.CacheInLineMaxDistance[self:GetId()][2]
				if (currentCacheMaxValue < newOffset) then
					currentCacheMaxValue = newOffset
					Details.CacheInLineMaxDistance[self:GetId()][2] = currentCacheMaxValue
				else
					--if not, use the distance value cached to avoid jittering in the string
					newOffset = currentCacheMaxValue
				end

				--update the lines
				for lineId = 1, self:GetNumLinesShown() do
					local thisLine = self:GetLine(lineId)
					thisLine.lineText2:SetPoint("right", thisLine.statusbar, "right", -newOffset, 0)
				end
			end
		end

		--reduce the size of the actor name string based on the total size of all strings in the right side
		for lineId = 1, self:GetNumLinesShown() do
			local thisLine = self:GetLine(lineId)

			--check if there's something showing in this line
			--check if the line is shown and if the text exists for sanitization
			if (thisLine.minha_tabela and thisLine:IsShown() and thisLine.lineText1:GetText()) then
				local playerNameFontString = thisLine.lineText1
				local text2 = thisLine.lineText2
				local text3 = thisLine.lineText3
				local text4 = thisLine.lineText4

				local totalWidth = text2:GetStringWidth() + text3:GetStringWidth() + text4:GetStringWidth()
				totalWidth = totalWidth + 40 - self.fontstrings_text_limit_offset

				DetailsFramework:TruncateTextSafe(playerNameFontString, self.cached_bar_width - totalWidth) --this avoid truncated strings with ...

				--these commented lines are for to create a cache and store the name already truncated there to safe performance
					--local truncatedName = playerNameFontString:GetText()
					--local actorObject = thisLine.minha_tabela
					--actorObject.name_cached = truncatedName
					--actorObject.name_cached_time = GetTime()
			end
		end
	end
end

--handle internal details! events
local eventListener = Details:CreateEventListener()
eventListener:RegisterEvent("COMBAT_PLAYER_ENTER", function()
	if (Details.CacheInLineMaxDistance) then
		wipe(Details.CacheInLineMaxDistance)

		for i = 1, 10 do
			C_Timer.After(i, function()
				wipe(Details.CacheInLineMaxDistance)
			end)
		end
	end
end)

local actor_class_color_r, actor_class_color_g, actor_class_color_b

-- ~texts
--[[exported]] function Details:SetInLineTexts(thisLine, valueText, perSecondText, percentText)
	--set defaults
	local instance = self
	valueText = valueText or ""
	perSecondText = perSecondText or ""
	percentText = percentText or ""

--		local actorSerial = thisLine:GetActor().serial
--		local currentDps = Details.CurrentDps.GetCurrentDps(actorSerial) or perSecondText
--		perSecondText = currentDps
--	end

	--check if the instance is showing total, dps and percent
	local instanceSettings = instance.row_info
	if (not instanceSettings.textR_show_data[3]) then --percent text disabled on options panel
		local attributeId = instance:GetDisplay()
		if (attributeId ~= 5) then --not custom
			percentText = ""
		end
	end

	--parse information
	if (percentText ~= "") then --has percent text
		thisLine.lineText4:SetText(percentText)

		if (perSecondText ~= "") then --has dps?
			thisLine.lineText3:SetText(perSecondText) --set dps
			thisLine.lineText2:SetText(valueText) --set amount
		else
			thisLine.lineText3:SetText(valueText) --set amount
			thisLine.lineText2:SetText("") --clear
		end
	else --no percent text
		if (perSecondText ~= "") then --has dps and no percent
			thisLine.lineText4:SetText(perSecondText) --set dps
			thisLine.lineText3:SetText(valueText) --set amount
			thisLine.lineText2:SetText("") --clear
		else --no dps and not percent
			thisLine.lineText4:SetText(valueText) --set dps
			thisLine.lineText3:SetText("") --clear
			thisLine.lineText2:SetText("") --clear
		end
	end
end

-- ~atualizar ~barra ~update
function atributo_damage:RefreshLine(instance, lineContainer, whichRowLine, rank, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)
	local thisLine = lineContainer[whichRowLine]

	if (not thisLine) then
		print("DEBUG: problema com <instance.thisLine> "..whichRowLine.." "..rank)
		return
	end

	local previousData = thisLine.minha_tabela
	thisLine.minha_tabela = self --store references
	self.minha_barra = thisLine --store references

	thisLine.colocacao = rank
	self.colocacao = rank

	local damageTotal = self.total --total damage of this actor
	local dps
	local percentString
	local percentNumber

	--calc the percent amount base on the percent type
	if (percentage_type == 1) then
		percentString = format("%.1f", self[keyName] / total * 100)

	elseif (percentage_type == 2) then
		percentString = format("%.1f", self[keyName] / instance.top * 100)
	end

	--calculate the actor dps
	if ((Details.time_type == 2 and self.grupo) or not Details:CaptureGet("damage") or instance.segmento == -1) then
		if (instance.segmento == -1 and combat_time == 0) then
			local actor = Details.tabela_vigente(1, self.nome)
			if (actor) then
				local combatTime = actor:Tempo()
				dps = damageTotal / combatTime
				self.last_dps = dps
			else
				dps = damageTotal / combat_time
				self.last_dps = dps
			end
		else
			dps = damageTotal / combat_time
			self.last_dps = dps
		end
	else
		if (not self.on_hold) then
			dps = damageTotal/self:Tempo() --calcula o dps deste objeto
			self.last_dps = dps --salva o dps dele
		else
			if (self.last_dps == 0) then --n�o calculou o dps dele ainda mas entrou em standby
				dps = damageTotal/self:Tempo()
				self.last_dps = dps
			else
				dps = self.last_dps
			end
		end
	end

	--right text
	if (sub_atributo == 1) then --damage done
		dps = _math_floor(dps)
		local formated_damage = SelectedToKFunction(_, damageTotal)
		local formated_dps = SelectedToKFunction(_, dps)
		thisLine.ps_text = formated_dps

		if (not bars_show_data [1]) then
			formated_damage = ""
		end

		if (not bars_show_data [2]) then
			formated_dps = ""
		end

		if (not bars_show_data [3]) then
			percentString = ""
		else
			percentString = percentString .. "%"
		end

		local rightText = formated_damage .. bars_brackets[1] .. formated_dps .. bars_separator .. percentString .. bars_brackets[2]

		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instance.row_info.textR_custom_text, formated_damage, formated_dps, percentString, self, instance.showing, instance, rightText))
		else
			if (instance.use_multi_fontstrings) then
				instance:SetInLineTexts(thisLine, formated_damage, formated_dps, percentString)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end

		percentNumber = _math_floor((damageTotal/instance.top) * 100)

	elseif (sub_atributo == 2) then --dps
		local raw_dps = dps
		dps = _math_floor(dps)

		local formated_damage = SelectedToKFunction(_, damageTotal)
		local formated_dps = SelectedToKFunction(_, dps)
		thisLine.ps_text = formated_dps

		local diff_from_topdps

		if (rank > 1) then
			diff_from_topdps = instance.player_top_dps - raw_dps
		end

		local rightText
		if (diff_from_topdps) then
			local threshold = diff_from_topdps / instance.player_top_dps_threshold * 100
			if (threshold < 100) then
				threshold = abs(threshold - 100)
			else
				threshold = 5
			end

			local rr, gg, bb = Details:percent_color ( threshold )

			rr, gg, bb = Details:hex (_math_floor(rr*255)), Details:hex (_math_floor(gg*255)), "28"
			local color_percent = "" .. rr .. gg .. bb .. ""

			if (not bars_show_data [1]) then
				formated_dps = ""
			end
			if (not bars_show_data [2]) then
				color_percent = ""
			else
				color_percent = bars_brackets[1] .. "|cFFFF4444-|r|cFF" .. color_percent .. SelectedToKFunction(_, _math_floor(diff_from_topdps)) .. "|r" .. bars_brackets[2]
			end

			rightText = formated_dps .. color_percent

		else
			local icon = "  |TInterface\\GROUPFRAME\\UI-Group-LeaderIcon:14:14:0:0:16:16:0:16:0:16|t "
			if (not bars_show_data [1]) then
				formated_dps = ""
			end
			if (not bars_show_data [2]) then
				icon = ""
			end

			rightText = formated_dps .. icon
		end

		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instance.row_info.textR_custom_text, formated_dps, formated_damage, percentString, self, instance.showing, instance, rightText))
		else
			if (instance.use_multi_fontstrings) then
				--instance:SetInLineTexts(thisLine, formated_damage, formated_dps, porcentagem)
				instance:SetInLineTexts(thisLine, rightText)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end

		percentNumber = _math_floor((dps/instance.top) * 100)

	elseif (sub_atributo == 3) then --damage taken
		local dtps = self.damage_taken / combat_time

		local formated_damage_taken = SelectedToKFunction(_, self.damage_taken)
		local formated_dtps = SelectedToKFunction(_, dtps)
		thisLine.ps_text = formated_dtps

		if (not bars_show_data [1]) then
			formated_damage_taken = ""
		end
		if (not bars_show_data [2]) then
			formated_dtps = ""
		end
		if (not bars_show_data [3]) then
			percentString = ""
		else
			percentString = percentString .. "%"
		end

		local rightText = formated_damage_taken .. bars_brackets[1] .. formated_dtps .. bars_separator .. percentString .. bars_brackets[2]
		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instance.row_info.textR_custom_text, formated_damage_taken, formated_dtps, percentString, self, instance.showing, instance, rightText))
		else
			if (instance.use_multi_fontstrings) then
				instance:SetInLineTexts(thisLine, formated_damage_taken, formated_dtps, percentString)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end

		percentNumber = _math_floor((self.damage_taken/instance.top) * 100)

	elseif (sub_atributo == 4) then --friendly fire
		local formated_friendly_fire = SelectedToKFunction(_, self.friendlyfire_total)

		if (not bars_show_data [1]) then
			formated_friendly_fire = ""
		end
		if (not bars_show_data [3]) then
			percentString = ""
		else
			percentString = percentString .. "%"
		end

		local rightText = formated_friendly_fire .. bars_brackets[1] .. percentString ..  bars_brackets[2]
		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instance.row_info.textR_custom_text, formated_friendly_fire, "", percentString, self, instance.showing, instance, rightText))
		else
			if (instance.use_multi_fontstrings) then
				instance:SetInLineTexts(thisLine, "", formated_friendly_fire, percentString)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end
		percentNumber = _math_floor((self.friendlyfire_total/instance.top) * 100)

	elseif (sub_atributo == 6) then --enemies
		local dtps = self.damage_taken / combat_time

		local formatedDamageTaken = SelectedToKFunction(_, self.damage_taken)
		local formatedDtps = SelectedToKFunction(_, dtps)
		thisLine.ps_text = formatedDtps

		if (not bars_show_data [1]) then
			formatedDamageTaken = ""
		end
		if (not bars_show_data [2]) then
			formatedDtps = ""
		end
		if (not bars_show_data [3]) then
			percentString = ""
		else
			percentString = percentString .. "%"
		end

		local rightText = formatedDamageTaken .. bars_brackets[1] .. formatedDtps .. bars_separator .. percentString .. bars_brackets[2]
		if (UsingCustomRightText) then
			thisLine.lineText4:SetText(stringReplace(instance.row_info.textR_custom_text, formatedDamageTaken, formatedDtps, percentString, self, instance.showing, instance, rightText))
		else
			if (instance.use_multi_fontstrings) then
				instance:SetInLineTexts(thisLine, formatedDamageTaken, formatedDtps, percentString)
			else
				thisLine.lineText4:SetText(rightText)
			end
		end

		percentNumber = _math_floor((self.damage_taken/instance.top) * 100)
	end

	--need tooltip update?
	if (thisLine.mouse_over and not instance.baseframe.isMoving) then
		gump:UpdateTooltip(whichRowLine, thisLine, instance)
	end

	if (self.need_refresh) then
		self.need_refresh = false
		forcar = true
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()

	return self:RefreshLineValue(thisLine, instance, previousData, forcar, percentNumber, whichRowLine, lineContainer, use_animations)
end


function Details:RefreshLineValue(thisLine, instance, previousData, isForceRefresh, percent, whichRowLine, lineContainer, useAnimations) --[[ exported]]
	if (thisLine.colocacao == 1) then
		thisLine.animacao_ignorar = true

		if (not previousData or previousData ~= thisLine.minha_tabela or isForceRefresh) then
			thisLine:SetValue(100)

			if (thisLine.hidden or thisLine.fading_in or thisLine.faded) then
				Details.FadeHandler.Fader(thisLine, "out")
			end

			return self:RefreshBarra(thisLine, instance)
		else
			return
		end
	else
		if (thisLine.hidden or thisLine.fading_in or thisLine.faded) then
			--setando o valor  mesmo com anima��es pq o barra esta hidada com o value do �ltimo actor que ela mostrou
			if (useAnimations) then
				thisLine.animacao_fim = percent
				thisLine:SetValue(percent)
			else
				thisLine:SetValue(percent)
				thisLine.animacao_ignorar = true
			end

			Details.FadeHandler.Fader(thisLine, "out")

			return self:RefreshBarra(thisLine, instance)
		else
			--agora esta comparando se a tabela da barra � diferente da tabela na atualiza��o anterior
			if (not previousData or previousData ~= thisLine.minha_tabela or isForceRefresh) then --aqui diz se a barra do jogador mudou de posi��o ou se ela apenas ser� atualizada
				if (useAnimations) then
					thisLine.animacao_fim = percent
				else
					thisLine:SetValue(percent)
					thisLine.animacao_ignorar = true
				end

				thisLine.last_value = percent --reseta o ultimo valor da barra

				return self:RefreshBarra(thisLine, instance)

			elseif (percent ~= thisLine.last_value) then --continua mostrando a mesma tabela ent�o compara a porcentagem
				--apenas atualizar
				if (useAnimations) then
					thisLine.animacao_fim = percent
				else
					thisLine:SetValue(percent)
				end
				thisLine.last_value = percent

				return self:RefreshBarra(thisLine, instance)
			end
		end
	end
end

local setLineTextSize = function(line, instance)
	if (instance.bars_inverted) then
		line.lineText4:SetSize(instance.cached_bar_width - line.lineText1:GetStringWidth() - 20, 15)
	else
		line.lineText1:SetSize(instance.cached_bar_width - line.lineText4:GetStringWidth() - 20, 15)
	end
end


function Details:SetBarLeftText(bar, instance, enemy, arenaEnemy, arenaAlly, usingCustomLeftText) --[[ exported]]
	local barNumber = ""
	if (instance.row_info.textL_show_number) then
		barNumber = bar.colocacao .. ". "
	end

	--translate cyrillic alphabet to western alphabet by Vardex (https://github.com/Vardex May 22, 2019)
	if (instance.row_info.textL_translit_text) then
		self.displayName = Translit:Transliterate(self.displayName, "!")
	end

	if (enemy) then
		if (arenaEnemy) then
			if (instance.row_info.show_arena_role_icon) then
				--show arena role icon
				local sizeOffset = instance.row_info.arena_role_icon_size_offset
				local leftText = barNumber .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:256:" .. Details.role_texcoord [self.role or "NONE"] .. "|t " .. self.displayName
				if (usingCustomLeftText) then
					bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:256:" .. Details.role_texcoord [self.role or "NONE"] .. "|t ", self, instance.showing, instance, leftText))
				else
					bar.lineText1:SetText(leftText)
				end
			else
				--don't show arena role icon
				local leftText = barNumber .. self.displayName
				if (usingCustomLeftText) then
					bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, " ", self, instance.showing, instance, leftText))
				else
					bar.lineText1:SetText(leftText)
				end
			end
		else
			if (instance.row_info.show_faction_icon) then
				local sizeOffset = instance.row_info.faction_icon_size_offset
				if (Details.faction_against == "Horde") then
					local leftText = barNumber .. "|TInterface\\AddOns\\Details\\images\\icones_barra:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:32:0:32:0:32|t"..self.displayName
					if (usingCustomLeftText) then
						bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, "|TInterface\\AddOns\\Details\\images\\icones_barra:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:32:0:32:0:32|t", self, instance.showing, instance, leftText))
					else
						bar.lineText1:SetText(leftText) --seta o texto da esqueda -- HORDA
					end
				else --alliance
					local leftText = barNumber .. "|TInterface\\AddOns\\Details\\images\\icones_barra:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:32:32:64:0:32|t"..self.displayName
					if (usingCustomLeftText) then
						bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, "|TInterface\\AddOns\\Details\\images\\icones_barra:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:32:32:64:0:32|t", self, instance.showing, instance, leftText))
					else
						bar.lineText1:SetText(leftText) --seta o texto da esqueda -- ALLY
					end
				end
			else
				--don't show faction icon
				local leftText = barNumber .. self.displayName
				if (usingCustomLeftText) then
					bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, " ", self, instance.showing, instance, leftText))
				else
					bar.lineText1:SetText(leftText)
				end
			end
		end
	else
		if (arenaAlly and instance.row_info.show_arena_role_icon) then
			local sizeOffset = instance.row_info.arena_role_icon_size_offset
			local leftText = barNumber .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:256:" .. Details.role_texcoord [self.role or "NONE"] .. "|t " .. self.displayName
			if (usingCustomLeftText) then
				bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. (instance.row_info.height + sizeOffset)..":"..(instance.row_info.height + sizeOffset) .. ":0:0:256:256:" .. Details.role_texcoord [self.role or "NONE"] .. "|t ", self, instance.showing, instance, leftText))
			else
				bar.lineText1:SetText(leftText)
			end
		else
			local leftText = barNumber .. self.displayName
			if (usingCustomLeftText) then
				bar.lineText1:SetText(stringReplace(instance.row_info.textL_custom_text, bar.colocacao, self.displayName, "", self, instance.showing, instance, leftText))
			else
				bar.lineText1:SetText(leftText) --seta o texto da esqueda
			end
		end
	end

	setLineTextSize (bar, instance)
end

--[[ exported]] function Details:SetBarColors(bar, instance, r, g, b, a)
	a = a or 1

	if (instance.row_info.texture_class_colors) then
		--[[ Deprecation of right_to_left_texture in favor of StatusBar:SetReverseFill 5/2/2022 - Flamanis
		if (instance.bars_inverted) then
			bar.right_to_left_texture:SetVertexColor(r, g, b, a)
		else
			bar.textura:SetVertexColor(r, g, b, a)
		end]]
		bar.textura:SetVertexColor(r, g, b, a)
	end

	if (instance.row_info.texture_background_class_color) then
		bar.background:SetVertexColor(r, g, b, a)
	end

	if (instance.row_info.textL_class_colors) then
		bar.lineText1:SetTextColor(r, g, b, a)
	end

	if (instance.row_info.textR_class_colors) then
		bar.lineText2:SetTextColor(r, g, b, a)
		bar.lineText3:SetTextColor(r, g, b, a)
		bar.lineText4:SetTextColor(r, g, b, a)
	end

	if (instance.row_info.backdrop.use_class_colors) then
		--get the alpha from the border color
		local alpha = instance.row_info.backdrop.color[4]
		bar.lineBorder:SetVertexColor(r, g, b, alpha)
	end
end

--@self: actor object
function Details:SetClassIcon(texture, instance, class) --[[ exported]]
	local customIcon
	if (Details.immersion_unit_special_icons) then
		customIcon = Details.Immersion.GetIcon(self.aID)
	end

	--set the size offset of the icon
	local iconSizeOffset = instance.row_info.icon_size_offset
	local iconSize = instance.row_info.height
	local newIconSize = iconSize + iconSizeOffset
	texture:SetSize(newIconSize, newIconSize)

	if (customIcon) then
		texture:SetTexture(customIcon[1])
		texture:SetTexCoord(unpack(customIcon[2]))
		texture:SetVertexColor(1, 1, 1)

	elseif (self.spellicon) then
		texture:SetTexture(self.spellicon)
		texture:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)

	elseif (class == "UNKNOW") then
		texture:SetTexture([[Interface\AddOns\Details\images\classes_plus]])
		texture:SetTexCoord(0.50390625, 0.62890625, 0, 0.125)
		texture:SetVertexColor(1, 1, 1)

	elseif (class == "UNGROUPPLAYER") then
		if (self.enemy) then
			if (Details.faction_against == "Horde") then
				texture:SetTexture("Interface\\ICONS\\Achievement_Character_Troll_Male")
				texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			else
				texture:SetTexture("Interface\\ICONS\\Achievement_Character_Nightelf_Female")
				texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			end
		else
			if (Details.faction_against == "Horde") then
				texture:SetTexture("Interface\\ICONS\\Achievement_Character_Nightelf_Female")
				texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			else
				texture:SetTexture("Interface\\ICONS\\Achievement_Character_Troll_Male")
				texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			end
		end

		texture:SetVertexColor(1, 1, 1)

	elseif (class == "PET") then
		texture:SetTexture(instance and instance.row_info.icon_file or [[Interface\AddOns\Details\images\classes_small]])
		texture:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		actor_class_color_r, actor_class_color_g, actor_class_color_b = DetailsFramework:ParseColors(actor_class_color_r, actor_class_color_g, actor_class_color_b)
		texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)

	else
		if (instance and instance.row_info.use_spec_icons) then
			if (self.spec and Details.class_specs_coords[self.spec]) then
				texture:SetTexture(instance.row_info.spec_file)
				texture:SetTexCoord(unpack(Details.class_specs_coords[self.spec]))
				texture:SetVertexColor(1, 1, 1)
			else
				texture:SetTexture(instance.row_info.icon_file or [[Interface\AddOns\Details\images\classes_small]])
				texture:SetTexCoord(unpack(Details.class_coords[class]))
				texture:SetVertexColor(1, 1, 1)
			end
		else
			texture:SetTexture(instance and instance.row_info.icon_file or [[Interface\AddOns\Details\images\classes_small]])
			texture:SetTexCoord(unpack(Details.class_coords[class]))
			texture:SetVertexColor(1, 1, 1)
		end
	end
end


function Details:RefreshBarra(thisLine, instance, fromResize) --[[ exported]]
	local class, enemy, arenaEnemy, arenaAlly = self.classe, self.enemy, self.arena_enemy, self.arena_ally

	if (not class) then
		Details:Msg("Warning, actor without a class:", self.nome, self.flag_original, self.serial)
		self.classe = "UNKNOW"
		class = "UNKNOW"
	end

	if (fromResize) then
		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	end

	--icon
	self:SetClassIcon(thisLine.icone_classe, instance, class)

	--texture color
	self:SetBarColors(thisLine, instance, actor_class_color_r, actor_class_color_g, actor_class_color_b)

	--left text
	self:SetBarLeftText(thisLine, instance, enemy, arenaEnemy, arenaAlly, UsingCustomLeftText)
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------

---------TOOLTIPS BIFURCA��O
-- ~tooltip
function atributo_damage:ToolTip (instance, numero, barra, keydown)
	--seria possivel aqui colocar o icone da classe dele?

	if (instance.atributo == 5) then --custom
		return self:TooltipForCustom(barra)
	else
		if (instance.sub_atributo == 1 or instance.sub_atributo == 2) then --damage done or Dps or enemy
			return self:ToolTip_DamageDone(instance, numero, barra, keydown)

		elseif (instance.sub_atributo == 3) then --damage taken
			return self:ToolTip_DamageTaken(instance, numero, barra, keydown)

		elseif (instance.sub_atributo == 6) then --enemies
			return self:ToolTip_Enemies(instance, numero, barra, keydown)

		elseif (instance.sub_atributo == 4) then --friendly fire
			return self:ToolTip_FriendlyFire(instance, numero, barra, keydown)
		end
	end
end

--tooltip locals
local r, g, b
local barAlha = .6

---------DAMAGE DONE & DPS

function atributo_damage:ToolTip_DamageDone (instancia, numero, barra, keydown)
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack(Details.class_colors [owner.classe])
	else
		if (not Details.class_colors [self.classe]) then
			return print("Details!: error class not found:", self.classe, "for", self.nome)
		end
		r, g, b = unpack(Details.class_colors [self.classe])
	end

	local combatObject = instancia:GetShowingCombat()

	--habilidades
	local icon_size = Details.tooltip.icon_size
	local icon_border = Details.tooltip.icon_border_texcoord

	do
		--TOP HABILIDADES

			--get variables
			--local ActorDamage = self.total_without_pet --mostrando os pets no tooltip
			local ActorDamage = self.total
			local ActorDamageWithPet = self.total
			if (ActorDamage == 0) then
				ActorDamage = 0.00000001
			end
			local ActorSkillsContainer = self.spells._ActorTable
			local ActorSkillsSortTable = {}

			local reflectionSpells = {}

			--get time type
			local meu_tempo
			if (Details.time_type == 1 or not self.grupo) then
				meu_tempo = self:Tempo()
			elseif (Details.time_type == 2) then
				meu_tempo = instancia.showing:GetCombatTime()
			end

			--add actor spells
			for _spellid, _skill in pairs(ActorSkillsContainer) do
				ActorSkillsSortTable [#ActorSkillsSortTable+1] = {_spellid, _skill.total, _skill.total/meu_tempo}
				if (_skill.isReflection) then
					reflectionSpells[#reflectionSpells+1] = _skill
				end
			end

			--add actor pets
			for petIndex, petName in ipairs(self:Pets()) do
				local petActor = instancia.showing[class_type]:PegarCombatente (nil, petName)
				if (petActor) then
					for _spellid, _skill in pairs(petActor:GetActorSpells()) do
						ActorSkillsSortTable [#ActorSkillsSortTable+1] = {_spellid, _skill.total, _skill.total/meu_tempo, petName:gsub((" <.*"), "")}
					end
				end
			end
			--sort
			table.sort(ActorSkillsSortTable, Details.Sort2)

		--TOP INIMIGOS
			--get variables
			local ActorTargetsSortTable = {}

			--add
			for targetName, amount in pairs(self.targets) do
				local targetActorObject = combatObject(DETAILS_ATTRIBUTE_DAMAGE, targetName)
				local npcId = targetActorObject and targetActorObject.aID
				npcId = tonumber(npcId or 0)
				ActorTargetsSortTable[#ActorTargetsSortTable+1] = {targetName, amount, npcId}
			end
			--sort
			table.sort(ActorTargetsSortTable, Details.Sort2)

			--tooltip stuff
			local tooltip_max_abilities = Details.tooltip.tooltip_max_abilities

			local is_maximized = false
			if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
				tooltip_max_abilities = 99
				is_maximized = true
			end

		--MOSTRA HABILIDADES
			Details:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #ActorSkillsSortTable, Details.tooltip_spell_icon.file, unpack(Details.tooltip_spell_icon.coords))

			if (is_maximized) then
				--highlight shift key
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
				Details:AddTooltipHeaderStatusbar (r, g, b, 1)
			else
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
				Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)
			end

			local topAbility = ActorSkillsSortTable [1] and ActorSkillsSortTable [1][2] or 0.0001

			if (#ActorSkillsSortTable > 0) then
				for i = 1, _math_min(tooltip_max_abilities, #ActorSkillsSortTable) do

					local SkillTable = ActorSkillsSortTable [i]

					local spellID = SkillTable [1]
					local totalDamage = SkillTable [2]
					local totalDPS = SkillTable [3]
					local petName = SkillTable [4]

					local nome_magia, _, icone_magia = _GetSpellInfo(spellID)
					if (petName) then
						if (not nome_magia) then
							spellID = spellID or "spellId?"
							nome_magia = "|cffffaa00" .. spellID .. " " .. " (|cFFCCBBBB" .. petName .. "|r)"
						else
							nome_magia = nome_magia .. " (|cFFCCBBBB" .. petName .. "|r)"
						end
					end

					local percent = format("%.1f", totalDamage/ActorDamage*100)
					if (string.len(percent) < 4) then
						percent = percent  .. "0"
					end

					if (instancia.sub_atributo == 1 or instancia.sub_atributo == 6) then
						GameCooltip:AddLine(nome_magia, FormatTooltipNumber (_, totalDamage) .."   ("..percent.."%)")
					else
						GameCooltip:AddLine(nome_magia, FormatTooltipNumber (_, _math_floor(totalDPS)) .."   ("..percent.."%)")
					end

					GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W + 4, icon_size.H + 4, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
					Details:AddTooltipBackgroundStatusbar (false, totalDamage/topAbility*100)
				end
			else
				GameCooltip:AddLine(Loc ["STRING_NO_SPELL"])
			end

		--spell reflected
			if (#reflectionSpells > 0) then
				--small blank space
				Details:AddTooltipSpellHeaderText ("", headerColor, 1, false, 0.1, 0.9, 0.1, 0.9, true) --add a space
				Details:AddTooltipSpellHeaderText ("Spells Reflected", headerColor, 1, select(3, _GetSpellInfo(reflectionSpells[1].id)), 0.1, 0.9, 0.1, 0.9) --localize-me
				Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)

				for i = 1, #reflectionSpells do
					local _spell = reflectionSpells[i]
					local extraInfo = _spell.extra
					for spellId, damageDone in pairs(extraInfo) do
						local spellName, _, spellIcon = _GetSpellInfo(spellId)

						if (spellName) then
							GameCooltip:AddLine(spellName, FormatTooltipNumber (_, damageDone) .. " (" .. _math_floor(damageDone / self.total * 100) .. "%)")
							Details:AddTooltipBackgroundStatusbar (false, damageDone / self.total * 100)
							GameCooltip:AddIcon (spellIcon, 1, 1, icon_size.W, icon_size.H, 0.1, 0.9, 0.1, 0.9)
						end
					end
				end
			end

		--targets (enemies)
			local topEnemy = ActorTargetsSortTable[1] and ActorTargetsSortTable[1][2] or 0
			if (instancia.sub_atributo == 1 or instancia.sub_atributo == 6) then
				--small blank space
				Details:AddTooltipSpellHeaderText("", headerColor, 1, false, 0.1, 0.9, 0.1, 0.9, true)

				Details:AddTooltipSpellHeaderText(Loc ["STRING_TARGETS"], headerColor, #ActorTargetsSortTable, [[Interface\Addons\Details\images\icons]], 0, 0.03125, 0.126953125, 0.15625)

				local max_targets = Details.tooltip.tooltip_max_targets
				local is_maximized = false
				if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
					max_targets = 99
					is_maximized = true
				end

				if (is_maximized) then
					--highlight
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
					Details:AddTooltipHeaderStatusbar(r, g, b, 1)
				else
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
					Details:AddTooltipHeaderStatusbar(r, g, b, barAlha)
				end

				for i = 1, math.min(max_targets, #ActorTargetsSortTable) do
					local enemyTable = ActorTargetsSortTable[i]
					GameCooltip:AddLine(enemyTable[1], FormatTooltipNumber(_, enemyTable[2]) .." ("..format("%.1f", enemyTable[2] / ActorDamageWithPet * 100).."%)")
					
					local portraitTexture-- = Details222.Textures.GetPortraitTextureForNpcID(enemyTable[3]) --disabled atm
					if (portraitTexture) then
						GameCooltip:AddIcon(portraitTexture, 1, 1, icon_size.W, icon_size.H)
					else
						GameCooltip:AddIcon([[Interface\PetBattles\PetBattle-StatIcons]], nil, nil, icon_size.W, icon_size.H, 0, 0.5, 0, 0.5, {.7, .7, .7, 1}, nil, true)
					end

					Details:AddTooltipBackgroundStatusbar(false, enemyTable[2] / topEnemy * 100)
				end
			end
	end

	--PETS
	local instance = instancia
	local combatObject = instance:GetShowingCombat()

	local myPets = self.pets
	if (#myPets > 0) then --teve ajudantes
		local petAmountWithSameName = {} --armazena a quantidade de pets iguais
		local petDamageTable = {} --armazena o dano total de cada objeto

		--small blank space
		Details:AddTooltipSpellHeaderText("", headerColor, 1, false, 0.1, 0.9, 0.1, 0.9, true)

		for index, petName in ipairs(myPets) do
			if (not petAmountWithSameName[petName]) then
				petAmountWithSameName[petName] = 1
				local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
				local petActorObject = damageContainer:GetActor(petName)

				if (petActorObject) then
					local petDamageDone = petActorObject.total_without_pet
					local petSpells = petActorObject:GetSpellList()
					local petSpellsSorted = {}

					--local timeInCombat = petActorObject:GetTimeInCombat(self)
					local timeInCombat = 0
					if (Details.time_type == 1 or not self.grupo) then
						timeInCombat = petActorObject:Tempo()
					elseif (Details.time_type == 2) then
						timeInCombat = petActorObject:GetCombatTime()
					end

					petDamageTable[#petDamageTable+1] = {petName, petActorObject.total_without_pet, petActorObject.total_without_pet / timeInCombat}

					for spellId, spellTable in pairs(petSpells) do
						local spellName, rank, spellIcon = _GetSpellInfo(spellId)
						tinsert(petSpellsSorted, {spellId, spellTable.total, spellTable.total / petDamageDone * 100, {spellName, rank, spellIcon}})
					end

					table.sort(petSpellsSorted, Details.Sort2)

					local petTargets = {}
					petSpells = petActorObject.targets
					for targetName, spellDamageDone in pairs(petSpells) do
						tinsert(petTargets, {targetName, spellDamageDone, spellDamageDone / petDamageDone * 100})
					end
					table.sort(petTargets,Details.Sort2)
				end
			else
				petAmountWithSameName[petName] = petAmountWithSameName[petName] + 1
			end
		end

		local petHeaderAdded = false

		table.sort(petDamageTable, Details.Sort2)

		local ismaximized = false
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			ismaximized = true
		end

		local topPetDamageDone = petDamageTable[1] and petDamageTable[1][2] or 0

		for index, damageTable in ipairs(petDamageTable) do
			if (damageTable [2] > 0 and (index <= Details.tooltip.tooltip_max_pets or ismaximized)) then
				if (not petHeaderAdded) then
					petHeaderAdded = true
					Details:AddTooltipSpellHeaderText(Loc ["STRING_PETS"], headerColor, #petDamageTable, [[Interface\COMMON\friendship-heart]], 0.21875, 0.78125, 0.09375, 0.6875)

					if (ismaximized) then
						GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_alt]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
						Details:AddTooltipHeaderStatusbar(r, g, b, 1)
					else
						GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_alt]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
						Details:AddTooltipHeaderStatusbar(r, g, b, barAlha)
					end
				end

				local petName = damageTable[1]
				local petDamageDone = damageTable[2]
				local petDPS = damageTable[3]

				petName = damageTable[1]:gsub(("%s%<.*"), "")
				if (instancia.sub_atributo == 1) then
					GameCooltip:AddLine(petName, FormatTooltipNumber(_, petDamageDone) .. " (" .. math.floor(petDamageDone/self.total*100) .. "%)")
				else
					GameCooltip:AddLine(petName, FormatTooltipNumber(_, math.floor(petDPS)) .. " (" .. math.floor(petDamageDone/self.total*100) .. "%)")
				end

				Details:AddTooltipBackgroundStatusbar(false, petDamageDone / topPetDamageDone * 100)

				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small_alpha]], 1, 1, icon_size.W, icon_size.H, 0.25/2, 0.49609375/2, 0.75/2, 1/2)
			end
		end
	end

	--~Phases
	local segment = instancia:GetShowingCombat()
	if (segment and self.grupo) then
		local bossInfo = segment:GetBossInfo()
		local phasesInfo = segment:GetPhases()
		if (bossInfo and phasesInfo) then
			if (#phasesInfo > 1) then

				--small blank space
				Details:AddTooltipSpellHeaderText ("", headerColor, 1, false, 0.1, 0.9, 0.1, 0.9, true)

				Details:AddTooltipSpellHeaderText ("Damage by Encounter Phase", headerColor, 1, [[Interface\Garrison\orderhall-missions-mechanic8]], 11/64, 53/64, 11/64, 53/64) --localize-me
				Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)

				local playerPhases = {}
				local totalDamage = 0

				for phase, playersTable in pairs(phasesInfo.damage) do --each phase

					local allPlayers = {} --all players for this phase
					for playerName, amount in pairs(playersTable) do
						tinsert(allPlayers, {playerName, amount})
						totalDamage = totalDamage + amount
					end
					table.sort (allPlayers, function(a, b) return a[2] > b[2] end)

					local myRank = 0
					for i = 1, #allPlayers do
						if (allPlayers [i] [1] == self.nome) then
							myRank = i
							break
						end
					end

					tinsert(playerPhases, {phase, playersTable [self.nome] or 0, myRank, (playersTable [self.nome] or 0) / totalDamage * 100})
				end

				table.sort (playerPhases, function(a, b) return a[1] < b[1] end)

				for i = 1, #playerPhases do
					--[1] Phase Number [2] Amount Done [3] Rank [4] Percent
					GameCooltip:AddLine("|cFFF0F0F0Phase|r " .. playerPhases [i][1], FormatTooltipNumber (_, playerPhases [i][2]) .. " (|cFFFFFF00#" .. playerPhases [i][3] ..  "|r, " .. format("%.1f", playerPhases [i][4]) .. "%)")
					GameCooltip:AddIcon ([[Interface\Garrison\orderhall-missions-mechanic9]], 1, 1, 14, 14, 11/64, 53/64, 11/64, 53/64)
					Details:AddTooltipBackgroundStatusbar()
				end
			end
		end
	end

	return true
end

local on_switch_show_enemies = function(instance)
	instance:TrocaTabela(instance, true, 1, 6)
	return true
end

local on_switch_show_frags = function(instance)
	instance:TrocaTabela(instance, true, 1, 5)
	return true
end

local ENEMIES_format_name = function(player) if (player == 0) then return false end return Details:GetOnlyName(player.nome) end
local ENEMIES_format_amount = function(amount) if (amount <= 0) then return false end return Details:ToK(amount) .. " (" .. format("%.1f", amount / tooltip_temp_table.damage_total * 100) .. "%)" end

function atributo_damage:ReportEnemyDamageTaken (actor, instance, ShiftKeyDown, ControlKeyDown, fromFrags)
	if (ShiftKeyDown) then
		local inimigo = actor.nome
		local custom_name = inimigo .. " -" .. Loc ["STRING_CUSTOM_ENEMY_DT"]

		--procura se j� tem um custom:
		for index, CustomObject in ipairs(Details.custom) do
			if (CustomObject:GetName() == custom_name) then
				--fix for not saving funcs on logout
				if (not CustomObject.OnSwitchShow) then
					CustomObject.OnSwitchShow = fromFrags and on_switch_show_frags or on_switch_show_enemies
				end
				return instance:TrocaTabela(instance.segmento, 5, index)
			end
		end

		--criar um custom para este actor.
		local new_custom_object = {
			name = custom_name,
			icon = [[Interface\ICONS\Pet_Type_Undead]],
			attribute = "damagedone",
			author = Details.playername,
			desc = inimigo .. " Damage Taken",
			source = "[raid]",
			target = inimigo,
			script = false,
			tooltip = false,
			temp = true,
			OnSwitchShow = fromFrags and on_switch_show_frags or on_switch_show_enemies,
		}

		tinsert(Details.custom, new_custom_object)
		setmetatable(new_custom_object, Details.atributo_custom)
		new_custom_object.__index = Details.atributo_custom

		return instance:TrocaTabela(instance.segmento, 5, #Details.custom)
	end

	local report_table = {"Details!: " .. actor.nome .. " - " .. Loc ["STRING_ATTRIBUTE_DAMAGE_TAKEN"]}

	Details:FormatReportLines (report_table, tooltip_temp_table, ENEMIES_format_name, ENEMIES_format_amount)

	return Details:Reportar (report_table, {_no_current = true, _no_inverse = true, _custom = true})
end

local FRAGS_format_name = function(player_name) return Details:GetOnlyName(player_name) end
local FRAGS_format_amount = function(amount) return Details:ToK(amount) .. " (" .. format("%.1f", amount / frags_tooltip_table.damage_total * 100) .. "%)" end

function atributo_damage:ReportSingleFragsLine (frag, instance, ShiftKeyDown, ControlKeyDown)

	if (ShiftKeyDown) then
		return atributo_damage:ReportEnemyDamageTaken (frag, instance, ShiftKeyDown, ControlKeyDown, true)
	end

	local report_table = {"Details!: " .. frag [1] .. " - " .. Loc ["STRING_ATTRIBUTE_DAMAGE_TAKEN"]}

	Details:FormatReportLines (report_table, frags_tooltip_table, FRAGS_format_name, FRAGS_format_amount)

	return Details:Reportar (report_table, {_no_current = true, _no_inverse = true, _custom = true})
end

function atributo_damage:ToolTip_Enemies (instancia, numero, barra, keydown)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack(Details.class_colors [owner.classe])
	else
		r, g, b = unpack(Details.class_colors [self.classe])
	end

	local combat = instancia:GetShowingCombat()
	local enemy_name = self:name()

	--enemy damage taken
	local i = 1
	local damage_taken = 0
	for _, actor in ipairs(combat[1]._ActorTable) do
		if (actor.grupo and actor.targets [self.nome]) then
			local t = tooltip_temp_table [i]
			if (not t) then
				tooltip_temp_table [i] = {}
				t = tooltip_temp_table [i]
			end
			t [1] = actor
			t [2] = actor.targets [enemy_name] or 0
			damage_taken = damage_taken + t [2]
			i = i + 1
		end
	end

	for o = i, #tooltip_temp_table do
		local t = tooltip_temp_table [o]
		t[2] = 0
		t[1] = 0
	end

	_table_sort(tooltip_temp_table, Details.Sort2)

	-- enemy damage taken
	Details:AddTooltipSpellHeaderText (Loc ["STRING_DAMAGE_TAKEN_FROM"], headerColor, i-1, [[Interface\Buttons\UI-MicroStream-Red]], 0.1875, 0.8125, 0.15625, 0.78125)
	GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)

	Details:AddTooltipHeaderStatusbar (1, 1, 1, 0.5)

	--build the tooltip
	local top = (tooltip_temp_table [1] and tooltip_temp_table [1][2]) or 0
	tooltip_temp_table.damage_total = damage_taken

	local lineHeight = Details.tooltip.line_height

	for o = 1, i-1 do

		local player = tooltip_temp_table [o][1]
		local total = tooltip_temp_table [o][2]
		local player_name = Details:GetOnlyName(player:name())

		GameCooltip:AddLine(player_name .. " ", FormatTooltipNumber (_, total) .." (" .. format("%.1f", (total / damage_taken) * 100) .. "%)")

		local classe = player:class()
		if (not classe) then
			classe = "UNKNOW"
		end
		if (classe == "UNKNOW") then
			GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, lineHeight, lineHeight, .25, .5, 0, 1)
		else
			local specID = player.spec
			if (specID) then
				local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
				GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
			else
				GameCooltip:AddIcon (instancia.row_info.icon_file, nil, nil, lineHeight, lineHeight, unpack(Details.class_coords [classe]))
			end
		end

		local r, g, b = unpack(Details.class_colors [classe])
		GameCooltip:AddStatusBar (total/top*100, 1, r, g, b, 1, false, enemies_background)

	end

	GameCooltip:SetOption("StatusBarTexture", "Interface\\AddOns\\Details\\images\\bar_serenity")

	--damage done and heal
	GameCooltip:AddLine(" ")
	GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_DAMAGE_ENEMIES_DONE"], FormatTooltipNumber (_, _math_floor(self.total)))
	local half = 0.00048828125
	GameCooltip:AddIcon (instancia:GetSkinTexture(), 1, 1, 14, 14, 0.005859375 + half, 0.025390625 - half, 0.3623046875, 0.3818359375)
	GameCooltip:AddStatusBar (0, 1, r, g, b, 1, false, enemies_background)

	local heal_actor = instancia.showing (2, self.nome)
	if (heal_actor) then
		GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_HEAL_ENEMY"], FormatTooltipNumber (_, _math_floor(heal_actor.heal_enemy_amt)))
	else
		GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_HEAL_ENEMY"], 0)
	end
	GameCooltip:AddIcon (instancia:GetSkinTexture(), 1, 1, 14, 14, 0.037109375 + half, 0.056640625 - half, 0.3623046875, 0.3818359375)
	GameCooltip:AddStatusBar (0, 1, r, g, b, 1, false, enemies_background)

	GameCooltip:AddLine(" ")
	Details:AddTooltipReportLineText()

	GameCooltip:SetOption("YSpacingMod", 0)

	return true
end

---------DAMAGE TAKEN
function atributo_damage:ToolTip_DamageTaken (instance, numero, barra, keydown)
	--if the object has a owner, it's a pet
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack(Details.class_colors[owner.classe])
	else
		r, g, b = unpack(Details.class_colors[self.classe])
	end

	local damageTakenFrom = self.damage_from
	local totalDamageTaken = self.damage_taken
	local actorName = self:Name()

	local combatObject = instance:GetShowingCombat()
	local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)

	local damageTakenSorted = {}
	local mainAttribute, subAttribute = instance:GetDisplay()

	if (subAttribute == DETAILS_SUBATTRIBUTE_ENEMIES) then
		for _, actorObject in damageContainer:ListActors() do
			if (actorObject:IsGroupPlayer() and actorObject.targets[actorName]) then
				damageTakenSorted [#damageTakenSorted+1] = {actorName, actorObject.targets[actorName], actorObject.classe, actorObject}
			end
		end
	else
		for enemyName, _ in pairs(damageTakenFrom) do --who damaged the player
			--get the aggressor
			local enemyActorObject = damageContainer:GetActor(enemyName)
			if (enemyActorObject) then
				--local name = enemyName
				local damageTakenTable
				local damageInflictedByThisEnemy = enemyActorObject.targets[actorName]

				if (damageInflictedByThisEnemy) then
					if (enemyActorObject:IsPlayer() or enemyActorObject:IsNeutralOrEnemy()) then
						damageTakenTable = {enemyName, damageInflictedByThisEnemy, enemyActorObject.classe, enemyActorObject}
						damageTakenSorted [#damageTakenSorted+1] = damageTakenTable
					end
				end

				--special cases - monk stagger
				if (enemyName == actorName and self.classe == "MONK") then
					local ff = enemyActorObject.friendlyfire [enemyName]
					if (ff and ff.total > 0) then
						local staggerDamage = ff.spells [124255] or 0
						if (staggerDamage > 0) then
							if (damageTakenTable) then
								damageTakenTable [2] = damageTakenTable [2] + staggerDamage
							else
								damageTakenSorted [#damageTakenSorted+1] = {enemyName, staggerDamage, "MONK", enemyActorObject}
							end
						end
					end
				end
			end
		end

	end

	local max = #damageTakenSorted
	if (max > 10) then
		max = 10
	end

	local bIsMaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3 or instance.sub_atributo == 6 or Details.damage_taken_everything) then
		max = #damageTakenSorted
		bIsMaximized = true
	end

	if (subAttribute == DETAILS_SUBATTRIBUTE_ENEMIES) then
		Details:AddTooltipSpellHeaderText (Loc ["STRING_DAMAGE_TAKEN_FROM"], headerColor, #damageTakenSorted, [[Interface\Buttons\UI-MicroStream-Red]], 0.1875, 0.8125, 0.15625, 0.78125)
	else
		Details:AddTooltipSpellHeaderText (Loc ["STRING_FROM"], headerColor, #damageTakenSorted, [[Interface\Addons\Details\images\icons]], 0.126953125, 0.1796875, 0, 0.0546875)
	end

	if (bIsMaximized) then
		--highlight
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
		if (subAttribute == DETAILS_SUBATTRIBUTE_ENEMIES) then
			GameCooltip:AddStatusBar (100, 1, 0.7, g, b, 1)
		else
			Details:AddTooltipHeaderStatusbar (r, g, b, 1)
		end
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
		if (subAttribute == DETAILS_SUBATTRIBUTE_ENEMIES) then
			GameCooltip:AddStatusBar (100, 1, 0.7, 0, 0, barAlha)
		else
			Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		end
	end

	local iconSize = Details.tooltip.icon_size
	local iconBorderTexCoord = Details.tooltip.icon_border_texcoord

	for i = 1, max do
		local enemyActorObject = damageTakenSorted[i][4]

		--only shows damage from enemies or from the player it self
		--the player it self can only be placed on the list by the iteration above
		--the iteration doesnt check friendly fire for all actors, only a few cases like Monk Stagger

		--bug: on the first iteration it's grabbing all actors that inflicted damage to this player
		--here it gets all spells from the player and display them, which won't be sorted

		if (enemyActorObject:IsNeutralOrEnemy() or enemyActorObject.nome == self.nome) then
			local all_spells = {}

			for spellid, spell in pairs(enemyActorObject.spells._ActorTable) do
				local on_target = spell.targets [self.nome]
				if (on_target) then
					tinsert(all_spells, {spellid, on_target, enemyActorObject.nome})
				end
			end

			--friendly fire
			local friendlyFire = enemyActorObject.friendlyfire [self.nome]
			if (friendlyFire) then
				for spellid, amount in pairs(friendlyFire.spells) do
					tinsert(all_spells, {spellid, amount, enemyActorObject.nome})
				end
			end

			for _, spell in ipairs(all_spells) do
				local spellname, _, spellicon = _GetSpellInfo(spell [1])
				GameCooltip:AddLine(spellname .. " (|cFFFFFF00" .. spell [3] .. "|r)", FormatTooltipNumber (_, spell [2]).." (" .. format("%.1f", (spell [2] / totalDamageTaken) * 100).."%)")
				GameCooltip:AddIcon (spellicon, 1, 1, iconSize.W, iconSize.H, iconBorderTexCoord.L, iconBorderTexCoord.R, iconBorderTexCoord.T, iconBorderTexCoord.B)
				Details:AddTooltipBackgroundStatusbar()
			end

		else
			local aggressorName = Details:GetOnlyName(damageTakenSorted[i][1])
			if (bIsMaximized and damageTakenSorted[i][1]:find(Details.playername)) then
				GameCooltip:AddLine(aggressorName, FormatTooltipNumber (_, damageTakenSorted[i][2]).." ("..format("%.1f", (damageTakenSorted[i][2]/totalDamageTaken) * 100).."%)", nil, "yellow")
			else
				GameCooltip:AddLine(aggressorName, FormatTooltipNumber (_, damageTakenSorted[i][2]).." ("..format("%.1f", (damageTakenSorted[i][2]/totalDamageTaken) * 100).."%)")
			end
			local classe = damageTakenSorted[i][3]

			if (not classe) then
				classe = "UNKNOW"
			end

			if (classe == "UNKNOW") then
				GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, iconSize.W, iconSize.H, .25, .5, 0, 1)
			else
				GameCooltip:AddIcon (instance.row_info.icon_file, nil, nil, iconSize.W, iconSize.H, unpack(Details.class_coords [classe]))
			end
			Details:AddTooltipBackgroundStatusbar()
		end
	end

	if (subAttribute == DETAILS_SUBATTRIBUTE_ENEMIES) then
		GameCooltip:AddLine(" ")
		GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_DAMAGE_DONE"], FormatTooltipNumber (_, _math_floor(self.total)))
		local half = 0.00048828125
		GameCooltip:AddIcon (instance:GetSkinTexture(), 1, 1, iconSize.W, iconSize.H, 0.005859375 + half, 0.025390625 - half, 0.3623046875, 0.3818359375)
		Details:AddTooltipBackgroundStatusbar()

		local heal_actor = instance.showing (2, self.nome)
		if (heal_actor) then
			GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_HEAL_DONE"], FormatTooltipNumber (_, _math_floor(heal_actor.heal_enemy_amt)))
		else
			GameCooltip:AddLine(Loc ["STRING_ATTRIBUTE_HEAL_DONE"], 0)
		end
		GameCooltip:AddIcon (instance:GetSkinTexture(), 1, 1, iconSize.W, iconSize.H, 0.037109375 + half, 0.056640625 - half, 0.3623046875, 0.3818359375)
		Details:AddTooltipBackgroundStatusbar()
	end

	return true
end

---------FRIENDLY FIRE
function atributo_damage:ToolTip_FriendlyFire (instancia, numero, barra, keydown)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack(Details.class_colors [owner.classe])
	else
		r, g, b = unpack(Details.class_colors [self.classe])
	end

	local FriendlyFire = self.friendlyfire
	local FriendlyFireTotal = self.friendlyfire_total
	local combat = instancia:GetShowingCombat()

	local tabela_do_combate = instancia.showing
	local showing = tabela_do_combate [class_type]

	local icon_size = Details.tooltip.icon_size
	local icon_border = Details.tooltip.icon_border_texcoord
	local lineHeight = Details.tooltip.line_height

	local DamagedPlayers = {}
	local Skills = {}

	for target_name, ff_table in pairs(FriendlyFire) do
		local actor = combat (1, target_name)
		if (actor) then
			DamagedPlayers [#DamagedPlayers+1] = {target_name, ff_table.total, actor.classe}
			for spellid, amount in pairs(ff_table.spells) do
				Skills [spellid] = (Skills [spellid] or 0) + amount
			end
		end
	end

	_table_sort(DamagedPlayers, Details.Sort2)

	Details:AddTooltipSpellHeaderText (Loc ["STRING_TARGETS"], headerColor, #DamagedPlayers, Details.tooltip_target_icon.file, unpack(Details.tooltip_target_icon.coords))

	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
		Details:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
		Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end

	local max_abilities = Details.tooltip.tooltip_max_abilities
	if (ismaximized) then
		max_abilities = 99
	end

	for i = 1, _math_min(max_abilities, #DamagedPlayers) do
		local classe = DamagedPlayers[i][3]
		if (not classe) then
			classe = "UNKNOW"
		end

		GameCooltip:AddLine(Details:GetOnlyName(DamagedPlayers[i][1]), FormatTooltipNumber (_, DamagedPlayers[i][2]).." ("..format("%.1f", DamagedPlayers[i][2]/FriendlyFireTotal*100).."%)")
		GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\espadas", nil, nil, lineHeight, lineHeight)
		Details:AddTooltipBackgroundStatusbar()

		if (classe == "UNKNOW") then
			GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, lineHeight, lineHeight, unpack(Details.class_coords ["UNKNOW"]))
		else
			local specID = Details:GetSpec(DamagedPlayers[i][1])
			if (specID) then
				local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
				GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
			else
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, lineHeight, lineHeight, unpack(Details.class_coords [classe]))
			end
		end

	end

	Details:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, 1, Details.tooltip_spell_icon.file, unpack(Details.tooltip_spell_icon.coords))

	local ismaximized = false
	if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
		Details:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay1)
		Details:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end

	local max_abilities2 = Details.tooltip.tooltip_max_abilities
	if (ismaximized) then
		max_abilities2 = 99
	end

	--spells usadas no friendly fire
	local SpellsInOrder = {}
	for spellID, amount in pairs(Skills) do
		SpellsInOrder [#SpellsInOrder+1] = {spellID, amount}
	end
	_table_sort(SpellsInOrder, Details.Sort2)

	for i = 1, _math_min(max_abilities2, #SpellsInOrder) do
		local nome, _, icone = _GetSpellInfo(SpellsInOrder[i][1])
		GameCooltip:AddLine(nome, FormatTooltipNumber (_, SpellsInOrder[i][2]).." ("..format("%.1f", SpellsInOrder[i][2]/FriendlyFireTotal*100).."%)")
		GameCooltip:AddIcon (icone, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
		Details:AddTooltipBackgroundStatusbar()
	end

	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------


---------DETALHES BIFURCA��O ~detalhes ~detailswindow ~bi
function atributo_damage:MontaInfo()
	if (info.sub_atributo == 1 or info.sub_atributo == 2 or info.sub_atributo == 6) then --damage done & dps
		return self:MontaInfoDamageDone()
	elseif (info.sub_atributo == 3) then --damage taken
		return self:MontaInfoDamageTaken()
	elseif (info.sub_atributo == 4) then --friendly fire
		return self:MontaInfoFriendlyFire()
	end
end

---------DETALHES bloco da direita BIFURCA��O
function atributo_damage:MontaDetalhes (spellid, barra, instancia)
	if (info.sub_atributo == 1 or info.sub_atributo == 2) then
		return self:MontaDetalhesDamageDone (spellid, barra, instancia)

	elseif (info.sub_atributo == 3) then
		return self:MontaDetalhesDamageTaken (spellid, barra, instancia)

	elseif (info.sub_atributo == 4) then
		return self:MontaDetalhesFriendlyFire (spellid, barra, instancia)

	elseif (info.sub_atributo == 6) then
		if (bitBand(self.flag_original, 0x00000400) ~= 0) then --� um jogador
			return self:MontaDetalhesDamageDone (spellid, barra, instancia)
		end
		return self:MontaDetalhesEnemy (spellid, barra, instancia)
	end
end


------ Friendly Fire
function atributo_damage:MontaInfoFriendlyFire()

	local instancia = info.instancia
	local combat = instancia:GetShowingCombat()
	local barras = info.barras1
	local barras2 = info.barras2
	local barras3 = info.barras3

	local FriendlyFireTotal = self.friendlyfire_total

	local DamagedPlayers = {}
	local Skills = {}

	for target_name, ff_table in pairs(self.friendlyfire) do

		local actor = combat (1, target_name)
		if (actor) then
			tinsert(DamagedPlayers, {target_name, ff_table.total, ff_table.total / FriendlyFireTotal * 100, actor.classe})

			for spellid, amount in pairs(ff_table.spells) do
				Skills [spellid] = (Skills [spellid] or 0) + amount
			end
		end
	end

	_table_sort(DamagedPlayers, Details.Sort2)

	local amt = #DamagedPlayers
	gump:JI_AtualizaContainerBarras (amt)

	local FirstPlaceDamage = DamagedPlayers [1] and DamagedPlayers [1][2] or 0

	for index, tabela in ipairs(DamagedPlayers) do
		local barra = barras [index]

		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
			barra.textura:SetStatusBarColor(1, 1, 1, 1)
			barra.on_focus = false
		end

		if (not info.mostrando_mouse_over) then
			if (tabela[1] == self.detalhes) then --tabela [1] = NOME = NOME que esta na caixa da direita
				if (not barra.on_focus) then --se a barra n�o tiver no foco
					barra.textura:SetStatusBarColor(129/255, 125/255, 69/255, 1)
					barra.on_focus = true
					if (not info.mostrando) then
						info.mostrando = barra
					end
				end
			else
				if (barra.on_focus) then
					barra.textura:SetStatusBarColor(1, 1, 1, 1) --volta a cor antiga
					barra:SetAlpha(.9) --volta a alfa antiga
					barra.on_focus = false
				end
			end
		end

		if (index == 1) then
			barra.textura:SetValue(100)
		else
			barra.textura:SetValue(tabela[2]/FirstPlaceDamage*100)
		end

		barra.lineText1:SetText(index .. instancia.divisores.colocacao .. Details:GetOnlyName(tabela[1])) --seta o texto da esqueda
		barra.lineText4:SetText(Details:comma_value (tabela[2]) .. " (" .. format("%.1f", tabela[3]) .."%)") --seta o texto da direita

		local classe = tabela[4]
		if (not classe) then
			classe = "MONSTER"
		end

		barra.icone:SetTexture(info.instancia.row_info.icon_file)

		if (Details.class_coords [classe]) then
			barra.icone:SetTexCoord(unpack(Details.class_coords [classe]))
		else
			barra.icone:SetTexture("")
		end

		local color = Details.class_colors [classe]
		if (color) then
			barra.textura:SetStatusBarColor(unpack(color))
		else
			barra.textura:SetStatusBarColor(1, 1, 1)
		end

		barra.minha_tabela = self
		barra.show = tabela[1]
		barra:Show()

		if (self.detalhes and self.detalhes == barra.show) then
			self:MontaDetalhes (self.detalhes, barra, instancia)
		end
	end

	local SkillTable = {}
	for spellid, amt in pairs(Skills) do
		local nome, _, icone = _GetSpellInfo(spellid)
		SkillTable [#SkillTable+1] = {nome, amt, amt/FriendlyFireTotal*100, icone}
	end

	_table_sort(SkillTable, Details.Sort2)

	amt = #SkillTable
	if (amt < 1) then
		return
	end

	gump:JI_AtualizaContainerAlvos (amt)

	FirstPlaceDamage = SkillTable [1] and SkillTable [1][2] or 0

	for index, tabela in ipairs(SkillTable) do
		local barra = barras2 [index]

		if (not barra) then
			barra = gump:CriaNovaBarraInfo2 (instancia, index)
			barra.textura:SetStatusBarColor(1, 1, 1, 1)
		end

		if (index == 1) then
			barra.textura:SetValue(100)
		else
			barra.textura:SetValue(tabela[2]/FirstPlaceDamage*100)
		end

		barra.lineText1:SetText(index..instancia.divisores.colocacao..tabela[1]) --seta o texto da esqueda
		barra.lineText4:SetText(Details:comma_value (tabela[2]) .." (" ..format("%.1f", tabela[3]) .. ")") --seta o texto da direita
		barra.icone:SetTexture(tabela[4])

		barra.minha_tabela = nil --desativa o tooltip

		barra:Show()
	end

end

------ Damage Taken
function atributo_damage:MontaInfoDamageTaken()

	local damage_taken = self.damage_taken
	local agressores = self.damage_from
	local instancia = info.instancia
	local tabela_do_combate = instancia.showing
	local showing = tabela_do_combate [class_type] --o que esta sendo mostrado -> [1] - dano [2] - cura --pega o container com ._NameIndexTable ._ActorTable
	local barras = info.barras1
	local meus_agressores = {}

	local este_agressor
	for nome, _ in pairs(agressores) do
		este_agressor = showing._ActorTable[showing._NameIndexTable[nome]]
		if (este_agressor) then
			local alvos = este_agressor.targets
			local este_alvo = alvos [self.nome]
			if (este_alvo) then
				meus_agressores [#meus_agressores+1] = {nome, este_alvo, este_alvo/damage_taken*100, este_agressor.classe}
			end
		end
	end

	local amt = #meus_agressores

	if (amt < 1) then --caso houve apenas friendly fire
		return true
	end

	--_table_sort(meus_agressores, function(a, b) return a[2] > b[2] end)
	_table_sort(meus_agressores, Details.Sort2)

	gump:JI_AtualizaContainerBarras (amt)

	local max_ = meus_agressores [1] and meus_agressores [1][2] or 0

	local barra
	for index, tabela in ipairs(meus_agressores) do
		barra = barras [index]
		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
		end

		self:FocusLock(barra, tabela[1])

		local texCoords = Details.class_coords [tabela[4]]
		if (not texCoords) then
			texCoords = Details.class_coords ["UNKNOW"]
		end

		local formated_value = SelectedToKFunction(_, _math_floor(tabela[2]))
		self:UpdadeInfoBar(barra, index, tabela[1], tabela[1], tabela[2], formated_value, max_, tabela[3], "Interface\\AddOns\\Details\\images\\classes_small_alpha", true, texCoords, nil, tabela[4])
	end

end

--[[exported]] function Details:UpdadeInfoBar(row, index, spellId, name, value, formattedValue, max, percent, icon, detalhes, texCoords, spellSchool, class)
	if (index == 1) then
		row.textura:SetValue(100)
	else
		max = math.max(max, 0.001)
		row.textura:SetValue(value / max * 100)
	end

	if (type(index) == "number") then
		if (debugmode) then
			row.lineText1:SetText(index .. ". " .. name .. " (" .. spellId .. ")")
		else
			row.lineText1:SetText(index .. ". " .. name)
		end
	else
		row.lineText1:SetText(name)
	end

	row.lineText1.text = row.lineText1:GetText()

	if (formattedValue) then
		row.lineText4:SetText(formattedValue .. " (" .. format("%.1f", percent) .."%)")
	end

	row.lineText1:SetSize(row:GetWidth() - row.lineText4:GetStringWidth() - 40, 15)

	if (icon) then
		row.icone:SetTexture(icon)
		if (icon == "Interface\\AddOns\\Details\\images\\classes_small") then
			row.icone:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		else
			row.icone:SetTexCoord(0, 1, 0, 1)
		end
	else
		row.icone:SetTexture("")
	end

	if (not row.IconUpBorder) then
		row.IconUpBorder = CreateFrame("frame", nil, row,"BackdropTemplate")
		row.IconUpBorder:SetAllPoints(row.icone)
		row.IconUpBorder:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		row.IconUpBorder:SetBackdropBorderColor(0, 0, 0, 0.75)
	end

	if (texCoords) then
		row.icone:SetTexCoord(unpack(texCoords))
	else
		local iconBorder = Details.tooltip.icon_border_texcoord
		row.icone:SetTexCoord(iconBorder.L, iconBorder.R, iconBorder.T, iconBorder.B)
	end

	row.minha_tabela = self
	row.show = spellId
	row:Show()

	if (spellSchool) then
		local schoolColor = Details.spells_school[spellSchool]
		if (schoolColor and schoolColor.decimals) then
			row.textura:SetStatusBarColor(schoolColor.decimals[1], schoolColor.decimals[2], schoolColor.decimals[3])
		else
			row.textura:SetStatusBarColor(1, 1, 1)
		end

	elseif (class) then
		local color = Details.class_colors[class]
		if (color) then
			row.textura:SetStatusBarColor(unpack(color))
		else
			row.textura:SetStatusBarColor(1, 1, 1)
		end
	else
		if (spellId == 98021) then --spirit linkl
			row.textura:SetStatusBarColor(1, 0.4, 0.4)
		else
			row.textura:SetStatusBarColor(1, 1, 1)
		end
	end

	if (detalhes and self.detalhes and self.detalhes == spellId and info.showing == index) then
		self:MontaDetalhes(row.show, row, info.instancia)
	end
end

--lock into a line after clicking on it
--[[exported]] function Details:FocusLock(row, spellId)
	if (not info.mostrando_mouse_over) then
		if (spellId == self.detalhes) then --tabela [1] = spellid = spellid que esta na caixa da direita
			if (not row.on_focus) then --se a barra n�o tiver no foco
				row.textura:SetStatusBarColor(129/255, 125/255, 69/255, 1)
				row.on_focus = true
				if (not info.mostrando) then
					info.mostrando = row
				end
			end
		else
			if (row.on_focus) then
				row.textura:SetStatusBarColor(1, 1, 1, 1) --volta a cor antiga
				row:SetAlpha(.9) --volta a alfa antiga
				row.on_focus = false
			end
		end
	end
end

local wipeSpellCache = function()
	table.wipe(Details222.PlayerBreakdown.DamageSpellsCache)
end

local addToSpellCache = function(unitGUID, spellName, spellTable)
	local unitSpellCache = Details222.PlayerBreakdown.DamageSpellsCache[unitGUID]
	if (not unitSpellCache) then
		unitSpellCache = {}
		Details222.PlayerBreakdown.DamageSpellsCache[unitGUID] = unitSpellCache
	end

	local spellCache = Details222.PlayerBreakdown.DamageSpellsCache[unitGUID][spellName]
	if (not spellCache) then
		spellCache = {}
		Details222.PlayerBreakdown.DamageSpellsCache[unitGUID][spellName] = spellCache
	end

	table.insert(spellCache, spellTable)
end

local getSpellDetails = function(unitGUID, spellName)
	local unitCachedSpells = Details222.PlayerBreakdown.DamageSpellsCache[unitGUID]
	local spellsTableForSpellName = unitCachedSpells and unitCachedSpells[spellName]

	if (spellsTableForSpellName) then --should always be valid
		if (#spellsTableForSpellName > 1) then
			local t = spellsTableForSpellName
			local spellId = t[1].id
			local newSpellTable = Details222.DamageSpells.CreateSpellTable(spellId)

			newSpellTable.n_min = 99999999
			newSpellTable.c_min = 99999999
			newSpellTable.n_max = 0
			newSpellTable.c_max = 0

			for i = 1, #t do
				for key, value in pairs(t[i]) do
					if (type(value) == "number") then
						if (key == "n_min" or key == "c_min") then
							if (value < newSpellTable[key]) then
								newSpellTable[key] = value
							end

						elseif (key == "n_max" or key == "c_max") then
							if (value > newSpellTable[key]) then
								newSpellTable[key] = value
							end

						elseif (key ~= "id" and key ~= "spellschool") then
							newSpellTable[key] = (newSpellTable[key] or 0) + value
						end
					end
				end
			end

			return newSpellTable
		else
			--there's only one table, so return the first
			return spellsTableForSpellName[1]
		end
	end
end

------ Damage Done & Dps
function atributo_damage:MontaInfoDamageDone()
	local actorObject = self

	local allLines = info.barras1
	local instance = info.instancia

	--damage rank
	local combatObject = instance:GetShowingCombat()
	local diff = combatObject:GetDifficulty()
	local attribute, subAttribute = instance:GetDisplay()

	--check if is a raid encounter and if is heroic or mythic
	if (diff and (diff == 15 or diff == 16)) then
		local db = Details.OpenStorage()
		if (db) then
			local bestRank, encounterTable = Details.storage:GetBestFromPlayer (diff, combatObject:GetBossInfo().id, "damage", self.nome, true)
			if (bestRank) then
				--discover which are the player position in the guild rank
				local playerTable, onEncounter, rankPosition = Details.storage:GetPlayerGuildRank (diff, combatObject:GetBossInfo().id, "damage", self.nome, true)
				local text1 = self.nome .. " Guild Rank on " .. (combatObject:GetBossInfo().name or "") .. ": |cFFFFFF00" .. (rankPosition or "x") .. "|r Best Dps: |cFFFFFF00" .. Details:ToK2((bestRank[1] or 0) / encounterTable.elapsed) .. "|r (" .. encounterTable.date:gsub(".*%s", "") .. ")"
				info:SetStatusbarText (text1, 10, "gray")
			else
				info:SetStatusbarText()
			end
		else
			info:SetStatusbarText()
		end
	else
		info:SetStatusbarText()
	end

	local totalDamageWithoutPet = actorObject.total_without_pet
	local actorTotalDamage = actorObject.total

	local actorSpellsSorted = {}
	local actorSpells = actorObject:GetSpellList()

	local bShouldMergePlayerAbilities = Details.merge_player_abilities
	local bShouldMergePetAbilities = Details.merge_pet_abilities

	wipeSpellCache()

	--get time type
	local actorCombatTime
	if (Details.time_type == 1 or not self.grupo) then
		actorCombatTime = self:Tempo()
	elseif (Details.time_type == 2) then
		actorCombatTime = info.instancia.showing:GetCombatTime()
	end

	for spellId, spellTable in pairs(actorSpells) do
		local spellName, _, spellIcon = _GetSpellInfo(spellId)
		if (spellName) then
			local spellTotal = spellTable.total
			local spellPercent = spellTable.total / actorTotalDamage * 100
			local nameString = spellName

			--problem: will show the first ability found when hovering over the spell
			if (bShouldMergePlayerAbilities) then
				local bAlreadyAdded = false
				for i = 1, #actorSpellsSorted do
					local thisSpell = actorSpellsSorted[i]
					if (thisSpell[4] == nameString) then
						bAlreadyAdded = true
						thisSpell[2] = thisSpell[2] + spellTotal
					end
				end

				if (not bAlreadyAdded) then
					tinsert(actorSpellsSorted, {spellId, spellTotal, spellPercent, nameString, spellIcon, nil, spellTable.spellschool})
				end

				addToSpellCache(actorObject:GetGUID(), spellName, spellTable)
			else
				tinsert(actorSpellsSorted, {spellId, spellTotal, spellPercent, nameString, spellIcon, nil, spellTable.spellschool})
			end
		end
	end

	--show damage percentille within item level bracket

	--add pets
	local actorPets = self.pets
	--local class_color = RAID_CLASS_COLORS [self.classe] and RAID_CLASS_COLORS [self.classe].colorStr
	local classColor = "FFCCBBBB"
	--local class_color = "FFDDDD44"

	for _, petName in ipairs(actorPets) do
		local petActor = combatObject(DETAILS_ATTRIBUTE_DAMAGE, petName)
		if (petActor) then
			local spells = petActor:GetSpellList()
			for spellId, spellTable in pairs(spells) do --da foreach em cada spellid do container
				local spellName, _, spellIcon = _GetSpellInfo(spellId)
				--tinsert(ActorSkillsSortTable, {_spellid, _skill.total, _skill.total/ActorTotalDamage*100, nome .. " |TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:0:128:128:33:64:96:128|t|c" .. class_color .. PetName:gsub((" <.*"), "") .. "|r", icone, PetActor, _skill.spellschool})
				if (spellName) then
					local spellTotal = spellTable.total
					local spellPercent = spellTable.total / actorTotalDamage * 100
					local nameString = spellName .. " (|c" .. classColor .. petName:gsub((" <.*"), "") .. "|r)"

					if (bShouldMergePetAbilities) then
						local bAlreadyAdded = false
						for i = 1, #actorSpellsSorted do
							local thisPetSpellTable = actorSpellsSorted[i]
							if (thisPetSpellTable[1] == spellId) then
								bAlreadyAdded = true
								thisPetSpellTable[2] = thisPetSpellTable[2] + spellTotal
							end
						end

						if (not bAlreadyAdded) then
							tinsert(actorSpellsSorted, {spellId, spellTotal, spellPercent, nameString, spellIcon, petActor, spellTable.spellschool})
						end

						addToSpellCache(actorObject:GetGUID(), spellName, spellTable) --all pet spells are added to later be combined and shown in the spell details
					else
						tinsert(actorSpellsSorted, {spellId, spellTotal, spellPercent, nameString, spellIcon, petActor, spellTable.spellschool})
					end
				end
			end
		end
	end

	_table_sort(actorSpellsSorted, Details.Sort2)

	gump:JI_AtualizaContainerBarras (#actorSpellsSorted + 1)

	local max_ = actorSpellsSorted[1] and actorSpellsSorted[1][2] or 0 --dano que a primeiro magia vez

	local barra

	--aura bar
	if (false) then --disabled for now
		barra = allLines [1]
		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instance, 1)
		end
		self:UpdadeInfoBar(barra, "", -51, "Auras", max_, false, max_, 100, [[Interface\BUTTONS\UI-GroupLoot-DE-Up]], true, nil, nil)
		barra.textura:SetStatusBarColor(Details.gump:ParseColors("purple"))
	end

	--spell bars
	for index, tabela in ipairs(actorSpellsSorted) do

		--index = index + 1 --with the aura bar
		index = index
		barra = allLines [index]
		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instance, index)
		end

		barra.other_actor = tabela [6]

		local name = tabela[4]

		if (info.sub_atributo == 2) then
			local formated_value = SelectedToKFunction(_, _math_floor(tabela[2]/actorCombatTime))
			self:UpdadeInfoBar(barra, index, tabela[1], name, tabela[2], formated_value, max_, tabela[3], tabela[5], true, nil, tabela [7])
		else
			local formated_value = SelectedToKFunction(_, _math_floor(tabela[2]))
			self:UpdadeInfoBar(barra, index, tabela[1], name, tabela[2], formated_value, max_, tabela[3], tabela[5], true, nil, tabela [7])
		end

		self:FocusLock(barra, tabela[1])
	end

	--targets
	if (instance.sub_atributo == DETAILS_SUBATTRIBUTE_ENEMIES) then
		local totalDamageTaken = self.damage_taken
		local damageTakenFrom = self.damage_from
		local combatObject = instance:GetShowingCombat()
		local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
		local barras = info.barras2
		local enemyTable = {}
		local targetName = self:Name()

		local enemyActorObject
		for enemyName in pairs(damageTakenFrom) do
			enemyActorObject = damageContainer:GetActor(enemyName)
			if (enemyActorObject) then
				local damageDoneToTarget = enemyActorObject.targets[targetName]
				if (damageDoneToTarget) then
					local npcId = DetailsFramework:GetNpcIdFromGuid(enemyActorObject:GetGUID())
					enemyTable[#enemyTable+1] = {enemyName, damageDoneToTarget, damageDoneToTarget / totalDamageTaken * 100, enemyActorObject:Class(), npcId}
				end
			end
		end

		local enemyAmount = #enemyTable

		if (enemyAmount < 1) then
			return true
		end

		gump:JI_AtualizaContainerAlvos(enemyAmount)

		table.sort(enemyTable, Details.Sort2)

		local topDamage = enemyTable[1] and enemyTable[1][2] or 0

		local thisLine
		for index, thisEnemyTable in ipairs(enemyTable) do
			thisLine = barras[index]

			if (not thisLine) then --se a barra n�o existir, criar ela ent�o
				thisLine = gump:CriaNovaBarraInfo2 (instance, index)
				thisLine.textura:SetStatusBarColor(1, 1, 1, 1) --isso aqui � a parte da sele��o e descele��o
			end

			if (index == 1) then
				thisLine.textura:SetValue(100)
			else
				thisLine.textura:SetValue(thisEnemyTable[2] / topDamage * 100)
			end

			thisLine.lineText1:SetText(index .. ". " .. Details:GetOnlyName(thisEnemyTable[1])) --left text
			thisLine.lineText4:SetText(Details:comma_value (thisEnemyTable[2]) .. " (" .. format("%.1f", thisEnemyTable[3]) .. "%)") --right text

			thisLine.icone:SetTexture([[Interface\AddOns\Details\images\classes_small_alpha]]) --class icon

			local texCoords = Details.class_coords[thisEnemyTable[4]]
			if (not texCoords) then
				texCoords = Details.class_coords["UNKNOW"]
			end
			thisLine.icone:SetTexCoord(unpack(texCoords))

			local color = Details.class_colors[thisEnemyTable[4]]
			if (color) then
				thisLine.textura:SetStatusBarColor(unpack(color))
			else
				thisLine.textura:SetStatusBarColor(1, 1, 1)
			end

			Details:name_space_info(thisLine)

			if (thisLine.mouse_over) then --atualizar o tooltip
				if (thisLine.isAlvo) then
					GameTooltip:Hide()
					GameTooltip:SetOwner(thisLine, "ANCHOR_TOPRIGHT")
					if (not thisLine.minha_tabela:MontaTooltipDamageTaken(thisLine, index)) then
						return
					end
					GameTooltip:Show()
				end
			end

			thisLine.minha_tabela = self --grava o jogador na tabela
			thisLine.nome_inimigo = thisEnemyTable[1] --salva o nome do inimigo na barra --isso � necess�rio?

			-- no rank do spell id colocar o que?
			thisLine.spellid = "enemies"

			thisLine:Show() --mostra a barra
		end
	else
		local combatObject = instance:GetShowingCombat()
		local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
		local allActorTargets = {}

		--table with actor names and damage done which the player caused damage to
		local targetsTable = self.targets
		for targetName, damageDone in pairs(targetsTable) do
			tinsert(allActorTargets, {targetName, damageDone, damageDone / totalDamageWithoutPet * 100})
		end

		table.sort(allActorTargets, Details.Sort2)

		local enemyAmount = #allActorTargets
		if (enemyAmount < 1) then
			return
		end

		gump:JI_AtualizaContainerAlvos(enemyAmount)

		local topDamage = allActorTargets[1] and allActorTargets[1][2] or 0

		local barra
		for index, targetTable in ipairs(allActorTargets) do
			barra = info.barras2[index]

			if (not barra) then
				barra = gump:CriaNovaBarraInfo2(instance, index)
				barra.textura:SetStatusBarColor(1, 1, 1, 1)
			end

			if (index == 1) then
				barra.textura:SetValue(100)
			else
				barra.textura:SetValue(targetTable[2] / topDamage * 100)
			end

			local targetName = targetTable[1]
			local targetActorObject = damageContainer:GetActor(targetName)

			if (targetActorObject) then
				local npcId = DetailsFramework:GetNpcIdFromGuid(targetActorObject:GetGUID())
				local portraitTexture = Details222.Textures.GetPortraitTextureForNpcID(npcId)
				if (portraitTexture) then
					Details222.Textures.FormatPortraitAsTexture(portraitTexture, barra.icone)
				else
					targetActorObject:SetClassIcon(barra.icone, instance, targetActorObject.classe)
				end
			else
				barra.icone:SetTexture([[Interface\AddOns\Details\images\classes_small_alpha]]) --CLASSE
				local texCoords = Details.class_coords ["ENEMY"]
				barra.icone:SetTexCoord(unpack(texCoords))
			end

			barra.textura:SetStatusBarColor(1, 0.8, 0.8)
			barra.textura:SetStatusBarColor(1, 1, 1, 1)

			barra.lineText1:SetText(index .. ". " .. Details:GetOnlyName(targetName))

			if (info.sub_atributo == 2) then
				barra.lineText4:SetText(Details:comma_value ( _math_floor(targetTable[2]/actorCombatTime)) .. " (" .. format("%.1f", targetTable[3]) .. "%)")
			else
				barra.lineText4:SetText(SelectedToKFunction(_, targetTable[2]) .." (" .. format("%.1f", targetTable[3]) .. "%)")
			end

			if (barra.mouse_over) then --atualizar o tooltip
				if (barra.isAlvo) then
					--GameTooltip:Hide()
					--GameTooltip:SetOwner(barra, "ANCHOR_TOPRIGHT")
					if (not barra.minha_tabela:MontaTooltipAlvos (barra, index, instance)) then
						return
					end
					--GameTooltip:Show()
				end
			end

			barra.minha_tabela = self --grava o jogador na tabela
			barra.nome_inimigo = targetTable [1] --salva o nome do inimigo na barra --isso � necess�rio?

			-- no rank do spell id colocar o que?
			barra.spellid = targetTable[5]
			barra:Show()
		end
	end
end


------ Detalhe Info Friendly Fire
function atributo_damage:MontaDetalhesFriendlyFire (nome, barra)

	for _, barra in ipairs(info.barras3) do
		barra:Hide()
	end

	local barras = info.barras3
	local instancia = info.instancia

	local tabela_do_combate = info.instancia.showing
	local showing = tabela_do_combate [class_type] --o que esta sendo mostrado -> [1] - dano [2] - cura --pega o container com ._NameIndexTable ._ActorTable

	local friendlyfire = self.friendlyfire

	local ff_table = self.friendlyfire [nome] --assumindo que nome � o nome do Alvo que tomou dano // bastaria pegar a tabela de habilidades dele
	if (not ff_table) then
		return
	end
	local total = ff_table.total

	local minhas_magias = {}

	for spellid, amount in pairs(ff_table.spells) do --da foreach em cada spellid do container
		local nome, _, icone = _GetSpellInfo(spellid)
		tinsert(minhas_magias, {spellid, amount, amount / total * 100, nome, icone})
	end

	_table_sort(minhas_magias, Details.Sort2)

	local max_ = minhas_magias[1] and minhas_magias[1][2] or 0 --dano que a primeiro magia vez

	local barra
	for index, tabela in ipairs(minhas_magias) do
		barra = barras [index]

		if (not barra) then --se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo3 (instancia, index)
			barra.textura:SetStatusBarColor(1, 1, 1, 1) --isso aqui � a parte da sele��o e descele��o
		end

		if (index == 1) then
			barra.textura:SetValue(100)
		else
			barra.textura:SetValue(tabela[2]/max_*100) --muito mais rapido...
		end

		barra.lineText1:SetText(index..instancia.divisores.colocacao..tabela[4]) --seta o texto da esqueda
		barra.lineText4:SetText(Details:comma_value (tabela[2]) .. " " .. instancia.divisores.abre .. format("%.1f", tabela[3]) .. "%" .. instancia.divisores.fecha) --seta o texto da direita

		barra.icone:SetTexture(tabela[5])
		barra.icone:SetTexCoord(0, 1, 0, 1)

		barra:Show() --mostra a barra

		if (index == 15) then
			break
		end
	end

end

-- detalhes info enemies
function atributo_damage:MontaDetalhesEnemy (spellid, barra)

	for _, barra in ipairs(info.barras3) do
		barra:Hide()
	end

	local container = info.instancia.showing[1]
	local barras = info.barras3
	local instancia = info.instancia

	local other_actor = barra.other_actor
	if (other_actor) then
		self = other_actor
	end

	if (barra.lineText1:IsTruncated()) then
		Details:CooltipPreset(2)
		GameCooltip:SetOption("FixedWidth", nil)
		GameCooltip:AddLine(barra.lineText1.text)
		GameCooltip:SetOwner(barra, "bottomleft", "topleft", 5, -10)
		GameCooltip:ShowCooltip()
	end

	local spell = self.spells:PegaHabilidade (spellid)

	local targets = spell.targets
	local target_pool = {}

	for target_name, amount in pairs(targets) do
		local classe
		local this_actor = info.instancia.showing (1, target_name)
		if (this_actor) then
			classe = this_actor.classe or "UNKNOW"
		else
			classe = "UNKNOW"
		end

		target_pool [#target_pool+1] = {target_name, amount, classe}
	end

	_table_sort(target_pool, Details.Sort2)

	local max_ = target_pool [1] and target_pool [1][2] or 0

	local barra
	for index, tabela in ipairs(target_pool) do
		barra = barras [index]

		if (not barra) then --se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo3 (instancia, index)
			barra.textura:SetStatusBarColor(1, 1, 1, 1) --isso aqui � a parte da sele��o e descele��o
		end

		if (index == 1) then
			barra.textura:SetValue(100)
		else
			barra.textura:SetValue(tabela[2]/max_*100) --muito mais rapido...
		end

		barra.lineText1:SetText(index .. ". " .. Details:GetOnlyName(tabela [1])) --seta o texto da esqueda
		Details:name_space_info (barra)

		if (spell.total > 0) then
			barra.lineText4:SetText(Details:comma_value (tabela[2]) .." (".. format("%.1f", tabela[2] / spell.total * 100) .."%)") --seta o texto da direita
		else
			barra.lineText4:SetText(tabela[2] .." (0%)") --seta o texto da direita
		end

		local texCoords = Details.class_coords [tabela[3]]
		if (not texCoords) then
			texCoords = Details.class_coords ["UNKNOW"]
		end

		local color = Details.class_colors [tabela[3]]
		if (color) then
			barra.textura:SetStatusBarColor(unpack(color))
		else
			barra.textura:SetStatusBarColor(1, 1, 1, 1)
		end

		barra.icone:SetTexture("Interface\\AddOns\\Details\\images\\classes_small_alpha")
		barra.icone:SetTexCoord(unpack(texCoords))

		barra:Show() --mostra a barra

		if (index == 15) then
			break
		end
	end

end

------ Detalhe Info Damage Taken
function atributo_damage:MontaDetalhesDamageTaken (nome, barra)

	for _, barra in ipairs(info.barras3) do
		barra:Hide()
	end

	local barras = info.barras3
	local instancia = info.instancia

	local tabela_do_combate = info.instancia.showing
	local showing = tabela_do_combate [class_type] --o que esta sendo mostrado -> [1] - dano [2] - cura --pega o container com ._NameIndexTable ._ActorTable

	local este_agressor = showing._ActorTable[showing._NameIndexTable[nome]]

	if (not este_agressor ) then
		return
	end

	local conteudo = este_agressor.spells._ActorTable --pairs[] com os IDs das magias

	local actor = info.jogador.nome

	local total = este_agressor.targets [actor] or 0

	local minhas_magias = {}

	for spellid, tabela in pairs(conteudo) do --da foreach em cada spellid do container
		local este_alvo = tabela.targets [actor]
		if (este_alvo) then --esta magia deu dano no actor
			local spell_nome, rank, icone = _GetSpellInfo(spellid)
			tinsert(minhas_magias, {spellid, este_alvo, este_alvo/total*100, spell_nome, icone})
		end
	end

	_table_sort(minhas_magias, Details.Sort2)

	--local amt = #minhas_magias
	--gump:JI_AtualizaContainerBarras (amt)

	local max_ = minhas_magias[1] and minhas_magias[1][2] or 0 --dano que a primeiro magia vez

	local barra
	for index, tabela in ipairs(minhas_magias) do
		barra = barras [index]

		if (not barra) then --se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo3 (instancia, index)
			barra.textura:SetStatusBarColor(1, 1, 1, 1) --isso aqui � a parte da sele��o e descele��o
		end

		if (index == 1) then
			barra.textura:SetValue(100)
		else
			barra.textura:SetValue(tabela[2]/max_*100)
		end

		barra.lineText1:SetText(index .. "." .. tabela[4]) --seta o texto da esqueda
		Details:name_space_info (barra)

		barra.lineText4:SetText(Details:comma_value (tabela[2]) .." ".. instancia.divisores.abre ..format("%.1f", tabela[3]) .."%".. instancia.divisores.fecha) --seta o texto da direita

		barra.icone:SetTexture(tabela[5])
		barra.icone:SetTexCoord(0, 1, 0, 1)

		barra:Show() --mostra a barra

		if (index == 15) then
			break
		end
	end

end

------ Detalhe Info Damage Done e Dps
--local defenses_table = {c = {117/255, 58/255, 0/255}, p = 0}
--local normal_table = {c = {255/255, 180/255, 0/255, 0.5}, p = 0}
--local critical_table = {c = {249/255, 74/255, 45/255, 0.5}, p = 0}

local defenses_table = {c = {1, 1, 1, 0.5}, p = 0}
local normal_table = {c = {1, 1, 1, 0.5}, p = 0}
local critical_table = {c = {1, 1, 1, 0.5}, p = 0}

local data_table = {}
local t1, t2, t3, t4 = {}, {}, {}, {}

local function FormatSpellString(str)
	return (string.gsub(str, "%d+", function(spellID)
				local name, _, icon = GetSpellInfo(spellID);
				return string.format("|T%s:16|t", icon);
			end));
end


local MontaDetalhesBuffProcs = function(actor, row, instance)

	instance = instance or info.instancia

	local spec = actor.spec
	if (spec) then
		local mainAuras = Details.important_auras [spec]
		if (mainAuras) then
			local miscActor = instance:GetShowingCombat():GetActor(4, actor:name())
			if (miscActor and miscActor.buff_uptime_spells) then
				--get the auras
				local added = 0
				for i = 1, #mainAuras do
					local spellID = mainAuras [i]
					local spellObject = miscActor.buff_uptime_spells._ActorTable [spellID]
					if (spellObject) then
						local spellName, spellIcon = GetSpellInfo(spellID)
						local spellUptime = spellObject.uptime
						local spellApplies = spellObject.appliedamt
						local spellRefreshes = spellObject.refreshamt

						gump:SetaDetalheInfoTexto(i, 100, FormatSpellString ("" .. spellID .. " " .. spellName), "Activations: " .. spellApplies, " ", "Refreshes: " .. spellRefreshes, " ", "Uptime: " .. spellUptime .. "s")
						added = added + 1
					end
				end

				for i = added + 1, 5 do
					gump:HidaDetalheInfo (i)
				end

				return
			end
		end
	end

	for i = 1, 5 do
		gump:HidaDetalheInfo (i)
	end
end



function atributo_damage:MontaDetalhesDamageDone (spellId, spellLine, instance)
	local spellTable
	if (spellLine.other_actor) then
		spellTable = spellLine.other_actor.spells._ActorTable [spellId]
		--self = spellLine.other_actor
	else
		spellTable = self.spells._ActorTable [spellId]
	end

	if (spellId == -51) then
		return MontaDetalhesBuffProcs(self, spellLine, instance)
	end

	if (not spellTable) then
		return
	end

	local spellName, _, icone = _GetSpellInfo(spellId)

	local bShouldMergePlayerAbilities = Details.merge_player_abilities
	local bShouldMergePetAbilities = Details.merge_pet_abilities

	if (bShouldMergePlayerAbilities or bShouldMergePetAbilities) then
		local mergedSpellTable = getSpellDetails(self:GetGUID(), spellName) --it's not merging
		if (mergedSpellTable) then
			spellTable = mergedSpellTable
		end
	end

	Details.playerDetailWindow.spell_icone:SetTexture(icone)

	local total = self.total

	local meu_tempo
	if (Details.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()

	elseif (Details.time_type == 2) then
		meu_tempo = info.instancia.showing:GetCombatTime()
	end

	local total_hits = spellTable.counter

	local index = 1
	local data = data_table

	table.wipe(t1)
	table.wipe(t2)
	table.wipe(t3)
	table.wipe(t4)
	table.wipe(data)

	--GERAL
		local media = 0
		if (total_hits > 0) then
			media = spellTable.total/total_hits
		end

		local this_dps = nil
		if (spellTable.counter > spellTable.c_amt) then
			this_dps = Loc ["STRING_DPS"] .. ": " .. Details:comma_value (spellTable.total/meu_tempo)
		else
			this_dps = Loc ["STRING_DPS"] .. ": " .. Loc ["STRING_SEE_BELOW"]
		end

		local spellschool, schooltext = spellTable.spellschool, ""
		if (spellschool) then
			local t = Details.spells_school [spellschool]
			if (t and t.name) then
				schooltext = t.formated
			end
		end

		local hits_string = "" .. total_hits
		local cast_string = Loc ["STRING_CAST"] .. ": "

		local misc_actor = info.instancia.showing (4, self:name())
		if (misc_actor) then

			local uptime_spellid = spellTable.id
			--if (uptime_spellid == 233490) then
			--	uptime_spellid = 233496
			--	uptime_spellid = 233490
			--end

			local debuff_uptime = misc_actor.debuff_uptime_spells and misc_actor.debuff_uptime_spells._ActorTable [uptime_spellid] and misc_actor.debuff_uptime_spells._ActorTable [uptime_spellid].uptime
			if (debuff_uptime) then
				hits_string = hits_string .. "  |cFFDDDD44(" .. _math_floor(debuff_uptime / info.instancia.showing:GetCombatTime() * 100) .. "% uptime)|r"
			end

			local spell_cast = misc_actor.spell_cast and misc_actor.spell_cast [spellId]

			if (not spell_cast and misc_actor.spell_cast) then
				local spellname = GetSpellInfo(spellId)
				for casted_spellid, amount in pairs(misc_actor.spell_cast) do
					local casted_spellname = GetSpellInfo(casted_spellid)
					if (casted_spellname == spellname) then
						spell_cast = amount .. " (|cFFFFFF00?|r)"
					end
				end
			end
			if (not spell_cast) then
				spell_cast = "(|cFFFFFF00?|r)"
			end
			cast_string = cast_string .. spell_cast
		end

		if (spellTable.e_total) then
			cast_string = Loc ["STRING_CAST"] .. ": " .. "|cFFFFFF00" .. spellTable.e_total .. "|r"
		end

		gump:SetaDetalheInfoTexto( index, 100,
			cast_string,
			Loc ["STRING_DAMAGE"]..": "..Details:ToK(spellTable.total),
			schooltext, --offhand,
			Loc ["STRING_AVERAGE"] .. ": " .. Details:comma_value (media),
			this_dps,
			Loc ["STRING_HITS"]..": " .. hits_string
		)

	--NORMAL
		local normal_hits = spellTable.n_amt
		if (normal_hits > 0) then
			local normal_dmg = spellTable.n_dmg
			local media_normal = normal_dmg/normal_hits
			local T = (meu_tempo*normal_dmg)/ max(spellTable.total, 0.001)
			local P = media/media_normal*100
			T = P*T/100

			normal_table.p = normal_hits/total_hits*100

			data[#data+1] = t1

			t1[1] = spellTable.n_amt
			t1[2] = normal_table
			t1[3] = Loc ["STRING_NORMAL_HITS"]
			t1[4] = Loc ["STRING_MINIMUM_SHORT"] .. ": " .. Details:comma_value (spellTable.n_min)
			t1[5] = Loc ["STRING_MAXIMUM_SHORT"] .. ": " .. Details:comma_value (spellTable.n_max)
			t1[6] = Loc ["STRING_AVERAGE"] .. ": " .. Details:comma_value (media_normal)
			t1[7] = Loc ["STRING_DPS"] .. ": " .. Details:comma_value (normal_dmg/T)
			t1[8] = normal_hits .. " [|cFFC0C0C0" .. format("%.1f", normal_hits/max(total_hits, 0.0001)*100) .. "%|r]"
			t1[9] = ""
		end

	--CRITICO
		if (spellTable.c_amt > 0) then
			local media_critico = spellTable.c_dmg/spellTable.c_amt
			local T = (meu_tempo*spellTable.c_dmg)/spellTable.total
			local P = media/max(media_critico, 0.0001)*100
			T = P*T/100
			local crit_dps = spellTable.c_dmg/T
			if (not crit_dps) then
				crit_dps = 0
			end

			critical_table.p = spellTable.c_amt/total_hits*100

			data[#data+1] = t2

			t2[1] = spellTable.c_amt
			t2[2] = critical_table
			t2[3] = Loc ["STRING_CRITICAL_HITS"]
			t2[4] = Loc ["STRING_MINIMUM_SHORT"] .. ": " .. Details:comma_value (spellTable.c_min)
			t2[5] = Loc ["STRING_MAXIMUM_SHORT"] .. ": " .. Details:comma_value (spellTable.c_max)
			t2[6] = Loc ["STRING_AVERAGE"] .. ": " .. Details:comma_value (media_critico)
			t2[7] = Loc ["STRING_DPS"] .. ": " .. Details:comma_value (crit_dps)
			t2[8] = spellTable.c_amt .. " [|cFFC0C0C0" .. format("%.1f", spellTable.c_amt/total_hits*100) .. "%|r]"
			t2[9] = ""
		end

	--Outros erros: GLACING, resisted, blocked, absorbed
		local outros_desvios = spellTable.g_amt + spellTable.b_amt
		local parry = spellTable ["PARRY"] or 0
		local dodge = spellTable ["DODGE"] or 0
		local misses = spellTable ["MISS"] or 0

		local erros = parry + dodge + misses

		if (outros_desvios > 0 or erros > 0) then
			local porcentagem_defesas = (outros_desvios + erros) / total_hits * 100

			data[#data+1] = t3
			defenses_table.p = porcentagem_defesas

			t3[1] = outros_desvios+erros
			t3[2] = defenses_table
			t3[3] = Loc ["STRING_DEFENSES"]
			t3[4] = Loc ["STRING_GLANCING"] .. ": " .. _math_floor(spellTable.g_amt/spellTable.counter*100) .. "%"
			t3[5] = Loc ["STRING_PARRY"] .. ": " .. parry
			t3[6] = Loc ["STRING_DODGE"] .. ": " .. dodge
			t3[7] = Loc ["STRING_BLOCKED"] .. ": " .. _math_floor(spellTable.b_amt/spellTable.counter*100)
			t3[8] = (outros_desvios+erros) .. " / " .. format("%.1f", porcentagem_defesas) .. "%"
			t3[9] = "MISS" .. ": " .. misses
		end

	--~empowered
	if (spellTable.e_total) then
		local empowerLevelSum = spellTable.e_total --total sum of empower levels
		local empowerAmount = spellTable.e_amt --amount of casts with empower
		local empowerAmountPerLevel = spellTable.e_lvl --{[1] = 4; [2] = 9; [3] = 15}
		local empowerDamagePerLevel = spellTable.e_dmg --{[1] = 54548745, [2] = 74548745}

		data[#data+1] = t4

		local level1AverageDamage = "0"
		local level2AverageDamage = "0"
		local level3AverageDamage = "0"
		local level4AverageDamage = "0"
		local level5AverageDamage = "0"

		if (empowerDamagePerLevel[1]) then
			level1AverageDamage = Details:ToK(empowerDamagePerLevel[1] / empowerAmountPerLevel[1])
		end
		if (empowerDamagePerLevel[2]) then
			level2AverageDamage = Details:ToK(empowerDamagePerLevel[2] / empowerAmountPerLevel[2])
		end
		if (empowerDamagePerLevel[3]) then
			level3AverageDamage = Details:ToK(empowerDamagePerLevel[3] / empowerAmountPerLevel[3])
		end
		if (empowerDamagePerLevel[4]) then
			level4AverageDamage = Details:ToK(empowerDamagePerLevel[4] / empowerAmountPerLevel[4])
		end
		if (empowerDamagePerLevel[5]) then
			level5AverageDamage = Details:ToK(empowerDamagePerLevel[5] / empowerAmountPerLevel[5])
		end

		t4[1] = 0
		t4[2] = {p = 100, c = {0.200, 0.576, 0.498, 0.6}}
		t4[3] = "Spell Empower Average Level: " .. format("%.2f", empowerLevelSum / empowerAmount)
		t4[4] = ""
		t4[5] = ""
		t4[6] = ""
		t4[10] = ""
		t4[11] = ""

		if (level1AverageDamage ~= "0") then
			t4[4] = "Level 1 Avg: " .. level1AverageDamage .. " (" .. (empowerAmountPerLevel[1] or 0) .. ")"
		end

		if (level2AverageDamage ~= "0") then
			t4[6] = "Level 2 Avg: " .. level2AverageDamage .. " (" .. (empowerAmountPerLevel[2] or 0) .. ")"
		end

		if (level3AverageDamage ~= "0") then
			t4[11] = "Level 3 Avg: " .. level3AverageDamage .. " (" .. (empowerAmountPerLevel[3] or 0) .. ")"
		end

		if (level4AverageDamage ~= "0") then
			t4[10] = "Level 4 Avg: " .. level4AverageDamage .. " (" .. (empowerAmountPerLevel[4] or 0) .. ")"
		end

		if (level5AverageDamage ~= "0") then
			t4[5] = "Level 5 Avg: " .. level5AverageDamage .. " (" .. (empowerAmountPerLevel[5] or 0) .. ")"
		end
	end

	--Details:BuildPlayerDetailsSpellChart()
	--DetailsPlayerDetailSmallChart.ShowChart (Details.playerDetailWindow.grupos_detalhes [5].bg, info.instancia.showing, info.instancia.showing.cleu_events, self.nome, false, spellid, 1, 2, 3, 4, 5, 6, 7, 8, 15)

	--spell damage chart
	--events: 1 2 3 4 5 6 7 8 15
	local spellTable = spellTable

	local blockId = 6
	local thatRectangle66 = Details222.BreakdownWindow.GetBlockIndex(blockId)
	thatRectangle66 = thatRectangle66:GetFrame()

	--hide all textures created
	if (thatRectangle66.ChartTextures) then
		for i = 1, #thatRectangle66.ChartTextures do
			thatRectangle66.ChartTextures[i]:Hide()
		end
	end

	local chartData = Details222.TimeCapture.GetChartDataFromSpell(spellTable)
	if (chartData and instance) then
		local width, height = thatRectangle66:GetSize()
		--reset which texture is the next to be used
		thatRectangle66.nextChartTextureId = 1

		local amountOfTimeStamps = 12

		if (not thatRectangle66.timeStamps) then
			thatRectangle66.timeStamps = {}
			for i = 1, amountOfTimeStamps do
				thatRectangle66.timeStamps[i] = thatRectangle66:CreateFontString(nil, "overlay", "GameFontNormal")
				thatRectangle66.timeStamps[i]:SetPoint("topleft", thatRectangle66, "topleft", 2 + (i - 1) * (width / amountOfTimeStamps), -2)
				DetailsFramework:SetFontSize(thatRectangle66.timeStamps[i], 9)
			end
		end

		if (not thatRectangle66.bloodLustIndicators) then
			thatRectangle66.bloodLustIndicators = {}
			for i = 1, 5 do
				local thisIndicator = thatRectangle66:CreateTexture(nil, "artwork", nil, 4)
				thisIndicator:SetColorTexture(0.0980392, 0.0980392, 0.439216)
				thatRectangle66.bloodLustIndicators[#thatRectangle66.bloodLustIndicators+1] = thisIndicator
			end
		end

		for i = 1, #thatRectangle66.bloodLustIndicators do
			thatRectangle66.bloodLustIndicators[i]:Hide()
		end

		if (not thatRectangle66.ChartTextures) then
			thatRectangle66.ChartTextures = {}
			function thatRectangle66:GetChartTexture()
				local thisTexture = thatRectangle66.ChartTextures[thatRectangle66.nextChartTextureId]
				if (not thisTexture) then
					thisTexture = thatRectangle66:CreateTexture(nil, "artwork", nil, 5)
					thisTexture:SetColorTexture(1, 1, 1, 0.65)
					thatRectangle66.ChartTextures[thatRectangle66.nextChartTextureId] = thisTexture
				end
				thatRectangle66.nextChartTextureId = thatRectangle66.nextChartTextureId + 1

				return thisTexture
			end
		end

		--elapsed combat time
		local combatObject = instance:GetShowingCombat()
		local combatTime = math.floor(combatObject:GetCombatTime())
		thatRectangle66.timeStamps[1]:SetText(DetailsFramework:IntegerToTimer(0))
		for i = 2, #thatRectangle66.timeStamps do
			local timePerSegment = combatTime / #thatRectangle66.timeStamps
			thatRectangle66.timeStamps[i]:SetText(DetailsFramework:IntegerToTimer(i * timePerSegment))
		end
		--compute the width oif each texture
		local textureWidth = width / combatTime
		--compute the max height of a texture can have
		local maxValue = 0
		local numData = 0

		--need to put the data in order FIRST
		--each damage then need to be parsed

		local dataInOrder = {}

		local CONST_INDEX_TIMESTAMP = 1
		local CONST_INDEX_DAMAGEDONE = 2
		local CONST_INDEX_EVENTDAMAGE = 3

		for timeStamp, value in pairs(chartData) do
			dataInOrder[#dataInOrder+1] = {timeStamp, value}
			dataInOrder[#dataInOrder+1] = {timeStamp, value}
			dataInOrder[#dataInOrder+1] = {timeStamp, value}
			numData = numData + 1
		end

		table.sort(dataInOrder, function(t1, t2)  return t1[CONST_INDEX_TIMESTAMP] < t2[CONST_INDEX_TIMESTAMP] end)
		local damageDoneByTime = dataInOrder

		--parser the damage done
		local currentTotalDamage = 0

		for i = 1, #damageDoneByTime do
			local damageEvent = damageDoneByTime[i]

			local atTime = damageEvent[CONST_INDEX_TIMESTAMP]
			local totalDamageUntilHere = damageEvent[CONST_INDEX_DAMAGEDONE] --raw damage

			local spellDamage = totalDamageUntilHere - currentTotalDamage
			currentTotalDamage = currentTotalDamage + spellDamage

			damageEvent[CONST_INDEX_EVENTDAMAGE] = spellDamage

			maxValue = math.max(spellDamage, maxValue)
		end

		--build the chart
		for i = 1, #damageDoneByTime do
		--for timeStamp, value in pairs(chartData) do --as it is pairs the data is scattered
			local damageEvent = damageDoneByTime[i]
			local timeStamp = damageEvent[CONST_INDEX_TIMESTAMP]
			local damageDone = damageEvent[CONST_INDEX_EVENTDAMAGE]

			local thisTexture = thatRectangle66:GetChartTexture()
			thisTexture:SetWidth(textureWidth)

			local texturePosition = textureWidth * timeStamp

			thisTexture:SetPoint("bottomleft", thatRectangle66, "bottomleft", 1 + texturePosition, 1)

			local percentFromPeak = damageDone / maxValue --normalized
			thisTexture:SetHeight(math.min(percentFromPeak * height, height - 15))
			thisTexture:Show()

			--print("DEBUG", 7 , "Peak:", percentFromPeak, "position:", texturePosition, "damage done:", damageDone) --debug
		end

		--show bloodlust indicators, member .bloodlust is not guarantted
		if (combatObject.bloodlust) then
			--bloodlust not being added into the combat object, probably a bug on Parser
			local bloodlustDuration = 40
			for i = 1, #combatObject.bloodlust do
				thatRectangle66.bloodLustIndicators[i]:Show()
				thatRectangle66.bloodLustIndicators[i]:SetAlpha(0.46)
				thatRectangle66.bloodLustIndicators[i]:SetSize(bloodlustDuration / combatTime * width, height - 2)
				thatRectangle66.bloodLustIndicators[i]:SetPoint("bottomleft", thatRectangle66, "bottomleft", 0, 0)
			end
		end

		DetailsPlayerDetailsWindow_DetalheInfoBG_bg_end6:Hide()
		thatRectangle66:SetShown(true)
	end

	_table_sort(data, Details.Sort1)

	for index, tabela in ipairs(data) do
		gump:SetaDetalheInfoTexto(index+1, tabela[2], tabela[3], tabela[4], tabela[5], tabela[6], tabela[7], tabela[8], tabela[9], tabela[10], tabela[11], tabela[12])
	end

	for i = #data+2, 5 do
		gump:HidaDetalheInfo (i)
	end

end

function Details:BuildPlayerDetailsSpellChart()
	local playerDetailSmallChart = DetailsPlayerDetailSmallChart

	if (not playerDetailSmallChart) then

		playerDetailSmallChart = CreateFrame("frame", "DetailsPlayerDetailSmallChart", info,"BackdropTemplate")
		DetailsFramework:ApplyStandardBackdrop(playerDetailSmallChart)
		playerDetailSmallChart.Lines = {}

		for i = 1, 200 do
			local texture = playerDetailSmallChart:CreateTexture(nil, "artwork")
			texture:SetColorTexture(1, 1, 1, 1)
			tinsert(playerDetailSmallChart.Lines, texture)
		end

		--Details.playerDetailWindow.grupos_detalhes [index]
		function playerDetailSmallChart.ShowChart (parent, combatObject, cleuData, playerName, targetName, spellId, ...)
			local tokenIdList = {}
			local eventList = {}

			--build the list of tokens
			for i = 1, select("#", ... ) do
				local tokenId = select(i, ...)
				tokenIdList [tokenId] = true
			end

			--check which lines can be added
			local index = 1
			local peakValue = 0

			for i = 1, cleuData.n -1 do
				local event = cleuData [i]
				if (event [2]) then --index 2 = token
					local playerNameFilter = playerName and playerName == event [3]
					local targetNameFilter = targetName and targetName == event [4]
					local spellIdFilter = spellId and spellId == event [5]

					if (playerNameFilter or targetNameFilter or spellIdFilter) then
						eventList [index] = cleuData [i]
						if (peakValue < cleuData [i] [6]) then
							peakValue = cleuData [i] [6]
						end
						index = index + 1
					end
				end
			end

			--200 lines, adjust the mini chart
			playerDetailSmallChart:SetPoint("topleft", parent, "topleft")
			playerDetailSmallChart:SetPoint("bottomright", parent, "bottomright")

			--update lines
			local width = playerDetailSmallChart:GetWidth()
			local combatTime = combatObject:GetCombatTime()
			local secondsPerBar = combatTime / 200
			local barWidth = width / 200
			local barHeight = playerDetailSmallChart:GetHeight()

			local currentTime = eventList [1][1]
			local currentIndex = 1
			local eventAmount = #eventList

			for i = 1, #playerDetailSmallChart.Lines do
				playerDetailSmallChart.Lines [i]:SetWidth(width / 200)
				playerDetailSmallChart.Lines [i]:SetHeight(1)

				for o = currentIndex, eventAmount do
					if (eventList [o][1] <= currentTime + secondsPerBar or eventList [o][1] >= currentTime) then
						playerDetailSmallChart.Lines [i]:SetPoint("bottomleft", playerDetailSmallChart, "bottomleft", barWidth  * (i - 1), 0)
						playerDetailSmallChart.Lines [i]:SetWidth(barWidth)
						playerDetailSmallChart.Lines [i]:SetHeight(eventList [o][6] / peakValue * barHeight)
					else
						currentIndex = o
						break
					end
				end

				currentTime = currentTime + secondsPerBar
			end
		end
	end
end

function atributo_damage:MontaTooltipDamageTaken (thisLine, index)

	local aggressor = info.instancia.showing [1]:PegarCombatente (_, thisLine.nome_inimigo)
	local container = aggressor.spells._ActorTable
	local habilidades = {}

	local total = 0

	for spellid, spell in pairs(container) do
		for target_name, amount in pairs(spell.targets) do
			if (target_name == self.nome) then
				total = total + amount
				habilidades [#habilidades+1] = {spellid, amount}
			end
		end
	end

	_table_sort(habilidades, Details.Sort2)

	GameTooltip:AddLine(index..". "..thisLine.nome_inimigo)
	GameTooltip:AddLine(Loc ["STRING_DAMAGE_TAKEN_FROM2"]..":")
	GameTooltip:AddLine(" ")

	for index, tabela in ipairs(habilidades) do
		local nome, _, icone = _GetSpellInfo(tabela[1])
		if (index < 8) then
			GameTooltip:AddDoubleLine (index..". |T"..icone..":0|t "..nome, Details:comma_value (tabela[2]).." ("..format("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine (index..". "..nome, Details:comma_value (tabela[2]).." ("..format("%.1f", tabela[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
		end
	end

	return true
	--GameTooltip:AddDoubleLine (meus_danos[i][4][1]..": ", meus_danos[i][2].." (".._cstr("%.1f", meus_danos[i][3]).."%)", 1, 1, 1, 1, 1, 1)

end

function atributo_damage:MontaTooltipAlvos (thisLine, index, instancia)

	local inimigo = thisLine.nome_inimigo
	local habilidades = {}
	local total = self.total
	local i = 1

	Details:FormatCooltipForSpells()
	GameCooltip:SetOwner(thisLine, "bottom", "top", 4, -2)
	GameCooltip:SetOption("MinWidth", _math_max (230, thisLine:GetWidth()*0.98))

	for spellid, spell in pairs(self.spells._ActorTable) do
		if (spell.isReflection) then
			for target_name, amount in pairs(spell.targets) do
				if (target_name == inimigo) then
					for reflectedSpellId, amount in pairs(spell.extra) do
						local spellName, _, spellIcon = _GetSpellInfo(reflectedSpellId)
						local t = habilidades [i]
						if (not t) then
							habilidades [i] = {}
							t = habilidades [i]
						end

						t[1], t[2], t[3] = spellName .. " (|cFFCCBBBBreflected|r)", amount, spellIcon
						i = i + 1
					end
				end
			end
		else
			for target_name, amount in pairs(spell.targets) do
				if (target_name == inimigo) then
					local nome, _, icone = _GetSpellInfo(spellid)

					local t = habilidades [i]
					if (not t) then
						habilidades [i] = {}
						t = habilidades [i]
					end

					t[1], t[2], t[3] = nome, amount, icone
					i = i + 1
				end
			end
		end
	end

	--add pets
	for _, PetName in ipairs(self.pets) do
		local PetActor = instancia.showing (class_type, PetName)
		if (PetActor) then
			local PetSkillsContainer = PetActor.spells._ActorTable
			for _spellid, _skill in pairs(PetSkillsContainer) do

				local alvos = _skill.targets
				for target_name, amount in pairs(alvos) do
					if (target_name == inimigo) then

						local t = habilidades [i]
						if (not t) then
							habilidades [i] = {}
							t = habilidades [i]
						end

						local nome, _, icone = _GetSpellInfo(_spellid)
						t[1], t[2], t[3] = nome .. " (" .. PetName:gsub((" <.*"), "") .. ")", amount, icone

						i = i + 1
					end
				end
			end
		end
	end

	_table_sort(habilidades, Details.Sort2)

	--get time type
	local meu_tempo
	if (Details.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()
	elseif (Details.time_type == 2) then
		meu_tempo = info.instancia.showing:GetCombatTime()
	end

	local is_dps = info.instancia.sub_atributo == 2

	if (is_dps) then
		Details:AddTooltipSpellHeaderText (Loc ["STRING_DAMAGE_DPS_IN"] .. ":", {1, 0.9, 0.0, 1}, 1, Details.tooltip_spell_icon.file, unpack(Details.tooltip_spell_icon.coords))
		Details:AddTooltipHeaderStatusbar (1, 1, 1, 1)

	else
		Details:AddTooltipSpellHeaderText (Loc ["STRING_DAMAGE_FROM"] .. ":", {1, 0.9, 0.0, 1}, 1, Details.tooltip_spell_icon.file, unpack(Details.tooltip_spell_icon.coords))
		Details:AddTooltipHeaderStatusbar (1, 1, 1, 1)
	end

	local icon_size = Details.tooltip.icon_size
	local icon_border = Details.tooltip.icon_border_texcoord

	local topSpellDamage = habilidades[1] and habilidades[1][2]

	if (topSpellDamage) then
		for index, tabela in ipairs(habilidades) do
			if (tabela [2] < 1) then
				break
			end

			if (is_dps) then
				--GameCooltip:AddDoubleLine (index..". |T"..tabela[3]..":0|t "..tabela[1], Details:comma_value ( _math_floor(tabela[2] / meu_tempo) ).." (".._cstr("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
				GameCooltip:AddLine(tabela[1], Details:comma_value ( _math_floor(tabela[2] / meu_tempo) ).." ("..format("%.1f", tabela[2]/total*100).."%)")
			else
				--GameCooltip:AddDoubleLine (index..". |T"..tabela[3]..":0|t " .. tabela[1], SelectedToKFunction(_, tabela[2]) .. " (".._cstr("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
				GameCooltip:AddLine(tabela[1], SelectedToKFunction(_, tabela[2]) .. " ("..format("%.1f", tabela[2]/total*100).."%)")
			end

			GameCooltip:AddIcon (tabela[3], nil, nil, icon_size.W + 4, icon_size.H + 4, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			Details:AddTooltipBackgroundStatusbar (false, tabela[2] / topSpellDamage * 100)
		end
	end

	GameCooltip:Show()

	return true

end

--controla se o dps do jogador esta travado ou destravado
function atributo_damage:Iniciar (iniciar)
	if (iniciar == nil) then
		return self.dps_started --retorna se o dps esta aberto ou fechado para este jogador
	elseif (iniciar) then
		self.dps_started = true
		self:RegistrarNaTimeMachine() --coloca ele da timeMachine
	else
		self.dps_started = false
		self:DesregistrarNaTimeMachine() --retira ele da timeMachine
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--core functions

	--limpa as tabelas tempor�rias ao resetar
		function atributo_damage:ClearTempTables()
			for i = #ntable, 1, -1 do
				ntable [i] = nil
			end
			for i = #vtable, 1, -1 do
				vtable [i] = nil
			end
			for i = #bs_table, 1, -1 do
				bs_table [i] = nil
			end

			if (bs_tooltip_table) then
				wipe (bs_tooltip_table)
			end
			if (frags_tooltip_table) then
				wipe (frags_tooltip_table)
			end
			wipe (bs_index_table)
			wipe (tooltip_temp_table)
			wipe (tooltip_void_zone_temp)
		end

	--atualize a funcao de abreviacao
		function atributo_damage:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions [Details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions [Details.tooltip.abbreviation]
			TooltipMaximizedMethod = Details.tooltip.maximize_method
			headerColor = Details.tooltip.header_text_color
		end

	--diminui o total das tabelas do combate
		function atributo_damage:subtract_total (combat_table)
			combat_table.totals [class_type] = combat_table.totals [class_type] - self.total
			if (self.grupo) then
				combat_table.totals_grupo [class_type] = combat_table.totals_grupo [class_type] - self.total
			end
		end
		function atributo_damage:add_total (combat_table)
			combat_table.totals [class_type] = combat_table.totals [class_type] + self.total
			if (self.grupo) then
				combat_table.totals_grupo [class_type] = combat_table.totals_grupo [class_type] + self.total
			end
		end

	--restaura a tabela de last event
		function atributo_damage:r_last_events_table (actor)
			if (not actor) then
				actor = self
			end
			--actor.last_events_table = Details:CreateActorLastEventTable()
		end

	--restaura e liga o ator com a sua shadow durante a inicializa��o (startup function)
		function atributo_damage:r_onlyrefresh_shadow (actor)
			--criar uma shadow desse ator se ainda n�o tiver uma
				local overall_dano = Details.tabela_overall [1]
				local shadow = overall_dano._ActorTable [overall_dano._NameIndexTable [actor.nome]]

				if (not shadow) then
					shadow = overall_dano:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)

					shadow.classe = actor.classe
					shadow:SetSpecId(actor.spec)
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.isTank = actor.isTank
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component

					shadow.start_time = time() - 3
					shadow.end_time = time()
				end

			--restaura a meta e indexes ao ator
			Details.refresh:r_atributo_damage (actor, shadow)

			--copia o container de alvos (captura de dados)
				for target_name, amount in pairs(actor.targets) do
					--cria e soma o valor do total
					if (not shadow.targets [target_name]) then
						shadow.targets [target_name] = 0
					end
				end

			--copia o container de habilidades (captura de dados)
				for spellid, habilidade in pairs(actor.spells._ActorTable) do
					--cria e soma o valor
					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, nil, true)

					--create the target value
					for target_name, amount in pairs(habilidade.targets) do
						if (not habilidade_shadow.targets [target_name]) then
							habilidade_shadow.targets [target_name] = 0
						end
					end

					--create the extra value
					for spellId, amount in pairs(habilidade.extra) do
						if (not habilidade_shadow.extra [spellId]) then
							habilidade_shadow.extra [spellId] = 0
						end
					end

				end

			--copia o container de friendly fire (captura de dados)
				for target_name, ff_table in pairs(actor.friendlyfire) do
					--cria ou pega a shadow
					local friendlyFire_shadow = shadow.friendlyfire [target_name] or shadow:CreateFFTable (target_name)
					--some as spells
					for spellid, amount in pairs(ff_table.spells) do
						friendlyFire_shadow.spells [spellid] = 0
					end
				end

			return shadow
		end

		function atributo_damage:r_connect_shadow (actor, no_refresh, combat_object)

			--check if there's a custom combat, if not just use the overall container
			local host_combat = combat_object or Details.tabela_overall

			--check if the host combat object has a shadow actor for this actor, if not, just create one new
				local overall_dano = host_combat [1]
				local shadow = overall_dano._ActorTable [overall_dano._NameIndexTable [actor.nome]]

				if (not shadow) then
					shadow = overall_dano:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)

					shadow.classe = actor.classe
					shadow:SetSpecId(actor.spec)
					shadow.isTank = actor.isTank
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component

					shadow.start_time = time() - 3
					shadow.end_time = time()
				end

			shadow.displayName = actor.displayName or actor.nome

			shadow.boss_fight_component = actor.boss_fight_component or shadow.boss_fight_component
			shadow.fight_component = actor.fight_component or shadow.fight_component
			shadow.grupo = actor.grupo or shadow.grupo

			--check if need to restore meta tables and indexes for this actor
			if (not no_refresh) then
				Details.refresh:r_atributo_damage (actor, shadow)
			end

			--tempo decorrido (captura de dados)
				local end_time = actor.end_time
				if (not actor.end_time) then
					end_time = time()
				end

				local tempo = end_time - actor.start_time
				shadow.start_time = shadow.start_time - tempo

			--pets (add unique pet names)
				for _, petName in ipairs(actor.pets) do
					local hasPet = false
					for i = 1, #shadow.pets do
						if (shadow.pets[i] == petName) then
							hasPet = true
							break
						end
					end

					if (not hasPet) then
						shadow.pets [#shadow.pets+1] = petName
					end
				end

			--total de dano (captura de dados)
				shadow.total = shadow.total + actor.total
				shadow.totalabsorbed = shadow.totalabsorbed + actor.totalabsorbed
			--total de dano sem o pet (captura de dados)
				shadow.total_without_pet = shadow.total_without_pet + actor.total_without_pet
			--total de dano que o ator sofreu (captura de dados)
				shadow.damage_taken = shadow.damage_taken + actor.damage_taken
			--total do friendly fire causado
				shadow.friendlyfire_total = shadow.friendlyfire_total + actor.friendlyfire_total

			--total no combate overall (captura de dados)
				host_combat.totals[1] = host_combat.totals[1] + actor.total
				if (actor.grupo) then
					host_combat.totals_grupo[1] = host_combat.totals_grupo[1] + actor.total
				end

			--copia o damage_from (captura de dados)
				for nome, _ in pairs(actor.damage_from) do
					shadow.damage_from [nome] = true
				end

			--copia o container de alvos (captura de dados)
				for target_name, amount in pairs(actor.targets) do
					shadow.targets [target_name] = (shadow.targets [target_name] or 0) + amount
				end

			--copiar o container de raid targets
				for flag, amount in pairs(actor.raid_targets) do
					shadow.raid_targets = shadow.raid_targets or {} --deu invalido noutro dia
					shadow.raid_targets [flag] = (shadow.raid_targets [flag] or 0) + amount
				end

			--copia o container de habilidades (captura de dados)
				for spellid, habilidade in pairs(actor.spells._ActorTable) do
					--cria e soma o valor
					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, nil, true)

					--refresh e soma os valores dos alvos
					for target_name, amount in pairs(habilidade.targets) do
						habilidade_shadow.targets [target_name] = (habilidade_shadow.targets [target_name] or 0) + amount
					end

					--refresh and add extra values
					for spellId, amount in pairs(habilidade.extra) do
						habilidade_shadow.extra [spellId] = (habilidade_shadow.extra [spellId] or 0) + amount
					end

					--soma todos os demais valores
					for key, value in pairs(habilidade) do
						if (type(value) == "number") then
							if (key ~= "id" and key ~= "spellschool") then
								if (not habilidade_shadow [key]) then
									habilidade_shadow [key] = 0
								end

								if (key == "n_min" or key == "c_min") then
									if (habilidade_shadow [key] > value) then
										habilidade_shadow [key] = value
									end
								elseif (key == "n_max" or key == "c_max") then
									if (habilidade_shadow [key] < value) then
										habilidade_shadow [key] = value
									end
								else
									habilidade_shadow [key] = habilidade_shadow [key] + value
								end

							end
						end
					end
				end

			--copia o container de friendly fire (captura de dados)
				for target_name, ff_table in pairs(actor.friendlyfire) do
					--cria ou pega a shadow
					local friendlyFire_shadow = shadow.friendlyfire [target_name] or shadow:CreateFFTable (target_name)
					--soma o total
					friendlyFire_shadow.total = friendlyFire_shadow.total + ff_table.total
					--some as spells
					for spellid, amount in pairs(ff_table.spells) do
						friendlyFire_shadow.spells [spellid] = (friendlyFire_shadow.spells [spellid] or 0) + amount
					end
				end

			return shadow
		end

function atributo_damage:ColetarLixo (lastevent)
	return Details:ColetarLixo (class_type, lastevent)
end


--actor 1 is who will receive the sum from actor2
function Details.SumDamageActors(actor1, actor2, actorContainer)
	--general
	actor1.total = actor1.total + actor2.total
	actor1.damage_taken = actor1.damage_taken + actor2.damage_taken
	actor1.totalabsorbed = actor1.totalabsorbed + actor2.totalabsorbed
	actor1.total_without_pet = actor1.total_without_pet + actor2.total_without_pet
	actor1.friendlyfire_total = actor1.friendlyfire_total + actor2.friendlyfire_total

	--damage taken from
	for actorName in pairs(actor2.damage_from) do
		actor1.damage_from[actorName] = true

		--add the damage done to actor2 into the damage done to target1
		if (actorContainer) then
			--get the actor that caused the damage on actor2
			local actorObject = actorContainer:GetActor(actorName)
			if (actorObject) then
				local damageToActor2 = (actorObject.targets[actor2.nome]) or 0
				actorObject.targets[actor1.nome] = (actorObject.targets[actor1.nome] or 0) + damageToActor2
			end
		end
	end

	--targets
	for actorName, damageDone in pairs(actor2.targets) do
		actor1.targets[actorName] = (actor1.targets[actorName] or 0) + damageDone
	end

	--pets
	for i = 1, #actor2.pets do
		DetailsFramework.table.addunique(actor1.pets, actor2.pets[i])
	end

	--raid targets
	for raidTargetFlag, damageDone in pairs(actor2.raid_targets) do
		actor1.raid_targets[raidTargetFlag] = (actor1.raid_targets[raidTargetFlag] or 0) + damageDone
	end

	--friendly fire
	for actorName, ffTable in pairs(actor2.friendlyfire) do
		actor1.friendlyfire[actorName] = actor1.friendlyfire[actorName] or actor1:CreateFFTable(actorName)
		actor1.friendlyfire[actorName].total = actor1.friendlyfire[actorName].total + ffTable.total

		for spellId, damageDone in pairs(ffTable.spells) do
			actor1.friendlyfire[actorName].spells[spellId] = (actor1.friendlyfire[actorName].spells[spellId] or 0) + damageDone
		end
	end

	--spells
	local ignoredKeys = {
		id = true,
		spellschool =  true,
	}

	local actor1Spells = actor1.spells
	for spellId, spellTable in pairs(actor2.spells._ActorTable) do

		local actor1Spell = actor1Spells:GetOrCreateSpell(spellId, true, "DAMAGE_DONE")

		--genetal spell attributes
		for key, value in pairs(spellTable) do
			if (type(value) == "number") then
				if (not ignoredKeys[key]) then
					if (key == "n_min" or key == "c_min") then
						if (actor1Spell[key] > value) then
							actor1Spell[key] = value
						end
					elseif (key == "n_max" or key == "c_max") then
						if (actor1Spell[key] < value) then
							actor1Spell[key] = value
						end
					else
						actor1Spell[key] = actor1Spell[key] + value
					end
				end
			end
		end

		--spell targets
		for targetName, damageDone in pairs(spellTable) do
			actor1Spell.targets[targetName] = (actor1Spell.targets[targetName] or 0) + damageDone
		end
	end
end


atributo_damage.__add = function(tabela1, tabela2)

	--tempo decorrido
		local tempo = (tabela2.end_time or time()) - tabela2.start_time
		tabela1.start_time = tabela1.start_time - tempo

	--total de dano
		tabela1.total = tabela1.total + tabela2.total
		tabela1.totalabsorbed = tabela1.totalabsorbed + tabela2.totalabsorbed
	--total de dano sem o pet
		tabela1.total_without_pet = tabela1.total_without_pet + tabela2.total_without_pet
	--total de dano que o cara levou
		tabela1.damage_taken = tabela1.damage_taken + tabela2.damage_taken
	--total do friendly fire causado
		tabela1.friendlyfire_total = tabela1.friendlyfire_total + tabela2.friendlyfire_total

	--soma o damage_from
		for nome, _ in pairs(tabela2.damage_from) do
			tabela1.damage_from [nome] = true
		end

		--pets (add unique pet names)
		for _, petName in ipairs(tabela2.pets) do
			local hasPet = false
			for i = 1, #tabela1.pets do
				if (tabela1.pets[i] == petName) then
					hasPet = true
					break
				end
			end

			if (not hasPet) then
				tabela1.pets [#tabela1.pets+1] = petName
			end
		end

	--soma os containers de alvos
		for target_name, amount in pairs(tabela2.targets) do
			tabela1.targets [target_name] = (tabela1.targets [target_name] or 0) + amount
		end

	--soma o container de raid targets
		for flag, amount in pairs(tabela2.raid_targets) do
			tabela1.raid_targets [flag] = (tabela1.raid_targets [flag] or 0) + amount
		end

	--soma o container de habilidades
		for spellid, habilidade in pairs(tabela2.spells._ActorTable) do
			--pega a habilidade no primeiro ator
			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_DAMAGE", false)

			--soma os alvos
			for target_name, amount in pairs(habilidade.targets) do
				habilidade_tabela1.targets[target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end

			--soma os extras
			for spellId, amount in pairs(habilidade.extra) do
				habilidade_tabela1.extra = (habilidade_tabela1.extra [spellId] or 0) + amount
			end

			--soma os valores da habilidade
			for key, value in pairs(habilidade) do
				if (type(value) == "number") then
					if (key ~= "id" and key ~= "spellschool") then
						if (not habilidade_tabela1 [key]) then
							habilidade_tabela1 [key] = 0
						end

						if (key == "n_min" or key == "c_min") then
							if (habilidade_tabela1 [key] > value) then
								habilidade_tabela1 [key] = value
							end
						elseif (key == "n_max" or key == "c_max") then
							if (habilidade_tabela1 [key] < value) then
								habilidade_tabela1 [key] = value
							end
						else
							habilidade_tabela1 [key] = habilidade_tabela1 [key] + value
						end

					end
				end
			end
		end

	--soma o container de friendly fire
		for target_name, ff_table in pairs(tabela2.friendlyfire) do
			--pega o ator ff no ator principal
			local friendlyFire_tabela1 = tabela1.friendlyfire [target_name] or tabela1:CreateFFTable (target_name)
			--soma o total
			friendlyFire_tabela1.total = friendlyFire_tabela1.total + ff_table.total

			--soma as habilidades
			for spellid, amount in pairs(ff_table.spells) do
				friendlyFire_tabela1.spells [spellid] = (friendlyFire_tabela1.spells [spellid] or 0) + amount
			end
		end

	return tabela1
end

atributo_damage.__sub = function(tabela1, tabela2)

	--tempo decorrido
		local tempo = (tabela2.end_time or time()) - tabela2.start_time
		tabela1.start_time = tabela1.start_time + tempo

	--total de dano
		tabela1.total = tabela1.total - tabela2.total
		tabela1.totalabsorbed = tabela1.totalabsorbed - tabela2.totalabsorbed

	--total de dano sem o pet
		tabela1.total_without_pet = tabela1.total_without_pet - tabela2.total_without_pet
	--total de dano que o cara levou
		tabela1.damage_taken = tabela1.damage_taken - tabela2.damage_taken
	--total do friendly fire causado
		tabela1.friendlyfire_total = tabela1.friendlyfire_total - tabela2.friendlyfire_total

	--reduz os containers de alvos
		for target_name, amount in pairs(tabela2.targets) do
			local alvo_tabela1 = tabela1.targets [target_name]
			if (alvo_tabela1) then
				tabela1.targets [target_name] = tabela1.targets [target_name] - amount
			end
		end

	--reduz o container de raid targets
		for flag, amount in pairs(tabela2.raid_targets) do
			if (tabela1.raid_targets [flag]) then
				tabela1.raid_targets [flag] = _math_max (tabela1.raid_targets [flag] - amount, 0)
			end
		end

	--reduz o container de habilidades
		for spellid, habilidade in pairs(tabela2.spells._ActorTable) do
			--get the spell from the first actor
			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_DAMAGE", false)

			--subtract targets
			for target_name, amount in pairs(habilidade.targets) do
				local alvo_tabela1 = habilidade_tabela1.targets [target_name]
				if (alvo_tabela1) then
					habilidade_tabela1.targets [target_name] = habilidade_tabela1.targets [target_name] - amount
				end
			end

			--subtract extra table
			for spellId, amount in pairs(habilidade.extra) do
				local extra_tabela1 = habilidade_tabela1.extra [spellId]
				if (extra_tabela1) then
					habilidade_tabela1.extra [spellId] = habilidade_tabela1.extra [spellId] - amount
				end
			end

			--subtrai os valores da habilidade
			for key, value in pairs(habilidade) do
				if (type(value) == "number") then
					if (key ~= "id" and key ~= "spellschool") then
						if (not habilidade_tabela1 [key]) then
							habilidade_tabela1 [key] = 0
						end
						if (key == "n_min" or key == "c_min") then
							if (habilidade_tabela1 [key] > value) then
								habilidade_tabela1 [key] = value
							end
						elseif (key == "n_max" or key == "c_max") then
							if (habilidade_tabela1 [key] < value) then
								habilidade_tabela1 [key] = value
							end
						else
							habilidade_tabela1 [key] = habilidade_tabela1 [key] - value
						end
					end
				end
			end
		end

	--reduz o container de friendly fire
		for target_name, ff_table in pairs(tabela2.friendlyfire) do
			--pega o ator ff no ator principal
			local friendlyFire_tabela1 = tabela1.friendlyfire [target_name]
			if (friendlyFire_tabela1) then
				friendlyFire_tabela1.total = friendlyFire_tabela1.total - ff_table.total
				for spellid, amount in pairs(ff_table.spells) do
					if (friendlyFire_tabela1.spells [spellid]) then
						friendlyFire_tabela1.spells [spellid] = friendlyFire_tabela1.spells [spellid] - amount
					end
				end
			end
		end

	return tabela1
end

function Details.refresh:r_atributo_damage (este_jogador, shadow)
	--restaura metas do ator
		setmetatable(este_jogador, Details.atributo_damage)
		este_jogador.__index = Details.atributo_damage
	--restaura as metas dos containers
		Details.refresh:r_container_habilidades (este_jogador.spells, shadow and shadow.spells)
end

function Details.clear:c_atributo_damage (este_jogador)
	este_jogador.__index = nil
	este_jogador.shadow = nil
	este_jogador.links = nil
	este_jogador.minha_barra = nil

	Details.clear:c_container_habilidades (este_jogador.spells)
end


--[[
	--enemy damage done
	i = 1
	local enemy = combat (1, enemy_name)
	if (enemy) then

		local damage_done = 0

		--get targets
		for target_name, amount in pairs(enemy.targets) do
			local player = combat (1, target_name)
			if (player and player.grupo) then
				local t = tooltip_temp_table [i]
				if (not t) then
					tooltip_temp_table [i] = {}
					t = tooltip_temp_table [i]
				end
				t [1] = player
				t [2] = amount
				damage_done = damage_done + amount
				i = i + 1
			end
		end

		--first clenup
		for o = i, #tooltip_temp_table do
			local t = tooltip_temp_table [o]
			t[2] = 0
			t[1] = 0
		end

		_table_sort(tooltip_temp_table, Details.Sort2)

		--enemy damage taken
		Details:AddTooltipSpellHeaderText (Loc ["STRING_ATTRIBUTE_DAMAGE"], headerColor, i-1, true)
		GameCooltip:AddIcon ([=[Interface\Buttons\UI-MicroStream-Green]=], 2, 1, 14, 14, 0.1875, 0.8125, 0.15625, 0.78125)
		GameCooltip:AddIcon ([=[Interface\AddOns\Details\images\key_shift]=], 2, 2, Details.tooltip_key_size_width, Details.tooltip_key_size_height, 0, 1, 0, 0.640625, Details.tooltip_key_overlay2)
		GameCooltip:AddStatusBar (100, 2, 0.7, g, b, 1)

		--build the tooltip
		for o = 1, i-1 do

			local player = tooltip_temp_table [o][1]
			local total = tooltip_temp_table [o][2]
			local player_name = player:name()

			if (player_name:find(Details.playername)) then
				GameCooltip:AddLine(player_name .. ": ", FormatTooltipNumber (_, total) .. " (" .. _cstr ("%.1f", (total / damage_done) * 100) .. "%)", 2, "yellow")
			else
				GameCooltip:AddLine(player_name .. ": ", FormatTooltipNumber (_, total) .." (" .. _cstr ("%.1f", (total / damage_done) * 100) .. "%)", 2)
			end

			local classe = player:class()
			if (not classe) then
				classe = "UNKNOW"
			end
			if (classe == "UNKNOW") then
				GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", 2, nil, 14, 14, .25, .5, 0, 1)
			else
				GameCooltip:AddIcon (instancia.row_info.icon_file, 2, nil, 14, 14, _unpack(Details.class_coords [classe]))
			end
			Details:AddTooltipBackgroundStatusbar (2)

		end

	end

	--clean up
	for o = 1, #tooltip_temp_table do
		local t = tooltip_temp_table [o]
		t[2] = 0
		t[1] = 0
	end
--]]

--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _table_sort = table.sort
local _table_insert = table.insert
local _table_size = table.getn
local _setmetatable = setmetatable
local _getmetatable = getmetatable
local _ipairs = ipairs
local _pairs = pairs
local _rawget= rawget
local _math_min = math.min
local _math_max = math.max
local _math_abs = math.abs
local _bit_band = bit.band
local _unpack = unpack
local _type = type
--api locals
local _GetSpellInfo = _detalhes.getspellinfo
local GameTooltip = GameTooltip
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup
local _GetNumGroupMembers = GetNumGroupMembers
local _GetNumSubgroupMembers = GetNumSubgroupMembers
local _UnitAura = UnitAura
local _UnitGUID = UnitGUID
local _UnitName = UnitName

local _string_replace = _detalhes.string.replace --details api

local _detalhes = 		_G._detalhes
local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ( "Details" )

local gump = 			_detalhes.gump
local _
local alvo_da_habilidade = 	_detalhes.alvo_da_habilidade
local container_habilidades = 	_detalhes.container_habilidades
local container_combatentes = _detalhes.container_combatentes
local container_pets =		_detalhes.container_pets
local atributo_misc =		_detalhes.atributo_misc
local habilidade_misc = 	_detalhes.habilidade_misc

local container_damage_target = _detalhes.container_type.CONTAINER_DAMAGETARGET_CLASS
local container_playernpc = _detalhes.container_type.CONTAINER_PLAYERNPC
local container_misc = _detalhes.container_type.CONTAINER_MISC_CLASS
local container_misc_target = _detalhes.container_type.CONTAINER_ENERGYTARGET_CLASS
--local container_friendlyfire = _detalhes.container_type.CONTAINER_FRIENDLYFIRE

--local modo_ALONE = _detalhes.modos.alone
local modo_GROUP = _detalhes.modos.group
local modo_ALL = _detalhes.modos.all

local class_type = _detalhes.atributos.misc

local DATA_TYPE_START = _detalhes._detalhes_props.DATA_TYPE_START
local DATA_TYPE_END = _detalhes._detalhes_props.DATA_TYPE_END

local div_abre = _detalhes.divisores.abre
local div_fecha = _detalhes.divisores.fecha
local div_lugar = _detalhes.divisores.colocacao

local ToKFunctions = _detalhes.ToKFunctions
local SelectedToKFunction = ToKFunctions [1]
local UsingCustomLeftText = false
local UsingCustomRightText = false

local FormatTooltipNumber = ToKFunctions [8]
local TooltipMaximizedMethod = 1

local info = _detalhes.janela_info
local keyName

local headerColor = "yellow"

function _detalhes.SortIfHaveKey (table1, table2)
	if (table1[keyName] and table2[keyName]) then
		return table1[keyName] > table2[keyName] 
	elseif (table1[keyName] and not table2[keyName]) then
		return true
	else
		return false
	end
end

function _detalhes.SortGroupIfHaveKey (table1, table2)
	if (table1.grupo and table2.grupo) then
		if (table1[keyName] and table2[keyName]) then
			return table1[keyName] > table2[keyName] 
		elseif (table1[keyName] and not table2[keyName]) then
			return true
		else
			return false
		end
	elseif (table1.grupo and not table2.grupo) then
		return true
	elseif (not table1.grupo and table2.grupo) then
		return false
	else
		if (table1[keyName] and table2[keyName]) then
			return table1[keyName] > table2[keyName] 
		elseif (table1[keyName] and not table2[keyName]) then
			return true
		else
			return false
		end
	end
end

function _detalhes.SortGroupMisc (container, keyName2)
	keyName = keyName2
	return _table_sort (container, _detalhes.SortKeyGroupMisc)
end

function _detalhes.SortKeyGroupMisc (table1, table2)
	if (table1.grupo and table2.grupo) then
		return table1 [keyName] > table2 [keyName]
	elseif (table1.grupo and not table2.grupo) then
		return true
	elseif (not table1.grupo and table2.grupo) then
		return false
	else
		return table1 [keyName] > table2 [keyName]
	end
end

function _detalhes.SortKeySimpleMisc (table1, table2)
	return table1 [keyName] > table2 [keyName]
end

function _detalhes:ContainerSortMisc (container, amount, keyName2)
	keyName = keyName2
	_table_sort (container,  _detalhes.SortKeySimpleMisc)
	
	if (amount) then 
		for i = amount, 1, -1 do --> de tr�s pra frente
			if (container[i][keyName] < 1) then
				amount = amount-1
			else
				break
			end
		end
		
		return amount
	end
end

--[[exported]] function _detalhes:GetSpellCastAmount (combat, actorName, spellId)
	local misc_actor = combat:GetActor (4, actorName)
	if (misc_actor) then
		local spell_cast = misc_actor.spell_cast and misc_actor.spell_cast [spellId]
		
		--try to find a spell with the same name and get the amount of casts of that spell object
		if (not spell_cast and misc_actor.spell_cast) then
			local spellname = GetSpellInfo (spellId)
			for casted_spellid, amount in _pairs (misc_actor.spell_cast) do
				local casted_spellname = GetSpellInfo (casted_spellid)
				if (casted_spellname == spellname) then
					return amount, true
				end
			end
		end
		
		if (not spell_cast) then
			return false
		end
		
		return spell_cast
	end
end

function atributo_misc:NovaTabela (serial, nome, link)

	local _new_miscActor = {
		last_event = 0,
		tipo = class_type, --> atributo 4 = misc
		pets = {} --> pets? okey pets
	}
	_setmetatable (_new_miscActor, atributo_misc)
	
	return _new_miscActor
end

function atributo_misc:CreateBuffTargetObject()
	return {
		uptime = 0,
		actived = false,
		activedamt = 0,
		refreshamt = 0,
		appliedamt = 0,
	}
end

local backgroundColor = {0, 0, 0, 1}
local backgroud_bar_damage = {value = 100, texture = [[Interface\AddOns\Details\images\bar_serenity]], color = {1, 0, 0, 0.1}}
--local backgroud_bar_heal = {value = 100, texture = [[Interface\AddOns\Details\images\bar_background]], color = {0, 0, 0, 1}}

function _detalhes:ToolTipDead (instancia, morte, esta_barra, keydown)
	
	local eventos = morte [1]
	local hora_da_morte = morte [2]
	local hp_max = morte [5]
	
	local battleress = false
	local lastcooldown = false
	
	local GameCooltip = GameCooltip
	
	GameCooltip:Reset()
	GameCooltip:SetType ("tooltipbar")
	
	GameCooltip:AddLine (Loc ["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack (self.click_to_report_color))
	GameCooltip:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
	GameCooltip:AddStatusBar (0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
	
	--death parser
	for index, event in _ipairs (eventos) do 
	
		local hp = _math_floor (event[5]/hp_max*100)
		if (hp > 100) then 
			hp = 100
		end
		
		local evtype = event [1]
		local spellname, _, spellicon = _GetSpellInfo (event [2])
		local amount = event [3]
		local time = event [4]
		local source = event [6]

		if (time + 12 > hora_da_morte) then
			if (type (evtype) == "boolean") then
				--> is damage or heal
				if (evtype) then
					--> damage
					
					local overkill = event [10] or 0
					if (overkill > 0) then
						--check the type of overkill that should be shown
						--if show_totalhitdamage_on_overkill is true it'll show the total damage of the hit
						--if false it shows the total damage of the hit minus the overkill
						if (not _detalhes.show_totalhitdamage_on_overkill) then
							amount = amount - overkill
						end
						
						overkill = " (" .. _detalhes:ToK (overkill) .. " |cFFFF8800overkill|r)"
						GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s |cFFFFFF00" .. spellname .. "|r (|cFFC6B0D9" .. source .. "|r)", "-" .. _detalhes:ToK (amount) .. overkill .. " (" .. hp .. "%)", 1, "white", "white")
					else
						overkill = ""
						GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (|cFFC6B0D9" .. source .. "|r)", "-" .. _detalhes:ToK (amount) .. overkill .. " (" .. hp .. "%)", 1, "white", "white")
					end
					
					GameCooltip:AddIcon (spellicon)
					
					if (event [9]) then
						--> friendly fire
						GameCooltip:AddStatusBar (hp, 1, "darkorange", true, backgroud_bar_damage)
					else
						--> from a enemy
						GameCooltip:AddStatusBar (hp, 1, "red", true, backgroud_bar_damage)
					end
				else
					--> heal
					if (amount > _detalhes.deathlog_healingdone_min) then
						GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (|cFFC6B0D9" .. source .. "|r)", "+" .. _detalhes:ToK (amount) .. " (" .. hp .. "%)", 1, "white", "white")
						GameCooltip:AddIcon (spellicon)
						GameCooltip:AddStatusBar (hp, 1, "green", true) --, backgroud_bar_heal
					end
				end
				
			elseif (type (evtype) == "number") then
				if (evtype == 1) then
					--> cooldown
					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (" .. source .. ")", "cooldown (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon)
					GameCooltip:AddStatusBar (100, 1, "yellow", true)
					
				elseif (evtype == 2 and not battleress) then
					--> battle ress
					battleress = event
					
				elseif (evtype == 3) then
					--> last cooldown used
					lastcooldown = event
				
				elseif (evtype == 4) then
					--> debuff
					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s [x" .. amount .. "] " .. spellname .. " (" .. source .. ")", "debuff (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon)
					GameCooltip:AddStatusBar (100, 1, "purple", true)
				
				end
			end
		end
	end

	GameCooltip:AddLine (morte [6] .. " " .. Loc ["STRING_TIME_OF_DEATH"] , "-- -- -- ", 1, "white")
	GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\small_icons", 1, 1, nil, nil, .75, 1, 0, 1)
	GameCooltip:AddStatusBar (0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar4_vidro]]})
	
	if (battleress) then
		local nome_magia, _, icone_magia = _GetSpellInfo (battleress [2])
		GameCooltip:AddLine ("+" .. _cstr ("%.1f", battleress[4] - hora_da_morte) .. "s " .. nome_magia .. " (" .. battleress[6] .. ")", "", 1, "white")
		GameCooltip:AddIcon ("Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons", 1, 1, nil, nil, .75, 1, 0, 1)
		GameCooltip:AddStatusBar (0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar4_vidro]]})
	end
	
	if (lastcooldown) then
		if (lastcooldown[3] == 1) then 
			local nome_magia, _, icone_magia = _GetSpellInfo (lastcooldown [2])
			GameCooltip:AddLine (_cstr ("%.1f", lastcooldown[4] - hora_da_morte) .. "s " .. nome_magia .. " (" .. Loc ["STRING_LAST_COOLDOWN"] .. ")")
			GameCooltip:AddIcon (icone_magia)
		else
			GameCooltip:AddLine (Loc ["STRING_NOLAST_COOLDOWN"])
			GameCooltip:AddIcon ([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]], 1, 1, 18, 18)
		end
			GameCooltip:AddStatusBar (0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
	end

	GameCooltip:SetOption ("StatusBarHeightMod", -6)
	GameCooltip:SetOption ("FixedWidth", (type (_detalhes.death_tooltip_width) == "number" and _detalhes.death_tooltip_width) or 300)

	GameCooltip:SetOption ("TextSize", _detalhes.tooltip.fontsize)
	GameCooltip:SetOption ("TextFont",  _detalhes.tooltip.fontface)
	
	GameCooltip:SetOption ("LeftBorderSize", -4)
	GameCooltip:SetOption ("RightBorderSize", 5)
	GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\bar4_reverse]])
	GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\BantoBar]])
	GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0.64453125, 0}, {.8, .8, .8, 0.2}, true)
	
	GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
	
	local myPoint = _detalhes.tooltip.anchor_point
	local anchorPoint = _detalhes.tooltip.anchor_relative
	local x_Offset = _detalhes.tooltip.anchor_offset[1]
	local y_Offset = _detalhes.tooltip.anchor_offset[2]
	
	if (_detalhes.tooltip.anchored_to == 1) then
		GameCooltip:SetHost (esta_barra, myPoint, anchorPoint, x_Offset, y_Offset)
	else
		GameCooltip:SetHost (DetailsTooltipAnchor, myPoint, anchorPoint, x_Offset, y_Offset)
	end
	
	GameCooltip:ShowCooltip()
	
end

local function RefreshBarraMorte (morte, barra, instancia)
	atributo_misc:DeadAtualizarBarra (morte, morte.minha_barra, barra.colocacao, instancia)
end

--objeto death:
--[1] tabela [2] time [3] nome [4] classe [5] maxhealth [6] time of death
--[1] true damage/ false heal [2] spellid [3] amount [4] time [5] current health [6] source

local report_table = {}
local ReportSingleDeathFunc = function (IsCurrent, IsReverse, AmtLines)

	AmtLines = AmtLines + 1

	local t = {}
	for i = 1, _math_min (#report_table, AmtLines) do
		local table = report_table [i]
		t [#t+1] = table [1] .. table [4] .. table [2] .. table [3]
	end
	
	local title = tremove (t, 1)
	t = _detalhes.table.reverse (t)
	tinsert (t, 1, title)
	
	_detalhes:SendReportLines (t)
	
end

function atributo_misc:ReportSingleDeadLine (morte, instancia)

	local barra = instancia.barras [morte.minha_barra]
	
	local max_health = morte [5]
	local time_of_death = morte [2]
	
	do
		if (not _detalhes.fontstring_len) then
			_detalhes.fontstring_len = _detalhes.listener:CreateFontString (nil, "background", "GameFontNormal")
		end
		local _, fontSize = FCF_GetChatWindowInfo (1)
		if (fontSize < 1) then
			fontSize = 10
		end
		local fonte, _, flags = _detalhes.fontstring_len:GetFont()
		_detalhes.fontstring_len:SetFont (fonte, fontSize, flags)
		_detalhes.fontstring_len:SetText ("thisisspacement")
	end
	local default_len = _detalhes.fontstring_len:GetStringWidth()
	
	wipe (report_table)
	local report_array = report_table
	report_array[1] = {"Details! " .. Loc ["STRING_REPORT_SINGLE_DEATH"] .. " " .. morte [3] .. " " .. Loc ["STRING_ACTORFRAME_REPORTAT"] .. " " .. morte [6], "", "", ""}
	
	for index, evento in _ipairs (_detalhes.table.reverse (morte [1])) do
		if (evento [1] and type (evento [1]) == "boolean") then --> damage
			if (evento [3]) then
				local elapsed = _cstr ("%.1f", evento [4] - time_of_death) .."s"
				local spellname, _, spellicon = _GetSpellInfo (evento [2])
				local spelllink
				
				if (evento [2] == 1) then
					spelllink = GetSpellLink (6603)
				elseif (evento [2] > 10) then
					spelllink = GetSpellLink (evento [2])
				else
					spelllink = spellname
				end
				
				local source = _detalhes:GetOnlyName (evento [6])
				local amount = evento [3]
				local hp = _math_floor (evento [5] / max_health * 100)
				if (hp > 100) then 
					hp = 100
				end
				
				tinsert (report_array, {elapsed .. " ", spelllink, " (" .. source .. ")", "-" .. _detalhes:ToK (amount) .. " (" .. hp .. "%) "})
			end
			
		elseif (not evento [1] and type (evento [1]) == "boolean") then --> heal
		
			local amount = evento [3]
			
			if (amount > _detalhes.deathlog_healingdone_min) then
				local elapsed = _cstr ("%.1f", evento [4] - time_of_death) .."s"
				local spelllink = GetSpellLink (evento [2])
				local source = _detalhes:GetOnlyName (evento [6])
				local spellname, _, spellicon = _GetSpellInfo (evento [2])
				
				local hp = _math_floor (evento [5] / max_health * 100)
				if (hp > 100) then 
					hp = 100
				end

				if (_detalhes.report_heal_links) then
					tinsert (report_array, {elapsed .. " ", spelllink, " (" .. source .. ")", "+" .. _detalhes:ToK (amount) .. " (" .. hp .. "%) "})
				else
					tinsert (report_array, {elapsed .. " ", spellname, " (" .. source .. ")", "+" .. _detalhes:ToK (amount) .. " (" .. hp .. "%) "})
				end
			end
			
		elseif (type (evento [1]) == "number" and evento [1] == 4) then --> debuff
			
			local elapsed = _cstr ("%.1f", evento [4] - time_of_death) .."s"
			local spelllink = GetSpellLink (evento [2])
			local source = _detalhes:GetOnlyName (evento [6])
			local spellname, _, spellicon = _GetSpellInfo (evento [2])
			local stacks = evento [3]
			local hp = _math_floor (evento [5] / max_health * 100)
			if (hp > 100) then 
				hp = 100
			end

			tinsert (report_array, {elapsed .. " ", "x" .. stacks .. "" .. spelllink, " (" .. source .. ")", "(" .. hp .. "%) "})
		end
	end
	
	_detalhes:SendReportWindow (ReportSingleDeathFunc, nil, nil, true)
end

function atributo_misc:ReportSingleCooldownLine (misc_actor, instancia)

	local reportar

	if (instancia.segmento == -1) then --overall
		reportar = {"Details!: " .. misc_actor.nome .. " - " .. Loc ["STRING_OVERALL"] .. " " .. Loc ["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"]}
	else
		reportar = {"Details!: " .. misc_actor.nome .. " - " .. Loc ["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"]}
	end
	
	local meu_total = _math_floor (misc_actor.cooldowns_defensive)
	local cooldowns = misc_actor.cooldowns_defensive_spells._ActorTable
	local cooldowns_used = {}
	
	for spellid, spell in _pairs (cooldowns) do
		cooldowns_used [#cooldowns_used+1] = {spellid, spell.counter, spell}
	end
	_table_sort (cooldowns_used, _detalhes.Sort2)

	for i, spell in _ipairs (cooldowns_used) do
		
		local spelllink = GetSpellLink (spell [1])
		reportar [#reportar+1] = spelllink .. ": " .. spell [2]
		
		for target_name, amount in _pairs (spell[3].targets) do
			if (target_name ~= misc_actor.nome and target_name ~= Loc ["STRING_RAID_WIDE"] and amount > 0) then
				reportar [#reportar+1] = "  -" .. target_name .. ": " .. amount
			end
		end
		
	end

	return _detalhes:Reportar (reportar, {_no_current = true, _no_inverse = true, _custom = true})
end

local buff_format_name = function (spellid)
	if (_type (spellid) == "string") then
		return spellid
	end
	return _detalhes:GetSpellLink (spellid)
end
local buff_format_amount = function (t)
	local total, percent = unpack (t)
	local m, s = _math_floor (total / 60), _math_floor (total % 60)
	return _cstr ("%.1f", percent) .. "% (" .. m .. "m " .. s .. "s)"
end
local sort_buff_report = function (t1, t2)
	return t1[2][1] > t2[2][1]
end

function atributo_misc:ReportSingleBuffUptimeLine (misc_actor, instance)
	local report_table = {"Details!: " .. misc_actor.nome .. " - " .. Loc ["STRING_ATTRIBUTE_MISC_BUFF_UPTIME"]}
	
	local buffs = {}
	local combat_time = instance.showing:GetCombatTime()
	
	for spellid, spell in _pairs (misc_actor.buff_uptime_spells._ActorTable) do
		local percent = spell.uptime / combat_time * 100
		if (percent < 99.5) then
			buffs [#buffs+1] = {spellid, {spell.uptime, percent}}
		end
	end

	_table_sort (buffs, sort_buff_report)
	_detalhes:FormatReportLines (report_table, buffs, buff_format_name, buff_format_amount)
	return _detalhes:Reportar (report_table, {_no_current = true, _no_inverse = true, _custom = true})
end

function atributo_misc:ReportSingleDebuffUptimeLine (misc_actor, instance)
	local report_table = {"Details!: " .. misc_actor.nome .. " - " .. Loc ["STRING_ATTRIBUTE_MISC_DEBUFF_UPTIME"]}

	local debuffs = {}
	local combat_time = instance.showing:GetCombatTime()
	
	for spellid, spell in _pairs (misc_actor.debuff_uptime_spells._ActorTable) do
		local percent = spell.uptime / combat_time * 100
		debuffs [#debuffs+1] = {spellid, {spell.uptime, percent}}
	end

	_table_sort (debuffs, sort_buff_report)
	_detalhes:FormatReportLines (report_table, debuffs, buff_format_name, buff_format_amount)

	return _detalhes:Reportar (report_table, {_no_current = true, _no_inverse = true, _custom = true})	
end

function atributo_misc:DeadAtualizarBarra (morte, qual_barra, colocacao, instancia)
	
	morte ["dead"] = true --> marca que esta tabela � uma tabela de mortes, usado no controla na hora de montar o tooltip
	local esta_barra = instancia.barras[qual_barra] --> pega a refer�ncia da barra na janela
	
	if (not esta_barra) then
		print ("DEBUG: problema com <instancia.esta_barra> "..qual_barra.." "..lugar)
		return
	end
	
	local tabela_anterior = esta_barra.minha_tabela
	
	esta_barra.minha_tabela = morte
	
	morte.nome = morte [3] --> evita dar erro ao redimencionar a janela
	morte.minha_barra = qual_barra
	esta_barra.colocacao = colocacao
	
	if (not _getmetatable (morte)) then 
		_setmetatable (morte, {__call = RefreshBarraMorte}) 
		morte._custom = true
	end
	
	esta_barra.texto_esquerdo:SetText (colocacao .. ". " .. morte [3]:gsub (("%-.*"), ""))
	esta_barra.texto_direita:SetText (morte [6])
	
	esta_barra:SetValue (100)
	if (esta_barra.hidden or esta_barra.fading_in or esta_barra.faded) then
		gump:Fade (esta_barra, "out")
	end
	
	--> seta a cor da barra e a cor do texto caso eles esteja mostrando com a cor da classe
	local r, g, b, a = _unpack (_detalhes.class_colors [morte[4]])
	_detalhes:SetBarColors (esta_barra, instancia, r, g, b, a)
	
	if (instancia.row_info.use_spec_icons) then
		local nome = morte[3]
		local spec = instancia.showing (1, nome) and instancia.showing (1, nome).spec or (instancia.showing (2, nome) and instancia.showing (2, nome).spec)
		if (spec) then
			esta_barra.icone_classe:SetTexture (instancia.row_info.spec_file)
			esta_barra.icone_classe:SetTexCoord (_unpack (_detalhes.class_specs_coords [spec]))
		else
			esta_barra.icone_classe:SetTexture (instancia.row_info.icon_file)
			esta_barra.icone_classe:SetTexCoord (_unpack (CLASS_ICON_TCOORDS [morte[4]]))
		end
	else
		esta_barra.icone_classe:SetTexture (instancia.row_info.icon_file)
		esta_barra.icone_classe:SetTexCoord (_unpack (CLASS_ICON_TCOORDS [morte[4]]))
	end
	esta_barra.icone_classe:SetVertexColor (1, 1, 1)
	
	if (esta_barra.mouse_over and not instancia.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip (qual_barra, esta_barra, instancia)
	end
	
	esta_barra.texto_esquerdo:SetSize (esta_barra:GetWidth() - esta_barra.texto_direita:GetStringWidth() - 20, 15)

end

function atributo_misc:RefreshWindow (instancia, tabela_do_combate, forcar, exportar, refresh_needed)
	
	local showing = tabela_do_combate [class_type] --> o que esta sendo mostrado -> [1] - dano [2] - cura --> pega o container com ._NameIndexTable ._ActorTable
	
	if (#showing._ActorTable < 1) then --> n�o h� barras para mostrar
		return _detalhes:EsconderBarrasNaoUsadas (instancia, showing), "", 0, 0
	end
	
	local total = 0	
	instancia.top = 0
	
	local sub_atributo = instancia.sub_atributo --> o que esta sendo mostrado nesta inst�ncia
	local conteudo = showing._ActorTable
	local amount = #conteudo
	local modo = instancia.modo
	
	if (exportar) then
		if (_type (exportar) == "boolean") then 		
			if (sub_atributo == 1) then --> CC BREAKS
				keyName = "cc_break"
			elseif (sub_atributo == 2) then --> RESS
				keyName = "ress"
			elseif (sub_atributo == 3) then --> INTERRUPT
				keyName = "interrupt"
			elseif (sub_atributo == 4) then --> DISPELLS
				keyName = "dispell"
			elseif (sub_atributo == 5) then --> DEATHS
				keyName = "dead"
			elseif (sub_atributo == 6) then --> DEFENSIVE COOLDOWNS
				keyName = "cooldowns_defensive"
			elseif (sub_atributo == 7) then --> BUFF UPTIME
				keyName = "buff_uptime"
			elseif (sub_atributo == 8) then --> DEBUFF UPTIME
				keyName = "debuff_uptime"
			end
		else
			keyName = exportar.key
			modo = exportar.modo
		end
		
	elseif (instancia.atributo == 5) then --> custom
		keyName = "custom"
		total = tabela_do_combate.totals [instancia.customName]		
		
	else	
		
		--> pega qual a sub key que ser� usada
		if (sub_atributo == 1) then --> CC BREAKS
			keyName = "cc_break"
		elseif (sub_atributo == 2) then --> RESS
			keyName = "ress"
		elseif (sub_atributo == 3) then --> INTERRUPT
			keyName = "interrupt"
		elseif (sub_atributo == 4) then --> DISPELLS
			keyName = "dispell"
		elseif (sub_atributo == 5) then --> DEATHS
			keyName = "dead"
		elseif (sub_atributo == 6) then --> DEFENSIVE COOLDOWNS
			keyName = "cooldowns_defensive"
		elseif (sub_atributo == 7) then --> BUFF UPTIME
			keyName = "buff_uptime"
		elseif (sub_atributo == 8) then --> DEBUFF UPTIME
			keyName = "debuff_uptime"
		end
	
	end
	
	if (keyName == "dead") then 
		local mortes = tabela_do_combate.last_events_tables
		--> n�o precisa reordenar, uma vez que sempre vai da na ordem do �ltimo a morrer at� o primeiro
		-- _table_sort (mortes, function (m1, m2) return m1[2] < m2[2] end) -- [1] = tabela com a morte [2] = tempo [3] = nome do jogador
		instancia.top = 1
		total = #mortes
		
		if (exportar) then 
			return mortes
		end

		if (total < 1) then
			instancia:EsconderScrollBar()
			return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
		end
		
		--estra mostrando ALL ent�o posso seguir o padr�o correto? primeiro, atualiza a scroll bar...
		instancia:AtualizarScrollBar (total)
		
		--depois faz a atualiza��o normal dele atrav�s dos_ iterators
		local qual_barra = 1
		local barras_container = instancia.barras
		local percentage_type = instancia.row_info.percent_type

		for i = instancia.barraS[1], instancia.barraS[2], 1 do --> vai atualizar s� o range que esta sendo mostrado
			if (mortes[i]) then --> corre��o para um raro e desconhecido problema onde mortes[i] � nil
				atributo_misc:DeadAtualizarBarra (mortes[i], qual_barra, i, instancia)
				qual_barra = qual_barra+1
			end
		end
		
		return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
		
	else
	
		if (instancia.atributo == 5) then --> custom
			--> faz o sort da categoria e retorna o amount corrigido
			_table_sort (conteudo, _detalhes.SortIfHaveKey)
			
			--> n�o mostrar resultados com zero
			for i = amount, 1, -1 do --> de tr�s pra frente
				if (not conteudo[i][keyName] or conteudo[i][keyName] < 1) then
					amount = amount - 1
				else
					break
				end
			end

			--> pega o total ja aplicado na tabela do combate
			total = tabela_do_combate.totals [class_type] [keyName]
			
			--> grava o total
			instancia.top = conteudo[1][keyName]
	
		elseif (modo == modo_ALL) then --> mostrando ALL
		
			_table_sort (conteudo, _detalhes.SortIfHaveKey)
			
			--> n�o mostrar resultados com zero
			for i = amount, 1, -1 do --> de tr�s pra frente
				if (not conteudo[i][keyName] or conteudo[i][keyName] < 1) then
					amount = amount - 1
				else
					break
				end
			end

			--> pega o total ja aplicado na tabela do combate
			total = tabela_do_combate.totals [class_type] [keyName]
			
			--> grava o total
			instancia.top = conteudo[1][keyName]
		
		elseif (modo == modo_GROUP) then --> mostrando GROUP
		
			--if (refresh_needed) then
				_table_sort (conteudo, _detalhes.SortGroupIfHaveKey)
			--end
			for index, player in _ipairs (conteudo) do
				if (player.grupo) then --> � um player e esta em grupo
					if (not player[keyName] or player[keyName] < 1) then --> dano menor que 1, interromper o loop
						amount = index - 1
						break
					elseif (index == 1) then --> esse IF aqui, precisa mesmo ser aqui? n�o daria pra pega-lo com uma chave [1] nad grupo == true?
						instancia.top = conteudo[1][keyName]
					end
					
					total = total + player[keyName]
				else
					amount = index-1
					break
				end
			end
		
		end
	end

	--> refaz o mapa do container
	showing:remapear()

	if (exportar) then 
		return total, keyName, instancia.top, amount
	end
	
	if (amount < 1) then --> n�o h� barras para mostrar
		instancia:EsconderScrollBar() --> precisaria esconder a scroll bar
		return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
	end

	--estra mostrando ALL ent�o posso seguir o padr�o correto? primeiro, atualiza a scroll bar...
	instancia:AtualizarScrollBar (amount)
	
	--depois faz a atualiza��o normal dele atrav�s dos_ iterators
	local qual_barra = 1
	local barras_container = instancia.barras
	local percentage_type = instancia.row_info.percent_type
	local bars_show_data = instancia.row_info.textR_show_data
	local bars_brackets = instancia:GetBarBracket()
	local bars_separator = instancia:GetBarSeparator()
	local use_animations = _detalhes.is_using_row_animations and (not instancia.baseframe.isStretching and not forcar)
	
	if (total == 0) then
		total = 0.00000001
	end

	UsingCustomLeftText = instancia.row_info.textL_enable_custom_text
	UsingCustomRightText = instancia.row_info.textR_enable_custom_text
	
	if (instancia.bars_sort_direction == 1) then --top to bottom
		for i = instancia.barraS[1], instancia.barraS[2], 1 do --> vai atualizar s� o range que esta sendo mostrado
			conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, nil, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)
			qual_barra = qual_barra+1
		end
		
	elseif (instancia.bars_sort_direction == 2) then --bottom to top
		for i = instancia.barraS[2], instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
			if (conteudo[i]) then
				conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, nil, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)
				qual_barra = qual_barra+1
			end
		end
		
	end
	
	if (use_animations) then
		instancia:fazer_animacoes (qual_barra-1)
	end
	
	if (instancia.atributo == 5) then --> custom
		--> zerar o .custom dos_ Actors
		for index, player in _ipairs (conteudo) do
			if (player.custom > 0) then 
				player.custom = 0
			else
				break
			end
		end
	end
	
	--> beta, hidar barras n�o usadas durante um refresh for�ado
	if (forcar) then
		if (instancia.modo == 2) then --> group
			for i = qual_barra, instancia.rows_fit_in_window  do
				gump:Fade (instancia.barras [i], "in", 0.3)
			end
		end
	end
	
	return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh

end

local actor_class_color_r, actor_class_color_g, actor_class_color_b

function atributo_misc:AtualizaBarra (instancia, barras_container, qual_barra, lugar, total, sub_atributo, forcar, keyName, is_dead, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)

	local esta_barra = instancia.barras[qual_barra] --> pega a refer�ncia da barra na janela
	
	if (not esta_barra) then
		print ("DEBUG: problema com <instancia.esta_barra> "..qual_barra.." "..lugar)
		return
	end
	
	local tabela_anterior = esta_barra.minha_tabela
	
	esta_barra.minha_tabela = self
	esta_barra.colocacao = lugar
	
	self.minha_barra = esta_barra
	self.colocacao = lugar
	
	local meu_total = _math_floor (self [keyName] or 0) --> total
	if (not meu_total) then
		return
	end
	
	--local porcentagem = meu_total / total * 100
	if (not percentage_type or percentage_type == 1) then
		porcentagem = _cstr ("%.1f", meu_total / total * 100)
	elseif (percentage_type == 2) then
		porcentagem = _cstr ("%.1f", meu_total / instancia.top * 100)
	end
	
	local esta_porcentagem = _math_floor ((meu_total/instancia.top) * 100)

	if (not bars_show_data [1]) then
		meu_total = ""
	end
	if (not bars_show_data [3]) then
		porcentagem = ""
	else
		porcentagem = porcentagem .. "%"
	end
	
	local rightText = meu_total .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
	if (UsingCustomRightText) then
		esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, meu_total, "", porcentagem, self, instancia.showing, instancia, rightText))
	else
		esta_barra.texto_direita:SetText (rightText)
	end
	
	if (esta_barra.mouse_over and not instancia.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip (qual_barra, esta_barra, instancia)
	end
	
	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()	

	return self:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, qual_barra, barras_container, use_animations)
end

function atributo_misc:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, qual_barra, barras_container, use_animations)
	
	--> primeiro colocado
	if (esta_barra.colocacao == 1) then
		if (not tabela_anterior or tabela_anterior ~= esta_barra.minha_tabela or forcar) then
			esta_barra:SetValue (100)
			
			if (esta_barra.hidden or esta_barra.fading_in or esta_barra.faded) then
				gump:Fade (esta_barra, "out")
			end
			
			return self:RefreshBarra (esta_barra, instancia)
		else
			return
		end
	else

		if (esta_barra.hidden or esta_barra.fading_in or esta_barra.faded) then
			
			if (use_animations) then
				esta_barra.animacao_fim = esta_porcentagem
			else
				esta_barra:SetValue (esta_porcentagem)
				esta_barra.animacao_ignorar = true
			end
			
			gump:Fade (esta_barra, "out")
			
			if (instancia.row_info.texture_class_colors) then
				esta_barra.textura:SetVertexColor (actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			if (instancia.row_info.texture_background_class_color) then
				esta_barra.background:SetVertexColor (actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			
			return self:RefreshBarra (esta_barra, instancia)
			
		else
			--> agora esta comparando se a tabela da barra � diferente da tabela na atualiza��o anterior
			if (not tabela_anterior or tabela_anterior ~= esta_barra.minha_tabela or forcar) then --> aqui diz se a barra do jogador mudou de posi��o ou se ela apenas ser� atualizada
			
				if (use_animations) then
					esta_barra.animacao_fim = esta_porcentagem
				else
					esta_barra:SetValue (esta_porcentagem)
					esta_barra.animacao_ignorar = true
				end
			
				esta_barra.last_value = esta_porcentagem --> reseta o ultimo valor da barra
				
				return self:RefreshBarra (esta_barra, instancia)
				
			elseif (esta_porcentagem ~= esta_barra.last_value) then --> continua mostrando a mesma tabela ent�o compara a porcentagem
				--> apenas atualizar
				if (use_animations) then
					esta_barra.animacao_fim = esta_porcentagem
				else
					esta_barra:SetValue (esta_porcentagem)
				end
				esta_barra.last_value = esta_porcentagem
				
				return self:RefreshBarra (esta_barra, instancia)
			end
		end

	end
	
end

function atributo_misc:RefreshBarra (esta_barra, instancia, from_resize)
	local class, enemy, arena_enemy, arena_ally = self.classe, self.enemy, self.arena_enemy, self.arena_ally
	
	if (from_resize) then
		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	end
	
	--> icon
	self:SetClassIcon (esta_barra.icone_classe, instancia, class)
	--> texture color
	self:SetBarColors (esta_barra, instancia, actor_class_color_r, actor_class_color_g, actor_class_color_b)
	--> left text
	self:SetBarLeftText (esta_barra, instancia, enemy, arena_enemy, arena_ally, UsingCustomLeftText)

	esta_barra.texto_esquerdo:SetSize (esta_barra:GetWidth() - esta_barra.texto_direita:GetStringWidth() - 20, 15)
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------


---------> TOOLTIPS BIFURCA��O ~tooltip
function atributo_misc:ToolTip (instancia, numero, barra, keydown)
	--> seria possivel aqui colocar o icone da classe dele?
	GameTooltip:ClearLines()
	GameTooltip:AddLine (barra.colocacao..". "..self.nome)
	
	if (instancia.sub_atributo == 3) then --> interrupt
		return self:ToolTipInterrupt (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 1) then --> cc_break
		return self:ToolTipCC (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 2) then --> ress 
		return self:ToolTipRess (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 4) then --> dispell
		return self:ToolTipDispell (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 5) then --> mortes
		return self:ToolTipDead (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 6) then --> defensive cooldowns
		return self:ToolTipDefensiveCooldowns (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 7) then --> buff uptime
		return self:ToolTipBuffUptime (instancia, numero, barra, keydown)
	elseif (instancia.sub_atributo == 8) then --> debuff uptime
		return self:ToolTipDebuffUptime (instancia, numero, barra, keydown)
	end
end

--> tooltip locals
local r, g, b
local barAlha = .6

function atributo_misc:ToolTipDead (instancia, numero, barra)
	
	local last_dead = self.dead_log [#self.dead_log]

end

function atributo_misc:ToolTipCC (instancia, numero, barra)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	

	local meu_total = self ["cc_break"]
	local habilidades = self.cc_break_spells._ActorTable
	
	--> habilidade usada para tirar o CC
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	local lineHeight = _detalhes.tooltip.line_height
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	for _spellid, _tabela in _pairs (habilidades) do
		
		--> quantidade
		local nome_magia, _, icone_magia = _GetSpellInfo (_spellid)
		GameCooltip:AddLine (nome_magia, _tabela.cc_break .. " (" .. _cstr ("%.1f", _tabela.cc_break / meu_total * 100) .. "%)")
		GameCooltip:AddIcon (icone_magia, nil, nil, lineHeight, lineHeight, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		
		--> o que quebrou
		local quebrou_oque = _tabela.cc_break_oque
		for spellid_quebrada, amt_quebrada in _pairs (_tabela.cc_break_oque) do 
			local nome_magia, _, icone_magia = _GetSpellInfo (spellid_quebrada)
			GameCooltip:AddLine (nome_magia, amt_quebrada .. "  ")
			GameCooltip:AddIcon ([[Interface\Buttons\UI-GroupLoot-Pass-Down]], nil, 1, 14, 14)
			GameCooltip:AddIcon (icone_magia, nil, 2, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			GameCooltip:AddStatusBar (100, 1, 1, 0, 0, .2)
		end
		
		--> em quem quebrou
		for target_name, amount in _pairs (_tabela.targets) do
			GameCooltip:AddLine (target_name .. ": ", amount .. "  ")
			
			local classe = _detalhes:GetClass (target_name)
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\espadas]], nil, 1, lineHeight, lineHeight)
			if (classe) then	
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], nil, 2, lineHeight, lineHeight, unpack (_detalhes.class_coords [classe]))
			else
				GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, 2, lineHeight, lineHeight, .25, .5, 0, 1)
			end
			
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	end
	
	
	return true
end

function atributo_misc:ToolTipDispell (instancia, numero, barra)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	

	local meu_total = _math_floor (self ["dispell"])
	local habilidades = self.dispell_spells._ActorTable
	
--> habilidade usada para dispelar
	local meus_dispells = {}
	for _spellid, _tabela in _pairs (habilidades) do
		meus_dispells [#meus_dispells+1] = {_spellid, _math_floor (_tabela.dispell)}
	end
	_table_sort (meus_dispells, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #meus_dispells, [[Interface\ICONS\Spell_Arcane_ArcaneTorrent]], 0.078125, 0.9375, 0.078125, 0.953125)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	if (#meus_dispells > 0) then
		for i = 1, _math_min (25, #meus_dispells) do
			local esta_habilidade = meus_dispells[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2].." (".._cstr("%.1f", esta_habilidade[2]/meu_total*100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	else
		GameTooltip:AddLine (Loc ["STRING_NO_SPELL"])
	end
	
--> quais habilidades foram dispaladas
	local buffs_dispelados = {}
	for _spellid, amt in _pairs (self.dispell_oque) do
		buffs_dispelados [#buffs_dispelados+1] = {_spellid, amt}
	end
	_table_sort (buffs_dispelados, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_DISPELLED"], headerColor, #buffs_dispelados, [[Interface\ICONS\Spell_Arcane_ManaTap]], 0.078125, 0.9375, 0.078125, 0.953125)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)

	if (#buffs_dispelados > 0) then
		for i = 1, _math_min (25, #buffs_dispelados) do
			local esta_habilidade = buffs_dispelados[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2].." (".._cstr("%.1f", esta_habilidade[2]/meu_total*100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	end

--> alvos dispelados
	
	local alvos_dispelados = {}
	for target_name, amount in _pairs (self.dispell_targets) do
		alvos_dispelados [#alvos_dispelados + 1] = {target_name, _math_floor (amount), amount / meu_total * 100}
	end
	_table_sort (alvos_dispelados, _detalhes.Sort2)

	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_TARGETS"], headerColor, #alvos_dispelados, [[Interface\ICONS\ACHIEVEMENT_GUILDPERK_EVERYONES A HERO_RANK2]], 0.078125, 0.9375, 0.078125, 0.953125)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	for i = 1, _math_min (25, #alvos_dispelados) do
		if (alvos_dispelados[i][2] < 1) then
			break
		end
		
		GameCooltip:AddLine (alvos_dispelados[i][1], _detalhes:comma_value (alvos_dispelados[i][2]) .." (".._cstr ("%.1f", alvos_dispelados[i][3]).."%)")
		_detalhes:AddTooltipBackgroundStatusbar()
		
		local targetActor = instancia.showing[4]:PegarCombatente (_, alvos_dispelados[i][1])
		
		if (targetActor) then
			local classe = targetActor.classe
			if (not classe) then
				classe = "UNKNOW"
			end
			if (classe == "UNKNOW") then
				GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
			else
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack (_detalhes.class_coords [classe]))
			end
		end
	end
	
--> Pet
	local meus_pets = self.pets
	if (#meus_pets > 0) then --> teve ajudantes
		
		local quantidade = {} --> armazena a quantidade de pets iguais
		local interrupts = {} --> armazena as habilidades
		local alvos = {} --> armazena os alvos
		local totais = {} --> armazena o dano total de cada objeto
		
		for index, nome in _ipairs (meus_pets) do
			if (not quantidade [nome]) then
				quantidade [nome] = 1
				
				local my_self = instancia.showing[class_type]:PegarCombatente (nil, nome)
				if (my_self and my_self.dispell) then
					totais [#totais+1] = {nome, my_self.dispell}
				end
			else
				quantidade [nome] = quantidade [nome]+1
			end
		end
	
		local _quantidade = 0
		local added_logo = false
		
		_table_sort (totais, _detalhes.Sort2)
		
		local ismaximized = false
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			ismaximized = true
		end
		
		for index, _table in _ipairs (totais) do
			
			if (_table [2] > 0 and (index < 3 or ismaximized)) then
			
				if (not added_logo) then
					added_logo = true

					_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_PETS"], headerColor, #totais, [[Interface\COMMON\friendship-heart]], 0.21875, 0.78125, 0.09375, 0.6875)
					_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
				end
			
				local n = _table [1]:gsub (("%s%<.*"), "")
				GameCooltip:AddLine (n, _table [2] .. " (" .. _math_floor (_table [2]/self.dispell*100) .. "%)")
				_detalhes:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
			
	end
	
	return true
end

local UnitReaction = UnitReaction
local UnitDebuff = UnitDebuff

function _detalhes:CloseEnemyDebuffsUptime()
	local combat = _detalhes.tabela_vigente
	local misc_container = combat [4]._ActorTable
	
	for _, actor in _ipairs (misc_container) do 
		if (actor.boss_debuff) then
			for target_name, target in _ipairs (actor.debuff_uptime_targets) do 
				if (target.actived and target.actived_at) then
					target.uptime = target.uptime + _detalhes._tempo - target.actived_at
					actor.debuff_uptime = actor.debuff_uptime + _detalhes._tempo - target.actived_at
					target.actived = false
					target.actived_at = nil
				end
			end
		end
	end
	
	return
end

function _detalhes:CatchRaidDebuffUptime (in_or_out) -- "DEBUFF_UPTIME_IN"

	if (in_or_out == "DEBUFF_UPTIME_OUT") then
		local combat = _detalhes.tabela_vigente
		local misc_container = combat [4]._ActorTable
		
		for _, actor in _ipairs (misc_container) do 
			if (actor.debuff_uptime) then
				for spellid, spell in _pairs (actor.debuff_uptime_spells._ActorTable) do 
					if (spell.actived and spell.actived_at) then
						spell.uptime = spell.uptime + _detalhes._tempo - spell.actived_at
						actor.debuff_uptime = actor.debuff_uptime + _detalhes._tempo - spell.actived_at
						spell.actived = false
						spell.actived_at = nil
					end
				end
			end
		end
		
		return
	end

	local cacheGetTime = GetTime()
	
	if (_IsInRaid()) then
	
		local checked = {}
		
		for raidIndex = 1, _GetNumGroupMembers() do
		
			local target = "raid"..raidIndex.."target"
			local his_target = _UnitGUID (target)
			
			if (his_target and not checked [his_target]) then
				local rect = UnitReaction (target, "player")
				if (rect and rect <= 4) then
					
					checked [his_target] = true
					
					for debuffIndex = 1, 41 do
						local name, _, _, _, _, _, _, unitCaster, _, _, spellid = UnitDebuff (target, debuffIndex)
						if (name and unitCaster) then
							local playerGUID = _UnitGUID (unitCaster)
							if (playerGUID) then
								local playerName, realmName = _UnitName (unitCaster)
								if (realmName and realmName ~= "") then
									playerName = playerName .. "-" .. realmName
								end
								_detalhes.parser:add_debuff_uptime (nil, cacheGetTime, playerGUID, playerName, 0x00000417, his_target, _UnitName (target), 0x842, nil, spellid, name, in_or_out)
							end
						end
					end
				end
			end
		end
		
	elseif (_IsInGroup()) then
		
		local checked = {}
		
		for raidIndex = 1, _GetNumGroupMembers()-1 do
			local his_target = _UnitGUID ("party"..raidIndex.."target")
			local rect = UnitReaction ("party"..raidIndex.."target", "player")
			if (his_target and not checked [his_target] and rect and rect <= 4) then
				
				checked [his_target] = true
				
				for debuffIndex = 1, 40 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff ("party"..raidIndex.."target", debuffIndex)
					if (name and unitCaster) then
						local playerName, realmName = _UnitName (unitCaster)
						local playerGUID = _UnitGUID (unitCaster)
						if (playerGUID) then
							if (realmName and realmName ~= "") then
								playerName = playerName .. "-" .. realmName
							end
							
							_detalhes.parser:add_debuff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, his_target, _UnitName ("party"..raidIndex.."target"), 0x842, nil, spellid, name, in_or_out)
						end
					end
				end
			end
		end
		
		local his_target = _UnitGUID ("playertarget")
		local rect = UnitReaction ("playertarget", "player")
		if (his_target and not checked [his_target] and rect and rect <= 4) then
			for debuffIndex = 1, 40 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff ("playertarget", debuffIndex)
				if (name and unitCaster) then
					local playerName, realmName = _UnitName (unitCaster)
					local playerGUID = _UnitGUID (unitCaster)
					if (playerGUID) then
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						_detalhes.parser:add_debuff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, his_target, _UnitName ("playertarget"), 0x842, nil, spellid, name, in_or_out)
					end
				end
			end
		end
		
	else
		local his_target = _UnitGUID ("playertarget")
		if (his_target) then
			local reaction = UnitReaction ("playertarget", "player")
			if (reaction and reaction <= 4) then
				for debuffIndex = 1, 40 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff ("playertarget", debuffIndex)
					if (name and unitCaster) then
						local playerName, realmName = _UnitName (unitCaster)
						local playerGUID = _UnitGUID (unitCaster)
						if (playerGUID) then
							if (realmName and realmName ~= "") then
								playerName = playerName .. "-" .. realmName
							end
							_detalhes.parser:add_debuff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, his_target, _UnitName ("playertarget"), 0x842, nil, spellid, name, in_or_out)
						end
					end
				end
			end
		end
	end
end

local runes_id = {
	[175457] = true, -- focus
	[175456] = true, --hyper
	[175439] = true, --stout
}

function _detalhes:CatchRaidBuffUptime (in_or_out)

	if (_IsInRaid()) then
	
		local pot_usage = {}
		local focus_augmentation = {}
	
		--> raid groups
		local cacheGetTime = GetTime()
		
		for raidIndex = 1, _GetNumGroupMembers() do
			local RaidIndex = "raid" .. raidIndex
			local playerGUID = _UnitGUID (RaidIndex)

			if (playerGUID) then
			
				local playerName, realmName = _UnitName (RaidIndex)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura (RaidIndex, buffIndex, nil, "HELPFUL")
					if (name and unitCaster == RaidIndex) then
						_detalhes.parser:add_buff_uptime (nil, cacheGetTime, playerGUID, playerName, 0x00000514, playerGUID, playerName, 0x00000514, 0x0, spellid, name, in_or_out)
						if (in_or_out == "BUFF_UPTIME_IN") then
							if (_detalhes.PotionList [spellid]) then
								pot_usage [playerName] = spellid
							elseif (runes_id [spellid]) then
								focus_augmentation [playerName] = true
							end
						end
					end
				end
			end
		end
		
--		/run print (GetNumSubgroupMembers());for i=1,GetNumSubgroupMembers()do print (UnitName("party"..i))end
		
		--> player sub group
		for partyIndex = 1, _GetNumSubgroupMembers() do
			local PartyIndex = "party" .. partyIndex
			local playerGUID = _UnitGUID (PartyIndex)
			
			if (playerGUID) then
			
				local playerName, realmName = _UnitName (PartyIndex)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura (PartyIndex, buffIndex, nil, "HELPFUL")
					if (name and unitCaster == PartyIndex) then
						_detalhes.parser:add_buff_uptime (nil, cacheGetTime, playerGUID, playerName, 0x00000514, playerGUID, playerName, 0x00000514, 0x0, spellid, name, in_or_out)
						
						if (in_or_out == "BUFF_UPTIME_IN") then
							if (_detalhes.PotionList [spellid]) then
								pot_usage [playerName] = spellid
							elseif (runes_id [spellid]) then
								focus_augmentation [playerName] = true
							end
						end
					end
				end
			end
		end
		
		--> unitCaster return player instead of raidIndex
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura ("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName ("player")
				local playerGUID = _UnitGUID ("player")
				
				if (playerGUID) then
					if (in_or_out == "BUFF_UPTIME_IN") then
						if (_detalhes.PotionList [spellid]) then
							pot_usage [playerName] = spellid
						elseif (runes_id [spellid]) then
							focus_augmentation [playerName] = true
						end
					end
					
					_detalhes.parser:add_buff_uptime (nil, cacheGetTime, playerGUID, playerName, 0x00000514, playerGUID, playerName, 0x00000514, 0x0, spellid, name, in_or_out)
				end
			end
		end
		
		if (in_or_out == "BUFF_UPTIME_IN") then
			local string_output = "pre-potion: " --> localize-me

			for playername, potspellid in _pairs (pot_usage) do
				local name, _, icon = _GetSpellInfo (potspellid)
				local _, class = UnitClass (playername)
				local class_color = ""
				if (class and RAID_CLASS_COLORS [class]) then
					class_color = RAID_CLASS_COLORS [class].colorStr
				end
				string_output = string_output .. "|c" .. class_color .. playername .. "|r |T" .. icon .. ":14:14:0:0:64:64:0:64:0:64|t "
			end
			
			_detalhes.pre_pot_used = string_output
			
			_detalhes:SendEvent ("COMBAT_PREPOTION_UPDATED", nil, pot_usage, focus_augmentation)
		end
		
	elseif (_IsInGroup()) then
	
		local pot_usage = {}
		local focus_augmentation = {}
		
		for groupIndex = 1, _GetNumGroupMembers()-1 do 
			for buffIndex = 1, 41 do
				local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura ("party"..groupIndex, buffIndex, nil, "HELPFUL")
				if (name and unitCaster == "party"..groupIndex) then
				
					local playerName, realmName = _UnitName ("party"..groupIndex)
					local playerGUID = _UnitGUID ("party"..groupIndex)
					
					if (playerGUID) then
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						if (in_or_out == "BUFF_UPTIME_IN") then
							if (_detalhes.PotionList [spellid]) then
								pot_usage [playerName] = spellid
							elseif (runes_id [spellid]) then
								focus_augmentation [playerName] = true
							end
						end
					
						_detalhes.parser:add_buff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, playerGUID, playerName, 0x00000417, 0x0, spellid, name, in_or_out)
					end
				end
			end
		end
		
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura ("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName ("player")
				local playerGUID = _UnitGUID ("player")
				if (playerGUID) then
					if (in_or_out == "BUFF_UPTIME_IN") then
						if (_detalhes.PotionList [spellid]) then
							pot_usage [playerName] = spellid
						elseif (runes_id [spellid]) then
							focus_augmentation [playerName] = true
						end
					end
				
					_detalhes.parser:add_buff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, playerGUID, playerName, 0x00000417, 0x0, spellid, name, in_or_out)
				end
			end
		end
		
		if (in_or_out == "BUFF_UPTIME_IN") then
			local string_output = "pre-potion: "
			
			for playername, potspellid in _pairs (pot_usage) do
				local name, _, icon = _GetSpellInfo (potspellid)
				local _, class = UnitClass (playername)
				local class_color = ""
				if (class and RAID_CLASS_COLORS [class]) then
					class_color = RAID_CLASS_COLORS [class].colorStr
				end
				string_output = string_output .. "|c" .. class_color .. playername .. "|r |T" .. icon .. ":14:14:0:0:64:64:0:64:0:64|t "
			end
			
			_detalhes.pre_pot_used = string_output
			_detalhes:SendEvent ("COMBAT_PREPOTION_UPDATED", nil, pot_usage, focus_augmentation)
		end
		
	else
	
		local pot_usage = {}
		local focus_augmentation = {}
		
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura ("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName ("player")
				local playerGUID = _UnitGUID ("player")
				
				if (playerGUID) then
					if (in_or_out == "BUFF_UPTIME_IN") then
						if (_detalhes.PotionList [spellid]) then
							pot_usage [playerName] = spellid
						elseif (runes_id [spellid]) then
							focus_augmentation [playerName] = true
						end
					end
					_detalhes.parser:add_buff_uptime (nil, GetTime(), playerGUID, playerName, 0x00000417, playerGUID, playerName, 0x00000417, 0x0, spellid, name, in_or_out)
				end
			end
		end
		
		--[
		if (in_or_out == "BUFF_UPTIME_IN") then
			local string_output = "pre-potion: "
			for playername, potspellid in _pairs (pot_usage) do
				local name, _, icon = _GetSpellInfo (potspellid)
				local _, class = UnitClass (playername)
				local class_color = ""
				if (class and RAID_CLASS_COLORS [class]) then
					class_color = RAID_CLASS_COLORS [class].colorStr
				end
				string_output = string_output .. "|c" .. class_color .. playername .. "|r |T" .. icon .. ":14:14:0:0:64:64:0:64:0:64|t "
			end
			
			_detalhes.pre_pot_used = string_output
			_detalhes:SendEvent ("COMBAT_PREPOTION_UPDATED", nil, pot_usage, focus_augmentation)
		end
		
		--]]
		-- _detalhes:Msg (string_output)
		
	end
end

local Sort2Reverse = function (a, b)
	return a[2] < b[2]
end

function atributo_misc:ToolTipDebuffUptime (instancia, numero, barra)
	
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	
	
	local meu_total = self ["debuff_uptime"]
	local minha_tabela = self.debuff_uptime_spells._ActorTable
	
--> habilidade usada para interromper
	local debuffs_usados = {}
	
	local _combat_time = instancia.showing:GetCombatTime()
	
	for _spellid, _tabela in _pairs (minha_tabela) do
		debuffs_usados [#debuffs_usados+1] = {_spellid, _tabela.uptime}
	end
	--_table_sort (debuffs_usados, Sort2Reverse)
	_table_sort (debuffs_usados, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #debuffs_usados, _detalhes.tooltip_spell_icon.file, unpack (_detalhes.tooltip_spell_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)

	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	if (#debuffs_usados > 0) then
		for i = 1, _math_min (30, #debuffs_usados) do
			local esta_habilidade = debuffs_usados[i]
			
			if (esta_habilidade[2] > 0) then
				local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
				
				local minutos, segundos = _math_floor (esta_habilidade[2]/60), _math_floor (esta_habilidade[2]%60)
				if (esta_habilidade[2] >= _combat_time) then
					--GameCooltip:AddLine (nome_magia, minutos .. "m " .. segundos .. "s" .. " (" .. _cstr ("%.1f", esta_habilidade[2] / _combat_time * 100) .. "%)", nil, "gray", "gray")
					--GameCooltip:AddStatusBar (100, nil, 1, 0, 1, .3, false)
				elseif (minutos > 0) then
					GameCooltip:AddLine (nome_magia, minutos .. "m " .. segundos .. "s" .. " (" .. _cstr ("%.1f", esta_habilidade[2] / _combat_time * 100) .. "%)")
					_detalhes:AddTooltipBackgroundStatusbar (false, esta_habilidade[2] / _combat_time * 100)
				else
					GameCooltip:AddLine (nome_magia, segundos .. "s" .. " (" .. _cstr ("%.1f", esta_habilidade[2] / _combat_time * 100) .. "%)")
					_detalhes:AddTooltipBackgroundStatusbar (false, esta_habilidade[2] / _combat_time * 100)
				end
				
				GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			end
		end
	else
		GameCooltip:AddLine (Loc ["STRING_NO_SPELL"]) 
	end
	
	return true
	
end

function atributo_misc:ToolTipBuffUptime (instancia, numero, barra)
	
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	
	
	local meu_total = self ["buff_uptime"]
	local minha_tabela = self.buff_uptime_spells._ActorTable
	
--> habilidade usada para interromper
	local buffs_usados = {}
	
	local _combat_time = instancia.showing:GetCombatTime()
	
	for _spellid, _tabela in _pairs (minha_tabela) do
		buffs_usados [#buffs_usados+1] = {_spellid, _tabela.uptime}
	end
	--_table_sort (buffs_usados, Sort2Reverse)
	_table_sort (buffs_usados, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #buffs_usados, _detalhes.tooltip_spell_icon.file, unpack (_detalhes.tooltip_spell_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)

	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	if (#buffs_usados > 0) then
		for i = 1, _math_min (30, #buffs_usados) do
			local esta_habilidade = buffs_usados[i]
			
			local percent = esta_habilidade[2] / _combat_time * 100
			
			if (esta_habilidade[2] > 0 and percent < 99.5) then
				local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
				
				local minutos, segundos = _math_floor (esta_habilidade[2]/60), _math_floor (esta_habilidade[2]%60)
				if (esta_habilidade[2] >= _combat_time) then
					--GameCooltip:AddLine (nome_magia, minutos .. "m " .. segundos .. "s" .. " (" .. _cstr ("%.1f", esta_habilidade[2] / _combat_time * 100) .. "%)", nil, "gray", "gray")
					--GameCooltip:AddStatusBar (100, nil, 1, 0, 1, .3, false)
				elseif (minutos > 0) then
					GameCooltip:AddLine (nome_magia, minutos .. "m " .. segundos .. "s" .. " (" .. _cstr ("%.1f", percent) .. "%)")
					_detalhes:AddTooltipBackgroundStatusbar (false, percent)
				else
					GameCooltip:AddLine (nome_magia, segundos .. "s" .. " (" .. _cstr ("%.1f", percent) .. "%)")
					_detalhes:AddTooltipBackgroundStatusbar (false, percent)
				end
				
				GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			end
		end
	else
		GameCooltip:AddLine (Loc ["STRING_NO_SPELL"]) 
	end
	
	return true
	
end

function atributo_misc:ToolTipDefensiveCooldowns (instancia, numero, barra)
	
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end
	
	local meu_total = _math_floor (self ["cooldowns_defensive"])
	local minha_tabela = self.cooldowns_defensive_spells._ActorTable
	
--> spells
	local cooldowns_usados = {}
	
	for _spellid, _tabela in _pairs (minha_tabela) do
		cooldowns_usados [#cooldowns_usados+1] = {_spellid, _tabela.counter}
	end
	_table_sort (cooldowns_usados, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #cooldowns_usados, _detalhes.tooltip_spell_icon.file, unpack (_detalhes.tooltip_spell_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	local lineHeight = _detalhes.tooltip.line_height
	
	if (#cooldowns_usados > 0) then
		for i = 1, _math_min (25, #cooldowns_usados) do
			local esta_habilidade = cooldowns_usados[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2].." (".._cstr("%.1f", esta_habilidade[2]/meu_total*100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	else
		GameCooltip:AddLine (Loc ["STRING_NO_SPELL"]) 
	end

--> targets
	local meus_alvos = self.cooldowns_defensive_targets
	local alvos = {}
	
	for target_name, amount in _pairs (meus_alvos) do
		alvos [#alvos+1] = {target_name, amount}
	end
	_table_sort (alvos, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_TARGETS"], headerColor, #alvos, _detalhes.tooltip_target_icon.file, unpack (_detalhes.tooltip_target_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	if (#alvos > 0) then
		for i = 1, _math_min (25, #alvos) do
			GameCooltip:AddLine (_detalhes:GetOnlyName (alvos[i][1]) .. ": ", alvos[i][2], 1, "white", "white")
			_detalhes:AddTooltipBackgroundStatusbar()
			
			GameCooltip:AddIcon ("Interface\\Icons\\PALADIN_HOLY", nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			
			local targetActor = instancia.showing[4]:PegarCombatente (_, alvos[i][1])
			if (targetActor) then
				local classe = targetActor.classe
				if (not classe) then
					classe = "UNKNOW"
				end
				if (classe == "UNKNOW") then
					GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
				else
					local specID = _detalhes:GetSpec (alvos[i][1])
					if (specID) then
						local texture, l, r, t, b = _detalhes:GetSpecIcon (specID, false)
						GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
					else
						GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack (_detalhes.class_coords [classe]))
					end
				end
			end
			
		end
	end
	
	return true
	
end

function atributo_misc:ToolTipRess (instancia, numero, barra)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	

	local meu_total = self ["ress"]
	local minha_tabela = self.ress_spells._ActorTable
	local lineHeight = _detalhes.tooltip.line_height
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
--> habilidade usada para interromper
	local meus_ress = {}
	
	for _spellid, _tabela in _pairs (minha_tabela) do
		meus_ress [#meus_ress+1] = {_spellid, _tabela.ress}
	end
	_table_sort (meus_ress, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #meus_ress, _detalhes.tooltip_spell_icon.file, unpack (_detalhes.tooltip_spell_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	if (#meus_ress > 0) then
		for i = 1, _math_min (3, #meus_ress) do
			local esta_habilidade = meus_ress[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2] .. " (" .. _cstr ("%.1f", floor (esta_habilidade[2]) / floor (meu_total) * 100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, lineHeight, lineHeight, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	else
		GameCooltip:AddLine (Loc ["STRING_NO_SPELL"]) 
	end

--> quem foi que o cara reviveu
	local meus_alvos = self.ress_targets
	local alvos = {}
	
	for target_name, amount in _pairs (meus_alvos) do
		alvos [#alvos+1] = {target_name, amount}
	end
	_table_sort (alvos, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_TARGETS"], headerColor, #alvos, _detalhes.tooltip_target_icon.file, unpack (_detalhes.tooltip_target_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	if (#alvos > 0) then
		for i = 1, _math_min (3, #alvos) do
			GameCooltip:AddLine (alvos[i][1], alvos[i][2])
			_detalhes:AddTooltipBackgroundStatusbar()
			
			local targetActor = instancia.showing[4]:PegarCombatente (_, alvos[i][1])
			if (targetActor) then
				local classe = targetActor.classe
				if (not classe) then
					classe = "UNKNOW"
				end
				if (classe == "UNKNOW") then
					GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, lineHeight, lineHeight, .25, .5, 0, 1)
				else
					local specID = _detalhes:GetSpec (alvos[i][1])
					if (specID) then
						local texture, l, r, t, b = _detalhes:GetSpecIcon (specID, false)
						GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
					else
						GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, lineHeight, lineHeight, _unpack (_detalhes.class_coords [classe]))
					end
				end
			end
			
		end
	end
	
	return true

end

function atributo_misc:ToolTipInterrupt (instancia, numero, barra)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end	

	local meu_total = self ["interrupt"]
	local minha_tabela = self.interrupt_spells._ActorTable
	
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	local lineHeight = _detalhes.tooltip.line_height
	
--> habilidade usada para interromper
	local meus_interrupts = {}
	
	for _spellid, _tabela in _pairs (minha_tabela) do
		meus_interrupts [#meus_interrupts+1] = {_spellid, _tabela.counter}
	end
	_table_sort (meus_interrupts, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #meus_interrupts, _detalhes.tooltip_spell_icon.file, unpack (_detalhes.tooltip_spell_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	if (#meus_interrupts > 0) then
		for i = 1, _math_min (25, #meus_interrupts) do
			local esta_habilidade = meus_interrupts[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2].." (".._cstr("%.1f", floor (esta_habilidade[2])/floor (meu_total)*100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	else
		GameTooltip:AddLine (Loc ["STRING_NO_SPELL"])
	end
	
--> quais habilidades foram interrompidas
	local habilidades_interrompidas = {}
	
	for _spellid, amt in _pairs (self.interrompeu_oque) do
		habilidades_interrompidas [#habilidades_interrompidas+1] = {_spellid, amt}
	end
	_table_sort (habilidades_interrompidas, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELL_INTERRUPTED"] .. ":", headerColor, #habilidades_interrompidas, _detalhes.tooltip_target_icon.file, unpack (_detalhes.tooltip_target_icon.coords))
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
	if (#habilidades_interrompidas > 0) then
		for i = 1, _math_min (25, #habilidades_interrompidas) do
			local esta_habilidade = habilidades_interrompidas[i]
			local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
			GameCooltip:AddLine (nome_magia, esta_habilidade[2].." (".._cstr("%.1f", floor (esta_habilidade[2])/floor (meu_total)*100).."%)")
			GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end
	end
	
--> Pet
	local meus_pets = self.pets
	if (#meus_pets > 0) then --> teve ajudantes
		
		local quantidade = {} --> armazena a quantidade de pets iguais
		local interrupts = {} --> armazena as habilidades
		local alvos = {} --> armazena os alvos
		local totais = {} --> armazena o dano total de cada objeto
		
		for index, nome in _ipairs (meus_pets) do
			if (not quantidade [nome]) then
				quantidade [nome] = 1
				
				local my_self = instancia.showing[class_type]:PegarCombatente (nil, nome)
				if (my_self and my_self.interrupt) then
					totais [#totais+1] = {nome, my_self.interrupt}
				end
			else
				quantidade [nome] = quantidade [nome]+1
			end
		end
	
		local _quantidade = 0
		local added_logo = false
		
		_table_sort (totais, _detalhes.Sort2)
		
		local ismaximized = false
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			ismaximized = true
		end
		
		for index, _table in _ipairs (totais) do
			
			if (_table [2] > 0 and (index < 3 or ismaximized)) then
			
				if (not added_logo) then
					added_logo = true

					_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_PETS"], headerColor, #totais, [[Interface\COMMON\friendship-heart]], 0.21875, 0.78125, 0.09375, 0.6875)
					_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
				end
			
				local n = _table [1]:gsub (("%s%<.*"), "")
				GameCooltip:AddLine (n, _table [2] .. " (" .. _math_floor (_table [2]/self.interrupt*100) .. "%)")
				_detalhes:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
			
	end
	
	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------


---------> DETALHES BIFURCA��O
function atributo_misc:MontaInfo()
	if (info.sub_atributo == 3) then --> interrupt
		return self:MontaInfoInterrupt()
	end
end

---------> DETALHES bloco da direita BIFURCA��O
function atributo_misc:MontaDetalhes (spellid, barra)
	if (info.sub_atributo == 3) then --> interrupt
		return self:MontaDetalhesInterrupt (spellid, barra)
	end
end

------ Interrupt
function atributo_misc:MontaInfoInterrupt()

	local meu_total = self ["interrupt"]
	
	if (not self.interrupt_spells) then
		return
	end
	
	local minha_tabela = self.interrupt_spells._ActorTable

	local barras = info.barras1
	local instancia = info.instancia
	
	local meus_interrupts = {}

	--player
	for _spellid, _tabela in _pairs (minha_tabela) do --> da foreach em cada spellid do container
		local nome, _, icone = _GetSpellInfo (_spellid)
		_table_insert (meus_interrupts, {_spellid, _tabela.counter, _tabela.counter/meu_total*100, nome, icone})
	end
	--pet
	local ActorPets = self.pets
	local class_color = "FFDDDDDD"
	for _, PetName in _ipairs (ActorPets) do
		local PetActor = instancia.showing (class_type, PetName)
		if (PetActor and PetActor.interrupt and PetActor.interrupt > 0) then 
			local PetSkillsContainer = PetActor.interrupt_spells._ActorTable
			for _spellid, _skill in _pairs (PetSkillsContainer) do --> da foreach em cada spellid do container
				local nome, _, icone = _GetSpellInfo (_spellid)
				_table_insert (meus_interrupts, {_spellid, _skill.counter, _skill.counter/meu_total*100, nome .. " (|c" .. class_color .. PetName:gsub ((" <.*"), "") .. "|r)", icone, PetActor})
			end
		end
	end
	
	_table_sort (meus_interrupts, _detalhes.Sort2)

	local amt = #meus_interrupts
	gump:JI_AtualizaContainerBarras (amt)

	local max_ = meus_interrupts [1][2] --> dano que a primeiro magia vez

	local barra
	for index, tabela in _ipairs (meus_interrupts) do

		barra = barras [index]

		if (not barra) then --> se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
			
			barra.textura:SetStatusBarColor (1, 1, 1, 1) --> isso aqui � a parte da sele��o e descele��o
			barra.on_focus = false --> isso aqui � a parte da sele��o e descele��o
		end

		--> isso aqui � tudo da sele��o e descele��o das barras
		
		if (not info.mostrando_mouse_over) then
			if (tabela[1] == self.detalhes) then --> tabela [1] = spellid = spellid que esta na caixa da direita
				if (not barra.on_focus) then --> se a barra n�o tiver no foco
					barra.textura:SetStatusBarColor (129/255, 125/255, 69/255, 1)
					barra.on_focus = true
					if (not info.mostrando) then
						info.mostrando = barra
					end
				end
			else
				if (barra.on_focus) then
					barra.textura:SetStatusBarColor (1, 1, 1, 1) --> volta a cor antiga
					barra:SetAlpha (.9) --> volta a alfa antiga
					barra.on_focus = false
				end
			end
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_*100) --> muito mais rapido...
		end

		barra.texto_esquerdo:SetText (index..instancia.divisores.colocacao..tabela[4]) --seta o texto da esqueda
		barra.texto_direita:SetText (tabela[2] .." ".. instancia.divisores.abre .._cstr("%.1f", tabela[3]) .."%".. instancia.divisores.fecha) --seta o texto da direita
		
		barra.icone:SetTexture (tabela[5])

		barra.minha_tabela = self --> grava o jogador na barrinho... � estranho pq todas as barras v�o ter o mesmo valor do jogador
		barra.show = tabela[1] --> grava o spellid na barra
		barra:Show() --> mostra a barra

		if (self.detalhes and self.detalhes == barra.show) then
			self:MontaDetalhes (self.detalhes, barra) --> poderia deixar isso pro final e montar uma tail call??
		end
	end

	--> Alvos do interrupt
	local meus_alvos = {}
	for target_name, amount in _pairs (self.interrupt_targets) do
		meus_alvos [#meus_alvos+1] = {target_name, amount}
	end
	_table_sort (meus_alvos, _detalhes.Sort2)
	
	local amt_alvos = #meus_alvos
	if (amt_alvos < 1) then
		return
	end
	gump:JI_AtualizaContainerAlvos (amt_alvos)
	
	local max_alvos = meus_alvos[1][2]
	
	local barra
	for index, tabela in _ipairs (meus_alvos) do
	
		barra = info.barras2 [index]
		
		if (not barra) then
			barra = gump:CriaNovaBarraInfo2 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_alvos*100)
		end

		barra.texto_esquerdo:SetText (index..instancia.divisores.colocacao..tabela[1]) --seta o texto da esqueda
		barra.texto_direita:SetText (tabela[2] .." ".. instancia.divisores.abre .._cstr("%.1f", tabela[2]/meu_total*100) .. instancia.divisores.fecha) --seta o texto da direita
		
		if (barra.mouse_over) then --> atualizar o tooltip
			if (barra.isAlvo) then
				GameTooltip:Hide() 
				GameTooltip:SetOwner (barra, "ANCHOR_TOPRIGHT")
				if (not barra.minha_tabela:MontaTooltipAlvos (barra, index)) then
					return
				end
				GameTooltip:Show()
			end
		end	
		
		barra.minha_tabela = self --> grava o jogador na tabela
		barra.nome_inimigo = tabela [1] --> salva o nome do inimigo na barra --> isso � necess�rio?

		barra:Show()
	end

end


------ Detalhe Info Interrupt
function atributo_misc:MontaDetalhesInterrupt (spellid, barra)

	for _, barra in _ipairs (info.barras3) do 
		barra:Hide()
	end

	local esta_magia = self.interrupt_spells._ActorTable [spellid]
	if (not esta_magia) then
		return
	end
	
	--> icone direito superior
	local nome, _, icone = _GetSpellInfo (spellid)
	local infospell = {nome, nil, icone}

	_detalhes.janela_info.spell_icone:SetTexture (infospell[3])

	local total = self.interrupt
	local meu_total = esta_magia.counter
	
	local index = 1
	
	local data = {}	
	
	local barras = info.barras3
	local instancia = info.instancia
	
	local habilidades_alvos = {}
	for spellid, amt in pairs (esta_magia.interrompeu_oque) do 
		habilidades_alvos [#habilidades_alvos+1] = {spellid, amt}
	end
	_table_sort (habilidades_alvos, _detalhes.Sort2)
	local max_ = habilidades_alvos[1][2]
	
	local barra
	for index, tabela in _ipairs (habilidades_alvos) do
		barra = barras [index]

		if (not barra) then --> se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo3 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1) --> isso aqui � a parte da sele��o e descele��o
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_*100) --> muito mais rapido...
		end
		
		local nome, _, icone = _GetSpellInfo (tabela[1])

		barra.texto_esquerdo:SetText (index..instancia.divisores.colocacao..nome) --seta o texto da esqueda
		barra.texto_direita:SetText (tabela[2] .." ".. instancia.divisores.abre .._cstr("%.1f", tabela[2]/total*100) .."%".. instancia.divisores.fecha) --seta o texto da direita
		
		barra.icone:SetTexture (icone)

		barra:Show() --> mostra a barra
		
		if (index == 15) then 
			break
		end
	end
	
end


function atributo_misc:MontaTooltipAlvos (esta_barra, index)
	
	local inimigo = esta_barra.nome_inimigo
	
	local container
	if (info.instancia.sub_atributo == 3) then --interrupt
		container = self.interrupt_spells._ActorTable
	end
	
	local habilidades = {}
	local total = self.interrupt
	
	for spellid, tabela in _pairs (container) do
		--> tabela = classe_damage_habilidade
		local alvos = tabela.targets
		for target_name, amount in _ipairs (alvos) do
			--> tabela = classe_target
			if (target_name == inimigo) then
				habilidades [#habilidades+1] = {spellid, amount}
			end
		end
	end
	
	table.sort (habilidades, _detalhes.Sort2)
	
	GameTooltip:AddLine (index..". "..inimigo)
	GameTooltip:AddLine (Loc ["STRING_SPELL_INTERRUPTED"] .. ":") 
	GameTooltip:AddLine (" ")
	
	for index, tabela in _ipairs (habilidades) do
		local nome, rank, icone = _GetSpellInfo (tabela[1])
		if (index < 8) then
			GameTooltip:AddDoubleLine (index..". |T"..icone..":0|t "..nome, tabela[2].." (".._cstr("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine (index..". "..nome, tabela[2].." (".._cstr("%.1f", tabela[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
		end
	end
	
	return true
	
end

--controla se o dps do jogador esta travado ou destravado
function atributo_misc:Iniciar (iniciar)
	return false --retorna se o dps esta aberto ou fechado para este jogador
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a funcao de abreviacao
		function atributo_misc:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions [_detalhes.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions [_detalhes.tooltip.abbreviation]
			TooltipMaximizedMethod = _detalhes.tooltip.maximize_method
			headerColor = _detalhes.tooltip.header_text_color
		end
		

	local sub_list = {"cc_break", "ress", "interrupt", "cooldowns_defensive", "dispell", "dead"}

	--> subtract total from a combat table
		function atributo_misc:subtract_total (combat_table)
			for _, sub_attribute in _ipairs (sub_list) do 
				if (self [sub_attribute]) then
					combat_table.totals [class_type][sub_attribute] = combat_table.totals [class_type][sub_attribute] - self [sub_attribute]
					if (self.grupo) then
						combat_table.totals_grupo [class_type][sub_attribute] = combat_table.totals_grupo [class_type][sub_attribute] - self [sub_attribute]
					end
				end
			end
		end
		function atributo_misc:add_total (combat_table)
			for _, sub_attribute in _ipairs (sub_list) do 
				if (self [sub_attribute]) then
					combat_table.totals [class_type][sub_attribute] = combat_table.totals [class_type][sub_attribute] + self [sub_attribute]
					if (self.grupo) then
						combat_table.totals_grupo [class_type][sub_attribute] = combat_table.totals_grupo [class_type][sub_attribute] + self [sub_attribute]
					end
				end
			end
		end

local refresh_alvos = function (container1, container2)
	for target_name, amount in _pairs (container2) do
		container1 [target_name] = container1 [target_name] or 0
	end
end
local refresh_habilidades = function (container1, container2)
	for spellid, habilidade in _pairs (container2._ActorTable) do 
		local habilidade_shadow = container1:PegaHabilidade (spellid, true, nil, true)
		refresh_alvos (habilidade_shadow.targets , habilidade.targets)
	end
end

function atributo_misc:r_onlyrefresh_shadow (actor)

	local overall_misc = _detalhes.tabela_overall [4]
	local shadow = overall_misc._ActorTable [overall_misc._NameIndexTable [actor.nome]]

	if (not actor.nome) then
		actor.nome = "unknown"
	end
	
	if (not shadow) then 
		shadow = overall_misc:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
		
		shadow.classe = actor.classe
		shadow.spec = actor.spec
		shadow.grupo = actor.grupo
		shadow.pvp = actor.pvp
		shadow.isTank = actor.isTank
		shadow.boss = actor.boss
		shadow.boss_fight_component = actor.boss_fight_component
		shadow.fight_component = actor.fight_component
		
	end

	_detalhes.refresh:r_atributo_misc (actor, shadow)

	--> spell cast
	if (actor.spell_cast) then
		if (not shadow.spell_cast) then
			shadow.spell_cast = {}
		end
		for spellid, _ in _pairs (actor.spell_cast) do
			shadow.spell_cast [spellid] = shadow.spell_cast [spellid] or 0
		end
	end
	
	--> cc done
		if (actor.cc_done) then
			refresh_alvos (shadow.cc_done_targets, actor.cc_done_targets)
			refresh_habilidades (shadow.cc_done_spells, actor.cc_done_spells)
		end	
	
	--> cooldowns
		if (actor.cooldowns_defensive) then
			refresh_alvos (shadow.cooldowns_defensive_targets, actor.cooldowns_defensive_targets)
			refresh_habilidades (shadow.cooldowns_defensive_spells, actor.cooldowns_defensive_spells)
		end
		
	--> buff uptime
		if (actor.buff_uptime) then
			refresh_alvos (shadow.buff_uptime_targets, actor.buff_uptime_targets)
			refresh_habilidades (shadow.buff_uptime_spells, actor.buff_uptime_spells)
		end
		
	--> debuff uptime
		if (actor.debuff_uptime) then
			refresh_habilidades (shadow.debuff_uptime_spells, actor.debuff_uptime_spells)
			if (actor.boss_debuff) then
				--
			else
				refresh_alvos (shadow.debuff_uptime_targets, actor.debuff_uptime_targets)
			end			
			
		end
		
	--> interrupt
		if (actor.interrupt) then
			refresh_alvos (shadow.interrupt_targets, actor.interrupt_targets)
			refresh_habilidades (shadow.interrupt_spells, actor.interrupt_spells)
			for spellid, habilidade in _pairs (actor.interrupt_spells._ActorTable) do 
				local habilidade_shadow = shadow.interrupt_spells:PegaHabilidade (spellid, true, nil, true)
				habilidade_shadow.interrompeu_oque = habilidade_shadow.interrompeu_oque or {}
			end
		end

	--> ress
		if (actor.ress) then
			refresh_alvos (shadow.ress_targets, actor.ress_targets)
			refresh_habilidades (shadow.ress_spells, actor.ress_spells)
		end

	--> dispell
		if (actor.dispell) then
			refresh_alvos (shadow.dispell_targets, actor.dispell_targets)
			refresh_habilidades (shadow.dispell_spells, actor.dispell_spells)
			for spellid, habilidade in _pairs (actor.dispell_spells._ActorTable) do 
				local habilidade_shadow = shadow.dispell_spells:PegaHabilidade (spellid, true, nil, true)
				habilidade_shadow.dispell_oque = habilidade_shadow.dispell_oque or {}
			end
		end
		
	--> cc break
		if (actor.cc_break) then
			refresh_alvos (shadow.cc_break_targets, actor.cc_break_targets)
			refresh_habilidades (shadow.cc_break_spells, actor.cc_break_spells)
			for spellid, habilidade in _pairs (actor.cc_break_spells._ActorTable) do 
				local habilidade_shadow = shadow.cc_break_spells:PegaHabilidade (spellid, true, nil, true)
				habilidade_shadow.cc_break_oque = habilidade_shadow.cc_break_oque or {}
			end
		end

	return shadow

end

local somar_keys = function (habilidade, habilidade_tabela1)
	for key, value in _pairs (habilidade) do 
		if (_type (value) == "number") then
			if (key ~= "id" and key ~= "spellschool") then
				habilidade_tabela1 [key] = (habilidade_tabela1 [key] or 0) + value
			end
		end
	end
end
local somar_alvos = function (container1, container2)
	for target_name, amount in _pairs (container2) do
		container1 [target_name] = (container1 [target_name] or 0) + amount
	end
end
local somar_habilidades = function (container1, container2)
	for spellid, habilidade in _pairs (container2._ActorTable) do
		local habilidade_tabela1 = container1:PegaHabilidade (spellid, true, nil, false)
		somar_alvos (habilidade_tabela1.targets, habilidade.targets)
		somar_keys (habilidade, habilidade_tabela1)
	end
end

function atributo_misc:r_connect_shadow (actor, no_refresh, combat_object)

	local host_combat = combat_object or _detalhes.tabela_overall

	--> criar uma shadow desse ator se ainda n�o tiver uma
	local overall_misc = host_combat [4]
	local shadow = overall_misc._ActorTable [overall_misc._NameIndexTable [actor.nome]]

	if (not actor.nome) then
		actor.nome = "unknown"
	end
	
	if (not shadow) then 
		shadow = overall_misc:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
		
		shadow.classe = actor.classe
		shadow.spec = actor.spec
		shadow.grupo = actor.grupo
		shadow.pvp = actor.pvp
		shadow.isTank = actor.isTank
		shadow.boss = actor.boss
		shadow.boss_fight_component = actor.boss_fight_component
		shadow.fight_component = actor.fight_component
		
	end

	--> aplica a meta e indexes
	if (not no_refresh) then
		_detalhes.refresh:r_atributo_misc (actor, shadow)
	end
	
	--> pets (add unique pet names)
	for _, petName in _ipairs (actor.pets) do
		DetailsFramework.table.addunique (shadow.pets, petName)
	end

	if (actor.spell_cast) then
		if (not shadow.spell_cast) then
			shadow.spell_cast = {}
		end
		
		for spellid, amount in _pairs (actor.spell_cast) do
			shadow.spell_cast [spellid] = (shadow.spell_cast [spellid] or 0) + amount
		end
	end
	
	if (actor.cc_done) then
		if (not shadow.cc_done_targets) then
			shadow.cc_done = _detalhes:GetOrderNumber()
			shadow.cc_done_targets = {}
			shadow.cc_done_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
	
		shadow.cc_done = shadow.cc_done + actor.cc_done
		
		somar_alvos (shadow.cc_done_targets, actor.cc_done_targets)
		somar_habilidades (shadow.cc_done_spells, actor.cc_done_spells)
	end
	
	if (actor.cooldowns_defensive) then
		if (not shadow.cooldowns_defensive_targets) then
			shadow.cooldowns_defensive =  _detalhes:GetOrderNumber (actor.nome)
			shadow.cooldowns_defensive_targets = {}
			shadow.cooldowns_defensive_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
	
		shadow.cooldowns_defensive = shadow.cooldowns_defensive + actor.cooldowns_defensive
		host_combat.totals[4].cooldowns_defensive = host_combat.totals[4].cooldowns_defensive + actor.cooldowns_defensive
		if (actor.grupo) then
			host_combat.totals_grupo[4].cooldowns_defensive = host_combat.totals_grupo[4].cooldowns_defensive + actor.cooldowns_defensive
		end
		
		somar_alvos (shadow.cooldowns_defensive_targets, actor.cooldowns_defensive_targets)
		somar_habilidades (shadow.cooldowns_defensive_spells, actor.cooldowns_defensive_spells)
	end

	if (actor.buff_uptime) then
		if (not shadow.buff_uptime_targets) then
			shadow.buff_uptime = 0
			shadow.buff_uptime_targets = {}
			shadow.buff_uptime_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end

		shadow.buff_uptime = shadow.buff_uptime + actor.buff_uptime
		somar_alvos (shadow.buff_uptime_targets, actor.buff_uptime_targets)
		somar_habilidades (shadow.buff_uptime_spells, actor.buff_uptime_spells)
	end
	

	if (actor.debuff_uptime) then
		if (not shadow.debuff_uptime_targets) then
			shadow.debuff_uptime = 0
			if (actor.boss_debuff) then
				shadow.debuff_uptime_targets = {}
				shadow.boss_debuff = true
				shadow.damage_twin = actor.damage_twin
				shadow.spellschool = actor.spellschool
				shadow.damage_spellid = actor.damage_spellid
				shadow.debuff_uptime = 0
			else
				shadow.debuff_uptime_targets = {}
			end
			shadow.debuff_uptime_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
	
		shadow.debuff_uptime = shadow.debuff_uptime + actor.debuff_uptime

		for target_name, amount in _pairs (actor.debuff_uptime_targets) do
			if (_type (amount) == "table") then --> boss debuff
				local t = shadow.debuff_uptime_targets [target_name]
				if (not t) then
					shadow.debuff_uptime_targets [target_name] = atributo_misc:CreateBuffTargetObject()
					t = shadow.debuff_uptime_targets [target_name]
				end
				t.uptime = t.uptime + amount.uptime
				t.activedamt = t.activedamt + amount.activedamt
				t.refreshamt = t.refreshamt + amount.refreshamt
				t.appliedamt = t.appliedamt + amount.appliedamt
			else
				shadow.debuff_uptime_targets [target_name] = (shadow.debuff_uptime_targets [target_name] or 0) + amount
			end
		end

		somar_habilidades (shadow.debuff_uptime_spells, actor.debuff_uptime_spells)
	end
		
	--> interrupt
	if (actor.interrupt) then
		if (not shadow.interrupt_targets) then
			shadow.interrupt = 0
			shadow.interrupt_targets = {}
			shadow.interrupt_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS) --> cria o container das habilidades usadas para interromper
			shadow.interrompeu_oque = {}
		end
	
		shadow.interrupt = shadow.interrupt + actor.interrupt
		host_combat.totals[4].interrupt = host_combat.totals[4].interrupt + actor.interrupt
		if (actor.grupo) then
			host_combat.totals_grupo[4].interrupt = host_combat.totals_grupo[4].interrupt + actor.interrupt
		end
	
		somar_alvos (shadow.interrupt_targets, actor.interrupt_targets)
		somar_habilidades (shadow.interrupt_spells, actor.interrupt_spells)
		
		for spellid, habilidade in _pairs (actor.interrupt_spells._ActorTable) do 
			local habilidade_shadow = shadow.interrupt_spells:PegaHabilidade (spellid, true, nil, true)
			
			habilidade_shadow.interrompeu_oque = habilidade_shadow.interrompeu_oque or {}
			
			for _spellid, amount in _pairs (habilidade.interrompeu_oque) do
				habilidade_shadow.interrompeu_oque [_spellid] = (habilidade_shadow.interrompeu_oque [_spellid] or 0) + amount
			end
		end
		for spellid, amount in _pairs (actor.interrompeu_oque) do 
			shadow.interrompeu_oque [spellid] = (shadow.interrompeu_oque [spellid] or 0) + amount
		end
	end

	--> ress
	if (actor.ress) then
		if (not shadow.ress_targets) then
			shadow.ress = 0
			shadow.ress_targets = {}
			shadow.ress_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		
		shadow.ress = shadow.ress + actor.ress
		host_combat.totals[4].ress = host_combat.totals[4].ress + actor.ress
		if (actor.grupo) then
			host_combat.totals_grupo[4].ress = host_combat.totals_grupo[4].ress + actor.ress
		end
		
		somar_alvos (shadow.ress_targets, actor.ress_targets)
		somar_habilidades (shadow.ress_spells, actor.ress_spells)
	end

	--> dispell
	if (actor.dispell) then
		if (not shadow.dispell_targets) then
			shadow.dispell = 0
			shadow.dispell_targets = {}
			shadow.dispell_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
			shadow.dispell_oque = {}
		end
	
		shadow.dispell = shadow.dispell + actor.dispell
		host_combat.totals[4].dispell = host_combat.totals[4].dispell + actor.dispell
		if (actor.grupo) then
			host_combat.totals_grupo[4].dispell = host_combat.totals_grupo[4].dispell + actor.dispell
		end
		
		somar_alvos (shadow.dispell_targets, actor.dispell_targets)
		somar_habilidades (shadow.dispell_spells, actor.dispell_spells)

		for spellid, habilidade in _pairs (actor.dispell_spells._ActorTable) do 
			local habilidade_shadow = shadow.dispell_spells:PegaHabilidade (spellid, true, nil, true)
			habilidade_shadow.dispell_oque = habilidade_shadow.dispell_oque or {}
			for _spellid, amount in _pairs (habilidade.dispell_oque) do
				habilidade_shadow.dispell_oque [_spellid] = (habilidade_shadow.dispell_oque [_spellid] or 0) + amount
			end
		end
		
		for spellid, amount in _pairs (actor.dispell_oque) do 
			shadow.dispell_oque [spellid] = (shadow.dispell_oque [spellid] or 0) + amount
		end
	end
	
	if (actor.cc_break) then
		if (not shadow.cc_break) then
			shadow.cc_break = 0
			shadow.cc_break_targets = {}
			shadow.cc_break_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS) --> cria o container das habilidades usadas para interromper
			shadow.cc_break_oque = {}
		end

		shadow.cc_break = shadow.cc_break + actor.cc_break
		host_combat.totals[4].cc_break = host_combat.totals[4].cc_break + actor.cc_break
		if (actor.grupo) then
			host_combat.totals_grupo[4].cc_break = host_combat.totals_grupo[4].cc_break + actor.cc_break
		end
		
		somar_alvos (shadow.cc_break_targets, actor.cc_break_targets)
		somar_habilidades (shadow.cc_break_spells, actor.cc_break_spells)
		
		for spellid, habilidade in _pairs (actor.cc_break_spells._ActorTable) do 
			local habilidade_shadow = shadow.cc_break_spells:PegaHabilidade (spellid, true, nil, true)
			habilidade_shadow.cc_break_oque = habilidade_shadow.cc_break_oque or {}
			for _spellid, amount in _pairs (habilidade.cc_break_oque) do
				habilidade_shadow.cc_break_oque [_spellid] = (habilidade_shadow.cc_break_oque [_spellid] or 0) + amount
			end
		end
		for spellid, amount in _pairs (actor.cc_break_oque) do
			shadow.cc_break_oque [spellid] = (shadow.cc_break_oque [spellid] or 0) + amount
		end
	end

	return shadow

end

function atributo_misc:ColetarLixo (lastevent)
	return _detalhes:ColetarLixo (class_type, lastevent)
end

function _detalhes.refresh:r_atributo_misc (este_jogador, shadow)
	_setmetatable (este_jogador, _detalhes.atributo_misc)
	este_jogador.__index = _detalhes.atributo_misc
	
	--> refresh spell cast
	if (este_jogador.spell_cast) then
		if (shadow and not shadow.spell_cast) then
			shadow.spell_cast = {}
		end
	end
	
	--> refresh cc done
	if (este_jogador.cc_done) then
		if (shadow and not shadow.cc_done_targets) then
			shadow.cc_done = 0
			shadow.cc_done_targets = {}
			shadow.cc_done_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.cc_done_spells, shadow and shadow.cc_done_spells)
	end	
	
	--> refresh interrupts
	if (este_jogador.interrupt_targets) then
		if (shadow and not shadow.interrupt_targets) then
			shadow.interrupt = 0
			shadow.interrupt_targets = {}
			shadow.interrupt_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
			shadow.interrompeu_oque = {}
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.interrupt_spells, shadow and shadow.interrupt_spells)
	end
	
	--> refresh buff uptime
	if (este_jogador.buff_uptime_targets) then
		if (shadow and not shadow.buff_uptime_targets) then
			shadow.buff_uptime = 0
			shadow.buff_uptime_targets = {}
			shadow.buff_uptime_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.buff_uptime_spells, shadow and shadow.buff_uptime_spells)
	end
	
	--> refresh buff uptime
	if (este_jogador.debuff_uptime_targets) then
		if (shadow and not shadow.debuff_uptime_targets) then
			shadow.debuff_uptime = 0
			if (este_jogador.boss_debuff) then
				shadow.debuff_uptime_targets = {}
				shadow.boss_debuff = true
				shadow.damage_twin = este_jogador.damage_twin
				shadow.spellschool = este_jogador.spellschool
				shadow.damage_spellid = este_jogador.damage_spellid
				shadow.debuff_uptime = 0
			else
				shadow.debuff_uptime_targets = {}
			end
			shadow.debuff_uptime_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.debuff_uptime_spells, shadow and shadow.debuff_uptime_spells)
	end
	
	--> refresh cooldowns defensive
	if (este_jogador.cooldowns_defensive_targets) then
		if (shadow and not shadow.cooldowns_defensive_targets) then
			shadow.cooldowns_defensive = 0
			shadow.cooldowns_defensive_targets = {}
			shadow.cooldowns_defensive_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.cooldowns_defensive_spells, shadow and shadow.cooldowns_defensive_spells)
	end
	
	--> refresh ressers
	if (este_jogador.ress_targets) then
		if (shadow and not shadow.ress_targets) then
			shadow.ress = 0
			shadow.ress_targets = {}
			shadow.ress_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.ress_spells, shadow and shadow.ress_spells)
	end
	
	--> refresh dispells
	if (este_jogador.dispell_targets) then
		if (shadow and not shadow.dispell_targets) then
			shadow.dispell = 0
			shadow.dispell_targets = {}
			shadow.dispell_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS) --> cria o container das habilidades usadas para interromper
			shadow.dispell_oque = {}
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.dispell_spells, shadow and shadow.dispell_spells)
	end
	
	--> refresh cc_breaks
	if (este_jogador.cc_break_targets) then
		if (shadow and not shadow.cc_break) then
			shadow.cc_break = 0
			shadow.cc_break_targets = {}
			shadow.cc_break_spells = container_habilidades:NovoContainer (_detalhes.container_type.CONTAINER_MISC_CLASS)
			shadow.cc_break_oque = {}
		end
		_detalhes.refresh:r_container_habilidades (este_jogador.cc_break_spells, shadow and shadow.cc_break_spells)
	end
end

function _detalhes.clear:c_atributo_misc (este_jogador)

	este_jogador.__index = nil
	este_jogador.shadow = nil
	este_jogador.links = nil
	este_jogador.minha_barra = nil
	
	if (este_jogador.cc_done_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.cc_done_spells)
	end
	
	if (este_jogador.interrupt_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.interrupt_spells)
	end
	
	if (este_jogador.cooldowns_defensive_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.cooldowns_defensive_spells)
	end
	
	if (este_jogador.buff_uptime_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.buff_uptime_spells)
	end
	
	if (este_jogador.debuff_uptime_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.debuff_uptime_spells)
	end
	
	if (este_jogador.ress_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.ress_spells)
	end
	
	if (este_jogador.cc_break_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.cc_break_spells)
	end
	
	if (este_jogador.dispell_targets) then
		_detalhes.clear:c_container_habilidades (este_jogador.dispell_spells)
	end
	
end

atributo_misc.__add = function (tabela1, tabela2)

	if (tabela2.spell_cast) then
		for spellid, amount in _pairs (tabela2.spell_cast) do
			tabela1.spell_cast [spellid] = (tabela1.spell_cast [spellid] or 0) + amount
		end
	end

	if (tabela2.cc_done) then
		tabela1.cc_done = tabela1.cc_done + tabela2.cc_done
		
		for target_name, amount in _pairs (tabela2.cc_done_targets) do
			tabela1.cc_done_targets [target_name] = (tabela1.cc_done_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cc_done_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cc_done_spells:PegaHabilidade (spellid, true, nil, false)
			
			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end
	end

	if (tabela2.interrupt) then
	
		if (not tabela1.interrupt) then
			tabela1.interrupt = 0
			tabela1.interrupt_targets = {}
			tabela1.interrupt_spells = container_habilidades:NovoContainer (container_misc)
			tabela1.interrompeu_oque = {}
		end
	
		--> total de interrupts
			tabela1.interrupt = tabela1.interrupt + tabela2.interrupt
		--> soma o interrompeu o que
			for spellid, amount in _pairs (tabela2.interrompeu_oque) do 
				tabela1.interrompeu_oque [spellid] = (tabela1.interrompeu_oque [spellid] or 0) + amount
			end
		--> soma os containers de alvos
			for target_name, amount in _pairs (tabela2.interrupt_targets) do
				tabela1.interrupt_targets [target_name] = (tabela1.interrupt_targets [target_name] or 0) + amount
			end
		
		--> soma o container de habilidades
			for spellid, habilidade in _pairs (tabela2.interrupt_spells._ActorTable) do 
				local habilidade_tabela1 = tabela1.interrupt_spells:PegaHabilidade (spellid, true, nil, false)
				
				habilidade_tabela1.interrompeu_oque = habilidade_tabela1.interrompeu_oque or {}
				for _spellid, amount in _pairs (habilidade.interrompeu_oque) do
					habilidade_tabela1.interrompeu_oque [_spellid] = (habilidade_tabela1.interrompeu_oque [_spellid] or 0) + amount
				end
				
				for target_name, amount in _pairs (habilidade.targets) do
					habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
				end
				
				somar_keys (habilidade, habilidade_tabela1)
			end

	end
	
	if (tabela2.buff_uptime) then
		if (not tabela1.buff_uptime) then
			tabela1.buff_uptime = 0
			tabela1.buff_uptime_targets = {}
			tabela1.buff_uptime_spells = container_habilidades:NovoContainer (container_misc)
		end
	
		tabela1.buff_uptime = tabela1.buff_uptime + tabela2.buff_uptime
		
		for target_name, amount in _pairs (tabela2.buff_uptime_targets) do
			tabela1.buff_uptime_targets [target_name] = (tabela1.buff_uptime_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.buff_uptime_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.buff_uptime_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end

			somar_keys (habilidade, habilidade_tabela1)
		end
	end
	
	if (tabela2.debuff_uptime) then
		if (not tabela1.debuff_uptime) then
			if (tabela2.boss_debuff) then
				tabela1.debuff_uptime_targets = {}
				tabela1.boss_debuff = true
				tabela1.damage_twin = tabela2.damage_twin
				tabela1.spellschool = tabela2.spellschool
				tabela1.damage_spellid = tabela2.damage_spellid
			else
				tabela1.debuff_uptime_targets = {}
			end
			
			tabela1.debuff_uptime = 0
			tabela1.debuff_uptime_spells = container_habilidades:NovoContainer (container_misc)
		end

		tabela1.debuff_uptime = tabela1.debuff_uptime + tabela2.debuff_uptime
		
		for target_name, amount in _pairs (tabela2.debuff_uptime_targets) do
			if (_type (amount) == "table") then --> boss debuff
				local t = tabela1.debuff_uptime_targets [target_name]
				if (not t) then
					tabela1.debuff_uptime_targets [target_name] = atributo_misc:CreateBuffTargetObject()
					t = tabela1.debuff_uptime_targets [target_name]
				end
				t.uptime = t.uptime + amount.uptime
				t.activedamt = t.activedamt + amount.activedamt
				t.refreshamt = t.refreshamt + amount.refreshamt
				t.appliedamt = t.appliedamt + amount.appliedamt
			else
				tabela1.debuff_uptime_targets [target_name] = (tabela1.debuff_uptime_targets [target_name] or 0) + amount
			end
		end
		
		for spellid, habilidade in _pairs (tabela2.debuff_uptime_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.debuff_uptime_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end	
	end
	
	if (tabela2.cooldowns_defensive) then
		if (not tabela1.cooldowns_defensive) then
			tabela1.cooldowns_defensive = 0
			tabela1.cooldowns_defensive_targets = {}
			tabela1.cooldowns_defensive_spells = container_habilidades:NovoContainer (container_misc)
		end
	
		tabela1.cooldowns_defensive = tabela1.cooldowns_defensive + tabela2.cooldowns_defensive
		
		for target_name, amount in _pairs (tabela2.cooldowns_defensive_targets) do 
			tabela1.cooldowns_defensive_targets [target_name] = (tabela1.cooldowns_defensive_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cooldowns_defensive_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cooldowns_defensive_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end	
	end
	
	if (tabela2.ress) then
		if (not tabela1.ress) then
			tabela1.ress = 0
			tabela1.ress_targets = {}
			tabela1.ress_spells = container_habilidades:NovoContainer (container_misc)
		end
	
		tabela1.ress = tabela1.ress + tabela2.ress
		
		for target_name, amount in _pairs (tabela2.ress_targets) do
			tabela1.ress_targets [target_name] = (tabela1.ress_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.ress_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.ress_spells:PegaHabilidade (spellid, true, nil, false)
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end
	end
	
	if (tabela2.dispell) then
	
		if (not tabela1.dispell) then
			tabela1.dispell = 0
			tabela1.dispell_targets = {}
			tabela1.dispell_spells = container_habilidades:NovoContainer (container_misc)
			tabela1.dispell_oque = {}
		end
	
		tabela1.dispell = tabela1.dispell + tabela2.dispell
		
		for target_name, amount in _pairs (tabela2.dispell_targets) do
			tabela1.dispell_targets [target_name] = (tabela1.dispell_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.dispell_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.dispell_spells:PegaHabilidade (spellid, true, nil, false)
			
			habilidade_tabela1.dispell_oque = habilidade_tabela1.dispell_oque or {}

			for _spellid, amount in _pairs (habilidade.dispell_oque) do
				habilidade_tabela1.dispell_oque [_spellid] = (habilidade_tabela1.dispell_oque [_spellid] or 0) + amount
			end
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end
		
		for spellid, amount in _pairs (tabela2.dispell_oque) do 
			tabela1.dispell_oque [spellid] = (tabela1.dispell_oque [spellid] or 0) + amount
		end
		
	end
	
	if (tabela2.cc_break) then
	
		if (not tabela1.cc_break) then
			tabela1.cc_break = 0
			tabela1.cc_break_targets = {}
			tabela1.cc_break_spells = container_habilidades:NovoContainer (container_misc)
			tabela1.cc_break_oque = {}
		end
	
		tabela1.cc_break = tabela1.cc_break + tabela2.cc_break
		
		for target_name, amount in _pairs (tabela2.cc_break_targets) do 
			tabela1.cc_break_targets [target_name] = (tabela1.cc_break_targets [target_name] or 0) + amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cc_break_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cc_break_spells:PegaHabilidade (spellid, true, nil, false)
			
			habilidade_tabela1.cc_break_oque = habilidade_tabela1.cc_break_oque or {}
			for _spellid, amount in _pairs (habilidade.cc_break_oque) do
				habilidade_tabela1.cc_break_oque [_spellid] = (habilidade_tabela1.cc_break_oque [_spellid] or 0) + amount
			end
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			
			somar_keys (habilidade, habilidade_tabela1)
		end

		for spellid, amount in _pairs (tabela2.cc_break_oque) do
			tabela1.cc_break_oque [spellid] = (tabela1.cc_break_oque [spellid] or 0) + amount
		end
	end
	
	return tabela1
end

local subtrair_keys = function (habilidade, habilidade_tabela1)
	for key, value in _pairs (habilidade) do 
		if (_type (value) == "number") then
			if (key ~= "id" and key ~= "spellschool") then
				habilidade_tabela1 [key] = (habilidade_tabela1 [key] or 0) - value
			end
		end
	end
end

atributo_misc.__sub = function (tabela1, tabela2)

	if (tabela2.spell_cast) then
		for spellid, amount in _pairs (tabela2.spell_cast) do
			tabela1.spell_cast [spellid] = (tabela1.spell_cast [spellid] or 0) - amount
		end
	end

	if (tabela2.cc_done) then
		tabela1.cc_done = tabela1.cc_done - tabela2.cc_done
		
		for target_name, amount in _pairs (tabela2.cc_done_targets) do
			tabela1.cc_done_targets [target_name] = (tabela1.cc_done_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cc_done_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cc_done_spells:PegaHabilidade (spellid, true, nil, false)
			
			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end
	end

	if (tabela2.interrupt) then
		--> total de interrupts
			tabela1.interrupt = tabela1.interrupt - tabela2.interrupt
		--> soma o interrompeu o que
			for spellid, amount in _pairs (tabela2.interrompeu_oque) do 
				tabela1.interrompeu_oque [spellid] = (tabela1.interrompeu_oque [spellid] or 0) - amount
			end
		--> soma os containers de alvos
			for target_name, amount in _pairs (tabela2.interrupt_targets) do
				tabela1.interrupt_targets [target_name] = (tabela1.interrupt_targets [target_name] or 0) - amount
			end
		
		--> soma o container de habilidades
			for spellid, habilidade in _pairs (tabela2.interrupt_spells._ActorTable) do 
				local habilidade_tabela1 = tabela1.interrupt_spells:PegaHabilidade (spellid, true, nil, false)
				
				habilidade_tabela1.interrompeu_oque = habilidade_tabela1.interrompeu_oque or {}
				for _spellid, amount in _pairs (habilidade.interrompeu_oque) do
					habilidade_tabela1.interrompeu_oque [_spellid] = (habilidade_tabela1.interrompeu_oque [_spellid] or 0) - amount
				end
				
				for target_name, amount in _pairs (habilidade.targets) do
					habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
				end
				
				subtrair_keys (habilidade, habilidade_tabela1)
			end
	end
	
	if (tabela2.buff_uptime) then	
		tabela1.buff_uptime = tabela1.buff_uptime - tabela2.buff_uptime
		
		for target_name, amount in _pairs (tabela2.buff_uptime_targets) do
			tabela1.buff_uptime_targets [target_name] = (tabela1.buff_uptime_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.buff_uptime_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.buff_uptime_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end

			subtrair_keys (habilidade, habilidade_tabela1)
		end		
	end
	
	if (tabela2.debuff_uptime) then	
		tabela1.debuff_uptime = tabela1.debuff_uptime - tabela2.debuff_uptime
		
		for target_name, amount in _pairs (tabela2.debuff_uptime_targets) do
			if (_type (amount) == "table") then --> boss debuff
				local t = tabela1.debuff_uptime_targets [target_name]
				if (not t) then
					tabela1.debuff_uptime_targets [target_name] = atributo_misc:CreateBuffTargetObject()
					t = tabela1.debuff_uptime_targets [target_name]
				end
				t.uptime = t.uptime - amount.uptime
				t.activedamt = t.activedamt - amount.activedamt
				t.refreshamt = t.refreshamt - amount.refreshamt
				t.appliedamt = t.appliedamt - amount.appliedamt
			else
				tabela2.debuff_uptime_targets [target_name] = (tabela2.debuff_uptime_targets [target_name] or 0) - amount
			end
		end
		
		for spellid, habilidade in _pairs (tabela2.debuff_uptime_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.debuff_uptime_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end	
	end
	
	if (tabela2.cooldowns_defensive) then	
		tabela1.cooldowns_defensive = tabela1.cooldowns_defensive - tabela2.cooldowns_defensive
		
		for target_name, amount in _pairs (tabela2.cooldowns_defensive_targets) do 
			tabela1.cooldowns_defensive_targets [target_name] = (tabela1.cooldowns_defensive_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cooldowns_defensive_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cooldowns_defensive_spells:PegaHabilidade (spellid, true, nil, false)

			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end			
	end
	
	if (tabela2.ress) then
		tabela1.ress = tabela1.ress - tabela2.ress
		
		for target_name, amount in _pairs (tabela2.ress_targets) do
			tabela1.ress_targets [target_name] = (tabela1.ress_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.ress_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.ress_spells:PegaHabilidade (spellid, true, nil, false)
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end
	end
	
	if (tabela2.dispell) then
		tabela1.dispell = tabela1.dispell - tabela2.dispell
		
		for target_name, amount in _pairs (tabela2.dispell_targets) do
			tabela1.dispell_targets [target_name] = (tabela1.dispell_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.dispell_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.dispell_spells:PegaHabilidade (spellid, true, nil, false)
			
			habilidade_tabela1.dispell_oque = habilidade_tabela1.dispell_oque or {}

			for _spellid, amount in _pairs (habilidade.dispell_oque) do
				habilidade_tabela1.dispell_oque [_spellid] = (habilidade_tabela1.dispell_oque [_spellid] or 0) - amount
			end
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end
		
		for spellid, amount in _pairs (tabela2.dispell_oque) do 
			tabela1.dispell_oque [spellid] = (tabela1.dispell_oque [spellid] or 0) - amount
		end
	end
	
	if (tabela2.cc_break) then
	
		tabela1.cc_break = tabela1.cc_break - tabela2.cc_break
		
		for target_name, amount in _pairs (tabela2.cc_break_targets) do 
			tabela1.cc_break_targets [target_name] = (tabela1.cc_break_targets [target_name] or 0) - amount
		end
		
		for spellid, habilidade in _pairs (tabela2.cc_break_spells._ActorTable) do 
			local habilidade_tabela1 = tabela1.cc_break_spells:PegaHabilidade (spellid, true, nil, false)
			
			habilidade_tabela1.cc_break_oque = habilidade_tabela1.cc_break_oque or {}
			for _spellid, amount in _pairs (habilidade.cc_break_oque) do
				habilidade_tabela1.cc_break_oque [_spellid] = (habilidade_tabela1.cc_break_oque [_spellid] or 0) - amount
			end
			
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) - amount
			end
			
			subtrair_keys (habilidade, habilidade_tabela1)
		end

		for spellid, amount in _pairs (tabela2.cc_break_oque) do
			tabela1.cc_break_oque [spellid] = (tabela1.cc_break_oque [spellid] or 0) - amount
		end
	end
	
	return tabela1
end

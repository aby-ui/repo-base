
--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _setmetatable = setmetatable
local _pairs = pairs
local _ipairs = ipairs
local _unpack = unpack
local _type = type
local _table_sort = table.sort
local _cstr = string.format
local _table_insert = table.insert
local _bit_band = bit.band
local _math_min = math.min
local _math_ceil = math.ceil
--api locals
local GetSpellInfo = GetSpellInfo
local _GetSpellInfo = _detalhes.getspellinfo
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup
local _UnitName = UnitName
local _GetNumGroupMembers = GetNumGroupMembers

local _string_replace = _detalhes.string.replace --details api

local _detalhes = 		_G._detalhes
local _

local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ( "Details" )

local gump = 			_detalhes.gump

local alvo_da_habilidade = 	_detalhes.alvo_da_habilidade
local container_habilidades = 	_detalhes.container_habilidades
local container_combatentes =	_detalhes.container_combatentes
local atributo_heal =		_detalhes.atributo_heal
local habilidade_cura = 		_detalhes.habilidade_cura

local container_playernpc = _detalhes.container_type.CONTAINER_PLAYERNPC
local container_heal = _detalhes.container_type.CONTAINER_HEAL_CLASS
local container_heal_target = _detalhes.container_type.CONTAINER_HEALTARGET_CLASS

local modo_ALONE = _detalhes.modos.alone
local modo_GROUP = _detalhes.modos.group
local modo_ALL = _detalhes.modos.all

local class_type = _detalhes.atributos.cura

local DATA_TYPE_START = _detalhes._detalhes_props.DATA_TYPE_START
local DATA_TYPE_END = _detalhes._detalhes_props.DATA_TYPE_END

local div_abre = _detalhes.divisores.abre
local div_fecha = _detalhes.divisores.fecha
local div_lugar = _detalhes.divisores.colocacao

local ToKFunctions = _detalhes.ToKFunctions
local SelectedToKFunction = ToKFunctions [1]
local UsingCustomRightText = false
local UsingCustomLeftText = false

local FormatTooltipNumber = ToKFunctions [8]
local TooltipMaximizedMethod = 1

local headerColor = "yellow"

local info = _detalhes.janela_info
local keyName

function atributo_heal:NovaTabela (serial, nome, link)

	local alphabetical = _detalhes:GetOrderNumber (nome)

	--> constructor
	local _new_healActor = {

		tipo = class_type, --> atributo 2 = cura
		
		total = alphabetical,
		totalover = alphabetical,
		totalabsorb = alphabetical,
		totaldenied = alphabetical,
		custom = 0,
		
		total_without_pet = alphabetical,
		totalover_without_pet = alphabetical,
		
		healing_taken = alphabetical, --> total de cura que este jogador recebeu
		healing_from = {}, --> armazena os nomes que deram cura neste jogador

		iniciar_hps = false,  --> dps_started
		last_event = 0,
		on_hold = false,
		delay = 0,
		last_value = nil, --> ultimo valor que este jogador teve, salvo quando a barra dele � atualizada
		last_hps = 0, --> cura por segundo

		end_time = nil,
		start_time = 0,

		pets = {}, --> nome j� formatado: pet nome <owner nome>
		
		heal_enemy = {}, --> quando o jogador cura um inimigo
		heal_enemy_amt = 0,

		--container armazenar� os IDs das habilidades usadas por este jogador
		spells = container_habilidades:NovoContainer (container_heal),
		--container armazenar� os seriais dos alvos que o player aplicou dano
		targets = {},
		targets_overheal = {},
		targets_absorbs = {}
	}
	
	_setmetatable (_new_healActor, atributo_heal)

	return _new_healActor
end


function _detalhes.SortGroupHeal (container, keyName2)
	keyName = keyName2
	return _table_sort (container, _detalhes.SortKeyGroupHeal)
end

function _detalhes.SortKeyGroupHeal (table1, table2)
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

function _detalhes.SortKeySimpleHeal (table1, table2)
	return table1 [keyName] > table2 [keyName]
end

function _detalhes:ContainerSortHeal (container, amount, keyName2)
	keyName = keyName2
	_table_sort (container, _detalhes.SortKeySimpleHeal)

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

function atributo_heal:ContainerRefreshHps (container, combat_time)

	local total = 0
	
	if (_detalhes.time_type == 2 or not _detalhes:CaptureGet ("heal")) then
		for _, actor in _ipairs (container) do
			if (actor.grupo) then
				actor.last_hps = actor.total / combat_time
			else
				actor.last_hps = actor.total / actor:Tempo()
			end
			total = total + actor.last_hps
		end
	else
		for _, actor in _ipairs (container) do
			actor.last_hps = actor.total / actor:Tempo()
			total = total + actor.last_hps
		end
	end
	
	return total
end

function atributo_heal:ReportSingleDamagePreventedLine (actor, instancia)
	local barra = instancia.barras [actor.minha_barra]

	local reportar = {"Details!: " .. actor.nome .. " - " .. Loc ["STRING_ATTRIBUTE_HEAL_PREVENT"]}
	for i = 2, GameCooltip:GetNumLines()-2 do 
		local texto_left, texto_right = GameCooltip:GetText (i)
		if (texto_left and texto_right) then 
			texto_left = texto_left:gsub (("|T(.*)|t "), "")
			reportar [#reportar+1] = ""..texto_left.." "..texto_right..""
		end
	end

	return _detalhes:Reportar (reportar, {_no_current = true, _no_inverse = true, _custom = true})
end

function atributo_heal:RefreshWindow (instancia, tabela_do_combate, forcar, exportar)
	
	local showing = tabela_do_combate [class_type] --> o que esta sendo mostrado -> [1] - dano [2] - cura

	--> n�o h� barras para mostrar -- not have something to show
	if (#showing._ActorTable < 1) then --> n�o h� barras para mostrar
		--> colocado isso recentemente para fazer as barras de dano sumirem na troca de atributo
		return _detalhes:EsconderBarrasNaoUsadas (instancia, showing), "", 0, 0
	end

	--> total
	local total = 0 
	--> top actor #1
	instancia.top = 0
	
	local using_cache = false
	
	local sub_atributo = instancia.sub_atributo --> o que esta sendo mostrado nesta inst�ncia
	local conteudo = showing._ActorTable
	local amount = #conteudo
	local modo = instancia.modo
	
	--> pega qual a sub key que ser� usada
	if (exportar) then
	
		if (_type (exportar) == "boolean") then 
			if (sub_atributo == 1) then --> healing DONE
				keyName = "total"
			elseif (sub_atributo == 2) then --> HPS
				keyName = "last_hps"
			elseif (sub_atributo == 3) then --> overheal
				keyName = "totalover"
			elseif (sub_atributo == 4) then --> healing take
				keyName = "healing_taken"
			elseif (sub_atributo == 5) then --> enemy heal
				keyName = "heal_enemy_amt"
			elseif (sub_atributo == 6) then --> absorbs
				keyName = "totalabsorb"
			elseif (sub_atributo == 7) then --> heal absorb
				keyName = "totaldenied"
			end
		else
			keyName = exportar.key
			modo = exportar.modo
		end
	elseif (instancia.atributo == 5) then --> custom
		keyName = "custom"
		total = tabela_do_combate.totals [instancia.customName]
	else	
		if (sub_atributo == 1) then --> healing DONE
			keyName = "total"
		elseif (sub_atributo == 2) then --> HPS
			keyName = "last_hps"
		elseif (sub_atributo == 3) then --> overheal
			keyName = "totalover"
		elseif (sub_atributo == 4) then --> healing take
			keyName = "healing_taken"
		elseif (sub_atributo == 5) then --> enemy heal
			keyName = "heal_enemy_amt"
		elseif (sub_atributo == 6) then --> absorbs
			keyName = "totalabsorb"
		elseif (sub_atributo == 7) then --> heal absorb
			keyName = "totaldenied"
		end
	end

	if (instancia.atributo == 5) then --> custom
		--> faz o sort da categoria e retorna o amount corrigido
		amount = _detalhes:ContainerSortHeal (conteudo, amount, keyName)
		
		--> grava o total
		instancia.top = conteudo[1][keyName]
	
	elseif (instancia.modo == modo_ALL or sub_atributo == 5 or sub_atributo == 7) then --> mostrando ALL

		amount = _detalhes:ContainerSortHeal (conteudo, amount, keyName)

		if (sub_atributo == 2) then --hps
			local combat_time = instancia.showing:GetCombatTime()
			total = atributo_heal:ContainerRefreshHps (conteudo, combat_time)
		else
			--> pega o total ja aplicado na tabela do combate
			total = tabela_do_combate.totals [class_type]
		end

		--> grava o total
		instancia.top = conteudo[1][keyName]
		
	elseif (instancia.modo == modo_GROUP) then --> mostrando GROUP
	
		if (_detalhes.in_combat and instancia.segmento == 0 and not exportar) then
			using_cache = true
		end
		
		if (using_cache) then
		
			conteudo = _detalhes.cache_healing_group

			if (sub_atributo == 2) then --> hps
				local combat_time = instancia.showing:GetCombatTime()
				atributo_heal:ContainerRefreshHps (conteudo, combat_time)
			end
			
			if (#conteudo < 1) then
				return _detalhes:EsconderBarrasNaoUsadas (instancia, showing), "", 0, 0
			end
		
			_detalhes:ContainerSortHeal (conteudo, nil, keyName)
		
			if (conteudo[1][keyName] < 1) then
				amount = 0
			else
				instancia.top = conteudo[1][keyName]
				amount = #conteudo
			end
			
			for i = 1, amount do 
				total = total + conteudo[i][keyName]
			end
			
		else
			if (sub_atributo == 2) then --> hps
				local combat_time = instancia.showing:GetCombatTime()
				atributo_heal:ContainerRefreshHps (conteudo, combat_time)
			end

			_detalhes.SortGroupHeal (conteudo, keyName)
		end
		--
		if (not using_cache) then
			for index, player in _ipairs (conteudo) do
				if (player.grupo) then --> � um player e esta em grupo
					if (player[keyName] < 1) then --> dano menor que 1, interromper o loop
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
	--> se for cache n�o precisa remapear
	showing:remapear()
	
	if (exportar) then 
		return total, keyName, instancia.top, amount
	end
	
	if (amount < 1) then --> n�o h� barras para mostrar
		instancia:EsconderScrollBar()
		return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
	end
	
	--estra mostrando ALL ent�o posso seguir o padr�o correto? primeiro, atualiza a scroll bar...
	instancia:AtualizarScrollBar (amount)
	
	--depois faz a atualiza��o normal dele atrav�s dos iterators
	local qual_barra = 1
	local barras_container = instancia.barras --> evita buscar N vezes a key .barras dentro da inst�ncia
	local percentage_type = instancia.row_info.percent_type
	local bars_show_data = instancia.row_info.textR_show_data
	local bars_brackets = instancia:GetBarBracket()
	local bars_separator = instancia:GetBarSeparator()
	local baseframe = instancia.baseframe
	
	local use_animations = _detalhes.is_using_row_animations and (not baseframe.isStretching and not forcar and not baseframe.isResizing)
 	
	if (total == 0) then
		total = 0.00000001
	end	
	
	local myPos
	local following = instancia.following.enabled
	
	if (following) then
		if (using_cache) then
			local pname = _detalhes.playername
			for i, actor in _ipairs (conteudo) do
				if (actor.nome == pname) then
					myPos = i
					break
				end
			end
		else
			myPos = showing._NameIndexTable [_detalhes.playername]
		end
	end
	
	local combat_time = instancia.showing:GetCombatTime()
	UsingCustomLeftText = instancia.row_info.textL_enable_custom_text
	UsingCustomRightText = instancia.row_info.textR_enable_custom_text
	
	local use_total_bar = false
	if (instancia.total_bar.enabled) then
		use_total_bar = true
		
		if (instancia.total_bar.only_in_group and (not _IsInGroup() and not _IsInRaid())) then
			use_total_bar = false
		end
	end
	
	if (instancia.bars_sort_direction == 1) then --top to bottom
		
		if (use_total_bar and instancia.barraS[1] == 1) then
		
			qual_barra = 2
			local iter_last = instancia.barraS[2]
			if (iter_last == instancia.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = barras_container [1]
			row1.minha_tabela = nil
			row1.texto_esquerdo:SetText (Loc ["STRING_TOTAL"])
			row1.texto_direita:SetText (_detalhes:ToK2 (total) .. " (" .. _detalhes:ToK (total / combat_time) .. ")")
			
			row1:SetValue (100)
			local r, g, b = unpack (instancia.total_bar.color)
			row1.textura:SetVertexColor (r, g, b)
			
			row1.icone_classe:SetTexture (instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord (0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade (row1, "out")
			
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], iter_last-1, 1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
				
				conteudo[myPos]:AtualizaBarra (instancia, barras_container, qual_barra, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
				qual_barra = qual_barra+1
			else
			
				for i = instancia.barraS[1], iter_last, 1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
			end

		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], instancia.barraS[2]-1, 1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
				
				conteudo[myPos]:AtualizaBarra (instancia, barras_container, qual_barra, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
				qual_barra = qual_barra+1
			else
				for i = instancia.barraS[1], instancia.barraS[2], 1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
			end
		end
		
	elseif (instancia.bars_sort_direction == 2) then --bottom to top
	
		if (use_total_bar and instancia.barraS[1] == 1) then
		
			qual_barra = 2
			local iter_last = instancia.barraS[2]
			if (iter_last == instancia.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = barras_container [1]
			row1.minha_tabela = nil
			row1.texto_esquerdo:SetText (Loc ["STRING_TOTAL"])
			row1.texto_direita:SetText (_detalhes:ToK2 (total) .. " (" .. _detalhes:ToK (total / combat_time) .. ")")
			
			row1:SetValue (100)
			local r, g, b = unpack (instancia.total_bar.color)
			row1.textura:SetVertexColor (r, g, b)
			
			row1.icone_classe:SetTexture (instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord (0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade (row1, "out")
			
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = iter_last-1, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
				
				conteudo[myPos]:AtualizaBarra (instancia, barras_container, qual_barra, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
				qual_barra = qual_barra+1
			else
				for i = iter_last, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
			end
		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[2]-1, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
				
				conteudo[myPos]:AtualizaBarra (instancia, barras_container, qual_barra, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
				qual_barra = qual_barra+1
			else
				for i = instancia.barraS[2], instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					if (conteudo[i]) then
						conteudo[i]:AtualizaBarra (instancia, barras_container, qual_barra, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) 
						qual_barra = qual_barra+1
					end
				end
			end
		end
		
	end

	if (use_animations) then
		instancia:fazer_animacoes (qual_barra - 1)
	end
	
	if (instancia.atributo == 5) then --> custom
		--> zerar o .custom dos Actors
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

	-- showing.need_refresh = false
	return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
	
end

local actor_class_color_r, actor_class_color_g, actor_class_color_b

--function atributo_heal:AtualizaBarra (instancia, qual_barra, lugar, total, sub_atributo, forcar)
function atributo_heal:AtualizaBarra (instancia, barras_container, qual_barra, lugar, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)

	local esta_barra = instancia.barras[qual_barra] --> pega a refer�ncia da barra na janela
	
	if (not esta_barra) then
		print ("DEBUG: problema com <instancia.esta_barra> "..qual_barra.." "..lugar)
		return
	end
	
	local tabela_anterior = esta_barra.minha_tabela
	
	esta_barra.minha_tabela = self --grava uma refer�ncia dessa classe de dano na barra
	self.minha_barra = esta_barra --> salva uma refer�ncia da barra no objeto do jogador
	
	esta_barra.colocacao = lugar --> salva na barra qual a coloca��o dela.
	self.colocacao = lugar --> salva qual a coloca��o do jogador no objeto dele
	
	local healing_total = self.total --> total de dano que este jogador deu
	local hps
	
	--local porcentagem = self [keyName] / total * 100
	local porcentagem
	local esta_porcentagem
	
	if (percentage_type == 1) then
		porcentagem = _cstr ("%.1f", self [keyName] / total * 100)
	elseif (percentage_type == 2) then
		porcentagem = _cstr ("%.1f", self [keyName] / instancia.top * 100)
	end

	if ((_detalhes.time_type == 2 and self.grupo) or (not _detalhes:CaptureGet ("heal") and not _detalhes:CaptureGet ("aura")) or instancia.segmento == -1) then
		if (instancia.segmento == -1 and combat_time == 0) then
			local p = _detalhes.tabela_vigente (2, self.nome)
			if (p) then
				local t = p:Tempo()
				hps = healing_total / t
				self.last_hps = hps
			else
				hps = healing_total / combat_time
				self.last_hps = hps
			end
		else
			hps = healing_total / combat_time
			self.last_hps = hps
		end
	else -- /dump _detalhes:GetCombat (2)(1, "Ditador").on_hold
		if (not self.on_hold) then
			hps = healing_total/self:Tempo() --calcula o dps deste objeto
			self.last_hps = hps --salva o dps dele
		else
			hps = self.last_hps
			
			if (hps == 0) then --> n�o calculou o dps dele ainda mas entrou em standby
				hps = healing_total/self:Tempo()
				self.last_hps = hps
			end
		end
	end
	
	-- >>>>>>>>>>>>>>> texto da direita
	if (instancia.atributo == 5) then --> custom
		esta_barra.texto_direita:SetText (_detalhes:ToK (self.custom) .. " (" .. porcentagem .. "%)")
		esta_porcentagem = _math_floor ((self.custom/instancia.top) * 100)
		
	else	
		if (sub_atributo == 1) then --> mostrando healing done
		
			hps = _math_floor (hps)
			local formated_heal = SelectedToKFunction (_, healing_total)
			local formated_hps = SelectedToKFunction (_, hps)
			esta_barra.ps_text = formated_hps
		
			if (not bars_show_data [1]) then
				formated_heal = ""
			end
			if (not bars_show_data [2]) then
				formated_hps = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
			
			local rightText = formated_heal .. bars_brackets[1] .. formated_hps .. bars_separator .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_heal, formated_hps, porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			esta_porcentagem = _math_floor ((healing_total/instancia.top) * 100)
			
		elseif (sub_atributo == 2) then --> mostrando hps
		
			hps = _math_floor (hps)
			local formated_heal = SelectedToKFunction (_, healing_total)
			local formated_hps = SelectedToKFunction (_, hps)
			esta_barra.ps_text = formated_hps
			
			if (not bars_show_data [1]) then
				formated_hps = ""
			end
			if (not bars_show_data [2]) then
				formated_heal = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
			
			local rightText = formated_hps .. bars_brackets[1] .. formated_heal .. bars_separator .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_hps, formated_heal, porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			
			esta_porcentagem = _math_floor ((hps/instancia.top) * 100)
			
		elseif (sub_atributo == 3) then --> mostrando overall
		
			local formated_overheal = SelectedToKFunction (_, self.totalover)
			
			local percent = self.totalover / (self.totalover + self.total) * 100
			local overheal_percent = _cstr ("%.1f", percent)
			
			local rr, gg, bb = _detalhes:percent_color (percent, true)
			rr, gg, bb = _detalhes:hex (_math_floor (rr*255)), _detalhes:hex (_math_floor (gg*255)), _detalhes:hex (_math_floor (bb*255))
			overheal_percent = "|cFF" .. rr .. gg .. bb .. overheal_percent .. "|r"
			
			if (not bars_show_data [1]) then
				formated_overheal = ""
			end
			if (not bars_show_data [3]) then
				overheal_percent = ""
			else
				overheal_percent = overheal_percent .. "%"
			end
			
			local rightText = formated_overheal .. bars_brackets[1] .. overheal_percent .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_overheal, "", overheal_percent, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			
			esta_porcentagem = _math_floor ((self.totalover/instancia.top) * 100)
			
		elseif (sub_atributo == 4) then --> mostrando healing taken
		
			local formated_healtaken = SelectedToKFunction (_, self.healing_taken)
			
			if (not bars_show_data [1]) then
				formated_healtaken = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
			
			local rightText = formated_healtaken .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_healtaken, "", porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			
			esta_porcentagem = _math_floor ((self.healing_taken/instancia.top) * 100)
		
		elseif (sub_atributo == 5) then --> mostrando enemy heal
		
			local formated_enemyheal = SelectedToKFunction (_, self.heal_enemy_amt)
		
			if (not bars_show_data [1]) then
				formated_enemyheal = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
		
			local rightText = formated_enemyheal .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_enemyheal, "", porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			esta_porcentagem = _math_floor ((self.heal_enemy_amt/instancia.top) * 100)
			
		elseif (sub_atributo == 6) then --> mostrando damage prevented
		
			local formated_absorbs = SelectedToKFunction (_, self.totalabsorb)
		
			if (not bars_show_data [1]) then
				formated_absorbs = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
			
			local rightText = formated_absorbs .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_absorbs, "", porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			esta_porcentagem = _math_floor ((self.totalabsorb/instancia.top) * 100)
			
		elseif (sub_atributo == 7) then --> mostrando cura negada
			
			local formated_absorbs = SelectedToKFunction (_, self.totaldenied)
		
			if (not bars_show_data [1]) then
				formated_absorbs = ""
			end
			if (not bars_show_data [3]) then
				porcentagem = ""
			else
				porcentagem = porcentagem .. "%"
			end
			
			local rightText = formated_absorbs .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
			if (UsingCustomRightText) then
				esta_barra.texto_direita:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_absorbs, "", porcentagem, self, instancia.showing, instancia, rightText))
			else
				esta_barra.texto_direita:SetText (rightText)
			end
			esta_porcentagem = _math_floor ((self.totaldenied/instancia.top) * 100)
			
		end
	end
	
	if (esta_barra.mouse_over and not instancia.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip (qual_barra, esta_barra, instancia)
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, qual_barra, barras_container, use_animations)	
end

function atributo_heal:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, qual_barra, barras_container, use_animations)
	
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
		
			esta_barra:SetValue (esta_porcentagem)
			if (use_animations) then
				esta_barra.animacao_fim = esta_porcentagem
			else
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

function atributo_heal:RefreshBarra (esta_barra, instancia, from_resize)
	
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

function _detalhes:CloseShields (combat)

	local escudos = _detalhes.escudos
	local container = combat[2]
	local time = time()
	local parser = _detalhes.parser
	local GetSpellInfo = GetSpellInfo --n�o colocar no cache de spells
	
	for alvo_name, spellid_table in _pairs (escudos) do
	
		local tgt = container:PegarCombatente (_, alvo_name)
		if (tgt) then
		
			for spellid, owner_table in _pairs (spellid_table) do
		
				local spellname = GetSpellInfo (spellid)
				for owner, amount in _pairs (owner_table) do
				
					if (amount > 0) then
						local obj = container:PegarCombatente (_, owner)
						if (obj) then
							parser:heal ("SPELL_AURA_REMOVED", time, obj.serial, owner, obj.flag_original, tgt.serial, alvo_name, tgt.flag_original, nil, spellid, spellname, nil, 0, _math_ceil (amount), 0, 0, nil, true)
						end
					end
					
				end
			end
			
		end
		
	end

	--escudo [alvo_name] [spellid] [who_name]
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------


---------> TOOLTIPS BIFURCA��O ~tooltip
function atributo_heal:ToolTip (instancia, numero, barra, keydown)
	--> seria possivel aqui colocar o icone da classe dele?

	if (instancia.atributo == 5) then --> custom
		return self:TooltipForCustom (barra)
	else
		--GameTooltip:ClearLines()
		--GameTooltip:AddLine (barra.colocacao..". "..self.nome)
		if (instancia.sub_atributo <= 3) then --> healing done, HPS or Overheal
			return self:ToolTip_HealingDone (instancia, numero, barra, keydown)
		elseif (instancia.sub_atributo == 6) then --> healing done, HPS or Overheal	
			return self:ToolTip_HealingDone (instancia, numero, barra, keydown)
		elseif (instancia.sub_atributo == 4) then --> healing taken
			return self:ToolTip_HealingTaken (instancia, numero, barra, keydown)
		elseif (instancia.sub_atributo == 7) then --> heal denied
			return self:ToolTip_HealingDenied (instancia, numero, barra, keydown)
		end
	end
end
--> tooltip locals
local r, g, b
local barAlha = .6

---------> HEAL DENIED
function atributo_heal:ToolTip_HealingDenied (instancia, numero, barra, keydown)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end

	local container = instancia.showing [2]
	local totalDenied = self.totaldenied
	
	local spellList = {} --spells the player used to deny heal
	local targetList = {} --all players affected
	local spellsDenied = {} --all spells which had heal denied
	local healersDenied = {} --heal denied on healers 
	
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	for spellID, spell in _pairs (self.spells._ActorTable) do 
		if (spell.totaldenied > 0 and spell.heal_denied) then
			--my spells which denied heal
			tinsert (spellList, {spell, spell.totaldenied}) 
			
			--players affected
			for playerName, amount in _pairs (spell.targets) do
				targetList [playerName] = (targetList [playerName] or 0) + amount
			end
			
			--spells with heal denied
			for spellID, amount in _pairs (spell.heal_denied) do 
				spellsDenied [spellID] = (spellsDenied [spellID] or 0) + amount
			end
			
			--healers denied
			for healerName, amount in _pairs (spell.heal_denied_healers) do 
				healersDenied [healerName] = (healersDenied [healerName] or 0) + amount
			end
		end
	end

	--Spells 
		table.sort (spellList, _detalhes.Sort2)
		_detalhes:AddTooltipSpellHeaderText ("Spells", headerColor, #spellList, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		
		local ismaximized = false
		if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
			ismaximized = true
		else
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		end

		local tooltip_max_abilities = _detalhes.tooltip.tooltip_max_abilities
		if (ismaximized) then
			tooltip_max_abilities = 99
		end
		
		for i = 1, _math_min (tooltip_max_abilities, #spellList) do
			local spellObject, spellTotal = unpack (spellList [i])
		
			if (spellTotal < 1) then
				break
			end

			local spellName, _, spellIcon = _GetSpellInfo (spellObject.id)
			
			GameCooltip:AddLine (spellName .. ": ", FormatTooltipNumber (_, spellTotal) .. " (" .. _cstr ("%.1f", spellTotal / totalDenied) .."%)")

			GameCooltip:AddIcon (spellIcon, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
		end

	-- follow esta bugado com este display

	--Target Players
		local playerSorted = {}
		for playerName, amount in _pairs (targetList) do
			tinsert (playerSorted, {playerName, amount})
		end
		table.sort (playerSorted, _detalhes.Sort2)
		_detalhes:AddTooltipSpellHeaderText ("Targets", headerColor, #playerSorted, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)	
	
		local ismaximized = false
		if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
			ismaximized = true
		else
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		end
		
		local tooltip_max_abilities2 = _detalhes.tooltip.tooltip_max_targets
		if (ismaximized) then
			tooltip_max_abilities2 = 99
		end
		
		for i = 1, _math_min (tooltip_max_abilities2, #playerSorted) do
		
			local playerName, amountDenied = unpack (playerSorted [i])
			
			GameCooltip:AddLine (playerName .. ": ", FormatTooltipNumber (_, amountDenied) .." (" .. _cstr ("%.1f", amountDenied / totalDenied * 100) .. "%)")
			_detalhes:AddTooltipBackgroundStatusbar()
			
			local targetActor = container:PegarCombatente (nil, playerName) or instancia.showing [1]:PegarCombatente (nil, playerName)
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

	-- Spells Affected
		local spellsSorted = {}
		for spellID, amount in _pairs (spellsDenied) do
			tinsert (spellsSorted, {spellID, amount})
		end
		table.sort (spellsSorted, _detalhes.Sort2)
		_detalhes:AddTooltipSpellHeaderText ("Spells Affected", headerColor, #spellsSorted, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
		local ismaximized = false
		local tooltip_max_abilities3 = _detalhes.tooltip.tooltip_max_targets
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			tooltip_max_abilities3 = 99
			ismaximized = true
		end
	
		for i = 1, _math_min (tooltip_max_abilities3, #spellsSorted) do
	
			local spellID, spellTotal = unpack (spellsSorted [i])
		
			if (spellTotal < 1) then
				break
			end

			local spellName, _, spellIcon = _GetSpellInfo (spellID)
			
			GameCooltip:AddLine (spellName .. ": ", FormatTooltipNumber (_, spellTotal) .. " (" .. _cstr ("%.1f", spellTotal / totalDenied) .."%)")

			GameCooltip:AddIcon (spellIcon, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
			_detalhes:AddTooltipBackgroundStatusbar()
	
		end
		
	--healers denied
	
		_detalhes:AddTooltipSpellHeaderText ("Healers", headerColor, #spellsSorted, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	
		local healersSorted = {}
		for healerName, amount in _pairs (healersDenied) do
			tinsert (healersSorted, {healerName, amount})
		end
		table.sort (healersSorted, _detalhes.Sort2)
			
		for i = 1, #healersSorted do
			local playerName, amountDenied = unpack (healersSorted [i])
			
			GameCooltip:AddLine (playerName .. ": ", FormatTooltipNumber (_, amountDenied) .." (" .. _cstr ("%.1f", amountDenied / totalDenied * 100) .. "%)")
			_detalhes:AddTooltipBackgroundStatusbar()
			
			local targetActor = container:PegarCombatente (nil, playerName) or instancia.showing [1]:PegarCombatente (nil, playerName)
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
	
	return true
end

---------> HEALING TAKEN
function atributo_heal:ToolTip_HealingTaken (instancia, numero, barra, keydown)

	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end

	local curadores = self.healing_from
	local total_curado = self.healing_taken
	
	local tabela_do_combate = instancia.showing
	local showing = tabela_do_combate [class_type] --> o que esta sendo mostrado -> [1] - dano [2] - cura --> pega o container com ._NameIndexTable ._ActorTable
	
	local meus_curadores = {}
	
	for nome, _ in _pairs (curadores) do --> agressores seria a lista de nomes
		local este_curador = showing._ActorTable[showing._NameIndexTable[nome]]
		if (este_curador) then --> checagem por causa do total e do garbage collector que n�o limpa os nomes que deram dano
			local alvos = este_curador.targets
			local este_alvo = alvos [self.nome]
			if (este_alvo and este_alvo > 0) then
				meus_curadores [#meus_curadores+1] = {nome, este_alvo, este_curador.classe}
			end
		end
	end
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_FROM"], headerColor, #meus_curadores, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)

	local ismaximized = false
	
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end

	_table_sort (meus_curadores, function (a, b) return a[2] > b[2] end)
	local max = #meus_curadores
	if (max > 9) then
		max = 9
	end
	
	if (ismaximized) then
		max = 99
	end
	
	local lineHeight = _detalhes.tooltip.line_height

	for i = 1, _math_min (max, #meus_curadores) do
		GameCooltip:AddLine (_detalhes:GetOnlyName (meus_curadores[i][1]), FormatTooltipNumber (_, meus_curadores[i][2]).." (".._cstr ("%.1f", (meus_curadores[i][2]/total_curado) * 100).."%)")
		local classe = meus_curadores[i][3]
		if (not classe) then
			classe = "UNKNOW"
		end
		if (classe == "UNKNOW") then
			GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, lineHeight, lineHeight, .25, .5, 0, 1)
		else
			local specID = _detalhes:GetSpec (meus_curadores[i][1])
			if (specID) then
				local texture, l, r, t, b = _detalhes:GetSpecIcon (specID, false)
				GameCooltip:AddIcon (texture, 1, 1, lineHeight, lineHeight, l, r, t, b)
			else
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, lineHeight, lineHeight, _unpack (_detalhes.class_coords [classe]))
			end
		end
		
		_detalhes:AddTooltipBackgroundStatusbar (false, meus_curadores[i][2] / meus_curadores[1][2] * 100)
		
	end
	
	return true
end

---------> HEALING DONE / HPS / OVERHEAL
local background_heal_vs_absorbs = {value = 100, color = {1, 1, 0, .25}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar4_glass]]}

function atributo_heal:ToolTip_HealingDone (instancia, numero, barra, keydown)
	
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end
	
	local ActorHealingTable = {}
	local ActorHealingTargets = {}
	local ActorSkillsContainer = self.spells._ActorTable
	
	local actor_key, skill_key = "total", "total"
	if (instancia.sub_atributo == 3) then
		actor_key, skill_key = "totalover", "overheal"
	elseif (instancia.sub_atributo == 6) then
		actor_key, skill_key = "totalabsorb", "totalabsorb"
	end
	
	local meu_tempo
	if (_detalhes.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()
	elseif (_detalhes.time_type == 2) then
		meu_tempo = instancia.showing:GetCombatTime()
	end
	
	local ActorTotal = self [actor_key]
	
	--add actor spells
	for _spellid, _skill in _pairs (ActorSkillsContainer) do 
		local SkillName, _, SkillIcon = _GetSpellInfo (_spellid)
		if (_skill [skill_key] > 0 or _skill.anti_heal) then
			_table_insert (ActorHealingTable, {
				_spellid, 
				_skill [skill_key], 
				_skill [skill_key]/ActorTotal*100, 
				{SkillName, nil, SkillIcon}, 
				_skill [skill_key]/meu_tempo, 
				_skill.total,
				false,
				_skill.anti_heal,
			})
		end
	end
	
	--add actor pets
	for petIndex, petName in _ipairs (self:Pets()) do
		local petActor = instancia.showing[class_type]:PegarCombatente (nil, petName)
		if (petActor) then
			for _spellid, _skill in _pairs (petActor:GetActorSpells()) do
				if (_skill [skill_key] > 0) then
					local SkillName, _, SkillIcon = _GetSpellInfo (_spellid)
					local petName = petName:gsub ((" <.*"), "")
					ActorHealingTable [#ActorHealingTable+1] = {
						_spellid, 
						_skill [skill_key], 
						_skill [skill_key]/ActorTotal*100, 
						{SkillName, nil, SkillIcon}, 
						_skill [skill_key]/meu_tempo, 
						_skill.total, 
						petName
					}
				end
			end
		end
	end
	
	_table_sort (ActorHealingTable, _detalhes.Sort2)
	
	--> TOP Curados
	ActorSkillsContainer = self.targets
	for target_name, amount in _pairs (ActorSkillsContainer) do
		if (amount > 0) then
			_table_insert (ActorHealingTargets, {target_name, amount, amount / ActorTotal * 100})
		end
	end
	_table_sort (ActorHealingTargets, _detalhes.Sort2)

	--> Mostra as habilidades no tooltip
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, #ActorHealingTable, [[Interface\RAIDFRAME\Raid-Icon-Rez]], 0.109375, 0.890625, 0.0625, 0.90625)

	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end

	local tooltip_max_abilities = _detalhes.tooltip.tooltip_max_abilities
	if (instancia.sub_atributo == 3 or instancia.sub_atributo == 2) then
		tooltip_max_abilities = 9
	end

	if (ismaximized) then
		tooltip_max_abilities = 99
	end
	
	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord
	
	local topAbility = ActorHealingTable [1] and ActorHealingTable [1][2] or 0
	
	for i = 1, _math_min (tooltip_max_abilities, #ActorHealingTable) do
		if (ActorHealingTable[i][2] < 1) then
			local antiHeal = ActorHealingTable[i][8]
			if (not antiHeal) then
				break
			end
		end
		
		local spellName = ActorHealingTable[i][4][1]
		
		local petName = ActorHealingTable[i][7]
		if (petName) then
			spellName = spellName .. " (|cFFCCBBBB" .. petName .. "|r)"
		end
		
		if (instancia.sub_atributo == 2) then --> hps
		
			local formatedTotal = FormatTooltipNumber (_,  _math_floor (ActorHealingTable[i][5]))
			local antiHeal = ActorHealingTable[i][8]
			if (antiHeal) then
				formatedTotal = formatedTotal .. " [|cFFFF5500" .. FormatTooltipNumber (_, _math_floor (antiHeal)) .." " .. Loc ["STRING_DAMAGE"] .."|r] "
			end
			
			GameCooltip:AddLine (spellName , formatedTotal .. " (".._cstr ("%.1f", ActorHealingTable[i][3]).."%)")
			
		elseif (instancia.sub_atributo == 3) then --> overheal
			local overheal = ActorHealingTable[i][2]
			local total = ActorHealingTable[i][6]
			local formatedTotal = FormatTooltipNumber (_,  _math_floor (ActorHealingTable[i][2]))
			
			local antiHeal = ActorHealingTable[i][8]
			if (antiHeal) then
				formatedTotal = formatedTotal .. " [|cFFFF5500" .. FormatTooltipNumber (_, _math_floor (antiHeal)) .." " .. Loc ["STRING_DAMAGE"] .."|r] "
			end
			
			GameCooltip:AddLine (spellName .." (|cFFFF3333" .. _math_floor ( (overheal / (overheal+total)) *100)  .. "%|r)", formatedTotal .. " (".._cstr ("%.1f", ActorHealingTable[i][3]).."%)")
			
		else
			local formatedTotal = FormatTooltipNumber (_, ActorHealingTable[i][2])
			local antiHeal = ActorHealingTable[i][8]
			if (antiHeal) then
				formatedTotal = formatedTotal .. " [|cFFFF5500" .. FormatTooltipNumber (_, _math_floor (antiHeal)) .." " .. Loc ["STRING_DAMAGE"] .."|r] "
			end
			GameCooltip:AddLine (spellName , formatedTotal .. " (" .. _cstr ("%.1f", ActorHealingTable[i][3]) .. "%)")
			
		end
		
		GameCooltip:AddIcon (ActorHealingTable[i][4][3], nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
		
		_detalhes:AddTooltipBackgroundStatusbar (false, ActorHealingTable[i][2] / topAbility * 100)
	end
	
	if (instancia.sub_atributo == 6) then
		GameCooltip:AddLine ("")
		GameCooltip:AddLine (Loc ["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack (self.click_to_report_color))
		GameCooltip:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
		
		GameCooltip:ShowCooltip()
	end
	
	local container = instancia.showing [2]
	local topTarget = ActorHealingTargets [1] and ActorHealingTargets [1][2] or 0
	
	if (instancia.sub_atributo == 1) then -- 1 or 2 -> healing done or hps
	
		_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_TARGETS"], headerColor, #ActorHealingTargets, [[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 0.10546875, 0.89453125, 0.05859375, 0.6796875)

		local ismaximized = false
		if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
			ismaximized = true
		else
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
			_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
		end
		
		local tooltip_max_abilities2 = _detalhes.tooltip.tooltip_max_targets
		if (ismaximized) then
			tooltip_max_abilities2 = 99
		end
		
		for i = 1, _math_min (tooltip_max_abilities2, #ActorHealingTargets) do
			if (ActorHealingTargets[i][2] < 1) then
				break
			end
			
			if (ismaximized and ActorHealingTargets[i][1]:find (_detalhes.playername)) then
				GameCooltip:AddLine (ActorHealingTargets[i][1], FormatTooltipNumber (_, ActorHealingTargets[i][2]) .." (".._cstr ("%.1f", ActorHealingTargets[i][3]).."%)", nil, "yellow")
				GameCooltip:AddStatusBar (100, 1, .5, .5, .5, .7)
			else
				GameCooltip:AddLine (ActorHealingTargets[i][1], FormatTooltipNumber (_, ActorHealingTargets[i][2]) .." (".._cstr ("%.1f", ActorHealingTargets[i][3]).."%)")
				_detalhes:AddTooltipBackgroundStatusbar (false, ActorHealingTargets[i][2] / topTarget * 100)
			end
			
			local targetActor = container:PegarCombatente (nil, ActorHealingTargets[i][1])
			
			if (targetActor) then
				local classe = targetActor.classe
				if (not classe) then
					classe = "UNKNOW"
				end
				if (classe == "UNKNOW") then
					GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, icon_size.W, icon_size.H, .25, .5, 0, 1)
				else
					GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, icon_size.W, icon_size.H, _unpack (_detalhes.class_coords [classe]))
				end
			end
		end
	end
	
	--> PETS
	local meus_pets = self.pets

	if (#meus_pets > 0 and (instancia.sub_atributo == 1 or instancia.sub_atributo == 2 or instancia.sub_atributo == 3)) then --> teve ajudantes
		
		local quantidade = {} --> armazena a quantidade de pets iguais
		local totais = {} --> armazena o dano total de cada objeto
		
		for index, nome in _ipairs (meus_pets) do
			if (not quantidade [nome]) then
				quantidade [nome] = 1
				
				local my_self = instancia.showing [class_type]:PegarCombatente (nil, nome)
				
				if (my_self) then
					local meu_tempo
					if (_detalhes.time_type == 1 or not self.grupo) then
						meu_tempo = my_self:Tempo()
					elseif (_detalhes.time_type == 2) then
						meu_tempo = instancia.showing:GetCombatTime()
					end
					
					if (instancia.sub_atributo == 3) then
						totais [#totais+1] = {nome, my_self.totalover, my_self.total_without_pet}
					else
						totais [#totais+1] = {nome, my_self.total_without_pet, my_self.total_without_pet / meu_tempo}
					end

				end
				
			else
				quantidade [nome] = quantidade [nome]+1
			end
		end
		
		local added_logo = false

		_table_sort (totais, _detalhes.Sort2)
		
		local ismaximized = false
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			ismaximized = true
		end
		
		for index, _table in _ipairs (totais) do
			
			if (_table [2] >= 1 and (index < 3 or ismaximized)) then
		
				if (not added_logo) then
					added_logo = true
					_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_PETS"], headerColor, #totais, [[Interface\COMMON\friendship-heart]], 0.21875, 0.78125, 0.09375, 0.6875)

					if (ismaximized) then
						GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_alt]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
						_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
					else
						GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_alt]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
						_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
					end
					
				end
			
				local n = _table [1]:gsub (("%s%<.*"), "")
				if (instancia.sub_atributo == 3) then --overheal
					GameCooltip:AddLine (n .. " (|cFFFF3333" .. _math_floor ( (_table [2] / (_table [2] + _table [3])) * 100)  .. "%|r):", FormatTooltipNumber (_,  _math_floor (_table [2])) .. " (" .. _math_floor ( (_table [2] / (_table [2] + _table [3])) * 100) .. "%)")
					
				elseif (instancia.sub_atributo == 2) then --hps
					GameCooltip:AddLine (n, FormatTooltipNumber (_,  _math_floor (_table [3])) .. " (" .. _math_floor (_table [2]/self.total*100) .. "%)")
				else
					GameCooltip:AddLine (n, FormatTooltipNumber (_, _table [2]) .. " (" .. _math_floor (_table [2]/self.total*100) .. "%)")
				end
				_detalhes:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, icon_size.W, icon_size.H, 0.25, 0.49609375, 0.75, 1)
			end
		end
		
	end
	
	--> ~Phases
	if (instancia.sub_atributo == 1 or instancia.sub_atributo == 2) then
		local segment = instancia:GetShowingCombat()
		if (segment and self.grupo) then
			local bossInfo = segment:GetBossInfo()
			local phasesInfo = segment:GetPhases()
			if (bossInfo and phasesInfo) then
				if (#phasesInfo > 1) then
					
					--_detalhes:AddTooltipSpellHeaderText ("Phases", headerColor, 1, [[Interface\Garrison\MobileAppIcons]], 2*130/1024, 3*130/1024, 5*130/1024, 6*130/1024)
					--_detalhes:AddTooltipSpellHeaderText ("Phases", headerColor, 1, [[Interface\Garrison\orderhall-missions-mechanic10]], 0, 1, 0, 1)
					_detalhes:AddTooltipSpellHeaderText ("Healing by Encounter Phase", headerColor, 1, [[Interface\Garrison\orderhall-missions-mechanic8]], 11/64, 53/64, 11/64, 53/64)
					--GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
					_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
					
					local playerPhases = {}
					local totalDamage = 0
					
					for phase, playersTable in pairs (phasesInfo.heal) do --each phase
					
						local allPlayers = {} --all players for this phase
						for playerName, amount in pairs (playersTable) do
							tinsert (allPlayers, {playerName, amount})
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
						
						tinsert (playerPhases, {phase, playersTable [self.nome] or 0, myRank, (playersTable [self.nome] or 0) / totalDamage * 100})
					end
					
					table.sort (playerPhases, function(a, b) return a[1] < b[1] end)
					
					for i = 1, #playerPhases do
						--[1] Phase Number [2] Amount Done [3] Rank [4] Percent
						GameCooltip:AddLine ("|cFFF0F0F0Phase|r " .. playerPhases [i][1], FormatTooltipNumber (_, playerPhases [i][2]) .. " (|cFFFFFF00#" .. playerPhases [i][3] ..  "|r, " .. _cstr ("%.1f", playerPhases [i][4]) .. "%)")
						GameCooltip:AddIcon ([[Interface\Garrison\orderhall-missions-mechanic9]], 1, 1, 14, 14, 11/64, 53/64, 11/64, 53/64)
						_detalhes:AddTooltipBackgroundStatusbar()
					end
				end
			end
		end
	end
	
	--> absorbs vs heal
	--[=[
	if (instancia.sub_atributo == 1 or instancia.sub_atributo == 2) then
		local total_healed = self.total - self.totalabsorb
		local total_previned = self.totalabsorb
		
		local healed_percentage = total_healed / self.total * 100
		local previned_percentage = total_previned / self.total * 100
		
		if (healed_percentage > 1 and previned_percentage > 1) then
			GameCooltip:AddLine (_math_floor (healed_percentage).."%", _math_floor (previned_percentage).."%")
			local r, g, b = _unpack (_detalhes.class_colors [self.classe])
			background_heal_vs_absorbs.color[1] = r
			background_heal_vs_absorbs.color[2] = g
			background_heal_vs_absorbs.color[3] = b
			background_heal_vs_absorbs.specialSpark = false
			GameCooltip:AddStatusBar (healed_percentage, 1, r, g, b, .9, false, background_heal_vs_absorbs)
			GameCooltip:AddIcon ([[Interface\ICONS\Ability_Priest_ReflectiveShield]], 1, 2, 14, 14, 0.0625, 0.9375, 0.0625, 0.9375)
			GameCooltip:AddIcon ([[Interface\ICONS\Ability_Monk_ChiWave]], 1, 1, 14, 14, 0.9375, 0.0625, 0.0625, 0.9375)
		end
		
	elseif (instancia.sub_atributo == 3) then
		local total_healed = self.total
		local total_overheal = self.totalover
		local both = total_healed + total_overheal
		
		local healed_okey = total_healed / both * 100
		local healed_disposed = total_overheal / both * 100
		
		if (healed_okey > 1 and healed_disposed > 1) then
			GameCooltip:AddLine (_math_floor (healed_okey).."%", _math_floor (healed_disposed).."%")
			background_heal_vs_absorbs.color[1] = 1
			background_heal_vs_absorbs.color[2] = 0
			background_heal_vs_absorbs.color[3] = 0
			background_heal_vs_absorbs.specialSpark = false
			GameCooltip:AddStatusBar (healed_okey, 1, 0, 1, 0, .9, false, background_heal_vs_absorbs)
			GameCooltip:AddIcon ([[Interface\Scenarios\ScenarioIcon-Check]], 1, 1, 14, 14, 0, 1, 0, 1)
			GameCooltip:AddIcon ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 1, 2, 14, 14, 1, 0, 0, 1)
		end
	end
	--]=]
	
	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------
---------- bifurca��o
function atributo_heal:MontaInfo()
	if (info.sub_atributo == 1 or info.sub_atributo == 2) then
		return self:MontaInfoHealingDone()
	elseif (info.sub_atributo == 3) then
		return self:MontaInfoOverHealing()
	elseif (info.sub_atributo == 4) then
		return self:MontaInfoHealTaken()
	end
end

function atributo_heal:MontaInfoHealTaken()

	local healing_taken = self.healing_taken
	local curandeiros = self.healing_from
	local instancia = info.instancia
	local tabela_do_combate = instancia.showing
	local showing = tabela_do_combate [class_type] --> o que esta sendo mostrado -> [1] - dano [2] - cura --> pega o container com ._NameIndexTable ._ActorTable
	local barras = info.barras1
	local meus_curandeiros = {}
	
	local este_curandeiro	
	for nome, _ in _pairs (curandeiros) do
		este_curandeiro = showing._ActorTable[showing._NameIndexTable[nome]]
		if (este_curandeiro) then
			local alvos = este_curandeiro.targets
			local este_alvo = alvos [self.nome]
			if (este_alvo) then
				meus_curandeiros [#meus_curandeiros+1] = {nome, este_alvo, este_alvo/healing_taken*100, este_curandeiro.classe}
			end
		end
	end
	
	local amt = #meus_curandeiros
	
	if (amt < 1) then
		return true
	end
	
	_table_sort (meus_curandeiros, _detalhes.Sort2)
	
	gump:JI_AtualizaContainerBarras (amt)

	local max_ = meus_curandeiros [1] and meus_curandeiros [1][2] or 0
	
	local barra
	for index, tabela in _ipairs (meus_curandeiros) do
		barra = barras [index]
		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
		end

		self:FocusLock (barra, tabela[1])
		
		--hes:UpdadeInfoBar (row, index, spellid, name, value, max, percent, icon, detalhes)
		
		local texCoords = CLASS_ICON_TCOORDS [tabela[4]]
		if (not texCoords) then
			texCoords = _detalhes.class_coords ["UNKNOW"]
		end
		
		local formated_value = SelectedToKFunction (_, _math_floor (tabela[2]))
		self:UpdadeInfoBar (barra, index, tabela[1], tabela[1], tabela[2], formated_value, max_, tabela[3], "Interface\\AddOns\\Details\\images\\classes_small", true, texCoords)
	end	
	
end

function atributo_heal:MontaInfoOverHealing()
--> pegar as habilidade de dar sort no heal
	
	local instancia = info.instancia
	local total = self.totalover
	local tabela = self.spells._ActorTable
	local minhas_curas = {}
	local barras = info.barras1

	for spellid, tabela in _pairs (tabela) do
		local nome, _, icone = _GetSpellInfo (spellid)
		_table_insert (minhas_curas, {spellid, tabela.overheal, tabela.overheal/total*100, nome, icone})
	end
	
	--> add pets
	local ActorPets = self.pets
	local class_color = "FFDDDDDD"
	for _, PetName in _ipairs (ActorPets) do
		local PetActor = instancia.showing (class_type, PetName)
		if (PetActor) then 
			local PetSkillsContainer = PetActor.spells._ActorTable
			for _spellid, _skill in _pairs (PetSkillsContainer) do --> da foreach em cada spellid do container
				local nome, _, icone = _GetSpellInfo (_spellid)
				_table_insert (minhas_curas, {_spellid, _skill.overheal, _skill.overheal/total*100, nome .. " (|c" .. class_color .. PetName:gsub ((" <.*"), "") .. "|r)", icone, PetActor})
			end
		end
	end

	_table_sort (minhas_curas, _detalhes.Sort2)

	local amt = #minhas_curas
	gump:JI_AtualizaContainerBarras (amt)

	local max_ = minhas_curas[1] and minhas_curas[1][2] or 0

	for index, tabela in _ipairs (minhas_curas) do

		local barra = barras [index]

		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
			barra.on_focus = false
		end

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
		
		local formated_value = SelectedToKFunction (_, _math_floor (tabela[2]))
		barra.texto_direita:SetText (formated_value .." (".. _cstr ("%.1f", tabela[3]) .."%)")

		barra.icone:SetTexture (tabela[5])

		barra.other_actor = tabela [6]
		barra.minha_tabela = self
		barra.show = tabela[1]
		barra:Show()

		if (self.detalhes and self.detalhes == barra.show) then
			self:MontaDetalhes (self.detalhes, barra)
		end
	end
	
	--> TOP OVERHEALED
	local jogadores_overhealed = {}
	tabela = self.targets_overheal
	local heal_container = instancia.showing[2]
	for target_name, amount in _pairs (tabela) do
		local classe = "UNKNOW"
		local actor_object = heal_container._ActorTable [heal_container._NameIndexTable [tabela.nome]]
		if (actor_object) then
			classe = actor_object.classe
		end
		_table_insert (jogadores_overhealed, {target_name, amount, amount/total*100, classe})
	end
	_table_sort (jogadores_overhealed, _detalhes.Sort2)
	
	local amt_alvos = #jogadores_overhealed
	gump:JI_AtualizaContainerAlvos (amt_alvos)
	
	local max_inimigos = jogadores_overhealed[1] and jogadores_overhealed[1][2] or 0
	
	for index, tabela in _ipairs (jogadores_overhealed) do
	
		local barra = info.barras2 [index]
		
		if (not barra) then
			barra = gump:CriaNovaBarraInfo2 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_*100)
		end
		
		barra.texto_esquerdo:SetText (index..instancia.divisores.colocacao..tabela[1]) --seta o texto da esqueda
		barra.texto_direita:SetText (_detalhes:comma_value (tabela[2]) .." ".. instancia.divisores.abre .. _cstr ("%.1f", tabela[3]) .. instancia.divisores.fecha)
		barra.texto_esquerdo:SetWidth (barra:GetWidth() - barra.texto_direita:GetStringWidth() - 30)
		
		-- icon
		barra.icone:SetTexture ([[Interface\AddOns\Details\images\classes_small]])
		
		local texCoords = _detalhes.class_coords [tabela[4]]
		if (not texCoords) then
			texCoords = _detalhes.class_coords ["UNKNOW"]
		end
		barra.icone:SetTexCoord (_unpack (texCoords))
		
		barra.minha_tabela = self
		barra.nome_inimigo = tabela [1]

		barra:Show()
	end
end

function atributo_heal:MontaInfoHealingDone()

	--> pegar as habilidade de dar sort no heal
	
	local instancia = info.instancia
	local total = self.total
	local tabela = self.spells._ActorTable
	local minhas_curas = {}
	local barras = info.barras1

	--get time type
	local meu_tempo
	if (_detalhes.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()
	elseif (_detalhes.time_type == 2) then
		meu_tempo = info.instancia.showing:GetCombatTime()
	end
	
	for spellid, tabela in _pairs (tabela) do
		local nome, rank, icone = _GetSpellInfo (spellid)
		_table_insert (minhas_curas, {
			spellid, 
			tabela.total, 
			tabela.total/total*100, 
			nome, 
			icone,
			false, --not a pet
			tabela.anti_heal,
		})
	end
	
	info:SetStatusbarText()

	--> add pets
	local ActorPets = self.pets
	--local class_color = RAID_CLASS_COLORS [self.classe] and RAID_CLASS_COLORS [self.classe].colorStr
	local class_color = "FFDDDDDD"
	for _, PetName in _ipairs (ActorPets) do
		local PetActor = instancia.showing (class_type, PetName)
		if (PetActor) then 
			local PetSkillsContainer = PetActor.spells._ActorTable
			for _spellid, _skill in _pairs (PetSkillsContainer) do --> da foreach em cada spellid do container
				local nome, _, icone = _GetSpellInfo (_spellid)
				_table_insert (minhas_curas, {
					_spellid, 
					_skill.total, 
					_skill.total/total*100, 
					nome .. " (|c" .. class_color .. PetName:gsub ((" <.*"), "") .. "|r)", 
					icone, 
					PetActor
				})
			end
		end
	end
	
	_table_sort (minhas_curas, _detalhes.Sort2)

	local amt = #minhas_curas
	gump:JI_AtualizaContainerBarras (amt)

	local max_ = minhas_curas[1] and minhas_curas[1][2] or 0
	local foundSpellDetail = false

	for index, tabela in _ipairs (minhas_curas) do

		local barra = barras [index]

		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
			barra.on_focus = false
		end

		self:FocusLock (barra, tabela[1])
		
		barra.other_actor = tabela [6]
		
		if (info.sub_atributo == 2) then
			local formated_value = SelectedToKFunction (_, _math_floor (tabela[2]/meu_tempo))
			self:UpdadeInfoBar (barra, index, tabela[1], tabela[4], tabela[2], formated_value, max_, tabela[3], tabela[5], true)
		else
			local formated_value = SelectedToKFunction (_, _math_floor (tabela[2]))
			if (tabela [7]) then
				formated_value = formated_value .. " [|cFFFF5500" .. SelectedToKFunction (_, _math_floor (tabela [7])) .." " .. Loc ["STRING_DAMAGE"] .."|r] "
			end
			self:UpdadeInfoBar (barra, index, tabela[1], tabela[4], tabela[2], formated_value, max_, tabela[3], tabela[5], true)
		end

		barra.minha_tabela = self
		barra.show = tabela[1]
		barra.spellid = self.nome
		barra:Show()

		if (self.detalhes and self.detalhes == barra.show and not foundSpellDetail) then
			self:MontaDetalhes (self.detalhes, barra)
			foundSpellDetail = true
		end
	end
	
	--> TOP CURADOS
	local meus_inimigos = {}
	tabela = self.targets
	for target_name, amount in _pairs (tabela) do
		_table_insert (meus_inimigos, {target_name, amount, amount / total*100})
	end
	_table_sort (meus_inimigos, _detalhes.Sort2)
	
	local amt_alvos = #meus_inimigos
	gump:JI_AtualizaContainerAlvos (amt_alvos)
	
	local max_inimigos = meus_inimigos[1] and meus_inimigos[1][2] or 0
	
	for index, tabela in _ipairs (meus_inimigos) do
	
		local barra = info.barras2 [index]
		
		if (not barra) then
			barra = gump:CriaNovaBarraInfo2 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_*100)
		end
		
		local target_actor = instancia.showing (2, tabela[1])
		if (target_actor) then
			target_actor:SetClassIcon (barra.icone, instancia, target_actor.classe)
		else
			barra.icone:SetTexture ([[Interface\AddOns\Details\images\classes_small_alpha]]) --CLASSE
			local texCoords = _detalhes.class_coords ["ENEMY"]
			barra.icone:SetTexCoord (_unpack (texCoords))
		end
		
		barra.texto_esquerdo:SetText (index .. ". " .. _detalhes:GetOnlyName (tabela[1]))
		barra.textura:SetStatusBarColor (1, 1, 1, 1)
		
		if (info.sub_atributo == 2) then
			barra.texto_direita:SetText (_detalhes:comma_value (_math_floor (tabela[2]/meu_tempo)) .." (" .. _cstr ("%.1f", tabela[3]) .. "%)")
		else
			barra.texto_direita:SetText (SelectedToKFunction (_, tabela[2]) .. " (" .. _cstr ("%.1f", tabela[3]) .. "%)")
		end
		
		barra.minha_tabela = self
		barra.nome_inimigo = tabela [1]
		
		-- no lugar do spell id colocar o que?
		barra.spellid = tabela[5]
		barra:Show()
	end
	
end

function atributo_heal:MontaTooltipAlvos (esta_barra, index, instancia)

	local inimigo = esta_barra.nome_inimigo
	local container = self.spells._ActorTable
	local habilidades = {}
	local total
	local sub_atributo = info.instancia.sub_atributo
	
	local targets_key = ""
	
	if (sub_atributo == 3) then --> overheal
		total = self.totalover
		targets_key = "_overheal"
	else
		total = self.total
	end

	--> add spells
	for spellid, tabela in _pairs (container) do
		for target_name, amount in _pairs (tabela ["targets" .. targets_key]) do
			if (target_name == inimigo) then
				local nome, _, icone = _GetSpellInfo (spellid)
				habilidades [#habilidades+1] = {nome, amount, icone}
			end
		end
	end

	--> add pets
	local ActorPets = self.pets
	for _, PetName in _ipairs (ActorPets) do
		local PetActor = instancia.showing (class_type, PetName)
		if (PetActor) then 
			local PetSkillsContainer = PetActor.spells._ActorTable
			for _spellid, _skill in _pairs (PetSkillsContainer) do

				for target_name, amount in _pairs (_skill ["targets" .. targets_key]) do
					if (target_name == inimigo) then
						local nome, _, icone = _GetSpellInfo (_spellid)
						habilidades [#habilidades+1] = {nome, amount, icone}
					end
				end
				
			end
		end
	end	
	
	_table_sort (habilidades, _detalhes.Sort2)
	
	--get time type
	local meu_tempo
	if (_detalhes.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()
	elseif (_detalhes.time_type == 2) then
		meu_tempo = info.instancia.showing:GetCombatTime()
	end
	
	local is_hps = info.instancia.sub_atributo == 2
	
	if (is_hps) then
		GameTooltip:AddLine (index..". "..inimigo)
		GameTooltip:AddLine (Loc ["STRING_HEALING_HPS_FROM"] .. ":")
		GameTooltip:AddLine (" ")
	else
		GameTooltip:AddLine (index..". "..inimigo)
		GameTooltip:AddLine (Loc ["STRING_HEALING_FROM"] .. ":")
		GameTooltip:AddLine (" ")
	end
	
	for index, tabela in _ipairs (habilidades) do
		local nome, icone = tabela[1], tabela [3]
		if (index < 8) then
			if (is_hps) then
				GameTooltip:AddDoubleLine (index..". |T"..icone..":0|t "..nome, _detalhes:comma_value (_math_floor (tabela[2]/meu_tempo)).." (".. _cstr ("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			else
				GameTooltip:AddDoubleLine (index..". |T"..icone..":0|t "..nome, SelectedToKFunction (_, tabela[2]).." (".. _cstr ("%.1f", tabela[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			end
		else
			if (is_hps) then
				GameTooltip:AddDoubleLine (index..". "..nome, _detalhes:comma_value (_math_floor (tabela[2]/meu_tempo)).." (".. _cstr ("%.1f", tabela[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			else
				GameTooltip:AddDoubleLine (index..". "..nome, SelectedToKFunction (_, tabela[2]).." (".. _cstr ("%.1f", tabela[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			end
		end
	end
	
	return true
	
end

function atributo_heal:MontaDetalhes (spellid, barra)
	--> bifurga��es
	if (info.sub_atributo == 1 or info.sub_atributo == 2 or info.sub_atributo == 3) then
		return self:MontaDetalhesHealingDone (spellid, barra)
	elseif (info.sub_atributo == 4) then
		atributo_heal:MontaDetalhesHealingTaken (spellid, barra)
	end
end

function atributo_heal:MontaDetalhesHealingTaken (nome, barra)

	for _, barra in _ipairs (info.barras3) do 
		barra:Hide()
	end

	local barras = info.barras3
	local instancia = info.instancia
	
	local tabela_do_combate = info.instancia.showing
	local showing = tabela_do_combate [class_type] --> o que esta sendo mostrado -> [1] - dano [2] - cura --> pega o container com ._NameIndexTable ._ActorTable

	local este_curandeiro = showing._ActorTable[showing._NameIndexTable[nome]]
	local conteudo = este_curandeiro.spells._ActorTable --> _pairs[] com os IDs das magias
	
	local actor = info.jogador.nome
	
	local total = este_curandeiro.targets [actor]

	local minhas_magias = {}

	for spellid, tabela in _pairs (conteudo) do --> da foreach em cada spellid do container
		if (tabela.targets [actor]) then
			local spell_nome, _, icone = _GetSpellInfo (spellid)
			_table_insert (minhas_magias, {spellid, tabela.targets [actor], tabela.targets [actor] / total*100, spell_nome, icone})
		end
	end

	_table_sort (minhas_magias, _detalhes.Sort2)

	local max_ = minhas_magias[1] and minhas_magias[1][2] or 0 --> dano que a primeiro magia vez
	
	local barra
	for index, tabela in _ipairs (minhas_magias) do
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

		barra.texto_esquerdo:SetText (index..instancia.divisores.colocacao..tabela[4]) --seta o texto da esqueda
		barra.texto_direita:SetText (_detalhes:comma_value (tabela[2]) .." ".. instancia.divisores.abre .._cstr("%.1f", tabela[3]) .."%".. instancia.divisores.fecha)
		
		barra.icone:SetTexture (tabela[5])

		barra:Show() --> mostra a barra
		
		if (index == 15) then 
			break
		end
	end
end

local absorbed_table = {c = {1, 1, 1, 0.4}, p = 0}
local overhealing_table = {c = {0.5, 0.1, 0.1, 0.4}, p = 0}
local anti_heal_table = {c = {0.5, 0.1, 0.1, 0.4}, p = 0}
local normal_table = {c = {1, 1, 1, 0.4}, p = 0}
local multistrike_table = {c = {1, 1, 1, 0.4}, p = 0}
local critical_table = {c = {1, 1, 1, 0.4}, p = 0}

local data_table = {}
local t1, t2, t3, t4 = {}, {}, {}, {}

function atributo_heal:MontaDetalhesHealingDone (spellid, barra)

	local esta_magia
	if (barra.other_actor) then
		esta_magia = barra.other_actor.spells._ActorTable [spellid]
	else
		esta_magia = self.spells._ActorTable [spellid]
	end
	
	if (not esta_magia) then
		return
	end
	
	--> icone direito superior
	local _, _, icone = _GetSpellInfo (spellid)
	info.spell_icone:SetTexture (icone)

	local total = self.total
	
	local overheal = esta_magia.overheal
	local meu_total = esta_magia.total + overheal
	
	local meu_tempo
	if (_detalhes.time_type == 1 or not self.grupo) then
		meu_tempo = self:Tempo()
	elseif (_detalhes.time_type == 2) then
		meu_tempo = info.instancia.showing:GetCombatTime()
	end

	local total_hits = esta_magia.counter
	local index = 1
	local data = data_table
	
	table.wipe (t1)
	table.wipe (t2)
	table.wipe (t3)
	table.wipe (t4)
	table.wipe (data)
	
	if (esta_magia.total > 0) then
	
	--> GERAL
		local media = esta_magia.total/total_hits
		
		local this_hps = nil
		if (esta_magia.counter > esta_magia.c_amt) then
			this_hps = Loc ["STRING_HPS"] .. ": " .. _detalhes:comma_value (esta_magia.total/meu_tempo)
		else
			this_hps = Loc ["STRING_HPS"] .. ": " .. Loc ["STRING_SEE_BELOW"]
		end
		
		local heal_string
		if (esta_magia.is_shield) then
			heal_string = Loc ["STRING_SHIELD_HEAL"]
		else
			heal_string = Loc ["STRING_HEAL"]
		end
		
		local hits_string = "" .. total_hits
		local cast_string = Loc ["STRING_CAST"] .. ": "
		
		local misc_actor = info.instancia.showing (4, self:name())
		if (misc_actor) then
			local buff_uptime = misc_actor.buff_uptime_spells and misc_actor.buff_uptime_spells._ActorTable [spellid] and misc_actor.buff_uptime_spells._ActorTable [spellid].uptime
			if (buff_uptime) then
				hits_string = hits_string .. "  |cFFDDDD44(" .. _math_floor (buff_uptime / info.instancia.showing:GetCombatTime() * 100) .. "% uptime)|r"
			end

			local spell_cast = misc_actor.spell_cast and misc_actor.spell_cast [spellid]
			
			if (not spell_cast and misc_actor.spell_cast) then
				local spellname = GetSpellInfo (spellid)
				for casted_spellid, amount in _pairs (misc_actor.spell_cast) do
					local casted_spellname = GetSpellInfo (casted_spellid)
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
		
		gump:SetaDetalheInfoTexto ( index, 100,
			--Loc ["STRING_GERAL"], 
			cast_string, 
			heal_string .. ": " .. _detalhes:ToK (esta_magia.total), 
			"", --Loc ["STRING_PERCENTAGE"] .. ": " .. _cstr ("%.1f", esta_magia.total/total*100) .. "%",
			Loc ["STRING_AVERAGE"] .. ": " .. _detalhes:comma_value (media), 
			this_hps,
			Loc ["STRING_HITS"] .. ": " .. hits_string) 
	
	--> NORMAL
		local normal_hits = esta_magia.n_amt
		if (normal_hits > 0) then
			local normal_curado = esta_magia.n_curado
			local media_normal = normal_curado/normal_hits
			media_normal = max (media_normal, 0.000001)
			
			local T = (meu_tempo*normal_curado)/esta_magia.total
			local P = media/media_normal*100
			T = P*T/100

			data[#data+1] = t1
			
			if (esta_magia.is_shield) then
				t1[3] = Loc ["STRING_ABSORBED"]
				normal_table.p = esta_magia.total / (esta_magia.total+esta_magia.overheal) * 100
			else
				t1[3] = heal_string
				normal_table.p = normal_hits/total_hits*100
			end
			
			t1[1] = esta_magia.n_amt
			t1[2] = normal_table

			t1[4] = Loc ["STRING_MINIMUM_SHORT"] .. ": " .. _detalhes:comma_value (esta_magia.n_min)
			t1[5] = Loc ["STRING_MAXIMUM_SHORT"] .. ": " .. _detalhes:comma_value (esta_magia.n_max)
			t1[6] = Loc ["STRING_AVERAGE"] .. ": " .. _detalhes:comma_value (media_normal)
			t1[7] = Loc ["STRING_HPS"] .. ": " .. _detalhes:comma_value (normal_curado/T)
			t1[8] = normal_hits .. " / ".. _cstr ("%.1f", normal_hits/total_hits*100) .. "%"

		end

	--> CRITICO
		if (esta_magia.c_amt > 0) then	
			local media_critico = esta_magia.c_curado/esta_magia.c_amt
			local T = (meu_tempo*esta_magia.c_curado)/esta_magia.total
			local P = media/media_critico*100
			T = P*T/100
			local crit_hps = esta_magia.c_curado/T
			if (not crit_hps) then
				crit_hps = 0
			end
			
			data[#data+1] = t2
			critical_table.p = esta_magia.c_amt/total_hits*100
			
			t2[1] = esta_magia.c_amt
			t2[2] = critical_table
			t2[3] = Loc ["STRING_HEAL_CRIT"]
			t2[4] = Loc ["STRING_MINIMUM_SHORT"] .. ": " .. _detalhes:comma_value (esta_magia.c_min)
			t2[5] = Loc ["STRING_MAXIMUM_SHORT"] .. ": " .. _detalhes:comma_value (esta_magia.c_max)
			t2[6] = Loc ["STRING_AVERAGE"] .. ": " .. _detalhes:comma_value (media_critico)
			t2[7] = Loc ["STRING_HPS"] .. ": " .. _detalhes:comma_value (crit_hps)
			t2[8] = esta_magia.c_amt .. " [|cFFC0C0C0".. _cstr ("%.1f", esta_magia.c_amt/total_hits*100) .. "%|r]"
			
		end
		
	--> MULTISTRIKE
		--[=[
		if (esta_magia.m_amt > 0) then
		
			local multistrike_hits = esta_magia.m_amt
			local multistrike_heal = esta_magia.m_healed

			local media_normal = multistrike_heal / multistrike_hits
			local T = (meu_tempo * multistrike_heal) / esta_magia.total
			local P = media / media_normal * 100
			T = P * T / 100
			
			data[#data+1] = t3
			multistrike_table.p = esta_magia.m_amt/total_hits*100
		
			t3[1] = multistrike_hits
			t3[2] = multistrike_table
			t3[3] = Loc ["STRING_MULTISTRIKE_HITS"]
			t3[4] = "On Critical: " .. esta_magia.m_crit
			t3[5] = "On Normals: " .. (esta_magia.m_amt - esta_magia.m_crit)
			t3[6] = Loc ["STRING_AVERAGE"] .. ": " .. _detalhes:comma_value (multistrike_heal / multistrike_hits)
			t3[7] = Loc ["STRING_HPS"] .. ": " .. _detalhes:comma_value (multistrike_heal / T)
			t3[8] = multistrike_hits .. " [|cFFC0C0C0" .. _cstr ("%.1f", multistrike_hits / total_hits * 100) .. "%|r]"

		end
		--]=]
	end

	_table_sort (data, _detalhes.Sort1)
	
--	for i = #data+1, 2 do --> para o antiheal aparecer na penultima barra
--		data[i] = nil
--	end	
	
	--> anti heal
		if (esta_magia.anti_heal and esta_magia.anti_heal > 0) then
			local porcentagem_anti_heal = esta_magia.anti_heal / meu_total * 100
			data[3] = t3
			
			anti_heal_table.p = porcentagem_anti_heal
			
			t3[1] = esta_magia.anti_heal
			t3[2] = anti_heal_table
			t3[3] = "Anti Heal"
			
			t3[4] = ""
			t3[5] = ""
			t3[6] = ""
			t3[7] = ""
			t3[8] = _detalhes:comma_value (esta_magia.anti_heal) .. " / " .. _cstr ("%.1f", porcentagem_anti_heal) .. "%"
		end
	
--	for i = #data+1, 3 do --> para o overheal aparecer na ultima barra
--		data[i] = nil
--	end
	
	--> overhealing
		if (overheal > 0) then
			local porcentagem_overheal = overheal/meu_total*100
			data[4] = t4
			
			overhealing_table.p = porcentagem_overheal
			
			t4[1] = overheal
			t4[2] = overhealing_table

			if (esta_magia.is_shield) then
				t4[3] = Loc ["STRING_SHIELD_OVERHEAL"]
			else
				t4[3] = Loc ["STRING_OVERHEAL"]
			end
			
			t4[4] = ""
			t4[5] = ""
			t4[6] = ""
			t4[7] = ""
			t4[8] = _detalhes:comma_value (overheal) .. " / " .. _cstr ("%.1f", porcentagem_overheal) .. "%"
		end
	
	for index = 1, 4 do
		local tabela = data[index]
		if (not tabela) then
			gump:HidaDetalheInfo (index+1)
		else
			gump:SetaDetalheInfoTexto (index+1, tabela[2], tabela[3], tabela[4], tabela[5], tabela[6], tabela[7], tabela[8])
		end
	end

end

--controla se o dps do jogador esta travado ou destravado
function atributo_heal:Iniciar (iniciar)
	if (iniciar == nil) then 
		return self.iniciar_hps --retorna se o dps esta aberto ou fechado para este jogador
	elseif (iniciar) then
		self.iniciar_hps = true
		self:RegistrarNaTimeMachine() --coloca ele da timeMachine
	else
		self.iniciar_hps = false
		self:DesregistrarNaTimeMachine() --retira ele da timeMachine
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a funcao de abreviacao
		function atributo_heal:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions [_detalhes.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions [_detalhes.tooltip.abbreviation]
			TooltipMaximizedMethod = _detalhes.tooltip.maximize_method
			headerColor = _detalhes.tooltip.header_text_color
		end

	--> subtract total from a combat table
		function atributo_heal:subtract_total (combat_table)
			combat_table.totals [class_type] = combat_table.totals [class_type] - self.total
			if (self.grupo) then
				combat_table.totals_grupo [class_type] = combat_table.totals_grupo [class_type] - self.total
			end
		end
		function atributo_heal:add_total (combat_table)
			combat_table.totals [class_type] = combat_table.totals [class_type] + self.total
			if (self.grupo) then
				combat_table.totals_grupo [class_type] = combat_table.totals_grupo [class_type] + self.total
			end
		end		
		
	--> restaura a tabela de last event
		function atributo_heal:r_last_events_table (actor)
			if (not actor) then
				actor = self
			end
			--actor.last_events_table = _detalhes:CreateActorLastEventTable()
		end
		
	--> restaura e liga o ator com a sua shadow durante a inicializa��o
		function atributo_heal:r_onlyrefresh_shadow (actor)
		
			--> criar uma shadow desse ator se ainda n�o tiver uma
				local overall_cura = _detalhes.tabela_overall [2]
				local shadow = overall_cura._ActorTable [overall_cura._NameIndexTable [actor.nome]]

				if (not shadow) then 
					shadow = overall_cura:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
					
					shadow.classe = actor.classe
					shadow.spec = actor.spec
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.isTank = actor.isTank
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component
					
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end
			
			--> restaura a meta e indexes ao ator
				_detalhes.refresh:r_atributo_heal (actor, shadow)
				
			--> copia o container de alvos (captura de dados)
				for target_name, amount in _pairs (actor.targets) do
					shadow.targets [target_name] = 0
				end
				for target_name, amount in _pairs (actor.targets_overheal) do
					shadow.targets_overheal [target_name] = 0
				end
				for target_name, amount in _pairs (actor.targets_absorbs) do
					shadow.targets_absorbs [target_name] = 0
				end
			
			--> copia o container de habilidades (captura de dados)
				for spellid, habilidade in _pairs (actor.spells._ActorTable) do 
					--> cria e soma o valor
					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, nil, true)
					--> refresh e soma os valores dos alvos
					
					for target_name, amount in _pairs (habilidade.targets) do
						if (not habilidade_shadow.targets [target_name]) then
							habilidade_shadow.targets [target_name] = 0
						end
					end
					for target_name, amount in _pairs (habilidade.targets_overheal) do
						if (not habilidade_shadow.targets_overheal [target_name]) then
							habilidade_shadow.targets_overheal [target_name] = 0
						end
					end
					for target_name, amount in _pairs (habilidade.targets_absorbs) do
						if (not habilidade_shadow.targets_absorbs [target_name]) then
							habilidade_shadow.targets_absorbs [target_name] = 0
						end
					end
					
					--> copia o container de heal negado se ele existir
					if (habilidade.heal_denied) then
						--> cria o container na shadow de ele n�o existir
						habilidade_shadow.heal_denied = habilidade_shadow.heal_denied or {}
						habilidade_shadow.heal_denied_healers = habilidade_shadow.heal_denied_healers or {}
						--> copia
						for spellID, amount in _pairs (habilidade.heal_denied) do
							if (not habilidade_shadow.heal_denied [spellID]) then
								habilidade_shadow.heal_denied [spellID] = 0
							end
						end
						for healerName, amount in _pairs (habilidade.heal_denied_healers) do
							if (not habilidade_shadow.heal_denied_healers [healerName]) then
								habilidade_shadow.heal_denied_healers [healerName] = 0
							end
						end						
					end

				end
			
			return shadow
		end
	
		function atributo_heal:r_connect_shadow (actor, no_refresh, combat_object)
		
			local host_combat = combat_object or _detalhes.tabela_overall
		
			--> criar uma shadow desse ator se ainda n�o tiver uma
				local overall_cura = host_combat [2]
				local shadow = overall_cura._ActorTable [overall_cura._NameIndexTable [actor.nome]]

				if (not shadow) then 
					shadow = overall_cura:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
					
					shadow.classe = actor.classe
					shadow.spec = actor.spec
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.isTank = actor.isTank
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component
					
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end
			
			--> restaura a meta e indexes ao ator
				if (not no_refresh) then
					_detalhes.refresh:r_atributo_heal (actor, shadow)
				end
			
			--> tempo decorrido (captura de dados)
				local end_time = actor.end_time
				if (not actor.end_time) then
					end_time = time()
				end
				
				local tempo = end_time - actor.start_time
				shadow.start_time = shadow.start_time - tempo

			--> pets (add unique pet names)
			for _, petName in _ipairs (actor.pets) do
				DetailsFramework.table.addunique (shadow.pets, petName)
			end
				
			--> total de cura (captura de dados)
				shadow.total = shadow.total + actor.total
			--> total de overheal (captura de dados)
				shadow.totalover = shadow.totalover + actor.totalover
			--> total de absorbs (captura de dados)
				shadow.totalabsorb = shadow.totalabsorb + actor.totalabsorb
			--> total de cura feita em inimigos (captura de dados)
				shadow.heal_enemy_amt = shadow.heal_enemy_amt + actor.heal_enemy_amt
			--> total de heal negado
				shadow.totaldenied = shadow.totaldenied + actor.totaldenied
			--> total sem pets (captura de dados)
				shadow.total_without_pet = shadow.total_without_pet + actor.total_without_pet
				shadow.totalover_without_pet = shadow.totalover_without_pet + actor.totalover_without_pet
			--> total de cura recebida (captura de dados)
				shadow.healing_taken = shadow.healing_taken + actor.healing_taken

			--> total no combate overall (captura de dados)
				host_combat.totals[2] = host_combat.totals[2] + actor.total
				if (actor.grupo) then
					host_combat.totals_grupo[2] = host_combat.totals_grupo[2] + actor.total
				end
				
			--> copia o healing_from  (captura de dados)
				for nome, _ in _pairs (actor.healing_from) do 
					shadow.healing_from [nome] = true
				end
				
			--> copia o heal_enemy (captura de dados)
				for spellid, amount in _pairs (actor.heal_enemy) do 
					if (shadow.heal_enemy [spellid]) then 
						shadow.heal_enemy [spellid] = shadow.heal_enemy [spellid] + amount
					else
						shadow.heal_enemy [spellid] = amount
					end
				end
			
			--> copia o container de alvos (captura de dados)
				for target_name, amount in _pairs (actor.targets) do
					shadow.targets [target_name] = (shadow.targets [target_name] or 0) + amount
				end
				for target_name, amount in _pairs (actor.targets_overheal) do
					shadow.targets_overheal [target_name] = (shadow.targets_overheal [target_name] or 0) + amount
				end
				for target_name, amount in _pairs (actor.targets_absorbs) do
					shadow.targets_absorbs [target_name] = (shadow.targets_absorbs [target_name] or 0) + amount
				end
			
			--> copia o container de habilidades (captura de dados)
				for spellid, habilidade in _pairs (actor.spells._ActorTable) do 
					--> cria e soma o valor
					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, nil, true)
					
					--> refresh e soma os valores dos alvos
					for target_name, amount in _pairs (habilidade.targets) do 
						habilidade_shadow.targets [target_name] = (habilidade_shadow.targets [target_name] or 0) + amount
					end
					for target_name, amount in _pairs (habilidade.targets_overheal) do 
						habilidade_shadow.targets_overheal [target_name] = (habilidade_shadow.targets_overheal [target_name] or 0) + amount
					end
					for target_name, amount in _pairs (habilidade.targets_absorbs) do 
						habilidade_shadow.targets_absorbs [target_name] = (habilidade_shadow.targets_absorbs [target_name] or 0) + amount
					end
					
					--> copia o container de heal negado se ele existir
					if (habilidade.heal_denied) then
						--> cria o container na shadow de ele n�o existir
						habilidade_shadow.heal_denied = habilidade_shadow.heal_denied or {}
						habilidade_shadow.heal_denied_healers = habilidade_shadow.heal_denied_healers or {}
						--> copia
						for spellID, amount in _pairs (habilidade.heal_denied) do
							habilidade_shadow.heal_denied [spellID] = (habilidade_shadow.heal_denied [spellID] or 0) + amount
						end
						for healerName, amount in _pairs (habilidade.heal_denied_healers) do
							habilidade_shadow.heal_denied_healers [healerName] = (habilidade_shadow.heal_denied_healers [healerName] or 0) + amount
						end
					end					
					
					--> soma todos os demais valores
					for key, value in _pairs (habilidade) do 
						if (_type (value) == "number") then
							if (key ~= "id") then
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
			
			return shadow
		end

function atributo_heal:ColetarLixo (lastevent)
	return _detalhes:ColetarLixo (class_type, lastevent)
end

atributo_heal.__add = function (tabela1, tabela2)

	--> tempo decorrido
		local tempo = (tabela2.end_time or time()) - tabela2.start_time
		tabela1.start_time = tabela1.start_time - tempo

	--> total de cura
		tabela1.total = tabela1.total + tabela2.total
	--> total de overheal
		tabela1.totalover = tabela1.totalover + tabela2.totalover
	--> total de absorbs
		tabela1.totalabsorb = tabela1.totalabsorb + tabela2.totalabsorb
	--> total de cura feita em inimigos
		tabela1.heal_enemy_amt = tabela1.heal_enemy_amt + tabela2.heal_enemy_amt
	--> total de cura negada
		tabela1.totaldenied = tabela1.totaldenied + tabela2.totaldenied
		
	--> total sem pets
		tabela1.total_without_pet = tabela1.total_without_pet + tabela2.total_without_pet
		tabela1.totalover_without_pet = tabela1.totalover_without_pet + tabela2.totalover_without_pet
	--> total de cura recebida
		tabela1.healing_taken = tabela1.healing_taken + tabela2.healing_taken
		
	--> soma o healing_from
		for nome, _ in _pairs (tabela2.healing_from) do 
			tabela1.healing_from [nome] = true
		end
	
	--> somar o heal_enemy
		for spellid, amount in _pairs (tabela2.heal_enemy) do 
			if (tabela1.heal_enemy [spellid]) then 
				tabela1.heal_enemy [spellid] = tabela1.heal_enemy [spellid] + amount
			else
				tabela1.heal_enemy [spellid] = amount
			end
		end
	
	--> somar o container de alvos
		for target_name, amount in _pairs (tabela2.targets) do
			tabela1.targets [target_name] = (tabela1.targets [target_name] or 0) + amount
		end
		for target_name, amount in _pairs (tabela2.targets_overheal) do 
			tabela1.targets_overheal [target_name] = (tabela1.targets_overheal [target_name] or 0) + amount
		end
		for target_name, amount in _pairs (tabela2.targets_absorbs) do 
			tabela1.targets_absorbs [target_name] = (tabela1.targets_absorbs [target_name] or 0) + amount
		end
	
	--> soma o container de habilidades
		for spellid, habilidade in _pairs (tabela2.spells._ActorTable) do 
			--> pega a habilidade no primeiro ator
			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_HEAL", false)
			--> soma os alvos
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets = (habilidade_tabela1.targets [target_name] or 0) + amount
			end
			for target_name, amount in _pairs (habilidade.targets_overheal) do 
				habilidade_tabela1.targets_overheal = (habilidade_tabela1.targets_overheal [target_name] or 0) + amount
			end
			for target_name, amount in _pairs (habilidade.targets_absorbs) do 
				habilidade_tabela1.targets_absorbs = (habilidade_tabela1.targets_absorbs [target_name] or 0) + amount
			end
			
			--> copia o container de heal negado se ele existir
			if (habilidade.heal_denied) then
				--> cria o container na shadow de ele n�o existir
				habilidade_tabela1.heal_denied = habilidade_tabela1.heal_denied or {}
				habilidade_tabela1.heal_denied_healers = habilidade_tabela1.heal_denied_healers or {}
				--> copia
				for spellID, amount in _pairs (habilidade.heal_denied) do
					habilidade_tabela1.heal_denied [spellID] = (habilidade_tabela1.heal_denied [spellID] or 0) + amount
				end
				for healerName, amount in _pairs (habilidade.heal_denied_healers) do
					habilidade_tabela1.heal_denied_healers [healerName] = (habilidade_tabela1.heal_denied_healers [healerName] or 0) + amount
				end
			end
			
			--> soma os valores da habilidade
			for key, value in _pairs (habilidade) do 
				if (_type (value) == "number") then
					if (key ~= "id") then
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
	
	return tabela1
end

atributo_heal.__sub = function (tabela1, tabela2)

	--> tempo decorrido
		local tempo = (tabela2.end_time or time()) - tabela2.start_time
		tabela1.start_time = tabela1.start_time + tempo

	--> total de cura
		tabela1.total = tabela1.total - tabela2.total
	--> total de overheal
		tabela1.totalover = tabela1.totalover - tabela2.totalover
	--> total de absorbs
		tabela1.totalabsorb = tabela1.totalabsorb - tabela2.totalabsorb
	--> total de cura feita em inimigos
		tabela1.heal_enemy_amt = tabela1.heal_enemy_amt - tabela2.heal_enemy_amt
	--> total de cura negada
		tabela1.totaldenied = tabela1.totaldenied - tabela2.totaldenied
	
	--> total sem pets
		tabela1.total_without_pet = tabela1.total_without_pet - tabela2.total_without_pet
		tabela1.totalover_without_pet = tabela1.totalover_without_pet - tabela2.totalover_without_pet
	--> total de cura recebida
		tabela1.healing_taken = tabela1.healing_taken - tabela2.healing_taken

	--> reduz o heal_enemy
		for spellid, amount in _pairs (tabela2.heal_enemy) do 
			if (tabela1.heal_enemy [spellid]) then 
				tabela1.heal_enemy [spellid] = tabela1.heal_enemy [spellid] - amount
			else
				tabela1.heal_enemy [spellid] = amount
			end
		end
		
	--> reduz o container de alvos
		for target_name, amount in _pairs (tabela2.targets) do 
			if (tabela1.targets [target_name]) then
				tabela1.targets [target_name] = tabela1.targets [target_name] - amount
			end
		end
		for target_name, amount in _pairs (tabela2.targets_overheal) do 
			if (tabela1.targets_overheal [target_name]) then
				tabela1.targets_overheal [target_name] = tabela1.targets_overheal [target_name] - amount
			end
		end
		for target_name, amount in _pairs (tabela2.targets_absorbs) do 
			if (tabela1.targets_absorbs [target_name]) then
				tabela1.targets_absorbs [target_name] = tabela1.targets_absorbs [target_name] - amount
			end
		end

	--> reduz o container de habilidades
		for spellid, habilidade in _pairs (tabela2.spells._ActorTable) do 
			--> pega a habilidade no primeiro ator
			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_HEAL", false)
			--> alvos
			for target_name, amount in _pairs (habilidade.targets) do 
				if (habilidade_tabela1.targets [target_name]) then
					habilidade_tabela1.targets [target_name] = habilidade_tabela1.targets [target_name] - amount
				end
			end
			for target_name, amount in _pairs (habilidade.targets_overheal) do 
				if (habilidade_tabela1.targets_overheal [target_name]) then
					habilidade_tabela1.targets_overheal [target_name] = habilidade_tabela1.targets_overheal [target_name] - amount
				end
			end
			for target_name, amount in _pairs (habilidade.targets_absorbs) do 
				if (habilidade_tabela1.targets_absorbs [target_name]) then
					habilidade_tabela1.targets_absorbs [target_name] = habilidade_tabela1.targets_absorbs [target_name] - amount
				end
			end
			
			--> copia o container de heal negado se ele existir
			if (habilidade.heal_denied) then
				--> cria o container na shadow de ele n�o existir
				habilidade_tabela1.heal_denied = habilidade_tabela1.heal_denied or {}
				habilidade_tabela1.heal_denied_healers = habilidade_tabela1.heal_denied_healers or {}
				--> copia
				for spellID, amount in _pairs (habilidade.heal_denied) do
					habilidade_tabela1.heal_denied [spellID] = (habilidade_tabela1.heal_denied [spellID] or 0) - amount
				end
				for healerName, amount in _pairs (habilidade.heal_denied_healers) do
					habilidade_tabela1.heal_denied_healers [healerName] = (habilidade_tabela1.heal_denied_healers [healerName] or 0) - amount
				end
			end
			
			--> soma os valores da habilidade
			for key, value in _pairs (habilidade) do 
				if (_type (value) == "number") then
					if (key ~= "id") then
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
	
	return tabela1
end

function _detalhes.refresh:r_atributo_heal (este_jogador, shadow)
	_setmetatable (este_jogador, atributo_heal)
	este_jogador.__index = atributo_heal
	
	_detalhes.refresh:r_container_habilidades (este_jogador.spells, shadow and shadow.spells)
end

function _detalhes.clear:c_atributo_heal (este_jogador)
	este_jogador.__index = nil
	este_jogador.shadow = nil
	este_jogador.links = nil
	este_jogador.minha_barra = nil
	
	_detalhes.clear:c_container_habilidades (este_jogador.spells)
end

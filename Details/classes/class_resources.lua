
--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _table_sort = table.sort
local _table_insert = table.insert
local _setmetatable = setmetatable
local _ipairs = ipairs
local _pairs = pairs
local _rawget= rawget
local _math_min = math.min
local _math_max = math.max
local _bit_band = bit.band
local _unpack = unpack
local _type = type
--api locals
local _GetSpellInfo = _detalhes.getspellinfo
local GameTooltip = GameTooltip
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup

local _string_replace = _detalhes.string.replace --details api

local _detalhes = 		_G._detalhes
local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ( "Details" )
local _

local gump = 			_detalhes.gump

local alvo_da_habilidade = 	_detalhes.alvo_da_habilidade
local container_habilidades = 	_detalhes.container_habilidades
local container_combatentes = _detalhes.container_combatentes
local container_pets =		_detalhes.container_pets
local atributo_energy =		_detalhes.atributo_energy
local habilidade_energy = 	_detalhes.habilidade_energy

local container_energy = _detalhes.container_type.CONTAINER_ENERGY_CLASS

--local modo_ALONE = _detalhes.modos.alone
local modo_GROUP = _detalhes.modos.group
local modo_ALL = _detalhes.modos.all

local class_type = _detalhes.atributos.e_energy

local DATA_TYPE_START = _detalhes._detalhes_props.DATA_TYPE_START
local DATA_TYPE_END = _detalhes._detalhes_props.DATA_TYPE_END

local ToKFunctions = _detalhes.ToKFunctions
local SelectedToKFunction = ToKFunctions [1]
local UsingCustomLeftText = false
local UsingCustomRightText = false

local FormatTooltipNumber = ToKFunctions [8]
local TooltipMaximizedMethod = 1

local headerColor = "yellow"

local actor_class_color_r, actor_class_color_g, actor_class_color_b

local info = _detalhes.playerDetailWindow
local keyName


function atributo_energy:NovaTabela (serial, nome, link)

	--> constructor
	
	local alphabetical = _detalhes:GetOrderNumber (nome)
	
	local _new_energyActor = {
	
		last_event = 0,
		tipo = class_type,

		total = alphabetical,
		totalover = alphabetical,
		passiveover = alphabetical,
		received = alphabetical,
		resource = alphabetical,
		alternatepower = alphabetical,

		last_value = nil,

		pets = {},
		targets = {},
		spells = container_habilidades:NovoContainer (container_energy),
	}
	
	_setmetatable (_new_energyActor, atributo_energy)
	
	return _new_energyActor
end

--> resources sort

function _detalhes.SortGroupResource (container, keyName2)
	keyName = keyName2
	return _table_sort (container, _detalhes.SortKeyGroupResources)
end

function _detalhes.SortKeyGroupResources (table1, table2)
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

function _detalhes.SortKeySimpleResources (table1, table2)
	return table1 [keyName] > table2 [keyName]
end

function _detalhes:ContainerSortResources (container, amount, keyName2)
	keyName = keyName2
	_table_sort (container,  _detalhes.SortKeySimpleResources)
	
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

--> power types sort

local power_table = {0, 1, 3, 6}
local power_type

local sort_energy = function (t1, t2)
	if (t1.powertype == power_type and t2.powertype == power_type) then
		return t1.received > t2.received
	elseif (t1.powertype == power_type) then
		return true
	elseif (t2.powertype == power_type) then
		return false
	else
		return t1.received > t2.received
	end
end

local sort_energyalternate = function (t1, t2)
	return t1.alternatepower > t2.alternatepower
end

local sort_energy_group = function (t1, t2)
	if (t1.grupo and t2.grupo) then
		if (t1.powertype == power_type and t2.powertype == power_type) then
			return t1.received > t2.received
		elseif (t1.powertype == power_type) then
			return true
		elseif (t2.powertype == power_type) then
			return false
		else
			return t1.received > t2.received
		end
	else
		if (t1.grupo) then
			return true
		elseif (t2.grupo) then
			return false
		else
			return t1.received > t2.received
		end
	end
end

local sort_alternateenergy_group = function (t1, t2)
	if (t1.grupo and t2.grupo) then
		return t1.alternatepower > t2.alternatepower
	else
		if (t1.grupo) then
			return true
		elseif (t2.grupo) then
			return false
		else
			return t1.alternatepower > t2.alternatepower
		end
	end
end

--> resource refresh

local function RefreshBarraResources (tabela, barra, instancia)
	tabela:AtualizarResources (tabela.minha_barra, barra.colocacao, instancia)
end

function atributo_energy:AtualizarResources (whichRowLine, colocacao, instancia)
	
	local esta_barra = instancia.barras [whichRowLine]
	
	if (not esta_barra) then
		print ("DEBUG: problema com <instancia.esta_barra> "..whichRowLine.." "..colocacao)
		return
	end
	
	self._refresh_window = RefreshBarraResources
	
	local tabela_anterior = esta_barra.minha_tabela
	esta_barra.minha_tabela = self
	self.minha_barra = whichRowLine
	esta_barra.colocacao = colocacao
	
	local total = instancia.showing.totals.resources
	
	local combat_time = instancia.showing:GetCombatTime()
	local rps = _math_floor (self.resource / combat_time)
	
	local formated_resource = SelectedToKFunction (_, self.resource)
	local formated_rps = _cstr ("%.2f", self.resource / combat_time)
	
	local porcentagem
	
	if (instancia.row_info.percent_type == 1) then
		porcentagem = _cstr ("%.1f", self.resource / total * 100)
	elseif (instancia.row_info.percent_type == 2) then
		porcentagem = _cstr ("%.1f", self.resource / instancia.top * 100)
	end
	
	local bars_show_data = instancia.row_info.textR_show_data
	local bars_brackets = instancia:GetBarBracket()
	local bars_separator = instancia:GetBarSeparator()

	if (not bars_show_data [1]) then
		formated_resource = ""
	end
	if (not bars_show_data [2]) then
		formated_rps = ""
	end
	if (not bars_show_data [3]) then
		porcentagem = ""
	else
		porcentagem = porcentagem .. "%"
	end
	
	local rightText = formated_resource .. bars_brackets[1] .. formated_rps .. " r/s" .. bars_separator .. porcentagem .. bars_brackets[2]
	if (UsingCustomRightText) then
		esta_barra.lineText4:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_resource, formated_rps, porcentagem, self, instancia.showing, instancia, rightText))
	else
		if (instancia.use_multi_fontstrings) then
			Details:SetTextsOnLine(esta_barra, formated_resource, formated_rps .. " r/s", porcentagem .. "%")
		else
			esta_barra.lineText4:SetText (rightText)
		end
	end
	
	esta_barra.lineText1:SetText (colocacao .. ". " .. self.nome)
	esta_barra.lineText1:SetSize (esta_barra:GetWidth() - esta_barra.lineText4:GetStringWidth() - 20, 15)
	
	esta_barra:SetValue (100)
	
	if (esta_barra.hidden or esta_barra.fading_in or esta_barra.faded) then
		gump:Fade (esta_barra, "out")
	end
	
	--> texture color
	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	self:SetBarColors (esta_barra, instancia, actor_class_color_r, actor_class_color_g, actor_class_color_b)
	--> icon
	self:SetClassIcon (esta_barra.icone_classe, instancia, self.classe)

end

--> refresh function

function atributo_energy:RefreshWindow (instancia, tabela_do_combate, forcar, exportar)

	local showing = tabela_do_combate [class_type]

	if (#showing._ActorTable < 1) then --> n�o h� barras para mostrar
		return _detalhes:EsconderBarrasNaoUsadas (instancia, showing), "", 0, 0
	end
	
	local total = 0
	instancia.top = 0
	
	local sub_atributo = instancia.sub_atributo
	local conteudo = showing._ActorTable
	local amount = #conteudo
	local modo = instancia.modo
	
	if (sub_atributo == 5) then 
		--> showing resources
		
		keyName = "resource"
		
		if (modo == modo_ALL) then
			amount = _detalhes:ContainerSortResources (conteudo, amount, "resource")
			instancia.top = conteudo[1].resource
			
			for index, player in _ipairs (conteudo) do
				if (player.resource >= 1) then
					total = total + player.resource
				else
					break
				end
			end
			
		elseif (modo == modo_GROUP) then
			_table_sort (conteudo, _detalhes.SortKeyGroupResources)
			
			for index, player in _ipairs (conteudo) do
				if (player.grupo) then --> � um player e esta em grupo
					if (player.resource < 1) then --> dano menor que 1, interromper o loop
						amount = index - 1
						break
					end
					
					total = total + player.resource
				else
					amount = index-1
					break
				end
			end
			
			instancia.top = conteudo [1].resource
		end

		showing:remapear()

		if (exportar) then 
			return total, keyName, instancia.top, amount
		end
		
		if (total < 1) then
			instancia:EsconderScrollBar()
			return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing)
		end
		
		tabela_do_combate.totals.resources = total
		
		instancia:RefreshScrollBar (amount)
		
		local whichRowLine = 1
		local barras_container = instancia.barras
		
		for i = instancia.barraS[1], instancia.barraS[2], 1 do
			conteudo[i]:AtualizarResources (whichRowLine, i, instancia)
			whichRowLine = whichRowLine+1
		end
		
		--> beta, hidar barras n�o usadas durante um refresh for�ado
		if (forcar) then
			if (instancia.modo == 2) then --> group
				for i = whichRowLine, instancia.rows_fit_in_window  do
					gump:Fade (instancia.barras [i], "in", 0.3)
				end
			end
		end
		
		return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing)
		
	end
	
	power_type = power_table [sub_atributo]
	
	keyName = "received"
	
	if (sub_atributo == 6) then
		keyName = "alternatepower"
	end
	
	if (exportar) then
		if (_type (exportar) == "boolean") then 		
			--keyName = "received"
		else
			keyName = exportar.key
			modo = exportar.modo		
		end
	else
		--keyName = "received"
	end
	
	if (modo == modo_ALL) then
	
		_table_sort (conteudo, sort_energyalternate)
		
		if (keyName == "alternatepower") then
			for i = amount, 1, -1 do
				if (conteudo[i].alternatepower < 1) then
					amount = amount-1
				else
					break
				end
			end
			
			total = tabela_do_combate.totals [class_type] ["alternatepower"]
			instancia.top = conteudo[1].alternatepower
		else
			for i = amount, 1, -1 do
				if (conteudo[i].received < 1) then
					amount = amount-1
				elseif (conteudo[i].powertype ~= power_type) then
					amount = amount-1
				else
					break
				end
			end
			
			total = tabela_do_combate.totals [class_type] [power_type]
			instancia.top = conteudo[1].received
		end
		
	elseif (modo == modo_GROUP) then
		if (keyName == "alternatepower") then
		
			_table_sort (conteudo, sort_alternateenergy_group)
			
			for index, player in _ipairs (conteudo) do
				if (player.grupo) then
					if (player.alternatepower < 1) then
						amount = index - 1
						break
					end
					
					total = total + player.alternatepower
				else
					amount = index-1
					break
				end
			end
			instancia.top = conteudo[1].alternatepower

		else
		
			_table_sort (conteudo, sort_energy_group)
		
			for index, player in _ipairs (conteudo) do
				if (player.grupo) then
					if (player.received < 1) then
						amount = index - 1
						break
					elseif (player.powertype ~= power_type) then
						amount = index - 1
						break
					end
					
					total = total + player.received
				else
					amount = index-1
					break
				end
			end
			instancia.top = conteudo[1].received
		end
	end

	showing:remapear()

	if (exportar) then 
		return total, keyName, instancia.top, amount
	end
	
	if (amount < 1) then --> n�o h� barras para mostrar
		instancia:EsconderScrollBar()
		return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh
	end

	instancia:RefreshScrollBar (amount)

	local whichRowLine = 1
	local barras_container = instancia.barras
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
		
			whichRowLine = 2
			local iter_last = instancia.barraS[2]
			if (iter_last == instancia.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = barras_container [1]
			row1.minha_tabela = nil
			row1.lineText1:SetText (Loc ["STRING_TOTAL"])
			if (instancia.use_multi_fontstrings) then
				Details:SetTextsOnLine(row1, "", _detalhes:ToK2 (total, _detalhes:ToK (total / combat_time)))
			else
				row1.lineText4:SetText (_detalhes:ToK2 (total) .. " (" .. _detalhes:ToK (total / combat_time) .. ")")
			end
			
			row1:SetValue (100)
			local r, g, b = unpack (instancia.total_bar.color)
			row1.textura:SetVertexColor (r, g, b)
			
			row1.icone_classe:SetTexture (instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord (0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade (row1, "out")
			
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], iter_last-1, 1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
				
				conteudo[myPos]:RefreshLine (instancia, barras_container, whichRowLine, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
				whichRowLine = whichRowLine+1
			else
				for i = instancia.barraS[1], iter_last, 1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
			end

		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[1], instancia.barraS[2]-1, 1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
				
				conteudo[myPos]:RefreshLine (instancia, barras_container, whichRowLine, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
				whichRowLine = whichRowLine+1
			else
				for i = instancia.barraS[1], instancia.barraS[2], 1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
			end
		end
		
	elseif (instancia.bars_sort_direction == 2) then --bottom to top
	
		if (use_total_bar and instancia.barraS[1] == 1) then
		
			whichRowLine = 2
			local iter_last = instancia.barraS[2]
			if (iter_last == instancia.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = barras_container [1]
			row1.minha_tabela = nil
			row1.lineText1:SetText (Loc ["STRING_TOTAL"])
			
			if (instancia.use_multi_fontstrings) then
				Details:SetTextsOnLine(row1, "", _detalhes:ToK2 (total), _detalhes:ToK (total / combat_time))
			else
				row1.lineText4:SetText (_detalhes:ToK2 (total) .. " (" .. _detalhes:ToK (total / combat_time) .. ")")
			end
			
			row1:SetValue (100)
			local r, g, b = unpack (instancia.total_bar.color)
			row1.textura:SetVertexColor (r, g, b)
			
			row1.icone_classe:SetTexture (instancia.total_bar.icon)
			row1.icone_classe:SetTexCoord (0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade (row1, "out")
			
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = iter_last-1, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
				
				conteudo[myPos]:RefreshLine (instancia, barras_container, whichRowLine, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
				whichRowLine = whichRowLine+1
			else
				for i = iter_last, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
			end
		else
			if (following and myPos and myPos > instancia.rows_fit_in_window and instancia.barraS[2] < myPos) then
				for i = instancia.barraS[2]-1, instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
				
				conteudo[myPos]:RefreshLine (instancia, barras_container, whichRowLine, myPos, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
				whichRowLine = whichRowLine+1
			else
				for i = instancia.barraS[2], instancia.barraS[1], -1 do --> vai atualizar s� o range que esta sendo mostrado
					conteudo[i]:RefreshLine (instancia, barras_container, whichRowLine, i, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator) --> inst�ncia, index, total, valor da 1� barra
					whichRowLine = whichRowLine+1
				end
			end
		end
		
	end
	
	if (use_animations) then
		instancia:PerformAnimations (whichRowLine-1)
	end
	
	if (forcar) then
		if (instancia.modo == 2) then --> group
			for i = whichRowLine, instancia.rows_fit_in_window  do
				gump:Fade (instancia.barras [i], "in", 0.3)
			end
		end
	end

	return _detalhes:EndRefresh (instancia, total, tabela_do_combate, showing) --> retorna a tabela que precisa ganhar o refresh

end

function atributo_energy:RefreshLine (instancia, barras_container, whichRowLine, lugar, total, sub_atributo, forcar, keyName, combat_time, percentage_type, use_animations, bars_show_data, bars_brackets, bars_separator)

	local esta_barra = instancia.barras[whichRowLine] --> pega a refer�ncia da barra na janela
	
	if (not esta_barra) then
		print ("DEBUG: problema com <instancia.esta_barra> "..whichRowLine.." "..lugar)
		return
	end
	
	local tabela_anterior = esta_barra.minha_tabela
	
	esta_barra.minha_tabela = self
	esta_barra.colocacao = lugar
	
	self.minha_barra = esta_barra
	self.colocacao = lugar

	local esta_e_energy_total = self [keyName] --> total de dano que este jogador deu
	
--	local porcentagem = esta_e_energy_total / total * 100
	local porcentagem
	if (percentage_type == 1) then
		porcentagem = _cstr ("%.1f", esta_e_energy_total / total * 100)
	elseif (percentage_type == 2) then
		porcentagem = _cstr ("%.1f", esta_e_energy_total / instancia.top * 100)
	end

	local esta_porcentagem = _math_floor ((esta_e_energy_total/instancia.top) * 100)

	local formated_energy = SelectedToKFunction (_, esta_e_energy_total)

	if (not bars_show_data [1]) then
		formated_energy = ""
	end
	if (not bars_show_data [3]) then
		porcentagem = ""
	else
		porcentagem = porcentagem .. "%"
	end
	
	local rightText = formated_energy .. bars_brackets[1] .. porcentagem .. bars_brackets[2]
	if (UsingCustomRightText) then
		esta_barra.lineText4:SetText (_string_replace (instancia.row_info.textR_custom_text, formated_energy, "", porcentagem, self, instancia.showing, instancia, rightText))
	else
		if (instancia.use_multi_fontstrings) then
			Details:SetTextsOnLine(esta_barra, "", formated_energy, porcentagem)
		else
			esta_barra.lineText4:SetText (rightText)
		end
	end
	
	if (esta_barra.mouse_over and not instancia.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip (whichRowLine, esta_barra, instancia)
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, whichRowLine, barras_container, use_animations)
end

function atributo_energy:RefreshBarra2 (esta_barra, instancia, tabela_anterior, forcar, esta_porcentagem, whichRowLine, barras_container, use_animations)
	
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

function atributo_energy:RefreshBarra (esta_barra, instancia, from_resize)
	
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
	
	esta_barra.lineText1:SetSize (esta_barra:GetWidth() - esta_barra.lineText4:GetStringWidth() - 20, 15)
	
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------
function atributo_energy:KeyNames (sub_atributo)
	return "total"
end

---------> TOOLTIPS BIFURCA��O ~tooltip

local resource_bg_color = {.1, .1, .1, 0.6}
local resource_bg_coords = {.6, 0.1, 0, 0.64453125}

function atributo_energy:ToolTip (instancia, numero, barra, keydown)
	if (instancia.sub_atributo <= 4) then
		return self:ToolTipRegenRecebido (instancia, numero, barra, keydown)
		
	elseif (instancia.sub_atributo == 5) then --resources

		local resource_string = _detalhes.resource_strings [self.resource_type]
		if (resource_string) then
			local icon = _detalhes.resource_icons [self.resource_type]
	
			GameCooltip:AddLine (resource_string, floor (self.resource) .. " (" .. _cstr ("%.2f", self.resource / instancia.showing:GetCombatTime()) .. " per second)", 1, "white")
			GameCooltip:AddIcon (icon.file, 1, 1, 16, 16, unpack (icon.coords))
			GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], resource_bg_coords, resource_bg_color, true)
			
			return true
		end
	
	end
end

--> tooltip locals
local r, g, b
local barAlha = .6

local energy_tooltips_table = {}
local energy_tooltips_hash = {}

local reset_tooltips_table = function()
	for i = 1, #energy_tooltips_table do
		local t = energy_tooltips_table [i]
		t[1], t[2], t[3] = "", 0, ""
	end
	
	for k, v in _pairs (energy_tooltips_hash) do
		energy_tooltips_hash [k] = nil
	end
end

function atributo_energy:ToolTipRegenRecebido (instancia, numero, barra, keydown)
	
	reset_tooltips_table()
	
	local owner = self.owner
	if (owner and owner.classe) then
		r, g, b = unpack (_detalhes.class_colors [owner.classe])
	else
		r, g, b = unpack (_detalhes.class_colors [self.classe])
	end
	
	local powertype = self.powertype
	local tabela_do_combate = instancia.showing
	local container = tabela_do_combate [class_type] 
	local total_regenerado = self.received
	local name = self.nome
	
	--> spells:
	local i = 1
	
	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then
		
			for spellid, spell in _pairs (actor.spells._ActorTable) do
				local on_self = spell.targets [name]
				if (on_self) then
					local already_tracked = energy_tooltips_hash [spellid]
					if (already_tracked) then
						local t = energy_tooltips_table [already_tracked]
						t[2] = t[2] + on_self
					else
						local t = energy_tooltips_table [i]
						if (not t) then
							energy_tooltips_table [i] = {}
							t = energy_tooltips_table [i]
						end
						t[1], t[2], t[3] = spellid, on_self, ""
						energy_tooltips_hash [spellid] = i
						i = i + 1
					end
				end
			end
			
		end
	end
	
	i = i - 1
	_table_sort (energy_tooltips_table, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_SPELLS"], headerColor, i, [[Interface\HELPFRAME\ReportLagIcon-Spells]], 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_shift]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end
	
	local max = i
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end

	local icon_size = _detalhes.tooltip.icon_size
	local icon_border = _detalhes.tooltip.icon_border_texcoord	
	
	for o = 1, math.min (i, max) do
		local spell = energy_tooltips_table [o]
		
		if (spell [2] < 1) then
			break
		end
	
		local nome_magia, _, icone_magia = _GetSpellInfo (spell [1])
		GameCooltip:AddLine (nome_magia, FormatTooltipNumber (_,  spell [2]).." (".._cstr("%.1f", (spell [2]/total_regenerado) * 100).."%)")
		GameCooltip:AddIcon (icone_magia, nil, nil, icon_size.W, icon_size.H, icon_border.L, icon_border.R, icon_border.T, icon_border.B)
		_detalhes:AddTooltipBackgroundStatusbar (false, spell [2] / energy_tooltips_table [1][2] * 100)
	end
	
	--> players
	reset_tooltips_table()
	i = 1

	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then

			local on_self = actor.targets [name]
			if (on_self) then
				local t = energy_tooltips_table [i]
				if (not t) then
					energy_tooltips_table [i] = {}
					t = energy_tooltips_table [i]
				end
				t[1], t[2], t[3] = actor.nome, on_self, actor.classe
				i = i + 1
			end
			
		end
	end
	
	i = i - 1
	_table_sort (energy_tooltips_table, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (Loc ["STRING_PLAYERS"], headerColor, i, [[Interface\HELPFRAME\HelpIcon-HotIssues]], 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay2)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon ([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, _detalhes.tooltip_key_size_width, _detalhes.tooltip_key_size_height, 0, 1, 0, 0.640625, _detalhes.tooltip_key_overlay1)
		_detalhes:AddTooltipHeaderStatusbar (r, g, b, barAlha)
	end
	
	max = i
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end
	
	for o = 1, math.min (i, max) do
	
		local source = energy_tooltips_table [o]
	
		if (source [2] < 1) then
			break
		end
	
		GameCooltip:AddLine (source [1], FormatTooltipNumber (_,  source [2]).." (".._cstr("%.1f", (source [2] / total_regenerado) * 100).."%)")
		_detalhes:AddTooltipBackgroundStatusbar()
		
		local classe = source [3]
		if (not classe) then
			classe = "UNKNOW"
		end
		if (classe == "UNKNOW") then
			GameCooltip:AddIcon ("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, icon_size.W, icon_size.H, .25, .5, 0, 1)
		else
			GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, icon_size.W, icon_size.H, _unpack (_detalhes.class_coords [classe]))
		end
		
	end

	--> player generators
	local allGeneratorSpells = {}
	local allGenerated = 0
	for spellid, spellObject in _pairs (self.spells._ActorTable) do
		tinsert (allGeneratorSpells, {spellObject, spellObject.total, spellObject.totalover})
		allGenerated = allGenerated + spellObject.total
	end

	table.sort (allGeneratorSpells, _detalhes.Sort2)
	
	_detalhes:AddTooltipSpellHeaderText (self.nome .. " Generators", headerColor, #allGeneratorSpells, [[Interface\HELPFRAME\HelpIcon-HotIssues]], 0.21875, 0.78125, 0.21875, 0.78125)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
	
	for i = 1, #allGeneratorSpells do
		local thisGenerator = allGeneratorSpells [i]
		local spellName, _, spellIcon = GetSpellInfo (thisGenerator[1].id)
		GameCooltip:AddLine (spellName, FormatTooltipNumber (_,  thisGenerator[2]) .. " (|cFFFF5555overflow: " .. FormatTooltipNumber (_,  thisGenerator[3]) .. "|r | " .. _cstr ("%.1f", (thisGenerator[2] / allGenerated) * 100).."%)")
		GameCooltip:AddIcon (spellIcon, nil, nil, icon_size.W, icon_size.H, .1, .9, .1, .9)
		_detalhes:AddTooltipBackgroundStatusbar()
	end
	
	--auto regen overflow
	_detalhes:AddTooltipSpellHeaderText (self.nome .. " Auto Regen Overflow", headerColor, 1, [[Interface\CHARACTERFRAME\Disconnect-Icon]], 0.3, 0.7, 0.3, 0.7)
	_detalhes:AddTooltipHeaderStatusbar (r, g, b, 1)
	
	GameCooltip:AddLine ("Auto Regen Overflow", FormatTooltipNumber (_,  self.passiveover) .. " ( " .. _cstr ("%.1f",  self.passiveover / (self.passiveover + self.total) * 100)  .. "%)")
	GameCooltip:AddIcon ([[Interface\COMMON\Indicator-Red]], nil, nil, icon_size.W, icon_size.H)
	_detalhes:AddTooltipBackgroundStatusbar()
	
	return true
end

--------------------------------------------- // JANELA DETALHES // ---------------------------------------------

---------> DETALHES BIFURCA��O
function atributo_energy:MontaInfo()
	if (info.sub_atributo <= 4) then
		return self:MontaInfoRegenRecebido()
	end
end

---------> DETALHES bloco da direita BIFURCA��O
function atributo_energy:MontaDetalhes (spellid, barra)
	if (info.sub_atributo <= 4) then
		return self:MontaDetalhesRegenRecebido (spellid, barra)
	end
end

function atributo_energy:MontaInfoRegenRecebido()

	reset_tooltips_table()

	local barras = info.barras1
	local barras2 = info.barras2
	local barras3 = info.barras3
	
	local instancia = info.instancia

	local tabela_do_combate = instancia.showing
	local container = tabela_do_combate [class_type] 
	
	local total_regenerado = self.received
	local my_name = self.nome
	local powertype = self.powertype
	
	--> spells:
	local i = 1
	
	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then

			for spellid, spell in _pairs (actor.spells._ActorTable) do
				local on_self = spell.targets [my_name]

				if (on_self) then
					local already_tracked = energy_tooltips_hash [spellid]
					if (already_tracked) then
						local t = energy_tooltips_table [already_tracked]
						t[2] = t[2] + on_self
					else
						local t = energy_tooltips_table [i]
						if (not t) then
							energy_tooltips_table [i] = {}
							t = energy_tooltips_table [i]
						end
						t[1], t[2], t[3] = spellid, on_self, ""
						energy_tooltips_hash [spellid] = i
						i = i + 1
					end
				end
			end
			
		end
	end
	
	i = i - 1
	_table_sort (energy_tooltips_table, _detalhes.Sort2)
	
	
	local amt = i
	
	if (amt < 1) then
		return true
	end
	
	gump:JI_AtualizaContainerBarras (amt)
	local max_ = energy_tooltips_table [1][2]
	
	for index, tabela in _ipairs (energy_tooltips_table) do
		
		if (tabela [2] < 1) then
			break
		end
		
		local barra = barras [index]

		if (not barra) then
			barra = gump:CriaNovaBarraInfo1 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
			barra.on_focus = false
		end

		self:FocusLock (barra, tabela[1])
		
		local spellname, _, spellicon = _GetSpellInfo (tabela [1])
		local percent = tabela [2] / total_regenerado * 100
		
		self:UpdadeInfoBar (barra, index, tabela[1], spellname, tabela[2], _detalhes:comma_value (tabela[2]), max_, percent, spellicon, true)

		barra.minha_tabela = self
		barra.show = tabela[1]
		barra:Show()

		if (self.detalhes and self.detalhes == barra.show) then
			self:MontaDetalhes (self.detalhes, barra)
		end
		
	end
	
	--> players:

	reset_tooltips_table()
	i = 1

	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then

			local on_self = actor.targets [my_name]
			if (on_self) then
				local t = energy_tooltips_table [i]
				if (not t) then
					energy_tooltips_table [i] = {}
					t = energy_tooltips_table [i]
				end
				t[1], t[2], t[3] = actor.nome, on_self, actor.classe
				i = i + 1
			end
			
		end
	end
	
	i = i - 1
	_table_sort (energy_tooltips_table, _detalhes.Sort2)
	
	local amt_fontes = i
	gump:JI_AtualizaContainerAlvos (amt_fontes)
	
	local max_fontes = energy_tooltips_table[1][2]
	
	local barra
	for index, tabela in _ipairs (energy_tooltips_table) do
	
		if (tabela [2] < 1) then
			break
		end
	
		barra = info.barras2 [index]
		
		if (not barra) then
			barra = gump:CriaNovaBarraInfo2 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2]/max_fontes*100)
		end
		
		barra.lineText1:SetText (index..instancia.divisores.colocacao..tabela[1])
		barra.lineText4:SetText (_detalhes:comma_value (tabela[2]) .. " (" .. _cstr("%.1f", tabela[2]/total_regenerado * 100) .. ")")
		
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

		barra.minha_tabela = self
		
		--print ("nome_inimigo = ", tabela [1])
		barra.nome_inimigo = tabela [1]

		barra:Show()
	end	

end

function atributo_energy:MontaDetalhesRegenRecebido (nome, barra)

	for _, barra in _ipairs (info.barras3) do 
		barra:Hide()
	end
	
	reset_tooltips_table()
	
	local barras = info.barras3
	local instancia = info.instancia

	local tabela_do_combate = info.instancia.showing
	local container = tabela_do_combate [class_type]
	
	local total_regenerado = self.received
	
	local spellid = nome
	local who_name = self.nome
	
	--> who is regenerating with the spell -> nome
	
	--> spells:
	local i = 1
	
	for index, actor in _ipairs (container._ActorTable) do
		if (actor.powertype == powertype) then
			local spell = actor.spells._ActorTable [spellid]
			if (spell) then
				local on_self = spell.targets [who_name]
				if (on_self) then
					local t = energy_tooltips_table [i]
					if (not t) then
						energy_tooltips_table [i] = {}
						t = energy_tooltips_table [i]
					end
					t[1], t[2], t[3] = actor.nome, on_self, actor.classe
					i = i + 1
				end
			end
		end
	end
	
	i = i - 1
	
	if (i < 1) then
		return
	end
	
	_table_sort (energy_tooltips_table, _detalhes.Sort2)

	local max_ = energy_tooltips_table [1][2]
	
	local barra
	for index, tabela in _ipairs (from) do
	
		if (tabela [2] < 1) then
			break
		end
	
		barra = barras [index]

		if (not barra) then --> se a barra n�o existir, criar ela ent�o
			barra = gump:CriaNovaBarraInfo3 (instancia, index)
			barra.textura:SetStatusBarColor (1, 1, 1, 1)
		end
		
		if (index == 1) then
			barra.textura:SetValue (100)
		else
			barra.textura:SetValue (tabela[2] / max_ * 100)
		end

		barra.lineText1:SetText (index .. "." .. tabela [1])
		barra.lineText4:SetText (_detalhes:comma_value (tabela[2]) .." (" .. _cstr("%.1f", tabela[2] / total_regenerado * 100) .."%)")
		
		barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [tabela[3]]))
		barra.icone:SetTexture ("Interface\\AddOns\\Details\\images\\classes_small")
		
		barra.icone:SetTexCoord (_unpack (_detalhes.class_coords [tabela[3]]))

		barra:Show() --> mostra a barra
		
		if (index == 15) then 
			break
		end
	end
end

function atributo_energy:MontaTooltipAlvos (esta_barra, index)

	local instancia = info.instancia
	local tabela_do_combate = instancia.showing
	local container = tabela_do_combate [class_type] 
	
	local total_regenerado = self.received
	local my_name = self.nome
	
	reset_tooltips_table()
	
	-- actor nome
	
	local actor = container._ActorTable [container._NameIndexTable [esta_barra.nome_inimigo]]
	
	--print ("Mouse Over", actor, esta_barra.nome_inimigo, self.tipo)
	
	if (actor) then
		--> spells:
		local i = 1
		
		for spellid, spell in _pairs (actor.spells._ActorTable) do
			local on_self = spell.targets [my_name]
			if (on_self) then
				local t = energy_tooltips_table [i]
				if (not t) then
					energy_tooltips_table [i] = {}
					t = energy_tooltips_table [i]
				end
				t[1], t[2], t[3] = spellid, on_self, ""
				i = i + 1
			end
		end
		
		i = i - 1
		_table_sort (energy_tooltips_table, _detalhes.Sort2)
		
		--print (i, #energy_tooltips_table)
		
		for index, spell in _ipairs (energy_tooltips_table) do
			if (spell [2] < 1) then
				break
			end
			
			local spellname, _, spellicon = _GetSpellInfo (spell [1])
			GameTooltip:AddDoubleLine (spellname .. ": ", _detalhes:comma_value (spell [2]) .. " (" .. _cstr ("%.1f", (spell [2] / total_regenerado) * 100).."%)", 1, 1, 1, 1, 1, 1)
			GameTooltip:AddTexture (icone_magia)
		end
	end
	
	return true
end


--controla se o dps do jogador esta travado ou destravado
function atributo_energy:Iniciar (iniciar)
	return false --retorna se o dps esta aberto ou fechado para este jogador
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a funcao de abreviacao
		function atributo_energy:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions [_detalhes.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions [_detalhes.tooltip.abbreviation]
			TooltipMaximizedMethod = _detalhes.tooltip.maximize_method
			headerColor = _detalhes.tooltip.header_text_color
		end

	--> subtract total from a combat table
		function atributo_energy:subtract_total (combat_table)
			--print ("reduce total:", combat_table.totals [class_type] [self.powertype], self.total, self.powertype, self.nome)
			if (self.powertype and combat_table.totals [class_type] [self.powertype]) then
				combat_table.totals [class_type] [self.powertype] = combat_table.totals [class_type] [self.powertype] - self.total
				if (self.grupo) then
					combat_table.totals_grupo [class_type] [self.powertype] = combat_table.totals_grupo [class_type] [self.powertype] - self.total
				end
			end

		end
		function atributo_energy:add_total (combat_table)
			--print ("add total:", combat_table.totals [class_type] [self.powertype], self.total)
			if (self.powertype and combat_table.totals [class_type] [self.powertype]) then
				combat_table.totals [class_type] [self.powertype] = combat_table.totals [class_type] [self.powertype] + self.total
				
				if (self.grupo) then
					combat_table.totals_grupo [class_type] [self.powertype] = combat_table.totals_grupo [class_type] [self.powertype] + self.total
				end
			end
		end
		
	--> restaura e liga o ator com a sua shadow durante a inicializa��o
	
		function atributo_energy:r_onlyrefresh_shadow (actor)
		
			--> criar uma shadow desse ator se ainda n�o tiver uma
				local overall_energy = _detalhes.tabela_overall [3]
				local shadow = overall_energy._ActorTable [overall_energy._NameIndexTable [actor.nome]]

				if (not shadow) then 
					shadow = overall_energy:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
					
					shadow.classe = actor.classe
					shadow.spec = actor.spec
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.isTank = actor.isTank
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component
					
				end
			
			--> restaura a meta e indexes ao ator
				_detalhes.refresh:r_atributo_energy (actor, shadow)
				shadow.powertype = actor.powertype
				
				if (actor.resource) then
					shadow.resource = (shadow.resource or 0) + actor.resource
					shadow.resource_type = actor.resource_type
				end
			
			--> targets
				for target_name, amount in _pairs (actor.targets) do 
					shadow.targets [target_name] = 0
				end
			
			--> spells
				for spellid, habilidade in _pairs (actor.spells._ActorTable) do 
					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, "SPELL_ENERGY", false)
					--> spell targets
					for target_name, amount in _pairs (habilidade.targets) do 
						habilidade_shadow.targets [target_name] = 0
					end
				end

			return shadow
		end
	
		function atributo_energy:r_connect_shadow (actor, no_refresh, combat_object)
		
			local host_combat = combat_object or _detalhes.tabela_overall
		
			--> criar uma shadow desse ator se ainda n�o tiver uma
				local overall_energy = host_combat [3]
				local shadow = overall_energy._ActorTable [overall_energy._NameIndexTable [actor.nome]]

				if (not shadow) then 
					shadow = overall_energy:PegarCombatente (actor.serial, actor.nome, actor.flag_original, true)
					
					shadow.classe = actor.classe
					shadow.spec = actor.spec
					shadow.grupo = actor.grupo
					shadow.pvp = actor.pvp
					shadow.isTank = actor.isTank
					shadow.boss = actor.boss
					shadow.boss_fight_component = actor.boss_fight_component
					shadow.fight_component = actor.fight_component
					
				end
			
			--> restaura a meta e indexes ao ator
				if (not no_refresh) then
					_detalhes.refresh:r_atributo_energy (actor, shadow)
				end
			
			--> pets (add unique pet names)
			for _, petName in _ipairs (actor.pets) do
				DetailsFramework.table.addunique (shadow.pets, petName)
			end
			
			--> total das energias (captura de dados)
				shadow.total = shadow.total + actor.total
				shadow.received = shadow.received + actor.received
				shadow.alternatepower = shadow.alternatepower + actor.alternatepower
				
				if (not actor.powertype) then
					--print ("actor without powertype", actor.nome, actor.powertype)
					actor.powertype = 1
				end
				
				shadow.powertype = actor.powertype
				
				if (actor.resource) then
					shadow.resource = (shadow.resource or 0) + actor.resource
					shadow.resource_type = actor.resource_type
				end
			
			--> total no combate overall (captura de dados)
				host_combat.totals[3] [actor.powertype] = host_combat.totals[3] [actor.powertype] + actor.total
				
				if (actor.grupo) then
					host_combat.totals_grupo[3][actor.powertype] = host_combat.totals_grupo[3][actor.powertype] + actor.total
				end

			--> targets
				for target_name, amount in _pairs (actor.targets) do 
					shadow.targets [target_name] = (shadow.targets [target_name] or 0) + amount
				end
			
			--> spells
				for spellid, habilidade in _pairs (actor.spells._ActorTable) do 

					local habilidade_shadow = shadow.spells:PegaHabilidade (spellid, true, "SPELL_ENERGY", false)
					
					habilidade_shadow.total = habilidade_shadow.total + habilidade.total
					habilidade_shadow.counter = habilidade_shadow.counter + habilidade.counter
					
					--> spell targets
					for target_name, amount in _pairs (habilidade.targets) do 
						habilidade_shadow.targets [target_name] = (habilidade_shadow.targets [target_name] or 0) + amount
					end

				end

			return shadow
		end

function atributo_energy:ColetarLixo (lastevent)
	return _detalhes:ColetarLixo (class_type, lastevent)
end

function _detalhes.refresh:r_atributo_energy (este_jogador, shadow)
	_setmetatable (este_jogador, _detalhes.atributo_energy)
	este_jogador.__index = _detalhes.atributo_energy

	_detalhes.refresh:r_container_habilidades (este_jogador.spells, shadow and shadow.spells)

	if (shadow and not shadow.powertype) then
		shadow.powertype = este_jogador.powertype
	end	
end

function _detalhes.clear:c_atributo_energy (este_jogador)
	este_jogador.__index = nil
	este_jogador.shadow = nil
	este_jogador.links = nil
	este_jogador.minha_barra = nil
	
	_detalhes.clear:c_container_habilidades (este_jogador.spells)
end

atributo_energy.__add = function (tabela1, tabela2)

	if (not tabela1.powertype) then
		tabela1.powertype = tabela2.powertype
	end
	
	if (tabela1.resource) then
		tabela1.resource = tabela1.resource + (tabela2.resource or 0)
	end

	--> total and received
		tabela1.total = tabela1.total + tabela2.total
		tabela1.received = tabela1.received + tabela2.received
		tabela1.alternatepower = tabela1.alternatepower + tabela2.alternatepower
	
	--> targets
		for target_name, amount in _pairs (tabela2.targets) do 
			tabela1.targets [target_name] = (tabela1.targets [target_name] or 0) + amount
		end
	
	--> spells
		for spellid, habilidade in _pairs (tabela2.spells._ActorTable) do 

			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_ENERGY", false)
			
			habilidade_tabela1.total = habilidade_tabela1.total + habilidade.total
			habilidade_tabela1.counter = habilidade_tabela1.counter + habilidade.counter
			
			--> spell targets
			for target_name, amount in _pairs (habilidade.targets) do 
				habilidade_tabela1.targets [target_name] = (habilidade_tabela1.targets [target_name] or 0) + amount
			end

		end
	
	return tabela1
end

atributo_energy.__sub = function (tabela1, tabela2)

	if (not tabela1.powertype) then
		tabela1.powertype = tabela2.powertype
	end
	
	if (tabela1.resource) then
		tabela1.resource = tabela1.resource - (tabela2.resource or 0)
	end

	--> total and received
		tabela1.total = tabela1.total - tabela2.total
		tabela1.received = tabela1.received - tabela2.received
		tabela1.alternatepower = tabela1.alternatepower - tabela2.alternatepower
	
	--> targets
		for target_name, amount in _pairs (tabela2.targets) do 
			if (tabela1.targets [target_name]) then
				tabela1.targets [target_name] = tabela1.targets [target_name] - amount
			end
		end
	
	--> spells
		for spellid, habilidade in _pairs (tabela2.spells._ActorTable) do 

			local habilidade_tabela1 = tabela1.spells:PegaHabilidade (spellid, true, "SPELL_ENERGY", false)
			
			habilidade_tabela1.total = habilidade_tabela1.total - habilidade.total
			habilidade_tabela1.counter = habilidade_tabela1.counter - habilidade.counter
			
			--> spell targets
			for target_name, amount in _pairs (habilidade.targets) do 
				if (habilidade_tabela1.targets [target_name]) then
					habilidade_tabela1.targets [target_name] = habilidade_tabela1.targets [target_name] - amount
				end
			end

		end

	return tabela1
end

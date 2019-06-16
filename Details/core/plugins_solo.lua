
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _pairs = pairs --lua locals
	local _math_floor = math.floor --lua locals

	local _UnitAura = UnitAura
	local _
	
	local gump = _detalhes.gump --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local modo_alone = _detalhes._detalhes_props["MODO_ALONE"]
	local modo_grupo = _detalhes._detalhes_props["MODO_GROUP"]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions	

	--> When a combat start
	function _detalhes:UpdateSolo()
		local SoloInstance = _detalhes.tabela_instancias[_detalhes.solo]
		_detalhes.SoloTables.CombatIDLast = _detalhes.SoloTables.CombatID
		_detalhes.SoloTables.CombatID = _detalhes:NumeroCombate()
		_detalhes.SoloTables.Attribute = SoloInstance.atributo
	end

	function _detalhes:CreateSoloCloseButton()
	
		local plugin, frame = self, self.Frame
		local button = CreateFrame ("Button", nil, frame, "UIPanelCloseButton")
		
		button:SetScript ("OnClick", function()
			if (not button.close_confirmation) then
				button.close_confirmation = gump:CreateSimplePanel (button, 296, 60, "", plugin.real_name .. "CloseConfirmation")
				button.close_confirmation:SetPoint ("center", frame, 0, 0)
				_G [button.close_confirmation:GetName() .. "TitleBar"]:Hide()
				local fade_background = button.close_confirmation:CreateTexture (nil, "background")
				fade_background:SetPoint ("topleft", frame, 0, 0)
				fade_background:SetPoint ("bottomright", frame, 0, 0)
				fade_background:SetTexture (0, 0, 0, 0.7)
				
				local close_func = function()
					local instance = plugin:GetPluginInstance()
					instance:ShutDown()
					button.close_confirmation:Hide()
				end
				local group_func = function()
					local instance = plugin:GetPluginInstance()
					instance:AlteraModo (instance, DETAILS_MODE_GROUP)
					button.close_confirmation:Hide()
					
					instance.baseframe.cabecalho.modo_selecao:GetScript ("OnEnter")(instance.baseframe.cabecalho.modo_selecao)
				end
				
				local close_window = gump:NewButton (button.close_confirmation, nil, "$parentCloseWindowButton", "CloseWindowButton", 140, 20, close_func, nil, nil, nil, Loc ["STRING_MENU_CLOSE_INSTANCE"], 1, gump:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
				local back_to_group_and_raid = gump:NewButton (button.close_confirmation, nil, "$parentBackToGroupButton", "BackToGroupButton", 140, 20, group_func, nil, nil, nil, Loc ["STRING_SWITCH_TO"] .. ": " .. Loc ["STRING_MODE_GROUP"], 2, gump:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
				
				close_window:SetIcon ([[Interface\Buttons\UI-Panel-MinimizeButton-Up]], nil, nil, nil, {0.143125, 0.8653125, 0.1446875, 0.8653125}, nil, nil, 2)
				back_to_group_and_raid:SetIcon ([[Interface\AddOns\Details\images\modo_icones]], nil, nil, nil, {32/256, 32/256*2, 0, 1}, nil, nil, 2)
				
				close_window:SetPoint ("topleft", 3, -4)
				close_window:SetPoint ("bottomright", -3, 31)
				back_to_group_and_raid:SetPoint ("topleft", 3, -31)
				back_to_group_and_raid:SetPoint ("bottomright", -3, 4)
			end
			
			button.close_confirmation:Show()
		end)
		
		button:SetWidth (20)
		button:SetHeight (20)
		--button:GetNormalTexture():SetDesaturated (true)
		return button
	end
	
	--> enable and disable Solo Mode for an Instance
	function _detalhes:SoloMode (show)
		if (show) then
		
			--> salvar a janela normal
			if (self.mostrando ~= "solo") then --> caso o addon tenha ligado ja no painel solo, n�o precisa rodar isso aqui
				self:SaveMainWindowPosition()

				if (self.rolagem) then
					self:EsconderScrollBar() --> hida a scrollbar
				end
				self.need_rolagem = false

				self.baseframe:EnableMouseWheel (false)
				gump:Fade (self, 1, nil, "barras") --> escondendo a janela da inst�ncia [inst�ncia [force hide [velocidade [hidar o que]]]]
				self.mostrando = "solo"
			end
			
			_detalhes.SoloTables.instancia = self
			
			--> default plugin
			if (not _detalhes.SoloTables.built) then
				gump:PrepareSoloMode (self)
			end
			
			self.modo = _detalhes._detalhes_props["MODO_ALONE"]
			_detalhes.solo = self.meu_id
			--self:AtualizaSliderSolo (0)

			if (not self.posicao.solo.w) then --> primeira vez que o solo mode � executado nessa inst�ncia
				self.baseframe:SetWidth (300)
				self.baseframe:SetHeight (300)
				self:SaveMainWindowPosition()
			else
				self:RestoreMainWindowPosition()
				local w, h = self:GetSize()
				if (w ~= 300 or h ~= 300) then
					self.baseframe:SetWidth (300)
					self.baseframe:SetHeight (300)
					self:SaveMainWindowPosition()
				end
			end
			
			local first_enabled_plugin, first_enabled_plugin_index
			for index, plugin in ipairs (_detalhes.SoloTables.Plugins) do
				if (plugin.__enabled) then
					first_enabled_plugin = plugin
					first_enabled_plugin_index = index
				end
			end
			
			if (not first_enabled_plugin) then
				_detalhes:WaitForSoloPlugin (self)
			else
				if (not _detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode]) then
					_detalhes.SoloTables.Mode = first_enabled_plugin_index
				end
				_detalhes.SoloTables:switch (nil, _detalhes.SoloTables.Mode)
			end

		else
		
			--print ("--------------------------------")
			--print (debugstack())
		
			if (_detalhes.PluginCount.SOLO > 0) then
				local solo_frame = _detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame
				if (solo_frame) then
					_detalhes.SoloTables:switch()
				end
			end

			_detalhes.solo = nil --> destranca a janela solo para ser usada em outras  inst�ncias
			self.mostrando = "normal"
			self:RestoreMainWindowPosition()
			
			if (_G.DetailsWaitForPluginFrame:IsShown()) then
				_detalhes:CancelWaitForPlugin()
			end

			gump:Fade (self, 1, nil, "barras")
			gump:Fade (self.scroll, 0)
			
			if (self.need_rolagem) then
				self:MostrarScrollBar (true)
			else
				--> precisa verificar se ele precisa a rolagem certo?
				self:ReajustaGump()
			end
			
			--> calcula se existem barras, etc...
			if (not self.rows_fit_in_window) then --> as barras n�o forma iniciadas ainda
				self.rows_fit_in_window = _math_floor (self.baseframe.BoxBarrasAltura / self.row_height)
				if (self.rows_created < self.rows_fit_in_window) then
					for i  = #self.barras+1, self.rows_fit_in_window do
						local nova_barra = gump:CriaNovaBarra (self, i, 30) --> cria nova barra
						nova_barra.texto_esquerdo:SetText (Loc ["STRING_NEWROW"])
						nova_barra.statusbar:SetValue (100) 
						self.barras [i] = nova_barra
					end
					self.rows_created = #self.barras
				end
			end
		end
	end

	function _detalhes.SoloTables:EnableSoloMode (instance, plugin_name, from_cooltip)
	
		--> check if came from cooltip
		if (from_cooltip) then
			self = _detalhes.SoloTables
			instance = plugin_name
			plugin_name = from_cooltip
		end
		
		instance:SoloMode (true)
		
		_detalhes.SoloTables:switch (nil, plugin_name)
	end
	
	--> Build Solo Mode Tables and Functions
	function gump:PrepareSoloMode (instancia)

		_detalhes.SoloTables.built = true

		_detalhes.SoloTables.SpellCastTable = {} --> not used
		_detalhes.SoloTables.TimeTable = {} --> not used

		_detalhes.SoloTables.Mode = _detalhes.SoloTables.Mode or 1 --> solo mode
		
		function _detalhes.SoloTables:GetActiveIndex()
			return _detalhes.SoloTables.Mode
		end
		
		function _detalhes.SoloTables:switch (_, _switchTo)

			--> just hide all
			if (not _switchTo) then 
				if (#_detalhes.SoloTables.Plugins > 0) then --> have at least one plugin
					_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame:Hide()
				end
				return
			end
			
			--> if passed the absolute plugin name
			if (type (_switchTo) == "string") then
				for index, ptable in ipairs (_detalhes.SoloTables.Menu) do 
					if (ptable [3].__enabled and ptable [4] == _switchTo) then
						_switchTo = index
						break
					end
				end
				
			elseif (_switchTo == -1) then
				_switchTo = _detalhes.SoloTables.Mode + 1
				if (_switchTo > #_detalhes.SoloTables.Plugins) then
					_switchTo = 1
				end
			end
		
			local ThisFrame = _detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode]
			if (not ThisFrame or not ThisFrame.__enabled) then
				--> frame not found, try in few second again
				_detalhes.SoloTables.Mode = _switchTo
				_detalhes:WaitForSoloPlugin (instancia)
				return
			end
		
			--> hide current frame
			_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame:Hide()
			--> switch mode
			_detalhes.SoloTables.Mode = _switchTo
			--> show and setpoint new frame

			_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame:Show()
			_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame:SetPoint ("TOPLEFT",_detalhes.SoloTables.instancia.bgframe)
			_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].Frame:SetFrameLevel (20)
			
			_detalhes.SoloTables.instancia:ChangeIcon (_detalhes.SoloTables.Menu [_detalhes.SoloTables.Mode] [2])
			
			_detalhes.SoloTables.Plugins [_detalhes.SoloTables.Mode].instance_id = _detalhes.SoloTables.instancia:GetId()
			
			_detalhes:SendEvent ("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, _detalhes.SoloTables.instancia, _detalhes.SoloTables.instancia.atributo, _detalhes.SoloTables.instancia.sub_atributo)

		end
		
		return true
	end

	function _detalhes:CloseSoloDebuffs()
		local SoloDebuffUptime = _detalhes.tabela_vigente.SoloDebuffUptime
		if (not SoloDebuffUptime) then
			return
		end
		
		for SpellId, DebuffTable in _pairs (SoloDebuffUptime) do
			if (DebuffTable.start) then
				DebuffTable.duration = DebuffTable.duration + (_detalhes._tempo - DebuffTable.start) --> time do parser ser� igual ao time()?
				DebuffTable.start = nil
			end
			DebuffTable.Active = false
		end
	end

	--> Buffs ter� em todos os Solo Modes
	function _detalhes.SoloTables:CatchBuffs()
		--> reset bufftables
		_detalhes.SoloTables.SoloBuffUptime = _detalhes.SoloTables.SoloBuffUptime or {}
		
		for spellname, BuffTable in _pairs (_detalhes.SoloTables.SoloBuffUptime) do
			--local BuffEntryTable = _detalhes.SoloTables.BuffTextEntry [BuffTable.tableIndex]
			
			if (BuffTable.Active) then
				BuffTable.start = _detalhes._tempo
				BuffTable.castedAmt = 1
				BuffTable.appliedAt = {}
				--BuffEntryTable.backgroundFrame:Active()
			else
				BuffTable.start = nil
				BuffTable.castedAmt = 0
				BuffTable.appliedAt = {}
				--BuffEntryTable.backgroundFrame:Desactive()
			end
			
			BuffTable.duration = 0
			BuffTable.refreshAmt = 0
			BuffTable.droppedAmt = 0
		end
		
		--> catch buffs untracked yet
		for buffIndex = 1, 41 do
			local name = _UnitAura ("player", buffIndex)
			if (name) then
				for index, BuffName in _pairs (_detalhes.SoloTables.BuffsTableNameCache) do
					if (BuffName == name) then
						local BuffObject = _detalhes.SoloTables.SoloBuffUptime [name]
						if (not BuffObject) then
							_detalhes.SoloTables.SoloBuffUptime [name] = {name = name, duration = 0, start = nil, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true, tableIndex = index, appliedAt = {}}
						end
					end
				end
			end
		end
	end

	function _detalhes:InstanciaCheckForDisabledSolo (instancia)

		if (not instancia) then
			instancia = self
		end
		
		
		if (instancia.modo == modo_alone) then
			--print ("arrumando a instancia "..instancia.meu_id)
			if (instancia.iniciada) then
				_detalhes:AlteraModo (instancia, modo_grupo)
				instancia:SoloMode (false)
				_detalhes:ResetaGump (instancia)
			else
				instancia.modo = modo_grupo
				instancia.last_modo = modo_grupo
			end
		end
	end

	function _detalhes:AtualizaSoloMode_AfertReset (instancia)
		if (_detalhes.SoloTables.CombatIDLast) then
			_detalhes.SoloTables.CombatIDLast = nil
		end
		if (_detalhes.SoloTables.CombatID) then
			_detalhes.SoloTables.CombatID = 0
		end
	end

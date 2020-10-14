do
	local _detalhes = _G._detalhes
	local DetailsFrameWork = _detalhes.gump
	local AceLocale = LibStub ("AceLocale-3.0")
	local Loc = AceLocale:GetLocale ("Details_EncounterDetails")
	local Graphics = LibStub:GetLibrary("LibGraph-2.0")
	local _ipairs = ipairs
	local _math_floor = math.floor
	local _cstr = string.format
	local _GetSpellInfo = _detalhes.getspellinfo
	local _
	
	local AurasButtonTemplate = {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.3, .3, .3, .5},
		onentercolor = {1, 1, 1, .5},
		backdropbordercolor = {0, 0, 0, 1},
	}
	
	local PhaseButtonTemplate = {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.7, .7, .7, .5},
		onentercolor = {1, 1, 1, .5},
		backdropbordercolor = {0, 0, 0, 1},
	}
	local PhaseButtonTemplateHighlight = {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.7, .7, .7, .5},
		onentercolor = {1, 1, 1, .5},
		backdropbordercolor = {.70, .70, .70, 1},
	}
	local PhaseButtonTemplateSelected = {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.7, .7, .7, .5},
		onentercolor = {1, 1, 1, .5},
		backdropbordercolor = {.9, .7, 0, 1},
	}	
	
	local set_backdrop = function (frame)
		frame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tileSize = 64, tile = true})
		frame:SetBackdropColor (0, 0, 0, .2)
		frame:SetBackdropBorderColor (0, 0, 0, 1)
	end
	
	local BGColorDefault = {0.5, 0.5, 0.5, 0.3}
	local BGColorDefault_Hover = {0.5, 0.5, 0.5, 0.7}
	local BackdropDefault = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}
	
_detalhes.EncounterDetailsTempWindow = function (EncounterDetails)
	
	--> options panel
	
	EncounterDetails.SetBarBackdrop_OnEnter = function (self)
		self:SetBackdropColor (unpack (BGColorDefault_Hover))
	end
	EncounterDetails.SetBarBackdrop_OnLeave = function (self)
		self:SetBackdropColor (unpack (BGColorDefault))
	end
	
	function EncounterDetails:AutoShowIcon()
		local found_boss = false
		for _, combat in ipairs (EncounterDetails:GetCombatSegments()) do 
			if (combat.is_boss) then
				EncounterDetails:ShowIcon()
				found_boss = true
			end
		end
		if (EncounterDetails:GetCurrentCombat().is_boss) then
			EncounterDetails:ShowIcon()
			found_boss = true
		end
		if (not found_boss) then
			EncounterDetails:HideIcon()
		end
	end
	
	local build_options_panel = function()
	
		local options_frame = EncounterDetails:CreatePluginOptionsFrame ("EncounterDetailsOptionsWindow", "Encounter Breakdown Options", 2)
		
		-- 1 = only when inside a raid map
		-- 2 = only when in raid group
		-- 3 = only after a boss encounter
		-- 4 = always show
		-- 5 = automatic show when have at least 1 encounter with boss
		
		local set = function (_, _, value) 
			EncounterDetails.db.show_icon = value 
			if (value == 1) then
				if (EncounterDetails:GetZoneType() == "raid") then
					EncounterDetails:ShowIcon()
				else
					EncounterDetails:HideIcon()
				end
			elseif (value == 2) then
				if (EncounterDetails:InGroup()) then
					EncounterDetails:ShowIcon()
				else
					EncounterDetails:HideIcon()
				end
			elseif (value == 3) then
				if (EncounterDetails:GetCurrentCombat().is_boss) then
					EncounterDetails:ShowIcon()
				else
					EncounterDetails:HideIcon()
				end
			elseif (value == 4) then
				EncounterDetails:ShowIcon()
			elseif (value == 5) then
				EncounterDetails:AutoShowIcon()
			end
		end
		local on_show_menu = {
			{value = 1, label = "Inside Raid", onclick = set, desc = "Only show the icon while inside a raid."},
			{value = 2, label = "In Group", onclick = set, desc = "Only show the icon while in group."},
			{value = 3, label = "After Encounter", onclick = set, desc = "Show the icon after a raid boss encounter."},
			{value = 4, label = "Always", onclick = set, desc = "Always show the icon."},
			{value = 5, label = "Auto", onclick = set, desc = "The plugin decides when the icon needs to be shown."},
		}
		
--		/dump DETAILS_PLUGIN_ENCOUNTER_DETAILS.db.show_icon
		
		local menu = {
			{
				type = "select",
				get = function() return EncounterDetails.db.show_icon end,
				values = function() return on_show_menu end,
				desc = "When the icon is shown in the Details! tooltip.",
				name = "Show Icon"
			},
			{
				type = "toggle",
				get = function() return EncounterDetails.db.hide_on_combat end,
				set = function (self, fixedparam, value) EncounterDetails.db.hide_on_combat = value end,
				desc = "Encounter Breakdown window automatically close when you enter in combat.",
				name = "Hide on Combat"
			},
			{
				type = "range",
				get = function() return EncounterDetails.db.max_emote_segments end,
				set = function (self, fixedparam, value) EncounterDetails.db.max_emote_segments = value end,
				min = 1,
				max = 10,
				step = 1,
				desc = "Keep how many segments emotes.",
				name = "Emote Segments Amount",
				usedecimals = true,
			},
			{
				type = "range",
				get = function() return EncounterDetails.db.window_scale end,
				set = function (self, fixedparam, value) EncounterDetails.db.window_scale = value; EncounterDetails:RefreshScale() end,
				min = 0.65,
				max = 1.50,
				step = 0.1,
				desc = "Set the window size",
				name = "Window Scale",
				usedecimals = true,
			},
			
		}
		
		DetailsFrameWork:BuildMenu (options_frame, menu, 15, -75, 260)
		
	end
	
	EncounterDetails.OpenOptionsPanel = function()
		if (not EncounterDetailsOptionsWindow) then
			build_options_panel()
		end
		EncounterDetailsOptionsWindow:Show()
	end
	
	function EncounterDetails:RefreshScale()
		local scale = EncounterDetails.db.window_scale
		if (EncounterDetails.Frame) then
			EncounterDetails.Frame:SetScale (scale)
		end
	end	
	
	function EncounterDetails:CreateRowTexture (row)
		row.textura = CreateFrame ("StatusBar", nil, row, "BackdropTemplate")
		row.textura:SetAllPoints (row)
		local t = row.textura:CreateTexture (nil, "overlay")
		t:SetTexture (EncounterDetails.Frame.DefaultBarTexture)

		row.t = t
		row.textura:SetStatusBarTexture (t)
		row.textura:SetStatusBarColor (.5, .5, .5, 0)
		row.textura:SetMinMaxValues (0,100)
		
		row.lineText1 = row.textura:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
		row.lineText1:SetPoint ("LEFT", row.textura, "LEFT", 22, -1)
		row.lineText1:SetJustifyH ("LEFT")
		row.lineText1:SetTextColor (1,1,1,1)

		row.lineText4 = row.textura:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
		row.lineText4:SetPoint ("RIGHT", row.textura, "RIGHT", -2, 0)
		row.lineText4:SetJustifyH ("RIGHT")
		row.lineText4:SetTextColor (1,1,1,1)
		
		row.textura:Show()
	end
	
	function EncounterDetails:CreateRow (index, container, x_mod, y_mod, width_mod)
		
		local barra = CreateFrame ("Button", "Details_"..container:GetName().."_barra_"..index, container,"BackdropTemplate")
		
		x_mod = x_mod or 0
		width_mod = width_mod or 0
		
		local default_height = EncounterDetails.Frame.DefaultBarHeight
		
		barra:SetWidth (200 + width_mod) --> tamanho da barra de acordo com o tamanho da janela
		barra:SetHeight (default_height) --> altura determinada pela inst�ncia
		
		local y = (index-1)*(default_height + 1)
		y_mod = y_mod or 0
		y = y + y_mod
		y = y*-1 --> baixo
		
		barra:SetPoint ("LEFT", container, "LEFT", x_mod, 0)
		barra:SetPoint ("RIGHT", container, "RIGHT", width_mod, 0)
		barra:SetPoint ("TOP", container, "TOP", 0, y)
		barra:SetFrameLevel (container:GetFrameLevel() + 1)
		
		barra:EnableMouse (true)
		barra:RegisterForClicks ("LeftButtonDown","RightButtonUp")	
		
		EncounterDetails:CreateRowTexture (barra)
		
		barra:SetBackdrop (BackdropDefault)
		EncounterDetails.SetBarBackdrop_OnLeave (barra)
		
		--> icone
		barra.icone = barra.textura:CreateTexture (nil, "OVERLAY")
		barra.icone:SetWidth (default_height)
		barra.icone:SetHeight (default_height)
		barra.icone:SetPoint ("RIGHT", barra.textura, "LEFT", 20, 0)
		
		barra:SetAlpha (0.9)
		barra.icone:SetAlpha (0.8)
		
		EncounterDetails:SetRowScripts (barra, index, container)
		
		container.barras [index] = barra
		
		return barra
	end	
	
	function EncounterDetails:JB_AtualizaContainer (container, amt, barras_total)
		barras_total = barras_total or 6
		if (amt >= barras_total and container.ultimo ~= amt) then
			local tamanho = (EncounterDetails.Frame.DefaultBarHeight + 1) * amt
			container:SetHeight (tamanho)
			container.window.slider:Update()
			container.window.ultimo = amt
		elseif (amt <= barras_total-1 and container.slider.ativo) then
			container.window.slider:Update (true)
			container:SetHeight (140)
			container.window.scroll_ativo = false
			container.window.ultimo = 0
		end
	end
	
	local grafico_cores = {{1, 1, 1, 1}, {1, 0.5, 0.3, 1}, {0.75, 0.7, 0.1, 1}, {0.2, 0.9, 0.2, 1}, {0.2, 0.5, 0.9, 1}}
	
	local lastBoss = nil
	EncounterDetails.CombatsAlreadyDrew = {}
	
	local CONST_CHART_WIDTH = 870
	local CONST_CHART_HEIGHT = 485
	local CONST_PHASE_PANEL_WIDTH = 451
	local CONST_PHASE_BAR_HEIGHT = 16
	local CONST_CHART_LENGTH = 810
	local CONST_CHART_TIMELINE_X_POSITION = 75
	local CONST_CHART_TIMELINE_Y_POSITION = -550
	local CONST_CHART_DAMAGELINE_X_POSITION = 27
	local CONST_DAMAGE_LINES_COLOR = {1, 1, 1, .05}
	local CONST_CHART_MAX_DEATHS_ICONS = 6
	
	function EncounterDetails:BuildDpsGraphic()
		
		local segment = EncounterDetails._segment
		
		local g
		
		if (not _G.DetailsRaidDpsGraph) then
			EncounterDetails:CreateGraphPanel()
			g = _G.DetailsRaidDpsGraph
		else
			g = _G.DetailsRaidDpsGraph
		end
		g:ResetData()
		
		local combat = EncounterDetails:GetCombat (segment)
		local graphicData = combat:GetTimeData ("Raid Damage Done")
		
		if (not graphicData or not combat.start_time or not combat.end_time) then
			EncounterDetails:Msg ("This segment doesn't have chart data.")
			return
		--elseif (EncounterDetails.CombatsAlreadyDrew [combat:GetCombatNumber()]) then
			--return
		end
		
		if (graphicData.max_value == 0) then
			return
		end
		
		--> battle time
		if (combat.end_time - combat.start_time < 12) then
			return
		end
		
		--EncounterDetails.Frame.linhas = EncounterDetails.Frame.linhas or 0
		EncounterDetails.Frame.linhas = 1
		
		if (EncounterDetails.Frame.linhas > 5) then
			EncounterDetails.Frame.linhas = 1
		end
		
		g.max_damage = 0
		
		for _, line in ipairs (g.VerticalLines) do
			line:Hide()
		end
		
		lastBoss = combat.is_boss and combat.is_boss.index
		
		--
		if (not segment) then
			return
		end
		for i = segment + 4, segment+1, -1 do
			local combat = EncounterDetails:GetCombat (i)
			if (combat) then --the combat exists
				local elapsed_time = combat:GetCombatTime()
				
				if (EncounterDetails.debugmode and not combat.is_boss) then
					combat.is_boss = {
						index = 1, 
						name = _detalhes:GetBossName (1098, 1),
						zone = "Throne of Thunder", 
						mapid = 1098, 
						encounter = "Jin'Rohk the Breaker"
					}
				end
				
				if (elapsed_time > 12 and combat.is_boss and combat.is_boss.index == lastBoss) then --is the same boss
				
					local chart_data = combat:GetTimeData ("Raid Damage Done")
					if (chart_data and chart_data.max_value and chart_data.max_value > 0) then --have a chart data
						--if (not EncounterDetails.CombatsAlreadyDrew [combat:GetCombatNumber()]) then --isn't drew yet
							EncounterDetails:DrawSegmentGraphic (g, chart_data, combat)
							--EncounterDetails.CombatsAlreadyDrew [combat:GetCombatNumber()] = true
						--end
					end
				end
			end
		end
		
		g:ClearPhaseTexture()
		local phase_data = combat.PhaseData
		local scale = CONST_CHART_LENGTH / combat:GetCombatTime()
		
		for i = 1, #phase_data do
			local phase = phase_data[i][1]
			local start_at = phase_data[i][2]
			local texture = g:GetPhaseTexture (i, phase)
			
			texture:SetPoint ("bottomleft", g, "bottomleft", (start_at * scale) + 58, 0)
			texture.phase = phase
			texture.start_at = start_at
			
			local next_phase = phase_data[i+1]
			if (next_phase) then
				local duration = next_phase [2] - start_at
				texture:SetWidth (scale * duration)
				texture.elapsed = duration
			else
				local duration = combat:GetCombatTime() - start_at
				texture:SetWidth (scale * duration)
				texture.elapsed = duration
			end
		end
		
		g.combat = combat
		
		--
		
		EncounterDetails:DrawSegmentGraphic (g, graphicData, combat, combat)
		EncounterDetails.CombatsAlreadyDrew [combat:GetCombatNumber()] = true
		
		g:Show()
		
	end	
	
	function EncounterDetails:DrawSegmentGraphic (g, graphicData, combat, drawDeathsCombat)
		
		local _data = {}
		local dps_max = graphicData.max_value or 0
		local amount = #graphicData
		
		local scaleW = 1/670
		
		local content = graphicData
		tinsert (content, 1, 0)
		tinsert (content, 1, 0)
		tinsert (content, #content+1, 0)
		tinsert (content, #content+1, 0)
		
		local _i = 3
		
		local graphMaxDps = math.max (g.max_damage, dps_max)
		while (_i <= #content-2) do 
			local v = (content[_i-2]+content[_i-1]+content[_i]+content[_i+1]+content[_i+2])/5 --> normalize
			_data [#_data+1] = {scaleW*(_i-2), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
		
		tremove (content, 1)
		tremove (content, 1)
		tremove (content, #graphicData)
		tremove (content, #graphicData)
		
		--> update timeline
		local tempo = combat.end_time - combat.start_time
		if (g.max_time < tempo) then 
			g.max_time = tempo

			local tempo_divisao = g.max_time / 8
			
			for i = 1, 8, 1 do
				local t = tempo_divisao*i
				local minutos, segundos = _math_floor (t/60), _math_floor (t%60)
				if (segundos < 10) then
					segundos = "0"..segundos
				end
				if (minutos < 10) then
					minutos = "0"..minutos
				end
				EncounterDetails.Frame["timeamt"..i]:SetText (minutos..":"..segundos)
			end
		end
		
		--> normalize previous data
		if (dps_max > g.max_damage) then 
			if (g.max_damage > 0) then
				local normalizePercent = g.max_damage / dps_max
				for dataIndex, Data in ipairs (g.Data) do 
					local Points = Data.Points
					for i = 1, #Points do 
						Points[i][2] = Points[i][2]*normalizePercent
					end
				end
			end
			
			g.max_damage = dps_max
			
			local dano_divisao = g.max_damage/8
			
			--> update damage line
			local o = 1
			for i = 8, 1, -1 do
				local d = _detalhes:ToK (dano_divisao*i)
				EncounterDetails.Frame["dpsamt"..o]:SetText (d)
				o = o + 1
			end
			
		end
		
		if (#g.Data == 5) then
			table.remove (g.Data, 5)
		end
		
		g:AddDataSeriesOnFirstIndex (_data, grafico_cores [1])
		
		for i = 2, #g.Data do 
			g:ChangeColorOnDataSeries (i, grafico_cores [i])
		end

		--> add death icons for the first deaths in the segment
		if (drawDeathsCombat) then
			local mortes = drawDeathsCombat.last_events_tables
			local scaleG = CONST_CHART_LENGTH / drawDeathsCombat:GetCombatTime()
			
			for _, row in _ipairs (g.VerticalLines) do 
				row:Hide()
			end
			
			for i = 1, math.min (CONST_CHART_MAX_DEATHS_ICONS, #mortes) do 
			
				local vRowFrame = g.VerticalLines [i]
				
				if (not vRowFrame) then
				
					vRowFrame = CreateFrame ("frame", "DetailsEncountersVerticalLine"..i, g, "BackdropTemplate")
					vRowFrame:SetWidth (20)
					vRowFrame:SetHeight (43)
					vRowFrame:SetFrameLevel (g:GetFrameLevel()+2)
					
					vRowFrame:SetScript ("OnEnter", function (frame) 
						
						if (vRowFrame.dead[1] and vRowFrame.dead[1][3] and vRowFrame.dead[1][3][2]) then
						
							GameCooltip:Reset()
							
							--time of death and player name
							GameCooltip:AddLine (vRowFrame.dead[6].." "..vRowFrame.dead[3])
							local class, l, r, t, b = _detalhes:GetClass (vRowFrame.dead[3])
							if (class) then
								GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, 12, 12, l, r, t, b)
							end
							GameCooltip:AddLine ("")
							
							--last hits:
							local death = vRowFrame.dead
							local amt = 0
							for i = #death[1], 1, -1 do
								local this_hit = death[1][i]
								if (type (this_hit[1]) == "boolean" and this_hit[1]) then
									local spellname, _, spellicon = _GetSpellInfo (this_hit[2])
									local t = death [2] - this_hit [4]
									GameCooltip:AddLine ("-" .. _cstr ("%.1f", t) .. " " .. spellname .. " (" .. this_hit[6] .. ")", EncounterDetails:comma_value (this_hit [3]))
									GameCooltip:AddIcon (spellicon, 1, 1, 12, 12, 0.1, 0.9, 0.1, 0.9)
									amt = amt + 1
									if (amt == 3) then
										break
									end
								end
							end
							
							GameCooltip:SetOption ("TextSize", 9.5)
							GameCooltip:SetOption ("HeightAnchorMod", -15)
							
							GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
							GameCooltip:ShowCooltip (frame, "tooltip")
						end
					end)
					
					vRowFrame:SetScript ("OnLeave", function (frame) 
						_detalhes.popup:ShowMe (false)
					end)

					vRowFrame.texture = vRowFrame:CreateTexture (nil, "overlay")
					vRowFrame.texture:SetTexture ("Interface\\AddOns\\Details\\images\\verticalline")
					vRowFrame.texture:SetWidth (3)
					vRowFrame.texture:SetHeight (20)
					vRowFrame.texture:SetPoint ("center", "DetailsEncountersVerticalLine"..i, "center")
					vRowFrame.texture:SetPoint ("bottom", "DetailsEncountersVerticalLine"..i, "bottom", 0, 0)
					vRowFrame.texture:SetVertexColor (1, 1, 1, .5)

					vRowFrame.icon = vRowFrame:CreateTexture (nil, "overlay")
					vRowFrame.icon:SetTexture ("Interface\\WorldStateFrame\\SkullBones")
					vRowFrame.icon:SetTexCoord (0.046875, 0.453125, 0.046875, 0.46875)
					vRowFrame.icon:SetWidth (16)
					vRowFrame.icon:SetHeight (16)
					vRowFrame.icon:SetPoint ("center", "DetailsEncountersVerticalLine"..i, "center")
					vRowFrame.icon:SetPoint ("bottom", "DetailsEncountersVerticalLine"..i, "bottom", 0, 20)

					g.VerticalLines [i] = vRowFrame
				end
				
				local deadTime = mortes [i].dead_at
				vRowFrame:SetPoint ("topleft", EncounterDetails.Frame, "topleft", (deadTime*scaleG)+70, -CONST_CHART_HEIGHT-22)
				vRowFrame.dead = mortes [i]
				vRowFrame:Show()
				
			end
		end
	end
	
	--~chart ~graphic ~grafico
	function EncounterDetails:CreateGraphPanel()
	
		--> main chart frame
			local g = Graphics:CreateGraphLine ("DetailsRaidDpsGraph", EncounterDetails.Frame, "topleft", "topleft", 20, -76, CONST_CHART_WIDTH, CONST_CHART_HEIGHT)
			g:SetXAxis (-1,1)
			g:SetYAxis (-1,1)
			g:SetGridSpacing (false, false)
			g:SetGridColor ({0.5,0.5,0.5,0.3})
			g:SetAxisDrawing (false,false)
			g:SetAxisColor({1.0,1.0,1.0,1.0})
			g:SetAutoScale (true)
			--g:SetLineTexture ("smallline")
			g:SetLineTexture([[Interface\AddOns\Details_EncounterDetails\images\line.tga]])
			g:SetBorderSize ("right", 0.001)
			g.VerticalLines = {}
			g.TryIndicator = {}
			g.PhaseTextures = {}
			
			local phase_alpha = 0.5
			local phase_colors = {{0.2, 1, 0.2, phase_alpha}, {1, 1, 0.2, phase_alpha}, {1, 0.2, 0.2, phase_alpha}, {0.2, 1, 1, phase_alpha}, {0.2, 0.2, 1, phase_alpha},
				[1.5] = {0.25, 0.95, 0.25, phase_alpha}, [2.5] = {0.95, 0.95, 0.25, phase_alpha}, [3.5] = {0.95, 0.25, 0.25, phase_alpha}
			}
		
		--> build the phase panel
			local phase_panel = CreateFrame ("frame", "EncounterDetailsPhasePanel", g, "BackdropTemplate")
			phase_panel:SetFrameStrata ("TOOLTIP")
			phase_panel:SetWidth (CONST_PHASE_PANEL_WIDTH)
			phase_panel:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
				edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize = 32,
				insets = {left = 1, right = 1, top = 1, bottom = 1}})
			phase_panel:SetBackdropColor (0, 0, 0, .4)
			
			local damage_icon = DetailsFrameWork:CreateImage (phase_panel, [[Interface\AddOns\Details\images\skins\classic_skin_v1]], 16, 16, "overlay", {11/1024, 24/1024, 376/1024, 390/1024})
			local damage_label = DetailsFrameWork:CreateLabel (phase_panel, "Damage Done:")
			damage_icon:SetPoint ("topleft", phase_panel, "topleft", 10, -10)
			damage_label:SetPoint ("left", damage_icon, "right", 4, 0)
			
			local heal_icon = DetailsFrameWork:CreateImage (phase_panel, [[Interface\AddOns\Details\images\skins\classic_skin_v1]], 16, 16, "overlay", {43/1024, 57/1024, 376/1024, 390/1024})
			local heal_label = DetailsFrameWork:CreateLabel (phase_panel, "Healing Done:")
			heal_icon:SetPoint ("topleft", phase_panel, "topleft", 250, -10)
			heal_label:SetPoint ("left", heal_icon, "right", 4, 0)
			
			phase_panel.damage_labels = {}
			phase_panel.heal_labels = {}
			
			function phase_panel:ClearLabels()
				for i, label in ipairs (phase_panel.damage_labels) do
					label.lefttext:Hide()
					label.righttext:Hide()
					label.icon:Hide()
					label.bg:Hide()
				end
				for i, label in ipairs (phase_panel.heal_labels) do
					label.lefttext:Hide()
					label.righttext:Hide()
					label.icon:Hide()
					label.bg:Hide()
				end
			end
			
			function phase_panel:GetDamageLabel (index)
				local label = phase_panel.damage_labels [index]
				if (not label) then
					local player_name = DetailsFrameWork:CreateLabel (phase_panel, "")
					local amount = DetailsFrameWork:CreateLabel (phase_panel, "")
					amount:SetJustifyH ("right")
					local icon = DetailsFrameWork:CreateImage (phase_panel, "", 16, 16)
					local bg = DetailsFrameWork:CreateImage (phase_panel, [[Interface\AddOns\Details\images\BantoBar]], nil, nil, "artwork")
					bg:SetPoint ("left", icon, "left"); bg.height = 16; bg:SetPoint ("right", amount, "right"); bg:SetVertexColor (.2, .2, .2, 0.8)
					
					icon:SetPoint ("topleft", phase_panel, "topleft", 10, ((index * 16) * -1) - 16)
					player_name:SetPoint ("left", icon, "right", 2, 0)
					amount:SetPoint ("topright", phase_panel, "topleft", 200, ((index * 16) * -1) - 16)
					
					label = {lefttext = player_name, righttext = amount, icon = icon, bg = bg}
					phase_panel.damage_labels [index] = label
				end
				return label
			end
			
			function phase_panel:GetHealLabel (index)
				local label = phase_panel.heal_labels [index]
				if (not label) then
					local player_name = DetailsFrameWork:CreateLabel (phase_panel, "")
					local amount = DetailsFrameWork:CreateLabel (phase_panel, "")
					amount:SetJustifyH ("right")
					local icon = DetailsFrameWork:CreateImage (phase_panel, "", 16, 16)
					local bg = DetailsFrameWork:CreateImage (phase_panel, [[Interface\AddOns\Details\images\BantoBar]], nil, nil, "artwork")
					bg:SetPoint ("left", icon, "left"); bg.height = 16; bg:SetPoint ("right", amount, "right"); bg:SetVertexColor (.2, .2, .2, 0.8)
					
					icon:SetPoint ("topleft", phase_panel, "topleft", 250, ((index * 16) * -1) - 16)
					player_name:SetPoint ("left", icon, "right", 2, 0)
					amount:SetPoint ("topright", phase_panel, "topleft", 440, ((index * 16) * -1) - 16)
					
					label = {lefttext = player_name, righttext = amount, icon = icon, bg = bg}
					phase_panel.heal_labels [index] = label
				end
				return label
			end
			
			phase_panel.phase_label = DetailsFrameWork:CreateLabel (phase_panel, "")
			phase_panel.time_label = DetailsFrameWork:CreateLabel (phase_panel, "")
			phase_panel.report_label = DetailsFrameWork:CreateLabel (phase_panel, "|cFFffb400Left Click|r: Report Damage |cFFffb400Right Click|r: Report Heal")
			
			phase_panel.phase_label:SetPoint ("bottomleft", phase_panel, "bottomleft", 10, 5)
			phase_panel.time_label:SetPoint ("left", phase_panel.phase_label, "right", 5, 0)
			phase_panel.report_label:SetPoint ("bottomright", phase_panel, "bottomright", -10, 5)
			
			local bg = DetailsFrameWork:CreateImage (phase_panel, [[Interface\Tooltips\UI-Tooltip-Background]], nil, nil, "artwork")
			bg:SetPoint ("left", phase_panel.phase_label, "left"); 
			bg.height = 16; 
			bg:SetPoint ("right", phase_panel.report_label, "right"); 
			bg:SetVertexColor (0, 0, 0, 1)
			
			local spark_container = {}
			local create_spark = function()
				local t = phase_panel:CreateTexture (nil, "overlay")
				t:SetTexture ([[Interface\CastingBar\UI-CastingBar-Spark]])
				t:SetBlendMode ("ADD")
				t:Hide()
				tinsert (spark_container, t)
			end
			local get_spark = function (index)
				local spark = spark_container [index]
				if (not spark) then
					create_spark()
					spark = spark_container [index]
				end
				spark:ClearAllPoints()
				return spark
			end
			local hide_sparks = function()
				for _, spark in ipairs (spark_container) do
					spark:Hide()
				end
			end
		
			local phase_on_enter = function (self)

				local spark1 = get_spark (1)
				local spark2 = get_spark (2)
				self.texture:SetBlendMode ("ADD")
				spark1:SetPoint ("left", self.texture, "left", -16, 0)
				spark2:SetPoint ("right", self.texture, "right", 16, 0)
				spark1:Show()
				spark2:Show()
				
				local phase = self.phase
				local spark_index = 3
				
				self.texture:SetVertexColor (1, 1, 1)
				
				for _, f in ipairs (g.PhaseTextures) do
					if (f ~= self and f.phase == phase) then
						local spark1 = get_spark (spark_index)
						local spark2 = get_spark (spark_index+1)
						f.texture:SetBlendMode ("ADD")
						f.texture:SetVertexColor (1, 1, 1)
						spark1:SetPoint ("left", f.texture, "left", -16, 0)
						spark2:SetPoint ("right", f.texture, "right", 16, 0)
						spark1:Show()
						spark2:Show()
						spark_index = spark_index + 2
					end
				end
				
				local combat = DetailsRaidDpsGraph.combat
				if (combat) then
				
					phase_panel:ClearLabels()
				
					--damage
					local players = {}
					for player_name, damage in pairs (combat.PhaseData.damage [self.phase]) do
						tinsert (players, {player_name, damage})
					end
					table.sort (players, _detalhes.Sort2)
					
					for i, player in ipairs (players) do
						local dlabel = phase_panel:GetDamageLabel (i)
						dlabel.lefttext.text = EncounterDetails:GetOnlyName (player [1])
						dlabel.righttext.text = _detalhes:ToK (_math_floor (player [2]))
						
						local class = EncounterDetails:GetClass (player [1])
						local spec = EncounterDetails:GetSpec (player [1])
						
						if (spec) then
							dlabel.icon.texture = [[Interface\AddOns\Details\images\spec_icons_normal]]
							dlabel.icon.texcoord = EncounterDetails.class_specs_coords [spec]
						
						elseif (class) then
							dlabel.icon.texture = [[Interface\AddOns\Details\images\classes_small_alpha]]
							dlabel.icon.texcoord = _detalhes.class_coords [class]
							
						else
							dlabel.icon.texture = [[Interface\LFGFRAME\LFGROLE_BW]]
							dlabel.icon:SetTexCoord (.25, .5, 0, 1)
						end
						
						dlabel.lefttext:Show()
						dlabel.righttext:Show()
						dlabel.icon:Show()
						dlabel.bg:Show()
					end
					
					local damage_players = #players
					self.damage_actors = players
					
					--heal
					local players = {}
					for player_name, heal in pairs (combat.PhaseData.heal [self.phase]) do
						tinsert (players, {player_name, heal})
					end
					table.sort (players, _detalhes.Sort2)
					
					for i, player in ipairs (players) do
						local hlabel = phase_panel:GetHealLabel (i)
						hlabel.lefttext.text = EncounterDetails:GetOnlyName (player [1])
						hlabel.righttext.text = _detalhes:ToK (_math_floor (player [2]))
						
						local classe = _detalhes:GetClass (player [1])
						if (classe) then	
							hlabel.icon:SetTexture ([[Interface\AddOns\Details\images\classes_small_alpha]])
							hlabel.icon:SetTexCoord (unpack (_detalhes.class_coords [classe]))
						else
							hlabel.icon:SetTexture ([[Interface\LFGFRAME\LFGROLE_BW]])
							hlabel.icon:SetTexCoord (.25, .5, 0, 1)
						end
						
						hlabel.lefttext:Show()
						hlabel.righttext:Show()
						hlabel.icon:Show()
						hlabel.bg:Show()
					end

					local heal_players = #players
					self.heal_actors = players
					
					--show the panel
					phase_panel:SetHeight ((math.max (damage_players, heal_players) * 16) + 60)
					phase_panel:SetPoint ("bottom", self, "top", 0, 10)
					phase_panel:Show()
					
					phase_panel.phase_label.text = "|cFFffb400Phase|r: " .. self.phase

					local m, s = _math_floor (self.elapsed / 60), _math_floor (self.elapsed % 60)
					phase_panel.time_label.text = "|cFFffb400Elapsed|r: " .. m .. "m " .. s .. "s"

				end
				
			end
			local phase_on_leave = function (self)
				table.wipe (self.damage_actors)
				table.wipe (self.heal_actors)
				
				for _, f in ipairs (g.PhaseTextures) do
					f.texture:SetBlendMode ("BLEND")
					f.texture:SetVertexColor (unpack (f.texture.original_color))
				end
				
				hide_sparks()
				phase_panel:Hide()
			end
			
			local phase_on_click = function (self, button)
				if (button == "LeftButton") then
				
					local result = {}
					local reportFunc = function (IsCurrent, IsReverse, AmtLines)
						AmtLines = AmtLines + 1
						if (#result > AmtLines) then
							for i = #result, AmtLines+1, -1 do
								tremove (result, i)
							end
						end
						EncounterDetails:SendReportLines (result)
					end
					
					--need to build here because the mouse will leave the block to click in the send button
					tinsert (result, "Details!: Damage for Phase " .. self.phase .. " of " .. (g.combat and g.combat.is_boss and g.combat.is_boss.name or "Unknown") .. ":")
					for i = 1, #self.damage_actors do
						tinsert (result, EncounterDetails:GetOnlyName (self.damage_actors[i][1]) .. ": " .. _detalhes:ToK (_math_floor (self.damage_actors [i][2])))
					end
					EncounterDetails:SendReportWindow (reportFunc, nil, nil, true)
					
				elseif (button == "RightButton") then
					
					local result = {}
					local reportFunc = function (IsCurrent, IsReverse, AmtLines)
						AmtLines = AmtLines + 1
						if (#result > AmtLines) then
							for i = #result, AmtLines+1, -1 do
								tremove (result, i)
							end
						end
						EncounterDetails:SendReportLines (result)
					end
					
					tinsert (result, "Details!: Healing for Phase " .. self.phase .. " of " .. (g.combat and g.combat.is_boss and g.combat.is_boss.name or "Unknown") .. ":")
					for i = 1, #self.heal_actors do
						tinsert (result, EncounterDetails:GetOnlyName (self.heal_actors[i][1]) .. ": " .. _detalhes:ToK (_math_floor (self.heal_actors [i][2])))
					end
					EncounterDetails:SendReportWindow (reportFunc, nil, nil, true)
					
				end
			end
		
			function g:GetPhaseTexture (index, phase)
			
				local texture = g.PhaseTextures [index]
				
				if (not texture) then
					local f = CreateFrame ("frame", "EncounterDetailsPhaseTexture" .. index, g, "BackdropTemplate")
					f:SetHeight (CONST_PHASE_BAR_HEIGHT)
					
					local t = f:CreateTexture (nil, "artwork")
					t:SetAllPoints()
					t:SetColorTexture (1, 1, 1, phase_alpha)
					t.original_color = {1, 1, 1}
					f.texture = t

					f:SetScript ("OnEnter", phase_on_enter)
					f:SetScript ("OnLeave", phase_on_leave)
					f:SetScript ("OnMouseUp", phase_on_click)
					
					texture = f
					tinsert (g.PhaseTextures, f)
				end
				
				texture:ClearAllPoints()
				
				phase = math.min (phase, 5)
				if (not phase_colors [phase]) then
					_detalhes:Msg ("Phase out of range:", phase)
					phase = math.max (phase, 1)
				end

				texture.texture:SetVertexColor (unpack (phase_colors [phase]))
				local oc = texture.texture.original_color
				oc[1], oc[2], oc[3] = unpack (phase_colors [phase])
				
				texture:Show()
				
				return texture
			end
			
			function g:ClearPhaseTexture()
				for i, texture in pairs (g.PhaseTextures) do
					texture:Hide()
				end
			end
		
		--> chart frame implementations
		
			function g:ChangeColorOnDataSeries (index, color)
				self.Data [index].Color = color
				self.NeedsUpdate=true
			end
				
			function g:AddDataSeriesOnFirstIndex (points, color, n2)
				local data
				--Make sure there is data points
				if not points then
					return
				end

				data=points
				if n2==nil then
					n2=false
				end
				if n2 or (table.getn(points)==2 and table.getn(points[1])~=2) then
					data={}
					for k,v in ipairs(points[1]) do
						tinsert(data,{v,points[2][k]})
					end
				end
				
				table.insert (self.Data, 1, {Points=data;Color=color})
				
				self.NeedsUpdate=true
			end

			DetailsFrameWork:NewLabel (EncounterDetails.Frame, EncounterDetails.Frame, nil, "phases_string", "phases:", "GameFontHighlightSmall")
			EncounterDetails.Frame["phases_string"]:SetPoint ("TOPLEFT", EncounterDetails.Frame, "TOPLEFT", 20, CONST_CHART_TIMELINE_Y_POSITION)
			
			DetailsFrameWork:NewLabel (EncounterDetails.Frame, EncounterDetails.Frame, nil, "timeamt0", "00:00", "GameFontHighlightSmall")
			EncounterDetails.Frame["timeamt0"]:SetPoint ("TOPLEFT", EncounterDetails.Frame, "TOPLEFT", 85, CONST_CHART_TIMELINE_Y_POSITION)

			--> create lines for damage and time
			for i = 1, 8, 1 do
				local line = g:CreateTexture (nil, "overlay")
				line:SetColorTexture (unpack (CONST_DAMAGE_LINES_COLOR))
				line:SetWidth (CONST_CHART_WIDTH)
				line:SetHeight (1)
				
				DetailsFrameWork:NewLabel (EncounterDetails.Frame, EncounterDetails.Frame, nil, "dpsamt"..i, "", "GameFontHighlightSmall")
				EncounterDetails.Frame["dpsamt"..i]:SetPoint ("TOPLEFT", EncounterDetails.Frame, "TOPLEFT", CONST_CHART_DAMAGELINE_X_POSITION, -61 + (-( (CONST_CHART_HEIGHT / 9) *i )))
				line:SetPoint ("topleft", EncounterDetails.Frame["dpsamt"..i].widget, "bottom", -27, 0)
				
				DetailsFrameWork:NewLabel (EncounterDetails.Frame, EncounterDetails.Frame, nil, "timeamt"..i, "", "GameFontHighlightSmall")
				EncounterDetails.Frame["timeamt"..i].widget:SetPoint ("TOPLEFT", EncounterDetails.Frame, "TOPLEFT", CONST_CHART_TIMELINE_X_POSITION + ( (CONST_CHART_WIDTH / 9) * i ), CONST_CHART_TIMELINE_Y_POSITION + 1)
			end
			
			g.max_time = 0
			g.max_damage = 0
			
			EncounterDetails.MaxGraphics = EncounterDetails.MaxGraphics or 5
			
			--> fight segments at the top right corner
			for i = 1, EncounterDetails.MaxGraphics do 
				local texture = g:CreateTexture (nil, "overlay")
				texture:SetWidth (9)
				texture:SetHeight (9)
				texture:SetPoint ("TOPLEFT", EncounterDetails.Frame, "TOPLEFT", (i*65) + 499, -81)
				texture:SetColorTexture (unpack (grafico_cores[i]))
				local text = g:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
				text:SetPoint ("LEFT", texture, "right", 2, 0)
				text:SetJustifyH ("LEFT")
				if (i == 1) then
					text:SetText (Loc ["STRING_CURRENT"])
				else
					text:SetText (Loc ["STRING_TRY"] .. " #" .. i)
				end
				g.TryIndicator [#g.TryIndicator+1] = {texture = texture, text = text}
			end
			
			--> vertical line at the left side
			local v = g:CreateTexture (nil, "overlay")
			v:SetWidth (1)
			v:SetHeight (CONST_CHART_HEIGHT + 1)
			v:SetPoint ("top", g, "top", 0, 1)
			v:SetPoint ("left", g, "left", CONST_CHART_DAMAGELINE_X_POSITION + 30, 0) --> leave 30 pixels for the damage text
			v:SetColorTexture (1, 1, 1, 1)
			
			--> horizontal line at the bottom side
			local h = g:CreateTexture (nil, "overlay")
			h:SetWidth (CONST_CHART_WIDTH)
			h:SetHeight (1)
			h:SetPoint ("top", g, "top", 0, -CONST_CHART_HEIGHT + CONST_PHASE_BAR_HEIGHT*2)
			h:SetPoint ("left", g, "left")
			h:SetColorTexture (1, 1, 1, 1)
	end
	
	-- ~start ~main ~frame ~baseframe ~bossframe
	local BossFrame = EncounterDetails.Frame
	local DetailsFrameWork = _detalhes.gump

	BossFrame:SetFrameStrata ("HIGH")
	BossFrame:SetToplevel (true)
	
	BossFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
	BossFrame:SetBackdropColor (.5, .5, .5, .5)
	BossFrame:SetBackdropBorderColor (0, 0, 0, 1)
	
	-- ~size
		BossFrame:SetWidth (898) -- + 200
		BossFrame:SetHeight (504) -- + 150
		
		BossFrame:EnableMouse (true)
		BossFrame:SetResizable (false)
		BossFrame:SetMovable (true)
	
	--background
	BossFrame.bg1 = BossFrame:CreateTexture (nil, "background")
	BossFrame.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
	BossFrame.bg1:SetAlpha (0.7)
	BossFrame.bg1:SetVertexColor (0.27, 0.27, 0.27)
	BossFrame.bg1:SetVertTile (true)
	BossFrame.bg1:SetHorizTile (true)
	BossFrame.bg1:SetSize (790, 454)
	BossFrame.bg1:SetAllPoints()
	
	--title bar
		local titlebar = CreateFrame ("frame", nil, BossFrame,"BackdropTemplate")
		titlebar:SetPoint ("topleft", BossFrame, "topleft", 2, -3)
		titlebar:SetPoint ("topright", BossFrame, "topright", -2, -3)
		titlebar:SetHeight (20)
		titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
		titlebar:SetBackdropColor (.5, .5, .5, 1)
		titlebar:SetBackdropBorderColor (0, 0, 0, 1)

		local name_bg_texture = BossFrame:CreateTexture (nil, "background")
		name_bg_texture:SetTexture ([[Interface\PetBattles\_PetBattleHorizTile]], true)
		name_bg_texture:SetHorizTile (true)
		name_bg_texture:SetTexCoord (0, 1, 126/256, 19/256)
		name_bg_texture:SetPoint ("topleft", BossFrame, "topleft", 2, -22)
		name_bg_texture:SetPoint ("bottomright", BossFrame, "bottomright")
		name_bg_texture:SetHeight (54)
		name_bg_texture:SetVertexColor (0, 0, 0, 0.2)
	
	--> header background
		local headerFrame = CreateFrame ("frame", "EncounterDetailsHeaderFrame", BossFrame,"BackdropTemplate")
		headerFrame:EnableMouse (false)
		headerFrame:SetPoint ("topleft", titlebar, "bottomleft", 0, -1)
		headerFrame:SetPoint ("topright", titlebar, "bottomright", 0, -1)
		headerFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
		headerFrame:SetBackdropColor (.7, .7, .7, .4)
		headerFrame:SetBackdropBorderColor (0, 0, 0, 0)
		headerFrame:SetHeight (48)
	
	--window title
		local titleLabel = DetailsFrameWork:NewLabel (titlebar, titlebar, nil, "titulo", Loc ["STRING_WINDOW_TITLE"], "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
		titleLabel:SetPoint ("center", BossFrame, "center")
		titleLabel:SetPoint ("top", BossFrame, "top", 0, -7)
	
	--> Nome do Encontro
		DetailsFrameWork:NewLabel (headerFrame, headerFrame, nil, "boss_name", "Unknown Encounter", "QuestFont_Large")
		BossFrame.boss_name = headerFrame.boss_name
		BossFrame.boss_name:SetPoint ("TOPLEFT", BossFrame, "TOPLEFT", 100, -46)
		
	--> Nome da Raid
		DetailsFrameWork:NewLabel (headerFrame, headerFrame, nil, "raid_name", "Unknown Raid", "GameFontHighlightSmall")
		BossFrame.raid_name = headerFrame.raid_name
		BossFrame.raid_name:SetPoint ("CENTER", BossFrame.boss_name, "CENTER", 0, 14)
	
	--> icone da classe no canto esquerdo superior
		BossFrame.boss_icone = headerFrame:CreateTexture (nil, "overlay")
		BossFrame.boss_icone:SetPoint ("TOPLEFT", BossFrame, "TOPLEFT", 9, -24)
		BossFrame.boss_icone:SetWidth (46)
		BossFrame.boss_icone:SetHeight (46)
	
	----
	
	BossFrame:SetScript ("OnMouseDown", 
					function (self, botao)
						if (botao == "LeftButton") then
							self:StartMoving()
							self.isMoving = true
						elseif (botao == "RightButton" and not self.isMoving) then
							EncounterDetails:CloseWindow()
						end
					end)
					
	BossFrame:SetScript ("OnMouseUp", 
					function (self)
						if (self.isMoving) then
							self:StopMovingOrSizing()
							self.isMoving = false
						end
					end)
	
	BossFrame:SetPoint ("CENTER", UIParent)
	
	--> imagem de fundo
		BossFrame.raidbackground = BossFrame:CreateTexture (nil, "BORDER")
		BossFrame.raidbackground:SetPoint ("TOPLEFT", BossFrame, "TOPLEFT", 0, -74)
		BossFrame.raidbackground:SetPoint ("bottomright", BossFrame, "bottomright", 0, 0)
		BossFrame.raidbackground:SetDrawLayer ("BORDER", 2)
		BossFrame.raidbackground:SetAlpha (0.1)
	
	--> bot�o fechar
		titlebar.CloseButton = CreateFrame ("Button", nil, titlebar, "UIPanelCloseButton")
		titlebar.CloseButton:SetWidth (20)
		titlebar.CloseButton:SetHeight (20)
		titlebar.CloseButton:SetPoint ("TOPRIGHT", BossFrame, "TOPRIGHT", -2, -3)
		titlebar.CloseButton:SetText ("X")
		titlebar.CloseButton:SetScript ("OnClick", function(self) 
						EncounterDetails:CloseWindow()
					end)
		titlebar.CloseButton:SetFrameLevel (titlebar:GetFrameLevel()+2)
		titlebar.CloseButton:GetNormalTexture():SetDesaturated (true)
	
	--> background completo

	BossFrame.Widgets = {}
	
	BossFrame.ShowType = "main"

	--> revisar
	BossFrame.Reset = function()
		BossFrame.switch (nil, nil, "main")
		if (_G.DetailsRaidDpsGraph) then 
			_G.DetailsRaidDpsGraph:ResetData()
		end
		if (BossFrame.aberta) then
			_detalhes:FecharEncounterWindows()
		end
		BossFrame.linhas = nil
	end
	
	local scrollframe
	local emote_segment = 1
	local searching
	
	local hide_Graph = function()
		if (_G.DetailsRaidDpsGraph) then 
			_G.DetailsRaidDpsGraph:Hide()
			for i = 1, 8, 1 do
				BossFrame["dpsamt"..i]:Hide()
				BossFrame["timeamt"..i]:Hide()
			end
			BossFrame["timeamt0"]:Hide()
			BossFrame["phases_string"]:Hide()
		end
	end
	
	local hide_Emote = function()
		--hide emote frames
		for _, widget in pairs (BossFrame.EmoteWidgets) do
			widget:Hide()
		end
	end
	
	local hide_WeakAuras = function()
		--hide spells frames
		for _, widget in pairs (BossFrame.EnemySpellsWidgets) do
			widget:Hide()
		end
	end
	
	local hide_Summary = function()
		--hide boss frames
		for _, frame in _ipairs (BossFrame.Widgets) do 
			frame:Hide()
		end
	end
	
	local resetSelectedButtonTemplate = function()
		BossFrame.buttonSwitchNormal:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		BossFrame.buttonSwitchSpellsAuras:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		BossFrame.buttonSwitchPhases:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		BossFrame.buttonSwitchGraphic:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		BossFrame.buttonSwitchBossEmotes:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	end

	BossFrame.switch = function (to, _, to2)
		if (type (to) == "string") then
			to = to
		elseif (type (to2) == "string") then
			to = to2
		end
		
		if (not BossFrame:IsShown()) then
			Details:OpenPlugin ("DETAILS_PLUGIN_ENCOUNTER_DETAILS")
		end
		
		EncounterDetailsPhaseFrame:Hide()
		resetSelectedButtonTemplate()
		
		if (to == "main") then 
			BossFrame.raidbackground:Show()

			for _, frame in _ipairs (BossFrame.Widgets) do
				frame:Show()
			end
			
			hide_Graph()
			hide_Emote()
			hide_WeakAuras()

			BossFrame.ShowType = "main"
			BossFrame.segmentosDropdown:Enable()
			
			BossFrame.buttonSwitchNormal:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))

			EncounterDetails.db.last_section_selected = BossFrame.ShowType
		
		elseif (to == "spellsauras") then
		
			_detalhes:SetTutorialCVar ("ENCOUNTER_BREAKDOWN_SPELLAURAS", true)
			if (EncounterDetails.Frame.buttonSwitchSpellsAuras.AntsFrame) then
				EncounterDetails.Frame.buttonSwitchSpellsAuras.AntsFrame:Hide()
			end
		
			hide_Summary()
			
			BossFrame.raidbackground:Show()
			
			hide_Graph()
			hide_Emote()
			
			--show spells frames
			for _, widget in pairs (BossFrame.EnemySpellsWidgets) do
				widget:Show()
			end
			
			BossFrame.ShowType = "spellsauras"

			EncounterDetails.update_enemy_spells()
			EncounterDetails.update_bossmods()
			
			BossFrame.segmentosDropdown:Enable()
			
			BossFrame.buttonSwitchSpellsAuras:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))

			EncounterDetails.db.last_section_selected = BossFrame.ShowType
		
		elseif (to == "emotes") then
		
			_detalhes:SetTutorialCVar ("ENCOUNTER_BREAKDOWN_EMOTES", true)
			if (EncounterDetails.Frame.buttonSwitchBossEmotes.AntsFrame) then
				EncounterDetails.Frame.buttonSwitchBossEmotes.AntsFrame:Hide()
			end
			
			--hide boss frames
			for _, frame in _ipairs (BossFrame.Widgets) do
				frame:Hide()
			end
			
			BossFrame.raidbackground:Show()
			
			--hide graph
			if (_G.DetailsRaidDpsGraph) then
				_G.DetailsRaidDpsGraph:Hide()
				for i = 1, 8, 1 do
					BossFrame["dpsamt"..i]:Hide()
					BossFrame["timeamt"..i]:Hide()
				end
				BossFrame["timeamt0"]:Hide()
				BossFrame["phases_string"]:Hide()
			end
			--show emote frames
			for _, widget in pairs (BossFrame.EmoteWidgets) do
				widget:Show()
			end
			
			--hide spells frames
			for _, widget in pairs (BossFrame.EnemySpellsWidgets) do
				widget:Hide()
			end			
		
			BossFrame.ShowType = "emotes"
			
			scrollframe:Update()
			BossFrame.EmotesSegment:Refresh()
			BossFrame.EmotesSegment:Select (emote_segment)
			
			BossFrame.segmentosDropdown:Disable()
			
			BossFrame.buttonSwitchBossEmotes:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))

			EncounterDetails.db.last_section_selected = BossFrame.ShowType
		
		elseif (to == "phases") then
		
			_detalhes:SetTutorialCVar ("ENCOUNTER_BREAKDOWN_PHASES", true)
			if (EncounterDetails.Frame.buttonSwitchPhases.AntsFrame) then
				EncounterDetails.Frame.buttonSwitchPhases.AntsFrame:Hide()
			end
			
			hide_Summary()
			hide_Graph()
			hide_Emote()
			hide_WeakAuras()
			
			BossFrame.ShowType = "phases"
			
			EncounterDetailsPhaseFrame:Show()
			
			BossFrame.buttonSwitchPhases:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))

			EncounterDetails.db.last_section_selected = BossFrame.ShowType
		
		elseif (to == "graph") then
			
			_detalhes:SetTutorialCVar ("ENCOUNTER_BREAKDOWN_CHART", true)
			if (EncounterDetails.Frame.buttonSwitchGraphic.AntsFrame) then
				EncounterDetails.Frame.buttonSwitchGraphic.AntsFrame:Hide()
			end
			
			EncounterDetails:BuildDpsGraphic()
			if (not _G.DetailsRaidDpsGraph) then
				return
			end
			
			BossFrame.raidbackground:Hide()
 
			for _, frame in _ipairs (BossFrame.Widgets) do 
				frame:Hide()
			end
				
			_G.DetailsRaidDpsGraph:Show()
			
			for i = 1, 8, 1 do
				BossFrame["dpsamt"..i].widget:Show()
				BossFrame["timeamt"..i].widget:Show()
			end
			BossFrame["timeamt0"].widget:Show()
			BossFrame["phases_string"].widget:Show()
			
			BossFrame.ShowType = "graph"
			
			--hide emote frames
			for _, widget in pairs (BossFrame.EmoteWidgets) do
				widget:Hide()
			end
			
			--hide spells frames
			for _, widget in pairs (BossFrame.EnemySpellsWidgets) do
				widget:Hide()
			end			
			
			BossFrame.segmentosDropdown:Enable()
			
			BossFrame.buttonSwitchGraphic:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))

			EncounterDetails.db.last_section_selected = BossFrame.ShowType
		end
	end
	
	-- ~button ~menu
	
	local BUTTON_WIDTH = 120
	local BUTTON_HEIGHT = 20
	local HEADER_MENUBUTTONS_SPACEMENT = 4
	local HEADER_MENUBUTTONS_X = 290
	local HEADER_MENUBUTTONS_Y = -38
	
	--summary
	BossFrame.buttonSwitchNormal = _detalhes.gump:CreateButton (BossFrame, BossFrame.switch, BUTTON_WIDTH, BUTTON_HEIGHT, "Summary", "main")
	BossFrame.buttonSwitchNormal:SetIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 18, 18, "overlay", {0, 32/256, 0, 0.505625})
	BossFrame.buttonSwitchNormal:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"))
	BossFrame.buttonSwitchNormal:SetWidth (BUTTON_WIDTH)
	
	--spells e auras
	BossFrame.buttonSwitchSpellsAuras = _detalhes.gump:CreateButton (BossFrame, BossFrame.switch, BUTTON_WIDTH, BUTTON_HEIGHT, "Timers & Spells", "spellsauras")
	BossFrame.buttonSwitchSpellsAuras:SetIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 18, 18, "overlay", {33/256, 64/256, 0, 0.505625})
	BossFrame.buttonSwitchSpellsAuras:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	BossFrame.buttonSwitchSpellsAuras:SetWidth (BUTTON_WIDTH)
	BossFrame.AllButtons = {BossFrame.buttonSwitchNormal, BossFrame.buttonSwitchGraphic, BossFrame.buttonSwitchBossEmotes, BossFrame.buttonSwitchSpellsAuras, BossFrame.buttonSwitchPhases}

	--phases
	BossFrame.buttonSwitchPhases = _detalhes.gump:CreateButton (BossFrame, BossFrame.switch, BUTTON_WIDTH, BUTTON_HEIGHT, "Phases", "phases")
	BossFrame.buttonSwitchPhases:SetIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 18, 18, "overlay", {65/256, 96/256, 0, 0.505625})
	BossFrame.buttonSwitchPhases:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	BossFrame.buttonSwitchPhases:SetWidth (BUTTON_WIDTH)
	
	--chart
	BossFrame.buttonSwitchGraphic = _detalhes.gump:CreateButton (BossFrame, BossFrame.switch, BUTTON_WIDTH, BUTTON_HEIGHT, "Damage Graphic", "graph")
	BossFrame.buttonSwitchGraphic:SetIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 18, 18, "overlay", {97/256, 128/256, 0, 0.505625})
	BossFrame.buttonSwitchGraphic:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	BossFrame.buttonSwitchGraphic:SetWidth (BUTTON_WIDTH)
	
	--emotes
	BossFrame.buttonSwitchBossEmotes = _detalhes.gump:CreateButton (BossFrame, BossFrame.switch, BUTTON_WIDTH, BUTTON_HEIGHT, "Emotes", "emotes")
	BossFrame.buttonSwitchBossEmotes:SetIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 18, 18, "overlay", {129/256, 160/256, 0, 0.505625})
	BossFrame.buttonSwitchBossEmotes:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	BossFrame.buttonSwitchBossEmotes:SetWidth (BUTTON_WIDTH)

	--anchors
	BossFrame.buttonSwitchNormal:SetPoint ("TOPLEFT", BossFrame, "TOPLEFT", HEADER_MENUBUTTONS_X, HEADER_MENUBUTTONS_Y)
	BossFrame.buttonSwitchSpellsAuras:SetPoint ("left", BossFrame.buttonSwitchNormal, "right", HEADER_MENUBUTTONS_SPACEMENT, 0)
	BossFrame.buttonSwitchPhases:SetPoint ("left", BossFrame.buttonSwitchSpellsAuras, "right", HEADER_MENUBUTTONS_SPACEMENT, 0)
	BossFrame.buttonSwitchGraphic:SetPoint ("left", BossFrame.buttonSwitchPhases, "right", HEADER_MENUBUTTONS_SPACEMENT, 0)
	BossFrame.buttonSwitchBossEmotes:SetPoint ("left", BossFrame.buttonSwitchGraphic, "right", HEADER_MENUBUTTONS_SPACEMENT, 0)
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> ~emotes
	
	local emote_lines = {}
	local emote_search_table = {}
	
	local CONST_EMOTES_MAX_LINES = 32
	
	local refresh_emotes = function (self)
		--update emote scroll
		
		local offset = FauxScrollFrame_GetOffset (self)
		
		--print (EncounterDetails.charsaved, EncounterDetails.charsaved.emotes, EncounterDetails.charsaved.emotes [1], #EncounterDetails.charsaved.emotes)
		local emote_pool = EncounterDetails.charsaved.emotes [emote_segment]
		
		if (searching) then
			local i = 0
			local lower = string.lower
			for index, data in ipairs (emote_pool) do
				if (lower (data [2]):find (lower(searching))) then
					i = i + 1
					emote_search_table [i] = data
				end
				for o = #emote_search_table, i+1, -1 do
					emote_search_table [o] = nil
				end
				emote_pool = emote_search_table
			end
			BossFrame.SearchResults:Show()
			BossFrame.SearchResults:SetText ("Found " .. i .. " matches")
			
			if (i > 0) then
				BossFrame.ReportEmoteButton:Enable()
			elseif (i == 0) then
				BossFrame.ReportEmoteButton:Disable()
			end
		else
			BossFrame.SearchResults:Hide()
		end
		
		if (emote_pool) then
			for bar_index = 1, CONST_EMOTES_MAX_LINES do 
				local data = emote_pool [bar_index + offset]
				local bar = emote_lines [bar_index]
				
				if (data) then
					bar:Show()
					local min, sec = _math_floor (data[1] / 60), _math_floor (data[1] % 60)
					bar.lefttext:SetText (min .. "m" .. sec .. "s:")
					
					if (data [2] == "") then
						bar.righttext:SetText ("--x--x--")
					else
						bar.righttext:SetText (_cstr (data [2], data [3]))
					end
					
					local color_string = EncounterDetails.BossWhispColors [data [4]]
					local color_table = ChatTypeInfo [color_string]	
					
					bar.righttext:SetTextColor (color_table.r, color_table.g, color_table.b)
					bar.icon:SetTexture ([[Interface\CHARACTERFRAME\UI-StateIcon]])
					bar.icon:SetTexCoord (0, 0.5, 0.5, 1)
					bar.icon:SetBlendMode ("ADD")
				else
					bar:Hide()
				end
			end
			
			FauxScrollFrame_Update (self, #emote_pool, CONST_EMOTES_MAX_LINES, 15)
		else
			for bar_index = 1, CONST_EMOTES_MAX_LINES do 
				local bar = emote_lines [bar_index]
				bar:Hide()
			end
		end
	end
	
	BossFrame.EmoteWidgets = {}
	--~emotes ~whispers
	
	local bar_div_emotes = DetailsFrameWork:CreateImage (BossFrame, "Interface\\AddOns\\Details_EncounterDetails\\images\\boss_bg", 4, 480, "artwork", {724/1024, 728/1024, 0, 245/512})
	bar_div_emotes:SetPoint ("TOPLEFT", BossFrame, "TOPLEFT", 244, -74)
	bar_div_emotes:Hide()
	tinsert (BossFrame.EmoteWidgets, bar_div_emotes)
	
	scrollframe = CreateFrame ("ScrollFrame", "EncounterDetails_EmoteScroll", BossFrame, "FauxScrollFrameTemplate, BackdropTemplate")
	scrollframe:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 14, refresh_emotes) end)
	scrollframe:SetPoint ("topleft", BossFrame, "topleft", 249, -75)
	scrollframe:SetPoint ("bottomright", BossFrame, "bottomright", -33, 42)
	scrollframe.Update = refresh_emotes
	scrollframe:Hide()
	_detalhes.gump:ReskinSlider (scrollframe, 3)
	
	--
	tinsert (BossFrame.EmoteWidgets, scrollframe)

	local row_on_enter = function (self)
		self:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
		self:SetBackdropColor (1, 1, 1, .6)
		if (self.righttext:IsTruncated()) then
			GameCooltip:Reset()
			GameCooltip:AddLine (self.righttext:GetText())
			GameCooltip:SetOwner (self, "bottomleft", "topleft", 42, -9)
			GameCooltip:Show()
		end
	end
	local row_on_leave = function (self)
		self:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})	
		self:SetBackdropColor (1, 1, 1, .3)
		GameCooltip:Hide()
	end
	
	local row_on_mouse_up = function (self)
		--report
		local text = self.righttext:GetText()
		local time = self.lefttext:GetText()
		
		local reportFunc = function()
			-- remove textures
			text = text:gsub ("(|T).*(|t)", "")
			-- remove colors
			text = text:gsub ("|c%x?%x?%x?%x?%x?%x?%x?%x?", "")
			text = text:gsub ("|r", "")
			-- replace links
			for _, spellid in text:gmatch ("(|Hspell:)(.-)(|h)") do
				local spell = tonumber (spellid)
				local link = GetSpellLink (spell)
				text = text:gsub ("(|Hspell).*(|h)", link)
			end
			-- remove unit links
			text = text:gsub ("(|Hunit).-(|h)", "")
			-- remove the left space
			text = text:gsub ("^%s$", "")

			EncounterDetails:SendReportLines ({"Details! Encounter Emote at " .. time, "\"" .. text .. "\""})
		end
		
		EncounterDetails:SendReportWindow (reportFunc)
	end
	
	for i = 1, CONST_EMOTES_MAX_LINES do
		local line = CreateFrame ("frame", nil, BossFrame,"BackdropTemplate")
		local y = (i-1) * 15 * -1
		line:SetPoint ("topleft", scrollframe, "topleft", 0, y)
		line:SetPoint ("topright", scrollframe, "topright", 0, y)
		line:SetHeight (14)
		line:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})	
		line:SetBackdropColor (1, 1, 1, .3)
		
		line.icon = line:CreateTexture (nil, "overlay")
		line.icon:SetPoint ("left", line, "left", 2, 0)
		line.icon:SetSize (14, 14)
		
		line.lefttext = line:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		line.lefttext:SetPoint ("left", line.icon, "right", 2, 0)
		line.lefttext:SetWidth (line:GetWidth() - 26)
		line.lefttext:SetHeight (14)
		line.lefttext:SetJustifyH ("left")
		
		line.righttext = line:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		line.righttext:SetPoint ("left", line.icon, "right", 46, 0)
		line.righttext:SetWidth (line:GetWidth() - 60)
		line.righttext:SetHeight (14)
		line.righttext:SetJustifyH ("left")
		
		line:SetFrameLevel (scrollframe:GetFrameLevel()+1)
		
		line:SetScript ("OnEnter", row_on_enter)
		line:SetScript ("OnLeave", row_on_leave)
		line:SetScript ("OnMouseUp", row_on_mouse_up)
		tinsert (emote_lines, line)
		tinsert (BossFrame.EmoteWidgets, line)
		line:Hide()
	end
	
	--select emote segment
	local emotes_segment_label = DetailsFrameWork:CreateLabel (BossFrame, "Segment:", 11, nil, "GameFontHighlightSmall")
	emotes_segment_label:SetPoint ("topleft", BossFrame, "topleft", 10, -85)
	
	local on_emote_Segment_select = function (_, _, segment)
		FauxScrollFrame_SetOffset (scrollframe, 0)
		emote_segment = segment
		scrollframe:Update()
	end
	
	function EncounterDetails:SetEmoteSegment (segment)
		emote_segment = segment
	end
	
	local segment_icon = [[Interface\AddOns\Details\images\icons]]
	local segment_icon_coord = {0.7373046875, 0.9912109375, 0.6416015625, 0.7978515625}
	local segment_icon_color = {1, 1, 1, 0.5}
	
	local build_emote_segments = function()
		local t = {}
		if (not EncounterDetails.charsaved) then
			return t
		end
		for index, segment in ipairs (EncounterDetails.charsaved.emotes) do
			tinsert (t, {label = "#" .. index .. " "  .. (segment.boss or "unknown"), value = index, icon = segment_icon, texcoord = segment_icon_coord, onclick = on_emote_Segment_select, iconcolor = segment_icon_color})
		end
		return t
	end
	local dropdown = DetailsFrameWork:NewDropDown (BossFrame, _, "$parentEmotesSegmentDropdown", "EmotesSegment", 180, 20, build_emote_segments, 1)
	dropdown:SetPoint ("topleft", emotes_segment_label, "bottomleft", -1, -2)
	dropdown:SetTemplate (DetailsFrameWork:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	
	tinsert (BossFrame.EmoteWidgets, dropdown)
	tinsert (BossFrame.EmoteWidgets, emotes_segment_label)
	
	--search box
	local emotes_search_label = DetailsFrameWork:CreateLabel (BossFrame, "Search:", 11, nil, "GameFontHighlightSmall")
	emotes_search_label:SetPoint ("topleft", BossFrame, "topleft", 10, -130)
	
	local emotes_search_results_label = DetailsFrameWork:CreateLabel (BossFrame, "", 11, nil, "GameFontNormal", "SearchResults")
	emotes_search_results_label:SetPoint ("topleft", BossFrame, "topleft", 10, -190)
	--
	local search = DetailsFrameWork:NewTextEntry (BossFrame, nil, "$parentEmoteSearchBox", nil, 180, 20)
	search:SetTemplate (DetailsFrameWork:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	search:SetPoint ("topleft",emotes_search_label, "bottomleft", -1, -2)
	search:SetJustifyH ("left")
	
	search:SetHook ("OnTextChanged", function() 
		searching = search:GetText()
		if (searching == "") then
			searching = nil
			FauxScrollFrame_SetOffset (scrollframe, 0)
			BossFrame.ReportEmoteButton:Disable()
			scrollframe:Update()
		else
			FauxScrollFrame_SetOffset (scrollframe, 0)
			BossFrame.ReportEmoteButton:Enable()
			scrollframe:Update()
		end
	end)

	local reset = DetailsFrameWork:NewButton (BossFrame, nil, "$parentResetSearchBoxtButton", "ResetSearchBox", 16, 16, function()
		search:SetText ("")
	end)
	
	reset:SetPoint ("left", search, "right", -1, 0)
	reset:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
	reset:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
	reset:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
	reset:GetNormalTexture():SetDesaturated (true)
	reset.tooltip = "Reset Search"
	
	tinsert (BossFrame.EmoteWidgets, search)
	tinsert (BossFrame.EmoteWidgets, reset)
	tinsert (BossFrame.EmoteWidgets, emotes_search_label)
	
	-- report button
	local report_emote_button = DetailsFrameWork:NewButton (BossFrame, nil, "$parentReportEmoteButton", "ReportEmoteButton", 180, 20, function()
		local reportFunc = function (IsCurrent, IsReverse, AmtLines)
			local segment = EncounterDetails.charsaved.emotes and EncounterDetails.charsaved.emotes [emote_segment]

			if (segment) then
				EncounterDetails.report_lines = {"Details!: Emotes for " .. segment.boss}
				local added = 0

				for index = 1, 16 do
					local bar = emote_lines [index]
					if (bar:IsShown() and added < AmtLines) then
						local time = bar.lefttext:GetText()
						local text = bar.righttext:GetText()

						--"|Hunit:77182:Oregorger|hOregorger prepares to cast |cFFFF0000|Hspell:156879|h[Blackrock Barrage]|h|r."
						
						-- remove textures
						text = text:gsub ("(|T).*(|t)", "")
						-- remove colors
						text = text:gsub ("|c%x?%x?%x?%x?%x?%x?%x?%x?", "")
						text = text:gsub ("|r", "")
						-- replace links
						for _, spellid in text:gmatch ("(|Hspell:)(.-)(|h)") do
							local spell = tonumber (spellid)
							local link = GetSpellLink (spell)
							text = text:gsub ("(|Hspell).*(|h)", link)
						end
						-- remove unit links
						text = text:gsub ("(|Hunit).-(|h)", "")
						-- remove the left space
						text = text:gsub ("^%s$", "")

						tinsert (EncounterDetails.report_lines, time .. " " .. text)
						added = added + 1
						
						if (added == AmtLines) then
							break
						end
					end
				end
				
				EncounterDetails:SendReportLines (EncounterDetails.report_lines)
			else
				EncounterDetails:Msg ("There is nothing to report.")
			end
		end
	
		local use_slider = true
		EncounterDetails:SendReportWindow (reportFunc, nil, nil, use_slider)
	end, nil, nil, nil, "Report Results")
	
	report_emote_button:SetIcon ([[Interface\AddOns\Details\images\report_button]], 8, 14, nil, {0, 1, 0, 1}, nil, 4, 2)
	report_emote_button:SetTemplate (DetailsFrameWork:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	
	report_emote_button:SetPoint ("topleft", search, "bottomleft", 0, -4)
	report_emote_button:Disable()
	
	tinsert (BossFrame.EmoteWidgets, report_emote_button)
	
	--
	
	for _, widget in pairs (BossFrame.EmoteWidgets) do
		widget:Hide()
	end
	
	local emote_report_label = DetailsFrameWork:NewLabel (search.widget, search.widget, nil, "report_click", "|cFFffb400Left Click|r: Report Line")
	emote_report_label:SetPoint ("topleft", search.widget, "bottomleft", 1, -61)

	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> auras weakauras


	BossFrame.EnemySpellsWidgets = {}

	--> spells and auras ~auras ~spell ~weakaura �ura

	local CONST_MAX_AURA_LINES = 21
	

	local spell_blocks = {}
	local bossmods_blocks = {}
	
	local on_focus_gain = function (self)
		self:HighlightText()
	end
	
	local on_focus_lost = function (self)
		self:HighlightText (0, 0)
	end
	
	local on_enter_spell = function (self)
		if (self.MyObject._spellid) then
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")

			if (type(self.MyObject._spellid) == "string") then
				local spellId = self.MyObject._spellid:gsub("%a", "")
				spellId = tonumber(spellId)
				if (spellId) then
					GameTooltip:SetSpellByID(spellId)
				end
			else
				GameTooltip:SetSpellByID(self.MyObject._spellid)
			end
			GameTooltip:Show()

			self:SetBackdropColor (1, 1, 1, .5)
			self:SetBackdropBorderColor (0, 0, 0, 1)
			return true
		end
	end
	
	local on_leave_spell = function (self, capsule)
		GameTooltip:Hide()
		self:SetBackdropColor (.3, .3, .3, .5)
	end
	
	local create_aura_func = function (self, button, spellid, encounter_id)
		local name, _, icon = EncounterDetails.getspellinfo (spellid)
		EncounterDetails:OpenAuraPanel (spellid, name, self and self.MyObject._icon.texture, encounter_id)
	end
	
	local info_onenter = function (self)
		local spellid = self._spellid
		
		local info = EncounterDetails.EnemySpellPool [spellid]
		if (info) then
			_detalhes:CooltipPreset (2)
			GameCooltip:SetOption ("FixedWidth", false)
			
			for token, _ in pairs (info.token) do
				GameCooltip:AddLine ("event:", token, 1, nil, "white")
			end
			
			GameCooltip:AddLine ("source:", info.source, 1, nil, "white")
			GameCooltip:AddLine ("school:", EncounterDetails:GetSpellSchoolFormatedName (info.school), 1, nil, "white")
			
			if (info.type) then
				GameCooltip:AddLine ("aura type:", info.type, 1, nil, "white")
			end
			GameCooltip:ShowCooltip (self, "tooltip")
		end

		self:SetBackdropColor (1, 1, 1, .5)
	end
	local info_onleave = function (self)
		GameCooltip:Hide()
		self:SetBackdropColor (.3, .3, .3, .5)
	end

	local bossModsTitle = DetailsFrameWork:CreateLabel (BossFrame, "Boss Mods Time Bars:", 12, "orange")
	bossModsTitle:SetPoint(10, -85)
	tinsert (BossFrame.EnemySpellsWidgets, bossModsTitle)
	bossModsTitle:Hide()

	local bossSpellsTitle = DetailsFrameWork:CreateLabel (BossFrame, "Boss Spells and Auras:", 12, "orange")
	bossSpellsTitle:SetPoint(444, -85)
	tinsert (BossFrame.EnemySpellsWidgets, bossSpellsTitle)
	bossSpellsTitle:Hide()

	--create boss mods list
	for i = 1, CONST_MAX_AURA_LINES do
		local anchor_frame = CreateFrame ("frame", "BossFrameBossModsAnchor" .. i, BossFrame, "BackdropTemplate")

		local spellicon = DetailsFrameWork:NewImage (anchor_frame, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentIcon")

		--timerId
		local spellid = DetailsFrameWork:CreateTextEntry (anchor_frame, EncounterDetails.empty_function, 80, 20, nil, "$parentSpellId")
		spellid:SetTemplate (AurasButtonTemplate)
		spellid:SetHook ("OnEditFocusGained", on_focus_gain)
		spellid:SetHook ("OnEditFocusLost", on_focus_lost)
		spellid:SetHook ("OnEnter", on_enter_spell)
		spellid:SetHook ("OnLeave", on_leave_spell)

		--ability name
		local spellname = DetailsFrameWork:CreateTextEntry (anchor_frame, EncounterDetails.empty_function, 180, 20, nil, "$parentSpellName")
		spellname:SetTemplate (AurasButtonTemplate)
		spellname:SetHook ("OnEditFocusGained", on_focus_gain)
		spellname:SetHook ("OnEditFocusLost", on_focus_lost)
		spellname:SetHook ("OnEnter", on_enter_spell)
		spellname:SetHook ("OnLeave", on_leave_spell)

		local create_aura = DetailsFrameWork:NewButton (anchor_frame, nil, "$parentCreateAuraButton", "AuraButton", 90, 18, create_aura_func, nil, nil, nil, "Make Aura")
		create_aura:SetTemplate (AurasButtonTemplate)

		spellicon:SetPoint ("topleft", BossFrame, "topleft", 10, -85 + (i * 21 * -1))
		spellid:SetPoint ("left", spellicon, "right", 4, 0)
		spellname:SetPoint ("left", spellid, "right", 4, 0)
		create_aura:SetPoint ("left", spellname, "right", 4, 0)

		spellid:SetBackdropBorderColor(0, 0, 0)
		spellname:SetBackdropBorderColor(0, 0, 0)

		anchor_frame.icon = spellicon
		anchor_frame.spellid = spellid
		anchor_frame.spellname = spellname
		anchor_frame.aurabutton = create_aura
		anchor_frame.aurabutton._icon = spellicon

		tinsert (bossmods_blocks, anchor_frame)
		tinsert (BossFrame.EnemySpellsWidgets, anchor_frame)
		
		anchor_frame:Hide()
	end
	
	--create buff list
	for i = 1, CONST_MAX_AURA_LINES do
		local anchor_frame = CreateFrame ("frame", "BossFrameSpellAnchor" .. i, BossFrame, "BackdropTemplate")

		local spellicon = DetailsFrameWork:NewImage (anchor_frame, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentIcon")
		
		local spellid = DetailsFrameWork:CreateTextEntry (anchor_frame, EncounterDetails.empty_function, 80, 20)
		spellid:SetTemplate (AurasButtonTemplate)
		spellid:SetHook ("OnEditFocusGained", on_focus_gain)
		spellid:SetHook ("OnEditFocusLost", on_focus_lost)
		spellid:SetHook ("OnEnter", on_enter_spell)
		spellid:SetHook ("OnLeave", on_leave_spell)
		
		local spellname = DetailsFrameWork:CreateTextEntry (anchor_frame, EncounterDetails.empty_function, 160, 20)
		spellname:SetTemplate (AurasButtonTemplate)
		spellname:SetHook ("OnEditFocusGained", on_focus_gain)
		spellname:SetHook ("OnEditFocusLost", on_focus_lost)
		spellname:SetHook ("OnEnter", on_enter_spell)
		spellname:SetHook ("OnLeave", on_leave_spell)
		
		--spellicon_button:SetPoint ("topleft", BossFrame, "topleft", 255, -65 + (i * 21 * -1))
		spellicon:SetPoint ("topleft", BossFrame, "topleft", 443, -85 + (i * 21 * -1))
		spellid:SetPoint ("left", spellicon, "right", 4, 0)
		spellname:SetPoint ("left", spellid, "right", 4, 0)
		
		local spellinfo = CreateFrame ("frame", nil, anchor_frame,"BackdropTemplate")
		spellinfo:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		spellinfo:SetBackdropColor (.3, .3, .3, .5)
		spellinfo:SetBackdropBorderColor (0, 0, 0, 1)
		spellinfo:SetSize (80, 20)
		spellinfo:SetScript ("OnEnter", info_onenter)
		spellinfo:SetScript ("OnLeave", info_onleave)
		
		local spellinfotext = spellinfo:CreateFontString (nil, "overlay", "GameFontNormal")
		spellinfotext:SetPoint ("center", spellinfo, "center")
		spellinfotext:SetText ("info")
		spellinfo:SetPoint ("left", spellname.widget, "right", 4, 0)
		
		local create_aura = DetailsFrameWork:NewButton (anchor_frame, nil, "$parentCreateAuraButton", "AuraButton", 90, 18, create_aura_func, nil, nil, nil, "Make Aura")
		create_aura:SetPoint ("left", spellinfo, "right", 4, 0)
		create_aura:SetTemplate (AurasButtonTemplate)
		
		anchor_frame.icon = spellicon
		anchor_frame.spellid = spellid
		anchor_frame.spellname = spellname
		anchor_frame.aurabutton = create_aura
		anchor_frame.aurabutton._icon = spellicon
		anchor_frame.info = spellinfo
		
		tinsert (spell_blocks, anchor_frame)
		tinsert (BossFrame.EnemySpellsWidgets, anchor_frame)
		
		anchor_frame:Hide()
	end
	
	local update_enemy_spells = function()
		local combat = EncounterDetails:GetCombat (EncounterDetails._segment)
		local spell_list = {}

		if (combat) then
			for i, npc in combat[1]:ListActors() do
				--damage
				if (npc:IsNeutralOrEnemy()) then
					for spellid, spell in pairs (npc.spells._ActorTable) do
						if (spellid > 10) then
							local name, _, icon = EncounterDetails.getspellinfo (spellid)
							tinsert (spell_list, {spellid, name, icon, nil, npc.serial})
						end
					end
				end
			end

			for i, npc in combat[2]:ListActors() do
				--heal
				if (npc:IsNeutralOrEnemy()) then
					for spellid, spell in pairs (npc.spells._ActorTable) do
						if (spellid > 10) then
							local name, _, icon = EncounterDetails.getspellinfo (spellid)
							tinsert (spell_list, {spellid, name, icon, true, npc.serial})
						end
					end
				end
			end

			table.sort(spell_list, function(t1, t2)
				return t1[2] < t2[2]
			end)

			EncounterDetails_SpellAurasScroll.spell_pool = spell_list
			EncounterDetails_SpellAurasScroll.encounter_id = combat.is_boss and combat.is_boss.id
			EncounterDetails_SpellAurasScroll:Update()
		end
	end
	
	local refresh_bossmods_timers = function(self)
		local combat = EncounterDetails:GetCombat(EncounterDetails._segment)
		local offset = FauxScrollFrame_GetOffset(self)
		local already_added = {}
		local db = _detalhes.boss_mods_timers
		local encounter_id = combat.is_boss and combat.is_boss.id

		if (db) then
			wipe(already_added)
			local timersToAdd = {}

			for timerId, timerTable in pairs (db.encounter_timers_dbm) do
				if (timerTable.id == encounter_id) then
					local spellId = timerTable [7]
					local spellIcon = timerTable [5]
					local spellName
				
					local spell = timerId
					spell = spell:gsub("ej", "")
					spell = tonumber(spell)
					
					if (spell and not already_added[spell]) then
						if (spell > 40000) then
							local spellname, _, spellicon = _GetSpellInfo(spell)
							tinsert (timersToAdd, {label = spellname, value = {timerTable[2], spellname, spellIcon or spellicon, timerTable.id, timerTable[7]}, icon = spellIcon or spellicon})

						else
							--local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = C_EncounterJournal.GetSectionInfo(spell)
							local sectionInfo = C_EncounterJournal.GetSectionInfo(spell)
							tinsert (timersToAdd, {label = sectionInfo.title, value = {timerTable[2], sectionInfo.title, spellIcon or sectionInfo.abilityIcon, timerTable.id, timerTable[7]}, icon = spellIcon or sectionInfo.abilityIcon})
						end

						already_added[spell] = true
					end
				end
			end

			table.sort(timersToAdd, function(t1, t2)
				return t1.label < t2.label
			end)

			local offset = FauxScrollFrame_GetOffset(self)
			
			for barIndex = 1, CONST_MAX_AURA_LINES do 

				local data = timersToAdd[barIndex + offset]
				local bar = bossmods_blocks[barIndex]

				if (data) then
					bar:Show()
			
					bar.icon.texture = data.icon
					bar.icon:SetTexCoord(.1, .9, .1, .9)
					bar.spellid.text = data.value[1] or "--x--x--"
					bar.spellname.text = data.label or "--x--x--"

					bar.spellid._spellid = data.value[1]
					bar.spellname._spellid = data.value[1]

					local func = function()
						local timerId, spellname, spellicon, encounterid, spellid = unpack(data.value)
						EncounterDetails:OpenAuraPanel (timerId, spellname, spellicon, encounterid, DETAILS_WA_TRIGGER_DBM_TIMER, DETAILS_WA_AURATYPE_TEXT, {dbm_timer_id = timerId, spellid = spellid, text = "Next " .. spellname .. " In", text_size = 72, icon = spellicon})
					end

					bar.aurabutton:SetClickFunction(func)
				else
					bar:Hide()
				end
			end

			FauxScrollFrame_Update(self, #timersToAdd, CONST_MAX_AURA_LINES, 20)

			if (#timersToAdd > 0) then
				self:Show()
			end
		end
	end

	local refresh_spellauras = function (self)
		
		local pool = EncounterDetails_SpellAurasScroll.spell_pool
		local encounter_id = EncounterDetails_SpellAurasScroll.encounter_id
		local offset = FauxScrollFrame_GetOffset (self)
		
		for bar_index = 1, CONST_MAX_AURA_LINES do 
			local data = pool [bar_index + offset]
			local bar = spell_blocks [bar_index]
			
			if (data) then
				bar:Show()
				
				bar.icon.texture = data [3]
				bar.icon:SetTexCoord(.1, .9, .1, .9)
				bar.spellid.text = data [1]
				bar.spellname.text = data [2]
				
				bar.spellid._spellid = data [1]
				bar.spellname._spellid = data [1]
				bar.info._spellid = data [1]
				
				local is_heal = data [4]
				if (is_heal) then
					bar.spellid:SetBackdropBorderColor (0, 1, 0)
					bar.spellname:SetBackdropBorderColor (0, 1, 0)
				else
					bar.spellid:SetBackdropBorderColor (0, 0, 0)
					bar.spellname:SetBackdropBorderColor (0, 0, 0)
				end
				
				bar.aurabutton:SetClickFunction (create_aura_func, data [1], encounter_id)

			else
				bar:Hide()
			end
		end
		
		FauxScrollFrame_Update (self, #pool, CONST_MAX_AURA_LINES, 20)
		
	end
	
	local spell_scrollframe = CreateFrame ("ScrollFrame", "EncounterDetails_SpellAurasScroll", BossFrame, "FauxScrollFrameTemplate, BackdropTemplate")
	spell_scrollframe:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 14, refresh_spellauras) end)
	spell_scrollframe:SetPoint ("topleft", BossFrame, "topleft", 200, -75)
	spell_scrollframe:SetPoint ("bottomright", BossFrame, "bottomright", -33, 42)
	spell_scrollframe.Update = refresh_spellauras
	spell_scrollframe:Hide()
	EncounterDetails.SpellScrollframe = spell_scrollframe
	_G.DetailsFramework:ReskinSlider(spell_scrollframe)
	
	tinsert (BossFrame.EnemySpellsWidgets, spell_scrollframe)
	EncounterDetails.update_enemy_spells = update_enemy_spells


	local bossmods_scrollframe = CreateFrame ("ScrollFrame", "EncounterDetails_BossModsScroll", BossFrame, "FauxScrollFrameTemplate, BackdropTemplate")
	bossmods_scrollframe:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, 14, refresh_bossmods_timers) end)
	bossmods_scrollframe:SetPoint ("topleft", BossFrame, "topleft", 10, -75)
	bossmods_scrollframe:SetPoint ("bottomleft", BossFrame, "bottomleft", 250, 42)
	bossmods_scrollframe.Update = refresh_bossmods_timers
	bossmods_scrollframe:Hide()
	EncounterDetails.BossModsScrollframe = bossmods_scrollframe

	tinsert (BossFrame.EnemySpellsWidgets, bossmods_scrollframe)
	EncounterDetails.update_bossmods = function() bossmods_scrollframe:Update() end

	
	local build_bigwigs_bars = function()
		local t = {}
		local db = _detalhes.boss_mods_timers
		if (db) then
			wipe (already_added)
			local encounter_id = EncounterDetails_SpellAurasScroll.encounter_id
			
			for timer_id, timer_table in pairs (db.encounter_timers_bw) do
				if (timer_table.id == encounter_id) then
					local spell = timer_id
					if (spell and not already_added [spell]) then	
						local int_spell = tonumber (spell)
						if (not int_spell) then
							local spellname = timer_table [2]:gsub (" %(.%)", "")
							tinsert (t, {label = spellname, value = {timer_table [2], spellname, timer_table [5], timer_table.id}, icon = timer_table [5], onclick = on_select_bw_bar})
						elseif (int_spell < 0) then
							local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = C_EncounterJournal.GetSectionInfo (abs (int_spell))
							tinsert (t, {label = title, value = {timer_table [2], title, timer_table [5] or abilityIcon, timer_table.id}, icon = timer_table [5] or abilityIcon, onclick = on_select_bw_bar})
						else
							local spellname, _, spellicon = _GetSpellInfo (int_spell)
							tinsert (t, {label = spellname, value = {timer_table [2], spellname, timer_table [5] or spellicon, timer_table.id}, icon = timer_table [5] or spellicon, onclick = on_select_bw_bar})
						end
						
						already_added [spell] = true
					end
				end
			end
		end
		return t
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~phases

local PhaseFrame = CreateFrame ("frame", "EncounterDetailsPhaseFrame", BossFrame, "BackdropTemplate")
PhaseFrame:SetAllPoints()
PhaseFrame:SetFrameLevel (BossFrame:GetFrameLevel()+1)
PhaseFrame.DamageTable = {}
PhaseFrame.HealingTable = {}
PhaseFrame.LastPhaseSelected = 1
PhaseFrame.CurrentSegment = {}
PhaseFrame.PhaseButtons = {}
EncounterDetailsPhaseFrame:Hide()

local ScrollWidth, ScrollHeight, ScrollLineAmount, ScrollLineHeight = 250, 420, 20, 20
local PhasesY = -88
local AnchorY = -120

PhaseFrame:SetScript ("OnShow", function()
	PhaseFrame.OnSelectPhase (1)
end)

function PhaseFrame:ClearAll()
	--disable all buttons
	for i = 1, #PhaseFrame.PhaseButtons do
		PhaseFrame.PhaseButtons[i]:SetTemplate (PhaseButtonTemplate)
		PhaseFrame.PhaseButtons[i]:Disable()
	end
	
	--update damage and healing scrolls
	table.wipe (PhaseFrame.DamageTable)
	table.wipe (PhaseFrame.HealingTable)
	
	--refresh the scroll
	PhaseFrame.Damage_Scroll:Refresh()
	PhaseFrame.Heal_Scroll:Refresh()
	
	--clear phase bars
	PhaseFrame:ClearPhaseBars()
end

local selectSegment = function (_, _, phaseSelected)
	PhaseFrame ["OnSelectPhase"] (phaseSelected)
end

function PhaseFrame.OnSelectPhase (phaseSelected)

	PhaseFrame:ClearAll()

	--get the selected segment
	PhaseFrame.CurrentSegment = EncounterDetails:GetCombat (EncounterDetails._segment)
	if (not PhaseFrame.CurrentSegment) then
		return
	end
	
	--get the heal and damage for phase selected
	local phaseData = PhaseFrame.CurrentSegment.PhaseData
	if (not phaseData) then
		return
	end

	phaseSelected = phaseSelected or PhaseFrame.LastPhaseSelected
	PhaseFrame.LastPhaseSelected = phaseSelected

	local phases = PhaseFrame:GetPhaseTimers (PhaseFrame.CurrentSegment, true)
	for buttonIndex, phase in ipairs (phases) do
		local button = PhaseFrame.PhaseButtons [buttonIndex]
		if (phase == phaseSelected) then
			button:SetTemplate (PhaseButtonTemplateHighlight)
		else
			button:SetTemplate (PhaseButtonTemplate)
			if (PhaseFrame.CurrentSegment.PhaseData.damage [phase]) then
				button:Enable()
			else
				button:Disable()
			end
		end
		button:SetText (phase)
		button:SetClickFunction (selectSegment, phase)
	end
	
	if (not phaseData.damage [phaseSelected]) then
		PhaseFrame:ClearAll()
		return
	end
	
	--update damage and healing scrolls
	table.wipe (PhaseFrame.DamageTable)
	for charName, amount in pairs (phaseData.damage [phaseSelected]) do
		tinsert (PhaseFrame.DamageTable, {charName, amount})
	end
	table.sort (PhaseFrame.DamageTable, function(a, b) return a[2] > b[2] end)
	
	table.wipe (PhaseFrame.HealingTable)
	for charName, amount in pairs (phaseData.heal [phaseSelected]) do
		tinsert (PhaseFrame.HealingTable, {charName, amount})
	end
	table.sort (PhaseFrame.HealingTable, function(a, b) return a[2] > b[2] end)
	
	--refresh the scroll
	PhaseFrame.Damage_Scroll:Refresh()
	PhaseFrame.Heal_Scroll:Refresh()
	
	PhaseFrame:UpdatePhaseBars()
end

local PhaseSelectLabel = _detalhes.gump:CreateLabel (PhaseFrame, "Select Phase:", 12, "orange")
local DamageLabel = _detalhes.gump:CreateLabel (PhaseFrame, "Damage Done")
local HealLabel = _detalhes.gump:CreateLabel (PhaseFrame, "Healing Done")
local PhaseTimersLabel = _detalhes.gump:CreateLabel (PhaseFrame, "Time Spent on Each Phase")

local report_damage = function (IsCurrent, IsReverse, AmtLines)
	local result = {}
	local reportFunc = function (IsCurrent, IsReverse, AmtLines)
		AmtLines = AmtLines + 1
		if (#result > AmtLines) then
			for i = #result, AmtLines+1, -1 do
				tremove (result, i)
			end
		end
		EncounterDetails:SendReportLines (result)
	end

	tinsert (result, "Details!: Damage for Phase " .. PhaseFrame.LastPhaseSelected .. " of " .. (PhaseFrame.CurrentSegment and PhaseFrame.CurrentSegment.is_boss and PhaseFrame.CurrentSegment.is_boss.name or "Unknown") .. ":")
	for i = 1, #PhaseFrame.DamageTable do
		tinsert (result, EncounterDetails:GetOnlyName (PhaseFrame.DamageTable[i][1]) .. ": " .. _detalhes:ToK (_math_floor (PhaseFrame.DamageTable [i][2])))
	end
	
	EncounterDetails:SendReportWindow (reportFunc, nil, nil, true)
end

local Report_DamageButton = _detalhes.gump:CreateButton (PhaseFrame, report_damage, 16, 16, "report")
Report_DamageButton:SetPoint ("left", DamageLabel, "left", ScrollWidth-44, 0)
Report_DamageButton.textcolor = "gray"
Report_DamageButton.textsize = 9

local report_healing = function()
	local result = {}
	local reportFunc = function (IsCurrent, IsReverse, AmtLines)
		AmtLines = AmtLines + 1
		if (#result > AmtLines) then
			for i = #result, AmtLines+1, -1 do
				tremove (result, i)
			end
		end
		EncounterDetails:SendReportLines (result)
	end

	tinsert (result, "Details!: Healing for Phase " .. PhaseFrame.LastPhaseSelected .. " of " .. (PhaseFrame.CurrentSegment and PhaseFrame.CurrentSegment.is_boss and PhaseFrame.CurrentSegment.is_boss.name or "Unknown") .. ":")
	for i = 1, #PhaseFrame.HealingTable do
		tinsert (result, EncounterDetails:GetOnlyName (PhaseFrame.HealingTable[i][1]) .. ": " .. _detalhes:ToK (_math_floor (PhaseFrame.HealingTable [i][2])))
	end
	
	EncounterDetails:SendReportWindow (reportFunc, nil, nil, true)
end
local Report_HealingButton = _detalhes.gump:CreateButton (PhaseFrame, report_healing, 16, 16, "report")
Report_HealingButton:SetPoint ("left", HealLabel, "left", ScrollWidth-44, 0)
Report_HealingButton.textcolor = "gray"
Report_HealingButton.textsize = 9


PhaseSelectLabel:SetPoint ("topleft", PhaseFrame, "topleft", 10, PhasesY)

DamageLabel:SetPoint ("topleft", PhaseFrame, "topleft", 10, AnchorY)
HealLabel:SetPoint ("topleft", PhaseFrame, "topleft", ScrollWidth + 40, AnchorY)
PhaseTimersLabel:SetPoint ("topleft", PhaseFrame, "topleft", (ScrollWidth * 2) + (40*2), AnchorY)

for i = 1, 10 do
	local button = _detalhes.gump:CreateButton (PhaseFrame, PhaseFrame.OnSelectPhase, 60, 20, "", i)
	button:SetPoint ("left", PhaseSelectLabel, "right", 8 + ((i-1) * 61), 0)
	tinsert (PhaseFrame.PhaseButtons, button)
end

local ScrollRefresh = function (self, data, offset, total_lines)
	local formatToK = Details:GetCurrentToKFunction()
	local removeRealm = _detalhes.GetOnlyName
	
	local topValue = data [1] and data [1][2]
	
	for i = 1, ScrollLineAmount do
		local index = i + offset
		local player = data [index]
		if (player) then
			local line = self:GetLine (i)
			local texture, L, R, T, B = _detalhes:GetPlayerIcon (player[1], PhaseFrame.CurrentSegment)
			
			line.icon:SetTexture (texture)
			line.icon:SetTexCoord (L, R, T, B)
			line.name:SetText (index .. ". " .. removeRealm (_, player[1]))
			line.done:SetText (formatToK (_, player[2]) .. " (" .. format ("%.1f", player[2] / topValue * 100) .. "%)")
			line.statusbar:SetValue (player[2] / topValue * 100)
			local actorClass = Details:GetClass (player[1])
			if (actorClass) then
				line.statusbar:SetColor (actorClass)
			else
				line.statusbar:SetColor ("silver")
			end
		end
	end
end

local line_onenter = function (self)
	self:SetBackdropColor (unpack (BGColorDefault_Hover))
end

local line_onleave = function (self)
	self:SetBackdropColor (unpack (BGColorDefault))
end

local ScrollCreateLine = function (self, index)
	local line = CreateFrame ("button", "$parentLine" .. index, self,"BackdropTemplate")
	line:SetPoint ("topleft", self, "topleft", 0, -((index-1)*(ScrollLineHeight+1)))
	line:SetSize (ScrollWidth, ScrollLineHeight)
	line:SetScript ("OnEnter", line_onenter)
	line:SetScript ("OnLeave", line_onleave)
	line:SetScript ("OnClick", line_onclick)
	
	line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	line:SetBackdropColor (unpack (BGColorDefault))

	local statusBar = 	DetailsFrameWork:CreateBar (line, EncounterDetails.Frame.DefaultBarTexture, 1, 1, 100)
	statusBar:SetAllPoints (line)
	statusBar.backgroundtexture = EncounterDetails.Frame.DefaultBarTexture
	statusBar.backgroundcolor = {.3, .3, .3, .3}
	
	local icon = statusBar:CreateTexture ("$parentIcon", "overlay")
	icon:SetSize (ScrollLineHeight, ScrollLineHeight)
	
	local name = statusBar:CreateFontString ("$parentName", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (name, 10)
	icon:SetPoint ("left", line, "left", 2, 0)
	name:SetPoint ("left", icon, "right", 2, 0)
	_detalhes.gump:SetFontColor (name, "white")
	
	local done = statusBar:CreateFontString ("$parentDone", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (done, 10)
	_detalhes.gump:SetFontColor (done, "white")
	done:SetPoint ("right", line, "right", -2, 0)
	
	line.icon = icon
	line.name = name
	line.done = done
	line.statusbar = statusBar
	name:SetHeight (10)
	name:SetJustifyH ("left")
	return line
end

local Damage_Scroll = _detalhes.gump:CreateScrollBox (PhaseFrame, "$parentDamageScroll", ScrollRefresh, PhaseFrame.DamageTable, ScrollWidth, ScrollHeight, ScrollLineAmount, ScrollLineHeight)
local Heal_Scroll = _detalhes.gump:CreateScrollBox (PhaseFrame, "$parentHealScroll", ScrollRefresh, PhaseFrame.HealingTable, ScrollWidth, ScrollHeight, ScrollLineAmount, ScrollLineHeight)

Damage_Scroll:SetPoint ("topleft", DamageLabel.widget, "bottomleft", 0, -4)
Heal_Scroll:SetPoint ("topleft", HealLabel.widget, "bottomleft", 0, -4)

_detalhes.gump:ReskinSlider (Damage_Scroll, 4)
_detalhes.gump:ReskinSlider (Heal_Scroll, 4)

for i = 1, ScrollLineAmount do 
	Damage_Scroll:CreateLine (ScrollCreateLine)
end
PhaseFrame.Damage_Scroll = Damage_Scroll
Damage_Scroll:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
Damage_Scroll:SetBackdropColor (0, 0, 0, .4)

for i = 1, ScrollLineAmount do 
	Heal_Scroll:CreateLine (ScrollCreateLine)
end
PhaseFrame.Heal_Scroll = Heal_Scroll
Heal_Scroll:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
Heal_Scroll:SetBackdropColor (0, 0, 0, .4)


----------------------------------------------------------

PhaseFrame.PhasesBars = {}
PhaseFrame.PhasesSegmentCompare = {}

local PhaseBarOnEnter = function (self)
	PhaseFrame:UpdateSegmentCompareBars (self.phase)
	self:SetBackdropColor (unpack (BGColorDefault_Hover))
end
local PhaseBarOnLeave = function (self)
	PhaseFrame:ClearSegmentCompareBars()
	self:SetBackdropColor (unpack (BGColorDefault))
end
local PhaseBarOnClick = function (self)
	--report
end

--cria as linhas mostrando o tempo decorride de cada phase
for i = 1, 10 do
	local line = CreateFrame ("button", "$parentPhaseBar" .. i, PhaseFrame,"BackdropTemplate")
	line:SetPoint ("topleft", PhaseTimersLabel.widget, "bottomleft", 0, -((i-1)*(31)) - 4)
	line:SetSize (175, 30)
	line:SetScript ("OnEnter", PhaseBarOnEnter)
	line:SetScript ("OnLeave", PhaseBarOnLeave)
	line:SetScript ("OnClick", PhaseBarOnClick)
	
	line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	line:SetBackdropColor (unpack (BGColorDefault))
	
	local icon = line:CreateTexture ("$parentIcon", "overlay")
	icon:SetSize (16, 16)
	icon:SetTexture ([[Interface\AddOns\Details\images\clock]])
	local name = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (name, 10)
	local done = line:CreateFontString ("$parentDone", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (done, 10)
	
	icon:SetPoint ("left", line, "left", 2, 0)
	name:SetPoint ("left", icon, "right", 2, 0)
	done:SetPoint ("right", line, "right", -3, 0)
	
	line.icon = icon
	line.name = name
	line.done = done
	name:SetHeight (10)
	name:SetJustifyH ("left")
	
	tinsert (PhaseFrame.PhasesBars, line)
end

--cria a linha do segmento para a compara��o, � o que fica na parte direita da tela
--ele � acessado para mostrar quando passar o mouse sobre uma das barras de phase
for i = 1, 20 do
	local line = CreateFrame ("button", "$parentSegmentCompareBar" .. i, PhaseFrame,"BackdropTemplate")
	line:SetPoint ("topleft", PhaseTimersLabel.widget, "bottomleft", 175+10, -((i-1)*(ScrollLineHeight+1)) - 4)
	line:SetSize (150, ScrollLineHeight)
	
	line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	line:SetBackdropColor (unpack (BGColorDefault))
	line:Hide()
	local name = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (name, 9)
	name:SetPoint ("left", line, "left", 2, 0)
	
	local done = line:CreateFontString ("$parentDone", "overlay", "GameFontNormal")
	_detalhes.gump:SetFontSize (done, 9)
	done:SetPoint ("right", line, "right", -2, 0)
	
	line.name = name
	line.done = done
	name:SetHeight (10)
	name:SetJustifyH ("left")
	
	tinsert (PhaseFrame.PhasesSegmentCompare, line)
end

function PhaseFrame:ClearPhaseBars()
	for i = 1, #PhaseFrame.PhasesBars do
		local bar = PhaseFrame.PhasesBars[i]
		bar.name:SetText ("")
		bar.done:SetText ("")
		bar.phase = nil
		bar:Hide()
	end
end
function PhaseFrame:ClearSegmentCompareBars()
	for i = 1, #PhaseFrame.PhasesSegmentCompare do
		PhaseFrame.PhasesSegmentCompare[i]:Hide()
	end
end

function PhaseFrame:GetPhaseTimers (segment, ordered)
	local t = {}
	
	segment = segment or PhaseFrame.CurrentSegment
	
	for phaseIT = 1, #segment.PhaseData do
		local phase, startAt = unpack (segment.PhaseData [phaseIT]) --phase iterator
		local endAt = segment.PhaseData [phaseIT+1] and segment.PhaseData [phaseIT+1][2] or segment:GetCombatTime()
		local elapsed = endAt - startAt
		t [phase] = (t [phase] or 0) + elapsed
	end
	
	if (ordered) then
		local order = {}
		for phase, _ in pairs (t) do
			tinsert (order, phase)
		end
		table.sort (order, function (a, b) return a < b end)
		return order, t
	end
	
	return t
end

--executa quando atualizar o segment geral
function PhaseFrame:UpdatePhaseBars()
	local timers, hash = PhaseFrame:GetPhaseTimers (PhaseFrame.CurrentSegment, true)
	local i = 1
	for index, phase in ipairs (timers) do
		local timer = hash [phase]
		PhaseFrame.PhasesBars [i].name:SetText ("|cFFC0C0C0Phase:|r |cFFFFFFFF" .. phase)
		PhaseFrame.PhasesBars [i].done:SetText (_detalhes.gump:IntegerToTimer (timer))
		PhaseFrame.PhasesBars [i].phase = phase
		PhaseFrame.PhasesBars [i]:Show()
		i = i + 1
	end
end

--executa quando passar o mouse sobre uma bnarra de phase
function PhaseFrame:UpdateSegmentCompareBars (phase)
	--segmento atual (numero)
	local segmentNumber = EncounterDetails._segment
	local segmentTable = PhaseFrame.CurrentSegment
	local bossID = segmentTable:GetBossInfo() and segmentTable:GetBossInfo().id

	local index = 1
	for i, segment in ipairs (_detalhes:GetCombatSegments()) do
		if (segment:GetBossInfo() and segment:GetBossInfo().id == bossID) then
		
			local bar = PhaseFrame.PhasesSegmentCompare [index]
			local timers = PhaseFrame:GetPhaseTimers (segment)
			
			if (timers [phase]) then
				if (segment ~= segmentTable) then
					bar.name:SetText ("Segment " .. i .. ":")
					_detalhes.gump:SetFontColor (bar.name, "orange")
					bar.done:SetText (_detalhes.gump:IntegerToTimer (timers [phase]))
					_detalhes.gump:SetFontColor (bar.done, "orange")
				else
					bar.name:SetText ("Segment " .. i .. ":")
					_detalhes.gump:SetFontColor (bar.name, "white")
					bar.done:SetText (_detalhes.gump:IntegerToTimer (timers [phase]))
					_detalhes.gump:SetFontColor (bar.done, "white")
				end
			else
				bar.name:SetText ("Segment " .. i .. ":")
				_detalhes.gump:SetFontColor (bar.name, "red")
				bar.done:SetText ("--x--x--")
			end
			
			bar:Show()
			index = index + 1
		end
	end
	
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local frame = BossFrame
	
	local mouse_down = function()
					--frame:StartMoving()
					--frame.isMoving = true
				end
				
	local mouse_up = function()
					if (frame.isMoving) then
					--	frame:StopMovingOrSizing()
					--	frame.isMoving = false
					end
				end
	
	
	
	local backdrop = {edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeSize = 1, insets = {left = 1, right = 1, top = 0, bottom = 1}}
	
	--> Selecionar o segmento
	
		local buildSegmentosMenu = function (self)
			local historico = _detalhes.tabela_historico.tabelas
			local return_table = {}
			
			for index, combate in ipairs (historico) do 
				if (combate.is_boss and combate.is_boss.index) then
					local l, r, t, b, icon = _detalhes:GetBossIcon (combate.is_boss.mapid, combate.is_boss.index)
					return_table [#return_table+1] = {value = index, label = "#" .. index .. " " .. combate.is_boss.name, icon = icon, texcoord = {l, r, t, b}, onclick = EncounterDetails.OpenAndRefresh}
				end
			end
			
			return return_table
		end
		
		local segmentos_string = DetailsFrameWork:NewLabel (frame, nil, nil, "segmentosString", "Segment:", "GameFontNormal", 12)
		segmentos_string:SetPoint ("bottomleft", frame, "bottomleft", 20, 16)
		
		-- ~dropdown
		local segmentos = DetailsFrameWork:NewDropDown (frame, _, "$parentSegmentsDropdown", "segmentosDropdown", 160, 20, buildSegmentosMenu, nil)	
		segmentos:SetPoint ("left", segmentos_string, "right", 2, 0)
		segmentos:SetTemplate (DetailsFrameWork:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		
		--> options button
		local options = DetailsFrameWork:NewButton (frame, nil, "$parentOptionsButton", "OptionsButton", 120, 20, EncounterDetails.OpenOptionsPanel, nil, nil, nil, "Options")
		options:SetPoint ("left", segmentos, "right", 10, 0)
		options:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		options:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
		
	--> macro box
		BossFrame.MacroEditBox = DetailsFrameWork:CreateTextEntry (frame, function()end, 300, 20)
		BossFrame.MacroEditBox:SetPoint ("left", options, "right", 10, 0)
		BossFrame.MacroEditBox:SetAlpha (0.5)
		BossFrame.MacroEditBox:SetText ("/run Details:OpenPlugin ('Encounter Breakdown')")
		BossFrame.MacroEditBox:SetTemplate (DetailsFrameWork:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		BossFrame.MacroEditBox:SetSize (360, 20)
		
		BossFrame.MacroEditBox:HookScript ("OnEditFocusGained", function()
			C_Timer.After (0, function() BossFrame.MacroEditBox:HighlightText() end)
		end)
		
		BossFrame.MacroEditBox.BackgroundLabel = DetailsFrameWork:CreateLabel (BossFrame.MacroEditBox, "macro")
		BossFrame.MacroEditBox.BackgroundLabel:SetPoint ("left", BossFrame.MacroEditBox, "left", 6, 0)
		BossFrame.MacroEditBox.BackgroundLabel:SetTextColor (.3, .3, .3, .98)
	
	--> Caixa do Dano total tomado pela Raid
	
	-- ~containers ~damagetaken
	
		local CONST_BOX_HEIGHT = 220
		local CONST_BOX_VERTICAL_SPACING = -26
		local CONST_BOX_HORIZONTAL_SPACING = 42
	
		local BOX_WIDTH = 250
		local BOX_HEIGHT = CONST_BOX_HEIGHT --232
		local BOX_HEIGHT_UPPER = CONST_BOX_HEIGHT --175
		
	
		local container_damagetaken_window = CreateFrame ("ScrollFrame", "Details_Boss_ContainerDamageTaken", frame,"BackdropTemplate")
		set_backdrop (container_damagetaken_window)
		
		local container_damagetaken_frame = CreateFrame ("Frame", "Details_Boss_FrameDamageTaken", container_damagetaken_window,"BackdropTemplate")
		
		frame.Widgets [#frame.Widgets+1] = container_damagetaken_window
		
		container_damagetaken_frame:SetScript ("OnMouseDown", mouse_down)
		container_damagetaken_frame:SetScript ("OnMouseUp", mouse_up)
		container_damagetaken_frame.barras = {}

		--label titulo & background		
		local dano_recebido_bg = CreateFrame ("Frame", nil, frame, "BackdropTemplate")
		dano_recebido_bg:SetWidth (BOX_WIDTH)
		dano_recebido_bg:SetHeight (16)
		dano_recebido_bg:EnableMouse (true)
		dano_recebido_bg:SetResizable (false)
		dano_recebido_bg:SetPoint ("topleft", frame, "topleft", 10, -78)
		
		frame.Widgets [#frame.Widgets+1] = dano_recebido_bg
		
		DetailsFrameWork:NewLabel (dano_recebido_bg, dano_recebido_bg, nil, "damagetaken_title", "Damage Taken per Player", "GameFontHighlight") --localize-me
		dano_recebido_bg.damagetaken_title:SetPoint ("BOTTOMLEFT", container_damagetaken_window, "TOPLEFT", 5, 1)
		
		container_damagetaken_frame:SetBackdrop (backdrop)
		container_damagetaken_frame:SetBackdropBorderColor (0,0,0,0)
		container_damagetaken_frame:SetBackdropColor (0, 0, 0, 0.6)
		
		container_damagetaken_frame:SetAllPoints (container_damagetaken_window)
		container_damagetaken_frame:SetWidth (BOX_WIDTH)
		container_damagetaken_frame:SetHeight (BOX_HEIGHT)
		container_damagetaken_frame:EnableMouse (true)
		container_damagetaken_frame:SetResizable (false)
		container_damagetaken_frame:SetMovable (true)
		
		container_damagetaken_window:SetWidth (BOX_WIDTH)
		container_damagetaken_window:SetHeight (BOX_HEIGHT)
		container_damagetaken_window:SetScrollChild (container_damagetaken_frame)
		container_damagetaken_window:SetPoint ("TOPLEFT", frame, "TOPLEFT", 10, -92)

		DetailsFrameWork:NewScrollBar (container_damagetaken_window, container_damagetaken_frame, 4, -16)
		container_damagetaken_window.slider:Altura (BOX_HEIGHT - 31)
		container_damagetaken_window.slider:cimaPoint (0, 1)
		container_damagetaken_window.slider:baixoPoint (0, -1)
		container_damagetaken_frame.slider = container_damagetaken_window.slider
		_detalhes.gump:ReskinSlider (container_damagetaken_window)
		
		container_damagetaken_window.gump = container_damagetaken_frame
		container_damagetaken_frame.window = container_damagetaken_window
		container_damagetaken_window.ultimo = 0
		frame.overall_damagetaken = container_damagetaken_window
		
	--> Caixa das Habilidades do boss
	--~ability ~damage taken by spell
		local container_habilidades_window = CreateFrame ("ScrollFrame", "Details_Boss_ContainerHabilidades", frame,"BackdropTemplate")
		set_backdrop (container_habilidades_window)
		
		local container_habilidades_frame = CreateFrame ("Frame", "Details_Boss_FrameHabilidades", container_habilidades_window,"BackdropTemplate")
		container_habilidades_frame:SetScript ("OnMouseDown",  mouse_down)
		container_habilidades_frame:SetScript ("OnMouseUp", mouse_up)
		container_habilidades_frame.barras = {}

		--label titulo % background
		local habilidades_inimigas_bg = CreateFrame ("Frame", nil, frame, "BackdropTemplate")
		habilidades_inimigas_bg:SetWidth (BOX_WIDTH)
		habilidades_inimigas_bg:SetHeight (16)
		habilidades_inimigas_bg:EnableMouse (true)
		habilidades_inimigas_bg:SetResizable (false)
		habilidades_inimigas_bg:SetPoint ("topleft", frame, "topleft", 10, -276)
		
		frame.Widgets [#frame.Widgets+1] = habilidades_inimigas_bg
		frame.Widgets [#frame.Widgets+1] = container_habilidades_window
		frame.Widgets [#frame.Widgets+1] = container_habilidades_frame
		
		DetailsFrameWork:NewLabel (habilidades_inimigas_bg, habilidades_inimigas_bg, nil, "habilidades_title", "Damage Taken by Spell", "GameFontHighlight") --localize-me
		habilidades_inimigas_bg.habilidades_title:SetPoint ("BOTTOMLEFT", container_habilidades_window, "TOPLEFT", 5, 1)
		
		container_habilidades_frame:SetBackdrop (backdrop)
		container_habilidades_frame:SetBackdropBorderColor (0,0,0,0)
		container_habilidades_frame:SetBackdropColor (0, 0, 0, 0.6)
		
		container_habilidades_frame:SetAllPoints (container_habilidades_window)
		container_habilidades_frame:SetWidth (BOX_WIDTH)
		container_habilidades_frame:SetHeight (BOX_HEIGHT)
		container_habilidades_frame:EnableMouse (true)
		container_habilidades_frame:SetResizable (false)
		container_habilidades_frame:SetMovable (true)
		
		container_habilidades_window:SetWidth (BOX_WIDTH)
		container_habilidades_window:SetHeight (BOX_HEIGHT)
		container_habilidades_window:SetScrollChild (container_habilidades_frame)
		container_habilidades_window:SetPoint ("TOPLEFT", container_damagetaken_window, "bottomleft", 0, CONST_BOX_VERTICAL_SPACING) --LOCATION

		DetailsFrameWork:NewScrollBar (container_habilidades_window, container_habilidades_frame, 4, -16)
		container_habilidades_window.slider:Altura (BOX_HEIGHT-31)
		container_habilidades_window.slider:cimaPoint (0, 1)
		container_habilidades_window.slider:baixoPoint (0, -1)
		container_habilidades_frame.slider = container_habilidades_window.slider
		_detalhes.gump:ReskinSlider (container_habilidades_window)
		
		container_habilidades_window.gump = container_habilidades_frame
		container_habilidades_frame.window = container_habilidades_window
		container_habilidades_window.ultimo = 0
		frame.overall_habilidades = container_habilidades_window
		
		
	--> Caixa dos Adds
	-- ~adds �dds
		local BOX_WIDTH = 270
		local BOX_HEIGHT = CONST_BOX_HEIGHT --173
	
		local container_adds_window = CreateFrame ("ScrollFrame", "Details_Boss_ContainerAdds", frame,"BackdropTemplate")
		set_backdrop (container_adds_window)
		
		local container_adds_frame = CreateFrame ("Frame", "Details_Boss_FrameAdds", container_adds_window, "BackdropTemplate")
		frame.Widgets [#frame.Widgets+1] = container_adds_frame 
		frame.Widgets [#frame.Widgets+1] = container_adds_window
		container_adds_frame.barras = {}
		
		local adds_total_string = DetailsFrameWork:CreateLabel (container_adds_window, "damage taken")
		adds_total_string.textcolor = "gray"
		adds_total_string.textsize = 9
		adds_total_string:SetPoint ("bottomright",  container_adds_window, "topright", 0, 3)
		
		container_adds_frame:SetAllPoints (container_adds_window)
		container_adds_frame:SetWidth (BOX_WIDTH)
		container_adds_frame:SetHeight (BOX_HEIGHT)
		container_adds_frame:EnableMouse (true)
		container_adds_frame:SetResizable (false)
		container_adds_frame:SetMovable (true)
		
		container_adds_window:SetWidth (BOX_WIDTH)
		container_adds_window:SetHeight (BOX_HEIGHT_UPPER)
		container_adds_window:SetScrollChild (container_adds_frame)
		container_adds_window:SetPoint ("TOPLEFT", container_damagetaken_window, "topright", CONST_BOX_HORIZONTAL_SPACING, 0)

		DetailsFrameWork:NewLabel (container_adds_window, container_adds_window, nil, "titulo", "Enemy Damage Taken", "GameFontHighlight")
		container_adds_window.titulo:SetPoint ("bottomleft", container_adds_window, "topleft", 0, 1)
		
		DetailsFrameWork:NewScrollBar (container_adds_window, container_adds_frame, 4, -16)
		container_adds_window.slider:Altura (BOX_HEIGHT - 31)
		container_adds_window.slider:cimaPoint (0, 1)
		container_adds_window.slider:baixoPoint (0, -1)
		container_adds_frame.slider = container_adds_window.slider
		_detalhes.gump:ReskinSlider (container_adds_window)
		
		container_adds_window.gump = container_adds_frame
		container_adds_frame.window = container_adds_window
		container_adds_window.ultimo = 0
		frame.overall_adds = container_adds_window
		
	--> Caixa dos interrupts (kicks)
	-- ~interrupt
		local container_interrupt_window = CreateFrame ("ScrollFrame", "Details_Boss_Containerinterrupt", frame,"BackdropTemplate")
		set_backdrop (container_interrupt_window)
		
		local container_interrupt_frame = CreateFrame ("Frame", "Details_Boss_Frameinterrupt", container_interrupt_window, "BackdropTemplate")
		
		local interrupt_total_string = DetailsFrameWork:CreateLabel (container_interrupt_window, "interrupts / casts")
		interrupt_total_string.textcolor = "gray"
		interrupt_total_string.textsize = 9		
		interrupt_total_string:SetPoint ("bottomright", container_interrupt_window, "topright", 0, 3)		
		
		frame.Widgets [#frame.Widgets+1] = container_interrupt_window
		frame.Widgets [#frame.Widgets+1] = container_interrupt_frame
		container_interrupt_frame:SetScript ("OnMouseDown",  mouse_down)
		container_interrupt_frame:SetScript ("OnMouseUp", mouse_up)
		container_interrupt_frame.barras = {}
		
		container_interrupt_frame:SetAllPoints (container_interrupt_window)
		container_interrupt_frame:SetWidth (BOX_WIDTH)
		container_interrupt_frame:SetHeight (BOX_HEIGHT)
		container_interrupt_frame:EnableMouse (true)
		container_interrupt_frame:SetResizable (false)
		container_interrupt_frame:SetMovable (true)
		
		container_interrupt_window:SetWidth (BOX_WIDTH)
		container_interrupt_window:SetHeight (BOX_HEIGHT_UPPER)
		container_interrupt_window:SetScrollChild (container_interrupt_frame)
		container_interrupt_window:SetPoint ("TOPLEFT", container_adds_window, "TOPRIGHT", CONST_BOX_HORIZONTAL_SPACING, 0)

		DetailsFrameWork:NewLabel (container_interrupt_window, container_interrupt_window, nil, "titulo", Loc ["STRING_INTERRUPTS"], "GameFontHighlight")
		container_interrupt_window.titulo:SetPoint ("bottomleft", container_interrupt_window, "topleft", 0, 1)
		
		DetailsFrameWork:NewScrollBar (container_interrupt_window, container_interrupt_frame, 4, -16)
		container_interrupt_window.slider:Altura (BOX_HEIGHT-31)
		container_interrupt_window.slider:cimaPoint (0, 1)
		container_interrupt_window.slider:baixoPoint (0, -1)
		container_interrupt_frame.slider = container_interrupt_window.slider
		_detalhes.gump:ReskinSlider (container_interrupt_window)
		
		
		container_interrupt_window.gump = container_interrupt_frame
		container_interrupt_frame.window = container_interrupt_window
		container_interrupt_window.ultimo = 0
		frame.overall_interrupt = container_interrupt_window
		
	--> Caixa dos Dispells
	-- ~dispel
		local container_dispell_window = CreateFrame ("ScrollFrame", "Details_Boss_Containerdispell", frame,"BackdropTemplate")
		set_backdrop (container_dispell_window)
		
		local container_dispell_frame = CreateFrame ("Frame", "Details_Boss_Framedispell", container_dispell_window, "BackdropTemplate")
		
		local dispell_total_string = DetailsFrameWork:CreateLabel (container_dispell_window, "total dispels")
		dispell_total_string.textcolor = "gray"
		dispell_total_string.textsize = 9		
		dispell_total_string:SetPoint ("bottomright", container_dispell_window, "topright", 0, 3)
		
		frame.Widgets [#frame.Widgets+1] = container_dispell_window
		frame.Widgets [#frame.Widgets+1] = container_dispell_frame
		container_dispell_frame:SetScript ("OnMouseDown",  mouse_down)
		container_dispell_frame:SetScript ("OnMouseUp", mouse_up)
		container_dispell_frame.barras = {}

		container_dispell_frame:SetAllPoints (container_dispell_window)
		container_dispell_frame:SetWidth (BOX_WIDTH)
		container_dispell_frame:SetHeight (BOX_HEIGHT)
		container_dispell_frame:EnableMouse (true)
		container_dispell_frame:SetResizable (false)
		container_dispell_frame:SetMovable (true)
		
		container_dispell_window:SetWidth (BOX_WIDTH)
		container_dispell_window:SetHeight (BOX_HEIGHT_UPPER)
		container_dispell_window:SetScrollChild (container_dispell_frame)
		container_dispell_window:SetPoint ("TOPLEFT", container_adds_window, "BOTTOMLEFT", 0, CONST_BOX_VERTICAL_SPACING)

		DetailsFrameWork:NewLabel (container_dispell_window, container_dispell_window, nil, "titulo", Loc ["STRING_DISPELLS"], "GameFontHighlight")
		container_dispell_window.titulo:SetPoint ("bottomleft", container_dispell_window, "topleft", 0, 1)
		
		DetailsFrameWork:NewScrollBar (container_dispell_window, container_dispell_frame, 4, -16)
		container_dispell_window.slider:Altura (BOX_HEIGHT-31)
		container_dispell_window.slider:cimaPoint (0, 1)
		container_dispell_window.slider:baixoPoint (0, -1)
		container_dispell_frame.slider = container_dispell_window.slider
		_detalhes.gump:ReskinSlider (container_dispell_window)

		container_dispell_window.gump = container_dispell_frame
		container_dispell_frame.window = container_dispell_window
		container_dispell_window.ultimo = 0
		frame.overall_dispell = container_dispell_window		
		
	--> Caixa das mortes
	-- ~mortes ~deaths ~dead
		local container_dead_window = CreateFrame ("ScrollFrame", "Details_Boss_ContainerDead", frame,"BackdropTemplate")
		set_backdrop (container_dead_window)
		
		local container_dead_frame = CreateFrame ("Frame", "Details_Boss_FrameDead", container_dead_window, "BackdropTemplate")
		
		local dead_total_string = DetailsFrameWork:CreateLabel (container_dead_window, "time of death")
		dead_total_string.textcolor = "gray"
		dead_total_string.textsize = 9		
		dead_total_string:SetPoint ("bottomright", container_dead_window, "topright", 0, 3)
		
		frame.Widgets [#frame.Widgets+1] = container_dead_window
		frame.Widgets [#frame.Widgets+1] =  container_dead_frame
		container_dead_frame:SetScript ("OnMouseDown",  mouse_down)
		container_dead_frame:SetScript ("OnMouseUp", mouse_up)
		container_dead_frame.barras = {}
		
		container_dead_frame:SetPoint ("left", container_dead_window, "left")
		container_dead_frame:SetPoint ("right", container_dead_window, "right")
		container_dead_frame:SetPoint ("top", container_dead_window, "top")
		container_dead_frame:SetPoint ("bottom", container_dead_window, "bottom", 0, 10)
		
		container_dead_frame:SetWidth (BOX_WIDTH)
		container_dead_frame:SetHeight (BOX_HEIGHT)
		
		container_dead_frame:EnableMouse (true)
		container_dead_frame:SetResizable (false)
		container_dead_frame:SetMovable (true)
		
		container_dead_window:SetWidth (BOX_WIDTH)
		container_dead_window:SetHeight (BOX_HEIGHT_UPPER)
		container_dead_window:SetScrollChild (container_dead_frame)
		container_dead_window:SetPoint ("TOPLEFT", container_dispell_window, "TOPRIGHT", CONST_BOX_HORIZONTAL_SPACING, 0)
		
		DetailsFrameWork:NewLabel (container_dead_window, container_dead_window, nil, "titulo", Loc ["STRING_DEATH_LOG"], "GameFontHighlight")
		container_dead_window.titulo:SetPoint ("bottomleft", container_dead_window, "topleft", 0, 1)
		
		DetailsFrameWork:NewScrollBar (container_dead_window, container_dead_frame, 4, -16)
		container_dead_window.slider:Altura (BOX_HEIGHT-31)
		container_dead_window.slider:cimaPoint (0, 1)
		container_dead_window.slider:baixoPoint (0, -1)
		container_dead_frame.slider = container_dead_window.slider
		_detalhes.gump:ReskinSlider (container_dead_window)
		
		container_dead_window.gump = container_dead_frame
		container_dead_frame.window = container_dead_window
		container_dead_window.ultimo = 0
		frame.overall_dead = container_dead_window
		
		
	--emotes frame
	local emote_frame = CreateFrame ("frame", "DetailsEncountersEmoteFrame", UIParent, "BackdropTemplate")
	emote_frame:RegisterEvent ("CHAT_MSG_RAID_BOSS_EMOTE")
	emote_frame:RegisterEvent ("CHAT_MSG_RAID_BOSS_WHISPER")
	emote_frame:RegisterEvent ("CHAT_MSG_MONSTER_EMOTE")
	emote_frame:RegisterEvent ("CHAT_MSG_MONSTER_SAY")
	emote_frame:RegisterEvent ("CHAT_MSG_MONSTER_WHISPER")
	emote_frame:RegisterEvent ("CHAT_MSG_MONSTER_PARTY")
	emote_frame:RegisterEvent ("CHAT_MSG_MONSTER_YELL")
	
	local emote_table = {
		["CHAT_MSG_RAID_BOSS_EMOTE"] = 1,
		["CHAT_MSG_RAID_BOSS_WHISPER"] = 2,
		["CHAT_MSG_MONSTER_EMOTE"] = 3,
		["CHAT_MSG_MONSTER_SAY"] = 4,
		["CHAT_MSG_MONSTER_WHISPER"] = 5,
		["CHAT_MSG_MONSTER_PARTY"] = 6,
		["CHAT_MSG_MONSTER_YELL"] = 7,
	}
	
	emote_frame:SetScript ("OnEvent", function (...)
	
		if (not EncounterDetails.current_whisper_table) then
			return
		end
	
		local combat = EncounterDetails:GetCombat ("current")
		--local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
		--print ("2 =", arg2, "3 =", arg3, "4 =",  arg4, "5 =",  arg5, "6 =",  arg6, "7 =",  arg7, "8 =",  arg8, "9 =",  arg9)
		if (combat and EncounterDetails:IsInCombat() and EncounterDetails:GetZoneType() == "raid") then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
			tinsert (EncounterDetails.current_whisper_table, {combat:GetCombatTime(), arg3, arg4, emote_table [arg2]})
		end
	end)
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




end
end
--endd


do

	local wipe = _G.wipe
	local Details = _G.Details
	local _detalhes = _G._detalhes


	_detalhes.DeathGraphsWindowBuilder = function (DeathGraphs)

		local tinsert = tinsert
		local GetSpellInfo = GetSpellInfo
		local unpack = unpack
		
		local f = DeathGraphs.Frame
		
		local framework = _G._detalhes:GetFramework()
		local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
		
		local CONST_DBTYPE_DEATH = "deaths"
		local CONST_DBTYPE_ENDURANCE = "endurance"
		local CONST_COORDS_NO_BORDER = {5/64, 59/64, 5/64, 59/64}
		
		local BUTTON_BACKGROUND_COLOR = {.2, .2, .2, .75}
		local BUTTON_BACKGROUND_COLORHIGHLIGHT = {.5, .5, .5, .8}
		
		local CONST_MIN_HEALINGDONE_DEATHLOG = 100
		local CONST_MAX_DEATH_EVENTS = 29
		local CONST_MAX_DEATH_PLAYERS = 25
		
		local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_DeathGraphs")
		
		local debugmode = false
		local cooltip_block_bg = {0, 0, 0, 1}
		local _
		
		framework.button_templates ["ADL_BUTTON_TEMPLATE"] = {
			backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
			backdropcolor = {.3, .3, .3, .9},
			onentercolor = {.6, .6, .6, .9},
			backdropbordercolor = {0, 0, 0, 1},
			onenterbordercolor = {0, 0, 0, 1},
		}
		
		framework:InstallTemplate ("button", "ADL_MENUBUTTON_TEMPLATE", {width = 160}, "DETAILS_PLUGIN_BUTTON_TEMPLATE")
		framework:InstallTemplate ("button", "ADL_MENUBUTTON_SELECTED_TEMPLATE", {width = 160}, "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE")
		
		local options_text_template = framework:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = framework:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
		local options_switch_template = framework:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
		local options_slider_template = framework:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
		local options_button_template = framework:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
		
		local mode_buttons_width = 140
		local mode_buttons_height = 20
		local mode_buttons_y_pos = 10		
	
	--> main frame
	
		f:SetFrameStrata ("HIGH")
		f:SetToplevel (true)
		f:SetPoint ("center", UIParent, "center")
		
		f:SetSize (925, 498)
		
		f:EnableMouse (true)
		f:SetResizable (false)
		f:SetMovable (true)
		f:SetScript ("OnMouseDown", 
						function (self, botao)
							if (botao == "LeftButton") then
								if (self.isMoving) then
									return
								end
								self:StartMoving()
								self.isMoving = true
							elseif (botao == "RightButton") then
								if (self.isMoving) then
									return
								end
								DeathGraphs:CloseWindow()
							end
						end)
						
		f:SetScript ("OnMouseUp", 
						function (self)
							if (self.isMoving) then
								self:StopMovingOrSizing()
								self.isMoving = false
							end
						end)

		f:SetBackdrop (_detalhes.PluginDefaults and _detalhes.PluginDefaults.Backdrop or {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1}})
		
		f:SetBackdropColor (unpack (_detalhes.PluginDefaults and _detalhes.PluginDefaults.BackdropColor or {0, 0, 0, .6}))
		f:SetBackdropBorderColor (unpack (_detalhes.PluginDefaults and _detalhes.PluginDefaults.BackdropBorderColor or {0, 0, 0, 1}))		
		
		f.bg1 = f:CreateTexture (nil, "background")
		f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
		f.bg1:SetAlpha (0.7)
		f.bg1:SetVertexColor (0.27, 0.27, 0.27)
		f.bg1:SetVertTile (true)
		f.bg1:SetHorizTile (true)
		f.bg1:SetAllPoints()

		local bottom_texture = framework:NewImage (f, nil, 922, 25, "background", nil, nil, "$parentBottomTexture")
		bottom_texture:SetColorTexture (0, 0, 0, .6)
		bottom_texture:SetPoint ("bottomleft", f, "bottomleft", 2, 7)
		
		local c = CreateFrame ("Button", nil, f, "UIPanelCloseButton")
		c:SetWidth (20)
		c:SetHeight (20)
		c:SetPoint ("TOPRIGHT",  f, "TOPRIGHT", -2, -3)
		c:SetFrameLevel (f:GetFrameLevel()+1)
		c:GetNormalTexture():SetDesaturated (true)
		c:SetAlpha (1)
		
		C_Timer.After (0.05, function()
			f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			f:SetBackdropColor (0.2, 0.2, 0.2, .6)
			f:SetBackdropBorderColor (0, 0, 0, 1)
			
		--title bar
			local titlebar = CreateFrame ("frame", nil, f, "BackdropTemplate")
			titlebar:SetPoint ("topleft", f, "topleft", 2, -3)
			titlebar:SetPoint ("topright", f, "topright", -2, -3)
			titlebar:SetHeight (20)
			titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar:SetBackdropColor (.5, .5, .5, 1)
			titlebar:SetBackdropBorderColor (0, 0, 0, 1)

			local name_bg_texture = f:CreateTexture (nil, "background")
			name_bg_texture:SetTexture ([[Interface\PetBattles\_PetBattleHorizTile]], true)
			name_bg_texture:SetHorizTile (true)
			name_bg_texture:SetTexCoord (0, 1, 126/256, 19/256)
			name_bg_texture:SetPoint ("topleft", f, "topleft", 2, -22)
			name_bg_texture:SetPoint ("bottomright", f, "bottomright")
			name_bg_texture:SetHeight (54)
			name_bg_texture:SetVertexColor (0, 0, 0, 0.2)
		
		--window title
			local titleLabel = _detalhes.gump:NewLabel (titlebar, titlebar, nil, "titulo", "Advanced Death Logs", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
			titleLabel:SetPoint ("center", f, "center")
			titleLabel:SetPoint ("top", f, "top", 0, -7)
		end)
		
		DeathGraphs.selected_texture_boss = framework:NewImage (f, "Interface\\SPELLBOOK\\Spellbook-Parts", 190, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_boss:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_boss2 = framework:NewImage (f, "Interface\\SPELLBOOK\\Spellbook-Parts", 190, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_boss2:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_boss2:SetAllPoints (DeathGraphs.selected_texture_boss.widget)


		
	--> boss scroll
		
		--
			local dicon, dL, dR, dT, dB = [[Interface\GossipFrame\IncompleteQuestIcon]], 0, 1, 0, 1
			local get_texture = function (t)
				if (t.boss_table) then
					return DeathGraphs:GetBossIcon (t.boss_table.mapid, t.boss_table.index)
				else
					return dL, dR, dT, dB, dicon
				end
			end
			local get_bd_table = function()
				if (DeathGraphs.db.showing_type == 1) then
					return DeathGraphs.deaths_database
				elseif (DeathGraphs.db.showing_type == 2) then
					return DeathGraphs.endurance_database
				end
			end
	
		--boss dropdowns:
			local dropdown_label_rf = framework:NewLabel (f, nil, "$parentRFLabel", nil, "Raid Finder:", "GameFontNormal")
			local dropdown_label_normal = framework:NewLabel (f, nil, "$parentNormalLabel", nil, "Normal:", "GameFontNormal")
			local dropdown_label_heroic = framework:NewLabel (f, nil, "$parentHeroicLabel", nil, "Heroic:", "GameFontNormal")
			local dropdown_label_mythic = framework:NewLabel (f, nil, "$parentMythicLabel", nil, "Mythic:", "GameFontNormal")
		
			local OnSelectBoss = function (_, _, boss)
				DeathGraphs.db.last_boss = boss
				if (DeathGraphs.db.showing_type == 1) then
					DeathGraphs:RefreshPlayerScroll()
				elseif (DeathGraphs.db.showing_type == 2) then
					DeathGraphs:ShowEndurance (boss, true)
				end
				
				DeathGraphs:RefreshBossScroll()
			end

			local build_rf_bosses = function()
				local db_table = get_bd_table() or {}
				
				local output = {}
				for hash, t in pairs (db_table) do
					if (t.diff == 17) then
						local l, r, tt, b, texture = get_texture (t)
						tinsert (output, {value = t.hash, label = t.name, onclick = OnSelectBoss, icon = texture, texcoord = {l, r, tt, b}})
					end
				end
				
				return output
			end
			
			local build_normal_bosses = function()
				local db_table = get_bd_table() or {}
				local output = {}
				
				for hash, t in pairs (db_table) do
					if (t.diff == 14) then
						local l, r, tt, b, texture = get_texture (t)
						tinsert (output, {value = t.hash, label = t.name, onclick = OnSelectBoss, icon = texture, texcoord = {l, r, tt, b}})
					end
				end
				
				return output
			end
			local build_heroic_bosses = function()
				local db_table = get_bd_table() or {}
				local output = {}
				
				for hash, t in pairs (db_table) do
					if (t.diff == 15) then
						local l, r, tt, b, texture = get_texture (t)
						tinsert (output, {value = t.hash, label = t.name, onclick = OnSelectBoss, icon = texture, texcoord = {l, r, tt, b}})
					end
				end
				
				return output
			end
			local build_mythic_bosses = function()
				local db_table = get_bd_table() or {}
				local output = {}
				
				for hash, t in pairs (db_table) do
					if (t.diff == 16) then
						local l, r, tt, b, texture = get_texture (t)
						tinsert (output, {value = t.hash, label = t.name, onclick = OnSelectBoss, icon = texture, texcoord = {l, r, tt, b}})
					end
				end
				
				return output
			end
			
			--> align the menus at the same point as the current deaths dropdown and timeline dropdowns
			local enduranceFrameMenuAnchor = CreateFrame ("frame", "DeathGraphsEnduranceFrameMenuAnchor", f, "BackdropTemplate")
			enduranceFrameMenuAnchor:SetPoint ("topleft", 10, -50)
			enduranceFrameMenuAnchor:SetSize (1, 1)
			
			local select_dropdown_rf = framework:NewDropDown (f, nil, "$parentRFDropdown", "RFDropdown", 150, 20, build_rf_bosses) -- , nil, options_dropdown_template
			local select_dropdown_normal = framework:NewDropDown (f, nil, "$parentNormalDropdown", "NormalDropdown", 150, 20, build_normal_bosses)
			local select_dropdown_heroic = framework:NewDropDown (f, nil, "$parentHeroicDropdown", "HeroicDropdown", 150, 20, build_heroic_bosses)
			local select_dropdown_mythic = framework:NewDropDown (f, nil, "$parentMythicDropdown", "MythicDropdown", 150, 20, build_mythic_bosses)

			local y = -5
			--dropdown_label_mythic:SetPoint ("topleft", f, "topleft", 10, -60)
			dropdown_label_mythic:SetPoint ("topleft", enduranceFrameMenuAnchor, "topleft", 0, 1)
			select_dropdown_mythic:SetPoint ("topleft", dropdown_label_mythic, "bottomleft", 0, y)
			dropdown_label_heroic:SetPoint ("topleft", select_dropdown_mythic, "bottomleft", 0, y)
			select_dropdown_heroic:SetPoint ("topleft", dropdown_label_heroic, "bottomleft", 0, y)
			dropdown_label_normal:SetPoint ("topleft", select_dropdown_heroic, "bottomleft", 0, y)
			select_dropdown_normal:SetPoint ("topleft", dropdown_label_normal, "bottomleft", 0, y)
			dropdown_label_rf:SetPoint ("topleft", select_dropdown_normal, "bottomleft", 0, y)
			select_dropdown_rf:SetPoint ("topleft", dropdown_label_rf, "bottomleft", 0, y)
			
			local backdrop = {bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16,
			edgeFile=[[Interface\AddOns\Details\images\border_2]], edgeSize=16,
			insets = {left = 0, right = 0, top = 0, bottom = 0}}
			local backdrop_color = {0, 0, 0, 0.3}
		
			select_dropdown_rf:SetBackdrop (backdrop)
			select_dropdown_normal:SetBackdrop (backdrop)
			select_dropdown_heroic:SetBackdrop (backdrop)
			select_dropdown_mythic:SetBackdrop (backdrop)
			
			select_dropdown_rf:SetBackdropColor (unpack (backdrop_color))
			select_dropdown_normal:SetBackdropColor (unpack (backdrop_color))
			select_dropdown_heroic:SetBackdropColor (unpack (backdrop_color))
			select_dropdown_mythic:SetBackdropColor (unpack (backdrop_color))
			
			select_dropdown_mythic.onleave_backdrop = backdrop_color
			select_dropdown_heroic.onleave_backdrop = backdrop_color
			select_dropdown_normal.onleave_backdrop = backdrop_color
			select_dropdown_rf.onleave_backdrop = backdrop_color
		
		function DeathGraphs:RefreshBossScroll()
			select_dropdown_rf:Refresh()
			select_dropdown_normal:Refresh()
			select_dropdown_heroic:Refresh()
			select_dropdown_mythic:Refresh()

			select_dropdown_rf:SetBackdropBorderColor (1, 1, 1, 0.3)
			select_dropdown_normal:SetBackdropBorderColor (1, 1, 1, 0.3)
			select_dropdown_heroic:SetBackdropBorderColor (1, 1, 1, 0.3)
			select_dropdown_mythic:SetBackdropBorderColor (1, 1, 1, 0.3)
			
			dropdown_label_mythic:SetTextColor (1, 1 , 1, 0.5)
			dropdown_label_heroic:SetTextColor (1, 1 , 1, 0.5)
			dropdown_label_normal:SetTextColor (1, 1 , 1, 0.5)
			dropdown_label_rf:SetTextColor (1, 1 , 1, 0.5)
			
			local hash = DeathGraphs.db.last_boss
			local diff
			
			if (hash) then
				diff = hash:gsub ("%d%d%d%d", "")
			else
				if (DeathGraphs.db.showing_type == 1) then
					DeathGraphs:RefreshPlayerScroll()
				elseif (DeathGraphs.db.showing_type == 2) then
					
				end
			end
			
			local rf_value = select_dropdown_rf.value
			local normal_value = select_dropdown_normal.value
			local heroic_value = select_dropdown_heroic.value
			local mythic_value = select_dropdown_mythic.value
			
			if (DeathGraphs.db.showing_type == 1) then
				
			elseif (DeathGraphs.db.showing_type == 2) then
				if (not DeathGraphs.endurance_database [rf_value]) then
					for _hash, t in pairs (DeathGraphs.endurance_database) do
						if (t.diff == 17) then
							select_dropdown_rf:Select (t.hash)
							break
						end
					end
				end
				if (not DeathGraphs.endurance_database [normal_value]) then
					for _hash, t in pairs (DeathGraphs.endurance_database) do
						if (t.diff == 14) then
							select_dropdown_normal:Select (t.hash)
							break
						end
					end
				end
				if (not DeathGraphs.endurance_database [heroic_value]) then
					for _hash, t in pairs (DeathGraphs.endurance_database) do
						if (t.diff == 15) then
							select_dropdown_heroic:Select (t.hash)
							break
						end
					end
				end
				if (not DeathGraphs.endurance_database [mythic_value]) then
					for _hash, t in pairs (DeathGraphs.endurance_database) do
						if (t.diff == 16) then
							select_dropdown_mythic:Select (t.hash)
							break
						end
					end
				end
			end

			if (diff == "14") then --normal
				select_dropdown_normal:SetBackdropBorderColor (1, 1, 0, 1)
				select_dropdown_normal:Select (hash)
				dropdown_label_normal:SetTextColor (1, 0.8 , 0, 1)
				
			elseif (diff == "15") then --heroic
				select_dropdown_heroic:SetBackdropBorderColor (1, 1, 0, 1)
				select_dropdown_heroic:Select (hash)
				dropdown_label_heroic:SetTextColor (1, 0.8 , 0, 1)
				
			elseif (diff == "16") then --mythic
				select_dropdown_mythic:SetBackdropBorderColor (1, 1, 0, 1)
				select_dropdown_mythic:Select (hash)
				dropdown_label_mythic:SetTextColor (1, 0.8 , 0, 1)
				
			elseif (diff == "17") then --rf
				select_dropdown_rf:SetBackdropBorderColor (1, 1, 0, 1)
				select_dropdown_rf:Select (hash)
				dropdown_label_rf:SetTextColor (1, 0.8 , 0, 1)
				
			end

		end
		
		local clear_func = function()

			local hash = DeathGraphs.db.last_boss
			
			if (DeathGraphs.db.showing_type == 1) then
				local db_table = DeathGraphs.deaths_database
				if (db_table and db_table [hash]) then
					table.wipe (db_table [hash])
				end
				db_table [hash] = nil
				
				if (DeathGraphs.db.last_boss == hash) then
					DeathGraphs.db.last_player = false
					DeathGraphs.db.last_segment = false
					DeathGraphs.db.last_boss = false
					
					for hash, _ in pairs (DeathGraphs.deaths_database) do
						DeathGraphs.db.last_boss = hash
						if (DeathGraphs.db.last_boss) then
							break
						end
					end
				end

				DeathGraphs.graphic_frame:Reset()
				DeathGraphs:ClearOverall()
				DeathGraphs:Refresh()
				
			elseif (DeathGraphs.db.showing_type == 2) then
				local db_table = DeathGraphs.endurance_database
				table.wipe (db_table [hash])
				db_table [hash] = nil
				DeathGraphs:ShowEndurance()
			end
			
			--> add
			
		end

		local AMOUNT_PLAYER_DEATH_LABELS = 17
		
	--> player scroll
		local player_refresh = function (self)
			--> pega a lista de player
			local boss_hash = DeathGraphs.db.last_boss
			local players = DeathGraphs.deaths_database [boss_hash]

			if (debugmode) then
				print ("player refresh (boss_hash, players):", boss_hash, players)
			end
			
			DeathGraphs.selected_texture_player:Hide()
			DeathGraphs.selected_texture_player2:Hide()
			
			if (players) then
				local players_list = players.player_db
				
				local amount = 0
				local numeric = {}
				
				for playername, t in pairs (players_list) do 
					if (#t.deaths > 0) then
						amount = amount+1
						tinsert (numeric, t)
					end
				end
				table.sort (numeric, function(t1, t2) return t1.name < t2.name end)
				
				FauxScrollFrame_Update (self, amount, 16, 21)
				
				local offset = FauxScrollFrame_GetOffset (self)

				for bar_index = 1, AMOUNT_PLAYER_DEATH_LABELS do
					local data = numeric [bar_index + offset]
					local button = self.buttons [bar_index]
					if (data) then
					
						button:SetText (DeathGraphs:GetOnlyName (data.name))
						
						if (data.class) then
							local r, g, b = DeathGraphs:GetClassColor (data.class)
							button.text_overlay:SetTextColor (.9, .9, .9)
							local _, l, r, t, b = DeathGraphs:GetClassIcon (data.class)
							button:SetIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], 16, 16, "overlay", {l, r, t, b})
						else
							button.text_overlay:SetTextColor (1, 1, 1)
							button:SetIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], 16, 16, "overlay", {0.75, 1, 0.5, 0.75})
						end
						
						button.player_table = data
						button.player_name = data.name
						
						if (DeathGraphs.db.last_player == data.name) then
							DeathGraphs.selected_texture_player:SetPoint ("topleft", button, "topleft", -2, 1)
							DeathGraphs.selected_texture_player:SetPoint ("bottomleft", button, "bottomleft", -2, -3)
							DeathGraphs.selected_texture_player:Show()
							DeathGraphs.selected_texture_player2:Show()
						end
				
						button:Show()
					else
						button:Hide()
					end
				end
			else
				for bar_index = 1, AMOUNT_PLAYER_DEATH_LABELS do
					local button = self.buttons [bar_index]
					button:Hide()
				end
			end
		end
		
		local player_overall_anchor = CreateFrame ("frame", "DeathGraphsPlayerOverallAnchor", f, "BackdropTemplate")
		player_overall_anchor:SetPoint ("topleft", enduranceFrameMenuAnchor, "topleft", 170, -45)
		player_overall_anchor:SetSize (1, 1)
		
		DeathGraphs.selected_texture_player = framework:NewImage (player_overall_anchor, "Interface\\SPELLBOOK\\Spellbook-Parts", 100, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_player:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_player2 = framework:NewImage (player_overall_anchor, "Interface\\SPELLBOOK\\Spellbook-Parts", 100, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_player2:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_player2:SetAllPoints (DeathGraphs.selected_texture_player.widget)
		
		DeathGraphs.selected_texture_segment = framework:NewImage (player_overall_anchor, "Interface\\SPELLBOOK\\Spellbook-Parts", 90, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_segment:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_segment2 = framework:NewImage (player_overall_anchor, "Interface\\SPELLBOOK\\Spellbook-Parts", 90, 50, "border", {0.31250000, 0.96484375, 0.37109375, 0.52343750})
		DeathGraphs.selected_texture_segment2:SetBlendMode ("ADD")
		DeathGraphs.selected_texture_segment2:SetAllPoints (DeathGraphs.selected_texture_segment.widget)
		
		local player_scroll = CreateFrame ("scrollframe", "DeathGraphsPlayerScroll", f, "FauxScrollFrameTemplate, BackdropTemplate")
		player_scroll:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, player_refresh) end)
		player_scroll:SetPoint ("topleft", player_overall_anchor, "topleft", 0, 0)
		player_scroll:SetSize (100, 360)
		player_scroll:SetFrameLevel (f:GetFrameLevel()+2)
		
		local player_bg_frame = CreateFrame ("frame", "DeathGraphsPlayerScrollBgFrame", f, "BackdropTemplate")
		player_bg_frame:SetPoint ("topleft", player_scroll, "topleft")
		player_bg_frame:SetPoint ("bottomright", player_scroll, "bottomright", -2, 0)
		player_bg_frame:SetFrameLevel (f:GetFrameLevel()+1)
		
		local clear_players_deaths = framework:NewButton (player_bg_frame, _, "$parentCleaPlayersDeathsButton", "CleaPlayersDeathsButton", 70, mode_buttons_height, clear_func, nil, nil, nil, "Clear", 1, options_dropdown_template)
		clear_players_deaths:SetPoint ("bottomleft", endurance_frame, "topleft", 0, 9)
		
		player_scroll:SetScript ("OnHide", function()
			for i = 1, AMOUNT_PLAYER_DEATH_LABELS do
				player_scroll.buttons[i]:Hide()
			end
		end)
		
		player_scroll.buttons = {}
		
		local player_button_on_click = function (self, button, param1, param2)
			--> carrega lista de segmentos para este jogador
			DeathGraphs.db.last_player = self.MyObject.player_name
			DeathGraphs:RefreshSegmentScroll()
			
			DeathGraphs:Select (nil, nil, 1)
			
			DeathGraphs.selected_texture_player:SetPoint ("topleft", self, "topleft", -2, 1)
			DeathGraphs.selected_texture_player:SetPoint ("bottomleft", self, "bottomleft", -2, -3)
			DeathGraphs.selected_texture_player:Show()
			DeathGraphs.selected_texture_player2:Show()
		end

		local player_on_enter = function (self, capsule)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
			capsule.textcolor = {1, 1, 1}
		end
		local player_on_leave = function (self, capsule)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			capsule.textcolor = {.9, .9, .9}
		end
	
		for i = 1, AMOUNT_PLAYER_DEATH_LABELS do
			local button = framework:NewButton (f, nil, "$parentPlayerButton" .. i, "PlayerButton" .. i, 94, 20, player_button_on_click, 1, nil, nil, "Player " .. i)
			button:SetPoint ("topleft", player_scroll, "topleft", 0, -(i-1) * 21)
			button.textalign = "left"
			button.textsize = 10
			tinsert (player_scroll.buttons, button)
			button:Hide()
			button:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			button:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			button:SetHook ("OnEnter", player_on_enter)
			button:SetHook ("OnLeave", player_on_leave)
		end
		
		function DeathGraphs:RefreshPlayerScroll()
			player_refresh (player_scroll)
		end
	
	--> segment scroll
		local segment_refresh = function (self)
			--> pega a lista de segmentos
			
			local boss_hash = DeathGraphs.db.last_boss
			local player_name = DeathGraphs.db.last_player
			
			if (debugmode) then
				print ("refresh segments:", boss_hash, player_name)
			end
			
			DeathGraphs.selected_texture_segment:Hide()
			DeathGraphs.selected_texture_segment2:Hide()
			
			if (player_name) then
			
				local player_container = DeathGraphs.deaths_database [boss_hash] and DeathGraphs.deaths_database [boss_hash].player_db [player_name]
				
				if (debugmode) then
					print ("refresh segments:", player_container)
				end
				
				if (player_container) then
					local amount = #player_container.deaths
					
					FauxScrollFrame_Update (self, amount, 8, 41)
					
					local offset = FauxScrollFrame_GetOffset (self)

					for bar_index = 1, 8 do
						local data = player_container.deaths [bar_index + offset]
						local button = self.buttons [bar_index]
						if (data) then
							-- data [8] --combat_id
							
							local minutos, segundos = math.floor (data[3]/60), math.floor (data[3]%60)
							button.text1:SetText ("#" .. bar_index + offset .. " (" .. minutos .. "m " .. segundos .. "s)")
							button.text2:SetText ("Try #" .. (data [8] or "0"))
							
							button.death_table = data
							button.index = bar_index + offset
							button:Show()
							
							if (DeathGraphs.db.last_segment == bar_index + offset) then
								DeathGraphs.selected_texture_segment:SetPoint ("topleft", button, "topleft", -1, 1)
								DeathGraphs.selected_texture_segment:SetPoint ("bottomleft", button, "bottomleft", -1, -3)
								DeathGraphs.selected_texture_segment:Show()
								DeathGraphs.selected_texture_segment2:Show()
							end
						else
							button:Hide()
						end
					end
				else
					for bar_index = 1, 8 do
						local button = self.buttons [bar_index]
						button:Hide()
					end
				end
			else
				for bar_index = 1, 8 do
					local button = self.buttons [bar_index]
					button:Hide()
				end
			end
		end
		
		local segments_scroll = CreateFrame ("scrollframe", "DeathGraphsSegmentScroll", f, "FauxScrollFrameTemplate, BackdropTemplate")
		segments_scroll:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, segment_refresh) end)
		segments_scroll:SetPoint ("topleft", enduranceFrameMenuAnchor, "topleft", 320, -45)
		segments_scroll:SetSize (100, 360)
		segments_scroll:SetFrameLevel (f:GetFrameLevel()+2)
		
		local segments_bg_frame = CreateFrame ("frame", nil, f, "BackdropTemplate")
		segments_bg_frame:SetPoint ("topleft", segments_scroll, "topleft")
		segments_bg_frame:SetPoint ("bottomright", segments_scroll, "bottomright", -5, 0)
		segments_bg_frame:SetFrameLevel (f:GetFrameLevel()+1)
		
		segments_scroll:SetScript ("OnHide", function()
			for i = 1, 8 do
				segments_scroll.buttons[i]:Hide()
			end
		end)
		
		segments_scroll.buttons = {}
		
		local segment_button_on_click = function (self, button, param1, param2)
			--> mostra o gr�fico para este segmento
			if (debugmode) then
				print ("on click segment:", self.MyObject.death_table, self.MyObject.index, DeathGraphs.db.last_boss)
			end
			DeathGraphs.db.last_segment = self.MyObject.index
			
			local death_table = DeathGraphs:GetBossTable (DeathGraphs.db.last_boss , nil, CONST_DBTYPE_DEATH)
			local player_table = DeathGraphs:GetPlayerTable (death_table, DeathGraphs.db.last_player)
			
			DeathGraphs:ShowGraphicForDeath (player_table.deaths [DeathGraphs.db.last_segment])
			
			DeathGraphs.selected_texture_segment:SetPoint ("topleft", self, "topleft", -1, 1)
			DeathGraphs.selected_texture_segment:SetPoint ("bottomleft", self, "bottomleft", -1, -3)
			DeathGraphs.selected_texture_segment:Show()
			DeathGraphs.selected_texture_segment2:Show()
		end
	
		local segments_on_enter = function (self)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
		end
		local segments_on_leave = function (self)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
		end
	
		for i = 1, 8 do
			local button = framework:NewButton (f, nil, "$parentSegmentButton" .. i, "SegmentButton" .. i, 95, 40, segment_button_on_click, i)
			
			button:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			button:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			
			button:SetHook ("OnEnter", segments_on_enter)
			button:SetHook ("OnLeave", segments_on_leave)
			
			button:SetPoint ("topleft", segments_scroll, "topleft", 0, -(i-1) * 41)
			button.textalign = "left"
			
			framework:CreateLabel (button, "label 1", nil, "white", "GameFontHighlightSmall", "text1")
			framework:CreateLabel (button, "label 2", nil, "white", "GameFontHighlightSmall", "text2")
			
			button.text1:SetPoint ("topleft", button, "topleft", 5, -10)
			button.text2:SetPoint ("topleft", button, "topleft", 5, -20)
			
			--button:InstallCustomTexture()
			tinsert (segments_scroll.buttons, button)
			button:Hide()
		end
		
		function DeathGraphs:RefreshSegmentScroll()
			segment_refresh (segments_scroll)
		end
		
	--> ~endurance box
		local endurance_frame = CreateFrame ("frame", "DeathGraphsEnduranceFrame", f, "BackdropTemplate")
		endurance_frame:SetFrameLevel (f:GetFrameLevel()+5)
		endurance_frame:SetPoint ("topleft", enduranceFrameMenuAnchor, "topleft", 170, -45)
		
		endurance_frame:SetSize (718, 470)
		endurance_frame:SetResizable (false)
		endurance_frame:SetMovable (true)
		
		local CONST_ENDURANCE_BREAKLINE = 450
		
		--
			local greenPercent = endurance_frame:CreateTexture (nil, "overlay")
			greenPercent:SetColorTexture (.2, 1, .2, .7)
			greenPercent:SetSize (6, 20)
			greenPercent:SetPoint ("topleft", dropdown_label_rf.widget, "bottomleft", 0, -40)
			
			local tutorialLabel3 = framework:CreateLabel (endurance_frame)
			tutorialLabel3:SetPoint ("topleft", greenPercent, "topright", 4, 1)
			tutorialLabel3.text = "Good, player never was one of the first three players dead"
			tutorialLabel3.width = 140
			tutorialLabel3:SetJustifyV ("top")
			
			local redPercent = endurance_frame:CreateTexture (nil, "overlay")
			redPercent:SetColorTexture (1, .2, .2, .7)
			redPercent:SetSize (6, 20)
			redPercent:SetPoint ("topleft", greenPercent, "bottomleft", 0, -20)
			
			local tutorialLabel4 = framework:CreateLabel (endurance_frame)
			tutorialLabel4:SetPoint ("topleft", redPercent, "topright", 4, 1)
			tutorialLabel4.text = "Bad, player often was one of the first three players dead"
			tutorialLabel4.width = 140
			tutorialLabel4:SetJustifyV ("top")
		--		
		
		if (not DetailsPluginContainerWindow) then
			endurance_frame:EnableMouse (true)
			endurance_frame:SetScript ("OnMouseDown", 
							function (self, botao)
								if (botao == "LeftButton") then
									if (f.isMoving) then
										return
									end
									f:StartMoving()
									f.isMoving = true
								elseif (botao == "RightButton") then
									if (f.isMoving) then
										return
									end
									DeathGraphs:CloseWindow()
								end
							end)
							
			endurance_frame:SetScript ("OnMouseUp", 
							function (self)
								if (f.isMoving) then
									f:StopMovingOrSizing()
									f.isMoving = false
								end
							end)
		else
			endurance_frame:EnableMouse (false)
		end
		
		endurance_frame.labels = {}
		endurance_frame:Hide()
		
		endurance_frame.x = 0
		endurance_frame.y = 0
		endurance_frame.y_original = 0
		
		--> erase current endurance shown
		
		local clear_endurance_func = function()
			local boss = DeathGraphs.db.last_boss
			if (not boss) then
				return
			end
			local boss_table = DeathGraphs.endurance_database [boss]
			if (not boss_table) then
				return
			end

			table.wipe (boss_table.player_db)
			DeathGraphs.endurance_database [boss] = nil
			endurance_frame:Clear()
			
			for hash, _ in pairs (DeathGraphs.endurance_database) do
				DeathGraphs.db.last_boss = hash
				DeathGraphs:Refresh()
				break
			end
		end
		local clear_endurance = framework:NewButton (endurance_frame, _, "$parentClearEnduranceButton", "ClearEnduranceButton", 120, mode_buttons_height, clear_endurance_func, nil, nil, nil, "Clear", 1, options_dropdown_template)
		clear_endurance:SetPoint ("bottomleft", endurance_frame, "topleft", 0, 9)

		--> report
		local report_endurance_func = function()
			local boss = DeathGraphs.db.last_boss
			if (not boss) then
				return
			end
			local boss_table = DeathGraphs.endurance_database [boss]
			if (not boss_table) then
				return
			end

			local reportFunc = function (IsCurrent, IsReverse, AmtLines)
				DeathGraphs.report_lines = {"Details!: Endurance for " .. (boss_table.name or "Unknown") .. " (A.D.L (plugin)):"}
				for i = 1, math.min (#endurance_frame.labels, AmtLines) do
					local label = endurance_frame.labels [i]
					if (label.panel:IsShown() and not label.gray_player) then
						tinsert (DeathGraphs.report_lines, label.name.text .. ": " .. label.points.text)
					end
				end
				DeathGraphs:SendReportLines (DeathGraphs.report_lines)
			end

			local use_slider = true
			DeathGraphs:SendReportWindow (reportFunc, nil, nil, use_slider)
		end
		local report_endurance = framework:NewButton (endurance_frame, _, "$parentReportEnduranceButton", "ReportEnduranceButton", 120, mode_buttons_height, report_endurance_func, nil, nil, nil, "Report", 1, options_dropdown_template)
		report_endurance:SetPoint ("left", clear_endurance, "right", 2, 0)

		function endurance_frame:Clear()
			for _, label in ipairs (self.labels) do 
				label.points:Hide()
				label.name:Hide()
				label.panel:Hide()
			end
		end
		
		local label_on_mouseup = function (self, button, capsule)
			
			if (button == "RightButton") then
				if (DeathGraphs.Frame.isMoving) then
					return
				end
				DeathGraphs:CloseWindow()
			end
			
			local reportFunc = function (IsCurrent, IsReverse, AmtLines)
				DeathGraphs.report_lines = {"Details!: Endurance Deaths for " .. capsule.label2.text .. " (A.D.L (plugin)):"}
				local deaths = capsule.deaths
				if (deaths) then
					if (#deaths > 0) then
						for i, death in ipairs (deaths) do
							local minutos, segundos = math.floor (death[2]/60), math.floor (death[2]%60)
							local damage = death[3]:gsub ("|c%x?%x?%x?%x?%x?%x?%x?%x?", ""):gsub ("|r", "")
							DeathGraphs.report_lines [#DeathGraphs.report_lines+1] = "#" .. death[1] .. ": " .. damage .. " (" .. minutos .. "m " .. segundos .. "s)"
						end
					end
				end
				DeathGraphs:SendReportLines (DeathGraphs.report_lines)
			end

			local use_slider = true
			DeathGraphs:SendReportWindow (reportFunc, nil, nil, use_slider)
			
		end
		
		local label_on_enter = function (self, capsule)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
			capsule.label2:SetTextColor (1, 1, 1)

			GameCooltip:Preset (2)
			GameCooltip:SetOwner (self, "topleft", "topright")
			
			GameCooltip:SetOption ("FixedWidth", 300)

			local total_encounters = capsule.encounters
			local points_earned = capsule.points
			
			GameCooltip:AddLine ("|cFFFFFF00Records: |r" .. total_encounters, "|cFFFFFF00Deaths: |r" .. #capsule.deaths .. (#capsule.deaths > 0 and " |cFFFFFF00(|r|cFFA0A0A01 each " .. format ("%.1f", total_encounters / #capsule.deaths) .. " tries|r|cFFFFFF00)|r" or ""), 1, "orange", "orange", 12, SharedMedia:Fetch ("font", "Friz Quadrata TT"))
			GameCooltip:AddLine (" ")
			
			local deaths = capsule.deaths
			if (deaths) then
				if (#deaths > 0) then
					for i, death in ipairs (deaths) do
						--[1] = combat_id [2] = dead_at [3] = last_hit
						local minutos, segundos = math.floor (death[2]/60), math.floor (death[2]%60)
						GameCooltip:AddLine ("|cFFFFFF00#" .. death[1] .. "|r  " .. minutos .. "m " .. segundos .. "s", death [3], 1, "orange", nil, 12, SharedMedia:Fetch ("font", "Friz Quadrata TT"))
						--GameCooltip:AddIcon (spellicon, 1, 1, 16, 16)
					end
				else
					GameCooltip:AddLine (Loc ["STRING_FLAWLESS"])
					GameCooltip:AddIcon ([[Interface\COMMON\ReputationStar]], 1, 1, nil, nil, 0, 0.5, 0.03125, 0.5)
				end
			end
			
			GameCooltip:Show()
		end
		
		local label_on_leave = function (self, capsule)
			if (capsule.ignored) then
				capsule.label2:SetTextColor (.5, .5, .5)
			else
				capsule.label2:SetTextColor (.9, .9, .9)
			end
			
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			GameCooltip:Hide()
		end
		
		local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16}
		
		function endurance_frame:SetPlayer (index, player_name, player_class, points, percent, encounters, deaths, min, max)
			local label = self.labels [index]
			
			if (not label) then
			
				local panel = framework:CreatePanel (endurance_frame, 200, 16)
				panel:SetBackdrop (backdrop)
				panel:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
				panel:SetPoint (self.x, self.y)
				panel:SetHook ("OnEnter", label_on_enter)
				panel:SetHook ("OnLeave", label_on_leave)
				panel:SetHook ("OnMouseUp", label_on_mouseup)
			
				local str1 = framework:NewLabel (panel, nil, "$parentLabel1" .. index, "label1", "", "GameFontHighlightSmall", 11)
				local str2 = framework:NewLabel (panel, nil, "$parentLabel2" .. index, "label2", "", "GameFontHighlightSmall", 11)
				local str3 = framework:NewLabel (panel, nil, "$parentLabel3" .. index, "label3", "", "GameFontHighlightSmall", 11)
				str2:SetWidth (120)
				str2:SetHeight (16)
				str3:SetHeight (16)
				str3:SetWidth (40)
				
				local icon1 = framework:NewImage (panel, nil, 14, 14, nil, nil, "icon")
				
				str1:SetPoint ("left", panel, "left")
				str3:SetPoint ("left", str1, "right", 6, 0)
				icon1:SetPoint ("left", str3, "right", 4, 0)
				str2:SetPoint ("left", icon1, "right", 4, 0)
				
				endurance_frame.y = endurance_frame.y - 17
				if (endurance_frame.y < -CONST_ENDURANCE_BREAKLINE) then
					endurance_frame.y = endurance_frame.y_original
					endurance_frame.x = endurance_frame.x + 220
				end
				self.labels [index] = {points = str1, name = str2, panel = panel, icon = icon1, recordsXdeaths = str3}
				label = self.labels [index]
			end

			label.gray_player = nil
			
			if (percent == 101) then
				
				label.points:SetTextColor (.5, .5, .5)
				label.points.text = string.format ("%.1f", math.abs ((#deaths / encounters * 100) - 100)) .. "%"
				
				label.name.text = DeathGraphs:GetOnlyName (player_name)
				local r, g, b = DeathGraphs:GetClassColor (player_class)
				label.name:SetTextColor (.5, .5, .5)
				
				label.gray_player = true
				
				local file, l, r, t, b = DeathGraphs:GetClassIcon (player_class)
				label.icon.texture = [[Interface\AddOns\Details\images\classes_small_alpha]]
				label.icon:SetTexCoord (l, r, t, b)
				label.icon:SetDesaturated (true)
				
				label.points:Show()
				label.name:Show()
				label.panel:Show()
				label.panel.deaths = deaths
				label.panel.encounters = encounters
				label.panel.points = points
				label.panel.ignored = true
			else
				local percent_scaled = DeathGraphs:Scale (min, max, 0, 100, percent)
				
				local r, g
				if (percent_scaled < 50) then
					r = 255
				else
					r = math.floor ( 255 - (percent_scaled * 2 - 100) * 255 / 100)
				end
				
				if (percent_scaled > 50) then
					g = 255
				else
					g = math.floor ( (percent_scaled * 2) * 255 / 100)
				end
				
				label.points:SetTextColor (r/255, g/255, 0)
				--label.recordsXdeaths:SetTextColor (r/255, g/255, 0)
				
				label.points.text = string.format ("%.1f", percent) .. "%"
				
				label.name.text = DeathGraphs:GetOnlyName (player_name)
				local r, g, b = DeathGraphs:GetClassColor (player_class)
				label.name:SetTextColor (.9, .9, .9)
				
				local file, l, r, t, b = DeathGraphs:GetClassIcon (player_class)
				label.icon.texture = [[Interface\AddOns\Details\images\classes_small_alpha]]
				label.icon:SetTexCoord (l, r, t, b)
				label.icon:SetDesaturated (false)
				
				label.points:Show()
				label.name:Show()
				label.panel:Show()
				
				label.panel.deaths = deaths
				label.panel.encounters = encounters
				label.panel.points = points
				label.panel.recordsXdeaths = #deaths .. " / " .. encounters
				
				label.recordsXdeaths.text = label.panel.recordsXdeaths
				label.recordsXdeaths:SetTextColor (.7, .7, .7)
				
				label.panel.ignored = nil
			end
		end
	
		function endurance_frame:Cancel()
			endurance_frame:Hide()
			DeathGraphs.db.showing_type = 1
			
			return
		end
	
		local reverse_sort = function (t1, t2)
			return t1[4] < t2[4]
		end
		
		--> if from dropdown, ignore all auto boss selection
		function DeathGraphs:ShowEndurance (boss, fromDropdown)
		
			player_scroll:Show()
			player_scroll:Hide()
			segments_scroll:Show()
			segments_scroll:Hide()
			segments_bg_frame:Hide()
			player_bg_frame:Hide()
			DeathGraphs.overall_bg:Hide()
			
			select_dropdown_rf:Show()
			select_dropdown_normal:Show()
			select_dropdown_heroic:Show()
			select_dropdown_mythic:Show()
			dropdown_label_rf:Show()
			dropdown_label_normal:Show()
			dropdown_label_heroic:Show()
			dropdown_label_mythic:Show()
			
			DeathGraphs.graphic_frame:Hide()
			
			--> refresh
			DeathGraphs.db.showing_type = 2
			DeathGraphs:RefreshBossScroll()
			endurance_frame:Clear()
			
			--> get boss table
			boss = boss or DeathGraphs.showing_endurance or DeathGraphs.db.last_boss
			if (debugmode) then
				print (":ShowEndurance", boss)
			end
			
			if (not boss) then
				for hash, _ in pairs (DeathGraphs.endurance_database) do
					boss = hash
					if (boss) then
						break
					end
				end
			end
			
			--> get the boss from the latest segment
				if (not fromDropdown) then
					local currentCombat = Details:GetCurrentCombat()
					if (currentCombat) then
						if (currentCombat.is_boss) then
							--> get the map index
							local mapID = currentCombat.is_boss.mapid
							--> get the boss index within the raid
							local bossIndex = Details:GetBossIndex (mapID, currentCombat.is_boss.id, nil, currentCombat.is_boss.name)
							if (bossIndex) then
								--> get the EJID
								local EJID = Details.EncounterInformation [mapID] and _detalhes.EncounterInformation [mapID].encounter_ids [bossIndex]
								if (EJID) then
									--> if the EJID exists build the hash
									local bossDificulty = currentCombat.is_boss.diff
									local hash = tostring (EJID) .. tostring (bossDificulty)
									if (hash) then
										boss = hash
									end
								end
							end
						end
					end
				end
			--
			
			if (not boss) then
				return
			end
			
			local boss_table = DeathGraphs.endurance_database [boss]
			if (debugmode) then
				print (":ShowEndurance", boss_table)
			end
			
			if (not boss_table) then
				for hash, _ in pairs (DeathGraphs.endurance_database) do
					boss = hash
					boss_table = DeathGraphs.endurance_database [hash]
					if (boss_table) then
						break
					end
				end
			end
			
			if (not boss_table) then
				return
			end
			
			DeathGraphs.db.last_boss = boss
			DeathGraphs:RefreshBossScroll()
			
			local sorted = {}
			local min_encounters = 9999
			local max_encounters = 0
			local min_points = 999999
			local max_points = 0
			local min_deaths, max_deaths = 999, 0
			
			for player_name, t in pairs (boss_table.player_db) do
				tinsert (sorted, {player_name, t.class, t.points, 0, t.encounters, t.deaths})
				
				if (min_encounters > t.encounters) then
					min_encounters = t.encounters
				end
				if (max_encounters < t.encounters) then
					max_encounters = t.encounters
				end
				if (min_points > t.points) then
					min_points = t.points
				end
				if (max_points < t.points) then
					max_points = t.points
				end
				if (min_deaths > #t.deaths) then
					min_deaths = #t.deaths
				end
				if (max_deaths < #t.deaths) then
					max_deaths = #t.deaths
				end
			end
			
			for i, t in ipairs (sorted) do
				if (t[5] / max_encounters * 100 < 35) then
					t[4] = 101
				else
					d_percent = math.abs ((#t[6] / t[5] * 100) - 100)
					t[4] = d_percent
				end
			end
			
			table.sort (sorted, reverse_sort)
			
			local min = sorted [1] and sorted [1] [4]
			local max = sorted [#sorted] and sorted [#sorted] [4]

			for index, t in ipairs (sorted) do
				endurance_frame:SetPlayer (index, t[1], t[2], t[3], t[4], t[5], t[6], min, max)
			end

			--> show
			endurance_frame:Show()
		end
		
		
		function DeathGraphs:HideAll()
		
			--boss selectors
			select_dropdown_rf:Hide()
			select_dropdown_normal:Hide()
			select_dropdown_heroic:Hide()
			select_dropdown_mythic:Hide()
			dropdown_label_rf:Hide()
			dropdown_label_normal:Hide()
			dropdown_label_heroic:Hide()
			dropdown_label_mythic:Hide()
	
			player_scroll:Show()
			player_scroll:Hide()
			segments_scroll:Show()
			segments_scroll:Hide()
			
			--endurance
			endurance_frame:Hide()
			
			--overall
			player_scroll:Hide()
			segments_scroll:Hide()
			segments_bg_frame:Hide()
			player_bg_frame:Hide()
			DeathGraphs.graphic_frame:Hide()
			DeathGraphs.overall_bg:Hide()
			player_overall_anchor:Hide()
			
			--current
			DeathGraphsCurrentFrameDeaths:Hide()
			
			--timeline
			DeathGraphsPlayerGraphicDeaths:Hide()
		end
		
		function DeathGraphs:ShowCurrent()
			DeathGraphs.db.showing_type = 3
			DeathGraphsCurrentFrameDeaths:Show()
			DeathGraphsCurrentFrameDeaths.Refresh()
		end
		
		function DeathGraphs:ShowTimeline()
			DeathGraphs.db.showing_type = 4
			DeathGraphsPlayerGraphicDeaths:Show()
			DeathGraphsPlayerGraphicDeaths.Refresh()
		end
		
		function DeathGraphs:ShowOverall()
			player_scroll:Show()
			segments_scroll:Show()
			segments_bg_frame:Show()
			player_bg_frame:Show()
			
			select_dropdown_rf:Show()
			select_dropdown_normal:Show()
			select_dropdown_heroic:Show()
			select_dropdown_mythic:Show()
			dropdown_label_rf:Show()
			dropdown_label_normal:Show()
			dropdown_label_heroic:Show()
			dropdown_label_mythic:Show()
			
			player_overall_anchor:Show()
			
			DeathGraphs.db.showing_type = 1
			
			local boss = DeathGraphs.db.last_boss
			if (not DeathGraphs.deaths_database [boss]) then
				for hash, _ in pairs (DeathGraphs.deaths_database) do
					DeathGraphs.db.last_boss = hash
					if (DeathGraphs.db.last_boss) then
						break
					end
				end
			end
			
			DeathGraphs:RefreshBossScroll()
			DeathGraphs:RefreshPlayerScroll()
			DeathGraphs:RefreshSegmentScroll()
			
			if (DeathGraphs.db.last_segment) then
				DeathGraphs.graphic_frame:Show()
				DeathGraphs.overall_bg:Show()
			end
		end
		
		function DeathGraphs:HideEndurance()
			DeathGraphs.db.showing_type = 1
			endurance_frame:Hide()
			
			player_scroll:Show()
			segments_scroll:Show()
			segments_bg_frame:Show()
			player_bg_frame:Show()
			
			local boss = DeathGraphs.db.last_boss
			if (not DeathGraphs.deaths_database [boss]) then
				for hash, _ in pairs (DeathGraphs.deaths_database) do
					DeathGraphs.db.last_boss = hash
					if (DeathGraphs.db.last_boss) then
						break
					end
				end
			end
			
			DeathGraphs:RefreshBossScroll()
			DeathGraphs:RefreshPlayerScroll()
			DeathGraphs:RefreshSegmentScroll()
			
			if (DeathGraphs.db.last_segment) then
				DeathGraphs.graphic_frame:Show()
				DeathGraphs.overall_bg:Show()
			end
		end
		
		function DeathGraphs:HideEnduranceAndDeaths()
			endurance_frame:Hide()
			player_scroll:Hide()
			segments_scroll:Hide()
			segments_bg_frame:Hide()
			player_bg_frame:Hide()
			DeathGraphs.graphic_frame:Hide()
			DeathGraphs.overall_bg:Hide()
		end
		
	--> bottom menu bar
	
	--> dropdown select type
		local select_type_label = framework:NewLabel (f, nil, "$parentTypeLabel", nil, "Showing:", "GameFontNormal")
	
		local OnSelectType = function (_, _, type)
			--> mostrar ou esconder o box de endurance
			if (type == 2) then
				DeathGraphs:ShowEndurance()
				
			elseif (type == 1) then
				DeathGraphs:HideEndurance()
			end
		end
		
		local death_desc = Loc ["STRING_DEATH_DESC"]
		local endurance_desc = Loc ["STRING_ENDURANCE_DESC"]
		
		local type_menu = {
			{value = 1, label = Loc ["STRING_DEATHS"], onclick = OnSelectType, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]], desc = death_desc},
			{value = 2, label = Loc ["STRING_ENDURANCE"], onclick = OnSelectType, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]], desc = endurance_desc},
			{value = 4, label = Loc ["STRING_OVERTIME"], onclick = OnSelectType, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]], desc = endurance_desc},
			{value = 3, label = Loc ["STRING_LATEST"], onclick = OnSelectType, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]], desc = endurance_desc},
		}

		local select_type_dropdown = framework:NewDropDown (f, nil, "$parentSegmentDropdown", "ModeDropdown", 150, 20, function() return type_menu end, DeathGraphs.db.showing_type)
		select_type_label:SetPoint ("bottomleft", f, "bottomleft", 15, 14)
		select_type_dropdown:SetPoint ("left", select_type_label, "right", 2, 0)
	
		select_type_label:Hide()
		select_type_dropdown:Hide()
	
	--> mode buttons:

		local BUTTON_INDEX_CURRENT = 1
		local BUTTON_INDEX_TIMELINE = 2
		local BUTTON_INDEX_OVERALL = 3
		local BUTTON_INDEX_ENDURANCE = 4
		local options_button_template = framework:GetTemplate ("button", "ADL_BUTTON_TEMPLATE")

		
		local change_mode = function (self, button, selected_mode)
			DeathGraphs:HideAll()
			
			if (selected_mode == BUTTON_INDEX_CURRENT) then
				--> current
				DeathGraphs:ShowCurrent() --internal index: 3
				
			elseif (selected_mode == BUTTON_INDEX_TIMELINE) then
				--> timeline
				DeathGraphs:ShowTimeline() --internal index: 4
				
			elseif (selected_mode == BUTTON_INDEX_OVERALL) then
				--> overall
				DeathGraphs:ShowOverall() --internal index: 1
				
			elseif (selected_mode == BUTTON_INDEX_ENDURANCE) then
				--> endurance
				DeathGraphs:ShowEndurance() --internal index: 2
			end
			
			DeathGraphs:RefreshButtons()
		end

		--> current encounter
		local current_encounter_button = framework:NewButton (f, _, "$parentModeCurrentEncounterButton", "ModeCurrentEncounterButton", mode_buttons_width, mode_buttons_height, change_mode, BUTTON_INDEX_CURRENT, nil, nil, "Current Encounter", 1)
		current_encounter_button:SetTemplate (framework:GetTemplate ("button", "ADL_MENUBUTTON_TEMPLATE"))
		current_encounter_button:SetIcon ([[Interface\WORLDSTATEFRAME\SkullBones]], nil, nil, nil, {4/64, 28/64, 4/64, 28/64}, "orange", nil, 2)
		--current_encounter_button:SetTextColor ("orange")
		
		--> timeline
		local timeline_button = framework:NewButton (f, _, "$parentModeTimelineButton", "ModeTimelineButton", mode_buttons_width, mode_buttons_height, change_mode, BUTTON_INDEX_TIMELINE, nil, nil, "Timeline", 1, options_button_template)
		timeline_button:SetTemplate (framework:GetTemplate ("button", "ADL_MENUBUTTON_TEMPLATE"))
		timeline_button:SetIcon ([[Interface\CHATFRAME\ChatFrameExpandArrow]], nil, nil, nil, {0, 1, 0, 1}, "orange", nil, 2)
		--timeline_button:SetTextColor ("orange")
		
		--> endurance
		local endurance_button = framework:NewButton (f, _, "$parentModeEnduranceButton", "ModeEnduranceButton", mode_buttons_width, mode_buttons_height, change_mode, BUTTON_INDEX_ENDURANCE, nil, nil, "Endurance", 1, options_button_template)
		endurance_button:SetTemplate (framework:GetTemplate ("button", "ADL_MENUBUTTON_TEMPLATE"))
		endurance_button:SetIcon ([[Interface\RAIDFRAME\Raid-Icon-Rez]], nil, nil, nil, {0, 1, 0, 1}, "orange", nil, 2)
		
		endurance_button:SetPoint ("bottomleft", f, "bottomleft", 10, mode_buttons_y_pos)
		timeline_button:SetPoint ("bottomleft", endurance_button, "bottomright", 5, 0)
		current_encounter_button:SetPoint ("bottomleft", timeline_button, "bottomright", 5, 0)
		
		--endurance_button:SetTextColor ("orange")
		
		--> overall ~overall
		--local overall_button = framework:NewButton (f, _, "$parentModeOverallButton", "ModeOverallButton", mode_buttons_width, mode_buttons_height, change_mode, BUTTON_INDEX_OVERALL, nil, nil, "Overall", 1, options_button_template)
		--overall_button:SetPoint ("bottomleft", endurance_button, "bottomright", 5, 0)
		--overall_button:SetIcon ([[Interface\Buttons\UI-MicroButton-Spellbook-Up]], nil, nil, nil, {0, 1, 0.4, 1}, nil, nil, 2)
		--overall_button:SetTextColor ("orange")

		--> highlight buttons when the mouse hoverover // change the color of button for the current selected module
		local all_buttons = {current_encounter_button, timeline_button, endurance_button} --overall_button,
	
		local set_button_as_pressed = function (button)
		
			--[=[
			local onenter = button.onenter_backdrop
			local onleave = button.onleave_backdrop
			onenter[1], onenter[2], onenter[3], onenter[4] = .8, .8, .8, 1
			onleave[1], onleave[2], onleave[3], onleave[4] = .1, .1, .1, 1
			
			local border_onenter = button.onenter_backdrop_border_color
			border_onenter[1], border_onenter[2], border_onenter[3], border_onenter[4] = 1, 1, 0, 1
			local border_onleave = button.onleave_backdrop_border_color
			border_onleave[1], border_onleave[2], border_onleave[3], border_onleave[4] = 1, .8, 0, 1
			
			if (button:IsMouseOver()) then
				button:SetBackdropColor (onenter[1], onenter[2], onenter[3], onenter[4])
				button:SetBackdropBorderColor (border_onenter[1], border_onenter[2], border_onenter[3], border_onenter[4])
			else
				button:SetBackdropColor (onleave[1], onleave[2], onleave[3], onleave[4])
				button:SetBackdropBorderColor (border_onleave[1], border_onleave[2], border_onleave[3], border_onleave[4])
			end
			--]=]
			
			button:SetTemplate (framework:GetTemplate ("button", "ADL_MENUBUTTON_SELECTED_TEMPLATE"))
		end
		
		function DeathGraphs:RefreshButtons()
			--> reset endurance button
			for _, button in ipairs (all_buttons) do
				--[=[
				local onenter = button.onenter_backdrop
				onenter[1], onenter[2], onenter[3], onenter[4] = .6, .6, .6, .9
				local onleave = button.onleave_backdrop
				onleave[1], onleave[2], onleave[3], onleave[4] = .3, .3, .3, .9
				local border_onenter = button.onenter_backdrop_border_color
				border_onenter[1], border_onenter[2], border_onenter[3], border_onenter[4] = 0, 0, 0, 1
				local border_onleave = button.onleave_backdrop_border_color
				border_onleave[1], border_onleave[2], border_onleave[3], border_onleave[4] = 0, 0, 0, 1
				
				button:SetBackdropColor (onleave[1], onleave[2], onleave[3], onleave[4])
				button:SetBackdropBorderColor (border_onleave[1], border_onleave[2], border_onleave[3], border_onleave[4])
				--]=]
				
				button:SetTemplate (framework:GetTemplate ("button", "ADL_MENUBUTTON_TEMPLATE"))
			end
		
			if (DeathGraphs.db.showing_type == 1) then --overall
				set_button_as_pressed (overall_button)
				
			elseif (DeathGraphs.db.showing_type == 2) then --endurance
				set_button_as_pressed (endurance_button)

			elseif (DeathGraphs.db.showing_type == 3) then --current
				set_button_as_pressed (current_encounter_button)
				
			elseif (DeathGraphs.db.showing_type == 4) then --timeline
				set_button_as_pressed (timeline_button)
				
			end
		end
		
		local w = 120
		
	--> erase data button
		local wipe_data = function (self) 
		
			table.wipe (DeathGraphs.deaths_database)
			table.wipe (DeathGraphs.endurance_database)
			table.wipe (DeathGraphs.current_database)
			table.wipe (DeathGraphs.graph_database)
			
			DeathGraphs.db.last_player = false
			DeathGraphs.db.last_segment = false
			DeathGraphs.db.last_boss = false
			DeathGraphs.graphic_frame:Reset()
			DeathGraphs:ClearOverall()
			DeathGraphs:Refresh()
			DeathGraphs:CanShowIcon()

			DeathGraphsCurrentFrameDeaths.OnResetAllData()
			DeathGraphsPlayerGraphicDeaths.OnResetAllData()
			
			if (DeathGraphs.db.showing_type == 3) then --current
				DeathGraphs:ShowCurrent()
			elseif (DeathGraphs.db.showing_type == 4) then --timeline
				DeathGraphs:ShowTimeline()
			end
			
		end
		
		local delete = framework:NewButton (f, _, "$parentDeleteButton", "DeleteButton", w, mode_buttons_height, wipe_data, nil, nil, nil, Loc ["STRING_RESET"], 1, framework:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		delete:SetPoint ("bottomright", f, "bottomright", -10, 10)
		delete:SetIcon ([[Interface\Buttons\UI-StopButton]], nil, nil, nil, {0, 1, 0, 1}, nil, nil, 2)
		--delete:SetTextColor ("orange")

	--> configure threshold
		local threshold_config = framework:NewButton (f, _, "$parentOptionsPanelButton", "OptionsPanelButton", w, mode_buttons_height, DeathGraphs.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS"], 1, framework:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		threshold_config:SetPoint ("right", delete, "left", 2, 0)
		threshold_config:SetIcon ([[Interface\Buttons\UI-OptionsButton]], nil, nil, nil, {0, 1, 0, 1}, nil, nil, 2)
		--threshold_config:SetTextColor ("orange")
		
	--> refresh on open
		function DeathGraphs:Refresh()
			
			DeathGraphs:RefreshBossScroll()
			DeathGraphs:HideAll()
			
			if (DeathGraphs.db.showing_type == 1) then --overall
				DeathGraphs:ShowOverall()
				
			elseif (DeathGraphs.db.showing_type == 2) then --endurance
				DeathGraphs:ShowEndurance()
				
			elseif (DeathGraphs.db.showing_type == 3) then --current
				DeathGraphs:ShowCurrent()
				
			elseif (DeathGraphs.db.showing_type == 4) then --timeline
				DeathGraphs:ShowTimeline()
				
			end
			
			DeathGraphs:RefreshButtons()
			
			if (DeathGraphs.db.showing_type == 1) then --else or nothing to show on endurance
			
				local last_boss = DeathGraphs.db.last_boss
				
				if (last_boss) then
					--> check if the last table exists
					if (DeathGraphs.deaths_database [last_boss]) then
						local last_player = DeathGraphs.db.last_player
						local last_segment = DeathGraphs.db.last_segment
					else
						local last_encounter = DeathGraphs.last_encounter_hash
						if (last_encounter and DeathGraphs.deaths_database [last_encounter]) then
							DeathGraphs.db.last_boss = DeathGraphs.last_encounter_hash
						else
							DeathGraphs.db.last_boss = false
						end

						DeathGraphs.db.last_player = false
						DeathGraphs.db.last_segment = false
					end
				else
					local last_encounter = DeathGraphs.last_encounter_hash
					if (last_encounter and DeathGraphs.deaths_database [last_encounter]) then
						DeathGraphs.db.last_boss = DeathGraphs.last_encounter_hash
					else
						DeathGraphs.db.last_boss = false
					end

					DeathGraphs.db.last_player = false
					DeathGraphs.db.last_segment = false
				end

				DeathGraphs:RefreshBossScroll()
				DeathGraphs:RefreshPlayerScroll()
				DeathGraphs:RefreshSegmentScroll()
				
				--> show graphic
				DeathGraphs:Select()
				
				--> show damage taken

			end
		end
		
	--> select boss / player / segment
		function DeathGraphs:Select (boss, player, segment)
			if (not boss) then
				boss = DeathGraphs.db.last_boss
			else
				DeathGraphs.db.last_boss = boss
			end
			if (not player) then
				player = DeathGraphs.db.last_player
			else
				DeathGraphs.db.last_player = player
			end
			if (not segment) then
				segment = DeathGraphs.db.last_segment
			else
				DeathGraphs.db.last_segment = segment
			end
			
			if (boss and player and segment) then
				local death_table = DeathGraphs:GetBossTable (boss , nil, CONST_DBTYPE_DEATH)
				local player_table = DeathGraphs:GetPlayerTable (death_table, player)
				DeathGraphs:ShowGraphicForDeath (player_table.deaths [segment])
			end
			
			DeathGraphs:RefreshBossScroll()
			DeathGraphs:RefreshPlayerScroll()
			DeathGraphs:RefreshSegmentScroll()
		end
		
	--> graphic
	
		local log
		local loglines = {}
		local linhas = {}
		local gradeframes = {}
		local gradelinhas = {}
		
		local gballs = {}
		
		local GetSpellInfo = _detalhes.getspellinfo
		local flag_logmouseover = false
	
		local gframe = CreateFrame ("frame", nil, f, "BackdropTemplate")
		gframe:SetSize (475, 160)
		gframe:SetPoint ("topleft", f, "topleft", 449, -95)
		gframe.CustomLine = [[Interface\AddOns\Details\Libs\LibGraph-2.0\line]]
		DeathGraphs.graphic_frame = gframe
		
		local g = LibStub:GetLibrary ("LibGraph-2.0")
		
		--> graphic lines on enter and leave
		local on_enter = function (self)
		
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
			local ball = gballs [self.id]
			ball:SetBlendMode ("ADD")
			local line = ball.line
			
			if (not line) then
				return
			end
			
			if (self.data [2] ~= 0) then
				GameCooltip:Reset()
				
				GameCooltip:SetOption ("ButtonsYMod", 0)
				GameCooltip:SetOption ("YSpacingMod", -5)
				GameCooltip:SetOption ("IgnoreButtonAutoHeight", true)
				GameCooltip:SetColor (1, 0.5, 0.5, 0.5, 0.5)
				
				local spellname, _, spellicon = GetSpellInfo (self.data [2])
				
				GameCooltip:AddLine (spellname, nil, 1, "orange", nil, 12, SharedMedia:Fetch ("font", "Friz Quadrata TT"))
				GameCooltip:AddIcon (spellicon, 1, 1, 16, 16)
				
				--> death parser
				if (type (self.data [1]) == "boolean") then --> damage or heal
					if (self.data [1]) then
						
						if (self.data [7] and self.data [7] > 0) then
							GameCooltip:AddLine ("-" .. DeathGraphs:comma_value (self.data [3]) .. " |cFF11FF11(|r" .. DeathGraphs:comma_value (self.data [7]) .. " |cFFFFFFBBabsorbed|r|cFF11FF11)|r") --> damage with absorb
						else
							GameCooltip:AddLine ("-" .. DeathGraphs:comma_value (self.data [3])) --> damage
						end
						
						GameCooltip:AddLine ("School: " .. DeathGraphs:GetSpellSchoolFormatedName (self.data [8]))
					else
						GameCooltip:AddLine ("+" .. DeathGraphs:comma_value (self.data [3]))
					end
					
				elseif (type (self.data [1]) == "number") then
					if (self.data [1] == 1) then --cooldown
						GameCooltip:AddLine ("Cooldown")
					elseif (self.data [1] == 2) then --battle ress
						GameCooltip:AddLine ("Battleress")
					end
				end
				
				GameCooltip:AddLine ("Source: " .. self.data [6])
			
				if (type (self.data [1]) == "boolean" and self.data [1] and self.data [9]) then --> damage or heal
					GameCooltip:AddLine ("|cFFFF0000Friendly Fire|r")
				end
			
				GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, cooltip_block_bg, _detalhes.tooltip_border_color)
			
				GameCooltip:SetOwner (ball.tooltip_anchor, "bottomleft", "topright")
				GameCooltip:Show()
			end
			
		end
		local on_leave = function (self)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			local ball = gballs [self.id]
			ball:SetBlendMode ("BLEND")
			local line = ball.line
			if (line) then
				line:SetBlendMode ("BLEND")
			end
			GameCooltip:Hide()
		end
		
		--> graphic lines
		for i = 1, 16 do
			linhas [i] = g:DrawLine (gframe, 400, 500, 600, 700, 20, {1, 1, 1, 1}, "artwork")
			
			local f = CreateFrame ("frame", nil, gframe, "BackdropTemplate")
			f:SetPoint ("left", gframe, "left", (i-1)*29, 0)
			f:SetSize (29, 160)
			gradeframes [i] = f
			f.id = i
			f:SetScript ("OnEnter", on_enter)
			f:SetScript ("OnLeave", on_leave)

			f:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			f:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			
			local t = gframe:CreateTexture (nil, "background")
			t:SetSize (1, 160)
			t:SetPoint ("left", gframe, "left", i*29, 0)
			t:SetColorTexture (1, 1, 1, .1)
			gradelinhas [i] = t
			
			local b = f:CreateTexture (nil, "overlay")
			b:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
			b:SetSize (16, 16)
			local anchor = CreateFrame ("frame", nil, f, "BackdropTemplate")
			anchor:SetAllPoints (b)
			b.tooltip_anchor = anchor
			gballs [i] = b
			
			local spellicon = f:CreateTexture (nil, "artwork")
			spellicon:SetPoint ("bottom", b, "bottom", 0, 10)
			spellicon:SetSize (16, 16)
			b.spellicon = spellicon
		end
		
		function gframe:ShowGrid()
			for _, frame in ipairs (gradeframes) do 
				frame:Show()
			end
			for _, line in ipairs (gradelinhas) do 
				line:Show()
			end
			for _, bola in ipairs (gballs) do 
				bola:Show()
			end
			gframe.timeline:Show()
		end
		function gframe:HideGrid()
			for _, frame in ipairs (gradeframes) do 
				frame:Hide()
			end
			for _, line in ipairs (gradelinhas) do 
				line:Hide()
			end
			for _, bola in ipairs (gballs) do 
				bola:Hide()
			end
			gframe.timeline:Hide()
		end

		function gframe:Reset()
			for i = #gframe.GraphLib_Lines_Used, 1, -1 do
				local line = tremove (gframe.GraphLib_Lines_Used)
				tinsert (gframe.GraphLib_Lines, line)
				line:Hide()
			end
		end
		
		--> timeline
		local timeline_bg = CreateFrame ("frame", nil, gframe, "BackdropTemplate")
		gframe.timeline = timeline_bg
		timeline_bg:SetPoint ("topleft", gframe, "bottomleft", 0, -1)
		timeline_bg:SetPoint ("topright", gframe, "bottomright", -11, -1)
		timeline_bg:SetHeight (20)
		timeline_bg:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16,
			insets = {left = 0, right = 0, top = 0, bottom = 0}})
		timeline_bg:SetBackdropColor (.1, .1, .1, .3)
		timeline_bg.labels = {}
		for i = 1, 16 do 
			local l = timeline_bg:CreateFontString (nil, "overlay", "GameFontNormal")
			DeathGraphs:SetFontSize (l, 9)
			DeathGraphs:SetFontColor (l, "silver")
			l:SetPoint ("left", timeline_bg, "left", (i-1) * 29, 0)
			timeline_bg.labels [i] = l
		end

		local red = {.9, .1, .1, 1}
		local green = {.1, .9, .1, 1}
		local white = {1, 1, 1, 1}
		local gray = {.5, .5, .5, 1}
		local orange = {1, .6, 0, 1}
		
		function DeathGraphs:ShowGraphicForDeath (data)
			
			gframe:Reset()
			gframe:ShowGrid()
			gframe:Show()
		
			if (not data) then
				return
			end
		
			local timeline = data [1]
			local max_health = data[4]

			if (#timeline < 16) then
				while (#timeline < 16) do
					table.insert (timeline, 1, {false, 0, 0, data[6], max_health, "-1"})
				end
			end
			
			log = timeline
			
			local h = gframe:GetHeight()/100

			local o = 1
			local lastlife = 156

			--for i = 16, 1, -1 do
			for i = 1, 16, 1 do
				local t = timeline [i]
				if (type (t) == "table") then
				
					--> death parser
					
					local evtype = t [1] --event type
					local spellid = t [2] --spellid
					local amount = t [3] --amount healed or damaged
					local time = t [4] --time
					local life = t [5] --health
					local source = t [6] --source

					local plife = life / max_health * 100
					if (plife > 98) then
						plife = 98
					end
					plife = plife*h
					
					local line
					
					if (source == "-1") then
						--> neutral line
						line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, gray, "overlay")
						
					elseif (type (evtype) == "boolean") then
						--> damage or heal
						if (evtype) then
							--> damage
							if (t [9]) then
								--> friendly fire
								line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, orange, "overlay")
							else
								--> normal damage
								line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, red, "overlay")
							end
						elseif (not evtype) then
							--> heal
							line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, green, "overlay")
						end
						
					elseif (type (evtype) == "number") then
						--> cooldown / bres / last cooldown
						if (evtype == 1) then
							--> cooldown
							line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, white, "overlay")
							
						elseif (evtype == 2 and not battleress) then
							--> battle ress
							local p = plife
							local next = timeline [i+1]
							if (next) then
								local plife = next [5] / max_health * 100
								if (plife > 98) then
									plife = 98
								end
								p = plife*h
							end
							line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, p, 50, white, "overlay")
							plife = p
							
						elseif (evtype == 3) then
							--> last cooldown used
							line = g:DrawLine (gframe, (o-1)*29, lastlife, o*29, plife, 50, gray, "overlay")
						end
					end

					local ball = gballs [o]
					ball:SetPoint ("bottomleft", gframe, "bottomleft", (o*29)-8, plife-8)
					if (type (evtype) == "boolean" and evtype) then --> damage
						ball.spellicon:SetTexture (select (3, GetSpellInfo (spellid)))
						ball.spellicon:SetTexCoord (4/64, 60/64, 4/64, 60/64)
					else
						ball.spellicon:SetTexture (nil)
					end
					
					ball.line = line
					
					local clock = data[6] - time
					if (type (evtype) == "number" and evtype == 2) then
						if (clock <= 100) then
							timeline_bg.labels [o]:SetText (math.floor (clock))
						else
							timeline_bg.labels [o]:SetText (string.format ("%.1f", clock))
						end
					else
						timeline_bg.labels [o]:SetText ("-" .. string.format ("%.1f", clock))
					end
					
					local frame = gradeframes [o]
					frame.data = t
					
					lastlife = plife
					o = o + 1
				end
			end
			
			DeathGraphs:UpdateOverall()

		end
		
		local overall = {}
		local amount_of_overall_blocks = 16
		
		local overall_bg = CreateFrame ("frame", "DeathGraphsOverallDamageBackground", f, "BackdropTemplate")
		DeathGraphs.overall_bg = overall_bg
		
		overall_bg:SetPoint ("topleft", gframe, "bottomleft", 0, -30)
		overall_bg:SetSize (464, 148)
		framework:CreateLabel (overall_bg, "Overall Damage Taken Before All Deaths:", nil, nil, "GameFontNormal", "overall")
		overall_bg.overall:SetPoint ("topleft", gframe, "bottomleft", 5, -38)
		
		local overall_on_enter = function (self)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
			if (self.spell) then
				GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
				if (self.spell == 1) then
					GameTooltip:SetSpellByID (6603)
				else
					GameTooltip:SetSpellByID (self.spell)
				end
				GameTooltip:Show()
			end
		end
		local overall_on_leave = function (self)
			self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
			GameTooltip:Hide()
		end
		
		local x, y = 0, -7
		for i = 1, amount_of_overall_blocks do
			local frame = CreateFrame ("frame", nil, overall_bg, "BackdropTemplate")
			frame:SetSize (220, 19)
			
			local icon = framework:NewImage (frame, "", 18, 18)
			local label = framework:CreateLabel (frame, ""..i)
			icon:SetPoint ("left", frame, "left")
			label:SetPoint ("left", icon, "right", 2, 0)
			
			local label2 = framework:CreateLabel (frame, ""..i)
			label2:SetPoint ("right", frame, "right")
			
			tinsert (overall, {frame = frame, icon = icon, label = label, label2 = label2})
			
			frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			frame:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))

			frame:SetScript ("OnEnter", overall_on_enter)
			frame:SetScript ("OnLeave", overall_on_leave)
			
			frame:SetPoint ("topleft", overall_bg.overall.widget, "bottomleft", x, y)
			y = y - 20

			if (y < -150) then
				x = x + 232
				y = -7
			end
		end
		
		--> report overall
		local report_overall_func = function()
			local boss = DeathGraphs.db.last_boss
			if (not boss) then
				return
			end
			local boss_table = DeathGraphs.endurance_database [boss]
			if (not boss_table) then
				return
			end

			local reportFunc = function (IsCurrent, IsReverse, AmtLines)
			
				local boss_table = DeathGraphs:GetBossTable (DeathGraphs.db.last_boss , nil, CONST_DBTYPE_DEATH)
				local player_table = DeathGraphs:GetPlayerTable (boss_table, DeathGraphs.db.last_player)
				
				if (not boss_table or not player_table) then
					DeathGraphs:Msg ("Nothing to report.")
					return
				end
			
				DeathGraphs.report_lines = {"Details!: overall damage taken before death for " .. (player_table.name or "Unknown") .. " on " .. (boss_table.name or "Unknown") .. " (A.D.L (plugin)):"}
				for i = 1, math.min (#overall, AmtLines) do
					local label = overall [i]
					if (label.frame:IsShown()) then
					
						local spellid = label.frame.spell
						local spelllink
						if (spellid > 10) then
							spelllink = GetSpellLink (spellid)
						else
							spelllink = label.label.text
						end
						
						tinsert (DeathGraphs.report_lines, spelllink .. ": " .. label.label2.text)
					end
				end
				DeathGraphs:SendReportLines (DeathGraphs.report_lines)
			end

			local use_slider = true
			DeathGraphs:SendReportWindow (reportFunc, nil, nil, use_slider)
		end
		
		local report_overall = framework:NewButton (overall_bg, _, "$parentReportOverallDamageButton", "ReportOverallDamageButton", 70, mode_buttons_height, report_overall_func, nil, nil, nil, "Report", 1, options_dropdown_template)
		report_overall:SetPoint ("topright", overall_bg, "topright", -6, -3)

		function DeathGraphs:UpdateOverall()
			DeathGraphs:ClearOverall()
		
			local death_table = DeathGraphs:GetBossTable (DeathGraphs.db.last_boss , nil, CONST_DBTYPE_DEATH)
			local player_table = DeathGraphs:GetPlayerTable (death_table, DeathGraphs.db.last_player)

			local numeric = {}
			for spellid, amount in pairs (player_table.overall) do
				tinsert (numeric, {spellid, amount})
			end
			table.sort (numeric, DeathGraphs.Sort2) --> sort by index 2
			
			for i, spelltable in ipairs (numeric) do
				local t = overall[i]
				
				if (t) then
					local spellname, _, spellicon = DeathGraphs.GetSpellInfo (spelltable[1])
					t.frame:Show()
					t.frame.spell = spelltable[1]
					t.icon.texture = spellicon
					t.icon.texcoord = CONST_COORDS_NO_BORDER
					t.label.text = spellname .. ": "
					t.label2.text = DeathGraphs:comma_value (spelltable [2])
				end
			end
			
			overall_bg:Show()
		end
		
		function DeathGraphs:ClearOverall()
			for i = 1, amount_of_overall_blocks do
				local t = overall[i]
				t.icon.texture = ""
				t.label.text = ""
				t.frame.spell = nil
				t.frame:Hide()
			end
		end
		
		gframe:Reset()
		gframe:HideGrid()		
		DeathGraphs:ClearOverall()
		
		
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> search keys: ~current
--> current deaths of latest try
	local MAX_SUMMARY_SPELLS =  5
	local BUTTON_TEXT_SIZE = 10
	local BUTTON_TEXT_COLOR = {.9, .9, .9, 1}
	local BUTTON_TEXT_HIGHLIGHT = "white"
	local BUTTON_TEXT_PRESSED = "orange"
	local BUTTON_BACKGROUND_COLOR = {.2, .2, .2, .75}
	local BUTTON_BACKGROUND_COLORHIGHLIGHT = {.5, .5, .5, .8}	
	
	local currentFrame = CreateFrame ("frame", "DeathGraphsCurrentFrameDeaths", f, "BackdropTemplate")
	currentFrame:SetPoint ("topleft", 10, -50)
	currentFrame:SetSize (800, 400)
	
	f.CurrentDeathFrame = currentFrame
	
	local segment_label = framework:NewLabel (currentFrame, nil, "$parentSegmentLabel", nil, "Segment:", "GameFontNormal")
	
	local OnSelectEncounter = function (_, _, index)
		--> selected the segment
		currentFrame.Refresh (index)
	end
	
	local build_segments_menu = function()
		local list = {}
		local db = DeathGraphs.current_database
		for i, encounter in ipairs (db) do
			tinsert (list, {value = i, label = "#" .. i .. " " .. encounter.bossname, onclick = OnSelectEncounter, icon = encounter.bossicon[5], texcoord = {encounter.bossicon[1], encounter.bossicon[2], encounter.bossicon[3], encounter.bossicon[4]}})
		end
		return list
	end
	
	local segment_dropdown = framework:NewDropDown (currentFrame, nil, "$parentSegmentDropdown", "SegmentDropdown", 150, 20, build_segments_menu, 1, options_dropdown_template)
	segment_label:SetPoint ("topleft", currentFrame, "topleft", 0, 1)
	segment_dropdown:SetPoint ("topleft", segment_label, "bottomleft", 0, -5)
	
	--create the player frame to host buttons
	local playerListFrame = CreateFrame ("frame", "DeathGraphsCurrentFrameDeathsPlayerList", currentFrame, "BackdropTemplate")
	playerListFrame:SetPoint ("topleft", currentFrame, "topleft", -9, -45)
	playerListFrame:SetSize (170, 400)
	
	--create the panel to show the death timeline
	local deathPanel = CreateFrame ("frame", "DeathGraphsCurrentFrameDeathsDeathTimeline", currentFrame, "BackdropTemplate")
	deathPanel:SetPoint ("topleft", playerListFrame, "topright", 2, 0)
	deathPanel:SetSize (750, 400)
	
	--colunms:
	local deathColumns = {}
	local summaryColumns = {}
	
	local column_onenter = function (self)
		--show the tooltip for this spell
		local spellid = self.spellid
		if (spellid) then
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			if (spellid == 1) then
				GameTooltip:SetSpellByID (6603)
			else
				GameTooltip:SetSpellByID (spellid)
			end
			GameTooltip:Show()
		end
		local r, g, b = self:GetBackdropColor()
		self:SetBackdropColor (r, g, b, 1)
	end
	local column_onleave = function (self)
		--hide the spell tooltip
		GameTooltip:Hide()
		--> set back the backdrop alpha
		local r, g, b = self:GetBackdropColor()
		self:SetBackdropColor (r, g, b, self.backdropAlpha)
	end
	
	--> create the lines for the death log
	for i = 1, CONST_MAX_DEATH_EVENTS do
		local column_frame = CreateFrame ("frame", nil, deathPanel, "BackdropTemplate")
		--time before death
		column_frame.hitTime = framework:CreateLabel (column_frame, "-10s", nil, "white", "GameFontHighlightSmall")
		
		--hit strength
		column_frame.hitStrength = framework:CreateLabel (column_frame, "100k", nil, "white", "GameFontHighlightSmall")
		
		--spell
		column_frame.hitSpell = framework:CreateLabel (column_frame, "[Melee]", nil, "white", "GameFontHighlightSmall")
		column_frame.hitSpellIcon = framework:CreateImage (column_frame, nil, 12, 12, "overlay")
		
		--source
		column_frame.hitSource = framework:CreateLabel (column_frame, "Sargeras", nil, "white", "GameFontHighlightSmall")
		
		--hp bar
		column_frame.healthBarBackground = framework:CreateImage (column_frame, nil, 150, 12, "artwork")
		column_frame.healthBarBackground:SetColorTexture (0, 0, 0, 0.5)
		column_frame.healthBar = framework:CreateImage (column_frame, nil, 150, 12, "overlay")
		column_frame.healthBar:SetColorTexture (.8, .8, .8, 0.7)
		
		--> set points, height and script
		column_frame:SetPoint ("topleft", deathPanel, "topleft", 0, (i-1)*16*-1)
		column_frame:SetPoint ("topright", deathPanel, "topright", 0, (i-1)*16*-1)
		column_frame:SetHeight (16)
		column_frame:SetScript ("OnEnter", column_onenter)
		column_frame:SetScript ("OnLeave", column_onleave)
		
		--> set the point off all widgets
		column_frame.hitTime:SetPoint ("left", column_frame, "left", 2, 0)
		column_frame.hitStrength:SetPoint ("left", column_frame, "left", 100, 0)
		
		column_frame.hitSpellIcon:SetPoint ("left", column_frame, "left", 176, 0)
		column_frame.hitSpell:SetPoint ("left", column_frame, "left", 190, 0)
		
		column_frame.hitSource:SetPoint ("left", column_frame, "left", 355, 0)
		
		column_frame.healthBar:SetPoint ("left", column_frame, "left", 520, 0)
		column_frame.healthBarBackground:SetPoint ("left", column_frame, "left", 520, 0)
		
		--> column backdrop
		column_frame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
		
		tinsert (deathColumns, column_frame)
		
		column_frame:Hide()
	end
	
	local summary_onenter = function (self)
		--show the tooltip for this spell
		local spellid = self.spellid
		if (spellid) then
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			if (spellid == 1) then
				GameTooltip:SetSpellByID (6603)
			else
				GameTooltip:SetSpellByID (spellid)
			end
			GameTooltip:Show()
		end
		self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
	end
	local summary_onleave = function (self)
		GameTooltip:Hide()
		self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
	end

	--> create the summary blocks
	for i = 1, MAX_SUMMARY_SPELLS do
		local summary_frame = CreateFrame ("frame", nil, deathPanel, "BackdropTemplate")
		
		summary_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		summary_frame:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
		
		--> set points, height and script
		summary_frame:SetPoint ("bottomleft", deathPanel, "topleft", (i-1) * 142, 10)
		summary_frame:SetWidth (140)
		summary_frame:SetHeight (20)
		summary_frame:SetScript ("OnEnter", summary_onenter)
		summary_frame:SetScript ("OnLeave", summary_onleave)
		
		--> create icon, spellname and amount widges
		summary_frame.spellIcon = framework:CreateImage (summary_frame, nil, 20, 20, "overlay")
		summary_frame.spellName = framework:CreateLabel (summary_frame, "place holder string", nil, "white", "GameFontHighlightSmall")
		summary_frame.spellAmount = framework:CreateLabel (summary_frame, "place holder string", nil, "white", "GameFontHighlightSmall")
		--> set theirs points
		summary_frame.spellIcon:SetPoint ("left", summary_frame, "left", 2, 0)
		summary_frame.spellName:SetPoint ("left",summary_frame.spellIcon, "right", 2, 0)
		summary_frame.spellAmount:SetPoint ("left", summary_frame.spellName, "right", 2, 0)
		
		--> add to the container
		tinsert (summaryColumns, summary_frame)
		summary_frame:Hide()
	end
	
	local temp_summary_table = {}
	
	--<
	function deathPanel.ShowPlayerScaleByDamage (index)
		local encounter = currentFrame.current_encounter
		if (encounter) then
			local deaths = encounter.deaths
			local player = deaths [index]
			if (player) then
				local events = player.events
				local total_damage = 0
				local total_time = 0
				local max_health = player.maxhealth
				local time_death = player.time
				
				for _, event in ipairs (player.events) do
					total_time = total_time + (event [4] - time_death)
					total_damage = total_damage + event [3]
				end
				
				local damage_per_second = total_damage / total_time
				damage_per_second = floor (damage_per_second)
				
				return damage_per_second
			end
		end
	end
	
	--> build the death events for the selected player
	function deathPanel.ShowPlayerDeath (index)
	
		deathPanel.HidePlayerDeathEvents()
		deathPanel.HideDeathEventsSummary()
		
		local encounter = currentFrame.current_encounter
		if (encounter) then
			local deaths = encounter.deaths
			local player = deaths [index]
			if (player) then
				local events = player.events
				
				--> death parser
				local maxhealth = player.maxhealth
				local time = player.time or events [1][4]
				
				local added = 1
				local number_format_func = Details:GetCurrentToKFunction()
				--local NumOfEvents = min (#events, CONST_MAX_DEATH_EVENTS)
				
				wipe (temp_summary_table)
				--local eventIndex = min (#events - NumOfEvents) + 1
				
				local eventsToShow = {}
				for i = #events, 1, -1 do
					
					local ev = events [i]
					local evtype = ev and ev [1]
					
					if (type (evtype) == "boolean" and evtype) then
						--> damage
						tinsert (eventsToShow, {"damage", ev})
						
					elseif (type (evtype) == "boolean" and not evtype) then
						--> healing
						if (ev [3] > CONST_MIN_HEALINGDONE_DEATHLOG) then
							tinsert (eventsToShow, {"healing", ev})
						end
						
					elseif (type (evtype) == "number" and evtype == 4) then	
						--> debuff applied on the player
						tinsert (eventsToShow, {"debuff", ev})
						
					end
				end
				
				for i = CONST_MAX_DEATH_EVENTS+1, #eventsToShow do
					table.remove (eventsToShow, CONST_MAX_DEATH_EVENTS+1)
				end
				
				local EventsList = Details.table.reverse (eventsToShow)
				
				for i = 1, #EventsList do
					local t = EventsList [i]
					local evtype_string = t [1]
					local ev = t [2]
					
					local column = deathColumns [i]
					
					local spellid = ev [2] --spellid
					local amount = ev [3] --amount healed or damaged
					local clock = ev [4] --time
					local life = ev [5] --health
					local sourceName = ev [6] --source
					
					column.hitTime.text = "-" .. string.format ("%.1f", time - clock)
					
					if (evtype_string == "damage") then
						column.hitStrength.text = "-" .. number_format_func (_, amount)
						column.hitStrength.textcolor = "white"
						column.hitStrength.textsize = 11
						column:SetBackdropColor (1, 0, 0, 1)
						column.backdropAlpha = 0.7
						column:SetAlpha (1)
						temp_summary_table [spellid] = (temp_summary_table [spellid] or 0) + amount
						
					elseif (evtype_string == "healing") then
						column.hitStrength.text = "+" .. number_format_func (_, amount)
						column.hitStrength.textcolor = {0.8, 1, 0.8, 0.9}
						column.hitStrength.textsize = 10
						column.backdropAlpha = 0.25
						column:SetBackdropColor (.2, 1, .2, column.backdropAlpha)
						column:SetAlpha (.75)
						
					elseif (evtype_string == "debuff") then
						column.hitStrength.text = "x" .. amount
						column.hitStrength.textcolor = "silver"
						column.hitStrength.textsize = 10
						column:SetBackdropColor (.8, .2, .8, 1)
						column.backdropAlpha = 0.7
						column:SetAlpha (1)
						
					end
					
					--> set the spellname with the link
					local spelllink = DeathGraphs:GetSpellLink (spellid)
					local _, _, spellicon = DeathGraphs.GetSpellInfo (spellid)
					column.hitSpell.text = spelllink
					column.hitSpellIcon.texture = spellicon
					column.hitSpellIcon.texcoord = CONST_COORDS_NO_BORDER
					
					--> the source name
					sourceName = framework:RemoveRealmName (sourceName)
					column.hitSource.text = sourceName
					
					--> set the life statusbar
					column.healthBar.width = math.min (life, maxhealth) / maxhealth * 100 * 1.5
					
					--> set the spell id
					column.spellid = spellid

					column:Show()
					
				end
				
				--> set the summary widgets
				local t = {}
				for spellid, amount in pairs (temp_summary_table) do 
					tinsert (t, {spellid, amount})
				end
				table.sort (t, Details.Sort2)
				for i = 1, min (#t, 5) do
					--> get the data from the table
					local spellid, amount = unpack (t[i])
					--> get the summary widget
					local summaryColumn = summaryColumns [i]
					--> get the icon and the spell name
					local spellname, _, spellicon = DeathGraphs.GetSpellInfo (spellid)
					summaryColumn.spellName.text = spellname
					
					for o = 1, 20 do
						if (summaryColumn.spellName:GetStringWidth() > 80) then
							spellname = strsub (spellname, 1, #spellname-1)
							summaryColumn.spellName.text = spellname
						else
							break
						end
					end
					
					summaryColumn.spellName.text = summaryColumn.spellName.text .. ":"
					summaryColumn.spellIcon.texture = spellicon
					summaryColumn.spellIcon.texcoord = CONST_COORDS_NO_BORDER
					--> set the hit amount
					summaryColumn.spellAmount.text = number_format_func (_, amount)
					--> show the widget
					summaryColumn.spellid = spellid
					summaryColumn:Show()
				end
				wipe (t)
			end
		end
	end
	
	--> clear the death events and the summary widgets
	function deathPanel.HidePlayerDeathEvents()
		for index, column in ipairs (deathColumns) do
			column:Hide()
			column.spellid = nil
		end
	end
	function deathPanel.HideDeathEventsSummary()
		for index, column in ipairs (summaryColumns) do
			column:Hide()
			column.spellid = nil
		end
	end
	
	--hold all player buttons
	local playerButtons = {}
	
	--> button on enter and on leave
	local button_onenter = function (self, capsule)
		if (not currentFrame.locked_on_player) then
			deathPanel.ShowPlayerDeath (capsule.player_index)
		end
		--> change the text color
		capsule.textcolor = BUTTON_TEXT_HIGHLIGHT
		self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLORHIGHLIGHT))
	end
	local button_onleave = function (self, capsule)
		if (not currentFrame.locked_on_player) then
			deathPanel.HidePlayerDeathEvents()
			deathPanel.HideDeathEventsSummary()
		end
		
		--> change the text color
		if (not currentFrame.locked_on_player or currentFrame.locked_on_player ~= capsule.player_index) then
			capsule.textcolor = BUTTON_TEXT_COLOR
		else
			capsule.textcolor = BUTTON_TEXT_PRESSED
		end

		self:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
	end
	
	--> remove the orange color from a button
	function deathPanel.UnpressButton()
		local oldbutton = currentFrame.locked_on_player
		if (oldbutton) then
			oldbutton = playerButtons [oldbutton]
			if (oldbutton) then
				oldbutton.textcolor = BUTTON_TEXT_COLOR
			end
		end
	end
	
	--> button is pressed
	local playerSelected = function (self, button, index)
		deathPanel.UnpressButton()
		
		if (not currentFrame.locked_on_player or currentFrame.locked_on_player ~= index) then
			currentFrame.locked_on_player = index
			deathPanel.ShowPlayerDeath (index)
		else
			currentFrame.locked_on_player = nil
		end
	end
	
	--> create player selection buttons
	for i = 1, CONST_MAX_DEATH_PLAYERS do 
		local button = framework:CreateButton (playerListFrame, playerSelected, 140, 16, "", i, nil, nil, nil, nil, 1)
		button:SetPoint (5, (i-1)*17*-1)
		button.textcolor = BUTTON_TEXT_COLOR
		button.textsize = BUTTON_TEXT_SIZE
		
		--on enter leave scripts
		button:SetHook ("OnEnter", button_onenter)
		button:SetHook ("OnLeave",  button_onleave)
		
		button:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		button:SetBackdropColor (unpack (BUTTON_BACKGROUND_COLOR))
		
		--add to the table
		tinsert (playerButtons, button)
	end
	--> hide all player buttons
	function deathPanel.HideAllPlayerButtons()
		for i = 1, CONST_MAX_DEATH_PLAYERS do
			local button = playerButtons [i]
			button:Hide()
		end
	end
	
	local format_time = function (v) return "" .. format ("%02.f", floor (v/60)) .. ":" .. format ("%02.f", v%60) end
	
	function playerListFrame.RefreshPlayers()
		--> hide all buttons
		deathPanel.HideAllPlayerButtons()
		
		--> get all deaths
		local encounter = currentFrame.current_encounter
		local deaths = encounter.deaths
		
		--> get the list of players of this segment and add them to the buttons
		for i = 1, min (CONST_MAX_DEATH_PLAYERS, #deaths) do
			local player = deaths [i]
			local button = playerButtons [i]
			
			local playerName = player.name
			playerName = framework:RemoveRealmName (playerName)
			
			local s = format_time (player.timeofdeath)
			local color = RAID_CLASS_COLORS [player.class]
			
			if (color) then
				button:SetText ("" .. s .. " |c" .. color.colorStr .. playerName .. "|r")
			else
				button:SetText ("" .. s .. " " .. playerName)
			end
			
			local _, l, r, t, b = DeathGraphs:GetClassIcon (player.class)
			--button:SetIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], 16, 16, "overlay", {l, r, t, b}, nil, 2, 2)
			button:SetIcon ([[]], 1, 1, "overlay", {l, r, t, b}, nil, 2, 2)
			
			button.player_index = i

			button:Show()
		end
	end
	
	function currentFrame.OnResetAllData()
		DeathGraphsCurrentFrameDeathsDeathTimeline.HidePlayerDeathEvents()
		DeathGraphsCurrentFrameDeathsDeathTimeline.HideDeathEventsSummary()
		DeathGraphsCurrentFrameDeathsDeathTimeline.HideAllPlayerButtons()
	end
	
	--refresh the panel
	function currentFrame.Refresh (index)
	
		deathPanel.UnpressButton()
	
		local encounter = DeathGraphs.current_database [index]
		if (encounter) then
			--encounter found
			currentFrame.current_encounter = encounter
	
			--refresh the list of players
			playerListFrame.RefreshPlayers()
			--clear the graphic (if any)
			deathPanel.HidePlayerDeathEvents()
			deathPanel.HideDeathEventsSummary()
			
			--clear player selection
			currentFrame.locked_on_player = nil
		else
			--encounter doesn't exist
			segment_dropdown:Refresh()
		end
	end
	
	currentFrame:SetScript ("OnShow", function (self)
		segment_dropdown:Refresh()
		segment_dropdown:Select (1, true)
		OnSelectEncounter (_, _, 1)
	end)
	
------------------------------------------------------------------------------------------------------------------------------------
--> search keys: ~timeline
--> graphic of enemy abilities and players deaths
	
	local CONST_TIMELINE_WIGHT = 905
	local CONST_TIMELINE_HEIGHT = 505
	
	local deathAbilityGraph = CreateFrame ("frame", "DeathGraphsPlayerGraphicDeaths", f, "BackdropTemplate")
	deathAbilityGraph:SetPoint ("topleft", 10, -50)
	deathAbilityGraph:SetSize (CONST_TIMELINE_WIGHT, CONST_TIMELINE_HEIGHT)
	
	f.deathAbilityGraph = deathAbilityGraph
	
	--> dropdown:
	
		local boss_label = framework:NewLabel (deathAbilityGraph, nil, "$parentBossLabel", nil, "Boss Encounter:", "GameFontNormal")
		local OnSelectBossEncounter = function (_, _, type)
			--> selected the segment
			deathAbilityGraph.Refresh (type)
		end
		
		local build_boss_menu = function()
			local list = {}
			local db = DeathGraphs.graph_database
			
			--> hierarchy for the graph
			-- Database -> [combat hash (EncounterId + Boss Diff Id)] = DataTable hash{ }
			-- DataTable = { .deaths = hash{},  .spells = hash{},  .ids = hash{} }
			
			for hash, infoTable in pairs (db) do
				
				local EI, diff = hash:match ("(%d%d%d%d.-)(%d%d)")
				EI, diff = tonumber (EI), tonumber (diff)

				local mapId = DeathGraphs:GetInstanceIdFromEncounterId (EI)
				
				if (mapId) then
			
					local diffName = DeathGraphs:GetEncounterDiffString (diff) or ""
			
					local bossDetails, bossIndex = DeathGraphs:GetBossEncounterDetailsFromEncounterId (mapId, EI)
					local bossName = DeathGraphs:GetBossName (mapId, bossIndex)
					
					local L, R, T, B, icon = DeathGraphs:GetBossIcon (mapId, bossIndex)
					
					if (not bossName) then
						bossName = "Unknown Boss"
					end
					
					local latestTime = 0
					local spellTable = infoTable.spells
					
					for spellName, spellTimers  in pairs (spellTable) do
						for index, spell in ipairs (spellTimers) do
							local combatTime, timeAt = unpack (spell)
							if (timeAt > latestTime) then
								latestTime = timeAt
							end
						end
					end
					
					tinsert (list, {value = hash, label = bossName .. " (" .. diffName .. ")", onclick = OnSelectBossEncounter, icon = icon, texcoord = {L, R, T, B}, when = latestTime})
				end
			end
			
			table.sort (list, function (t1, t2) return t1.when > t2.when end)
			
			return list
		end
		
		local boss_dropdown = framework:NewDropDown (deathAbilityGraph, nil, "$parentBossDropdown", "BossDropdown", 150, 20, build_boss_menu, 1, options_dropdown_template)
		boss_label:SetPoint ("topleft", deathAbilityGraph, "topleft", 0, 1)
		boss_dropdown:SetPoint ("topleft", boss_label, "bottomleft", 0, -5)
		
		function boss_dropdown:SelectLastEncounter()
			local currentCombat = Details:GetCurrentCombat()
			if (currentCombat) then
				if (currentCombat.is_boss) then
					--> get the map index
					local mapID = currentCombat.is_boss.mapid
					--> get the boss index within the raid
					local bossIndex = Details:GetBossIndex (mapID, currentCombat.is_boss.id, nil, currentCombat.is_boss.name)
					if (bossIndex) then
						--> get the EJID
						local EJID = Details.EncounterInformation [mapID] and _detalhes.EncounterInformation [mapID].encounter_ids [bossIndex]
						if (EJID) then
							--> if the EJID exists build the hash
							local bossDificulty = currentCombat.is_boss.diff
							local hash = tostring (EJID) .. tostring (bossDificulty)
							if (hash) then
								boss_dropdown:Select (hash)
							end
						end
					end
				end
			end
		end
		
		--> graph frame:
		local graphFrame = CreateFrame ("frame", "DeathGraphsPlayerGraphicDeaths_graphFrame", deathAbilityGraph, "BackdropTemplate")
		
		graphFrame.Width = 738
		graphFrame.Height = 516
		graphFrame.LineHeight = 440 --> how hight the death bars goes
		graphFrame.LineWidth = 900 --> width of spellbars
		graphFrame.MaxSpellLines = 25 --> max os spell lines, they auto resize the height according to the amount shown
		graphFrame.SpellBlockAlpha = 0.3 --> the alpha of the little red spell blocks
		graphFrame.SpellLineBackground = {.5, .5, .5, .3} --> spell line default color
		graphFrame.SpellLineBackgroundHighlight = {.5, .5, .5, .8} --> color when hover over a spell line
		
		graphFrame:SetPoint ("topleft", deathAbilityGraph, "topleft", 170, 0)
		graphFrame:SetSize (graphFrame.Width, graphFrame.Height)
		graphFrame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		graphFrame:SetBackdropColor (0, 0, 0, 0)
		
		--> death lines
		local deathLinesFrame = CreateFrame ("frame", "DeathGraphsPlayerGraphicDeaths_deathLinesFrame", graphFrame, "BackdropTemplate")
		deathLinesFrame:SetFrameLevel (graphFrame:GetFrameLevel()+4)
		
		--> spells lines
		local spellLinesFrame = CreateFrame ("frame", "DeathGraphsPlayerGraphicDeaths_spellLinesFrame", graphFrame, "BackdropTemplate")
		spellLinesFrame:SetPoint ("topright", graphFrame, "topleft")
		spellLinesFrame:SetPoint ("bottomright", graphFrame, "bottomleft")
		spellLinesFrame:SetWidth (160)
		spellLinesFrame:SetFrameLevel (graphFrame:GetFrameLevel()+1)
		
		--> tutorial text
		local whiteLine = graphFrame:CreateTexture (nil, "overlay")
		whiteLine:SetColorTexture (1, 1, 1, .7)
		whiteLine:SetSize (6, 20)		
		whiteLine:SetPoint ("topleft", deathAbilityGraph, "topleft", 0, -55)		
		
		local tutorialLabel1 = framework:CreateLabel (graphFrame)
		tutorialLabel1:SetPoint ("left", whiteLine, "right", 4, 1)
		tutorialLabel1.text = "White vertical lines are\noccurences of deaths during tries"
		
		local redBlock = graphFrame:CreateTexture (nil, "overlay")
		redBlock:SetColorTexture (1, .2, .2, .7)
		redBlock:SetSize (6, 20)
		redBlock:SetPoint ("topleft", deathAbilityGraph, "topleft", 0, -85)		
		
		local tutorialLabel2 = framework:CreateLabel (graphFrame)
		tutorialLabel2:SetPoint ("left", redBlock, "right", 4, 1)
		tutorialLabel2.text = "Red squares are occurences\nof enemy spells"
		
		local y = -100
		graphFrame.SpellsLines = {}
		
		local spellLineOnEnter = function (self)
			--> show the spell tooltip when hover over the line
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			GameTooltip:SetSpellByID (self.spellid)
			self:SetBackdropColor (unpack (graphFrame.SpellLineBackgroundHighlight))
			GameTooltip:Show()
		end
		local spellLineOnLeave = function (self)
			self:SetBackdropColor (unpack (graphFrame.SpellLineBackground))
			GameTooltip:Hide()
		end
		
		--> get a spell block for the giving line spell
		local getSpellBlock = function (self)
			--get an already existing block
			local block = self.SpellBlocks [self.NextSpellBlock]
			if (block) then
				self.NextSpellBlock = self.NextSpellBlock + 1
				return block
			end
			
			--create a new block
			block = self:CreateTexture (nil, "overlay") --no framework
			block:SetColorTexture (1, 0, 0, graphFrame.SpellBlockAlpha)
			self.SpellBlocks [self.NextSpellBlock] = block
			self.NextSpellBlock = self.NextSpellBlock + 1
			return block
		end
		
		local setSpellBlockPosition = function (self, block, time)
			local startTime = graphFrame.currentStartTime
			local endTime = graphFrame.currentEndTime
			
			--> get the position
			time = time - startTime
			local pixelSize = graphFrame.pixelPerSecond
			local where = time * pixelSize
			
			--> how large is the block
			local blockWidth = graphFrame.spellBlockWidth
			
			block:SetPoint ("topleft", self, "topleft", 170 + where, 0)
			block:SetPoint ("bottomright", self, "bottomleft", 170 + where + blockWidth, 0)
			block:Show()
		end
		
		--> reset the spell block counter and hide all spell blocks
		local resetSpellBlocks = function (self)
			for i = 1, #self.SpellBlocks do
				self.SpellBlocks[i]:Hide()
			end
			self.icon.texture = ""
			self.label.text = ""
			self.NextSpellBlock = 1
		end
		
		--> set the spell name and icon
		local texcoord = {5/64, 59/64, 5/64, 59/64}
		local setIconAndSpell = function (self)
			--> spellid is a member .spellid
			local spellname, _, icon = DeathGraphs.GetSpellInfo (self.spellid)
			self.icon.texture = icon
			self.icon.texcoord = texcoord
			self.label.text = spellname
		end
		
		function graphFrame.ResetAllSpellLines()
			for i = 1, #graphFrame.SpellsLines do
				local line = graphFrame.SpellsLines[i]
				line:ResetSpell()
				line:Hide()
			end
			for i = 1, #graphFrame.DeathLines do
				local line = graphFrame.DeathLines[i]
				line:Hide()
			end
		end
		
		--> create the spell labels on the left side of the frame
		for i = 1, graphFrame.MaxSpellLines do
			local line = CreateFrame ("frame", nil, spellLinesFrame, "BackdropTemplate")
			
			line:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			line:SetBackdropColor (unpack (graphFrame.SpellLineBackground))
			
			line:SetSize (graphFrame.LineWidth, 25)
			line:SetScript ("OnEnter", spellLineOnEnter)
			line:SetScript ("OnLeave", spellLineOnLeave)
			line.spellid = 1
			line.SpellBlocks = {}
			line.ResetSpell = resetSpellBlocks
			line.GetSpellBlock = getSpellBlock
			line.SetIconAndSpellName = setIconAndSpell
			line.SetSpellBlockPositionInTime = setSpellBlockPosition
			line.NextSpellBlock = 1
			local label = framework:CreateLabel (line)
			local icon = framework:CreateImage (line, nil, 22, 22)
			icon:SetPoint ("left", line, "left", 2, 0)
			label:SetPoint ("left", icon, "right", 2, 0)
			line.icon = icon
			line.label = label
			line:Hide()
			tinsert (graphFrame.SpellsLines, line)
		end
	
		--> death lines
		graphFrame.DeathLines = {}

		--> time line
		local timeLine = CreateFrame ("frame", nil, graphFrame, "BackdropTemplate")
		timeLine:SetPoint ("bottomleft", graphFrame, "bottomleft", 0, 0)
		timeLine:SetPoint ("bottomright", graphFrame, "bottomright", 6, 0)
		timeLine:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		timeLine:SetBackdropColor (0, 0, 0, .4)
		timeLine:SetHeight (20)
		local timeLineExtension = CreateFrame ("frame", nil, graphFrame, "BackdropTemplate")
		timeLineExtension:SetPoint ("right", timeLine, "left", 0, 0)
		timeLineExtension:SetWidth (178)
		timeLineExtension:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		timeLineExtension:SetBackdropColor (0, 0, 0, .4)
		timeLineExtension:SetHeight (20)
		
		timeLine.Labels = {}
			--> build timeline labels
			for i = 1, 20 do
				local label = framework:CreateLabel (timeLine)
				tinsert (timeLine.Labels, label)
				label:SetPoint ("bottomleft", timeLine, "bottomleft", (i-1) * 37, 4)
				label.text = "00:00"
			end
			
		--> cut off events by time
		local OnSelectTimeCutOff = function (_, _, time)
			DeathGraphs.db.timeline_cutoff_time = time
			if (deathAbilityGraph.LastBoss) then
				deathAbilityGraph.Refresh (deathAbilityGraph.LastBoss)
			else
				--print ("boss not found")
			end
		end
		local timeCutOffMenu = {
			{value = 1, label = "Last 30 Minutes", onclick = OnSelectTimeCutOff},
			{value = 2, label = "Last 1 Hours", onclick = OnSelectTimeCutOff},
			{value = 3, label = "Last 2 Hours", onclick = OnSelectTimeCutOff},
			{value = 4, label = "Last 3 Hours", onclick = OnSelectTimeCutOff},
			{value = 5, label = "Last 4 Hours", onclick = OnSelectTimeCutOff},
			{value = 6, label = "Last 5 Hours", onclick = OnSelectTimeCutOff},
			{value = 7, label = "Everything", onclick = OnSelectTimeCutOff},
		}
		local build_events_by_time_menu = function()
			return timeCutOffMenu
		end
		
		local events_by_time_label = framework:NewLabel (deathLinesFrame, nil, "$parentEventsByTimeLabel", nil, "Time Sample:", "GameFontNormal")
		local events_by_time_dropdown = framework:NewDropDown (deathLinesFrame, nil, "$parentEventsByTimeDropdown", "EventsByTimeDropdown", 150, 20, build_events_by_time_menu, 1, options_dropdown_template)
		events_by_time_label:SetPoint ("topleft", deathAbilityGraph, "topleft", 170, 1)
		events_by_time_dropdown:SetPoint ("topleft", events_by_time_label, "bottomleft", 0, -5)
		--> set the default value from the database
		events_by_time_dropdown:Select (DeathGraphs.db.timeline_cutoff_time, true)
		
		--> erase events by time
		local OnSelectEraseTimeCutOff = function (_, _, time)
			DeathGraphs.db.timeline_cutoff_delete_time = time
		end
		
		local EraseTimeCutOffMenu = {
			{value = 1, label = "Older Than 30 Minutes", onclick = OnSelectEraseTimeCutOff},
			{value = 2, label = "Older Than 1 Hours", onclick = OnSelectEraseTimeCutOff},
			{value = 3, label = "Older Than 2 Hour", onclick = OnSelectEraseTimeCutOff},
			{value = 4, label = "Older Than 3 Hour", onclick = OnSelectEraseTimeCutOff},
			{value = 5, label = "Older Than 4 Hour", onclick = OnSelectEraseTimeCutOff},
			{value = 6, label = "Older Than 5 Hour", onclick = OnSelectEraseTimeCutOff},
			{value = 7, label = "Everything", onclick = OnSelectEraseTimeCutOff},
		}
		local build_erase_events_by_time_menu = function()
			return EraseTimeCutOffMenu
		end
		
		local erase_events_by_time_label = framework:NewLabel (deathLinesFrame, nil, "$parentErase_EventsByTimeLabel", nil, "Erase Samples:", "GameFontNormal")
		local erase_events_by_time_dropdown = framework:NewDropDown (deathLinesFrame, nil, "$parentErase_EventsByTimeDropdown", "Erase_EventsByTimeDropdown", 170, 20, build_erase_events_by_time_menu, 1, options_dropdown_template)
		erase_events_by_time_label:SetPoint ("topleft", deathAbilityGraph, "topleft", 350, 1)
		erase_events_by_time_dropdown:SetPoint ("topleft", erase_events_by_time_label, "bottomleft", 0, -5)
		--> set the default value
		erase_events_by_time_dropdown:Select (DeathGraphs.db.timeline_cutoff_delete_time, true)
		
		local erase_by_time = function()
			deathAbilityGraph.EraseByTime (DeathGraphs.db.timeline_cutoff_delete_time)
		end
		local confirm_erase_button = framework:NewButton (deathAbilityGraph, _, "$parentEraseEventsByTimeButton", "EraseEventsByTimeButton", 70, mode_buttons_height, erase_by_time, nil, nil, nil, "Erase", 1, options_dropdown_template)
		confirm_erase_button:SetPoint ("left", erase_events_by_time_dropdown, "right", 2, 0)
		
		function timeLine.ResetTimeline()
			for i = 1, 20 do
				local label = timeLine.Labels [i]
				label.text = "00:00"
			end
		end
		
		--> update the bottom time elapsed line
		function timeLine.UpdateTimers (length)
			if (length <= 0) then
				timeLine.ResetTimeline()
				return
			end
		
			local interval = length / 20
			local startTime = graphFrame.currentStartTime - graphFrame.currentStartTimeDiff
			startTime = max (0, startTime)
			
			--print ("interval", interval, "startTime", startTime)
			
			for i = 1, 20 do
				local time = floor (interval * i) + startTime
				local label = timeLine.Labels [i]
				label.text = format_time (time)
			end
		end
		
		--> update the graphic lines to fit in the time of the encounter
		function graphFrame.SetTimePeriod()
		
			local startTime, endTime = graphFrame.currentStartTime, graphFrame.currentEndTime
			
			local deathLines = graphFrame.DeathLines
		
			--> how many lines we will need
			local length = endTime - startTime
			--> update the bottom time elapsed bar (timeline)
			timeLine.UpdateTimers (length)
			--> we want integers to iterate on the for loop
			local lengthFloor = floor (length)
			graphFrame.timePeriod = lengthFloor
			
			--> create the required lines
			for i = #deathLines + 1, lengthFloor do
				local newLine = deathLinesFrame:CreateTexture (nil, "overlay") --no framework here
				newLine:SetColorTexture (.7, .7, .7)
				deathLines [i] = newLine
			end
			
			--> format size and set point
			local width = graphFrame.Width / length
			for i = 1, lengthFloor do
				local line = deathLines [i]
				line:SetWidth (width)
				line:SetPoint ("bottomleft", graphFrame, "bottomleft", (i-1)*width, 20)
				--> reset the height
				line:SetHeight (0)
			end
			
			--> hide all lines
			for i = 1, #deathLines do
				deathLines [i]:Hide()
			end
		end
		
		--> get the time to filter events
		function deathAbilityGraph.GetTimeToCutOff (cutoff_override)
			local now = time()
			local time_cutoff = cutoff_override or DeathGraphs.db.timeline_cutoff_time
			local cutoff
			
			if (time_cutoff == 1) then --30m
				cutoff = now - 1800
			elseif (time_cutoff == 2) then --1h
				cutoff = now - 3600
			elseif (time_cutoff == 3) then --2h
				cutoff = now - (3600*2)
			elseif (time_cutoff == 4) then --3h
				cutoff = now - (3600*3)
			elseif (time_cutoff == 5) then --4h
				cutoff = now - (3600*4)
			elseif (time_cutoff == 6) then --5h
				cutoff = now - (3600*5)
			elseif (time_cutoff == 7) then --everything
				cutoff = 0
			end
			
			return cutoff
		end
		
		--> erase spells and deaths
		local CurrentBossTable
		function deathAbilityGraph.EraseByTime (t)
			if (CurrentBossTable) then
				local bossTable = CurrentBossTable
				local cutoffTime = deathAbilityGraph.GetTimeToCutOff (t)
				if (t == 7) then
					cutoffTime = time()
				end
				
				for second, deaths in pairs (bossTable.deaths) do
					for i = #deaths, 1, -1 do
						local deathTime = deaths [i]
						if (deathTime < cutoffTime) then
							tremove (deaths, i)
						end
					end
				end
				
				if (deathAbilityGraph.LastBoss) then
					deathAbilityGraph.Refresh (deathAbilityGraph.LastBoss)
				else
					--print ("boss not found")
				end
			else
				--print ("CurrentBossTable not found")
			end
		end
		
		--> build the graphic
		function deathAbilityGraph.BuildGraph (bossTable)
			
			CurrentBossTable = bossTable
			
			local startTime, endTime = 9999, 0
			local highestDeathStack = 0

			local cutoffTime = deathAbilityGraph.GetTimeToCutOff()
			
			--> get the start and end time
			for second, deaths in pairs (bossTable.deaths) do
				local validStackOfDeaths = 0
				for i, deathTime in ipairs (deaths) do
					if (deathTime > cutoffTime) then
						validStackOfDeaths = validStackOfDeaths + 1
					end
				end
			
				if (validStackOfDeaths > 0) then
					--> check if the time of this death is lower than all other deaths
					if (second < startTime) then
						startTime = second
					end
					--> check if the time of this death is higher than all other deaths
					if (second > endTime) then
						endTime = second
					end
					--> check if this 'second' has more deaths
					local deathStack = validStackOfDeaths
					if (highestDeathStack < deathStack) then
						highestDeathStack = deathStack
					end
				end
			end
			
			--> startTimeDiff is the size of the space added before startTime, saving this value to be able to get the line of the death second.
			local startTimeDiff
			if (startTime > 20) then
				startTime = startTime - 20
				startTimeDiff = 20
			else
				startTimeDiff = startTime - 1
				startTime = 1
			end
			
			--> add a little of space after the last death
			endTime = endTime + 20
			
			--> save the start and end time state inte the graph
			graphFrame.currentStartTime = startTime
			graphFrame.currentStartTimeDiff = startTimeDiff
			graphFrame.currentEndTime = endTime
			
			--> set the graph width and the time period / hide all lines
			graphFrame.SetTimePeriod()
			--> timePeriod = total of secods between start and end time, also the total of lines shown in the graph
			local timePeriod = graphFrame.timePeriod
			
			--> calculate how much in time value one pixel
			local pixelPerSecond = graphFrame.Width / timePeriod
			graphFrame.pixelPerSecond = pixelPerSecond
			
			--> calculate the width of each spell block
			local spellBlockWidth = graphFrame.Width / timePeriod * 3.5
			graphFrame.spellBlockWidth = spellBlockWidth
			
			--> build the spells and set them into the spells frame
			local spellFrameIndex = 1
			graphFrame.ResetAllSpellLines()
			
			for spellName, indexSpellTable  in pairs (bossTable.spells) do
				--> get the next available spellLine
				local spellId = bossTable.ids [spellName]
				local spellLine = graphFrame.SpellsLines [spellFrameIndex]
				--> set the spellid for internal functions
				spellLine.spellid = spellId
				--> hide all block, clear name and icon
				spellLine:ResetSpell()
				--> set the name and icon from the spellLine.spellid
				spellLine:SetIconAndSpellName()
				
				--> show the spell block timers in the line
				for index, spellTable in ipairs (indexSpellTable) do
					local combatTime, time = unpack (spellTable)
					if (time > cutoffTime) then
						--> cut off all spells casted before the first death and after the last death
						if (combatTime >= startTime and combatTime <= endTime-10) then
							--> get the next available block
							local spellBlock = spellLine:GetSpellBlock()
							--> set it's position in the graph
							spellLine:SetSpellBlockPositionInTime (spellBlock, combatTime)
						end
					end
				end

				spellLine:Show()
				
				--> limit the shown spells in - graphFrame.MaxSpellLines (default 20)
				spellFrameIndex = spellFrameIndex + 1
				if (spellFrameIndex > graphFrame.MaxSpellLines) then
					break
				end
			end
			
			--> total of spell lines shown is
			local totalOfSpellLinesShown = spellFrameIndex - 1

			--> set the height of all spellLines shown
			local spellLinesY = 16 --to be defined
			--> get the size of the lines
			local height = 326 / totalOfSpellLinesShown --256 estimativa
			--> limit the line height in 20 pixels
			height = min (20, height)
			--height = 20
			
			--> build the spellLines height
			for i = 1, totalOfSpellLinesShown do
				local spellLine = graphFrame.SpellsLines [i]
				spellLine:SetPoint ("bottomleft", deathAbilityGraph, "bottomleft", 0, spellLinesY)
				spellLine:SetHeight (height)
				spellLine.icon:SetSize (height, height)
				spellLinesY = spellLinesY + height + 1
			end
			
			--> build the death lines height
			for second, deaths in pairs (bossTable.deaths) do
				--> get the line, we need to subtract the 'second' with startTime
				local line = graphFrame.DeathLines [second - startTime] --  + 1 - startTimeDiff
				if (not line) then
					--print ("ADL:TimeLine) Line not found.") --debug
				else
					local validStackOfDeaths = 0
					for i, deathTime in ipairs (deaths) do
						if (deathTime > cutoffTime) then
							validStackOfDeaths = validStackOfDeaths + 1
						end
					end
					
					if (validStackOfDeaths > 0) then
						--> amount of deaths on this 'second'
						local deathStack = validStackOfDeaths
						--> percent comparent within the highest deaths on a single second
						local percent = deathStack / highestDeathStack
						--> set the line height
						line:SetHeight (graphFrame.LineHeight * percent)
						line:Show()
					end
				end
			end

		end
	
	function deathAbilityGraph.OnResetAllData()
		graphFrame.ResetAllSpellLines()
		timeLine.ResetTimeline()
	end
	
	--> refresh the main frame:
	function deathAbilityGraph.Refresh (boss)
		local db = DeathGraphs.graph_database
		local bossTable = db [boss]
		
		if (bossTable) then
			deathAbilityGraph.LastBoss = boss
			deathAbilityGraph.BuildGraph (bossTable)
		end
	end
	
	--> OnShow Timeline - refresh the dropdown and show the first boss // should be show the last boss
	deathAbilityGraph:SetScript ("OnShow", function (self)
		boss_dropdown:Refresh()
		
		boss_dropdown:Select (1, true)
		boss_dropdown:SelectLastEncounter()
		
		local currentValue = boss_dropdown:GetValue()
		
		if (type (currentValue) == "string") then
			OnSelectBossEncounter (_, _, currentValue)
		end
	end)
	
end
	
end
--doo
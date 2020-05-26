--[[ 
	options panel file 
	please note: this file was wrote on 2012 when Details! had only 5 options,
	the addon got bigger but I keeped the same format, you're free to judge my decision.
--]]



--[[
	search for "~number" without the quotes to quick access the page:
	
	1 - general
	2 - combat / pvp pve
	3 - skin
	4 - row settings
	5 - row texts
	6 - window settings
	7 - title bar buttons
	8 - row advanced
	9 - wallpaper
	10 - performance teaks
	11 - raid tools
	12 - plugins
	13 - profiles
	14 - title bar text
	15 - custom spells
	16 - data for charts
	17 - automatization settings
	18 - broadcaster options
	19 - externals widgets (data feed)
	20 - tooltip
--]]

local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
local LDB = LibStub ("LibDataBroker-1.1", true)
local LDBIcon = LDB and LibStub ("LibDBIcon-1.0", true)
local tinsert = tinsert

local g =	_detalhes.gump
local _
local preset_version = 3
_detalhes.preset_version = preset_version

local slider_backdrop = {edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8,
bgFile = [[Interface\ACHIEVEMENTFRAME\UI-GuildAchievement-Parchment-Horizontal-Desaturated]], tile = true, tileSize = 130, insets = {left = 1, right = 1, top = 5, bottom = 5}}

local slider_backdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\AddOns\Details\images\border_3]], tile=true,
	edgeSize = 15, tileSize = 64, insets = {left = 3, right = 3, top = 4, bottom = 4}}

local slider_backdrop_color = {1, 1, 1, 1}

local slider_backdrop_color = {1, 1, 1, 0.5}
local slider_backdrop_border_color = {.5, .5, .5}

local button_color_rgb = {1, 0.93, 0.74}

local font_select_icon, font_select_texcoord = [[Interface\AddOns\Details\images\icons]], {472/512, 513/512, 186/512, 230/512}
local texture_select_icon, texture_select_texcoord = [[Interface\AddOns\Details\images\icons]], {472/512, 513/512, 186/512, 230/512}

local dropdown_backdrop = {edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize = 14,
bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, insets = {left = 3, right = 3, top = 0, bottom = 0}}
dropdown_backdrop_border_color = {.7, .7, .7}
local dropdown_height = 18

local dropdown_backdrop_onenter = {0, 0, 0, 1}
local dropdown_backdrop_onleave = {.1, .1, .1, .9}

local SLIDER_WIDTH = 130
local SLIDER_HEIGHT = 18
local TEXTENTRY_HEIGHT = 18
local DROPDOWN_WIDTH = 160
local COLOR_BUTTON_WIDTH = 160



local CONST_BUTTON_TEMPLATE = g:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE")



_detalhes.options_window_background = [[Interface\AddOns\Details\images\options_window]]

function _detalhes:SetOptionsWindowTexture (texture)
	_detalhes.options_window_background = texture
	if (_G.DetailsOptionsWindowBackground) then
		_G.DetailsOptionsWindowBackground:SetTexture (texture)
	end
end


function _detalhes:InitializeOptionsWindow()
	local DetailsOptionsWindow = g:NewPanel (UIParent, _, "DetailsOptionsWindow", _, 897, 592)
	
	local f = DetailsOptionsWindow.frame
	
	f.Frame = f
	f.__name = "Options"
	f.real_name = "DETAILS_OPTIONS"
	f.__icon = [[Interface\Scenarios\ScenarioIcon-Interact]]
	DetailsPluginContainerWindow.EmbedPlugin (f, f, true)
	f:Hide()

	function f.RefreshWindow()
		if (not _G.DetailsOptionsWindow.instance) then
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _detalhes:GetInstance (1)
				_detalhes.CriarInstancia (_, _, 1)
				_detalhes:OpenOptionsWindow (instance)
			else
				_detalhes:OpenOptionsWindow (_detalhes:GetInstance (lower_instance))
			end
		else
			_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
		end
	end
end


function _detalhes:OpenOptionsWindow (instance, no_reopen, section)

	if (not instance.meu_id) then
		instance, no_reopen, section = unpack (instance)
	end

	GameCooltip:Close()
	local window = _G.DetailsOptionsWindow
	
	local editing_instance = instance
	
	if (_G.DetailsOptionsWindow) then
		_G.DetailsOptionsWindow.instance = instance
	end
	
	if (not no_reopen and not instance:IsEnabled() or not instance:IsStarted()) then
		_detalhes.CriarInstancia (_, _, instance:GetId())
	end
	
	if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow.full_created) then
		_detalhes:FormatBackground (_G.DetailsOptionsWindow)
		
		_G.DetailsOptionsWindow.MyObject:update_all (instance, section)
		DetailsOptionsWindow.OpenInPluginPanel()
		return 
	end
	
	if (not window or not window.Initialized) then

		local options_button_template = g:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
		local options_dropdown_template = g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
		local options_slider_template = g:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
		local options_switch_template = g:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE")
		
		g:InstallTemplate ("button", "DETAILS_TITLEBAR_OPTION_BUTTON_TEMPLATE", {
			backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
			backdropcolor = {1, 1, 1, .1},
			backdropbordercolor = {0, 0, 0, 1},
			width = 21,
			height = 21,
			onentercolor = {1, 1, 1, .3},
		})
		g:InstallTemplate ("button", "DETAILS_SKIN_OPTION_BUTTON_TEMPLATE", {
			backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
			backdropcolor = {1, 1, 1, .5},
			backdropbordercolor = {0, 0, 0, 1},
			width = 160,
			height = 18,
			icon = {texture = [[Interface\Buttons\UI-OptionsButton]], width = 12, height = 12, color = {1, 0.8, 0, 1}, textdistance = 3, leftpadding = 2},
		})

		local config_slider = function (slider)
			slider:SetBackdrop (slider_backdrop)
			slider:SetBackdropColor (unpack (slider_backdrop_color))
			slider:SetBackdropBorderColor (unpack (slider_backdrop_border_color))
			slider:SetThumbSize (50, 19)
			slider.thumb:SetTexture ([[Interface\AddOns\Details\images\knob]])
		end

		-- Most of details widgets have the same 6 first parameters: parent, container, global name, parent key, width, height
	
		window = DetailsOptionsWindow and DetailsOptionsWindow.MyObject or g:NewPanel (UIParent, _, "DetailsOptionsWindow", _, 897, 592)
		window.Initialized = true
		window.frame.Initialized = true
		
		window.instance = instance
		tinsert (UISpecialFrames, "DetailsOptionsWindow")
		window:SetFrameStrata ("HIGH")
		window:SetToplevel (true)
		window:SetPoint ("center", UIParent, "Center")
		window.locked = false
		window.close_with_right = true
		window.backdrop = nil
		
		window.using_skin = 1
		
		local scaleBar = Details.gump:CreateScaleBar (DetailsOptionsWindow, Details.options_window)
		DetailsOptionsWindow:SetScale (Details.options_window.scale)
		
		DetailsOptionsWindow.instance = instance
		DetailsOptionsWindow.loading_settings = true
		
		window:SetHook ("OnHide", function()
			DetailsDisable3D:Hide()
			DetailsOptionsWindowDisable3D:SetChecked (false)
			window.Disable3DColorPick:Hide()
			window.Disable3DColorPick:Cancel()
			GameCooltip:Hide()
			
			if (window.help_popups) then
				for _, widget in ipairs (window.help_popups) do
					widget:Hide()
				end
			end
		end)
		
		--x 9 897 y 9 592
		
		--local background = g:NewImage (window, _detalhes.options_window_background, 897, 592, nil, nil, "background", "$parentBackground")
		--background:SetPoint (0, 0)
		--background:SetDrawLayer ("border")
		--background:SetTexCoord (0, 0.8759765625, 0, 0.578125)
		
		--local sub_background = window:CreateTexture ("DetailsOptionsWindowBackgroundWallpaper", "background")
		--sub_background:SetTexture ([[Interface\FrameGeneral\UI-Background-Marble]], true)
		--sub_background:SetTexture ([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		--sub_background:SetPoint ("topleft", window.widget, "topleft", 192, -80)
		--sub_background:SetPoint ("bottomright", window.widget, "bottomright", -30, 27)
		--sub_background:SetVertTile (true)
		--sub_background:SetHorizTile (true)
		--sub_background:SetAlpha (0.81)
		--sub_background:SetAlpha (0.85)
		--sub_background:Hide()
		
		--local menu_background = window:CreateTexture ("DetailsOptionsWindowBackgroundMenu", "background")
		--menu_background:SetTexture ([[Interface\AddOns\Details\images\options_window]], true)
		--menu_background:SetTexture ([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		--menu_background:SetPoint ("topleft", window.widget, "topleft", 29, -78)
		--menu_background:SetSize (164, 488)
		--menu_background:SetTexCoord (327/1024, 488/1024, 627/1024, 663/1024)
		--menu_background:SetAlpha (0.81)
		--menu_background:SetAlpha (0.85)
		--menu_background:SetVertTile (true)
		--menu_background:Hide()

		local bigdog = g:NewImage (window, [[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]], 180*0.9, 200*0.9, nil, {1, 0, 0, 1}, "backgroundBigDog", "$parentBackgroundBigDog")
		bigdog:SetPoint ("bottomright", window, "bottomright", -8, 31)
		bigdog:SetAlpha (.25)
		
		local window_icon = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 58, 58, nil, nil, "windowicon", "$parentWindowIcon")
		window_icon:SetPoint (17, -17)
		window_icon:SetDrawLayer ("background")
		window_icon:SetTexCoord (0, 0.054199, 0.591308, 0.646972) --605 663

		--> title
		local title = g:NewLabel (window, nil, "$parentTitleLabel", "title", "Details! " .. Loc ["STRING_OPTIONS_WINDOW"], "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
		title:SetPoint ("center", window, "center")
		title:SetPoint ("top", window, "top", 0, -28)
		
		--> edit what label
		local editing = g:NewLabel (window, nil, "$parentEditingLabel", "editing", Loc ["STRING_OPTIONS_GENERAL"], "QuestFont_Large", 20, "white")
		--editing:SetPoint ("topleft", window, "topleft", 90, -57)
		editing:SetPoint ("topright", window, "topright", -30, -62)
		editing.options = {Loc ["STRING_OPTIONS_GENERAL"], Loc ["STRING_OPTIONS_APPEARANCE"], Loc ["STRING_OPTIONS_PERFORMANCE"], Loc ["STRING_OPTIONS_PLUGINS"]}
		editing.shadow = 2
		
		--> edit anchors
		editing.apoio_icone_esquerdo = window:CreateTexture (nil, "ARTWORK")
		editing.apoio_icone_direito = window:CreateTexture (nil, "ARTWORK")
		--editing.apoio_icone_esquerdo:SetTexture ("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
		--editing.apoio_icone_direito:SetTexture ("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
		
		local apoio_altura = 13/256
		editing.apoio_icone_esquerdo:SetTexCoord (0, 1, 0, apoio_altura)
		editing.apoio_icone_direito:SetTexCoord (0, 1, apoio_altura+(1/256), apoio_altura+apoio_altura)
		
		editing.apoio_icone_esquerdo:SetPoint ("bottomright", editing.widget, "bottomleft",  42, 0)
		editing.apoio_icone_direito:SetPoint ("bottomleft", editing.widget, "bottomright",  -8, 0)
		
		editing.apoio_icone_esquerdo:SetWidth (64)
		editing.apoio_icone_esquerdo:SetHeight (13)
		editing.apoio_icone_direito:SetWidth (64)
		editing.apoio_icone_direito:SetHeight (13)		
		
		--> close button
		local close_button = CreateFrame ("button", "DetailsOptionsWindowCloseButton", window.widget, "UIPanelCloseButton")
		close_button:SetWidth (32)
		close_button:SetHeight (32)
		close_button:SetPoint ("TOPRIGHT", window.widget, "TOPRIGHT", 0, -19)
		close_button:SetText ("X")
		close_button:SetFrameLevel (close_button:GetFrameLevel()+2)
		
		--> desc text (on the right)
		local info_text = g:NewLabel (window, nil, "$parentInfoTextLabel", "infotext", "", "GameFontNormal", 12)
		info_text:SetPoint ("topleft", window, "topleft", 560, -109)
		info_text.width = 300
		info_text.height = 380
		info_text.align = "<"
		info_text.valign = "^"
		info_text.active = false
		info_text.color = "white"

		local desc_anchor_topright = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.2724609375, 0.19921875, 0.6796875, 0.783203125}, "descAnchorTopRightImage", "$parentDescAnchorTopRightImage") --204 696 279 802
		desc_anchor_topright:SetPoint ("topleft", window.widget, "topleft", 796, -76)
		desc_anchor_topright:Hide()
		desc_anchor_topright:SetAlpha (.8)
		local desc_anchor_topleft = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.19921875, 0.2724609375, 0.783203125, 0.6796875}, "descAnchorBottomLeftImage", "$parentDescAnchorBottomLeftImage") --204 696 279 802
		desc_anchor_topleft:SetPoint ("topleft", window.widget, "topleft", 191, -465)
		desc_anchor_topleft:Hide()
		desc_anchor_topleft:SetAlpha (.8)
		local desc_anchor_bottomleft = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.19921875, 0.2724609375, 0.6796875, 0.783203125}, "descAnchorTopLeftImage", "$parentDescAnchorTopLeftImage") --204 696 279 802
		desc_anchor_bottomleft:SetPoint ("topleft", window.widget, "topleft", 191, -76)
		desc_anchor_bottomleft:Hide()
		desc_anchor_bottomleft:SetAlpha (.8)
		
		local desc_anchor = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.19921875, 0.2724609375, 0.6796875, 0.783203125}, "descAnchorImage", "$parentDescAnchorImage") --204 696 279 802
		desc_anchor:SetPoint ("topleft", info_text, "topleft", -28, 33)
		
		local desc_background = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 253, 198, "artwork", {0.3193359375, 0.56640625, 0.685546875, 0.87890625}, "descBackgroundImage", "$parentDescBackgroundImage") -- 327 702 580 900
		desc_background:SetPoint ("topleft", info_text, "topleft", 0, 0)

-- as it stands in the plugin panel, these buttons aren't required anymore
		--> forge and history buttons
--		local forge_button = g:NewButton (window, _, "$parentForgeButton", "ForgeButton", 90, 20, function() _detalhes:OpenForge(); window:Hide() end, nil, nil, nil, "Open Forge", 1) --, g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
--		forge_button:SetIcon ([[Interface\AddOns\Details\images\icons]], nil, nil, nil, {396/512, 428/512, 243/512, 273/512}, nil, nil, 2)
--		forge_button:SetPoint ("topleft", 80, -61)

--		local history_button = g:NewButton (window, _, "$parentHistoryButton", "HistoryButton", 90, 20, function() _detalhes:OpenRaidHistoryWindow(); window:Hide() end, nil, nil, nil, "Guild Rank", 1) --, g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
--		history_button:SetIcon ([[Interface\AddOns\Details\images\icons]], nil, nil, nil, {434/512, 466/512, 243/512, 273/512}, nil, nil, 2)
--		history_button:SetPoint ("topleft", 180, -61)

		--> select instance dropbox
		local onSelectInstance = function (_, _, instance)
		
			local this_instance = _detalhes.tabela_instancias [instance]
			
			if (not this_instance:IsEnabled() or not this_instance:IsStarted()) then
				_detalhes.CriarInstancia (_, _, this_instance.meu_id)
			end
			
			_detalhes:OpenOptionsWindow (this_instance)
		end

		local buildInstanceMenu = function()
			local InstanceList = {}
			for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount), 1 do 
				local _this_instance = _detalhes.tabela_instancias [index]

				--> pegar o que ela ta mostrando
				local atributo = _this_instance.atributo
				local sub_atributo = _this_instance.sub_atributo
				
				if (atributo == 5) then --> custom
				
					local CustomObject = _detalhes.custom [sub_atributo]
					
					if (not CustomObject) then
						_this_instance:ResetAttribute()
						atributo = _this_instance.atributo
						sub_atributo = _this_instance.sub_atributo
						InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
					else
						InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. CustomObject.name, onclick = onSelectInstance, icon = CustomObject.icon}
					end

				else
					local modo = _this_instance.modo
					
					if (modo == 1) then --alone
						atributo = _detalhes.SoloTables.Mode or 1
						local SoloInfo = _detalhes.SoloTables.Menu [atributo]
						if (SoloInfo) then
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. SoloInfo [1], onclick = onSelectInstance, icon = SoloInfo [2]}
						else
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
						end
						
					elseif (modo == 4) then --raid
						local plugin_name = _this_instance.current_raid_plugin or _this_instance.last_raid_plugin
						if (plugin_name) then
							local plugin_object = _detalhes:GetPlugin (plugin_name)
							if (plugin_object) then
								InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. plugin_object.__name, onclick = onSelectInstance, icon = plugin_object.__icon}
							else
								InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
							end
						else
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
						end
					else
						InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
						
					end
				end
			end
			return InstanceList
		end

		--local profile_string = g:NewLabel (window, nil, nil, "instancetext", "Current Profile:", "GameFontNormal", 12)
		--profile_string:SetPoint ("bottomleft", window, "bottomleft", 27, 11)
		
		local instances = g:NewDropDown (window, _, "$parentInstanceSelectDropdown", "instanceDropdown", 200, 18, buildInstanceMenu) --, nil, options_dropdown_template
		instances:SetPoint ("bottomright", window, "bottomright", -17, 09)
		instances:SetHook ("OnEnter", function()
			GameCooltip:Reset()
			GameCooltip:Preset (2)
			GameCooltip:AddLine (Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL1"])
			GameCooltip:ShowCooltip (instances.widget, "tooltip")
		end)
		instances:SetHook ("OnLeave", function()
			GameCooltip:Hide()
		end)
		
		local instances_string = g:NewLabel (window, nil, "$parentInstanceDropdownLabel", "instancetext", Loc ["STRING_OPTIONS_EDITINSTANCE"], "GameFontNormal", 12)
		instances_string:SetPoint ("right", instances, "left", -2, 1)

		--
		local group_editing = CreateFrame ("CheckButton", "DetailsOptionsWindowGroupEditing", window.widget, "ChatConfigCheckButtonTemplate")
		group_editing:ClearAllPoints()
		DetailsOptionsWindowGroupEditingText:ClearAllPoints()
		group_editing:SetPoint ("right", DetailsOptionsWindowGroupEditingText, "left", -1, 0)
		DetailsOptionsWindowGroupEditingText:SetText ("Editing Group")
		DetailsOptionsWindowGroupEditingText:SetPoint ("right", instances_string.widget, "left", -20, 0)
		DetailsOptionsWindowGroupEditingText:SetTextColor (1, 0.8, 0)
		group_editing.tooltip = Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL2"]
		group_editing:SetHitRectInsets (0, -105, 0, 0)

		group_editing:SetChecked (_detalhes.options_group_edit)
		
		group_editing:SetScript ("OnClick", function()
			_detalhes.options_group_edit = group_editing:GetChecked()
		end)
		
		local group_editing_help = group_editing:CreateTexture (nil, "overlay")
		group_editing_help:SetSize (16, 16)
		group_editing_help:SetPoint ("right", group_editing, "left", -1, 0)
		group_editing_help:SetAlpha (0.6)
		group_editing_help:SetTexture ([[Interface\GossipFrame\IncompleteQuestIcon]])
		
		local group_editing_help_frame = g:NewButton (group_editing, _, "$parentHelpButton", "HelpButton", 16, 16, _detalhes.empty_function)
		group_editing_help_frame:SetPoint ("right", group_editing_help, "right", 1, 0)
		--group_editing_help_frame:InstallCustomTexture()
		group_editing_help_frame:SetHook ("OnEnter", function()
			group_editing_help:SetTexture ([[Interface\GossipFrame\ActiveQuestIcon]])
			GameCooltip:Reset()
			GameCooltip:Preset (2)
			GameCooltip:AddLine (Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL3"])
			GameCooltip:ShowCooltip (group_editing_help_frame, "tooltip")
		end)
		group_editing_help_frame:SetHook ("OnLeave", function()
			group_editing_help:SetTexture ([[Interface\GossipFrame\IncompleteQuestIcon]])
			GameCooltip:Hide()
		end)

		instances.OnDisable = function (self)
			instances_string:SetAlpha (0.4)
			group_editing:SetAlpha (0.4)
			group_editing:Disable()
		end
		
		instances.OnEnable = function (self)
			instances_string:SetAlpha (1)
			group_editing:SetAlpha (1)
			group_editing:Enable()
		end
		
		--
		
		local f = CreateFrame ("frame", "DetailsDisable3D", UIParent)
		tinsert (UISpecialFrames, "DetailsDisable3D")
		f:SetFrameStrata ("BACKGROUND")
		f:SetFrameLevel (0)
		f:SetPoint ("topleft", WorldFrame, "topleft")
		f:SetPoint ("bottomright", WorldFrame, "bottomright")
		f:Hide()
		
		local t = f:CreateTexture ("DetailsDisable3DTexture", "background")
		t:SetAllPoints (f)
		t:SetTexture (.5, .5, .5, 1)
		
		local c = f:CreateTexture ("DetailsDisable3DTexture", "border")
		c:SetPoint ("center", f, "center", 0, -5)
		c:SetTexture ([[Interface\Challenges\challenges-metalglow]])
		c:SetDesaturated (true)
		c:SetAlpha (.6)
		local tt = f:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
		tt:SetPoint ("center", f, "center", 0, -5)
		tt:SetText ("Character\nPosition")
		
		local hide_3d_world = CreateFrame ("CheckButton", "DetailsOptionsWindowDisable3D", window.widget, "ChatConfigCheckButtonTemplate")
		hide_3d_world:SetPoint ("bottomleft", window.widget, "bottomleft", 28, 7)
		DetailsOptionsWindowDisable3DText:SetText (Loc ["STRING_OPTIONS_INTERFACEDIT"])
		DetailsOptionsWindowDisable3DText:ClearAllPoints()
		DetailsOptionsWindowDisable3DText:SetPoint ("left", hide_3d_world, "right", -2, 1)
		DetailsOptionsWindowDisable3DText:SetTextColor (1, 0.8, 0)
		hide_3d_world.tooltip = "Goodbye Cruel World :("
		hide_3d_world:SetHitRectInsets (0, -105, 0, 0)
		
		hide_3d_world:SetScript ("OnClick", function()
			if (hide_3d_world:GetChecked()) then
				f:Show()
				window.Disable3DColorPick:Show()
			else
				f:Hide()
				window.Disable3DColorPick:Hide()
			end
		end)
		
		local last_change = GetTime()
		local disable3dcolor_callback = function (button, r, g, b)
			if (last_change+0.5 < GetTime()) then --protection agaist fast color changes
				t:SetTexture (r, g, b)
				last_change = GetTime()
			end
		end
		g:NewColorPickButton (window, "$parentDisable3DColorPick", "Disable3DColorPick", disable3dcolor_callback)
		window.Disable3DColorPick:SetPoint ("left", hide_3d_world, "right", 120, 0)
		window.Disable3DColorPick:SetColor (.5, .5, .5, 1)
		window.Disable3DColorPick:Hide()
	
		--> disabled
		hide_3d_world:Hide()
	
	--> create bars
		
		g:NewColor ("C_OptionsButtonOrange", 0.9999, 0.8196, 0, 1)
		
		local create_test_bars_func = function()
			_detalhes.CreateTestBars()
			if (not _detalhes.test_bar_update) then
				_detalhes:StartTestBarUpdate()
			else
				_detalhes:StopTestBarUpdate()
			end
		end
		local fillbars = g:NewButton (window, _, "$parentCreateExampleBarsButton", nil, 110, 14, create_test_bars_func, nil, nil, nil, Loc ["STRING_OPTIONS_TESTBARS"], 1)
		fillbars:SetPoint ("bottomleft", window.widget, "bottomleft", 41, 12)
		fillbars:SetTemplate (CONST_BUTTON_TEMPLATE)
		
		local fillbars_image = g:NewImage (window, [[Interface\Buttons\UI-RADIOBUTTON]], 8, 9, "artwork", {20/64, 27/64, 4/16, 11/16})
		fillbars_image:SetPoint ("right", fillbars, "left", -1, 0)
		
	--> change log

		local changelog = g:NewButton (window, _, "$parentOpenChangeLogButton", nil, 110, 14, _detalhes.OpenNewsWindow, "change_log", nil, nil, Loc ["STRING_OPTIONS_CHANGELOG"], 1)
		changelog:SetPoint ("left", fillbars, "right", 10, 0)
		changelog:SetTemplate (CONST_BUTTON_TEMPLATE)
		
		local changelog_image = g:NewImage (window, [[Interface\Buttons\UI-RADIOBUTTON]], 8, 9, "artwork", {20/64, 27/64, 4/16, 11/16})
		changelog_image:SetPoint ("right", changelog, "left", -1, 0)
		
	--> send feedback
	
		local feedback_button = g:NewButton (window, _, "$parentOpenFeedbackButton", nil, 80, 14, _detalhes.OpenFeedbackWindow, nil, nil, nil, Loc ["STRING_OPTIONS_SENDFEEDBACK"], 1)
		feedback_button:SetPoint ("left", changelog, "right", 10, 0)
		feedback_button:SetTemplate (CONST_BUTTON_TEMPLATE)
		
		local feedback_image = g:NewImage (window, [[Interface\Buttons\UI-RADIOBUTTON]], 8, 9, "artwork", {20/64, 27/64, 4/16, 11/16})
		feedback_image:SetPoint ("right", feedback_button, "left", -1, 0)
		
		feedback_button:Hide()
		
	--> translate
--[[
		local translate_button = g:NewButton (window, _, "$parentOpenTranslateButton", nil, 140, 14, _detalhes.OpenTranslateWindow, nil, nil, nil, Loc ["STRING_TRANSLATE_LANGUAGE"], 1)
		translate_button:SetPoint ("left", feedback_button, "right", 10, 0)
		translate_button.textalign = "left"
		translate_button:SetHook ("OnEnter", function()
			translate_button:SetTextColor (1, 1, 0)
		end)
		translate_button:SetHook ("OnLeave", function()
			translate_button:SetTextColor (0.9999, 0.8196, 0, 1)
		end)
		
		local feedback_image = g:NewImage (window, "Interface\\Buttons\\UI-RADIOBUTTON", 8, 9, "artwork", {20/64, 27/64, 4/16, 11/16})
		feedback_image:SetPoint ("right", translate_button, "left", -1, 0)
--]]
		
	--> right click to close
		--local right_click_close = window:CreateRightClickLabel ("short", 14, 14, "Close")
		--right_click_close:SetPoint ("left", fillbars, "right", 90, 0)
		--_detalhes:SetFontColor (right_click_close.widget, {1, 0.82, 0, 1})
		--_detalhes:SetFontFace (right_click_close.widget, [[Fonts\FRIZQT__.TTF]])
		--_detalhes:SetFontOutline (right_click_close.widget, true)
		--_detalhes:SetFontSize (right_click_close.widget, 12)
		
	--> left panel buttons

	--mudando a ordem do menu
	--menus_settings = { muda a poci��o de qual menu ser� mostrado
	--menus = { muda a poci��o do text no menu
	
	--> index dos menus
	local menus_settings = {
		--general settings
		1, --display
		2, --combat
		20, --tooltip
		19, --datafeed
		13, --profiles
		
		--appearance
		3, --skin

		4, --row general
		5, --row texts
		8, --row advanced

		7, -- title bar buttons
		14, --title bar text
		
		6, --window settings 
		17, --auto hide settings
		9, --wallpaper		
		
		18, --streamer options
		
		--advanced
		11, --raid tools
		10, --performance
		12, --plugins
		15, --spell custom
		16 --chart data
	}
	
	
local menus = { --labels nos menus
	{
		Loc ["STRING_OPTIONSMENU_DISPLAY"], 
		Loc ["STRING_OPTIONSMENU_COMBAT"], 
		Loc ["STRING_OPTIONSMENU_TOOLTIP"], 
		Loc ["STRING_OPTIONSMENU_DATAFEED"], 
		Loc ["STRING_OPTIONSMENU_PROFILES"]
	},
	
	{
		Loc ["STRING_OPTIONSMENU_SKIN"], 

		Loc ["STRING_OPTIONSMENU_ROWSETTINGS"], 
		Loc ["STRING_OPTIONSMENU_ROWTEXTS"], 
		Loc ["STRING_OPTIONSMENU_ROWMODELS"], 

		Loc ["STRING_OPTIONSMENU_LEFTMENU"], 
		Loc ["STRING_OPTIONSMENU_TITLETEXT"], 
		
		Loc ["STRING_OPTIONSMENU_WINDOW"], 
		Loc ["STRING_OPTIONSMENU_AUTOMATIC"],
		Loc ["STRING_OPTIONSMENU_WALLPAPER"], 
		
		"Streamer Settings", --Loc ["STRING_OPTIONSMENU_MISC"]
	},
	
	{	
		Loc ["STRING_OPTIONSMENU_RAIDTOOLS"], 
		Loc ["STRING_OPTIONSMENU_PERFORMANCE"], 
		Loc ["STRING_OPTIONSMENU_PLUGINS"], 
		Loc ["STRING_OPTIONSMENU_SPELLS"], 
		Loc ["STRING_OPTIONSMENU_DATACHART"]
	}
}

local menus2 = {
		Loc ["STRING_OPTIONSMENU_DISPLAY"], --1
		Loc ["STRING_OPTIONSMENU_COMBAT"], --2
		Loc ["STRING_OPTIONSMENU_SKIN"], --3
		Loc ["STRING_OPTIONSMENU_ROWSETTINGS"], --4
		Loc ["STRING_OPTIONSMENU_ROWTEXTS"], --5
		Loc ["STRING_OPTIONSMENU_WINDOW"], --6
		Loc ["STRING_OPTIONSMENU_LEFTMENU"], --7
		Loc ["STRING_OPTIONSMENU_ROWMODELS"], --8
		Loc ["STRING_OPTIONSMENU_WALLPAPER"], --9
		Loc ["STRING_OPTIONSMENU_PERFORMANCE"],--10
		Loc ["STRING_OPTIONSMENU_RAIDTOOLS"], --11
		Loc ["STRING_OPTIONSMENU_PLUGINS"],--12
		Loc ["STRING_OPTIONSMENU_PROFILES"], --13
		Loc ["STRING_OPTIONSMENU_TITLETEXT"], --14
		Loc ["STRING_OPTIONSMENU_SPELLS"], --15
		Loc ["STRING_OPTIONSMENU_DATACHART"], --16
		Loc ["STRING_OPTIONSMENU_AUTOMATIC"], --17
		"Streamer Settings", --18
		Loc ["STRING_OPTIONSMENU_DATAFEED"], --19
		Loc ["STRING_OPTIONSMENU_TOOLTIP"], --20
	}
	
	local is_window_settings = {
		[1] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[14] = true,
		[17] = true,
		--[18] = true,
	}
	window.is_window_settings = is_window_settings
	
		--~new
		local newIcon = g:CreateImage (window, [[Interface\AddOns\Details\images\icons2]], 62*0.6, 40*0.6, "overlay", {443/512, 505/512, 306/512, 346/512})
		--newIcon:SetPoint ("topleft", window.widget, "topleft", 135, -351)
	
		local select_options = function (options_type, true_index)
			
			window.current_selected = options_type
			
			if (is_window_settings [options_type]) then
				instances:Enable()
			else
				instances:Disable()
			end
			
			window:hide_all_options()
			
			window:un_hide_options (options_type)
			
			editing.text = menus2 [options_type]
			
			-- ~altura
			if (options_type == 12 or options_type == 15 or options_type == 16) then --plugins / spell custom / charts
				window.options [12][1].slider:SetMinMaxValues (0, 320)
				--info_text.text = ""
				info_text:Hide()
				window.descAnchorImage:Hide()
				window.descBackgroundImage:Hide()
				
				window.descAnchorTopLeftImage:Hide()
				window.descAnchorBottomLeftImage:Hide()
				window.descAnchorTopRightImage:Hide()
				
			else
				info_text:Hide()
				window.descAnchorImage:Hide()
				window.descBackgroundImage:Hide()
				
				if (window.using_skin == 1) then --normal skin
					window.descAnchorTopLeftImage:Show()
					window.descAnchorBottomLeftImage:Show()
					window.descAnchorTopRightImage:Show()
				end
			end
			
		end

		local mouse_over_texture = g:NewImage (window, [[Interface\AddOns\Details\images\options_window]], 156, 22, nil, nil, "buttonMouseOver", "$parentButtonMouseOver")
		--mouse_over_texture:SetTexCoord (0.006347, 0.170410, 0.528808, 0.563964)
		mouse_over_texture:SetTexCoord (0.1044921875, 0.26953125, 0.6259765625, 0.662109375)
		mouse_over_texture:SetWidth (169)
		mouse_over_texture:SetHeight (37)
		mouse_over_texture:Hide()
		mouse_over_texture:SetBlendMode ("ADD")
		
		--> menu anchor textures
		
		local menu_frame = CreateFrame("frame", "DetailsOptionsWindowMenuAnchor", window.widget)
		menu_frame:SetPoint ("TopLeft", window.widget, "TopLeft", 0, -90)
		menu_frame:SetSize (1, 1)
		
		--general settings
		
			local menuTitleAnchorX = 10
		
			local g_settings = g:NewButton (menu_frame, _, "$parentGeneralSettingsButton", "g_settings", 150, 33, function() end, 0x1)
			
			g:NewLabel (menu_frame, _, "$parentgeneral_settings_text", "GeneralSettingsLabel", Loc ["STRING_OPTIONS_GENERAL"], "GameFontNormal", 12)
			menu_frame.GeneralSettingsLabel:SetPoint ("topleft", g_settings, "topleft", menuTitleAnchorX, -10)
		
		--	local g_settings_texture = g:NewImage (menu_frame, [[Interface\AddOns\Details\images\options_window]], 160, 33, nil, nil, "GeneralSettingsTexture", "$parentGeneralSettingsTexture")
		--	g_settings_texture:SetTexCoord (0, 0.15625, 0.685546875, 0.7177734375)
		--	g_settings_texture:SetPoint ("topleft", g_settings, "topleft", 0, 0)

		--apparance
			local g_appearance = g:NewButton (menu_frame, _, "$parentAppearanceButton", "g_appearance", 150, 33, function() end, 0x2)

			g:NewLabel (menu_frame, _, "$parentappearance_settings_text", "AppearanceSettingsLabel", Loc ["STRING_OPTIONS_APPEARANCE"], "GameFontNormal", 12)
			menu_frame.AppearanceSettingsLabel:SetPoint ("topleft", g_appearance, "topleft", menuTitleAnchorX, -11)
		
		--	local g_appearance_texture = g:NewImage (menu_frame, [[Interface\AddOns\Details\images\options_window]], 160, 33, nil, nil, "AppearanceSettingsTexture", "$parentAppearanceSettingsTexture")
		--	g_appearance_texture:SetTexCoord (0, 0.15625, 0.71875, 0.7509765625)
		--	g_appearance_texture:SetPoint ("topleft", g_appearance, "topleft", 0, 0)

		--advanced
			local g_advanced = g:NewButton (menu_frame, _, "$parentAdvancedButton", "g_advanced", 150, 33, function() end, 0x4)
			
			g:NewLabel (menu_frame, _, "$parentadvanced_settings_text", "AdvancedSettingsLabel", Loc ["STRING_OPTIONS_ADVANCED"], "GameFontNormal", 12)
			menu_frame.AdvancedSettingsLabel:SetPoint ("topleft", g_advanced, "topleft", menuTitleAnchorX, -11)
		
		--	local g_advanced_texture = g:NewImage (menu_frame, [[Interface\AddOns\Details\images\options_window]], 160, 33, nil, nil, "AdvancedSettingsTexture", "$parentAdvancedSettingsTexture")
		--	g_advanced_texture:SetTexCoord (0, 0.15625, 0.8173828125, 0.849609375)
		--	g_advanced_texture:SetPoint ("topleft", g_advanced, "topleft", 0, 0)

		
		
		--> create menus
		local anchors = {g_settings, g_appearance, g_advanced} --g_performance
		local y = 0
		local sub_menu_index = 1
		
		local textcolor = {.8, .8, .8, 1}
		local last_pressed
		local all_buttons = {}
		window.menu_buttons = all_buttons
		local true_index = 1
		local selected_textcolor = "wheat"

		local selected_texture = g:NewImage (window, [[Interface\ARCHEOLOGY\ArchaeologyParts]], 130, 14)
		selected_texture:SetTexCoord (0.146484375, 0.591796875, 0.0546875, 0.26171875)
		selected_texture:SetVertexColor (1, 1, 1, 0.8)
		selected_texture:SetBlendMode ("ADD")

		local is_appearance = {
			[3] = true,
			[4] = true,
			[5] = true,
			[8] = true,
			[14] = true,
			[7] = true,
			[6] = true,
			[17] = true,
			[9] = true,
			[18] = true,
		}
		local button_onenter = function (self, capsule)
			self.MyObject.my_bg_texture:SetVertexColor (1, 1, 1, 1)
			self.MyObject.textcolor = "yellow"
		end
		local button_onleave = function (self)
			self.MyObject.my_bg_texture:SetVertexColor (1, 1, 1, .5)
			if (last_pressed ~= self.MyObject) then
				self.MyObject.textcolor = textcolor
			else
				self.MyObject.textcolor = selected_textcolor
			end
			GameCooltip:Hide()
		end
		local button_mouse_up = function (button)
			button = button.MyObject
			if (last_pressed ~= button) then
				button.func (button.param1, button.param2, button)
				last_pressed.widget.text:SetPoint ("left", last_pressed.widget, "left", 2, 0)
				selected_texture:SetPoint ("left", button, "left", 0, -1)
				last_pressed.textcolor = textcolor
				last_pressed = button
			end
			return true
		end
		
		--[=[
		--> gradient
		local blackdiv = window:CreateTexture (nil, "artwork")
		blackdiv:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
		blackdiv:SetVertexColor (0, 0, 0)
		blackdiv:SetAlpha (0.7)
		blackdiv:SetPoint ("topleft", window.frame, "topleft", 0, 0)
		blackdiv:SetPoint ("bottomleft", window.frame, "bottomleft", 0, 0)
		blackdiv:SetWidth (200)
		--]=]
		
		--move buttons creation to loading process
		function window:create_left_menu()
			for index, menulist in ipairs (menus) do 
				
				anchors [index]:SetPoint (10, y)
				local amount = #menulist
				
				y = y - 37
				
				for i = 1, amount do 
				
					--local texture = g:NewImage (menu_frame, [[Interface\ARCHEOLOGY\ArchaeologyParts]], 130, 14, nil, nil, nil, "$parentButton_" .. index .. "_" .. i .. "_texture")
					local texture = g:NewImage (menu_frame, [[Interface\Scenarios\ScenarioIcon-Combat]], 10, 10, nil, nil, nil, "$parentButton_" .. index .. "_" .. i .. "_texture")
					texture:SetTexCoord (0.23, 0.87, 0.15, 0.73)
					texture:SetPoint (24, y-5)
					texture:SetVertexColor (1, 1, 1, .5)
					--texture:Hide()

					local button = g:NewButton (menu_frame, _, "$parentButton_" .. index .. "_" .. i, nil, 150, 18, select_options, menus_settings [true_index], true_index, "", menus [index] [i])
					button:SetPoint (40, y)
					button.textalign = "<"
					button.textcolor = textcolor
					button.textsize = 11
					button.my_bg_texture = texture
					button.menu_index = menus_settings [true_index]
					tinsert (all_buttons, button)
					y = y - 16
					
					button:SetHook ("OnEnter", button_onenter)
					button:SetHook ("OnLeave", button_onleave)
					button:SetHook ("OnMouseUp", button_mouse_up)
					
					if (true_index == 1) then
						selected_texture:SetPoint ("left", button, "left", 0, -1)
					end
					
					true_index = true_index + 1
				
				end
				
				y = y - 10
				
			end
		end

		window.options = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
			[6] = {},
			[7] = {},
			[8] = {},
			[9] = {},
			[10] = {},
			[11] = {},
			[12] = {},
			[13] = {}, --profiles
			[14] = {}, --attribute text
			[15] = {}, --spellcustom
			[16] = {}, --charts data
			[17] = {}, --instance settings
			[18] = {}, --miscellaneous settings
			[19] = {}, --data feed widgets
			[20] = {}, --tooltips
		} --> vai armazenar os frames das op��es
		
		
		function window:create_box_no_scroll (n)
			local container = CreateFrame ("Frame", "DetailsOptionsWindow" .. n, window.widget)

			container:SetScript ("OnMouseDown", function()
				if (not window.widget.isMoving) then
					window.widget:StartMoving()
					window.widget.isMoving = true
				end
			end)
			container:SetScript ("OnMouseUp", function (self, button)
				if (window.widget.isMoving) then
					window.widget:StopMovingOrSizing()
					window.widget.isMoving = false
				end
				if (button == "RightButton")then
					DetailsOptionsWindow:Hide()
				end
			end)
			
			container:SetBackdrop({
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})
			container:SetBackdropBorderColor (0, 0, 0, 0)
			container:SetBackdropColor (0, 0, 0, 0)
			
			container:SetWidth (663)
			container:SetHeight (500)
			container:SetPoint ("TOPLEFT", window.widget, "TOPLEFT", 198, -88)
			
			g:NewScrollBar (container, container, 8, -10)
			container.slider:Altura (449)
			container.slider:cimaPoint (0, 1)
			container.slider:baixoPoint (0, -3)
			container.wheel_jump = 80
			
			container.slider:Disable()
			container.baixo:Disable()
			container.cima:Disable()
			container:EnableMouseWheel (false)
			
			return container
		end
		
		
		function window:create_box (n)
			local container_window = CreateFrame ("ScrollFrame", "Details_Options_ContainerScroll" .. n, window.widget)
			local container_slave = CreateFrame ("Frame", "DetailsOptionsWindow" .. n, container_window)

			container_slave:SetScript ("OnMouseDown", function()
				if (not window.widget.isMoving) then
					window.widget:StartMoving()
					window.widget.isMoving = true
				end
			end)
			container_slave:SetScript ("OnMouseUp", function (self, button)
				if (window.widget.isMoving) then
					window.widget:StopMovingOrSizing()
					window.widget.isMoving = false
				end
				if (button == "RightButton")then
					DetailsOptionsWindow:Hide()
				end
			end)
			
			container_window:SetBackdrop({
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})		
			container_window:SetBackdropBorderColor (0, 0, 0, 0)
			container_window:SetBackdropColor (0, 0, 0, 0)
			
			container_slave:SetBackdrop({
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})		
			container_slave:SetBackdropColor (0, 0, 0, 0)

			container_slave:SetAllPoints (container_window)
			container_slave:SetWidth (480)
			container_slave:SetHeight (700)
			container_slave:EnableMouse (true)
			container_slave:SetResizable (false)
			container_slave:SetMovable (true)
			
			container_window:SetWidth (663)
			container_window:SetHeight (470)
			container_window:SetScrollChild (container_slave)
			container_window:SetPoint ("TOPLEFT", window.widget, "TOPLEFT", 198, -88)

			g:NewScrollBar (container_window, container_slave, 8, -10)
			container_window.slider:Altura (449)
			container_window.slider:cimaPoint (20, 1)
			container_window.slider:baixoPoint (20, -3)
			container_window.wheel_jump = 80
			
			container_window.ultimo = 0
			container_window.gump = container_slave
			container_window.container_slave = container_slave
			
			return container_window
		end

		table.insert (window.options [1], window:create_box_no_scroll (1))
		table.insert (window.options [2], window:create_box_no_scroll (2))
		table.insert (window.options [3], window:create_box_no_scroll (3))
		table.insert (window.options [4], window:create_box_no_scroll (4))
		table.insert (window.options [5], window:create_box_no_scroll (5))
		table.insert (window.options [6], window:create_box_no_scroll (6))
		table.insert (window.options [7], window:create_box_no_scroll (7))
		table.insert (window.options [8], window:create_box_no_scroll (8))
		table.insert (window.options [9], window:create_box_no_scroll (9))
		table.insert (window.options [10], window:create_box_no_scroll (10))
		table.insert (window.options [11], window:create_box_no_scroll (11))
		table.insert (window.options [12], window:create_box (12))
		table.insert (window.options [13], window:create_box_no_scroll (13))
		table.insert (window.options [14], window:create_box_no_scroll (14))
		table.insert (window.options [15], window:create_box_no_scroll (15))
		table.insert (window.options [16], window:create_box_no_scroll (16))
		table.insert (window.options [17], window:create_box_no_scroll (17))
		table.insert (window.options [18], window:create_box_no_scroll (18))
		table.insert (window.options [19], window:create_box_no_scroll (19))
		table.insert (window.options [20], window:create_box_no_scroll (20))

		function window:hide_all_options()
			for _, frame in ipairs (window.options) do 
				for _, widget in ipairs (frame) do 
					widget:Hide()
				end
			end
		end
		
		function window:hide_options (options)
			for _, widget in ipairs (window.options [options]) do 
				widget:Hide()
			end
		end

		function window:un_hide_options (options)
			for _, widget in ipairs (window.options [options]) do 
				widget:Show()
			end
		end
		
		--local yellow_point = window:CreateTexture (nil, "overlay")
		--yellow_point:SetSize (16, 16)
		--yellow_point:SetTexture ([[Interface\QUESTFRAME\UI-Quest-BulletPoint]])
		
		local background_on_enter = function (self)
			if (self.background_frame) then
				self = self.background_frame
			end
			
			if (self.parent and self.parent.info) then
				info_text.active = true
				info_text.text = self.parent.info
			end
			
			self.label:SetTextColor (1, .8, 0)
			
			--self:SetBackdrop ({edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 8,
			--insets = {left = 1, right = 1, top = 0, bottom = 1},})
			
			--yellow_point:Show()
			--yellow_point:SetPoint ("right", self, "left", 5, -1)
		end
		local background_on_leave = function (self)
			if (self.background_frame) then
				self = self.background_frame
			end
			--self:SetBackdropColor (0, 0, 0, 0)
			if (info_text.active) then
				info_text.active = false
				--info_text.text = ""
			end
			
			self.label:SetTextColor (1, 1, 1)
			
			--self:SetBackdrop (nil)
			
			--yellow_point:ClearAllPoints()
			--yellow_point:Hide()
		end
		
		local background_on_mouse_down = function (self)
			if (not window.widget.isMoving) then
				window.widget:StartMoving()
				window.widget.isMoving = true
			end
		end
		
		local background_on_mouse_up = function (self, button)
			if (window.widget.isMoving) then
				window.widget:StopMovingOrSizing()
				window.widget.isMoving = false
			end
			if (button == "RightButton")then
				DetailsOptionsWindow:Hide()
			end
		end
		
		function window:create_line_background (frameX, label, parent)
			local f = CreateFrame ("frame", nil, frameX)
			f:SetPoint ("left", label.widget or label, "left", -2, 0)
			f:SetSize (260, 16)
			f:SetScript ("OnEnter", background_on_enter)
			f:SetScript ("OnLeave", background_on_leave)
			--f:SetScript ("OnMouseDown", background_on_mouse_down)
			--f:SetScript ("OnMouseUp", background_on_mouse_up)
			f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})		
			f:SetBackdropColor (0, 0, 0, 0)
			f.parent = parent
			f.label = label
			if (parent.widget) then
				parent.widget.background_frame = f
			else
				parent.background_frame = f
			end
			
			if (label:GetObjectType() == "FontString") then
				local t = frameX:CreateTexture (nil, "artwork")
				t:SetPoint ("left", label.widget or label, "left")
				t:SetSize (label:GetStringWidth(), 12)
				t:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
				t:SetDesaturated (true)
				t:SetAlpha (.5)
			end
			
			return f
		end
		
		function window:CreateLineBackground (frame, widget_name, label_name, desc_loc)
			frame [widget_name].info = desc_loc
			local f = window:create_line_background (frame, frame [label_name], frame [widget_name])
			frame [widget_name]:SetHook ("OnEnter", background_on_enter)
			frame [widget_name]:SetHook ("OnLeave", background_on_leave)
			return f
		end
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		local background_on_enter2 = function (self)
			if (self.background_frame) then
				self = self.background_frame
			end

			if (self.is_button1) then
				self.label:SetTextColor (self.is_button1)
			else
				self.label:SetTextColor (1, .8, 0)
			end
			
			if (self.have_icon) then
				self.have_icon:SetBlendMode ("ADD")
			end
			
			if (self.MyObject and self.MyObject.have_icon) then
				self.MyObject.have_icon:SetBlendMode ("ADD")
			end
			
			if (self.parent and self.parent.info) then
				--GameCooltip:Preset (2)
				GameCooltip:Preset (2)
				GameCooltip:AddLine (self.parent.info)
				GameCooltip:ShowCooltip (self, "tooltip")
				return true
			end
			
		end
		
		local background_on_leave2 = function (self)
			if (self.background_frame) then
				self = self.background_frame
			end
			
			if (self.have_icon) then
				self.have_icon:SetBlendMode ("BLEND")
			end
			if (self.MyObject and self.MyObject.have_icon) then
				self.MyObject.have_icon:SetBlendMode ("BLEND")
			end
			
			GameCooltip:Hide()

			if (self.is_button2) then
				self.label:SetTextColor (self.is_button2)
			else
				self.label:SetTextColor (1, 1, 1)
			end
		end
		
		function window:create_line_background2 (frameX, label, parent, icon, is_button1, is_button2)
			local f = CreateFrame ("frame", nil, frameX)
			f:SetPoint ("left", label.widget or label, "left", -2, 0)
			f:SetSize (260, 16)
			f.is_button1 = is_button1
			f.is_button2 = is_button2
			f:SetScript ("OnEnter", background_on_enter2)
			f:SetScript ("OnLeave", background_on_leave2)
			--f:SetScript ("OnMouseDown", background_on_mouse_down)
			--f:SetScript ("OnMouseUp", background_on_mouse_up)
			f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})		
			f:SetBackdropColor (0, 0, 0, 0)
			f.parent = parent
			f.label = label
			f.have_icon = icon
			if (parent.widget) then
				parent.widget.background_frame = f
			else
				parent.background_frame = f
			end
			
			if (label:GetObjectType() == "FontString") then
				local t = frameX:CreateTexture (nil, "artwork")
				t:SetPoint ("left", label.widget or label, "left")
				t:SetSize (label:GetStringWidth(), 12)
				t:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
				t:SetDesaturated (true)
				t:SetAlpha (.5)
			end
			
			return f
		end
		
		function window:CreateLineBackground2 (frame, widget_name, label_name, desc_loc, icon, is_button1, is_button2)
			
			local label
			if (type (label_name) == "table") then
				label = label_name
			else
				label = frame [label_name]
			end
			if (label:GetObjectType() == "FontString") then
				if (label:GetStringWidth() > 200) then
					_detalhes:SetFontSize (label, 10)
				elseif (label:GetStringWidth() > 150) then
					_detalhes:SetFontSize (label, 11)
				end
			end
			
			if (type (widget_name) == "table") then
				widget_name.info = desc_loc
				widget_name.have_tooltip = desc_loc
				widget_name.have_icon = icon
				local f = window:create_line_background2 (frame, label_name, widget_name, icon, is_button1, is_button2)
				if (widget_name.SetHook) then
					widget_name:SetHook ("OnEnter", background_on_enter2)
					widget_name:SetHook ("OnLeave", background_on_leave2)
				else
					widget_name:SetScript ("OnEnter", background_on_enter2)
					widget_name:SetScript ("OnLeave", background_on_leave2)
				end
				return f
			end
		
			frame [widget_name].info = desc_loc
			frame [widget_name].have_tooltip = desc_loc
			frame [widget_name].have_icon = icon
			local f = window:create_line_background2 (frame, frame [label_name], frame [widget_name], icon, is_button1, is_button2)
			frame [widget_name]:SetHook ("OnEnter", background_on_enter2)
			frame [widget_name]:SetHook ("OnLeave", background_on_leave2)
			f.is_button1 = is_button1
			f.is_button2 = is_button2
			frame [widget_name].is_button1 = is_button1
			frame [widget_name].is_button2 = is_button2
			return f
		end
		
		select_options (1)
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		window.title_y_pos = -30
		window.title_y_pos2 = -50
		
		window.left_start_at = 30
		window.right_start_at = 390
		window.top_start_at = -90
		
		window.buttons_width = 160
		window.buttons_height = 18
		
		function window:arrange_menu (frame, t, x, y_start)		
			local y = y_start
		
			--table.sort (t, function (a, b) return a[2] < b[2] end)
		
			for index, _table in ipairs (t) do
				local widget = _table [1]
				local istitle = _table [3]

				if (type (istitle) == "boolean" and istitle and y ~= y_start) then
					y = y - 10
				elseif (type (istitle) == "boolean" and not istitle and y ~= y_start) then
					y = y + 5 
				end

				if (type (widget) == "string") then
					widget = frame [widget]
				end
				widget:SetPoint (x, y)
				y = y - 25
			end
		end

-------------------------------------------------------------------------------------------------------------------	
	--> helps tips on first run ~tutorial
		if (not _detalhes:GetTutorialCVar ("OPTIONS_PANEL_OPENED")) then
			_detalhes:SetTutorialCVar ("OPTIONS_PANEL_OPENED", true)
			
			local create_test_bars = CreateFrame ("frame", "DetailsOptionsPanelPopUp1", DetailsOptionsWindow, "DetailsHelpBoxTemplate")
			create_test_bars.ArrowDOWN:Show()
			create_test_bars.ArrowGlowDOWN:Show()
			create_test_bars.Text:SetText (Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL4"])
			create_test_bars:SetPoint ("top", fillbars.widget, "bottom", 0, -30)
			create_test_bars:Show()
			-- 
			local group_edit = CreateFrame ("frame", "DetailsOptionsPanelPopUp1", DetailsOptionsWindow, "DetailsHelpBoxTemplate")
			group_edit.ArrowDOWN:Show()
			group_edit.ArrowGlowDOWN:Show()
			group_edit.Text:SetText (Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL5"])
			group_edit:SetPoint ("top", group_editing, "bottom", 0, -30)
			group_edit:Show()
			-- 
			local select_window = CreateFrame ("frame", "DetailsOptionsPanelPopUp1", DetailsOptionsWindow, "DetailsHelpBoxTemplate")
			select_window.ArrowDOWN:Show()
			select_window.ArrowGlowDOWN:Show()
			select_window.Text:SetText (Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL6"])
			select_window:SetPoint ("top", instances.widget, "bottom", 0, -30)
			select_window:Show()
			
			window.help_popups = {create_test_bars, group_edit, select_window}
			
		end
	
	
	--SKINS ~skins ~elvui
		function window:UseElvUISkin()
		
			local window_widget = window.widget
		
			--> title bar
			local titlebar = CreateFrame ("frame", window:GetName() .. "OptionsTitleBar", window_widget)
			titlebar:SetPoint ("topleft", window_widget, "topleft", 2, -3)
			titlebar:SetPoint ("topright", window_widget, "topright", -2, -3)
			titlebar:SetHeight (20)
			titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar:SetBackdropColor (.5, .5, .5, 1)
			titlebar:SetBackdropBorderColor (0, 0, 0, 1)
		
			--> move the title text to titlebar
			title:ClearAllPoints()
			title:SetParent (titlebar)
			title:SetPoint ("center", titlebar, "center")
			--title:SetPoint ("top", titlebar, "top", 0, -6)
		
			--> move the close button to titlebar
			close_button:SetWidth (20)
			close_button:SetHeight (20)
			close_button:SetPoint ("TOPRIGHT", window_widget, "TOPRIGHT", 0, -3)
			close_button:Show()
			close_button:GetNormalTexture():SetDesaturated (true)
		
			--> create a new background texture
			--background:SetTexture ([[Interface\AddOns\Details\images\background]])
			--background:SetVertexColor (0.27, 0.27, 0.27, 0.7)
			window:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
			window:SetBackdropColor (1, 1, 1, 1)
			window:SetBackdropBorderColor (0, 0, 0, 1)
			
			--> change the icon to a transparent one
			window_icon:SetTexCoord (740/1024, 810/1024, 660/1024, 740/1024)
			window_icon:SetSize (70, 80)
			window_icon:SetParent (titlebar)
			window_icon:SetPoint (12, -12)
			window_icon:Hide()
			
			--> hide the dog and other stuff
			bigdog:Hide()
			window.descAnchorTopLeftImage:Hide()
			window.descAnchorBottomLeftImage:Hide()
			window.descAnchorTopRightImage:Hide()
			
			--> set the point of the editing label
			editing:SetPoint ("topright", window, "topright", -12, -62)
			editing:SetPoint ("topright", window, "topright", -30, -90)
			editing:Hide()
			
			--> instance selection dropdown
			instances:SetPoint ("bottomright", window, "bottomright", -12, 16)
			instances:SetTemplate (options_dropdown_template)
			
			--> buttons:
			
			--> location
			fillbars:SetPoint ("bottomleft", window.widget, "bottomleft", 17, 16)
			fillbars:SetTemplate (options_button_template)
			fillbars:SetSize(120, 20)
			changelog:SetTemplate (options_button_template)
			changelog:SetSize(120, 20)
			feedback_button:SetTemplate (options_button_template)
			feedback_button:SetSize(120, 20)
			
			feedback_button.textsize = 10
			changelog.textsize = 10
			fillbars.textsize = 10
--			history_button.textsize = 10
--			forge_button.textsize = 10
			
			fillbars:SetIcon ("Interface\\AddOns\\Details\\images\\icons", nil, nil, nil, {323/512, 365/512, 42/512, 78/512}, {1, 1, 1, 0.6}, 4, 2)
			changelog:SetIcon ("Interface\\AddOns\\Details\\images\\icons", nil, nil, nil, {367/512, 399/512, 43/512, 76/512}, {1, 1, 1, 0.8}, 4, 2)
			feedback_button:SetIcon ("Interface\\FriendsFrame\\UI-Toast-BroadcastIcon", nil, nil, nil, {4/32, 27/32, 5/32, 25/32}, {1, 1, 1, 0.8}, 4, 2)
			
			changelog_image:Hide()
			fillbars_image:Hide()
			feedback_image:Hide()

			DetailsOptionsWindowGroupEditingText:ClearAllPoints()
			DetailsOptionsWindowGroupEditingText:SetPoint ("bottomright", instances.widget, "topright", 0, 2)
			
			_detalhes:SetFontSize (DetailsOptionsWindowGroupEditingText, 10)
			instances_string.textsize = 10
			instances_string:SetPoint ("right", instances, "left", -2, 0)
			--forge_button.textsize = 10
			
			--> menus height
			
			window.title_y_pos = -8
			window.title_y_pos2 = -28
			window.top_start_at = -90
			
			local YMod = 45
			local XMod = 6
			
			menu_frame:SetPoint ("TopLeft", window.widget, "TopLeft", -6, -90 + YMod)
			
			YMod = 42
			
			--> modify the scrollbars
			for i, container in ipairs (window.options) do
				for hash, frame in pairs (container) do
					if (frame:GetName():find ("DetailsOptionsWindow") or frame:GetName():find ("ContainerScroll12")) then
					
						frame:SetPoint ("TOPLEFT", window.widget, "TOPLEFT", 198 + XMod, -88 + YMod)

						local up = frame.cima
						local down = frame.baixo
						local slider = frame.slider
						
						slider:SetPoint ("TOPLEFT", frame, "TOPRIGHT", 30, -20)
						slider:Altura (429)
						
						up:SetNormalTexture ([[Interface\Buttons\Arrow-Up-Up]])
						up:SetPushedTexture ([[Interface\Buttons\Arrow-Up-Down]])
						up:SetDisabledTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
						up:GetNormalTexture():ClearAllPoints()
						up:GetPushedTexture():ClearAllPoints()
						up:GetDisabledTexture():ClearAllPoints()
						up:GetNormalTexture():SetPoint ("center", up, "center", 1, 1)
						up:GetPushedTexture():SetPoint ("center", up, "center", 1, 1)
						up:GetDisabledTexture():SetPoint ("center", up, "center", 1, 1)
						up:SetSize (16, 16)
						up:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
						up:SetBackdropColor (0, 0, 0, 0.3)
						up:SetBackdropBorderColor (0, 0, 0, 1)
						
						down:SetNormalTexture ([[Interface\Buttons\Arrow-Down-Up]])
						down:SetPushedTexture ([[Interface\Buttons\Arrow-Down-Down]])
						down:SetDisabledTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
						down:GetNormalTexture():ClearAllPoints()
						down:GetPushedTexture():ClearAllPoints()
						down:GetDisabledTexture():ClearAllPoints()
						down:GetNormalTexture():SetPoint ("center", down, "center", 1, -5)
						down:GetPushedTexture():SetPoint ("center", down, "center", 1, -5)
						down:GetDisabledTexture():SetPoint ("center", down, "center", 1, -5)
						down:SetSize (16, 16)
						down:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
						down:SetBackdropColor (0, 0, 0, 0.35)
						down:SetBackdropBorderColor (0, 0, 0, 1)
					
						slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
						slider:SetBackdropColor (0, 0, 0, 0.35)
						slider:SetBackdropBorderColor (0, 0, 0, 1)
					
						slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
						slider:SetBackdropColor (0, 0, 0, 0.35)
						slider:SetBackdropBorderColor (0, 0, 0, 1)

						slider:cimaPoint (0, 13)
						slider:baixoPoint (0, -13)
						slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
						slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
						slider.thumb:SetSize (12, 12)
						slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)
					end
				end
			end			
		
			window.using_skin = 2
		end
		
		if (_detalhes.player_details_window.skin == "ElvUI") then
			window:UseElvUISkin()
		end
		
		--> is the default one, doesn't need to change anything
		function window:UseClassicSkin()
			window.using_skin = 1
		end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - Tooltips ~20
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame20()

	local frame20 = window.options [20][1]

		local titulo_tooltips = g:NewLabel (frame20, _, "$parentTituloTooltipsText", "tooltipsTituloLabel", Loc ["STRING_OPTIONS_TOOLTIPS_TITLE"], "GameFontNormal", 16)
		local titulo_tooltips_desc = g:NewLabel (frame20, _, "$parentTituloTooltipsText2", "tooltips2TituloLabel", Loc ["STRING_OPTIONS_TOOLTIPS_TITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_tooltips_desc.width = 350
		titulo_tooltips_desc.height = 20
		
		-- text color
			-- texts anchors
			g:NewLabel (frame20, _, "$parentTooltipTextColorLeftLabel", "TooltipTextColorLeftLabel", Loc ["STRING_LEFT"], "GameFontHighlightLeft")
			g:NewLabel (frame20, _, "$parentTooltipTextColorRightLabel", "TooltipTextColorRightLabel", Loc ["STRING_RIGHT"], "GameFontHighlightLeft")
			g:NewLabel (frame20, _, "$parentTooltipTextColorAnchorLabel", "TooltipTextColorAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHORCOLOR"], "GameFontHighlightLeft")
			-- left color pick
			local tooltip_text_color_callback = function (button, r, g, b, a)
				local c = _detalhes.tooltip.fontcolor
				c[1], c[2], c[3], c[4] = r, g, b, a
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewColorPickButton (frame20, "$parentTooltipTextColorPick", "TooltipTextColorPick", tooltip_text_color_callback, nil, options_button_template)
			-- right color pick
			local tooltip_text_color_callback_right = function (button, r, g, b, a)
				local c = _detalhes.tooltip.fontcolor_right
				c[1], c[2], c[3], c[4] = r, g, b, a
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewColorPickButton (frame20, "$parentTooltipTextColorPickRight", "TooltipTextColorPickRight", tooltip_text_color_callback_right, nil, options_button_template)
			-- anchor color pick
			local tooltip_text_color_callback_anchor = function (button, r, g, b, a)
				local c = _detalhes.tooltip.header_text_color
				c[1], c[2], c[3], c[4] = r, g, b, a
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewColorPickButton (frame20, "$parentTooltipTextColorPickAnchor", "TooltipTextColorPickAnchor", tooltip_text_color_callback_anchor, nil, options_button_template)
			-- text label
			g:NewLabel (frame20, _, "$parentTooltipTextColorLabel", "TooltipTextColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTCOLOR"], "GameFontHighlightLeft")
			frame20.TooltipTextColorPick:SetPoint ("left", frame20.TooltipTextColorLabel, "right", 2, 0)
			frame20.TooltipTextColorLeftLabel:SetPoint ("left", frame20.TooltipTextColorPick, "right", 2, 0)
			frame20.TooltipTextColorPickRight:SetPoint ("left", frame20.TooltipTextColorLeftLabel, "right", 6, 0)
			frame20.TooltipTextColorRightLabel:SetPoint ("left", frame20.TooltipTextColorPickRight, "right", 2, 0)
			frame20.TooltipTextColorPickAnchor:SetPoint ("left", frame20.TooltipTextColorRightLabel, "right", 6, 0)
			frame20.TooltipTextColorAnchorLabel:SetPoint ("left", frame20.TooltipTextColorPickAnchor, "right", 2, 0)
			
			window:CreateLineBackground2 (frame20, "TooltipTextColorPick", "TooltipTextColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"])
			window:CreateLineBackground2 (frame20, "TooltipTextColorPickRight", "TooltipTextColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"])
			window:CreateLineBackground2 (frame20, "TooltipTextColorPickAnchor", "TooltipTextColorAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"])
		
		-- text size
		g:NewLabel (frame20, _, "$parentTooltipTextSizeLabel", "TooltipTextSizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame20, _, "$parentTooltipTextSizeSlider", "TooltipTextSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 5, 32, 1, tonumber (_detalhes.tooltip.fontsize), nil, nil, nil, options_slider_template)
		--config_slider (s)
	
		frame20.TooltipTextSizeSlider:SetPoint ("left", frame20.TooltipTextSizeLabel, "right", 2)
		frame20.TooltipTextSizeSlider:SetHook ("OnValueChange", function (self, _, amount)
			_detalhes.tooltip.fontsize = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		window:CreateLineBackground2 (frame20, "TooltipTextSizeSlider", "TooltipTextSizeLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTSIZE_DESC"])
		
		-- text face
		local on_select_tooltip_font = function (self, _, fontName)
			_detalhes.tooltip.fontface = fontName
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		--local icon, texcoord = [[Interface\AddOns\Details\images\icons]], {479/512, 506/512, 186/512, 221/512}
		
		local build_tooltip_menu = function() 
			local fonts = {}
			for name, fontPath in pairs (SharedMedia:HashTable ("font")) do 
			
				fonts [#fonts+1] = {value = name, icon = font_select_icon, texcoord = font_select_texcoord, label = name, onclick = on_select_tooltip_font, font = fontPath, descfont = name, desc = "Our thoughts strayed constantly\nAnd without boundary\nThe ringing of the division bell had began."}
			end
			table.sort (fonts, function (t1, t2) return t1.label < t2.label end)
			return fonts 
		end

		g:NewLabel (frame20, _, "$parentTooltipFontLabel", "TooltipFontLabel", Loc ["STRING_OPTIONS_TEXT_FONT"] , "GameFontHighlightLeft")
		local d = g:NewDropDown (frame20, _, "$parentTooltipFontDropdown", "TooltipFontDropdown", DROPDOWN_WIDTH, dropdown_height, build_tooltip_menu, _detalhes.tooltip.fontface, options_dropdown_template)
		
		frame20.TooltipFontDropdown:SetPoint ("left", frame20.TooltipFontLabel, "right", 2)
		
		window:CreateLineBackground2 (frame20, "TooltipFontDropdown", "TooltipFontLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTFACE_DESC"])
		
		-- text shadow
		g:NewLabel (frame20, _, "$parentTooltipShadowLabel", "TooltipShadowLabel", Loc ["STRING_OPTIONS_TEXT_LOUTILINE"], "GameFontHighlightLeft")
		g:NewSwitch (frame20, _, "$parentTooltipShadowSwitch", "TooltipShadowSwitch", 60, 20, nil, nil, _detalhes.tooltip.fontshadow, nil, nil, nil, nil, options_switch_template)
		frame20.TooltipShadowSwitch:SetPoint ("left", frame20.TooltipShadowLabel, "right", 2)
		frame20.TooltipShadowSwitch:SetAsCheckBox()
		frame20.TooltipShadowSwitch.OnSwitch = function (self, _, value)
			_detalhes.tooltip.fontshadow = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame20, "TooltipShadowSwitch", "TooltipShadowLabel", Loc ["STRING_OPTIONS_TOOLTIPS_FONTSHADOW_DESC"])
		
		-- background color
		local tooltip_background_color_callback = function (button, r, g, b, a)
			_detalhes.tooltip.background = {r, g, b, a}
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame20, "$parentTooltipBackgroundColorPick", "TooltipBackgroundColorPick", tooltip_background_color_callback, nil, options_button_template)
		g:NewLabel (frame20, _, "$parentTooltipBackgroundColorLabel", "TooltipBackgroundColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"], "GameFontHighlightLeft")
		frame20.TooltipBackgroundColorPick:SetPoint ("left", frame20.TooltipBackgroundColorLabel, "right", 2, 0)
		window:CreateLineBackground2 (frame20, "TooltipBackgroundColorPick", "TooltipBackgroundColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR_DESC"])
		
		-- abbreviation method
		g:NewLabel (frame20, _, "$parentTooltipDpsAbbreviateLabel", "TooltipdpsAbbreviateLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ABBREVIATION"], "GameFontHighlightLeft")
		--
		local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
			_detalhes.tooltip.abbreviation = abbreviationtype
			
			_detalhes.atributo_damage:UpdateSelectedToKFunction()
			_detalhes.atributo_heal:UpdateSelectedToKFunction()
			_detalhes.atributo_energy:UpdateSelectedToKFunction()
			_detalhes.atributo_misc:UpdateSelectedToKFunction()
			_detalhes.atributo_custom:UpdateSelectedToKFunction()
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local icon = [[Interface\COMMON\mini-hourglass]]
		local iconcolor = {1, 1, 1, .5}
		local iconsize = {14, 14}
		
		local abbreviationOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = "Example: 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = "Example: 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = "Example: 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = "Example: 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = "Example: 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = "Example: 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = "Example: 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = "Example: 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
		}
		local buildAbbreviationMenu = function()
			return abbreviationOptions
		end
		
		local d = g:NewDropDown (frame20, _, "$parentTooltipAbbreviateDropdown", "TooltipdpsAbbreviateDropdown", 160, dropdown_height, buildAbbreviationMenu, _detalhes.tooltip.abbreviation, options_dropdown_template)
		
		frame20.TooltipdpsAbbreviateDropdown:SetPoint ("left", frame20.TooltipdpsAbbreviateLabel, "right", 2, 0)		
		
		window:CreateLineBackground2 (frame20, "TooltipdpsAbbreviateDropdown", "TooltipdpsAbbreviateLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ABBREVIATION_DESC"])
			
		-- maximize
		g:NewLabel (frame20, _, "$parentTooltipMaximizeLabel", "TooltipMaximizeLabel", Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE"], "GameFontHighlightLeft")
		local onSelectMaximize = function (_, _, maximizeType)
			_detalhes.tooltip.maximize_method = maximizeType
			_detalhes.atributo_damage:UpdateSelectedToKFunction()
			_detalhes.atributo_heal:UpdateSelectedToKFunction()
			_detalhes.atributo_energy:UpdateSelectedToKFunction()
			_detalhes.atributo_misc:UpdateSelectedToKFunction()
			_detalhes.atributo_custom:UpdateSelectedToKFunction()
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local icon = [[Interface\Buttons\UI-Panel-BiggerButton-Up]]
		local iconcolor = {1, 1, 1, 1}
		local iconcord = {0.1875, 0.78125+0.109375, 0.78125+0.109375+0.03, 0.21875-0.109375-0.03}
		
		local maximizeOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE1"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
			{value = 2, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE2"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
			{value = 3, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE3"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
			{value = 4, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE4"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
			{value = 5, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE5"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
		}
		local buildMaximizeMenu = function()
			return maximizeOptions
		end
		
		local d = g:NewDropDown (frame20, _, "$parentTooltipMaximizeDropdown", "TooltipMaximizeDropdown", 160, dropdown_height, buildMaximizeMenu, _detalhes.tooltip.maximize_method, options_dropdown_template)

		
		frame20.TooltipMaximizeDropdown:SetPoint ("left", frame20.TooltipMaximizeLabel, "right", 2, 0)		
		
		window:CreateLineBackground2 (frame20, "TooltipMaximizeDropdown", "TooltipMaximizeLabel", Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE_DESC"])
		
		--show amount
		g:NewLabel (frame20, _, "$parentTooltipShowAmountLabel", "TooltipShowAmountLabel", Loc ["STRING_OPTIONS_TOOLTIPS_SHOWAMT"], "GameFontHighlightLeft")
		g:NewSwitch (frame20, _, "$parentTooltipShowAmountSlider", "TooltipShowAmountSlider", 60, 20, _, _, _detalhes.tooltip.show_amount, nil, nil, nil, nil, options_switch_template)
		frame20.TooltipShowAmountSlider:SetPoint ("left", frame20.TooltipShowAmountLabel, "right", 2)
		frame20.TooltipShowAmountSlider:SetAsCheckBox()

		frame20.TooltipShowAmountSlider.OnSwitch = function (self, _, value)
			_detalhes.tooltip.show_amount = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame20, "TooltipShowAmountSlider", "TooltipShowAmountLabel", Loc ["STRING_OPTIONS_TOOLTIPS_SHOWAMT_DESC"])
		
	--> border
		--border anchor
			g:NewLabel (frame20, _, "$parentTooltipsBorderAnchor", "TooltipsBorderAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_BORDER"], "GameFontNormal")
		
		--border texture
			local onSelectTextureBackdrop = function (_, _, textureName)
				_detalhes:SetTooltipBackdrop (textureName)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end

			local iconsize = {16, 16}
			local buildTextureBackdropMenu = function() 
				local textures2 = SharedMedia:HashTable ("border")
				local texTable2 = {}
				for name, texturePath in pairs (textures2) do 
					texTable2 [#texTable2+1] = {value = name, label = name, onclick = onSelectTextureBackdrop, icon = [[Interface\DialogFrame\UI-DialogBox-Corner]], texcoord = {0.09375, 1, 0, 0.78}, iconsize = iconsize}
				end
				table.sort (texTable2, function (t1, t2) return t1.label < t2.label end)
				return texTable2 
			end
			
			g:NewLabel (frame20, _, "$parentBackdropBorderTextureLabel", "BackdropBorderTextureLabel", Loc ["STRING_TEXTURE"], "GameFontHighlightLeft")
			local d = g:NewDropDown (frame20, _, "$parentBackdropBorderTextureDropdown", "BackdropBorderTextureDropdown", DROPDOWN_WIDTH, dropdown_height, buildTextureBackdropMenu, _detalhes.tooltip.border_texture, options_dropdown_template)

			frame20.BackdropBorderTextureDropdown:SetPoint ("left", frame20.BackdropBorderTextureLabel, "right", 2)
			window:CreateLineBackground2 (frame20, "BackdropBorderTextureDropdown", "BackdropBorderTextureLabel", Loc ["STRING_OPTIONS_TOOLTIPS_BORDER_TEXTURE_DESC"])
			
		--border size
			g:NewLabel (frame20, _, "$parentBackdropSizeLabel", "BackdropSizeLabel", Loc ["STRING_OPTIONS_SIZE"], "GameFontHighlightLeft")
			local s = g:NewSlider (frame20, _, "$parentBackdropSizeHeight", "BackdropSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 32, 1, _detalhes.tooltip.border_size, nil, nil, nil, options_slider_template)
			--config_slider (s)

			frame20.BackdropSizeSlider:SetPoint ("left", frame20.BackdropSizeLabel, "right", 2)
			--frame20.BackdropSizeSlider:SetThumbSize (50)
			frame20.BackdropSizeSlider:SetHook ("OnValueChange", function (_, _, amount) 
				_detalhes:SetTooltipBackdrop (nil, amount)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)	
			window:CreateLineBackground2 (frame20, "BackdropSizeSlider", "BackdropSizeLabel", Loc ["STRING_OPTIONS_TOOLTIPS_BORDER_SIZE_DESC"])

		--border color
			local backdropcolor_callback = function (button, r, g, b, a)
				_detalhes:SetTooltipBackdrop (nil, nil, {r, g, b, a})
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewColorPickButton (frame20, "$parentBackdropColorPick", "BackdropColorPick", backdropcolor_callback, nil, options_button_template)
			g:NewLabel (frame20, _, "$parentBackdropColorLabel", "BackdropColorLabel", Loc ["STRING_COLOR"], "GameFontHighlightLeft")
			frame20.BackdropColorPick:SetPoint ("left", frame20.BackdropColorLabel, "right", 2, 0)

			local background = window:CreateLineBackground2 (frame20, "BackdropColorPick", "BackdropColorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_BORDER_COLOR_DESC"])
		
	--> tooltip anchors

		--unlock screen anchor
			g:NewLabel (frame20, _, "$parentUnlockAnchorButtonLabel", "UnlockAnchorButtonLabel", "", "GameFontHighlightLeft")
			
			local unlock_function = function()
				DetailsTooltipAnchor:MoveAnchor()
			end
			local unlock_anchor_button = g:NewButton (frame20, nil, "$parentUnlockAnchorButton", "UnlockAnchorButton", window.buttons_width, 18, unlock_function, nil, nil, nil, Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE"], 1, options_button_template)
			--unlock_anchor_button:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			frame20.UnlockAnchorButton:SetTextColor (button_color_rgb)
		
			frame20.UnlockAnchorButton:SetIcon ([[Interface\COMMON\UI-ModelControlPanel]], nil, nil, nil, {20/64, 34/64, 38/128, 52/128}, nil, 4, 2)

			if (_detalhes.tooltip.anchored_to == 1) then
				unlock_anchor_button:Disable()
			else
				unlock_anchor_button:Enable()
			end
			
			frame20.UnlockAnchorButton:SetPoint ("left", frame20.UnlockAnchorButtonLabel, "right", 0, 0)
			window:CreateLineBackground2 (frame20, "UnlockAnchorButton", "UnlockAnchorButton", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE_DESC"], nil, {1, 0.8, 0}, button_color_rgb)

		--main anchor
			g:NewLabel (frame20, _, "$parentTooltipAnchorLabel", "TooltipAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO"], "GameFontHighlightLeft")
			local onSelectAnchor = function (_, _, selected_anchor)
				_detalhes.tooltip.anchored_to = selected_anchor
				if (selected_anchor == 1) then
					unlock_anchor_button:Disable()
				else
					unlock_anchor_button:Enable()
				end
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local anchorOptions = {
				{value = 1, label = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO1"], onclick = onSelectAnchor, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]]},
				{value = 2, label = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO2"], onclick = onSelectAnchor, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]]},
			}
			local buildAnchorMenu = function()
				return anchorOptions
			end
			
			local d = g:NewDropDown (frame20, _, "$parentTooltipAnchorDropdown", "TooltipAnchorDropdown", 160, dropdown_height, buildAnchorMenu, _detalhes.tooltip.anchored_to, options_dropdown_template)
			
			frame20.TooltipAnchorDropdown:SetPoint ("left", frame20.TooltipAnchorLabel, "right", 2, 0)
			
			window:CreateLineBackground2 (frame20, "TooltipAnchorDropdown", "TooltipAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_DESC"])

			unlock_anchor_button:SetWidth (frame20.TooltipAnchorLabel:GetStringWidth() + 2 + frame20.TooltipAnchorDropdown:GetWidth())
			
		--tooltip side
			g:NewLabel (frame20, _, "$parentTooltipAnchorSideLabel", "TooltipAnchorSideLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH"], "GameFontHighlightLeft")
			local onSelectAnchorPoint = function (_, _, selected_anchor)
				_detalhes.tooltip.anchor_point = selected_anchor
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local anchorPointOptions = {
				{value = "top", label = Loc ["STRING_ANCHOR_TOP"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.8125, 0.1875, 0.875}},
				{value = "bottom", label = Loc ["STRING_ANCHOR_BOTTOM"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.875, 1, 0.1875}},
				{value = "left", label = Loc ["STRING_ANCHOR_LEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0.5, 0, 0, 0.8125}},
				{value = "right", label = Loc ["STRING_ANCHOR_RIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0, 0.5, 0, 0.8125}},
				{value = "topleft", label = Loc ["STRING_ANCHOR_TOPLEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.1875, 0.375}},
				{value = "bottomleft", label = Loc ["STRING_ANCHOR_BOTTOMLEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.375, 0.1875}},
				{value = "topright", label = Loc ["STRING_ANCHOR_TOPRIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.1875, 0.375}},
				{value = "bottomright", label = Loc ["STRING_ANCHOR_BOTTOMRIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.375, 0.1875}},
			}
			
			local buildAnchorPointMenu = function()
				return anchorPointOptions
			end
			
			local d = g:NewDropDown (frame20, _, "$parentTooltipAnchorSideDropdown", "TooltipAnchorSideDropdown", 160, dropdown_height, buildAnchorPointMenu, _detalhes.tooltip.anchor_point, options_dropdown_template)
			
			frame20.TooltipAnchorSideDropdown:SetPoint ("left", frame20.TooltipAnchorSideLabel, "right", 2, 0)		
			
			window:CreateLineBackground2 (frame20, "TooltipAnchorSideDropdown", "TooltipAnchorSideLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH_DESC"])

		--tooltip relative side
			g:NewLabel (frame20, _, "$parentTooltipRelativeSideLabel", "TooltipRelativeSideLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE"], "GameFontHighlightLeft")
			local onSelectAnchorRelative = function (_, _, selected_anchor)
				_detalhes.tooltip.anchor_relative = selected_anchor
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local anchorRelativeOptions = {
				{value = "top", label = Loc ["STRING_ANCHOR_TOP"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.8125, 0.1875, 0.875}},
				{value = "bottom", label = Loc ["STRING_ANCHOR_BOTTOM"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.875, 1, 0.1875}},
				{value = "left", label = Loc ["STRING_ANCHOR_LEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0.5, 0, 0, 0.8125}},
				{value = "right", label = Loc ["STRING_ANCHOR_RIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0, 0.5, 0, 0.8125}},
				{value = "topleft", label = Loc ["STRING_ANCHOR_TOPLEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.1875, 0.375}},
				{value = "bottomleft", label = Loc ["STRING_ANCHOR_BOTTOMLEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.375, 0.1875}},
				{value = "topright", label = Loc ["STRING_ANCHOR_TOPRIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.1875, 0.375}},
				{value = "bottomright", label = Loc ["STRING_ANCHOR_BOTTOMRIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.375, 0.1875}},
			}
			
			local buildAnchorRelativeMenu = function()
				return anchorRelativeOptions
			end
			
			local d = g:NewDropDown (frame20, _, "$parentTooltipRelativeSideDropdown", "TooltipRelativeSideDropdown", 160, dropdown_height, buildAnchorRelativeMenu, _detalhes.tooltip.anchor_relative, options_dropdown_template)

			
			frame20.TooltipRelativeSideDropdown:SetPoint ("left", frame20.TooltipRelativeSideLabel, "right", 2, 0)		
			
			window:CreateLineBackground2 (frame20, "TooltipRelativeSideDropdown", "TooltipRelativeSideLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE_DESC"])

		--tooltip offset
			g:NewLabel (frame20, _, "$parentTooltipOffsetXLabel", "TooltipOffsetXLabel", Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETX"], "GameFontHighlightLeft")
			local s = g:NewSlider (frame20, _, "$parentTooltipOffsetXSlider", "TooltipOffsetXSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -100, 100, 1, tonumber (_detalhes.tooltip.anchor_offset[1]), nil, nil, nil, options_slider_template)
			--config_slider (s)
		
			frame20.TooltipOffsetXSlider:SetPoint ("left", frame20.TooltipOffsetXLabel, "right", 2)
			frame20.TooltipOffsetXSlider:SetHook ("OnValueChange", function (self, _, amount)
				_detalhes.tooltip.anchor_offset[1] = amount
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			window:CreateLineBackground2 (frame20, "TooltipOffsetXSlider", "TooltipOffsetXLabel", Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETX_DESC"])
			
			g:NewLabel (frame20, _, "$parentTooltipOffsetYLabel", "TooltipOffsetYLabel", Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETY"], "GameFontHighlightLeft")
			local s = g:NewSlider (frame20, _, "$parentTooltipOffsetYSlider", "TooltipOffsetYSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -100, 100, 1, tonumber (_detalhes.tooltip.anchor_offset[2]), nil, nil, nil, options_slider_template)
			--config_slider (s)
		
			frame20.TooltipOffsetYSlider:SetPoint ("left", frame20.TooltipOffsetYLabel, "right", 2)
			frame20.TooltipOffsetYSlider:SetHook ("OnValueChange", function (self, _, amount)
				_detalhes.tooltip.anchor_offset[2] = amount
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			window:CreateLineBackground2 (frame20, "TooltipOffsetYSlider", "TooltipOffsetYLabel", Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETY_DESC"])

	--> edit menu background
		local edit_menu_bg_callback = function (width, height, overlayColor, alpha, texCoords)
			_detalhes.tooltip.menus_bg_color[1] = overlayColor[1]
			_detalhes.tooltip.menus_bg_color[2] = overlayColor[2]
			_detalhes.tooltip.menus_bg_color[3] = overlayColor[3]
			_detalhes.tooltip.menus_bg_color[4] = alpha
			_detalhes.tooltip.menus_bg_coords = texCoords
		end
		local edit_menu_bg_func = function()
			g:ImageEditor (edit_menu_bg_callback, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, 250, 300, nil, _detalhes.tooltip.menus_bg_color[4], true)
		end
		local edit_menu_bg = g:NewButton (frame20, nil, "$parentEditMenuBgButton", "EditMenuBgButton", window.buttons_width, 18, edit_menu_bg_func, nil, nil, nil, Loc ["STRING_OPTIONS_TOOLTIPS_MENU_WALLP"], nil, options_button_template)
		--edit_menu_bg:InstallCustomTexture (nil, nil, nil, nil, nil, true)
		edit_menu_bg:SetIcon ([[Interface\CHATFRAME\UI-ChatIcon-Maximize-Down]], 12, 12, nil, {6/32, 23/32, 10/32, 25/32}, nil, 4, 2)
		window:CreateLineBackground2 (frame20, "EditMenuBgButton", "EditMenuBgButton", Loc ["STRING_OPTIONS_TOOLTIPS_MENU_WALLP_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		
	--> disable cooltip wallpaper on submenus
		g:NewLabel (frame20, _, "$parentCopyMainWallpaperLabel", "CopyMainWallpaperLabel", Loc ["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER"], "GameFontHighlightLeft")
		g:NewSwitch (frame20, _, "$parentCopyMainWallpaperSlider", "CopyMainWallpaperSlider", 60, 20, _, _, _detalhes.tooltip.submenu_wallpaper, nil, nil, nil, nil, options_switch_template)
		frame20.CopyMainWallpaperSlider:SetPoint ("left", frame20.CopyMainWallpaperLabel, "right", 2)
		frame20.CopyMainWallpaperSlider:SetAsCheckBox()

		frame20.CopyMainWallpaperSlider.OnSwitch = function (self, _, value)
			_detalhes.tooltip.submenu_wallpaper = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame20, "CopyMainWallpaperSlider", "CopyMainWallpaperLabel", Loc ["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER_DESC"])
		
	--> anchors:
	
		--general anchor
		g:NewLabel (frame20, _, "$parentTooltipsTextsAnchor", "TooltipsTextsAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"], "GameFontNormal")
		g:NewLabel (frame20, _, "$parentTooltipsAnchor", "TooltipsAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIP_ANCHOR"], "GameFontNormal")
		
		g:NewLabel (frame20, _, "$parentTooltipsAnchorPoint", "TooltipsAnchorPointLabel", Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_POINT"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_tooltips:SetPoint (x, window.title_y_pos)
		titulo_tooltips_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"TooltipsTextsAnchorLabel", 1, true},
			{"TooltipShadowLabel", 2},
			{"TooltipTextColorLabel", 3},
			{"TooltipTextSizeLabel", 4},
			{"TooltipFontLabel", 5},
			
			{"TooltipsAnchorLabel", 6, true},
			{"TooltipBackgroundColorLabel", 7},
			{"TooltipShowAmountLabel", 8},
			{"TooltipdpsAbbreviateLabel", 10},
			{"TooltipMaximizeLabel", 9},
			{"CopyMainWallpaperLabel", 10},
			{edit_menu_bg, 11, true},
		}

		window:arrange_menu (frame20, left_side, x, window.top_start_at)
		
		x = window.right_start_at
		
		local right_side = {
			{"TooltipsAnchorPointLabel", 1, true},
			{"TooltipAnchorLabel", 2},
			{"UnlockAnchorButtonLabel", 3, true},
			{"TooltipAnchorSideLabel", 4, true},
			{"TooltipRelativeSideLabel", 5},
			{"TooltipOffsetXLabel", 6, true},
			{"TooltipOffsetYLabel", 7},
			
			{"TooltipsBorderAnchorLabel", 8, true},
			{"BackdropBorderTextureLabel", 9},
			{"BackdropSizeLabel", 10},
			{"BackdropColorLabel", 11},
		}
		
		window:arrange_menu (frame20, right_side, x, window.top_start_at)
		
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - Data Feed Widgets ~19
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame19()
	
	local frame19 = window.options [19][1]

		local titulo_externals = g:NewLabel (frame19, _, "$parentTituloExternalsText", "ExternalsTituloLabel", Loc ["STRING_OPTIONS_EXTERNALS_TITLE"], "GameFontNormal", 16)
		local titulo_externals_desc = g:NewLabel (frame19, _, "$parentTituloExternalsText2", "Externals2TituloLabel", Loc ["STRING_OPTIONS_EXTERNALS_TITLE2"], "GameFontNormal", 10, "white")
		titulo_externals_desc.width = 350
		titulo_externals_desc.height = 20
	
	--> minimap  
		--anchor
		g:NewLabel (frame19, _, "$parentMinimapAnchor", "minimapAnchorLabel", Loc ["STRING_OPTIONS_MINIMAP_ANCHOR"], "GameFontNormal")
		
		--show or hide
			g:NewLabel (frame19, _, "$parentMinimapLabel", "minimapLabel", Loc ["STRING_OPTIONS_MINIMAP"], "GameFontHighlightLeft")
			g:NewSwitch (frame19, _, "$parentMinimapSlider", "minimapSlider", 60, 20, _, _, not _detalhes.minimap.hide, nil, nil, nil, nil, options_switch_template)
			
			frame19.minimapSlider:SetPoint ("left", frame19.minimapLabel, "right", 2, 0)
			frame19.minimapSlider:SetAsCheckBox()
			frame19.minimapSlider.OnSwitch = function (self, _, value)
				_detalhes.minimap.hide = not value
				
				LDBIcon:Refresh ("Details", _detalhes.minimap)
				if (_detalhes.minimap.hide) then
					LDBIcon:Hide ("Details")
				else
					LDBIcon:Show ("Details")
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			window:CreateLineBackground2 (frame19, "minimapSlider", "minimapLabel", Loc ["STRING_OPTIONS_MINIMAP_DESC"])

		--on click action
			do
				g:NewLabel (frame19, _, "$parentMinimapActionLabel", "minimapActionLabel", Loc ["STRING_OPTIONS_MINIMAP_ACTION"], "GameFontHighlightLeft")
				local on_select = function (_, _, option)
					_detalhes.minimap.onclick_what_todo = option
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				local menu = {
						{value = 1, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION1"], onclick = on_select, icon = [[Interface\FriendsFrame\FriendsFrameScrollIcon]]},
						{value = 2, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION2"], onclick = on_select, icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], iconcolor = {1, .8, 0, 1}},
						{value = 3, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION3"], onclick = on_select, icon = [[Interface\Buttons\UI-CheckBox-Up]], texcoord = {0.1, 0.9, 0.1, 0.9}},
					}
				local build_menu = function()
					return menu
				end
				local dropdown = g:NewDropDown (frame19, _, "$parentMinimapActionDropdown", "minimapActionDropdown", 160, dropdown_height, build_menu, _detalhes.minimap.onclick_what_todo, options_dropdown_template)

				
				frame19.minimapActionDropdown:SetPoint ("left", frame19.minimapActionLabel, "right", 2, 0)
				window:CreateLineBackground2 (frame19, "minimapActionDropdown", "minimapActionLabel", Loc ["STRING_OPTIONS_MINIMAP_ACTION_DESC"])
			end
	--> hot corner
	
		--anchor
		g:NewLabel (frame19, _, "$parentHotcornerAnchor", "hotcornerAnchorLabel", Loc ["STRING_OPTIONS_HOTCORNER_ANCHOR"], "GameFontNormal")
		
		--show or hide
			g:NewLabel (frame19, _, "$parentHotcornerLabel", "hotcornerLabel", Loc ["STRING_OPTIONS_HOTCORNER"], "GameFontHighlightLeft")
			g:NewSwitch (frame19, _, "$parentHotcornerSlider", "hotcornerSlider", 60, 20, _, _, not _detalhes.hotcorner_topleft.hide, nil, nil, nil, nil, options_switch_template)
			
			frame19.hotcornerSlider:SetPoint ("left", frame19.hotcornerLabel, "right", 2, 0)
			frame19.hotcornerSlider:SetAsCheckBox()
			frame19.hotcornerSlider.OnSwitch = function (self, _, value)
				_G.HotCorners:HideHotCornerButton ("Details!", "TOPLEFT", not value)
			end
			window:CreateLineBackground2 (frame19, "hotcornerSlider", "hotcornerLabel", Loc ["STRING_OPTIONS_HOTCORNER_DESC"])
			
	--> broker
		--anchor
		g:NewLabel (frame19, _, "$parentHotcornerAnchor", "brokerAnchorLabel", Loc ["STRING_OPTIONS_DATABROKER"], "GameFontNormal")

		--broker text
			g:NewLabel (frame19, _, "$parentBrokerTextLabel", "brokerTextLabel", Loc ["STRING_OPTIONS_DATABROKER_TEXT"], "GameFontHighlightLeft")
			
			local broker_entry = g:NewTextEntry (frame19, _, "$parentBrokerEntry", "BrokerTextEntry", 180, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
			broker_entry:SetPoint ("left", frame19.brokerTextLabel, "right", 2, -1)
			broker_entry.text = _detalhes.data_broker_text

			broker_entry:SetHook ("OnTextChanged", function (self, byUser)
				_detalhes:SetDataBrokerText (broker_entry.text)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			
			window:CreateLineBackground2 (frame19, "BrokerTextEntry", "brokerTextLabel", Loc ["STRING_OPTIONS_DATABROKER_TEXT1_DESC"])
			
			local editor = g:NewButton (broker_entry, _, "$parentOpenEditorButton", "OpenEditorButton", 22, 22, function()
				_detalhes:OpenBrokerTextEditor()
			end)
			editor:SetPoint ("left", broker_entry, "right", 2, 1)
			editor:SetNormalTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
			editor:SetHighlightTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
			editor:SetPushedTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
			editor:GetNormalTexture():SetDesaturated (true)
			editor.tooltip = Loc ["STRING_OPTIONS_OPEN_TEXT_EDITOR"]
			
			local clear = g:NewButton (broker_entry, _, "$parentResetButton", "ResetButton", 20, 20, function()
				broker_entry.text = ""
				_detalhes:BrokerTick()
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			
			clear:SetPoint ("left", editor, "right", 0, 0)
			clear:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
			clear:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
			clear:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
			clear:GetNormalTexture():SetDesaturated (true)
			clear.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
		--number format
		g:NewLabel (frame19, _, "$parentBrokerNumberAbbreviateLabel", "BrokerNumberAbbreviateLabel", Loc ["STRING_OPTIONS_PS_ABBREVIATE"], "GameFontHighlightLeft")
		--
		local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
			_detalhes.minimap.text_format = abbreviationtype
			_detalhes:BrokerTick()
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		local icon = [[Interface\COMMON\mini-hourglass]]
		local iconcolor = {1, 1, 1, .5}
		local iconsize = {14, 14}
		local abbreviationOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = Loc ["STRING_EXAMPLE"] .. ": 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
		}
		local buildAbbreviationMenu = function()
			return abbreviationOptions
		end
		
		local d = g:NewDropDown (frame19, _, "$parentBrokerNumberAbbreviateDropdown", "BrokerNumberAbbreviateDropdown", 160, dropdown_height, buildAbbreviationMenu, _detalhes.minimap.text_format, options_dropdown_template)
		
		frame19.BrokerNumberAbbreviateDropdown:SetPoint ("left", frame19.BrokerNumberAbbreviateLabel, "right", 2, 0)		
		
		window:CreateLineBackground2 (frame19, "BrokerNumberAbbreviateDropdown", "BrokerNumberAbbreviateLabel", Loc ["STRING_OPTIONS_PS_ABBREVIATE_DESC"])

	--> item level tracker
		--anchor
		g:NewLabel (frame19, _, "$parentItemLevelTrackerAnchor", "ItemLevelTrackerAnchorLabel", Loc ["STRING_OPTIONS_ILVL_TRACKER"], "GameFontNormal")
		--switch
		g:NewLabel (frame19, _, "$parentItemLevelLabel", "ItemLevelLabel", Loc ["STRING_OPTIONS_ILVL_TRACKER_TEXT"], "GameFontHighlightLeft")
		g:NewSwitch (frame19, _, "$parentItemLevelSlider", "ItemLevelSlider", 60, 20, _, _, _detalhes.ilevel:IsTrackerEnabled(), nil, nil, nil, nil, options_switch_template)
		
		frame19.ItemLevelSlider:SetPoint ("left", frame19.ItemLevelLabel, "right", 2, 0)
		frame19.ItemLevelSlider:SetAsCheckBox()
		frame19.ItemLevelSlider.OnSwitch = function (self, _, value)
			_detalhes.ilevel:TrackItemLevel (value)
		end
		window:CreateLineBackground2 (frame19, "ItemLevelSlider", "ItemLevelLabel", Loc ["STRING_OPTIONS_ILVL_TRACKER_DESC"])
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> Report
		--heal links
		g:NewLabel (frame19, _, "$parentReportHelpfulLinkLabel", "ReportHelpfulLinkLabel", Loc ["STRING_OPTIONS_REPORT_HEALLINKS"], "GameFontHighlightLeft")
		g:NewSwitch (frame19, _, "$parentReportHelpfulLinkSlider", "ReportHelpfulLinkSlider", 60, 20, _, _, _detalhes.report_heal_links, nil, nil, nil, nil, options_switch_template)

		frame19.ReportHelpfulLinkSlider:SetPoint ("left", frame19.ReportHelpfulLinkLabel, "right", 2)
		frame19.ReportHelpfulLinkSlider:SetAsCheckBox()
		frame19.ReportHelpfulLinkSlider.OnSwitch = function (_, _, value)
			_detalhes.report_heal_links = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame19, "ReportHelpfulLinkSlider", "ReportHelpfulLinkLabel", Loc ["STRING_OPTIONS_REPORT_HEALLINKS_DESC"])
	
		--report format
		g:NewLabel (frame19, _, "$parentReportFormatLabel", "ReportFormatLabel", Loc ["STRING_OPTIONS_REPORT_SCHEMA"], "GameFontHighlightLeft")
		
		local onSelectReportFormatAlpha = function (_, _, value)
			_detalhes.report_schema = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		local coords = {1, 0, 0, 1}
		local ReportFormatOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_REPORT_SCHEMA1"], onclick = onSelectReportFormatAlpha, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Disabled]], texcoord = coords, desc = "1. Jack .. 128.9k (29.9k, 23.33%)"},
			{value = 2, label = Loc ["STRING_OPTIONS_REPORT_SCHEMA2"], onclick = onSelectReportFormatAlpha, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Disabled]], texcoord = coords, desc = "1. Jack .. 23.33% (29.9k, 128.9k)"},
			{value = 3, label = Loc ["STRING_OPTIONS_REPORT_SCHEMA3"], onclick = onSelectReportFormatAlpha, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Disabled]], texcoord = coords, desc = "1. Jack .. 23.33% (128.9k 29.9k)"},
		}
		local BuildReportFormatOptions = function()
			return ReportFormatOptions
		end
		local d = g:NewDropDown (frame19, _, "$parentReportFormatDropdown", "ReportFormatDropdown", 160, dropdown_height, BuildReportFormatOptions, nil, options_dropdown_template)
		
		frame19.ReportFormatDropdown:SetPoint ("left", frame19.ReportFormatLabel, "right", 2, 0)		
		
		window:CreateLineBackground2 (frame19, "ReportFormatDropdown", "ReportFormatLabel", Loc ["STRING_OPTIONS_REPORT_SCHEMA_DESC"])

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	--> anchors:
	
		g:NewLabel (frame19, _, "$parentReportAnchor", "reportAnchorLabel", Loc ["STRING_OPTIONS_REPORT_ANCHOR"], "GameFontNormal")

		local x = window.left_start_at
		
		titulo_externals:SetPoint (x, window.title_y_pos)
		titulo_externals_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"minimapAnchorLabel", 1, true},
			{"minimapLabel", 2},
			{"minimapActionLabel", 3},
			{"hotcornerAnchorLabel", 4, true},
			{"hotcornerLabel", 5},
			{"brokerAnchorLabel", 6, true},
			{"brokerTextLabel", 7},
			{"BrokerNumberAbbreviateLabel", 8},
			{"ItemLevelTrackerAnchorLabel", 9, true},
			{"ItemLevelLabel", 10}
		}
		
		window:arrange_menu (frame19, left_side, x, window.top_start_at)	
		
		local right_side = {
			{"reportAnchorLabel", 1, true},
			{"ReportHelpfulLinkLabel", 2},
			{"ReportFormatLabel", 3},	
		}
		
		window:arrange_menu (frame19, right_side, window.right_start_at, window.top_start_at)		

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - options for broadcasters ~18
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame18()

	local frame18 = window.options [18][1]

		local titulo_misc_settings = g:NewLabel (frame18, _, "$parentTituloMiscSettingsText", "MiscSettingsLabel", Loc ["STRING_OPTIONS_MISCTITLE"], "GameFontNormal", 16)
		local titulo_misc_settings_desc = g:NewLabel (frame18, _, "$parentTituloMiscSettingsText2", "Misc2SettingsLabel", Loc ["STRING_OPTIONS_MISCTITLE2"], "GameFontNormal", 10, "white")
		titulo_misc_settings_desc.width = 350
		titulo_misc_settings_desc.height = 20
	
		--> 
		local button_width = 180
		
		local titleFrame18 = g:NewLabel (frame18, _, "$parentTitleText", "TitleTextLabel", "Streamer Settings", "GameFontNormal", 16)
		local titleFrame18Desc = g:NewLabel (frame18, _, "$parentTitleDescText", "TitleDescTextLabel", "Set of tools for streamers, youtubers and broadcasters in general", "GameFontNormal", 10, "white")
		titleFrame18Desc:SetSize (450, 20)
		
		--fazer os headers com espa�o para images
		--fazer o bot�o para abrir o painel de op�opoes
		
		--> streamer plugin - a.k.a. player spell tracker 
			--> title anchor
			g:NewLabel (frame18, _, "$parentStreamerPluginAnchor", "streamerPluginAnchor", "Streamer Plugin: Action Tracker", "GameFontNormal")
			local streamerTitleDesc = g:NewLabel (frame18, _, "$parentStreamerTitleDescText", "StreamerTitleDescTextLabel", "Show the spells you are casting, allowing the viewer to follow your decision making and learn your rotation.", "GameFontNormal", 10, "white")
			streamerTitleDesc:SetSize (270, 40)
			streamerTitleDesc:SetJustifyV ("top")
			streamerTitleDesc:SetPoint ("topleft", frame18.streamerPluginAnchor, "bottomleft", 0, -4)
			
			local streamerTitleImage = g:CreateImage (frame18, [[Interface\AddOns\Details\images\icons2]], 256, 41, "overlay", {0.5, 1, 0.49, 0.57})
			streamerTitleImage:SetPoint ("topleft", frame18.streamerPluginAnchor, "bottomleft", 0, -40)
			
			--> get the plugin object
			local StreamerPlugin = _detalhes:GetPlugin ("DETAILS_PLUGIN_STREAM_OVERLAY")
			if (StreamerPlugin) then
				--> get the plugin settings table
				local tPluginSettings = _detalhes:GetPluginSavedTable ("DETAILS_PLUGIN_STREAM_OVERLAY")
				if (tPluginSettings) then
					local bIsPluginEnabled = tPluginSettings.enabled
					--> plugin already enabled
					if (bIsPluginEnabled) then
						--> config button
						local configure_streamer_plugin = function()
							StreamerPlugin.OpenOptionsPanel (true)
							C_Timer.After (0.2, function()
								window:Hide()
							end)
						end
						local configurePluginButton = g:NewButton (frame18, _, "$parentConfigureStreamerPluginButton", "configureStreamerPlugin", 100, 20, configure_streamer_plugin, nil, nil, nil, "Action Tracker Options", nil, options_button_template)
						configurePluginButton:SetWidth (button_width)
						configurePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -7)
						
						--> text telling how to disable
						local pluginAlreadyEnabled = g:NewLabel (frame18, _, "$parentStreamerAlreadyEnabledText", "StreamerAlreadyEnabledTextLabel", "Plugin is enabled. You may disable it on Plugin Management section.", "GameFontNormal", 10, "white")
						pluginAlreadyEnabled:SetJustifyV ("top")
						pluginAlreadyEnabled:SetSize (270, 40)
						pluginAlreadyEnabled:SetPoint ("topleft", configurePluginButton, "bottomleft", 0, -7)
					else
						--> plugin isnt enabled, create the enable button
						local enable_streamer_plugin = function()
							tPluginSettings.enabled = true
							StreamerPlugin.__enabled = true
							_detalhes:SendEvent ("PLUGIN_ENABLED", StreamerPlugin)
							
							frame18.enableStreamerPluginButton:Hide()
							
							--> config button
							local configure_streamer_plugin = function()
								StreamerPlugin.OpenOptionsPanel()
							end
							local configurePluginButton = g:NewButton (frame18, _, "$parentConfigureStreamerPluginButton", "configureStreamerPlugin", 100, 20, configure_streamer_plugin, nil, nil, nil, "Action Tracker Options", nil, options_button_template)
							configurePluginButton:SetWidth (button_width)
							configurePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -7)
							
							--> text telling how to disable
							local pluginAlreadyEnabled = g:NewLabel (frame18, _, "$parentStreamerAlreadyEnabledText", "StreamerAlreadyEnabledTextLabel", "Plugin is enabled. You may disable it on Plugin Management section.", "GameFontNormal", 10, "white")
							pluginAlreadyEnabled:SetJustifyV ("top")
							pluginAlreadyEnabled:SetSize (270, 40)
							pluginAlreadyEnabled:SetPoint ("topleft", configurePluginButton, "bottomleft", 0, -7)
						end
						
						local enablePluginButton = g:NewButton (frame18, _, "$parentEnableStreamerPluginButton", "enableStreamerPluginButton", 100, 20, enable_streamer_plugin, nil, nil, nil, "Enable Plugin", nil, options_button_template)
						enablePluginButton:SetWidth (button_width)
						enablePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -5)
					end
				end
			else
				--> plugin is disabled at the addon control panel
				local pluginDisabled = g:NewLabel (frame18, _, "$parentStreamerDisabledText", "StreamerDisabledTextLabel", "Details!: Streamer Plugin is disabled on the AddOns Control Panel.", "GameFontNormal", 10, "red")
				pluginDisabled:SetSize (270, 40)
				pluginDisabled:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -2)
			end
		
		
		--> event tracker
			g:NewLabel (frame18, _, "$parentEventTrackerAnchor", "eventTrackerAnchor", "Event Tracker", "GameFontNormal")
			local eventTrackerTitleDesc = g:NewLabel (frame18, _, "$parentEventTrackerTitleDescText", "EventTrackerTitleDescTextLabel", "Show what's happening near you so the viewer can follow what's going on. Show cooldowns, CC, spell interruption. Useful on any group content.", "GameFontNormal", 10, "white")
			eventTrackerTitleDesc:SetJustifyV ("top")
			eventTrackerTitleDesc:SetSize (270, 40)
			eventTrackerTitleDesc:SetPoint ("topleft", frame18.eventTrackerAnchor, "bottomleft", 0, -4)
			
			local eventTrackerTitleImage = g:CreateImage (frame18, [[Interface\AddOns\Details\images\icons2]], 256, 50, "overlay", {0.5, 1, 134/512, 184/512})
			eventTrackerTitleImage:SetPoint ("topleft", frame18.eventTrackerAnchor, "bottomleft", 0, -40)
			
			--> enable feature checkbox
				g:NewLabel (frame18, _, "$parentEnableEventTrackerLabel", "EventTrackerLabel", "Enable Event Tracker", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentEventTrackerSlider", "EventTrackerSlider", 60, 20, _, _, _detalhes.event_tracker.enabled, nil, nil, nil, nil, options_switch_template)

				frame18.EventTrackerSlider:SetPoint ("left", frame18.EventTrackerLabel, "right", 2)
				frame18.EventTrackerSlider:SetAsCheckBox()
				frame18.EventTrackerSlider.OnSwitch = function (_, _, value)
					_detalhes.event_tracker.enabled = not _detalhes.event_tracker.enabled
					Details:LoadFramesForBroadcastTools()
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "EventTrackerSlider", "EventTrackerLabel", "Enable Event Tracker")
				
				frame18.EventTrackerLabel:SetPoint ("topleft", eventTrackerTitleImage, "bottomleft", 0, -10)
				frame18.EventTrackerSlider:SetPoint ("left", frame18.EventTrackerLabel, "right", 2, 0)
				
			--> configure feature button
				local configure_event_tracker = function()
					_detalhes:OpenEventTrackerOptions (true)
					C_Timer.After (0.2, function()
						window:Hide()
					end)
				end
				local configureEventTrackerButton = g:NewButton (frame18, _, "$parentConfigureEventTrackerButton", "configureEventTracker", 100, 20, configure_event_tracker, nil, nil, nil, "Event Tracker Options", nil, options_button_template)
				configureEventTrackerButton:SetWidth (button_width)
				configureEventTrackerButton:SetPoint ("topleft", frame18.EventTrackerLabel, "bottomleft", 0, -7)


		--> current dps
			g:NewLabel (frame18, _, "$parentCurrentDPSAnchor", "currentDPSAnchor", "The Real Current DPS", "GameFontNormal")
			local currentDPSTitleDesc = g:NewLabel (frame18, _, "$parentCurrentDPSTitleDescText", "CurrentDPSTitleDescTextLabel", "Show a frame with DPS done only in the last 5 seconds. Useful for arena matches and mythic dungeons.", "GameFontNormal", 10, "white")
			currentDPSTitleDesc:SetJustifyV ("top")
			currentDPSTitleDesc:SetSize (270, 40)
			currentDPSTitleDesc:SetPoint ("topleft", frame18.currentDPSAnchor, "bottomleft", 0, -4)
			
			local currentDPSTitleImage = g:CreateImage (frame18, [[Interface\AddOns\Details\images\icons2]], 250, 61, "overlay", {259/512, 509/512, 186/512, 247/512})
			currentDPSTitleImage:SetPoint ("topleft", frame18.currentDPSAnchor, "bottomleft", 0, -40)
			
			--> enable feature checkbox
				g:NewLabel (frame18, _, "$parentEnableCurrentDPSLabel", "CurrentDPSLabel", "Enable The Real Current Dps", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentCurrentDPSSlider", "CurrentDPSSlider", 60, 20, _, _, _detalhes.current_dps_meter.enabled, nil, nil, nil, nil, options_switch_template)

				frame18.CurrentDPSSlider:SetPoint ("left", frame18.CurrentDPSLabel, "right", 2)
				frame18.CurrentDPSSlider:SetAsCheckBox()
				frame18.CurrentDPSSlider.OnSwitch = function (_, _, value)
					_detalhes.current_dps_meter.enabled = not _detalhes.current_dps_meter.enabled
					Details:LoadFramesForBroadcastTools()
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "CurrentDPSSlider", "CurrentDPSLabel", "Enable The Real Current Dps")
				
				frame18.CurrentDPSLabel:SetPoint ("topleft", currentDPSTitleImage, "bottomleft", 0, -10)
				frame18.CurrentDPSSlider:SetPoint ("left", frame18.CurrentDPSLabel, "right", 2, 0)
				
			--> configure feature button
				local configure_current_dps = function()
					_detalhes:OpenCurrentRealDPSOptions (true)
					C_Timer.After (0.2, function()
						window:Hide()
					end)
				end
				local configureCurrentDPSButton = g:NewButton (frame18, _, "$parentConfigureCurrentDPSButton", "configureCurrentDPS", 100, 20, configure_current_dps, nil, nil, nil, "Current Real DPS Options", nil, options_button_template)
				configureCurrentDPSButton:SetWidth (button_width)
				configureCurrentDPSButton:SetPoint ("topleft", frame18.CurrentDPSLabel, "bottomleft", 0, -7)

		
		--> suppress alerts and tutorial popups
			g:NewLabel (frame18, _, "$parentAlertsAndPopupsAnchor", "alertsAndPopupsAnchor", "Other Settings:", "GameFontNormal")
			

		
			--> no alerts
				g:NewLabel (frame18, _, "$parentNoAlertsLabel", "NoAlertsLabel", "No Window Alerts", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentNoAlertsSlider", "NoAlertsSlider", 60, 20, _, _, _detalhes.streamer_config.no_alerts, nil, nil, nil, nil, options_switch_template)

				frame18.NoAlertsSlider:SetPoint ("left", frame18.NoAlertsLabel, "right", 2)
				frame18.NoAlertsSlider:SetAsCheckBox()
				frame18.NoAlertsSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.no_alerts = not _detalhes.streamer_config.no_alerts
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "NoAlertsSlider", "NoAlertsLabel", "Don't show alerts in the bottom of the window and avoid show tutorial popups.")
				
			--> faster updates
				g:NewLabel (frame18, _, "$parentFasterUpdatesLabel", "FasterUpdatesLabel", "60 Updates Per Second", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentFasterUpdatesSlider", "FasterUpdatesSlider", 60, 20, _, _, _detalhes.streamer_config.faster_updates, nil, nil, nil, nil, options_switch_template)

				frame18.FasterUpdatesSlider:SetPoint ("left", frame18.FasterUpdatesLabel, "right", 2)
				frame18.FasterUpdatesSlider:SetAsCheckBox()
				frame18.FasterUpdatesSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.faster_updates = not _detalhes.streamer_config.faster_updates
					_detalhes:RefreshUpdater()
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "FasterUpdatesSlider", "FasterUpdatesLabel", "Increase the refresh rate to 60 times per second.")
			
			--> quick detection
				g:NewLabel (frame18, _, "$parentQuickDetectionLabel", "QuickDetectionLabel", "Quick Player Info", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentQuickDetectionSlider", "QuickDetectionSlider", 60, 20, _, _, _detalhes.streamer_config.quick_detection, nil, nil, nil, nil, options_switch_template)

				frame18.QuickDetectionSlider:SetPoint ("left", frame18.QuickDetectionLabel, "right", 2)
				frame18.QuickDetectionSlider:SetAsCheckBox()
				frame18.QuickDetectionSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.quick_detection = not _detalhes.streamer_config.quick_detection
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "QuickDetectionSlider", "QuickDetectionLabel", "Attempt to acquire player information such as class, spec or item level faster.")
			
			--> disable mythic dungeon
				g:NewLabel (frame18, _, "$parentDisableMythicDungeonLabel", "DisableMythicDungeonLabel", "No Mythic Dungeon Shenanigans", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentDisableMythicDungeonSlider", "DisableMythicDungeonSlider", 60, 20, _, _, _detalhes.streamer_config.disable_mythic_dungeon, nil, nil, nil, nil, options_switch_template)

				frame18.DisableMythicDungeonSlider:SetPoint ("left", frame18.DisableMythicDungeonLabel, "right", 2)
				frame18.DisableMythicDungeonSlider:SetAsCheckBox()
				frame18.DisableMythicDungeonSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.disable_mythic_dungeon = not _detalhes.streamer_config.disable_mythic_dungeon
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "DisableMythicDungeonSlider", "DisableMythicDungeonLabel", "Threat mythic dungeon segments as common segments: no trash merge, no mythic run overall, segments wraps on entering and leaving combat.")
				
			--> disable chart at the end of a mythic dungeon
				g:NewLabel (frame18, _, "$parentDisableMythicDungeonChartLabel", "DisableMythicDungeonChartLabel", "Show Mythic Dungeon Damage Graphic", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentDisableMythicDungeonChartSlider", "DisableMythicDungeonChartSlider", 60, 20, _, _, _detalhes.mythic_plus.show_damage_graphic, nil, nil, nil, nil, options_switch_template)

				frame18.DisableMythicDungeonChartSlider:SetPoint ("left", frame18.DisableMythicDungeonChartLabel, "right", 2)
				frame18.DisableMythicDungeonChartSlider:SetAsCheckBox()
				frame18.DisableMythicDungeonChartSlider.OnSwitch = function (_, _, value)
					_detalhes.mythic_plus.show_damage_graphic = not _detalhes.mythic_plus.show_damage_graphic
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "DisableMythicDungeonChartSlider", "DisableMythicDungeonChartLabel", "At the end of a mythic dungeon run, show a graphic with the DPS of each player.")
				
			--> clear cache
				g:NewLabel (frame18, _, "$parentClearCacheLabel", "ClearCacheLabel", "Clear Cache on New Event", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentClearCacheSlider", "ClearCacheSlider", 60, 20, _, _, _detalhes.streamer_config.reset_spec_cache, nil, nil, nil, nil, options_switch_template)

				frame18.ClearCacheSlider:SetPoint ("left", frame18.ClearCacheLabel, "right", 2)
				frame18.ClearCacheSlider:SetAsCheckBox()
				frame18.ClearCacheSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.reset_spec_cache = not _detalhes.streamer_config.reset_spec_cache
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "ClearCacheSlider", "ClearCacheLabel", "Reduces the chance of getting a serial number overlap when working with multiple realms.")
				
			--> advanced animations
			--[[
				g:NewLabel (frame18, _, "$parentAdvancedAnimationsLabel", "AdvancedAnimationsLabel", "Use Animation Acceleration", "GameFontHighlightLeft")
				g:NewSwitch (frame18, _, "$parentAdvancedAnimationsSlider", "AdvancedAnimationsSlider", 60, 20, _, _, _detalhes.streamer_config.use_animation_accel, nil, nil, nil, nil, options_switch_template)

				frame18.AdvancedAnimationsSlider:SetPoint ("left", frame18.AdvancedAnimationsLabel, "right", 2)
				frame18.AdvancedAnimationsSlider:SetAsCheckBox()
				frame18.AdvancedAnimationsSlider.OnSwitch = function (_, _, value)
					_detalhes.streamer_config.use_animation_accel = not _detalhes.streamer_config.use_animation_accel
					_detalhes:RefreshAnimationFunctions()
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				
				window:CreateLineBackground2 (frame18, "AdvancedAnimationsSlider", "AdvancedAnimationsLabel", "Animation speed changes accordly to the amount of space the bar needs to travel.")
			--]]	
			
		--> anchoring
		local x = window.left_start_at
		titleFrame18:SetPoint (x, window.title_y_pos)
		titleFrame18Desc:SetPoint (x, window.title_y_pos2)
	
		local a = frame18:CreateFontString (nil, "overlay", "GameFontNormal")
		frame18.a = a
		
		local left_side = {
			{"streamerPluginAnchor", 0, true},
			
			{"eventTrackerAnchor", 0, true},
			{"eventTrackerAnchor", 0, true},
			{"eventTrackerAnchor", 0, true},
			{"eventTrackerAnchor", 0, true},
			{"eventTrackerAnchor", 0, true},
			
		}
		
		window:arrange_menu (frame18, left_side, x, window.top_start_at)	
	
		local right_side = {
			{"currentDPSAnchor", 0, true},
			{"alertsAndPopupsAnchor", 0, true},
			{"alertsAndPopupsAnchor", 0, true},
			{"alertsAndPopupsAnchor", 0, true},
			{"alertsAndPopupsAnchor", 0, true},
			{"alertsAndPopupsAnchor", 0, true},
			{"NoAlertsLabel"},
			{"FasterUpdatesLabel"},
			{"QuickDetectionLabel"},
			{"DisableMythicDungeonLabel"},
			{"DisableMythicDungeonChartLabel"},
			{"ClearCacheLabel"},
			--{"AdvancedAnimationsLabel"},
		}
		
		window:arrange_menu (frame18, right_side, window.right_start_at, window.top_start_at)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - Automatization Settings ~17
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame17()
	
	local frame17 = window.options [17][1]

		local titulo_automatization_settings = g:NewLabel (frame17, _, "$parentTituloAutomatizationSettingsText", "AutomatizationSettingsLabel", Loc ["STRING_OPTIONSMENU_AUTOMATIC_TITLE"], "GameFontNormal", 16)
		local titulo_automatization_settings_desc = g:NewLabel (frame17, _, "$parentAutomatizationSettingsText2", "AutomatizationSettingsLabel2", Loc ["STRING_OPTIONSMENU_AUTOMATIC_TITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_automatization_settings_desc:SetSize (450, 20)
	
	--> combat alpha modifier
	
		--anchor
		g:NewLabel (frame17, _, "$parentHideInCombatAnchor", "hideInCombatAnchor", Loc ["STRING_OPTIONS_ALPHAMOD_ANCHOR"], "GameFontNormal")
		
		--> hide in combat
		g:NewLabel (frame17, _, "$parentCombatAlphaLabel", "combatAlphaLabel", Loc ["STRING_OPTIONS_COMBAT_ALPHA"], "GameFontHighlightLeft")
		
		local onSelectCombatAlpha = function (_, _, combat_alpha)
			local instance = _G.DetailsOptionsWindow.instance
			
			instance:SetCombatAlpha (combat_alpha)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetCombatAlpha (combat_alpha)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		local texCoords = {.9, 0.1, 0.1, .9}
		local typeCombatAlpha = {
			{value = 1, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_1"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_03", texcoord = texCoords, color = "gray"},
			{value = 2, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_2"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
			{value = 3, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_3"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
			{value = 4, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_4"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
			{value = 5, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_5"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
			{value = 6, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_6"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
			{value = 7, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_7"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords, desc = Loc ["STRING_OPTIONS_COMBAT_ALPHA_6"] .. " + " .. Loc ["STRING_OPTIONS_COMBAT_ALPHA_3"]},
			{value = 8, label = Loc ["STRING_OPTIONS_COMBAT_ALPHA_8"], onclick = onSelectCombatAlpha, icon = "Interface\\Icons\\INV_Misc_Spyglass_02", texcoord = texCoords},
		}
		local buildTypeCombatAlpha = function()
			return typeCombatAlpha
		end
		
		local d = g:NewDropDown (frame17, _, "$parentCombatAlphaDropdown", "combatAlphaDropdown", 160, dropdown_height, buildTypeCombatAlpha, nil, options_dropdown_template)
		
		frame17.combatAlphaDropdown:SetPoint ("left", frame17.combatAlphaLabel, "right", 2, 0)		
		
		window:CreateLineBackground2 (frame17, "combatAlphaDropdown", "combatAlphaLabel", Loc ["STRING_OPTIONS_COMBAT_ALPHA_DESC"])

		g:NewLabel (frame17, _, "$parentHideOnCombatAlphaLabel", "hideOnCombatAlphaLabel", Loc ["STRING_ALPHA"], "GameFontHighlightLeft")
		
		local s = g:NewSlider (frame17, _, "$parentHideOnCombatAlphaSlider", "hideOnCombatAlphaSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 100, 1, _G.DetailsOptionsWindow.instance.hide_in_combat_alpha, nil, nil, nil, options_slider_template)
		--config_slider (s)
		
		frame17.hideOnCombatAlphaSlider:SetPoint ("left", frame17.hideOnCombatAlphaLabel, "right", 2, 0)
		frame17.hideOnCombatAlphaSlider:SetHook ("OnValueChange", function (self, instance, amount) --> slider, fixedValue, sliderValue
			instance.hide_in_combat_alpha = amount
			instance:SetCombatAlpha (nil, nil, true)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance.hide_in_combat_alpha = amount
						this_instance:SetCombatAlpha (nil, nil, true)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame17, "hideOnCombatAlphaSlider", "hideOnCombatAlphaLabel", Loc ["STRING_OPTIONS_HIDECOMBATALPHA_DESC"])
	
	--> auto transparency
		--> alpha onenter onleave auto transparency
		
		g:NewLabel (frame17, _, "$parentMenuAlphaAnchor", "menuAlphaAnchorLabel", Loc ["STRING_OPTIONS_MENU_ALPHA"], "GameFontNormal")
	
		g:NewSwitch (frame17, _, "$parentMenuOnEnterLeaveAlphaSwitch", "alphaSwitch", 60, 20, _, _, instance.menu_alpha.enabled, nil, nil, nil, nil, options_switch_template)
		
		local s = g:NewSlider (frame17, _, "$parentMenuOnEnterAlphaSlider", "menuOnEnterSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 1, 0.02, instance.menu_alpha.onenter, true, nil, nil, options_slider_template)
		--config_slider (s)
		s.useDecimals = true
		
		local s = g:NewSlider (frame17, _, "$parentMenuOnLeaveAlphaSlider", "menuOnLeaveSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 1, 0.02, instance.menu_alpha.onleave, true, nil, nil, options_slider_template)
		--config_slider (s)
		
		frame17.menuOnEnterSlider.useDecimals = true
		frame17.menuOnLeaveSlider.useDecimals = true
		
		g:NewLabel (frame17, _, "$parentMenuOnEnterLeaveAlphaLabel", "alphaSwitchLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewLabel (frame17, _, "$parentMenuOnEnterAlphaLabel", "menuOnEnterLabel", Loc ["STRING_OPTIONS_MENU_ALPHAENTER"], "GameFontHighlightLeft")
		g:NewLabel (frame17, _, "$parentMenuOnLeaveAlphaLabel", "menuOnLeaveLabel", Loc ["STRING_OPTIONS_MENU_ALPHALEAVE"], "GameFontHighlightLeft")
		
		window:CreateLineBackground2 (frame17, "alphaSwitch", "alphaSwitchLabel", Loc ["STRING_OPTIONS_MENU_ALPHAENABLED_DESC"])
		
		window:CreateLineBackground2 (frame17, "menuOnEnterSlider", "menuOnEnterLabel", Loc ["STRING_OPTIONS_MENU_ALPHAENTER_DESC"])
		
		window:CreateLineBackground2 (frame17, "menuOnLeaveSlider", "menuOnLeaveLabel", Loc ["STRING_OPTIONS_MENU_ALPHALEAVE_DESC"])
		
		frame17.alphaSwitch:SetPoint ("left", frame17.alphaSwitchLabel, "right", 2)
		frame17.alphaSwitch:SetAsCheckBox()
		frame17.menuOnEnterSlider:SetPoint ("left", frame17.menuOnEnterLabel, "right", 2)
		frame17.menuOnLeaveSlider:SetPoint ("left", frame17.menuOnLeaveLabel, "right", 2)

		frame17.menuOnEnterSlider:SetThumbSize (24)
		frame17.menuOnLeaveSlider:SetThumbSize (24)


		g:NewLabel (frame17, _, "$parentMenuOnEnterLeaveAlphaIconsTooLabel", "alphaIconsTooLabel", Loc ["STRING_OPTIONS_MENU_IGNOREBARS"], "GameFontHighlightLeft")		
		g:NewSwitch (frame17, _, "$parentMenuOnEnterLeaveAlphaIconsTooSwitch", "alphaIconsTooSwitch", 60, 20, _, _, instance.menu_alpha.ignorebars, nil, nil, nil, nil, options_switch_template)
		
		window:CreateLineBackground2 (frame17, "alphaIconsTooSwitch", "alphaIconsTooLabel", Loc ["STRING_OPTIONS_MENU_IGNOREBARS_DESC"])
		
		frame17.alphaIconsTooSwitch:SetPoint ("left", frame17.alphaIconsTooLabel, "right", 2)
		frame17.alphaIconsTooSwitch:SetAsCheckBox()
		
		frame17.alphaIconsTooSwitch.OnSwitch = function (self, instance, value)
			instance:SetMenuAlpha (nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetMenuAlpha (nil, nil, nil, value)
					end
				end
			end
			
		end
		frame17.alphaSwitch.OnSwitch = function (self, instance, value)
			instance:SetMenuAlpha (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetMenuAlpha (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		frame17.menuOnEnterSlider:SetHook ("OnValueChange", function (self, instance, value) 
			self.amt:SetText (string.format ("%.2f", value))
			instance:SetMenuAlpha (nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetMenuAlpha (nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			return true
		end)
		frame17.menuOnLeaveSlider:SetHook ("OnValueChange", function (self, instance, value) 
			self.amt:SetText (string.format ("%.2f", value))
			instance:SetMenuAlpha (nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetMenuAlpha (nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			return true
		end)		

		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		local Current_Switch_Func = function()end
	
		local BuildSwitchMenu = function()
		
			window.lastSwitchList = {}
			local t = {{value = 0, label = "do not switch", color = {.7, .7, .7, 1}, onclick = Current_Switch_Func, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]}}
			
			local attributes = _detalhes.sub_atributos
			local i = 1
			
			for atributo, sub_atributo in ipairs (attributes) do
				local icones = sub_atributo.icones
				for index, att_name in ipairs (sub_atributo.lista) do
					local texture, texcoord = unpack (icones [index])
					tinsert (t, {value = i, label = att_name, onclick = Current_Switch_Func, icon = texture, texcoord = texcoord})
					window.lastSwitchList [i] = {atributo, index, i}
					i = i + 1
				end
			end
			
			for index, ptable in ipairs (_detalhes.RaidTables.Menu) do
				tinsert (t, {value = i, label = ptable [1], onclick = Current_Switch_Func, icon = ptable [2]})
				window.lastSwitchList [i] = {"raid", ptable [4], i}
				i = i + 1
			end
		
			return t
		end
	
		local healer_icon1 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("HEALER")}, "HealerIcon1", "$parentHealerIcon1")
		local healer_icon2 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("HEALER")}, "HealerIcon2", "$parentHealerIcon2")

		local dps_icon1 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("DAMAGER")}, "DpsIcon1", "$parentDpsIcon1")
		local dps_icon2 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("DAMAGER")}, "DpsIcon2", "$parentDpsIcon2")
		
		local tank_icon1 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("TANK")}, "TankIcon1", "$parentTankIcon1")
		local tank_icon2 = g:NewImage (frame17, [[Interface\LFGFRAME\UI-LFG-ICON-ROLES]], 20, 20, nil, {GetTexCoordsForRole("TANK")}, "TankIcon2", "$parentTankIcon2")
	
		-- auto switch all roles in combat
			g:NewLabel (frame17, _, "$parentAutoSwitchLabel", "autoSwitchLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH"], "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchOnCombatAllRoles = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_all_roles_in_combat = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_all_roles_in_combat = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end

			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchOnCombatAllRoles
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchDropdown", "autoSwitchDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			frame17.autoSwitchDropdown:SetPoint ("left", frame17.autoSwitchLabel, "right", 2, 0)		
			
			window:CreateLineBackground2 (frame17, "autoSwitchDropdown", "autoSwitchLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_DESC"])
		
		-- auto switch after a wipe
			g:NewLabel (frame17, _, "$parentAutoSwitchWipeLabel", "AutoSwitchWipeLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_WIPE"], "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchWipe = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_all_roles_after_wipe = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_all_roles_after_wipe = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchWipe
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchWipeDropdown", "autoSwitchWipeDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			frame17.autoSwitchWipeDropdown:SetPoint ("left", frame17.AutoSwitchWipeLabel, "right", 2, 0)		
			
			window:CreateLineBackground2 (frame17, "autoSwitchWipeDropdown", "AutoSwitchWipeLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_WIPE_DESC"])

		-- auto switch damage no in combat
			g:NewLabel (frame17, _, "$parentAutoSwitchDamageNoCombatLabel", "AutoSwitchDamageNoCombatLabel", "", "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchDamageNoCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_damager = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_damager = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchDamageNoCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchDamageNoCombatDropdown", "AutoSwitchDamageNoCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			frame17.AutoSwitchDamageNoCombatDropdown:SetPoint ("left", dps_icon1, "right", 2, 0)
			frame17.AutoSwitchDamageNoCombatLabel:SetPoint ("left", dps_icon1, "left", 0, 0)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchDamageNoCombatDropdown", "AutoSwitchDamageNoCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_DAMAGER_DESC"], dps_icon1)

		-- auto switch damage in combat
			g:NewLabel (frame17, _, "$parentAutoSwitchDamageCombatLabel", "AutoSwitchDamageCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_COMBAT"], "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchDamageCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_damager_in_combat = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_damager_in_combat = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchDamageCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchDamageCombatDropdown", "AutoSwitchDamageCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			frame17.AutoSwitchDamageCombatDropdown:SetPoint ("left", frame17.AutoSwitchDamageCombatLabel, "right", 2, -1)		
			frame17.AutoSwitchDamageCombatLabel:SetPoint ("left", dps_icon2, "right", 2, 1)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchDamageCombatDropdown", "AutoSwitchDamageCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_DAMAGER_DESC"], dps_icon2)

		-- auto switch heal in no combat
			g:NewLabel (frame17, _, "$parentAutoSwitchHealNoCombatLabel", "AutoSwitchHealNoCombatLabel", "", "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchHealNoCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_healer = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_healer = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchHealNoCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchHealNoCombatDropdown", "AutoSwitchHealNoCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			--frame17.AutoSwitchHealNoCombatDropdown:SetPoint ("left", frame17.AutoSwitchHealNoCombatLabel, "right", 2, 0)		
			frame17.AutoSwitchHealNoCombatDropdown:SetPoint ("left", healer_icon1, "right", 2, 0)
			frame17.AutoSwitchHealNoCombatLabel:SetPoint ("left", healer_icon1, "left", 0, 0)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchHealNoCombatDropdown", "AutoSwitchHealNoCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_HEALER_DESC"], healer_icon1)

		-- auto switch heal in combat
			g:NewLabel (frame17, _, "$parentAutoSwitchHealCombatLabel", "AutoSwitchHealCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_COMBAT"], "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchHealCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_healer_in_combat = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_healer_in_combat = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchHealCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchHealCombatDropdown", "AutoSwitchHealCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			--frame17.AutoSwitchHealCombatDropdown:SetPoint ("left", frame17.AutoSwitchHealCombatLabel, "right", 2, 0)		
			frame17.AutoSwitchHealCombatDropdown:SetPoint ("left", frame17.AutoSwitchHealCombatLabel, "right", 2, -1)
			frame17.AutoSwitchHealCombatLabel:SetPoint ("left", healer_icon2, "right", 2, 1)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchHealCombatDropdown", "AutoSwitchHealCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_HEALER_DESC"], healer_icon2)
			
		-- auto switch tank in no combat
			g:NewLabel (frame17, _, "$parentAutoSwitchTankNoCombatLabel", "AutoSwitchTankNoCombatLabel", "", "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchTankNoCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_tank = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_tank = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchTankNoCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchTankNoCombatDropdown", "AutoSwitchTankNoCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)

			frame17.AutoSwitchTankNoCombatDropdown:SetPoint ("left", tank_icon1, "right", 2, 0)		
			frame17.AutoSwitchTankNoCombatLabel:SetPoint ("left", tank_icon1, "left", 0, 0)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchTankNoCombatDropdown", "AutoSwitchTankNoCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_TANK_DESC"], tank_icon1)

		-- auto switch tank in combat
			g:NewLabel (frame17, _, "$parentAutoSwitchTankCombatLabel", "AutoSwitchTankCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_COMBAT"], "GameFontHighlightLeft")
			--
			local OnSelectAutoSwitchTankCombat = function (_, _, switch_to)
				if (switch_to == 0) then
					_G.DetailsOptionsWindow.instance.switch_tank_in_combat = false
					return
				end
				
				local selected = window.lastSwitchList [switch_to]
				_G.DetailsOptionsWindow.instance.switch_tank_in_combat = selected
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildThisMenu = function()
				Current_Switch_Func = OnSelectAutoSwitchTankCombat
				return BuildSwitchMenu()
			end
			
			local d = g:NewDropDown (frame17, _, "$parentAutoSwitchTankCombatDropdown", "AutoSwitchTankCombatDropdown", 160, dropdown_height, BuildThisMenu, 1, options_dropdown_template)
			
			frame17.AutoSwitchTankCombatDropdown:SetPoint ("left", frame17.AutoSwitchTankCombatLabel, "right", 2, -1)
			frame17.AutoSwitchTankCombatLabel:SetPoint ("left", tank_icon2, "right", 2, 1)
			
			window:CreateLineBackground2 (frame17, "AutoSwitchTankCombatDropdown", "AutoSwitchTankCombatLabel", Loc ["STRING_OPTIONS_AUTO_SWITCH_TANK_DESC"], tank_icon2)
		
		
		--> auto current segment
		g:NewSwitch (frame17, _, "$parentAutoCurrentSlider", "autoCurrentSlider", 60, 20, _, _, instance.auto_current, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame17, _, "$parentAutoCurrentLabel", "autoCurrentLabel", Loc ["STRING_OPTIONS_INSTANCE_CURRENT"], "GameFontHighlightLeft")

		frame17.autoCurrentSlider:SetPoint ("left", frame17.autoCurrentLabel, "right", 2)
		frame17.autoCurrentSlider:SetAsCheckBox()
		frame17.autoCurrentSlider.OnSwitch = function (self, instance, value)
			instance.auto_current = value
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame17, "autoCurrentSlider", "autoCurrentLabel", Loc ["STRING_OPTIONS_INSTANCE_CURRENT_DESC"])

	--> trash suppression
		g:NewLabel (frame17, _, "$parentTrashSuppressionLabel", "TrashSuppressionLabel", Loc ["STRING_OPTIONS_TRASH_SUPPRESSION"], "GameFontHighlightLeft")
		g:NewSlider (frame17, _, "$parentTrashSuppressionSlider", "TrashSuppressionSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 180, 1, _detalhes.instances_suppress_trash, nil, nil, nil, options_slider_template)

		frame17.TrashSuppressionSlider:SetPoint ("left", frame17.TrashSuppressionLabel, "right", 2)
	
		frame17.TrashSuppressionSlider:SetHook ("OnValueChange", function (_, _, amount)
			_detalhes:SetTrashSuppression (amount)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame17, "TrashSuppressionSlider", "TrashSuppressionLabel", Loc ["STRING_OPTIONS_TRASH_SUPPRESSION_DESC"])

		
		
	--> Anchors
		
		g:NewLabel (frame17, _, "$parentInstancesMiscAnchor", "instancesMiscLabel", Loc ["STRING_OPTIONS_INSTANCES"], "GameFontNormal")
		g:NewLabel (frame17, _, "$parentSwitchesAnchor", "switchesAnchorLabel", Loc ["STRING_OPTIONS_SWITCH_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_automatization_settings:SetPoint (x, window.title_y_pos)
		titulo_automatization_settings_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"switchesAnchorLabel", 1, true},
			
			{dps_icon1, 2},
			{healer_icon1, 3},
			{tank_icon1, 4},
			
			{dps_icon2, 5, true},
			{healer_icon2, 6},
			{tank_icon2, 7},
			
			{"autoSwitchLabel", 8, true},
			{"AutoSwitchWipeLabel", 9},
			{"autoCurrentLabel", 10},
			{"TrashSuppressionLabel", 11},
		}
		
		window:arrange_menu (frame17, left_side, x, window.top_start_at)

		local right_side = {
			{"hideInCombatAnchor", 1, true},
			{"combatAlphaLabel", 2},
			{"hideOnCombatAlphaLabel", 3},
			
			{"menuAlphaAnchorLabel", 4, true},
			{"alphaSwitchLabel", 5},
			{"alphaIconsTooLabel", 6},
			{"menuOnEnterLabel", 7, true},
			{"menuOnLeaveLabel", 8},
		}
		
		window:arrange_menu (frame17, right_side, window.right_start_at, window.top_start_at)
		
		
		
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - Chart Data ~16
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame16()

	--> general settings:
		local frame16 = window.options [16][1]

	--> title
		local titulo_datacharts = g:NewLabel (frame16, _, "$parentTituloDataChartsText", "DataChartsLabel", Loc ["STRING_OPTIONS_DATACHARTTITLE"], "GameFontNormal", 16)
		local titulo_datacharts_desc = g:NewLabel (frame16, _, "$parentDataChartsText2", "DataCharts2Label", Loc ["STRING_OPTIONS_DATACHARTTITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_datacharts_desc.width = 350
	
	--> warning
		if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_CHART_VIEWER")) then
			local label = g:NewLabel (frame16, _, "$parentPluginWarningLabel", "PluginWarningLabel", Loc ["STRING_OPTIONS_CHART_PLUGINWARNING"], "GameFontNormal")
			local image = g:NewImage (frame16, [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
			label:SetPoint ("topright", frame16, "topright", -42, -10)
			label:SetJustifyH ("left")
			label:SetWidth (160)
			image:SetPoint ("right", label, "left", -7, 0)	
			image:SetSize (32, 32)
		end
	
	--> panel
		local edit_name = function (index, name)
			_detalhes:TimeDataUpdate (index, name)
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		
		local big_code_editor = g:NewSpecialLuaEditorEntry (frame16, 643, 382, "bigCodeEditor", "$parentBigCodeEditor")
		big_code_editor:SetPoint ("topleft", frame16, "topleft", 7, -70)
		big_code_editor:SetFrameLevel (frame16:GetFrameLevel()+6)
		big_code_editor:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
		DetailsFramework:ReskinSlider (big_code_editor.scroll)
		big_code_editor:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
		big_code_editor:SetBackdropBorderColor (0, 0, 0, 1)
		big_code_editor:Hide()
		
		local accept = function()
			big_code_editor:ClearFocus()
			if (not big_code_editor.is_export) then
				_detalhes:TimeDataUpdate (big_code_editor.index, nil, big_code_editor:GetText())
			end
			big_code_editor:Hide()
		end
		local cancel = function()
			big_code_editor:ClearFocus()
			big_code_editor:Hide()
		end
		local accept_changes = g:NewButton (big_code_editor, nil, "$parentAccept", "acceptButton", 24, 24, accept, nil, nil, [[Interface\Buttons\UI-CheckBox-Check]])
		accept_changes:SetPoint (10, 18)
		local accept_changes_label = g:NewLabel (big_code_editor, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_SAVE"])
		accept_changes_label:SetPoint ("left", accept_changes, "right", 2, 0)
		
		local cancel_changes = g:NewButton (big_code_editor, nil, "$parentCancel", "CancelButton", 20, 20, cancel, nil, nil, [[Interface\PetBattles\DeadPetIcon]])
		cancel_changes:SetPoint (100, 17)
		local cancel_changes_label = g:NewLabel (big_code_editor, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_CANCEL"])
		cancel_changes_label:SetPoint ("left", cancel_changes, "right", 2, 0)

		local edit_code = function (index)
			local data = _detalhes.savedTimeCaptures [index]
			if (data) then
				local func = data [2]
				
				if (type (func) == "function") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_CODELOADED"])
				end
				
				big_code_editor:SetText (func)
				big_code_editor.original_code = func
				big_code_editor.index = index
				big_code_editor.is_export = nil
				big_code_editor:Show()
				
				frame16.userTimeCaptureAddPanel:Hide()
				frame16.importEditor:ClearFocus()
				frame16.importEditor:Hide()
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
			end
		end
		
		local edit_icon = function (index, icon)
			_detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, icon)
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		local edit_author = function (index, author)
			_detalhes:TimeDataUpdate (index, nil, nil, nil, author)
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		local edit_version = function (index, version)
			_detalhes:TimeDataUpdate (index, nil, nil, nil, nil, version)
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		
		local big_code_editor2 = g:NewSpecialLuaEditorEntry (frame16, 643, 402, "exportEditor", "$parentExportEditor", true)
		big_code_editor2:SetPoint ("topleft", frame16, "topleft", 7, -70)
		big_code_editor2:SetFrameLevel (frame16:GetFrameLevel()+6)
		big_code_editor2:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
		DetailsFramework:ReskinSlider (big_code_editor2.scroll)
		big_code_editor2:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
		big_code_editor2:SetBackdropBorderColor (0, 0, 0, 1)
		big_code_editor2:Hide()
		
		local close_export_box = function()
			big_code_editor2:ClearFocus()
			big_code_editor2:Hide()
		end
		
		local close_export = g:NewButton (big_code_editor2, nil, "$parentClose", "closeButton", 120, 20, close_export_box)
		close_export:SetPoint (10, 18)
		close_export:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]])
		close_export:SetText (Loc ["STRING_OPTIONS_CHART_CLOSE"])
		close_export:SetTemplate (options_button_template)
		
		local export_function = function (index)
			local data = _detalhes.savedTimeCaptures [index]
			if (data) then
				local encoded = Details:CompressData (data, "print")
				if (encoded) then
					big_code_editor2:SetText (encoded)
					
					big_code_editor2:Show()
					big_code_editor2.editbox:HighlightText()
					big_code_editor2.editbox:SetFocus (true)
				else
					Details:Msg ("error exporting the time capture.") --localize-me
				end
			end
		end
		
		local remove_capture = function (index)
			_detalhes:TimeDataUnregister (index)
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		
		local edit_enabled = function (index, enabled, a, b)
			if (enabled) then
				_detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, nil, false)
			else
				_detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, nil, true)
			end
			
			frame16.userTimeCaptureFillPanel:Refresh()
		end
		
		local header = {
			{name = Loc ["STRING_OPTIONS_CHART_NAME"], width = 175, type = "entry", func = edit_name},
			{name = Loc ["STRING_OPTIONS_CHART_EDIT"], width = 55, type = "button", func = edit_code, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]], notext = true, iconalign = "center"},
			{name = Loc ["STRING_OPTIONS_CHART_ICON"], width = 50, type = "icon", func = edit_icon},
			{name = Loc ["STRING_OPTIONS_CHART_AUTHOR"], width = 125, type = "text", func = edit_author},
			{name = Loc ["STRING_OPTIONS_CHART_VERSION"], width = 65, type = "entry", func = edit_version},
			{name = Loc ["STRING_ENABLED"], width = 50, type = "button", func = edit_enabled, icon = [[Interface\COMMON\Indicator-Green]], notext = true, iconalign = "center"},
			{name = Loc ["STRING_OPTIONS_CHART_EXPORT"], width = 50, type = "button", func = export_function, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], notext = true, iconalign = "center"},
			{name = Loc ["STRING_OPTIONS_CHART_REMOVE"], width = 70, type = "button", func = remove_capture, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], notext = true, iconalign = "center"},
		}
		
		local total_lines = function()
			return #_detalhes.savedTimeCaptures
		end
		local fill_row = function (index)
			local data = _detalhes.savedTimeCaptures [index]
			if (data) then
			
				local enabled_texture
				if (data[7]) then
					enabled_texture = [[Interface\COMMON\Indicator-Green]]
				else
					enabled_texture = [[Interface\COMMON\Indicator-Red]]
				end

				return {
					data[1], --name
					"", --func
					data[6], --icon
					data[4], -- author
					data[5], --version
					{func = edit_enabled, icon = enabled_texture, value = data[7]} --enabled
				}
			else
				return {nil, nil, nil, nil, nil, nil}
			end
		end

		local panel = g:NewFillPanel (frame16, header, "$parentUserTimeCapturesFillPanel", "userTimeCaptureFillPanel", 640, 382, total_lines, fill_row, false)

		panel:SetHook ("OnMouseDown", function()
			if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
				DetailsIconPickFrame:Hide()
			end
		end)
		
		panel:Refresh()
		
		--> add panel
			local addframe = g:NewPanel (frame16, nil, "$parentUserTimeCapturesAddPanel", "userTimeCaptureAddPanel", 644, 402)
			addframe:SetPoint (8, -70)
			addframe:SetFrameLevel (7)
			addframe:Hide()

			addframe:SetPoint ("topleft", frame16, "topleft", 7, -70)
			addframe:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
			addframe:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
			addframe:SetBackdropBorderColor (0, 0, 0, 1)

			--> name
				local capture_name = g:NewLabel (addframe, nil, "$parentNameLabel", "nameLabel", Loc ["STRING_OPTIONS_CHART_ADDNAME"])
				local capture_name_entry = g:NewTextEntry (addframe, nil, "$parentNameEntry", "nameEntry", 160, TEXTENTRY_HEIGHT, function() end, nil, nil, nil, nil, options_dropdown_template)
				capture_name_entry:SetMaxLetters (16)
				capture_name_entry:SetPoint ("left", capture_name, "right", 2, 0)
			
			--> function
				local capture_func = g:NewLabel (addframe, nil, "$parentFunctionLabel", "functionLabel", Loc ["STRING_OPTIONS_CHART_ADDCODE"])
				local capture_func_entry = g:NewSpecialLuaEditorEntry (addframe.widget, 300, 200, "funcEntry", "$parentFuncEntry")
				capture_func_entry:SetPoint ("topleft", capture_func.widget, "topright", 2, 0)
				capture_func_entry:SetSize (500, 220)
				capture_func_entry:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				capture_func_entry:SetBackdropBorderColor (0, 0, 0, 1)
				capture_func_entry:SetBackdropColor (0, 0, 0, .5)
				DetailsFramework:ReskinSlider (capture_func_entry.scroll)
				
			--> icon
				local capture_icon = g:NewLabel (addframe, nil, "$parentIconLabel", "iconLabel", Loc ["STRING_OPTIONS_CHART_ADDICON"])
				local icon_button_func = function (texture)
					addframe.iconButton.icon.texture = texture
				end
				local capture_icon_button = g:NewButton (addframe, nil, "$parentIconButton", "iconButton", 20, 20, function() g:IconPick (icon_button_func, true) end, nil, nil, nil, nil, nil, options_button_template)
				local capture_icon_button_icon = g:NewImage (capture_icon_button, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentIcon")
				capture_icon_button_icon:SetPoint (0, 0)
				--capture_icon_button:InstallCustomTexture()
				capture_icon_button:SetPoint ("left", capture_icon, "right", 2, 0)			
			
			--> author
				local capture_author = g:NewLabel (addframe, nil, "$parentAuthorLabel", "authorLabel", Loc ["STRING_OPTIONS_CHART_ADDAUTHOR"])
				local capture_author_entry = g:NewTextEntry (addframe, nil, "$parentAuthorEntry", "authorEntry", 160, TEXTENTRY_HEIGHT, function() end, nil, nil, nil, nil, options_dropdown_template)
				capture_author_entry:SetPoint ("left", capture_author, "right", 2, 0)
				
			--> version
				local capture_version = g:NewLabel (addframe, nil, "$parentVersionLabel", "versionLabel", Loc ["STRING_OPTIONS_CHART_ADDVERSION"])
				local capture_version_entry = g:NewTextEntry (addframe, nil, "$parentVersionEntry", "versionEntry", 160, TEXTENTRY_HEIGHT, function() end, nil, nil, nil, nil, options_dropdown_template)
				capture_version_entry:SetPoint ("left", capture_version, "right", 2, 0)
		
		--> open add panel button
			local add = function() 
				addframe:Show()
				frame16.importEditor:ClearFocus()
				frame16.importEditor:Hide()
				big_code_editor:ClearFocus()
				big_code_editor:Hide()
				big_code_editor2:ClearFocus()
				big_code_editor2:Hide()
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
			end
			
			local addbutton = g:NewButton (frame16, nil, "$parentAddButton", "addbutton", 120, 20, add, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_ADD"], nil, options_button_template)
			addbutton:SetPoint ("bottomright", panel, "topright", -30, 0)
			addbutton:SetIcon ([[Interface\PaperDollInfoFrame\Character-Plus]], 12, 12, nil, nil, nil, 4)
			window:CreateLineBackground2 (frame16, "addbutton", "addbutton", nil, nil, {1, 0.8, 0}, button_color_rgb)
			addbutton:SetTextColor (button_color_rgb)
			
		--> open import panel button
		
			local importframe = g:NewSpecialLuaEditorEntry (frame16, 644, 402, "importEditor", "$parentImportEditor", true)
			local font, size, flag = importframe.editbox:GetFont()
			importframe.editbox:SetFont (font, 9, flag)
			importframe:SetPoint ("topleft", frame16, "topleft", 8, -70)
			importframe:SetFrameLevel (frame16:GetFrameLevel()+6)
			importframe:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
			DetailsFramework:ReskinSlider (importframe.scroll)
			importframe:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
			importframe:SetBackdropBorderColor (0, 0, 0, 1)
			importframe:Hide()
			
			local doimport = function()
				local text = importframe:GetText()
				
				text = DetailsFramework:Trim (text)

				local dataTable = Details:DecompressData (text, "print")
				if (dataTable) then
					local unserialize = dataTable
					
					if (type (unserialize) == "table") then
						if (unserialize[1] and unserialize[2] and unserialize[3] and unserialize[4] and unserialize[5]) then
							local register = _detalhes:TimeDataRegister (unpack (unserialize))
							if (type (register) == "string") then
								_detalhes:Msg (register)
							end
						else
							_detalhes:Msg (Loc ["STRING_OPTIONS_CHART_IMPORTERROR"])
						end
					else
						_detalhes:Msg (Loc ["STRING_OPTIONS_CHART_IMPORTERROR"])
					end
					
					importframe:Hide()
					panel:Refresh()
				else
					_detalhes:Msg (Loc ["STRING_CUSTOM_IMPORT_ERROR"])
					return
				end
			end
	
			local accept_import = g:NewButton (importframe, nil, "$parentAccept", "acceptButton", 120, 20, doimport)
			accept_import:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]])
			accept_import:SetPoint (10, 18)
			accept_import:SetText (Loc ["STRING_OPTIONS_CHART_IMPORT"])
			accept_import:SetTemplate (options_button_template)
			
			local cancelimport = function()
				importframe:ClearFocus()
				importframe:Hide()
			end
			
			local cancel_changes = g:NewButton (importframe, nil, "$parentCancel", "CancelButton", 120, 20, cancelimport)
			cancel_changes:SetIcon ([[Interface\PetBattles\DeadPetIcon]])
			cancel_changes:SetText (Loc ["STRING_OPTIONS_CHART_CANCEL"])
			cancel_changes:SetPoint (132, 18)
			cancel_changes:SetTemplate (options_button_template)
		
			local import = function() 
				importframe:Show()
				importframe:SetText ("")
				importframe:SetFocus (true)
				addframe:Hide()
				big_code_editor:ClearFocus()
				big_code_editor:Hide()
				big_code_editor2:ClearFocus()
				big_code_editor2:Hide()
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
			end
			
			local importbutton = g:NewButton (frame16, nil, "$parentImportButton", "importbutton", 120, 20, import, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_IMPORT"], nil, options_button_template)
			importbutton:SetPoint ("right", addbutton, "left", -4, 0)
			importbutton:SetIcon ([[Interface\Buttons\UI-GuildButton-PublicNote-Up]], 14, 14, nil, nil, nil, 4)
			window:CreateLineBackground2 (frame16, "importbutton", "importbutton", nil, nil, {1, 0.8, 0}, button_color_rgb)
			importbutton:SetTextColor (button_color_rgb)
	
		--> close button
			local closebutton = g:NewButton (addframe, nil, "$parentAddCloseButton", "addClosebutton", 120, 20, function() addframe:Hide() end, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_CLOSE"], nil, options_button_template)
			--closebutton:InstallCustomTexture()
			
		--> confirm add capture
			local addcapture = function()
				local name = capture_name_entry.text
				if (name == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_NAMEERROR"])
				end
				
				local author = capture_author_entry.text
				if (author == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_AUTHORERROR"])
				end
				
				local icon = capture_icon_button_icon.texture
				
				local version = capture_version_entry.text
				if (version == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_VERSIONERROR"])
				end
				
				local func = capture_func_entry:GetText()
				if (func == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_FUNCERROR"])
				end
				
				_detalhes:TimeDataRegister (name, func, nil, author, version, icon, true)
				
				panel:Refresh()
				
				capture_name_entry.text = ""
				capture_author_entry.text = ""
				capture_version_entry.text = ""
				capture_func_entry:SetText ("")
				capture_icon_button_icon.texture = [[Interface\ICONS\TEMP]]
				
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
				addframe:Hide()

			end
			
			local addcapturebutton = g:NewButton (addframe, nil, "$parentAddCaptureButton", "addCapturebutton", 120, 21, addcapture, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_ADD2"], nil, options_button_template)
	
		--> anchors
			local start = 25
			capture_name:SetPoint (start, window.title_y_pos)
			capture_icon:SetPoint (start, -55)
			capture_author:SetPoint (start, -80)
			capture_version:SetPoint (start, -105)
			capture_func:SetPoint (start, -130)
			
			addcapturebutton:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], 18, 18, nil, nil, nil, 4)
			closebutton:SetIcon ([[Interface\PetBattles\DeadPetIcon]], 14, 14, nil, nil, nil, 4)
			
			addcapturebutton:SetTemplate (options_button_template)
			closebutton:SetTemplate (options_button_template)
			
			window:CreateLineBackground2 (addframe.widget, closebutton, closebutton, nil, nil, {1, 0.8, 0}, button_color_rgb)
			closebutton:SetTextColor (button_color_rgb)
			
			window:CreateLineBackground2 (addframe.widget, addcapturebutton, addcapturebutton, nil, nil, {1, 0.8, 0}, button_color_rgb)
			addcapturebutton:SetTextColor (button_color_rgb)
			
			addcapturebutton:SetPoint ("bottomright", addframe, "bottomright", -5, 5)
			closebutton:SetPoint ("right", addcapturebutton, "left", -4, 0)			
	
	--> anchors
	
		titulo_datacharts:SetPoint (10, window.title_y_pos)
		titulo_datacharts_desc:SetPoint (10, window.title_y_pos2)
		
		panel:SetPoint (10, -70)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Settings - Custom Spells ~15
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame15()

	--> general settings:
		local frame15 = window.options [15][1]

	--> title
		local titulo_customspells = g:NewLabel (frame15, _, "$parentTituloCustomSpellsText", "customSpellsTextLabel", Loc ["STRING_OPTIONS_CUSTOMSPELLTITLE"], "GameFontNormal", 16)
		local titulo_customspells_desc = g:NewLabel (frame15, _, "$parentCustomSpellsText2", "customSpellsText2Label", Loc ["STRING_OPTIONS_CUSTOMSPELLTITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_customspells_desc.width = 350		
	
		local name_entry_func = function (index, text)
			_detalhes:UserCustomSpellUpdate (index, text) 
		end
		local icon_func = function (index, icon)
			_detalhes:UserCustomSpellUpdate (index, nil, icon)
		end
		local remove_func = function (index)
			_detalhes:UserCustomSpellRemove (index)
		end
		local reset_func = function (index)
			_detalhes:UserCustomSpellReset (index)
		end
	
	--> custom spells panel
		local header = {
			{name = Loc ["STRING_OPTIONS_SPELL_INDEX"], width = 55, type = "text"}, 
			{name = Loc ["STRING_OPTIONS_SPELL_NAME"], width = 310, type = "entry", func = name_entry_func}, 
			{name = Loc ["STRING_OPTIONS_SPELL_ICON"], width = 50, type = "icon", func = icon_func}, 
			{name = Loc ["STRING_OPTIONS_SPELL_SPELLID"], width = 100, type = "text"},
			{name = Loc ["STRING_OPTIONS_SPELL_RESET"], width = 50, type = "button", func = reset_func, icon = [[Interface\Buttons\UI-RefreshButton]], notext = true, iconalign = "center"}, 
			{name = Loc ["STRING_OPTIONS_SPELL_REMOVE"], width = 75, type = "button", func = remove_func, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], notext = true, iconalign = "center"}, 
		}
		--local header = {{name = "Index", type = "text"}, {name = "Name", type = "entry"}, {name = "Icon", type = "icon"}, {name = "Author", type = "text"}, {name = "Version", type = "text"}}
		
		local total_lines = function()
			return #_detalhes.savedCustomSpells
		end
		local fill_row = function (index)
			local data = _detalhes.savedCustomSpells [index]
			if (data) then
				return {index, data [2], data [3], data [1], ""}
			else
				return {nil, nil, nil, nil, nil}
			end
		end
		
		local panel = g:NewFillPanel (frame15, header, "$parentCustomSpellsFillPanel", "customSpellsFillPanel", 640, 382, total_lines, fill_row, false)
		panel:Refresh()
	
	--> add
		--> add panel
			local addframe = g:NewPanel (frame15, nil, "$parentCustomSpellsAddPanel", "customSpellsAddPanel", 644, 382)
			addframe:SetPoint (8, -80)
			addframe:SetFrameLevel (7)
			addframe:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
			addframe:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
			addframe:SetBackdropBorderColor (0, 0, 0, 1)
			addframe:Hide()			

			local spellid = g:NewLabel (addframe, nil, "$parentSpellidLabel", "spellidLabel", Loc ["STRING_OPTIONS_SPELL_ADDSPELLID"])
			local spellname = g:NewLabel (addframe, nil, "$parentSpellnameLabel", "spellnameLabel", Loc ["STRING_OPTIONS_SPELL_ADDNAME"])
			local spellicon = g:NewLabel (addframe, nil, "$parentSpelliconLabel", "spelliconLabel", Loc ["STRING_OPTIONS_SPELL_ADDICON"])
		
			local spellname_entry_func = function() end
			local spellname_entry = g:NewTextEntry (addframe, nil, "$parentSpellnameEntry", "spellnameEntry", 160, TEXTENTRY_HEIGHT, spellname_entry_func, nil, nil, nil, nil, options_dropdown_template)
			spellname_entry:SetPoint ("left", spellname, "right", 2, 0)

			local spellid_entry_func = function (arg1, arg2, spellid) 
				local spellname, _, icon = GetSpellInfo (spellid)
				if (spellname) then
					spellname_entry:SetText (spellname) 
					addframe.spellIconButton.icon.texture = icon
				else
					_detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_NOTFOUND"])
				end
			end
			local spellid_entry = g:NewSpellEntry (addframe, spellid_entry_func, 160, 20, nil, nil, "spellidEntry", "$parentSpellidEntry")
			spellid_entry:SetTemplate (options_dropdown_template)
			spellid_entry:SetPoint ("left", spellid, "right", 2, 0)
			
			local icon_button_func = function (texture)
				addframe.spellIconButton.icon.texture = texture
			end
			local icon_button = g:NewButton (addframe, nil, "$parentSpellIconButton", "spellIconButton", 20, 20, function() g:IconPick (icon_button_func, true) end)
			local icon_button_icon = g:NewImage (icon_button, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentSpellIcon")
			icon_button_icon:SetPoint (0, 0)
			icon_button:InstallCustomTexture()
			icon_button:SetPoint ("left", spellicon, "right", 2, 0)
			
		--> close button
			local closebutton = g:NewButton (addframe, nil, "$parentAddCloseButton", "addClosebutton", 120, 20, function() addframe:Hide() end, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_CLOSE"], nil, options_button_template)
			
			local bg = window:CreateLineBackground2 (addframe.widget, closebutton, closebutton, nil, nil, {1, 0.8, 0}, button_color_rgb)
			closebutton:SetTextColor (button_color_rgb)
			
		--> confirm add spell
			local addspell = function()
				local id = spellid_entry.text
				if (id == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_IDERROR"])
				end
				local name = spellname_entry.text
				if (name == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_NAMEERROR"])
				end
				local icon = addframe.spellIconButton.icon.texture
				
				id = tonumber (id)
				if (not id) then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_IDERROR"])
				end
				
				_detalhes:UserCustomSpellAdd (id, name, icon)
				
				panel:Refresh()
				
				spellid_entry.text = ""
				spellname_entry.text = ""
				addframe.spellIconButton.icon.texture = [[Interface\ICONS\TEMP]]
				
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
				addframe:Hide();
			end
			
			local addspellbutton = g:NewButton (addframe, nil, "$parentAddSpellButton", "addSpellbutton", 120, 20, addspell, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_ADD"], nil, options_button_template)
			local bg2 = window:CreateLineBackground2 (addframe.widget, addspellbutton, addspellbutton, nil, nil, {1, 0.8, 0}, button_color_rgb)
			addspellbutton:SetTextColor (button_color_rgb)
			bg:SetFrameLevel (bg2:GetFrameLevel()-1)

			addspellbutton:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], 18, 18, nil, nil, nil, 4)
			closebutton:SetIcon ([[Interface\PetBattles\DeadPetIcon]], 14, 14, nil, nil, nil, 4)
			
			addspellbutton:SetPoint ("bottomright", addframe, "bottomright", -5, 5)
			closebutton:SetPoint ("right", addspellbutton, "left", -4, 0)

			spellid:SetPoint (50, -10)
			spellname:SetPoint (50, -35)
			spellicon:SetPoint (50, -60)
		
		--> open add panel button
			local add = function() 
				addframe:Show()
			end
			local addbutton = g:NewButton (frame15, nil, "$parentAddButton", "addbutton", 120, 20, add, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_ADDSPELL"], nil, options_button_template)
			window:CreateLineBackground2 (frame15, "addbutton", "addbutton", nil, nil, {1, 0.8, 0}, button_color_rgb)
			addbutton:SetTextColor (button_color_rgb)
			addbutton:SetPoint ("bottomright", panel, "topright", -00, 1)
			addbutton:SetIcon ([[Interface\PaperDollInfoFrame\Character-Plus]], 12, 12, nil, nil, nil, 4)
	
	--> anchors
	
		titulo_customspells:SetPoint (10, window.title_y_pos)
		titulo_customspells_desc:SetPoint (10, window.title_y_pos2)
		panel:SetPoint (10, -80)
		
	--> consilidade spells
		g:NewLabel (frame15, _, "$parentConsolidadeSpellsLabel", "ConsolidadeSpellsLabel", Loc ["STRING_OPTIONSMENU_SPELLS_CONSOLIDATE"], "GameFontHighlightLeft")
		g:NewSwitch (frame15, _, "$parentConsolidadeSpellsSwitch", "ConsolidadeSpellsSwitch", 60, 20, nil, nil, _detalhes.override_spellids, nil, nil, nil, nil, options_switch_template)
		frame15.ConsolidadeSpellsLabel:SetPoint ("left", frame15.ConsolidadeSpellsSwitch, "right", 3)
		frame15.ConsolidadeSpellsSwitch:SetAsCheckBox()
		frame15.ConsolidadeSpellsSwitch.OnSwitch = function (self, instance, value)
			_detalhes.override_spellids = value
			_detalhes:UpdateParserGears()
		end
		window:CreateLineBackground2 (frame15, "ConsolidadeSpellsSwitch", "ConsolidadeSpellsLabel", "")
		frame15.ConsolidadeSpellsSwitch:SetPoint (10, -55)
		_detalhes:SetFontSize (frame15.ConsolidadeSpellsLabel, 12)
end

		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Settings - title bar text ~14
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame14()

	--> general settings:
		local frame14 = window.options [14][1]

		local titulo_attributetext = g:NewLabel (frame14, _, "$parentTituloAttributeText", "attributeTextLabel", Loc ["STRING_OPTIONS_ATTRIBUTE_TEXT"], "GameFontNormal", 16)
		local titulo_attributetext_desc = g:NewLabel (frame14, _, "$parentAttributeText2", "attributeText2Label", Loc ["STRING_OPTIONS_ATTRIBUTE_TEXT_DESC"], "GameFontNormal", 10, "white")
		titulo_attributetext_desc.width = 350
		
--attribute text
	
	--enabled
		g:NewLabel (frame14, _, "$parentAttributeEnabledLabel", "attributeEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame14, _, "$parentAttributeEnabledSwitch", "attributeEnabledSwitch", 60, 20, nil, nil, instance.attribute_text.enabled, nil, nil, nil, nil, options_switch_template)
		frame14.attributeEnabledSwitch:SetPoint ("left", frame14.attributeEnabledLabel, "right", 2)
		frame14.attributeEnabledSwitch:SetAsCheckBox()
		frame14.attributeEnabledSwitch.OnSwitch = function (self, instance, value)
			instance:AttributeMenu (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame14, "attributeEnabledSwitch", "attributeEnabledLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED_DESC"])
	
	--anchors
		g:NewLabel (frame14, _, "$parentAttributeAnchorXLabel", "attributeAnchorXLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX"], "GameFontHighlightLeft")
		g:NewLabel (frame14, _, "$parentAttributeAnchorYLabel", "attributeAnchorYLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame14, _, "$parentAttributeAnchorXSlider", "attributeAnchorXSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -20, 300, 1, instance.attribute_text.anchor [1], nil, nil, nil, options_slider_template)
		--config_slider (s)
		s:SetThumbSize (24)
		local s = g:NewSlider (frame14, _, "$parentAttributeAnchorYSlider", "attributeAnchorYSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -100, 50, 1, instance.attribute_text.anchor [2], nil, nil, nil, options_slider_template)
		--config_slider (s)
		--s:SetThumbSize (28)
		
		frame14.attributeAnchorXSlider:SetPoint ("left", frame14.attributeAnchorXLabel, "right", 2)
		frame14.attributeAnchorYSlider:SetPoint ("left", frame14.attributeAnchorYLabel, "right", 2)
		
		frame14.attributeAnchorXSlider:SetHook ("OnValueChange", function (self, instance, amount) 
			instance:AttributeMenu (nil, amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		frame14.attributeAnchorYSlider:SetHook ("OnValueChange", function (self, instance, amount) 
			instance:AttributeMenu (nil, nil, amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame14, "attributeAnchorXSlider", "attributeAnchorXLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX_DESC"])
		window:CreateLineBackground2 (frame14, "attributeAnchorYSlider", "attributeAnchorYLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY_DESC"])
		
	--font
		local on_select_attribute_font = function (self, instance, fontName)
			instance:AttributeMenu (nil, nil, nil, fontName)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, fontName)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local build_font_menu = function() 
			local fonts = {}
			for name, fontPath in pairs (SharedMedia:HashTable ("font")) do 
				fonts [#fonts+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = on_select_attribute_font, font = fontPath, descfont = name, desc = "Our thoughts strayed constantly\nAnd without boundary\nThe ringing of the division bell had began."}
			end
			table.sort (fonts, function (t1, t2) return t1.label < t2.label end)
			return fonts 
		end

		g:NewLabel (frame14, _, "$parentAttributeFontLabel", "attributeFontLabel", Loc ["STRING_OPTIONS_TEXT_FONT"], "GameFontHighlightLeft")
		local d = g:NewDropDown (frame14, _, "$parentAttributeFontDropdown", "attributeFontDropdown", DROPDOWN_WIDTH, dropdown_height, build_font_menu, instance.attribute_text.text_face, options_dropdown_template)
		
		frame14.attributeFontDropdown:SetPoint ("left", frame14.attributeFontLabel, "right", 2)
		
		window:CreateLineBackground2 (frame14, "attributeFontDropdown", "attributeFontLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_FONT_DESC"])
		
	--size
		g:NewLabel (frame14, _, "$parentAttributeTextSizeLabel", "attributeTextSizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame14, _, "$parentAttributeTextSizeSlider", "attributeTextSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 5, 32, 1, tonumber ( instance.attribute_text.text_size), nil, nil, nil, options_slider_template)
		--config_slider (s)
	
		frame14.attributeTextSizeSlider:SetPoint ("left", frame14.attributeTextSizeLabel, "right", 2)
	
		frame14.attributeTextSizeSlider:SetHook ("OnValueChange", function (self, instance, amount) 
			instance:AttributeMenu (nil, nil, nil, nil, amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, nil, amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame14, "attributeTextSizeSlider", "attributeTextSizeLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE_DESC"])
		
	--color
		local attribute_text_color_callback = function (button, r, g, b, a)
		
			local instance = _G.DetailsOptionsWindow.instance
		
			instance:AttributeMenu (nil, nil, nil, nil, nil, {r, g, b, a})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, nil, nil, {r, g, b, a})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame14, "$parentAttributeTextColorPick", "attributeTextColorPick", attribute_text_color_callback, nil, options_button_template)
		g:NewLabel (frame14, _, "$parentAttributeTextColorLabel", "attributeTextColorLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR"], "GameFontHighlightLeft")
		
		frame14.attributeTextColorPick:SetPoint ("left", frame14.attributeTextColorLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame14, "attributeTextColorPick", "attributeTextColorLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR_DESC"])
	
	--shadow
		g:NewLabel (frame14, _, "$parentAttributeShadowLabel", "attributeShadowLabel", Loc ["STRING_OPTIONS_TEXT_LOUTILINE"], "GameFontHighlightLeft")
		g:NewSwitch (frame14, _, "$parentAttributeShadowSwitch", "attributeShadowSwitch", 60, 20, nil, nil, instance.attribute_text.shadow, nil, nil, nil, nil, options_switch_template)
		frame14.attributeShadowSwitch:SetPoint ("left", frame14.attributeShadowLabel, "right", 2)
		frame14.attributeShadowSwitch:SetAsCheckBox()
		frame14.attributeShadowSwitch.OnSwitch = function (self, instance, value)
			instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame14, "attributeShadowSwitch", "attributeShadowLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW_DESC"])
	
	--side
		local side_switch_func = function (slider, value) if (value == 2) then return false elseif (value == 1) then return true end end
		local side_return_func = function (slider, value) if (value) then return 1 else return 2 end end
		
		g:NewLabel (frame14, _, "$parentAttributeSideLabel", "attributeSideLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE"], "GameFontHighlightLeft")
		g:NewSwitch (frame14, _, "$parentAttributeSideSwitch", "attributeSideSwitch", 80, 20, "bottom", "top", instance.attribute_text.side, nil, side_switch_func, side_return_func, nil, options_switch_template)
		frame14.attributeSideSwitch:SetPoint ("left", frame14.attributeSideLabel, "right", 2)
		frame14.attributeSideSwitch:SetAsCheckBox()
		frame14.attributeSideSwitch.OnSwitch = function (self, instance, value)
			instance:AttributeMenu (nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--frame14.attributeSideSwitch:SetThumbSize (50)
		window:CreateLineBackground2 (frame14, "attributeSideSwitch", "attributeSideLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE_DESC"])

	--show timer
		--for encounters
		
		g:NewLabel (frame14, _, "$parentAttributeEncounterTimerLabel", "AttributeEncounterTimerLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER"], "GameFontHighlightLeft")
		g:NewSwitch (frame14, _, "$parentAttributeEncounterTimerSwitch", "AttributeEncounterTimerSwitch", 60, 20, nil, nil, instance.attribute_text.show_timer [1], nil, nil, nil, nil, options_switch_template)
		frame14.AttributeEncounterTimerSwitch:SetPoint ("left", frame14.AttributeEncounterTimerLabel, "right", 2)
		frame14.AttributeEncounterTimerSwitch:SetAsCheckBox()
		frame14.AttributeEncounterTimerSwitch.OnSwitch = function (self, instance, value)
			instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, nil, value)
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:AttributeMenu (nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame14, "AttributeEncounterTimerSwitch", "AttributeEncounterTimerLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER_DESC"])
		
		--general anchor
		g:NewLabel (frame14, _, "$parentAttributeTextTextAnchor", "TextAnchorLabel", Loc ["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"], "GameFontNormal")
		g:NewLabel (frame14, _, "$parentAttributeTextSettingsAnchor", "SettingsAnchorLabel", Loc ["STRING_OPTIONS_MENU_ATTRIBUTESETTINGS_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame14, _, "$parentLayoutSettingsAnchor", "LayoutAnchorLabel", Loc ["STRING_OPTIONS_ROW_SETTING_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_attributetext:SetPoint (x, window.title_y_pos)
		titulo_attributetext_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"SettingsAnchorLabel", 1, true},
			{"attributeEnabledLabel", 2},
			{"AttributeEncounterTimerLabel", 2},
			
			{"LayoutAnchorLabel", 3, true},
			
			{"attributeAnchorXLabel", 5},
			{"attributeAnchorYLabel", 6},
			{"attributeSideLabel", 7},

			{"TextAnchorLabel", 8, true},
			{"attributeTextColorLabel", 9},
			{"attributeTextSizeLabel", 10},
			{"attributeFontLabel", 11},
			{"attributeShadowLabel", 12},
		}
		
		window:arrange_menu (frame14, left_side, x, window.top_start_at)

	
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Settings - Display ~1 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame1()

	--> general settings:
		local frame1 = window.options [1][1]

	--> nickname avatar
		local onPressEnter = function (_, _, text)
			local accepted, errortext = _detalhes:SetNickname (text)
			if (not accepted) then
				_detalhes:Msg (errortext)
			end
			--> we call again here, because if not accepted the box return the previous value and if successful accepted, update the value for formated string.
			local nick = _detalhes:GetNickname (UnitName ("player"), UnitName ("player"), true)

			frame1.nicknameEntry.text = nick
			_G.DetailsOptionsWindow1AvatarNicknameLabel:SetText (nick)
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local titulo_persona = g:NewLabel (frame1, _, "$parentTituloPersona", "tituloPersonaLabel", Loc ["STRING_OPTIONS_SOCIAL"], "GameFontNormal", 16)
		local titulo_persona_desc = g:NewLabel (frame1, _, "$parentTituloPersona2", "tituloPersona2Label", Loc ["STRING_OPTIONS_SOCIAL_DESC"], "GameFontNormal", 10, "white")
		titulo_persona_desc.width = 350
		
	--> persona
		
		frame1.HaveAvatar = false
		
		g:NewLabel (frame1, _, "$parentNickNameLabel", "nicknameLabel", Loc ["STRING_OPTIONS_NICKNAME"], "GameFontHighlightLeft")
		
		local avatar_x_anchor2 = window.right_start_at - 15
		
		local box = g:NewTextEntry (frame1, _, "$parentNicknameEntry", "nicknameEntry", SLIDER_WIDTH, TEXTENTRY_HEIGHT, onPressEnter, nil, nil, nil, nil, options_dropdown_template)
		box:SetFontObject ("SystemFont_Outline_Small")
		
		--create a reset nickname button
			g:NewButton (box, _, "$parentResetNicknameButton", "resetNicknameButton", 16, 16, function()
				Details:ResetPlayerPersona()
				local playerName = UnitName ("player")
				local playerPersona = Details:GetNicknameTable (playerName)
				
				if (playerPersona) then
					box:SetText (playerPersona[1])
				end
			end)
			frame1.resetNicknameButton = box.resetNicknameButton
			frame1.resetNicknameButton:SetPoint ("left", box, "right", 0, 0)
			frame1.resetNicknameButton:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
			frame1.resetNicknameButton:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
			frame1.resetNicknameButton:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
			frame1.resetNicknameButton:GetNormalTexture():SetDesaturated (true)
			frame1.resetNicknameButton.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		---------
			
		frame1.nicknameEntry:SetPoint ("left", frame1.nicknameLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame1, "nicknameEntry", "nicknameLabel", Loc ["STRING_OPTIONS_NICKNAME_DESC"])
		
		local avatarcallback = function (textureAvatar, textureAvatarTexCoord, textureBackground, textureBackgroundTexCoord, textureBackgroundColor)
			_detalhes:SetNicknameBackground (textureBackground, textureBackgroundTexCoord, textureBackgroundColor, true)
			_detalhes:SetNicknameAvatar (textureAvatar, textureAvatarTexCoord)

			_G.DetailsOptionsWindow1AvatarPreviewTexture.MyObject.texture = textureAvatar
			_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject.texture = textureBackground
			_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject.texcoord =  textureBackgroundTexCoord
			_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject:SetVertexColor (unpack (textureBackgroundColor))
			
			if (not textureAvatar:find ("UI%-EJ%-BOSS%-Default")) then
				_G.DetailsOptionsWindow1.ChooseAvatarLabel:SetTextColor (1, 0.93, 0.74, 0)
				_G.DetailsOptionsWindow1.HaveAvatar = true
			else
				_G.DetailsOptionsWindow1.ChooseAvatarLabel:SetTextColor (1, 0.93, 0.74)
				_G.DetailsOptionsWindow1.HaveAvatar = false
			end
			
			_G.AvatarPickFrame.callback = nil
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local openAtavarPickFrame = function()
			_G.AvatarPickFrame.callback = avatarcallback
			_G.AvatarPickFrame:Show()
		end
		
		g:NewButton (frame1, _, "$parentAvatarFrame", "chooseAvatarButton", 275, 85, openAtavarPickFrame, nil, nil, nil, "", 1)
		frame1.chooseAvatarButton:SetTextColor (button_color_rgb)
		
		g:NewLabel (frame1, _, "$parentChooseAvatarLabel", "ChooseAvatarLabel", Loc ["STRING_OPTIONS_AVATAR"], "GameFontHighlightLeft")
		frame1.ChooseAvatarLabel:SetPoint ("topright", frame1.chooseAvatarButton, "topright", -50, -35)
		frame1.ChooseAvatarLabel:SetTextColor (button_color_rgb)

	--> avatar preview
		g:NewImage (frame1, nil, 128, 64, nil, nil, "avatarPreview", "$parentAvatarPreviewTexture")
		g:NewImage (frame1, nil, 275, 60, nil, nil, "avatarPreview2", "$parentAvatarPreviewTexture2")
		g:NewLabel (frame1, _, "$parentAvatarNicknameLabel", "avatarNickname", UnitName ("player"), "GameFontHighlightSmall")		
	
	--> avatar button
		frame1.chooseAvatarButton:SetHook ("OnEnter", function()
			if (not frame1.HaveAvatar) then
				frame1.ChooseAvatarLabel:SetTextColor (1, 1, 1)
			end
			
			GameCooltip:Preset (2)
			GameCooltip:AddLine (Loc ["STRING_OPTIONS_AVATAR_DESC"])
			GameCooltip:ShowCooltip (frame1.chooseAvatarButton.widget, "tooltip")
			--frame1.avatarPreview:SetBlendMode ("ADD")
			frame1.avatarPreview2:SetBlendMode ("ADD")
			return true
		end)
		frame1.chooseAvatarButton:SetHook ("OnLeave", function()
			if (not frame1.HaveAvatar) then
				frame1.ChooseAvatarLabel:SetTextColor (button_color_rgb)
			end
			
			GameCooltip:Hide()
			--frame1.avatarPreview:SetBlendMode ("BLEND")
			frame1.avatarPreview2:SetBlendMode ("BLEND")
			return true
		end)
		frame1.chooseAvatarButton:SetHook ("OnMouseDown", function()
			frame1.avatarPreview:SetPoint (avatar_x_anchor2+2, -138)
			frame1.avatarPreview2:SetPoint (avatar_x_anchor2+2, -140)
			frame1.avatarNickname:SetPoint (avatar_x_anchor2+110, -172)
			frame1.ChooseAvatarLabel:SetPoint ("topright", frame1.chooseAvatarButton, "topright", -49, -36)
		end)
		frame1.chooseAvatarButton:SetHook ("OnMouseUp", function()
			frame1.avatarPreview:SetPoint (avatar_x_anchor2+1, -137)
			frame1.avatarPreview2:SetPoint (avatar_x_anchor2+1, -139)
			frame1.avatarNickname:SetPoint (avatar_x_anchor2+109, -171)
			frame1.ChooseAvatarLabel:SetPoint ("topright", frame1.chooseAvatarButton, "topright", -50, -35)
		end)
		
		--window:CreateLineBackground2 (frame1, "chooseAvatarButton", "chooseAvatarButton", Loc ["STRING_OPTIONS_AVATAR_DESC"], nil, {1, 0.8, 0}, button_color_rgb)

		_detalhes:SetFontSize (frame1.avatarNickname.widget, 18)
		
		frame1.avatarPreview:SetDrawLayer ("overlay", 3)
		frame1.avatarNickname:SetDrawLayer ("overlay", 3)
		frame1.avatarPreview2:SetDrawLayer ("overlay", 2)
		
	-->  ignore nicknames --------------------------------------------------------------------------------------------------------------------------------------------

		g:NewLabel (frame1, _, "$parentIgnoreNicknamesLabel", "IgnoreNicknamesLabel", Loc ["STRING_OPTIONS_IGNORENICKNAME"], "GameFontHighlightLeft")
		g:NewSwitch (frame1, _, "$parentIgnoreNicknamesSlider", "IgnoreNicknamesSlider", 60, 20, _, _, _detalhes.ignore_nicktag, nil, nil, nil, nil, options_switch_template)
		frame1.IgnoreNicknamesSlider:SetPoint ("left", frame1.IgnoreNicknamesLabel, "right", 2)
		
		if (not frame1.IgnoreNicknamesSlider.SetAsCheckBox) then
			print ("================")
			print ("================")
			print ("Details!: |cFFFFFF00A very old Framework version is installed by another addon, please update (if you have any of these installed): |cFFFFFFFFIskarAssist|r, |cFFFFFFFFSalvageYardSeller|r, |cFFFFFFFFHansgar&Franzok Assist|r and |cFFFFFFFFFlashTaskbar|r.|r")
			print ("================")
			print ("================")
		end
		
		frame1.IgnoreNicknamesSlider:SetAsCheckBox()

		frame1.IgnoreNicknamesSlider.OnSwitch = function (self, _, value)
			_detalhes.ignore_nicktag = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame1, "IgnoreNicknamesSlider", "IgnoreNicknamesLabel", Loc ["STRING_OPTIONS_IGNORENICKNAME_DESC"])
		
	-->  realm name --------------------------------------------------------------------------------------------------------------------------------------------

		g:NewLabel (frame1, _, "$parentRealmNameLabel", "realmNameLabel", Loc ["STRING_OPTIONS_REALMNAME"], "GameFontHighlightLeft")
		g:NewSwitch (frame1, _, "$parentRealmNameSlider", "realmNameSlider", 60, 20, _, _, _detalhes.remove_realm_from_name, nil, nil, nil, nil, options_switch_template)
		frame1.realmNameSlider:SetPoint ("left", frame1.realmNameLabel, "right", 2)
		frame1.realmNameSlider:SetAsCheckBox()

		frame1.realmNameSlider.OnSwitch = function (self, _, value)
			_detalhes.remove_realm_from_name = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame1, "realmNameSlider", "realmNameLabel", Loc ["STRING_OPTIONS_REALMNAME_DESC"])

	--> Segments Locked
	
		g:NewLabel (frame1, _, "$parentSegmentsLockedLabel", "SegmentsLockedLabel", Loc ["STRING_OPTIONS_LOCKSEGMENTS"], "GameFontHighlightLeft")
		g:NewSwitch (frame1, _, "$parentSegmentsLockedSlider", "SegmentsLockedSlider", 60, 20, _, _, _detalhes.instances_segments_locked, nil, nil, nil, nil, options_switch_template)
		frame1.SegmentsLockedSlider:SetAsCheckBox()
		frame1.SegmentsLockedSlider:SetPoint ("left", frame1.SegmentsLockedLabel, "right", 2)

		frame1.SegmentsLockedSlider.OnSwitch = function (self, _, value)
			_detalhes.instances_segments_locked = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame1, "SegmentsLockedSlider", "SegmentsLockedLabel", Loc ["STRING_OPTIONS_LOCKSEGMENTS_DESC"])
	
	--> wheel speed
		g:NewLabel (frame1, _, "$parentWheelSpeedLabel", "WheelSpeedLabel", Loc ["STRING_OPTIONS_WHEEL_SPEED"], "GameFontHighlightLeft")
		--
		
		local s = g:NewSlider (frame1, _, "$parentWheelSpeedSlider", "WheelSpeedSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 3, 1, _detalhes.scroll_speed, nil, nil, nil, options_slider_template)
		--config_slider (s)
		
		frame1.WheelSpeedSlider:SetPoint ("left", frame1.WheelSpeedLabel, "right", 2, -1)
		frame1.WheelSpeedSlider:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.scroll_speed = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame1, "WheelSpeedSlider", "WheelSpeedLabel", Loc ["STRING_OPTIONS_WHEEL_SPEED_DESC"])
		
	--> Max Instances
		g:NewLabel (frame1, _, "$parentLabelMaxInstances", "maxInstancesLabel", Loc ["STRING_OPTIONS_MAXINSTANCES"], "GameFontHighlightLeft")
		--
		local s = g:NewSlider (frame1, _, "$parentSliderMaxInstances", "maxInstancesSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 30, 1, _detalhes.instances_amount, nil, nil, nil, options_slider_template)
		--config_slider (s)
		
		frame1.maxInstancesSlider:SetPoint ("left", frame1.maxInstancesLabel, "right", 2, -1)
		frame1.maxInstancesSlider:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.instances_amount = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame1, "maxInstancesSlider", "maxInstancesLabel", Loc ["STRING_OPTIONS_MAXINSTANCES_DESC"])

	--> Abbreviation Type
		g:NewLabel (frame1, _, "$parentDpsAbbreviateLabel", "dpsAbbreviateLabel", Loc ["STRING_OPTIONS_PS_ABBREVIATE"], "GameFontHighlightLeft")
		--
		local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
			_detalhes.ps_abbreviation = abbreviationtype
			
			_detalhes:UpdateToKFunctions()
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		local icon = [[Interface\COMMON\mini-hourglass]]
		local iconcolor = {1, 1, 1, .5}
		local iconsize = {14, 14}
		local abbreviationOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = Loc ["STRING_EXAMPLE"] .. ": 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
		}
		local buildAbbreviationMenu = function()
			return abbreviationOptions
		end
		
		local d = g:NewDropDown (frame1, _, "$parentAbbreviateDropdown", "dpsAbbreviateDropdown", 160, dropdown_height, buildAbbreviationMenu, _detalhes.ps_abbreviation, options_dropdown_template)
		frame1.dpsAbbreviateDropdown:SetPoint ("left", frame1.dpsAbbreviateLabel, "right", 2, 0)		
		window:CreateLineBackground2 (frame1, "dpsAbbreviateDropdown", "dpsAbbreviateLabel", Loc ["STRING_OPTIONS_PS_ABBREVIATE_DESC"])
		
	
	--> avatar
	
		local avatar = NickTag:GetNicknameAvatar (UnitName ("player"), NICKTAG_DEFAULT_AVATAR, true)
		local background, cords, color = NickTag:GetNicknameBackground (UnitName ("player"), NICKTAG_DEFAULT_BACKGROUND, NICKTAG_DEFAULT_BACKGROUND_CORDS, {1, 1, 1, 1}, true)
		
		frame1.avatarPreview.texture = avatar
		frame1.avatarPreview2.texture = background
		frame1.avatarPreview2.texcoord = cords
		frame1.avatarPreview2:SetVertexColor (unpack (color))

	--> numerical system
		g:NewLabel (frame1, _, "$parentNumericalSystemLabel", "NumericalSystemLabel", Loc ["STRING_NUMERALSYSTEM"], "GameFontHighlightLeft")
		
		local onSelectNumeralSystem = function (_, _, systemNumber)
			_detalhes:SelectNumericalSystem (systemNumber)
		end
		
		local asian1K, asian10K, asian1B = _detalhes.gump:GetAsianNumberSymbols()
		local asianNumerals = {value = 2, label = Loc ["STRING_NUMERALSYSTEM_MYRIAD_EASTASIA"], desc = "1" .. asian1K .. " = 1.000 \n1" .. asian10K .. " = 10.000 \n10" .. asian10K .. " = 100.000 \n100" .. asian10K .. " = 1.000.000", onclick = onSelectNumeralSystem, icon = icon, iconcolor = iconcolor, iconsize = iconsize}
		
		--> if region is western it'll be using Korean symbols, set a font on the dropdown so it won't show ?????
		local clientRegion = _detalhes.gump:GetClientRegion()
		if (clientRegion == "western" or clientRegion == "russia") then
			asianNumerals.descfont = _detalhes.gump:GetBestFontForLanguage ("koKR")
		end

		local numeralSystems = {
			{value = 1, label = Loc ["STRING_NUMERALSYSTEM_ARABIC_WESTERN"], desc = "1K = 1.000 \n10K = 10.000 \n100K = 100.000 \n1M = 1.000.000", onclick = onSelectNumeralSystem, icon = icon, iconcolor = iconcolor, iconsize = iconsize},
			asianNumerals
		}
		
		local buildNumeralSystemsMenu = function()
			return numeralSystems
		end
		
		local d = g:NewDropDown (frame1, _, "$parentNumericalSystemOfADropdown", "NumericalSystemDropdown", 160, dropdown_height, buildNumeralSystemsMenu, _detalhes.numerical_system, options_dropdown_template)
		d:SetPoint ("left", frame1.NumericalSystemLabel, "right", 2, 0)		
		window:CreateLineBackground2 (frame1, "NumericalSystemDropdown", "NumericalSystemLabel", Loc ["STRING_NUMERALSYSTEM_DESC"])
		
	--> animate bars 
	
		g:NewLabel (frame1, _, "$parentAnimateLabel", "animateLabel", Loc ["STRING_OPTIONS_ANIMATEBARS"], "GameFontHighlightLeft")

		g:NewSwitch (frame1, _, "$parentAnimateSlider", "animateSlider", 60, 20, _, _, _detalhes.use_row_animations, nil, nil, nil, nil, options_switch_template)
		frame1.animateSlider:SetAsCheckBox()
		
		frame1.animateSlider:SetPoint ("left",frame1.animateLabel, "right", 2, 0)
		frame1.animateSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
			_detalhes:SetUseAnimations (value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame1, "animateSlider", "animateLabel", Loc ["STRING_OPTIONS_ANIMATEBARS_DESC"])
		
	--> update speed

		local s = g:NewSlider (frame1, _, "$parentSliderUpdateSpeed", "updatespeedSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0.05, 3, 0.05, _detalhes.update_speed, true, nil, nil, options_slider_template)
		--config_slider (s)
		
		g:NewLabel (frame1, _, "$parentUpdateSpeedLabel", "updatespeedLabel", Loc ["STRING_OPTIONS_WINDOWSPEED"], "GameFontHighlightLeft")
		--
		frame1.updatespeedSlider:SetPoint ("left", frame1.updatespeedLabel, "right", 2, -1)
		frame1.updatespeedSlider:SetThumbSize (28)
		frame1.updatespeedSlider.useDecimals = true
		local updateColor = function (slider, value)
			if (value < 1) then
				slider.amt:SetTextColor (1, value, .2)
			elseif (value > 1) then
				slider.amt:SetTextColor (-(value-3), 1, 0)
			else
				slider.amt:SetTextColor (1, 1, 0)
			end
		end
		
		frame1.updatespeedSlider:SetHook ("OnValueChange", function (self, _, amount) 
			_detalhes:SetWindowUpdateSpeed (amount)
			updateColor (self, amount)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		updateColor (frame1.updatespeedSlider, _detalhes.update_speed)
		
		window:CreateLineBackground2 (frame1, "updatespeedSlider", "updatespeedLabel", Loc ["STRING_OPTIONS_WINDOWSPEED_DESC"])
		
	--> window controls
		
		
		
		--lock unlock
			g:NewButton (frame1, _, "$parentLockButton", "LockButton", window.buttons_width, window.buttons_height, _detalhes.lock_instance_function, true, true, nil, Loc ["STRING_OPTIONS_WC_LOCK"], 1, options_button_template)
			--frame1.LockButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)

			window:CreateLineBackground2 (frame1, "LockButton", "LockButton", Loc ["STRING_OPTIONS_WC_LOCK_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.LockButton:SetIcon ([[Interface\PetBattles\PetBattle-LockIcon]], nil, nil, nil, {0.0703125, 0.9453125, 0.0546875, 0.9453125}, nil, nil, 2)
			frame1.LockButton:SetTextColor (button_color_rgb)
			
		--break snap
			g:NewButton (frame1, _, "$parentBreakSnapButton", "BreakSnapButton", window.buttons_width, window.buttons_height, _G.DetailsOptionsWindow.instance.Desagrupar, -1, nil, nil, Loc ["STRING_OPTIONS_WC_UNSNAP"], 1, options_button_template)
			--frame1.BreakSnapButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			
			window:CreateLineBackground2 (frame1, "BreakSnapButton", "BreakSnapButton", Loc ["STRING_OPTIONS_WC_UNSNAP_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.BreakSnapButton:SetIcon ([[Interface\AddOns\Details\images\icons]], nil, nil, nil, {160/512, 179/512, 142/512, 162/512}, nil, nil, 2)
			frame1.BreakSnapButton:SetTextColor (button_color_rgb)

		--close
			g:NewButton (frame1, _, "$parentCloseButton", "CloseButton", window.buttons_width, window.buttons_height, _detalhes.close_instancia_func, _G.DetailsOptionsWindow.instance, nil, nil, Loc ["STRING_OPTIONS_WC_CLOSE"], 1, options_button_template)
			--frame1.CloseButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			window:CreateLineBackground2 (frame1, "CloseButton", "CloseButton", Loc ["STRING_OPTIONS_WC_CLOSE_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.CloseButton:SetIcon ([[Interface\Buttons\UI-Panel-MinimizeButton-Up]], nil, nil, nil, {0.143125, 0.8653125, 0.1446875, 0.8653125}, nil, nil, 2)
			frame1.CloseButton:SetTextColor (button_color_rgb)
			
		--create
			g:NewButton (frame1, _, "$parentCreateWindowButton", "CreateWindowButton", window.buttons_width, window.buttons_height, function() _detalhes.CriarInstancia (nil, nil, true) end, nil, nil, nil, Loc ["STRING_OPTIONS_WC_CREATE"], 1, options_button_template)
			--frame1.CreateWindowButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			
			window:CreateLineBackground2 (frame1, "CreateWindowButton", "CreateWindowButton", Loc ["STRING_OPTIONS_WC_CREATE_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.CreateWindowButton:SetIcon ([[Interface\Buttons\UI-AttributeButton-Encourage-Up]], nil, nil, nil, nil, nil, nil, 2)
			frame1.CreateWindowButton:SetTextColor (button_color_rgb)
			
		--set window color
			local windowcolor_callback = function (button, r, g, b, a)
			
				local instance = _G.DetailsOptionsWindow.instance
			
				if (instance.menu_alpha.enabled and a ~= instance.color[4]) then
					_detalhes:Msg (Loc ["STRING_OPTIONS_MENU_ALPHAWARNING"])
					_G.DetailsOptionsWindow6StatusbarColorPick.MyObject:SetColor (r, g, b, instance.menu_alpha.onleave)
					instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
							end
						end
					end
					
					return
				end
				
				_G.DetailsOptionsWindow6StatusbarColorPick.MyObject:SetColor (r, g, b, a)
				instance:InstanceColor (r, g, b, a, nil, true)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceColor (r, g, b, a, nil, true)
						end
					end
				end
				
			end
			local change_color = function()
				local r, g, b, a = unpack (_G.DetailsOptionsWindow.instance.color)
				_detalhes.gump:ColorPick (_G.DetailsOptionsWindow1SetWindowColorButton, r, g, b, a, windowcolor_callback)
			end
		
			g:NewButton (frame1, _, "$parentSetWindowColorButton", "SetWindowColorButton", window.buttons_width, window.buttons_height, change_color, nil, nil, nil, Loc ["STRING_OPTIONS_CHANGECOLOR"], 1, options_button_template)
			--frame1.SetWindowColorButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			
			window:CreateLineBackground2 (frame1, "SetWindowColorButton", "SetWindowColorButton", "Shortcut to modify the window color.\nFor more options check out |cFFFFFF00Window Settings|r section.", nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.SetWindowColorButton:SetIcon ([[Interface\AddOns\Details\images\icons]], 10, 10, nil, {0.640625, 0.6875, 0.630859375, 0.677734375}, nil, nil, 4)
			frame1.SetWindowColorButton:SetTextColor (button_color_rgb)
			
		--erase data
			g:NewLabel (frame1, _, "$parentEraseDataLabel", "EraseDataLabel", Loc ["STRING_OPTIONS_ED"], "GameFontHighlightLeft")
			--
			local OnSelectEraseData = function (_, _, EraseType)
				_detalhes.segments_auto_erase = EraseType
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local EraseDataOptions = {
				{value = 1, label = Loc ["STRING_OPTIONS_ED1"], onclick = OnSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
				{value = 2, label = Loc ["STRING_OPTIONS_ED2"], onclick = OnSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
				{value = 3, label = Loc ["STRING_OPTIONS_ED3"], onclick = OnSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
			}
			local BuildEraseDataMenu = function()
				return EraseDataOptions
			end
			
			local d = g:NewDropDown (frame1, _, "$parentEraseDataDropdown", "EraseDataDropdown", 160, dropdown_height, BuildEraseDataMenu, _detalhes.segments_auto_erase, options_dropdown_template)
			
			frame1.EraseDataDropdown:SetPoint ("left", frame1.EraseDataLabel, "right", 2, 0)		

			window:CreateLineBackground2 (frame1, "EraseDataDropdown", "EraseDataLabel", Loc ["STRING_OPTIONS_ED_DESC"])
		
			
		--config bookmarks
			g:NewButton (frame1, _, "$parentBookmarkButton", "BookmarkButton", window.buttons_width, 18, _detalhes.OpenBookmarkConfig, nil, nil, nil, Loc ["STRING_OPTIONS_WC_BOOKMARK"], 1, options_button_template)
			--frame1.BookmarkButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			window:CreateLineBackground2 (frame1, "BookmarkButton", "BookmarkButton", Loc ["STRING_OPTIONS_WC_BOOKMARK_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.BookmarkButton:SetIcon ([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]], nil, nil, nil, {0.75, 1, 0, 1}, nil, nil, 2)
			frame1.BookmarkButton:SetTextColor (button_color_rgb)
			
		--config class colors
			g:NewButton (frame1, _, "$parentClassColorsButton", "ClassColorsButton", window.buttons_width, 18, _detalhes.OpenClassColorsConfig, nil, nil, nil, Loc ["STRING_OPTIONS_CHANGE_CLASSCOLORS"], 1, options_button_template)
			--frame1.ClassColorsButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
			window:CreateLineBackground2 (frame1, "ClassColorsButton", "ClassColorsButton", Loc ["STRING_OPTIONS_CHANGE_CLASSCOLORS_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
			
			frame1.ClassColorsButton:SetIcon ([[Interface\AddOns\Details\images\icons]], nil, nil, nil, {430/512, 459/512, 4/512, 30/512}, nil, nil, 2) -- , "orange"
			frame1.ClassColorsButton:SetTextColor (button_color_rgb)
		
		--click through ~clickthrough
			
			--in combat only
			g:NewLabel (frame1, _, "$parentclickThroughInCombatLabel", "clickThroughInCombatLabel", "In Combat Only", "GameFontHighlightLeft")
			
			g:NewSwitch (frame1, _, "$parentclickThroughInCombatSlider", "clickThroughInCombatSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.clickthrough_incombatonly, nil, nil, nil, nil, options_switch_template)
			frame1.clickThroughInCombatSlider:SetAsCheckBox()
			
			frame1.clickThroughInCombatSlider:SetPoint ("left", frame1.clickThroughInCombatLabel, "right", 2, 0)
			frame1.clickThroughInCombatSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
				_G.DetailsOptionsWindow.instance:UpdateClickThroughSettings (value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
						if (this_instance ~= _G.DetailsOptionsWindow.instance) then
							this_instance:UpdateClickThroughSettings (value)
						end
					end
				end
			end
			
			window:CreateLineBackground2 (frame1, "clickThroughInCombatSlider", "clickThroughInCombatLabel", "Only apply click through when in combat.")
			
			--window
			g:NewLabel (frame1, _, "$parentclickThroughWindowLabel", "clickThroughWindowLabel", "Affect Window", "GameFontHighlightLeft")
			
			g:NewSwitch (frame1, _, "$parentclickThroughWindowSlider", "clickThroughWindowSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.clickthrough_window, nil, nil, nil, nil, options_switch_template)
			frame1.clickThroughWindowSlider:SetAsCheckBox()
			
			frame1.clickThroughWindowSlider:SetPoint ("left", frame1.clickThroughWindowLabel, "right", 2, 0)
			frame1.clickThroughWindowSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
				_G.DetailsOptionsWindow.instance:UpdateClickThroughSettings (nil, value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
						if (this_instance ~= _G.DetailsOptionsWindow.instance) then
							this_instance:UpdateClickThroughSettings (nil, value)
						end
					end
				end
			end
			
			window:CreateLineBackground2 (frame1, "clickThroughWindowSlider", "clickThroughWindowLabel", "The window will be click through.")
			
			--bars
			g:NewLabel (frame1, _, "$parentclickThroughBarsLabel", "clickThroughBarsLabel", "Affect Bars", "GameFontHighlightLeft")
			
			g:NewSwitch (frame1, _, "$parentclickThroughBarsSlider", "clickThroughBarsSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.clickthrough_rows, nil, nil, nil, nil, options_switch_template)
			frame1.clickThroughBarsSlider:SetAsCheckBox()
			
			frame1.clickThroughBarsSlider:SetPoint ("left", frame1.clickThroughBarsLabel, "right", 2, 0)
			frame1.clickThroughBarsSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
				_G.DetailsOptionsWindow.instance:UpdateClickThroughSettings (nil, nil, value)
				
				if (_detalhes.options_group_edit and not _G.DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
						if (this_instance ~= _G.DetailsOptionsWindow.instance) then
							this_instance:UpdateClickThroughSettings (nil, nil, value)
						end
					end
				end
			end
			
			window:CreateLineBackground2 (frame1, "clickThroughBarsSlider", "clickThroughBarsLabel", "Player bars will be click through, won't show tooltips when hover hover them.")
			
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> Time Type
		g:NewLabel (frame1, _, "$parentTimeTypeLabel", "timetypeLabel", Loc ["STRING_OPTIONS_TIMEMEASURE"], "GameFontHighlightLeft")
		--
		local onSelectTimeType = function (_, _, timetype)
			_detalhes.time_type = timetype
			_detalhes.time_type_original = timetype
			_detalhes:AtualizaGumpPrincipal (-1, true)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		local timetypeOptions = {
			--localize-me
			{value = 1, label = "Activity Time", onclick = onSelectTimeType, icon = "Interface\\Icons\\Achievement_Quests_Completed_Daily_08", iconcolor = {1, .9, .9}, texcoord = {0.078125, 0.921875, 0.078125, 0.921875}}, --, desc = ""
			{value = 2, label = "Effective Time", onclick = onSelectTimeType, icon = "Interface\\Icons\\Achievement_Quests_Completed_08"} --, desc = ""
		}
		local buildTimeTypeMenu = function()
			return timetypeOptions
		end
		local d = g:NewDropDown (frame1, _, "$parentTTDropdown", "timetypeDropdown", 160, dropdown_height, buildTimeTypeMenu, nil, options_dropdown_template)
		
		frame1.timetypeDropdown:SetPoint ("left", frame1.timetypeLabel, "right", 2, 0)		

		window:CreateLineBackground2 (frame1, "timetypeDropdown", "timetypeLabel", Loc ["STRING_OPTIONS_TIMEMEASURE_DESC"])

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	--> anchors
	
		local titulo_display = g:NewLabel (frame1, _, "$parentTituloDisplay", "tituloDisplayLabel", Loc ["STRING_OPTIONSMENU_DISPLAY"], "GameFontNormal", 16) --> localize-me
		local titulo_display_desc = g:NewLabel (frame1, _, "$parentTituloDisplay2", "tituloDisplay2Label", Loc ["STRING_OPTIONSMENU_DISPLAY_DESC"], "GameFontNormal", 10, "white") --> localize-me
		titulo_display_desc.width = 320	
	
		g:NewLabel (frame1, _, "$parentGeneralAnchor", "GeneralAnchorLabel", Loc ["STRING_OPTIONS_GENERAL_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame1, _, "$parentIdentityAnchor", "GeneralIdentityLabel", Loc ["STRING_OPTIONS_AVATAR_ANCHOR"], "GameFontNormal")
		
		g:NewLabel (frame1, _, "$parentWindowControlsAnchor", "WindowControlsLabel", Loc ["STRING_OPTIONS_WC_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame1, _, "$parentToolsAnchor", "ToolsLabel", Loc ["STRING_OPTIONS_TOOLS_ANCHOR"], "GameFontNormal")
		
		g:NewLabel (frame1, _, "$parentClickThroughAnchor", "clickThroughLabel", "Click Through", "GameFontNormal")

		local w_start = 10
		
		titulo_display:SetPoint (window.left_start_at, window.title_y_pos)
		titulo_display_desc:SetPoint (window.left_start_at, window.title_y_pos2)
		
		local avatar_x_anchor = window.right_start_at
		
		frame1.GeneralIdentityLabel:SetPoint (avatar_x_anchor, window.top_start_at)
		
		frame1.nicknameLabel:SetPoint (avatar_x_anchor, -115)
		frame1.chooseAvatarButton:SetPoint (avatar_x_anchor+1, -115)
		
		frame1.avatarPreview:SetPoint (avatar_x_anchor2+1, -137)
		frame1.avatarPreview2:SetPoint (avatar_x_anchor2+1, -139)
		frame1.avatarNickname:SetPoint (avatar_x_anchor2+109, -171)
		
		frame1.IgnoreNicknamesLabel:SetPoint (avatar_x_anchor, -215)
		frame1.realmNameLabel:SetPoint (avatar_x_anchor, -235)
		
		--frame1.ToolsLabel:SetPoint (avatar_x_anchor, -265)
		--frame1.EraseDataLabel:SetPoint (avatar_x_anchor, -290)
		--frame1.BookmarkButton:SetPoint (avatar_x_anchor, -315)
		--frame1.ClassColorsButton:SetPoint (avatar_x_anchor, -340)

		local x = avatar_x_anchor
		
		local right_side = {
			{"WindowControlsLabel", 1, true},
			{"LockButton", 2},
			{"CloseButton", 3},
			{"BreakSnapButton", 4},
			--{"SetWindowColorButton", 5},
			{"CreateWindowButton", 6}, --, true
			
			{"clickThroughLabel", 14, true},
			{"clickThroughInCombatLabel", 15},
			{"clickThroughWindowLabel", 16},
			{"clickThroughBarsLabel", 17},
		}
		
		window:arrange_menu (frame1, right_side, x, -265)
		
		local left_side = {
			{"GeneralAnchorLabel", 1, true},
			{"animateLabel", 2},
			{"updatespeedLabel", 3},
			
			{"WheelSpeedLabel", 4},
			
			{"SegmentsLockedLabel", 5},
			{"timetypeLabel", 6, true},
			
			{"maxInstancesLabel", 7, true},
			{"dpsAbbreviateLabel", 8},
			{"NumericalSystemLabel", 9},
			
			{frame1.ToolsLabel, 10, true},
			{frame1.EraseDataLabel, 11},
			{frame1.BookmarkButton, 12},
			{frame1.ClassColorsButton, 13},
			

			
			
			--{"WindowControlsLabel", 9, true},
			--{"LockButton", 10},
			--{"CloseButton", 11},
			--{"BreakSnapButton", 12},
			--{"SetWindowColorButton", 13},
			--{"CreateWindowButton", 14, true},
			
		}
		
		window:arrange_menu (frame1, left_side, window.left_start_at, window.top_start_at)
		
end		
		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Settings - Combat PvP PvE ~2 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function window:CreateFrame2()
	
	--> general settings:
		local frame2 = window.options [2][1]
		
	--> titles
		local titulo_combattweeks = g:NewLabel (frame2, _, "$parentTituloCombatTweeks", "tituloCombatTweeksLabel", Loc ["STRING_OPTIONS_COMBATTWEEKS"], "GameFontNormal", 16)
		local titulo_combattweeks_desc = g:NewLabel (frame2, _, "$parentCombatTweeks2", "tituloCombatTweeks2Label", Loc ["STRING_OPTIONS_COMBATTWEEKS_DESC"], "GameFontNormal", 10,"white")
		titulo_combattweeks_desc.width = 320

		
	--> Frags PVP Mode
		g:NewLabel (frame2, _, "$parentLabelFragsPvP", "fragsPvpLabel", Loc ["STRING_OPTIONS_PVPFRAGS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentFragsPvpSlider", "fragsPvpSlider", 60, 20, _, _, _detalhes.only_pvp_frags, nil, nil, nil, nil, options_switch_template)
		frame2.fragsPvpSlider:SetPoint ("left", frame2.fragsPvpLabel, "right", 2, 0)
		frame2.fragsPvpSlider:SetAsCheckBox()
		frame2.fragsPvpSlider.OnSwitch = function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.only_pvp_frags = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame2, "fragsPvpSlider", "fragsPvpLabel", Loc ["STRING_OPTIONS_PVPFRAGS_DESC"])

	--> death log limit
		g:NewLabel (frame2, _, "$parentDeathLogLimitLabel", "DeathLogLimitLabel", Loc ["STRING_OPTIONS_DEATHLIMIT"], "GameFontHighlightLeft")
		--
		local onSelectDeathLogLimit = function (_, _, limit_amount)
			_detalhes:SetDeathLogLimit (limit_amount)
		end
		local DeathLogLimitOptions = {
			{value = 16, label = "16 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
			{value = 32, label = "32 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
			{value = 45, label = "45 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
		}
		local buildDeathLogLimitMenu = function()
			return DeathLogLimitOptions
		end
		local d = g:NewDropDown (frame2, _, "$parentDeathLogLimitDropdown", "DeathLogLimitDropdown", 160, dropdown_height, buildDeathLogLimitMenu, nil, options_dropdown_template)
		
		frame2.DeathLogLimitDropdown:SetPoint ("left", frame2.DeathLogLimitLabel, "right", 2, 0)		

		window:CreateLineBackground2 (frame2, "DeathLogLimitDropdown", "DeathLogLimitLabel", Loc ["STRING_OPTIONS_DEATHLIMIT_DESC"])

	--> damage taken always on everything
		g:NewLabel (frame2, _, "$parentDamageTakenEverythingLabel", "DamageTakenEverythingLabel", Loc ["STRING_OPTIONS_DTAKEN_EVERYTHING"], "GameFontHighlightLeft")
		g:NewSwitch (frame2, _, "$parentDamageTakenEverythingSlider", "DamageTakenEverythingSlider", 60, 20, _, _, _detalhes.damage_taken_everything, nil, nil, nil, nil, options_switch_template)

		frame2.DamageTakenEverythingSlider:SetPoint ("left", frame2.DamageTakenEverythingLabel, "right", 2)
		frame2.DamageTakenEverythingSlider:SetAsCheckBox()
		frame2.DamageTakenEverythingSlider.OnSwitch = function (_, _, value)
			_detalhes.damage_taken_everything = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame2, "DamageTakenEverythingSlider", "DamageTakenEverythingLabel", Loc ["STRING_OPTIONS_DTAKEN_EVERYTHING_DESC"])		
		
	--> deathlog healing done threshold
		g:NewLabel (frame2, _, "$parentDeathLogHealingThresholdLabel", "DeathLogHealingThresholdLabel", Loc ["STRING_OPTIONS_DEATHLOG_MINHEALING"], "GameFontHighlightLeft")
		
		local s = g:NewSlider (frame2, _, "$parentDeathLogHealingThresholdSlider", "DeathLogHealingThresholdSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 100000, 1, _detalhes.deathlog_healingdone_min, nil, nil, nil, options_slider_template)
		
		frame2.DeathLogHealingThresholdSlider:SetPoint ("left", frame2.DeathLogHealingThresholdLabel, "right", 2, -1)
		frame2.DeathLogHealingThresholdSlider:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.deathlog_healingdone_min = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame2, "DeathLogHealingThresholdSlider", "DeathLogHealingThresholdLabel", Loc ["STRING_OPTIONS_DEATHLOG_MINHEALING_DESC"])
		
	--> always show players
		g:NewLabel (frame2, _, "$parentAlwaysShowPlayersLabel", "AlwaysShowPlayersLabel", Loc ["STRING_OPTIONS_ALWAYSSHOWPLAYERS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentAlwaysShowPlayersSlider", "AlwaysShowPlayersSlider", 60, 20, _, _, _detalhes.all_players_are_group, nil, nil, nil, nil, options_switch_template)
		frame2.AlwaysShowPlayersSlider:SetPoint ("left", frame2.AlwaysShowPlayersLabel, "right", 2, 0)
		frame2.AlwaysShowPlayersSlider:SetAsCheckBox()
		frame2.AlwaysShowPlayersSlider.OnSwitch = function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.all_players_are_group = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame2, "AlwaysShowPlayersSlider", "AlwaysShowPlayersLabel", Loc ["STRING_OPTIONS_ALWAYSSHOWPLAYERS_DESC"])
	
	--> Overall Data
		g:NewLabel (frame2, _, "$parentOverallDataAnchor", "OverallDataLabel", Loc ["STRING_OPTIONS_OVERALL_ANCHOR"], "GameFontNormal")
		
	--raid boss
		g:NewLabel (frame2, _, "$parentOverallDataRaidBossLabel", "OverallDataRaidBossLabel", Loc ["STRING_OPTIONS_OVERALL_RAIDBOSS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallDataRaidBossSlider", "OverallDataRaidBossSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallDataRaidBossSlider:SetPoint ("left", frame2.OverallDataRaidBossLabel, "right", 2, 0)
		frame2.OverallDataRaidBossSlider:SetAsCheckBox()
		--
		frame2.OverallDataRaidBossSlider.OnSwitch = function (self, _, value)
			if (value and bit.band (_detalhes.overall_flag, 0x1) == 0) then
				_detalhes.overall_flag = _detalhes.overall_flag + 0x1
			elseif (not value and bit.band (_detalhes.overall_flag, 0x1) ~= 0) then
				_detalhes.overall_flag = _detalhes.overall_flag - 0x1
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallDataRaidBossSlider", "OverallDataRaidBossLabel", Loc ["STRING_OPTIONS_OVERALL_RAIDBOSS_DESC"])
		
	--raid cleanup
		g:NewLabel (frame2, _, "$parentOverallDataRaidCleaupLabel", "OverallDataRaidCleaupLabel", Loc ["STRING_OPTIONS_OVERALL_RAIDCLEAN"], "GameFontHighlightLeft")
		--
		local raid_cleanup = g:NewSwitch (frame2, _, "$parentOverallDataRaidCleaupSlider", "OverallDataRaidCleaupSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallDataRaidCleaupSlider:SetPoint ("left", frame2.OverallDataRaidCleaupLabel, "right", 2, 0)
		frame2.OverallDataRaidCleaupSlider:SetAsCheckBox()
		--
		frame2.OverallDataRaidCleaupSlider.OnSwitch = function (self, _, value)
			if (value and bit.band (_detalhes.overall_flag, 0x2) == 0) then
				_detalhes.overall_flag = _detalhes.overall_flag + 0x2
			elseif (not value and bit.band (_detalhes.overall_flag, 0x2) ~= 0) then
				_detalhes.overall_flag = _detalhes.overall_flag - 0x2
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallDataRaidCleaupSlider", "OverallDataRaidCleaupLabel", Loc ["STRING_OPTIONS_OVERALL_RAIDCLEAN_DESC"])
		
	--dungeon boss
		g:NewLabel (frame2, _, "$parentOverallDataDungeonBossLabel", "OverallDataDungeonBossLabel", Loc ["STRING_OPTIONS_OVERALL_DUNGEONBOSS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallDataDungeonBossSlider", "OverallDataDungeonBossSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallDataDungeonBossSlider:SetPoint ("left", frame2.OverallDataDungeonBossLabel, "right", 2, 0)
		frame2.OverallDataDungeonBossSlider:SetAsCheckBox()
		--
		frame2.OverallDataDungeonBossSlider.OnSwitch = function (self, _, value)
			if (value and bit.band (_detalhes.overall_flag, 0x4) == 0) then
				_detalhes.overall_flag = _detalhes.overall_flag + 0x4
			elseif (not value and bit.band (_detalhes.overall_flag, 0x4) ~= 0) then
				_detalhes.overall_flag = _detalhes.overall_flag - 0x4
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallDataDungeonBossSlider", "OverallDataDungeonBossLabel", Loc ["STRING_OPTIONS_OVERALL_DUNGEONBOSS_DESC"])
		
	--dungeon cleanup
		g:NewLabel (frame2, _, "$parentOverallDataDungeonCleaupLabel", "OverallDataDungeonCleaupLabel", Loc ["STRING_OPTIONS_OVERALL_DUNGEONCLEAN"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallDataDungeonCleaupSlider", "OverallDataDungeonCleaupSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallDataDungeonCleaupSlider:SetPoint ("left", frame2.OverallDataDungeonCleaupLabel, "right", 2, 0)
		frame2.OverallDataDungeonCleaupSlider:SetAsCheckBox()
		--
		frame2.OverallDataDungeonCleaupSlider.OnSwitch = function (self, _, value)
			if (value and bit.band (_detalhes.overall_flag, 0x8) == 0) then
				_detalhes.overall_flag = _detalhes.overall_flag + 0x8
			elseif (not value and bit.band (_detalhes.overall_flag, 0x8) ~= 0) then
				_detalhes.overall_flag = _detalhes.overall_flag - 0x8
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallDataDungeonCleaupSlider", "OverallDataDungeonCleaupLabel", Loc ["STRING_OPTIONS_OVERALL_DUNGEONCLEAN_DESC"])
		
	--everything
		g:NewLabel (frame2, _, "$parentOverallDataAllLabel", "OverallDataAllLabel", Loc ["STRING_OPTIONS_OVERALL_ALL"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallDataAllSlider", "OverallDataAllSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallDataAllSlider:SetPoint ("left", frame2.OverallDataAllLabel, "right", 2, 0)
		frame2.OverallDataAllSlider:SetAsCheckBox()
		--
		
		function frame2:OverallSliderEnabled()
			frame2.OverallDataRaidBossSlider:Disable()
			frame2.OverallDataRaidCleaupSlider:Disable()
			frame2.OverallDataDungeonBossSlider:Disable()
			frame2.OverallDataDungeonCleaupSlider:Disable()
		end
		
		function frame2:OverallSliderDisabled()
			frame2.OverallDataRaidBossSlider:Enable()
			frame2.OverallDataRaidCleaupSlider:Enable()
			frame2.OverallDataDungeonBossSlider:Enable()
			frame2.OverallDataDungeonCleaupSlider:Enable()
		end
		
		frame2.OverallDataAllSlider.OnSwitch = function (self, _, value)
		
			if (value and bit.band (_detalhes.overall_flag, 0x10) == 0) then
				_detalhes.overall_flag = _detalhes.overall_flag + 0x10
				frame2:OverallSliderEnabled()
				
			elseif (not value and bit.band (_detalhes.overall_flag, 0x10) ~= 0) then
				_detalhes.overall_flag = _detalhes.overall_flag - 0x10
				frame2:OverallSliderDisabled()

			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallDataAllSlider", "OverallDataAllLabel", Loc ["STRING_OPTIONS_OVERALL_ALL_DESC"])
		
	--erase on new boss
		g:NewLabel (frame2, _, "$parentOverallNewBossLabel", "OverallNewBossLabel", Loc ["STRING_OPTIONS_OVERALL_NEWBOSS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallNewBossSlider", "OverallNewBossSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallNewBossSlider:SetPoint ("left", frame2.OverallNewBossLabel, "right", 2, 0)
		frame2.OverallNewBossSlider:SetAsCheckBox()
		--
		frame2.OverallNewBossSlider.OnSwitch = function (self, _, value)
			_detalhes:OverallOptions (value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallNewBossSlider", "OverallNewBossLabel", Loc ["STRING_OPTIONS_OVERALL_NEWBOSS_DESC"])

	--erase on new mythic+ dungeon
		g:NewLabel (frame2, _, "$parentOverallNewChallengeLabel", "OverallNewChallengeLabel", Loc ["STRING_OPTIONS_OVERALL_MYTHICPLUS"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallNewChallengeSlider", "OverallNewChallengeSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallNewChallengeSlider:SetPoint ("left", frame2.OverallNewChallengeLabel, "right", 2, 0)
		frame2.OverallNewChallengeSlider:SetAsCheckBox()
		--
		frame2.OverallNewChallengeSlider.OnSwitch = function (self, _, value)
			_detalhes:OverallOptions (nil, value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallNewChallengeSlider", "OverallNewChallengeLabel", Loc ["STRING_OPTIONS_OVERALL_MYTHICPLUS_DESC"])
		
	--erase on logout overall_clear_logout
		g:NewLabel (frame2, _, "$parentOverallOnLogoutLabel", "OverallOnLogoutLabel", Loc ["STRING_OPTIONS_OVERALL_LOGOFF"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame2, _, "$parentOverallOnLogoutSlider", "OverallOnLogoutSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame2.OverallOnLogoutSlider:SetPoint ("left", frame2.OverallOnLogoutLabel, "right", 2, 0)
		frame2.OverallOnLogoutSlider:SetAsCheckBox()
		--
		frame2.OverallOnLogoutSlider.OnSwitch = function (self, _, value)
			_detalhes:OverallOptions (nil, nil, value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		--
		window:CreateLineBackground2 (frame2, "OverallOnLogoutSlider", "OverallOnLogoutLabel", Loc ["STRING_OPTIONS_OVERALL_LOGOFF_DESC"])
		

	--> battleground
		--> remote parser
		g:NewLabel (frame2, _, "$parentRemoteParserLabel", "RemoteParserLabel", Loc ["STRING_OPTIONS_BG_UNIQUE_SEGMENT"], "GameFontHighlightLeft")
		g:NewSwitch (frame2, _, "$parentRemoteParserSlider", "RemoteParserSlider", 60, 20, _, _, _detalhes.use_battleground_server_parser, nil, nil, nil, nil, options_switch_template)
		frame2.RemoteParserSlider:SetPoint ("left", frame2.RemoteParserLabel, "right", 2)
		frame2.RemoteParserSlider:SetAsCheckBox()
		frame2.RemoteParserSlider.OnSwitch = function (self, _, value)
			_detalhes.use_battleground_server_parser = value
		end
		window:CreateLineBackground2 (frame2, "RemoteParserSlider", "RemoteParserLabel", Loc ["STRING_OPTIONS_BG_UNIQUE_SEGMENT_DESC"])
		
	--> show all
		g:NewLabel (frame2, _, "$parentShowAllLabel", "ShowAllLabel", Loc ["STRING_OPTIONS_BG_ALL_ALLY"], "GameFontHighlightLeft")
		g:NewSwitch (frame2, _, "$parentShowAllSlider", "ShowAllSlider", 60, 20, _, _, _detalhes.pvp_as_group, nil, nil, nil, nil, options_switch_template)
		frame2.ShowAllSlider:SetPoint ("left", frame2.ShowAllLabel, "right", 2)
		frame2.ShowAllSlider:SetAsCheckBox()
		frame2.ShowAllSlider.OnSwitch = function (self, _, value)
			_detalhes.pvp_as_group = value
		end
		window:CreateLineBackground2 (frame2, "ShowAllSlider", "ShowAllLabel", Loc ["STRING_OPTIONS_BG_ALL_ALLY_DESC"])
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		
	--> anchors
	
		--general anchor
		g:NewLabel (frame2, _, "$parentGeneralAnchor", "GeneralAnchorLabel", Loc ["STRING_OPTIONS_GENERAL_ANCHOR"], "GameFontNormal")
		--battleground anchor
		g:NewLabel (frame2, _, "$parentBattlegroundAnchor", "BattlegroundAnchorLabel", Loc ["STRING_OPTIONS_BG_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_combattweeks:SetPoint (x, window.title_y_pos)
		titulo_combattweeks_desc:SetPoint (x, window.title_y_pos2)

		local left_side = {
			{"GeneralAnchorLabel", 1, true},
			{"fragsPvpLabel"},
			{"DeathLogLimitLabel"},
			{"DeathLogHealingThresholdLabel"},
			{"DamageTakenEverythingLabel"},
			{"AlwaysShowPlayersLabel"},
			
			{"BattlegroundAnchorLabel", 10, true},
			{"RemoteParserLabel", 11},
			{"ShowAllLabel", 12},

		}
		
		window:arrange_menu (frame2, left_side, x, window.top_start_at)
		
		local x = window.right_start_at
		
		local right_side = {
			{"OverallDataLabel", 1, true},
			{"OverallDataRaidBossLabel", 2},
			{"OverallDataRaidCleaupLabel", 3},
			{"OverallDataDungeonBossLabel", 4},
			{"OverallDataDungeonCleaupLabel", 5},
			{"OverallDataAllLabel", 6, true},
			{"OverallNewBossLabel", 7, true},
			{"OverallNewChallengeLabel", 8},
			{"OverallOnLogoutLabel", 9},

		}
		
		window:arrange_menu (frame2, right_side, x, window.top_start_at)
		
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Settings - Profiles ~13
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function window:CreateFrame13()
	
	local frame13 = window.options [13][1]

	--> profiles title
		local titulo_profiles = g:NewLabel (frame13, _, "$parentTituloProfiles", "tituloProfilesLabel", Loc ["STRING_OPTIONS_PROFILES_TITLE"], "GameFontNormal", 16)
		local titulo_profiles_desc = g:NewLabel (frame13, _, "$parentTituloProfiles2", "tituloProfiles2Label", Loc ["STRING_OPTIONS_PROFILES_TITLE_DESC"], "GameFontNormal", 10,"white")
		titulo_profiles_desc.width = 320

	--> current profile
		local current_profile_label = g:NewLabel (frame13, _, "$parentCurrentProfileLabel1", "currentProfileLabel1",  Loc ["STRING_OPTIONS_PROFILES_CURRENT"], "GameFontHighlightLeft")
		local current_profile_label2 = g:NewLabel (frame13, _, "$parentCurrentProfileLabel2", "currentProfileLabel2",  "", "GameFontNormal")
		current_profile_label2:SetPoint ("left", current_profile_label, "right", 3, 0)
		
		local info_holder_frame = CreateFrame ("frame", nil, frame13.widget or frame13)
		info_holder_frame:SetPoint ("topleft", current_profile_label.widget, "topleft")
		info_holder_frame:SetPoint ("bottomright", current_profile_label2.widget, "bottomright")
		
		window:CreateLineBackground2 (frame13, info_holder_frame, current_profile_label.widget, Loc ["STRING_OPTIONS_PROFILES_CURRENT_DESC"])
	
	--> exclamation warning about an exception on this character for use profile on all characters
		local exclamation_frame = CreateFrame ("frame", nil, frame13)
		exclamation_frame:SetSize (16, 16)
		local exclamation_frame_texture = exclamation_frame:CreateTexture (nil, "overlay")
		exclamation_frame_texture:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
		exclamation_frame_texture:SetAllPoints()
		exclamation_frame:SetScript ("OnEnter", function (self)
			--show tooltip
			GameCooltip:Preset (2)
			GameCooltip:AddLine (Loc ["STRING_OPTIONS_PROFILE_OVERWRITTEN"])
			GameCooltip:ShowCooltip (self, "tooltip")
		end)
		exclamation_frame:SetScript ("OnLeave", function()
			--hide tooltip
			GameCooltip:Hide()
		end)
		exclamation_frame:Hide()
		exclamation_frame:SetFrameLevel (30)
	
	--> select profile
		local profile_selected = function (_, instance, profile_name)
		
			if (_detalhes.always_use_profile) then
				local unitname = UnitName ("player")
				_detalhes.always_use_profile_exception [unitname] = true
				--show a exclamation on the always use this profile
				exclamation_frame:Show()
			end
		
			_detalhes:ApplyProfile (profile_name)
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], profile_name)
			_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
		end
		local build_profile_menu = function()
			local menu = {}
			
			for index, profile_name in ipairs (_detalhes:GetProfileList()) do 
				menu [#menu+1] = {value = profile_name, label = profile_name, onclick = profile_selected, icon = "Interface\\MINIMAP\\Vehicle-HammerGold-3"}
			end
			
			return menu
		end
		local select_profile_dropdown = g:NewDropDown (frame13, _, "$parentSelectProfileDropdown", "selectProfileDropdown", 160, dropdown_height, build_profile_menu, 0, options_dropdown_template)
		local d = select_profile_dropdown
		
		local select_profile_label = g:NewLabel (frame13, _, "$parentSelectProfileLabel", "selectProfileLabel", Loc ["STRING_OPTIONS_PROFILES_SELECT"], "GameFontHighlightLeft")
		select_profile_dropdown:SetPoint ("left", select_profile_label, "right", 2, 0)
		
		window:CreateLineBackground2 (frame13, select_profile_dropdown, select_profile_label, Loc ["STRING_OPTIONS_PROFILES_SELECT_DESC"])
		
	--> always use this profile dropdown
		local profile_selected_alwaysuse = function (_, instance, profile_name)
			
			--if (not _detalhes.always_use_profile or not profile_name) then
			--	return
			--end
			
			_detalhes.always_use_profile_name = profile_name
			local unitname = UnitName ("player")
			_detalhes.always_use_profile_exception [unitname] = nil
			
			_detalhes:ApplyProfile (profile_name)
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], profile_name)
			_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
		end
		local build_profile_menu = function()
			local menu = {}
			for index, profile_name in ipairs (_detalhes:GetProfileList()) do 
				menu [#menu+1] = {value = profile_name, label = profile_name, onclick = profile_selected_alwaysuse, icon = "Interface\\MINIMAP\\Vehicle-HammerGold-3"}
			end
			return menu
		end
	
		local select_alwaysuseprofile_dropdown = g:NewDropDown (frame13, _, "$parentSelectAlwaysuseprofileDropdown", "SelectAlwaysuseprofileDropdown", 160, dropdown_height, build_profile_menu, _detalhes.always_use_profile_name, options_dropdown_template)
		select_alwaysuseprofile_dropdown:SetEmptyTextAndIcon ("Select Profile")

		local select_alwaysuseprofile_label = g:NewLabel (frame13, _, "$parentSelectAlwaysuseprofileLabel", "SelectAlwaysuseprofileLabel", "Select Profile", "GameFontHighlightLeft")
		select_alwaysuseprofile_dropdown:SetPoint ("left", select_alwaysuseprofile_label, "right", 2, 0)
		
		window:CreateLineBackground2 (frame13, select_alwaysuseprofile_dropdown,  select_alwaysuseprofile_label, Loc ["STRING_OPTIONS_PROFILE_GLOBAL"])
		
	
	--> always use this profile checkbox
		g:NewLabel (frame13, _, "$parentAlwaysUseLabel", "AlwaysUseLabel", Loc ["STRING_OPTIONS_ALWAYS_USE"], "GameFontHighlightLeft")
		g:NewSwitch (frame13, _, "$parentAlwaysUseSlider", "AlwaysUseSlider", 60, 20, _, _, _detalhes.always_use_profile, nil, nil, nil, nil, options_switch_template)
		
		--set the point of the exclamation image
		exclamation_frame:SetPoint ("left", frame13.AlwaysUseSlider.widget, "right", 2, 0)
		
		frame13.AlwaysUseSlider:SetPoint ("left", frame13.AlwaysUseLabel, "right", 2, -1)
		frame13.AlwaysUseSlider:SetAsCheckBox()
		frame13.AlwaysUseSlider.OnSwitch = function (self, _, value) 
			if (value) then
				_detalhes.always_use_profile = true
				_detalhes.always_use_profile_name = select_profile_dropdown:GetValue()
				
				--enable the dropdown
				frame13.SelectAlwaysuseprofileDropdown:Enable()
				
				--set the dropdown value to the current profile selected
				frame13.SelectAlwaysuseprofileDropdown:Select (_detalhes.always_use_profile_name)
				
				--remove this character from the exception list
				local unitname = UnitName ("player")
				_detalhes.always_use_profile_exception [unitname] = nil
				exclamation_frame:Hide()
			else
				_detalhes.always_use_profile = false
				--disable the dropdown
				frame13.SelectAlwaysuseprofileDropdown:Disable()
				
				--remove this character from the exception list
				local unitname = UnitName ("player")
				_detalhes.always_use_profile_exception [unitname] = nil
				exclamation_frame:Hide()
			end
		end
		frame13.AlwaysUseSlider:SetPoint ("left", frame13.AlwaysUseLabel, "right", 3, 0)
		window:CreateLineBackground2 (frame13, "AlwaysUseSlider", "AlwaysUseLabel", Loc ["STRING_OPTIONS_ALWAYS_USE_DESC"])

		function frame13:update_profile_settings()
			if (_detalhes.always_use_profile) then
				frame13.SelectAlwaysuseprofileDropdown:Enable()
				frame13.SelectAlwaysuseprofileDropdown:Select (_detalhes.always_use_profile_name)
				
				local unitname = UnitName ("player")
				if (_detalhes.always_use_profile_exception [unitname]) then
					exclamation_frame:Show()
				else
					exclamation_frame:Hide()
				end
			else
				exclamation_frame:Hide()
				frame13.SelectAlwaysuseprofileDropdown:Disable()
			end
		end
		
		
		
	--> new profile
		local profile_name = g:NewTextEntry (frame13, _, "$parentProfileNameEntry", "profileNameEntry", 120, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		local profile_name_label = g:NewLabel (frame13, _, "$parentProfileNameLabel", "profileNameLabel", Loc ["STRING_OPTIONS_PROFILES_CREATE"], "GameFontHighlightLeft")
		profile_name:SetPoint ("left", profile_name_label, "right", 2, 0)
		
		local create_profile = function()
			local text = profile_name:GetText()
			if (text == "") then
				return _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_FIELDEMPTY"])
			end
			
			profile_name:SetText ("")
			profile_name:ClearFocus()
			
			local new_profile = _detalhes:CreateProfile (text)
			if (new_profile) then
				_detalhes:ApplyProfile (text)
				_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
				_G.DetailsOptionsWindow13SelectProfileCopyDropdown.MyObject:Refresh()
				_G.DetailsOptionsWindow13SelectProfileEraseDropdown.MyObject:Refresh()
			else
				return _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_NOTCREATED"])
			end
		end
		local profile_create_button = g:NewButton (frame13, _, "$parentProfileCreateButton", "profileCreateButton", 50, 18, create_profile, nil, nil, nil, Loc ["STRING_OPTIONS_SAVELOAD_SAVE"], nil, options_button_template)
		--profile_create_button:InstallCustomTexture()
		profile_create_button:SetPoint ("left", profile_name, "right", 2, 0)
		
		window:CreateLineBackground2 (frame13, profile_name, profile_name_label, Loc ["STRING_OPTIONS_PROFILES_CREATE_DESC"])

	--> copy profile
		local profile_selectedCopy = function (_, instance, profile_name)
			--copiar o profile
			local current_instance = _G.DetailsOptionsWindow.instance
			_detalhes:ApplyProfile (profile_name, nil, true)
			_G.DetailsOptionsWindow13SelectProfileCopyDropdown.MyObject:Select (false)
			_G.DetailsOptionsWindow13SelectProfileCopyDropdown.MyObject:Refresh()
			
			_detalhes:OpenOptionsWindow (current_instance)
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_COPYOKEY"])
		end
		local build_copy_menu = function()
			local menu = {}
			
			local current = _detalhes:GetCurrentProfileName()
			
			for index, profile_name in ipairs (_detalhes:GetProfileList()) do 
				if (profile_name ~= current) then
					menu [#menu+1] = {value = profile_name, label = profile_name, onclick = profile_selectedCopy, icon = "Interface\\MINIMAP\\Vehicle-HammerGold-2"}
				end
			end
			
			return menu
		end
		
		local select_profileCopy_dropdown = g:NewDropDown (frame13, _, "$parentSelectProfileCopyDropdown", "selectProfileCopyDropdown", 160, dropdown_height, build_copy_menu, 0, options_dropdown_template)	
		select_profileCopy_dropdown:SetEmptyTextAndIcon (Loc ["STRING_OPTIONS_PROFILE_SELECT"])
		
		local d = select_profileCopy_dropdown

		local select_profileCopy_label = g:NewLabel (frame13, _, "$parentSelectProfileCopyLabel", "selectProfileCopyLabel", Loc ["STRING_OPTIONS_PROFILES_COPY"], "GameFontHighlightLeft")
		select_profileCopy_dropdown:SetPoint ("left", select_profileCopy_label, "right", 2, 0)
		
		window:CreateLineBackground2 (frame13, select_profileCopy_dropdown,  select_profileCopy_label, Loc ["STRING_OPTIONS_PROFILES_COPY_DESC"])
		
	--> erase profile
		local profile_selectedErase = function (_, instance, profile_name)
			local current_instance = _G.DetailsOptionsWindow.instance
			_detalhes:EraseProfile (profile_name)
			
			_detalhes:OpenOptionsWindow (current_instance)
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_REMOVEOKEY"])
			
			_G.DetailsOptionsWindow13SelectProfileEraseDropdown.MyObject:Select (false)
			_G.DetailsOptionsWindow13SelectProfileCopyDropdown.MyObject:Refresh()
			_G.DetailsOptionsWindow13SelectProfileEraseDropdown.MyObject:Refresh()
		end
		local build_erase_menu = function()
			local menu = {}

			local current = _detalhes:GetCurrentProfileName()
			
			for index, profile_name in ipairs (_detalhes:GetProfileList()) do 
				if (profile_name ~= current) then
					menu [#menu+1] = {value = profile_name, label = profile_name, onclick = profile_selectedErase, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}}
				end
			end
			
			return menu
		end
		local select_profileErase_dropdown = g:NewDropDown (frame13, _, "$parentSelectProfileEraseDropdown", "selectProfileEraseDropdown", 160, dropdown_height, build_erase_menu, 0, options_dropdown_template)	
		select_profileErase_dropdown:SetEmptyTextAndIcon (Loc ["STRING_OPTIONS_PROFILE_SELECT"])
		
		local d = select_profileErase_dropdown
		
		local select_profileErase_label = g:NewLabel (frame13, _, "$parentSelectProfileEraseLabel", "selectProfileLabel", Loc ["STRING_OPTIONS_PROFILES_ERASE"], "GameFontHighlightLeft")
		select_profileErase_dropdown:SetPoint ("left", select_profileErase_label, "right", 2, 0)
		
		window:CreateLineBackground2 (frame13, select_profileErase_dropdown, select_profileErase_label, Loc ["STRING_OPTIONS_PROFILES_ERASE_DESC"])
		
	--> reset profile
		
		function _detalhes:RefreshOptionsAfterProfileReset()
			_detalhes:OpenOptionsWindow (_detalhes:GetInstance(1))
		end
		
		local reset_profile = function()
			local current_instance = _G.DetailsOptionsWindow.instance
			_detalhes:ResetProfile (_detalhes:GetCurrentProfileName())
			_detalhes:ScheduleTimer ("RefreshOptionsAfterProfileReset", 1)
		end
		
		local profile_reset_button = g:NewButton (frame13, _, "$parentProfileResetButton", "profileResetButton", window.buttons_width, 18, reset_profile, nil, nil, nil, Loc ["STRING_OPTIONS_PROFILES_RESET"], nil, options_button_template)
		frame13.profileResetButton:SetIcon ([[Interface\Buttons\UI-RefreshButton]], 14, 14, nil, {0, 1, 0, 0.9375}, nil, 4, 2)
		frame13.profileResetButton:SetTextColor (button_color_rgb)
		
		local hiddenlabel = g:NewLabel (frame13, _, "$parentProfileResetButtonLabel", "profileResetButtonLabel", "", "GameFontHighlightLeft")
		hiddenlabel:SetPoint ("left", profile_reset_button, "left")
		
		window:CreateLineBackground2 (frame13, "profileResetButton", "profileResetButton", Loc ["STRING_OPTIONS_PROFILES_RESET_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		
	--> import export functions
		local export_profile = function()
			local str = Details:ExportCurrentProfile()
			if (str) then
				_detalhes:ShowImportWindow (str, nil, "Details! Export Profile")
				
				--[=[ debug
				local uncompress = Details:DecompressData (str, "print")
				if (uncompress) then
					Details:Dump (uncompress)
				else
					print ("failed...")
				end
				--]=]
			end
		end
		
		local import_profile = function()
			--when clicking in the okay button in the import window, it send the text in the first argument
			_detalhes:ShowImportWindow ("", function (profileString)
				if (type (profileString) ~= "string" or string.len (profileString) < 2) then
					return
				end
				
				--prompt text panel returns what the user inserted in the text field in the first argument
				DetailsFramework:ShowTextPromptPanel ("Insert a Name for the New Profile:", function (newProfileName)
					Details:ImportProfile (profileString, newProfileName)
				end)
			end, "Details! Import Profile (paste string)")
		end	
		
	--> import profile
		local profileImportButton = g:NewButton (frame13, _, "$parentProfileImportButton", "profileImportButton", window.buttons_width, 18, import_profile, nil, nil, nil, "Import Profile", nil, options_button_template) --> localize-me
		frame13.profileImportButton:SetIcon ([[Interface\BUTTONS\UI-GuildButton-OfficerNote-Up]], 14, 14, nil, {0, 1, 0, 1}, nil, 4, 2)
		frame13.profileImportButton:SetTextColor (button_color_rgb)
		
		local hiddenlabel = g:NewLabel (frame13, _, "$parentProfileImportButtonLabel", "profileImportButtonLabel", "", "GameFontHighlightLeft")
		hiddenlabel:SetPoint ("left", profileImportButton, "left")
		
		window:CreateLineBackground2 (frame13, "profileImportButton", "profileImportButton", "Import current profile", nil, {1, 0.8, 0}, button_color_rgb)
		
	-->  export profile
		local profileExportButton = g:NewButton (frame13, _, "$parentProfileExportButton", "profileExportButton", window.buttons_width, 18, export_profile, nil, nil, nil, "Export Current Profile", nil, options_button_template) --> localize-me
		frame13.profileExportButton:SetIcon ([[Interface\Buttons\UI-GuildButton-MOTD-Up]], 14, 14, nil, {1, 0, 0, 1}, nil, 4, 2)
		frame13.profileExportButton:SetTextColor (button_color_rgb)
		
		local hiddenlabel = g:NewLabel (frame13, _, "$parentProfileExportButtonLabel", "profileExportButtonLabel", "", "GameFontHighlightLeft")
		hiddenlabel:SetPoint ("left", profileExportButton, "left")
		
		window:CreateLineBackground2 (frame13, "profileExportButton", "profileExportButton", "Export current profile", nil, {1, 0.8, 0}, button_color_rgb)
		
	--> save window position within profile
	
		g:NewLabel (frame13, _, "$parentSavePosAndSizeLabel", "PosAndSizeLabel", Loc ["STRING_OPTIONS_PROFILE_POSSIZE"], "GameFontHighlightLeft")
		g:NewSwitch (frame13, _, "$parentPosAndSizeSlider", "PosAndSizeSlider", 60, 20, _, _, _detalhes.profile_save_pos, nil, nil, nil, nil, options_switch_template)
		frame13.PosAndSizeSlider:SetPoint ("left", frame13.PosAndSizeLabel, "right", 2, -1)
		frame13.PosAndSizeSlider:SetAsCheckBox()
		frame13.PosAndSizeSlider.OnSwitch = function (self, _, value)
			_detalhes.profile_save_pos = value
			_detalhes:SetProfileCProp (nil, "profile_save_pos", value)
		end
		frame13.PosAndSizeSlider:SetPoint ("left", frame13.PosAndSizeLabel, "right", 3, 0)
		window:CreateLineBackground2 (frame13, "PosAndSizeSlider", "PosAndSizeLabel", Loc ["STRING_OPTIONS_PROFILE_POSSIZE_DESC"])
		
	--> anchors
	
		--general anchor
		g:NewLabel (frame13, _, "$parentProfilesAnchor", "ProfileAnchorLabel", Loc ["STRING_OPTIONS_PROFILES_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_profiles:SetPoint (x, window.title_y_pos)
		titulo_profiles_desc:SetPoint (x, window.title_y_pos2)

		local left_side = {
			{"ProfileAnchorLabel", 1, true},
			{current_profile_label, 2},
			{select_profile_label, 3},
			
			{"AlwaysUseLabel", 4, true},
			{select_alwaysuseprofile_label, 4},
			
			{"PosAndSizeLabel", 5, true},
			{profile_name_label, 6, true},
			{select_profileCopy_label, 7},
			{select_profileErase_label, 8},
			{profile_reset_button, 9, true},
			{profileExportButton},
			{profileImportButton},
			
		}
		
		window:arrange_menu (frame13, left_side, x, window.top_start_at)	
		
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Skin ~3
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function window:CreateFrame3()
	
	local frame3 = window.options [3][1]

	--> custom skin texture
	local custom_texture = g:NewTextEntry (frame3, _, "$parentCustomTextureEntry", "CustomTextureEntry", 120, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
	local custom_texture_label = g:NewLabel (frame3, _, "$parentCustomTextureLabel", "CustomTextureLabel", Loc ["STRING_CUSTOM_SKIN_TEXTURE"], "GameFontHighlightLeft")
	custom_texture:SetPoint ("left", custom_texture_label, "right", 2, 0)

	custom_texture:SetHook ("OnEnterPressed", function()
		local instance = _G.DetailsOptionsWindow.instance
		local file_name = custom_texture.text
		
		instance:SetUserCustomSkinFile (file_name)
		
		if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
			for _, this_instance in ipairs (instance:GetInstanceGroup()) do
				if (this_instance ~= instance) then
					this_instance:SetUserCustomSkinFile (file_name)
				end
			end
		end

		_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
	end)
	
	window:CreateLineBackground2 (frame3, "CustomTextureEntry", "CustomTextureLabel", Loc ["STRING_CUSTOM_SKIN_TEXTURE_DESC"])

	local custom_texture_cancel = g:NewButton (frame3.CustomTextureEntry, _, "$parentCustomTextureCancel", "CustomTextureCancel", 20, 20, function (self)
		local instance = _G.DetailsOptionsWindow.instance
		
		instance:SetUserCustomSkinFile ("")
		
		if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
			for _, this_instance in ipairs (instance:GetInstanceGroup()) do
				if (this_instance ~= instance) then
					this_instance:SetUserCustomSkinFile ("")
				end
			end
		end

		custom_texture:SetText ("")
		_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
	end)
	custom_texture_cancel:SetPoint ("left", frame3.CustomTextureEntry, "right", 2, 0)
	custom_texture_cancel:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
	custom_texture_cancel:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
	custom_texture_cancel:GetNormalTexture():SetDesaturated (true)
	custom_texture_cancel.tooltip = "Stop using the custom texture"
	custom_texture_cancel:SetHook ("OnEnter", function (self, capsule)
		self:GetNormalTexture():SetBlendMode("ADD")
	end)
	custom_texture_cancel:SetHook ("OnLeave", function (self, capsule)
		self:GetNormalTexture():SetBlendMode("BLEND")
	end)
	
	--> Skin
		local titulo_skin = g:NewLabel (frame3, _, "$parentTituloSkin", "tituloSkinLabel", Loc ["STRING_OPTIONS_SKIN_A"], "GameFontNormal", 16)
		local titulo_skin_desc = g:NewLabel (frame3, _, "$parentTituloSkin2", "tituloSkin2Label", Loc ["STRING_OPTIONS_SKIN_A_DESC"], "GameFontNormal", 10, "white")
		titulo_skin_desc.width = 320
		
	--> create functions and frames first:

		local loadStyle = function (_, instance, index)
		
			local style
		
			if (type (index) == "table") then
				style = index
			else
				style = _detalhes.savedStyles [index]
				if (not style.version or preset_version > style.version) then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_PRESETTOOLD"])
				end
			end
			
			--> set skin preset
			local skin = style.skin
			instance.skin = ""
			instance:ChangeSkin (skin)
			
			--> overwrite all instance parameters with saved ones
			for key, value in pairs (style) do
				if (key ~= "skin" and not _detalhes.instance_skin_ignored_values [key]) then
					if (type (value) == "table") then
						instance [key] = table_deepcopy (value)
					else
						instance [key] = value
					end
				end
			end
			
			--> apply all changed attributes
			instance:ChangeSkin()
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance.skin = ""
						this_instance:ChangeSkin (skin)
						
						--> overwrite all instance parameters with saved ones
						for key, value in pairs (style) do
							if (key ~= "skin" and not _detalhes.instance_skin_ignored_values [key]) then
								if (type (value) == "table") then
									this_instance [key] = table_deepcopy (value)
								else
									this_instance [key] = value
								end
							end
						end
						
						this_instance:ChangeSkin()
					end
				end
			end
			
			--> reload options panel
			_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		_detalhes.loadStyleFunc = loadStyle 
	
		--> select skin
		local onSelectSkin = function (_, instance, skin_name)
			instance:ChangeSkin (skin_name)
			
			if (instance._ElvUIEmbed) then
				local AS, ASL = unpack (AddOnSkins)
				AS:Embed_Details()
			end
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:ChangeSkin (skin_name)
						if (this_instance._ElvUIEmbed) then
							local AS, ASL = unpack (AddOnSkins)
							AS:Embed_Details()
						end
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local buildSkinMenu = function()
			local skinOptions = {}
			for skin_name, skin_table in pairs (_detalhes.skins) do
				local file = skin_table.file:gsub ([[Interface\AddOns\Details\images\skins\]], "")
				local desc = "Author: |cFFFFFFFF" .. skin_table.author .. "|r\nVersion: |cFFFFFFFF" .. skin_table.version .. "|r\nSite: |cFFFFFFFF" .. skin_table.site .. "|r\n\nDesc: |cFFFFFFFF" .. skin_table.desc .. "|r\n\nFile: |cFFFFFFFF" .. file .. ".tga|r"
				skinOptions [#skinOptions+1] = {value = skin_name, label = skin_name, onclick = onSelectSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", desc = desc}
			end
			return skinOptions
		end	
		
		-- skin
		local d = g:NewDropDown (frame3, _, "$parentSkinDropdown", "skinDropdown", 160, dropdown_height, buildSkinMenu, 1, options_dropdown_template)
		
		g:NewLabel (frame3, _, "$parentSkinLabel", "skinLabel", Loc ["STRING_OPTIONS_INSTANCE_SKIN"], "GameFontHighlightLeft")
		
		window:CreateLineBackground2 (frame3, "skinDropdown", "skinLabel", Loc ["STRING_OPTIONS_INSTANCE_SKIN_DESC"])
		
		frame3.skinDropdown:SetPoint ("left", frame3.skinLabel, "right", 2)

	--> Create New Skin
	
		local function saveStyleFunc (self, b, temp)
			if ((not frame3.saveStyleName.text or frame3.saveStyleName.text == "") and not temp) then
				_detalhes:Msg (Loc ["STRING_OPTIONS_PRESETNONAME"])
				return
			end
			
			local savedObject = {
				version = preset_version,
				name = frame3.saveStyleName.text, --> preset name
			}
			
			for key, value in pairs (_G.DetailsOptionsWindow.instance) do 
				if (_detalhes.instance_defaults [key] ~= nil) then	
					if (type (value) == "table") then
						savedObject [key] = table_deepcopy (value)
					else
						savedObject [key] = value
					end
				end
			end
			
			if (temp) then
				return savedObject
			end
			
			_detalhes.savedStyles [#_detalhes.savedStyles+1] = savedObject
			frame3.saveStyleName.text = ""
			frame3.saveStyleName:ClearFocus()
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_SKINCREATED"])

			_G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Refresh()
			_G.DetailsOptionsWindow3CustomSkinRemoveDropdown.MyObject:Refresh()
			_G.DetailsOptionsWindow3CustomSkinExportDropdown.MyObject:Refresh()
			
		end	
	
		g:NewTextEntry (frame3, _, "$parentSaveStyleName", "saveStyleName", 120, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		g:NewLabel (frame3, _, "$parentSaveSkinLabel", "saveSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_PNAME"], "GameFontHighlightLeft")
		frame3.saveStyleName:SetPoint ("left", frame3.saveSkinLabel, "right", 2)
		g:NewButton (frame3, _, "$parentSaveStyleButton", "saveStyle", 50, 18, saveStyleFunc, nil, nil, nil, Loc ["STRING_OPTIONS_SAVELOAD_SAVE"], nil, options_button_template)
		
		window:CreateLineBackground2 (frame3, "saveStyleName", "saveSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_CREATE_DESC"])

	--> apply to all button
		local applyToAll = function()
		
			local temp_preset = saveStyleFunc (nil, nil, true)
			local current_instance = _G.DetailsOptionsWindow.instance
			
			for _, this_instance in ipairs (_detalhes.tabela_instancias) do 
				if (this_instance.meu_id ~= _G.DetailsOptionsWindow.instance.meu_id) then
					if (not this_instance.iniciada) then
						this_instance:RestauraJanela()
						loadStyle (nil, this_instance, temp_preset)
						this_instance:DesativarInstancia()
					else
						loadStyle (nil, this_instance, temp_preset)
						_detalhes:SendOptionsModifiedEvent (this_instance)
					end
				end
			end
			
			_detalhes:OpenOptionsWindow (current_instance)
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_APPLYALL"])
			
		end
		
		local makeDefault = function()
			local temp_preset = saveStyleFunc (nil, nil, true)
			_detalhes.standard_skin = temp_preset
			_detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_STDSAVE"])
		end

		g:NewLabel (frame3, _, "$parentToAllStyleLabel", "toAllStyleLabel", "", "GameFontHighlightLeft")
		g:NewLabel (frame3, _, "$parentmakeDefaultLabel", "makeDefaultLabel", "", "GameFontHighlightLeft")
		
		g:NewButton (frame3, _, "$parentToAllStyleButton", "applyToAll", 160, 20, applyToAll, nil, nil, nil, Loc ["STRING_OPTIONS_SAVELOAD_APPLYTOALL"], 1, options_button_template)
		window:CreateLineBackground2 (frame3, "applyToAll", "applyToAll", Loc ["STRING_OPTIONS_SAVELOAD_APPLYALL_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		
		g:NewButton (frame3, _, "$parentMakeDefaultButton", "makeDefault", 160, 20, makeDefault, nil, nil, nil, Loc ["STRING_OPTIONS_SAVELOAD_MAKEDEFAULT"], nil, options_button_template)
		window:CreateLineBackground2 (frame3, "makeDefault", "makeDefault", Loc ["STRING_OPTIONS_SAVELOAD_STD_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		
		frame3.toAllStyleLabel:SetPoint ("left", frame3.applyToAll, "left")
		frame3.makeDefaultLabel:SetPoint ("left", frame3.makeDefault, "left")
		
		frame3.makeDefault:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], 14, 14, nil, {4/32, 28/32, 4/32, 28/32}, "yellow", 4, 2)
		frame3.applyToAll:SetIcon ([[Interface\Buttons\UI-HomeButton]], 14, 14, nil, {1/16, 14/16, 0, 1}, nil, 4, 2)
		frame3.makeDefault:SetTextColor (button_color_rgb)
		frame3.applyToAll:SetTextColor (button_color_rgb)

	--> Load Custom Skin
		g:NewLabel (frame3, _, "$parentLoadCustomSkinLabel", "loadCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_LOAD"], "GameFontHighlightLeft")
		--
		local onSelectCustomSkin = function (_, _, index)
			local style
		
			if (type (index) == "table") then
				style = index
			else
				style = _detalhes.savedStyles [index]
				if (not style.version or preset_version > style.version) then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_PRESETTOOLD"])
				end
			end
			
			--> set skin preset
			local skin = style.skin
			_G.DetailsOptionsWindow.instance.skin = ""
			_G.DetailsOptionsWindow.instance:ChangeSkin (skin)
			
			--> overwrite all instance parameters with saved ones
			for key, value in pairs (style) do
				if (key ~= "skin" and not _detalhes.instance_skin_ignored_values [key]) then
					if (type (value) == "table") then
						_G.DetailsOptionsWindow.instance [key] = table_deepcopy (value)
					else
						_G.DetailsOptionsWindow.instance [key] = value
					end
				end
			end
			
			--> apply all changed attributes
			_G.DetailsOptionsWindow.instance:ChangeSkin()
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance.skin = ""
						this_instance:ChangeSkin (skin)
						
						--> overwrite all instance parameters with saved ones
						for key, value in pairs (style) do
							if (key ~= "skin" and not _detalhes.instance_skin_ignored_values [key]) then
								if (type (value) == "table") then
									this_instance [key] = table_deepcopy (value)
								else
									this_instance [key] = value
								end
							end
						end
						
						this_instance:ChangeSkin()
					end
				end
			end			
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			
			--> reload options panel
			_detalhes:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
			
			_G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Select (false)
			_G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Refresh()
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_SKIN_LOADED"])
		end

		local loadtable = {}
		local buildCustomSkinMenu = function()
			table.wipe (loadtable)
			for index, _table in ipairs (_detalhes.savedStyles) do
				tinsert (loadtable, {value = index, label = _table.name, onclick = onSelectCustomSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", iconcolor = {.7, .7, .5, 1}})
			end
			return loadtable
		end
		
		local d = g:NewDropDown (frame3, _, "$parentCustomSkinLoadDropdown", "customSkinSelectDropdown", 160, dropdown_height, buildCustomSkinMenu, 0, options_dropdown_template)
		d:SetEmptyTextAndIcon (Loc ["STRING_OPTIONS_SKIN_SELECT"])
		
		frame3.customSkinSelectDropdown:SetPoint ("left", frame3.loadCustomSkinLabel, "right", 2, 0)
		
		window:CreateLineBackground2 (frame3, "customSkinSelectDropdown", "loadCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_LOAD_DESC"])
		
	--> Remove Custom Skin
		g:NewLabel (frame3, _, "$parentRemoveCustomSkinLabel", "removeCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_REMOVE"], "GameFontHighlightLeft")
		--
		local onSelectCustomSkinToErase = function (_, _, index)
			table.remove (_detalhes.savedStyles, index)
			_G.DetailsOptionsWindow3CustomSkinRemoveDropdown.MyObject:Select (false)
			_G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Refresh()
			_G.DetailsOptionsWindow3CustomSkinRemoveDropdown.MyObject:Refresh()
			_G.DetailsOptionsWindow3CustomSkinExportDropdown.MyObject:Refresh()
			_detalhes:Msg (Loc ["STRING_OPTIONS_SKIN_REMOVED"])
		end

		local loadtable2 = {}
		local buildCustomSkinToEraseMenu = function()
			table.wipe (loadtable2)
			for index, _table in ipairs (_detalhes.savedStyles) do
				tinsert (loadtable2, {value = index, label = _table.name, onclick = onSelectCustomSkinToErase, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}})
			end
			return loadtable2
		end
		
		local d = g:NewDropDown (frame3, _, "$parentCustomSkinRemoveDropdown", "customSkinSelectToRemoveDropdown", 160, dropdown_height, buildCustomSkinToEraseMenu, 0, options_dropdown_template)
		d:SetEmptyTextAndIcon (Loc ["STRING_OPTIONS_SKIN_SELECT"])

		
		frame3.customSkinSelectToRemoveDropdown:SetPoint ("left", frame3.removeCustomSkinLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame3, "customSkinSelectToRemoveDropdown", "removeCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_ERASE_DESC"])
		
	--> Export Custom Skin
		g:NewLabel (frame3, _, "$parentExportCustomSkinLabel", "ExportCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_EXPORT"], "GameFontHighlightLeft")
		--
		local onSelectCustomSkinToExport = function (_, _, index)
			local compressedData = Details:CompressData (_detalhes.savedStyles [index], "print")
			if (compressedData) then
				_detalhes:ShowImportWindow (compressedData, nil, "Details! Export Skin")
			else
				Details:Msg ("failed to export skin.") --localize-me
			end
			_G.DetailsOptionsWindow3CustomSkinExportDropdown.MyObject:Select (false)
		end

		local loadtable2 = {}
		local buildCustomSkinToExportMenu = function()
			table.wipe (loadtable2)
			for index, _table in ipairs (_detalhes.savedStyles) do
				tinsert (loadtable2, {value = index, label = _table.name, onclick = onSelectCustomSkinToExport, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}, texcoord = {1, 0, 0, 1}})
			end
			return loadtable2
		end
		
		local d = g:NewDropDown (frame3, _, "$parentCustomSkinExportDropdown", "CustomSkinSelectToExportDropdown", 160, dropdown_height, buildCustomSkinToExportMenu, 0, options_dropdown_template)
		d:SetEmptyTextAndIcon (Loc ["STRING_OPTIONS_SKIN_SELECT"])
		
		frame3.CustomSkinSelectToExportDropdown:SetPoint ("left", frame3.ExportCustomSkinLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame3, "CustomSkinSelectToExportDropdown", "ExportCustomSkinLabel", Loc ["STRING_OPTIONS_SAVELOAD_EXPORT_DESC"])
	
	--> Import Button
	
		local import_saved = function()
			--when clicking in the okay button in the import window, it send the text in the first argument
			_detalhes:ShowImportWindow ("", function (skinString)
				if (type (skinString) ~= "string" or string.len (skinString) < 2) then
					return
				end

				skinString = DetailsFramework:Trim (skinString)

				local dataTable = Details:DecompressData (skinString, "print")
				if (dataTable) then
					--add the new skin
					_detalhes.savedStyles [#_detalhes.savedStyles+1] = dataTable
					_detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_IMPORT_OKEY"])
					
					--refresh skin dropdowns
					_G.DetailsOptionsWindow3CustomSkinLoadDropdown.MyObject:Refresh()
					_G.DetailsOptionsWindow3CustomSkinRemoveDropdown.MyObject:Refresh()
					_G.DetailsOptionsWindow3CustomSkinExportDropdown.MyObject:Refresh()
				else
					Details:Msg (Loc ["STRING_CUSTOM_IMPORT_ERROR"])
				end
			
			end, "Details! Import Skin (paste string)") --localize-me
			
		end
	
		g:NewButton (frame3, _, "$parentImportButton", "ImportButton", 160, 20, import_saved, nil, nil, nil, Loc ["STRING_OPTIONS_SAVELOAD_IMPORT"], nil, options_button_template)
		--frame3.ImportButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
		frame3.ImportButton:SetIcon ([[Interface\Buttons\UI-GuildButton-PublicNote-Up]], 14, 14, nil, nil, nil, 4, 2)
		frame3.ImportButton:SetTextColor (button_color_rgb)
		
		g:NewLabel (frame3, _, "$parentImportLabel", "ImportLabel", "", "GameFontHighlightLeft")
		frame3.ImportLabel:SetPoint ("left", frame3.ImportButton, "left")
		
		window:CreateLineBackground2 (frame3, "ImportButton", "ImportButton", Loc ["STRING_OPTIONS_SAVELOAD_IMPORT_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
	
	--> player detail window
		g:NewLabel (frame3, _, "$parentPDWAnchor", "PDWAnchor", Loc ["STRING_OPTIONS_PDW_ANCHOR"], "GameFontNormal")
		
		--skin
		local onSelectPDWSkin = function (_, instance, skin_name)
			_detalhes:ApplyPDWSkin (skin_name)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local buildPDWSkinMenu = function()
			local skinOptions = {}
			for skin_name, skin_table in pairs (_detalhes.playerdetailwindow_skins) do
				local desc = "Author: |cFFFFFFFF" .. skin_table.author .. "|r\nVersion: |cFFFFFFFF" .. skin_table.version .. "|r\n\nDesc: |cFFFFFFFF" .. skin_table.desc .. "|r"
				skinOptions [#skinOptions+1] = {value = skin_name, label = skin_name, onclick = onSelectPDWSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", desc = desc}
			end
			return skinOptions
		end	
		
		-- skin
		local d = g:NewDropDown (frame3, _, "$parentPDWSkinDropdown", "PDWSkinDropdown", 160, dropdown_height, buildPDWSkinMenu, 1, options_dropdown_template)

		
		g:NewLabel (frame3, _, "$parentPDWSkinLabel", "PDWSkinLabel", Loc ["STRING_OPTIONS_INSTANCE_SKIN"], "GameFontHighlightLeft")
		window:CreateLineBackground2 (frame3, "PDWSkinDropdown", "PDWSkinLabel", Loc ["STRING_OPTIONS_PDW_SKIN_DESC"])
		frame3.PDWSkinDropdown:SetPoint ("left", frame3.PDWSkinLabel, "right", 2)

	--> chat tab embed
		g:NewLabel (frame3, _, "$parentChatTabEmbedAnchor", "ChatTabEmbedAnchor", Loc ["STRING_OPTIONS_TABEMB_ANCHOR"], "GameFontNormal")
		
		--> enabled
		g:NewSwitch (frame3, _, "$parentChatTabEmbedEnabledSlider", "ChatTabEmbedEnabledSlider", 60, 20, _, _, _detalhes.chat_tab_embed.enabled, nil, nil, nil, nil, options_switch_template)			
		g:NewLabel (frame3, _, "$parentChatTabEmbedEnabledLabel", "ChatTabEmbedEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")

		frame3.ChatTabEmbedEnabledSlider:SetPoint ("left", frame3.ChatTabEmbedEnabledLabel, "right", 2)
		frame3.ChatTabEmbedEnabledSlider:SetAsCheckBox()
		frame3.ChatTabEmbedEnabledSlider.OnSwitch = function (self, instance, value)
			_detalhes.chat_embed:SetTabSettings (_, value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame3, "ChatTabEmbedEnabledSlider", "ChatTabEmbedEnabledLabel", Loc ["STRING_OPTIONS_TABEMB_ENABLED_DESC"])
		
		--> window name
		local tab_on_press_enter = function (_, _, text)
			_detalhes.chat_embed:SetTabSettings (text)
		end
		local tabname = g:NewTextEntry (frame3, _, "$parentChatTabEmbedNameEntry", "ChatTabEmbedNameEntry", SLIDER_WIDTH, TEXTENTRY_HEIGHT, tab_on_press_enter, nil, nil, nil, nil, options_dropdown_template)
		g:NewLabel (frame3, _, "$parentChatTabEmbedNameLabel", "ChatTabEmbedNameLabel", Loc ["STRING_OPTIONS_TABEMB_TABNAME"], "GameFontHighlightLeft")
		tabname:SetPoint ("left", frame3.ChatTabEmbedNameLabel, "right", 2)
		
		window:CreateLineBackground2 (frame3, "ChatTabEmbedNameEntry", "ChatTabEmbedNameLabel", Loc ["STRING_OPTIONS_TABEMB_TABNAME_DESC"])
		tabname.text = _detalhes.chat_tab_embed.tab_name
		
		--> one or two windows
		g:NewSwitch (frame3, _, "$parentChatTabEmbed2WindowsSlider", "ChatTabEmbed2WindowsSlider", 60, 20, _, _, _detalhes.chat_tab_embed.single_window, nil, nil, nil, nil, options_switch_template)			
		g:NewLabel (frame3, _, "$parentChatTabEmbed2WindowsLabel", "ChatTabEmbed2WindowsLabel", Loc ["STRING_OPTIONS_TABEMB_SINGLE"], "GameFontHighlightLeft")

		frame3.ChatTabEmbed2WindowsSlider:SetPoint ("left", frame3.ChatTabEmbed2WindowsLabel, "right", 2)
		frame3.ChatTabEmbed2WindowsSlider:SetAsCheckBox()
		frame3.ChatTabEmbed2WindowsSlider.OnSwitch = function (self, instance, value)
			_detalhes.chat_embed:SetTabSettings (_, _, value)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame3, "ChatTabEmbed2WindowsSlider", "ChatTabEmbed2WindowsLabel", Loc ["STRING_OPTIONS_TABEMB_SINGLE_DESC"])
		
		--> size correction - width
			g:NewLabel (frame3, _, "$parentChatTabEmbedSizeCorrectionLabel", "ChatTabEmbedSizeCorrectionLabel", "Width Offset", "GameFontHighlightLeft")
			local s = g:NewSlider (frame3, _, "$parentChatTabEmbedSizeCorrectionSlider", "ChatTabEmbedSizeCorrectionSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -100, 100, 1, tonumber (_detalhes.chat_tab_embed.x_offset), nil, nil, nil, options_slider_template)

			frame3.ChatTabEmbedSizeCorrectionSlider:SetPoint ("left", frame3.ChatTabEmbedSizeCorrectionLabel, "right", 2)
			frame3.ChatTabEmbedSizeCorrectionSlider:SetHook ("OnValueChange", function (self, instance, amount) 
				_detalhes.chat_tab_embed.x_offset = amount
				
				if (_detalhes.chat_embed.enabled) then
					_detalhes.chat_embed:DoEmbed()
				end
				
				_detalhes:SendOptionsModifiedEvent (instance)
			end)	
			window:CreateLineBackground2 (frame3, "ChatTabEmbedSizeCorrectionSlider", "ChatTabEmbedSizeCorrectionLabel", "Fine tune the size of the window while embeded in the chat.")
		---------
		--> size correction - height
			g:NewLabel (frame3, _, "$parentChatTabEmbedSizeCorrection2Label", "ChatTabEmbedSizeCorrection2Label", "Height Offset", "GameFontHighlightLeft")
			local s = g:NewSlider (frame3, _, "$parentChatTabEmbedSizeCorrection2Slider", "ChatTabEmbedSizeCorrection2Slider", SLIDER_WIDTH, SLIDER_HEIGHT, -100, 100, 1, tonumber (_detalhes.chat_tab_embed.y_offset), nil, nil, nil, options_slider_template)

			frame3.ChatTabEmbedSizeCorrection2Slider:SetPoint ("left", frame3.ChatTabEmbedSizeCorrection2Label, "right", 2)
			frame3.ChatTabEmbedSizeCorrection2Slider:SetHook ("OnValueChange", function (self, instance, amount) 
				_detalhes.chat_tab_embed.y_offset = amount
				
				if (_detalhes.chat_embed.enabled) then
					_detalhes.chat_embed:DoEmbed()
				end
				
				_detalhes:SendOptionsModifiedEvent (instance)
			end)	
			window:CreateLineBackground2 (frame3, "ChatTabEmbedSizeCorrection2Slider", "ChatTabEmbedSizeCorrection2Label", "Fine tune the size of the window while embeded in the chat.")
		--------
	
	--> extra Options -~-extra
		g:NewLabel (frame3, _, "$parentSkinExtraOptionsAnchor", "SkinExtraOptionsAnchor", Loc ["STRING_OPTIONS_SKIN_EXTRA_OPTIONS_ANCHOR"], "GameFontNormal")
		--frame3.SkinExtraOptionsAnchor:Hide()
		--frame3.SkinExtraOptionsAnchor:SetPoint (window.right_start_at, window.top_start_at)
		frame3.ExtraOptions = {}
		
	--> Anchors
		
		--general anchor
		g:NewLabel (frame3, _, "$parentSkinSelectionAnchor", "SkinSelectionAnchorLabel", Loc ["STRING_OPTIONS_SKIN_SELECT_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame3, _, "$parentSkinPresetAnchor", "SkinPresetAnchorLabel", Loc ["STRING_OPTIONS_SKIN_PRESETS_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame3, _, "$parentSkinPresetConfigAnchor", "SkinPresetConfigAnchorLabel", Loc ["STRING_OPTIONS_SKIN_PRESETSCONFIG_ANCHOR"], "GameFontNormal")
		
		frame3.saveStyle:SetPoint ("left", frame3.saveStyleName, "right", 2)
		
		local x = window.left_start_at
		
		titulo_skin:SetPoint (x, window.title_y_pos)
		titulo_skin_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"SkinSelectionAnchorLabel", 1, true},
			{"skinLabel", 2},
			{custom_texture_label, 3},
			{"SkinPresetAnchorLabel", 4, true},
			{"saveSkinLabel", 5},
			
			{"SkinPresetConfigAnchorLabel", 6, true},
			{"loadCustomSkinLabel"},
			{"removeCustomSkinLabel", 7},
			{"ExportCustomSkinLabel", 8},
			
			{"ImportButton", 10, true},
			{"makeDefault", 11},
			{"applyToAll", 12},
			
			--{"PDWAnchor", 13, true},
			--{"PDWSkinLabel", 14},
		}
		
		local right_side = {
			{"ChatTabEmbedAnchor", 1, true}, 
			{"ChatTabEmbedEnabledLabel", 2}, 
			{"ChatTabEmbedNameLabel", 3}, 
			{"ChatTabEmbed2WindowsLabel", 4}, 
			{"ChatTabEmbedSizeCorrectionLabel"},
			{"ChatTabEmbedSizeCorrection2Label"},
			
			{"SkinExtraOptionsAnchor", 5, true},
		}
		
		window:arrange_menu (frame3, left_side, x, window.top_start_at)
		window:arrange_menu (frame3, right_side, window.right_start_at, window.top_start_at)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Row ~4
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame4()

	local frame4 = window.options [4][1]

	--> bars general
		local titulo_bars = g:NewLabel (frame4, _, "$parentTituloPersona", "tituloBarsLabel", Loc ["STRING_OPTIONS_BARS"], "GameFontNormal", 16)
		local titulo_bars_desc = g:NewLabel (frame4, _, "$parentTituloPersona2", "tituloBars2Label", Loc ["STRING_OPTIONS_BARS_DESC"], "GameFontNormal", 10, "white")
		titulo_bars_desc.width = 320
	
	--> general anchor
		g:NewLabel (frame4, _, "$parentRowGeneralAnchor", "RowGeneralAnchorLabel", Loc ["STRING_OPTIONS_GENERAL_ANCHOR"], "GameFontNormal")
	
	--> bar height
		g:NewLabel (frame4, _, "$parentRowHeightLabel", "rowHeightLabel", Loc ["STRING_OPTIONS_BAR_HEIGHT"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame4, _, "$parentSliderRowHeight", "rowHeightSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 10, 30, 1, tonumber (instance.row_info.height), nil, nil, nil, options_slider_template)
		--config_slider (s)

		frame4.rowHeightSlider:SetPoint ("left", frame4.rowHeightLabel, "right", 2)
		--frame4.rowHeightSlider:SetThumbSize (50)
		frame4.rowHeightSlider:SetHook ("OnValueChange", function (self, instance, amount) 
			instance:SetBarSettings (amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (instance)
		end)	
		window:CreateLineBackground2 (frame4, "rowHeightSlider", "rowHeightLabel", Loc ["STRING_OPTIONS_BAR_HEIGHT_DESC"])
	
	local orientation_icon_size = {14, 14}
	
	--> grow direction
		local set_bar_grow_direction = function (_, instance, value)
			instance:SetBarGrowDirection (value)
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarGrowDirection (value)
					end
				end
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local grow_icon_size = {14, 14}
		local grow_options = {
			{value = 1, label = Loc ["STRING_TOP_TO_BOTTOM"], iconsize = orientation_icon_size, onclick = set_bar_grow_direction, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0, 0.7}},
			{value = 2, label = Loc ["STRING_BOTTOM_TO_TOP"], iconsize = orientation_icon_size, onclick = set_bar_grow_direction, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0.7, 0}}
		}
		local grow_menu = function() 
			return grow_options
		end
		
		g:NewLabel (frame4, _, "$parentGrowLabel", "GrowLabel", Loc ["STRING_OPTIONS_BAR_GROW"], "GameFontHighlightLeft")
		g:NewDropDown (frame4, _, "$parentGrowDropdown", "GrowDropdown", DROPDOWN_WIDTH, dropdown_height, grow_menu, nil, options_dropdown_template)
		
		frame4.GrowDropdown:SetPoint ("left", frame4.GrowLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "GrowDropdown", "GrowLabel", Loc ["STRING_OPTIONS_BAR_GROW_DESC"])
	
	--> orientation
		--texture
		local set_bar_orientation = function (_, instance, value)
			instance:SetBarOrientationDirection (value)
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarOrientationDirection (value)
					end
				end
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local orientation_options = {
			{value = false, label = Loc ["STRING_LEFT_TO_RIGHT"], iconsize = orientation_icon_size, onclick = set_bar_orientation, icon = [[Interface\CHATFRAME\ChatFrameExpandArrow]]},
			{value = true, label = Loc ["STRING_RIGHT_TO_LEFT"], iconsize = orientation_icon_size, onclick = set_bar_orientation, icon = [[Interface\CHATFRAME\ChatFrameExpandArrow]], texcoord = {1, 0, 0, 1}}
		}
		local orientation_menu = function() 
			return orientation_options
		end
		
		g:NewLabel (frame4, _, "$parentOrientationLabel", "OrientationLabel", Loc ["STRING_OPTIONS_BARORIENTATION"], "GameFontHighlightLeft")
		g:NewDropDown (frame4, _, "$parentOrientationDropdown", "OrientationDropdown", DROPDOWN_WIDTH, dropdown_height, orientation_menu, nil, options_dropdown_template)			
		
		frame4.OrientationDropdown:SetPoint ("left", frame4.OrientationLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "OrientationDropdown", "OrientationLabel", Loc ["STRING_OPTIONS_BARORIENTATION_DESC"])
	
	--> sort direction
		local set_bar_sorting = function (_, instance, value)
			instance.bars_sort_direction = value
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance.bars_sort_direction = value
					end
				end
			end
			
			_detalhes:AtualizaGumpPrincipal (-1, true)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)			
		end

		local sorting_options = {
			{value = 1, label = Loc ["STRING_DESCENDING"], iconsize ={14, 14}, onclick = set_bar_sorting, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0, 0.7}},
			{value = 2, label = Loc ["STRING_ASCENDING"], iconsize = {14, 14}, onclick = set_bar_sorting, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0.7, 0}}
		}
		local sorting_menu = function() 
			return sorting_options
		end

		g:NewLabel (frame4, _, "$parentSortLabel", "SortLabel", Loc ["STRING_OPTIONS_BARSORT"], "GameFontHighlightLeft")
		g:NewDropDown (frame4, _, "$parentSortDropdown", "SortDropdown", DROPDOWN_WIDTH, dropdown_height, sorting_menu, nil, options_dropdown_template)			
		
		frame4.SortDropdown:SetPoint ("left", frame4.SortLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "SortDropdown", "SortLabel", Loc ["STRING_OPTIONS_BARSORT_DESC"])

	-- spacement
		g:NewLabel (frame4, _, "$parentBarSpacementLabel", "BarSpacementLabel", Loc ["STRING_OPTIONS_BAR_SPACING"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame4, _, "$parentBarSpacementSizeSlider", "BarSpacementSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -2, 10, 1, instance.row_info.space.between, nil, nil, nil, options_slider_template)
		--config_slider (s)
	
		frame4.BarSpacementSlider:SetPoint ("left", frame4.BarSpacementLabel, "right", 2)
		frame4.BarSpacementSlider:SetHook ("OnValueChange", function (self, instancia, amount)
			instancia:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instancia:GetInstanceGroup()) do
					if (this_instance ~= instancia) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		window:CreateLineBackground2 (frame4, "BarSpacementSlider", "BarSpacementLabel", Loc ["STRING_OPTIONS_BAR_SPACING_DESC"])
	
	--> Top Texture
	
		local texture_icon = [[Interface\TARGETINGFRAME\UI-PhasingIcon]]
		local texture_icon = [[Interface\AddOns\Details\images\icons]]
		local texture_icon_size = {14, 14}
		local texture_texcoord = {469/512, 505/512, 249/512, 284/512}
	
		--anchor
		g:NewLabel (frame4, _, "$parentRowUpperTextureAnchor", "rowUpperTextureLabel", Loc ["STRING_OPTIONS_TEXT_TEXTUREU_ANCHOR"], "GameFontNormal")
	
		--texture
		local onSelectTexture = function (_, instance, textureName)
			instance:SetBarSettings (nil, textureName)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, textureName)
					end
				end
			end			
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local buildTextureMenu = function() 
			local textures = SharedMedia:HashTable ("statusbar")
			local texTable = {}
			for name, texturePath in pairs (textures) do 
				texTable[#texTable+1] = {value = name, label = name, iconsize = texture_icon_size, statusbar = texturePath,  onclick = onSelectTexture, icon = texture_icon, texcoord = texture_texcoord}
			end
			table.sort (texTable, function (t1, t2) return t1.label < t2.label end)
			return texTable 
		end
		
		g:NewLabel (frame4, _, "$parentTextureLabel", "textureLabel", Loc ["STRING_TEXTURE"], "GameFontHighlightLeft")
		local d = g:NewDropDown (frame4, _, "$parentTextureDropdown", "textureDropdown", DROPDOWN_WIDTH, dropdown_height, buildTextureMenu, nil, options_dropdown_template)			


		frame4.textureDropdown:SetPoint ("left", frame4.textureLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "textureDropdown", "textureLabel", Loc ["STRING_OPTIONS_BAR_TEXTURE_DESC"])

		--> custom bar texture
		local custom_texture = g:NewTextEntry (frame4, _, "$parentCustomTextureEntry", "CustomTextureEntry", 120, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		local custom_texture_label = g:NewLabel (frame4, _, "$parentCustomTextureLabel", "CustomTextureLabel", Loc ["STRING_OPTIONS_BARS_CUSTOM_TEXTURE"], "GameFontHighlightLeft")
		custom_texture:SetPoint ("left", custom_texture_label, "right", 2, 0)

		custom_texture:SetHook ("OnEnterPressed", function()
			local instance = _G.DetailsOptionsWindow.instance
			local file_name = custom_texture.text
			
			instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, file_name)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, file_name)
					end
				end
			end

			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame4, "CustomTextureEntry", "CustomTextureLabel", Loc ["STRING_CUSTOM_SKIN_TEXTURE_DESC"] .. Loc ["STRING_OPTIONS_BARS_CUSTOM_TEXTURE_DESC"])

		local custom_texture_cancel = g:NewButton (frame4.CustomTextureEntry, _, "$parentCustomTextureCancel", "CustomTextureCancel", 20, 20, function (self)
			local instance = _G.DetailsOptionsWindow.instance
			
			instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "")
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "")
					end
				end
			end

			custom_texture:SetText ("")
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		custom_texture_cancel:SetPoint ("left", frame4.CustomTextureEntry, "right", 2, 0)
		custom_texture_cancel:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		custom_texture_cancel:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		custom_texture_cancel:GetNormalTexture():SetDesaturated (true)
		custom_texture_cancel.tooltip = "Stop using the custom texture"
		custom_texture_cancel:SetHook ("OnEnter", function (self, capsule)
			self:GetNormalTexture():SetBlendMode("ADD")
		end)
		custom_texture_cancel:SetHook ("OnLeave", function (self, capsule)
			self:GetNormalTexture():SetBlendMode("BLEND")
		end)		

		-- row texture color
		local rowcolor_callback = function (button, r, g, b, a)
			_G.DetailsOptionsWindow.instance.row_info.alpha = a
			_G.DetailsOptionsWindow.instance:SetBarSettings (nil, nil, nil, {r, g, b})
			_G.DetailsOptionsWindow.instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, a)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance.row_info.alpha = a
						this_instance:SetBarSettings (nil, nil, nil, {r, g, b})
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, a)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewLabel (frame4, _, "$parentRowColorPickLabel", "rowPickColorLabel", Loc ["STRING_COLOR"], "GameFontHighlightLeft")
		g:NewColorPickButton (frame4, "$parentRowColorPick", "rowColorPick", rowcolor_callback, nil, options_button_template)
		frame4.rowColorPick:SetPoint ("left", frame4.rowPickColorLabel, "right", 2, 0)
		local background = window:CreateLineBackground2 (frame4, "rowColorPick", "rowPickColorLabel", Loc ["STRING_OPTIONS_BAR_COLOR_DESC"])
		background:SetSize (50, 16)

		-- bar texture by class color
		g:NewLabel (frame4, _, "$parentUseClassColorsLabel", "classColorsLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"], "GameFontHighlightLeft")
		g:NewSwitch (frame4, _, "$parentClassColorSlider", "classColorSlider", 60, 20, _, _, instance.row_info.texture_class_colors, nil, nil, nil, nil, options_switch_template)
		frame4.classColorSlider:SetFrameLevel (frame4.rowColorPick:GetFrameLevel()+2)
		frame4.classColorSlider:SetAsCheckBox()
		frame4.classColorSlider:SetPoint ("left", frame4.classColorsLabel, "right", 2, -1)
		frame4.classColorSlider.OnSwitch = function (self, instance, value)
			instance:SetBarSettings (nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame4, "classColorSlider", "classColorsLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"])		
		
	--> Bottom Texture
	
		--anchor
		g:NewLabel (frame4, _, "$parentRowLowerTextureAnchor", "rowLowerTextureLabel", Loc ["STRING_OPTIONS_TEXT_TEXTUREL_ANCHOR"], "GameFontNormal")
	
		--texture
		local onSelectTextureBackground = function (_, instance, textureName)
			instance:SetBarSettings (nil, nil, nil, nil, textureName)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, textureName)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local buildTextureMenu2 = function() 
			local textures2 = SharedMedia:HashTable ("statusbar")
			local texTable2 = {}
			for name, texturePath in pairs (textures2) do 
				texTable2[#texTable2+1] = {value = name, label = name, iconsize = texture_icon_size, statusbar = texturePath,  onclick = onSelectTextureBackground, icon = texture_icon, texcoord = texture_texcoord}
			end
			table.sort (texTable2, function (t1, t2) return t1.label < t2.label end)
			return texTable2 
		end
		
		g:NewLabel (frame4, _, "$parentRowBackgroundTextureLabel", "rowBackgroundLabel", Loc ["STRING_TEXTURE"], "GameFontHighlightLeft")
		local d = g:NewDropDown (frame4, _, "$parentRowBackgroundTextureDropdown", "rowBackgroundDropdown", DROPDOWN_WIDTH, dropdown_height, buildTextureMenu2, nil, options_dropdown_template)			
	
		
		frame4.rowBackgroundDropdown:SetPoint ("left", frame4.rowBackgroundLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "rowBackgroundDropdown", "rowBackgroundLabel", Loc ["STRING_OPTIONS_BAR_BTEXTURE_DESC"])
		
		--bar background color	
		local rowcolorbackground_callback = function (button, r, g, b, a)
			_G.DetailsOptionsWindow.instance:SetBarSettings (nil, nil, nil, nil, nil, nil, {r, g, b, a})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, {r, g, b, a})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame4, "$parentRowBackgroundColorPick", "rowBackgroundColorPick", rowcolorbackground_callback, nil, options_button_template)
		g:NewLabel (frame4, _, "$parentRowBackgroundColorPickLabel", "rowBackgroundPickLabel", Loc ["STRING_COLOR"], "GameFontHighlightLeft")
		frame4.rowBackgroundColorPick:SetPoint ("left", frame4.rowBackgroundPickLabel, "right", 2, 0)

		local background = window:CreateLineBackground2 (frame4, "rowBackgroundColorPick", "rowBackgroundPickLabel", Loc ["STRING_OPTIONS_BAR_COLOR_DESC"])
		background:SetSize (50, 16)
		
		--bar texture by class color
		g:NewSwitch (frame4, _, "$parentBackgroundClassColorSlider", "rowBackgroundColorByClassSlider", 60, 20, _, _, instance.row_info.texture_background_class_color, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame4, _, "$parentRowBackgroundClassColorLabel", "rowBackgroundColorByClassLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"], "GameFontHighlightLeft")
		frame4.rowBackgroundColorByClassSlider:SetFrameLevel (frame4.rowBackgroundColorPick:GetFrameLevel()+2)
		frame4.rowBackgroundColorByClassSlider:SetAsCheckBox()
		frame4.rowBackgroundColorByClassSlider:SetPoint ("left", frame4.rowBackgroundColorByClassLabel, "right", 2)
		frame4.rowBackgroundColorByClassSlider.OnSwitch = function (self, instance, value)
			instance:SetBarSettings (nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame4, "rowBackgroundColorByClassSlider", "rowBackgroundColorByClassLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"])
	
		--frame4.rowBackgroundColorByClassLabel:SetPoint ("left", frame4.rowBackgroundColorPick, "right", 3)
		
		
	--> Icons
	--> anchors
		g:NewLabel (frame4, _, "$parentIconsAnchor", "rowIconsLabel", Loc ["STRING_OPTIONS_TEXT_ROWICONS_ANCHOR"], "GameFontNormal")
		
	--> icon file
	
		--> textbox
		g:NewTextEntry (frame4, _, "$parentIconFileEntry", "iconFileEntry", 180, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
	
		g:NewLabel (frame4, _, "$parentIconFileLabel", "iconFileLabel", Loc ["STRING_OPTIONS_BAR_ICONFILE"], "GameFontHighlightLeft")
		g:NewLabel (frame4, _, "$parentIconFileLabel2", "iconFileLabel2", "", "GameFontHighlightLeft")
	
		--> dropdown
		local OnSelectIconFile = function (_, _, iconpath)
			_G.DetailsOptionsWindow.instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, iconpath)
			frame4.iconFileEntry:SetText (iconpath)
			
			if (_G.DetailsOptionsWindow.instance.row_info.use_spec_icons) then
				_G.DetailsOptionsWindow.instance:SetBarSpecIconSettings (false)
			end
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, iconpath)
						if (this_instance.row_info.use_spec_icons) then
							this_instance:SetBarSpecIconSettings (false)
						end
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local OnSelectIconFileSpec = function (_, _, iconpath)
			_G.DetailsOptionsWindow.instance:SetBarSpecIconSettings (true, iconpath, true)
			frame4.iconFileEntry:SetText (iconpath)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance:SetBarSpecIconSettings (true, iconpath, true)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local iconsize = {16, 16}
		local icontexture = [[Interface\WorldStateFrame\ICONS-CLASSES]]
		local iconcoords = {0.25, 0.50, 0, 0.25}
		local list = {
			{value = [[]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE1"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize, iconcolor = {1, 1, 1, .3}},
			{value = [[Interface\AddOns\Details\images\classes_small]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE2"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\spec_icons_normal]], label = "Specialization", onclick = OnSelectIconFileSpec, icon = [[Interface\AddOns\Details\images\icons]], texcoord = {2/512, 32/512, 480/512, 510/512}, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\spec_icons_normal_alpha]], label = "Specialization Alpha", onclick = OnSelectIconFileSpec, icon = [[Interface\AddOns\Details\images\icons]], texcoord = {2/512, 32/512, 480/512, 510/512}, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\classes_small_bw]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE3"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\classes_small_alpha]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE4"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\classes_small_alpha_bw]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE6"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
			{value = [[Interface\AddOns\Details\images\classes]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE5"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
		}
		local BuiltIconList = function() 
			return list
		end
		
		local default
		if (instance.row_info.use_spec_icons) then
			default = _G.DetailsOptionsWindow.instance.row_info.spec_file
		else
			default = instance.row_info.icon_file
		end
		
		local d = g:NewDropDown (frame4, _, "$parentIconSelectDropdown", "IconSelectDropdown", DROPDOWN_WIDTH, dropdown_height, BuiltIconList, default, options_dropdown_template)
		
		d:SetPoint ("left", frame4.iconFileLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "IconSelectDropdown", "iconFileLabel", Loc ["STRING_OPTIONS_BAR_ICONFILE_DESC2"])
		--
		
		frame4.iconFileEntry:SetPoint ("topleft", frame4.iconFileLabel, "bottomleft", 0, -3)
		--frame4.iconFileEntry:SetPoint ("topright", frame4.IconSelectDropdown, "bottomright", 0, 0)

		frame4.iconFileEntry.tooltip = "- Press escape to restore default value.\n- Leave empty to hide icons."
		frame4.iconFileEntry:SetHook ("OnEnterPressed", function()
		
			local instance = _G.DetailsOptionsWindow.instance
		
			local text = frame4.iconFileEntry.text
			if (text:find ("spec_")) then
				instance:SetBarSpecIconSettings (true, text, true)
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:SetBarSpecIconSettings (true, text, true)
						end
					end
				end
			else
				if (instance.row_info.use_spec_icons) then
					instance:SetBarSpecIconSettings (false)
				end
				instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, text)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							if (this_instance.row_info.use_spec_icons) then
								this_instance:SetBarSpecIconSettings (false)
							end
							this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, text)
						end
					end
				end
			end
			
			d:Select (false)
			d:Select (frame4.iconFileEntry.text)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		frame4.iconFileEntry:SetHook ("OnEscapePressed", function()
			local instance = _G.DetailsOptionsWindow.instance
		
			if (instance.row_info.use_spec_icons) then
				frame4.iconFileEntry:SetText (instance.row_info.spec_file)
			else
				frame4.iconFileEntry:SetText (instance.row_info.icon_file)
			end
			
			frame4.iconFileEntry:ClearFocus()
			return true
		end)
		
		window:CreateLineBackground2 (frame4, "iconFileEntry", "iconFileLabel", Loc ["STRING_OPTIONS_BAR_ICONFILE_DESC"])
		
		frame4.iconFileEntry.text = instance.row_info.icon_file
		
		g:NewButton (frame4.iconFileEntry, _, "$parentNoIconButton", "noIconButton", 20, 20, function()
			if (frame4.iconFileEntry.text == "") then
				frame4.iconFileEntry.text = [[Interface\AddOns\Details\images\classes_small]]
				frame4.iconFileEntry:PressEnter()
			else
				frame4.iconFileEntry.text = ""
				frame4.iconFileEntry:PressEnter()
			end
		end)
		
		frame4.noIconButton = frame4.iconFileEntry.noIconButton
		frame4.noIconButton:SetPoint ("left", frame4.iconFileEntry, "right", 2, 0)
		frame4.noIconButton:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		frame4.noIconButton:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		frame4.noIconButton:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		frame4.noIconButton:GetNormalTexture():SetDesaturated (true)
		frame4.noIconButton.tooltip = "Clear icon file / Restore default"

	--> bar start at
		g:NewSwitch (frame4, _, "$parentBarStartSlider", "barStartSlider", 60, 20, nil, nil, instance.row_info.start_after_icon, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame4, _, "$parentBarStartLabel", "barStartLabel", Loc ["STRING_OPTIONS_BARSTART"], "GameFontHighlightLeft")

		frame4.barStartSlider:SetAsCheckBox()
		frame4.barStartSlider:SetPoint ("left", frame4.barStartLabel, "right", 2)
		frame4.barStartSlider.OnSwitch = function (self, instance, value)
			instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame4, "barStartSlider", "barStartLabel", Loc ["STRING_OPTIONS_BARSTART_DESC"])
		
	--> Backdrop
		--anchor
		g:NewLabel (frame4, _, "$parentBackdropAnchor", "BackdropAnchorLabel", Loc ["STRING_OPTIONS_BAR_BACKDROP_ANCHOR"], "GameFontNormal")

		--enabled
		g:NewLabel (frame4, _, "$parentBackdropEnabledLabel", "BackdropEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame4, _, "$parentBackdropEnabledSlider", "BackdropEnabledSlider", 60, 20, _, _, instance.row_info.backdrop.enabled, nil, nil, nil, nil, options_switch_template)
		frame4.BackdropEnabledSlider:SetPoint ("left", frame4.BackdropEnabledLabel, "right", 2, -1)
		frame4.BackdropEnabledSlider:SetAsCheckBox()
		frame4.BackdropEnabledSlider.OnSwitch = function (self, instance, value)
			instance:SetBarBackdropSettings (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarBackdropSettings (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame4, "BackdropEnabledSlider", "BackdropEnabledLabel", Loc ["STRING_OPTIONS_BAR_BACKDROP_ENABLED_DESC"])
		
		--texture
		local onSelectTextureBackdrop = function (_, instance, textureName)
			instance:SetBarBackdropSettings (nil, nil, nil, textureName)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarBackdropSettings (nil, nil, nil, textureName)
					end
				end
			end			
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		local iconsize = {16, 16}
		local buildTextureBackdropMenu = function() 
			local textures2 = SharedMedia:HashTable ("border")
			local texTable2 = {}
			for name, texturePath in pairs (textures2) do 
				texTable2 [#texTable2+1] = {value = name, label = name, onclick = onSelectTextureBackdrop, icon = [[Interface\DialogFrame\UI-DialogBox-Corner]], texcoord = {0.09375, 1, 0, 0.78}, iconsize = iconsize}
			end
			table.sort (texTable2, function (t1, t2) return t1.label < t2.label end)
			return texTable2 
		end
		
		g:NewLabel (frame4, _, "$parentBackdropBorderTextureLabel", "BackdropBorderTextureLabel", Loc ["STRING_TEXTURE"], "GameFontHighlightLeft")
		local d = g:NewDropDown (frame4, _, "$parentBackdropBorderTextureDropdown", "BackdropBorderTextureDropdown", DROPDOWN_WIDTH, dropdown_height, buildTextureBackdropMenu, nil, options_dropdown_template)			
		
		frame4.BackdropBorderTextureDropdown:SetPoint ("left", frame4.BackdropBorderTextureLabel, "right", 2)
		window:CreateLineBackground2 (frame4, "BackdropBorderTextureDropdown", "BackdropBorderTextureLabel", Loc ["STRING_OPTIONS_BAR_BACKDROP_TEXTURE_DESC"])
		
		--size
		g:NewLabel (frame4, _, "$parentBackdropSizeLabel", "BackdropSizeLabel", Loc ["STRING_OPTIONS_SIZE"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame4, _, "$parentBackdropSizeHeight", "BackdropSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 20, 1, tonumber (instance.row_info.height), nil, nil, nil, options_slider_template)
		--config_slider (s)

		frame4.BackdropSizeSlider:SetPoint ("left", frame4.BackdropSizeLabel, "right", 2)
		--frame4.BackdropSizeSlider:SetThumbSize (50)
		frame4.BackdropSizeSlider:SetHook ("OnValueChange", function (self, instance, amount) 
			instance:SetBarBackdropSettings (nil, amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarBackdropSettings (nil, amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)	
		window:CreateLineBackground2 (frame4, "BackdropSizeSlider", "BackdropSizeLabel", Loc ["STRING_OPTIONS_BAR_BACKDROP_SIZE_DESC"])

		--color
		local backdropcolor_callback = function (button, r, g, b, a)
			_G.DetailsOptionsWindow.instance:SetBarBackdropSettings (nil, nil, {r, g, b, a})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (_G.DetailsOptionsWindow.instance:GetInstanceGroup()) do
					if (this_instance ~= _G.DetailsOptionsWindow.instance) then
						this_instance:SetBarBackdropSettings (nil, nil, {r, g, b, a})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame4, "$parentBackdropColorPick", "BackdropColorPick", backdropcolor_callback, nil, options_button_template)
		g:NewLabel (frame4, _, "$parentBackdropColorLabel", "BackdropColorLabel", Loc ["STRING_COLOR"], "GameFontHighlightLeft")
		frame4.BackdropColorPick:SetPoint ("left", frame4.BackdropColorLabel, "right", 2, 0)

		local background = window:CreateLineBackground2 (frame4, "BackdropColorPick", "BackdropColorLabel", Loc ["STRING_OPTIONS_BAR_BACKDROP_COLOR_DESC"])

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		--> disable bar highlight
		g:NewLabel (frame4, _, "$parentDisableBarHighlightLabel", "DisableBarHighlightLabel", Loc ["STRING_OPTIONS_DISABLE_BARHIGHLIGHT"], "GameFontHighlightLeft")
		g:NewSwitch (frame4, _, "$parentDisableBarHighlightSlider", "DisableBarHighlightSlider", 60, 20, _, _, _detalhes.instances_disable_bar_highlight, nil, nil, nil, nil, options_switch_template)
		
		frame4.DisableBarHighlightSlider:SetPoint ("left", frame4.DisableBarHighlightLabel, "right", 2)
		frame4.DisableBarHighlightSlider:SetAsCheckBox()
		frame4.DisableBarHighlightSlider.OnSwitch = function (_, _, value)
			_detalhes.instances_disable_bar_highlight = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame4, "DisableBarHighlightSlider", "DisableBarHighlightLabel", Loc ["STRING_OPTIONS_DISABLE_BARHIGHLIGHT_DESC"])

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	--> Anchors:
		local x = window.left_start_at
		
		titulo_bars:SetPoint (x, window.title_y_pos)
		titulo_bars_desc:SetPoint (x, window.title_y_pos2)

		local left_side = {
			--basic
			{frame4.RowGeneralAnchorLabel, 1, true},
			
			{frame4.rowHeightLabel, 1},
			{frame4.BarSpacementLabel, 1},
			{"DisableBarHighlightLabel", 1},
			
			{"GrowLabel", 2, true},
			{"OrientationLabel", 2},
			{"SortLabel", 2},

			--backdrop
			{frame4.BackdropAnchorLabel, 3, true},
			{frame4.BackdropColorLabel, 3},
			{frame4.BackdropEnabledLabel, 3},
			{frame4.BackdropSizeLabel, 3},
			{frame4.BackdropBorderTextureLabel, 3},
		}
		
		local right_side = {
			--textures
			{frame4.rowUpperTextureLabel, 1, true},
			{frame4.textureLabel, 2},
			{custom_texture_label, 3},
			{frame4.classColorsLabel, 4},
			{frame4.rowPickColorLabel, 5},
			
			{frame4.rowLowerTextureLabel, 6, true},
			{frame4.rowBackgroundLabel, 7},
			{frame4.rowBackgroundColorByClassLabel, 8},
			{frame4.rowBackgroundPickLabel, 9},
			--icon
			{frame4.rowIconsLabel, 10, true},
			{frame4.iconFileLabel, 11},
			{frame4.iconFileLabel2, 12},
			{frame4.barStartLabel, 13},			
		}
		
		window:arrange_menu (frame4, left_side, x, window.top_start_at)
		window:arrange_menu (frame4, right_side, 360, window.top_start_at)

end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Texts ~5
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame5()

	local frame5 = window.options [5][1]
	
	--> bars text
		local titulo_texts = g:NewLabel (frame5, _, "$parentTituloPersona", "tituloBarsLabel", Loc ["STRING_OPTIONS_TEXT"], "GameFontNormal", 16)
		local titulo_texts_desc = g:NewLabel (frame5, _, "$parentTituloPersona2", "tituloBars2Label", Loc ["STRING_OPTIONS_TEXT_DESC"], "GameFontNormal", 10, "white")
		titulo_texts_desc.width = 320
	
	--> text color
		local textcolor_callback = function (button, r, g, b, a)
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, {r, g, b, 1})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, {r, g, b, 1})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame5, "$parentFixedTextColor", "fixedTextColor", textcolor_callback, false, options_button_template)
		local fixedColorText = g:NewLabel (frame5, _, "$parentFixedTextColorLabel", "fixedTextColorLabel", Loc ["STRING_OPTIONS_TEXT_FIXEDCOLOR"], "GameFontHighlightLeft")
		frame5.fixedTextColor:SetPoint ("left", fixedColorText, "right", 2, 0)
	
		window:CreateLineBackground2 (frame5, "fixedTextColor", "fixedTextColorLabel", Loc ["STRING_OPTIONS_TEXT_FIXEDCOLOR_DESC"])
	
	--> text size
		local s = g:NewSlider (frame5, _, "$parentSliderFontSize", "fonsizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 5, 32, 1, tonumber (instance.row_info.font_size), nil, nil, nil, options_slider_template)
		--config_slider (s)
		
		g:NewLabel (frame5, _, "$parentFontSizeLabel", "fonsizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE"], "GameFontHighlightLeft")
		frame5.fonsizeSlider:SetPoint ("left", frame5.fonsizeLabel, "right", 2)
		--frame5.fonsizeSlider:SetThumbSize (50)
		frame5.fonsizeSlider:SetHook ("OnValueChange", function (self, instance, amount)
			instance:SetBarTextSettings (amount)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (amount)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)

		window:CreateLineBackground2 (frame5, "fonsizeSlider", "fonsizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE_DESC"])
		
	--> Text Fonts

		local onSelectFont = function (_, instance, fontName)
			instance:SetBarTextSettings (nil, fontName)

			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, fontName)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local buildFontMenu = function() 
			local fontObjects = SharedMedia:HashTable ("font")
			local fontTable = {}
			for name, fontPath in pairs (fontObjects) do 
				fontTable[#fontTable+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = onSelectFont, font = fontPath, descfont = name, desc = Loc ["STRING_MUSIC_DETAILS_ROBERTOCARLOS"]}
			end
			table.sort (fontTable, function (t1, t2) return t1.label < t2.label end)
			return fontTable 
		end
		
		local d = g:NewDropDown (frame5, _, "$parentFontDropdown", "fontDropdown", DROPDOWN_WIDTH, dropdown_height, buildFontMenu, nil, options_dropdown_template)		
		
		g:NewLabel (frame5, _, "$parentFontLabel", "fontLabel", Loc ["STRING_OPTIONS_TEXT_FONT"], "GameFontHighlightLeft")
		frame5.fontDropdown:SetPoint ("left", frame5.fontLabel, "right", 2)

		window:CreateLineBackground2 (frame5, "fontDropdown", "fontLabel", Loc ["STRING_OPTIONS_TEXT_FONT_DESC"])		

	--> left text and right class color
		g:NewSwitch (frame5, _, "$parentUseClassColorsLeftTextSlider", "classColorsLeftTextSlider", 60, 20, _, _, instance.row_info.textL_class_colors, nil, nil, nil, nil, options_switch_template)
		g:NewSwitch (frame5, _, "$parentUseClassColorsRightTextSlider", "classColorsRightTextSlider", 60, 20, _, _, instance.row_info.textR_class_colors, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentUseClassColorsLeftText", "classColorsLeftTextLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"], "GameFontHighlightLeft")

		frame5.classColorsLeftTextSlider:SetPoint ("left", frame5.classColorsLeftTextLabel, "right", 2)
		frame5.classColorsRightTextSlider:SetAsCheckBox()
		frame5.classColorsLeftTextSlider:SetAsCheckBox()
		frame5.classColorsLeftTextSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "classColorsLeftTextSlider", "classColorsLeftTextLabel", Loc ["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"])
		
	--> right text by class color
		g:NewLabel (frame5, _, "$parentUseClassColorsRightText", "classColorsRightTextLabel", Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"], "GameFontHighlightLeft")

		frame5.classColorsRightTextSlider:SetPoint ("left", frame5.classColorsRightTextLabel, "right", 2)
		frame5.classColorsRightTextSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "classColorsRightTextSlider", "classColorsRightTextLabel", Loc ["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"])
		
	--> left outline
		g:NewSwitch (frame5, _, "$parentTextLeftOutlineSlider", "textLeftOutlineSlider", 60, 20, _, _, instance.row_info.textL_outline, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentTextLeftOutlineLabel", "textLeftOutlineLabel", Loc ["STRING_OPTIONS_TEXT_LOUTILINE"], "GameFontHighlightLeft")
		
		frame5.textLeftOutlineSlider:SetPoint ("left", frame5.textLeftOutlineLabel, "right", 2)
		frame5.textLeftOutlineSlider:SetAsCheckBox()
		frame5.textLeftOutlineSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "textLeftOutlineSlider", "textLeftOutlineLabel", Loc ["STRING_OPTIONS_TEXT_LOUTILINE_DESC"])
		
	--> left outline small
		g:NewSwitch (frame5, _, "$parentTextLeftOutlineSmallSlider", "textLeftOutlineSmallSlider", 60, 20, _, _, instance.row_info.textL_outline_small, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentTextLeftOutlineSmallLabel", "textLeftOutlineSmallLabel", "Outline", "GameFontHighlightLeft")
		
		frame5.textLeftOutlineSmallSlider:SetPoint ("left", frame5.textLeftOutlineSmallLabel, "right", 2)
		frame5.textLeftOutlineSmallSlider:SetAsCheckBox()
		frame5.textLeftOutlineSmallSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
	
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "textLeftOutlineSmallSlider", "textLeftOutlineSmallLabel", "Text Outline")
		
	--> left outline small color
		local left_outline_small_callback = function (button, r, g, b, a)
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame5, "$parentOutlineSmallColorLeft", "OutlineSmallColorLeft", left_outline_small_callback, false, options_button_template)
		local OutlineSmallColorTextLeft = g:NewLabel (frame5, _, "$parentOutlineSmallLabelLeft", "OutlineSmallColorLabelLeft", "Outline Color", "GameFontHighlightLeft")
		frame5.OutlineSmallColorLeft:SetPoint ("left", OutlineSmallColorTextLeft, "right", 2, 0)

		window:CreateLineBackground2 (frame5, "OutlineSmallColorLeft", "OutlineSmallColorLabelLeft", "Outline Color")

	--> left show positio number
		g:NewSwitch (frame5, _, "$parentPositionNumberSlider", "PositionNumberSlider", 60, 20, _, _, instance.row_info.textL_show_number, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentPositionNumberLabel", "PositionNumberLabel", Loc ["STRING_OPTIONS_TEXT_LPOSITION"], "GameFontHighlightLeft")
		
		frame5.PositionNumberSlider:SetPoint ("left", frame5.PositionNumberLabel, "right", 2)
		frame5.PositionNumberSlider:SetAsCheckBox()
		frame5.PositionNumberSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "PositionNumberSlider", "PositionNumberLabel", Loc ["STRING_OPTIONS_TEXT_LPOSITION_DESC"])
		
		--> left translit text by Vardex (https://github.com/Vardex May 22, 2019)
		g:NewSwitch (frame5, _, "$parentTranslitTextSlider", "TranslitTextSlider", 60, 20, _, _, instance.row_info.textL_translit_text, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentTranslitTextLabel", "TranslitTextLabel", Loc ["STRING_OPTIONS_TEXT_LTRANSLIT"], "GameFontHighlightLeft")

		frame5.TranslitTextSlider:SetPoint ("left", frame5.TranslitTextLabel, "right", 2)
		frame5.TranslitTextSlider:SetAsCheckBox()
		frame5.TranslitTextSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)

			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end

			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "TranslitTextSlider", "TranslitTextLabel", Loc ["STRING_OPTIONS_TEXT_LTRANSLIT_DESC"])



	--> right outline
		g:NewSwitch (frame5, _, "$parentTextRightOutlineSlider", "textRightOutlineSlider", 60, 20, _, _, instance.row_info.textR_outline, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentTextRightOutlineLabel", "textRightOutlineLabel", Loc ["STRING_OPTIONS_TEXT_LOUTILINE"], "GameFontHighlightLeft")
		
		frame5.textRightOutlineSlider:SetPoint ("left", frame5.textRightOutlineLabel, "right", 2)
		frame5.textRightOutlineSlider:SetAsCheckBox()
		frame5.textRightOutlineSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "textRightOutlineSlider", "textRightOutlineLabel", Loc ["STRING_OPTIONS_TEXT_ROUTILINE_DESC"])
	
	
	--> right outline small
		g:NewSwitch (frame5, _, "$parentTextRightOutlineSmallSlider", "textRightOutlineSmallSlider", 60, 20, _, _, instance.row_info.textR_outline_small, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentTextRightOutlineSmallLabel", "textRightOutlineSmallLabel", "Outline", "GameFontHighlightLeft")
		
		frame5.textRightOutlineSmallSlider:SetPoint ("left", frame5.textRightOutlineSmallLabel, "right", 2)
		frame5.textRightOutlineSmallSlider:SetAsCheckBox()
		frame5.textRightOutlineSmallSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
			--(13, smalloutline_Right, smalloutlinecolor_Right, smalloutline_right, smalloutlinecolor_right)
			--14 15 16 17
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "textRightOutlineSmallSlider", "textRightOutlineSmallLabel", "Text Outline")
		
	--> right outline small color
		local right_outline_small_callback = function (button, r, g, b, a)
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewColorPickButton (frame5, "$parentOutlineSmallColorRight", "OutlineSmallColorRight", right_outline_small_callback, false, options_button_template)
		local OutlineSmallColorTextRight = g:NewLabel (frame5, _, "$parentOutlineSmallLabelRight", "OutlineSmallColorLabelRight", "Outline Color", "GameFontHighlightRight")
		frame5.OutlineSmallColorRight:SetPoint ("left", OutlineSmallColorTextRight, "right", 2, 0)

		window:CreateLineBackground2 (frame5, "OutlineSmallColorRight", "OutlineSmallColorLabelRight", "Outline Color")	
	
	--> percent type
		local onSelectPercent = function (_, instance, percentType)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, percentType)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, percentType)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local buildPercentMenu = function() 
			local percentTable = {
				{value = 1, label = "Relative to Total", onclick = onSelectPercent, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]},
				{value = 2, label = "Relative to Top Player", onclick = onSelectPercent, icon = [[Interface\GROUPFRAME\UI-Group-LeaderIcon]]}
			}
			return percentTable 
		end
		
		local d = g:NewDropDown (frame5, _, "$parentPercentDropdown", "percentDropdown", DROPDOWN_WIDTH, dropdown_height, buildPercentMenu, nil, options_dropdown_template)
		
		g:NewLabel (frame5, _, "$parentPercentLabel", "percentLabel", Loc ["STRING_OPTIONS_PERCENT_TYPE"], "GameFontHighlightLeft")
		frame5.percentDropdown:SetPoint ("left", frame5.percentLabel, "right", 2)

		window:CreateLineBackground2 (frame5, "percentDropdown", "percentLabel", Loc ["STRING_OPTIONS_PERCENT_TYPE_DESC"])
	
	--> right text customization
	
		g:NewLabel (frame5, _, "$parentCutomRightTextLabel", "cutomRightTextLabel", Loc ["STRING_OPTIONS_BARRIGHTTEXTCUSTOM"], "GameFontHighlightLeft")
		g:NewSwitch (frame5, _, "$parentCutomRightTextSlider", "cutomRightTextSlider", 60, 20, _, _, instance.row_info.textR_enable_custom_text, nil, nil, nil, nil, options_switch_template)

		frame5.cutomRightTextSlider:SetPoint ("left", frame5.cutomRightTextLabel, "right", 2)
		frame5.cutomRightTextSlider:SetAsCheckBox()
		frame5.cutomRightTextSlider.OnSwitch = function (self, instance, value)
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "cutomRightTextSlider", "cutomRightTextLabel", Loc ["STRING_OPTIONS_BARRIGHTTEXTCUSTOM_DESC"])
		
		--text entry
		g:NewLabel (frame5, _, "$parentCutomRightText2Label", "cutomRightTextEntryLabel", Loc ["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2"], "GameFontHighlightLeft")
		g:NewTextEntry (frame5, _, "$parentCutomRightTextEntry", "cutomRightTextEntry", 180, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame5.cutomRightTextEntry:SetPoint ("left", frame5.cutomRightTextEntryLabel, "right", 2, -1)

		frame5.cutomRightTextEntry:SetHook ("OnTextChanged", function (self, byUser)
		
			if (not frame5.cutomRightTextEntry.text:find ("{func")) then
			
				if (frame5.cutomRightTextEntry.changing and not byUser) then
					frame5.cutomRightTextEntry.changing = false
					return
				elseif (frame5.cutomRightTextEntry.changing and byUser) then
					frame5.cutomRightTextEntry.changing = false
				end

				if (byUser) then
					local t = frame5.cutomRightTextEntry.text
					t = t:gsub ("||", "|")
					
					local instance = _G.DetailsOptionsWindow.instance
					instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, t)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, t)
							end
						end
					end
					
				else
					local t = frame5.cutomRightTextEntry.text
					t = t:gsub ("|", "||")
					frame5.cutomRightTextEntry.changing = true
					frame5.cutomRightTextEntry.text = t
				end
			end
		end)
		
		frame5.cutomRightTextEntry:SetHook ("OnChar", function()
			if (frame5.cutomRightTextEntry.text:find ("{func")) then
				GameCooltip:Reset()
				GameCooltip:AddLine ("'func' keyword found, auto update disabled.")
				GameCooltip:Show (frame5.cutomRightTextEntry.widget)
			end
		end)

		frame5.cutomRightTextEntry:SetHook ("OnEnterPressed", function()
			local t = frame5.cutomRightTextEntry.text
			t = t:gsub ("||", "|")
			
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, t)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, t)
					end
				end
			end
			
		end)
		frame5.cutomRightTextEntry:SetHook ("OnEscapePressed", function()
			frame5.cutomRightTextEntry:ClearFocus()
			return true
		end)

		window:CreateLineBackground2 (frame5, "cutomRightTextEntry", "cutomRightTextEntryLabel", Loc ["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2_DESC"])
		
		frame5.cutomRightTextEntry.text = instance.row_info.textR_custom_text
		
		local callback = function (text)
			frame5.cutomRightTextEntry.text = text
			frame5.cutomRightTextEntry:PressEnter()
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewButton (frame5.cutomRightTextEntry, _, "$parentOpenTextBarEditorButton", "TextBarEditorButton", 22, 22, function()
			DetailsWindowOptionsBarTextEditor:Open (frame5.cutomRightTextEntry.text, callback, _G.DetailsOptionsWindow, _detalhes.instance_defaults.row_info.textR_custom_text)
		end)
		frame5.TextBarEditorButton = frame5.cutomRightTextEntry.TextBarEditorButton
		frame5.TextBarEditorButton:SetPoint ("left", frame5.cutomRightTextEntry, "right", 2, 1)
		frame5.TextBarEditorButton:SetNormalTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:SetHighlightTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:SetPushedTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:GetNormalTexture():SetDesaturated (true)
		frame5.TextBarEditorButton.tooltip = Loc ["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"]
		
		g:NewButton (frame5.cutomRightTextEntry, _, "$parentResetCustomRightTextButton", "customRightTextButton", 20, 20, function()
			frame5.cutomRightTextEntry.text = _detalhes.instance_defaults.row_info.textR_custom_text
			frame5.cutomRightTextEntry:PressEnter()
		end)
		frame5.customRightTextButton = frame5.cutomRightTextEntry.customRightTextButton
		frame5.customRightTextButton:SetPoint ("left", frame5.TextBarEditorButton, "right", 0, 0)
		frame5.customRightTextButton:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		frame5.customRightTextButton:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		frame5.customRightTextButton:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		frame5.customRightTextButton:GetNormalTexture():SetDesaturated (true)
		frame5.customRightTextButton.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
	--> left text customization
	
		g:NewLabel (frame5, _, "$parentCutomLeftTextLabel", "cutomLeftTextLabel", Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM"], "GameFontHighlightLeft")
		g:NewSwitch (frame5, _, "$parentCutomLeftTextSlider", "cutomLeftTextSlider", 60, 20, _, _, instance.row_info.textL_enable_custom_text, nil, nil, nil, nil, options_switch_template)

		frame5.cutomLeftTextSlider:SetPoint ("left", frame5.cutomLeftTextLabel, "right", 2)
		frame5.cutomLeftTextSlider:SetAsCheckBox()
		frame5.cutomLeftTextSlider.OnSwitch = function (self, instance, value)
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "cutomLeftTextSlider", "cutomLeftTextLabel", Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"])
		
		--text entry
		g:NewLabel (frame5, _, "$parentCutomLeftText2Label", "cutomLeftTextEntryLabel", Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM2"], "GameFontHighlightLeft")
		g:NewTextEntry (frame5, _, "$parentCutomLeftTextEntry", "cutomLeftTextEntry", 180, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame5.cutomLeftTextEntry:SetPoint ("left", frame5.cutomLeftTextEntryLabel, "right", 2, -1)

		frame5.cutomLeftTextEntry:SetHook ("OnTextChanged", function (self, byUser)
		
			if (not frame5.cutomLeftTextEntry.text:find ("{func")) then
			
				if (frame5.cutomLeftTextEntry.changing and not byUser) then
					frame5.cutomLeftTextEntry.changing = false
					return
				elseif (frame5.cutomLeftTextEntry.changing and byUser) then
					frame5.cutomLeftTextEntry.changing = false
				end

				if (byUser) then
					local t = frame5.cutomLeftTextEntry.text
					t = t:gsub ("||", "|")
					
					local instance = _G.DetailsOptionsWindow.instance
					instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, t)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, t)
							end
						end
					end
					
				else
					local t = frame5.cutomLeftTextEntry.text
					t = t:gsub ("|", "||")
					frame5.cutomLeftTextEntry.changing = true
					frame5.cutomLeftTextEntry.text = t
				end
			end
		end)
		
		frame5.cutomLeftTextEntry:SetHook ("OnChar", function()
			if (frame5.cutomLeftTextEntry.text:find ("{func")) then
				GameCooltip:Reset()
				GameCooltip:AddLine ("'func' keyword found, auto update disabled.")
				GameCooltip:Show (frame5.cutomLeftTextEntry.widget)
			end
		end)

		frame5.cutomLeftTextEntry:SetHook ("OnEnterPressed", function()
			local t = frame5.cutomLeftTextEntry.text
			t = t:gsub ("||", "|")
			
			local instance = _G.DetailsOptionsWindow.instance
			instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, t)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarTextSettings (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, t)
					end
				end
			end

		end)
		frame5.cutomLeftTextEntry:SetHook ("OnEscapePressed", function()
			frame5.cutomLeftTextEntry:ClearFocus()
			return true
		end)

		window:CreateLineBackground2 (frame5, "cutomLeftTextEntry", "cutomLeftTextEntryLabel", Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM2_DESC"])
		
		frame5.cutomLeftTextEntry.text = instance.row_info.textL_custom_text
		
		local callback = function (text)
			frame5.cutomLeftTextEntry.text = text
			frame5.cutomLeftTextEntry:PressEnter()
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		g:NewButton (frame5.cutomLeftTextEntry, _, "$parentOpenTextBarEditorButton", "TextBarEditorButton", 22, 22, function()
			DetailsWindowOptionsBarTextEditor:Open (frame5.cutomLeftTextEntry.text, callback, _G.DetailsOptionsWindow, _detalhes.instance_defaults.row_info.textL_custom_text)
		end)
		frame5.TextBarEditorButton = frame5.cutomLeftTextEntry.TextBarEditorButton
		frame5.TextBarEditorButton:SetPoint ("left", frame5.cutomLeftTextEntry, "right", 2, 1)
		frame5.TextBarEditorButton:SetNormalTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:SetHighlightTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:SetPushedTexture ([[Interface\HELPFRAME\OpenTicketIcon]])
		frame5.TextBarEditorButton:GetNormalTexture():SetDesaturated (true)
		frame5.TextBarEditorButton.tooltip = Loc ["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"]
		
		g:NewButton (frame5.cutomLeftTextEntry, _, "$parentResetCustomLeftTextButton", "customLeftTextButton", 20, 20, function()
			frame5.cutomLeftTextEntry.text = _detalhes.instance_defaults.row_info.textL_custom_text
			frame5.cutomLeftTextEntry:PressEnter()
		end)
		frame5.customLeftTextButton = frame5.cutomLeftTextEntry.customLeftTextButton
		frame5.customLeftTextButton:SetPoint ("left", frame5.TextBarEditorButton, "right", 0, 0)
		frame5.customLeftTextButton:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		frame5.customLeftTextButton:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		frame5.customLeftTextButton:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		frame5.customLeftTextButton:GetNormalTexture():SetDesaturated (true)
		frame5.customLeftTextButton.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
	--> total dps percent bracket separator
	
		-- total
		g:NewSwitch (frame5, _, "$parentRightTextShowTotalSlider", "RightTextShowTotalSlider", 60, 20, _, _, instance.row_info.textR_show_data [1], nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentRightTextShowTotalLabel", "RightTextShowTotalLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_TOTAL"], "GameFontHighlightLeft")
		
		frame5.RightTextShowTotalSlider:SetPoint ("left", frame5.RightTextShowTotalLabel, "right", 2)
		frame5.RightTextShowTotalSlider:SetAsCheckBox()
		frame5.RightTextShowTotalSlider.OnSwitch = function (self, instance, value)
			instance:SetBarRightTextSettings (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarRightTextSettings (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame5, "RightTextShowTotalSlider", "RightTextShowTotalLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_TOTAL_DESC"])
		
		-- ps
		g:NewSwitch (frame5, _, "$parentRightTextShowPSSlider", "RightTextShowPSSlider", 60, 20, _, _, instance.row_info.textR_show_data [2], nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentRightTextShowPSLabel", "RightTextShowPSLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_PS"], "GameFontHighlightLeft")
		
		frame5.RightTextShowPSSlider:SetPoint ("left", frame5.RightTextShowPSLabel, "right", 2)
		frame5.RightTextShowPSSlider:SetAsCheckBox()
		frame5.RightTextShowPSSlider.OnSwitch = function (self, instance, value)
			instance:SetBarRightTextSettings (nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarRightTextSettings (nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "RightTextShowPSSlider", "RightTextShowPSLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_PS_DESC"])
		
		-- percent
		g:NewSwitch (frame5, _, "$parentRightTextShowPercentSlider", "RightTextShowPercentSlider", 60, 20, _, _, instance.row_info.textR_show_data [3], nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame5, _, "$parentRightTextShowPercentLabel", "RightTextShowPercentLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_PERCENT"], "GameFontHighlightLeft")
		
		frame5.RightTextShowPercentSlider:SetPoint ("left", frame5.RightTextShowPercentLabel, "right", 2)
		frame5.RightTextShowPercentSlider:SetAsCheckBox()
		frame5.RightTextShowPercentSlider.OnSwitch = function (self, instance, value)
			instance:SetBarRightTextSettings (nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarRightTextSettings (nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame5, "RightTextShowPercentSlider", "RightTextShowPercentLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_PERCENT_DESC"])
		
		--brackets
		local onSelectBracket = function (_, instance, value)
			instance:SetBarRightTextSettings (nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarRightTextSettings (nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local BracketTable = {
			{value = "(", label = "(", onclick = onSelectBracket, icon = ""},
			{value = "{", label = "{", onclick = onSelectBracket, icon = ""},
			{value = "[", label = "[", onclick = onSelectBracket, icon = ""},
			{value = "<", label = "<", onclick = onSelectBracket, icon = ""},
			{value = "NONE", label = "no bracket", onclick = onSelectBracket, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]},
		}
		local buildBracketMenu = function() 
			return BracketTable 
		end
		
		local d = g:NewDropDown (frame5, _, "$parentBracketDropdown", "BracketDropdown", 60, dropdown_height, buildBracketMenu, nil, options_dropdown_template)
		
		g:NewLabel (frame5, _, "$parentBracketLabel", "BracketLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_BRACKET"], "GameFontHighlightLeft")
		frame5.BracketDropdown:SetPoint ("left", frame5.BracketLabel, "right", 2)

		window:CreateLineBackground2 (frame5, "BracketDropdown", "BracketLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_BRACKET_DESC"])
		
		--separators
		local onSelectSeparator = function (_, instance, value)
			instance:SetBarRightTextSettings (nil, nil, nil, nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBarRightTextSettings (nil, nil, nil, nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local SeparatorTable = {
			{value = ",", label = ",", onclick = onSelectSeparator, icon = ""},
			{value = ".", label = ".", onclick = onSelectSeparator, icon = ""},
			{value = ";", label = ";", onclick = onSelectSeparator, icon = ""},
			{value = "-", label = "-", onclick = onSelectSeparator, icon = ""},
			{value = "|", label = "|", onclick = onSelectSeparator, icon = ""},
			{value = "/", label = "/", onclick = onSelectSeparator, icon = ""},
			{value = "\\", label = "\\", onclick = onSelectSeparator, icon = ""},
			{value = "~", label = "~", onclick = onSelectSeparator, icon = ""},
			{value = "NONE", label = "no separator", onclick = onSelectSeparator, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]},
		}
		local buildSeparatorMenu = function() 
			return SeparatorTable 
		end
		
		local d = g:NewDropDown (frame5, _, "$parentSeparatorDropdown", "SeparatorDropdown", 60, dropdown_height, buildSeparatorMenu, nil, options_dropdown_template)
		
		
		g:NewLabel (frame5, _, "$parentSeparatorLabel", "SeparatorLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_SEPARATOR"], "GameFontHighlightLeft")
		frame5.SeparatorDropdown:SetPoint ("left", frame5.SeparatorLabel, "right", 2)
		
		window:CreateLineBackground2 (frame5, "SeparatorDropdown", "SeparatorLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_SEPARATOR_DESC"])
		
	--> anchors
		
		--general anchor
		g:NewLabel (frame5, _, "$parentRowTextGeneralAnchor", "RowGeneralAnchorLabel", Loc ["STRING_OPTIONS_GENERAL_ANCHOR"], "GameFontNormal")
		
		--left text anchor
		g:NewLabel (frame5, _, "$parentLeftTextAnchor", "LeftTextAnchorLabel", Loc ["STRING_OPTIONS_TEXT_LEFT_ANCHOR"], "GameFontNormal")
		--right text anchor
		g:NewLabel (frame5, _, "$parentRightTextAnchor", "RightTextAnchorLabel", Loc ["STRING_OPTIONS_TEXT_RIGHT_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_texts:SetPoint (x, window.title_y_pos)
		titulo_texts_desc:SetPoint (x, window.title_y_pos2)

		local left_side = {
			{"RowGeneralAnchorLabel", 7, true},
			{frame5.fonsizeLabel, 8}, --text size
			{frame5.fontLabel, 9},--text fontface
			{frame5.fixedTextColorLabel, 10},
			{frame5.percentLabel, 11, true},
			
			{"LeftTextAnchorLabel", 1, true},
			{"textLeftOutlineLabel", 2},
			{"textLeftOutlineSmallLabel", 2},
			{"OutlineSmallColorLabelLeft", 2},
			{"classColorsLeftTextLabel", 3},
			{"PositionNumberLabel", 4},
			{"TranslitTextLabel", 5},
			{"cutomLeftTextLabel", 5, true},
			{"cutomLeftTextEntryLabel", 6},
		}
		
		window:arrange_menu (frame5, left_side, x, window.top_start_at)
		
		local right_side = {
			{"RightTextAnchorLabel", 1, true},
			{"textRightOutlineLabel", 2},
			{"textRightOutlineSmallLabel", 2},
			{"OutlineSmallColorLabelRight", 2},
			
			{"classColorsRightTextLabel", 3},
			
			{"RightTextShowTotalLabel", 4, true},
			{"RightTextShowPSLabel", 5},
			{"RightTextShowPercentLabel", 6},
			{"SeparatorLabel", 7, true},
			{"BracketLabel", 8},
			
			{"cutomRightTextLabel", 9, true},
			{"cutomRightTextEntryLabel", 10},
		}
	
		window:arrange_menu (frame5, right_side, window.right_start_at, window.top_start_at)
	

		

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Window Settings ~6
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function window:CreateFrame6()

	local frame6 = window.options [6][1]

	--> window
		local titulo_instance = g:NewLabel (frame6, _, "$parentTituloPersona", "tituloBarsLabel", Loc ["STRING_OPTIONS_WINDOW_TITLE"], "GameFontNormal", 16)
		local titulo_instance_desc = g:NewLabel (frame6, _, "$parentTituloPersona2", "tituloBars2Label", Loc ["STRING_OPTIONS_WINDOW_TITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_instance_desc.width = 320

	--> window color
		local windowcolor_callback = function (button, r, g, b, a)
		
			local instance = _G.DetailsOptionsWindow.instance
		
			if (instance.menu_alpha.enabled and a ~= instance.color[4]) then
				_detalhes:Msg (Loc ["STRING_OPTIONS_MENU_ALPHAWARNING"])
				_G.DetailsOptionsWindow6StatusbarColorPick.MyObject:SetColor (r, g, b, instance.menu_alpha.onleave)
				instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
						end
					end
				end
				
				return
			end
			
			_G.DetailsOptionsWindow6StatusbarColorPick.MyObject:SetColor (r, g, b, a)
			instance:InstanceColor (r, g, b, a, nil, true)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:InstanceColor (r, g, b, a, nil, true)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (instance)
		end
		g:NewColorPickButton (frame6, "$parentWindowColorPick", "windowColorPick", windowcolor_callback, nil, options_button_template)
		g:NewLabel (frame6, _, "$parentWindowColorPickLabel", "windowPickColorLabel", Loc ["STRING_OPTIONS_INSTANCE_COLOR"], "GameFontHighlightLeft")
		frame6.windowColorPick:SetPoint ("left", frame6.windowPickColorLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame6, "windowColorPick", "windowPickColorLabel", Loc ["STRING_OPTIONS_INSTANCE_COLOR_DESC"])
		
	--> background color
		local windowbackgroundcolor_callback = function (button, r, g, b, a)
			local instance = _G.DetailsOptionsWindow.instance
		
			instance:SetBackgroundColor (r, g, b)
			instance:SetBackgroundAlpha (a)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBackgroundColor (r, g, b)
						this_instance:SetBackgroundAlpha (a)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (instance)
		end
		
		g:NewColorPickButton (frame6, "$parentWindowBackgroundColorPick", "windowBackgroundColorPick", windowbackgroundcolor_callback, nil, options_button_template)
		g:NewLabel (frame6, _, "$parentWindowBackgroundColorPickLabel", "windowBackgroundPickColorLabel", Loc ["STRING_OPTIONS_INSTANCE_ALPHA2"], "GameFontHighlightLeft")
		frame6.windowBackgroundColorPick:SetPoint ("left", frame6.windowBackgroundPickColorLabel, "right", 2, 0)

		window:CreateLineBackground2 (frame6, "windowBackgroundColorPick", "windowBackgroundPickColorLabel", Loc ["STRING_OPTIONS_INSTANCE_ALPHA2_DESC"])
	
	--> stretch button anchor

			local grow_switch_func = function (slider, value)
				if (value == 1) then
					return true
				elseif (value == 2) then
					return false
				end
			end
			local grow_return_func = function (slider, value)
				if (value) then
					return 1
				else
					return 2
				end
			end		
		
			g:NewSwitch (frame6, _, "$parentStretchAnchorSlider", "stretchAnchorSlider", 80, 20, Loc ["STRING_BOTTOM"], Loc ["STRING_TOP"], instance.toolbar_side, nil, grow_switch_func, grow_return_func, nil, options_switch_template)
			g:NewLabel (frame6, _, "$parentStretchAnchorLabel", "stretchAnchorLabel", Loc ["STRING_OPTIONS_STRETCH"], "GameFontHighlightLeft")

			frame6.stretchAnchorSlider:SetPoint ("left", frame6.stretchAnchorLabel, "right", 2)
			frame6.stretchAnchorSlider:SetAsCheckBox()
			frame6.stretchAnchorSlider.OnSwitch = function (self, instance, value)
				instance:StretchButtonAnchor (value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:StretchButtonAnchor (value)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			frame6.stretchAnchorSlider.thumb:SetSize (40, 12)
			
			window:CreateLineBackground2 (frame6, "stretchAnchorSlider", "stretchAnchorLabel", Loc ["STRING_OPTIONS_STRETCH_DESC"])

	--> stretch button always on top
			g:NewSwitch (frame6, _, "$parentStretchAlwaysOnTopSlider", "stretchAlwaysOnTopSlider", 60, 20, _, _, instance.grab_on_top, nil, nil, nil, nil, options_switch_template)
			g:NewLabel (frame6, _, "$parentStretchAlwaysOnTopLabel", "stretchAlwaysOnTopLabel", Loc ["STRING_OPTIONS_STRETCHTOP"], "GameFontHighlightLeft")
			
			frame6.stretchAlwaysOnTopSlider:SetPoint ("left", frame6.stretchAlwaysOnTopLabel, "right", 2, 0)
			frame6.stretchAlwaysOnTopSlider:SetAsCheckBox()
		
			frame6.stretchAlwaysOnTopSlider.OnSwitch = function (self, instance, value)
				instance:StretchButtonAlwaysOnTop (value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:StretchButtonAlwaysOnTop (value)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame6, "stretchAlwaysOnTopSlider", "stretchAlwaysOnTopLabel", Loc ["STRING_OPTIONS_STRETCHTOP_DESC"])

	--> instance toolbar side
			g:NewSwitch (frame6, _, "$parentInstanceToolbarSideSlider", "instanceToolbarSideSlider", 80, 20, Loc ["STRING_BOTTOM"], Loc ["STRING_TOP"], instance.toolbar_side, nil, grow_switch_func, grow_return_func, nil, options_switch_template)
			g:NewLabel (frame6, _, "$parentInstanceToolbarSideLabel", "instanceToolbarSideLabel", Loc ["STRING_OPTIONS_TOOLBARSIDE"], "GameFontHighlightLeft")
			
			frame6.instanceToolbarSideSlider:SetPoint ("left", frame6.instanceToolbarSideLabel, "right", 2)
			frame6.instanceToolbarSideSlider:SetAsCheckBox()
			frame6.instanceToolbarSideSlider.OnSwitch = function (self, instance, value)
				instance:ToolbarSide (value)
				
				local group_editing = _detalhes.options_group_edit
				_detalhes.options_group_edit = nil
					_G.DetailsOptionsWindow7:update_menuanchor_xy (instance)
				_detalhes.options_group_edit = group_editing
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:ToolbarSide (value)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			frame6.instanceToolbarSideSlider.thumb:SetSize (50, 12)
			
			window:CreateLineBackground2 (frame6, "instanceToolbarSideSlider", "instanceToolbarSideLabel", Loc ["STRING_OPTIONS_TOOLBARSIDE_DESC"])
			
	--> micro displays side
			g:NewSwitch (frame6, _, "$parentInstanceMicroDisplaysSideSlider", "instanceMicroDisplaysSideSlider", 80, 20, Loc ["STRING_BOTTOM"], Loc ["STRING_TOP"], instance.toolbar_side, nil, grow_switch_func, grow_return_func, nil, options_switch_template)
			g:NewLabel (frame6, _, "$parentInstanceMicroDisplaysSideLabel", "instanceMicroDisplaysSideLabel", Loc ["STRING_OPTIONS_MICRODISPLAYSSIDE"], "GameFontHighlightLeft")
			
			frame6.instanceMicroDisplaysSideSlider:SetPoint ("left", frame6.instanceMicroDisplaysSideLabel, "right", 2)
			frame6.instanceMicroDisplaysSideSlider:SetAsCheckBox()
			frame6.instanceMicroDisplaysSideSlider.OnSwitch = function (self, instance, value)
				instance:MicroDisplaysSide (value, true)
				window:update_microframes()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:MicroDisplaysSide (value, true)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			frame6.instanceMicroDisplaysSideSlider.thumb:SetSize (50, 12)
			
			window:CreateLineBackground2 (frame6, "instanceMicroDisplaysSideSlider", "instanceMicroDisplaysSideLabel", Loc ["STRING_OPTIONS_MICRODISPLAYSSIDE_DESC"])
	
	--> micro displays selection
			g:NewLabel (frame6, _, "$parentMicroDisplaysAnchor", "MicroDisplaysAnchor", Loc ["STRING_OPTIONS_MICRODISPLAY_ANCHOR"], "GameFontNormal")
			
			g:NewLabel (frame6, _, "$parentMicroDisplayLeftLabel", "MicroDisplayLeftLabel", Loc ["STRING_ANCHOR_LEFT"], "GameFontHighlightLeft")
			g:NewLabel (frame6, _, "$parentMicroDisplayCenterLabel", "MicroDisplayCenterLabel", Loc ["STRING_CENTER_UPPER"], "GameFontHighlightLeft")
			g:NewLabel (frame6, _, "$parentMicroDisplayRightLabel", "MicroDisplayRightLabel", Loc ["STRING_ANCHOR_RIGHT"], "GameFontHighlightLeft")
			
			g:NewLabel (frame6, _, "$parentMicroDisplayWarningLabel", "MicroDisplayWarningLabel", Loc ["STRING_OPTIONS_MICRODISPLAYS_WARNING"], "GameFontHighlightSmall", 10, "orange")

			local OnMicroDisplaySelect = function (_, instance, micro_display)
				local anchor, index = unpack (micro_display)
				
				if (index == -1) then
					return _detalhes.StatusBar:SetPlugin (instance, -1, anchor)
				end
				
				local absolute_name = _detalhes.StatusBar.Plugins [index].real_name
				_detalhes.StatusBar:SetPlugin (instance, absolute_name, anchor)
				
				window:update_microframes()
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local BuildLeftMicroMenu = function() 
				local options = {}
				--options [1] = {value = {"left", -1}, label = Loc ["STRING_PLUGIN_CLEAN"], onclick = OnMicroDisplaySelect, icon = [[Interface\Buttons\UI-GroupLoot-Pass-Down]]}
				for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
					options [#options+1] = {value = {"left", index}, label = _name_and_icon [1], onclick = OnMicroDisplaySelect, icon = _name_and_icon [2]}
				end
				return options
			end
			local BuildCenterMicroMenu = function() 
				local options = {}
				--options [1] = {value = {"center", -1}, label = Loc ["STRING_PLUGIN_CLEAN"], onclick = OnMicroDisplaySelect, icon = [[Interface\Buttons\UI-GroupLoot-Pass-Down]]}
				for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
					options [#options+1] = {value = {"center", index}, label = _name_and_icon [1], onclick = OnMicroDisplaySelect, icon = _name_and_icon [2]}
				end
				return options
			end
			local BuildRightMicroMenu = function() 
				local options = {}
				--options [1] = {value = {"right", -1}, label = Loc ["STRING_PLUGIN_CLEAN"], onclick = OnMicroDisplaySelect, icon = [[Interface\Buttons\UI-GroupLoot-Pass-Down]]}
				for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
					options [#options+1] = {value = {"right", index}, label = _name_and_icon [1], onclick = OnMicroDisplaySelect, icon = _name_and_icon [2]}
				end
				return options
			end
			
			local d = g:NewDropDown (frame6, _, "$parentMicroDisplayLeftDropdown", "MicroDisplayLeftDropdown", DROPDOWN_WIDTH, dropdown_height, BuildLeftMicroMenu, nil, options_dropdown_template)	

			
			local d = g:NewDropDown (frame6, _, "$parentMicroDisplayCenterDropdown", "MicroDisplayCenterDropdown", DROPDOWN_WIDTH, dropdown_height, BuildCenterMicroMenu, nil, options_dropdown_template)	

			
			local d = g:NewDropDown (frame6, _, "$parentMicroDisplayRightDropdown", "MicroDisplayRightDropdown", DROPDOWN_WIDTH, dropdown_height, BuildRightMicroMenu, nil, options_dropdown_template)	

			
			frame6.MicroDisplayLeftDropdown:SetPoint ("left", frame6.MicroDisplayLeftLabel, "right", 2)
			frame6.MicroDisplayCenterDropdown:SetPoint ("left", frame6.MicroDisplayCenterLabel, "right", 2)
			frame6.MicroDisplayRightDropdown:SetPoint ("left", frame6.MicroDisplayRightLabel, "right", 2)
			
			window:CreateLineBackground2 (frame6, "MicroDisplayLeftDropdown", "MicroDisplayLeftLabel", Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"])
			window:CreateLineBackground2 (frame6, "MicroDisplayCenterDropdown", "MicroDisplayCenterLabel", Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"])
			window:CreateLineBackground2 (frame6, "MicroDisplayRightDropdown", "MicroDisplayRightLabel", Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"])
			
			local HideLeftMicroFrameButton = g:NewButton (frame6.MicroDisplayLeftDropdown, _, "$parentHideLeftMicroFrameButton", "HideLeftMicroFrameButton", 22, 22, function (self, button)
				if (_G.DetailsOptionsWindow.instance.StatusBar ["left"].options.isHidden) then
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, _G.DetailsOptionsWindow.instance.StatusBar ["left"].real_name, "left")
				else
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, -1, "left")
				end
				if (_G.DetailsOptionsWindow.instance.StatusBar ["left"].options.isHidden) then
					self:GetNormalTexture():SetDesaturated (false)
				else
					self:GetNormalTexture():SetDesaturated (true)
				end
			end)
			HideLeftMicroFrameButton:SetPoint ("left", frame6.MicroDisplayLeftDropdown, "right", 2, 0)
			HideLeftMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
			--HideLeftMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
			HideLeftMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
			HideLeftMicroFrameButton:GetNormalTexture():SetDesaturated (true)
			HideLeftMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
			HideLeftMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("ADD")
			end)
			HideLeftMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("BLEND")
			end)
		
			local HideCenterMicroFrameButton = g:NewButton (frame6.MicroDisplayCenterDropdown, _, "$parentHideCenterMicroFrameButton", "HideCenterMicroFrameButton", 22, 22, function (self)
				if (_G.DetailsOptionsWindow.instance.StatusBar ["center"].options.isHidden) then
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, _G.DetailsOptionsWindow.instance.StatusBar ["center"].real_name, "center")
				else
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, -1, "center")
				end
				
				if (_G.DetailsOptionsWindow.instance.StatusBar ["center"].options.isHidden) then
					self:GetNormalTexture():SetDesaturated (false)
				else
					self:GetNormalTexture():SetDesaturated (true)
				end
			end)
			HideCenterMicroFrameButton:SetPoint ("left", frame6.MicroDisplayCenterDropdown, "right", 2, 0)
			HideCenterMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
			--HideCenterMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
			HideCenterMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
			HideCenterMicroFrameButton:GetNormalTexture():SetDesaturated (true)
			HideCenterMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
			HideCenterMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("ADD")
			end)
			HideCenterMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("BLEND")
			end)
			
			local HideRightMicroFrameButton = g:NewButton (frame6.MicroDisplayRightDropdown, _, "$parentHideRightMicroFrameButton", "HideRightMicroFrameButton", 20, 20, function (self)
				if (_G.DetailsOptionsWindow.instance.StatusBar ["right"].options.isHidden) then
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, _G.DetailsOptionsWindow.instance.StatusBar ["right"].real_name, "right")
				else
					_detalhes.StatusBar:SetPlugin (_G.DetailsOptionsWindow.instance, -1, "right")
				end
				if (_G.DetailsOptionsWindow.instance.StatusBar ["right"].options.isHidden) then
					self:GetNormalTexture():SetDesaturated (false)
				else
					self:GetNormalTexture():SetDesaturated (true)
				end
			end)
			HideRightMicroFrameButton:SetPoint ("left", frame6.MicroDisplayRightDropdown, "right", 2, 0)
			HideRightMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
			--HideRightMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
			HideRightMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
			HideRightMicroFrameButton:GetNormalTexture():SetDesaturated (true)
			HideRightMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
			HideRightMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("ADD")
			end)
			HideRightMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
				self:GetNormalTexture():SetBlendMode("BLEND")
			end)
			
			-------------
			
			local ConfigRightMicroFrameButton = g:NewButton (frame6.MicroDisplayRightDropdown, _, "$parentConfigRightMicroFrameButton", "ConfigRightMicroFrameButton", 18, 18, function (self)
				_G.DetailsOptionsWindow.instance.StatusBar ["right"]:Setup()
				_G.DetailsOptionsWindow.instance.StatusBar ["right"]:Setup()
			end)
			ConfigRightMicroFrameButton:SetPoint ("left", HideRightMicroFrameButton, "right", 1, -1)
			ConfigRightMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigRightMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigRightMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]
			
			local ConfigCenterMicroFrameButton = g:NewButton (frame6.MicroDisplayCenterDropdown, _, "$parentConfigCenterMicroFrameButton", "ConfigCenterMicroFrameButton", 18, 18, function (self)
				_G.DetailsOptionsWindow.instance.StatusBar ["center"]:Setup()
				_G.DetailsOptionsWindow.instance.StatusBar ["center"]:Setup()
			end)
			ConfigCenterMicroFrameButton:SetPoint ("left", HideCenterMicroFrameButton, "right", 1, -1)
			ConfigCenterMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigCenterMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigCenterMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]
			
			local ConfigLeftMicroFrameButton = g:NewButton (frame6.MicroDisplayLeftDropdown, _, "$parentConfigLeftMicroFrameButton", "ConfigLeftMicroFrameButton", 18, 18, function (self)
				_G.DetailsOptionsWindow.instance.StatusBar ["left"]:Setup()
				_G.DetailsOptionsWindow.instance.StatusBar ["left"]:Setup()
			end)
			ConfigLeftMicroFrameButton:SetPoint ("left", HideLeftMicroFrameButton, "right", 1, -1)
			ConfigLeftMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigLeftMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
			ConfigLeftMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]
			
	--> lock mini displays
		g:NewSwitch (frame6, _, "$parentLockMiniDisplaysSlider", "LockMiniDisplaysSlider", 60, 20, _, _, instance.micro_displays_locked, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame6, _, "$parentLockMiniDisplaysLabel", "LockMiniDisplaysLabel", Loc ["STRING_OPTIONS_MICRODISPLAY_LOCK"], "GameFontHighlightLeft")

		frame6.LockMiniDisplaysSlider:SetPoint ("left", frame6.LockMiniDisplaysLabel, "right", 2)
		frame6.LockMiniDisplaysSlider:SetAsCheckBox()
		frame6.LockMiniDisplaysSlider.OnSwitch = function (self, instance, value)

			instance:MicroDisplaysLock (value)
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:MicroDisplaysLock (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "LockMiniDisplaysSlider", "LockMiniDisplaysLabel", Loc ["STRING_OPTIONS_MICRODISPLAY_LOCK_DESC"])
	
	--> sidebars
		g:NewSwitch (frame6, _, "$parentSideBarsSlider", "sideBarsSlider", 60, 20, _, _, instance.show_sidebars, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame6, _, "$parentSideBarsLabel", "sideBarsLabel", Loc ["STRING_OPTIONS_SHOW_SIDEBARS"], "GameFontHighlightLeft")

		frame6.sideBarsSlider:SetPoint ("left", frame6.sideBarsLabel, "right", 2)
		frame6.sideBarsSlider:SetAsCheckBox()
		frame6.sideBarsSlider.OnSwitch = function (self, instance, value)
			if (value) then
				instance:ShowSideBars()
			else
				instance:HideSideBars()
			end
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						if (value) then
							this_instance:ShowSideBars()
						else
							this_instance:HideSideBars()
						end
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "sideBarsSlider", "sideBarsLabel", Loc ["STRING_OPTIONS_SHOW_SIDEBARS_DESC"])
		
	--> show statusbar
		
		g:NewSwitch (frame6, _, "$parentStatusbarSlider", "statusbarSlider", 60, 20, _, _, instance.show_statusbar, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame6, _, "$parentStatusbarLabel", "statusbarLabel", Loc ["STRING_OPTIONS_SHOW_STATUSBAR"], "GameFontHighlightLeft")

		frame6.statusbarSlider:SetPoint ("left", frame6.statusbarLabel, "right", 2)
		frame6.statusbarSlider:SetAsCheckBox()
		frame6.statusbarSlider.OnSwitch = function (self, instance, value)
			if (value) then
				instance:ShowStatusBar()
			else
				instance:HideStatusBar()
			end
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						if (value) then
							this_instance:ShowStatusBar()
						else
							this_instance:HideStatusBar()
						end
					end
				end
			end
			
			instance:BaseFrameSnap()
			window:update_microframes()
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end

		window:CreateLineBackground2 (frame6, "statusbarSlider", "statusbarLabel", Loc ["STRING_OPTIONS_SHOW_STATUSBAR_DESC"])
		
	--> backdrop texture
		local onBackdropSelect = function (_, instance, backdropName)
		
			instance:SetBackdropTexture (backdropName)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetBackdropTexture (backdropName)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			
		end

		local backdrop_icon_size = {16, 16}
		local backdrop_icon_color = {.6, .6, .6}
		
		local buildBackdropMenu = function()
			local backdropTable = {}
			for name, backdropPath in pairs (SharedMedia:HashTable ("background")) do 
				backdropTable[#backdropTable+1] = {value = name, label = name, onclick = onBackdropSelect, icon = [[Interface\ITEMSOCKETINGFRAME\UI-EMPTYSOCKET]], iconsize = backdrop_icon_size, iconcolor = backdrop_icon_color}
			end
			return backdropTable 
		end
		
		local d = g:NewDropDown (frame6, _, "$parentBackdropDropdown", "backdropDropdown", DROPDOWN_WIDTH, dropdown_height, buildBackdropMenu, nil, options_dropdown_template)		

		
		g:NewLabel (frame6, _, "$parentBackdropLabel", "backdropLabel", Loc ["STRING_OPTIONS_INSTANCE_BACKDROP"], "GameFontHighlightLeft")
		frame6.backdropDropdown:SetPoint ("left", frame6.backdropLabel, "right", 2)
		
		window:CreateLineBackground2 (frame6, "backdropDropdown", "backdropLabel", Loc ["STRING_OPTIONS_INSTANCE_BACKDROP_DESC"])
		
	--> frame strata
			local onStrataSelect = function (_, instance, strataName)
				instance:SetFrameStrata (strataName)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:SetFrameStrata (strataName)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			local strataTable = {
				{value = "BACKGROUND", label = "Background", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Green]], iconcolor = {0, .5, 0, .8}, texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
				{value = "LOW", label = "Low", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Green]] , texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
				{value = "MEDIUM", label = "Medium", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Yellow]] , texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
				{value = "HIGH", label = "High", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Yellow]] , iconcolor = {1, .7, 0, 1}, texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
				{value = "DIALOG", label = "Dialog", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Red]] , iconcolor = {1, 0, 0, 1},  texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
			}
			local buildStrataMenu = function() return strataTable end
			
			local d = g:NewDropDown (frame6, _, "$parentStrataDropdown", "strataDropdown", DROPDOWN_WIDTH, dropdown_height, buildStrataMenu, nil, options_dropdown_template)		

			
			g:NewLabel (frame6, _, "$parentStrataLabel", "strataLabel", Loc ["STRING_OPTIONS_INSTANCE_STRATA"], "GameFontHighlightLeft")
			frame6.strataDropdown:SetPoint ("left", frame6.strataLabel, "right", 2)
			
			window:CreateLineBackground2 (frame6, "strataDropdown", "strataLabel", Loc ["STRING_OPTIONS_INSTANCE_STRATA_DESC"])

	--> statusbar color overwrite
			g:NewLabel (frame6, _, "$parentStatusbarLabelAnchor", "statusbarAnchorLabel", Loc ["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"], "GameFontNormal")
		
			local statusbar_color_callback = function (button, r, g, b, a)
				local instance = _G.DetailsOptionsWindow.instance
				instance:StatusBarColor (r, g, b, a)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:StatusBarColor (r, g, b, a)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewColorPickButton (frame6, "$parentStatusbarColorPick", "statusbarColorPick", statusbar_color_callback, nil, options_button_template)
			g:NewLabel (frame6, _, "$parentStatusbarColorLabel", "statusbarColorLabel", Loc ["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR"], "GameFontHighlightLeft")
			frame6.statusbarColorPick:SetPoint ("left", frame6.statusbarColorLabel, "right", 2, 0)
			window:CreateLineBackground2 (frame6, "statusbarColorPick", "statusbarColorLabel", Loc ["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR_DESC"])
			
		
	--> window scale
			local s = g:NewSlider (frame6, _, "$parentWindowScaleSlider", "WindowScaleSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0.65, 1.5, 0.02, instance.window_scale, true, nil, nil, options_slider_template)
			--config_slider (s)
			s.fine_tuning = 0.011
			s:SetThumbSize (25)
			
			frame6.WindowScaleSlider:SetHook ("OnValueChange", function (self, instance, amount) 
				instance:SetWindowScale (amount, true)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			
			g:NewLabel (frame6, _, "$parentWindowScaleLabel", "WindowScaleLabel", Loc ["STRING_OPTIONS_WINDOW_SCALE"], "GameFontHighlightLeft")
			frame6.WindowScaleSlider:SetPoint ("left", frame6.WindowScaleLabel, "right", 2)
			
			window:CreateLineBackground2 (frame6, "WindowScaleSlider", "WindowScaleLabel", Loc ["STRING_OPTIONS_WINDOW_SCALE_DESC"])
			
			frame6.WindowScaleSlider:SetHook ("OnEnter", function()
				GameCooltip:Preset (2)
				GameCooltip:AddLine (string.format (Loc ["STRING_OPTIONS_WINDOW_SCALE_DESC"], _G.DetailsOptionsWindow.instance.window_scale))
				GameCooltip:ShowCooltip (frame6.WindowScaleSlider.widget, "tooltip")
				return true
			end)

	--> ignore mass show hide
		g:NewSwitch (frame6, _, "$parentIgnoreMassShowHideSlider", "IgnoreMassShowHideSlider", 60, 20, _, _, instance.ignore_mass_showhide, nil, nil, nil, nil, options_switch_template)
		g:NewLabel (frame6, _, "$parentIgnoreMassShowHideLabel", "IgnoreMassShowHideLabel", Loc ["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE"], "GameFontHighlightLeft")

		frame6.IgnoreMassShowHideSlider:SetPoint ("left", frame6.IgnoreMassShowHideLabel, "right", 2)
		frame6.IgnoreMassShowHideSlider:SetAsCheckBox()
		frame6.IgnoreMassShowHideSlider.OnSwitch = function (self, instance, value)

			instance.ignore_mass_showhide = value
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance.ignore_mass_showhide = value
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "IgnoreMassShowHideSlider", "IgnoreMassShowHideLabel", Loc ["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE_DESC"])			

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		--> disable groups
		g:NewLabel (frame6, _, "$parentDisableGroupsLabel", "DisableGroupsLabel", Loc ["STRING_OPTIONS_DISABLE_GROUPS"], "GameFontHighlightLeft")
		g:NewSwitch (frame6, _, "$parentDisableGroupsSlider", "DisableGroupsSlider", 60, 20, _, _, _detalhes.disable_window_groups, nil, nil, nil, nil, options_switch_template)

		frame6.DisableGroupsSlider:SetPoint ("left", frame6.DisableGroupsLabel, "right", 2)
		frame6.DisableGroupsSlider:SetAsCheckBox()
		frame6.DisableGroupsSlider.OnSwitch = function (_, _, value)
			_detalhes.disable_window_groups = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "DisableGroupsSlider", "DisableGroupsLabel", Loc ["STRING_OPTIONS_DISABLE_GROUPS_DESC"])
	

		--> disable lock resize ungroup buttons
		g:NewLabel (frame6, _, "$parentDisableLockResizeUngroupLabel", "DisableLockResizeUngroupLabel", Loc ["STRING_OPTIONS_DISABLE_LOCK_RESIZE"], "GameFontHighlightLeft")
		g:NewSwitch (frame6, _, "$parentDisableLockResizeUngroupSlider", "DisableLockResizeUngroupSlider", 60, 20, _, _, _detalhes.disable_lock_ungroup_buttons, nil, nil, nil, nil, options_switch_template)

		frame6.DisableLockResizeUngroupSlider:SetPoint ("left", frame6.DisableLockResizeUngroupLabel, "right", 2)
		frame6.DisableLockResizeUngroupSlider:SetAsCheckBox()
		frame6.DisableLockResizeUngroupSlider.OnSwitch = function (_, _, value)
			_detalhes.disable_lock_ungroup_buttons = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "DisableLockResizeUngroupSlider", "DisableLockResizeUngroupLabel", Loc ["STRING_OPTIONS_DISABLE_LOCK_RESIZE_DESC"])
		
		--> disable stretch button
		g:NewLabel (frame6, _, "$parentDisableStretchButtonLabel", "DisableStretchButtonLabel", Loc ["STRING_OPTIONS_DISABLE_STRETCH_BUTTON"], "GameFontHighlightLeft")
		g:NewSwitch (frame6, _, "$parentDisableStretchButtonSlider", "DisableStretchButtonSlider", 60, 20, _, _, _detalhes.disable_stretch_button, nil, nil, nil, nil, options_switch_template)

		frame6.DisableStretchButtonSlider:SetPoint ("left", frame6.DisableStretchButtonLabel, "right", 2)
		frame6.DisableStretchButtonSlider:SetAsCheckBox()
		frame6.DisableStretchButtonSlider.OnSwitch = function (_, _, value)
			_detalhes.disable_stretch_button = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "DisableStretchButtonSlider", "DisableStretchButtonLabel", Loc ["STRING_OPTIONS_DISABLE_STRETCH_BUTTON_DESC"])


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> instances
	
		g:NewLabel (frame6, _, "$parentDeleteInstanceLabel", "deleteInstanceLabel", Loc ["STRING_OPTIONS_INSTANCE_DELETE"], "GameFontHighlightLeft")
		
		local onSelectDeleteInstance = function (_, _, selected)
			frame6.deleteInstanceButton.selected_instance = selected
		end
		
		local buildSelectDeleteInstance = function()
			local InstanceList = {}
			for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount), 1 do 
				local _this_instance = _detalhes.tabela_instancias [index]

				--> pegar o que ela ta mostrando
				local atributo = _this_instance.atributo
				local sub_atributo = _this_instance.sub_atributo
				
				if (atributo == 5) then --> custom
					local CustomObject = _detalhes.custom [sub_atributo]
					
					if (CustomObject) then
						InstanceList [#InstanceList+1] = {value = index, label = _detalhes.atributos.lista [atributo] .. " - " .. CustomObject.name, onclick = onSelectDeleteInstance, icon = CustomObject.icon}
					else
						InstanceList [#InstanceList+1] = {value = index, label = "unknown" .. " - " .. " invalid custom", onclick = onSelectDeleteInstance, icon = [[Interface\COMMON\VOICECHAT-MUTED]]}
					end
					
				else
					local modo = _this_instance.modo
					
					if (modo == 1) then --alone
						atributo = _detalhes.SoloTables.Mode or 1
						local SoloInfo = _detalhes.SoloTables.Menu [atributo]
						if (SoloInfo) then
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. SoloInfo [1], onclick = onSelectDeleteInstance, icon = SoloInfo [2]}
						else
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectDeleteInstance, icon = ""}
						end
						
					elseif (modo == 4) then --raid
						atributo = _detalhes.RaidTables.Mode or 1
						local RaidInfo = _detalhes.RaidTables.Menu [atributo]
						if (RaidInfo) then
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. RaidInfo [1], onclick = onSelectDeleteInstance, icon = RaidInfo [2]}
						else
							InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectDeleteInstance, icon = ""}
						end
					else
						InstanceList [#InstanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectDeleteInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
						
					end
				end
			end
			return InstanceList
		end
		
		local d = g:NewDropDown (frame6, _, "$parentDeleteInstanceDropdown", "deleteInstanceDropdown", 160, dropdown_height, buildSelectDeleteInstance, 0, options_dropdown_template)
		d:SetBackdropBorderColor (.5, .2, .2, 0.4)
		frame6.deleteInstanceDropdown:SetPoint ("left", frame6.deleteInstanceLabel, "right", 2, 0)		
		
		local desc = window:CreateLineBackground2 (frame6, "deleteInstanceDropdown", "deleteInstanceLabel", Loc ["STRING_OPTIONS_INSTANCE_DELETE_DESC"])
		desc:SetWidth (180)
		
		local delete_instance = function (self)
			if (self.selected_instance) then
				_detalhes:DeleteInstance (self.selected_instance)
				ReloadUI()
			end
		end
		
		local confirm_button = CreateFrame ("button", "DetailsDeleteInstanceButton", frame6, "OptionsButtonTemplate")
		confirm_button:SetSize (60, 20)
		confirm_button:SetPoint ("left", frame6.deleteInstanceDropdown.widget, "right", 2, 0)
		confirm_button:SetText ("confirm")
		confirm_button:SetScript ("OnClick", delete_instance)
		frame6.deleteInstanceButton = confirm_button

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> Use Scroll Bar
		g:NewLabel (frame6, _, "$parentUseScrollLabel", "scrollLabel", Loc ["STRING_OPTIONS_SCROLLBAR"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame6, _, "$parentUseScrollSlider", "scrollSlider", 60, 20, _, _, _detalhes.use_scroll, nil, nil, nil, nil, options_switch_template)
		frame6.scrollSlider:SetPoint ("left", frame6.scrollLabel, "right", 2, 0)
		frame6.scrollSlider:SetAsCheckBox()
		frame6.scrollSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue
			_detalhes.use_scroll = value
			if (not value) then
				for index = 1, #_detalhes.tabela_instancias do
					local instance = _detalhes.tabela_instancias [index]
					if (instance.baseframe) then --fast check if instance already been initialized
						instance:EsconderScrollBar (true, true)
					end
				end
			end
			--hard instances reset
			_detalhes:InstanciaCallFunction (_detalhes.gump.Fade, "in", nil, "barras")
			_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
			_detalhes:InstanciaCallFunction (_detalhes.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
			_detalhes:InstanciaCallFunction (_detalhes.ResetaGump) --_detalhes:ResetaGump ("de todas as instancias")
			_detalhes:AtualizaGumpPrincipal (-1, true) --atualiza todas as instancias
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame6, "scrollSlider", "scrollLabel", Loc ["STRING_OPTIONS_SCROLLBAR_DESC"])

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		
	--> general anchor
		g:NewLabel (frame6, _, "$parentAdjustmentsAnchor", "AdjustmentsAnchorLabel", Loc ["STRING_OPTIONS_ROW_SETTING_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame6, _, "$parentAdjustments2Anchor", "AdjustmentsAnchor2Label", Loc ["STRING_OPTIONS_WINDOW_ANCHOR_ANCHORS"], "GameFontNormal")
		g:NewLabel (frame6, _, "$parentInstancesMiscAnchor", "WindowAnchorLabel", Loc ["STRING_OPTIONS_INSTANCES"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_instance:SetPoint (x, window.title_y_pos)
		titulo_instance_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"AdjustmentsAnchorLabel", 1, true},
			{"windowPickColorLabel", 2},
			{"windowBackgroundPickColorLabel", 3},
			{"WindowScaleLabel", 4},
			{"sideBarsLabel", 5},
			{"IgnoreMassShowHideLabel", 6},
			{"strataLabel", 7},
			{"backdropLabel", 8},
			{"DisableGroupsLabel", 9, true},
			{"DisableLockResizeUngroupLabel", 10},
			{"DisableStretchButtonLabel", 11},
			
			--{"AdjustmentsAnchor2Label", 12},
			{"instanceToolbarSideLabel", 12, true},
			{"stretchAnchorLabel", 13},
			{"stretchAlwaysOnTopLabel", 14},
		}
		
		window:arrange_menu (frame6, left_side, x, window.top_start_at)
		
		local right_side = {
			{"statusbarAnchorLabel", 1, true},
			{"statusbarLabel", 2},
			{"statusbarColorLabel", 3},
			{"MicroDisplaysAnchor", 4, true},
			{"MicroDisplayLeftLabel", 5},
			{"MicroDisplayCenterLabel", 6},
			{"MicroDisplayRightLabel", 7},
			{"instanceMicroDisplaysSideLabel", 8, true},
			{"LockMiniDisplaysLabel", 9},
			{"MicroDisplayWarningLabel", 10},
		}
		
		window:arrange_menu (frame6, right_side, window.right_start_at, window.top_start_at)
		
		local right_side2 = {
			{"WindowAnchorLabel", 1, true},
			{"deleteInstanceLabel", 2},
			{"scrollLabel", 3},
		}
		window:arrange_menu (frame6, right_side2, window.right_start_at, window.top_start_at-294)
	
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Top Menu Bar ~7
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function window:CreateFrame7()

	local frame7 = window.options [7][1]
	
		local titulo_toolbar = g:NewLabel (frame7, _, "$parentTituloToolbar", "tituloToolbarLabel", Loc ["STRING_OPTIONS_TOOLBAR_SETTINGS"], "GameFontNormal", 16)
		local titulo_toolbar_desc = g:NewLabel (frame7, _, "$parentTituloToolbar2", "tituloToolbar2Label", Loc ["STRING_OPTIONS_TOOLBAR_SETTINGS_DESC"], "GameFontNormal", 10, "white")
		titulo_toolbar_desc.width = 320

		-- menu anchors
			local s = g:NewSlider (frame7, _, "$parentMenuAnchorXSlider", "menuAnchorXSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -200, 200, 1, instance.menu_anchor[1], nil, nil, nil, options_slider_template)
			--config_slider (s)
			local s = g:NewSlider (frame7, _, "$parentMenuAnchorYSlider", "menuAnchorYSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -30, 30, 1, instance.menu_anchor[2], nil, nil, nil, options_slider_template)
			--config_slider (s)
			
			g:NewLabel (frame7, _, "$parentMenuAnchorXLabel", "menuAnchorXLabel", Loc ["STRING_OPTIONS_MENU_X"], "GameFontHighlightLeft")
			g:NewLabel (frame7, _, "$parentMenuAnchorYLabel", "menuAnchorYLabel", Loc ["STRING_OPTIONS_MENU_Y"], "GameFontHighlightLeft")
			
			frame7.menuAnchorXSlider:SetPoint ("left", frame7.menuAnchorXLabel, "right", 2, -1)
			frame7.menuAnchorYSlider:SetPoint ("left", frame7.menuAnchorYLabel, "right", 2)
			
			frame7.menuAnchorXSlider:SetThumbSize (24)
			frame7.menuAnchorXSlider:SetHook ("OnValueChange", function (self, instance, x) 
				instance:MenuAnchor (x, nil)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:MenuAnchor (x, nil)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			--frame7.menuAnchorYSlider:SetThumbSize (50)
			frame7.menuAnchorYSlider:SetHook ("OnValueChange", function (self, instance, y)
				instance:MenuAnchor (nil, y)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:MenuAnchor (nil, y)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end)
			
			window:CreateLineBackground2 (frame7, "menuAnchorXSlider", "menuAnchorXLabel", Loc ["STRING_OPTIONS_MENU_X_DESC"])
			window:CreateLineBackground2 (frame7, "menuAnchorYSlider", "menuAnchorYLabel", Loc ["STRING_OPTIONS_MENU_X_DESC"])

			function frame7:update_menuanchor_xy (instance)
				if (instance.toolbar_side == 1) then --top
					frame7.menuAnchorXSlider:SetValue (instance.menu_anchor [1])
					frame7.menuAnchorYSlider:SetValue (instance.menu_anchor [2])
				elseif (instance.toolbar_side == 2) then --bottom
					frame7.menuAnchorXSlider:SetValue (instance.menu_anchor_down [1])
					frame7.menuAnchorYSlider:SetValue (instance.menu_anchor_down [2])
				end
			end
			
		-- menu anchor left and right
		
			local menusode_switch_func = function (slider, value)
				if (value == 1) then
					return false
				elseif (value == 2) then
					return true
				end
			end
			local menuside_return_func = function (slider, value)
				if (value) then
					return 2
				else
					return 1
				end
			end	
			
			g:NewSwitch (frame7, _, "$parentMenuAnchorSideSlider", "pluginMenuAnchorSideSlider", 80, 20, Loc ["STRING_LEFT"], Loc ["STRING_RIGHT"], instance.menu_anchor.side, nil, menusode_switch_func, menuside_return_func, nil, options_switch_template)
			g:NewLabel (frame7, _, "$parentMenuAnchorSideLabel", "menuAnchorSideLabel", Loc ["STRING_OPTIONS_MENU_ANCHOR"], "GameFontHighlightLeft")
			
			frame7.pluginMenuAnchorSideSlider:SetPoint ("left", frame7.menuAnchorSideLabel, "right", 2)
			frame7.pluginMenuAnchorSideSlider:SetAsCheckBox()
			frame7.pluginMenuAnchorSideSlider.OnSwitch = function (self, instance, value)
				instance:LeftMenuAnchorSide (value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:LeftMenuAnchorSide (value)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame7, "pluginMenuAnchorSideSlider", "menuAnchorSideLabel", Loc ["STRING_OPTIONS_MENU_ANCHOR_DESC"])
			
		-- desaturate
			g:NewSwitch (frame7, _, "$parentDesaturateMenuSlider", "desaturateMenuSlider", 60, 20, _, _, instance.desaturated_menu, nil, nil, nil, nil, options_switch_template)
			g:NewLabel (frame7, _, "$parentDesaturateMenuLabel", "desaturateMenuLabel", Loc ["STRING_OPTIONS_DESATURATE_MENU"], "GameFontHighlightLeft")

			frame7.desaturateMenuSlider:SetPoint ("left", frame7.desaturateMenuLabel, "right", 2)
			frame7.desaturateMenuSlider:SetAsCheckBox()
			frame7.desaturateMenuSlider.OnSwitch = function (self, instance, value)
				instance:DesaturateMenu (value)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:DesaturateMenu (value)
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame7, "desaturateMenuSlider", "desaturateMenuLabel", Loc ["STRING_OPTIONS_DESATURATE_MENU_DESC"])

		-- hide icon
			g:NewSwitch (frame7, _, "$parentHideIconSlider", "hideIconSlider", 60, 20, _, _, instance.hide_icon, nil, nil, nil, nil, options_switch_template)			
			g:NewLabel (frame7, _, "$parentHideIconLabel", "hideIconLabel", Loc ["STRING_OPTIONS_HIDE_ICON"], "GameFontHighlightLeft")

			frame7.hideIconSlider:SetPoint ("left", frame7.hideIconLabel, "right", 2)
			frame7.hideIconSlider:SetAsCheckBox()
			frame7.hideIconSlider.OnSwitch = function (self, instance, value)
			
				instance:HideMainIcon (value)
				
				if (not DetailsOptionsWindow.loading_settings and _detalhes.skins [instance.skin].icon_titletext_position) then
					if (not value and instance.attribute_text.enabled and instance.attribute_text.side == instance.toolbar_side) then
						instance.attribute_text.anchor [1] = _detalhes.skins [instance.skin].icon_titletext_position [1]
						instance.attribute_text.anchor [2] = _detalhes.skins [instance.skin].icon_titletext_position [2]
						instance:AttributeMenu()
					elseif (value and instance.attribute_text.enabled and instance.attribute_text.side == instance.toolbar_side) then
						instance.attribute_text.anchor [1] = _detalhes.skins [instance.skin].instance_cprops.attribute_text.anchor [1]
						instance.attribute_text.anchor [2] = _detalhes.skins [instance.skin].instance_cprops.attribute_text.anchor [2]
						instance:AttributeMenu()
					end
				end
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:HideMainIcon (value)
							
							if (not DetailsOptionsWindow.loading_settings and _detalhes.skins [this_instance.skin].icon_titletext_position) then
								if (not value and this_instance.attribute_text.enabled and this_instance.attribute_text.side == this_instance.toolbar_side) then
									this_instance.attribute_text.anchor [1] = _detalhes.skins [this_instance.skin].icon_titletext_position [1]
									this_instance.attribute_text.anchor [2] = _detalhes.skins [this_instance.skin].icon_titletext_position [2]
									this_instance:AttributeMenu()
								elseif (value and this_instance.attribute_text.enabled and this_instance.attribute_text.side == this_instance.toolbar_side) then
									this_instance.attribute_text.anchor [1] = _detalhes.skins [this_instance.skin].instance_cprops.attribute_text.anchor [1]
									this_instance.attribute_text.anchor [2] = _detalhes.skins [this_instance.skin].instance_cprops.attribute_text.anchor [2]
									this_instance:AttributeMenu()
								end
							end
							
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame7, "hideIconSlider", "hideIconLabel", Loc ["STRING_OPTIONS_HIDE_ICON_DESC"])
			
		-- plugin icons direction
			local grow_switch_func = function (slider, value)
				if (value == 1) then
					return false
				elseif (value == 2) then
					return true
				end
			end
			local grow_return_func = function (slider, value)
				if (value) then
					return 2
				else
					return 1
				end
			end	
			
			g:NewSwitch (frame7, _, "$parentPluginIconsDirectionSlider", "pluginIconsDirectionSlider", 80, 20, Loc ["STRING_LEFT"], Loc ["STRING_RIGHT"], instance.plugins_grow_direction, nil, grow_switch_func, grow_return_func, nil, options_switch_template)
			g:NewLabel (frame7, _, "$parentPluginIconsDirectionLabel", "pluginIconsDirectionLabel", Loc ["STRING_OPTIONS_PICONS_DIRECTION"], "GameFontHighlightLeft")

			frame7.pluginIconsDirectionSlider:SetPoint ("left", frame7.pluginIconsDirectionLabel, "right", 2)
			frame7.pluginIconsDirectionSlider:SetAsCheckBox()
			frame7.pluginIconsDirectionSlider.OnSwitch = function (self, instance, value)
				instance.plugins_grow_direction = value
				instance:ToolbarMenuSetButtons()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance.plugins_grow_direction = value
							this_instance:ToolbarMenuSetButtons()
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			frame7.pluginIconsDirectionSlider.thumb:SetSize (40, 12)
			
			window:CreateLineBackground2 (frame7, "pluginIconsDirectionSlider", "pluginIconsDirectionLabel", Loc ["STRING_OPTIONS_PICONS_DIRECTION_DESC"])
			
		--> show or hide buttons
			local label_icons = g:NewLabel (frame7, _, "$parentShowButtonsLabel", "showButtonsLabel", Loc ["STRING_OPTIONS_MENU_SHOWBUTTONS"], "GameFontHighlightLeft")
			local icon1 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {0/256, 32/256, 0, 1}, "icon1", nil)
			local icon2 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {33/256, 64/256, 0, 1}, "icon2", nil)
			local icon3 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {64/256, 96/256, 0, 1}, "icon3", nil)
			local icon4 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {96/256, 128/256, 0, 1}, "icon4", nil)
			local icon5 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {128/256, 160/256, 0, 1}, "icon5", nil)
			local icon6 = g:NewImage (frame7, [[Interface\AddOns\Details\images\toolbar_icons]], 20, 20, "border", {160/256, 192/256, 0, 1}, "icon6", nil)
			
			local X1 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x1", nil)
			local X2 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x2", nil)
			local X3 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x3", nil)
			local X4 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x4", nil)
			local X5 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x5", nil)
			local X6 = g:NewImage (frame7, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 16, 16, nil, nil, "x6", nil)
			X1:SetVertexColor (1, 1, 1, .9)
			X2:SetVertexColor (1, 1, 1, .9)
			X3:SetVertexColor (1, 1, 1, .9)
			X4:SetVertexColor (1, 1, 1, .9)
			X5:SetVertexColor (1, 1, 1, .9)
			X6:SetVertexColor (1, 1, 1, .9)
			local x_container = {X1, X2, X3, X4, X5, X6}
			
			local func = function (self, button, menu_button)
				local instance = _G.DetailsOptionsWindow.instance
				
				instance.menu_icons [menu_button] = not instance.menu_icons [menu_button]
				instance:ToolbarMenuSetButtons()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance.menu_icons [menu_button] = not this_instance.menu_icons [menu_button]
							this_instance:ToolbarMenuSetButtons()
						end
					end
				end
				
				if (instance.menu_icons [menu_button]) then
					x_container [menu_button]:Hide()
				else
					x_container [menu_button]:Show()
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local t = g:GetTemplate ("button", "DETAILS_TITLEBAR_OPTION_BUTTON_TEMPLATE")
			
			local button1 = g:NewButton (frame7, _, "$parentShowButtons1", "showButtons1Button", 21, 21, func, 1, nil, nil, nil, nil, t)
			local button2 = g:NewButton (frame7, _, "$parentShowButtons2", "showButtons2Button", 21, 21, func, 2, nil, nil, nil, nil, t)
			local button3 = g:NewButton (frame7, _, "$parentShowButtons3", "showButtons3Button", 21, 21, func, 3, nil, nil, nil, nil, t)
			local button4 = g:NewButton (frame7, _, "$parentShowButtons4", "showButtons4Button", 21, 21, func, 4, nil, nil, nil, nil, t)
			local button5 = g:NewButton (frame7, _, "$parentShowButtons5", "showButtons5Button", 21, 21, func, 5, nil, nil, nil, nil, t)
			local button6 = g:NewButton (frame7, _, "$parentShowButtons6", "showButtons6Button", 21, 21, func, 6, nil, nil, nil, nil, t)

			function frame7:update_icon_buttons (instance)
				for i = 1, 6 do 
					if (instance.menu_icons [i]) then
						x_container [i]:Hide()
					else
						x_container [i]:Show()
					end
				end
			end
			
			button1:SetPoint ("left", label_icons, "right", 5, 0)
			icon1:SetPoint ("left", label_icons, "right", 5, 0)
			X1:SetPoint ("center", button1, "center")
			
			button2:SetPoint ("left", icon1, "right", 2, 0)
			icon2:SetPoint ("left", icon1, "right", 2, 0)
			X2:SetPoint ("center", button2, "center")
			
			button3:SetPoint ("left", icon2, "right", 2, 0)
			icon3:SetPoint ("left", icon2, "right", 2, 0)
			X3:SetPoint ("center", button3, "center")
			
			button4:SetPoint ("left", icon3, "right", 2, 0)
			icon4:SetPoint ("left", icon3, "right", 2, 0)
			X4:SetPoint ("center", button4, "center")
			
			button5:SetPoint ("left", icon4, "right", 2, 0)
			icon5:SetPoint ("left", icon4, "right", 2, 0)
			X5:SetPoint ("center", button5, "center")
			
			button6:SetPoint ("left", icon5, "right", 2, 0)
			icon6:SetPoint ("left", icon5, "right", 2, 0)
			X6:SetPoint ("center", button6, "center")
			
			window:CreateLineBackground2 (frame7, "showButtons1Button", "showButtonsLabel", Loc ["STRING_OPTIONS_MENU_SHOWBUTTONS_DESC"])
			
	--icon sizes
		local s = g:NewSlider (frame7, _, "$parentMenuIconSizeSlider", "menuIconSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0.4, 1.6, 0.05, instance.menu_icons_size, true, nil, nil, options_slider_template)
		--config_slider (s)
		s.useDecimals = true
		s:SetThumbSize (24)
		s.fine_tuning = 0.05
		
		g:NewLabel (frame7, _, "$parentMenuIconSizeLabel", "menuIconSizeLabel", Loc ["STRING_OPTIONS_SIZE"], "GameFontHighlightLeft")
		
		frame7.menuIconSizeSlider:SetPoint ("left", frame7.menuIconSizeLabel, "right", 2, -1)
		
		frame7.menuIconSizeSlider:SetHook ("OnValueChange", function (self, instance, value)
			instance:ToolbarMenuButtonsSize (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:ToolbarMenuButtonsSize (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame7, "menuIconSizeSlider", "menuIconSizeLabel", Loc ["STRING_OPTIONS_MENU_BUTTONSSIZE_DESC"])
		
	--icon spacement
	
		local s = g:NewSlider (frame7, _, "$parentMenuIconSpaceSlider", "MenuIconSpaceSlider", SLIDER_WIDTH, SLIDER_HEIGHT, -5, 10, 1, instance.menu_icons.space, nil, nil, nil, options_slider_template)
		--config_slider (s)
		
		g:NewLabel (frame7, _, "$parentMenuIconSpaceLabel", "MenuIconSpaceLabel", Loc ["STRING_OPTIONS_MENUS_SPACEMENT"], "GameFontHighlightLeft")
		
		frame7.MenuIconSpaceSlider:SetPoint ("left", frame7.MenuIconSpaceLabel, "right", 2, -1)
		
		frame7.MenuIconSpaceSlider:SetHook ("OnValueChange", function (self, instance, value)
			instance:ToolbarMenuSetButtonsOptions (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:ToolbarMenuSetButtonsOptions (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame7, "MenuIconSpaceSlider", "MenuIconSpaceLabel", Loc ["STRING_OPTIONS_MENUS_SPACEMENT_DESC"])
		
	--icon shadow
	
		g:NewSwitch (frame7, _, "$parentMenuIconShadowSlider", "MenuIconShadowSlider", 60, 20, _, _, instance.menu_icons.shadow, nil, nil, nil, nil, options_switch_template)			
		g:NewLabel (frame7, _, "$parentMenuIconShadowLabel", "MenuIconShadowLabel", Loc ["STRING_OPTIONS_MENUS_SHADOW"], "GameFontHighlightLeft")

		frame7.MenuIconShadowSlider:SetPoint ("left", frame7.MenuIconShadowLabel, "right", 2)
		frame7.MenuIconShadowSlider:SetAsCheckBox()
		frame7.MenuIconShadowSlider.OnSwitch = function (self, instance, value)
			instance:ToolbarMenuSetButtonsOptions (nil, value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:ToolbarMenuSetButtonsOptions (nil, value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame7, "MenuIconShadowSlider", "MenuIconShadowLabel", Loc ["STRING_OPTIONS_MENUS_SHADOW_DESC"])
		
		
		
--auto hide menus
		
	--left
		g:NewLabel (frame7, _, "$parentAutoHideLeftMenuLabel", "autoHideLeftMenuLabel", Loc ["STRING_OPTIONS_MENU_AUTOHIDE_LEFT"], "GameFontHighlightLeft")
		g:NewSwitch (frame7, _, "$parentAutoHideLeftMenuSwitch", "autoHideLeftMenuSwitch", 60, 20, nil, nil, instance.auto_hide_menu.left, nil, nil, nil, nil, options_switch_template)
		frame7.autoHideLeftMenuSwitch:SetPoint ("left", frame7.autoHideLeftMenuLabel, "right", 2)
		frame7.autoHideLeftMenuSwitch:SetAsCheckBox()
		frame7.autoHideLeftMenuSwitch.OnSwitch = function (self, instance, value)
			instance:SetAutoHideMenu (value)
			
			if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:SetAutoHideMenu (value)
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame7, "autoHideLeftMenuSwitch", "autoHideLeftMenuLabel", Loc ["STRING_OPTIONS_MENU_AUTOHIDE_DESC"])
	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

		--> click to open menus
		g:NewLabel (frame7, _, "$parentClickToOpenMenusLabel", "ClickToOpenMenusLabel", Loc ["STRING_OPTIONS_CLICK_TO_OPEN_MENUS"], "GameFontHighlightLeft")
		g:NewSwitch (frame7, _, "$parentClickToOpenMenusSlider", "ClickToOpenMenusSlider", 60, 20, _, _, _detalhes.instances_menu_click_to_open, nil, nil, nil, nil, options_switch_template)

		frame7.ClickToOpenMenusSlider:SetPoint ("left", frame7.ClickToOpenMenusLabel, "right", 2)
		frame7.ClickToOpenMenusSlider:SetAsCheckBox()
		frame7.ClickToOpenMenusSlider.OnSwitch = function (_, _, value)
			_detalhes.instances_menu_click_to_open = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame7, "ClickToOpenMenusSlider", "ClickToOpenMenusLabel", Loc ["STRING_OPTIONS_CLICK_TO_OPEN_MENUS_DESC"])

		--> disable reset button
		g:NewLabel (frame7, _, "$parentDisableResetLabel", "DisableResetLabel", Loc ["STRING_OPTIONS_DISABLE_RESET"], "GameFontHighlightLeft")
		g:NewSwitch (frame7, _, "$parentDisableResetSlider", "DisableResetSlider", 60, 20, _, _, _detalhes.disable_reset_button, nil, nil, nil, nil, options_switch_template)

		frame7.DisableResetSlider:SetPoint ("left", frame7.DisableResetLabel, "right", 2)
		frame7.DisableResetSlider:SetAsCheckBox()
		frame7.DisableResetSlider.OnSwitch = function (_, _, value)
			_detalhes.disable_reset_button = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame7, "DisableResetSlider", "DisableResetLabel", Loc ["STRING_OPTIONS_DISABLE_RESET_DESC"])

		--> menu text face
		local onSelectFont = function (_, _, fontName)
			_detalhes.font_faces.menus = fontName
		end
		
		local buildFontMenu = function() 
			local fontObjects = SharedMedia:HashTable ("font")
			local fontTable = {}
			for name, fontPath in pairs (fontObjects) do 
				fontTable[#fontTable+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = onSelectFont, font = fontPath, descfont = name, desc = Loc ["STRING_MUSIC_DETAILS_ROBERTOCARLOS"]}
			end
			table.sort (fontTable, function (t1, t2) return t1.label < t2.label end)
			return fontTable 
		end
		
		local d = g:NewDropDown (frame7, _, "$parentFontDropdown", "fontDropdown", DROPDOWN_WIDTH, dropdown_height, buildFontMenu, nil, options_dropdown_template)
		
		g:NewLabel (frame7, _, "$parentFontLabel", "fontLabel", Loc ["STRING_OPTIONS_MENU_FONT_FACE"], "GameFontHighlightLeft")
		frame7.fontDropdown:SetPoint ("left", frame7.fontLabel, "right", 2)

		window:CreateLineBackground2 (frame7, "fontDropdown", "fontLabel", Loc ["STRING_OPTIONS_MENU_FONT_FACE_DESC"])	
		
		--> menu text size
		g:NewLabel (frame7, _, "$parentMenuTextSizeLabel", "MenuTextSizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame7, _, "$parentMenuTextSizeSlider", "MenuTextSizeSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 5, 32, 1, _detalhes.font_sizes.menus, nil, nil, nil, options_slider_template)
	
		frame7.MenuTextSizeSlider:SetPoint ("left", frame7.MenuTextSizeLabel, "right", 2)
	
		frame7.MenuTextSizeSlider:SetHook ("OnValueChange", function (_, _, amount)
			_detalhes.font_sizes.menus = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame7, "MenuTextSizeSlider", "MenuTextSizeLabel", Loc ["STRING_OPTIONS_MENU_FONT_SIZE_DESC"])

		--> disable all displays window
		g:NewLabel (frame7, _, "$parentDisableAllDisplaysWindowLabel", "DisableAllDisplaysWindowLabel", Loc ["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW"], "GameFontHighlightLeft")
		g:NewSwitch (frame7, _, "$parentDisableAllDisplaysWindowSlider", "DisableAllDisplaysWindowSlider", 60, 20, _, _, _detalhes.disable_alldisplays_window, nil, nil, nil, nil, options_switch_template)

		frame7.DisableAllDisplaysWindowSlider:SetPoint ("left", frame7.DisableAllDisplaysWindowLabel, "right", 2)
		frame7.DisableAllDisplaysWindowSlider:SetAsCheckBox()
		frame7.DisableAllDisplaysWindowSlider.OnSwitch = function (_, _, value)
			_detalhes.disable_alldisplays_window = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame7, "DisableAllDisplaysWindowSlider", "DisableAllDisplaysWindowLabel", Loc ["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW_DESC"])		
		

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

		
	--> Anchors
	
		--general anchor
		g:NewLabel (frame7, _, "$parentLeftMenuAnchor", "LeftMenuAnchorLabel", Loc ["STRING_OPTIONS_LEFT_MENU_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame7, _, "$parentLayoutAnchor", "LayoutAnchorLabel", Loc ["STRING_OPTIONS_ROW_SETTING_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_toolbar:SetPoint (x, window.title_y_pos)
		titulo_toolbar_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"LayoutAnchorLabel", 1, true},
			{label_icons, 2},
			{"menuIconSizeLabel", 3},
			{"desaturateMenuLabel", 4},
			{"MenuIconShadowLabel", 5},
			
			{"menuAnchorXLabel", 6, true},
			{"menuAnchorYLabel", 7},
			{"MenuIconSpaceLabel", 8},
			
			{"hideIconLabel", 9, true},
			{"menuAnchorSideLabel", 10},
			{"pluginIconsDirectionLabel", 11},
		}
		
		window:arrange_menu (frame7, left_side, x, window.top_start_at)
	
		local right_side = {
			{"LeftMenuAnchorLabel", 1, true},
			{"MenuTextSizeLabel", 2},
			{"fontLabel", 3},
			{"DisableResetLabel", 4},
			{"ClickToOpenMenusLabel", 5},
			{"autoHideLeftMenuLabel", 6},
			{"DisableAllDisplaysWindowLabel", 7},
		}
		
		window:arrange_menu (frame7, right_side, window.right_start_at, window.top_start_at)
	
		
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Rows: Advanced ~8
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function window:CreateFrame8()

		local frame8 = window.options [8][1]

		local titulo_toolbar = g:NewLabel (frame8, _, "$parentTituloToolbar_buttons", "tituloToolbarLabel", Loc ["STRING_OPTIONS_ROWADV_TITLE"], "GameFontNormal", 16)
		local titulo_toolbar_desc = g:NewLabel (frame8, _, "$parentTituloToolbar_buttons", "tituloToolbar2Label", Loc ["STRING_OPTIONS_ROWADV_TITLE_DESC"], "GameFontNormal", 10, "white")
		titulo_toolbar_desc.width = 320
	
		--> models
			--> anchor
				g:NewLabel (frame8, _, "$parentModelUpperAnchor", "ModelUpperAnchor", Loc ["STRING_OPTIONS_3D_UANCHOR"], "GameFontNormal")
				g:NewLabel (frame8, _, "$parentModelLowerAnchor", "ModelLowerAnchor", Loc ["STRING_OPTIONS_3D_LANCHOR"], "GameFontNormal")
				
			--> upper model enabled
				g:NewLabel (frame8, _, "$parentModelUpperEnabledLabel", "ModelUpperEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
				g:NewSwitch (frame8, _, "$parentModelUpperEnabledSlider", "ModelUpperEnabledSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.row_info.models.upper_enabled, nil, nil, nil, nil, options_switch_template)
				frame8.ModelUpperEnabledSlider:SetPoint ("left", frame8.ModelUpperEnabledLabel, "right", 2, -1)
				frame8.ModelUpperEnabledSlider:SetAsCheckBox()
				frame8.ModelUpperEnabledSlider.OnSwitch = function (self, instance, value)
					instance:SetBarModel (value)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (value)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				window:CreateLineBackground2 (frame8, "ModelUpperEnabledSlider", "ModelUpperEnabledLabel", Loc ["STRING_OPTIONS_3D_UENABLED_DESC"])
				
			--> upper model texture
			
				local select_upper_model_callback = function (model)
					local instance = _G.DetailsOptionsWindow.instance
					
					instance:SetBarModel (nil, model)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (nil, model)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				local select_lower_model_callback = function (model)
					local instance = _G.DetailsOptionsWindow.instance
					
					instance:SetBarModel (nil, nil, nil, nil, model)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (nil, nil, nil, nil, model)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
			
				local select_model = function (is_upper)
					if (not IsAddOnLoaded ("Details_3DModelsPaths")) then
						local loaded, reason = LoadAddOn ("Details_3DModelsPaths")
						if (not loaded) then
							return _detalhes:Msg ("Failed to load Details_3DModelsPaths addon.")
						end
						_G.Lib3DModelList:Embed (_detalhes)
					end
					
					if (is_upper) then
						_detalhes:SelectModel (select_upper_model_callback, _G.DetailsOptionsWindow.instance.row_info.models.upper_model)
					else
						_detalhes:SelectModel (select_lower_model_callback, _G.DetailsOptionsWindow.instance.row_info.models.lower_model)
					end
				end
				
				g:NewButton (frame8, frame8, "$parentModelUpperSelect", "ModelUpperSelect", window.buttons_width, window.buttons_height, select_model, true, nil, nil, Loc ["STRING_OPTIONS_3D_SELECT"], 1, options_button_template)
				--frame8.ModelUpperSelect:InstallCustomTexture (nil, nil, nil, nil, nil, true)
				window:CreateLineBackground2 (frame8, "ModelUpperSelect", "ModelUpperSelect", Loc ["STRING_OPTIONS_3D_USELECT_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
				
				frame8.ModelUpperSelect:SetIcon ([[Interface\WorldStateFrame\OrcHead]], nil, nil, nil, {0.03125, 1-0.03125, 0.03125, 1-0.03125}, nil, nil, 2)
				frame8.ModelUpperSelect:SetTextColor (button_color_rgb)
				

			--> upper model alpha
				g:NewLabel (frame8, _, "$parentModelUpperAlphaLabel", "ModelUpperAlphaLabel", Loc ["STRING_ALPHA"], "GameFontHighlightLeft")
				local s = g:NewSlider (frame8, _, "$parentModelUpperAlphaSlider", "ModelUpperAlphaSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 1, 0.05, _G.DetailsOptionsWindow.instance.row_info.models.upper_alpha, true, nil, nil, options_slider_template)
				--config_slider (s)
				s:SetThumbSize (25)
			
				frame8.ModelUpperAlphaSlider:SetPoint ("left", frame8.ModelUpperAlphaLabel, "right", 2)
			
				frame8.ModelUpperAlphaSlider:SetHook ("OnValueChange", function (self, instance, amount)
					instance:SetBarModel (nil, nil, amount)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (nil, nil, amount)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end)
				
				window:CreateLineBackground2 (frame8, "ModelUpperAlphaSlider", "ModelUpperAlphaLabel", Loc ["STRING_OPTIONS_3D_UALPHA_DESC"])
				
			--> lower model enabled
				g:NewLabel (frame8, _, "$parentModelLowerEnabledLabel", "ModelLowerEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
				g:NewSwitch (frame8, _, "$parentModelLowerEnabledSlider", "ModelLowerEnabledSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.row_info.models.lower_enabled, nil, nil, nil, nil, options_switch_template)
				frame8.ModelLowerEnabledSlider:SetPoint ("left", frame8.ModelLowerEnabledLabel, "right", 2, -1)
				frame8.ModelLowerEnabledSlider:SetAsCheckBox()
				frame8.ModelLowerEnabledSlider.OnSwitch = function (self, instance, value)
					instance:SetBarModel (nil, nil, nil, value)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (nil, nil, nil, value)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				window:CreateLineBackground2 (frame8, "ModelLowerEnabledSlider", "ModelLowerEnabledLabel", Loc ["STRING_OPTIONS_3D_LENABLED_DESC"])
				
			--> lower model texture
			
				g:NewButton (frame8, frame8, "$parentModelLowerSelect", "ModelLowerSelect", window.buttons_width, window.buttons_height, select_model, nil, nil, nil, Loc ["STRING_OPTIONS_3D_SELECT"], nil, options_button_template)
				--frame8.ModelLowerSelect:InstallCustomTexture (nil, nil, nil, nil, nil, true)
				window:CreateLineBackground2 (frame8, "ModelLowerSelect", "ModelLowerSelect", Loc ["STRING_OPTIONS_3D_LSELECT_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
				
				frame8.ModelLowerSelect:SetIcon ([[Interface\WorldStateFrame\OrcHead]], nil, nil, nil, {0.03125, 1-0.03125, 0.03125, 1-0.03125}, nil, nil, 2)
				frame8.ModelLowerSelect:SetTextColor (button_color_rgb)
				
			--> lower model alpha
				g:NewLabel (frame8, _, "$parentModelLowerAlphaLabel", "ModelLowerAlphaLabel", Loc ["STRING_ALPHA"], "GameFontHighlightLeft")
				local s = g:NewSlider (frame8, _, "$parentModelLowerAlphaSlider", "ModelLowerAlphaSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0, 1, 0.05, _G.DetailsOptionsWindow.instance.row_info.models.lower_alpha, true, nil, nil, options_slider_template)
				--config_slider (s)
				s:SetThumbSize (25)
			
				frame8.ModelLowerAlphaSlider:SetPoint ("left", frame8.ModelLowerAlphaLabel, "right", 2)
			
				frame8.ModelLowerAlphaSlider:SetHook ("OnValueChange", function (self, instance, amount)
					instance:SetBarModel (nil, nil, nil, nil, nil, amount)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarModel (nil, nil, nil, nil, nil, amount)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end)
				
				window:CreateLineBackground2 (frame8, "ModelLowerAlphaSlider", "ModelLowerAlphaLabel", Loc ["STRING_OPTIONS_3D_LALPHA_DESC"])
		
		--> fast updates

			--> anchor
				g:NewLabel (frame8, _, "$parentBarUpdateRateAnchor", "BarUpdateRateAnchor", Loc ["STRING_OPTIONS_BARUR_ANCHOR"], "GameFontNormal")
			
			--> enable fast updates
			
				g:NewLabel (frame8, _, "$parentBarUpdateRateLabel", "BarUpdateRateLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
				g:NewSwitch (frame8, _, "$parentBarUpdateRateSlider", "BarUpdateRateSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.row_info.fast_ps_update, nil, nil, nil, nil, options_switch_template)
				frame8.BarUpdateRateSlider:SetPoint ("left", frame8.BarUpdateRateLabel, "right", 2, -1)
				frame8.BarUpdateRateSlider:SetAsCheckBox()
				frame8.BarUpdateRateSlider.OnSwitch = function (self, instance, value)
					instance:FastPSUpdate (value)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:FastPSUpdate (value)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				window:CreateLineBackground2 (frame8, "BarUpdateRateSlider", "BarUpdateRateLabel", Loc ["STRING_OPTIONS_BARUR_DESC"])
		
		--> player bar

			--> anchor
				g:NewLabel (frame8, _, "$parentPlayerBarAnchor", "PlayerBarAnchor", Loc ["STRING_OPTIONS_BAR_FOLLOWING_ANCHOR"], "GameFontNormal")
			
			--> enable player bar
				g:NewLabel (frame8, _, "$parentShowMeLabel", "ShowMeLabel", Loc ["STRING_OPTIONS_BAR_FOLLOWING"], "GameFontHighlightLeft")
				g:NewSwitch (frame8, _, "$parentShowMeSlider", "ShowMeSlider", 60, 20, _, _, instance.following.enabled, nil, nil, nil, nil, options_switch_template)
				frame8.ShowMeSlider:SetPoint ("left", frame8.ShowMeLabel, "right", 2, -1)
				frame8.ShowMeSlider:SetAsCheckBox()
				frame8.ShowMeSlider.OnSwitch = function (self, instance, value)
					instance:SetBarFollowPlayer (value)
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:SetBarFollowPlayer (value)
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				window:CreateLineBackground2 (frame8, "ShowMeSlider", "ShowMeLabel", Loc ["STRING_OPTIONS_BAR_FOLLOWING_DESC"])
		
		--> show total bar
			
			g:NewLabel (frame8, _, "$parentTotalBarAnchor", "totalBarAnchorLabel", Loc ["STRING_OPTIONS_TOTALBAR_ANCHOR"], "GameFontNormal")
			
			g:NewLabel (frame8, _, "$parentTotalBarLabel", "totalBarLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
			g:NewSwitch (frame8, _, "$parentTotalBarSlider", "totalBarSlider", 60, 20, _, _, instance.total_bar.enabled, nil, nil, nil, nil, options_switch_template)

			frame8.totalBarSlider:SetPoint ("left", frame8.totalBarLabel, "right", 2)
			frame8.totalBarSlider:SetAsCheckBox()
			frame8.totalBarSlider.OnSwitch = function (self, instance, value)
				instance.total_bar.enabled = value
				instance:InstanceReset()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance.total_bar.enabled = value
							this_instance:InstanceReset()
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame8, "totalBarSlider", "totalBarLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_DESC"])
			
		--> total bar color
				local totalbarcolor_callback = function (button, r, g, b, a)
				
					local instance = _G.DetailsOptionsWindow.instance
				
					instance.total_bar.color[1] = r
					instance.total_bar.color[2] = g
					instance.total_bar.color[3] = b
					instance:InstanceReset()
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance.total_bar.color[1] = r
								this_instance.total_bar.color[2] = g
								this_instance.total_bar.color[3] = b
								this_instance:InstanceReset()
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
				end
				g:NewColorPickButton (frame8, "$parentTotalBarColorPick", "totalBarColorPick", totalbarcolor_callback, nil, options_button_template)
				g:NewLabel (frame8, _, "$parentTotalBarColorPickLabel", "totalBarPickColorLabel", Loc ["STRING_COLOR"], "GameFontHighlightLeft")
				frame8.totalBarColorPick:SetPoint ("left", frame8.totalBarPickColorLabel, "right", 2, 0)
			
				window:CreateLineBackground2 (frame8, "totalBarColorPick", "totalBarPickColorLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_COLOR_DESC"])
			
		--> total bar only in group
			g:NewLabel (frame8, _, "$parentTotalBarOnlyInGroupLabel", "totalBarOnlyInGroupLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP"], "GameFontHighlightLeft")
			g:NewSwitch (frame8, _, "$parentTotalBarOnlyInGroupSlider", "totalBarOnlyInGroupSlider", 60, 20, _, _, instance.total_bar.only_in_group, nil, nil, nil, nil, options_switch_template)

			frame8.totalBarOnlyInGroupSlider:SetPoint ("left", frame8.totalBarOnlyInGroupLabel, "right", 2)
			frame8.totalBarOnlyInGroupSlider:SetAsCheckBox()
			frame8.totalBarOnlyInGroupSlider.OnSwitch = function (self, instance, value)
				instance.total_bar.only_in_group = value
				instance:InstanceReset()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance.total_bar.only_in_group = value
							this_instance:InstanceReset()
						end
					end
				end
				
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			window:CreateLineBackground2 (frame8, "totalBarOnlyInGroupSlider", "totalBarOnlyInGroupLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP_DESC"])
			
		--> total bar icon
			local totalbar_pickicon_callback = function (texture)
			
				local instance = _G.DetailsOptionsWindow.instance
			
				instance.total_bar.icon = texture
				instance:InstanceReset()
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance.total_bar.icon = texture
							this_instance:InstanceReset()
						end
					end
				end
				
				frame8.totalBarIconTexture:SetTexture (texture)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			local totalbar_pickicon = function()
				g:IconPick (totalbar_pickicon_callback, true)
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			g:NewLabel (frame8, _, "$parentTotalBarIconLabel", "totalBarIconLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_ICON"], "GameFontHighlightLeft")
			g:NewImage (frame8, nil, 20, 20, nil, nil, "totalBarIconTexture", "$parentTotalBarIconTexture")
			g:NewButton (frame8, _, "$parentTotalBarIconButton", "totalBarIconButton", 20, 20, totalbar_pickicon, nil, nil, nil, nil, nil, options_button_template)
			--frame8.totalBarIconButton:InstallCustomTexture (nil, nil, nil, true)
			frame8.totalBarIconButton:SetPoint ("left", frame8.totalBarIconLabel, "right", 2, 0)
			frame8.totalBarIconTexture:SetPoint ("left", frame8.totalBarIconLabel, "right", 2, 0)
			
			window:CreateLineBackground2 (frame8, "totalBarIconButton", "totalBarIconLabel", Loc ["STRING_OPTIONS_SHOW_TOTALBAR_ICON_DESC"])
			
		
		--> anchors
		
		local x = window.left_start_at
		
		titulo_toolbar:SetPoint (x, window.title_y_pos)
		titulo_toolbar_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"ModelUpperAnchor", 1, true},
			{"ModelUpperEnabledLabel", 2},
			{"ModelUpperAlphaLabel", 3},
			{"ModelUpperSelect", 4},
			
			{"ModelLowerAnchor", 5, true},
			{"ModelLowerEnabledLabel", 6},
			{"ModelLowerAlphaLabel", 7},
			{"ModelLowerSelect", 8},
			
			{"totalBarAnchorLabel", 9, true},
			{"totalBarIconLabel", 10},
			{"totalBarPickColorLabel", 11},
			{"totalBarLabel", 12},
			{"totalBarOnlyInGroupLabel", 13},
		}
		
		window:arrange_menu (frame8, left_side, x, window.top_start_at)
		
		local right_side = {
			{"BarUpdateRateAnchor", 1, true},
			{"BarUpdateRateLabel", 2},
			{"PlayerBarAnchor", 3, true},
			{"ShowMeLabel", 4},
		}
	
		window:arrange_menu (frame8, right_side, window.right_start_at, window.top_start_at)
		
end
		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Appearance - Wallpaper ~9
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function window:CreateFrame9()

	local frame9 = window.options [9][1]

		local titulo_wallpaper = g:NewLabel (frame9, _, "$parentTituloPersona", "tituloBarsLabel", Loc ["STRING_OPTIONS_WP"], "GameFontNormal", 16)
		local titulo_wallpaper_desc = g:NewLabel (frame9, _, "$parentTituloPersona2", "tituloBars2Label", Loc ["STRING_OPTIONS_WP_DESC"], "GameFontNormal", 10, "white")
		titulo_wallpaper_desc.width = 320
		
		--> wallpaper
		
			--> primeiro o bot�o de editar a imagem
			local callmeback = function (width, height, overlayColor, alpha, texCoords)
				local instance = _G.DetailsOptionsWindow.instance
				instance:InstanceWallpaper (nil, nil, alpha, texCoords, width, height, overlayColor)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceWallpaper (nil, nil, alpha, texCoords, width, height, overlayColor)
						end
					end
				end
				
				window:update_wallpaper_info()
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			
			local startImageEdit = function()
				local tinstance = _G.DetailsOptionsWindow.instance
				
				if (not tinstance.wallpaper.texture) then
					return
				end

				local wp = tinstance.wallpaper

				if (wp.texture:find ("TALENTFRAME")) then
					if (wp.anchor == "all") then
						g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, tinstance.baseframe.wallpaper:GetWidth(), tinstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
					else
						g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, tinstance.baseframe.wallpaper:GetWidth(), tinstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
					end
					
				else
					if (wp.anchor == "all") then
						g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, tinstance.baseframe.wallpaper:GetWidth(), tinstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
					else
						g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, tinstance.baseframe.wallpaper:GetWidth(), tinstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
					end
				end
			end
			g:NewButton (frame9, _, "$parentEditImage", "editImage", window.buttons_width, 18, startImageEdit, nil, nil, nil, Loc ["STRING_OPTIONS_EDITIMAGE"], nil, options_button_template)
			
			--> agora o dropdown do alinhamento
			local onSelectAnchor = function (_, instance, anchor)
				instance:InstanceWallpaper (nil, anchor)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceWallpaper (nil, anchor)
						end
					end
				end
				
				window:update_wallpaper_info()
				_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			end
			local anchorMenu = {
				{value = "all", label = "Fill", onclick = onSelectAnchor},
				{value = "center", label = "Center", onclick = onSelectAnchor},
				{value = "stretchLR", label = "Stretch Left-Right", onclick = onSelectAnchor},
				{value = "stretchTB", label = "Stretch Top-Bottom", onclick = onSelectAnchor},
				{value = "topleft", label = "Top Left", onclick = onSelectAnchor},
				{value = "bottomleft", label = "Bottom Left", onclick = onSelectAnchor},
				{value = "topright", label = "Top Right", onclick = onSelectAnchor},
				{value = "bottomright", label = "Bottom Right", onclick = onSelectAnchor},
			}
			local buildAnchorMenu = function()
				return anchorMenu
			end

			local d = g:NewDropDown (frame9, _, "$parentAnchorDropdown", "anchorDropdown", DROPDOWN_WIDTH, dropdown_height, buildAnchorMenu, nil, options_dropdown_template)			
	
			
			--> agora cria os 2 dropdown da categoria e wallpaper
			
			local onSelectSecTexture = function (self, instance, texturePath) 
				
				local textureOptions = window.WallpaperTextureOptions
				local selectedTextureOption
				for textureBracket, textureTables in pairs (textureOptions) do
					for i = 1, #textureTables do
						local textureTable = textureTables [i]
						if (textureTable.value == texturePath) then
							selectedTextureOption = textureTable
							break
						end
					end
				end
				
				if (texturePath:find ("TALENTFRAME")) then
				
					instance:InstanceWallpaper (texturePath, nil, nil, {0, 1, 0, 0.703125}, nil, nil, {1, 1, 1, 1})
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:InstanceWallpaper (texturePath, nil, nil, {0, 1, 0, 0.703125}, nil, nil, {1, 1, 1, 1})
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
					
					if (DetailsImageEdit and DetailsImageEdit:IsShown()) then
						local wp = instance.wallpaper
						if (wp.anchor == "all") then
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
						else
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
						end
					end
				
				elseif (texturePath:find ("EncounterJournal")) then
				
					instance:InstanceWallpaper (texturePath, nil, nil, {0.06, 0.68, 0.1, 0.57}, nil, nil, {1, 1, 1, 1})
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:InstanceWallpaper (texturePath, nil, nil, {0.06, 0.68, 0.1, 0.57}, nil, nil, {1, 1, 1, 1})
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
					
					if (DetailsImageEdit and DetailsImageEdit:IsShown()) then
						local wp = instance.wallpaper
						if (wp.anchor == "all") then
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
						else
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
						end
					end
				
				else
					local texCoords = selectedTextureOption and selectedTextureOption.texcoord
					instance:InstanceWallpaper (texturePath, nil, nil, texCoords or {0, 1, 0, 1}, nil, nil, {1, 1, 1, 1})
					
					if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:InstanceWallpaper (texturePath, nil, nil, texCoords or {0, 1, 0, 1}, nil, nil, {1, 1, 1, 1})
							end
						end
					end
					
					_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
					
					if (DetailsImageEdit and DetailsImageEdit:IsShown()) then
						local wp = instance.wallpaper
						if (wp.anchor == "all") then
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
						else
							g:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, instance.baseframe.wallpaper:GetWidth(), instance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
						end
					end
				end
				
				window:update_wallpaper_info()
				
			end
		
			local subMenu = {
				
				["DESIGN"] = {
					{value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]], label = "Horizontal Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]], texcoord = nil},
					{value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Highlight]], label = "Golden Highlight", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Highlight]], texcoord = {0.35, 0.655, 0.0390625, 0.859375}},
					{value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Stat-Buttons]], label = "Gray Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Stat-Buttons]], texcoord = {0, 1, 97/128, 1}},
					{value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Borders]], label = "Orange Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Borders]], texcoord = {160/512, 345/512, 80/256, 130/256}},
				},
				
				["ARCHEOLOGY"] = {
					{value = [[Interface\ARCHEOLOGY\Arch-BookCompletedLeft]], label = "Book Wallpaper", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-BookCompletedLeft]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-BookItemLeft]], label = "Book Wallpaper 2", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-BookItemLeft]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-DraeneiBIG]], label = "Draenei", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-DraeneiBIG]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-DwarfBIG]], label = "Dwarf", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-DwarfBIG]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-NightElfBIG]], label = "Night Elf", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-NightElfBIG]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-OrcBIG]], label = "Orc", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-OrcBIG]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-PandarenBIG]], label = "Pandaren", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-PandarenBIG]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-TrollBIG]], label = "Troll", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-TrollBIG]], texcoord = nil},

					{value = [[Interface\ARCHEOLOGY\ArchRare-AncientShamanHeaddress]], label = "Ancient Shaman", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-AncientShamanHeaddress]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-BabyPterrodax]], label = "Baby Pterrodax", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-BabyPterrodax]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-ChaliceMountainKings]], label = "Chalice Mountain Kings", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-ChaliceMountainKings]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-ClockworkGnome]], label = "Clockwork Gnomes", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-ClockworkGnome]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-QueenAzsharaGown]], label = "Queen Azshara Gown", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-QueenAzsharaGown]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-QuilinStatue]], label = "Quilin Statue", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-QuilinStatue]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-TempRareSketch]], label = "Rare Sketch", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-TempRareSketch]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-ScepterofAzAqir]], label = "Scepter of Az Aqir", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-ScepterofAzAqir]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-ShriveledMonkeyPaw]], label = "Shriveled Monkey Paw", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-ShriveledMonkeyPaw]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-StaffofAmmunrae]], label = "Staff of Ammunrae", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-StaffofAmmunrae]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-TinyDinosaurSkeleton]], label = "Tiny Dinosaur", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-TinyDinosaurSkeleton]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-TyrandesFavoriteDoll]], label = "Tyrandes Favorite Doll", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-TyrandesFavoriteDoll]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ArchRare-ZinRokhDestroyer]], label = "ZinRokh Destroyer", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ArchRare-ZinRokhDestroyer]], texcoord = nil},
				},
			
				["RAIDS"] = {
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-BlackrockCaverns]], label = "Blackrock Caverns", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-BlackrockCaverns]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-BlackrockSpire]], label = "Blackrock Spire", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-BlackrockSpire]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-DragonSoul]], label = "Dragon Soul", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-DragonSoul]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-EndTime]], label = "End Time", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-EndTime]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-Firelands1]], label = "Firelands", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-Firelands1]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-HallsofReflection]], label = "Halls of Reflection", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-HallsofReflection]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-HellfireCitadel]], label = "Hellfire Citadel", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-HellfireCitadel]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-Pandaria]], label = "Pandaria", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-Pandaria]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-RagefireChasm]], label = "Ragefire Chasm", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-RagefireChasm]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]], label = "Siege of Orgrimmar", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-SiegeofOrgrimmar]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheNexus]], label = "The Nexus", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheNexus]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheOculus]], label = "The Oculus", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheOculus]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheStonecore]], label = "The Stonecore", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-TheStonecore]], texcoord = nil},
					{value = [[Interface\EncounterJournal\UI-EJ-LOREBG-ThunderKingRaid]], label = "Throne of Thunder", onclick = onSelectSecTexture, icon = [[Interface\EncounterJournal\UI-EJ-LOREBG-ThunderKingRaid]], texcoord = nil},
				},
			
				["LOGOS"] = {
					{value = [[Interface\Timer\Alliance-Logo]], label = "For the Alliance", onclick = onSelectSecTexture, icon = [[Interface\Timer\Alliance-Logo]], texcoord = nil},
					{value = [[Interface\Timer\Horde-Logo]], label = "For the Horde", onclick = onSelectSecTexture, icon = [[Interface\Timer\Horde-Logo]], texcoord = nil},
					{value = [[Interface\Destiny\EndscreenImage]], label = "Pandaria Logo", onclick = onSelectSecTexture, icon = [[Interface\Destiny\EndscreenImage]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ARCH-RACE-ORC]], label = "Orc Crest", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ARCH-RACE-ORC]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ARCH-RACE-DWARF]], label = "Dwarf Crest", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ARCH-RACE-DWARF]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ARCH-RACE-NIGHTELF]], label = "Night Elf Crest", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ARCH-RACE-NIGHTELF]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\Arch-Race-Pandaren]], label = "Padaren Crest", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-Race-Pandaren]], texcoord = nil},
					{value = [[Interface\ARCHEOLOGY\ARCH-RACE-TROLL]], label = "Troll Crest", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\ARCH-RACE-TROLL]], texcoord = nil},
					{value = [[Interface\FlavorImages\BloodElfLogo-small]], label = "Blood Elf Crest", onclick = onSelectSecTexture, icon = [[Interface\FlavorImages\BloodElfLogo-small]], texcoord = nil},
					{value = [[Interface\Glues\COMMON\Glues-Logo]], label = "Wow Logo", onclick = onSelectSecTexture, icon = [[Interface\Glues\COMMON\Glues-Logo]], texcoord = nil},
					{value = [[Interface\Glues\COMMON\GLUES-WOW-BCLOGO]], label = "Burning Cruzade Logo", onclick = onSelectSecTexture, icon = [[Interface\Glues\COMMON\GLUES-WOW-BCLOGO]], texcoord = nil},
					{value = [[Interface\Glues\COMMON\GLUES-WOW-CCLOGO]], label = "Cataclysm Logo", onclick = onSelectSecTexture, icon = [[Interface\Glues\COMMON\GLUES-WOW-CCLOGO]], texcoord = nil},
					{value = [[Interface\Glues\COMMON\Glues-WOW-WoltkLogo]], label = "WotLK Logo", onclick = onSelectSecTexture, icon = [[Interface\Glues\COMMON\Glues-WOW-WoltkLogo]], texcoord = nil},
				},
				
				["CREDITS"] = {
					{value = [[Interface\Glues\CREDITS\Arakkoa2]], label = "Arakkoa", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Arakkoa2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Arcane_Golem2]], label = "Arcane Golem", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Arcane_Golem2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Badlands3]], label = "Badlands", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Badlands3]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\BD6]], label = "Draenei", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\BD6]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei_Character1]], label = "Draenei 2", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei_Character1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei_Character2]], label = "Draenei 3", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei_Character2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei_Crest2]], label = "Draenei Crest", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei_Crest2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei_Female2]], label = "Draenei 4", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei_Female2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei2]], label = "Draenei 5", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Blood_Elf_One1]], label = "Kael'thas", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Blood_Elf_One1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\BD2]], label = "Blood Elf", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\BD2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\BloodElf_Priestess_Master2]], label = "Blood elf 2", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\BloodElf_Priestess_Master2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Female_BloodElf2]], label = "Blood Elf 3", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Female_BloodElf2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\CinSnow01TGA3]], label = "Cin Snow", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\CinSnow01TGA3]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\DalaranDomeTGA3]], label = "Dalaran", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\DalaranDomeTGA3]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Darnasis5]], label = "Darnasus", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Darnasis5]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Draenei_CityInt5]], label = "Exodar", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Draenei_CityInt5]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Shattrath6]], label = "Shattrath", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Shattrath6]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Demon_Chamber2]], label = "Demon Chamber", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Demon_Chamber2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Demon_Chamber6]], label = "Demon Chamber 2", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Demon_Chamber6]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Dwarfhunter1]], label = "Dwarf Hunter", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Dwarfhunter1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Fellwood5]], label = "Fellwood", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Fellwood5]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\HordeBanner1]], label = "Horde Banner", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\HordeBanner1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Illidan_Concept1]], label = "Illidan", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Illidan_Concept1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Illidan1]], label = "Illidan 2", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Illidan1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Naaru_CrashSite2]], label = "Naaru Crash", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Naaru_CrashSite2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\NightElves1]], label = "Night Elves", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\NightElves1]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Ocean2]], label = "Mountain", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Ocean2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Tempest_Keep2]], label = "Tempest Keep", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Tempest_Keep2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Tempest_Keep6]], label = "Tempest Keep 2", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Tempest_Keep6]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Terrokkar6]], label = "Terrokkar", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Terrokkar6]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\ThousandNeedles2]], label = "Thousand Needles", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\ThousandNeedles2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\Troll2]], label = "Troll", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\Troll2]], texcoord = nil},
					{value = [[Interface\Glues\CREDITS\CATACLYSM\LESSERELEMENTAL_FIRE_03B1]], label = "Fire Elemental", onclick = onSelectSecTexture, icon = [[Interface\Glues\CREDITS\CATACLYSM\LESSERELEMENTAL_FIRE_03B1]], texcoord = nil},
				},
			
				["DEATHKNIGHT"] = {
					{value = [[Interface\TALENTFRAME\bg-deathknight-blood]], label = "Blood", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_BloodPresence]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-deathknight-frost]], label = "Frost", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_FrostPresence]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-deathknight-unholy]], label = "Unholy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_UnholyPresence]], texcoord = nil}
				},
				
				["DRESSUP"] = {
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-BloodElf1]], label = "Blood Elf", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.5, 0.625, 0.75, 1}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-DeathKnight1]], label = "Death Knight", onclick = onSelectSecTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["DEATHKNIGHT"]},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Draenei1]], label = "Draenei", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.5, 0.625, 0.5, 0.75}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Dwarf1]], label = "Dwarf", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.125, 0.25, 0, 0.25}},
					{value = [[Interface\DRESSUPFRAME\DRESSUPBACKGROUND-GNOME1]], label = "Gnome", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.25, 0.375, 0, 0.25}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Goblin1]], label = "Goblin", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.625, 0.75, 0.75, 1}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Human1]], label = "Human", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0, 0.125, 0.5, 0.75}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-NightElf1]], label = "Night Elf", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.375, 0.5, 0, 0.25}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Orc1]], label = "Orc", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.375, 0.5, 0.25, 0.5}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Pandaren1]], label = "Pandaren", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.75, 0.875, 0.5, 0.75}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Tauren1]], label = "Tauren", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0, 0.125, 0.25, 0.5}},
					{value = [[Interface\DRESSUPFRAME\DRESSUPBACKGROUND-TROLL1]], label = "Troll", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.25, 0.375, 0.75, 1}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Scourge1]], label = "Undead", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.125, 0.25, 0.75, 1}},
					{value = [[Interface\DRESSUPFRAME\DressUpBackground-Worgen1]], label = "Worgen", onclick = onSelectSecTexture, icon = [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-RACES]], texcoord = {0.625, 0.75, 0, 0.25}},
				},
				
				["DRUID"] = {
					{value = [[Interface\TALENTFRAME\bg-druid-bear]], label = "Guardian", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_racial_bearform]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-druid-restoration]], label = "Restoration", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_healingtouch]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-druid-cat]], label = "Feral", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_vampiricaura]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-druid-balance]], label = "Balance", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_starfall]], texcoord = nil}
				},
				
				["HUNTER"] = {
					{value = [[Interface\TALENTFRAME\bg-hunter-beastmaster]], label = "Beast Mastery", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_bestialdiscipline]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-hunter-marksman]], label = "Marksmanship", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_focusedaim]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-hunter-survival]], label = "Survival", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_camouflage]], texcoord = nil}
				},
				
				["MAGE"] = {
					{value = [[Interface\TALENTFRAME\bg-mage-arcane]], label = "Arcane", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_magicalsentry]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-mage-fire]], label = "Fire", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_fire_firebolt02]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-mage-frost]], label = "Frost", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_frost_frostbolt02]], texcoord = nil}
				},

				["MONK"] = {
					{value = [[Interface\TALENTFRAME\bg-monk-brewmaster]], label = "Brewmaster", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_drunkenox]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-monk-mistweaver]], label = "Mistweaver", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_wiseserpent]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-monk-battledancer]], label = "Windwalker", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_whitetiger]], texcoord = nil}
				},

				["PALADIN"] = {
					{value = [[Interface\TALENTFRAME\bg-paladin-holy]], label = "Holy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_holybolt]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-paladin-protection]], label = "Protection", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_paladin_shieldofthetemplar]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-paladin-retribution]], label = "Retribution", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_auraoflight]], texcoord = nil}
				},
				
				["PRIEST"] = {
					{value = [[Interface\TALENTFRAME\bg-priest-discipline]], label = "Discipline", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_powerwordshield]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-priest-holy]], label = "Holy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_guardianspirit]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-priest-shadow]], label = "Shadow", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_shadowwordpain]], texcoord = nil}
				},

				["ROGUE"] = {
					{value = [[Interface\TALENTFRAME\bg-rogue-assassination]], label = "Assassination", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_rogue_eviscerate]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-rogue-combat]], label = "Combat", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_backstab]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-rogue-subtlety]], label = "Subtlety", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_stealth]], texcoord = nil}
				},

				["SHAMAN"] = {
					{value = [[Interface\TALENTFRAME\bg-shaman-elemental]], label = "Elemental", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_lightning]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-shaman-enhancement]], label = "Enhancement", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_lightningshield]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-shaman-restoration]], label = "Restoration", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_magicimmunity]], texcoord = nil}	
				},
				
				["WARLOCK"] = {
					{value = [[Interface\TALENTFRAME\bg-warlock-affliction]], label = "Affliction", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_deathcoil]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-warlock-demonology]], label = "Demonology", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_metamorphosis]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-warlock-destruction]], label = "Destruction", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_rainoffire]], texcoord = nil}
				},
				["WARRIOR"] = {
					{value = [[Interface\TALENTFRAME\bg-warrior-arms]], label = "Arms", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_savageblow]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-warrior-fury]], label = "Fury", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_innerrage]], texcoord = nil},
					{value = [[Interface\TALENTFRAME\bg-warrior-protection]], label = "Protection", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_defensivestance]], texcoord = nil}
				},
			}
			
			window.WallpaperTextureOptions = subMenu
		
			local buildBackgroundMenu2 = function() 
				return  subMenu [frame9.backgroundDropdown.value] or {label = "", value = 0}
			end
		
			local onSelectMainTexture = function (_, instance, choose)
				frame9.backgroundDropdown2:Select (choose)
				window:update_wallpaper_info()
			end
		
			local backgroundTable = {
				{value = "DESIGN", label = "Design", onclick = onSelectMainTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]]},
				{value = "ARCHEOLOGY", label = "Archeology", onclick = onSelectMainTexture, icon = [[Interface\ARCHEOLOGY\Arch-Icon-Marker]]},
				{value = "CREDITS", label = "Burning Crusade", onclick = onSelectMainTexture, icon = [[Interface\ICONS\TEMP]]},
				{value = "LOGOS", label = "Logos", onclick = onSelectMainTexture, icon = [[Interface\WorldStateFrame\ColumnIcon-FlagCapture0]]},
				{value = "DRESSUP", label = "Race Background", onclick = onSelectMainTexture, icon = [[Interface\ICONS\INV_Chest_Cloth_17]]},
				{value = "RAIDS", label = "Dungeons & Raids", onclick = onSelectMainTexture, icon = [[Interface\COMMON\friendship-FistHuman]]},
				{value = "DEATHKNIGHT", label = "Death Knight", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["DEATHKNIGHT"]},
				{value = "DRUID", label = "Druid", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["DRUID"]},
				{value = "HUNTER", label = "Hunter", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["HUNTER"]},
				{value = "MAGE", label = "Mage", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["MAGE"]},
				{value = "MONK", label = "Monk", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["MONK"]},
				{value = "PALADIN", label = "Paladin", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["PALADIN"]},
				{value = "PRIEST", label = "Priest", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["PRIEST"]},
				{value = "ROGUE", label = "Rogue", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["ROGUE"]},
				{value = "SHAMAN", label = "Shaman", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["SHAMAN"]},
				{value = "WARLOCK", label = "Warlock", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["WARLOCK"]},
				{value = "WARRIOR", label = "Warrior", onclick = onSelectMainTexture, icon = _detalhes.class_icons_small, texcoord = _detalhes.class_coords ["WARRIOR"]},
			}
			local buildBackgroundMenu = function() return backgroundTable end		
			
			g:NewSwitch (frame9, _, "$parentUseBackgroundSlider", "useBackgroundSlider", 60, 20, _, _, _G.DetailsOptionsWindow.instance.wallpaper.enabled, nil, nil, nil, nil, options_switch_template)
			
			--category
			local d = g:NewDropDown (frame9, _, "$parentBackgroundDropdown", "backgroundDropdown", DROPDOWN_WIDTH, dropdown_height, buildBackgroundMenu, nil, options_dropdown_template)

			--wallpaper
			local d = g:NewDropDown (frame9, _, "$parentBackgroundDropdown2", "backgroundDropdown2", DROPDOWN_WIDTH, dropdown_height, buildBackgroundMenu2, nil, options_dropdown_template)

	-- Wallpaper Settings	

		-- wallpaper

		g:NewLabel (frame9, _, "$parentBackgroundLabel", "enablewallpaperLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		--
		frame9.useBackgroundSlider:SetPoint ("left", frame9.enablewallpaperLabel, "right", 2, 0) --> slider ativar ou desativar
		frame9.useBackgroundSlider:SetAsCheckBox()
		frame9.useBackgroundSlider.OnSwitch = function (self, instance, value)
			instance.wallpaper.enabled = value
			if (value) then
				--> primeira vez que roda:
				if (not instance.wallpaper.texture) then
					instance.wallpaper.texture = "Interface\\AddOns\\Details\\images\\background"
				end
				
				instance:InstanceWallpaper (true)
				
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceWallpaper (true)
						end
					end
				end
				
			else
				instance:InstanceWallpaper (false)
				if (_detalhes.options_group_edit and not DetailsOptionsWindow.loading_settings) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceWallpaper (false)
						end
					end
				end
			end
			
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
			
			window:update_wallpaper_info()
			
		end
		
		g:NewLabel (frame9, _, "$parentBackgroundLabel1", "wallpapergroupLabel", Loc ["STRING_OPTIONS_WP_GROUP"], "GameFontHighlightLeft")
		g:NewLabel (frame9, _, "$parentBackgroundLabel2", "selectwallpaperLabel", Loc ["STRING_OPTIONS_WP_GROUP2"], "GameFontHighlightLeft")
		g:NewLabel (frame9, _, "$parentAnchorLabel", "anchorLabel", Loc ["STRING_OPTIONS_WP_ALIGN"], "GameFontHighlightLeft")
		--
		frame9.anchorDropdown:SetPoint ("left", frame9.anchorLabel, "right", 2)
		--
		--frame9.editImage:InstallCustomTexture (nil, nil, nil, nil, nil, true)
		window:CreateLineBackground2 (frame9, "editImage", "editImage", Loc ["STRING_OPTIONS_WP_EDIT_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		frame9.editImage:SetTextColor (button_color_rgb)
		frame9.editImage:SetIcon ([[Interface\AddOns\Details\images\icons]], 14, 14, nil, {469/512, 505/512, 290/512, 322/512}, nil, 4, 2)

		window:CreateLineBackground2 (frame9, "useBackgroundSlider", "enablewallpaperLabel", Loc ["STRING_OPTIONS_WP_ENABLE_DESC"])
		
		window:CreateLineBackground2 (frame9, "anchorDropdown", "anchorLabel", Loc ["STRING_OPTIONS_WP_ALIGN_DESC"])

		window:CreateLineBackground2 (frame9, "backgroundDropdown", "wallpapergroupLabel", Loc ["STRING_OPTIONS_WP_GROUP_DESC"])
		
		window:CreateLineBackground2 (frame9, "backgroundDropdown2", "selectwallpaperLabel", Loc ["STRING_OPTIONS_WP_GROUP2_DESC"])

		g:NewLabel (frame9, _, "$parentWallpaperPreviewAnchor", "wallpaperPreviewAnchorLabel", "Preview:", "GameFontNormal")
		
		--128 64
		
		local icon1 = g:NewImage (frame9, nil, 128, 64, "artwork", nil, nil, "$parentIcon1")
		icon1:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		icon1:SetPoint ("topleft", frame9.wallpaperPreviewAnchorLabel.widget, "bottomleft", 0, -5)
		icon1:SetDrawLayer ("artwork", 1)
		icon1:SetTexCoord (0.337890625, 0.5859375, 0.59375, 0.716796875-0.0009765625) --173 304 300 367
		
		local icon2 = g:NewImage (frame9, nil, 128, 64, "artwork", nil, nil, "$parentIcon2")
		icon2:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		icon2:SetPoint ("left", icon1.widget, "right")
		icon2:SetDrawLayer ("artwork", 1)
		icon2:SetTexCoord (0.337890625, 0.5859375, 0.59375, 0.716796875-0.0009765625) --173 304 300 367
		
		local icon3 = g:NewImage (frame9, nil, 128, 64, "artwork", nil, nil, "$parentIcon3")
		icon3:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		icon3:SetPoint ("top", icon1.widget, "bottom")
		icon3:SetDrawLayer ("artwork", 1)
		icon3:SetTexCoord (0.337890625, 0.5859375, 0.59375+0.0009765625, 0.716796875) --173 304 300 367
		
		local icon4 = g:NewImage (frame9, nil, 128, 64, "artwork", nil, nil, "$parentIcon4")
		icon4:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		icon4:SetPoint ("left", icon3.widget, "right")
		icon4:SetDrawLayer ("artwork", 1)
		icon4:SetTexCoord (0.337890625, 0.5859375, 0.59375+0.0009765625, 0.716796875) --173 304 300 367
		
		icon1:SetVertexColor (.15, .15, .15, 1)
		icon2:SetVertexColor (.15, .15, .15, 1)
		icon3:SetVertexColor (.15, .15, .15, 1)
		icon4:SetVertexColor (.15, .15, .15, 1)
		
		local preview = frame9:CreateTexture (nil, "overlay")
		preview:SetDrawLayer ("artwork", 3)
		preview:SetSize (256, 128)
		preview:SetPoint ("topleft", frame9.wallpaperPreviewAnchorLabel.widget, "bottomleft", 0, -5)
		
		local w, h = 20, 20
		
		local L1 = frame9:CreateTexture (nil, "overlay")
		L1:SetPoint ("topleft", preview, "topleft")
		L1:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		L1:SetTexCoord (0.13671875+0.0009765625, 0.234375, 0.29296875, 0.1953125+0.0009765625)
		L1:SetSize (w, h)
		L1:SetDrawLayer ("overlay", 2)
		L1:SetVertexColor (1, 1, 1, .8)
		
		local L2 = frame9:CreateTexture (nil, "overlay")
		L2:SetPoint ("bottomleft", preview, "bottomleft")
		L2:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		L2:SetTexCoord (0.13671875+0.0009765625, 0.234375, 0.1953125+0.0009765625, 0.29296875)
		L2:SetSize (w, h)
		L2:SetDrawLayer ("overlay", 2)
		L2:SetVertexColor (1, 1, 1, .8)
		
		local L3 = frame9:CreateTexture (nil, "overlay")
		L3:SetPoint ("bottomright", preview, "bottomright", 0, 0)
		L3:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		L3:SetTexCoord (0.234375, 0.13671875-0.0009765625, 0.1953125+0.0009765625, 0.29296875)
		L3:SetSize (w, h)
		L3:SetDrawLayer ("overlay", 5)
		L3:SetVertexColor (1, 1, 1, .8)
		
		local L4 = frame9:CreateTexture (nil, "overlay")
		L4:SetPoint ("topright", preview, "topright", 0, 0)
		L4:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
		L4:SetTexCoord (0.234375, 0.13671875-0.0009765625, 0.29296875, 0.1953125+0.0009765625)
		L4:SetSize (w, h)
		L4:SetDrawLayer ("overlay", 5)
		L4:SetVertexColor (1, 1, 1, .8)
		
		function window:update_wallpaper_info()
			local w = _G.DetailsOptionsWindow.instance.wallpaper
			
			local a = w.alpha or 0
			a = a * 100
			a = string.format ("%.1f", a) .. "%"

			local t = w.texcoord [3] or 0
			t = t * 100
			t = string.format ("%.3f", t) .. "%"
			
			local b = w.texcoord [4] or 1
			b = b * 100
			b = string.format ("%.3f", b) .. "%"
			
			local l = w.texcoord [1] or 0
			l = l * 100
			l = string.format ("%.3f", l) .. "%"
			
			local r = w.texcoord [2] or 1
			r = r * 100
			r = string.format ("%.3f", r) .. "%"
			
			local red = w.overlay[1] or 0
			red = math.ceil (red * 255)
			local green = w.overlay[2] or "0"
			green = math.ceil (green * 255)
			local blue = w.overlay[3] or "0"
			blue = math.ceil (blue * 255)
			
			preview:SetTexture (w.texture)
			preview:SetTexCoord (unpack (w.texcoord))
			preview:SetVertexColor (unpack (w.overlay))
			preview:SetAlpha (w.alpha)

			frame9.wallpaperCurrentLabel1text.text = w.texture or ""
			frame9.wallpaperCurrentLabel2text.text = a
			frame9.wallpaperCurrentLabel3text.text = red
			frame9.wallpaperCurrentLabel4text.text = green
			frame9.wallpaperCurrentLabel5text.text = blue
			frame9.wallpaperCurrentLabel6text.text = t
			frame9.wallpaperCurrentLabel7text.text = b
			frame9.wallpaperCurrentLabel8text.text = l
			frame9.wallpaperCurrentLabel9text.text = r
		end
		
	--current settings
		g:NewLabel (frame9, _, "$parentWallpaperCurrentAnchor", "wallpaperCurrentAnchorLabel", "Current:", "GameFontNormal")
		
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel1", "wallpaperCurrentLabel1", Loc ["STRING_OPTIONS_WALLPAPER_FILE"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel2", "wallpaperCurrentLabel2", Loc ["STRING_OPTIONS_WALLPAPER_ALPHA"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel3", "wallpaperCurrentLabel3", Loc ["STRING_OPTIONS_WALLPAPER_RED"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel4", "wallpaperCurrentLabel4", Loc ["STRING_OPTIONS_WALLPAPER_GREEN"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel5", "wallpaperCurrentLabel5", Loc ["STRING_OPTIONS_WALLPAPER_BLUE"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel6", "wallpaperCurrentLabel6", Loc ["STRING_OPTIONS_WALLPAPER_CTOP"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel7", "wallpaperCurrentLabel7", Loc ["STRING_OPTIONS_WALLPAPER_CBOTTOM"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel8", "wallpaperCurrentLabel8", Loc ["STRING_OPTIONS_WALLPAPER_CLEFT"], "GameFontHighlightSmall")
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel9", "wallpaperCurrentLabel9", Loc ["STRING_OPTIONS_WALLPAPER_CRIGHT"], "GameFontHighlightSmall")
		
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel1text", "wallpaperCurrentLabel1text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel1text:SetPoint ("left", frame9.wallpaperCurrentLabel1, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel2text", "wallpaperCurrentLabel2text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel2text:SetPoint ("left", frame9.wallpaperCurrentLabel2, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel3text", "wallpaperCurrentLabel3text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel3text:SetPoint ("left", frame9.wallpaperCurrentLabel3, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel4text", "wallpaperCurrentLabel4text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel4text:SetPoint ("left", frame9.wallpaperCurrentLabel4, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel5text", "wallpaperCurrentLabel5text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel5text:SetPoint ("left", frame9.wallpaperCurrentLabel5, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel6text", "wallpaperCurrentLabel6text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel6text:SetPoint ("left", frame9.wallpaperCurrentLabel6, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel7text", "wallpaperCurrentLabel7text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel7text:SetPoint ("left", frame9.wallpaperCurrentLabel7, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel8text", "wallpaperCurrentLabel8text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel8text:SetPoint ("left", frame9.wallpaperCurrentLabel8, "right", 2, 0)
		g:NewLabel (frame9, _, "$parentWallpaperCurrentLabel9text", "wallpaperCurrentLabel9text", "", "GameFontHighlightSmall")
		frame9.wallpaperCurrentLabel9text:SetPoint ("left", frame9.wallpaperCurrentLabel9, "right", 2, 0)
	
	--> Load Wallpaper
	
		g:NewLabel (frame9, _, "$parentWallpaperLoadTitleAnchor", "WallpaperLoadTitleAnchor", Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TITLE"], "GameFontNormal")
	
		local load_image = function()
			if (not DetailsLoadWallpaperImage) then
				
				local f = CreateFrame ("frame", "DetailsLoadWallpaperImage", UIParent)
				f:SetPoint ("center", UIParent, "center")
				f:SetFrameStrata ("FULLSCREEN")
				f:SetSize (512, 150)
				f:EnableMouse (true)
				f:SetMovable (true)
				f:SetScript ("OnMouseDown", function(self, button)
					if (self.isMoving) then
						return
					end
					if (button == "RightButton") then
						self:Hide()
					else
						self:StartMoving() 
						self.isMoving = true
					end
				end)
				f:SetScript ("OnMouseUp", function(self, button) 
					if (self.isMoving and button == "LeftButton") then
						self:StopMovingOrSizing()
						self.isMoving = nil
					end
				end)
				
				f:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 128, insets = {left=3, right=3, top=3, bottom=3},
				edgeFile = [[Interface\AddOns\Details\images\border_welcome]], edgeSize = 16})
				f:SetBackdropColor (1, 1, 1, 0.75)
				
				tinsert (UISpecialFrames, "DetailsLoadWallpaperImage")
				
				local t = f:CreateFontString (nil, "overlay", "GameFontNormal")
				t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
				t:SetPoint ("topleft", f, "topleft", 15, -15)
				t:SetJustifyH ("left")
				f.t = t
				
				local filename = f:CreateFontString (nil, "overlay", "GameFontHighlightLeft")
				filename:SetPoint ("topleft", f, "topleft", 15, -120)
				filename:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME"])
				
				local editbox = g:NewTextEntry (f, nil, "$parentFileName", "FileName", 160, TEXTENTRY_HEIGHT, function() end, nil, nil, nil, nil, options_dropdown_template)
				editbox:SetPoint ("left", filename, "right", 2, 0)
				editbox.tooltip = Loc ["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME_DESC"]
				
				local close = CreateFrame ("button", "DetailsLoadWallpaperImageOkey", f, "UIPanelCloseButton")
				close:SetSize (32, 32)
				close:SetPoint ("topright", f, "topright", -3, -1)

				local okey_func = function() 
					local text = editbox:GetText()
					if (text == "") then
						return
					end
					
					local instance = _G.DetailsOptionsWindow.instance
					local path = "Interface\\" .. text
					editbox:ClearFocus()
					instance:InstanceWallpaper (path, "all", 0.50, {0, 1, 0, 1}, 256, 256, {1, 1, 1, 1})
					_detalhes:OpenOptionsWindow (instance)
					window:update_wallpaper_info()
				end
				local okey = g:NewButton (f, _, "$parentOkeyButton", nil, 105, 20, okey_func, nil, nil, nil, Loc ["STRING_OPTIONS_WALLPAPER_LOAD_OKEY"], 1, options_button_template)
				okey:SetPoint ("left", editbox.widget, "right", 2, 0)
				--okey:InstallCustomTexture()
				
				local throubleshoot_func = function() 
					if (t:GetText() == Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"]) then
						t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT_TEXT"])
					else
						DetailsLoadWallpaperImage.t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
					end
				end
				local throubleshoot = g:NewButton (f, _, "$parentThroubleshootButton", nil, 105, 20, throubleshoot_func, nil, nil, nil, Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT"], 1, options_button_template)
				throubleshoot:SetPoint ("left", okey, "right", 2, 0)
				--throubleshoot:InstallCustomTexture()
			end
			
			DetailsLoadWallpaperImage.t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
			DetailsLoadWallpaperImage:Show()
		end
		
		g:NewButton (frame9, _, "$parentLoadImage", "LoadImage", window.buttons_width, 18, load_image, nil, nil, nil, Loc ["STRING_OPTIONS_WALLPAPER_LOAD"], nil, options_button_template)
		--frame9.LoadImage:InstallCustomTexture (nil, nil, nil, nil, nil, true)
		window:CreateLineBackground2 (frame9, "LoadImage", "LoadImage", Loc ["STRING_OPTIONS_WALLPAPER_LOAD_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		frame9.LoadImage:SetTextColor (button_color_rgb)
		frame9.LoadImage:SetIcon ([[Interface\AddOns\Details\images\icons]], 10, 13, nil, {437/512, 467/512, 191/512, 239/512}, nil, 5, 3)
		
	--> Anchors
	
--		/script local f=CreateFrame("frame",nil,UIParent);f:SetSize(256,256);local t=f:CreateTexture(nil,"overlay");t:SetAllPoints();t:SetTexture([[Interface\wallpaper]]);f:SetPoint("center",UIParent,"center")
	
		frame9.backgroundDropdown:SetPoint ("left", frame9.wallpapergroupLabel, "right", 2, 0)
		frame9.backgroundDropdown2:SetPoint ("left", frame9.selectwallpaperLabel, "right", 2, 0)
		
		--general anchor
		g:NewLabel (frame9, _, "$parentWallpaperAnchor", "WallpaperAnchorLabel", Loc ["STRING_OPTIONS_WALLPAPER_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_wallpaper:SetPoint (x, window.title_y_pos)
		titulo_wallpaper_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"WallpaperAnchorLabel", 1, true},
			{"enablewallpaperLabel", 2},
			{"wallpapergroupLabel", 3},
			{"selectwallpaperLabel", 4},
			{"anchorLabel", 5},
			{"editImage", 6},
			--{"wallpaperCurrentAnchorLabel", 7, true},
			--{"wallpaperCurrentAnchorLabel"}, --invisible space
			{"WallpaperLoadTitleAnchor", 1, true},
			{"LoadImage", 2},
		}
		
		local downY = -5
		frame9.wallpaperCurrentLabel1:SetPoint ("topleft", frame9.wallpaperCurrentAnchorLabel, "bottomleft", 0, -10)
		frame9.wallpaperCurrentLabel2:SetPoint ("topleft", frame9.wallpaperCurrentLabel1, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel3:SetPoint ("topleft", frame9.wallpaperCurrentLabel2, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel4:SetPoint ("topleft", frame9.wallpaperCurrentLabel3, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel5:SetPoint ("topleft", frame9.wallpaperCurrentLabel4, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel6:SetPoint ("topleft", frame9.wallpaperCurrentLabel5, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel7:SetPoint ("topleft", frame9.wallpaperCurrentLabel6, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel8:SetPoint ("topleft", frame9.wallpaperCurrentLabel7, "bottomleft", 0, downY)
		frame9.wallpaperCurrentLabel9:SetPoint ("topleft", frame9.wallpaperCurrentLabel8, "bottomleft", 0, downY)
		
		--hide current
		frame9.wallpaperCurrentAnchorLabel:Hide()
		frame9.wallpaperCurrentLabel1:Hide()
		frame9.wallpaperCurrentLabel2:Hide()
		frame9.wallpaperCurrentLabel3:Hide()
		frame9.wallpaperCurrentLabel4:Hide()
		frame9.wallpaperCurrentLabel5:Hide()
		frame9.wallpaperCurrentLabel6:Hide()
		frame9.wallpaperCurrentLabel7:Hide()
		frame9.wallpaperCurrentLabel8:Hide()
		frame9.wallpaperCurrentLabel9:Hide()
		frame9.wallpaperCurrentLabel1text:Hide()
		frame9.wallpaperCurrentLabel2text:Hide()
		frame9.wallpaperCurrentLabel3text:Hide()
		frame9.wallpaperCurrentLabel4text:Hide()
		frame9.wallpaperCurrentLabel5text:Hide()
		frame9.wallpaperCurrentLabel6text:Hide()
		frame9.wallpaperCurrentLabel7text:Hide()
		frame9.wallpaperCurrentLabel8text:Hide()
		frame9.wallpaperCurrentLabel9text:Hide()
		
		
		window:arrange_menu (frame9, left_side, x, window.top_start_at)
		
		local right_side = {
			{"wallpaperPreviewAnchorLabel", 1, true},
		}
		window:arrange_menu (frame9, right_side, window.right_start_at, window.top_start_at)
	
		local right_side2 = {

		}
		window:arrange_menu (frame9, right_side2, window.right_start_at, -250)
		
	--> wallpaper settings

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Performance - Tweaks ~10
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function window:CreateFrame10()

		local frame10 = window.options [10][1]
		local frame11 = window.options [11][1]
		
		local titulo_performance_general = g:NewLabel (frame10, _, "$parentTituloPerformance1", "tituloPerformance1Label", Loc ["STRING_OPTIONS_PERFORMANCE1"], "GameFontNormal", 16)
		local titulo_performance_general_desc = g:NewLabel (frame10, _, "$parentTituloPersona2", "tituloPersona2Label", Loc ["STRING_OPTIONS_PERFORMANCE1_DESC"], "GameFontNormal", 10, "white")
		titulo_performance_general_desc.width = 320
		
	--------------- Max Segments Saved
		g:NewLabel (frame10, _, "$parentLabelSegmentsSave", "segmentsSaveLabel", Loc ["STRING_OPTIONS_SEGMENTSSAVE"], "GameFontHighlightLeft")
		--
		local s = g:NewSlider (frame10, _, "$parentSliderSegmentsSave", "segmentsSliderToSave", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 25, 1, _detalhes.segments_amount_to_save, nil, nil, nil, options_slider_template)
		--config_slider (s)
		--
		frame10.segmentsSliderToSave:SetPoint ("left", frame10.segmentsSaveLabel, "right", 2, 0)
		frame10.segmentsSliderToSave:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.segments_amount_to_save = math.floor (amount)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame10, "segmentsSliderToSave", "segmentsSaveLabel", Loc ["STRING_OPTIONS_SEGMENTSSAVE_DESC"])
	
	--------------- Panic Mode
		g:NewLabel (frame10, _, "$parentPanicModeLabel", "panicModeLabel", Loc ["STRING_OPTIONS_PANIMODE"], "GameFontHighlightLeft")
		--
		g:NewSwitch (frame10, _, "$parentPanicModeSlider", "panicModeSlider", 60, 20, _, _, _detalhes.segments_panic_mode, nil, nil, nil, nil, options_switch_template)
		frame10.panicModeSlider:SetPoint ("left", frame10.panicModeLabel, "right", 2, 0)
		frame10.panicModeSlider:SetAsCheckBox()
		frame10.panicModeSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue
			_detalhes.segments_panic_mode = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame10, "panicModeSlider", "panicModeLabel", Loc ["STRING_OPTIONS_PANIMODE_DESC"])
		
	--------------- Animate scroll bar
		g:NewLabel (frame10, _, "$parentAnimateScrollLabel", "animatescrollLabel", Loc ["STRING_OPTIONS_ANIMATESCROLL"], "GameFontHighlightLeft")
		
		--
		g:NewSwitch (frame10, _, "$parentClearAnimateScrollSlider", "animatescrollSlider", 60, 20, _, _, _detalhes.animate_scroll, nil, nil, nil, nil, options_switch_template) -- ltext, rtext, defaultv
		frame10.animatescrollSlider:SetPoint ("left", frame10.animatescrollLabel, "right", 2, 0)
		frame10.animatescrollSlider:SetAsCheckBox()
		frame10.animatescrollSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue
			_detalhes.animate_scroll = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame10, "animatescrollSlider", "animatescrollLabel", Loc ["STRING_OPTIONS_ANIMATESCROLL_DESC"])
	
	--------------- Erase Trash
		g:NewLabel (frame10, _, "$parentEraseTrash", "eraseTrashLabel", Loc ["STRING_OPTIONS_CLEANUP"], "GameFontHighlightLeft")
		

		--
		g:NewSwitch (frame10, _, "$parentRemoveTrashSlider", "removeTrashSlider", 60, 20, _, _, _detalhes.trash_auto_remove, nil, nil, nil, nil, options_switch_template)
		frame10.removeTrashSlider:SetPoint ("left", frame10.eraseTrashLabel, "right")
		frame10.removeTrashSlider:SetAsCheckBox()
		frame10.removeTrashSlider.OnSwitch = function (self, _, amount)
			_detalhes.trash_auto_remove = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame10, "removeTrashSlider", "eraseTrashLabel", Loc ["STRING_OPTIONS_CLEANUP_DESC"])

	--------------- Consider World as Trash
		g:NewLabel (frame10, _, "$parentWorldAsTrash", "WorldAsTrashLabel", Loc ["STRING_OPTIONS_PERFORMANCE_ERASEWORLD"], "GameFontHighlightLeft")
		
		--
		g:NewSwitch (frame10, _, "$parentWorldAsTrashSlider", "WorldAsTrashSlider", 60, 20, _, _, _detalhes.world_combat_is_trash, nil, nil, nil, nil, options_switch_template)
		frame10.WorldAsTrashSlider:SetPoint ("left", frame10.WorldAsTrashLabel, "right")
		frame10.WorldAsTrashSlider:SetAsCheckBox()
		frame10.WorldAsTrashSlider.OnSwitch = function (self, _, amount)
			_detalhes.world_combat_is_trash = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame10, "WorldAsTrashSlider", "WorldAsTrashLabel", Loc ["STRING_OPTIONS_PERFORMANCE_ERASEWORLD_DESC"])
		
	--> performance profiles
	
		--enabled func
		local function unlock_profile (settings)
			frame10.animateSlider:Enable()
			frame10.animateLabel:SetTextColor (1, 1, 1, 1)
			frame10.animateSlider:SetValue (settings.use_row_animations)
			
			frame10.updatespeedSlider:Enable()
			frame10.updatespeedLabel:SetTextColor (1, 1, 1, 1)
			frame10.updatespeedSlider:SetValue (settings.update_speed)
			
			frame10.damageCaptureSlider:Enable()
			frame10.damageCaptureSlider:SetValue (settings.damage)
			
			frame10.healCaptureSlider:Enable()
			frame10.healCaptureSlider:SetValue (settings.heal)
			
			frame10.energyCaptureSlider:Enable()
			frame10.energyCaptureSlider:SetValue (settings.energy)
			
			frame10.miscCaptureSlider:Enable()
			frame10.miscCaptureSlider:SetValue (settings.miscdata)
			
			frame10.auraCaptureSlider:Enable()
			frame10.auraCaptureSlider:SetValue (settings.aura)

			frame10.damageCaptureLabel:SetTextColor (1, 1, 1, 1)
			frame10.healCaptureLabel:SetTextColor (1, 1, 1, 1)
			frame10.energyCaptureLabel:SetTextColor (1, 1, 1, 1)
			frame10.miscCaptureLabel:SetTextColor (1, 1, 1, 1)
			frame10.auraCaptureLabel:SetTextColor (1, 1, 1, 1)
		end
		
		--disable func
		local function lock_profile()
			frame10.animateSlider:Disable()
			frame10.animateLabel:SetTextColor (.4, .4, .4, 1)
			
			frame10.updatespeedSlider:Disable()
			frame10.updatespeedLabel:SetTextColor (.4, .4, .4, 1)
			
			frame10.damageCaptureSlider:Disable()
			frame10.healCaptureSlider:Disable()
			frame10.energyCaptureSlider:Disable()
			frame10.miscCaptureSlider:Disable()
			frame10.auraCaptureSlider:Disable()
			
			frame10.damageCaptureLabel:SetTextColor (.4, .4, .4, 1)
			frame10.healCaptureLabel:SetTextColor (.4, .4, .4, 1)
			frame10.energyCaptureLabel:SetTextColor (.4, .4, .4, 1)
			frame10.miscCaptureLabel:SetTextColor (.4, .4, .4, 1)
			frame10.auraCaptureLabel:SetTextColor (.4, .4, .4, 1)
		end
	
		local editing = nil
		local modify_setting = function (config, value)
			
		end
	
		g:NewLabel (frame10, _, "$parentPerformanceProfilesAnchor", "PerformanceProfilesAnchorLabel", Loc ["STRING_OPTIONS_PERFORMANCEPROFILES_ANCHOR"], "GameFontNormal")
		
		--type dropdown
		g:NewLabel (frame10, _, "$parentProfileTypeLabel", "ProfileTypeLabel", Loc ["STRING_OPTIONS_PERFORMANCE_TYPES"], "GameFontHighlightLeft")
		local OnSelectProfileType = function (_, _, selected)
			--enable enable button
			frame10.ProfileTypeEnabledSlider:Enable()
			frame10.ProfileTypeEnabledLabel:SetTextColor (1, 1, 1, 1)
			
			editing = _detalhes.performance_profiles [selected]
			
			if (editing.enabled) then
				frame10.ProfileTypeEnabledSlider:SetValue (true)
				unlock_profile (editing)
			else
				frame10.ProfileTypeEnabledSlider:SetValue (false)
				lock_profile()
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local PerformanceProfileOptions = {
			{value = "RaidFinder", label = Loc ["STRING_OPTIONS_PERFORMANCE_RF"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank15]], texcoord = {0, 1, 0, 1}},
			{value = "Raid15", label = Loc ["STRING_OPTIONS_PERFORMANCE_RAID15"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank15]], iconcolor = {1, .8, 0, 1}, texcoord = {0, 1, 0, 1}},
			{value = "Raid30", label = Loc ["STRING_OPTIONS_PERFORMANCE_RAID30"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank15]], iconcolor = {1, .8, 0, 1}, texcoord = {0, 1, 0, 1}},
			{value = "Mythic", label = Loc ["STRING_OPTIONS_PERFORMANCE_MYTHIC"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank15]], iconcolor = {1, .4, 0, 1}, texcoord = {0, 1, 0, 1}},
			{value = "Battleground15", label = Loc ["STRING_OPTIONS_PERFORMANCE_BG15"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank07]], texcoord = {0, 1, 0, 1}},
			{value = "Battleground40", label = Loc ["STRING_OPTIONS_PERFORMANCE_BG40"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank07]], texcoord = {0, 1, 0, 1}},
			{value = "Arena", label = Loc ["STRING_OPTIONS_PERFORMANCE_ARENA"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank12]], texcoord = {0, 1, 0, 1}},
			{value = "Dungeon", label = Loc ["STRING_OPTIONS_PERFORMANCE_DUNGEON"], onclick = OnSelectProfileType, icon = [[Interface\PvPRankBadges\PvPRank01]], texcoord = {0, 1, 0, 1}},
		}
		
		local BuildPerformanceProfileMenu = function()
			return PerformanceProfileOptions
		end
		
		local d = g:NewDropDown (frame10, _, "$parentProfileTypeDropdown", "ProfileTypeDropdown", 160, dropdown_height, BuildPerformanceProfileMenu, 0, options_dropdown_template)

		
		frame10.ProfileTypeDropdown:SetPoint ("left", frame10.ProfileTypeLabel, "right", 2)
		
		window:CreateLineBackground2 (frame10, "ProfileTypeDropdown", "ProfileTypeLabel", Loc ["STRING_OPTIONS_PERFORMANCE_TYPES_DESC"])

		--enabled slider
		g:NewLabel (frame10, _, "$parenttProfileTypeEnabledLabel", "ProfileTypeEnabledLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame10, _, "$parentProfileTypeEnabledSlider", "ProfileTypeEnabledSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.ProfileTypeEnabledSlider:SetPoint ("left", frame10.ProfileTypeEnabledLabel, "right", 2)
		frame10.ProfileTypeEnabledSlider:SetAsCheckBox()
		frame10.ProfileTypeEnabledSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.enabled = value
				if (value) then
					unlock_profile (editing)
				else
					lock_profile()
				end
			end
		end
		
		frame10.ProfileTypeEnabledSlider:Disable()
		frame10.ProfileTypeEnabledLabel:SetTextColor (.4, .4, .4, 1)		
		
		--window:CreateLineBackground2 (frame10, "ProfileTypeEnabledSlider", "ProfileTypeEnabledLabel", Loc ["STRING_OPTIONS_PERFORMANCE_ENABLE_DESC"])
		
		--animate bars
		g:NewLabel (frame10, _, "$parentAnimateLabel", "animateLabel", Loc ["STRING_OPTIONS_ANIMATEBARS"], "GameFontHighlightLeft")

		g:NewSwitch (frame10, _, "$parentAnimateSlider", "animateSlider", 60, 20, _, _, _detalhes.use_row_animations, nil, nil, nil, nil, options_switch_template)
		frame10.animateSlider:SetPoint ("left",frame10.animateLabel, "right", 2, 0)
		frame10.animateSlider:SetAsCheckBox()
		frame10.animateSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
			if (editing)  then
				editing.use_row_animations = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "animateSlider", "animateLabel", Loc ["STRING_OPTIONS_ANIMATEBARS_DESC"])
		
		--update speed
		local s = g:NewSlider (frame10, _, "$parentSliderUpdateSpeed", "updatespeedSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 0.05, 3, 0.05, _detalhes.update_speed, true, nil, nil, options_slider_template)
		--config_slider (s)
		
		g:NewLabel (frame10, _, "$parentUpdateSpeedLabel", "updatespeedLabel", Loc ["STRING_OPTIONS_WINDOWSPEED"], "GameFontHighlightLeft")
		--
		frame10.updatespeedSlider:SetPoint ("left", frame10.updatespeedLabel, "right", 2, -1)
		frame10.updatespeedSlider:SetThumbSize (50)
		frame10.updatespeedSlider.useDecimals = true
		local updateColor = function (slider, value)
			if (value < 1) then
				slider.amt:SetTextColor (1, value, 0)
			elseif (value > 1) then
				slider.amt:SetTextColor (-(value-3), 1, 0)
			else
				slider.amt:SetTextColor (1, 1, 0)
			end
		end
		frame10.updatespeedSlider:SetHook ("OnValueChange", function (self, _, amount) 
			if (editing)  then
				editing.update_speed = amount
				_detalhes:CheckForPerformanceProfile()
			end
			--_detalhes:CancelTimer (_detalhes.atualizador)
			--_detalhes.update_speed = amount
			--_detalhes.atualizador = _detalhes:ScheduleRepeatingTimer ("AtualizaGumpPrincipal", _detalhes.update_speed, -1)
			updateColor (self, amount)
		end)
		updateColor (frame10.updatespeedSlider, _detalhes.update_speed)
		
		--window:CreateLineBackground2 (frame10, "updatespeedSlider", "updatespeedLabel", Loc ["STRING_OPTIONS_WINDOWSPEED_DESC"])
		
		-- captures
		g:NewLabel (frame10, _, "$parentCaptureDamageLabel", "damageCaptureLabel", Loc ["STRING_OPTIONS_CDAMAGE"], "GameFontHighlightLeft")
		g:NewLabel (frame10, _, "$parentCaptureHealLabel", "healCaptureLabel", Loc ["STRING_OPTIONS_CHEAL"], "GameFontHighlightLeft")
		g:NewLabel (frame10, _, "$parentCaptureEnergyLabel", "energyCaptureLabel", Loc ["STRING_OPTIONS_CENERGY"], "GameFontHighlightLeft")
		g:NewLabel (frame10, _, "$parentCaptureMiscLabel", "miscCaptureLabel", Loc ["STRING_OPTIONS_CMISC"], "GameFontHighlightLeft")
		g:NewLabel (frame10, _, "$parentCaptureAuraLabel", "auraCaptureLabel", Loc ["STRING_OPTIONS_CAURAS"], "GameFontHighlightLeft")

		-- damage
		g:NewSwitch (frame10, _, "$parentCaptureDamageSlider", "damageCaptureSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.damageCaptureSlider:SetPoint ("left", frame10.damageCaptureLabel, "right", 2)
		frame10.damageCaptureSlider:SetAsCheckBox()
		frame10.damageCaptureSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.damage = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "damageCaptureSlider", "damageCaptureLabel", Loc ["STRING_OPTIONS_CDAMAGE_DESC"])
		
		--heal
		g:NewSwitch (frame10, _, "$parentCaptureHealSlider", "healCaptureSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.healCaptureSlider:SetPoint ("left", frame10.healCaptureLabel, "right", 2)
		frame10.healCaptureSlider:SetAsCheckBox()
		frame10.healCaptureSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.heal = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "healCaptureSlider", "healCaptureLabel", Loc ["STRING_OPTIONS_CHEAL_DESC"])
		
		--energy
		g:NewSwitch (frame10, _, "$parentCaptureEnergySlider", "energyCaptureSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.energyCaptureSlider:SetPoint ("left", frame10.energyCaptureLabel, "right", 2)
		frame10.energyCaptureSlider:SetAsCheckBox()

		frame10.energyCaptureSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.energy = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "energyCaptureSlider", "energyCaptureLabel", Loc ["STRING_OPTIONS_CENERGY_DESC"])
		
		--misc
		g:NewSwitch (frame10, _, "$parentCaptureMiscSlider", "miscCaptureSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.miscCaptureSlider:SetPoint ("left", frame10.miscCaptureLabel, "right", 2)
		frame10.miscCaptureSlider:SetAsCheckBox()
		frame10.miscCaptureSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.miscdata = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "miscCaptureSlider", "miscCaptureLabel", Loc ["STRING_OPTIONS_CMISC_DESC"])
		
		--aura
		g:NewSwitch (frame10, _, "$parentCaptureAuraSlider", "auraCaptureSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.auraCaptureSlider:SetPoint ("left", frame10.auraCaptureLabel, "right", 2)
		frame10.auraCaptureSlider:SetAsCheckBox()
		frame10.auraCaptureSlider.OnSwitch = function (self, _, value)
			if (editing)  then
				editing.aura = value
				_detalhes:CheckForPerformanceProfile()
			end
		end
		
		--window:CreateLineBackground2 (frame10, "auraCaptureSlider", "auraCaptureLabel", Loc ["STRING_OPTIONS_CAURAS_DESC"])
		
		lock_profile()
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> captures
			
		--> icons
		g:NewImage (frame10, [[Interface\AddOns\Details\images\atributos_captures]], 20, 20, nil, nil, "damageCaptureImage2", "$parentCaptureDamage2")
		frame10.damageCaptureImage2:SetTexCoord (0, 0.125, 0, 1)
		
		g:NewImage (frame10, [[Interface\AddOns\Details\images\atributos_captures]], 20, 20, nil, nil, "healCaptureImage2", "$parentCaptureHeal2")
		frame10.healCaptureImage2:SetTexCoord (0.125, 0.25, 0, 1)
		
		g:NewImage (frame10, [[Interface\AddOns\Details\images\atributos_captures]], 20, 20, nil, nil, "energyCaptureImage2", "$parentCaptureEnergy2")
		frame10.energyCaptureImage2:SetTexCoord (0.25, 0.375, 0, 1)
		
		g:NewImage (frame10, [[Interface\AddOns\Details\images\atributos_captures]], 20, 20, nil, nil, "miscCaptureImage2", "$parentCaptureMisc2")
		frame10.miscCaptureImage2:SetTexCoord (0.375, 0.5, 0, 1)
		
		g:NewImage (frame10, [[Interface\AddOns\Details\images\atributos_captures]], 20, 20, nil, nil, "auraCaptureImage2", "$parentCaptureAura2")
		frame10.auraCaptureImage2:SetTexCoord (0.5, 0.625, 0, 1)
		
		--> labels
		g:NewLabel (frame10, _, "$parentCaptureDamageLabel2", "damageCaptureLabel2", Loc ["STRING_OPTIONS_CDAMAGE"], "GameFontHighlightLeft")
		frame10.damageCaptureLabel2:SetPoint ("left", frame10.damageCaptureImage2, "right", 2, 0)
		
		g:NewLabel (frame10, _, "$parentCaptureHealLabel2", "healCaptureLabel2", Loc ["STRING_OPTIONS_CHEAL"], "GameFontHighlightLeft")
		frame10.healCaptureLabel2:SetPoint ("left", frame10.healCaptureImage2, "right", 2, 0)
		
		g:NewLabel (frame10, _, "$parentCaptureEnergyLabel2", "energyCaptureLabel2", Loc ["STRING_OPTIONS_CENERGY"], "GameFontHighlightLeft")
		frame10.energyCaptureLabel2:SetPoint ("left", frame10.energyCaptureImage2, "right", 2, 0)
		
		g:NewLabel (frame10, _, "$parentCaptureMiscLabel2", "miscCaptureLabel2", Loc ["STRING_OPTIONS_CMISC"], "GameFontHighlightLeft")
		frame10.miscCaptureLabel2:SetPoint ("left", frame10.miscCaptureImage2, "right", 2, 0)
		
		g:NewLabel (frame10, _, "$parentCaptureAuraLabel2", "auraCaptureLabel2", Loc ["STRING_OPTIONS_CAURAS"], "GameFontHighlightLeft")
		frame10.auraCaptureLabel2:SetPoint ("left", frame10.auraCaptureImage2, "right", 2, 0)
		
		--> switches
		
		local switch_icon_color = function (icon, on_off)
			icon:SetDesaturated (not on_off)
		end
		
		g:NewSwitch (frame10, _, "$parentCaptureDamageSlider2", "damageCaptureSlider2", 60, 20, _, _, _detalhes.capture_real ["damage"], nil, nil, nil, nil, options_switch_template)
		frame10.damageCaptureSlider2:SetPoint ("left", frame10.damageCaptureLabel2, "right", 2)
		frame10.damageCaptureSlider2:SetAsCheckBox()
		frame10.damageCaptureSlider2.OnSwitch = function (self, _, value)
			_detalhes:CaptureSet (value, "damage", true)
			if (value) then
				_detalhes:CaptureSet (true, "spellcast", true)
			end
			switch_icon_color (frame10.damageCaptureImage2, value)
		end
		switch_icon_color (frame10.damageCaptureImage2, _detalhes.capture_real ["damage"])
		
		window:CreateLineBackground2 (frame10, "damageCaptureSlider2", "damageCaptureLabel", Loc ["STRING_OPTIONS_CDAMAGE_DESC"], frame10.damageCaptureImage)
		
		g:NewSwitch (frame10, _, "$parentCaptureHealSlider2", "healCaptureSlider2", 60, 20, _, _, _detalhes.capture_real ["heal"], nil, nil, nil, nil, options_switch_template)
		frame10.healCaptureSlider2:SetPoint ("left", frame10.healCaptureLabel2, "right", 2)
		frame10.healCaptureSlider2:SetAsCheckBox()
		frame10.healCaptureSlider2.OnSwitch = function (self, _, value)
			_detalhes:CaptureSet (value, "heal", true)
			if (value) then
				_detalhes:CaptureSet (true, "spellcast", true)
			end
			switch_icon_color (frame10.healCaptureImage2, value)
		end
		switch_icon_color (frame10.healCaptureImage2, _detalhes.capture_real ["heal"])
		
		window:CreateLineBackground2 (frame10, "healCaptureSlider2", "healCaptureLabel2", Loc ["STRING_OPTIONS_CHEAL_DESC"], frame10.healCaptureImage)
		
		g:NewSwitch (frame10, _, "$parentCaptureEnergySlider2", "energyCaptureSlider2", 60, 20, _, _, _detalhes.capture_real ["energy"], nil, nil, nil, nil, options_switch_template)
		frame10.energyCaptureSlider2:SetPoint ("left", frame10.energyCaptureLabel2, "right", 2)
		frame10.energyCaptureSlider2:SetAsCheckBox()

		frame10.energyCaptureSlider2.OnSwitch = function (self, _, value)
			_detalhes:CaptureSet (value, "energy", true)
			if (value) then
				_detalhes:CaptureSet (true, "spellcast", true)
			end
			switch_icon_color (frame10.energyCaptureImage2, value)
		end
		switch_icon_color (frame10.energyCaptureImage2, _detalhes.capture_real ["energy"])
		
		window:CreateLineBackground2 (frame10, "energyCaptureSlider2", "energyCaptureLabel2", Loc ["STRING_OPTIONS_CENERGY_DESC"], frame10.energyCaptureImage)
		
		g:NewSwitch (frame10, _, "$parentCaptureMiscSlider2", "miscCaptureSlider2", 60, 20, _, _, _detalhes.capture_real ["miscdata"], nil, nil, nil, nil, options_switch_template)
		frame10.miscCaptureSlider2:SetPoint ("left", frame10.miscCaptureLabel2, "right", 2)
		frame10.miscCaptureSlider2:SetAsCheckBox()
		frame10.miscCaptureSlider2.OnSwitch = function (self, _, value)
			_detalhes:CaptureSet (value, "miscdata", true)
			if (value) then
				_detalhes:CaptureSet (true, "spellcast", true)
			end
			switch_icon_color (frame10.miscCaptureImage2, value)
		end
		switch_icon_color (frame10.miscCaptureImage2, _detalhes.capture_real ["miscdata"])
		
		window:CreateLineBackground2 (frame10, "miscCaptureSlider2", "miscCaptureLabel2", Loc ["STRING_OPTIONS_CMISC_DESC"], frame10.miscCaptureImage)
		
		g:NewSwitch (frame10, _, "$parentCaptureAuraSlider2", "auraCaptureSlider2", 60, 20, _, _, _detalhes.capture_real ["aura"], nil, nil, nil, nil, options_switch_template)
		frame10.auraCaptureSlider2:SetPoint ("left", frame10.auraCaptureLabel2, "right", 2)
		frame10.auraCaptureSlider2:SetAsCheckBox()
		frame10.auraCaptureSlider2.OnSwitch = function (self, _, value)
			_detalhes:CaptureSet (value, "aura", true)
			if (value) then
				_detalhes:CaptureSet (true, "spellcast", true)
			end
			switch_icon_color (frame10.auraCaptureImage2, value)
		end
		switch_icon_color (frame10.auraCaptureImage2, _detalhes.capture_real ["aura"])
		
		window:CreateLineBackground2 (frame10, "auraCaptureSlider2", "auraCaptureLabel2", Loc ["STRING_OPTIONS_CAURAS_DESC"], frame10.auraCaptureImage)
		
		--> cloud capture
		g:NewLabel (frame10, _, "$parentCloudCaptureLabel", "cloudCaptureLabel", Loc ["STRING_OPTIONS_CLOUD"], "GameFontHighlightLeft")

		g:NewSwitch (frame10, _, "$parentCloudAuraSlider", "cloudCaptureSlider", 60, 20, _, _, _detalhes.cloud_capture, nil, nil, nil, nil, options_switch_template)
		frame10.cloudCaptureSlider:SetPoint ("left", frame10.cloudCaptureLabel, "right", 2)
		frame10.cloudCaptureSlider:SetAsCheckBox()
		frame10.cloudCaptureSlider.OnSwitch = function (self, _, value)
			_detalhes.cloud_capture = value
		end
		
		window:CreateLineBackground2 (frame10, "cloudCaptureSlider", "cloudCaptureLabel", Loc ["STRING_OPTIONS_CLOUD_DESC"] )


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> Erase Chart Data
		g:NewLabel (frame10, _, "$parentEraseChartDataLabel", "EraseChartDataLabel", Loc ["STRING_OPTIONS_ERASECHARTDATA"], "GameFontHighlightLeft")
		g:NewSwitch (frame10, _, "$parentEraseChartDataSlider", "EraseChartDataSlider", 60, 20, _, _, false, nil, nil, nil, nil, options_switch_template)
		frame10.EraseChartDataSlider:SetPoint ("left", frame10.EraseChartDataLabel, "right", 2, 0)
		frame10.EraseChartDataSlider:SetAsCheckBox()
		frame10.EraseChartDataSlider.OnSwitch = function (self, _, value)
			_detalhes.clear_graphic = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		window:CreateLineBackground2 (frame10, "EraseChartDataSlider", "EraseChartDataLabel", Loc ["STRING_OPTIONS_ERASECHARTDATA_DESC"])

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> Max Segments
	
		g:NewLabel (frame10, _, "$parentSliderLabel", "segmentsLabel", Loc ["STRING_OPTIONS_MAXSEGMENTS"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame10, _, "$parentSlider", "segmentsSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 25, 1, _detalhes.segments_amount, nil, nil, nil, options_slider_template)
		
		frame10.segmentsSlider:SetPoint ("left", frame10.segmentsLabel, "right", 2, -1)
		frame10.segmentsSlider:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
			_detalhes.segments_amount = math.floor (amount)
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame10, "segmentsSlider", "segmentsLabel", Loc ["STRING_OPTIONS_MAXSEGMENTS_DESC"])

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	--> Anchors
	
		--captures anchor
		g:NewLabel (frame10, _, "$parentDataCollectAnchor", "DataCollectAnchorLabel", Loc ["STRING_OPTIONS_DATACOLLECT_ANCHOR"], "GameFontNormal")
	
		--general anchor
		g:NewLabel (frame10, _, "$parentPerformanceAnchor", "PerformanceAnchorLabel", Loc ["STRING_OPTIONS_PERFORMANCE_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo_performance_general:SetPoint (x, window.title_y_pos)
		titulo_performance_general_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"PerformanceProfilesAnchorLabel", 1, true},
			{"ProfileTypeLabel", 2},
			{"ProfileTypeEnabledLabel", 3},
			{"animateLabel", 4},
			{"updatespeedLabel", 5},
			{"damageCaptureLabel", 6},
			{"healCaptureLabel", 7},
			{"energyCaptureLabel", 8},
			{"miscCaptureLabel", 9},
			{"auraCaptureLabel", 10},
		}
		
		window:arrange_menu (frame10, left_side, window.left_start_at, window.top_start_at)
		
		local right_side = {
			{"PerformanceAnchorLabel", 1, true},
			--{"memoryLabel", 1, true},
			{"segmentsLabel", 6},
			{"segmentsSaveLabel", 2},
			{"panicModeLabel", 3},
			{"eraseTrashLabel", 4},
			{"WorldAsTrashLabel", 4},
			{"EraseChartDataLabel", 5},
			
			{"DataCollectAnchorLabel", 5, true},
			{"damageCaptureImage2", 6},
			{"healCaptureImage2", 7},
			{"energyCaptureImage2", 8},
			{"miscCaptureImage2", 9},
			{"auraCaptureImage2", 10},
			{"cloudCaptureLabel", 11, true},			
			
		}
		
		window:arrange_menu (frame10, right_side, window.right_start_at, window.top_start_at)

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Performance - Raid Tools ~11
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function window:CreateFrame11()

	local frame11 = window.options [11][1]

	--> title
		local titulo1 = g:NewLabel (frame11, _, "$parentTituloRaidTools", "RaidToolsLabel", Loc ["STRING_OPTIONS_RT_TITLE"], "GameFontNormal", 16)
		local titulo1_desc = g:NewLabel (frame11, _, "$parentTituloRaidToolsDesc", "RaidToolsDescLabel", Loc ["STRING_OPTIONS_RT_TITLE_DESC"], "GameFontNormal", 10, "white")
		titulo1_desc.width = 320
	
		local text_entry_size = 140
	
	--interrupts
		--enable
		g:NewLabel (frame11, _, "$parentEnableInterruptsLabel", "EnableInterruptsLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableInterruptsSlider", "EnableInterruptsSlider", 60, 20, _, _, _detalhes.announce_interrupts.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnableInterruptsSlider:SetPoint ("left", frame11.EnableInterruptsLabel, "right", 2)
		frame11.EnableInterruptsSlider:SetAsCheckBox()
		frame11.EnableInterruptsSlider.OnSwitch = function (_, _, value)
			if (value) then
				_detalhes:EnableInterruptAnnouncer()
			else
				_detalhes:DisableInterruptAnnouncer()
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableInterruptsSlider", "EnableInterruptsLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_ONOFF_DESC"])
		
		--whisper target
		g:NewLabel (frame11, _, "$parentInterruptsWhisperLabel", "InterruptsWhisperLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"], "GameFontHighlightLeft")
		g:NewTextEntry (frame11, _, "$parentInterruptsWhisperEntry", "InterruptsWhisperEntry", text_entry_size, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame11.InterruptsWhisperEntry:SetPoint ("left", frame11.InterruptsWhisperLabel, "right", 2, -1)
		frame11.InterruptsWhisperEntry:SetText (_detalhes.announce_interrupts.whisper)
		
		frame11.InterruptsWhisperEntry:SetHook ("OnTextChanged", function (self, byUser)
			if (byUser) then
				_detalhes.announce_interrupts.whisper = self:GetText()
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		if (_detalhes.announce_interrupts.channel ~= "WHISPER") then
			frame11.InterruptsWhisperEntry:Disable()
			frame11.InterruptsWhisperLabel:SetTextColor (1, 1, 1, .4)
		end
		
		--channel
		local on_select_channel = function (self, _, channel)
			_detalhes.announce_interrupts.channel = channel
			if (channel == "WHISPER") then
				frame11.InterruptsWhisperEntry:Enable()
				frame11.InterruptsWhisperLabel:SetTextColor (1, 1, 1, 1)
			else
				frame11.InterruptsWhisperEntry:Disable()
				frame11.InterruptsWhisperLabel:SetTextColor (1, 1, 1, .4)
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local channel_list = {
			{value = "PRINT", icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = "SAY", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, label = Loc ["STRING_CHANNEL_SAY"], onclick = on_select_channel},
			{value = "YELL", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, iconcolor = {1, 0.3, 0, 1}, label = Loc ["STRING_CHANNEL_YELL"], onclick = on_select_channel},
			{value = "RAID", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_INSTANCE_CHAT"], onclick = on_select_channel},
			{value = "WHISPER", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 1}, iconsize = {14, 14}, texcoord = {0.0546875, 0.1953125, 0.625, 0.890625}, label = Loc ["STRING_CHANNEL_WHISPER"], onclick = on_select_channel},
		}
		local build_channel_menu = function() 
			return channel_list
		end

		g:NewLabel (frame11, _, "$parentInterruptsChannelLabel", "InterruptsChannelLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL"] , "GameFontHighlightLeft")
		local d = g:NewDropDown (frame11, _, "$parentInterruptsChannelDropdown", "InterruptsChannelDropdown", DROPDOWN_WIDTH, dropdown_height, build_channel_menu, _detalhes.announce_interrupts.channel, options_dropdown_template)

		
		frame11.InterruptsChannelDropdown:SetPoint ("left", frame11.InterruptsChannelLabel, "right", 2)
		window:CreateLineBackground2 (frame11, "InterruptsChannelDropdown", "InterruptsChannelLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL_DESC"])

		--campo para digitar o nome do proximo
		g:NewLabel (frame11, _, "$parentInterruptsNextLabel", "InterruptsNextLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_NEXT"], "GameFontHighlightLeft")
		g:NewTextEntry (frame11, _, "$parentInterruptsNextEntry", "InterruptsNextEntry", text_entry_size, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame11.InterruptsNextEntry:SetPoint ("left", frame11.InterruptsNextLabel, "right", 2, -1)
		frame11.InterruptsNextEntry:SetText (_detalhes.announce_interrupts.next)
		
		frame11.InterruptsNextEntry:SetHook ("OnTextChanged", function (self, byUser)
			_detalhes.announce_interrupts.next = self:GetText()
		end)
		window:CreateLineBackground2 (frame11, "InterruptsNextEntry", "InterruptsNextLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_NEXT_DESC"])
		
		local reset_next = g:NewButton (frame11.InterruptsNextEntry, _, "$parentResetNextPlayerButton", "ResetNextPlayerButton", 16, 16, function()
			frame11.InterruptsNextEntry.text = ""
			frame11.InterruptsNextEntry:PressEnter()
		end)
		reset_next:SetPoint ("left", frame11.InterruptsNextEntry, "right", 0, 0)
		reset_next:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		reset_next:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		reset_next:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		reset_next:GetNormalTexture():SetDesaturated (true)
		reset_next.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
		--campo para digitar a fala customizada
		g:NewLabel (frame11, _, "$parentInterruptsCustomLabel", "InterruptsCustomLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM"], "GameFontHighlightLeft")
		g:NewTextEntry (frame11, _, "$parentInterruptsCustomEntry", "InterruptsCustomEntry", text_entry_size, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame11.InterruptsCustomEntry:SetPoint ("left", frame11.InterruptsCustomLabel, "right", 2, -1)
		frame11.InterruptsCustomEntry:SetText (_detalhes.announce_interrupts.custom)
		
		frame11.InterruptsCustomEntry:SetHook ("OnTextChanged", function (self, byUser)
			_detalhes.announce_interrupts.custom = self:GetText()
		end)
		window:CreateLineBackground2 (frame11, "InterruptsCustomEntry", "InterruptsCustomLabel", Loc ["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM_DESC"])
		
		local reset_custom = g:NewButton (frame11.InterruptsCustomEntry, _, "$parentResetCustomPhraseButton", "ResetCustomPhraseButton", 16, 16, function()
			frame11.InterruptsCustomEntry.text = ""
			frame11.InterruptsCustomEntry:PressEnter()
		end)
		reset_custom:SetPoint ("left", frame11.InterruptsCustomEntry, "right", 0, 0)
		reset_custom:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		reset_custom:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		reset_custom:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		reset_custom:GetNormalTexture():SetDesaturated (true)
		reset_custom.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
		local test_custom_text = g:NewButton (frame11.InterruptsCustomEntry, _, "$parentTestCustomPhraseButton", "TestCustomPhraseButton", 16, 16, function()
			local text = frame11.InterruptsCustomEntry.text

			local channel = _detalhes.announce_interrupts.channel
			_detalhes.announce_interrupts.channel = "PRINT"
			_detalhes:interrupt_announcer (nil, nil, nil, _detalhes.playername, nil, nil, "A Monster", nil, 1766, "Kick", nil, 106523, "Cataclysm", nil)
			_detalhes.announce_interrupts.channel = channel
			
		end)
		test_custom_text:SetPoint ("left", reset_custom, "right", 0, 0)
		test_custom_text:SetNormalTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:SetHighlightTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:SetPushedTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:GetNormalTexture():SetDesaturated (true)
		test_custom_text.tooltip = "Click to test!"
		
	--cooldowns
	
		g:NewLabel (frame11, _, "$parentEnableCooldownsLabel", "EnableCooldownsLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableCooldownsSlider", "EnableCooldownsSlider", 60, 20, _, _, _detalhes.announce_cooldowns.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnableCooldownsSlider:SetPoint ("left", frame11.EnableCooldownsLabel, "right", 2)
		frame11.EnableCooldownsSlider:SetAsCheckBox()
		frame11.EnableCooldownsSlider.OnSwitch = function (_, _, value)
			if (value) then
				_detalhes:EnableCooldownAnnouncer()
			else
				_detalhes:DisableCooldownAnnouncer()
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableCooldownsSlider", "EnableCooldownsLabel", Loc ["STRING_OPTIONS_RT_COOLDOWNS_ONOFF_DESC"])
		
		--dropdown para escolher o canal
		local on_select_channel = function (self, _, channel)
			_detalhes.announce_cooldowns.channel = channel
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local channel_list = {
			{value = "PRINT", icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = "SAY", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, label = Loc ["STRING_CHANNEL_SAY"], onclick = on_select_channel},
			{value = "YELL", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, iconcolor = {1, 0.3, 0, 1}, label = Loc ["STRING_CHANNEL_YELL"], onclick = on_select_channel},
			{value = "RAID", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_INSTANCE_CHAT"], onclick = on_select_channel},
			{value = "WHISPER", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 1}, iconsize = {14, 14}, texcoord = {0.0546875, 0.1953125, 0.625, 0.890625}, label = Loc ["STRING_CHANNEL_WHISPER_TARGET_COOLDOWN"], onclick = on_select_channel},
		}
		local build_channel_menu = function() 
			return channel_list
		end

		g:NewLabel (frame11, _, "$parentCooldownChannelLabel", "CooldownChannelLabel", Loc ["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL"] , "GameFontHighlightLeft")
		local d = g:NewDropDown (frame11, _, "$parentCooldownChannelDropdown", "CooldownChannelDropdown", DROPDOWN_WIDTH, dropdown_height, build_channel_menu, _detalhes.announce_cooldowns.channel, options_dropdown_template)
		
		frame11.CooldownChannelDropdown:SetPoint ("left", frame11.CooldownChannelLabel, "right", 2)
		window:CreateLineBackground2 (frame11, "CooldownChannelDropdown", "CooldownChannelLabel", Loc ["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL_DESC"])
		
		--campo para digitar a frase customizada
		g:NewLabel (frame11, _, "$parentCooldownCustomLabel", "CooldownCustomLabel", Loc ["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM"], "GameFontHighlightLeft")
		g:NewTextEntry (frame11, _, "$parentCooldownCustomEntry", "CooldownCustomEntry", text_entry_size, TEXTENTRY_HEIGHT, nil, nil, nil, nil, nil, options_dropdown_template)
		frame11.CooldownCustomEntry:SetPoint ("left", frame11.CooldownCustomLabel, "right", 2, -1)
		frame11.CooldownCustomEntry:SetText (_detalhes.announce_cooldowns.custom)
		
		frame11.CooldownCustomEntry:SetHook ("OnTextChanged", function (self, byUser)
			_detalhes.announce_cooldowns.custom = self:GetText()
		end)
		window:CreateLineBackground2 (frame11, "CooldownCustomEntry", "CooldownCustomLabel", Loc ["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM_DESC"])
		
		local reset_custom = g:NewButton (frame11.CooldownCustomEntry, _, "$parentResetCooldownCustomPhraseButton", "ResetCooldownCustomPhraseButton", 16, 16, function()
			frame11.CooldownCustomEntry.text = ""
			frame11.CooldownCustomEntry:PressEnter()
		end)
		reset_custom:SetPoint ("left", frame11.CooldownCustomEntry, "right", 0, 0)
		reset_custom:SetNormalTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		reset_custom:SetHighlightTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		reset_custom:SetPushedTexture ([[Interface\Glues\LOGIN\Glues-CheckBox-Check]] or [[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		reset_custom:GetNormalTexture():SetDesaturated (true)
		reset_custom.tooltip = Loc ["STRING_OPTIONS_RESET_TO_DEFAULT"]
		
		local test_custom_text = g:NewButton (frame11.CooldownCustomEntry, _, "$parentTestCustomPhraseButton", "TestCustomPhraseButton", 16, 16, function()
			local text = frame11.CooldownCustomEntry.text

			local channel = _detalhes.announce_cooldowns.channel
			_detalhes.announce_cooldowns.channel = "PRINT"
			_detalhes:cooldown_announcer (nil, nil, nil, _detalhes.playername, nil, nil, "Tyrande Whisperwind", nil, 47788, "Guardian Spirit")
			_detalhes.announce_cooldowns.channel = channel
			
		end)
		test_custom_text:SetPoint ("left", reset_custom, "right", 0, 0)
		test_custom_text:SetNormalTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:SetHighlightTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:SetPushedTexture ([[Interface\CHATFRAME\ChatFrameExpandArrow]])
		test_custom_text:GetNormalTexture():SetDesaturated (true)
		test_custom_text.tooltip = "Click to test!"
	
		--esquema para ativar ou desativar certos cooldowns
			--bot�o que abre um gump estilo welcome, com as spells pegas na lista de cooldowns
		
		g:NewButton (frame11, _, "$parentCooldownIgnoreButton", "CooldownIgnoreButton", window.buttons_width, 18, function()
			if (not DetailsAnnounceSelectCooldownIgnored) then
				DetailsAnnounceSelectCooldownIgnored = CreateFrame ("frame", "DetailsAnnounceSelectCooldownIgnored", UIParent)
				local f = DetailsAnnounceSelectCooldownIgnored
				f:SetSize (250, 400)
				f:SetPoint ("center", UIParent, "center", 0, 0)

				f:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 128, insets = {left=3, right=3, top=3, bottom=3},
				edgeFile = [[Interface\AddOns\Details\images\border_welcome]], edgeSize = 16})
				f:SetBackdropColor (1, 1, 1, 0.75)				
				
				f:SetFrameStrata ("FULLSCREEN")
				local close = CreateFrame ("button", "DetailsAnnounceSelectCooldownIgnoredClose", f, "UIPanelCloseButton")
				close:SetSize (32, 32)
				close:SetPoint ("topright", f, "topright", 0, -12)
				f:EnableMouse()
				f:SetMovable (true)
				f:SetScript ("OnMouseDown", function (self, button)
					if (button == "RightButton") then
						if (f.IsMoving) then
							f.IsMoving = false
							f:StopMovingOrSizing()
						end
						f:Hide()
						return
					end
					
					f.IsMoving = true
					f:StartMoving()
				end)
				f:SetScript ("OnMouseUp", function (self, button)
					if (f.IsMoving) then
						f.IsMoving = false
						f:StopMovingOrSizing()
					end
				end)
				f.title = g:CreateLabel (f, Loc ["STRING_OPTIONS_RT_IGNORE_TITLE"], 12, nil, "GameFontNormal")
				f.title:SetPoint ("top", f, "top", 0, -22)
				
				f.labels = {}
				
				local on_switch_func = function (self, spellid, value)
					if (not value) then
						_detalhes.announce_cooldowns.ignored_cooldowns [spellid] = nil
					else
						_detalhes.announce_cooldowns.ignored_cooldowns [spellid] = true
					end
				end
				
				f:SetScript ("OnHide", function (self)
					self:Clear()
				end)
				
				function f:Clear()
					for _, label in ipairs (self.labels) do
						label.icon:Hide()
						label.text:Hide()
						label.switch:Hide()
					end
				end
				
				function f:CreateLabel()
					local L = {
						icon = g:CreateImage (f, nil, 16, 16, "overlay", {0.1, 0.9, 0.1, 0.9}),
						text = g:CreateLabel (f, "", 10, "white", "GameFontHighlightSmall"),
						switch = g:CreateSwitch (f, on_switch_func, false)
					}
					L.icon:SetPoint ("topleft", f, "topleft", 10, ((#f.labels*20)*-1)-55)
					L.text:SetPoint ("left", L.icon, "right", 2, 0)
					L.switch:SetPoint ("left", L.text, "right", 2, 0)
					tinsert (f.labels, L)
					return L
				end
				
				function f:Open()
					local _GetSpellInfo = _detalhes.getspellinfo --details api
					
					for index, spellid in ipairs (_detalhes:GetCooldownList()) do
						local name, _, icon = _GetSpellInfo (spellid)
						if (name) then
							local label = f.labels [index] or f:CreateLabel()
							label.icon.texture = icon
							label.text.text = name .. ":"
							label.switch:SetFixedParameter (spellid)
							label.switch:SetValue (_detalhes.announce_cooldowns.ignored_cooldowns [spellid])
							label.icon:Show()
							label.text:Show()
							label.switch:Show()
						end
					end
					
					f:Show()
				end
				
			end
			
			DetailsAnnounceSelectCooldownIgnored:Open()
		
		end, nil, nil, nil, Loc ["STRING_OPTIONS_RT_COOLDOWNS_SELECT"], 1, options_button_template)
		
		--frame11.CooldownIgnoreButton:InstallCustomTexture (nil, nil, nil, nil, nil, true)
		window:CreateLineBackground2 (frame11, "CooldownIgnoreButton", "CooldownIgnoreButton", Loc ["STRING_OPTIONS_RT_COOLDOWNS_SELECT_DESC"], nil, {1, 0.8, 0}, button_color_rgb)
		
		frame11.CooldownIgnoreButton:SetIcon ([[Interface\COMMON\UI-DropDownRadioChecks]], nil, nil, nil, {0, 0.5, 0, 0.5}, nil, nil, 2)
		frame11.CooldownIgnoreButton:SetTextColor (button_color_rgb)
	
	--deaths

		g:NewLabel (frame11, _, "$parentEnableDeathsLabel", "EnableDeathsLabel", Loc ["STRING_ENABLED"], "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableDeathsSlider", "EnableDeathsSlider", 60, 20, _, _, _detalhes.announce_deaths.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnableDeathsSlider:SetPoint ("left", frame11.EnableDeathsLabel, "right", 2)
		frame11.EnableDeathsSlider:SetAsCheckBox()
		frame11.EnableDeathsSlider.OnSwitch = function (_, _, value)
			if (value) then
				_detalhes:EnableDeathAnnouncer()
			else
				_detalhes:DisableDeathAnnouncer()
			end
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableDeathsSlider", "EnableDeathsLabel", Loc ["STRING_OPTIONS_RT_DEATHS_ONOFF_DESC"])
		
		--slider para quantidade de danos a mostrar
		g:NewLabel (frame11, _, "$parentDeathsDamageLabel", "DeathsDamageLabel", Loc ["STRING_OPTIONS_RT_DEATHS_HITS"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame11, _, "$parentDeathsDamageSlider", "DeathsDamageSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 5, 1, _detalhes.announce_deaths.last_hits, nil, nil, nil, options_slider_template)

		frame11.DeathsDamageSlider:SetPoint ("left", frame11.DeathsDamageLabel, "right", 2)
		frame11.DeathsDamageSlider:SetHook ("OnValueChange", function (self, _, amount)
			_detalhes.announce_deaths.last_hits = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		window:CreateLineBackground2 (frame11, "DeathsDamageSlider", "DeathsDamageLabel", Loc ["STRING_OPTIONS_RT_DEATHS_HITS_DESC"])
		
		--slider para limite de mortes para reportar
		g:NewLabel (frame11, _, "$parentDeathsAmountLabel", "DeathsAmountLabel", Loc ["STRING_OPTIONS_RT_DEATHS_FIRST"], "GameFontHighlightLeft")
		local s = g:NewSlider (frame11, _, "$parentDeathsAmountSlider", "DeathsAmountSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 30, 1, _detalhes.announce_deaths.only_first, nil, nil, nil, options_slider_template)
		--config_slider (s)
	
		frame11.DeathsAmountSlider:SetPoint ("left", frame11.DeathsAmountLabel, "right", 2)
		frame11.DeathsAmountSlider:SetHook ("OnValueChange", function (self, _, amount)
			_detalhes.announce_deaths.only_first = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		window:CreateLineBackground2 (frame11, "DeathsAmountSlider", "DeathsAmountLabel", Loc ["STRING_OPTIONS_RT_DEATHS_FIRST_DESC"])
		
		--dropdown para WHERE onde anunciar se s� em raid e party
		local on_select_channel = function (self, _, channel)
			_detalhes.announce_deaths.where = channel
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		local officer = _detalhes.GetReportIconAndColor ("OFFICER")
		
		local channel_list = {
			{value = 1, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0, 1}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE1"], onclick = on_select_channel},
			{value = 2, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE2"], onclick = on_select_channel},
			{value = 3, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {0.66, 0.65, 1}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE3"], onclick = on_select_channel},
			{value = 4, icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = 5, icon = officer.icon, iconsize = {14, 14}, iconcolor = officer.color, texcoord = officer.coords, label = officer.label, onclick = on_select_channel},
		}
		local build_channel_menu = function() 
			return channel_list
		end

		g:NewLabel (frame11, _, "$parentDeathChannelLabel", "DeathChannelLabel", Loc ["STRING_OPTIONS_RT_DEATHS_WHERE"] , "GameFontHighlightLeft")
		local d = g:NewDropDown (frame11, _, "$parentDeathChannelDropdown", "DeathChannelDropdown", DROPDOWN_WIDTH, dropdown_height, build_channel_menu, _detalhes.announce_deaths.where, options_dropdown_template)
		
		frame11.DeathChannelDropdown:SetPoint ("left", frame11.DeathChannelLabel, "right", 2)
		window:CreateLineBackground2 (frame11, "DeathChannelDropdown", "DeathChannelLabel", Loc ["STRING_OPTIONS_RT_DEATHS_WHERE_DESC"])

	--> death recap
		--enabled?
		g:NewLabel (frame11, _, "$parentEnableDeathRecapLabel", "EnableDeathRecapLabel", "Enabled", "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableDeathRecapSlider", "EnableDeathRecapSlider", 60, 20, _, _, _detalhes.death_recap.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnableDeathRecapSlider:SetPoint ("left", frame11.EnableDeathRecapLabel, "right", 2)
		frame11.EnableDeathRecapSlider:SetAsCheckBox()
		frame11.EnableDeathRecapSlider.OnSwitch = function (_, _, value)
			_detalhes.death_recap.enabled = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableDeathRecapSlider", "EnableDeathRecapLabel", "Modify the Blizzard's Death Recap screen.")
		
		--time relevance
		g:NewLabel (frame11, _, "$parentDeathRecapRelevanceLabel", "DeathRecapRelevanceLabel", "Relevance Time", "GameFontHighlightLeft")
		g:NewSlider (frame11, _, "$parentDeathRecapRelevanceSlider", "DeathRecapRelevanceSlider", SLIDER_WIDTH, SLIDER_HEIGHT, 1, 12, 1, _detalhes.death_recap.relevance_time, nil, nil, nil, options_slider_template)

		frame11.DeathRecapRelevanceSlider:SetPoint ("left", frame11.DeathRecapRelevanceLabel, "right", 2)
		frame11.DeathsDamageSlider:SetHook ("OnValueChange", function (self, _, amount)
			_detalhes.death_recap.relevance_time = amount
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end)
		
		window:CreateLineBackground2 (frame11, "DeathRecapRelevanceSlider", "DeathRecapRelevanceLabel", "Attempt to fill the Death Recap with high damage (discart low hits) in the relevant time before death.")
		
		--show life
		g:NewLabel (frame11, _, "$parentEnableDeathRecapLifePercentLabel", "EnableDeathRecapLifePercentLabel", "Life Percent", "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableDeathRecapLifePercentSlider", "EnableDeathRecapLifePercentSlider", 60, 20, _, _, _detalhes.death_recap.show_life_percent, nil, nil, nil, nil, options_switch_template)

		frame11.EnableDeathRecapLifePercentSlider:SetPoint ("left", frame11.EnableDeathRecapLifePercentLabel, "right", 2)
		frame11.EnableDeathRecapLifePercentSlider:SetAsCheckBox()
		frame11.EnableDeathRecapLifePercentSlider.OnSwitch = function (_, _, value)
			_detalhes.death_recap.show_life_percent = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableDeathRecapLifePercentSlider", "EnableDeathRecapLifePercentLabel", "Show the percent of life the player had when received the hit.")
		
		--show segments
		g:NewLabel (frame11, _, "$parentEnableDeathRecapSegmentsLabel", "EnableDeathRecapSegmentsLabel", "Segment List", "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnableDeathRecapSegmentsSlider", "EnableDeathRecapSegmentsSlider", 60, 20, _, _, _detalhes.death_recap.show_segments, nil, nil, nil, nil, options_switch_template)

		frame11.EnableDeathRecapSegmentsSlider:SetPoint ("left", frame11.EnableDeathRecapSegmentsLabel, "right", 2)
		frame11.EnableDeathRecapSegmentsSlider:SetAsCheckBox()
		frame11.EnableDeathRecapSegmentsSlider.OnSwitch = function (_, _, value)
			_detalhes.death_recap.show_segments = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnableDeathRecapSegmentsSlider", "EnableDeathRecapSegmentsLabel", "Show a list of the latest segments in case you want to see recaps from previous fights.")
		
		
	--> general tools
		--> pre pots
		g:NewLabel (frame11, _, "$parentEnabledPrePotLabel", "EnabledPrePotLabel", Loc ["STRING_OPTIONS_RT_INFOS_PREPOTION"], "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnabledPrePotSlider", "EnabledPrePotSlider", 60, 20, _, _, _detalhes.announce_prepots.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnabledPrePotSlider:SetPoint ("left", frame11.EnabledPrePotLabel, "right", 2)
		frame11.EnabledPrePotSlider:SetAsCheckBox()
		frame11.EnabledPrePotSlider.OnSwitch = function (_, _, value)
			_detalhes.announce_prepots.enabled = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnabledPrePotSlider", "EnabledPrePotLabel", Loc ["STRING_OPTIONS_RT_INFOS_PREPOTION_DESC"])
		
		--> first hit
		g:NewLabel (frame11, _, "$parentEnabledFirstHitLabel", "EnabledFirstHitLabel", Loc ["STRING_OPTIONS_RT_FIRST_HIT"], "GameFontHighlightLeft")
		g:NewSwitch (frame11, _, "$parentEnabledFirstHitSlider", "EnabledFirstHitSlider", 60, 20, _, _, _detalhes.announce_firsthit.enabled, nil, nil, nil, nil, options_switch_template)

		frame11.EnabledFirstHitSlider:SetPoint ("left", frame11.EnabledFirstHitLabel, "right", 2)
		frame11.EnabledFirstHitSlider:SetAsCheckBox()
		frame11.EnabledFirstHitSlider.OnSwitch = function (_, _, value)
			_detalhes.announce_firsthit.enabled = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "EnabledFirstHitSlider", "EnabledFirstHitLabel", Loc ["STRING_OPTIONS_RT_FIRST_HIT_DESC"])
		
		--> death menu
		g:NewLabel (frame11, _, "$parentShowDeathMenuLabel", "ShowDeathMenuLabel", "Show Death Menu", "GameFontHighlightLeft") --localize-me
		g:NewSwitch (frame11, _, "$parentShowDeathMenuSlider", "ShowDeathMenuSlider", 60, 20, _, _, _detalhes.on_death_menu, nil, nil, nil, nil, options_switch_template)

		frame11.ShowDeathMenuSlider:SetPoint ("left", frame11.ShowDeathMenuLabel, "right", 2)
		frame11.ShowDeathMenuSlider:SetAsCheckBox()
		frame11.ShowDeathMenuSlider.OnSwitch = function (_, _, value)
			_detalhes.on_death_menu = value
			_detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
		end
		
		window:CreateLineBackground2 (frame11, "ShowDeathMenuSlider", "ShowDeathMenuLabel", "Show a panel below the Release / Death Recap panel with some shortcuts for Raid Leaders.") --localize-me
		
	--> anchors
	
		--announcers anchor
		g:NewLabel (frame11, _, "$parentAnnouncersAnchorInterrupt", "AnnouncersInterrupt", Loc ["STRING_OPTIONS_RT_INTERRUPT_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame11, _, "$parentAnnouncersAnchorCooldowns", "AnnouncersCooldowns", Loc ["STRING_OPTIONS_RT_COOLDOWNS_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame11, _, "$parentAnnouncersAnchorDeaths", "AnnouncersDeaths", Loc ["STRING_OPTIONS_RT_DEATHS_ANCHOR"], "GameFontNormal")
		g:NewLabel (frame11, _, "$parentAnnouncersAnchorDeathRecap", "AnnouncersDeathRecap", "Death Recap:", "GameFontNormal")
		g:NewLabel (frame11, _, "$parentAnnouncersAnchorOther", "AnnouncersOther", Loc ["STRING_OPTIONS_RT_OTHER_ANCHOR"], "GameFontNormal")
		
		local x = window.left_start_at
		
		titulo1:SetPoint (x, window.title_y_pos)
		titulo1_desc:SetPoint (x, window.title_y_pos2)
		
		local left_side = {
			{"AnnouncersInterrupt", 1, true},
			{"EnableInterruptsLabel", 2},
			{"InterruptsChannelLabel", 3},
			{"InterruptsWhisperLabel", 4},
			{"InterruptsNextLabel", 5},
			{"InterruptsCustomLabel", 6},
			{"AnnouncersCooldowns", 7, true},
			{"EnableCooldownsLabel", 8},
			{"CooldownChannelLabel", 9},
			{"CooldownCustomLabel", 10},
			{"CooldownIgnoreButton", 11},

		}
		
		window:arrange_menu (frame11, left_side, window.left_start_at, window.top_start_at)
		
		local right_side = {
			{"AnnouncersDeaths", 1, true},
			{"EnableDeathsLabel", 2},
			{"DeathChannelLabel", 3},
			{"DeathsDamageLabel", 4},
			{"DeathsAmountLabel", 5},
			
			{"AnnouncersDeathRecap", 5, true},
			{"EnableDeathRecapLabel", 5},
			{"DeathRecapRelevanceLabel", 5},
			{"EnableDeathRecapLifePercentLabel", 5},
			{"EnableDeathRecapSegmentsLabel", 5},
			{"AnnouncersOther", 6, true},
			{"EnabledPrePotLabel", 7},
			{"EnabledFirstHitLabel", 8},
			{"ShowDeathMenuLabel", 9},
		}
		
		window:arrange_menu (frame11, right_side, window.right_start_at, window.top_start_at)
	
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Advanced Plugins Config ~12
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
function window:CreateFrame12()

-------- plugins
	local frame4 = window.options [12][1].gump
	window.plugin_widgets = {}
	
 	local on_enter = function (self)
	
		self:SetBackdropColor (.5, .5, .5, .8)
		
		if (self ["toolbarPluginsIcon" .. self.id]) then
			self ["toolbarPluginsIcon" .. self.id]:SetBlendMode ("ADD")
		elseif (self ["raidPluginsIcon" .. self.id]) then
			self ["raidPluginsIcon" .. self.id]:SetBlendMode ("ADD")
		elseif (self ["soloPluginsIcon" .. self.id]) then
			self ["soloPluginsIcon" .. self.id]:SetBlendMode ("ADD")
		end

		if (self.plugin) then
			local desc = self.plugin:GetPluginDescription()
			if (desc) then
				GameCooltip:Preset (2)
				GameCooltip:AddLine (desc)
				GameCooltip:SetType ("tooltip")
				GameCooltip:SetOwner (self, "bottomleft", "topleft", 150, -2)
				GameCooltip:Show()
			end
		end

		if (self.hasDesc) then
			GameCooltip:Preset (2)
			GameCooltip:AddLine (self.hasDesc)
			GameCooltip:SetType ("tooltip")
			GameCooltip:SetOwner (self, "bottomleft", "topleft", 150, -2)
			GameCooltip:Show()
		end
 	end
	
	local on_leave = function (self)
		self:SetBackdropColor (.3, .3, .3, .3)
		
		if (self ["toolbarPluginsIcon" .. self.id]) then
			self ["toolbarPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
		elseif (self ["raidPluginsIcon" .. self.id]) then
			self ["raidPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
		elseif (self ["soloPluginsIcon" .. self.id]) then
			self ["soloPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
		end

		GameCooltip:Hide()
	end
	
	local y = -20
	
	--> toolbar
	g:NewLabel (frame4, _, "$parentToolbarPluginsLabel", "toolbarLabel", Loc ["STRING_OPTIONS_PLUGINS_TOOLBAR_ANCHOR"], "GameFontNormal", 16)
	frame4.toolbarLabel:SetPoint ("topleft", frame4, "topleft", 10, y)
	
	y = y - 30
	
	do
		local descbar = frame4:CreateTexture (nil, "artwork")
		descbar:SetTexture (.3, .3, .3, .8)
		descbar:SetPoint ("topleft", frame4, "topleft", 5, y+3)
		descbar:SetSize (650, 20)
		g:NewLabel (frame4, _, "$parentDescNameLabel", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
		frame4.descNameLabel:SetPoint ("topleft", frame4, "topleft", 15, y)
		g:NewLabel (frame4, _, "$parentDescAuthorLabel", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
		frame4.descAuthorLabel:SetPoint ("topleft", frame4, "topleft", 180, y)
		g:NewLabel (frame4, _, "$parentDescVersionLabel", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
		frame4.descVersionLabel:SetPoint ("topleft", frame4, "topleft", 290, y)
		g:NewLabel (frame4, _, "$parentDescEnabledLabel", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
		frame4.descEnabledLabel:SetPoint ("topleft", frame4, "topleft", 400, y)
		g:NewLabel (frame4, _, "$parentDescOptionsLabel", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
		frame4.descOptionsLabel:SetPoint ("topleft", frame4, "topleft", 510, y)
	end
	
	y = y - 30
	
	--> toolbar plugins loop
	local i = 1
	local allplugins_toolbar = _detalhes.ToolBar.NameTable --where is store all plugins for the title bar

	--first loop and see which plugins isn't installed
	--then add a 'ghost' plugin so the player can download

	local allExistentToolbarPlugins = {
		{"DETAILS_PLUGIN_CHART_VIEWER", "Details_ChartViewer", "Chart Viewer", "View combat data in handsome charts.", "https://www.curseforge.com/wow/addons/details-chart-viewer-plugin"},
		{"DETAILS_PLUGIN_DEATH_GRAPHICS", "Details_DeathGraphs", "Advanced Death Logs", "Encounter endurance per player (who's dying more), deaths timeline by enemy spells and regular death logs.", "https://www.curseforge.com/wow/addons/details-advanced-death-logs-plug"},
		--{"Details_RaidPowerBars", "Raid Power Bars", "Alternate power bar in a details! window", "https://www.curseforge.com/wow/addons/details_raidpowerbars/"},
		--{"Details_TargetCaller", "Target Caller", "Show raid damage done to an entity since you targetted it.", "https://www.curseforge.com/wow/addons/details-target-caller-plugin"},
		{"DETAILS_PLUGIN_TIME_LINE", "Details_TimeLine", "Time Line", "View raid cooldowns usage, debuff gain, boss casts in a fancy time line.", "https://www.curseforge.com/wow/addons/details_timeline"},
	}

	local allExistentRaidPlugins = {
		--{"DETAILS_PLUGIN_CHART_VIEWER", "Details_ChartViewer", "Chart Viewer", "View combat data in handsome charts.", "https://www.curseforge.com/wow/addons/details-chart-viewer-plugin"},
		--{"DETAILS_PLUGIN_DEATH_GRAPHICS", "Details_DeathGraphs", "Advanced Death Logs", "Encounter endurance per player (who's dying more), deaths timeline by enemy spells and regular death logs.", "https://www.curseforge.com/wow/addons/details-advanced-death-logs-plug"},
		{"DETAILS_PLUGIN_RAID_POWER_BARS", "Details_RaidPowerBars", "Raid Power Bars", "Alternate power bar in a details! window", "https://www.curseforge.com/wow/addons/details_raidpowerbars/"},
		{"DETAILS_PLUGIN_TARGET_CALLER", "Details_TargetCaller", "Target Caller", "Show raid damage done to an entity since you targetted it.", "https://www.curseforge.com/wow/addons/details-target-caller-plugin"},
		--{"DETAILS_PLUGIN_TIME_LINE", "Details_TimeLine", "Time Line", "View raid cooldowns usage, debuff gain, boss casts in a fancy time line.", "https://www.curseforge.com/wow/addons/details_timeline"},
	}	

	local installedToolbarPlugins = {}
	local installedRaidPlugins = {}

	for absName, pluginObject in pairs (allplugins_toolbar) do 
	
		local bframe = CreateFrame ("frame", "OptionsPluginToolbarBG", frame4)
		bframe:SetSize (640, 20)
		bframe:SetPoint ("topleft", frame4, "topleft", 10, y)
		bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
		bframe:SetBackdropColor (.3, .3, .3, .3)
		bframe:SetScript ("OnEnter", on_enter)
		bframe:SetScript ("OnLeave", on_leave)
		bframe.plugin = pluginObject
		bframe.id = i
		
		g:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
		bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", frame4, "topleft", 10, y)
	
		g:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
		bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
		
		g:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
		bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", frame4, "topleft", 180, y-4)
		
		g:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
		bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", frame4, "topleft", 290, y-4)
		
		local plugin_stable = _detalhes:GetPluginSavedTable (absName)
		local plugin = _detalhes:GetPlugin (absName)
		g:NewSwitch (bframe, _, "$parentToolbarSlider"..i, "toolbarPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
		bframe ["toolbarPluginsSlider"..i].PluginName = absName
		tinsert (window.plugin_widgets, bframe ["toolbarPluginsSlider"..i])
		bframe ["toolbarPluginsSlider"..i]:SetPoint ("topleft", frame4, "topleft", 415, y)
		bframe ["toolbarPluginsSlider"..i]:SetAsCheckBox()
		bframe ["toolbarPluginsSlider"..i].OnSwitch = function (self, _, value)
			plugin_stable.enabled = value
			plugin.__enabled = value
			if (value) then
				_detalhes:SendEvent ("PLUGIN_ENABLED", plugin)
			else
				_detalhes:SendEvent ("PLUGIN_DISABLED", plugin)
			end
		end
		
		if (pluginObject.OpenOptionsPanel) then
			g:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 120, 20, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
			bframe ["OptionsButton"..i]:SetPoint ("topleft", frame4, "topleft", 510, y-0)
			--bframe ["OptionsButton"..i]:InstallCustomTexture()
			
			window:CreateLineBackground2 (bframe, "OptionsButton"..i, "OptionsButton"..i, nil, nil, {1, 0.8, 0}, button_color_rgb)
			bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
			bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
		end
		
		i = i + 1
		y = y - 20

		--plugins installed, adding their abs name
		DetailsFramework.table.addunique (installedToolbarPlugins, absName)
	
	end

	local notInstalledColor = "gray"

	for o = 1, #allExistentToolbarPlugins do
		local pluginAbsName = allExistentToolbarPlugins [o] [1]
		if (not DetailsFramework.table.find (installedToolbarPlugins, pluginAbsName)) then

			local absName = pluginAbsName
			local pluginObject = {
				__icon = "",
				__name = allExistentToolbarPlugins [o] [3],
				__author = "Not Installed",
				__version = "",
				OpenOptionsPanel = false,
			}

			local bframe = CreateFrame ("frame", "OptionsPluginToolbarBG", frame4)
			bframe:SetSize (640, 20)
			bframe:SetPoint ("topleft", frame4, "topleft", 10, y)
			bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
			bframe:SetBackdropColor (.3, .3, .3, .3)
			bframe:SetScript ("OnEnter", on_enter)
			bframe:SetScript ("OnLeave", on_leave)
			--bframe.plugin = pluginObject
			bframe.id = i
			bframe.hasDesc = allExistentToolbarPlugins [o] [4]
			
			g:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
			bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", frame4, "topleft", 10, y)
		
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
			bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
			bframe ["toolbarPluginsLabel"..i].color = notInstalledColor
			
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
			bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", frame4, "topleft", 180, y-4)
			bframe ["toolbarPluginsLabel2"..i].color = notInstalledColor
			
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
			bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", frame4, "topleft", 290, y-4)
			bframe ["toolbarPluginsLabel3"..i].color = notInstalledColor

			local installButton = DetailsFramework:CreateButton (bframe, function() Details:CopyPaste (allExistentToolbarPlugins [o] [5]) end, 120, 20, "Install")
			installButton:SetTemplate (options_button_template)
			installButton:SetPoint ("topleft", frame4, "topleft", 510, y-0)
			
			i = i + 1
			y = y - 20			
		end
	end
	
	y = y - 10
	
	--raid
	g:NewLabel (frame4, _, "$parentRaidPluginsLabel", "raidLabel", Loc ["STRING_OPTIONS_PLUGINS_RAID_ANCHOR"], "GameFontNormal", 16)
	frame4.raidLabel:SetPoint ("topleft", frame4, "topleft", 10, y)
	
	y = y - 30
	
	do
		local descbar = frame4:CreateTexture (nil, "artwork")
		descbar:SetTexture (.3, .3, .3, .8)
		descbar:SetPoint ("topleft", frame4, "topleft", 5, y+3)
		descbar:SetSize (650, 20)
		g:NewLabel (frame4, _, "$parentDescNameLabel2", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
		frame4.descNameLabel:SetPoint ("topleft", frame4, "topleft", 15, y)
		g:NewLabel (frame4, _, "$parentDescAuthorLabel2", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
		frame4.descAuthorLabel:SetPoint ("topleft", frame4, "topleft", 180, y)
		g:NewLabel (frame4, _, "$parentDescVersionLabel2", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
		frame4.descVersionLabel:SetPoint ("topleft", frame4, "topleft", 290, y)
		g:NewLabel (frame4, _, "$parentDescEnabledLabel2", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
		frame4.descEnabledLabel:SetPoint ("topleft", frame4, "topleft", 400, y)
		g:NewLabel (frame4, _, "$parentDescOptionsLabel2", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
		frame4.descOptionsLabel:SetPoint ("topleft", frame4, "topleft", 510, y)
	end
	
	y = y - 30
	
	local i = 1
	local allplugins_raid = _detalhes.RaidTables.NameTable
	for absName, pluginObject in pairs (allplugins_raid) do 

		local bframe = CreateFrame ("frame", "OptionsPluginRaidBG", frame4)
		bframe:SetSize (640, 20)
		bframe:SetPoint ("topleft", frame4, "topleft", 10, y)
		bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
		bframe:SetBackdropColor (.3, .3, .3, .3)
		bframe:SetScript ("OnEnter", on_enter)
		bframe:SetScript ("OnLeave", on_leave)
		bframe.plugin = pluginObject
		bframe.id = i
		
		g:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "raidPluginsIcon"..i, "$parentRaidPluginsIcon"..i)
		bframe ["raidPluginsIcon"..i]:SetPoint ("topleft", frame4, "topleft", 10, y)
	
		g:NewLabel (bframe, _, "$parentRaidPluginsLabel"..i, "raidPluginsLabel"..i, pluginObject.__name)
		bframe ["raidPluginsLabel"..i]:SetPoint ("left", bframe ["raidPluginsIcon"..i], "right", 2, 0)
		
		g:NewLabel (bframe, _, "$parentRaidPluginsLabel2"..i, "raidPluginsLabel2"..i, pluginObject.__author)
		bframe ["raidPluginsLabel2"..i]:SetPoint ("topleft", frame4, "topleft", 180, y-4)
		
		g:NewLabel (bframe, _, "$parentRaidPluginsLabel3"..i, "raidPluginsLabel3"..i, pluginObject.__version)
		bframe ["raidPluginsLabel3"..i]:SetPoint ("topleft", frame4, "topleft", 290, y-4)
		
		local plugin_stable = _detalhes:GetPluginSavedTable (absName)
		local plugin = _detalhes:GetPlugin (absName)
		g:NewSwitch (bframe, _, "$parentRaidSlider"..i, "raidPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
		tinsert (window.plugin_widgets, bframe ["raidPluginsSlider"..i])
		bframe ["raidPluginsSlider"..i].PluginName = absName
		bframe ["raidPluginsSlider"..i]:SetPoint ("topleft", frame4, "topleft", 415, y+1)
		bframe ["raidPluginsSlider"..i]:SetAsCheckBox()
		bframe ["raidPluginsSlider"..i].OnSwitch = function (self, _, value)
			plugin_stable.enabled = value
			plugin.__enabled = value
			if (not value) then
				for index, instancia in ipairs (_detalhes.tabela_instancias) do
					if (instancia.modo == 4) then -- 4 = raid
						if (instancia:IsEnabled()) then
							_detalhes:TrocaTabela (instancia, 0, 1, 1, nil, 2)
						else
							instancia.modo = 2 -- group mode
						end
					end
				end
			end
		end
		
		if (pluginObject.OpenOptionsPanel) then
			g:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 86, 18, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
			bframe ["OptionsButton"..i]:SetPoint ("topleft", frame4, "topleft", 510, y-0)
			--bframe ["OptionsButton"..i]:InstallCustomTexture()
			
			window:CreateLineBackground2 (bframe, "OptionsButton"..i, "OptionsButton"..i, nil, nil, {1, 0.8, 0}, button_color_rgb)
			bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
			bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
		end

		--plugins installed, adding their abs name
		DetailsFramework.table.addunique (installedRaidPlugins, absName)
		
		i = i + 1
		y = y - 20
	end

	for o = 1, #allExistentRaidPlugins do
		local pluginAbsName = allExistentRaidPlugins [o] [1]
		if (not DetailsFramework.table.find (installedRaidPlugins, pluginAbsName)) then

			local absName = pluginAbsName
			local pluginObject = {
				__icon = "",
				__name = allExistentRaidPlugins [o] [3],
				__author = "Not Installed",
				__version = "",
				OpenOptionsPanel = false,
			}

			local bframe = CreateFrame ("frame", "OptionsPluginToolbarBG", frame4)
			bframe:SetSize (640, 20)
			bframe:SetPoint ("topleft", frame4, "topleft", 10, y)
			bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
			bframe:SetBackdropColor (.3, .3, .3, .3)
			bframe:SetScript ("OnEnter", on_enter)
			bframe:SetScript ("OnLeave", on_leave)
			--bframe.plugin = pluginObject
			bframe.id = i
			bframe.hasDesc = allExistentRaidPlugins [o] [4]
			
			g:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
			bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", frame4, "topleft", 10, y)
		
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
			bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
			bframe ["toolbarPluginsLabel"..i].color = notInstalledColor
			
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
			bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", frame4, "topleft", 180, y-4)
			bframe ["toolbarPluginsLabel2"..i].color = notInstalledColor
			
			g:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
			bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", frame4, "topleft", 290, y-4)
			bframe ["toolbarPluginsLabel3"..i].color = notInstalledColor

			local installButton = DetailsFramework:CreateButton (bframe, function() Details:CopyPaste (allExistentRaidPlugins [o] [5]) end, 120, 20, "Install")
			installButton:SetTemplate (options_button_template)
			installButton:SetPoint ("topleft", frame4, "topleft", 510, y-0)
			
			i = i + 1
			y = y - 20			
		end
	end	
	
	y = y - 10

	-- solo
	g:NewLabel (frame4, _, "$parentSoloPluginsLabel", "soloLabel", Loc ["STRING_OPTIONS_PLUGINS_SOLO_ANCHOR"], "GameFontNormal", 16)
	frame4.soloLabel:SetPoint ("topleft", frame4, "topleft", 10, y)
	
	y = y - 30
	
	do
		local descbar = frame4:CreateTexture (nil, "artwork")
		descbar:SetTexture (.3, .3, .3, .8)
		descbar:SetPoint ("topleft", frame4, "topleft", 5, y+3)
		descbar:SetSize (650, 20)
		g:NewLabel (frame4, _, "$parentDescNameLabel3", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
		frame4.descNameLabel:SetPoint ("topleft", frame4, "topleft", 15, y)
		g:NewLabel (frame4, _, "$parentDescAuthorLabel3", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
		frame4.descAuthorLabel:SetPoint ("topleft", frame4, "topleft", 180, y)
		g:NewLabel (frame4, _, "$parentDescVersionLabel3", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
		frame4.descVersionLabel:SetPoint ("topleft", frame4, "topleft", 290, y)
		g:NewLabel (frame4, _, "$parentDescEnabledLabel3", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
		frame4.descEnabledLabel:SetPoint ("topleft", frame4, "topleft", 400, y)
		g:NewLabel (frame4, _, "$parentDescOptionsLabel3", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
		frame4.descOptionsLabel:SetPoint ("topleft", frame4, "topleft", 510, y)
	end
	
	y = y - 30
	
	local i = 1
	local allplugins_solo = _detalhes.SoloTables.NameTable
	for absName, pluginObject in pairs (allplugins_solo) do 
	
		local bframe = CreateFrame ("frame", "OptionsPluginSoloBG", frame4)
		bframe:SetSize (640, 20)
		bframe:SetPoint ("topleft", frame4, "topleft", 10, y)
		bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
		bframe:SetBackdropColor (.3, .3, .3, .3)
		bframe:SetScript ("OnEnter", on_enter)
		bframe:SetScript ("OnLeave", on_leave)
		bframe.plugin = pluginObject
		bframe.id = i
		
		g:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "soloPluginsIcon"..i, "$parentSoloPluginsIcon"..i)
		bframe ["soloPluginsIcon"..i]:SetPoint ("topleft", frame4, "topleft", 10, y)
	
		g:NewLabel (bframe, _, "$parentSoloPluginsLabel"..i, "soloPluginsLabel"..i, pluginObject.__name)
		bframe ["soloPluginsLabel"..i]:SetPoint ("left", bframe ["soloPluginsIcon"..i], "right", 2, 0)
		
		g:NewLabel (bframe, _, "$parentSoloPluginsLabel2"..i, "soloPluginsLabel2"..i, pluginObject.__author)
		bframe ["soloPluginsLabel2"..i]:SetPoint ("topleft", frame4, "topleft", 180, y-4)
		
		g:NewLabel (bframe, _, "$parentSoloPluginsLabel3"..i, "soloPluginsLabel3"..i, pluginObject.__version)
		bframe ["soloPluginsLabel3"..i]:SetPoint ("topleft", frame4, "topleft", 290, y-4)
		
		local plugin_stable = _detalhes:GetPluginSavedTable (absName)
		local plugin = _detalhes:GetPlugin (absName)
		g:NewSwitch (bframe, _, "$parentSoloSlider"..i, "soloPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
		tinsert (window.plugin_widgets, bframe ["soloPluginsSlider"..i])
		bframe ["soloPluginsSlider"..i].PluginName = absName
		bframe ["soloPluginsSlider"..i]:SetPoint ("topleft", frame4, "topleft", 415, y+1)
		bframe ["soloPluginsSlider"..i]:SetAsCheckBox()
		bframe ["soloPluginsSlider"..i].OnSwitch = function (self, _, value)
			plugin_stable.enabled = value
			plugin.__enabled = value
			if (not value) then
				for index, instancia in ipairs (_detalhes.tabela_instancias) do
					if (instancia.modo == 1 and instancia.baseframe) then -- 1 = solo
						_detalhes:TrocaTabela (instancia, 0, 1, 1, nil, 2)
					end
				end
			end
		end
		
		if (pluginObject.OpenOptionsPanel) then
			g:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 86, 18, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
			bframe ["OptionsButton"..i]:SetPoint ("topleft", frame4, "topleft", 510, y-0)
			--bframe ["OptionsButton"..i]:InstallCustomTexture()
			
			window:CreateLineBackground2 (bframe, "OptionsButton"..i, "OptionsButton"..i, nil, nil, {1, 0.8, 0}, button_color_rgb)
			bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
			bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
		end
		
		i = i + 1
		y = y - 20
	end

end
	
	--> create the frames
	if (InCombatLockdown()) then

		window.IsLoading = true

		if (not _detalhes.LoadingOptionsPanelFrame) then
			_detalhes.LoadingOptionsPanelFrame = CreateFrame ("frame", "LoadingOptionsPanelFrame", UIParent)
			_detalhes.LoadingOptionsPanelFrame:SetSize (390, 75)
			_detalhes.LoadingOptionsPanelFrame:SetPoint ("center")
			_detalhes.LoadingOptionsPanelFrame:SetFrameStrata ("TOOLTIP")
			_detalhes.gump:ApplyStandardBackdrop (_detalhes.LoadingOptionsPanelFrame)
			_detalhes.LoadingOptionsPanelFrame:SetBackdropBorderColor (1, 0.8, 0.1)
			
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel1 = _detalhes.gump:CreateLabel (_detalhes.LoadingOptionsPanelFrame, "Details! is Safe Loading the Options Panel During Combat")
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel2 = _detalhes.gump:CreateLabel (_detalhes.LoadingOptionsPanelFrame, "This may take only a few seconds")
			_detalhes.LoadingOptionsPanelFrame.IsLoadingImage1 = _detalhes.gump:CreateImage (_detalhes.LoadingOptionsPanelFrame, [[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]], 32, 32)
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel1.align = "center"
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel2.align = "center"
			
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel1:SetPoint ("center", 16, 10)
			_detalhes.LoadingOptionsPanelFrame.IsLoadingLabel2:SetPoint ("center", 16, -5)
			_detalhes.LoadingOptionsPanelFrame.IsLoadingImage1:SetPoint ("left", 10, 0)
			
			_detalhes.LoadingOptionsPanelFrame.ProgressBar = _detalhes.gump:CreateBar (_detalhes.LoadingOptionsPanelFrame, "Details Serenity", 300, 20, 0)
			_detalhes.LoadingOptionsPanelFrame.ProgressBar:SetPoint ("center", 0, -25)
		end
	
		local panel_index = 1
		local percent_string = g:NewLabel (window, nil, nil, "percent_string", "loading: 0%", "GameFontNormal", 12)
		percent_string.textcolor = "white"
		percent_string:SetPoint ("bottomleft", window, "bottomleft", 340, 12)
		local step = 5 -- 100/quantidade de menus
		
		function _detalhes:create_options_panels()
		
			window ["CreateFrame" .. panel_index]()

			if (panel_index == 20) then
				_detalhes:CancelTimer (window.create_thread)
				window:create_left_menu()
				
				percent_string.hide = true
				_G.DetailsOptionsWindow.full_created = true
				
				local first_button = all_buttons [1]
				last_pressed = first_button
				first_button.widget.text:SetPoint ("left", first_button.widget, "left", 3, -1)
				first_button.textcolor = selected_textcolor
				
				_detalhes.LoadingOptionsPanelFrame:Hide()
				window.IsLoading = false
			else
				percent_string.text = "wait... " .. math.floor (step * panel_index) .. "%"
				_detalhes.LoadingOptionsPanelFrame.ProgressBar.value = (step * panel_index)
			end

			panel_index = panel_index + 1
			
		end
		
		window.create_thread = _detalhes:ScheduleRepeatingTimer ("create_options_panels", 0.1)
		
	else
		
		for i = 1, 20 do
			window ["CreateFrame" .. i]()
		end
		window:create_left_menu()
		
		_G.DetailsOptionsWindow.full_created = true

		local first_button = all_buttons [1]
		last_pressed = first_button
		first_button.widget.text:SetPoint ("left", first_button.widget, "left", 3, -1)
		first_button.textcolor = selected_textcolor
		
	end

	select_options (1)

	DetailsOptionsWindow.loading_settings = nil
	
end --> if not window

----------------------------------------------------------------------------------------
--> Show

	local strata = {
		["BACKGROUND"] = "Background",
		["LOW"] = "Low",
		["MEDIUM"] = "Medium",
		["HIGH"] = "High",
		["DIALOG"] = "Dialog"
	}

	function _detalhes:DelayUpdateWindowControls (editing_instance)
		_G.DetailsOptionsWindow1LockButton.MyObject:SetClickFunction (_detalhes.lock_instance_function, editing_instance.baseframe.lock_button)
		if (editing_instance.baseframe.isLocked) then
			_G.DetailsOptionsWindow1LockButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_UNLOCK"])
		else
			_G.DetailsOptionsWindow1LockButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_LOCK"])
		end
	end
	
	function window:update_microframes()
	
		local instance = _G.DetailsOptionsWindow.instance
	
		local hide_left_button = _G.DetailsOptionsWindow6MicroDisplayLeftDropdown.MyObject.HideLeftMicroFrameButton
		if (instance.StatusBar ["left"].options.isHidden) then
			hide_left_button:GetNormalTexture():SetDesaturated (false)
		else
			hide_left_button:GetNormalTexture():SetDesaturated (true)
		end
		
		local hide_center_button = _G.DetailsOptionsWindow6MicroDisplayCenterDropdown.MyObject.HideCenterMicroFrameButton
		if (instance.StatusBar ["center"].options.isHidden) then
			hide_center_button:GetNormalTexture():SetDesaturated (false)
		else
			hide_center_button:GetNormalTexture():SetDesaturated (true)
		end
		
		local hide_right_button = _G.DetailsOptionsWindow6MicroDisplayRightDropdown.MyObject.HideRightMicroFrameButton
		if (instance.StatusBar ["right"].options.isHidden) then
			hide_right_button:GetNormalTexture():SetDesaturated (false)
		else
			hide_right_button:GetNormalTexture():SetDesaturated (true)
		end
		
		local left = instance.StatusBar ["left"].__name
		local center = instance.StatusBar ["center"].__name
		local right = instance.StatusBar ["right"].__name
		
		_G.DetailsOptionsWindow6MicroDisplayLeftDropdown.MyObject:Select (left)
		_G.DetailsOptionsWindow6MicroDisplayCenterDropdown.MyObject:Select (center)
		_G.DetailsOptionsWindow6MicroDisplayRightDropdown.MyObject:Select (right)

		if (not instance.show_statusbar and instance.micro_displays_side == 2) then
			_G.DetailsOptionsWindow6.MicroDisplayWarningLabel:Show()
		else
			_G.DetailsOptionsWindow6.MicroDisplayWarningLabel:Hide()
		end
	end

	function window:update_all (editing_instance, section)

		DetailsOptionsWindow.loading_settings = true
	
		--> window 1
		_G.DetailsOptionsWindow1RealmNameSlider.MyObject:SetValue (_detalhes.remove_realm_from_name)
		_G.DetailsOptionsWindow1SegmentsLockedSlider.MyObject:SetValue (_detalhes.instances_segments_locked) --locked segments
		
		_G.DetailsOptionsWindow1NumericalSystemOfADropdown.MyObject:Select (_detalhes.numerical_system)
		
		_G.DetailsOptionsWindow1WheelSpeedSlider.MyObject:SetValue (_detalhes.scroll_speed)
		_G.DetailsOptionsWindow1SliderMaxInstances.MyObject:SetValue (_detalhes.instances_amount)
		_G.DetailsOptionsWindow1AbbreviateDropdown.MyObject:Select (_detalhes.ps_abbreviation)
		_G.DetailsOptionsWindow1SliderUpdateSpeed.MyObject:SetValue (_detalhes.update_speed)
		_G.DetailsOptionsWindow1AnimateSlider.MyObject:SetValue (_detalhes.use_row_animations)
		
		_G.DetailsOptionsWindow1WindowControlsAnchor:SetText (string.format (Loc ["STRING_OPTIONS_WC_ANCHOR"], editing_instance.meu_id))
		
		_G.DetailsOptionsWindow1EraseDataDropdown.MyObject:Select (_detalhes.segments_auto_erase)
		
		if (not editing_instance.baseframe) then
			_detalhes:ScheduleTimer ("DelayUpdateWindowControls", 1, editing_instance)
		else
			_G.DetailsOptionsWindow1LockButton.MyObject:SetClickFunction (_detalhes.lock_instance_function, editing_instance.baseframe.lock_button)
			if (editing_instance.baseframe.isLocked) then
				_G.DetailsOptionsWindow1LockButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_UNLOCK"])
			else
				_G.DetailsOptionsWindow1LockButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_LOCK"])
			end
			
			_G.DetailsOptionsWindow1clickThroughInCombatSlider.MyObject:SetValue (editing_instance.clickthrough_incombatonly)
			_G.DetailsOptionsWindow1clickThroughWindowSlider.MyObject:SetValue (editing_instance.clickthrough_window)
			_G.DetailsOptionsWindow1clickThroughBarsSlider.MyObject:SetValue (editing_instance.clickthrough_rows)  
		end
		
		_G.DetailsOptionsWindow1BreakSnapButton.MyObject:Disable()
		
		for side, have_snap in pairs (editing_instance.snap) do 
			if (have_snap) then
				_G.DetailsOptionsWindow1BreakSnapButton.MyObject:Enable()
				_G.DetailsOptionsWindow1BreakSnapButton.MyObject:SetClickFunction (editing_instance.Desagrupar, editing_instance, -1)
				break
			end
		end

		if (editing_instance.ativa) then
			_G.DetailsOptionsWindow1CloseButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_CLOSE"])
			_G.DetailsOptionsWindow1CloseButton.MyObject:SetClickFunction (_detalhes.close_instancia_func, editing_instance.baseframe.cabecalho.fechar)
		else
			_G.DetailsOptionsWindow1CloseButton.MyObject:SetText (Loc ["STRING_OPTIONS_WC_REOPEN"])
			_G.DetailsOptionsWindow1CloseButton.MyObject:SetClickFunction (function() _detalhes:CriarInstancia (_, editing_instance.meu_id) end)
		end
		
		--> window 2
		_G.DetailsOptionsWindow2FragsPvpSlider.MyObject:SetValue (_detalhes.only_pvp_frags)
		_G.DetailsOptionsWindow1TTDropdown.MyObject:Select (_detalhes.time_type)
		_G.DetailsOptionsWindow2DeathLogLimitDropdown.MyObject:Select (_detalhes.deadlog_events)

		_G.DetailsOptionsWindow2OverallDataRaidBossSlider.MyObject:SetValue (bit.band (_detalhes.overall_flag, 0x1) ~= 0)
		_G.DetailsOptionsWindow2OverallDataRaidCleaupSlider.MyObject:SetValue (bit.band (_detalhes.overall_flag, 0x2) ~= 0)
		_G.DetailsOptionsWindow2OverallDataDungeonBossSlider.MyObject:SetValue (bit.band (_detalhes.overall_flag, 0x4) ~= 0)
		_G.DetailsOptionsWindow2OverallDataDungeonCleaupSlider.MyObject:SetValue (bit.band (_detalhes.overall_flag, 0x8) ~= 0)
		
		local overall_state = bit.band (_detalhes.overall_flag, 0x10) ~= 0
		_G.DetailsOptionsWindow2OverallDataAllSlider.MyObject:SetValue (overall_state)
		if (overall_state) then
			_G.DetailsOptionsWindow2:OverallSliderEnabled()
		else
			_G.DetailsOptionsWindow2:OverallSliderDisabled()
		end
		
		_G.DetailsOptionsWindow2OverallNewBossSlider.MyObject:SetValue (_detalhes.overall_clear_newboss)
		_G.DetailsOptionsWindow2OverallNewChallengeSlider.MyObject:SetValue (_detalhes.overall_clear_newchallenge)
		_G.DetailsOptionsWindow2OverallOnLogoutSlider.MyObject:SetValue (_detalhes.overall_clear_logout)
		
		_G.DetailsOptionsWindow2RemoteParserSlider.MyObject:SetValue (_detalhes.use_battleground_server_parser)
		_G.DetailsOptionsWindow2ShowAllSlider.MyObject:SetValue (_detalhes.pvp_as_group)

		--damage taken advanced
		_G.DetailsOptionsWindow2DamageTakenEverythingSlider.MyObject:SetValue (_detalhes.damage_taken_everything)
		
		--healing done mim on death log
		_G.DetailsOptionsWindow2DeathLogHealingThresholdSlider.MyObject:SetValue (_detalhes.deathlog_healingdone_min)
		
		--always show all players (consider they as in group)
		_G.DetailsOptionsWindow2AlwaysShowPlayersSlider.MyObject:SetValue (_detalhes.all_players_are_group)

		--> window 3
		
		local skin = editing_instance.skin
		local frame3 = _G.DetailsOptionsWindow3
		
		_G.DetailsOptionsWindow3CustomTextureEntry:SetText (editing_instance.skin_custom)
		
		_G.DetailsOptionsWindow3SkinDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow3SkinDropdown.MyObject:Select (skin)
		
		_G.DetailsOptionsWindow3PDWSkinDropdown.MyObject:Select (_detalhes.player_details_window.skin)
		
		local skin_object = editing_instance:GetSkin()
		local skin_name_formated = skin:gsub (" ", "")
		
		_G.DetailsOptionsWindow3ChatTabEmbedEnabledSlider.MyObject:SetValue (_detalhes.chat_tab_embed.enabled)
		_G.DetailsOptionsWindow3ChatTabEmbedNameEntry.MyObject.text = _detalhes.chat_tab_embed.tab_name
		_G.DetailsOptionsWindow3ChatTabEmbed2WindowsSlider.MyObject:SetValue (_detalhes.chat_tab_embed.single_window)
		_G.DetailsOptionsWindow3ChatTabEmbedSizeCorrectionSlider.MyObject:SetValue (_detalhes.chat_tab_embed.x_offset)
		_G.DetailsOptionsWindow3ChatTabEmbedSizeCorrection2Slider.MyObject:SetValue (_detalhes.chat_tab_embed.y_offset)
		
		--> hide all
		for name, _ in pairs (_detalhes.skins) do
			local name = name:gsub (" ", "")
			for index, t in ipairs (frame3.ExtraOptions [name] or {}) do
				t[1]:Hide()
				t[2]:Hide()
			end
		end
		
		for _, frame in pairs (frame3.ExtraOptions) do
			frame:Hide()
		end
		
		--> create or show options if necessary ~extra
		if (skin_object.skin_options and not skin_object.options_created) then
			skin_object.options_created = true

			local f = CreateFrame ("frame", "DetailsSkinOptions" .. skin_name_formated, frame3)
			frame3.ExtraOptions [skin_name_formated] = f
			f:SetPoint ("topleft", frame3, "topleft", window.right_start_at, window.top_start_at + (25 * -1))
			f:SetPoint ("topleft", frame3.SkinExtraOptionsAnchor.widget, "bottomleft", 0, -10)
			f:SetSize (250, 400)

			g:BuildMenu (f, skin_object.skin_options, 0, 0, 400, nil, nil, nil, nil, nil, nil, g:GetTemplate ("button", "DETAILS_SKIN_OPTION_BUTTON_TEMPLATE"))

		elseif (skin_object.skin_options) then
			frame3.ExtraOptions [skin_name_formated]:Show()
		end
		
		--> window 4
		
		_G.DetailsOptionsWindow4CustomTextureEntry:SetText (editing_instance.row_info.texture_custom)
		
		_G.DetailsOptionsWindow4OrientationDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4OrientationDropdown.MyObject:Select (editing_instance.bars_inverted and 2 or 1, true)
		_G.DetailsOptionsWindow4SortDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4SortDropdown.MyObject:Select (editing_instance.bars_sort_direction, true)
		_G.DetailsOptionsWindow4GrowDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4GrowDropdown.MyObject:Select (editing_instance.bars_grow_direction, true)
		
		_G.DetailsOptionsWindow4BarSpacementSizeSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BarSpacementSizeSlider.MyObject:SetValue (editing_instance.row_info.space.between)
		
		_G.DetailsOptionsWindow4BarStartSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BarStartSlider.MyObject:SetValue (editing_instance.row_info.start_after_icon)

		_G.DetailsOptionsWindow4BackdropBorderTextureDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BackdropEnabledSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BackdropSizeHeight.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BackdropBorderTextureDropdown.MyObject:Select (editing_instance.row_info.backdrop.texture)
		_G.DetailsOptionsWindow4BackdropEnabledSlider.MyObject:SetValue (editing_instance.row_info.backdrop.enabled)
		_G.DetailsOptionsWindow4BackdropSizeHeight.MyObject:SetValue (editing_instance.row_info.backdrop.size)
		_G.DetailsOptionsWindow4BackdropColorPick.MyObject:SetColor (unpack (editing_instance.row_info.backdrop.color))
		
		_G.DetailsOptionsWindow4IconSelectDropdown.MyObject:Select (false)
		local default
		if (editing_instance.row_info.use_spec_icons) then
			default = editing_instance.row_info.spec_file
		else
			default = editing_instance.row_info.icon_file
		end
		_G.DetailsOptionsWindow4IconSelectDropdown.MyObject:Select (default)
		_G.DetailsOptionsWindow4IconFileEntry:SetText (default)
		
		--disable bar highlight
		_G.DetailsOptionsWindow4DisableBarHighlightSlider.MyObject:SetValue (_detalhes.instances_disable_bar_highlight)
		
		--> window 5
		
		_G.DetailsOptionsWindow5PercentDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5PercentDropdown.MyObject:Select (editing_instance.row_info.percent_type)
		
		_G.DetailsOptionsWindow5CutomLeftTextSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5CutomLeftTextSlider.MyObject:SetValue (editing_instance.row_info.textL_enable_custom_text)
		
		_G.DetailsOptionsWindow5CutomRightTextSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5CutomRightTextSlider.MyObject:SetValue (editing_instance.row_info.textR_enable_custom_text)

		local text = editing_instance.row_info.textL_custom_text
		_G.DetailsOptionsWindow5CutomLeftTextEntry.MyObject:SetText (text)
		
		local text = editing_instance.row_info.textR_custom_text
		_G.DetailsOptionsWindow5CutomRightTextEntry.MyObject:SetText (text)
		
		_G.DetailsOptionsWindow5PositionNumberSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5PositionNumberSlider.MyObject:SetValue (editing_instance.row_info.textL_show_number)

		_G.DetailsOptionsWindow5TranslitTextSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5TranslitTextSlider.MyObject:SetValue (editing_instance.row_info.textL_translit_text)

		_G.DetailsOptionsWindow5BracketDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5SeparatorDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5RightTextShowTotalSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5RightTextShowPSSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5RightTextShowPercentSlider.MyObject:SetFixedParameter (editing_instance)
		
		_G.DetailsOptionsWindow5BracketDropdown.MyObject:Select (editing_instance.row_info.textR_bracket)
		_G.DetailsOptionsWindow5SeparatorDropdown.MyObject:Select (editing_instance.row_info.textR_separator)
		_G.DetailsOptionsWindow5RightTextShowTotalSlider.MyObject:SetValue (editing_instance.row_info.textR_show_data [1])
		_G.DetailsOptionsWindow5RightTextShowPSSlider.MyObject:SetValue (editing_instance.row_info.textR_show_data [2])
		_G.DetailsOptionsWindow5RightTextShowPercentSlider.MyObject:SetValue (editing_instance.row_info.textR_show_data [3])

		_G.DetailsOptionsWindow5UseClassColorsLeftTextSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5UseClassColorsLeftTextSlider.MyObject:SetValue (editing_instance.row_info.textL_class_colors)
		_G.DetailsOptionsWindow5UseClassColorsRightTextSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5UseClassColorsRightTextSlider.MyObject:SetValue (editing_instance.row_info.textR_class_colors)
		
		local r, g, b, a = unpack (editing_instance.row_info.textL_outline_small_color)
		_G.DetailsOptionsWindow5OutlineSmallColorLeft.MyObject:SetColor (r, g, b, a)
		
		_G.DetailsOptionsWindow5TextLeftOutlineSmallSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5TextLeftOutlineSmallSlider.MyObject:SetValue (editing_instance.row_info.textL_outline_small)
		
		_G.DetailsOptionsWindow5TextLeftOutlineSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5TextLeftOutlineSlider.MyObject:SetValue (editing_instance.row_info.textL_outline)
		--
		local r, g, b, a = unpack (editing_instance.row_info.textR_outline_small_color)
		_G.DetailsOptionsWindow5OutlineSmallColorRight.MyObject:SetColor (r, g, b, a)
		
		_G.DetailsOptionsWindow5TextRightOutlineSmallSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5TextRightOutlineSmallSlider.MyObject:SetValue (editing_instance.row_info.textR_outline_small)
		
		_G.DetailsOptionsWindow5TextRightOutlineSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5TextRightOutlineSlider.MyObject:SetValue (editing_instance.row_info.textR_outline)
		
		--> window 6
		_G.DetailsOptionsWindow6BackdropDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6BackdropDropdown.MyObject:Select (editing_instance.backdrop_texture)
		
		local r, g, b = unpack (editing_instance.statusbar_info.overlay)
		_G.DetailsOptionsWindow6StatusbarColorPick.MyObject:SetColor (r, g, b, editing_instance.statusbar_info.alpha)
		
		_G.DetailsOptionsWindow6StrataDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6StrataDropdown.MyObject:Select (strata [editing_instance.strata] or "Low")
		
		_G.DetailsOptionsWindow6StretchAlwaysOnTopSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6StretchAlwaysOnTopSlider.MyObject:SetValue (editing_instance.grab_on_top)
		
		_G.DetailsOptionsWindow6IgnoreMassShowHideSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6IgnoreMassShowHideSlider.MyObject:SetValue (editing_instance.ignore_mass_showhide)
		
		_G.DetailsOptionsWindow6InstanceMicroDisplaysSideSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6InstanceMicroDisplaysSideSlider.MyObject:SetValue (editing_instance.micro_displays_side)

		_G.DetailsOptionsWindow6WindowScaleSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6WindowScaleSlider.MyObject:SetValue (editing_instance.window_scale)
		
		_G.DetailsOptionsWindow6LockMiniDisplaysSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6LockMiniDisplaysSlider.MyObject:SetValue (editing_instance.micro_displays_locked)

		----
		
		_G.DetailsOptionsWindow6MicroDisplayLeftDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6MicroDisplayCenterDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6MicroDisplayRightDropdown.MyObject:SetFixedParameter (editing_instance)
		
		--scroll bar
		_G.DetailsOptionsWindow6UseScrollSlider.MyObject:SetValue (_detalhes.use_scroll)
		--disabled groups
		_G.DetailsOptionsWindow6DisableGroupsSlider.MyObject:SetValue (_detalhes.disable_window_groups)
		--disable lock resize ungroup buttons
		_G.DetailsOptionsWindow6DisableLockResizeUngroupSlider.MyObject:SetValue (_detalhes.disable_lock_ungroup_buttons) 
		--disable stretch
		_G.DetailsOptionsWindow6DisableStretchButtonSlider.MyObject:SetValue (_detalhes.disable_stretch_button)
		
		--_detalhes.StatusBar.Plugins[1].real_name
		--_detalhes.StatusBar.Plugins[1].__name

		window:update_microframes()

		--> window 7
		_G.DetailsOptionsWindow7MenuIconShadowSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7MenuIconShadowSlider.MyObject:SetValue (editing_instance.menu_icons.shadow)
		_G.DetailsOptionsWindow7MenuIconSpaceSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7MenuIconSpaceSlider.MyObject:SetValue (editing_instance.menu_icons.space)
		
		_G.DetailsOptionsWindow7AutoHideLeftMenuSwitch.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7AutoHideLeftMenuSwitch.MyObject:SetValue (editing_instance.auto_hide_menu.left)
		
		_G.DetailsOptionsWindow7MenuAnchorSideSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7MenuAnchorSideSlider.MyObject:SetValue (editing_instance.menu_anchor.side)
		
		_G.DetailsOptionsWindow7:update_icon_buttons (editing_instance)
		
		_G.DetailsOptionsWindow7PluginIconsDirectionSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7PluginIconsDirectionSlider.MyObject:SetValue (editing_instance.plugins_grow_direction)	
		
		_G.DetailsOptionsWindow7DesaturateMenuSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7DesaturateMenuSlider.MyObject:SetValue (editing_instance.desaturated_menu)
		
		_G.DetailsOptionsWindow7HideIconSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7HideIconSlider.MyObject:SetValue (editing_instance.hide_icon)
		
		_G.DetailsOptionsWindow7MenuIconSizeSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7MenuIconSizeSlider.MyObject:SetValue (editing_instance.menu_icons_size)	
		
		_G.DetailsOptionsWindow7MenuAnchorXSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7MenuAnchorYSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow7:update_menuanchor_xy (editing_instance)

		--click to open menus
		_G.DetailsOptionsWindow7ClickToOpenMenusSlider.MyObject:SetValue (_detalhes.instances_menu_click_to_open)
		--menu font
		_G.DetailsOptionsWindow7FontDropdown.MyObject:Select (_detalhes.font_faces.menus)
		--disable reset
		_G.DetailsOptionsWindow7DisableResetSlider.MyObject:SetValue (_detalhes.disable_reset_button)
		--menu font size
		_G.DetailsOptionsWindow7MenuTextSizeSlider.MyObject:SetValue (_detalhes.font_sizes.menus)
		--disable all displays on titlebar right click
		_G.DetailsOptionsWindow7DisableAllDisplaysWindowSlider.MyObject:SetValue (_detalhes.disable_alldisplays_window)
		
		--> window 8

		_G.DetailsOptionsWindow8ModelUpperEnabledSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8ModelUpperEnabledSlider.MyObject:SetValue (editing_instance.row_info.models.upper_enabled)
		
		_G.DetailsOptionsWindow8ModelLowerEnabledSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8ModelLowerEnabledSlider.MyObject:SetValue (editing_instance.row_info.models.lower_enabled)
		
		_G.DetailsOptionsWindow8ModelUpperAlphaSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8ModelUpperAlphaSlider.MyObject:SetValue (editing_instance.row_info.models.upper_alpha)
		
		_G.DetailsOptionsWindow8ModelLowerAlphaSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8ModelLowerAlphaSlider.MyObject:SetValue (editing_instance.row_info.models.lower_alpha)
		
		_G.DetailsOptionsWindow8BarUpdateRateSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8BarUpdateRateSlider.MyObject:SetValue (editing_instance.row_info.fast_ps_update)

		_G.DetailsOptionsWindow8ShowMeSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8ShowMeSlider.MyObject:SetValue (editing_instance.following.enabled)
		
		_G.DetailsOptionsWindow8TotalBarSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8TotalBarSlider.MyObject:SetValue (editing_instance.total_bar.enabled)
		
		_G.DetailsOptionsWindow8TotalBarColorPick.MyObject:SetColor (unpack (editing_instance.total_bar.color))
		
		_G.DetailsOptionsWindow8TotalBarOnlyInGroupSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow8TotalBarOnlyInGroupSlider.MyObject:SetValue (editing_instance.total_bar.only_in_group)
		_G.DetailsOptionsWindow8TotalBarIconTexture.MyObject:SetTexture (editing_instance.total_bar.icon)
		
		--> window 10	
		
		_G.DetailsOptionsWindow10RemoveTrashSlider.MyObject:SetValue (_detalhes.trash_auto_remove)
		_G.DetailsOptionsWindow10WorldAsTrashSlider.MyObject:SetValue (_detalhes.world_combat_is_trash)

		_G.DetailsOptionsWindow10PanicModeSlider.MyObject:SetValue (_detalhes.segments_panic_mode)
		_G.DetailsOptionsWindow10ClearAnimateScrollSlider.MyObject:SetValue (_detalhes.animate_scroll)
		_G.DetailsOptionsWindow10SliderSegmentsSave.MyObject:SetValue (_detalhes.segments_amount_to_save)
		
		_G.DetailsOptionsWindow10CaptureDamageSlider.MyObject:SetValue (_detalhes.capture_real ["damage"])
		_G.DetailsOptionsWindow10CaptureHealSlider.MyObject:SetValue (_detalhes.capture_real ["heal"])
		_G.DetailsOptionsWindow10CaptureEnergySlider.MyObject:SetValue (_detalhes.capture_real ["energy"])
		_G.DetailsOptionsWindow10CaptureMiscSlider.MyObject:SetValue (_detalhes.capture_real ["miscdata"])
		_G.DetailsOptionsWindow10CaptureAuraSlider.MyObject:SetValue (_detalhes.capture_real ["aura"])
		
		--cloud capture
		_G.DetailsOptionsWindow10CloudAuraSlider.MyObject:SetValue (_detalhes.cloud_capture)
		--erase charts
		_G.DetailsOptionsWindow10EraseChartDataSlider.MyObject:SetValue (_detalhes.clear_graphic)
		--segments amount
		_G.DetailsOptionsWindow10Slider.MyObject:SetValue (_detalhes.segments_amount) --segments
		
		
		--> window 11

		--> window 12
		
		for _, slider in ipairs (window.plugin_widgets) do
			local plugin_stable = _detalhes:GetPluginSavedTable (slider.PluginName)
			slider:SetValue (plugin_stable.enabled)
		end
		
		--> window 13
		_G.DetailsOptionsWindow13SelectProfileDropdown.MyObject:Select (_detalhes:GetCurrentProfileName())
		_G.DetailsOptionsWindow13SelectProfileDropdown.MyObject:SetFixedParameter (editing_instance)
		
		_G.DetailsOptionsWindow13PosAndSizeSlider.MyObject:SetValue (_detalhes.profile_save_pos)
		--_G.DetailsOptionsWindow13AlwaysUseSlider.MyObject:SetValue (_detalhes.always_use_profile)
		
		_G.DetailsOptionsWindow13:update_profile_settings()

		--> window 14

		_G.DetailsOptionsWindow14AttributeEnabledSwitch.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeAnchorXSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeAnchorYSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeFontDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeTextSizeSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeShadowSwitch.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeEncounterTimerSwitch.MyObject:SetFixedParameter (editing_instance)
		
		_G.DetailsOptionsWindow14AttributeEnabledSwitch.MyObject:SetValue (editing_instance.attribute_text.enabled)
		_G.DetailsOptionsWindow14AttributeAnchorXSlider.MyObject:SetValue (editing_instance.attribute_text.anchor [1])
		_G.DetailsOptionsWindow14AttributeAnchorYSlider.MyObject:SetValue (editing_instance.attribute_text.anchor [2])
		_G.DetailsOptionsWindow14AttributeFontDropdown.MyObject:Select (editing_instance.attribute_text.text_face)
		_G.DetailsOptionsWindow14AttributeTextSizeSlider.MyObject:SetValue (tonumber (editing_instance.attribute_text.text_size))
		_G.DetailsOptionsWindow14AttributeTextColorPick.MyObject:SetColor (unpack (editing_instance.attribute_text.text_color))
		_G.DetailsOptionsWindow14AttributeShadowSwitch.MyObject:SetValue (editing_instance.attribute_text.shadow)
		_G.DetailsOptionsWindow14AttributeEncounterTimerSwitch.MyObject:SetValue (editing_instance.attribute_text.show_timer [1])

		_G.DetailsOptionsWindow14AttributeSideSwitch.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow14AttributeSideSwitch.MyObject:SetValue (editing_instance.attribute_text.side)
		
		--> window 16
		_G.DetailsOptionsWindow16UserTimeCapturesFillPanel.MyObject:Refresh()
		
		--> window 18
		_G.DetailsOptionsWindow18EventTrackerSlider.MyObject:SetValue (_detalhes.event_tracker.enabled)
		_G.DetailsOptionsWindow18CurrentDPSSlider.MyObject:SetValue (_detalhes.current_dps_meter.enabled)
		_G.DetailsOptionsWindow18NoAlertsSlider.MyObject:SetValue (_detalhes.streamer_config.no_alerts)
		_G.DetailsOptionsWindow18FasterUpdatesSlider.MyObject:SetValue (_detalhes.streamer_config.faster_updates)
		_G.DetailsOptionsWindow18QuickDetectionSlider.MyObject:SetValue (_detalhes.streamer_config.quick_detection)
		_G.DetailsOptionsWindow18DisableMythicDungeonSlider.MyObject:SetValue (_detalhes.streamer_config.disable_mythic_dungeon)
		_G.DetailsOptionsWindow18DisableMythicDungeonChartSlider.MyObject:SetValue (_detalhes.mythic_plus.show_damage_graphic)
		_G.DetailsOptionsWindow18ClearCacheSlider.MyObject:SetValue (_detalhes.streamer_config.reset_spec_cache)
		--_G.DetailsOptionsWindow18AdvancedAnimationsSlider.MyObject:SetValue (_detalhes.streamer_config.use_animation_accel)
		
		--> window 17
		_G.DetailsOptionsWindow17CombatAlphaDropdown.MyObject:Select (editing_instance.hide_in_combat_type, true)
		_G.DetailsOptionsWindow17HideOnCombatAlphaSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow17HideOnCombatAlphaSlider.MyObject:SetValue (editing_instance.hide_in_combat_alpha)
		
		_G.DetailsOptionsWindow17MenuOnEnterLeaveAlphaSwitch.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow17MenuOnEnterAlphaSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow17MenuOnLeaveAlphaSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow17MenuOnEnterLeaveAlphaIconsTooSwitch.MyObject:SetFixedParameter (editing_instance)	
		
		_G.DetailsOptionsWindow17MenuOnEnterAlphaSlider.MyObject:SetValue (editing_instance.menu_alpha.onenter)
		_G.DetailsOptionsWindow17MenuOnLeaveAlphaSlider.MyObject:SetValue (editing_instance.menu_alpha.onleave)
		_G.DetailsOptionsWindow17MenuOnEnterLeaveAlphaSwitch.MyObject:SetValue (editing_instance.menu_alpha.enabled)
		_G.DetailsOptionsWindow17MenuOnEnterLeaveAlphaIconsTooSwitch.MyObject:SetValue (editing_instance.menu_alpha.ignorebars)
		
		--> window 18
		
		--auto switch
		local switch_tank_in_combat = editing_instance.switch_tank_in_combat
		if (switch_tank_in_combat) then
			if (switch_tank_in_combat [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_tank_in_combat[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchTankCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchTankCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchTankCombatDropdown.MyObject:Select (switch_tank_in_combat[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchTankCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_tank = editing_instance.switch_tank
		if (switch_tank) then
			if (switch_tank [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_tank[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchTankNoCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchTankNoCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchTankNoCombatDropdown.MyObject:Select (switch_tank[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchTankNoCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_healer_in_combat = editing_instance.switch_healer_in_combat
		if (switch_healer_in_combat) then
			if (switch_healer_in_combat [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_healer_in_combat[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchHealCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchHealCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchHealCombatDropdown.MyObject:Select (switch_healer_in_combat[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchHealCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_healer = editing_instance.switch_healer
		if (switch_healer) then
			if (switch_healer [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_healer[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchHealNoCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchHealNoCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchHealNoCombatDropdown.MyObject:Select (switch_healer[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchHealNoCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_damager_in_combat = editing_instance.switch_damager_in_combat
		if (switch_damager_in_combat) then
			if (switch_damager_in_combat [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_damager_in_combat[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchDamageCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchDamageCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchDamageCombatDropdown.MyObject:Select (switch_damager_in_combat[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchDamageCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_damager = editing_instance.switch_damager
		if (switch_damager) then
			if (switch_damager [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_damager[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchDamageNoCombatDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchDamageNoCombatDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchDamageNoCombatDropdown.MyObject:Select (switch_damager[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchDamageNoCombatDropdown.MyObject:Select (1, true)
		end
		
		local switch_all_roles_after_wipe = editing_instance.switch_all_roles_after_wipe
		if (switch_all_roles_after_wipe) then
			if (switch_all_roles_after_wipe [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (switch_all_roles_after_wipe[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchWipeDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchWipeDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchWipeDropdown.MyObject:Select (switch_all_roles_after_wipe[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchWipeDropdown.MyObject:Select (1, true)
		end
		
		local autoswitch = editing_instance.switch_all_roles_in_combat
		if (autoswitch) then
			if (autoswitch [1] == "raid") then
				local plugin_object = _detalhes:GetPlugin (autoswitch[2])
				if (plugin_object) then
					_G.DetailsOptionsWindow17AutoSwitchDropdown.MyObject:Select (plugin_object.__name)
				else
					_G.DetailsOptionsWindow17AutoSwitchDropdown.MyObject:Select (1, true)
				end
			else
				_G.DetailsOptionsWindow17AutoSwitchDropdown.MyObject:Select (autoswitch[3]+1, true)
			end
		else
			_G.DetailsOptionsWindow17AutoSwitchDropdown.MyObject:Select (1, true)
		end
		
		_G.DetailsOptionsWindow17AutoCurrentSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow17AutoCurrentSlider.MyObject:SetValue (editing_instance.auto_current)
		_G.DetailsOptionsWindow17TrashSuppressionSlider.MyObject:SetValue (editing_instance.instances_suppress_trash)

		--> window 19
		_G.DetailsOptionsWindow19MinimapSlider.MyObject:SetValue (not _detalhes.minimap.hide)
		_G.DetailsOptionsWindow19MinimapActionDropdown.MyObject:Select (_detalhes.minimap.onclick_what_todo)
		
		_G.DetailsOptionsWindow19BrokerEntry.MyObject:SetText (_detalhes.data_broker_text)
		_G.DetailsOptionsWindow19BrokerNumberAbbreviateDropdown.MyObject:Select (_detalhes.minimap.text_format)
		
		if (not _G.HotCorners) then
			_G.DetailsOptionsWindow19HotcornerSlider.MyObject:Disable()
			if (not _G.DetailsOptionsWindow19HotcornerAnchor.MyObject:GetText():find ("not installed")) then
				_G.DetailsOptionsWindow19HotcornerAnchor.MyObject:SetText (_G.DetailsOptionsWindow19HotcornerAnchor.MyObject:GetText() .. " |cFFFF5555(not installed)|r")
			end
		else
			_G.DetailsOptionsWindow19HotcornerSlider.MyObject:SetValue (not _detalhes.hotcorner_topleft.hide)
		end
		
		_G.DetailsOptionsWindow19ItemLevelSlider.MyObject:SetValue (_detalhes.track_item_level)

		--report
		_G.DetailsOptionsWindow19ReportHelpfulLinkSlider.MyObject:SetValue (_detalhes.report_heal_links)
		_G.DetailsOptionsWindow19ReportFormatDropdown.MyObject:Select (_detalhes.report_schema)
		
		--> window 20
		_G.DetailsOptionsWindow20TooltipTextColorPick.MyObject:SetColor (unpack (_detalhes.tooltip.fontcolor))
		_G.DetailsOptionsWindow20TooltipTextColorPickRight.MyObject:SetColor (unpack (_detalhes.tooltip.fontcolor_right))
		_G.DetailsOptionsWindow20TooltipTextColorPickAnchor.MyObject:SetColor (unpack (_detalhes.tooltip.header_text_color))

		_G.DetailsOptionsWindow20TooltipTextSizeSlider.MyObject:SetValue (_detalhes.tooltip.fontsize)
		_G.DetailsOptionsWindow20TooltipFontDropdown.MyObject:Select (_detalhes.tooltip.fontface)
		_G.DetailsOptionsWindow20TooltipShadowSwitch.MyObject:SetValue (_detalhes.tooltip.fontshadow)
		_G.DetailsOptionsWindow20TooltipBackgroundColorPick.MyObject:SetColor (unpack (_detalhes.tooltip.background))
		_G.DetailsOptionsWindow20TooltipAbbreviateDropdown.MyObject:Select (_detalhes.tooltip.abbreviation, true)
		_G.DetailsOptionsWindow20TooltipMaximizeDropdown.MyObject:Select (_detalhes.tooltip.maximize_method, true)
		_G.DetailsOptionsWindow20TooltipShowAmountSlider.MyObject:SetValue (_detalhes.tooltip.show_amount)
		
		_G.DetailsOptionsWindow20TooltipAnchorDropdown.MyObject:Select (_detalhes.tooltip.anchored_to)
		_G.DetailsOptionsWindow20TooltipAnchorSideDropdown.MyObject:Select (_detalhes.tooltip.anchor_point)
		_G.DetailsOptionsWindow20TooltipRelativeSideDropdown.MyObject:Select (_detalhes.tooltip.anchor_relative)
		_G.DetailsOptionsWindow20TooltipOffsetXSlider.MyObject:SetValue (_detalhes.tooltip.anchor_offset[1])
		_G.DetailsOptionsWindow20TooltipOffsetYSlider.MyObject:SetValue (_detalhes.tooltip.anchor_offset[2])
		
		_G.DetailsOptionsWindow20BackdropBorderTextureDropdown.MyObject:Select (_detalhes.tooltip.border_texture)
		_G.DetailsOptionsWindow20BackdropSizeHeight.MyObject:SetValue (_detalhes.tooltip.border_size)
		_G.DetailsOptionsWindow20BackdropColorPick.MyObject:SetColor (unpack (_detalhes.tooltip.border_color))
		
		_G.DetailsOptionsWindow20CopyMainWallpaperSlider.MyObject:SetValue (_detalhes.tooltip.submenu_wallpaper)
		
		----------
		
		_G.DetailsOptionsWindow6SideBarsSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6SideBarsSlider.MyObject:SetValue (editing_instance.show_sidebars)

		_G.DetailsOptionsWindow6StatusbarSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6StatusbarSlider.MyObject:SetValue (editing_instance.show_statusbar)
		
		_G.DetailsOptionsWindow6StretchAnchorSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6StretchAnchorSlider.MyObject:SetValue (editing_instance.stretch_button_side)
		

		
		_G.DetailsOptionsWindow6InstanceToolbarSideSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow6InstanceToolbarSideSlider.MyObject:SetValue (editing_instance.toolbar_side)
		
	----------------------------------------------------------------	
		--instanceOverlayColorLabel
		--closeOverlayColorLabel
		
		_G.DetailsOptionsWindow4TextureDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4RowBackgroundTextureDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4TextureDropdown.MyObject:Select (editing_instance.row_info.texture)
		_G.DetailsOptionsWindow4RowBackgroundTextureDropdown.MyObject:Select (editing_instance.row_info.texture_background)
		
		_G.DetailsOptionsWindow4RowBackgroundColorPick.MyObject:SetColor (unpack (editing_instance.row_info.fixed_texture_background_color))
		
		_G.DetailsOptionsWindow4BackgroundClassColorSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4BackgroundClassColorSlider.MyObject:SetValue (editing_instance.row_info.texture_background_class_color)
		
		_G.DetailsOptionsWindow5FontDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5FontDropdown.MyObject:Select (editing_instance.row_info.font_face)
		--
		_G.DetailsOptionsWindow4SliderRowHeight.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4SliderRowHeight.MyObject:SetValue (editing_instance.row_info.height)
		--
		_G.DetailsOptionsWindow5SliderFontSize.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow5SliderFontSize.MyObject:SetValue (editing_instance.row_info.font_size)
		--
		--
		_G.DetailsOptionsWindow4ClassColorSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow4ClassColorSlider.MyObject:SetValue (editing_instance.row_info.texture_class_colors)

		--
		_G.DetailsOptionsWindow9UseBackgroundSlider.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow9BackgroundDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow9BackgroundDropdown2.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow9AnchorDropdown.MyObject:SetFixedParameter (editing_instance)
		_G.DetailsOptionsWindow9BackgroundDropdown.MyObject:Select (editing_instance.wallpaper.texture)
		
		_G.DetailsOptionsWindow9UseBackgroundSlider.MyObject:SetValue (editing_instance.wallpaper.enabled)
		
		_G.DetailsOptionsWindow6WindowColorPick.MyObject:SetColor (unpack (editing_instance.color))
		--_G.DetailsOptionsWindow6InstanceColorTexture.MyObject:SetTexture (unpack (editing_instance.color))
		
		--_G.DetailsOptionsWindow6BackgroundColorTexture.MyObject:SetTexture (editing_instance.bg_r, editing_instance.bg_g, editing_instance.bg_b)
		_G.DetailsOptionsWindow6WindowBackgroundColorPick.MyObject:SetColor (editing_instance.bg_r, editing_instance.bg_g, editing_instance.bg_b, editing_instance.bg_alpha)
		
		local r1, g1, b1 = unpack (editing_instance.row_info.fixed_texture_color)
		_G.DetailsOptionsWindow4RowColorPick.MyObject:SetColor ( r1, g1, b1, editing_instance.row_info.alpha)
		
		_G.DetailsOptionsWindow5FixedTextColor.MyObject:SetColor (unpack (editing_instance.row_info.fixed_text_color))
		
		_G.DetailsOptionsWindow1NicknameEntry.MyObject.text = _detalhes:GetNickname (UnitName ("player"), UnitName ("player"), true) or ""
		_G.DetailsOptionsWindow1TTDropdown.MyObject:Select (_detalhes.time_type, true)
		
		_G.DetailsOptionsWindow.MyObject.instance = instance
		
		if (editing_instance.meu_id > _detalhes.instances_amount) then
		else
			_G.DetailsOptionsWindowInstanceSelectDropdown.MyObject:Select (editing_instance.meu_id, true)
			GameCooltip:Reset()

			GameCooltip:SetOption ("TextFont", "Friz Quadrata TT")
			GameCooltip:SetOption ("TextColor", "orange")
			GameCooltip:SetOption ("TextSize", 12)
			GameCooltip:SetOption ("FixedWidth", 220)
			GameCooltip:SetOption ("ButtonsYMod", -4)
			GameCooltip:SetOption ("YSpacingMod", -4)
			GameCooltip:SetOption ("IgnoreButtonAutoHeight", true)
			GameCooltip:SetColor (1, 0.5, 0.5, 0.5, 0.5)
			
			GameCooltip:SetBackdrop (1, {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tileSize = 64, tile = true}, "black", "white")
			
			GameCooltip:AddLine ("Editing Window:", editing_instance.meu_id)
			GameCooltip:SetOwner (_G.DetailsOptionsWindowInstanceSelectDropdown, "bottom", "top", -212, -6)
			GameCooltip:ShowCooltip (nil, "tooltip")
			
			if (_G.DetailsOptionsWindow.MyObject.is_window_settings [_G.DetailsOptionsWindow.MyObject.current_selected]) then
				_G.DetailsOptionsWindowInstanceSelectDropdown.MyObject:Enable()
			else
				_G.DetailsOptionsWindowInstanceSelectDropdown.MyObject:Disable()
			end
			
		end
		
		
		
		--profiles
		_G.DetailsOptionsWindow13CurrentProfileLabel2.MyObject:SetText (_detalhes_database.active_profile)
		
		window:Show()

		local avatar = NickTag:GetNicknameAvatar (UnitName ("player"), NICKTAG_DEFAULT_AVATAR, true)
		local background, cords, color = NickTag:GetNicknameBackground (UnitName ("player"), NICKTAG_DEFAULT_BACKGROUND, NICKTAG_DEFAULT_BACKGROUND_CORDS, {1, 1, 1, 1}, true)

		_G.DetailsOptionsWindow1AvatarPreviewTexture.MyObject.texture = avatar
		_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject.texture = background
		_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject.texcoord = cords
		_G.DetailsOptionsWindow1AvatarPreviewTexture2.MyObject:SetVertexColor (unpack (color))
		
		if (not avatar:find ("UI%-EJ%-BOSS%-Default")) then
			_G.DetailsOptionsWindow1.ChooseAvatarLabel:SetTextColor (1, 0.93, 0.74, 0)
			_G.DetailsOptionsWindow1.HaveAvatar = true
		else
			_G.DetailsOptionsWindow1.ChooseAvatarLabel:SetTextColor (1, 0.93, 0.74)
			_G.DetailsOptionsWindow1.HaveAvatar = false
		end

		local nick = _detalhes:GetNickname (UnitName ("player"), UnitName ("player"), true)
		_G.DetailsOptionsWindow1AvatarNicknameLabel:SetText (nick)
		
		if (window.update_wallpaper_info) then
			window:update_wallpaper_info()
		end
		
		if (section) then
		
			
		
			local button = window.menu_buttons [section]
			button:Click()
			
			--local mouse_up_hook = button.OnMouseUpHook
			--mouse_up_hook (button.widget)
		end

		DetailsOptionsWindow.loading_settings = nil
		
		DetailsOptionsWindowGroupEditing:SetChecked (_detalhes.options_group_edit)
		
		_detalhes:SendOptionsModifiedEvent (editing_instance)
		
	end

	
	if (_G.DetailsOptionsWindow.full_created) then
		_G.DetailsOptionsWindow.MyObject:update_all (instance)
	else
		--> its loading while in combat
		function _detalhes:options_loading_done()
			if (_G.DetailsOptionsWindow.full_created) then
				_G.DetailsOptionsWindow.MyObject:update_all (instance)
				_detalhes:CancelTimer (window.loading_check, true)
			end
		end
		window.loading_check = _detalhes:ScheduleRepeatingTimer ("options_loading_done", 0.1)
	end
	
	window:Show()
	
	function DetailsOptionsWindow.OpenInPluginPanel()
		if (not window.options) then
			--might be loading in combat
			return
		end
		
		for i = 1, #window.options do	
			local frame = window.options [i][1]
			if (frame) then
				frame:EnableMouse (false)
				--frame:SetSize (DetailsPluginContainerWindow.FrameWidth, DetailsPluginContainerWindow.FrameHeight)
			end
		end
		
		--DetailsOptionsWindowBackground:SetSize (DetailsPluginContainerWindow.FrameWidth, DetailsPluginContainerWindow.FrameHeight)
		_detalhes:FormatBackground (_G.DetailsOptionsWindow)
		
		DetailsPluginContainerWindow.OpenPlugin (DetailsOptionsWindow)
	end
	
	DetailsOptionsWindow.OpenInPluginPanel()

end --> OpenOptionsWindow

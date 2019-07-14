local _detalhes = 		_G._detalhes
local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ( "Details" )

local gump = 			_detalhes.gump
local _
--lua locals
local _unpack = unpack
local _math_floor = math.floor

--api locals
do
	local _CreateFrame = CreateFrame
	local _UIParent = UIParent

	local gump_fundo_backdrop = {
		bgFile = "Interface\\AddOns\\Details\\images\\background", 
		tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}

	local frame = _CreateFrame ("frame", "DetailsSwitchPanel", _UIParent)
	frame:SetPoint ("center", _UIParent, "center", 500, -300)
	frame:SetWidth (250)
	frame:SetHeight (100)
	frame:SetBackdrop (gump_fundo_backdrop)
	frame:SetBackdropBorderColor (170/255, 170/255, 170/255)
	frame:SetBackdropColor (0, 0, 0, .7)
	
	DetailsSwitchPanel.HoverOverBackground = {.6, .6, .6, .2}
	
	frame.hover_over_texture = frame:CreateTexture (nil, "border")
	frame.hover_over_texture:SetTexture (unpack (DetailsSwitchPanel.HoverOverBackground))
	frame.hover_over_texture:SetSize (130, 18)
	frame.hover_over_texture:Hide()
	
	frame:SetFrameStrata ("FULLSCREEN")
	frame:SetFrameLevel (16)
	
	frame.background = frame:CreateTexture (nil, "background")
	frame.background:SetTexture ("Interface\\AddOns\\Details\\images\\background")
	--frame.background:SetTexture ([[Interface\SPELLBOOK\Spellbook-Page-1]])
	--frame.background:SetTexCoord (331/512, 63/512, 109/512, 143/512)
	frame.background:SetAllPoints()
	frame.background:SetDesaturated (true)
	--frame.background:SetVertexColor (1, 1, 1, 0.1)
	frame.background:SetVertexColor (0, 0, 0, .8)
	
	frame.topbg = frame:CreateTexture (nil, "background")
	frame.topbg:SetTexture ("Interface\\AddOns\\Details\\images\\background")
	--frame.topbg:SetTexCoord (100/512, 267/512, 143/512, 202/512)
	frame.topbg:SetPoint ("bottomleft", frame, "topleft")
	frame.topbg:SetPoint ("bottomright", frame, "topright")
	frame.topbg:SetHeight (20)
	frame.topbg:SetDesaturated (true)
	frame.topbg:SetVertexColor (0, 0, 0, 1)
	
	frame.topbg_frame = CreateFrame ("frame", nil, frame)
	frame.topbg_frame:SetPoint ("bottomleft", frame, "topleft")
	frame.topbg_frame:SetPoint ("bottomright", frame, "topright")
	frame.topbg_frame:SetHeight (20)
	frame.topbg_frame:EnableMouse (true)
	frame.topbg_frame:SetScript ("OnMouseDown", function (self, button)
		if (button == "RightButton") then
			_detalhes.switch:CloseMe()
		end
	end)
	
	frame.star = frame:CreateTexture (nil, "overlay")
	frame.star:SetTexture ([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]])
	frame.star:SetTexCoord (0.75, 1, 0, 1)
	frame.star:SetVertexColor (1, 0.8, 0.6)
	frame.star:SetSize (16, 16)
	frame.star:SetPoint ("bottomleft", frame, "topleft", 4, 1)
	
	frame.title_label = frame:CreateFontString (nil, "overlay", "GameFontNormal")
	frame.title_label:SetPoint ("left", frame.star, "right", 4, 0)
	frame.title_label:SetTextColor (1, 0.8, 0.4)
	frame.title_label:SetText (Loc ["STRING_KEYBIND_BOOKMARK"])

---------------------------------------------------------------------------------------------------------------------------

	frame.editing_window = nil
	local windowcolor_callback = function (button, r, g, b, a)
		local instance = frame.editing_window
	
		if (instance.menu_alpha.enabled and a ~= instance.color[4]) then
			_detalhes:Msg (Loc ["STRING_OPTIONS_MENU_ALPHAWARNING"])
			instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
			
			if (_detalhes.options_group_edit) then
				for _, this_instance in ipairs (instance:GetInstanceGroup()) do
					if (this_instance ~= instance) then
						this_instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
					end
				end
			end
			
			return
		end
		
		instance:InstanceColor (r, g, b, a, nil, true)
		if (_detalhes.options_group_edit) then
			for _, this_instance in ipairs (instance:GetInstanceGroup()) do
				if (this_instance ~= instance) then
					this_instance:InstanceColor (r, g, b, a, nil, true)
				end
			end
		end
	end
	
	local change_color = function()
		frame.editing_window = _detalhes.switch.current_instancia
		local r, g, b, a = unpack (frame.editing_window.color)
		_detalhes.gump:ColorPick (frame, r, g, b, a, windowcolor_callback)
		_detalhes.switch:CloseMe()
	end
	
	local window_color = gump:CreateButton (frame.topbg_frame, change_color, 14, 14)
	window_color:SetPoint ("bottomright", frame, "topright", -3, 2)
	
	local window_color_texture = gump:CreateImage (window_color, [[Interface\AddOns\Details\images\icons]], 14, 14, "artwork", {434/512, 466/512, 277/512, 307/512})
	window_color_texture:SetAlpha (0.55)
	window_color_texture:SetAllPoints()
	
	window_color:SetHook ("OnEnter", function()
		window_color_texture:SetAlpha (1)
		GameCooltip:Reset()
		_detalhes:CooltipPreset (1)
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		GameCooltip:AddLine (Loc ["STRING_OPTIONS_INSTANCE_COLOR"])
		GameCooltip:SetOwner (window_color.widget)
		GameCooltip:SetType ("tooltip")
		GameCooltip:Show()
	end)
	window_color:SetHook ("OnLeave", function()
		window_color_texture:SetAlpha (0.55)
		GameCooltip:Hide()
	end)
	
---------------------------------------------------------------------------------------------------------------------------
	--> ~all
	local all_switch = CreateFrame ("frame", "DetailsAllAttributesFrame", UIParent)
	all_switch:SetFrameStrata ("tooltip")
	all_switch:Hide()
	all_switch:SetSize (400, 150)
	all_switch:SetClampedToScreen (true)
	all_switch:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
	all_switch:SetBackdropColor (0.05, 0.05, 0.05, 0.3)
	all_switch.background = all_switch:CreateTexture ("DetailsAllAttributesFrameBackground", "background")
	all_switch.background:SetDrawLayer ("background", 2)
	all_switch.background:SetPoint ("topleft", all_switch, "topleft", 4, -4)
	all_switch.background:SetPoint ("bottomright", all_switch, "bottomright", -4, 4)
	all_switch.wallpaper = all_switch:CreateTexture ("DetailsAllAttributesFrameWallPaper", "background")
	all_switch.wallpaper:SetDrawLayer ("background", 4)
	all_switch.wallpaper:SetPoint ("topleft", all_switch, "topleft", 4, -4)
	all_switch.wallpaper:SetPoint ("bottomright", all_switch, "bottomright", -4, 4)
	all_switch.buttons = {}
	
	all_switch.ShowAnimation = _detalhes.gump:CreateAnimationHub (all_switch, function() all_switch:Show() end)
	_detalhes.gump:CreateAnimation (all_switch.ShowAnimation, "scale", 1, 0.04, 1, 0, 1, 1, "BOTTOM", 0, 0)
	_detalhes.gump:CreateAnimation (all_switch.ShowAnimation, "alpha", 1, 0.04, 0, 1)
	
	all_switch:SetScript ("OnMouseDown", function (self, button)
		if (button == "RightButton") then
			self:Hide()
		end
	end)
	all_switch:SetScript ("OnEnter", function (self, button)
		all_switch.interacting = true
		all_switch.last_up = GetTime()
	end)
	all_switch:SetScript ("OnLeave", function (self, button)
		all_switch.interacting = false
		all_switch.last_up = GetTime()
	end)
	
	local on_update_all_switch = function (self, elapsed)
		if (not self.interacting) then
			if (GetTime() > all_switch.last_up+2) then
				local cursor_x, cursor_y = GetCursorPosition()
				cursor_x, cursor_y = floor (cursor_x), floor (cursor_y)
				if (all_switch.cursor_x ~= cursor_x or all_switch.cursor_y ~= cursor_y) then
					self:Hide()
				else
					all_switch.last_up = GetTime()-1
				end
			end
		end
	end
	
	all_switch:SetScript ("OnHide", function (self)
		all_switch:SetScript ("OnUpdate", nil)
	end)	
	
	DetailsSwitchPanel.all_switch = all_switch
	
	function _detalhes:ShowAllSwitch()
	
	--[=[ --tutorial removed, I don't think is necessary anymore, July 2019
		--_detalhes:SetTutorialCVar ("SWITCH_PANEL_FIRST_OPENED", false)
		if (not _detalhes:GetTutorialCVar ("SWITCH_PANEL_FIRST_OPENED")) then
			_detalhes:SetTutorialCVar ("SWITCH_PANEL_FIRST_OPENED", true)
			local fake_window = _detalhes:CreateFakeWindow()
			fake_window:SetPoint ("bottomleft", all_switch, "topleft", 0, 10)
			
			local all_switch_titlebar_help = CreateFrame ("frame", "DetailsSwitchAllPopUp1", fake_window, "DetailsHelpBoxTemplate")
			all_switch_titlebar_help.ArrowUP:Show()
			all_switch_titlebar_help.ArrowGlowUP:Show()
			all_switch_titlebar_help.Text:SetText ("Right click on Title Bar to open all displays menu.")
			all_switch_titlebar_help:SetPoint ("bottom", fake_window.TitleBar, "top", 0, 30)
			all_switch_titlebar_help:Show()
			
			local all_switch_titlebar2_help = CreateFrame ("frame", "DetailsSwitchAllPopUp1", fake_window, "DetailsHelpBoxTemplate")
			all_switch_titlebar2_help.ArrowLEFT:Show()
			all_switch_titlebar2_help.ArrowGlowLEFT:Show()
			all_switch_titlebar2_help.Text:SetText ("Right clicking anywhere else opens your Bookmarks.")
			all_switch_titlebar2_help:SetPoint ("right", fake_window, "left", -30, 0)
			all_switch_titlebar2_help:Show()
			
			local close = CreateFrame ("button", nil, fake_window)
			close:SetPoint ("bottomright", fake_window, "bottomright", -10, 10)
			close:SetScript ("OnClick", function() fake_window:Hide(); all_switch_titlebar2_help:Hide(); all_switch_titlebar_help:Hide() end)
			close:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
			close:SetBackdropColor (0.7, 0.7, 0.7, 0.4)
			close:SetSize (100, 20)
			local t = close:CreateFontString (nil, "overlay", "GameFontNormal")
			t:SetPoint ("center", 0, 0)
			t:SetText ("CLOSE")
		end
	--]=]
	
		if (all_switch:IsShown()) then
			return all_switch:Hide()
		end
		all_switch.instance = self
		GameTooltip:Hide()
		GameCooltip:Hide()
		all_switch:ClearAllPoints()
		all_switch:SetPoint ("bottom", self.baseframe.UPFrame, "top", 4)
		
		--all_switch.ShowAnimation:Play()
		all_switch:Show()
		
		if (_detalhes.switch.frame:IsShown()) then
			_detalhes.switch:CloseMe()
		end
	end
	
	local on_click_all_switch_button = function (self, button)
		if (button == "LeftButton") then
			local attribute = self.attribute
			local sub_attribute = self.sub_attribute
			local instance = all_switch.instance
			
			if (instance.modo == _detalhes._detalhes_props["MODO_ALONE"] or instance.modo == _detalhes._detalhes_props["MODO_RAID"]) then
				instance:AlteraModo (instance, 2)
			end
			instance:TrocaTabela (instance, true, attribute, sub_attribute)
			all_switch:Hide()
			
		elseif (button == "RightButton") then
			all_switch:Hide()
		end
	end
	
	local hover_over_texture = all_switch:CreateTexture (nil, "border")
	hover_over_texture:SetTexture (unpack (DetailsSwitchPanel.HoverOverBackground))
	hover_over_texture:SetSize (130, 18)
	hover_over_texture:Hide()
	
	local icon_size = 16
	local text_color = {.9, .9, .9, 1}
	
	local on_enter_all_switch_button = function (self)
		_detalhes:SetFontColor (self.text, "orange")
		all_switch.interacting = true
		all_switch.last_up = GetTime()
		
		hover_over_texture:SetSize (130, 18)
		hover_over_texture:ClearAllPoints()
		hover_over_texture:SetPoint ("topleft", self, "topleft", -2, 1)
		hover_over_texture:Show()
		--self.texture:SetSize (icon_size+1, icon_size+1)
	end
	
	local on_leave_all_switch_button = function (self)
		_detalhes:SetFontColor (self.text, text_color)
		all_switch.interacting = false
		all_switch.last_up = GetTime()
		hover_over_texture:Hide()
		--self.texture:SetSize (icon_size, icon_size)
	end

	local on_enter_all_switch_button_icon = function (self)
		self.MainFrame.texture:SetBlendMode ("ADD")
		on_enter_all_switch_button (self.MainFrame)
	end
	local on_leave_all_switch_button_icon = function (self)
		self.MainFrame.texture:SetBlendMode ("BLEND")
		on_leave_all_switch_button (self.MainFrame)
	end
	
	all_switch.check_text_size = function (font_string)
		local text_width = font_string:GetStringWidth()
		while (text_width > 104) do
			local text = font_string:GetText()
			text = strsub (text, 1, #text-1)
			font_string:SetText (text)
			text_width = font_string:GetStringWidth()
		end
	end
	
	local create_all_switch_button = function (attribute, sub_attribute, x, y)
		local button = CreateFrame ("button", "DetailsAllAttributesFrame" .. attribute .. sub_attribute, all_switch)
		button:SetSize (130, 16)
		button.texture = button:CreateTexture (nil, "overlay")
		button.texture:SetPoint ("left", 0, 0)
		button.texture:SetSize (icon_size, icon_size)
		
		local texture_highlight_frame = CreateFrame ("button", "DetailsAllAttributesFrame" .. attribute .. sub_attribute .. "IconFrame", button)
		texture_highlight_frame:SetSize (icon_size, icon_size)
		texture_highlight_frame:SetPoint ("left", 0, 0)
		texture_highlight_frame.texture = button.texture
		texture_highlight_frame.MainFrame = button
		
		button.text = button:CreateFontString (nil, "overlay", "GameFontNormal")
		button.text:SetPoint ("left", button.texture, "right", 2, 0)
		button.attribute = attribute
		button.sub_attribute = sub_attribute
		button:SetPoint ("topleft", x, y)
		_detalhes:SetFontSize (button.text, 10)
		_detalhes:SetFontColor (button.text, text_color)
		
		button:SetScript ("OnClick", on_click_all_switch_button)
		button:SetScript ("OnEnter", on_enter_all_switch_button)
		button:SetScript ("OnLeave", on_leave_all_switch_button)
		
		texture_highlight_frame:SetScript ("OnClick", on_click_all_switch_button)
		texture_highlight_frame:SetScript ("OnEnter", on_enter_all_switch_button_icon)
		texture_highlight_frame:SetScript ("OnLeave", on_leave_all_switch_button_icon)
		
		button:RegisterForClicks ("LeftButtonDown", "RightButtonDown")

		return button
	end	
	
	all_switch:SetScript ("OnShow", function()
		
		if (not all_switch.already_built) then
			local x, y = 8, -8
			all_switch.higher_counter = 0

			for attribute = 1, _detalhes.atributos[0] do 
				--> localized attribute name
				local loc_attribute_name = _detalhes.atributos.lista [attribute]

				local title_icon = all_switch:CreateTexture (nil, "overlay")
				title_icon:SetPoint ("topleft", x, y)
				local texture, l, r, t, b = _detalhes:GetAttributeIcon (attribute)
				title_icon:SetTexture (texture)
				title_icon:SetTexCoord (l, r, t, b)
				title_icon:SetSize (18, 18)
				local title_str = all_switch:CreateFontString (nil, "overlay", "GameFontNormal")
				title_str:SetPoint ("left", title_icon, "right", 2, 0)
				title_str:SetText (loc_attribute_name)
				
				y = y - 20
				
				all_switch.buttons [attribute] = {}
				for i = 1, #_detalhes.sub_atributos [attribute].lista do
					--> localized sub attribute name
					local loc_sub_attribute_name = _detalhes.sub_atributos [attribute].lista [i]
					local button = create_all_switch_button (attribute, i, x, y)
					button.text:SetText (loc_sub_attribute_name)
					all_switch.check_text_size (button.text)
					button.texture:SetTexture (_detalhes.sub_atributos [attribute].icones [i] [1])
					button.texture:SetTexCoord (unpack (_detalhes.sub_atributos [attribute].icones [i] [2]))
					tinsert (all_switch.buttons [attribute], button)
					y = y - 17
				end
				
				if (#_detalhes.sub_atributos [attribute].lista > all_switch.higher_counter) then
					all_switch.higher_counter = #_detalhes.sub_atributos [attribute].lista
				end
				
				x = x + 130
				y = -8
			end
			
			--> prepare for customs
			all_switch.x = x
			all_switch.y = -8
			all_switch.buttons [_detalhes.atributos[0]+1] = {}
			
			local title_icon = all_switch:CreateTexture (nil, "overlay")
			local texture, l, r, t, b = _detalhes:GetAttributeIcon (_detalhes.atributos[0]+1)
			title_icon:SetTexture (texture)
			title_icon:SetTexCoord (l, r, t, b)
			title_icon:SetSize (18, 18)
			local title_str = all_switch:CreateFontString (nil, "overlay", "GameFontNormal")
			title_str:SetPoint ("left", title_icon, "right", 2, 0)
			title_str:SetText (_detalhes.atributos.lista [_detalhes.atributos[0]+1])
			
			title_icon:SetPoint ("topleft", all_switch.x, all_switch.y)
			all_switch.y = all_switch.y - 20
			all_switch.title_custom = title_icon
			
			all_switch.already_built = true
		end
		
		--> update customs
		local custom_index = _detalhes.atributos[0]+1
		for _, button in ipairs (all_switch.buttons [custom_index]) do
			button:Hide()
		end
		
		local button_index = 1
		for i = #_detalhes.custom, 1, -1 do
			local button = all_switch.buttons [custom_index] [button_index]
			if (not button) then
				button = create_all_switch_button (custom_index, i, all_switch.x, all_switch.y)
				tinsert (all_switch.buttons [custom_index], button)
				all_switch.y = all_switch.y - 17
			end
			
			local custom = _detalhes.custom [i]
			button.text:SetText (custom.name)
			all_switch.check_text_size (button.text)
			button.texture:SetTexture (custom.icon)
			button.texture:SetTexCoord (0.078125, 0.921875, 0.078125, 0.921875)
			button:Show()
			
			button_index = button_index + 1
		end
		
		if (#_detalhes.custom > all_switch.higher_counter) then
			all_switch.higher_counter = #_detalhes.custom
		end
		
		all_switch:SetHeight ((all_switch.higher_counter * 17) + 20 + 16)
		all_switch:SetWidth ((120 * 5) + (5 * 2) + (12*4))
		
		all_switch.last_up = GetTime()
		local cursor_x, cursor_y = GetCursorPosition()
		all_switch.cursor_x, all_switch.cursor_y = floor (cursor_x), floor (cursor_y)
		all_switch:SetScript ("OnUpdate", on_update_all_switch)
		
		--[=[
		all_switch.wallpaper:SetTexture (_detalhes.tooltip.menus_bg_texture)
		all_switch.wallpaper:SetTexCoord (unpack (_detalhes.tooltip.menus_bg_coords))
		all_switch.wallpaper:SetVertexColor (unpack (_detalhes.tooltip.menus_bg_color))
		all_switch.wallpaper:SetDesaturated (true)
		--]=]
		
		--[=[
		all_switch:SetBackdrop (_detalhes.tooltip_backdrop)
		all_switch:SetBackdropColor (0.09019, 0.09019, 0.18823, 1)
		all_switch:SetBackdropBorderColor (unpack (_detalhes.tooltip_border_color))
		--]=]
		
		--updated colors (these colors are set inside the janela_principal file
		all_switch:SetBackdrop (_detalhes.menu_backdrop_config.menus_backdrop)
		all_switch:SetBackdropColor (unpack (_detalhes.menu_backdrop_config.menus_backdropcolor))
		all_switch:SetBackdropBorderColor (unpack (_detalhes.menu_backdrop_config.menus_bordercolor))
		
	end) 
	
---------------------------------------------------------------------------------------------------------------------------	

	local open_options = function()
		_detalhes:OpenOptionsWindow (_detalhes.switch.current_instancia)
		_detalhes.switch:CloseMe()
	end
	local options_button = gump:CreateButton (frame.topbg_frame, open_options, 14, 14, open_options)
	options_button:SetPoint ("right", window_color, "left", -2, 0)
	
	local options_button_texture = gump:CreateImage (options_button, [[Interface\AddOns\Details\images\icons]], 14, 14, "artwork", {396/512, 428/512, 277/512, 307/512})
	options_button_texture:SetAlpha (0.55)
	options_button_texture:SetAllPoints()
	
	options_button:SetHook ("OnEnter", function()
		options_button_texture:SetAlpha (1)
		GameCooltip:Reset()
		_detalhes:CooltipPreset (1)
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		GameCooltip:AddLine (Loc ["STRING_INTERFACE_OPENOPTIONS"])
		GameCooltip:SetOwner (window_color.widget)
		GameCooltip:SetType ("tooltip")
		GameCooltip:Show()
	end)
	options_button:SetHook ("OnLeave", function()
		options_button_texture:SetAlpha (0.55)
		GameCooltip:Hide()
	end)
	
---------------------------------------------------------------------------------------------------------------------------

	local open_forge = function()
		_detalhes:OpenForge()
		_detalhes.switch:CloseMe()
	end
	local forge_button = gump:CreateButton (frame.topbg_frame, open_forge, 14, 14, open_forge)
	forge_button:SetPoint ("right", options_button, "left", -2, 0)
	
	local forge_button_texture = gump:CreateImage (forge_button, [[Interface\AddOns\Details\images\icons]], 14, 14, "artwork", {396/512, 428/512, 243/512, 273/512})
	forge_button_texture:SetAlpha (0.55)
	forge_button_texture:SetAllPoints()
	
	forge_button:SetHook ("OnEnter", function()
		forge_button_texture:SetAlpha (1)
		GameCooltip:Reset()
		_detalhes:CooltipPreset (1)
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		GameCooltip:AddLine ("Open Forge")
		GameCooltip:SetOwner (window_color.widget)
		GameCooltip:SetType ("tooltip")
		GameCooltip:Show()
	end)
	forge_button:SetHook ("OnLeave", function()
		forge_button_texture:SetAlpha (0.55)
		GameCooltip:Hide()
	end)
	
---------------------------------------------------------------------------------------------------------------------------
	
	local open_history = function()
		_detalhes:OpenRaidHistoryWindow()
		_detalhes.switch:CloseMe()
	end
	local history_button = gump:CreateButton (frame.topbg_frame, open_history, 14, 14, open_history)
	history_button:SetPoint ("right", forge_button, "left", -2, 0)
	
	local history_button_texture = gump:CreateImage (history_button, [[Interface\AddOns\Details\images\icons]], 14, 14, "artwork", {434/512, 466/512, 243/512, 273/512})
	history_button_texture:SetAlpha (0.55)
	history_button_texture:SetAllPoints()
	
	history_button:SetHook ("OnEnter", function()
		history_button_texture:SetAlpha (1)
		GameCooltip:Reset()
		_detalhes:CooltipPreset (1)
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		GameCooltip:AddLine ("Open History Panel")
		GameCooltip:SetOwner (window_color.widget)
		GameCooltip:SetType ("tooltip")
		GameCooltip:Show()
	end)
	history_button:SetHook ("OnLeave", function()
		history_button_texture:SetAlpha (0.55)
		GameCooltip:Hide()
	end)	
	
	window_color:Hide()
	options_button:Hide()
	forge_button:Hide()
	history_button:Hide()
	
---------------------------------------------------------------------------------------------------------------------------

	--animation has been disabled (July 2019)
	--they aren't called anymore on showing and hiding the bookmark frame
	--show animation
	local animHub = _detalhes.gump:CreateAnimationHub (frame, function() frame:Show() end)
	_detalhes.gump:CreateAnimation (animHub, "scale", 1, 0.04, 0, 1, 1, 1, "LEFT", 0, 0)
	_detalhes.gump:CreateAnimation (animHub, "alpha", 1, 0.04, 0, 1)
	frame.ShowAnimation = animHub

	--hide animation
	local animHub = _detalhes.gump:CreateAnimationHub (frame, function() frame:Show() end, function() frame:Hide() end)
	_detalhes.gump:CreateAnimation (animHub, "scale", 1, 0.04, 1, 1, 0, 1, "RIGHT", 0, 0)
	_detalhes.gump:CreateAnimation (animHub, "alpha", 1, 0.04, 1, 0)
	frame.HideAnimation = animHub

---------------------------------------------------------------------------------------------------------------------------
	
	function _detalhes.switch:CloseMe()
		_detalhes.switch.frame:Hide()
		_detalhes.switch.frame:ClearAllPoints()
		
		--_detalhes.switch.frame.HideAnimation:Play()
		
		GameCooltip:Hide()
		_detalhes.switch.frame:SetBackdropColor (0, 0, 0, .7)
		_detalhes.switch.current_instancia:StatusBarAlert (nil)
		_detalhes.switch.current_instancia = nil
	end
	
	--> limita��o: n�o tenho como pegar o base frame da inst�ncia por aqui
	frame.close = gump:NewDetailsButton (frame, frame, _, function() end, nil, nil, 1, 1, "", "", "", "", {rightFunc = {func = _detalhes.switch.CloseMe, param1 = nil, param2 = nil}}, "DetailsSwitchPanelClose")
	frame.close:SetPoint ("topleft", frame, "topleft")
	frame.close:SetPoint ("bottomright", frame, "bottomright")
	frame.close:SetFrameLevel (9)
	frame:Hide()
	
	_detalhes.switch.frame = frame
	_detalhes.switch.button_height = 24
end

_detalhes.switch.buttons = {}
_detalhes.switch.slots = _detalhes.switch.slots or 6
_detalhes.switch.showing = 0
_detalhes.switch.table = _detalhes.switch.table or {}
_detalhes.switch.current_instancia = nil
_detalhes.switch.current_button = nil
_detalhes.switch.height_necessary = (_detalhes.switch.button_height * _detalhes.switch.slots) / 2

local right_click_text = {text = Loc ["STRING_SHORTCUT_RIGHTCLICK"], size = 9, color = {.9, .9, .9}}
local right_click_texture = {[[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 14, 14, 0.0019531, 0.1484375, 0.6269531, 0.8222656}

function _detalhes.switch:HideAllBookmarks()
	for _, bookmark in ipairs (_detalhes.switch.buttons) do
		bookmark:Hide()
	end
end

function _detalhes.switch:ShowMe (instancia)

	_detalhes.switch.current_instancia = instancia

	if (IsControlKeyDown()) then
		
		if (not _detalhes.tutorial.ctrl_click_close_tutorial) then
			if (not DetailsCtrlCloseWindowPanelTutorial) then
				local tutorial_frame = CreateFrame ("frame", "DetailsCtrlCloseWindowPanelTutorial", _detalhes.switch.frame)
				tutorial_frame:SetFrameStrata ("FULLSCREEN_DIALOG")
				tutorial_frame:SetAllPoints()
				tutorial_frame:EnableMouse (true)
				tutorial_frame:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
				tutorial_frame:SetBackdropColor (0.05, 0.05, 0.05, 0.95)

				tutorial_frame.info_label = tutorial_frame:CreateFontString (nil, "overlay", "GameFontNormal")
				tutorial_frame.info_label:SetPoint ("topleft", tutorial_frame, "topleft", 10, -10)
				tutorial_frame.info_label:SetText (Loc ["STRING_MINITUTORIAL_CLOSECTRL1"])
				tutorial_frame.info_label:SetJustifyH ("left")
				
				tutorial_frame.mouse = tutorial_frame:CreateTexture (nil, "overlay")
				tutorial_frame.mouse:SetTexture ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]])
				tutorial_frame.mouse:SetTexCoord (0.0019531, 0.1484375, 0.6269531, 0.8222656)
				tutorial_frame.mouse:SetSize (20, 22)
				tutorial_frame.mouse:SetPoint ("topleft", tutorial_frame.info_label, "bottomleft", -3, -10)

				tutorial_frame.close_label = tutorial_frame:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tutorial_frame.close_label:SetPoint ("left", tutorial_frame.mouse, "right", 4, 0)
				tutorial_frame.close_label:SetText (Loc ["STRING_MINITUTORIAL_CLOSECTRL2"])
				tutorial_frame.close_label:SetJustifyH ("left")
				
				local checkbox = CreateFrame ("CheckButton", "DetailsCtrlCloseWindowPanelTutorialCheckBox", tutorial_frame, "ChatConfigCheckButtonTemplate")
				checkbox:SetPoint ("topleft", tutorial_frame.mouse, "bottomleft", -1, -5)
				_G [checkbox:GetName().."Text"]:SetText (Loc ["STRING_MINITUTORIAL_BOOKMARK4"])
				
				tutorial_frame:SetScript ("OnMouseDown", function()
					if (checkbox:GetChecked()) then
						_detalhes.tutorial.ctrl_click_close_tutorial = true
					end
					
					tutorial_frame:Hide()
					
					if (instancia:IsEnabled()) then
						return instancia:ShutDown()
					end
				end)
			end
			
			DetailsCtrlCloseWindowPanelTutorial:Show()
			DetailsCtrlCloseWindowPanelTutorial.info_label:SetWidth (_detalhes.switch.frame:GetWidth()-30)
			DetailsCtrlCloseWindowPanelTutorial.close_label:SetWidth (_detalhes.switch.frame:GetWidth()-30)
			
			_detalhes.switch.frame:SetPoint ("topleft", instancia.baseframe, "topleft", 0, 1)
			_detalhes.switch.frame:SetPoint ("bottomright", instancia.baseframe, "bottomright", 0, 1)
			_detalhes.switch.frame:SetBackdropColor (0.094, 0.094, 0.094, .8)
			_detalhes.switch.frame:Show()
			
			return
		end
		
		return instancia:ShutDown()
		
	elseif (IsShiftKeyDown()) then
		
		if (not _detalhes.switch.segments_blocks) then
		
			local segment_switch = function (self, button, segment)
				if (button == "LeftButton") then
					_detalhes.switch.current_instancia:TrocaTabela (segment)
					_detalhes.switch.CloseMe()
				elseif (button == "RightButton") then
					_detalhes.switch.CloseMe()
				end
			end
			
			local hide_label = function (self)
				self.texture:Hide()
				self.button:Hide()
				self.background:Hide()
				self:Hide()
			end
			
			local show_label = function (self)
				self.texture:Show()
				self.button:Show()
				self.background:Show()
				self:Show()
			end
			
			local on_enter = function (self)
				--self.MyObject.this_background:SetBlendMode ("ADD")
				--self.MyObject.boss_texture:SetBlendMode ("ADD")
			end
			
			local on_leave = function (self)
				self.MyObject.this_background:SetBlendMode ("BLEND")
				self.MyObject.boss_texture:SetBlendMode ("BLEND")
			end
		
			function _detalhes.switch:CreateSegmentBlock()
				local s = gump:CreateLabel (_detalhes.switch.frame)
				_detalhes:SetFontSize (s, 9)
				
				local index = #_detalhes.switch.segments_blocks
				if (index == 1) then --overall button
					index = -1
				elseif (index >= 2) then
					index = index - 1
				end
				
				local button = gump:CreateButton (_detalhes.switch.frame, segment_switch, 100, 20, "", index)
				button:SetPoint ("topleft", s, "topleft", -17, 0)
				button:SetPoint ("bottomright", s, "bottomright", 0, 0)
				button:SetClickFunction (segment_switch, nil, nil, "right")

				local boss_texture = gump:CreateImage (button, nil, 16, 16)
				boss_texture:SetPoint ("right", s, "left", -2, 0)

				local background = button:CreateTexture (nil, "background")
				background:SetTexture ("Interface\\SPELLBOOK\\Spellbook-Parts")
				background:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
				background:SetWidth (85)
				background:SetPoint ("topleft", s.widget, "topleft", -16, 3)
				background:SetPoint ("bottomright", s.widget, "bottomright", -3, -5)
				
				button.this_background = background
				button.boss_texture = boss_texture.widget
				
				s.texture = boss_texture
				s.button = button
				s.background = background
				
				button:SetScript ("OnEnter", on_enter)
				button:SetScript ("OnLeave", on_leave)
				
				s.HideMe = hide_label
				s.ShowMe = show_label
				
				tinsert (_detalhes.switch.segments_blocks, s)
				return s
			end
			
			function _detalhes.switch:GetSegmentBlock (index)
				local block = _detalhes.switch.segments_blocks [index]
				if (not block) then
					return _detalhes.switch:CreateSegmentBlock()
				else
					return block
				end
			end
			
			function _detalhes.switch:ClearSegmentBlocks()
				for _, block in ipairs (_detalhes.switch.segments_blocks) do
					block:HideMe()
				end
			end
			
			function _detalhes.switch:ResizeSegmentBlocks()

				local x = 7
				local y = 5
				
				local window_width, window_height = _detalhes.switch.current_instancia:GetSize()
				
				local horizontal_amt = floor (math.max (window_width / 100, 2))
				local vertical_amt = floor ((window_height - y) / 20)
				local size = window_width / horizontal_amt
				
				local frame = _detalhes.switch.frame
				
				_detalhes.switch:ClearSegmentBlocks()
				
				local i = 1
				for vertical = 1, vertical_amt do
					x = 7
					for horizontal = 1, horizontal_amt do
						local button = _detalhes.switch:GetSegmentBlock (i)
						
						button:SetPoint ("topleft", frame, "topleft", x + 16, -y)
						button:SetSize (size - 22, 12)
						button:ShowMe()
						
						i = i + 1
						x = x + size
						if (i > 40) then
							break
						end
					end
					y = y + 20
				end
			end
		
			_detalhes.switch.segments_blocks = {}

			--> current and overall
			_detalhes.switch:CreateSegmentBlock()
			_detalhes.switch:CreateSegmentBlock()
			
			local block1 = _detalhes.switch:GetSegmentBlock (1)
			block1:SetText (Loc ["STRING_CURRENTFIGHT"])
			block1.texture:SetTexture ([[Interface\Scenarios\ScenariosParts]])
			block1.texture:SetTexCoord (55/512, 81/512, 368/512, 401/512)
			
			local block2 = _detalhes.switch:GetSegmentBlock (2)
			block2:SetText (Loc ["STRING_SEGMENT_OVERALL"])
			block2.texture:SetTexture ([[Interface\Scenarios\ScenariosParts]])
			block2.texture:SetTexCoord (55/512, 81/512, 368/512, 401/512)
		end
		
		_detalhes.switch:ClearSegmentBlocks()
		_detalhes.switch:HideAllBookmarks()
		
		local segment_index = 1
		for i = 3, #_detalhes.tabela_historico.tabelas + 2 do
		
			local combat = _detalhes.tabela_historico.tabelas [segment_index]
		
			local block = _detalhes.switch:GetSegmentBlock (i)
			local enemy, color, raid_type, killed, is_trash, portrait, background, background_coords = _detalhes:GetSegmentInfo (segment_index)

			block:SetText ("#" .. segment_index .. " " .. enemy)
			
			if (combat.is_boss and combat.instance_type == "raid") then
				local L, R, T, B, Texture = _detalhes:GetBossIcon (combat.is_boss.mapid, combat.is_boss.index)
				if (L) then
					block.texture:SetTexture (Texture)
					block.texture:SetTexCoord (L, R, T, B)
				else
					block.texture:SetTexture ([[Interface\Scenarios\ScenarioIcon-Boss]])
				end
			else
				block.texture:SetTexture ([[Interface\Scenarios\ScenarioIcon-Boss]])
			end
			
			block:ShowMe()
			segment_index = segment_index + 1
		end
		
		_detalhes.switch.frame:SetScale (instancia.window_scale)
		_detalhes.switch:ResizeSegmentBlocks()
		
		for i = segment_index+2, #_detalhes.switch.segments_blocks do
			_detalhes.switch.segments_blocks [i]:HideMe()
		end
		
		_detalhes.switch.frame:SetPoint ("topleft", instancia.baseframe, "topleft", 0, 1)
		_detalhes.switch.frame:SetPoint ("bottomright", instancia.baseframe, "bottomright", 0, 1)
		_detalhes.switch.frame:SetBackdropColor (0.094, 0.094, 0.094, .8)
		_detalhes.switch.frame:Show()
		
		return
		
	else
		if (_detalhes.switch.segments_blocks) then
			_detalhes.switch:ClearSegmentBlocks()
		end
	end
	
	--> check if there is some custom contidional
	if (instancia.atributo == 5) then
		local custom_object = instancia:GetCustomObject()
		if (custom_object and custom_object.OnSwitchShow) then
			local interrupt = custom_object.OnSwitchShow (instancia)
			if (interrupt) then
				return
			end
		end
	end
	
	_detalhes.switch.frame:SetPoint ("topleft", instancia.baseframe, "topleft", 0, 1)
	_detalhes.switch.frame:SetPoint ("bottomright", instancia.baseframe, "bottomright", 0, 1)
	_detalhes.switch.frame:SetBackdropColor (0, 0, 0, .7)
	
	local altura = instancia.baseframe:GetHeight()
	local mostrar_quantas = _math_floor (altura / _detalhes.switch.button_height) * 2
	
	local precisa_mostrar = 0
	for i = 1, #_detalhes.switch.table do
		local slot = _detalhes.switch.table [i]
		if (not slot) then
			_detalhes.switch.table [i] = {}
			slot = _detalhes.switch.table [i]
		end
		if (slot.atributo) then
			precisa_mostrar = precisa_mostrar + 1
		else
			break
		end
	end
	
	if (_detalhes.switch.mostrar_quantas ~= mostrar_quantas) then 
		for i = 1, #_detalhes.switch.buttons do
			if (i <= mostrar_quantas) then 
				_detalhes.switch.buttons [i]:Show()
			else
				_detalhes.switch.buttons [i]:Hide()
			end
		end
		
		if (#_detalhes.switch.buttons < mostrar_quantas) then
			_detalhes.switch.slots = mostrar_quantas
		end
		
		_detalhes.switch.mostrar_quantas = mostrar_quantas
	end
	
	_detalhes.switch:Resize (precisa_mostrar)
	_detalhes.switch:Update()
	
	_detalhes.switch.frame:SetScale (instancia.window_scale)
	_detalhes.switch.frame:Show()
	--_detalhes.switch.frame.ShowAnimation:Play()
	
	--[=[ --removed bookmark tutorials July 2019
	if (not _detalhes.tutorial.bookmark_tutorial) then
	
		if (not SwitchPanelTutorial) then
			local tutorial_frame = CreateFrame ("frame", "SwitchPanelTutorial", _detalhes.switch.frame)
			tutorial_frame:SetFrameStrata ("FULLSCREEN_DIALOG")
			tutorial_frame:SetAllPoints()
			tutorial_frame:EnableMouse (true)
			tutorial_frame:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
			tutorial_frame:SetBackdropColor (0.05, 0.05, 0.05, 0.95)

			tutorial_frame.info_label = tutorial_frame:CreateFontString (nil, "overlay", "GameFontNormal")
			tutorial_frame.info_label:SetPoint ("topleft", tutorial_frame, "topleft", 10, -10)
			tutorial_frame.info_label:SetText (Loc ["STRING_MINITUTORIAL_BOOKMARK2"])
			tutorial_frame.info_label:SetJustifyH ("left")
			
			tutorial_frame.mouse = tutorial_frame:CreateTexture (nil, "overlay")
			tutorial_frame.mouse:SetTexture ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]])
			tutorial_frame.mouse:SetTexCoord (0.0019531, 0.1484375, 0.6269531, 0.8222656)
			tutorial_frame.mouse:SetSize (20, 22)
			tutorial_frame.mouse:SetPoint ("topleft", tutorial_frame.info_label, "bottomleft", -3, -10)

			tutorial_frame.close_label = tutorial_frame:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tutorial_frame.close_label:SetPoint ("left", tutorial_frame.mouse, "right", 4, 0)
			tutorial_frame.close_label:SetText (Loc ["STRING_MINITUTORIAL_BOOKMARK3"])
			tutorial_frame.close_label:SetJustifyH ("left")
			
			local checkbox = CreateFrame ("CheckButton", "SwitchPanelTutorialCheckBox", tutorial_frame, "ChatConfigCheckButtonTemplate")
			checkbox:SetPoint ("topleft", tutorial_frame.mouse, "bottomleft", -1, -5)
			_G [checkbox:GetName().."Text"]:SetText (Loc ["STRING_MINITUTORIAL_BOOKMARK4"])
			
			tutorial_frame:SetScript ("OnMouseDown", function()
				if (checkbox:GetChecked()) then
					_detalhes.tutorial.bookmark_tutorial = true
				end
				tutorial_frame:Hide()
			end)
		end
		
		SwitchPanelTutorial:Show()
		SwitchPanelTutorial.info_label:SetWidth (_detalhes.switch.frame:GetWidth()-30)
		SwitchPanelTutorial.close_label:SetWidth (_detalhes.switch.frame:GetWidth()-30)
	end
	--]=]
	
	_detalhes.switch:Resize (precisa_mostrar)
	--instancia:StatusBarAlert (right_click_text, right_click_texture) --icon, color, time
	
	if (DetailsSwitchPanel.all_switch:IsShown()) then
		return DetailsSwitchPanel.all_switch:Hide()
	end
	
end

-- ~setting
function _detalhes.switch:Config (_, _, atributo, sub_atributo)
	if (not sub_atributo) then 
		return
	end

	if (type (atributo) == "string") then
		--> is a plugin?
		local plugin = _detalhes:GetPlugin (atributo)
		if (plugin) then
			_detalhes.switch.table [_detalhes.switch.editing_bookmark].atributo = "plugin"
			_detalhes.switch.table [_detalhes.switch.editing_bookmark].sub_atributo = atributo
		end
	else
		--> is a attribute or custom script
		_detalhes.switch.table [_detalhes.switch.editing_bookmark].atributo = atributo
		_detalhes.switch.table [_detalhes.switch.editing_bookmark].sub_atributo = sub_atributo
	end
	
	_detalhes.switch.editing_bookmark = nil
	GameCooltip:Hide()
	_detalhes.switch:Update()
end

--[[global]] function DetailsChangeDisplayFromBookmark (number, instance)
	if (not instance) then
		local lower = _detalhes:GetLowerInstanceNumber()
		if (lower) then
			instance = _detalhes:GetInstance (lower)
		end
		if (not instance) then
			return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
		end
	end
	
	local bookmark = _detalhes.switch.table [number]

	if (bookmark) then
		_detalhes.switch.current_instancia = instance
		
		if (not bookmark.atributo) then
			return _detalhes:Msg (string.format (Loc ["STRING_SWITCH_SELECTMSG"], number))
		end
		
		_detalhes:FastSwitch (nil, bookmark, number)
		
		--return _detalhes:FastSwitch (paramTable)
	end
	
end

function _detalhes:FastSwitch (button, bookmark, bookmark_number, select_new)

	local UnknownPlugin = bookmark and bookmark.atributo == "plugin" and not _detalhes:GetPlugin (bookmark.sub_atributo)

	if (select_new or not bookmark.atributo or UnknownPlugin) then
	
		--> monta o menu para escolher qual atributo colocar ~select
	
		GameCooltip:Reset()
		GameCooltip:SetType (3)
		GameCooltip:SetFixedParameter (_detalhes.switch.current_instancia)

		GameCooltip:SetOwner (button)
		
		_detalhes.switch.editing_bookmark = bookmark_number
		
		_detalhes:MontaAtributosOption (_detalhes.switch.current_instancia, _detalhes.switch.Config)
		
			--> build raid plugins list
			GameCooltip:AddLine (Loc ["STRING_MODE_RAID"])
			GameCooltip:AddMenu (1, function() end, 4, true)
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 32/256*3, 32/256*4, 0, 1)
			
			local available_plugins = _detalhes.RaidTables:GetAvailablePlugins()

			if (#available_plugins >= 0) then
				local amt = 0
				
				for index, ptable in ipairs (available_plugins) do
					if (ptable [3].__enabled) then
						GameCooltip:AddMenu (2, _detalhes.switch.Config, _detalhes.switch.current_instancia, ptable [4], true, ptable [1], ptable [2], true) --PluginName, PluginIcon, PluginObject, PluginAbsoluteName
						amt = amt + 1
					end
				end
				
				GameCooltip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
				
				if (amt <= 3) then
					GameCooltip:SetOption ("SubFollowButton", true)
				end
			end

			--> build self plugins list
			GameCooltip:AddLine (Loc ["STRING_MODE_SELF"])
			GameCooltip:AddMenu (1, function() end, 1, true)
			GameCooltip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 0, 32/256, 0, 1)

			if (#_detalhes.SoloTables.Menu > 0) then
				for index, ptable in ipairs (_detalhes.SoloTables.Menu) do 
					if (ptable [3].__enabled) then
						GameCooltip:AddMenu (2, _detalhes.switch.Config, _detalhes.switch.current_instancia, ptable [4], true, ptable [1], ptable [2], true)
					end
				end
				GameCooltip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
			end
		
		GameCooltip:SetColor (1, {.1, .1, .1, .3})
		GameCooltip:SetColor (2, {.1, .1, .1, .3})
		GameCooltip:SetOption ("HeightAnchorMod", -7)
		GameCooltip:SetOption ("TextSize", _detalhes.font_sizes.menus)
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, nil, _detalhes.tooltip_border_color)
		GameCooltip:SetBackdrop (2, _detalhes.tooltip_backdrop, nil, _detalhes.tooltip_border_color)
		return GameCooltip:ShowCooltip()
	end

	if (IsShiftKeyDown()) then
		--> get a closed window or created a new one.
		local instance = _detalhes:CreateInstance()
		
		if (not instance) then
			_detalhes.switch.CloseMe()
			return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
		end
		
		_detalhes.switch.current_instancia = instance
	end

	if (_detalhes.switch.current_instancia.modo == _detalhes._detalhes_props["MODO_ALONE"]) then
		_detalhes.switch.current_instancia:AlteraModo (_detalhes.switch.current_instancia, 2)
	elseif (_detalhes.switch.current_instancia.modo == _detalhes._detalhes_props["MODO_RAID"]) then
		_detalhes.switch.current_instancia:AlteraModo (_detalhes.switch.current_instancia, 2)
	end
	
	if (bookmark.atributo == "plugin") then
		--> is a plugin, check if is a raid or solo plugin
		if (_detalhes.RaidTables.NameTable [bookmark.sub_atributo]) then
			_detalhes.RaidTables:EnableRaidMode (_detalhes.switch.current_instancia, bookmark.sub_atributo)
		elseif (_detalhes.SoloTables.NameTable [bookmark.sub_atributo]) then
			_detalhes.SoloTables:EnableSoloMode (_detalhes.switch.current_instancia, bookmark.sub_atributo)
		else
			_detalhes:Msg ("Plugin not found.")
		end
	else
		_detalhes.switch.current_instancia:TrocaTabela (_detalhes.switch.current_instancia, true, bookmark.atributo, bookmark.sub_atributo)
	end

	_detalhes.switch.CloseMe()
end

-- nao tem suporte a solo mode tank mode
-- nao tem suporte a custom at� agora, n�o sei como vai ficar

function _detalhes.switch:InitSwitch()
	local instancia = _detalhes.tabela_instancias [1]
	_detalhes.switch:ShowMe (instancia)
	_detalhes.switch:CloseMe()
	--return _detalhes.switch:Update()
end

function _detalhes.switch:OnRemoveCustom (CustomIndex)
	for i = 1, _detalhes.switch.slots do
		local options = _detalhes.switch.table [i]
		if (options and options.atributo == 5 and options.sub_atributo == CustomIndex) then 
			--> precisa resetar esse aqui
			options.atributo = nil
			options.sub_atributo = nil
			
			--update if already shown once at least
			if (_detalhes.switch.vertical_amt) then
				_detalhes.switch:Update()
			end
		end
	end
end

local default_coords = {5/64, 59/64, 5/64, 59/64}
local unknown_coords = {157/512, 206/512, 39/512,  89/512}
local vertex_color_default = {1, 1, 1}
local vertex_color_unknown = {1, 1, 1}
local add_coords = {464/512, 473/512, 1/512, 11/512}

function _detalhes.switch:Update()

	if (not _detalhes.switch.vertical_amt) then
		--wasn't opened yet, so doesn't matter if we update or not.
		return
	end

	local slots = _detalhes.switch.slots
	local x = 10
	local y = 5
	local jump = false
	local hide_the_rest
	
	local offset = FauxScrollFrame_GetOffset (DetailsSwitchPanelScroll)
	local slots_shown = _detalhes.switch.slots
	
	for i = 1, slots_shown do

		--bookmark index
		local index = (offset * _detalhes.switch.vertical_amt) + i
	
		--button
		local button = _detalhes.switch.buttons [i]
		if (not button) then
			button = _detalhes.switch:NewSwitchButton (_detalhes.switch.frame, i, x, y, jump)
			button:SetFrameLevel (_detalhes.switch.frame:GetFrameLevel()+2)
			_detalhes.switch.showing = _detalhes.switch.showing + 1
		end

		local options = _detalhes.switch.table [index]
		if (not options and index <= 40) then 
			options = {}
			_detalhes.switch.table [index] = options
		end
		
		button.bookmark_number = index --button on icon
		button.button2.bookmark_number = index --button on text
		
		local icone
		local coords
		local name
		local vcolor
		local add
		
		if (options and options.sub_atributo) then
			if (options.atributo == 5) then --> custom
				local CustomObject = _detalhes.custom [options.sub_atributo]
				if (not CustomObject) then --> ele j� foi deletado
					icone = [[Interface\AddOns\Details\images\icons]]
					coords = add_coords
					name = Loc ["STRING_SWITCH_CLICKME"]
					vcolor = vertex_color_unknown
					add = true
				else
					icone = CustomObject.icon
					coords = default_coords
					name = CustomObject.name
					vcolor = vertex_color_default
				end
				
			elseif (options.atributo == "plugin") then --> plugin
				local plugin = _detalhes:GetPlugin (options.sub_atributo)
				if (plugin) then
					icone =  plugin.__icon
					coords = default_coords
					name = plugin.__name
					vcolor = vertex_color_default
				else
					icone = [[Interface\AddOns\Details\images\icons]]
					coords = add_coords
					name = Loc ["STRING_SWITCH_CLICKME"]
					vcolor = vertex_color_unknown
					add = true
				end
			else
				icone = _detalhes.sub_atributos [options.atributo].icones [options.sub_atributo] [1]
				coords = _detalhes.sub_atributos [options.atributo].icones [options.sub_atributo] [2]
				name = _detalhes.sub_atributos [options.atributo].lista [options.sub_atributo]
				vcolor = vertex_color_default
			end
		else

			icone = [[Interface\AddOns\Details\images\icons]]
			coords = add_coords
			name = Loc ["STRING_SWITCH_CLICKME"]
			vcolor = vertex_color_unknown
			add = true
		end

		button:Show()
		button.button2:Show()
		button.fundo:Show()

		local width, height = button.button2.texto:GetSize()
		button.button2.texto:SetWidth (300)
		button.button2.texto:SetText (name)
		local text_width = button.button2.texto:GetStringWidth()
		while (text_width > _detalhes.switch.text_size) do
			_detalhes:SetFontSize (button.button2.texto, _detalhes.bookmark_text_size)
			local text = button.button2.texto:GetText()
			text = strsub (text, 1, #text-1)
			button.button2.texto:SetText (text)
			text_width = button.button2.texto:GetStringWidth()
		end
		
		button.button2.texto:SetSize (width, height)
		
		button.textureNormal:SetTexture (icone, true)
		button.textureNormal:SetTexCoord (_unpack (coords))
		button.textureNormal:SetVertexColor (_unpack (vcolor))
		button.texturePushed:SetTexture (icone, true)
		button.texturePushed:SetTexCoord (_unpack (coords))
		button.texturePushed:SetVertexColor (_unpack (vcolor))
		button.textureH:SetTexture (icone, true)
		button.textureH:SetVertexColor (_unpack (vcolor))
		button.textureH:SetTexCoord (_unpack (coords))
		button:ChangeIcon (button.textureNormal, button.texturePushed, nil, button.textureH)

		if (add) then
			button:SetSize (12, 12)
		else
			button:SetSize (15, 15)
		end
		
		if (name == Loc ["STRING_SWITCH_CLICKME"]) then
			--button.button2.texto:SetTextColor (.3, .3, .3, 1)
			button:SetAlpha (0.3)
			button.textureNormal:SetDesaturated (true)
			button.button2.texto:SetPoint ("left", button, "right", 5, -1)
		else
			--button.button2.texto:SetTextColor (.8, .8, .8, 1)
			button:SetAlpha (1)
			button.textureNormal:SetDesaturated (false)
			button.button2.texto:SetPoint ("left", button, "right", 3, -1)
		end
		
		if (jump) then 
			x = x - 125
			y = y + _detalhes.switch.button_height
			jump = false
		else
			x = x + 1254
			jump = true
		end
		
	end
	
	FauxScrollFrame_Update (DetailsSwitchPanelScroll, ceil (40 / _detalhes.switch.vertical_amt) , _detalhes.switch.horizontal_amt, 20)
end

local scroll = CreateFrame ("scrollframe", "DetailsSwitchPanelScroll", DetailsSwitchPanel, "FauxScrollFrameTemplate")
scroll:SetAllPoints()
scroll:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, _detalhes.switch.Update) end) --altura
scroll.ScrollBar:Hide()
scroll.ScrollBar.ScrollUpButton:Hide()
scroll.ScrollBar.ScrollDownButton:Hide()

function _detalhes.switch:Resize (precisa_mostrar)

	local x, x_original = 5, 5
	local y = 5
	local y_increment = 18
	
	local window_width, window_height = _detalhes.switch.current_instancia:GetSize()
	
	local horizontal_amt = floor (math.max (window_width / 100, 2))
	local vertical_amt = floor ((window_height - y) / y_increment)
	
	local total_amt = horizontal_amt * vertical_amt
	if (precisa_mostrar > total_amt) then
		--vertical_amt = floor ((window_height - y) / 15)
		--y_increment = 15
	end
	
	_detalhes.switch.y_increment = y_increment
	
	local size = window_width / horizontal_amt
	local frame = _detalhes.switch.frame
	
	for index, button in ipairs (_detalhes.switch.buttons) do
		button:Hide()
	end
	
	_detalhes.switch.vertical_amt = vertical_amt
	_detalhes.switch.horizontal_amt = horizontal_amt
	
	_detalhes.switch.text_size = size - 30
	
	local i = 1
	for vertical = 1, vertical_amt do
		x = x_original
		for horizontal = 1, horizontal_amt do
			local button = _detalhes.switch.buttons [i]
			
			local options = _detalhes.switch.table [i]
			if (not options) then 
				options = {atributo = nil, sub_atributo = nil}
				_detalhes.switch.table [i] = options
			end
			
			if (not button) then
				button = _detalhes.switch:NewSwitchButton (frame, i, x, y)
				button:SetFrameLevel (frame:GetFrameLevel()+2)
				_detalhes.switch.showing = _detalhes.switch.showing + 1
			end
			
			button:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint ("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint ("topleft", frame, "topleft", x, -y)	
			button.button2.texto:SetSize (size - 30, 12)
			button.button2:SetPoint ("bottomright", button, "bottomright", size - 30, 0)
			button.line:SetWidth (size - 15)
			button.line2:SetWidth (size - 15)
			
			button:Show()
			
			i = i + 1
			x = x + size
			if (i > 40) then
				break
			end
		end
		y = y + y_increment + 2
	end
	
	_detalhes.switch.slots = i-1
	
end

function _detalhes.switch:Resize2()

	local x = 7
	local y = 5
	local xPlus = (_detalhes.switch.current_instancia:GetSize()/2)-5
	local frame = _detalhes.switch.frame
	
	for index, button in ipairs (_detalhes.switch.buttons) do
		
		if (button.rightButton) then
			button:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint ("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint ("topleft", frame, "topleft", x, -y)	
			button.button2.texto:SetSize (xPlus - 30, 12)
			button.button2:SetPoint ("bottomright", button, "bottomright", xPlus - 30, 0)
			button.line:SetWidth (xPlus - 15)
			button.line2:SetWidth (xPlus - 15)
			
			x = x - xPlus
			y = y + _detalhes.switch.button_height
			jump = false
		else
			button:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureNormal:SetPoint ("topleft", frame, "topleft", x, -y)
			button.texturePushed:SetPoint ("topleft", frame, "topleft", x, -y)
			button.textureH:SetPoint ("topleft", frame, "topleft", x, -y)	
			button.button2.texto:SetSize (xPlus - 30, 12)
			button.button2:SetPoint ("topleft", button, "topright", 1, 0)
			button.button2:SetPoint ("bottomright", button, "bottomright", xPlus - 30, 0)
			button.line:SetWidth (xPlus - 20)
			button.line2:SetWidth (xPlus - 20)
			
			x = x + xPlus
			jump = true			
		end
		
	end
end

local onenter = function (self)
	if (not _detalhes.switch.table [self.id].atributo) then
		GameCooltip:Reset()
		_detalhes:CooltipPreset (1)
		GameCooltip:AddLine ("add bookmark")
		GameCooltip:AddIcon ([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]], 1, 1, 16, 16, 0.75, 1, 0, 1, {0, 1, 0})

		GameCooltip:SetOwner (self)
		GameCooltip:SetType ("tooltip")
		
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("ButtonsYMod", 0)
		GameCooltip:SetOption ("YSpacingMod", 0)
		GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
		
		GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		GameCooltip:SetBackdrop (2, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
		
		GameCooltip:Show()
	else
		GameCooltip:Hide()
	end

	_detalhes:SetFontColor (self.texto, "orange")
	--self.border:SetBlendMode ("ADD")
	--self.button1_icon:SetBlendMode ("ADD")
	
	DetailsSwitchPanel.hover_over_texture:SetSize (self:GetWidth(), self:GetHeight()) --size of button
	DetailsSwitchPanel.hover_over_texture:ClearAllPoints()
	DetailsSwitchPanel.hover_over_texture:SetPoint ("topleft", self, "topleft", -18, 1)
	DetailsSwitchPanel.hover_over_texture:SetPoint ("bottomright", self, "bottomright", 8, -1)
	DetailsSwitchPanel.hover_over_texture:Show()
	
end

local onleave = function (self)
	if (GameCooltip:IsTooltip()) then
		GameCooltip:Hide()
	end
	self.texto:SetTextColor (.9, .9, .9, .9)
	self.border:SetBlendMode ("BLEND")
	self.button1_icon:SetBlendMode ("BLEND")
end

local oniconenter = function (self)

	if (GameCooltip:IsMenu()) then
		return
	end

	GameCooltip:Reset()
	_detalhes:CooltipPreset (1)
	GameCooltip:AddLine ("select bookmark")
	GameCooltip:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 14, 0.0019531, 0.1484375, 0.6269531, 0.8222656)
	
	GameCooltip:SetOwner (self)
	GameCooltip:SetType ("tooltip")
	
	GameCooltip:SetOption ("TextSize", 10)
	GameCooltip:SetOption ("ButtonsYMod", 0)
	GameCooltip:SetOption ("YSpacingMod", 0)
	GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
	
	GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, backgroundColor, _detalhes.tooltip_border_color)
	
	_detalhes:SetFontColor (self.texto, "orange")
	
	GameCooltip:Show()
end

local oniconleave = function (self)
	if (GameCooltip:IsTooltip()) then
		GameCooltip:Hide()
	end
	
	self.texto:SetTextColor (.9, .9, .9, .9)
end

local left_box_on_click = function (self, button)
	if (button == "RightButton") then
		--select another bookmark
		_detalhes:FastSwitch (self, bookmark, self.bookmark_number, true)
	else
		--change the display
		local bookmark = _detalhes.switch.table [self.bookmark_number]
		if (bookmark.atributo) then
			_detalhes:FastSwitch (self, bookmark, self.bookmark_number)
		else
			--invalid bookmark, select another bookmark
			_detalhes:FastSwitch (self, bookmark, self.bookmark_number, true)
		end
	end
end

local right_box_on_click = function (self, button)
	if (button == "RightButton") then
		--close the bookmark menu
		_detalhes.switch:CloseMe()
	else
		--change the display
		local bookmark = _detalhes.switch.table [self.bookmark_number]
		if (bookmark.atributo) then
			_detalhes:FastSwitch (self, bookmark, self.bookmark_number)
		else
			--invalid bookmark, select another bookmark
			_detalhes:FastSwitch (self, bookmark, self.bookmark_number, true)
		end
	end
end

local change_icon = function (self, icon1, icon2, icon3, icon4)
	self:SetNormalTexture (icon1)
	self:SetPushedTexture (icon2)
	self:SetDisabledTexture (icon3)
	self:SetHighlightTexture (icon4, "ADD")
end
	
function _detalhes.switch:NewSwitchButton (frame, index, x, y, rightButton)

	local paramTable = {
			["instancia"] = _detalhes.switch.current_instancia, 
			["button"] = index, 
			["atributo"] = nil, 
			["sub_atributo"] = nil
		}

	--botao dentro da caixa
	local button = CreateFrame ("button", "DetailsSwitchPanelButton_1_"..index, frame) --botao com o icone
	button:SetSize (15, 24) 
	button:SetPoint ("topleft", frame, "topleft", x, -y)
	button:SetScript ("OnMouseDown", left_box_on_click)
	button:SetScript ("OnEnter", oniconenter)
	button:SetScript ("OnLeave", oniconleave)
	button.ChangeIcon = change_icon
	button.id = index
	
	--borda
	button.fundo = button:CreateTexture (nil, "overlay")
	button.fundo:SetTexCoord (0.00390625, 0.27734375, 0.44140625,0.69531250)
	button.fundo:SetWidth (26)
	button.fundo:SetHeight (24)
	button.fundo:SetPoint ("topleft", button, "topleft", -5, 5)
	
	--fundo marrom
	local fundo_x = -3
	local fundo_y = -5
	button.line = button:CreateTexture (nil, "background")
	button.line:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
	button.line:SetWidth (85)
	button.line:SetPoint ("topleft", button, "topright", fundo_x-14, 0)
	button.line:SetPoint ("bottomleft", button, "bottomright", fundo_x, fundo_y)
	button.line:SetAlpha (0.6)
	
	--fundo marrom 2
	button.line2 = button:CreateTexture (nil, "background")
	button.line2:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
	button.line2:SetWidth (85)
	button.line2:SetPoint ("topleft", button, "topright", fundo_x, 0)
	button.line2:SetPoint ("bottomleft", button, "bottomright", fundo_x, fundo_y)
	
	--botao do fundo marrom
	local button2 = CreateFrame ("button", "DetailsSwitchPanelButton_2_"..index, button) --botao com o texto
	button2:SetSize (1, 1)
	button2:SetPoint ("topleft", button, "topright", 1, 0)
	button2:SetPoint ("bottomright", button, "bottomright", 90, 0)
	button2:SetScript ("OnMouseDown", right_box_on_click)
	button2:SetScript ("OnEnter", onenter)
	button2:SetScript ("OnLeave", onleave)
	button2.id = index
	
	button.button2 = button2
	
	--icone
	button.textureNormal = button:CreateTexture (nil, "background")
	button.textureNormal:SetAllPoints (button)
	
	--icone pushed
	button.texturePushed = button:CreateTexture (nil, "background")
	button.texturePushed:SetAllPoints (button)
	
	--highlight
	button.textureH = button:CreateTexture (nil, "background")
	button.textureH:SetAllPoints (button)
	
	--texto do atributo
	gump:NewLabel (button2, button2, nil, "texto", "", "GameFontNormal")
	button2.texto:SetPoint ("left", button, "right", 5, -1)
	button2.texto:SetTextColor (.9, .9, .9, .9)
	
	_detalhes:SetFontSize (button2.texto, _detalhes.bookmark_text_size)
	
	button.texto = button2.texto
	
	button2.button1_icon = button.textureNormal
	button2.button1_icon2 = button.texturePushed
	button2.button1_icon3 = button.textureH
	button2.border = button.fundo
	
	button2.MouseOnEnterHook = onenter
	button2.MouseOnLeaveHook = onleave
	
	_detalhes.switch.buttons [index] = button
	
	return button
end
--doa

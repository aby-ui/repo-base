-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	-- none

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> create a button which will be displayed on tooltip
	function _detalhes.ToolBar:NewPluginToolbarButton (func, icon, pluginname, tooltip, w, h, framename, menu_function)

		--> random name if nameless
		if (not framename) then
			framename = "DetailsToolbarButton" .. math.random (1, 100000)
		end

		--> create button from template
		local button = CreateFrame ("button", framename, _detalhes.listener, "DetailsToolbarButton")
		
		--> sizes
		if (w) then
			button:SetWidth (w)
		end
		if (h) then
			button:SetHeight (h)
		end
		
		button.x = 0
		button.y = 0
		
		--> tooltip and function on click
		button.tooltip = tooltip
		button.menu = menu_function
		button:SetScript ("OnClick", func)
		
		--> textures
		button:SetNormalTexture (icon)
		button:SetPushedTexture (icon)
		button:SetDisabledTexture (icon)
		button:SetHighlightTexture (icon, "ADD")
		button.__icon = icon
		button.__name = pluginname
		
		--> blizzard built-in animation
		local FourCornerAnimeFrame = CreateFrame ("frame", framename.."Blink", button, "IconIntroAnimTemplate")
		FourCornerAnimeFrame:SetPoint ("center", button)
		FourCornerAnimeFrame:SetWidth (w or 14)
		FourCornerAnimeFrame:SetHeight (w or 14)
		FourCornerAnimeFrame.glow:SetScript ("OnFinished", nil)
		button.blink = FourCornerAnimeFrame
		
		_detalhes.ToolBar.AllButtons [#_detalhes.ToolBar.AllButtons+1] = button
		
		return button
	end
	
	--> show your plugin icon on tooltip
	function _detalhes:ShowToolbarIcon (Button, Effect)

		local LastIcon
		
		--> get the lower number instance
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (not lower_instance) then
			return
		end
		
		local instance = _detalhes:GetInstance (lower_instance)
		
		if (#_detalhes.ToolBar.Shown > 0) then
			--> already shown
			if (_detalhes:tableIN (_detalhes.ToolBar.Shown, Button)) then
				return
			end
			LastIcon = _detalhes.ToolBar.Shown [#_detalhes.ToolBar.Shown]
		else
			LastIcon = instance.baseframe.cabecalho.report
		end
		
		_detalhes.ToolBar.Shown [#_detalhes.ToolBar.Shown+1] = Button
		Button:SetPoint ("left", LastIcon.widget or LastIcon, "right", Button.x, Button.y)
		
		Button:Show()
		
		if (instance.auto_hide_menu.left and not instance.is_interacting) then
			instance:ToolbarMenuButtons()
			Button:SetAlpha (0)
			return
		end

		if (Effect) then
			if (type (Effect) == "string") then
				if (Effect == "blink") then
					Button.blink.glow:Play()
				elseif (Effect == "star") then
					Button.StarAnim:Play()
				end
			elseif (Effect) then
				Button.blink.glow:Play()
			end
		end
		
		_detalhes.ToolBar:ReorganizeIcons (true)
		
		return true
	end

	--> hide your plugin icon from toolbar
	function _detalhes:HideToolbarIcon (Button)
		
		local index = _detalhes:tableIN (_detalhes.ToolBar.Shown, Button)
		
		if (not index) then
			--> current not shown
			return
		end
		
		Button:Hide()
		table.remove (_detalhes.ToolBar.Shown, index)
		
		--> reorganize icons
		_detalhes.ToolBar:ReorganizeIcons (true)
		
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
do
	local PluginDescPanel = CreateFrame ("frame", "DetailsPluginDescPanel", UIParent)
	PluginDescPanel:SetFrameStrata ("tooltip")
	PluginDescPanel:Hide()
	PluginDescPanel:SetWidth (205)
	PluginDescPanel.BackdropTable = {}
	
	local background = PluginDescPanel:CreateTexture (nil, "artwork")
	background:SetPoint ("topleft", 0, 0)
	background:SetPoint ("bottomright", 0, 0)
	PluginDescPanel.background = background
	
	local icon, title, desc = PluginDescPanel:CreateTexture (nil, "overlay"), PluginDescPanel:CreateFontString (nil, "overlay", "GameFontNormal"), PluginDescPanel:CreateFontString (nil, "overlay", "GameFontNormal")
	icon:SetPoint ("topleft", 10, -10)
	icon:SetSize (16, 16)
	title:SetPoint ("left", icon, "right", 2, 0)
	desc:SetPoint ("topleft", 13, -30)
	desc:SetWidth (180)
	desc:SetJustifyH ("left")
	_detalhes:SetFontColor (desc, "white")
	
	PluginDescPanel.icon = icon
	PluginDescPanel.title = title
	PluginDescPanel.desc = desc
end

	--[[global]] function DetailsToolbarButtonOnEnter (button)
	
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			_detalhes.OnEnterMainWindow (_detalhes:GetInstance (lower_instance), button, 3)
		end
	
		if (button.tooltip) then
			if (button.menu) then
				_detalhes.gump:QuickDispatch (button.menu)
				
				local next_check = 0.8
				
				--check if the mouse is still interacting with the menu or with the button
				button:SetScript ("OnUpdate", function (self, elapsed)
					next_check = next_check - elapsed
					
					if (next_check < 0) then
						if (not GameCooltipFrame1:IsMouseOver() and not button:IsMouseOver()) then
							GameCooltip2:Hide()
							button:SetScript ("OnUpdate", nil)
							return
						end
						next_check = 0.8
					end
				end)
				
				--disable the hider menu if the cooltip is required in another place
				hooksecurefunc (GameCooltip2, "ShowCooltip", function()
					button:SetScript ("OnUpdate", nil)
				end)
				
				return
			end
		
			GameCooltip:Hide()
			local plugin_object = _detalhes:GetPlugin (button.__name)
			
			local f = DetailsPluginDescPanel
			f.icon:SetTexture (button.__icon)
			f.title:SetText (button.__name)
			f.desc:SetText (plugin_object:GetPluginDescription())
			_detalhes:SetFontSize (f.desc, _detalhes.font_sizes.menus)
			_detalhes:SetFontFace (f.desc, _detalhes.font_faces.menus)
			
			--f.background:SetTexture (_detalhes.tooltip.menus_bg_texture)
			f.background:SetTexCoord (unpack (_detalhes.tooltip.menus_bg_coords))
			f.background:SetVertexColor (unpack (_detalhes.tooltip.menus_bg_color))
			--f.background:SetDesaturated (true)
			
			f.BackdropTable.bgFile = _detalhes.tooltip_backdrop.bgFile
			f.BackdropTable.edgeFile = [[Interface\Buttons\WHITE8X8]] --_detalhes.tooltip_backdrop.edgeFile
			f.BackdropTable.tile = _detalhes.tooltip_backdrop.tile
			f.BackdropTable.edgeSize = 1 --_detalhes.tooltip_backdrop.edgeSize
			f.BackdropTable.tileSize = _detalhes.tooltip_backdrop.tileSize
			
			f:SetBackdrop (f.BackdropTable)
			local r, g, b, a = _detalhes.gump:ParseColors (_detalhes.tooltip_border_color)
			f:SetBackdropBorderColor (r, g, b, a)
			
			f:SetHeight (40 + f.desc:GetStringHeight())
			f:SetPoint ("bottom", button, "top", 0, 10)
			f:Show()
			--SharedMedia:Fetch ("font", "Friz Quadrata TT")
			
			
		end
	end
	--[[global]] function DetailsToolbarButtonOnLeave (button)
	
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			_detalhes.OnLeaveMainWindow (_detalhes:GetInstance (lower_instance), button, 3)
		end
	
		if (button.tooltip) then
			DetailsPluginDescPanel:Hide()
		end
	end	

	_detalhes:RegisterEvent (_detalhes.ToolBar, "DETAILS_INSTANCE_OPEN", "OnInstanceOpen")
	_detalhes:RegisterEvent (_detalhes.ToolBar, "DETAILS_INSTANCE_CLOSE", "OnInstanceClose")
	_detalhes.ToolBar.Enabled = true --> must have this member or wont receive the event
	_detalhes.ToolBar.__enabled = true

	function _detalhes.ToolBar:OnInstanceOpen() 
		_detalhes.ToolBar:ReorganizeIcons (true)
	end
	function _detalhes.ToolBar:OnInstanceClose() 
		_detalhes.ToolBar:ReorganizeIcons (true)
	end

	function _detalhes.ToolBar:ReorganizeIcons (just_refresh)
		--> get the lower number instance
		local lower_instance = _detalhes:GetLowerInstanceNumber()
	
		if (not lower_instance) then
			for _, ThisButton in ipairs (_detalhes.ToolBar.Shown) do 
				ThisButton:Hide()
			end
			return
		end

		local instance = _detalhes:GetInstance (lower_instance)

		if (not just_refresh) then
			for _, instancia in pairs (_detalhes.tabela_instancias) do 
				if (instancia.baseframe and instancia:IsAtiva()) then
					instancia:ReajustaGump()
				end
			end

			instance:ChangeSkin()
		else
			instance:ToolbarMenuButtons()
			instance:SetAutoHideMenu (nil, nil, true)
		end
		
		return true
	end

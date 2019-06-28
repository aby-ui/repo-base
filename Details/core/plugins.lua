	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _detalhes = _G._detalhes
	DETAILSPLUGIN_ALWAYSENABLED = 0x1
	
	--> consts
		local CONST_PLUGINWINDOW_MENU_WIDTH = 150
		local CONST_PLUGINWINDOW_MENU_HEIGHT = 22
		local CONST_PLUGINWINDOW_MENU_X = -5
		local CONST_PLUGINWINDOW_MENU_Y = -26
		local CONST_PLUGINWINDOW_WIDTH = 925
		local CONST_PLUGINWINDOW_HEIGHT = 600
	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions
	function _detalhes:GetPlugin (PAN) --plugin absolute name
		return _detalhes.SoloTables.NameTable [PAN] or _detalhes.RaidTables.NameTable [PAN] or _detalhes.ToolBar.NameTable [PAN] or _detalhes.StatusBar.NameTable [PAN] or _detalhes.PluginsLocalizedNames [PAN] or _detalhes.PluginsGlobalNames [PAN]
	end
	
	function _detalhes:GetPluginSavedTable (PluginAbsoluteName)
		return _detalhes.plugin_database [PluginAbsoluteName]
	end
	
	function _detalhes:UpdatePluginBarsConfig()
		local instance = self:GetPluginInstance()
		if (instance) then
			self.row_info = self.row_info or {}
			_detalhes.table.copy (self.row_info, instance.row_info)
			self.bars_grow_direction = instance.bars_grow_direction
			self.row_height = instance.row_height
			self:SetBarGrowDirection()
		end
	end
	
	function _detalhes:AttachToInstance()
		local instance = self:GetPluginInstance()
		if (instance) then
			local w, h = instance:GetSize()
			self.Frame:SetSize (w, h)
		end
	end
	
	function _detalhes:GetPluginInstance (PluginAbsoluteName)
		local plugin = self
		if (PluginAbsoluteName) then
			plugin = _detalhes:GetPlugin (PluginAbsoluteName)
		end
		
		local id = plugin.instance_id
		if (id) then
			return _detalhes:GetInstance (id)
		end
	end
	
	function _detalhes:IsPluginEnabled (PluginAbsoluteName)
		if (PluginAbsoluteName) then
			local plugin = _detalhes.plugin_database [PluginAbsoluteName]
			if (plugin) then
				return plugin.enabled
			end
		else
			return self.__enabled
		end
	end
	
	function _detalhes:SetPluginDescription (desc)
		self.__description = desc
	end
	function _detalhes:GetPluginDescription()
		return self.__description or ""
	end
	
	function _detalhes:DisablePlugin (AbsoluteName)
		local plugin = _detalhes:GetPlugin (AbsoluteName)
		
		if (plugin) then
			local saved_table = _detalhes:GetPluginSavedTable (AbsoluteName)
			
			saved_table.enabled = false
			plugin.__enabled = false
		
			_detalhes:SendEvent ("PLUGIN_DISABLED", plugin)
			
			_detalhes:DelayOptionsRefresh()
			return true
		end
	end
	
	function _detalhes:CheckDefaultTable (current, default)
		for key, value in pairs (default) do 
			if (type (value) == "table") then
				if (type (current [key]) ~= "table") then
					current [key] = table_deepcopy (value)
				else
					_detalhes:CheckDefaultTable (current [key], value)
				end
			else
				if (current [key] == nil) then
					current [key] = value
				--elseif (type (current [key]) ~= type (value)) then
				--	current [key] = value
				end
			end
		end
	end

	function _detalhes:InstallPlugin (PluginType, PluginName, PluginIcon, PluginObject, PluginAbsoluteName, MinVersion, Author, Version, DefaultSavedTable)

		if (MinVersion and MinVersion > _detalhes.realversion) then
			print (PluginName, Loc ["STRING_TOOOLD"])
			return _detalhes:NewError ("Details version is out of date.")
		end
		
		if (_detalhes.FILEBROKEN) then
			return _detalhes:NewError ("Game client needs to be restarted in order to finish Details! update.")
		end
		
		if (PluginType == "TANK") then
			PluginType = "RAID"
		end
	
		if (not PluginType) then
			return _detalhes:NewError ("InstallPlugin parameter 1 (plugin type) not especified")
		elseif (not PluginName) then
			return _detalhes:NewError ("InstallPlugin parameter 2 (plugin name) can't be nil")
		elseif (not PluginIcon) then
			return _detalhes:NewError ("InstallPlugin parameter 3 (plugin icon) can't be nil")
		elseif (not PluginObject) then
			return _detalhes:NewError ("InstallPlugin parameter 4 (plugin object) can't be nil")
		elseif (not PluginAbsoluteName) then
			return _detalhes:NewError ("InstallPlugin parameter 5 (plugin absolut name) can't be nil")
		end
		
		if (_G [PluginAbsoluteName]) then
			print (Loc ["STRING_PLUGIN_NAMEALREADYTAKEN"] .. ": " .. PluginName .. " name: " .. PluginAbsoluteName)
			return
		else
			_G [PluginAbsoluteName] = PluginObject
			PluginObject.real_name = PluginAbsoluteName
		end
		
		PluginObject.__name = PluginName
		PluginObject.__author = Author or "--------"
		PluginObject.__version = Version or "v1.0.0"
		PluginObject.__icon = PluginIcon or [[Interface\ICONS\Trade_Engineering]]
		PluginObject.real_name = PluginAbsoluteName
		
		_detalhes.PluginsGlobalNames [PluginAbsoluteName] = PluginObject
		_detalhes.PluginsLocalizedNames [PluginName] = PluginObject
		
		local saved_table
		
		if (PluginType ~= "STATUSBAR") then
			saved_table = _detalhes.plugin_database [PluginAbsoluteName]
			
			if (not saved_table) then
				saved_table = {enabled = true, author = Author or "--------"}
				_detalhes.plugin_database [PluginAbsoluteName] = saved_table
			end
			
			if (DefaultSavedTable) then
				_detalhes:CheckDefaultTable (saved_table, DefaultSavedTable)
			end
			
			PluginObject.__enabled = saved_table.enabled
		end
		
		if (PluginType == "SOLO") then
			if (not PluginObject.Frame) then
				return _detalhes:NewError ("plugin doesn't have a Frame, please check case-sensitive member name: Frame")
			end
			
			--> Install Plugin
			_detalhes.SoloTables.Plugins [#_detalhes.SoloTables.Plugins+1] = PluginObject
			_detalhes.SoloTables.Menu [#_detalhes.SoloTables.Menu+1] = {PluginName, PluginIcon, PluginObject, PluginAbsoluteName}
			_detalhes.SoloTables.NameTable [PluginAbsoluteName] = PluginObject
			_detalhes:SendEvent ("INSTALL_OKEY", PluginObject)
			
			_detalhes.PluginCount.SOLO = _detalhes.PluginCount.SOLO + 1

		elseif (PluginType == "RAID") then
			
			--> Install Plugin
			_detalhes.RaidTables.Plugins [#_detalhes.RaidTables.Plugins+1] = PluginObject
			_detalhes.RaidTables.Menu [#_detalhes.RaidTables.Menu+1] = {PluginName, PluginIcon, PluginObject, PluginAbsoluteName}
			_detalhes.RaidTables.NameTable [PluginAbsoluteName] = PluginObject
			_detalhes:SendEvent ("INSTALL_OKEY", PluginObject)
			
			_detalhes.PluginCount.RAID = _detalhes.PluginCount.RAID + 1
			
			_detalhes:InstanceCall ("RaidPluginInstalled", PluginAbsoluteName)
			
		elseif (PluginType == "TOOLBAR") then
			
			--> Install Plugin
			_detalhes.ToolBar.Plugins [#_detalhes.ToolBar.Plugins+1] = PluginObject
			_detalhes.ToolBar.Menu [#_detalhes.ToolBar.Menu+1] = {PluginName, PluginIcon, PluginObject, PluginAbsoluteName}
			_detalhes.ToolBar.NameTable [PluginAbsoluteName] = PluginObject
			_detalhes:SendEvent ("INSTALL_OKEY", PluginObject)
			
			_detalhes.PluginCount.TOOLBAR = _detalhes.PluginCount.TOOLBAR + 1
			
		elseif (PluginType == "STATUSBAR") then	
		
			--> Install Plugin
			_detalhes.StatusBar.Plugins [#_detalhes.StatusBar.Plugins+1] = PluginObject
			_detalhes.StatusBar.Menu [#_detalhes.StatusBar.Menu+1] = {PluginName, PluginIcon}
			_detalhes.StatusBar.NameTable [PluginAbsoluteName] = PluginObject
			_detalhes:SendEvent ("INSTALL_OKEY", PluginObject)
			
			_detalhes.PluginCount.STATUSBAR = _detalhes.PluginCount.STATUSBAR + 1
		end
		
		if (saved_table) then
			PluginObject.db = saved_table
		end
		
		if (PluginObject.__enabled) then
			return true, saved_table, true
		else
			return true, saved_table, false
		end
		
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
	
	_detalhes.PluginCount = {
		["SOLO"] = 0,
		["RAID"] = 0,
		["TOOLBAR"] = 0,
		["STATUSBAR"] = 0
	}	
		
	local OnEnableFunction = function (self)
		self.__parent.Enabled = true
		--self = frame __parent = plugin object
		local instance = _detalhes:GetInstance (self.__parent.instance_id)
		if (instance) then
			self:SetParent (instance.baseframe)
		end
		_detalhes:SendEvent ("SHOW", self.__parent)
	end

	local OnDisableFunction = function (self)
		_detalhes:SendEvent ("HIDE", self.__parent)
		if (bit.band (self.__parent.__options, DETAILSPLUGIN_ALWAYSENABLED) == 0) then
			self.__parent.Enabled = false
		end
	end

	local BuildDefaultStatusBarMembers = function (self)
		self.childs = {}
		self.__index = self
		function self:Setup()
			_detalhes.StatusBar:OpenOptionsForChild (self)
		end
	end
	
	local temp_event_function = function()
		print ("=====================")
		print ("Hello There plugin developer!")
		print ("Please make sure you are declaring")
		print ("A member called 'OnDetailsEvent' on your plugin object")
		print ("With a function to receive the events like bellow:")
		print ("function PluginObject:OnDetailsEvent (event, ...) end")
		print ("Thank You Sir!===================")
	end

	local register_event_func = function (self, event)
		self.Frame:RegisterEvent (event)
	end
	local unregister_event_func = function (self, event)
		self.Frame:UnregisterEvent (event)
	end
	
	function _detalhes:NewPluginObject (FrameName, PluginOptions, PluginType)

		PluginOptions = PluginOptions or 0x0
		local NewPlugin = {__options = PluginOptions, __enabled = true, RegisterEvent = register_event_func, UnregisterEvent = unregister_event_func}
		
		local Frame = CreateFrame ("Frame", FrameName, UIParent)
		Frame:RegisterEvent ("PLAYER_LOGIN")
		Frame:RegisterEvent ("PLAYER_LOGOUT")
		
		Frame:SetScript ("OnEvent", function(self, event, ...) 
			if (NewPlugin.OnEvent) then
				if (event == "PLAYER_LOGIN") then
					NewPlugin:OnEvent (self, "ADDON_LOADED", NewPlugin.Frame:GetName())
					NewPlugin.Frame:Hide()
					return
				end
				return NewPlugin:OnEvent (self, event, ...) 
			end
		end)
		
		Frame:SetFrameStrata ("HIGH")
		Frame:SetFrameLevel (6)

		Frame:Hide()
		Frame.__parent = NewPlugin
		
		if (bit.band (PluginOptions, DETAILSPLUGIN_ALWAYSENABLED) ~= 0) then
			NewPlugin.Enabled = true
		else
			NewPlugin.Enabled = false
		end
		
		--> default members
		if (PluginType == "STATUSBAR") then
			BuildDefaultStatusBarMembers (NewPlugin)
		end
		
		NewPlugin.Frame = Frame
		
		Frame:SetScript ("OnShow", OnEnableFunction)
		Frame:SetScript ("OnHide", OnDisableFunction)
		
		--> temporary details event function
		NewPlugin.OnDetailsEvent = temp_event_function
		
		setmetatable (NewPlugin, _detalhes)
		
		return NewPlugin
	end

	function _detalhes:CreatePluginOptionsFrame (name, title, template)
	
		template = template or 1
	
		if (template == 2) then
			local options_frame = CreateFrame ("frame", name, UIParent, "ButtonFrameTemplate")
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)
			
			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			options_frame.TitleText:SetText (title)
			options_frame.portrait:SetTexture ([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-BLOODELF]])
			
			return options_frame
	
		elseif (template == 1) then
		
			local options_frame = CreateFrame ("frame", name, UIParent)
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)

			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			
			options_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
			edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize = 32,
			insets = {left = 1, right = 1, top = 1, bottom = 1}})
			options_frame:SetBackdropColor (0, 0, 0, .7)

			Details.gump:ApplyStandardBackdrop (options_frame)
			Details.gump:CreateTitleBar (options_frame, title)

			local bigdog = _detalhes.gump:NewImage (options_frame, [[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]], 110, 120, nil, {1, 0, 0, 1}, "backgroundBigDog", "$parentBackgroundBigDog")
			bigdog:SetPoint ("bottomright", options_frame, "bottomright", -3, 0)
			bigdog:SetAlpha (.25)
			
			return options_frame
		end
	end
	
	
	function _detalhes:CreatePluginWindowContainer()
	
		local f = CreateFrame ("frame", "DetailsPluginContainerWindow", UIParent)
		f:EnableMouse (true)
		f:SetMovable (true)
		f:SetPoint ("center", UIParent, "center")
		f:SetBackdrop (_detalhes.PluginDefaults and _detalhes.PluginDefaults.Backdrop or {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		f:SetBackdropColor (0, 0, 0, 0.3)
	
		f:Hide()

		--> members
			f.MenuX = CONST_PLUGINWINDOW_MENU_X
			f.MenuY = CONST_PLUGINWINDOW_MENU_Y
			f.MenuButtonWidth = CONST_PLUGINWINDOW_MENU_WIDTH
			f.MenuButtonHeight = CONST_PLUGINWINDOW_MENU_HEIGHT
			f.FrameWidth = CONST_PLUGINWINDOW_WIDTH
			f.FrameHeight = CONST_PLUGINWINDOW_HEIGHT
			f.TitleHeight = 20
			
			--> store button references for the left menu
			f.MenuButtons = {}
			--> store all plugins embed
			f.EmbedPlugins = {}
		
		--> lib window
			f:SetSize (f.FrameWidth, f.FrameHeight)
			local LibWindow = LibStub ("LibWindow-1.1")
			LibWindow.RegisterConfig (f, _detalhes.plugin_window_pos)
			LibWindow.RestorePosition (f)
			LibWindow.MakeDraggable (f)
			LibWindow.SavePosition (f)
			
		--> menu background
			local menuBackground = CreateFrame ("frame", "$parentMenuFrame", f)
			_detalhes:FormatBackground (menuBackground)
			
		--> statusbar
			local statusBar = CreateFrame ("frame", nil, menuBackground)
			statusBar:SetPoint ("topleft", menuBackground, "bottomleft", 0, 1)
			statusBar:SetPoint ("topright", f, "bottomright", 0, 1)
			statusBar:SetHeight (20)
			_detalhes.gump:ApplyStandardBackdrop (statusBar)
			statusBar:SetAlpha (1)
			_detalhes.gump:BuildStatusbarAuthorInfo (statusBar)
			--
			local right_click_to_back = _detalhes.gump:CreateLabel (statusBar, "right click to close", 10, "gray")
			right_click_to_back:SetPoint ("bottomright", statusBar, "bottomright", -1, 5)
			right_click_to_back:SetAlpha (.4)

			--> point
			menuBackground:SetPoint ("topright", f, "topleft", -2, 0)
			menuBackground:SetPoint ("bottomright", f, "bottomleft", -2, 0)
			menuBackground:SetWidth (f.MenuButtonWidth + 6)
			
			local bigdog = _detalhes.gump:NewImage (menuBackground, [[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]], 180*0.7, 200*0.7, "overlay", {0, 1, 0, 1}, "backgroundBigDog", "$parentBackgroundBigDog")
			bigdog:SetPoint ("bottomleft", custom_window, "bottomleft", 0, 1)
			bigdog:SetAlpha (0.3)
			
			local bigdogRow = menuBackground:CreateTexture (nil, "artwork")
			bigdogRow:SetPoint ("bottomleft", menuBackground, "bottomleft", 1, 1)
			bigdogRow:SetPoint ("bottomright", menuBackground, "bottomright", -1, 1)
			bigdogRow:SetHeight (20)
			bigdogRow:SetColorTexture (.5, .5, .5, .1)
			bigdogRow:Hide()
			
			--
		--> plugins menu title bar
			local titlebar_plugins = CreateFrame ("frame", nil, menuBackground)
			PixelUtil.SetPoint (titlebar_plugins, "topleft", menuBackground, "topleft", 2, -3)
			PixelUtil.SetPoint (titlebar_plugins, "topright", menuBackground, "topright", -2, -3)
			titlebar_plugins:SetHeight (f.TitleHeight)
			titlebar_plugins:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar_plugins:SetBackdropColor (.5, .5, .5, 1)
			titlebar_plugins:SetBackdropBorderColor (0, 0, 0, 1)
			--> title
			local titleLabel = _detalhes.gump:NewLabel (titlebar_plugins, titlebar_plugins, nil, "titulo", "Plugins", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
			PixelUtil.SetPoint (titleLabel, "center", titlebar_plugins , "center", 0, 0)
			PixelUtil.SetPoint (titleLabel, "top", titlebar_plugins , "top", 0, -5)
			
		--> plugins menu title bar
			local titlebar_tools = CreateFrame ("frame", nil, menuBackground)
			titlebar_tools:SetHeight (f.TitleHeight)
			titlebar_tools:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar_tools:SetBackdropColor (.5, .5, .5, 1)
			titlebar_tools:SetBackdropBorderColor (0, 0, 0, 1)
			--> title
			local titleLabel = _detalhes.gump:NewLabel (titlebar_tools, titlebar_tools, nil, "titulo", "Tools", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
			PixelUtil.SetPoint (titleLabel, "center", titlebar_tools , "center", 0, 0)
			PixelUtil.SetPoint (titleLabel, "top", titlebar_tools , "top", 0, -5)
		
		--> scripts
			f:SetScript ("OnShow", function()
				--check if the window isn't out of screen
				C_Timer.After (1, function()
					local right = f:GetRight()
					if (right and right > GetScreenWidth() + 500) then
						f:ClearAllPoints()
						f:SetPoint ("center", UIParent, "center", 0, 0)
						LibWindow.SavePosition (f)
						_detalhes:Msg ("detected options panel out of screen, position has reset")
					end
				end)
			end)
			
			f:SetScript ("OnHide", function()
				
			end)
			
			f:SetScript ("OnMouseDown", function (self, button)
				if (button == "RightButton") then
					f.ClosePlugin()
				end
			end)
			
			f.Debug = false
			function f.DebugMsg (...)
				if (f.Debug) then
					print ("[Details! Debug]", ...)
				end
			end
		

		
		function f.OnMenuClick (_, _, pluginAbsName, callRefresh)

			--> get the plugin
			local pluginObject = _detalhes:GetPlugin (pluginAbsName)
			if (not pluginObject) then
				for index, plugin in ipairs (f.EmbedPlugins) do 
					if (plugin.real_name == pluginAbsName) then
						pluginObject = plugin
					end
				end
				
				if (not pluginObject) then
					f.DebugMsg ("Plugin not found")
					return
				end
			end
			
			--> hide or show plugin windows
			for index, plugin in ipairs (f.EmbedPlugins) do 
				if (plugin ~= pluginObject) then
					--> hide this plugin
					if (plugin.Frame:IsShown()) then
						plugin.Frame:Hide()
					end
				end
			end
			
			--> re set the point of the frame within the main plugin window
			f.RefreshFrame (pluginObject.__var_Frame)
			C_Timer.After (0.016, function ()
				f.RefreshFrame (pluginObject.__var_Frame)
			end)
			
			--> show the plugin window
			if (pluginObject.RefreshWindow and callRefresh) then
				DetailsFramework:QuickDispatch (pluginObject.RefreshWindow)
			end
			
			--> highlight the plugin button on the menu
			for index, button in ipairs (f.MenuButtons) do
				button:Show()
				
				if (button.PluginAbsName == pluginAbsName) then
					--> emphatizate this button
					button:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTONSELECTED_TEMPLATE"))
				else
					--> make this button regular
					button:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
				end
			end
			
			--> show the container
			f:Show()
			
			return true
		end
		
		function f.CreatePluginMenuButton (pluginObject, isUtility)
			--> create the button
			local newButton = _detalhes.gump:CreateButton (f, f.OnMenuClick, f.MenuButtonWidth, f.MenuButtonHeight, pluginObject.__name, pluginObject.real_name, true)
			newButton.PluginAbsName = pluginObject.real_name
			newButton.PluginName = pluginObject.__name
			newButton.IsUtility = isUtility
			
			--> add a template
			newButton:SetTemplate (_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
			newButton:SetText (pluginObject.__name)
			newButton.textsize = 10
			
			--> set icon
			newButton:SetIcon (pluginObject.__icon, nil, nil, nil, pluginObject.__iconcoords, pluginObject.__iconcolor, 4)
			
			--> add it to menu table
			tinsert (f.MenuButtons, newButton)
			
			return newButton
		end

		local on_hide = function (self)
			DetailsPluginContainerWindow.ClosePlugin()
		end
		
		function f.RefreshFrame (frame)
			frame:EnableMouse (false)
			frame:SetSize (f.FrameWidth, f.FrameHeight)
			frame:SetScript ("OnMouseDown", nil)
			frame:SetScript ("OnMouseUp", nil)
			--frame:SetScript ("OnHide", on_hide)
			frame:HookScript ("OnHide", on_hide)
			frame:ClearAllPoints()
			PixelUtil.SetPoint (frame, "topleft", f, "topleft", 0, 0)
			frame:Show()
		end
		
		--> a plugin request to be embed into the main plugin window		
		function f.EmbedPlugin (pluginObject, frame, isUtility)
		
			--> check if the plugin has a frame
			if (not pluginObject.Frame) then
				f.DebugMsg ("plugin doesn't have a frame.")
				return
			end
			
			--> create a button for this plugin
			local newMenuButtom = f.CreatePluginMenuButton (pluginObject, isUtility)
			
			--> utility is true when the object isn't a real plugin, but instead a tool frame from the main addon being embed on this panel
			if (isUtility) then
				pluginObject.__var_Utility = true
			end
			pluginObject.__var_Frame = frame
			
			--> sort buttons alphabetically, put utilities at the end
			table.sort (f.MenuButtons, function (t1, t2)
				if (t1.IsUtility and t2.IsUtility) then
					return t1.PluginName < t2.PluginName
				elseif (t1.IsUtility) then
					return false
				elseif (t2.IsUtility) then
					return true
				else
					return t1.PluginName < t2.PluginName
				end
			end) 
			
			--> reset the buttons points
			local addingTools = false
			for index, button in ipairs (f.MenuButtons) do
				button:ClearAllPoints()
				PixelUtil.SetPoint (button, "center", menuBackground, "center", 0, 0)

				if (button.IsUtility) then
					--> add -20 to add a gap between plugins and utilities
					
					if (not addingTools) then
						--> add the header
						addingTools = true
						PixelUtil.SetPoint (titlebar_tools, "topleft", menuBackground, "topleft", 2, f.MenuY + ( (index-1) * -f.MenuButtonHeight ) - index - 20)
						PixelUtil.SetPoint (titlebar_tools, "topright", menuBackground, "topright", -2, f.MenuY + ( (index-1) * -f.MenuButtonHeight ) - index - 20)
					end
					
					PixelUtil.SetPoint (button, "top", menuBackground, "top", 0, f.MenuY + ( (index-1) * -f.MenuButtonHeight ) - index - 40)
				else
					PixelUtil.SetPoint (button, "top", menuBackground, "top", 0, f.MenuY + ( (index-1) * -f.MenuButtonHeight ) - index)
				end
			end
			
			--> format the plugin main frame
			f.RefreshFrame (frame)
			--> add the plugin to embed table
			tinsert (f.EmbedPlugins, pluginObject)
			
			f.DebugMsg ("plugin added", pluginObject.__name)
		end
		
		function f.OpenPlugin (pluginObject)
			--> just simulate a click on the menu button
			f.OnMenuClick (_, _, pluginObject.real_name)
		end
		
		function f.ClosePlugin()
			--> hide all embed plugins
			for index, plugin in ipairs (f.EmbedPlugins) do 
				plugin.Frame:Hide()
			end
			--> hide the main frame
			f:Hide()
		end
		
		--[=[
			Function to be used on macros to open a plugin, signature:
			Details:OpenPlugin (PLUGIN_ABSOLUTE_NAME)
			Details:OpenPlugin (PluginObject)
			Details:OpenPlugin ("Plugin Name")
			
			Example: /run Details:OpenPlugin ("Time Line")
		--]=]
		
		function _detalhes:OpenPlugin (wildcard)
			local originalName = wildcard
			
			if (type (wildcard) == "string") then
			
				--> check if passed a plugin absolute name
				local pluginObject = _detalhes:GetPlugin (wildcard)
				if (pluginObject) then
					f.OpenPlugin (pluginObject)
					return true
				end
				
				--> check if passed a plugin name, remove spaces and make it lower case
				wildcard = string.lower (wildcard)
				wildcard = wildcard:gsub ("%s", "")
				
				for index, pluginInfoTable in ipairs (_detalhes.ToolBar.Menu) do
					local pluginName = pluginInfoTable [1]
					pluginName = string.lower (pluginName)
					pluginName = pluginName:gsub ("%s", "")
					
					if (pluginName ==  wildcard) then
						local pluginObject = pluginInfoTable [3]
						f.OpenPlugin (pluginObject)
						return true
					end
				end
			
			--> check if passed a plugin object
			elseif (type (wildcard) == "table") then
				if (wildcard.__name) then
					f.OpenPlugin (wildcard)
					return true
				end
			end
			
			Details:Msg ("|cFFFF7700plugin not found|r:|cFFFFFF00", (originalName or wildcard), "|rcheck if it is enabled in the addons control panel.") --localize-me
		end
		
		
	end
	
	
	
	
	
--stop auto complete: doe enda endb

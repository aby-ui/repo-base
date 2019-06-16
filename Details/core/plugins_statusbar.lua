	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
	
	local DEFAULT_CHILD_WIDTH = 60
	local DEFAULT_CHILD_HEIGHT = 16
	local DEFAULT_CHILD_FONTFACE = "Friz Quadrata TT"
	local DEFAULT_CHILD_FONTCOLOR = {1, 0.733333, 0, 1}
	local DEFAULT_CHILD_FONTSIZE = 10
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _math_floor = math.floor --> api local
	local _ipairs = ipairs --> api local


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> status bar core functions

	--> hida all micro frames
	function _detalhes.StatusBar:Hide (instance, side)
		if (not side) then
			if (instance.StatusBar.center and instance.StatusBar.left and instance.StatusBar.right) then
				instance.StatusBar.center.frame:Hide()
				instance.StatusBar.left.frame:Hide()
				instance.StatusBar.right.frame:Hide()
			end
		end
	end
	
	function _detalhes.StatusBar:Show (instance, side)
		if (not side) then
			if (instance.StatusBar.center and instance.StatusBar.left and instance.StatusBar.right) then
				instance.StatusBar.center.frame:Show()
				instance.StatusBar.left.frame:Show()
				instance.StatusBar.right.frame:Show()
			end
		end
	end
	
	function _detalhes.StatusBar:LockDisplays (instance, locked)
		if (instance.StatusBar.center and instance.StatusBar.left and instance.StatusBar.right) then
			if (locked) then
				instance.StatusBar.center.frame:EnableMouse (false)
				instance.StatusBar.left.frame:EnableMouse (false)
				instance.StatusBar.right.frame:EnableMouse (false)
			else
				instance.StatusBar.center.frame:EnableMouse (true)
				instance.StatusBar.left.frame:EnableMouse (true)
				instance.StatusBar.right.frame:EnableMouse (true)
			end
		end
	end
	
	--> create a plugin child for an instance
	function _detalhes.StatusBar:CreateStatusBarChildForInstance (instance, pluginName)
		local PluginObject = _detalhes.StatusBar.NameTable [pluginName]
		if (PluginObject) then
			local new_child = PluginObject:CreateChildObject (instance)
			if (new_child) then
				instance.StatusBar [#instance.StatusBar+1] = new_child
				new_child.enabled = false
				return new_child
			end
		end
		return nil
	end

	function _detalhes.StatusBar:AlignPluginText (child, default)
		local side = child.options.textAlign
		if (child.options.textAlign == 0) then
			side = default
		end
		
		child.text:ClearAllPoints()
		if (side == 1) then
			child.text:SetPoint ("left", child.frame, "left", child.options.textXMod, child.options.textYMod)
		elseif (side == 2) then
			child.text:SetPoint ("center", child.frame, "center", child.options.textXMod, child.options.textYMod)
		elseif (side == 3) then
			child.text:SetPoint ("right", child.frame, "right", child.options.textXMod, child.options.textYMod)
		end
	end
	
	--> functions to set the three statusbar places: left, center and right
		function _detalhes.StatusBar:SetCenterPlugin (instance, childObject, fromStartup)
			childObject.frame:Show()
			childObject.frame:ClearAllPoints()
			
			if (instance.micro_displays_side == 2) then --> default - bottom
				childObject.frame:SetPoint ("center", instance.baseframe.rodape.StatusBarCenterAnchor, "center")
			elseif (instance.micro_displays_side == 1) then --> top side
				childObject.frame:SetPoint ("center", instance.baseframe.cabecalho.StatusBarCenterAnchor, "center")
			end
			
			_detalhes.StatusBar:AlignPluginText (childObject, 2)
			
			instance.StatusBar.center = childObject
			childObject.anchor = "center"
			childObject.enabled = true
			if (childObject.OnEnable) then
				childObject:OnEnable()
			end
			
			if (fromStartup and childObject.options.isHidden) then
				childObject.frame.text:Hide()
				if (childObject.frame.texture) then
					childObject.frame.texture:Hide()
				end
			end
			
			return true
		end

		function _detalhes.StatusBar:SetLeftPlugin (instance, childObject, fromStartup)
		
			if (not childObject) then
				return
			end
		
			childObject.frame:Show()
			childObject.frame:ClearAllPoints()
			
			if (instance.micro_displays_side == 2) then --> default - bottom
				childObject.frame:SetPoint ("left", instance.baseframe.rodape.StatusBarLeftAnchor,  "left")
			elseif (instance.micro_displays_side == 1) then --> top side
				childObject.frame:SetPoint ("left", instance.baseframe.cabecalho.StatusBarLeftAnchor,  "left")
			end
			
			_detalhes.StatusBar:AlignPluginText (childObject, 1)
			
			instance.StatusBar.left = childObject
			childObject.anchor = "left"
			childObject.enabled = true
			if (childObject.OnEnable) then
				childObject:OnEnable()
			end
			
			if (fromStartup and childObject.options.isHidden) then
				childObject.frame.text:Hide()
				if (childObject.frame.texture) then
					childObject.frame.texture:Hide()
				end
			end
			
			return true
		end

		function _detalhes.StatusBar:SetRightPlugin (instance, childObject, fromStartup)
			childObject.frame:Show()
			childObject.frame:ClearAllPoints()
			
			if (instance.micro_displays_side == 2) then --> default - bottom
				childObject.frame:SetPoint ("right", instance.baseframe.rodape.direita, "right", -20, 10)
			elseif (instance.micro_displays_side == 1) then --> top side
				childObject.frame:SetPoint ("right", instance.baseframe.cabecalho.StatusBarRightAnchor, "right")
			end
			
			_detalhes.StatusBar:AlignPluginText (childObject, 3)
			
			instance.StatusBar.right = childObject
			childObject.anchor = "right"
			childObject.enabled = true
			if (childObject.OnEnable) then
				childObject:OnEnable()
			end
			
			if (fromStartup and childObject.options.isHidden) then
				childObject.frame.text:Hide()
				if (childObject.frame.texture) then
					childObject.frame.texture:Hide()
				end
			end
			
			return true
		end

	--> disable all plugin childs attached to an specified instance and reactive the childs taking the instance statusbar anchors
	function _detalhes.StatusBar:ReloadAnchors (instance)
		for _, child in _ipairs (instance.StatusBar) do
			child.frame:ClearAllPoints()
			child.frame:Hide()
			child.anchor = nil
			child.enabled = false
			if (child.OnDisable) then
				child:OnDisable()
			end
		end
		--> enable only needed plugins
		if (instance.StatusBar.right) then
			_detalhes.StatusBar:SetRightPlugin (instance, instance.StatusBar.right)
		end
		if (instance.StatusBar.center) then
			_detalhes.StatusBar:SetCenterPlugin (instance, instance.StatusBar.center)
		end
		if (instance.StatusBar.left) then
			_detalhes.StatusBar:SetLeftPlugin (instance, instance.StatusBar.left)
		end
		
		if (not instance.show_statusbar and instance.micro_displays_side == 2) then
			_detalhes.StatusBar:Hide (instance)
		end
	end
	

	
	--> select a new plugin in for an instance anchor
	local ChoosePlugin = function (_, _, index, current_child, anchor)
	
		GameCooltip:Close()
		
		local byuser = false
		
		if (type (index) == "table") then
			index, current_child, anchor = unpack (index)
			byuser = true
		end
	
		if (index and index == -1) then --> hide
			_detalhes.StatusBar:ApplyOptions (current_child, "hidden", true)
			return
		else
			_detalhes.StatusBar:ApplyOptions (current_child, "hidden", false)
			current_child.frame.text:Show()
			if (current_child.frame.texture) then
				current_child.frame.texture:Show()
			end
		end
	
		local pluginMestre = _detalhes.StatusBar.Plugins [index]
		if (not pluginMestre) then
			if (anchor == "left") then
				pluginMestre = _detalhes.StatusBar.Plugins [2]
			elseif (anchor == "center") then
				pluginMestre = _detalhes.StatusBar.Plugins [4]
			elseif (anchor == "right") then
				pluginMestre = _detalhes.StatusBar.Plugins [1]
			end
		end
		
		local instance = current_child.instance -- instance que estamos usando agora
		
		local chosenChild = nil
		
		--procura pra ver se ja tem uma criada
		for _, child_created in _ipairs (instance.StatusBar) do 
			if (child_created.mainPlugin == pluginMestre) then
				chosenChild = child_created
				break
			end
		end
		
		--se nao tiver cria uma
		if (not chosenChild) then
			chosenChild = _detalhes.StatusBar:CreateStatusBarChildForInstance (current_child.instance, pluginMestre.real_name)
		end

		instance.StatusBar [anchor] = chosenChild
		--> copia os atributos do current para o chosen
		local options_current = table_deepcopy (current_child.options)
		
		if (chosenChild.anchor) then
			--o widget escolhido ja estava sendo mostrado...
			-- copia os atributos do chosen para o current
			
			current_child.options = table_deepcopy (chosenChild.options)
			instance.StatusBar [chosenChild.anchor] = current_child
		end
		
		chosenChild.options = options_current
		
		_detalhes.StatusBar:ReloadAnchors (instance)

		_detalhes.StatusBar:UpdateOptions (instance)
		
	end

	function _detalhes.StatusBar:SetPlugin (instance, absolute_name, anchor)
		if (absolute_name == -1) then --> none
			anchor = string.lower (anchor)
			ChoosePlugin (nil, nil, -1, instance.StatusBar [anchor], anchor)
		else
			local index = _detalhes.StatusBar:GetIndexFromAbsoluteName (absolute_name)
			if (index and anchor) then
				anchor = string.lower (anchor)
				ChoosePlugin (nil, nil, index, instance.StatusBar [anchor], anchor)
			end
		end
	end
	
	--> on enter
	local onEnterCooltipTexts = { 
			{text = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:14:0:1:512:512:8:70:224:306|t " .. Loc ["STRING_PLUGIN_TOOLTIP_LEFTBUTTON"]},
			{text = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:14:0:1:512:512:8:70:328:409|t " .. Loc ["STRING_PLUGIN_TOOLTIP_RIGHTBUTTON"]}}
			
	local on_enter_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16}
	
	local OnEnter = function (frame)
		
		--|TTexturePath:							size X: size Y: point offset Y X : texture size : coordx1 L : coordx2 R : coordy1 T : coordy2 B |t 
		-- left click: 0.0019531:0.1484375:0.4257813:0.6210938 right click: 0.0019531:0.1484375:0.6269531:0.8222656
		
		local instance = frame.child.instance
		
		_detalhes.OnEnterMainWindow (instance)
		
		frame:SetBackdrop (on_enter_backdrop)
		frame:SetBackdropColor (0.7, 0.7, 0.7, 0.6)

		GameCooltip:Reset()
		GameCooltip:AddFromTable (onEnterCooltipTexts)
		GameCooltip:SetOption ("TextSize", 9)
		GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
		
		GameCooltip:SetOption ("ButtonHeightMod", -4)
		GameCooltip:SetOption ("ButtonsYMod", -4)
		GameCooltip:SetOption ("YSpacingMod", -4)
		GameCooltip:SetOption ("FixedHeight", 46)
		
		GameCooltip:ShowCooltip (frame, "tooltip")

		return true
	end

	--> on leave
	local OnLeave = function (frame)
	
		frame:SetBackdrop (nil)
	
		_detalhes.OnLeaveMainWindow (frame.child.instance)
	
		_detalhes.popup:Hide()

		return true
	end

	local OnMouseUp = function (frame, mouse)

		if (mouse == "LeftButton") then
			if (not frame.child.Setup) then
				print (Loc ["STRING_STATUSBAR_NOOPTIONS"])
				return
			end
			frame.child:Setup()
		else
			GameCooltip:Reset()
			GameCooltip:SetType ("menu")
			
			GameCooltip:AddMenu (1, ChoosePlugin, -1, frame.child, frame.child.anchor, Loc ["STRING_PLUGIN_CLEAN"], [[Interface\Buttons\UI-GroupLoot-Pass-Down]], true)
			
			local current
			
			for index, _name_and_icon in _ipairs (_detalhes.StatusBar.Menu) do 
				GameCooltip:AddMenu (1, ChoosePlugin, {index, frame.child, frame.child.anchor}, nil, nil, _name_and_icon [1], _name_and_icon [2], true)
				
				local pluginMestre = _detalhes.StatusBar.Plugins [index]
				
				if (pluginMestre and pluginMestre.real_name == frame.child.mainPlugin.real_name) then
					current = index+1
				end
			end
			
			if (current) then
				GameCooltip:SetLastSelected (1, current)
			else
				GameCooltip:SetOption ("NoLastSelectedBar", true)
			end

			
			GameCooltip:SetOption ("HeightAnchorMod", -12)
			GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
			GameCooltip:ShowCooltip (frame, "menu")
		end
		return true
	end

	--> reset micro frames
	function _detalhes.StatusBar:Reset (instance)
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textcolor", {1, 0.82, 0, 1})
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textcolor", {1, 0.82, 0, 1})
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textcolor", {1, 0.82, 0, 1})

		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textface", "Friz Quadrata TT")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textface", "Friz Quadrata TT")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textface", "Friz Quadrata TT")

		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textsize", 9)
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textsize", 9)
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textsize", 9)
	end
	
	function _detalhes.StatusBar:GetIndexFromAbsoluteName (AbsName)
		for index, object in ipairs (_detalhes.StatusBar.Plugins) do
			if (object.real_name == AbsName) then
				return index
			end
		end
	end
	
	function _detalhes.StatusBar:UpdateOptions (instance)
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "hidden")
		
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "hidden")
		
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "hidden")
	end
	
	function _detalhes.StatusBar:UpdateChilds (instance)
	
		local left = instance.StatusBarSaved.left
		local center = instance.StatusBarSaved.center
		local right = instance.StatusBarSaved.right

		local left_index = _detalhes.StatusBar:GetIndexFromAbsoluteName (left)
		ChoosePlugin (nil, nil, left_index, instance.StatusBar.left, "left")
		
		local center_index = _detalhes.StatusBar:GetIndexFromAbsoluteName (center)
		ChoosePlugin (nil, nil, center_index, instance.StatusBar.center, "center")
		
		local right_index = _detalhes.StatusBar:GetIndexFromAbsoluteName (right)
		ChoosePlugin (nil, nil, right_index, instance.StatusBar.right, "right")
		
		if (instance.StatusBarSaved.options and instance.StatusBarSaved.options [left]) then
			instance.StatusBar.left.options = table_deepcopy (instance.StatusBarSaved.options [left])
		end
		if (instance.StatusBarSaved.options and instance.StatusBarSaved.options [center]) then
			instance.StatusBar.center.options = table_deepcopy (instance.StatusBarSaved.options [center])
		end
		if (instance.StatusBarSaved.options and instance.StatusBarSaved.options [right]) then
			instance.StatusBar.right.options = table_deepcopy (instance.StatusBarSaved.options [right])
		end
		
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.left, "hidden")
		
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.center, "hidden")
		
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textcolor")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textsize")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textface")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textxmod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "textymod")
		_detalhes.StatusBar:ApplyOptions (instance.StatusBar.right, "hidden")

	end
	
	--> build-in function for create a frame for an plugin child
	function _detalhes.StatusBar:CreateChildFrame (instance, name, w, h)
		--local frame = _detalhes.gump:NewPanel (instance.baseframe.cabecalho.fechar, nil, name..instance:GetInstanceId(), nil, w or DEFAULT_CHILD_WIDTH, h or DEFAULT_CHILD_HEIGHT, false)
		local frame = _detalhes.gump:NewPanel (instance.baseframe, nil, name..instance:GetInstanceId(), nil, w or DEFAULT_CHILD_WIDTH, h or DEFAULT_CHILD_HEIGHT, false)
		frame:SetFrameLevel (instance.baseframe:GetFrameLevel()+4)

		--create widgets
		local text = _detalhes.gump:NewLabel (frame, nil, "$parentText", "text", "0")
		text:SetPoint ("right", frame, "right", 0, 0)
		text:SetJustifyH ("right")
		_detalhes:SetFontSize (text, 9.8)
		
		frame:SetHook ("OnEnter", OnEnter)
		frame:SetHook ("OnLeave", OnLeave)
		frame:SetHook ("OnMouseUp", OnMouseUp)
		return frame
	end

	--> built-in function for create an table for the plugin child
	function _detalhes.StatusBar:CreateChildTable (instance, mainObject, frame)
	
		local _table = {}
		
		--> treat as a class
		setmetatable (_table, mainObject)
		
		--> default members
		_table.instance = instance
		_table.frame = frame
		_table.text = frame.text
		_table.mainPlugin = mainObject
		
		--> options table
		_table.options = instance.StatusBar.options [mainObject.real_name]
		if (not _table.options) then
			_table.options = {
			textStyle = 2,
			textColor = {unpack (DEFAULT_CHILD_FONTCOLOR)},
			textSize = DEFAULT_CHILD_FONTSIZE,
			textAlign = 0,
			textXMod = 0,
			textYMod = 0,
			textFace = DEFAULT_CHILD_FONTFACE}
			instance.StatusBar.options [mainObject.real_name] = _table.options
		end
		
		_detalhes.StatusBar:ApplyOptions (_table, "textcolor")
		_detalhes.StatusBar:ApplyOptions (_table, "textsize")
		_detalhes.StatusBar:ApplyOptions (_table, "textface")
		
		_detalhes.StatusBar:ReloadAnchors (instance)
		
		--> table reference on frame widget
		frame.frame.child = _table
		
		--> adds this new child to parent child container
		mainObject.childs [#mainObject.childs+1] = _table
		
		return _table
	end

	function _detalhes.StatusBar:ApplyOptions (child, option, value)

		option = string.lower (option)
		
		if (option == "textxmod") then
		
			if (value == nil) then
				value = child.options.textXMod
			end

			child.options.textXMod = value
			_detalhes.StatusBar:ReloadAnchors (child.instance)
			
		elseif (option == "textymod") then
		
			if (value == nil) then
				value = child.options.textYMod
			end

			child.options.textYMod = value
			_detalhes.StatusBar:ReloadAnchors (child.instance)
			
		elseif (option == "textcolor") then
		
			if (value == nil) then
				value = child.options.textColor
			end
		
			child.options.textColor = value
			local r, g, b, a = _detalhes.gump:ParseColors (child.options.textColor)
			child.text:SetTextColor (r, g, b, a)
			
		elseif (option == "textsize") then
		
			if (value == nil) then
				value = child.options.textSize
			end
		
			child.options.textSize = value
			child:SetFontSize (child.text, child.options.textSize)
			
		elseif (option == "textface") then
		
			if (value == nil) then
				value = child.options.textFace
			end
		
			child.options.textFace = value
			child:SetFontFace (child.text, SharedMedia:Fetch ("font", child.options.textFace))
			
		elseif (option == "hidden") then
		
			if (value == nil) then
				value = child.options.isHidden
			end
		
			child.options.isHidden = value
			
			if (value) then
				child.frame.text:Hide()
				if (child.frame.texture) then
					child.frame.texture:Hide()
				end
			else
				child.frame.text:Show()
				if (child.frame.texture) then
					child.frame.texture:Show()
				end
			end
		else
			if (child [option] and type (child [option]) == "function") then
				child [option] (nil, child, value)
			end
		end
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> BUILT-IN DPS PLUGIN
do

		--> Create the plugin Object [1] = frame name on _G [2] options [3] plugin type
		local PDps = _detalhes:NewPluginObject ("Details_StatusBarDps", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")

		--[[ Note: Declare all functions using : not . if you use . make sure to ignore first parameter and move all parameters 1 position to right ]]
		
		-- handle event "COMBAT_PLAYER_ENTER"
		function PDps:PlayerEnterCombat()
			for index, child in _ipairs (PDps.childs) do
				if (child.enabled and child.instance:GetSegment() == 0) then
					child.tick = _detalhes:ScheduleRepeatingTimer ("PluginDpsUpdate", 1, child)
				end
			end
		end
		
		-- handle event "COMBAT_PLAYER_LEAVE"
		function PDps:PlayerLeaveCombat()
			for index, child in _ipairs (PDps.childs) do
				if (child.tick) then
					_detalhes:CancelTimer (child.tick)
					child.tick = nil
				end
			end
		end

		-- handle event "DETAILS_INSTANCE_CHANGESEGMENT" 
		function PDps:ChangeSegment (instance, segment)
			for index, child in _ipairs (PDps.childs) do 
				if (child.enabled and child.instance == instance) then
					_detalhes:PluginDpsUpdate (child)
				end
			end
		end
		
		--handle event "DETAILS_DATA_RESET"
		function PDps:DataReset()
			for index, child in _ipairs (PDps.childs) do 
				if (child.enabled) then
					child.text:SetText ("0")
				end
			end
		end

		function PDps:Refresh (child)
			_detalhes:PluginDpsUpdate (child)
		end
		
		--still a little buggy, working on
		function _detalhes:PluginDpsUpdate (child)
		
			--> showing is the combat table which is current shown on instance
			if (child.instance.showing) then
			
				--GetCombatTime() return the time length of combat
				local combatTime = child.instance.showing:GetCombatTime()
				if (combatTime < 1) then
					return child.text:SetText ("0")
				end
				
				--GetTotal (attribute, sub attribute, onlyGroup) return the total of requested attribute
				local total = child.instance.showing:GetTotal (child.instance.atributo, child.instance.sub_atributo, true)
				
				local dps = _math_floor (total / combatTime)
				
				local textStyle = child.options.textStyle
				if (textStyle == 1) then
					child.text:SetText (_detalhes:ToK (dps))
				elseif (textStyle == 2) then
					child.text:SetText (_detalhes:comma_value (dps))
				else
					child.text:SetText (dps)
				end
			end
		end
		
		--> Create Plugin Frames
		function PDps:CreateChildObject (instance)
			--> create main frame and widgets
			--> a statusbar frame is made of a panel with a member called 'text' which is a label
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsStatusBarDps", DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PDps, myframe)
			
			return new_child
		end
		
		--> Handle events (must have, we'll use direct call to functions)
		function PDps:OnDetailsEvent (event)
			return
		end

		--> Install
		-- _detalhes:InstallPlugin ( Plugin Type | Plugin Display Name | Plugin Icon | Plugin Object | Plugin Real Name )
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_PDPSNAME"], "Interface\\Icons\\Achievement_brewery_3", PDps, "DETAILS_STATUSBAR_PLUGIN_PDPS")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
		--> Register needed events
		-- here we are redirecting the event to an specified function, otherwise events need to be handle inside "PDps:OnDetailsEvent (event)"
		_detalhes:RegisterEvent (PDps, "DETAILS_INSTANCE_CHANGESEGMENT", PDps.ChangeSegment)
		_detalhes:RegisterEvent (PDps, "DETAILS_DATA_RESET", PDps.DataReset)
		_detalhes:RegisterEvent (PDps, "COMBAT_PLAYER_ENTER", PDps.PlayerEnterCombat)
		_detalhes:RegisterEvent (PDps, "COMBAT_PLAYER_LEAVE", PDps.PlayerLeaveCombat)

end

---------> BUILT-IN SEGMENT PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PSegment = _detalhes:NewPluginObject ("Details_Segmenter", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PSegment:OnDetailsEvent (event)
			return
		end
		
		--> initialize and reset 'can_schedule' variable
		function PSegment:NewCombat()
			PSegment.can_schedule = 1
			PSegment:Change()
		end
		function PSegment:OnSegmentChange()
			PSegment.can_schedule = 1
			PSegment:Change()
		end

		--> on 'can_schedule' timeout, re-run the Change() function
		function PSegment:SchduleGetName()
			PSegment:Change()
		end
		
		function PSegment:Change()
		
			for index, child in _ipairs (PSegment.childs) do
			
				if (child.enabled and child.instance:IsEnabled()) then
					
					child.options.segmentType = child.options.segmentType or 2

					if (not child.instance.showing) then
						return child.text:SetText (Loc ["STRING_EMPTY_SEGMENT"])
					end
				
					if (child.instance.segmento == -1) then --> overall
						child.text:SetText (Loc ["STRING_OVERALL"])
						
					elseif (child.instance.segmento == 0) then --> combate atual

						if (child.options.segmentType == 1) then
							child.text:SetText (Loc ["STRING_CURRENT"])
						else
							local name = _detalhes.tabela_vigente:GetCombatName (true)

							if (name and name ~= Loc ["STRING_UNKNOW"]) then
								if (child.options.segmentType == 2) then
									child.text:SetText (name)
								elseif (child.options.segmentType == 3) then
									child.text:SetText (name)
								end
							else
								child.text:SetText (Loc ["STRING_CURRENT"])
								if (_detalhes.in_combat and PSegment.can_schedule <= 2) then
									PSegment:ScheduleTimer ("SchduleGetName", 2)
									PSegment.can_schedule = PSegment.can_schedule + 1
									return
								end
							end
						end
						
					else --> alguma tabela do hist�rico
					
						if (child.options.segmentType == 1) then
							child.text:SetText (Loc ["STRING_FIGHTNUMBER"] .. child.instance.segmento)
							
						else
							local name = child.instance.showing:GetCombatName (true)
							if (name ~= Loc ["STRING_UNKNOW"]) then
								if (child.options.segmentType == 2) then
									child.text:SetText (name)
								elseif (child.options.segmentType == 3) then
									child.text:SetText (name .. " #" .. child.instance.segmento)
								end
							else
								if (child.options.segmentType == 2) then
									child.text:SetText (Loc ["STRING_UNKNOW"])
								elseif (child.options.segmentType == 3) then
									child.text:SetText (Loc ["STRING_UNKNOW"] .. " #" .. child.instance.segmento)
								end
							end
						end
					end
				end
			end
		end
		
		function PSegment:ExtraOptions()
			
			--> all widgets need to be placed on a table
			local widgets = {}
			--> reference of extra window for custom options
			local window = _G.DetailsStatusBarOptions2.MyObject
			
			--> build all your widgets -----------------------------------------------------------------------------------------------------------------------------
				_detalhes.gump:NewLabel (window, nil, "$parentSegmentOptionLabel", "segmentOptionLabel", Loc ["STRING_PLUGIN_SEGMENTTYPE"])
				window.segmentOptionLabel:SetPoint (10, -15)
				
				local onSelectSegmentType = function (_, child, thistype)
					child.options.segmentType = thistype
					PSegment:Change()
				end
				
				local segmentTypes = {
					{value = 1, label = Loc ["STRING_PLUGIN_SEGMENTTYPE_1"], onclick = onSelectSegmentType, icon = [[Interface\ICONS\Ability_Rogue_KidneyShot]]},
					{value = 2, label = Loc ["STRING_PLUGIN_SEGMENTTYPE_2"], onclick = onSelectSegmentType, icon = [[Interface\ICONS\Achievement_Boss_Ra_Den]]},
					{value = 3, label = Loc ["STRING_PLUGIN_SEGMENTTYPE_3"], onclick = onSelectSegmentType, icon = [[Interface\ICONS\Achievement_Boss_Durumu]]},
				}
				
				_detalhes.gump:NewDropDown (window, nil, "$parentSegmentTypeDropdown", "segmentTypeDropdown", 200, 20, function() return segmentTypes end, 1) -- func, default
				window.segmentTypeDropdown:SetPoint ("left", window.segmentOptionLabel, "right", 2)
			-----------------------------------------------------------------------------------------------------------------------------
			
			--> now we insert all widgets created on widgets table
			table.insert (widgets, window.segmentOptionLabel)
			table.insert (widgets, window.segmentTypeDropdown)

			--> after first call we replace this function with widgets table
			PSegment.ExtraOptions = widgets
		end
		
		--> ExtraOptionsOnOpen is called when options are opened and plugin have custom options
		--> here we setup options widgets for get the values of clicked child and also for tell options window what child we are configuring
		function PSegment:ExtraOptionsOnOpen (child)
			_G.DetailsStatusBarOptions2SegmentTypeDropdown.MyObject:SetFixedParameter (child)
			_G.DetailsStatusBarOptions2SegmentTypeDropdown.MyObject:Select (child.options.segmentType, true)
		end
		
		--> Create Plugin Frames (must have)
		function PSegment:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPSegmentInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PSegment, myframe)
			new_child.options.segmentType = new_child.options.segmentType or 2
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_PSEGMENTNAME"], "Interface\\Icons\\inv_misc_enchantedscroll", PSegment, "DETAILS_STATUSBAR_PLUGIN_PSEGMENT")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
		--> Register needed events
		_detalhes:RegisterEvent (PSegment, "DETAILS_INSTANCE_CHANGESEGMENT", PSegment.OnSegmentChange)
		_detalhes:RegisterEvent (PSegment, "DETAILS_DATA_RESET", PSegment.Change)
		_detalhes:RegisterEvent (PSegment, "COMBAT_PLAYER_ENTER", PSegment.NewCombat)
		
end

---------> BUILT-IN ATTRIBUTE PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PAttribute = _detalhes:NewPluginObject ("Details_Attribute", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PAttribute:OnDetailsEvent (event)
			return
		end

		function PAttribute:Change (instance, attribute, subAttribute)
			if (not instance) then
				instance, attribute, subAttribute = self.instance, self.instance.atributo, self.instance.sub_atributo
			end
			
			for index, child in _ipairs (PAttribute.childs) do
				if (child.instance == instance and child.enabled and child.instance:IsEnabled()) then
					local sName = child.instance:GetInstanceAttributeText()
					child.text:SetText (sName)
				end
			end
		end
		
		function PAttribute:OnEnable()
			self:Change()
		end
		
		--> Create Plugin Frames (must have)
		function PAttribute:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPAttributeInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PAttribute, myframe)
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_PATTRIBUTENAME"], "Interface\\Icons\\inv_misc_emberclothbolt", PAttribute, "DETAILS_STATUSBAR_PLUGIN_PATTRIBUTE")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
		--> Register needed events
		_detalhes:RegisterEvent (PAttribute, "DETAILS_INSTANCE_CHANGEATTRIBUTE", PAttribute.Change)
		
end

---------> BUILT-IN CLOCK PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do

		--> Create the plugin Object
		local Clock = _detalhes:NewPluginObject ("Details_Clock", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events --must have this function
		function Clock:OnDetailsEvent (event)
			return
		end

		--enter combat
		function Clock:PlayerEnterCombat()
			Clock.tick = _detalhes:ScheduleRepeatingTimer ("ClockPluginTick", 1) 
		end
		--leave combat
		function Clock:PlayerLeaveCombat()
			_detalhes:CancelTimer (Clock.tick)
		end
		
		function _detalhes:ClockPluginTickOnSegment()
			_detalhes:ClockPluginTick (true)
		end
		
		--1 sec tick
		function _detalhes:ClockPluginTick (force)

			for index, child in _ipairs (Clock.childs) do
				local instance = child.instance
				if (child.enabled and instance:IsEnabled()) then
					if (instance.showing and ( (instance.segmento ~= -1) or (instance.segmento == -1 and not _detalhes.in_combat) or force) ) then
						
						local timeType = child.options.timeType
						if (timeType == 1) then
							local combatTime = instance.showing:GetCombatTime()
							local minutos, segundos = _math_floor (combatTime/60), _math_floor (combatTime%60)
							child.text:SetText (minutos .. "m " .. segundos .. "s")
							
						elseif (timeType == 2) then
							local combatTime = instance.showing:GetCombatTime()
							child.text:SetText (combatTime .. "s")
							
						elseif (timeType == 3) then
						
							local getSegment = instance.segmento
							
							if (getSegment < 1) then
								getSegment = 1
							elseif (getSegment > _detalhes.segments_amount) then
								getSegment = _detalhes.segments_amount
							else
								getSegment = getSegment+1
							end
							
							local lastFight = _detalhes:GetCombat (getSegment)
							local currentCombatTime = instance.showing:GetCombatTime()
							
							if (lastFight) then
								child.text:SetText (currentCombatTime - lastFight:GetCombatTime() .. "s")
							else
								child.text:SetText (currentCombatTime .. "s")
							end
						end

					end
				end
			end
		end
		
		--on reset
		function Clock:DataReset()
			for index, child in _ipairs (Clock.childs) do
				if (child.enabled and child.instance:IsEnabled()) then
					child.text:SetText ("0m 0s")
				end
			end
		end
		
		--> this is a fixed member, put all your widgets for custom options inside this function
		--> if ExtraOptions isn't preset, secondary options box will be hided and only default options will be show
		function Clock:ExtraOptions()
			
			--> all widgets need to be placed on a table
			local widgets = {}
			--> reference of extra window for custom options
			local window = _G.DetailsStatusBarOptions2.MyObject
			
			--> build all your widgets -----------------------------------------------------------------------------------------------------------------------------
				_detalhes.gump:NewLabel (window, nil, "$parentClockTypeLabel", "ClockTypeLabel", Loc ["STRING_PLUGIN_CLOCKTYPE"])
				window.ClockTypeLabel:SetPoint (10, -15)
				
				local onSelectClockType = function (_, child, thistype)
					child.options.timeType = thistype
					_detalhes:ClockPluginTick()
				end
				
				local clockTypes = {{value = 1, label = Loc ["STRING_PLUGIN_MINSEC"], onclick = onSelectClockType},
				{value = 2, label = Loc ["STRING_PLUGIN_SECONLY"], onclick = onSelectClockType},
				{value = 3, label = Loc ["STRING_PLUGIN_TIMEDIFF"], onclick = onSelectClockType}}
				
				_detalhes.gump:NewDropDown (window, nil, "$parentClockTypeDropdown", "ClockTypeDropdown", 200, 20, function() return clockTypes end, 1) -- func, default
				window.ClockTypeDropdown:SetPoint ("left", window.ClockTypeLabel, "right", 2)
			-----------------------------------------------------------------------------------------------------------------------------
			
			--> now we insert all widgets created on widgets table
			table.insert (widgets, window.ClockTypeLabel)
			table.insert (widgets, window.ClockTypeDropdown)

			--> after first call we replace this function with widgets table
			Clock.ExtraOptions = widgets
		end
		
		--> ExtraOptionsOnOpen is called when options are opened and plugin have custom options
		--> here we setup options widgets for get the values of clicked child and also for tell options window what child we are configuring
		function Clock:ExtraOptionsOnOpen (child)
			_G.DetailsStatusBarOptions2ClockTypeDropdown.MyObject:SetFixedParameter (child)
			_G.DetailsStatusBarOptions2ClockTypeDropdown.MyObject:Select (child.options.timeType, true)
		end
		
		--> Create Plugin Frames
		function Clock:CreateChildObject (instance)

			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsClockInstance"..instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			
			--> we place custom frame, widgets inside this function
			--local texture = myframe:CreateTexture (nil, "overlay")
			--texture:SetTexture ("Interface\\AddOns\\Details\\images\\clock")
			--texture:SetPoint ("right", myframe.text.widget, "left")
			--myframe.texture = texture

			local new_child = _detalhes.StatusBar:CreateChildTable (instance, Clock, myframe)
			
			--> default text
			new_child.text:SetText ("0m 0s")

			--> some changes from default options
			if (new_child.options.textXMod == 0) then
				new_child.options.textXMod = 6
			end
			
			--> here we are adding a new option member
			new_child.options.timeType = new_child.options.timeType or 1
			
			return new_child
		end

		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_CLOCKNAME"], "Interface\\Icons\\Achievement_BG_grab_cap_flagunderXseconds", Clock, "DETAILS_STATUSBAR_PLUGIN_CLOCK")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
		--> Register needed events
		_detalhes:RegisterEvent (Clock, "COMBAT_PLAYER_ENTER", Clock.PlayerEnterCombat)
		_detalhes:RegisterEvent (Clock, "COMBAT_PLAYER_LEAVE", Clock.PlayerLeaveCombat)
		_detalhes:RegisterEvent (Clock, "DETAILS_INSTANCE_CHANGESEGMENT", _detalhes.ClockPluginTickOnSegment)
		_detalhes:RegisterEvent (Clock, "DETAILS_DATA_SEGMENTREMOVED", _detalhes.ClockPluginTick)
		_detalhes:RegisterEvent (Clock, "DETAILS_DATA_RESET", Clock.DataReset)

end

---------> BUILT-IN THREAT PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do

		local _UnitDetailedThreatSituation = UnitDetailedThreatSituation --> wow api
		local _cstr = string.format --> lua api
		local _math_abs = math.abs --> lua api
		
		--> Create the plugin Object
		local Threat = _detalhes:NewPluginObject ("Details_TargetThreat", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events
		function Threat:OnDetailsEvent (event)
			return
		end

		Threat.isTank = nil

		function Threat:PlayerEnterCombat()
			local role = UnitGroupRolesAssigned ("player")
			if (role == "TANK") then
				Threat.isTank = true
			else
				Threat.isTank = nil
			end
			Threat.tick = _detalhes:ScheduleRepeatingTimer ("ThreatPluginTick", 1) 
		end
		
		function Threat:PlayerLeaveCombat()
			_detalhes:CancelTimer (Threat.tick)
		end
		
		function _detalhes:ThreatPluginTick()
			for index, child in _ipairs (Threat.childs) do
				local instance = child.instance
				if (child.enabled and instance:IsEnabled()) then
					-- atualiza a threat
					local isTanking, status, threatpct, rawthreatpct, threatvalue = _UnitDetailedThreatSituation ("player", "target")
					if (threatpct) then
						child.text:SetText (_math_floor (threatpct).."%")
						if (Threat.isTank) then
							child.text:SetTextColor (_math_abs (threatpct-100)*0.01, threatpct*0.01, 0, 1)
						else
							child.text:SetTextColor (threatpct*0.01, _math_abs (threatpct-100)*0.01, 0, 1)
						end
					else
						child.text:SetText ("0%")
						child.text:SetTextColor (1, 1, 1, 1)
					end
				end
			end
		end
		
		--> Create Plugin Frames
		function Threat:CreateChildObject (instance)

			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsThreatInstance"..instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, Threat, myframe)

			myframe.widget:RegisterEvent ("PLAYER_TARGET_CHANGED")
			myframe.widget:SetScript ("OnEvent", function()
				_detalhes:ThreatPluginTick()
			end)
			
			return new_child
		end

		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_THREATNAME"], "Interface\\Icons\\Ability_Hunter_ResistanceIsFutile", Threat, "DETAILS_STATUSBAR_PLUGIN_THREAT")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
		--> Register needed events
		_detalhes:RegisterEvent (Threat, "COMBAT_PLAYER_ENTER", Threat.PlayerEnterCombat)
		_detalhes:RegisterEvent (Threat, "COMBAT_PLAYER_LEAVE", Threat.PlayerLeaveCombat)


end

---------> BUILT-IN PFS PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PFps = _detalhes:NewPluginObject ("Details_Statusbar_Fps", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PFps:OnDetailsEvent (event)
			return
		end
		
		function PFps:UpdateFps()
			self.text:SetText (_math_floor (GetFramerate()) .. " fps")
		end
		
		function PFps:OnDisable()
			self:CancelTimer (self.srt, true)
		end

		function PFps:OnEnable()
			self.srt = self:ScheduleRepeatingTimer ("UpdateFps", 1, self)
			self:UpdateFps()
		end
		
		function PFps:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPFpsInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PFps, myframe)
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_FPS"], "Interface\\Icons\\Spell_Shadow_MindTwisting", PFps, "DETAILS_STATUSBAR_PLUGIN_PFPS")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end		

end

---------> BUILT-IN LATENCY PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PLatency = _detalhes:NewPluginObject ("Details_Statusbar_Latency", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PLatency:OnDetailsEvent (event)
			return
		end
		
		function PLatency:UpdateLatency()
			local _, _, _, lagWorld = GetNetStats()
			self.text:SetText (_math_floor (lagWorld) .. " ms")
		end
		
		function PLatency:OnDisable()
			self:CancelTimer (self.srt, true)
		end

		function PLatency:OnEnable()
			self.srt = self:ScheduleRepeatingTimer ("UpdateLatency", 30, self)
			self:UpdateLatency()
		end
		
		function PLatency:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPLatencyInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PLatency, myframe)
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_LATENCY"], "Interface\\FriendsFrame\\PlusManz-BattleNet", PLatency, "DETAILS_STATUSBAR_PLUGIN_PLATENCY")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end		

end

---------> BUILT-IN DURABILITY PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do

		local _GetInventoryItemDurability = GetInventoryItemDurability

		--> Create the plugin Object
		local PDurability = _detalhes:NewPluginObject ("Details_Statusbar_Latency", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PDurability:OnDetailsEvent (event)
			return
		end
		
		function PDurability:UpdateDurability()
			local percent, items = 0, 0
			for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
				local durability, maxdurability = _GetInventoryItemDurability (i)
				if (durability and maxdurability) then
					local p = durability / maxdurability * 100
					percent = percent + p
					items = items + 1
				end
			end
			
			if (items == 0) then
				self.text:SetText (Loc ["STRING_UPTADING"])
				return self:ScheduleTimer ("UpdateDurability", 5, self)
			end
			
			percent = percent / items
			self.text:SetText (_math_floor (percent) .. "%")
		end
		
		function PDurability:OnDisable()
			self.frame.widget:UnregisterEvent ("PLAYER_DEAD")
			self.frame.widget:UnregisterEvent ("PLAYER_UNGHOST")
			self.frame.widget:UnregisterEvent ("UPDATE_INVENTORY_DURABILITY")
			self.frame.widget:UnregisterEvent ("MERCHANT_SHOW")
			self.frame.widget:UnregisterEvent ("MERCHANT_CLOSED")
			self.frame.widget:UnregisterEvent ("ZONE_CHANGED_NEW_AREA")
		end

		function PDurability:OnEnable()
			self.frame.widget:RegisterEvent ("PLAYER_DEAD")
			self.frame.widget:RegisterEvent ("PLAYER_UNGHOST")
			self.frame.widget:RegisterEvent ("UPDATE_INVENTORY_DURABILITY")
			self.frame.widget:RegisterEvent ("MERCHANT_SHOW")
			self.frame.widget:RegisterEvent ("MERCHANT_CLOSED")
			self.frame.widget:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
			self:UpdateDurability()
		end
		
		function PDurability:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPDurabilityInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PDurability, myframe)
			
			local texture = myframe:CreateTexture (nil, "overlay")
			texture:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
			texture:SetPoint ("right", myframe.text.widget, "left", -2, -1)
			texture:SetWidth (10)
			texture:SetHeight (10)
			texture:SetTexCoord (0.216796875, 0.26171875, 0.0078125, 0.052734375)
			myframe.texture = texture
			
			myframe.widget:SetScript ("OnEvent", function()
				new_child:UpdateDurability()
			end)
			
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_DURABILITY"], "Interface\\ICONS\\INV_Chest_Chain_10", PDurability, "DETAILS_STATUSBAR_PLUGIN_PDURABILITY")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end		

end


---------> BUILT-IN GOLD PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PGold = _detalhes:NewPluginObject ("Details_Statusbar_Gold", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PGold:OnDetailsEvent (event)
			return
		end
		
		function PGold:GoldPluginTick()
			for index, child in _ipairs (PGold.childs) do
				local instance = child.instance
				if (child.enabled and instance:IsEnabled()) then
					child:UpdateGold()
				end
			end
		end
		
		function PGold:UpdateGold()
			self.text:SetText (_math_floor (GetMoney() / 100 / 100))
		end

		function PGold:OnEnable()
			self:UpdateGold()
		end
		
		function PGold:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPGoldInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PGold, myframe)
			
			local texture = myframe:CreateTexture (nil, "overlay")
			texture:SetTexture ("Interface\\MONEYFRAME\\UI-GoldIcon")
			texture:SetPoint ("right", myframe.text.widget, "left")
			texture:SetWidth (12)
			texture:SetHeight (12)
			myframe.texture = texture
			
			myframe.widget:RegisterEvent ("PLAYER_MONEY")
			myframe.widget:RegisterEvent ("PLAYER_ENTERING_WORLD")
			myframe.widget:SetScript ("OnEvent", function (event)
				if (event == "PLAYER_ENTERING_WORLD") then
					return PGold:ScheduleTimer ("GoldPluginTick", 10)
				end
				PGold:GoldPluginTick()
			end)
			
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_GOLD"], "Interface\\Icons\\INV_Ore_Gold_01", PGold, "DETAILS_STATUSBAR_PLUGIN_PGold")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end		

end

---------> BUILT-IN TIME PLUGIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

do
		--> Create the plugin Object
		local PTime = _detalhes:NewPluginObject ("Details_Statusbar_Time", DETAILSPLUGIN_ALWAYSENABLED, "STATUSBAR")
		--> Handle events (must have)
		function PTime:OnDetailsEvent (event)
			return
		end
		
		function PTime:UpdateClock()
			
			if (self.options.timeType == 1) then
				self.text:SetText (date ("%I:%M %p"))
			elseif (self.options.timeType == 2) then
				self.text:SetText (date ("%H:%M"))
			end
			
		end
		
		function PTime:OnDisable()
			self:CancelTimer (self.srt, true)
		end

		function PTime:OnEnable()
			self.srt = self:ScheduleRepeatingTimer ("UpdateClock", 60, self)
			self:UpdateClock()
		end
		
		function PTime:ExtraOptions()
			
			--> all widgets need to be placed on a table
			local widgets = {}
			--> reference of extra window for custom options
			local window = _G.DetailsStatusBarOptions2.MyObject
			
			--> build all your widgets -----------------------------------------------------------------------------------------------------------------------------
				_detalhes.gump:NewLabel (window, _, "$parentTimeTypeLabel", "TimeTypeLabel", Loc ["STRING_PLUGIN_CLOCKTYPE"])
				window.TimeTypeLabel:SetPoint (10, -15)
				
				local onSelectClockType = function (_, child, thistype)
					child.options.timeType = thistype
					child:UpdateClock()
				end
				
				local clockTypes = {{value = 1, label = date ("%I:%M %p"), onclick = onSelectClockType},
				{value = 2, label = date ("%H:%M"), onclick = onSelectClockType}
				}
				
				_detalhes.gump:NewDropDown (window, _, "$parentTimeTypeDropdown", "TimeTypeDropdown", 200, 20, function() return clockTypes end, 1) -- func, default
				window.TimeTypeDropdown:SetPoint ("left", window.TimeTypeLabel, "right", 2)
			-----------------------------------------------------------------------------------------------------------------------------
			
			--> now we insert all widgets created on widgets table
			table.insert (widgets, window.TimeTypeLabel)
			table.insert (widgets, window.TimeTypeDropdown)

			--> after first call we replace this function with widgets table
			PTime.ExtraOptions = widgets
		end
		
		--> ExtraOptionsOnOpen is called when options are opened and plugin have custom options
		--> here we setup options widgets for get the values of clicked child and also for tell options window what child we are configuring
		function PTime:ExtraOptionsOnOpen (child)
			_G.DetailsStatusBarOptions2TimeTypeDropdown.MyObject:SetFixedParameter (child)
			_G.DetailsStatusBarOptions2TimeTypeDropdown.MyObject:Select (child.options.timeType, true)
		end
		
		--> Create Plugin Frames (must have)
		function PTime:CreateChildObject (instance)
			local myframe = _detalhes.StatusBar:CreateChildFrame (instance, "DetailsPTimeInstance" .. instance:GetInstanceId(), DEFAULT_CHILD_WIDTH, DEFAULT_CHILD_HEIGHT)
			local new_child = _detalhes.StatusBar:CreateChildTable (instance, PTime, myframe)
			new_child.options.timeType = new_child.options.timeType or 1
			return new_child
		end
		
		--> Install
		local install = _detalhes:InstallPlugin ("STATUSBAR", Loc ["STRING_PLUGIN_TIME"], "Interface\\Icons\\Spell_Shadow_LastingAfflictions", PTime, "DETAILS_STATUSBAR_PLUGIN_PTIME")
		if (type (install) == "table" and install.error) then
			print (install.errortext)
			return
		end
		
end

---------> default options panel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local window = _detalhes.gump:NewPanel (UIParent, nil, "DetailsStatusBarOptions", nil, 300, 180)
tinsert (UISpecialFrames, "DetailsStatusBarOptions")
window:SetPoint ("center", UIParent, "center")
window.locked = false
window.close_with_right = true
window.child = nil
window.instance = nil
window:SetFrameStrata ("FULLSCREEN")

window:SetBackdrop ({bgFile =  [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize=12})
window:SetBackdropColor (0, 0, 0, 0.9)

local extraWindow = _detalhes.gump:NewPanel (window, nil, "DetailsStatusBarOptions2", "extra", 300, 180)
extraWindow:SetPoint ("left", window, "right")
extraWindow.close_with_right = true
extraWindow.locked = false
extraWindow:Hide()

extraWindow:SetHook ("OnHide", function()
	window:Hide()
end)

extraWindow:SetBackdrop ({bgFile =  [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, edgeFile = [[Interface\AddOns\Details\images\border_2]], edgeSize=12})
extraWindow:SetBackdropColor (0, 0, 0, 0.9)

--> text style
	_detalhes.gump:NewLabel (window, _, "$parentTextStyleLabel", "textstyle", Loc ["STRING_PLUGINOPTIONS_TEXTSTYLE"])
	window.textstyle:SetPoint (10, -15)
	
	local onSelectTextStyle = function (_, child, style)
	
		window.instance.StatusBar.left.options.textStyle = style
		window.instance.StatusBar.center.options.textStyle = style
		window.instance.StatusBar.right.options.textStyle = style
		
		if (window.instance.StatusBar.left.Refresh and type (window.instance.StatusBar.left.Refresh) == "function") then
			window.instance.StatusBar.left:Refresh (window.instance.StatusBar.left)
		end
		if (window.instance.StatusBar.center.Refresh and type (window.instance.StatusBar.center.Refresh) == "function") then
			window.instance.StatusBar.center:Refresh (window.instance.StatusBar.center)
		end
		if (window.instance.StatusBar.right.Refresh and type (window.instance.StatusBar.right.Refresh) == "function") then
			window.instance.StatusBar.right:Refresh (window.instance.StatusBar.right)
		end
		
	end
	local textStyle = {{value = 1, label = Loc ["STRING_PLUGINOPTIONS_ABBREVIATE"] .. " (105.5K)", onclick = onSelectTextStyle},
	{value = 2, label = Loc ["STRING_PLUGINOPTIONS_COMMA"] .. " (105.500)", onclick = onSelectTextStyle},
	{value = 3, label = Loc ["STRING_PLUGINOPTIONS_NOFORMAT"] .. " (105500)", onclick = onSelectTextStyle}}
	
	_detalhes.gump:NewDropDown (window, _, "$parentTextStyleDropdown", "textstyleDropdown", 200, 20, function() return textStyle end, 1) -- func, default
	window.textstyleDropdown:SetPoint ("left", window.textstyle, "right", 2)

--> text color
	_detalhes.gump:NewLabel (window, _, "$parentTextColorLabel", "textcolor", Loc ["STRING_PLUGINOPTIONS_TEXTCOLOR"])
	window.textcolor:SetPoint (10, -35)
	local selectedColor = function()
		local r, g, b, a = ColorPickerFrame:GetColorRGB()
		window.textcolortexture:SetTexture (r, g, b, a)
		--_detalhes.StatusBar:ApplyOptions (window.child, "textcolor", {r, g, b, a})
		
		local color = {r, g, b, a}
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.left, "textcolor", color)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.center, "textcolor", color)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.right, "textcolor", color)
	end
	local canceledColor = function()
		local r, g, b, a = unpack (ColorPickerFrame.previousValues)
		window.textcolortexture:SetTexture (r, g, b, a)
		local color = {r, g, b, a}
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.left, "textcolor", color)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.center, "textcolor", color)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.right, "textcolor", color)
	end
	local colorpick = function()
		ColorPickerFrame.func = selectedColor
		ColorPickerFrame.cancelFunc = canceledColor
		ColorPickerFrame.opacityFunc = nil
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame.previousValues = window.child.options.textColor
		ColorPickerFrame:SetParent (window.widget)
		ColorPickerFrame:SetColorRGB (unpack (window.child.options.textColor))
		ColorPickerFrame:Show()
	end

	_detalhes.gump:NewImage (window, nil, 160, 16, nil, nil, "textcolortexture", "$parentTextColorTexture")
	window.textcolortexture:SetPoint ("left", window.textcolor, "right", 2)
	window.textcolortexture:SetTexture (1, 1, 1)
	
	_detalhes.gump:NewButton (window, _, "$parentTextColorButton", "textcolorbutton", 160, 20, colorpick)
	window.textcolorbutton:SetPoint ("left", window.textcolor, "right", 2)
	--window.textcolorbutton:InstallCustomTexture()
	
--> text size
	_detalhes.gump:NewLabel (window, _, "$parentFontSizeLabel", "fonsizeLabel", Loc ["STRING_PLUGINOPTIONS_TEXTSIZE"])
	window.fonsizeLabel:SetPoint (10, -55)
	--
	_detalhes.gump:NewSlider (window, _, "$parentSliderFontSize", "fonsizeSlider", 170, 20, 7, 20, 1, 1)
	window.fonsizeSlider:SetPoint ("left", window.fonsizeLabel, "right", 2)
	window.fonsizeSlider:SetThumbSize (50)
	--window.fonsizeSlider.useDecimals = true
	window.fonsizeSlider:SetHook ("OnValueChange", function (self, child, amount) 
		--_detalhes.StatusBar:ApplyOptions (child, "textsize", amount)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.left, "textsize", amount)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.center, "textsize", amount)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.right, "textsize", amount)
	end)
	
--> align
	_detalhes.gump:NewLabel (window, _, "$parentTextAlignLabel", "textalign", Loc ["STRING_PLUGINOPTIONS_TEXTALIGN"])
	window.textalign:SetPoint (10, -95)
	--
	_detalhes.gump:NewSlider (window, _, "$parentSliderAlign", "alignSlider", 180, 20, 0, 3, 1)
	window.alignSlider:SetPoint ("left", window.textalign, "right")
	window.alignSlider:SetThumbSize (75)
	window.alignSlider:SetHook ("OnValueChange", function (self, child, side)
		
		side = _math_floor (side)
		
		child.options.textAlign = side
		
		if (side == 0) then
			window.alignSlider.amt:SetText (Loc ["STRING_AUTO"])
		elseif (side == 1) then
			window.alignSlider.amt:SetText (Loc ["STRING_LEFT"])
		elseif (side == 2) then
			window.alignSlider.amt:SetText (Loc ["STRING_CENTER"])
		elseif (side == 3) then
			window.alignSlider.amt:SetText (Loc ["STRING_RIGHT"])
		end
		
		_detalhes.StatusBar:ReloadAnchors (child.instance)
		
		return true
	end)
	
--> text font
	local onSelectFont = function (_, child, fontName)
		--_detalhes.StatusBar:ApplyOptions (child, "textface", fontName)
		
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.left, "textface", fontName)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.center, "textface", fontName)
		_detalhes.StatusBar:ApplyOptions (window.instance.StatusBar.right, "textface", fontName)
		
	end

	local buildFontMenu = function() 
		local fontObjects = SharedMedia:HashTable ("font")
		local fontTable = {}
		for name, fontPath in pairs (fontObjects) do 
			fontTable[#fontTable+1] = {value = name, label = name, onclick = onSelectFont, font = fontPath}
		end
		return fontTable
	end
	
	_detalhes.gump:NewLabel (window, _, "$parentFontFaceLabel", "fontfaceLabel", Loc ["STRING_PLUGINOPTIONS_FONTFACE"])
	window.fontfaceLabel:SetPoint (10, -75)
	--
	_detalhes.gump:NewDropDown (window, _, "$parentFontDropdown", "fontDropdown", 170, 20, buildFontMenu, nil)
	window.fontDropdown:SetPoint ("left", window.fontfaceLabel, "right", 2)
	
	window:Hide()
	
--> align mod X
	_detalhes.gump:NewLabel (window, _, "$parentAlignXLabel", "alignXLabel", Loc ["STRING_PLUGINOPTIONS_TEXTALIGN_X"])
	window.alignXLabel:SetPoint (10, -115)
	--
	_detalhes.gump:NewSlider (window, _, "$parentSliderAlignX", "alignXSlider", 160, 20, -20, 20, 1, 0)
	window.alignXSlider:SetPoint ("left", window.alignXLabel, "right", 2)
	window.alignXSlider:SetThumbSize (40)
	window.alignXSlider:SetHook ("OnValueChange", function (self, child, amount) 
		_detalhes.StatusBar:ApplyOptions (child, "textxmod", amount)
	end)
	
--> align modY
	_detalhes.gump:NewLabel (window, _, "$parentAlignYLabel", "alignYLabel", Loc ["STRING_PLUGINOPTIONS_TEXTALIGN_Y"])
	window.alignYLabel:SetPoint (10, -135)
	--
	_detalhes.gump:NewSlider (window, _, "$parentSliderAlignY", "alignYSlider", 160, 20, -10, 10, 1, 0)
	window.alignYSlider:SetPoint ("left", window.alignYLabel, "right", 2)
	window.alignYSlider:SetThumbSize (40)
	window.alignYSlider:SetHook ("OnValueChange", function (self, child, amount) 
		_detalhes.StatusBar:ApplyOptions (child, "textymod", amount)
	end)
	
--> right click to close
	local c = window:CreateRightClickLabel ("short")
	c:SetPoint ("bottomleft", window, "bottomleft", 8, 5)
	
--> open options
	function _detalhes.StatusBar:OpenOptionsForChild (child)
		
		window.child = child
		window.instance = child.instance
		
		_G.DetailsStatusBarOptionsTextStyleDropdown.MyObject:SetFixedParameter (child)
		
		_G.DetailsStatusBarOptionsTextColorTexture:SetColorTexture (child.options.textColor[1], child.options.textColor[2], child.options.textColor[3], child.options.textColor[4])

		_G.DetailsStatusBarOptionsSliderFontSize.MyObject:SetFixedParameter (child)
		_G.DetailsStatusBarOptionsSliderFontSize.MyObject:SetValue (child.options.textSize)
		
		_G.DetailsStatusBarOptionsSliderAlign.MyObject:SetFixedParameter (child)
		_G.DetailsStatusBarOptionsSliderAlign.MyObject:SetValue (child.options.textAlign)

		_G.DetailsStatusBarOptionsFontDropdown.MyObject:SetFixedParameter (child)
		_G.DetailsStatusBarOptionsFontDropdown.MyObject:Select (child.options.textFace)
		
		_G.DetailsStatusBarOptionsSliderAlignX.MyObject:SetFixedParameter (child)
		_G.DetailsStatusBarOptionsSliderAlignX.MyObject:SetValue (child.options.textXMod)
		
		_G.DetailsStatusBarOptionsSliderAlignY.MyObject:SetFixedParameter (child)
		_G.DetailsStatusBarOptionsSliderAlignY.MyObject:SetValue (child.options.textYMod)
		
		_G.DetailsStatusBarOptions:Show()
		
		if (child.ExtraOptions) then
		
			if (type (child.ExtraOptions) == "function") then
				child.ExtraOptions()
			end
			
			extraWindow:HideWidgets()
			
			for _, widget in pairs (child.ExtraOptions) do
				widget:Show()
			end
			
			child:ExtraOptionsOnOpen (child)
			
			extraWindow:Show()
		else
			extraWindow:Hide()
		end
	end

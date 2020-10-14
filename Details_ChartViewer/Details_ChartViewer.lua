local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ("Details_ChartViewer")

local _math_floor = math.floor
local _cstr = string.format
local _string_len = string.len
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local ipairs = ipairs

--> Create the plugin Object
local ChartViewer = _detalhes:NewPluginObject ("Details_ChartViewer", DETAILSPLUGIN_ALWAYSENABLED)
--> Main Frame
local CVF = ChartViewer.Frame

--> desc
ChartViewer:SetPluginDescription (Loc ["STRING_PLUGIN_DESC"])

local plugin_version = "v2.90" 

local function CreatePluginFrames (data)

--	ChartViewerWindowFrame:SetBackdrop (_detalhes.PluginDefaults and _detalhes.PluginDefaults.Backdrop or {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
--	edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
--	insets = {left = 1, right = 1, top = 1, bottom = 1}})
--	ChartViewerWindowFrame:SetBackdropColor (unpack (_detalhes.PluginDefaults and _detalhes.PluginDefaults.BackdropColor or {0, 0, 0, .6}))
--	ChartViewerWindowFrame:SetBackdropBorderColor (unpack (_detalhes.PluginDefaults and _detalhes.PluginDefaults.BackdropBorderColor or {0, 0, 0, 1}))

	ChartViewerWindowFrame.bg1 = ChartViewerWindowFrame:CreateTexture (nil, "background")
	ChartViewerWindowFrame.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
	ChartViewerWindowFrame.bg1:SetAlpha (0.7)
	ChartViewerWindowFrame.bg1:SetVertexColor (0.27, 0.27, 0.27)
	ChartViewerWindowFrame.bg1:SetVertTile (true)
	ChartViewerWindowFrame.bg1:SetHorizTile (true)
	ChartViewerWindowFrame.bg1:SetAllPoints()	

	local c = CreateFrame ("Button", "ChartViewerWindowFrameCloseButton", ChartViewerWindowFrame, "UIPanelCloseButton")
	c:SetWidth (20)
	c:SetHeight (20)
	c:SetPoint ("TOPRIGHT", ChartViewerWindowFrame, "TOPRIGHT", -2, -3)
	c:SetFrameLevel (ChartViewerWindowFrame:GetFrameLevel()+1)
	c:GetNormalTexture():SetDesaturated (true)
	c:SetAlpha (1)

	function ChartViewer:OnDetailsEvent (event)

		if (event == "HIDE") then
			--> in case the welcome is shown when hiding the main panel
			if (ChartViewer.welcome_panel) then
				ChartViewer.welcome_panel:Hide()
			end
		
		elseif (event == "SHOW") then
			if (not ChartViewerWindowFrame.OptionsButton) then
				local options = ChartViewer:GetFramework():NewButton (ChartViewerWindowFrame, nil, "$parentOptionsButton", "OptionsButton", 120, 20, ChartViewer.OpenOptionsPanel, nil, nil, nil, "Options")
				options:SetTextColor (1, 0.93, 0.74)
				options:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
				options:SetPoint ("left", ChartViewer.NewTabButton, "right", 4, 0)
				options:SetTemplate (ChartViewer:GetFramework():GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
				options:SetFrameLevel (10)
			end
			
			ChartViewer:RefreshScale()
			
		elseif (event == "PLUGIN_DISABLED") then
			ChartViewer:HideButton()
		
		elseif (event == "PLUGIN_ENABLED") then
			ChartViewer:CanShowOrHideButton()
			if (ChartViewerWindowFrame and ChartViewerWindowFrame:IsShown()) then
				ChartViewer:RefreshScale()
			end
			
		elseif (event ==  "DETAILS_STARTED") then
			--> craete icon
			ChartViewer:CanShowOrHideButton()
		
		elseif (event ==  "DETAILS_DATA_RESET") then
			--ChartViewer:CanShowOrHideButton()
			--ChartViewerWindowFrame:Hide()
			
		elseif (event ==  "COMBAT_PLAYER_LEAVE") then
			ChartViewer:CheckFor_CreateNewTabForCombat()
			ChartViewer:CanShowOrHideButton()
			
		elseif (event ==  "COMBAT_PLAYER_ENTER") then
			ChartViewer:OnCombatEnter()
		
		elseif (event ==  "COMBAT_CHARTTABLES_CREATING") then
			--criar as data captures
			for index, tab in ipairs (ChartViewer.tabs) do
				if (tab.data and tab.data:find ("PRESET_")) then
					ChartViewer:BuildAndAddPresetFunction (tab.data)
				end
			end
			
		elseif (event ==  "COMBAT_CHARTTABLES_CREATED") then
			--apagar as data captures
			for i = #_detalhes.savedTimeCaptures, 1, -1 do
				local t = _detalhes.savedTimeCaptures [i]
				if (t[1]:find ("PRESET_")) then
					_detalhes:TimeDataUnregister (t[1])
				end
			end
		end
	end
	
	
----------> Check Combat 
function ChartViewer:CheckFor_CreateNewTabForCombat()

	if (not ChartViewer.db.options.auto_create) then
		return
	end

	local combat = ChartViewer:GetCurrentCombat()
	if (combat) then

		--verifica se o comnate era arena, verifica se tem uma aba pra arena.
		if (combat.is_arena) then
			local has_arena_tab = false
			
			for _, tab in ChartViewer:GetAllTabs() do
				if (tab.iType and tab.iType:find ("arena")) then
					has_arena_tab = true
					break
				end
			end
			
			--print ("IS ARENA COMBAT", has_arena_tab)
			
			if (not has_arena_tab) then
				--> auto create an arena tab (two actually)
				local presets = ChartViewer:GetChartsForIType ("arena", true)
				--print ("FOUND:", #presets, "presets.")
				for _, preset_name in ipairs (presets) do
					-- create chart for this preset
					local internal_options = ChartViewer:GetInternalOptionsForChart (preset_name)
					ChartViewer:CreateTab (internal_options.name, 1, preset_name, "line", internal_options, preset_name)
					--print ("Auto Created Arena Tab:", preset_name)
				end
			end
		
		elseif (combat.is_boss) then
			local has_raid_tab = false
			local role = UnitGroupRolesAssigned ("player")
			local iType = "raid-" .. role
			
			for _, tab in ChartViewer:GetAllTabs() do
				if (tab.iType and tab.iType == iType) then
					has_raid_tab = true
					break
				end
			end
			
			if (not has_raid_tab) then
				local presets = ChartViewer:GetChartsForIType (iType)
				for _, preset_name in ipairs (presets) do
					-- create chart for this preset
					local internal_options = ChartViewer:GetInternalOptionsForChart (preset_name)
					ChartViewer:CreateTab (internal_options.name, 1, preset_name, "line", internal_options, preset_name)
					--print ("Auto Created Raid Tab:", preset_name)
				end
			end
		
		end

	end
end
		
----------> Tabs
	local titlecase = function (first, rest)
		return first:upper()..rest:lower()
	end
	
	--tab on enter
	function ChartViewer:TabOnEnter (tab)
			GameTooltip:SetOwner (tab, "ANCHOR_TOPLEFT")
			local tabObject = DETAILS_PLUGIN_CHART_VIEWER:GetTab (tab.index)
			GameTooltip:AddLine (tabObject.name)
			GameTooltip:AddLine (tabObject.segment_type == 1 and "Current Segment" or "Last 5 Segments")
			GameTooltip:AddLine (" ")
			
			local chartData = tabObject.data
			if (chartData:find ("MULTICHARTS~")) then --multichart
				chartData = chartData:gsub ("MULTICHARTS~", "")
				chartData = chartData:gsub ("~", ", ")
				
			elseif (chartData:find ("_")) then --preset
				chartData = chartData:gsub ("_", " ")
				chartData = chartData:gsub ("(%a)([%w_']*)", titlecase)
				chartData = chartData:gsub ("Preset", "Preset:")
			end
			
			GameTooltip:AddDoubleLine ("Chart:", chartData)
			GameTooltip:Show()
			tab.CloseButton:SetNormalTexture ("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	end	
		
	--new tab
		ChartViewer.tab_prototype = {name = Loc ["STRING_NEWTAB"], segment_type = 1, data = "", texture = "line", version = "v2.0"}
		
		function ChartViewer:GetAllTabs()
			return ipairs (self.tabs)
		end
		
		function ChartViewer:GetTab (tabindex)
			return self.tabs [tabindex]
		end
		
		function ChartViewer:CreateTab (tabname, segment_type, tabdata, tabtexture, extra_options, data_preset_name)
		
			if (not tabname) then
				return false
				
			elseif (_string_len (tabname) < 2) then
				ChartViewer:Msg (Loc ["STRING_TOOSHORTNAME"])
				return false
				
			end
			
			if (not segment_type) then
				segment_type = 1
			end
			
			if (tabname == Loc ["STRING_NEWTAB"] and data_preset_name and data_preset_name ~= "") then
				tabname = data_preset_name
			end
			
			local new_tab = table_deepcopy (ChartViewer.tab_prototype)
			new_tab.name = tabname
			new_tab.segment_type = segment_type
			new_tab.data = tabdata
			new_tab.texture = tabtexture
			new_tab.options = extra_options
			
			if (extra_options) then
				new_tab.iType = extra_options.iType
			end
			
			new_tab.iType = new_tab.iType or "NONE"
			
			tinsert (ChartViewer.tabs, new_tab)
			
			ChartViewer:TabRefresh (#ChartViewer.tabs)
			return new_tab
		end
		
	--refresh tabs
		function ChartViewer:TabRefresh (tab_selected)
			
			--put in order
			for index, tab in ipairs (ChartViewer.tabs) do 
				local tabFrame = ChartViewer:TabGetFrame (index)
				tabFrame:Show()
				tabFrame:SetText (tab.name)
				tabFrame.index = index
				tabFrame:SetPoint ("topleft", tabFrame:GetParent(), "topleft", 50 + ( (index-1) * 100), -30)
			end
			
			--hide not used tabs
			ChartViewer:TabHideNotUsedFrames()
			
			--check which tab is selected
			if (not tab_selected) then
				tab_selected = ChartViewer.tabs.last_selected
			end
			if (tab_selected > #ChartViewer.tabs) then
				tab_selected = #ChartViewer.tabs
			end
			
			--click on the selected tab
			ChartViewer:TabClick (ChartViewer.tab_container [tab_selected])
		end
	
	--click on a tab
	
		function ChartViewer:TabDoubleClick (self)
			--edit
			local tab = ChartViewer.tabs [self.index]
			
			ChartViewer.type_dropdown:Select (tab.segment_type, true)
			ChartViewer.data_dropdown:Select (tab.data)
			
			ChartViewer.type_dropdown:Disable()
			ChartViewer.data_dropdown:Disable()
			
			ChartViewer.create_button.text = Loc ["STRING_CONFIRM"]
			
			ChartViewer.name_textentry.text = tab.name
			ChartViewer.texture_dropdown:Select (tab.texture)
			
			ChartViewer.NewTabPanel.editing = tab
			ChartViewer.NewTabPanel:Show()
		end
	
		function ChartViewer:TabClick (self)
			ChartViewer.tabs.last_selected = self.index
			ChartViewer:TabHighlight (self.index)
			ChartViewer:RefreshGraphic()
		end
		
	--get the selected tab object
		function ChartViewer:TabGetCurrent()
			return ChartViewer.tabs [ChartViewer.tabs.last_selected]
		end

	--delete a tab
		function ChartViewer:TabErase (index)

			--get the new index
			local new_selected_tab = 1
			if (#ChartViewer.tabs > 1) then
				if (index == ChartViewer.tabs.last_selected) then
					if (index > 1 and #ChartViewer.tabs > index) then
						new_selected_tab = index
					elseif (index == #ChartViewer.tabs) then
						ChartViewer:TabRefresh (index-1)
					else
						ChartViewer:TabRefresh (1)
					end
					
				elseif (index < ChartViewer.tabs.last_selected) then
					new_selected_tab = ChartViewer.tabs.last_selected - 1
				else
					new_selected_tab = ChartViewer.tabs.last_selected
				end
			end
			--do the erase thing
			tremove (ChartViewer.tabs, index)
			
			--check if there is at least 1 tab
			if (#ChartViewer.tabs == 0) then
				ChartViewer.tabs [1] = {name = Loc ["STRING_NEWTAB"], captures = {}, segment_type = 1, data = "", texture = "line"}
				new_selected_tab = 1
			end
			
			--refresh
			ChartViewer:TabRefresh (new_selected_tab)
		end
		
	--tab frames
		function ChartViewer:TabGetFrame (index)
			local frame = ChartViewer.tab_container [index]
			if (not frame) then
				frame = ChartViewer:TabCreateFrame (index)
				frame.widget.index = index
				frame.index = index
				tinsert (ChartViewer.tab_container, frame)
			end
			return frame
		end
		function ChartViewer:TabCreateFrame (index)
			local onClick = function (self, button)
				if (self.lastclick and self.lastclick + 0.2 > GetTime()) then
					DETAILS_PLUGIN_CHART_VIEWER:TabDoubleClick (self)
					self.lastclick = nil
					return
				end
				self.lastclick = GetTime()
				if (button == "LeftButton") then
					ChartViewer:TabClick (self)
				end			
			end
			local frame = DetailsFramework:CreateButton (ChartViewerWindowFrame, onClick, 20, 20)
			frame:SetTemplate ("DETAILS_TAB_BUTTON_TEMPLATE")
			frame:SetAlpha (0.8)
			return frame
		end
		function ChartViewer:TabHideNotUsedFrames()
			for i = #ChartViewer.tabs+1, #ChartViewer.tab_container do
				ChartViewer.tab_container [i]:Hide()
			end
		end
		function ChartViewer:TabHighlight (index)
			for i = 1, #ChartViewer.tab_container do
				local tabFrame = ChartViewer:TabGetFrame (i)
				if (i == index) then
					tabFrame:SetTemplate ("DETAILS_TAB_BUTTONSELECTED_TEMPLATE")
				else
					tabFrame:SetTemplate ("DETAILS_TAB_BUTTON_TEMPLATE")
				end
			end

		end
		
		--if is a boss encounter, force close the window
		local check_for_boss = function()
			if (_detalhes and _detalhes.tabela_vigente and _detalhes.tabela_vigente.is_boss) then
				if (CVF and CVF:IsShown()) then
					CVF:Hide()
				end
			end
		end
		
		function ChartViewer:OnCombatEnter()
			ChartViewer.current_on_combat = true
			ChartViewer.capturing_data = true
			
			C_Timer.After (1, check_for_boss)
		end
	
----------> Icon show functions
		function ChartViewer:ShowButton()
			if (not ChartViewer.ToolbarButton:IsShown()) then
				ChartViewer:ShowToolbarIcon (ChartViewer.ToolbarButton, "star")
			end
		end
		function ChartViewer:HideButton()
			if (ChartViewer.ToolbarButton:IsShown()) then
				ChartViewer:HideToolbarIcon (ChartViewer.ToolbarButton)
			end
		end
		
		function ChartViewer:RefreshScale()
			local scale = ChartViewer.options.window_scale
			if (ChartViewerWindowFrame) then
				ChartViewerWindowFrame:SetScale (scale)
			end
		end
		
		function ChartViewer:CanShowOrHideButton()
		
			if (not ChartViewer.__enabled) then
				return ChartViewer:HideButton()
			end
			
			if (ChartViewer.welcome_panel) then
				ChartViewer:ShowButton()
				return
			end
		
			if (self.options.show_method == 1) then --> always show
				ChartViewer:ShowButton()
				
			elseif (self.options.show_method == 2) then --> group
				if (IsInGroup() or IsInRaid()) then
					ChartViewer:ShowButton()
				else
					ChartViewer:HideButton()
				end
				
			elseif (self.options.show_method == 3) then --> inside instances
				local _, instanceType = GetInstanceInfo()
				if (instanceType == "raid") then
					ChartViewer:ShowButton()
				else
					ChartViewer:HideButton()
				end
				
			elseif (self.options.show_method == 4) then --> automatic
			
				local segments = ChartViewer:GetCombatSegments()
				local segments_start_index = 1
				
				for i = 1, #segments do
					local this_combat = segments [i]
					if ( (not this_combat.is_trash and this_combat.is_boss and this_combat.TimeData) or (this_combat.is_arena)) then
						local charts = this_combat.TimeData
						if (charts) then
							for id, chart in pairs (charts) do
								if (chart and chart [1] and chart [2]) then
									ChartViewer:ShowButton()
									return
								end
							end
						end
					end
				end

				ChartViewer:HideButton()
			end
		end
		
		ChartViewer.CanShowOrHideButtonEvents = {
			["GROUP_ROSTER_UPDATE"] = true,
			["ZONE_CHANGED_NEW_AREA"] = true,
			["PLAYER_ENTERING_WORLD"] = true,
		}
		
		function ChartViewer:CreateNewDataFeed (templateID)
			local name = ChartViewer.DataFeedTemplatesByIndex [templateID]
			local script = ChartViewer.DataFeedTemplates [name]
			
			if (script) then
				local result = ChartViewer:TimeDataRegister (name, script, nil, "Chart Viewer", "1.0", [[Interface\ICONS\TEMP]], true)
				if (type (result) == "string") then
					ChartViewer:Msg (result)
				else
					ChartViewer:Msg (Loc ["STRING_ADDEDOKAY"])
				end
			end
		end

----------> Graphic Frame
	
	--graphic
		local frame = _G.ChartViewerWindowFrame
		frame:SetToplevel (true)
	
		--> using details framework
		local chart_panel = ChartViewer:GetFramework():CreateChartPanel (frame, frame:GetWidth()-20, frame:GetHeight()-20, "ChartViewerWindowFrameChartFrame")
		chart_panel:SetPoint ("topleft", frame, "topleft", 8, -65)
		chart_panel:SetTitle ("")
		chart_panel:SetFrameStrata ("HIGH")
		chart_panel:SetFrameLevel (4)
		chart_panel:CanMove (false)
		chart_panel:HideCloseButton()
		chart_panel:RightClickClose (false)
		
		if (not DetailsPluginContainerWindow) then
			chart_panel:SetScript ("OnMouseDown", function (self, button)
				if (button == "LeftButton") then
					if (not frame.isMoving) then
						frame.isMoving = true
						frame:StartMoving()
					end
				elseif (button == "RightButton") then
					if (not frame.isMoving) then
						frame:Hide()
					end
				end
			end)
			chart_panel:SetScript ("OnMouseUp", function (self, button)
				if (button == "LeftButton" and frame.isMoving) then
					frame.isMoving = nil
					frame:StopMovingOrSizing()
				end
			end)
		else
			chart_panel:EnableMouse (false)
		end
		
		chart_panel:SetBackdrop({
				edgeFile = [[Interface\Buttons\WHITE8X8]], tile = true, tileSize = 16, edgeSize = 1,
				insets = {left = 1, right = 1, top = 0, bottom = 1},})
		chart_panel:SetBackdropBorderColor (0, 0, 0, 1)
		
		local g = chart_panel
		
		g:Reset()

	--refresh the graphic
	
		local colors = {
			{1, 1, 1}, {1, 1, .4}, {1, 0.9, 0.1}, {1, 0.5, 0.1}, {1, 0.1, 0.1}, {1, 0.1, 0.5}, {1, 0.1, 0.9}, {0.9, 0.4, 1}, {0.6, 0.7, 1}, {0.3, 0.9, 1},
			{0.1, 1, 0.9}, {0.1, 1, 0.5}, {0.1, 1, 0.1}, {0.4, 0.5, 0.5}, {0.7, 0.3, 0.3}, {1, 0.5, 1}, {0.8, 0.5, 0.8}, {0.9, 0.5, 0.8}, {1, 0.4, 0.8}, {0.4, 0.4, 0.8}
		}
	
		function ChartViewer:RefreshGraphic (combat)
		
			if (not combat) then
				combat = ChartViewer:GetCombat (ChartViewer.current_segment)
				if (not combat) then
					ChartViewer.current_segment = 1
					combat = ChartViewer:GetCurrentCombat()
					ChartViewer.segments_dropdown:Select (1, true)
				end
			end
			
			local current_tab = ChartViewer:TabGetCurrent()
			
			local capture_name = current_tab.data
			local tab_type = current_tab.segment_type
			local options = current_tab.options
			
			g:Reset()
			
			local segments = ChartViewer:GetCombatSegments()
			local segments_start_index = 1
			
			--avoid selecting a trash segment during raids
			if (IsInInstance() and (combat.is_trash or not combat.is_boss)) then
				for i = 1, #segments do
					local this_combat = segments [i]
					if (not this_combat.is_trash) then
						combat = this_combat
						segments_start_index = i
						break
					end
				end
			end
			
			local elapsed_time = combat:GetCombatTime()
			local texture = current_tab.texture
			local data = {}
			local maxTime = 0
			local boss_id = combat.is_boss and combat.is_boss.id
			
			if (capture_name:find ("MULTICHARTS~") and tab_type == 1 and elapsed_time > 12) then --current
				-- v�rias charts setadas no valor
				local charts = {}
				for key in capture_name:gsub ("MULTICHARTS~", ""):gmatch ("[^%~]+") do 
					charts [key] = true
				end
				
				local i = 1
				for name, t in pairs (combat.TimeData) do
					if (charts [name] and t.max_value and t.max_value > 0) then
						--> mostrar
						local color = colors [i] or colors [1]
						if (options) then
							if (options.colors and options.colors [name]) then
								color = options.colors [name]
							end
						end
						tinsert (data, {t, color, elapsed_time, name, texture})
						if (elapsed_time > maxTime) then
							maxTime = elapsed_time
						end
						i = i + 1
					end
				end
			
			elseif (capture_name:find ("PRESET_") and tab_type == 1 and elapsed_time > 12) then --current
			
				-- � um preset e precisa pegar todos os presets registrados no combate desse tipo
				local i = 1
				for name, t in pairs (combat.TimeData) do
					if (name:find (capture_name) and t.max_value and t.max_value > 0) then
						--> mostrar
						local data_name = name:gsub ((".*%~"), "")
						data_name = data_name:gsub (("%-.*"), "")
						tinsert (data, {t, colors [i] or colors [1], elapsed_time, data_name, texture})
						if (elapsed_time > maxTime) then
							maxTime = elapsed_time
						end
						i = i + 1
					end
				end
			
			elseif (tab_type == 1 and elapsed_time > 12) then --current segment
			
				local chart_data = combat.TimeData [capture_name]
				if (chart_data and chart_data.max_value and chart_data.max_value > 0) then
					tinsert (data, {chart_data, {1, 1, 1}, elapsed_time, capture_name, texture})
					if (elapsed_time > maxTime) then
						maxTime = elapsed_time
					end
				end
			
			elseif (tab_type == 2) then --last 5 segments
			
				local color_index = 1
				local boss_index = 1
			
				for i = segments_start_index + 5, segments_start_index, -1 do
					local combat = ChartViewer:GetCombat (i)
					if (combat) then
						
						local boss_validated = true
						if (boss_id) then
							if ((not combat.is_boss) or (not combat.is_boss.id) or (combat.is_boss.id ~= boss_id)) then
								boss_validated = false
							end
						end
					
						local elapsed_time = combat:GetCombatTime()
						if (elapsed_time > 12 and boss_validated) then
						
							if (capture_name:find ("PRESET_")) then --current
								for name, t in pairs (combat.TimeData) do
									if (name:find (capture_name) and t.max_value and t.max_value > 0) then
										--> mostrar
										local data_name
										if (boss_index == 1) then
											data_name = name:gsub ((".*%~"), "")
											boss_index = boss_index + 1
										else
											data_name = "segment #" .. boss_index
											boss_index = boss_index + 1
										end
										
										tinsert (data, {t, colors [color_index] or colors [1], elapsed_time, data_name, texture})
										color_index = color_index + 1
										
										if (elapsed_time > maxTime) then
											maxTime = elapsed_time
										end
									end
								end
							else
								local chart_data = combat:GetTimeData (capture_name)
								if (chart_data and chart_data.max_value and chart_data.max_value > 0) then
								
									local data_name
									if (boss_index == 1) then
										data_name = capture_name
										boss_index = boss_index + 1
									else
										data_name = "segment #" .. boss_index
										boss_index = boss_index + 1
									end
									
									tinsert (data, {chart_data, colors [color_index] or colors [1], elapsed_time, data_name, texture})
									color_index = color_index + 1
									
									if (elapsed_time > maxTime) then
										maxTime = elapsed_time
									end
								end
							end
							
						end
					end
				end
			
			end
			
			if (#data > 0) then
				for index, chart in ipairs (data) do 
					--> get the tables and color
					local chart_data = chart [1]
					local chart_color = chart [2]
					local combat_time = chart [3]
					local line_name = chart [4]
					local texture = chart [5]
					
					g:AddLine (chart_data, chart_color, line_name, combat_time, texture) --, "SMA"
				end
			end
			
		end

----------> Window Functions

		function ChartViewer.RefreshWindow()
			local segments = ChartViewer:GetCombatSegments()
			
			for i = 1, #segments do
				local this_combat = segments [i]
				if (this_combat.is_boss and this_combat.is_boss.index) then
				
					ChartViewer.current_segment = i
					ChartViewer.segments_dropdown:Refresh()
					ChartViewer.segments_dropdown:Select (1, true)
					
					break
				end
			end
			
			ChartViewer:TabRefresh()
		end

	--open window
		function ChartViewer:OpenWindow()
			local segments = ChartViewer:GetCombatSegments()
			
			for i = 1, #segments do
				local this_combat = segments [i]
				if (this_combat.is_boss and this_combat.is_boss.index) then
				
					ChartViewer.current_segment = i
					ChartViewer.segments_dropdown:Refresh()
					ChartViewer.segments_dropdown:Select (1, true)
					
					break
				end
			end
			
			ChartViewer:TabRefresh()
			
			--ChartViewerWindowFrame:Show()
			DetailsPluginContainerWindow.OpenPlugin (ChartViewer)
			
			if (ChartViewer.welcome_panel) then
				ChartViewer.welcome_panel:Show()
				ChartViewer.welcome_panel = nil
			end
		end
		
	
----------> Create the icon

	local cooltip_menu = function()
		
		local CoolTip = GameCooltip2
		
		CoolTip:Reset()
		CoolTip:SetType ("menu")
		
		CoolTip:SetOption ("TextSize", Details.font_sizes.menus)
		CoolTip:SetOption ("TextFont", Details.font_faces.menus)		

		CoolTip:SetOption ("LineHeightSizeOffset", 3)
		CoolTip:SetOption ("VerticalOffset", 2)
		CoolTip:SetOption ("VerticalPadding", -4)
		CoolTip:SetOption ("FrameHeightSizeOffset", -3)
		
		Details:SetTooltipMinWidth()
		
		--build the menu with the available tabs
			for index, tab in ipairs (ChartViewer.tabs) do 
				CoolTip:AddLine (tab.name .. " Graphic")
				CoolTip:AddIcon ([[Interface\Addons\Details_ChartViewer\icon]], 1, 1, 16, 16, 0, 1, 0, 1, "orange")
				
				CoolTip:AddMenu (1, function() 
					ChartViewer:OpenWindow()
					local tab = ChartViewer:TabGetFrame (index)
					tab:Click()
					CoolTip:Hide()
				end, "main")
			end
			
		--apply the backdrop settings to the menu
		Details:FormatCooltipBackdrop()
		CoolTip:SetOwner (CHARTVIEWER_BUTTON, "bottom", "top", 0, 0)
		CoolTip:ShowCooltip()
	end	

		ChartViewer.ToolbarButton = _detalhes.ToolBar:NewPluginToolbarButton (ChartViewer.OpenWindow, [[Interface\Addons\Details_ChartViewer\icon]], Loc ["STRING_PLUGIN_NAME"], Loc ["STRING_TOOLTIP"], 14, 14, "CHARTVIEWER_BUTTON", cooltip_menu)
		ChartViewer.ToolbarButton.shadow = true
		
end

local build_options_panel = function()

	local options_frame = ChartViewer:CreatePluginOptionsFrame ("ChartViewerOptionsWindow", Loc ["STRING_OPTIONS"], 2)
	
	local set = function (_, _, value) 
		ChartViewer.options.show_method = value 
		ChartViewer:CanShowOrHideButton()
	end
	local on_show_menu = {
		{value = 1, label = "Always", onclick = set, desc = "Always show the icon."},
		{value = 2, label = "In Group", onclick = set, desc = "Only show the icon while in group."},
		{value = 3, label = "Inside Raid", onclick = set, desc = "Only show the icon while inside a raid."},
		{value = 4, label = "Auto", onclick = set, desc = "The plugin decides when the icon needs to be shown."},
	}
	
	local menu = {
		{
			type = "select",
			get = function() return ChartViewer.options.show_method end,
			values = function() return on_show_menu end,
			desc = "When the icon is shown over Details! toolbar.",
			name = Loc ["STRING_OPTIONS_SHOWICON"]
		},
		{
			type = "range",
			get = function() return ChartViewer.options.window_scale end,
			set = function (self, fixedparam, value) ChartViewer.options.window_scale = value; ChartViewer:RefreshScale() end,
			min = 0.65,
			max = 1.50,
			step = 0.1,
			desc = "Set the window size",
			name = Loc ["STRING_OPTIONS_WINDOWSCALE"],
			usedecimals = true,
		},
	}
	ChartViewer:GetFramework():BuildMenu (options_frame, menu, 15, -75, 260)
end

ChartViewer.OpenOptionsPanel = function()
	if (not ChartViewerOptionsWindow) then
		build_options_panel()
		ChartViewerOptionsWindow:SetFrameStrata ("FULLSCREEN")
	end
	
	ChartViewerOptionsWindow:Show()
end

local create_segment_dropdown = function()

	local statusbar_background = CreateFrame ("frame", nil, ChartViewerWindowFrame, "BackdropTemplate")
	statusbar_background:SetPoint ("bottomleft", ChartViewerWindowFrame, "bottomleft")
	statusbar_background:SetPoint ("bottomright", ChartViewerWindowFrame, "bottomright")
	statusbar_background:SetHeight (30)
	statusbar_background:EnableMouse (true)
	statusbar_background:SetFrameLevel (9)
	
	local frame = ChartViewerWindowFrame
	if (not DetailsPluginContainerWindow) then
		statusbar_background:SetScript ("OnMouseDown", function (self, button)
			if (button == "LeftButton") then
				if (not frame.isMoving) then
					frame.isMoving = true
					frame:StartMoving()
				end
			elseif (button == "RightButton") then
				if (not frame.isMoving) then
					frame:Hide()
				end
			end
		end)
		statusbar_background:SetScript ("OnMouseUp", function (self, button)
			if (button == "LeftButton" and frame.isMoving) then
				frame.isMoving = nil
				frame:StopMovingOrSizing()
			end
		end)
	end

	local on_segment_chosen = function (self, _, segment)
		ChartViewer.current_segment = segment
		ChartViewer:RefreshGraphic (ChartViewer:GetCombat (segment))
	end

	local build_segments_menu = function (self)
		local segments = ChartViewer:GetCombatSegments()
		local return_table = {}
		
		for index, combat in ipairs (segments) do
			--verify if the combat has a valid chart to display
			if (next (combat.TimeData)) then
				if (combat.is_boss and combat.is_boss.index) then
					local l, r, t, b, icon = ChartViewer:GetBossIcon (combat.is_boss.mapid, combat.is_boss.index)
					return_table [#return_table+1] = {value = index, label = "#" .. index .. " " .. combat.is_boss.name, icon = icon, texcoord = {l, r, t, b}, onclick = on_segment_chosen}
					
				else
					return_table [#return_table+1] = {value = index, label = "#" .. index .. " " .. (combat.enemy or "unknown"), icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], onclick = on_segment_chosen}
				end
			end
		end
		
		return return_table
	end
	
	local segments_string = ChartViewer:GetFramework():CreateLabel (ChartViewerWindowFrame, "Segment:", nil, nil, "GameFontNormal")
	segments_string:SetPoint ("bottomleft", frame, "bottomleft", 8, 12)
	
	local segments_dropdown = ChartViewer:GetFramework():CreateDropDown (ChartViewerWindowFrame, build_segments_menu, 1, 150, 20)
	segments_dropdown:SetPoint ("left", segments_string, "right", 2, 0)
	segments_dropdown:SetFrameLevel (10)
	segments_dropdown:SetTemplate (_detalhes.gump:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	ChartViewer.segments_dropdown = segments_dropdown
end

--<
local create_delete_button = function (f, name)
	local frame = CreateFrame ("frame", "ChartViewerDeleteButton" .. (name or math.random (1, 100000)), f, "BackdropTemplate")
	frame:SetPoint ("topleft", f, "topleft", 10, -10)
	frame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8})
	
	local delete_button = CreateFrame ("button", nil, frame, "BackdropTemplate")
	delete_button:SetPoint ("topleft", frame, "topleft")
	delete_button:SetPoint ("bottomright", frame, "bottomright")
	delete_button:SetScript ("OnClick", function()
		ChartViewer.tabs [delete_button.Id] = nil
		ChartViewer:TabRefresh (#ChartViewer.tabs)
	end)
	return frame
end
	
local create_add_tab_button = function()
	local fw = ChartViewer:GetFramework()
	
	local button = fw:CreateButton (ChartViewerWindowFrame, ChartViewer.OpenAddTabPanel, 120, 20, "Add Chart")
	button:SetTextColor (1, 0.93, 0.74)
	button:SetIcon ([[Interface\PaperDollInfoFrame\Character-Plus]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
	button:SetTemplate (ChartViewer:GetFramework():GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
	button:SetFrameLevel (10)

	button:SetPoint ("left", ChartViewer.segments_dropdown, "right", 4, 0)
	ChartViewer.NewTabButton = button
end
local create_add_tab_panel = function()
	
	local fw = ChartViewer:GetFramework()
	
	local panel = fw:CreatePanel (ChartViewerWindowFrame, 360, 280)
	ChartViewer.NewTabPanel = panel
	
	panel:SetPoint ("center", ChartViewerWindowFrame, "center")
	
	panel:SetFrameStrata ("FULLSCREEN")
	
	Details:FormatBackground (panel)
	
	local titlebar = CreateFrame ("frame", nil, panel.widget, "BackdropTemplate")
	titlebar:SetPoint ("topleft", panel.widget, "topleft", 2, -3)
	titlebar:SetPoint ("topright", panel.widget, "topright", -2, -3)
	titlebar:SetHeight (20)
	titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
	titlebar:SetBackdropColor (.5, .5, .5, 1)
	titlebar:SetBackdropBorderColor (0, 0, 0, 1)
	--> title
	local titleLabel = _detalhes.gump:NewLabel (titlebar, titlebar, nil, "titulo", "Add Chart", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
	titleLabel:SetPoint ("center", titlebar , "center")
	titleLabel:SetPoint ("top", titlebar , "top", 0, -5)
	
	
	local x_start = 10
	
	--<
	local tab_size = {
		width = 1024,
		height = 768,
	}
	
	-- name
		--label
		local name_label = fw:CreateLabel (panel, "Name:") -- , size, color, font, member, name, layer)
		
		--texentry
		local name_textentry = fw:CreateTextEntry (panel, func, 150, 20) -- , member, name)
		name_textentry:SetPoint ("left", name_label, "right", 2, 0)
		ChartViewer.name_textentry = name_textentry
		name_textentry:SetTemplate (ChartViewer:GetFramework():GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		
	-- type
		--label
		local type_label = fw:CreateLabel (panel, "Type:")
		
		--dropdown
		local type_options_onselect = function()
			if (ChartViewer.data_dropdown) then
				ChartViewer.data_dropdown:Refresh()
				ChartViewer.data_dropdown:Select (1, true)
			end
		end
		local type_options = {
			{onclick = type_options_onselect, value = 1, icon = [[Interface\AddOns\Details\images\toolbar_icons]], iconcolor = {1, 1, 1}, iconsize = {14, 14}, texcoord = {32/256, 64/256, 0, 1}, label = "Current Segment", desc = "Show data only for the current segment, but can show more than one player."},
			{onclick = type_options_onselect, value = 2, icon = [[Interface\AddOns\Details\images\toolbar_icons]], iconcolor = {1, 1, 1}, iconsize = {14, 14}, texcoord = {32/256, 64/256, 0, 1}, label = "Last 5 Segments", desc = "Show only one player, but shows it for the last 5 segments."},
		}
		local type_options_func = function()
			return type_options
		end
		local type_dropdown = fw:CreateDropDown (panel, type_options_func, 1, 150, 20) -- , member, name
		type_dropdown:SetPoint ("left", type_label, "right", 2, 0)
		ChartViewer.type_dropdown = type_dropdown
		type_dropdown:SetTemplate (ChartViewer:GetFramework():GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		
	-- data
		--label
		local data_label = fw:CreateLabel (panel, "Data:")
		
		--dropdown
		local data_options_func = function()
		
			if (type_dropdown.value == 1) then -- current
				local t = {}
				
				-- raid healing done
				tinsert (t, {value = "PRESET_PLAYER_HEAL", label = "Player Healing Done", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				-- player healing done
				tinsert (t, {value = "PRESET_RAID_HEAL", label = "Raid Healing Done", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				-- same class
				tinsert (t, {value = "PRESET_DAMAGE_SAME_CLASS", label = "Damage (Same Class)", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				tinsert (t, {value = "PRESET_HEAL_SAME_CLASS", label = "Healing (Same Class)", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				-- all damagers
				tinsert (t, {value = "PRESET_ALL_DAMAGERS", label = "All Damagers", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})				
				
				-- all healers
				tinsert (t, {value = "PRESET_ALL_HEALERS", label = "All Healers", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				-- tank damage taken
				tinsert (t, {value = "PRESET_TANK_TAKEN", label = "Tanks Damage Taken", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				-- already created data charts
				for index, capture in ipairs (_detalhes.savedTimeCaptures) do
					tinsert (t, {value = capture[1], icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}, label = capture[1], onclick = nil})
				end
				
				-- arena ally team damage
				tinsert (t, {value = "MULTICHARTS~Your Team Damage~Enemy Team Damage", label = "Arena Damage", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				tinsert (t, {value = "MULTICHARTS~Your Team Healing~Enemy Team Healing", label = "Arena Heal", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				return t
				
			elseif (type_dropdown.value == 2) then -- last 5
				
				local t = {}
				
				-- raid healing done
				tinsert (t, {value = "PRESET_PLAYER_HEAL", label = "Player Healing Done", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				tinsert (t, {value = "PRESET_RAID_HEAL", label = "Raid Healing Done", icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}})
				
				-- already created data charts
				for index, capture in ipairs (_detalhes.savedTimeCaptures) do
					tinsert (t, {value = capture[1], icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], iconsize = {14, 14}, label = capture[1], onclick = nil})
				end
				
				return t
				
			end
		
			return data_options
		end
		
		local data_dropdown = fw:CreateDropDown (panel, data_options_func, 1, 150, 20)
		data_dropdown:SetPoint ("left", data_label, "right", 2, 0)
		ChartViewer.data_dropdown = data_dropdown
		data_dropdown:SetTemplate (ChartViewer:GetFramework():GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		
	-- line texture
		--label
		local texture_label = fw:CreateLabel (panel, "Texture:")
		
		--dropdown
		local texture_options = {
			{value = "thinline", label = "Thin Line", icon = [[Interface\AddOns\Details\Libs\LibGraph-2.0\thinline]], iconcolor = {1, 1, 1}, iconsize = {30, 14}, texcoord = {0, 1, 0.3, 0.7}, onclick = nil},
			{value = "line", label = "Normal Line", icon = [[Interface\AddOns\Details\Libs\LibGraph-2.0\line]], iconcolor = {1, 1, 1}, iconsize = {30, 14}, texcoord = {0, 1, 0.3, 0.7}, onclick = nil},
			--{value = "sline", label = "Sline", desc = "", icon = [[Interface\AddOns\Details\Libs\LibGraph-2.0\sline]], iconcolor = {1, 1, 1}, iconsize = {130, 14}, texcoord = {0, 1, 0.3, 0.7}, onclick = nil},
			--{value = "smallline", label = "Small Line", desc = "", icon = [[Interface\AddOns\Details\Libs\LibGraph-2.0\smallline]], iconcolor = {1, 1, 1}, iconsize = {130, 14}, texcoord = {0, 1, 0.3, 0.7}, onclick = nil},
		}
		local texture_options_func = function()
			return texture_options
		end
		local texture_dropdown = fw:CreateDropDown (panel, texture_options_func, 1, 150, 20)
		texture_dropdown:SetPoint ("left", texture_label, "right", 2, 0)
		ChartViewer.texture_dropdown = texture_dropdown
		texture_dropdown:SetTemplate (ChartViewer:GetFramework():GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		
		local internal_options = {
			["MULTICHARTS~Your Team Damage~Enemy Team Damage"] = {colors = {["Your Team Damage"] = {1, 1, 1}, ["Enemy Team Damage"] = {1, 0.6, 0.2}}, iType = "arena-DAMAGER", name = "Arena Damage"},
			["MULTICHARTS~Your Team Healing~Enemy Team Healing"] = {colors = {["Your Team Healing"] = {1, 1, 1}, ["Enemy Team Healing"] = {1, 0.6, 0.2}}, iType = "arena-HEALER", name = "Arena Heal"},
			["PRESET_PLAYER_HEAL"] = {iType = "solo-HEALER", name = "Player Healing Done"},
			["PRESET_RAID_HEAL"] = {iType = "raid-HEALER", name = "Raid Healing Done"},
			["PRESET_TANK_TAKEN"] = {iType = "raid-TANK", name = "Tanks Damage Taken"},
			["PRESET_ALL_HEALERS"] = {iType = "raid-HEALER", name = "All Healers"},
			["PRESET_ALL_DAMAGERS"] = {iType = "raid-DAMAGER-all", name = "All Damagers"},
			["PRESET_HEAL_SAME_CLASS"] = {iType = "raid-HEALER", name = "Healing (Same Class)"},
			["PRESET_DAMAGE_SAME_CLASS"] = {iType = "raid-DAMAGER", name = "Damager (Same Class)"},
		}
		
		function ChartViewer:GetInternalOptionsForChart (preset_name)
			return internal_options [preset_name]
		end
	
		function ChartViewer:GetChartsForIType (iType, is_keyword)
			local t = {}
			if (is_keyword) then
				for preset_name, internal_options in pairs (internal_options) do
					if (internal_options.iType:find (iType)) then
						tinsert (t, preset_name)
					end
				end
			else
				for preset_name, internal_options in pairs (internal_options) do
					if (internal_options.iType == iType) then
						tinsert (t, preset_name)
					end
				end
			end
			return t
		end
	
	-- todo: smoothness process selection
	
	-- create button
		local create_func = function()
			local tab_name = name_textentry.text
			local tab_type = type_dropdown.value
			local tab_data = data_dropdown.value
			local tab_texture = texture_dropdown.value
			
			if (ChartViewer.NewTabPanel.editing) then
				ChartViewer.NewTabPanel.editing.texture = tab_texture
				ChartViewer.NewTabPanel.editing.name = tab_name
				ChartViewer:RefreshGraphic()
			else
				local extra_options = internal_options [tab_data]
				ChartViewer:CreateTab (tab_name, tab_type, tab_data, tab_texture, extra_options, data_dropdown.label:GetText())
			end
			
			panel:Hide()
		end
		local create_button = fw:CreateButton (panel, create_func, 86, 16, "Create")
		ChartViewer.create_button = create_button
		create_button:SetTemplate (ChartViewer:GetFramework():GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		
		local cancel_button = fw:CreateButton (panel, function() name_textentry:ClearFocus(); panel:Hide(); ChartViewer.NewTabPanel.editing = nil end, 86, 16, "Cancel")
		cancel_button:SetTemplate (ChartViewer:GetFramework():GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))

		create_button:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], nil, nil, nil, {0.125, 0.875, 0.125, 0.875}, nil, 4, 2)
		cancel_button:SetIcon ([[Interface\Buttons\UI-GroupLoot-Pass-Down]], nil, nil, nil, {0.125, 0.875, 0.125, 0.875}, nil, 4, 2)
	
	-- align
		local y = -26
		name_label:SetPoint ("topleft", panel, "topleft", x_start, y*2)
		type_label:SetPoint ("topleft", panel, "topleft", x_start, y*3)
		data_label:SetPoint ("topleft", panel, "topleft", x_start, y*4)
		texture_label:SetPoint ("topleft", panel, "topleft", x_start, y*5)
		
		create_button:SetPoint ("topleft", panel, "topleft", 10, y*7)
		cancel_button:SetPoint ("left", create_button, "right", 20, 0)
	
	ChartViewer.OpenAddTabPanel = function()
		ChartViewer.type_dropdown:Enable()
		ChartViewer.data_dropdown:Enable()
		ChartViewer.create_button.text = "Create"
		ChartViewer.name_textentry.text = "New Tab"
		ChartViewer.NewTabPanel.editing = nil
		panel:Show()
	end
end

function ChartViewer:OnEvent (_, event, ...)

	if (event == "ADDON_LOADED") then
		local AddonName = select (1, ...)
		if (AddonName == "Details_ChartViewer") then
			
			if (_G._detalhes) then

				--> register player damage done chart data
				ChartViewer:TimeDataRegister ("Player Damage Done", ChartViewer.PlayerDamageDoneChartCode, nil, "Chart Viewer", "1.0", [[Interface\ICONS\Ability_MeleeDamage]], true)
				
				--> create widgets
				CreatePluginFrames()

				local MINIMAL_DETAILS_VERSION_REQUIRED = 76
				
				--> Install
				local install, saveddata, is_enabled = _G._detalhes:InstallPlugin ("TOOLBAR", Loc ["STRING_PLUGIN_NAME"], [[Interface\Addons\Details_ChartViewer\icon]], ChartViewer, "DETAILS_PLUGIN_CHART_VIEWER", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", plugin_version)
				if (type (install) == "table" and install.error) then
					print (Loc ["STRING_PLUGIN_NAME"], install.errortext)
					return
				end
				-- /run DETAILS_PLUGIN_CHART_VIEWER:ShowButton()
				if (not saveddata.tabs) then
					--> first run
					local welcome = CreateFrame ("frame", nil, ChartViewerFrame, "BackdropTemplate")
					welcome:SetFrameStrata ("TOOLTIP")
					welcome:SetPoint ("center", ChartViewerFrame, "center")
					welcome:SetSize (300, 150)
					ChartViewer.welcome_panel = welcome
					welcome:Hide()
					welcome:SetBackdrop ({edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8,
					bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 130, insets = {left = 1, right = 1, top = 5, bottom = 5}})
					
					local str = _detalhes.gump:CreateLabel (welcome, "- Each tab shows a graphic.\n\n- Double click a tab to edit it.\n\n- Click on 'Add Chart' to create a new tab.\n\n- Press escape or right mouse button to close the panel.")
					str:SetPoint (15, -15)
					str:SetWidth (270)
					
					local close_button = _detalhes.gump:CreateButton (welcome, function() welcome:Hide() end, 86, 16, "Close")
					close_button:InstallCustomTexture()
					close_button:SetPoint ("center", welcome, "center")
					close_button:SetPoint ("bottom", welcome, "bottom", 0, 10)
				end
				
				--> detect 1.x versions
				if (saveddata.tabs and saveddata.tabs[1] and saveddata.tabs[1].captures) then
					table.wipe (saveddata.tabs)
				end

				--> build tab container
				saveddata.tabs = saveddata.tabs or {}
				saveddata.options = saveddata.options or {show_method = 4, window_scale = 1.0}
				if (saveddata.options.auto_create == nil) then
					saveddata.options.auto_create = true
				end
				
				ChartViewer.tabs = saveddata.tabs
				ChartViewer.options = saveddata.options
				
				ChartViewer.tabs.last_selected = ChartViewer.tabs.last_selected or 1
				
				ChartViewer.tab_container = {}
				
				if (#ChartViewer.tabs == 0) then
					ChartViewer.tabs [1] = {name = "Your Damage", segment_type = 2, data = "Player Damage Done", texture = "line", version = "v2.0"}
					ChartViewer.tabs [2] = {name = "Class Damage", segment_type = 1, data = "PRESET_DAMAGE_SAME_CLASS", texture = "line", version = "v2.0", iType = "raid-DAMAGER"}
					ChartViewer.tabs [3] = {name = "Raid Damage", segment_type = 2, data = "Raid Damage Done", texture = "line", version = "v2.0"}
				end
				
				--> register wow events
				CVF:RegisterEvent ("GROUP_ROSTER_UPDATE")
				CVF:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
				CVF:RegisterEvent ("PLAYER_ENTERING_WORLD")
				
				if (is_enabled) then
					ChartViewer:CanShowOrHideButton()
				else
					ChartViewer:HideButton()
				end
				
				--> register details events
				_G._detalhes:RegisterEvent (ChartViewer, "DETAILS_DATA_RESET")
				
				_G._detalhes:RegisterEvent (ChartViewer, "COMBAT_PLAYER_LEAVE")
				_G._detalhes:RegisterEvent (ChartViewer, "COMBAT_PLAYER_ENTER")
				
				_G._detalhes:RegisterEvent (ChartViewer, "COMBAT_CHARTTABLES_CREATING")
				_G._detalhes:RegisterEvent (ChartViewer, "COMBAT_CHARTTABLES_CREATED")
				
				create_segment_dropdown()
				create_add_tab_panel()
				create_add_tab_button()
				
				ChartViewer.current_segment = 1
				
				ChartViewer.NewTabPanel:Hide()
				
				--> replace the built-in frame with the outside frame
				ChartViewer.Frame = _G.ChartViewerWindowFrame
				
				--> embed the plugin into the plugin window
				if (DetailsPluginContainerWindow) then
					DetailsPluginContainerWindow.EmbedPlugin (ChartViewer, ChartViewerWindowFrame)
				end
				
				C_Timer.After (5, function()
					--> adjust the size of the chart frame
					local height = ChartViewerWindowFrame:GetHeight()
					ChartViewerWindowFrameChartFrame:SetSize (ChartViewerWindowFrame:GetWidth()-20, height-100)
				
					--ChartViewerWindowFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
					--ChartViewerWindowFrame:SetBackdropColor (0.2, 0.2, 0.2, .6)
					--ChartViewerWindowFrame:SetBackdropBorderColor (0, 0, 0, 1)
					
				--title bar
					local titlebar = CreateFrame ("frame", nil, ChartViewerWindowFrame, "BackdropTemplate")
					titlebar:SetPoint ("topleft", ChartViewerWindowFrame, "topleft", 2, -3)
					titlebar:SetPoint ("topright", ChartViewerWindowFrame, "topright", -2, -3)
					titlebar:SetHeight (20)
					titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
					titlebar:SetBackdropColor (.5, .5, .5, 1)
					titlebar:SetBackdropBorderColor (0, 0, 0, 1)

					local name_bg_texture = ChartViewerWindowFrame:CreateTexture (nil, "background")
					name_bg_texture:SetTexture ([[Interface\PetBattles\_PetBattleHorizTile]], true)
					name_bg_texture:SetHorizTile (true)
					name_bg_texture:SetTexCoord (0, 1, 126/256, 19/256)
					name_bg_texture:SetPoint ("topleft", ChartViewerWindowFrame, "topleft", 2, -22)
					name_bg_texture:SetPoint ("bottomright", ChartViewerWindowFrame, "bottomright")
					name_bg_texture:SetHeight (54)
					name_bg_texture:SetVertexColor (0, 0, 0, 0.2)
				
				--window title
					local titleLabel = _detalhes.gump:NewLabel (titlebar, titlebar, nil, "titulo", "Chart Viewer", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
					titleLabel:SetPoint ("center", ChartViewerWindowFrame, "center")
					titleLabel:SetPoint ("top", ChartViewerWindowFrame, "top", 0, -7)
				
				--close button
					
					
				end)
			end
		end

	elseif (ChartViewer.CanShowOrHideButtonEvents [event]) then
		ChartViewer:CanShowOrHideButton()		
		
	end
end

local add_preset_player_healind_done = function()
	local code = [[
	local current_combat = _detalhes:GetCombat ("current")
	local my_self = current_combat (2, _detalhes.playername)
	return my_self and my_self.total or 0
	]]
	_detalhes:TimeDataRegister ("PRESET_PLAYER_HEAL~" .. _detalhes.playername, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
end

local add_preset_raid_healind_done = function()
	local code = [[
	local current_combat = _detalhes:GetCombat ("current")
	local total_healing = current_combat:GetTotal ( DETAILS_ATTRIBUTE_HEAL, nil, DETAILS_TOTALS_ONLYGROUP )
	return total_healing or 0]]
	_detalhes:TimeDataRegister ("PRESET_RAID_HEAL~Raid Healing Done", code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
end

local add_preset_damage_same_class = function()
	if (IsInRaid()) then
		local _, class = UnitClass ("player")
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class2, class1, zone, online, isDead, _, isML, role = GetRaidRosterInfo (i)
			if (class == class1) then

				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				--even my self
				local code = [[
				local current_combat = _detalhes:GetCombat ("current")
				local my_self = current_combat (1, "PLAYERNAME")
				return my_self and my_self.total or 0]]
				code = code:gsub ("PLAYERNAME", playerName)
				_detalhes:TimeDataRegister ("PRESET_DAMAGE_SAME_CLASS~" .. playerName, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
			end
		end
	end
end

local add_preset_heal_same_class = function()
	if (IsInRaid()) then
		local _, class = UnitClass ("player")
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class2, class1, zone, online, isDead, _, isML, role = GetRaidRosterInfo (i)
			if (class == class1) then
				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				--even my self
				local code = [[
				local current_combat = _detalhes:GetCombat ("current")
				local my_self = current_combat (2, "PLAYERNAME")
				return my_self and my_self.total or 0]]
				code = code:gsub ("PLAYERNAME", playerName)
				_detalhes:TimeDataRegister ("PRESET_HEAL_SAME_CLASS~" .. playerName, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
			end
		end
	end
end

local add_preset_all_damagers = function()
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class2, class1, zone, online, isDead, _, isML, role = GetRaidRosterInfo (i)
			if (role == "DAMAGER") then
				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				--even my self
				local code = [[
				local current_combat = _detalhes:GetCombat ("current")
				local my_self = current_combat (1, "PLAYERNAME")
				return my_self and my_self.total or 0]]
				code = code:gsub ("PLAYERNAME", playerName)
				_detalhes:TimeDataRegister ("PRESET_ALL_DAMAGERS~" .. playerName, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
			end
		end
	end
end

local add_preset_all_healers = function()
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class2, class1, zone, online, isDead, _, isML, role = GetRaidRosterInfo (i)
			if (role == "HEALER") then
				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				--even my self
				local code = [[
				local current_combat = _detalhes:GetCombat ("current")
				local my_self = current_combat (2, "PLAYERNAME")
				return my_self and my_self.total or 0]]
				code = code:gsub ("PLAYERNAME", playerName)
				_detalhes:TimeDataRegister ("PRESET_ALL_HEALERS~" .. playerName, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
			end
		end
	end
end

local add_preset_tank_damage_taken = function()
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class2, class1, zone, online, isDead, _, isML, role = GetRaidRosterInfo (i)
		
			if (role == "TANK") then
				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
			
				--even my self
				local code = [[
				local current_combat = _detalhes:GetCombat ("current")
				local my_self = current_combat (1, "PLAYERNAME")
				return my_self and my_self.damage_taken or 0]]
				code = code:gsub ("PLAYERNAME", playerName)
				_detalhes:TimeDataRegister ("PRESET_TANK_TAKEN~" .. playerName, code, nil, "Chart Viewer 2.0", "v1.0", [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], true, true)
			end
		end
	end
end

function ChartViewer:BuildAndAddPresetFunction (preset_name)
	
	if (preset_name == "PRESET_PLAYER_HEAL") then
		add_preset_player_healind_done()
		
	elseif (preset_name == "PRESET_RAID_HEAL") then
		add_preset_raid_healind_done()
		
	elseif (preset_name == "PRESET_DAMAGE_SAME_CLASS") then
		add_preset_damage_same_class()
		
	elseif (preset_name == "PRESET_HEAL_SAME_CLASS") then
		add_preset_heal_same_class()
		
	elseif (preset_name == "PRESET_ALL_DAMAGERS") then
		add_preset_all_damagers()
		
	elseif (preset_name == "PRESET_ALL_HEALERS") then
		add_preset_all_healers()
		
	elseif (preset_name == "PRESET_TANK_TAKEN") then
		add_preset_tank_damage_taken()
	
	end
	
end


--> player damage done chart code
ChartViewer.PlayerDamageDoneChartCode = [[

	-- the goal of this script is get the current combat then get your character and extract your damage done.
	-- the first thing to do is get the combat, so, we use here the command "_detalhes:GetCombat ( "overall" "current" or "segment number")"
	
	local current_combat = _detalhes:GetCombat ("current") --> getting the current combat
	
	-- the next step is request your character from the combat
	-- to do this, we take the combat which here we named "current_combat" and tells what we want inside parentheses.
	
	local my_self = current_combat (DETAILS_ATTRIBUTE_DAMAGE, _detalhes.playername)
	
	-- _detalhes.playername holds the name of your character.
	-- DETAILS_ATTRIBUTE_DAMAGE means we want the damage table, _HEAL _ENERGY _MISC is the other 3 tables.
	
	-- before we proceed, the result needs to be checked to make sure its a valid result.
	
	if (not my_self) then
		return 0 -- the combat doesnt have *you*, this happens when you didn't deal any damage in the combat yet.
	end
	
	-- now its time to get the total damage.
	
	local my_damage = my_self.total
	
	-- then finally return the amount to the capture.
	
	return my_damage
	
]]

ChartViewer.DataFeedTemplatesByIndex = {
	"Raid Damage Taken", "Raid Healing Done", "Raid Overheal"
}

ChartViewer.DataFeedTemplates = {
["Raid Damage Taken"] = [[ -- this script takes the current combat and get the total of damage taken by the group.
local damage_taken = 0

--get the raid players on current combat
local players = _detalhes:GetActorsOnDamageCache()

--add the damage taken from each player
for _, player in ipairs (players) do
	damage_taken = damage_taken + player.damage_taken
end

--return the value
return damage_taken
]],

["Raid Healing Done"] = [[ -- this script takes the current combat and request the total of healing done by the group.
-- get the current combat
local current_combat = _detalhes:GetCombat ("current")

-- get the total healing done from the combat
local total_healing = current_combat:GetTotal ( DETAILS_ATTRIBUTE_HEAL, nil, DETAILS_TOTALS_ONLYGROUP )

-- check if the result is valid
if (not total_healing) then
	return 0
else
	-- return the value
	return total_healing
end
]],

["Raid Overheal"] = [[ -- this script get the total of overheal from the raid.
local overheal = 0

--get the raid players on current combat
local players = _detalhes:GetActorsOnHealingCache()

--add the overheal from each player
for _, player in ipairs (players) do
	overheal = overheal + player.totalover
end

--return the value
return overheal
]]
}

ChartViewer.PlayerIndividualChartCode = [[
	local current_combat = _detalhes:GetCombat ("current") --> getting the current combat
	local my_self = current_combat (DETAILS_ATTRIBUTE_DAMAGE, UnitName ("player"))
	if (not my_self) then
		return 0
	end
	local my_damage = my_self.total
	return my_damage or 0
]]
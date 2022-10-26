local Details = Details
local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )

local gump = Details.gump
local _

--lua locals
local unpack = unpack
local floor = math.floor
local gameCooltip = GameCooltip

--api locals
do
	local bookmarkFrame = CreateFrame("frame", "DetailsSwitchPanel", UIParent,"BackdropTemplate")
	bookmarkFrame:SetPoint("center", UIParent, "center", 500, -300)
	bookmarkFrame:SetWidth(250)
	bookmarkFrame:SetHeight(100)
	bookmarkFrame:SetFrameStrata("FULLSCREEN")
	bookmarkFrame:SetFrameLevel(16)
	bookmarkFrame.editing_window = nil

	DetailsFramework:ApplyStandardBackdrop(bookmarkFrame, true)
	bookmarkFrame:SetBackdropBorderColor(0, 0, 0, 0)

	local backgroundGradientTexture = DetailsFramework:CreateTexture(bookmarkFrame, {gradient = "vertical", fromColor = {0, 0, 0, 0.2}, toColor = {0, 0, 0, 0.4}}, 1, 1, "artwork", {0, 1, 0, 1})
	backgroundGradientTexture:SetAllPoints()

	bookmarkFrame.HoverOverBackground = {.6, .6, .6, .2}
	bookmarkFrame.hoverOverTexture = bookmarkFrame:CreateTexture(nil, "border")
	bookmarkFrame.hoverOverTexture:SetTexture(unpack(bookmarkFrame.HoverOverBackground))
	bookmarkFrame.hoverOverTexture:SetSize(130, 18)
	bookmarkFrame.hoverOverTexture:Hide()

	--~all
	local allDisplaysFrame = CreateFrame("frame", "DetailsAllAttributesFrame", UIParent,"BackdropTemplate")
	allDisplaysFrame:SetFrameStrata("tooltip")
	allDisplaysFrame:Hide()
	allDisplaysFrame:SetSize(600, 150)
	allDisplaysFrame:SetClampedToScreen(true)
	allDisplaysFrame.buttons = {}

	DetailsFramework:ApplyStandardBackdrop(allDisplaysFrame)
	allDisplaysFrame.BackgroundGradientTexture = DetailsFramework:CreateTexture(allDisplaysFrame, {gradient = "vertical", fromColor = "transparent", toColor = {0, 0, 0, 0.2}}, 1, 1, "artwork", {0, 1, 0, 1})
	allDisplaysFrame.BackgroundGradientTexture:SetAllPoints()

	allDisplaysFrame:SetScript("OnMouseDown", function(self, button)
		if (button == "RightButton") then
			self:Hide()
		end
	end)

	allDisplaysFrame:SetScript("OnEnter", function(self, button)
		allDisplaysFrame.interacting = true
		allDisplaysFrame.last_up = GetTime()
	end)

	allDisplaysFrame:SetScript("OnLeave", function(self, button)
		allDisplaysFrame.interacting = false
		allDisplaysFrame.last_up = GetTime()
	end)

	local on_update_all_switch = function(self, elapsed)
		if (not self.interacting) then
			if (GetTime() > allDisplaysFrame.last_up + 2) then
				local cursorX, cursorY = GetCursorPosition()
				cursorX, cursorY = floor(cursorX), floor(cursorY)
				if (allDisplaysFrame.cursor_x ~= cursorX or allDisplaysFrame.cursor_y ~= cursorY) then
					self:Hide()
				else
					allDisplaysFrame.last_up = GetTime() - 1
				end
			end
		end
	end

	allDisplaysFrame:SetScript("OnHide", function(self)
		allDisplaysFrame:SetScript("OnUpdate", nil)
	end)

	DetailsSwitchPanel.all_switch = allDisplaysFrame

	function Details:ShowAllSwitch()
		if (allDisplaysFrame:IsShown()) then
			return allDisplaysFrame:Hide()
		end

		allDisplaysFrame.instance = self
		GameTooltip:Hide()
		gameCooltip:Hide()
		allDisplaysFrame:ClearAllPoints()
		allDisplaysFrame:SetPoint("bottom", self.baseframe.UPFrame, "top", 4)

		allDisplaysFrame:Show()

		if (Details.switch.frame:IsShown()) then
			Details.switch:CloseMe()
		end
	end

	local on_click_all_switch_button = function(self, button)
		if (button == "LeftButton") then
			local attribute = self.attribute
			local subAttribute = self.sub_attribute
			local instance = allDisplaysFrame.instance

			--check if is a plugin button
			if (self.isPlugin) then
				if (Details.RaidTables.NameTable[self.pluginName]) then
					Details.RaidTables:EnableRaidMode(instance, self.pluginName)
				elseif (Details.SoloTables.NameTable [self.pluginName]) then
					Details.SoloTables:EnableSoloMode(instance, self.pluginName)
				else
					Details:Msg("Plugin not found.")
				end

				allDisplaysFrame:Hide()
				return
			end

			if (instance.modo == Details._detalhes_props["MODO_ALONE"] or instance.modo == Details._detalhes_props["MODO_RAID"]) then
				instance:AlteraModo(instance, 2)
			end

			instance:TrocaTabela(instance, true, attribute, subAttribute)
			allDisplaysFrame:Hide()

		elseif (button == "RightButton") then
			allDisplaysFrame:Hide()
		end
	end

	local hoverOverTexture = allDisplaysFrame:CreateTexture(nil, "border")
	hoverOverTexture:SetTexture(unpack(DetailsSwitchPanel.HoverOverBackground))
	hoverOverTexture:SetSize(130, 18)
	hoverOverTexture:Hide()

	local icon_size = 16
	local text_color = {.9, .9, .9, 1}

	local on_enter_all_switch_button = function(self)
		Details:SetFontColor(self.text, "orange")
		allDisplaysFrame.interacting = true
		allDisplaysFrame.last_up = GetTime()

		hoverOverTexture:SetSize(130, 18)
		hoverOverTexture:ClearAllPoints()
		hoverOverTexture:SetPoint("topleft", self, "topleft", -2, 1)
		hoverOverTexture:Show()
	end

	local on_leave_all_switch_button = function(self)
		Details:SetFontColor(self.text, text_color)
		allDisplaysFrame.interacting = false
		allDisplaysFrame.last_up = GetTime()
		hoverOverTexture:Hide()
	end

	local on_enter_all_switch_button_icon = function(self)
		self.MainFrame.texture:SetBlendMode("ADD")
		on_enter_all_switch_button(self.MainFrame)
	end
	local on_leave_all_switch_button_icon = function(self)
		self.MainFrame.texture:SetBlendMode("BLEND")
		on_leave_all_switch_button(self.MainFrame)
	end
	
	allDisplaysFrame.check_text_size = function(font_string)
		local text_width = font_string:GetStringWidth()
		while (text_width > 104) do
			local text = font_string:GetText()
			text = strsub (text, 1, #text-1)
			font_string:SetText(text)
			text_width = font_string:GetStringWidth()
		end
	end
	
	local create_all_switch_button = function(attribute, sub_attribute, x, y)
		local button = CreateFrame("button", "DetailsAllAttributesFrame" .. attribute .. sub_attribute, allDisplaysFrame)
		button:SetSize(130, 16)
		button.texture = button:CreateTexture(nil, "overlay")
		button.texture:SetPoint("left", 0, 0)
		button.texture:SetSize(icon_size, icon_size)
		
		local texture_highlight_frame = CreateFrame("button", "DetailsAllAttributesFrame" .. attribute .. sub_attribute .. "IconFrame", button)
		texture_highlight_frame:SetSize(icon_size, icon_size)
		texture_highlight_frame:SetPoint("left", 0, 0)
		texture_highlight_frame.texture = button.texture
		texture_highlight_frame.MainFrame = button
		
		button.text = button:CreateFontString(nil, "overlay", "GameFontNormal")
		button.text:SetPoint("left", button.texture, "right", 2, 0)
		button.attribute = attribute
		button.sub_attribute = sub_attribute
		button:SetPoint("topleft", x, y)
		Details:SetFontSize(button.text, Details.all_switch_config.font_size)
		Details:SetFontColor(button.text, text_color)
		
		button:SetScript("OnClick", on_click_all_switch_button)
		button:SetScript("OnEnter", on_enter_all_switch_button)
		button:SetScript("OnLeave", on_leave_all_switch_button)
		
		texture_highlight_frame:SetScript("OnClick", on_click_all_switch_button)
		texture_highlight_frame:SetScript("OnEnter", on_enter_all_switch_button_icon)
		texture_highlight_frame:SetScript("OnLeave", on_leave_all_switch_button_icon)
		
		button:RegisterForClicks ("LeftButtonDown", "RightButtonDown")

		return button
	end
	
	allDisplaysFrame:SetScript("OnShow", function()
		
		if (not allDisplaysFrame.already_built) then
			local x, y = 8, -8
			allDisplaysFrame.higher_counter = 0

			for attribute = 1, Details.atributos[0] do
				--localized attribute name
				local loc_attribute_name = Details.atributos.lista [attribute]

				local title_icon = allDisplaysFrame:CreateTexture(nil, "overlay")
				title_icon:SetPoint("topleft", x, y)
				local texture, l, r, t, b = Details:GetAttributeIcon (attribute)
				title_icon:SetTexture(texture)
				title_icon:SetTexCoord(l, r, t, b)
				title_icon:SetSize(18, 18)
				local title_str = allDisplaysFrame:CreateFontString(nil, "overlay", "GameFontNormal")
				title_str:SetPoint("left", title_icon, "right", 2, 0)
				title_str:SetText(loc_attribute_name)
				
				y = y - 20
				
				allDisplaysFrame.buttons [attribute] = {}
				for i = 1, #Details.sub_atributos [attribute].lista do
					--localized sub attribute name
					local loc_sub_attribute_name = Details.sub_atributos [attribute].lista [i]
					local button = create_all_switch_button (attribute, i, x, y)

					button.text:SetText(loc_sub_attribute_name)
					Details:SetFontSize(button.text, Details.all_switch_config.font_size)

					allDisplaysFrame.check_text_size (button.text)
					button.texture:SetTexture(Details.sub_atributos [attribute].icones [i] [1])
					button.texture:SetTexCoord(unpack(Details.sub_atributos [attribute].icones [i] [2]))
					tinsert(allDisplaysFrame.buttons [attribute], button)
					y = y - 17
				end
				
				if (#Details.sub_atributos [attribute].lista > allDisplaysFrame.higher_counter) then
					allDisplaysFrame.higher_counter = #Details.sub_atributos [attribute].lista
				end
				
				x = x + 130
				y = -8
			end
			
			--prepare for scripts
			allDisplaysFrame.x = x
			allDisplaysFrame.y = -8
			allDisplaysFrame.buttons [Details.atributos[0]+1] = {}
			
			local title_icon = allDisplaysFrame:CreateTexture(nil, "overlay")
			local texture, l, r, t, b = Details:GetAttributeIcon (Details.atributos[0]+1)
			title_icon:SetTexture([[Interface\AddOns\Details\images\icons]])
			title_icon:SetTexCoord(412/512, 441/512, 43/512, 79/512)
			title_icon:SetVertexColor(.7, .6, .5, 1)
			title_icon:SetSize(16, 16)
			local title_str = allDisplaysFrame:CreateFontString(nil, "overlay", "GameFontNormal")
			title_str:SetPoint("left", title_icon, "right", 2, 0)
			title_str:SetText("Scripts")
			
			title_icon:SetPoint("topleft", allDisplaysFrame.x, allDisplaysFrame.y)
			allDisplaysFrame.y = allDisplaysFrame.y - 20
			allDisplaysFrame.title_custom = title_icon
			
			allDisplaysFrame.already_built = true

			--prepare for plugins
				allDisplaysFrame.buttons[6] = {}
				local title_icon = allDisplaysFrame:CreateTexture(nil, "overlay")
				title_icon:SetTexture([[Interface\AddOns\Details\images\modo_icones]])
				title_icon:SetTexCoord(32/256*3, 32/256*4, 0, 1)
				title_icon:SetSize(16, 16)

				local title_str = allDisplaysFrame:CreateFontString(nil, "overlay", "GameFontNormal")
				title_str:SetPoint("left", title_icon, "right", 2, 0)
				title_str:SetText(Loc["STRING_OPTIONS_PLUGINS"])
				title_icon:SetPoint("topleft", allDisplaysFrame.x + 130, -8)
				allDisplaysFrame.title_scripts = title_icon
		end
		
		--update scripts
		local custom_index = Details.atributos[0]+1
		for _, button in ipairs(allDisplaysFrame.buttons [custom_index]) do
			button:Hide()
		end
		
		local button_index = 1
		for i = #Details.custom, 1, -1 do
			local button = allDisplaysFrame.buttons [custom_index] [button_index]
			if (not button) then
				button = create_all_switch_button (custom_index, i, allDisplaysFrame.x, allDisplaysFrame.y)
				tinsert(allDisplaysFrame.buttons [custom_index], button)
				allDisplaysFrame.y = allDisplaysFrame.y - 17
			end
			
			local custom = Details.custom [i]
			button.text:SetText(custom.name)
			Details:SetFontSize(button.text, Details.all_switch_config.font_size)

			allDisplaysFrame.check_text_size (button.text)
			button.texture:SetTexture(custom.icon)
			button.texture:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)
			button:Show()
			
			button_index = button_index + 1
		end
		
		if (#Details.custom > allDisplaysFrame.higher_counter) then
			allDisplaysFrame.higher_counter = #Details.custom
		end

		--update plugins
			local script_index = Details.atributos[0]+2
			local button_index = 1
			allDisplaysFrame.x = allDisplaysFrame.x + 130
			allDisplaysFrame.y = -28

			for _, button in ipairs(allDisplaysFrame.buttons[script_index]) do
				button:Hide()
			end

			--build raid plugins list
			local raidPlugins = Details.RaidTables:GetAvailablePlugins()
			if (#raidPlugins >= 0) then
				for i, ptable in ipairs(raidPlugins) do
					--if a plugin has the member 'NoMenu', it won't be shown on menus to select plugins
					if (ptable[3].__enabled and not ptable[3].NoMenu) then
						--PluginName, PluginIcon, PluginObject, PluginAbsoluteName
						local button = allDisplaysFrame.buttons [script_index] [button_index]
						if (not button) then
							button = create_all_switch_button(script_index, button_index, allDisplaysFrame.x, allDisplaysFrame.y)
							tinsert(allDisplaysFrame.buttons [script_index], button)
							allDisplaysFrame.y = allDisplaysFrame.y - 17
						end

						--set the button to select the plugin
						button.isPlugin = true
						button.pluginName = ptable[4]

						button.text:SetText(ptable[1])
						Details:SetFontSize(button.text, Details.all_switch_config.font_size)
						
						allDisplaysFrame.check_text_size(button.text)
						button.texture:SetTexture(ptable[2])
						button.texture:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)
						button:Show()
						
						button_index = button_index + 1
					end
				end
			end

		--check if the plugins list is the biggest list
		button_index = button_index - 1
		if (button_index > allDisplaysFrame.higher_counter) then
			allDisplaysFrame.higher_counter = button_index
		end

		allDisplaysFrame:SetHeight((allDisplaysFrame.higher_counter * 17) + 20 + 16)
		allDisplaysFrame:SetWidth((120 * 6) + (6 * 2) + (12 * 4))

		allDisplaysFrame.last_up = GetTime()
		local cursorX, cursorY = GetCursorPosition()
		allDisplaysFrame.cursor_x, allDisplaysFrame.cursor_y = floor(cursorX), floor(cursorY)
		allDisplaysFrame:SetScript("OnUpdate", on_update_all_switch)
		allDisplaysFrame:SetScale(Details.all_switch_config.scale)
	end)


---------------------------------------------------------------------------------------------------------------------------

	--animation has been disabled (July 2019)
	--they aren't called anymore on showing and hiding the bookmark frame
	--show animation
	local animHub = Details.gump:CreateAnimationHub (bookmarkFrame, function() bookmarkFrame:Show() end)
	Details.gump:CreateAnimation(animHub, "scale", 1, 0.04, 0, 1, 1, 1, "LEFT", 0, 0)
	Details.gump:CreateAnimation(animHub, "alpha", 1, 0.04, 0, 1)
	bookmarkFrame.ShowAnimation = animHub

	--hide animation
	local animHub = Details.gump:CreateAnimationHub (bookmarkFrame, function() bookmarkFrame:Show() end, function() bookmarkFrame:Hide() end)
	Details.gump:CreateAnimation(animHub, "scale", 1, 0.04, 1, 1, 0, 1, "RIGHT", 0, 0)
	Details.gump:CreateAnimation(animHub, "alpha", 1, 0.04, 1, 0)
	bookmarkFrame.HideAnimation = animHub

---------------------------------------------------------------------------------------------------------------------------
	function Details.switch:CloseMe()
		Details.switch.frame:Hide()
		Details.switch.frame:ClearAllPoints()

		gameCooltip:Hide()
		Details.switch.current_instancia:StatusBarAlert(nil)
		Details.switch.current_instancia = nil
	end

	bookmarkFrame.close = gump:NewDetailsButton(bookmarkFrame, bookmarkFrame, _, function() end, nil, nil, 1, 1, "", "", "", "", {rightFunc = {func = Details.switch.CloseMe, param1 = nil, param2 = nil}}, "DetailsSwitchPanelClose")
	bookmarkFrame.close:SetPoint("topleft", bookmarkFrame, "topleft")
	bookmarkFrame.close:SetPoint("bottomright", bookmarkFrame, "bottomright")
	bookmarkFrame.close:SetFrameLevel(9)
	bookmarkFrame:Hide()

	Details.switch.frame = bookmarkFrame
	Details.switch.button_height = 24
end

Details.switch.buttons = {}
Details.switch.slots = Details.switch.slots or 6
Details.switch.showing = 0
Details.switch.table = Details.switch.table or {}
Details.switch.current_instancia = nil
Details.switch.current_button = nil
Details.switch.height_necessary = (Details.switch.button_height * Details.switch.slots) / 2

function Details.switch:HideAllBookmarks()
	for _, bookmark in ipairs(Details.switch.buttons) do
		bookmark:Hide()
	end
end

function Details.switch:ShowMe(instancia)
	Details.switch.current_instancia = instancia

	if (IsControlKeyDown()) then
		if (not Details.tutorial.ctrl_click_close_tutorial) then
			if (not DetailsCtrlCloseWindowPanelTutorial) then
				local tutorialFrame = CreateFrame("frame", "DetailsCtrlCloseWindowPanelTutorial", Details.switch.frame, "BackdropTemplate")
				tutorialFrame:SetFrameStrata("FULLSCREEN_DIALOG")
				tutorialFrame:SetAllPoints()
				tutorialFrame:EnableMouse(true)
				tutorialFrame:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
				tutorialFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)

				tutorialFrame.info_label = tutorialFrame:CreateFontString(nil, "overlay", "GameFontNormal")
				tutorialFrame.info_label:SetPoint("topleft", tutorialFrame, "topleft", 10, -10)
				tutorialFrame.info_label:SetText(Loc["STRING_MINITUTORIAL_CLOSECTRL1"])
				tutorialFrame.info_label:SetJustifyH("left")

				tutorialFrame.mouse = tutorialFrame:CreateTexture(nil, "overlay")
				tutorialFrame.mouse:SetTexture([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]])
				tutorialFrame.mouse:SetTexCoord(0.0019531, 0.1484375, 0.6269531, 0.8222656)
				tutorialFrame.mouse:SetSize(20, 22)
				tutorialFrame.mouse:SetPoint("topleft", tutorialFrame.info_label, "bottomleft", -3, -10)

				tutorialFrame.close_label = tutorialFrame:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
				tutorialFrame.close_label:SetPoint("left", tutorialFrame.mouse, "right", 4, 0)
				tutorialFrame.close_label:SetText(Loc["STRING_MINITUTORIAL_CLOSECTRL2"])
				tutorialFrame.close_label:SetJustifyH("left")

				local checkbox = CreateFrame("CheckButton", "DetailsCtrlCloseWindowPanelTutorialCheckBox", tutorialFrame, "ChatConfigCheckButtonTemplate")
				checkbox:SetPoint("topleft", tutorialFrame.mouse, "bottomleft", -1, -5)
				_G[checkbox:GetName().."Text"]:SetText(Loc["STRING_MINITUTORIAL_BOOKMARK4"])

				tutorialFrame:SetScript("OnMouseDown", function()
					if (checkbox:GetChecked()) then
						Details.tutorial.ctrl_click_close_tutorial = true
					end

					tutorialFrame:Hide()
					if (instancia:IsEnabled()) then
						return instancia:ShutDown()
					end
				end)
			end

			DetailsCtrlCloseWindowPanelTutorial:Show()
			DetailsCtrlCloseWindowPanelTutorial.info_label:SetWidth(Details.switch.frame:GetWidth()-30)
			DetailsCtrlCloseWindowPanelTutorial.close_label:SetWidth(Details.switch.frame:GetWidth()-30)

			Details.switch.frame:SetPoint("topleft", instancia.baseframe, "topleft", 0, 1)
			Details.switch.frame:SetPoint("bottomright", instancia.baseframe, "bottomright", 0, 1)
			Details.switch.frame:Show()
			return
		end

		return instancia:ShutDown()

	elseif (IsShiftKeyDown()) then
		if (not Details.switch.segments_blocks) then
			local segment_switch = function(self, button, segment)
				if (button == "LeftButton") then
					Details.switch.current_instancia:TrocaTabela(segment)
					Details.switch.CloseMe()
				elseif (button == "RightButton") then
					Details.switch.CloseMe()
				end
			end
			
			local hide_label = function(self)
				self.texture:Hide()
				self.button:Hide()
				self.background:Hide()
				self:Hide()
			end
			
			local show_label = function(self)
				self.texture:Show()
				self.button:Show()
				self.background:Show()
				self:Show()
			end
			
			local on_enter = function(self)
				--self.MyObject.this_background:SetBlendMode("ADD")
				--self.MyObject.boss_texture:SetBlendMode("ADD")
			end
			
			local on_leave = function(self)
				self.MyObject.this_background:SetBlendMode("BLEND")
				self.MyObject.boss_texture:SetBlendMode("BLEND")
			end
		
			function Details.switch:CreateSegmentBlock()
				local s = gump:CreateLabel(Details.switch.frame)
				Details:SetFontSize(s, 9)
				
				local index = #Details.switch.segments_blocks
				if (index == 1) then --overall button
					index = -1
				elseif (index >= 2) then
					index = index - 1
				end
				
				local button = gump:CreateButton(Details.switch.frame, segment_switch, 100, 20, "", index)
				button:SetPoint("topleft", s, "topleft", -17, 0)
				button:SetPoint("bottomright", s, "bottomright", 0, 0)
				button:SetClickFunction(segment_switch, nil, nil, "right")

				local boss_texture = gump:CreateImage(button, nil, 16, 16)
				boss_texture:SetPoint("right", s, "left", -2, 0)

				local background = button:CreateTexture(nil, "background")
				background:SetTexture("Interface\\SPELLBOOK\\Spellbook-Parts")
				background:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)
				background:SetWidth(85)
				background:SetPoint("topleft", s.widget, "topleft", -16, 3)
				background:SetPoint("bottomright", s.widget, "bottomright", -3, -5)
				
				button.this_background = background
				button.boss_texture = boss_texture.widget
				
				s.texture = boss_texture
				s.button = button
				s.background = background
				
				button:SetScript("OnEnter", on_enter)
				button:SetScript("OnLeave", on_leave)
				
				s.HideMe = hide_label
				s.ShowMe = show_label
				
				tinsert(Details.switch.segments_blocks, s)
				return s
			end
			
			function Details.switch:GetSegmentBlock (index)
				local block = Details.switch.segments_blocks [index]
				if (not block) then
					return Details.switch:CreateSegmentBlock()
				else
					return block
				end
			end
			
			function Details.switch:ClearSegmentBlocks()
				for _, block in ipairs(Details.switch.segments_blocks) do
					block:HideMe()
				end
			end
			
			function Details.switch:ResizeSegmentBlocks()

				local x = 7
				local y = 5
				
				local window_width, window_height = Details.switch.current_instancia:GetSize()
				
				local horizontal_amt = floor(math.max(window_width / 100, 2))
				local vertical_amt = floor((window_height - y) / 20)
				local size = window_width / horizontal_amt
				
				local frame = Details.switch.frame
				
				Details.switch:ClearSegmentBlocks()
				
				local i = 1
				for vertical = 1, vertical_amt do
					x = 7
					for horizontal = 1, horizontal_amt do
						local button = Details.switch:GetSegmentBlock (i)
						
						button:SetPoint("topleft", frame, "topleft", x + 16, -y)
						button:SetSize(size - 22, 12)
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
		
			Details.switch.segments_blocks = {}

			--current and overall
			Details.switch:CreateSegmentBlock()
			Details.switch:CreateSegmentBlock()
			
			local block1 = Details.switch:GetSegmentBlock (1)
			block1:SetText(Loc["STRING_CURRENTFIGHT"])
			block1.texture:SetTexture([[Interface\Scenarios\ScenariosParts]])
			block1.texture:SetTexCoord(55/512, 81/512, 368/512, 401/512)
			
			local block2 = Details.switch:GetSegmentBlock (2)
			block2:SetText(Loc["STRING_SEGMENT_OVERALL"])
			block2.texture:SetTexture([[Interface\Scenarios\ScenariosParts]])
			block2.texture:SetTexCoord(55/512, 81/512, 368/512, 401/512)
		end
		
		Details.switch:ClearSegmentBlocks()
		Details.switch:HideAllBookmarks()
		
		local segment_index = 1
		for i = 3, #Details.tabela_historico.tabelas + 2 do
		
			local combat = Details.tabela_historico.tabelas [segment_index]
		
			local block = Details.switch:GetSegmentBlock (i)
			local enemy, color, raid_type, killed, is_trash, portrait, background, background_coords = Details:GetSegmentInfo (segment_index)

			block:SetText("#" .. segment_index .. " " .. enemy)
			
			if (combat.is_boss and combat.instance_type == "raid") then
				local L, R, T, B, Texture = Details:GetBossIcon (combat.is_boss.mapid, combat.is_boss.index)
				if (L) then
					block.texture:SetTexture(Texture)
					block.texture:SetTexCoord(L, R, T, B)
				else
					block.texture:SetTexture([[Interface\Scenarios\ScenarioIcon-Boss]])
				end
			else
				block.texture:SetTexture([[Interface\Scenarios\ScenarioIcon-Boss]])
			end
			
			block:ShowMe()
			segment_index = segment_index + 1
		end
		
		Details.switch.frame:SetScale(instancia.window_scale)
		Details.switch:ResizeSegmentBlocks()
		
		for i = segment_index+2, #Details.switch.segments_blocks do
			Details.switch.segments_blocks [i]:HideMe()
		end
		
		Details.switch.frame:SetPoint("topleft", instancia.baseframe, "topleft", 0, 1)
		Details.switch.frame:SetPoint("bottomright", instancia.baseframe, "bottomright", 0, 1)
		Details.switch.frame:Show()
		
		return
		
	else
		if (Details.switch.segments_blocks) then
			Details.switch:ClearSegmentBlocks()
		end
	end
	
	--check if there is some custom contidional
	if (instancia.atributo == 5) then
		local custom_object = instancia:GetCustomObject()
		if (custom_object and custom_object.OnSwitchShow) then
			local interrupt = custom_object.OnSwitchShow (instancia)
			if (interrupt) then
				return
			end
		end
	end
	
	Details.switch.frame:SetPoint("topleft", instancia.baseframe, "topleft", 0, 1)
	Details.switch.frame:SetPoint("bottomright", instancia.baseframe, "bottomright", 0, 1)

	local altura = instancia.baseframe:GetHeight()
	local mostrar_quantas = floor(altura / Details.switch.button_height) * 2
	
	local precisa_mostrar = 0
	for i = 1, #Details.switch.table do
		local slot = Details.switch.table [i]
		if (not slot) then
			Details.switch.table [i] = {}
			slot = Details.switch.table [i]
		end
		if (slot.atributo) then
			precisa_mostrar = precisa_mostrar + 1
		else
			break
		end
	end
	
	if (Details.switch.mostrar_quantas ~= mostrar_quantas) then 
		for i = 1, #Details.switch.buttons do
			if (i <= mostrar_quantas) then 
				Details.switch.buttons [i]:Show()
			else
				Details.switch.buttons [i]:Hide()
			end
		end
		
		if (#Details.switch.buttons < mostrar_quantas) then
			Details.switch.slots = mostrar_quantas
		end
		
		Details.switch.mostrar_quantas = mostrar_quantas
	end
	
	Details.switch:Resize (precisa_mostrar)
	Details.switch:Update()
	
	Details.switch.frame:SetScale(instancia.window_scale)
	Details.switch.frame:Show()
	
	Details.switch:Resize (precisa_mostrar)
	
	if (DetailsSwitchPanel.all_switch:IsShown()) then
		return DetailsSwitchPanel.all_switch:Hide()
	end
end

-- ~setting
function Details.switch:Config(_, _, atributo, sub_atributo)
	if (not sub_atributo) then
		return
	end

	if (type(atributo) == "string") then
		--is a plugin?
		local plugin = Details:GetPlugin(atributo)
		if(plugin) then
			Details.switch.table[Details.switch.editing_bookmark].atributo = "plugin"
			Details.switch.table[Details.switch.editing_bookmark].sub_atributo = atributo
		end
	else
		--is a attribute or custom script
		Details.switch.table[Details.switch.editing_bookmark].atributo = atributo
		Details.switch.table[Details.switch.editing_bookmark].sub_atributo = sub_atributo
	end

	Details.switch.editing_bookmark = nil
	gameCooltip:Hide()
	Details.switch:Update()
end

--[[global]] function DetailsChangeDisplayFromBookmark(number, instance)
	if (not instance) then
		local lowerInstanceId = Details:GetLowerInstanceNumber()
		if (lowerInstanceId) then
			instance = Details:GetInstance(lowerInstanceId)
		end
		if (not instance) then
			return Details:Msg(Loc["STRING_WINDOW_NOTFOUND"])
		end
	end

	local bookmark = Details.switch.table[number]

	if (bookmark) then
		Details.switch.current_instancia = instance
		if (not bookmark.atributo) then
			return Details:Msg(string.format(Loc["STRING_SWITCH_SELECTMSG"], number))
		end

		Details:FastSwitch(nil, bookmark, number)
	end
end

function Details:FastSwitch(button, bookmark, bookmarkNumber, selectNew)
	local unknownPlugin = bookmark and bookmark.atributo == "plugin" and not Details:GetPlugin(bookmark.sub_atributo)

	if (selectNew or not bookmark.atributo or unknownPlugin) then
		gameCooltip:Reset()
		gameCooltip:SetOwner(button)
		gameCooltip:SetType(3)
		gameCooltip:SetFixedParameter(Details.switch.current_instancia)

		Details.switch.editing_bookmark = bookmarkNumber

		Details:MontaAtributosOption(Details.switch.current_instancia, Details.switch.Config)

		--build raid plugins list
		gameCooltip:AddLine(Loc["STRING_MODE_PLUGINS"])
		gameCooltip:AddMenu(1, function() end, 4, true)
		gameCooltip:AddIcon([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 32/256*3, 32/256*4, 0, 1)

		local availablePlugins = Details.RaidTables:GetAvailablePlugins()
		local amt = 0

		if (#availablePlugins >= 0) then
			for index, ptable in ipairs(availablePlugins) do
				if (ptable [3].__enabled and not ptable[3].NoMenu) then
					gameCooltip:AddMenu(2, Details.switch.Config, Details.switch.current_instancia, ptable [4], true, ptable [1], ptable [2], true) --PluginName, PluginIcon, PluginObject, PluginAbsoluteName
					amt = amt + 1
				end
			end
			gameCooltip:SetWallpaper(2, Details.tooltip.menus_bg_texture, Details.tooltip.menus_bg_coords, Details.tooltip.menus_bg_color, true)
		end

		if (#Details.SoloTables.Menu > 0) then
			for index, ptable in ipairs(Details.SoloTables.Menu) do
				if (ptable [3].__enabled and not ptable[3].NoMenu) then
					gameCooltip:AddMenu(2, Details.switch.Config, Details.switch.current_instancia, ptable [4], true, ptable [1], ptable [2], true)
				end
			end
			gameCooltip:SetWallpaper(2, Details.tooltip.menus_bg_texture, Details.tooltip.menus_bg_coords, Details.tooltip.menus_bg_color, true)
		end

		if (amt <= 3) then
			gameCooltip:SetOption("SubFollowButton", true)
		end

		gameCooltip:SetOption("HeightAnchorMod", -7)
		gameCooltip:SetOption("TextSize", Details.font_sizes.menus)
		return gameCooltip:ShowCooltip()
	end

	if (IsShiftKeyDown()) then
		--get a closed window or created a new one
		local instance = Details:CreateInstance()
		if (not instance) then
			Details.switch.CloseMe()
			return Details:Msg(Loc["STRING_WINDOW_NOTFOUND"])
		end
		Details.switch.current_instancia = instance
	end

	if (Details.switch.current_instancia.modo == Details._detalhes_props["MODO_ALONE"]) then
		Details.switch.current_instancia:AlteraModo (Details.switch.current_instancia, 2)

	elseif (Details.switch.current_instancia.modo == Details._detalhes_props["MODO_RAID"]) then
		Details.switch.current_instancia:AlteraModo (Details.switch.current_instancia, 2)
	end

	if (bookmark.atributo == "plugin") then
		--is a plugin, check if is a raid or solo plugin
		if (Details.RaidTables.NameTable [bookmark.sub_atributo]) then
			local raidPlugins = Details.RaidTables:GetAvailablePlugins()
			local isAvailable = false
			if (#raidPlugins >= 0) then
				for i, ptable in ipairs(raidPlugins) do
					--check if the plugin is available
					if (ptable[4] == bookmark.sub_atributo) then
						isAvailable = true
					end
				end
			end

			if (isAvailable) then
				Details.RaidTables:EnableRaidMode(Details.switch.current_instancia, bookmark.sub_atributo)
			else
				Details:Msg("plugin already in use in another window. If you are wondering where, check the Orange Gear > Window Control.") --localize-me
			end

		elseif (Details.SoloTables.NameTable [bookmark.sub_atributo]) then
			Details.SoloTables:EnableSoloMode(Details.switch.current_instancia, bookmark.sub_atributo)
		else
			Details:Msg("Plugin not found.")
		end
	else
		Details.switch.current_instancia:TrocaTabela(Details.switch.current_instancia, true, bookmark.atributo, bookmark.sub_atributo)
	end

	Details.switch.CloseMe()
end

function Details.switch:InitSwitch()
	local instancia = Details.tabela_instancias[1]
	Details.switch:ShowMe(instancia)
	Details.switch:CloseMe()
end

function Details.switch:OnRemoveCustom(customIndex)
	for i = 1, Details.switch.slots do
		local options = Details.switch.table[i]
		if (options and options.atributo == 5 and options.sub_atributo == customIndex) then
			options.atributo = nil
			options.sub_atributo = nil
			--update if already shown once at least
			if (Details.switch.vertical_amt) then
				Details.switch:Update()
			end
		end
	end
end

local default_coords = {5/64, 59/64, 5/64, 59/64}
local vertex_color_default = {1, 1, 1}
local vertex_color_unknown = {1, 1, 1}
local add_coords = {464/512, 473/512, 1/512, 11/512}

function Details.switch:Update()
	if (not Details.switch.vertical_amt) then
		--wasn't opened yet, so doesn't matter if we update or not
		return
	end

	local slots = Details.switch.slots
	local x = 10
	local y = 5
	local jump = false
	local hide_the_rest

	local offset = FauxScrollFrame_GetOffset(DetailsSwitchPanelScroll)
	local slots_shown = Details.switch.slots

	for i = 1, slots_shown do
		--bookmark index
		local index = (offset * Details.switch.vertical_amt) + i
	
		--button
		local button = Details.switch.buttons [i]
		if (not button) then
			button = Details.switch:NewSwitchButton (Details.switch.frame, i, x, y, jump)
			button:SetFrameLevel(Details.switch.frame:GetFrameLevel()+2)
			Details.switch.showing = Details.switch.showing + 1
		end

		local options = Details.switch.table [index]
		if (not options and index <= 40) then 
			options = {}
			Details.switch.table [index] = options
		end
		
		button.bookmark_number = index --button on icon
		button.button2.bookmark_number = index --button on text
		
		local icone
		local coords
		local name
		local vcolor
		local add
		local textColor = "white"
		
		if (options and options.sub_atributo) then
			if (options.atributo == 5) then --custom
				local CustomObject = Details.custom [options.sub_atributo]
				if (not CustomObject) then --ele j� foi deletado
					icone = [[Interface\AddOns\Details\images\icons]]
					coords = add_coords
					name = Loc["STRING_SWITCH_CLICKME"]
					vcolor = vertex_color_unknown
					add = true
				else
					icone = CustomObject.icon
					coords = default_coords
					name = CustomObject.name
					vcolor = vertex_color_default
				end
				
			elseif (options.atributo == "plugin") then --plugin

				local plugin = Details:GetPlugin (options.sub_atributo)
				if (plugin) then

					local raidPlugins = Details.RaidTables:GetAvailablePlugins()
					local isAvailable = false
					if (#raidPlugins >= 0) then
						for i, ptable in ipairs(raidPlugins) do
							--check if the plugin is available
							if (ptable[4] == plugin.real_name) then
								isAvailable = true
							end
						end
					end

					if (isAvailable) then
						vcolor = vertex_color_default
					else
						vcolor = {.35, .35, .35, .35}
						textColor = "gray"
					end
					icone =  plugin.__icon
					coords = default_coords
					name = plugin.__name

				else
					icone = [[Interface\AddOns\Details\images\icons]]
					coords = add_coords
					name = Loc["STRING_SWITCH_CLICKME"]
					vcolor = vertex_color_unknown
					add = true
				end
			else
				icone = Details.sub_atributos [options.atributo].icones [options.sub_atributo] [1]
				coords = Details.sub_atributos [options.atributo].icones [options.sub_atributo] [2]
				name = Details.sub_atributos [options.atributo].lista [options.sub_atributo]
				vcolor = vertex_color_default
			end
		else

			icone = [[Interface\AddOns\Details\images\icons]]
			coords = add_coords
			name = Loc["STRING_SWITCH_CLICKME"]
			vcolor = vertex_color_unknown
			add = true
		end

		button:Show()
		button.button2:Show()

		local width, height = button.button2.texto:GetSize()
		button.button2.texto:SetWidth(300)
		button.button2.texto:SetText(name)
		local text_width = button.button2.texto:GetStringWidth()

		while (text_width > Details.switch.text_size) do
			Details:SetFontSize(button.button2.texto, Details.bookmark_text_size)
			local text = button.button2.texto:GetText()
			text = strsub(text, 1, #text-1)
			button.button2.texto:SetText(text)
			text_width = button.button2.texto:GetStringWidth()
		end

		button.button2.texto:SetSize(width, height)
		DetailsFramework:SetFontColor(button.button2.texto, textColor)

		button.textureNormal:SetTexture(icone, true)
		button.textureNormal:SetTexCoord(unpack(coords))
		button.textureNormal:SetVertexColor(unpack(vcolor))
		button.texturePushed:SetTexture(icone, true)
		button.texturePushed:SetTexCoord(unpack(coords))
		button.texturePushed:SetVertexColor(unpack(vcolor))
		button.textureH:SetTexture(icone, true)
		button.textureH:SetVertexColor(unpack(vcolor))
		button.textureH:SetTexCoord(unpack(coords))
		button:ChangeIcon(button.textureNormal, button.texturePushed, nil, button.textureH)

		if (add) then
			button:SetSize(12, 12)
		else
			button:SetSize(15, 15)
		end

		if (name == Loc["STRING_SWITCH_CLICKME"]) then
			button:SetAlpha(0.3)
			button.textureNormal:SetDesaturated(true)
			button.button2.texto:SetPoint("left", button, "right", 5, -1)
		else
			button:SetAlpha(1)
			button.textureNormal:SetDesaturated(false)
			button.button2.texto:SetPoint("left", button, "right", 3, -1)
		end

		if (jump) then
			x = x - 125
			y = y + Details.switch.button_height
			jump = false
		else
			x = x + 1254
			jump = true
		end

	end

	FauxScrollFrame_Update(DetailsSwitchPanelScroll, ceil (40 / Details.switch.vertical_amt) , Details.switch.horizontal_amt, 20)
end

local scroll = CreateFrame("scrollframe", "DetailsSwitchPanelScroll", DetailsSwitchPanel, "FauxScrollFrameTemplate")
scroll:SetAllPoints()
scroll:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, Details.switch.Update) end) --altura
scroll.ScrollBar:Hide()
scroll.ScrollBar.ScrollUpButton:Hide()
scroll.ScrollBar.ScrollDownButton:Hide()

function Details.switch:Resize()
	local x, xOriginal = 5, 5
	local y = 5
	local incrementY = 18
	local windowWidth, windowHeight = Details.switch.current_instancia:GetSize()

	local horizontalAmt = floor(math.max(windowWidth / 100, 2))
	local verticalAmt = floor((windowHeight - y) / incrementY)

	Details.switch.y_increment = incrementY
	local size = windowWidth / horizontalAmt
	local bookmarkFrame = Details.switch.frame

	for index, button in ipairs(Details.switch.buttons) do
		button:Hide()
	end

	Details.switch.vertical_amt = verticalAmt
	Details.switch.horizontal_amt = horizontalAmt
	Details.switch.text_size = size - 30

	local i = 1
	for vertical = 1, verticalAmt do
		x = xOriginal
		for horizontal = 1, horizontalAmt do
			local button = Details.switch.buttons[i]
			local options = Details.switch.table[i]

			if (not options) then
				options = {atributo = nil, sub_atributo = nil}
				Details.switch.table[i] = options
			end

			if (not button) then
				button = Details.switch:NewSwitchButton(bookmarkFrame, i, x, y)
				button:SetFrameLevel(bookmarkFrame:GetFrameLevel()+2)
				Details.switch.showing = Details.switch.showing + 1
			end

			button:SetPoint("topleft", bookmarkFrame, "topleft", x, -y)
			button.textureNormal:SetPoint("topleft", bookmarkFrame, "topleft", x, -y)
			button.texturePushed:SetPoint("topleft", bookmarkFrame, "topleft", x, -y)
			button.textureH:SetPoint("topleft", bookmarkFrame, "topleft", x, -y)
			button.button2.texto:SetSize(size - 30, 12)
			button.button2:SetPoint("bottomright", button, "bottomright", size - 30, 0)
			button:Show()

			i = i + 1
			x = x + size
			if (i > 40) then
				break
			end
		end
		y = y + incrementY + 2
	end

	Details.switch.slots = i - 1
end

local bookmarkButtonBodyOnEnter = function(self)
	if (not Details.switch.table[self.id].atributo) then
		gameCooltip:Reset()
		gameCooltip:SetOwner(self)

		gameCooltip:SetOption("TextSize", 10)
		gameCooltip:SetOption("ButtonsYMod", 0)
		gameCooltip:SetOption("YSpacingMod", 0)
		gameCooltip:SetOption("IgnoreButtonAutoHeight", false)

		gameCooltip:AddLine(Loc["STRING_SWITCH_CLICKME"]) --add bookmark
		gameCooltip:AddIcon([[Interface\Glues\CharacterSelect\Glues-AddOn-Icons]], 1, 1, 16, 16, 0.75, 1, 0, 1, {0, 1, 0})
		gameCooltip:Show()
	else
		gameCooltip:Hide()
	end

	Details:SetFontColor(self.texto, "orange")

	DetailsSwitchPanel.hoverOverTexture:SetSize(self:GetWidth(), self:GetHeight()) --size of button
	DetailsSwitchPanel.hoverOverTexture:ClearAllPoints()
	DetailsSwitchPanel.hoverOverTexture:SetPoint("topleft", self, "topleft", -18, 1)
	DetailsSwitchPanel.hoverOverTexture:SetPoint("bottomright", self, "bottomright", 8, -1)
	DetailsSwitchPanel.hoverOverTexture:Show()
end

local bookmarkButtonBodyOnLeave = function(self)
	if (gameCooltip:IsTooltip()) then
		gameCooltip:Hide()
	end
	self.texto:SetTextColor(.9, .9, .9, .9)
	self.button1_icon:SetBlendMode("BLEND")
end

local bookmarkButtonIconOnEnter = function(self)
	if (gameCooltip:IsMenu()) then
		return
	end

	gameCooltip:Reset()
	gameCooltip:SetOwner(self)

	gameCooltip:AddLine("select bookmark")
	gameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 14, 0.0019531, 0.1484375, 0.6269531, 0.8222656)

	gameCooltip:SetOption("TextSize", 10)
	gameCooltip:SetOption("ButtonsYMod", 0)
	gameCooltip:SetOption("YSpacingMod", 0)
	gameCooltip:SetOption("IgnoreButtonAutoHeight", false)

	Details:SetFontColor(self.texto, "orange")
	gameCooltip:Show()
end

local bookmarkButtonIconOnLeave = function(self)
	if (gameCooltip:IsTooltip()) then
		gameCooltip:Hide()
	end
	self.texto:SetTextColor(.9, .9, .9, .9)
end

local bookmarkButtonIconOnClick = function(self, button)
	if (button == "RightButton") then
		--select another bookmark
		Details:FastSwitch(self, nil, self.bookmark_number, true)
	else
		--change the display
		local bookmark = Details.switch.table[self.bookmark_number]
		if (bookmark.atributo) then
			Details:FastSwitch(self, bookmark, self.bookmark_number)
		else
			--invalid bookmark, select another bookmark
			Details:FastSwitch(self, bookmark, self.bookmark_number, true)
		end
	end
end

local bookmarkButtonBodyOnClick = function(self, button)
	if (button == "RightButton") then
		--close the bookmark menu
		Details.switch:CloseMe()
	else
		--change the display
		local bookmark = Details.switch.table[self.bookmark_number]
		if (bookmark.atributo) then
			Details:FastSwitch(self, bookmark, self.bookmark_number)
		else
			--invalid bookmark, select another bookmark
			Details:FastSwitch(self, bookmark, self.bookmark_number, true)
		end
	end
end

local changeIconFunc = function(self, icon1, icon2, icon3, icon4)
	self:SetNormalTexture(icon1 or "")
	self:SetPushedTexture(icon2 or "")
	self:SetDisabledTexture(icon3 or "")
	self:SetHighlightTexture(icon4 or "", "ADD")
end

function Details.switch:NewSwitchButton(frame, index, x, y, rightButton)
	local newSwitchButton = CreateFrame("button", "DetailsSwitchPanelButton_1_" .. index, frame, "BackdropTemplate")
	newSwitchButton:SetSize(15, 24)
	newSwitchButton:SetPoint("topleft", frame, "topleft", x, -y)
	newSwitchButton:SetScript("OnMouseDown", bookmarkButtonIconOnClick)
	newSwitchButton:SetScript("OnEnter", bookmarkButtonIconOnEnter)
	newSwitchButton:SetScript("OnLeave", bookmarkButtonIconOnLeave)
	newSwitchButton.ChangeIcon = changeIconFunc
	newSwitchButton.id = index

	local backgroundTexture = DetailsFramework:CreateTexture(newSwitchButton, {gradient = "vertical", fromColor = {0, 0, 0, 0.3}, toColor = "transparent"}, 1, 1, "artwork", {0, 1, 0, 1})
	backgroundTexture:SetAllPoints()

	local button2 = CreateFrame("button", "DetailsSwitchPanelButton_2_" .. index, newSwitchButton, "BackdropTemplate")
	button2:SetSize(1, 1)
	button2:SetPoint("topleft", newSwitchButton, "topright", 1, 0)
	button2:SetPoint("bottomright", newSwitchButton, "bottomright", 90, 0)
	button2:SetScript("OnMouseDown", bookmarkButtonBodyOnClick)
	button2:SetScript("OnEnter", bookmarkButtonBodyOnEnter)
	button2:SetScript("OnLeave", bookmarkButtonBodyOnLeave)
	button2.id = index
	newSwitchButton.button2 = button2

	--icon
	newSwitchButton.textureNormal = newSwitchButton:CreateTexture(nil, "background")
	newSwitchButton.textureNormal:SetAllPoints()

	--icon pushed
	newSwitchButton.texturePushed = newSwitchButton:CreateTexture(nil, "background")
	newSwitchButton.texturePushed:SetAllPoints()

	--highlight
	newSwitchButton.textureH = newSwitchButton:CreateTexture(nil, "background")
	newSwitchButton.textureH:SetAllPoints()

	--text
	gump:NewLabel(button2, button2, nil, "texto", "", "GameFontNormal")
	button2.texto:SetPoint("left", newSwitchButton, "right", 5, -1)
	button2.texto:SetTextColor(.9, .9, .9, 1)

	Details:SetFontSize(button2.texto, Details.bookmark_text_size)

	newSwitchButton.texto = button2.texto

	button2.button1_icon = newSwitchButton.textureNormal
	button2.button1_icon2 = newSwitchButton.texturePushed
	button2.button1_icon3 = newSwitchButton.textureH

	button2.MouseOnEnterHook = bookmarkButtonBodyOnEnter
	button2.MouseOnLeaveHook = bookmarkButtonBodyOnLeave

	Details.switch.buttons[index] = newSwitchButton
	return newSwitchButton
end




local Details = _G.Details
local C_Timer = _G.C_Timer
local libwindow = LibStub("LibWindow-1.1")

function Details:OpenEventTrackerOptions (from_options_panel)
	
	if (not _G.DetailsEventTrackerOptions) then
	
		local DF = _detalhes.gump
	
		local f = DF:CreateSimplePanel (_G.UIParent, 700, 400, "Details! Event Tracker Options", "DetailsEventTrackerOptions")
		f:SetPoint ("center", _G.UIParent, "center")
		f:SetScript ("OnMouseDown", nil)
		f:SetScript ("OnMouseUp", nil)
		local LibWindow = _G.LibStub("LibWindow-1.1")
		LibWindow.RegisterConfig (f, _detalhes.event_tracker.options_frame)
		LibWindow.MakeDraggable (f)
		LibWindow.RestorePosition (f)
		
		local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
		local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
		local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
		local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
		
		--> frame strata options
			local set_frame_strata = function (_, _, strata)
				Details.event_tracker.frame.strata = strata
				Details:UpdateEventTrackerFrame()
			end
			local strataTable = {}
			strataTable [1] = {value = "BACKGROUND", label = "BACKGROUND", onclick = set_frame_strata}
			strataTable [2] = {value = "LOW", label = "LOW", onclick = set_frame_strata}
			strataTable [3] = {value = "MEDIUM", label = "MEDIUM", onclick = set_frame_strata}
			strataTable [4] = {value = "HIGH", label = "HIGH", onclick = set_frame_strata}
			strataTable [5] = {value = "DIALOG", label = "DIALOG", onclick = set_frame_strata}
		
		--> font options
			local set_font_shadow= function (_, _, shadow)
				Details.event_tracker.font_shadow = shadow
				Details:UpdateEventTrackerFrame()
			end
			local fontShadowTable = {}
			fontShadowTable [1] = {value = "NONE", label = "None", onclick = set_font_shadow}
			fontShadowTable [2] = {value = "OUTLINE", label = "Outline", onclick = set_font_shadow}
			fontShadowTable [3] = {value = "THICKOUTLINE", label = "Thick Outline", onclick = set_font_shadow}
			
			local on_select_text_font = function (self, fixed_value, value)
				Details.event_tracker.font_face = value
				Details:UpdateEventTrackerFrame()
			end
		
		--> texture options
			local set_bar_texture = function (_, _, value) 
				Details.event_tracker.line_texture = value
				Details:UpdateEventTrackerFrame()
			end
			
			local SharedMedia = _G.LibStub:GetLibrary ("LibSharedMedia-3.0")
			local textures = SharedMedia:HashTable ("statusbar")
			local texTable = {}
			for name, texturePath in pairs (textures) do 
				texTable [#texTable + 1] = {value = name, label = name, statusbar = texturePath, onclick = set_bar_texture}
			end
			table.sort (texTable, function (t1, t2) return t1.label < t2.label end)
		
		--> options table
		local options = {
		
			{type = "label", get = function() return "Frame Settings:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
			--enabled
			{
				type = "toggle",
				get = function() return Details.event_tracker.enabled end,
				set = function (self, fixedparam, value)
					Details.event_tracker.enabled = not Details.event_tracker.enabled
					Details:LoadFramesForBroadcastTools()
				end,
				desc = "Enabled",
				name = "Enabled",
				text_template = options_text_template,
			},
			--locked
			{
				type = "toggle",
				get = function() return Details.event_tracker.frame.locked end,
				set = function (self, fixedparam, value) 
					Details.event_tracker.frame.locked = not Details.event_tracker.frame.locked
					Details:UpdateEventTrackerFrame()
				end,
				desc = "Locked",
				name = "Locked",
				text_template = options_text_template,
			},
			--showtitle
			{
				type = "toggle",
				get = function() return Details.event_tracker.frame.show_title end,
				set = function (self, fixedparam, value) 
					Details.event_tracker.frame.show_title = not Details.event_tracker.frame.show_title
					Details:UpdateEventTrackerFrame()
				end,
				desc = "Show Title",
				name = "Show Title",
				text_template = options_text_template,
			},
			--backdrop color
			{
				type = "color",
				get = function() 
					return {Details.event_tracker.frame.backdrop_color[1], Details.event_tracker.frame.backdrop_color[2], Details.event_tracker.frame.backdrop_color[3], Details.event_tracker.frame.backdrop_color[4]} 
				end,
				set = function (self, r, g, b, a) 
					local color = Details.event_tracker.frame.backdrop_color
					color[1], color[2], color[3], color[4] = r, g, b, a
					Details:UpdateEventTrackerFrame()
				end,
				desc = "Backdrop Color",
				name = "Backdrop Color",
				text_template = options_text_template,
			},
			--statra
			{
				type = "select",
				get = function() return Details.event_tracker.frame.strata end,
				values = function() return strataTable end,
				name = "Frame Strata"
			},
			{type = "breakline"},
			{type = "label", get = function() return "Line Settings:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
			--line height
			{
				type = "range",
				get = function() return Details.event_tracker.line_height end,
				set = function (self, fixedparam, value) 
					Details.event_tracker.line_height = value
					Details:UpdateEventTrackerFrame()
				end,
				min = 4,
				max = 32,
				step = 1,
				name = "Line Height",
				text_template = options_text_template,
			},
			--line texture
			{
				type = "select",
				get = function() return Details.event_tracker.line_texture end,
				values = function() return texTable end,
				name = "Line Texture",
			},
			--line color
			{
				type = "color",
				get = function() 
					return {Details.event_tracker.line_color[1], Details.event_tracker.line_color[2], Details.event_tracker.line_color[3], Details.event_tracker.line_color[4]} 
				end,
				set = function (self, r, g, b, a) 
					local color = Details.event_tracker.line_color
					color[1], color[2], color[3], color[4] = r, g, b, a
					Details:UpdateEventTrackerFrame()
				end,
				desc = "Line Color",
				name = "Line Color",
				text_template = options_text_template,
			},
			--font size
			{
				type = "range",
				get = function() return Details.event_tracker.font_size end,
				set = function (self, fixedparam, value) 
					Details.event_tracker.font_size = value
					Details:UpdateEventTrackerFrame()
				end,
				min = 4,
				max = 32,
				step = 1,
				name = "Font Size",
				text_template = options_text_template,
			},
			--font color
			{
				type = "color",
				get = function() 
					return {Details.event_tracker.font_color[1], Details.event_tracker.font_color[2], Details.event_tracker.font_color[3], Details.event_tracker.font_color[4]} 
				end,
				set = function (self, r, g, b, a) 
					local color = Details.event_tracker.font_color
					color[1], color[2], color[3], color[4] = r, g, b, a
					Details:UpdateEventTrackerFrame()
				end,
				desc = "Font Color",
				name = "Font Color",
				text_template = options_text_template,
			},
			--font shadow
			{
				type = "select",
				get = function() return Details.event_tracker.font_shadow end,
				values = function() return fontShadowTable end,
				name = "Font Shadow"
			},
			--font face
			{
				type = "select",
				get = function() return Details.event_tracker.font_face end,
				values = function() return DF:BuildDropDownFontList (on_select_text_font) end,
				name = "Font Face",
				text_template = options_text_template,
			},
		}

		DF:BuildMenu (f, options, 7, -30, 500, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
		
		f:SetScript ("OnHide", function()
			--> reopen the options panel
			if (f.FromOptionsPanel) then
				C_Timer.After (0.2, function()
					Details:OpenOptionsWindow(Details:GetInstance(1))
				end)
			end
		end)
	end

	_G.DetailsEventTrackerOptions:RefreshOptions()
	_G.DetailsEventTrackerOptions:Show()
	_G.DetailsEventTrackerOptions.FromOptionsPanel = from_options_panel
end


function Details:CreateEventTrackerFrame(parent, name)

	local DF = _detalhes.gump
	local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
	
	--> main farame
		local f = CreateFrame ("frame", name, parent or UIParent,"BackdropTemplate")
		f:SetPoint ("center", UIParent, "center")
		f:SetMinResize (150, 40)
		f:SetMaxResize (800, 1024)
		f:SetSize (_detalhes.event_tracker.frame.width, _detalhes.event_tracker.frame.height)

		f:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor (unpack (_detalhes.event_tracker.frame.backdrop_color))
		f:EnableMouse (true)
		f:SetMovable (true)
		f:SetResizable (true)
		f:SetClampedToScreen (true)
		
		local LibWindow = LibStub ("LibWindow-1.1")
		LibWindow.RegisterConfig (f, _detalhes.event_tracker.frame)
		LibWindow.MakeDraggable (f)
		LibWindow.RestorePosition (f)
	
	--> two resizers
	
		local left_resize, right_resize = DF:CreateResizeGrips (f)
		
		left_resize:SetScript ("OnMouseDown", function (self)
			if (not f.resizing and not _detalhes.event_tracker.frame.locked) then
				f.resizing = true
				f:StartSizing ("bottomleft")
			end
		end)
		left_resize:SetScript ("OnMouseUp", function (self)
			if (f.resizing) then
				f.resizing = false
				f:StopMovingOrSizing()
				_detalhes.event_tracker.frame.width = f:GetWidth()
				_detalhes.event_tracker.frame.height = f:GetHeight()
			end
		end)
		right_resize:SetScript ("OnMouseDown", function (self)
			if (not f.resizing and not _detalhes.event_tracker.frame.locked) then
				f.resizing = true
				f:StartSizing ("bottomright")
			end
		end)
		right_resize:SetScript ("OnMouseUp", function (self) 
			if (f.resizing) then
				f.resizing = false
				f:StopMovingOrSizing()
				_detalhes.event_tracker.frame.width = f:GetWidth()
				_detalhes.event_tracker.frame.height = f:GetHeight()
			end
		end)
		
		f:SetScript ("OnSizeChanged", function (self)
			
		end)
	
	--> scroll frame
	
		--> frame config
		
		local scroll_line_amount = 1
		local scroll_width = 195
		local header_size = 20
		
		--> on tick script
		local lineOnTick = function (self, deltaTime)
			--> when this event occured on combat log
			local gameTime = self.GameTime
			
			--> calculate how much time elapsed since the event got triggered
			local elapsedTime = GetTime() - gameTime
			
			--> set the bar animation:
			local animationPercent = min (elapsedTime, 1)
			self.Statusbar:SetValue (animationPercent)
			
			--> set the spark location
			if (animationPercent < 1) then
				self.Spark:SetPoint ("left", self, "left", (self:GetWidth() * animationPercent) - 10, 0)
				if (not self.Spark:IsShown()) then
					self.Spark:Show()
				end
			else
				if (self.Spark:IsShown()) then
					self.Spark:Hide()
				end
			end
		end
		
		--> create a line on the scroll frame
		local scroll_createline = function (self, index)
		
			local line = CreateFrame ("frame", "$parentLine" .. index, self,"BackdropTemplate")
			line:EnableMouse (false)
			line.Index = index --> hack to not trigger error on UpdateWorldTrackerLines since Index is set after this function is ran
			
			--> set its backdrop
			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			--line:SetBackdropColor (1, 1, 1, 0.75)
			
			--> statusbar
			local statusbar = CreateFrame ("statusbar", "$parentStatusBar", line,"BackdropTemplate")
			statusbar:SetAllPoints()
			local statusbartexture = statusbar:CreateTexture (nil, "border")
			statusbar:SetStatusBarTexture (statusbartexture)
			statusbar:SetMinMaxValues (0, 1)
			statusbar:SetValue (0)
			
			local statusbarspark = statusbar:CreateTexture (nil, "artwork")
			statusbarspark:SetTexture ([[Interface\CastingBar\UI-CastingBar-Spark]])
			statusbarspark:SetSize (16, 30)
			statusbarspark:SetBlendMode ("ADD")
			statusbarspark:Hide()
			
			--> create the icon textures and texts - they are all statusbar childs
			local lefticon = statusbar:CreateTexture ("$parentLeftIcon", "overlay")
			lefticon:SetPoint ("left", line, "left", 0, 0)
			
			local righticon = statusbar:CreateTexture ("$parentRightIcon", "overlay")
			righticon:SetPoint ("right", line, "right", 0, 0)
			
			local lefttext = statusbar:CreateFontString ("$parentLeftText", "overlay", "GameFontNormal")
			DF:SetFontSize (lefttext, 9)
			lefttext:SetPoint ("left", lefticon, "right", 2, 0)
			
			local righttext = statusbar:CreateFontString ("$parentRightText", "overlay", "GameFontNormal")
			DF:SetFontSize (righttext, 9)
			righttext:SetPoint ("right", righticon, "left", -2, 0)
			
			lefttext:SetJustifyH ("left")
			righttext:SetJustifyH ("right")
			
			local actionicon = statusbar:CreateTexture ("$parentRightIcon", "overlay")
			actionicon:SetPoint ("center", line, "center")

			--> set members
			line.LeftIcon = lefticon
			line.RightIcon = righticon
			line.LeftText = lefttext
			line.RightText = righttext
			line.Statusbar = statusbar
			line.StatusbarTexture = statusbartexture
			line.Spark = statusbarspark
			line.ActionIcon = actionicon

			--> set some parameters
			_detalhes:UpdateWorldTrackerLines (line)
			
			--> set scripts
			line:SetScript ("OnUpdate", lineOnTick)
			
			return line
		end
		
		--> some consts to help work with indexes
		local SPELLTYPE_COOLDOWN = "cooldown"
		local SPELLTYPE_INTERRUPT = "interrupt"
		local SPELLTYPE_OFFENSIVE = "offensive"
		local SPELLTYPE_CROWDCONTROL = "crowdcontrol"
		
		local ABILITYTABLE_SPELLTYPE = 1
		local ABILITYTABLE_SPELLID = 2
		local ABILITYTABLE_CASTERNAME = 3
		local ABILITYTABLE_TARGETNAME = 4
		local ABILITYTABLE_TIME = 5
		local ABILITYTABLE_EXTRASPELLID = 6
		local ABILITYTABLE_GAMETIME = 7
		local ABILITYTABLE_CASTERSERIAL = 8
		local ABILITYTABLE_ISENEMY = 9
		local ABILITYTABLE_TARGETSERIAL = 10
		
		local get_spec_or_class = function (serial, name)
			local class
			local spec = _detalhes.cached_specs [serial]
			if (not spec) then
				local _, engClass = UnitClass (name)
				if (engClass) then
					class = engClass
				else
					local locClass, engClass, locRace, engRace, gender = GetPlayerInfoByGUID (serial)
					if (engClass) then
						class = engClass
					end
				end
			end
			
			return spec, class
		end
		
		local get_player_icon = function (spec, class)
			if (spec) then
				return [[Interface\AddOns\Details\images\spec_icons_normal]], unpack (_detalhes.class_specs_coords [spec])
			elseif (class) then
				return [[Interface\AddOns\Details\images\classes_small]], unpack (_detalhes.class_coords [class])
			else
				return [[Interface\AddOns\Details\images\classes_plus]], 0.50390625, 0.62890625, 0, 0.125
			end
		end
		
		local add_role_and_class_color = function (player_name, player_serial)
		
			--> get the actor object
			local actor = _detalhes.tabela_vigente[1]:GetActor (player_name)
			
			if (actor) then
				--> remove realm name
				player_name = _detalhes:GetOnlyName (player_name)
			
				local class, spec, role = actor.classe, actor.spec, actor.role
				if (not class) then
					spec, class = get_spec_or_class (player_serial, player_name)
				end
				
				--> add the class color
				if (_detalhes.player_class [class]) then
					--> is a player, add the class color
					player_name = _detalhes:AddColorString (player_name, class)
				end
				
				--add the role icon
				if (role ~= "NONE") then
					--> have a role
					player_name = _detalhes:AddRoleIcon (player_name, role, _detalhes.event_tracker.line_height)
				end
			
			else
				local spec, class = get_spec_or_class (player_serial, player_name)
				player_name = _detalhes:GetOnlyName (player_name)
				
				if (class) then
					--> add the class color
					if (_detalhes.player_class [class]) then
						--> is a player, add the class color
						player_name = _detalhes:AddColorString (player_name, class)
					end
				end
			end
			
			return player_name
		end
		
		local get_text_size = function()
			local iconsSpace = _detalhes.event_tracker.line_height * 3
			local textSpace = 4
			local saveSpace = 14
			
			local availableSpace = (f:GetWidth() - iconsSpace - textSpace - saveSpace) / 2
			
			return availableSpace
		end
		
		local shrink_string = function (fontstring, size)
			local text = fontstring:GetText()
			local loops = 20
			while (fontstring:GetStringWidth() > size and loops > 0) do
				text = strsub (text, 1, #text-1)
				fontstring:SetText (text)
				loops = loops - 1
			end
			
			return fontstring
		end
		
		--refresh the scroll frame
		local scroll_refresh = function (self, data, offset, total_lines)
		
			local textSize = get_text_size()
		
			for i = 1, total_lines do
				local index = i + offset
				local ability = data [index]
				
				if (ability) then
					local line = self:GetLine (i)
					
					local spec, class = get_spec_or_class (ability [ABILITYTABLE_CASTERSERIAL], ability [ABILITYTABLE_CASTERNAME])
					local texture, L, R, T, B = get_player_icon (spec, class)
					line.LeftIcon:SetTexture (texture)
					line.LeftIcon:SetTexCoord (L, R, T, B)
					line.LeftText:SetText (_detalhes:GetOnlyName (ability [ABILITYTABLE_CASTERNAME]))
					
					if (ability [ABILITYTABLE_ISENEMY]) then
						line:SetBackdropColor (1, .3, .3, 0.5)
					else
						line:SetBackdropColor (1, 1, 1, 0.5)
					end
					
					if (ability [ABILITYTABLE_SPELLTYPE] == SPELLTYPE_COOLDOWN) then
						local spellName, _, spellIcon = GetSpellInfo (ability [ABILITYTABLE_SPELLID])
						line.RightIcon:SetTexture (spellIcon)
						line.RightIcon:SetTexCoord (.06, .94, .06, .94)
						
						local targetName = ability [ABILITYTABLE_TARGETNAME]
						if (targetName) then
							local targetSerial = ability [ABILITYTABLE_TARGETSERIAL]
							targetName = add_role_and_class_color (targetName, targetSerial)
						end
						
						line.RightText:SetText (targetName or spellName)
						
						line.ActionIcon:SetTexture ([[Interface\AddOns\Details\images\event_tracker_icons]])
						line.ActionIcon:SetTexCoord (0, 0.125, 0, 1)
						
					elseif (ability [ABILITYTABLE_SPELLTYPE] == SPELLTYPE_OFFENSIVE) then
						local spellName, _, spellIcon = GetSpellInfo (ability [ABILITYTABLE_SPELLID])
						line.RightIcon:SetTexture (spellIcon)
						line.RightIcon:SetTexCoord (.06, .94, .06, .94)
						line.RightText:SetText (spellName)
						
						line.ActionIcon:SetTexture ([[Interface\AddOns\Details\images\event_tracker_icons]])
						line.ActionIcon:SetTexCoord (0.127, 0.25, 0, 1)

					elseif (ability [ABILITYTABLE_SPELLTYPE] == SPELLTYPE_INTERRUPT) then
						local spellNameInterrupted, _, spellIconInterrupted = GetSpellInfo (ability [ABILITYTABLE_EXTRASPELLID])
						line.RightIcon:SetTexture (spellIconInterrupted)
						line.RightIcon:SetTexCoord (.06, .94, .06, .94)
						line.RightText:SetText (spellNameInterrupted)
						
						line.ActionIcon:SetTexture ([[Interface\AddOns\Details\images\event_tracker_icons]])
						line.ActionIcon:SetTexCoord (0.251, 0.375, 0, 1)
						
					elseif (ability [ABILITYTABLE_SPELLTYPE] == SPELLTYPE_CROWDCONTROL) then
						local spellName, _, spellIcon = GetSpellInfo (ability [ABILITYTABLE_SPELLID])
						line.RightIcon:SetTexture (spellIcon)
						line.RightIcon:SetTexCoord (.06, .94, .06, .94)

						local targetName = ability [ABILITYTABLE_TARGETNAME]
						if (targetName) then
							local targetSerial = ability [ABILITYTABLE_TARGETSERIAL]
							targetName = add_role_and_class_color (targetName, targetSerial)
						end
						
						line.RightText:SetText (targetName or "unknown target")
						
						line.ActionIcon:SetTexture ([[Interface\AddOns\Details\images\event_tracker_icons]])
						line.ActionIcon:SetTexCoord (0.376, 0.5, 0, 1)

					end
					
					shrink_string (line.LeftText, textSize)
					shrink_string (line.RightText, textSize)
					
					--> set when the ability was registered on combat log
					line.GameTime = ability [ABILITYTABLE_GAMETIME]
					line:Show()
				end
			end
		end
		
		--title text
		local TitleString = f:CreateFontString (nil, "overlay", "GameFontNormal")
		TitleString:SetPoint ("top", f, "top", 0, -3)
		TitleString:SetText ("Details!: Event Tracker")
		local TitleBackground = f:CreateTexture (nil, "artwork")
		TitleBackground:SetTexture ([[Interface\Tooltips\UI-Tooltip-Background]])
		TitleBackground:SetVertexColor (.1, .1, .1, .9)
		TitleBackground:SetPoint ("topleft", f, "topleft")
		TitleBackground:SetPoint ("topright", f, "topright")
		TitleBackground:SetHeight (header_size)
		
		--> table with spells showing on the scroll frame
		local CurrentShowing = {}
		
		--> scrollframe
		local scrollframe = DF:CreateScrollBox (f, "$parentScrollFrame", scroll_refresh, CurrentShowing, scroll_width, 400, scroll_line_amount, _detalhes.event_tracker.line_height, scroll_createline, true, true)
		scrollframe:SetPoint ("topleft", f, "topleft", 0, -header_size)
		scrollframe:SetPoint ("topright", f, "topright", 0, -header_size)
		scrollframe:SetPoint ("bottomleft", f, "bottomleft", 0, 0)
		scrollframe:SetPoint ("bottomright", f, "bottomright", 0, 0)
		
		--> update line - used by 'UpdateWorldTrackerLines' function
		local update_line = function (line)
			
			--> get the line index
			local index = line.Index
			
			--> update left text
			DF:SetFontColor (line.LeftText, _detalhes.event_tracker.font_color)
			DF:SetFontFace (line.LeftText, _detalhes.event_tracker.font_face)
			DF:SetFontSize (line.LeftText, _detalhes.event_tracker.font_size)
			DF:SetFontOutline (line.LeftText, _detalhes.event_tracker.font_shadow)
			
			--> update right text
			DF:SetFontColor (line.RightText, _detalhes.event_tracker.font_color)
			DF:SetFontFace (line.RightText, _detalhes.event_tracker.font_face)
			DF:SetFontSize (line.RightText, _detalhes.event_tracker.font_size)
			DF:SetFontOutline (line.RightText, _detalhes.event_tracker.font_shadow)

			--> adjust where the line is anchored
			line:SetPoint ("topleft", line:GetParent(), "topleft", 0, -((index-1)*(_detalhes.event_tracker.line_height+1)))
			line:SetPoint ("topright", line:GetParent(), "topright", 0, -((index-1)*(_detalhes.event_tracker.line_height+1)))
			
			--> set its height
			line:SetHeight (_detalhes.event_tracker.line_height)
			
			--> set texture
			local texture = SharedMedia:Fetch ("statusbar", _detalhes.event_tracker.line_texture)
			line.StatusbarTexture:SetTexture (texture)
			line.StatusbarTexture:SetVertexColor (unpack (_detalhes.event_tracker.line_color))
			
			--> set icon size
			line.LeftIcon:SetSize (_detalhes.event_tracker.line_height, _detalhes.event_tracker.line_height)
			line.RightIcon:SetSize (_detalhes.event_tracker.line_height, _detalhes.event_tracker.line_height)
			line.ActionIcon:SetSize (_detalhes.event_tracker.line_height-4, _detalhes.event_tracker.line_height-4)
			line.ActionIcon:SetAlpha (0.65)
		end
		
		-- /run _detalhes.event_tracker.font_shadow = 24
		-- /run _detalhes:UpdateWorldTrackerLines()
		
		function _detalhes:UpdateWorldTrackerLines (line)
			--> don't run if the featured hasn't loaded
			if (not f) then
				return
			end
			
			if (line) then
				update_line (line)
			else
				--> update all lines
				for index, line in ipairs (scrollframe:GetFrames()) do
					update_line (line)
				end
				scrollframe:SetFramesHeight (_detalhes.event_tracker.line_height)
				scrollframe:Refresh()
			end
		end
		
		function _detalhes:UpdateEventTrackerFrame()
			--> don't run if the featured hasn't loaded
			if (not f) then
				return
			end
			
			f:SetSize (_detalhes.event_tracker.frame.width, _detalhes.event_tracker.frame.height)
			LibWindow.RegisterConfig (f, _detalhes.event_tracker.frame)
			LibWindow.RestorePosition (f)
			scrollframe:OnSizeChanged()
			
			if (_detalhes.event_tracker.frame.locked) then
				f:EnableMouse (false)
				left_resize:Hide()
				right_resize:Hide()
			else
				f:EnableMouse (true)
				left_resize:Show()
				right_resize:Show()
			end
			
			if (_detalhes.event_tracker.frame.show_title) then
				TitleString:Show()
				TitleBackground:Show()
				scrollframe:SetPoint ("topleft", f, "topleft", 0, -header_size)
				scrollframe:SetPoint ("topright", f, "topright", 0, -header_size)
			else
				TitleString:Hide()
				TitleBackground:Hide()
				scrollframe:SetPoint ("topleft", f, "topleft", 0, 0)
				scrollframe:SetPoint ("topright", f, "topright", 0, 0)
			end
			
			f:SetBackdropColor (unpack (_detalhes.event_tracker.frame.backdrop_color))
			scrollframe.__background:SetVertexColor (unpack (_detalhes.event_tracker.frame.backdrop_color))
			
			f:SetFrameStrata (_detalhes.event_tracker.frame.strata)
			
			_detalhes:UpdateWorldTrackerLines()
			scrollframe:Refresh()
		end
		
		--create the first line
		for i = 1, 1 do 
			scrollframe:CreateLine (scroll_createline)
		end
		f.scrollframe = scrollframe
		scrollframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		scrollframe:SetBackdropColor (0, 0, 0, 0)
		
		--> get tables used inside the combat parser
		local cooldownListFromFramework = DetailsFramework.CooldownsAllDeffensive
		local attackCooldownsFromFramework = DetailsFramework.CooldownsAttack
		local crowdControlFromFramework = DetailsFramework.CrowdControlSpells
		
		local combatLog = CreateFrame ("frame")
		combatLog:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		local OBJECT_TYPE_PLAYER = 0x00000400
		local OBJECT_TYPE_ENEMY = 0x00000040
		
		--> combat parser
		local is_player = function (flag)
			if (not flag) then
				return false
			end
			return bit.band (flag, OBJECT_TYPE_PLAYER) ~= 0
		end
		local is_enemy = function (flag)
			if (not flag) then
				return false
			end
			return bit.band (flag, OBJECT_TYPE_ENEMY) ~= 0
		end
		
		combatLog:SetScript ("OnEvent", function (self, event)
			
			local time, token, hidding, caster_serial, caster_name, caster_flags, caster_flags2, target_serial, target_name, target_flags, target_flags2, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool = CombatLogGetCurrentEventInfo()
			local added = false
			
			--> defensive cooldown
			if (token == "SPELL_CAST_SUCCESS" and (cooldownListFromFramework [spellid]) and is_player (caster_flags)) then 
				tinsert (CurrentShowing, 1, {SPELLTYPE_COOLDOWN, spellid, caster_name, target_name, time, false, GetTime(), caster_serial, is_enemy (caster_flags), target_serial})
				added = true
				
			--> offensive cooldown
			elseif (token == "SPELL_CAST_SUCCESS" and (attackCooldownsFromFramework [spellid]) and is_player (caster_flags)) then 
				tinsert (CurrentShowing, 1, {SPELLTYPE_OFFENSIVE, spellid, caster_name, target_name, time, false, GetTime(), caster_serial, is_enemy (caster_flags), target_serial})
				added = true
			
			--> crowd control
			elseif (token == "SPELL_AURA_APPLIED" and (crowdControlFromFramework [spellid])) then
				--check if isnt a pet
				if (target_flags and is_player (target_flags)) then
					tinsert (CurrentShowing, 1, {SPELLTYPE_CROWDCONTROL, spellid, caster_name, target_name, time, false, GetTime(), caster_serial, is_enemy (caster_flags), target_serial})
					added = true
				end
			
			--> spell interrupt
			elseif (token == "SPELL_INTERRUPT") then
				tinsert (CurrentShowing, 1, {SPELLTYPE_INTERRUPT, spellid, caster_name, target_name, time, extraSpellID, GetTime(), caster_serial, is_enemy (caster_flags), target_serial})
				added = true

			end
			
			if (added) then
				local amountOfLines = scrollframe:GetNumFramesShown()
				local amountToShow = #CurrentShowing
				
				if (amountToShow > amountOfLines) then
					tremove (CurrentShowing, amountToShow)
				end
				scrollframe:Refresh()
			end
			
		end)
	
	_detalhes.Broadcaster_EventTrackerLoaded = true
	_detalhes.Broadcaster_EventTrackerFrame = f
	f:Hide()
end
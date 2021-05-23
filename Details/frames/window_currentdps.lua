

local Details = _G.Details
local libwindow = LibStub("LibWindow-1.1")
local DF = DetailsFramework

local green_team_color
local yellow_team_color

function Details:OpenCurrentRealDPSOptions(from_options_panel)

	if (not DetailsCurrentRealDPSOptions) then
	
		green_team_color = Details.class_colors.ARENA_GREEN --{.5, 1, .5, 1}
		yellow_team_color = Details.class_colors.ARENA_YELLOW --{1, 1, .5, 1}

		local DF = _detalhes.gump
	
		local f = DF:CreateSimplePanel (UIParent, 700, 400, "Details! The Current Real DPS Options", "DetailsCurrentRealDPSOptions")
		f:SetPoint ("center", UIParent, "center")
		f:SetScript ("OnMouseDown", nil)
		f:SetScript ("OnMouseUp", nil)
		local LibWindow = LibStub ("LibWindow-1.1")
		LibWindow.RegisterConfig (f, _detalhes.current_dps_meter.options_frame)
		LibWindow.MakeDraggable (f)
		LibWindow.RestorePosition (f)
		
		local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
		local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
		local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
		local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
		
		local testUsing = "arena" --mythicdungeon
		
		--> frame strata options
			local set_frame_strata = function (_, _, strata)
				Details.current_dps_meter.frame.strata = strata
				Details:UpdateTheRealCurrentDPSFrame(testUsing)
			end
			local strataTable = {}
			strataTable [1] = {value = "BACKGROUND", label = "BACKGROUND", onclick = set_frame_strata}
			strataTable [2] = {value = "LOW", label = "LOW", onclick = set_frame_strata}
			strataTable [3] = {value = "MEDIUM", label = "MEDIUM", onclick = set_frame_strata}
			strataTable [4] = {value = "HIGH", label = "HIGH", onclick = set_frame_strata}
			strataTable [5] = {value = "DIALOG", label = "DIALOG", onclick = set_frame_strata}
			
		--> font options
			local set_font_shadow= function (_, _, shadow)
				Details.current_dps_meter.font_shadow = shadow
				Details:UpdateTheRealCurrentDPSFrame(testUsing)
			end
			local fontShadowTable = {}
			fontShadowTable [1] = {value = "NONE", label = "None", onclick = set_font_shadow}
			fontShadowTable [2] = {value = "OUTLINE", label = "Outline", onclick = set_font_shadow}
			fontShadowTable [3] = {value = "THICKOUTLINE", label = "Thick Outline", onclick = set_font_shadow}
			
			local on_select_text_font = function (self, fixed_value, value)
				Details.current_dps_meter.font_face = value
				Details:UpdateTheRealCurrentDPSFrame(testUsing)
			end
		
		local lockCallback = function()
			local f = _G.DetailsCurrentDpsMeter
			if (Details.current_dps_meter.frame.locked) then
				f.movemeLabel:Hide()
				f.lockButton:Hide()
				f:SetBackdropColor(.2, .2, .2, 0)
			else
				f.movemeLabel:Show()
				f.lockButton:Show()
				f:SetBackdropColor(.2, .2, .2, 0.5)
			end
		end

		--> options table
		local options = {
		
			{type = "label", get = function() return "Frame Settings:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
			--enabled
			{
				type = "toggle",
				get = function() return Details.current_dps_meter.enabled end,
				set = function (self, fixedparam, value)
					Details.current_dps_meter.enabled = not Details.current_dps_meter.enabled
					Details:LoadFramesForBroadcastTools()
				end,
				desc = "Enabled",
				name = "Enabled",
				text_template = options_text_template,
			},
			--locked
			{
				type = "toggle",
				get = function() return Details.current_dps_meter.frame.locked end,
				set = function (self, fixedparam, value) 
					Details.current_dps_meter.frame.locked = not Details.current_dps_meter.frame.locked
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
					lockCallback()
				end,
				desc = "Locked",
				name = "Locked",
				text_template = options_text_template,
			},
			--showtitle
			{
				type = "toggle",
				get = function() return Details.current_dps_meter.frame.show_title end,
				set = function (self, fixedparam, value) 
					Details.current_dps_meter.frame.show_title = not Details.current_dps_meter.frame.show_title
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				desc = "Show Title",
				name = "Show Title",
				text_template = options_text_template,
			},
			--backdrop color
			{
				type = "color",
				get = function() 
					return {Details.current_dps_meter.frame.backdrop_color[1], Details.current_dps_meter.frame.backdrop_color[2], Details.current_dps_meter.frame.backdrop_color[3], Details.current_dps_meter.frame.backdrop_color[4]} 
				end,
				set = function (self, r, g, b, a) 
					local color = Details.current_dps_meter.frame.backdrop_color
					color[1], color[2], color[3], color[4] = r, g, b, a
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				desc = "Backdrop Color",
				name = "Backdrop Color",
				text_template = options_text_template,
			},
			--statra
			{
				type = "select",
				get = function() return Details.current_dps_meter.frame.strata end,
				values = function() return strataTable end,
				name = "Frame Strata"
			},
			--speed
			{
				type = "range",
				get = function() return Details.current_dps_meter.sample_size end,
				set = function (self, fixedparam, value)
					Details.current_dps_meter.sample_size = value
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				min = 1,
				max = 6,
				step = 1,
				name = "Speed",
				desc = "Low is faster",
				text_template = options_text_template,
			},
			--width
			{
				type = "range",
				get = function() return Details.current_dps_meter.frame.width end,
				set = function (self, fixedparam, value) 
					Details.current_dps_meter.frame.width = value
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				min = 1,
				max = 300,
				step = 1,
				name = "Width",
				text_template = options_text_template,
			},			
			--height
			{
				type = "range",
				get = function() return Details.current_dps_meter.frame.height end,
				set = function (self, fixedparam, value) 
					Details.current_dps_meter.frame.height = value
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				min = 1,
				max = 300,
				step = 1,
				name = "Height",
				text_template = options_text_template,
			},			
			
			{type = "breakline"},
			{type = "label", get = function() return "Enabled On:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
			--arenas
			{
				type = "toggle",
				get = function() return Details.current_dps_meter.arena_enabled end,
				set = function (self, fixedparam, value)
					Details.current_dps_meter.arena_enabled = not Details.current_dps_meter.arena_enabled
					Details:LoadFramesForBroadcastTools()
				end,
				name = "Arena Matches",
				text_template = options_text_template,
			},
			--mythic dungeon
			{
				type = "toggle",
				get = function() return Details.current_dps_meter.mythic_dungeon_enabled end,
				set = function (self, fixedparam, value)
					Details.current_dps_meter.mythic_dungeon_enabled = not Details.current_dps_meter.mythic_dungeon_enabled
					Details:LoadFramesForBroadcastTools()
				end,
				name = "Mythic Dungeons",
				text_template = options_text_template,
			},
			
			{type = "breakline"},
			{type = "label", get = function() return "Text Settings:" end, text_template = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")},
			--font size
			{
				type = "range",
				get = function() return Details.current_dps_meter.font_size end,
				set = function (self, fixedparam, value) 
					Details.current_dps_meter.font_size = value
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
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
					return {Details.current_dps_meter.font_color[1], Details.current_dps_meter.font_color[2], Details.current_dps_meter.font_color[3], Details.current_dps_meter.font_color[4]} 
				end,
				set = function (self, r, g, b, a) 
					local color = Details.current_dps_meter.font_color
					color[1], color[2], color[3], color[4] = r, g, b, a
					Details:UpdateTheRealCurrentDPSFrame(testUsing)
				end,
				desc = "Font Color",
				name = "Font Color",
				text_template = options_text_template,
			},
			--font shadow
			{
				type = "select",
				get = function() return Details.current_dps_meter.font_shadow end,
				values = function() return fontShadowTable end,
				name = "Font Shadow"
			},
			--font face
			{
				type = "select",
				get = function() return Details.current_dps_meter.font_face end,
				values = function() return DF:BuildDropDownFontList (on_select_text_font) end,
				name = "Font Face",
				text_template = options_text_template,
			},
		}
		
		DF:BuildMenu (f, options, 7, -30, 500, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

		f:SetScript ("OnHide" , function()
			if (DetailsCurrentDpsMeter) then
				--> check if can hide the main frame as well
				--> we force show the main frame for the user see the frame while editing the options
				local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
				if ((instanceType ~= "party" and difficultyID ~= 8) and instanceType ~= "arena") then
					DetailsCurrentDpsMeter:Hide()
				end
			end

			--> reopen the options panel
			if (f.FromOptionsPanel) then
				C_Timer.After (0.2, function()
					Details:OpenOptionsWindow(Details:GetInstance(1))
				end)
			end
		end)

		C_Timer.After(1, lockCallback)
	end

	--> check if the frame was been created
	if (not DetailsCurrentDpsMeter) then
		Details:CreateCurrentDpsFrame(UIParent, "DetailsCurrentDpsMeter")
	end

	--> show the options
	DetailsCurrentRealDPSOptions:Show()
	DetailsCurrentRealDPSOptions:RefreshOptions()
	DetailsCurrentRealDPSOptions.FromOptionsPanel = from_options_panel

	--> start the frame for viewing while editing the options
	DetailsCurrentDpsMeter:StartForArenaMatch()
end


function Details:CreateCurrentDpsFrame(parent, name)

	local DF = _detalhes.gump
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

	green_team_color = Details.class_colors.ARENA_GREEN --{.5, 1, .5, 1}
	yellow_team_color = Details.class_colors.ARENA_YELLOW --{1, 1, .5, 1}

	--> some constants
		local header_size = 12 --title bar size
		local spacing_vertical = -6 --vertical space between the group anchor and the group dps

	--> main farame
		local f = CreateFrame ("frame", name, parent or UIParent,"BackdropTemplate")
		f:SetPoint ("center", UIParent, "center")
		f:SetSize (_detalhes.current_dps_meter.frame.width, _detalhes.current_dps_meter.frame.height)

		f:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor (unpack (_detalhes.current_dps_meter.frame.backdrop_color))
		f:EnableMouse (true)
		f:SetMovable (true)
		f:SetClampedToScreen (true)

		f.movemeLabel = f:CreateFontString(nil, "overlay", "GameFontNormal")
		f.movemeLabel:SetPoint("center", f, "center", 0, 20)
		f.movemeLabel:SetText("Move-Me")

		f.lockButton = DetailsFramework:CreateButton(f, function()
			Details.current_dps_meter.frame.locked = not Details.current_dps_meter.frame.locked
			Details:UpdateTheRealCurrentDPSFrame()
			f.movemeLabel:Hide()
			f.lockButton:Hide()
		end, 80, 20)
		f.lockButton:SetPoint("center", f, "center", 0, -20)
		f.lockButton.text = "Lock"

		if (Details.current_dps_meter.frame.locked) then
			f.movemeLabel:Hide()
			f.lockButton:Hide()
		end

		f.PlayerTeam = 0

		local LibWindow = LibStub ("LibWindow-1.1")
		LibWindow.RegisterConfig (f, _detalhes.current_dps_meter.frame)
		LibWindow.MakeDraggable (f)
		LibWindow.RestorePosition (f)

		local lockCallback = function()
			local f = _G.DetailsCurrentDpsMeter
			if (Details.current_dps_meter.frame.locked) then
				f.movemeLabel:Hide()
				f.lockButton:Hide()
				f:SetBackdropColor(.2, .2, .2, 0)
			else
				f.movemeLabel:Show()
				f.lockButton:Show()
				f:SetBackdropColor(.2, .2, .2, 0.5)
			end
		end

	--> arena dps bars
		--code for the dps bars shown in arenas

		--frame to support the two bars, one for the dps and another for heal
		--the dps bar is wider and taller, hps is below it and smaller
			local barFrame = CreateFrame("frame", "DetailsArenaDpsBars", f)
			f.dpsBarFrame = barFrame
			barFrame:SetSize(400, 80)
			barFrame:SetPoint("center", f, "center", 0, 0)

			barFrame.splitBar = DF:CreateSplitBar(barFrame, 400, 20)
			barFrame.splitBar:SetSize(400, 20)
			barFrame.splitBar:SetPoint("center", barFrame, "center", 0, 0)
			barFrame.splitBar.fontsize = 10
			barFrame.splitBar:SetTexture(SharedMedia:Fetch("statusbar", "Splitbar"))

	--> title bar
		local TitleString = f:CreateFontString (nil, "overlay", "GameFontNormal")
		TitleString:SetPoint ("top", f, "top", 0, -1)
		TitleString:SetText ("Dps on Last 5 Seconds")
		DF:SetFontSize (TitleString, 9)
		local TitleBackground = f:CreateTexture (nil, "artwork")
		TitleBackground:SetTexture ([[Interface\Tooltips\UI-Tooltip-Background]])
		TitleBackground:SetVertexColor (.1, .1, .1, .9)
		TitleBackground:SetPoint ("topleft", f, "topleft")
		TitleBackground:SetPoint ("topright", f, "topright")
		TitleBackground:SetHeight (header_size)
		
	--> labels for arena
		local labelPlayerTeam_DPS = barFrame.splitBar:CreateFontString(nil, "overlay", "GameFontNormal")
		local labelYellowTeam_DPS = barFrame.splitBar:CreateFontString(nil, "overlay", "GameFontNormal")
		labelPlayerTeam_DPS:SetText ("0")
		labelYellowTeam_DPS:SetText ("0")
		labelPlayerTeam_DPS:SetPoint ("left", barFrame.splitBar.widget, "left", 4, 0)
		labelYellowTeam_DPS:SetPoint ("right", barFrame.splitBar.widget, "right", -4, 0)
		
		function f.SwapArenaTeamColors()
			if (f.PlayerTeam == 0) then
				labelPlayerTeam:SetTextColor (unpack (yellow_team_color))
				labelYellowTeam:SetTextColor (unpack (green_team_color))
			else
				labelPlayerTeam:SetTextColor (unpack (green_team_color))
				labelYellowTeam:SetTextColor (unpack (yellow_team_color))
			end
		end

	--> labels for mythic dungeon / group party
		local labelGroupDamage = f:CreateFontString (nil, "overlay", "GameFontNormal")
		labelGroupDamage:SetText ("Real Time Group DPS")
		DF:SetFontSize (labelGroupDamage, 14)
		DF:SetFontOutline (labelGroupDamage, "NONE")
		
		local labelGroupDamage_DPS = f:CreateFontString (nil, "overlay", "GameFontNormal")
		labelGroupDamage_DPS:SetText ("0")
		
		labelGroupDamage:SetPoint ("center", f, "center", 0, 10)
		labelGroupDamage_DPS:SetPoint ("center", labelGroupDamage, "center")
		labelGroupDamage_DPS:SetPoint ("top", labelGroupDamage, "bottom", 0, spacing_vertical)
		
	--> frame update function
		
		--> update
		local time_fraction = 100/1000 --one tick per 100ms
		f.NextUpdate =  time_fraction --when the next tick occur
		f.NextScreenUpdate = _detalhes.current_dps_meter.update_interval --when the labels on the frame receive update
		
		--> arena
		f.PlayerTeamBuffer = {}
		f.YellowTeamBuffer = {}
		f.PlayerTeamDamage = 0
		f.YellowDamage = 0
		f.LastPlayerTeamDamage = 0
		f.LastYellowDamage = 0

		--> mythic dungeon / party group
		f.GroupBuffer = {}
		f.GroupTotalDamage = 0
		f.LastTickGroupDamage = 0

		--> general
		f.SampleSize = _detalhes.current_dps_meter.sample_size
		f.MaxBufferIndex = 1
		f.ShowingArena = false

		function _detalhes:UpdateTheRealCurrentDPSFrame(scenario)
			--> don't run if the featured hasn't loaded
			if (not f) then
				return
			end

			if (not _detalhes.current_dps_meter.enabled) then
				f:Hide()
				print("D! debug currentdps.lua > !current_dps_meter.enabled")
				return
			end

			if (not _detalhes.current_dps_meter.arena_enabled and not _detalhes.current_dps_meter.mythic_dungeon_enabled) then
				f:Hide()
				print("D! debug currentdps.lua > not _detalhes.current_dps_meter.arena_enabled and not _detalhes.current_dps_meter.mythic_dungeon_enabled")
				return
			end

			--> where the player are
			if (scenario == "arena") then

				f.SampleSize = _detalhes.current_dps_meter.sample_size

				labelPlayerTeam_DPS:Show()
				labelYellowTeam_DPS:Show()

				--> update arena labels
				DF:SetFontColor (labelPlayerTeam_DPS, _detalhes.current_dps_meter.font_color)
				DF:SetFontFace (labelPlayerTeam_DPS, _detalhes.current_dps_meter.font_face)
				DF:SetFontSize (labelPlayerTeam_DPS, _detalhes.current_dps_meter.font_size)
				DF:SetFontOutline (labelPlayerTeam_DPS, _detalhes.current_dps_meter.font_shadow)

				DF:SetFontColor (labelYellowTeam_DPS, _detalhes.current_dps_meter.font_color)
				DF:SetFontFace (labelYellowTeam_DPS, _detalhes.current_dps_meter.font_face)
				DF:SetFontSize (labelYellowTeam_DPS, _detalhes.current_dps_meter.font_size)
				DF:SetFontOutline (labelYellowTeam_DPS, _detalhes.current_dps_meter.font_shadow)

				--> wipe current data for arena
				wipe (f.PlayerTeamBuffer)
				wipe (f.YellowTeamBuffer)

				--> reset damage
				f.PlayerTeamDamage = 0
				f.YellowDamage = 0

				--> reset last tick damage
				f.LastPlayerTeamDamage = 0
				f.LastYellowDamage = 0

				f:Show()
				DetailsArenaDpsBars:Show()
				DetailsArenaDpsBars.splitBar:Show()
				barFrame.splitBar:EnableAnimations()

				--hide group widgets
				labelGroupDamage:Hide()
				labelGroupDamage_DPS:Hide()
				f.dpsBarFrame:Hide()

			elseif (scenario == "mythicdungeon") then
				labelGroupDamage:Show()
				labelGroupDamage_DPS:Show()

				DF:SetFontColor (labelGroupDamage_DPS, _detalhes.current_dps_meter.font_color)
				DF:SetFontFace (labelGroupDamage_DPS, _detalhes.current_dps_meter.font_face)
				DF:SetFontSize (labelGroupDamage_DPS, _detalhes.current_dps_meter.font_size)
				DF:SetFontOutline (labelGroupDamage_DPS, _detalhes.current_dps_meter.font_shadow)

				--> wipe current data for mythic dungeon
				f.GroupBuffer = {}

				--> reset damage
				f.GroupTotalDamage = 0

				--> reset last tick damage
				f.LastTickGroupDamage = 0

				--show the frame
				f:Show()

				--hide arena widgets
				DetailsArenaDpsBars:Hide()
				DetailsArenaDpsBars.splitBar:Hide()
				labelPlayerTeam_DPS:Hide()
				labelYellowTeam_DPS:Hide()
			end
			
			--> frame position
			f:SetSize (_detalhes.current_dps_meter.frame.width, _detalhes.current_dps_meter.frame.height)
			LibWindow.RegisterConfig (f, _detalhes.current_dps_meter.frame)
			LibWindow.RestorePosition (f)

			--> backdrop color
			f:SetBackdropColor (unpack (_detalhes.current_dps_meter.frame.backdrop_color))
			
			--> set frame size
			f:SetSize (_detalhes.current_dps_meter.frame.width, _detalhes.current_dps_meter.frame.height)
			
			--> frame is locked
			if (_detalhes.current_dps_meter.frame.locked) then
				f:EnableMouse (false)
			else
				f:EnableMouse (true)
			end
			
			--> frame can show title
			if (_detalhes.current_dps_meter.frame.show_title) then
				TitleString:Show()
				TitleBackground:Show()
			else
				TitleString:Hide()
				TitleBackground:Hide()
			end
			
			--> frame strata
			f:SetFrameStrata (_detalhes.current_dps_meter.frame.strata)

			--> calcule buffer size
			f.MaxBufferIndex = f.SampleSize * time_fraction * 100 --sample size in seconds * fraction * tick milliseconds

			--> interval to update the frame
			f.NextScreenUpdate = _detalhes.current_dps_meter.update_interval
		end
	
		_detalhes:UpdateTheRealCurrentDPSFrame()
		
		local on_tick = function (self, deltaTime)
		
			self.NextUpdate = self.NextUpdate - deltaTime
			
			if (self.NextUpdate <= 0) then
				--> update string
				local currentCombat = _detalhes:GetCombat()
				local damageContainer = currentCombat:GetContainer (DETAILS_ATTRIBUTE_DAMAGE)
				
				--> show the current dps during an arena match
				if (self.ShowingArena) then
					--> the team damage done at this tick
					local thisTickPlayerTeamDamage = 0
					local thisTickYellowDamage = 0
				
					for i, actor in damageContainer:ListActors() do
						--actor.arena_team = actor.arena_team or 0 --debug
						if (actor:IsPlayer() and actor.arena_team) then
							if (actor.arena_team == 0) then
								--green team / player team
								thisTickPlayerTeamDamage = thisTickPlayerTeamDamage + actor.total
							else
								--yellow
								thisTickYellowDamage = thisTickYellowDamage + actor.total
							end
							
							if (actor.nome == _detalhes.playername) then
								--> if player isn't in green team > swap colors
								if (f.PlayerTeam ~= actor.arena_team) then
									f.SwapArenaTeamColors()
									f.PlayerTeam  = actor.arena_team
								end
							end
						end
					end
					
					--> calculate how much damage the team made on this tick
					local playerTeamDamageDone = thisTickPlayerTeamDamage - f.LastPlayerTeamDamage
					local yellowDamageDone = thisTickYellowDamage - f.LastYellowDamage

					--> add the damage to buffer
					tinsert (f.PlayerTeamBuffer, 1, playerTeamDamageDone)
					tinsert (f.YellowTeamBuffer, 1, yellowDamageDone)
					
					--> save the current damage amount
					f.LastPlayerTeamDamage = thisTickPlayerTeamDamage
					f.LastYellowDamage = thisTickYellowDamage
					
					--> add the damage to current total damage
					f.PlayerTeamDamage = f.PlayerTeamDamage + playerTeamDamageDone
					f.YellowDamage = f.YellowDamage + yellowDamageDone
					
					--> remove player team damage
					local removedDamage = tremove (f.PlayerTeamBuffer, f.MaxBufferIndex+1)
					if (removedDamage) then
						f.PlayerTeamDamage = f.PlayerTeamDamage - removedDamage
						--> be save
						f.PlayerTeamDamage = max (0, f.PlayerTeamDamage)
					end
					
					--> remove yellow damage
					local removedDamage = tremove (f.YellowTeamBuffer, f.MaxBufferIndex+1)
					if (removedDamage) then
						f.YellowDamage = f.YellowDamage - removedDamage
						--> be save
						f.YellowDamage = max (0, f.YellowDamage)
					end
					
					self.NextScreenUpdate = self.NextScreenUpdate - time_fraction

					--> update double bar
						local teamGreenDps = self.PlayerTeamDamage / self.SampleSize
						local teamYellowDps = self.YellowDamage / self.SampleSize
						local totalDamage = teamGreenDps + teamYellowDps
						local dpsBarFrame = DetailsArenaDpsBars.splitBar

						--a percenntagem na barra esta sendo setada corretamente, porem a animação não esta funcrtionando ainda
						DetailsArenaDpsBars.splitBar:SetValueWithAnimation(teamGreenDps / totalDamage)
						DetailsArenaDpsBars:Show()

						if (f.PlayerTeam == 0) then
							dpsBarFrame:SetLeftColor(unpack (green_team_color))
							dpsBarFrame:SetRightColor(unpack (yellow_team_color))
						else
							dpsBarFrame:SetLeftColor(unpack (yellow_team_color))
							dpsBarFrame:SetRightColor(unpack (green_team_color))
						end

						if (Details.current_dps_meter.frame.locked) then
							f.movemeLabel:Hide()
							f.lockButton:Hide()
							f:SetBackdropColor(.2, .2, .2, 0)
						end

					if (self.NextScreenUpdate <= 0) then
						if (f.PlayerTeam == 0) then
							labelPlayerTeam_DPS:SetText (_detalhes:ToK2 (self.PlayerTeamDamage / self.SampleSize))
							labelYellowTeam_DPS:SetText (_detalhes:ToK2 (self.YellowDamage / self.SampleSize))
						else
							labelPlayerTeam_DPS:SetText (_detalhes:ToK2 (self.YellowDamage / self.SampleSize))
							labelYellowTeam_DPS:SetText (_detalhes:ToK2 (self.PlayerTeamDamage / self.SampleSize))
						end
						f.NextScreenUpdate = _detalhes.current_dps_meter.update_interval
					end
					
				elseif (self.ShowingMythicDungeon) then
				
					--iniciava um novo combate e tinha o buffer do combate anterior
					--ent�o dava o total de dano do combate recente menos o que tinha no buffer do round anterior
				
					--> the party damage done at this tick
					local thisTickGroupDamage = 0
					
					for i, actor in damageContainer:ListActors() do
						if (actor:IsPlayer() and actor:IsGroupPlayer()) then
							thisTickGroupDamage = thisTickGroupDamage + actor.total
						end
					end
					
					--> calculate how much damage the team made on this tick
					local groupDamageDoneOnThisTick = thisTickGroupDamage - f.LastTickGroupDamage
					
					--> add the damage to buffer
					tinsert (f.GroupBuffer, 1, groupDamageDoneOnThisTick)
					
					--> save the current damage amount
					f.LastTickGroupDamage = thisTickGroupDamage
					
					--> add the damage to current total damage
					f.GroupTotalDamage = f.GroupTotalDamage + groupDamageDoneOnThisTick
					
					--> cicle buffer removing the last index and subtract its damage
					local removedDamage = tremove (f.GroupBuffer, f.MaxBufferIndex+1)
					if (removedDamage) then
						--> remove the value from the total damage
						f.GroupTotalDamage = f.GroupTotalDamage - removedDamage
						--> be save
						f.GroupTotalDamage = max (0, f.GroupTotalDamage)
					end
					
					self.NextScreenUpdate = self.NextScreenUpdate - time_fraction
					if (self.NextScreenUpdate <= 0) then
						labelGroupDamage_DPS:SetText (_detalhes:ToK2 (f.GroupTotalDamage / self.SampleSize))
						f.NextScreenUpdate = _detalhes.current_dps_meter.update_interval
					end
					
				end
				
				--> set next update time
				self.NextUpdate = time_fraction
			end
		end

		f:SetScript ("OnHide", function()
			f.ShowingArena = false
			f.ShowingMythicDungeon = false
			f:SetScript ("OnUpdate", nil)
		end)

		function f:StartForArenaMatch()
			--seems not to call any show()
			if (not f.ShowingArena) then
				Details:UpdateTheRealCurrentDPSFrame("arena")
				
				f.ShowingArena = true
				f:SetScript ("OnUpdate", on_tick)
			end
		end

		function f:StartForMythicDungeon()
			if (not f.ShowingMythicDungeon) then
				f.ShowingMythicDungeon = true
				f:SetScript ("OnUpdate", on_tick)
			end
		end

		local eventListener = _detalhes:CreateEventListener()

		function eventListener:ArenaStarted()
			if (_detalhes.current_dps_meter.arena_enabled) then
				--it is working here, f:StartForArenaMatch() is called but the frame is still now shown.
				f:StartForArenaMatch()
			end
		end
		
		function eventListener:MythicDungeonStarted()
			if (_detalhes.current_dps_meter.mythic_dungeon_enabled) then
				f:StartForMythicDungeon()
			end
		end
		
		function eventListener:ArenaEnded()
			f:Hide()
		end

		function eventListener:MythicDungeonEnded()
			f:Hide()
		end
		
		function eventListener:ResetBuffer()
			if (f:IsShown()) then
				wipe (f.PlayerTeamBuffer)
				wipe (f.YellowTeamBuffer)
				wipe (f.GroupBuffer)
				f.GroupTotalDamage = 0
				f.PlayerTeamDamage = 0
				f.YellowDamage = 0
				f.LastTickGroupDamage = 0
				f.LastPlayerTeamDamage = 0
				f.LastYellowDamage = 0
			end
		end

		eventListener:RegisterEvent ("COMBAT_ARENA_START", "ArenaStarted")
		eventListener:RegisterEvent ("COMBAT_ARENA_END", "ArenaEnded")
		eventListener:RegisterEvent ("COMBAT_MYTHICDUNGEON_START", "MythicDungeonStarted")
		eventListener:RegisterEvent ("COMBAT_MYTHICDUNGEON_END", "MythicDungeonEnded")
		eventListener:RegisterEvent ("COMBAT_PLAYER_ENTER", "ResetBuffer")

	_detalhes.Broadcaster_CurrentDpsLoaded = true
	_detalhes.Broadcaster_CurrentDpsFrame = f
	C_Timer.After(1, lockCallback)
	f:Hide()
end

function DetailsTestSplitBar()

	--> create the frame
		local f = CreateFrame("frame", "DetailsTestSplitBarFrame", UIParent)
		f:SetSize(400, 200)
		f:SetPoint("center")
		local backgroundTexture = f:CreateTexture(nil, "overlay")
		backgroundTexture:SetAllPoints()
		backgroundTexture:SetColorTexture(.1, .1, .1, .7)

		local barFrame = CreateFrame("frame", "DetailsArenaDpsBars", f, "BackdropTemplate")
		f.dpsBarFrame = barFrame
		barFrame:SetSize(400, 80)
		barFrame:SetPoint("center", f, "center", 0, 50)
		DF:ApplyStandardBackdrop(barFrame)

		barFrame.splitBar = DF:CreateSplitBar(barFrame, 400, 50)
		barFrame.splitBar:SetSize(400, 50)
		barFrame.splitBar:SetPoint("center", barFrame, "center", 0, 0)
		barFrame.splitBar.fontsize = 10
		local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
		barFrame.splitBar:SetTexture(SharedMedia:Fetch("statusbar", "Splitbar"))

		barFrame.splitBar:SetLeftColor(unpack (green_team_color))
		barFrame.splitBar:SetRightColor(unpack (yellow_team_color))

	--> test the splitbar
		local loopTime = 0.1
		f:SetScript("OnUpdate", function(self, deltaTime)
			loopTime = loopTime - deltaTime
			if (loopTime <= 0) then
				local value = abs(1.0 * math.sin((math.pi*2) * (GetTime() * 0.1)))
				local value = math.random()
				barFrame.splitBar:SetValueWithAnimation(value)
				loopTime = 0.1
			end
		end)
end

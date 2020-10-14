
local debugmode = false

local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details_DeathGraphs")
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

--> create the plugin object
	local DeathGraphs = _detalhes:NewPluginObject ("Details_DeathGraphs", DETAILSPLUGIN_ALWAYSENABLED)
	tinsert (UISpecialFrames, "Details_DeathGraphs")
--> main frame (shortcut)
	local DeathGraphsFrame = DeathGraphs.Frame

DeathGraphs.version_string = "v3.8"

local CONST_DBTYPE_DEATH = "deaths"
local CONST_DBTYPE_ENDURANCE = "endurance"

DeathGraphs:SetPluginDescription (Loc ["STRING_PLUGIN_DESC"])

local combat_log_event_listener = CreateFrame ("frame")

local function CreatePluginFunctions()

	function DeathGraphs:DebugMsg (msg, sec)
		if (debugmode) then
			DeathGraphs:Msg (msg, sec)
		end
	end

	function DeathGraphs.RefreshWindow()
		if (not DeathGraphs.frames_built) then
			_detalhes.DeathGraphsWindowBuilder (DeathGraphs)
			_detalhes.DeathGraphsWindowBuilder = nil
			DeathGraphs.frames_built = true
			
			local current_segment = DeathGraphs:GetCurrentCombat()
			if (current_segment and current_segment.is_boss and current_segment.is_boss.diff and current_segment.is_boss.id) then
				DeathGraphs.db.last_boss = DeathGraphs.last_encounter_hash or ("" .. current_segment.is_boss.id .. current_segment.is_boss.diff)
			end
			
			DeathGraphs.db.showing_type = 3
		end

		DeathGraphs:Refresh()
		
	end
	
	function DeathGraphs:OpenWindow()
		if (not DeathGraphs.frames_built) then
			_detalhes.DeathGraphsWindowBuilder (DeathGraphs)
			_detalhes.DeathGraphsWindowBuilder = nil
			DeathGraphs.frames_built = true
			
			local current_segment = DeathGraphs:GetCurrentCombat()
			if (current_segment and current_segment.is_boss and current_segment.is_boss.diff and current_segment.is_boss.id) then
				DeathGraphs.db.last_boss = DeathGraphs.last_encounter_hash or ("" .. current_segment.is_boss.id .. current_segment.is_boss.diff)
			end
			
			DeathGraphs.db.showing_type = 3
		end

		DeathGraphs:Refresh()
		DetailsPluginContainerWindow.OpenPlugin (DeathGraphs)
	end
	
	function DeathGraphs:CloseWindow()
		DeathGraphsFrame:Hide()
	end
	
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

		--build the menu options
			--> death log
			CoolTip:AddLine ("Advanced Death Log")
			CoolTip:AddMenu (1, function() 
				DeathGraphs:OpenWindow()
				DeathGraphs:HideAll()
				DeathGraphs:ShowCurrent()
				DeathGraphs:RefreshButtons()

				CoolTip:Hide()
			end, "main")
			CoolTip:AddIcon ([[Interface\WORLDSTATEFRAME\SkullBones]], 1, 1, 16, 16, 4/64, 28/64, 4/64, 28/64, "orange")
		
			--> enemy spell timeline
			CoolTip:AddLine ("Boss Ability Timeline")
			CoolTip:AddMenu (1, function() 
				DeathGraphs:OpenWindow()
				DeathGraphs:HideAll()
				DeathGraphs:ShowTimeline()
				DeathGraphs:RefreshButtons()

				CoolTip:Hide()
			end, "main")
			CoolTip:AddIcon ([[Interface\Transmogrify\transmog-tooltip-arrow]], 1, 1, 16, 14, 0, 1, 0, 1, "orange")

			--> player endurance
			CoolTip:AddLine ("Player Endurance")
			CoolTip:AddMenu (1, function() 
				DeathGraphs:OpenWindow()
				DeathGraphs:HideAll()
				DeathGraphs:ShowEndurance()
				DeathGraphs:RefreshButtons()

				CoolTip:Hide()
			end, "main")
			CoolTip:AddIcon ([[Interface\RAIDFRAME\Raid-Icon-Rez]], 1, 1, 16, 16, 0.03, 0.97, 0, 1, "orange")

		--apply the backdrop settings to the menu
		Details:FormatCooltipBackdrop()
		CoolTip:SetOwner (DEATHGRAPHICS_BUTTON, "bottom", "top", 0, 0)
		CoolTip:ShowCooltip()
	end	
	
	DeathGraphs.ToolbarButton = DeathGraphs.ToolBar:NewPluginToolbarButton (DeathGraphs.OpenWindow, "Interface\\AddOns\\Details_DeathGraphs\\icon", Loc ["STRING_PLUGIN_NAME"], Loc ["STRING_TOOLTIP"], 16, 16, "DEATHGRAPHICS_BUTTON", cooltip_menu)
	DeathGraphs.ToolbarButton.shadow = true
	
	function DeathGraphs:CanShowIcon()
		if (self.db.show_icon == 1) then
			local found_something = false
			
			for _, boss in pairs (DeathGraphs.deaths_database) do
				if (boss) then
					found_something = true
					break
				end
			end
			
			if (not found_something) then
				for _, boss in pairs (DeathGraphs.endurance_database) do
					if (boss) then
						found_something = true
						break
					end
				end
			end
			
			if (found_something) then
				DeathGraphs:ShowToolbarIcon (DeathGraphs.ToolbarButton, "star")
			else
				DeathGraphs:HideToolbarIcon (DeathGraphs.ToolbarButton)
			end
		end
	end
	
	function DeathGraphs:HideIcon()
		DeathGraphs:HideToolbarIcon (DeathGraphs.ToolbarButton)
	end

	function DeathGraphs:OnDetailsEvent (event, ...)
		if (event == "HIDE") then --> plugin hidded, disabled
			self.open = false
		
		elseif (event == "SHOW") then --> plugin hidded, disabled
			self.open = true
			
			if (not DeathGraphs.db.first_run) then
			
				DeathGraphs.db.first_run = true
			
				--> first run
				local welcome = CreateFrame ("frame", nil, DeathGraphsFrame, "BackdropTemplate")
				welcome:SetFrameStrata ("TOOLTIP")
				welcome:SetPoint ("center", DeathGraphsFrame, "center")
				welcome:SetSize (400, 300)
				DeathGraphs.welcome_panel = welcome
				welcome:Show()
				welcome:SetBackdrop ({edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8,
				bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 130, insets = {left = 1, right = 1, top = 5, bottom = 5}})
				
				local str = _detalhes.gump:CreateLabel (welcome, Loc ["STRING_PLUGIN_WELCOME"], 
				nil, nil, "GameFontNormal")
				str:SetPoint (15, -15)
				str:SetWidth (370)
				
				local close_button = _detalhes.gump:CreateButton (welcome, function() welcome:Hide() end, 86, 16, "Close")
				close_button:InstallCustomTexture()
				close_button:SetPoint ("center", welcome, "center")
				close_button:SetPoint ("bottom", welcome, "bottom", 0, 10)
			end
			
		elseif (event == "COMBAT_BOSS_FOUND") then --> is a boss encounter 
			DeathGraphs.EnemySkillTable = {}
			DeathGraphs.EnemySkillTableDelay = {}
			
			combat_log_event_listener:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
			
			if (not DeathGraphs.BossEncounterStartAt) then
				DeathGraphs.BossEncounterStartAt = GetTime()
			end
		
		elseif (event == "COMBAT_PLAYER_ENTER") then --> combat started
			DeathGraphs.BossEncounterStartAt = GetTime()
		
		elseif (event == "COMBAT_PLAYER_LEAVE") then --> combat ended
			DeathGraphs:DebugMsg ("combat finished -> calling CombatFinished()")
			DeathGraphs:CombatFinished (...)
			combat_log_event_listener:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
			
		elseif (event == "PLUGIN_DISABLED") then
			DeathGraphs:HideIcon()
			
		elseif (event == "PLUGIN_ENABLED" or event == "DETAILS_STARTED") then
			DeathGraphs:CanShowIcon()

		end
	end
	
	DeathGraphsFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")

	function DeathGraphs:GetEncounterDiffString (diffInteger)
		if (diffInteger == 17) then
			return "Raid Finder"
			
		elseif (diffInteger == 16) then
			return "Mythic"
			
		elseif (diffInteger == 15) then
			return "Heroic"
			
		elseif (diffInteger == 14) then
			return "Normal"
		end
	end
	
	function DeathGraphs:GetPlayerTable (boss_table, player_name)
	
		local player_table = boss_table.player_db [player_name]
		if (player_table) then
			return player_table
		end
		
		if (boss_table.type == CONST_DBTYPE_DEATH) then
			local t = {
				overall = {},
				deaths = {},
				name = player_name,
				class = select (2, UnitClass (player_name))
			}
			boss_table.player_db [player_name] = t
			return t
			
		elseif (boss_table.type == CONST_DBTYPE_ENDURANCE) then
			local t = {
				points = 0,
				encounters = 0,
				deaths = {},
				class = select (2, UnitClass (player_name))
			}
			boss_table.player_db [player_name] = t
			return t
			
		end
	end

	function DeathGraphs:GetBossTable (encounter_id, boss, type)
	
		local db_table
		if (type == CONST_DBTYPE_DEATH) then
			db_table = DeathGraphs.deaths_database
		elseif (type == CONST_DBTYPE_ENDURANCE) then
			db_table = DeathGraphs.endurance_database
		end
	
		local hash
		if (boss) then
			hash = "" .. encounter_id .. boss.diff
		else
			hash = "" .. encounter_id
		end
	
		local boss_table = db_table [hash]
		if (boss_table) then
			return boss_table
		end
	
		local t = {
			player_db = {},
			id = encounter_id,
			name = boss.name,
			diff = boss.diff,
			hash = hash,
			boss_table = table_deepcopy (boss)
		}
		
		if (type == CONST_DBTYPE_DEATH) then
			t.type = CONST_DBTYPE_DEATH
			DeathGraphs.deaths_database [hash] = t
			
		elseif (type == CONST_DBTYPE_ENDURANCE) then
			t.type = CONST_DBTYPE_ENDURANCE
			DeathGraphs.endurance_database [hash] = t
		end
	
		return t
	end
	
	function DeathGraphs:CombatFinished (combat)
		
		if (not DeathGraphs.EnemySkillTable) then
			--print ("error 1")
			return
		end
		
		local difficult = combat:GetDifficulty()
		
		if (difficult) then
			--> normal mode
			if (difficult == 14) then
				if (not DeathGraphs.db.captures [2]) then
					DeathGraphs:DebugMsg ("Normal mode isn't active, not recording this segment.")
					return
				end
			--> heroic mode
			elseif (difficult == 15) then
				if (not DeathGraphs.db.captures [3]) then
					DeathGraphs:DebugMsg ("Heroic mode isn't active, not recording this segment.")
					return
				end
			--> raid finder
			elseif (difficult == 17) then
				if (not DeathGraphs.db.captures [1]) then
					DeathGraphs:DebugMsg ("Raid Finder mode isn't active, not recording this segment.")
					return
				end
			--> mythic
			elseif (difficult == 16) then
				if (not DeathGraphs.db.captures [4]) then
					DeathGraphs:DebugMsg ("Mythic mode isn't active, not recording this segment.")
					return
				end
			else
				return
			end
		end

		--> read all deaths
	
		local boss = combat:GetBossInfo()
		DeathGraphs:DebugMsg ("bossinfo", boss)
		
		DeathGraphs.db.last_combat_id = DeathGraphs.combat_id
		
		if (boss) then
		
			DeathGraphs:DebugMsg ("boss found", boss.name)
		
			local EI = DeathGraphs:GetEncounterIdFromBossIndex (boss.mapid, boss.index)
			if (EI) then
			
				DeathGraphs:DebugMsg ("boss EI: " .. EI .. " diff: " .. combat:GetDifficulty())
			
				local diff = combat:GetDifficulty()
				if (not diff) then
					return
				end
			
				DeathGraphs:DebugMsg ("" .. EI .. boss.diff)
			
				local boss_table = DeathGraphs:GetBossTable (EI, boss, CONST_DBTYPE_DEATH)
				local endurance_table = DeathGraphs:GetBossTable (EI, boss, CONST_DBTYPE_ENDURANCE)
				
				DeathGraphs.last_encounter_hash = "" .. EI .. boss.diff
				
				--> iterate beetween deaths occured in latest encounter
				local death_list = combat:GetDeaths()
				local endurance_failed = {}
				
				DeathGraphs:DebugMsg ("deaths: " .. #death_list)
				
				if (#death_list > 0) then
					
					--> get raid size
					--local size = select (5, GetInstanceInfo())
					if (combat:GetCombatTime() > 40) then
						local group_size = GetNumGroupMembers()
						local size = group_size
						
						local max_endurance = DeathGraphs.db.endurance_threshold
						local max_deaths = DeathGraphs.db.deaths_threshold
						local max_deaths_for_current = DeathGraphs.db.max_deaths_for_current
						
						local deaths_stored = 0
						
						--> get boss icon (for last try deaths)
						local L, R, T, B, Texture = DeathGraphs:GetBossIcon (boss.mapid, boss.index)
						--> build the table (for last try deaths)
						local current_table = {bossname = combat.is_boss.name, timeelapsed = combat:GetCombatTime(), bossicon = {L, R, T, B, Texture}, date = combat:GetEndTime(), deaths = {}}
						--> and add to the database
						tinsert (DeathGraphs.current_database, 1, current_table)
						--> check if there is too much segments
						if (#DeathGraphs.current_database > DeathGraphs.db.max_segments_for_current) then
							tremove (DeathGraphs.current_database)
						end						
						
						--print ("ADL:", combat.is_boss.name, combat:GetCombatTime())
						
						--> timeline stuff, spellcast
						DeathGraphs.graph_database [DeathGraphs.last_encounter_hash] = DeathGraphs.graph_database [DeathGraphs.last_encounter_hash] or {deaths = {}, spells = {}, ids = {}}
						local timeline_boss = DeathGraphs.graph_database [DeathGraphs.last_encounter_hash]
						
						local timenow = time()
						
						--> parse all spells:
						local unpack = unpack
						for index, t in ipairs (DeathGraphs.EnemySkillTable) do
							--> get the values
							local TimeAt, SpellId, SpellName = unpack (t)
							--> check and create the table for this spell
							timeline_boss.spells [SpellName] = timeline_boss.spells [SpellName] or {}
							--> save the spellId for this spell
							timeline_boss.ids [SpellName] = SpellId
							--> add the spell to the table
							tinsert (timeline_boss.spells [SpellName], {TimeAt, timenow})
						end
						
						local max_timeline_deaths = DeathGraphs.db.max_deaths_for_timeline
						
						wipe (DeathGraphs.EnemySkillTable) --> unload from memory
						
						--> hierarchy for the new graph
						-- Database -> [Combat Hash (EncounterId + Boss Diff Id)] = {}  Hash
						-- Combat Hash (EncounterId + Boss Diff Id) -> [SpellId] = {}  Hash
						-- SpellId -> [Index] = {}  Numeric
						-- Indexed -> TimeAt, time()
						
						--> iterate amoung deaths
						for i, t in ipairs (death_list) do
						
							-------------------------------------
							--> for 'last try' deaths stuff
								local _, class = UnitClass (t[3])
								local playername, playerclass, deathtime, deathcombattime, deathtimestring, playermaxhealth, deathevents, lastcooldown = DeathGraphs:UnpackDeathTable (t)
								if (#current_table.deaths < max_deaths_for_current) then
									tinsert (current_table.deaths, {name = playername, class = playerclass, time = deathtime, timestring = deathtimestring, timeofdeath = deathcombattime, events = deathevents, maxhealth = playermaxhealth})
								end
							-------------------------------------
						
							if (deaths_stored < max_deaths) then
								local player_table = DeathGraphs:GetPlayerTable (boss_table, t[3])
							
								deaths_stored = deaths_stored + 1
							
								--> store death
								local d = table_deepcopy (t[1])
								
								local last = d [#d]
								if (last [4]) then
									if (type (last[1]) == "number" and last[1] == 3) then
										tremove (d, #d)
									end
								end
								
								while (#d > 16) do
									tremove (d, 1)
								end
								
								--> store overall
								local d_stored = 0
								local time_of_death = t[2]
								
							end --if deaths_stored < max_deaths

							--> store endurance
								if (i <= max_endurance) then
									local player_table = DeathGraphs:GetPlayerTable (endurance_table, t[3])
									
									if (endurance_failed [t[3]]) then
										player_table.points = player_table.points + 80
									else
										player_table.points = player_table.points + 90
									end
									
									player_table.encounters = player_table.encounters + 1
									
									local last_hit = DeathGraphs:GetLastHit (t[1])
									tinsert (player_table.deaths, {combat.is_boss.try_number or 0, t.dead_at, last_hit})
									endurance_failed [t[3]] = true
								end
							
							--> timeline storage
								if (i <= max_timeline_deaths) then
									--playername, playerclass, deathtime, deathcombattime, deathtimestring, playermaxhealth, deathevents, lastcooldown
									--combat time
									local TimeAt = floor (deathcombattime)
									--add to the table
									timeline_boss.deaths [TimeAt] = timeline_boss.deaths [TimeAt] or {}
									tinsert (timeline_boss.deaths [TimeAt], timenow)
								end
							
							--> everything is on max
								if (i > max_endurance and deaths_stored >= max_deaths and i > max_timeline_deaths) then
									break
								end
							
						end --loop
					end --combat time > 40
				end --#death_list > 0
				
				--> close the rest of endurance
				if (combat:GetCombatTime() > 40) then
					for i = 1, GetNumGroupMembers(), 1 do
						local player_name, player_realm = UnitName ("raid" .. i)
						if (player_realm and player_realm ~= "") then
							player_name = player_name .. "-" .. player_realm
						end
						
						if (not endurance_failed [player_name]) then
							local damage_actor = combat (1, player_name)
							local healing_actor = combat (2, player_name)
							
							if ((damage_actor and damage_actor.total > 0) or (healing_actor and healing_actor.total > 0)) then
								local player_table = DeathGraphs:GetPlayerTable (endurance_table, player_name)
								player_table.points = player_table.points + 100
								player_table.encounters = player_table.encounters + 1
							end
						end
					end
				end
				
				DeathGraphs:CanShowIcon()
				
			end
		else
			DeathGraphs:DebugMsg ("boss not found on latest segment.")
		end --is boss
		
	end --combat finished

end

function DeathGraphs:GetLastHit (deathlog)
	for i = #deathlog, 1, -1 do
		local hit = deathlog[i]
		--[1] boolean (true)
		--added a check for index 6 which stores info about the source, it won't pass if there's no source of the damage
		if (type (hit [1]) == "boolean" and hit [1] and hit [6]) then
			local spellname = DeathGraphs.getspellinfo (hit [2]) or ""
			return spellname .. " |cFFFF3333" .. DeathGraphs:comma_value (hit [3]) .. "|r"
		end
	end
	return ""
end

local build_options_panel = function()
	local options_frame = DeathGraphs:CreatePluginOptionsFrame ("DeathGraphsOptionsWindow", Loc ["STRING_OPTIONS"], 1)
	options_frame:SetHeight (260)
	
	local menu = {
		{
			type = "range",
			get = function() return DeathGraphs.db.endurance_threshold end,
			set = function (self, fixedparam, value) DeathGraphs.db.endurance_threshold = value end,
			min = 1,
			max = 30,
			step = 1,
			desc = Loc ["STRING_ENDURANCE_DEATHS_THRESHOLD_DESC"],
			name = Loc ["STRING_ENDURANCE_DEATHS_THRESHOLD"],
		},
		{
			type = "range",
			get = function() return DeathGraphs.db.max_deaths_for_timeline end,
			set = function (self, fixedparam, value) DeathGraphs.db.max_deaths_for_timeline = value end,
			min = 1,
			max = 30,
			step = 1,
			desc = Loc ["STRING_TIMELINE_DEATHS_THRESHOLD_DESC"],
			name = Loc ["STRING_TIMELINE_DEATHS_THRESHOLD"],
		},
		{
			type = "range",
			get = function() return DeathGraphs.db.max_segments_for_current end,
			set = function (self, fixedparam, value) DeathGraphs.db.max_segments_for_current = value end,
			min = 1,
			max = 10,
			step = 1,
			desc = Loc ["STRING_ENCOUNTER_MAXSEGMENTS_DESC"],
			name = Loc ["STRING_ENCOUNTER_MAXSEGMENTS"],
		},

		{blank = true},
		{
			type = "toggle",
			name = Loc ["STRING_RAIDFINDER"],
			desc = Loc ["STRING_RAIDFINDER_DESC"],
			order = 1,
			get = function() return DeathGraphs.db.captures[1] end,
			set = function (self, val) 
				DeathGraphs.db.captures[1] = not DeathGraphs.db.captures[1]
			end,
		},
		{
			type = "toggle",
			name = Loc ["STRING_NORMAL"],
			desc = Loc ["STRING_NORMAL_DESC"],
			order = 1,
			get = function() return DeathGraphs.db.captures[2] end,
			set = function (self, val) 
				DeathGraphs.db.captures[2] = not DeathGraphs.db.captures[2]
			end,
		},
		{
			type = "toggle",
			name = Loc ["STRING_HEROIC"],
			desc = Loc ["STRING_HEROIC_DESC"],
			order = 1,
			get = function() return DeathGraphs.db.captures[4] end,
			set = function (self, val) 
				DeathGraphs.db.captures[3] = not DeathGraphs.db.captures[3]
			end,
		},
		{
			type = "toggle",
			name = Loc ["STRING_MYTHIC"],
			desc = Loc ["STRING_MYTHIC_DESC"],
			order = 1,
			get = function() return DeathGraphs.db.captures[4] end,
			set = function (self, val) 
				DeathGraphs.db.captures[4] = not DeathGraphs.db.captures[4]
			end,
		},
		--{blank = true},
		
	}

	local options_text_template = DeathGraphs:GetFramework():GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DeathGraphs:GetFramework():GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DeathGraphs:GetFramework():GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DeathGraphs:GetFramework():GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DeathGraphs:GetFramework():GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	DeathGraphs:GetFramework():BuildMenu (options_frame, menu, 15, -75, 360, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
	options_frame:SetBackdropColor (0, 0, 0, .9)
end

DeathGraphs.OpenOptionsPanel = function()
	if (not DeathGraphsOptionsWindow) then
		build_options_panel()
	end
	DeathGraphsOptionsWindow:Show()
end

local floor = floor

combat_log_event_listener:SetScript ("OnEvent", function (self, event, time, token, ...)
	if (token == "SPELL_CAST_SUCCESS") then --> if an actor successful casted a spell
		local hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, spellid, spellname, spelltype = ...
		if (bit.band (who_flags, 0x00000040) ~= 0) then --> check if the actor is a enemy        DeathGraphs.BossEncounterStartAt
			local t = floor (GetTime() - DeathGraphs.BossEncounterStartAt) --> get the combat time
			if (DeathGraphs.EnemySkillTableDelay [spellid] ~= t) then --> avoid a spell be recorded more than once per second
				tinsert (DeathGraphs.EnemySkillTable, {t, spellid, spellname}) --> add the spell
				DeathGraphs.EnemySkillTableDelay [spellid] = t
			end
		end
	end
end)

function DeathGraphs:OnEvent (_, event, ...)

	if (event == "ADDON_LOADED") then
		local AddonName = select (1, ...)
		if (AddonName == "Details_DeathGraphs") then
			
			if (_G._detalhes) then
				
				--> catch data
				DeathGraphs.deaths_database = DeathGraphsDBDeaths or {}
				DeathGraphsDBDeaths = DeathGraphs.deaths_database
				
				--> clean up
				local time_threshold = time() - 604800 -- one week
				for hash, bosstable in pairs (DeathGraphs.deaths_database) do
					for playername, playertable in pairs (bosstable.player_db) do
						for i = #(playertable.deaths or {}), 1, -1 do
							local this_death = playertable.deaths [i]
							if ((this_death [6] or 0) < time_threshold) then
								tremove (playertable.deaths, i)
								--print ("Death removed for player", playername, this_death [6])
							end
						end
					end
				end

				DeathGraphs.endurance_database = DeathGraphsDBEndurance or {}
				DeathGraphsDBEndurance = DeathGraphs.endurance_database
				
				--new (current deaths)
				DeathGraphs.current_database = DeathGraphsDBCurrent or {}
				DeathGraphsDBCurrent = DeathGraphs.current_database
				--new (graph stuff)
				DeathGraphs.graph_database = DeathGraphsDBGraph or {}
				DeathGraphsDBGraph = DeathGraphs.graph_database
				
				--> check old versions without endurance amount
				for bossid, bosstable in pairs (DeathGraphs.endurance_database) do
					for playername, playertable in pairs (bosstable.player_db) do
						if (not playertable.encounters) then
							DeathGraphs.endurance_database [bossid].player_db [playername] = nil
						end
					end
				end
				
			--	DeathGraphs.endurance_database -> hashboss, bosstable -> player_db -> playername, playertable -> encounters
			--	/run DeathGraphsDBEndurance=nil;DeathGraphsDBDeaths=nil
				
				--> create widgets
				CreatePluginFunctions()

				--> core version required
				local MINIMAL_DETAILS_VERSION_REQUIRED = 128
				
				local defaults = {
					show_icon = 1,
					last_boss = false,
					last_player = false,
					last_segment = false,
					last_encounter_hash = false,
					showing_type = 4,
					last_combat_id = 0,
					captures = {false, true, true, true},
					first_run = false,
					deaths_threshold = 10,
					endurance_threshold = 3,
					max_segments_for_current = 2,
					max_deaths_for_current = 20,
					max_deaths_for_timeline = 5,
					timeline_cutoff_time = 3,
					timeline_cutoff_delete_time = 3,
				}
				
				--> Install
				local install, saveddata = _G._detalhes:InstallPlugin ("TOOLBAR", Loc ["STRING_PLUGIN_NAME"], "Interface\\AddOns\\Details_DeathGraphs\\icon", DeathGraphs, "DETAILS_PLUGIN_DEATH_GRAPHICS", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", DeathGraphs.version_string, defaults)
				if (type (install) == "table" and install.error) then
					print (install.error)
				end
				
				--> Register needed events
				_G._detalhes:RegisterEvent (DeathGraphs, "COMBAT_BOSS_FOUND")
				_G._detalhes:RegisterEvent (DeathGraphs, "DETAILS_DATA_RESET")
				_G._detalhes:RegisterEvent (DeathGraphs, "COMBAT_PLAYER_LEAVE")
				_G._detalhes:RegisterEvent (DeathGraphs, "COMBAT_PLAYER_ENTER")
				
				--> store the install time for deactive tutorials by time
				DeathGraphs.db.InstalledAt = DeathGraphs.db.InstalledAt or time()
				if (not DeathGraphs.db.v1) then
					DeathGraphs.db.v1 = true
					wipe (DeathGraphsDBGraph)
				end
				
				--> embed the plugin into the plugin window
				if (DetailsPluginContainerWindow) then
					DetailsPluginContainerWindow.EmbedPlugin (DeathGraphs, DeathGraphs.Frame)
				end

			end
		end
	end
end



local UnitGroupRolesAssigned = _G.DetailsFramework.UnitGroupRolesAssigned
local wipe = _G.wipe
local C_Timer = _G.C_Timer
local CreateFrame = _G.CreateFrame
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")


--start funtion
function Details:StartMeUp() --I'll never stop!

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> row single click, this determines what happen when the user click on a bar

	--> single click row function replace
		--damage, dps, damage taken, friendly fire
			self.row_singleclick_overwrite [1] = {true, true, true, true, self.atributo_damage.ReportSingleFragsLine, self.atributo_damage.ReportEnemyDamageTaken, self.atributo_damage.ReportSingleVoidZoneLine, self.atributo_damage.ReportSingleDTBSLine}
		--healing, hps, overheal, healing taken
			self.row_singleclick_overwrite [2] = {true, true, true, true, false, self.atributo_heal.ReportSingleDamagePreventedLine} 
		--mana, rage, energy, runepower
			self.row_singleclick_overwrite [3] = {true, true, true, true} 
		--cc breaks, ress, interrupts, dispells, deaths
			self.row_singleclick_overwrite [4] = {true, true, true, true, self.atributo_misc.ReportSingleDeadLine, self.atributo_misc.ReportSingleCooldownLine, self.atributo_misc.ReportSingleBuffUptimeLine, self.atributo_misc.ReportSingleDebuffUptimeLine} 
		
		function self:ReplaceRowSingleClickFunction(attribute, sub_attribute, func)
			assert(type(attribute) == "number" and attribute >= 1 and attribute <= 4, "ReplaceRowSingleClickFunction expects a attribute index on #1 argument.")
			assert(type(sub_attribute) == "number" and sub_attribute >= 1 and sub_attribute <= 10, "ReplaceRowSingleClickFunction expects a sub attribute index on #2 argument.")
			assert(type(func) == "function", "ReplaceRowSingleClickFunction expects a function on #3 argument.")
			
			self.row_singleclick_overwrite [attribute] [sub_attribute] = func
			return true
		end
		
		self.click_to_report_color = {1, 0.8, 0, 1}
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialize

	--build frames
		--plugin container
			self:CreatePluginWindowContainer()
			self:InitializeForge() --to install into the container plugin
			self:InitializeRaidHistoryWindow()
			--self:InitializeOptionsWindow()
			
			C_Timer.After(2, function()
				self:InitializeAuraCreationWindow()
			end)
			
			self:InitializeCustomDisplayWindow()
			self:InitializeAPIWindow()
			self:InitializeRunCodeWindow()
			self:InitializePlaterIntegrationWindow()
			self:InitializeMacrosWindow()

			if (self.ocd_tracker.show_options) then
				self:InitializeCDTrackerWindow()
			end
			
		--custom window
			self.custom = self.custom or {}
			
		--micro button alert
			--"MainMenuBarMicroButton" has been removed on 9.0
			self.MicroButtonAlert = CreateFrame("frame", "DetailsMicroButtonAlert", UIParent)
			self.MicroButtonAlert.Text = self.MicroButtonAlert:CreateFontString(nil, "overlay", "GameFontNormal")
			self.MicroButtonAlert.Text:SetPoint("center")
			self.MicroButtonAlert:Hide()
			
		--actor details window
			self.playerDetailWindow = self.gump:CriaJanelaInfo()
			self.gump:Fade(self.playerDetailWindow, 1)
			
		--copy and paste window
			self:CreateCopyPasteWindow()
			self.CreateCopyPasteWindow = nil
			
	--> start instances
		if (self:GetNumInstancesAmount() == 0) then
			self:CriarInstancia()
		end
		self:GetLowerInstanceNumber()
		
	--> start time machine
		self.timeMachine:Ligar()
	
	--> update abbreviation shortcut
	
		self.atributo_damage:UpdateSelectedToKFunction()
		self.atributo_heal:UpdateSelectedToKFunction()
		self.atributo_energy:UpdateSelectedToKFunction()
		self.atributo_misc:UpdateSelectedToKFunction()
		self.atributo_custom:UpdateSelectedToKFunction()
		
	--> start instances updater
	
		self:CheckSwitchOnLogon()
	
		function _detalhes:ScheduledWindowUpdate(forced)
			if (not forced and _detalhes.in_combat) then
				return
			end
			_detalhes.scheduled_window_update = nil
			_detalhes:RefreshMainWindow(-1, true)
		end
		function _detalhes:ScheduleWindowUpdate(time, forced)
			if (_detalhes.scheduled_window_update) then
				Details.Schedules.Cancel(_detalhes.scheduled_window_update)
				_detalhes.scheduled_window_update = nil
			end
			--_detalhes.scheduled_window_update = _detalhes:ScheduleTimer("ScheduledWindowUpdate", time or 1, forced)
			_detalhes.scheduled_window_update = Details.Schedules.NewTimer(time or 1, Details.ScheduledWindowUpdate, Details, forced)
		end
	
		self:RefreshMainWindow(-1, true)
		Details:RefreshUpdater()
		
		for index = 1, #self.tabela_instancias do
			local instance = self.tabela_instancias[index]
			if (instance:IsAtiva()) then
				Details.Schedules.NewTimer(1, Details.RefreshBars, Details, instance)
				Details.Schedules.NewTimer(1, Details.InstanceReset, Details, instance)
				Details.Schedules.NewTimer(1, Details.InstanceRefreshRows, Details, instance)

				--self:ScheduleTimer("RefreshBars", 1, instance)
				--self:ScheduleTimer("InstanceReset", 1, instance)
				--self: ("InstanceRefreshRows", 1, instance)
			end
		end

		function self:RefreshAfterStartup()
		
			self:RefreshMainWindow(-1, true)
			
			local lower_instance = _detalhes:GetLowerInstanceNumber()

			for index = 1, #self.tabela_instancias do
				local instance = self.tabela_instancias [index]
				if(instance:IsAtiva()) then
					--> refresh wallpaper
					if(instance.wallpaper.enabled) then
						instance:InstanceWallpaper(true)
					else
						instance:InstanceWallpaper(false)
					end
					
					--> refresh desaturated icons if is lower instance
					if(index == lower_instance) then
						instance:DesaturateMenu()

						instance:SetAutoHideMenu(nil, nil, true)
					end
					
				end
			end
			
			--> refresh lower instance plugin icons and skin
			_detalhes.ToolBar:ReorganizeIcons()
			--> refresh skin for other windows
			if(lower_instance) then
				for i = lower_instance+1, #self.tabela_instancias do
					local instance = self:GetInstance(i)
					if (instance and instance.baseframe and instance.ativa) then
						instance:ChangeSkin()
					end
				end
			end
		
			self.RefreshAfterStartup = nil
			
			function _detalhes:CheckWallpaperAfterStartup()
				if (not _detalhes.profile_loaded) then
					Details.Schedules.NewTimer(5, Details.CheckWallpaperAfterStartup, Details)
					--return _detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 2)
				end
				
				for i = 1, self.instances_amount do
					local instance = self:GetInstance (i)
					if (instance and instance:IsEnabled()) then
						if (not instance.wallpaper.enabled) then
							instance:InstanceWallpaper (false)
						end
					
						instance.do_not_snap = true
						self.move_janela_func (instance.baseframe, true, instance, true)
						self.move_janela_func (instance.baseframe, false, instance, true)
						instance.do_not_snap = false
					end
				end
				self.CheckWallpaperAfterStartup = nil
				_detalhes.profile_loaded = nil
			end
			--_detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 5)
			Details.Schedules.NewTimer(5, Details.CheckWallpaperAfterStartup, Details)
		end

		--self:ScheduleTimer ("RefreshAfterStartup", 5)
		Details.Schedules.NewTimer(5, Details.RefreshAfterStartup, Details)

	--start garbage collector
	self.ultima_coleta = 0
	self.intervalo_coleta = 720
	self.intervalo_memoria = 180
	--self.garbagecollect = self:ScheduleRepeatingTimer ("IniciarColetaDeLixo", self.intervalo_coleta) --deprecated
	self.garbagecollect = Details.Schedules.NewTicker(self.intervalo_coleta, Details.IniciarColetaDeLixo, Details)
	self.next_memory_check = _G.time()+self.intervalo_memoria

	--player role
	self.last_assigned_role = UnitGroupRolesAssigned ("player")
		
	--> start parser
		
		--> load parser capture options
			self:CaptureRefresh()

		--> register parser events
			self.listener:RegisterEvent ("PLAYER_REGEN_DISABLED")
			self.listener:RegisterEvent ("PLAYER_REGEN_ENABLED")
			self.listener:RegisterEvent ("UNIT_PET")

			self.listener:RegisterEvent ("GROUP_ROSTER_UPDATE")
			self.listener:RegisterEvent ("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
			
			self.listener:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
			self.listener:RegisterEvent ("PLAYER_ENTERING_WORLD")
		
			self.listener:RegisterEvent ("ENCOUNTER_START")
			self.listener:RegisterEvent ("ENCOUNTER_END")
			
			self.listener:RegisterEvent ("START_TIMER")
			self.listener:RegisterEvent ("UNIT_NAME_UPDATE")

			self.listener:RegisterEvent ("PLAYER_ROLES_ASSIGNED")
			self.listener:RegisterEvent ("ROLE_CHANGED_INFORM")
			
			self.listener:RegisterEvent ("UNIT_FACTION")

			if (not _G.DetailsFramework.IsClassicWow()) then
				self.listener:RegisterEvent ("PET_BATTLE_OPENING_START")
				self.listener:RegisterEvent ("PET_BATTLE_CLOSE")
				self.listener:RegisterEvent ("PLAYER_SPECIALIZATION_CHANGED")
				self.listener:RegisterEvent ("PLAYER_TALENT_UPDATE")
				self.listener:RegisterEvent ("CHALLENGE_MODE_START")
				self.listener:RegisterEvent ("CHALLENGE_MODE_COMPLETED")
			end

			self.parser_frame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")


	--update is in group
	self.details_users = {}
	self.in_group = IsInGroup() or IsInRaid()
		
	--done
	self.initializing = nil
	
	--scan pets
	_detalhes:SchedulePetUpdate(1)
	
	--send messages gathered on initialization
	--self:ScheduleTimer ("ShowDelayMsg", 10)
	Details.Schedules.NewTimer(10, Details.ShowDelayMsg, Details)
	
	--send instance open signal
	for index, instancia in _detalhes:ListInstances() do
		if (instancia.ativa) then
			self:SendEvent ("DETAILS_INSTANCE_OPEN", nil, instancia)
		end
	end

	--send details startup done signal
	function self:AnnounceStartup()
		self:SendEvent ("DETAILS_STARTED", "SEND_TO_ALL")
		
		if (_detalhes.in_group) then
			_detalhes:SendEvent ("GROUP_ONENTER")
		else
			_detalhes:SendEvent ("GROUP_ONLEAVE")
		end
		
		_detalhes.last_zone_type = "INIT"
		_detalhes.parser_functions:ZONE_CHANGED_NEW_AREA()
		
		_detalhes.AnnounceStartup = nil
	end

	--self:ScheduleTimer ("AnnounceStartup", 5)
	Details.Schedules.NewTimer(5, Details.AnnounceStartup, Details)
	
	if (_detalhes.failed_to_load) then
		_detalhes:CancelTimer (_detalhes.failed_to_load)
		_detalhes.failed_to_load = nil
	end

	--announce alpha version
	function self:AnnounceVersion()
		for index, instancia in _detalhes:ListInstances() do
			if (instancia.ativa) then
				self.gump:Fade(instancia._version, "in", 0.1)
			end
		end
	end

	--check version
	_detalhes:CheckVersion(true)
		
	--restore cooltip anchor position, this is for the custom anchor in the screen
	_G.DetailsTooltipAnchor:Restore()
	
	--check is this is the first run
	if (self.is_first_run) then
		if (#self.custom == 0) then
			_detalhes:AddDefaultCustomDisplays()
		end
		_detalhes:FillUserCustomSpells()
	end
	
	--check is this is the first run of this version
	if (self.is_version_first_run) then

		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			lower_instance = _detalhes:GetInstance (lower_instance)

			if (lower_instance) then
				--check if there's changes in the size of the news string
				if (Details.last_changelog_size < #Loc["STRING_VERSION_LOG"]) then
					Details.last_changelog_size = #Loc["STRING_VERSION_LOG"]

					if (false and Details.auto_open_news_window) then
						C_Timer.After(5, function()
							Details.OpenNewsWindow()
						end)
					end

					if (lower_instance) then
						_G.C_Timer.After(10, function()
							if (lower_instance:IsEnabled()) then
								lower_instance:InstanceAlert(Loc ["STRING_VERSION_UPDATE"], {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, 60, {_detalhes.OpenNewsWindow}, true)
								--Details:Msg("A new version has been installed: /details news") --localize-me
								Details:Msg ("伤害统计更新了 /details news 查看更新内容（英文）")
							end
						end)
					end
				end
			end
		end
		
		_detalhes:FillUserCustomSpells()
		_detalhes:AddDefaultCustomDisplays()
	end
	
	local lower = _detalhes:GetLowerInstanceNumber()
	if (lower) then
		local instance = _detalhes:GetInstance (lower)
		if (instance) then

			--in development
			local dev_icon = instance.bgdisplay:CreateTexture (nil, "overlay")
			dev_icon:SetWidth (40)
			dev_icon:SetHeight (40)
			dev_icon:SetPoint ("bottomleft", instance.baseframe, "bottomleft", 4, 8)
			dev_icon:SetAlpha (.3)
			
			local dev_text = instance.bgdisplay:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			dev_text:SetHeight (64)
			dev_text:SetPoint ("left", dev_icon, "right", 5, 0)
			dev_text:SetTextColor (1, 1, 1)
			dev_text:SetAlpha (.3)
	
			--version
			self.gump:Fade (instance._version, 0)
			instance._version:SetText ("Details! " .. _detalhes.userversion .. " (core " .. self.realversion .. ")")
			instance._version:SetTextColor (1, 1, 1, .35)
			instance._version:SetPoint ("bottomleft", instance.baseframe, "bottomleft", 5, 1)

			if (instance.auto_switch_to_old) then
				instance:SwitchBack()
			end

			function _detalhes:FadeStartVersion()
				_detalhes.gump:Fade (dev_icon, "in", 2)
				_detalhes.gump:Fade (dev_text, "in", 2)
				self.gump:Fade (instance._version, "in", 2)
			end
			Details.Schedules.NewTimer(12, Details.FadeStartVersion, Details)
		end
	end
	
	function _detalhes:OpenOptionsWindowAtStart()
		--_detalhes:OpenOptionsWindow (_detalhes.tabela_instancias[1])
		--print (_G ["DetailsClearSegmentsButton1"]:GetSize())
		--_detalhes:OpenCustomDisplayWindow()
		--_detalhes:OpenWelcomeWindow()
	end
	--_detalhes:ScheduleTimer ("OpenOptionsWindowAtStart", 2)
	Details.Schedules.NewTimer(2, Details.OpenOptionsWindowAtStart, Details)
	--_detalhes:OpenCustomDisplayWindow()
	
	--> minimap
	pcall (_detalhes.RegisterMinimap, Details)
	
	--hot corner addon
	function _detalhes:RegisterHotCorner()
		_detalhes:DoRegisterHotCorner()
	end
	--_detalhes:ScheduleTimer ("RegisterHotCorner", 5)
	Details.Schedules.NewTimer(5, Details.RegisterHotCorner, Details)


	--restore mythic dungeon state
	_detalhes:RestoreState_CurrentMythicDungeonRun()

	--open profiler
	_detalhes:OpenProfiler()
	
	--start announcers
	_detalhes:StartAnnouncers()
	
	--open welcome
	if (self.is_first_run) then
		_G.C_Timer.After (1, function() --wait details full load the rest of the systems before executing the welcome window
			_detalhes:OpenWelcomeWindow()
		end)
	end
	
	--load broadcaster tools
	_detalhes:LoadFramesForBroadcastTools()
	_detalhes:BrokerTick()
	
	--boss mobs callbacks (DBM and BigWigs)
	Details.Schedules.NewTimer(5, Details.BossModsLink, Details)

	--limit item level life for 24Hs
	local now = _G.time()
	for guid, t in pairs (_detalhes.item_level_pool) do
		if (t.time + 86400 < now) then
			_detalhes.item_level_pool [guid] = nil
		end
	end
	
	--dailly reset of the cache for talents and specs
	local today = _G.date("%d")
	if (_detalhes.last_day ~= today) then
		wipe(_detalhes.cached_specs)
		wipe(_detalhes.cached_talents)
	end

	--> get the player spec
	C_Timer.After(2, _detalhes.parser_functions.PLAYER_SPECIALIZATION_CHANGED)

	--embed windows on the chat window
	_detalhes.chat_embed:CheckChatEmbed(true)
	
	--save the time when the addon finished  loading
	_detalhes.AddOnStartTime = _G.GetTime()
	
	if (_detalhes.player_details_window.skin ~= "ElvUI") then
		local reset_player_detail_window = function()
			_detalhes:ApplyPDWSkin("ElvUI")
		end
		C_Timer.After(2, reset_player_detail_window)
	end
	
	--coach feature startup
	Details.Coach.StartUp()

	--force the group edit be always enabled when Details! starts
	_detalhes.options_group_edit = true

	--shutdown pre-pot announcer
	Details.announce_prepots.enabled = false
	--disable the min healing to show
	Details.deathlog_healingdone_min =  1
	--remove standard skin on 9.0.1
	_detalhes.standard_skin = false
	--enforce to show 6 abilities on the tooltip
	--_detalhes.tooltip.tooltip_max_abilities = 6 freeeeeedooommmmm

	--Plater integration
	C_Timer.After(2, function()
		_detalhes:RefreshPlaterIntegration()
	end)
	
	--show warning message about classic beta
	if (not DetailsFramework.IsClassicWow()) then
		--print ("|CFFFFFF00[Details!]: Details! now has a separated version for Classic, Twitch app should give the right version, any issues report at Discord (/details discord).")
	else
		print ("|CFFFFFF00[Details!]: you're using Details! for RETAIL on Classic WOW, please get the classic version (Details! Damage Meter Classic WoW), if you need help see our Discord (/details discord).")
	end

	Details:InstallHook("HOOK_DEATH", Details.Coach.Client.SendMyDeath)

	if (math.random(10) == 1) then
		--Details:Msg("use '/details me' macro to open the player breakdown for you!")
	end

	Details.cached_specs[UnitGUID("player")] = GetSpecializationInfo(GetSpecialization() or 0)

	if (not Details.data_wipes_exp["9"]) then
		wipe(Details.encounter_spell_pool or {})
		wipe(Details.boss_mods_timers or {})
		wipe(Details.spell_school_cache or {})
		wipe(Details.spell_pool or {})
		wipe(Details.npcid_pool or {})
		wipe(Details.current_exp_raid_encounters or {})
		Details.data_wipes_exp["9"] = true
	end

	Details.boss_mods_timers.encounter_timers_dbm = Details.boss_mods_timers.encounter_timers_dbm or {}
	Details.boss_mods_timers.encounter_timers_bw = Details.boss_mods_timers.encounter_timers_bw or {}

	--clear overall data on new session
	if (_detalhes.overall_clear_logout) then
		_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
	end

	--wipe overall on torghast - REMOVE ON 10.0
	local torghastTracker = CreateFrame("frame")
	torghastTracker:RegisterEvent("JAILERS_TOWER_LEVEL_UPDATE")
	torghastTracker:SetScript("OnEvent", function(self, event, level, towerType)
		if (level == 1) then
			if (Details.overall_clear_newtorghast) then
				Details.historico:resetar_overall()
				Details:Msg ("overall data are now reset.") --localize-me
			end
		end
	end)

	function Details:InstallOkey()
		return true
	end
end

_detalhes.AddOnLoadFilesTime = _G.GetTime()










local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local UnitName = UnitName
local UnitGUID = UnitGUID
local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
local select = select
local floor = floor

local GetNumGroupMembers = GetNumGroupMembers

local ItemUpgradeInfo = LibStub ("LibItemUpgradeInfo-1.0")
--local LibGroupInSpecT = LibStub ("LibGroupInSpecT-1.1") --disabled due to classic wow
local ItemUpgradeInfo
local LibGroupInSpecT

if (DetailsFramework.IsClassicWow()) then
	ItemUpgradeInfo = false
	LibGroupInSpecT = false
end

local storageDebug = true --remember to turn this to false!
local store_instances = _detalhes.InstancesToStoreData

function _detalhes:UpdateGears()
	
	_detalhes:UpdateParser()
	_detalhes:UpdateControl()
	_detalhes:UpdateCombat()
	
end

function _detalhes:GetCoreVersion()
	return _detalhes.realversion
end

------------------------------------------------------------------------------------------------------------
--> chat hooks

	_detalhes.chat_embed = _detalhes:CreateEventListener()
	_detalhes.chat_embed.startup = true
	
	_detalhes.chat_embed.hook_settabname = function (frame, name, doNotSave)
		if (not doNotSave) then
			if (_detalhes.chat_tab_embed.enabled and _detalhes.chat_tab_embed.tab_name ~= "") then
				if (_detalhes.chat_tab_embed_onframe == frame) then
					_detalhes.chat_tab_embed.tab_name = name
					_detalhes:DelayOptionsRefresh (_detalhes:GetInstance(1))
				end
			end
		end
	end
	_detalhes.chat_embed.hook_closetab = function (frame, fallback)
		if (_detalhes.chat_tab_embed.enabled and _detalhes.chat_tab_embed.tab_name ~= "") then
			if (_detalhes.chat_tab_embed_onframe == frame) then
				_detalhes.chat_tab_embed.enabled = false
				_detalhes.chat_tab_embed.tab_name = ""
				_detalhes.chat_tab_embed_onframe = nil
				_detalhes:DelayOptionsRefresh (_detalhes:GetInstance(1))
				_detalhes.chat_embed:ReleaseEmbed()
			end
		end
	end
	hooksecurefunc ("FCF_SetWindowName", _detalhes.chat_embed.hook_settabname)
	hooksecurefunc ("FCF_Close", _detalhes.chat_embed.hook_closetab)
	
	function _detalhes.chat_embed:SetTabSettings (tab_name, is_enabled, is_single)
	
		local current_enabled_state = _detalhes.chat_tab_embed.enabled
		local current_name = _detalhes.chat_tab_embed.tab_name
	
		tab_name = tab_name or _detalhes.chat_tab_embed.tab_name
		if (is_enabled == nil) then
			is_enabled = _detalhes.chat_tab_embed.enabled
		end
		if (is_single == nil) then
			is_single = _detalhes.chat_tab_embed.single_window
		end
		
		_detalhes.chat_tab_embed.tab_name = tab_name or ""
		_detalhes.chat_tab_embed.enabled = is_enabled
		_detalhes.chat_tab_embed.single_window = is_single
		
		if (current_name ~= tab_name) then
			--> rename the tab on chat frame
			local ChatFrame = _detalhes.chat_embed:GetTab (current_name)
			if (ChatFrame) then
				FCF_SetWindowName (ChatFrame, tab_name, false)
			end
		end
		
		if (is_enabled) then
			--> was disabled, so we need to save the current window positions.
			if (not current_enabled_state) then
				local window1 = _detalhes:GetInstance (1)
				if (window1) then
					window1:SaveMainWindowPosition()
					if (window1.libwindow) then
						local pos = window1:CreatePositionTable()
						_detalhes.chat_tab_embed.w1_pos = pos
					end
				end
				local window2 = _detalhes:GetInstance (2)
				if (window2) then
					window2:SaveMainWindowPosition()
					if (window2.libwindow) then
						local pos = window2:CreatePositionTable()
						_detalhes.chat_tab_embed.w2_pos = pos
					end
				end
			end
			
			--> need to make the embed
			_detalhes.chat_embed:DoEmbed()
		else
			--> need to release the frame
			if (current_enabled_state) then
				_detalhes.chat_embed:ReleaseEmbed()
			end
		end
	end
	
	function _detalhes.chat_embed:CheckChatEmbed (is_startup)
		if (_detalhes.chat_tab_embed.enabled) then
			_detalhes.chat_embed:DoEmbed (is_startup)
		end
	end
	
	--dom 
-- 	/run _detalhes.chat_embed:SetTabSettings ("Dano", true, false)
-- 	/run _detalhes.chat_embed:SetTabSettings (nil, false, false)
--	/dump _detalhes.chat_tab_embed.tab_name

	function _detalhes.chat_embed:DelayedChatEmbed (is_startup)
		_detalhes.chat_embed.startup = nil
		_detalhes.chat_embed:DoEmbed()
	end

	function _detalhes.chat_embed:DoEmbed (is_startup)
		if (_detalhes.chat_embed.startup and not is_startup) then
			if (_detalhes.AddOnStartTime + 5 < GetTime()) then
				_detalhes.chat_embed.startup = nil
			else
				return
			end
		end
		if (is_startup) then
			return _detalhes.chat_embed:ScheduleTimer ("DelayedChatEmbed", 5)
		end
		local tabname = _detalhes.chat_tab_embed.tab_name
		
		if (_detalhes.chat_tab_embed.enabled and tabname ~= "") then
			local ChatFrame, ChatFrameTab, ChatFrameBackground = _detalhes.chat_embed:GetTab (tabname)
			
			if (not ChatFrame) then
				FCF_OpenNewWindow (tabname)
				ChatFrame, ChatFrameTab, ChatFrameBackground = _detalhes.chat_embed:GetTab (tabname)
			end
			
			if (ChatFrame) then
				for index, t in pairs (ChatFrame.messageTypeList) do
					ChatFrame_RemoveMessageGroup (ChatFrame, t)
					ChatFrame.messageTypeList [index] = nil
				end
			
				_detalhes.chat_tab_embed_onframe = ChatFrame
			
				if (_detalhes.chat_tab_embed.single_window) then
					--> only one window
					local window1 = _detalhes:GetInstance (1)
					
					window1:UngroupInstance()
					window1.baseframe:ClearAllPoints()
					
					window1.baseframe:SetParent (ChatFrame)

					window1.rowframe:SetParent (window1.baseframe)
					window1.rowframe:ClearAllPoints()
					window1.rowframe:SetAllPoints()

					window1.windowSwitchButton:SetParent (window1.baseframe)
					window1.windowSwitchButton:ClearAllPoints()
					window1.windowSwitchButton:SetAllPoints()
					
					local y_up = window1.toolbar_side == 1 and -20 or 0
					local y_down = (window1.show_statusbar and 14 or 0) + (window1.toolbar_side == 2 and 20 or 0)
					
					window1.baseframe:SetPoint ("topleft", ChatFrameBackground, "topleft", 0, y_up + _detalhes.chat_tab_embed.y_offset)
					window1.baseframe:SetPoint ("bottomright", ChatFrameBackground, "bottomright", _detalhes.chat_tab_embed.x_offset, y_down)

					window1:LockInstance (true)
					window1:SaveMainWindowPosition()
					
					local window2 = _detalhes:GetInstance (2)
					if (window2 and window2.baseframe) then
						if (window2.baseframe:GetParent() == ChatFrame) then
							--> need to detach
							_detalhes.chat_embed:ReleaseEmbed (true)
						end
					end

				else
					--> window #1 and #2
					local window1 = _detalhes:GetInstance (1)
					local window2 = _detalhes:GetInstance (2)
					if (not window2) then
						window2 = _detalhes:CriarInstancia()
					end
					
					window1:UngroupInstance()
					window2:UngroupInstance()
					window1.baseframe:ClearAllPoints()
					window2.baseframe:ClearAllPoints()
					
					window1.baseframe:SetParent (ChatFrame)
					window2.baseframe:SetParent (ChatFrame)
					window1.rowframe:SetParent (window1.baseframe)
					window2.rowframe:SetParent (window2.baseframe)

					window1.windowSwitchButton:SetParent (window1.baseframe)
					window1.windowSwitchButton:ClearAllPoints()
					window1.windowSwitchButton:SetAllPoints()
					window2.windowSwitchButton:SetParent (window2.baseframe)
					window2.windowSwitchButton:ClearAllPoints()
					window2.windowSwitchButton:SetAllPoints()

					window1:LockInstance (true)
					window2:LockInstance (true)
					
					local statusbar_enabled1 = window1.show_statusbar
					local statusbar_enabled2 = window2.show_statusbar

					table.wipe (window1.snap); table.wipe (window2.snap)
					window1.snap [3] = 2; window2.snap [1] = 1;
					window1.horizontalSnap = true; window2.horizontalSnap = true
					
					local y_up = window1.toolbar_side == 1 and -20 or 0
					local y_down = (window1.show_statusbar and 14 or 0) + (window1.toolbar_side == 2 and 20 or 0)
					
					local width = ChatFrameBackground:GetWidth() / 2
					local height = ChatFrameBackground:GetHeight() - y_down + y_up
					
					window1.baseframe:SetSize (width + (_detalhes.chat_tab_embed.x_offset/2), height + _detalhes.chat_tab_embed.y_offset)
					window2.baseframe:SetSize (width + (_detalhes.chat_tab_embed.x_offset/2), height + _detalhes.chat_tab_embed.y_offset)
					
					window1.baseframe:SetPoint ("topleft", ChatFrameBackground, "topleft", 0, y_up + _detalhes.chat_tab_embed.y_offset)
					window2.baseframe:SetPoint ("topright", ChatFrameBackground, "topright", _detalhes.chat_tab_embed.x_offset, y_up + _detalhes.chat_tab_embed.y_offset)
				
					window1:SaveMainWindowPosition()
					window2:SaveMainWindowPosition()
					
				--	/dump ChatFrame3Background:GetSize()
				end
			end
		end
	end
	
	function _detalhes.chat_embed:ReleaseEmbed (second_window)
		--> release
		local window1 = _detalhes:GetInstance (1)
		local window2 = _detalhes:GetInstance (2)
		
		if (second_window) then
			window2.baseframe:ClearAllPoints()
			window2.baseframe:SetParent (UIParent)
			window2.rowframe:SetParent (UIParent)
			window2.baseframe:SetPoint ("center", UIParent, "center", 200, 0)
			window2.rowframe:SetPoint ("center", UIParent, "center", 200, 0)
			window2:LockInstance (false)
			window2:SaveMainWindowPosition()
			
			local previous_pos = _detalhes.chat_tab_embed.w2_pos
			if (previous_pos) then
				window2:RestorePositionFromPositionTable (previous_pos)
			end
			return
		end
		
		window1.baseframe:ClearAllPoints()
		window1.baseframe:SetParent (UIParent)
		window1.rowframe:SetParent (UIParent)
		window1.baseframe:SetPoint ("center", UIParent, "center")
		window1.rowframe:SetPoint ("center", UIParent, "center")
		window1:LockInstance (false)
		window1:SaveMainWindowPosition()
		
		local previous_pos = _detalhes.chat_tab_embed.w1_pos
		if (previous_pos) then
			window1:RestorePositionFromPositionTable (previous_pos)
		end
		
		if (not _detalhes.chat_tab_embed.single_window and window2) then
			window2.baseframe:ClearAllPoints()
			window2.baseframe:SetParent (UIParent)
			window2.rowframe:SetParent (UIParent)
			window2.baseframe:SetPoint ("center", UIParent, "center", 200, 0)
			window2.rowframe:SetPoint ("center", UIParent, "center", 200, 0)
			window2:LockInstance (false)
			window2:SaveMainWindowPosition()
			
			local previous_pos = _detalhes.chat_tab_embed.w2_pos
			if (previous_pos) then
				window2:RestorePositionFromPositionTable (previous_pos)
			end
		end
	end
	
	function _detalhes.chat_embed:GetTab (tabname)
		tabname = tabname or _detalhes.chat_tab_embed.tab_name
		for i = 1, 20 do
			local tabtext = _G ["ChatFrame" .. i .. "TabText"]
			if (tabtext) then
				if (tabtext:GetText() == tabname) then
					return _G ["ChatFrame" .. i], _G ["ChatFrame" .. i .. "Tab"], _G ["ChatFrame" .. i .. "Background"], i
				end
			end
		end
	end
	
--[[
	--create a tab on chat
	--FCF_OpenNewWindow(name)
	--rename it? perhaps need to hook
	--FCF_SetWindowName(chatFrame, name, true)    --FCF_SetWindowName(3, "DDD", true)
	--/run local chatFrame = _G["ChatFrame3"]; FCF_SetWindowName(chatFrame, "DDD", true)

	--FCF_SetWindowName(frame, name, doNotSave)
	--API SetChatWindowName(frame:GetID(), name); -- set when doNotSave is false

	-- need to store the chat frame reference
	-- hook set window name and check if the rename was on our window

	--FCF_Close
	-- ^ when the window is closed
--]]

------------------------------------------------------------------------------------------------------------

function _detalhes:SetDeathLogLimit (limit)

	if (limit and type (limit) == "number" and limit >= 8) then
		_detalhes.deadlog_events = limit
		
		local combat = _detalhes.tabela_vigente

		local wipe = table.wipe
		for player_name, event_table in pairs (combat.player_last_events) do
			if (limit > #event_table) then
				for i = #event_table + 1, limit do
					event_table [i] = {}
				end
			else
				event_table.n = 1
				for _, t in ipairs (event_table) do
					wipe (t)
				end
			end
		end
		
		_detalhes:UpdateParserGears()
	end
end

------------------------------------------------------------------------------------------------------------

function _detalhes:TrackSpecsNow (track_everything)

	local spelllist = _detalhes.SpecSpellList
	
	if (not track_everything) then
		for _, actor in _detalhes.tabela_vigente[1]:ListActors() do
			if (actor:IsPlayer()) then
				for spellid, spell in pairs (actor:GetSpellList()) do
					if (spelllist [spell.id]) then
						actor.spec = spelllist [spell.id]
						_detalhes.cached_specs [actor.serial] = actor.spec
						break
					end
				end
			end
		end

		for _, actor in _detalhes.tabela_vigente[2]:ListActors() do
			if (actor:IsPlayer()) then
				for spellid, spell in pairs (actor:GetSpellList()) do
					if (spelllist [spell.id]) then
						actor.spec = spelllist [spell.id]
						_detalhes.cached_specs [actor.serial] = actor.spec
						break
					end
				end
			end
		end
	else
		local combatlist = {}
		for _, combat in ipairs (_detalhes.tabela_historico.tabelas) do
			tinsert (combatlist, combat)
		end
		tinsert (combatlist, _detalhes.tabela_vigente)
		tinsert (combatlist, _detalhes.tabela_overall)
		
		for _, combat in ipairs (combatlist) do
			for _, actor in combat[1]:ListActors() do
				if (actor:IsPlayer()) then
					for spellid, spell in pairs (actor:GetSpellList()) do
						if (spelllist [spell.id]) then
							actor.spec = spelllist [spell.id]
							_detalhes.cached_specs [actor.serial] = actor.spec
							break
						end
					end
				end
			end

			for _, actor in combat[2]:ListActors() do
				if (actor:IsPlayer()) then
					for spellid, spell in pairs (actor:GetSpellList()) do
						if (spelllist [spell.id]) then
							actor.spec = spelllist [spell.id]
							_detalhes.cached_specs [actor.serial] = actor.spec
							break
						end
					end
				end
			end
		end
	end
	
end

function _detalhes:ResetSpecCache (forced)

	local isininstance = IsInInstance()
	
	if (forced or (not isininstance and not _detalhes.in_group)) then
		table.wipe (_detalhes.cached_specs)
		
		if (_detalhes.track_specs) then
			local my_spec = DetailsFramework.GetSpecialization()
			if (type (my_spec) == "number") then
				local spec_number = DetailsFramework.GetSpecializationInfo (my_spec)
				if (type (spec_number) == "number") then
					local pguid = UnitGUID (_detalhes.playername)
					if (pguid) then
						_detalhes.cached_specs [pguid] = spec_number
					end
				end
			end
		end
	
	elseif (_detalhes.in_group and not isininstance) then
		table.wipe (_detalhes.cached_specs)
		
		if (_detalhes.track_specs) then
			if (IsInRaid()) then
				local c_combat_dmg = _detalhes.tabela_vigente [1]
				local c_combat_heal = _detalhes.tabela_vigente [2]
				for i = 1, GetNumGroupMembers(), 1 do
					local name = GetUnitName ("raid" .. i, true)
					local index = c_combat_dmg._NameIndexTable [name]
					if (index) then
						local actor = c_combat_dmg._ActorTable [index]
						if (actor and actor.grupo and actor.spec) then
							_detalhes.cached_specs [actor.serial] = actor.spec
						end
					else
						index = c_combat_heal._NameIndexTable [name]
						if (index) then
							local actor = c_combat_heal._ActorTable [index]
							if (actor and actor.grupo and actor.spec) then
								_detalhes.cached_specs [actor.serial] = actor.spec
							end
						end
					end
				end
			end
		end
	end
	
end

function _detalhes:RefreshUpdater(suggested_interval)
	local updateInterval = suggested_interval or _detalhes.update_speed
	
	if (_detalhes.streamer_config.faster_updates) then
		--> force 60 updates per second
		updateInterval = 0.016
	end
	
	if (_detalhes.atualizador) then
		--_detalhes:CancelTimer(_detalhes.atualizador)
		Details.Schedules.Cancel(_detalhes.atualizador)
	end
	--_detalhes.atualizador = _detalhes:ScheduleRepeatingTimer("RefreshMainWindow", updateInterval, -1)
	_detalhes.atualizador = Details.Schedules.NewTicker(updateInterval, Details.RefreshMainWindow, Details, -1)
end

function _detalhes:SetWindowUpdateSpeed(interval, nosave)
	if (not interval) then
		interval = _detalhes.update_speed
	end

	if (type(interval) ~= "number") then
		interval = _detalhes.update_speed or 0.3
	end
	
	if (not nosave) then
		_detalhes.update_speed = interval
	end
	
	_detalhes:RefreshUpdater(interval)
end

function _detalhes:SetUseAnimations(enabled, nosave)
	if (enabled == nil) then
		enabled = _detalhes.use_row_animations
	end
	
	if (not nosave) then
		_detalhes.use_row_animations = enabled
	end
	
	_detalhes.is_using_row_animations = enabled
end

function _detalhes:HavePerformanceProfileEnabled()
	return _detalhes.performance_profile_enabled
end

_detalhes.PerformanceIcons = {
	["RaidFinder"] = {icon = [[Interface\PvPRankBadges\PvPRank15]], color = {1, 1, 1, 1}},
	["Raid15"] = {icon = [[Interface\PvPRankBadges\PvPRank15]], color = {1, .8, 0, 1}},
	["Raid30"] = {icon = [[Interface\PvPRankBadges\PvPRank15]], color = {1, .8, 0, 1}},
	["Mythic"] = {icon = [[Interface\PvPRankBadges\PvPRank15]], color = {1, .4, 0, 1}},
	["Battleground15"] = {icon = [[Interface\PvPRankBadges\PvPRank07]], color = {1, 1, 1, 1}},
	["Battleground40"] = {icon = [[Interface\PvPRankBadges\PvPRank07]], color = {1, 1, 1, 1}},
	["Arena"] = {icon = [[Interface\PvPRankBadges\PvPRank12]], color = {1, 1, 1, 1}},
	["Dungeon"] = {icon = [[Interface\PvPRankBadges\PvPRank01]], color = {1, 1, 1, 1}},
}

function _detalhes:CheckForPerformanceProfile()
	
	local type = _detalhes:GetPerformanceRaidType()
	
	local profile = _detalhes.performance_profiles [type]
	
	if (profile and profile.enabled) then
		_detalhes:SetWindowUpdateSpeed(profile.update_speed, true)
		_detalhes:SetUseAnimations(profile.use_row_animations, true)
		_detalhes:CaptureSet(profile.damage, "damage")
		_detalhes:CaptureSet(profile.heal, "heal")
		_detalhes:CaptureSet(profile.energy, "energy")
		_detalhes:CaptureSet(profile.miscdata, "miscdata")
		_detalhes:CaptureSet(profile.aura, "aura")
		
		if (not _detalhes.performance_profile_lastenabled or _detalhes.performance_profile_lastenabled ~= type) then
			_detalhes:InstanceAlert (Loc ["STRING_OPTIONS_PERFORMANCE_PROFILE_LOAD"] .. type, {_detalhes.PerformanceIcons [type].icon, 14, 14, false, 0, 1, 0, 1, unpack (_detalhes.PerformanceIcons [type].color)} , 5, {_detalhes.empty_function})
		end
		
		_detalhes.performance_profile_enabled = type
		_detalhes.performance_profile_lastenabled = type
	else
		_detalhes:SetWindowUpdateSpeed(_detalhes.update_speed)
		_detalhes:SetUseAnimations(_detalhes.use_row_animations)
		_detalhes:CaptureSet(_detalhes.capture_real ["damage"], "damage")
		_detalhes:CaptureSet(_detalhes.capture_real ["heal"], "heal")
		_detalhes:CaptureSet(_detalhes.capture_real ["energy"], "energy")
		_detalhes:CaptureSet(_detalhes.capture_real ["miscdata"], "miscdata")
		_detalhes:CaptureSet(_detalhes.capture_real ["aura"], "aura")
		_detalhes.performance_profile_enabled = nil
	end
	
end

function _detalhes:GetPerformanceRaidType()

	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()

	if (type == "none") then
		return nil
	end
	
	if (type == "pvp") then
		if (maxPlayers == 40) then
			return "Battleground40"
		elseif (maxPlayers == 15) then
			return "Battleground15"
		else
			return nil
		end
	end
	
	if (type == "arena") then
		return "Arena"
	end

	if (type == "raid") then
		--mythic
		if (difficulty == 15) then
			return "Mythic"
		end
		
		--raid finder
		if (difficulty == 7) then
			return "RaidFinder"
		end
		
		--flex
		if (difficulty == 14) then
			if (GetNumGroupMembers() > 15) then
				return "Raid30"
			else
				return "Raid15"
			end
		end
		
		--normal heroic
		if (maxPlayers == 10) then
			return "Raid15"
		elseif (maxPlayers == 25) then
			return "Raid30"
		end
	end
	
	if (type == "party") then
		return "Dungeon"
	end
	
	return nil
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> background tasks


local background_tasks = {}
local task_timers = {
	["LOW"] = 30,
	["MEDIUM"] = 18,
	["HIGH"] = 10,
}

function _detalhes:RegisterBackgroundTask (name, func, priority, ...)

	assert (type (self) == "table", "RegisterBackgroundTask 'self' must be a table.")
	assert (type (name) == "string", "RegisterBackgroundTask param #1 must be a string.")
	if (type (func) == "string") then
		assert (type (self [func]) == "function", "RegisterBackgroundTask param #2 function not found on main object.")
	else
		assert (type (func) == "function", "RegisterBackgroundTask param #2 expect a function or function name.")
	end
	
	priority = priority or "LOW"
	priority = string.upper (priority)
	if (not task_timers [priority]) then
		priority = "LOW"
	end

	if (background_tasks [name]) then
		background_tasks [name].func = func
		background_tasks [name].priority = priority
		background_tasks [name].args = {...}
		background_tasks [name].args_amt = select ("#", ...)
		background_tasks [name].object = self
		return
	else
		background_tasks [name] = {func = func, lastexec = time(), priority = priority, nextexec = time() + task_timers [priority] * 60, args = {...}, args_amt = select ("#", ...), object = self}
	end
end

function _detalhes:UnregisterBackgroundTask (name)
	background_tasks [name] = nil
end

function _detalhes:DoBackgroundTasks()
	if (_detalhes:GetZoneType() ~= "none" or _detalhes:InGroup()) then
		return
	end
	
	local t = time()
	
	for taskName, taskTable in pairs (background_tasks) do 
		if (t > taskTable.nextexec) then
			if (type (taskTable.func) == "string") then
				taskTable.object [taskTable.func] (taskTable.object, unpack (taskTable.args, 1, taskTable.args_amt))
			else
				taskTable.func (unpack (taskTable.args, 1, taskTable.args_amt))
			end

			taskTable.nextexec = random (30, 120) + t + (task_timers [taskTable.priority] * 60)
		end
	end
end

_detalhes.background_tasks_loop = _detalhes:ScheduleRepeatingTimer ("DoBackgroundTasks", 120)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> storage stuff ~storage

--global database
_detalhes.storage = {}

function _detalhes.storage:OpenRaidStorage()
	--> check if the storage is already loaded
	if (not IsAddOnLoaded ("Details_DataStorage")) then
		local loaded, reason = LoadAddOn ("Details_DataStorage")
		if (not loaded) then
			return
		end
	end
	
	--> get the storage table
	local db = DetailsDataStorage
	
	if (not db and _detalhes.CreateStorageDB) then
		db = _detalhes:CreateStorageDB()
		if (not db) then
			return
		end
	elseif (not db) then
		return
	end

	return db
end

function _detalhes.storage:HaveDataForEncounter (diff, encounter_id, guild_name)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	if (guild_name and type (guild_name) == "boolean") then
		guild_name = GetGuildInfo ("player")
	end
	
	local table = db [diff]
	if (table) then
		local encounters = table [encounter_id]
		if (encounters) then
			--> didn't requested a guild name, so just return 'we have data for this encounter'
			if (not guild_name) then
				return true
			end
			
			--> data for a specific guild is requested, check if there is data for the guild
			for index, encounter in ipairs (encounters) do
				if (encounter.guild == guild_name) then
					return true
				end
			end
		end
	end
end

function _detalhes.storage:GetBestFromGuild (diff, encounter_id, role, dps, guild_name)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	if (not guild_name) then
		guild_name = GetGuildInfo ("player")
	end
	
	if (not guild_name) then
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) GetBestFromGuild() guild name invalid.")
		end
		return
	end
	
	local best = 0
	local bestdps = 0
	local bestplayername
	local onencounter
	local bestactor
	
	if (not role) then
		role = "damage"
	end
	role = string.lower (role)
	if (role == "damager") then
		role = "damage"
	elseif (role == "healer") then
		role = "healing"
	end
	
	local table = db [diff]
	if (table) then
		local encounters = table [encounter_id]
		if (encounters) then
			for index, encounter in ipairs (encounters) do
				if (encounter.guild == guild_name) then
					local players = encounter [role]
					if (players) then
						for playername, t in pairs (players) do
							if (dps) then
								if (t[1]/encounter.elapsed > bestdps) then
									bestdps = t[1]/encounter.elapsed
									bestplayername = playername
									onencounter = encounter
									bestactor = t
								end
							else
								if (t[1] > best) then
									best = t [1]
									bestplayername = playername
									onencounter = encounter
									bestactor = t
								end

							end
						end
					end
				end
			end
		end
	end
	
	return t, onencounter
end

function _detalhes.storage:GetPlayerGuildRank (diff, encounter_id, role, playername, dps, guild_name)

	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	if (not guild_name) then
		guild_name = GetGuildInfo ("player")
	end
	
	if (not guild_name) then
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) GetBestFromGuild() guild name invalid.")
		end
		return
	end
	
	if (not role) then
		role = "damage"
	end
	role = string.lower (role)
	if (role == "damager") then
		role = "damage"
	elseif (role == "healer") then
		role = "healing"
	end
	
	local playerScore = {}
	
	local _table = db [diff]
	if (_table) then
		local encounters = _table [encounter_id]
		if (encounters) then
			for index, encounter in ipairs (encounters) do
				if (encounter.guild == guild_name) then
					local roleTable = encounter [role]
					for playerName, playerTable in pairs (roleTable) do
					
						if (not playerScore [playerName]) then
							playerScore [playerName] = {0, 0, {}}
						end
					
						local total = playerTable[1]
						local persecond = total / encounter.elapsed
						
						if (dps) then
							if (persecond > playerScore [playerName][2]) then
								playerScore [playerName][1] = total
								playerScore [playerName][2] = total / encounter.elapsed
								playerScore [playerName][3] = playerTable
								playerScore [playerName][4] = encounter
							end
						else
							if (total > playerScore [playerName][1]) then
								playerScore [playerName][1] = total
								playerScore [playerName][2] = total / encounter.elapsed
								playerScore [playerName][3] = playerTable
								playerScore [playerName][4] = encounter
							end
						end
					end
				end
			end
			
			if (not playerScore [playername]) then
				return
			end
			
			local t = {}
			for playerName, playerTable in pairs (playerScore) do
				playerTable [5]  = playerName
				tinsert (t, playerTable)
			end
			
			table.sort (t, dps and _detalhes.Sort2 or _detalhes.Sort1)
			
			for i = 1, #t do
				if (t[i][5] == playername) then
					return t[i][3], t[i][4], i
				end
			end
		end
	end

end

function _detalhes.storage:GetBestFromPlayer (diff, encounter_id, role, playername, dps)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		print("DB noot found on GetBestFromPlayer()")
		return
	end
	
	local best
	local onencounter
	local topdps
	
	if (not role) then
		role = "damage"
	end
	role = string.lower (role)
	if (role == "damager") then
		role = "damage"
	elseif (role == "healer") then
		role = "healing"
	end
	
	local table = db [diff]
	if (table) then
		local encounters = table [encounter_id]
		if (encounters) then
			for index, encounter in ipairs (encounters) do
				local player = encounter [role] and encounter [role] [playername]
				if (player) then
					if (best) then
						if (dps) then
							if (player[1]/encounter.elapsed > topdps) then
								onencounter = encounter
								best = player
								topdps = player[1]/encounter.elapsed
							end
						else
							if (player[1] > best[1]) then
								onencounter = encounter
								best = player
							end
						end
					else
						onencounter = encounter
						best = player
						topdps = player[1]/encounter.elapsed
					end
				end
			end
		end
	end
	
	return best, onencounter
end

function _detalhes.storage:DBGuildSync()

	_detalhes:SendGuildData ("GS", "R")
	
end

local OnlyFromCurrentRaidTier = true
local encounter_is_current_tier = function (encounterID)
	if (OnlyFromCurrentRaidTier) then
		local mapID = _detalhes:GetInstanceIdFromEncounterId (encounterID)
		if (mapID) then
			--> if isn'y the mapID in the table to save data
			if (not _detalhes.InstancesToStoreData [mapID]) then
				return false
			end
		else
			return false
		end
	end
	return true
end

local have_encounter = function (db, ID)
	local minTime = ID - 120
	local maxTime = ID + 120
	
	for diff, diffTable in pairs (db or {}) do
		if (type (diffTable) == "table") then
			for encounterID, encounterTable in pairs (diffTable) do
				for index, encounter in ipairs (encounterTable) do
					--check if the encounter fits in the timespam window
					if (encounter.time >= minTime and encounter.time <= maxTime) then
						return true
					end
					if (encounter.servertime) then
						if (encounter.servertime >= minTime and encounter.servertime <= maxTime) then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

local have_recent_requested_encounter = function (ID)
	local minTime = ID - 120
	local maxTime = ID + 120
	
	for requestedID, _ in pairs (_detalhes.RecentRequestedIDs) do
		if (requestedID >= minTime and requestedID <= maxTime) then
			return true
		end
	end
end

--remote call RoS
function _detalhes.storage:GetIDsToGuildSync()
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	local IDs = {}
	
	--build the encounter ID list
	for diff, diffTable in pairs (db or {}) do
		if (type (diffTable) == "table") then
			for encounterID, encounterTable in pairs (diffTable) do
				if (encounter_is_current_tier (encounterID)) then
					for index, encounter in ipairs (encounterTable) do
						if (encounter.servertime) then
							tinsert (IDs, encounter.servertime)
						end
					end
				end
			end
		end
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) [RoS-EncounterSync] sending " .. #IDs .. " IDs.")
	end
	
	return IDs
end


--local call RoC - received the encounter IDS - need to know which fights is missing
function _detalhes.storage:CheckMissingIDsToGuildSync (IDsList)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	if (type (IDsList) ~= "table") then
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) [RoS-EncounterSync] RoC IDsList isn't a table.")
		end
		return
	end
	
	--this will prevent to request the same fight from multiple people
	_detalhes.RecentRequestedIDs = _detalhes.RecentRequestedIDs or {}
	
	--store the IDs which need to be sync
	local RequestIDs = {}
	
	--check missing IDs
	for index, ID in ipairs (IDsList) do
		if (not have_encounter (db, ID)) then
			if (not have_recent_requested_encounter (ID)) then
				tinsert (RequestIDs, ID)
				_detalhes.RecentRequestedIDs [ID] = true
			end
		end
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) [RoC-EncounterSync] RoS found " .. #RequestIDs .. " encounters out dated.")
	end
	
	return RequestIDs
end

--remote call RoS - build the encounter list from the IDsList
function _detalhes.storage:BuildEncounterDataToGuildSync (IDsList)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	if (type (IDsList) ~= "table") then
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) [RoS-EncounterSync] IDsList isn't a table.")
		end
		return
	end
	
	local EncounterList = {}
	local CurrentTable = {}
	tinsert (EncounterList, CurrentTable)
	
	local AmtToSend = 0
	local MaxAmount = 0
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) [RoS-EncounterSync] the client requested " .. #IDsList .. " encounters.")
	end
	
	for index, ID in ipairs (IDsList) do
		
		for diff, diffTable in pairs (db or {}) do
			if (type (diffTable) == "table") then
				for encounterID, encounterTable in pairs (diffTable) do
					for index, encounter in ipairs (encounterTable) do
					
						if (ID == encounter.time or ID == encounter.servertime) then --> the time here is always exactly
							--send this encounter
							CurrentTable [diff] = CurrentTable [diff] or {}
							CurrentTable [diff] [encounterID] = CurrentTable [diff] [encounterID] or {}
							
							tinsert (CurrentTable [diff] [encounterID], encounter)
							
							AmtToSend = AmtToSend + 1
							MaxAmount = MaxAmount + 1
							
							if (MaxAmount == 3) then
								CurrentTable = {}
								tinsert (EncounterList, CurrentTable)
								MaxAmount = 0
							end
						end
					end
				end
			end
		end
		
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) [RoS-EncounterSync] sending " .. AmtToSend .. " encounters.")
	end
	
	return EncounterList
end


--local call RoC - add the fights to the client db
function _detalhes.storage:AddGuildSyncData (data, source)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	local AddedAmount = 0
	_detalhes.LastGuildSyncReceived = GetTime()
	
	for diff, diffTable in pairs (data) do
		if (type (diff) == "number" and type (diffTable) == "table") then
			for encounterID, encounterTable in pairs (diffTable) do
				if (type (encounterID) == "number" and type (encounterTable) == "table") then
					for index, encounter in ipairs (encounterTable) do
						--validate the encounter
						if (type (encounter.servertime) == "number" and type (encounter.time) == "number" and type (encounter.guild) == "string" and type (encounter.date) == "string" and type (encounter.healing) == "table" and type (encounter.elapsed) == "number" and type (encounter.damage) == "table") then
							--check if the encounter is from the current raiding tier
							if (encounter_is_current_tier (encounterID)) then
								--check if this encounter already has been added from another sync
								if (not have_encounter (db, encounter.servertime)) then
									db [diff] = db [diff] or {}
									db [diff] [encounterID] = db [diff] [encounterID] or {}
									
									tinsert (db [diff] [encounterID], encounter)
									
									if (_G.DetailsRaidHistoryWindow and _G.DetailsRaidHistoryWindow:IsShown()) then
										_G.DetailsRaidHistoryWindow:Refresh()
									end
									
									AddedAmount = AddedAmount + 1
								else
									if (_detalhes.debug) then
										_detalhes:Msg ("(debug) [RoS-EncounterSync] received a duplicated encounter table.")
									end
								end
							else
								if (_detalhes.debug) then
									_detalhes:Msg ("(debug) [RoS-EncounterSync] received an old tier encounter.")
								end		
							end
						else
							if (_detalhes.debug) then
								_detalhes:Msg ("(debug) [RoS-EncounterSync] received an invalid encounter table.")
							end
						end
					end
				end
			end
		end
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) [RoS-EncounterSync] added " .. AddedAmount .. " to database.")
	end
	
	if (_G.DetailsRaidHistoryWindow and _G.DetailsRaidHistoryWindow:IsShown()) then
		_G.DetailsRaidHistoryWindow:UpdateDropdowns()
		_G.DetailsRaidHistoryWindow:Refresh()
	end
end

function _detalhes.storage:ListDiffs()
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	local t = {}
	for diff, _ in pairs (db) do
		tinsert (t, diff)
	end
	return t
end

function _detalhes.storage:ListEncounters (diff)
	local db = _detalhes.storage:OpenRaidStorage()
	
	if (not db) then
		return
	end
	
	local t = {}
	if (diff) then
		local table = db [diff]
		if (table) then
			for encounter_id, _ in pairs (table) do
				tinsert (t, {diff, encounter_id})
			end
		end
	else
		for diff, table in pairs (db) do
			for encounter_id, _ in pairs (table) do
				tinsert (t, {diff, encounter_id})
			end
		end
	end
	
	return t
end

function _detalhes.storage:GetPlayerData (diff, encounter_id, playername)
	local db = _detalhes.storage:OpenRaidStorage()

	if (not db) then
		return
	end
	
	local t = {}
	assert (type (playername) == "string", "PlayerName must be a string.")

	
	if (not diff) then
		for diff, table in pairs (db) do
			if (encounter_id) then
				local encounters = table [encounter_id]
				if (encounters) then
					for i = 1, #encounters do
						local encounter = encounters [i]
						local player = encounter.healing [playername] or encounter.damage [playername]
						if (player) then
							tinsert (t, player)
						end
					end
				end
			else
				for encounter_id, encounters in pairs (table) do
					for i = 1, #encounters do
						local encounter = encounters [i]
						local player = encounter.healing [playername] or encounter.damage [playername]
						if (player) then
							tinsert (t, player)
						end
					end
				end
			end
		end
	else
		local table = db [diff]
		if (table) then
			if (encounter_id) then
				local encounters = table [encounter_id]
				if (encounters) then
					for i = 1, #encounters do
						local encounter = encounters [i]
						local player = encounter.healing [playername] or encounter.damage [playername]
						if (player) then
							tinsert (t, player)
						end
					end
				end
			else
				for encounter_id, encounters in pairs (table) do
					for i = 1, #encounters do
						local encounter = encounters [i]
						local player = encounter.healing [playername] or encounter.damage [playername]
						if (player) then
							tinsert (t, player)
						end
					end
				end
			end
		end
	end
	
	return t
end

function _detalhes.storage:GetEncounterData (diff, encounter_id, guild)
	local db = _detalhes.storage:OpenRaidStorage()

	if (not diff) then
		return db
	end

	local data = db [diff]
	
	assert (data, "Difficulty not found. Use: 14, 15 or 16.")
	assert (type (encounter_id) == "number", "EncounterId must be a number.")
	
	data = data [encounter_id]
	
	local t = {}

	if (not data) then
		return t
	end
	
	for i = 1, #data do
		local encounter = data [i]
		
		if (guild) then
			if (encounter.guild == guild) then
				tinsert (t, encounter)
			end
		else
			tinsert (t, encounter)
		end
	end
	
	return t
end

local create_storage_tables = function()
	--> get the storage table
	local db = DetailsDataStorage
	
	if (not db and _detalhes.CreateStorageDB) then
		db = _detalhes:CreateStorageDB()
		if (not db) then
			return
		end
	elseif (not db) then
		return
	end
	
	return db
end

function _detalhes.ScheduleLoadStorage()
	if (InCombatLockdown() or UnitAffectingCombat ("player")) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! storage scheduled to load (player in combat).")
		end
		_detalhes.schedule_storage_load = true
		return
	else
		if (not IsAddOnLoaded ("Details_DataStorage")) then
			local loaded, reason = LoadAddOn ("Details_DataStorage")
			if (not loaded) then
				if (_detalhes.debug) then
					print ("|cFFFFFF00Details! Storage|r: can't load storage, may be the addon is disabled.")
				end
				return
			end
			
			create_storage_tables()
		end
	end
	
	if (IsAddOnLoaded ("Details_DataStorage")) then
		_detalhes.schedule_storage_load = nil
		_detalhes.StorageLoaded = true
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! storage loaded.")
		end
	else
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! fail to load storage, scheduled once again.")
		end
		_detalhes.schedule_storage_load = true
	end
end

function _detalhes.GetStorage()
	return DetailsDataStorage
end

function _detalhes.OpenStorage()
	--if the player is in combat, this function return false, if failed to load by other reason it returns nil

	--> check if the storage is already loaded
	if (not IsAddOnLoaded ("Details_DataStorage")) then
		--> can't open it during combat
		if (InCombatLockdown() or UnitAffectingCombat ("player")) then
			if (_detalhes.debug) then
				print ("|cFFFFFF00Details! Storage|r: can't load storage due to combat.")
			end
			return false
		end
	
		local loaded, reason = LoadAddOn ("Details_DataStorage")
		if (not loaded) then
			if (_detalhes.debug) then
				print ("|cFFFFFF00Details! Storage|r: can't load storage, may be the addon is disabled.")
			end
			return
		end
		
		local db = create_storage_tables()
		
		if (db and IsAddOnLoaded ("Details_DataStorage")) then
			_detalhes.StorageLoaded = true
		end
		
		return DetailsDataStorage
	else
		return DetailsDataStorage
	end
end

Details.Database = {}

function Details.Database.LoadDB()
	--check if the storage is already loaded
	if (not IsAddOnLoaded("Details_DataStorage")) then
		local loaded, reason = LoadAddOn("Details_DataStorage")
		if (not loaded) then
			if (_detalhes.debug) then
				print ("|cFFFFFF00Details! Storage|r: can't save the encounter, couldn't load DataStorage, may be the addon is disabled.")
			end
			return
		end
	end

	--> get the storage table
	local db = _G.DetailsDataStorage
	
	if (not db and _detalhes.CreateStorageDB) then
		db = _detalhes:CreateStorageDB()
		if (not db) then
			if (_detalhes.debug) then
				print ("|cFFFFFF00Details! Storage|r: can't save the encounter, couldn't load DataStorage, may be the addon is disabled.")
			end
			return
		end
	elseif (not db) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: can't save the encounter, couldn't load DataStorage, may be the addon is disabled.")
		end
		return
	end

	return db
end

function Details.Database.GetBossKillsDB(db)
	--total kills in a boss on raid or dungeon
	local totalkills_database = db["totalkills"]
	if (not totalkills_database) then
		db["totalkills"] = {}
		totalkills_database = db["totalkills"]
	end

	return totalkills_database
end

function Details.Database.StoreWipe(combat)

	combat = combat or _detalhes.tabela_vigente

	if (not combat) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: combat not found.")
		end
		return
	end

	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()
	
	local bossCLEUID = combat.boss_info and combat.boss_info.id
	
	if (not store_instances [mapID] and not _detalhes.EncountersToStoreData [bossCLEUID]) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: instance not allowed.")
		end
		return
	end

	local boss_info = combat:GetBossInfo()
	local encounter_id = boss_info and boss_info.id
	
	if (not encounter_id) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: encounter ID not found.")
		end
		return
	end

	--get the difficulty
	local diff = combat:GetDifficulty()
	
	--database
		local db = Details.Database.LoadDB()

		local diff_storage = db [diff]
		if (not diff_storage) then
			db [diff] = {}
			diff_storage = db [diff]
		end
		
		local encounter_database = diff_storage [encounter_id]
		if (not encounter_database) then
			diff_storage [encounter_id] = {}
			encounter_database = diff_storage [encounter_id]
		end

		--total kills in a boss on raid or dungeon
		local totalkills_database = Details.Database.GetBossKillsDB(db)

		if (IsInRaid()) then
			totalkills_database[encounter_id] = totalkills_database[encounter_id] or {}
			totalkills_database[encounter_id][diff] = totalkills_database[encounter_id][diff] or {kills = 0, wipes = 0, time_fasterkill = 0, time_fasterkill_when = 0, time_incombat = 0, dps_best = 0, dps_best_when = 0, dps_best_raid = 0, dps_best_raid_when = 0}

			local bossData = totalkills_database[encounter_id][diff]

			--wipes amount
			bossData.wipes = bossData.wipes + 1

			Details:Msg("Wipe stored, you have now " .. bossData.wipes .. " wipes on this boss.")
		end
end

function Details.Database.StoreEncounter(combat)

	--note: this only runs on boss kill
	
	combat = combat or _detalhes.tabela_vigente
	
	if (not combat) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: combat not found.")
		end
		return
	end
	
	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()
	
	local bossCLEUID = combat.boss_info and combat.boss_info.id
	
	if (not store_instances [mapID] and not _detalhes.EncountersToStoreData [bossCLEUID]) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: instance not allowed.")
		end
		return
	end
	
	local boss_info = combat:GetBossInfo()
	local encounter_id = boss_info and boss_info.id
	
	if (not encounter_id) then
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: encounter ID not found.")
		end
		return
	end

	--get the difficulty
	local diff = combat:GetDifficulty()
	
	--database
		local db = Details.Database.LoadDB()

		local diff_storage = db [diff]
		if (not diff_storage) then
			db [diff] = {}
			diff_storage = db [diff]
		end
		
		local encounter_database = diff_storage [encounter_id]
		if (not encounter_database) then
			diff_storage [encounter_id] = {}
			encounter_database = diff_storage [encounter_id]
		end

		--total kills in a boss on raid or dungeon
		local totalkills_database = Details.Database.GetBossKillsDB(db)

	--> store total kills on this boss
		--if the player is facing a raid boss
		if (IsInRaid()) then
			totalkills_database[encounter_id] = totalkills_database[encounter_id] or {}
			totalkills_database[encounter_id][diff] = totalkills_database[encounter_id][diff] or {kills = 0, wipes = 0, time_fasterkill = 0, time_fasterkill_when = 0, time_incombat = 0, dps_best = 0, dps_best_when = 0, dps_best_raid = 0, dps_best_raid_when = 0}

			local bossData = totalkills_database[encounter_id][diff]
			local encounterElapsedTime = combat:GetCombatTime()

			--kills amount
			bossData.kills = bossData.kills + 1

			--best time
			if (encounterElapsedTime > bossData.time_fasterkill) then
				bossData.time_fasterkill = encounterElapsedTime
				bossData.time_fasterkill_when = time()
			end

			--total time in combat
			bossData.time_incombat = bossData.time_incombat + encounterElapsedTime

			--player best dps
			local player = combat(DETAILS_ATTRIBUTE_DAMAGE, UnitName("player"))
			if (player) then
				local playerDps = player.total / encounterElapsedTime
				if (playerDps > bossData.dps_best) then
					bossData.dps_best = playerDps
					bossData.dps_best_when = time()
				end
			end

			--raid best dps
			local raidTotalDamage = combat:GetTotal(DETAILS_ATTRIBUTE_DAMAGE, false, true)
			local raidDps = raidTotalDamage / encounterElapsedTime
			if (raidDps > bossData.dps_best_raid) then
				bossData.dps_best_raid = raidDps
				bossData.dps_best_raid_when = time()
			end

		end



	--> check for heroic and mythic
	if (storageDebug or (diff == 15 or diff == 16 or diff == 17)) then --test on raid finder:  ' or diff == 17' -- normal mode: diff == 14 or 
	
		--> check the guild name
		local match = 0
		local guildName = select (1, GetGuildInfo ("player"))
		local raid_size = GetNumGroupMembers() or 0
		
		if (not storageDebug) then
			if (guildName) then
				for i = 1, raid_size do
					local gName = select (1, GetGuildInfo ("raid" .. i)) or ""
					if (gName == guildName) then
						match = match + 1
					end
				end
				
				if (match < raid_size * 0.75 and not storageDebug) then
					if (_detalhes.debug) then
						print ("|cFFFFFF00Details! Storage|r: can't save the encounter, need at least 75% of players be from your guild.")
					end
					return
				end
			else
				if (_detalhes.debug) then
					print ("|cFFFFFF00Details! Storage|r: player isn't in a guild.")
				end
				return
			end
		else
			guildName = "Test Guild"
		end
		
		local this_combat_data = {
			damage = {},
			healing = {},
			date = date ("%H:%M %d/%m/%y"),
			time = time(),
			servertime = GetServerTime(),
			elapsed = combat:GetCombatTime(),
			guild = guildName,
		}
		
		local damage_container_hash = combat [1]._NameIndexTable
		local damage_container_pool = combat [1]._ActorTable
		
		local healing_container_hash = combat [2]._NameIndexTable
		local healing_container_pool = combat [2]._ActorTable

		for i = 1, GetNumGroupMembers() do
		
			local role = UnitGroupRolesAssigned ("raid" .. i)
			
			if (UnitIsInMyGuild ("raid" .. i)) then
				if (role == "DAMAGER" or role == "TANK") then
					local player_name, player_realm = UnitName ("raid" .. i)
					if (player_realm and player_realm ~= "") then
						player_name = player_name .. "-" .. player_realm
					end
					
					local _, _, class = UnitClass (player_name)
					
					local damage_actor = damage_container_pool [damage_container_hash [player_name]]
					if (damage_actor) then
						local guid = UnitGUID (player_name) or UnitGUID (UnitName ("raid" .. i))
						this_combat_data.damage [player_name] = {floor (damage_actor.total), _detalhes.item_level_pool [guid] and _detalhes.item_level_pool [guid].ilvl or 0, class or 0}
					end
				elseif (role == "HEALER") then
					local player_name, player_realm = UnitName ("raid" .. i)
					if (player_realm and player_realm ~= "") then
						player_name = player_name .. "-" .. player_realm
					end
					
					local _, _, class = UnitClass (player_name)
					
					local heal_actor = healing_container_pool [healing_container_hash [player_name]]
					if (heal_actor) then
						local guid = UnitGUID (player_name) or UnitGUID (UnitName ("raid" .. i))
						this_combat_data.healing [player_name] = {floor (heal_actor.total), _detalhes.item_level_pool [guid] and _detalhes.item_level_pool [guid].ilvl or 0, class or 0}
					end
				end
			end
		end
		
		--> add the encounter data
		tinsert (encounter_database, this_combat_data)
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: combat data added to encounter database.")
		end

		local myrole = UnitGroupRolesAssigned ("player")
		local mybest, onencounter = _detalhes.storage:GetBestFromPlayer (diff, encounter_id, myrole, _detalhes.playername, true) --> get dps or hps
		local mybest2 = mybest[1] or 0
		local myBestDps = mybest2 / onencounter.elapsed

		--[12:18:37] Details!: error occurred on Details.Database.StoreEncounter(): Interface\AddOns\Details\core\gears.lua:1758: attempt to index local 'mybest' (a nil value)

		if (mybest) then
			local d_one = 0
			if (myrole == "DAMAGER" or myrole == "TANK") then
				d_one = combat (1, _detalhes.playername) and combat (1, _detalhes.playername).total / combat:GetCombatTime()
			elseif (myrole == "HEALER") then
				d_one = combat (2, _detalhes.playername) and combat (2, _detalhes.playername).total / combat:GetCombatTime()
			end
			
			if (myBestDps > d_one) then
				if (not _detalhes.deny_score_messages) then
					print (Loc ["STRING_DETAILS1"] .. format (Loc ["STRING_SCORE_NOTBEST"], _detalhes:ToK2 (d_one), _detalhes:ToK2 (myBestDps), onencounter.date, mybest[2]))
				end
			else
				if (not _detalhes.deny_score_messages) then
					print (Loc ["STRING_DETAILS1"] .. format (Loc ["STRING_SCORE_BEST"], _detalhes:ToK2 (d_one)))
				end
			end
		end
		
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			local instance = _detalhes:GetInstance (lower_instance)
			if (instance) then
				local my_role = UnitGroupRolesAssigned ("player")
				if (my_role == "TANK") then
					my_role = "DAMAGER"
				end
				local raid_name = GetInstanceInfo()
				local func = {_detalhes.OpenRaidHistoryWindow, _detalhes, raid_name, encounter_id, diff, my_role, guildName} --, 2, UnitName ("player")
				--local icon = {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}
				local icon = {[[Interface\PvPRankBadges\PvPRank08]], 16, 16, false, 0, 1, 0, 1}
				
				if (not _detalhes.deny_score_messages) then
					instance:InstanceAlert (Loc ["STRING_GUILDDAMAGERANK_WINDOWALERT"], icon, _detalhes.update_warning_timeout, func, true)
				end
			end
		end
	else
		if (_detalhes.debug) then
			print ("|cFFFFFF00Details! Storage|r: raid difficulty must be heroic or mythic.")
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> inspect stuff

_detalhes.ilevel = {}
local ilvl_core = _detalhes:CreateEventListener()
ilvl_core.amt_inspecting = 0
_detalhes.ilevel.core = ilvl_core

ilvl_core:RegisterEvent ("GROUP_ONENTER", "OnEnter")
ilvl_core:RegisterEvent ("GROUP_ONLEAVE", "OnLeave")
ilvl_core:RegisterEvent ("COMBAT_PLAYER_ENTER", "EnterCombat")
ilvl_core:RegisterEvent ("COMBAT_PLAYER_LEAVE", "LeaveCombat")
ilvl_core:RegisterEvent ("ZONE_TYPE_CHANGED", "ZoneChanged")

local inspecting = {}
ilvl_core.forced_inspects = {}

function ilvl_core:HasQueuedInspec (unitName)
	local guid = UnitGUID (unitName)
	if (guid) then
		return ilvl_core.forced_inspects [guid]
	end
end

local inspect_frame = CreateFrame ("frame")
inspect_frame:RegisterEvent ("INSPECT_READY")

local two_hand = {
	["INVTYPE_2HWEAPON"] = true,
 	["INVTYPE_RANGED"] = true,
	["INVTYPE_RANGEDRIGHT"] = true,
}

local MAX_INSPECT_AMOUNT = 1
local MIN_ILEVEL_TO_STORE = 50
local LOOP_TIME = 7

function _detalhes:IlvlFromNetwork (player, realm, core, serialNumber, itemLevel, talentsSelected, currentSpec)
	if (_detalhes.debug) then
		local talents = "Invalid Talents"
		if (type (talentsSelected) == "table") then
			talents = ""
			for i = 1, #talentsSelected do
				talents = talents .. talentsSelected [i] .. ","
			end
		end
		_detalhes:Msg ("(debug) Received PlayerInfo Data: " .. (player or "Invalid Player Name") .. " | " .. (itemLevel or "Invalid Item Level") .. " | " .. (currentSpec or "Invalid Spec") .. " | " .. talents  .. " | " .. (serialNumber or "Invalid Serial"))
	end

	if (not player) then
		return
	end
	
	--> older versions of details wont send serial nor talents nor spec
	if (not serialNumber or not itemLevel or not talentsSelected or not currentSpec) then
		--if any data is invalid, abort
		return
	end

	--> won't inspect this actor
	_detalhes.trusted_characters [serialNumber] = true
	
	if (type (serialNumber) ~= "string") then
		return
	end

	--store the item level
	if (type (itemLevel) == "number") then
		_detalhes.item_level_pool [serialNumber] = {name = player, ilvl = itemLevel, time = time()}
	end
	
	--store talents
	if (type (talentsSelected) == "table") then
		if (talentsSelected [1]) then
			_detalhes.cached_talents [serialNumber] = talentsSelected
		end
	end
	
	--store the spec the player is playing
	if (type (currentSpec) == "number") then
		_detalhes.cached_specs [serialNumber] = currentSpec
	end
end

--> test
--/run _detalhes.ilevel:CalcItemLevel ("player", UnitGUID("player"), true)
--/run wipe (_detalhes.item_level_pool)

function ilvl_core:CalcItemLevel (unitid, guid, shout)
	
	if (type (unitid) == "table") then
		shout = unitid [3]
		guid = unitid [2]
		unitid = unitid [1]
	end

	if (CheckInteractDistance (unitid, 1)) then

		--> 16 = all itens including main and off hand
		local item_amount = 16
		local item_level = 0
		local failed = 0
		
		for equip_id = 1, 17 do
			if (equip_id ~= 4) then --shirt slot
				local item = GetInventoryItemLink (unitid, equip_id)
				if (item) then
					local _, _, itemRarity, iLevel, _, _, _, _, equipSlot = GetItemInfo (item)
					if (iLevel) then
						if (ItemUpgradeInfo) then
							local ilvl = ItemUpgradeInfo:GetUpgradedItemLevel (item)
							item_level = item_level + (ilvl or iLevel)
						else
							item_level = item_level + iLevel
						end
						
						--> 16 = main hand 17 = off hand
						-->  if using a two-hand, ignore the off hand slot
						if (equip_id == 16 and two_hand [equipSlot]) then
							item_amount = 15
							break
						end
					end
				else
					failed = failed + 1
					if (failed > 2) then
						break
					end
				end
			end
		end
		
		local average = item_level / item_amount
		--print (UnitName (unitid), "ILVL:", average, unitid, "items:", item_amount)
		
		--> register
		if (average > 0) then
			if (shout) then
				_detalhes:Msg (UnitName(unitid) .. " item level: " .. average)
			end
			
			if (average > MIN_ILEVEL_TO_STORE) then
				local name = _detalhes:GetCLName (unitid)
				_detalhes.item_level_pool [guid] = {name = name, ilvl = average, time = time()}
			end
		end
		
		local spec
		local talents = {}
		
		if (not DetailsFramework.IsClassicWow()) then
			spec = GetInspectSpecialization (unitid)
			if (spec and spec ~= 0) then
				_detalhes.cached_specs [guid] = spec
			end
		
--------------------------------------------------------------------------------------------------------

			for i = 1, 7 do
				for o = 1, 3 do
					--need to review this in classic
					local talentID, name, texture, selected, available = GetTalentInfo (i, o, 1, true, unitid)
					if (selected) then
						tinsert (talents, talentID)
						break
					end
				end
			end
		
			if (talents [1]) then
				_detalhes.cached_talents [guid] = talents
				--print (UnitName (unitid), "talents:", unpack (talents))
			end
		end
--------------------------------------------------------------------------------------------------------

		if (ilvl_core.forced_inspects [guid]) then
			if (type (ilvl_core.forced_inspects [guid].callback) == "function") then
				local okey, errortext = pcall (ilvl_core.forced_inspects[guid].callback, guid, unitid, ilvl_core.forced_inspects[guid].param1, ilvl_core.forced_inspects[guid].param2)
				if (not okey) then
					_detalhes:Msg ("Error on QueryInspect callback: " .. errortext)
				end
			end
			ilvl_core.forced_inspects [guid] = nil
		end

--------------------------------------------------------------------------------------------------------
		
	end
end
_detalhes.ilevel.CalcItemLevel = ilvl_core.CalcItemLevel

inspect_frame:SetScript ("OnEvent", function (self, event, ...)
	local guid = select (1, ...)
	
	if (inspecting [guid]) then
		local unitid, cancel_tread = inspecting [guid] [1], inspecting [guid] [2]
		inspecting [guid] = nil
		ilvl_core.amt_inspecting = ilvl_core.amt_inspecting - 1
		
		ilvl_core:CancelTimer (cancel_tread)
		
		--> do inspect stuff
		if (unitid) then
			local t = {unitid, guid}
			--ilvl_core:ScheduleTimer ("CalcItemLevel", 0.5, t)
			ilvl_core:ScheduleTimer ("CalcItemLevel", 0.5, t)
			ilvl_core:ScheduleTimer ("CalcItemLevel", 2, t)
			ilvl_core:ScheduleTimer ("CalcItemLevel", 4, t)
			ilvl_core:ScheduleTimer ("CalcItemLevel", 8, t)
		end
	else
		if (IsInRaid()) then
			--get the unitID
			local serial = ...
			if (serial and type (serial) == "string") then
				for i = 1, GetNumGroupMembers() do
					if (UnitGUID ("raid" .. i) == serial) then
						ilvl_core:ScheduleTimer ("CalcItemLevel", 2, {"raid" .. i, serial})
						ilvl_core:ScheduleTimer ("CalcItemLevel", 4, {"raid" .. i, serial})
					end
				end
			end
		end
	end
end)

function ilvl_core:InspectTimeOut (guid)
	inspecting [guid] = nil
	ilvl_core.amt_inspecting = ilvl_core.amt_inspecting - 1
end

function ilvl_core:ReGetItemLevel (t)
	local unitid, guid, is_forced, try_number = unpack (t)
	return ilvl_core:GetItemLevel (unitid, guid, is_forced, try_number)
end

function ilvl_core:GetItemLevel (unitid, guid, is_forced, try_number)

	--> ddouble check
	if (not is_forced and (UnitAffectingCombat ("player") or InCombatLockdown())) then
		return
	end
	if (not unitid or not CanInspect (unitid) or not CheckInteractDistance (unitid, 1)) then
		if (is_forced) then
			try_number = try_number or 0
			if (try_number > 18) then
				return
			else
				try_number = try_number + 1
			end
			ilvl_core:ScheduleTimer ("ReGetItemLevel", 3, {unitid, guid, is_forced, try_number})
		end
		return
	end

	inspecting [guid] = {unitid, ilvl_core:ScheduleTimer ("InspectTimeOut", 12, guid)}
	ilvl_core.amt_inspecting = ilvl_core.amt_inspecting + 1

	NotifyInspect (unitid)
end

local NotifyInspectHook = function (unitid)
	local unit = unitid:gsub ("%d+", "")
	
	if ((IsInRaid() or IsInGroup()) and (_detalhes:GetZoneType() == "raid" or _detalhes:GetZoneType() == "party")) then
		local guid = UnitGUID (unitid)
		local name = _detalhes:GetCLName (unitid)
		if (guid and name and not inspecting [guid]) then
			for i = 1, GetNumGroupMembers() do
				if (name == _detalhes:GetCLName (unit .. i)) then
					unitid = unit .. i
					break
				end
			end
			
			inspecting [guid] = {unitid, ilvl_core:ScheduleTimer ("InspectTimeOut", 12, guid)}
			ilvl_core.amt_inspecting = ilvl_core.amt_inspecting + 1
		end
	end
end
hooksecurefunc ("NotifyInspect", NotifyInspectHook)

function ilvl_core:Reset()
	ilvl_core.raid_id = 1
	ilvl_core.amt_inspecting = 0
	
	for guid, t in pairs (inspecting) do
		ilvl_core:CancelTimer (t[2])
		inspecting [guid] = nil
	end
end

function ilvl_core:QueryInspect (unitName, callback, param1)
	local unitid

	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			if (GetUnitName ("raid" .. i, true) == unitName) then
				unitid = "raid" .. i
				break
			end
		end
	elseif (IsInGroup()) then
		for i = 1, GetNumGroupMembers()-1 do
			if (GetUnitName ("party" .. i, true) == unitName) then
				unitid = "party" .. i
				break
			end
		end
	else
		unitid = unitName
	end
	
	if (not unitid) then
		return false
	end
	
	local guid = UnitGUID (unitid)
	if (not guid) then
		return false
	elseif (ilvl_core.forced_inspects [guid]) then
		return true
	end
	
	if (inspecting [guid]) then
		return true
	end
	
	ilvl_core.forced_inspects [guid] = {callback = callback, param1 = param1}
	ilvl_core:GetItemLevel (unitid, guid, true)
	
	if (ilvl_core.clear_queued_list) then
		ilvl_core:CancelTimer (ilvl_core.clear_queued_list)
	end
	ilvl_core.clear_queued_list = ilvl_core:ScheduleTimer ("ClearQueryInspectQueue", 60)
	
	return true
end

function ilvl_core:ClearQueryInspectQueue()
	wipe (ilvl_core.forced_inspects)
	ilvl_core.clear_queued_list = nil
end

function ilvl_core:Loop()
	if (ilvl_core.amt_inspecting >= MAX_INSPECT_AMOUNT) then
		return
	end

	local members_amt = GetNumGroupMembers()
	if (ilvl_core.raid_id > members_amt) then
		ilvl_core.raid_id = 1
	end
	
	local unitid
	if (IsInRaid()) then
		unitid = "raid" .. ilvl_core.raid_id
	elseif (IsInGroup()) then
		unitid = "party" .. ilvl_core.raid_id
	else
		return
	end

	local guid = UnitGUID (unitid)
	if (not guid) then
		ilvl_core.raid_id = ilvl_core.raid_id + 1
		return
	end

	--> if already inspecting or the actor is in the list of trusted actors
	if (inspecting [guid] or _detalhes.trusted_characters [guid]) then
		return
	end

	local ilvl_table = _detalhes.ilevel:GetIlvl (guid)
	if (ilvl_table and ilvl_table.time + 3600 > time()) then
		ilvl_core.raid_id = ilvl_core.raid_id + 1
		return
	end
	
	ilvl_core:GetItemLevel (unitid, guid)
	ilvl_core.raid_id = ilvl_core.raid_id + 1
end

function ilvl_core:EnterCombat()
	if (ilvl_core.loop_process) then
		ilvl_core:CancelTimer (ilvl_core.loop_process)
		ilvl_core.loop_process = nil
	end
end

local can_start_loop = function()
	if ((_detalhes:GetZoneType() ~= "raid" and _detalhes:GetZoneType() ~= "party") or ilvl_core.loop_process or _detalhes.in_combat or not _detalhes.track_item_level) then
		return false
	end
	return true
end

function ilvl_core:LeaveCombat()
	if (can_start_loop()) then
		ilvl_core:Reset()
		ilvl_core.loop_process = ilvl_core:ScheduleRepeatingTimer ("Loop", LOOP_TIME)
	end
end

function ilvl_core:ZoneChanged (zone_type)
	if (can_start_loop()) then
		ilvl_core:Reset()
		ilvl_core.loop_process = ilvl_core:ScheduleRepeatingTimer ("Loop", LOOP_TIME)
	end
end

function ilvl_core:OnEnter()
	if (IsInRaid()) then
		_detalhes:SendCharacterData()
	end
	
	if (can_start_loop()) then
		ilvl_core:Reset()
		ilvl_core.loop_process = ilvl_core:ScheduleRepeatingTimer ("Loop", LOOP_TIME)
	end
end

function ilvl_core:OnLeave()
	if (ilvl_core.loop_process) then
		ilvl_core:CancelTimer (ilvl_core.loop_process)
		ilvl_core.loop_process = nil
	end
end

--> ilvl API
function _detalhes.ilevel:IsTrackerEnabled()
	return _detalhes.track_item_level
end
function _detalhes.ilevel:TrackItemLevel (bool)
	if (type (bool) == "boolean") then
		if (bool) then
			_detalhes.track_item_level = true
			if (can_start_loop()) then
				ilvl_core:Reset()
				ilvl_core.loop_process = ilvl_core:ScheduleRepeatingTimer ("Loop", LOOP_TIME)
			end
		else
			_detalhes.track_item_level = false
			if (ilvl_core.loop_process) then
				ilvl_core:CancelTimer (ilvl_core.loop_process)
				ilvl_core.loop_process = nil
			end
		end
	end
end

function _detalhes.ilevel:GetPool()
	return _detalhes.item_level_pool
end

function _detalhes.ilevel:GetIlvl (guid)
	return _detalhes.item_level_pool [guid]
end

function _detalhes.ilevel:GetInOrder()
	local order = {}
	
	for guid, t in pairs (_detalhes.item_level_pool) do
		order [#order+1] = {t.name, t.ilvl or 0, t.time}
	end
	
	table.sort (order, _detalhes.Sort2)
	
	return order
end

function _detalhes:GetTalents (guid)
	return _detalhes.cached_talents [guid]
end

function _detalhes:GetSpecFromSerial (guid)
	return _detalhes.cached_specs [guid]
end

if (LibGroupInSpecT) then
	function _detalhes:LibGroupInSpecT_UpdateReceived (event, guid, unitid, info)
		--> update talents
		local talents = _detalhes.cached_talents [guid] or {}
		local i = 1
		for talentId, _ in pairs (info.talents) do 
			talents [i] = talentId
			i = i + 1
		end
		_detalhes.cached_talents [guid] = talents
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) received GroupInSpecT_Update from user", guid)
		end
		
		--> update spec
		if (info.global_spec_id and info.global_spec_id ~= 0) then
			if (not _detalhes.class_specs_coords [info.global_spec_id]) then
				print ("Details! Spec Id Invalid:", info.global_spec_id, info.name)
			else
				_detalhes.cached_specs [guid] = info.global_spec_id
			end
		end
		
		--print ("LibGroupInSpecT Received from", info.name, info.global_spec_id)
	end
	LibGroupInSpecT.RegisterCallback (_detalhes, "GroupInSpecT_Update", "LibGroupInSpecT_UpdateReceived")
end


--------------------------------------------------------------------------------------------------------------------------------------------
--compress data

-- ~compress ~zip ~export ~import ~deflate ~serialize
function Details:CompressData (data, dataType)
	local LibDeflate = LibStub:GetLibrary ("LibDeflate")
	local LibAceSerializer = LibStub:GetLibrary ("AceSerializer-3.0")
	
	if (LibDeflate and LibAceSerializer) then
		local dataSerialized = LibAceSerializer:Serialize (data)
		if (dataSerialized) then
			local dataCompressed = LibDeflate:CompressDeflate (dataSerialized, {level = 9})
			if (dataCompressed) then
				if (dataType == "print") then
					local dataEncoded = LibDeflate:EncodeForPrint (dataCompressed)
					return dataEncoded
					
				elseif (dataType == "comm") then
					local dataEncoded = LibDeflate:EncodeForWoWAddonChannel (dataCompressed)
					return dataEncoded
				end
			end
		end
	end
end

function Details:DecompressData (data, dataType)
	local LibDeflate = LibStub:GetLibrary ("LibDeflate")
	local LibAceSerializer = LibStub:GetLibrary ("AceSerializer-3.0")
	
	if (LibDeflate and LibAceSerializer) then
		
		local dataCompressed
		
		if (dataType == "print") then
		
			data = DetailsFramework:Trim (data)
		
			dataCompressed = LibDeflate:DecodeForPrint (data)
			if (not dataCompressed) then
				Details:Msg ("couldn't decode the data.")
				return false
			end

		elseif (dataType == "comm") then
			dataCompressed = LibDeflate:DecodeForWoWAddonChannel (data)
			if (not dataCompressed) then
				Details:Msg ("couldn't decode the data.")
				return false
			end
		end
		
		local dataSerialized = LibDeflate:DecompressDeflate (dataCompressed)
		if (not dataSerialized) then
			Details:Msg ("couldn't uncompress the data.")
			return false
		end
		
		local okay, data = LibAceSerializer:Deserialize (dataSerialized)
		if (not okay) then
			Details:Msg ("couldn't unserialize the data.")
			return false
		end
		
		return data
	end
end


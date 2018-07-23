--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
----------------------------------------------------------------------]]

local GRID, Grid = ...
local LDBIcon = LibStub("LibDBIcon-1.0")
local format, print, strfind, strlen, tostring, type = format, print, strfind, strlen, tostring, type

_G.Grid = LibStub("AceAddon-3.0"):NewAddon(Grid, GRID, "AceConsole-3.0", "AceEvent-3.0")

if not Grid.L then Grid.L = { } end
local L = setmetatable( Grid.L, {
	__index = function(t, k)
		t[k] = k
		return k
	end
})

------------------------------------------------------------------------

function Grid:Debug(str, ...)
	if not self.debug then return end
	if not str or strlen(str) == 0 then return end

	if (...) then
		if strfind(str, "%%%.%d") or strfind(str, "%%[dfqsx%d]") then
			str = format(str, ...)
		else
			str = strjoin(" ", str, tostringall(...))
		end
	end

	local name = self.moduleName or self.name or GRID
	_G[Grid.db.global.debugFrame]:AddMessage(format("|cffff9933%s:|r %s", name, str))
end

function Grid:GetDebuggingEnabled(moduleName)
	return self.db.global.debug[moduleName]
end

do
	local function FindModule(start, moduleName)
		--print("FindModule", start.moduleName, moduleName)
		if start.name == moduleName or start.moduleName == moduleName then
			return start
		end
		for name, module in start:IterateModules() do
			local found = FindModule(module, moduleName)
			if found then
				--print("FOUND")
				return found
			end
		end
	end

	function Grid:SetDebuggingEnabled(moduleName, value)
		--print("SetDebuggingEnabled", moduleName, value)
		local module = FindModule(self, moduleName)
		if not module then
			--print("ERROR: module "..moduleName.." doesn't exist!")
			return
		end

		if module.db and module.db.profile and module.db.profile.debug ~= nil then
			--print("Removed old debug setting from module", moduleName, tostring(module.db.profile.debug))
			module.db.profile.debug = nil
		end

		local args = self.options.args.debug.args
		if not args[moduleName] then
			args[moduleName] = self:GetDebuggingOptions(moduleName)
		end

		if value == nil then
			module.debug = self.db.global.debug[moduleName]
		else
			self.db.global.debug[moduleName] = value or nil
			module.debug = value
		end
	end
end

------------------------------------------------------------------------

Grid.options = {
	handler = Grid,
	type = "group",
	childGroups = "tab",
	args = {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				minimap = {
					name = L["Show minimap icon"],
					desc = L["Show the Grid icon on the minimap. Note that some DataBroker display addons may hide the icon regardless of this setting."],
					order = 1,
					width = "double",
					type = "toggle",
					get = function()
						return not Grid.db.profile.minimap.hide
					end,
					set = function(info, value)
						Grid.db.profile.minimap.hide = not value
						if value then
							LDBIcon:Show(GRID)
						else
							LDBIcon:Hide(GRID)
						end
					end
				},
				standaloneOptions = {
					name = L["Standalone options"],
					desc = L["Open Grid's options in their own window, instead of the Interface Options window, when typing /grid or right-clicking on the minimap icon, DataBroker icon, or layout tab."],
					order = 2,
					width = "double",
					type = "toggle",
					get = function()
						return Grid.db.profile.standaloneOptions
					end,
					set = function(info, value)
						Grid.db.profile.standaloneOptions = value
					end,
				}
			},
		},
		debug = {
			type = "group",
			name = L["Debugging"],
			desc = L["Module debugging menu."],
			order = -1,
			args = {
				desc = {
					order = 1,
					type = "description",
					name = L["Debugging messages help developers or testers see what is happening inside Grid in real time. Regular users should leave debugging turned off except when troubleshooting a problem for a bug report."],
				},
				frame = {
					order = 2,
					name = L["Output Frame"],
					desc = L["Show debugging messages in this frame."],
					type = "select",
					get = function(info)
						return Grid.db.global.debugFrame
					end,
					set = function(info, value)
						Grid.db.global.debugFrame = value
					end,
					values = {
						ChatFrame1  = "ChatFrame1",
						ChatFrame2  = "ChatFrame2",
						ChatFrame3  = "ChatFrame3",
						ChatFrame4  = "ChatFrame4",
						ChatFrame5  = "ChatFrame5",
						ChatFrame6  = "ChatFrame6",
						ChatFrame7  = "ChatFrame7",
						ChatFrame8  = "ChatFrame8",
						ChatFrame9  = "ChatFrame9",
						ChatFrame10 = "ChatFrame10",
					},
				},
				spacer = {
					order = 3,
					name = " ",
					type = "description",
				},
			}
		}
	}
}

------------------------------------------------------------------------

Grid.defaultDB = {
	profile = {
		minimap = {},
		standaloneOptions = false,
	},
	global = {
		debug = {},
		debugFrame = "ChatFrame1",
	}
}

------------------------------------------------------------------------

Grid.modulePrototype = {
	core = Grid,
	Debug = Grid.Debug,
	registeredModules = { },
}

function Grid.modulePrototype:OnInitialize()
	if not self.db then
		self.db = Grid.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end

	self:Debug("OnInitialize")

	Grid:SetDebuggingEnabled(self.moduleName)
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
		Grid:SetDebuggingEnabled(name)
	end

	if type(self.PostInitialize) == "function" then
		self:PostInitialize()
	end
end

function Grid.modulePrototype:OnEnable()
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	self:EnableModules()

	if type(self.PostEnable) == "function" then
		self:PostEnable()
	end
end

function Grid.modulePrototype:OnDisable()
	self:DisableModules()

	if type(self.PostDisable) == "function" then
		self:PostDisable()
	end
end

function Grid.modulePrototype:Reset()
	self:Debug("Reset")
	self:ResetModules()

	if type(self.PostReset) == "function" then
		self:PostReset()
	end
end

function Grid.modulePrototype:OnModuleCreated(module)
	module.super = self.modulePrototype
	self:Debug("OnModuleCreated", module.moduleName)
	if Grid.db then
		-- otherwise it will be caught in core OnInitialize
		Grid:SetDebuggingEnabled(module.moduleName)
	end
end

function Grid.modulePrototype:RegisterModule(name, module)
	if self.registeredModules[module] then return end

	self:Debug("Registering", name)

	if not module.db then
		module.db = Grid.db:RegisterNamespace(name, { profile = module.defaultDB or { } })
	end

	if module.extraOptions and not module.options then
		module.options = {
			name = module.menuName or module.moduleName,
			type = "group",
			args = {},
		}
		for name, option in pairs(module.extraOptions) do
			module.options.args[name] = option
		end
	end

	if module.options then
		self.options.args[name] = module.options
	end

	self.registeredModules[module] = true
end

function Grid.modulePrototype:EnableModules()
	for name, module in self:IterateModules() do
		self:EnableModule(name)
	end
end

function Grid.modulePrototype:DisableModules()
	for name, module in self:IterateModules() do
		self:DisableModule(name)
	end
end

function Grid.modulePrototype:ResetModules()
	for name, module in self:IterateModules() do
		self:Debug("Resetting " .. name)
		module.db = self.core.db:GetNamespace(name)
		if type(module.Reset) == "function" then
			module:Reset()
		end
	end
end

function Grid.modulePrototype:StartTimer(callback, delay, repeating, arg)
	if not self.ScheduleTimer then
		-- This module doesn't use AceTimer-3.0.
		self:Debug("Attempt to call StartTimer without AceTimer-3.0!")
		return
	end
	self:Debug("StartTimer", callback, delay, repeating, arg)

	local handles = self.timerHandles
	if not handles then
		-- First time starting a timer.
		handles = {}
		self.timerHandles = handles
	end

	local timerName = tostring(callback)
	if handles[timerName] then
		-- Timer is already running; stop it first.
		self:StopTimer(timerName)
	end

	local handle
	if repeating then
		handle = self:ScheduleRepeatingTimer(callback, delay, arg)
	else
		handle = self:ScheduleTimer(callback, delay, arg)
		-- KNOWN ISSUE: Unless the module cancels the timer itself in
		-- the callback function, the timer will remain listed in the
		-- module.timerHandles table. Should not cause any problems,
		-- though, since StopTimer calls CancelTimer silently.
	end
	handles[timerName] = handle
	return handle
end

function Grid.modulePrototype:StopTimer(callback)
	local handles, timerName = self.timerHandles, tostring(callback)
	if not handles or not handles[timerName] then
		-- This module doesn't use AceTimer, or hasn't started any timers
		-- yet, or the specified timer is not running.
		self:Debug("Attempt to call StopTimer without AceTimer-3.0!")
		return
	end
	self:Debug("StopTimer", timerName)
	self:CancelTimer(handles[timerName], true)
	handles[timerName] = nil
end

Grid:SetDefaultModulePrototype(Grid.modulePrototype)
Grid:SetDefaultModuleLibraries("AceEvent-3.0")

------------------------------------------------------------------------

function Grid:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GridDB", self.defaultDB, true)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileEnable")

	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profile.order = -3

	local LibDualSpec = LibStub("LibDualSpec-1.0")
	LibDualSpec:EnhanceDatabase(self.db, GRID)
	LibDualSpec:EnhanceOptions(self.options.args.profile, self.db)

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(GRID, self.options)

	--
	--	Broker launcher
	--

	local DataBroker = LibStub("LibDataBroker-1.1", true)
	if DataBroker then
		self.Broker = DataBroker:NewDataObject(GRID, {
			type = "launcher",
			icon = "Interface\\AddOns\\Grid\\Media\\icon",
			OnClick = function(self, button)
				if button == "RightButton" then
					Grid:ToggleOptions()
				elseif not InCombatLockdown() then
					local GridLayout = Grid:GetModule("GridLayout")
					GridLayout.db.profile.lock = not GridLayout.db.profile.lock
					LibStub("AceConfigRegistry-3.0"):NotifyChange(GRID)
					GridLayout:UpdateTabVisibility()
				end
			end,
			OnTooltipShow = function(tooltip)
				tooltip:AddLine(GRID, 1, 1, 1)
				if InCombatLockdown() then
					tooltip:AddLine(L["Click to toggle the frame lock."], 0.5, 0.5, 0.5)
				else
					tooltip:AddLine(L["Click to toggle the frame lock."])
				end
				tooltip:AddLine(L["Right-Click for more options."])
			end,
		})
	end

	LDBIcon:Register(GRID, self.Broker, self.db.profile.minimap)
	if self.db.profile.minimap.hide then
		LDBIcon:Hide(GRID)
	else
		LDBIcon:Show(GRID)
	end

	self:SetDebuggingEnabled("Grid")
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	-- to catch mysteriously late-loading modules
	self:RegisterEvent("ADDON_LOADED")
end

function Grid:OnEnable()
	self:Debug("OnEnable")

	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end

	self:EnableModules()

	if self.SetupOptions then
		self:SetupOptions()
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self:SendMessage("Grid_Enabled")
end

function Grid:OnDisable()
	self:Debug("OnDisable")

	self:SendMessage("Grid_Disabled")

	self:DisableModules()
end

function Grid:OnProfileEnable()
	self:Debug("Loaded profile", self.db:GetCurrentProfile())

	local LDBIcon = LibStub("LibDBIcon-1.0", true)
	if LDBIcon then
		LDBIcon:Refresh(GRID, self.db.profile.minimap)
		if self.db.profile.minimap.hide then
			LDBIcon:Hide(GRID)
		else
			LDBIcon:Show(GRID)
		end
	end

	self:ResetModules()
end

function Grid:SetupOptions()
	local Command = LibStub("AceConfigCmd-3.0")
	local Dialog = LibStub("AceConfigDialog-3.0")

	---------------------------------------------------------------------
	--	Standalone options

	local status = Dialog:GetStatusTable(GRID)
	status.width = 780 -- 685
	status.height = 500 -- 530

	local child1 = Dialog:GetStatusTable(GRID, { "GridIndicator" })
	child1.groups = child1.groups or {}
	child1.groups.treewidth = 220

	local child2 = Dialog:GetStatusTable(GRID, { "GridStatus" })
	child2.groups = child2.groups or {}
	child2.groups.treewidth = 260

	local child3 = Dialog:GetStatusTable(GRID, { "GridHelp" })
	child3.groups = child3.groups or {}
	child3.groups.treewidth = 300

	self:RegisterChatCommand("grid", function(input)
		if input then
			input = strtrim(input)
		end
		if not input or input == "" then
			self:ToggleOptions()
		elseif strmatch(strlower(input), "^ve?r?s?i?o?n?$") then
			local version = GetAddOnMetadata(GRID, "Version")
			if version == "@" .. "project-version" .. "@" then -- concatenation to trick the packager
				self:Print("You are using a developer version.") -- no need to localize
			else
				self:Print(format(L["You are using version %s"], version))
			end
		else
			Command.HandleCommand(Grid, "grid", GRID, input)
		end
	end)

	InterfaceOptionsFrame:HookScript("OnShow", function()
		Dialog:Close(GRID)
	end)

	---------------------------------------------------------------------
	--	Interface Options frame integrated options

	local panels = {}
	for k, v in pairs(self.options.args) do
		if k ~= "general" then
			tinsert(panels, k)
		end
	end

	table.sort(panels, function(a, b) -- copied from Dialog-3.0
		if not a then return true end
		if not b then return false end
		local orderA, orderB = self.options.args[a].order or 10000, self.options.args[b].order or 10000
		if orderA == orderB then
			return strupper(self.options.args[a].name or "") < strupper(self.options.args[b].name or "")
		end
		if orderA < 0 then
			if orderB > 0 then return false end
		else
			if orderB < 0 then return true end
		end
		return orderA < orderB
	end)

	self.optionsPanels = {
		Dialog:AddToBlizOptions(GRID, GRID, nil, "general") -- "appName", "panelName", "parentName", ... "optionsPath"
	}

	local noop = function() end
	for i = 1, #panels do
		local path = panels[i]
		local name = self.options.args[path].name
		local f = Dialog:AddToBlizOptions(GRID, name, GRID, path)
		f.obj:SetTitle(GRID .. " - " .. name) -- workaround for AceConfig deficiency
		f.obj.SetTitle = noop
		self.optionsPanels[i+1] = f
	end

	self.SetupOptions = nil
end

function Grid:ToggleOptions()
	if self.db.profile.standaloneOptions then
		local Dialog = LibStub("AceConfigDialog-3.0")
		if Dialog.OpenFrames[GRID] then
			Dialog:Close(GRID)
		else
			Dialog:Open(GRID)
		end
	else
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels[2]) -- default to Layout
		InterfaceOptionsFrame_OpenToCategory(self.optionsPanels[2]) -- double up as a workaround for the bug that opens the frame without selecting the panel
	end
end

------------------------------------------------------------------------

do
	local function debug_get(info)
		--print("debug_get", info[#info])
		return Grid:GetDebuggingEnabled(info[#info])
	end

	local function debug_set(info, value)
		--print("debug_set", info[#info], value)
		return Grid:SetDebuggingEnabled(info[#info], value)
	end

	function Grid:GetDebuggingOptions(moduleName)
		return {
			name = moduleName,
			desc = format(L["Enable debugging messages for the %s module."], moduleName),
			type = "toggle",
			width = "double",
			get = debug_get,
			set = debug_set,
		}
	end
end

function Grid:OnModuleCreated(module)
	module.super = self.modulePrototype

	if self.db then
		-- otherwise it will be caught in core OnInitialize
		self:SetDebuggingEnabled(module.moduleName)
	end
end

------------------------------------------------------------------------

local registeredModules = { }

function Grid:RegisterModule(name, module)
	if registeredModules[module] then return end

	self:Debug("Registering " .. name)

	if not module.db then
		module.db = self.db:RegisterNamespace(name, { profile = module.defaultDB or { } })
	end

	if module.options then
		self.options.args[name] = module.options
	end

	registeredModules[module] = true
end

function Grid:EnableModules()
	for name, module in self:IterateModules() do
		self:EnableModule(name)
	end
end

function Grid:DisableModules()
	for name, module in self:IterateModules() do
		self:DisableModule(name)
	end
end

function Grid:ResetModules()
	for name, module in self:IterateModules() do
		self:Debug("Resetting " .. name)
		module.db = self.db:GetNamespace(name)
		if type(module.Reset) == "function" then
			module:Reset()
		end
	end
end

------------------------------------------------------------------------

function Grid:PLAYER_ENTERING_WORLD()
	-- this is needed for zoning while in combat
	self:PLAYER_REGEN_ENABLED()
end

function Grid:PLAYER_REGEN_DISABLED()
	self:Debug("Entering combat")
	self:SendMessage("Grid_EnteringCombat")
	Grid.inCombat = true
end

function Grid:PLAYER_REGEN_ENABLED()
	Grid.inCombat = InCombatLockdown() == 1
	if not Grid.inCombat then
		self:Debug("Leaving combat")
		self:SendMessage("Grid_LeavingCombat")
	end
end

function Grid:ADDON_LOADED()
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
	end
end

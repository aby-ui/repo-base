
-----------------------------------------------------------
-- LibAddonManager.lua
-----------------------------------------------------------
-- Take the global "..." (name, addon) as parameters to
-- initialize an addon object.
--
-- Abin (2014-11-04)

-----------------------------------------------------------
-- API Documentation:
-----------------------------------------------------------

-- addon = LibAddonManager:CreateAddon(...) -- Take over the addon object

-- addon is a table represents your addon object, it contains the following field upon creation:

-- version: string, the value of fileld "## Version" in toc file, or "1.0" if missing
-- numericVersion: number, numeric form of version
-- name: string, name of the addon, same as the toc file name
-- title: string, same as "name" by default but developers may change for different locales
-- path: string, the folder path where the addon resides, usually "Interface\\AddOns\\myaddon"
-- player: string, player name
-- realm: string, current realm name
-- faction: string, player faction group in English, either "Alliance" or "Horde"
-- class: string, player class in upper-cased English, "WARRIOR", "MAGE", "PALADIN" etc.
-- race: string, player race in English, "Human", "NightElf", "Troll", etc.
-- guid: string, GUID of the player
-- group: string, can be "raid", "party", or nil
-- leadship: string, group leadship of the player, can be "leader", "officer", or nil
-- members: number, number of group members in current raid or party, 0 if not grouped
-- spec: number, id of the active specialzation (1-4)

-- And the following functions & methods are defined for the object:

-- addon.tcopy(source [, destination]) -- Copy entire table data includes sub-tables from source to destination, return new table
-- addon.tfind(table, value) -- Seach a numeric based table for match value, return index
-- addon.tfind(table, func, ...) -- Seach a numeric based table for match value using defined function, return index, [boolean] func(element, ...)

-- addon:Print("text" [, r, g, b]) -- Prints a message
-- addon:Debug("text") -- Prints a message ONLY if addon.debug is true

-- addon:Initialized() -- Returns whether the addon has been initialized
-- addon:RegisterDB("dbName", hasCharDB) -- "hasCharDB" can be string, in which case char db will be the contents in toc field "SavedVariablesPerCharacter". Non-string type will treated as "name - realm" stored in db["profiles"]
-- addon:VerifyDBVersion(version [, db]) -- Returns true only if value of [db].version is numeric and no smaller than the specified version value
-- addon:RegisterSlashCmd("command1" [, "command2" [, ...]]) -- Register slash commands, no limited numbers
-- addon:RegisterBindingClick(button, "name", "text") -- Set an override binding click to a button, "name" is the binding name, "text" is what appears in the game's "Key Bindings" UI
-- addon:GetCurProfileName() -- Return current profile name string, in format of "name - realm"
-- addob:GetProfileNameList() -- Return a table stores list of profile names { "name1", "name2", ... }
-- addon:GetProfileData("name") -- Return the profile data table specified by "name"
-- addon:CopyProfile("src" [, "dest"]) -- Copy contents from profile "src" to "dest", copy to current profile if "dest" is not specified
-- addon:DeleteProfile("name") -- Delete a profile specified by "name", cannot delete current profile

-- addon:RegisterLocale("name", "locale", data) -- Register a localized string table
-- addon:GetLocale("name", "locale") -- Get a registered string table

-- addon:PopupShowConfirm("text", func, arg1 [, "buttons"]) -- Show a popup dialog without editbox, func(arg1) will be called. "buttons" can be "MB_OK", "MB_OKCANCEL", "MB_YESNO", "MB_ACCEPTCANCEL", "MB_ACCEPTDECLINE"
-- addon:PopupShowAck("text" [, func, arg1]) -- Show an acknowledgement dialog with a fixed "Okay" button
-- addon:PopupShowInput("text", func, arg1, "default" [, wide]) -- Show a popup dialog with editbox for user inputs, func(arg1, "text") will be called. editbox width will be set to 260 if "wide" is true
-- addon:PopupHide() -- Hide the popup dialog shown by this addon

-- addon:EmbedEventObject([ object ]) -- Embeds an object with event-handling capability
-- addon:RegisterEvent("event" [, func])
-- addon:RegisterEvent("event" [, "method"])
-- addon:UnregisterEvent("event")
-- addon:RegisterAllEvents()
-- addon:UnregisterAllEvents()
-- addon:RegisterTick(interval) -- addon:OnTick() will be called every "interval" seconds
-- addon:UnregisterTick()
-- addon:SetInterval(interval)
-- addon:IsTicking()
-- addon:BroadcastEvent("event" [, ...])
-- addon:RegisterEventCallback("event", func [, arg1])
-- addon:BroadcastOptionEvent(option [, ...])
-- addon:RegisterOptionCallback("option", func [, arg1])

-- addon:CreateModule("key", "dbType" [, ...]) -- Create a module using an unique key, "dbType" can be "ACCOUNT", "CHAR" or "ACCOUNT|CHAR", ... can be anything
-- addon:NumModules() -- Return number of modules registered in this addon
-- addon:GetModule(index) -- Get a module specified by index
-- addon:GetModule("key") -- Get a module specified by key string
-- addon:EnumModules(func, ...) -- Enum all modules and call func(module, ...)
-- addon:CallModule(module, "method", ...) -- Call a modules' method specified by "method"(STRING), regardless the enable/disable states of the module
-- addon:CallAllModules("method", ...) -- Call all modules' method specified by "method"(STRING), regardless the enable/disable states of the module
-- addon:CallAllEnabledModules("method", ...) -- Call all modules' method specified by "method"(STRING), only enabled modules are involved

-----------------------------------------------------------
-- Callback functions:
-----------------------------------------------------------

-- addon:OnInitialize(db, dbIsNew, chardb, chardbIsNew) -- Called when PLAYER_LOGIN event fires
-- addon:OnModulesInitDone() -- Called after all modules of this addon are initialized done
-- addon:OnControlReady() -- Called when the character is ready to be controlled
-- addon:OnGroupChange("group", "leadship", members) -- Fires when group state changes
-- addon:OnSpecChange(spec) -- Fires when the active specialization changes
-- addon:OnTick(elapsed) -- Fires when ticking
-- addon:OnSlashCmd(text) -- Fires when the user types a slash command registered by this addon
-- addon:OnVerifyModule("key", "dbType" [, ...]) -- Called before creates a new module, if this method exists and returns nil/false, the creatiopn fails
-- addon:OnCreateModule(module, "key", ...) -- Called when a new module is created, "..." is what passed in addon:CreateModule
-- addon:OnEvent(event, ...) -- Fires when an event fires and this callback is defined
-- addon:OnEnterCombat() -- Fires when the player enters combat
-- addon:OnLeaveCombat() -- Fires when the player leaves combat

-----------------------------------------------------------
-- Module functions:
-----------------------------------------------------------

-- module:Enable()
-- module:Disable()
-- module:IsEnabled()

-----------------------------------------------------------
-- Module callback functions:
-----------------------------------------------------------

-- module:OnInitialize(db, dbIsNew, chardb, chardbIsNew) -- Fires after the PLAYER_LOGIN event fires, db and chardb are subsets of the addon dbs
-- module:OnEnable() -- Fires when the module is enabled via "module:Enable()"
-- module:OnDisable() -- Fires when the module is disabled via "module:Disable()"
-- module:OnControlReady() -- Called when the character is ready to be controlled
-- module:OnGroupChange("group", "leadship", members) -- Fires when group state changes
-- module:OnSpecChange(spec) -- Fires when the active specialization changes
-- module:OnTick(elapsed) -- Fires when ticking
-- module:OnEvent(event, ...) -- Fires when an event fires and this callback is defined
-- module:OnEnterCombat() -- Fires when the player enters combat, only for enabled modules
-- module:OnLeaveCombat() -- Fires when the player leaves combat, only for enabled modules

-----------------------------------------------------------

local type = type
local CreateFrame = CreateFrame
local tinsert = tinsert
local GetAddOnMetadata = GetAddOnMetadata
local tonumber = tonumber
local tostring = tostring
local select = select
local strupper = strupper
local strfind = strfind
local strtrim = strtrim
local wipe = wipe
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local pairs = pairs
local ipairs = ipairs
local InCombatLockdown = InCombatLockdown
local UnitName = UnitName
local GetRealmName = GetRealmName
local UnitFactionGroup = UnitFactionGroup
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local format = format
local error = error
local StaticPopup_Show = StaticPopup_Show
local StaticPopup_Hide = StaticPopup_Hide
local StaticPopupDialogs = StaticPopupDialogs
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsRaidOfficer = UnitIsRaidOfficer
local GetSpecialization = GetSpecialization
local _G = _G

local VERSION = 1.27

local lib = _G.LibAddonManager
if type(lib) == "table" then
	local version = lib.version
	if type(version) == "number" and version >= VERSION then
		return
	end
else
	lib = {}
	_G.LibAddonManager = lib
end

lib.version = VERSION

local PRIVATE = "{62B10A9A-6AF5-40EF-93F6-D7271489AA66}"

local PLAYER_INFO = {}
local PROFILE_NAME

-------------------------------------------------------
-- Library utility function
-------------------------------------------------------

function lib.tcopy(src, dest)
	if type(dest) == "table" then
		wipe(dest)
	else
		dest = {}
	end

	local k, v
	for k, v in pairs(src) do
		if type(v) == "table" then
			dest[k] = lib.tcopy(v)
		else
			dest[k] = v
		end
	end

	return dest
end

function lib.tfind(t, arg, ...)
	if type(t) ~= "table" then
		return
	end

	local funcSearch = type(arg) == "function"
	local index, data
	for index, data in ipairs(t) do
		if funcSearch then
			if arg(data, ...) then
				return index
			end
		else
			if data == arg then
				return index
			end
		end
	end
end

local function Addon_Print(self, msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..self.title..":|r "..tostring(msg), r or 0.5, g or 0.75, b or 1)
end

local function Addon_Debug(self, msg)
	if self.debug then
		Addon_Print(self, msg, 1, 0.5, 0)
	end
end

local function Addon_GetCurProfileName(self)
	return PROFILE_NAME
end

local function Addon_GetProfileNameList(self)
	local list = {}
	if self.db and type(self.db.profiles) == "table" then
		local name
		for name in pairs(self.db.profiles) do
			tinsert(list, name)
		end
	end
	return list
end

-- Depreciated
local function Addon_CopyTable(self, ...)
	return lib.tcopy(...)
end

local function Addon_GetProfileData(self, profile)
	if self.db and type(self.db.profiles) == "table" then
		return self.db.profiles[profile]
	end
end

local function Addon_CopyProfile(self, source, dest)
	if type(source) ~= "string" then
		source = Addon_GetCurProfileName(self)
	end

	if type(dest) ~= "string" then
		dest = Addon_GetCurProfileName(self)
	end

	if source == dest then
		return
	end

	if self.db and type(self.db.profiles) == "table" then
		if self.db.profiles[source] then
			self.db.profiles[dest] = lib.tcopy(self.db.profiles[source])
		end
	end
end

local function Addon_DeleteProfile(self, profile)
	if self.db and type(self.db.profiles) == "table" and type(profile) == "string" and profile ~= Addon_GetCurProfileName(self) then
		self.db.profiles[profile] = nil
	end
end

local function Addon_RegisterSlashCmd(self, ...)
	local UPPER_NAME = strupper(self.name)

	local i
	for i = 1, select("#", ...) do
		local cmd = select(i, ...)
		if type(cmd) == "string" then
			if strfind(cmd, "/") ~= 1 then
				cmd = "/"..cmd
			end

			_G["SLASH_"..UPPER_NAME..i] = cmd
		end
	end

	SlashCmdList[UPPER_NAME] = function(text)
		if type(self.OnSlashCmd) == "function" then
			self:OnSlashCmd(strtrim(text)) -- The addon wants to process the slash command itself
		elseif type(self.OnClashCmd) == "function" then
			self:OnClashCmd(strtrim(text)) -- The addon wants to process the slash command itself
		else
			local frame = self.optionFrame or self.optionPage or self.frame
			if type(frame) ~= "table" then
				return
			end

			if type(frame.Toggle) == "function" then
				frame:Toggle()
			elseif type(frame.Open) == "function" then
				frame:Open()
			elseif frame:IsShown() then
				frame:Hide()
			else
				frame:Show()
			end
		end
	end
end

local function Addon_RegisterDB(self, dbName, hasCharDB)
	if type(dbName) ~= "string" then
		dbName = nil
	end

	local private = self[PRIVATE]
	private.dbName, private.hasCharDB = dbName, hasCharDB

	if dbName and not self.db then
		self.db = {}
	end

	if hasCharDB and not self.chardb then
		self.chardb = {}
	end
end

local function Addon_RegisterBindingClick(self, button, name, text)
	if type(name) ~= "string" or type(button) ~= "table" then
		return
	end

	--local header = "BINDING_HEADER_"..strupper(self.name).."_TITLE"
	--if not _G[header] then
	--	_G[header] = self.title
	--end

	if type(text) == "string" then
		_G["BINDING_NAME_"..name] = text
	end

	button.bindingName, button.bindingText = name, text
	lib._bindingList[name] = button
end

local function EEO_RegisterEvent(self, event, method)
	if type(method) ~= "function" and type(method) ~= "string" then
		method = nil
	end

	local frame = self[PRIVATE].frame
	if not frame:IsEventRegistered(event) then
		frame:RegisterEvent(event)
	end
	frame.events[event] = method
end

local function EEO_UnregisterEvent(self, event)
	local frame = self[PRIVATE].frame
	frame.events[event] = nil
	if frame:IsEventRegistered(event) then
		frame:UnregisterEvent(event)
	end
end

local function EEO_IsEventRegistered(self, event)
	return self[PRIVATE].frame:IsEventRegistered(event)
end

local function EEO_RegisterAllEvents(self)
	return self[PRIVATE].frame:RegisterAllEvents()
end

local function EEO_UnregisterAllEvents(self)
	return self[PRIVATE].frame:UnregisterAllEvents()
end

local function EEO_SetInterval(self, interval)
	if type(interval) ~= "number" or interval < 0.2 then
		interval = 0.2
	end

	local frame = self[PRIVATE].frame
	frame.elapsed = 0
	frame.tickSeconds = interval
end

local function EEO_RegisterTick(self, interval)
	EEO_SetInterval(self, interval)
	self[PRIVATE].frame:Show()
end

local function EEO_UnregisterTick(self)
	local frame = self[PRIVATE].frame
	frame:Hide()
	frame.tickSeconds = nil
end

local function EEO_IsTicking(self)
	return self[PRIVATE].frame:IsShown()
end

local function EEOFrame_OnEvent(self, event, ...)
	local object = self.parentObject
	if type(object.OnEvent) == "function" then
		object:OnEvent(event, ...)
	else
		local func = self.events[event]
		if not func then
			func = object[event]
		elseif type(func) ~= "function" then -- string, number, etc
			func = object[func]
		end

		if type(func) == "function" then
			func(object, ...)
		end
	end
end

local function EEOFrame_OnUpdate(self, elapsed)
	local tickSeconds = self.tickSeconds
	if not tickSeconds then
		self:Hide()
		return
	end

	local updateElapsed = (self.elapsed or 0) + elapsed
	if updateElapsed >= tickSeconds then
		local object = self.parentObject
		if object.OnTick then
			object:OnTick(updateElapsed)
		end
		updateElapsed = 0
	end
	self.elapsed = updateElapsed
end

local function Lib_EmbedEventObject(object)
	if type(object) ~= "table" then
		object = {}
	end

	local private = lib._SetupTable(object, PRIVATE)
	local frame = CreateFrame("Frame")
	private.frame = frame
	frame.parentObject = object
	frame.events = {}
	frame:Hide()

	frame:SetScript("OnEvent", EEOFrame_OnEvent)
	frame:SetScript("OnUpdate", EEOFrame_OnUpdate)

	object.RegisterEvent = EEO_RegisterEvent
	object.UnregisterEvent = EEO_UnregisterEvent
	object.IsEventRegistered = EEO_IsEventRegistered
	object.RegisterAllEvents = EEO_RegisterAllEvents
	object.UnregisterAllEvents = EEO_UnregisterAllEvents

	object.RegisterTick = EEO_RegisterTick
	object.UnregisterTick = EEO_UnregisterTick
	object.SetInterval = EEO_SetInterval
	object.IsTicking = EEO_IsTicking

	return object
end

local function BCO_BroadcastEvent(self, event, ...)
	local callbacks = self[PRIVATE].broadcastCallbacks[event]
	if not callbacks then
		return
	end

	local i
	for i = 1, #callbacks do
		local arg1 = callbacks[i].arg1
		if arg1 then
			callbacks[i].func(arg1, ...)
		else
			callbacks[i].func(...)
		end
	end
end

local function BCO_RegisterEventCallback(self, event, func, arg1)
	if type(event) ~= "string" or type(func) ~= "function" then
		return
	end

	local list = self[PRIVATE].broadcastCallbacks
	local callbacks = list[event]
	if not callbacks then
		callbacks = {}
		list[event] = callbacks
	end

	tinsert(callbacks, { func = func, arg1 = arg1 })
end

local OPTION_EVENT_PREFX = "OnOptionChanged_" -- Option event name prefix

local function BCO_BroadcastOptionEvent(self, option, ...)
	if type(option) == "string" then
		BCO_BroadcastEvent(self, OPTION_EVENT_PREFX..option, ...)
	end
end

local function BCO_RegisterOptionCallback(self, option, func, arg1)
	if type(option) == "string" then
		BCO_RegisterEventCallback(self, OPTION_EVENT_PREFX..option, func, arg1)
	end
end

local function Lib_EmbedBroadcastObject(object)
	if type(object) ~= "table" then
		object = {}
	end

	local private = lib._SetupTable(object, PRIVATE)
	private.broadcastCallbacks = {}

	object.BroadcastEvent = BCO_BroadcastEvent
	object.RegisterEventCallback = BCO_RegisterEventCallback
	object.BroadcastOptionEvent = BCO_BroadcastOptionEvent
	object.RegisterOptionCallback = BCO_RegisterOptionCallback

	return object
end

local function Module_IsEnabled(self)
	return self[PRIVATE].enabled -- This usually should be over-ridden by addons
end

local function Module_Enable(self)
	if self:IsEnabled() then
		return
	end

	self[PRIVATE].enabled = 1
	if type(self.OnEnable) == "function" then
		self:OnEnable()
	end
end

local function Module_Disable(self)
	if not self:IsEnabled() then
		return
	end

	self[PRIVATE].enabled = nil
	self:UnregisterAllEvents()
	self:UnregisterTick()

	if type(self.OnDisable) == "function" then
		self:OnDisable()
	end
end

local function Addon_EnumModules(self, func, ...)
	if type(func) == "function" then
		local modules = self[PRIVATE].modules
		local  i
		for i = 1, #modules do
			func(modules[i], ...)
		end
	end
end

local function Addon_CallModule(self, module, method, ...)
	if type(module) ~= "table" then
		return
	end

	local func = module[method]
	if type(func) == "function" then
		return 1, func(module, ...)
	end

end

local function Addon_CallAllModules(self, method, ...)
	local modules = self[PRIVATE].modules
	local  i
	for i = 1, #modules do
		local module = modules[i]
		local func = module[method]
		if type(func) == "function" then
			func(module, ...)
		end
	end
end

local function Addon_CallAllEnabledModules(self, method, ...)
	local modules = self[PRIVATE].modules
	local  i
	for i = 1, #modules do
		local module = modules[i]
		if module:IsEnabled() then
			local func = module[method]
			if type(func) == "function" then
				func(module, ...)
			end
		end
	end
end

local function Addon_GetModule(self, key)
	local modules = self[PRIVATE].modules
	if type(key) ~= "string" then
		return modules[key]
	end

	local _, module
	for _, module in ipairs(modules) do
		if module.key == key then
			return module
		end
	end
end

local function Addon_NumModules(self)
	return #(self[PRIVATE].modules)
end

local function Addon_CreateModule(self, key, dbType, ...)
	if type(key) ~= "string" then
		error(format("bad argument #1 to 'addon:CreateModule' (string expected, got %s)", type(key)))
		return
	end

	local module = Addon_GetModule(self, key)
	if module then
		error(format("bad argument #1 to 'addon:CreateModule' (key '%s' already used)", key))
		return
	end

	if type(dbType) == "string" then
		dbType = strupper(dbType)
	else
		dbType = nil
	end

	local verifyFunc = self.OnVerifyModule
	if type(verifyFunc) == "function" and not verifyFunc(self, key, dbType, ...) then
		return
	end

	module = Lib_EmbedEventObject()

	module.key, module.dbType = key, dbType
	module.IsEnabled = Module_IsEnabled
	module.Enable = Module_Enable
	module.Disable = Module_Disable

	tinsert(self[PRIVATE].modules, module)

	if type(self.OnCreateModule) == "function" then
		self:OnCreateModule(module, key, ...)
	end

	return module
end

local function Addon_RegisterLocale(self, name, locale, data)
	if type(name) == "string" and type(data) == "table" and type(locale) == "string" then
		local moduleLocales = self[PRIVATE].moduleLocales

		if not moduleLocales[name] then
			moduleLocales[name] = {}
		end

		if not moduleLocales[name][locale] then
			moduleLocales[name][locale] = data
		end
	end
end

local function Addon_GetLocale(self, name, locale)
	local data = self[PRIVATE].moduleLocales[name]
	if data then
		if type(locale) ~= "string" then
			locale = GetLocale()
		end

		return data[locale] or data.enUS
	end
end

local function Addon_EmbedEventObject(self, object)
	return Lib_EmbedEventObject(object)
end

local function Addon_VerifyDBVersion(self, version, t)
	if type(version) ~= "number" then
		version = 0
	end

	if type(t) ~= "table" then
		t = self.db
	end

	if t and type(t.version) == "number" then
		return t.version >= version
	end
end

local function Addon_Initialized(self)
	return self[PRIVATE].initDone
end

local function EditBox_Highlight(self)
	self:SetFocus()
	self:HighlightText()
end

local function PopupData_EditBoxOnEnterPressed(self)
	local text = strtrim(self:GetText())
	local parent = self:GetParent()
	local func = parent.data2
	if text == "" or (type(func) == "function" and func(parent.data, text)) then
		EditBox_Highlight(self)
	else
		self:GetParent():Hide()
	end
end

local function PopupData_OnShow(self)
	local editBox = self.editBox
	if editBox:IsShown() and editBox:GetText() ~= "" then
		EditBox_Highlight(editBox)
	end
end

local function PopupData_EditBoxOnEscapePressed(self)
	self:GetParent():Hide()
end

local function PopupData_OnAccept(self, arg1, func)
	if type(func) ~= "function" then
		return
	end

	local editBox = self.editBox
	if not editBox:IsShown() then
		return func(arg1)
	end

	local text = strtrim(editBox:GetText())
	if text == "" or func(arg1, text) then
		EditBox_Highlight(editBox)
		return 1
	end
end

local function ParsePopupButtons(buttons)
	if buttons == "MB_OK" then
		return OKAY
	end

	if buttons == "MB_YESNO" then
		return YES, NO
	end

	if buttons == "MB_ACCEPTCANCEL" then
		return ACCEPT, CANCEL
	end

	if buttons == "MB_ACCEPTDECLINE" then
		return ACCEPT, DECLINE
	end

	return OKAY, CANCEL -- "MB_OKCANCEL" or others
end

local function Addon_PopupShowConfirm(self, text, func, arg1, buttons)
	local data = self[PRIVATE].popupData
	data.text =  text
	data.hasEditBox = nil
	data.editBoxWidth = nil
	data.button1, data.button2, data.button3 = ParsePopupButtons(buttons)

	local dialog = StaticPopup_Show(self[PRIVATE].popupId)
	if dialog then
		dialog.data = arg1
		dialog.data2 = func
		return dialog
	end
end

local function Addon_PopupShowAck(self, text, func, arg1)
	return Addon_PopupShowConfirm(self, text, func, arg1, "MB_OK")
end

local function Addon_PopupShowInput(self, text, func, arg1, default, wide)
	local data = self[PRIVATE].popupData
	data.text =  text
	data.hasEditBox = 1
	data.editBoxWidth = wide and 260 or nil
	data.button1, data.button2, data.button3 = ParsePopupButtons()

	local dialog = StaticPopup_Show(self[PRIVATE].popupId)
	if dialog then
		dialog.data = arg1
		dialog.data2 = func
		if default then
			dialog.editBox:SetText(tostring(default))
			return dialog
		end
	end
end

local function Addon_PopupHide(self)
	StaticPopup_Hide(self[PRIVATE].popupId)
end

function lib:CreateAddon(name, addon)
	if type(name) ~= "string" then
		error(format("bad argument #1 to 'LibAddonManager:CreateAddon' (string expected, got %s)", type(name)))
		return
	end

	if type(addon) ~= "table" then
		error(format("bad argument #2 to 'LibAddonManager:CreateAddon' (table expected, got %s)", type(addon)))
		return
	end

	if _G[name] then
		error(format("'LibAddonManager:CreateAddon' failed to register addon '%s' (object already exists)", name))
		return
	end

	_G[name] = addon
	addon.version = GetAddOnMetadata(name, "Version") or "1.0"
	addon.numericVersion = tonumber(addon.version) or 1.0
	addon.name = name
	addon.title = name -- This may be changed by developers into other locales, but just use name for now
	lib.CopyPlayerInfo(addon)
	addon.members = 0
	addon.spec = 1
	addon.path = "Interface\\AddOns\\"..name

	local popupId = "LibAddonManager_PopupData_"..name

	local popupData = {
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1,
		OnAccept = PopupData_OnAccept,
		EditBoxOnEnterPressed = PopupData_EditBoxOnEnterPressed,
		EditBoxOnEscapePressed = PopupData_EditBoxOnEscapePressed,
		OnShow = PopupData_OnShow,
	}

	StaticPopupDialogs[popupId] = popupData

	addon[PRIVATE] = { modules = {}, moduleLocales = {}, popupData = popupData, popupId = popupId }
	Lib_EmbedEventObject(addon)
	Lib_EmbedBroadcastObject(addon)

	addon.Print = Addon_Print
	addon.Debug = Addon_Debug
	addon.RegisterDB = Addon_RegisterDB
	addon.GetCurProfileName = Addon_GetCurProfileName
	addon.GetProfileNameList = Addon_GetProfileNameList
	addon.GetProfileData = Addon_GetProfileData
	addon.CopyProfile = Addon_CopyProfile
	addon.DeleteProfile = Addon_DeleteProfile
	addon.Initialized = Addon_Initialized
	addon.RegisterBindingClick = Addon_RegisterBindingClick
	addon.RegisterSlashCmd = Addon_RegisterSlashCmd
	addon.RegisterLocale = Addon_RegisterLocale
	addon.GetLocale = Addon_GetLocale
	addon.EmbedEventObject = Addon_EmbedEventObject
	addon.VerifyDBVersion = Addon_VerifyDBVersion
	addon.PopupShowConfirm = Addon_PopupShowConfirm
	addon.PopupShowAck = Addon_PopupShowAck
	addon.PopupShowInput = Addon_PopupShowInput
	addon.PopupHide = Addon_PopupHide

	addon.tcopy = lib.tcopy
	addon.tfind = lib.tfind

	addon.CreateModule = Addon_CreateModule
	addon.NumModules = Addon_NumModules
	addon.GetModule = Addon_GetModule
	addon.EnumModules = Addon_EnumModules
	addon.CallModule = Addon_CallModule
	addon.CallAllModules = Addon_CallAllModules
	addon.CallAllEnabledModules = Addon_CallAllEnabledModules

	-- Depreciated functions but stay for downward compatibility
	addon.CopyTable = Addon_CopyTable

	tinsert(lib._addonList, addon)
	return addon
end

-------------------------------------------------------
-- The library background event frame works
-------------------------------------------------------

function lib.CopyPlayerInfo(addon)
	local key, val
	for key, val in pairs(PLAYER_INFO) do
		addon[key] = val
	end
end

local function Lib_UpdatePlayerInfo()
	PLAYER_INFO.player = UnitName("player")
	PLAYER_INFO.realm = GetRealmName()
	PLAYER_INFO.faction = UnitFactionGroup("player")
	PLAYER_INFO.class = select(2, UnitClass("player"))
	PLAYER_INFO.race = select(2, UnitRace("player"))
	PLAYER_INFO.guid = UnitGUID("player")
	PROFILE_NAME = PLAYER_INFO.player.." - "..PLAYER_INFO.realm
end

Lib_UpdatePlayerInfo()

function lib._SetupTable(parent, key, isFrame)
	if type(parent) ~= "table" or not key then
		return
	end

	local t = parent[key]
	local isNew

	if type(t) ~= "table" then
		isNew = 1
		if isFrame then
			t = CreateFrame("Frame")
		else
			t = {}
		end
		parent[key] = t
	end
	return t, isNew
end

lib._SetupTable(lib, "_addonList")
lib._SetupTable(lib, "_bindingList")

local function Module_InitializeDB(self, db, chardb)
	local moduledb, moduledbNew, moduleChardb, moduleChardbNew

	if strfind(self.dbType or "", "ACCOUNT") then
		local temp = lib._SetupTable(db, "modules")
		moduledb, moduledbNew = lib._SetupTable(temp, self.key)
	end

	if strfind(self.dbType or "", "CHAR") then
		local temp = lib._SetupTable(chardb, "modules")
		moduleChardb, moduleChardbNew = lib._SetupTable(temp, self.key)
	end

	self.db, self.chardb = moduledb, moduleChardb

	local private = self[PRIVATE]
	if type(self.OnInitialize) == "function"  then
		self:OnInitialize(moduledb, moduledbNew, moduleChardb, moduleChardbNew)
	end
end

local function Lib_CallAllAddonsAndEnabledModules(method, ...)
	local _, addon
	for _, addon in ipairs(lib._addonList) do
		local func = addon[method]
		if type(func) == "function" then
			func(addon, ...)
		end

		Addon_CallAllEnabledModules(addon, method, ...)
	end
end

local function Lib_CheckInitDB(addon)
	local private = addon[PRIVATE]
	local db, dbIsNew = lib._SetupTable(_G, private.dbName)
	addon.db = db

	local chardb, chardbIsNew

	if db and private.hasCharDB then
		if type(private.hasCharDB) == "string" then
			chardb, chardbIsNew = lib._SetupTable(_G, private.hasCharDB)
			addon.chardb = chardb
		else
			local profileName = addon:GetCurProfileName()
			local profiles = lib._SetupTable(db, "profiles")
			chardb, chardbIsNew = lib._SetupTable(profiles, profileName)
			addon.chardb = chardb
		end
	end

	if type(addon.OnInitialize) == "function" then
		addon:OnInitialize(db, dbIsNew, chardb, chardbIsNew)
	end
end

local function Lib_ApplyAllBindings()
	local name, button
	for name, button in pairs(lib._bindingList) do
		ClearOverrideBindings(button)
		local key1, key2 = GetBindingKey(name)
		if key2 then
			SetOverrideBindingClick(button, false, key2, button:GetName())
		end

		if key1 then
			SetOverrideBindingClick(button, false, key1, button:GetName())
		end
	end
end

local function EventFrame_TryUpdateBindings(self)
	if InCombatLockdown() then
		self.hasPending = 1 -- Delay call
	else
		Lib_ApplyAllBindings()
	end
end

local function lib_SetAllAddonsKey(key, value)
	local _, addon
	for _, addon in ipairs(lib._addonList) do
		addon[key] = value
	end
end

lib.members = 0
local function Lib_UpdateGroupStats()
	local group, leadship
	local members = GetNumGroupMembers()
	if IsInRaid() then
		group = "raid"
		if UnitIsGroupLeader("player") then
			leadship = "leader"
		elseif UnitIsRaidOfficer("player") then
			leadship = "officer"
		end
	elseif members > 1 then
		group = "party"
		if UnitIsGroupLeader("player") then
			leadship = "leader"
		end
	end

	if lib.group ~= group or lib.leadship ~= leadship or lib.members ~= members then
		lib.group, lib.leadship, lib.members = group, leadship, members
		lib_SetAllAddonsKey("group", group)
		lib_SetAllAddonsKey("leadship", leadship)
		lib_SetAllAddonsKey("members", members)
		Lib_CallAllAddonsAndEnabledModules("OnGroupChange", group, leadship, members)
	end
end

lib.spec = 1
local function Lib_UpdateSpec(force)
	local spec = GetSpecialization()
	if force or spec ~= lib.spec then
		lib.spec = spec
		lib_SetAllAddonsKey("spec", spec)
		Lib_CallAllAddonsAndEnabledModules("OnSpecChange", spec)
	end
end

local frame = lib._SetupTable(lib, "_eventFrame", 1)

frame:RegisterEvent("PLAYER_LOGIN")

local function LibFrame_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 1 then
		return
	end

	self.elapsed = 0
	self.count = (self.count or 0) + 1
	if self.count > 3 then
		self:SetScript("OnUpdate", nil)
		Lib_CallAllAddonsAndEnabledModules("OnControlReady")
	end
end

frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		Lib_UpdatePlayerInfo()

		local _, addon
		for _, addon in ipairs(lib._addonList) do
			lib.CopyPlayerInfo(addon)
			Lib_CheckInitDB(addon)
		end

		for _, addon in ipairs(lib._addonList) do
			Addon_EnumModules(addon, Module_InitializeDB, addon.db, addon.chardb)
		end

		for _, addon in ipairs(lib._addonList) do
			addon[PRIVATE].initDone = 1

			if type(addon.OnModulesInitDone) == "function" then
				addon:OnModulesInitDone()
			end
		end

		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("UPDATE_BINDINGS")
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		EventFrame_TryUpdateBindings(self)
		Lib_UpdateSpec(1)
		Lib_UpdateGroupStats()

		self:SetScript("OnUpdate", LibFrame_OnUpdate)

	elseif event == "UPDATE_BINDINGS" then
		EventFrame_TryUpdateBindings(self)

	elseif event == "PLAYER_REGEN_DISABLED" then
		Lib_CallAllAddonsAndEnabledModules("OnEnterCombat")

	elseif event == "PLAYER_REGEN_ENABLED" then
		if self.hasPending then
			self.hasPending = nil
			Lib_ApplyAllBindings()
		end
		Lib_CallAllAddonsAndEnabledModules("OnLeaveCombat")

	elseif event == "GROUP_ROSTER_UPDATE" then
		Lib_UpdateGroupStats()

	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		Lib_UpdateSpec()
	end
end)
-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local pairs = _G.pairs


-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local panel = _G.CreateFrame("Frame")
private.Modules = panel


panel.AlphaDefault = 0.5

panel.List = {}
local LoadQueue = {}

local function GetEnabled(Options, Name)
	return Options.Modules[Name] ~= false -- Uninitialized (nil) defaults to enabled
end

local function GetAlpha(Options, Name)
	return Options.ModulesAlpha[Name] or panel.List[Name].AlphaDefault or panel.AlphaDefault
end

local SafeCall
do
	-- Checks the Success return of pcall.
	local function Catch(Success, ...)
		if not Success then
			geterrorhandler()(...)
		end
		return Success, ...
	end

	local pcall = pcall
	-- Similar to pcall, but throws errors without ending execution.
	function SafeCall(Function, ...)
		return Catch(pcall(Function, ...))
	end
end

-- Sets a module's overlay alpha.
local function SetAlpha(Module, Alpha)
	if Module.Enabled then
		Module.Alpha = Alpha
		if Module.SetAlpha then
			SafeCall(Module.SetAlpha, Module, Alpha)
		end
	end
end

-- Disables a module.
local function Disable(Module)
	if Module.Enabled then
		if Module.OnDisable then
			SafeCall(Module.OnDisable, Module)
		end
		Module.Enabled = nil
	end
end

-- Enables a module.
local function Enable(Module)
	if Module.Loaded and not Module.Enabled then
		Module.Enabled = true
		if Module.OnEnable then
			SafeCall(Module.OnEnable, Module)
		end
		SetAlpha(Module, GetAlpha(private.Options, Module.Name))
		if Module.OnMapUpdate then
			SafeCall(Module.OnMapUpdate, Module)
		end
	end
end

-- Shuts a module down and GCs resources created in OnLoad.
local function Unload(Module)
	if Module.Loaded then
		Disable(Module)

		if Module.OnUnload then
			SafeCall(Module.OnUnload, Module)
		end
		Module.Loaded = nil
	end
	Module.OnLoad = nil
	Module.OnUnload = nil
	Module.OnEnable = nil
	Module.OnDisable = nil
	Module.OnMapUpdate = nil
	Module.SetAlpha = nil
end

-- Loads module and initializes its settings.
local function Load(Module)
	if Module.Registered and not Module.Loaded then
		Module.Loaded = true
		if Module.OnLoad then
			SafeCall(Module.OnLoad, Module)
			Module.OnLoad = nil
		end

		if panel.Synchronized and GetEnabled(private.Options, Module.Name) then
			Enable(Module)
		end
	end
end

-- Unloads all of the module's resources.
local function Unregister(Module)
	if Module.Registered then
		Unload(Module)

		if Module.OnUnregister then
			SafeCall(Module.OnUnregister, Module)
			Module.OnUnregister = nil
		end

		Module.Registered = nil
		Module.Config:Unregister()
	end
end

-- Prepares a module to load.
local function Register(Module, Name, Label, ParentAddOn)
	if not Module.Registered then
		Module.Registered, Module.Name = true, Name
		Module.Config = private.Config.ModuleRegister(Module, Label)
		-- No need for an OnRegister handler

		if not ParentAddOn or IsAddOnLoaded(ParentAddOn) then
			Load(Module)
		else
			local _, _, _, Loadable, Reason = GetAddOnInfo(ParentAddOn)
			if Loadable or (Reason == "DISABLED" and IsAddOnLoadOnDemand(ParentAddOn)) or Reason == "DEMAND_LOADED" then -- Potentially loadable
			LoadQueue[ParentAddOn:upper()] = Module
			else
				Unregister(Module)
			end
		end
	end
end

do
	-- Calls OnMapUpdate for all enabled modules.
	local function UpdateModules(Map)
		for Name, Module in pairs(panel.List) do
			if Module.Enabled and Module.OnMapUpdate then
				SafeCall(Module.OnMapUpdate, Module, Map)
			end
		end
	end

	local UpdateAll, UpdateMaps = false, {}

	local function OnUpdate()
		panel:SetScript("OnUpdate", nil)

		if UpdateAll then
			UpdateAll = false
			UpdateModules(nil)
		else
			for Map in pairs(UpdateMaps) do
				UpdateModules(Map)
				UpdateMaps[Map] = nil
			end
		end
	end

	--- Updates a map for all active modules.
	-- @param Map MapID to update, or nil to update all maps.
	function panel.UpdateMap(Map)
		if not UpdateAll then
			if Map then
				UpdateMaps[Map] = true
			else
				UpdateAll = true
				wipe(UpdateMaps)
			end
			panel:SetScript("OnUpdate", OnUpdate)
		end
	end
end


--- Registers a canvas module to paint polygons on.
-- @param Name Name of module used in settings keys, etc.
-- @param Module Module table containing methods.
-- @param Label Name displayed in configuration screen.
-- @param ParentAddOn Optional dependency to wait on to load.
function panel.Register(Name, Module, Label, ParentAddOn)
	panel.List[Name] = Module
	Register(Module, Name, Label, ParentAddOn)
end

-- Disables the module for the session and disables its configuration controls.
function panel.Unregister(Name)
	Unregister(panel.List[Name])
end


--- Enables a module.
-- @return True if enabled successfully.
function panel.Enable(Name)
	private.Options.Modules[Name] = true

	local Module = panel.List[Name]
	Module.Config:SetEnabled(true)
	Enable(Module)
	return true
end

--- Disables a module.
-- @return True if disabled successfully.
function panel.Disable(Name)
	if GetEnabled(private.Options, Name) then
		private.Options.Modules[Name] = false

		local Module = panel.List[Name]
		Module.Config:SetEnabled(false)
		Disable(Module)
		return true
	end
end

-- Sets the module's alpha setting.
function panel.SetAlpha(Name, Alpha)
	private.Options.ModulesAlpha[Name] = Alpha
	local Module = panel.List[Name]
	Module.Config.Alpha:SetValue(Alpha)
	SetAlpha(Module, Alpha)
end

-- Loads modules that depend on other mods as they load.
function panel:ADDON_LOADED(_, ParentAddOn)
	ParentAddOn = ParentAddOn:upper()
	local Module = LoadQueue[ParentAddOn]
	if Module then
		LoadQueue[ParentAddOn] = nil

		if Module.Registered then -- Not unregistered
		Load(Module)
		end
	end
end

-- Common event handler.
function panel:OnEvent(Event, ...)
	if self[Event] then
		return self[Event](self, Event, ...)
	end
end

do
	local OptionsExtraDefault = {}

	-- Synchronizes settings of all modules.
	function panel.OnSynchronize(Options)
		panel.Synchronized = true
		-- Preserve options for missing modules
		for Name, Enabled in pairs(Options.Modules) do
			if not panel.List[Name] then
				private.Options.Modules[Name] = Enabled
				private.Options.ModulesAlpha[Name] = Options.ModulesAlpha[Name]
			end
		end

		-- Synchronize extra module options
		for Name, Module in pairs(panel.List) do
			panel[GetEnabled(Options, Name) and "Enable" or "Disable"](Name)
			panel.SetAlpha(Name, GetAlpha(Options, Name))

			if Module.OnSynchronize then
				if not private.Options.ModulesExtra[Name] then
					private.Options.ModulesExtra[Name] = {}
				end
				SafeCall(Module.OnSynchronize, Module, Options.ModulesExtra[Name] or OptionsExtraDefault)
			end
		end
		for Name, Extra in pairs(Options.ModulesExtra) do
			if not panel.List[Name] then
				private.Options.ModulesExtra[Name] = CopyTable(Extra)
			end
		end
	end
end

panel:SetScript("OnEvent", panel.OnEvent)
panel:RegisterEvent("ADDON_LOADED")

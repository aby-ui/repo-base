-- Dominos.lua - The main driver for Dominos
local AddonName, AddonTable = ...
local Addon = LibStub('AceAddon-3.0'):NewAddon(AddonTable, AddonName, 'AceEvent-3.0', 'AceConsole-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

local ADDON_VERSION = GetAddOnMetadata(AddonName, 'Version')
local CONFIG_ADDON_NAME = AddonName .. '_Config'
local CONFIG_VERSION = 1

--[[ Events ]]

function Addon:OnInitialize()
	-- setup db
	self:CreateDatabase()
	self:UpgradeDatabase()

	-- create a loader for the options menu
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function()
		f:SetScript('OnShow', nil)
		LoadAddOn(CONFIG_ADDON_NAME)
	end)

	-- keybound support
	local kb = LibStub('LibKeyBound-1.0')
	kb.RegisterCallback(self, 'LIBKEYBOUND_ENABLED')
	kb.RegisterCallback(self, 'LIBKEYBOUND_DISABLED')

    --aby8 force azerite
    if self.db.profile and self.db.profile.frames and self.db.profile.frames.artifact then
        if not self.db.profile.update801 then
            self.db.profile.frames.artifact.mode = 'azerite';
            self.db.profile.update801 = true
        end
        if not self.db.profile.update807 then
            (self.db.profile.frames.artifact.display or {}).bonus = true;
            self.db.profile.update807 = true
        end
    end
end

function Addon:OnEnable()
	self:UpdateUseOverrideUI()
	self:Load()
end

-- configuration events
function Addon:OnUpgradeDatabase(oldVersion, newVersion)
end

function Addon:OnUpgradeAddon(oldVersion, newVersion)
	self:Printf(L.Updated, ADDON_VERSION, self:GetBuild())
end

-- keybound events
function Addon:LIBKEYBOUND_ENABLED()
	for _,frame in self.Frame:GetAll() do
		if frame.KEYBOUND_ENABLED then
			frame:KEYBOUND_ENABLED()
		end
	end
end

function Addon:LIBKEYBOUND_DISABLED()
	for _,frame in self.Frame:GetAll() do
		if frame.KEYBOUND_DISABLED then
			frame:KEYBOUND_DISABLED()
		end
	end
end

-- profile events
function Addon:OnNewProfile(msg, db, name)
	self:Printf(L.ProfileCreated, name)
end

function Addon:OnProfileDeleted(msg, db, name)
	self:Printf(L.ProfileDeleted, name)
end

function Addon:OnProfileChanged(msg, db, name)
	self:Printf(L.ProfileLoaded, name)
end

function Addon:OnProfileCopied(msg, db, name)
	self:Printf(L.ProfileCopied, name)
end

function Addon:OnProfileReset(msg, db)
	self:Printf(L.ProfileReset, db:GetCurrentProfile())
end

-- module actions
-- Load is called when the addon is first enabled, and also whenever a profile
-- is loaded
function Addon:Load()
	local function module_load(module, id)
		if not self.db.profile.modules[id] then
			return
		end

		local f = module.Load
		if type(f) == "function"  then
			f(module)
		end
	end

	for id, module in self:IterateModules() do
		local success, msg = pcall(module_load, module, id)
		if not success then
			self:Printf('Failed to load %s\n%s', module:GetName(), msg)
		end
	end

	self.Frame:ForAll('Reanchor')
	self:GetModule('ButtonThemer'):Reskin()
end

-- unload is called when we're switching profiles
function Addon:Unload()
	local function module_unload(module, id)
		if not self.db.profile.modules[id] then
			return
		end

		local f = module.Unload
		if type(f) == "function"  then
			f(module)
		end
	end

	-- unload any module stuff
	for id, module in self:IterateModules() do
		local success, msg = pcall(module_unload, module, id)
		if not success then
			self:Printf('Failed to unload %s\n%s', module:GetName(), msg)
		end
	end
end

-- db actions
function Addon:CreateDatabase()
    -- XXX 163
    self.db = LibStub('AceDB-3.0'):New('DominosDB', self:GetDatabaseDefaults(), '爱不易-'..(GetRealmName())..'-'..(UnitName'player'))
    self:U1_InitPreset()
    -- XXX 163 end

	local db = LibStub('AceDB-3.0'):New(AddonName .. 'DB', self:GetDatabaseDefaults(), UnitClass('player'))

	db.RegisterCallback(self, 'OnNewProfile')
	db.RegisterCallback(self, 'OnProfileChanged')
	db.RegisterCallback(self, 'OnProfileCopied')
	db.RegisterCallback(self, 'OnProfileReset')
	db.RegisterCallback(self, 'OnProfileDeleted')

	self.db = db
end

function Addon:GetDatabaseDefaults()
	return {
		global = {
			-- configVersion = CONFIG_VERSION,
			-- addonVersion = ADDON_VERSION
		},

		profile = {
			possessBar = 1,

			-- if true, applies a default dominos skin to buttons
			-- when masque is not enabled
			applyButtonTheme = true,

			sticky = true,
			linkedOpacity = false,
			showMacroText = true,
			showBindingText = true,
			showCounts = true,
			showEquippedItemBorders = true,
			showTooltips = true,
			showTooltipsCombat = true,
			useOverrideUI = not self:IsBuild("classic"),

			minimap = {
				minimapPos = 10,
				hide = false,
			},

			ab = {
				count = 10,
				showgrid = true,
			},

			frames = {
				bags = {
					point = 'BOTTOMRIGHT',
					oneBag = false,
					keyRing = true,
					spacing = 2,
				}
			},

			-- what modules are enabled
			-- module[id] = enabled
			modules = {
				["**"] = true
			}
		}
	}
end

function Addon:UpgradeDatabase()
	local configVerison = self.db.global.configVersion
	if configVerison ~= CONFIG_VERSION then
		self:OnUpgradeDatabase(configVerison, CONFIG_VERSION)
		self.db.global.configVersion = CONFIG_VERSION
	end

	local addonVersion = self.db.global.addonVersion
	if addonVersion ~= ADDON_VERSION then
		self:OnUpgradeAddon(addonVersion, ADDON_VERSION)
		self.db.global.addonVersion = ADDON_VERSION
	end
end

-- profile actions
function Addon:SaveProfile(name)
	local toCopy = self.db:GetCurrentProfile()
	if name and name ~= toCopy then
		self:Unload()
		self.db:SetProfile(name)
		self.db:CopyProfile(toCopy)
		self:Load()
	end
end

function Addon:SetProfile(name)
	local profile = self:MatchProfile(name)
	if profile and profile ~= self.db:GetCurrentProfile() then
		self:Unload()
		self.db:SetProfile(profile)
		self:Load()
	else
		self:Printf(L.InvalidProfile, name or 'null')
	end
end

function Addon:DeleteProfile(name)
	local profile = self:MatchProfile(name)
	if profile and profile ~= self.db:GetCurrentProfile() then
		self.db:DeleteProfile(profile)
	else
		self:Print(L.CantDeleteCurrentProfile)
	end
end

function Addon:CopyProfile(name)
	if name and name ~= self.db:GetCurrentProfile() then
		self:Unload()
		self.db:CopyProfile(name)
		self:Load()
	end
end

function Addon:ResetProfile()
	self:Unload()
	self.db:ResetProfile()
	self:Load()
end

function Addon:ListProfiles()
	self:Print(L.AvailableProfiles)

	local current = self.db:GetCurrentProfile()
	for _,k in ipairs(self.db:GetProfiles()) do
		if k == current then
			print(' - ' .. k, 1, 1, 0)
		else
			print(' - ' .. k)
		end
	end
end

function Addon:MatchProfile(name)
	name = name:lower()

	local nameRealm = name .. ' - ' .. GetRealmName():lower()
	local match

	for _, k in ipairs(self.db:GetProfiles()) do
		local key = k:lower()
		if key == name then
			return k
		elseif key == nameRealm then
			match = k
		end
	end
	return match
end

-- options menu display
function Addon:GetOptions()
	local options = self.Options

	if (not options) and LoadAddOn(CONFIG_ADDON_NAME) then
		options = self.Options
	end

	return options
end

function Addon:ShowOptions()
	if InCombatLockdown() then return end

	local options = self:GetOptions()
	if options then
		options:ShowAddonPanel()
		return true
	end

	return false
end

function Addon:NewMenu()
	local options = self:GetOptions()
	if options then
		return options.Menu:New()
	end
	return nil
end

function Addon:IsConfigAddonEnabled()
	if GetAddOnEnableState(UnitName('player'), CONFIG_ADDON_NAME) >= 1 then
		return true
	end
end

-- miscellanous actions
function Addon:PrintVersion()
	self:Printf("%s-%s", ADDON_VERSION, self:GetBuild())
end


--[[ Configuration ]]--

-- frame configuration
function Addon:SetFrameSets(id, sets)
	id = tonumber(id) or id

	self.db.profile.frames[id] = sets

	return self.db.profile.frames[id]
end

function Addon:GetFrameSets(id)
	return self.db.profile.frames[tonumber(id) or id]
end

-- configuration mode
Addon.locked = true

function Addon:SetLock(enable)
	if InCombatLockdown() and (not enable) then
		return
	end

	self.locked = enable or false

	if self:Locked() then
		self:GetModule('ConfigOverlay'):Hide()
	else
		LibStub('LibKeyBound-1.0'):Deactivate()
		self:GetModule('ConfigOverlay'):Show()
	end
end

function Addon:Locked()
	return self.locked
end

function Addon:ToggleLockedFrames()
	self:SetLock(not self:Locked())
end

-- binding mode
function Addon:ToggleBindingMode()
	self:SetLock(true)
	LibStub('LibKeyBound-1.0'):Toggle()
end

function Addon:IsBindingModeEnabled()
	return LibStub('LibKeyBound-1.0'):IsShown()
end

-- scale
function Addon:ScaleFrames(...)
	local numArgs = select('#', ...)
	local scale = tonumber(select(numArgs, ...))

	if scale and scale > 0 and scale <= 10 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameScale', scale)
		end
	end
end

-- opacity
function Addon:SetOpacityForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameAlpha', alpha)
		end
	end
end

-- faded opacity
function Addon:SetFadeForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFadeMultiplier', alpha)
		end
	end
end

-- columns
function Addon:SetColumnsForFrames(...)
	local numArgs = select('#', ...)
	local cols = tonumber(select(numArgs, ...))

	if cols then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetColumns', cols)
		end
	end
end

-- spacing
function Addon:SetSpacingForFrame(...)
	local numArgs = select('#', ...)
	local spacing = tonumber(select(numArgs, ...))

	if spacing then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetSpacing', spacing)
		end
	end
end

-- padding
function Addon:SetPaddingForFrames(...)
	local numArgs = select('#', ...)
	local pW, pH = select(numArgs - 1, ...)

	if tonumber(pW) and tonumber(pH) then
		for i = 1, numArgs - 2 do
			self.Frame:ForFrame(select(i, ...), 'SetPadding', tonumber(pW), tonumber(pH))
		end
	end
end

-- visibility
function Addon:ShowFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'ShowFrame')
	end
end

function Addon:HideFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'HideFrame')
	end
end

function Addon:ToggleFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'ToggleFrame')
	end
end

-- clickthrough
function Addon:SetClickThroughForFrames(...)
	local numArgs = select('#', ...)
	local enable = select(numArgs - 1, ...)

	for i = 1, numArgs - 2 do
		self.Frame:ForFrame(select(i, ...), 'SetClickThrough', tonumber(enable) == 1)
	end
end

-- empty button display
function Addon:ToggleGrid()
	self:SetShowGrid(not self:ShowGrid())
end

function Addon:SetShowGrid(enable)
	self.db.profile.showgrid = enable or false
	self.ActionBar:ForAll('UpdateGrid')
end

function Addon:ShowGrid()
	return self.db.profile.showgrid
end

-- right click selfcast
function Addon:SetRightClickUnit(unit)
	self.db.profile.ab.rightClickUnit = unit
	self.ActionBar:ForAll('UpdateRightClickUnit')
end

function Addon:GetRightClickUnit()
	return self.db.profile.ab.rightClickUnit
end

-- binding text
function Addon:SetShowBindingText(enable)
	self.db.profile.showBindingText = enable or false

	for _,f in self.Frame:GetAll() do
		if f.buttons then
			for _,b in pairs(f.buttons) do
				if b.UpdateHotkey then
					b:UpdateHotkey()
				end
			end
		end
	end
end

function Addon:ShowBindingText()
	return self.db.profile.showBindingText
end

-- macro text
function Addon:SetShowMacroText(enable)
	self.db.profile.showMacroText = enable or false

	for _, f in self.Frame:GetAll() do
		if f.buttons then
			for _,b in pairs(f.buttons) do
				if b.UpdateMacro then
					b:UpdateMacro()
				end
			end
		end
	end
end

function Addon:ShowMacroText()
	return self.db.profile.showMacroText
end

-- border
function Addon:SetShowEquippedItemBorders(enable)
	self.db.profile.showEquippedItemBorders = enable or false

	for _, f in self.Frame:GetAll() do
		if f.buttons then
			for _, b in pairs(f.buttons) do
				if b.UpdateShowEquippedItemBorders then
					b:UpdateShowEquippedItemBorders()
				end
			end
		end
	end
end

function Addon:ShowEquippedItemBorders()
	return self.db.profile.showEquippedItemBorders
end

-- override ui
function Addon:SetUseOverrideUI(enable)
	self.db.profile.useOverrideUI = enable and true or false
	self:UpdateUseOverrideUI()
end

function Addon:UsingOverrideUI()
	return self.db.profile.useOverrideUI and not self:IsBuild("classic")
end

function Addon:UpdateUseOverrideUI()
	local overrideBar = _G.OverrideActionBar
	if not overrideBar then return end

	local usingOverrideUI = self:UsingOverrideUI()

	self.OverrideController:SetAttribute('state-useoverrideui', usingOverrideUI)

	overrideBar:ClearAllPoints()
	if usingOverrideUI then
		overrideBar:SetPoint('BOTTOM')
	else
		overrideBar:SetPoint('LEFT', overrideBar:GetParent(), 'RIGHT', 100, 0)
	end
end

-- override action bar selection
function Addon:SetOverrideBar(id)
	local prevBar = self:GetOverrideBar()
	self.db.profile.possessBar = id
	local newBar = self:GetOverrideBar()

	prevBar:UpdateOverrideBar()
	newBar:UpdateOverrideBar()
end

function Addon:GetOverrideBar()
	return self.Frame:Get(self.db.profile.possessBar)
end

-- action bar counts
function Addon:SetNumBars(count)
	count = max(min(count, 120), 1)

	if count ~= self:NumBars() then
		self.ActionBar:ForAll('Delete')
		self.db.profile.ab.count = count

		for i = 1, self:NumBars() do
			self.ActionBar:New(i)
		end
	end
end

function Addon:SetNumButtons(count)
	self:SetNumBars(120 / count)
end

function Addon:NumBars()
	return self.db.profile.ab.count
end

-- tooltips
function Addon:ShowTooltips()
	return self.db.profile.showTooltips
end

function Addon:SetShowTooltips(enable)
	self.db.profile.showTooltips = enable or false
	self:GetModule('Tooltips'):SetShowTooltips(enable)
end

function Addon:SetShowCombatTooltips(enable)
	self.db.profile.showTooltipsCombat = enable or false
	self:GetModule('Tooltips'):SetShowTooltipsInCombat(enable)
end

function Addon:ShowCombatTooltips()
	return self.db.profile.showTooltipsCombat
end

-- minimap button
function Addon:SetShowMinimap(enable)
	self.db.profile.minimap.hide = not enable
	self:GetModule('Launcher'):Update()
end

function Addon:ShowingMinimap()
	return not self.db.profile.minimap.hide
end

-- sticky bars
function Addon:SetSticky(enable)
	self.db.profile.sticky = enable or false

	if not enable then
		self.Frame:ForAll('Stick')
		self.Frame:ForAll('Reposition')
	end
end

function Addon:Sticky()
	return self.db.profile.sticky
end

-- linked opacity
function Addon:SetLinkedOpacity(enable)
	self.db.profile.linkedOpacity = enable or false

	self.Frame:ForAll('UpdateWatched')
	self.Frame:ForAll('UpdateAlpha')
end

function Addon:IsLinkedOpacityEnabled()
	return self.db.profile.linkedOpacity
end

-- button theming toggle
function Addon:ThemeButtons()
	return self.db.profile.applyButtonTheme
end

function Addon:SetThemeButtons(enable)
	self.db.profile.applyButtonTheme = enable or false

	self:GetModule("ButtonThemer"):Reskin()
end

-- show counts toggle
function Addon:ShowCounts()
	return self.db.profile.showCounts
end

function Addon:SetShowCounts(enable)
	self.db.profile.showCounts = enable or false

	for _, f in self.Frame:GetAll() do
		if f.buttons then
			for _,b in pairs(f.buttons) do
				if b.UpdateCount then
					b:UpdateCount()
				end
			end
		end
	end
end


-- build test
function Addon:GetBuild()
	local project = WOW_PROJECT_ID

	if project == WOW_PROJECT_CLASSIC then
		return "classic"
	elseif project == WOW_PROJECT_MAINLINE then
		return "retail"
	else
		return "unknown"
	end
end

function Addon:IsBuild(...)
	local build = self:GetBuild()

	for i = 1, select("#", ...) do
		if build == select(i, ...):lower() then
			return true
		end
	end

	return false
end

-- exports
-- luacheck: push ignore 122
_G[AddonName] = Addon
-- luacheck: pop

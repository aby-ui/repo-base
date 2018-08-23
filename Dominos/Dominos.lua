--[[
	Dominos.lua
		Driver for Dominos Frames
--]]

local AddonName, AddonTable = ...
local Addon = LibStub('AceAddon-3.0'):NewAddon(AddonTable, AddonName, 'AceEvent-3.0', 'AceConsole-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

local CURRENT_VERSION = GetAddOnMetadata(AddonName, 'Version')
local CONFIG_ADDON_NAME = AddonName .. '_Config'

--[[ Startup ]]--

function Addon:OnInitialize()

	-- XXX 163
    self.db = LibStub('AceDB-3.0'):New('DominosDB', self:GetDefaults(),
    '有爱-'..(GetRealmName())..'-'..(UnitName'player'))
    self:U1_InitPreset()
    -- XXX 163 end
    
	--register database events
	self.db = LibStub('AceDB-3.0'):New(AddonName .. 'DB', self:GetDefaults(), UnitClass('player'))
	self.db.RegisterCallback(self, 'OnNewProfile')
	self.db.RegisterCallback(self, 'OnProfileChanged')
	self.db.RegisterCallback(self, 'OnProfileCopied')
	self.db.RegisterCallback(self, 'OnProfileReset')
	self.db.RegisterCallback(self, 'OnProfileDeleted')

	--version update
	if _G[AddonName .. 'Version'] then
		if _G[AddonName .. 'Version'] ~= CURRENT_VERSION then
			self:UpdateSettings(_G[AddonName .. 'Version']:match('(%w+)%.(%w+)%.(%w+)'))
			self:UpdateVersion()
		end
	--new user
	else
		_G[AddonName .. 'Version'] = CURRENT_VERSION
	end

	--create a loader for the options menu
	local f = CreateFrame('Frame', nil, _G['InterfaceOptionsFrame'])
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn(CONFIG_ADDON_NAME)
	end)

	--keybound support
	local kb = LibStub('LibKeyBound-1.0')
	kb.RegisterCallback(self, 'LIBKEYBOUND_ENABLED')
	kb.RegisterCallback(self, 'LIBKEYBOUND_DISABLED')

    --aby8 force azerite
    if self.db.profile and self.db.profile.frames and self.db.profile.frames.artifact then
        if not self.db.profile.update801 then
            self.db.profile.frames.artifact.mode = 'azerite';
            self.db.profile.update801 = true
        end
    end
end

function Addon:OnEnable()
	self:UpdateUseOverrideUI()
	self:Load()

	self.MultiActionBarGridFixer:SetShowGrid(self:ShowGrid())
end

--[[ Version Updating ]]--

function Addon:GetDefaults()
	return {
		profile = {
			possessBar = 1,

			sticky = true,
			linkedOpacity = false,
			showMacroText = true,
			showBindingText = true,
			showEquippedItemBorders = true,
			showTooltips = true,
			showTooltipsCombat = true,
			useOverrideUI = true,

			minimap = {
                minimapPos = 10,
				hide = false,
			},

			ab = {
				count = 10,
				showgrid = true,
			},

			frames = {}
		}
	}
end

function Addon:UpdateSettings(major, minor, bugfix)
	--inject new roll bar defaults
	if major == '5' and minor == '0' and bugfix < '14' then
		for profile, sets in pairs(self.db.sv.profiles) do
			if sets.frames then
				local rollBarFrameSets = sets.frames['roll']
				if rollBarFrameSets then
					rollBarFrameSets.showInPetBattleUI = true
					rollBarFrameSets.showInOverrideUI = true
				end
			end
		end
	end
end

function Addon:UpdateVersion()
	_G[AddonName .. 'Version'] = CURRENT_VERSION

	self:Printf(L.Updated, _G[AddonName .. 'Version'])
end

function Addon:PrintVersion()
	self:Print(_G[AddonName .. 'Version'])
end


--Load is called  when the addon is first enabled, and also whenever a profile is loaded
function Addon:Load()
	local module_load = function(module)
		if module.Load then
			module:Load()
		end
	end

	for i, module in self:IterateModules() do
		local success, msg = pcall(module_load, module)
		if not success then
			self:Printf('Failed to load %s\n%s', module:GetName(), msg)
		end
	end

	self.Frame:ForAll('Reanchor')
	self:GetModule('ButtonThemer'):Reskin()
end

--unload is called when we're switching profiles
function Addon:Unload()
	local module_unload = function(module)
		if module.Unload then
			module:Unload()
		end
	end

	--unload any module stuff
	for i, module in self:IterateModules() do
		local success, msg = pcall(module_unload, module)
		if not success then
			self:Printf('Failed to unload %s\n%s', module:GetName(), msg)
		end
	end
end

--[[
	 Configuration
--]]

function Addon:SetUseOverrideUI(enable)
	self.db.profile.useOverrideUI = enable and true or false
	self:UpdateUseOverrideUI()
end

function Addon:UsingOverrideUI()
	return self.db.profile.useOverrideUI
end

function Addon:UpdateUseOverrideUI()
	local usingOverrideUI = self:UsingOverrideUI()

	self.OverrideController:SetAttribute('state-useoverrideui', usingOverrideUI)

	local oab = _G['OverrideActionBar']
	oab:ClearAllPoints()
	if usingOverrideUI then
		oab:SetPoint('BOTTOM')
	else
		oab:SetPoint('LEFT', oab:GetParent(), 'RIGHT', 100, 0)
	end
end


--[[ Keybound Events ]]--

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


--[[ Profile Functions ]]--

function Addon:SaveProfile(name)
	local toCopy = self.db:GetCurrentProfile()
	if name and name ~= toCopy then
		self:Unload()
		self.db:SetProfile(name)
		self.db:CopyProfile(toCopy)
		self.isNewProfile = nil
		self:Load()
	end
end

function Addon:SetProfile(name)
	local profile = self:MatchProfile(name)
	if profile and profile ~= self.db:GetCurrentProfile() then
		self:Unload()
		self.db:SetProfile(profile)
		self.isNewProfile = nil
		self:Load()
	else
		self:Print(format(L.InvalidProfile, name or 'null'))
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
		self.isNewProfile = nil
		self:Load()
	end
end

function Addon:ResetProfile()
	self:Unload()
	self.db:ResetProfile()
	self.isNewProfile = true
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
	local name = name:lower()
	local nameRealm = name .. ' - ' .. GetRealmName():lower()
	local match

	for i, k in ipairs(self.db:GetProfiles()) do
		local key = k:lower()
		if key == name then
			return k
		elseif key == nameRealm then
			match = k
		end
	end
	return match
end


--[[ Profile Events ]]--

function Addon:OnNewProfile(msg, db, name)
	self.isNewProfile = true
	self:Print(format(L.ProfileCreated, name))
end

function Addon:OnProfileDeleted(msg, db, name)
	self:Print(format(L.ProfileDeleted, name))
end

function Addon:OnProfileChanged(msg, db, name)
	self:Print(format(L.ProfileLoaded, name))
end

function Addon:OnProfileCopied(msg, db, name)
	self:Print(format(L.ProfileCopied, name))
end

function Addon:OnProfileReset(msg, db)
	self:Print(format(L.ProfileReset, db:GetCurrentProfile()))
end


--[[ Settings...Setting ]]--

function Addon:SetFrameSets(id, sets)
	local id = tonumber(id) or id
	self.db.profile.frames[id] = sets

	return self.db.profile.frames[id]
end

function Addon:GetFrameSets(id)
	return self.db.profile.frames[tonumber(id) or id]
end


--[[ Options Menu Display ]]--

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


--[[ Configuration Functions ]]--

--moving
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

function Addon:ToggleBindingMode()
	self:SetLock(true)
	LibStub('LibKeyBound-1.0'):Toggle()
end

function Addon:IsBindingModeEnabled()
	return LibStub('LibKeyBound-1.0'):IsShown()
end

--scale
function Addon:ScaleFrames(...)
	local numArgs = select('#', ...)
	local scale = tonumber(select(numArgs, ...))

	if scale and scale > 0 and scale <= 10 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameScale', scale)
		end
	end
end

--opacity
function Addon:SetOpacityForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameAlpha', alpha)
		end
	end
end

--faded opacity
function Addon:SetFadeForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFadeMultiplier', alpha)
		end
	end
end

--columns
function Addon:SetColumnsForFrames(...)
	local numArgs = select('#', ...)
	local cols = tonumber(select(numArgs, ...))

	if cols then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetColumns', cols)
		end
	end
end

--spacing
function Addon:SetSpacingForFrame(...)
	local numArgs = select('#', ...)
	local spacing = tonumber(select(numArgs, ...))

	if spacing then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetSpacing', spacing)
		end
	end
end

--padding
function Addon:SetPaddingForFrames(...)
	local numArgs = select('#', ...)
	local pW, pH = select(numArgs - 1, ...)

	if tonumber(pW) and tonumber(pH) then
		for i = 1, numArgs - 2 do
			self.Frame:ForFrame(select(i, ...), 'SetPadding', tonumber(pW), tonumber(pH))
		end
	end
end

--visibility
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

--clickthrough
function Addon:SetClickThroughForFrames(...)
	local numArgs = select('#', ...)
	local enable = select(numArgs - 1, ...)

	for i = 1, numArgs - 2 do
		self.Frame:ForFrame(select(i, ...), 'SetClickThrough', tonumber(enable) == 1)
	end
end

--empty button display
function Addon:ToggleGrid()
	self:SetShowGrid(not self:ShowGrid())
end

function Addon:SetShowGrid(enable)
	self.db.profile.showgrid = enable or false
	self.ActionBar:ForAll('UpdateGrid')
	self.MultiActionBarGridFixer:SetShowGrid(enable)
end

function Addon:ShowGrid()
	return self.db.profile.showgrid
end

--right click selfcast
function Addon:SetRightClickUnit(unit)
	self.db.profile.ab.rightClickUnit = unit
	self.ActionBar:ForAll('UpdateRightClickUnit')
end

function Addon:GetRightClickUnit()
	return self.db.profile.ab.rightClickUnit
end

--binding text
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

--macro text
function Addon:SetShowMacroText(enable)
	self.db.profile.showMacroText = enable or false

	for _,f in self.Frame:GetAll() do
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

--border
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


--possess bar settings
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

--action bar numbers
function Addon:SetNumBars(count)
	count = max(min(count, 120), 1) --sometimes, I do entertaininig things

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


--tooltips
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


--minimap button
function Addon:SetShowMinimap(enable)
	self.db.profile.minimap.hide = not enable
	self:GetModule('Launcher'):Update()
end

function Addon:ShowingMinimap()
	return not self.db.profile.minimap.hide
end

--sticky bars
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

--linked opacity
function Addon:SetLinkedOpacity(enable)
	self.db.profile.linkedOpacity = enable or false

	self.Frame:ForAll('UpdateWatched')
	self.Frame:ForAll('UpdateAlpha')
end

function Addon:IsLinkedOpacityEnabled()
	return self.db.profile.linkedOpacity
end

--[[ exports ]]--

_G[AddonName] = Addon

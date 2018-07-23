local AddonObj	= CreateFrame('Frame')
local AddonName = ...

local Ellipsis	= LibStub('AceAddon-3.0'):NewAddon(AddonObj, AddonName, 'AceConsole-3.0', 'LibSink-2.0')
local L			= LibStub('AceLocale-3.0'):GetLocale(AddonName)
local LSM		= LibStub('LibSharedMedia-3.0')

_G[AddonName]	= Ellipsis

local CURRENT_VERSION		= GetAddOnMetadata(AddonName, 'Version')
local OPTIONS_ADDON			= AddonName .. '_Options'

Ellipsis.NUM_AURA_ANCHORS	= 7

Ellipsis.anchors			= {}	-- gui reference for unit anchors
Ellipsis.activeAuras		= {}	-- active auras for OnUpdate iteration and reference
Ellipsis.activeUnits		= {}	-- active units for event reference
Ellipsis.auraPool			= {}	-- storage for inactive auras
Ellipsis.unitPool			= {}	-- storage for inactive units
Ellipsis.anchorLookup		= {}	-- reference lookup for display of Units in the appropriate anchor for their group type
Ellipsis.priorityLookup		= {}	-- reference lookup for priority sorting of Units on their anchors

-- Rolling our own for Event Handling for the minimum overhead (especially for CLEU)
Ellipsis:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)


-- ------------------------
-- ADDON INITIALIZATION
-- ------------------------
function Ellipsis:OnInitialize()
	-- clear old settings from Ellipsis versions prior to 4.0.0
	if (not EllipsisVersion) then EllipsisDB = nil end

	-- setup settings database
	self.db = LibStub('AceDB-3.0'):New('EllipsisDB', self:GetDefaults(), true)
	self:SetSinkStorage(self.db.profile.notify.outputAlerts) -- Setup LibSink

	-- handle version updates (only for 4.0.0 and above)
	if (EllipsisVersion) then
		if (EllipsisVersion ~= CURRENT_VERSION) then
			self:UpdateVersion(EllipsisVersion:match('(%w+)%.(%w+)%.(%w+)'))
		end
	else -- first run of 4.0.0 or greater
		EllipsisVersion = CURRENT_VERSION
	end

	self:MediaRegistration() -- register additional LSM entries

	-- initialize objects and control
	self:InitializeAnchors()
	self:InitializeAuras()
	self:InitializeUnits()
	self:InitializeCooldowns()
	self:InitializeNotify()

	self:RegisterChatCommand('ellipsis', 'ChatHandler')
	self:RegisterChatCommand('...', 'ChatHandler')

	if (not self.db.profile.locked) then
		self:UnlockInterface() -- ensure that until locked, user can see anchor overlays for positioning
	end
end

function Ellipsis:OnEnable()
	self:InitializeControl() -- not called until now due to delayed population of some data (notably playerGUID)

	self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:RegisterEvent('UNIT_AURA')
	self:RegisterEvent('UNIT_PET')
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	self:RegisterEvent('PLAYER_FOCUS_CHANGED')
	self:RegisterEvent('PLAYER_TOTEM_UPDATE')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')

	C_Timer.After(2, function()
		-- correct a pet being shown as Unknown right after first login
		if (UnitExists('pet')) then
			local guid = UnitGUID('pet')
			local pet = self.activeUnits[guid]

			if (pet) then -- we have and are tracking a pet
				pet.unitName = UnitName('pet')
				pet:UpdateHeaderText()
			end
		end

		-- force an event update for the player on login to ensure auras are properly tracked
		self:UNIT_AURA('player')
	end)
end

function Ellipsis:UpdateVersion(major, minor, bugfix)
	local newOptions = false


	if (minor == '0' or minor == '1') then -- 0 = cooldown tracker, 1 = new options for display
		newOptions = true
	end


	EllipsisVersion = CURRENT_VERSION -- finalize update

	if (newOptions) then
		self:Printf(L.VersionUpdatedNew, EllipsisVersion)
	else
		self:Printf(L.VersionUpdated, EllipsisVersion)
	end
end

function Ellipsis:ChatHandler(input)
	if (input == '') then
		local loaded, reason = LoadAddOn(OPTIONS_ADDON)

		if (not Ellipsis.OptionsAddonLoaded) then
			self:Printf(L.CannotLoadOptions, reason and _G['ADDON_' .. reason] or '')
			return
		end

		Ellipsis:OpenOptions()
	elseif (input == 'lock') then
		self:LockInterface()
	elseif (input == 'unlock') then
		self:UnlockInterface()
	else
		self:Print(L.ChatUsage)
	end
end


-- ------------------------
-- FILTER LIST FUNCTIONS
-- ------------------------
function Ellipsis:FilterAura(spellID)
	if (type(spellID) == 'number' and spellID > 0) then -- ensure we're dealing with a (potentially) legitimate spellID
		if (self.db.profile.control.filterByBlacklist) then	-- Filtering via BLACKLIST
			if (self.db.profile.control.blacklist[spellID]) then -- aura already blocked, remove filter
				self.db.profile.control.blacklist[spellID] = nil

				local name = GetSpellInfo(spellID)

				self:Printf(L.FilterBlackRemove, name or L.Aura_Unknown, spellID)
			else -- aura not currently blocked, add to blacklist
				self.db.profile.control.blacklist[spellID] = true

				for _, aura in pairs(self.activeAuras) do
					if (aura.spellID == spellID) then
						aura:Release() -- kill any active auras with this newly blocked ID
					end
				end

				local name = GetSpellInfo(spellID)

				self:Printf(L.FilterBlackAdd, name or L.Aura_Unknown, spellID)
			end
		else												-- Filtering via WHITELIST
			if (self.db.profile.control.whitelist[spellID]) then -- aura already allowed, remove
				self.db.profile.control.whitelist[spellID] = nil

				for _, aura in pairs(self.activeAuras) do
					if (aura.spellID == spellID) then
						aura:Release() -- kill any active auras with this (now blocked) ID
					end
				end

				local name = GetSpellInfo(spellID)

				self:Printf(L.FilterWhiteRemove, name or L.Aura_Unknown, spellID)
			else -- aura not currently allowed, add to whitelist
				self.db.profile.control.whitelist[spellID] = true

				local name = GetSpellInfo(spellID)

				self:Printf(L.FilterWhiteAdd, name or L.Aura_Unknown, spellID)
			end
		end

		self:UNIT_AURA('player') -- update player auras (only unit we can reliably assume may need it after a removal)
	end
end

function Ellipsis:BlacklistCooldownAdd(group, timerID)
	if (type(timerID) == 'number' and timerID > 0) then -- just ensure its a (potentially legitimate) timerID
		self.db.profile.cooldowns.blacklist[group][timerID] = true

		for _, timer in pairs(self.Cooldown.activeTimers) do
			if (timer.timerID == timerID) then -- matching ID, matching group to?
				if ((group == 'ITEM' and timer.group == 'ITEM') or (group ~=' ITEM' and timer.group ~= 'ITEM')) then
					timer:Release() -- kill any active timers with this newly blocked ID
				end
			end
		end

		local name = (group == 'ITEM') and GetItemInfo(timerID) or GetSpellInfo(timerID)
		self:Printf(L.BlacklistCooldownAdd, name or L.BlacklistUnknown, timerID)
	end
end

function Ellipsis:BlacklistCooldownRemove(group, timerID)
	if (self.db.profile.cooldowns.blacklist[group][timerID]) then
		self.db.profile.cooldowns.blacklist[group][timerID] = nil

		local name = (group == 'ITEM') and GetItemInfo(timerID) or GetSpellInfo(timerID)
		self:Printf(L.BlacklistCooldownRemove, name or L.BlacklistUnknown, timerID)
	end
end

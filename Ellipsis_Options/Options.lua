local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LUG		= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM		= LibStub('LibSharedMedia-3.0')

Ellipsis.OptionsAddonLoaded = true

local registered	= false
local hookedClose	= false

local exampleAurasActive = false
local ClearExampleAuras


-- ------------------------
-- OPTIONS TABLE
-- ------------------------
local options = {
	name = '|cff67b1e9E|cff4779cellipsis|r |cffffffffv' .. EllipsisVersion .. '|r',
	handler = Ellipsis,
	type = 'group',
	args = {
		general = {
			name = L.GeneralHeader,
			type = 'group',
			order = 1,
			args = {
				locked = {
					name = L.GeneralLocked,
					desc = L.GeneralLockedDesc,
					type = 'toggle',
					order = 1,
					get = function(info)
						return Ellipsis.db.profile.locked
					end,
					set = function(info, val)
						if (val) then -- locked
							Ellipsis:LockInterface()
						else
							Ellipsis:UnlockInterface()
						end
					end,
				},
				exampleAuras = {
					name = L.GeneralExample,
					desc = L.GeneralExampleDesc,
					type = 'execute',
					order = 2,
					func = function()
						if (IsShiftKeyDown()) then
							ClearExampleAuras()
						else
							Ellipsis:SpawnExampleAuras()
						end
					end,
				},
				groupHelp = {
					name = L.GeneralHelpHeader,
					type = 'group',
					inline = true,
					order = 3,
					args = {
						help = {
							name = L.GeneralHelp,
							type = 'description',
							order = 1
						},
					}
				},
				groupControl1 = {
					name = L.GeneralControl1Header,
					type = 'group',
					order = 4,
					get = 'ControlGet',
					-- INSERT > CONTROL GROUP 1 (Aura Restrictions)
				},
				groupControl2 = {
					name = L.GeneralControl2Header,
					type = 'group',
					order = 5,
					get = 'ControlGet_UnitGroup',
					set = 'ControlSet_UnitGroup',
					-- INSERT > CONTROL GROUP 2 (Grouping & Tracking)
				},
				groupControl3 = {
					name = L.GeneralControl3Header,
					type = 'group',
					order = 6,
					get = 'ControlGet',
					-- INSERT > CONTROL GROUP 3 (Layout & Sorting)
				},
			}
		},
		auraConfiguration = {
			name = L.AuraHeader,
			type = 'group',
			order = 2,
			get = 'AurasGet',
			set = 'AurasSet',
			-- INSERT > AURA CONFIGURATION
		},
		unitConfiguration = {
			name = L.UnitHeader,
			type = 'group',
			order = 3,
			get = 'UnitsGet',
			set = 'UnitsSet',
			-- INSERT > UNIT CONFIGURATION
		},
		cooldownOptions = {
			name = L.CooldownHeader,
			type = 'group',
			order = 4,
			get = 'CooldownsGet',
			set = 'CooldownsSet',
			-- INSERT > COOLDOWN SETTINGS
		},
		notificationOptions = {
			name = L.NotifyHeader,
			type = 'group',
			order = 5,
			get = 'NotifyGet',
			set = 'NotifySet',
			-- INSERT > NOTIFICATIONS
		},
		spacer = { -- to keep advanced options spaced out from all others
			name = '',
			type = 'group',
			order = 6,
			disabled = true,
			args = {}
		},
		advanced = {
			name = L.AdvancedHeader,
			type = 'group',
			order = 7,
			args = {
				tickRate = {
					name = L.AdvancedTickRate,
					desc = L.AdvancedTickRateDesc,
					type = 'range',
					order = 1,
					min = 10,
					max = 250,
					step = 5,
					get = function()
						return Ellipsis.db.profile.advanced.tickRate * 1000
					end,
					set = function(info, val)
						Ellipsis.db.profile.advanced.tickRate = tonumber(val) / 1000
						Ellipsis:ConfigureAuras()
					end,
				},
			}
		},
	}
}


-- ------------------------
-- PROFILE CALLBACKS
-- ------------------------
function Ellipsis:OnProfileChanged(msg, db, name)
	C_Timer.After(0.1, function() Ellipsis:UpdateEntireConfiguration() end)

	self:Printf(L.ProfileChanged, name)
end

function Ellipsis:OnProfileCopied(msg, db, name)
	C_Timer.After(0.1, function() Ellipsis:UpdateEntireConfiguration() end)

	self:Printf(L.ProfileCopied, name)
end

function Ellipsis:OnProfileDeleted(msg, db, name)
	self:Printf(L.ProfileDeleted, name)
end

function Ellipsis:OnProfileReset(msg, db)
	C_Timer.After(0.1, function() Ellipsis:UpdateEntireConfiguration() end)

	self:Printf(L.ProfileReset, db:GetCurrentProfile())
end

function Ellipsis:UpdateEntireConfiguration()
	self:InitializeAuras()
	self:UpdateExistingAuras()

	self:InitializeUnits()
	self:UpdateExistingUnits()

	self:InitializeCooldowns()
	self.Cooldown:Configure()
	self.Cooldown:ApplyOptionsTimerRestrictions()
	self.Cooldown:UpdateExistingTimers()

	self:InitializeControl()
	self:ApplyOptionsAuraRestrictions()
	self:ApplyOptionsUnitGroups()

	self:InitializeAnchors()

	for _, anchor in pairs(self.anchors) do
		anchor:Configure()
		anchor:UpdateDisplay(true)
	end

	if (not self.db.profile.locked) then
		self:UnlockInterface() -- ensure that until locked, user can see anchor overlays for positioning
	end
end


-- ------------------------
-- EXAMPLE AURAS
-- ------------------------
ClearExampleAuras = function()
	if (not exampleAurasActive) then return end -- no example auras spawned, do nothing

	-- cleanse sample cooldowns if present
	local activeTimers = Ellipsis.Cooldown.activeTimers

	if (activeTimers['ITEM' .. -100001]) then
		activeTimers['ITEM' .. -100001]:Release()
	end

	if (activeTimers['PET' .. -100002]) then
		activeTimers['PET' .. -100002]:Release()
	end

	if (activeTimers['SPELL' .. -100003]) then
		activeTimers['SPELL' .. -100003]:Release()
	end


	local activeUnits = Ellipsis.activeUnits

	if (activeUnits['sample-harmful-1']) then
		activeUnits['sample-harmful-1']:Release()
	end

	if (activeUnits['sample-harmful-2']) then
		activeUnits['sample-harmful-2']:Release()
	end

	if (activeUnits['sample-helpful']) then
		activeUnits['sample-helpful']:Release()
	end

	local unit = activeUnits['notarget'] or false

	if (unit) then -- cleanse sample auras from notarget if present
		for x = -100001, -100003, -1 do
			if (unit.auras[x]) then
				unit.auras[x]:Release()
			end
		end
	end

	unit = activeUnits[UnitGUID('player')] or false

	if (unit) then -- cleanse sample auras from player if present
		for x = -100001, -100003, -1 do
			if (unit.auras[x]) then
				unit.auras[x]:Release()
			end
		end
	end

	exampleAurasActive = false
end

function Ellipsis:SpawnExampleAuras()
	local controlDB		= self.db.profile.control
	local activeUnits	= self.activeUnits
	local Aura, Unit	= self.Aura, self.Unit
	local time			= sampleAuraDurations

	local currentTime	= GetTime()
	local aura, unit


	if (self.db.profile.cooldowns.enabled) then -- only spawn sample cooldown timers if enabled
		local CooldownTimer	= self.CooldownTimer
		local activeTimers	= self.Cooldown.activeTimers
		local timer

		timer = activeTimers['ITEM' .. -100001] or false
		if (timer) then
			timer:Update(currentTime, 90)
		else
			CooldownTimer:New(currentTime, 'ITEM', -100001, L.SampleCoolItem, GetSpellTexture(11426), currentTime, 90)
		end

		timer = activeTimers['PET' .. -100002] or false
		if (timer) then
			timer:Update(currentTime, 12)
		else
			CooldownTimer:New(currentTime, 'PET', -100002, L.SampleCoolPet, GetSpellTexture(186257), currentTime, 12)
		end

		timer = activeTimers['SPELL' .. -100003] or false
		if (timer) then
			timer:Update(currentTime, 24)
		else
			CooldownTimer:New(currentTime, 'SPELL', -100003, L.SampleCoolSpell, GetSpellTexture(191427), currentTime, 24)
		end

		self.Cooldown:ApplyOptionsTimerRestrictions() -- apply cooldown timer restrictions to our samples
	end

	-- spawn harmful unit + auras (1)
	unit = activeUnits['sample-harmful-1'] or Unit:New(currentTime, 'harmful', false, 'sample-harmful-1', L.SampleUnitHarmful, 'WARLOCK', -1)

	aura = unit.auras[-100001] or false
	if (aura) then
		aura:Update(currentTime, 400, currentTime + 400, 0)
	else
		unit:AddAura(Aura:New(currentTime, unit, -100001, format(L.SampleAuraDebuff, 1), GetSpellTexture(115767), 400, currentTime + 400, 0))
	end

	aura = unit.auras[-100002] or false
	if (aura) then
		aura:Update(currentTime, 24, currentTime + 24, 3)
	else
		unit:AddAura(Aura:New(currentTime + 1, unit, -100002, format(L.SampleAuraDebuff, 2), GetSpellTexture(172), 24, currentTime + 24, 3))
	end

	aura = unit.auras[-100003] or false
	if (aura) then
		aura:Update(currentTime, 8, currentTime + 8, 0)
	else
		unit:AddAura(Aura:New(currentTime + 2, unit, -100003, format(L.SampleAuraDebuff, 3), GetSpellTexture(188389), 8, currentTime + 8, 0))
	end

	unit:UpdateDisplay(true)


	-- spawn harmful unit + auras (2)
	unit = activeUnits['sample-harmful-2'] or Unit:New(currentTime + 1, 'harmful', false, 'sample-harmful-2', L.SampleUnitHarmful, 'PRIEST', 110)

	aura = unit.auras[-100001] or false
	if (aura) then
		aura:Update(currentTime, 380, currentTime + 380, 0)
	else
		unit:AddAura(Aura:New(currentTime, unit, -100001, format(L.SampleAuraDebuff, 1), GetSpellTexture(589), 380, currentTime + 380, 0))
	end

	aura = unit.auras[-100002] or false
	if (aura) then
		aura:Update(currentTime, 32, currentTime + 32, 10)
	else
		unit:AddAura(Aura:New(currentTime + 1, unit, -100002, format(L.SampleAuraDebuff, 2), GetSpellTexture(30108), 32, currentTime + 32, 10))
	end

	aura = unit.auras[-100003] or false
	if (aura) then
		aura:Update(currentTime, 14, currentTime + 14, 0)
	else
		unit:AddAura(Aura:New(currentTime + 2, unit, -100003, format(L.SampleAuraDebuff, 3), GetSpellTexture(51514), 14, currentTime + 14, 0))
	end

	unit:UpdateDisplay(true)


	-- spawn helpful unit + auras
	unit = activeUnits['sample-helpful'] or Unit:New(currentTime + 2, 'helpful', false, 'sample-helpful', L.SampleUnitHelpful, 'SHAMAN', 110)

	aura = unit.auras[-100001] or false
	if (aura) then
		aura:Update(currentTime, 420, currentTime + 420, 2)
	else
		unit:AddAura(Aura:New(currentTime, unit, -100001, format(L.SampleAuraBuff, 1), GetSpellTexture(11426), 420, currentTime + 420, 2))
	end

	aura = unit.auras[-100002] or false
	if (aura) then
		aura:Update(currentTime, 20, currentTime + 20, 0)
	else
		unit:AddAura(Aura:New(currentTime + 1, unit, -100002, format(L.SampleAuraBuff, 2), GetSpellTexture(186257), 20, currentTime + 20, 0))
	end

	aura = unit.auras[-100003] or false
	if (aura) then
		aura:Update(currentTime, 10, currentTime + 10, 0)
	else
		unit:AddAura(Aura:New(currentTime + 2, unit, -100003, format(L.SampleAuraBuff, 3), GetSpellTexture(191427), 10, currentTime + 10, 0))
	end

	unit:UpdateDisplay(true)


	-- spawn notarget unit + auras
	unit = activeUnits['notarget'] or Unit:New(currentTime + 3, 'notarget', false, 'notarget', LUG.UnitName_NoTarget, false, 0)

	aura = unit.auras[-100001] or false
	if (aura) then
		aura:Update(currentTime, 120, currentTime + 120, 0)
	else
		unit:AddAura(Aura:New(currentTime, unit, -100001, L.SampleAuraMinion, GetSpellTexture(55078), 120, currentTime + 120, 0))
	end

	aura = unit.auras[-100002] or false
	if (aura) then
		aura:Update(currentTime, 40, currentTime + 40, 0)
	else
		unit:AddAura(Aura:New(currentTime + 1, unit, -100002, L.SampleAuraTotem, GetSpellTexture(605), 40, currentTime + 40, 0))
	end

	aura = unit.auras[-100003] or false
	if (aura) then
		aura:Update(currentTime, 8, currentTime + 8, 0)
	else
		unit:AddAura(Aura:New(currentTime + 2, unit, -100003, L.SampleAuraGTAoE, GetSpellTexture(8921), 8, currentTime + 8, 0))
	end

	unit:UpdateDisplay(true)


	-- spawn player unit + auras (if tracking player)
	if (self.anchorLookup['player']) then
		local guid = UnitGUID('player')

		unit = activeUnits[guid] or false

		if (not unit) then -- no player unit, make one
			local override = UnitIsUnit('player', 'target') and 'target' or UnitIsUnit('player', 'focus') and 'focus' or false

			unit = Unit:New(currentTime + 4, 'player', override, guid, UnitName('player'), select(2, UnitClass('player')), UnitLevel('player'))
		end

		aura = unit.auras[-100001] or false
		if (aura) then
			aura:Update(currentTime, 440, currentTime + 440, 0)
		else
			aura = unit:AddAura(Aura:New(currentTime, unit, -100001, format(L.SampleAuraBuff, 1), GetSpellTexture(209525), 440, currentTime + 440, 0))
		end
		aura.updated = currentTime + 500 -- need to stop UNIT_AURA killing our samples

		aura = unit.auras[-100002] or false
		if (aura) then
			aura:Update(currentTime, 28, currentTime + 28, 0)
		else
			aura = unit:AddAura(Aura:New(currentTime + 1, unit, -100002, format(L.SampleAuraBuff, 2), GetSpellTexture(31224), 28, currentTime + 28, 0))
		end
		aura.updated = currentTime + 60 -- need to stop UNIT_AURA killing our samples

		aura = unit.auras[-100003] or false
		if (aura) then
			aura:Update(currentTime, 12, currentTime + 12, 0)
		else
			aura = unit:AddAura(Aura:New(currentTime + 2, unit, -100003, format(L.SampleAuraBuff, 3), GetSpellTexture(642), 12, currentTime + 12, 0))
		end
		aura.updated = currentTime + 40 -- need to stop UNIT_AURA killing our samples

		unit:UpdateDisplay(true)
	end

	self:ApplyOptionsAuraRestrictions() -- apply aura time restrictions to our samples

	exampleAurasActive = true
end


-- ------------------------
-- OPTIONS INITIALIZATION
-- ------------------------
function Ellipsis:OpenOptions()
	if (not registered) then
		-- fill out options table
		options.args.general.args.groupControl1.args	= self:GetControl1Options()
		options.args.general.args.groupControl2.args	= self:GetControl2Options()
		options.args.general.args.groupControl3.args	= self:GetControl3Options()
		options.args.auraConfiguration.args				= self:GetAuraConfiguration()
		options.args.unitConfiguration.args				= self:GetUnitConfiguration()
		options.args.cooldownOptions.args				= self:GetCooldownOptions()
		options.args.notificationOptions.args			= self:GetNotificationOptions()

		-- setup LibSink options
		options.args.notificationOptions.args.groupAlertOutput.args.groupSink			= self:GetSinkAce3OptionsDataTable()
		options.args.notificationOptions.args.groupAlertOutput.args.groupSink.name		= L.NotifyAlertSinkHeader
		options.args.notificationOptions.args.groupAlertOutput.args.groupSink.order		= 2
		options.args.notificationOptions.args.groupAlertOutput.args.groupSink.inline	= true

		-- setup profile options
		options.args.general.args.groupProfiles			= LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
		options.args.general.args.groupProfiles.order	= 6

		-- register profile callbacks
		self.db.RegisterCallback(self, 'OnProfileChanged')
		self.db.RegisterCallback(self, 'OnProfileCopied')
		self.db.RegisterCallback(self, 'OnProfileDeleted')
		self.db.RegisterCallback(self, 'OnProfileReset')

		-- create options table
		LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable('Ellipsis', options, true)
		LibStub('AceConfigDialog-3.0'):SetDefaultSize('Ellipsis', 620, 460)

		registered = true
	end

	LibStub('AceConfigDialog-3.0'):Open('Ellipsis')
	-- force open the sub-headers for all sections with them (looks nicer)
	LibStub('AceConfigDialog-3.0').Status.Ellipsis.status.groups.groups.general				= true
	LibStub('AceConfigDialog-3.0').Status.Ellipsis.status.groups.groups.auraConfiguration	= true
	LibStub('AceConfigDialog-3.0').Status.Ellipsis.status.groups.groups.unitConfiguration	= true
	LibStub('AceConfigDialog-3.0').Status.Ellipsis.status.groups.groups.cooldownOptions		= true
	LibStub('AceConfigDialog-3.0').Status.Ellipsis.status.groups.groups.notificationOptions	= true

	if (not hookedClose) then -- somewhat hacky, but lets us make sure samples are gone when options window closes
		hooksecurefunc(LibStub('AceConfigDialog-3.0').OpenFrames['Ellipsis'], 'Hide', ClearExampleAuras)
		hookedClose = true -- make sure we only hook once
	end
end

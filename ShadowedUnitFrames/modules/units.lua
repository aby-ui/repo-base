local Units = {headerFrames = {}, unitFrames = {}, frameList = {}, unitEvents = {}, remappedUnits = {}, canCure = {}}
Units.childUnits = {["partytarget"] = "party", ["partytargettarget"] = "party", ["partypet"] = "party", ["maintanktarget"] = "maintank", ["mainassisttarget"] = "mainassist", ["bosstarget"] = "boss", ["arenatarget"] = "arena", ["arenatargettarget"] = "arena", ["arenapet"] = "arena", ["battlegroundpet"] = "battleground", ["battlegroundtarget"] = "battleground", ["battlegroundtargettarget"] = "battleground", ["maintanktargettarget"] = "maintank", ["mainassisttargettarget"] = "mainassist", ["bosstargettarget"] = "boss"}
Units.zoneUnits = {["arena"] = "arena", ["arenapet"] = "arena", ["arenatarget"] = "arena", ["arenatargettarget"] = "arena", ["boss"] = {"party", "raid"}, ["bosstarget"] = {"party", "raid"}, ["battleground"] = "pvp", ["battlegroundtarget"] = "pvp", ["battlegroundtargettarget"] = "pvp", ["battlegroundpet"] = "pvp", ["bosstargettarget"] = {"party", "raid"}}
Units.remappedUnits = {["battleground"] = "arena", ["battlegroundpet"] = "arenapet", ["battlegroundtarget"] = "arenatarget", ["battlegroundtargettarget"] = "arenatargettarget"}
Units.headerUnits = {["raid"] = true, ["party"] = true, ["maintank"] = true, ["mainassist"] = true, ["raidpet"] = true, ["partypet"] = true}

local stateMonitor = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
stateMonitor.raids = {}
local playerClass = select(2, UnitClass("player"))
local unitFrames, headerFrames, frameList, unitEvents, childUnits, headerUnits, queuedCombat, zoneUnits = Units.unitFrames, Units.headerFrames, Units.frameList, Units.unitEvents, Units.childUnits, Units.headerUnits, {}, Units.zoneUnits
local remappedUnits = Units.remappedUnits
local _G = getfenv(0)

ShadowUF.Units = Units
ShadowUF:RegisterModule(Units, "units")

-- This is the wrapper frame that everything parents to so we can just hide it when we need to deal with pet battles
local petBattleFrame = CreateFrame("Frame", "SUFWrapperFrame", UIParent, "SecureHandlerBaseTemplate")
petBattleFrame:SetFrameStrata("BACKGROUND")
petBattleFrame:SetAllPoints(UIParent)
petBattleFrame:WrapScript(petBattleFrame, "OnAttributeChanged", [[
	if( name ~= "state-petbattle" ) then return end
	if( value == "active" ) then
		self:Hide()
	else
		self:Show()
	end
]])

RegisterStateDriver(petBattleFrame, "petbattle", "[petbattle] active; none")

-- Frame shown, do a full update
local function FullUpdate(self)
	for i=1, #(self.fullUpdates), 2 do
		local handler = self.fullUpdates[i]
		handler[self.fullUpdates[i + 1]](handler, self)
	end
end

-- Re-registers events when unit changes
local function ReregisterUnitEvents(self)
	-- Not an unit event
	if( ShadowUF.fakeUnits[self.unitRealType] or not headerUnits[self.unitType] ) then return end

	for event, list in pairs(self.registeredEvents) do
		if( unitEvents[event] ) then
			local hasHandler
			for handler in pairs(list) do
				hasHandler = true
				break
			end

			if( hasHandler ) then
				self:UnregisterEvent(event)
				self:BlizzRegisterUnitEvent(event, self.unitOwner, self.vehicleUnit)
			end
		end
	end
end

-- Register an event that should always call the frame
local function RegisterNormalEvent(self, event, handler, func, unitOverride)
	-- Make sure the handler/func exists
	if( not handler[func] ) then
		error(string.format("Invalid handler/function passed for %s on event %s, the function %s does not exist.", self:GetName() or tostring(self), tostring(event), tostring(func)), 3)
		return
	end

	if( unitEvents[event] and not ShadowUF.fakeUnits[self.unitRealType] ) then
		self:BlizzRegisterUnitEvent(event, unitOverride or self.unitOwner, self.vehicleUnit)
		if unitOverride then
			self.unitEventOverrides = self.unitEventOverrides or {}
			self.unitEventOverrides[event] = unitOverride
		end
	else
		self:RegisterEvent(event)
	end

	self.registeredEvents[event] = self.registeredEvents[event] or {}

	-- Each handler can only register an event once per a frame.
	if( self.registeredEvents[event][handler] ) then
		return
	end

	self.registeredEvents[event][handler] = func
end

-- Unregister an event
local function UnregisterEvent(self, event, handler)
	if( self.registeredEvents[event] and self.registeredEvents[event][handler] ) then
		self.registeredEvents[event][handler] = nil

		local hasHandler
		for _handler in pairs(self.registeredEvents[event]) do
			hasHandler = true
			break
		end

		if( not hasHandler ) then
			self:UnregisterEvent(event)
		end
	end
end

-- Register an event thats only called if it's for the actual unit
local function RegisterUnitEvent(self, event, handler, func)
	unitEvents[event] = true
	RegisterNormalEvent(self, event, handler, func)
end

-- Register a function to be called in an OnUpdate if it's an invalid unit (targettarget/etc)
local function RegisterUpdateFunc(self, handler, func)
	if( not handler[func] ) then
		error(string.format("Invalid handler/function passed to RegisterUpdateFunc for %s, the function %s does not exist.", self:GetName() or tostring(self), func), 3)
		return
	end

	for i=1, #(self.fullUpdates), 2 do
		local data = self.fullUpdates[i]
		if( data == handler and self.fullUpdates[i + 1] == func ) then
			return
		end
	end

	table.insert(self.fullUpdates, handler)
	table.insert(self.fullUpdates, func)
end

local function UnregisterUpdateFunc(self, handler, func)
	for i=#(self.fullUpdates), 1, -1 do
		if( self.fullUpdates[i] == handler and self.fullUpdates[i + 1] == func ) then
			table.remove(self.fullUpdates, i + 1)
			table.remove(self.fullUpdates, i)
		end
	end
end

-- Used when something is disabled, removes all callbacks etc to it
local function UnregisterAll(self, handler)
	for i=#(self.fullUpdates), 1, -1 do
		if( self.fullUpdates[i] == handler ) then
			table.remove(self.fullUpdates, i + 1)
			table.remove(self.fullUpdates, i)
		end
	end

	for event, list in pairs(self.registeredEvents) do
		if( list[handler] ) then
			list[handler] = nil

			local hasRegister
			for _handler in pairs(list) do
				hasRegister = true
				break
			end

			if( not hasRegister ) then
				self:UnregisterEvent(event)
			end
		end
	end
end

-- Handles setting alphas in a way so combat fader and range checker don't override each other
local function DisableRangeAlpha(self, toggle)
	self.disableRangeAlpha = toggle

	if( not toggle and self.rangeAlpha ) then
		self:SetAlpha(self.rangeAlpha)
	end
end

local function SetRangeAlpha(self, alpha)
	if( not self.disableRangeAlpha ) then
		self:SetAlpha(alpha)
	else
		self.rangeAlpha = alpha
	end
end

local function SetBarColor(self, key, r, g, b)
	self:SetBlockColor(self[key], key, r, g, b)
end

local function SetBlockColor(self, bar, key, r, g, b)
	local bgColor = bar.background.overrideColor or bar.background.backgroundColor
	if( not ShadowUF.db.profile.units[self.unitType][key].invert ) then
		bar:SetStatusBarColor(r, g, b, ShadowUF.db.profile.bars.alpha)
		if( not bgColor ) then
			bar.background:SetVertexColor(r, g, b, ShadowUF.db.profile.bars.backgroundAlpha)
		else
			bar.background:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, ShadowUF.db.profile.bars.backgroundAlpha)
		end
	else
		bar.background:SetVertexColor(r, g, b, ShadowUF.db.profile.bars.alpha)
		if( not bgColor ) then
			bar:SetStatusBarColor(0, 0, 0, 1 - ShadowUF.db.profile.bars.backgroundAlpha)
		else
			bar:SetStatusBarColor(bgColor.r, bgColor.g, bgColor.b, 1 - ShadowUF.db.profile.bars.backgroundAlpha)
		end
	end
end

-- Event handling
local function OnEvent(self, event, unit, ...)
	if( not unitEvents[event] or self.unit == unit or (self.unitEventOverrides and self.unitEventOverrides[event] == unit)) then
		for handler, func in pairs(self.registeredEvents[event]) do
			handler[func](handler, self, event, unit, ...)
		end
	end
end

Units.OnEvent = OnEvent

-- Do a full update OnShow, and stop watching for events when it's not visible
local function OnShowForced(self)
	-- Reset the event handler
	self:SetScript("OnEvent", OnEvent)
	self:FullUpdate()
end

local function OnShow(self)
	-- Reset the event handler
	self:SetScript("OnEvent", OnEvent)
	Units:CheckUnitStatus(self)
end

local function OnHide(self)
	self:SetScript("OnEvent", nil)

	-- If it's a volatile such as target or focus, next time it's shown it has to do an update
	-- OR if the unit is still shown, but it's been hidden because our parent (Basically UIParent)
	-- we want to flag it as having changed so it can be updated
	if( self.isUnitVolatile or self:IsShown() ) then
		self.unitGUID = nil
	end
end

-- Deal with enabling modules inside a zone
local function SetVisibility(self)
	local layoutUpdate
	local instanceType = select(2, IsInInstance()) or "none"
	local playerSpec = GetSpecialization()
	if( instanceType == "scenario" ) then instanceType = "party" end

	-- Selectively disable modules
	for _, module in pairs(ShadowUF.moduleOrder) do
		if( module.OnEnable and module.OnDisable and ShadowUF.db.profile.units[self.unitType][module.moduleKey] ) then
			local key = module.moduleKey
			local enabled = ShadowUF.db.profile.units[self.unitType][key].enabled

			-- These modules have mini-modules, the entire module should be enabled if at least one is enabled, and disabled if all are disabled
			if( key == "auras" or key == "indicators" or key == "highlight" ) then
				enabled = nil
				for _, option in pairs(ShadowUF.db.profile.units[self.unitType][key]) do
					if( type(option) == "table" and option.enabled or option == true ) then
						enabled = true
						break
					end
				end
			end

			-- In an actual zone, check to see if we have an override for the zone
			if( instanceType ~= "none" ) then
				if( ShadowUF.db.profile.visibility[instanceType][self.unitType .. key] == false ) then
					enabled = nil
				elseif( ShadowUF.db.profile.visibility[instanceType][self.unitType .. key] == true ) then
					enabled = true
				end
			end

			-- Force disable modules for people who aren't the appropriate class
			if( module.moduleClass and module.moduleClass ~= playerClass ) then
				enabled = nil
			-- Force disable if they aren't the appropriate spec
			elseif( module.moduleSpec and module.moduleSpec[playerSpec] ~= true ) then
				enabled = nil
			end

			-- Restrict by level
			if( module.moduleLevel and enabled and self.unitType == "player" ) then
				if( UnitLevel("player") < module.moduleLevel ) then
					enabled = nil
				end
			end

			-- Module isn't enabled all the time, only in this zone so we need to force it to be enabled
			if( not self.visibility[key] and enabled ) then
				module:OnEnable(self)
				layoutUpdate = true
			elseif( self.visibility[key] and not enabled ) then
				module:OnDisable(self)
				layoutUpdate = true
			end

			self.visibility[key] = enabled or nil
		end
	end

	-- We had a module update, force a full layout update of this frame
	if( layoutUpdate ) then
		ShadowUF.Layout:Load(self)
	end
end

-- Vehicles do not always return their data right away, a pure OnUpdate check seems to be the most accurate unfortunately
local function checkVehicleData(self, elapsed)
	self.timeElapsed = self.timeElapsed + elapsed
	if( self.timeElapsed >= 0.50 ) then
		self.timeElapsed = 0
		self.dataAttempts = self.dataAttempts + 1

		-- Took too long to get vehicle data, or they are no longer in a vehicle
		if( self.dataAttempts >= 6 or not UnitHasVehicleUI(self.unitOwner) or not UnitHasVehiclePlayerFrameUI(self.unitOwner) ) then
			self.timeElapsed = nil
			self.dataAttempts = nil
			self:SetScript("OnUpdate", nil)

			self.inVehicle = false
			self.unit = self.unitOwner
			self:FullUpdate()

		-- Got data, stop checking and do a full frame update
		elseif( UnitIsConnected(self.unit) or UnitHealthMax(self.unit) > 0 ) then
			self.timeElapsed = nil
			self.dataAttempts = nil
			self:SetScript("OnUpdate", nil)

			self.unitGUID = UnitGUID(self.unit)
			self:FullUpdate()
		end
	end
end

-- Check if a unit entered a vehicle
function Units:CheckVehicleStatus(frame, event, unit)
	if( event and frame.unitOwner ~= unit ) then return end

	-- Not in a vehicle yet, and they entered one that has a UI or they were in a vehicle but the GUID changed (vehicle -> vehicle)
	if( ( not frame.inVehicle or frame.unitGUID ~= UnitGUID(frame.vehicleUnit) ) and UnitHasVehicleUI(frame.unitOwner) and UnitHasVehiclePlayerFrameUI(frame.unitOwner) and not ShadowUF.db.profile.units[frame.unitType].disableVehicle ) then
		frame.inVehicle = true
		frame.unit = frame.vehicleUnit

		if( not UnitIsConnected(frame.unit) or UnitHealthMax(frame.unit) == 0 ) then
			frame.timeElapsed = 0
			frame.dataAttempts = 0
			frame:SetScript("OnUpdate", checkVehicleData)
		else
			frame.unitGUID = UnitGUID(frame.unit)
			frame:FullUpdate()
		end

	-- Was in a vehicle, no longer has a UI
	elseif( frame.inVehicle and ( not UnitHasVehicleUI(frame.unitOwner) or not UnitHasVehiclePlayerFrameUI(frame.unitOwner) or ShadowUF.db.profile.units[frame.unitType].disableVehicle ) ) then
		frame.inVehicle = false
		frame.unit = frame.unitOwner
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	end
end

-- Handles checking for GUID changes for doing a full update, this fixes frames sometimes showing the wrong unit when they change
function Units:CheckUnitStatus(frame)
	local guid = frame.unit and UnitGUID(frame.unit)
	if( guid ~= frame.unitGUID ) then
		frame.unitGUID = guid

		if( guid ) then
			frame:FullUpdate()
		end
	end
end


-- The argument from UNIT_PET is the pets owner, so the player summoning a new pet gets "player", party1 summoning a new pet gets "party1" and so on
function Units:CheckPetUnitUpdated(frame, event, unit)
	if( unit == frame.unitRealOwner and UnitExists(frame.unit) ) then
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	end
end

-- When raid1, raid2, raid3 are in a group with each other and raid1 or raid2 are in a vehicle and get kicked
-- OnAttributeChanged won't do anything because the frame is already setup, however, the active unit is non-existant
-- while the primary unit is. So if we see they're in a vehicle with this case, we force the full update to get the vehicle change
function Units:CheckGroupedUnitStatus(frame)
	if( frame.inVehicle and not UnitExists(frame.unit) and UnitExists(frame.unitOwner) ) then
		frame.inVehicle = false
		frame.unit = frame.unitOwner
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	else
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	end
end

-- More fun with sorting, due to sorting magic we have to check if we want to create stuff when the frame changes of partys too
local function createChildUnits(self)
	if( not self.unitID ) then return end

	for child, parentUnit in pairs(childUnits) do
		if( parentUnit == self.unitType and ShadowUF.db.profile.units[child].enabled ) then
			Units:LoadChildUnit(self, child, self.unitID)
		end
	end
end

local OnAttributeChanged
local function updateChildUnits(...)
	if( not ShadowUF.db.profile.locked ) then return end

	for i=1, select("#", ...) do
		local child = select(i, ...)
		if( child.parent and child.unitType ) then
			OnAttributeChanged(child, "unit", SecureButton_GetModifiedUnit(child))
		end
	end
end

local function createFakeUnitUpdateTimer(frame)
	if( not frame.updateTimer ) then
		frame.updateTimer = C_Timer.NewTicker(0.5, function() if( UnitExists(frame.unit) ) then frame:FullUpdate() end end)
	end
end

-- Attribute set, something changed
-- unit = Active unitid
-- unitID = Just the number from the unitid
-- unitType = Unitid minus numbers in it, used for configuration
-- unitRealType = The actual unit type, if party is shown in raid this will be "party" while unitType is still "raid"
-- unitOwner = Always the units owner even when unit changes due to vehicles
-- vehicleUnit = Unit to use when the unitOwner is in a vehicle
OnAttributeChanged = function(self, name, unit)
	if( name ~= "unit" or not unit or unit == self.unitOwner ) then return end

	-- Nullify the previous entry if it had one
	local configUnit = self.unitUnmapped or unit
	if( self.configUnit and unitFrames[self.configUnit] == self ) then unitFrames[self.configUnit] = nil end

	-- Setup identification data
	self.unit = unit
	self.unitID = tonumber(string.match(unit, "([0-9]+)"))
	self.unitRealType = string.gsub(unit, "([0-9]+)", "")
	self.unitType = self.unitUnmapped and string.gsub(self.unitUnmapped, "([0-9]+)", "") or self.unitType or self.unitRealType
	self.unitOwner = unit
	self.vehicleUnit = self.unitOwner == "player" and "vehicle" or self.unitRealType == "party" and "partypet" .. self.unitID or self.unitRealType == "raid" and "raidpet" .. self.unitID or nil
	self.inVehicle = nil

	-- Split everything into two maps, this is the simple parentUnit -> frame map
	-- This is for things like finding a party parent for party target/pet, the main map for doing full updates is
	-- an indexed frame that is updated once and won't have unit conflicts.
	if( self.unitRealType == self.unitType ) then
		unitFrames[configUnit] = self
	end

	frameList[self] = true

	if( self.hasChildren ) then
		updateChildUnits(self:GetChildren())
	end

	-- Create child frames
	createChildUnits(self)

	-- Unit already exists but unitid changed, update the info we got on them
	-- Don't need to recheck the unitType and force a full update, because a raid frame can never become
	-- a party frame, or a player frame and so on
	if( self.unitInitialized ) then
		self:ReregisterUnitEvents()
		self:FullUpdate()
		return
	end

	self.unitInitialized = true

	-- Add to Clique
	if( not self:GetAttribute("isHeaderDriven") ) then
		ClickCastFrames = ClickCastFrames or {}
		ClickCastFrames[self] = true
	end

	-- Handles switching the internal unit variable to that of their vehicle
	if( self.unit == "player" or self.unitRealType == "party" or self.unitRealType == "raid" ) then
		self:RegisterNormalEvent("UNIT_ENTERED_VEHICLE", Units, "CheckVehicleStatus")
		self:RegisterNormalEvent("UNIT_EXITED_VEHICLE", Units, "CheckVehicleStatus")
		self:RegisterUpdateFunc(Units, "CheckVehicleStatus")
	end

	-- Phase change, do a full update on it
	self:RegisterUnitEvent("UNIT_PHASE", self, "FullUpdate")

	-- Pet changed, going from pet -> vehicle for one
	if( self.unit == "pet" or self.unitType == "partypet" ) then
		self.unitRealOwner = self.unit == "pet" and "player" or ShadowUF.partyUnits[self.unitID]
		self:SetAttribute("unitRealOwner", self.unitRealOwner)
		self:RegisterNormalEvent("UNIT_PET", Units, "CheckPetUnitUpdated")

		if( self.unit == "pet" ) then
			self:SetAttribute("disableVehicleSwap", ShadowUF.db.profile.units.player.disableVehicle)
		else
			self:SetAttribute("disableVehicleSwap", ShadowUF.db.profile.units.party.disableVehicle)
		end

		-- Logged out in a vehicle
		if( UnitHasVehicleUI(self.unitRealOwner) and UnitHasVehiclePlayerFrameUI(self.unitRealOwner) ) then
			self:SetAttribute("unitIsVehicle", true)
		end

		-- Hide any pet that became a vehicle, we detect this by the owner being untargetable but they have a pet out
		stateMonitor:WrapScript(self, "OnAttributeChanged", [[
			if( name == "state-vehicleupdated" ) then
				self:SetAttribute("unitIsVehicle", UnitHasVehicleUI(self:GetAttribute("unitRealOwner")) and value == "vehicle" and true or false)
			elseif( name == "disablevehicleswap" or name == "state-unitexists" or name == "unitisvehicle" ) then
				-- Unit does not exist, OR unit is a vehicle and vehicle swap is not disabled, hide frame
				if( not self:GetAttribute("state-unitexists") or ( self:GetAttribute("unitIsVehicle") and not self:GetAttribute("disableVehicleSwap") ) ) then
					self:Hide()
				-- Unit exists, show it
				else
					self:Show()
				end
			end
		]])
		RegisterStateDriver(self, "vehicleupdated", string.format("[target=%s, nohelp, noharm] vehicle; pet", self.unitRealOwner, self.unit))

	-- Automatically do a full update on target change
	elseif( self.unit == "target" ) then
		self.isUnitVolatile = true
		self:RegisterNormalEvent("PLAYER_TARGET_CHANGED", Units, "CheckUnitStatus")
		self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", self, "FullUpdate")

	-- Automatically do a full update on focus change
	elseif( self.unit == "focus" ) then
		self.isUnitVolatile = true
		self:RegisterNormalEvent("PLAYER_FOCUS_CHANGED", Units, "CheckUnitStatus")
		self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", self, "FullUpdate")

	elseif( self.unit == "player" ) then
		-- this should not get called in combat, but just in case make sure we are not actually in combat
		if not InCombatLockdown() then
			self:SetAttribute("toggleForVehicle", true)
		end

		-- Force a full update when the player is alive to prevent freezes when releasing in a zone that forces a ressurect (naxx/tk/etc)
		self:RegisterNormalEvent("PLAYER_ALIVE", self, "FullUpdate")

	-- Update boss
	elseif( self.unitType == "boss" ) then
		self:RegisterNormalEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", self, "FullUpdate")
		self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", self, "FullUpdate")
		self:RegisterUnitEvent("UNIT_NAME_UPDATE", Units, "CheckUnitStatus")

	-- Update arena
	elseif( self.unitType == "arena" ) then
		self:RegisterUnitEvent("UNIT_NAME_UPDATE", self, "FullUpdate")
		self:RegisterUnitEvent("UNIT_CONNECTION", self, "FullUpdate")

	-- Update battleground
	elseif( self.unitType == "battleground" ) then
		self:RegisterUnitEvent("UNIT_NAME_UPDATE", Units, "CheckUnitStatus")

	-- Check for a unit guid to do a full update
	elseif( self.unitRealType == "raid" ) then
		self:RegisterNormalEvent("GROUP_ROSTER_UPDATE", Units, "CheckGroupedUnitStatus")
		self:RegisterUnitEvent("UNIT_NAME_UPDATE", Units, "CheckUnitStatus")
		self:RegisterUnitEvent("UNIT_CONNECTION", self, "FullUpdate")

	-- Party members need to watch for changes
	elseif( self.unitRealType == "party" ) then
		self:RegisterNormalEvent("GROUP_ROSTER_UPDATE", Units, "CheckGroupedUnitStatus")
		self:RegisterNormalEvent("PARTY_MEMBER_ENABLE", Units, "CheckGroupedUnitStatus")
		self:RegisterNormalEvent("PARTY_MEMBER_DISABLE", Units, "CheckGroupedUnitStatus")
		self:RegisterUnitEvent("UNIT_NAME_UPDATE", Units, "CheckUnitStatus")
		self:RegisterUnitEvent("UNIT_OTHER_PARTY_CHANGED", self, "FullUpdate")
		self:RegisterUnitEvent("UNIT_CONNECTION", self, "FullUpdate")

	-- *target units are not real units, thus they do not receive events and must be polled for data
	elseif( ShadowUF.fakeUnits[self.unitRealType] ) then
		createFakeUnitUpdateTimer(self)

		-- Speeds up updating units when their owner changes target, if party1 changes target then party1target is force updated, if target changes target
		-- then targettarget and targettargettarget are also force updated
		if( self.unitRealType == "partytarget" ) then
			self.unitRealOwner = ShadowUF.partyUnits[self.unitID]
		elseif( self.unitRealType == "partytargettarget" ) then
			self.unitRealOwner = ShadowUF.partyUnits[self.unitID] .. "target"
		elseif( self.unitRealType == "raid" ) then
			self.unitRealOwner = ShadowUF.raidUnits[self.unitID]
		elseif( self.unitRealType == "arenatarget" ) then
			self.unitRealOwner = ShadowUF.arenaUnits[self.unitID]
		elseif( self.unitRealType == "arenatargettarget" ) then
			self.unitRealOwner = ShadowUF.arenaUnits[self.unitID] .. "target"
		elseif( self.unit == "focustarget" ) then
			self.unitRealOwner = "focus"
			self:RegisterNormalEvent("PLAYER_FOCUS_CHANGED", Units, "CheckUnitStatus")
		elseif( self.unit == "targettarget" or self.unit == "targettargettarget" ) then
			self.unitRealOwner = "target"
			self:RegisterNormalEvent("PLAYER_TARGET_CHANGED", Units, "CheckUnitStatus")
		end

		self:RegisterNormalEvent("UNIT_TARGET", Units, "CheckPetUnitUpdated")
	end

	self:SetVisibility()
	Units:CheckUnitStatus(self)
end

Units.OnAttributeChanged = OnAttributeChanged

local secureInitializeUnit = [[
	local header = self:GetParent()

	self:SetHeight(header:GetAttribute("style-height"))
	self:SetWidth(header:GetAttribute("style-width"))
	self:SetScale(header:GetAttribute("style-scale"))

	self:SetAttribute("toggleForVehicle", true)

	self:SetAttribute("*type1", "target")
	self:SetAttribute("*type2", "togglemenu")
	self:SetAttribute("type2", "togglemenu")

	self:SetAttribute("isHeaderDriven", true)

	-- initialize frame
	header:CallMethod("initialConfigFunction", self:GetName())

	-- Clique integration
	local clickHeader = header:GetFrameRef("clickcast_header")
	if( clickHeader ) then
		clickHeader:SetAttribute("clickcast_button", self)
		clickHeader:RunAttribute("clickcast_register")
	end
]]

local unitButtonTemplate = ClickCastHeader and "ClickCastUnitTemplate,SUF_SecureUnitTemplate" or "SUF_SecureUnitTemplate"

-- Header unit initialized
local function initializeUnit(header, frameName)
	local frame = _G[frameName]

	frame.ignoreAnchor = true
	frame.unitType = header.unitType

	Units:CreateUnit(frame)
end

-- Show tooltip
local function OnEnter(self)
	if( self.OnEnter ) then
		self:OnEnter()
	end
end

local function OnLeave(self)
	if( self.OnLeave ) then
		self:OnLeave()
	end
end

local function SUF_OnEnter(self)
	if( not ShadowUF.db.profile.tooltipCombat or not InCombatLockdown() ) then
		if not GameTooltip:IsForbidden() then
			UnitFrame_OnEnter(self)
		end
	end
end

local function SUF_OnLeave(self)
	if not GameTooltip:IsForbidden() then
		UnitFrame_OnLeave(self)
	end
end

-- Create the generic things that we want in every secure frame regardless if it's a button or a header
local function ClassToken(self)
	return (select(2, UnitClass(self.unit)))
end

local function ArenaClassToken(self)
	local specID = GetArenaOpponentSpec(self.unitID)
	return specID and select(6, GetSpecializationInfoByID(specID))
end

function Units:CreateUnit(...)
	local frame = select("#", ...) > 1 and CreateFrame(...) or select(1, ...)
	frame.fullUpdates = {}
	frame.registeredEvents = {}
	frame.visibility = {}
	frame.BlizzRegisterUnitEvent = frame.RegisterUnitEvent
	frame.RegisterNormalEvent = RegisterNormalEvent
	frame.RegisterUnitEvent = RegisterUnitEvent
	frame.RegisterUpdateFunc = RegisterUpdateFunc
	frame.UnregisterAll = UnregisterAll
	frame.UnregisterSingleEvent = UnregisterEvent
	frame.SetRangeAlpha = SetRangeAlpha
	frame.DisableRangeAlpha = DisableRangeAlpha
	frame.UnregisterUpdateFunc = UnregisterUpdateFunc
	frame.ReregisterUnitEvents = ReregisterUnitEvents
	frame.SetBarColor = SetBarColor
	frame.SetBlockColor = SetBlockColor
	frame.FullUpdate = FullUpdate
	frame.SetVisibility = SetVisibility
	frame.UnitClassToken = ClassToken
	frame.topFrameLevel = 5

	-- Ensures that text is the absolute highest thing there is
	frame.highFrame = CreateFrame("Frame", nil, frame)
	frame.highFrame:SetFrameLevel(frame.topFrameLevel + 2)
	frame.highFrame:SetAllPoints(frame)

	frame:HookScript("OnAttributeChanged", OnAttributeChanged)
	frame:SetScript("OnEvent", OnEvent)
	frame:HookScript("OnEnter", OnEnter)
	frame:HookScript("OnLeave", OnLeave)
	frame:SetScript("OnShow", OnShow)
	frame:SetScript("OnHide", OnHide)

	frame.OnEnter = SUF_OnEnter
	frame.OnLeave = SUF_OnLeave

	frame:RegisterForClicks("AnyUp")
	-- non-header frames don't set those, so we need to do it
	if( not InCombatLockdown() and not frame:GetAttribute("isHeaderDriven") ) then
		frame:SetAttribute("*type1", "target")
		frame:SetAttribute("*type2", "togglemenu")
	end

	return frame
end

-- Reload a header completely
function Units:ReloadHeader(type)
	if( ShadowUF.db.profile.units[type].frameSplit ) then
		if( headerFrames.raid ) then
			self:InitializeFrame("raid")
		else
			self:SetHeaderAttributes(headerFrames.raidParent, type)
			ShadowUF.Layout:AnchorFrame(UIParent, headerFrames.raidParent, ShadowUF.db.profile.positions[type])
			ShadowUF:FireModuleEvent("OnLayoutReload", type)
		end
	elseif( type == "raid" and not ShadowUF.db.profile.units[type].frameSplit and headerFrames.raidParent ) then
		self:InitializeFrame("raid")

	elseif( headerFrames[type] ) then
		self:SetHeaderAttributes(headerFrames[type], type)
		ShadowUF.Layout:AnchorFrame(UIParent, headerFrames[type], ShadowUF.db.profile.positions[type])
		ShadowUF:FireModuleEvent("OnLayoutReload", type)
	end
end

function Units:PositionHeaderChildren(frame)
    local point = frame:GetAttribute("point") or "TOP"
    local relativePoint = ShadowUF.Layout:GetRelativeAnchor(point)

	if( #(frame.children) == 0 ) then return end

    local xMod, yMod = math.abs(frame:GetAttribute("xMod")), math.abs(frame:GetAttribute("yMod"))
    local x = frame:GetAttribute("xOffset") or 0
    local y = frame:GetAttribute("yOffset") or 0

	for id, child in pairs(frame.children) do
		if( id > 1 ) then
			frame.children[id]:ClearAllPoints()
			frame.children[id]:SetPoint(point, frame.children[id - 1], relativePoint, xMod * x, yMod * y)
		else
			frame.children[id]:ClearAllPoints()
			frame.children[id]:SetPoint(point, frame, point, 0, 0)
		end
	end
end

function Units:CheckGroupVisibility()
	if( not ShadowUF.db.profile.locked ) then return end
	local raid = headerFrames.raid and not ShadowUF.db.profile.units.raid.frameSplit and headerFrames.raid or headerFrames.raidParent
	local party = headerFrames.party
	if( party ) then
		party:SetAttribute("showParty", ( not ShadowUF.db.profile.units.raid.showParty or not ShadowUF.enabledUnits.raid ) and true or false)
		party:SetAttribute("showPlayer", ShadowUF.db.profile.units.party.showPlayer)
	end

	if( raid and party ) then
		raid:SetAttribute("showParty", not party:GetAttribute("showParty"))
		raid:SetAttribute("showPlayer", party:GetAttribute("showPlayer"))
	end
end

function Units:SetHeaderAttributes(frame, type)
	local config = ShadowUF.db.profile.units[type]
	local xMod = config.attribPoint == "LEFT" and 1 or config.attribPoint == "RIGHT" and -1 or 0
	local yMod = config.attribPoint == "TOP" and -1 or config.attribPoint == "BOTTOM" and 1 or 0
	local widthMod = (config.attribPoint == "LEFT" or config.attribPoint == "RIGHT") and MEMBERS_PER_RAID_GROUP or 1
	local heightMod = (config.attribPoint == "TOP" or config.attribPoint == "BOTTOM") and MEMBERS_PER_RAID_GROUP or 1

	frame:SetAttribute("point", config.attribPoint)
	frame:SetAttribute("sortMethod", config.sortMethod)
	frame:SetAttribute("sortDir", config.sortOrder)

	frame:SetAttribute("xOffset", config.offset * xMod)
	frame:SetAttribute("yOffset", config.offset * yMod)
	frame:SetAttribute("xMod", xMod)
	frame:SetAttribute("yMod", yMod)

	-- Split up raid frame groups
	if( config.frameSplit and type == "raid" ) then
		local anchorPoint, relativePoint, xModRow, yModRow = ShadowUF.Layout:GetSplitRelativeAnchor(config.attribPoint, config.attribAnchorPoint)
		local columnPoint, xColMod, yColMod = ShadowUF.Layout:GetRelativeAnchor(config.attribPoint)

		local lastHeader = frame
		for id=1, 8 do
			local childHeader = headerFrames["raid" .. id]
			if( childHeader ) then
				childHeader:SetAttribute("showRaid", ShadowUF.db.profile.locked and true)

				childHeader:SetAttribute("minWidth", config.width * widthMod)
				childHeader:SetAttribute("minHeight", config.height * heightMod)

				if( childHeader ~= frame ) then
					childHeader:SetAttribute("point", config.attribPoint)
					childHeader:SetAttribute("sortMethod", config.sortMethod)
					childHeader:SetAttribute("sortDir", config.sortOrder)
					childHeader:SetAttribute("showPlayer", nil)
					childHeader:SetAttribute("showParty", nil)

					childHeader:SetAttribute("xOffset", frame:GetAttribute("xOffset"))
					childHeader:SetAttribute("yOffset", frame:GetAttribute("yOffset"))

					childHeader:ClearAllPoints()
					if( (id - 1) % config.groupsPerRow == 0 ) then
						local x = config.groupSpacing * xColMod
						local y = config.groupSpacing * yColMod

						-- When we're anchoring a new column to the bottom of naother one, the height will mess it up
						-- if what we anchored to isn't full, by anchoring it to the top instead will get a consistent result
						local point = columnPoint
						if( point == "BOTTOM" ) then
							point = config.attribPoint
							x = x + (config.height * 5) * xColMod
							y = y + (config.height * 5) * yColMod
						end

						childHeader:SetPoint(config.attribPoint, headerFrames["raid" .. id - config.groupsPerRow], point, x, y)
					else
						childHeader:SetPoint(anchorPoint, lastHeader, relativePoint, config.columnSpacing * xModRow, config.columnSpacing * yModRow)
					end

					lastHeader = childHeader
				end

				-- There appears to be a bug where if you reloadui with a split raid frames the positions get messed up
				-- if we force a repositioning through startingIndex it's fixed thought.
				childHeader:SetAttribute("startingIndex", 10000)
				childHeader:SetAttribute("startingIndex", 1)
			end
		end

	-- Normal raid, ma or mt
	elseif( type == "raidpet" or type == "raid" or type == "mainassist" or type == "maintank" ) then
		local filter
		if( config.filters ) then
			for id, enabled in pairs(config.filters) do
				if( enabled ) then
					if( filter ) then
						filter = filter .. "," .. id
					else
						filter = id
					end
				end
			end
		else
			filter = config.groupFilter
		end

		frame:SetAttribute("showRaid", ShadowUF.db.profile.locked and true)
		frame:SetAttribute("maxColumns", config.maxColumns)
		frame:SetAttribute("unitsPerColumn", config.unitsPerColumn)
		frame:SetAttribute("columnSpacing", config.columnSpacing)
		frame:SetAttribute("columnAnchorPoint", config.attribAnchorPoint)
		frame:SetAttribute("groupFilter", filter or "1,2,3,4,5,6,7,8")
		frame:SetAttribute("roleFilter", config.roleFilter)

		if( config.groupBy == "CLASS" ) then
			frame:SetAttribute("groupingOrder", "DEATHKNIGHT,DEMONHUNTER,DRUID,HUNTER,MAGE,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR,MONK")
			frame:SetAttribute("groupBy", "CLASS")
		elseif( config.groupBy == "ASSIGNEDROLE" ) then
			frame:SetAttribute("groupingOrder", "TANK,HEALER,DAMAGER,NONE")
			frame:SetAttribute("groupBy", "ASSIGNEDROLE")
		else
			frame:SetAttribute("groupingOrder", "1,2,3,4,5,6,7,8")
			frame:SetAttribute("groupBy", "GROUP")
		end

	-- Need to position the fake units
	elseif( type == "boss" or type == "arena" or type == "battleground" ) then
		frame:SetAttribute("attribPoint", config.attribPoint)
		frame:SetAttribute("baseOffset", config.offset)
		frame:SetAttribute("childChanged", 1)

		self:PositionHeaderChildren(frame)

	-- Update party frames to not show anyone if they should be in raids
	elseif( type == "party" ) then
		frame:SetAttribute("maxColumns", math.ceil((config.showPlayer and 5 or 4) / config.unitsPerColumn))
		frame:SetAttribute("unitsPerColumn", config.unitsPerColumn)
		frame:SetAttribute("columnSpacing", config.columnSpacing)
		frame:SetAttribute("columnAnchorPoint", config.attribAnchorPoint)

		self:CheckGroupVisibility()
		if( stateMonitor.party ) then
			stateMonitor.party:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.party.hideSemiRaid)
			stateMonitor.party:SetAttribute("hideAnyRaid", ShadowUF.db.profile.units.party.hideAnyRaid)
		end
	end

	if( type == "raid" ) then
		self:CheckGroupVisibility()

		for id, monitor in pairs(stateMonitor.raids) do
			monitor:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.raid.hideSemiRaid)
		end
	end

	if( not InCombatLockdown() and headerUnits[type] and frame.shouldReset ) then
		-- Children no longer have ClearAllPoints() called on them before they are repositioned
		-- this tries to stop it from bugging out by clearing it then forcing it to reposition everything
		local name = frame:GetName() .. "UnitButton"
		local index = 1
		local child = _G[name .. index]
		while( child ) do
			child:ClearAllPoints()

			index = index + 1
			child = _G[name .. index]
		end

		-- Hiding and reshowing the header forces an update
		if( frame:IsShown() ) then
			frame:Hide()
			frame:Show()
		end
	end

	frame.shouldReset = true
end

-- Load a single unit such as player, target, pet, etc
function Units:LoadUnit(unit)
	-- Already be loaded, just enable
	if( unitFrames[unit] ) then
		RegisterUnitWatch(unitFrames[unit], unitFrames[unit].hasStateWatch)
		return
	end

	local frame = self:CreateUnit("Button", "SUFUnit" .. unit, petBattleFrame, "SecureUnitButtonTemplate")
	frame:SetAttribute("unit", unit)
	frame.hasStateWatch = unit == "pet"

	-- Annd lets get this going
	RegisterUnitWatch(frame, frame.hasStateWatch)
end

local function setupRaidStateMonitor(id, headerFrame)
	if( stateMonitor.raids[id] ) then return end

	stateMonitor.raids[id] = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
	stateMonitor.raids[id]:SetAttribute("raidDisabled", nil)
	stateMonitor.raids[id]:SetFrameRef("raidHeader", headerFrame)
	stateMonitor.raids[id]:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.raid.hideSemiRaid)
	stateMonitor.raids[id]:WrapScript(stateMonitor.raids[id], "OnAttributeChanged", [[
		if( name ~= "state-raidmonitor" and name ~= "raiddisabled" and name ~= "hidesemiraid" ) then
			return
		end

		local header = self:GetFrameRef("raidHeader")
		if( self:GetAttribute("raidDisabled") ) then
			if( header:IsVisible() ) then header:Hide() end
			return
		end

		if( self:GetAttribute("hideSemiRaid") and self:GetAttribute("state-raidmonitor") ~= "raid6" ) then
			header:Hide()
		else
			header:Show()
		end
	]])

	RegisterStateDriver(stateMonitor.raids[id], "raidmonitor", "[target=raid6, exists] raid6; none")
end

function Units:LoadSplitGroupHeader(type)
	if( headerFrames.raid ) then headerFrames.raid:Hide() end
	headerFrames.raidParent = nil

	for id, monitor in pairs(stateMonitor.raids) do
		monitor:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.raid.hideSemiRaid)
		monitor:SetAttribute("raidDisabled", id == -1 and true or nil)
		monitor:SetAttribute("recheck", time())
	end

	local config = ShadowUF.db.profile.units[type]
	for id, enabled in pairs(ShadowUF.db.profile.units[type].filters) do
		local frame = headerFrames["raid" .. id]
		if( enabled ) then
			if( not frame ) then
				frame = CreateFrame("Frame", "SUFHeader" .. type .. id, petBattleFrame, "SecureGroupHeaderTemplate")
				frame:SetAttribute("template", unitButtonTemplate)
				frame:SetAttribute("initial-unitWatch", true)
				frame:SetAttribute("showRaid", true)
				frame:SetAttribute("groupFilter", id)
				frame:SetAttribute("initialConfigFunction", secureInitializeUnit)
				frame.initialConfigFunction = initializeUnit
				frame.isHeaderFrame = true
				frame.unitType = type
				frame.unitMappedType = type
				frame.splitParent = type
				frame.groupID = id
				--frame:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1})
				--frame:SetBackdropBorderColor(1, 0, 0, 1)
				--frame:SetBackdropColor(0, 0, 0, 0)

				frame:SetAttribute("style-height", config.height)
				frame:SetAttribute("style-width", config.width)
				frame:SetAttribute("style-scale", config.scale)

				if( ClickCastHeader ) then
					-- the OnLoad adds the functions like SetFrameRef to the header
					SecureHandler_OnLoad(frame)
					frame:SetFrameRef("clickcast_header", ClickCastHeader)
				end

				headerFrames["raid" .. id] = frame
			end

			frame:Show()

			if( not headerFrames.raidParent or headerFrames.raidParent.groupID > id ) then
				headerFrames.raidParent = frame
			end

			setupRaidStateMonitor(id, frame)

		elseif( frame ) then
			frame:Hide()
		end
	end

	if( headerFrames.raidParent ) then
		self:SetHeaderAttributes(headerFrames.raidParent, type)
		ShadowUF.Layout:AnchorFrame(UIParent, headerFrames.raidParent, ShadowUF.db.profile.positions.raid)
	end
end

-- Load a header unit, party or raid
function Units:LoadGroupHeader(type)
	-- Already created, so just reshow and we out
	if( headerFrames[type] ) then
		headerFrames[type]:Show()

		if( type == "party" and stateMonitor.party ) then
			stateMonitor.party:SetAttribute("partyDisabled", nil)
		end

		if( type == "raid" ) then
			for id, monitor in pairs(stateMonitor.raids) do
				monitor:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.raid.hideSemiRaid)
				monitor:SetAttribute("raidDisabled", id >= 0 and true or nil)
			end
		end

		if( type == "party" or type == "raid" ) then
			self:CheckGroupVisibility()
		end
		return
	end

	local headerFrame = CreateFrame("Frame", "SUFHeader" .. type, petBattleFrame, type == "raidpet" and "SecureGroupPetHeaderTemplate" or "SecureGroupHeaderTemplate")
	headerFrames[type] = headerFrame

	self:SetHeaderAttributes(headerFrame, type)

	headerFrame:SetAttribute("template", unitButtonTemplate)
	headerFrame:SetAttribute("initial-unitWatch", true)
	headerFrame:SetAttribute("initialConfigFunction", secureInitializeUnit)

	headerFrame.initialConfigFunction = initializeUnit
	headerFrame.isHeaderFrame = true
	headerFrame.unitType = type
	headerFrame.unitMappedType = type

	-- For securely managely the display
	local config = ShadowUF.db.profile.units[type]
	headerFrame:SetAttribute("style-height", config.height)
	headerFrame:SetAttribute("style-width", config.width)
	headerFrame:SetAttribute("style-scale", config.scale)

	if( type == "raidpet" ) then
		headerFrame:SetAttribute("filterOnPet", true)
	end

	if( ClickCastHeader ) then
		-- the OnLoad adds the functions like SetFrameRef to the header
		SecureHandler_OnLoad(headerFrame)
		headerFrame:SetFrameRef("clickcast_header", ClickCastHeader)
	end

	ShadowUF.Layout:AnchorFrame(UIParent, headerFrame, ShadowUF.db.profile.positions[type])

	-- We have to do party hiding based off raid as a state driver so that we can smoothly hide the party frames based off of combat and such
	-- technically this isn't the cleanest solution because party frames will still have unit watches active
	-- but this isn't as big of a deal, because SUF automatically will unregister the OnEvent for party frames while hidden
	if( type == "party" ) then
		stateMonitor.party = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
		stateMonitor.party:SetAttribute("partyDisabled", nil)
		stateMonitor.party:SetFrameRef("partyHeader", headerFrame)
		stateMonitor.party:SetAttribute("hideSemiRaid", ShadowUF.db.profile.units.party.hideSemiRaid)
		stateMonitor.party:SetAttribute("hideAnyRaid", ShadowUF.db.profile.units.party.hideAnyRaid)
		stateMonitor.party:WrapScript(stateMonitor.party, "OnAttributeChanged", [[
			if( name ~= "state-raidmonitor" and name ~= "partydisabled" and name ~= "hideanyraid" and name ~= "hidesemiraid" ) then return end
			if( self:GetAttribute("partyDisabled") ) then return end

			if( self:GetAttribute("hideAnyRaid") and ( self:GetAttribute("state-raidmonitor") == "raid1" or self:GetAttribute("state-raidmonitor") == "raid6" ) ) then
				self:GetFrameRef("partyHeader"):Hide()
			elseif( self:GetAttribute("hideSemiRaid") and self:GetAttribute("state-raidmonitor") == "raid6" ) then
				self:GetFrameRef("partyHeader"):Hide()
			else
				self:GetFrameRef("partyHeader"):Show()
			end
		]])
		RegisterStateDriver(stateMonitor.party, "raidmonitor", "[target=raid6, exists] raid6; [target=raid1, exists] raid1; none")

	elseif( type == "raid" ) then
		setupRaidStateMonitor(-1, headerFrame)
	else
		headerFrame:Show()
	end

	-- Any frames that were split out in this group need to be hidden
	if( headerFrames.raidParent ) then
		for _, f in pairs(headerFrames) do
			if( f.splitParent == type ) then
				f:Hide()
			end
		end
	end
end

-- Fake headers that are supposed to act like headers to the users, but are really not
function Units:LoadZoneHeader(type)
	if( headerFrames[type] ) then
		headerFrames[type]:Show()
		for _, child in pairs(headerFrames[type].children) do
			RegisterUnitWatch(child, child.hasStateWatch)
		end

		if( type == "arena" ) then
			self:InitializeArena()
		end
		return
	end

	local headerFrame = CreateFrame("Frame", "SUFHeader" .. type, petBattleFrame, "SecureHandlerBaseTemplate")
	headerFrame.isHeaderFrame = true
	headerFrame.unitType = type
	headerFrame.unitMappedType = remappedUnits[type] or type
	headerFrame:SetClampedToScreen(true)
	headerFrame:SetMovable(true)
	headerFrame:SetHeight(0.1)
	headerFrame:SetAttribute("totalChildren", #(ShadowUF[type .. "Units"]))
	headerFrame.children = {}

	headerFrames[type] = headerFrame

	if( type == "arena" ) then
		headerFrame:SetScript("OnAttributeChanged", function(frame, key, value)
			if( key == "childChanged" and value and frame.children[value] and frame:IsVisible() ) then
				frame.children[value]:FullUpdate()
			end
		end)
	end

	for id, unit in pairs(ShadowUF[type .. "Units"]) do
		local frame = self:CreateUnit("Button", "SUFHeader" .. type .. "UnitButton" .. id, headerFrame, "SecureUnitButtonTemplate")
		frame.ignoreAnchor = true
		frame.hasStateWatch = true
		frame.unitUnmapped = type .. id
		frame:SetAttribute("unit", unit)
		frame:SetAttribute("unitID", id)
		frame:Hide()

		-- Override with our arena specific concerns
		frame.UnitClassToken = ArenaClassToken
		frame:SetScript("OnShow", OnShowForced)

		headerFrame.children[id] = frame
		headerFrame:SetFrameRef("child" .. id, frame)

		-- Arena frames are only allowed to be shown not hidden from the unit existing, or else when a Rogue
		-- stealths the frame will hide which looks bad. Instead force it to stay open and it has to be manually hidden when the player leaves an arena.
		if( type == "arena" ) then
			stateMonitor:WrapScript(frame, "OnAttributeChanged", [[
				if( name == "state-unitexists" ) then
					local parent = self:GetParent()
					if( value and self:GetAttribute("unitDisappeared") ) then
						parent:SetAttribute("childChanged", self:GetAttribute("unitID"))
						self:SetAttribute("unitDisappeared", nil)
					elseif( not value and not self:GetAttribute("unitDisappeared") ) then
						self:SetAttribute("unitDisappeared", true)
					end

					if( value ) then
						self:Show()
					end
				end
			]])
		else
			stateMonitor:WrapScript(frame, "OnAttributeChanged", [[
				if( name == "state-unitexists" ) then
					if( value ) then
						self:Show()
					else
						self:Hide()
					end

					local parent = self:GetParent()
					parent:SetAttribute("childChanged", self:GetAttribute("unitID"))
				end
			]])
		end

		RegisterUnitWatch(frame, frame.hasStateWatch)
	end

	-- Dynamic height/width adjustment
	stateMonitor:WrapScript(headerFrame, "OnAttributeChanged", [[
		if( name ~= "childchanged" ) then return end

		local visible = 0
		for i=1, self:GetAttribute("totalChildren") do
			if( self:GetFrameRef("child" .. i):IsShown() ) then
				visible = visible + 1
			end
		end

		if( visible == 0 ) then
			self:Hide()
			return
		end

		local child = self:GetFrameRef("child1")
		local xMod = math.abs(self:GetAttribute("xMod"))
		local yMod = math.abs(self:GetAttribute("yMod"))
		local offset = self:GetAttribute("baseOffset")

		self:SetWidth(xMod * ((child:GetWidth() * (visible - 1)) + (offset * (visible - 1))) + child:GetWidth())
		self:SetHeight(yMod * ((child:GetHeight() * (visible - 1)) + (offset * (visible - 1))) + child:GetHeight())
		self:Show()
	]])


	self:SetHeaderAttributes(headerFrame, type)
	ShadowUF.Layout:AnchorFrame(UIParent, headerFrame, ShadowUF.db.profile.positions[type])

	if( type == "arena" ) then
		self:InitializeArena()
	end
end

-- Load a unit that is a child of another unit (party pet/party target)
function Units:LoadChildUnit(parent, type, id)
	if( InCombatLockdown() ) then
		if( not queuedCombat[parent:GetName() .. type] ) then
			queuedCombat[parent:GetName() .. type] = {parent = parent, type = type, id = id}
		end
		return
	else
		-- This is a bit confusing to write down, but just in case I forget:
		-- It's possible theres a bug where you have a frame skip creating it's child because it thinks one was already created, but the one that was created is actually associated to another parent. What would need to be changed is it checks if the frame has the parent set to it and it's the same unit type before returning, not that the units match.
		for frame in pairs(frameList) do
			if( frame.unitType == type and frame.parent == parent ) then
				RegisterUnitWatch(frame, frame.hasStateWatch)
				return
			end
		end
	end

	parent.hasChildren = true

	local suffix
	if( string.match(type, "pet$") ) then
		suffix = "pet"
	elseif( string.match(type, "targettarget$") ) then
		suffix = "targettarget"
	else
		suffix = "target"
	end

	-- Now we can create the actual frame
	local frame = self:CreateUnit("Button", "SUFChild" .. type .. string.match(parent:GetName(), "(%d+)"), parent, "SecureUnitButtonTemplate")
	frame.unitType = type
	frame.parent = parent
	frame.isChildUnit = true
	frame.hasStateWatch = type == "partypet"
	frame:SetFrameStrata("LOW")
	frame:SetAttribute("useparent-unit", true)
	frame:SetAttribute("unitsuffix", suffix)
	OnAttributeChanged(frame, "unit", SecureButton_GetModifiedUnit(frame))
	frameList[frame] = true

	RegisterUnitWatch(frame, frame.hasStateWatch)
	ShadowUF.Layout:AnchorFrame(parent, frame, ShadowUF.db.profile.positions[type])
end

-- Initialize units
function Units:InitializeFrame(type)
	if( type == "raid" and ShadowUF.db.profile.units[type].frameSplit ) then
		self:LoadSplitGroupHeader(type)
	elseif( type == "party" or type == "raid" or type == "maintank" or type == "mainassist" or type == "raidpet" ) then
		self:LoadGroupHeader(type)
	elseif( self.childUnits[type] ) then
		for frame in pairs(frameList) do
			if( frame.unitType == self.childUnits[type] and ShadowUF.db.profile.units[frame.unitType] and frame.unitID ) then
				self:LoadChildUnit(frame, type, frame.unitID)
			end
		end
	elseif( self.zoneUnits[type] ) then
		self:LoadZoneHeader(type)
	else
		self:LoadUnit(type)
	end
end

-- Uninitialize units
function Units:UninitializeFrame(type)
	if( type == "party" or type == "raid" ) then
		self:CheckGroupVisibility()
	end

	-- Disables showing party in raid automatically if raid frames are disabled
	if( type == "party" and stateMonitor.party ) then
		stateMonitor.party:SetAttribute("partyDisabled", true)
	end
	if( type == "raid" ) then
		for _, monitor in pairs(stateMonitor.raids) do
			monitor:SetAttribute("raidDisabled", true)
		end
	end

	-- Disable the parent and the children will follow
	if( ShadowUF.db.profile.units[type].frameSplit ) then
		for _, headerFrame in pairs(headerFrames) do
			if( headerFrame.splitParent == type ) then
				headerFrame:Hide()
			end
		end
	elseif( headerFrames[type] ) then
		headerFrames[type]:Hide()

		if( headerFrames[type].children ) then
			for _, frame in pairs(headerFrames[type].children) do
				if( self.zoneUnits[type] ) then
					UnregisterUnitWatch(frame)
					frame:SetAttribute("state-unitexists", false)
				end

				frame:Hide()
			end
		end
	else
		-- Disable all frames of this type
		for frame in pairs(frameList) do
			if( frame.unitType == type ) then
				UnregisterUnitWatch(frame)
				frame:SetAttribute("state-unitexits", false)
				frame:Hide()
			end
		end
	end
end

-- Profile changed, reload units
function Units:ProfileChanged()
	-- Reset the anchors for all frames to prevent X is dependant on Y
	for frame in pairs(frameList) do
		if( frame.unit ) then
			frame:ClearAllPoints()
		end
	end

	for frame in pairs(frameList) do
		if( frame.unit and ShadowUF.db.profile.units[frame.unitType].enabled ) then
			-- Force all enabled modules to disable
			for key, module in pairs(ShadowUF.modules) do
				if( frame[key] and frame.visibility[key] ) then
					frame.visibility[key] = nil
					module:OnDisable(frame)
				end
			end

			-- Now enable whatever we need to
			frame:SetVisibility()
			ShadowUF.Layout:Load(frame)
			frame:FullUpdate()
		end
	end

	for _, frame in pairs(headerFrames) do
		if( ShadowUF.db.profile.units[frame.unitType].enabled ) then
			self:ReloadHeader(frame.unitType)
		end
	end
end

-- Small helper function for creating bars with
function Units:CreateBar(parent)
	local bar = CreateFrame("StatusBar", nil, parent)
	bar:SetFrameLevel(parent.topFrameLevel or 5)
	bar.parent = parent

	bar.background = bar:CreateTexture(nil, "BORDER")
	bar.background:SetHeight(1)
	bar.background:SetWidth(1)
	bar.background:SetAllPoints(bar)
	bar.background:SetHorizTile(false)

	return bar
end

-- Handle showing for the arena prep frames
function Units:InitializeArena()
	if( not headerFrames.arena or InCombatLockdown() ) then return end

	local specs = GetNumArenaOpponentSpecs()
	if( not specs or specs == 0 ) then return end

	for i=1, specs do
		local frame = headerFrames.arena.children[i]
		frame:SetAttribute("state-unitexists", true)
		frame:Show()
		frame:FullUpdate()
	end
end

-- Deal with zone changes for enabling modules
local instanceType, queueZoneCheck
function Units:CheckPlayerZone(force)
	if( InCombatLockdown() ) then
		queueZoneCheck = force and 2 or 1
		return
	end

	-- CanHearthAndResurrectFromArea() returns true for world pvp areas, according to BattlefieldFrame.lua
	local instance = CanHearthAndResurrectFromArea() and "pvp" or select(2, IsInInstance()) or "none"
	if( instance == "scenario" ) then instance = "party" end

	if( instance == instanceType and not force ) then return end
	instanceType = instance

	ShadowUF:LoadUnits()
	for frame in pairs(frameList) do
		if( frame.unit and ShadowUF.db.profile.units[frame.unitType].enabled ) then
			frame:SetVisibility()

			-- Auras are enabled so will need to check if the filter has to change
			if( frame.visibility.auras ) then
				ShadowUF.modules.auras:UpdateFilter(frame)
			end

			if( UnitExists(frame.unit) ) then
				frame:FullUpdate()
			end
		end
	end
end

-- Handle figuring out what auras players can cure
local curableSpells = {
	["DRUID"] = {[88423] = {"Magic", "Curse", "Poison"}, [2782] = {"Curse", "Poison"}},
	["PRIEST"] = {[527] = {"Magic", "Disease"}, [32375] = {"Magic"}, [213634] = {"Disease"}},
	["PALADIN"] = {[4987] = {"Poison", "Disease", "Magic"}, [213644] = {"Poison", "Disease"}},
	["SHAMAN"] = {[77130] = {"Curse", "Magic"}, [51886] = {"Curse"}},
	["MONK"] = {[115450] = {"Poison", "Disease", "Magic"}, [218164] = {"Poison", "Disease"}},
	["MAGE"] = {[475] = {"Curse"}},
}

curableSpells = curableSpells[select(2, UnitClass("player"))]

local function checkCurableSpells()
	if( not curableSpells ) then return end

	table.wipe(Units.canCure)

	for spellID, cures in pairs(curableSpells) do
		if( IsPlayerSpell(spellID) ) then
			for _, auraType in pairs(cures) do
				Units.canCure[auraType] = true
			end
		end
	end
end

local centralFrame = CreateFrame("Frame")
centralFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
centralFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
centralFrame:RegisterEvent("PLAYER_LOGIN")
centralFrame:RegisterEvent("PLAYER_LEVEL_UP")
centralFrame:RegisterEvent("CINEMATIC_STOP")
centralFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
centralFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
centralFrame:SetScript("OnEvent", function(self, event, unit)
	-- Check if the player changed zone types and we need to change module status, while they are dead
	-- we won't change their zone type as releasing from an instance will change the zone type without them
	-- really having left the zone
	if( event == "ZONE_CHANGED_NEW_AREA" ) then
		if( UnitIsDeadOrGhost("player") ) then
			self:RegisterEvent("PLAYER_UNGHOST")
		else
			self:UnregisterEvent("PLAYER_UNGHOST")
			Units:CheckPlayerZone()
		end

	-- Force update frames
	elseif( event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" ) then
		Units:InitializeArena()

	-- They're alive again so they "officially" changed zone types now
	elseif( event == "PLAYER_UNGHOST" ) then
		Units:CheckPlayerZone()

	-- Monitor level up
	elseif( event == "PLAYER_LEVEL_UP" or event == "CINEMATIC_STOP" ) then
		if( unitFrames.player ) then
			unitFrames.player:SetVisibility()
			unitFrames.player:FullUpdate()
		end

	-- Monitor talent changes for curable changes
	elseif( event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		checkCurableSpells()

		for frame in pairs(ShadowUF.Units.frameList) do
			if( frame.unit ) then
				frame:SetVisibility()

				if( frame:IsVisible() ) then
					frame:FullUpdate()
				end
		    end
	    end

	elseif( event == "PLAYER_LOGIN" ) then
		checkCurableSpells()
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	-- This is slightly hackish, but it suits the purpose just fine for somthing thats rarely called.
	elseif( event == "PLAYER_REGEN_ENABLED" ) then
		-- Now do all of the creation for child wrapping
		for _, queue in pairs(queuedCombat) do
			Units:LoadChildUnit(queue.parent, queue.type, queue.id)
		end

		table.wipe(queuedCombat)

		if( queueZoneCheck ) then
			Units:CheckPlayerZone(queueZoneCheck == 2 and true)
			queueZoneCheck = nil
		end
	end
end)

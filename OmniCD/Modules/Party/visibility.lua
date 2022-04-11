local E, L, C = select(2, ...):unpack()

local GetNumGroupMembers = GetNumGroupMembers
local GetUnitName = GetUnitName
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local C_Timer_NewTicker = C_Timer.NewTicker
local C_PvP_IsWarModeDesired = C_PvP and C_PvP.IsWarModeDesired
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local P = E["Party"]
local UPDATE_ROSTER_DELAY = 2
local MSG_INFO_REQUEST_DELAY = 3

P.groupInfo = {}
P.pendingQueue = {}
P.loginsessionData = {}

P.userData = {
	guid = E.userGUID,
	class = E.userClass,
	raceID = E.userRaceID,
	name = E.userName,
	level = E.userLevel,
	active = {},
	auras = {},
	spellIcons = {},
	preActiveIcons = {},
	glowIcons = {},
	talentData = {},
	invSlotData = {},
	shadowlandsData = {},
	version = E.versionNum,
}

if E.isPreBCC then
	P.zoneEvents = {
		arena = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" },
		pvp   = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" },
	}
else
	P.zoneEvents = {
		none  = { "PLAYER_FLAGS_CHANGED" },
		arena = { "PLAYER_REGEN_DISABLED", "UPDATE_UI_WIDGET" },
		pvp   = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" },
		party = { "CHALLENGE_MODE_START" },
		raid  = { "ENCOUNTER_END" },
	}
end

do
	local anchorTimer
	local rosterTimer
	local syncTimer

	local function AnchorFix()
		P.UpdatePosition()
		anchorTimer = nil
	end

	local function SendRequestSync()
		local success = E.Comms:InspectPlayer()
		if success then
			E.Comms:RequestSync()
			P.groupJoined = false
			syncTimer = nil
		else
			C_Timer.After(2, SendRequestSync)
		end
	end

	local function updateRosterInfo(force)
		if not force then
			rosterTimer = nil
		end

		local size = P:GetEffectiveNumGroupMembers()
		local oldDisabled = P.disabled
		P.disabled = not P.test and (P.disabledzone or size == 0 or
			(size == 1 and P.isUserHidden) or
			(GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 and not E.profile.Party.visibility.finder) or
			(size > E.profile.Party.visibility.size))
		if P.disabled then
			if oldDisabled == false then
				P:ResetModule()
			end
			P.groupJoined = false

			return
		elseif oldDisabled ~= false then
			E.Comms:Enable()
			E.Cooldowns:Enable()
			force = true
		end

		E.Libs.CBH:Fire("OnStartup")

		for guid, info in pairs(P.groupInfo) do
			if not UnitExists(info.name) or (guid == E.userGUID and P.isUserDisabled) then
				P.groupInfo[guid] = nil
				info.bar:Hide()

				local cap = info.auras.capTotemGUID
				if cap then
					E.Cooldowns.totemGUIDS[cap] = nil
				end
				local petGUID = info.petGUID
				if petGUID then
					E.Cooldowns.petGUIDS[petGUID] = nil
				end

				E.Comms.syncGUIDS[guid] = nil
				E.Comms:DequeueInspect(guid)
			end
		end

		local isInRaid = IsInRaid()

		for i = 1, size do
			local index = not isInRaid and i == size and 5 or i
			local unit = isInRaid and E.RAID_UNIT[index] or E.PARTY_UNIT[index]
			local guid = UnitGUID(unit)
			local info = P.groupInfo[guid]
			local _, class = UnitClass(unit)
			local isDead = UnitIsDeadOrGhost(unit)
			local isDeadOrOffline = isDead or not UnitIsConnected(unit)
			local isUser = guid == E.userGUID



			local pet = (class == "HUNTER" or class == "WARLOCK")and E.unitToPetId[unit]
			if pet then
				local petGUID = UnitGUID(pet)
				if petGUID then
					pet = petGUID
					E.Cooldowns.petGUIDS[petGUID] = guid
				end
			end




			if info then
				if info.unit ~= unit then
					info.index = index
					info.unit = unit

					local bar = info.bar
					bar.key = index
					bar.unit = unit
					bar.anchor.text:SetText(index)


					bar:UnregisterAllEvents()
					if not E.isPreBCC and not isUser then
						bar:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", unit)
					end
					if info.glowIcons[125174] or info.preActiveIcons[5384] then
						bar:RegisterUnitEvent("UNIT_AURA", unit)
					end
					if isDead then
						bar:RegisterUnitEvent("UNIT_HEALTH", unit)
					end
					bar:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit, E.unitToPetId[unit])
				end

				if force or (not info.isDead and info.isDeadOrOffline and not isDeadOrOffline) then
					P.pendingQueue[#P.pendingQueue + 1] = guid
					P:UpdateUnitBar(guid, true)
				end
			elseif isUser then
				if not P.isUserDisabled then
					P.groupInfo[guid] = P.userData
					P.groupInfo[guid].index = index
					P.groupInfo[guid].unit = unit
					P.groupInfo[guid].petGUID = pet
					P.groupInfo[guid].isDead = isDead
					P.groupInfo[guid].isDeadOrOffline = isDeadOrOffline
					info = P.groupInfo[guid]

					P:UpdateUnitBar(guid, true)
				end
			elseif class then
				local _,_, race = UnitRace(unit)

				local name = GetUnitName(unit, true)
				local level = UnitLevel(unit)
				level = level > 0 and level or 200
				info = {
					guid = guid,
					class = class,
					raceID = race,
					name = name,
					level = level,
					index = index,
					unit = unit,
					petGUID = pet,
					active = {},
					auras = {},
					spellIcons = {},
					preActiveIcons = {},
					glowIcons = {},
					talentData = {},
					invSlotData = {},
					shadowlandsData = {},
					isDead = isDead,
					isDeadOrOffline = isDeadOrOffline,
				}
				P.groupInfo[guid] = info

				P.pendingQueue[#P.pendingQueue + 1] = guid
				P:UpdateUnitBar(guid, true)
			else
				E.TimerAfter(UPDATE_ROSTER_DELAY, updateRosterInfo, true)
			end

			if info then
				if isDeadOrOffline then
					P:SetDisabledColorScheme(info)
				else
					P:SetEnabledColorScheme(info)
				end
			end
		end

		P:UpdatePosition()
		P:UpdateExPosition()
		E.Comms:EnqueueInspect()









		if P.groupJoined or force then

			if anchorTimer then
				anchorTimer:Cancel()
			end
			anchorTimer = C_Timer_NewTicker(5, AnchorFix, 2)

			if syncTimer then
				syncTimer:Cancel()
			end


			syncTimer = C_Timer_NewTicker(size == 1 and 0 or MSG_INFO_REQUEST_DELAY, SendRequestSync, 1)
		end

		E.Comms:ToggleLazySync()
	end

	function P:GROUP_ROSTER_UPDATE(isPEW, isRefresh)
		if ( isRefresh or GetNumGroupMembers() == 0 ) then
			updateRosterInfo(true)
		elseif ( isPEW ) then
			 E.TimerAfter(E.customUF.delay or 0.5, updateRosterInfo, true)
		elseif ( not rosterTimer) then
			rosterTimer = E.TimerAfter(E.customUF.delay or 0.5, updateRosterInfo)
		end
	end
end

function P:GROUP_JOINED(arg)
	if self.test then
		self:Test()
	end
	self.groupJoined = true
end

local inspectAll = function()
	E.Comms:EnqueueInspect(true)
end

local arenaTimer;

function P:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi, isRefresh)
	local _, instanceType = IsInInstance()
	self.zone = instanceType
	self.isInArena = instanceType == "arena"
	self.isInBG = instanceType == "pvp"
	self.isInPvPInstance = self.isInArena or self.isInBG
	self.isInDungeon = instanceType == "party"

	if not isRefresh and self.test then
		self:Test()
	end

	self.disabledzone = not self.test and not E.profile.Party.visibility[instanceType]
	if self.disabledzone then
		self:ResetModule()
		return
	end

	wipe(E.Cooldowns.diedDestGUIDS)
	wipe(E.Cooldowns.dispelledDestGUIDS)


	local key = self.test and self.testZone or instanceType
	key = key == "none" and E.profile.Party.noneZoneSetting or (key == "scenario" and E.profile.Party.scenarioZoneSetting) or key
	E.db = E.profile.Party[key]
	P.profile = E.profile.Party
	P.db = E.db
	self.isUserHidden = not self.test and not E.db.general.showPlayer

	self.isUserDisabled = self.isUserHidden and (not E.db.extraBars.interruptBar.enabled and not E.db.extraBars.raidCDBar.enabled)

	E.Cooldowns:UpdateCombatLogVar()
	E:SetActiveUnitFrameData()
	self:UpdateEnabledSpells()
	self:UpdatePositionValues()
	self:UpdateExPositionValues()
	self:UpdateRaidPriority()

	E.UnregisterEvents(self)











	E.RegisterEvents(self, self.zoneEvents[instanceType])

	self.isPvP = E.isPreBCC or (self.isInPvPInstance or (instanceType == "none" and C_PvP_IsWarModeDesired()))


	if self.isInPvPInstance then
		self:ResetAllIcons("joinedPvP")
	end

	if ( not E.isPreBCC ) then
		if ( self.isInArena ) then
			if ( not arenaTimer ) then
				arenaTimer = C_Timer_NewTicker(5, inspectAll, 11);
			end
		elseif ( arenaTimer ) then
			arenaTimer:Cancel();
			arenaTimer = nil;
		end
	end

	self:GROUP_ROSTER_UPDATE(true, isRefresh)
end

function P:CHAT_MSG_BG_SYSTEM_NEUTRAL(arg1)
	if self.disabled then return end
	if string.find(arg1, "!") then
		E.Comms:EnqueueInspect(true)
	end
end

function P:UPDATE_UI_WIDGET(widgetInfo)
	if self.disabled then return end
	if widgetInfo.widgetSetID == 1 and widgetInfo.widgetType == 0 then
		local info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(widgetInfo.widgetID)
		if info and info.state == 1 then
			E.UnregisterEvents(self, "UPDATE_UI_WIDGET")
			C_Timer.After(1, inspectAll)
		end
	end
end

function P:PLAYER_REGEN_DISABLED()
	if ( arenaTimer ) then
		arenaTimer:Cancel();
		arenaTimer = nil;
	end
	E.UnregisterEvents(self, self.zoneEvents[self.zone])
end

function P:PLAYER_FLAGS_CHANGED()
	if ( InCombatLockdown() ) then return end

	local oldpvp = self.isPvP
	self.isPvP = C_PvP_IsWarModeDesired()
	if oldpvp ~= self.isPvP then
		self:UpdateBars()
		self:UpdateExPosition()
		E.Comms:EnqueueInspect(true)
	end
end

function P:CHALLENGE_MODE_START()
	E.Comms:EnqueueInspect(true)
	self:ResetAllIcons()
	E.UnregisterEvents(self, "CHALLENGE_MODE_START")
end

function P:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
	if groupSize > 5 then
		self:ResetAllIcons("encounterEnd")
	end
end

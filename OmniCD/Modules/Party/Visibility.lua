local E = select(2, ...):unpack()
local P, CM, CD = E.Party, E.Comm, E.Cooldowns

local pairs, type = pairs, type
local UnitExists, UnitGUID, UnitClass, UnitIsDeadOrGhost, UnitIsConnected, GetRaidRosterInfo, UnitRace, GetUnitName, UnitLevel = UnitExists, UnitGUID, UnitClass, UnitIsDeadOrGhost, UnitIsConnected, GetRaidRosterInfo, UnitRace, GetUnitName, UnitLevel
local C_PvP_IsRatedSoloShuffle = E.isDF and C_PvP and C_PvP.IsRatedSoloShuffle or E.Noop
local UPDATE_ROSTER_DELAY = 2
local MSG_INFO_REQUEST_DELAY = UPDATE_ROSTER_DELAY + 1

P.groupInfo = {}
P.pendingQueue = {}
P.loginsessionData = {}
P.callbackTimers = {}

P.userInfo = {}
P.userInfo.guid = E.userGUID
P.userInfo.class = E.userClass
P.userInfo.raceID = E.userRaceID
P.userInfo.name = E.userName
P.userInfo.level = E.userLevel
P.userInfo.preactiveIcons = {}
P.userInfo.spellIcons = {}
P.userInfo.glowIcons = {}
P.userInfo.active = {}
P.userInfo.auras = {}
P.userInfo.itemData = {}
P.userInfo.talentData = {}
P.userInfo.shadowlandsData = {}
P.userInfo.callbackTimers = {}
P.userInfo.spellModRates = {}

local RAID_UNIT = {
	"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
	"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
	"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
	"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40",
}

local PARTY_UNIT = {
	"party1", "party2", "party3", "party4", "player"
}

local INSTANCETYPE_EVENTS = E.preCata and {
	arena = {
		'PLAYER_REGEN_DISABLED',
		'UPDATE_UI_WIDGET',
	},
	pvp = {
		'CHAT_MSG_BG_SYSTEM_NEUTRAL',
		'PLAYER_REGEN_DISABLED',
		'UPDATE_UI_WIDGET',
	}
} or {
	party = {
		'CHALLENGE_MODE_START',
	},
	raid  = {
		'ENCOUNTER_END',
	},
	none = {
		'PLAYER_FLAGS_CHANGED',
	},
	arena = {
		'PLAYER_REGEN_DISABLED',
		'UPDATE_UI_WIDGET',
	},
	pvp = {
		'CHAT_MSG_BG_SYSTEM_NEUTRAL',
		'UPDATE_UI_WIDGET',
		'PLAYER_REGEN_DISABLED',
	}
}

function P:UnregisterZoneEvents()
	local registeredZoneEvents = self.currentZoneEvents
	if registeredZoneEvents then
		for _, event in ipairs(registeredZoneEvents) do
			self:UnregisterEvent(event)
		end
	end
	self.currentZoneEvents = nil
end

function P:RegisterZoneEvents(currentZoneEvents)
	self:UnregisterZoneEvents()
	currentZoneEvents = currentZoneEvents or INSTANCETYPE_EVENTS[self.zone]
	if currentZoneEvents then
		for _, event in ipairs(currentZoneEvents) do
			self:RegisterEvent(event)
		end
	end
	self.currentZoneEvents = currentZoneEvents
end

local function IsInShadowlands()
	local mapID = C_Map and C_Map.GetBestMapForUnit("player")
	if mapID then
		local mapInfo = C_Map.GetMapInfo(mapID)
		while mapInfo.mapType > 2 do
			mapID = mapInfo.parentMapID
			mapInfo =  C_Map.GetMapInfo(mapID)
		end
		return mapID == 1550
	end
end

local function AnchorFix()
	P:UpdatePosition()
	P.callbackTimers.anchorDelay = nil
end

local function SendRequestSync()
	local success = CM:InspectUser()
	if success then
		CM:RequestSync()
		P.joinedNewGroup = false
		P.callbackTimers.syncTimer = nil
	else
		C_Timer.After(2, SendRequestSync)
	end
end

local function UpdateRosterInfo(force)
	if not force then
		P.callbackTimers.rosterDelay = nil
	end

	local size = P:GetEffectiveNumGroupMembers()
	local oldDisabled = P.disabled
	P.disabled = not P.isInTestMode and (P.disabledZone or size == 0
		or (size == 1 and P.isUserDisabled)
		or (GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 and not E.profile.Party.visibility.finder)
		or (size > E.profile.Party.visibility.size))

	if P.disabled then
		if oldDisabled == false then
			P:ResetModule()
		end
		P.joinedNewGroup = false
		return
	end

	if oldDisabled ~= false then
		CM:Enable()
		CD:Enable()
		force = true
	end

	if force then
		P.isInShadowlands = E.isSL or (E.postBFA and not P.isInPvPInstance and IsInShadowlands())
	end

	E.Libs.CBH:Fire("OnStartup")


	for guid, info in pairs(P.groupInfo) do
		if not UnitExists(info.name) or (guid == E.userGUID and P.isUserDisabled) then
			for _, timer in pairs(info.callbackTimers) do
				if type(timer) == "table" then
					timer:Cancel()
				end
			end

			P.groupInfo[guid] = nil
			info.bar:Hide()

			local capGUID = info.auras.capTotemGUID
			if capGUID then
				CD.totemGUIDS[capGUID] = nil
			end
			local petGUID = info.petGUID
			if petGUID then
				CD.petGUIDS[petGUID] = nil
			end

			CM.syncedGroupMembers[guid] = nil
			CM:DequeueInspect(guid)
		end
	end

	local isInRaid = IsInRaid()
	for i = 1, size do
		local index = not isInRaid and i == size and 5 or i
		local unit = isInRaid and RAID_UNIT[index] or PARTY_UNIT[index]
		local guid = UnitGUID(unit)
		local info = P.groupInfo[guid]
		local _, class = UnitClass(unit)
		local isDead = UnitIsDeadOrGhost(unit)
		local isOffline = not UnitIsConnected(unit)
		local isDeadOrOffline = isDead or isOffline
		local isUser = guid == E.userGUID

		local isAdminObsForMDI
		if P.isInDungeon then
			local _,_, subgroup = GetRaidRosterInfo(i)
			isAdminObsForMDI = subgroup and subgroup > 1
		end

		local isWarlock = class == "WARLOCK"
		local pet = (class == "HUNTER" or isWarlock) and E.UNIT_TO_PET[unit]
		if pet then
			local petGUID = UnitGUID(pet)
			if petGUID then
				pet = petGUID
				CD.petGUIDS[petGUID] = guid
			end
		end

		if info then
			local frame = info.bar
			local unitIdChanged = info.unit ~= unit
			if unitIdChanged then
				info.index, info.unit = index, unit
				frame.key, frame.unit = index, unit
				frame.anchor.text:SetText(index)
			end




			if force or (not info.isDead and info.isDeadOrOffline and not isDeadOrOffline) or (info.isAdminObsForMDI ~= isAdminObsForMDI) then
				info.isAdminObsForMDI = isAdminObsForMDI
				if not isUser then
					P.pendingQueue[#P.pendingQueue + 1] = guid
				end
				P:UpdateUnitBar(guid, true)
			elseif unitIdChanged and not isAdminObsForMDI then
				frame:UnregisterAllEvents()
				if not E.preCata and not isUser then
					frame:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', unit)
				end
				if E.isBFA then
					if P.isInArena then
						frame:RegisterUnitEvent('UNIT_AURA', unit)
					end
				else
					if info.glowIcons[125174] or info.preactiveIcons[5384] then
						frame:RegisterUnitEvent('UNIT_AURA', unit)
					end
				end
				if isDead then
					frame:RegisterUnitEvent('UNIT_HEALTH', unit)
				end
				if not E.isClassic then
					frame:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', unit, E.UNIT_TO_PET[unit])
				end
				frame:RegisterUnitEvent('UNIT_CONNECTION', unit)
			end
		elseif isUser then
			if not P.isUserDisabled then
				P.groupInfo[guid] = P.userInfo
				P.groupInfo[guid].index = index
				P.groupInfo[guid].unit = unit
				P.groupInfo[guid].petGUID = pet
				P.groupInfo[guid].isDead = isDead
				P.groupInfo[guid].isDeadOrOffline = isDeadOrOffline
				P.groupInfo[guid].isAdminObsForMDI = isAdminObsForMDI
				info = P.groupInfo[guid]

				P:UpdateUnitBar(guid, true)
			end
		elseif class then
			local _,_, race = UnitRace(unit)
			local name = GetUnitName(unit, true) or ""
			local level = UnitLevel(unit)
			level = level > 0 and level or 200
			info = {
				guid = guid, class = class, raceID = race, name = name, level = level,
				index = index, unit = unit, petGUID = pet,
				isDead = isDead, isDeadOrOffline = isDeadOrOffline, isAdminObsForMDI = isAdminObsForMDI,
				preactiveIcons = {},
				spellIcons = {},
				glowIcons = {},
				active = {},
				auras = {},
				itemData = {},
				talentData = {},
				shadowlandsData = {},
				callbackTimers = {},
				spellModRates = {},
			}
			P.groupInfo[guid] = info

			P.pendingQueue[#P.pendingQueue + 1] = guid
			P:UpdateUnitBar(guid, true)
		elseif not isOffline then
			E.TimerAfter(UPDATE_ROSTER_DELAY, UpdateRosterInfo, true)
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
	P:UpdateExBars()
	CM:EnqueueInspect()

	if P.joinedNewGroup or force then
		if P.callbackTimers.syncTimer then
			P.callbackTimers.syncTimer:Cancel()
		end
		P.callbackTimers.syncTimer = C_Timer.NewTicker(size == 1 and 0 or MSG_INFO_REQUEST_DELAY, SendRequestSync, 1)
	end

	if P.callbackTimers.anchorDelay then
		P.callbackTimers.anchorDelay:Cancel()
	end
	P.callbackTimers.anchorDelay = C_Timer.NewTicker(6, AnchorFix, (E.customUF.active == "VuhDo" or E.customUF.active == "HealBot") and 2 or 1)

	CM:ToggleCooldownSync()
end



function P:GROUP_ROSTER_UPDATE(isPEW, isRefresh)
	if isRefresh or GetNumGroupMembers() == 0 then
		UpdateRosterInfo(true)
	elseif isPEW then
		E.TimerAfter(E.customUF.delay or 0.5, UpdateRosterInfo, true)
	else
		if self.callbackTimers.rosterDelay then
			self.callbackTimers.rosterDelay:Cancel()
		end
		self.callbackTimers.rosterDelay = E.TimerAfter(E.customUF.delay or 0.5, UpdateRosterInfo)
	end
end

local inspectAllGroupMembers = function()
	CM:EnqueueInspect(true)
end




function P:GROUP_JOINED(arg1,arg2)
	if self.isInTestMode then
		self:Test()
	end
	self.joinedNewGroup = true

	if self.isInArena and C_PvP_IsRatedSoloShuffle() then
		self:ResetAllIcons("joinedPvP")
		if not self.callbackTimers.arenaTicker then
			self:RegisterEvent('PLAYER_REGEN_DISABLED')
			self.callbackTimers.arenaTicker = C_Timer.NewTicker(6, inspectAllGroupMembers, 5)
		end
	end
end

local function IsAnyExBarEnabled()
	for key in pairs(P.extraBars) do
		local db = E.db.extraBars[key]
		if db.enabled then return true end
	end
end


function P:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi, isRefresh)
	local _, instanceType = IsInInstance()
	self.zone = instanceType
	self.isInDungeon = instanceType == "party"
	self.isInArena = instanceType == "arena"
	self.isInBG = instanceType == "pvp"
	self.isInPvPInstance = self.isInArena or self.isInBG

	if not isRefresh and self.isInTestMode then
		self:Test()
	end

	self.disabledZone = not self.isInTestMode and not E.profile.Party.visibility[instanceType]
	if self.disabledZone then
		self:ResetModule()
		return
	end

	local key = self.isInTestMode and self.testZone or instanceType
	key = key == "none" and E.profile.Party.noneZoneSetting or (key == "scenario" and E.profile.Party.scenarioZoneSetting) or key
	E.db = E.profile.Party[key]
	self.db = E.db

	for key, frame in pairs(self.extraBars) do
		frame.db = E.db.extraBars[key]
	end

	self.isUserHidden = not self.isInTestMode and not E.db.general.showPlayer

	self.isUserDisabled = self.isUserHidden and (not E.db.general.showPlayerEx or not IsAnyExBarEnabled())
	self.isPvP = E.preCata or (self.isInPvPInstance or (instanceType == "none" and C_PvP.IsWarModeDesired()))
	self.effectivePixelMult = nil

	CD:UpdateCombatLogVar()
	wipe(CD.diedHostileGUIDS)
	wipe(CD.dispelledHostileGUIDS)

	E:SetActiveUnitFrameData()
	self:UpdateEnabledSpells()
	self:UpdatePositionValues()
	self:UpdateExBarPositionValues()

	self:RegisterZoneEvents()

	if self.isInPvPInstance then
		self:ResetAllIcons("joinedPvP")
	end
	if self.isInArena then
		if not self.callbackTimers.arenaTicker then
			self.callbackTimers.arenaTicker = C_Timer.NewTicker(12, inspectAllGroupMembers, 6)
		end
	else
		if self.callbackTimers.arenaTicker then
			self.callbackTimers.arenaTicker:Cancel()
			self.callbackTimers.arenaTicker = nil
		end
	end

	self:GROUP_ROSTER_UPDATE(true, isRefresh)
end

function P:CHAT_MSG_BG_SYSTEM_NEUTRAL(arg1)
	if self.disabled then return end
	if strfind(arg1, "!") then
		CM:EnqueueInspect(true)
	end
end

function P:UPDATE_UI_WIDGET(widgetInfo)
	if self.disabled then return end
	if widgetInfo.widgetSetID == 1 and widgetInfo.widgetType == 0 then
		local info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(widgetInfo.widgetID)
		if info and info.state == 1 and info.hasTimer then
			self:UnregisterZoneEvents()
			C_Timer.After(.5, inspectAllGroupMembers)
		end
	end
end

function P:PLAYER_REGEN_DISABLED()
	if self.callbackTimers.arenaTicker then
		self.callbackTimers.arenaTicker:Cancel()
		self.callbackTimers.arenaTicker = nil
	end
	self:UnregisterEvent('PLAYER_REGEN_DISABLED')
end

function P:PLAYER_FLAGS_CHANGED(unitTarget)
	if unitTarget ~= "player" or InCombatLockdown() then return end
	local oldpvp = self.isPvP
	self.isPvP = C_PvP.IsWarModeDesired()
	if oldpvp ~= self.isPvP then
		self:UpdateBars()
		self:UpdateExBars()
		CM:EnqueueInspect(true)
	end
end

function P:CHALLENGE_MODE_START()
	CM:EnqueueInspect(true)
	self:ResetAllIcons()
	self:UnregisterZoneEvents()
end

function P:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
	if groupSize > 5 then
		self:ResetAllIcons("encounterEnd")
	end
end

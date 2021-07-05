local E, L, C = select(2, ...):unpack()

local GetNumGroupMembers = GetNumGroupMembers
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local P = E["Party"]

P.groupInfo = {}
P.pendingQueue = {}

P.userData = {
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
	shadowlandsData = {}
}

P.zoneEvents = {
	none  = { "PLAYER_FLAGS_CHANGED" },
	arena = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" },
	pvp   = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" },
	party = { "CHALLENGE_MODE_START" },
	raid  = { "ENCOUNTER_END" },
	all   = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET", "PLAYER_FLAGS_CHANGED", "CHALLENGE_MODE_START", "ENCOUNTER_END" },
}
if E.isBCC then
	P.zoneEvents.none = nil
	P.zoneEvents.party = nil
	P.zoneEvents.all = { "PLAYER_REGEN_DISABLED", "CHAT_MSG_BG_SYSTEM_NEUTRAL", "UPDATE_UI_WIDGET" }
end

do
	local anchorTimer
	local rosterTimer
	local syncTimer

	local function AnchorFix()
		P.UpdatePosition()
		anchorTimer = nil
	end

	local function SendRequestSync() -- [58]
		local success = E.Comms:InspectPlayer()
		if success then
			E.Comms:RequestSync()
			P.groupJoined = false
			syncTimer = nil
		else
			C_Timer.After(3, SendRequestSync)
		end
	end

	local function updateRosterInfo(force)
		if not force then
			rosterTimer = nil
		end

		local size = P:GetEffectiveNumGroupMembers()
		local oldDisabled = P.disabled
		P.disabled = not P.test and (P.disabledzone or size == 0 or
			(size == 1 and P.isUserDisabled) or -- [82]
			(GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 and not E.profile.Party.visibility.finder) or
			(size > E.profile.Party.visibility.size) or
			(size > 5 and not P.isInDungeon and E.customUF.enabled and E.db.position.uf ~= "blizz" and not E.db.extraBars.raidCDBar.enabled)) --> FindAnchorFrame
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

		for guid, info in pairs(P.groupInfo) do -- [42]
			if not UnitExists(info.name) or (guid == E.userGUID and P.isUserDisabled) then -- [82]
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

		local isInRaid = IsInRaid() -- [89]
		for i = 1, size do
			local index = not isInRaid and i == size and 5 or i
			local unit = isInRaid and E.RAID_UNIT[index] or E.PARTY_UNIT[index]
			local guid = UnitGUID(unit)
			local info = P.groupInfo[guid]
			local _, class = UnitClass(unit)

			local pet = class == "HUNTER" and E.unitToPetId[unit]
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
					info.bar.key = index
					info.bar.unit = unit
					info.bar.anchor.text:SetText(index)

					-- update event unitIDs
					if not E.isBCC then
						if guid ~= E.userGUID then -- [96]
							info.bar:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", unit)
						end

						if info.maxHealth then
							f:RegisterUnitEvent("UNIT_HEALTH", unit, unit)
						end
					end
					info.bar:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit, E.unitToPetId[unit]) -- [41]*
				end
				if force then -- [37]*
					P.pendingQueue[#P.pendingQueue + 1] = guid
					P:UpdateUnitBar(guid, true)
				end
			elseif guid == E.userGUID then
				if not P.isUserDisabled then -- [82]
					P.groupInfo[guid] = P.userData
					P.groupInfo[guid].index = index
					P.groupInfo[guid].unit = unit
					P.groupInfo[guid].petGUID = pet

					P:UpdateUnitBar(guid, true) -- [49]
				end
			elseif class then -- [32]
				local _,_, race = UnitRace(unit)
				local name = GetUnitName(unit, true)
				local level = UnitLevel(unit)
				if level == 0 then -- TODO: this isn't updated for synced units
					level = 200
				end
				P.groupInfo[guid] = {
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
				}

				P.pendingQueue[#P.pendingQueue + 1] = guid
				P:UpdateUnitBar(guid, true)
			else
				E.TimerAfter(3, updateRosterInfo, true) -- [97]
			end
		end

		P:UpdatePosition()
		P:UpdateExPosition()
		E.Comms:EnqueueInspect()

		if P.groupJoined or force then -- [101]
			if anchorTimer then -- TODO: Temp Fix Healbot on RL, VuhDo w/ Group+Invert
				anchorTimer:Cancel()
			end
			anchorTimer = C_Timer.NewTicker(10, AnchorFix, 1)

			if syncTimer then
				syncTimer:Cancel()
			end
			syncTimer = C_Timer.NewTicker(3, SendRequestSync, 1)
		end
	end

	function P:GROUP_ROSTER_UPDATE(isPEW, isRefresh) -- [50]
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

	-- TODO: remove showPlayerEx option and enable it by default
	-- TODO: if zone changed or isRefresh or first run
	local key = self.test and self.testZone or instanceType
	key = key == "none" and E.profile.Party.noneZoneSetting or (key == "scenario" and E.profile.Party.scenarioZoneSetting) or key
	E.db = E.profile.Party[key]
	P.profile = E.profile.Party
	P.db = E.db
	self.isUserHidden = not self.test and not E.db.general.showPlayer
	self.isUserDisabled = self.isUserHidden and (not E.db.general.showPlayerEx or (not E.db.extraBars.interruptBar.enabled and not E.db.extraBars.raidCDBar.enabled)) -- [82]

	E.Cooldowns:UpdateCombatLogVar()
	E:SetActiveUnitFrameData()
	self:UpdateEnabledSpells()
	self:UpdatePositionValues()
	self:UpdateExPositionValues()
	self:UpdateRaidPriority()

	E.UnregisterEvents(self, self.zoneEvents.all)
	E.RegisterEvents(self, self.zoneEvents[instanceType])

	self.isPvP = E.isBCC and true or (self.isInPvPInstance or (instanceType == "none" and C_PvP.IsWarModeDesired()))
	--//

	if self.isInPvPInstance then
		self:ResetAllIcons("joinedPvP")
	end

	self:GROUP_ROSTER_UPDATE(true, isRefresh) -- [37]
end

function P:CHAT_MSG_BG_SYSTEM_NEUTRAL(arg1)
	if self.disabled then return end
	if string.find(arg1, "!") then
		E.Comms:EnqueueInspect(true)
	end
end

do
	local inspectAll = function()
		E.Comms.EnqueueInspect(true)
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
end

function P:PLAYER_REGEN_DISABLED()
	E.UnregisterEvents(self, self.zoneEvents.arena)
end

function P:PLAYER_FLAGS_CHANGED()
	if ( InCombatLockdown() ) then return end

	local oldpvp = self.isPvP
	self.isPvP = C_PvP.IsWarModeDesired()
	if oldpvp ~= self.isPvP then
		self:UpdateBars()
		self:UpdateExPosition() -- update layout
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

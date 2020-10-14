local Indicators = {list = {"status", "pvp", "leader", "resurrect", "sumPending", "masterLoot", "raidTarget", "ready", "role", "lfdRole", "class", "phase", "questBoss", "petBattle", "arenaSpec"}}

ShadowUF:RegisterModule(Indicators, "indicators", ShadowUF.L["Indicators"])

function Indicators:UpdateArenaSpec(frame)
	if( not frame.indicators.arenaSpec or not frame.indicators.arenaSpec.enabled ) then return end

	local specID = GetArenaOpponentSpec(frame.unitID)
	local specIcon = specID and select(4, GetSpecializationInfoByID(specID))
	if( specIcon ) then
		frame.indicators.arenaSpec:SetTexture(specIcon)
		frame.indicators.arenaSpec:Show()
	else
		frame.indicators.arenaSpec:Hide()
	end
end

function Indicators:UpdateClass(frame)
	if( not frame.indicators.class or not frame.indicators.class.enabled ) then return end

	local class = frame:UnitClassToken()
	if( UnitIsPlayer(frame.unit) and class ) then
		local coords = CLASS_ICON_TCOORDS[class]
		frame.indicators.class:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		frame.indicators.class:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		frame.indicators.class:Show()
	else
		frame.indicators.class:Hide()
	end
end

function Indicators:UpdatePhase(frame)
    if( not frame.indicators.phase or not frame.indicators.phase.enabled ) then return end

    if( UnitIsConnected(frame.unit) and UnitPhaseReason(frame.unit) ) then
        frame.indicators.phase:SetTexture("Interface\\TargetingFrame\\UI-PhasingIcon")
        frame.indicators.phase:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
        frame.indicators.phase:Show()
    else
        frame.indicators.phase:Hide()
    end
end

function Indicators:UpdateResurrect(frame)
    if( not frame.indicators.resurrect or not frame.indicators.resurrect.enabled ) then return end

    if( UnitHasIncomingResurrection(frame.unit) ) then
        frame.indicators.resurrect:Show()
    else
        frame.indicators.resurrect:Hide()
    end
end

function Indicators:SummonPending(frame)
	if( not frame.indicators.sumPending or not frame.indicators.sumPending.enabled ) then return end

	if( C_IncomingSummon.HasIncomingSummon(frame.unit) ) then
		if( C_IncomingSummon.IncomingSummonStatus(frame.unit) == 1 ) then
			frame.indicators.sumPending:SetTexture("Interface\\RaidFrame\\RaidFrameSummon")
			frame.indicators.sumPending:SetTexCoord(0.539062, 0.789062, 0.015625, 0.515625)
			frame.indicators.sumPending:Show()
		elseif( C_IncomingSummon.IncomingSummonStatus(frame.unit) == 2 ) then
			frame.indicators.sumPending:SetTexture("Interface\\RaidFrame\\RaidFrameSummon")
			frame.indicators.sumPending:SetTexCoord(0.0078125, 0.257812, 0.015625, 0.515625)
			frame.indicators.sumPending:Show()
		elseif( C_IncomingSummon.IncomingSummonStatus(frame.unit) == 3 ) then
			frame.indicators.sumPending:SetTexture("Interface\\RaidFrame\\RaidFrameSummon")
			frame.indicators.sumPending:SetTexCoord(0.273438, 0.523438, 0.015625, 0.515625)
			frame.indicators.sumPending:Show()
		else
			frame.indicators.sumPending:Hide()
		end
	else
		frame.indicators.sumPending:Hide()
	end
end


function Indicators:UpdateMasterLoot(frame)
	if( not frame.indicators.masterLoot or not frame.indicators.masterLoot.enabled ) then return end

	local lootType, partyID, raidID = GetLootMethod()
	if( lootType ~= "master" ) then
		frame.indicators.masterLoot:Hide()
	elseif( ( partyID and partyID == 0 and UnitIsUnit(frame.unit, "player") ) or ( partyID and partyID > 0 and UnitIsUnit(frame.unit, ShadowUF.partyUnits[partyID]) ) or ( raidID and raidID > 0 and UnitIsUnit(frame.unit, ShadowUF.raidUnits[raidID]) ) ) then
		frame.indicators.masterLoot:Show()
	else
		frame.indicators.masterLoot:Hide()
	end
end

function Indicators:UpdateRaidTarget(frame)
	if( not frame.indicators.raidTarget or not frame.indicators.raidTarget.enabled ) then return end

	if( UnitExists(frame.unit) and GetRaidTargetIndex(frame.unit) ) then
		SetRaidTargetIconTexture(frame.indicators.raidTarget, GetRaidTargetIndex(frame.unit))
		frame.indicators.raidTarget:Show()
	else
		frame.indicators.raidTarget:Hide()
	end
end

function Indicators:UpdateQuestBoss(frame)
	if( not frame.indicators.questBoss or not frame.indicators.questBoss.enabled ) then return end

	if( UnitIsQuestBoss(frame.unit) ) then
		frame.indicators.questBoss:Show()
	else
		frame.indicators.questBoss:Hide()
	end
end

function Indicators:UpdateLFDRole(frame, event)
	if( not frame.indicators.lfdRole or not frame.indicators.lfdRole.enabled ) then return end

	local role
	if( frame.unitType ~= "arena" ) then
		role = UnitGroupRolesAssigned(frame.unitOwner)
	else
		local specID = GetArenaOpponentSpec(frame.unitID)
		role = specID and select(6, GetSpecializationInfoByID(specID))
	end

	if( role == "TANK" ) then
		frame.indicators.lfdRole:SetTexCoord(0, 19/64, 22/64, 41/64)
		frame.indicators.lfdRole:Show()
	elseif( role == "HEALER" ) then
		frame.indicators.lfdRole:SetTexCoord(20/64, 39/64, 1/64, 20/64)
		frame.indicators.lfdRole:Show()
	elseif( role == "DAMAGER" ) then
		frame.indicators.lfdRole:SetTexCoord(20/64, 39/64, 22/64, 41/64)
		frame.indicators.lfdRole:Show()
	else
		frame.indicators.lfdRole:Hide()
	end
end

function Indicators:UpdateRole(frame, event)
	if( not frame.indicators.role or not frame.indicators.role.enabled ) then return end

	if( not UnitInRaid(frame.unit) and not UnitInParty(frame.unit) ) then
		frame.indicators.role:Hide()
	elseif( GetPartyAssignment("MAINTANK", frame.unit) ) then
		frame.indicators.role:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon")
		frame.indicators.role:Show()
	elseif( GetPartyAssignment("MAINASSIST", frame.unit) ) then
		frame.indicators.role:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon")
		frame.indicators.role:Show()
	else
		frame.indicators.role:Hide()
	end
end

function Indicators:UpdateLeader(frame)
	if( not frame.indicators.leader or not frame.indicators.leader.enabled ) then return end

	if( UnitIsGroupLeader(frame.unit) or (frame.unit == "target" and UnitLeadsAnyGroup(frame.unit)) ) then
		if( HasLFGRestrictions() ) then
			frame.indicators.leader:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			frame.indicators.leader:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
		else
			frame.indicators.leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
			frame.indicators.leader:SetTexCoord(0, 1, 0, 1)
		end

		frame.indicators.leader:Show()

	elseif( UnitIsGroupAssistant(frame.unit) or ( UnitInRaid(frame.unit) and IsEveryoneAssistant() ) ) then
		frame.indicators.leader:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
		frame.indicators.leader:SetTexCoord(0, 1, 0, 1)
		frame.indicators.leader:Show()
	else
		frame.indicators.leader:Hide()
	end
end

function Indicators:GroupRosterUpdate(frame)
	self:UpdateMasterLoot(frame)
	self:UpdateRole(frame)
	self:UpdateLFDRole(frame)
	self:UpdateLeader(frame)
end

function Indicators:UpdatePVPFlag(frame)
	if( not frame.indicators.pvp or not frame.indicators.pvp.enabled ) then return end

	local faction = UnitFactionGroup(frame.unit)
	if( UnitIsPVPFreeForAll(frame.unit) ) then
		frame.indicators.pvp:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
		frame.indicators.pvp:SetTexCoord(0,1,0,1)
		frame.indicators.pvp:Show()
	elseif( faction and faction ~= "Neutral" and UnitIsPVP(frame.unit) ) then
		frame.indicators.pvp:SetTexture(string.format("Interface\\TargetingFrame\\UI-PVP-%s", faction))
		frame.indicators.pvp:SetTexCoord(0,1,0,1)
		frame.indicators.pvp:Show()
	else
		frame.indicators.pvp:Hide()
	end
end

function Indicators:UpdatePetBattle(frame)
	if( UnitIsWildBattlePet(frame.unit) or UnitIsBattlePetCompanion(frame.unit) ) then
		local petType = UnitBattlePetType(frame.unit)
		frame.indicators.petBattle:SetTexture(string.format("Interface\\TargetingFrame\\PetBadge-%s", PET_TYPE_SUFFIX[petType]))
		frame.indicators.petBattle:Show()
	else
		frame.indicators.petBattle:Hide()
	end
end

-- Non-player units do not give events when they enter or leave combat, so polling is necessary
local function combatMonitor(self, elapsed)
	self.timeElapsed = self.timeElapsed + elapsed
	if( self.timeElapsed < 1 ) then return end
	self.timeElapsed = self.timeElapsed - 1

	if( UnitAffectingCombat(self.parent.unit) ) then
		self.status:Show()
	else
		self.status:Hide()
	end
end

-- It looks like the combat check for players is a bit buggy when they are in a vehicle, so swap it to also check polling
function Indicators:CheckVehicle(frame)
	frame.indicators.timeElapsed = 0
	frame.indicators:SetScript("OnUpdate", frame.inVehicle and combatMonitor or nil)
end

function Indicators:UpdateStatus(frame)
	if( not frame.indicators.status or not frame.indicators.status.enabled ) then return end

	if( UnitAffectingCombat(frame.unitOwner) ) then
		frame.indicators.status:SetTexCoord(0.50, 1.0, 0.0, 0.49)
		frame.indicators.status:Show()
	elseif( frame.unitRealType == "player" and IsResting() ) then
		frame.indicators.status:SetTexCoord(0.0, 0.50, 0.0, 0.421875)
		frame.indicators.status:Show()
	else
		frame.indicators.status:Hide()
	end
end

-- Ready check fading once the check complete
local function fadeReadyStatus(self, elapsed)
	self.timeLeft = self.timeLeft - elapsed
	self.ready:SetAlpha(self.timeLeft / self.startTime)

	if( self.timeLeft <= 0 ) then
		self:SetScript("OnUpdate", nil)

		self.ready.status = nil
		self.ready:Hide()
	end
end

local FADEOUT_TIME = 6
function Indicators:UpdateReadyCheck(frame, event)
	if( not frame.indicators.ready or not frame.indicators.ready.enabled ) then return end

	-- We're done, and should fade it out if it's shown
	if( event == "READY_CHECK_FINISHED" ) then
		if( not frame.indicators.ready:IsShown() ) then return end

		-- Create the central timer frame if ones not already made
		if( not self.fadeTimer ) then
			self.fadeTimer = CreateFrame("Frame", nil)
			self.fadeTimer.fadeList = {}
			self.fadeTimer:Hide()
			self.fadeTimer:SetScript("OnUpdate", function(f, elapsed)
				local hasTimer
				for fadeFrame, timeLeft in pairs(f.fadeList) do
					hasTimer = true

					f.fadeList[fadeFrame] = timeLeft - elapsed
					fadeFrame:SetAlpha(f.fadeList[fadeFrame] / FADEOUT_TIME)

					if( f.fadeList[fadeFrame] <= 0 ) then
						f.fadeList[fadeFrame] = nil
						fadeFrame:Hide()
					end
				end

				if( not hasTimer ) then f:Hide() end
			end)
		end

		-- Start the timer
		self.fadeTimer.fadeList[frame.indicators.ready] = FADEOUT_TIME
		self.fadeTimer:Show()

		-- Player never responded so they are AFK
		if( frame.indicators.ready.status == "waiting" ) then
			frame.indicators.ready:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
		end
		return
	end

	-- Have a state change in ready status
	local status = GetReadyCheckStatus(frame.unit)
	if( not status ) then
		frame.indicators.ready.status = nil
		frame.indicators.ready:Hide()
		return
	end

	if( status == "ready" ) then
		frame.indicators.ready:SetTexture(READY_CHECK_READY_TEXTURE)
	elseif( status == "notready" ) then
		frame.indicators.ready:SetTexture(READY_CHECK_NOT_READY_TEXTURE)
	elseif( status == "waiting" ) then
		frame.indicators.ready:SetTexture(READY_CHECK_WAITING_TEXTURE)
	end

	frame.indicators:SetScript("OnUpdate", nil)
	frame.indicators.ready.status = status
	frame.indicators.ready:SetAlpha(1.0)
	frame.indicators.ready:Show()
end

function Indicators:UpdateFlags(frame)
	self:UpdateLeader(frame)
	self:UpdatePVPFlag(frame)
end

function Indicators:OnEnable(frame)
	-- Forces the indicators to be above the bars/portraits/etc
	if( not frame.indicators ) then
		frame.indicators = CreateFrame("Frame", nil, frame)
		frame.indicators:SetFrameLevel(frame.topFrameLevel + 2)
	end

	-- Now lets enable all the indicators
	local config = ShadowUF.db.profile.units[frame.unitType]
	if( config.indicators.status and config.indicators.status.enabled ) then
		frame:RegisterUpdateFunc(self, "UpdateStatus")
		frame.indicators.status = frame.indicators.status or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.status:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
		frame.indicators.timeElapsed = 0
		frame.indicators.parent = frame

		if( frame.unitType == "player" ) then
			frame:RegisterUpdateFunc(self, "CheckVehicle")
			frame:RegisterNormalEvent("PLAYER_REGEN_ENABLED", self, "UpdateStatus")
			frame:RegisterNormalEvent("PLAYER_REGEN_DISABLED", self, "UpdateStatus")
			frame:RegisterNormalEvent("PLAYER_UPDATE_RESTING", self, "UpdateStatus")
			frame:RegisterNormalEvent("UPDATE_FACTION", self, "UpdateStatus")
		else
			frame.indicators.status:SetTexCoord(0.50, 1.0, 0.0, 0.49)
			frame.indicators:SetScript("OnUpdate", combatMonitor)
		end
	elseif( frame.indicators.status ) then
		frame.indicators:SetScript("OnUpdate", nil)
	end

	if( config.indicators.arenaSpec and config.indicators.arenaSpec.enabled ) then
		frame:RegisterNormalEvent("ARENA_OPPONENT_UPDATE", self, "UpdateArenaSpec")
		frame:RegisterUpdateFunc(self, "UpdateArenaSpec")
        frame.indicators.arenaSpec = frame.indicators.arenaSpec or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	if( config.indicators.phase and config.indicators.phase.enabled ) then
		-- Player phase changes do not generate a phase change event. This seems to be the best
		-- TODO: what event does fire here? frame:RegisterNormalEvent("UPDATE_WORLD_STATES", self, "UpdatePhase")
        frame:RegisterUpdateFunc(self, "UpdatePhase")
        frame.indicators.phase = frame.indicators.phase or frame.indicators:CreateTexture(nil, "OVERLAY")
    end

	if( config.indicators.resurrect and config.indicators.resurrect.enabled ) then
	    frame:RegisterNormalEvent("INCOMING_RESURRECT_CHANGED", self, "UpdateResurrect")
	    frame:RegisterNormalEvent("UNIT_OTHER_PARTY_CHANGED", self, "UpdateResurrect")
	    frame:RegisterUpdateFunc(self, "UpdateResurrect")

	    frame.indicators.resurrect = frame.indicators.resurrect or frame.indicators:CreateTexture(nil, "OVERLAY")
	    frame.indicators.resurrect:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez")
	end

	if( config.indicators.sumPending and config.indicators.sumPending.enabled ) then
		frame:RegisterNormalEvent("INCOMING_SUMMON_CHANGED", self, "SummonPending")
		frame:RegisterUpdateFunc(self, "SummonPending")

		frame.indicators.sumPending = frame.indicators.sumPending or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.sumPending:SetTexture("Interface\\RaidFrame\\RaidFrameSummon")
	end

	if( config.indicators.pvp and config.indicators.pvp.enabled ) then
		frame:RegisterUnitEvent("UNIT_FACTION", self, "UpdatePVPFlag")
		frame:RegisterUpdateFunc(self, "UpdatePVPFlag")

		frame.indicators.pvp = frame.indicators.pvp or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	if( config.indicators.class and config.indicators.class.enabled ) then
		frame:RegisterUpdateFunc(self, "UpdateClass")
		frame.indicators.class = frame.indicators.class or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	if( config.indicators.leader and config.indicators.leader.enabled ) then
		frame:RegisterNormalEvent("PARTY_LEADER_CHANGED", self, "UpdateLeader")
		frame:RegisterUpdateFunc(self, "UpdateLeader")

		frame.indicators.leader = frame.indicators.leader or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	if( config.indicators.masterLoot and config.indicators.masterLoot.enabled ) then
		frame:RegisterNormalEvent("PARTY_LOOT_METHOD_CHANGED", self, "UpdateMasterLoot")
		frame:RegisterUpdateFunc(self, "UpdateMasterLoot")

		frame.indicators.masterLoot = frame.indicators.masterLoot or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.masterLoot:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
	end

	if( config.indicators.role and config.indicators.role.enabled ) then
		frame:RegisterUpdateFunc(self, "UpdateRole")

		frame.indicators.role = frame.indicators.role or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.role:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon")
	end

	if( config.indicators.raidTarget and config.indicators.raidTarget.enabled ) then
		frame:RegisterNormalEvent("RAID_TARGET_UPDATE", self, "UpdateRaidTarget")
		frame:RegisterUpdateFunc(self, "UpdateRaidTarget")

		frame.indicators.raidTarget = frame.indicators.raidTarget or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.raidTarget:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	end

	if( config.indicators.ready and config.indicators.ready.enabled ) then
		frame:RegisterNormalEvent("READY_CHECK", self, "UpdateReadyCheck")
		frame:RegisterNormalEvent("READY_CHECK_CONFIRM", self, "UpdateReadyCheck")
		frame:RegisterNormalEvent("READY_CHECK_FINISHED", self, "UpdateReadyCheck")
		frame:RegisterUpdateFunc(self, "UpdateReadyCheck")

		frame.indicators.ready = frame.indicators.ready or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	if( config.indicators.lfdRole and config.indicators.lfdRole.enabled ) then
		frame:RegisterNormalEvent("PLAYER_ROLES_ASSIGNED", self, "UpdateLFDRole")
		frame:RegisterUpdateFunc(self, "UpdateLFDRole")

		frame.indicators.lfdRole = frame.indicators.lfdRole or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.lfdRole:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	end

	if( config.indicators.questBoss and config.indicators.questBoss.enabled ) then
		frame:RegisterUnitEvent("UNIT_CLASSIFICATION_CHANGED", self, "UpdateQuestBoss")
		frame:RegisterUpdateFunc(self, "UpdateQuestBoss")

		frame.indicators.questBoss = frame.indicators.questBoss or frame.indicators:CreateTexture(nil, "OVERLAY")
		frame.indicators.questBoss:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")
	end

	if( config.indicators.petBattle and config.indicators.petBattle.enabled ) then
		frame:RegisterUpdateFunc(self, "UpdatePetBattle")
		frame.indicators.petBattle = frame.indicators.petBattle or frame.indicators:CreateTexture(nil, "OVERLAY")
	end

	-- As they all share the function, register it as long as one is active
	if( frame.indicators.leader or frame.indicators.masterLoot or frame.indicators.role or ( frame.unit ~= "player" and frame.indicators.lfdRole ) ) then
		frame:RegisterNormalEvent("GROUP_ROSTER_UPDATE", self, "GroupRosterUpdate")
	end

	if( frame.indicators.leader or frame.indicators.pvp ) then
		frame:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", self, "UpdateFlags")
	end
end

function Indicators:OnDisable(frame)
	frame:UnregisterAll(self)

	for _, key in pairs(self.list) do
		if( frame.indicators[key] ) then
			frame.indicators[key].enabled = nil
			frame.indicators[key]:Hide()
		end
	end
end

function Indicators:OnLayoutApplied(frame, config)
	if( frame.visibility.indicators ) then
		self:OnDisable(frame)
		self:OnEnable(frame)

		for _, key in pairs(self.list) do
			local indicator = frame.indicators[key]
			if( indicator and config.indicators[key] and config.indicators[key].enabled and config.indicators[key].size ) then
				indicator.enabled = true
				indicator:SetHeight(config.indicators[key].size)
				indicator:SetWidth(config.indicators[key].size)
				ShadowUF.Layout:AnchorFrame(frame, indicator, config.indicators[key])
			elseif( indicator ) then
				indicator.enabled = nil
				indicator:Hide()
			end
		end

		-- Disable the polling
		if( config.indicators.status and not config.indicators.status.enabled and frame.indicators.status ) then
			frame.indicators:SetScript("OnUpdate", nil)
		end
	end
end

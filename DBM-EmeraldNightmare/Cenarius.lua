local mod	= DBM:NewMod(1750, "DBM-EmeraldNightmare", nil, 768)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116144653")
mod:SetCreatureID(104636)
mod:SetEncounterID(1877)
mod:SetUsedIcons(8, 7, 6, 5, 4)
mod:SetHotfixNoticeRev(15557)
mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 212726 212630 211073 211368 214529 213162 214249 226821",
	"SPELL_CAST_SUCCESS 214529 211471 212726",
	"SPELL_AURA_APPLIED 210346 211368 211471",
	"SPELL_AURA_APPLIED_DOSE 210279",
	"SPELL_AURA_REMOVED 210346",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5",
	"UNIT_AURA player"
)

--Cenarius
local warnNightmareBrambles			= mod:NewTargetAnnounce(210290, 2)
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
----Forces of Nightmare
local warnDesiccatingStomp			= mod:NewCastAnnounce(211073, 3, nil, nil, true, 2)--Basic warning for now, will change to special if needed
local warnRottenBreath				= mod:NewTargetAnnounce(211192, 2)
local warnScornedTouch				= mod:NewTargetAnnounce(211471, 3)
--Malfurion Stormrage
local warnCleansingGround			= mod:NewCastAnnounce(212630, 1)

--Cenarius
local specWarnCreepingNightmares	= mod:NewSpecialWarningStack(210279, nil, 16, nil, 2, 1, 6)--Stack warning subject to tuning
local yellNightmareBrambles			= mod:NewYell(210290, L.BrambleYell)
local specWarnNightmareBramblesNear	= mod:NewSpecialWarningClose(210290, nil, nil, nil, 1, 2)
local specWarnNightmareBlast		= mod:NewSpecialWarningDefensive(213162, nil, nil, nil, 1, 2)
local specWarnNightmareBlastOther	= mod:NewSpecialWarningTaunt(213162, nil, nil, nil, 1, 2)
local specWarnForcesOfNightmare		= mod:NewSpecialWarningSwitchCount(212726, nil, nil, nil, 1, 2)--Switch warning or just spell warning?
local specWarnSpearOfNightmares		= mod:NewSpecialWarningDefensive(214529, nil, nil, nil, 1, 2)
local specWarnSpearOfNightmaresOther= mod:NewSpecialWarningTaunt(214529, nil, nil, nil, 1, 2)
local specWarnSpearOfNightmaresMelee= mod:NewSpecialWarningRun(214529, nil, nil, nil, 4, 2)
local specWarnEntangledNightmares	= mod:NewSpecialWarningSwitch(214505, "Dps", nil, nil, 1, 2)
local specWarnBeastsOfNightmare		= mod:NewSpecialWarningDodge(214876, nil, nil, nil, 2, 2)
----Forces of Nightmare
local yellRottenBreath				= mod:NewYell(211192)
local specWarnTouchofLife			= mod:NewSpecialWarningInterrupt(211368, "HasInterrupt")
local specWarnTouchofLifeDispel		= mod:NewSpecialWarningDispel(211368, "MagicDispeller")
local specWarnScornedTouch			= mod:NewSpecialWarningMoveAway(211471, nil, nil, nil, 3, 2)
local yellScornedTouch				= mod:NewYell(211471)

--Cenarius
mod:AddTimerLine(L.name)
local timerNightmareBramblesCD		= mod:NewCDTimer(30, 210290, nil, "-Tank", 2, 3, nil, nil, nil, 3, 4)--On for all, for now. Doesn't target melee but melee still have to be aware. Just not AS aware.
local timerDreadThornsCD			= mod:NewCDTimer(34, 210346, nil, false, 3, 5, nil, DBM_COMMON_L.TANK_ICON)--Optional but off by default
local timerNightmareBlastCD			= mod:NewNextTimer(32.5, 213162, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 4)
local timerForcesOfNightmareCD		= mod:NewCDCountTimer(77.6, 212726, nil, nil, nil, 1, nil, nil, nil, 1, 4)--77.8-80
local timerSpearOfNightmaresCD		= mod:NewCDTimer(18.2, 214529, nil, "Melee|Healer", 3, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 4)
local timerBeastsOfNightmareCD		= mod:NewCDTimer(30, 214876, nil, nil, 2, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerEntanglingNightmareCD	= mod:NewNextTimer(51, 214505, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
----Malfurion
local timerCleansingGroundCD		= mod:NewNextTimer(77, 214249, nil, nil, nil, 3)--Phase 2 version only for now. Not sure if cast more than once though?
----Forces of Nightmare
mod:AddTimerLine(DBM_COMMON_L.ADDS)
local timerScornedTouchCD			= mod:NewCDTimer(20.7, 211471, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerTouchofLifeCD			= mod:NewCDTimer(15, 211368, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerRottenBreathCD			= mod:NewCDTimer(24.3, 211192, nil, nil, nil, 3)
local timerDisiccatingStompCD		= mod:NewCDTimer(32, 211073, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)

mod:AddRangeFrameOption(8, 211471)
mod:AddSetIconOption("SetIconOnWisps", "ej13348", false, true)
mod:AddInfoFrameOption(210279)

mod.vb.phase = 1
mod.vb.addsCount = 0
mod.vb.sisterCount = 0
local scornedWarned = false
local seenMobs = {}
local debuffName, infoframeName = DBM:GetSpellInfo(211471), DBM:GetSpellInfo(210279)

function mod:BreathTarget(targetname, uId)
	if not targetname then return end
	warnRottenBreath:Show(targetname)
	if targetname == UnitName("player") then
		yellRottenBreath:Yell()
	end
end

function mod:OnCombatStart(delay)
	scornedWarned = false
	table.wipe(seenMobs)
	self.vb.phase = 1
	self.vb.addsCount = 0
	self.vb.sisterCount = 0
	timerForcesOfNightmareCD:Start(7.2-delay, 1)--7.2-8.6
	timerDreadThornsCD:Start(14-delay)
	timerNightmareBramblesCD:Start(27.5-delay)--Cast finish.
	if self:IsMythic() then
		timerNightmareBlastCD:Start(30.5-delay)
	end
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"
	)
	if self.Options.InfoFrame and not self:IsLFR() then
		DBM.InfoFrame:SetHeader(infoframeName)
		DBM.InfoFrame:Show(8, "playerdebuffstacks", infoframeName)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	--DBM:AddMsg(L.BrambleMessage)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 212726 then
		self.vb.addsCount = self.vb.addsCount + 1
		specWarnForcesOfNightmare:Show(self.vb.addsCount)
		specWarnForcesOfNightmare:Play("mobsoon")
		timerForcesOfNightmareCD:Start(nil, self.vb.addsCount+1)
	elseif spellId == 212630 or spellId == 214249 then--214249 is phase 2
		warnCleansingGround:Show()
	elseif (spellId == 211073 or spellId == 226821) and self:AntiSpam(10, args.sourceGUID) then
		warnDesiccatingStomp:Show()
		if self:IsMythic() then
			timerDisiccatingStompCD:Start(29, args.SourceGUID)
		else
			timerDisiccatingStompCD:Start(nil, args.SourceGUID)
		end
	elseif spellId == 211368 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTouchofLife:Show(args.sourceName)
			specWarnTouchofLife:Play("kickcast")
		end
		if self:IsEasy() then
			timerTouchofLifeCD:Start(15, args.sourceGUID)
		else
			timerTouchofLifeCD:Start(11, args.sourceGUID)
		end
	elseif spellId == 214529 then
		timerSpearOfNightmaresCD:Start()
		local targetName, uId, bossuid = self:GetBossTarget(104636, true)
		if self:IsTanking("player", bossuid, nil, true) then
			specWarnSpearOfNightmares:Show()
			specWarnSpearOfNightmares:Play("defensive")
		end
		if self:IsMeleeDps() and self:IsMythic() then
			specWarnSpearOfNightmaresMelee:Show()
			specWarnSpearOfNightmaresMelee:Play("runout")
		end
	elseif spellId == 213162 then
		timerNightmareBlastCD:Start()
		local targetName, uId, bossuid = self:GetBossTarget(104636, true)
		if self:IsTanking("player", bossuid, nil, true) then
			specWarnNightmareBlast:Show()
			specWarnNightmareBlast:Play("defensive")
		else
			if self:GetNumAliveTanks() >= 3 and not self:CheckNearby(30, targetName) then return end--You are not near current tank, you're probably 3rd tank on Adds that never taunts nightmare blast
			specWarnNightmareBlastOther:Schedule(2, targetName)
			specWarnNightmareBlastOther:ScheduleVoice(2, "tauntboss")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 214529 and not args:IsPlayer() then
		if self:GetNumAliveTanks() >= 3 and not self:CheckNearby(21, args.destName) then return end--You are not near current tank, you're probably 3rd tank on Adds that never taunts nightmare blast
		specWarnSpearOfNightmaresOther:Show(args.destName)
		specWarnSpearOfNightmaresOther:Play("tauntboss")
	elseif spellId == 211471 and self:AntiSpam(5, 1) then
		timerScornedTouchCD:Start(nil, args.sourceGUID)
	elseif spellId == 212726 then
		--Wisps don't fire IEEU so done here instead
		if self.Options.SetIconOnWisps then
			self:ScanForMobs(106304, 0, 8, 5, {[106304] = true, [106659] = true,}, 20, "SetIconOnWisps", false)--Double ID scan for wisps
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 210346 then
--		specWarnDreadThorns:Show()
--		specWarnDreadThorns:Play("bossout")
	elseif spellId == 211368 then
		specWarnTouchofLifeDispel:Show(args.destName)
		if self.Options.SpecWarn211368dispel then
			specWarnTouchofLifeDispel:Play("dispelnow")
		end
	elseif spellId == 211471 then--Original casts only. Jumps can't be warned this way as of 04-01-16 Testing
		warnScornedTouch:CombinedShow(0.5, args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 210279 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount % 4 == 0 then--Every 4
			if amount >= 16 then--Starting at 16
				specWarnCreepingNightmares:Show(amount)
				specWarnCreepingNightmares:Play("stackhigh")
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 210346 then
		timerDreadThornsCD:Start()
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unitID = "boss"..i
		local GUID = UnitGUID(unitID)
		if GUID and not seenMobs[GUID] and UnitIsEnemy("player", unitID) then
			seenMobs[GUID] = true
			local cid = self:GetCIDFromGUID(GUID)
			if cid == 105495 then--Scorned Sister
				self.vb.sisterCount = self.vb.sisterCount + 1
				timerScornedTouchCD:Start(4.5, GUID)
				timerTouchofLifeCD:Start(6, GUID)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(8)
				end
			elseif cid == 105494 then--Rotten Drake
				timerRottenBreathCD:Start(18.1, GUID)
			elseif cid == 105468 then--Nightmare Ancient
				timerDisiccatingStompCD:Start(18.1, GUID)
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 105495 then--Scorned Sister
		self.vb.sisterCount = self.vb.sisterCount - 1
		timerTouchofLifeCD:Stop(args.destGUID)
		timerScornedTouchCD:Stop(args.destGUID)
		if self.Options.RangeFrame and self.vb.sisterCount == 0 and not DBM:UnitDebuff("player", debuffName) then--Do to shitty spellInfo code, it'll fail to hide first time
			DBM.RangeCheck:Hide()
		end
	elseif cid == 105494 then--Rotten Drake
		--This is safer method to cancel it but if more than 1 drake is up it may in rare cases break scan for 2nd drake
		self:BossUnitTargetScannerAbort()
		timerRottenBreathCD:Stop(args.destGUID)
	elseif cid == 105468 then--Nightmare Ancient
		timerDisiccatingStompCD:Stop(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 211189 then--Rotten Breath precast. Best method for fastest and most accurate target scanning
		self:BossUnitTargetScanner(uId, "BreathTarget")
		timerRottenBreathCD:Start(nil, UnitGUID(uId))
	elseif spellId == 210290 then--Bramble cast finish (only thing not hidden, probably be hidden too by live, if so will STILL find a way to warn this, even if it means scanning boss 24/7)
		if not UnitExists(uId.."target") then return end--Blizzard decided to go even further out of way to break this detection, if this happens we don't want nil errors for users.
		local targetName = DBM:GetUnitFullName(uId.."target")
		if UnitIsUnit("player", uId.."target") then
			specWarnNightmareBramblesNear:Show(YOU)
			yellNightmareBrambles:Yell()
			specWarnNightmareBramblesNear:Play("runout")
		elseif self:CheckNearby(8, targetName) then
			specWarnNightmareBramblesNear:Show(targetName)
			specWarnNightmareBramblesNear:Play("watchstep")
		else
			warnNightmareBrambles:Show(targetName)
		end
		timerNightmareBramblesCD:Start()
	elseif spellId == 217368 then--Overwhelming Nightmare (Phase 2)
		self.vb.phase = 2
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		timerForcesOfNightmareCD:Stop()
		timerNightmareBlastCD:Stop()
		timerDreadThornsCD:Stop()
		timerNightmareBramblesCD:Stop()
		timerCleansingGroundCD:Stop()
		timerNightmareBramblesCD:Start(13)
		timerSpearOfNightmaresCD:Start(20)
		timerCleansingGroundCD:Start(30.5)
		timerEntanglingNightmareCD:Start(35)
--		if self:IsMythic() then
--			timerBeastsOfNightmareCD:Start(1)--First one is near right away
--		end
	elseif spellId == 214454 then--Entangling Nightmares (this is just a lot faster than combat log)
		specWarnEntangledNightmares:Show()
		timerEntanglingNightmareCD:Start()
	elseif spellId == 214876 then
		specWarnBeastsOfNightmare:Show()
		specWarnBeastsOfNightmare:Play("watchstep")
		timerBeastsOfNightmareCD:Start()
	end
end

do
	--Jumps didn't show in combat log during testing, only original casts. However, jumps need warnings too
	--Check at later time if jumps are in combat log
	function mod:UNIT_AURA(uId)
		local hasDebuff = DBM:UnitDebuff("player", debuffName)
		if hasDebuff and not scornedWarned then
			specWarnScornedTouch:Show()
			specWarnScornedTouch:Play("runout")
			yellScornedTouch:Yell()
			scornedWarned = true
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		elseif not hasDebuff and scornedWarned then
			scornedWarned = false
			if self.Options.RangeFrame and self.vb.sisterCount == 0 then
				DBM.RangeCheck:Hide()
			end
		end
	end
end

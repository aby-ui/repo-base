local mod	= DBM:NewMod(2366, "DBM-Nyalotha", nil, 1180)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217005916")
mod:SetCreatureID(157439)--Fury of N'Zoth
mod:SetEncounterID(2337)
mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20200315000000)--2020, 3, 15
mod:SetMinSyncRevision(20200315000000)--2020, 3, 15
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 307809 307092 313039 315820 315891 315947 307064",
	"SPELL_CAST_SUCCESS 313362 306971 306986 306988",
	"SPELL_AURA_APPLIED 313334 307832 306973 306990 306984 315954 307079 316848",
	"SPELL_AURA_APPLIED_DOSE 315954",
	"SPELL_AURA_REMOVED 313334 306973 306990 307079 306984 316848",
	"SPELL_AURA_REMOVED_DOSE 307079",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_POWER_FREQUENT player"
)

--TODO, escalated tank warning for adaptive membrane on Fury, if you're tanking it
--[[
(ability.id = 315820 or ability.id = 307809 or ability.id = 313039 or ability.id = 307092 or ability.id = 315891 or ability.id = 315947) and type = "begincast"
 or (ability.id = 313362 or ability.id = 306971 or ability.id = 306986 or ability.id = 306988) and type = "cast"
 or ability.id = 307079 and (type = "applybuff" or type = "removebuff")
 or ability.id = 318108 and type = "applybuff"
--]]
--General
local warnPhase								= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnGiftofNzoth						= mod:NewTargetNoFilterAnnounce(313334, 2)
local warnWillPower							= mod:NewCountAnnounce(307831, 3)

local specWarnGiftofNzoth					= mod:NewSpecialWarningYou(313334, nil, nil, nil, 1, 2)
local specWarnServantofNzoth				= mod:NewSpecialWarningTargetChange(307832, false, nil, 2, 1, 2)
local yellServantofNzoth					= mod:NewYell(307832)
local specWarnBlackScar						= mod:NewSpecialWarningStack(315954, nil, 2, nil, nil, 1, 6)
local specWarnBlackScarTaunt				= mod:NewSpecialWarningTaunt(315954, nil, nil, nil, 1, 2)
local specwarnWillPower						= mod:NewSpecialWarningCount(307831, nil, nil, nil, 1, 10)
--local specWarnGTFO						= mod:NewSpecialWarningGTFO(270290, nil, nil, nil, 1, 8)

local timerGiftofNzoth						= mod:NewBuffFadesTimer(20, 313334, nil, nil, nil, 5)

mod:AddRangeFrameOption("10")
mod:AddInfoFrameOption(307831, true)
--Stage 1: Exterior Carapace
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20558))
----Fury of N'Zoth
local warnMadnessBomb						= mod:NewTargetAnnounce(306973, 2)
local warnAdaptiveMembrane					= mod:NewTargetNoFilterAnnounce(306990, 4)
local warnBlackScar							= mod:NewStackAnnounce(315954, 2, nil, "Tank")

local specWarnMadnessBomb					= mod:NewSpecialWarningMoveAway(306973, nil, nil, nil, 1, 2)
local yellMadnessBomb						= mod:NewYell(306973)
local yellMadnessBombFades					= mod:NewShortFadesYell(306973)
local specWarnGrowthCoveredTentacle			= mod:NewSpecialWarningDodgeCount(307131, nil, nil, nil, 3, 2)
local specWarnAdaptiveMembrane				= mod:NewSpecialWarningYou(306990, nil, nil, nil, 1, 2, 4)--Mythic

local timerMadnessBombCD					= mod:NewCDCountTimer(22.2, 306973, nil, nil, nil, 3)--22-24
local timerAdaptiveMembraneCD				= mod:NewCDCountTimer(27.7, 306990, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 3, 3)
local timerAdaptiveMembrane					= mod:NewBuffActiveTimer(12, 306990, nil, false, 2, 5, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerMentalDecayCD					= mod:NewCDTimer(21, 313364, nil, nil, nil, 3)
local timerGrowthCoveredTentacleCD			= mod:NewNextCountTimer(60, 307131, nil, nil, nil, 1, nil, nil, nil, 1, 3)
local timerMandibleSlamCD					= mod:NewCDTimer(12.7, 315947, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)--12.7

mod:AddSetIconOption("SetIconAdaptiveMembrane", 316848, true, false, {1, 2, 3})
mod:AddNamePlateOption("NPAuraOnMembrane2", 306990, false)
----Gaze of Madness
local specWarnGazeOfMadness					= mod:NewSpecialWarningSwitch("ej20565", "Dps", nil, nil, 1, 2)

local timerGazeofMadnessCD					= mod:NewCDCountTimer(58, "ej20565", nil, nil, nil, 1, 307008, DBM_COMMON_L.DAMAGE_ICON)
--Stage 2: Subcutaneous Tunnel
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20566))
local warnSynthesRemaining					= mod:NewCountAnnounce(307079, 2)
local warnSynthesisOver						= mod:NewEndAnnounce(307079, 1)

local specWarnEternalDarkness				= mod:NewSpecialWarningCount(307048, nil, nil, nil, 2, 2)
local specWarnOccipitalBlast				= mod:NewSpecialWarningDodge(307092, nil, nil, nil, 2, 2)

local timerEternalDarknessCD				= mod:NewCDTimer(22.2, 307048, nil, nil, nil, 2)--Can be delayed if it overlaps with blast, otherwise dead on
local timerOccipitalBlastCD					= mod:NewCDTimer(33.3, 307092, nil, nil, nil, 3)--Can be delayed if it overlaps with Eternal darkness, otherwise dead on
--Stage 3: Nightmare Chamber
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20569))
local warnInsanityBomb						= mod:NewTargetAnnounce(306984, 2)
local warnCystGenesis						= mod:NewSpellAnnounce(307064, 3)

local specWarnInsanityBomb					= mod:NewSpecialWarningMoveAway(306984, nil, nil, nil, 1, 2)
local yellInsanityBomb						= mod:NewYell(306984, nil, false, 2)
local yellInsanityBombFades					= mod:NewShortFadesYell(306984)
local specWarnInfiniteDarkness				= mod:NewSpecialWarningCount(313040, nil, nil, nil, 2, 2)
local specWarnThrashingTentacle				= mod:NewSpecialWarningCount(315820, nil, nil, nil, 2, 2)

local timerInsanityBombCD					= mod:NewCDTimer(66.9, 306984, nil, nil, nil, 3)
local timerInfiniteDarknessCD				= mod:NewCDCountTimer(53.9, 313040, nil, nil, nil, 2)
local timerThrashingTentacleCD				= mod:NewCDCountTimer(20, 315820, nil, nil, nil, 3)

local berserkTimer							= mod:NewBerserkTimer(720)

mod.vb.TentacleCount = 0
mod.vb.gazeCount = 0
mod.vb.DarknessCount = 0
mod.vb.anchorCount = 0
mod.vb.adaptiveCount = 0
mod.vb.adaptiveIcon = 1
mod.vb.madnessBombCount = 0
local lastSanity = 100
--Debug
local lastGazeTime = 0
local debugSpawnTable = {}

local function thrashingTentacleLoop(self)
	self.vb.TentacleCount = self.vb.TentacleCount + 1
	specWarnThrashingTentacle:Show(self.vb.TentacleCount)
	specWarnThrashingTentacle:Play("watchstep")
	timerThrashingTentacleCD:Start(20, self.vb.TentacleCount+1)
	--LFR confirmed, mythic confirmed. heroic and normal iffy
	self:Schedule(self:IsLFR() and 28 or self:IsNormal() and 24 or 20, thrashingTentacleLoop, self)
end

local function phaseOneTentacleLoop(self)
	self.vb.TentacleCount = self.vb.TentacleCount + 1
	local timer = self:IsMythic() and 63.5 or self:IsHeroic() and 60 or self:IsNormal() and 74.9 or 85.6
	specWarnGrowthCoveredTentacle:Show(self.vb.TentacleCount)
	specWarnGrowthCoveredTentacle:Play("watchstep")
	timerGrowthCoveredTentacleCD:Start(timer, self.vb.TentacleCount+1)
	self:Schedule(timer, phaseOneTentacleLoop, self)
end

function mod:OnCombatStart(delay)
	self.vb.TentacleCount = 0
	self.vb.gazeCount = 0
	self.vb.DarknessCount = 0
	self:SetStage(1)
	self.vb.anchorCount = 0
	self.vb.adaptiveCount = 0
	self.vb.adaptiveIcon = 1
	self.vb.madnessBombCount = 0
	lastSanity = 100
	lastGazeTime = GetTime()
	table.wipe(debugSpawnTable)
	if self:IsMythic() then
		timerMentalDecayCD:Start(9.1-delay)--SUCCESS
		timerMandibleSlamCD:Start(9.3-delay)
		timerMadnessBombCD:Start(12.6-delay, 1)--SUCCESS
		timerAdaptiveMembraneCD:Start(18.1-delay, 1)--SUCCESS
		timerGrowthCoveredTentacleCD:Start(30-delay, 1)--30 til attackable, slam is like 3 sec sooner
		self:Schedule(30, phaseOneTentacleLoop, self)--Only started on mythic for now
		timerGazeofMadnessCD:Start(41.2-delay, 1)
		self:RegisterShortTermEvents(
			"UNIT_HEALTH boss1"
		)
	elseif self:IsHeroic() then--Heroic confirmed, mythic assumed
		timerMadnessBombCD:Start(5-delay, 1)--SUCCESS
		timerGazeofMadnessCD:Start(10-delay, 1)
		timerMentalDecayCD:Start(12-delay)--SUCCESS
		timerAdaptiveMembraneCD:Start(16-delay, 1)--SUCCESS
		timerMandibleSlamCD:Start(16-delay)
		timerGrowthCoveredTentacleCD:Start(30-delay, 1)
	elseif self:IsNormal() then--Normal confirmed, LFR assumed
		timerMadnessBombCD:Start(5.8-delay, 1)--SUCCESS
		--timerGazeofMadnessCD:Start(12.1-delay, 1)--Unknown, guessed by 0.82 adjustment
		timerMentalDecayCD:Start(14.8-delay)--SUCCESS 12.1?
		timerAdaptiveMembraneCD:Start(19.5-delay, 1)--SUCCESS
		timerMandibleSlamCD:Start(20-delay)
		timerGrowthCoveredTentacleCD:Start(37.5-delay, 1)--Confirmed via debug
	else--LFR
		timerMadnessBombCD:Start(6.3-delay, 1)--SUCCESS
		--timerGazeofMadnessCD:Start(13.7-delay, 1)--Not in LFR?
		timerMentalDecayCD:Start(16.7-delay)--SUCCESS 12.1?
		timerAdaptiveMembraneCD:Start(22-delay, 1)--SUCCESS
		timerMandibleSlamCD:Start(22.8-delay)
		timerGrowthCoveredTentacleCD:Start(43-delay, 1)--Confirmed via debug
	end
	berserkTimer:Start(self:IsEasy() and 840 or 780)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
		DBM.InfoFrame:Show(8, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
	end
	if self.Options.NPAuraOnMembrane2 then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.NPAuraOnMembrane2 then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
	if #debugSpawnTable > 0 then
		local message = table.concat(debugSpawnTable, ", ")
		DBM:AddMsg("Gaze Spawns collected. Please report these numbers and raid difficulty to DBM author: "..message)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 315820 then
		DBM:AddMsg("Blizzard Re-added tentacle spawn combat event. Tell DBM Author")
		--self.vb.TentacleCount = self.vb.TentacleCount + 1
		--specWarnThrashingTentacle:Show(self.vb.TentacleCount)
		--specWarnThrashingTentacle:Play("watchstep")--???
		--timerThrashingTentacleCD:Start()
	elseif spellId == 307809 then
		self.vb.DarknessCount = self.vb.DarknessCount + 1
		specWarnEternalDarkness:Show(self.vb.DarknessCount)
		specWarnEternalDarkness:Play("aesoon")
		local timer
		if self:IsMythic() then
			timer = 19.7--Mythic only Has it in stage 2 (there is no stage 2.5)
		elseif self:IsHeroic() then--(Heroic only has it in 2 and 2.5)
			timer = 22.2--Same in 2 and 2.5
		elseif self:IsNormal() then--(Not case in phase 1, just 3, 2.5, and 2)
			timer = (self.vb.phase == 3) and 67.4 or 25--Same in 2 and 2.5
		else--LFR (Not case in phase 1, just 3, 2.5, and 2)
			timer = (self.vb.phase == 3) and 77.1 or 28.5--Same in 2 and 2.5
		end
		timerEternalDarknessCD:Start(timer, self.vb.DarknessCount+1)
	elseif spellId == 313039 then
		self.vb.DarknessCount = self.vb.DarknessCount + 1
		specWarnInfiniteDarkness:Show(self.vb.DarknessCount)
		specWarnInfiniteDarkness:Play("aesoon")
		timerInfiniteDarknessCD:Start(52, self.vb.DarknessCount+1)--Heroic+ only
	elseif (spellId == 307092 or spellId == 315891) and args:GetSrcCreatureID() == 157439  then--Stage 2/Stage 3 (so we ignore 162285 casts)
		specWarnOccipitalBlast:Show()
		specWarnOccipitalBlast:Play("shockwave")
		timerOccipitalBlastCD:Start(self:IsHard() and 33.3 or self:IsNormal() and 37.5 or 42.8)
	elseif spellId == 315947 then
		--Not case in phase 2, just 1, 2.5, and 3
		local timer
		if self:IsMythic() then
			timer = (self.vb.phase == 3) and 14.7 or 15.7
		elseif self:IsHard() then
			timer = (self.vb.phase == 3) and 10.7 or (self.vb.phase == 2.5) and 22.2 or 12.7
		elseif self:IsNormal() then
			timer = (self.vb.phase == 3) and 13.7 or (self.vb.phase == 2.5) and 25 or 16.2
		else--LFR
			timer = (self.vb.phase == 3) and 15.6 or (self.vb.phase == 2.5) and 28.5 or 18.5
		end
		timerMandibleSlamCD:Start(timer)
	elseif spellId == 307064 then
		warnCystGenesis:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 313362 then
		--Requires antispam because sometimes boss double casts
		if args:GetSrcCreatureID() == 157439 and self:AntiSpam(5, 8) then--Fury of N'Zoth
			local timer
			if self:IsMythic() then
				timer = (self.vb.phase == 3) and 15.2 or (self.vb.phase == 2) and 18.4 or 20.8--Phase 3 not confirmed yet
			elseif self:IsHeroic() then
				timer = (self.vb.phase == 3) and 26.7 or (self.vb.phase == 2) and 20.2 or (self.vb.phase == 2.5) and 42.2 or 21
			elseif self:IsNormal() then
				timer = (self.vb.phase == 3) and 33.7 or (self.vb.phase == 2) and 22.6 or (self.vb.phase == 2.5) and 47.5 or 26.2
			else--LFR
				timer = (self.vb.phase == 3) and 38.5 or (self.vb.phase == 2) and 28.5 or (self.vb.phase == 2.5) and 54.2 or 29.9
			end
			timerMentalDecayCD:Start(timer)
		end
	elseif spellId == 306971 then
		self.vb.madnessBombCount = self.vb.madnessBombCount + 1
		local timer
		--Not case in phase 3, just 1, 2, and 2.5
		if self:IsMythic() then
			if self.vb.phase == 1 then
				timer = 24.7
			else--Phase 2
				if self.vb.madnessBombCount % 2 == 0 then
					timer = 10
				else
					timer = 4.3
				end
			end
		elseif self:IsHeroic() then
			timer = (self.vb.phase == 2.5) and 22.2 or (self.vb.phase == 2) and 32.1 or 24
		elseif self:IsNormal() then
			timer = (self.vb.phase == 2.5) and 24.9 or (self.vb.phase == 2) and 37.4 or 30
		else--LFR
			timer = (self.vb.phase == 2.5) and 28.5 or (self.vb.phase == 2) and 42.8 or 34.2
		end
		timerMadnessBombCD:Start(timer, self.vb.madnessBombCount+1)
	elseif spellId == 306986 then
		timerInsanityBombCD:Start(self:IsHard() and 66.9 or self:IsNormal() and 83.7 or 95.7)
	elseif spellId == 306988 and self:AntiSpam(3, 9) then
		self.vb.adaptiveCount = self.vb.adaptiveCount + 1
		self.vb.adaptiveIcon = 1
		--Yes this has 4 distinct timers. Verified in multiple logs that the second stage 2 in fact does have it's own CD
		local timer
		if self:IsMythic() then
			if self.vb.phase == 1 then
				if self.vb.adaptiveCount % 2 == 0 then
					timer = 21.7
				else
					timer = 10.3
				end
			elseif self.vb.phase == 2 then
				timer = 9.7
			else--Phase 3
				if self.vb.adaptiveCount % 2 == 0 then
					timer = 44
				else
					timer = 9.1--9.1-10
				end
			end
		elseif self:IsHeroic() then
			timer = (self.vb.phase == 3) and 32 or (self.vb.phase == 2) and 21.1 or (self.vb.phase == 2.5) and 33.3 or 27.6
		elseif self:IsNormal() then
			timer = (self.vb.phase == 3) and 40 or (self.vb.phase == 2) and 25 or (self.vb.phase == 2.5) and 37.4 or 36.2
		else--LFR
			timer = (self.vb.phase == 3) and 45.6 or (self.vb.phase == 2) and 28.5 or (self.vb.phase == 2.5) and 42.7 or 41.4
		end
		timerAdaptiveMembraneCD:Start(timer, self.vb.adaptiveCount+1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 313334 then
		if args:IsPlayer() then
			specWarnGiftofNzoth:Show()
			specWarnGiftofNzoth:Play("targetyou")
			timerGiftofNzoth:Start()
		else
			warnGiftofNzoth:CombinedShow(1, args.destName)
		end
	elseif spellId == 307832 then
		specWarnServantofNzoth:CombinedShow(1, args.destName)
		specWarnServantofNzoth:ScheduleVoice(1, "findmc")
		if args:IsPlayer() then
			yellServantofNzoth:Yell()
		end
	elseif spellId == 306973 then
		warnMadnessBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnMadnessBomb:Show()
			specWarnMadnessBomb:Play("runout")
			yellMadnessBomb:Yell()
			yellMadnessBombFades:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 306984 then
		warnInsanityBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnInsanityBomb:Show()
			specWarnInsanityBomb:Play("runout")
			yellInsanityBomb:Yell()
			yellInsanityBombFades:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 306990 or spellId == 316848 then
		warnAdaptiveMembrane:CombinedShow(0.3, args.destName)
		if args:GetDestCreatureID() == 157439 then
			timerAdaptiveMembrane:Start()
			if self.Options.InfoFrame then
				DBM.InfoFrame:SetHeader(args.spellName)
				DBM.InfoFrame:Show(2, "enemyabsorb", nil, args.amount, "boss1")
			end
		elseif args:IsDestTypePlayer() then
			if args:IsPlayer() then
				specWarnAdaptiveMembrane:Show()
				specWarnAdaptiveMembrane:Play("targetyou")
			end
			if self.Options.SetIconAdaptiveMembrane then
				self:SetIcon(args.destName, self.vb.adaptiveIcon)
			end
			self.vb.adaptiveIcon = self.vb.adaptiveIcon + 1
		end
		if self.Options.NPAuraOnMembrane2 and not args:IsDestTypePlayer() then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 12)
		end
	elseif spellId == 307079 and self.vb.phase < 2 then--Synthesis
		self:SetStage(2)
		self.vb.adaptiveCount = 0
		self.vb.madnessBombCount = 0
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
		warnPhase:Play("ptwo")
		timerMadnessBombCD:Stop()
		timerAdaptiveMembraneCD:Stop()
		timerMentalDecayCD:Stop()
		timerGrowthCoveredTentacleCD:Stop()
		timerGazeofMadnessCD:Stop()
		timerMandibleSlamCD:Stop()
		self:Unschedule(phaseOneTentacleLoop)
		self:UnregisterShortTermEvents()
		--Stopping timers here is accurate, but not starting them, those started at first anchor here cast
		if self:IsMythic() then
			--timerAdaptiveMembraneCD:Start(33.2, 1)--SUCCESS
			--timerEternalDarknessCD:Start(36.1)
			--timerMadnessBombCD:Start(41.2, 1)--SUCCESS
			--timerMentalDecayCD:Start(49.2)--SUCCESS
		elseif self:IsHeroic() then
			--Started here, but updated in Anchor Here cast
			timerMentalDecayCD:Start(17.2)--SUCCESS
			timerAdaptiveMembraneCD:Start(20.4, 1)--SUCCESS
			timerEternalDarknessCD:Start(24, 1)
			timerMadnessBombCD:Start(29.3, 1)--SUCCESS
		elseif self:IsNormal() then
			--TODO, Update these in Anchor here
			timerMentalDecayCD:Start(18.4)--SUCCESS
			timerAdaptiveMembraneCD:Start(21.9, 1)--SUCCESS
			timerEternalDarknessCD:Start(26.2, 1)
			timerMadnessBombCD:Start(32, 1)--SUCCESS
		else
			--TODO, Update these in Anchor here
			timerMentalDecayCD:Start(16.8)--SUCCESS
			timerAdaptiveMembraneCD:Start(20.6, 1)--SUCCESS
			timerEternalDarknessCD:Start(25.8, 1)
			timerMadnessBombCD:Start(32.1, 1)--SUCCESS
		end
	elseif spellId == 315954 then
		local amount = args.amount or 1
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnBlackScar:Show(amount)
				specWarnBlackScar:Play("stackhigh")
			else
				local _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
				local remaining
				if expireTime then
					remaining = expireTime-GetTime()
				end
				if not UnitIsDeadOrGhost("player") and (not remaining or remaining and remaining < 12.7) then
					specWarnBlackScarTaunt:Show(args.destName)
					specWarnBlackScarTaunt:Play("tauntboss")
				else
					warnBlackScar:Show(args.destName, amount)
				end
			end
		else
			warnBlackScar:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 313334 then
		if args:IsPlayer() then
			timerGiftofNzoth:Stop()
		end
	elseif spellId == 306973 then
		if args:IsPlayer() then
			yellMadnessBombFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 306984 then
		if args:IsPlayer() then
			yellInsanityBombFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 306990 or spellId == 316848 then
		if args:GetDestCreatureID() == 157439 then
			timerAdaptiveMembrane:Stop()
			if self.Options.InfoFrame then
				DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
				DBM.InfoFrame:Show(8, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
			end
		elseif args:IsDestTypePlayer() then
			if self.Options.SetIconAdaptiveMembrane then
				self:SetIcon(args.destName, 0)
			end
		end
		if self.Options.NPAuraOnMembrane2 and not args:IsDestTypePlayer() then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 307079 and self:IsMythic() then--Synthesis
		--Stop mythic P2 timers here at least
		timerMadnessBombCD:Stop()
		timerAdaptiveMembraneCD:Stop()
		timerEternalDarknessCD:Stop()
		timerMentalDecayCD:Stop()
		--Start timers for Phase 2.5 (or phase 3 mythic) are in anchor event.
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 307079 then
		local amount = args.amount or 0
		if (amount % 3 == 0) or amount < 4 then
			warnSynthesRemaining:Show(amount)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	--"<23.58 17:24:45> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\INV_EyeofNzothPet.blp:20|t A %s emerges!#Gaze of Madness#####0#0##0#1983#nil#0#false#false#false#false", -- [566]
	if msg:find("INV_EyeofNzothPet.blp") then
		self.vb.gazeCount = self.vb.gazeCount + 1
		specWarnGazeOfMadness:Show(self.vb.gazeCount)
		specWarnGazeOfMadness:Play("killmob")
		if self:IsHard() then
			timerGazeofMadnessCD:Start(self:IsMythic() and 65 or self:IsHeroic() and 58, self.vb.gazeCount+1)
		else
			local currentTime = GetTime() - lastGazeTime
			debugSpawnTable[#debugSpawnTable + 1] = math.floor(currentTime*10)/10--Floored but only after trying to preserve at least one decimal place
			lastGazeTime = GetTime()
		end
	--"<48.92 17:25:10> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\INV_MISC_MONSTERHORN_04.BLP:20|t A %s emerges. Look out!#Growth-Covered Tentacle#####0#0##0#1990#nil#0#false#false#false#false",
	elseif msg:find("INV_MISC_MONSTERHORN_04.BLP") and not self:IsMythic() then
		self.vb.TentacleCount = self.vb.TentacleCount + 1
		specWarnGrowthCoveredTentacle:Show(self.vb.TentacleCount)
		specWarnGrowthCoveredTentacle:Play("watchstep")
		timerGrowthCoveredTentacleCD:Start(self:IsMythic() and 63.5 or self:IsHeroic() and 60 or self:IsNormal() and 74.9 or 85.6, self.vb.TentacleCount+1)
	end
end

--"<415.03 15:50:30> [CLEU] SPELL_AURA_APPLIED#Player-3685-0A675506#Hulahoops-Turalyon#Player-3685-0A675506#Hulahoops-Turalyon#318108#Boon of the Black Prince#BUFF#nil", -- [17297]
--"<415.38 15:50:30> [CHAT_MSG_MONSTER_YELL] I dare not enter that foul place, lest I lose myself to his madness. Strike him down!#Wrathion###Siory##0#0##0#1325#nil#0#false#false#false#false", -- [17314]
--"<423.12 15:50:38> [UNIT_SPELLCAST_SUCCEEDED] Fury of N'Zoth(??) -Anchor Here- [[boss1:Cast-3-3886-2217-7151-45313-0017A8B59E:45313]]", -- [17461]
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 315673 then--Thrashing Tentacle
		--timerThrashingTentacleCD:Start()--27.8
	elseif spellId == 45313 then--Anchor Here
		self.vb.anchorCount = self.vb.anchorCount + 1
		--Initial timers on most difficulties start on Synthesis, but get updated here since synthesis accuracy isn't great
		--(the variation for how long it takes boss to get into position and cast anchor here)
		if self.vb.anchorCount == 1 then
			if self:IsMythic() then
				timerAdaptiveMembraneCD:Start(17, 1)--SUCCESS
				timerEternalDarknessCD:Start(20, 1)
				timerMadnessBombCD:Start(25, 1)--SUCCESS
				timerMentalDecayCD:Start(33)--SUCCESS
			elseif self:IsHeroic() then
				timerMentalDecayCD:Update(16.2, 17.2)--SUCCESS
				timerAdaptiveMembraneCD:Update(16.2, 20.4, 1)--SUCCESS
				timerEternalDarknessCD:Update(16.2, 24, 1)
				timerMadnessBombCD:Update(16.2, 29.3, 1)--SUCCESS

				--timerMentalDecayCD:Start(1)--SUCCESS
				--timerAdaptiveMembraneCD:Start(4.2, 1)--SUCCESS
				--timerEternalDarknessCD:Start(7.8)
				--timerMadnessBombCD:Start(13.1, 1)--SUCCESS
			elseif self:IsNormal() then
				--timerMentalDecayCD:Start(1)--SUCCESS
				--timerAdaptiveMembraneCD:Start(4.2, 1)--SUCCESS
				--timerEternalDarknessCD:Start(7.8)
				--timerMadnessBombCD:Start(13.1, 1)--SUCCESS
			else--LFR
				--timerMentalDecayCD:Start(1)--SUCCESS
				--timerAdaptiveMembraneCD:Start(4.2, 1)--SUCCESS
				--timerEternalDarknessCD:Start(7.8)
				--timerMadnessBombCD:Start(13.1, 1)--SUCCESS
			end
		elseif (self.vb.anchorCount == 2 and self:IsMythic()) or self.vb.anchorCount == 3 then
			--Boon of Black Prince can be used as a backup but it's NOT as consistent and introduces a 3 second variation to elements. Should only be used if this can't be
			--It may be wise to move timer canceling for phase 2/2.5 to boon but timer starting stay at anchor event
			self:SetStage(3)
			self.vb.adaptiveCount = 0
			self.vb.TentacleCount = 0
			self.vb.DarknessCount = 0
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
			warnPhase:Play("pthree")
			timerMentalDecayCD:Stop()
			timerAdaptiveMembraneCD:Stop()
			timerEternalDarknessCD:Stop()
			timerMadnessBombCD:Stop()
			timerOccipitalBlastCD:Stop()
			timerMandibleSlamCD:Stop()
			if self:IsMythic() then
				timerMandibleSlamCD:Start(15.1)
				timerInfiniteDarknessCD:Start(16.1, 1)
				timerAdaptiveMembraneCD:Start(20.6, 1)--SUCCESS
				timerInsanityBombCD:Start(36.6)--SUCCESS
				timerMentalDecayCD:Start(44.1)--SUCCESS
				timerThrashingTentacleCD:Start(20, 1)--Confirmed from twitch vods
				self:Schedule(20, thrashingTentacleLoop, self)
			elseif self:IsHeroic() then
				timerMentalDecayCD:Start(12.1)--SUCCESS
				timerMandibleSlamCD:Start(17.1)
				timerInsanityBombCD:Start(21.6)--SUCCESS
				timerThrashingTentacleCD:Start(32, 1)--Confirmed from https://www.twitch.tv/videos/541753121 from 00:54:06 onward
				self:Schedule(32, thrashingTentacleLoop, self)
				timerAdaptiveMembraneCD:Start(38.1, 1)--SUCCESS
				timerInfiniteDarknessCD:Start(54, 1)
			elseif self:IsNormal() then
				--These are probably off by 1-3 seconds, it's impossible to perfect this, even using boon, without transcriptor log to capture anchor here event
				timerMentalDecayCD:Start(14.5)--SUCCESS
				timerMandibleSlamCD:Start(20.9)
				timerInsanityBombCD:Start(26.1)--SUCCESS
				timerThrashingTentacleCD:Start(39, 1)--Probably wrong (Guessed by 0.82 calculation from heroic)
				self:Schedule(39, thrashingTentacleLoop, self)--Probably wrong
				timerAdaptiveMembraneCD:Start(46.6, 1)--SUCCESS
				timerEternalDarknessCD:Start(67, 1)
			else--LFR
				--These are probably off by 1-3 seconds, it's impossible to perfect this, even using boon, without transcriptor log to capture anchor here event
				timerMentalDecayCD:Start(14.3)--SUCCESS
				timerMandibleSlamCD:Start(21.8)
				timerInsanityBombCD:Start(27.6)--SUCCESS
				timerThrashingTentacleCD:Start(43, 1)
				self:Schedule(43, thrashingTentacleLoop, self)
				timerAdaptiveMembraneCD:Start(51, 1)--SUCCESS
				timerEternalDarknessCD:Start(74.7, 1)
			end
		else
			--he hangs around in tunnel for 10%
			self:SetStage(2.5)
			self.vb.adaptiveCount = 0
			self.vb.madnessBombCount = 0
			warnSynthesisOver:Show()
			timerMadnessBombCD:Stop()
			timerAdaptiveMembraneCD:Stop()
			timerEternalDarknessCD:Stop()
			timerMentalDecayCD:Stop()
			if self:IsHeroic() then
				timerOccipitalBlastCD:Start(5)
				timerMadnessBombCD:Start(13.1, 1)--SUCCESS
				timerMandibleSlamCD:Start(15.5)
				timerAdaptiveMembraneCD:Start(18.7, 1)--SUCCESS
				timerEternalDarknessCD:Start(22.3, self.vb.DarknessCount+1)
				timerMentalDecayCD:Start(28.7)--SUCCESS
			elseif self:IsNormal() then--(timers need actual transcriptor log to verify, created by energy calculation of 0.82 from heroic)
				timerOccipitalBlastCD:Start(6.2)
				timerMadnessBombCD:Start(14.6, 1)--SUCCESS
				timerMandibleSlamCD:Start(17.5)
				timerAdaptiveMembraneCD:Start(20.8, 1)--SUCCESS
				timerEternalDarknessCD:Start(25, self.vb.DarknessCount+1)
				timerMentalDecayCD:Start(32.3)--SUCCESS
			else--LFR (timers need actual transcriptor log to verify, created by energy calculation of 0.88 from normal)
				timerOccipitalBlastCD:Start(7)
				timerMadnessBombCD:Start(16.6, 1)--SUCCESS
				timerMandibleSlamCD:Start(19.9)
				timerAdaptiveMembraneCD:Start(23.7, 1)--SUCCESS
				timerEternalDarknessCD:Start(28.5, self.vb.DarknessCount+1)
				timerMentalDecayCD:Start(36.8)--SUCCESS
			end
		end
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	local currentSanity = UnitPower(uId, ALTERNATE_POWER_INDEX)
	if currentSanity > lastSanity then
		lastSanity = currentSanity
		return
	end
	if self:AntiSpam(5, 6) then--Additional throttle in case you lose sanity VERY rapidly with increased ICD for special warning
		if currentSanity == 15 and lastSanity > 15 then
			lastSanity = 15
			specwarnWillPower:Show(lastSanity)
			specwarnWillPower:Play("lowsanity")
		elseif currentSanity == 30 and lastSanity > 30 then
			lastSanity = 30
			specwarnWillPower:Show(lastSanity)
			specwarnWillPower:Play("lowsanity")
		end
	elseif self:AntiSpam(3, 7) then--Additional throttle in case you lose sanity VERY rapidly
		if currentSanity == 45 and lastSanity > 45 then
			lastSanity = 45
			warnWillPower:Show(lastSanity)
		elseif currentSanity == 60 and lastSanity > 60 then
			lastSanity = 60
			warnWillPower:Show(lastSanity)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	local hp = UnitHealth(uId) / UnitHealthMax(uId)
	if hp < 0.56 then
		self:Unschedule(phaseOneTentacleLoop)
		timerGrowthCoveredTentacleCD:Stop()
		self:UnregisterShortTermEvents()
	end
end

local mod	= DBM:NewMod(1737, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220201235234")
mod:SetCreatureID(104154)--The Demon Within (111022)
mod:SetEncounterID(1866)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6)
mod:SetHotfixNoticeRev(16172)
mod.respawnTime = 29

mod:RegisterCombat("combat")
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 206219 206220 206514 206675 206840 207938 104534 208545 209270 211152 208672 206744 206883 206221 206222 221783 211439 220957 227008 221408 221486",
	"SPELL_CAST_SUCCESS 206222 206221 221783 212258 227008 221336 221486",
	"SPELL_AURA_APPLIED 206219 206220 209011 206354 206384 209086 208903 211162 221891 208802 221606 221603 221785 221784 212686 227427 206516 206847 206983 206458 227009 206310",
	"SPELL_AURA_APPLIED_DOSE 211162 208802",
	"SPELL_AURA_REMOVED 209011 206354 206384 209086 221603 221785 221784 212686 221606 206847 206458 206310",
--	"SPELL_DAMAGE",
--	"SPELL_MISSED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

--[[
(ability.id = 206219 or ability.id = 206220 or ability.id = 206514 or ability.id = 206675 or ability.id = 206840 or ability.id = 207938 or ability.id = 206883 or ability.id = 208545 or ability.id = 209270 or ability.id = 211152 or ability.id = 208672 or ability.id = 167819 or ability.id = 206939 or ability.id = 206744) and type = "begincast"
or (ability.id = 206222 or ability.id = 206221 or ability.id = 221783 or ability.id = 212258) and type = "cast"
or (ability.id = 227427 or ability.id = 206516) and type = "applybuff"
or (ability.id = 227427 or ability.id = 206516) and type = "removebuff"
--]]

local Kurazmal = DBM:EJ_GetSectionInfo(13121)
local Vethriz = DBM:EJ_GetSectionInfo(13124)
local Dzorykx = DBM:EJ_GetSectionInfo(13129)

--Stage One: The Council of Elders
----Gul'dan
local warnLiquidHellfire			= mod:NewCastAnnounce(206219, 3)
----Inquisitor Vethriz
local warnGazeofVethriz				= mod:NewSpellAnnounce(206840, 3)
local warnShadowblink				= mod:NewSpellAnnounce(207938, 2)
----D'zorykx the Trapper
local warnSoulVortex				= mod:NewTargetAnnounce(206883, 3)
local warnAnguishedSpirits			= mod:NewSpellAnnounce(208545, 2)
--Stage Two: The Ritual of Aman'thul
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnBondsofFel				= mod:NewTargetAnnounce(206222, 3)
local warnEmpBondsofFel				= mod:NewTargetAnnounce(209086, 4)
--Stage Three: The Master's Power
local warnPhase3Soon				= mod:NewPrePhaseAnnounce(3, 2)
local warnPhase3					= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)
local warnSoulSiphon				= mod:NewTargetAnnounce(221891, 3, nil, "Healer")
local warnFlamesofSargeras			= mod:NewTargetAnnounce(221606, 4)
--Mythic Only
local warnParasiticWound			= mod:NewTargetAnnounce(206847, 3)
local warnShadowyGaze				= mod:NewTargetAnnounce(206983, 3)
local warnWounded					= mod:NewSpellAnnounce(227009, 1)

--Stage One: The Council of Elders
----Gul'dan
local specWarnLiquidHellfire		= mod:NewSpecialWarningDodge(206219, nil, nil, nil, 1, 2)
local specWarnFelEfflux				= mod:NewSpecialWarningDodge(206514, nil, nil, nil, 1, 12)
----Fel Lord Kuraz'mal
local specWarnShatterEssence		= mod:NewSpecialWarningDefensive(206675, nil, nil, nil, 3, 2)
local specWarnFelObelisk			= mod:NewSpecialWarningDodge(229945, nil, nil, nil, 1, 2)
----D'zorykx the Trapper
local specWarnSoulVortex			= mod:NewSpecialWarningSpell(206883, nil, nil, nil, 2, 2)
local yellSoulVortex				= mod:NewYell(206883)
--Stage Two: The Ritual of Aman'thul
local specWarnBondsofFel			= mod:NewSpecialWarningYou(206222, nil, nil, nil, 1, 2)
local specWarnBondsofFelTank		= mod:NewSpecialWarningTaunt(206222, nil, nil, nil, 1, 2)
local yellBondsofFel				= mod:NewPosYell(206222)
local specWarnHandofGuldan			= mod:NewSpecialWarningSwitch(212258, "-Healer", nil, nil, 1, 2)
local specWarnEyeofGuldan			= mod:NewSpecialWarningSwitchCount(209270, "Dps", nil, nil, 1, 2)
local specWarnCarrionWave			= mod:NewSpecialWarningInterrupt(208672, "HasInterrupt", nil, nil, 1, 2)
--Stage Three: The Master's Power
local specWarnStormOfDestroyer		= mod:NewSpecialWarningDodge(161121, nil, nil, nil, 2, 2)
local specWarnSoulCorrosion			= mod:NewSpecialWarningStack(208802, nil, 5, nil, nil, 1, 6)--stack guessed
local specWarnBlackHarvest			= mod:NewSpecialWarningCount(206744, nil, nil, nil, 2, 2)
local specWarnFlamesOfSargeras		= mod:NewSpecialWarningMoveAway(221606, nil, nil, nil, 3, 2)
local yellFlamesofSargeras			= mod:NewPosYell(221606, 15643)
local specWarnFlamesOfSargerasTank	= mod:NewSpecialWarningTaunt(221606, nil, nil, nil, 1, 2)
--Mythic Only
local specWarnWilloftheDemonWithin	= mod:NewSpecialWarningSpell(211439, nil, nil, nil, 1, 2)
local specWarnParasiticWound		= mod:NewSpecialWarningMoveAway(206847, nil, nil, nil, 3, 2)
local yellParasiticWound			= mod:NewYell(206847, 36469)
local yellParasiticWoundFades		= mod:NewFadesYell(206847, 36469)
--local specWarnShearedSoul			= mod:NewSpecialWarningYou(206458, nil, nil, nil, 1)
local specWarnSoulsever				= mod:NewSpecialWarningCount(220957, nil, nil, nil, 3, 2)--Needs voice, but what?
local specWarnVisionsofDarkTitan	= mod:NewSpecialWarningMoveTo(227008, nil, nil, nil, 3, 7)
local specWarnSummonNightorb		= mod:NewSpecialWarningCount(227283, "Dps", nil, nil, 1, 2)
--Shard
local specWarnManifestAzzinoth		= mod:NewSpecialWarningSwitchCount(221149, "-Healer", nil, nil, 1, 2)
local specWarnBulwarkofAzzinoth		= mod:NewSpecialWarningSpell(221408, nil, nil, nil, 1)--Needs voice, but what?
local specWarnPurifiedEssence		= mod:NewSpecialWarningMoveTo(221486, nil, nil, nil, 3, 7)

--Stage One: The Council of Elders
----Gul'dan
local timerRP						= mod:NewRPTimer(78)
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerLiquidHellfireCD			= mod:NewNextCountTimer(25, 206219, nil, nil, nil, 3)
local timerFelEffluxCD				= mod:NewCDCountTimer(10.7, 206514, nil, nil, nil, 3)--10.7-13.5 (14-15 on normal)
----Fel Lord Kuraz'mal
mod:AddTimerLine(Kurazmal)
local timerFelLordKurazCD			= mod:NewCastTimer(16, "ej13121", nil, nil, nil, 1, 212258, nil, nil, mod:IsTank() and 2, 4)
local timerShatterEssenceCD			= mod:NewCDTimer(54, 206675, nil, "Tank", nil, 5, nil, DBM_COMMON_L.DEADLY_ICON..DBM_COMMON_L.TANK_ICON)
local timerFelObeliskCD				= mod:NewCDTimer(16, 206841, nil, nil, nil, 3)
----Inquisitor Vethriz
mod:AddTimerLine(Vethriz)
local timerVethrizCD				= mod:NewCastTimer(25, "ej13124", nil, nil, nil, 1, 212258, nil, nil, mod:IsTank() and 2, 4)
local timerGazeofVethrizCD			= mod:NewCDTimer(4.7, 206840, nil, nil, nil, 3)
----D'zorykx the Trapper
mod:AddTimerLine(Dzorykx)
local timerDzorykxCD				= mod:NewCastTimer(35, "ej13129", nil, nil, nil, 1, 212258, nil, nil, mod:IsTank() and 2, 4)
local timerSoulVortexCD				= mod:NewCDTimer(21, 206883, nil, nil, nil, 3)--34-36
--Stage Two: The Ritual of Aman'thul
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerTransition				= mod:NewPhaseTimer(19)
local timerHandofGuldanCD			= mod:NewNextCountTimer(58.5, 212258, nil, nil, nil, 1, nil, nil, nil, mod:IsTank() and 2, 4)
local timerBondsofFelCD				= mod:NewNextCountTimer(50, 206222, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerEyeofGuldanCD			= mod:NewNextCountTimer(60, 209270, nil, nil, nil, 1, nil, nil, nil, not mod:IsTank() and 2, 4)
--Stage Three: The Master's Power
mod:AddTimerLine(SCENARIO_STAGE:format(3))
local timerFlamesofSargerasCD		= mod:NewNextCountTimer("d58.5", 221783, 15643, nil, nil, 3)
local timerStormOfDestroyerCD		= mod:NewNextCountTimer(16, 161121, 196871, nil, nil, 3)
local timerWellOfSouls				= mod:NewCastTimer(16, 206939, nil, nil, nil, 5)
local timerBlackHarvestCD			= mod:NewNextCountTimer(83, 206744, nil, nil, nil, 2, nil, nil, nil, 3, 4)
--Mythic Only
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerWindsCD					= mod:NewCDCountTimer(39, 199446, nil, nil, nil, 2)
local timerWilloftheDemonWithin		= mod:NewCastTimer(43, 211439, nil, nil, nil, 2)
local timerParasiticWoundCD			= mod:NewCDTimer(36, 206847, nil, nil, nil, 3)
local timerWounded					= mod:NewBuffActiveTimer(36, 227009, nil, nil, nil, 6)
local timerSoulSeverCD				= mod:NewCDCountTimer(36, 220957, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, mod:IsTank() and 2, 6)
local timerVisionsofDarkTitan		= mod:NewCastTimer(9, 227008, nil, nil, nil, 2)
local timerVisionsofDarkTitanCD		= mod:NewCDCountTimer(9, 227008, nil, nil, nil, 2, nil, nil, nil, 1, 6)
local timerFlameCrashCD				= mod:NewCDCountTimer(20, 227071, nil, nil, nil, 3, nil, nil, nil, mod:IsTank() and 3, 6)
local timerSummonNightorbCD			= mod:NewCDCountTimer(10.9, 227283, nil, nil, nil, 1, 225133)
--Shard
mod:AddTimerLine(DBM_COMMON_L.ADDS)
local timerManifestAzzinothCD		= mod:NewCDCountTimer(10.9, 221149, nil, nil, nil, 1, 236237)
local timerChaosSeedCD				= mod:NewCDTimer(10.9, 221336, nil, nil, nil, 3)
local timerBulwarkofAzzinothCD		= mod:NewCDTimer(10.9, 221408, nil, nil, nil, 6)
local timerPurifiedEssence			= mod:NewCastTimer(4, 221486, nil, nil, nil, 2)

mod:AddRangeFrameOption(8, 221606)
mod:AddSetIconOption("SetIconOnBondsOfFlames", 221783, true)
mod:AddSetIconOption("SetIconOnBondsOfFel", 206222, true)
mod:AddInfoFrameOption(206310)

mod.vb.phase = 1
mod.vb.addsDied = 0
mod.vb.liquidHellfireCast = 0
mod.vb.felEffluxCast = 0
mod.vb.handofGuldanCast = 0
mod.vb.stormCast = 0
mod.vb.blackHarvestCast = 0
mod.vb.eyeCast = 0
mod.vb.flamesSargCast = 0
mod.vb.flamesTargets = 0
mod.vb.bondsofFelCast = 0
--Mythic only Phase
mod.vb.obeliskCastCount = 0
mod.vb.severCastCount = 0
mod.vb.crashCastCount = 0
mod.vb.orbCastCount = 0
mod.vb.visionCastCount = 0
mod.vb.azzCount = 0
--Mythic only Phase end
local felEffluxTimers = {11.0, 14.0, 18.5, 12.0, 12.2, 12.0}
local felEffluxTimersEasy = {11.0, 14.0, 19.9, 15.6, 16.8, 15.9, 15.8}
local handofGuldanTimers = {14.5, 48.9, 138.8}
--local mythicHandofGuldanTimers = {17, 165, 0, 0, 0}
local stormTimersEasy = {94, 78.6, 70.0, 87}
local stormTimers = {84.1, 68.7, 61.3, 76.5}
local stormTimersMythic = {72.6, 57.9, 51.6, 64.7, 57.4}--Credit to JustWait
local blackHarvestTimersEasy = {63, 82.9, 100.0}
local blackHarvestTimers = {64.1, 72.5, 87.5}
local blackHarvestTimersMythic = {55.7, 61.0, 75.3, 86.8}--Credit to JustWait
--local phase2Eyes = {29, 53.3, 53.4, 53.3, 53.3, 53.3, 66}--Not used, not needed if only 1 is different. need longer pulls to see what happens after 66
--local p1EyesMythic = {26, 48, 48}
local p3EmpoweredEyeTimersEasy = {42.5, 71.5, 71.4, 28.6, 114}--114 is guessed on the 1/8th formula
local p3EmpoweredEyeTimers = {39.1, 62.5, 62.5, 25, 100}--100 is confirmed
local p3EmpoweredEyeTimersMythic = {35.1, 52.6, 53.3, 20.4, 84.2, 52.6}--Credit to JustWait
local bondsIcons = {}
local flamesIcons = {}
local timeStopBuff, parasiteName = DBM:GetSpellInfo(206310), DBM:GetSpellInfo(206847)

local function upValueCapsAreStupid(self)
	self.vb.phase = 3
	timerWindsCD:Stop()
	self:SetBossHPInfoToHighest()
	specWarnWilloftheDemonWithin:Show()
	specWarnWilloftheDemonWithin:Play("carefly")
	timerWilloftheDemonWithin:Update(39, 43)
	self.vb.severCastCount = 0
	self.vb.crashCastCount = 0
	self.vb.orbCastCount = 0
	self.vb.visionCastCount = 0
	self.vb.azzCount = 0
	timerParasiticWoundCD:Start(8.3)
	timerSoulSeverCD:Start(19.3, 1)
	timerManifestAzzinothCD:Start(26.3, 1)
	timerFlameCrashCD:Start(29.3, 1)
	timerSummonNightorbCD:Start(39.3, 1)
	timerVisionsofDarkTitanCD:Start(95.1, 1)
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.addsDied = 0
	self.vb.liquidHellfireCast = 0
	self.vb.felEffluxCast = 0
	self.vb.handofGuldanCast = 0
	self.vb.stormCast = 0
	self.vb.blackHarvestCast = 0
	self.vb.eyeCast = 0
	self.vb.flamesSargCast = 0
	self.vb.flamesTargets = 0
	self.vb.bondsofFelCast = 0
	self.vb.obeliskCastCount = 0
	table.wipe(bondsIcons)
	table.wipe(flamesIcons)
	if self:IsMythic() then
		self:SetCreatureID(104154, 111022)
		timerBondsofFelCD:Start(self:IsTank() and 6.4 or 8.4, 1)
		timerDzorykxCD:Start(17-delay)
		timerEyeofGuldanCD:Start(26.1-delay, 1)
		timerLiquidHellfireCD:Start(36-delay, 1)
	else
		self:SetCreatureID(104154)
		timerLiquidHellfireCD:Start(2-delay, 1)
		timerFelEffluxCD:Start(11-delay, 1)
		timerFelLordKurazCD:Start(11-delay)
		timerVethrizCD:Start(25-delay)
		timerDzorykxCD:Start(35-delay)
		self:SetCreatureID(104154)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:OnTimerRecovery()
	if self:IsMythic() then
		self:SetCreatureID(104154, 111022)
	else
		self:SetCreatureID(104154)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 206219 or spellId == 206220 then
		self.vb.liquidHellfireCast = self.vb.liquidHellfireCast + 1
		specWarnLiquidHellfire:Show()
		specWarnLiquidHellfire:Play("watchstep")
		if self:IsMythic() or self.vb.phase >= 2 then
			local longTimer, shortTimer, mediumTimer
			if self:IsMythic() then
				longTimer, shortTimer, mediumTimer = 66, 28.9, 33
			elseif self:IsHeroic() then
				longTimer, shortTimer, mediumTimer = 74, 31.6, 36
			elseif self:IsNormal() then--Normal
				longTimer, shortTimer, mediumTimer = 84, 36, 41
			else
				longTimer, shortTimer, mediumTimer = 88, 38.6, 44
			end
			if self.vb.liquidHellfireCast == 4 or self.vb.liquidHellfireCast == 6 then
				timerLiquidHellfireCD:Start(longTimer, self.vb.liquidHellfireCast+1)
			elseif self.vb.liquidHellfireCast == 7 then--TODO, if a longer phase 2 than 7 casts, and continue to see diff timers than 36, build a table
				timerLiquidHellfireCD:Start(shortTimer, self.vb.liquidHellfireCast+1)
			else
				timerLiquidHellfireCD:Start(mediumTimer, self.vb.liquidHellfireCast+1)
			end
		elseif self.vb.phase == 1.5 then
			if self.vb.liquidHellfireCast == 2 or self:IsHeroic() then
				timerLiquidHellfireCD:Start(23.8, self.vb.liquidHellfireCast+1)
			else--On LFR/Normal the rest are 32 in phase 1.5
				timerLiquidHellfireCD:Start(32.5, self.vb.liquidHellfireCast+1)
			end
		else--Phase 1
			timerLiquidHellfireCD:Start(15, self.vb.liquidHellfireCast+1)
		end
	elseif spellId == 206514 then
		self.vb.felEffluxCast = self.vb.felEffluxCast + 1
		specWarnFelEfflux:Show()
		specWarnFelEfflux:Play("flamejet")
		local timer = self:IsEasy() and felEffluxTimersEasy[self.vb.felEffluxCast+1] or felEffluxTimers[self.vb.felEffluxCast+1] or 12
		timerFelEffluxCD:Start(timer, self.vb.felEffluxCast+1)
	elseif spellId == 206675 then
		if self:IsMythic() then
			timerShatterEssenceCD:Start(21)
		else
			timerShatterEssenceCD:Start()
		end
		local targetName, uId, bossuid = self:GetBossTarget(104537)--Add true if it has a boss unitID
		if self:IsTanking("player", bossuid, nil, true) then--Player is current target
			specWarnShatterEssence:Show()
			specWarnShatterEssence:Play("defensive")
		end
	elseif spellId == 206840 then
		warnGazeofVethriz:Show()
		timerGazeofVethrizCD:Start()
	elseif spellId == 207938 then
		warnShadowblink:Show()
		--timerShadowBlinkCD:Start()
	elseif spellId == 206883 then
		if self:IsMythic() then--On mythic it's just tossed into center of room, not at tank
			specWarnSoulVortex:Show()
			specWarnSoulVortex:Play("watchstep")
			timerSoulVortexCD:Start(21)
		else
			local targetName, uId, bossuid = self:GetBossTarget(104534, true)
			if self:IsTanking("player", bossuid, nil, true) then--Player is current target
				specWarnSoulVortex:Show()
				specWarnSoulVortex:Play("runout")
				yellSoulVortex:Yell()
			elseif targetName then
				warnSoulVortex:Show(targetName)
			end
		end
	elseif spellId == 208545 then
		warnAnguishedSpirits:Show()
	elseif spellId == 209270 or spellId == 211152 then
		self.vb.eyeCast = self.vb.eyeCast + 1
		specWarnEyeofGuldan:Show(self.vb.eyeCast)
		specWarnEyeofGuldan:Play("killmob")
		if self:IsMythic() and self.vb.phase == 2 or self.vb.phase == 3 then
			local timer = self:IsMythic() and p3EmpoweredEyeTimersMythic[self.vb.eyeCast+1] or self:IsEasy() and p3EmpoweredEyeTimersEasy[self.vb.eyeCast+1] or p3EmpoweredEyeTimers[self.vb.eyeCast+1]
			if timer then
				timerEyeofGuldanCD:Start(timer, self.vb.eyeCast+1)
			end
		else
			local longTimer, shortTimer
			if self:IsMythic() then
				longTimer, shortTimer = 80, 48
			elseif self:IsHeroic() then
				longTimer, shortTimer = 66, 53
			elseif self:IsNormal() then--Normal
				longTimer, shortTimer = 75, 60
			else--LFR
				longTimer, shortTimer = 80, 64
			end
			if self.vb.eyeCast == 6 then
				timerEyeofGuldanCD:Start(longTimer, self.vb.eyeCast+1)--An oddball cast
			else
				timerEyeofGuldanCD:Start(shortTimer, self.vb.eyeCast+1)
			end
		end
	elseif spellId == 208672 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnCarrionWave:Show(args.sourceName)
			specWarnCarrionWave:Play("kickcast")
		end
	elseif spellId == 206744 then
		self.vb.blackHarvestCast = self.vb.blackHarvestCast + 1
		specWarnBlackHarvest:Show(self.vb.blackHarvestCast)
		specWarnBlackHarvest:Play("aesoon")
		local timer = self:IsMythic() and blackHarvestTimersMythic[self.vb.blackHarvestCast+1] or self:IsEasy() and blackHarvestTimersEasy[self.vb.blackHarvestCast+1] or blackHarvestTimers[self.vb.blackHarvestCast+1]
		if timer then
			timerBlackHarvestCD:Start(timer, self.vb.blackHarvestCast+1)
		end
		if self:IsMythic() then
			if self.vb.blackHarvestCast == 2 then
				timerWindsCD:Start(67, 3)
			elseif self.vb.blackHarvestCast == 3 then
				timerWindsCD:Start(75, 4)
			end
		end
	elseif spellId == 206222 or spellId == 206221 then
		table.wipe(bondsIcons)
		if self:IsTanking("player", "boss1", nil, true) then
			if spellId == 206221 then
				specWarnBondsofFel:Play("carefly")
			end
		else
			local targetName = UnitName("boss1target") or DBM_COMMON_L.UNKNOWN
			if not UnitIsUnit("player", "boss1target") then--the very first bonds of fel, threat is broken and not available yet, so we need an additional filter
				if self:AntiSpam(5, targetName) then
					specWarnBondsofFelTank:Show(targetName)
					specWarnBondsofFelTank:Play("tauntboss")
				end
			end
		end
	elseif spellId == 221783 then
		table.wipe(flamesIcons)
		self.vb.flamesTargets = 0
	--Begin Mythic Only Stuff
	elseif spellId == 211439 then--Will of the Demon Within
		upValueCapsAreStupid(self)
	elseif spellId == 220957 then
		self.vb.severCastCount = self.vb.severCastCount + 1
		local _, _, bossuid = self:GetBossTarget(111022, true)
		if self:IsTanking("player", bossuid, nil, true) then
			specWarnSoulsever:Show(self.vb.severCastCount)
			specWarnSoulsever:Play("defensive")
		end
		if self.vb.severCastCount == 4 or self.vb.severCastCount == 7 then
			timerSoulSeverCD:Start(50, self.vb.severCastCount+1)
		else
			timerSoulSeverCD:Start(20, self.vb.severCastCount+1)
		end
	elseif spellId == 227008 then
		self.vb.visionCastCount = self.vb.visionCastCount+1
		specWarnVisionsofDarkTitan:Show(timeStopBuff)
		specWarnVisionsofDarkTitan:Play("movetimebubble")
		timerVisionsofDarkTitan:Start()
		if self.vb.visionCastCount ~= 3 then
			if self.vb.visionCastCount == 2 then
				timerVisionsofDarkTitanCD:Start(150)
			else
				timerVisionsofDarkTitanCD:Start(90)
			end
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(DBM_COMMON_L.NO_DEBUFF:format(timeStopBuff))
			DBM.InfoFrame:Show(10, "playergooddebuff", timeStopBuff)
		end
	elseif spellId == 221408 then
		specWarnBulwarkofAzzinoth:Show()
	elseif spellId == 221486 and self:AntiSpam(5, 4) then
		specWarnPurifiedEssence:Show(timeStopBuff)
		specWarnPurifiedEssence:Play("movetimebubble")
		timerPurifiedEssence:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(DBM_COMMON_L.NO_DEBUFF:format(timeStopBuff))
			DBM.InfoFrame:Show(10, "playergooddebuff", timeStopBuff)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 206222 or spellId == 206221 then
		self.vb.bondsofFelCast = self.vb.bondsofFelCast + 1
		if self:IsMythic() then
			local timer = self:IsTank() and 38 or 40
			timerBondsofFelCD:Start(timer, self.vb.bondsofFelCast+1)
		elseif self:IsHeroic() then
			local timer = self:IsTank() and 42.4 or 44.4
			timerBondsofFelCD:Start(timer, self.vb.bondsofFelCast+1)
		elseif self:IsNormal() then
			local timer = self:IsTank() and 48 or 50
			timerBondsofFelCD:Start(timer, self.vb.bondsofFelCast+1)
		else
			local timer = self:IsTank() and 51 or 53
			timerBondsofFelCD:Start(timer, self.vb.bondsofFelCast+1)
		end
	elseif spellId == 221783 and self:AntiSpam(35, 1) then
		self.vb.flamesSargCast = self.vb.flamesSargCast + 1
		if self:IsMythic() then
			timerFlamesofSargerasCD:Start(6.3, (self.vb.flamesSargCast).."-"..2)
			timerFlamesofSargerasCD:Start(13.6, (self.vb.flamesSargCast).."-"..3)
			timerFlamesofSargerasCD:Start(45, (self.vb.flamesSargCast+1).."-"..1)
			if self.vb.flamesSargCast == 2 then
				timerWindsCD:Start(31, 2)
			end
		elseif self:IsHeroic() then
			timerFlamesofSargerasCD:Start(7.7, (self.vb.flamesSargCast).."-"..2)
			timerFlamesofSargerasCD:Start(16.4, (self.vb.flamesSargCast).."-"..3)
			timerFlamesofSargerasCD:Start(50, (self.vb.flamesSargCast+1).."-"..1)--5-6 is 50, 1-5 is 51. For time being using a simple 50 timer
		else--Normal, LFR?
			timerFlamesofSargerasCD:Start(18.9, (self.vb.flamesSargCast).."-"..2)
			timerFlamesofSargerasCD:Start(58.5, (self.vb.flamesSargCast+1).."-"..1)
		end
	elseif spellId == 212258 and (self:IsMythic() or self.vb.phase > 1.5) then--Ignore phase 1 adds with this cast
		self.vb.handofGuldanCast = self.vb.handofGuldanCast + 1
		specWarnHandofGuldan:Show()
		specWarnHandofGuldan:Play("bigmob")
		if self:IsMythic() then
			if self.vb.handofGuldanCast == 1 then
				timerFelLordKurazCD:Start(165)
			end
		else
			local timer = handofGuldanTimers[self.vb.handofGuldanCast+1]
			if timer then
				timerHandofGuldanCD:Start(timer, self.vb.handofGuldanCast+1)
			end
		end
	elseif spellId == 227008 then
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 221486 then
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 221336 then
		timerChaosSeedCD:Start(10.5, args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 209011 or spellId == 206354 or spellId == 206384 or spellId == 209086 then--206354/206366 unconfirmed on normal/heroic. LFR/Mythic?
		local isPlayer = args:IsPlayer()
		local name = args.destName
		if not tContains(bondsIcons, name) then
			bondsIcons[#bondsIcons+1] = name
		end
		local count = #bondsIcons
		if spellId == 206384 or spellId == 209086 then
			warnEmpBondsofFel:CombinedShow(0.5, name)
		else
			warnBondsofFel:CombinedShow(0.5, name)
		end
		if isPlayer then
			specWarnBondsofFel:Show()
			specWarnBondsofFel:Play("targetyou")
			yellBondsofFel:Yell(count, count, count)
		else
			local uId = DBM:GetRaidUnitId(name)
			if self:IsTanking(uId, "boss1") and not self:IsTanking("player", "boss1", nil, true) then
				--secondary warning, in case first one didn't go through
				if self:AntiSpam(5, name) then
					specWarnBondsofFelTank:Show(name)
					specWarnBondsofFelTank:Play("tauntboss")
				end
			end
		end
		if self.Options.SetIconOnBondsOfFel then
			self:SetIcon(name, count)
		end
	elseif spellId == 221891 then
		warnSoulSiphon:CombinedShow(0.3, args.destName)
	elseif spellId == 208802 then
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 5 then
			specWarnSoulCorrosion:Show(amount)
			specWarnSoulCorrosion:Play("stackhigh")
		end
	elseif spellId == 221606 then--Looks like the 3 second pre targeting debuff for flames of sargeras
		if self:AntiSpam(35, 1) then
			self.vb.flamesSargCast = self.vb.flamesSargCast + 1
			if self:IsMythic() then
				timerFlamesofSargerasCD:Start(6.3, (self.vb.flamesSargCast).."-"..2)
				timerFlamesofSargerasCD:Start(13.6, (self.vb.flamesSargCast).."-"..3)
				timerFlamesofSargerasCD:Start(45, (self.vb.flamesSargCast+1).."-"..1)
				if self.vb.flamesSargCast == 2 then
					timerWindsCD:Start(31, 2)
				end
			elseif self:IsHeroic() then
				timerFlamesofSargerasCD:Start(7.7, (self.vb.flamesSargCast).."-"..2)
				timerFlamesofSargerasCD:Start(16.4, (self.vb.flamesSargCast).."-"..3)
				timerFlamesofSargerasCD:Start(50, (self.vb.flamesSargCast+1).."-"..1)--5-6 is 50, 1-5 is 51. For time being using a simple 50 timer
			else--Normal, LFR
				timerFlamesofSargerasCD:Start(18.9, (self.vb.flamesSargCast).."-"..2)
				timerFlamesofSargerasCD:Start(58.5, (self.vb.flamesSargCast+1).."-"..1)
			end
		end
		local name = args.destName
		self.vb.flamesTargets = self.vb.flamesTargets + 1
		if not tContains(flamesIcons, name) then
			flamesIcons[#flamesIcons+1] = name
		end
		local count = #flamesIcons+3
		warnFlamesofSargeras:CombinedShow(0.3, name)
		if args:IsPlayer() then
			specWarnFlamesOfSargeras:Show()
			specWarnFlamesOfSargeras:Play("runout")
			yellFlamesofSargeras:Yell(count, count, count)
		else
			local uId = DBM:GetRaidUnitId(name)
			if self:IsTanking(uId, "boss1") then
				specWarnFlamesOfSargerasTank:Show(name)
				specWarnFlamesOfSargerasTank:Play("tauntboss")
			end
		end
		if self.Options.SetIconOnBondsOfFlames and count < 9 then
			self:SetIcon(name, count)--Should start at icon 4 and go up from there (because icons 1-3 are used by bonds of fel)
		end
	elseif spellId == 221603 or spellId == 221785 or spellId == 221784 or spellId == 212686 then--4 different duration versions of Flames of sargeras?
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
	elseif spellId == 206516 then--The Eye of Aman'Thul (phase 1 buff)
		self.vb.phase = 1.5
		timerLiquidHellfireCD:Stop()
		timerFelEffluxCD:Stop()
		timerLiquidHellfireCD:Start(5, self.vb.liquidHellfireCast+1)
		timerFelEffluxCD:Start(10, self.vb.felEffluxCast+1)
	elseif spellId == 227427 then--The Eye of Aman'Thul (phase 3 transition buff)
		timerBondsofFelCD:Stop()
		timerLiquidHellfireCD:Stop()
		timerEyeofGuldanCD:Stop()
		timerHandofGuldanCD:Stop()
		timerWindsCD:Start(12, 1)
		timerWellOfSouls:Start(15)
		self.vb.eyeCast = 0
		if self:IsMythic() then
			self.vb.phase = 2
			warnPhase2:Show()
			warnPhase2:Play("ptwo")
			timerDzorykxCD:Stop()
			timerFelLordKurazCD:Stop()
			timerFlamesofSargerasCD:Start(24.5, "1-1")
			timerEyeofGuldanCD:Start(34.3, 1)
			timerBlackHarvestCD:Start(55.7, 1)
			timerStormOfDestroyerCD:Start(72.6, 1)
		else
			self.vb.phase = 3
			warnPhase3:Show()
			warnPhase3:Play("pthree")
			timerBlackHarvestCD:Start(self:IsLFR() and 73 or 63, 1)
			if self:IsEasy() then
				timerFlamesofSargerasCD:Start(29, 1)
				timerEyeofGuldanCD:Start(42.5, 1)
				timerStormOfDestroyerCD:Start(94, 1)
			else
				timerFlamesofSargerasCD:Start(27.5, "1-1")
				timerEyeofGuldanCD:Start(39, 1)
				timerStormOfDestroyerCD:Start(84, 1)
			end
		end
	elseif spellId == 206847 then
		warnParasiticWound:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			local _, _, _, _, _, expires = DBM:UnitDebuff(args.destName, args.spellName)
			local remaining = expires-GetTime()
			specWarnParasiticWound:Show()
			specWarnParasiticWound:Play("scatter")
			yellParasiticWound:Yell()
			yellParasiticWoundFades:Countdown(remaining)
		end
	elseif spellId == 206983 and self:AntiSpam(2, args.destName) then
		warnShadowyGaze:CombinedShow(0.3, args.destName)
	elseif spellId == 206458 then
		if args:IsPlayer() then
			--specWarnShearedSoul:Show()
			--specWarnShearedSoul:Play("defensive")
		end
	elseif spellId == 227009 then
		warnWounded:Show()
		timerWounded:Start()
		timerVisionsofDarkTitan:Stop()
	elseif spellId == 206310 and args:IsPlayer() then
		yellParasiticWoundFades:Cancel()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 209011 or spellId == 206354 then
		if self.Options.SetIconOnBondsOfFel then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 206384 or spellId == 209086 then--(206366: stunned version mythic?)
		if self.Options.SetIconOnBondsOfFel then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 221606 then
		self.vb.flamesTargets = self.vb.flamesTargets - 1
		if self.vb.flamesTargets == 0 then
			table.wipe(flamesIcons)
		end
	elseif spellId == 221603 or spellId == 221785 or spellId == 221784 or spellId == 212686 then--4 different duration versions of Flames of sargeras?
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
		if self.Options.SetIconOnBondsOfFlames then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 206847 then
		if args:IsPlayer() then
			yellParasiticWoundFades:Cancel()
		end
	elseif spellId == 206310 and args:IsPlayer() then
		if DBM:UnitDebuff("player", parasiteName) then
			local _, _, _, _, _, expires = DBM:UnitDebuff("player", parasiteName)
			local remaining = expires-GetTime()
			yellParasiticWoundFades:Countdown(remaining)
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 205611 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
--		specWarnMiasma:Show()
--		specWarnMiasma:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 111070 then--Azzinoth
		timerChaosSeedCD:Stop(args.destGUID)
	elseif cid == 104154 and self:IsMythic() then--Gul'dan
		self.vb.bossLeft = self.vb.bossLeft - 1
		timerFlamesofSargerasCD:Stop()
		timerEyeofGuldanCD:Stop()
		timerBlackHarvestCD:Stop()
		timerStormOfDestroyerCD:Stop()
		timerWindsCD:Stop()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.prePullRP or msg:find(L.prePullRP)) and self:LatencyCheck() then
		self:SendSync("GuldanRP")
	elseif ( msg == L.mythicPhase3 or msg:find(L.mythicPhase3)) and self:IsMythic() then
		self:SendSync("mythicPhase3")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 161121 then--Assumed this is a script like felseeker
		self.vb.stormCast = self.vb.stormCast + 1
		specWarnStormOfDestroyer:Show()
		specWarnStormOfDestroyer:Play("watchstep")
		local timer = self:IsMythic() and stormTimersMythic[self.vb.stormCast+1] or self:IsEasy() and stormTimersEasy[self.vb.stormCast+1] or stormTimers[self.vb.stormCast+1]
		if timer then
			timerStormOfDestroyerCD:Start(timer, self.vb.stormCast+1)
		end
	elseif spellId == 215736 then--Hand of Guldan (Fel Lord Kuraz'mal)
		if self:IsMythic() then
			timerShatterEssenceCD:Start(21)
		else
			timerShatterEssenceCD:Start(19)--Same on normal and heroic. mythic/LFR need vetting.
		end
	elseif spellId == 215738 then--Hand of Guldan (Inquisitor Vethriz)
		if self:IsEasy() then
			--Unknown, died before casting either one
		else
			--timerShadowBlinkCD:Start(27.8)
			timerGazeofVethrizCD:Start(27.8)--Basically starts casting it right after blink, then every 5 seconds
		end
	elseif spellId == 215739 then--Hand of Guldan (D'zorykx the Trapper)
		if self:IsMythic() then
			timerSoulVortexCD:Start(3)
		end
		--[[if self:IsEasy() then
			timerSoulVortexCD:Start(52)--Normal verified, LFR assumed
		else
			timerSoulVortexCD:Start(35)--Heroic Jan 21
		end--]]
	elseif spellId == 210273 then--Fel Obelisk
		self.vb.obeliskCastCount = self.vb.obeliskCastCount + 1
		specWarnFelObelisk:Show()
		specWarnFelObelisk:Play("watchstep")
		if self:IsMythic() then
			if self.vb.obeliskCastCount % 2 == 0 then
				timerFelObeliskCD:Start(16)
			else
				timerFelObeliskCD:Start(5)
			end
		else
			timerFelObeliskCD:Start(23)
		end
	elseif spellId == 209601 or spellId == 209637 or spellId == 208831 then--Fel Lord, Inquisitor, Jailer (they cast these on death, more reliable than UNIT_DIED which often doesn't fire for inquisitor)
		local cid = self:GetUnitCreatureId(uId)
		if cid == 104537 or cid == 104536 or cid == 104534 then
			self.vb.addsDied = self.vb.addsDied + 1
			if cid == 104537 then--Fel Lord Kuraz'mal
				timerShatterEssenceCD:Stop()
				timerFelObeliskCD:Stop()
			elseif cid == 104536 then--Inquisitor Vethriz
				timerGazeofVethrizCD:Stop()
				--timerShadowBlinkCD:Stop()
			elseif cid == 104534 then--D'zorykx the Trapper
				timerSoulVortexCD:Stop()
			end
			if self.vb.addsDied == 3 and not self:IsMythic() then
				--This probably needs refactoring for mythic since phase 1 and 2 happen at same time
				self.vb.phase = 2
				self.vb.liquidHellfireCast = 0
				warnPhase2:Show()
				warnPhase2:Play("ptwo")
				timerLiquidHellfireCD:Stop()
				timerFelEffluxCD:Stop()
				timerTransition:Start(19)
				timerBondsofFelCD:Start(self:IsTank() and 25.5 or 27.6, 1)
				if self:IsLFR() then
					timerEyeofGuldanCD:Start(54, 1)
					timerLiquidHellfireCD:Start(67, 1)
				elseif self:IsNormal() then
					timerEyeofGuldanCD:Start(50.6, 1)
					timerLiquidHellfireCD:Start(63.1, 1)
				else--Heroic
					timerHandofGuldanCD:Start(33, 1)
					timerEyeofGuldanCD:Start(48, 1)
					timerLiquidHellfireCD:Start(59, 1)
				end
			end
		end
	elseif spellId == 227035 then -- Parasitic Wound
		timerParasiticWoundCD:Start()
	elseif spellId == 221149 or spellId == 227277 then -- Manifest Azzinoth
		self.vb.azzCount = self.vb.azzCount + 1
		local count = self.vb.azzCount
		specWarnManifestAzzinoth:Show(count)
		specWarnManifestAzzinoth:Play("bigmob")
		specWarnManifestAzzinoth:ScheduleVoice(1.2, nil, "Interface\\AddOns\\DBM-VP"..DBM.Options.ChosenVoicePack2.."\\count\\"..count..".ogg")
		timerBulwarkofAzzinothCD:Start(15)
		timerManifestAzzinothCD:Start(40, count+1)
	elseif spellId == 227071 then -- Flame Crash
		self.vb.crashCastCount  = self.vb.crashCastCount  + 1
		if self.vb.crashCastCount == 4 or self.vb.crashCastCount == 7 then
			timerFlameCrashCD:Start(50, self.vb.crashCastCount+1)
		else
			timerFlameCrashCD:Start(20, self.vb.crashCastCount+1)
		end
	elseif spellId == 227283 then -- Nightorb
		self.vb.orbCastCount = self.vb.orbCastCount + 1
		specWarnSummonNightorb:Show(self.vb.orbCastCount)
		specWarnSummonNightorb:Play("mobsoon")
		if self.vb.orbCastCount ~= 4 then
			if self.vb.orbCastCount == 2 then
				timerSummonNightorbCD:Start(60, self.vb.orbCastCount+1)
			elseif self.vb.orbCastCount == 3 then
				timerSummonNightorbCD:Start(40, self.vb.orbCastCount+1)
			else
				timerSummonNightorbCD:Start(45, self.vb.orbCastCount+1)
			end
		end
	end
end

function mod:OnSync(msg)
	if msg == "GuldanRP" and self:AntiSpam(10, 3) then
		timerRP:Start()
	end
	if not self:IsInCombat() then return end
	if msg == "mythicPhase3" and self:IsMythic() then
		warnPhase3Soon:Show()
		timerWilloftheDemonWithin:Start(43)
	end
end

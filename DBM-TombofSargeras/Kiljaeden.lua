local mod	= DBM:NewMod(1898, "DBM-TombofSargeras", nil, 875)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116144653")
mod:SetCreatureID(117269)--121227 Illiden? 121193 Shadowsoul
mod:SetEncounterID(2051)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 237725 238999 243982 240910 241983 239932",
	"SPELL_CAST_SUCCESS 236378 236710 237590 236498 238502 238430 238999 241564",
	"SPELL_AURA_APPLIED 239932 236378 236710 237590 236498 236597 241721 245509 243536 243624",
	"SPELL_AURA_APPLIED_DOSE 245509",
	"SPELL_AURA_REFRESH 241721",
	"SPELL_AURA_REMOVED 236378 236710 237590 236498 241721 239932 241983 244834 243536",
	"UNIT_DIED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"--Illiden might cast important stuff, or adds?
)

--TODO, do we need shadow gaze warnings for player other then self?
--TODO, how many shadowsouls? Also add a "remaining warning" for it as well.
--TODO, deal wih wailing timer if tank suicides during spell cast start (and before success fires)
--[[
(ability.id = 238502 or ability.id = 237725 or ability.id = 238999 or ability.id = 243982 or ability.id = 240910 or ability.id = 241983) and type = "begincast"
 or (ability.id = 239932 or ability.id = 235059 or ability.id = 238502 or ability.id = 239785 or ability.id = 236378 or ability.id = 236710 or ability.id = 237590 or ability.id = 236498 or ability.id = 238430 or ability.id = 241564) and type = "cast"
 or ability.id = 244834 and type = "applybuff" or (ability.id = 241983 or ability.id = 244834) and type = "removebuff"
 or ability.name = "Rupturing Singularity" and target.name = "Omegal"
 --]]
 --Stage One:
local warnFelClaw					= mod:NewCountAnnounce(239932, 3, nil, "Tank")
local warnEruptingRelections		= mod:NewTargetAnnounce(236710, 2)
local warnSingularitySoon			= mod:NewAnnounce("warnSingularitySoon", 4, 235059, nil, nil, true)
--Intermission: Eternal Flame
local warnBurstingDreadFlame		= mod:NewTargetCountAnnounce(238430, 2)--Generic for now until more known, likely something cast fairly often
--Stage Two:
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnWailingReflection			= mod:NewTargetCountAnnounce(236378, 4)
local warnSorrowfulWail				= mod:NewSpellAnnounce(241564, 4)
--Stage Three: Darkness of A Thousand Souls
local warnPhase3					= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)
local warnTearRift					= mod:NewCountAnnounce(243982, 2)--Positive message color?
local warnDarknessofStuffEnded		= mod:NewEndAnnounce(238999, 1)

--Stage One: The Betrayer
local specWarnFelclaws				= mod:NewSpecialWarningDefensive(239932, nil, nil, nil, 1, 2)
local specWarnFelclawsOther			= mod:NewSpecialWarningTaunt(239932, nil, nil, nil, 1, 2)
local specWarnRupturingSingularity	= mod:NewSpecialWarningSoon(235059, nil, nil, nil, 3, 2)
local specWarnArmageddon			= mod:NewSpecialWarningCount(240910, nil, nil, nil, 2, 2)
local specWarnSRWailing				= mod:NewSpecialWarningYou(236378, nil, nil, nil, 1, 2)
local yellSRWailing					= mod:NewFadesYell(236378, 236075)--Keep name in tank one for now
local specWarnSRErupting			= mod:NewSpecialWarningYouPos(236710, nil, nil, nil, 1, 2)
local yellSRErupting				= mod:NewIconFadesYell(236710, 243160)
local specWarnLingeringEruption		= mod:NewSpecialWarningDodge(243536, nil, nil, nil, 2, 2)
local specWarnLingeringWail			= mod:NewSpecialWarningDefensive(243624, nil, nil, nil, 1, 2)
local yellLingeringWail				= mod:NewShortYell(243624, nil, false)
local specWarnSorrowfulWail			= mod:NewSpecialWarningRun(241564, "Melee", nil, nil, 4, 2)
--Intermission: Eternal Flame
local specWarnFocusedDreadflame		= mod:NewSpecialWarningYou(238502, nil, nil, nil, 1, 2)
local yellFocusedDreadflame			= mod:NewShortYell(238502)
local yellFocusedDreadflameFades	= mod:NewFadesYell(238502)
local specWarnFocusedDreadflameOther= mod:NewSpecialWarningTarget(238502, nil, nil, nil, 1, 2)
local specWarnBurstingDreadflame	= mod:NewSpecialWarningMoveAway(238430, nil, nil, nil, 1, 2)
local yellBurstingDreadflame		= mod:NewPosYell(238430, DBM_CORE_L.AUTO_YELL_CUSTOM_POSITION2)
local yellBurstingDreadflameFades	= mod:NewShortFadesYell(238430, nil, false)
--Stage Two: Reflected Souls
local specWarnSRHopeless			= mod:NewSpecialWarningYou(237590, nil, nil, 2, 3, 2)
local yellSRHopeless				= mod:NewShortFadesYell(237590, 237724)
local specWarnSRMalignant			= mod:NewSpecialWarningYou(236498, nil, nil, nil, 1, 2)
local yellSRMalignant				= mod:NewShortFadesYell(236498)
local specWarnMalignantAnguish		= mod:NewSpecialWarningInterrupt(236597, "HasInterrupt")
--Intermission: Deceiver's Veil

--Stage Three: Darkness of A Thousand Souls
local specWarnDarknessofSouls		= mod:NewSpecialWarningMoveTo(238999, nil, nil, nil, 3, 2)
local specWarnObelisk				= mod:NewSpecialWarningCount(239785, nil, nil, nil, 2, 2)
local specWarnFlamingOrbSpawn		= mod:NewSpecialWarningDodge(239253, nil, nil, nil, 2, 2)--Spawn warning

--Stage One: The Betrayer
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerFelclawsCD				= mod:NewCDCountTimer(25, 239932, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 4)
local timerRupturingSingularityCD	= mod:NewCDCountTimer(61, 235059, nil, nil, nil, 3)--61-68?
local timerRupturingSingularity		= mod:NewCastSourceTimer(9.7, 235059, 206577, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 5)--Shortname: Comet Impact
local timerArmageddonCD				= mod:NewCDCountTimer(42, 240910, nil, nil, nil, 5)
local timerArmageddon				= mod:NewCastTimer(9, 234295, nil, nil, nil, 2)--Armageddon Rain
local timerShadReflectionEruptingCD	= mod:NewCDTimer(35, 236710, 236711, nil, nil, 3, nil, DBM_COMMON_L.DAMAGE_ICON)--Shortname : Erupting Reflection
--Intermission: Eternal Flame
--mod:AddTimerLine(SCENARIO_STAGE:format(1.5))
local timerTransition				= mod:NewPhaseTimer(57.9)
local timerFocusedDreadflameCD		= mod:NewCDCountTimer(31, 238502, nil, nil, nil, 3, nil, nil, nil, 3, 4)
local timerBurstingDreadflameCD		= mod:NewCDCountTimer(31, 238430, nil, nil, nil, 3)
--Stage Two: Reflected Souls
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerShadReflectionHopelessCD	= mod:NewCDTimer(196, 237590, 237724, nil, nil, 3, nil, DBM_COMMON_L.HEALER_ICON)--Shortname : Hopeless Reflection
local timerHopelessness				= mod:NewCastTimer(8, 237725, nil, "Healer", nil, 5, nil, DBM_COMMON_L.HEALER_ICON)
local timerShadReflectionWailingCD	= mod:NewCDCountTimer(35, 236378, 236475, nil, nil, 3, nil, DBM_COMMON_L.TANK_ICON)--Shortname : Wailing Reflection
local timerSorrowfulWailCD			= mod:NewCDTimer(14.1, 241564, nil, nil, nil, 2)
--Intermission: Deceiver's Veil
--mod:AddTimerLine(SCENARIO_STAGE:format(2.5))
local timerSightlessGaze			= mod:NewBuffActiveTimer(20, 241721, nil, nil, nil, 5)
--Stage Three: Darkness of A Thousand Souls
mod:AddTimerLine(SCENARIO_STAGE:format(3))
local timerDarknessofSoulsCD		= mod:NewCDCountTimer(89.7, 238999, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerTearRiftCD				= mod:NewCDCountTimer(95, 243982, nil, nil, nil, 3)
local timerFlamingOrbCD				= mod:NewCDCountTimer(30, 239253, nil, nil, nil, 3)
local timerObeliskCD				= mod:NewCDCountTimer(42, 239785, nil, nil, nil, 3)
local timerObelisk					= mod:NewCastTimer(13, 239785, L.Obelisklasers, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 5)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddSetIconOption("SetIconOnFocusedDread", 238502, true)
mod:AddSetIconOption("SetIconOnBurstingDread", 238430, false)
mod:AddSetIconOption("SetIconOnEruptingReflection", 236710, true)
mod:AddInfoFrameOption(239154, true)
mod:AddRangeFrameOption("5/10")--238502/239253

mod.vb.phase = 1
mod.vb.shadowSoulsRemaining = 5--Need real number
mod.vb.armageddonCast = 0
mod.vb.focusedDreadCast = 0
mod.vb.burstingDreadCast = 0
mod.vb.burstingDreadIcon = 6
mod.vb.eruptingReflectionIcon = 3
mod.vb.singularityCount = 0
mod.vb.felClawsCount = 0
mod.vb.orbCount = 0
mod.vb.darknessCount = 0
mod.vb.riftCount = 0
mod.vb.lastTankHit = "None"
mod.vb.clawCount = 0
mod.vb.obeliskCount = 0
mod.vb.wailingCount = 0
local riftName, gravitySqueezeBuff = DBM:GetSpellInfo(239130), DBM:GetSpellInfo(239154)
local phase1LFRArmageddonTimers = {10, 22, 42}--Incomplete
local phase1MythicArmageddonTimers = {10, 54, 38, 46}--Incomplete
local phase1MythicSingularityTimers = {55, 25, 25}--Incomplete
local phase1point5MythicSingularityTimers = {14.8, 5, 13.2, 5, 5, 4.98, 25, 4.98}--Timers, if all of the emotes exist. Not all of them do, DBM attempts to hack fix this
local phase2LFRArmageddonTimers = {55.9, 27.8, 56.6, 26.6, 12.2}
local phase2NormalArmageddonTimers = {50, 45, 31, 35, 31}
local phase2HeroicArmageddonTimers = {50, 75, 35, 30}
local phase2MythicArmageddonTimers = {19.4, 32, 45, 33, 36, 36, 47, 32, 45}
--local phase2NormalBurstingTimers = {57, 48, 55}--Not used yet, needs more data to verify and improve
local phase2HeroicBurstingTimers = {52, 47, 55}--Incomplete
local phase2MythicBurstingTimers = {53.4, 50.0, 45.0, 48.0, 86}
local phase15LFRBurstingTimers = {7.7, 17, 13.3, 17}
local phase2LFRBurstingTimers = {58.2, 53.3, 61}
local phase2NormalFocusedTimers = {71.4, 99}
local phase2HeroicFocusedTimers = {30, 45, 53, 46}
local phase2MythicFocusedTimers = {33.4, 44, 47, 138, 44}
local phase2NormalSingularityTimers = {74, 81}
local phase2HeroicSingularityTimers = {74, 26, 55, 44}
local phase2MythicSingularityTimers = {22, 50, 66.9, 78, 84}
local playerName = UnitName("player")

local function ObeliskWarning(self)
	self.vb.obeliskCount = self.vb.obeliskCount + 1
	specWarnObelisk:Show(self.vb.obeliskCount)
	specWarnObelisk:Play("farfromline")
	if self:IsMythic() then
		timerObelisk:Start(12)
	else
		timerObelisk:Start(13)
	end
	if self.vb.obeliskCount % 2 == 1 then
		timerObeliskCD:Start(36, self.vb.obeliskCount+1)
		self:Schedule(36, ObeliskWarning, self)
	end
end

local function handleMissingEmote(self)
	self:Unschedule(handleMissingEmote)
	self.vb.singularityCount = self.vb.singularityCount + 1
	timerRupturingSingularity:Start(7.7, self.vb.singularityCount)
	if self:IsMythic() then
		local timer = phase1point5MythicSingularityTimers[self.vb.singularityCount+1]
		if timer then
			self:Schedule(timer, handleMissingEmote, self)--Already scheduled on delay
			timerRupturingSingularityCD:Start(timer-2, self.vb.singularityCount+1)
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.armageddonCast = 0
	self.vb.focusedDreadCast = 0
	self.vb.burstingDreadCast = 0
	self.vb.singularityCount = 0
	self.vb.felClawsCount = 0
	self.vb.orbCount = 0
	self.vb.darknessCount = 0
	self.vb.riftCount = 0
	self.vb.lastTankHit = "None"
	self.vb.clawCount = 0
	self.vb.obeliskCount = 0
	self.vb.wailingCount = 0
	timerArmageddonCD:Start(10-delay, 1)
	timerFelclawsCD:Start(25-delay, 1)
	if self:IsMythic() then
		timerShadReflectionEruptingCD:Start(18.5-delay)
		timerRupturingSingularityCD:Start(55.2-delay, 1)
		timerShadReflectionWailingCD:Start(56, 1)
		berserkTimer:Start(840-delay)--apparently it's anywhere between 14:00 and 14:10 depending on RNG
	else
		if not self:IsLFR() then
			timerRupturingSingularityCD:Start(58-delay, 1)
			if not self:IsEasy() then
				timerShadReflectionEruptingCD:Start(21-delay)--Erupting
			end
		end
		berserkTimer:Start(600-delay)
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

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 237725 and self:AntiSpam(5, 2) then--Assume they all spawn/begin casting at same time
		timerHopelessness:Start()
	elseif spellId == 238999 then
		self.vb.darknessCount = self.vb.darknessCount + 1
		if self.vb.darknessCount == 1 then--No rift yet, stack with group
			specWarnDarknessofSouls:Show(GROUP)
			self:Schedule(25, ObeliskWarning, self)
			timerObeliskCD:Start(25, 1)
		else--Move to rift
			specWarnDarknessofSouls:Show(riftName)
			if self.Options.InfoFrame then
				DBM.InfoFrame:SetHeader(DBM_COMMON_L.NO_DEBUFF:format(DBM_COMMON_L.SAFE))
				DBM.InfoFrame:Show(10, "playergooddebuff", gravitySqueezeBuff)
			end
			self:Schedule(28.5, ObeliskWarning, self)
			timerObeliskCD:Start(28.5, self.vb.obeliskCount+1)
		end
		specWarnDarknessofSouls:Play("findshelter")
		timerDarknessofSoulsCD:Start(nil, self.vb.darknessCount+1)
	elseif spellId == 243982 then
		self.vb.riftCount = self.vb.riftCount + 1
		warnTearRift:Show(self.vb.riftCount)
		timerTearRiftCD:Start(nil, self.vb.riftCount+1)
	elseif spellId == 240910 then--Armageddon.
		self.vb.armageddonCast = self.vb.armageddonCast + 1
		specWarnArmageddon:Show(self.vb.armageddonCast)
		specWarnArmageddon:Play("helpsoak")
		timerArmageddon:Start()
		if self.vb.phase == 1.5 then
			if self.vb.armageddonCast < 2 then
				if self:IsMythic() then
					timerArmageddonCD:Start(58.5, self.vb.armageddonCast+1)
				elseif self:IsNormal() then
					timerArmageddonCD:Start(28, self.vb.armageddonCast+1)
				else
					timerArmageddonCD:Start(29.5, self.vb.armageddonCast+1)
				end
			end
		elseif self.vb.phase == 2 then
			local timer = self:IsMythic() and phase2MythicArmageddonTimers[self.vb.armageddonCast+1] or self:IsNormal() and phase2NormalArmageddonTimers[self.vb.armageddonCast+1] or self:IsHeroic() and phase2HeroicArmageddonTimers[self.vb.armageddonCast+1] or self:IsLFR() and phase2LFRArmageddonTimers[self.vb.armageddonCast+1]
			if timer then
				timerArmageddonCD:Start(timer, self.vb.armageddonCast+1)
			end
		else--Phase 1
			if self:IsMythic() then
				local timer = phase1MythicArmageddonTimers[self.vb.armageddonCast+1]
				if timer then
					timerArmageddonCD:Start(timer, self.vb.armageddonCast+1)
				end
			elseif self:IsLFR() then
				local timer = phase1LFRArmageddonTimers[self.vb.armageddonCast+1]
				if timer then
					timerArmageddonCD:Start(timer, self.vb.armageddonCast+1)
				end
			else
				timerArmageddonCD:Start(64, self.vb.armageddonCast+1)
			end
		end
	elseif spellId == 239932 then
		self.vb.clawCount = 0
		self.vb.felClawsCount = self.vb.felClawsCount + 1
		--Special snow flake (https://www.warcraftlogs.com/reports/xntG1J4r7MmwAPqB#fight=3&type=summary&pins=2%24Off%24%23244F4B%24expression%24(ability.id%20%3D%20238502%20or%20ability.id%20%3D%20237725%20or%20ability.id%20%3D%20238999%20or%20ability.id%20%3D%20243982%20or%20ability.id%20%3D%20240910%20or%20ability.id%20%3D%20241983)%20and%20type%20%3D%20%22begincast%22%0A%20or%20(ability.id%20%3D%20239932%20or%20ability.id%20%3D%20235059%20or%20ability.id%20%3D%20238502%20or%20ability.id%20%3D%20239785%20or%20ability.id%20%3D%20236378%20or%20ability.id%20%3D%20236710%20or%20ability.id%20%3D%20237590%20or%20ability.id%20%3D%20236498%20or%20ability.id%20%3D%20238430)%20and%20type%20%3D%20%22cast%22%0A%20or%20ability.id%20%3D%20244834%20and%20type%20%3D%20%22applybuff%22%20or%20(ability.id%20%3D%20241983%20or%20ability.id%20%3D%20244834)%20and%20type%20%3D%20%22removebuff%22%0A%20or%20ability.name%20%3D%20%22Rupturing%20Singularity%22%20and%20target.name%20%3D%20%22Omegal%22&view=events)
		--TODO, see if this happens more than once (8th claw, etc)
		if self.vb.phase == 3 and (self.vb.felClawsCount == 4 or self.vb.felClawsCount == 8) then
			timerFelclawsCD:Start(16, self.vb.felClawsCount+1)
		elseif self.vb.phase == 2 and self:IsMythic() and self.vb.felClawsCount == 2 then--Only sub 24 niche case?
			timerFelclawsCD:Start(22.9, self.vb.felClawsCount+1)
		else
			timerFelclawsCD:Start(24, self.vb.felClawsCount+1)
		end
		local tanking, status = UnitDetailedThreatSituation("player", "boss1")
		if tanking or (status == 3) then
			specWarnFelclaws:Show()
			specWarnFelclaws:Play("defensive")
		end
	elseif spellId == 241983 and self.vb.phase < 2.5 then--Deceiver's Veil
		timerFelclawsCD:Stop()
		timerFocusedDreadflameCD:Stop()
		timerBurstingDreadflameCD:Stop()
		timerArmageddonCD:Stop()
		timerShadReflectionEruptingCD:Stop()
		timerShadReflectionWailingCD:Stop()
		timerShadReflectionHopelessCD:Stop()
		timerRupturingSingularityCD:Stop()
		self.vb.phase = 2.5
		self.vb.shadowSoulsRemaining = 5--Normal count anyways
		self.vb.singularityCount = 0
		warnPhase3:Play("phasechange")
		if self:IsMythic() then
			timerRupturingSingularityCD:Start(19.3, 1)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 236378 then--Wailing Shadow Reflection (Stage 1)
		self.vb.wailingCount = self.vb.wailingCount + 1
		if self:IsMythic() and self.vb.phase == 2 then
			--if self.vb.wailingCount == 1 then--Need more data
			if self.vb.wailingCount % 2 == 0 then--Alternation assumed
				timerShadReflectionWailingCD:Start(169.1, self.vb.wailingCount+1)
			else
				timerShadReflectionWailingCD:Start(60, self.vb.wailingCount+1)
			end
		else
			timerShadReflectionWailingCD:Start(112, self.vb.wailingCount+1)
		end
	elseif spellId == 236710 then--Erupting Shadow Reflection (Stage 1)
		self.vb.eruptingReflectionIcon = 3
		if self.vb.phase == 2 and not self:IsMythic() then
			timerShadReflectionEruptingCD:Start(112)
		elseif self:IsMythic() and self.vb.phase == 1 then
			timerShadReflectionEruptingCD:Start(109)
		end
	elseif spellId == 237590 then--Hopeless Shadow Reflection (Stage 2)
		timerShadReflectionHopelessCD:Start()
	elseif spellId == 236498 then--Malignant Shadow Reflection (Stage 2)

	elseif spellId == 238502 then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnFocusedDread then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 238430 then
		if self:AntiSpam(2, 5) then
			self.vb.burstingDreadCast = self.vb.burstingDreadCast + 1
			self.vb.burstingDreadIcon = 6
			if self.vb.phase == 1.5 then
				if self:IsLFR() then
					local timer = phase15LFRBurstingTimers[self.vb.burstingDreadCast+1]
					if timer then
						timerBurstingDreadflameCD:Start(timer, self.vb.burstingDreadCast+1)
					end
				else
					if self.vb.burstingDreadCast < 2 then
						if self:IsMythic() then
							timerBurstingDreadflameCD:Start(79, 2)
						elseif self:IsNormal() then
							timerBurstingDreadflameCD:Start(44, 2)
						else
							timerBurstingDreadflameCD:Start(47, 2)--Delayed by singularity which doesn't happen on normal/LFR
						end
					end
				end
			elseif self.vb.phase == 2 then
				if self:IsMythic() then
					local timer = phase2MythicBurstingTimers[self.vb.burstingDreadCast+1]
					if timer then
						timerBurstingDreadflameCD:Start(timer, self.vb.burstingDreadCast+1)
					end
				else
					if self:IsLFR() then
						local timer = phase2LFRBurstingTimers[self.vb.burstingDreadCast+1]
						if timer then
							timerBurstingDreadflameCD:Start(timer, self.vb.burstingDreadCast+1)
						end
					else
						local timer = phase2HeroicBurstingTimers[self.vb.burstingDreadCast+1]
						if timer then
							timerBurstingDreadflameCD:Start(timer, self.vb.burstingDreadCast+1)
						end
					end
				end
			else--Phase 3
				if self.vb.burstingDreadCast % 2 == 0 then
					if self:IsMythic() then
						timerBurstingDreadflameCD:Start(43, self.vb.burstingDreadCast+1)
					else
						timerBurstingDreadflameCD:Start(70, self.vb.burstingDreadCast+1)
					end
				else
					if self:IsMythic() then
						timerBurstingDreadflameCD:Start(51.9, self.vb.burstingDreadCast+1)
					else
						timerBurstingDreadflameCD:Start(25, self.vb.burstingDreadCast+1)
					end
				end
			end
		end
		warnBurstingDreadFlame:CombinedShow(0.5, self.vb.burstingDreadCast, args.destName)
		if args:IsPlayer() then
			specWarnBurstingDreadflame:Show()
			specWarnBurstingDreadflame:Play("scatter")
			yellBurstingDreadflame:Yell(self.vb.burstingDreadIcon, args.spellName, self.vb.burstingDreadIcon)
			yellBurstingDreadflameFades:Countdown(5)
		end
		if self.Options.SetIconOnBurstingDread then
			self:SetIcon(args.destName, self.vb.burstingDreadIcon, 5)
		end
		self.vb.burstingDreadIcon = self.vb.burstingDreadIcon + 1
		if self.vb.burstingDreadIcon == 8 then self.vb.burstingDreadIcon = 1 end
	elseif spellId == 238999 then
		warnDarknessofStuffEnded:Show()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 241564 then
		if self.Options.SpecWarn241564run then
			specWarnSorrowfulWail:Show()
			specWarnSorrowfulWail:Play("runout")
		else
			warnSorrowfulWail:Show()
		end
		timerSorrowfulWailCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 245509 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if uId and self:IsTanking(uId) then
			self.vb.lastTankHit = args.destName
		end
		if self:AntiSpam(0.5, 6) then
			self.vb.clawCount = self.vb.clawCount + 1
			warnFelClaw:Show(self.vb.clawCount)
		end
		if self.vb.clawCount == 5 then
			if (self.vb.lastTankHit ~= playerName) and self:AntiSpam(3, self.vb.lastTankHit) then
				specWarnFelclawsOther:Show(self.vb.lastTankHit)
				specWarnFelclawsOther:Play("tauntboss")
			end
		end
	elseif spellId == 236378 then--Wailing Shadow Reflection (Stage 1)
		if args:IsPlayer() then
			specWarnSRWailing:Show()
			specWarnSRWailing:Play("targetyou")
			yellSRWailing:Countdown(7)
		else
			warnWailingReflection:Show(self.vb.wailingCount, args.destName)
		end
	elseif spellId == 236710 then--Erupting Shadow Reflection (Stage 1)
		warnEruptingRelections:CombinedShow(0.3, args.destName)
		local icon = self.vb.eruptingReflectionIcon
		if args:IsPlayer() then
			if self:IsMythic() then
				specWarnSRErupting:Show(self:IconNumToTexture(icon))
				specWarnSRErupting:Play("mm"..icon)
			else
				specWarnSRErupting:Show(BOSS)
				specWarnSRErupting:Play("gathershare")
			end
			yellSRErupting:Countdown(8, nil, icon)
		end
		if self.Options.SetIconOnEruptingReflection and self:IsMythic() then
			self:SetIcon(args.destName, icon)
		end
		self.vb.eruptingReflectionIcon = self.vb.eruptingReflectionIcon + 1
	elseif spellId == 237590 then--Hopeless Shadow Reflection (Stage 2)
		if args:IsPlayer() then
			specWarnSRHopeless:Show()
			specWarnSRHopeless:Play("targetyou")
			yellSRHopeless:Countdown(8)
		end
	elseif spellId == 236498 then--Malignant Shadow Reflection (Stage 2)
		if args:IsPlayer() then
			specWarnSRMalignant:Show()
			specWarnSRMalignant:Play("targetyou")
			yellSRMalignant:Countdown(8)
		end
	elseif spellId == 236597 then
		if self:CheckInterruptFilter(args.destGUID, false, true) then
			specWarnMalignantAnguish:Show(args.destName)
			specWarnMalignantAnguish:Play("kickcast")
		end
	elseif spellId == 241721 and args:IsPlayer() then
		timerSightlessGaze:Start()
	elseif spellId == 243536 and self:AntiSpam(3, 7) then
		if args:IsPlayer() then
			specWarnLingeringEruption:Play("keepmove")
		else
			if self:AntiSpam(3, 7) then
				specWarnLingeringEruption:Show()
				specWarnLingeringEruption:Play("watchorb")
			end
		end
	elseif spellId == 243624 then
		if args:IsPlayer() then
			specWarnLingeringWail:Show()
			specWarnLingeringWail:Play("defensive")
			yellLingeringWail:Yell()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 236378 then--Wailing Shadow Reflection (Stage 1)
		if not self:IsEasy() then
			timerSorrowfulWailCD:Start(15.2)
		end
		if args:IsPlayer() then
			yellSRWailing:Cancel()
		end
	elseif spellId == 236710 then--Erupting Shadow Reflection (Stage 1)
		if args:IsPlayer() then
			yellSRErupting:Cancel()
		end
	elseif spellId == 243536 then
		if self.Options.SetIconOnEruptingReflection then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 237590 then--Hopeless Shadow Reflection (Stage 2)
		if args:IsPlayer() then
			yellSRHopeless:Cancel()
		end
	elseif spellId == 236498 then--Malignant Shadow Reflection (Stage 2)
		if args:IsPlayer() then
			yellSRMalignant:Cancel()
		end
	elseif spellId == 241721 and args:IsPlayer() then
		timerSightlessGaze:Stop()
	elseif spellId == 239932 and not self.vb.phase ~= 1.5 then--Felclaws ended
		if (self.vb.lastTankHit ~= playerName) and self:AntiSpam(3, self.vb.lastTankHit) then
			specWarnFelclawsOther:Show(self.vb.lastTankHit)
			specWarnFelclawsOther:Play("tauntboss")
		end
	elseif spellId == 241983 and self:IsInCombat() then--Deceiver's Veil
		self:Unschedule(handleMissingEmote)
		self.vb.phase = 3
		self.vb.armageddonCast = 0
		self.vb.focusedDreadCast = 0
		self.vb.burstingDreadCast = 0
		self.vb.felClawsCount = 0
		--timerDarknessofSoulsCD:Start(1, 1)--Cast intantly
		timerSightlessGaze:Stop()
		warnPhase3:Show()
		warnPhase3:Play("pthree")
		timerTearRiftCD:Start(14, 1)
		if self:IsMythic() then
			timerBurstingDreadflameCD:Start(30, 1)
			timerFlamingOrbCD:Start(40, 1)
			timerFocusedDreadflameCD:Start(48, 1)
		else
			if not self:IsEasy() then
				timerFlamingOrbCD:Start(30, 1)
			end
			timerBurstingDreadflameCD:Start(44, 1)
			if not self:IsLFR() then
				timerFocusedDreadflameCD:Start(80, 1)
			end
		end
	elseif spellId == 244834 then--Nether Gale
		self:Unschedule(handleMissingEmote)
		self.vb.phase = 2
		self.vb.armageddonCast = 0
		self.vb.focusedDreadCast = 0
		self.vb.burstingDreadCast = 0
		self.vb.singularityCount = 0
		self.vb.felClawsCount = 0
		self.vb.wailingCount = 0
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		if self:IsMythic() then
			timerFelclawsCD:Start(10.4, 1)
			timerArmageddonCD:Start(18.2, 1)
			timerRupturingSingularityCD:Start(21.5, 1)
			timerShadReflectionHopelessCD:Start(27)
			timerFocusedDreadflameCD:Start(32.4, 1)
			timerShadReflectionWailingCD:Start(49.5, 1)
			timerBurstingDreadflameCD:Start(52.6, 1)
			timerShadReflectionEruptingCD:Start(164, 1)
		else
			timerFelclawsCD:Start(9, 1)
			timerShadReflectionEruptingCD:Start(12)
			if self:IsLFR() then
				timerArmageddonCD:Start(55.9, 1)
				timerBurstingDreadflameCD:Start(58.2, 1)
			else
				timerArmageddonCD:Start(50, 1)
				timerBurstingDreadflameCD:Start(52.3, 1)
				if self:IsNormal() then
					timerRupturingSingularityCD:Start(74, 1)
					timerFocusedDreadflameCD:Start(76.5, 1)
				else
					timerFocusedDreadflameCD:Start(30, 1)
					timerShadReflectionWailingCD:Start(48, 1)
					timerRupturingSingularityCD:Start(74, 1)
				end
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg:find("spell:238502") then
		self.vb.focusedDreadCast = self.vb.focusedDreadCast + 1
		if self.vb.phase == 1.5 then
			if self.vb.focusedDreadCast < 2 then
				if self:IsMythic() then
					timerFocusedDreadflameCD:Start(37.6, 2)
				else
					timerFocusedDreadflameCD:Start(12, 2)
				end
			end
		elseif self.vb.phase == 2 then
			local timer = self:IsMythic() and phase2MythicFocusedTimers[self.vb.focusedDreadCast+1] or self:IsHeroic() and phase2HeroicFocusedTimers[self.vb.focusedDreadCast+1] or self:IsNormal() and phase2NormalFocusedTimers[self.vb.focusedDreadCast+1]
			if timer then
				timerFocusedDreadflameCD:Start(timer, self.vb.focusedDreadCast+1)
			end
		else--Phase 3
			if self:IsMythic() then
				if self.vb.focusedDreadCast % 2 == 0 then
					timerFocusedDreadflameCD:Start(59)
				else
					timerFocusedDreadflameCD:Start(35.9)
				end
			else
				timerFocusedDreadflameCD:Start(95)
			end
		end
		if not self:IsEasy() then--TODO, this isn't mentioned in intermission, only in phase 2+ version. Investigate
			specWarnFocusedDreadflame:ScheduleVoice(1, "range5")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(5, nil, nil, nil, nil, 6)
			end
		end
		if target then
			target = DBM:GetUnitFullName(target)
			if target == UnitName("player") then
				specWarnFocusedDreadflame:Show()
				specWarnFocusedDreadflame:Play("targetyou")
				yellFocusedDreadflame:Yell()
				yellFocusedDreadflameFades:Countdown(5)
			else
				specWarnFocusedDreadflameOther:Show(target)
				specWarnFocusedDreadflameOther:Play("helpsoak")
			end
			if self.Options.SetIconOnFocusedDread then
				self:SetIcon(target, 2, 6)
			end
		end
	elseif msg:find("spell:235059") then
		self:Unschedule(handleMissingEmote)
		self.vb.singularityCount = self.vb.singularityCount + 1
		timerRupturingSingularity:Start(9.7, self.vb.singularityCount)
		if self.vb.phase == 1.5 then
			if self:IsMythic() then
				if self.vb.singularityCount == 1 or self.vb.singularityCount == 3 or self.vb.singularityCount == 7 then
					--Only show warning at start of each set
					warnSingularitySoon:Countdown(9.7, 3)
					specWarnRupturingSingularity:Show()
					specWarnRupturingSingularity:Play("carefly")
				end
				local timer = phase1point5MythicSingularityTimers[self.vb.singularityCount+1]
				if timer then
					self:Schedule(timer+2, handleMissingEmote, self)
					timerRupturingSingularityCD:Start(timer, self.vb.singularityCount+1)
				end
			else
				warnSingularitySoon:Countdown(9.7, 3)
				specWarnRupturingSingularity:Show()
				specWarnRupturingSingularity:Play("carefly")
				if self.vb.singularityCount == 1 then
					timerRupturingSingularityCD:Start(30, self.vb.singularityCount+1)
				end
			end
		elseif self.vb.phase == 2 then
			warnSingularitySoon:Countdown(9.7, 3)
			specWarnRupturingSingularity:Show()
			specWarnRupturingSingularity:Play("carefly")
			local timer = self:IsMythic() and phase2MythicSingularityTimers[self.vb.singularityCount+1] or self:IsHeroic() and phase2HeroicSingularityTimers[self.vb.singularityCount+1] or self:IsNormal() and phase2NormalSingularityTimers[self.vb.singularityCount+1]
			if timer then
				timerRupturingSingularityCD:Start(timer, self.vb.singularityCount+1)
			end
		elseif self.vb.phase == 2.5 then--Second phase transition Mythic Only
			warnSingularitySoon:Countdown(9.7, 3)
			specWarnRupturingSingularity:Show()
			specWarnRupturingSingularity:Play("carefly")
			if self.vb.singularityCount == 1 then
				timerRupturingSingularityCD:Start(10, 2)
			end
		else--Phase 1
			warnSingularitySoon:Countdown(9.7, 3)
			specWarnRupturingSingularity:Show()
			specWarnRupturingSingularity:Play("carefly")
			if self:IsMythic() then
				local timer = phase1MythicSingularityTimers[self.vb.singularityCount+1]
				if timer then
					timerRupturingSingularityCD:Start(timer, self.vb.singularityCount+1)
				end
			elseif self:IsEasy() then
				timerRupturingSingularityCD:Start(80, self.vb.singularityCount+1)
			else
				timerRupturingSingularityCD:Start(55, self.vb.singularityCount+1)
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 121193 then--Shadowsoul
		--Do more with when 5 count confirmed in more difficulties or all normal sizes
		self.vb.shadowSoulsRemaining = self.vb.shadowSoulsRemaining - 1
	elseif cid == 119107 then--Tank Add
		timerSorrowfulWailCD:Stop()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 242377 then--Kil'jaeden Take Off Sound (intermission 1)
		self.vb.phase = 1.5
		self.vb.armageddonCast = 0
		self.vb.focusedDreadCast = 0
		self.vb.burstingDreadCast = 0
		self.vb.singularityCount = 0
		timerFelclawsCD:Stop()
		timerRupturingSingularityCD:Stop()
		timerArmageddonCD:Stop()
		timerShadReflectionEruptingCD:Stop()
		timerShadReflectionWailingCD:Stop()
		warnPhase2:Play("phasechange")
		if self:IsMythic() then
			timerArmageddonCD:Start(6.7, 1)
			timerBurstingDreadflameCD:Start(11, 1)
			timerRupturingSingularityCD:Start(14.7, 1)
			timerFocusedDreadflameCD:Start(31.8, 1)
			timerTransition:Start(95.1)
		else
			if self:IsLFR() then
				timerArmageddonCD:Start(6.4, 1)
				timerBurstingDreadflameCD:Start(7.7, 1)
			else
				timerArmageddonCD:Start(7.0, 1)
				timerBurstingDreadflameCD:Start(8.7, 1)
				if not self:IsNormal() then
					timerRupturingSingularityCD:Start(14.2, 1)
				end
				timerFocusedDreadflameCD:Start(24.7, 1)
			end
			timerTransition:Start(57.9)
		end
	elseif spellId == 244856 and self:AntiSpam(5, 3) then--Flaming Orb (more likely than combat log. this spell looks like it's entirely scripted)
		self.vb.orbCount = self.vb.orbCount + 1
		specWarnFlamingOrbSpawn:Show(self.vb.orbCount)
		specWarnFlamingOrbSpawn:Play("watchstep")
		specWarnFlamingOrbSpawn:ScheduleVoice(1, "runout")
		if self:IsMythic() then
			--"Flaming Orb-244856-npc:117269 = pull:20.1, 15.0, 16.0, 64.0, 15.0, 16.0", -- [1]
			if self.vb.orbCount % 3 == 0 then
				timerFlamingOrbCD:Start(64, self.vb.orbCount+1)
			else
				timerFlamingOrbCD:Start(15, self.vb.orbCount+1)--15-16
			end
		else
			if self.vb.orbCount % 2 == 0 then
				timerFlamingOrbCD:Start(64, self.vb.orbCount+1)
			else
				timerFlamingOrbCD:Start(31, self.vb.orbCount+1)
			end
		end
	end
end

local mod	= DBM:NewMod(1725, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(104415)--104731 (Depleted Time Particle). 104676 (Waning Time Particle). 104491 (Accelerated Time particle). 104492 (Slow Time Particle)
mod:SetEncounterID(1865)
--mod:SetUsedIcons(5, 4, 3, 2, 1)--sometimes it was 5 targets, sometimes it was whole raid. even post nerf. have to see
mod:SetHotfixNoticeRev(15910)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 211927 207228",
	"SPELL_CAST_SUCCESS 219815",
	"SPELL_AURA_APPLIED 206617 206607 212099",
	"SPELL_AURA_APPLIED_DOSE 206607 219823",
	"SPELL_AURA_REMOVED 206617",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5",
	"UNIT_SPELLCAST_CHANNEL_STOP boss1 boss2 boss3 boss4 boss5",
	"UNIT_SPELLCAST_STOP boss1 boss2 boss3 boss4 boss5"
)

--TODO, More data to complete sequences of timers on LFR/Heroic/Normal
--(ability.id = 206618 or ability.id = 206610 or ability.id = 206614) and type = "cast" or ability.id = 211927
local warnNormal					= mod:NewCountAnnounce(207012, 2)
local warnFast						= mod:NewCountAnnounce(207013, 2)
local warnSlow						= mod:NewCountAnnounce(207011, 2)
local warnTimeBomb					= mod:NewTargetAnnounce(206617, 3)
local warnChronometricPart			= mod:NewStackAnnounce(206607, 3, nil, "Tank")
local warnPowerOverwhelmingStack	= mod:NewStackAnnounce(219823, 2)
local warnTemporalCharge			= mod:NewTargetAnnounce(212099, 1)

local specWarnTemporalOrbs			= mod:NewSpecialWarningDodge(219815, nil, nil, nil, 2, 2)
local specWarnPowerOverwhelming		= mod:NewSpecialWarningSpell(211927, nil, nil, 2, 2, 2)
local specWarnTimeBomb				= mod:NewSpecialWarningMoveAway(206617, nil, nil, 2, 3, 2)--When close to expiring, not right away
local yellTimeBomb					= mod:NewFadesYell(206617)
local specWarnWarp					= mod:NewSpecialWarningInterrupt(207228, "HasInterrupt", nil, nil, 1, 2)
local specWarnBigAdd				= mod:NewSpecialWarningSwitch("ej13022", "-Healer", nil, nil, 1, 2)--Switch to waning time particle when section info known

local timerTemporalOrbsCD			= mod:NewNextCountTimer(30, 219815, nil, nil, nil, 2)
local timerPowerOverwhelmingCD		= mod:NewNextCountTimer(60, 211927, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerTimeBomb					= mod:NewBuffFadesTimer(30, 206617, nil, nil, nil, 5, nil, nil, nil, 3, 4)
local timerTimeBombCD				= mod:NewNextCountTimer(30, 206617, nil, nil, nil, 3)
local timerBurstofTimeCD			= mod:NewNextCountTimer(30, 206614, nil, nil, nil, 3)
local timerTimeReleaseCD			= mod:NewNextCountTimer(30, 206610, nil, "Healer", nil, 5, nil, DBM_COMMON_L.HEALER_ICON)
local timerChronoPartCD				= mod:NewCDTimer(5, 206607, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerBigAddCD					= mod:NewNextCountTimer(30, 206700, nil, nil, nil, 1, nil, nil, nil, 1, 4)--Switch to waning time particle when section info known
local timerNextPhase				= mod:NewPhaseTimer(74)--Used anywhere phase change is NOT immediately after power overwhelming

mod:AddRangeFrameOption(10, 206617)
mod:AddInfoFrameOption(206610)
mod:AddDropdownOption("InfoFrameBehavior", {"TimeRelease", "TimeBomb"}, "TimeRelease", "misc")

mod.vb.normCount = 0
mod.vb.fastCount = 0
mod.vb.slowCount = 0
mod.vb.currentPhase = 2
mod.vb.interruptCount = 0
mod.vb.timeBombDebuffCount = 0
local timeBombDebuff = DBM:GetSpellInfo(206617)
local timeRelease = DBM:GetSpellInfo(206610)
local function updateTimeBomb(self)
	local _, _, _, _, _, expires = DBM:UnitDebuff("player", timeBombDebuff)
	if expires then
		specWarnTimeBomb:Cancel()
		specWarnTimeBomb:CancelVoice()
		timerTimeBomb:Stop()
		yellTimeBomb:Cancel()
		local debuffTime = expires - GetTime()
		specWarnTimeBomb:Schedule(debuffTime - 5)	-- Show "move away" warning 5secs before explode
		specWarnTimeBomb:ScheduleVoice(debuffTime - 5, "runout")
		timerTimeBomb:Start(debuffTime)
		yellTimeBomb:Schedule(debuffTime-1, 1)
		yellTimeBomb:Schedule(debuffTime-2, 2)
		yellTimeBomb:Schedule(debuffTime-3, 3)
	end
end

function mod:OnCombatStart(delay)
	self.vb.currentPhase = 2
	self.vb.interruptCount = 0
	self.vb.normCount = 0
	self.vb.fastCount = 0
	self.vb.slowCount = 0
	self.vb.timeBombDebuffCount = 0
	if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "TimeRelease" then
		DBM.InfoFrame:SetHeader(timeRelease)
		DBM.InfoFrame:Show(10, "playerabsorb", timeRelease)
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
	if spellId == 211927 then
		timerChronoPartCD:Stop()--Will be used immediately when this ends.
		specWarnPowerOverwhelming:Show()
		specWarnPowerOverwhelming:Play("aesoon")
	elseif spellId == 207228 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnWarp:Show(args.sourceName)
		specWarnWarp:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 219815 then
		specWarnTemporalOrbs:Show()
		specWarnTemporalOrbs:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 206617 then
		self.vb.timeBombDebuffCount = self.vb.timeBombDebuffCount + 1
		warnTimeBomb:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			updateTimeBomb(self)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() and self.Options.InfoFrameBehavior == "TimeBomb" then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(10, "playerdebuffremaining", args.spellName)
		end
	elseif spellId == 206607 then
		local amount = args.amount or 1
		warnChronometricPart:Show(args.destName, amount)
		timerChronoPartCD:Start()--Move timer to success if this can be avoided
	elseif spellId == 219823 then
		local amount = args.amount or 1
		warnPowerOverwhelmingStack:Show(args.destName, amount)
	elseif spellId == 212099 and args:IsDestTypePlayer() then
		warnTemporalCharge:Show(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 206617 then
		self.vb.timeBombDebuffCount = self.vb.timeBombDebuffCount - 1
		if args:IsPlayer() then
			specWarnTimeBomb:Cancel()
			specWarnTimeBomb:CancelVoice()
			timerTimeBomb:Stop()
			yellTimeBomb:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
		if self.Options.InfoFrame and self.vb.timeBombDebuffCount == 0 and self.Options.InfoFrameBehavior == "TimeBomb" then
			DBM.InfoFrame:Hide()
		end
	end
end

local function delayedBurst(self, time, count)
	timerBurstofTimeCD:Start(time, count)
end
local function delayedTimeRelease(self, time, count)
	timerTimeReleaseCD:Start(time, count)
end
local function delayedTimeBomb(self, time, count)
	timerTimeBombCD:Start(time, count)
end
local function delayedOrbs(self, time, count)
	timerTemporalOrbsCD:Start(time, count)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 207012 then--Speed: Normal
		self.vb.currentPhase = 2
		self.vb.interruptCount = 0
		self.vb.normCount = self.vb.normCount + 1
		warnNormal:Show(self.vb.normCount)
		if self.vb.normCount == 1 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeBombCD:Start(5, 1)
				timerTimeReleaseCD:Start(10, 1)
				timerNextPhase:Start(12)
			elseif self:IsHeroic() then--UPDATED Jan 18
				timerTimeReleaseCD:Start(5, 1)
				self:Schedule(5, delayedTimeRelease, self, 13, 2)--18
				timerBigAddCD:Start(23, 1)
				timerTimeBombCD:Start(28, 1)
				self:Schedule(28, delayedTimeBomb, self, 5, 2)--33
				timerTemporalOrbsCD:Start(38, 1)
				self:Schedule(30, delayedTimeRelease, self, 13, 3)--43
				timerPowerOverwhelmingCD:Start(53, 1)
			elseif self:IsNormal() then--Updated Jan 17
				timerTimeReleaseCD:Start(5, 1)
				self:Schedule(5, delayedTimeRelease, self, 15, 2)--20
				timerBigAddCD:Start(28, 1)
				timerTimeBombCD:Start(35, 1)
				timerTemporalOrbsCD:Start(48, 1)
				timerPowerOverwhelmingCD:Start(84, 1)
			else--LFR

			end
		elseif self.vb.normCount == 2 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeReleaseCD:Start(2, 1)
				timerTemporalOrbsCD:Start(7, 1)
				timerTimeBombCD:Start(12, 1)
				timerPowerOverwhelmingCD:Start(17, 1)
			elseif self:IsHeroic() then--Updated May 26 2017
				timerTimeBombCD:Start(5, 1)
				timerTemporalOrbsCD:Start(10, 1)
				self:Schedule(5, delayedTimeBomb, self, 10, 2)--15
				timerBigAddCD:Start(20, 1)
				self:Schedule(15, delayedTimeBomb, self, 10, 3)--25
				timerTimeReleaseCD:Start(30, 1)
				self:Schedule(10, delayedOrbs, self, 25, 2)--35
				self:Schedule(30, delayedTimeRelease, self, 20, 2)--50
				self:Schedule(50, delayedTimeRelease, self, 7, 3)--57
				self:Schedule(35, delayedOrbs, self, 30, 3)--65
				timerPowerOverwhelmingCD:Start(72, 1)
				--Triggers special extention phase after interrupt
			elseif self:IsNormal() then
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.normCount == 3 then
			if self:IsMythic() then--Updated Jan 25
				timerTemporalOrbsCD:Start(2, 1)
				timerTimeBombCD:Start(7, 1)
				timerNextPhase:Start(12)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.normCount == 4 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeBombCD:Start(2, 1)
				timerNextPhase:Start(5)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		else
			DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
		end
		updateTimeBomb(self)
		self:Schedule(2, updateTimeBomb, self)
		self:Schedule(5, updateTimeBomb, self)
	elseif spellId == 207011 then--Speed: Slow
		self.vb.currentPhase = 1
		self.vb.interruptCount = 0
		self.vb.slowCount = self.vb.slowCount + 1
		warnSlow:Show(self.vb.slowCount)
		if self.vb.slowCount == 1 then
			if self:IsMythic() then--Updated Jan 25
				timerTemporalOrbsCD:Start(8, 1)
				timerTimeReleaseCD:Start(13, 1)
				timerTimeBombCD:Start(16, 1)
				self:Schedule(13, delayedTimeRelease, self, 10, 2)--23
				timerPowerOverwhelmingCD:Start(28, 1)
			elseif self:IsHeroic() then--Updated Jan 18
				timerTimeReleaseCD:Start(10, 1)
				timerTimeBombCD:Start(15, 1)
				timerTemporalOrbsCD:Start(20, 1)
				self:Schedule(10, delayedTimeBomb, self, 15, 2)--25
				self:Schedule(5, delayedTimeRelease, self, 25, 2)--30
				self:Schedule(25, delayedTimeBomb, self, 10, 3)--35
				self:Schedule(20, delayedOrbs, self, 18, 2)--38
				self:Schedule(25, delayedTimeBomb, self, 15, 3)--40
				timerBigAddCD:Start(43, 1)
				self:Schedule(38, delayedOrbs, self, 7, 3)--45
				timerPowerOverwhelmingCD:Start(55, 1)
			elseif self:IsNormal() then--Updated Jan 17
				timerTimeReleaseCD:Start(5, 1)
				timerTimeBombCD:Start(20, 1)
				self:Schedule(5, delayedTimeRelease, self, 23, 2)--28
				timerTemporalOrbsCD:Start(30, 1)
				timerBigAddCD:Start(38, 1)
				timerPowerOverwhelmingCD:Start(90, 1)
			else--LFR

			end
		elseif self.vb.slowCount == 2 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeBombCD:Start(2, 1)
				timerTimeReleaseCD:Start(7, 1)
				timerBigAddCD:Start(9, 1)
				timerTemporalOrbsCD:Start(14, 1)
				timerPowerOverwhelmingCD:Start(19, 1)
			elseif self:IsHeroic() then--Updated May 26, 2017
				timerTimeReleaseCD:Start(5, 1)
				timerTemporalOrbsCD:Start(15, 1)
				timerTimeBombCD:Start(20, 1)
				self:Schedule(20, delayedTimeBomb, self, 5, 2)--25
				self:Schedule(25, delayedTimeBomb, self, 5, 2)--30
				timerPowerOverwhelmingCD:Start(35, 1)
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.slowCount == 3 then
			if self:IsMythic() then
				timerTemporalOrbsCD:Start(5, 1)
				timerTimeBombCD:Start(7, 1)
				timerPowerOverwhelmingCD:Start(9, 1)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.slowCount == 4 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeReleaseCD:Start(5, 1)
				timerTemporalOrbsCD:Start(15, 1)
				timerTimeBombCD:Start(20, 1)
				self:Schedule(15, delayedOrbs, self, 10, 2)--25
				timerPowerOverwhelmingCD:Start(30, 1)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		else--Slow 5
			if self:IsMythic() then--Updated Jan 25
				timerTimeReleaseCD:Start(2, 1)
				timerTimeBombCD:Start(3, 1)
				timerPowerOverwhelmingCD:Start(8, 1)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		end
		updateTimeBomb(self)
		self:Schedule(2, updateTimeBomb, self)
		self:Schedule(5, updateTimeBomb, self)
	elseif spellId == 207013 then--Speed: Fast
		self.vb.currentPhase = 3
		self.vb.interruptCount = 0
		self.vb.fastCount = self.vb.fastCount + 1
		warnFast:Show(self.vb.fastCount)
		if self.vb.fastCount == 1 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeReleaseCD:Start(5, 1)
				timerBigAddCD:Start(7, 1)
				timerTemporalOrbsCD:Start(12, 1)
				timerPowerOverwhelmingCD:Start(22, 1)
			elseif self:IsHeroic() then--Updated May 26, 2017
				timerTimeReleaseCD:Start(5, 1)
				self:Schedule(5, delayedTimeRelease, self, 7, 2)--12
				timerTimeBombCD:Start(17, 1)
				self:Schedule(12, delayedTimeRelease, self, 13, 3)--25
				self:Schedule(25, delayedTimeRelease, self, 5, 4)--30
				self:Schedule(30, delayedTimeRelease, self, 5, 5)--35
				timerBigAddCD:Start(38, 1)
				self:Schedule(35, delayedTimeRelease, self, 8, 6)--43
				timerPowerOverwhelmingCD:Start(50, 1)
			elseif self:IsNormal() then--Normal confirmed
				timerTimeReleaseCD:Start(10, 1)
				timerTemporalOrbsCD:Start(15, 1)
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.fastCount == 2 then
			if self:IsMythic() then--Updated Feb 15
				timerTimeReleaseCD:Start(5, 1)
				self:Schedule(5, delayedTimeRelease, self, 5, 2)--10
				self:Schedule(10, delayedTimeRelease, self, 5, 3)--15
				self:Schedule(15, delayedTimeRelease, self, 5, 4)--20
				timerBigAddCD:Start(23, 1)
				timerTemporalOrbsCD:Start(25, 1)
				timerPowerOverwhelmingCD:Start(30, 1)
			elseif self:IsHeroic() then--Updated Dec 2
				timerTemporalOrbsCD:Start(10, 1)
				self:Schedule(10, delayedOrbs, self, 15, 2)--25
				timerTimeBombCD:Start(30, 1)
				timerTimeReleaseCD:Start(40, 1)
				timerPowerOverwhelmingCD:Start(45, 1)
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.fastCount == 3 then
			if self:IsMythic() then--Updated Feb 15
				timerTimeReleaseCD:Start(5, 1)
				self:Schedule(5, delayedTimeRelease, self, 5, 2)--10
				self:Schedule(10, delayedTimeRelease, self, 5, 3)--15
				self:Schedule(15, delayedTimeRelease, self, 5, 4)--20
				timerTemporalOrbsCD:Start(23, 1)
				timerBigAddCD:Start(25, 1)
				timerPowerOverwhelmingCD:Start(30, 1)
			elseif self:IsHeroic() then--Updated Dec 2
				--Goes into Full Power here?
				--DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else--LFR

			end
		elseif self.vb.fastCount == 4 then
			if self:IsMythic() then--Updated Jan 25
				timerTimeReleaseCD:Start(5, 1)
				timerNextPhase:Start(8)
			elseif self:IsHeroic() then--Probably changed.
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			elseif self:IsNormal() then--Normal confirmed
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			else
				DBM:AddMsg("There is no timer data going this far into the fight. Please submit transcriptor log to improve this mod")
			end
		else--LFR

		end
		updateTimeBomb(self)
		self:Schedule(2, updateTimeBomb, self)
		self:Schedule(5, updateTimeBomb, self)
	elseif spellId == 206700 then--Summon Slow Add (Big Adds)
		specWarnBigAdd:Show()
		specWarnBigAdd:Play("bigmobsoon")
	elseif spellId == 207972 then--Full Power, he's just gonna run in circles aoeing the raid and stop using abilities
		timerBigAddCD:Stop()
		timerTemporalOrbsCD:Stop()
		timerPowerOverwhelmingCD:Stop()
		timerTimeReleaseCD:Stop()
		timerTimeBombCD:Stop()
		timerBurstofTimeCD:Stop()
		timerNextPhase:Stop()
		self:Unschedule(delayedTimeRelease)
		self:Unschedule(delayedTimeBomb)
		self:Unschedule(delayedBurst)
		self:Unschedule(delayedOrbs)
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(uId, _, spellId)
	if spellId == 211927 then--Power Overwhelming
		self.vb.interruptCount = self.vb.interruptCount + 1
		if self.vb.currentPhase == 1 then--slow
			if self.vb.normCount == 2 then
				if self:IsMythic() then--Updated Jan 25
					timerTimeReleaseCD:Start(5, 1)
					timerNextPhase:Start(8)
				elseif self:IsNormal() then
					--timerBurstofTimeCD:Start(5, 2)
					--self:Schedule(5, delayedBurst, self, 5, 3)--10
					--timerTimeReleaseCD:Start(18, 2)
					--timerTimeBombCD:Start(25, 1)
					--timerNextPhase:Start(30)
				end
			end
		elseif self.vb.currentPhase == 2 then--normal
			if self.vb.normCount == 2 then
				if self:IsMythic() then--Updated Jan 25
					timerTimeBombCD:Start(3, 2)
					timerTemporalOrbsCD:Start(6, 2)
					timerNextPhase:Start(9)
				elseif self:IsHeroic() then--Updated May 26 2017
					timerTimeReleaseCD:Start(5, 1)
					timerNextPhase:Start(10)
				elseif self:IsNormal() then
					--timerTimeReleaseCD:Start(5, 3)
					--timerNextPhase:Start(10)
				else--LFR
					--timerTimeReleaseCD:Start(10, 3)
					--timerNextPhase:Start(15)
				end
			end
		end
	end
end
mod.UNIT_SPELLCAST_STOP = mod.UNIT_SPELLCAST_CHANNEL_STOP

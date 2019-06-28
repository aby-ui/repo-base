local mod	= DBM:NewMod(1392, "DBM-HellfireCitadel", nil, 669)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(90435)
mod:SetEncounterID(1787)
mod:SetZone()
--mod:SetUsedIcons(8, 7, 6, 4, 2, 1)
mod.respawnTime = 18--18 is an odd one, but definitely was 18

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 181292 181293 181296 181297 181299 181300 180244 181305",
	"SPELL_CAST_SUCCESS 181307 181299 181300",
	"SPELL_AURA_APPLIED 181306 186882 180115 180116 180117 189197 189198 189199 186879 186880 186881",
	"SPELL_AURA_REMOVED 181306 180244"
)

--(ability.id = 181292 or ability.id = 181293 or ability.id = 181296 or ability.id = 181297 or ability.id = 181299 or ability.id = 181300 or ability.id = 180244 or ability.id = 181305) and type = "begincast" or ability.id = 181307 and type = "cast" or (ability.id = 181306 or ability.id = 180115 or ability.id = 180116 or ability.id = 180117 or ability.id = 189197 or ability.id = 189198 or ability.id = 189199 or ability.id = 186882 or ability.id = 186879 or ability.id = 186880 or ability.id = 186881) and (type = "applybuff" or type = "applydebuff")
--TODO, other voices, once ability importance is assessed.
local warnShadowEnergy				= mod:NewSpellAnnounce(180115, 2)
local warnExplosiveEnergy			= mod:NewSpellAnnounce(180116, 3)--This one looks more dangerous than other 2, because it enables the Explosive Runes ability
local warnFoulEnergy				= mod:NewSpellAnnounce(180117, 2)
--These are probably temp, changed to better tank special warnings when better understood
local warnExplosiveBurst			= mod:NewTargetCountAnnounce(181306, 4)--Concerns everyone
local warnEnrage					= mod:NewSpellAnnounce(186882, 3)

local specWarnPound					= mod:NewSpecialWarningCount(180244, nil, nil, nil, 2, 2)
local specWarnSwat					= mod:NewSpecialWarningCount(181305, "Tank", nil, nil, 1, 2)
local specWarnExplosiveBurst		= mod:NewSpecialWarningYouCount(181306)
local yellExplosiveBurst			= mod:NewYell(181306)
local specWarnExplosiveBurstNear	= mod:NewSpecialWarningClose(181306, nil, nil, nil, 3, 2)
local specWarnFoulCrush				= mod:NewSpecialWarningSwitch(181307, "Dps|Tank")--Tweak it as needed once can figure out how to detect what tank it's on
local specWarnFelOutpouring			= mod:NewSpecialWarningDodge(181292, nil, nil, nil, 2, 2)
local specWarnExplosiveRunes		= mod:NewSpecialWarningSpell(181296, "-Tank")--Leaving as a spell warning, MoveTo gives misleading info that everyone just runs toward them, only a few do who know what to do
local specWarnGraspingHands			= mod:NewSpecialWarningSwitch(181299)
--Empowered versions (made separate so users can set different sounds for the more dangerous versions if they choose)
local specWarnEmpFelOutpouring		= mod:NewSpecialWarningDodge(181293, nil, nil, nil, 2, 2)
local specWarnEmpExplosiveRunes		= mod:NewSpecialWarningSpell(181297, "-Tank")
local specWarnDraggingHands			= mod:NewSpecialWarningSwitch(181300)

local timerLeapCD					= mod:NewPhaseTimer(113.5)--Not techincally a leap timer, timer syncs up to when he gains next buff (leap ended)
--Times here are not relevant, they are all hard coded orders based on what buff boss has, real values are under 3 different phases
local timerPoundCD					= mod:NewNextCountTimer(42, 180244, nil, nil, nil, 2)
local timerFelOutpouringCD			= mod:NewNextTimer(107, 181292, nil, nil, nil, 2)
local timerExplosiveRunesCD			= mod:NewNextTimer(48, 181296, nil, nil, nil, 5)
local timerGraspingHandsCD			= mod:NewNextTimer(107, 181299, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON, nil, 1, 4)
--Tank Debuffs. These are also hard coded, but in different place.
mod:AddTimerLine(TANK)
local timerExplosiveBurstCD			= mod:NewNextCountTimer(40, 181306, nil, nil, nil, 3, nil, nil, nil, 2, 4)--Everyone needs to know these 2
local timerFoulCrushCD				= mod:NewNextCountTimer(40, 181307, nil, nil, nil, 1)--Everyone needs to know these 2
local timerSwatCD					= mod:NewNextCountTimer(40, 181305, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)

--local berserkTimer				= mod:NewBerserkTimer(360)--Was 8 min on heroic PTR, but that also might have been a bug so will wait to confirm

mod:AddRangeFrameOption("4/40")

mod.vb.explodingTank = nil
mod.vb.poundActive = false
mod.vb.poundCount = 0
mod.vb.explosiveBurst = 0
mod.vb.foulCrush = 0
mod.vb.swatCount = 0
mod.vb.enraged = false
local debuffName = DBM:GetSpellInfo(181306)
local playerName = UnitName("player")

local debuffFilter
do
	debuffFilter = function(uId)
		if DBM:UnitDebuff(uId, debuffName) then
			return true
		end
	end
end

local function updateRangeCheck(self, force)
	if not self.Options.RangeFrame then return end
	if self.vb.explodingTank then
		if DBM:UnitDebuff("player", debuffName) then
			DBM.RangeCheck:Show(30)
		elseif not self:CheckNearby(31, self.vb.explodingTank) and self.vb.poundActive then--far enough from tank and pound is active, switch back to 4
			DBM.RangeCheck:Show(4)
		else--No pound, tank still active, keep filtered radar up to prevent walking back into tank
			DBM.RangeCheck:Show(30, debuffFilter)
		end
	elseif self.vb.poundActive or force then--Just pound, no tank debuff.
		DBM.RangeCheck:Show(4)
	else
		DBM.RangeCheck:Hide()
	end
end

local function trippleBurstCheck(self, target, first)
	if self:CheckNearby(31, target) then--Second and third check will use smaller range
		specWarnExplosiveBurstNear:Show(target)
		specWarnExplosiveBurstNear:Play("justrun")
	end
	if first then
		self:Schedule(2.5, trippleBurstCheck, self, target)
	end
	updateRangeCheck(self)
end

function mod:OnCombatStart(delay)
	self.vb.explodingTank = nil
	self.vb.poundActive = false
	self.vb.poundCount = 0
	self.vb.enraged = false
	timerLeapCD:Start(12-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end 

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 181292 or spellId == 181293 then
		if spellId == 181293 then
			specWarnEmpFelOutpouring:Show()
			specWarnEmpFelOutpouring:Play("watchwave")
		else
			specWarnFelOutpouring:Show()
			specWarnFelOutpouring:Play("watchwave")
		end
	elseif spellId == 181296 or spellId == 181297 then
		if spellId == 181297 then
			specWarnEmpExplosiveRunes:Show()
		else
			specWarnExplosiveRunes:Show()
		end
	elseif spellId == 181299 or spellId == 181300 then
		if spellId == 181300 then
			specWarnDraggingHands:Show()
		else
			specWarnGraspingHands:Show()
		end
		updateRangeCheck(self, true)
	elseif spellId == 180244 then
		self.vb.poundActive = true
		self.vb.poundCount = self.vb.poundCount + 1
		specWarnPound:Show(self.vb.poundCount)
		specWarnPound:Play("scatter")
		updateRangeCheck(self)
	elseif spellId == 181305 then
		self.vb.swatCount = self.vb.swatCount + 1
		specWarnSwat:Show(self.vb.swatCount)
		specWarnSwat:Play("carefly")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 181307 then
		self.vb.foulCrush = self.vb.foulCrush + 1
		specWarnFoulCrush:Show(self.vb.foulCrush)
	elseif spellId == 181299 or spellId == 181300 then
		updateRangeCheck(self)
	end
end

local function delayedPound(self, time)
	timerPoundCD:Start(time, 2)
end

local function delayedExplosiveRunes(self, time)
	timerExplosiveRunesCD:Start(time)
end

local function delayedHands(self, time)
	timerGraspingHandsCD:Start(time)
	if not self:IsMythic() then
		specWarnGraspingHands:CancelVoice()
		specWarnGraspingHands:ScheduleVoice(time-5, "gather")
	end
end

local function delayedFelOutpouring(self, time)
	timerFelOutpouringCD:Start(time)
end

local function delayedSwat(self, time, count)
	timerSwatCD:Start(time, count)
end

local function delayedFowlCrush(self, time, count)
	timerFoulCrushCD:Start(time, count)
end

local function delayedExplosiveBurst(self, time, count)
	timerExplosiveBurstCD:Start(time, count)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 181306 then
		self.vb.explosiveBurst = self.vb.explosiveBurst + 1
		self.vb.explodingTank = args.destName
		if args:IsPlayer() then
			specWarnExplosiveBurst:Show(self.vb.explosiveBurst)
			specWarnExplosiveBurst:Play("targetyou")
			yellExplosiveBurst:Yell()
		else
			if self:CheckNearby(30, args.destName) then
				specWarnExplosiveBurstNear:Show(args.destName)
				specWarnExplosiveBurstNear:Play("runout")
			else
				warnExplosiveBurst:Show(self.vb.explosiveBurst, args.destName)
			end
			--Check player distance 3x, like mark of chaos, don't let players run INTO it after they are safe
			self:Schedule(3, trippleBurstCheck, self, args.destName, true)
		end
		updateRangeCheck(self)
	--Each energy has it's own hard coded sequence of events/timers.
	--So all timers need to be scheduled here, they aren't started by any ability casts
	elseif spellId == 180115 or spellId == 186879 then--Shadow Energy (186879 enraged version)
		self.vb.poundCount = 0
		self.vb.swatCount = 0
		warnShadowEnergy:Show()
		self:Unschedule(delayedPound)
		self:Unschedule(delayedExplosiveRunes)
		self:Unschedule(delayedHands)
		self:Unschedule(delayedFelOutpouring)
		self:Unschedule(delayedSwat)
		self:Unschedule(delayedFowlCrush)
		self:Unschedule(delayedExplosiveBurst)
		if self:IsMythic() and spellId == 186879 then--Mythic AND enraged
			timerFelOutpouringCD:Start(8)
			self:Schedule(8, delayedFelOutpouring, self, 65)--73
			timerSwatCD:Start(23, 1)
			self:Schedule(23, delayedSwat, self, 23, 2)
			self:Schedule(46, delayedSwat, self, 23, 3)
			timerPoundCD:Start(26, 1)
			self:Schedule(26, delayedPound, self, 30)--57
			timerExplosiveRunesCD:Start(39)
			timerGraspingHandsCD:Start(50)
			timerLeapCD:Start(96)
		elseif (self:IsMythic() and spellId == 180115) or spellId == 186879 then--Mythic regular, or heroic/normal enrage
			timerFelOutpouringCD:Start(11)
			self:Schedule(11, delayedFelOutpouring, self, 84)--95
			timerSwatCD:Start(31, 1)
			self:Schedule(31, delayedSwat, self, 32, 2)
			self:Schedule(53, delayedSwat, self, 32, 3)
			timerPoundCD:Start(37, 1)
			self:Schedule(37, delayedPound, self, 48)--85
			timerExplosiveRunesCD:Start(53)
			timerGraspingHandsCD:Start(69)
			timerLeapCD:Start()
		else
			timerFelOutpouringCD:Start(13)
			self:Schedule(13, delayedFelOutpouring, self, 100)--113
			timerSwatCD:Start(37, 1)
			self:Schedule(37, delayedSwat, self, 38, 2)
			self:Schedule(75, delayedSwat, self, 38, 3)
			timerPoundCD:Start(45, 1)
			self:Schedule(45, delayedPound, self, 50)--95
			timerExplosiveRunesCD:Start(63)
			specWarnGraspingHands:CancelVoice()
			specWarnGraspingHands:ScheduleVoice(78, "gather")
			timerGraspingHandsCD:Start(83)
			timerLeapCD:Start(135.5)
		end
	--Non LFR phase changes need reworking post mechanics changes.
	--Probably still mostly right but need minor tweaks
	elseif spellId == 180116 or spellId == 186880 then--Explosive Energy (186880 enrage version)
		self.vb.poundCount = 0
		self.vb.explosiveBurst = 0
		warnExplosiveEnergy:Show()
		self:Unschedule(delayedPound)
		self:Unschedule(delayedExplosiveRunes)
		self:Unschedule(delayedHands)
		self:Unschedule(delayedFelOutpouring)
		self:Unschedule(delayedSwat)
		self:Unschedule(delayedFowlCrush)
		self:Unschedule(delayedExplosiveBurst)
		if (self:IsMythic() and spellId == 186880) then
			timerExplosiveRunesCD:Start(8)
			self:Schedule(8, delayedExplosiveRunes, self, 63)--71
			timerExplosiveBurstCD:Start(15, 1)
			self:Schedule(15, delayedExplosiveBurst, self, 23, 2)
			self:Schedule(38, delayedExplosiveBurst, self, 30, 3)
			timerPoundCD:Start(19, 1)
			self:Schedule(19, delayedPound, self, 35)--54
			timerGraspingHandsCD:Start(35)
			timerFelOutpouringCD:Start(49)
			timerLeapCD:Start(96)
		elseif (self:IsMythic() and spellId == 180116) or spellId == 186880 then
			timerExplosiveRunesCD:Start(11)
			self:Schedule(11, delayedExplosiveRunes, self, 90)--101
			timerExplosiveBurstCD:Start(21, 1)
			self:Schedule(21, delayedExplosiveBurst, self, 32, 2)
			self:Schedule(53, delayedExplosiveBurst, self, 42, 3)
			timerPoundCD:Start(27, 1)
			self:Schedule(27, delayedPound, self, 42)--69
			timerGraspingHandsCD:Start(43)
			timerFelOutpouringCD:Start(59)
			timerLeapCD:Start()
		else
			timerExplosiveRunesCD:Start(13)
			self:Schedule(13, delayedExplosiveRunes, self, 108)--121
			timerExplosiveBurstCD:Start(25, 1)
			self:Schedule(25, delayedExplosiveBurst, self, 38, 2)
			self:Schedule(63, delayedExplosiveBurst, self, 50, 3)
			timerPoundCD:Start(33, 1)
			self:Schedule(33, delayedPound, self, 62)--95
			specWarnGraspingHands:CancelVoice()
			specWarnGraspingHands:ScheduleVoice(46, "gather")
			timerGraspingHandsCD:Start(51)
			timerFelOutpouringCD:Start(71)
			timerLeapCD:Start(135.5)
		end
	elseif spellId == 180117 or spellId == 186881 then--Foul Energy (186881 enrage version)
		self.vb.poundCount = 0
		self.vb.foulCrush = 0
		warnFoulEnergy:Show()
		self:Unschedule(delayedPound)
		self:Unschedule(delayedExplosiveRunes)
		self:Unschedule(delayedHands)
		self:Unschedule(delayedFelOutpouring)
		self:Unschedule(delayedSwat)
		self:Unschedule(delayedFowlCrush)
		self:Unschedule(delayedExplosiveBurst)
		if (self:IsMythic() and spellId == 186881) then
			timerGraspingHandsCD:Start(8)
			self:Schedule(8, delayedHands, self, 75)--83
			timerFoulCrushCD:Start(15, 1)
			self:Schedule(15, delayedFowlCrush, self, 31, 2)
			self:Schedule(46, delayedFowlCrush, self, 23, 3)
			timerPoundCD:Start(19, 1)
			self:Schedule(19, delayedPound, self, 43)--62
			timerFelOutpouringCD:Start(31)
			timerExplosiveRunesCD:Start(50)
			timerLeapCD:Start(96)
		elseif (self:IsMythic() and spellId == 180117) or spellId == 186881 then
			timerGraspingHandsCD:Start(11)
			self:Schedule(11, delayedHands, self, 90)--101
			timerFoulCrushCD:Start(21, 1)
			self:Schedule(21, delayedFowlCrush, self, 42, 2)
			self:Schedule(63, delayedFowlCrush, self, 32, 3)
			timerPoundCD:Start(27, 1)
			self:Schedule(27, delayedPound, self, 52)--79
			timerFelOutpouringCD:Start(43.5)
			timerExplosiveRunesCD:Start(69)
			timerLeapCD:Start()
		else
			specWarnGraspingHands:CancelVoice()
			specWarnGraspingHands:ScheduleVoice(8, "gather")
			timerGraspingHandsCD:Start(13)
			self:Schedule(13, delayedHands, self, 108)--121
			timerFoulCrushCD:Start(25, 1)
			self:Schedule(25, delayedFowlCrush, self, 50, 2)
			self:Schedule(75, delayedFowlCrush, self, 38, 3)
			timerPoundCD:Start(33, 1)
			self:Schedule(33, delayedPound, self, 62)--95
			timerFelOutpouringCD:Start(51)
			timerExplosiveRunesCD:Start(83)
			timerLeapCD:Start(135.5)
		end
	--LFR is an ENTIRELY different fight
	--Fortunately it's also different spellids for phase changes so easy separate rules
	elseif spellId == 189197 then--Shadow Energy
		--10 Outpouring, 40 pound, 55 outporing, 75 pound, 100 outpouring
		self.vb.poundCount = 0
		warnShadowEnergy:Show()
		timerFelOutpouringCD:Start(10)
		self:Schedule(10, delayedFelOutpouring, self, 45)--55
		self:Schedule(45, delayedFelOutpouring, self, 45)--100
		timerPoundCD:Start(40, 1)
		self:Schedule(40, delayedPound, self, 35)--75
		timerLeapCD:Start(124)
	elseif spellId == 189198 then--Explosive Energy
		--10 Runes, 30 pound, 45 runes, 55 pound, 80 runes
		self.vb.poundCount = 0
		warnExplosiveEnergy:Show()
		timerExplosiveRunesCD:Start(10)
		self:Schedule(10, delayedExplosiveRunes, self, 35)--45
		self:Schedule(45, delayedExplosiveRunes, self, 35)--80
		timerPoundCD:Start(30, 1)
		self:Schedule(30, delayedPound, self, 25)--55
		timerLeapCD:Start(93)
	elseif spellId == 189199 then--Foul Energy
		--10 grasping, 30 pound, 45 grasping, 55 pound, 80 grasping
		self.vb.poundCount = 0
		warnFoulEnergy:Show()
		timerGraspingHandsCD:Start(10)
		specWarnGraspingHands:CancelVoice()
		specWarnGraspingHands:ScheduleVoice(5, "gather")
		self:Schedule(10, delayedHands, self, 35)--45
		self:Schedule(45, delayedHands, self, 35)--80
		timerPoundCD:Start(30, 1)
		self:Schedule(30, delayedPound, self, 25)--55
		timerLeapCD:Start(93)
	elseif spellId == 186882 then
		self.vb.enraged = true
		warnEnrage:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 181306 then
		self.vb.explodingTank = nil
		self:Unschedule(trippleBurstCheck)
		updateRangeCheck(self)
	elseif spellId == 180244 then
		self.vb.poundActive = false
		updateRangeCheck(self)
	end
end

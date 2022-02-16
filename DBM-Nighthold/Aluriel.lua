local mod	= DBM:NewMod(1751, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(104881)
mod:SetEncounterID(1871)
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetHotfixNoticeRev(16075)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 213853 213567 213564 213852 212735 213083 212492 230504",
	"SPELL_CAST_SUCCESS 230403 212492 213275",
	"SPELL_AURA_APPLIED 213864 216389 213867 213869 212531 213148 213569 212587 230951 212647 215458",
	"SPELL_AURA_APPLIED_DOSE 212647 215458",
	"SPELL_AURA_REMOVED 213569 230951",
	"SPELL_PERIODIC_DAMAGE 212736 213278 213504 230414",
	"SPELL_PERIODIC_MISSED 212736 213278 213504 230414",
	"SPELL_DAMAGE 213520",
	"SPELL_MISSED 213520",
	"UNIT_AURA player",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 213853 or ability.id = 213567 or ability.id = 213564 or ability.id = 213852 or ability.id = 212735 or ability.id = 213275 or ability.id = 213390 or ability.id = 213083 or ability.id = 212492 or ability.id = 230951 or ability.id = 230504) and type = "begincast" or
ability.id = 230403 and type = "cast" or
(ability.id = 213864 or ability.id = 216389 or ability.id = 213867 or ability.id = 213869) and type = "applybuff" or
(ability.id = 212531 or ability.id = 213148) and type = "applydebuff" or
ability.id = 230951 and type = "removebuff" or ability.id = 230414
--]]
--Phases/General
local warnFrostPhase				= mod:NewSpellAnnounce(213864, 2, nil, nil, nil, nil, nil, 2)
local warnFirePhase					= mod:NewSpellAnnounce(213867, 2, nil, nil, nil, nil, nil, 2)
local warnArcanePhase				= mod:NewSpellAnnounce(213869, 2, nil, nil, nil, nil, nil, 2)
local warnAnnihilate				= mod:NewStackAnnounce(212492, 2, nil, "Tank")
--Debuffs
local warnMarkOfFrostChosen			= mod:NewTargetAnnounce(212531, 3)
local warnSearingBrandChosen		= mod:NewTargetAnnounce(213148, 3)
--Animate Specials Temp, to avoid spam
local warnFrozenTempest				= mod:NewCastAnnounce(213083, 4)
local warnArmageddon				= mod:NewAddsLeftAnnounce(213568, 2)
--Mythic
local warnFelSoul					= mod:NewSpellAnnounce(230951, 3)

local specWarnAnnihilate			= mod:NewSpecialWarningCount(212492, "Tank", nil, nil, 3, 2)
local specWarnAnnihilateOther		= mod:NewSpecialWarningTaunt(212492, nil, nil, nil, 1, 2)
--Debuffs
local specWarnMarkOfFrost			= mod:NewSpecialWarningYou(212531, nil, nil, nil, 1, 2)
local yellMarkofFrost				= mod:NewYell(212531)
local specWarnFrostbitten			= mod:NewSpecialWarningStack(212647, nil, 6, nil, nil, 1, 6)
local specWarnSearingBrand			= mod:NewSpecialWarningMoveAway(213148, nil, nil, nil, 1, 2)
local specWarnSearingBrandDodge		= mod:NewSpecialWarningDodge(213148, nil, nil, nil, 2, 6)
local specWarnArcaneOrb				= mod:NewSpecialWarningDodge(213519, nil, nil, nil, 2, 2)
--Detonates
local specWarnFrostdetonate			= mod:NewSpecialWarningMoveAway(212735, nil, nil, nil, 3, 2)
local yellFrostDetonate				= mod:NewYell(212735, 29870)--29870 "Detonate" short name
local specWarnFireDetonate			= mod:NewSpecialWarningMoveAway(213275, nil, nil, nil, 3, 2)
local yellFireDetonate				= mod:NewYell(213275, 29870)--29870 "Detonate" short name
local specWarnArcaneDetonate		= mod:NewSpecialWarningDodge(213390, nil, nil, nil, 3, 2)
--GTFOs
local specWarnPoolOfFrost			= mod:NewSpecialWarningMove(212736, nil, nil, nil, 1, 2)
local specWarnBurningGround			= mod:NewSpecialWarningMove(213278, nil, nil, nil, 1, 2)
local specWarnArcaneFog				= mod:NewSpecialWarningMove(213504, nil, nil, nil, 1, 2)--Fog and orbs combined for simplicity
local specWarnFelStomp				= mod:NewSpecialWarningMove(230414, nil, nil, nil, 1, 2)--Mythic
--Animates
local specWarnAnimateFrost			= mod:NewSpecialWarningSwitch(213853, "-Healer", nil, nil, 1, 2)--Currently spell ID does not contain "animate" in name, which makes warning confusing. Hopefully blizzard fixes
local specWarnAnimateFire			= mod:NewSpecialWarningSwitch(213567, "-Healer", nil, nil, 1, 2)
local specWarnAnimateArcane			= mod:NewSpecialWarningSwitch(213564, "-Healer", nil, nil, 1, 2)
--Mythic
local specWarnDecimate				= mod:NewSpecialWarningSpell(230504, nil, nil, nil, 1, 2)
local specWarnFelLash				= mod:NewSpecialWarningSoon(230403, nil, nil, nil, 1, 2)

local timerFrostPhaseCD				= mod:NewNextTimer(80, 213864, nil, nil, nil, 6)
local timerFirePhaseCD				= mod:NewNextTimer(85, 213867, nil, nil, nil, 6)
local timerArcanePhaseCD			= mod:NewNextTimer(85, 213869, nil, nil, nil, 6)
local timerAnnihilateCD				= mod:NewNextCountTimer(40, 212492, nil, "Tank", nil, 5, nil, DBM_COMMON_L.DEADLY_ICON..DBM_COMMON_L.TANK_ICON, nil, 2, 4)
--Debuffs
local timerMarkOfFrostCD			= mod:NewNextTimer(16, 212531, nil, nil, nil, 3)
local timerSearingBrandCD			= mod:NewNextTimer(16, 213148, nil, nil, nil, 3)
local timerArcaneOrbCD				= mod:NewNextTimer(11.5, 213519, nil, nil, nil, 3)
--Replicates
local timerMarkOfFrostRepCD			= mod:NewNextTimer(16, 212530, 160324, nil, nil, 3)--Short name "Replicate"
local timerSearingBrandRepCD		= mod:NewNextTimer(16, 213182, 160324, nil, nil, 3)--Short name "Replicate"
local timerArcaneOrbRepCD			= mod:NewNextTimer(14.5, 213852, 160324, nil, nil, 3)--Short name "Replicate"
--Detonates
local timerMarkOfFrostDetonateCD	= mod:NewNextTimer(16, 212735, 29870, nil, nil, 3, nil, DBM_COMMON_L.HEALER_ICON)--Short name "Detonate"
local timerSearingBrandDetonateCD	= mod:NewNextTimer(16, 213275, 29870, nil, nil, 3, nil, DBM_COMMON_L.HEALER_ICON)--Short name "Detonate"
local timerArcaneOrbDetonateCD		= mod:NewNextTimer(16, 213390, 29870, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON..DBM_COMMON_L.HEALER_ICON)--Short name "Detonate"
--Animates
local timerAnimateFrostCD			= mod:NewNextTimer(16, 213853, 124338, nil, nil, 1, 57612, DBM_COMMON_L.TANK_ICON)--"Animated" short name. Wrong tense but only short spell I can use
local timerAnimateFireCD			= mod:NewNextTimer(16, 213567, 124338, nil, nil, 1, nil, DBM_COMMON_L.DEADLY_ICON..DBM_COMMON_L.TANK_ICON)--"Animated" short name. Wrong tense but only short spell I can use
local timerAnimateArcaneCD			= mod:NewNextTimer(16, 213564, 124338, nil, nil, 1, nil, DBM_COMMON_L.DEADLY_ICON..DBM_COMMON_L.DAMAGE_ICON..DBM_COMMON_L.TANK_ICON)--"Animated" short name. Wrong tense but only short spell I can use
--Animate Specials
local timerArmageddon				= mod:NewCastTimer(33, 213568, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 3, 4)
--Mythic
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerFelSoulCD				= mod:NewNextTimer(15, 230951, nil, nil, nil, 1, nil, DBM_COMMON_L.HEROIC_ICON)
local timerFelSoul					= mod:NewBuffActiveTimer(45, 230951, nil, nil, nil, 6)
local timerDecimateCD				= mod:NewCDTimer(16.1, 230504, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--17-20 (Tank timer by default, holy/ret/etc that's doing taunting will have to enable by default)
local timerFelStompCD				= mod:NewNextTimer(25, 230414, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON)
local timerFelLashCD				= mod:NewNextCountTimer(25, 230403, nil, nil, nil, 2, nil, DBM_COMMON_L.HEROIC_ICON, nil, 1, 3)

local berserkTimer					= mod:NewBerserkTimer(600)--480

mod:AddRangeFrameOption("8")
mod:AddSetIconOption("SetIconOnFrozenTempest", 213083, true, true)
mod:AddSetIconOption("SetIconOnSearingDetonate", 213275, true)
mod:AddSetIconOption("SetIconOnBurstOfFlame", 213760, true, true)
mod:AddSetIconOption("SetIconOnBurstOfMagic", 213808, true, true)
mod:AddInfoFrameOption(212647)

mod.vb.annihilateCount = 0
mod.vb.armageddonAdds = 0
mod.vb.felLashCount = 0
mod.vb.lastPhase = 1
local MarkOfFrostDebuff, SearingBrandDebuff, annihilatedDebuff, frostBitten = DBM:GetSpellInfo(212587), DBM:GetSpellInfo(213166), DBM:GetSpellInfo(215458), DBM:GetSpellInfo(212647)
local rangeShowAll = false
local chargeTable = {}
local annihilateTimers = {8.0, 45.0, 40.0, 44.0, 38.0, 37.0, 33.0, 47.0, 41.0, 44.0, 38.0, 37.0, 33.0}--Need longer pulls/more data. However this pattern did prove to always be same
local mythicAnnihilateTimers = {8, 46, 30, 37, 35, 43, 27, 37, 41, 37, 35, 43, 27}
local felLashTimers = {21, 10.9, 6, 11, 6}
local searingDetonateIcons = {}

local debuffFilter
do
	debuffFilter = function(uId)
		if DBM:UnitDebuff(uId, MarkOfFrostDebuff) or DBM:UnitDebuff(uId, SearingBrandDebuff) then
			return true
		end
	end
end

local function findSearingMark(self)
	if DBM:UnitDebuff("player", SearingBrandDebuff) then
		specWarnFireDetonate:Show()
		specWarnFireDetonate:Play("runout")
		yellFireDetonate:Yell()
	end
	table.wipe(searingDetonateIcons)
	if self.Options.SetIconOnSearingDetonate then
		for uId in DBM:GetGroupMembers() do
			if DBM:UnitDebuff(uId, SearingBrandDebuff) then
				local name = DBM:GetUnitFullName(uId)
				searingDetonateIcons[#searingDetonateIcons+1] = name
				self:SetIcon(name, #searingDetonateIcons, 3)
			end
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.annihilateCount = 0
	self.vb.armageddonAdds = 0
	self.vb.lastPhase = 1
	timerAnnihilateCD:Start(8-delay, 1)
	--Rest of timers are triggered by frost buff 0.1 seconds into pull
	table.wipe(chargeTable)
	table.wipe(searingDetonateIcons)
	rangeShowAll = false
	if self:IsMythic() then
		self.vb.felLashCount = 0
		berserkTimer:Start(450)
	elseif self:IsEasy() then
		berserkTimer:Start(-delay)--600 confirmed on normal (needs reconfirm on live)
	else
		berserkTimer:Start(480-delay)--480 confirmed on heroic (needs reconfirm on live)
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
	if spellId == 213853 then--Mark of Frost (Animate)
		specWarnAnimateFrost:Show()
		specWarnAnimateFrost:Play("mobsoon")--using this trigger, mobsoon
	elseif spellId == 213567 then--Animate: Searing Brand
		specWarnAnimateFire:Show()
		specWarnAnimateFire:Play("mobsoon")
	elseif spellId == 213564 then--Animate: Arcane Orb
		specWarnAnimateArcane:Show()
		specWarnAnimateArcane:Play("mobsoon")
		if not self:IsEasy() then
			timerArmageddon:Start()
		end
	elseif spellId == 213852 then--Replicate: Arcane Orb
		specWarnArcaneOrb:Show()
		specWarnArcaneOrb:Play("watchorb")
	elseif spellId == 212735 then--Detonate: Mark of Frost
		if DBM:UnitDebuff("player", MarkOfFrostDebuff) then
			specWarnFrostdetonate:Show()
			specWarnFrostdetonate:Play("runout")
			yellFrostDetonate:Yell()
		end
	elseif spellId == 213083 then--Frozen Tempest
		warnFrozenTempest:Show()
		if self.Options.SetIconOnFrozenTempest then
			self:ScanForMobs(args.sourceGUID, 2, 8, 1, nil, 10, "SetIconOnFrozenTempest")
		end
	elseif spellId == 212492 then--Annihilate
		local targetName, uId, bossuid = self:GetBossTarget(104881, true)
		if bossuid and self:IsTanking("player", bossuid, nil, true) then
			specWarnAnnihilate:Show(self.vb.annihilateCount+1)
			specWarnAnnihilate:Play("defensive")
		end
	elseif spellId == 230504 then
		local targetName, uId, bossuid = self:GetBossTarget(115905)
		if bossuid and self:IsTanking("player", bossuid, nil, true) then
			specWarnDecimate:Show()
			specWarnDecimate:Play("carefly")
		end
		if self.vb.lastPhase == 3 then
			timerDecimateCD:Start(17)
		else
			timerDecimateCD:Start(20)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 230403 then
		self.vb.felLashCount = self.vb.felLashCount + 1
		local timer = felLashTimers[self.vb.felLashCount+1]
		if timer then
			specWarnFelLash:Schedule(timer-3)
			specWarnFelLash:ScheduleVoice(timer-3, "gathershare")
			timerFelLashCD:Start(timer, self.vb.felLashCount+1)
		end
	elseif spellId == 212492 then--Annihilate
		self.vb.annihilateCount = self.vb.annihilateCount + 1
		local nextCount = self.vb.annihilateCount+1
		local timer = self:IsMythic() and mythicAnnihilateTimers[nextCount] or annihilateTimers[nextCount]
		if timer then
			timerAnnihilateCD:Start(timer-3, nextCount)
		end
		if nextCount == 6 and not self:IsMythic() then
			--Better place to start arcane orb timer since it's cast 1.5 seconds after arcane phase begins and this is last annihilate in fire phase
			timerArcaneOrbCD:Start()
		end
	elseif spellId == 213275 and self.Options.SetIconOnBurstOfFlame then--Detonate: Searing Brand
		--self:ScanForMobs(107285, 0, 8, 6, nil, 20, "SetIconOnBurstOfFlame", false)--Second CID isn't actually second ID, just more redundancy to try and get god damn thing to work AT ALL
		self:ScheduleMethod(15, "ScanForMobs", 107285, 0, 8, 8, nil, 12, "SetIconOnBurstOfFlame")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 213864 or spellId == 216389 then--Icy enchantment
		self.vb.lastPhase = 1
		warnFrostPhase:Show()
		warnFrostPhase:Play("phasechange")
		if spellId == 216389 then--First icy
			timerMarkOfFrostCD:Start(18)
			if self:IsMythic() then
				timerFelSoulCD:Start(15)
				timerMarkOfFrostRepCD:Start(28)
				timerMarkOfFrostDetonateCD:Start(48)
				timerAnimateFrostCD:Start(65)
				timerFirePhaseCD:Start(75)
			else
				timerMarkOfFrostRepCD:Start(38)
				timerMarkOfFrostDetonateCD:Start(68)
				timerAnimateFrostCD:Start(75)
				timerFirePhaseCD:Start(85)
			end
		else--Rest of them
			--timerMarkOfFrostCD:Start(1.5)--No real reason to show a 1.5 second timer
			timerMarkOfFrostRepCD:Start(15)
			if self:IsMythic() then
				timerFelSoulCD:Start(18)
				timerMarkOfFrostDetonateCD:Start(35)
				timerAnimateFrostCD:Start(52)
				timerFirePhaseCD:Start(75)
			else
				timerMarkOfFrostDetonateCD:Start(45)
				timerAnimateFrostCD:Start(62)
				timerFirePhaseCD:Start(85)
			end
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8, debuffFilter)
		end
		if self.Options.InfoFrame and not self:IsLFR() then
			DBM.InfoFrame:SetHeader(frostBitten)
			DBM.InfoFrame:Show(6, "playerdebuffstacks", frostBitten)
		end
	elseif spellId == 213867 then--Fiery Enchantment
		self.vb.lastPhase = 2
		warnFirePhase:Show()
		warnFirePhase:Play("phasechange")
		if self:IsMythic() then
			timerFelSoulCD:Start(15)
			timerSearingBrandCD:Start(17.8)
			timerFelStompCD:Start(25)
			timerSearingBrandRepCD:Start(27)
			self:Schedule(37, findSearingMark, self)--Schedule markers to go out 3 seconds before detonate cast, making a 6 total seconds to position instead of 3
			timerSearingBrandDetonateCD:Start(40)
			timerAnimateFireCD:Start(55)
			timerArcanePhaseCD:Start(75)
		else
			timerSearingBrandCD:Start(17.8)
			timerSearingBrandRepCD:Start(27)
			self:Schedule(42, findSearingMark, self)--Schedule markers to go out 3 seconds before detonate cast, making a 6 total seconds to position instead of 3
			timerSearingBrandDetonateCD:Start(45)
			timerAnimateFireCD:Start(62)
			timerArcanePhaseCD:Start(85)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 213869 then--Magic Enchantment
		self.vb.lastPhase = 3
		warnArcanePhase:Show()
		warnArcanePhase:Play("phasechange")
		if self:IsMythic() then
			self.vb.felLashCount = 0
			timerFelSoulCD:Start(12)
			--Arcane orb not started here, started somewhere else so timer is actually useful
			timerArcaneOrbRepCD:Start(15)
			specWarnFelLash:Schedule(18)
			specWarnFelLash:ScheduleVoice(18, "gathershare")
			timerFelLashCD:Start(21, 1)
			timerArcaneOrbDetonateCD:Start(35)--Not in combat log, So difficult to fix until transcriptor. Needs verification
			specWarnArcaneDetonate:Schedule(35)--^^
			specWarnArcaneDetonate:ScheduleVoice(35, "watchorb")--^^
			timerAnimateArcaneCD:Start(55)--Oddly slightly longer on mythic than others
			timerFrostPhaseCD:Start(70)
		else
			--Arcane orb not started here, started somewhere else so timer is actually useful
			timerArcaneOrbRepCD:Start(15)
			timerArcaneOrbDetonateCD:Start(35)--Not in combat log, but this is when yell occurs
			specWarnArcaneDetonate:Schedule(35)
			specWarnArcaneDetonate:ScheduleVoice(35, "watchorb")
			timerAnimateArcaneCD:Start(51.9)
			timerFrostPhaseCD:Start(70)
		end
		if self.Options.RangeFrame and self:IsRanged() then
			DBM.RangeCheck:Show(8)--Show everyone for better arcane orb spread
		else--Melee, kill range frame this phase
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 212531 then--Mark of Frost (5sec Targetting Debuff)
		warnMarkOfFrostChosen:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnMarkOfFrost:Show()
			specWarnMarkOfFrost:Play("targetyou")
			self:AntiSpam(7, args.destName)
			yellMarkofFrost:Yell()
		end
	elseif spellId == 212587 then
		if args:IsPlayer() and self:AntiSpam(7, args.destName) then
			specWarnMarkOfFrost:Show()
			specWarnMarkOfFrost:Play("targetyou")
			yellMarkofFrost:Yell()
		end
	elseif spellId == 213148 then--Searing Brand (5sec Targetting Debuff)
		warnSearingBrandChosen:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnSearingBrand:Show()
			specWarnSearingBrand:Play("scatter")
		end
	elseif spellId == 213569 then--Armageddon Applied to mobs
		self.vb.armageddonAdds = self.vb.armageddonAdds + 1
	elseif spellId == 230951 then
		warnFelSoul:Show()
		timerFelSoul:Start()
		if self.vb.lastPhase == 1 then
			timerDecimateCD:Start(18.5)
		elseif self.vb.lastPhase == 2 then
			timerDecimateCD:Start(11.2)
		else
			timerDecimateCD:Start(9.4)
		end
	elseif spellId == 212647 then
		local amount = args.amount or 1
		if args:IsPlayer() and amount % 2 == 0 and amount >= 6 and amount ~= 8 then
			specWarnFrostbitten:Show(amount)
			specWarnFrostbitten:Play("stackhigh")
		end
	elseif spellId == 215458 then
		local amount = args.amount or 1
		if amount >= 2 then
			if not DBM:UnitDebuff("player", args.spellName) and not args:IsPlayer() then
				specWarnAnnihilateOther:Show(args.destName)
				specWarnAnnihilateOther:Play("tauntboss")
			else
				warnAnnihilate:Show(args.destName, amount)
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 213569 then--Armageddon Applied to mobs
		self.vb.armageddonAdds = self.vb.armageddonAdds - 1
		local count = self.vb.armageddonAdds
		if count < 4 then
			warnArmageddon:Show(count)
			if count == 0 then
				timerArmageddon:Stop()
			end
		end
	elseif spellId == 230951 then
		timerFelSoul:Stop()
	end
end

do
	local playerGUID = UnitGUID("player")
	function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
		if spellId == 212736 and destGUID == playerGUID and self:AntiSpam(2, 1) then
			specWarnPoolOfFrost:Show()
			specWarnPoolOfFrost:Play("runaway")
		elseif spellId == 213278 and destGUID == playerGUID and self:AntiSpam(2, 2) then
			specWarnBurningGround:Show()
			specWarnBurningGround:Play("runaway")
		elseif spellId == 213504 and destGUID == playerGUID and self:AntiSpam(2, 3) then
			specWarnArcaneFog:Show()
			specWarnArcaneFog:Play("runaway")
		elseif spellId == 230414 and destGUID == playerGUID and self:AntiSpam(2, 4) then
			specWarnFelStomp:Show()
			specWarnFelStomp:Play("runaway")
		end
	end
	mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

	function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
		if spellId == 213520 and destGUID == playerGUID and self:AntiSpam(2, 1) then
			specWarnArcaneFog:Show()
			specWarnArcaneFog:Play("runaway")
		end
	end
	mod.SPELL_MISSED = mod.SPELL_DAMAGE
end

--More accurate way to do this for now, too many spell Ids right now don't know what's what for sure. However a simple spell NAME check should work fairly reliable for test purposes
function mod:UNIT_AURA(uId)
	local hasDebuff = DBM:UnitDebuff("player", MarkOfFrostDebuff) or DBM:UnitDebuff("player", SearingBrandDebuff)
	if hasDebuff and not rangeShowAll then--Has 1 or more debuff, show all players on range frame
		rangeShowAll = true
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	elseif not hasDebuff and rangeShowAll then--No debuffs, only show those that have debuffs
		rangeShowAll = false
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8, debuffFilter)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 215455 then--Arcane Orb
		specWarnArcaneOrb:Show()
		specWarnArcaneOrb:Play("watchorb")
	elseif spellId == 213390 then--Detonate: Arcane Orb (still missing from combat log, although this event is 3 seconds slower than scheduling or using yell)
		self:ScheduleMethod(15, "ScanForMobs", 107287, 0, 8, 8, nil, 12, "SetIconOnBurstOfMagic")
--		specWarnArcaneDetonate:Show()
--		specWarnArcaneDetonate:Play("watchorb")
	end
end

local mod	= DBM:NewMod(867, "DBM-SiegeOfOrgrimmarV2", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(71734)
mod:SetEncounterID(1604)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 144400 144379 144832",
	"SPELL_CAST_SUCCESS 144400 144832 144800 146823",
	"SPELL_AURA_APPLIED 144359 146594 145215 146822 146817 144843 144351 144358 144574 144636 147207 144683 144684",
	"SPELL_AURA_REMOVED 144351 147207",
	"UNIT_POWER_FREQUENT boss1"
)

--Sha of Pride
local warnGiftOfTitans			= mod:NewTargetAnnounce(144359, 1, nil, "Healer")
local warnMark					= mod:NewTargetAnnounce(144351, 3, nil, "Healer")
local warnWoundedPride			= mod:NewTargetAnnounce(144358, 4, nil, "Healer|Tank")
local warnCorruptedPrison		= mod:NewTargetAnnounce(144574, 3)
local warnBanishment			= mod:NewTargetAnnounce(145215, 3)--Heroic
local warnUnleashed				= mod:NewSpellAnnounce(144832, 3)--Phase 2
--Pride / These 5 warnings can be show at same time. Can be extremely spam. Need to throttle these warnings. (core changes not enough)
local warnBurstingPride			= mod:NewTargetAnnounce(144911, 2, nil, false)--25-49 Energy (off by default, who has them isn't as relevant as to where they are
local warnProjection			= mod:NewTargetAnnounce(146822, 3)--50-74 Energy (VERY important who has)
local warnAuraOfPride			= mod:NewTargetAnnounce(146817, 3, nil, false)--75-99 Energy (not important who has them)
local warnOvercome				= mod:NewTargetAnnounce(144843, 3)--100 Energy (pre mind control) Also very important who has
local warnOvercomeMC			= mod:NewTargetAnnounce(605, 4)--Mind control version (use priest mind control spellid to discribe. because have same spell name in pre-warning)
--Manifestation of Pride
local warnMockingBlast			= mod:NewSpellAnnounce(144379, 3, nil, false)

--Sha of Pride
local specWarnGiftOfTitans		= mod:NewSpecialWarningYou(144359, "Healer")
local yellGiftOfTitans			= mod:NewYell(146594, nil, false)
local specWarnSwellingPride		= mod:NewSpecialWarningCount(144400, nil, nil, nil, 2)
local specWarnWoundedPride		= mod:NewSpecialWarningYou(144358)--Cast/personal warning
local specWarnWoundedPrideOther	= mod:NewSpecialWarningTaunt(144358)
local specWarnSelfReflection	= mod:NewSpecialWarningSpell(144800, nil, nil, nil, 2)
local specWarnCorruptedPrison	= mod:NewSpecialWarningSpell(144574)
local specWarnCorruptedPrisonYou= mod:NewSpecialWarningYou(144574, false)--Since you can't do anything about it, might as well be off by default. but an option cause someone will want it
local yellCorruptedPrison		= mod:NewYell(144574, nil, false)
--Pride
local specWarnBurstingPride		= mod:NewSpecialWarningMove(144911)--25-49 Energy
local specWarnBurstingPrideNear	= mod:NewSpecialWarningClose(144911)
local yellBurstingPride			= mod:NewYell(144911, nil, false)
local specWarnProjection		= mod:NewSpecialWarningYou(146822, nil, nil, nil, 3)--50-74 Energy
local specWarnAuraOfPride		= mod:NewSpecialWarningYou(146817)--75-99 Energy
local yellAuraOfPride			= mod:NewYell(146818, nil, false)
local specWarnOvercome			= mod:NewSpecialWarningYou(144843, nil, nil, nil, 3)--100 EnergyHonestly, i have a feeling your best option if this happens is to find a way to kill yourself!
local specWarnBanishment		= mod:NewSpecialWarningYou(145215, nil, nil, nil, 3)--Heroic
--Manifestation of Pride
local specWarnManifestation		= mod:NewSpecialWarningSwitch("ej8262", "-Healer")--Spawn warning, need trigger first
local specWarnMockingBlast		= mod:NewSpecialWarningInterrupt(144379)

--Sha of Pride
local timerGiftOfTitansCD		= mod:NewNextTimer(25.5, 144359, nil, "-Tank", nil, 3)--NOT cast or tied or boss, on it's own. Off for tanks because it can't target tanks, ever
--These abilitie timings are all based on boss1 UNIT_POWER. All timers have a 1 second variance
local timerMarkCD				= mod:NewNextTimer(20.5, 144351, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerSelfReflectionCD		= mod:NewNextTimer(25, 144800, nil, nil, nil, 1, nil, nil, nil, 2, 4)
local timerWoundedPrideCD		= mod:NewNextTimer(30, 144358, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)--A tricky on that is based off unit power but with variable timings, but easily workable with an 11, 26 rule
local timerBanishmentCD			= mod:NewNextTimer(37.5, 145215, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)
local timerCorruptedPrisonCD	= mod:NewNextTimer(53, 144574, nil, nil, nil, 3)--Technically 51 for Imprison base cast, but this is timer til debuffs go out.
local timerManifestationCD		= mod:NewNextTimer(60, "ej8262", nil, nil, nil, 1, "627685")
local timerSwellingPrideCD		= mod:NewNextCountTimer(75.5, 144400, nil, nil, nil, 2, nil, nil, nil, 1, 4)
local timerWeakenedResolve		= mod:NewBuffFadesTimer(60, 147207, nil, false)
--Pride
local timerBurstingPride		= mod:NewCastTimer(3, 144911)
local timerProjection			= mod:NewCastTimer(6, 146822)

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddInfoFrameOption("ej8255")
mod:AddSetIconOption("SetIconOnMark", 144351, false)
mod:AddBoolOption("SetIconOnFragment", false)--This does not get along with SetIconOnMark though
mod.findFastestComputer = {"SetIconOnFragment"} -- for set icon stuff.

--Upvales, don't need variables
local UnitPower, UnitPowerMax, UnitIsDeadOrGhost, UnitGUID = UnitPower, UnitPowerMax, UnitIsDeadOrGhost, UnitGUID
local prideLevel = DBM:EJ_GetSectionInfo(8255)
--Not important, don't need to recover
local manifestationWarned = false
local bpSpecWarnFired = false
--Important, needs recover
mod.vb.woundCount = 0
mod.vb.swellingCount = 0

function mod:OnCombatStart(delay)
	timerGiftOfTitansCD:Start(7.5-delay)
	timerMarkCD:Start(11-delay)
	if not self:IsDifficulty("lfr25") then
		timerWoundedPrideCD:Start(10-delay)
	end
	timerSelfReflectionCD:Start(-delay)
	timerCorruptedPrisonCD:Start(-delay)
	timerManifestationCD:Start(-delay)
	timerSwellingPrideCD:Start(-delay, 1)
	berserkTimer:Start(-delay)
	self.vb.woundCount = 0
	manifestationWarned = false
	self.vb.swellingCount = 0
	bpSpecWarnFired = false
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(prideLevel)
		DBM.InfoFrame:Show(5, "playerpower", 5, ALTERNATE_POWER_INDEX)
	end
	if self:IsMythic() then
		timerBanishmentCD:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 144400 then
		self.vb.swellingCount = self.vb.swellingCount + 1
		specWarnSwellingPride:Show(self.vb.swellingCount)
	elseif spellId == 144379 then
		local sourceGUID = args.sourceGUID
		warnMockingBlast:Show()
		if sourceGUID == UnitGUID("target") or sourceGUID == UnitGUID("focus") then 
			specWarnMockingBlast:Show(args.sourceName)
		end
	elseif spellId == 144832 then
		--These abilitie cd reset on SPELL_CAST_START (they no longer desync though, they sync back up after first off sync cast)
		timerSwellingPrideCD:Cancel()
		if not self:IsDifficulty("lfr25") then
			timerWoundedPrideCD:Start()
		end
		timerSelfReflectionCD:Start()
		timerCorruptedPrisonCD:Start()
		if self:IsMythic() then
			timerBanishmentCD:Start()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 144400 then--Swelling Pride Cast END
		self.vb.woundCount = 0
		bpSpecWarnFired = false
		--Since we register this event anyways for bursting, might as well start cd bars here instead
		timerMarkCD:Start(10.5)
		timerSelfReflectionCD:Start()
		timerCorruptedPrisonCD:Start()
		timerManifestationCD:Start()
		timerSwellingPrideCD:Start(nil, self.vb.swellingCount + 1)
		if not self:IsDifficulty("lfr25") then
			timerWoundedPrideCD:Start(11)
		end
		if self:IsMythic() then
			timerBanishmentCD:Start()
		end
		--This is done here because a lot can change during a cast, and we need to know players energy when cast ends, i.e. this event
		for uId in DBM:GetGroupMembers() do
			local maxPower = UnitPowerMax(uId, ALTERNATE_POWER_INDEX)
			if maxPower ~= 0 and not UnitIsDeadOrGhost(uId) then--PTR work around mainly, div by 0 crap
				local unitsPower = UnitPower(uId, ALTERNATE_POWER_INDEX) / maxPower * 100
				if unitsPower > 24 and unitsPower < 50 then--Valid Bursting target
					local targetName = DBM:GetUnitFullName(uId)
					warnBurstingPride:CombinedShow(0.5, targetName)
					if targetName == UnitName("player") then
						bpSpecWarnFired = true
						specWarnBurstingPride:Show()
						yellBurstingPride:Yell()
						timerBurstingPride:Start()
					elseif self:CheckNearby(6, targetName) and not bpSpecWarnFired then
						bpSpecWarnFired = true
						specWarnBurstingPrideNear:Show(targetName)
					end
				end
			end
		end
	elseif spellId == 144832 then
		warnUnleashed:Show()
		timerGiftOfTitansCD:Cancel()
		self.vb.woundCount = 0
		timerManifestationCD:Start()--Not yet verified if altered or not
		timerSwellingPrideCD:Start(75, self.vb.swellingCount + 1)--Not yet verified if altered or not (it would be 62 instead of 60 though since we'd be starting at 0 energy instead of cast finish of last swelling)
	elseif spellId == 144800 then
		specWarnSelfReflection:Show()
	elseif spellId == 146823 and self.Options.SetIconOnFragment then--Banishment cast. Not want to use applied for add mark scheduling
		self:ScanForMobs(72569, 0, 8, 2, 0.2, 10)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if args:IsSpellID(144359, 146594) then
		warnGiftOfTitans:CombinedShow(0.5, args.destName)
		timerGiftOfTitansCD:DelayedStart(0.5)
		if args:IsPlayer() then
			specWarnGiftOfTitans:Show()
			if not self:IsDifficulty("lfr25") then
				yellGiftOfTitans:Yell()
			end
		end
	elseif spellId == 145215 then
		warnBanishment:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnBanishment:Show()
		end
	elseif spellId == 146822 then
		warnProjection:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnProjection:Show()
			timerProjection:Start()
		end
	elseif spellId == 146817 then
		warnAuraOfPride:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnAuraOfPride:Show()
			yellAuraOfPride:Yell()
		end
	elseif spellId == 144843 then--Same spellid fires for both versions, so we have to do some more advanced filtering
		if bit.band(args.destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then--Mind controled version
			warnOvercomeMC:CombinedShow(0.5, args.destName)
		else--Non mind controlled version
			warnOvercome:CombinedShow(0.5, args.destName)
			if args:IsPlayer() then
				specWarnOvercome:Show()
			end
		end
	elseif spellId == 144351 then
		warnMark:CombinedShow(0.5, args.destName)
		timerMarkCD:DelayedStart(0.5)
		if self.Options.SetIconOnMark and args:IsDestTypePlayer() then--Filter further on icons because we don't want to set icons on grounding totems
			self:SetSortedIcon(0.5, args.destName, 1)
		end
	elseif spellId == 144358 then
		warnWoundedPride:Show(args.destName)
		if UnitDetailedThreatSituation("player", "boss1") then
			specWarnWoundedPride:Show()
		else
			specWarnWoundedPrideOther:Show(args.destName)
		end
		if self.vb.woundCount < 2 and not self:IsDifficulty("lfr25") then
			self.vb.woundCount = self.vb.woundCount + 1
			timerWoundedPrideCD:Start()
		end
	elseif args:IsSpellID(144574, 144636, 144683, 144684) then
		warnCorruptedPrison:CombinedShow(0.5, args.destName)
		specWarnCorruptedPrison:DelayedShow(0.5)
		if args:IsPlayer() then
			specWarnCorruptedPrisonYou:Show()
			yellCorruptedPrison:Yell()
		end
	elseif spellId == 147207 then
		if args:IsPlayer() then
			timerWeakenedResolve:Start()
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED--In case i decide to do something with fact healer debuff stacks if you suck at dispels

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 144351 and self.Options.SetIconOnMark then
		self:SetIcon(args.destName, 0)
	elseif spellId == 147207 and args:IsPlayer() then
		timerWeakenedResolve:Cancel()
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	local power = UnitPower(uId)
	if power > 81 and not manifestationWarned then--May not be 100% precise, but very close, it spawns around 80-85 energy
		manifestationWarned = true
		specWarnManifestation:Show()--No spawn trigger to speak of. fortunately for us, they spawn based on boss power.
	elseif power > 10 and power < 82 and manifestationWarned then
		manifestationWarned = false
	end
end

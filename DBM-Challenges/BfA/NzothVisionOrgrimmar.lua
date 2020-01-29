local mod	= DBM:NewMod("d1995", "DBM-Challenges", 3)--1993 Stormwind 1995 Org
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200129034746")
mod:SetZone()
mod.onlyNormal = true

mod:RegisterCombat("scenario", 2212)--2212, 2213 (org, stormwind)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 297822 297746 304976 297574 304251 306726 299110 307863 300351 300388 304101 304282 306001 306199 303589 305875 306828 306617 300388 296537 305378",
	"SPELL_AURA_APPLIED 311390 315385 316481 311641 299055",
	"SPELL_AURA_APPLIED_DOSE 311390",
	"SPELL_CAST_SUCCESS 297237",
	"SPELL_PERIODIC_DAMAGE 303594",
	"SPELL_PERIODIC_MISSED 303594",
	"UNIT_DIED",
	"ENCOUNTER_START"
)

--TODO, notable trash or affix warnings
--TODO, maybe add https://ptr.wowhead.com/spell=298510/aqiri-mind-toxin
--TODO, improve https://ptr.wowhead.com/spell=306001/explosive-leap warning if can get throw target
--TODO, can https://ptr.wowhead.com/spell=305875/visceral-fluid be dodged? If so upgrade the warning
local warnScorchedFeet				= mod:NewSpellAnnounce(315385, 4)
--Extra Abilities (used by main boss and the area LTs)
local warnCriesoftheVoid			= mod:NewCastAnnounce(304976, 4)
local warnVoidQuills				= mod:NewCastAnnounce(304251, 3)
--Other notable abilities by mini bosses/trash
local warnDarkForce					= mod:NewTargetNoFilterAnnounce(299055, 3)
local warnExplosiveLeap				= mod:NewCastAnnounce(306001, 3)
local warnVisceralFluid				= mod:NewCastAnnounce(305875, 3)
local warnEndlessHungerTotem		= mod:NewSpellAnnounce(297237, 4)

--General (GTFOs and Affixes)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(303594, nil, nil, nil, 1, 8)
local specWarnEntomophobia			= mod:NewSpecialWarningJump(311389, nil, nil, nil, 1, 6)
--local specWarnDarkDelusions			= mod:NewSpecialWarningRun(306955, nil, nil, nil, 4, 2)
local specWarnScorchedFeet			= mod:NewSpecialWarningYou(315385, false, nil, 2, 1, 2)
local yellScorchedFeet				= mod:NewYell(315385)
local specWarnSplitPersonality		= mod:NewSpecialWarningYou(316481, nil, nil, nil, 1, 2)
local specWarnWaveringWill			= mod:NewSpecialWarningReflect(311641, "false", nil, nil, 1, 2)--Off by default, it's only 5%, but that might matter to some classes
--local specWarnHauntingShadows		= mod:NewSpecialWarningDodge(310173, nil, nil, nil, 2, 2)--Not detectable apparently
--Thrall
local specWarnSurgingDarkness		= mod:NewSpecialWarningDodge(297822, nil, nil, nil, 2, 2)
local specWarnSeismicSlam			= mod:NewSpecialWarningDodge(297746, nil, nil, nil, 2, 2)
local yellSeismicSlam				= mod:NewYell(297746)
--Extra Abilities (used by Thrall and the area LTs)
local specWarnHopelessness			= mod:NewSpecialWarningMoveTo(297574, nil, nil, nil, 1, 2)
local specWarnDefiledGround			= mod:NewSpecialWarningDodge(306726, nil, nil, nil, 2, 2)--Can this be dodged?
--Other notable abilities by mini bosses/trash
local specWarnOrbofAnnihilation		= mod:NewSpecialWarningDodge(299110, nil, nil, nil, 2, 2)
local specWarnDarkForce				= mod:NewSpecialWarningYou(299055, nil, nil, nil, 1, 2)
local specWarnVoidTorrent			= mod:NewSpecialWarningDodge(307863, nil, nil, nil, 2, 8)
local specWarnSurgingFist			= mod:NewSpecialWarningDodge(300351, nil, nil, nil, 2, 2)
local specWarnDecimator				= mod:NewSpecialWarningDodge(300412, nil, nil, nil, 2, 2)
local specWarnDesperateRetching		= mod:NewSpecialWarningYou(304165, nil, nil, nil, 1, 2)
local yellDesperateRetching			= mod:NewYell(304165)
local specWarnDesperateRetchingD	= mod:NewSpecialWarningDispel(304165, "RemoveDisease", nil, nil, 1, 2)
local specWarnMaddeningRoar			= mod:NewSpecialWarningRun(304101, nil, nil, nil, 4, 2)
local specWarnStampedingCorruption	= mod:NewSpecialWarningDodge(304282, nil, nil, nil, 2, 2)
local specWarnHowlinginPain			= mod:NewSpecialWarningCast(306199, "SpellCaster", nil, nil, 1, 2)
local specWarnSanguineResidue		= mod:NewSpecialWarningDodge(303589, nil, nil, nil, 2, 2)
local specWarnDefiledGround			= mod:NewSpecialWarningDodge(306828, nil, nil, nil, 2, 2)
local specWarnRingofChaos			= mod:NewSpecialWarningDodge(306617, nil, nil, nil, 2, 2)
local specWarnHorrifyingShout		= mod:NewSpecialWarningInterrupt(305378, "HasInterrupt", nil, nil, 1, 2)
local specWarnMentalAssault			= mod:NewSpecialWarningInterrupt(296537, "HasInterrupt", nil, nil, 1, 2)

--Thrall
local timerSurgingDarknessCD	= mod:NewCDTimer(23.1, 297822, nil, nil, nil, 3)
local timerSeismicSlamCD		= mod:NewCDTimer(12.1, 297746, nil, nil, nil, 3)
--Extra Abilities (used by Thrall and the area LTs)
--local timerCriesoftheVoidCD		= mod:NewAITimer(21, 304976, nil, nil, nil, 3, nil, DBM_CORE_DAMAGE_ICON)
local timerDefiledGroundCD		= mod:NewAITimer(21, 306726, nil, nil, nil, 3)
--Both surging fist and Decimator are 9.7 second cds, worth adding?

mod:AddInfoFrameOption(307831, true)

local started = false
local playerName = UnitName("player")
mod.vb.GnshalCleared = false
mod.vb.VezokkCleared = false

function mod:SeismicSlamTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellSeismicSlam:Yell()
	end
end

function mod:OnCombatStart(delay)
	self.vb.GnshalCleared = false
	self.vb.VezokkCleared = false
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
		DBM.InfoFrame:Show(5, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 297822 then
		specWarnSurgingDarkness:Show()
		specWarnSurgingDarkness:Play("watchstep")
		timerSurgingDarknessCD:Start()
	elseif spellId == 297746 then
		specWarnSeismicSlam:Show()
		specWarnSeismicSlam:Play("shockwave")
		timerSeismicSlamCD:Start()
		if GetNumGroupMembers() > 1 then
			self:BossTargetScanner(args.sourceGUID, "SeismicSlamTarget", 0.1, 7)
		end
	elseif spellId == 304976 then
		warnCriesoftheVoid:Show()
		--timerCriesoftheVoidCD:Start()
	elseif spellId == 297574 then
		specWarnHopelessness:Show(DBM_CORE_ORB)
		specWarnHopelessness:Play("orbrun")--Technically not quite accurate but closest match to "find orb"
	elseif spellId == 304251 and self:AntiSpam(3, 1) then--Two boars, 3 second throttle
		warnVoidQuills:Show()
	elseif spellId == 306726 then
		specWarnDefiledGround:Show()
		specWarnDefiledGround:Play("shockwave")
		timerDefiledGroundCD:Start()
	elseif spellId == 299055 then
		if args:IsPlayer() then
			specWarnDarkForce:Show()
			specWarnDarkForce:Play("targetyou")
		else
			warnDarkForce:Show(args.destName)
		end
	elseif spellId == 299110 then
		specWarnOrbofAnnihilation:Show()
		specWarnOrbofAnnihilation:Play("watchorb")
	elseif spellId == 307863 then
		specWarnVoidTorrent:Show()
		specWarnVoidTorrent:Play("behindmob")
	elseif spellId == 300351 then
		specWarnSurgingFist:Show()
		specWarnSurgingFist:Play("chargemove")
	elseif spellId == 300388 then
		specWarnDecimator:Show()
		specWarnDecimator:Play("watchorb")
	elseif spellId == 304101 then
		specWarnMaddeningRoar:Show()
		specWarnMaddeningRoar:Play("justrun")
	elseif spellId == 304282 then
		specWarnStampedingCorruption:Show()
		specWarnStampedingCorruption:Play("watchstep")
	elseif spellId == 306001 then
		warnExplosiveLeap:Show()
	elseif spellId == 306199 then
		specWarnHowlinginPain:Show()
		specWarnHowlinginPain:Play("stopcast")
	elseif spellId == 303589 and self:AntiSpam(2, 2) then
		specWarnSanguineResidue:Show()
		specWarnSanguineResidue:Play("watchstep")
	elseif spellId == 305875 then
		warnVisceralFluid:Show()
	elseif spellId == 306828 then
		specWarnDefiledGround:Show()
		specWarnDefiledGround:Play("shockwave")
	elseif spellId == 306617 then
		specWarnRingofChaos:Show()
		specWarnRingofChaos:Play("watchorb")
	elseif spellId == 296537 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMentalAssault:Show(args.sourceName)
		specWarnMentalAssault:Play("kickcast")
	elseif spellId == 305378 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnHorrifyingShout:Show(args.sourceName)
		specWarnHorrifyingShout:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 297237 then
		warnEndlessHungerTotem:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 311390 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 3 then
			specWarnEntomophobia:Show()
			specWarnEntomophobia:Play("keepjump")
		end
--	elseif spellId == 306955 and args:IsPlayer() then
--		specWarnDarkDelusions:Show()
--		specWarnDarkDelusions:Play("justrun")
	elseif spellId == 315385 and args:IsPlayer() then
		if self.Options.SpecWarn315385you then
			specWarnScorchedFeet:Show()
			specWarnScorchedFeet:Play("targetyou")
		else
			warnScorchedFeet:Show()
		end
		if IsInGroup() then--Warn allies if in scenario with others
			yellScorchedFeet:Yell()
		end
	elseif spellId == 316481 and args:IsPlayer() then
		specWarnSplitPersonality:Show()
		specWarnSplitPersonality:Play("targetyou")
	elseif spellId == 311641 and args:IsPlayer() then
		specWarnWaveringWill:Show(playerName)
		specWarnWaveringWill:Play("stopattack")
	elseif spellId == 304165 then
		if args:IsPlayer() then
			specWarnDesperateRetching:Show()
			specWarnDesperateRetching:Play("keepmove")
			if IsInGroup() then
				yellDesperateRetching:Yell()
			end
		elseif self:CheckDispelFilter() then
			specWarnDesperateRetchingD:Show(args.destName)
			specWarnDesperateRetchingD:Play("helpdispel")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 303594 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152089 then--Thrall
		timerSurgingDarknessCD:Stop()
		timerSeismicSlamCD:Stop()
		--timerCriesoftheVoidCD:Stop()
		timerDefiledGroundCD:Stop()
		DBM:EndCombat(self)
		started = false
	elseif cid == 156161 then--Inquisitor Gnshal
		--timerCriesoftheVoidCD:Stop()
		self.vb.GnshalCleared = true
	elseif cid == 152874 then--Vez'okk the Lightless
		timerDefiledGroundCD:Stop()
		self.vb.VezokkCleared = true
	--elseif cid == 153244 then--Oblivion Elemental

	--elseif cid == 155098 then--Rexxar

	--elseif cid == 157349 then--Wild Boar

	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	local uiMap = C_Map.GetBestMapForUnit("player")
	if started and uiMap ~= 1469 then
		DBM:EndCombat(self, true)
		started = false
	elseif not uiMap and uiMap == 1469 then
		self:StartCombat(self, 0, "LOADING_SCREEN_DISABLED")
		started = true
	end
end

function mod:ENCOUNTER_START(encounterID)
	if encounterID == 2332 and self:IsInCombat() then
		timerSurgingDarknessCD:Start(11.1)
		if self.vb.VezokkCleared then
			timerDefiledGroundCD:Start(1)
		else
			timerSeismicSlamCD:Start(4.6)
		end
		--if self.vb.GnshalCleared then
		--	timerCriesoftheVoidCD:Start(1)
		--end
	end
end

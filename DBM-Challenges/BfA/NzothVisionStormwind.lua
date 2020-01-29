local mod	= DBM:NewMod("d1993", "DBM-Challenges", 3)--1993 Stormwind 1995 Org
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200129034746")
mod:SetZone()
mod.onlyNormal = true

mod:RegisterCombat("scenario", 2213)--2212, 2213 (org, stormwind)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 308278 309819 309648 298691 308669 308366 308406 311456 296911 296537 308481 308575",
	"SPELL_AURA_APPLIED 311390 315385 316481 311641 308380 308366 308265",
	"SPELL_AURA_APPLIED_DOSE 311390",
	"SPELL_CAST_SUCCESS 309035",
	"SPELL_PERIODIC_DAMAGE 312121 296674 308807",
	"SPELL_PERIODIC_MISSED 312121 296674 308807",
	"UNIT_DIED",
	"ENCOUNTER_START",
	"UNIT_SPELLCAST_SUCCEEDED"
)

--TODO, detect engaging of end bosses for start timers
--TODO, notable trash or affix warnings
--TODO, detect hard modes on end boss
--TODO, verify Explosive Ordnance cast ID
--TODO, proper place to stop dark gaze timer
--TODO, verify if scenario is appropriate combat tactic for this mod
--TODO, verify all the Affix warnings using correct spellIds/events
--TODO, maybe add https://ptr.wowhead.com/spell=292021/madness-leaden-foot#see-also-other affix? just depends on warning to stop moving can be counter to a stacked affix
--TODO, see if target scanning will work on Entropic Leap
--General
local warnScorchedFeet			= mod:NewSpellAnnounce(315385, 4)
--Extra Abilities (used by main boss and the area LTs)
local warnTaintedPolymorph		= mod:NewCastAnnounce(309648, 3)
local warnExplosiveOrdnance		= mod:NewSpellAnnounce(305672, 3)
--Other notable abilities by mini bosses/trash
local warnEntropicLeap			= mod:NewCastAnnounce(308406, 3)
local warnConvert				= mod:NewTargetNoFilterAnnounce(308380, 3)
local warnChaosBreath			= mod:NewCastAnnounce(296911, 3)

--General (GTFOs and Affixes)
local specWarnGTFO				= mod:NewSpecialWarningGTFO(312121, nil, nil, nil, 1, 8)
local specWarnEntomophobia		= mod:NewSpecialWarningJump(311389, nil, nil, nil, 1, 6)
--local specWarnDarkDelusions		= mod:NewSpecialWarningRun(306955, nil, nil, nil, 4, 2)
local specWarnScorchedFeet		= mod:NewSpecialWarningYou(315385, false, nil, 2, 1, 2)
local yellScorchedFeet			= mod:NewYell(315385)
local specWarnSplitPersonality	= mod:NewSpecialWarningYou(316481, nil, nil, nil, 1, 2)
local specWarnWaveringWill		= mod:NewSpecialWarningReflect(311641, "false", nil, nil, 1, 2)--Off by default, it's only 5%, but that might matter to some classes
--local specWarnHauntingShadows	= mod:NewSpecialWarningDodge(310173, nil, nil, nil, 2, 2)--Not detectable apparently
--Alleria Windrunner
local specWarnDarkenedSky		= mod:NewSpecialWarningDodge(308278, nil, nil, nil, 2, 2)
local specWarnVoidEruption		= mod:NewSpecialWarningMoveTo(309819, nil, nil, nil, 3, 2)
--Extra Abilities (used by Alleria and the area LTs)
local specWarnChainsofServitude	= mod:NewSpecialWarningRun(298691, nil, nil, nil, 4, 2)
local specWarnDarkGaze			= mod:NewSpecialWarningLookAway(308669, nil, nil, nil, 2, 2)
--Other notable abilities by mini bosses/trash
local specWarnAgonizingTorment	= mod:NewSpecialWarningInterrupt(308366, "HasInterrupt", nil, nil, 1, 2)
local specWarnEntropicMissiles	= mod:NewSpecialWarningInterrupt(309035, "HasInterrupt", nil, nil, 1, 2)
local specWarnMentalAssault		= mod:NewSpecialWarningInterrupt(296537, "HasInterrupt", nil, nil, 1, 2)
local specWarnShadowShift		= mod:NewSpecialWarningInterrupt(308575, "HasInterrupt", nil, nil, 1, 2)
local specWarnAgonizingTormentD	= mod:NewSpecialWarningDispel(308366, "RemoveCurse", nil, nil, 1, 2)
local specWarnRoaringBlast		= mod:NewSpecialWarningDodge(311456, nil, nil, nil, 2, 2)
local specWarnCorruptedBlight	= mod:NewSpecialWarningDispel(308265, nil, nil, nil, 1, 2)
local yellCorruptedBlight		= mod:NewYell(308265)
local specWarnRiftStrike		= mod:NewSpecialWarningDodge(308481, nil, nil, nil, 2, 2)

--Alleria Windrunner
local timerDarkenedSkyCD		= mod:NewCDTimer(13.3, 308278, nil, nil, nil, 3)
local timerVoidEruptionCD		= mod:NewCDTimer(27.9, 309819, nil, nil, nil, 2)
--Extra Abilities (used by Alleria and the area LTs)
local timerTaintedPolymorphCD	= mod:NewAITimer(21, 309648, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON)
local timerExplosiveOrdnanceCD	= mod:NewCDTimer(20.7, 305672, nil, nil, nil, 3)--20-25 (on alleria anyways, forgot to log other guy)
local timerChainsofServitudeCD	= mod:NewAITimer(21, 298691, nil, nil, nil, 2)
local timerDarkGazeCD			= mod:NewAITimer(21, 308669, nil, nil, nil, 3)

mod:AddInfoFrameOption(307831, true)

local started = false
local playerName = UnitName("player")
mod.vb.TherumCleared = false
mod.vb.UlrokCleared = false
mod.vb.ShawCleared = false
mod.vb.UmbricCleared = false

function mod:OnCombatStart(delay)
	self.vb.TherumCleared = false
	self.vb.UlrokCleared = false
	self.vb.ShawCleared = false
	self.vb.UmbricCleared = false
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
	if spellId == 308278 then
		specWarnDarkenedSky:Show()
		specWarnDarkenedSky:Play("watchstep")
		timerDarkenedSkyCD:Start()
	elseif spellId == 309819 then
		specWarnVoidEruption:Show(DBM_CORE_BREAK_LOS)
		specWarnVoidEruption:Play("findshelter")
		timerVoidEruptionCD:Start()
	elseif spellId == 309648 then
		warnTaintedPolymorph:Show()
		timerTaintedPolymorphCD:Start()
	elseif spellId == 298691 then
		specWarnChainsofServitude:Show()
		specWarnChainsofServitude:Play("justrun")
		timerChainsofServitudeCD:Start()
	elseif spellId == 308669 then
		specWarnDarkGaze:Show(args.sourceName)
		specWarnDarkGaze:Play("turnaway")
		timerDarkGazeCD:Start()
	elseif spellId == 308366 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnAgonizingTorment:Show(args.sourceName)
		specWarnAgonizingTorment:Play("kickcast")
	elseif spellId == 296537 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMentalAssault:Show(args.sourceName)
		specWarnMentalAssault:Play("kickcast")
	elseif spellId == 308575 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowShift:Show(args.sourceName)
		specWarnShadowShift:Play("kickcast")
	elseif spellId == 308406 then
		warnEntropicLeap:Show()
	elseif spellId == 311456 then
		specWarnRoaringBlast:Show()
		specWarnRoaringBlast:Play("shockwave")
	elseif spellId == 296911 then
		warnChaosBreath:Show()
	elseif spellId == 308481 and self:AntiSpam(5, 3) then
		specWarnRiftStrike:Show()
		specWarnRiftStrike:Play("watchstep")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 309035 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnEntropicMissiles:Show(args.sourceName)
		specWarnEntropicMissiles:Play("kickcast")
	--elseif spellId == 310173 then
	--	specWarnHauntingShadows:Show()
	--	specWarnHauntingShadows:Play("watchstep")
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
		if GetNumGroupMembers() > 1 then--Warn allies if in scenario with others
			yellScorchedFeet:Yell()
		end
	elseif spellId == 316481 and args:IsPlayer() then
		specWarnSplitPersonality:Show()
		specWarnSplitPersonality:Play("targetyou")
	elseif spellId == 311641 and args:IsPlayer() then
		specWarnWaveringWill:Show(playerName)
		specWarnWaveringWill:Play("stopattack")
	elseif spellId == 308380 then
		warnConvert:Show(args.destName)
	elseif spellId == 308366 and self:CheckDispelFilter() then
		specWarnAgonizingTormentD:Show(args.destName)
		specWarnAgonizingTormentD:Play("helpdispel")
	elseif spellId == 308265 then
		if args:IsPlayer() and GetNumGroupMembers() > 1 then
			yellCorruptedBlight:Yell()
		end
		if self:CheckDispelFilter() then
			specWarnCorruptedBlight:Show(args.destName)
			specWarnCorruptedBlight:Play("helpdispel")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if (spellId == 296674 or spellId == 312121 or spellId == 308807) and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152718 then--Alleria Windrunner
		timerDarkenedSkyCD:Stop()
		timerVoidEruptionCD:Stop()
		timerTaintedPolymorphCD:Stop()
		timerExplosiveOrdnanceCD:Stop()
		timerChainsofServitudeCD:Stop()
		timerDarkGazeCD:Stop()--Stopped when she dies or eye?
		DBM:EndCombat(self)
		started = false
	elseif cid == 158315 then--Eye of Chaos
		timerDarkGazeCD:Stop()--Stopped when she dies or eye?
	elseif cid == 156577 then--Therum Deepforge
		timerExplosiveOrdnanceCD:Stop()
		self.vb.TherumCleared = true
	elseif cid == 153541 then--slavemaster-ulrok
		timerChainsofServitudeCD:Stop()
		self.vb.UlrokCleared = true
	elseif cid == 158157 then--Overlord Mathias Shaw
		timerDarkGazeCD:Stop()--Stopped when he dies or eye?
		self.vb.ShawCleared = true
	elseif cid == 158035 then--Magister Umbric
		timerTaintedPolymorphCD:Stop()
		self.vb.UmbricCleared = true
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	local uiMap = C_Map.GetBestMapForUnit("player")
	if started and uiMap ~= 1470 then
		DBM:EndCombat(self, true)
		started = false
	elseif not uiMap and uiMap == 1470 then
		self:StartCombat(self, 0, "LOADING_SCREEN_DISABLED")
		started = true
	end
end

function mod:ENCOUNTER_START(encounterID)
	if encounterID == 2338 and self:IsInCombat() then
		timerDarkenedSkyCD:Start(4.9)
		timerVoidEruptionCD:Start(20.5)
		if self.vb.TherumCleared then
			timerExplosiveOrdnanceCD:Start(9.7)
		end
		if self.vb.UlrokCleared then
			timerChainsofServitudeCD:Start(1)
		end
		if self.vb.ShawCleared then
			timerDarkGazeCD:Start(1)
		end
		if self.vb.UmbricCleared then
			timerTaintedPolymorphCD:Start(1)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 312260 and self:AntiSpam(3, 1) then--Explosive Ordnance (not in combat log)
		self:SendSync("ExplosiveOrd")
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "ExplosiveOrd" then
		warnExplosiveOrdnance:Show()
		timerExplosiveOrdnanceCD:Start()
	end
end

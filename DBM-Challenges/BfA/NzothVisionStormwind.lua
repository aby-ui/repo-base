local mod	= DBM:NewMod("d1993", "DBM-Challenges", 2)--1993 Stormwind 1995 Org
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210404132247")

mod:RegisterCombat("scenario", 2213)--2212, 2213 (org, stormwind)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 308278 309819 309648 298691 308669 308366 308406 311456 296911 296537 308481 308575 298033 308375 309882 309671 308305 311399 297315 308998 308265 296669",
	"SPELL_AURA_APPLIED 311390 315385 316481 311641 308380 308366 308265 308998",
	"SPELL_AURA_APPLIED_DOSE 311390",
	"SPELL_AURA_REMOVED 308998 298033",
	"SPELL_CAST_SUCCESS 309035",
	"SPELL_PERIODIC_DAMAGE 312121 296674 308807 313303",
	"SPELL_PERIODIC_MISSED 312121 296674 308807 313303",
	"SPELL_INTERRUPT",
	"UNIT_DIED",
	"ENCOUNTER_START",
	"UNIT_SPELLCAST_SUCCEEDED_UNFILTERED",
	"UNIT_SPELLCAST_INTERRUPTED_UNFILTERED",
	"UNIT_AURA player",
	"NAME_PLATE_UNIT_ADDED",
	"FORBIDDEN_NAME_PLATE_UNIT_ADDED"
)

--TODO, maybe add https://ptr.wowhead.com/spell=292021/madness-leaden-foot#see-also-other affix? just depends on warning to stop moving can be counter to a stacked affix
--TODO, see if target scanning will work on Entropic Leap
--General
local warnGiftoftheTitans		= mod:NewSpellAnnounce(313698, 1)
local warnScorchedFeet			= mod:NewSpellAnnounce(315385, 4)
--Extra Abilities (used by main boss and the area LTs)
local warnTaintedPolymorph		= mod:NewCastAnnounce(309648, 3)
local warnEntropicMissiles		= mod:NewSpellAnnounce(309373, 3)
local warnExplosiveOrdnance		= mod:NewSpellAnnounce(305672, 3)
local warnSeekAndDestroy		= mod:NewSpellAnnounce(311570, 3)
local warnSummonEyeofChaos		= mod:NewSpellAnnounce(308681, 2)
local warnCorruptedBlight		= mod:NewCastAnnounce(308265, 3)
local warnLurkingAppendage		= mod:NewCastAnnounce(296669, 3)
--Other notable abilities by mini bosses/trash
local warnEntropicLeap			= mod:NewCastAnnounce(308406, 3)
local warnConvert				= mod:NewTargetNoFilterAnnounce(308380, 3)
local warnImprovedMorale		= mod:NewTargetNoFilterAnnounce(308998, 3)
local warnTouchoftheAbyss		= mod:NewCastAnnounce(298033, 4)
local warnBrutalSmash			= mod:NewCastAnnounce(309882, 3)

--General (GTFOs and Affixes)
local specWarnGTFO				= mod:NewSpecialWarningGTFO(312121, nil, nil, nil, 1, 8)
local specWarnEntomophobia		= mod:NewSpecialWarningJump(311389, nil, nil, nil, 1, 6)
local specWarnHauntingShadows	= mod:NewSpecialWarningDodge(306545, false, nil, 4, 1, 2)
local specWarnScorchedFeet		= mod:NewSpecialWarningYou(315385, false, nil, 2, 1, 2)
local yellScorchedFeet			= mod:NewYell(315385)
local specWarnSplitPersonality	= mod:NewSpecialWarningYou(316481, nil, nil, nil, 1, 2)
local specWarnWaveringWill		= mod:NewSpecialWarningReflect(311641, "false", nil, nil, 1, 2)--Off by default, it's only 5%, but that might matter to some classes
--Alleria Windrunner
local specWarnDarkenedSky		= mod:NewSpecialWarningDodge(308278, nil, nil, nil, 2, 2)
local specWarnVoidEruption		= mod:NewSpecialWarningMoveTo(309819, nil, nil, nil, 3, 2)
--Extra Abilities (used by Alleria and the area LTs)
local specWarnChainsofServitude	= mod:NewSpecialWarningRun(298691, nil, nil, nil, 4, 2)
local specWarnDarkGaze			= mod:NewSpecialWarningLookAway(308669, false, nil, 2, 2, 2)
local specWarnForgeBreath		= mod:NewSpecialWarningDodge(309671, nil, nil, nil, 2, 2)
local specWarnTaintedPolymorph	= mod:NewSpecialWarningInterrupt(309648, "HasInterrupt", nil, nil, 1, 2)
--Other notable abilities by mini bosses/trash
local specWarnAgonizingTorment	= mod:NewSpecialWarningInterrupt(308366, "HasInterrupt", nil, nil, 1, 2)
local specWarnEntropicMissiles	= mod:NewSpecialWarningInterrupt(309035, "HasInterrupt", nil, nil, 1, 2)
local specWarnMentalAssault		= mod:NewSpecialWarningInterrupt(296537, "HasInterrupt", nil, nil, 1, 2)
local specWarnShadowShift		= mod:NewSpecialWarningInterrupt(308575, "HasInterrupt", nil, nil, 1, 2)
local specWarnTouchoftheAbyss	= mod:NewSpecialWarningInterrupt(298033, "HasInterrupt", nil, nil, 1, 2)
local specWarnPsychicScream		= mod:NewSpecialWarningInterrupt(308375, "HasInterrupt", nil, nil, 1, 2)
local specWarnImproveMorale		= mod:NewSpecialWarningInterrupt(308998, "HasInterrupt", nil, nil, 1, 2)
local specWarnVoidBuffet		= mod:NewSpecialWarningInterrupt(297315, "HasInterrupt", nil, nil, 1, 2)
local specWarnBladeFlourish		= mod:NewSpecialWarningRun(311399, nil, nil, nil, 4, 2)
local specWarnRoaringBlast		= mod:NewSpecialWarningDodge(311456, nil, nil, nil, 2, 2)
local specWarnChaosBreath		= mod:NewSpecialWarningDodge(296911, nil, nil, nil, 2, 2)
local specWarnAgonizingTormentD	= mod:NewSpecialWarningDispel(308366, "RemoveCurse", nil, nil, 1, 2)
local specWarnCorruptedBlight	= mod:NewSpecialWarningDispel(308265, "RemoveDisease", nil, 2, 1, 2)
local specWarnBlightEruption	= mod:NewSpecialWarningMoveAway(308305, nil, nil, nil, 1, 2)
local yellBlightEruption		= mod:NewYell(308305)
local specWarnRiftStrike		= mod:NewSpecialWarningDodge(308481, nil, nil, nil, 2, 2)

--General
local timerGiftoftheTitan		= mod:NewBuffFadesTimer(20, 313698, nil, nil, nil, 5)
--Affixes/Masks
local timerDarkImaginationCD	= mod:NewCDTimer(60, 315976, nil, nil, nil, 1, 296733)
--Alleria Windrunner
local timerDarkenedSkyCD		= mod:NewCDTimer(13.3, 308278, nil, nil, nil, 3)
local timerVoidEruptionCD		= mod:NewCDTimer(27.9, 309819, nil, nil, nil, 2)
--Extra Abilities (used by Alleria and the area LTs)
--local timerTaintedPolymorphCD	= mod:NewAITimer(21, 309648, nil, nil, nil, 3, nil, DBM_CORE_L.MAGIC_ICON)
--local timerExplosiveOrdnanceCD	= mod:NewCDTimer(20.7, 305672, nil, nil, nil, 3)--20-25 (on alleria anyways, forgot to log other guy)

mod:AddInfoFrameOption(307831, true)
mod:AddNamePlateOption("NPAuraOnHaunting2", 306545, false)
mod:AddNamePlateOption("NPAuraOnAbyss", 298033)
mod:AddNamePlateOption("NPAuraOnMorale", 308998)

--Antispam 1: Boss throttles, 2: GTFOs, 3: Dodge stuff on ground. 4: Face Away/special action. 5: Dodge Shockwaves

local playerName = UnitName("player")
mod.vb.TherumCleared = false
mod.vb.UlrokCleared = false
mod.vb.ShawCleared = false
mod.vb.UmbricCleared = false
local warnedGUIDs = {}

--If you have potions when run ends, the debuffs throw you in combat for about 6 seconds after run has ended
local function DelayedNameplateFix(self, once)
	--Check if we changed users nameplate options and restore them
	if self.Options.CVAR1 or self.Options.CVAR2 or self.Options.CVAR3 then
		if InCombatLockdown() then
			if once then return end
			--In combat, delay nameplate fix
			DBM:Schedule(2, DelayedNameplateFix, self)
		else
			if self.Options.CVAR1 then
				SetCVar("nameplateShowFriends", self.Options.CVAR1)
			end
			if self.Options.CVAR2 then
				SetCVar("nameplateShowFriendlyNPCs", self.Options.CVAR2)
			end
			if self.Options.CVAR3 then
				SetCVar("nameplateShowOnlyNames", self.Options.CVAR3)
			end
			self.Options.CVAR1, self.Options.CVAR2, self.Options.CVAR3 = nil, nil, nil
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.TherumCleared = false
	self.vb.UlrokCleared = false
	self.vb.ShawCleared = false
	self.vb.UmbricCleared = false
	table.wipe(warnedGUIDs)
	DelayedNameplateFix(self, true)--Repair settings from previous session if they didn't get repaired in last session
	if self.Options.SpecWarn306545dodge4 then
		--This warning requires friendly nameplates, because it's only way to detect it.
		self.Options.CVAR1, self.Options.CVAR2, self.Options.CVAR3 = tonumber(GetCVar("nameplateShowFriends") or 0), tonumber(GetCVar("nameplateShowFriendlyNPCs") or 0), tonumber(GetCVar("nameplateShowOnlyNames") or 0)
		--Check if they were disabled, if disabled, force enable them
		if self.Options.CVAR1 == 0 then
			SetCVar("nameplateShowFriends", 1)
		end
		if self.Options.CVAR2 == 0 then
			SetCVar("nameplateShowFriendlyNPCs", 1)
		end
		if self.Options.CVAR3 == 0 then
			SetCVar("nameplateShowOnlyNames", 1)
		end
		--Making this option rely on another option is kind of required because this won't work without nameplateShowFriendlyNPCs
		if not DBM:HasMapRestrictions() and self.Options.NPAuraOnHaunting2 then
			DBM:FireEvent("BossMod_EnableFriendlyNameplates")
		end
	end
	if self.Options.NPAuraOnAbyss or self.Options.NPAuraOnMorale then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
		DBM.InfoFrame:Show(5, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
	end
end

function mod:OnCombatEnd()
	table.wipe(warnedGUIDs)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.NPAuraOnAbyss or self.Options.NPAuraOnHaunting2 or self.Options.NPAuraOnMorale then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, self.Options.NPAuraOnAbyss or self.Options.NPAuraOnMorale, self.Options.CVAR1)--isGUID, unit, spellId, texture, force, isHostile, isFriendly
	end
	--Check if we changed users nameplate options and restore them
	DelayedNameplateFix(self)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 308278 then
		specWarnDarkenedSky:Show()
		specWarnDarkenedSky:Play("watchstep")
		timerDarkenedSkyCD:Start()
	elseif spellId == 309819 then
		specWarnVoidEruption:Show(DBM_CORE_L.BREAK_LOS)
		specWarnVoidEruption:Play("findshelter")
		timerVoidEruptionCD:Start()
	elseif spellId == 309648 then
		if self.Options.SpecWarn309648interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTaintedPolymorph:Show(args.sourceName)
			specWarnTaintedPolymorph:Play("kickcast")
		else
			warnTaintedPolymorph:Show()
		end
		--timerTaintedPolymorphCD:Start()
	elseif spellId == 298691 then
		specWarnChainsofServitude:Show()
		specWarnChainsofServitude:Play("justrun")
	elseif spellId == 308669 and self:AntiSpam(5, 4) then
		specWarnDarkGaze:Show(args.sourceName)
		specWarnDarkGaze:Play("turnaway")
	elseif spellId == 308366 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnAgonizingTorment:Show(args.sourceName)
		specWarnAgonizingTorment:Play("kickcast")
	elseif spellId == 296537 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMentalAssault:Show(args.sourceName)
		specWarnMentalAssault:Play("kickcast")
	elseif spellId == 308575 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowShift:Show(args.sourceName)
		specWarnShadowShift:Play("kickcast")
	elseif spellId == 308375 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnPsychicScream:Show(args.sourceName)
		specWarnPsychicScream:Play("kickcast")
	elseif spellId == 297315 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnVoidBuffet:Show(args.sourceName)
		specWarnVoidBuffet:Play("kickcast")
	elseif spellId == 308998 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnImproveMorale:Show(args.sourceName)
		specWarnImproveMorale:Play("kickcast")
	elseif spellId == 298033 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTouchoftheAbyss:Show(args.sourceName)
			specWarnTouchoftheAbyss:Play("kickcast")
		else
			warnTouchoftheAbyss:Show()
		end
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Show(true, args.sourceGUID, 298033, nil, 7)
		end
	elseif spellId == 308406 then
		warnEntropicLeap:Show()
	elseif spellId == 311456 and self:AntiSpam(3, 5) then
		specWarnRoaringBlast:Show()
		specWarnRoaringBlast:Play("shockwave")
	elseif spellId == 296911 and self:AntiSpam(3, 5) then
		specWarnChaosBreath:Show()
		specWarnChaosBreath:Play("shockwave")
	elseif spellId == 309671 and self:AntiSpam(3, 5) then
		specWarnForgeBreath:Show()
		specWarnForgeBreath:Play("shockwave")
	elseif spellId == 308481 and self:AntiSpam(5, 3) then
		specWarnRiftStrike:Show()
		specWarnRiftStrike:Play("watchstep")
	elseif spellId == 309882 and self:AntiSpam(5, 3) then
		warnBrutalSmash:Show()
	elseif spellId == 308305 and GetNumGroupMembers() > 1 and DBM:UnitDebuff("player", 308265) then
		specWarnBlightEruption:Show()
		specWarnBlightEruption:Play("runout")
		yellBlightEruption:Yell()
	elseif spellId == 311399 then
		specWarnBladeFlourish:Show()
		specWarnBladeFlourish:Play("justrun")
	elseif spellId == 308265 then
		warnCorruptedBlight:Show()
	elseif spellId == 296669 then
		warnLurkingAppendage:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 309035 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnEntropicMissiles:Show(args.sourceName)
		specWarnEntropicMissiles:Play("kickcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 311390 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 4 then
			specWarnEntomophobia:Show()
			specWarnEntomophobia:Play("keepjump")
		end
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
		if self:CheckDispelFilter() then
			specWarnCorruptedBlight:Show(args.destName)
			specWarnCorruptedBlight:Play("helpdispel")
		end
	elseif spellId == 308998 then
		warnImprovedMorale:CombinedShow(0.5, args.destName)
		if self.Options.NPAuraOnMorale then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 12)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 308998 then
		if self.Options.NPAuraOnMorale then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 298033 then
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Hide(true, args.sourceGUID, 298033)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if (spellId == 296674 or spellId == 312121 or spellId == 308807 or spellId == 313303) and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and args.extraSpellId == 298033 then
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Hide(true, args.destGUID, 298033)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152718 then--Alleria Windrunner
		timerDarkenedSkyCD:Stop()
		timerVoidEruptionCD:Stop()
		--timerTaintedPolymorphCD:Stop()
		--timerExplosiveOrdnanceCD:Stop()
		DBM:EndCombat(self)
	elseif cid == 156577 then--Therum Deepforge
		--timerExplosiveOrdnanceCD:Stop()
		self.vb.TherumCleared = true
	elseif cid == 153541 then--slavemaster-ulrok
		self.vb.UlrokCleared = true
	elseif cid == 158157 then--Overlord Mathias Shaw
		self.vb.ShawCleared = true
	elseif cid == 158035 then--Magister Umbric
		--timerTaintedPolymorphCD:Stop()
		self.vb.UmbricCleared = true
	elseif cid == 156795 then--S.I. Informant
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Hide(true, args.destGUID, 298033)
		end
	end
end

function mod:ENCOUNTER_START(encounterID)
	if encounterID == 2338 and self:IsInCombat() then
		timerDarkenedSkyCD:Start(4.9)
		timerVoidEruptionCD:Start(20.5)
		--if self.vb.TherumCleared then
			--timerExplosiveOrdnanceCD:Start(9.7)
		--end
		--if self.vb.UlrokCleared then

		--end
		--if self.vb.UmbricCleared then
		--	timerTaintedPolymorphCD:Start(27.9)
		--end
	end
end

--None of these boss abilities are in combat log
function mod:UNIT_SPELLCAST_SUCCEEDED_UNFILTERED(uId, _, spellId)
	if (spellId == 305708 or spellId == 312260) and self:AntiSpam(2, 1) then
		self:SendSync("ExplosiveOrd")
	elseif spellId == 309035 and self:AntiSpam(2, 1) then
		self:SendSync("EntropicMissiles")
	elseif spellId == 311530 and self:AntiSpam(2, 1) then
		self:SendSync("SeekandDestroy")
	elseif spellId == 308681 and self:AntiSpam(2, 1) then
		self:SendSync("SummonEye")
	elseif spellId == 18950 and self:AntiSpam(2, 6) then
		local cid = self:GetUnitCreatureId(uId)
		if cid == 164189 or cid == 164188 then
			self:SendSync("DarkImagination")
		end
	end
end

function mod:UNIT_SPELLCAST_INTERRUPTED_UNFILTERED(uId, _, spellId)
	if spellId == 298033 then
		if self.Options.NPAuraOnAbyss then
			local guid = UnitGUID(uId)
			DBM.Nameplate:Hide(true, guid, 298033)
		end
	end
end

do
	--Gift of the Titans isn't in combat log either
	local titanWarned = false
	function mod:UNIT_AURA(uId)
		local hasTitan = DBM:UnitBuff("player", 313698)
		if hasTitan and not titanWarned then
			warnGiftoftheTitans:Show()
			timerGiftoftheTitan:Start()
			titanWarned = true
		elseif not hasTitan and titanWarned then
			titanWarned = false
		end
	end
end

function mod:NAME_PLATE_UNIT_ADDED(unit)
	if unit and (UnitName(unit) == playerName) and not (UnitPlayerOrPetInRaid(unit) or UnitPlayerOrPetInParty(unit)) then
		local guid = UnitGUID(unit)
		if not guid then return end
		if not warnedGUIDs[guid] then
			warnedGUIDs[guid] = true
			if self:AntiSpam(2, 2) then--Throttled because sometimes two spawn at once
				specWarnHauntingShadows:Show()
				specWarnHauntingShadows:Play("runaway")
			end
		end
		if not DBM:HasMapRestrictions() and self.Options.NPAuraOnHaunting2 then
			DBM.Nameplate:Show(true, guid, 306545, 1029718, 5)
		end
	end
end
mod.FORBIDDEN_NAME_PLATE_UNIT_ADDED = mod.NAME_PLATE_UNIT_ADDED--Just in case blizzard fixes map restrictions

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "ExplosiveOrd" then
		warnExplosiveOrdnance:Show()
	elseif msg == "EntropicMissiles" then
		warnEntropicMissiles:Show()
	elseif msg == "SeekandDestroy" then
		warnSeekAndDestroy:Show()
	elseif msg == "SummonEye" then
		warnSummonEyeofChaos:Show()
	elseif msg == "DarkImagination" then
		timerDarkImaginationCD:Start()
	end
end

local mod	= DBM:NewMod("d1995", "DBM-Challenges", 2)--1993 Stormwind 1995 Org
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211208050610")

mod:RegisterCombat("scenario", 2212)--2212, 2213 (org, stormwind)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 297822 297746 304976 297574 304251 306726 299110 307863 300351 300388 304101 304282 306001 306199 303589 305875 306828 306617 300388 296537 305378 298630 298033 305236 304169 298502 297315",
	"SPELL_AURA_APPLIED 311390 315385 316481 311641 299055",
	"SPELL_AURA_APPLIED_DOSE 311390",
	"SPELL_AURA_REMOVED 298033",
	"SPELL_CAST_SUCCESS 297237 305378",
	"SPELL_PERIODIC_DAMAGE 303594 313303",
	"SPELL_PERIODIC_MISSED 303594 313303",
	"SPELL_INTERRUPT",
	"UNIT_DIED",
	"ENCOUNTER_START",
	"UNIT_SPELLCAST_SUCCEEDED_UNFILTERED",
	"UNIT_SPELLCAST_INTERRUPTED_UNFILTERED",
	"UNIT_AURA player",
	"NAME_PLATE_UNIT_ADDED",
	"FORBIDDEN_NAME_PLATE_UNIT_ADDED"
)

--TODO, maybe add https://ptr.wowhead.com/spell=298510/aqiri-mind-toxin
--TODO, improve https://ptr.wowhead.com/spell=306001/explosive-leap warning if can get throw target
--TODO, can https://ptr.wowhead.com/spell=305875/visceral-fluid be dodged? If so upgrade the warning
local warnGiftoftheTitans			= mod:NewSpellAnnounce(313698, 1)
local warnScorchedFeet				= mod:NewSpellAnnounce(315385, 4)
--Extra Abilities (used by main boss and the area LTs)
local warnCriesoftheVoid			= mod:NewCastAnnounce(304976, 4)
local warnVoidQuills				= mod:NewCastAnnounce(304251, 3)
--Other notable abilities by mini bosses/trash
local warnDarkForce					= mod:NewTargetNoFilterAnnounce(299055, 3)
local warnExplosiveLeap				= mod:NewCastAnnounce(306001, 3)
local warnEndlessHungerTotem		= mod:NewSpellAnnounce(297237, 4)
local warnHorrifyingShout			= mod:NewCastAnnounce(305378, 4)
local warnTouchoftheAbyss			= mod:NewCastAnnounce(298033, 4)
local warnToxicBreath				= mod:NewSpellAnnounce(298502, 2)

--General (GTFOs and Affixes)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(303594, nil, nil, nil, 1, 8)
local specWarnEntomophobia			= mod:NewSpecialWarningJump(311389, nil, nil, nil, 1, 6)
local specWarnHauntingShadows		= mod:NewSpecialWarningDodge(306545, false, nil, 4, 1, 2)
local specWarnScorchedFeet			= mod:NewSpecialWarningYou(315385, false, nil, 2, 1, 2)
local yellScorchedFeet				= mod:NewYell(315385)
local specWarnSplitPersonality		= mod:NewSpecialWarningYou(316481, nil, nil, nil, 1, 2)
local specWarnWaveringWill			= mod:NewSpecialWarningReflect(311641, "false", nil, nil, 1, 2)--Off by default, it's only 5%, but that might matter to some classes
--Thrall
local specWarnSurgingDarkness		= mod:NewSpecialWarningDodge(297822, nil, nil, nil, 2, 2)
local specWarnSeismicSlam			= mod:NewSpecialWarningDodge(297746, nil, nil, nil, 2, 2)
local yellSeismicSlam				= mod:NewYell(297746)
local yellDefiledGround				= mod:NewYell(306726)
--Extra Abilities (used by Thrall and the area LTs)
local specWarnHopelessness			= mod:NewSpecialWarningMoveTo(297574, nil, nil, nil, 1, 2)
local specWarnDefiledGround			= mod:NewSpecialWarningDodge(306726, nil, nil, nil, 2, 2)--Can this be dodged?
--Other notable abilities by mini bosses/trash
local specWarnOrbofAnnihilation		= mod:NewSpecialWarningDodge(299110, nil, nil, nil, 2, 2)
local specWarnDarkForce				= mod:NewSpecialWarningYou(299055, nil, nil, nil, 1, 2)
local specWarnVoidTorrent			= mod:NewSpecialWarningYou(307863, nil, nil, nil, 4, 2)
local yellVoidTorrent				= mod:NewYell(307863)
local specWarnSurgingFist			= mod:NewSpecialWarningDodge(300351, nil, nil, nil, 2, 2)
local specWarnDecimator				= mod:NewSpecialWarningDodge(300412, nil, nil, nil, 2, 2)
local specWarnDesperateRetching		= mod:NewSpecialWarningYou(304165, nil, nil, nil, 1, 2)
local yellDesperateRetching			= mod:NewYell(304165)
local specWarnDesperateRetchingD	= mod:NewSpecialWarningDispel(304165, "RemoveDisease", nil, nil, 1, 2)
local specWarnMaddeningRoar			= mod:NewSpecialWarningRun(304101, nil, nil, nil, 4, 2)
local specWarnStampedingCorruption	= mod:NewSpecialWarningDodge(304282, nil, nil, nil, 2, 2)
local specWarnHowlinginPain			= mod:NewSpecialWarningCast(306199, "SpellCaster", nil, nil, 1, 2)
local specWarnSanguineResidue		= mod:NewSpecialWarningDodge(303589, nil, nil, nil, 2, 2)
local specWarnRingofChaos			= mod:NewSpecialWarningDodge(306617, nil, nil, nil, 2, 2)
local specWarnHorrifyingShout		= mod:NewSpecialWarningInterrupt(305378, "HasInterrupt", nil, nil, 1, 2)
local specWarnMentalAssault			= mod:NewSpecialWarningInterrupt(296537, "HasInterrupt", nil, nil, 1, 2)
local specWarnTouchoftheAbyss		= mod:NewSpecialWarningInterrupt(298033, "HasInterrupt", nil, nil, 1, 2)
local specWarnVenomBolt				= mod:NewSpecialWarningInterrupt(305236, "HasInterrupt", nil, nil, 1, 2)
local specWarnVoidBuffet			= mod:NewSpecialWarningInterrupt(297315, "HasInterrupt", nil, nil, 1, 2)
local specWarnShockwave				= mod:NewSpecialWarningDodge(298630, nil, nil, nil, 2, 2)
local specWarnVisceralFluid			= mod:NewSpecialWarningDodge(305875, nil, nil, nil, 2, 2)
local specWarnToxicVolley			= mod:NewSpecialWarningDodge(304169, nil, nil, nil, 2, 2)

--General
local timerGiftoftheTitan		= mod:NewBuffFadesTimer(20, 313698, nil, nil, nil, 5)
--Affixes/Masks
local timerDarkImaginationCD	= mod:NewCDTimer(60, 315976, nil, nil, nil, 1, 296733)
--Thrall
local timerSurgingDarknessCD	= mod:NewCDTimer(20.6, 297822, nil, nil, nil, 3)
local timerSeismicSlamCD		= mod:NewCDTimer(12.1, 297746, nil, nil, nil, 3)
--Extra Abilities (used by Thrall and the area LTs)
local timerDefiledGroundCD		= mod:NewCDTimer(12.1, 306726, nil, nil, nil, 3)
--Other notable elite timers
local timerSurgingFistCD		= mod:NewCDTimer(9.7, 300351, nil, nil, nil, 3)
local timerDecimatorCD			= mod:NewCDTimer(9.7, 300412, nil, nil, nil, 3)
local timerToxicBreathCD		= mod:NewCDTimer(7.3, 298502, nil, nil, nil, 3)
local timerToxicVolleyCD		= mod:NewCDTimer(7.3, 304169, nil, nil, nil, 3)

mod:AddInfoFrameOption(307831, true)
mod:AddNamePlateOption("NPAuraOnHaunting2", 306545, false)
mod:AddNamePlateOption("NPAuraOnAbyss", 298033)
mod:AddNamePlateOption("NPAuraOnHorrifyingShout", 305378)

--AntiSpam Throttles: 1-Unique ability, 2-watch steps, 3-shockwaves, 4-GTFOs
local playerName = UnitName("player")
mod.vb.GnshalCleared = false
mod.vb.VezokkCleared = false
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

function mod:DefiledGroundTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellDefiledGround:Yell()
	end
end

function mod:SeismicSlamTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellSeismicSlam:Yell()
	end
end

function mod:VoidTorrentTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnVoidTorrent:Show()
		specWarnVoidTorrent:Play("justrun")
		yellVoidTorrent:Yell()
	end
end

function mod:OnCombatStart(delay)
	self.vb.GnshalCleared = false
	self.vb.VezokkCleared = false
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
	if self.Options.NPAuraOnAbyss or self.Options.NPAuraOnHorrifyingShout then
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
	if self.Options.NPAuraOnAbyss or self.Options.NPAuraOnHaunting2 or self.Options.NPAuraOnHorrifyingShout then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, self.Options.NPAuraOnAbyss or self.Options.NPAuraOnHorrifyingShout, self.Options.CVAR1)--isGUID, unit, spellId, texture, force, isHostile, isFriendly
	end
	--Check if we changed users nameplate options and restore them
	DelayedNameplateFix(self)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 297822 then
		if self:AntiSpam(2, 2) then
			specWarnSurgingDarkness:Show()
			specWarnSurgingDarkness:Play("watchstep")
		end
		timerSurgingDarknessCD:Start()
	elseif spellId == 297746 then
		if self:AntiSpam(3, 3) then
			specWarnSeismicSlam:Show()
			specWarnSeismicSlam:Play("shockwave")
		end
		timerSeismicSlamCD:Start()
		if GetNumGroupMembers() > 1 then
			self:BossTargetScanner(args.sourceGUID, "SeismicSlamTarget", 0.1, 7)
		end
	elseif spellId == 304976 then
		warnCriesoftheVoid:Show()
		--timerCriesoftheVoidCD:Start()
	elseif spellId == 297574 then
		specWarnHopelessness:Show(DBM_COMMON_L.ORB)
		specWarnHopelessness:Play("orbrun")--Technically not quite accurate but closest match to "find orb"
	elseif spellId == 304251 and self:AntiSpam(3.5, 1) then--1-4 boars, 3.5 second throttle
		warnVoidQuills:Show()
	elseif spellId == 306726 or spellId == 306828 then
		if self:AntiSpam(3, 3) then
			specWarnDefiledGround:Show()
			specWarnDefiledGround:Play("shockwave")
		end
		timerDefiledGroundCD:Start()
		if GetNumGroupMembers() > 1 then
			self:BossTargetScanner(args.sourceGUID, "DefiledGroundTarget", 0.1, 7)
		end
	elseif spellId == 299055 then
		if args:IsPlayer() then
			specWarnDarkForce:Show()
			specWarnDarkForce:Play("targetyou")
		else
			warnDarkForce:Show(args.destName)
		end
	elseif spellId == 299110 and self:AntiSpam(2, 2) then
		specWarnOrbofAnnihilation:Show()
		specWarnOrbofAnnihilation:Play("watchstep")
	elseif spellId == 307863 then
		if GetNumGroupMembers() > 1 then
			self:BossTargetScanner(args.sourceGUID, "VoidTorrentTarget", 0.1, 7)
		else
			specWarnVoidTorrent:Show()
			specWarnVoidTorrent:Play("justrun")
		end
	elseif spellId == 300351 then
		specWarnSurgingFist:Show()
		specWarnSurgingFist:Play("chargemove")
		timerSurgingFistCD:Start()
	elseif spellId == 300388 then
		specWarnDecimator:Show()
		specWarnDecimator:Play("watchorb")
		timerDecimatorCD:Start()
	elseif spellId == 304101 then
		specWarnMaddeningRoar:Show()
		specWarnMaddeningRoar:Play("justrun")
	elseif spellId == 304282 and self:AntiSpam(2, 2) then
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
	elseif spellId == 305875 and self:AntiSpam(2, 2) then
		specWarnVisceralFluid:Show()
		specWarnVisceralFluid:Play("watchstep")
	elseif spellId == 306617 then
		specWarnRingofChaos:Show()
		specWarnRingofChaos:Play("watchorb")
	elseif spellId == 296537 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMentalAssault:Show(args.sourceName)
		specWarnMentalAssault:Play("kickcast")
	elseif spellId == 305378 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHorrifyingShout:Show(args.sourceName)
			specWarnHorrifyingShout:Play("kickcast")
		else
			warnHorrifyingShout:Show()
		end
		if self.Options.NPAuraOnHorrifyingShout then
			DBM.Nameplate:Show(true, args.sourceGUID, 305378, nil, 2.5)
		end
	elseif spellId == 305236 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnVenomBolt:Show(args.sourceName)
		specWarnVenomBolt:Play("kickcast")
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
	elseif spellId == 298630 and self:AntiSpam(3, 3) then
		specWarnShockwave:Show()
		specWarnShockwave:Play("shockwave")
	elseif spellId == 304169 then
		if self:AntiSpam(2, 2) then
			specWarnToxicVolley:Show()
			specWarnToxicVolley:Play("watchstep")
		end
		timerToxicVolleyCD:Start()
	elseif spellId == 298502 then
		if self:AntiSpam(3, 3) then
			warnToxicBreath:Show()
		end
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid == 153532 then
			timerToxicBreathCD:Start()
		end
	elseif spellId == 297315 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnVoidBuffet:Show(args.sourceName)
		specWarnVoidBuffet:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 297237 then
		warnEndlessHungerTotem:Show()
	elseif spellId == 305378 then
		if self.Options.NPAuraOnHorrifyingShout then
			DBM.Nameplate:Hide(true, args.sourceGUID, 305378)
		end
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
	elseif spellId == 304165 then
		if args:IsPlayer() then
			specWarnDesperateRetching:Show()
			specWarnDesperateRetching:Play("keepmove")
			if GetNumGroupMembers() > 1 then
				yellDesperateRetching:Yell()
			end
		elseif self:CheckDispelFilter() then
			specWarnDesperateRetchingD:Show(args.destName)
			specWarnDesperateRetchingD:Play("helpdispel")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 298033 then
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Hide(true, args.sourceGUID, 298033)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if (spellId == 303594 or spellId == 313303) and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
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
	elseif type(args.extraSpellId) == "number" and args.extraSpellId == 305378 then
		if self.Options.NPAuraOnHorrifyingShout then
			DBM.Nameplate:Hide(true, args.destGUID, 305378)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152089 then--Thrall
		timerSurgingDarknessCD:Stop()
		timerSeismicSlamCD:Stop()
		--timerCriesoftheVoidCD:Stop()
		timerDefiledGroundCD:Stop()
		DBM:EndCombat(self)
	elseif cid == 156161 then--Inquisitor Gnshal
		--timerCriesoftheVoidCD:Stop()
		self.vb.GnshalCleared = true
	elseif cid == 152874 then--Vez'okk the Lightless
		timerDefiledGroundCD:Stop()
		self.vb.VezokkCleared = true
	elseif cid == 153943 then
		timerSurgingFistCD:Stop()
		timerDecimatorCD:Stop()
	elseif cid == 153401 then--K'thir Dominator
		if self.Options.NPAuraOnAbyss then
			DBM.Nameplate:Hide(true, args.destGUID, 298033)
		end
	elseif cid == 153532 then--Big Bug Guy
		timerToxicVolleyCD:Stop()
		timerToxicBreathCD:Stop()
	end
end

function mod:ENCOUNTER_START(encounterID)
	if not self:IsInCombat() then return end
	if encounterID == 2332 then--Thrall
		timerSurgingDarknessCD:Start(11.1)
		if self.vb.VezokkCleared then
			timerDefiledGroundCD:Start(1)
		else
			timerSeismicSlamCD:Start(4.6)
		end
	elseif encounterID == 2373 then--Vezokk
		timerDefiledGroundCD:Start(3.4)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED_UNFILTERED(uId, _, spellId)
	if spellId == 18950 and self:AntiSpam(2, 6) then
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
	elseif spellId == 305378 then
		if self.Options.NPAuraOnHorrifyingShout then
			local guid = UnitGUID(uId)
			DBM.Nameplate:Hide(true, guid, 305378)
		end
	end
end

do
	--In blizzards infinite wisdom, Gift of the Titans isn't in combat log
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
			if self:AntiSpam(2, 4) then--Throttled because sometimes two spawn at once
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
	if msg == "DarkImagination" then
		timerDarkImaginationCD:Start()
	end
end

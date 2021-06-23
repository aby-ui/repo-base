local mod	= DBM:NewMod(2444, "DBM-SanctumOfDomination", nil, 1193)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210523002923")
mod:SetCreatureID(175729)
mod:SetEncounterID(2432)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20201222000000)
--mod:SetMinSyncRevision(20201222000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 355123 351066 351067 351073 350469",--350096 350691 350518
--	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON 349908",
	"SPELL_AURA_APPLIED 355790 350469 349890 355790",--350097
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 355790 350469 355790",--350097
	"SPELL_PERIODIC_DAMAGE 350489",
	"SPELL_PERIODIC_MISSED 350489"
--	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, Fix timers if possible, right now they are near useless since they are all HIGHLY variable with no pattern as to why (no evidence shows shatter affects them)
--TODO, Orb of Torment's Unrelenting Torment cast removed? Same with Burst of Agony?
--[[
(ability.id = 349889 or ability.id = 355123 or ability.id = 351066 or ability.id = 351067 or ability.id = 351073 or ability.id = 350469 or ability.id = 350894) and type = "begincast"
 or ability.id = 349908
 or (ability.id = 350694 or ability.id = 349891 or ability.id = 355166) and type = "begincast"
 or (source.type = "NPC" and source.firstSeen = timestamp) or (target.type = "NPC" and target.firstSeen = timestamp)
--]]
local warnOrbofTorment							= mod:NewCountAnnounce(349908, 2)
local warnOrbEternalTorment						= mod:NewFadesAnnounce(355790, 1)
--local warnUnrelentingTorment					= mod:NewCountAnnounce(350518, 4)
local warnMalevolence							= mod:NewTargetNoFilterAnnounce(350469, 3)
--local warnSuffering							= mod:NewTargetNoFilterAnnounce(349890, 3)
--local warnAgony								= mod:NewTargetAnnounce(350097, 3)
local warnShatter								= mod:NewCountAnnounce(351066, 1)

local specWarnMalevolence						= mod:NewSpecialWarningYouPos(350469, nil, nil, nil, 1, 2)
local yellMalevolence							= mod:NewShortPosYell(350469)
local yellMalevolenceFades						= mod:NewIconFadesYell(350469)
local specWarnSuffering							= mod:NewSpecialWarningMoveTo(350894, nil, nil, nil, 1, 2)
local yellSuffering								= mod:NewYell(350894, nil, false)--Not as useful as fades
local yellSufferingFades						= mod:NewFadesYell(350894)
local specWarnSufferingSwap						= mod:NewSpecialWarningTaunt(350894, nil, nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(350489, nil, nil, nil, 1, 8)
local specWarnGraspofMalice						= mod:NewSpecialWarningDodge(355123, nil, nil, nil, 2, 2)--Malicious Gauntlet
--local specWarnAgony							= mod:NewSpecialWarningMoveAway(350097, nil, nil, nil, 1, 2)
--local yellAgony								= mod:NewYell(350097)
--local yellAgonyFades							= mod:NewFadesYell(350097)

--mod:AddTimerLine(BOSS)
local timerOrbofTormentCD						= mod:NewCDTimer(35.4, 349908, nil, nil, nil, 1, nil, nil, true)--31-60, kind of worthless timer
local timerMalevolenceCD						= mod:NewCDTimer(31.7, 350469, nil, nil, nil, 3, nil, DBM_CORE_L.CURSE_ICON, true)--Rattlecage of Agony
local timerSufferingCD							= mod:NewCDTimer(19.5, 350894, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON, true, mod:IsTank() and 2, 3)--Helm of Suffering
local timerGraspofMaliceCD						= mod:NewCDTimer(20.7, 355123, nil, nil, nil, 3, nil, nil, true)--Malicious Gauntlet
--local timerBurstofAgonyCD						= mod:NewAITimer(23, 350096, nil, nil, nil, 3)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(349890, true)
mod:AddSetIconOption("SetIconOnMalevolence", 350469, true, false, {1, 2, 3})
mod:AddSetIconOption("SetIconOnOrbs", 321226, true, true, {7, 8})
mod:AddNamePlateOption("NPAuraOnOrbEternalTorment", 355790)

mod.vb.orbCount = 0
mod.vb.iconCount = 8
mod.vb.unrelentingCount = 0
mod.vb.malevolenceCount = 0
mod.vb.malevolenceIcon = 1
mod.vb.shatterCount = 0

function mod:OnCombatStart(delay)
	self.vb.orbCount = 0
	self.vb.iconCount = 8
	self.vb.unrelentingCount = 0
	self.vb.malevolenceCount = 0
	self.vb.shatterCount = 0
	timerOrbofTormentCD:Start(15-delay)
	timerSufferingCD:Start(20.5-delay)
	timerMalevolenceCD:Start(26.5-delay)
	timerGraspofMaliceCD:Start(40-delay)--Probably doesn't start here
--	timerBurstofAgonyCD:Start(1-delay)--probably doesn't start here
--	berserkTimer:Start(-delay)
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(328897))
--		DBM.InfoFrame:Show(10, "table", ExsanguinatedStacks, 1)
--	end
	if self.Options.NPAuraOnOrbEternalTorment then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.NPAuraOnOrbEternalTorment then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 350894 then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnSuffering:Show(DBM_CORE_L.ORB)
			specWarnSuffering:Play("targetyou")--or orbrun.ogg?
			yellSuffering:Yell()
			yellSufferingFades:Countdown(3)
--		else
--			specWarnSufferingSwap:Show(args.destName)
--			specWarnSufferingSwap:Play("tauntboss")
		end
		timerSufferingCD:Start()
	elseif spellId == 355123 then
		specWarnGraspofMalice:Show()
		specWarnGraspofMalice:Play("watchstep")
		timerGraspofMaliceCD:Start()
--	elseif spellId == 350096 or spellId == 350691 then--Mythic/Heroic likely and normal/LFR likely
--		timerBurstofAgonyCD:Start()
	elseif spellId == 351066 or spellId == 351067 or spellId == 351073 then--Shatter (Helm of Suffering, Malicious Gauntlets, Rattlecage of Agony)
		self.vb.shatterCount = self.vb.shatterCount + 1
		warnShatter:Show(self.vb.shatterCount)
	elseif spellId == 350469 then
		self.vb.malevolenceIcon = 1
		self.vb.malevolenceCount = self.vb.malevolenceCount + 1
		timerMalevolenceCD:Start()
--	elseif spellId == 350518 then
--		self.vb.unrelentingCount = self.vb.unrelentingCount + 1
--		warnUnrelentingTorment:Show(self.vb.unrelentingCount)
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 350469 then
		self.vb.malevolenceIcon = 1
		self.vb.malevolenceCount = self.vb.malevolenceCount + 1
		timerMalevolenceCD:Start()
	end
end
--]]

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 349908 then
		if self:AntiSpam(3, 1) then
			self.vb.iconCount = 8
			self.vb.orbCount = self.vb.orbCount + 1
			warnOrbofTorment:Show(self.vb.orbCount)
			timerOrbofTormentCD:Start()
		end
		if self.Options.SetIconOnOrbs then
			self:ScanForMobs(args.destGUID, 2, self.vb.iconCount, 1, 0.2, 12, "SetIconOnOrbs")
		end
		self.vb.iconCount = self.vb.iconCount - 1
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 355790 then
		if self.Options.NPAuraOnOrbEternalTorment then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId, nil, 20)
		end
	elseif spellId == 350469 then
		local icon = self.vb.malevolenceIcon
		if self.Options.SetIconOnMalevolence then
			self:SetIcon(args.destName, icon)
		end
		if args:IsPlayer() then
			specWarnMalevolence:Show(self:IconNumToTexture(icon))
			specWarnMalevolence:Play("mm"..icon)
			yellMalevolence:Yell(icon, icon)
			yellMalevolenceFades:Countdown(spellId, nil, icon)
		end
		warnMalevolence:CombinedShow(0.3, args.destName)
		self.vb.malevolenceIcon = self.vb.malevolenceIcon + 1
--	elseif spellId == 349890 then
--		warnSuffering:Show(args.destName)
--[[	elseif spellId == 350097 then
		warnAgony:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnAgony:Show()
			specWarnAgony:Play("runout")
			yellAgony:Yell()
			yellAgonyFades:Countdown(spellId)
		end
	elseif spellId == 350894 then
		if args:IsPlayer() then
			specWarnSuffering:Show(DBM_CORE_L.ORB)
			specWarnSuffering:Play("targetyou")--or orbrun.ogg?
			yellSuffering:Yell()
			yellSufferingFades:Countdown(spellId)
		else
			specWarnSufferingSwap:Show(args.destName)
			specWarnSufferingSwap:Play("tauntboss")
		end--]]
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 355790 then
		if self.Options.NPAuraOnOrbEternalTorment then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
		if self:AntiSpam(3, 2) then
			warnOrbEternalTorment:Show()
		end
	elseif spellId == 350469 then
		if args:IsPlayer() then
			yellMalevolenceFades:Cancel()
		end
		if self.Options.SetIconOnMalevolence then
			self:SetIcon(args.destName, 0)
		end
--	elseif spellId == 350097 then
--		if args:IsPlayer() then
--			yellAgonyFades:Cancel()
--		end
--	elseif spellId == 350894 then
--		if args:IsPlayer() then
--			yellSufferingFades:Cancel()
--		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 350489 and destGUID == UnitGUID("player") and self:AntiSpam(2, 3) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--[[
function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 177289 then--https://ptr.wowhead.com/npc=177289/rattlecage-of-agony

	elseif cid == 177268 then--https://ptr.wowhead.com/npc=177268/helm-of-suffering

	elseif cid == 177287 then--https://ptr.wowhead.com/npc=177287/malicious-gauntlet

	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 350676 then--Orb of Torment
--		self.vb.iconCount = 8
--		self.vb.orbCount = self.vb.orbCount + 1
--		warnOrbofTorment:Show(self.vb.orbCount)
--		timerOrbofTormentCD:Start()
	end
end
--]]

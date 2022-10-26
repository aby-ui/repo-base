local mod	= DBM:NewMod(2504, "DBM-Party-Dragonflight", 8, 1204)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220830020512")
mod:SetCreatureID(189719)
mod:SetEncounterID(2615)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 389179 384351 384014 384524 389446",
	"SPELL_AURA_APPLIED 389179 383840 389443",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 389179",
	"SPELL_PERIODIC_DAMAGE 389181",
	"SPELL_PERIODIC_MISSED 389181"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, longer pulls since heroic is vastly undertuned
--[[
(ability.id = 389179 or ability.id = 384351 or ability.id = 384014 or ability.id = 384524 or ability.id = 389446) and type = "begincast"
 or ability.id = 383840
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 or (source.type = "NPC" and source.firstSeen = timestamp) or (target.type = "NPC" and target.firstSeen = timestamp)
--]]
--Stage One: A Chance at Redemption
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25745))
local warnPowerLoverload						= mod:NewTargetAnnounce(389179, 3)

local specWarnPowerOverload						= mod:NewSpecialWarningMoveAway(389179, nil, nil, nil, 1, 2)
local yellPowerOverload							= mod:NewYell(389179)
local yellPowerOverloadFades					= mod:NewShortFadesYell(389179)
local specWarnSparkVolley						= mod:NewSpecialWarningDodge(384351, nil, nil, nil, 2, 2)
local specWarnStaticSurge						= mod:NewSpecialWarningInterrupt(384014, "HasInterrupt", nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(389181, nil, nil, nil, 1, 8)
local specWarnTitanticFist						= mod:NewSpecialWarningDefensive(384524, nil, nil, nil, 1, 2)

local timerPowerOverloadCD						= mod:NewAITimer(35, 389179, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)
local timerSparkVolleyCD						= mod:NewAITimer(35, 384351, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)
local timerStaticSurgeCD						= mod:NewAITimer(35, 384014, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerTitanicFistCD						= mod:NewAITimer(35, 384524, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
--Stage Two: Watcher's Last Stand
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25744))
local warnAblativeBarrier						= mod:NewSpellAnnounce(383840, 2)
local warnAblativeBarrierOver					= mod:NewFadesAnnounce(383840, 1)
local warnNullifyingPulse						= mod:NewCastAnnounce(389446, 4)
local warnPurifyingBlast						= mod:NewTargetNoFilterAnnounce(389443, 3, nil, false)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerPowerOverloadCD:Start(1-delay)
	timerSparkVolleyCD:Start(1-delay)
	timerStaticSurgeCD:Start(1-delay)--10.1
	timerTitanicFistCD:Start(1-delay)--6.4
end

--function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 389179 then
		timerPowerOverloadCD:Start()
	elseif spellId == 384351 then
		specWarnSparkVolley:Show()
		specWarnSparkVolley:Play("watchstep")
		timerSparkVolleyCD:Start()
	elseif spellId == 384014 then
		timerStaticSurgeCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnStaticSurge:Show(args.sourceName)
			specWarnStaticSurge:Play("kickcast")
		end
	elseif spellId == 384524 then
		timerTitanicFistCD:Start()
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnTitanticFist:Show()
			specWarnTitanticFist:Play("defensive")
		end
	elseif spellId == 389446 and self:AntiSpam(3, 1) then
		warnNullifyingPulse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 389179 then
		warnPowerLoverload:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnPowerOverload:Show()
			specWarnPowerOverload:Play("runout")
			yellPowerOverload:Yell()
			yellPowerOverloadFades:Countdown(spellId)
		end
	elseif spellId == 383840 then
		warnAblativeBarrier:Show()
		if self.vb.phase == 1 then
			self:SetStage(2)
			timerPowerOverloadCD:Stop()
			timerSparkVolleyCD:Stop()
			timerStaticSurgeCD:Stop()
			timerTitanicFistCD:Stop()
		end
	elseif spellId == 389443 then
		warnPurifyingBlast:CombinedShow(1, args.destname)
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 389179 then
		if args:IsPlayer() then
			yellPowerOverloadFades:Cancel()
		end
	elseif spellId == 383840 then
		warnAblativeBarrierOver:Show()
		self:SetStage(1)
		timerPowerOverloadCD:Start(2)
		timerSparkVolleyCD:Start(2)--1.3
		timerStaticSurgeCD:Start(2)--5.3
		timerTitanicFistCD:Start(2)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 389181 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]

local mod	= DBM:NewMod("ArtifactXylem", "DBM-Challenges", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetCreatureID(115244)
mod:SetZone()--Healer (1710), Tank (1698), DPS (1703-The God-Queen's Fury), DPS (Fel Totem Fall)
mod.soloChallenge = true
mod.onlyNormal = true

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 234728",
	"SPELL_AURA_APPLIED 231443 233248",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS 232661 231522",
--	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)
--Notes:
--TODO, more timer work/data.
--TODO, phase 2
--Frost Phase
local warnFrostPhase				= mod:NewSpellAnnounce(242394, 2)
--Arcane Phase
local warnArcanePhase				= mod:NewSpellAnnounce(242386, 2)

--Frost Phase
local specWarnRazorIce				= mod:NewSpecialWarningDodge(232661, nil, nil, nil, 1, 2)
--Transition
local specWarnArcaneAnnihilation	= mod:NewSpecialWarningInterrupt(234728, nil, nil, nil, 1, 2)
--Arcane Phase
local specWarnShadowBarrage			= mod:NewSpecialWarningDodge(231443, nil, nil, nil, 2, 2)
local specWarnDrawPower				= mod:NewSpecialWarningInterrupt(231522, nil, nil, nil, 1, 2)
--Phase 2
local specWarnSeeds					= mod:NewSpecialWarningRun(233248, nil, nil, nil, 4, 2)

--Frost Phase
local timerRazorIceCD				= mod:NewCDTimer(25.5, 232661, nil, nil, nil, 3)--25.5-38.9 (other casts can delay it a lot)
--Transition
local timerArcaneAnnihilationCD		= mod:NewNextTimer(5, 234728, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerShadowBarrageCD			= mod:NewCDTimer(40.0, 231443, nil, nil, nil, 3)--Actually used both phases
--Arcane Phase
local timerDrawPowerCD				= mod:NewCDTimer(18.2, 231522, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)

--local countdownTimer				= mod:NewCountdownFades(10, 141582)

local activeBossGUIDS = {}

function mod:OnCombatStart(delay)
	timerRazorIceCD:Start(12-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 234423 then
		specWarnArcaneAnnihilation:Show(args.sourceName)
		specWarnArcaneAnnihilation:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 232661 then
		specWarnRazorIce:Show()
		specWarnRazorIce:Play("watchstep")
		timerRazorIceCD:Start()
	elseif spellId == 231522 then
		specWarnDrawPower:Show(args.sourceName)
		specWarnDrawPower:Play("kickcast")
		timerDrawPowerCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 231443 then
		specWarnShadowBarrage:Show()
		specWarnShadowBarrage:Play("watchorb")
		timerShadowBarrageCD:Start()
	elseif spellId == 233248 and args:IsPlayer() then
		specWarnSeeds:Show()
		specWarnSeeds:Play("runout")
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 242394 then--Frost Phase
		timerDrawPowerCD:Stop()
		warnFrostPhase:Show()
		timerArcaneAnnihilationCD:Start()
		timerRazorIceCD:Start(20)--20-33
	elseif spellId == 242386 then--Arcane Phase
		warnArcanePhase:Show()
		timerRazorIceCD:Stop()
		timerArcaneAnnihilationCD:Start()
		--timerShadowBarrageCD:Start(11)
		timerDrawPowerCD:Start(27)--27-42
	elseif spellId == 164393 then--Cancel Channeling (Successfully interrupted Arcane Annihilation)
		
	end
end

local mod	= DBM:NewMod(1656, "DBM-Party-Legion", 2, 762)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210905144759")
mod:SetCreatureID(99200)
mod:SetEncounterID(1838)
mod:DisableESCombatDetection()--Remove if blizz fixes trash firing ENCOUNTER_START

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 199389 199345",
	"SPELL_PERIODIC_DAMAGE 199460",
	"SPELL_PERIODIC_MISSED 199460",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnRoar						= mod:NewSpellAnnounce(199389, 2)

local specWarnDownDraft				= mod:NewSpecialWarningSpell(199345, nil, nil, nil, 2, 2)
local specWarnBreath				= mod:NewSpecialWarningDodge(199332, "Tank", nil, nil, 1, 2)
--local yellBreath					= mod:NewYell(199332)
local specWarnFallingRocks			= mod:NewSpecialWarningMove(199460, nil, nil, nil, 2, 2)

local timerBreathCD					= mod:NewCDTimer(15, 199332, nil, "Tank", nil, 5)--15/20 alternating? need more logs to confirm
local timerEarthShakerCD			= mod:NewCDTimer(21, 199389, nil, nil, nil, 3)
local timerDownDraftCD				= mod:NewCDTimer(29, 199345, nil, nil, nil, 2)--30-42 (health based or varaible?)

function mod:OnCombatStart(delay)
	timerBreathCD:Start(8-delay)
	timerEarthShakerCD:Start(15-delay)
	timerDownDraftCD:Start(20-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 199389 then
		warnRoar:Show()
	elseif spellId == 199345 then
		specWarnDownDraft:Show()
		specWarnDownDraft:Play("keepmove")
		timerDownDraftCD:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 199460 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnFallingRocks:Show()
		specWarnFallingRocks:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 199332 then--Even with this scanner, it's abougt 50/50 hit or miss you can grab a target at all
		specWarnBreath:Show()
		specWarnBreath:Play("breathsoon")
		timerBreathCD:Start()
	end
end

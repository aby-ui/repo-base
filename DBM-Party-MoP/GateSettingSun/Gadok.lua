local mod	= DBM:NewMod(675, "DBM-Party-MoP", 4, 303)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 96 $"):sub(12, -3))
mod:SetCreatureID(56589)
mod:SetEncounterID(1405)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 106933",
	"SPELL_AURA_REMOVED 106933",
	"SPELL_CAST_SUCCESS 107047",
	"SPELL_DAMAGE 115458",
	"SPELL_MISSED 116297",
	"RAID_BOSS_EMOTE"
)

local warnImpalingStrike	= mod:NewTargetAnnounce(107047, 3)
local warnPreyTime			= mod:NewTargetAnnounce(106933, 3, nil, "Healer")
local warnStrafingRun		= mod:NewSpellAnnounce("ej5660", 4)

local specWarnStafingRun	= mod:NewSpecialWarningSpell("ej5660", nil, nil, nil, 2)
local specWarnStafingRunAoe	= mod:NewSpecialWarningMove(116297)
local specWarnAcidBomb		= mod:NewSpecialWarningMove(115458)

local timerImpalingStrikeCD	= mod:NewNextTimer(30, 107047)
local timerPreyTime			= mod:NewTargetTimer(5, 106933, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerPreyTimeCD		= mod:NewNextTimer(14.5, 106933, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
--	timerImpalingStrikeCD:Start(-delay)--Bad pull, no pull timers.
--	timerPreyTimeCD:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 106933 then
		warnPreyTime:Show(args.destName)
		timerPreyTime:Start(args.destName)
		timerPreyTimeCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 106933 then
		timerPreyTime:Start(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 107047 then
		warnImpalingStrike:Show(args.destName)
		timerImpalingStrikeCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 115458 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnAcidBomb:Show()
	elseif spellId == 116297 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnStafingRunAoe:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:RAID_BOSS_EMOTE(msg)--Needs a better trigger if possible using transcriptor.
	if msg == L.StaffingRun or msg:find(L.StaffingRun) then
		warnStrafingRun:Show()
		specWarnStafingRun:Show()
		timerImpalingStrikeCD:Start(29)
		timerPreyTimeCD:Start(32.5)
	end
end

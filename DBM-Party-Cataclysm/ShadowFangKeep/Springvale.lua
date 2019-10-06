local mod	= DBM:NewMod(98, "DBM-Party-Cataclysm", 6, 64)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(4278)
mod:SetEncounterID(1071)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 93693 93852",
	"SPELL_CAST_START 93844",
	"SPELL_CAST_SUCCESS 93685 93687",
	"SPELL_DAMAGE 93691",
	"CHAT_MSG_MONSTER_YELL"
)

local warnDesecration		= mod:NewSpellAnnounce(93687, 3)
local warnMaleficStrike		= mod:NewSpellAnnounce(93685, 2, nil, false)
local warnShield			= mod:NewSpellAnnounce(93693, 4)
local warnWordShame			= mod:NewTargetAnnounce(93852, 3)

local specWarnDesecration	= mod:NewSpecialWarningMove(93691, nil, nil, nil, 1, 8)
local specWarnEmpowerment	= mod:NewSpecialWarningInterrupt(93844, "HasInterrupt", nil, nil, 1, 2)

local timerAdds				= mod:NewTimer(40, "TimerAdds", 48000, nil, nil, 1)
local timerMaleficStrike	= mod:NewNextTimer(6, 93685, nil, false, nil, 5, nil, DBM_CORE_TANK_ICON)

function mod:OnCombatStart(delay)
	timerAdds:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93693 then
		warnShield:Show()
	elseif args.spellId == 93852 then
		warnWordShame:Show(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93844 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnEmpowerment:Show(args.sourceName)
		specWarnEmpowerment:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 93685 then
		warnMaleficStrike:Show()
		timerMaleficStrike:Start()
	elseif args.spellId == 93687 then
		warnDesecration:Show()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 93691 and destGUID == UnitGUID("player") and self:AntiSpam(4) then
		specWarnDesecration:Show()
		specWarnDesecration:Play("watchfeet")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		timerAdds:Start()--unknown time for 2nd+ set, pugs don't take this long anymore. Assumed the same but don't know for sure.
	end
end
local mod	= DBM:NewMod(888, "DBM-Party-WoD", 2, 385)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(74787)
mod:SetEncounterID(1653)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 150751",
	"SPELL_CAST_START 150759 150801 153679 150753"
)

local warnCrushingLeap			= mod:NewTargetNoFilterAnnounce(150751, 3)

local specWarnFerociousYell		= mod:NewSpecialWarningInterrupt(150759, "HasInterrupt", nil, 2, 1, 2)
local specWarnRaiseMiners		= mod:NewSpecialWarningSwitch(150801, "Tank", nil, nil, 1, 2)
local specWarnEarthCrush		= mod:NewSpecialWarningSpell(153679, nil, nil, nil, 3, 2)--avoidable.
local specWarnWildSlam			= mod:NewSpecialWarningSpell(150753, nil, nil, nil, 2, 2)--not avoidable. large aoe damage and knockback

--local timerFerociousYellCD--12~18. large variable?
--local timerRaiseMinersCD--14~26. large variable. useless.
local timerCrushingLeapCD		= mod:NewCDTimer(23, 150751, nil, nil, nil, 3)--23~25 variable.
--local timerEarthCrushCD--13~21. large variable. useless.
local timerWildSlamCD			= mod:NewCDTimer(23, 150753, nil, nil, nil, 2)--23~24 variable.

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 150751 then
		warnCrushingLeap:Show(args.destName)
		timerCrushingLeapCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 150759 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFerociousYell:Show(args.sourceName)
		specWarnFerociousYell:Play("kickcast")
	elseif spellId == 150801 then
		specWarnRaiseMiners:Show()
		specWarnRaiseMiners:Play("mobsoon")
	elseif spellId == 153679 then
		specWarnEarthCrush:Show()
		specWarnEarthCrush:Play("watchstep")
	elseif spellId == 150753 then
		specWarnWildSlam:Show()
		specWarnWildSlam:Play("carefly")
		timerWildSlamCD:Start()
	end
end

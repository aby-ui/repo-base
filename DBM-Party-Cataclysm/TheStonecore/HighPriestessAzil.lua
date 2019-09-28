local mod	= DBM:NewMod(113, "DBM-Party-Cataclysm", 7, 67)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(42333)
mod:SetEncounterID(1057)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 79351 79345",
	"SPELL_CAST_START 82858 79351",
	"SPELL_CAST_SUCCESS 79340 79002 79021 86856 86858 86860"
)

local warnShield	= mod:NewSpellAnnounce(82858, 2)
local warnGrip		= mod:NewTargetNoFilterAnnounce(79351, 3)
local warnWell		= mod:NewSpellAnnounce(79340, 2)
local warnShard		= mod:NewSpellAnnounce(79002, 2)

local specWarnGrip	= mod:NewSpecialWarningInterrupt(79351, "HasInterrupt", nil, nil, 1, 2)
local specWarnCurse	= mod:NewSpecialWarningDispel(79345, "RemoveCurse", nil, 2, 1, 2)

local timerGrip		= mod:NewTargetTimer(5, 79351, nil, nil, nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 79351 and args:IsDestTypePlayer() then
		warnGrip:Show(args.destName)
		timerGrip:Start(args.destName)
	elseif args.spellId == 79345 and self:CheckDispelFilter() then
		specWarnCurse:Show(args.destName)
		specWarnCurse:Play("helpdispel")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 82858 then
		warnShield:Show()
	elseif args.spellId == 79351 and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
		specWarnGrip:Show(args.sourceName)
		specWarnGrip:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 79340 then
		warnWell:Show()
	elseif args:IsSpellID(79002, 79021, 86856, 86858, 86860) then -- not comfirmed
		warnShard:Show()
	end
end
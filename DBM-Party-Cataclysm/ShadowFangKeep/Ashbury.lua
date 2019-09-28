local mod	= DBM:NewMod(96, "DBM-Party-Cataclysm", 6, 64)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(46962)
mod:SetEncounterID(1069)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 93581",
	"SPELL_CAST_START 93757 93468",
	"SPELL_CAST_SUCCESS 93423 93720"
)

local warnPain				= mod:NewTargetAnnounce(93581, 3)
local warnWracking			= mod:NewSpellAnnounce(93720, 2)
local warnArchangel			= mod:NewSpellAnnounce(93757, 4)

local specWarnStayExec		= mod:NewSpecialWarningInterrupt(93468, "HasInterrupt", nil, nil, 1, 2)

local timerAsphyxiate		= mod:NewCDTimer(45, 93423, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	timerAsphyxiate:Start(18-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93581 then
		warnPain:Show(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93757 then
		warnArchangel:Show()
	elseif args.spellId == 93468 and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
		specWarnStayExec:Show(args.sourceName)
		specWarnStayExec:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 93423 then
		timerAsphyxiate:Start()
	elseif args.spellId == 93720 then
		warnWracking:Show()
	end
end
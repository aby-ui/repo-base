local mod	= DBM:NewMod(624, "DBM-Party-WotLK", 9, 282)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(27655)
mod:SetEncounterID(532, 533, 2014)

mod:RegisterCombat("yell", L.CombatStart)--Why using yell instead of "Combat". I do not remember.

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 51121 59376",
	"SPELL_CAST_START 51110 59377"
)

local warningTimeBomb		= mod:NewTargetNoFilterAnnounce(51121, 4)

local specWarnExplosion		= mod:NewSpecialWarningMoveTo(51110, nil, nil, nil, 3, 2)

local timerTimeBomb			= mod:NewTargetTimer(6, 51121, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerExplosion		= mod:NewCastTimer(8, 51110, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(51110, 59377) then
		specWarnExplosion:Show(DBM_CORE_BREAK_LOS)
		specWarnExplosion:Play("findshelter")
		timerExplosion:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(51121, 59376) then
		warningTimeBomb:Show(args.destName)
		timerTimeBomb:Start(args.destName)
	end
end

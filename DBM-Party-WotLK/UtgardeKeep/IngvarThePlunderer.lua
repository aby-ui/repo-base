local mod	= DBM:NewMod(640, "DBM-Party-WotLK", 10, 285)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(23980, 23954)
mod:SetEncounterID(575, 576, 2025)
mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 42723 42669 59706 59709 42708 42729 59708 59734",
	"SPELL_AURA_APPLIED 42730 59735",
	"SPELL_AURA_REMOVED 42730 59735"
)

local warningWoeStrike	= mod:NewTargetNoFilterAnnounce(42730, 2, nil, "RemoveCurse", 2)

local specWarnSpelllock	= mod:NewSpecialWarningCast(42729, "SpellCaster", nil, 2, 1, 2)
local specWarnSmash		= mod:NewSpecialWarningDodge(42723, "Tank", nil, nil, 1, 2)

local timerSmash		= mod:NewCastTimer(3, 42723)
local timerWoeStrike	= mod:NewTargetTimer(10, 42723, nil, "RemoveCurse", nil, 5, nil, DBM_CORE_CURSE_ICON)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(42723, 42669, 59706, 59709) then
		specWarnSmash:Show()
		specWarnSmash:Play("shockwave")
		timerSmash:Start()
	elseif args:IsSpellID(42708, 42729, 59708, 59734) then
		specWarnSpelllock:Show()
		specWarnSpelllock:Play("stopcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(42730, 59735) then
		warningWoeStrike:Show(args.destName)
		timerWoeStrike:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(42730, 59735) then
		timerWoeStrike:Cancel()
	end
end

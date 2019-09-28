local mod	= DBM:NewMod("Garr", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(50056)
mod:SetModelID(37307)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 93508",
	"SPELL_CAST_SUCCESS 93506"
)
mod.onlyNormal = true

local warnAntiMagicPulse		= mod:NewSpellAnnounce(93506, 2)--An attack that one shots anyone not in a twilight zone.

local specWarnMassiveEruption	= mod:NewSpecialWarningRun(93508, "Melee", nil, nil, 4, 2)

local timerMassiveEruptionCD	= mod:NewNextTimer(30, 93508, nil, nil, nil, 2)
local timerAntiMagicPulseCD		= mod:NewCDTimer(16, 93506, nil, nil, nil, 2)--Every 17-25 seconds. So only a CD bar usuable here.


function mod:OnCombatStart(delay)
	timerMassiveEruptionCD:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93508 then--Possibly use 93507 (Magma Shackles) EDIT: nope, they are resistable so they woudln't be reliable.
		specWarnMassiveEruption:Show()
		specWarnMassiveEruption:Play("justrun")
		timerMassiveEruptionCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 93506 then--Possibly use 93507 (Magma Shackles) instead if it's always cast before eruption, for an earlier warning?
		warnAntiMagicPulse:Show()
		timerAntiMagicPulseCD:Start()
	end
end

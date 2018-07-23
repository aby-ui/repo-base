local mod	= DBM:NewMod("Garr", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 145 $"):sub(12, -3))
mod:SetCreatureID(50056)
mod:SetModelID(37307)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)
mod.onlyNormal = true

local warnAntiMagicPulse		= mod:NewSpellAnnounce(93506, 2)--An attack that one shots anyone not in a twilight zone.
local warnMassiveEruption		= mod:NewSpellAnnounce(93508, 4)--An attack that one shots anyone not in a twilight zone.

local specWarnMassiveEruption	= mod:NewSpecialWarningRun(93508, "Melee", nil, nil, 4)

local timerMassiveEruptionCD	= mod:NewNextTimer(30, 93508)
local timerAntiMagicPulseCD		= mod:NewCDTimer(16, 93506)--Every 17-25 seconds. So only a CD bar usuable here.


function mod:OnCombatStart(delay)
	timerMassiveEruptionCD:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93508 then--Possibly use 93507 (Magma Shackles) EDIT: nope, they are resistable so they woudln't be reliable.
		warnMassiveEruption:Show()
		specWarnMassiveEruption:Show()
		timerMassiveEruptionCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 93506 then--Possibly use 93507 (Magma Shackles) instead if it's always cast before eruption, for an earlier warning?
		warnAntiMagicPulse:Show()
		timerAntiMagicPulseCD:Start()
	end
end

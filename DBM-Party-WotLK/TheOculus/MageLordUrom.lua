local mod	= DBM:NewMod(624, "DBM-Party-WotLK", 9, 282)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(27655)
mod:SetEncounterID(532, 533, 2014)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("yell", L.CombatStart)--Why using yell instead of "Combat". I do not remember.

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START"
)

local warningTimeBomb		= mod:NewTargetAnnounce(51121, 2)
local warningExplosion		= mod:NewCastAnnounce(51110, 3)

local specWarnBombYou		= mod:NewSpecialWarningYou(51121)

local timerTimeBomb			= mod:NewTargetTimer(6, 51121)
local timerExplosion		= mod:NewTargetTimer(8, 51110)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(51110, 59377) then
		warningExplosion:Show()
		timerExplosion:Start(args.destName)
		if args:IsPlayer() then
			specWarnBombYou:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(51121, 59376) then
		warningTimeBomb:Show(args.destName)
		timerTimeBomb:Start(args.destName)
	end
end

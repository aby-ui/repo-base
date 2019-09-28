local mod	= DBM:NewMod(638, "DBM-Party-WotLK", 10, 285)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(23953)
mod:SetEncounterID(571, 572, 2026)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warningTomb	= mod:NewTargetAnnounce(48400, 4)
local timerTomb		= mod:NewTargetTimer(10, 48400)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 48400 then
		warningTomb:Show(args.destName)
		timerTomb:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 48400 then
		timerTomb:Cancel()
	end
end
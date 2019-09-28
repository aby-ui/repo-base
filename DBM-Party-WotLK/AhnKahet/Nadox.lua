local mod	= DBM:NewMod(580, "DBM-Party-WotLK", 1, 271)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29309)
mod:SetEncounterID(212, 259, 1969)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 56130 59467",
	"SPELL_AURA_REMOVED 56130 59467"
)

local warningPlague	= mod:NewTargetAnnounce(56130, 2, nil, "Healer")

local timerPlague	= mod:NewTargetTimer(30, 56130, nil, "Healer", nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(56130, 59467) then
		warningPlague:Show(args.destName)
		timerPlague:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(56130, 59467) then
		timerPlague:Stop()
	end
end
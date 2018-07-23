local mod	= DBM:NewMod(581, "DBM-Party-WotLK", 1, 271)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(29308)
mod:SetEncounterID(213, 260, 1966)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 55931",
	"SPELL_AURA_APPLIED 55959 59513",
	"SPELL_AURA_REMOVED 55959 59513"
)

local warningEmbrace	= mod:NewTargetAnnounce(55959, 2)
local warningFlame		= mod:NewSpellAnnounce(55931, 3)

local timerEmbrace		= mod:NewTargetTimer(20, 55959)
local timerFlameCD		= mod:NewCDTimer(15, 55959)


function mod:SPELL_CAST_START(args)
	if args.spellId == 55931 then
		warningFlame:Show()
		timerFlameCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(55959, 59513) then
		warningEmbrace:Show(args.destName)
		timerEmbrace:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(55959, 59513) then
		timerEmbrace:Cancel()
	end
end
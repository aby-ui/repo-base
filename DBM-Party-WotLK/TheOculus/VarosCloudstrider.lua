local mod	= DBM:NewMod(623, "DBM-Party-WotLK", 9, 282)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(27447)
mod:SetEncounterID(530, 531, 2015)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warningAmplify	= mod:NewTargetAnnounce(51054, 2)
local timerAmplify		= mod:NewTargetTimer(30, 51054)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(51054, 59371) then
		warningAmplify:Show(args.destName)
		timerAmplify:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(51054, 59371) then
		timerAmplify:Cancel()
	end
end
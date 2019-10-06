local mod	= DBM:NewMod(585, "DBM-Party-WotLK", 2, 272)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(28684)
mod:SetEncounterID(216, 264, 1971)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 52592 59368"
)

local warningCurse	= mod:NewSpellAnnounce(52592, 2)
local timerCurseCD	= mod:NewCDTimer(20, 52592, nil, nil, nil, 2)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(52592, 59368) then
		warningCurse:Show()
		timerCurseCD:Start()
	end
end
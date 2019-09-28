local mod	= DBM:NewMod(598, "DBM-Party-WotLK", 6, 275)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(28587)
mod:SetEncounterID(557, 558, 1985)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 59529 52237"
)

local warningStomp	= mod:NewSpellAnnounce(52237, 3)

local timerStompCD	= mod:NewCDTimer(30, 52237, nil, nil, nil, 2)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(59529, 52237) then
		warningStomp:Show()
		timerStompCD:Start()
	end
end
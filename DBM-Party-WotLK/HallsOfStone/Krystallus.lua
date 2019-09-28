local mod	= DBM:NewMod(604, "DBM-Party-WotLK", 7, 277)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(27977)
mod:SetEncounterID(563, 564, 1994)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 50833"
)

local warningShatter	= mod:NewSpellAnnounce(50810, 3)

local timerShatterCD	= mod:NewCDTimer(25, 50810, nil, nil, nil, 2)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 50833 then
		warningShatter:Show()	-- Shatter warning when Ground Slam is cast
		timerShatterCD:Start()
	end
end
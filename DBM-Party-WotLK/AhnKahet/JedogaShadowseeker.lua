local mod	= DBM:NewMod(582, "DBM-Party-WotLK", 1, 271)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29310)
mod:SetEncounterID(214, 261, 1967)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 56926 60029",
	"SPELL_CAST_START 56855 60030"
)

--TODO, GTFO for thundershock shit on ground
--TODO, switch warning for add
local warningThundershock	= mod:NewSpellAnnounce(56926, 3)
local warningCycloneStrike	= mod:NewSpellAnnounce(56855, 3)

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(56926, 60029) then
		warningThundershock:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(56855, 60030) then
		warningCycloneStrike:Show()
	end
end
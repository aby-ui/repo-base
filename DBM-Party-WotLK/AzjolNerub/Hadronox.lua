local mod	= DBM:NewMod(586, "DBM-Party-WotLK", 2, 272)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(28921)
mod:SetEncounterID(217, 265, 1972)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 53030 59417 53400 59419"
)

local warningCloud	= mod:NewSpellAnnounce(53400, 3)
local warningLeech	= mod:NewSpellAnnounce(53030, 1)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(53030, 59417) then
		warningLeech:Show()
	elseif args:IsSpellID(53400, 59419) then
		warningCloud:Show()
	end
end
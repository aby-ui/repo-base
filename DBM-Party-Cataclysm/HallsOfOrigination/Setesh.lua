local mod	= DBM:NewMod(129, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39732)
mod:SetEncounterID(1079)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)

-- nothing added yet, he only casts Chaos Bolt in combatlog
-- he spawns adds, they might do something .. will check their names next time :)
-- Setesh seeks a portal every 25 seconds, up from 20. (from 4.0.6 patch notes,needs to be implimented somehow).
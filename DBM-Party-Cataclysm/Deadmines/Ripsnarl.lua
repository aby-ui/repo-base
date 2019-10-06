local mod	= DBM:NewMod(92, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(47626)
mod:SetEncounterID(1062)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)
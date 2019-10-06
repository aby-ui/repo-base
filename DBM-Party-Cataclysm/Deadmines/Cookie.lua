local mod	= DBM:NewMod(93, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(47739)
mod:SetEncounterID(1060)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)
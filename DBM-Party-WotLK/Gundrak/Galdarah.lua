local mod	= DBM:NewMod(596, "DBM-Party-WotLK", 5, 274)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29306)
mod:SetEncounterID(390, 391, 1981)
mod:SetModelID(27061)
--mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)

local mod	= DBM:NewMod(630, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetCreatureID(29312)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)

<<<<<<< HEAD
local mod	= DBM:NewMod(629, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision((string.sub("20190414033732", 1, -5)):sub(12, -3))
mod:SetCreatureID(29266)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)
=======
local mod	= DBM:NewMod(629, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision((string.sub("20190414033732", 1, -5)):sub(12, -3))
mod:SetCreatureID(29266)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
)
>>>>>>> 0c4c352d04b9b16e45411ea8888c232424c574e4

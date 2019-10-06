local mod	= DBM:NewMod(125, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39428, 99999)--Combat log shows him as dying when he borrows, wtf?
--mod:SetEncounterID(1076)--In case this has same bug as unit died with borrow
mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 77370"
)

local warnFlameBolt		= mod:NewSpellAnnounce(77370, 2)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 77370 then
		warnFlameBolt:Show()
	end
end
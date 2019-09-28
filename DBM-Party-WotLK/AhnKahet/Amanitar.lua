local mod	= DBM:NewMod(583, "DBM-Party-WotLK", 1, 271)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(30258)
mod:SetEncounterID(262, 1989)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 57055"
)
mod.onlyHeroic = true

local warningMini	= mod:NewSpellAnnounce(57055, 3)

local timerMiniCD	= mod:NewCDTimer(30, 57055, nil, nil, nil, 2)

function mod:SPELL_CAST_START(args)
	if args.spellId == 57055 then
		warningMini:Show()
		timerMiniCD:Start()
	end
end
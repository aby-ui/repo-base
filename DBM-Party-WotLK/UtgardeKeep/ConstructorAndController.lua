local mod	= DBM:NewMod(639, "DBM-Party-WotLK", 10, 285)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(24200, 24201)
mod:SetEncounterID(573, 574, 2024)
mod:SetModelID(26349)
mod:SetZone()

mod:RegisterCombat("combat")
--mod:RegisterKill("kill")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 43650",
	"SPELL_SUMMON 52611"
)

local warningEnfeeble	= mod:NewTargetNoFilterAnnounce(43650, 2)
local warningSummon		= mod:NewSpellAnnounce(52611, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43650 then
		warningEnfeeble:Show(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 52611 and self:AntiSpam() then
		warningSummon:Show()
	end
end
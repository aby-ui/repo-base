local mod	= DBM:NewMod(597, "DBM-Party-WotLK", 6, 275)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(28586)
mod:SetEncounterID(555, 556, 1987)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 52027 52028"
)

local warningWhirlwind		= mod:NewSpellAnnounce(52027, 3)

local specWarnWhirlwind		= mod:NewSpecialWarningRun(52027, "Melee", nil, nil, 4, 2)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(52027, 52028) then
		if self.Options.SpecWarn52024run then
			specWarnWhirlwind:Show()
			specWarnWhirlwind:Play("runout")
		else
			warningWhirlwind:Show()
		end
	end
end
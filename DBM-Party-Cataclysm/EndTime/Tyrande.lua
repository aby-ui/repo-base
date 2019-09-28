local mod	= DBM:NewMod(283, "DBM-Party-Cataclysm", 12, 184)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54544)
mod:SetEncounterID(1884)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 102472",
	"SPELL_AURA_APPLIED_DOSE 102472",
	"SPELL_CAST_START 102472 102173"
)
mod.onlyHeroic = true

local warnGuidance		= mod:NewSpellAnnounce(102472, 3)
local warnGuidanceStack	= mod:NewCountAnnounce(102472, 2, nil, false)

local specwarnStardust	= mod:NewSpecialWarningInterrupt(102173, "HasInterrupt", nil, nil, 1, 2)

local timerGuidance		= mod:NewNextTimer(20, 102472)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 102472 then
		warnGuidanceStack:Show(args.amount or 1)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args.spellId == 102472 then
		warnGuidance:Show()
		timerGuidance:Start()
	elseif args.spellId == 102173 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specwarnStardust:Show(args.sourceName)
		specwarnStardust:Play("kickcast")
	end
end
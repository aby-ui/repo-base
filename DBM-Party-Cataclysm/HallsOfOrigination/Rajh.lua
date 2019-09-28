local mod	= DBM:NewMod(130, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39378)
mod:SetEncounterID(1078)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 76355",
	"SPELL_CAST_START 87653",
	"SPELL_CAST_SUCCESS 73872 80352"
)

local warnBlessing		= mod:NewSpellAnnounce(76355, 3)
local warnLeap			= mod:NewSpellAnnounce(87653, 2)
local warnSunStrike		= mod:NewSpellAnnounce(73872, 3)

local specWarnSunOrb	= mod:NewSpecialWarningInterrupt(80352, "HasInterrupt", nil, nil, 1, 2)

local timerBlessing		= mod:NewBuffActiveTimer(23, 76355, nil, nil, nil, 5)
local timerSunStrike	= mod:NewCDTimer(27, 73872, nil, nil, nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 76355 and self:AntiSpam(5) then
		warnBlessing:Show()
		timerBlessing:Start()
		timerSunStrike:Start(50)	-- or hack it into SPELL_AURA_REMOVED
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 87653 then
		warnLeap:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 80352 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSunOrb:Show(args.sourceName)
		specWarnSunOrb:Play("kickcast")
	elseif args.spellId == 73872 then
		warnSunStrike:Show()
		timerSunStrike:Start()
	end
end
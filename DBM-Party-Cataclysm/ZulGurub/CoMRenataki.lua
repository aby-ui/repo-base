local mod	= DBM:NewMod(179, "DBM-Party-Cataclysm", 11, 76, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(52269)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 96646",
	"SPELL_AURA_APPLIED 96639"
)
mod.onlyHeroic = true

local warnVanish			= mod:NewSpellAnnounce(96639, 3)

local specWarnBlades		= mod:NewSpecialWarningRun(96646, nil, nil, 2, 4, 2)

local timerBlades			= mod:NewBuffActiveTimer(11, 96646, nil, nil, nil, 2)--3sec cast + 8 sec duration
local timerBladesCD			= mod:NewCDTimer(45, 96646, nil, nil, nil, 2)--Speculated, since log only cast it twice.
local timerVanishCD			= mod:NewCDTimer(46.5, 96639, nil, nil, nil, 6)--Speculated, since log only cast it twice.
local timerAmbush			= mod:NewNextTimer(2.5, 96640, nil, nil, nil, 3)--2.5 seconds after vanish.

function mod:OnCombatStart(delay)
	timerVanishCD:Start(15-delay)--Consistent?
	timerBladesCD:Start(34-delay)--^^
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96646 then
        specWarnBlades:Show()
        specWarnBlades:Play("justrun")
		timerBlades:Start()
		timerBladesCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96639 then
		warnVanish:Show()
		timerVanishCD:Start()
		timerAmbush:Start()
	end
end
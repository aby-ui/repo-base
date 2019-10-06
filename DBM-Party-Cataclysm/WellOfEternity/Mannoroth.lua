local mod	= DBM:NewMod(292, "DBM-Party-Cataclysm", 13, 185)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54969)
mod:SetEncounterID(1274)--Definitely Review
mod:SetReCombatTime(60)
mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("say", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 105041",
	"SPELL_CAST_START 103888"
)
mod.onlyHeroic = true

local specWarnFelStorm		= mod:NewSpecialWarningRun(103888, nil, nil, nil, 4, 2)

local timerFelStorm			= mod:NewBuffActiveTimer(15, 103888, nil, nil, nil, 2)
local timerFelStormCD		= mod:NewCDTimer(29, 103888, nil, nil, nil, 2)
local timerTyrandeHelp		= mod:NewTimer(82, "TimerTyrandeHelp", 102472, nil, nil, 6)

mod.vb.felstorms = 0

function mod:OnCombatStart(delay)
	timerFelStormCD:Start(15-delay)
	timerTyrandeHelp:Start(-delay)
	self.vb.felstorms = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 105041 then
		timerFelStormCD:Start()		-- ~30sec after Nether Tear ?
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 103888 then
		self.vb.felstorms = self.vb.felstorms + 1
		timerFelStormCD:Cancel()
		specWarnFelStorm:Show()
		specWarnFelStorm:Play("justrun")
		timerFelStorm:Start()
		if self.vb.felstorms < 2 then
			timerFelStormCD:Start()
		end
	end
end


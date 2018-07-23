local mod	= DBM:NewMod("d589", "DBM-Scenario-MoP")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 114 $"):sub(12, -3))
mod:SetZone()

mod:RegisterCombat("scenario", 1104)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)
mod.onlyNormal = true

--Todo, Add some more resource gathering warnings/timers? Unfortunately none of those events got recorded by transcriptor. it appears they are all UNIT_AURA only :\
--Commander Scargash
local warnBloodRage			= mod:NewTargetAnnounce(134974, 3)--15 second target fixate

--Commander Scargash
local specWarnBloodrage		= mod:NewSpecialWarningRun(134974, nil, nil, nil, 4)

--Commander Scargash
local timerBloodRage		= mod:NewTargetTimer(15, 134974)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 134974 then
		warnBloodRage:Show(args.destName)
		timerBloodRage:Start(args.destName)
		if args:IsPlayer() then
			specWarnBloodrage:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 134974 then
		timerBloodRage:Cancel(args.destname)
	end
end

local mod	= DBM:NewMod(291, "DBM-Party-Cataclysm", 13, 185)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54853)
mod:SetEncounterID(1273)
mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 103241",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)
mod.onlyHeroic = true

local warnAdds			= mod:NewAnnounce("WarnAdds", 3)

local specWarnServant	= mod:NewSpecialWarningSpell(102334, nil, nil, nil, 2)
local specWarnObedience	= mod:NewSpecialWarningInterrupt(103241, nil, nil, nil, 1, 2)

local timerServantCD	= mod:NewCDTimer(26, 102334, nil, nil, nil, 3)--Still don't have good logs, and encounter bugs a lot so i can't get any reliable timers except for first casts on engage.
local timerObedienceCD	= mod:NewCDTimer(37, 103241, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerAdds			= mod:NewTimer(36, "TimerAdds", nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)

mod.vb.addsCount = 0

function mod:Adds()
	self.vb.addsCount = self.vb.addsCount + 1
	if self.vb.addsCount == 3 then return end
	timerAdds:Start()
	warnAdds:Schedule(31)
	self:ScheduleMethod(36, "Adds")
end

function mod:OnCombatStart(delay)
	timerServantCD:Start(24-delay)
	timerObedienceCD:Start(36-delay)
	timerAdds:Start(17-delay)
	warnAdds:Schedule(14-delay)
	self:ScheduleMethod(17, "Adds")
	self.vb.addsCount = 0
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 103241 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnObedience:Show(args.sourceName)
		specWarnObedience:Play("kickcast")
--		timerObedienceCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 102334 then
		specWarnServant:Show()
		specWarnServant:Play("findmc")
--		timerServantCD:Start()
	end
end
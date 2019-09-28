local mod	= DBM:NewMod(594, "DBM-Party-WotLK", 5, 274)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29305)
mod:SetEncounterID(387, 388, 1980)
--mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 55098",
	"UNIT_HEALTH boss1"
)

local specWarnTransform		= mod:NewSpecialWarningInterruptCount(55098, nil, nil, nil, 1, 2)

local timerTransform		= mod:NewCDTimer(10, 55098, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)--experimental

mod.vb.lowHealth = false
mod.vb.kickCount = 0

function mod:OnCombatStart()
	self.vb.lowHealth = false
	self.vb.kickCount = 0
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 55098 then
		self.vb.kickCount = self.vb.kickCount + 1
		specWarnTransform:Show(args.sourceName, self.vb.kickCount)
		specWarnTransform:Play("kickcast")
		if self.vb.lowHealth then
			timerTransform:Start(5) --cast every 5 seconds below 50% health
		else
			timerTransform:Start() --cast every 10 seconds above 50% health
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 29305 then
		if not self.vb.lowHealth and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 then
			self.vb.lowHealth = true
			local remaining = timerTransform:GetRemaining()
			timerTransform:Cancel()
			if remaining > 5 then--Update
				timerTransform:Start(remaining-5)
			end
		end
	end
end

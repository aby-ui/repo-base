local mod	= DBM:NewMod("Splinterbark", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20221023055051")
mod:SetCreatureID(172682)--Guessed
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(7, 5)
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
--	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED 337419",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED",
	"CRITERIA_COMPLETE"
)

local specWarnRage				= mod:NewSpecialWarningRun(337419, nil, nil, nil, 4, 2)

--local berserkTimer								= mod:NewBerserkTimer(480)

--function mod:OnCombatStart(delay)
--	berserkTimer:Start(100-delay)
--end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 337419 then
		specWarnRage:Show()
		specWarnRage:Play("justrun")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 333198 then--[DNT] Set World State: Win Encounter-
		DBM:EndCombat(self)
	end
end

do
	local function checkForWipe(self)
		if UnitInVehicle("player") then--success
			DBM:EndCombat(self)
		else--fail
			DBM:EndCombat(self, true)
		end
	end

	function mod:CRITERIA_COMPLETE(criteriaID)
		if criteriaID == 48408 then
			self:Unschedule(checkForWipe)
			self:Schedule(3, checkForWipe, self)
		end
	end
end

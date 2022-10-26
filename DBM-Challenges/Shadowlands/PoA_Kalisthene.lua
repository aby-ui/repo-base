local mod	= DBM:NewMod("Kalisthene", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20221023053638")
mod:SetCreatureID(170654)--Guessed
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(7, 5)
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 332985 333244",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED",
	"CRITERIA_COMPLETE"
)
local warnTetheringSpear					= mod:NewSpellAnnounce(332985, 4)

local specWarnAscendantBarrage				= mod:NewSpecialWarningDodge(333244, nil, nil, nil, 2, 2)

local timerAscendantBarrageCD				= mod:NewAITimer(23.1, 333244, nil, nil, nil, 3)
--local berserkTimer								= mod:NewBerserkTimer(480)

function mod:OnCombatStart(delay)
	timerAscendantBarrageCD:Start(1-delay)
--	berserkTimer:Start(100-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 332985 then
		warnTetheringSpear:Show()
	elseif spellId == 333244 then
		specWarnAscendantBarrage:Show()
		specWarnAscendantBarrage:Play("watchstep")
		timerAscendantBarrageCD:Start()
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


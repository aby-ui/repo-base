local mod	= DBM:NewMod("AlderynandMynir", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20221023053638")
mod:SetCreatureID(172408, 172409)
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(7, 5)
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 337175 337013",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"CRITERIA_COMPLETE"
)

local specWarnAnimaSeed				= mod:NewSpecialWarningSoak(337175, nil, nil, nil, 1, 2)
local specWarnAnimaDervish			= mod:NewSpecialWarningDodge(337013, nil, nil, nil, 2, 2)

local timerAnimaSeedCD				= mod:NewCDTimer(25.1, 337175, nil, nil, nil, 5)
local timerAnimaDervishCD			= mod:NewCDTimer(11.7, 337013, nil, nil, nil, 3)
local berserkTimer					= mod:NewBerserkTimer(480)

function mod:OnCombatStart(delay)
	timerAnimaDervishCD:Start(5.5-delay)
	timerAnimaSeedCD:Start(9.9-delay)
	if self:IsHard() then
		berserkTimer:Start(100-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 337175 then
		specWarnAnimaSeed:Show()
		specWarnAnimaSeed:Play("helpsoak")
		timerAnimaSeedCD:Start()
	elseif spellId == 337013 then
		specWarnAnimaDervish:Show()
		specWarnAnimaDervish:Play("watchstep")
		timerAnimaDervishCD:Start()
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


local mod	= DBM:NewMod("Athanos", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20221023164141")
mod:SetCreatureID(171873)--Guessed
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(7, 5)
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 335497 335748 335697 335599",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED",
	"CRITERIA_COMPLETE"
)

local warnShieldingCharging			= mod:NewSpellAnnounce(335697, 2)

local specWarnPowerSwing			= mod:NewSpecialWarningSpell(335497, nil, nil, nil, 1, 2)
local specWarnMassiveCharge			= mod:NewSpecialWarningDodge(335748, nil, nil, nil, 1, 2)
local specWarnQuakingShockwave		= mod:NewSpecialWarningDodge(335599, nil, nil, nil, 2, 2)

local timerPowerSwingCD				= mod:NewCDTimer(12.1, 335497, nil, nil, nil, 3)--12.1-15.7
--local timerMassiveChargeCD		= mod:NewCDTimer(30, 335748, nil, nil, nil, 3)

--local berserkTimer								= mod:NewBerserkTimer(480)

--function mod:OnCombatStart(delay)
--	berserkTimer:Start(100-delay)
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 335497 then
		specWarnPowerSwing:Show()
		specWarnPowerSwing:Play("carefly")
		timerPowerSwingCD:Start()
	elseif spellId == 335748 then
		specWarnMassiveCharge:Show()
		specWarnMassiveCharge:Play("chargemove")
--		timerMassiveChargeCD:Start()
	elseif spellId == 335697 then
		warnShieldingCharging:Show()
	elseif spellId == 335599 then
		specWarnQuakingShockwave:Show()
		specWarnQuakingShockwave:Play("watchstep")
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

local mod	= DBM:NewMod("Azaruux", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20221023164000")
mod:SetCreatureID(172333)--Guessed
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(7, 5)
mod:SetWipeTime(30)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 336833 336782",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED",
	"CRITERIA_COMPLETE"
)

local warnDevouringRift			= mod:NewSpellAnnounce(336833, 2)
local warnInfestation			= mod:NewSpellAnnounce(336782, 2)

--local berserkTimer								= mod:NewBerserkTimer(480)

--function mod:OnCombatStart(delay)
--	timerPowerSwingCD:Start(15.6-delay)
--	timerMassiveChargeCD:Start(33-delay)
--	berserkTimer:Start(100-delay)
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 336833 then
		warnDevouringRift:Show()
	elseif spellId == 336782 then
		warnInfestation:Show()
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

local mod	= DBM:NewMod(2144, "DBM-Party-BfA", 6, 1001)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217031102")
mod:SetCreatureID(133389)
mod:SetEncounterID(2126)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 266511 266923",
	"SPELL_AURA_APPLIED_DOSE 266511 266923",
	"SPELL_CAST_START 266512"
)

--TODO, fine tune stacks?
--TODO, chaotic Spark fixate?
local warnCapacitance				= mod:NewCountAnnounce(266511, 2)

local specWarnConsumeCharge			= mod:NewSpecialWarningSpell(266512, nil, nil, nil, 2, 2)
local specWarnGalvanize				= mod:NewSpecialWarningStack(266923, nil, 5, nil, nil, 1, 6)

--local timerReapSoulCD				= mod:NewNextTimer(13, 194956, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.DEADLY_ICON)

mod:AddInfoFrameOption(266923, true)

function mod:OnCombatStart()
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM_CORE_L.INFOFRAME_POWER)
		DBM.InfoFrame:Show(2, "enemypower", 2, 10)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 266511 then
		warnCapacitance:Show(args.amount or 1)
	elseif spellId == 266923 and args:IsPlayer() then
		local amount = args.amount or 1
		if (amount >= 5) and self:AntiSpam(3, 1) then
			specWarnGalvanize:Show(amount)
			specWarnGalvanize:Play("stackhigh")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 266512 then
		specWarnConsumeCharge:Show()
		specWarnConsumeCharge:Play("aesoon")
	end
end

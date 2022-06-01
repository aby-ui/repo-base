local mod	= DBM:NewMod("CravenCorinth", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20220530062110")
mod:SetCreatureID(172412)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 341868 341869 341870",
	"SPELL_AURA_APPLIED 337924",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"UNIT_DIED"
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnFansCasts					= mod:NewCountAnnounce(341868, 2)

local specWarnFansofDesolation		= mod:NewSpecialWarningDodge(341868, nil, nil, nil, 2, 2)
local specWarnConsume				= mod:NewSpecialWarningSwitch(337924, nil, nil, nil, 1, 2)

local timerFansofDesolationCD		= mod:NewCDTimer(55.8, 341868, nil, nil, nil, 3)
local timerConsumeCD				= mod:NewCDTimer(55.8, 337924, nil, nil, nil, 1)

local berserkTimer					= mod:NewBerserkTimer(480)

local fansCount = 0--no need for sycnable variables, it's solo scenario

function mod:OnCombatStart(delay)
	timerFansofDesolationCD:Start(11.1-delay)
	timerConsumeCD:Start(32.9-delay)
	if self:IsHard() then
		berserkTimer:Start(80-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 341868 then
		fansCount = 1
		specWarnFansofDesolation:Show(fansCount)
		specWarnFansofDesolation:Play("watchstep")
		timerFansofDesolationCD:Start()
	elseif args:IsSpellID(341869, 341870) then
		fansCount = fansCount + 1
		warnFansCasts:Show(fansCount)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 337924 then
		specWarnConsume:Show()
		specWarnConsume:Play("targetchange")
		timerConsumeCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 333198 then--[DNT] Set World State: Win Encounter-
		DBM:EndCombat(self)
	end
end

local mod	= DBM:NewMod("Zarithrian", "DBM-ChamberOfAspects", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(39746)
mod:SetEncounterID(1148)
mod:SetModelID(32179)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 74384",
	"SPELL_AURA_APPLIED 74367",
	"SPELL_AURA_APPLIED_DOSE 74367",
	"CHAT_MSG_MONSTER_YELL"
)

local warningAdds				= mod:NewAnnounce("WarnAdds", 3, 74398)
local warnCleaveArmor			= mod:NewStackAnnounce(74367, 2, nil, "Tank|Healer")

local specWarnFear				= mod:NewSpecialWarningSpell(244016, nil, nil, nil, 2, 2)
local specWarnCleaveArmor		= mod:NewSpecialWarningStack(74367, nil, 2, nil, nil, 1, 6)--ability lasts 30 seconds, has a 15 second cd, so tanks should trade at 2 stacks.

local timerAddsCD				= mod:NewTimer(45.5, "TimerAdds", 74398, nil, nil, 1)
local timerCleaveArmor			= mod:NewTargetTimer(30, 74367, nil, "Tank|Healer", nil, 5)
local timerFearCD				= mod:NewCDTimer(33, 74384, nil, nil, nil, 2)--anywhere from 33-40 seconds in between fears.

function mod:OnCombatStart(delay)
	timerFearCD:Start(14-delay)--need more pulls to verify consistency
	timerAddsCD:Start(15.5-delay)--need more pulls to verify consistency
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 74384 then
		specWarnFear:Show()
		specWarnFear:Play("fearsoon")
		timerFearCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 74367 then
		local amount = args.amount or 1
		timerCleaveArmor:Start(args.destName)
		if args:IsPlayer() and amount >= 2 then
			specWarnCleaveArmor:Show(amount)
			specWarnCleaveArmor:Play("stackhigh")
		else
			warnCleaveArmor:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SummonMinions or msg:match(L.SummonMinions) then
		warningAdds:Show()
		timerAddsCD:Start()
	end
end

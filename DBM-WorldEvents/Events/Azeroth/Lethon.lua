local mod	= DBM:NewMod("Lethon", "DBM-WorldEvents", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(121821)--121821 TW ID, 14888 classic ID
--mod:SetModelID(17887)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 243401 243468",
	"SPELL_CAST_SUCCESS 243399",
	"SPELL_AURA_APPLIED 243401",
	"SPELL_AURA_APPLIED_DOSE 243401"
)

--TODO, maybe taunt special warnings for classic version when it matters more.
local warnNoxiousBreath			= mod:NewStackAnnounce(243401, 2, nil, "Tank")

local specWarnSleepingFog		= mod:NewSpecialWarningDodge(243399, nil, nil, nil, 2, 2)
local specWarnShadowBoltWhirl	= mod:NewSpecialWarningDodge(243468, nil, nil, nil, 2, 2)

local timerNoxiousBreathCD		= mod:NewCDTimer(18.3, 243401, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Iffy
local timerSleepingFogCD		= mod:NewCDTimer(16.8, 243399, nil, nil, nil, 3)
--local timerShadowBoltWhirlCD	= mod:NewCDTimer(15.8, 243468, nil, nil, nil, 3)

--mod:AddReadyCheckOption(48620, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		--timerNoxiousBreathCD:Start(11.9-delay)
		--timerSleepingFogCD:Start(18.4-delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 243401 then
		timerNoxiousBreathCD:Start()
	elseif args.spellId == 243468 and self:AntiSpam(5, 1) then
		specWarnShadowBoltWhirl:Show()
		specWarnShadowBoltWhirl:Play("watchorb")
		--timerShadowBoltWhirlCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 243399 then
		specWarnSleepingFog:Show()
		specWarnSleepingFog:Play("watchstep")
		timerSleepingFogCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 243401 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			warnNoxiousBreath:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

local mod	= DBM:NewMod("Ysondre", "DBM-WorldEvents", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(121912)--121912 TW ID, 14887 classic ID
--mod:SetModelID(17887)

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 243401",
	"SPELL_CAST_SUCCESS 243399",
	"SPELL_AURA_APPLIED 243401",
	"SPELL_AURA_APPLIED_DOSE 243401",
	"UNIT_SPELLCAST_SUCCEEDED"
)

--TODO, maybe taunt special warnings for classic version when it matters more.
local warnNoxiousBreath			= mod:NewStackAnnounce(243401, 2, nil, "Tank")
local warningLightningWave		= mod:NewSpellAnnounce(243610, 3)

local specWarnSleepingFog		= mod:NewSpecialWarningDodge(243399, nil, nil, nil, 2, 2)

local timerNoxiousBreathCD		= mod:NewCDTimer(19.4, 243401, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Iffy
local timerSleepingFogCD		= mod:NewCDTimer(14.7, 243399, nil, nil, nil, 3)
local timerLightningWaveCD		= mod:NewCDTimer(12.3, 243610, nil, nil, nil, 3)

--mod:AddReadyCheckOption(48620, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		timerLightningWaveCD:Start(5.9-delay)--Iffy
		timerNoxiousBreathCD:Start(11.9-delay)
		timerSleepingFogCD:Start(18.4-delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 243401 and self:AntiSpam(3, 1) then
		timerNoxiousBreathCD:Start()
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

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 243672 and self:AntiSpam(5, 2) then--Lightning Wave
		warningLightningWave:Show()
		timerLightningWaveCD:Start()
	end
end

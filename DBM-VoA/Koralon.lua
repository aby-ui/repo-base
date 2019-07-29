local mod	= DBM:NewMod("Koralon", "DBM-VoA")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(35013)
mod:SetEncounterID(1128)
mod:SetModelID(29524)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 66665 66725",
	"SPELL_AURA_APPLIED 66684 66721",
	"SPELL_AURA_APPLIED_DOSE 66721"
)

local warnBreath			= mod:NewSpellAnnounce(66665, 3)
local warnMeteor			= mod:NewSpellAnnounce(66725, 3)
local warnMeteorSoon		= mod:NewPreWarnAnnounce(66725, 5, 2)
local WarnBurningFury		= mod:NewAnnounce("BurningFury", 2, 66721)

local specWarnCinder		= mod:NewSpecialWarningMove(66684, nil, nil, nil, 1, 2)

local timerNextMeteor		= mod:NewNextTimer(47, 66725, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)
local timerNextBurningFury	= mod:NewNextTimer(20, 66721, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON..DBM_CORE_HEALER_ICON)
local timerBreath			= mod:NewBuffActiveTimer(4.5, 66665, nil, nil, nil, 2)
local timerBreathCD			= mod:NewCDTimer(45, 66665, nil, nil, nil, 2)--Seems to variate, but 45sec cooldown looks like a good testing number to start.

local timerKoralonEnrage	= mod:NewTimer(300, "KoralonEnrage", 26662)

function mod:OnCombatStart(delay)
	timerKoralonEnrage:Start(-delay)
	timerNextMeteor:Start(-delay)
	timerBreathCD:Start(12-delay)
	warnMeteorSoon:Schedule(42-delay)
	timerNextBurningFury:Start()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 66665 then
		warnBreath:Show()
		timerBreath:Start()
		timerBreathCD:Start()
	elseif args.spellId == 66725 then
		warnMeteor:Show()
		timerNextMeteor:Start()
		warnMeteorSoon:Schedule(42)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsPlayer() and args.spellId == 66684 then
		specWarnCinder:Show()
		specWarnCinder:Play("runaway")
	elseif args.spellId == 66721 then
		WarnBurningFury:Show(args.amount or 1)
		timerNextBurningFury:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

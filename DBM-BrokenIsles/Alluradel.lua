local mod	= DBM:NewMod(2011, "DBM-BrokenIsles", 2, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(124625)
mod:SetEncounterID(2083)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 247549 247604",
	"SPELL_CAST_SUCCESS 247517",
	"SPELL_AURA_APPLIED 247551 247544 247517",
	"SPELL_AURA_APPLIED_DOSE 247544"
)

local warnBeguilingCharm			= mod:NewTargetAnnounce(247549, 4)
local warnFelLash					= mod:NewSpellAnnounce(247604, 2)
local warnHeartBreaker				= mod:NewTargetAnnounce(247517, 2, nil, "Healer")

local specWarnBeguilingCharm		= mod:NewSpecialWarningLookAway(247549, nil, nil, nil, 3, 2)
local specWarnSadist				= mod:NewSpecialWarningCount(247544, nil, DBM_CORE_L.AUTO_SPEC_WARN_OPTIONS.stack:format(12, 159515), nil, 1, 2)
local specWarnSadistOther			= mod:NewSpecialWarningTaunt(247544, nil, nil, nil, 1, 2)

local timerBeguilingCharmCD			= mod:NewCDTimer(34.1, 247549, nil, nil, nil, 2, nil, DBM_COMMON_L.IMPORTANT_ICON, nil, 1, 4)
local timerFelLashCD				= mod:NewCDTimer(31.1, 247604, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerHeartBreakerCD			= mod:NewCDTimer(21.2, 247517, nil, "Healer", nil, 5, nil, DBM_COMMON_L.HEALER_ICON)

mod:AddReadyCheckOption(48620, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		timerHeartBreakerCD:Start(5-delay)
		timerFelLashCD:Start(15-delay)
		timerBeguilingCharmCD:Start(30-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 247549 then
		specWarnBeguilingCharm:Show(args.sourceName)
		specWarnBeguilingCharm:Play("turnaway")
		timerBeguilingCharmCD:Start()
	elseif spellId == 247604 then
		warnFelLash:Show()
		timerFelLashCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 247517 then
		timerHeartBreakerCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 247551 then
		warnBeguilingCharm:CombinedShow(1, args.destName)
	elseif spellId == 247544 then
		local amount = args.amount or 1
		if (amount >= 12) and self:AntiSpam(4, 4) then--First warning at 12, then spam every 4 seconds above.
			if self:IsTanking("player", "boss1", nil, true) then
				specWarnSadist:Show(amount)
				specWarnSadist:Play("changemt")
			else
				specWarnSadistOther:Show(L.name)
				specWarnSadistOther:Play("changemt")
			end
		end
	elseif spellId == 247517 then
		warnHeartBreaker:CombinedShow(0.3, args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

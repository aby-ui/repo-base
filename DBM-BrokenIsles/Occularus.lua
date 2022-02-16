local mod	= DBM:NewMod(2013, "DBM-BrokenIsles", 2, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(124492)
--mod:SetEncounterID(1952)--Does not have one
--mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 247320 247393",
	"SPELL_CAST_SUCCESS 247318 247325 247332",
	"SPELL_AURA_APPLIED 247318 247330",
	"SPELL_AURA_APPLIED_DOSE 247318"
)

local warnGushingWound					= mod:NewStackAnnounce(247318, 2, nil, "Tank")
local warnLash							= mod:NewSpellAnnounce(247325, 2, nil, "Tank")

local specWarnGushingWound				= mod:NewSpecialWarningStack(247318, nil, 3, nil, nil, 1, 6)
local specWarnGushingWoundOther			= mod:NewSpecialWarningTaunt(247318, nil, nil, nil, 1, 2)
local specWarnSearingGaze				= mod:NewSpecialWarningInterrupt(247320, "HasInterrupt", nil, nil, 1, 2)
local specWarnPhantasm					= mod:NewSpecialWarningDodge(247393, nil, nil, nil, 2, 2)
local specWarnEyeSore					= mod:NewSpecialWarningTarget(247330, "Healer", nil, nil, 1, 2)

local timerGushingWoundCD				= mod:NewCDTimer(8.5, 247318, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerLashCD						= mod:NewCDTimer(15.9, 247325, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerSearingGazeCD				= mod:NewCDTimer(7.3, 247320, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerPhantasmCD					= mod:NewCDTimer(31.9, 247393, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerEyeSoreCD					= mod:NewCDTimer(23.0, 247330, nil, "Healer", nil, 3, nil, DBM_COMMON_L.HEALER_ICON)

mod:AddReadyCheckOption(49195, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 247320 then
		timerSearingGazeCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnSearingGaze:Show(args.sourceName)
			specWarnSearingGaze:Play("kickcast")
		end
	elseif spellId == 247393 then
		specWarnPhantasm:Show()
		specWarnPhantasm:Play("watchorb")
		timerPhantasmCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 247318 then
		timerGushingWoundCD:Start()
	elseif spellId == 247325 then
		warnLash:Show()
		timerLashCD:Start()
	elseif spellId == 247332 then
		timerEyeSoreCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 247318 then
		local amount = args.amount or 1
		if amount >= 3 then--Lasts 20 seconds, cast every 8 seconds, swapping will be at 3
			if args:IsPlayer() then--At this point the other tank SHOULD be clear.
				specWarnGushingWound:Show(amount)
				specWarnGushingWound:Play("stackhigh")
			else--Taunt as soon as stacks are clear, regardless of stack count.
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", args.spellName) then
					specWarnGushingWoundOther:Show(args.destName)
					specWarnGushingWoundOther:Play("tauntboss")
				else
					warnGushingWound:Show(args.destName, amount)
				end
			end
		else
			warnGushingWound:Show(args.destName, amount)
		end
	elseif spellId == 247330 then
		specWarnEyeSore:CombinedShow(0.3, args.destName)
		if self:AntiSpam(4, 1) then
			specWarnEyeSore:Play("healall")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

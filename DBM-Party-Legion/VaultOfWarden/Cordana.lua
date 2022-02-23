local mod	= DBM:NewMod(1470, "DBM-Party-Legion", 10, 707)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217011830")
mod:SetCreatureID(95888)
mod:SetEncounterID(1818)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 213576 213583 197251 213685 197422",
	"SPELL_AURA_APPLIED 205004",
	"SPELL_AURA_REMOVED 206567 197422",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnDeepeningShadows			= mod:NewSpellAnnounce(213583, 4)
local warnVengeance					= mod:NewSpellAnnounce(205004, 4)

local specWarnKick					= mod:NewSpecialWarningSpell(197251, "Tank", nil, nil, 3, 2)
local specWarnDeepeningShadows		= mod:NewSpecialWarningMoveTo(213583, nil, nil, nil, 3, 12)
local specWarnHiddenStarted			= mod:NewSpecialWarningSpell(192750, nil, nil, nil, 2, 2)
local specWarnHiddenOver			= mod:NewSpecialWarningEnd(192750, nil, nil, nil, 1, 2)
local specWarnCreepingDoom			= mod:NewSpecialWarningDodge(197422, nil, nil, nil, 2, 2)
local specWarnVengeance				= mod:NewSpecialWarningMoveTo(205004, nil, nil, nil, 3, 12)

local timerKickCD					= mod:NewCDTimer(16, 197251, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--16-42
local timerDeepeningShadowsCD		= mod:NewCDTimer(30.5, 213583, nil, nil, nil, 3)
local timerCreepingDoom				= mod:NewBuffActiveTimer(35, 197422, nil, nil, nil, 6)--35-40
local timerVengeanceCD				= mod:NewCDTimer(35, 205004, nil, nil, nil, 1)--35-40

function mod:OnCombatStart(delay)
	timerKickCD:Start(8.3-delay)
	--timerDeepeningShadowsCD:Start(10.5-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 213576 or spellId == 213583 then
		if ExtraActionBarFrame:IsShown() then--Has light
			specWarnDeepeningShadows:Show(args.spellName)
			specWarnDeepeningShadows:Play("bringlighttoshadow")
		else
			warnDeepeningShadows:Show()
		end
		timerDeepeningShadowsCD:Start()
	elseif spellId == 197251 then
		specWarnKick:Show()
		specWarnKick:Play("carefly")
		timerKickCD:Start()
	elseif spellId == 197422 then--First creeping doom
		specWarnCreepingDoom:Show()
		specWarnCreepingDoom:Play("stilldanger")
		specWarnCreepingDoom:ScheduleVoice(2, "keepmove")
		timerKickCD:Stop()
		timerDeepeningShadowsCD:Stop()
		timerCreepingDoom:Start()
	elseif spellId == 213685 then--Second creeping doom
		specWarnCreepingDoom:Show()
		specWarnCreepingDoom:Play("stilldanger")
		specWarnCreepingDoom:ScheduleVoice(2, "keepmove")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 205004 then
		if ExtraActionBarFrame:IsShown() then--Has light
			specWarnVengeance:Show(args.spellName)
			specWarnVengeance:Play("bringlighttomob")
		else
			warnVengeance:Show()
		end
		timerVengeanceCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 206567 then
		specWarnHiddenOver:Show()
		specWarnHiddenOver:Play("phasechange")
		--timerVengeanceCD:Start(14)
		timerKickCD:Start(15.5)--15-20
		timerDeepeningShadowsCD:Start(20)--20-25
	elseif spellId == 197422 then
		timerVengeanceCD:Start(10)
		timerKickCD:Start(20)--Small sample
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 203416 then--Shadowstep. Faster than 206567 applied
		timerDeepeningShadowsCD:Stop()
		timerKickCD:Stop()
		specWarnHiddenStarted:Show()
		specWarnHiddenStarted:Play("phasechange")
	end
end

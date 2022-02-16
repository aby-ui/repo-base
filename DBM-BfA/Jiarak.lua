local mod	= DBM:NewMod(2141, "DBM-BfA", 2, 1028)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116032237")
mod:SetCreatureID(132253)
--mod:SetEncounterID(1880)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors
--mod:SetMinSyncRevision(11969)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 260908",
	"SPELL_CAST_SUCCESS 261467 261088"
)

local specWarnStormWing				= mod:NewSpecialWarningSpell(260908, nil, nil, nil, 2, 2)
local specWarnHurricaneCrash		= mod:NewSpecialWarningRun(261088, nil, nil, nil, 4, 2)
local specWarnMatriarchsCall		= mod:NewSpecialWarningSwitch(261467, "-Healer", nil, 2, 1, 2)

local timerStormWingCD				= mod:NewCDTimer(46.2, 260908, nil, nil, nil, 2)
local timerHurricaneCrashCD			= mod:NewCDTimer(46.2, 261088, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerMatriarchCallCD			= mod:NewCDTimer(46.2, 261467, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 260908 then
		specWarnStormWing:Show()
		specWarnStormWing:Play("aesoon")
		timerStormWingCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 261467 then
		specWarnMatriarchsCall:Show()
		specWarnMatriarchsCall:Play("killmob")
		timerMatriarchCallCD:Start()
	elseif spellId == 261088 then
		specWarnHurricaneCrash:Show()
		specWarnHurricaneCrash:Play("justrun")
		specWarnHurricaneCrash:ScheduleVoice(1.5, "keepmove")
		timerHurricaneCrashCD:Start()
	end
end

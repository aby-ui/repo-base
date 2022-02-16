local mod	= DBM:NewMod(2134, "DBM-Party-BfA", 5, 1001)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116185401")
mod:SetCreatureID(128651)
mod:SetEncounterID(2099)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 257882 276068",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local specWarnCrashingTide			= mod:NewSpecialWarningDodge(261563, "Tank", nil, nil, 1, 2)
local specWarnBreakWater			= mod:NewSpecialWarningDodge(257882, nil, nil, nil, 2, 2)
local specWarnTidalSurge			= mod:NewSpecialWarningMoveTo(276068, nil, nil, nil, 3, 2)

local timerCrashingTideCD			= mod:NewCDTimer(15.8, 261563, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerBreakWaterCD				= mod:NewCDTimer(30, 257882, nil, nil, nil, 3)
local timerTidalSurgeCD				= mod:NewCDTimer(49.8, 276068, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)

function mod:OnCombatStart(delay)
	timerBreakWaterCD:Start(7.1-delay)
	timerCrashingTideCD:Start(13.1-delay)
	timerTidalSurgeCD:Start(24.1-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 257882 then
		specWarnBreakWater:Show()
		specWarnBreakWater:Play("watchstep")
		timerBreakWaterCD:Start()
	elseif spellId == 276068 then
		specWarnTidalSurge:Show(DBM_COMMON_L.BREAK_LOS)
		specWarnTidalSurge:Play("findshelter")
		timerTidalSurgeCD:Start()--Unknown, pulls to short
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
	if spellId == 257861 then--Crashing Tide
		specWarnCrashingTide:Show()
		specWarnCrashingTide:Play("shockwave")
		timerCrashingTideCD:Start()
	end
end

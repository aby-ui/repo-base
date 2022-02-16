local mod	= DBM:NewMod(2198, "DBM-BfA", 1, 1028)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116032237")
mod:SetCreatureID(140163)
--mod:SetEncounterID(1880)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors
--mod:SetMinSyncRevision(11969)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 274842 274932"
)

local warnVoidNova					= mod:NewSpellAnnounce(274842, 3)

local specWarnEndlessAbyss			= mod:NewSpecialWarningRun(274932, nil, nil, nil, 4, 2)

local timerVoidNovaCD				= mod:NewCDTimer(22.3, 274842, nil, nil, nil, 2)
local timerEndlessAbyssCD			= mod:NewCDTimer(45.7, 274932, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)

--mod:AddReadyCheckOption(37460, false)

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		--timerVoidNovaCD:Start(1-delay)
		--timerEndlessAbyssCD:Start(1-delay)
	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 274842 then
		warnVoidNova:Show()
		timerVoidNovaCD:Start()
	elseif spellId == 274932 then
		specWarnEndlessAbyss:Show()
		specWarnEndlessAbyss:Play("justrun")
		timerEndlessAbyssCD:Start()
	end
end

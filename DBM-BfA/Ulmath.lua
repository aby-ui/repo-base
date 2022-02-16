local mod	= DBM:NewMod(2362, "DBM-BfA", 5, 1028)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116032237")
mod:SetCreatureID(152697)--152736/guardian-tannin, 152729/moon-priestess-liara
mod:SetEncounterID(2317)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors
--mod:SetMinSyncRevision(11969)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 301748 301773 301840"
)

--TODO, upgrade endlessdoom to special warning?
local warnEndlessDoom				= mod:NewSpellAnnounce(301748, 3)

local specWarnMentalCollapse		= mod:NewSpecialWarningRun(301773, nil, nil, nil, 4, 2)
local specWarnVoidDance				= mod:NewSpecialWarningDodge(301840, nil, nil, nil, 2, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(238028, nil, nil, nil, 1, 8)

local timerEndlessDoomCD			= mod:NewCDTimer(72, 301748, nil, nil, nil, 3)--Need at least one more log, i was dumb and released thinking rez was closeby, it wasn't
local timerMentalCollapseCD			= mod:NewCDTimer(20.4, 301773, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerVoidDanceCD				= mod:NewCDTimer(21.4, 301840, nil, nil, nil, 3)

--mod:AddRangeFrameOption(8, 261605)
--mod:AddReadyCheckOption(37460, false)

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
--		timerEndlessDoomCD:Start(1-delay)
--		timerMentalCollapseCD:Start(1-delay)
--		timerVoidDanceCD:Start(1-delay)
	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 301748 then
		warnEndlessDoom:Show()
		timerEndlessDoomCD:Start()
	elseif spellId == 301773 then
		specWarnMentalCollapse:Show()
		specWarnMentalCollapse:Play("justrun")
		timerMentalCollapseCD:Start()
	elseif spellId == 301840 then
		specWarnVoidDance:Show()
		specWarnVoidDance:Play("watchstep")
		timerVoidDanceCD:Start()
	end
end

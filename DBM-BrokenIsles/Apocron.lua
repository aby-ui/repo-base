local mod	= DBM:NewMod(1956, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(121124)
--mod:SetEncounterID(1880)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 241458 241498 241518"
)

local warnFelfireMissiles				= mod:NewTargetAnnounce(241498, 2)

local specWarnQuake						= mod:NewSpecialWarningSpell(241458, nil, nil, nil, 2, 2)
local specWarnFelfireMissiles			= mod:NewSpecialWarningMoveAway(241498, nil, nil, nil, 1, 2)
local specWarnFelfireMissilesNear		= mod:NewSpecialWarningClose(241498, nil, nil, nil, 1, 2)
local specWarnSear						= mod:NewSpecialWarningDefensive(241518, "Tank", nil, nil, 1, 2)

local timerQuakeCD						= mod:NewCDTimer(22.1, 241458, nil, nil, nil, 2)--22.1-25.6
local timerFelfireMissilesCD			= mod:NewCDTimer(9.7, 241498, nil, nil, nil, 3)--9.7-14.6
local timerSearCD						= mod:NewCDTimer(9.7, 241518, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--mod:AddReadyCheckOption(37460, false)

function mod:MissilesTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnFelfireMissiles:Show()
		specWarnFelfireMissiles:Play("runout")
	elseif self:CheckNearby(10, targetname) then
		specWarnFelfireMissilesNear:Show(targetname)
		specWarnFelfireMissilesNear:Play("watchstep")
	else
		warnFelfireMissiles:Show(targetname)
	end
end

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 241458 then
		specWarnQuake:Show()
		specWarnQuake:Play("carefly")
		timerQuakeCD:Start()
	elseif spellId == 241498 then
		timerFelfireMissilesCD:Start()
		self:BossTargetScanner(args.sourceGUID, "MissilesTarget", 0.2, 5)
	elseif spellId == 241518 then
		specWarnSear:Show()
		specWarnSear:Play("defensive")
		timerSearCD:Start()
	end
end

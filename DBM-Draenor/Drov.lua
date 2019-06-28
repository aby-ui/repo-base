local mod	= DBM:NewMod(1291, "DBM-Draenor", nil, 557)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019052110231")
mod:SetCreatureID(81252)
mod:SetReCombatTime(20)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 175791",
	"SPELL_AURA_APPLIED 175827"
)

local specWarnColossalSlam		= mod:NewSpecialWarningDodge(175791, nil, nil, nil, 2, 2)
local specWarnCallofEarth		= mod:NewSpecialWarningSpell(175827)

local timerColossalSlamCD		= mod:NewCDTimer(16, 175791, nil, nil, nil, 3)--16-35 second variation? Then again was a bad pull with no tank, boss running loose so may have affected timer
local timerCallofEarthCD		= mod:NewCDTimer(90, 175827, nil, nil, nil, 1)

--mod:AddReadyCheckOption(37460, false, 100)

function mod:OnCombatStart(delay, yellTriggered)
--[[	if yellTriggered then

	end--]]
end

function mod:OnCombatEnd()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 175791 then
		specWarnColossalSlam:Show()
		timerColossalSlamCD:Start()
		specWarnColossalSlam:Play("shockwave")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 175827 then
		specWarnCallofEarth:Show()
		timerCallofEarthCD:Start()
	end
end

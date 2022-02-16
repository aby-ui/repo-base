local mod	= DBM:NewMod(1795, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(99929)
mod:SetEncounterID(1951)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 220340 223317 223373",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnYaksam				= mod:NewCastAnnounce(223373, 3)
local warnJetsam				= mod:NewTargetAnnounce(220295, 2)

local specWarnGetsam			= mod:NewSpecialWarningDodge(220340, "Tank", nil, nil, 1, 2)
local specWarnBreakSam			= mod:NewSpecialWarningSpell(223317, "Melee", nil, nil, 1, 2)

local timerGetsamCD				= mod:NewCDTimer(53, 220340, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerYaksamCD				= mod:NewCDTimer(50, 223373, nil, nil, nil, 1)--50-55

--mod:AddReadyCheckOption(37460, false)

function mod:JetsamTarget(targetname, uId)
	if not targetname then return end
	warnJetsam:Show(targetname)
end

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end
--]]

function mod:OnCombatEnd()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 223317 then
		specWarnBreakSam:Show()
		specWarnBreakSam:Play("carefly")
	elseif spellId == 220340 then
		specWarnGetsam:Show()
		specWarnGetsam:Play("shockwave")
		timerGetsamCD:Start()
	elseif spellId == 223373 then
		warnYaksam:Show()
		timerYaksamCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 220295 and self:AntiSpam(4, 1) then---220277-Summon Jetsam Stalker/220295-Jetsam
		self:BossTargetScanner(99929, "JetsamTarget", 0.2, 5)
	end
end

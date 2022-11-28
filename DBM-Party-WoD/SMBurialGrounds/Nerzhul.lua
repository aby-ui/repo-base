local mod	= DBM:NewMod(1160, "DBM-Party-WoD", 6, 537)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20221127051031")
mod:SetCreatureID(76407)
mod:SetEncounterID(1682)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 154442",
--	"SPELL_SUMMON 154350",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
ability.id = 154442 and type = "begincast"
 or ability.id = 154350
 or ability.id = 154671
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--TODO, 154350 is not firing spell summmon anymore in 10.0.2 M+ version, Omen of Death moved to USCS but target scan needs to be rechecked as well
local warnOmenOfDeath			= mod:NewTargetAnnounce(154350, 3)

local specWarnRitualOfBones		= mod:NewSpecialWarningSpell(154671, nil, nil, nil, 2, 2)
local specWarnOmenOfDeath		= mod:NewSpecialWarningMove(154350, nil, nil, nil, 1, 2)
local specWarnOmenOfDeathNear	= mod:NewSpecialWarningClose(154350, nil, nil, nil, 1, 2)
local yellOmenOfDeath			= mod:NewYell(154350)
local specWarnMalevolence		= mod:NewSpecialWarningDodge(154442, nil, nil, nil, 2, 2)

local timerRitualOfBonesCD		= mod:NewCDTimer(50.5, 154671, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerOmenOfDeathCD		= mod:NewCDTimer(10.5, 154350, nil, nil, nil, 3)

function mod:OmenOfDeathTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnOmenOfDeath:Show()
		specWarnOmenOfDeath:Play("runaway")
		yellOmenOfDeath:Yell()
	elseif self:CheckNearby(8, targetname) then
		specWarnOmenOfDeathNear:Show(targetname)
		specWarnOmenOfDeathNear:Play("watchstep")
	else
		warnOmenOfDeath:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	--timerOmenOfDeathCD:Start(8.5-delay)
	timerRitualOfBonesCD:Start(20-delay)
	specWarnRitualOfBones:ScheduleVoice(18-delay, "specialsoon")
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 154442 then
		specWarnMalevolence:Show()
		specWarnMalevolence:Play("shockwave")
	end
end

--[[
function mod:SPELL_SUMMON(args)
	if args.spellId == 154350 then
		self:BossTargetScanner(76407, "OmenOfDeathTarget", 0.04, 15)
		timerOmenOfDeathCD:Start()
	end
end
--]]

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 154671 then
		specWarnRitualOfBones:Show()
		specWarnRitualOfBones:ScheduleVoice(48.5, "specialsoon")
		timerRitualOfBonesCD:Start()
	elseif spellId == 177691 then
		self:BossTargetScanner(76407, "OmenOfDeathTarget", 0.04, 15)
		timerOmenOfDeathCD:Start()
	end
end

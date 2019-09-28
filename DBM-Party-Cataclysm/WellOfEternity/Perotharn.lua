local mod	= DBM:NewMod(290, "DBM-Party-Cataclysm", 13, 185)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(55085)
mod:SetEncounterID(1272)
mod:SetZone()

mod:RegisterCombat("say", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 108141",
	"SPELL_CAST_SUCCESS 104905",
	"SPELL_AURA_APPLIED 105544 105526",
	"SPELL_AURA_REMOVED 105544"
)
mod.onlyHeroic = true

local warnFelFlames			= mod:NewTargetNoFilterAnnounce(108141, 3)
local warnDecay				= mod:NewTargetNoFilterAnnounce(105544, 3, nil, "Healer")
local warnFelQuickening		= mod:NewTargetNoFilterAnnounce(104905, 3, nil, "Tank|Healer")

local specWarnFelFlames		= mod:NewSpecialWarningMove(108141, nil, nil, nil, 1, 2)

local timerFelFlamesCD		= mod:NewNextTimer(8.4, 108141, nil, nil, nil, 3)
local timerDecay			= mod:NewTargetTimer(10, 105544, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerDecayCD			= mod:NewNextTimer(17, 105544, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerFelQuickening	= mod:NewBuffActiveTimer(15, 104905, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON..DBM_CORE_HEALER_ICON)

local function showFelFlamesWarning()
	local targetname = mod:GetBossTarget(55085)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnFelFlames:Show()
		specWarnFelFlames:Play("watchstep")
	else
		warnFelFlames:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	timerFelFlamesCD:Start(5-delay)
	timerDecayCD:Start(8-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 108141 then
		timerFelFlamesCD:Start()
		self:Schedule(0.2, showFelFlamesWarning)
	end
end

--This mod needs work, the timers on this are based on failing at eyes, I don't have a log of actually doing it right, which should extend this phase significantly
function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 104905 then
		self:SetWipeTime(30)--You leave combat briefly during this transition, we don't want the mod ending prematurely.
		timerFelFlamesCD:Start(39.5)
		timerDecayCD:Start(44)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 105544 then
		warnDecay:Show(args.destName)
		timerDecay:Start(args.destName)
		timerDecayCD:Start()
	elseif args.spellId == 105526 then
		warnFelQuickening:Show(args.destName)
		timerFelQuickening:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 105544 then
		timerDecay:Cancel(args.destName)
	end
end
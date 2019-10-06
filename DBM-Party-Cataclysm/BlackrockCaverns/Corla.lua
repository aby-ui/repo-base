local mod	= DBM:NewMod(106, "DBM-Party-Cataclysm", 1, 66)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39679)
mod:SetEncounterID(1038)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 75823 75697",
	"SPELL_AURA_APPLIED_DOSE 75697",
	"SPELL_AURA_REMOVED 75608",
	"SPELL_CAST_START 75823 82362",
	"SPELL_INTERRUPT"
)

local warnDarkCommand		= mod:NewTargetNoFilterAnnounce(75823, 4)
local warnAdd				= mod:NewAnnounce("WarnAdd", 4)

local specWarnShadowStrike	= mod:NewSpecialWarningInterrupt(82362, nil, nil, nil, 1, 2)
local specWarnDarkCommand	= mod:NewSpecialWarningInterrupt(75823, nil, nil, nil, 1, 2)
local specWarnEvolution		= mod:NewSpecialWarningStack(75697, true, 80, nil, nil, 1, 6)

local timerDarkCommandCast	= mod:NewCastTimer(4, 75823, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerDarkCommand		= mod:NewTargetTimer(4, 75823, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerDarkCommandCD	= mod:NewCDTimer(25, 75823, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerShadowStrike		= mod:NewCastTimer(2, 82362, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerEvolution		= mod:NewBuffFadesTimer(15, 75697, nil, nil, nil, 5)

function mod:OnCombatStart(delay)
	timerDarkCommandCD:Start(22-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 75823 then
		warnDarkCommand:Show(args.destName)
		timerDarkCommand:Start(args.destName)
	elseif args.spellId == 75697 and args:IsPlayer() then
		timerEvolution:Start()
		if (args.amount or 1) >= 80 and self:AntiSpam(5) then
			specWarnEvolution:Show(args.amount)
			specWarnEvolution:Play("stackhigh")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 75608 then
		warnAdd:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 75823 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDarkCommand:Show(args.sourceName)
			specWarnDarkCommand:Play("kickcast")
		end
		timerDarkCommandCast:Start()
		timerDarkCommandCD:Start()
	elseif args.spellId == 82362 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnShadowStrike:Show(args.sourceName)
			specWarnShadowStrike:Play("kickcast")
		end
		if self:IsDifficulty("heroic5") then
			timerShadowStrike:Start()
		else
			timerShadowStrike:Start(3)
		end
	end
end

function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and args.extraSpellId == 82362 then
		timerShadowStrike:Cancel()
	elseif type(args.extraSpellId) == "number" and args.extraSpellId == 75823 then
		timerDarkCommandCast:Cancel()
	end
end
local mod	= DBM:NewMod(190, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(24239)
mod:SetEncounterID(1193)
mod:SetZone()

mod:RegisterCombat("combat")
mod:SetMinCombatTime(30)	-- Prevent pre-maturely combat-end in cases where none targets the boss?

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 43451 43431 43548",
	"SPELL_CAST_SUCCESS 43436",
	"SPELL_AURA_APPLIED 43501 43383 43421",
	"SPELL_PERIODIC_DAMAGE 43429 43440 61603",
	"SPELL_PERIODIC_MISSED 43429 43440 61603"
)
mod.onlyHeroic = true

local warnSiphon			= mod:NewTargetNoFilterAnnounce(43501, 3)
local warnSpiritBolts		= mod:NewSpellAnnounce(43383, 3)
local warnSpiritBoltsSoon	= mod:NewSoonAnnounce(43383, 5, 2)

local specWarnFireNovaTotem	= mod:NewSpecialWarningSwitch(43436, "Dps", nil, nil, 1, 2)
local specWarnHolyLight		= mod:NewSpecialWarningInterrupt(43451, "HasInterrupt", nil, 2, 1, 2)
local specWarnFlashHeal		= mod:NewSpecialWarningInterrupt(43431, "HasInterrupt", nil, 2, 1, 2)
local specWarnHealingWave	= mod:NewSpecialWarningInterrupt(43548, "HasInterrupt", nil, 2, 1, 2)
local specWarnLifebloom		= mod:NewSpecialWarningDispel(43421, "MagicDispeller", nil, nil, 1, 2)
local specWarnGTFO			= mod:NewSpecialWarningGTFO(43440, nil, nil, nil, 1, 8)

local timerSiphon			= mod:NewTimer(30, "TimerSiphon", 43501, nil, nil, 3)
local timerSpiritBolts		= mod:NewBuffActiveTimer(5, 43383, nil, nil, nil, 2)
local timerSpiritBoltsNext	= mod:NewNextTimer(36, 43383, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	timerSpiritBoltsNext:Start(15-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 43451 and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
		specWarnHolyLight:Show(args.sourceName)
		specWarnHolyLight:Play("kickcast")
	elseif args.spellId == 43431 and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
		specWarnFlashHeal:Show(args.sourceName)
		specWarnFlashHeal:Play("kickcast")
	elseif args.spellId == 43548 and self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
		specWarnHealingWave:Show(args.sourceName)
		specWarnHealingWave:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 43436 then
		specWarnFireNovaTotem:Show()
		specWarnFireNovaTotem:Play("attacktotem")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43501 then
		local uId = DBM:GetRaidUnitId(args.destName)
		local class = select(2, UnitClass(uId)) or "unknown"
		class = class:sub(0, 1):upper()..class:sub(2):lower()
		warnSiphon:Show(args.destName)
		timerSiphon:Start(args.spellName, class)
	elseif args.spellId == 43383 then
		warnSpiritBolts:Show()
		warnSpiritBoltsSoon:Schedule(31)
		timerSpiritBolts:Start()
		timerSpiritBoltsNext:Start()
	elseif args.spellId == 43421 and self:CheckDispelFilter() then
		specWarnLifebloom:Show(args.destName)
		specWarnLifebloom:Play("dispelboss")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 43429 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("watchfeet")
	elseif spellId == 43440 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("watchfeet")
	elseif spellId == 61603 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

local mod	= DBM:NewMod(889, "DBM-Party-WoD", 2, 385)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(74790)
mod:SetEncounterID(1654)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 150677 150784 150755",
	"SPELL_AURA_APPLIED 150678",
	"SPELL_PERIODIC_DAMAGE 150784",
	"SPELL_ABSORBED 150784"
)

--TODO, Add heroic ability "Flame Buffet"? Seems to just stack up over time and not really need warnings.
local warnMoltenCore			= mod:NewTargetAnnounce(150678, 2)

local specWarnMoltenBlast		= mod:NewSpecialWarningInterrupt(150677, "HasInterrupt", nil, 3, 1, 2)
local specWarnUnstableSlag		= mod:NewSpecialWarningSwitch(150755, "Dps", nil, 2, 1, 2)
local specWarnMagmaEruptionCast	= mod:NewSpecialWarningSpell(150784, nil, nil, nil, 2, 2)
local specWarnMagmaEruption		= mod:NewSpecialWarningMove(150784, nil, nil, nil, 1, 8)
local specWarnMoltenCore		= mod:NewSpecialWarningDispel(150678, "MagicDispeller", nil, nil, 1, 2)

local timerMagmaEruptionCD		= mod:NewCDTimer(20, 150784)
local timerUnstableSlagCD		= mod:NewCDTimer(20, 150755, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON, nil, 1, 4)

function mod:OnCombatStart(delay)
--	timerMagmaEruptionCD:Start(8-delay)--Poor sample size
	timerUnstableSlagCD:Start(-delay)--Also poor sample size but more likely to be correct.
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 150677 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMoltenBlast:Show(args.sourceName)
		if self:IsTank() then
			specWarnMoltenBlast:Play("kickcast")
		else
			specWarnMoltenBlast:Play("helpkick")
		end
	elseif spellId == 150784 then
		specWarnMagmaEruptionCast:Show()
		specWarnMagmaEruptionCast:Play("watchstep")
		timerMagmaEruptionCD:Start()
	elseif spellId == 150755 then
		specWarnUnstableSlag:Show()
		timerUnstableSlagCD:Start()
		specWarnUnstableSlag:Play("mobkill")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 150678 and not args:IsDestTypePlayer() then
		if self.Options.SpecWarn150678dispel then
			specWarnMoltenCore:Show(args.destName)
			specWarnMoltenCore:Play("dispelboss")
		else
			warnMoltenCore:Show(args.destName)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 150784 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnMagmaEruption:Show()
		specWarnMagmaEruption:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

local mod	= DBM:NewMod("RubyLifePoolsTrash", "DBM-Party-Dragonflight", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205064214")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 372087 391726 391723 373614 392395 372696",
	"SPELL_AURA_APPLIED 373693 392641",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 373693"
)

--TODO, can Blazing Rush be target scanned? upgrade to special announce?
--Lady's Trash, minus bottled anima, which will need a unit event to detect it looks like
local warnLivingBomb						= mod:NewTargetAnnounce(373693, 3)
local warnBlazingRush						= mod:NewCastAnnounce(372087, 3)
local warnBurnout							= mod:NewCastAnnounce(373614, 4)
local warnRollingThunder					= mod:NewTargetNoFilterAnnounce(392641, 3)

local specWarnLivingBomb					= mod:NewSpecialWarningMoveAway(373693, nil, nil, nil, 1, 2)
local yellLivingBomb						= mod:NewShortYell(373693)
local yellLivingBombFades					= mod:NewShortFadesYell(373693)
local specWarnStormBreath					= mod:NewSpecialWarningDodge(391726, nil, nil, nil, 2, 2)
local yellStormBreath						= mod:NewShortYell(391726)
local specWarnFlameBreath					= mod:NewSpecialWarningDodge(391723, nil, nil, nil, 2, 2)
local yellFlameBreath						= mod:NewShortYell(391723)
local specWarnExcavatingBlast				= mod:NewSpecialWarningDodge(372696, nil, nil, nil, 2, 2)
local specWarnBurnout						= mod:NewSpecialWarningRun(373614, "Melee", nil, nil, 4, 2)
local specWarnThunderJaw					= mod:NewSpecialWarningDefensive(392395, nil, nil, nil, 1, 2)
--local specWarnSharedSuffering				= mod:NewSpecialWarningYou(339607, nil, nil, nil, 1, 2)
--local specWarnDirgefromBelow				= mod:NewSpecialWarningInterrupt(310839, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:StormBreathTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellStormBreath:Yell()
	end
end

function mod:FlameBreathTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellFlameBreath:Yell()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 310780 and self:AntiSpam(5, 6) then
		warnBlazingRush:Show()
	elseif spellId == 391726 then
		if self:AntiSpam(3, 2) then
			specWarnStormBreath:Show()
			specWarnStormBreath:Play("breathsoon")
		end
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "StormBreathTarget", 0.1, 8)
	elseif spellId == 391723 then
		if self:AntiSpam(3, 2) then
			specWarnFlameBreath:Show()
			specWarnFlameBreath:Play("breathsoon")
		end
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "FlameBreathTarget", 0.1, 8)
	elseif spellId == 373614 and self:AntiSpam(3, 1) then
		if self.Options.SpecWarn373614run then
			specWarnBurnout:Show()
			specWarnBurnout:Play("justrun")
		else
			warnBurnout:Show()
		end
	elseif spellId == 372696 and self:AntiSpam(3, 2) then
		specWarnExcavatingBlast:Show()
		specWarnExcavatingBlast:Play("watchstep")
	elseif spellId == 392395 then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnThunderJaw:Show()
			specWarnThunderJaw:Play("carefly")
		end
--	elseif spellId == 310839 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
--		specWarnDirgefromBelow:Show(args.sourceName)
--		specWarnDirgefromBelow:Play("kickcast")
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 373693 then
		warnLivingBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnLivingBomb:Show()
			specWarnLivingBomb:Play("runout")
			yellLivingBomb:Yell()
			yellLivingBombFades:Countdown(spellId)
		end
	elseif spellId == 392641 then
		warnRollingThunder:CombinedShow(0.3, args.destName)
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then
		yellLivingBombFades:Cancel()
	end
end

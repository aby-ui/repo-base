local mod	= DBM:NewMod("AlgetharAcademyTrash", "DBM-Party-Dragonflight", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221203231852")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 387910 377383 378003 388976 388863 377912 387843 388392",
	"SPELL_CAST_SUCCESS 390915",
	"SPELL_AURA_APPLIED 388984 387843",
--	"SPELL_AURA_APPLIED_DOSE 339528",
	"SPELL_AURA_REMOVED 387843"
)

--TODO: add https://www.wowhead.com/spell=386026/surge ?
local warnAstralWhirlwind						= mod:NewCastAnnounce(387910, 3)
local warnManavoid								= mod:NewCastAnnounce(388863, 3)
local warnMonotonousLecture						= mod:NewCastAnnounce(388392, 2)
local warnAstralBomb							= mod:NewCastAnnounce(387843, 3)
local warnAstralBombTargets						= mod:NewTargetAnnounce(387843, 3)
local warnViciousAmbush							= mod:NewTargetAnnounce(388984, 3)

local specWarnExpelIntruders					= mod:NewSpecialWarningRun(377912, nil, nil, nil, 4, 2)
local specWarnDetonateSeeds						= mod:NewSpecialWarningDodge(390915, nil, nil, nil, 2, 2)
local specWarnDeadlyWinds						= mod:NewSpecialWarningDodge(378003, nil, nil, nil, 2, 2)
local specWarnRiftbreath						= mod:NewSpecialWarningDodge(388976, nil, nil, nil, 2, 2)
local specWarnGust								= mod:NewSpecialWarningDodge(377383, nil, nil, nil, 2, 2)
local yellGust									= mod:NewYell(377383)
local specWarnViciousAmbush						= mod:NewSpecialWarningYou(388984, nil, nil, nil, 1, 2)--You warning not move away, because some strategies involve actually baiting charge into melee instead of out
local yellnViciousAmbush						= mod:NewYell(388984)
local specWarnAstralBomb						= mod:NewSpecialWarningMoveAway(387843, nil, nil, nil, 2, 2)
local yellAstralBomb							= mod:NewYell(387843)
local yellAstralBombFades						= mod:NewShortFadesYell(387843)
--local yellConcentrateAnimaFades				= mod:NewShortFadesYell(339525)
--local specWarnSharedSuffering					= mod:NewSpecialWarningYou(339607, nil, nil, nil, 1, 2)
--local specWarnDirgefromBelow					= mod:NewSpecialWarningInterrupt(310839, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:GustTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellGust:Yell()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 387910 and self:AntiSpam(4, 6) then
		warnAstralWhirlwind:Show()
	elseif spellId == 388863 and self:AntiSpam(4, 6) then
		warnManavoid:Show()
	elseif spellId == 387843 and self:AntiSpam(4, 5) then
		warnAstralBomb:Show()
	elseif spellId == 388392 and self:AntiSpam(4, 5) then
		warnMonotonousLecture:Show()
	elseif spellId == 377383 then
		if self:AntiSpam(3, 2) then
			specWarnGust:Show()
			specWarnGust:Play("shockwave")
		end
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "GustTarget", 0.1, 8)
	elseif spellId == 378003 and self:AntiSpam(3, 2) then
		specWarnDeadlyWinds:Show()
		specWarnDeadlyWinds:Play("watchstep")
	elseif spellId == 388976 and self:AntiSpam(3, 2) then
		specWarnRiftbreath:Show()
		specWarnRiftbreath:Play("shockwave")
	elseif spellId == 377912 and self:AntiSpam(3, 1) then
		specWarnExpelIntruders:Show()
		specWarnExpelIntruders:Play("justrun")
--	elseif spellId == 310839 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
--		specWarnDirgefromBelow:Show(args.sourceName)
--		specWarnDirgefromBelow:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 390915 and self:AntiSpam(3, 2) then
		specWarnDetonateSeeds:Show()
		specWarnDetonateSeeds:Play("watchstep")
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 388984 then
		warnViciousAmbush:Show(args.destName)
		if args:IsPlayer() then
			specWarnViciousAmbush:Show()
			specWarnViciousAmbush:Play("targetyou")
			yellnViciousAmbush:Yell()
		end
	elseif spellId == 387843 then
		warnAstralBombTargets:Show(args.destName)
		if args:IsPlayer() then
			specWarnAstralBomb:Show()
			specWarnAstralBomb:Play("runout")
			yellAstralBomb:Yell()
			yellAstralBombFades:Countdown(spellId, 2)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 387843 and args:IsPlayer() then
		yellAstralBombFades:Cancel()
	end
end

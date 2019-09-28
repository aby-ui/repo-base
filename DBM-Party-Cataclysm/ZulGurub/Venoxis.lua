local mod	= DBM:NewMod(175, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(52155)
mod:SetEncounterID(1178)
mod:SetZone()
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 96842"
)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 96477 96509 96512 96466",
	"SPELL_AURA_REMOVED 96466 96477"
)
mod.onlyHeroic = true

local warnWordHethiss		= mod:NewSpellAnnounce(96560, 2)
local warnBreathHethiss		= mod:NewSpellAnnounce(96509, 3)
local warnToxicLink			= mod:NewTargetNoFilterAnnounce(96477, 4)
local warnBlessing			= mod:NewSpellAnnounce(96512, 3)

local specWarnWhisperHethiss= mod:NewSpecialWarningInterrupt(96466, "HasInterrupt", nil, nil, 1, 2)
local specWarnToxicLink		= mod:NewSpecialWarningYou(96477, nil, nil, nil, 1, 2)
local specWarnBloodvenom	= mod:NewSpecialWarningSpell(96842, nil, nil, nil, 2, 2)
local specWarnPoolAcridTears= mod:NewSpecialWarningMove(96521, nil, nil, nil, 1, 2)
local specWarnEffusion		= mod:NewSpecialWarningMove(96680, nil, nil, nil, 1, 2)

local timerWhisperHethiss	= mod:NewTargetTimer(8, 96466, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerBreathHethiss	= mod:NewNextTimer(12, 96509, nil, nil, nil, 3)
local timerToxicLinkCD		= mod:NewNextTimer(14, 96477, nil, nil, nil, 3)--13-15 second variations, 14 will be a good medium

mod:AddSetIconOption("SetIconOnToxicLink", 96477, true, false, {7, 8})

mod.vb.toxicLinkIcon = 8
local toxicLinkTargets = {}

local function warnToxicLinkTargets(self)
	warnToxicLink:Show(table.concat(toxicLinkTargets, "<, >"))
	table.wipe(toxicLinkTargets)
	self.vb.toxicLinkIcon = 8	
end

function mod:OnCombatStart(delay)
	timerToxicLinkCD:Start(12-delay)
	self.vb.toxicLinkIcon = 8
	table.wipe(toxicLinkTargets)
	if not self:IsTrivial(90) then--Only warning that uses these events is remorseless winter and that warning is completely useless spam for level 90s.
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE 96685 96521",
			"SPELL_MISSED 96685 96521"
		)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96477 then
		toxicLinkTargets[#toxicLinkTargets + 1] = args.destName
		if self:IsInCombat() then--only start cd timer on boss fight, not when trash does it.
			timerToxicLinkCD:Start()
		end	
		if args:IsPlayer() then
			specWarnToxicLink:Show()
			specWarnToxicLink:Play("gather")
		end
		if self.Options.SetIconOnToxicLink then
			self:SetIcon(args.destName, self.vb.toxicLinkIcon, 10)
		end
		self.vb.toxicLinkIcon = self.vb.toxicLinkIcon - 1
		self:Unschedule(warnToxicLinkTargets)
		self:Schedule(0.2, warnToxicLinkTargets, self)
	elseif args.spellId == 96509 then
		warnBreathHethiss:Show()
		timerBreathHethiss:Start()
	elseif args.spellId == 96512 then
		warnBlessing:Show()
	elseif args.spellId == 96466 and args:IsDestTypePlayer() then
		timerWhisperHethiss:Start(args.destName)
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnWhisperHethiss:Show(args.sourceName)
			specWarnWhisperHethiss:Play("kickcast")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 96466 then
		timerWhisperHethiss:Cancel(args.destName)
	elseif args.spellId == 96477 then
		if self.Options.SetIconOnToxicLink then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96842 then
		specWarnBloodvenom:Show()
		specWarnBloodvenom:Play("runaway")
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 96685 and self:AntiSpam(3, 1) and destGUID == UnitGUID("player") then
		specWarnEffusion:Show()
		specWarnEffusion:Play("watchfeet")
	elseif spellId == 96521 and self:AntiSpam(3, 2) and destGUID == UnitGUID("player") then
		specWarnPoolAcridTears:Show()
		specWarnPoolAcridTears:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

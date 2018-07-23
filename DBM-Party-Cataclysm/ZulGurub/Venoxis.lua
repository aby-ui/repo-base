local mod	= DBM:NewMod(175, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(52155)
mod:SetEncounterID(1178)
mod:SetZone()
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START"
)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)
mod.onlyHeroic = true

local warnWordHethiss		= mod:NewSpellAnnounce(96560, 2)
local warnWhisperHethiss	= mod:NewTargetAnnounce(96466, 3)
local warnBreathHethiss		= mod:NewSpellAnnounce(96509, 3)
local warnToxicLink			= mod:NewTargetAnnounce(96477, 4)
local warnBlessing			= mod:NewSpellAnnounce(96512, 3)
local warnBloodvenom		= mod:NewSpellAnnounce(96842, 3)

local timerWhisperHethiss	= mod:NewTargetTimer(8, 96466)
local timerBreathHethiss	= mod:NewNextTimer(12, 96509)
local timerToxicLinkCD		= mod:NewNextTimer(14, 96477)--13-15 second variations, 14 will be a good medium

local specWarnWhisperHethiss= mod:NewSpecialWarningInterrupt(96466, "-Healer")
local specWarnToxicLink		= mod:NewSpecialWarningYou(96477)
local specWarnBloodvenom	= mod:NewSpecialWarningSpell(96842, nil, nil, nil, 2)
local specWarnPoolAcridTears= mod:NewSpecialWarningMove(96521)
local specWarnEffusion		= mod:NewSpecialWarningMove(96680)

mod:AddBoolOption("SetIconOnToxicLink")
mod:AddBoolOption("LinkArrow")

local toxicLinkIcon = 8
local toxicLinkTargets = {}

local function warnToxicLinkTargets()
	warnToxicLink:Show(table.concat(toxicLinkTargets, "<, >"))
	table.wipe(toxicLinkTargets)
	toxicLinkIcon = 8	
end

function mod:OnCombatStart(delay)
	timerToxicLinkCD:Start(12-delay)
	toxicLinkIcon = 8
	table.wipe(toxicLinkTargets)
	if not self:IsTrivial(90) then--Only warning that uses these events is remorseless winter and that warning is completely useless spam for level 90s.
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE",
			"SPELL_MISSED"
		)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96477 then
		toxicLinkTargets[#toxicLinkTargets + 1] = args.destName
		if self:IsInCombat() then--only start cd timer on boss fight, not when trash does it.
			timerToxicLinkCD:Start()
		end
		if self.Options.LinkArrow and #toxicLinkTargets == 2 then
			if toxicLinkTargets[1] == UnitName("player") then
				DBM.Arrow:ShowRunAway(toxicLinkTargets[2])
			elseif toxicLinkTargets[2] == UnitName("player") then
				DBM.Arrow:ShowRunAway(toxicLinkTargets[1])
			end
		end		
		if args:IsPlayer() then
			specWarnToxicLink:Show()
		end
		if self.Options.SetIconOnToxicLink then
			self:SetIcon(args.destName, toxicLinkIcon, 10)
			toxicLinkIcon = toxicLinkIcon - 1
		end
		self:Unschedule(warnToxicLinkTargets)
		self:Schedule(0.2, warnToxicLinkTargets)
	elseif args.spellId == 96509 then
		warnBreathHethiss:Show()
		timerBreathHethiss:Start()
	elseif args.spellId == 96512 then
		warnBlessing:Show()
	elseif args.spellId == 96466 and args:IsDestTypePlayer() then
		warnWhisperHethiss:Show(args.destName)
		timerWhisperHethiss:Start(args.destName)
		specWarnWhisperHethiss:Show(args.sourceName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 96466 then
		timerWhisperHethiss:Cancel(args.destName)
	elseif args.spellId == 96477 then
		DBM.Arrow:Hide()
		if self.Options.SetIconOnToxicLink then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96842 then
		warnBloodvenom:Show()
		specWarnBloodvenom:Show()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 96685 and self:AntiSpam(3, 1) and destGUID == UnitGUID("player") then
		specWarnEffusion:Show()
	elseif spellId == 96521 and self:AntiSpam(3, 2) and destGUID == UnitGUID("player") then
		specWarnPoolAcridTears:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

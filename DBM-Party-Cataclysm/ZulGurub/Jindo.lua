local mod	= DBM:NewMod(185, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(52148)
mod:SetEncounterID(1182)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 97172 97320 97597",
	"SPELL_AURA_REMOVED 97417",
	"SPELL_AURA_REMOVED_DOSE 97417",
	"SPELL_CAST_START 97172 97158",
	"SPELL_CAST_SUCCESS 97170"
)
mod.onlyHeroic = true

local warnDeadzone				= mod:NewSpellAnnounce(97170, 3)
local warnShadowsOfHakkar		= mod:NewCastAnnounce(97172, 4)
local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnBarrierDown			= mod:NewAnnounce("WarnBarrierDown", 2)
local warnBodySlam				= mod:NewTargetNoFilterAnnounce(97198, 2)

local specWarnShadow			= mod:NewSpecialWarningMoveTo(97172, nil, nil, nil, 2, 2)
local specWarnBodySlam			= mod:NewSpecialWarningYou(97198, nil, nil, nil, 1, 2)
local specWarnSunderRift		= mod:NewSpecialWarningMove(97320, nil, nil, nil, 1, 2)

local timerDeadzone				= mod:NewNextTimer(21, 97170, nil, nil, nil, 3)
local timerShadowsOfHakkar		= mod:NewBuffActiveTimer(10, 97172, nil, nil, nil, 2)
local timerShadowsOfHakkarNext	= mod:NewNextTimer(21, 97172, nil, nil, nil, 2)

mod:AddSetIconOption("BodySlamIcon", 97597, true, false, {8})

mod.vb.phase = 1
mod.vb.barrier = 3
local zoneName = DBM:GetSpellInfo(97170)

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.barrier = 3
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 97172 then
		specWarnShadow:Show(zoneName)
		specWarnShadow:Play("findshelter")
		timerShadowsOfHakkar:Start()
		timerShadowsOfHakkarNext:Start()
	elseif args.spellId == 97320 and args:IsPlayer() then
		specWarnSunderRift:Show()
		specWarnSunderRift:Play("watchfeet")
	elseif args.spellId == 97597 then
		if args:IsPlayer() then
			specWarnBodySlam:Show()
			specWarnBodySlam:Play("targetyou")
		else
			warnBodySlam:Show(args.destName)
		end
		if self.Options.BodySlamIcon then
			self:SetIcon(args.destName, 8, 2)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 97417 then
		self.vb.barrier = self.vb.barrier - 1
		warnBarrierDown:Show(self.vb.barrier)
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

function mod:SPELL_CAST_START(args)
	if args.spellId == 97172 then
		warnShadowsOfHakkar:Show()
	elseif args.spellId == 97158 and self.vb.phase < 2 then
		self.vb.phase = 2
		warnPhase2:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 97170 then
		warnDeadzone:Show()
		timerDeadzone:Start()
	end
end

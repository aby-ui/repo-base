local mod	= DBM:NewMod(176, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()
local Ohgan	= DBM:EJ_GetSectionInfo(2615)

mod:SetRevision("20190421035925")
mod:SetCreatureID(52151)
mod:SetEncounterID(1179)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 96776 96800",
	"SPELL_CAST_START 96484 96740 96724",
	"SPELL_CAST_SUCCESS 96684",
	"SPELL_HEAL 96724",
	"UNIT_DIED"
)
mod.onlyHeroic = true

local warnDecapitate		= mod:NewTargetAnnounce(96684, 2)
local warnBloodletting		= mod:NewTargetAnnounce(96776, 3)
local warnOhgan				= mod:NewSpellAnnounce(96724, 4)
local warnFrenzy			= mod:NewSpellAnnounce(96800, 3)
local warnRevive 			= mod:NewAnnounce("WarnRevive", 2, 96484, false)

local specWarnSlam			= mod:NewSpecialWarningDodge(96740, nil, nil, nil, 1, 2)
local specWarnOhgan			= mod:NewSpecialWarning("SpecWarnOhgan", nil, nil, nil, 1, 2)

local timerSummonOhgan		= mod:NewNextTimer(20, 96717, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--Engage only
local timerResOhgan			= mod:NewCDTimer(40, 96724, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--rez cd
local timerDecapitate		= mod:NewNextTimer(35, 96684, nil, nil, nil, 3)
local timerBloodletting		= mod:NewTargetTimer(10, 96776, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerBloodlettingCD	= mod:NewCDTimer(25, 96776, nil, nil, nil, 3)
local timerOhgan			= mod:NewCastTimer(2.5, 96724, nil, nil, nil, 1)

mod:AddSetIconOption("SetIconOnOhgan", 96717, false, true, {8})

mod.vb.reviveCounter = 8
mod.vb.ohganDiedOnce = false

function mod:OnCombatStart(delay)
	self.vb.reviveCounter = 8
	self.vb.ohganDiedOnce = false
	timerSummonOhgan:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96776 then
		warnBloodletting:Show(args.destName)
		timerBloodletting:Start(args.destName)
		timerBloodlettingCD:Start()
	elseif args.spellId == 96800 then
		warnFrenzy:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96484 then
		self.vb.reviveCounter = self.vb.reviveCounter - 1
		warnRevive:Show(self.vb.reviveCounter)
	elseif args.spellId == 96740 then
		specWarnSlam:Show()
		specWarnSlam:Play("shockwave")
	elseif args.spellId == 96724 then
		warnOhgan:Show()
		timerOhgan:Start()
		timerResOhgan:Start()--We start Cd here cause this is how it works. if it comes off CD while he's alive, then if he dies, he is rezed instantly
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 96684 then
		warnDecapitate:Show(args.destName)
		timerDecapitate:Start()
	end
end

function mod:SPELL_HEAL(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 96724 then
		specWarnOhgan:Show()
		specWarnOhgan:Play("bigmob")
		if self.Options.SetIconOnOhgan then
			self:ScanForMobs(destGUID, 0, 8, 1, 0.1, 10, "SetIconOnOhgan")
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.sourceGUID)
	if cid == 52156 then
		self.vb.reviveCounter = self.vb.reviveCounter - 1
		warnRevive:Show(self.vb.reviveCounter)
	elseif cid == 52157 and not self.vb.ohganDiedOnce then
		self.vb.ohganDiedOnce = true
		timerResOhgan:Start(20)--First time he dies, res isn't on CD yet, but he won't use it for 20 seconds.
	end
end

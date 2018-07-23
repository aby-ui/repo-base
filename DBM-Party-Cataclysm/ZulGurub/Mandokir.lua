local mod	= DBM:NewMod(176, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()
local Ohgan	= DBM:EJ_GetSectionInfo(2615)

mod:SetRevision(("$Revision: 185 $"):sub(12, -3))
mod:SetCreatureID(52151)
mod:SetEncounterID(1179)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_HEAL",
	"UNIT_DIED"
)
mod.onlyHeroic = true

local warnDecapitate		= mod:NewTargetAnnounce(96684, 2)
local warnBloodletting		= mod:NewTargetAnnounce(96776, 3)
local warnSlam				= mod:NewSpellAnnounce(96740, 4)
local warnOhgan				= mod:NewSpellAnnounce(96724, 4)
local warnFrenzy			= mod:NewSpellAnnounce(96800, 3)
local warnRevive 			= mod:NewAnnounce("WarnRevive", 2, 96484, false)

local timerSummonOhgan		= mod:NewNextTimer(20, 96717)--Engage only
local timerResOhgan			= mod:NewCDTimer(40, 96724)--rez cd
local timerDecapitate		= mod:NewNextTimer(35, 96684)
local timerBloodletting		= mod:NewTargetTimer(10, 96776)
local timerBloodlettingCD	= mod:NewCDTimer(25, 96776)
local timerSlam				= mod:NewCastTimer(2, 96740)
local timerOhgan			= mod:NewCastTimer(2.5, 96724)

local specWarnSlam			= mod:NewSpecialWarningSpell(96740)
local specWarnOhgan			= mod:NewSpecialWarning("SpecWarnOhgan")

mod:AddSetIconOption("SetIconOnOhgan", 96717, false, true)

local reviveCounter = 8
local ohganDiedOnce = false

function mod:OnCombatStart(delay)
	reviveCounter = 8
	ohganDiedOnce = false
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
		reviveCounter = reviveCounter - 1
		warnRevive:Show(reviveCounter)
	elseif args.spellId == 96740 then
		warnSlam:Show()
		specWarnSlam:Show()
		timerSlam:Start()
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
		if self.Options.SetIconOnOhgan then
			self:ScanForMobs(destGUID, 0, 8, 1, 0.1, 10, "SetIconOnOhgan")
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.sourceGUID)
	if cid == 52156 then
		reviveCounter = reviveCounter - 1
		warnRevive:Show(reviveCounter)
	elseif cid == 52157 and not ohganDiedOnce then
		ohganDiedOnce = true
		timerResOhgan:Start(20)--First time he dies, res isn't on CD yet, but he won't use it for 20 seconds.
	end
end

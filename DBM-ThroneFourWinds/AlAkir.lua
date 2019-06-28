local mod	= DBM:NewMod(155, "DBM-ThroneFourWinds", nil, 75)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(46753)
mod:SetEncounterID(1034)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--Classes that can drop stacks of acid rain, but only if they can time AMS/bubble right, they use it wrong and they do no good.
local isDKorPaly	= select(2, UnitClass("player")) == "DEATHKNIGHT"
					or select(2, UnitClass("player")) == "PALADIN"

local warnIceStorm			= mod:NewSpellAnnounce(88239, 3)
local warnSquallLine		= mod:NewSpellAnnounce(91129, 4)
local warnWindBurst			= mod:NewSpellAnnounce(87770, 3)
local warnAdd				= mod:NewSpellAnnounce(88272, 2)
local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnAcidRain			= mod:NewCountAnnounce(88301, 2, nil, false)
local warnFeedback			= mod:NewStackAnnounce(87904, 2)
local warnPhase3			= mod:NewPhaseAnnounce(3)
local warnCloud				= mod:NewSpellAnnounce(89588, 3)
local warnLightningRod		= mod:NewTargetAnnounce(89668, 4)

local specWarnWindBurst		= mod:NewSpecialWarningSpell(87770, nil, nil, nil, 2)
local specWarnIceStorm		= mod:NewSpecialWarningMove(91020)
local specWarnCloud			= mod:NewSpecialWarningMove(89588)
local specWarnLightningRod	= mod:NewSpecialWarningMoveAway(89668)
local yellLightningRod		= mod:NewYell(89668)

local timerWindBurst		= mod:NewCastTimer(5, 87770, nil, nil, nil, 2)
local timerWindBurstCD		= mod:NewCDTimer(25, 87770, nil, nil, nil, 2)		-- 25-30 Variation
local timerAddCD			= mod:NewCDTimer(20, 88272, nil, nil, nil, 1)
local timerFeedback			= mod:NewTimer(20, "TimerFeedback", 87904, nil, nil, 5, DBM_CORE_DAMAGE_ICON)
local timerAcidRainStack	= mod:NewNextTimer(15, 88301, nil, isDKorPaly)
local timerLightningRod		= mod:NewTargetTimer(5, 89668, nil, false)
local timerLightningRodCD	= mod:NewNextTimer(15, 89668, nil, nil, nil, 3)
local timerLightningCloudCD	= mod:NewNextTimer(15, 89588, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)
local timerIceStormCD		= mod:NewCDTimer(25, 88239, nil, nil, nil, 3)
local timerSquallLineCD		= mod:NewCDTimer(20, 91129, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)

local berserkTimer			= mod:NewBerserkTimer(600)

mod:AddBoolOption("LightningRodIcon")
mod:AddBoolOption("RangeFrame", true)

local phase2Started = false
local strikeStarted = false

function mod:CloudRepeat()
	self:UnscheduleMethod("CloudRepeat")
	warnCloud:Show()
	if self:IsInCombat() then--Don't schedule if not in combat, prevent an infinite loop from happening if for some reason one got scheduled exactly on boss death.
		if self:IsDifficulty("heroic10", "heroic25") then
			timerLightningCloudCD:Start(10)
			self:ScheduleMethod(10, "CloudRepeat")
		else
			timerLightningCloudCD:Start()
			self:ScheduleMethod(15, "CloudRepeat")
		end
	end
end

function mod:OnCombatStart(delay)
	phase2Started = false
	strikeStarted = false
	berserkTimer:Start(-delay)
	timerWindBurstCD:Start(20-delay)
	timerIceStormCD:Start(6-delay)
	--Only needed in phase 1
	self:RegisterShortTermEvents(
		"SPELL_PERIODIC_DAMAGE",
		"SPELL_PERIODIC_MISSED"
	)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 87904 then
		warnFeedback:Show(args.destName, args.amount or 1)
		timerFeedback:Cancel()--prevent multiple timers spawning with diff args.
		if self:IsDifficulty("normal10", "normal25") then
			timerFeedback:Start(30, args.amount or 1)
		else
			timerFeedback:Start(20, args.amount or 1)
		end
	elseif args.spellId == 88301 then--Acid Rain (phase 2 debuff)
		if args.amount and args.amount > 1 and args:IsPlayer() then
			warnAcidRain:Show(args.amount)
		end
	elseif args.spellId == 89668 then
		warnLightningRod:Show(args.destName)
		timerLightningRod:Show(args.destName)
		timerLightningRodCD:Start()
		if args:IsPlayer() then
			specWarnLightningRod:Show()
			yellLightningRod:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(20)
			end
		end
		if self.Options.LightningRodIcon then
			self:SetIcon(args.destName, 8, 5)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 89668 then
		timerLightningRod:Cancel(args.destName)
		if self.Options.LightningRodIcon then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 87770 then--Phase 1 wind burst
		specWarnWindBurst:Show()
		timerWindBurstCD:Start()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerWindBurst:Start(4)
		else
			timerWindBurst:Start()
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 88858 and self:AntiSpam(5, 1) then--Phase 3 wind burst, does not use cast success
		warnWindBurst:Show()
		timerWindBurstCD:Start(20)
	elseif spellId == 89588 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then--Phase 3 Clouds
		specWarnCloud:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 91020 and destGUID == UnitGUID("player") and self:AntiSpam(4, 1) then--Phase 1 Ice Storm
		specWarnIceStorm:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 91129 and self:AntiSpam(2, 3) then -- Squall Line (Tornados)
		warnSquallLine:Show()
		if not phase2Started then
			timerSquallLineCD:Start(30)--Seems like a longer CD in phase 1? That or had some electrocute and windburst delays, need more data.
		else
			timerSquallLineCD:Start()
		end
	elseif spellId == 88239 and self:AntiSpam(2, 4) then -- Ice Storm (Phase 1)
		warnIceStorm:Show()
		timerIceStormCD:Start()
	elseif spellId == 88272 and self:AntiSpam(2, 4) then -- Summon Stormling (Phase 2 add)
		warnAdd:Show()
		timerAddCD:Start()
	elseif spellId == 88290 and self:AntiSpam(2, 5) then -- Acid Rain
		if self:IsDifficulty("normal10", "normal25") then
			timerAcidRainStack:Start(20)
		else
			timerAcidRainStack:Start()
		end
		if not phase2Started then
			phase2Started = true
			warnPhase2:Show()
			timerWindBurstCD:Cancel()
			timerIceStormCD:Cancel()
			self:UnregisterShortTermEvents()
		end
	elseif spellId == 89528 and self:AntiSpam(2, 6) then -- Relentless Storm Initial Vehicle Ride Trigger (phase 3 start trigger)
		warnPhase3:Show()
		timerLightningCloudCD:Start(15.5)
		timerWindBurstCD:Start(25)
		timerLightningRodCD:Start(20)
		timerAddCD:Cancel()
		timerSquallLineCD:Cancel()
		timerAcidRainStack:Cancel()
	elseif spellId == 89639 and self:AntiSpam(2, 3) then -- Phase 3 Lightning cloud trigger (only cast once)
		self:CloudRepeat()
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE",
			"SPELL_MISSED"
		)
	end
end

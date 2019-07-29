local mod	= DBM:NewMod("Halion", "DBM-ChamberOfAspects", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(39863)--40142 (twilight form)
mod:SetEncounterID(1150)
mod:SetModelID(31952)
mod:SetUsedIcons(7, 8)
--mod:SetMinSyncRevision(4358)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("combat")
--mod:RegisterKill("yell", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"CHAT_MSG_MONSTER_YELL",
	"RAID_BOSS_EMOTE",
	"UNIT_HEALTH boss1"
)

local warnPhase2Soon				= mod:NewPrePhaseAnnounce(2)
local warnPhase3Soon				= mod:NewPrePhaseAnnounce(3)
local warnPhase2					= mod:NewPhaseAnnounce(2)
local warnPhase3					= mod:NewPhaseAnnounce(3)
local warningShadowConsumption		= mod:NewTargetAnnounce(74792, 4)
local warningFieryCombustion		= mod:NewTargetAnnounce(74562, 4)
local warningMeteor					= mod:NewSpellAnnounce(74648, 3)
local warningShadowBreath			= mod:NewSpellAnnounce(74806, 2, nil, "Tank|Healer")
local warningFieryBreath			= mod:NewSpellAnnounce(74525, 2, nil, "Tank|Healer")
local warningTwilightCutter			= mod:NewAnnounce("TwilightCutterCast", 4, 74769)

local specWarnShadowConsumption		= mod:NewSpecialWarningRun(74792, nil, nil, nil, 4, 2)
local yellShadowconsumption			= mod:NewYell(74792)
local specWarnFieryCombustion		= mod:NewSpecialWarningRun(74562, nil, nil, nil, 4, 2)
local yellFieryCombustion			= mod:NewYell(74562)
local specWarnMeteorStrike			= mod:NewSpecialWarningMove(74648, nil, nil, nil, 1, 2)
local specWarnTwilightCutter		= mod:NewSpecialWarningSpell(74769, nil, nil, nil, 3, 2)

local timerShadowConsumptionCD		= mod:NewNextTimer(25, 74792, nil, nil, nil, 3)
local timerFieryConsumptionCD		= mod:NewNextTimer(25, 74562, nil, nil, nil, 3)
local timerMeteorCD					= mod:NewNextTimer(40, 74648, nil, nil, nil, 3)--Target or aoe? tough call. It's a targeted aoe!
local timerMeteorCast				= mod:NewCastTimer(7, 74648)--7-8 seconds from boss yell the meteor impacts.
local timerTwilightCutterCast		= mod:NewCastTimer(5, 74769)
local timerTwilightCutter			= mod:NewBuffActiveTimer(10, 74769, nil, nil, nil, 6)
local timerTwilightCutterCD			= mod:NewNextTimer(15, 74769, nil, nil, nil, 6)
local timerShadowBreathCD			= mod:NewCDTimer(19, 74806, nil, "Tank|Healer", nil, 5)--Same as debuff timers, same CD, can be merged into 1.
local timerFieryBreathCD			= mod:NewCDTimer(19, 74525, nil, "Tank|Healer", nil, 5)--But unique icons are nice pertaining to phase you're in ;)

local berserkTimer					= mod:NewBerserkTimer(480)

mod:AddBoolOption("AnnounceAlternatePhase", true, "announce")
mod:AddBoolOption("SetIconOnConsumption", true)

mod.vb.warned_preP2 = false
mod.vb.warned_preP3 = false
mod.vb.phase = 1
local phases = {}

function mod:OnCombatStart(delay)--These may still need retuning too, log i had didn't have pull time though.
	table.wipe(phases)
	self.vb.warned_preP2 = false
	self.vb.warned_preP3 = false
	self.vb.phase = 1
	berserkTimer:Start(-delay)
	timerMeteorCD:Start(20-delay)
	timerFieryConsumptionCD:Start(15-delay)
	timerFieryBreathCD:Start(10-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 74806 then
		warningShadowBreath:Show()
		timerShadowBreathCD:Start()
	elseif args.spellId == 74525 then
		warningFieryBreath:Show()
		timerFieryBreathCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)--We use spell cast success for debuff timers in case it gets resisted by a player we still get CD timer for next one
	if args.spellId == 74792 then
		if self:IsDifficulty("heroic10", "heroic25") then
			timerShadowConsumptionCD:Start(20)
		else
			timerShadowConsumptionCD:Start()
		end
		if self:LatencyCheck() then
			self:SendSync("ShadowCD")
		end
	elseif args.spellId == 74562 then
		if self:IsDifficulty("heroic10", "heroic25") then
			timerFieryConsumptionCD:Start(20)
		else
			timerFieryConsumptionCD:Start()
		end
		if self:LatencyCheck() then
			self:SendSync("FieryCD")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)--We don't use spell cast success for actual debuff on >player< warnings since it has a chance to be resisted.
	if args.spellId == 74792 then
		if self:LatencyCheck() then
			self:SendSync("ShadowTarget", args.destName)
		end
		if args:IsPlayer() then
			specWarnShadowConsumption:Show()
			specWarnShadowConsumption:Play("runout")
			yellShadowconsumption:Yell()
		end
		if not self.Options.AnnounceAlternatePhase then
			warningShadowConsumption:Show(args.destName)
		end
		if self.Options.SetIconOnConsumption then
			self:SetIcon(args.destName, 7)
		end
	elseif args.spellId == 74562 then
		if self:LatencyCheck() then
			self:SendSync("FieryTarget", args.destName)
		end
		if args:IsPlayer() then
			specWarnFieryCombustion:Show()
			specWarnFieryCombustion:Play("runout")
			yellFieryCombustion:Yell()
		end
		if not self.Options.AnnounceAlternatePhase then
			warningFieryCombustion:Show(args.destName)
		end
		if self.Options.SetIconOnConsumption then
			self:SetIcon(args.destName, 8)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 74792 then
		if self.Options.SetIconOnConsumption then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 74562 then
		if self.Options.SetIconOnConsumption then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if (spellId == 74712 or spellId == 74717) and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnMeteorStrike:Show()
		specWarnMeteorStrike:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_HEALTH(uId)
	if not self.vb.warned_preP2 and self:GetUnitCreatureId(uId) == 39863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.79 then
		self.vb.warned_preP2 = true
		warnPhase2Soon:Show()	
	elseif not self.vb.warned_preP3 and self:GetUnitCreatureId(uId) == 40142 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.54 then
		self.vb.warned_preP3 = true
		warnPhase3Soon:Show()	
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2 or msg:find(L.Phase2) then
		self:SendSync("Phase2")
	elseif msg == L.Phase3 or msg:find(L.Phase3) then
		self:SendSync("Phase3")
	elseif msg == L.MeteorCast or msg:find(L.MeteorCast) then--There is no CLEU cast trigger for meteor, only yell
		if not self.Options.AnnounceAlternatePhase then
			warningMeteor:Show()
			timerMeteorCast:Start()--7 seconds from boss yell the meteor impacts.
			timerMeteorCD:Start()
		end
		if self:LatencyCheck() then
			self:SendSync("Meteor")
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.twilightcutter or msg:find(L.twilightcutter) then
			specWarnTwilightCutter:Schedule(5)
			specWarnTwilightCutter:ScheduleVoice(5, "farfromline")
		if not self.Options.AnnounceAlternatePhase then
			timerTwilightCutterCD:Cancel()
			warningTwilightCutter:Show()
			timerTwilightCutterCast:Start()
			timerTwilightCutter:Schedule(5)--Delay it since it happens 5 seconds after the emote
			timerTwilightCutterCD:Schedule(15)
		end
		if self:LatencyCheck() then
			self:SendSync("TwilightCutter")
		end
	end
end

function mod:OnSync(msg, target)
	if msg == "TwilightCutter" then
		if self.Options.AnnounceAlternatePhase then
			timerTwilightCutterCD:Cancel()
			warningTwilightCutter:Show()
			timerTwilightCutterCast:Start()
			timerTwilightCutter:Schedule(5)--Delay it since it happens 5 seconds after the emote
			timerTwilightCutterCD:Schedule(15)
		end
	elseif msg == "Meteor" then
		if self.Options.AnnounceAlternatePhase then
			warningMeteor:Show()
			timerMeteorCast:Start()
			timerMeteorCD:Start()
		end
	elseif msg == "ShadowTarget" then
		if self.Options.AnnounceAlternatePhase then
			warningShadowConsumption:Show(target)
		end
	elseif msg == "FieryTarget" then
		if self.Options.AnnounceAlternatePhase then
			warningFieryCombustion:Show(target)
		end
	elseif msg == "ShadowCD" then
		if self.Options.AnnounceAlternatePhase then
			if self:IsDifficulty("heroic10", "heroic25") then
				timerShadowConsumptionCD:Start(20)
			else
				timerShadowConsumptionCD:Start()
			end
		end
	elseif msg == "FieryCD" then
		if self.Options.AnnounceAlternatePhase then
			if self:IsDifficulty("heroic10", "heroic25") then
				timerFieryConsumptionCD:Start(20)
			else
				timerFieryConsumptionCD:Start()
			end
		end
	elseif msg == "Phase2" and self.vb.phase < 2 then
		self.vb.phase = 2
		timerFieryBreathCD:Cancel()
		timerMeteorCD:Cancel()
		timerFieryConsumptionCD:Cancel()
		warnPhase2:Show()
		timerShadowBreathCD:Start(25)
		timerShadowConsumptionCD:Start(20)--not exact, 15 seconds from tank aggro, but easier to add 5 seconds to it as a estimate timer than trying to detect this
		timerTwilightCutterCD:Start(35)
	elseif msg == "Phase3" and self.vb.phase < 3 then
		self.vb.phase = 3
		warnPhase3:Show()
		timerMeteorCD:Start(30) --These i'm not sure if they start regardless of drake aggro, or if it varies as well.
		timerFieryConsumptionCD:Start(20)--not exact, 15 seconds from tank aggro, but easier to add 5 seconds to it as a estimate timer than trying to detect this
	end
end

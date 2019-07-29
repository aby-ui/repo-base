local mod	= DBM:NewMod("Jaraxxus", "DBM-Coliseum")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(34780)
mod:SetEncounterID(1087)
mod:SetModelID(29615)
mod:SetMinCombatTime(30)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)

local warnPortalSoon			= mod:NewSoonAnnounce(66269, 3)
local warnVolcanoSoon			= mod:NewSoonAnnounce(66258, 3)
local warnFlame					= mod:NewTargetAnnounce(66197, 4)
local warnFlesh					= mod:NewTargetAnnounce(66237, 4, nil, "Healer")

local specWarnFlame				= mod:NewSpecialWarningRun(66877, nil, nil, 2, 4, 2)
local specWarnFlameGTFO			= mod:NewSpecialWarningMove(66877, nil, nil, 2, 4, 2)
local specWarnFlesh				= mod:NewSpecialWarningYou(66237, nil, nil, nil, 1, 2)
local specWarnKiss				= mod:NewSpecialWarningCast(66334, "SpellCaster", nil, 2, 1, 2)
local specWarnNetherPower		= mod:NewSpecialWarningDispel(67009, "MagicDispeller", nil, nil, 1, 2)
local specWarnFelInferno		= mod:NewSpecialWarningMove(66496, nil, nil, nil, 1, 2)
local SpecWarnFelFireball		= mod:NewSpecialWarningInterrupt(66532, "HasInterrupt", nil, 2, 1, 2)
local SpecWarnFelFireballDispel	= mod:NewSpecialWarningDispel(66532, false, nil, 2, 1, 2)

local timerCombatStart			= mod:NewCombatTimer(82)--rollplay for first pull
local timerFlame 				= mod:NewTargetTimer(8, 66197, nil, nil, nil, 3)--There are 8 debuff Ids. Since we detect first to warn, use an 8sec timer to cover duration of trigger spell and damage debuff.
local timerFlameCD				= mod:NewCDTimer(30, 66197, nil, nil, nil, 3)
local timerNetherPowerCD		= mod:NewCDTimer(42, 67009, nil, "MagicDispeller", nil, 5, nil, DBM_CORE_MAGIC_ICON)
local timerFlesh				= mod:NewTargetTimer(12, 66237, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON)
local timerFleshCD				= mod:NewCDTimer(23, 66237, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON) 
local timerPortalCD				= mod:NewCDTimer(120, 66269, nil, nil, nil, 1)
local timerVolcanoCD			= mod:NewCDTimer(120, 66258, nil, nil, nil, 1)

local enrageTimer				= mod:NewBerserkTimer(600)

mod:AddSetIconOption("LegionFlameIcon", 66197)
mod:AddSetIconOption("IncinerateFleshIcon", 66237)
mod:AddInfoFrameOption(66237, true)

mod.vb.fleshCount = 0

function mod:OnCombatStart(delay)
	self.vb.fleshCount = 0
	timerPortalCD:Start(20-delay)
	warnPortalSoon:Schedule(15-delay)
	timerVolcanoCD:Start(80-delay)
	warnVolcanoSoon:Schedule(75-delay)
	timerFleshCD:Start(14-delay)
	timerFlameCD:Start(20-delay)
	enrageTimer:Start(-delay)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 66877 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then
		specWarnFlameGTFO:Show()
		specWarnFlameGTFO:Play("runaway")
	elseif spellId == 66496 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnFelInferno:Show()
		specWarnFelInferno:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66237 then
		self.vb.fleshCount = self.vb.fleshCount + 1
		timerFlesh:Start(args.destName)
		timerFleshCD:Start()
		if self.Options.IncinerateFleshIcon then
			self:SetIcon(args.destName, 8, 15)
		end
		if args:IsPlayer() then
			specWarnFlesh:Show()
			specWarnFlesh:Play("targetyou")
		else
			warnFlesh:Show(args.destName)
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(6, "playerabsorb", args.spellName, select(16, DBM:UnitDebuff(args.destName, args.spellName)))
		end
	elseif args.spellId == 66197 then
		timerFlame:Start(args.destName)
		timerFlameCD:Start()
		if args:IsPlayer() then
			specWarnFlame:Show()
			specWarnFlame:Play("runout")
			specWarnFlame:SheduleVoice(1.5, "keepmove")
		end
		if self.Options.LegionFlameIcon then
			self:SetIcon(args.destName, 7, 8)
		end
	elseif args.spellId == 66334 and args:IsPlayer() then
		specWarnKiss:Show()
		specWarnKiss:Play("stopcast")
	elseif args.spellId == 66532 then
		SpecWarnFelFireballDispel:Show(args.destName)
		SpecWarnFelFireballDispel:Play("helpdispel")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 66237 then
		self.vb.fleshCount = self.vb.fleshCount - 1
		if self.Options.InfoFrame and self.vb.fleshCount == 0 then
			DBM.InfoFrame:Hide()
		end
		timerFlesh:Stop(args.destName)
		if self.Options.IncinerateFleshIcon then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 66532 and self:CheckInterruptFilter(args.sourceGUID) then
		SpecWarnFelFireball:Show(args.sourceName)
		SpecWarnFelFireball:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 67009 then
		specWarnNetherPower:Show(args.sourceName)
		specWarnNetherPower:Play("dispelboss")
		timerNetherPowerCD:Start()
	elseif args.spellId == 66258 then
		timerVolcanoCD:Start()
		warnVolcanoSoon:Schedule(110)
	elseif args.spellId == 66269 then
		timerPortalCD:Start()
		warnPortalSoon:Schedule(110)
	elseif args.spellId == 66197 then
		warnFlame:Show(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.FirstPull or msg:find(L.FirstPull) then
		timerCombatStart:Start()
	end
end

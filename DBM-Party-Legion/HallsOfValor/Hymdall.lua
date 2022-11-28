local mod	= DBM:NewMod(1485, "DBM-Party-Legion", 4, 721)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128001010")
mod:SetCreatureID(94960)
mod:SetEncounterID(1805)
mod:SetHotfixNoticeRev(20221127000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 191284 193235 193092",
	"SPELL_CAST_SUCCESS 188404",
	"SPELL_PERIODIC_DAMAGE 193234",
	"SPELL_PERIODIC_MISSED 193234"
)

--[[
(ability.id = 191284 or ability.id = 193235 or ability.id = 193092) and type = "begincast"
 or ability.id = 188404 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnBreath					= mod:NewCountAnnounce(193235, 3)
local warnDancingBlade				= mod:NewCountAnnounce(193235, 3)
local warnSweep						= mod:NewSpellAnnounce(193092, 2, nil, "Tank")

local specWarnHornOfValor			= mod:NewSpecialWarningSoon(188404, nil, nil, nil, 2, 2)
local specWarnDancingBlade			= mod:NewSpecialWarningGTFO(193235, nil, nil, nil, 1, 8)
--local yellDancingBlade				= mod:NewYell(193235)

local timerSweepCD					= mod:NewCDTimer(16.9, 193092, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerDancingBladeCD			= mod:NewCDTimer(10, 193235, nil, nil, nil, 3)
local timerHornCD					= mod:NewCDTimer(43.8, 191284, nil, nil, nil, 2)
local timerBreathCast				= mod:NewCastCountTimer(43.8, 191284, nil, nil, nil, 3)

mod.vb.bladeCount = 0
mod.vb.breathCount = 0

function mod:OnCombatStart(delay)
	self.vb.bladeCount = 0
	timerDancingBladeCD:Start(5.2-delay)
	timerHornCD:Start(10.8-delay)
	timerSweepCD:Start(15.7-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 191284 then
		self.vb.breathCount = 0
		specWarnHornOfValor:Show()
		specWarnHornOfValor:Play("breathsoon")
		timerBreathCast:Start(8, 1)
		timerHornCD:Start()
	elseif spellId == 193235 then
		self.vb.bladeCount = self.vb.bladeCount + 1
		warnDancingBlade:Show(self.vb.bladeCount)
		--self:BossTargetScanner(94960, "BladeTarget", 0.1, 20, true, nil, nil, nil, true)
		if self.vb.bladeCount % 2 == 0 then
			timerDancingBladeCD:Start(11.2)
		else
			timerDancingBladeCD:Start(32.5)
		end
	elseif spellId == 188404 then
		self.vb.breathCount = self.vb.breathCount + 1
		warnBreath:Show(self.vb.breathCount)
		if self.vb.breathCount < 3 then
			timerBreathCast:Start(5, self.vb.breathCount+1)
		end
	elseif spellId == 193092 then
		warnSweep:Show()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 188404 and self:AntiSpam(5, 2) then
		warnBreath:Show()
		warnBreath:Play("watchstep")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 193234 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnDancingBlade:Show()
		specWarnDancingBlade:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

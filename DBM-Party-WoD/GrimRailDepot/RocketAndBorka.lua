local mod	= DBM:NewMod(1138, "DBM-Party-WoD", 3, 536)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"
mod.upgradedMPlus = true

mod:SetRevision("20220712012318")
mod:SetCreatureID(77803, 77816)
mod:SetEncounterID(1715)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 162500 162407 161090 162617",
	"SPELL_AURA_APPLIED 163947",
	"UNIT_DIED"
)

local warnVX18B					= mod:NewCountAnnounce(162500, 2)--Cast twice, 3rd cast is X2101, then repeats

local specWarnX2101AMissile		= mod:NewSpecialWarningSpell(162407, nil, nil, nil, 2, 2)--Large AOE damage
local specWarnMadDash			= mod:NewSpecialWarningSpell(161090, nil, nil, nil, 2, 2)--DPS version of this warning
local specWarnMadDashInterrupt	= mod:NewSpecialWarningMoveTo(161090, nil, nil, nil, 3, 1)--It's actually an interrupt warning for OTHER boss, not caster of this spell
local specWarnSlam				= mod:NewSpecialWarningCast(162617, "SpellCaster", nil, nil, 1, 2)

local timerVX18BCD				= mod:NewCDTimer(33, 162500, nil, nil, nil, 3)
local timerX2101AMissileCD		= mod:NewCDTimer(40, 162407, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON..DBM_COMMON_L.TANK_ICON)
local timerMadDashCD			= mod:NewCDTimer(40, 161090, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerSlamCD				= mod:NewCDTimer(15, 162617, nil, "SpellCaster", nil, 5)
local timerSlam					= mod:NewCastTimer(1.5, 162617, nil, "SpellCaster", nil, 5)
local timerRecovering			= mod:NewBuffActiveTimer(6, 163947, nil, nil, nil, 5)

local rocketsName = DBM:EJ_GetSectionInfo(9430)
local borkaID = nil
mod.vb.VXCast = 0
mod.vb.SlamCast = 0

local function getBorkaID(self)
	for i = 1, 2 do
		local uId = "boss"..i
		if self:GetUnitCreatureId(uId) == 77816 then
			borkaID = uId
			return
		end
	end
end

function mod:OnCombatStart(delay)
	borkaID = nil
	self.vb.VXCast = 0
	self.vb.SlamCast = 0
	timerSlamCD:Start(9-delay)
	timerX2101AMissileCD:Start(18.5-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 162500 then
		self.vb.VXCast = self.vb.VXCast + 1
		warnVX18B:Show(self.vb.VXCast)
		if self.vb.VXCast == 2 then
			timerVX18BCD:Start()
		else
			timerVX18BCD:Start(7)
		end
	elseif spellId == 162407 then
		self.vb.VXCast = 0
		specWarnX2101AMissile:Show()
		specWarnX2101AMissile:Play("aesoon")
		timerX2101AMissileCD:Start()
	elseif spellId == 161090 then
		self.vb.SlamCast = 0
		if not borkaID then
			getBorkaID(self)
		end
		if borkaID and self:IsTanking("player", borkaID) then--failsafe 2
			specWarnMadDashInterrupt:Show(rocketsName)
			specWarnMadDashInterrupt:Play("targetyou")--bleh voice choice
		else
			specWarnMadDash:Show()
			specWarnMadDash:Play("farfromline")
		end
		timerMadDashCD:Start()
	elseif spellId == 162617 then
		self.vb.SlamCast = self.vb.SlamCast + 1
		specWarnSlam:Show()
		timerSlam:Start()
		specWarnSlam:Play("stopcast")
		if self.vb.SlamCast == 2 then
			timerSlamCD:Start(30)
		else
			timerSlamCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 163947 then
		local unitid
		for i = 1, 2 do
			if UnitGUID("boss"..i) == args.destGUID then
				unitid = "boss"..i
			end
		end
		if unitid then
			local _, _, _, _, duration, expires, _, _ = DBM:UnitBuff(unitid, args.spellName)
			if expires then
				timerRecovering:Start(expires-GetTime())
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	--Maybe both cancel if either one dies?
	if cid == 77816 then
		timerMadDashCD:Cancel()
	elseif cid == 77803 then
		timerX2101AMissileCD:Cancel()
	end
end

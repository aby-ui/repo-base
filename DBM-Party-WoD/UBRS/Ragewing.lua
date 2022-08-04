local mod	= DBM:NewMod(1229, "DBM-Party-WoD", 8, 559)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200806142123")
mod:SetCreatureID(76585)
mod:SetEncounterID(1760)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 155620 167203",
	"SPELL_AURA_APPLIED_DOSE 155620",
	"SPELL_AURA_REMOVED 167203",
	"SPELL_DAMAGE 155051",
	"SPELL_MISSED 155051",
	"SPELL_PERIODIC_DAMAGE 155057",
	"SPELL_ABSORBED 155057",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnBurningRage		= mod:NewStackAnnounce(155620, 3, nil, "RemoveEnrage|Tank")
local warnSwirlingWinds		= mod:NewSpellAnnounce(167203, 2)
local warnMagmaSpit			= mod:NewTargetNoFilterAnnounce(155051, 3)

local specWarnBurningRage	= mod:NewSpecialWarningDispel(155620, "RemoveEnrage", nil, nil, 1, 2)
local specWarnMagmaSpit		= mod:NewSpecialWarningMove(155051, nil, nil, nil, 1, 8)
local specWarnMagmaSpitYou	= mod:NewSpecialWarningYou(155051, nil, nil, nil, 1, 2)
local yellMagmaSpit			= mod:NewYell(155051)
local specWarnMagmaPool		= mod:NewSpecialWarningMove(155057, nil, nil, nil, 1, 8)
local specWarnEngulfingFire	= mod:NewSpecialWarningDodge(154996, nil, nil, nil, 3, 2)

local timerEngulfingFireCD	= mod:NewCDTimer(24, 154996, nil, nil, nil, 3)
local timerSwirlingWinds	= mod:NewBuffActiveTimer(20, 167203, nil, nil, nil, 6)

mod.vb.firstBreath = false

function mod:MagmaSpitTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnMagmaSpitYou:Show()
		specWarnMagmaSpitYou:Play("targetyou")
		yellMagmaSpit:Yell()
	else
		warnMagmaSpit:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	timerEngulfingFireCD:Start(15-delay)--Needs more data
	self.vb.firstBreath = false
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 155620 then
		warnBurningRage:Show(args.destName, args.amount or 1)
		specWarnBurningRage:Show(args.destName)
		specWarnBurningRage:Play("enrage")
	elseif spellId == 167203 then
		warnSwirlingWinds:Show()
		timerSwirlingWinds:Start()
		timerEngulfingFireCD:Cancel()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 167203 then
		self.vb.firstBreath = false
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 155051 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then--Goriona's Void zones
		specWarnMagmaSpit:Show()
		specWarnMagmaSpit:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 155057 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then--Goriona's Void zones
		specWarnMagmaPool:Show()
		specWarnMagmaPool:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

--This boss actually does fire IEEU so boss1 works
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 154996 then
		specWarnEngulfingFire:Show()
		specWarnEngulfingFire:Play("breathsoon")
		if not self.vb.firstBreath then
			self.vb.firstBreath = true
			timerEngulfingFireCD:Start()
		end
	elseif spellId == 155050 then
		self:BossTargetScanner(76585, "MagmaSpitTarget", 0.05, 10)
	end
end

local mod	= DBM:NewMod("RubyLifePoolsTrash", "DBM-Party-Dragonflight", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230124013307")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 372087 391726 391723 373614 392395 372696 384194 392486 392394 392640 392451 372047",
	"SPELL_AURA_APPLIED 373693 392641 373972 391050",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 373693 391050",
	"UNIT_DIED"
)

--TODO, can Blazing Rush be target scanned? upgrade to special announce?
--[[
(ability.id = 372087 or ability.id = 391726 or ability.id = 391723 or ability.id = 373614 or ability.id = 372696 or ability.id = 392395 or ability.id = 392486 or ability.id = 392394 or ability.id = 392640 or ability.id = 392451 or ability.id = 372047) and type = "begincast"
 or ability.id = 391050 and (type = "applybuff" or type = "removebuff")
--]]
local warnLivingBomb						= mod:NewTargetAnnounce(373693, 3)
local warnBurnout							= mod:NewCastAnnounce(373614, 4)
local warnRollingThunder					= mod:NewTargetNoFilterAnnounce(392641, 3)
local warnFireMaw							= mod:NewCastAnnounce(392394, 3, nil, nil, "Tank|Healer")
local warnSteelBarrage						= mod:NewCastAnnounce(372047, 3, nil, nil, "Tank|Healer")
local warnFlashfire							= mod:NewCastAnnounce(392451, 4)

local specWarnLightningStorm				= mod:NewSpecialWarningSpell(392486, nil, nil, nil, 2, 2)
local specWarnBlazeofGlory					= mod:NewSpecialWarningSpell(373972, nil, nil, nil, 2, 2)
local specWarnTempestStormshield			= mod:NewSpecialWarningSwitch(391050, nil, nil, nil, 1, 2)
local specWarnLivingBomb					= mod:NewSpecialWarningMoveTo(373693, nil, nil, nil, 1, 2)
local yellLivingBomb						= mod:NewShortYell(373693)
local yellLivingBombFades					= mod:NewShortFadesYell(373693)
local specWarnBlazingRush					= mod:NewSpecialWarningDodge(372087, nil, nil, nil, 2, 2)
local specWarnStormBreath					= mod:NewSpecialWarningDodge(391726, nil, nil, nil, 2, 2)
local yellStormBreath						= mod:NewShortYell(391726)
local specWarnFlameBreath					= mod:NewSpecialWarningDodge(391723, nil, nil, nil, 2, 2)
local yellFlameBreath						= mod:NewShortYell(391723)
local specWarnExcavatingBlast				= mod:NewSpecialWarningDodge(372696, nil, nil, nil, 2, 2)
local specWarnBurnout						= mod:NewSpecialWarningRun(373614, "Melee", nil, nil, 4, 2)
local specWarnThunderJaw					= mod:NewSpecialWarningDefensive(392395, nil, nil, nil, 1, 2)
--local specWarnSharedSuffering				= mod:NewSpecialWarningYou(339607, nil, nil, nil, 1, 2)
local specWarnCinderbolt					= mod:NewSpecialWarningInterrupt(384194, "HasInterrupt", nil, nil, 1, 2)
local specWarnFlashfire						= mod:NewSpecialWarningInterrupt(392451, "HasInterrupt", nil, nil, 1, 2)

local timerExcavatingBlastCD				= mod:NewCDTimer(17, 372696, nil, nil, nil, 3)
local timerSteelBarrageCD					= mod:NewCDTimer(17, 372047, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerBlazingRushCD					= mod:NewCDTimer(17, 372087, nil, nil, nil, 3)
local timerStormBreathCD					= mod:NewCDTimer(15.7, 391726, nil, nil, nil, 3)
local timerRollingThunderCD					= mod:NewCDTimer(21.8, 392641, nil, nil, nil, 3)
local timerThunderjawCD						= mod:NewCDTimer(19.4, 392395, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerLightningStormCD					= mod:NewCDTimer(20.6, 392486, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)
local timerFlashfireCD						= mod:NewCDTimer(12.1, 392451, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerTempestStormshieldCD				= mod:NewCDTimer(18.2, 391050, nil, nil, nil, 5, nil, DBM_COMMON_L.DAMAGE_ICON)


--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:StormBreathTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellStormBreath:Yell()
	end
end

function mod:FlameBreathTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellFlameBreath:Yell()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 372087 then
		if self:AntiSpam(3, 2) then
			specWarnBlazingRush:Show()
			specWarnBlazingRush:Play("chargemove")
		end
		timerBlazingRushCD:Start(17, args.sourceGUID)
	elseif spellId == 391726 then
		timerStormBreathCD:Start(15.7)
		if self:AntiSpam(3, 2) then
			specWarnStormBreath:Show()
			specWarnStormBreath:Play("breathsoon")
		end
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "StormBreathTarget", 0.1, 8)
	elseif spellId == 391723 then
		if self:AntiSpam(3, 2) then
			specWarnFlameBreath:Show()
			specWarnFlameBreath:Play("breathsoon")
		end
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "FlameBreathTarget", 0.1, 8)
	elseif spellId == 373614 and self:AntiSpam(3, 1) then
		if self.Options.SpecWarn373614run then
			specWarnBurnout:Show()
			specWarnBurnout:Play("justrun")
		else
			warnBurnout:Show()
		end
	elseif spellId == 372696 then
		timerExcavatingBlastCD:Start(17, args.sourceGUID)
		if self:AntiSpam(3, 2) then
			specWarnExcavatingBlast:Show()
			specWarnExcavatingBlast:Play("watchstep")
		end
	elseif spellId == 392395 then
		timerThunderjawCD:Start()
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnThunderJaw:Show()
			specWarnThunderJaw:Play("carefly")
		end
	elseif spellId == 384194 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnCinderbolt:Show(args.sourceName)
		specWarnCinderbolt:Play("kickcast")
	elseif spellId == 392486 then
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid == 197535 then
			timerLightningStormCD:Start(21.8, args.sourceGUID)
		else
			timerLightningStormCD:Start(20.6, args.sourceGUID)
		end
		if self:AntiSpam(3, 4) then
			specWarnLightningStorm:Show()
			specWarnLightningStorm:Play("aesoon")
		end
	elseif spellId == 392394 then
		if self:AntiSpam(3, 5) then
			warnFireMaw:Show()
		end
	elseif spellId == 392640 then--Rolling Thunder
		timerRollingThunderCD:Start()
	elseif spellId == 392451 then
		timerFlashfireCD:Start(12.1, args.sourceGUID)
		if self.Options.SpecWarn392451interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFlashfire:Show(args.sourceName)
			specWarnFlashfire:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnFlashfire:Show()
		end
	elseif spellId == 372047 then
		timerSteelBarrageCD:Start(17, args.sourceGUID)
		if self:AntiSpam(3, 5) then
			warnSteelBarrage:Show()
		end
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 373693 then
		warnLivingBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnLivingBomb:Show(DBM_COMMON_L.ADDS)
			specWarnLivingBomb:Play("targetyou")
			yellLivingBomb:Yell()
			yellLivingBombFades:Countdown(spellId)
		end
	elseif spellId == 392641 then
		warnRollingThunder:CombinedShow(0.3, args.destName)
	elseif spellId == 373972 and self:AntiSpam(3, 4) then
		specWarnBlazeofGlory:Show()
		specWarnBlazeofGlory:Play("aesoon")
	elseif spellId == 391050 then
		specWarnTempestStormshield:Show()
		specWarnTempestStormshield:Play("attackshield")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 373693 and args:IsPlayer() then
		yellLivingBombFades:Cancel()
	elseif spellId == 391050 then
		timerTempestStormshieldCD:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 188244 then--Primal Juggernaut
		timerExcavatingBlastCD:Stop(args.destGUID)
	elseif cid == 187897 then--Defier Draghar
		timerSteelBarrageCD:Stop(args.destGUID)
		timerBlazingRushCD:Stop(args.destGUID)
	elseif cid == 197698 then--Thunderhead
		timerStormBreathCD:Stop()
		timerRollingThunderCD:Stop()
		timerThunderjawCD:Stop()
	elseif cid == 198047 then--Tempest Channeler
		timerLightningStormCD:Stop(args.destGUID)
	elseif cid == 197985 then--Flame Channeler
		timerFlashfireCD:Stop(args.destGUID)
	elseif cid == 197535 then--High Channeler Ryvati
		timerLightningStormCD:Stop(args.destGUID)
		timerTempestStormshieldCD:Stop()
	end
end

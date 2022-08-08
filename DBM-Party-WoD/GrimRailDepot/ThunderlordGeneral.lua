local mod	= DBM:NewMod(1133, "DBM-Party-WoD", 3, 536)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"
mod.upgradedMPlus = true

mod:SetRevision("20220807021335")
mod:SetCreatureID(80005)
mod:SetEncounterID(1736)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 162066 162058",
	"SPELL_AURA_APPLIED 163447 161588",
	"SPELL_AURA_APPLIED_DOSE 161588",
	"SPELL_AURA_REMOVED 163447",
	"CHAT_MSG_MONSTER_YELL"
)

--[[
(ability.id = 162066 or ability.id = 162058) and type = "begincast"
 or (ability.id = 171900 or ability.id = 163447) and (type = "applybuff" or type = "applydebuff")
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnFreezingSnare			= mod:NewTargetAnnounce(162066, 3)
local warnMark					= mod:NewTargetNoFilterAnnounce(163447, 3)

local specWarnFreezingSnare		= mod:NewSpecialWarningYou(162066, nil, nil, nil, 1, 2)
local specWarnFreezingSnareNear	= mod:NewSpecialWarningClose(162066, nil, nil, nil, 1, 2)
local yellFreezingSnare			= mod:NewYell(162066)
local specWarnDiffusedEnergy	= mod:NewSpecialWarningMove(161588, nil, nil, nil, 1, 8)
local specWarnSpinningSpear		= mod:NewSpecialWarningDodge(162058, nil, nil, 3, 2, 2)
local specWarnMark				= mod:NewSpecialWarningMoveAway(163447, nil, nil, nil, 1, 2)
local yellMark					= mod:NewYell(163447)
local specWarnThunderousBreath	= mod:NewSpecialWarningDodge(171900, nil, nil, nil, 2, 2)

local timerFreezingSnareCD		= mod:NewCDTimer(16.6, 162066, nil, nil, nil, 3)
local timerSpinningSpearCD		= mod:NewCDTimer(17, 162058, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerMark					= mod:NewTargetTimer(5, 163447, nil, nil, nil, 5)
local timerMarkCD				= mod:NewCDTimer(20, 163447, nil, nil, nil, 3)
local timerThunderousBreathCD	= mod:NewCDTimer(17.5, 171900, nil, nil, nil, 3)

mod:AddRangeFrameOption(8, 163447)

local debuffCheck = DBM:GetSpellInfo(163447)
local debuffFilter
do
	debuffFilter = function(uId)
		return DBM:UnitDebuff(uId, debuffCheck)
	end
end

function mod:FreezingSnareTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnFreezingSnare:Show()
		yellFreezingSnare:Yell()
		specWarnFreezingSnare:Play("runaway")
	elseif self:CheckNearby(8, targetname) then
		specWarnFreezingSnareNear:Show(targetname)
		specWarnFreezingSnareNear:Play("watchstep")
	else
		warnFreezingSnare:Show(targetname)
	end
end

--function mod:OnCombatStart(delay)

--end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 162066 then
		self:BossTargetScanner(80005, "FreezingSnareTarget", 0.04, 15)
		timerFreezingSnareCD:Start()
	elseif spellId == 162058 then
		specWarnSpinningSpear:Show()
		specWarnSpinningSpear:Play("shockwave")
		timerSpinningSpearCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 163447 then
		timerMark:Start(args.destName)
		timerMarkCD:Start()
		if args:IsPlayer() then
			specWarnMark:Show()
			specWarnMark:Play("runout")
			yellMark:Yell()
		else
			warnMark:Show(args.destName)
		end
		if self.Options.RangeFrame then
			if DBM:UnitDebuff("player", debuffCheck) then--You have debuff, show everyone
				DBM.RangeCheck:Show(8, nil)
			else--You do not have debuff, only show players who do
				DBM.RangeCheck:Show(8, debuffFilter)
			end
		end
	elseif args.spellId == 161588 and args:IsPlayer() and self:AntiSpam() then
		specWarnDiffusedEnergy:Show()
		specWarnDiffusedEnergy:Play("watchfeet")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 163447 then
		timerMark:Cancel(args.destName)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, _, _, _, target)
	if not self:IsInCombat() then return end
	if target == L.Rakun then
		self:SendSync("Breath")
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "Breath" then
		specWarnThunderousBreath:Show()
		specWarnThunderousBreath:Play("breathsoon")
		timerThunderousBreathCD:Start()
	end
end

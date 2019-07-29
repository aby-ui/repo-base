local mod	= DBM:NewMod("XT002", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(33293)
mod:SetEncounterID(1142)
mod:SetModelID(28611)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62776",
	"SPELL_AURA_APPLIED 62776 63018 65121 63024 64234 63849",
	"SPELL_AURA_REMOVED 63018 65121 63024 64234 63849",
	"SPELL_DAMAGE 64208 64206",
	"SPELL_MISSED 64208 64206"
)

--TODO, figure out TIMEwalker CD for tantrums
--TODO, bomb CD timers?
local warnLightBomb					= mod:NewTargetAnnounce(65121, 3)
local warnGravityBomb				= mod:NewTargetAnnounce(64234, 3)

local specWarnLightBomb				= mod:NewSpecialWarningMoveAway(65121, nil, nil, nil, 1, 2)
local yellLightBomb					= mod:NewYell(65121)
local specWarnGravityBomb			= mod:NewSpecialWarningMoveAway(64234, nil, nil, nil, 1, 2)
local yellGravityBomb				= mod:NewYell(64234)
local specWarnConsumption			= mod:NewSpecialWarningMove(64206, nil, nil, nil, 1, 2)--Hard mode void zone dropped by Gravity Bomb

local enrageTimer					= mod:NewBerserkTimer(600)
local timerTympanicTantrum			= mod:NewBuffActiveTimer(8, 62776, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerTympanicTantrumCD		= mod:NewCDTimer(62, 62776, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerHeart					= mod:NewCastTimer(30, 63849, nil, nil, nil, 6, nil, DBM_CORE_DAMAGE_ICON)
local timerLightBomb				= mod:NewTargetTimer(9, 65121, nil, nil, nil, 3)
local timerGravityBomb				= mod:NewTargetTimer(9, 64234, nil, nil, nil, 3)
local timerAchieve					= mod:NewAchievementTimer(205, 12329)--2937

mod:AddBoolOption("SetIconOnLightBombTarget", true)
mod:AddBoolOption("SetIconOnGravityBombTarget", true)

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	timerAchieve:Start()
	timerTympanicTantrumCD:Start(30-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 62776 then					-- Tympanic Tantrum (aoe damge + daze)
		timerTympanicTantrumCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 62776 then	-- Tympanic Tantrum
		timerTympanicTantrum:Start()
	elseif args:IsSpellID(63018, 65121) then 	-- Light Bomb
		if args:IsPlayer() then
			specWarnLightBomb:Show()
			specWarnLightBomb:Play("runout")
			yellLightBomb:Yell()
		end
		if self.Options.SetIconOnLightBombTarget then
			self:SetIcon(args.destName, 7, 9)
		end
		warnLightBomb:Show(args.destName)
		timerLightBomb:Start(args.destName)
	elseif args:IsSpellID(63024, 64234) then		-- Gravity Bomb
		if args:IsPlayer() then
			specWarnGravityBomb:Show()
			specWarnGravityBomb:Play("runout")
			yellGravityBomb:Yell()
		end
		if self.Options.SetIconOnGravityBombTarget then
			self:SetIcon(args.destName, 8, 9)
		end
		warnGravityBomb:Show(args.destName)
		timerGravityBomb:Start(args.destName)
	elseif args.spellId == 63849 then
		timerHeart:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(63018, 65121) then 	-- Light Bomb
		if self.Options.SetIconOnLightBombTarget then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(63024, 64234) then		-- Gravity Bomb
		if self.Options.SetIconOnGravityBombTarget then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 63849 then
		timerHeart:Stop()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if (spellId == 64208 or spellId == 64206) and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnConsumption:Show()
		specWarnConsumption:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

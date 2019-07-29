local mod	= DBM:NewMod("Hodir", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(32845,32926)
mod:SetEncounterID(1135)
mod:SetModelID(28743)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat_yell", L.Pull)
mod:RegisterKill("yell", L.YellKill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 61968",
	"SPELL_AURA_APPLIED 62478 63512 65123 65133",
	"SPELL_AURA_REMOVED 65123 65133",
	"SPELL_DAMAGE 62038 62188"
)

--TODO, refactor biting cold to track unit aura stacks and start spaming at like 4-5
local warnStormCloud		= mod:NewTargetAnnounce(65123)

local warnFlashFreeze		= mod:NewSpecialWarningSpell(61968, nil, nil, nil, 3, 2)
local specWarnStormCloud	= mod:NewSpecialWarningYou(65123, nil, nil, nil, 1, 2)
local yellStormCloud		= mod:NewYell(65133)
local specWarnBitingCold	= mod:NewSpecialWarningMove(62188, nil, nil, nil, 1, 2)

local enrageTimer			= mod:NewBerserkTimer(475)
local timerFlashFreeze		= mod:NewCastTimer(9, 61968, nil, nil, nil, 2)
local timerFrozenBlows		= mod:NewBuffActiveTimer(20, 63512, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON..DBM_CORE_HEALER_ICON)
local timerFlashFrCD		= mod:NewCDTimer(50, 61968, nil, nil, nil, 2)
local timerAchieve			= mod:NewAchievementTimer(179, 12347)--3182

mod:AddBoolOption("SetIconOnStormCloud")

mod.vb.stormCloudIcon = 8

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	timerAchieve:Start()
	timerFlashFrCD:Start(-delay)
	self.vb.stormCloudIcon = 8
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 61968 then
		timerFlashFreeze:Start()
		warnFlashFreeze:Show()
		warnFlashFreeze:Play("findshelter")
		timerFlashFrCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62478, 63512) then
		timerFrozenBlows:Start()
	elseif args:IsSpellID(65123, 65133) then
		if args:IsPlayer() then
			specWarnStormCloud:Show()
			specWarnStormCloud:Play("gathershare")
			yellStormCloud:Yell()
		else
			warnStormCloud:Show(args.destName)
		end
		if self.Options.SetIconOnStormCloud then
			self:SetIcon(args.destName, self.vb.stormCloudIcon)
		end
		if self.vb.stormCloudIcon == 8 then	-- There is a chance 2 ppl will have the buff on 25 player, so we are alternating between 2 icons
			self.vb.stormCloudIcon = 7
		else
			self.vb.stormCloudIcon = 8
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(65123, 65133) then
		if self.Options.SetIconOnStormCloud then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if (spellId == 62038 or spellId == 62188) and destGUID == UnitGUID("player") and self:AntiSpam(4) then
		specWarnBitingCold:Show()
		specWarnBitingCold:Play("keepmove")
	end
end

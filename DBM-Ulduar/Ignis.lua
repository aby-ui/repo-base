local mod	= DBM:NewMod("Ignis", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190722195205")
mod:SetCreatureID(33118)
mod:SetEncounterID(1136)
mod:SetModelID(29185)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62680 63472",
	"SPELL_CAST_SUCCESS 62548 63474 62488",
	"SPELL_AURA_APPLIED 62717 63477 62382",
	"SPELL_AURA_REMOVED 62717 63477"
)

local announceSlagPot			= mod:NewTargetNoFilterAnnounce(63477, 3)
local announceConstruct			= mod:NewCountAnnounce(62488, 2)

local warnFlameJetsCast			= mod:NewSpecialWarningCast(62488, "SpellCaster")
local warnFlameBrittle			= mod:NewSpecialWarningSwitch(62382, "Dps")

local timerFlameJetsCast		= mod:NewCastTimer(2.7, 63472)
local timerActivateConstruct	= mod:NewCDCountTimer(30, 62488, nil, nil, nil, 1)
local timerFlameJetsCooldown	= mod:NewCDTimer(23.5, 63472, nil, nil, nil, 2)--23.5-31
local timerScorchCooldown		= mod:NewCDTimer(20.5, 63473, nil, nil, nil, 5)
local timerSlagPot				= mod:NewTargetTimer(10, 63477, nil, nil, nil, 3)
local timerAchieve				= mod:NewAchievementTimer(240, 12325)--2930

mod.vb.ConstructCount = 0

mod:AddBoolOption("SlagPotIcon", false)

function mod:OnCombatStart(delay)
	self.vb.ConstructCount = 0
	timerAchieve:Start()
	timerActivateConstruct:Start(11-delay)
	timerScorchCooldown:Start(12-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62680, 63472) then		-- Flame Jets
		timerFlameJetsCast:Start()
		warnFlameJetsCast:Show()
		warnFlameJetsCast:Play("stopcast")
		timerFlameJetsCooldown:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(62548, 63474) then	-- Scorch
		timerScorchCooldown:Start()
	elseif args.spellId == 62488 then
		self.vb.ConstructCount = self.vb.ConstructCount + 1
		announceConstruct:Show(self.vb.ConstructCount)
		if self.vb.ConstructCount < 20 then
			timerActivateConstruct:Start(nil, self.vb.ConstructCount+1)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62717, 63477) then		-- Slag Pot
		announceSlagPot:Show(args.destName)
		timerSlagPot:Start(args.destName)
		if self.Options.SlagPotIcon then
			self:SetIcon(args.destName, 8, 10)
		end
	elseif args.spellId == 62382 and self:AntiSpam(5, 1) then
		warnFlameBrittle:Show()
		warnFlameBrittle:Play("killmob")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(62717, 63477) then		-- Slag Pot
		if self.Options.SlagPotIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

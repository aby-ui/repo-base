local mod	= DBM:NewMod(184, "DBM-Party-Cataclysm", 11, 76)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(52053)
mod:SetEncounterID(1181)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 96338 96316 96916",
	"SPELL_CAST_START 96914 96338 96342"
)
mod.onlyHeroic = true

local warnZanzilElixir		= mod:NewSpellAnnounce(96316, 4)
local warnZanzilFire		= mod:NewSpellAnnounce(96914, 3)
local warnZanzilGas			= mod:NewSpellAnnounce(96338, 3)
local warnGaze				= mod:NewTargetNoFilterAnnounce(96342, 3)

local specWarnGaze			= mod:NewSpecialWarningRun(96342, nil, nil, nil, 4, 2)
local specWarnToxic			= mod:NewSpecialWarning("SpecWarnToxic", nil, nil, nil, 3, 2)
local specWarnFire			= mod:NewSpecialWarningMove(96916, nil, nil, nil, 1, 8)

local timerZanzilGas		= mod:NewBuffActiveTimer(7, 96338, nil, nil, nil, 2)
local timerGaze				= mod:NewTargetTimer(17, 96342, nil, nil, nil, 3)
local timerZanzilElixir		= mod:NewCDTimer(30, 96316, nil, nil, nil, 1)

mod:AddSetIconOption("SetIconOnGaze", 96342, false, false, {8})
mod:AddBoolOption("InfoFrame", "Healer")--on by default for healers, so they know what numpties to heal through gas

local frameDebuff = DBM:GetSpellInfo(96328)

function mod:GazeTarget()
	local targetname = self:GetBossTarget(52054)
	if not targetname then return end
	timerGaze:Start(targetname)
	if self.Options.SetIconOnGaze then
		self:SetIcon(targetname, 8, 17)
	end
	if targetname == UnitName("player") then
		specWarnGaze:Show()
		specWarnGaze:Play("justrun")
	else
		warnGaze:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.PlayerDebuffs)
		DBM.InfoFrame:Show(5, "playergooddebuff", frameDebuff)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96338 then
		timerZanzilGas:Start()
	elseif args.spellId == 96316 then
		warnZanzilElixir:Show()
		timerZanzilElixir:Start()
	elseif args.spellId == 96916 and args:IsPlayer() and self:AntiSpam() then
		specWarnFire:Show()
		specWarnFire:Play("watchfeet")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96914 then
		warnZanzilFire:Show()
	elseif args.spellId == 96338 then
		warnZanzilGas:Show()
		if not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
			specWarnToxic:Show()
			specWarnToxic:Play("useitem")
		end
	elseif args.spellId == 96342 and self:IsInCombat() then
		self:ScheduleMethod(0.2, "GazeTarget")
	end
end

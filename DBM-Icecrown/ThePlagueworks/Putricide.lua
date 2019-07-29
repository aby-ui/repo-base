local mod	= DBM:NewMod("Putricide", "DBM-Icecrown", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(36678)
mod:SetEncounterID(1102)
mod:SetModelID(30881)
mod:SetUsedIcons(5, 6, 7, 8)
--mod:SetMinSyncRevision(3860)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 70351 71617 72840 71621 71893",
	"SPELL_CAST_SUCCESS 70341 71255 70911 72295",
	"SPELL_AURA_APPLIED 70447 70672 71615 71618 72451 70542 70539 70352 70353 70911",
	"SPELL_AURA_APPLIED_DOSE 72451 70542",
	"SPELL_AURA_REFRESH 70539 70542",
	"SPELL_AURA_REMOVED 70447 70672 70911 71615 70539 70542",
	"UNIT_HEALTH boss1"
)

--TODO, move mutated plague timer to SUCCESS event
local warnSlimePuddle				= mod:NewSpellAnnounce(70341, 2)
local warnUnstableExperimentSoon	= mod:NewSoonAnnounce(70351, 3)
local warnUnstableExperiment		= mod:NewSpellAnnounce(70351, 4)
local warnVolatileOozeAdhesive		= mod:NewTargetAnnounce(70447, 3)
local warnGaseousBloat				= mod:NewTargetAnnounce(70672, 3)
local warnPhase2Soon				= mod:NewPrePhaseAnnounce(2)
local warnTearGas					= mod:NewSpellAnnounce(71617, 2)		-- Phase transition normal
local warnVolatileExperiment		= mod:NewSpellAnnounce(72840, 4)		-- Phase transition heroic
local warnChokingGasBombSoon		= mod:NewPreWarnAnnounce(71255, 5, 3, nil, "Melee")
local warnChokingGasBomb			= mod:NewSpellAnnounce(71255, 3, nil, "Melee")		-- Phase 2 ability
local warnPhase3Soon				= mod:NewPrePhaseAnnounce(3)
local warnMutatedPlague				= mod:NewStackAnnounce(72451, 3, nil, "Tank|Healer") -- Phase 3 ability
local warnUnboundPlague				= mod:NewTargetAnnounce(70911, 3)		-- Heroic Ability

local specWarnVolatileOozeAdhesive	= mod:NewSpecialWarningYou(70447, nil, nil, nil, 1, 2)
local specWarnVolatileOozeAdhesiveT	= mod:NewSpecialWarningMoveTo(70447, nil, nil, nil, 1, 2)
local specWarnGaseousBloat			= mod:NewSpecialWarningRun(70672, nil, nil, nil, 4, 2)
local specWarnMalleableGoo			= mod:NewSpecialWarningYou(72295, nil, nil, nil, 1, 2)
local yellMalleableGoo				= mod:NewYell(72295)
local specWarnMalleableGooNear		= mod:NewSpecialWarningClose(72295, nil, nil, nil, 1, 2)
local specWarnChokingGasBomb		= mod:NewSpecialWarningMove(71255, "Tank", nil, nil, 1, 2)
local specWarnMalleableGooCast		= mod:NewSpecialWarningSpell(72295, nil, nil, nil, 2, 2)
local specWarnOozeVariable			= mod:NewSpecialWarningYou(70352)		-- Heroic Ability
local specWarnGasVariable			= mod:NewSpecialWarningYou(70353)		-- Heroic Ability
local specWarnUnboundPlague			= mod:NewSpecialWarningYou(70911, nil, nil, nil, 1, 2)		-- Heroic Ability
local yellUnboundPlague				= mod:NewYell(70911)

local timerGaseousBloat				= mod:NewTargetTimer(20, 70672, nil, nil, nil, 3)			-- Duration of debuff
local timerSlimePuddleCD			= mod:NewCDTimer(35, 70341, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)				-- Approx
local timerUnstableExperimentCD		= mod:NewNextTimer(38, 70351, nil, nil, nil, 1, nil, DBM_CORE_DEADLY_ICON)			-- Used every 38 seconds exactly except after phase changes
local timerChokingGasBombCD			= mod:NewNextTimer(35.5, 71255, nil, nil, nil, 3)
local timerMalleableGooCD			= mod:NewCDTimer(25, 72295, nil, nil, nil, 3)
local timerTearGas					= mod:NewBuffFadesTimer(16, 71615, nil, nil, nil, 6)
local timerPotions					= mod:NewBuffActiveTimer(30, 71621, nil, nil, nil, 6)
local timerMutatedPlagueCD			= mod:NewCDTimer(10, 72451, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)				-- 10 to 11
local timerUnboundPlagueCD			= mod:NewNextTimer(60, 70911, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)
local timerUnboundPlague			= mod:NewBuffActiveTimer(12, 70911, nil, nil, nil, 3)		-- Heroic Ability: we can't keep the debuff 60 seconds, so we have to switch at 12-15 seconds. Otherwise the debuff does to much damage!

-- buffs from "Drink Me"
local timerMutatedSlash				= mod:NewTargetTimer(20, 70542, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)
local timerRegurgitatedOoze			= mod:NewTargetTimer(20, 70539, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddBoolOption("OozeAdhesiveIcon")
mod:AddBoolOption("GaseousBloatIcon")
mod:AddBoolOption("MalleableGooIcon")
mod:AddBoolOption("UnboundPlagueIcon")

mod.vb.warned_preP2 = false
mod.vb.warned_preP3 = false
mod.vb.phase = 0

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerSlimePuddleCD:Start(10-delay)
	timerUnstableExperimentCD:Start(30-delay)
	warnUnstableExperimentSoon:Schedule(25-delay)
	self.vb.warned_preP2 = false
	self.vb.warned_preP3 = false
	self.vb.phase = 1
	if self:IsDifficulty("heroic10", "heroic25") then
		timerUnboundPlagueCD:Start(10-delay)
	end
end

function mod:MalleableGooTarget(targetname, uId)
	if not targetname then return end
		if self.Options.MalleableGooIcon then
			self:SetIcon(targetname, 6, 10)
		end
	if targetname == UnitName("player") then
		specWarnMalleableGoo:Show()
		specWarnMalleableGoo:Play("targetyou")
		yellMalleableGoo:Yell()
	else
		if uId then
			local inRange = CheckInteractDistance(uId, 2)
			if inRange then
				specWarnMalleableGooNear:Show(targetname)
				specWarnMalleableGooNear:Play("watchstep")
			else
				specWarnMalleableGooCast:Show()
				specWarnMalleableGooCast:Play("watchstep")
			end
		else
			specWarnMalleableGooCast:Show()
			specWarnMalleableGooCast:Play("watchstep")
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 70351 then
		warnUnstableExperimentSoon:Cancel()
		warnUnstableExperiment:Show()
		timerUnstableExperimentCD:Start()
		warnUnstableExperimentSoon:Schedule(33)
	elseif args.spellId == 71617 then				--Tear Gas, normal phase change trigger
		warnTearGas:Show()
		warnUnstableExperimentSoon:Cancel()
		warnChokingGasBombSoon:Cancel()
		timerUnstableExperimentCD:Cancel()
		timerMalleableGooCD:Cancel()
		timerSlimePuddleCD:Cancel()
		timerChokingGasBombCD:Cancel()
		timerUnboundPlagueCD:Cancel()
	elseif args.spellId == 72840 then		--Volatile Experiment (heroic phase change begin)
		warnVolatileExperiment:Show()
		warnUnstableExperimentSoon:Cancel()
		warnChokingGasBombSoon:Cancel()
		timerUnstableExperimentCD:Cancel()
		timerMalleableGooCD:Cancel()
		timerSlimePuddleCD:Cancel()
		timerChokingGasBombCD:Cancel()
		timerUnboundPlagueCD:Cancel()
	elseif args.spellId == 71621 then		--Create Concoction (Heroic phase change end)
		if self:IsDifficulty("heroic10", "heroic25") then
			self:ScheduleMethod(40, "NextPhase")	--May need slight tweaking +- a second or two
			timerPotions:Start()
		end
	elseif args.spellId == 71893 then		--Guzzle Potions (Heroic phase change end)
		if self:IsDifficulty("heroic10") then
			self:ScheduleMethod(40, "NextPhase")	--May need slight tweaking +- a second or two
			timerPotions:Start()
		elseif self:IsDifficulty("heroic25") then
			self:ScheduleMethod(30, "NextPhase")
			timerPotions:Start(20)
		end
	end
end

function mod:NextPhase()
	self.vb.phase = self.vb.phase + 1
	if self.vb.phase == 2 then
		warnUnstableExperimentSoon:Schedule(15)
		timerUnstableExperimentCD:Start(20)
		timerSlimePuddleCD:Start(10)
		timerMalleableGooCD:Start(5)
		timerChokingGasBombCD:Start(15)
		warnChokingGasBombSoon:Schedule(10)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerUnboundPlagueCD:Start(50)
		end
	elseif self.vb.phase == 3 then
		timerSlimePuddleCD:Start(15)
		timerMalleableGooCD:Start(9)
		timerChokingGasBombCD:Start(12)
		warnChokingGasBombSoon:Schedule(7)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerUnboundPlagueCD:Start(50)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 70341 and self:AntiSpam(5, 1) then
		warnSlimePuddle:Show()
		if self.vb.phase == 3 then
			timerSlimePuddleCD:Start(20)--In phase 3 it's faster
		else
			timerSlimePuddleCD:Start()
		end
	elseif args.spellId == 71255 then
		warnChokingGasBomb:Show()
		specWarnChokingGasBomb:Show()
		timerChokingGasBombCD:Start()
		warnChokingGasBombSoon:Schedule(30.5)
	elseif args.spellId == 70911 then
		timerUnboundPlagueCD:Start()
	elseif args.spellId == 72295 then
		if self:IsDifficulty("heroic10", "heroic25") then
			timerMalleableGooCD:Start(20)
		else
			timerMalleableGooCD:Start()
		end
		self:BossTargetScanner(36678, "MalleableGooTarget", 0.05, 6)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 70447 then--Green Slime
		if args:IsPlayer() then--Still worth warning 100s because it does still do knockback
			specWarnVolatileOozeAdhesive:Show()
		elseif not self:IsTank() then
			specWarnVolatileOozeAdhesiveT:Show(args.destName)
			specWarnVolatileOozeAdhesiveT:Play("helpsoak")
		else
			warnVolatileOozeAdhesive:Show(args.destName)
		end
		if self.Options.OozeAdhesiveIcon then
			self:SetIcon(args.destName, 8)
		end
	elseif args.spellId == 70672 then	--Red Slime
		timerGaseousBloat:Start(args.destName)
		if args:IsPlayer() and not self:IsTrivial(100) then
			specWarnGaseousBloat:Show()
			specWarnGaseousBloat:Play("justrun")
			specWarnGaseousBloat:ScheduleVoice(1.5, "keepmove")
		else
			warnGaseousBloat:Show(args.destName)
		end
		if self.Options.GaseousBloatIcon then
			self:SetIcon(args.destName, 7)
		end
	elseif args:IsSpellID(71615, 71618) then	--71615 used in 10 and 25 normal, 71618?
		timerTearGas:Start()
	elseif args.spellId == 72451 then	-- Mutated Plague
		warnMutatedPlague:Show(args.destName, args.amount or 1)
		timerMutatedPlagueCD:Start()
	elseif args.spellId == 70542 then
		timerMutatedSlash:Show(args.destName)
	elseif args.spellId == 70539 then
		timerRegurgitatedOoze:Show(args.destName)
	elseif args.spellId == 70352 and not self:IsTrivial(100) then	--Ooze Variable
		if args:IsPlayer() then
			specWarnOozeVariable:Show()
		end
	elseif args.spellId == 70353 and not self:IsTrivial(100) then	-- Gas Variable
		if args:IsPlayer() then
			specWarnGasVariable:Show()
		end
	elseif args.spellId == 70911 then	 -- Unbound Plague
		if self.Options.UnboundPlagueIcon then
			self:SetIcon(args.destName, 5)
		end
		if args:IsPlayer() and not self:IsTrivial(100) then
			specWarnUnboundPlague:Show()
			specWarnUnboundPlague:Play("targetyou")
			timerUnboundPlague:Start()
			yellUnboundPlague:Yell()
		else
			warnUnboundPlague:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 72451 then	-- Mutated Plague
		warnMutatedPlague:Show(args.destName, args.amount or 1)
		timerMutatedPlagueCD:Start()
	elseif args.spellId == 70542 then
		timerMutatedSlash:Show(args.destName)
	end
end

function mod:SPELL_AURA_REFRESH(args)
	if args.spellId == 70539 then
		timerRegurgitatedOoze:Show(args.destName)
	elseif args.spellId == 70542 then
		timerMutatedSlash:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 70447 then
		if self.Options.OozeAdhesiveIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 70672 then
		timerGaseousBloat:Cancel(args.destName)
		if self.Options.GaseousBloatIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 70911 then 						-- Unbound Plague
		timerUnboundPlague:Stop(args.destName)
		if self.Options.UnboundPlagueIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 71615 and self:AntiSpam(5, 2) then 	-- Tear Gas Removal
		self:NextPhase()
	elseif args.spellId == 70539 then
		timerRegurgitatedOoze:Cancel(args.destName)
	elseif args.spellId == 70542 then
		timerMutatedSlash:Cancel(args.destName)
	end
end

--values subject to tuning depending on dps and his health pool
function mod:UNIT_HEALTH(uId)
	if self.vb.phase == 1 and not self.vb.warned_preP2 and self:GetUnitCreatureId(uId) == 36678 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.83 then
		self.vb.warned_preP2 = true
		warnPhase2Soon:Show()	
	elseif self.vb.phase == 2 and not self.vb.warned_preP3 and self:GetUnitCreatureId(uId) == 36678 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.38 then
		self.vb.warned_preP3 = true
		warnPhase3Soon:Show()	
	end
end

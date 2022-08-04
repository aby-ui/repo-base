local mod	= DBM:NewMod(1225, "DBM-Party-WoD", 1, 547)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20220220013546")
mod:SetCreatureID(77734)
mod:SetEncounterID(1714)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 156965 156842 156921 157168 164841 156856",
	"SPELL_AURA_REMOVED 156921 157168",
	"SPELL_CAST_SUCCESS 156854 156974",
	"SPELL_CAST_START 157039 157001 156975 156857 156964",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, get timers for other forms besides demonic, form chosen is RNG based so may take a few logs.
--Basic Abilities
local warnDrainLife				= mod:NewTargetAnnounce(156854, 4)
local warnFixate				= mod:NewTargetNoFilterAnnounce(157168, 2, nil, nil, 2)
--Affliction Abilities
local warnSeedOfMalevolence		= mod:NewTargetAnnounce(156921, 3)
--Demonic Abilities
local warnDemonForm				= mod:NewSpellAnnounce(156919, 3)
local warnDemonicLeap			= mod:NewTargetAnnounce(157039, 3)
local warnChaosWave				= mod:NewTargetAnnounce(157001, 3)
local warnDoom					= mod:NewTargetNoFilterAnnounce(156965, 3, nil, "Healer")

--Basic Abilities
local specWarnDrainLife			= mod:NewSpecialWarningInterrupt(156854, "HasInterrupt", nil, nil, 1, 2)
local specWarnCorruption		= mod:NewSpecialWarningDispel(156842, "Healer", nil, nil, 1, 2)
local specWarnRainOfFire		= mod:NewSpecialWarningSpell(156857, nil, nil, nil, 2, 2)--156856 fires SUCCESS but do not use, it fires for any player walking in or out of it
local specWarnRainOfFireMove	= mod:NewSpecialWarningGTFO(156857, nil, nil, nil, 1, 8)
--Unknown Abilities
local specWarnFixate			= mod:NewSpecialWarningRun(157168, nil, nil, 2, 4, 2)
--Affliction Abilities
--TODO : Maybe need shit warning.
local specWarnSeedOfMelevolence	= mod:NewSpecialWarningMoveAway(156921, nil, nil, nil, 1, 2)
local specWarnExhaustion		= mod:NewSpecialWarningDispel(164841, "RemoveCurse", nil, 2, 1, 2)
--Destruction Abilities
local specWarnChaosBolt			= mod:NewSpecialWarningInterrupt(156975, "HasInterrupt", nil, nil, 3, 2)
local specWarnImmolate			= mod:NewSpecialWarningDispel(156964, "Healer", nil, nil, 1, 2)
--Demonic Abilities
local specWarnDemonicLeap		= mod:NewSpecialWarningYou(157039, nil, nil, nil, 1, 2)
local yellDemonicLeap			= mod:NewYell(157039)
local specWarnChaosWave			= mod:NewSpecialWarningYou(157001, nil, nil, nil, 1, 2)
local yellWarnChaosWave			= mod:NewYell(157001)

--Basic Abilities
local timerDrainLifeCD			= mod:NewCDTimer(15, 156854, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--15~18 variation
local timerFixate				= mod:NewTargetTimer(12, 157168, nil, "-Tank", 3, 3)
local timerRainOfFireCD			= mod:NewCDTimer(12, 156857, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--12-22sec variation phase 2. Unknown Phase 1 repeat timer
--Destruction Abilities
local timerChaosBoltCD			= mod:NewCDTimer(20.5, 156975, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--20-25 variation.
local timerImmolateCD			= mod:NewCDTimer(12, 156964, nil, "Healer", nil, 5, nil, DBM_COMMON_L.HEALER_ICON)--Only timer that's probably not variable
--Affliction Abilities
local timerSeedOfMelevolence	= mod:NewTargetTimer(18, 156921, nil, "-Tank")
local timerSeedOfMelevolenceCD	= mod:NewCDTimer(22, 156921, nil, nil, nil, 3)--22-25
--local timerExhaustionCD		= mod:NewCDTimer(14, 164841)--14~24 variation. Large variation, seems useless.
--Demonic Abilities
local timerChaosWaveCD			= mod:NewCDTimer(13, 157001, nil, nil, nil, 3)--13-17 variation
local timerDemonicLeapCD		= mod:NewCDTimer(20, 157039, nil, nil, nil, 3)

mod:AddRangeFrameOption(10, 156921)

local seedDebuff = DBM:GetSpellInfo(156921)
local DebuffFilter
do
	DebuffFilter = function(uId)
		return DBM:UnitDebuff(uId, seedDebuff)
	end
end

mod.vb.seedCount = 0

function mod:LeapTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnDemonicLeap:Show()
		specWarnDemonicLeap:Play("targetyou")
		yellDemonicLeap:Yell()
	else
		warnDemonicLeap:Show(targetname)
	end
end

function mod:ChaosWaveTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnChaosWave:Show()
		specWarnChaosWave:Play("runaway")
		yellWarnChaosWave:Yell()
	else
		warnChaosWave:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.seedCount = 0
	self:SetStage(1)
	timerRainOfFireCD:Start(15-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 156965 then
		warnDoom:Show(args.destName)
	elseif spellId == 156842 and self:CheckDispelFilter() then
		specWarnCorruption:Show(args.destName)
		specWarnCorruption:Play("dispelnow")
	elseif spellId == 156921 and args:IsDestTypePlayer() then--This debuff can be spread to the boss. bugged?
		self.vb.seedCount = self.vb.seedCount + 1
		warnSeedOfMalevolence:Show(args.destName)
		--timerSeedOfMelevolenceCD:Start()
		timerSeedOfMelevolence:Start(args.destName)
		if args:IsPlayer() then
			specWarnSeedOfMelevolence:Show()
			specWarnSeedOfMelevolence:Play("runout")
		end
		if self.Options.RangeFrame then
			if DBM:UnitDebuff("player", seedDebuff) then--You have debuff, show everyone
				DBM.RangeCheck:Show(10, nil)
			else--You do not have debuff, only show players who do
				DBM.RangeCheck:Show(10, DebuffFilter)
			end
		end
	elseif spellId == 157168 then
		timerFixate:Start(args.destName)
		if args:IsPlayer() then
			specWarnFixate:Show()
			specWarnFixate:Play("justrun")
		else
			warnFixate:Show(args.destName)
		end
	elseif spellId == 164841 and self:CheckDispelFilter() then
		specWarnExhaustion:Show(args.destName)
		specWarnExhaustion:Play("dispelnow")
		--timerExhaustionCD:Start()
	elseif spellId == 156964 and self:CheckDispelFilter() then--Base version cast only in phase 1
		specWarnImmolate:Show(args.destName)
		timerImmolateCD:Start()
		specWarnImmolate:Play("dispelnow")
	elseif spellId == 156856 and args:IsPlayer() then
		specWarnRainOfFireMove:Show(args.spellName)
		specWarnRainOfFireMove:Play("watchfeet")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 156921 and args:IsDestTypePlayer() then
		self.vb.seedCount = self.vb.seedCount - 1
		timerSeedOfMelevolence:Cancel(args.destName)
		if self.Options.RangeFrame and self.vb.seedCount == 0 then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 157168 then
		timerFixate:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 157039 then
		timerDemonicLeapCD:Start()
		self:BossTargetScanner(77734, "LeapTarget", 0.1, 16)--Timing not verified, but Boss DOES look at leap target
	elseif spellId == 157001 then
		timerChaosWaveCD:Start()
		self:BossTargetScanner(77734, "ChaosWaveTarget", 0.1, 16)--Timing not verified, but Boss DOES look at leap target
	elseif spellId == 156975 then
		timerChaosBoltCD:Start()--TODO, verify it's 20 on heroic and normal too. it's definitely 20 on CM
		specWarnChaosBolt:Show(args.sourceName)
		if self:IsTank() then
			specWarnChaosBolt:Play("kickcast")
		else
			specWarnChaosBolt:Play("helpkick")
		end
	elseif spellId == 156857 then--Base version cast only in phase 1
		specWarnRainOfFire:Show()
		specWarnRainOfFire:Play("watchstep")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 156854 then
		warnDrainLife:Show(args.destName)
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDrainLife:Show(args.sourceName)
			specWarnDrainLife:Play("kickcast")
		end
		timerDrainLifeCD:Start()
	elseif spellId == 156974 then--Instant cast version from destro
		specWarnRainOfFire:Show()
		specWarnRainOfFire:Play("watchstep")
		timerRainOfFireCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 156919 then--Demonology Transformation
		self:SetStage(2)
		timerDrainLifeCD:Cancel()
		timerRainOfFireCD:Cancel()
		timerChaosWaveCD:Start(10)
		timerDemonicLeapCD:Start(23)
	elseif spellId == 156863 then--Affliction Transformation
		self:SetStage(2)
		timerRainOfFireCD:Cancel()
		--timerSeedOfMelevolenceCD:Start(5)
		--timerDrainLifeCD:Start()--Update timer here
		--no timers. need logs.
	elseif spellId == 156866 then--Destruction Transformation
		self:SetStage(2)
		timerDrainLifeCD:Cancel()
		if self:IsDifficulty("challenge5") then-- (in CM, it says he goes into this form but it's a lie)
			timerSeedOfMelevolenceCD:Start(5)
			timerRainOfFireCD:Start(13)
			timerChaosBoltCD:Start(15)
			timerImmolateCD:Start(22)--Debuff timer, not cast. you don't interrupt, so timer for healer dispel, not cast
		else--Actual heroic/normal destro form
			--no timers. need logs.
			--timerRainOfFireCD:Start(13)
			--timerChaosBoltCD:Start(15)
			--timerImmolateCD:Start(22)
		end
	elseif spellId == 114268 then
		DBM:EndCombat(self)
	end
end

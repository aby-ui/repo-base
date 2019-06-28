local mod	= DBM:NewMod(169, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(42180, 42178, 42179, 42166)
mod:SetEncounterID(1027)
mod:SetZone()
mod:SetUsedIcons(1, 3, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_OmnitronIntro01.ogg", "Sound\\Creature\\Council\\VO_BD_Council_Event01.ogg")
--Long: Hmm, the Omnotron Defense System. Centuries ago, these constructs were considered the dwarves greatest tactical achievements. With so many counters to each construct's attacks, I'll have to rectify these designs for them to provide me ANY entertainment!
--Short: Intruders detected. Primary defense matrix initiated.

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_INTERRUPT",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)

--Magmatron
local warnIncineration			= mod:NewSpellAnnounce(79023, 2, nil, "Healer")
local warnBarrierSoon			= mod:NewPreWarnAnnounce(79582, 10, 3, nil, "-Healer")
local warnBarrier				= mod:NewSpellAnnounce(79582, 4, nil, "-Healer")
local warnAcquiringTarget		= mod:NewTargetAnnounce(79501, 4, nil, false)--Off by default, default UI has this warning built in
--Electron
local warnLightningConductor	= mod:NewTargetAnnounce(79888, 4, nil, false)--Off by default, default UI has this warning built in
local warnUnstableShieldSoon	= mod:NewPreWarnAnnounce(79900, 10, 3, nil, "-Healer")
local warnUnstableShield		= mod:NewSpellAnnounce(79900, 4, nil, "-Healer")
local warnShadowConductorCast	= mod:NewPreWarnAnnounce(92053, 5, 4)--Heroic Ability
--Toxitron
local warnPoisonProtocol		= mod:NewSpellAnnounce(80053, 3)
local warnFixate				= mod:NewTargetAnnounce(80094, 4, nil, false)--Spammy, off by default. Raid leader can turn it on if they wanna yell at these people.
local warnChemicalBomb			= mod:NewTargetAnnounce(80157, 3)
local warnShellSoon				= mod:NewPreWarnAnnounce(79835, 10, 2, nil, false)
local warnShell					= mod:NewSpellAnnounce(79835, 3, nil, "-Healer")
local warnGrip					= mod:NewCastAnnounce(91849, 4)--Heroic Ability
--Arcanotron
local warnGenerator				= mod:NewSpellAnnounce(79624, 3)
local warnConversionSoon		= mod:NewPreWarnAnnounce(79729, 10, 3, nil, "-Healer")
local warnConversion			= mod:NewSpellAnnounce(79729, 4, nil, "-Healer")
local warnOverchargedGenerator	= mod:NewSpellAnnounce(91857, 4)--Heroic Ability
--All
local warnActivated				= mod:NewTargetAnnounce(78740, 3)

--Magmatron
local specWarnBarrier			= mod:NewSpecialWarningSpell(79582, "-Healer")
local specWarnAcquiringTarget	= mod:NewSpecialWarningMoveAway(79501)
local yellAcquiringTarget		= mod:NewYell(79501)
local specWarnEncasingShadows	= mod:NewSpecialWarningTarget(92023, false)--Heroic Ability
local yellEncasingShadows		= mod:NewYell(92023, L.YellTargetLock)
--Electron
local specWarnUnstableShield	= mod:NewSpecialWarningSpell(79900, "-Healer")
local specWarnConductor			= mod:NewSpecialWarningMoveAway(79888)
local yellLightConductor		= mod:NewYell(79888)
local specWarnShadowConductor	= mod:NewSpecialWarningTarget(92053)--Heroic Ability
local yellShadowConductor		= mod:NewYell(92053)
--Toxitron
local specWarnShell				= mod:NewSpecialWarningSpell(79835, "-Healer")
local specWarnBombTarget		= mod:NewSpecialWarningRun(80094)
local yellFixate				= mod:NewYell(80094, nil, false)
local specWarnPoisonProtocol	= mod:NewSpecialWarningSpell(80053, "-Healer")
local specWarnChemicalCloud		= mod:NewSpecialWarningMove(80161)
local yellChemicalCloud			= mod:NewYell(80161)--May Return false tank yells
local specWarnGrip				= mod:NewSpecialWarningSpell(91849, nil, nil, nil, 2)--Heroic Ability
--Arcanotron
local specWarnConversion		= mod:NewSpecialWarningSpell(79729, "-Healer")
local specWarnGenerator			= mod:NewSpecialWarning("specWarnGenerator", "Tank")
local specWarnAnnihilator		= mod:NewSpecialWarningInterrupt(79710, "Melee")--On by default for melee now that there is a smart filterin place on whether or not they should be warned.
local specWarnOvercharged		= mod:NewSpecialWarningSpell(91857, false)--Heroic Ability
--All
local specWarnActivated			= mod:NewSpecialWarning("SpecWarnActivated", "-Healer")--Good for target switches, but healers probably don't want an extra special warning for it.

--Magmatron
local timerAcquiringTarget		= mod:NewNextTimer(40, 79501)
local timerBarrier				= mod:NewBuffActiveTimer(11.5, 79582, nil, false)	-- 10 + 1.5 cast time
local timerIncinerationCD   	= mod:NewNextTimer(26.5, 79023, nil, "Healer")--Timer Series, 10, 27, 32 (on normal) from activate til shutdown.
--Electron
local timerLightningConductor	= mod:NewTargetTimer(10, 79888)
local timerLightningConductorCD	= mod:NewNextTimer(25, 79888)
local timerUnstableShield		= mod:NewBuffActiveTimer(11.5, 79900, nil, false)	-- 10 + 1.5 cast time
local timerShadowConductor		= mod:NewTargetTimer(10, 92053)						--Heroic Ability
local timerShadowConductorCast	= mod:NewTimer(5, "timerShadowConductorCast", 92048)--Heroic Ability
--Toxitron
local timerChemicalBomb			= mod:NewCDTimer(30, 80157)							--Timer Series, 11, 30, 36 (on normal) from activate til shutdown.
local timerShell				= mod:NewBuffActiveTimer(11.5, 79835, nil, false)	-- 10 + 1.5 cast time
local timerPoisonProtocolCD		= mod:NewNextTimer(45, 80053)
--Arcanotron
local timerGeneratorCD			= mod:NewNextTimer(30, 79624)
local timerConversion			= mod:NewBuffActiveTimer(11.5, 79729, nil, false)		--10 + 1.5 cast time
local timerArcaneLockout		= mod:NewTimer(3, "timerArcaneLockout", 79710, false)	--How long arcanotron is locked out from casting another Arcane Annihilator
local timerArcaneBlowback		= mod:NewTimer(8, "timerArcaneBlowbackCast", 91879)		--what happens after the overcharged power generator explodes. 8 seconds after overcharge cast.
--All
local timerNextActivate			= mod:NewNextTimer(45, 78740)				--Activations are every 90 (60sec heroic) seconds but encounter staggers them in an alternating fassion so 45 (30 heroic) seconds between add switches
local timerNefAbilityCD			= mod:NewTimer(30, "timerNefAblity", 92048)--Huge variation on this, but shortest CD i've observed is 30.

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("AcquiringTargetIcon")
mod:AddBoolOption("ConductorIcon")
mod:AddBoolOption("ShadowConductorIcon")
mod:AddBoolOption("SetIconOnActivated", false)

local pulled = false
local cloudSpam = 0--Uses custom resets, don't use prototype
local incinerateCast = 0
local encasing = false
local Magmatron = DBM:EJ_GetSectionInfo(3207)
local Electron = DBM:EJ_GetSectionInfo(3201)
local Toxitron = DBM:EJ_GetSectionInfo(3208)
local Arcanotron = DBM:EJ_GetSectionInfo(3194)

function mod:ChemicalBombTarget()
	local targetname = self:GetBossTarget(42180)
	if not targetname then return end
	warnChemicalBomb:Show(targetname)
	if targetname == UnitName("player") then
		yellChemicalCloud:Yell()
	end
end

local bossActivate = function(boss)
	if boss == Magmatron or boss == 42178 then
		incinerateCast = 0
		timerAcquiringTarget:Start(20)--These are same on heroic and normal
		timerIncinerationCD:Start(10)
		if mod:IsDifficulty("heroic10", "heroic25") then
			warnBarrierSoon:Schedule(34)
		else
			warnBarrierSoon:Schedule(40)
		end
	elseif boss == Electron or boss == 42179 then
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerLightningConductorCD:Start(15)--Probably also has a variation if it's like normal. Needs more logs to verify.
			warnUnstableShieldSoon:Schedule(30)
		else
			timerLightningConductorCD:Start(11)--11-15 variation confirmed for normal, only boss ability with an actual variation on timer. Strange.
			warnUnstableShieldSoon:Schedule(40)
		end
	elseif boss == Toxitron or boss == 42180 then
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerChemicalBomb:Start(25)
			timerPoisonProtocolCD:Start(15)
			warnShellSoon:Schedule(30)
		else
			timerChemicalBomb:Start(11)
			timerPoisonProtocolCD:Start(21)
			warnShellSoon:Schedule(40)
		end
	elseif boss == Arcanotron or boss == 42166 then
		timerGeneratorCD:Start(15)--These appear same on heroic and non heroic but will leave like this for now to await 25 man heroic confirmation.
		if mod:IsDifficulty("heroic10", "heroic25") then
			warnConversionSoon:Schedule(30)
		else
			warnConversionSoon:Schedule(40)
		end
	end
end

local bossInactive = function(boss)
	if boss == Magmatron then
		timerAcquiringTarget:Cancel()
		timerIncinerationCD:Cancel()
	elseif boss == Electron then
		timerLightningConductorCD:Cancel()
	elseif boss == Toxitron then
		timerChemicalBomb:Cancel()
		timerPoisonProtocolCD:Cancel()
	elseif boss == Arcanotron then
		timerGeneratorCD:Cancel()
	end
end

function mod:CheckEncasing() -- prevent two yells at a time
	if encasing then
		yellEncasingShadows:Yell()
	else
		yellAcquiringTarget:Yell()
	end
	encasing = false
end

function mod:OnCombatStart(delay)
	cloudSpam = 0
	encasing = false
	incinerateCast = 0
	if self:IsDifficulty("heroic10", "heroic25") then
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	pulled = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 78740 then--Ignore any activates that fire too close to eachother thanks to 4.1 screwing it up.
		warnActivated:Show(args.destName)
		bossActivate(args.destName)
		if pulled then -- prevent show warning when first pulled.
			specWarnActivated:Show(args.destName)
		end
		if not pulled then
			pulled = true
		end
		if self:IsDifficulty("heroic10", "heroic25") then
			timerNextActivate:Start(30)
		else
			timerNextActivate:Start()
		end
		if self.Options.SetIconOnActivated and DBM:GetRaidRank() >= 1 then
			for i = 1, 4 do
				if UnitName("boss"..i) == args.destName then
					SetRaidTarget("boss"..i, 8)
					break
				end
			end
		end
	elseif args.spellId == 78726 then
		bossInactive(args.destName)
	elseif args.spellId == 79501 then
		warnAcquiringTarget:Show(args.destName)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerAcquiringTarget:Start(27)
		else
			timerAcquiringTarget:Start()
		end
		if args:IsPlayer() then
			specWarnAcquiringTarget:Show()
			self:ScheduleMethod(1, "CheckEncasing")
		end
		if self.Options.AcquiringTargetIcon then
			self:SetIcon(args.destName, 7, 8)
		end
	elseif args.spellId == 79888 then
		warnLightningConductor:Show(args.destName)
		if args:IsPlayer() then
			specWarnConductor:Show()
			yellLightConductor:Yell()
		end
		if self.Options.ConductorIcon then
			self:SetIcon(args.destName, 1)
		end
		if self:IsDifficulty("heroic10", "heroic25") then
			timerLightningConductor:Start(15, args.destName)
			timerLightningConductorCD:Start(20)
		else
			timerLightningConductor:Start(args.destName)
			timerLightningConductorCD:Start()
		end
	elseif args.spellId == 80094 then
		warnFixate:Show(args.destName)
		if args:IsPlayer() then
			specWarnBombTarget:Show()
			yellFixate:Yell()
		end
	elseif args.spellId == 80161 and args:IsPlayer() and GetTime() - cloudSpam > 4 then
		specWarnChemicalCloud:Show()
		cloudSpam = GetTime()
	elseif args.spellId == 79629 and args:IsDestTypeHostile() then--Check if Generator buff is gained by a hostile.
		local targetCID = self:GetUnitCreatureId("target")--Get CID of current target
		if args:GetDestCreatureID() == targetCID and args:GetDestCreatureID() ~= 42897 then--If target gaining buff is target then not an ooze (only hostiles left filtering oozes is golems)
			specWarnGenerator:Show(args.destName)--Show special warning to move him out of it.
		end
	elseif args.spellId == 92048 then--Shadow Infusion, debuff 5 seconds before shadow conductor.
		timerNefAbilityCD:Start()
		warnShadowConductorCast:Show()
		timerShadowConductorCast:Start()
	elseif args.spellId == 92023 then
		if args:IsPlayer() then
			encasing = true
		end
		if self.Options.AcquiringTargetIcon then
			self:SetIcon(args.destName, 6, 8)
		end
		specWarnEncasingShadows:Show(args.destName)
		timerNefAbilityCD:Start()
	elseif args.spellId == 92053 then
		specWarnShadowConductor:Show(args.destName)
		timerShadowConductor:Show(args.destName)
		timerLightningConductor:Cancel()
		if self.Options.ShadowConductorIcon then
			self:SetIcon(args.destName, 3)
		end
		if args:IsPlayer() then
			yellShadowConductor:Yell()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 79888 then
		if self.Options.ConductorIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 92053 then
		timerShadowConductor:Cancel(args.destName)
		if self.Options.ShadowConductorIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 79023 then
		incinerateCast = incinerateCast + 1
		warnIncineration:Show()
		if incinerateCast == 1 then--Only cast twice on heroic, 3 times on normal.
			timerIncinerationCD:Start()--second cast is after 27 seconds on heroic and normal.
		elseif incinerateCast == 2 and self:IsDifficulty("normal10", "normal25") then
			timerIncinerationCD:Start(32)--3rd cast on normal is 32 seconds. 10 27 32 series.
		end
	elseif args.spellId == 79582 then
		warnBarrier:Show()
		timerBarrier:Start()
		if self:GetUnitCreatureId("target") == 42178 then
			specWarnBarrier:Show()
		end
	elseif args.spellId == 79900 then
		warnUnstableShield:Show()
		timerUnstableShield:Start()
		if self:GetUnitCreatureId("target") == 42179 then
			specWarnUnstableShield:Show()
		end
	elseif args.spellId == 79835 then
		warnShell:Show()
		timerShell:Start()
		if self:GetUnitCreatureId("target") == 42180 then
			specWarnShell:Show()
		end
	elseif args.spellId == 79729 then
		warnConversion:Show()
		timerConversion:Start()
		if self:GetUnitCreatureId("target") == 42166 then
			specWarnConversion:Show()
		end
	elseif args.spellId == 91849 then--Grip
		warnGrip:Show()
		specWarnGrip:Show()
		timerNefAbilityCD:Start()
		cloudSpam = GetTime()
	elseif args.spellId == 79710 then
		if self:IsMelee() and (self:GetUnitCreatureId("target") == 42166 or self:GetUnitCreatureId("focus") == 42166) or not self:IsMelee() then
			specWarnAnnihilator:Show(args.sourceName)--Only warn for melee targeting him or exclicidly put him on focus, else warn regardless if he's your target/focus or not if you aren't a melee
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 80157 then
		timerChemicalBomb:Start()--Appears same on heroic
		self:ScheduleMethod(0.1, "ChemicalBombTarget")--Since this is an instance cast scanning accurately is very hard.
	elseif args.spellId == 80053 then
		warnPoisonProtocol:Show()
		if self:GetUnitCreatureId("target") ~= 42180 then--You're not targeting toxitron
			specWarnPoisonProtocol:Show()
		end
		if self:IsDifficulty("heroic10", "heroic25") then
			timerPoisonProtocolCD:Start(25)
		else
			timerPoisonProtocolCD:Start()
		end
	elseif args.spellId == 79624 then
		warnGenerator:Show()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerGeneratorCD:Start(20)
		else
			timerGeneratorCD:Start()
		end
	elseif args.spellId == 91857 then
		warnOverchargedGenerator:Show()
		specWarnOvercharged:Show()
		timerArcaneBlowback:Start()
		timerNefAbilityCD:Start()
	end
end

function mod:SPELL_INTERRUPT(args)
	if (type(args.extraSpellId) == "number" and args.extraSpellId == 79710) and self:AntiSpam(2, 2) then
		if args.spellId == 2139 then															--Counterspell
			timerArcaneLockout:Start(7.5)
		elseif args.spellId == 19647 then													--Shield Bash (will be removed in 4.1), Spell Lock (Fel Hunter)
			timerArcaneLockout:Start(6.5)--Shield bash verified, spell lock assumed since it's same lockout duration.
		elseif args:IsSpellID(96231, 6552, 47528, 1766) or args:IsSpellID(80964, 80965)  then	--Rebuke, Pummel, Mind Freeze, Kick, Skull Bash (feral and bear)
			timerArcaneLockout:Start(5)--4 out of 6 verified, skull bash needs logs to review for certainty.
		elseif args:IsSpellID(34490, 15487) then												--Silencing Shot, Silence
			timerArcaneLockout:Start(3.5)--Drycoded, needs verification for both spells.
		elseif args.spellId == 57994 then														--Wind Shear
			timerArcaneLockout:Start(2.5)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, _, _, _, _, spellId)
	if spellId == 79710 then--An interrupt failed (or wasn't cast)
		timerArcaneLockout:Cancel()--Cancel bar just in case one was started by a late SPELL_INTERRUPT event that showed in combat log while cast went off anyways.
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

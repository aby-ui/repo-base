local mod	= DBM:NewMod(158, "DBM-BastionTwilight", nil, 72)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(43686, 43687, 43688, 43689, 43735)
mod:SetEncounterID(1028)
mod:SetZone()
mod:SetUsedIcons(3, 4, 5, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Chogall\\VO_BT_Chogall_BotEvent14.ogg", "Sound\\Creature\\Terrastra\\VO_BT_Terrastra_Event02.ogg")
--Long: Brothers of Twilight! The Hammer calls to you! Fire, water, earth, air! Leave your mortal shell behind! Fire, water, earth, air! Embrace your new forms, for here and ever after... Burn and drown and crush and sufficate!...and use your gifts to destroy the unbelievers! Burn and drown and crush and sufficate!
--Short: We will handle them!

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Kill)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4",
	"UNIT_HEALTH boss1 boss2 boss3 boss4"
)

local Ignacious = DBM:EJ_GetSectionInfo(3118)
local Feludius = DBM:EJ_GetSectionInfo(3110)
local Arion = DBM:EJ_GetSectionInfo(3128)
local Terrastra = DBM:EJ_GetSectionInfo(3135)
local Monstrosity = DBM:EJ_GetSectionInfo(3145)

--Feludius
local warnHeartIce			= mod:NewTargetAnnounce(82665, 3, nil, false)
local warnGlaciate			= mod:NewSpellAnnounce(82746, 3, nil, "Melee")
local warnWaterBomb			= mod:NewSpellAnnounce(82699, 3)
local warnFrozen			= mod:NewTargetAnnounce(82772, 3, nil, "Healer")
--Ignacious
local warnBurningBlood		= mod:NewTargetAnnounce(82660, 3, nil, false)
local warnFlameTorrent		= mod:NewSpellAnnounce(82777, 2, nil, "Tank|Healer")--Not too useful to announce but will leave for now. CD timer useless.
--Terrastra
local warnEruption			= mod:NewSpellAnnounce(83675, 2, nil, "Melee")
local warnHardenSkin		= mod:NewSpellAnnounce(83718, 3, nil, "Tank")
local warnQuakeSoon			= mod:NewPreWarnAnnounce(83565, 10, 3)
local warnQuake				= mod:NewSpellAnnounce(83565, 4)
--Arion
local warnLightningRod		= mod:NewTargetAnnounce(83099, 3)
local warnDisperse			= mod:NewSpellAnnounce(83087, 3, nil, "Tank")
local warnLightningBlast	= mod:NewCastAnnounce(83070, 3, nil, nil, "Tank")
local warnThundershockSoon	= mod:NewPreWarnAnnounce(83067, 10, 3)
local warnThundershock		= mod:NewSpellAnnounce(83067, 4)
--Elementium Monstrosity
local warnLavaSeed			= mod:NewSpellAnnounce(84913, 4)
local warnGravityCrush		= mod:NewTargetAnnounce(84948, 3)
--Heroic
local warnGravityCore		= mod:NewTargetAnnounce(92075, 4)--Heroic Phase 1 ablity
local warnStaticOverload	= mod:NewTargetAnnounce(92067, 4)--Heroic Phase 1 ablity
local warnFlameStrike		= mod:NewCastAnnounce(92212, 3) --Heroic Phase 2 ablity
local warnFrostBeacon		= mod:NewTargetAnnounce(92307, 4)--Heroic Phase 2 ablity

--Feludius
local specWarnHeartIce		= mod:NewSpecialWarningYou(82665, false)
local specWarnGlaciate		= mod:NewSpecialWarningRun(82746, "Melee", nil, nil, 4)
local specWarnWaterLogged	= mod:NewSpecialWarningYou(82762)
local specWarnHydroLance	= mod:NewSpecialWarningInterrupt(82752, "Melee")
--Ignacious
local specWarnBurningBlood	= mod:NewSpecialWarningYou(82660, false)
local specWarnAegisFlame	= mod:NewSpecialWarningSwitch(82631, nil, nil, nil, 1)
local specWarnRisingFlames	= mod:NewSpecialWarningInterrupt(82636)
--Terrastra
local specWarnEruption		= mod:NewSpecialWarningSpell(83675, false)
local specWarnSearingWinds	= mod:NewSpecialWarning("SpecWarnSearingWinds")
local specWarnHardenedSkin	= mod:NewSpecialWarningInterrupt(83718, "Melee")
--Arion
local specWarnGrounded		= mod:NewSpecialWarning("SpecWarnGrounded")
local specWarnLightningBlast= mod:NewSpecialWarningInterrupt(83070, false)
local specWarnLightningRod	= mod:NewSpecialWarningMoveAway(83099)
local yellLightningRod		= mod:NewYell(83099)
--Heroic
local specWarnGravityCore	= mod:NewSpecialWarningYou(92075)--Heroic
local yellGravityCore		= mod:NewYell(92075)
local specWarnStaticOverload= mod:NewSpecialWarningYou(92067)--Heroic
local yellStaticOverload	= mod:NewYell(92067)
local specWarnFrostBeacon	= mod:NewSpecialWarningYou(92307, nil, nil, nil, 3)--Heroic
local yellFrostbeacon		= mod:NewYell(92307)
local yellScrewed			= mod:NewYell(92307, L.blizzHatesMe, true, "yellScrewed", "YELL")--Amusing but effective.

local specWarnBossLow		= mod:NewSpecialWarning("specWarnBossLow")

--Feludius
mod:AddTimerLine(Feludius)
local timerHeartIce			= mod:NewTargetTimer(60, 82665, nil, false)
local timerHeartIceCD		= mod:NewCDTimer(22, 82665, nil, false)--22-24 seconds
local timerGlaciate			= mod:NewCDTimer(33, 82746, nil, "Melee", nil, 2, nil, DBM_CORE_DEADLY_ICON)--33-35 seconds
local timerWaterBomb		= mod:NewCDTimer(33, 82699, nil, nil, nil, 3)--33-35 seconds
local timerFrozen			= mod:NewBuffFadesTimer(10, 82772, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerHydroLanceCD		= mod:NewCDTimer(12, 82752, nil, "HasInterrupt", 2, 4, nil, DBM_CORE_INTERRUPT_ICON)--12 second cd but lowest cast priority
--Ignacious
mod:AddTimerLine(Ignacious)
local timerBurningBlood		= mod:NewTargetTimer(60, 82660, nil, false)
local timerBurningBloodCD	= mod:NewCDTimer(22, 82660, nil, false)--22-33 seconds, even worth having a timer?
local timerAegisFlame		= mod:NewNextTimer(60, 82631, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)
--Terrastra
mod:AddTimerLine(Terrastra)
local timerEruptionCD		= mod:NewNextTimer(15, 83675, nil, "Melee", nil, 3)
local timerHardenSkinCD		= mod:NewCDTimer(42, 83718, nil, "HasInterrupt", 2, 4, nil, DBM_CORE_INTERRUPT_ICON)--This one is iffy, it isn't as consistent as other ability timers
local timerQuakeCD			= mod:NewNextTimer(33, 83565, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerQuakeCast		= mod:NewCastTimer(3, 83565)
--Arion
mod:AddTimerLine(Arion)
local timerLightningRod		= mod:NewBuffFadesTimer(15, 83099)
local timerDisperse			= mod:NewCDTimer(30, 83087, nil, nil, nil, 6)
local timerLightningBlast	= mod:NewCastTimer(4, 83070, nil, false)
local timerThundershockCD	= mod:NewNextTimer(33, 83067, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerThundershockCast	= mod:NewCastTimer(3, 83067)
--Elementium Monstrosity
mod:AddTimerLine(Monstrosity)
local timerTransition		= mod:NewTimer(16.7, "timerTransition", 84918, nil, nil, 6)
local timerLavaSeedCD		= mod:NewCDTimer(23, 84913, nil, nil, nil, 2)
local timerGravityCrush		= mod:NewBuffActiveTimer(10, 84948)
local timerGravityCrushCD	= mod:NewCDTimer(24, 84948, nil, nil, nil, 3)--24-28sec cd, decent varation
--Heroic
mod:AddTimerLine(PLAYER_DIFFICULTY2)
local timerGravityCoreCD	= mod:NewNextTimer(20, 92075, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)--Heroic Phase 1 ablity
local timerStaticOverloadCD	= mod:NewNextTimer(20, 92067, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)--Heroic Phase 1 ablity
local timerFlameStrikeCD	= mod:NewNextTimer(20, 92212, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)--Heroic Phase 2 ablity
local timerFrostBeaconCD	= mod:NewNextTimer(20, 92307, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)--Heroic Phase 2 ablity

mod:AddBoolOption("HeartIceIcon")
mod:AddBoolOption("BurningBloodIcon")
mod:AddBoolOption("LightningRodIcon")
mod:AddBoolOption("GravityCrushIcon")
mod:AddBoolOption("FrostBeaconIcon")
mod:AddBoolOption("StaticOverloadIcon")
mod:AddBoolOption("GravityCoreIcon")
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("InfoFrame")

local frozenTargets = {}
local lightningRodTargets = {}
local gravityCrushTargets = {}
local lightningRodIcon = 8
local gravityCrushIcon = 8
local sentLowHP = {}
local warnedLowHP = {}
local frozenCount = 0
local isBeacon = false
local isRod = false
local infoFrameUpdated = false
local phase = 1
local groundedName, searingName = DBM:GetSpellInfo(83581), DBM:GetSpellInfo(83500)

local shieldHealth = {
	["heroic25"] = 2000000,
	["heroic10"] = 700000,
	["normal25"] = 1500000,
	["normal10"] = 500000
}

local function showFrozenWarning()
	warnFrozen:Show(table.concat(frozenTargets, "<, >"))
	timerFrozen:Start()
	table.wipe(frozenTargets)
end

local function showLightningRodWarning()
	warnLightningRod:Show(table.concat(lightningRodTargets, "<, >"))
	timerLightningRod:Start()
	table.wipe(lightningRodTargets)
	lightningRodIcon = 8
end

local function showGravityCrushWarning()
	warnGravityCrush:Show(table.concat(gravityCrushTargets, "<, >"))
	timerGravityCrush:Start()
	table.wipe(gravityCrushTargets)
	gravityCrushIcon = 8
end

local function checkGrounded(self)
	if not DBM:UnitDebuff("player", groundedName) and not UnitIsDeadOrGhost("player") then
		specWarnGrounded:Show()
	end
	if self.Options.InfoFrame and not infoFrameUpdated then
		infoFrameUpdated = true
		DBM.InfoFrame:SetHeader(L.WrongDebuff:format(groundedName))
		DBM.InfoFrame:Show(5, "playergooddebuff", groundedName)
	end
end

local function checkSearingWinds(self)
	if not DBM:UnitDebuff("player", searingName) and not UnitIsDeadOrGhost("player") then
		specWarnSearingWinds:Show()
	end
	if self.Options.InfoFrame and not infoFrameUpdated then
		infoFrameUpdated = true
		DBM.InfoFrame:SetHeader(L.WrongDebuff:format(searingName))
		DBM.InfoFrame:Show(5, "playergooddebuff", searingName)
	end
end

function mod:OnCombatStart(delay)
	DBM:GetModByName("BoTrash"):SetFlamestrike(true)
	phase = 1
	table.wipe(frozenTargets)
	table.wipe(lightningRodTargets)
	table.wipe(gravityCrushTargets)
	table.wipe(sentLowHP)
	table.wipe(warnedLowHP)
	lightningRodIcon = 8
	gravityCrushIcon = 8
	frozenCount = 0
	isBeacon = false
	isRod = false
	infoFrameUpdated = false
	timerGlaciate:Start(30-delay)
	timerWaterBomb:Start(15-delay)
	timerHeartIceCD:Start(18-delay)--could be just as flakey as it is in combat though.
	timerBurningBloodCD:Start(28-delay)--could be just as flakey as it is in combat though.
	timerAegisFlame:Start(31-delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerGravityCoreCD:Start(25-delay)
		timerStaticOverloadCD:Start(20-delay)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 82772 then
		frozenCount = frozenCount + 1
		frozenTargets[#frozenTargets + 1] = args.destName
		self:Unschedule(showFrozenWarning)
		self:Schedule(0.3, showFrozenWarning)
	elseif args.spellId == 82665 then
		warnHeartIce:Show(args.destName)
		timerHeartIce:Start(args.destName)
		if args:IsPlayer() then
			specWarnHeartIce:Show()
		end
		if self.Options.HeartIceIcon then
			self:SetIcon(args.destName, 6)
		end
	elseif args.spellId == 82660 then
		warnBurningBlood:Show(args.destName)
		timerBurningBlood:Start(args.destName)
		if args:IsPlayer() then
			specWarnBurningBlood:Show()
		end
		if self.Options.BurningBloodIcon then
			self:SetIcon(args.destName, 7)
		end
	elseif args.spellId == 83099 then
		lightningRodTargets[#lightningRodTargets + 1] = args.destName
		if args:IsPlayer() then
			isRod = true
			specWarnLightningRod:Show()
			if isBeacon then--You have lighting rod and frost beacon at same time.
				yellScrewed:Yell()
			else--You only have rod so do normal yell
				yellLightningRod:Yell()
			end
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if self.Options.LightningRodIcon then
			self:SetIcon(args.destName, lightningRodIcon)
			lightningRodIcon = lightningRodIcon - 1
		end
		self:Unschedule(showLightningRodWarning)
		if (self:IsDifficulty("normal25", "heroic25") and #lightningRodTargets >= 3) or (self:IsDifficulty("normal10", "heroic10") and #lightningRodTargets >= 1) then
			showLightningRodWarning()
		else
			self:Schedule(0.3, showLightningRodWarning)
		end
	elseif args.spellId == 82777 then
		if self:GetUnitCreatureId("target") == 43686 or self:GetBossTarget(43686) == DBM:GetUnitFullName("target") then--Warn if the boss casting it is your target, OR your target is the person its being cast on.
			warnFlameTorrent:Show()
		end
	elseif args.spellId == 82631 then--Aegis of Flame
		specWarnAegisFlame:Show()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(2, "enemyabsorb", nil, shieldHealth[(DBM:GetCurrentInstanceDifficulty())])
		end
	elseif args.spellId == 82762 and args:IsPlayer() then
		specWarnWaterLogged:Show()
	elseif args.spellId == 84948 then
		gravityCrushTargets[#gravityCrushTargets + 1] = args.destName
		timerGravityCrushCD:Start()
		if self.Options.GravityCrushIcon then
			self:SetIcon(args.destName, gravityCrushIcon)
			gravityCrushIcon = gravityCrushIcon - 1
		end
		self:Unschedule(showGravityCrushWarning)
		if (self:IsDifficulty("normal25", "heroic25") and #gravityCrushTargets >= 3) or (self:IsDifficulty("normal10", "heroic10") and #gravityCrushTargets >= 1) then
			showGravityCrushWarning()
		else
			self:Schedule(0.3, showGravityCrushWarning)
		end
	elseif args.spellId == 92307 then
		warnFrostBeacon:Show(args.destName)
		if args:IsPlayer() then
			isBeacon = true
			specWarnFrostBeacon:Show()
			if isRod then--You have lighting rod and frost beacon at same time.
				yellScrewed:Yell()
			else--You only have beacon so do normal yell
				yellFrostbeacon:Yell()
			end
		end
		if self.Options.FrostBeaconIcon then
			self:SetIcon(args.destName, 3)
		end
		if self:AntiSpam(18, 1) then -- sometimes Frost Beacon change targets, show only new Frost orbs.
			timerFrostBeaconCD:Start()
		end
	elseif args.spellId == 92067 then--All other spell IDs are jump spellids, do not add them in or we'll have to scan source target and filter them.
		warnStaticOverload:Show(args.destName)
		timerStaticOverloadCD:Start()
		if self.Options.StaticOverloadIcon then
			self:SetIcon(args.destName, 4)
		end
		if args:IsPlayer() then
			specWarnStaticOverload:Show()
			yellStaticOverload:Yell()
		end
	elseif args.spellId == 92075 then
		warnGravityCore:Show(args.destName)
		timerGravityCoreCD:Start()
		if self.Options.GravityCoreIcon then
			self:SetIcon(args.destName, 5)
		end
		if args:IsPlayer() then
			specWarnGravityCore:Show()
			yellGravityCore:Yell()
		end
	end
end

function mod:SPELL_AURA_REFRESH(args)--We do not combine refresh with applied cause it causes issues with burning blood/heart of ice.
	if args.spellId == 82772 then
		frozenCount = frozenCount + 1
		frozenTargets[#frozenTargets + 1] = args.destName
		self:Unschedule(showFrozenWarning)
		self:Schedule(0.3, showFrozenWarning)
	elseif args.spellId == 83099 then
		lightningRodTargets[#lightningRodTargets + 1] = args.destName
		if args:IsPlayer() then
			isRod = true
			specWarnLightningRod:Show()
			if isBeacon then--You have lighting rod and frost beacon at same time.
				yellScrewed:Yell()
			else--You only have rod so do normal yell
				yellLightningRod:Yell()
			end
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if self.Options.LightningRodIcon then
			self:SetIcon(args.destName, lightningRodIcon)
			lightningRodIcon = lightningRodIcon - 1
		end
		self:Unschedule(showLightningRodWarning)
		if (self:IsDifficulty("normal25", "heroic25") and #lightningRodTargets >= 3) or (self:IsDifficulty("normal10", "heroic10") and #lightningRodTargets >= 1) then
			showLightningRodWarning()
		else
			self:Schedule(0.3, showLightningRodWarning)
		end
	elseif args.spellId == 82762 and args:IsPlayer() then
		specWarnWaterLogged:Show()
	elseif args.spellId == 84948 then
		gravityCrushTargets[#gravityCrushTargets + 1] = args.destName
		timerGravityCrushCD:Start()
		if self.Options.GravityCrushIcon then
			self:SetIcon(args.destName, gravityCrushIcon)
			gravityCrushIcon = gravityCrushIcon - 1
		end
		self:Unschedule(showGravityCrushWarning)
		if (self:IsDifficulty("normal25", "heroic25") and #gravityCrushTargets >= 3) or (self:IsDifficulty("normal10", "heroic10") and #gravityCrushTargets >= 1) then
			showGravityCrushWarning()
		else
			self:Schedule(0.3, showGravityCrushWarning)
		end
	elseif args.spellId == 92307 then
		warnFrostBeacon:Show(args.destName)
		if args:IsPlayer() then
			isBeacon = true
			specWarnFrostBeacon:Show()
			if isRod then--You have lighting rod and frost beacon at same time.
				yellScrewed:Yell()
			else--You only have beacon so do normal yell
				yellFrostbeacon:Yell()
			end
		end
		if self.Options.FrostBeaconIcon then
			self:SetIcon(args.destName, 3)
		end
	elseif args.spellId == 92067 then--All other spell IDs are jump spellids, do not add them in or we'll have to scan source target and filter them.
		warnStaticOverload:Show(args.destName)
		timerStaticOverloadCD:Start()
		if self.Options.StaticOverloadIcon then
			self:SetIcon(args.destName, 4)
		end
		if args:IsPlayer() then
			specWarnStaticOverload:Show()
			yellStaticOverload:Yell()
		end
	elseif args.spellId == 92075 then
		warnGravityCore:Show(args.destName)
		timerGravityCoreCD:Start()
		if self.Options.GravityCoreIcon then
			self:SetIcon(args.destName, 5)
		end
		if args:IsPlayer() then
			specWarnGravityCore:Show()
			yellGravityCore:Yell()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 82665 then
		timerHeartIce:Cancel(args.destName)
		if self.Options.HeartIceIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 82660 then
		timerBurningBlood:Cancel(args.destName)
		if self.Options.BurningBloodIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 82772 then
		frozenCount = frozenCount - 1
		if frozenCount == 0 then
			timerFrozen:Cancel()
		end
	elseif args.spellId == 83099 then
		timerLightningRod:Cancel(args.destName)
		if args:IsPlayer() then
			isRod = false
		end
		if self.Options.LightningRodIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 84948 then
		timerGravityCrush:Cancel(args.destName)
		if self.Options.GravityCrushIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 92307 then
		if args:IsPlayer() then
			isBeacon = false
		end
		if self.Options.FrostBeacondIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 92067 then
		if self.Options.StaticOverloadIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 92075 then
		if self.Options.GravityCoreIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 82631 then	-- Shield Removed
		if self:IsMelee() and (self:GetUnitCreatureId("target") == 43686 or self:GetUnitCreatureId("focus") == 43686) or not self:IsMelee() then
			specWarnRisingFlames:Show(args.sourceName)--Only warn for melee targeting him or exclicidly put him on focus, else warn regardless if he's your target/focus or not if you aren't a melee
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 82746 then
		timerGlaciate:Start()
		if self:GetUnitCreatureId("target") == 43687 then--Only warn if targeting/tanking this boss.
			warnGlaciate:Show()
			specWarnGlaciate:Show()
		end
	elseif args.spellId == 82752 then
		if self:IsMelee() and (self:GetUnitCreatureId("target") == 43687 or self:GetUnitCreatureId("focus") == 43687) or not self:IsMelee() then
			specWarnHydroLance:Show(args.sourceName)--Only warn for melee targeting him or exclicidly put him on focus, else warn regardless if he's your target/focus or not if you aren't a melee
		end
		timerHydroLanceCD:Show()
	elseif args.spellId == 82699 then
		warnWaterBomb:Show()
		timerWaterBomb:Start()
	elseif args.spellId == 83675 then
		warnEruption:Show()
		specWarnEruption:Show()
		timerEruptionCD:Start()
	elseif args.spellId == 83718 then
		warnHardenSkin:Show()
		timerHardenSkinCD:Start()
		if self:IsMelee() and (self:GetUnitCreatureId("target") == 43689 or self:GetUnitCreatureId("focus") == 43689) or not self:IsMelee() then
			specWarnHardenedSkin:Show(args.sourceName)--Only warn for melee targeting him or exclicidly put him on focus, else warn regardless if he's your target/focus or not if you aren't a melee
		end
	elseif args.spellId == 83565 then
		infoFrameUpdated = false
		warnQuake:Show()
		timerQuakeCD:Cancel()
		timerQuakeCast:Start()
		timerThundershockCD:Start()
		self:Schedule(5, checkGrounded, self)
	elseif args.spellId == 83087 then
		warnDisperse:Show()
		timerDisperse:Start()
	elseif args.spellId == 83070 then
		warnLightningBlast:Show()
		timerLightningBlast:Start()
		specWarnLightningBlast:Show()
	elseif args.spellId == 83067 then
		infoFrameUpdated = false
		warnThundershock:Show()
		timerThundershockCD:Cancel()
		timerThundershockCast:Start()
		timerQuakeCD:Start()
		self:Schedule(5, checkSearingWinds, self)
	elseif args.spellId == 84913 then
		warnLavaSeed:Show()
		timerLavaSeedCD:Start()
	elseif args.spellId == 92212 then
		warnFlameStrike:Show()
		timerFlameStrikeCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 82636 then
		timerAegisFlame:Start()
	elseif args.spellId == 82665 then
		timerHeartIceCD:Start()
	elseif args.spellId == 82660 then
		timerBurningBloodCD:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if (msg == L.Quake or msg:find(L.Quake)) and phase == 2 then
		timerQuakeCD:Update(23, 33)
		warnQuakeSoon:Show()
		checkSearingWinds(self)
		if self:IsDifficulty("heroic10", "heroic25") then
			self:Schedule(3.3, checkSearingWinds, self)
			self:Schedule(6.6, checkSearingWinds, self)
		end
	elseif (msg == L.Thundershock or msg:find(L.Thundershock)) and phase == 2 then
		timerThundershockCD:Update(23, 33)
		warnThundershockSoon:Show()
		checkGrounded(self)
		if self:IsDifficulty("heroic10", "heroic25") then
			self:Schedule(3.3, checkGrounded, self)
			self:Schedule(6.6, checkGrounded, self)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
--	"<60.5> Feludius:Possible Target<nil>:boss1:Frost Xplosion (DND)::0:94739"
	if spellId == 94739 and self:AntiSpam(2, 2) then -- Frost Xplosion (Phase 2 starts)
		self:SendSync("Phase2")
--	"<105.3> Terrastra:Possible Target<Omegal>:boss3:Elemental Stasis::0:82285"
	elseif spellId == 82285 and self:AntiSpam(2, 2)  then -- Elemental Stasis (Phase 3 Transition)
		self:SendSync("PhaseTransition")
--	"<122.0> Elementium Monstrosity:Possible Target<nil>:boss1:Electric Instability::0:84526"
	elseif spellId == 84526 and self:AntiSpam(2, 2) then -- Electric Instability (Phase 3 Actually started)
		self:SendSync("Phase3")
	end
end

function mod:UNIT_HEALTH(uId)
	if (uId == "boss1" or uId == "boss2" or uId == "boss3" or uId == "boss4") and self:IsInCombat() then
		if UnitHealth(uId)/UnitHealthMax(uId) <= 0.30 then
			local cid = self:GetUnitCreatureId(uId)
			if (cid == 43686 or cid == 43687 or cid == 43688 or cid == 43689) and not sentLowHP[cid] then
				sentLowHP[cid] = true
				self:SendSync("lowhealth", UnitName(uId))
			end
		end
	end
end

function mod:OnSync(msg, boss)
	if msg == "lowhealth" and boss and not warnedLowHP[boss] then
		warnedLowHP[boss] = true
		specWarnBossLow:Show(boss)
	elseif msg == "Phase2" and self:IsInCombat() then
		phase = 2
		timerWaterBomb:Cancel()
		timerGlaciate:Cancel()
		timerAegisFlame:Cancel()
		timerBurningBloodCD:Cancel()
		timerHeartIceCD:Cancel()
		timerGravityCoreCD:Cancel()
		timerStaticOverloadCD:Cancel()
		timerHydroLanceCD:Cancel()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerFrostBeaconCD:Start(25)
			timerFlameStrikeCD:Start(28)
		end
		timerQuakeCD:Start()
		self:Schedule(3, checkSearingWinds)
	elseif msg == "PhaseTransition" and self:IsInCombat() then
		self:Unschedule(checkSearingWinds)
		self:Unschedule(checkGrounded)
		timerQuakeCD:Cancel()
		timerThundershockCD:Cancel()
		timerHardenSkinCD:Cancel()
		timerEruptionCD:Cancel()
		timerDisperse:Cancel()
		timerFlameStrikeCD:Cancel()
		timerTransition:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif msg == "Phase3" and self:IsInCombat() then
		phase = 3
		timerFrostBeaconCD:Cancel()--Cancel here to avoid problems with orbs that spawn during the transition.
		timerLavaSeedCD:Start(18)
		timerGravityCrushCD:Start(28)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	end
end

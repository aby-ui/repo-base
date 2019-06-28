local mod	= DBM:NewMod(167, "DBM-BastionTwilight", nil, 72)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(43324)
mod:SetEncounterID(1029)
mod:SetZone()
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Chogall\\VO_BT_Chogall_BotEvent15.ogg", "Sound\\Creature\\Chogall\\VO_BT_Chogall_BotEvent42.ogg")
--Long: Foolish mortals-(Usurper's children!) nothing you have done- (Spawn of a lesser god!) I am TRYING to speak here. (Words, words, words. The Master wants murder.) ALL falls to chaos. ALL will be destroyed. (Chaos, chaos!) Your work here today changes nothing. (Chaos, chaos, all things end) No mortal may see what you have and live. Your end has come.
--Short: (The Master sees, the Master sees!)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_HEALTH boss1",
	"UNIT_AURA player"
)

local warnWorship					= mod:NewTargetAnnounce(91317, 3)--Phase 1
local warnFury						= mod:NewSpellAnnounce(82524, 3, nil, "Tank|Healer")--Phase 1
local warnAdherent					= mod:NewSpellAnnounce(81628, 4)--Phase 1
local warnShadowOrders				= mod:NewSpellAnnounce(81556, 3, nil, "Dps")--Warning is disabled on normal mode, it has no use there
local warnFlameOrders				= mod:NewSpellAnnounce(81171, 3, nil, "Dps")--This one is also disabled on normal.
local warnFlamingDestruction		= mod:NewSpellAnnounce(81194, 4, nil, "Tank|Healer")
local warnEmpoweredShadows			= mod:NewSpellAnnounce(81572, 4, nil, "Healer")
local warnCorruptingCrash			= mod:NewTargetAnnounce(81685, 2, nil, false)
local warnPhase2					= mod:NewPhaseAnnounce(2)
local warnPhase2Soon				= mod:NewPrePhaseAnnounce(2)
local warnCreations					= mod:NewSpellAnnounce(82414, 3)--Phase 2

local specWarnSickness				= mod:NewSpecialWarningYou(82235, "Melee")--Ranged should already be spread out and not need a special warning every sickness.
local specWarnBlaze					= mod:NewSpecialWarningMove(81538)
local specWarnWorship				= mod:NewSpecialWarningSpell(91317, false)
local specWarnEmpoweredShadows		= mod:NewSpecialWarningSpell(81572, "Healer", nil, nil, true)
local specWarnCorruptingCrash		= mod:NewSpecialWarningMove(81685)--Subject to accuracy flaws in rare cases but most of the time it's right.
local specWarnCorruptingCrashNear	= mod:NewSpecialWarningClose(81685)--^^
local yellCrash						= mod:NewYell(81685)--^^
local specWarnDepravity				= mod:NewSpecialWarningInterrupt(81713)--On by default cause these things don't get interrupted otherwise. but will only warn if it's target.
local specwarnFury					= mod:NewSpecialWarningTarget(82524, "Tank")
local specwarnFlamingDestruction	= mod:NewSpecialWarningSpell(81194, "Tank")

local timerWorshipCD				= mod:NewCDTimer(36, 91303, nil, nil, nil, 3, nil, DBM_CORE_INTERRUPT_ICON)
local timerAdherent					= mod:NewCDTimer(92, 81628, nil, nil, nil, 1)
local timerFesterBlood				= mod:NewNextTimer(40, 82299, nil, nil, nil, 1)--40 seconds after an adherent is summoned
local timerFlamingDestruction		= mod:NewBuffActiveTimer(10, 81194, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerEmpoweredShadows			= mod:NewBuffActiveTimer(9, 81572, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerFuryCD					= mod:NewCDTimer(47, 82524, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)--47-48 unless a higher priority ability is channeling (such as summoning adds or MC)
local timerCreationsCD				= mod:NewNextTimer(30, 82414, nil, nil, nil, 1)
local timerSickness					= mod:NewBuffFadesTimer(5, 82235)
local timerFlamesOrders				= mod:NewNextTimer(25, 81171, nil, "Dps", nil, 1, nil, DBM_CORE_DAMAGE_ICON)--Orders are when he summons elemental
local timerShadowsOrders			= mod:NewNextTimer(25, 81556, nil, "Dps", nil, 1, nil, DBM_CORE_DAMAGE_ICON)--These are more for dps to switch to them to lower em so useless for normal mode
local timerFlamingDestructionCD		= mod:NewNextTimer(20, 81194, nil, "Tank|Healer", nil, 5)--Timer for when the special actually goes off (when he absorbs elemental)
local timerEmpoweredShadowsCD		= mod:NewNextTimer(20, 81572, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)--^^
local timerDepravityCD				= mod:NewCDTimer(12, 81713, nil, "HasInterrupt", 2, 4, nil, DBM_CORE_INTERRUPT_ICON)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddBoolOption("SetIconOnWorship", true)
mod:AddSetIconOption("SetIconOnCreature", 82411, false, true)
mod:AddBoolOption("CorruptingCrashArrow", true)
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("InfoFrame")

local worshipTargets = {}
local prewarned_Phase2 = false
local firstFury = false
local worshipIcon = 8
local worshipCooldown = 20.5
local shadowOrdersCD = 15
local Corruption = DBM:GetSpellInfo(82235)
local Bloodlevel = DBM:EJ_GetSectionInfo(3165)

local function showWorshipWarning()
	warnWorship:Show(table.concat(worshipTargets, "<, >"))
	table.wipe(worshipTargets)
	worshipIcon = 8
	timerWorshipCD:Start(worshipCooldown)
	specWarnWorship:Show()
end

function mod:CorruptingCrashTarget(sGUID)
	local targetname = nil
	for uId in DBM:GetGroupMembers() do
		if UnitGUID(uId.."target") == sGUID then
			targetname = DBM:GetUnitFullName(uId.."targettarget")
			break
		end
	end
	if not targetname then return end
	warnCorruptingCrash:Show(targetname)
	if targetname == UnitName("player") then
		specWarnCorruptingCrash:Show()
		yellCrash:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = CheckInteractDistance(uId, 2)
			if inRange then
				specWarnCorruptingCrashNear:Show(targetname)
				if self.Options.CorruptingCrashArrow then
					local x, y = UnitPosition(uId)
					DBM.Arrow:ShowRunAway(x, y, 10, 5)
				end
			end
		end
	end
end

function mod:OnCombatStart(delay)
	timerFlamesOrders:Start(5-delay)
	timerWorshipCD:Start(10-delay)
	table.wipe(worshipTargets)
	prewarned_Phase2 = false
	firstFury = false
	worshipIcon = 8
	worshipCooldown = 20.5
	shadowOrdersCD = 15
	berserkTimer:Start(-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(Bloodlevel)
		DBM.InfoFrame:Show(5, "playerpower", 10, ALTERNATE_POWER_INDEX)
	end
end	

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end 

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 91317 then
		worshipTargets[#worshipTargets + 1] = args.destName
		if self.Options.SetIconOnWorship then
			self:SetIcon(args.destName, worshipIcon)
			worshipIcon = worshipIcon - 1
		end
		self:Unschedule(showWorshipWarning)
		if (self:IsDifficulty("normal25", "heroic25") and #worshipTargets >= 4) or (self:IsDifficulty("normal10", "heroic10") and #worshipTargets >= 2) then
			showWorshipWarning()
		else
			self:Schedule(0.3, showWorshipWarning)
		end
	elseif args.spellId == 81194 then
		warnFlamingDestruction:Show()
		if self:GetUnitCreatureId("target") == 43324 or self:GetBossTarget(43324) == DBM:GetUnitFullName("target") then--Add tank doesn't need this spam, just tank on chogal and healers healing that tank.
			specwarnFlamingDestruction:Show()
		end
		timerFlamingDestruction:Start()
	elseif args.spellId == 81572 then
		warnEmpoweredShadows:Show()
		specWarnEmpoweredShadows:Show()
		timerEmpoweredShadows:Start()
	elseif args.spellId == 82518 then
		specwarnFury:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 91317 then
		if self.Options.SetIconOnWorship then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 81628 then
		warnAdherent:Show()
		timerAdherent:Start()
		timerFesterBlood:Start()
	elseif args.spellId == 82524 then
		warnFury:Show()
		timerFuryCD:Start()
		if not firstFury then--85% fury of chogal, it resets cd on worship and changes cd to 36
			firstFury = true
			worshipCooldown = 36
			shadowOrdersCD = 25
			timerWorshipCD:Start(10)--worship is 10 seconds after first fury, regardless of what timer was at before 85%
			timerShadowsOrders:Cancel()--Cancel shadows orders timer, flame is going to be next.
			timerFlamesOrders:Start(15)--Flames orders is 15 seconds after first fury, regardless whether or not shadow was last.
		end
	elseif args.spellId == 82411 then -- Creatures are channeling after their spawn.
		if self.Options.SetIconOnCreature then
			if self:IsDifficulty("normal25", "heroic25") then
				self:ScanForMobs(args.destGUID, 0, 8, 8, 0.1, 20, "SetIconOnCreature")
			else
				self:ScanForMobs(args.destGUID, 0, 8, 4, 0.1, 20, "SetIconOnCreature")
			end
		end
	elseif args.spellId == 81713 then
		if args.sourceGUID == UnitGUID("target") then--Only show warning for your own target.
			specWarnDepravity:Show(args.sourceName)
			if self:IsDifficulty("normal10", "heroic10") then
				timerDepravityCD:Start()--every 12 seconds on 10 man from their 1 adherent, can be solo interrupted.
			else
				timerDepravityCD:Start(6)--every 6 seconds on 25 man (unless interrupted by a mage then 7.5 cause of school lockout)
			end
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 82414 then
		warnCreations:Show()
		if self:IsDifficulty("heroic10", "heroic25") then -- other difficulty not sure, only comfirmed 25 man heroic
			timerCreationsCD:Start(40)
		else
			timerCreationsCD:Start()
		end
	elseif args.spellId == 82630 then
		warnPhase2:Show()
		timerAdherent:Cancel()
		timerWorshipCD:Cancel()
		timerFesterBlood:Cancel()
		timerFlamesOrders:Cancel()
		timerShadowsOrders:Cancel()
	elseif args.spellId == 81556 then--Shadow's Orders
		if self:IsDifficulty("heroic10", "heroic25") then
			warnShadowOrders:Show()--No reason to do this warning on normal, nothing spawns so nothing you can do about it.
			timerEmpoweredShadowsCD:Start()--Time til he actually absorbs elemental and gains it's effects
			timerFlamesOrders:Start()--always 25 seconds after shadows orders, regardless of phase.
		else
			timerEmpoweredShadowsCD:Start(10.8)--Half the time on normal since you don't actually have to kill elementals plus the only thing worth showing on normal.
		end
	elseif args.spellId == 81171 then--Flame's Orders
		if self:IsDifficulty("heroic10", "heroic25") then
			warnFlameOrders:Show()--No reason to do this warning on normal, nothing spawns so nothing you can do about it.
			timerFlamingDestructionCD:Start()--Time til he actually absorbs elemental and gains it's effects
			timerShadowsOrders:Start(shadowOrdersCD)--15 seconds after a flame order above 85%, 25 seconds after a flame orders below 85%
		else
			timerFlamingDestructionCD:Start(10.8)--Half the time on normal since you don't actually have to kill elementals plus the only thing worth showing on normal.
		end
	elseif args.spellId == 81685 then
		self:ScheduleMethod(0.2, "CorruptingCrashTarget", args.sourceGUID)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 81538 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then
		specWarnBlaze:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 43324 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 40 and prewarned_Phase2 then
			prewarned_Phase2 = false
		elseif not prewarned_Phase2 and (h > 27 and h < 30) then
			warnPhase2Soon:Show()
			prewarned_Phase2 = true
		end
	end
end

function mod:UNIT_AURA(uId)
	if DBM:UnitDebuff("player", Corruption) and self:AntiSpam(7, 2) then
		specWarnSickness:Show()
		timerSickness:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	end
end

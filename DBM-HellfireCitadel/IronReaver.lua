local mod	= DBM:NewMod(1425, "DBM-HellfireCitadel", nil, 669)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(90284)
mod:SetEncounterID(1785)
mod:SetZone()
mod:SetUsedIcons(4, 3, 2)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 186684 186666 186660 188293 182523",
	"SPELL_CAST_START 179889 182066 186449 181999 185282 182055 182668",
	"SPELL_AURA_APPLIED 182280 182020 182074 182001",
	"SPELL_AURA_APPLIED_DOSE 182074",
	"SPELL_AURA_REMOVED 182280",
	"SPELL_DAMAGE 182523",
	"SPELL_MISSED 182523",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, check falling slam for target scanning.
--TODO, see if one of the instance cast spellids are earlier than channeled casts for falling slam
--TODO, add timer with count 2 for artillery fading on player
local warnArtillery					= mod:NewTargetCountAnnounce(182280, 4)
local warnUnstableOrb				= mod:NewTargetCountAnnounce(182001, 3, nil, false)--Off by default do to some frequent casts. Boss fires 2 orbs. anyone then hit on landing gets debuff, if ranged properly spread, 2 targets, if numpty, could be 30 targets
local warnFuelStreak				= mod:NewCountAnnounce(182668, 3)

local specWarnArtillery				= mod:NewSpecialWarningMoveAway(182280, nil, nil, nil, 3, 2)
local yellArtillery					= mod:NewFadesYell(182108)
local specWarnImmolation			= mod:NewSpecialWarningMove(182074, nil, nil, nil, 1, 2)
local specWarnBarrage				= mod:NewSpecialWarningCount(185282, nil, nil, nil, 2, 5)--Count probably better than dodge
local specWarnPounding				= mod:NewSpecialWarningCount(182020, nil, nil, nil, 2, 2)
local specWarnBlitz					= mod:NewSpecialWarningCount(179889, nil, nil, nil, 2, 2)--Count probably better than dodge
local specWarnFullCharge			= mod:NewSpecialWarningSpell(182055, nil, nil, nil, 1, 2)--Phase change
local specWarnFallingSlam			= mod:NewSpecialWarningSpell(182066, nil, nil, nil, 2, 2)--Phase change
local specWarnFirebomb				= mod:NewSpecialWarningSwitchCount(181999, "-Healer", nil, nil, 1, 5)

--mod:AddTimerLine(ALL)--Uncomment when ground phase and air phase are done, don't want to enable this line now and incorrectly flag everything as "All"
local timerArtilleryCD				= mod:NewNextCountTimer(15, 182108, nil, nil, nil, 3, nil, nil, nil, 3, 4)
--mod:AddTimerLine(ALL)--Find translation that works for "Ground Phase"
local timerUnstableOrbCD			= mod:NewNextCountTimer(24, 182001, nil, "Ranged", 2, 3)
local timerPoundingCD				= mod:NewNextCountTimer(24, 182020, nil, nil, nil, 2)
local timerBlitzCD					= mod:NewNextCountTimer(5, 179889, nil, nil, nil, 3)
local timerBarrageCD				= mod:NewNextCountTimer(15, 185282, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerFullChargeCD				= mod:NewNextTimer(136, 182055, nil, nil, nil, 6)
--mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)--Find translation that works for "Air Phase"
local timerFallingSlamCD			= mod:NewNextTimer(54, 182066, nil, nil, nil, 6)
local timerFuelLeakCD				= mod:NewNextCountTimer(15, 182668, nil, nil, nil, 2)--Fire bombs always immediately after, so no timer needed
local timerVolatileBombCD			= mod:NewNextCountTimer(15, 182534, nil, nil, nil, 1)

local berserkTimer					= mod:NewBerserkTimer(514)

mod:AddRangeFrameOption("8/30")
mod:AddSetIconOption("SetIconOnArtillery", 182280, true)
mod:AddHudMapOption("HudMapOnArt", 182108)
mod:AddInfoFrameOption(181999)

mod.vb.artilleryActive = 0--Number of debuffs count. Room is MASSIVE and combat log range could be an issue. Unsure at this time. DBM didn't seem to miss any artillery debuffs in testing.
mod.vb.groundPhase = true
mod.vb.tankIcon = 2
mod.vb.artilleryCount = 0--Cast count
mod.vb.barrageCount = 0
mod.vb.poundingCount = 0
mod.vb.blitzCount = 0
mod.vb.unstableOrbCount = 0
mod.vb.firebombCount = 0
mod.vb.fuelCount = 0
mod.vb.volatileCount = 0
mod.vb.quickfuseCount = 0
mod.vb.reactiveCount = 0
mod.vb.burningCount = 0
mod.vb.reinforcedCount = 0
--All timers are energy based and scripted. boss uses x ability at y energy.
--These tables establish the cast sequence by ability.
--If energy rates are different in different modes, then each table will need to be different.
--These tables are Heroic/LFR timers. Hopefully all modes the same. If not, easily fixed
local artilleryTimers = {9, 9, 30, 15, 9, 24, 15}--Phase 1, phase 2 is just 15
local artilleryTimersN = {9, 39, 15, 33, 15}
local barrageTimers = {11.7, 30, 12, 45}
local blitzTimers = {63, 5, 58, 4.7}
local unstableOrbsTimers = {3, 18, 24, 24, 24}--Nerfed considerbly, useful now.
local poundingTimers = {32.6, 54, 24}

local debuffFilter
local debuffName, reactiveName, burningName, quickfuseName, reinforcedName, volatileName = DBM:GetSpellInfo(182280), DBM:GetSpellInfo(186676), DBM:GetSpellInfo(186667), DBM:GetSpellInfo(186660), DBM:GetSpellInfo(188294), DBM:GetSpellInfo(182523)
do
	debuffFilter = function(uId)
		if DBM:UnitDebuff(uId, debuffName) then
			return true
		end
	end
end

local updateInfoFrame
do
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		table.wipe(lines)
		table.wipe(sortedLines)
		local total = mod.vb.burningCount + mod.vb.reactiveCount + mod.vb.quickfuseCount + mod.vb.volatileCount + mod.vb.reinforcedCount
		if total == 0 then--None found, hide infoframe because all bombs dead
			DBM.InfoFrame:Hide()
		end
		if mod.vb.reactiveCount > 0 then
			if mod:IsTank() then
				addLine("|cff00ffff"..reactiveName.."|r", mod.vb.reactiveCount)
			else
				addLine(reactiveName, mod.vb.reactiveCount)
			end
		end
		if mod.vb.burningCount > 0 then
			addLine(burningName, mod.vb.burningCount)
		end
		if mod.vb.quickfuseCount > 0 then
			if mod:IsDps() then
				addLine("|cff00ffff"..quickfuseName.."|r", mod.vb.quickfuseCount)
			else
				addLine(quickfuseName, mod.vb.quickfuseCount)
			end
		end
		if mod.vb.reinforcedCount > 0 then
			addLine(reinforcedName, mod.vb.reinforcedCount)
		end
		if mod.vb.volatileCount > 0 then
			addLine(volatileName, mod.vb.volatileCount)
		end
		return lines, sortedLines
	end
end

local function updateRangeFrame(self)
	if not self.Options.RangeFrame or not self:IsInCombat() then return end
	if (self:IsMelee() or not self.vb.groundPhase) and self.vb.artilleryActive > 0 then--Artillery
		if DBM:UnitDebuff("player", debuffName) then
			DBM.RangeCheck:Show(30, nil)
		else
			DBM.RangeCheck:Show(30, debuffFilter)
		end
	elseif self:IsRanged() and self.vb.groundPhase then--Unstable Orb
		DBM.RangeCheck:Show(8)
	else
		DBM.RangeCheck:Hide()
	end
end

function mod:OnCombatStart(delay)
	self.vb.artilleryActive = 0--Only one that should reset on pull
	self.vb.volatileCount = 0
	self.vb.quickfuseCount = 0
	self.vb.reactiveCount = 0
	self.vb.burningCount = 0
	self.vb.reinforcedCount = 0
	updateRangeFrame(self)
	--berserkTimer:Start(-delay)
	--Boss uses "Ground Phase" trigger after pull. Do not start timers here
	--No reason to reset variables here either, they also reset on ground phase trigger 1 second after pull
	if self:IsMythic() then
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.HudMapOnArt then
		DBMHudMap:Disable()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end 

--(ability.id = 186684 or ability.id = 186666 or ability.id = 186660 or ability.id = 188293 or ability.id = 182523) and type = "cast"
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	--bombs exploding
	if spellId == 186684 then--Reactive
		self.vb.reactiveCount = self.vb.reactiveCount - 1
	elseif spellId == 186666 then--Burning
		self.vb.burningCount = self.vb.burningCount - 1
	elseif spellId == 186660 then--Quick-Fuse
		self.vb.quickfuseCount = self.vb.quickfuseCount - 1
	elseif spellId == 188293 then--Reinforced
		self.vb.reinforcedCount = self.vb.reinforcedCount - 1
	elseif spellId == 182523 then--Volatile
		self.vb.volatileCount = self.vb.volatileCount - 1
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 179889 then
		self.vb.blitzCount = self.vb.blitzCount + 1
		specWarnBlitz:Show(self.vb.blitzCount)
		specWarnBlitz:Play("chargemove")
		local cooldown = blitzTimers[self.vb.blitzCount+1]
		if cooldown then
			timerBlitzCD:Start(cooldown, self.vb.blitzCount+1)
		end
	elseif spellId == 182066 or spellId == 186449 then--182066 confirmed on heroic. Mythic uses 186449 (Confirmed)
		specWarnFallingSlam:Show()
		updateRangeFrame(self)
		specWarnFallingSlam:Play("phasechange")
		specWarnFallingSlam:ScheduleVoice(1.5, "watchstep")
	elseif spellId == 181999 then
		self.vb.firebombCount = self.vb.firebombCount + 1
		local count = self.vb.firebombCount
		specWarnFirebomb:Show(count)
		specWarnFirebomb:Play("attbomb")
		if self.vb.groundPhase then--Should only happen on mythic
			self.vb.volatileCount = self.vb.volatileCount + 5
			if count == 1 then
				timerVolatileBombCD:Start(42, count+1)
			elseif count == 2 then
				timerVolatileBombCD:Start(69, count+1)
			end
		else
			timerVolatileBombCD:Start(15, self.vb.firebombCount+1)--Always 2 seconds after fuel streak, seems redundant to have both. Keeping for now.
			if self:IsMythic() then
				self.vb.reactiveCount = self.vb.reactiveCount + 3
				self.vb.burningCount = self.vb.burningCount + 3
				self.vb.quickfuseCount = self.vb.quickfuseCount + 4
				self.vb.reinforcedCount = self.vb.reinforcedCount + 1
			else
				self.vb.volatileCount = self.vb.volatileCount + 5
			end
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(5, "function", updateInfoFrame)
		end
	elseif spellId == 185282 then
		self.vb.barrageCount = self.vb.barrageCount + 1
		specWarnBarrage:Show(self.vb.barrageCount)
		local cooldown = barrageTimers[self.vb.barrageCount+1]
		if cooldown then
			timerBarrageCD:Start(cooldown, self.vb.barrageCount+1)
		end
		specWarnBarrage:Play("185282")
	elseif spellId == 182055 then
		self.vb.groundPhase = false
		self.vb.fuelCount = 0
		self.vb.firebombCount = 0
		self.vb.artilleryCount = 0--Also used in air phase, with it's own air phase counter
		if not self:IsMythic() then
			self.vb.volatileCount = 0--Only reset on non mythic, on mythic these are left over from ground phase
		else
			self.vb.quickfuseCount = 0
			self.vb.reactiveCount = 0
			self.vb.burningCount = 0
			self.vb.reinforcedCount = 0
		end
		specWarnFullCharge:Show()
		timerFuelLeakCD:Start(9, 1)
		timerArtilleryCD:Start(9, 1)
		timerFallingSlamCD:Start()
		specWarnFullCharge:Play("phasechange")
	elseif spellId == 182668 then
		self.vb.fuelCount = self.vb.fuelCount + 1
		warnFuelStreak:Show(self.vb.fuelCount)
		if self.vb.fuelCount < 3 then
			timerFuelLeakCD:Start(nil, self.vb.fuelCount+1)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 182280 then
		self.vb.artilleryActive = self.vb.artilleryActive + 1
		if self:AntiSpam(3, 1) then
			self.vb.artilleryCount = self.vb.artilleryCount + 1
			if self.vb.groundPhase then
				local timersTable = self:IsDifficulty("lfr", "normal") and artilleryTimersN or artilleryTimers
				local cooldown = timersTable[self.vb.artilleryCount+1]
				if cooldown and self:IsTank() then--Only show timer to tanks in phase 1
					timerArtilleryCD:Start(cooldown, self.vb.artilleryCount+1)
				end
			else
				if self.vb.artilleryCount < 3 then--Only 3 casts in air phase
					timerArtilleryCD:Start(15, self.vb.artilleryCount+1)
				end
			end
		end
		warnArtillery:CombinedShow(0.3, self.vb.artilleryCount, args.destName)
		if args:IsPlayer() then
			specWarnArtillery:Schedule(5)
			yellArtillery:Schedule(11.5, 1)
			yellArtillery:Schedule(10.5, 2)
			yellArtillery:Schedule(9.5, 3)
			yellArtillery:Schedule(8.5, 4)
			yellArtillery:Schedule(7.5, 5)
			yellArtillery:Schedule(5.5, 7)
			specWarnArtillery:ScheduleVoice(5, "runout")
		end
		if self.Options.SetIconOnArtillery then
			if self.vb.groundPhase then--1 target, alternating icons because two debuffs will overlap but not cast at same time
				self:SetIcon(args.destName, self.vb.tankIcon)
				if self.vb.tankIcon == 2 then
					self.vb.tankIcon = 3
				else
					self.vb.tankIcon = 2
				end
			else
				self:SetSortedIcon(0.5, args.destName, 2, 3)--3 targets at once
			end
		end
		if self.Options.HudMapOnArt then
			DBMHudMap:RegisterRangeMarkerOnPartyMember(spellId, "highlight", args.destName, 5, 13, 1, 1, 0, 0.5, nil, true, 1):Pulse(0.5, 0.5)
		end
		updateRangeFrame(self)
	elseif spellId == 182020 then
		self.vb.poundingCount = self.vb.poundingCount + 1
		specWarnPounding:Show(self.vb.poundingCount)
		specWarnPounding:Play("aesoon")
		local cooldown = poundingTimers[self.vb.poundingCount+1]
		if cooldown then
			timerPoundingCD:Start(cooldown, self.vb.poundingCount+1)
		end
	elseif spellId == 182074 and args:IsPlayer() and self:AntiSpam(2, 2) then
		specWarnImmolation:Show()
		specWarnImmolation:Play("runaway")
	elseif spellId == 182001 then
		warnUnstableOrb:CombinedShow(0.3, self.vb.unstableOrbCount, args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 182280 then
		self.vb.artilleryActive = self.vb.artilleryActive - 1
		if args:IsPlayer() then
			specWarnArtillery:Cancel()
			yellArtillery:Cancel()
		end
		if self.Options.SetIconOnArtillery then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.HudMapOnArt then
			DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
		end
		updateRangeFrame(self)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId) -- captures spellid 161612, 161576
	if spellId == 182523 and self:AntiSpam(5, 4) then
		self.vb.volatileCount = self.vb.volatileCount - 1
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 94326 then--Reactive
		self.vb.reactiveCount = self.vb.reactiveCount - 1
	elseif cid == 94322 then--Burning
		self.vb.burningCount = self.vb.burningCount - 1
	elseif cid == 94312 then--Quick-Fuse
		self.vb.quickfuseCount = self.vb.quickfuseCount - 1
	elseif cid == 94955 then--Reinforced
		self.vb.reinforcedCount = self.vb.reinforcedCount - 1
	elseif cid == 93717 then--Volatile
		self.vb.volatileCount = self.vb.volatileCount - 1
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 185250 and self:AntiSpam(2, 3) then--Unstable Orb Cast
		self.vb.unstableOrbCount = self.vb.unstableOrbCount + 1
		local cooldown = unstableOrbsTimers[self.vb.unstableOrbCount+1]
		if cooldown then
			timerUnstableOrbCD:Start(cooldown, self.vb.unstableOrbCount+1)
		end
	elseif spellId == 181923 then--Ground Phase (using this to start timers because it's more accurate than "falling" cast, because falling cast is shorter on mythic)
		--Reset Counts
		self.vb.groundPhase = true
		self.vb.tankIcon = 2
		self.vb.artilleryCount = 0
		self.vb.barrageCount = 0
		self.vb.poundingCount = 0
		self.vb.blitzCount = 0
		self.vb.unstableOrbCount = 0
		self.vb.firebombCount = 0
		--Start ground phase timers
		--Tiny variation in the firsts, 0.3-0.4, lowest times used. but for example 8.9 could be 9.3
		timerUnstableOrbCD:Start(3, 1)
		timerArtilleryCD:Start(8.9, 1)
		timerBarrageCD:Start(11.7, 1)
		timerPoundingCD:Start(32.6, 1)
		timerBlitzCD:Start(63, 1)
		timerFullChargeCD:Start()
		if self:IsMythic() then
			self.vb.volatileCount = 0--Only reset here on mythic, because THESE bombs are left over on non mythic when this happens
			timerVolatileBombCD:Start(9, 1)
		end
	end
end

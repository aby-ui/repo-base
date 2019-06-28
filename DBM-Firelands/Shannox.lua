local mod	= DBM:NewMod(195, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()
local Riplimb	= DBM:EJ_GetSectionInfo(2581)
local Rageface	= DBM:EJ_GetSectionInfo(2583)

mod:SetRevision("20190625143316")
mod:SetCreatureID(53691)
mod:SetEncounterID(1205)
mod:SetZone()
mod:SetUsedIcons(6, 8) -- cross(7) is hard to see in redish environment?
--mod:SetModelSound("Sound\\Creature\\SHANNOX\\VO_FL_SHANNOX_SPAWN.ogg", "Sound\\Creature\\SHANNOX\\VO_FL_SHANNOX_KILL_04.ogg")
--Long: Yes, I smell them too, Riplimb. Outsiders encroach on the Firelord's private grounds. Find their trail. Find them for me, that I may dispense punishment!
--Short: Dog food!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 100415 100167 99837 99937",
	"SPELL_AURA_APPLIED_DOSE 99945 99937",
	"SPELL_AURA_REMOVED 99945 99937",
	"SPELL_CAST_START 100002 99840",
	"SPELL_CAST_SUCCESS 99947",
	"SPELL_SUMMON 99836 99839",
	"UNIT_HEALTH boss1 boss2 boss3", -- probably needs just one (?)
	"UNIT_DIED"
)

local warnFaceRage				= mod:NewTargetAnnounce(99947, 4)
local warnRage					= mod:NewTargetAnnounce(100415, 3)
local warnWary					= mod:NewTargetAnnounce(100167, 2, nil, false)
local warnTears					= mod:NewStackAnnounce(99937, 3, nil, "Tank|Healer")
local warnSpear					= mod:NewSpellAnnounce(100002, 3)--warn for this instead of magmaflare until/if rip dies.
local warnMagmaRupture			= mod:NewSpellAnnounce(99840, 3)
local warnCrystalPrison			= mod:NewTargetAnnounce(99836, 2)--On by default, not as often, and useful for tanks or kiters
local warnImmoTrap				= mod:NewTargetAnnounce(99839, 2, nil, false)--Spammy, off by default for those who want it.
local warnCrystalPrisonTrapped	= mod:NewTargetAnnounce(99837, 4)--Player is in prison.
local warnPhase2Soon			= mod:NewPrePhaseAnnounce(2, 3)

local specWarnSpear				= mod:NewSpecialWarningSpell(100002, false)
local specWarnRage				= mod:NewSpecialWarningYou(100415)
local specWarnFaceRage			= mod:NewSpecialWarningTarget(99947, false)
local specWarnImmTrap			= mod:NewSpecialWarningMove(99839)
local specWarnImmTrapNear		= mod:NewSpecialWarningClose(99839)
local yellImmoTrap				= mod:NewYell(99839, nil, false)
local specWarnCrystalTrap		= mod:NewSpecialWarningMove(99836)
local specWarnCrystalTrapNear	= mod:NewSpecialWarningClose(99836)
local yellCrystalTrap			= mod:NewYell(99836)
local specWarnTears				= mod:NewSpecialWarningStack(99937, "Tank", 8)

local timerRage					= mod:NewTargetTimer(15, 100415)
local timerWary					= mod:NewTargetTimer(25, 100167, nil, false)
local timerTears				= mod:NewTargetTimer(26, 99937, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerCrystalPrison		= mod:NewTargetTimer(10, 99837)--Dogs Only
local timerCrystalPrisonCD		= mod:NewCDTimer(25.5, 99836, nil, nil, nil, 3)--Seems consistent timing, other trap is not.
local timerSpearCD				= mod:NewCDTimer(42, 100002, nil, nil, nil, 3)--Before riplimb dies
local timerMagmaRuptureCD		= mod:NewCDTimer(15, 99840, nil, nil, nil, 2)--After riplimb dies
local timerFaceRageCD			= mod:NewCDTimer(27, 99947, nil, false, nil, 5)--Has a 27-30 sec cd but off by default as it's subject to wild variation do to traps.

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("SetIconOnFaceRage", false)
mod:AddBoolOption("SetIconOnRage", false)

local prewarnedPhase2 = false
local ripLimbDead = false
local trapScansDone = 0

function mod:ImmoTrapTarget(targetname)
	warnImmoTrap:Show(targetname)
	if targetname == UnitName("player") then
		specWarnImmTrap:Show()
		yellImmoTrap:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 6 then
				specWarnImmTrapNear:Show(targetname)
			end
		end
	end
end

function mod:CrystalTrapTarget(targetname)
	warnCrystalPrison:Show(targetname)
	if targetname == UnitName("player") then
		specWarnCrystalTrap:Show()
		yellCrystalTrap:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 6 then
				specWarnCrystalTrapNear:Show(targetname)
			end
		end
	end
end

local function getBossuId()
	local UnitID
	if UnitExists("boss1") or UnitExists("boss2") or UnitExists("boss3") then
		for i = 1, 3 do
			if UnitName("boss"..i) == L.name then
				UnitID = "boss"..i
				break
			end
		end
	else
		for uId in DBM:GetGroupMembers() do
			if UnitName(uId.."target") == L.name and not UnitIsPlayer(uId.."target") then
				UnitID = uId.."target"
				break
			end			
		end
	end
	return UnitID
end

local function isTank(unit)
	-- 1. check blizzard tanks first
	-- 2. check blizzard roles second
	-- 3. check shannox's highest threat target
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end
	local uId = getBossuId()
	if uId and UnitExists(uId.."target") and UnitDetailedThreatSituation(unit, uId) then
		return true
	end
	return false
end

function mod:TrapHandler(SpellID, ScansDone)
	trapScansDone = trapScansDone + 1
	local targetname, uId = self:GetBossTarget(53691)
	-- UnitExists also accepts not unit id but unitname. so we can use unitname as UnitExists parameter. and it also works with player controlled pet.
	if UnitExists(targetname) then--Better way to check if target exists and prevent nil errors at same time, without stopping scans from starting still. so even if target is nil, we stil do more checks instead of just blowing off a trap warning.
		if isTank(uId) and not ScansDone then--He's targeting a tank.
			if trapScansDone < 12 then--Make sure no infinite loop.
				self:ScheduleMethod(0.05, "TrapHandler", SpellID)--Check multiple times to be sure it's not on something other then tank.
			else
				self:TrapHandler(SpellID, true)--It's still on tank, force true isTank and activate else rule and warn trap is on tank.
			end
		else--He's not targeting a tank target (or isTank was set to true after 12 scans) so this has to be right target.
			self:UnscheduleMethod("TrapHandler")--Unschedule all checks just to be sure none are running, we are done.
			if SpellID == 99836 then
				self:CrystalTrapTarget(targetname)
			else
				self:ImmoTrapTarget(targetname)
			end
		end
	else--target was nil, lets schedule a rescan here too.
		if trapScansDone < 12 then--Make sure not to infinite loop here as well.
			self:ScheduleMethod(0.05, "TrapHandler", SpellID)
		end
	end
end

function mod:OnCombatStart(delay)
	prewarnedPhase2 = false
	ripLimbDead = false
	trapScansDone = 0
--	timerCrystalPrisonCD:Start(-delay)--Don't know yet, Need to run transcriptor with combat logging turned OFF to get the timestamps right.
	timerSpearCD:Start(20-delay)--High variation, just a CD?
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 100415 then
		warnRage:Show(args.destName)
		timerRage:Start(args.destName)
		if args:IsPlayer() then
			specWarnRage:Show()
		end
		if self.Options.SetIconOnRage then
			self:SetIcon(args.destName, 6, 15)
		end
	elseif spellId == 100167 then
		warnWary:Show(args.destName)
		timerWary:Start(args.destName)
	elseif spellId == 99837 then--Filter when the dogs get it?
		if args:IsDestTypePlayer() then
			warnCrystalPrisonTrapped:Show(args.destName)
		else--It's a trapped dog
			timerCrystalPrison:Start(args.destName)--make a 10 second timer for how long dog is trapped.
		end
	elseif spellId == 99937 then
		if (args.amount or 1) % 3 == 0 then	--Warn every 3 stacks
			warnTears:Show(args.destName, args.amount or 1)
		end
		if args:IsPlayer() and (args.amount or 1) >= 8 then
			specWarnTears:Show(args.amount)
		end
		if self:IsDifficulty("heroic10", "heroic25") then
			timerTears:Start(30, args.destName)
		else
			timerTears:Start(args.destName)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 99945 then
		if self.Options.SetIconOnFaceRage then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 99937 then
		timerTears:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 100002 then
		warnSpear:Show()--Only valid until rip dies
		specWarnSpear:Show()
		timerSpearCD:Start()
	elseif spellId == 99840 and ripLimbDead then	--This is cast after Riplimb dies.
		warnMagmaRupture:Show()
		timerMagmaRuptureCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 99947 then
		warnFaceRage:Show(args.destName)
		specWarnFaceRage:Show(args.destName)
		timerFaceRageCD:Start()
		if self.Options.SetIconOnFaceRage then
			self:SetIcon(args.destName, 8)
		end
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 99836 then
		timerCrystalPrisonCD:Start()
		trapScansDone = 0
		self:TrapHandler(99836)
	elseif spellId == 99839 then
		trapScansDone = 0
		self:TrapHandler(99839)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 53691 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 50 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 33 and h < 36 and not prewarnedPhase2 and self:IsDifficulty("normal10", "normal25") then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53694 then
		timerSpearCD:Cancel()--Cancel it and replace it with other timer
		timerMagmaRuptureCD:Start(10)
		ripLimbDead = true
	elseif cid == 53695 then
		timerFaceRageCD:Cancel()
	end
end

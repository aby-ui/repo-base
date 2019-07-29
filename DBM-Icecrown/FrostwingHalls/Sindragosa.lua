local mod	= DBM:NewMod("Sindragosa", "DBM-Icecrown", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(36853)
mod:SetEncounterID(1105)
mod:SetModelID(30362)
mod:SetUsedIcons(3, 4, 5, 6, 7, 8)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 69649 73061",
	"SPELL_AURA_APPLIED 70126 69762 70106 69766 70127",
	"SPELL_AURA_APPLIED_DOSE 70106 69766 70127",
	"SPELL_AURA_REMOVED 69762 70157 70126 70106 69766 70127",
	"SPELL_CAST_SUCCESS 70117",
	"UNIT_HEALTH boss1",
	"CHAT_MSG_MONSTER_YELL"
)

local warnAirphase				= mod:NewAnnounce("WarnAirphase", 2, 43810)
local warnGroundphaseSoon		= mod:NewAnnounce("WarnGroundphaseSoon", 2, 43810)
local warnPhase2soon			= mod:NewPrePhaseAnnounce(2)
local warnPhase2				= mod:NewPhaseAnnounce(2, 2)
local warnInstability			= mod:NewCountAnnounce(69766, 2, nil, false)
local warnChilledtotheBone		= mod:NewCountAnnounce(70106, 2, nil, false)
local warnMysticBuffet			= mod:NewCountAnnounce(70128, 2, nil, false)
local warnFrostBeacon			= mod:NewTargetAnnounce(70126, 4)
local warnFrostBreath			= mod:NewSpellAnnounce(69649, 2, nil, "Tank|Healer")
local warnUnchainedMagic		= mod:NewTargetAnnounce(69762, 2, nil, "SpellCaster", 2)

local specWarnUnchainedMagic	= mod:NewSpecialWarningYou(69762, nil, nil, nil, 1, 2)
local specWarnFrostBeacon		= mod:NewSpecialWarningMoveAway(70126, nil, nil, nil, 3, 2)
local specWarnInstability		= mod:NewSpecialWarningStack(69766, nil, 4, nil, nil, 1, 6)
local specWarnChilledtotheBone	= mod:NewSpecialWarningStack(70106, nil, 4, nil, nil, 1, 6)
local specWarnMysticBuffet		= mod:NewSpecialWarningStack(70128, false, 5, nil, nil, 1, 6)
local specWarnBlisteringCold	= mod:NewSpecialWarningRun(70123, nil, nil, nil, 4, 2)

local timerNextAirphase			= mod:NewTimer(110, "TimerNextAirphase", 43810, nil, nil, 6)
local timerNextGroundphase		= mod:NewTimer(45, "TimerNextGroundphase", 43810, nil, nil, 6)
local timerNextFrostBreath		= mod:NewNextTimer(22, 69649, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerNextBlisteringCold	= mod:NewCDTimer(67, 70123, nil, nil, nil, 2)
local timerNextBeacon			= mod:NewNextTimer(16, 70126, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)
local timerBlisteringCold		= mod:NewCastTimer(6, 70123, nil, nil, nil, 2)
local timerUnchainedMagic		= mod:NewCDTimer(30, 69762, nil, nil, nil, 3)
local timerInstability			= mod:NewBuffFadesTimer(5, 69766, nil, nil, nil, 5)
local timerChilledtotheBone		= mod:NewBuffFadesTimer(8, 70106, nil, nil, nil, 5)
local timerMysticBuffet			= mod:NewBuffFadesTimer(10, 70128, nil, nil, nil, 5)
local timerNextMysticBuffet		= mod:NewNextTimer(6, 70128, nil, nil, nil, 2)
local timerMysticAchieve		= mod:NewAchievementTimer(30, 4620, "AchievementMystic")

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("SetIconOnFrostBeacon", true)
mod:AddBoolOption("SetIconOnUnchainedMagic", true)
mod:AddBoolOption("ClearIconsOnAirphase", true)
mod:AddBoolOption("AnnounceFrostBeaconIcons", false)
mod:AddBoolOption("AchievementCheck", false, "announce")
mod:AddBoolOption("RangeFrame")

local beaconTargets		= {}
local beaconIconTargets	= {}
local unchainedTargets	= {}
mod.vb.warned_P2 = false
mod.vb.warnedfailed = false
mod.vb.phase = 0
mod.vb.unchainedIcons = 7
mod.vb.activeBeacons	= false
local playerUnchained = false
local playerBeaconed = false
local beaconDebuff, unchainedDebuff = DBM:GetSpellInfo(70126), DBM:GetSpellInfo(69762)

local function ClearBeaconTargets(self)
	table.wipe(beaconIconTargets)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(DBM:GetUnitFullName(v1)) < DBM:GetRaidSubgroup(DBM:GetUnitFullName(v2))
	end
	function mod:SetBeaconIcons()
		table.sort(beaconIconTargets, sort_by_group)
		local beaconIcons = 8
		for i, v in ipairs(beaconIconTargets) do
			if self.Options.AnnounceFrostBeaconIcons and DBM:GetRaidRank() > 0 then
				SendChatMessage(L.BeaconIconSet:format(beaconIcons, DBM:GetUnitFullName(v)), "RAID")
			end
			self:SetIcon(v, beaconIcons)
			beaconIcons = beaconIcons - 1
		end
		self:Schedule(8, ClearBeaconTargets, self)
	end
end

local beaconDebuffFilter
do
	beaconDebuffFilter = function(uId)
		return DBM:UnitDebuff(uId, beaconDebuff)
	end
end

local function warnBeaconTargets(self)
	if self.Options.RangeFrame then
		if not playerBeaconed then
			DBM.RangeCheck:Show(10, beaconDebuffFilter)
		else
			DBM.RangeCheck:Show(10)
		end
	end
	warnFrostBeacon:Show(table.concat(beaconTargets, "<, >"))
	table.wipe(beaconTargets)
	playerBeaconed = false
end

local unchainedDebuffFilter
do
	unchainedDebuffFilter = function(uId)
		return DBM:UnitDebuff(uId, unchainedDebuff)
	end
end

local function warnUnchainedTargets(self)
	if self.Options.RangeFrame then
		if not playerUnchained then
			DBM.RangeCheck:Show(20, unchainedDebuffFilter)
		else
			DBM.RangeCheck:Show(20)
		end
	end
	warnUnchainedMagic:Show(table.concat(unchainedTargets, "<, >"))
	if self.vb.phase == 2 then
		timerUnchainedMagic:Start(80)
	else
		timerUnchainedMagic:Start()
	end
	table.wipe(unchainedTargets)
	self.vb.unchainedIcons = 7
	playerUnchained = false
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextAirphase:Start(50-delay)
	timerNextBlisteringCold:Start(33-delay)
	self.vb.warned_P2 = false
	self.vb.warnedfailed = false
	table.wipe(beaconTargets)
	table.wipe(beaconIconTargets)
	table.wipe(unchainedTargets)
	self.vb.unchainedIcons = 7
	playerUnchained = false
	playerBeaconed = false
	self.vb.phase = 1
	self.vb.activeBeacons = false
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(69649, 73061) then--Frost Breath
		warnFrostBreath:Show()
		timerNextFrostBreath:Start()
	end
end	

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 70126 then
		beaconTargets[#beaconTargets + 1] = args.destName
		if args:IsPlayer() then
			playerBeaconed = true
			specWarnFrostBeacon:Show()
			specWarnFrostBeacon:Play("scatter")
		end
		if self.vb.phase == 1 and self.Options.SetIconOnFrostBeacon then
			table.insert(beaconIconTargets, DBM:GetRaidUnitId(args.destName))
			self:UnscheduleMethod("SetBeaconIcons")
			if (self:IsDifficulty("normal25") and #beaconIconTargets >= 5) or (self:IsDifficulty("heroic25") and #beaconIconTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #beaconIconTargets >= 2) then
				self:SetBeaconIcons()--Sort and fire as early as possible once we have all targets.
			else
				if self:LatencyCheck() then--Icon sorting is still sensitive and should not be done by laggy members that don't have all targets.
					self:ScheduleMethod(0.3, "SetBeaconIcons")
				end
			end
		end
		if self.vb.phase == 2 then--Phase 2 there is only one icon/beacon, don't use sorting method if we don't have to.
			timerNextBeacon:Start()
			if self.Options.SetIconOnFrostBeacon then
				self:SetIcon(args.destName, 8)
				if self.Options.AnnounceFrostBeaconIcons then
					SendChatMessage(L.BeaconIconSet:format(8, args.destName), "RAID")
				end
			end
		end
		self:Unschedule(warnBeaconTargets)
		if self.vb.phase == 2 or (self:IsDifficulty("normal25") and #beaconTargets >= 5) or (self:IsDifficulty("heroic25") and #beaconTargets >= 6) or (self:IsDifficulty("normal10", "heroic10") and #beaconIconTargets >= 2) then
			warnBeaconTargets(self)
		else
			self:Schedule(0.3, warnBeaconTargets, self)
		end
	elseif args.spellId == 69762 then
		unchainedTargets[#unchainedTargets + 1] = args.destName
		if args:IsPlayer() then
			playerUnchained = true
			specWarnUnchainedMagic:Show()
			specWarnUnchainedMagic:Play("targetyou")
		end
		if self.Options.SetIconOnUnchainedMagic then
			self:SetIcon(args.destName, self.vb.unchainedIcons)
		end
		self.vb.unchainedIcons = self.vb.unchainedIcons - 1
		self:Unschedule(warnUnchainedTargets)
		if #unchainedTargets >= 6 then
			warnUnchainedTargets(self)
		else
			self:Schedule(0.3, warnUnchainedTargets, self)
		end
	elseif args.spellId == 70106 and not self:IsTrivial(100) then	--Chilled to the bone (melee)
		if args:IsPlayer() then
			timerChilledtotheBone:Start()
			if (args.amount or 1) >= 4 then
				specWarnChilledtotheBone:Show(args.amount)
				specWarnChilledtotheBone:Play("stackhigh")
			else
				warnChilledtotheBone:Show(args.amount or 1)
			end
		end
	elseif args.spellId == 69766 and not self:IsTrivial(100) then	--Instability (casters)
		if args:IsPlayer() then
			timerInstability:Start()
			if (args.amount or 1) >= 4 then
				specWarnInstability:Show(args.amount)
				specWarnInstability:Play("stackhigh")
			else
				warnInstability:Show(args.amount or 1)
			end
		end
	elseif args.spellId == 70127 then	--Mystic Buffet (phase 2 - everyone)
		if args:IsPlayer() then
			timerMysticBuffet:Start()
			timerNextMysticBuffet:Start()
			if (args.amount or 1) >= 5 then
				specWarnMysticBuffet:Show(args.amount)
				specWarnMysticBuffet:Play("stackhigh")
			else
				warnMysticBuffet:Show(args.amount or 1)
			end
			if self.Options.AchievementCheck and not self.vb.warnedfailed and (args.amount or 1) < 2 then
				timerMysticAchieve:Start()
			end
		end
		if args:IsDestTypePlayer() then
			if self.Options.AchievementCheck and DBM:GetRaidRank() > 0 and not self.vb.warnedfailed and self:AntiSpam(3) then
				if (args.amount or 1) == 5 then
					SendChatMessage(L.AchievementWarning:format(args.destName), "RAID")
				elseif (args.amount or 1) > 5 then
					self.vb.warnedfailed = true
					SendChatMessage(L.AchievementFailed:format(args.destName, (args.amount or 1)), "RAID_WARNING")
				end
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 70117 then--Icy Grip Cast, not blistering cold, but adds an extra 1sec to the warning
		if not self:IsTrivial(100) then
			specWarnBlisteringCold:Show()
			specWarnBlisteringCold:Play("runout")
		end
		timerBlisteringCold:Start()
		timerNextBlisteringCold:Start()
	end
end	

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 69762 then
		if self.Options.SetIconOnUnchainedMagic and not self.vb.activeBeacons then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 70157 then
		if self.Options.SetIconOnFrostBeacon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 70126 then
		self.vb.activeBeacons = false
	elseif args.spellId == 70106 then	--Chilled to the bone (melee)
		if args:IsPlayer() then
			timerChilledtotheBone:Cancel()
		end
	elseif args.spellId == 69766 then	--Instability (casters)
		if args:IsPlayer() then
			timerInstability:Cancel()
		end
	elseif args.spellId == 70127 then
		if args:IsPlayer() then
			timerMysticAchieve:Cancel()
			timerMysticBuffet:Cancel()
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if not self.vb.warned_P2 and self:GetUnitCreatureId(uId) == 36853 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.38 then
		self.vb.warned_P2 = true
		warnPhase2soon:Show()	
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.YellAirphase or msg:find(L.YellAirphase)) or (msg == L.YellAirphaseDem or msg:find(L.YellAirphaseDem)) then
		if self.Options.ClearIconsOnAirphase then
			self:ClearIcons()
		end
		warnAirphase:Show()
		timerNextFrostBreath:Cancel()
		timerUnchainedMagic:Start(55)
		timerNextBlisteringCold:Start(80)--Not exact anywhere from 80-110seconds after airphase begin
		timerNextAirphase:Start()
		timerNextGroundphase:Start()
		warnGroundphaseSoon:Schedule(40)
		self.vb.activeBeacons = true
	elseif (msg == L.YellPhase2 or msg:find(L.YellPhase2)) or (msg == L.YellPhase2Dem or msg:find(L.YellPhase2Dem)) then
		self.vb.phase = 2
		warnPhase2:Show()
		timerNextBeacon:Start(7)
		timerNextAirphase:Cancel()
		timerNextGroundphase:Cancel()
		warnGroundphaseSoon:Cancel()
		timerNextBlisteringCold:Start(35)
	end
end

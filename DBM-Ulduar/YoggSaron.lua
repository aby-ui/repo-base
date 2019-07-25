local mod	= DBM:NewMod("YoggSaron", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190722195205")
mod:SetCreatureID(33288)
mod:SetEncounterID(1143)
mod:SetModelID(28817)
mod:RegisterCombat("combat_yell", L.YellPull)
mod:SetUsedIcons(8, 7, 6, 2, 1)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64059 64189 63138",
	"SPELL_CAST_SUCCESS 64144 64465",
	"SPELL_SUMMON 62979",
	"SPELL_AURA_APPLIED 63802 63830 63881 64126 64125 63138 63894 64167 64163 64465",
	"SPELL_AURA_REMOVED 63802 63894 64167 64163 63830 63138 63881 64465",
	"SPELL_AURA_REMOVED_DOSE 63050"
)

--TODO, if blizzard writes a dungeon journal for ulduar in 7.3.5, convert more of these warnings to auto local
local warnMadness 					= mod:NewCastAnnounce(64059, 2)
local warnSqueeze					= mod:NewTargetAnnounce(64125, 3)
local warnFervor					= mod:NewTargetAnnounce(63138, 4)
local warnDeafeningRoarSoon			= mod:NewPreWarnAnnounce(64189, 5, 3)
local warnGuardianSpawned 			= mod:NewAnnounce("WarningGuardianSpawned", 3, 62979)
local warnCrusherTentacleSpawned	= mod:NewAnnounce("WarningCrusherTentacleSpawned", 2, 93708)
local warnP2 						= mod:NewPhaseAnnounce(2, 2)
local warnP3 						= mod:NewPhaseAnnounce(3, 2)
local warnSanity 					= mod:NewAnnounce("WarningSanity", 3, 63050)
local warnBrainLink 				= mod:NewTargetAnnounce(63802, 3)
local warnBrainPortalSoon			= mod:NewAnnounce("WarnBrainPortalSoon", 2, 57687)
local warnEmpowerSoon				= mod:NewSoonAnnounce(64465, 4)

local specWarnBrainLink 			= mod:NewSpecialWarningYou(63802)
local specWarnSanity 				= mod:NewSpecialWarning("SpecWarnSanity")
local specWarnMadnessOutNow			= mod:NewSpecialWarning("SpecWarnMadnessOutNow")
local specWarnDeafeningRoar			= mod:NewSpecialWarningSpell(64189, nil, nil, nil, 1, 2)
local specWarnFervor				= mod:NewSpecialWarningYou(63138, nil, nil, nil, 1, 2)
local specWarnMalady				= mod:NewSpecialWarningYou(63830, nil, nil, nil, 1, 2)
local specWarnMaladyNear			= mod:NewSpecialWarningClose(63830, nil, nil, nil, 1, 2)
local yellSqueeze					= mod:NewYell(64125)

local enrageTimer					= mod:NewBerserkTimer(900)
local timerFervor					= mod:NewTargetTimer(15, 63138, nil, false, 2)
--local timerMaladyCD					= mod:NewCDTimer(18.1, 63830, nil, nil, nil, 3)
--local timerBrainLinkCD				= mod:NewCDTimer(32, 63802, nil, nil, nil, 3)
local brainportal					= mod:NewTimer(20, "NextPortal", 57687, nil, nil, 5)
local timerLunaricGaze				= mod:NewCastTimer(4, 64163, nil, nil, nil, 2)
local timerNextLunaricGaze			= mod:NewCDTimer(8.5, 64163, nil, nil, nil, 2)
local timerEmpower					= mod:NewCDTimer(46, 64465, nil, nil, nil, 3)
local timerEmpowerDuration			= mod:NewBuffActiveTimer(10, 64465, nil, nil, nil, 3)
local timerMadness 					= mod:NewCastTimer(60, 64059, nil, nil, nil, 5)
local timerCastDeafeningRoar		= mod:NewCastTimer(2.3, 64189, nil, nil, nil, 2)
local timerNextDeafeningRoar		= mod:NewNextTimer(30, 64189, nil, nil, nil, 2)
local timerAchieve					= mod:NewAchievementTimer(420, 12396)--3012

mod:AddBoolOption("SetIconOnFearTarget", true)
mod:AddBoolOption("SetIconOnFervorTarget", false)
mod:AddBoolOption("SetIconOnBrainLinkTarget", true)
mod:AddSetIconOption("SetIconOnBeacon", 64465, true, true)
mod:AddInfoFrameOption(212647)

mod.vb.phase = 1
local brainLinkTargets = {}
local SanityBuff = DBM:GetSpellInfo(63050)
mod.vb.brainLinkIcon = 2
mod.vb.beaconIcon = 8
mod.vb.Guardians = 0
mod.vb.numberOfPlayers = 1

function mod:OnCombatStart(delay)
	self.vb.numberOfPlayers = DBM:GetNumRealGroupMembers()
	self.vb.brainLinkIcon = 2
	self.vb.beaconIcon = 8
	self.vb.Guardians = 0
	self.vb.phase = 1
	enrageTimer:Start()
	timerAchieve:Start()
	table.wipe(brainLinkTargets)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(SanityBuff)
		DBM.InfoFrame:Show(6, "playerdebuffstacks", 63050, 2)--Sorted lowest first (highest first is default of arg not given)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end


function mod:OnTimerRecovery()
	self.vb.numberOfPlayers = DBM:GetNumRealGroupMembers()
end

function mod:FervorTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") and self:AntiSpam(4, 1) then
		specWarnFervor:Show()
		specWarnFervor:Play("targetyou")
	end
end

local function warnBrainLinkWarning(self)
	warnBrainLink:Show(table.concat(brainLinkTargets, "<, >"))
	--timerBrainLinkCD:Start()--VERIFY ME
	table.wipe(brainLinkTargets)
	self.vb.brainLinkIcon = 2
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 64059 then	-- Induce Madness
		timerMadness:Start()
		warnMadness:Show()
		specWarnMadnessOutNow:Schedule(55)
	elseif args.spellId == 64189 then		--Deafening Roar
		timerNextDeafeningRoar:Start()
		warnDeafeningRoarSoon:Schedule(55)
		timerCastDeafeningRoar:Start()
		specWarnDeafeningRoar:Show()
		specWarnDeafeningRoar:Play("silencesoon")
	elseif args.spellId == 63138 and not self:IsTrivial(85) then		--Sara's Fervor
		self:BossTargetScanner(args.sourceGUID, "FervorTarget", 0.1, 12, true, nil, nil, nil, true)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 64144 and self:GetUnitCreatureId(args.sourceGUID) == 33966 then 
		warnCrusherTentacleSpawned:Show()
	elseif args.spellId == 64465 then
		timerEmpower:Start()
		timerEmpowerDuration:Start()
		warnEmpowerSoon:Schedule(40)
	elseif args:IsSpellID(64167, 64163) then	-- Lunatic Gaze
		timerLunaricGaze:Start()
		brainportal:Start(60)
		warnBrainPortalSoon:Schedule(55)
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 62979 then
		self.vb.Guardians = self.vb.Guardians + 1
		warnGuardianSpawned:Show(self.vb.Guardians)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 63802 then		-- Brain Link
		self:Unschedule(warnBrainLinkWarning)
		brainLinkTargets[#brainLinkTargets + 1] = args.destName
		if self.Options.SetIconOnBrainLinkTarget then
			self:SetIcon(args.destName, self.vb.brainLinkIcon)
		end
		self.vb.brainLinkIcon = self.vb.brainLinkIcon - 1
		if args:IsPlayer() then
			specWarnBrainLink:Show()
			specWarnBrainLink:Play("linegather")
		end
		if #brainLinkTargets == 2 then
			warnBrainLinkWarning(self)
		else
			self:Schedule(0.5, warnBrainLinkWarning, self)
		end
	elseif args:IsSpellID(63830, 63881) then   -- Malady of the Mind (Death Coil) 
		--timerMaladyCD:Start()
		if self.Options.SetIconOnFearTarget then
			self:SetIcon(args.destName, 6) 
		end
		if args:IsPlayer() then
			specWarnMalady:Show()
			specWarnMalady:Play("targetyou")
		else
			local uId = DBM:GetRaidUnitId(args.destName) 
			if uId then 
				local inRange = CheckInteractDistance(uId, 2)
				if inRange then 
					specWarnMaladyNear:Show(args.destName)
					specWarnMaladyNear:Play("runaway")
				end
			end
		end 
	elseif args:IsSpellID(64126, 64125) then	-- Squeeze
		warnSqueeze:Show(args.destName)
		if args:IsPlayer() then
			yellSqueeze:Yell()
		end
	elseif args.spellId == 63138 then	-- Sara's Fervor
		warnFervor:Show(args.destName)
		timerFervor:Start(args.destName)
		if self.Options.SetIconOnFervorTarget then
			self:SetIcon(args.destName, 7)
		end
		if args:IsPlayer() and self:AntiSpam(4, 1) then 
			specWarnFervor:Show()
			specWarnFervor:Play("targetyou")
		end
	elseif args.spellId == 63894 and self.vb.phase < 2 then	-- Shadowy Barrier of Yogg-Saron (this is happens when p2 starts)
		self.vb.phase = 2
		--timerMaladyCD:Start(13)--VERIFY ME
		--timerBrainLinkCD:Start(19)--VERIFY ME
		brainportal:Start(25)
		warnBrainPortalSoon:Schedule(20)
		warnP2:Show()
	elseif args:IsSpellID(64167, 64163) then	-- Lunatic Gaze (reduces sanity)
		timerLunaricGaze:Start()
	elseif args.spellId == 64465 then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 2, self.vb.beaconIcon, 1, 0.2, 10, "SetIconOnBeacon")
		end
		self.vb.beaconIcon = self.vb.beaconIcon - 1
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 63802 and self.Options.SetIconOnBrainLinkTarget then		-- Brain Link
		self:SetIcon(args.destName, 0)
	elseif args.spellId == 63138 and self.Options.SetIconOnFervorTarget then	-- Sara's Fervor
		self:SetIcon(args.destName, 0)
	elseif args.spellId == 63894 then		-- Shadowy Barrier removed from Yogg-Saron (start p3)
		self:SendSync("Phase3")			-- Sync this because you don't get it in your combat log if you are in brain room.
	elseif args:IsSpellID(64167, 64163) and self:AntiSpam(3, 2) then	-- Lunatic Gaze
		timerNextLunaricGaze:Start()
	elseif args:IsSpellID(63830, 63881) and self.Options.SetIconOnFearTarget then   -- Malady of the Mind (Death Coil) 
		self:SetIcon(args.destName, 0) 
	elseif args.spellId == 64465 then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 2, 0, 1, 0.2, 12, "SetIconOnBeacon")
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	if args.spellId == 63050 and args.destGUID == UnitGUID("player") then
		if args.amount == 50 then
			warnSanity:Show(args.amount)
		elseif args.amount == 35 or args.amount == 25 or args.amount == 15 then
			specWarnSanity:Show(args.amount)
		end
	end
end

function mod:OnSync(msg)
	if msg == "Phase3" then
		self.vb.phase = 3
		brainportal:Cancel()
		warnBrainPortalSoon:Cancel()
		--timerMaladyCD:Cancel()
		--timerBrainLinkCD:Cancel()
		timerEmpower:Start()
		if self.vb.numberOfPlayers == 1 then
			timerMadness:Cancel()
			specWarnMadnessOutNow:Cancel()
		end
		warnP3:Show()
		warnEmpowerSoon:Schedule(40)
		timerNextDeafeningRoar:Start(30)
		warnDeafeningRoarSoon:Schedule(25)
	end
end

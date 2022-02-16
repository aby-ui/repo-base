local mod	= DBM:NewMod(1744, "DBM-EmeraldNightmare", nil, 768)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(106087)
mod:SetEncounterID(1876)
mod:SetUsedIcons(1, 2, 3, 4, 5)
mod:SetHotfixNoticeRev(15357)

mod:RegisterCombat("combat")
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 212707 210948 210547 215288 210308 210326 215582",
	"SPELL_CAST_SUCCESS 210864 215443 218630 218124",
	"SPELL_AURA_APPLIED 212514 218124 218629 215582 215307 215300",
	"SPELL_AURA_APPLIED_DOSE 212512 215582",
	"SPELL_AURA_REMOVED 218124 218629 215300 215307",
	"SPELL_PERIODIC_DAMAGE 213124",
	"SPELL_PERIODIC_MISSED 213124",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, Shimering Feather (212993) also missing from combat log. Will add tracking for this when blizzard revises fight when/if they fix it. If they don't, UNIT_AURA it is!
--(ability.id = 212707 or ability.id = 210948 or ability.id = 210547 or ability.id = 215582 or ability.id = 210326 or ability.id = 210308 or ability.id = 218124) and type = "begincast" or (ability.id = 210864 or ability.id = 215443 or ability.id = 218630 or ability.id = 218124) and type = "cast"
--Spider Form
local warnSpiderForm				= mod:NewSpellAnnounce(210326, 2)
local warnFeedingTime				= mod:NewSpellAnnounce(212364, 3)
local warnWebWrap					= mod:NewTargetAnnounce(212514, 4)
local warnNecroticVenom				= mod:NewTargetAnnounce(218831, 3)
local warnWebOfPain					= mod:NewAnnounce("warnWebOfPain", 2, 215307)
----Mythic
local warnNightmareSpawn			= mod:NewSpellAnnounce(218630, 3)
--Roc Form
local warnRocForm					= mod:NewSpellAnnounce(210308, 2)
local warnTwistingShadows			= mod:NewTargetCountAnnounce(210864, 3)
----Mythic
local warnViolentWinds				= mod:NewTargetAnnounce(218124, 4)

--Spider Form
local specWarnFeedingTime			= mod:NewSpecialWarningSwitch(212364, "-Healer", nil, nil, 1, 2)
local specWarnVenomousPool			= mod:NewSpecialWarningMove(213124, nil, nil, nil, 1, 2)
local specWarnWebWrap				= mod:NewSpecialWarningStack(212512, nil, 5, nil, nil, 1, 6)
local specWarnNecroticVenom			= mod:NewSpecialWarningMoveAway(218831, nil, nil, nil, 1, 2)
local yellNecroticVenom				= mod:NewFadesYell(218831)
local specWarnWebofPain				= mod:NewSpecialWarning("specWarnWebofPain", nil, nil, nil, 1, 2)
--Roc Form
local specWarnGatheringClouds		= mod:NewSpecialWarningSpell(212707, nil, nil, nil, 1, 2)
local specWarnDarkStorm				= mod:NewSpecialWarningMoveTo(210948, nil, nil, nil, 1, 2)
local specWarnTwistingShadows		= mod:NewSpecialWarningMoveAway(210864, nil, nil, nil, 1, 2)
local specWarnTwistingShadowsMove	= mod:NewSpecialWarningMove(210864, nil, nil, nil, 1, 2)--For expires. visual is WAY off from debuff, if you wait for visual you'll die to this
local yellTwistingShadows			= mod:NewFadesYell(210864)
local specWarnRazorWing				= mod:NewSpecialWarningDodge(210547, nil, nil, nil, 3, 2)
local specWarnRakingTalon			= mod:NewSpecialWarningDefensive(215582, nil, nil, nil, 1, 2)
local specWarnRakingTalonOther		= mod:NewSpecialWarningTaunt(215582, nil, nil, nil, 1, 2)
----Mythic
local specViolentWinds				= mod:NewSpecialWarningYou(218124, nil, nil, nil, 3, 2)
local yellViolentWinds				= mod:NewYell(218124)

--Spider Form
mod:AddTimerLine(DBM:GetSpellInfo(210326))
local timerSpiderFormCD				= mod:NewNextTimer(132, 210326, nil, nil, nil, 6, nil, nil, nil, 1, 4)
local timerFeedingTimeCD			= mod:NewNextCountTimer(50, 212364, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerNecroticVenomCD			= mod:NewNextCountTimer(21.8, 215443, nil, nil, nil, 3, nil, nil, nil, 3, 4)--This only targets ranged, but melee/tanks need to be sure to also move away from them
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerNightmareSpawnCD			= mod:NewNextTimer(10, 218630, nil, nil, nil, 1, nil, DBM_COMMON_L.HEROIC_ICON)
--Roc Form
mod:AddTimerLine(DBM:GetSpellInfo(210308))
local timerRocFormCD				= mod:NewNextTimer(47, 210308, nil, nil, nil, 6, nil, nil, nil, 1, 4)
local timerGatheringCloudsCD		= mod:NewNextTimer(15.8, 212707, nil, nil, nil, 2)
local timerDarkStormCD				= mod:NewNextTimer(26, 210948, nil, nil, nil, 2)
local timerTwistingShadowsCD		= mod:NewNextCountTimer(21.5, 210864, nil, nil, nil, 3)
local timerRazorWingCD				= mod:NewNextTimer(32.5, 210547, nil, nil, nil, 3)
local timerRakingTalonsCD			= mod:NewCDCountTimer(32, 215582, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerViolentWindsCD			= mod:NewNextTimer(40.5, 218124, nil, nil, nil, 5, nil, DBM_COMMON_L.HEROIC_ICON..DBM_COMMON_L.TANK_ICON)

local berserkTimer					= mod:NewBerserkTimer(540)

--mod:AddRangeFrameOption("5")--Add range frame to Necrotic Debuff if detecting it actually works with FindDebuff()
mod:AddSetIconOption("SetIconOnWeb", 215307)
mod:AddSetIconOption("SetIconOnWinds", 218124)

mod.vb.feedingTimeCast = 0
mod.vb.venomCast = 0
mod.vb.twistedCast = 0
mod.vb.talonsCast = 0
mod.vb.razorWingCast = 0
mod.vb.windsCast = 0
mod.vb.platformCount = 1
mod.vb.ViolentWindsPlat = false
local eyeOfStorm = DBM:GetSpellInfo(211127)
local scanTime = 0
local playerGUID = UnitGUID("player")

--TODO, need exact number of target affected by it for each scale to refactor it to just not stop until it finds all targets, then make it faster again
local function findDebuff(self, spellName, spellId)
	scanTime = scanTime + 1
	local found = 0
	for uId in DBM:GetGroupMembers() do
		local name = DBM:GetUnitFullName(uId)
		if DBM:UnitDebuff(uId, spellName) then
			found = found + 1
			if spellId == 210864 then
				warnTwistingShadows:CombinedShow(0.1, self.vb.twistedCast, name)
				if name == UnitName("player") then
					specWarnTwistingShadows:Show()
					specWarnTwistingShadows:Play("runout")
					local _, _, _, _, _, expires = DBM:UnitDebuff("Player", spellName)
					local debuffTime = expires - GetTime()
					if debuffTime then
						yellTwistingShadows:Schedule(debuffTime-1, 1)
						yellTwistingShadows:Schedule(debuffTime-2, 2)
						yellTwistingShadows:Schedule(debuffTime-3, 3)
					end
				end
			else
				warnNecroticVenom:CombinedShow(0.1, name)
				if name == UnitName("player") then
					specWarnNecroticVenom:Show()
					specWarnNecroticVenom:Play("runout")
					local _, _, _, _, _, expires = DBM:UnitDebuff("Player", spellName)
					local debuffTime = expires - GetTime()
					if debuffTime then
						yellNecroticVenom:Schedule(debuffTime - 1, 1)
						yellNecroticVenom:Schedule(debuffTime - 2, 2)
						yellNecroticVenom:Schedule(debuffTime - 3, 3)
					end
				end
			end
		end
	end
	if found == 0 and scanTime < 6 then--Scan for 1.8 sec, not forever.
		self:Schedule(1, findDebuff, self, spellName, spellId)
	end
end

function mod:OnCombatStart(delay)
	self.vb.venomCast = 0
	self.vb.feedingTimeCast = 0
	timerNecroticVenomCD:Start(12.2-delay, 1)
	timerFeedingTimeCD:Start(15.5-delay, 1)
	timerRocFormCD:Start(90-delay)--Some variation expected. I've seen 90-92. Always happens with energy based bosses
	berserkTimer:Start(-delay)--540 heroic, other difficulties not confirmed
	self.vb.platformCount = 1
	self.vb.ViolentWindsPlat = false
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 212707 then
		specWarnGatheringClouds:Show()
		specWarnGatheringClouds:Play("aesoon")
	elseif spellId == 210948 then
		specWarnDarkStorm:Show(eyeOfStorm)
		specWarnDarkStorm:Play("findshelter")
	elseif spellId == 210547 then
		self.vb.razorWingCast = self.vb.razorWingCast + 1
		specWarnRazorWing:Show()
		specWarnRazorWing:Play("carefly")
		if self.vb.ViolentWindsPlat and self.vb.razorWingCast < 2 or self.vb.razorWingCast < 3 then
			timerRazorWingCD:Start(self.vb.ViolentWindsPlat and 46 or 32.5, self.vb.razorWingCast+1)
		end
	elseif spellId == 215582 then
		self.vb.talonsCast = self.vb.talonsCast + 1
		local targetName, uId, bossuid = self:GetBossTarget(106087, true)
		if self:IsTanking("player", bossuid, nil, true) then
			specWarnRakingTalon:Show()
			specWarnRakingTalon:Play("defensive")
		end
		if self.vb.ViolentWindsPlat and self.vb.talonsCast < 2 or self.vb.talonsCast < 3 then
			timerRakingTalonsCD:Start(self.vb.ViolentWindsPlat and 46 or 32.5, self.vb.talonsCast+1)
		end
	elseif spellId == 210326 then--Spider Form
		DBM:Debug("CLEU: Spider Form Cast")
	elseif spellId == 210308 then--Roc Form
		DBM:Debug("CLEU: Roc Form Cast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 210864 then
		self.vb.twistedCast = self.vb.twistedCast + 1
		--Only cast 4x per roc form (used to be 3, but roc form is 127 seconds now, up from like 97)
		if self.vb.twistedCast == 1 then
			timerTwistingShadowsCD:Start(40, 2)
		elseif self.vb.twistedCast == 2 then
			if self.vb.ViolentWindsPlat then
				timerTwistingShadowsCD:Start(34, 3)
			else
				timerTwistingShadowsCD:Start(21.5, 3)
			end
		elseif self.vb.twistedCast == 3 then
			if self.vb.ViolentWindsPlat then
				timerTwistingShadowsCD:Start(24, 4)
			else
				timerTwistingShadowsCD:Start(32.5, 4)
			end
		end
		self:Schedule(1, findDebuff, self, args.spellName, spellId)
	elseif spellId == 215443 then
		scanTime = 0
		self.vb.venomCast = self.vb.venomCast + 1
		self:Schedule(1, findDebuff, self, args.spellName, spellId)
		if self.vb.venomCast < 4 then--Cast 4x per spider form
			timerNecroticVenomCD:Start(nil, self.vb.venomCast+1)
		end
	elseif spellId == 218630 then
		warnNightmareSpawn:Show()
		timerNightmareSpawnCD:Start()
	elseif spellId == 218124 then
		self.vb.windsCast = self.vb.windsCast + 1
		if self.vb.windsCast == 1 then
			timerViolentWindsCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 212514 then
		warnWebWrap:Show(args.destName)
	elseif spellId == 218124 then--218144 is ID people helping to soak get, 218124 is only applied to current tank
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then--Why I need a tank filter is beyond me but for some reason 218124 is MAGICALLY triggering on 218144
			if args:IsPlayer() then
				specViolentWinds:Show()
				specViolentWinds:Play("justrun")
				specViolentWinds:ScheduleVoice(1, "keepmove")
				yellViolentWinds:Yell()
			else
				warnViolentWinds:Show(args.destName)
			end
			if self.Options.SetIconOnWinds then
				self:SetIcon(args.destName, 5)
			end
		end
	elseif spellId == 215582 then
		if not args:IsPlayer() then--Player is not current target
			specWarnRakingTalonOther:Show(args.destName)
			specWarnRakingTalonOther:Play("tauntboss")
		end
	elseif spellId == 215300 then--215307 can also be used and technically is actually faster since it's first event in combat log, However 215300 is what BW uses and I want to make sure DMM repots it in same Order. Especially if they add icon options
		if args.sourceGUID == playerGUID then
			specWarnWebofPain:Show(args.destName)
			specWarnWebofPain:Play("targetyou")
		elseif args.destGUID == playerGUID then
			specWarnWebofPain:Show(args.sourceName)
		else
			warnWebOfPain:Show(args.sourceName, args.destName)
		end
		if self.Options.SetIconOnWeb and self:IsInCombat() then
			local uId = DBM:GetRaidUnitId(args.destName)
			if self:IsTanking(uId) then--Tank Group
				self:SetIcon(args.sourceName, 1)
				self:SetIcon(args.destName, 2)
			else--Non Tank Group
				self:SetIcon(args.sourceName, 3)
				self:SetIcon(args.destName, 4)
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 212512 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 5 then
			specWarnWebWrap:Show(amount)
			specWarnWebWrap:Play("stackhigh")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 218124 then
		if self.Options.SetIconOnWinds then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 218629 then
		timerNightmareSpawnCD:Stop()
	elseif (spellId == 215300 or spellId == 215307) then--Remove calls need both
		if self.Options.SetIconOnWeb then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 213124 and destGUID == playerGUID and self:AntiSpam(2, 1) then
		specWarnVenomousPool:Show()
		specWarnVenomousPool:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 212364 then--Feeding Time
		self.vb.feedingTimeCast = self.vb.feedingTimeCast + 1
		specWarnFeedingTime:Show(self.vb.feedingTimeCast)
		specWarnFeedingTime:Play("killmob")
		if self.vb.feedingTimeCast < 2 then
			timerFeedingTimeCD:Start(nil, 2)
		end
	elseif spellId == 226039 then--Bird Transform
		DBM:Debug("Bird Transform Cast")
		self.vb.platformCount = self.vb.platformCount + 1
		self.vb.ViolentWindsPlat = false
		self.vb.twistedCast = 0
		self.vb.talonsCast = 0
		self.vb.razorWingCast = 0
		self.vb.windsCast = 0
		warnRocForm:Show()
		timerTwistingShadowsCD:Start(6.6, 1)
		timerGatheringCloudsCD:Start()--15.8-16
		timerDarkStormCD:Start()--26
		timerSpiderFormCD:Start()
		if self:IsMythic() and self.vb.platformCount == 2 then--Only happens platform 2, platform 4 (roc form second cast behaves like non mythic
			self.vb.ViolentWindsPlat = true
			timerViolentWindsCD:Start(56)--50 plus 6 second cast
			timerRakingTalonsCD:Start(66, 1)
			timerRazorWingCD:Start(73, 1)
		else
			timerRakingTalonsCD:Start(52, 1)
			timerRazorWingCD:Start(59, 1)
		end
	elseif spellId == 226055 then--Spider Transform
		DBM:Debug("Spider Transform Cast")
		self.vb.platformCount = self.vb.platformCount + 1
		self.vb.ViolentWindsPlat = false
		self.vb.venomCast = 0
		self.vb.feedingTimeCast = 0
		timerRazorWingCD:Stop()
		warnSpiderForm:Show()
		timerNecroticVenomCD:Start(12.2, 1)
		timerFeedingTimeCD:Start(15.5, 1)
		timerRocFormCD:Start(92)
	end
end

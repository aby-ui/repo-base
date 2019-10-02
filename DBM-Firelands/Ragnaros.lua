local mod	= DBM:NewMod(198, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190821185238")
mod:SetCreatureID(52409)
mod:SetEncounterID(1203)
mod:SetZone()
mod:SetUsedIcons(1, 2)
--mod:SetModelSound("Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_AGGRO.ogg", "Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_KILL_03.ogg")
--Long: blah blah blah (didn't feel like transcribing it)
--Short: This is my realm

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 98710 98951 98952 98953 99172 99235 99236 100646 100479",
	"SPELL_CAST_SUCCESS 98237 98164 98263 100460 99268 100714 101110",
	"SPELL_AURA_APPLIED 99399 100594 100171 100604",
	"SPELL_AURA_APPLIED_DOSE 99399 100594",
	"SPELL_AURA_REMOVED 99399",
	"SPELL_DAMAGE 98518 98175 98870 99144 100941 98981",
	"SPELL_MISSED 98518 98175 98870 99144 100941 98981",
	"CHAT_MSG_MONSTER_YELL",
	"RAID_BOSS_EMOTE",
	"UNIT_HEALTH boss1",
	"UNIT_AURA player",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_DIED"
)

--[[
(ability.id = 98710 or ability.id = 98951 or ability.id = 98952 or ability.id = 98953 or ability.id = 98951 or ability.id = 98952 or ability.id = 98953 or ability.id = 99172 or ability.id = 99235 or ability.id = 99236 or ability.id = 99172 or ability.id = 99235 or ability.id = 99236 or ability.id = 100646 or ability.id = 100479 and type = "begincast"
 or (ability.id = 98237 or ability.id = 98164 or ability.id = 98263 or ability.id = 100460 or ability.id = 99268 or ability.id = 100714 or ability.id = 101110) and type = "cast"
 or type = "death"
--]]
local warnRageRagnaros		= mod:NewTargetAnnounce(101110, 3)--Staff quest ability (normal only)
local warnRageRagnarosSoon	= mod:NewAnnounce("warnRageRagnarosSoon", 4, 101109)--Staff quest ability (normal only)
local warnHandRagnaros		= mod:NewSpellAnnounce(98237, 3, nil, "Melee")--Phase 1 only ability
local warnWrathRagnaros		= mod:NewSpellAnnounce(98263, 3, nil, "Ranged")--Phase 1 only ability
local warnBurningWound		= mod:NewStackAnnounce(99399, 3, nil, "Tank|Healer")
local warnSulfurasSmash		= mod:NewSpellAnnounce(98710, 4)--Phase 1-3 ability.
local warnMagmaTrap			= mod:NewTargetAnnounce(98164, 3)--Phase 1 ability.
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 3)
mod:AddBoolOption("warnSeedsLand", false, "announce")
local warnSplittingBlow		= mod:NewAnnounce("warnSplittingBlow", 3, 98951)
local warnSonsLeft			= mod:NewAddsLeftAnnounce("ej2637", 2, 99014)
local warnEngulfingFlame	= mod:NewAnnounce("warnEngulfingFlame", 4, 99171)
mod:AddBoolOption("warnEngulfingFlameHeroic", false, "announce")
local warnPhase3Soon		= mod:NewPrePhaseAnnounce(3, 3)
local warnBlazingHeat		= mod:NewTargetAnnounce(100460, 4)--Second transition adds ability.
local warnLivingMeteorSoon	= mod:NewPreWarnAnnounce(99268, 10, 3)
local warnLivingMeteor		= mod:NewTargetAnnounce(99268, 4)--Phase 3 only ability
local warnBreadthofFrost	= mod:NewSpellAnnounce(100479, 2)--Heroic phase 4 ability
local warnCloudBurst		= mod:NewSpellAnnounce(100714, 2)--Heroic phase 4 ability (only casts this once, doesn't seem to need a timer)
local warnEntrappingRoots	= mod:NewSpellAnnounce(100646, 3)--Heroic phase 4 ability
local warnEmpoweredSulf		= mod:NewAnnounce("warnEmpoweredSulf", 4, 100604)--Heroic phase 4 ability
local warnDreadFlame		= mod:NewSpellAnnounce(100675, 3, nil, false)--Heroic phase 4 ability

local specWarnMagmaTrap		= mod:NewSpecialWarningMove(98164, nil, nil, nil, 1, 2)
local specWarnMagmaTrapNear	= mod:NewSpecialWarningClose(98164, nil, nil, nil, 1, 2)
local yellMagmaTrap			= mod:NewYell(98164)--May Return false tank yells
local specWarnBurningWound	= mod:NewSpecialWarningStack(99399, nil, 4, nil, nil, 1, 6)
local specWarnSplittingBlow	= mod:NewSpecialWarningSpell(98951, nil, nil, nil, 1, 2)
local specWarnBlazingHeat	= mod:NewSpecialWarningYou(100460)--Debuff on you
local yellBlazingHeat		= mod:NewYell(100460)
local specWarnMoltenSeed	= mod:NewSpecialWarningDodge(98495, nil, nil, nil, 2, 2)
local specWarnEngulfing		= mod:NewSpecialWarningMove(99171, nil, nil, nil, 1, 2)
local specWarnMeteor		= mod:NewSpecialWarningMove(99268, nil, nil, nil, 1, 2)--Spawning on you
local specWarnMeteorNear	= mod:NewSpecialWarningClose(99268, nil, nil, nil, 1, 2)--Spawning near you
local yellMeteor			= mod:NewYell(99268)
local specWarnFixate		= mod:NewSpecialWarningRun(99849, nil, nil, nil, 4, 2)--Chasing you after it spawned
local yellFixate			= mod:NewYell(99849)
local specWarnWorldofFlames	= mod:NewSpecialWarningDodge(100171, nil, nil, nil, 2, 2)
local specWarnEmpoweredSulf	= mod:NewSpecialWarningSpell(100604, "Tank", nil, nil, 3, 2)--Heroic ability Asuming only the tank cares about this? seems like according to tooltip 5 seconds to hide him into roots?
local specWarnSuperheated	= mod:NewSpecialWarningStack(100593, true, 12, nil, nil, 1, 6)
local specWarnGTFO			= mod:NewSpecialWarningGTFO(98870, nil, nil, nil, 1, 8)

local timerRageRagnaros		= mod:NewTimer(5, "timerRageRagnaros", 101110)
local timerRageRagnarosCD	= mod:NewNextTimer(60, 101110)
local timerMagmaTrap		= mod:NewCDTimer(25, 98164, nil, nil, nil, 5)		-- Phase 1 only ability. 25-30sec variations.
local timerSulfurasSmash	= mod:NewNextTimer(30, 98710, nil, nil, nil, 3)
local timerHandRagnaros		= mod:NewCDTimer(25, 98237, nil, "Melee", nil, 2)-- might even be a "next" timer
local timerWrathRagnaros	= mod:NewCDTimer(30, 98263, nil, "Ranged", nil, 3)--It's always 12 seconds after smash unless delayed by magmatrap or hand of rag.
local timerBurningWound		= mod:NewTargetTimer(20, 99399, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerFlamesCD			= mod:NewNextTimer(40, 99171, nil, nil, nil, 3)
local timerMoltenSeedCD		= mod:NewCDTimer(60, 98495, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON, nil, 1, 4)--60 seconds CD in between from seed to seed. 50 seconds using the molten inferno trigger.
local timerMoltenInferno	= mod:NewNextTimer(10, 98518, nil, nil, nil, 2)--Cast bar for molten Inferno (seeds exploding)
local timerLivingMeteorCD	= mod:NewNextCountTimer(45, 99268, nil, nil, nil, 1, nil, nil, nil, 2, 4)
local timerInvokeSons		= mod:NewCastTimer(17, 99014, nil, nil, nil, 1, nil, DBM_CORE_DEADLY_ICON..DBM_CORE_DAMAGE_ICON)--8 seconds for splitting blow, about 8-10 seconds after for them landing, using the average, 9.
local timerLavaBoltCD		= mod:NewNextTimer(4, 98981)
local timerBlazingHeatCD	= mod:NewCDTimer(20, 100460, nil, nil, nil, 3)
local timerPhaseSons		= mod:NewTimer(45, "TimerPhaseSons", 99014, nil, nil, 6)	-- lasts 45secs or till all sons are dead
local timerCloudBurstCD		= mod:NewCDTimer(50, 100714)
local timerBreadthofFrostCD	= mod:NewCDTimer(45, 100479)
local timerEntrapingRootsCD	= mod:NewCDTimer(56, 100646, nil, nil, nil, 5)--56-60sec variations. Always cast before empowered sulf, varies between 3 sec before and like 11 sec before.
local timerEmpoweredSulfCD	= mod:NewCDTimer(56, 100604, nil, nil, nil, 5, nil, DBM_CORE_DEADLY_ICON..DBM_CORE_TANK_ICON, nil, mod:IsTank() and 1, 5)--56-64sec variations
local timerEmpoweredSulf	= mod:NewBuffActiveTimer(10, 100604, nil, "Tank", nil, 5, nil, DBM_CORE_DEADLY_ICON..DBM_CORE_TANK_ICON, nil, 1, 0)--Countout timer
local timerDreadFlameCD		= mod:NewCDTimer(40, 100675, nil, false, nil, 5)--Off by default as only the people dealing with them care about it.

local berserkTimer			= mod:NewBerserkTimer(1080)

mod:AddRangeFrameOption("6/8")
mod:AddSetIconOption("BlazingHeatIcons", 100460, true, false, {1, 2})
mod:AddBoolOption("InfoHealthFrame", "Healer")--Phase 1 info framefor low health detection.
mod:AddBoolOption("AggroFrame", false)--Phase 2 info frame for seed aggro detection.
mod:AddBoolOption("MeteorFrame", true)--Phase 3 info frame for meteor fixate detection.

mod.vb.firstSmash = false
mod.vb.wrathcount = 0
mod.vb.magmaTrapSpawned = 0
mod.vb.elementalsSpawned = 0
mod.vb.meteorSpawned = 0
mod.vb.sonsLeft = 8
mod.vb.phase = 1
mod.vb.prewarnedPhase2 = false
mod.vb.prewarnedPhase3 = false
mod.vb.phase2Started = false
mod.vb.blazingHeatIcon = 2
mod.vb.seedsActive = false
mod.vb.dreadFlameTimer = 45
local magmaTrapGUID = {}
local elementalsGUID = {}
local meteorWarned = false
local dreadflame, meteorTarget, staffDebuff, seedCast, deluge = DBM:GetSpellInfo(100675), DBM:GetSpellInfo(99849), DBM:GetSpellInfo(101109), DBM:GetSpellInfo(98333), DBM:GetSpellInfo(100713)

local function showRangeFrame(self)
	if DBM:UnitDebuff("player", staffDebuff) then return end--Staff debuff, don't change their range finder from 8.
	if self.Options.RangeFrame then
		if self.vb.phase == 1 and self:IsRanged() then
			DBM.RangeCheck:Show(6)--For wrath of rag, only for ranged.
		elseif self.vb.phase == 2 then
			DBM.RangeCheck:Show(6)--For seeds
		end
	end
end

local function hideRangeFrame(self)
	if DBM:UnitDebuff("player", staffDebuff) then return end--Staff debuff, don't hide it either.
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function TransitionEnded(self)
	timerPhaseSons:Stop()
	timerLavaBoltCD:Stop()
	if self.vb.phase == 2 then
		if self:IsHeroic() then
			timerSulfurasSmash:Start(6)
			if mod.Options.warnSeedsLand then
				timerMoltenSeedCD:Start(17.5)
			else
				timerMoltenSeedCD:Start(15)--14.8-16 variation. We use earliest time for safety.
			end
		else
			timerSulfurasSmash:Start(15.5)
			if self.Options.warnSeedsLand then
				timerMoltenSeedCD:Start(24)--23-25 Variation. we use the average
			else
				timerMoltenSeedCD:Start(21.5)--Use the earliest known time, based on my logs is 21.5
			end
		end
		timerFlamesCD:Start()--Probably the only thing that's really consistent.
		showRangeFrame(self)--Range 6 for seeds
	elseif self.vb.phase == 3 then
		timerSulfurasSmash:Start(15.5)--Also a variation.
		timerFlamesCD:Start(30)
		warnLivingMeteorSoon:Schedule(35)
		timerLivingMeteorCD:Start(45, 1)
	elseif self.vb.phase == 4 then
		timerLivingMeteorCD:Stop()
		warnLivingMeteorSoon:Stop()
		timerFlamesCD:Stop()
		timerSulfurasSmash:Stop()
		timerBreadthofFrostCD:Start(33)
		timerDreadFlameCD:Start(48)
		timerCloudBurstCD:Start()
		timerEntrapingRootsCD:Start(67)
		timerEmpoweredSulfCD:Start(83)
	end
end

function mod:MagmaTrapTarget(targetname)
	if targetname == UnitName("player") then
		specWarnMagmaTrap:Show()
		specWarnMagmaTrap:Play("runaway")
		yellMagmaTrap:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 6 then
				specWarnMagmaTrapNear:Show(targetname)
				specWarnMagmaTrapNear:Play("runaway")
			else
				warnMagmaTrap:Show(targetname)
			end
		end
	end
end

function mod:LivingMeteorTarget(targetname)
	if targetname == UnitName("player") then
		specWarnMeteor:Show()
		specWarnMeteor:Play("targetyou")
		yellMeteor:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 12 then
				specWarnMeteorNear:Show(targetname)
				specWarnMeteorNear:Play("runaway")
			else
				warnLivingMeteor:Show(targetname)
			end
		end
	end
end

local function warnSeeds()
	specWarnMoltenSeed:Show()
	specWarnMoltenSeed:Play("watchstep")
	timerMoltenSeedCD:Start()
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerWrathRagnaros:Start(6-delay)--4.5-6sec variation, as a result, randomizes whether or not there will be a 2nd wrath before sulfuras smash. (favors not tho)
	timerMagmaTrap:Start(16-delay)
	timerHandRagnaros:Start(-delay)
	timerSulfurasSmash:Start(-delay)
	self.vb.wrathcount = 0
	self.vb.magmaTrapSpawned = 0
	self.vb.elementalsSpawned = 0
	self.vb.meteorSpawned = 0
	self.vb.sonsLeft = 8
	self.vb.phase = 1
	self.vb.firstSmash = false
	self.vb.prewarnedPhase2 = false
	self.vb.prewarnedPhase3 = false
	self.vb.blazingHeatIcon = 2
	self.vb.phase2Started = false
	self.vb.seedsActive = false
	self.vb.dreadFlameTimer = 45
	table.wipe(magmaTrapGUID)
	table.wipe(elementalsGUID)
	meteorWarned = false
	showRangeFrame(self)
	if not self:IsHeroic() then--register alternate kill detection, he only dies on heroic.
		self:RegisterKill("yell", L.Defeat)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.MeteorFrame or self.Options.InfoHealthFrame or self.Options.AggroFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 98710 then
		self.vb.firstSmash = true
		warnSulfurasSmash:Show()
		if self.vb.phase == 1 or self.vb.phase == 3 then
			timerSulfurasSmash:Start()--30 second cd in phase 1 and phase 3 in 3/4 difficulties
			if self.vb.phase == 1 and self.vb.wrathcount < 2 then--always 12 seconds after smash if 30 second CD (ie wrathcount didn't reach 2 before first smash)
				timerWrathRagnaros:Update(18, 30)--This is most accurate place to put it so we use auto correction here.
			end
		else
			timerSulfurasSmash:Start(40)--40 seconds in phase 2
			if not self.vb.phase2Started then
				self.vb.phase2Started = true
				if self:IsHeroic() then
					if self.Options.warnSeedsLand then
						timerMoltenSeedCD:Update(6, 17.5)--Update the timer here if it's off, but timer still starts at yell so it has more visability sooner.
					else
						timerMoltenSeedCD:Update(6, 15)--Update the timer here if it's off, but timer still starts at yell so it has more visability sooner.
					end
				else
					if self.Options.warnSeedsLand then
						timerMoltenSeedCD:Update(16.2, 24)--Update the timer here if it's off, but timer still starts at yell so it has more visability sooner.
					else
						timerMoltenSeedCD:Update(16.2, 21.5)--I'll run more transcriptor logs to tweak this
					end
				end
			end
		end
	elseif args:IsSpellID(98951, 98952, 98953) then--This has 3 spellids, 1 for each possible location for hammer.
		self.vb.sonsLeft = 8
		self.vb.phase = self.vb.phase + 1
		self:Unschedule(warnSeeds)
		timerMoltenSeedCD:Stop()
		timerMagmaTrap:Stop()
		timerSulfurasSmash:Stop()
		timerHandRagnaros:Stop()
		timerWrathRagnaros:Stop()
		timerFlamesCD:Stop()
		hideRangeFrame(self)
		if self:IsHeroic() then
			timerPhaseSons:Start(60)--Longer on heroic
		else
			timerPhaseSons:Start(47)--45 sec plus the 2 or so seconds he takes to actually come up and yell.
		end
		specWarnSplittingBlow:Show()
		specWarnSplittingBlow:Play("phasechange")
		timerInvokeSons:Start()
		timerLavaBoltCD:Start(17.3)--9.3 seconds + cast time for splitting blow
		if spellId == 98951 then--West
			warnSplittingBlow:Show(args.spellName, L.West)
		elseif spellId == 98952 then--Middle
			warnSplittingBlow:Show(args.spellName, L.Middle)
		elseif spellId == 98953 then--East
			warnSplittingBlow:Show(args.spellName, L.East)
		end
	elseif args:IsSpellID(99172, 99235, 99236) then--Another scripted spell with a ton of spellids based on location of room.
		if self.vb.phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start()--40 second CD in phase 2
		end
		--North: 99172
		--Middle: 99235
		--South: 99236
		if spellId == 99172 then--North
			if not self.Options.WarnEngulfingFlameHeroic and self:IsHeroic() then return end
			warnEngulfingFlame:Show(args.spellName, L.North)
			if self:IsMelee() or self.vb.seedsActive then--Always warn melee classes if it's in melee (duh), warn everyone if seeds are active since 90% of strats group up in melee
				specWarnEngulfing:Show()
				specWarnEngulfing:Play("watchstep")
			end
		elseif spellId == 99235 then--Middle
			if not self.Options.WarnEngulfingFlameHeroic and self:IsHeroic() then return end
			warnEngulfingFlame:Show(args.spellName, L.Middle)
		elseif spellId == 99236 then--South
			if not self.Options.WarnEngulfingFlameHeroic and self:IsHeroic() then return end
			warnEngulfingFlame:Show(args.spellName, L.South)
		end
	elseif spellId == 100646 then
		warnEntrappingRoots:Show()
		timerEntrapingRootsCD:Start()
	elseif spellId == 100479 then
		warnBreadthofFrost:Show()
		timerBreadthofFrostCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 98237 and not args:IsSrcTypePlayer() then -- can be stolen which triggers a new SPELL_CAST_SUCCESS event...
		warnHandRagnaros:Show()
		timerHandRagnaros:Start()
	elseif spellId == 98164 then	--98164 confirmed
		self.vb.magmaTrapSpawned = self.vb.magmaTrapSpawned + 1
		timerMagmaTrap:Start()
		self:BossTargetScanner(52409, "MagmaTrapTarget", 0.025, 12)
		if self.Options.InfoHealthFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(L.HealthInfo)
			DBM.InfoFrame:Show(5, "health", 100000)
		end
	elseif spellId == 98263 and self:AntiSpam(4, 1) then
		warnWrathRagnaros:Show()
		--Wrath of Ragnaros has a 25 second cd if 2 happen before first smash, otherwise it's 30.
		--In this elaborate function we count the wraths before first smash
		--As well as even dynamically start correct timer based on when first one was cast so people know right away if there will be a 2nd before smash
		if not self.vb.firstSmash then--First smash hasn't happened yet
			self.vb.wrathcount = self.vb.wrathcount + 1--So count wraths
		end
		if GetTime() - self.combatInfo.pull <= 5 or self.vb.wrathcount == 2 then--We check if there were two wraths before smash, or if pull was within last 5 seconds.
			timerWrathRagnaros:Start(25)--if yes to either, this bar is always 25 seconds.
		else--First wrath was after 5 second mark and wrathcount not 2 so we have a 30 second cd wrath.
			if self.vb.firstSmash then--Check if first smash happened yet to determine at this point whether to start a 30 second bar or the one time only 36 bar.
				timerWrathRagnaros:Start()--First smash already happened so it's later fight and this is always gonna be 30.
			else
				timerWrathRagnaros:Start(36)--First smash didn't happen yet, and first wrath happened later then 5 seconds into pull, 2nd smash will be delayed by sulfuras smash.
			end
		end
	elseif spellId == 100460 then	-- Blazing heat
		timerBlazingHeatCD:Start(args.sourceGUID)--args.sourceGUID is to support multiple cds when more then 1 is up at once
		if args:IsPlayer() then
			specWarnBlazingHeat:Show()
			specWarnBlazingHeat:Play("targetyou")
			yellBlazingHeat:Yell()
		else
			warnBlazingHeat:Show(args.destName)
		end
		if self.Options.BlazingHeatIcons then
			self:SetIcon(args.destName, self.vb.blazingHeatIcon, 8)
		end
		if self.vb.blazingHeatIcon == 2 then-- Alternate icons, they are cast too far apart to sort in a table or do icons at once, and there are 2 adds up so we need to do it this way.
			self.vb.blazingHeatIcon = 1
		else
			self.vb.blazingHeatIcon = 2
		end
	elseif spellId == 99268 then
		self.vb.meteorSpawned = self.vb.meteorSpawned + 1
		if self.vb.meteorSpawned == 1 or self.vb.meteorSpawned % 2 == 0 then--Spam filter, announce at 1, 2, 4, 6, 8, 10 etc. The way that they spawn
			self:BossTargetScanner(52409, "LivingMeteorTarget", 0.025, 12)
			timerLivingMeteorCD:Start(45, self.vb.meteorSpawned+1)--Start new one with new count
			warnLivingMeteorSoon:Schedule(35)
		end
		if self.Options.MeteorFrame and self.vb.meteorSpawned == 1 then--Show meteor frame and clear any health or aggro frame because nothing is more important then meteors.
			DBM.InfoFrame:SetHeader(L.MeteorTargets)
			DBM.InfoFrame:Show(6, "playerbaddebuff", meteorTarget)--If you get more then 6 chances are you're screwed unless it's normal mode and he's at like 11%. Really anything more then 4 is chaos and wipe waiting to happen.
		end
	elseif spellId == 100714 then
		warnCloudBurst:Show()
	elseif spellId == 101110 then
		warnRageRagnaros:Show(args.destName)
		if self.Options.RangeFrame and args:IsPlayer() then
			DBM.RangeCheck:Show(8)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 99399 then
		local amount = args.amount or 1
		if amount >= 4 and args:IsPlayer() then
			specWarnBurningWound:Show(amount)
			specWarnBurningWound:Play("stackhigh")
		else
			warnBurningWound:Show(args.destName, amount)
		end
		timerBurningWound:Start(args.destName)
	elseif spellId == 100594 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 12 and amount % 4 == 0 then
			specWarnSuperheated:Show(amount)
			specWarnSuperheated:Play("stackhigh")
		end
	elseif spellId == 100171 then--World of Flames, heroic version for engulfing flames.
		specWarnWorldofFlames:Show()
		specWarnWorldofFlames:Play("watchstep")
		if self.vb.phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start(60)--60 second CD in phase 2
		end
	elseif spellId == 100604 then
		if self.Options.SpecWarn100604spell then
			specWarnEmpoweredSulf:Show()
		else
			warnEmpoweredSulf:Show(args.spellName)
		end
		timerEmpoweredSulf:Schedule(5)--Schedule 10 second bar to start when cast ends for buff active timer.
		timerEmpoweredSulfCD:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 99399 then
		timerBurningWound:Stop(args.destName)
	end
end

function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 98518 and not elementalsGUID[sourceGUID] then--Molten Inferno. elementals cast this on spawn.
		elementalsGUID[sourceGUID] = true--Add unit GUID's to ignore
		self.vb.elementalsSpawned = self.vb.elementalsSpawned + 1--Add up the total elementals
	elseif spellId == 98175 and not magmaTrapGUID[sourceGUID] then--Magma Trap Eruption. We use it to count traps that have been set off
		magmaTrapGUID[sourceGUID] = true--Add unit GUID's to ignore
		self.vb.magmaTrapSpawned = self.vb.magmaTrapSpawned - 1--Add up total traps
		if self.vb.magmaTrapSpawned == 0 and self.Options.InfoHealthFrame and not self.vb.seedsActive then--All traps are gone hide the health frame.
			DBM.InfoFrame:Hide()
		end
	elseif (spellId == 98870 or spellId == 99144 or spellId == 100941) and destGUID == UnitGUID("player") and self:AntiSpam(5, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	elseif spellId == 98981 and self:AntiSpam(3, 1) then--Reuse anti spam ID 1 again because lava bolts and wraths are never near eachother.
		timerLavaBoltCD:Start()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE--Have to track absorbs too for this method to work.

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.TransitionEnded1 or msg:find(L.TransitionEnded1) or msg == L.TransitionEnded2 or msg:find(L.TransitionEnded2) or msg == L.TransitionEnded3 or msg:find(L.TransitionEnded3) then--This is more reliable then adds which may or may not add up to 8 cause blizz sucks. Plus it's more precise anyways, timers seem more consistent with this method.
		TransitionEnded(self)
	elseif (msg == L.Phase4 or msg:find(L.Phase4)) and self:IsInCombat() then
		self.vb.phase = 4
		TransitionEnded(self)--Easier to just trigger this and keep all phase change stuff in one place.
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find(dreadflame) then--This is more reliable then adds which may or may not add up to 8 cause blizz sucks. Plus it's more precise anyways, timers seem more consistent with this method.
		if self.vb.dreadFlameTimer > 15 then
			self.vb.dreadFlameTimer = self.vb.dreadFlameTimer - 5
		end
		warnDreadFlame:Show()
		timerDreadFlameCD:Start(self.vb.dreadFlameTimer)
	end
end

function mod:OnTranscriptorSync(msg, targetName)
	if msg:find(staffDebuff) and targetName then
		targetName = Ambiguate(targetName, "none")
		warnRageRagnarosSoon:Show(staffDebuff, targetName)
		timerRageRagnaros:Start(5, staffDebuff, targetName)
		timerRageRagnarosCD:Start()
	end
end

function mod:OnSync(event, target)
	if event == "RageOfRagnaros" then
		warnRageRagnarosSoon:Show(staffDebuff, target)
		timerRageRagnaros:Start(5, staffDebuff, target)
		timerRageRagnarosCD:Start()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 52409 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 80 and self.vb.prewarnedPhase2 then
			self.vb.prewarnedPhase2 = false
		elseif h > 72 and h < 75 and not self.vb.prewarnedPhase2 then
			self.vb.prewarnedPhase2 = true
			warnPhase2Soon:Show()
		elseif h > 50 and self.vb.prewarnedPhase3 then
			self.vb.prewarnedPhase3 = false
		elseif h > 42 and h < 45 and not self.vb.prewarnedPhase3 then
			self.vb.prewarnedPhase3 = true
			warnPhase3Soon:Show()
		end
	end
end

function mod:UNIT_AURA(uId)
	if DBM:UnitDebuff("player", meteorTarget) and not meteorWarned then--Warn you that you have a meteor
		specWarnFixate:Show()
		specWarnFixate:Play("justrun")
		yellFixate:Yell()
		meteorWarned = true
	elseif not DBM:UnitDebuff("player", meteorTarget) and meteorWarned then--reset warned status if you don't have debuff
		meteorWarned = false
	end
end

local function clearSeedsActive(self)
	self.vb.seedsActive = false
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	--TODO, switch to spellid once verified spellid is always same
	local spellName = DBM:GetSpellInfo(spellId)--TEMP, just get right spellID at some point
	if spellName == seedCast and not self.vb.seedsActive then -- The true molten seeds cast.
		self.vb.seedsActive = true
		timerMoltenInferno:Start(11.5)--1.5-2.5 variation, we use lowest +10 seconds
		if self.Options.warnSeedsLand then--Warn after they are on ground, typical strat for normal mode. Time not 100% consistent.
			self:Schedule(2.5, warnSeeds, self)--But use upper here
		else
			warnSeeds(self)
		end
		self:Schedule(17.5, clearSeedsActive, self)--Clear active/warned seeds after they have all blown up.
		if self.Options.AggroFrame then--Show aggro frame regardless if health frame is still up, it should be more important than health frame at this point. Shouldn't be blowing up traps while elementals are up.
			DBM.InfoFrame:SetHeader(L.NoAggro)
			DBM.InfoFrame:Show(10, "playeraggro", 0)--20 man has at least 5 targets without aggro, often more do to immunities. because of it's size, it's now off by default.
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53140 then--Son of Flame
		self.vb.sonsLeft = self.vb.sonsLeft - 1
		if self.vb.sonsLeft < 3 then
			warnSonsLeft:Show(self.vb.sonsLeft)
		end
	elseif cid == 53500 then--Meteors
		self.vb.meteorSpawned = self.vb.meteorSpawned - 1
		if self.vb.meteorSpawned == 0 and self.Options.MeteorFrame then--Meteors all gone, hide info frame
			DBM.InfoFrame:Hide()
			if self.vb.magmaTrapSpawned >= 1 and self.Options.InfoHealthFrame then--If traps are still up we restore the health frame (why on earth traps would still up in phase 4 is beyond me).
				DBM.InfoFrame:SetHeader(L.HealthInfo)
				DBM.InfoFrame:Show(5, "health", 200000)
			end
		end
	elseif cid == 53189 then--Molten elemental
		self.vb.elementalsSpawned = self.vb.elementalsSpawned - 1
		if self.vb.elementalsSpawned == 0 and self.Options.AggroFrame then--Elementals all gone, hide info frame
			DBM.InfoFrame:Hide()
			if self.vb.magmaTrapSpawned >= 1 and self.Options.InfoHealthFrame then--If traps are still up we restore the health frame.
				DBM.InfoFrame:SetHeader(L.HealthInfo)
				DBM.InfoFrame:Show(5, "health", 200000)
			end
		end
	elseif cid == 53231 then--Lava Scion
		timerBlazingHeatCD:Stop(args.sourceGUID)
	end
end

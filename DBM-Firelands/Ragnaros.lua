local mod	= DBM:NewMod(198, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(52409)
mod:SetEncounterID(1203)
mod:SetZone()
mod:SetUsedIcons(1, 2)
--mod:SetModelSound("Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_AGGRO.ogg", "Sound\\Creature\\RAGNAROS\\VO_FL_RAGNAROS_KILL_03.ogg")
--Long: blah blah blah (didn't feel like transcribing it)
--Short: This is my realm

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 99399 100594 100171 100604",
	"SPELL_AURA_APPLIED_DOSE 99399 100594",
	"SPELL_AURA_REMOVED 99399",
	"SPELL_CAST_START 98710 98951 98952 98953 99172 99235 99236 100646 100479",
	"SPELL_CAST_SUCCESS 98237 98164 98263 100460 99268 100714 101110",
	"SPELL_DAMAGE 98518 98175 98870 99144 100941 98981",
	"SPELL_MISSED 98518 98175 98870 99144 100941 98981",
	"CHAT_MSG_MONSTER_YELL",
	"RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER",
	"UNIT_HEALTH boss1",
	"UNIT_AURA player",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_DIED"
)

local warnRageRagnaros		= mod:NewTargetAnnounce(101110, 3)--Staff quest ability (normal only)
local warnRageRagnarosSoon	= mod:NewAnnounce("warnRageRagnarosSoon", 4, 101109)--Staff quest ability (normal only)
local warnHandRagnaros		= mod:NewSpellAnnounce(98237, 3, nil, "Melee")--Phase 1 only ability
local warnWrathRagnaros		= mod:NewSpellAnnounce(98263, 3, nil, "Ranged")--Phase 1 only ability
local warnBurningWound		= mod:NewStackAnnounce(99399, 3, nil, "Tank|Healer")
local warnSulfurasSmash		= mod:NewSpellAnnounce(98710, 4)--Phase 1-3 ability.
local warnMagmaTrap			= mod:NewTargetAnnounce(98164, 3)--Phase 1 ability.
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 3)
local warnMoltenSeed		= mod:NewSpellAnnounce(98495, 4)--Phase 2 only ability
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

local specWarnSulfurasSmash	= mod:NewSpecialWarningSpell(98710, false)
local specWarnScorchedGround= mod:NewSpecialWarningMove(98870)--Fire on ground left by Sulfuras Smash
local specWarnMagmaTrap		= mod:NewSpecialWarningMove(98164)
local specWarnMagmaTrapNear	= mod:NewSpecialWarningClose(98164)
local yellMagmaTrap			= mod:NewYell(98164)--May Return false tank yells
local specWarnBurningWound	= mod:NewSpecialWarningStack(99399, "Tank", 4)
local specWarnSplittingBlow	= mod:NewSpecialWarningSpell(98951)
local specWarnBlazingHeat	= mod:NewSpecialWarningYou(100460)--Debuff on you
local yellBlazingHeat		= mod:NewYell(100460)
local specWarnBlazingHeatMV	= mod:NewSpecialWarningMove(99144)--Standing in it
local specWarnMoltenSeed	= mod:NewSpecialWarningSpell(98495, nil, nil, nil, true)
local specWarnEngulfing		= mod:NewSpecialWarningMove(99171)
local specWarnMeteor		= mod:NewSpecialWarningMove(99268)--Spawning on you
local specWarnMeteorNear	= mod:NewSpecialWarningClose(99268)--Spawning on you
local yellMeteor			= mod:NewYell(99268)
local specWarnFixate		= mod:NewSpecialWarningRun(99849, nil, nil, nil, 4)--Chasing you after it spawned
local yellFixate			= mod:NewYell(99849)
local specWarnWorldofFlames	= mod:NewSpecialWarningSpell(100171, nil, nil, nil, true)
local specWarnDreadFlame	= mod:NewSpecialWarningMove(100941)--Standing in dreadflame
local specWarnEmpoweredSulf	= mod:NewSpecialWarningSpell(100604, "Tank", nil, nil, 3)--Heroic ability Asuming only the tank cares about this? seems like according to tooltip 5 seconds to hide him into roots?
local specWarnSuperheated	= mod:NewSpecialWarningStack(100593, true, 12)

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

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("BlazingHeatIcons", true)
mod:AddBoolOption("InfoHealthFrame", "Healer")--Phase 1 info framefor low health detection.
mod:AddBoolOption("AggroFrame", false)--Phase 2 info frame for seed aggro detection.
mod:AddBoolOption("MeteorFrame", true)--Phase 3 info frame for meteor fixate detection.

local firstSmash = false
local wrathcount = 0
local magmaTrapSpawned = 0
local magmaTrapGUID = {}
local elementalsGUID = {}
local elementalsSpawned = 0
local meteorSpawned = 0
local sonsLeft = 8
local phase = 1
local prewarnedPhase2 = false
local prewarnedPhase3 = false
local phase2Started = false
local blazingHeatIcon = 2
local seedsActive = false
local meteorWarned = false
local dreadflame, meteorTarget, staffDebuff, seedCast, deluge = DBM:GetSpellInfo(100675), DBM:GetSpellInfo(99849), DBM:GetSpellInfo(101109), DBM:GetSpellInfo(98333), DBM:GetSpellInfo(100713)
local dreadFlameTimer = 45

local function showRangeFrame()
	if DBM:UnitDebuff("player", staffDebuff) then return end--Staff debuff, don't change their range finder from 8.
	if mod.Options.RangeFrame then
		if phase == 1 and mod:IsRanged() then
			DBM.RangeCheck:Show(6)--For wrath of rag, only for ranged.
		elseif phase == 2 then
			DBM.RangeCheck:Show(6)--For seeds
		end
	end
end

local function hideRangeFrame()
	if DBM:UnitDebuff("player", staffDebuff) then return end--Staff debuff, don't hide it either.
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function TransitionEnded()
	timerPhaseSons:Cancel()
	timerLavaBoltCD:Cancel()
	if phase == 2 then
		if mod:IsDifficulty("heroic10", "heroic25") then
			timerSulfurasSmash:Start(6)
			if mod.Options.warnSeedsLand then
				timerMoltenSeedCD:Start(17.5)
			else
				timerMoltenSeedCD:Start(15)--14.8-16 variation. We use earliest time for safety.
			end
		else
			timerSulfurasSmash:Start(15.5)
			if mod.Options.warnSeedsLand then
				timerMoltenSeedCD:Start(24)--23-25 Variation. we use the average
			else
				timerMoltenSeedCD:Start(21.5)--Use the earliest known time, based on my logs is 21.5
			end
		end
		timerFlamesCD:Start()--Probably the only thing that's really consistent.
		showRangeFrame()--Range 6 for seeds
	elseif phase == 3 then
		timerSulfurasSmash:Start(15.5)--Also a variation.
		timerFlamesCD:Start(30)
		warnLivingMeteorSoon:Schedule(35)
		timerLivingMeteorCD:Start(45, 1)
	elseif phase == 4 then
		timerLivingMeteorCD:Cancel()
		warnLivingMeteorSoon:Cancel()
		timerFlamesCD:Cancel()
		timerSulfurasSmash:Cancel()
		timerBreadthofFrostCD:Start(33)
		timerDreadFlameCD:Start(48)
		timerCloudBurstCD:Start()
		timerEntrapingRootsCD:Start(67)
		timerEmpoweredSulfCD:Start(83)
	end
end

function mod:MagmaTrapTarget(targetname)
	warnMagmaTrap:Show(targetname)
	if targetname == UnitName("player") then
		specWarnMagmaTrap:Show()
		yellMagmaTrap:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 6 then
				specWarnMagmaTrapNear:Show(targetname)
			end
		end
	end
end

function mod:LivingMeteorTarget(targetname)
	warnLivingMeteor:Show(targetname)
	if targetname == UnitName("player") then
		specWarnMeteor:Show()
		yellMeteor:Yell()
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 12 then
				specWarnMeteorNear:Show(targetname)
			end
		end
	end
end

local function warnSeeds()
	warnMoltenSeed:Show()
	specWarnMoltenSeed:Show()
	timerMoltenSeedCD:Start()
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerWrathRagnaros:Start(6-delay)--4.5-6sec variation, as a result, randomizes whether or not there will be a 2nd wrath before sulfuras smash. (favors not tho)
	timerMagmaTrap:Start(16-delay)
	timerHandRagnaros:Start(-delay)
	timerSulfurasSmash:Start(-delay)
	wrathcount = 0
	table.wipe(magmaTrapGUID)
	table.wipe(elementalsGUID)
	magmaTrapSpawned = 0
	elementalsSpawned = 0
	meteorSpawned = 0
	sonsLeft = 8
	phase = 1
	firstSmash = false
	prewarnedPhase2 = false
	prewarnedPhase3 = false
	blazingHeatIcon = 2
	phase2Started = false
	seedsActive = false
	meteorWarned = false
	dreadFlameTimer = 45
	showRangeFrame()
	if self:IsDifficulty("normal10", "normal25") then--register alternate kill detection, he only dies on heroic.
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

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 99399 then
		warnBurningWound:Show(args.destName, args.amount or 1)
		if (args.amount or 0) >= 4 and args:IsPlayer() then
			specWarnBurningWound:Show(args.amount)
		end
		timerBurningWound:Start(args.destName)
	elseif spellId == 100594 and args:IsPlayer() then
		if (args.amount or 0) >= 12 and args.amount % 4 == 0 then
			specWarnSuperheated:Show(args.amount)
		end
	elseif spellId == 100171 then--World of Flames, heroic version for engulfing flames.
		specWarnWorldofFlames:Show()
		if phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start(60)--60 second CD in phase 2
		end
	elseif spellId == 100604 then
		warnEmpoweredSulf:Show(args.spellName)
		specWarnEmpoweredSulf:Show()
		timerEmpoweredSulf:Schedule(5)--Schedule 10 second bar to start when cast ends for buff active timer.
		timerEmpoweredSulfCD:Start()
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 99399 then
		timerBurningWound:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 98710 then
		firstSmash = true
		warnSulfurasSmash:Show()
		specWarnSulfurasSmash:Show()
		if phase == 1 or phase == 3 then
			timerSulfurasSmash:Start()--30 second cd in phase 1 and phase 3 in 3/4 difficulties
			if phase == 1 and wrathcount < 2 then--always 12 seconds after smash if 30 second CD (ie wrathcount didn't reach 2 before first smash)
				timerWrathRagnaros:Update(18, 30)--This is most accurate place to put it so we use auto correction here.
			end
		else
			timerSulfurasSmash:Start(40)--40 seconds in phase 2
			if not phase2Started then
				phase2Started = true
				if self:IsDifficulty("heroic10", "heroic25") then
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
		sonsLeft = 8
		phase = phase + 1
		self:Unschedule(warnSeeds)
		timerMoltenSeedCD:Cancel()
		timerMagmaTrap:Cancel()
		timerSulfurasSmash:Cancel()
		timerHandRagnaros:Cancel()
		timerWrathRagnaros:Cancel()
		timerFlamesCD:Cancel()
		hideRangeFrame()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerPhaseSons:Start(60)--Longer on heroic
		else
			timerPhaseSons:Start(47)--45 sec plus the 2 or so seconds he takes to actually come up and yell.
		end
		specWarnSplittingBlow:Show()
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
		if phase == 3 then
			timerFlamesCD:Start(30)--30 second CD in phase 3
		else
			timerFlamesCD:Start()--40 second CD in phase 2
		end
		--North: 99172
		--Middle: 99235
		--South: 99236
		if spellId == 99172 then--North
			if not self.Options.WarnEngulfingFlameHeroic and self:IsDifficulty("heroic10", "heroic25") then return end
			warnEngulfingFlame:Show(args.spellName, L.North)
			if self:IsMelee() or seedsActive then--Always warn melee classes if it's in melee (duh), warn everyone if seeds are active since 90% of strats group up in melee
				specWarnEngulfing:Show()
			end
		elseif spellId == 99235 then--Middle
			if not self.Options.WarnEngulfingFlameHeroic and self:IsDifficulty("heroic10", "heroic25") then return end
			warnEngulfingFlame:Show(args.spellName, L.Middle)
		elseif spellId == 99236 then--South
			if not self.Options.WarnEngulfingFlameHeroic and self:IsDifficulty("heroic10", "heroic25") then return end
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
		magmaTrapSpawned = magmaTrapSpawned + 1
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
		if not firstSmash then--First smash hasn't happened yet
			wrathcount = wrathcount + 1--So count wraths
		end
		if GetTime() - self.combatInfo.pull <= 5 or wrathcount == 2 then--We check if there were two wraths before smash, or if pull was within last 5 seconds.
			timerWrathRagnaros:Start(25)--if yes to either, this bar is always 25 seconds.
		else--First wrath was after 5 second mark and wrathcount not 2 so we have a 30 second cd wrath.
			if firstSmash then--Check if first smash happened yet to determine at this point whether to start a 30 second bar or the one time only 36 bar.
				timerWrathRagnaros:Start()--First smash already happened so it's later fight and this is always gonna be 30.
			else
				timerWrathRagnaros:Start(36)--First smash didn't happen yet, and first wrath happened later then 5 seconds into pull, 2nd smash will be delayed by sulfuras smash.
			end
		end
	elseif spellId == 100460 then	-- Blazing heat
		warnBlazingHeat:Show(args.destName)
		timerBlazingHeatCD:Start(args.sourceGUID)--args.sourceGUID is to support multiple cds when more then 1 is up at once
		if args:IsPlayer() then
			specWarnBlazingHeat:Show()
			yellBlazingHeat:Yell()
		end
		if self.Options.BlazingHeatIcons then
			self:SetIcon(args.destName, blazingHeatIcon, 8)
			if blazingHeatIcon == 2 then-- Alternate icons, they are cast too far apart to sort in a table or do icons at once, and there are 2 adds up so we need to do it this way.
				blazingHeatIcon = 1
			else
				blazingHeatIcon = 2
			end
		end
	elseif spellId == 99268 then
		meteorSpawned = meteorSpawned + 1
		if meteorSpawned == 1 or meteorSpawned % 2 == 0 then--Spam filter, announce at 1, 2, 4, 6, 8, 10 etc. The way that they spawn
			self:BossTargetScanner(52409, "LivingMeteorTarget", 0.025, 12)
			timerLivingMeteorCD:Start(45, meteorSpawned+1)--Start new one with new count
			warnLivingMeteorSoon:Schedule(35)
		end
		if self.Options.MeteorFrame and meteorSpawned == 1 then--Show meteor frame and clear any health or aggro frame because nothing is more important then meteors.
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

function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 98518 and not elementalsGUID[sourceGUID] then--Molten Inferno. elementals cast this on spawn.
		elementalsGUID[sourceGUID] = true--Add unit GUID's to ignore
		elementalsSpawned = elementalsSpawned + 1--Add up the total elementals
	elseif spellId == 98175 and not magmaTrapGUID[sourceGUID] then--Magma Trap Eruption. We use it to count traps that have been set off
		magmaTrapGUID[sourceGUID] = true--Add unit GUID's to ignore
		magmaTrapSpawned = magmaTrapSpawned - 1--Add up total traps
		if magmaTrapSpawned == 0 and self.Options.InfoHealthFrame and not seedsActive then--All traps are gone hide the health frame.
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 98870 and destGUID == UnitGUID("player") and self:AntiSpam(5, 2) then
		specWarnScorchedGround:Show()
	elseif spellId == 99144 and destGUID == UnitGUID("player") and self:AntiSpam(5, 2) then
		specWarnBlazingHeatMV:Show()
	elseif spellId == 100941 and destGUID == UnitGUID("player") and self:AntiSpam(5, 2) and not DBM:UnitBuff("player", deluge) then
		specWarnDreadFlame:Show()
	elseif spellId == 98981 and self:AntiSpam(3, 1) then--Reuse anti spam ID 1 again because lava bolts and wraths are never near eachother.
		timerLavaBoltCD:Start()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE--Have to track absorbs too for this method to work.

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.TransitionEnded1 or msg:find(L.TransitionEnded1) or msg == L.TransitionEnded2 or msg:find(L.TransitionEnded2) or msg == L.TransitionEnded3 or msg:find(L.TransitionEnded3) then--This is more reliable then adds which may or may not add up to 8 cause blizz sucks. Plus it's more precise anyways, timers seem more consistent with this method.
		TransitionEnded()
	elseif (msg == L.Phase4 or msg:find(L.Phase4)) and self:IsInCombat() then
		phase = 4
		TransitionEnded()--Easier to just trigger this and keep all phase change stuff in one place.
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find(dreadflame) then--This is more reliable then adds which may or may not add up to 8 cause blizz sucks. Plus it's more precise anyways, timers seem more consistent with this method.
		if dreadFlameTimer > 15 then
			dreadFlameTimer = dreadFlameTimer - 5
		end
		warnDreadFlame:Show()
		timerDreadFlameCD:Start(dreadFlameTimer)
	end
end

function mod:RAID_BOSS_WHISPER(msg)
	if msg:find(staffDebuff) then--Only person with staff sees this.
		self:SendSync("RageOfRagnaros", UnitName("player"))--Send it out so others can get notice too.
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
		if h > 80 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 72 and h < 75 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		elseif h > 50 and prewarnedPhase3 then
			prewarnedPhase3 = false
		elseif h > 42 and h < 45 and not prewarnedPhase3 then
			prewarnedPhase3 = true
			warnPhase3Soon:Show()
		end
	end
end

function mod:UNIT_AURA(uId)
	if DBM:UnitDebuff("player", meteorTarget) and not meteorWarned then--Warn you that you have a meteor
		specWarnFixate:Show()
		yellFixate:Yell()
		meteorWarned = true
	elseif not DBM:UnitDebuff("player", meteorTarget) and meteorWarned then--reset warned status if you don't have debuff
		meteorWarned = false
	end
end

local function clearSeedsActive()
	seedsActive = false
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	--TODO, switch to spellid once verified spellid is always same
	local spellName = DBM:GetSpellInfo(spellId)--TEMP, just get right spellID at some point
	if spellName == seedCast and not seedsActive then -- The true molten seeds cast.
		seedsActive = true
		timerMoltenInferno:Start(11.5)--1.5-2.5 variation, we use lowest +10 seconds
		if self.Options.warnSeedsLand then--Warn after they are on ground, typical strat for normal mode. Time not 100% consistent.
			self:Schedule(2.5, warnSeeds)--But use upper here
		else
			warnSeeds()
		end
		self:Schedule(17.5, clearSeedsActive)--Clear active/warned seeds after they have all blown up.
		if self.Options.AggroFrame then--Show aggro frame regardless if health frame is still up, it should be more important than health frame at this point. Shouldn't be blowing up traps while elementals are up.
			DBM.InfoFrame:SetHeader(L.NoAggro)
			if self:IsDifficulty("normal25", "heroic25") then
				DBM.InfoFrame:Show(10, "playeraggro", 0)--20 man has at least 5 targets without aggro, often more do to immunities. because of it's size, it's now off by default.
			else
				DBM.InfoFrame:Show(5, "playeraggro", 0)
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53140 then--Son of Flame
		sonsLeft = sonsLeft - 1
		if sonsLeft < 3 then
			warnSonsLeft:Show(sonsLeft)
		end
	elseif cid == 53500 then--Meteors
		meteorSpawned = meteorSpawned - 1
		if meteorSpawned == 0 and self.Options.MeteorFrame then--Meteors all gone, hide info frame
			DBM.InfoFrame:Hide()
			if magmaTrapSpawned >= 1 and self.Options.InfoHealthFrame then--If traps are still up we restore the health frame (why on earth traps would still up in phase 4 is beyond me).
				DBM.InfoFrame:SetHeader(L.HealthInfo)
				DBM.InfoFrame:Show(5, "health", 100000)
			end
		end	
	elseif cid == 53189 then--Molten elemental
		elementalsSpawned = elementalsSpawned - 1
		if elementalsSpawned == 0 and self.Options.AggroFrame then--Elementals all gone, hide info frame
			DBM.InfoFrame:Hide()
			if magmaTrapSpawned >= 1 and self.Options.InfoHealthFrame then--If traps are still up we restore the health frame.
				DBM.InfoFrame:SetHeader(L.HealthInfo)
				DBM.InfoFrame:Show(5, "health", 100000)
			end
		end
	elseif cid == 53231 then--Lava Scion
		timerBlazingHeatCD:Cancel(args.sourceGUID)
	end
end

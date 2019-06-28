local mod	= DBM:NewMod(829, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(68905, 68904)--Lu'lin 68905, Suen 68904
mod:SetEncounterID(1560)
mod:SetZone()
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 137491 137531",
	"SPELL_AURA_APPLIED 136752 137404 137375 137408 137417 137360 138855 138306 138300",
	"SPELL_AURA_APPLIED_DOSE 137408",--needs review
	"SPELL_AURA_REMOVED 137408",
	"SPELL_CAST_SUCCESS 137414",
	"SPELL_SUMMON 137419",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

local Lulin = select(2, EJ_GetCreatureInfo(1, 829))
local Suen = select(2, EJ_GetCreatureInfo(2, 829))

--Darkness
local warnNight							= mod:NewAnnounce("warnNight", 2, 108558)
local warnCrashingStarSoon				= mod:NewSoonAnnounce(137129, 3)
local warnBeastOfNightmares				= mod:NewTargetAnnounce(137375, 3, nil, "Tank|Healer")
--Light
local warnDay							= mod:NewAnnounce("warnDay", 2, 122789)
local warnLightOfDay					= mod:NewSpellAnnounce(137403, 2, nil, false)--Spammy, but leave it as an option at least
local warnFanOfFlames					= mod:NewStackAnnounce(137408, 2, nil, "Tank|Healer")
local warnFlamesOfPassion				= mod:NewSpellAnnounce(137414, 2)--Todo, check target scanning
local warnIceComet						= mod:NewSpellAnnounce(137419, 1)
--Celestials Assist
local warnTiger							= mod:NewSpellAnnounce(138855)
local warnSerpent						= mod:NewSpellAnnounce(138306)
local warnOx							= mod:NewSpellAnnounce(138300)
--Dusk
local warnDusk							= mod:NewAnnounce("warnDusk", 2, "236760")--"achievement_zone_easternplaguelands" (best Dusk icon i could find)
local warnTidalForce					= mod:NewCastAnnounce(137531, 3, 2)

--Darkness
local specWarnCosmicBarrage				= mod:NewSpecialWarningCount(136752, true, nil, nil, 2)--better as a cosmic barrage warning with cast bar being stars. Also good as count warning for cooldowns
local specWarnTearsOfSun				= mod:NewSpecialWarningSpell(137404, nil, nil, nil, 2)
local specWarnBeastOfNightmares			= mod:NewSpecialWarningTarget(137375, "Tank|Healer")
local specWarnCorruptedHealing			= mod:NewSpecialWarningStack(137360, "Healer")
--Light
local specWarnFanOfFlames				= mod:NewSpecialWarningStack(137408, nil, 2)
local specWarnFanOfFlamesOther			= mod:NewSpecialWarningTaunt(137408)
local specWarnFlamesofPassionMove		= mod:NewSpecialWarningMove(137417)
local specWarnIceComet					= mod:NewSpecialWarningSpell(137419, false)
local specWarnNuclearInferno			= mod:NewSpecialWarningCount(137491, nil, nil, nil, 2)--Heroic
--Dusk
local specWarnTidalForce				= mod:NewSpecialWarningSpell(137531, nil, nil, nil, 2)--Maybe switch to a stop dps warning, or a switch to Suen?

--Darkness
local timerDayCD						= mod:NewTimer(183, "timerDayCD", 122789) -- timer is 183 or 190 (confirmed in 10 man. variable)
local timerCrashingStar					= mod:NewNextTimer(4.5, 137129)
local timerCosmicBarrageCD				= mod:NewCDCountTimer(22, 136752)--VERY IMPORTANT on heroic, do not remove. many heroic strat ignore adds and group up BEFORE day phase starts so adds come to middle at phase start. Variation is unimportant, timer isn't to see when next cast is, it's to show safety window for when no cast will happen
local timerTearsOfTheSunCD				= mod:NewCDTimer(41, 137404)
local timerTearsOfTheSun				= mod:NewBuffActiveTimer(10, 137404)
local timerBeastOfNightmaresCD			= mod:NewCDTimer(51, 137375, nil, "Tank|Healer")
--Light
local timerDuskCD						= mod:NewTimer(360, "timerDuskCD", "236760")--it seems always 360s after combat entered. (day timer is variables, so not reliable to day phase)
local timerLightOfDayCD					= mod:NewCDTimer(6, 137403, nil, false)--Trackable in day phase using UNIT event since boss1 can be used in this phase. Might be useful for heroic to not run behind in shadows too early preparing for a special
local timerFanOfFlamesCD				= mod:NewCDTimer(12, 137408, nil, "Tank|Healer")
local timerFanOfFlames					= mod:NewTargetTimer(30, 137408, nil, "Tank")
--local timerFlamesOfPassionCD			= mod:NewCDTimer(30, 137414)--Also very high variation. (31~65). Can be confuse, no use.
local timerIceCometCD					= mod:NewCDTimer(20.5, 137419)--Every 20.5-25 seconds on normal. On 10 heroic, variables 20.5~41s. 25 heroic vary 20.5-27.
local timerNuclearInferno				= mod:NewBuffActiveTimer(12, 137491)
local timerNuclearInfernoCD				= mod:NewCDCountTimer(49.5, 137491)
--Celestials Assist
local timerTiger						= mod:NewBuffFadesTimer(20, 138855)
local timerSerpent						= mod:NewBuffFadesTimer(30, 138306)
local timerOx							= mod:NewBuffFadesTimer(30, 138300)
--Dusk
local timerTidalForce					= mod:NewBuffActiveTimer(18 ,137531)
local timerTidalForceCD					= mod:NewCDTimer(71, 137531)

local berserkTimer						= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrame")--For various abilities that target even melee. UPDATE, cosmic barrage (worst of the 3 abilities) no longer target melee. However, light of day and tears of teh sun still do. melee want to split into 2-3 groups (depending on how many) but no longer have to stupidly spread about all crazy and out of range of boss during cosmic barrage to avoid dying. On that note, MAYBE change this to ranged default instead of all.

local phase3Started = false
local invokeTiger, invokeCrane, invokeSerpent, invokeOx = DBM:GetSpellInfo(138264), DBM:GetSpellInfo(138189), DBM:GetSpellInfo(138267), DBM:GetSpellInfo(138254)
local infernoCount = 0
local cosmicCount = 0

local function isRunner(unit)
	if DBM:UnitDebuff(unit, invokeTiger, invokeCrane, invokeSerpent, invokeOx) then
		return true
	end
	return false
end

local constellationRunner
do
	constellationRunner = function(uId)
		return isRunner(uId)
	end
end

function mod:OnCombatStart(delay)
	phase3Started = false
	infernoCount = 0
	cosmicCount = 0
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8, not constellationRunner)
	end
end

function mod:OnCombatEnd()
	phase3Started = false
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 137491 then
		self:SendSync("Inferno")
	elseif spellId == 137531 then
		self:SendSync("TidalForce")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 136752 then
		self:SendSync("CosmicBarrage")
	elseif spellId == 137404 then
		specWarnTearsOfSun:Show()
		timerTearsOfTheSun:Start()
		if timerDayCD:GetTime() < 145 then
			timerTearsOfTheSunCD:Start()
		end
	elseif spellId == 137375 then
		warnBeastOfNightmares:Show(args.destName)
		specWarnBeastOfNightmares:Show(args.destName)
		if timerDayCD:GetTime() < 135 then
			timerBeastOfNightmaresCD:Start()
		end
	elseif spellId == 137408 then
		local amount = args.amount or 1
		local threatamount = self:IsTrivial(100) and 6 or 2
		timerFanOfFlames:Start(args.destName)
		timerFanOfFlamesCD:Start()
		if args:IsPlayer() then
			if amount >= threatamount then
				specWarnFanOfFlames:Show(amount)
			else
				warnFanOfFlames:Show(args.destName, amount)
			end
		else
			if amount >= threatamount and not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
				specWarnFanOfFlamesOther:Show(args.destName)
			else
				warnFanOfFlames:Show(args.destName, amount)
			end
		end
	elseif spellId == 137417 and args:IsPlayer() and self:AntiSpam(3, 4) then
		specWarnFlamesofPassionMove:Show()
	elseif spellId == 137360 and args:IsPlayer() then
		specWarnCorruptedHealing:Show(args.amount or 1)
	elseif spellId == 138855 and self:AntiSpam(3, 5) then
		warnTiger:Show()
		timerTiger:Start()
	elseif spellId == 138306 and self:AntiSpam(3, 5) then
		warnSerpent:Show()
		timerSerpent:Start()
	elseif spellId == 138300 and self:AntiSpam(3, 5) then
		warnOx:Show()
		timerOx:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 137408 then
		timerFanOfFlames:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 137414 then
		warnFlamesOfPassion:Show()
		--timerFlamesOfPassionCD:Start()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 137419 then
		self:SendSync("Comet")
	end
end

--"<333.5 18:37:56> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#Lu'lin! Lend me your strength!#Suen#####0#0##0#247#nil#0#false#false", -- [71265]
--"<339.3 18:38:02> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#1#1#Suen#0xF1310D2800005863#worldboss#410952978#nil#1#Unknown#0xF1310D2900005864#worldboss#310232488
function mod:CHAT_MSG_MONSTER_YELL(msg) -- Switch to yell. INSTANCE_ENCOUNTER_ENGAGE_UNIT fires too late. also yell ranage covers all rooms. Not need sync.
	if msg == L.DuskPhase or msg:find(L.DuskPhase) then
		self:SendSync("Phase3Yell")
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT(event) -- still remains backup trigger for phase3.
	if UnitExists("boss2") and self:GetCIDFromGUID(UnitGUID("boss2")) == 68905 then--Make sure we don't trigger it off another engage such as wipe engage event
		self:SendSync("Phase3")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 68905 then--Lu'lin
		timerCosmicBarrageCD:Cancel()
		timerTearsOfTheSunCD:Cancel()
		timerTidalForceCD:Cancel()
		timerBeastOfNightmaresCD:Cancel()
		timerDayCD:Cancel()
		timerDuskCD:Cancel()
		timerNuclearInfernoCD:Cancel()
		warnDay:Show()
		timerLightOfDayCD:Start()
		timerFanOfFlamesCD:Start(13)
		--She also does Flames of passion, but this is done 3 seconds after Lu'lin dies, is a 3 second timer worth it?
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		phase3Started = true
	elseif cid == 68904 then--Suen
		--timerFlamesOfPassionCD:Cancel()
		timerBeastOfNightmaresCD:Start(64)
		timerNuclearInfernoCD:Cancel()
		timerDuskCD:Cancel()
		warnNight:Show()
		phase3Started = true
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 137105 then--Suen Ports away (Night Phase)
		warnNight:Show()
		timerDayCD:Start()
		timerDuskCD:Start()
		timerCosmicBarrageCD:Start(17, 1)
		timerTearsOfTheSunCD:Start(28.5)
		timerBeastOfNightmaresCD:Start()
	elseif spellId == 137187 then--Lu'lin Ports away (Day Phase)
		self:SendSync("Phase2")
	elseif spellId == 138823 then
		warnLightOfDay:Show()
		timerLightOfDayCD:Start()
	end
end

--[[
patch 5.3 week 1 (want to see at least couple more logs to see if the "no second comet" bug is truely fixed.)
"<244.6 22:35:04> [UNIT_SPELLCAST_SUCCEEDED] Lu'lin [boss1:Dissipate::0:137187]",
"<266.0 22:35:26> [CLEU] SPELL_SUMMON#false#0xF1310D29000056FC#Lu'lin#2632#0#0xF1310FDC0000BA57#Ice Comet#2600#0#137419#Ice Comet#16",
"<290.2 22:35:50> [CLEU] SPELL_SUMMON#false#0xF1310D29000056FC#Lu'lin#2632#0#0xF1310FDC0000BB18#Ice Comet#2600#0#137419#Ice Comet#16",
"<293.5 22:35:53> [CLEU] SPELL_CAST_START#false#0xF1310D280000569B#Suen#68168#0##nil#-2147483648#-2147483648#137491#Nuclear Inferno#4",
"<315.4 22:36:15> [CLEU] SPELL_SUMMON#false#0xF1310D29000056FC#Lu'lin#2632#0#0xF1310FDC0000BBCB#Ice Comet#2600#0#137419#Ice Comet#16",
"<335.2 22:36:35> [CLEU] SPELL_SUMMON#false#0xF1310D29000056FC#Lu'lin#2632#0#0xF1310FDC0000BC4A#Ice Comet#2600#0#137419#Ice Comet#16",
"<362.8 22:37:02> [CLEU] SPELL_SUMMON#false#0xF1310D29000056FC#Lu'lin#2632#0#0xF1310FDC0000BCE1#Ice Comet#2600#0#137419#Ice Comet#16",
--]]
function mod:OnSync(msg)
	if msg == "Phase2" and GetTime() - self.combatInfo.pull >= 5 then--Rare cases, this fires on pull, we need to ignore it if it happens within 5 sec of pull
		timerCosmicBarrageCD:Cancel()
		timerTearsOfTheSunCD:Cancel()
		timerBeastOfNightmaresCD:Cancel()
		warnDay:Show()
		timerLightOfDayCD:Start()
		timerIceCometCD:Start()--TODO, update timer for late 5.3 hotfix.
		timerFanOfFlamesCD:Start(6)
		--timerFlamesOfPassionCD:Start(12.5)
		if self:IsHeroic() then
			timerNuclearInfernoCD:Start(45, 1)--45-50 second variation (cd is 45, but there is hard code failsafe that if a commet has spawned recently it's extended?
		end
		self:RegisterShortTermEvents(
			"INSTANCE_ENCOUNTER_ENGAGE_UNIT"
		)
	elseif msg == "Phase3Yell" and not phase3Started then -- Split from phase3 sync to prevent who running older version not to show bad timers.
		phase3Started = true
		cosmicCount = 0
		infernoCount = 0
		warnDusk:Show()
		timerIceCometCD:Start(17)--This seems to reset, despite what last CD was (this can be a bad thing if it was do any second)
		timerTidalForceCD:Start(26)
		if self:IsHeroic() then
			timerNuclearInfernoCD:Cancel()
			timerNuclearInfernoCD:Start(67, 1)
		end
		timerCosmicBarrageCD:Start(54, cosmicCount+1)--I want to analyze a few logs and readd this once I know for certain this IS the minimum time.
	elseif msg == "Phase3" and GetTime() - self.combatInfo.pull >= 5 then
		self:UnregisterShortTermEvents()
		timerFanOfFlamesCD:Cancel()--DO NOT CANCEL THIS ON YELL
		if not phase3Started then
			warnDusk:Show()
			phase3Started = true
			cosmicCount = 0
			infernoCount = 0
			timerIceCometCD:Start(11)--This seems to reset, despite what last CD was (this can be a bad thing if it was do any second)
			timerTidalForceCD:Start(20)
			if self:IsHeroic() then
				timerNuclearInfernoCD:Cancel()
				timerNuclearInfernoCD:Start(61, infernoCount+1)
			end
			timerCosmicBarrageCD:Start(48, cosmicCount+1)--I want to analyze a few logs and readd this once I know for certain this IS the minimum time.
		end
	elseif msg == "Comet" then
		warnIceComet:Show()
		specWarnIceComet:Show()
		if phase3Started then -- cd longer on phase 3.
			timerIceCometCD:Start(30.5)
		else
			timerIceCometCD:Start()
		end
	elseif msg == "TidalForce" then
		warnTidalForce:Show()
		specWarnTidalForce:Show()
		timerTidalForce:Start()
		timerTidalForceCD:Start()
	elseif msg == "CosmicBarrage" then
		cosmicCount = cosmicCount + 1
		warnCrashingStarSoon:Show()
		specWarnCosmicBarrage:Show(cosmicCount)
		timerCrashingStar:Start()
		if timerDayCD:GetTime() < 165 then
			timerCosmicBarrageCD:Start(nil, cosmicCount+1)
		end
	elseif msg == "Inferno" then
		infernoCount = infernoCount + 1
		specWarnNuclearInferno:Show(infernoCount)
		timerNuclearInferno:Start()
		if phase3Started then
			timerNuclearInfernoCD:Start(73, infernoCount+1)
		else
			timerNuclearInfernoCD:Start(nil, infernoCount+1)
		end
	end
end

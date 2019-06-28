local mod	= DBM:NewMod(683, "DBM-TerraceofEndlessSpring", nil, 320)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(60585, 60586, 60583)--60583 Protector Kaolan, 60585 Elder Regail, 60586 Elder Asani
mod:SetEncounterID(1409)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 117519 111850 117436 117283 117052 118191",
	"SPELL_AURA_APPLIED_DOSE 118191",
	"SPELL_AURA_REMOVED 117519 117436",
	"SPELL_CAST_START 117309 117975 117227 118077 118312",
	"SPELL_CAST_SUCCESS 117986 117052 118191"
)

local Kaolan = DBM:EJ_GetSectionInfo(5789)
local Regail = DBM:EJ_GetSectionInfo(5793)
local Asani = DBM:EJ_GetSectionInfo(5794)

local warnPhase2					= mod:NewPhaseAnnounce(2)
local warnPhase3					= mod:NewPhaseAnnounce(3)
--Elder Asani
local warnWaterBolt					= mod:NewCountAnnounce(118312, 3, nil, false)
local warnCleansingWaters			= mod:NewTargetAnnounce(117309, 3)--Phase 1+ ability. If target scanning fails, will switch to spell announce
--Elder Regail (Also uses Overwhelming Corruption in phase 3)
local warnLightningPrison			= mod:NewTargetAnnounce(111850, 3)--Phase 1+ ability.							
--Protector Kaolan
local warnTouchofSha				= mod:NewTargetAnnounce(117519, 3, nil, "Healer")--Phase 1+ ability. He stops casting it when everyone in raid has it then ceases. If someone dies and is brezed, he casts it on them again.
local warnDefiledGround				= mod:NewSpellAnnounce(117986, 3, nil, "Melee")--Phase 2+ ability.
--Heroic
local warnGroupOrder				= mod:NewAnnounce("warnGroupOrder", 1, 118191, false)--25 man for now, unless someone codes a 10 man version of it into code then it can be both.

--Elder Asani
local specWarnCleansingWaters		= mod:NewSpecialWarningTarget(117309, false)--This is if you want to move the boss out of waters before they can even gain it. Many strats don't ever move boss and just dispel it
local specWarnCleansingWatersDispel	= mod:NewSpecialWarningDispel(117309, "MagicDispeller")--The boss wasn't moved in time, now he needs to be dispelled.
local specWarnCorruptingWaters		= mod:NewSpecialWarningSwitch("ej5821", "Dps")
--Elder Regail
local specWarnLightningPrison		= mod:NewSpecialWarningYou(111850)--Debuff you gain before you are hit with it.
local yellLightningPrison			= mod:NewYell(111850)
local specWarnLightningStorm		= mod:NewSpecialWarningSpell(118077, nil, nil, nil, 2)--Since it's multiple targets, will just use spell instead of dispel warning.
--Protector Kaolan
local specWarnDefiledGround			= mod:NewSpecialWarningMove(117986, "Tank")
local specWarnExpelCorruption		= mod:NewSpecialWarningSpell(117975, nil, nil, nil, 2)--Entire raid needs to move.
--Minions of Fear
local specWarnYourGroup				= mod:NewSpecialWarning("specWarnYourGroup", false)
local specWarnCorruptedEssence		= mod:NewSpecialWarningStack(118191, true, 9)--You cannot get more than 9, if you get 9 you need to GTFO or you do big damage to raid

--Elder Asani
local timerCleansingWatersCD		= mod:NewCDTimer(32.5, 117309, nil, nil, nil, 3)
local timerCorruptingWatersCD		= mod:NewNextTimer(42, 117227, nil, nil, nil, 1)
--Elder Regail
local timerLightningPrisonCD		= mod:NewCDTimer(25, 111850, nil, nil, nil, 3)
local timerLightningStormCD			= mod:NewCDTimer(42, 118077, nil, nil, nil, 2)--Shorter Cd in phase 3 32 seconds.
local timerLightningStorm			= mod:NewBuffActiveTimer(14, 118077)
--Protector Kaolan
local timerTouchOfShaCD				= mod:NewCDTimer(29, 117519)--Need new heroic data, timers confirmed for 10 man and 25 man normal as 29 and 12
local timerDefiledGroundCD			= mod:NewNextTimer(15.5, 117986, nil, "Melee")
local timerExpelCorruptionCD		= mod:NewNextTimer(38.5, 117975, nil, nil, nil, 2, nil, nil, nil, 1, 4)--It's a next timer, except first cast. that one variates.

local berserkTimer					= mod:NewBerserkTimer(490)

mod:AddBoolOption("RangeFrame")--For Lightning Prison
mod:AddBoolOption("SetIconOnPrison", true)--For Lightning Prison (icons don't go out until it's DISPELLABLE, not when targetting is up).

local phase = 1
local totalTouchOfSha = 0
local prisonTargets = {}
local prisonIcon = 1--Will try to start from 1 and work up, to avoid using icons you are probalby putting on bosses (unless you really fail at spreading).
local prisonDebuff = DBM:GetSpellInfo(111850)
local prisonCount = 0
local asaniCasts = 0
local corruptedCount = 0
local myGroup = nil
local notARaid = false

local DebuffFilter
do
	DebuffFilter = function(uId)
		return DBM:UnitDebuff(uId, prisonDebuff)
	end
end

local function resetPrisonStatus()
	prisonCount = 0
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

local function warnPrisonTargets()
	if mod.Options.RangeFrame then
		if DBM:UnitDebuff("player", prisonDebuff) then--You have debuff, show everyone
			DBM.RangeCheck:Show(8, nil)
		else--You do not have debuff, only show players who do
			DBM.RangeCheck:Show(8, DebuffFilter)
		end
	end
	warnLightningPrison:Show(table.concat(prisonTargets, "<, >"))
	timerLightningPrisonCD:Start()
	table.wipe(prisonTargets)
	prisonIcon = 1
	mod:Schedule(11, resetPrisonStatus)--Because if a mage or paladin bubble/iceblock debuff, they do not get the stun, and it messes up prisonCount
end

function mod:WatersTarget(targetname)
	if not targetname then return end
	warnCleansingWaters:Show(targetname)
	if targetname == UnitName("target") then--You are targeting the target of this spell.
		specWarnCleansingWaters:Show(targetname)
	end
end

local function findGroupNumber()
	if UnitInRaid("player") then
		local name, _, subgroup = GetRaidRosterInfo(UnitInRaid("player"))
		myGroup = subgroup
	else--Probably next expansion and you're soloing or undermanning this shit not in a raid group.
		notARaid = true
	end
end

function mod:OnCombatStart(delay)
	phase = 1
	totalTouchOfSha = 0
	prisonCount = 0
	asaniCasts = 0
	corruptedCount = 0
	notARaid = false
	table.wipe(prisonTargets)
	timerCleansingWatersCD:Start(10-delay)
	timerLightningPrisonCD:Start(15.5-delay)
	if self:IsDifficulty("normal10", "heroic10") then
		timerTouchOfShaCD:Start(35-delay)
	else
		timerTouchOfShaCD:Start(15-delay)
	end
	if not self:IsDifficulty("lfr25") then
		berserkTimer:Start(-delay)
	end
	findGroupNumber()
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 117519 then
		totalTouchOfSha = totalTouchOfSha + 1
		warnTouchofSha:Show(args.destName)
		if totalTouchOfSha < DBM:GetNumGroupMembers() then--This ability will not be cast if everyone in raid has it.
			if self:IsDifficulty("normal10", "heroic10") then--Heroic is assumed same as 10 normal.
				timerTouchOfShaCD:Start()
			else
				timerTouchOfShaCD:Start(12)--every 12 seconds on 25 man. Not sure about LFR though. Will adjust next week accordingly
			end
		end
	elseif spellId == 111850 then--111850 is targeting debuff (NOT dispelable one)
		prisonTargets[#prisonTargets + 1] = args.destName
		prisonCount = prisonCount + 1
		if args:IsPlayer() then
			specWarnLightningPrison:Show()
			yellLightningPrison:Yell()
		end
		self:Unschedule(warnPrisonTargets)
		self:Schedule(0.3, warnPrisonTargets)
	elseif spellId == 117436 then--111850 is pre warning, mainly for player, 117436 is the actual final result, mainly for the healer dispel icons
		if self.Options.SetIconOnPrison then
			self:SetIcon(args.destName, prisonIcon)
			prisonIcon = prisonIcon + 1
		end
	elseif spellId == 117283 and args.destGUID == (UnitGUID("target") or UnitGUID("focus")) then -- not needed to dispel except for raid member's dealing boss. 
		specWarnCleansingWatersDispel:Show(args.destName)
	elseif spellId == 117052 then--Phase changes
		--Here we go off applied because then we can detect both targets in phase 1 to 2 transition.
		--There is some possiblity that other timers are reset or altered on phase 2-3 start. Light in case of Lightning storm Cd resetting in phase 3.
		--If any are missing that actually ALTER during a phase 2 or 3 transition they will be updated here.
		if phase == 2 then
			if args:GetDestCreatureID() == 60585 then--Elder Regail
				timerLightningStormCD:Start(25.5)--Starts 25.5~27
			elseif args:GetDestCreatureID() == 60586 then--Elder Asani
				timerCorruptingWatersCD:Start(10)
			elseif args:GetDestCreatureID() == 60583 then--Protector Kaolan
				timerDefiledGroundCD:Start(5)
			end
		elseif phase == 3 then
			if args:GetDestCreatureID() == 60583 then--Elder Regail
				timerLightningStormCD:Start(9.5)--His LS cd seems to reset in phase 3 since the CD actually changes.
			elseif args:GetDestCreatureID() == 60583 then--Protector Kaolan
				timerExpelCorruptionCD:Start(5)--5-10 second variation for first cast.
			end
		end
	elseif spellId == 118191 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 9 then
			specWarnCorruptedEssence:Show(amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 117519 then
		totalTouchOfSha = totalTouchOfSha - 1
	elseif spellId == 117436 then
		prisonCount = prisonCount - 1
		if prisonCount == 0 and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnPrison then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 117309 then
		self:BossTargetScanner(60586, "WatersTarget", 0.1, 15, true, true)
		timerCleansingWatersCD:Start()
	elseif spellId == 117975 then
		specWarnExpelCorruption:Show()
		timerExpelCorruptionCD:Start()
	elseif spellId == 117227 then
		specWarnCorruptingWaters:Show()
		timerCorruptingWatersCD:Start()
	elseif spellId == 118077 then
		specWarnLightningStorm:Show()
		if phase == 3 then
			timerLightningStormCD:Start(32)
		else
			timerLightningStormCD:Start(41)
		end
	elseif spellId == 118312 then--Asani water bolt
		if asaniCasts == 3 then asaniCasts = 0 end
		asaniCasts = asaniCasts + 1
		warnWaterBolt:Show(asaniCasts)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 117986 then
		warnDefiledGround:Show()
		timerDefiledGroundCD:Start()
		if args.sourceName == UnitName("target") then 
			specWarnDefiledGround:Show()
		end
	elseif spellId == 117052 and phase < 3 then--Phase changes
		phase = phase + 1
		--We cancel timers for whatever boss just died (ie boss that cast the buff, not the ones getting it)
		if args:GetSrcCreatureID() == 60585 then--Elder Regail
			timerLightningPrisonCD:Cancel()
			timerLightningStormCD:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		elseif args:GetSrcCreatureID() == 60586 then--Elder Asani
			timerCleansingWatersCD:Cancel()
			timerCorruptingWatersCD:Cancel()
		elseif args:GetSrcCreatureID() == 60583 then--Protector Kaolan
			timerTouchOfShaCD:Cancel()
			timerDefiledGroundCD:Cancel()
		end
	elseif spellId == 118191 then--Corrupted Essence
		--You dced, rebuild group number. Not sure how to recover corruptedCount though. Sync maybe, but then it may get screwed up by similtanious events like getting a sync .1 sec before this event and then being off by +1
		if not myGroup then
			findGroupNumber()
		end
		if notARaid then return end
		corruptedCount = corruptedCount + 1
		if self:IsDifficulty("heroic25") then
			--25 man 5 2 2 2, 1 2 2 2, 1 2 2 2, 1 2 2 2, 1 1 1 1 strat.
			if corruptedCount == 5 or corruptedCount == 12 or corruptedCount == 19 or corruptedCount == 26 or corruptedCount == 33 then
				warnGroupOrder:Show(2)
				if myGroup == 2 then
					specWarnYourGroup:Show()
				end
			elseif corruptedCount == 7 or corruptedCount == 14 or corruptedCount == 21 or corruptedCount == 28 or corruptedCount == 34 then
				warnGroupOrder:Show(3)
				if myGroup == 3 then
					specWarnYourGroup:Show()
				end
			elseif corruptedCount == 9 or corruptedCount == 16 or corruptedCount == 23 or corruptedCount == 30 or corruptedCount == 35 then
				warnGroupOrder:Show(4)
				if myGroup == 4 then
					specWarnYourGroup:Show()
				end
			elseif corruptedCount == 11 or corruptedCount == 18 or corruptedCount == 25 or corruptedCount == 32 then
				warnGroupOrder:Show(1)
				if myGroup == 1 then
					specWarnYourGroup:Show()
				end
			elseif corruptedCount == 36 then--Groups 1-4 are all at 9 stacks, boss not dead yet (low dps?) you send healer group in so you don't wipe.
				warnGroupOrder:Show(5)
			end
		--TODO, give 10 man some kind of rotation helper. Blue? I do not raid 10 man and cannot test this
		end
	end
end

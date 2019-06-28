local mod	= DBM:NewMod(737, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(62511)
mod:SetEncounterID(1499)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 123059 121949 122540 122395 122784 125502",
	"SPELL_AURA_APPLIED_DOSE 123059",
	"SPELL_AURA_REMOVED 122370 121994 121949 122540",
	"SPELL_CAST_START 122398 122402 122408 122413",
	"SPELL_CAST_SUCCESS 122348 121994 122532 123156 122389",
	"SPELL_DAMAGE 122504",
	"SPELL_MISSED 122504",
	"UNIT_SPELLCAST_STOP boss1 boss2"
)

--[[WoL Reg Expression
(spellid = 45477 or spellid = 122540 or spellid = 122532 or spellid = 122348) and fulltype = SPELL_CAST_SUCCESS or (spellid =122784 or spellid =121949 or spellid = 122395 or spellid = 121994) and fulltype = SPELL_AURA_APPLIED or (spellid =122370 or spellid = 122540 or spellid = 122395 or spellid = 121994) and fulltype = SPELL_AURA_REMOVED or (spellid = 122408 or spellid = 122413 or spellid = 122398 or spellid = 122540 or spellid = 122402) and fulltype = SPELL_CAST_START or fulltype = UNIT_DIED and (targetname = "Omegal" or targetname = "Shiramune")
(spellid = 45477 or spellid = 122540) and fulltype = SPELL_CAST_SUCCESS or (spellid =122784 or spellid =121949 or spellid = 122395 or spellid = 121994) and fulltype = SPELL_AURA_APPLIED or (spellid =122370 or spellid = 122540 or spellid = 122395 or spellid = 121994) and fulltype = SPELL_AURA_REMOVED or (spellid = 122408 or spellid = 122413 or spellid = 122398 or spellid = 122540 or spellid = 122402) and fulltype = SPELL_CAST_START or fulltype = UNIT_DIED and (targetname = "Omegal" or targetname = "Shiramune")
--]]
--Boss
local warnReshapeLifeTutor		= mod:NewAnnounce("warnReshapeLifeTutor", 1, 122784)--Another LFR focused warning really.
local warnReshapeLife			= mod:NewAnnounce("warnReshapeLife", 4, 122784)
local warnWillPower				= mod:NewAnnounce("warnWillPower", 3, 63050)
local warnAmberGlob				= mod:NewTargetAnnounce(125502, 4)
--Construct
local warnAmberExplosion		= mod:NewAnnounce("warnAmberExplosion", 3, 122398, false)--In case you want to get warned for all of them, but could be spammy later fight so off by default. This announce includes source of cast.
local warnStruggleForControl	= mod:NewTargetAnnounce(122395, 2, nil, false)--Disabled in phase 3 as at that point it's just a burn.
local warnDestabalize			= mod:NewStackAnnounce(123059, 1, nil, false)--This can be super spammy so off by default.
--Living Amber
local warnLivingAmber			= mod:NewSpellAnnounce("ej6261", 2, nil, false)--122348 is what you check spawns with. ALso spamming and off by default
local warnBurningAmber			= mod:NewCountAnnounce("ej6567", 2, nil, false)--Keep track of Burning Amber Puddles. Spammy, but nessesary for heroic for someone managing them.
--Amber Monstrosity
local warnAmberCarapace			= mod:NewTargetAnnounce(122540, 4)--Monstrosity Shielding Boss (phase 2 start)
local warnAmberExplosionSoon	= mod:NewSoonAnnounce(122402, 3)
local warnAmberExplosionAM		= mod:NewAnnounce("warnAmberExplosionAM", 4, 122398)-- in koKR, even 25 man, most starts have only 1 construct. So this warning needs to be enabled by default on koKR. 10 man also uses 1 construct start.
local warnInterruptsAvailable	= mod:NewAnnounce("warnInterruptsAvailable", 1, 122398)

--Boss
local specwarnAmberScalpel			= mod:NewSpecialWarningSpell(121994, nil, nil, nil, 2)
local specwarnReshape				= mod:NewSpecialWarningYou(122784)
local specwarnParasiticGrowth		= mod:NewSpecialWarningTarget(121949, "Healer")
local specwarnParasiticGrowthYou	= mod:NewSpecialWarningYou(121949) -- This warn will be needed at player is clustered together. Especially on Phase 3.
local specwarnAmberGlob				= mod:NewSpecialWarningYou(125502)
--Construct
local specwarnAmberExplosionYou		= mod:NewSpecialWarning("specwarnAmberExplosionYou")--Only interruptable by the player controling construct casting, so only that person gets warning. non generic used to make this one more specific.
local specwarnAmberExplosionAM		= mod:NewSpecialWarning("specwarnAmberExplosionAM", nil, nil, nil, 3)--Must be on by default. Amber montrosity's MUST be interrupted on heroic or it's an auto wipe. it hits for over 500k.
local specwarnAmberExplosionOther	= mod:NewSpecialWarning("specwarnAmberExplosionOther", false)--A compromise. loose non player controled constructs now off by default but should still be an option as they are still perfectly interruptable (and should be)
local specwarnAmberExplosion		= mod:NewSpecialWarningTarget(122398, nil, nil, nil, 2)--One you can't interrupt it
local specwarnWillPower				= mod:NewSpecialWarning("specwarnWillPower")--Special warning for when your will power is low (construct)
--local specwarnBossDebuff			= mod:NewSpecialWarning("specwarnBossDebuff")--Some special warning that says "get your ass to boss and refresh debuff NOW" (Debuff stacks up to 255 with 10% damage taken increase every stack, keeping buff up and stacking is paramount to dps check on heroic)
--Living Amber
local specwarnBurningAmber		= mod:NewSpecialWarningMove(122504)--Standing in a puddle
--Amber Monstrosity
local specwarnAmberMonstrosity	= mod:NewSpecialWarningSwitch("ej6254", "-Healer")
local specwarnFling				= mod:NewSpecialWarningSpell(122413, "Tank")
local specwarnMassiveStomp		= mod:NewSpecialWarningSpell(122408, "Melee", nil, nil, 2)

--Boss
local timerReshapeLifeCD		= mod:NewNextCountTimer(50, 122784, nil, nil, nil, 3)--50 second cd in phase 1-2, 15 second in phase 3. if no construct is up, cd is ignored and boss casts it anyways to make sure 1 is always up.
local timerAmberScalpelCD		= mod:NewNextTimer(40, 121994, nil, nil, nil, 3)--40 seconds after last one ENDED
local timerAmberScalpel			= mod:NewBuffActiveTimer(10, 121994)
local timerParasiticGrowthCD	= mod:NewCDTimer(35, 121949, nil, "Healer", nil, 5)--35-50 variation (most of the time 50, rare pulls he decides to use 35 sec cd instead)
local timerParasiticGrowth		= mod:NewTargetTimer(30, 121949, nil, "Healer")
--Construct
local timerAmberExplosionCD		= mod:NewNextSourceTimer(13, 122398, nil, nil, nil, 4)--13 second cd on player controled units, 18 seconds on non player controlled constructs
local timerDestabalize			= mod:NewTimer(15, "timerDestabalize", 123059)--timer Enables for all players. It's very importantant for heroic. (espcially on phase 2)
local timerStruggleForControl	= mod:NewTargetTimer(5, 122395, nil, false)
--Amber Monstrosity
local timerMassiveStompCD		= mod:NewCDTimer(18, 122408, nil, "Melee", nil, 2)--18-25 seconds variation
local timerFlingCD				= mod:NewCDTimer(25, 122413, nil, "Tank", nil, 5)--25-40sec variation.
local timerAmberExplosionAMCD	= mod:NewTimer(46, "timerAmberExplosionAMCD", 122402, nil, nil, 4)--Special timer just for amber monstrosity. easier to cancel, easier to tell apart. His bar is the MOST important and needs to be seperate from any other bar option.
local timerAmberExplosion		= mod:NewCastTimer(2.5, 122402)

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("InfoFrame", true)
mod:AddBoolOption("FixNameplates", true)--Because having 215937495273598637205175t9 hostile nameplates on screen when you enter a construct is not cool.

local Phase = 1
local Puddles = 0
local Constructs = 0
local constructCount = 0--NOT same as Constructs variable above. this is one is for counting them mainly in phase 1
local reshapeElapsed = 0
local playerIsConstruct = false
local warnedWill = false
local willNumber = 100--Last warned player will power number (not same as actual player will power)
local lastStrike = 0
local amDestabalizeStack = 0
local amWarnCount = 0
local Totems = nil
local Guardians = nil
local Pets = nil
local TPTPNormal = nil
local amberExplosion = DBM:GetSpellInfo(122402)
local Monstrosity = DBM:EJ_GetSectionInfo(6254)
local MutatedConstruct = DBM:EJ_GetSectionInfo(6249)
local canInterrupt = {}

function mod:AmberExplosionAMWarning()
	amWarnCount = amWarnCount + 1
	if amWarnCount < 6 then
		warnAmberExplosionAM:Show()
		self:ScheduleMethod(0.4, "AmberExplosionAMWarning")
	end
end

function mod:ReshapeTimerRestart()
	if Phase == 3 and (reshapeElapsed > 35.2 or reshapeElapsed == 0) then -- Not comfirmed. It's estimation
		timerReshapeLifeCD:Update(35.2, 50, 1)
	else
		timerReshapeLifeCD:Update(reshapeElapsed-0.2, 50, 1)
	end
end

local function warnAmberExplosionCast(spellId)
	if #canInterrupt == 0 then--This will never happen if fired by "InterruptAvailable" sync since it should always be 1 or greater. This is just a fallback if contructs > 0 and we scheduled "warnAmberExplosionCast" there
		specwarnAmberExplosion:Show(spellId == 122402 and Monstrosity or MutatedConstruct)--No interupts, warn the raid to prep for aoe damage with beware! alert.
	else--Interrupts available, lets call em out as a great tool to give raid leader split second decisions on who to allocate to the task (so they don't all waste it on same target and not have for next one).
		warnInterruptsAvailable:Show(spellId == 122402 and Monstrosity or MutatedConstruct, table.concat(canInterrupt, "<, >"))
	end
	table.wipe(canInterrupt)
end

function mod:OnCombatStart(delay)
	warnedWill = true--avoid wierd bug on pull
	willNumber = 100
	Phase = 1
	Puddles = 0
	Constructs = 0
	constructCount = 0
	lastStrike = 0
	amDestabalizeStack = 0
	table.wipe(canInterrupt)
	playerIsConstruct = false
	timerAmberScalpelCD:Start(9-delay)
	timerReshapeLifeCD:Start(20-delay, 1)
	timerParasiticGrowthCD:Start(23.5-delay)
	if not self:IsDifficulty("lfr25") then
		berserkTimer:Start(-delay)
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.WillPower)
		DBM.InfoFrame:SetSortingAsc(true)
		DBM.InfoFrame:Show(5, "playerpower", 1, ALTERNATE_POWER_INDEX)
	end
	if self.Options.FixNameplates then
		--Blizz settings either return 1 or nil, we pull users original settings first, then change em if appropriate after.
		Totems = GetCVarBool("nameplateShowEnemyTotems")
		Guardians = GetCVarBool("nameplateShowEnemyGuardians")
		Pets = GetCVarBool("nameplateShowEnemyPets")
		--Now change all settings to make the nameplates while in constructs not terrible.
		if not InCombatLockdown() then--Now restricted functions in combat in 5.4.8. My hope is that startcombat fires first, if not, prevent lua errors.
			if Totems then
				SetCVar("nameplateShowEnemyTotems", 0)
			end
			if Guardians then
				SetCVar("nameplateShowEnemyGuardians", 0)
			end
			if Pets then
				SetCVar("nameplateShowEnemyPets", 0)
			end
		end
		--Check for threat plates on pull and save users setting.
		if IsAddOnLoaded("TidyPlates_ThreatPlates") then
			TPTPNormal = TidyPlatesThreat.db.profile.nameplate.toggle["Normal"]--Returns true or false, use TidyPlatesNormal to save that value on pull
		end
	end
end

local function delayNamePlateRestore()
	if Totems then
		SetCVar("nameplateShowEnemyTotems", 1)
	end
	if Guardians then
		SetCVar("nameplateShowEnemyGuardians", 1)
	end
	if Pets then
		SetCVar("nameplateShowEnemyPets", 1)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.FixNameplates then
		--if any of settings were on before pull, we put them back to way they were.
		if not InCombatLockdown() then--Can't change options back yet
			if Totems then
				SetCVar("nameplateShowEnemyTotems", 1)
			end
			if Guardians then
				SetCVar("nameplateShowEnemyGuardians", 1)
			end
			if Pets then
				SetCVar("nameplateShowEnemyPets", 1)
			end
		else
			self:Schedule(3, delayNamePlateRestore)--So try again in 3 seconds. Hopefuly PLAYER_REGEN_ENABLED fired by then (mod:stop called before mod:oncombatend so this scheduling SHOULD work)
		end
		if IsAddOnLoaded("TidyPlates_ThreatPlates") then
			if TPTPNormal == true and not TidyPlatesThreat.db.profile.nameplate.toggle["Normal"] then--Normal plates were on when we pulled but aren't on now.
				TidyPlatesThreat.db.profile.nameplate.toggle["Normal"] = true--Turn them back on
				TidyPlates:ReloadTheme()--Call the Tidy plates update methods
				TidyPlates:ForceUpdate()
			end
		end
	end
end 

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 123059 then
		local cid = args:GetDestCreatureID()
		local amount = args.amount or 1
		if cid == 62511 or cid == 62711 then -- Only boss or monstrosity (most raids do not care about to construct)
			if Phase < 3 then -- ignore phase3, not useful and super spammy.
				warnDestabalize:Show(args.destName, amount)
			end
			if amount then
				timerDestabalize:Cancel(args.destName, amount - 1)
			end
			if self:IsDifficulty("lfr25") then
				timerDestabalize:Start(60, args.destName, amount)
			else
				timerDestabalize:Start(nil, args.destName, amount)
			end
			if cid == 62711 then 
				amDestabalizeStack = amount -- save for timer canceling.
			end
		end
	elseif spellId == 121949 then
		if not playerIsConstruct then--Healers do need to know this, but it's still a distraction as a construct for sound, they got the reg warning.
			specwarnParasiticGrowth:Show(args.destName)
		end
		if args:IsPlayer() then
			specwarnParasiticGrowthYou:Show()
		end
		timerParasiticGrowth:Start(args.destName)
		timerParasiticGrowthCD:Start()
	elseif spellId == 122540 then
		Phase = 2
		reshapeElapsed = timerReshapeLifeCD:GetTime(constructCount+1)
		timerReshapeLifeCD:Cancel()
		constructCount = 0
		warnAmberCarapace:Show(args.destName)
		if not playerIsConstruct then
			specwarnAmberMonstrosity:Show()
		end
		self:ScheduleMethod(0.2, "ReshapeTimerRestart")
		timerMassiveStompCD:Start(20)
		timerFlingCD:Start(33)
		warnAmberExplosionSoon:Schedule(50.5)
		timerAmberExplosionAMCD:Start(55.5, amberExplosion)
	elseif spellId == 122395 and Phase < 3 and not playerIsConstruct then
		warnStruggleForControl:Show(args.destName)
		timerStruggleForControl:Start(args.destName)
	elseif spellId == 122784 then
		Constructs = Constructs + 1
		constructCount = constructCount + 1
		warnReshapeLife:Show(args.spellName, args.destName, constructCount)
		if args:IsPlayer() then
			self:RegisterShortTermEvents(
				"UNIT_POWER_FREQUENT player"
			)
			playerIsConstruct = true
			warnedWill = true -- fix bad low will special warning on entering Construct. After entering vehicle, this will be return to false. (on alt.power changes)
			specwarnReshape:Show()
			warnReshapeLifeTutor:Show()
			timerAmberExplosionCD:Start(15, args.destName)--Only player needs to see this, they are only person who can do anything about it.
			if self.Options.FixNameplates and IsAddOnLoaded("TidyPlates_ThreatPlates") then
				if TPTPNormal == true then
					TidyPlatesThreat.db.profile.nameplate.toggle["Normal"] = false
					TidyPlates:ReloadTheme()--Call the Tidy plates update methods
					TidyPlates:ForceUpdate()
				end
			end
		end
		if Phase < 3 then
			timerReshapeLifeCD:Start(nil, constructCount+1)
		else
			timerReshapeLifeCD:Start(15, constructCount+1)--More often in phase 3
		end
	elseif spellId == 125502 then
		warnAmberGlob:Show(args.destName)
		if args:IsPlayer() then
			specwarnAmberGlob:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 122370 then
		Constructs = Constructs - 1
		if args:IsPlayer() then
			self:UnregisterShortTermEvents()
			playerIsConstruct = false
			if self.Options.FixNameplates and IsAddOnLoaded("TidyPlates_ThreatPlates") then
				if TPTPNormal == true and not TidyPlatesThreat.db.profile.nameplate.toggle["Normal"] then--Normal plates were on when we pulled but aren't on now.
					TidyPlatesThreat.db.profile.nameplate.toggle["Normal"] = true--Turn them back on
					TidyPlates:ReloadTheme()--Call the Tidy plates update methods
					TidyPlates:ForceUpdate()
				end
			end
		end
		timerAmberExplosionCD:Cancel(args.destName)
	elseif spellId == 121994 then
		timerAmberScalpelCD:Start()
	elseif spellId == 121949 then
		timerParasiticGrowth:Cancel(args.destName)
	elseif spellId == 122540 then--Phase 3
		Phase = 3
		reshapeElapsed = timerReshapeLifeCD:GetTime(constructCount+1)
		timerReshapeLifeCD:Cancel()
		timerMassiveStompCD:Cancel()
		timerFlingCD:Cancel()
		timerAmberExplosionAMCD:Cancel()
		constructCount = 0
		timerDestabalize:Cancel(Monstrosity, amDestabalizeStack)
		warnAmberExplosionSoon:Cancel()
		self:ScheduleMethod(0.2, "ReshapeTimerRestart")
		--He does NOT reset reshape live cd here, he finishes out last CD first, THEN starts using new one.
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 122398 then
		warnAmberExplosion:Show(args.sourceName, args.spellName)
		if args:GetSrcCreatureID() == 62701 then--Cast by a wild construct not controlled by player
			if playerIsConstruct and GetTime() - lastStrike >= 3.5 then--Player is construct and Amber Strike will be available before cast ends.
				specwarnAmberExplosionOther:Show(args.spellName, args.sourceName)
				if self:LatencyCheck() then--if you're too laggy we don't want you telling us you can interrupt it 2-3 seconds from now. we only care if you can interrupt it NOW
					self:SendSync("InterruptAvailable", UnitGUID("player")..":122398")
				end
			end
			timerAmberExplosionCD:Start(18, args.sourceName, args.sourceGUID)--Longer CD if it's a non player controlled construct. Everyone needs to see this bar because there is no way to interrupt these.
			self:Unschedule(warnAmberExplosionCast)
			self:Schedule(0.5, warnAmberExplosionCast, 122398)--Always check available interrupts and special warn if not
		elseif args.sourceGUID == UnitGUID("player") then--Cast by YOU
			specwarnAmberExplosionYou:Show(args.spellName)
			timerAmberExplosionCD:Start(13, args.sourceName)--Only player needs to see this, they are only person who can do anything about it.
		end
	elseif spellId == 122402 then--Amber Monstrosity
		if playerIsConstruct and GetTime() - lastStrike >= 3.5 then--Player is construct and Amber Strike will be available before cast ends.
			amWarnCount = 0
			self:AmberExplosionAMWarning()
			specwarnAmberExplosionAM:Show(args.spellName, args.sourceName)--On heroic, not interrupting amber montrosity is an auto wipe. this is single handedly the most important special warning of all!!!!!!
			if self:LatencyCheck() then--if you're too laggy we don't want you telling us you can interrupt it 2-3 seconds from now. we only care if you can interrupt it NOW
				self:SendSync("InterruptAvailable", UnitGUID("player")..":122402")
			end
		else
			warnAmberExplosion:Show(args.sourceName, args.spellName)
		end
		warnAmberExplosionSoon:Cancel()
		warnAmberExplosionSoon:Schedule(41)
		timerAmberExplosion:Start()
		timerAmberExplosionAMCD:Start(nil, args.spellName)
		self:Unschedule(warnAmberExplosionCast)
		self:Schedule(0.5, warnAmberExplosionCast, 122402)--Always check available interrupts and special warn if not
	elseif spellId == 122408 then
		if not playerIsConstruct then
			specwarnMassiveStomp:Show()
		end
		timerMassiveStompCD:Start()--Still start timer so you still have it when you leave construct
	elseif spellId == 122413 then
		if not playerIsConstruct then
			specwarnFling:Show()
		end
		timerFlingCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 122348 then
		warnLivingAmber:Show()
	elseif spellId == 121994 then
		specwarnAmberScalpel:Show()
	elseif spellId == 122532 then
		Puddles = Puddles + 1
		warnBurningAmber:Show(Puddles)
	elseif spellId == 123156 then
		Puddles = Puddles - 1
		warnBurningAmber:Show(Puddles)
	elseif spellId == 122389 and args.sourceGUID == UnitGUID("player") then--Amber Strike
		lastStrike = GetTime()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 122504 and destGUID == UnitGUID("player") and self:AntiSpam(3) then
		specwarnBurningAmber:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_POWER_FREQUENT(uId)
	local playerWill = UnitPower(uId, ALTERNATE_POWER_INDEX)
	if playerWill > willNumber then willNumber = playerWill end--Will power has gone up since last warning so reset that warning.
	if playerWill == 80 and willNumber > 80 then
		willNumber = 80
		warnWillPower:Show(willNumber)
	elseif playerWill == 50 and willNumber > 50 then--Works
		willNumber = 50
		warnWillPower:Show(willNumber)
	elseif playerWill == 30 and willNumber > 30 then
		willNumber = 30
		warnWillPower:Show(willNumber)
	elseif playerWill >= 22 and warnedWill then
		warnedWill = false
	elseif playerWill < 18 and not warnedWill then--5 seconds before 0 (after subtracking a budget of 8 for interrupt)
		warnedWill = true
		specwarnWillPower:Show()
	elseif playerWill == 10 and willNumber > 10 then--Works
		willNumber = 10
		warnWillPower:Show(willNumber)
	elseif playerWill == 4 and willNumber > 4 then
		willNumber = 4
		warnWillPower:Show(willNumber)
	end
end

function mod:UNIT_SPELLCAST_STOP(uId, _, spellId)
	if spellId == 122402 then--SPELL_INTERRUPT not always fires, so use UNIT_SPELLCAST_STOP
		timerAmberExplosion:Cancel()
		self:UnscheduleMethod("AmberExplosionAMWarning")
		amWarnCount = 6
	end
end

function mod:OnSync(msg, str)
	local guid, spellId
	if str then
		guid, spellId = string.split(":", str)
		spellId = tonumber(spellId or "")
	end
	if msg == "InterruptAvailable" and guid and spellId then
		canInterrupt[#canInterrupt + 1] = DBM:GetFullPlayerNameByGUID(guid)
		self:Unschedule(warnAmberExplosionCast)
		self:Schedule(0.5, warnAmberExplosionCast, spellId)
	end
end

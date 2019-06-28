local mod	= DBM:NewMod(959, "DBM-BlackrockFoundry", nil, 457)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(77325)--68168
mod:SetEncounterID(1704)
mod:SetZone()
mod:SetUsedIcons(3, 2, 1)
mod.respawnTime = 29.5

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 155992 159142 156928 158054 163008",
	"SPELL_AURA_APPLIED 156096 157000 156667 156401 156653 159179",
	"SPELL_AURA_REMOVED 156096 157000 156667 159179",
	"SPELL_CAST_SUCCESS 162579",
	"SPELL_PERIODIC_DAMAGE 156401",
	"SPELL_PERIODIC_MISSED 156401",
	"SPELL_ENERGIZE 104915",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, get damage ID for fire on ground created by Mortar
--TODO, check position of highest threat tank in phase 2 and guess which siege engine is going to come out (and type for mythic)?
local warnPhase						= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)
--Stage One: The Blackrock Forge
local warnMarkedforDeath			= mod:NewTargetCountAnnounce(156096, 4)--If not in combat log, find a RAID_BOSS_WHISPER event.
local warnMassiveDemolition			= mod:NewCountAnnounce(156479, 3, nil, "Ranged", 2)--As a regular warning, not too spammy and perfectly reasonable for ranged to be on by default.
--Stage Two: Storage Warehouse
local warnSiegemaker				= mod:NewCountAnnounce("ej9571", 3, 156667)
local warnFixate					= mod:NewTargetAnnounce(156653, 4)
--Stage Three: Iron Crucible
local warnAttachSlagBombs			= mod:NewTargetCountAnnounce(157000, 4)

--Stage One: The Blackrock Forge
local specWarnDemolition			= mod:NewSpecialWarningCount(156425, nil, nil, nil, 2, 2)
local specWarnMassiveDemolition		= mod:NewSpecialWarningCount(156479, false, nil, nil, 2)
local specWarnMarkedforDeath		= mod:NewSpecialWarningYou(156096, nil, nil, nil, 3, 2)
local specWarnMFDPosition			= mod:NewSpecialWarning("specWarnMFDPosition", nil, false, nil, 1)--Mythic Position Assignment. No option, connected to specWarnMarkedforDeath
local specWarnMarkedforDeathOther	= mod:NewSpecialWarningTargetCount(156096, false, nil, nil, 1, 2)
local yellMarkedforDeath			= mod:NewYell(156096)
local specWarnThrowSlagBombs		= mod:NewSpecialWarningCount(156030, nil, nil, nil, 2, 2)--This spell is not gtfo.
local specWarnShatteringSmash		= mod:NewSpecialWarningCount(155992, "Melee", nil, nil, nil, 2)
local specWarnMoltenSlag			= mod:NewSpecialWarningMove(156401)
--Stage Two: Storage Warehouse
local specWarnSiegemaker			= mod:NewSpecialWarningCount("ej9571", false)--Kiter switch. off by default. 
local specWarnSiegemakerPlatingFades= mod:NewSpecialWarningFades(156667, "Ranged", nil, 2)--Plating removed, NOW dps switch
local specWarnFixate				= mod:NewSpecialWarningRun(156653, nil, nil, nil, 4)
local yellFixate					= mod:NewYell(156653)
local specWarnMortarSoon			= mod:NewSpecialWarningSoon(156530, "Ranged")--Mortar prefers the furthest targets from siege engine. It's ranged job to bait it to a wall
local specWarnMassiveExplosion		= mod:NewSpecialWarningSpell(163008, nil, nil, nil, 2, 2)--Mythic
--Stage Three: Iron Crucible
local specWarnSlagEruption			= mod:NewSpecialWarningCount(156928, nil, nil, nil, 2)
local specWarnAttachSlagBombs		= mod:NewSpecialWarningYou(157000, nil, nil, nil, nil, 2)--May change to sound 3, but I don't want it confused with the even more threatening marked for death, so for now will try 1
local specWarnAttachSlagBombsOther	= mod:NewSpecialWarningTaunt(157000, nil, nil, nil, nil, 2)
local specWarnSlagPosition			= mod:NewSpecialWarning("specWarnSlagPosition", nil, false, nil, 1)
local yellAttachSlagBombs			= mod:NewYell(157000, nil, nil, 2)
local specWarnMassiveShatteringSmash= mod:NewSpecialWarningCount(158054, nil, nil, 2, 3, 2)
local specWarnFallingDebris			= mod:NewSpecialWarningCount(162585, nil, nil, nil, 2, 2)--Mythic (like Meteor)

--Stage One: The Blackrock Forge
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerDemolitionCD				= mod:NewNextCountTimer(45, 156425, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerMassiveDemolitionCD		= mod:NewNextCountTimer(6, 156479, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerMarkedforDeathCD			= mod:NewNextCountTimer(15.5, 156096, nil, nil, nil, 3, nil, nil, nil, 3, 4)--Deadly icon? DJ doesn't give it an icon so i won't either for now
local timerThrowSlagBombsCD			= mod:NewCDCountTimer(24.5, 156030, nil, "Melee", nil, 3, nil, nil, nil, 2, 4)--It's a next timer, but sometimes delayed by Shattering Smash
local timerShatteringSmashCD		= mod:NewCDCountTimer(44.5, 155992, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON, nil, 1, 5)--power based, can variate a little do to blizzard buggy power code.
local timerImpalingThrow			= mod:NewCastTimer(5, 156111, nil, nil, nil, nil, nil, DBM_CORE_DEADLY_ICON)--How long marked target has to aim throw at Debris Pile or Siegemaker
--Stage Two: Storage Warehouse
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerSiegemakerCD				= mod:NewNextCountTimer(50, "ej9571", nil, nil, nil, 1, 156667)
local timerMassiveExplosion			= mod:NewCastTimer(5, 163008, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
--Stage Three: Iron Crucible
mod:AddTimerLine(SCENARIO_STAGE:format(3))
local timerSlagEruptionCD			= mod:NewCDCountTimer(32.5, 156928, nil, nil, nil, 2)
local timerAttachSlagBombsCD		= mod:NewCDCountTimer(25.5, 157000, nil, nil, nil, 3)--26-28. Do to increased cast time vs phase 1 and 2 slag bombs, timer is 1 second longer on CD
local timerSlagBomb					= mod:NewCastTimer(5, 157015)
local timerFallingDebris			= mod:NewCastTimer(6, 162585)--Mythic
local timerFallingDebrisCD			= mod:NewNextCountTimer(40, 162585, nil, nil, nil, 5, nil, DBM_CORE_HEROIC_ICON)--Mythic

mod:AddSetIconOption("SetIconOnMarked", 156096, true)
mod:AddRangeFrameOption("6/10")
mod:AddBoolOption("PositionsAllPhases", false)
mod:AddHudMapOption("HudMapOnMFD", 156096)
mod:AddBoolOption("InfoFrame")

mod.vb.phase = 1
mod.vb.demolitionCount = 0
mod.vb.SlagEruption = 0
mod.vb.smashCount = 0
mod.vb.markCount = 0
mod.vb.markCount2 = 0
mod.vb.siegemaker = 0
mod.vb.deprisCount = 0
mod.vb.slagCastCount = 0
local slagPlayerCount = 0--Doesn't seem to be any value in syncing this, this value is always 0 except for 0.2-2 seconds at most, recovery wouldn't give an accurate count.
local smashTank = nil
local UnitName, UnitClass, UnitPowerMax = UnitName, UnitClass, UnitPowerMax
local markTargets = {}
local slagTargets = {}
local mortarsWarned = {}
local DBMHudMap = DBMHudMap
local tankFilter
local yellMFD2 = mod:NewYell(156096, L.customMFDSay, true, false)
local yellSlag2 = mod:NewYell(157000, L.customSlagSay, true, false)
local mfdDebuff, slagDebuff1, slagDebuff2 = DBM:GetSpellInfo(156096), DBM:GetSpellInfo(157000), DBM:GetSpellInfo(159179)
local playerName = UnitName("player")
do
	tankFilter = function(uId)
		if UnitName(uId) == smashTank then
			return true
		end
	end
end

local function massiveOver(self)
	smashTank = nil
	if not DBM:UnitDebuff("player", slagDebuff1) and not DBM:UnitDebuff("player", slagDebuff2) then
		DBM.RangeCheck:Hide()
	end
end

local function warnMarked(self)
	local countFormat = self.vb.markCount
	if self.vb.phase == 2 then
		countFormat = self.vb.markCount.."-"..self.vb.markCount2
	end
	local text = table.concat(markTargets, "<, >")
	if self.Options.SpecWarn156096targetcount then
		specWarnMarkedforDeathOther:Show(countFormat, text)
	else
		warnMarkedforDeath:Show(countFormat, text)
	end
	table.wipe(markTargets)
	--Begin Check Marked function
	if not DBM:UnitDebuff("player", mfdDebuff) then
		specWarnMarkedforDeathOther:Play("156096")
	end
	--Sort by raidid since combat log order may diff person to person
	--Order changed from left middle right to left right middle to match BW to prevent conflict in dual mod raids.
	--This feature was suggested and started before that mod appeared, but since it exists, focus is on ensuring they work well together
	--Feature disabled until phase 3
	if self:IsLFR() or (not self.Options.PositionsAllPhases and self.vb.phase ~= 3) then return end
	local mfdFound = 0
	local numGroupMembers = DBM:GetNumGroupMembers()
	local expectedTotal = self:IsMythic() and 3 or 2
	if numGroupMembers < 3 then return end--Future proofing solo raid. can't assign 3 positions if less than 3 people
	for i = 1, numGroupMembers do
		if DBM:UnitDebuff("raid"..i, mfdDebuff) then
			mfdFound = mfdFound + 1
			if UnitName("raid"..i) == playerName then
				if mfdFound == 1 then
					if self.Options.SpecWarn156096you then
						specWarnMFDPosition:Show(DBM_CORE_LEFT)
					end
					if self.Options.Yell156096 then
						yellMFD2:Yell(DBM_CORE_LEFT, playerName)
					end
					specWarnMFDPosition:Play("left")--Schedule another 0.7, for total of 1.2 second after "find shelder"
				elseif mfdFound == 2 then
					if self.Options.SpecWarn156096you then
						specWarnMFDPosition:Show(DBM_CORE_RIGHT)
					end
					if self.Options.Yell156096 then
						yellMFD2:Yell(DBM_CORE_RIGHT, playerName)
					end
					specWarnMFDPosition:Play("right")--Schedule another 0.7, for total of 1.2 second after "find shelder"
				elseif mfdFound == 3 then
					if self.Options.SpecWarn156096you then
						specWarnMFDPosition:Show(DBM_CORE_MIDDLE)
					end
					if self.Options.Yell156096 then
						yellMFD2:Yell(DBM_CORE_MIDDLE, playerName)
					end
					specWarnMFDPosition:Play("center")--Schedule another 0.7, for total of 1.2 second after "find shelder"
				end
			end
			if mfdFound == expectedTotal then break end
		end
	end
end

local function checkSlag(self)
	DBM:Debug("checkSlag running", 2)
	local numGroupMembers = DBM:GetNumGroupMembers()
	if numGroupMembers < 2 then return end--Future proofing solo raid. can't assign 2 positions if less than 2 people
	--Was originally going to also do this as 3 positions, but changed to match BW for compatability, for users who want to run DBM in BW dominant raids.
	--Looks like BW helper fixed melee check to not be broken. Now we have to match it to prevent mod conflict.
	local slagFound = 0
	local totalMelee = 0
	local tempTable = {}
	for i = 1, numGroupMembers do
		local unitID = "raid"..i
		if DBM:UnitDebuff(unitID, slagDebuff1) then--Tank excluded on purpose to match BW helper
			slagFound = slagFound + 1
			if self:IsMeleeDps(unitID) then
				DBM:Debug("Slag found on melee"..totalMelee, 2)
				totalMelee = totalMelee + 1
			end
			tempTable[slagFound] = UnitName(unitID)
			DBM:Debug("Slag "..slagFound.." found on "..UnitName(unitID), 2)
			if slagFound == 2 then break end
		end
	end
	if totalMelee == 1 then--Melee count exactly 1
		DBM:Debug("Slag melee count exactly 1, should be assigning 1 ranged one melee")
		--Assign melee to middle and ranged to back
		local playerIsMelee = self:IsMeleeDps()
		if playerIsMelee and ((tempTable[1] == playerName) or (tempTable[2] == playerName)) then
			if self.Options.SpecWarn157000you then
				specWarnSlagPosition:Show(DBM_CORE_MIDDLE)
			end
			if self.Options.Yell1570002 then
				yellSlag2:Yell(DBM_CORE_MIDDLE, playerName)
			end
		elseif not playerIsMelee and ((tempTable[1] == playerName) or (tempTable[2] == playerName)) then
			if self.Options.SpecWarn157000you then
				specWarnSlagPosition:Show(DBM_CORE_BACK)
			end
			if self.Options.Yell1570002 then
				yellSlag2:Yell(DBM_CORE_BACK, playerName)
			end
		end	
	else--Just use roster order
		DBM:Debug("Slag on 2 ranged or 2 melee")
		if tempTable[1] == playerName then
			if self.Options.SpecWarn157000you then
				specWarnSlagPosition:Show(DBM_CORE_MIDDLE)
			end
			if self.Options.Yell1570002 then
				yellSlag2:Yell(DBM_CORE_MIDDLE, playerName)
			end
		elseif tempTable[2] == playerName then
			if self.Options.SpecWarn157000you then
				specWarnSlagPosition:Show(DBM_CORE_BACK)
			end
			if self.Options.Yell1570002 then
				yellSlag2:Yell(DBM_CORE_BACK, playerName)
			end
		end	
	end
end

--Do not combine slag functions. warnSlag includes tank, checkSlag does NOT include tank.
local function warnSlag(self)
	warnAttachSlagBombs:Show(self.vb.slagCastCount, table.concat(slagTargets, "<, >"))
	table.wipe(slagTargets)
end

--/run DBM:GetModByName("959"):NoteTestFunction(1)
function mod:NoteTestFunction(count)
	specWarnShatteringSmash:Show(count)
end

function mod:OnCombatStart(delay)
	table.wipe(markTargets)
	table.wipe(slagTargets)
	table.wipe(mortarsWarned)
	self.vb.phase = 1
	self.vb.demolitionCount = 0
	self.vb.SlagEruption = 0
	self.vb.smashCount = 0
	self.vb.markCount = 0
	self.vb.slagCastCount = 0
	timerThrowSlagBombsCD:Start(5.2-delay, 1)
	timerDemolitionCD:Start(15-delay, 1)
	timerShatteringSmashCD:Start(21-delay, 1)
	if self:IsTank() then--Ability only concerns tank in phase 1
		if self.Options.InfoFrame then--Only tanks in phase 1
			DBM.InfoFrame:Show(5, "enemypower", 1)
		end
	end
	timerMarkedforDeathCD:Start(36-delay, 1)
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.HudMapOnMFD then
		DBMHudMap:Disable()
	end
	if self.Options.InfoFrame then--Only tanks in phase 1
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 155992 or spellId == 159142 then--Phase 1 and then phase 2 version.
		self.vb.smashCount = self.vb.smashCount + 1
		if self.vb.phase == 1 then
			timerShatteringSmashCD:Start(30, self.vb.smashCount+1)
			if self:IsTank() then--only warnk tank in phase 1
				specWarnShatteringSmash:Show(self.vb.smashCount)
				specWarnShatteringSmash:Play("carefly")
			end
		else
			if self:IsMythic() then
				timerShatteringSmashCD:Start(30.5, self.vb.smashCount+1)
			else
				timerShatteringSmashCD:Start(nil, self.vb.smashCount+1)
			end
			specWarnShatteringSmash:Show(self.vb.smashCount)--Warn all melee in phase 2
			specWarnShatteringSmash:Play("carefly")
		end
	elseif spellId == 156928 and self:AntiSpam(3, 5) then
		self.vb.SlagEruption = self.vb.SlagEruption + 1
		specWarnSlagEruption:Show(self.vb.SlagEruption)
		timerSlagEruptionCD:Start(nil, self.vb.SlagEruption+1)
	elseif spellId == 158054 then
		smashTank = UnitName("boss1target")
		self.vb.smashCount = self.vb.smashCount + 1
		specWarnMassiveShatteringSmash:Show(self.vb.smashCount)
		timerShatteringSmashCD:Start(24.5, self.vb.smashCount+1)--Use this cd bar in phase 3 as well, because text for "Massive Shattering Smash" too long.
		specWarnMassiveShatteringSmash:Play("carefly")
		if self.Options.RangeFrame and smashTank then
			--Open regular range frame if you are the smash tank, even if you are a bomb, because now you don't have a choice.
			if smashTank == UnitName("player") then
				DBM.RangeCheck:Show(6)
			--Don't open radar for massive smash if you are one of bomb targets
			elseif not DBM:UnitDebuff("player", slagDebuff1) and not DBM:UnitDebuff("player", slagDebuff2) then
				DBM.RangeCheck:Show(6, tankFilter)
			end
			self:Schedule(4, massiveOver, self)
		end
	--"<175.87 23:28:43> [CLEU] SPELL_CAST_START#Vehicle-0-3127-1205-1151-80660-0000732F74#自爆攻城戰車##nil#163008#巨大的爆炸#nil#nil", -- [13865]
	--"<182.00 23:28:49> [CLEU] UNIT_DIED##nil#Vehicle-0-3127-1205-1151-80660-0000732F74#自爆攻城戰車#-1#false#nil#nil", -- [14611]
	elseif spellId == 163008 then
		specWarnMassiveExplosion:Show()
		timerMassiveExplosion:Start()
		specWarnMassiveExplosion:Play("aesoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 162579 then
		self.vb.deprisCount = self.vb.deprisCount + 1
		specWarnFallingDebris:Show(self.vb.deprisCount)
		specWarnFallingDebris:Play("helpsoak")
		timerFallingDebris:Start()
		timerFallingDebrisCD:Start(nil, self.vb.deprisCount+1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 156096 then
		if self:AntiSpam(5, 3) then
			self.vb.markCount = self.vb.markCount + 1
			if self.vb.phase == 2 then
				self.vb.markCount2 = self.vb.markCount2 + 1
			end
			local timer
			if self.vb.phase == 3 then
				timer = 20.5
			else
				timer = 15.5
			end
			timerImpalingThrow:Start()
			timerMarkedforDeathCD:Start(timer, self.vb.markCount+1)
			local elapsed, total = timerShatteringSmashCD:GetTime(self.vb.smashCount+1)
			local remaining = total - elapsed
			DBM:Debug("Smash Elapsed: "..elapsed.." Smash Total: "..total.." Smash Remaining: "..remaining.." MFD Timer: "..timer, 2)
			if (remaining > timer) and (remaining < timer+6) then--Marked for death will come off cd before timerShatteringSmashCD comes off cd and delay the cast
				local extend = (timer+6)-remaining
				DBM:Debug("Delay detected, updating smash timer now. Extend: "..extend)
				timerShatteringSmashCD:Update(elapsed, total+extend, self.vb.smashCount+1)
			end
		end
		markTargets[#markTargets + 1] = args.destName
		self:Unschedule(warnMarked)
		local expectedMFDCount = self:IsMythic() and 3 or 2
		if #markTargets == expectedMFDCount then--Have all targets, warn immediately
			warnMarked(self)
		else
			self:Schedule(1.5, warnMarked, self)
		end
		if args:IsPlayer() then
			specWarnMarkedforDeath:Show()
			if self:IsLFR() or (not self.Options.PositionsAllPhases and self.vb.phase < 3) then
				yellMarkedforDeath:Yell()
				specWarnMarkedforDeath:Play("findshelter")
			end
		end
		if self.Options.SetIconOnMarked then
			self:SetSortedIcon(1.5, args.destName, 1, expectedMFDCount)
		end
		if self.Options.HudMapOnMFD then
			DBMHudMap:RegisterRangeMarkerOnPartyMember(spellId, "highlight", args.destName, 3, 5, 1, 1, 0, 0.5, nil, true, 1):Pulse(0.5, 0.5)
		end
	elseif spellId == 157000 then--Non Tank Version
		if self:AntiSpam(5, 4) then
			slagPlayerCount = 0--Reset to 0, once
			self.vb.slagCastCount = self.vb.slagCastCount + 1
			timerAttachSlagBombsCD:Start(nil, self.vb.slagCastCount+1)
		end
		slagPlayerCount = slagPlayerCount + 1--Add counter (not in antispam on purpose)
		slagTargets[#slagTargets + 1] = args.destName
		self:Unschedule(warnSlag)
		if #slagTargets == 3 then--Have all 3 targets (including tank), warn immediately
			warnSlag(self)
		else
			self:Schedule(2, warnSlag, self)
		end
		if self:IsMythic() and slagPlayerCount == 2 then--Counter 2, do checkSlag immediately, this of course means function has to run for everyone instead of just player, but that's harmless
			checkSlag(self)
		end
		if args:IsPlayer() and self:AntiSpam(3, 6) then
			specWarnAttachSlagBombs:Show()
			if not self:IsMythic() then
				yellAttachSlagBombs:Yell()
			end
			timerSlagBomb:Start()
			specWarnAttachSlagBombs:Play("runout")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 159179 then--Tank version
		slagTargets[#slagTargets + 1] = args.destName
		self:Unschedule(warnSlag)
		if #slagTargets == 3 then--Have all targets, warn immediately
			warnSlag(self)
		else
			self:Schedule(2, warnSlag, self)
		end
		if args:IsPlayer() and self:AntiSpam(3, 6) then
			specWarnAttachSlagBombs:Show()
			yellAttachSlagBombs:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		else
			specWarnAttachSlagBombsOther:Show(args.destName)
		end
		specWarnAttachSlagBombsOther:Play("changemt")
	elseif spellId == 156667 then
		self.vb.markCount2 = 0
		self.vb.siegemaker = self.vb.siegemaker + 1
		if not self.Options.SpecWarnej9571spell then
			warnSiegemaker:Show(self.vb.siegemaker)
		else
			specWarnSiegemaker:Show(self.vb.siegemaker)
		end
		timerSiegemakerCD:Start(nil, self.vb.siegemaker+1)
	elseif spellId == 156401 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnMoltenSlag:Show()
	elseif spellId == 156653 then
		if args:IsPlayer() then
			specWarnFixate:Show()
			yellFixate:Yell()
		else
			warnFixate:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 156096 then
		if self.Options.HudMapOnMFD then
			DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
		end
		timerImpalingThrow:Stop()
		if self.Options.SetIconOnMarked then
			self:SetIcon(args.destName, 0)
		end
	elseif (spellId == 157000 or spellId == 159179) and args:IsPlayer() then
		timerSlagBomb:Stop()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 156667 then
		specWarnSiegemakerPlatingFades:Show()
		specWarnSiegemakerPlatingFades:Play("ej9571")
	end
end

function mod:SPELL_ENERGIZE(_, _, _, _, destGUID, _, _, _, spellId, _, _, amount)
	if spellId == 104915 and destGUID == UnitGUID("boss1") then
		--TODO, even more complex marked for death checks here to factor that into energy updating.
		DBM:Debug("SPELL_ENERGIZE fired on Blackhand, 4 targets not hit? Amount: "..amount)
		local bossPower = UnitPower("boss1")
		bossPower = bossPower / 4--4 energy per second, smash every 25 seconds there abouts.
		local remaining = 25-bossPower
		timerShatteringSmashCD:Stop()--Prevent timer debug when updating timer
		timerShatteringSmashCD:Start(remaining, self.vb.smashCount+1)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 156401 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnMoltenSlag:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if (spellId == 156031 or spellId == 156998) and self:AntiSpam(2, 2) then--156031 phase 1, 156991 phase 2. 156998 is also usuable for phase 2 but 156991
		self.vb.slagCastCount = self.vb.slagCastCount + 1
		specWarnThrowSlagBombs:Show(self.vb.slagCastCount)
		timerThrowSlagBombsCD:Start(nil, self.vb.slagCastCount+1)
		specWarnThrowSlagBombs:Play("bombsoon")
	elseif spellId == 156425 then
		self.vb.demolitionCount = self.vb.demolitionCount + 1
		specWarnDemolition:Show(self.vb.demolitionCount)
		if self:IsMythic() then
			self.vb.deprisCount = 0
			timerDemolitionCD:Start(30.5, self.vb.demolitionCount + 1)
		else
			timerDemolitionCD:Start(nil, self.vb.demolitionCount + 1)
		end
		timerMassiveDemolitionCD:Start(nil, 1)
		if self:IsMythic() then
			timerMassiveDemolitionCD:Schedule(6, 3, 2)
			timerMassiveDemolitionCD:Schedule(9, 3, 3)
			timerMassiveDemolitionCD:Schedule(12, 3, 4)
			if self.Options.SpecWarn156479count then
				specWarnMassiveDemolition:Schedule(6, 1)
				specWarnMassiveDemolition:Schedule(9, 2)
				specWarnMassiveDemolition:Schedule(12, 3)
				specWarnMassiveDemolition:Schedule(15, 4)
			else
				warnMassiveDemolition:Schedule(6, 1)
				warnMassiveDemolition:Schedule(9, 2)
				warnMassiveDemolition:Schedule(12, 3)
				warnMassiveDemolition:Schedule(15, 4)
			end
		else
			timerMassiveDemolitionCD:Schedule(6, 5, 2)
			timerMassiveDemolitionCD:Schedule(11, 5, 3)
			if self.Options.SpecWarn156479count then
				specWarnMassiveDemolition:Schedule(6, 1)
				specWarnMassiveDemolition:Schedule(11, 2)
				specWarnMassiveDemolition:Schedule(16, 3)	
			else
				if not self:IsLFR() then
					warnMassiveDemolition:Schedule(6, 1)
					warnMassiveDemolition:Schedule(11, 2)
					warnMassiveDemolition:Schedule(16, 3)
				end
			end
		end
		specWarnDemolition:Play("aesoon")
	elseif spellId == 161347 then--Phase 2 Trigger
		self.vb.phase = 2
		self.vb.smashCount = 0
		self.vb.siegemaker = 0
		self.vb.markCount = 0
		self.vb.markCount2 = 0
		self.vb.slagCastCount = 0
		timerDemolitionCD:Stop()
		timerMassiveDemolitionCD:Cancel()
		timerMassiveDemolitionCD:Unschedule()--Redundant?
		specWarnMassiveDemolition:Cancel()
		warnMassiveDemolition:Cancel()
		timerThrowSlagBombsCD:Stop()
		timerThrowSlagBombsCD:Start(11, 1)--11-12.5
		timerSiegemakerCD:Start(15, 1)
		timerShatteringSmashCD:Stop()
		if self:IsMythic() then--Boss gain power faster on mythic phase 2
			timerShatteringSmashCD:Start(18, 1)--18 seen in 10 pulls worth of data.
		else
			timerShatteringSmashCD:Start(21, 1)--21-23 variation. Boss power is set to 66/100 automatically by transitions
		end
		timerMarkedforDeathCD:Stop()
		timerMarkedforDeathCD:Start(25.5, 1)
		warnPhase:Show(DBM_CORE_AUTO_ANNOUNCE_TEXTS.stage:format(2))
		warnPhase:Play("ptwo")
		--Maybe not needed whole phase, only when balcony adds are up? A way to detect and improve?
		if self.Options.RangeFrame and not self:IsMelee() then
			DBM.RangeCheck:Show(6)
		end
		if self.Options.InfoFrame then--Everyone in phase 2 and 3
			DBM.InfoFrame:Show(5, "enemypower", 1)
		end
		self:RegisterShortTermEvents(
			"UNIT_POWER_FREQUENT boss2 boss3 boss4 boss5"
		)
	elseif spellId == 161348 then--Phase 3 Trigger
		self:UnregisterShortTermEvents()
		self.vb.phase = 3
		self.vb.smashCount = 0
		self.vb.markCount = 0
		self.vb.slagCastCount = 0
		timerSiegemakerCD:Stop()
		timerThrowSlagBombsCD:Stop()
		if self:IsMythic() then
			timerFallingDebrisCD:Start(11, 1)
		end
		timerAttachSlagBombsCD:Start(11, 1)
		timerShatteringSmashCD:Stop()
		timerShatteringSmashCD:Start(26, 1)--26-28 variation. Boss power is set to 33/100 automatically by transition (after short delay)
		timerMarkedforDeathCD:Stop()
		if self:IsMythic() then
			timerMarkedforDeathCD:Start(22.5, 1)
		else
			timerMarkedforDeathCD:Start(17, 1)
		end
		timerSlagEruptionCD:Start(31.5, 1)
		warnPhase:Show(DBM_CORE_AUTO_ANNOUNCE_TEXTS.stage:format(3))
		warnPhase:Play("pthree")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	local power = UnitPower(uId)
	local guid = UnitGUID(uId)
	if power > 70 and not mortarsWarned[guid] then
		specWarnMortarSoon:Show()
		mortarsWarned[guid] = true
	end
end

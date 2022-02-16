local mod	= DBM:NewMod(1726, "DBM-EmeraldNightmare", nil, 768)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220201235234")
mod:SetCreatureID(103769)
mod:SetEncounterID(1864)
mod:SetUsedIcons(6, 2, 1)
mod:SetHotfixNoticeRev(15369)
mod.respawnTime = 15

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 207830 209443 205588",
	"SPELL_CAST_SUCCESS 206651 209158 224649 210264",
	"SPELL_SUMMON 210264",
	"SPELL_AURA_APPLIED 208431 206651 205771 209158 211802 209034 210451 224508 206005",
	"SPELL_AURA_APPLIED_DOSE 206651 209158",
	"SPELL_AURA_REMOVED 208431 211802 206651 209158 209034 210451 224508 206005",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--"<271.21 22:57:25> [CLEU] SPELL_PERIODIC_ENERGIZE##nil#Player-3693-07CA07EE#Jaybee#208385#Tainted Discharge#3#10", -- [5739]
--TODO, infoframe for remaining tainted discharge maybe? Has to be combined with alt power infoframe
--TODO, reverify mythic/LFR timers
--Nightmare Corruption
local warnDescentIntoMadness			= mod:NewTargetAnnounce(208431, 4)
local warnDream							= mod:NewYouAnnounce(206005, 1)
local warnDreamOthers					= mod:NewTargetAnnounce(206005, 1)
local warnTormentingSwipe				= mod:NewTargetAnnounce(224649, 2, nil, "Tank")
--Stage One: The Decent Into Madness
local warnNightmareBlades				= mod:NewTargetAnnounce(206656, 2)
local warnDarkeningSoul					= mod:NewStackAnnounce(206651, 3, nil, "Healer|Tank")
local warnTormentingFixation			= mod:NewTargetAnnounce(205771, 4)
--Stage Two: From the Shadows
local warnPhase2						= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnBlackeningSoul				= mod:NewStackAnnounce(209158, 3, nil, "Healer|Tank")
local warnNightmareInfusion				= mod:NewSpellAnnounce(209443, 4, nil, "Tank")
local warnBondsOfTerror					= mod:NewTargetAnnounce(209034, 2)
--Stage Three: Darkness and stuff
local warnPhase3						= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)
local warnNightmareTentacles			= mod:NewSpellAnnounce("ej12977", 3, 93708)

local specWarnDescentIntoMadness		= mod:NewSpecialWarningYou(208431)
local yellDescentIntoMadness			= mod:NewFadesYell(208431)
local specWarnDreaming					= mod:NewSpecialWarningCount(205843, nil, nil, nil, 1, 2)--Mythic
--Stage One: The Decent Into Madness
local specWarnNightmareBlades			= mod:NewSpecialWarningMoveAway(206656, nil, nil, nil, 1, 2)
local specWarnCorruptionHorror			= mod:NewSpecialWarningSwitchCount("ej12973", "-Healer", nil, nil, 1, 2)
local specWarnCorruptingNova			= mod:NewSpecialWarningSpell(207830, nil, nil, nil, 2, 2)
local specWarnDarkeningSoulYou			= mod:NewSpecialWarningStack(206651, nil, 3, nil, 2, 1, 6)
local specWarnDarkeningSoulOther		= mod:NewSpecialWarningTaunt(206651, nil, nil, nil, 1, 2)
local specWarnTormentingFixation		= mod:NewSpecialWarningMoveAway(205771, nil, nil, nil, 1, 2)
local specWarnNightmareInfusionOther	= mod:NewSpecialWarningTaunt(209443, nil, nil, nil, 1, 2)
--Stage Two: From the Shadows
local specWarnBondsOfTerror				= mod:NewSpecialWarningMoveTo(209034, nil, nil, nil, 1, 2)
local specWarnCorruptionMeteorYou		= mod:NewSpecialWarningYou(206308, nil, nil, nil, 1, 2)
local yellMeteor						= mod:NewFadesYell(206308)
local specWarnCorruptionMeteorAway		= mod:NewSpecialWarningDodge(206308, "-Tank", nil, nil, 2, 2)--No dream, high corruption, dodge it. Subjective and defaults may be altered to off.
local specWarnCorruptionMeteorTo		= mod:NewSpecialWarningMoveTo(206308, "-Tank", nil, nil, 1, 2)--Has dream, definitely should help
local specWarnBlackeningSoulYou			= mod:NewSpecialWarningStack(209158, nil, 3, nil, 2, 1, 6)
local specWarnBlackeningSoulOther		= mod:NewSpecialWarningTaunt(209158, nil, nil, nil, 1, 2)
local specWarnInconHorror				= mod:NewSpecialWarningSwitch("ej13162", "-Healer", nil, nil, 1, 2)

--Stage One: The Decent Into Madness
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerDarkeningSoulCD				= mod:NewCDTimer(7, 206651, nil, "Healer|Tank", nil, 5, nil, DBM_COMMON_L.MAGIC_ICON..DBM_COMMON_L.TANK_ICON)
local timerNightmareBladesCD			= mod:NewNextTimer(15.7, 206656, nil, "-Tank", 2, 3)
local timerLurkingEruptionCD			= mod:NewCDCountTimer(20.5, 208322, nil, "-Tank", 2, 3)
local timerCorruptionHorrorCD			= mod:NewNextCountTimer(82.5, 210264, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON, nil, 1, 4)
local timerCorruptingNovaCD				= mod:NewNextTimer(20, 207830, nil, nil, nil, 2)
local timerTormentingSwipeCD			= mod:NewCDTimer(10, 224649, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
--Stage Two: From the Shadows
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerBondsOfTerrorCD				= mod:NewCDTimer(14.1, 209034, nil, "-Tank", 2, 3)
local timerCorruptionMeteorCD			= mod:NewCDCountTimer(28, 206308, 57467, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON, nil, not mod:IsTank() and 3, 4)--Short text "meteor"
local timerBlackeningSoulCD				= mod:NewCDTimer(7.2, 209158, nil, "Healer|Tank", nil, 5, nil, DBM_COMMON_L.MAGIC_ICON..DBM_COMMON_L.TANK_ICON)
local timerNightmareInfusionCD			= mod:NewCDTimer(61.5, 209443, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 4)--61.5-62.5
local timerCallOfNightmaresCD			= mod:NewCDTimer(40, 205588, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON, nil, 1, 4)
--Stage Three: Darkness and stuff
mod:AddTimerLine(SCENARIO_STAGE:format(3))
local timerNightmareTentacleCD			= mod:NewCDTimer(20, "ej12977", nil, nil, nil, 1, 93708)--226194 is an icon consideration now

mod:AddInfoFrameOption("ej12970")
mod:AddBoolOption("InfoFrameFilterDream", true)
mod:AddRangeFrameOption(6, 208322)
mod:AddSetIconOption("SetIconOnBlades", 206656)
mod:AddSetIconOption("SetIconOnMeteor", 206308)

local lurkingTimers = {17, 20.5, 41, 20.5, 20.5}--{13.6, 26.3, 47.4, 20.7, 25.9} old. TODO, get more data, if all but one are 20.5, just code smarter without table
local corruptionName = DBM:EJ_GetSectionInfo(12970)
local darkSoul, blackSoul, dreamDebuff, blackened = DBM:GetSpellInfo(206651), DBM:GetSpellInfo(209158), DBM:GetSpellInfo(206005), DBM:GetSpellInfo(205612)
local bladesTarget = {}
local gatherTarget = {}
local playerName = UnitName("player")
local playerHasDream = false
mod.vb.phase = 1
mod.vb.lurkingCount = 0
mod.vb.corruptionHorror = 0
mod.vb.inconHorror = 0
mod.vb.meteorCount = 0
mod.vb.lastBonds = nil
mod.vb.dreamCount = 0

local function updateRangeFrame(self)
	if not self.Options.RangeFrame then return end
	if DBM:UnitDebuff("player", darkSoul) then
		if self:IsEasy() then
			DBM.RangeCheck:Show(15)
		else
			DBM.RangeCheck:Show(25)
		end
	elseif DBM:UnitDebuff("player", blackSoul) then
		DBM.RangeCheck:Show(10)--10 for tainted discharge?
	elseif self.vb.phase == 1 then--Maybe only show for ranged?
		DBM.RangeCheck:Show(6)--Will be rounded up by 7.1+ restrictions
	else
		DBM.RangeCheck:Hide()
	end
end

local function bondsWarning(self)
	local previousTarget = nil
	for i = 1, #gatherTarget do
		local name = gatherTarget[i]
		if previousTarget then
			if playerName == previousTarget then
				specWarnBondsOfTerror:Show(name)
				specWarnBondsOfTerror:Play("linegather")
			elseif playerName == name then
				specWarnBondsOfTerror:Show(previousTarget)
				specWarnBondsOfTerror:Play("linegather")
			end
		end
		previousTarget = name
	end
	table.wipe(gatherTarget)
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.lurkingCount = 0
	self.vb.corruptionHorror = 0
	self.vb.inconHorror = 0
	self.vb.meteorCount = 0
	self.vb.dreamCount = 0
	self.vb.lastBonds = nil
	table.wipe(bladesTarget)
	table.wipe(gatherTarget)
	timerDarkeningSoulCD:Start(-delay)
	timerLurkingEruptionCD:Start(13.6-delay, 1)
	timerNightmareBladesCD:Start(18.5-delay)
	timerCorruptionHorrorCD:Start(58.4-delay, 1)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(corruptionName)
		if self.Options.InfoFrameFilterDream then
			DBM.InfoFrame:Show(8, "playerpower", 5, ALTERNATE_POWER_INDEX, dreamDebuff)
		else
			DBM.InfoFrame:Show(8, "playerpower", 5, ALTERNATE_POWER_INDEX)
		end
	end
	updateRangeFrame(self)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 207830 then
		timerCorruptingNovaCD:Start(nil, args.sourceGUID)
		if self:AntiSpam(2, 1) then
			specWarnCorruptingNova:Show(args.sourceName)
			specWarnCorruptingNova:Play("aesoon")
		end
	elseif spellId == 209443 then
		if self.vb.phase == 3 then
			timerNightmareInfusionCD:Start(31.5)
		else
			timerNightmareInfusionCD:Start()
		end
		local targetName, uId = self:GetBossTarget(args.sourceGUID, true)
		if self:IsTanking("player", "boss1", nil, true) then
			--Player is current target, just give a generic warning, since if player has dream it doesn't matter, if player doesn't, it's OTHER tanks job to fix this
			warnNightmareInfusion:Show()
		else
			--Player has dream buff and current tank does NOT so TAUNT warning.
			if playerHasDream and not DBM:UnitDebuff(uId, dreamDebuff) then
				specWarnNightmareInfusionOther:Show(targetName)
				specWarnNightmareInfusionOther:Play("tauntboss")
			end
		end
	elseif spellId == 205588 then
		self.vb.inconHorror = self.vb.inconHorror + 1
		specWarnInconHorror:Show(self.vb.inconHorror)
		specWarnInconHorror:Play("killmob")
		timerCallOfNightmaresCD:Start(nil, self.vb.inconHorror+1)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 206651 then
		timerDarkeningSoulCD:Start()
	elseif spellId == 209158 then
		timerBlackeningSoulCD:Start()
	elseif spellId == 224649 then
		warnTormentingSwipe:Show(args.destName)
		timerTormentingSwipeCD:Start(nil, args.sourceGUID)
	elseif spellId == 210264 then
		self.vb.corruptionHorror = self.vb.corruptionHorror + 1
		specWarnCorruptionHorror:Show(self.vb.corruptionHorror)
		specWarnCorruptionHorror:Play("bigmob")
		timerCorruptionHorrorCD:Start(nil, self.vb.corruptionHorror+1)
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 210264 then
		timerTormentingSwipeCD:Start(10, args.destGUID)
		timerCorruptingNovaCD:Start(14.5, args.destGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 208431 then
		warnDescentIntoMadness:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnDescentIntoMadness:Show()
			if not playerHasDream then
				yellDescentIntoMadness:Schedule(19, 1)
				yellDescentIntoMadness:Schedule(18, 2)
				yellDescentIntoMadness:Schedule(17, 3)
			end
		end
	elseif spellId == 206651 then
		local amount = args.amount or 1
		warnDarkeningSoul:Show(args.destName, amount)
		if args:IsPlayer() then
			if amount >= 3 then
				specWarnDarkeningSoulYou:Show(amount)
				specWarnDarkeningSoulYou:Play("stackhigh")
			end
			updateRangeFrame(self)
		else
			if amount >= 4 then
				local filterWarning = false
				if self:GetNumAliveTanks() >= 3 then
					--Three (or more) Tank Strat AND at least 3 alive
					for i = 1, 5 do
						--Check if tanking a big add
						local bossUnitID = "boss"..i
						if UnitExists(bossUnitID) and self:IsTanking("player", bossUnitID, nil, true) and self:GetCIDFromGUID(UnitGUID(bossUnitID)) == 103695 then
							filterWarning = true--Tanking big add, in 3 tank strat means this tank has nothing to do with boss swapping.
							break
						end
					end
				end
				if not filterWarning then
					specWarnDarkeningSoulOther:Show(args.destName)
					specWarnDarkeningSoulOther:Play("tauntboss")
				end
			end
		end
	elseif spellId == 209158 then
		local amount = args.amount or 1
		warnBlackeningSoul:Show(args.destName, amount)
		if args:IsPlayer() then
			if amount >= 3 then
				specWarnBlackeningSoulYou:Show(amount)
				specWarnBlackeningSoulYou:Play("stackhigh")
			end
			updateRangeFrame(self)
		else
			if amount >= 4 then
				local filterWarning = false
				if self:GetNumAliveTanks() >= 3 then
					--Three (or more) Tank Strat AND at least 3 alive
					for i = 1, 5 do
						--Check if tanking a big add
						local bossUnitID = "boss"..i
						if UnitExists(bossUnitID) and self:IsTanking("player", bossUnitID, nil, true) and self:GetCIDFromGUID(UnitGUID(bossUnitID)) == 103695 then
							filterWarning = true--Tanking big add, in 3 tank strat means this tank has nothing to do with boss swapping.
							break
						end
					end
				end
				if not filterWarning and not DBM:UnitDebuff("player", blackened) then
					specWarnBlackeningSoulOther:Show(args.destName)
					specWarnBlackeningSoulOther:Play("tauntboss")
				end
			end
		end
	elseif spellId == 205771 then
		warnTormentingFixation:CombinedShow(1, args.destName)
		if args:IsPlayer() then
			specWarnTormentingFixation:Show()
			specWarnTormentingFixation:Play("targetyou")
		end
	elseif spellId == 211802 then
		warnNightmareBlades:CombinedShow(0.5, args.destName)
		if not tContains(bladesTarget, args.destName) then
			bladesTarget[#bladesTarget+1] = args.destName
		end
		if args:IsPlayer() then
			specWarnNightmareBlades:Show()
			specWarnNightmareBlades:Play("runout")
		end
		if self.Options.SetIconOnBlades then
			self:SetIcon(args.destName, #bladesTarget)
		end
	elseif spellId == 209034 or spellId == 210451 then
		warnBondsOfTerror:CombinedShow(0.5, args.destName)
		self:Unschedule(bondsWarning)
		if not tContains(gatherTarget, args.destName) then
			gatherTarget[#gatherTarget+1] = args.destName
		end
		if #gatherTarget == 2 then--Know it's 2 on heroic and normal, mythic unknown LFR assumed can't be more than normal/heroic.
			bondsWarning(self)
		else
			self:Schedule(1, bondsWarning, self)
		end
	elseif spellId == 224508 then
		if args:IsPlayer() then
			specWarnCorruptionMeteorYou:Show()
			specWarnCorruptionMeteorYou:Play("targetyou")
			yellMeteor:Countdown(spellId)
		else
			if playerHasDream then
				specWarnCorruptionMeteorTo:Show(args.destName)
				specWarnCorruptionMeteorTo:Play("gathershare")
			else
				local maxPower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
				if maxPower > 0 then
					local playerPower = UnitPower("player", ALTERNATE_POWER_INDEX) / maxPower * 100
					if self.vb.phase == 3 and playerPower > 75 or playerPower > 55 then--Avoid it if corruption too high for it
						specWarnCorruptionMeteorAway:Show()
						specWarnCorruptionMeteorAway:Play("watchstep")
					end
				end
			end
		end
		if self.Options.SetIconOnMeteor then
			self:SetIcon(args.destName, 6)
		end
	elseif spellId == 206005 then
		if args:IsPlayer() then
			playerHasDream = true
		end
		if self:IsTank() then
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId and self:IsTanking(uId) then
				warnDreamOthers:CombinedShow(0.3, args.destName)
			end
		elseif self:IsHealer() then
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId and self:IsHealer(uId) then
				warnDreamOthers:CombinedShow(0.3, args.destName)
			end
		else--Just an unspecial dps
			if args:IsPlayer() then
				warnDream:Show()
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 208431 and args:IsPlayer() then
		yellDescentIntoMadness:Cancel()
	elseif spellId == 211802 then
		bladesTarget[args.destName] = nil
		if self.Options.SetIconOnBlades then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 206651 then
		if args:IsPlayer() then
			updateRangeFrame(self)
		end
	elseif spellId == 209158 then
		if args:IsPlayer() then
			updateRangeFrame(self)
		end
	elseif spellId == 209034 or spellId == 210451 then
	elseif spellId == 224508 then
		if args:IsPlayer() then
			yellMeteor:Cancel()
		end
		if self.Options.SetIconOnMeteor then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 206005 then
		if args:IsPlayer() then
			playerHasDream = false
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 103695 then--Corruption Horror
		timerCorruptingNovaCD:Stop(args.destGUID)
		timerTormentingSwipeCD:Stop(args.destGUID)
	end
end

function mod:SPELL_PERIODIC_ENERGIZE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 208385 then
		DBM:Debug("SPELL_PERIODIC_ENERGIZE fired for Tainted Discharge", 3)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 206341 then--Corruption Meteor (casting not in combat log, targetting is finally but I trust this more for timer in case targetting can be gamed.)
		self.vb.meteorCount = self.vb.meteorCount + 1
		if self.vb.phase == 3 then
			timerCorruptionMeteorCD:Start(35, self.vb.meteorCount+1)--35-38 in phase 3
		else
			timerCorruptionMeteorCD:Start(nil, self.vb.meteorCount+1)--Generally always 28
		end
	elseif spellId == 209000 then--Nightmare Blades (casting not in combat log)
		if self.vb.phase == 3 then
			timerNightmareBladesCD:Start(30)--Every 30 or so
		else
			timerNightmareBladesCD:Start()--Every 15.7 or so
		end
	elseif spellId == 209034 then--Bonds of Terror (casting not in combat log)
		timerBondsOfTerrorCD:Start()
	elseif spellId == 208322 then--Lurking Eruption
		self.vb.lurkingCount = self.vb.lurkingCount + 1
		local timers = lurkingTimers[self.vb.lurkingCount+1]
		if timers then
			timerLurkingEruptionCD:Start(timers, self.vb.lurkingCount+1)
		else
			timerLurkingEruptionCD:Start(20.5, self.vb.lurkingCount+1)
		end
	elseif spellId == 226193 then--Xavius Energize Phase 2
		self.vb.phase = 2
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		timerNightmareBladesCD:Stop()
		timerLurkingEruptionCD:Stop()
		timerCorruptionHorrorCD:Stop()
		timerBlackeningSoulCD:Start(7)
		timerBondsOfTerrorCD:Start(14)
		timerCorruptionMeteorCD:Start(21, 1)
		timerCallOfNightmaresCD:Start(23, 1)
		timerNightmareInfusionCD:Start(30)
		updateRangeFrame(self)
		self:RegisterShortTermEvents(
			"SPELL_PERIODIC_ENERGIZE 208385"
		)
	elseif spellId == 226185 then--Xavius Energize Phase 3
		self.vb.phase = 3
		warnPhase3:Show()
		warnPhase3:Play("pthree")
		timerBlackeningSoulCD:Stop()
		timerBondsOfTerrorCD:Stop()
		timerCallOfNightmaresCD:Stop()
		timerCorruptionMeteorCD:Stop()
		timerNightmareInfusionCD:Stop()
		timerNightmareInfusionCD:Start(11)
		timerBlackeningSoulCD:Start(15)
		timerCorruptionMeteorCD:Start(20.5, 1)
		timerNightmareBladesCD:Start(30)
		self:UnregisterShortTermEvents()
	elseif spellId == 226194 then--Writhing Deep
		warnNightmareTentacles:Show()
		timerNightmareTentacleCD:Start()
	elseif spellId == 205843 and self:IsMythic() then
		self.vb.dreamCount = self.vb.dreamCount + 1
		local count = self.vb.dreamCount
		specWarnDreaming:Show(count)
		specWarnDreaming:Play(nil, "Interface\\AddOns\\DBM-VP"..DBM.Options.ChosenVoicePack2.."\\count\\"..count..".ogg")
		specWarnDreaming:ScheduleVoice(1, "stepring")
	end
end

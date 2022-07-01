local mod	= DBM:NewMod(1738, "DBM-EmeraldNightmare", nil, 768)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220610054336")
mod:SetCreatureID(105393)
mod:SetEncounterID(1873)
mod:SetUsedIcons(8, 4, 3, 2, 1)
mod:SetHotfixNoticeRev(15422)
mod.respawnTime = 29

mod:RegisterCombat("combat")
mod.syncThreshold = 30

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 210931 209471 208697 208929 208689 210781 208685 218415 223121",
	"SPELL_CAST_SUCCESS 210984 215128 209387 208929",
	"SPELL_AURA_APPLIED 209915 210099 210984 215234 215128 212886",
	"SPELL_AURA_APPLIED_DOSE 210984",
	"SPELL_AURA_REMOVED 209915 215128 208929",
	"SPELL_PERIODIC_DAMAGE 212886",
	"SPELL_PERIODIC_MISSED 212886",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	"UNIT_DIED",
	"RAID_BOSS_WHISPER",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

--TODO, fix more adds timers (especially corruptors/deathglarers)
--Stage One: The Ruined Ground
--(ability.id = 208697 or ability.id = 208929 or ability.id = 218415) and type = "begincast" or ability.id = 209915
local warnNightmareGaze				= mod:NewSpellAnnounce(210931, 3, nil, false)--Something tells me this is just something it spam casts
local warnFixate					= mod:NewTargetAnnounce(210099, 2, nil, false)--Spammy so default off
local warnNightmareExplosion		= mod:NewCastAnnounce(209471, 3)
local warnEyeOfFate					= mod:NewStackAnnounce(210984, 2, nil, "Tank")
local warnCorruptorTentacle			= mod:NewCountAnnounce("ej13191", 2, 208929)
local warnSpewCorruption			= mod:NewTargetAnnounce(208929, 3, nil, true, 2)
local warnSpewCorruptionSoon		= mod:NewSoonAnnounce(208929, 3)
local warnGroundSlam				= mod:NewTargetAnnounce(208689, 2)--Figure this out later
local warnDeathglareTentacle		= mod:NewCountAnnounce("ej13190", 2, 208697)
local warnDeathBlossom				= mod:NewCastAnnounce(218415, 4)
--Stage Two: The Heart of Corruption
local warnCursedBlood				= mod:NewTargetAnnounce(215128, 3)

--Stage One: The Ruined Ground
local specWarnNightmareCorruption	= mod:NewSpecialWarningMove(212886, nil, nil, nil, 1, 2)
local specWarnFixate				= mod:NewSpecialWarningMoveTo(210099, nil, nil, nil, 1, 2)
local specWarnNightmareHorror		= mod:NewSpecialWarningSwitch("ej13188", "-Healer", nil, nil, 1, 2)--spellId for summon 210289
local specWarnEyeOfFate				= mod:NewSpecialWarningStack(210984, nil, 2, nil, nil, 1, 6)
local specWarnEyeOfFateOther		= mod:NewSpecialWarningTaunt(210984, nil, nil, nil, 1, 2)
local specWarnMindFlay				= mod:NewSpecialWarningInterrupt(208697, "HasInterrupt", nil, 2, 1, 2)
--local specWarnCorruptorTentacle		= mod:NewSpecialWarningSwitch("ej13191", false, nil, nil, 1)
local specWarnSpewCorruption		= mod:NewSpecialWarningRun(208929, nil, nil, nil, 4, 2)
local yellSpewCorruption			= mod:NewYell(208929)
local specWarnNightmarishFury		= mod:NewSpecialWarningDefensive(215234, "Tank", nil, nil, 3, 2)
local specWarnDominatorTentacle		= mod:NewSpecialWarningSwitch("ej13189", "-Healer", nil, 2, 1)
local specWarnGroundSlam			= mod:NewSpecialWarningYou(208689, nil, nil, nil, 1, 2)
local yellGroundSlam				= mod:NewYell(208689)
local specWarnGroundSlamNear		= mod:NewSpecialWarningClose(208689, nil, nil, nil, 1, 2)
--Stage Two: The Heart of Corruption
local specWarnHeartPhaseBegin		= mod:NewSpecialWarningFades(209915, nil, nil, nil, 1)
local specWarnCursedBlood			= mod:NewSpecialWarningMoveAway(215128, nil, nil, nil, 1, 2)
local yellCursedBlood				= mod:NewFadesYell(215128)

--Stage One: The Ruined Ground
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerDeathGlareCD				= mod:NewCDTimer(220, "ej13190", nil, nil, nil, 1, 208697)
local timerCorruptorTentacleCD		= mod:NewCDTimer(220, "ej13191", nil, nil, nil, 1, 208929)
local timerNightmareHorrorCD		= mod:NewCDTimer(280, "ej13188", nil, nil, nil, 1, 210289, nil, nil, nil, 1, 4)
local timerEyeOfFateCD				= mod:NewCDTimer(10, 210984, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 4)
local timerNightmareishFuryCD		= mod:NewNextTimer(10.9, 215234, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerGroundSlamCD				= mod:NewNextTimer(20.5, 208689, nil, nil, nil, 3)
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerDeathBlossomCD			= mod:NewNextTimer(105, 218415, nil, nil, nil, 2, nil, DBM_COMMON_L.HEROIC_ICON, nil, 3, 4)
local timerDeathBlossom				= mod:NewCastTimer(15, 218415, nil, nil, nil, 5, nil, DBM_COMMON_L.DEADLY_ICON)
--Stage Two: The Heart of Corruption
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerDarkReconstitution		= mod:NewCastTimer(50, 210781, nil, nil, nil, 6, nil, DBM_COMMON_L.DEADLY_ICON, nil, 2, 10)
local timerFinalTorpor				= mod:NewCastTimer(90, 223121, nil, nil, nil, 6, nil, DBM_COMMON_L.DEADLY_ICON)
local timerCursedBloodCD			= mod:NewNextTimer(15, 215128, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnSpew", 208929, false, 6)
mod:AddSetIconOption("SetIconOnOoze", "ej13186", false)
mod:AddBoolOption("SetIconOnlyOnce2", true)
mod:AddRangeFrameOption(8, 215128)
mod:AddInfoFrameOption(210099)
mod:AddDropdownOption("InfoFrameBehavior", {"Fixates", "Adds"}, "Fixates", "misc")

mod.vb.phase = 1
mod.vb.insideActive = false
mod.vb.DominatorCount = 0
mod.vb.CorruptorCount = 0
mod.vb.DeathglareCount = 0
mod.vb.NightmareCount = 0
mod.vb.IchorCount = 0
--Not to be confused with counts above, this is SPANW count not add total count like above
mod.vb.DeathglareSpawn = 0
mod.vb.CorruptorSpawn = 0
local UnitExists, UnitGUID = UnitExists, UnitGUID
local eyeName = DBM:EJ_GetSectionInfo(13185)
local addsTable = {}
local phase1EasyDeathglares = {26, 62, 85, 55}--Normal/LFR OCT 16
local phase1HeroicDeathglares = {21, 51.5, 51}--VERIFIED Nov 18
--This might be same problem as below. Need to review and see if this is another stupid 21/26 variation that makes 2nd one also variable
local phase1MythicDeathglares = {21, 69, 85, 70}--VERIFIED Oct 27
local phase1EasyCorruptors = {86, 95, 35}--Only verifyed 90 on Oct 16 (TODO, verify 95, 35)
local phase1HeroicCorruptors = {71.5, 60}--VERIFIED Nov 18
local phase1MythicCorruptors = {88, 95, 50, 45, 20}--VERIFIED Oct 27
local phase1DeathBlossom = {58.6, 100, 35}--VERIFIED Oct 27

--Based on data, first one is either 21 or 26, if it's 26 then second one changes from 95 to 90
--Might have to switch to scheduling to fix accuracy of timers 2 and 3 because of the 5 second variation on timer 1
local phase2ComboDeathglares = {21.5, 90, 130}--Fuck it. i'm not scheduling to fix a 5 second variation, the two lowest times combined
local phase2MythicDeathglares = {21.5, 90, 115, 20}
--local phase2AllDeathglares = {21.5, 95, 130}--True timers
--local phase2AltDeathglares = {26.5, 90, 130}--Fucked up timers when first one is late
--Old shit, when i thought variations were cause of difficulty. They aren't. These tentacles same in all modes apparently
--local phase2LFRDeathglares = {21.5, 95, 130}--VERIFIED Oct 16 (except for 130)
--local phase2EasyDeathglares = {21.5, 95, 130}--VERIFIED Oct 16 (except for 130)
--local phase2HeroicDeathglares = {26.5, 90, 130}--26, 90 verified Oct 16 (130 not verified)
--These also same in all modes except mythic
local phase2Corruptors = {45, 95, 35, 85, 40}--verified Oct 16 45, 95, 30 on heroic/LFR/Normal
local phase2MythicCorruptors = {45, 75, 115, 65}--VERIFIED Oct 27 (fix missing set needed)
local phase2DeathBlossom = {80, 75}--VERIFIED Oct 16
local autoMarkScannerActive = false
local autoMarkBlocked = false
local autoMarkFilter = {}
local infoFrameSpell = DBM:GetSpellInfo(210099)

local updateInfoFrame
do
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	local DominatorTentacle, CorruptorTentacle, DeathglareTentacle, NightmareHorror, NightmareIchor = DBM:EJ_GetSectionInfo(13189), DBM:EJ_GetSectionInfo(13191), DBM:EJ_GetSectionInfo(13190), DBM:EJ_GetSectionInfo(13188), DBM:EJ_GetSectionInfo(13186)
	updateInfoFrame = function()
		table.wipe(lines)
		table.wipe(sortedLines)
		if mod.vb.NightmareCount > 0 then
			if mod:IsTank() then--Add needs to be tanked
				addLine("|cff00ffff"..NightmareHorror.."|r", mod.vb.NightmareCount)
			else
				addLine(NightmareHorror, mod.vb.NightmareCount)
			end
		end
		if mod.vb.DominatorCount > 0 then
			if mod:IsTank() then--Add needs to be tanked
				addLine("|cff00ffff"..DominatorTentacle.."|r", mod.vb.DominatorCount)
			else
				addLine(DominatorTentacle, mod.vb.DominatorCount)
			end
		end
		if mod.vb.CorruptorCount > 0 then
			addLine(CorruptorTentacle, mod.vb.CorruptorCount)
		end
		if mod.vb.DeathglareCount > 0 then
			addLine(DeathglareTentacle, mod.vb.DeathglareCount)
		end
		if mod.vb.IchorCount > 0 then
			addLine(NightmareIchor, mod.vb.IchorCount)
		end
		return lines, sortedLines
	end
end

local autoMarkOozes
do
	local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
	autoMarkOozes = function(self)
		self:Unschedule(autoMarkOozes)
		if self.vb.IchorCount == 0 then
			autoMarkScannerActive = false
			autoMarkBlocked = false
			return
		end--None left, abort scans
		local lowestUnitID = nil
		local lowestHealth = 100
		local found = false
		for i = 1, 40 do
			local UnitID = "nameplate"..i
			local GUID = UnitGUID(UnitID)
			if GUID and not autoMarkFilter[GUID] then
				local cid = self:GetCIDFromGUID(GUID)
				if cid == 105721 then
					local unitHealth = UnitHealth(UnitID) / UnitHealthMax(UnitID)
					if unitHealth < lowestHealth then
						lowestHealth = unitHealth
						lowestUnitID = UnitID
					end
				end
			end
		end
		if lowestUnitID then
			self:SetIcon(lowestUnitID, 8)
			found = true
		end
		if found and self.Options.SetIconOnlyOnce2 then
			--Abort until invoked again
			autoMarkScannerActive = false
			autoMarkBlocked = true
			return
		end
		self:Schedule(1, autoMarkOozes, self)
	end
end

function mod:SpewCorruptionTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		warnSpewCorruptionSoon:Show()
	end
end

function mod:OnCombatStart(delay)
	table.wipe(addsTable)
	self.vb.phase = 1
	self.vb.insideActive = false
	self.vb.DominatorCount = 0
	self.vb.CorruptorCount = 0
	self.vb.DeathglareCount = 0
	self.vb.NightmareCount = 0
	self.vb.IchorCount = 0
	self.vb.DeathglareSpawn = 0
	self.vb.CorruptorSpawn = 0
	autoMarkScannerActive = false
	autoMarkBlocked = false
	table.wipe(autoMarkFilter)
	timerNightmareishFuryCD:Start(6-delay)
	timerGroundSlamCD:Start(12-delay)
	timerDeathGlareCD:Start(21.5-delay)
	if self:IsMythic() then
		self.vb.deathBlossomCount = 0
		timerDeathBlossomCD:Start(58.6-delay)
		timerNightmareHorrorCD:Start(60-delay)
		timerCorruptorTentacleCD:Start(90-delay)--Verify
	elseif self:IsHeroic() then
		timerNightmareHorrorCD:Start(52.5-delay)
		timerCorruptorTentacleCD:Start(71.5-delay)
	else
		timerNightmareHorrorCD:Start(60-delay)
		timerCorruptorTentacleCD:Start(79-delay)--79-85 but is same in all non mythic modes
	end
	if self.Options.InfoFrame then
		if self.Options.InfoFrameBehavior == "Fixates" then
			DBM.InfoFrame:SetHeader(infoFrameSpell)
			DBM.InfoFrame:Show(10, "playerbaddebuff", infoFrameSpell)
		else
			DBM.InfoFrame:SetHeader(UNIT_NAMEPLATES_SHOW_ENEMY_MINIONS)
			DBM.InfoFrame:Show(5, "function", updateInfoFrame, false, false, true)
		end
	end
	DBM:AddMsg(L.AddSpawnNotice)
	if self:AntiSpam(15, 2) then
		--Do nothing. Just to avoid spam on pull
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 210931 then
		warnNightmareGaze:Show()
	elseif spellId == 209471 then
		if self:AntiSpam(3, 5) then
			warnNightmareExplosion:Show()
		end
		if self.Options.SetIconOnOoze and self:IsMythic() then
			if not autoMarkFilter[args.sourceGUID] then
				 autoMarkFilter[args.sourceGUID] = true
				 autoMarkBlocked = false
			end
			autoMarkOozes(self)
		end
	elseif spellId == 208697 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnMindFlay:Show(args.sourceName)
			specWarnMindFlay:Play("kickcast")
		end
		if not addsTable[args.sourceGUID] and not self.vb.insideActive then
			addsTable[args.sourceGUID] = true
			self.vb.DeathglareCount = self.vb.DeathglareCount + 1
			if self:AntiSpam(10, 16) then
				self.vb.DeathglareSpawn = self.vb.DeathglareSpawn + 1
				warnDeathglareTentacle:Show(self.vb.DeathglareSpawn)
				local nextCount = self.vb.DeathglareSpawn + 1
				local timer
				if self.vb.phase == 2 then
					timer = self:IsMythic() and phase2MythicDeathglares[nextCount] or phase2ComboDeathglares[nextCount]
				else
					timer = self:IsMythic() and phase1MythicDeathglares[nextCount] or self:IsHeroic() and phase1HeroicDeathglares[nextCount] or phase1EasyDeathglares[nextCount]
				end
				if timer then
					timerDeathGlareCD:Start(timer)
				end
			end
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		end
	elseif spellId == 208929 then
		self:BossTargetScanner(args.sourceGUID, "SpewCorruptionTarget", 0.2, 16)
		if not addsTable[args.sourceGUID] then
			addsTable[args.sourceGUID] = true
			self.vb.CorruptorCount = self.vb.CorruptorCount + 1
			if self:AntiSpam(10, 7) then
				self.vb.CorruptorSpawn = self.vb.CorruptorSpawn + 1
				warnCorruptorTentacle:Show(self.vb.CorruptorSpawn)
				local nextCount = self.vb.CorruptorSpawn + 1
				local timer
				if self.vb.phase == 2 then
					timer = self:IsMythic() and phase2MythicCorruptors[nextCount] or phase2Corruptors[nextCount]
				else
					timer = self:IsMythic() and phase1MythicCorruptors[nextCount] or self:IsHeroic() and phase1HeroicCorruptors[nextCount] or phase1EasyCorruptors[nextCount]
				end
				if timer then
					timerCorruptorTentacleCD:Start(timer)
				end
			end
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		end
	elseif spellId == 210781 then--Dark Reconstitution
		if self:IsMythic() then
			timerDarkReconstitution:Start(55)
		else
			timerDarkReconstitution:Start()
		end
	elseif spellId == 208685 and self:AntiSpam(4, 2) then--Rupturing roar (Untanked tentacle)
		specWarnDominatorTentacle:Show()
	elseif spellId == 218415 then
		self.vb.deathBlossomCount = self.vb.deathBlossomCount + 1
		warnDeathBlossom:Show()
		timerDeathBlossom:Start()
		local nextCount = self.vb.deathBlossomCount + 1
		local timer = self.vb.phase == 2 and phase2DeathBlossom[nextCount] or phase1DeathBlossom[nextCount]
		if timer then
			timerDeathBlossomCD:Start(timer, self.vb.deathBlossomCount+1)
		end
		local elapsed, total = timerNightmareHorrorCD:GetTime()
		local remaining = total - elapsed
		if remaining < 15 then--delayed
			local extend = 15-remaining
			DBM:Debug("Delay detected, updating horror timer now. Extend: "..extend)
			timerNightmareHorrorCD:Update(elapsed, total+extend)
		end
	elseif spellId == 223121 then
		if self:IsMythic() then
			timerFinalTorpor:Start(55)
		else
			timerFinalTorpor:Start()
		end
	elseif spellId == 208689 and self:AntiSpam(2, 6) then
		timerGroundSlamCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 210984 then
		timerEyeOfFateCD:Start(nil, args.sourceGUID)
	elseif spellId == 209387 then--First thing Nightmare Horror casts that can give us GUID
		timerEyeOfFateCD:Start(14, args.sourceGUID)
	elseif spellId == 208929 then
		warnSpewCorruption:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnSpewCorruption:Show()
			specWarnSpewCorruption:Play("runout")
			yellSpewCorruption:Yell()
		end
		if self.Options.SetIconOnSpew then
			self:SetAlphaIcon(0.5, args.destName)--Number of icons is 2 3 or 4. 4 only if fight is too long really.
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 209915 then--Stuff of Nightmares
		self.vb.insideActive = false
		timerCursedBloodCD:Stop()
		timerNightmareishFuryCD:Start(6.1)
		timerGroundSlamCD:Start(12.1)
		if self:IsMythic() then
			self.vb.deathBlossomCount = 0
			timerDeathBlossomCD:Start(80)
		end
		timerDeathGlareCD:Start(21.5)
		timerCorruptorTentacleCD:Start(45)
		timerNightmareHorrorCD:Start(95)
		self.vb.phase = self.vb.phase + 1
		self.vb.DeathglareSpawn = 0
		self.vb.CorruptorSpawn = 0
	elseif spellId == 210099 then--Ooze Fixate
		warnFixate:CombinedShow(1, args.destName)
		if args:IsPlayer() then
			specWarnFixate:Show(eyeName)
			specWarnFixate:Play("targetyou")
		end
		if not addsTable[args.sourceGUID] then
			addsTable[args.sourceGUID] = true
			self.vb.IchorCount = self.vb.IchorCount + 1
			if self.Options.SetIconOnOoze and self:IsMythic() and not autoMarkScannerActive and not autoMarkBlocked then
				autoMarkScannerActive = true
				self:Schedule(2.5, autoMarkOozes, self)
			end
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		end
	elseif spellId == 210984 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			if amount >= 2 then
				if args:IsPlayer() then--At this point the other tank SHOULD be clear.
					specWarnEyeOfFate:Show(amount)
					specWarnEyeOfFate:Play("stackhigh")
				else--Taunt as soon as stacks are clear, regardless of stack count.
					local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", args.spellName)
					if not UnitIsDeadOrGhost("player") and (not expireTime or expireTime and expireTime-GetTime() < 10) then
						specWarnEyeOfFateOther:Show(args.destName)
						specWarnEyeOfFateOther:Play("changemt")
					else
						warnEyeOfFate:Show(args.destName, amount)
					end
				end
			else
				warnEyeOfFate:Show(args.destName, amount)
			end
		end
	elseif spellId == 215234 then
		if self:AntiSpam(3, 4) then
			timerNightmareishFuryCD:Start()
		end
		--Hopefully this has a boss unitID
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and self:IsTanking("player", bossUnitID, nil, true) then--We are highest threat target
				specWarnNightmarishFury:Show()
				specWarnNightmarishFury:Play("defensive")
				break
			end
		end
	elseif spellId == 215128 then
		warnCursedBlood:CombinedShow(0.5, args.destName)--Multi target assumed
		if self:AntiSpam(2, 3) then
			timerCursedBloodCD:Start()
		end
		if args:IsPlayer() then
			specWarnCursedBlood:Show()
			yellCursedBlood:Schedule(7, 1)
			yellCursedBlood:Schedule(6, 2)
			yellCursedBlood:Schedule(5, 3)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
	elseif spellId == 212886 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnNightmareCorruption:Show()
		specWarnNightmareCorruption:Play("runaway")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 209915 then--Stuff of Nightmares
		self.vb.insideActive = true
		specWarnHeartPhaseBegin:Show()
		timerDeathGlareCD:Stop()
		timerCorruptorTentacleCD:Stop()
		timerNightmareHorrorCD:Stop()
		timerDeathBlossomCD:Stop()
		timerCursedBloodCD:Start()
	elseif spellId == 215128 and args:IsPlayer() then
		yellCursedBlood:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 208929 and self.Options.SetIconOnSpew then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 212886 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnNightmareCorruption:Show()
		specWarnNightmareCorruption:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local bossUnitID = "boss"..i
		if UnitExists(bossUnitID) then--Check if new units exist we haven't detected and added yet.
			local cid = self:GetCIDFromGUID(UnitGUID(bossUnitID))
			if not addsTable[UnitGUID(bossUnitID)] and cid == 105304 then--Dominator Tentacle
				if self:AntiSpam(4, 2) then
					specWarnDominatorTentacle:Show()
				end
				addsTable[UnitGUID(bossUnitID)] = true
				self.vb.DominatorCount = self.vb.DominatorCount + 1
				if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
					DBM.InfoFrame:Update()
				end
			end
		end
	end
end

function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:208689") then
		specWarnGroundSlam:Show()
		yellGroundSlam:Yell()
		specWarnGroundSlam:Play("targetyou")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 105591 or cid == 105304 or cid == 105383 or cid == 105322 or cid == 105721 then
		self:SendSync("EnemyDied", args.destGUID)
	end
end

function mod:OnSync(msg, guid)
	--Syncing used do to combat log range issues if raid is too spread out
	--It's easy to be out of range of combat log event
	if not self:IsInCombat() then return end
	if msg == "EnemyDied" and guid then
		local cid = self:GetCIDFromGUID(guid)
		if cid == 105591 then--Nightmare Horror
			self.vb.NightmareCount = self.vb.NightmareCount - 1
			timerEyeOfFateCD:Stop(guid)
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		elseif cid == 105304 then--Dominator Tentacle
			self.vb.DominatorCount = self.vb.DominatorCount - 1
			if self.vb.DominatorCount == 0 then
				timerNightmareishFuryCD:Stop()
				timerGroundSlamCD:Stop()
			end
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		elseif cid == 105383 then--Corruptor tentacle
			self.vb.CorruptorCount = self.vb.CorruptorCount - 1
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		elseif cid == 105322 then--Deathglare Tentacle
			self.vb.DeathglareCount = self.vb.DeathglareCount - 1
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		elseif cid == 105721 then--Nightmare Ichor
			self.vb.IchorCount = self.vb.IchorCount - 1
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		end
	end
end

do
	--This method is still 4 seconds faster than using Seeping Corruption
	local NightmareHorror = DBM:EJ_GetSectionInfo(13188)
	function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, targetname)
		if targetname == NightmareHorror then
			specWarnNightmareHorror:Show()
			specWarnNightmareHorror:Play("bigmob")
			if self:IsMythic() then
				timerNightmareHorrorCD:Start(250)
			else
				timerNightmareHorrorCD:Start()--280
			end
			self.vb.NightmareCount = self.vb.NightmareCount + 1
			--timerEyeOfFateCD:Start(18)--Started at seeping corruption for mob GUID
			if self.Options.InfoFrame and self.Options.InfoFrameBehavior == "Adds" then
				DBM.InfoFrame:Update()
			end
		end
	end
end

function mod:OnTranscriptorSync(msg, targetName)
	if msg:find("spell:208689") and self:AntiSpam(2, targetName) then--Ground Slam
		targetName = Ambiguate(targetName, "none")
		if self:CheckNearby(5, targetName) then
			specWarnGroundSlamNear:Show(targetName)
			specWarnGroundSlamNear:Play("watchwave")
		else
			warnGroundSlam:CombinedShow(1, targetName)
		end
	end
end

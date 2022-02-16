local mod	= DBM:NewMod(1704, "DBM-EmeraldNightmare", nil, 768)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(102679)--Ysondre, 102683 (Emeriss), 102682 (Lethon), 102681 (Taerar)
mod:SetEncounterID(1854)
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetHotfixNoticeRev(15407)
mod.respawnTime = 39

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 203028 204767 205300 203817 203888 204100 204078 214540 207573",
	"SPELL_CAST_SUCCESS 203787 205298 205329",
	"SPELL_AURA_APPLIED 203102 203125 203124 203121 203110 203770 203787 204040",
	"SPELL_AURA_APPLIED_DOSE 203102 203125 203124 203121",
	"SPELL_AURA_REMOVED 203787 204040 203787",
--	"SPELL_DAMAGE",
--	"SPELL_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5"
)

local Ysondre = DBM:EJ_GetSectionInfo(12768)
local Emeriss = DBM:EJ_GetSectionInfo(12770)
local Lethon = DBM:EJ_GetSectionInfo(12772)
local Taerar = DBM:EJ_GetSectionInfo(12774)

--(type = "begincast" or type = "cast" or type = "applybuff") and (source.name = "Taerar" or source.name = "Ysondre" or source.name = "Emeriss" or source.name = "Lethon")
--TODO, if only one volatile infection goes out at a time, hide general alert if player affected
--TODO, remove combined show from any warnings that are only one target
--TODO, when timers are more finalized add countdowns to more things.
--All
local warnSlumberingNightmare		= mod:NewTargetAnnounce(203110, 4, nil, false)--An option to announce fuckups
local warnBreath					= mod:NewSpellAnnounce(203028, 2)
--Ysondre
local warnCallDefiledSpirit			= mod:NewSpellAnnounce(207573, 4)
local warnNightmareBlast			= mod:NewSpellAnnounce(203153, 2)
--Emeriss
local warnVolatileInfection			= mod:NewTargetAnnounce(203787, 3)
local warnEssenceOfCorruption		= mod:NewSpellAnnounce(205298, 2)
--Lethon
local warnGloom						= mod:NewSpellAnnounce(205329, 2)
local warnShadowBurst				= mod:NewTargetAnnounce(204040, 3)

--All
local specWarnMark					= mod:NewSpecialWarningStack("ej12809", nil, 7, nil, 2, 1, 6)
local specWarnDragon				= mod:NewSpecialWarningTarget(204720, "Tank", nil, nil, 1, 2)
--Ysondre
--local specWarnNightmareBlast		= mod:NewSpecialWarningSpell(203153, nil, nil, nil, 2)
local specWarnDefiledSpirit			= mod:NewSpecialWarningYou(207573)
local yellSpirit					= mod:NewYell(207573)
local specWarnDefiledVines			= mod:NewSpecialWarningDispel(207573, "Healer", nil, nil, 1, 2)
local specWarnLumberingMindgorger	= mod:NewSpecialWarningSwitch("ej13460", "-Dps", nil, nil, 1, 2)
local specWarnCollapsingNightmare	= mod:NewSpecialWarningInterrupt(214540, "HasInterrupt", nil, nil, 1, 2)
--Emeriss
local specWarnVolatileInfection		= mod:NewSpecialWarningMoveAway(203787, nil, nil, nil, 1, 2)
local yellVolatileInfection			= mod:NewYell(203787)
local specWarnCorruptedBurst		= mod:NewSpecialWarningDodge(203817, "Melee", nil, nil, 1, 2)
local specWarnCorruption			= mod:NewSpecialWarningInterrupt(205300, "HasInterrupt", nil, nil, 1, 2)
--Lethon
local specWarnSiphonSpirit			= mod:NewSpecialWarningSwitch(203888, "Dps", nil, nil, 3, 2)
local specWarnShadowBurst			= mod:NewSpecialWarningYou(204040, nil, nil, nil, 1, 2)
local yellShadowBurst				= mod:NewFadesYell(204040, nil, false, 2)
--Taerar
local specWarnShadesOfTaerar		= mod:NewSpecialWarningSwitch(204100, "Tank", nil, nil, 1, 2)
local specWarnBellowingRoar			= mod:NewSpecialWarningSpell(204078, nil, nil, nil, 2, 6)

--All
local timerMarkCD					= mod:NewNextTimer(7, "ej12809", 28836, false, 2, 3, 203102)--Now off by default, to further reduce timer clutter, plus sometimes it's wrong because in rare cases the dragons desync for some reason
local timerBreathCD					= mod:NewCDSourceTimer(27, 203028, 21131, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--27-34 for Ysondre, Cohorts 27-29.
--Ysondre
mod:AddTimerLine(Ysondre)
local timerNightmareBlastCD			= mod:NewCDTimer(15, 203153, nil, "-Tank", nil, 3)--15-20
local timerDefiledSpiritCD			= mod:NewCDTimer(33.2, 207573, nil, nil, nil, 3)
--Emeriss
mod:AddTimerLine(Emeriss)
local timerVolatileInfectionCD		= mod:NewCDTimer(45.4, 203787, nil, "-Tank", 2, 3)
local timerEssenceOfCorruptionCD	= mod:NewNextTimer(30, 205298, nil, nil, nil, 1)
--Lethon
mod:AddTimerLine(Lethon)
local timerSiphonSpiritCD			= mod:NewNextTimer(49.9, 203888, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerShadowBurstCD			= mod:NewNextTimer(14.5, 204040, nil, nil, nil, 3)--Air
--Taerar
mod:AddTimerLine(Taerar)
local timerShadesOfTaerarCD			= mod:NewNextTimer(48.5, 204100, nil, "-Healer", nil, 1, nil, nil, nil, 1, 4)
local timerSeepingFogCD				= mod:NewCDTimer(15.5, 205341, nil, false, 2, 3, 24814)--Spawn pretty often, and timers don't help dodge, so now off by default
local timerBellowingRoarCD			= mod:NewCDTimer(44.5, 204078, 118699, nil, nil, 2)--Air

mod:AddRangeFrameOption(10, 203787)
mod:AddSetIconOption("SetIconOnInfection", 203787, false)
mod:AddSetIconOption("SetIconOnOozes", 205298, false, true)
mod:AddInfoFrameOption("ej12809")

mod.vb.volatileInfectionIcon = 1
mod.vb.alternateOozes = false
local activeBossGUIDS = {}
local spellName1, spellName2, spellName3, spellName4 = DBM:GetSpellInfo(203102), DBM:GetSpellInfo(203125), DBM:GetSpellInfo(203124), DBM:GetSpellInfo(203121)

local function whoDatUpThere(self)
	local emerissFound = false
	local lethonFound = false
	local taerarFound = false
	for i = 1, 5 do
		local bossUID = "boss"..i
		if UnitExists(bossUID) then--if they are in air they won't exist.
			local cid = self:GetUnitCreatureId(bossUID)
			if cid == 102683 then -- Emeriss
				emerissFound = true
			elseif cid == 102682 then -- Lethon
				lethonFound = true
			elseif cid == 102681 then -- Taerar
				taerarFound = true
			end
		end
	end
	--Subtracking 2 from all timers do to delay
	if not emerissFound then -- Emeriss

	end
	if not lethonFound then -- Lethon
		timerShadowBurstCD:Start(12.6)
	end
	if not taerarFound then -- Taerar
		timerBellowingRoarCD:Start(43)
	end
end

--Probably broken with recent infoframe changes, needs code review
local updateInfoFrame
do
--	local playerName = UnitName("player")
	local lines = {}
	local floor = math.floor
	updateInfoFrame = function()
		table.wipe(lines)
		local playersWithTwo = false
		for uId in DBM:GetGroupMembers() do
			local debuffCount = 0
			local text = ""
			if DBM:UnitDebuff(uId, spellName1) then
				debuffCount = debuffCount + 1
				local _, _, stackCount, _, _, expires = DBM:UnitDebuff(uId, spellName1)
				if expires == 0 then
					text = SPELL_FAILED_OUT_OF_RANGE
				else
					local debuffTime = expires - GetTime()
					text = floor(debuffTime)
				end
			end
			if DBM:UnitDebuff(uId, spellName2) then
				debuffCount = debuffCount + 1
				local _, _, stackCount, _, _, expires = DBM:UnitDebuff(uId, spellName2)
				if expires == 0 then
					text = SPELL_FAILED_OUT_OF_RANGE
				else
					local debuffTime = expires - GetTime()
					text = text..", "..floor(debuffTime)
				end
			end
			if DBM:UnitDebuff(uId, spellName3) then
				debuffCount = debuffCount + 1
				local _, _, stackCount, _, _, expires = DBM:UnitDebuff(uId, spellName3)
				if expires == 0 then
					text = SPELL_FAILED_OUT_OF_RANGE
				else
					local debuffTime = expires - GetTime()
					text = text..", "..floor(debuffTime)
				end
			end
			if DBM:UnitDebuff(uId, spellName4) then
				debuffCount = debuffCount + 1
				local _, _, stackCount, _, _, expires = DBM:UnitDebuff(uId, spellName4)
				if expires == 0 then
					text = SPELL_FAILED_OUT_OF_RANGE
				else
					local debuffTime = expires - GetTime()
					text = text..", "..floor(debuffTime)
				end
			end
			if debuffCount > 1 then
				playersWithTwo = true
				lines[UnitName(uId)] = text
			end
		end
		if not playersWithTwo then
			--No players with two, show generic stats
			--Do stuff
			lines[ALL] = OKAY
		end
		return lines
	end
end

function mod:OnCombatStart(delay)
	self.vb.volatileInfectionIcon = 1
	self.vb.alternateOozes = false
	table.wipe(activeBossGUIDS)
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"--We register here to make sure we wipe vb.on pull
	)
	timerBreathCD:Start(15.5, Ysondre)
	timerDefiledSpiritCD:Start(30-delay)
	timerNightmareBlastCD:Start(40-delay)--40 on mythic, it changing on heroic too is assumed. Was 22.5 before
	if self:IsMythic() then
		--Only done on mythic for now since we know for sure what dragons are up once we know what dragons are down.
		--On non mythic one dragon is missing from encounter and we have no way of knowing what one currently :\
		self:Schedule(2, whoDatUpThere, self)
	end
	if self.Options.InfoFrame and not self:IsLFR() then
		DBM.InfoFrame:SetHeader(DBM:EJ_GetSectionInfo(12809))
		DBM.InfoFrame:Show(5, "function", updateInfoFrame)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 203028 or spellId == 204767 then--204767 is weaker version used by Shade of Taerar
		local targetName, uId, bossuid = self:GetBossTarget(args.sourceGUID)
		if not bossuid then
			DBM:Debug("GetBossTarget failed, no bossuid")
			return
		end
		if self:IsTanking("player", bossuid, nil, true) then
			warnBreath:Show()
		end
		if args:GetSrcCreatureID() ~= 103145 then--Filter shades
			timerBreathCD:Start(27, args.sourceName)
		end
	elseif spellId == 207573 then
		warnCallDefiledSpirit:Show()
		self:SendSync("DefiledSpirit")
	elseif spellId == 205300 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnCorruption:Show(args.sourceName)
		specWarnCorruption:Play("kickcast")
	elseif spellId == 214540 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnCollapsingNightmare:Show(args.sourceName)
		specWarnCollapsingNightmare:Play("kickcast")
	elseif spellId == 203817 and self:AntiSpam(5, 6) then
		specWarnCorruptedBurst:Show()
		specWarnCorruptedBurst:Play("watchstep")
	elseif spellId == 203888 then
		specWarnSiphonSpirit:Show()
		specWarnSiphonSpirit:Play("killspirit")
		self:SendSync("SiphonSpirit")
	elseif spellId == 204100 then
		specWarnShadesOfTaerar:Show()
		specWarnShadesOfTaerar:Play("mobsoon")
		self:SendSync("Shades")
	elseif spellId == 204078 then
		specWarnBellowingRoar:Show()
		specWarnBellowingRoar:Play("fearsoon")
		self:SendSync("Fear")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 203787 then
		self:SendSync("Infection")
	elseif spellId == 205298 then
		warnEssenceOfCorruption:Show()
		timerEssenceOfCorruptionCD:Start()
		if self.Options.SetIconOnOozes then
			if self.vb.alternateOozes then
				--6 and 5 used
				self:ScanForMobs(103691, 0, 6, 2, nil, 10, "SetIconOnOozes")
			else
				--8 and 7 used
				self:ScanForMobs(103691, 0, 8, 2, nil, 10, "SetIconOnOozes")
			end
		end
		self.vb.alternateOozes = not self.vb.alternateOozes
	elseif spellId == 205329 then
		warnGloom:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if (spellId == 203102 or spellId == 203125 or spellId == 203124 or spellId == 203121) and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 7 then
			specWarnMark:Show(amount)
			specWarnMark:Play("stackhigh")
		end
		if self:AntiSpam(5, 2) then
			if self:IsMythic() then
				timerMarkCD:Start()
			elseif self:IsHeroic() then
				timerMarkCD:Start(8)
			elseif self:IsNormal() then
				timerMarkCD:Start(10)
			else
				timerMarkCD:Start(12)
			end
		end
	elseif spellId == 203110 then
		warnSlumberingNightmare:CombinedShow(0.5, args.destName)
	elseif spellId == 203770 then
		specWarnDefiledVines:CombinedShow(0.5, args.destName)
		if self:AntiSpam(2, 1) then
			specWarnDefiledVines:Play("helpdispel")
		end
	elseif spellId == 203787 then
		warnVolatileInfection:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnVolatileInfection:Show()
			yellVolatileInfection:Yell()
			specWarnVolatileInfection:Play("scatter")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if self.Options.SetIconOnInfection then
			self:SetIcon(args.destName, self.vb.volatileInfectionIcon)
		end
		self.vb.volatileInfectionIcon = self.vb.volatileInfectionIcon + 1
		if self.vb.volatileInfectionIcon > 4 then
			self.vb.volatileInfectionIcon = 1
		end
	elseif spellId == 204040 then
		warnShadowBurst:CombinedShow(1, args.destName)
		if self:AntiSpam(5, 5) then
			timerShadowBurstCD:Start()
		end
		if args:IsPlayer() then
			specWarnShadowBurst:Show()
			yellShadowBurst:Schedule(5, 1)
			yellShadowBurst:Schedule(4, 2)
			yellShadowBurst:Schedule(3, 3)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 203787 and args:IsPlayer() and self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	elseif spellId == 204040 and args:IsPlayer() then
		yellShadowBurst:Cancel()
	elseif spellId == 203787 and self.Options.SetIconOnInfection then
		self:SetIcon(args.destName, 0)
	end
end

--this should work for both pull and any of them landing from air, well assuming the timers in both situations are same
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unitID = "boss"..i
		local unitGUID = UnitGUID(unitID)
		if UnitExists(unitID) and not activeBossGUIDS[unitGUID] then
			activeBossGUIDS[unitGUID] = true
			local bossName = UnitName(unitID)
			local cid = self:GetUnitCreatureId(unitID)
			--Subtracking .5 from all timers do to slight delay in IEEU vs ENCOUNTER_START
			if cid == 102683 then -- Emeriss
				timerBreathCD:Start(15.5, bossName)
				timerVolatileInfectionCD:Start(19.5)
				timerEssenceOfCorruptionCD:Start(29.5)
			elseif cid == 102682 then -- Lethon
				timerShadowBurstCD:Stop()
				timerBreathCD:Start(13, bossName)
				timerSiphonSpiritCD:Start(20.5)
			elseif cid == 102681 then -- Taerar
				timerBellowingRoarCD:Stop()
				timerBreathCD:Start(17, bossName)
				timerShadesOfTaerarCD:Start(19.5)--19.5-21
				timerSeepingFogCD:Start(25)
			end
			self:SendSync("IEEU", bossName, unitGUID)
		end
	end
end

--"<38.03 01:01:06> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\sha_ability_rogue_envelopingshadows_nightmare:20|tA Lumbering Mindgorger forms in the mists of The Hinterlands!#Ysondre#####0#0##0#1
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, targetname)
	if msg:find("sha_ability_rogue_envelopingshadows_nightmare") then
		specWarnLumberingMindgorger:Show()
		specWarnLumberingMindgorger:Play("bigmob")
	end
end

local function delayedClear(self, GUID)
	activeBossGUIDS[GUID] = nil
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 203147 then--Nightmare Blast
		warnNightmareBlast:Show()
		timerNightmareBlastCD:Start()
	elseif spellId == 205331 then--Seeping Fog
		timerSeepingFogCD:Start()
	elseif spellId == 204720 then--Aeriel
		local unitGUID = UnitGUID(uId)
		local bossName = UnitName(uId)
		self:SendSync("Aeriel", bossName, unitGUID)
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 205611 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
--		specWarnMiasma:Show()
--		specWarnMiasma:Play("runaway")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE
--]]

function mod:OnSync(msg, targetName, guid)
	if not self:IsInCombat() then return end
	if guid and msg == "Aeriel" then
		local cid = self:GetCIDFromGUID(guid)
		specWarnDragon:Show(targetName)
		self:Schedule(10, delayedClear, self, guid)
		timerBreathCD:Stop(targetName)
		if cid == 102683 then--Emeriss
			timerVolatileInfectionCD:Stop()
			timerEssenceOfCorruptionCD:Stop()
		elseif cid == 102682 then--Lethon
			timerSiphonSpiritCD:Stop()
			if not self:IsEasy() then
				timerShadowBurstCD:Start(19.5)
			end
		elseif cid == 102681 then--Taerar
			timerShadesOfTaerarCD:Stop()
			timerSeepingFogCD:Stop()
			if not self:IsEasy() then
				timerBellowingRoarCD:Start(44.5)
			end
		end
	elseif guid and msg == "IEEU" and not activeBossGUIDS[guid] then
		activeBossGUIDS[guid] = true
		local cid = self:GetCIDFromGUID(guid)
		--Subtracking .5 from all timers do to slight delay in IEEU vs ENCOUNTER_START
		if cid == 102683 then -- Emeriss
			timerBreathCD:Start(17, targetName)
			timerVolatileInfectionCD:Start(19.5)
			timerEssenceOfCorruptionCD:Start(29.5)
		elseif cid == 102682 then -- Lethon
			timerShadowBurstCD:Stop()
			timerBreathCD:Start(13, targetName)
			timerSiphonSpiritCD:Start(20.5)
		elseif cid == 102681 then -- Taerar
			timerBellowingRoarCD:Stop()
			timerBreathCD:Start(17, targetName)
			timerShadesOfTaerarCD:Start(19.5)--19.5-21
			timerSeepingFogCD:Start(25)
		end
	elseif msg == "Shades" then
		timerShadesOfTaerarCD:Start()
	elseif msg == "Fear" then
		timerBellowingRoarCD:Start()
	elseif msg == "SiphonSpirit" then
		timerSiphonSpiritCD:Start()
	elseif msg == "DefiledSpirit" then
		timerDefiledSpiritCD:Start()
	elseif msg == "Infection" then
		timerVolatileInfectionCD:Start()
	end
end

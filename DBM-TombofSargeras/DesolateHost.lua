local mod	= DBM:NewMod(1896, "DBM-TombofSargeras", nil, 875)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210905144823")
mod:SetCreatureID(118460, 118462, 119072)--118460 Engine of Souls, 118462 Soul Queen Dajahna, 119072 The Desolate Host
mod:SetEncounterID(2054)
mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(3, 4)
mod.respawnTime = 40

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 238570 235927 236542 236544 236072",
	"SPELL_CAST_SUCCESS 236449 236131 235969 236542 236544",
	"SPELL_AURA_APPLIED 236459 235924 238018 236513 236138 236131 235969 236515 236361 239923 236548 235732",
	"SPELL_AURA_APPLIED_DOSE 236548 236515",
	"SPELL_AURA_REMOVED 236459 235924 236513 235969 235732 236072 238570",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED",
--	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

--[[
(ability.id = 238570 or ability.id = 235927 or ability.id = 236542 or ability.id = 236544) and type = "begincast" or
(ability.id = 235907 or ability.id = 236072 or ability.id = 236507 or ability.id = 235969 or ability.id = 236449 or ability.id =  236138 or ability.id = 236131) and type = "cast" or
(ability.id = 235924) and type = "applydebuff" or
ability.id = 236072 and (type = "applybuff" or type = "removebuff") or
(ability.id = 236459 or ability.id = 235969 or ability.id = 236513) and (type = "applydebuff" or type = "removedebuff" or type = "applybuff" or type = "removebuff")
--]]
--Corporeal Realm
local warnSpearofAnguish			= mod:NewTargetCountAnnounce(235924, 3)
local warnCollapsingFissure			= mod:NewSpellAnnounce(235907, 3)--Upgrade to special, if needed
local warnTormentingCries			= mod:NewTargetAnnounce(238018, 3)--Spammy? off by default?
----Adds
local warnRupturingSlam				= mod:NewSpellAnnounce(235927, 3)
local warnBonecageArmor				= mod:NewTargetAnnounce(236513, 3)
--Spirit Realm
local warnSoulbind					= mod:NewTargetAnnounce(236459, 4)
local warnWither					= mod:NewTargetAnnounce(236138, 3, nil, "Healer", 2)
local warnShatteringScream			= mod:NewTargetAnnounce(235969, 4, nil, false, 2)--This warning DOES need to be cross phase
local warnSpiritChains				= mod:NewTargetAnnounce(236361, 3, nil, false, 2)
--Desolate Host
local warnTorment					= mod:NewStackAnnounce(236548, 3)

--Corporeal Realm
local specWarnSpearofAnguish		= mod:NewSpecialWarningYou(235924, nil, nil, nil, 1, 2)
local yellSpearofAnguish			= mod:NewFadesYell(235924)
local specWarnTormentingCries		= mod:NewSpecialWarningYou(238018, nil, nil, nil, 1, 2)
local yellTormentingCries			= mod:NewShortYell(238018)
--Spirit Realm
local specWarnSoulbind				= mod:NewSpecialWarningYou(236459, nil, nil, nil, 3, 2)
local yellSoulbind					= mod:NewYell(236459)
local specWarnWither				= mod:NewSpecialWarningYou(236138, nil, nil, nil, 1, 7)
local specWarnShatteringScream		= mod:NewSpecialWarningMoveAway(235969, nil, nil, nil, 1, 2)
local specWarnShatteringScreamAdd	= mod:NewSpecialWarningMoveTo(235969, nil, nil, nil, 3, 2)
local yellShatteringScream			= mod:NewShortFadesYell(235969, nil, false)
local specWarnWailingSouls			= mod:NewSpecialWarningCount(236072, nil, nil, nil, 2, 2)
--The Desolate Host
local specWarnSunderingDoomTaunt	= mod:NewSpecialWarningTaunt(236542, nil, nil, nil, 1, 2)
local specWarnSunderingDoomGather	= mod:NewSpecialWarningMoveTo(236542, nil, nil, nil, 1, 2)
local specWarnSunderingDoomRun		= mod:NewSpecialWarningRun(236542, nil, nil, nil, 4, 2)
local specWarnDoomedSunderingTaunt	= mod:NewSpecialWarningTaunt(236544, nil, nil, nil, 1, 2)
local specWarnDoomedSunderingGather	= mod:NewSpecialWarningMoveTo(236544, nil, nil, nil, 1, 2)
local specWarnDoomedSunderingRun	= mod:NewSpecialWarningRun(236544, nil, nil, nil, 4, 2)

mod:AddTimerLine(SCENARIO_STAGE:format(1))
--Corporeal Realm
local timerSpearofAnquishCD			= mod:NewCDCountTimer(20, 235924, nil, nil, nil, 3)
--local timerCollapsingFissureCD		= mod:NewAITimer(31, 235907, nil, nil, nil, 3)
local timerTormentedCriesCD			= mod:NewNextCountTimer(58, 238570, nil, nil, nil, 6)
--Spirit Realm
local timerSoulbindCD				= mod:NewCDCountTimer(24, 236459, nil, nil, nil, 3)
--local timerWitherCD					= mod:NewCDTimer(9.4, 236138, nil, nil, nil, 3)
--local timerShatteringScreamCD		= mod:NewCDTimer(12, 235969, nil, nil, nil, 3)--12 seconds, per add
local timerWailingSoulsCD			= mod:NewNextCountTimer(58, 236072, nil, nil, nil, 2)
--The Desolate Host
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerSunderingDoomCD			= mod:NewCDTimer(24.4, 236542, nil, nil, nil, 5, nil, nil, nil, 1, 4)
local timerDoomedSunderingCD		= mod:NewCDTimer(24.4, 236544, nil, nil, nil, 5, nil, nil, nil, 1, 4)

local berserkTimer					= mod:NewBerserkTimer(480)

mod:AddSetIconOption("SoulIcon", 236459, true)
mod:AddInfoFrameOption(235621, true)
mod:AddRangeFrameOption(10, 236459)
mod:AddNamePlateOption("NPAuraOnBonecageArmor", 236513)
mod:AddBoolOption("IgnoreTemplarOn3Tank", true)

mod.vb.soulboundCast = 0
mod.vb.spearCast = 0
mod.vb.wailingSoulsCast = 0
mod.vb.tormentedCriesCast = 0
mod.vb.boneArmorCount = 0
mod.vb.phase = 1
mod.vb.soulIcon = 3
mod.vb.tankCount = 2
local spiritRealm, boneArmor = DBM:GetSpellInfo(235621), DBM:GetSpellInfo(236513)
local doBones = true
local playersInSpirit = {}
local playersNotInSpirit = {}

local spiritFilter, regularFilter
do
	spiritFilter = function(uId)
		if DBM:UnitDebuff(uId, spiritRealm) then
			return true
		end
	end
	regularFilter = function(uId)
		if not DBM:UnitDebuff(uId, spiritRealm) then
			return true
		end
	end
end

local updateInfoFrame
do
	local corpRealm = DBM:EJ_GetSectionInfo(14856)
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		table.wipe(lines)
		table.wipe(sortedLines)
		addLine(spiritRealm, #playersInSpirit)
		addLine(corpRealm, #playersNotInSpirit)
		if doBones then
			addLine(boneArmor, mod.vb.boneArmorCount)
		end
		return lines, sortedLines
	end
end

function mod:OnCombatStart(delay)
	table.wipe(playersInSpirit)
	table.wipe(playersNotInSpirit)
	self.vb.soulboundCast = 0
	self.vb.spearCast = 0
	self.vb.wailingSoulsCast = 0
	self.vb.tormentedCriesCast = 0
	self.vb.boneArmorCount = 0
	self.vb.phase = 1
	self.vb.soulIcon = 3
	self.vb.tankCount = self:GetNumAliveTanks() or 2
	--timerCollapsingFissureCD:Start(9.7-delay)
	timerSoulbindCD:Start(14.2-delay, 1)
	if not self:IsEasy() then
		doBones = true
		timerSpearofAnquishCD:Start(20.7-delay, 1)
		if self:IsMythic() then
			berserkTimer:Start(480-delay)
		end
	else
		doBones = false
	end
	--timerWitherCD:Start(32-delay)
	timerWailingSoulsCD:Start(59.4-delay, 1)
	timerTormentedCriesCD:Start(119-delay, 1)
	if self.Options.NPAuraOnBonecageArmor then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
	for uId in DBM:GetGroupMembers() do
		local name = DBM:GetUnitFullName(uId)
		if DBM:UnitDebuff(uId, spiritRealm) then
			playersInSpirit[#playersInSpirit+1] = name
		else
			playersNotInSpirit[#playersNotInSpirit+1] = name
		end
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(OVERVIEW)
		DBM.InfoFrame:Show(5, "function", updateInfoFrame, false, true)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.NPAuraOnBonecageArmor then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 238570 then--Tormented Cries
		self.vb.tormentedCriesCast = self.vb.tormentedCriesCast + 1
		timerSpearofAnquishCD:Stop()
	elseif spellId == 235927 and self.vb.tankCount < 3 then
		warnRupturingSlam:Show()
	elseif spellId == 236542 then--Sundering Doom (regular realm soaks)
		if DBM:UnitBuff("player", spiritRealm) or DBM:UnitDebuff("player", spiritRealm) then--Figure out which it is
			specWarnSunderingDoomRun:Show()
			specWarnSunderingDoomRun:Play("justrun")
		else
			specWarnSunderingDoomGather:Show(BOSS)
			specWarnSunderingDoomGather:Play("gathershare")
		end
		timerSunderingDoomCD:Start()
	elseif spellId == 236544 then--Doomed Sunering (spirit realm soaks)
		if DBM:UnitBuff("player", spiritRealm) or DBM:UnitDebuff("player", spiritRealm) then--Figure out which it is
			specWarnDoomedSunderingGather:Show(BOSS)
			specWarnDoomedSunderingGather:Play("gathershare")
		else
			specWarnDoomedSunderingRun:Show()
			specWarnDoomedSunderingRun:Play("justrun")
		end
		timerDoomedSunderingCD:Start()
	elseif spellId == 236072 then
		self.vb.wailingSoulsCast = self.vb.wailingSoulsCast + 1
		timerSoulbindCD:Stop()
		--timerWitherCD:Stop()
		specWarnWailingSouls:Show(self.vb.wailingSoulsCast)
		--In normal realm, and boss is above 35%, getting adds
		if not (DBM:UnitBuff("player", spiritRealm) or DBM:UnitDebuff("player", spiritRealm)) and UnitHealth("boss1") / UnitHealthMax("boss1") * 100 >= 35 then
			specWarnWailingSouls:Play("killmob")
		else--Down below, or boss not 35%, not getting adds
			specWarnWailingSouls:Play("aesoon")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 235907 then
		warnCollapsingFissure:Show()
	elseif spellId == 236449 then--Soulbind Cast
		self.vb.soulboundCast = self.vb.soulboundCast + 1
		if self.vb.phase == 2 then
			if self:IsEasy() then
				--["236449-Soulbind"] = "pull:12.5, 25.4, 94.7, 26.0, 75.9, 19.1, 20.3",
				timerSoulbindCD:Start(24, self.vb.soulboundCast+1)
			else
				timerSoulbindCD:Start(19.6, self.vb.soulboundCast+1)
			end
		else
			if self:IsEasy() then
				--["236449-Soulbind"] = "pull:52.4, 84.8, 34.7, 17.4, 24.6, 24.7"
				timerSoulbindCD:Start(34, self.vb.soulboundCast+1)
			else
				timerSoulbindCD:Start(24, self.vb.soulboundCast+1)
			end
		end
	elseif spellId == 236542 then--Sundering Doom Finished (doomed sundering, soaked by spirit realm is next)
		if DBM:UnitBuff("player", spiritRealm) or DBM:UnitDebuff("player", spiritRealm) then--Figure out which it is
			specWarnDoomedSunderingTaunt:Show(BOSS)
			specWarnDoomedSunderingTaunt:Play("tauntboss")
		end
	elseif spellId == 236544 then--Doomed Sundering Finished (sundring doom, soaked by regular realm is next)
		if not (DBM:UnitBuff("player", spiritRealm) or DBM:UnitDebuff("player", spiritRealm)) then--Figure out which it is
			specWarnSunderingDoomTaunt:Show(BOSS)
			specWarnSunderingDoomTaunt:Play("tauntboss")
		end
--	elseif spellId ==  236138 or spellId == 236131 then
		--timerWitherCD:Start()
--	elseif spellId == 235969 then--Shattering Scream
--		timerShatteringScreamCD:Start(nil, args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 236459 then
		warnSoulbind:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnSoulbind:Show()
			specWarnSoulbind:Play("targetyou")
			yellSoulbind:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if self.Options.SoulIcon then
			self:SetIcon(args.destName, self.vb.soulIcon)
		end
		self.vb.soulIcon = self.vb.soulIcon + 1
		if self.vb.soulIcon > 4 then
			self.vb.soulIcon = 3
		end
	elseif spellId == 235924 then
		self.vb.spearCast = self.vb.spearCast + 1
		warnSpearofAnguish:Show(self.vb.spearCast, args.destName)
		timerSpearofAnquishCD:Start(nil, self.vb.spearCast+1)
		if args:IsPlayer() then
			specWarnSpearofAnguish:Show()
			specWarnSpearofAnguish:Play("runout")
			yellSpearofAnguish:Countdown(6)
		end
	elseif spellId == 238018 then
		if args:IsPlayer() then
			specWarnTormentingCries:Show()
			specWarnTormentingCries:Play("targetyou")
			yellTormentingCries:Yell()
		else
			warnTormentingCries:Show(args.destName)
		end
	elseif spellId == 236513 then
		if self.Options.NPAuraOnBonecageArmor then
			if self:IsMythic() then
				DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 180)
			else
				DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 60)
			end
		end
		local cid = self:GetCIDFromGUID(args.destGUID)
		if self.Options.IgnoreTemplarOn3Tank and (cid == 119938 or cid == 118715) and self.vb.tankCount >= 3 then return end--Reanimated templar
		self.vb.boneArmorCount = self.vb.boneArmorCount + 1
		if self:AntiSpam(4, args.destName) and self.vb.boneArmorCount == 1 then
			warnBonecageArmor:Show(args.destName)
		end
	elseif (spellId ==  236138 or spellId == 236131) then
		warnWither:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnWither:Show()
			specWarnWither:Play("switchphase")
		end
	elseif spellId == 235969 then
		if args:IsPlayer() and self:AntiSpam(5, 2) then
			if self.vb.boneArmorCount > 0 then
				specWarnShatteringScreamAdd:Show(boneArmor)
				specWarnShatteringScreamAdd:Play("getboned")
			else
				specWarnShatteringScream:Show()
				specWarnShatteringScream:Play("scatter")
			end
		end
		if self.vb.boneArmorCount > 0 then
			warnShatteringScream:CombinedShow(1, args.destName)
		end
	elseif spellId == 236515 and args:IsPlayer() then
		yellShatteringScream:Yell(args.spellName, args.amount or 1)
	elseif spellId == 236361 or spellId == 239923 then
		warnSpiritChains:CombinedShow(0.3, args.destName)
	elseif spellId == 236548 then
		local amount = args.amount or 1
		warnTorment:Cancel()
		warnTorment:Schedule(0.5, args.destName, amount)
	elseif spellId == 235732 then
		playersInSpirit[#playersInSpirit+1] = args.destName
		tDeleteItem(playersNotInSpirit, args.destName)
		if args:IsPlayer() then--Only show people not in spirit realm
			DBM.RangeCheck:Show(8, regularFilter)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 236459 then
		if self.Options.SoulIcon then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.RangeFrame and args:IsPlayer() then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 235924 then
		if args:IsPlayer() then
			yellSpearofAnguish:Cancel()
		end
	elseif spellId == 236513 then--Bonecage Armor
		if self.Options.NPAuraOnBonecageArmor then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
		local cid = self:GetCIDFromGUID(args.destGUID)
		if self.Options.IgnoreTemplarOn3Tank and (cid == 119938 or cid == 118715) and self.vb.tankCount >= 3 then return end--Reanimated templar
		self.vb.boneArmorCount = self.vb.boneArmorCount - 1
	elseif spellId == 235969 and args:IsPlayer() then--Shattering Scream
		yellShatteringScream:Cancel()
	elseif spellId == 236072 then--Wailing Souls
		self.vb.soulboundCast = 0
		--timerSoulbindCD:Start(12, 1)--5-14, too variable to start timer for first cast after souls
		--timerWitherCD:Start(19.7)
		timerWailingSoulsCD:Start(50, 1)
	elseif spellId == 235732 then
		playersNotInSpirit[#playersNotInSpirit+1] = args.destName
		tDeleteItem(playersInSpirit, args.destName)
		if args:IsPlayer() then--Only show people in spirit realm
			DBM.RangeCheck:Show(8, spiritFilter)
		end
	elseif spellId == 238570 then--Tormented Cries
		timerTormentedCriesCD:Start(58, self.vb.tormentedCriesCast+1)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 118462 then
		timerSoulbindCD:Stop()
		timerSpearofAnquishCD:Stop()
		berserkTimer:Cancel()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	--["235907-Collapsing Fissure"] = "pull:9.7, 31.5, 10.4, 2.4, 4.7, 22.2, 1.8, 9.8, 2.3, 0.9, 41.4"
	if spellId == 235907 then--Collapsing Fissure
		--timerCollapsingFissureCD:Start()
	elseif spellId == 239978 then
		self.vb.phase = 2
		timerSoulbindCD:Stop()
		timerWailingSoulsCD:Stop()
		timerTormentedCriesCD:Stop()
		if not self:IsEasy() then
			timerSpearofAnquishCD:Stop()
			timerSpearofAnquishCD:Start(8, self.vb.spearCast+1)
		end
		timerSoulbindCD:Start(10, self.vb.soulboundCast+1)
		--New Phase Timers
		timerSunderingDoomCD:Start(7)
		timerDoomedSunderingCD:Start(18)
	end
end

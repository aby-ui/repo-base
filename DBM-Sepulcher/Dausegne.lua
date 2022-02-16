local mod	= DBM:NewMod(2459, "DBM-Sepulcher", nil, 1195)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220110111635")
mod:SetCreatureID(181224)
mod:SetEncounterID(2540)
mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20220106000000)
mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 359483 363607 361513 361630 365418 360960",
	"SPELL_AURA_APPLIED 361966 361018 361651",
	"SPELL_AURA_APPLIED_DOSE 361966",
	"SPELL_AURA_REMOVED 361966 361018 361651",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, exact stack count optimal of tanks swaps of 361966, for now most warnings are silent or way overtuned
--TODO, use https://ptr.wowhead.com/spell=359481/domination-core for auto marking domination ores maybe, if more than 1 to mark on mythic
--TODO, rework the ring code to have timers for each ring, and smarter handling of soft enrage and other stuff. Waiting for CLEU event from next build first
--[[
(ability.id = 359483 or ability.id = 361513 or ability.id = 361630 or ability.id = 365418 or ability.id = 360960) and type = "begincast"
 or ability.id = 361651 and (type = "applybuff" or type = "removebuff")
--]]
--The Fallen Oracle
local warnInfusedStrikes						= mod:NewStackAnnounce(361966, 2, nil, "Tank|Healer")
local warnStaggeringBarrage						= mod:NewTargetNoFilterAnnounce(361018, 3)
local warnDominationCore						= mod:NewCountAnnounce(359483, 3)
--Inevitable Dominion
local warnSiphonReservoir						= mod:NewCountAnnounce(361643, 2)

--The Fallen Oracle
local specWarnInfusedStrikes					= mod:NewSpecialWarningStack(361966, nil, 8, nil, nil, 1, 6)
local specWarnInfusedStrikesTaunt				= mod:NewSpecialWarningTaunt(361966, nil, nil, nil, 1, 2)
local yellInfusedStrikes						= mod:NewShortFadesYell(361966)
local specWarnStaggeringBarrage					= mod:NewSpecialWarningYouPos(361018, nil, nil, nil, 1, 2)
local yellStaggeringBarrage						= mod:NewShortPosYell(361018)
local yellStaggeringBarrageFades				= mod:NewIconFadesYell(361018)
local specWarnStaggeringBarrageTarget			= mod:NewSpecialWarningTarget(361018, false, nil, nil, 1, 2, 3)--Optional Soak special warning that auto checks no soak debuff
local specWarnDominationBolt					= mod:NewSpecialWarningInterruptCount(363607, "HasInterrupt", nil, nil, 1, 2)
local specWarnObliterationArc					= mod:NewSpecialWarningDodgeCount(361513, nil, nil, nil, 2, 2)
local specWarnDisintegrationHalo				= mod:NewSpecialWarningCount(365373, nil, nil, nil, 2, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)
--Inevitable Dominion
local specWarnTotalDominion						= mod:NewSpecialWarningSpell(365418, nil, nil, nil, 3, 2)--Basically soft enrage/wipe mechanic

--mod:AddTimerLine(BOSS)
--The Fallen Oracle
local timerUnleashedInfusion					= mod:NewTargetTimer(20, 361967, nil, nil, nil, 2)
local timerStaggeringBarrageCD					= mod:NewCDCountTimer(35, 361018, nil, nil, nil, 3)
local timerDominationCoreCD						= mod:NewCDCountTimer(33.5, 359483, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerObliterationArcCD					= mod:NewCDCountTimer(35, 361513, nil, nil, nil, 3)
local timerDisintegrationHaloCD					= mod:NewCDCountTimer(70, 365373, nil, nil, nil, 3)
--Inevitable Dominion
local timerSiphonReservoirCD					= mod:NewCDCountTimer(28.8, 361643, nil, nil, nil, 6)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(361651, true)
mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})--Only one was happening on heroic, is 3 mythic only?
--mod:AddNamePlateOption("NPAuraOnBurdenofDestiny", 353432, true)

mod.vb.DebuffIcon = 1
mod.vb.barrageCount = 0
mod.vb.ReservoirCount = 0
mod.vb.arcCount = 0
mod.vb.coreCount = 0
mod.vb.haloCount = 0
mod.vb.softEnrage = false
local castsPerGUID = {}

function mod:OnCombatStart(delay)
	self.vb.DebuffIcon = 1
	self.vb.barrageCount = 0
	self.vb.ReservoirCount = 0
	self.vb.arcCount = 0
	self.vb.coreCount = 0
	self.vb.haloCount = 0
	self.vb.softEnrage = false
	timerDisintegrationHaloCD:Start(5.2-delay, 1)
	timerDominationCoreCD:Start(6.5-delay, 1)
	timerObliterationArcCD:Start(15-delay, 1)
	timerStaggeringBarrageCD:Start(29-delay, 1)
	timerSiphonReservoirCD:Start(72.8-delay, 1)
--	if self.Options.NPAuraOnBurdenofDestiny then
--		DBM:FireEvent("BossMod_EnableHostileNameplates")
--	end
end

function mod:OnCombatEnd()
	table.wipe(castsPerGUID)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
--	if self.Options.NPAuraOnBurdenofDestiny then
--		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
--	end
end

--[[
function mod:OnTimerRecovery()

end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 359483 then
		self.vb.coreCount = self.vb.coreCount + 1
		warnDominationCore:Show(self.vb.coreCount)
		timerDominationCoreCD:Start(nil, self.vb.coreCount+1)
	elseif spellId == 363607 then
		if not castsPerGUID[args.sourceGUID] then
			castsPerGUID[args.sourceGUID] = 0
		end
		castsPerGUID[args.sourceGUID] = castsPerGUID[args.sourceGUID] + 1
		local count = castsPerGUID[args.sourceGUID]
		if self:CheckInterruptFilter(args.sourceGUID, false, false) then
			specWarnDominationBolt:Show(args.sourceName, count)
			if count == 1 then
				specWarnDominationBolt:Play("kick1r")
			elseif count == 2 then
				specWarnDominationBolt:Play("kick2r")
			elseif count == 3 then
				specWarnDominationBolt:Play("kick3r")
			elseif count == 4 then
				specWarnDominationBolt:Play("kick4r")
			elseif count == 5 then
				specWarnDominationBolt:Play("kick5r")
			else
				specWarnDominationBolt:Play("kickcast")
			end
		end
	elseif spellId == 361513 then
		self.vb.arcCount = self.vb.arcCount + 1
		specWarnObliterationArc:Show(self.vb.arcCount)
		specWarnObliterationArc:Play("shockwave")
		timerObliterationArcCD:Start(nil, self.vb.arcCount+1)
	elseif spellId == 361630 then--Teleport
		self.vb.ReservoirCount = self.vb.ReservoirCount + 1
		warnSiphonReservoir:Show(self.vb.ReservoirCount)
		timerStaggeringBarrageCD:Stop()
		timerDominationCoreCD:Stop()
		timerObliterationArcCD:Stop()
		timerDisintegrationHaloCD:Stop()
	elseif spellId == 365418 then
		self.vb.softEnrage = true
		specWarnTotalDominion:Show()
		specWarnTotalDominion:Play("stilldanger")
	elseif spellId == 360960 then
		self.vb.DebuffIcon = 1
		self.vb.barrageCount = self.vb.barrageCount + 1
		timerStaggeringBarrageCD:Start(nil, self.vb.barrageCount+1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 361966 then
		local amount = args.amount or 1
		if args:IsPlayer() then
			yellInfusedStrikes:Cancel()
			yellInfusedStrikes:Countdown(spellId, 5)
			if amount % 3 == 0 then
				if amount >= 9 then
					specWarnInfusedStrikes:Show(amount)
					specWarnInfusedStrikes:Play("stackhigh")
				else
					warnInfusedStrikes:Show(args.destName, amount)
				end
			end
		else
			if amount % 3 == 0 then
				if (amount >= 9) and not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", spellId) then
					specWarnInfusedStrikesTaunt:Show(args.destName)
					specWarnInfusedStrikesTaunt:Play("tauntboss")
				else
					warnInfusedStrikes:Show(args.destName, amount)
				end
			end
		end
		timerUnleashedInfusion:Stop(args.destName)
		timerUnleashedInfusion:Start(20, args.destName)
	elseif spellId == 361018 then
		local icon = self.vb.DebuffIcon
		if self.Options.SetIconOnStaggeringBarrage then
			self:SetIcon(args.destName, icon)
		end
		if args:IsPlayer() then
			--Unschedule target warning if you've become one of victims
			specWarnStaggeringBarrageTarget:Cancel()
			specWarnStaggeringBarrageTarget:CancelVoice()
			--Now show your warnings
			specWarnStaggeringBarrage:Show(self:IconNumToTexture(icon))
			specWarnStaggeringBarrage:Play("mm"..icon)
			yellStaggeringBarrage:Yell(icon, icon)
			yellStaggeringBarrageFades:Countdown(spellId, nil, icon)
		elseif self.Options.SpecWarn361018target and not DBM:UnitDebuff("player", 364289) then
			--Don't show special warning if you're one of victims
			specWarnStaggeringBarrageTarget:CombinedShow(0.5, args.destName)
			specWarnStaggeringBarrageTarget:ScheduleVoice(0.5, "helpsoak")
		else
			warnStaggeringBarrage:CombinedShow(0.5, args.destName)
		end
		self.vb.DebuffIcon = self.vb.DebuffIcon + 1
	elseif spellId == 361651 then
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(2, "enemyabsorb", nil, args.amount, "boss1")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then
		if args:IsPlayer() then
			yellInfusedStrikes:Cancel()
		end
		timerUnleashedInfusion:Stop(args.destName)
	elseif spellId == 361018 then
		if self.Options.SetIconOnStaggeringBarrage then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			yellStaggeringBarrageFades:Cancel()
		end
	elseif spellId == 361651 then--Siphoned Barrier
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
		timerDominationCoreCD:Start(7.6, self.vb.coreCount+1)
		timerObliterationArcCD:Start(16.1, self.vb.arcCount+1)
		timerStaggeringBarrageCD:Start(30, self.vb.barrageCount+1)
		timerSiphonReservoirCD:Start(108, self.vb.ReservoirCount+1)--108-110, closer here than teleport to teleport.
		if not self.vb.softEnrage then
			timerDisintegrationHaloCD:Start(6.3, self.vb.haloCount+1)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("spell:365373") then
		self.vb.haloCount = self.vb.haloCount + 1
		specWarnDisintegrationHalo:Show(self.vb.haloCount)
		specWarnDisintegrationHalo:Play("watchwave")
		if not self.vb.softEnrage then
			timerDisintegrationHaloCD:Start(70, self.vb.haloCount+1)
		end
	end
end
mod.RAID_BOSS_WHISPER = mod.CHAT_MSG_RAID_BOSS_EMOTE--Dunno what this is about. You ok Blizz?

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and not playerDebuff and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]

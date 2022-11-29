local mod	= DBM:NewMod(2478, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128090806")
mod:SetCreatureID(186339, 186338)
mod:SetEncounterID(2581)
--mod:SetUsedIcons(1, 2, 3)
mod:SetBossHPInfoToHighest()
mod:SetHotfixNoticeRev(20221127000000)
mod:SetMinSyncRevision(20221105000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 382670 386063 385339 386547 385434 382836",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 384808 392198",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 392198",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 382670 or ability.id = 386063 or ability.id = 385339 or ability.id = 386547 or ability.id = 385434 or ability.id = 382836) and type = "begincast"
 or (target.id = 186339 or target.id = 186338) and type = "death"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 or type = "interrupt"
--]]
--Teera
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25552))
local warnRepel									= mod:NewCastAnnounce(386547, 3, nil, nil, nil, nil, nil, 2)
local warnSpiritLeap							= mod:NewSpellAnnounce(385434, 3)

local specWarnGaleArrow							= mod:NewSpecialWarningDodgeCount(382670, nil, nil, nil, 2, 2)
local specWarnGuardianWind						= mod:NewSpecialWarningInterrupt(384808, "HasInterrupt", nil, nil, 1, 2)

local timerGaleArrowCD							= mod:NewCDCountTimer(57.4, 382670, nil, nil, nil, 3)
local timerRepelCD								= mod:NewCDCountTimer(57.4, 386547, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerSpiritLeapCD							= mod:NewCDCountTimer(20.4, 385434, nil, nil, nil, 3)--20-38.4 (if guardian wind isn't interrupted this can get delayed by repel recast)

--Maruuk
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25546))
local warnFrightfulRoar							= mod:NewCastAnnounce(386063, 3, nil, nil, nil, nil, nil, 2)--Not a special warning, since I don't want to layer 2 special warings for same pair

local specWarnEarthsplitter						= mod:NewSpecialWarningDodgeCount(385339, nil, nil, nil, 2, 2)
local specWarnFrightfulRoar						= mod:NewSpecialWarningRun(386063, nil, nil, nil, 4, 2)
local specWarnBrutalize							= mod:NewSpecialWarningDefensive(382836, nil, nil, nil, 1, 2)

local timerEarthSplitterCD						= mod:NewCDCountTimer(57.4, 385339, nil, false, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)--Off by default since it should always be cast immediately after Repel)
local timerFrightfulRoarCD						= mod:NewCDCountTimer(30.4, 386063, nil, nil, nil, 2, nil, DBM_COMMON_L.MAGIC_ICON)--New timer unknown
local timerBrutalizeCD							= mod:NewCDCountTimer(18.2, 382836, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Delayed a lot. Doesn't alternate or sequence leanly, it just spell queues in randomness

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})
mod:AddNamePlateOption("NPAuraOnAncestralBond", 392198)

--Gale Arrow: 21.5, 57.4, 57.5
--Repel: 50, 57.4, 57.5
--Spirit Leap: 6.0, 24.0, 13.5, 19.9, 24.0, 13.5, 20.0, 23.9, 13.5
--Earth Splitter: 51, 57.4, 57.5
--Frightful Roar: 5.5, 38.4, 18.9, 38.4, 19, 38.5
--Brutalize: 13.5, 7.4, 15.9, 34.0, 7.4, 15.9, 34.0, 7.5, 15.9
--Static Counts
mod.vb.galeCount = 0
mod.vb.repelCount = 0
mod.vb.splitterCount = 0
--Sequenced counts
mod.vb.leapCount = 0
mod.vb.roarCount = 0
mod.vb.brutalizeCount = 0

--[[
--Use for spirit leap if it's on players and scanable
function mod:ArrowTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnHeavyArrow:Show()
		specWarnHeavyArrow:Play("targetyou")
		yellHeavyArrow:Yell()
	else
		warnHeavyArrow:Show(targetname)
	end
end
--]]

function mod:OnCombatStart(delay)
	--Static Counts
	self.vb.galeCount = 0
	self.vb.repelCount = 0
	self.vb.splitterCount = 0
	--Sequenced counts
	self.vb.leapCount = 0
	self.vb.roarCount = 0
	self.vb.brutalizeCount = 0
	--Terra
	timerSpiritLeapCD:Start(6-delay, 1)
	timerGaleArrowCD:Start(21.5-delay, 1)
	timerRepelCD:Start(50-delay, 1)
	--Maruuk
	timerFrightfulRoarCD:Start(5.5-delay, 1)
	timerBrutalizeCD:Start(13.5-delay, 1)
	timerEarthSplitterCD:Start(51-delay, 1)
	if self.Options.NPAuraOnAncestralBond then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
	if self.Options.NPAuraOnAncestralBond then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 382670 then
		self.vb.galeCount = self.vb.galeCount + 1
		specWarnGaleArrow:Show(self.vb.galeCount)
		specWarnGaleArrow:Play("watchstep")
		timerGaleArrowCD:Start(nil, self.vb.galeCount+1)
	elseif spellId == 386063 then
		self.vb.roarCount = self.vb.roarCount + 1
		if self.Options.SpecWarn386063run then
			specWarnFrightfulRoar:Show()
			specWarnFrightfulRoar:Play("justrun")
			specWarnFrightfulRoar:ScheduleVoice(1, "fearsoon")
		else
			warnFrightfulRoar:Show()
			warnFrightfulRoar:Play("fearsoon")
		end
		local timer
		--Frightful Roar: 5.5, 38.4, 18.9, 38.4, 19, 38.5
		if self.vb.roarCount % 2 == 0 then--2, 4, 6, etc
			timer = 18.9
		else
			timer = 38.4
		end
		timerFrightfulRoarCD:Start(timer, self.vb.roarCount+1)
	elseif spellId == 385339 then
		self.vb.splitterCount = self.vb.splitterCount + 1
		specWarnEarthsplitter:Show(self.vb.splitterCount)
		specWarnEarthsplitter:Play("watchstep")
		timerEarthSplitterCD:Start(nil, self.vb.splitterCount+1)
	elseif spellId == 386547 then
		self.vb.repelCount = self.vb.repelCount + 1
		warnRepel:Show(self.vb.repelCount)
		warnRepel:Play("carefly")
		timerRepelCD:Start(nil, self.vb.repelCount+1)
	elseif spellId == 385434 then
		self.vb.leapCount = self.vb.leapCount + 1
--		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "ArrowTarget", 0.1, 8, true)
		warnSpiritLeap:Show()
		local timer
		--Spirit Leap: 6.0, 24.0, 13.5, 19.9, 24.0, 13.5, 20.0, 23.9, 13.5
		if self.vb.leapCount % 3 == 0 then--3, 6, 9, etc
			timer = 19.9
		elseif self.vb.leapCount % 3 == 1 then--1, 4, 7, etc
			timer = 23.9
		else--2, 5, 8, etc
			timer = 13.4
		end
		timerSpiritLeapCD:Start(timer, self.vb.leapCount+1)
	elseif spellId == 382836 then
		self.vb.brutalizeCount = self.vb.brutalizeCount + 1
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnBrutalize:Show()
			specWarnBrutalize:Play("defensive")
		end
		local timer
		--Brutalize: 13.5, 7.4, 15.9, 34.0, 7.4, 15.9, 34.0, 7.5, 15.9
		if self.vb.brutalizeCount % 3 == 0 then--3, 6, 9, etc
			timer = 34
		elseif self.vb.brutalizeCount % 3 == 1 then--1, 4, 7, etc
			timer = 7.4
		else--2, 5, 8, etc
			timer = 15.9
		end
		timerBrutalizeCD:Start(timer, self.vb.brutalizeCount+1)
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then

	end
end
--]]

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 384808 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnGuardianWind:Show(args.sourceName)
		specWarnGuardianWind:Play("kickcast")
	elseif spellId == 392198 then
		if self.Options.NPAuraOnAncestralBond then
			DBM.Nameplate:Show(true, args.destGUID, spellId)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 392198 then
		if self.Options.NPAuraOnAncestralBond then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 186339 then--Teera
		timerGaleArrowCD:Stop()
		timerRepelCD:Stop()
		timerSpiritLeapCD:Stop()
	elseif cid == 186338 then--Maruuk
		timerEarthSplitterCD:Stop()
		timerFrightfulRoarCD:Stop()
		timerBrutalizeCD:Stop()
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
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

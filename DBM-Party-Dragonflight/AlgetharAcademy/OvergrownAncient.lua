local mod	= DBM:NewMod(2512, "DBM-Party-Dragonflight", 5, 1201)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186951)
mod:SetEncounterID(2563)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221015000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 388923 388623 396640 388544",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 388796 389033",
	"SPELL_AURA_APPLIED_DOSE 389033",
	"SPELL_AURA_REMOVED 389033",
	"SPELL_AURA_REMOVED_DOSE 389033",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, Branch Out target scan? it says "at a location" not "at a player"
--TODO, do stuff with Splinterbark/Abunance mythic mechanic? Seems self explanatory. You get a bleedd on spawn, and clear it on death with target goal to be "don't ignore adds"
--[[
(ability.id = 388923 or ability.id = 388623 or ability.id = 396640 or ability.id = 388544) and type = "begincast"
 or ability.id = 388796 and type = "applybuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--local warnEntanglingRoots						= mod:NewTargetNoFilterAnnounce(371453, 3, nil, "RemoveMagic")

local specWarnGerminate							= mod:NewSpecialWarningDodge(388796, nil, nil, nil, 2, 2)
local specWarnLasherToxin						= mod:NewSpecialWarningStack(389033, nil, 12, nil, nil, 1, 6)
local specWarnBurstForth						= mod:NewSpecialWarningSpell(388923, nil, nil, nil, 2, 2)
local specWarnBranchOut							= mod:NewSpecialWarningDodge(388623, nil, nil, nil, 2, 2)
local specWarnHealingTouch						= mod:NewSpecialWarningInterrupt(396640, "HasInterrupt", nil, nil, 1, 2)
local specWarnBarkbreaker						= mod:NewSpecialWarningDefensive(388544, nil, nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerGerminateCD							= mod:NewCDCountTimer(29.1, 388796, nil, nil, nil, 3)
local timerBurstForthCD							= mod:NewCDTimer(49.8, 388923, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)--Assumed it's on same cycle as branch out, CD not confirmed
local timerBranchOutCD							= mod:NewCDTimer(49.8, 388623, nil, nil, nil, 3)
local timerHealingTouchCD						= mod:NewCDTimer(5, 396640, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--First cast only, after that it's iffy
local timerBarkbreakerCD						= mod:NewCDCountTimer(35, 388544, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.HEALER_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(389033, "RemovePoison")
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

local toxinStacks = {}
mod.vb.germinateCount = 0
mod.vb.barkCount = 0

function mod:OnCombatStart(delay)
	table.wipe(toxinStacks)
	self.vb.germinateCount = 0
	self.vb.barkCount = 0
	timerBarkbreakerCD:Start(4.6-delay)--4.6-9.3
	timerGerminateCD:Start(13.1-delay, 1)
	timerBranchOutCD:Start(30-delay)
	timerBurstForthCD:Start(47-delay)
	if self.Options.InfoFrame and self:IsMythic() then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(389033))
		DBM.InfoFrame:Show(5, "table", toxinStacks, 1)
	end
end

function mod:OnCombatEnd()
	table.wipe(toxinStacks)
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 388923 then
		specWarnBurstForth:Show()
		specWarnBurstForth:Play("aesoon")
		timerBurstForthCD:Start()

		--The other possible timer explanation
		--timerBarkbreakerCD:Restart(6, self.vb.barkCount+1)
		--timerGerminateCD:Restart(15.7, self.vb.germinateCount+1)
	elseif spellId == 388623 then
		specWarnBranchOut:Show()
		specWarnBranchOut:Play("watchstep")
		timerBranchOutCD:Start()
		timerHealingTouchCD:Start(5)
	elseif spellId == 396640 then
		timerHealingTouchCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingTouch:Show(args.sourceName)
			specWarnHealingTouch:Play("kickcast")
		end
	elseif spellId == 388544 then
		self.vb.barkCount = self.vb.barkCount + 1
		--4.6, 30.3, 18.2, 29.2
		if self.vb.germinateCount % 2 == 0 then
			timerBarkbreakerCD:Start(18.2, self.vb.barkCount+1)
		else
			timerBarkbreakerCD:Start(29.2, self.vb.barkCount+1)
		end
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnBarkbreaker:Show()
			specWarnBarkbreaker:Play("defensive")
		end
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
	if spellId == 388796 then
		self.vb.germinateCount = self.vb.germinateCount + 1
		specWarnGerminate:Show()
		specWarnGerminate:Play("watchstep")
		--13.1, 29.1, 20.6, 29.1, 20.5
		if self.vb.germinateCount % 2 == 0 then
			timerGerminateCD:Start(20.5, self.vb.germinateCount+1)
		else
			timerGerminateCD:Start(29.1, self.vb.germinateCount+1)
		end
	elseif spellId == 389033 then
		local amount = args.amount or 1
		toxinStacks[args.destName] = amount
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks, 0.2)
		end
		if args:IsPlayer() and amount >= 12 and self:AntiSpam(3.5, 1) then
			specWarnLasherToxin:Show(amount)
			specWarnLasherToxin:Play("stackhigh")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 389033 then
		toxinStacks[args.destName] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks, 0.2)
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 389033 then
		toxinStacks[args.destName] = args.amount or 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks, 0.2)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 196548 then--Ancient Branch
		timerHealingTouchCD:Stop()
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

local mod	= DBM:NewMod(2507, "DBM-Party-Dragonflight", 8, 1204)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220904205606")
mod:SetCreatureID(189722)
mod:SetEncounterID(2616)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 385551 385181 385531 385442",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 385743 374389",
	"SPELL_AURA_APPLIED_DOSE 385743 374389",
	"SPELL_AURA_REMOVED 374389",
	"SPELL_AURA_REMOVED_DOSE 374389"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 385551 or ability.id = 385181 or ability.id = 385531 or ability.id = 385442) and type = "begincast"
 or ability.id = 385743
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 or (source.type = "NPC" and source.firstSeen = timestamp) or (target.type = "NPC" and target.firstSeen = timestamp)
--]]
--TODO, actually detect gulp target or is it no one specific?
local warnHangry								= mod:NewSpellAnnounce(385743, 2, nil, "Tank|Healer")
local warnBodySlam								= mod:NewTargetNoFilterAnnounce(385531, 3)
local warnToxicEff								= mod:NewSpellAnnounce(385442, 3)

local specWarnGulpSwogToxin						= mod:NewSpecialWarningStack(374389, nil, 8, nil, nil, 1, 6)
local specWarnGulp								= mod:NewSpecialWarningRun(385551, nil, nil, nil, 4, 2)
local specWarnHangry							= mod:NewSpecialWarningDispel(385743, "RemoveEnrage", nil, nil, 1, 2)
local specWarnOverpoweringCroak					= mod:NewSpecialWarningDodge(385187, nil, nil, nil, 2, 2)--385181 is cast but lacks tooltip, so damage Id used for tooltip/option
local specWarnBodySlam							= mod:NewSpecialWarningMoveAway(385531, nil, nil, nil, 1, 2)
local yellBodySlam								= mod:NewYell(385531)
--local specWarnDominationBolt					= mod:NewSpecialWarningInterrupt(363607, "HasInterrupt", nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerGulpCD								= mod:NewAITimer(35, 385551, nil, nil, nil, 3)
local timerOverpoweringCroakCD					= mod:NewAITimer(35, 385187, nil, nil, nil, 2)--Tough to classify, it's aoe, it's targeted dodge, and it's adds
local timerBellySlamCD							= mod:NewAITimer(35, 385531, nil, nil, nil, 3)
local timerToxicEffluviaaCD						= mod:NewAITimer(35, 385442, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(12, 385531)
mod:AddInfoFrameOption(374389, "RemovePoison")
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

local toxinStacks = {}

function mod:BodySlamTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnBodySlam:Show()
		specWarnBodySlam:Play("runout")
		yellBodySlam:Yell()
	else
		warnBodySlam:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	table.wipe(toxinStacks)
	timerGulpCD:Start(1-delay)
	timerOverpoweringCroakCD:Start(1-delay)
	timerBellySlamCD:Start(1-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(374389))
		DBM.InfoFrame:Show(5, "table", toxinStacks, 1)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(12)
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
	if spellId == 385551 then
		specWarnGulp:Show()
		specWarnGulp:Play("justrun")
		timerGulpCD:Start()
	elseif spellId == 385181 then
		specWarnOverpoweringCroak:Show()
		specWarnOverpoweringCroak:Play("aesoon")
		specWarnOverpoweringCroak:ScheduleVoice(2, "watchstep")
		timerOverpoweringCroakCD:Start()
	elseif spellId == 385531 then
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "BodySlamTarget", 0.1, 6, true)
		timerBellySlamCD:Start()
	elseif spellId == 385442 then
		warnToxicEff:Show()
		timerToxicEffluviaaCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 385743 then
		if self.Options.SpecWarn385743dispel then
			specWarnHangry:Show(args.destName)
			specWarnHangry:Play("enrage")
		else
			warnHangry:Show()
		end
	elseif spellId == 374389 then
		local amount = args.amount or 1
		toxinStacks[args.destName] = amount
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks)
		end
		if args:IsPlayer() and amount >= 8 then
			specWarnGulpSwogToxin:Show(amount)
			specWarnGulpSwogToxin:Play("stackhigh")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 374389 then
		toxinStacks[args.destName] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks)
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 374389 then
		toxinStacks[args.destName] = args.amount or 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(toxinStacks)
		end
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

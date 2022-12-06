local mod	= DBM:NewMod(2505, "DBM-Party-Dragonflight", 6, 1203)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186739)
mod:SetEncounterID(2585)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221127000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 372222 385578 384223 373932 384132",
	"SPELL_AURA_REMOVED 384132"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_DIED"
)

--TODO, number of images spawned for tracking
--TODO, change arcane orb to personal alert if target scanner works or remove yell if it doesn't
--TODO, timers restart on overwhelming energy end? Does timer for next overwhelming start at cast of previous, or end of previous?
--[[
(ability.id = 372222 or ability.id = 385578 or ability.id = 384223 or ability.id = 384132) and type = "begincast"
 or ability.id = 384132 and type = "removebuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnSummonDraconicImage					= mod:NewSpellAnnounce(384223, 3)

local specWarnArcaneCleave						= mod:NewSpecialWarningSpell(372222, nil, nil, nil, 1, 2)
local specWarnAncientOrb						= mod:NewSpecialWarningDodge(385578, nil, nil, nil, 2, 2)
local yellAncientOrb							= mod:NewYell(385578)
local specWarnIllusionaryBolt					= mod:NewSpecialWarningInterrupt(373932, "HasInterrupt", nil, nil, 1, 2)
local specWarnOverwhelmingEnergy				= mod:NewSpecialWarningSpell(384132, nil, nil, nil, 2, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerArcaneCleaveCD						= mod:NewCDTimer(13.3, 372222, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--13.3-15
local timerAncientOrbCD							= mod:NewCDTimer(15.7, 385578, nil, nil, nil, 3)
local timerSummonDraconicImageCD				= mod:NewCDTimer(14.2, 384223, nil, nil, nil, 1)
local timerOverwhelmingenergyCD					= mod:NewCDTimer(35, 384132, nil, nil, nil, 6)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OrbTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellAncientOrb:Yell()
	end
end

function mod:OnCombatStart(delay)
	timerSummonDraconicImageCD:Start(3.7-delay)
	timerArcaneCleaveCD:Start(5-delay)
	timerAncientOrbCD:Start(10.1-delay)
	timerOverwhelmingenergyCD:Start(24.3-delay)
end

--function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 372222 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnArcaneCleave:Show()
			specWarnArcaneCleave:Play("shockwave")
		end
		timerArcaneCleaveCD:Start()
	elseif spellId == 385578 then
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "OrbTarget", 0.1, 8, true)
		specWarnAncientOrb:Show()
		specWarnAncientOrb:Play("watchorb")
		timerAncientOrbCD:Start()
	elseif spellId == 384223 then
		warnSummonDraconicImage:Show()
		timerSummonDraconicImageCD:Start()
	elseif spellId == 373932 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnIllusionaryBolt:Show(args.sourceName)
		specWarnIllusionaryBolt:Play("kickcast")
	elseif spellId == 384132 then--Overwhelming Energy
		timerArcaneCleaveCD:Stop()
		timerAncientOrbCD:Stop()
		timerSummonDraconicImageCD:Stop()
		specWarnOverwhelmingEnergy:Show()
		specWarnOverwhelmingEnergy:Play("phasechange")
	end
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 361966 then

	end
end
--]]

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 384132 then--Overwhelming Energy
		timerSummonDraconicImageCD:Start(4.7)--4.7-5.7
		timerArcaneCleaveCD:Start(7.1)--7.1-8.1
		timerAncientOrbCD:Start(12)--12-13
		timerOverwhelmingenergyCD:Start(43.3)
	end
end

--[[
function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 190187 then--Draconic Image

	elseif cid == 192955 or cid == 190967 then--Draconic Illusion

	end
end

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

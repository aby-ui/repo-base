local mod	= DBM:NewMod(2498, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220820005632")
mod:SetCreatureID(186616)
mod:SetEncounterID(2637)
mod:SetUsedIcons(8)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 388283 388817 385916 386921 386530",
--	"SPELL_CAST_SUCCESS 386320",
	"SPELL_SUMMON 386320",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, fix spear creatureid?
--TODO, timers with longer logs
--[[
(ability.id = 388283 or ability.id = 388817 or ability.id = 385916 or ability.id = 385916 or ability.id = 386921 or ability.id = 386530) and type = "begincast"
 or spellid = 362805
 or target.id = 194367 and type = "death"
--]]
local warnShardsofStone							= mod:NewCountAnnounce(388817, 3)
local warnDragonkillerLance						= mod:NewCastAnnounce(386530, 1)
local warnReload								= mod:NewCastAnnounce(386921, 2)
local warnAdd									= mod:NewCountAnnounce(386320, 3)

local specWarnEruption							= mod:NewSpecialWarningCount(388283, nil, nil, nil, 1, 2)
local specWarnTectonicStomp						= mod:NewSpecialWarningRun(385916, "Melee", nil, nil, 4, 2)
--local specWarnInfusedStrikesTaunt				= mod:NewSpecialWarningTaunt(361966, nil, nil, nil, 1, 2)
--local yellInfusedStrikes						= mod:NewYell(361966)
--local specWarnDominationBolt					= mod:NewSpecialWarningInterrupt(363607, "HasInterrupt", nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerEruptionCD							= mod:NewAITimer(35, 388283, nil, nil, nil, 2)
local timerShardsofStoneCD						= mod:NewAITimer(35, 388817, nil, nil, nil, 2)
local timerTectonicStompCD						= mod:NewAITimer(35, 385916, nil, nil, nil, 3)--Technically also aoe, but limited aoe range, so targeted aoe
local timerSummonSaboteurCD						= mod:NewCDTimer(15, 386320, nil, nil, nil, 1)
local timerReload								= mod:NewCastTimer(25, 386320, nil, nil, nil, 5)
--local timerDecaySprayCD							= mod:NewAITimer(35, 376811, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
mod:AddSetIconOption("SetIconOnAdd", 386320, true, 5, {8})

mod.vb.eruptionCount = 0
mod.vb.shardsCount = 0
mod.vb.addCount = 0

function mod:OnCombatStart(delay)
	self.vb.eruptionCount = 0
	self.vb.shardsCount = 0
	self.vb.addCount = 0
	timerEruptionCD:Start(1-delay)
	timerShardsofStoneCD:Start(1-delay)
	timerTectonicStompCD:Start(1-delay)
	timerSummonSaboteurCD:Start(15-delay)
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
	if spellId == 388283 then
		self.vb.eruptionCount = self.vb.eruptionCount + 1
		specWarnEruption:Show(self.vb.eruptionCount)
		specWarnEruption:Play("aesoon")
		timerEruptionCD:Start()
	elseif spellId == 388817 or spellId == 385657 then--388817 confirmed on heroic/normal, 385657 might be mythic/plus
		self.vb.shardsCount = self.vb.shardsCount + 1
		warnShardsofStone:Show(self.vb.shardsCount)
		timerShardsofStoneCD:Start()
	elseif spellId == 385916 then
		specWarnTectonicStomp:Show()
		specWarnTectonicStomp:Play("justrun")
		timerTectonicStompCD:Start()
	elseif spellId == 386921 then
		warnReload:Show()
		timerReload:Start()
	elseif spellId == 386530 then
		warnDragonkillerLance:Show()
	end
end

--[[
--Backup, in case spell summon event ever get disabled
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then
		self.vb.addCount = self.vb.addCount + 1
		warnAdd:Show(self.vb.addCount)
		timerSummonSaboteurCD:Start()
	end
end
--]]

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 362805 then
		self.vb.addCount = self.vb.addCount + 1
		warnAdd:Show(self.vb.addCount)
		timerSummonSaboteurCD:Start()
		if self.Options.SetIconOnAdd then
			self:ScanForMobs(args.destGUID, 2, 8, 1, nil, 12, "SetIconOnAdd")
		end
	end
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 361966 then

	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then

	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 194367 then--Dragonkiller Lance (CID may be wrong)
		timerReload:Stop()
	end
end

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]

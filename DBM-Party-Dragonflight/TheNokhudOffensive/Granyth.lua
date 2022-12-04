local mod	= DBM:NewMod(2498, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221203231852")
mod:SetCreatureID(186616)
mod:SetEncounterID(2637)
mod:SetUsedIcons(8)
mod:SetHotfixNoticeRev(20221029000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 388283 388817 385916 386921",
--	"SPELL_CAST_SUCCESS 386320",
	"SPELL_SUMMON 386747 386748 386320",
	"SPELL_AURA_APPLIED 387155",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 387155",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, fix spear creatureid?
--TODO, timers with longer logs that suck at lances
--TODO, announce 386490?
--[[
(ability.id = 388283 or ability.id = 388817 or ability.id = 385916 or ability.id = 386921 or ability.id = 386530 or ability.id = 385657) and type = "begincast"
 or ability.id = 386747 or ability.id = 386748 or ability.id = 386320
 or ability.id = 387155 and (type = "applydebuff" or type =  "removedebuff")
 or target.id = 194367 and type = "death"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnShardsofStone							= mod:NewCountAnnounce(388817, 3)
local warnLanced								= mod:NewTargetNoFilterAnnounce(387155, 1)
local warnReload								= mod:NewCastAnnounce(386921, 2)
local warnAdd									= mod:NewCountAnnounce(386320, 3)

local specWarnEruption							= mod:NewSpecialWarningCount(388283, nil, nil, nil, 1, 2)
local specWarnTectonicStomp						= mod:NewSpecialWarningRun(385916, "Melee", nil, nil, 4, 2)
--local specWarnInfusedStrikesTaunt				= mod:NewSpecialWarningTaunt(361966, nil, nil, nil, 1, 2)
--local yellInfusedStrikes						= mod:NewYell(361966)
--local specWarnDominationBolt					= mod:NewSpecialWarningInterrupt(363607, "HasInterrupt", nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerEruptionCD							= mod:NewCDTimer(35, 388283, nil, nil, nil, 2)
local timerShardsofStoneCD						= mod:NewCDTimer(13.3, 388817, nil, nil, nil, 2)
local timerTectonicStompCD						= mod:NewCDTimer(35, 385916, nil, nil, nil, 3)--Technically also aoe, but limited aoe range, so targeted aoe
local timerSummonSaboteurCD						= mod:NewNextCountTimer(14.9, 386320, nil, nil, nil, 1, nil, DBM_COMMON_L.MYTHIC_ICON)
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
	timerShardsofStoneCD:Start(10.6-delay)
	timerTectonicStompCD:Start(15.5-delay)
	timerEruptionCD:Start(28.8-delay)
	if self:IsMythic() then
		timerSummonSaboteurCD:Start(15-delay, 1)
	end
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
		specWarnEruption:Play("interruptsoon")
--		timerEruptionCD:Start()--In between times not known yet since doing fight correctly shouldn't see in betweens
	elseif spellId == 388817 then--388817 confirmed on mythic/heroic/normal, 385657 unused?
		self.vb.shardsCount = self.vb.shardsCount + 1
		warnShardsofStone:Show(self.vb.shardsCount)
		timerShardsofStoneCD:Start()
	elseif spellId == 385916 then
		specWarnTectonicStomp:Show()
		specWarnTectonicStomp:Play("justrun")
--		timerTectonicStompCD:Start()--In between times not known yet since doing fight correctly shouldn't see in betweens
	elseif spellId == 386921 then
		warnReload:Show()
		timerReload:Start()
	end
end

--[[
--Backup, in case spell summon event ever get disabled
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 386747 or spellId == 386748 or spellId == 386320 then--386747 Lance 1, 386748 Lance 2, 386320 Lance 3
		self.vb.addCount = self.vb.addCount + 1
		warnAdd:Show(self.vb.addCount)
		timerSummonSaboteurCD:Start(nil, self.vb.addCount+1)
	end
end
--]]

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 386747 or spellId == 386748 or spellId == 386320 then--386747 Lance 1, 386748 Lance 2, 386320 Lance 3
		self.vb.addCount = self.vb.addCount + 1
		warnAdd:Show(self.vb.addCount)
		timerSummonSaboteurCD:Start(nil, self.vb.addCount+1)
		if self.Options.SetIconOnAdd then--195821, 195820, 195580
			self:ScanForMobs(args.destGUID, 2, 8, 1, nil, 12, "SetIconOnAdd")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 387155 then
		warnLanced:Show(args.destName)
		timerEruptionCD:Stop()
		timerShardsofStoneCD:Stop()
		timerTectonicStompCD:Stop()
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then--Lanced!
		--Resets these timers
		timerShardsofStoneCD:Start(10)
		timerTectonicStompCD:Start(15.3)
		timerEruptionCD:Start(28.6)
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

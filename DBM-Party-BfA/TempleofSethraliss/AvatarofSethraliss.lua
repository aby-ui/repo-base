local mod	= DBM:NewMod(2145, "DBM-Party-BfA", 6, 1001)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17674 $"):sub(12, -3))
mod:SetCreatureID(133392)
mod:SetEncounterID(2127)
mod:SetZone()
mod:SetBossHPInfoToHighest()
mod.noBossDeathKill = true

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 268008 269686 268024",
	"SPELL_AURA_REMOVED 268008 269686",
	"SPELL_CAST_START 268061",
	"SPELL_CAST_SUCCESS 273677 269688"
)

--TODO, work on Cds if adds long enough for more than 1 cast each wave
local warnTaint						= mod:NewSpellAnnounce(273677, 2)
local warnPlague					= mod:NewTargetAnnounce(269686, 2)
local warnPulse						= mod:NewSpellAnnounce(268024, 3)

local specWarnChainLightning		= mod:NewSpecialWarningInterrupt(268061, nil, nil, nil, 1, 2)
local specWarnRainofToads			= mod:NewSpecialWarningSpell(269688, nil, nil, nil, 2, 2)
local specWarnPlague				= mod:NewSpecialWarningDispel(269686, "RemoveDisease", nil, nil, 1, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(238028, nil, nil, nil, 1, 2)

local timerRainofToadsCD			= mod:NewAITimer(10, 269688, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerPlague					= mod:NewTargetTimer(10, 269686, nil, "RemoveDisease", nil, 5, nil, DBM_CORE_DISEASE_ICON)
local timerPulse					= mod:NewAITimer(10, 268024, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)

--mod:AddRangeFrameOption(5, 194966)
mod:AddNamePlateOption("NPAuraOnSnakeCharm", 268008)

function mod:OnCombatStart(delay)
	timerPulse:Start(1-delay)
	timerRainofToadsCD:Start(1-delay)
	if self.Options.NPAuraOnSnakeCharm then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.NPAuraOnSnakeCharm then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 268008 then
		if self.Options.NPAuraOnSnakeCharm then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 15)
		end
	elseif spellId == 269686 then
		specWarnPlague:Show(args.destName)
		specWarnPlague:Play("helpdispel")
		timerPlague:Start(args.destName)
	elseif spellId == 268024 and self:AntiSpam(3, 1) then
		warnPulse:Show()
		timerPulse:Start()
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 268008 then
		if self.Options.NPAuraOnSnakeCharm then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 269686 then
		timerPlague:Stop(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 268061 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnChainLightning:Show(args.sourceName)
		specWarnChainLightning:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 273677 and self:AntiSpam(3, 2) then
		warnTaint:Show()
	elseif spellId == 269688 then
		specWarnRainofToads:Show()
		specWarnRainofToads:Play("specialsoon")
		timerRainofToadsCD:Start()
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228007 and destGUID == UnitGUID("player") and self:AntiSpam(2, 3) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 124396 then
		
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257939 then
	end
end
--]]

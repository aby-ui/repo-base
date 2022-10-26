local mod	= DBM:NewMod(2497, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220820005632")
mod:SetCreatureID(186615)
mod:SetEncounterID(2636)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 384316 384620 384686",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 384686"
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, timer updates with longer logs
--[[
(ability.id = 384316 or ability.id = 384620 or ability.id = 384686) and type = "begincast"
--]]
local warnElectricalStorm						= mod:NewSpellAnnounce(384620, 3)
local warnEnergySurge							= mod:NewSpellAnnounce(384686, 3, nil, "Tank|Healer")

local specWarnLightingStrike					= mod:NewSpecialWarningDodge(384316, nil, nil, nil, 2, 2)
--local yellInfusedStrikes						= mod:NewYell(361966)
local specWarnEnergySurge						= mod:NewSpecialWarningDispel(384686, "MagicDispeller", nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerLightingStrikeCD						= mod:NewAITimer(35, 384316, nil, nil, nil, 3)
local timerElectricStormCD						= mod:NewAITimer(35, 384620, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)
local timerEnergySurgeCD						= mod:NewAITimer(35, 384686, nil, "Tank|MagicDispeller", nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.MAGIC_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(382628, false)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OnCombatStart(delay)
	timerLightingStrikeCD:Start(1-delay)
	timerElectricStormCD:Start(1-delay)
	timerEnergySurgeCD:Start(1-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(382628))
		DBM.InfoFrame:Show(5, "playerdebuffremaining", 382628)
	end
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 384316 then
		specWarnLightingStrike:Show()
		specWarnLightingStrike:Play("watchstep")
		timerLightingStrikeCD:Start()
	elseif spellId == 384620 then
		warnElectricalStorm:Show()
		timerElectricStormCD:Start()
	elseif spellId == 384686 then
		warnEnergySurge:Show()
		timerEnergySurgeCD:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then

	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 384686 and args:IsDestTypeHostile() then
		specWarnEnergySurge:Show(args.destName)
		specWarnEnergySurge:Play("dispelboss")
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

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]

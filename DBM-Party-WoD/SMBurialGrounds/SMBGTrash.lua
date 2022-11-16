local mod	= DBM:NewMod("SMBGTrash", "DBM-Party-WoD", 6)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221115231757")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 152818 152964 153395"
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525"
)

local warnVoidPulse							= mod:NewSpellAnnounce(152964, 3)
local warnBodySlam							= mod:NewCastAnnounce(153395, 3, nil, nil, "Tank")

--local specWarnConcentrateAnima			= mod:NewSpecialWarningMoveAway(310780, nil, nil, nil, 1, 2)
--local yellConcentrateAnima				= mod:NewYell(339525)
--local yellConcentrateAnimaFades			= mod:NewShortFadesYell(339525)
--local specWarnSharedSuffering				= mod:NewSpecialWarningYou(339607, nil, nil, nil, 1, 2)
local specWarnShadowMend					= mod:NewSpecialWarningInterrupt(152818, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 152818 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowMend:Show(args.sourceName)
		specWarnShadowMend:Play("kickcast")
	elseif spellId == 152964 and self:AntiSpam(3, 4) then
		warnVoidPulse:Show()
	elseif spellId == 153395 and self:AntiSpam(5, 4) then
		warnBodySlam:Show()
	end
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 339525 then

	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]

local mod	= DBM:NewMod("HallsofInfusionTrash", "DBM-Party-Dragonflight", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205015333")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 390290 374080 375351 375348 375327 375384 374563",
	"SPELL_AURA_APPLIED 374724",
	"SPELL_AURA_APPLIED_DOSE 374389"
--	"SPELL_AURA_REMOVED"
)

local warnBlastingGust						= mod:NewCastAnnounce(374080, 4)
local warnMoltenSubduction					= mod:NewTargetNoFilterAnnounce(374724, 3)

local specWarnGulpSwogToxin					= mod:NewSpecialWarningStack(374389, nil, 8, nil, nil, 1, 6)
local specWarnFlashFlood					= mod:NewSpecialWarningSpell(390290, nil, nil, nil, 3, 2)
local specWarnOceanicBreath					= mod:NewSpecialWarningDodge(375351, nil, nil, nil, 2, 2)
local specWarnGustingBreath					= mod:NewSpecialWarningDodge(375348, nil, nil, nil, 2, 2)
local specWarnTectonicBreath				= mod:NewSpecialWarningDodge(375327, nil, nil, nil, 2, 2)
local specWarnRumblingEarth					= mod:NewSpecialWarningDodge(375384, nil, nil, nil, 2, 2)
local specWarnDazzle						= mod:NewSpecialWarningDodge(374563, nil, nil, nil, 2, 2)
--local yellConcentrateAnima					= mod:NewYell(339525)
--local yellConcentrateAnimaFades				= mod:NewShortFadesYell(339525)
local specWarnBlastingGust					= mod:NewSpecialWarningInterrupt(374080, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 390290 and self:AntiSpam(3, 6) then
		specWarnFlashFlood:Show()
		specWarnFlashFlood:Play("carefly")
	elseif spellId == 374080 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnBlastingGust:Show(args.sourceName)
			specWarnBlastingGust:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnBlastingGust:Show()
		end
	elseif spellId == 375351 and self:AntiSpam(3, 2) then
		specWarnOceanicBreath:Show()
		specWarnOceanicBreath:Play("breathsoon")
	elseif spellId == 375348 and self:AntiSpam(3, 2) then
		specWarnGustingBreath:Show()
		specWarnGustingBreath:Play("breathsoon")
	elseif spellId == 375327 and self:AntiSpam(3, 2) then
		specWarnTectonicBreath:Show()
		specWarnTectonicBreath:Play("breathsoon")
	elseif spellId == 375384 and self:AntiSpam(3, 2) then
		specWarnRumblingEarth:Show()
		specWarnRumblingEarth:Play("watchstep")
	elseif spellId == 374563 and self:AntiSpam(3, 2) then
		specWarnDazzle:Show()
		specWarnDazzle:Play("shockwave")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 374389 and args:IsPlayer()then
		local amount = args.amount or 1
		if amount >= 8 and self:AntiSpam(3, 5) then
			specWarnGulpSwogToxin:Show(amount)
			specWarnGulpSwogToxin:Play("stackhigh")
		end
	elseif spellId == 374724 then
		warnMoltenSubduction:Show(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]

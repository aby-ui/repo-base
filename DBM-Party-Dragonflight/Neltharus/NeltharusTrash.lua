local mod	= DBM:NewMod("NeltharusTrash", "DBM-Party-Dragonflight", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205015333")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 382708 376186 372566 372311 372201 381663 378282",
	"SPELL_CAST_SUCCESS 378827",
	"SPELL_AURA_APPLIED 384161 372543 371875"
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525"
)


local warnBoldAmbush						= mod:NewTargetNoFilterAnnounce(372566, 3)

local specWarnTempest						= mod:NewSpecialWarningSpell(381663, nil, nil, nil, 2, 13)--pushbackincoming
local specWarnVolcanicGuard					= mod:NewSpecialWarningDodge(382708, nil, nil, nil, 1, 2)
local specWarnEruptiveCrash					= mod:NewSpecialWarningDodge(376186, nil, nil, nil, 2, 2)
local specWarnMagmaFist						= mod:NewSpecialWarningDodge(372311, nil, nil, nil, 2, 2)
local specWarnExplosiveConcoction			= mod:NewSpecialWarningDodge(378827, nil, nil, nil, 2, 2)
local specWarnScorchingBreath				= mod:NewSpecialWarningDodge(372201, nil, nil, nil, 2, 2)
local specWarnScorchingFusillade			= mod:NewSpecialWarningMoveAway(372543, nil, nil, nil, 1, 2)
local yellScorchingFusillade				= mod:NewYell(372543)
local specWarnMoteofCombustion				= mod:NewSpecialWarningMoveAway(384161, nil, nil, nil, 1, 2)
local yellMoteofCombustion					= mod:NewYell(384161)
local specWarnBoldAmbush					= mod:NewSpecialWarningYou(372566, nil, nil, nil, 1, 2)
local yellBoldAmbush						= mod:NewYell(372566)
local specWarnFiredUp						= mod:NewSpecialWarningDispel(371875, "RemoveEnrage", nil, nil, 2, 2)
local specWarnMoltenCore					= mod:NewSpecialWarningInterrupt(378282, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:AmbushTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		if self:AntiSpam(4, 5) then
			specWarnBoldAmbush:Show()
			specWarnBoldAmbush:Play("targetyou")
		end
		yellBoldAmbush:Yell()
	else
		warnBoldAmbush:Show(targetname)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 382708 and self:AntiSpam(3, 2) then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnVolcanicGuard:Show()
			specWarnVolcanicGuard:Play("shockwave")
		end
	elseif spellId == 376186 and self:AntiSpam(3, 2) then
		specWarnEruptiveCrash:Show()
		specWarnEruptiveCrash:Play("watchstep")
	elseif spellId == 372311 and self:IsValidWarning(args.sourceGUID) and self:AntiSpam(3, 2) then
		specWarnMagmaFist:Show()
		specWarnMagmaFist:Play("shockwave")
	elseif spellId == 372201 and self:AntiSpam(3, 2) then
		specWarnScorchingBreath:Show()
		specWarnScorchingBreath:Play("shockwave")
	elseif spellId == 381663 and self:AntiSpam(3, 6) then
		specWarnTempest:Show()
		specWarnTempest:Play("pushbackincoming")
	elseif spellId == 372566 then
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "AmbushTarget", 0.1, 8)
	elseif spellId == 378282 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMoltenCore:Show(args.sourceName)
		specWarnMoltenCore:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 378827 and self:AntiSpam(3, 2) then
		specWarnExplosiveConcoction:Show()
		specWarnExplosiveConcoction:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 384161 then
		if args:IsPlayer() then
			specWarnMoteofCombustion:Show()
			specWarnMoteofCombustion:Play("runout")
			yellMoteofCombustion:Yell()
		end
	elseif spellId == 372543 then
		if args:IsPlayer() then
			specWarnScorchingFusillade:Show()
			specWarnScorchingFusillade:Play("scatter")
			yellScorchingFusillade:Yell()
		end
	elseif spellId == 371875 and self:AntiSpam(3, 5) then
		specWarnFiredUp:Show(args.destName)
		specWarnFiredUp:Play("enrage")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]

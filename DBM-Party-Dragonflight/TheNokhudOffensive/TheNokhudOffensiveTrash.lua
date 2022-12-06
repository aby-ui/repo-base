local mod	= DBM:NewMod("TheNokhudOffensiveTrash", "DBM-Party-Dragonflight", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205064214")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 387145 386024 387127 384336 387629 387614 387411 382233 373395",
	"SPELL_AURA_APPLIED 395035"
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525"
)

--TODO, https://www.wowhead.com/beta/spell=381683/swift-stab ?
--TODO, target scan https://www.wowhead.com/beta/spell=387127/chain-lightning ?
--Lady's Trash, minus bottled anima, which will need a unit event to detect it looks like
--local warnConcentrateAnima					= mod:NewTargetNoFilterAnnounce(339525, 3)
local warnTotemicOverload					= mod:NewCastAnnounce(387145, 4)
local warnChantoftheDead					= mod:NewCastAnnounce(387614, 3)
local warnBloodcurdlingShout				= mod:NewCastAnnounce(373395, 3)

local specWarnShatterSoul					= mod:NewSpecialWarningMoveTo(395035, nil, nil, nil, 1, 2)
local specWarnChainLightning				= mod:NewSpecialWarningMoveAway(387127, nil, nil, nil, 1, 2)
local yellChainLightning					= mod:NewYell(387127)
local specWarnWarStomp						= mod:NewSpecialWarningDodge(384336, nil, nil, nil, 2, 2)
local specWarnBroadStomp					= mod:NewSpecialWarningDodge(382233, nil, nil, nil, 2, 2)
local specWarnRottingWind					= mod:NewSpecialWarningDodge(387629, nil, nil, nil, 2, 2)
--local yellConcentrateAnimaFades				= mod:NewShortFadesYell(339525)
--local specWarnSharedSuffering				= mod:NewSpecialWarningYou(339607, nil, nil, nil, 1, 2)
local specWarnTempest						= mod:NewSpecialWarningInterrupt(386024, "HasInterrupt", nil, nil, 1, 2)
local specWarnDeathBoltVolley				= mod:NewSpecialWarningInterrupt(387411, "HasInterrupt", nil, nil, 1, 2)
local specWarnBloodcurdlingShout			= mod:NewSpecialWarningInterrupt(373395, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:CLTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		if self:AntiSpam(4, 5) then
			specWarnChainLightning:Show()
			specWarnChainLightning:Play("runout")
		end
		yellChainLightning:Yell()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 387145 and self:AntiSpam(5, 4) then
		warnTotemicOverload:Show()
	elseif spellId == 386024 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnTempest:Show(args.sourceName)
		specWarnTempest:Play("kickcast")
	elseif spellId == 387411 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnDeathBoltVolley:Show(args.sourceName)
		specWarnDeathBoltVolley:Play("kickcast")
	elseif spellId == 373395 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnBloodcurdlingShout:Show(args.sourceName)
			specWarnBloodcurdlingShout:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnBloodcurdlingShout:Show()
		end
	elseif spellId == 387127 then
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "CLTarget", 0.1, 8)
	elseif spellId == 384336 and self:AntiSpam(3, 2) then
		specWarnWarStomp:Show()
		specWarnWarStomp:Play("watchstep")
	elseif spellId == 387629 and self:IsValidWarning(args.sourceGUID) and self:AntiSpam(3, 2) then
		specWarnRottingWind:Show()
		specWarnRottingWind:Play("shockwave")
	elseif spellId == 382233 and self:AntiSpam(3, 2) then
		specWarnBroadStomp:Show()
		specWarnBroadStomp:Play("shockwave")
	elseif spellId == 387614 and self:AntiSpam(5, 6) then
		warnChantoftheDead:Show()
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 395035 and args:IsPlayer() then
		specWarnShatterSoul:Show(L.Soul)
		specWarnShatterSoul:Play("targetyou")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]

local mod	= DBM:NewMod(2416, "DBM-Party-Shadowlands", 5, 1186)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(162058)
mod:SetEncounterID(2356)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 334485",
	"SPELL_CAST_START 324205",
	"SPELL_CAST_SUCCESS 324148"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
ability.id = 324205 and type = "begincast"
 or ability.id = 324148 and type = "cast"
 or ability.id = 334485 and (type = "applybuff" or type = "removebuff" or type = "removedebuff" or type = "applydebuff")
 --]]
--local warnBlackPowder				= mod:NewTargetAnnounce(257314, 4)

--local specWarnDarkStride			= mod:NewSpecialWarningTaunt(324148, nil, nil, nil, 1, 2)
local specWarnBlindingFlash			= mod:NewSpecialWarningDodge(324205, nil, nil, nil, 2, 2)
local specWarnRecharge				= mod:NewSpecialWarningDodge(334485, nil, nil, nil, 2, 2)
--local specWarnGTFO					= mod:NewSpecialWarningGTFO(257274, nil, nil, nil, 1, 8)

local timerDarkStrideCD				= mod:NewCDTimer(17, 324148, nil, nil, nil, 3, nil, DBM_COMMON_L.TANK_ICON)
local timerBlindingFlashCD			= mod:NewCDTimer(21.8, 324205, nil, nil, nil, 3)
local timerRechargeCD				= mod:NewCDTimer(15.8, 334485, nil, nil, nil, 6)

function mod:OnCombatStart(delay)
	timerDarkStrideCD:Start(10.1-delay)
	timerBlindingFlashCD:Start(15.7-delay)
	timerRechargeCD:Start(44.9-delay)--SUCCESS/APPLIED
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 324205 then
		specWarnBlindingFlash:Show()
		specWarnBlindingFlash:Play("shockwave")
		timerBlindingFlashCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 324148 then
--		specWarnDarkStride:Show(args.destName or "Unknown")
--		specWarnDarkStride:Play("tauntboss")
		timerDarkStrideCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 334485 then
		specWarnRecharge:Show()
		specWarnRecharge:Play("watchstep")
--		timerRechargeCD:Start()--Need more data, longer pull
		timerDarkStrideCD:Stop()
		timerBlindingFlashCD:Stop()
		timerDarkStrideCD:Start(12.1)
		timerBlindingFlashCD:Start(14.7)
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 309991 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257453  then

	end
end
--]]

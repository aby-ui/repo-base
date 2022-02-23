local mod	= DBM:NewMod(1467, "DBM-Party-Legion", 10, 707)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217011830")
mod:SetCreatureID(95885)
mod:SetEncounterID(1815)
mod:DisableESCombatDetection()--Remove if blizz fixes trash firing ENCOUNTER_START

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 191941",
	"SPELL_AURA_REMOVED 191941",
	"SPELL_CAST_START 204151 191823 191941 202913",
	"SPELL_DAMAGE 202919",
	"SPELL_MISSED 202919"
)

--TODO, timers possibly. Right now it's up in hair and possibly all health based. No timer matched between multiple pulls
--[[
			["SPELL_CAST_START"] = {
				["191941-Darkstrikes"] = "pull:21.6",
				["204151-Darkstrikes"] = "pull:47.0, 23.2",
			},
--]]
local specWarnDarkStrikes			= mod:NewSpecialWarningDefensive(204151, "Tank", nil, nil, 3, 2)
local specWarnFuriousBlast			= mod:NewSpecialWarningInterrupt(191823, "HasInterrupt", nil, nil, 1, 2)
local specWarnFelMortar				= mod:NewSpecialWarningDodge(202913, nil, nil, nil, 2, 2)
local specWarnFelMortarGTFO			= mod:NewSpecialWarningGTFO(202919, nil, nil, nil, 1, 8)

local timerDarkStrikes				= mod:NewBuffActiveTimer(11, 191941, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--tooltip says 15 but every log was 10-11

--function mod:OnCombatStart(delay)

--end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 191941 then
		timerDarkStrikes:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 191941 then
		timerDarkStrikes:Cancel()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if (spellId == 204151 or spellId == 191941) and self:AntiSpam(3, 1) then--Why two Ids?
		specWarnDarkStrikes:Show()
		specWarnDarkStrikes:Play("defensive")
	elseif spellId == 191823 then
		specWarnFuriousBlast:Show(args.sourceName)
		specWarnFuriousBlast:Play("kickcast")
	elseif spellId == 202913 then
		specWarnFelMortar:Show()
		specWarnFelMortar:Play("watchstep")
	end
end

do
	local playerGUID = UnitGUID("player")
	function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
		if spellId == 202919 and destGUID == playerGUID and self:AntiSpam(2, 2) then
			specWarnFelMortarGTFO:Show()
			specWarnFelMortarGTFO:Play("watchfeet")
		end
	end
	mod.SPELL_MISSED = mod.SPELL_DAMAGE
end

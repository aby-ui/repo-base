local mod	= DBM:NewMod(1769, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(108829)
mod:SetEncounterID(1953)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 217235 217249 217344",
	"SPELL_AURA_APPLIED 217352"
)

--TODO, Figure out if any of the other spells besides spout need special warnings. Maybe check if player has buff or not to get out of water
local warnRendingWhirl			= mod:NewCastAnnounce(217235, 2)
local warnElectrify				= mod:NewCastAnnounce(217344, 2)

local specWarnMassiveSpout		= mod:NewSpecialWarningDodge(217249, nil, nil, nil, 2, 2)
local specWarnElectrifyDispel	= mod:NewSpecialWarningDispel(217352, "Healer", nil, nil, 2, 2)

local timerRendingWhirlCD		= mod:NewCDTimer(48.5, 217235, nil, nil, nil, 2)
local timerElectrifyCD			= mod:NewCDTimer(33, 217344, nil, nil, nil, 2)
local timerMassiveSpoutCD		= mod:NewCDTimer(66, 217249, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)

--mod:AddReadyCheckOption(37460, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 217235 then
		warnRendingWhirl:Show()
		timerRendingWhirlCD:Start()
	elseif spellId == 217249 then
		specWarnMassiveSpout:Show()
		specWarnMassiveSpout:Play("watchwave")
		timerMassiveSpoutCD:Start()
	elseif spellId == 217344 then
		warnElectrify:Show()
		timerElectrifyCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 217352 then
		specWarnElectrifyDispel:CombinedShow(0.5, args.destName)
		if self:AntiSpam(3, 1) then
			specWarnElectrifyDispel:Play("helpdispel")
		end
	end
end

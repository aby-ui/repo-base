local mod	= DBM:NewMod(1469, "DBM-Party-Legion", 10, 707)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217011830")
mod:SetCreatureID(95887)
mod:SetEncounterID(1817)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 193443 194942",
	"SPELL_PERIODIC_DAMAGE 194945",
	"SPELL_PERIODIC_MISSED 194945"
)

--TODO, maybe voice for mirrors to bounce beam back into boss? But how do you say this short
local warnGaze						= mod:NewSpellAnnounce(194942, 2)

local specWarnFocused				= mod:NewSpecialWarningSpell(194289, nil, nil, nil, 2, 2)
local specWarnGazeGTFO				= mod:NewSpecialWarningGTFO(194945, nil, nil, nil, 1, 8)

local timerGazeCD					= mod:NewCDTimer(19.4, 194942, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerGazeCD:Start(11.8-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 193443 then--194289 backup if energize stops working.
		timerGazeCD:Stop()
		specWarnFocused:Show()
		specWarnFocused:Play("specialsoon")
	elseif spellId == 194942 then
		warnGaze:Show()
		timerGazeCD:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 194945 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnGazeGTFO:Show()
		specWarnGazeGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

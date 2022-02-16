local mod	= DBM:NewMod(1468, "DBM-Party-Legion", 10, 707)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(95886)
mod:SetEncounterID(1816)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 192522 192631 192621",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED"
)

local warnVolcano					= mod:NewSpellAnnounce(192621, 3, nil, nil, nil, nil, nil, 2)

local specWarnLavaWreath			= mod:NewSpecialWarningDodge(192631, nil, nil, nil, 2, 2)
local specWarnFissure				= mod:NewSpecialWarningSpell(192522, "Tank", nil, nil, 1, 2)--Not dogable, just so we aim it correctly

local timerVolcanoCD				= mod:NewCDTimer(20, 192621, nil, nil, nil, 1)--20-22 unless delayed by brittle
local timerLavaWreathCD				= mod:NewCDTimer(42.5, 192631, nil, nil, nil, 3)--42 unless delayed by brittle
local timerFissureCD				= mod:NewCDTimer(42.5, 192522, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--42 unless delayed by brittle

function mod:OnCombatStart(delay)
	timerVolcanoCD:Start(10-delay)
	timerLavaWreathCD:Start(25-delay)
	timerFissureCD:Start(40-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 192522 then
		specWarnFissure:Show()
		specWarnFissure:Play("shockwave")
		timerFissureCD:Start()
	elseif spellId == 192631 then
		specWarnLavaWreath:Show()
		specWarnLavaWreath:Play("watchstep")
		timerLavaWreathCD:Start()
	elseif spellId == 192621 then
		warnVolcano:Show()
		warnVolcano:Play("mobsoon")
		timerVolcanoCD:Start()
	end
end

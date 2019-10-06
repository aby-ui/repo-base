local mod	= DBM:NewMod(117, "DBM-Party-Cataclysm", 5, 69)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(44577)
mod:SetEncounterID(1052)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 83445 91263",
	"SPELL_CAST_SUCCESS 83113"
)

local warnShockwave 	= mod:NewCastAnnounce(83445, 3)
local warnIntentions	= mod:NewTargetAnnounce(83113, 3)

local specWarnDetonate	= mod:NewSpecialWarningDodge(91263, nil, nil, nil, 2, 2)

local timerShockwaveCD	= mod:NewCDTimer(36, 83445, nil, nil, nil, 2)
local timerShockwave	= mod:NewCastTimer(5, 83445)
local timerIntentions	= mod:NewNextTimer(25.4, 83113, nil, nil, nil, 3)-- First one seems health based, after that it's every 25-26

function mod:OnCombatStart(delay)
	timerShockwaveCD:Start(18-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 83445 then
		warnShockwave:Show()
		timerShockwave:Start()
		timerShockwaveCD:Start()
	elseif spellId == 91263 and self:AntiSpam(5) then
		specWarnDetonate:Show()
		specWarnDetonate:Play("watchstep")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 83113 then
		warnIntentions:Show(args.destName)
		timerIntentions:Start()
	end
end
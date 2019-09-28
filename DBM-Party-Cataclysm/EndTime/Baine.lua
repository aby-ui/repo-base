local mod	= DBM:NewMod(340, "DBM-Party-Cataclysm", 12, 184)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54431)
mod:SetEncounterID(1881)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 101840",
	"SPELL_AURA_APPLIED_DOSE 101840",
	"SPELL_CAST_SUCCESS 101625",
	"SPELL_SUMMON 101614"
)
mod.onlyHeroic = true

-- Just adding all I can find, no idea how usefull they will be on Live :)

local warnTotem			= mod:NewSpellAnnounce(101614, 3)
local warnMoltenBlast	= mod:NewTargetAnnounce(101840, 3)
local warnPulverize		= mod:NewSpellAnnounce(101625, 3)

local timerTotem		= mod:NewNextTimer(25, 101614, nil, nil, nil, 5)
local timerPulverize	= mod:NewNextTimer(40, 101625, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerTotem:Start(10-delay)
	timerPulverize:Start(30-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 101840 and self:AntiSpam(3, 1) then
		warnMoltenBlast:Show(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 101625 and self:AntiSpam(3, 2) then
		warnPulverize:Show()
		timerPulverize:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 101614 then
		warnTotem:Show()
		timerTotem:Start()
	end
end
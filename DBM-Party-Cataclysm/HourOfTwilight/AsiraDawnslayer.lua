local mod	= DBM:NewMod(342, "DBM-Party-Cataclysm", 14, 186)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54968)
mod:SetEncounterID(1340)
mod:SetZone()

mod:RegisterCombat("yell", L.Pull)
mod:SetMinCombatTime(15)	-- need to do another run to confirm it works

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 103558 103419",
	"SPELL_SUMMON 108374"
)
mod.onlyHeroic = true

local warnSmokeBomb		= mod:NewSpellAnnounce(103558, 2)
local warnBladeBarrier	= mod:NewSpellAnnounce(103419, 3)
local warnFireTotem		= mod:NewSpellAnnounce(108374, 1)

local timerSmokeBomb	= mod:NewNextTimer(24, 103558, nil, nil, nil, 3)
local timerFireTotem	= mod:NewNextTimer(23, 108374, nil, nil, nil, 5)

function mod:OnCombatStart(delay)
	timerSmokeBomb:Start(16-delay)
	timerFireTotem:Start(25-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 103558 then
		warnSmokeBomb:Show()
		timerSmokeBomb:Start()
	elseif args.spellId == 103419 then
		warnBladeBarrier:Show()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 108374 then
		warnFireTotem:Show()
		timerFireTotem:Start()
	end
end
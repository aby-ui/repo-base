local mod	= DBM:NewMod(89, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(47162)
mod:SetEncounterID(1064)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 87859 87861 88009",
	"SPELL_CAST_SUCCESS 59304"
)

local warnFistsFlame		= mod:NewSpellAnnounce(87859, 3, nil, "Tank|Healer")
local warnFistsFrost		= mod:NewSpellAnnounce(87861, 3, nil, "Tank|Healer")
local warnArcanePower		= mod:NewSpellAnnounce(88009, 3)
local warnSpiritStrike		= mod:NewSpellAnnounce(59304, 3)

local timerFistsFlame		= mod:NewBuffActiveTimer(10, 87859, nil, "Tank|Healer", nil, 5)
local timerFistsFrost		= mod:NewBuffActiveTimer(10, 87861, nil, "Tank|Healer", nil, 5)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 87859 and args.destName == args.sourceName then
		warnFistsFlame:Show()
		timerFistsFlame:Start()
	elseif args.spellId == 87861 and args.destName == args.sourceName then
		warnFistsFrost:Show()
		timerFistsFrost:Start()
	elseif args.spellId == 88009 then
		warnArcanePower:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 59304 then
		warnSpiritStrike:Show()
	end
end
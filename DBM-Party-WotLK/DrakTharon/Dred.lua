local mod	= DBM:NewMod(590, "DBM-Party-WotLK", 4, 273)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(27483)
mod:SetEncounterID(373, 374, 1977)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 22686 27483",
	"SPELL_AURA_APPLIED 48920 48873 48878"
)

local warningSlash	= mod:NewSpellAnnounce(48873, 3)
local warningBite	= mod:NewTargetNoFilterAnnounce(48920, 2, nil, "Healer")
local warningFear	= mod:NewSpellAnnounce(22686, 1)

local timerFearCD	= mod:NewCDTimer(15, 22686, nil, nil, nil, 2)  -- cooldown ??
local timerSlashCD	= mod:NewCDTimer(18, 48873, nil, "Tank|Healer", nil, 5)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 22686 and args.sourceGUID == 27483 then
		warningFear:Show()
		timerFearCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 48920 then
		warningBite:Show(args.destName)
	elseif args.spellId == 48873 then
		warningSlash:Show()
		timerSlashCD:Start()
	elseif args.spellId == 48878 then
		warningSlash:Show()
		timerSlashCD:Start()
	end
end
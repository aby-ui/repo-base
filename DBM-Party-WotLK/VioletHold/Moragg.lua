local mod	= DBM:NewMod(627, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29316)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 54396"
)

local warningLink 	= mod:NewTargetNoFilterAnnounce(54396, 2)

local timerLink		= mod:NewTargetTimer(12, 54396, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerLinkCD	= mod:NewCDTimer(45, 54396, nil, nil, nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 54396 then
		warningLink:Show(args.destName)
		timerLink:Start(args.destName)
		timerLinkCD:Cancel()
		timerLinkCD:Start()
	end
end
local mod	= DBM:NewMod(612, "DBM-Party-WotLK", 3, 279)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(26530)
mod:SetEncounterID(294, 298, 2004)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 58845 52709",
	"SPELL_AURA_REMOVED 58845",
	"SPELL_SUMMON 52451"
)

local warningCurse	= mod:NewTargetNoFilterAnnounce(58845, 2, nil, "RemoveCurse", 2)
local warningSteal	= mod:NewTargetNoFilterAnnounce(52709, 2)
local warningGhoul	= mod:NewSpellAnnounce(52451, 3)

local timerGhoulCD	= mod:NewCDTimer(20, 52451, nil, nil, nil, 1)
local timerCurse	= mod:NewTargetTimer(30, 58845, nil, "RemoveCurse", nil, 5, nil, DBM_CORE_CURSE_ICON)

function mod:SPELL_SUMMON(args)
	if args.spellId == 52451 then
		warningGhoul:Show()
		timerGhoulCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 58845 then
		warningCurse:Show(args.destName)
		timerCurse:Start(args.destName)
	elseif args.spellId == 52709 then
		warningSteal:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 58845 then
		timerCurse:Stop(args.destName)
	end
end

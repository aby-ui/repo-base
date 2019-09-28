local mod	= DBM:NewMod(621, "DBM-Party-WotLK", 8, 281)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(26723)
mod:SetEncounterID(526, 527, 2011)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 50997 8599 48179",
	"SPELL_AURA_REMOVED 50997"
)

local warningChains		= mod:NewTargetAnnounce(50997, 4)
local warningNova		= mod:NewSpellAnnounce(48179, 3)
local warningEnrage		= mod:NewSpellAnnounce(8599, 3, nil, "Tank|Healer", 2)

local timerChains		= mod:NewTargetTimer(10, 50997, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerChainsCD		= mod:NewCDTimer(25, 50997, nil, nil, nil, 3)
local timerNovaCD		= mod:NewCDTimer(25, 48179, nil, nil, nil, 2)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 50997 then
		warningChains:Show(args.destName)
		timerChains:Start(args.destName)
		timerChainsCD:Start()
	elseif args.spellId == 8599 then
		warningEnrage:Show()
	elseif args.spellId == 48179 then
		warningNova:Show()
		timerNovaCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 50997 then
		timerChains:Cancel()
	end
end
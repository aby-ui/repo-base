local mod	= DBM:NewMod(128, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39731)
mod:SetEncounterID(1074)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 76043 80968",
	"SPELL_CAST_START 75790"
)

local warnWither		= mod:NewTargetNoFilterAnnounce(76043, 3, nil, "Healer", 2)
local warnConsume		= mod:NewTargetNoFilterAnnounce(80968, 3)
local warnRampant		= mod:NewSpellAnnounce(75790, 4)

local timerWither		= mod:NewTargetTimer(10, 76043, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerWitherCD		= mod:NewCDTimer(18, 76043, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON)
local timerConsume		= mod:NewTargetTimer(4, 80968, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON)
local timerConsumeCD	= mod:NewCDTimer(15, 80968, nil, nil, nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 76043 then
		warnWither:Show(args.destName)
		timerWither:Start(args.destName)
		timerWitherCD:Start()
	elseif args.spellId == 80968 then
		warnConsume:Show(args.destName)
		timerConsume:Start(args.destName)
		timerConsumeCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 75790 then
		warnRampant:Show()
	end
end
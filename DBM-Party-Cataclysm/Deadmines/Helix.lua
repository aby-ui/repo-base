local mod	= DBM:NewMod(90, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(47296, 47297)
mod:SetEncounterID(1065)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 88352",
	"SPELL_CAST_SUCCESS 59304"
)

local warnChestBomb			= mod:NewTargetNoFilterAnnounce(88352, 4)
local warnSpiritStrike		= mod:NewSpellAnnounce(59304, 3)

local specWarnChestBomb		= mod:NewSpecialWarningMoveAway(88352, nil, nil, nil, 1, 2)

local timerChestBomb		= mod:NewTargetTimer(10, 88352, nil, nil, nil, 3)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 88352 then
		timerChestBomb:Start(args.destName)
		if args:IsPlayer() then
			specWarnChestBomb:Show()
			specWarnChestBomb:Play("runout")
		else
			warnChestBomb:Show(args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 59304 then
		warnSpiritStrike:Show()
	end
end

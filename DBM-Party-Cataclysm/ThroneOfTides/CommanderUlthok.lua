local mod	= DBM:NewMod(102, "DBM-Party-Cataclysm", 9, 65)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(40765)
mod:SetEncounterID(1044)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 76094 76100 76026",
	"SPELL_CAST_START 76047 76100"
)

local warnDarkFissure		= mod:NewSpellAnnounce(76047, 4)
local warnSqueeze			= mod:NewTargetAnnounce(76026, 3)
local warnEnrage			= mod:NewSpellAnnounce(76100, 2, nil, "Tank")

local specWarnCurse			= mod:NewSpecialWarningDispel(76094, "RemoveCurse", nil, 2)
local specWarnFissure		= mod:NewSpecialWarningDodge(76047, "Tank")

local timerDarkFissureCD	= mod:NewCDTimer(18.4, 76047)
local timerSqueeze			= mod:NewTargetTimer(6, 76026)
local timerSqueezeCD		= mod:NewCDTimer(29, 76026, nil, nil, nil, 3)
local timerEnrage			= mod:NewBuffActiveTimer(10, 76100, nil, "Tank", 2, 5)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 76094 then
		specWarnCurse:Show(args.destName)
	elseif args.spellId == 76100 then
		timerEnrage:Start()
	elseif args.spellId == 76026 then
		warnSqueeze:Show(args.destName)
		timerSqueeze:Start(args.destName)
		timerSqueezeCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 76047 then
		if self.Options.SpecWarn76047dodge then
			specWarnFissure:Show()
		else
			warnDarkFissure:Show()
		end
		timerDarkFissureCD:Start()
	elseif args.spellId == 76100 then
		warnEnrage:Show()
	end
end
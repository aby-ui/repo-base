local mod = DBM:NewMod("Commander", "DBM-Party-WotLK", 8)
local L = mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
--mod:SetEncounterID(519)--FIXME in 7.1

if UnitFactionGroup("player") == "Alliance" then
	mod:SetCreatureID(26798)
	mod:SetModelID(24352)
else
	mod:SetCreatureID(26796)
	mod:SetModelID(24366)
end

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 19134",
	"SPELL_CAST_START 38619 38618"
)

local warningFear		= mod:NewSpellAnnounce(19134, 3)
local warningWhirlwind	= mod:NewSpellAnnounce(38619, 3)

local specWarnWW		= mod:NewSpecialWarningRun(38619, "MeleeDps", nil, nil, 4, 2)

local timerFearCD		= mod:NewCDTimer(20, 19134, nil, nil, nil, 2)--Correct?
local timerWhirlwindCD	= mod:NewCDTimer(15, 38619, nil, nil, nil, 2)--Correct?

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 19134 then
		warningFear:Show()
		timerFearCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38619, 38618) then
		if self.Options.SpecWarn38619run then
			specWarnWW:Show()
			specWarnWW:Play("runaway")
		else
			warningWhirlwind:Show()
		end
		timerWhirlwindCD:Start()
	end
end
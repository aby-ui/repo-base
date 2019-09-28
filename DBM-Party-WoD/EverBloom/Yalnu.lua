local mod	= DBM:NewMod(1210, "DBM-Party-WoD", 5, 556)
local L		= mod:GetLocalizedStrings()

mod:SetRevision((string.sub("20190414033732", 1, -5)):sub(12, -3))
mod:SetCreatureID(83846)
mod:SetEncounterID(1756)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 169179 169613",
	"SPELL_CAST_SUCCESS 169251",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnFontofLife			= mod:NewSpellAnnounce(169120, 3)--Does this need a switch warning too?

local specWarnColossalBlow		= mod:NewSpecialWarningDodge(169179, nil, nil, nil, 2, 2)
local specWarnEntanglement		= mod:NewSpecialWarningSwitch(169251, "Dps", nil, nil, 1, 2)
local specWarnGenesis			= mod:NewSpecialWarningSpell(169613, nil, nil, nil, 1, 2)--Everyone. "Switch" is closest generic to "run around stomping flowers"

--Only timers that were consistent, others are all over the place.
local timerFontOfLife			= mod:NewNextTimer(15, 169120, nil, nil, nil, 1)
local timerGenesis				= mod:NewCastTimer(17, 169613, nil, nil, nil, 5)
local timerGenesisCD			= mod:NewNextTimer(60.5, 169613, nil, nil, nil, 6)

function mod:OnCombatStart(delay)
	--timerFontOfLife:Start(-delay)
	--timerGenesisCD:Start(25-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 169179 then
		specWarnColossalBlow:Show()
		specWarnColossalBlow:Play("shockwave")
	elseif spellId == 169613 then
		specWarnGenesis:Show()
		specWarnGenesis:Play("169613")
		timerGenesis:Start()
		timerGenesisCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 169251 then
		specWarnEntanglement:Show()
		specWarnEntanglement:Play("targetchange")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 169120 then
		warnFontofLife:Show()
		timerFontOfLife:Start()
	end
end

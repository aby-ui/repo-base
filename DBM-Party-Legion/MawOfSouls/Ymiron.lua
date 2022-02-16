local mod	= DBM:NewMod(1502, "DBM-Party-Legion", 8, 727)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(96756)
mod:SetEncounterID(1822)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 193211 193364 193977 193460 193566"
)

local warnBane						= mod:NewSpellAnnounce(193460, 3)

local specWarnDarkSlash				= mod:NewSpecialWarningDefensive(193211, "Tank", nil, nil, 3, 2)
local specWarnScreams				= mod:NewSpecialWarningRun(193364, "Melee", nil, nil, 4, 2)
local specWarnWinds					= mod:NewSpecialWarningSpell(193977, nil, nil, nil, 2, 2)
local specAriseFallen				= mod:NewSpecialWarningSwitch(193566, "-Healer", nil, nil, 1, 2)

local timerDarkSlashCD				= mod:NewCDTimer(14.6, 193211, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerScreamsCD				= mod:NewCDTimer(23, 193364, nil, "Melee", nil, 2)
local timerWindsCD					= mod:NewCDTimer(24, 193977, nil, nil, nil, 2)
local timerBaneCD					= mod:NewCDTimer(49.5, 193460, nil, nil, nil, 2)
local timerAriseFallenCD			= mod:NewCDTimer(18, 193566, nil, nil, nil, 1, nil, DBM_COMMON_L.HEROIC_ICON)

function mod:OnCombatStart(delay)
	timerDarkSlashCD:Start(3.5-delay)
	timerScreamsCD:Start(5.9-delay)
	timerWindsCD:Start(15-delay)
	timerBaneCD:Start(21-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 193211 then
		specWarnDarkSlash:Show()
		specWarnDarkSlash:Play("defensive")
		timerDarkSlashCD:Start()
	elseif spellId == 193364 then
		specWarnScreams:Show()
		specWarnScreams:Play("runout")
		timerScreamsCD:Start()
	elseif spellId == 193977 then
		specWarnWinds:Show()
		specWarnWinds:Play("carefly")
		timerWindsCD:Start()
	elseif spellId == 193460 then
		warnBane:Show()
		timerBaneCD:Start()
		if not self:IsNormal() then
			timerAriseFallenCD:Start()
		end
	elseif spellId == 193566 then
		specAriseFallen:Show()
		specAriseFallen:Play("mobkill")
	end
end

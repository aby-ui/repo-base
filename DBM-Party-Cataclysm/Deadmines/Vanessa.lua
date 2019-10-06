local mod	= DBM:NewMod(95, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(49541)
mod:SetEncounterID(1081)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS 92100"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 92614 92622"
)

local warnDeflection	= mod:NewSpellAnnounce(92614, 3)
local warnDeadlyBlades	= mod:NewSpellAnnounce(92622, 3)

local specWarnDeflection	= mod:NewSpecialWarningReflect(92614, "SpellCaster", nil, nil, 1, 2)

local timerDeflection	= mod:NewBuffActiveTimer(10, 92614, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerDeadlyBlades	= mod:NewBuffActiveTimer(5, 92622, nil, nil, nil, 3)

local timerGauntlet		= mod:NewAchievementTimer(300, 5371, "achievementGauntlet")

function mod:OnCombatStart(delay)
	timerGauntlet:Cancel()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 92614 then
		timerDeflection:Start()
		if self.Options.SpecWarn92614reflect then
			specWarnDeflection:Show()
			specWarnDeflection:Play("stopattack")
		else
			warnDeflection:Show()
		end
	elseif args.spellId == 92622 then
		warnDeadlyBlades:Show()
		timerDeadlyBlades:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 92100 then
		timerGauntlet:Start()
	end
end
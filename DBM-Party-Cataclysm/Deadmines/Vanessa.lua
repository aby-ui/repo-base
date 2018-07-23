local mod	= DBM:NewMod(95, "DBM-Party-Cataclysm", 2, 63)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(49541)
mod:SetEncounterID(1081)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED"
)

local warnDeflection	= mod:NewSpellAnnounce(92614, 3)
local warnDeadlyBlades	= mod:NewSpellAnnounce(92622, 3)

local timerDeflection	= mod:NewBuffActiveTimer(10, 92614)
local timerDeadlyBlades	= mod:NewBuffActiveTimer(5, 92622)

local timerGauntlet		= mod:NewAchievementTimer(300, 5371, "achievementGauntlet")

function mod:OnCombatStart(delay)
	timerGauntlet:Cancel()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 92614 then
		warnDeflection:Show()
		timerDeflection:Start()
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
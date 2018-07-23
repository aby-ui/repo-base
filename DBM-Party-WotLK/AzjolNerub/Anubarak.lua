local mod	= DBM:NewMod(587, "DBM-Party-WotLK", 2, 272)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(29120)
mod:SetEncounterID(218, 266, 1973)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START"
)

local warningPound		= mod:NewSpellAnnounce(53472, 3)
local timerAchieve		= mod:NewAchievementTimer(240, 1860, "TimerSpeedKill") 

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic5") then
		timerAchieve:Start(-delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(53472, 59433) then
		warningPound:Show()
	end
end
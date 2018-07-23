local mod	= DBM:NewMod(600, "DBM-Party-WotLK", 6, 275)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(28923)
mod:SetEncounterID(561, 562, 1986)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START"
)

local warningNova	= mod:NewSpellAnnounce(52960, 3)

local timerNovaCD	= mod:NewCDTimer(30, 52960)
local timerAchieve	= mod:NewAchievementTimer(120, 1867, "TimerSpeedKill") 

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic5") then
		timerAchieve:Start(-delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(52960, 59835) then
		warningNova:Show()
		timerNovaCD:Start()
	end
end
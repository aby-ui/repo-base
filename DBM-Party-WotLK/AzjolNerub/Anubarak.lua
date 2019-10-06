local mod	= DBM:NewMod(587, "DBM-Party-WotLK", 2, 272)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(29120)
mod:SetEncounterID(218, 266, 1973)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 53472 59433"
)

local warningPound		= mod:NewSpellAnnounce(53472, 3)

local timerAchieve		= mod:NewAchievementTimer(240, 1860) 

function mod:OnCombatStart(delay)
	if not self:IsDifficulty("normal5") then
		timerAchieve:Start(-delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(53472, 59433) then
		warningPound:Show()
	end
end
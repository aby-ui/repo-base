local mod	= DBM:NewMod("Patchwerk", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(16028)
mod:SetEncounterID(1118)
mod:SetModelID(16174)
mod:RegisterCombat("combat_yell", L.yell1, L.yell2)

local enrageTimer	= mod:NewBerserkTimer(360)
local timerAchieve	= mod:NewAchievementTimer(180, 1857)

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	timerAchieve:Start(-delay)
end

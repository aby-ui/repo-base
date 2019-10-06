local mod	= DBM:NewMod(606, "DBM-Party-WotLK", 7, 277)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(28070)
mod:SetEncounterID(567, 568, 1995)

mod:RegisterCombat("yell", L.Pull)
mod:RegisterKill("yell", L.Kill)
mod:SetMinCombatTime(50)
mod:SetWipeTime(25)

mod:RegisterEventsInCombat(
	"CHAT_MSG_MONSTER_YELL"
)

local warningPhase	= mod:NewAnnounce("WarningPhase", 2, "136116")

local timerEvent	= mod:NewTimer(302, "timerEvent", "237538", nil, nil, 6)

function mod:OnCombatStart(delay)
	timerEvent:Start(-delay)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if L.Phase1 == msg then
		warningPhase:Show(1)
	elseif msg == L.Phase2 then
		warningPhase:Show(2)
	elseif msg == L.Phase3 then
		warningPhase:Show(3)
	end
end

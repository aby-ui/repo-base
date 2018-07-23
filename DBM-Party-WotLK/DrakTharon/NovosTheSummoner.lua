local mod	= DBM:NewMod(589, "DBM-Party-WotLK", 4, 273)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(26631)
mod:SetEncounterID(371, 372, 1976)
mod:SetZone()

mod:RegisterCombat("yell", L.YellPull)
mod:RegisterKill("yell", L.YellKill)
mod:SetWipeTime(25)

mod:RegisterEventsInCombat(
	"CHAT_MSG_MONSTER_YELL"
)

local WarnCrystalHandler 	= mod:NewCountAnnounce("ej6378", 2, 59910)
local warnPhase2			= mod:NewPhaseAnnounce(2)

local timerCrystalHandler 	= mod:NewNextTimer(15.5, "ej6378", nil, nil, nil, 1, 59910, DBM_CORE_DAMAGE_ICON)

local CrystalHandlers = 4

function mod:OnCombatStart(delay)
	timerCrystalHandler:Start(25.5-delay)
	CrystalHandlers = 4
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.HandlerYell then
		CrystalHandlers = CrystalHandlers - 1
		if CrystalHandlers > 0 then
			WarnCrystalHandler:Show(CrystalHandlers)
			timerCrystalHandler:Start()
		else
			WarnCrystalHandler:Show(CrystalHandlers)
		end
	elseif msg == L.Phase2 then
		warnPhase2:Show()
	end
end
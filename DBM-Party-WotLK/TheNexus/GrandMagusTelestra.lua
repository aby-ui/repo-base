local mod	= DBM:NewMod(618, "DBM-Party-WotLK", 8, 281)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 240 $"):sub(12, -3))
mod:SetCreatureID(26731)
mod:SetEncounterID(520, 521, 2010)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"UNIT_HEALTH boss1",
	"CHAT_MSG_MONSTER_YELL"
)

local warningSplitSoon	= mod:NewSoonAnnounce("ej7395", 2)
local warningSplitNow	= mod:NewSpellAnnounce("ej7395", 3)

local warnedSplit1		= false
local warnedSplit2		= false

function mod:OnCombatStart()
	warnedSplit1 = false
	warnedSplit2 = false
end

function mod:UNIT_HEALTH(uId)
	if not warnedSplit1 and self:GetUnitCreatureId(uId) == 26731 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.58 then
		warnedSplit1 = true
		warningSplitSoon:Show()
	elseif not warnedSplit2 and self:IsDifficulty("heroic5") and self:GetUnitCreatureId(uId) == 26731 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.19 then
		warnedSplit2 = true
		warningSplitSoon:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SplitTrigger1 or msg == L.SplitTrigger2 then
		warningSplitNow:Show()
	end
end

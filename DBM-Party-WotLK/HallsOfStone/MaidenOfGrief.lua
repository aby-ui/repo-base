local mod	= DBM:NewMod(605, "DBM-Party-WotLK", 7, 277)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(27975)
mod:SetEncounterID(565, 566, 1996)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningWoe		= mod:NewTargetAnnounce(50761, 2)
local warningSorrow		= mod:NewSpellAnnounce(50760, 1)
local warningStorm		= mod:NewSpellAnnounce(50752, 3)

local timerWoe			= mod:NewTargetTimer(10, 50761)
local timerSorrow		= mod:NewBuffActiveTimer(6, 50760)
local timerStormCD		= mod:NewCDTimer(20, 50752)
local timerSorrowCD		= mod:NewCDTimer(30, 50760)
local timerAchieve		= mod:NewAchievementTimer(60, 1866, "TimerSpeedKill")

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic5") then
		timerAchieve:Start(-delay)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(50760, 59726) then
		timerSorrow:Start()
		warningSorrow:Show()
		timerSorrowCD:Start()
	elseif args:IsSpellID(50752, 59772) then
		warningStorm:Show()
		timerStormCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(50761, 59727) then
		warningWoe:Show(args.destName)
		timerWoe:Start(args.destName)
	end
end
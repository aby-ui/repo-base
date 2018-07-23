local mod	= DBM:NewMod(643, "DBM-Party-WotLK", 11, 286)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 248 $"):sub(12, -3))
mod:SetCreatureID(26693)
mod:SetEncounterID(581, 582, 2029)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("yell", L.Phase2)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warnPhase2		= mod:NewPhaseAnnounce(2)
local warningPoison		= mod:NewTargetAnnounce(59331, 2)

local specWarnWhirlwind	= mod:NewSpecialWarningRun(59322, nil, nil, 2, 4, 2)

local timerPoison		= mod:NewTargetTimer(12, 59331)
local timerWhirlwindCD	= mod:NewCDTimer(23, 59322)
local timerAchieve		= mod:NewAchievementTimer(180, 1873, "TimerSpeedKill")

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(59331, 50255) then
		warningPoison:Show(args.destName)
		timerPoison:Start(args.destName)
	elseif args:IsSpellID(59322, 50228) then
		timerWhirlwindCD:Start()
		if not self:IsTrivial(90) then
			specWarnWhirlwind:Show()
			specWarnWhirlwind:Play("runout")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(59331, 50255) then
		timerPoison:Cancel(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2 or msg:find(L.Phase2) then
		warnPhase2:Show()
	elseif msg == L.CombatStart or msg:find(L.CombatStart) then
		if self:IsDifficulty("heroic5") then
			timerAchieve:Start()
		end
	end
end
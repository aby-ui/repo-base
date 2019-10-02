local mod	= DBM:NewMod(637, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(35451, 10000)		-- work around, DBM API failes to handle a Boss to die, rebirth, die again, rebirth again and die to loot...
mod:SetEncounterID(340, 341, 2021)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 67729",
	"SPELL_AURA_APPLIED 67823 67751",
	"SPELL_DAMAGE 67781 67729",
	"SPELL_MISSED 67781 67729"
)

local warnMarked			= mod:NewTargetNoFilterAnnounce(67823, 3)

local specWarnDesecration	= mod:NewSpecialWarningMove(67781, nil, nil, nil, 1, 8)
local specWarnExplode		= mod:NewSpecialWarningRun(67751, "Melee", nil, 2, 4, 2)

local timerCombatStart		= mod:NewCombatTimer(55.5)
local timerMarked			= mod:NewTargetTimer(10, 67823, nil, nil, nil, 3)
local timerExplode			= mod:NewCastTimer(4, 67729, nil, nil, nil, 2)

mod:AddSetIconOption("SetIconOnMarkedTarget", 67823, false, false, {8})
mod:AddBoolOption("AchievementCheck", false, "announce")

local warnedfailed = false

function mod:OnCombatStart(delay)
	warnedfailed = false
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 67729 and self:AntiSpam(2, 2) then
		specWarnExplode:Show()
		specWarnExplode:Play("justrun")
		timerExplode:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 67781 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then
		specWarnDesecration:Show()
		specWarnDesecration:Play("watchfeet")
	elseif spellId == 67729 then
		if self.Options.AchievementCheck and not warnedfailed then
			SendChatMessage(L.AchievementFailed:format(destName), "PARTY")
			warnedfailed = true
		end
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 67823 and args:IsDestTypePlayer() then
		if self.Options.SetIconOnMarkedTarget then
			self:SetIcon(args.destName, 8, 10)
		end
		warnMarked:Show(args.destName)
		timerMarked:Show(args.destName)
	elseif args.spellId == 67751 and self:AntiSpam(2, 2) then	-- Ghoul Explode (BK exlodes Army of the dead. Phase 3)
		specWarnExplode:Show()
		specWarnExplode:Play("justrun")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Pull or msg:find(L.Pull) then
		timerCombatStart:Start()
	end
end

local mod	= DBM:NewMod(189, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(23577)
mod:SetEncounterID(1192)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL"
)
mod.onlyHeroic = true

local warnTotemWater	= mod:NewSpellAnnounce(97499, 3)
local warnTotemLighting	= mod:NewSpellAnnounce(43302, 3)
local warnShock			= mod:NewTargetAnnounce(43303, 3)
local warnEnrage		= mod:NewTargetAnnounce(43139, 3)
local warnSpirit		= mod:NewAnnounce("WarnSpirit", 4, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)

local specWarnTotem		= mod:NewSpecialWarningSpell(43302)
local specWarnTotemWater= mod:NewSpecialWarningMove(97499, "Tank")
local specWarnEnrage	= mod:NewSpecialWarningDispel(43139, "RemoveEnrage")

local timerShock		= mod:NewTargetTimer(12, 43303)

local berserkTimer		= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43303 then
		warnShock:Show(args.destName)
		timerShock:Show(args.destName)
	elseif args.spellId == 43139 then
		warnEnrage:Show(args.destName)
		specWarnEnrage:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 43303 then
		timerShock:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 43302 then
		warnTotemLighting:Show()
		specWarnTotem:Show()
	elseif args.spellId == 97499 then
		warnTotemWater:Show()
		specWarnTotemWater:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellSpirit or msg:find(L.YellSpirit) then
		warnSpirit:Show()
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		warnNormal:Show()
	end
end

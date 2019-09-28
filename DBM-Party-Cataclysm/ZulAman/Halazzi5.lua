local mod	= DBM:NewMod(189, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(23577)
mod:SetEncounterID(1192)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 43303 43139",
	"SPELL_AURA_REMOVED 43303",
	"SPELL_CAST_START 43302 97499",
	"CHAT_MSG_MONSTER_YELL"
)
mod.onlyHeroic = true

local warnShock			= mod:NewTargetNoFilterAnnounce(43303, 3, nil, "Healer", 2)
local warnEnrage		= mod:NewTargetAnnounce(43139, 3)
local warnSpirit		= mod:NewAnnounce("WarnSpirit", 4, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)

local specWarnTotem		= mod:NewSpecialWarningSwitch(43302, nil, nil, nil, 1, 2)
local specWarnTotemWater= mod:NewSpecialWarningMove(97499, "Tank", nil, nil, 1, 2)
local specWarnEnrage	= mod:NewSpecialWarningDispel(43139, "RemoveEnrage", nil, nil, 1, 2)

local timerShock		= mod:NewTargetTimer(12, 43303, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)

local berserkTimer		= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43303 then
		warnShock:Show(args.destName)
		timerShock:Show(args.destName)
	elseif args.spellId == 43139 then
		if self.Options.SpecWarn43139dispel then
			specWarnEnrage:Show(args.destName)
			specWarnEnrage:Play("enrage")
		else
			warnEnrage:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 43303 then
		timerShock:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 43302 then
		specWarnTotem:Show()
		specWarnTotem:Play("attacktotem")
	elseif args.spellId == 97499 then
		specWarnTotemWater:Show()
		specWarnTotemWater:Play("moveboss")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellSpirit or msg:find(L.YellSpirit) then
		warnSpirit:Show()
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		warnNormal:Show()
	end
end

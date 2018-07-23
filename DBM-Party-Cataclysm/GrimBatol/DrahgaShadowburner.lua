local mod	= DBM:NewMod(133, "DBM-Party-Cataclysm", 3, 71)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 190 $"):sub(12, -3))
mod:SetCreatureID(40319)
mod:SetEncounterID(1048)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
--	"SPELL_SUMMON",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_AURA_UNFILTERED"
)

--shredding? Disabled since it seemed utterly useless in my limited testing
--local warnShredding				= mod:NewSpellAnnounce(75271, 3)
local warnFlamingFixate	 		= mod:NewTargetAnnounce(82850, 4)

local specWarnFlamingFixate		= mod:NewSpecialWarningRun(82850, nil, nil, nil, 4)
local specWarnDevouring 		= mod:NewSpecialWarningDodge(90950, nil, nil, nil, 2)
local specWarnSeepingTwilight	= mod:NewSpecialWarningMove(75317)

local timerAddCD				= mod:NewCDTimer(22, 90949, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--22-27. 24 is the average
local timerDevouringCD			= mod:NewCDTimer(40, 90950, nil, nil, nil, 3)
local timerDevouring			= mod:NewBuffActiveTimer(5, 90950)
--local timerShredding			= mod:NewBuffActiveTimer(20, 75271)

local flamingFixate = DBM:GetSpellInfo(82850)
local fixateWarned = {}
local Valiona = DBM:EJ_GetSectionInfo(3369)
local valionaLanded = false

function mod:OnCombatStart(delay)
	table.wipe(fixateWarned)
	valionaLanded = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 75328 then
		timerDevouringCD:Cancel()
		timerDevouring:Cancel()
	elseif args.spellId == 75317 and args:IsPlayer() then
		specWarnSeepingTwilight:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 90950 then
		specWarnDevouring:Show()
		timerDevouring:Start()
		timerDevouringCD:Start()
	end
end

--[[
function mod:SPELL_SUMMON(args)
	if args.spellId == 75271 then
		warnShredding:Show()
		timerShredding:Start()
	end
end--]]

function mod:CHAT_MSG_MONSTER_YELL(msg, npc)
	if npc == Valiona and not valionaLanded then
		valionaLanded = true
		timerDevouringCD:Start(29)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("spell:75218") then--Add spawning
		timerAddCD:Start()
	end
end

function mod:UNIT_AURA_UNFILTERED(uId)
	local isFixate = DBM:UnitDebuff(uId, flamingFixate)
	local name = DBM:GetUnitFullName(uId)
	if not isFixate and fixateWarned[name] then
		fixateWarned[name] = nil
	elseif isFixate and not fixateWarned[name] then
		fixateWarned[name] = true
		if uId == "player" then
			specWarnFlamingFixate:Show()
		else
			warnFlamingFixate:Show(DBM:GetUnitFullName(uId))
		end
	end
end

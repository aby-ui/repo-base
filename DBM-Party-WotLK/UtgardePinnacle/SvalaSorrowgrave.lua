local mod	= DBM:NewMod(641, "DBM-Party-WotLK", 11, 286)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(26668)
mod:SetEncounterID(577, 578, 2030)
mod:DisableESCombatDetection()
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 48267 48276",
	"SPELL_AURA_REMOVED 48276"
)

local warningSacrifice	= mod:NewTargetNoFilterAnnounce(48267, 4)

local timerSacrifice	= mod:NewBuffActiveTimer(25, 48276, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerRoleplay		= mod:NewTimer(67, "timerRoleplay", "237538")--roleplay for boss is active

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 48267 then
		warningSacrifice:Show(args.destName)
	elseif args.spellId == 48276 then
		timerSacrifice:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 48276 then
		timerSacrifice:Stop()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SvalaRoleplayStart or msg:find(L.SvalaRoleplayStart) then
		timerRoleplay:Start()
	end
end
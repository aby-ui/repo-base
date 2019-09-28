local mod	= DBM:NewMod(632, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(31134)
mod:SetEncounterID(545, 546, 2020)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 58694 58693 59369",
	"SPELL_AURA_APPLIED 59374",
	"SPELL_AURA_REMOVED 59374"
)

local warningVacuum		= mod:NewSpellAnnounce(58694, 1)
local warningBlizzard	= mod:NewSpellAnnounce(58693, 3)

local specwarnMana		= mod:NewSpecialWarningDispel(59374, "Healer", nil, nil, 1, 2)

local timerVacuumCD		= mod:NewCDTimer(35, 58694, nil, nil, nil, 2)
local timerMana			= mod:NewTargetTimer(8, 59374, nil, "Healer", nil, 5, nil, DBM_CORE_MAGIC_ICON)
local timerCombat		= mod:NewCombatTimer(14)

function mod:OnCombatStart(delay)
	timerVacuumCD:Start(30 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 58694 then
		warningVacuum:Show()
		timerVacuumCD:Cancel()
		timerVacuumCD:Start()
	elseif args:IsSpellID(58693, 59369) then
		warningBlizzard:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 59374 then
		if self:CheckDispelFilter() then
			specwarnMana:Show(args.destName)
			specwarnMana:Play("helpdispel")
		end
		timerMana:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 59374 then
		timerMana:Stop(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.CyanArrived then
		self:SendSync("CyanArrived")
	end
end

function mod:OnSync(msg, arg)
	if msg == "CyanArrived" then
		timerCombat:Start()
	end
end

local mod	= DBM:NewMod(104, "DBM-Party-Cataclysm", 9, 65)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 190 $"):sub(12, -3))
mod:SetCreatureID(40792)
mod:SetEncounterID(1047)
mod:SetMainBossID(42172)--42172 is Ozumat, but we need Neptulon for engage trigger.
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 83463 76133",
	"SPELL_CAST_SUCCESS 83985 83986",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnPhase2		= mod:NewPhaseAnnounce(2)
local warnPhase3		= mod:NewPhaseAnnounce(3)
local warnBlightSpray	= mod:NewSpellAnnounce(83985, 2)

local timerPhase		= mod:NewTimer(95, "TimerPhase", nil, nil, nil, 6)
local timerBlightSpray	= mod:NewBuffActiveTimer(4, 83985)

local warnedPhase2 = false
local warnedPhase3 = false

function mod:OnCombatStart(delay)
	warnedPhase2 = false
	warnedPhase3 = false
	timerPhase:Start()--Can be done right later once consistency is confirmed.
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 83463 and not warnedPhase2 then
		warnPhase2:Show(2)
		warnedPhase2 = true
	elseif args.spellId == 76133 and not warnedPhase3 then
		warnPhase3:Show(3)
		warnedPhase3 = true
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(83985, 83986) then
		warnBlightSpray:Show()
		timerBlightSpray:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 83909 then --Clear Tidal Surge
		self:SendSync("bossdown")
	end
end

function mod:OnSync(msg)
	if msg == "bossdown" then
		DBM:EndCombat(self)
	end
end
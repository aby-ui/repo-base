local mod	= DBM:NewMod(124, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(39425)
mod:SetEncounterID(1080)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"UNIT_HEALTH"
)

local warnShield		= mod:NewSpellAnnounce(74938, 3)
local warnShieldSoon	= mod:NewSoonAnnounce(74938, 2)
local warnReckoning		= mod:NewTargetAnnounce(75592, 4)

local timerReckoning	= mod:NewTargetTimer(8, 75592)

local specWarnLight		= mod:NewSpecialWarningMove(75117)

local prewarnShield = false

function mod:OnCombatStart(delay)
	prewarnShield = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 74938 then
		warnShield:Show()
	elseif args.spellId == 75592 then
		warnReckoning:Show(args.destName)
		timerReckoning:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 75592 then
		timerReckoning:Cancel(args.destName)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 75117 and destGUID == UnitGUID("player") and self:AntiSpam(5) then
		specWarnLight:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitName(uId) == L.name then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if not prewarnShield and (h < 75 and h > 70 or h < 41 and h < 36) then
			prewarnShield = true
			warnShieldSoon:Show()
		elseif prewarnShield and (h > 80 or h < 60 and h > 45) then
			prewarnShield = false
		end
	end
end
		

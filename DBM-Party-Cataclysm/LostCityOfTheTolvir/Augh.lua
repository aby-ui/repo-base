local mod	= DBM:NewMod("Augh", "DBM-Party-Cataclysm", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(49045)
mod:SetModelID(37339)--Needs hardcode because he's not in EJ as a separate boss even though he is.
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 84768 84799 91408",
	"SPELL_AURA_REMOVED 84799"
)

local warnSmokeBomb			= mod:NewSpellAnnounce(84768, 3)
local warnParalyticDart		= mod:NewTargetAnnounce(84799, 3, nil, false, 2)
local warnWhirlWind			= mod:NewSpellAnnounce(91408, 3)

local timerParalyticDart	= mod:NewTargetTimer(9, 84799, nil, false, 2, 5)

function mod:OnCombatStart(delay)

end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 84768 and self:AntiSpam(5) then
		warnSmokeBomb:Show()
	elseif spellId == 84799 then
		warnParalyticDart:Show(args.destName)
		timerParalyticDart:Start(args.destName)
	elseif spellId == 91408 then
		warnWhirlWind:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 84799 then
		timerParalyticDart:Cancel()
	end
end
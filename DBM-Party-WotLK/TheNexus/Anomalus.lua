local mod	= DBM:NewMod(619, "DBM-Party-WotLK", 8, 281)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(26763)
mod:SetEncounterID(522, 523, 2009)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_SUMMON 47743",
	"UNIT_HEALTH boss1"
)

local warningRiftSoon	= mod:NewSoonAnnounce(47743, 2)
local warningRiftNow	= mod:NewSpellAnnounce(47743, 3)

local warnedRift		= false

function mod:OnCombatStart()
	warnedRift = false
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 47743 then
		warningRiftNow:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitName(uId) == L.name then
		local h = UnitHealth(uId) / UnitHealthMax(uId)
		if (h > 0.80) or (h < 0.70 and h > 0.55) or (h < 0.45 and h > 0.30) then
			warnedRift = false
		end
		if not warnedRift then
			if (h < 0.80 and h > 0.77) or (h < 0.55 and h > 0.52) or (h < 0.30 and h > 0.27) then
				warningRiftSoon:Show()
				warnedRift = true
			end
		end
	end
end


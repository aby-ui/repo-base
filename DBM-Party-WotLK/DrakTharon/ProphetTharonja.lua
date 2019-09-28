local mod	= DBM:NewMod(591, "DBM-Party-WotLK", 4, 273)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(26632)
mod:SetEncounterID(375, 376, 1975)
mod:SetModelID(27072)--Does not scale, but at least it's on face. Leaving on for now.
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 49548 59969",
	"UNIT_HEALTH boss1"
)

local warningDecayFleshSoon		= mod:NewSoonAnnounce(49356, 2)
local warningCloud 				= mod:NewSpellAnnounce(49548, 3)

mod.vb.warnedDecay = false

function mod:OnCombatStart()
	self.vb.warnedDecay = false
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(49548, 59969) then
		warningCloud:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if not self.vb.warnedDecay and self:GetUnitCreatureId(uId) == 26632 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.58 then
		self.vb.warnedDecay = true
		warningDecayFleshSoon:Show()
	end
end

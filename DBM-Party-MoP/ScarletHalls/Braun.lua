local mod	= DBM:NewMod(660, "DBM-Party-MoP", 8, 311)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 10728 $"):sub(12, -3))
mod:SetCreatureID(59303)
mod:SetEncounterID(1422)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 114021 114242 114259 116140",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnPiercingThrow			= mod:NewSpellAnnounce(114021, 2)
local warnDeathBlossom			= mod:NewSpellAnnounce(114242, 3)
local warnCallDog				= mod:NewSpellAnnounce(114259, 4)
local warnBloodyRage			= mod:NewSpellAnnounce(116140, 4)

local timerPiercingThrowCD		= mod:NewNextTimer(6, 114021)
local timerDeathBlossomCD		= mod:NewNextTimer(6, 114242)

function mod:OnCombatStart(delay)
	timerPiercingThrowCD:Start(7-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 114021 then
		warnPiercingThrow:Show()
	elseif args.spellId == 114242 then
		warnDeathBlossom:Show()
	elseif args.spellId == 114259 and self:AntiSpam(3, 1) then--Call Dog
		warnCallDog:Show()
	elseif args.spellId == 116140 then--Blood Rage(done calling dogs)
		warnBloodyRage:Show()
		timerPiercingThrowCD:Start(13.5)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 114086 then
		warnPiercingThrow:Show()
	end
end

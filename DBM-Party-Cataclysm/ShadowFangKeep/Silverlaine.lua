local mod	= DBM:NewMod(97, "DBM-Party-Cataclysm", 6, 64)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(3887)
mod:SetEncounterID(1070)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 93956",
	"SPELL_AURA_REMOVED 93956",
	"SPELL_CAST_START 93857"
)

local warnVeilShadow	= mod:NewSpellAnnounce(93956, 3)
local warnWorgenSpirit	= mod:NewSpellAnnounce(93857, 3)

local timerVeilShadow	= mod:NewBuffFadesTimer(8, 93956, nil, nil, nil, 5, nil, DBM_CORE_MAGIC_ICON)

local veilShadowCast = 0

function mod:OnCombatStart(delay)
	veilShadowCast = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93956 then
		veilShadowCast = veilShadowCast + 1
		if self:AntiSpam(4) then
			warnVeilShadow:Show()
			timerVeilShadow:Start()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 93956 then
		veilShadowCast = veilShadowCast - 1
		if veilShadowCast == 0 then
			timerVeilShadow:Cancel()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93857 then
		warnWorgenSpirit:Show()
	end
end
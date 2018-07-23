local mod	= DBM:NewMod(335, "DBM-Party-MoP", 1, 313)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 102 $"):sub(12, -3))
mod:SetCreatureID(56439)
mod:SetEncounterID(1439)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 106736 106113",
	"SPELL_AURA_APPLIED 117665 106113 110099",
	"SPELL_AURA_REMOVED 117665 106113"
)


local warnWitherWill			= mod:NewSpellAnnounce(106736, 3, nil, false, 2)
local warnBoundsOfReality		= mod:NewSpellAnnounce(117665, 3)

local specWarnTouchOfNothingness= mod:NewSpecialWarningDispel(106113, "Healer")
local specWarnShadowsOfDoubt	= mod:NewSpecialWarningMove(110099)--Actually used by his trash, but in a speed run, you tend to pull it all together

local timerWitherWillCD			= mod:NewCDTimer(6, 106736, nil, false, 2)--6-10 second variations.
local timerTouchofNothingnessCD	= mod:NewCDTimer(15.5, 106113, nil, "Heaker", 2, 5, nil, DBM_CORE_MAGIC_ICON)--15.5~20 second variations.
local timerTouchofNothingness	= mod:NewTargetTimer(30, 106113, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON)
local timerBoundsOfRealityCD	= mod:NewCDTimer(60, 117665, nil, nil, nil, 6)
local timerBoundsOfReality		= mod:NewBuffFadesTimer(30, 117665, nil, nil, nil, 6)

function mod:OnCombatStart(delay)
	timerWitherWillCD:Start(-delay)
	timerTouchofNothingnessCD:Start(13-delay)
	timerBoundsOfRealityCD:Start(22-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 106736 then
		warnWitherWill:Show()
		timerWitherWillCD:Start()
	elseif args.spellId == 106113 then--Start Cd here in case it's resisted
		timerTouchofNothingnessCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 117665 then
		warnBoundsOfReality:Show()
		timerWitherWillCD:Cancel()
		timerTouchofNothingnessCD:Cancel()
		timerBoundsOfReality:Start()
		timerBoundsOfRealityCD:Start()
	elseif args.spellId == 106113 then
		specWarnTouchOfNothingness:Show(args.destName)
		timerTouchofNothingness:Start(args.destName)
	elseif args.spellId == 110099 and args:IsPlayer() then
		specWarnShadowsOfDoubt:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 117665 then
		timerBoundsOfReality:Cancel()
	elseif args.spellId == 106113 then
		timerTouchofNothingness:Cancel(args.destName)
	end
end

local mod	= DBM:NewMod(1235, "DBM-Party-WoD", 4, 558)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 35 $"):sub(12, -3))
mod:SetCreatureID(81297, 81305)
mod:SetEncounterID(1749)
mod:SetZone()
mod:SetBossHPInfoToHighest(false)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 164426 164835 164632",
	"SPELL_AURA_REMOVED 164426",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_TARGETABLE_CHANGED"
)

local warnNokgar						= mod:NewSpellAnnounce("ej10433", 3, "Interface\\ICONS\\INV_Misc_Head_Orc_01.blp")

local specWarnBurningArrows				= mod:NewSpecialWarningSpell(164635, nil, nil, nil, 2, 2)
local specWarnBurningArrowsMove			= mod:NewSpecialWarningMove(164635, nil, nil, nil, 1, 2)
local specWarnRecklessProvocation		= mod:NewSpecialWarningReflect(164426, nil, nil, nil, 1, 2)
local specWarnRecklessProvocationEnd	= mod:NewSpecialWarningEnd(164426, nil, nil, nil, 1, 2)
local specWarnEnrage					= mod:NewSpecialWarningDispel(164835, "RemoveEnrage", nil, nil, 1, 2)

local timerRecklessProvocation			= mod:NewBuffActiveTimer(5, 164426)
--local timerBurningArrowsCD			= mod:NewNextTimer(25, 164635)--25~42 variable (patterned?)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 164426 then
		specWarnRecklessProvocation:Show(args.destName)
		timerRecklessProvocation:Start()
		specWarnRecklessProvocation:Play("stopattack")
	elseif args.spellId == 164835 and self:AntiSpam(2, 1) then
		specWarnEnrage:Show(args.destName)
		specWarnEnrage:Play("trannow") --multi sound
	elseif args.spellId == 164632 and args:IsPlayer() and self:AntiSpam(2, 2) then
		specWarnBurningArrowsMove:Show()
		specWarnBurningArrowsMove:Play("runaway")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 164426 then
		specWarnRecklessProvocationEnd:Show()
		specWarnRecklessProvocationEnd:Play("safenow")
	end
end

--Not detectable in phase 1. Seems only cleanly detectable in phase 2, in phase 1 boss has no "boss" unitid so cast hidden.
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 164635 then
		specWarnBurningArrows:Show()
		specWarnBurningArrows:Play("watchstep")
		--timerBurningArrowsCD:Start()
	end
end

function mod:UNIT_TARGETABLE_CHANGED()
	warnNokgar:Show()
end

local mod	= DBM:NewMod(1497, "DBM-Party-Legion", 6, 726)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20220217011830")
mod:SetCreatureID(98203)
mod:SetEncounterID(1827)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 196562 196805",
	"SPELL_AURA_REMOVED 196562",
	"SPELL_CAST_SUCCESS 196562 196804 196392",
	"SPELL_PERIODIC_DAMAGE 196824",
	"SPELL_PERIODIC_MISSED 196824"
)

--TODO, verify some of this is actually timer based and not just mana depletion related.
--TODO, verify first special timers some more
local warnVolatileMagic				= mod:NewTargetAnnounce(196562, 3)
local warnNetherLink				= mod:NewTargetAnnounce(196805, 4)

local specWarnVolatileMagic			= mod:NewSpecialWarningMoveAway(196562, nil, nil, nil, 1, 2)
local yellVolatileMagic				= mod:NewYell(196562)
local specWarnNetherLink			= mod:NewSpecialWarningYou(196805, nil, nil, nil, 1, 2)
local specWarnNetherLinkGTFO		= mod:NewSpecialWarningMove(196805, nil, nil, nil, 1, 2)
local specWarnOverchargeMana		= mod:NewSpecialWarningInterrupt(196392, "HasInterrupt", nil, nil, 1, 2)

local timerVolatileMagicCD			= mod:NewCDTimer(32, 196562, nil, nil, nil, 3)--Review, Might be health based? or just really variable
local timerNetherLinkCD				= mod:NewCDTimer(30, 196805, nil, nil, nil, 3)
local timerOverchargeManaCD			= mod:NewCDTimer(40, 196392, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)

mod:AddRangeFrameOption(8, 196562)

function mod:OnCombatStart(delay)
	--Watch closely, review. He may be able to swap nether link and volatile magic?
	timerVolatileMagicCD:Start(7.7-delay)--APPLIED
	timerNetherLinkCD:Start(17.5-delay)--APPLIED
	timerOverchargeManaCD:Start(30-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 196562 then
		warnVolatileMagic:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnVolatileMagic:Show()
			specWarnVolatileMagic:Play("runout")
			yellVolatileMagic:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
	elseif spellId == 196805 then
		warnNetherLink:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnNetherLink:Show()
			specWarnNetherLink:Play("targetyou")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 196562 and args:IsPlayer() and self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 196562 then
		timerVolatileMagicCD:Start()
	elseif spellId == 196804 then
		timerNetherLinkCD:Start()
	elseif spellId == 196392 then
		specWarnOverchargeMana:Show(args.sourceName)
		specWarnOverchargeMana:Play("kickcast")
		timerOverchargeManaCD:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 196824 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnNetherLinkGTFO:Show()
		specWarnNetherLinkGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

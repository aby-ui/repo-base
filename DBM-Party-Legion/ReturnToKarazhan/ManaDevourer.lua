local mod	= DBM:NewMod(1818, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20221016002954")
mod:SetCreatureID(114252)
mod:SetEncounterID(1959)
--mod:SetUsedIcons(1)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227507",
	"SPELL_CAST_SUCCESS 227618 227523",
	"SPELL_AURA_APPLIED 227297"
)

local warnEnergyVoid				= mod:NewSpellAnnounce(227523, 1)
local warnArcaneBomb				= mod:NewSpellAnnounce(227618, 3)

local specWarnDecimatingEssence		= mod:NewSpecialWarningSpell(227507, nil, nil, nil, 3, 2)
local specWarnCoalescePower			= mod:NewSpecialWarningMoveTo(227297, nil, nil, nil, 1, 2)

local timerEnergyVoidCD				= mod:NewCDTimer(20.6, 227523, nil, nil, nil, 3)
local timerCoalescePowerCD			= mod:NewNextTimer(30, 227297, nil, nil, nil, 1, nil, nil, nil, 1, 4)

mod:AddInfoFrameOption(227502, true)

local unstableMana, looseMana = DBM:GetSpellInfo(227502), DBM:GetSpellInfo(227296)

function mod:OnCombatStart(delay)
	timerEnergyVoidCD:Start(14.5-delay)
	timerCoalescePowerCD:Start(30-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(unstableMana)
		DBM.InfoFrame:Show(5, "playerdebuffstacks", unstableMana)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227507 then
		specWarnDecimatingEssence:Show()
		specWarnDecimatingEssence:Play("aesoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 227618 then
		warnArcaneBomb:Show()
	elseif spellId == 227523 then
		warnEnergyVoid:Show()
		timerEnergyVoidCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 227297 then
		specWarnCoalescePower:Show(looseMana)
		specWarnCoalescePower:Play("helpsoak")
		timerCoalescePowerCD:Start()
	end
end

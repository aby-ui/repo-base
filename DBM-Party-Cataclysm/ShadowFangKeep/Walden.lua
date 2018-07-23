local mod	= DBM:NewMod(99, "DBM-Party-Cataclysm", 6, 64)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(46963)
mod:SetEncounterID(1073)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 93505 93697",
	"SPELL_AURA_APPLIED 93527 93689 93617",
	"SPELL_AURA_APPLIED_DOSE 93527 93689 93617"
)

local warnFrostMix		= mod:NewSpellAnnounce(93505, 3)
local warnIceShards		= mod:NewSpellAnnounce(93527, 3)
local warnPoisonMix		= mod:NewSpellAnnounce(93697, 3)
local warnGreenMix		= mod:NewSpellAnnounce(93617, 4)
local warnRedMix		= mod:NewSpellAnnounce(93689, 4)

local specWarnGreenMix	= mod:NewSpecialWarning("specWarnCoagulant", nil, false)
local specWarnRedMix	= mod:NewSpecialWarning("specWarnRedMix", nil, false)
mod:AddBoolOption("RedLightGreenLight", true, "announce")

local timerIceShards	= mod:NewBuffActiveTimer(5, 93527)
local timerRedMix		= mod:NewBuffActiveTimer(10, 93689, nil, nil, nil, 6)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93527 then
		warnIceShards:Show()
		timerIceShards:Start()
	elseif args.spellId == 93689 and self:AntiSpam(4, 1) then--Red Light
		warnRedMix:Show()
		timerRedMix:Start()
		if self.Options.RedLightGreenLight then
			specWarnRedMix:Show()
		end
	elseif args.spellId == 93617 and self:AntiSpam(10, 2) then--Green Light
		warnGreenMix:Show()
		if self.Options.RedLightGreenLight then
			specWarnGreenMix:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args.spellId == 93505 then
		warnFrostMix:Show()
	elseif args.spellId == 93697 then
		warnPoisonMix:Show()
	end
end
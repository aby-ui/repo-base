local mod	= DBM:NewMod(1790, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210721041434")
mod:SetCreatureID(109943)
--mod:SetEncounterID(1880)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 218823 218888 219045 219254",
	"SPELL_AURA_APPLIED 219045 219068"
)

--TODO: Tank swap warning if breath is often enough and threatening.
--TODO: figure out Gaseous Breath stuff.
--TODO, icon option for mind controls maybe. Coordinate healer dispels better
local warnMothersEmbrace		= mod:NewTargetAnnounce(219045, 3)
local warnMothersEmbraceFail	= mod:NewTargetAnnounce(219068, 4)
local warnGaseousBreath			= mod:NewSpellAnnounce(219254, 2)

local specWarnFelGeyser			= mod:NewSpecialWarningDodge(218823, nil, nil, nil, 2, 2)
local specWarnImpishFlames		= mod:NewSpecialWarningDefensive(218888, "Tank", nil, nil, 1, 2)
local specWarnMothersEmbrace	= mod:NewSpecialWarningDispel(219045, "Healer", nil, nil, 1, 2)

local timerFelGeyserCD			= mod:NewAITimer(16, 218823, nil, nil, nil, 2)
local timerImpishFlamesCD		= mod:NewCDTimer(22, 218888, nil, "Tank", nil, 5)
local timerMothersEmbraceCD		= mod:NewCDTimer(62, 219045, nil, nil, nil, 3)
local timerGaseousBreathCD		= mod:NewCDTimer(30, 219254, nil, nil, nil, 1)

--mod:AddReadyCheckOption(37460, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:OnCombatEnd()

end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 218823 then
		specWarnFelGeyser:Show()
		specWarnFelGeyser:Play("watchstep")
		timerFelGeyserCD:Start()
	elseif spellId == 218888 then
		specWarnImpishFlames:Show()
		specWarnImpishFlames:Play("breathsoon")
		timerImpishFlamesCD:Start()
	elseif spellId == 219045 then
		timerMothersEmbraceCD:Start()
	elseif spellId == 219254 then
		warnGaseousBreath:Show()
		timerGaseousBreathCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 219045 then
		if self.Options.SpecWarn219045dispel then
			specWarnMothersEmbrace:CombinedShow(0.3, args.destName)
		else
			warnMothersEmbrace:CombinedShow(0.3, args.destName)
		end
		if self:AntiSpam(3, 1) then
			specWarnMothersEmbrace:Play("helpdispel")
		end
	elseif spellId == 219068 then--Dispel failure.
		warnMothersEmbraceFail:CombinedShow(0.3, args.destName)
	end
end

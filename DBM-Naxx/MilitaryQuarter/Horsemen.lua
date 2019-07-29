local mod	= DBM:NewMod("Horsemen", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(16063, 16064, 16065, 30549)
mod:SetEncounterID(1121)
mod:SetModelID(10729)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 28884 57467",
	"SPELL_CAST_SUCCESS 28832 28833 28834 28835",
	"SPELL_AURA_APPLIED_DOSE 28832 28833 28834 28835"
)

--TODO, first marks
local warnMarkSoon				= mod:NewAnnounce("WarningMarkSoon", 1, 28835, false)
local warnMeteor				= mod:NewSpellAnnounce(57467, 4)

local specWarnMarkOnPlayer		= mod:NewSpecialWarning("SpecialWarningMarkOnPlayer", nil, nil, nil, 1, 6)

local timerMarkCD				= mod:NewCDTimer(12, 28835, nil, nil, nil, 3)


function mod:OnCombatStart(delay)
	--timerMarkCD:Start()
	--warnMarkSoon:Schedule(7)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28884, 57467) then
		warnMeteor:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and self:AntiSpam(5) then
		timerMarkCD:Start()
		warnMarkSoon:Schedule(7)
	end
end


function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and args:IsPlayer() then
		if args.amount >= 4 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
			specWarnMarkOnPlayer:Play("stackhigh")
		end
	end
end


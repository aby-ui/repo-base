local mod	= DBM:NewMod(1234, "DBM-Party-WoD", 8, 559)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(77120)
mod:SetEncounterID(1762)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 155673",
	"SPELL_AURA_APPLIED 155721",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_TARGETABLE_CHANGED"
)

local warnDestructiveSmite		= mod:NewSpellAnnounce(155673, 4, nil, "Tank")
local warnReboundingBlade		= mod:NewSpellAnnounce(155705, 2, nil, false)--More for completion than anything.
local warnBlackIronCyclone		= mod:NewTargetAnnounce(155721, 3)

local specWarnBlackIronCyclone	= mod:NewSpecialWarningRun(155721, nil, nil, 2, 4, 2)
local specWarnZaela				= mod:NewSpecialWarningSwitch("ej10312", nil, nil, 4, 1, 2)

local timerDestructiveSmiteCD	= mod:NewNextTimer(15.5, 155673, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)
local timerReboundingBladeCD	= mod:NewNextTimer(10.5, 155705, nil, false)
local timerBlackIronCycloneCD	= mod:NewCDTimer(19.5, 155721, nil, nil, nil, 3)--19.5-23sec variation in phase 2. phase 1 seems diff
local timerZaelaReturns			= mod:NewTimer(26.5, "timerZaelaReturns", 166041, nil, nil, 6)

function mod:OnCombatStart(delay)
	timerReboundingBladeCD:Start(-delay)
	timerDestructiveSmiteCD:Start(10-delay)
	timerBlackIronCycloneCD:Start(18-delay)--In one pull, the first cast got interrupted
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 155673 then
		warnDestructiveSmite:Show()
		timerDestructiveSmiteCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 155721 then
		timerBlackIronCycloneCD:Start()
		if args:IsPlayer() then
			specWarnBlackIronCyclone:Show()
			specWarnBlackIronCyclone:Play("runaway")
		else
			warnBlackIronCyclone:Show(args.destName)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 155705 then
		warnReboundingBlade:Show()
		timerReboundingBladeCD:Start()
	end
end

function mod:UNIT_TARGETABLE_CHANGED()
	if UnitExists("boss1") then--Returning from air phase
		specWarnZaela:Show()
		timerBlackIronCycloneCD:Start(10)
		specWarnZaela:Play("phasechange")
	else--Leaving for air phase, may need to delay by a sec or so if boss1 still exists.
		timerZaelaReturns:Start()
		timerBlackIronCycloneCD:Cancel()
		specWarnZaela:Play("phasechange")
	end
end	

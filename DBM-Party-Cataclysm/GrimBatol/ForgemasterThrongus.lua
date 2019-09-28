local mod	= DBM:NewMod(132, "DBM-Party-Cataclysm", 3, 71)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(40177)
mod:SetEncounterID(1050)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 74981 75007 74908 74976 74987",
	"SPELL_CAST_START 75000",
	"SPELL_DAMAGE 90754",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnPickWeapon		= mod:NewSpellAnnounce(75000, 3)
local warnDualBlades		= mod:NewSpellAnnounce(74981, 3)
local warnEncumbered		= mod:NewSpellAnnounce(75007, 3)
local warnPhalanx			= mod:NewSpellAnnounce(74908, 3)
local warnDisorientingRoar	= mod:NewSpellAnnounce(74976, 3)

local specWarnCaveIn		= mod:NewSpecialWarningMove(74987, nil, nil, nil, 1, 2)
local specWarnLavaPatch		= mod:NewSpecialWarningMove(90754, nil, nil, nil, 1, 2)
local specWarnEncumbered	= mod:NewSpecialWarningRun(75007, "Tank", nil, nil, 4, 2)
local specWarnFlamingShield	= mod:NewSpecialWarningDodge(90819, nil, nil, nil, 2, 2)

local timerDualBlades		= mod:NewBuffActiveTimer(30, 74981, nil, nil, nil, 6)
local timerEncumbered		= mod:NewBuffActiveTimer(30, 75007, nil, nil, nil, 6)
local timerPhalanx			= mod:NewBuffActiveTimer(30, 74908, nil, nil, nil, 6)

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 74981 then
		warnDualBlades:Show()
		timerDualBlades:Start()
	elseif spellId == 75007 then
		if self.Options.SpecWarn75007run then
			specWarnEncumbered:Show()
			specWarnEncumbered:Play("justrun")
		else
			warnEncumbered:Show()
		end
		timerEncumbered:Start()
	elseif spellId == 74908 then
		warnPhalanx:Show()
		timerPhalanx:Start()
	elseif spellId == 74976 and self:AntiSpam(10, 1) then
		warnDisorientingRoar:Show()
	elseif spellId == 74987 and args:IsPlayer() then
		specWarnCaveIn:Show()
		specWarnCaveIn:Play("runaway")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 75000 then
		warnPickWeapon:Show()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 90754 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnLavaPatch:Show()
		specWarnLavaPatch:Play("runaway")
	end
end
--mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 75071 then--Fixate effect (cast twice during phalanx phase, when boss prepares fire breath
		specWarnFlamingShield:Show()
		specWarnFlamingShield:Play("159202")
	end
end

local mod	= DBM:NewMod(111, "DBM-Party-Cataclysm", 7, 67)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(43214)
mod:SetEncounterID(1059)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 92265",
	"SPELL_CAST_SUCCESS 92265",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnGroundphase		= mod:NewAnnounce("WarnGroundphase", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnAirphase			= mod:NewAnnounce("WarnAirphase", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnFissure			= mod:NewSpellAnnounce(80803, 3)

local specWarnEruption 		= mod:NewSpecialWarningMove(80801, nil, nil, nil, 1, 2)
local specWarnCrystalStorm 	= mod:NewSpecialWarning("specWarnCrystalStorm", nil, nil, nil, 2, 2)

local timerFissureCD		= mod:NewCDTimer(6.2, 80803, nil, nil, nil, 3)
local timerCrystalStorm		= mod:NewBuffActiveTimer(8.5, 92265, nil, nil, nil, 2)
local timerAirphase			= mod:NewTimer(50, "TimerAirphase", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)
local timerGroundphase		= mod:NewTimer(10, "TimerGroundphase", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, 6)

function mod:groundphase()
	warnGroundphase:Show()
--	timerFissureCD:Start()
	timerAirphase:Start()
	self:ScheduleMethod(50, "airphase")
end

function mod:airphase()
	timerFissureCD:Cancel()
	warnAirphase:Show()
	timerGroundphase:Start()
	self:ScheduleMethod(10, "groundphase")
end

function mod:OnCombatStart(delay)
--	timerFissureCD:Start(-delay)
	timerAirphase:Start(12.5-delay)
	self:ScheduleMethod(12.5-delay, "airphase")
	if not self:IsTrivial(90) then
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE 80800 80801",
			"SPELL_MISSED 80800 80801"
		)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if (spellId == 80800 or spellId == 80801) and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnEruption:Show()
		specWarnEruption:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_CAST_START(args)
	if args.spellId == 92265 then
		specWarnCrystalStorm:Show()
		specWarnCrystalStorm:Play("findshelter")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 92265 then
		timerCrystalStorm:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 80803 then--Lava Fissure
		warnFissure:Show()
		timerFissureCD:Start()
	end
end

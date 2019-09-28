local mod	= DBM:NewMod(1186, "DBM-Party-WoD", 1, 547)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190601211051")
mod:SetCreatureID(76177)
mod:SetEncounterID(1685)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 154477",
	"SPELL_CAST_START 155327 153994"
)

--TODO, soul vessel is probably wrong now.
--Even on CM, fights too short to get a good soulvessel timer. Still need better logs

local specWarnSWP				= mod:NewSpecialWarningDispel(154477, "Healer", nil, nil, 1, 2)
local specWarnSoulVessel		= mod:NewSpecialWarningSpell(155327, nil, nil, nil, 2, 2)
local specWarnSoulVesselEnd		= mod:NewSpecialWarningEnd(155327, nil, nil, nil, 1, 2)
local specWarnTornSpirits		= mod:NewSpecialWarningSwitch(153991, "-Healer", nil, nil, 1, 2)

local timerSoulVessel			= mod:NewBuffActiveTimer(11.5, 155327, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerSoulVesselCD			= mod:NewCDTimer(51.5, 155327, nil, nil, nil, 6)
local timerTornSpiritsCD		= mod:NewCDTimer(25.5, 153991, nil, nil, nil, 1)

function mod:OnCombatStart(delay)
	timerSoulVesselCD:Start(20-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 154477 and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		specWarnSWP:Show(args.destName)
		specWarnSWP:Play("dispelnow")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 155327 then
		specWarnSoulVessel:Show()
		specWarnSoulVesselEnd:Schedule(11.5)
		timerSoulVessel:Start()
		timerTornSpiritsCD:Start()
		timerSoulVesselCD:Start()
		specWarnSoulVessel:Play("findshadow")
		specWarnSoulVesselEnd:ScheduleVoice(11.5, "safenow")
	elseif spellId == 153994 then
		specWarnTornSpirits:Show()
		specWarnTornSpirits:Play("mobsoon")
	end
end

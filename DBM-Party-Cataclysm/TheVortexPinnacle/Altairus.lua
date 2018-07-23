local mod	= DBM:NewMod(115, "DBM-Party-Cataclysm", 8, 68)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(43873)
mod:SetEncounterID(1041)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 88282 88286",
	"SPELL_CAST_START 88308"
)

local warnBreath		= mod:NewTargetAnnounce(88308, 2)
local warnUpwind		= mod:NewSpellAnnounce(88282, 1)

local specWarnBreath	= mod:NewSpecialWarningYou(88308, false)
local specWarnBreathNear= mod:NewSpecialWarningClose(88308)
local specWarnDownwind	= mod:NewSpecialWarningMove(88286)

local timerBreathCD		= mod:NewCDTimer(10.5, 88308, nil, nil, nil, 3)

mod:AddBoolOption("BreathIcon")

local activeWind = ""

function mod:BreathTarget()
	local targetname = self:GetBossTarget(43873)
	if not targetname then return end
	if self.Options.BreathIcon then
		self:SetIcon(targetname, 8, 4)
	end
	if targetname == UnitName("player") then--Tank doesn't care about this so if your current spec is tank ignore this warning.
		specWarnBreath:Show()
	elseif self:CheckNearby(10, targetname) then
		specWarnBreathNear:Show(targetname)
	else
		warnBreath:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	activeWind = ""
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 88282 and args:IsPlayer() and activeWind ~= "up" then
		warnUpwind:Show()
		activeWind = "up"
	elseif args.spellId == 88286 and args:IsPlayer() and activeWind ~= "down" then
		specWarnDownwind:Show()
		activeWind = "down"
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 88308 then
		self:ScheduleMethod(0.2, "BreathTarget")
		timerBreathCD:Start()
	end
end

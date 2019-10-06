local mod	= DBM:NewMod(115, "DBM-Party-Cataclysm", 8, 68)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(43873)
mod:SetEncounterID(1041)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 88282 88286",
	"SPELL_CAST_START 88308"
)

local warnBreath		= mod:NewTargetNoFilterAnnounce(88308, 2)
local warnUpwind		= mod:NewSpellAnnounce(88282, 1)

local specWarnBreath	= mod:NewSpecialWarningYou(88308, "-Tank", nil, 2, 1, 2)
local specWarnBreathNear= mod:NewSpecialWarningClose(88308, nil, nil, nil, 1, 2)
local specWarnDownwind	= mod:NewSpecialWarningMove(88286, nil, nil, nil, 1, 2)

local timerBreathCD		= mod:NewCDTimer(10.5, 88308, nil, nil, nil, 3)

mod:AddSetIconOption("BreathIcon", 88308, true, false, {8})

mod.vb.activeWind = "none"

function mod:BreathTarget()
	local targetname = self:GetBossTarget(43873)
	if not targetname then return end
	if self.Options.BreathIcon then
		self:SetIcon(targetname, 8, 4)
	end
	if targetname == UnitName("player") then--Tank doesn't care about this so if your current spec is tank ignore this warning.
		specWarnBreath:Show()
		specWarnBreath:Play("targetyou")
	elseif self:CheckNearby(10, targetname) then
		specWarnBreathNear:Show(targetname)
		specWarnBreathNear:Play("runaway")
	else
		warnBreath:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.activeWind = "none"
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 88282 and args:IsPlayer() and self.vb.activeWindactiveWind ~= "up" then
		warnUpwind:Show()
		self.vb.activeWindactiveWind = "up"
	elseif args.spellId == 88286 and args:IsPlayer() and self.vb.activeWindactiveWind ~= "down" then
		specWarnDownwind:Show()
		specWarnDownwind:Play("turnaway")
		self.vb.activeWindactiveWind = "down"
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 88308 then
		self:ScheduleMethod(0.2, "BreathTarget")
		timerBreathCD:Start()
	end
end

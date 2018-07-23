local mod	= DBM:NewMod(103, "DBM-Party-Cataclysm", 9, 65)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(40825, 40788)
mod:SetMainBossID(40788)-- 40788 = Mindbender Ghur'sha
mod:SetEncounterID(1046)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 76170 76165 76207 76307 76339",
	"SPELL_AURA_REMOVED 76170 76616",
	"SPELL_CAST_START 76171 84931 76307",
	"SPELL_CAST_SUCCESS 76234",
	"UNIT_DIED"
)

local warnMagmaSplash		= mod:NewTargetAnnounce(76170, 3)
local warnEmberstrike		= mod:NewTargetAnnounce(76165, 3)
local warnEarthShards		= mod:NewTargetAnnounce(84931, 2)
local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnEnslave			= mod:NewTargetAnnounce(76207, 2)
local warnMindFog			= mod:NewSpellAnnounce(76234, 3)
local warnAgony				= mod:NewSpellAnnounce(76339, 3)

local specWarnLavaBolt		= mod:NewSpecialWarningInterrupt(76171)
local specWarnAbsorbMagic	= mod:NewSpecialWarningReflect(76307, "SpellCaster")
local specWarnEarthShards	= mod:NewSpecialWarningMove(84931)

local timerMagmaSplash		= mod:NewBuffActiveTimer(10, 76170)
local timerAbsorbMagic		= mod:NewBuffActiveTimer(3, 76307, nil, "SpellCaster", 2, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerMindFog			= mod:NewBuffActiveTimer(20, 76234)

local magmaTargets = {}
local magmaCount = 0

local function showMagmaWarning()
	warnMagmaSplash:Show(table.concat(magmaTargets, "<, >"))
	table.wipe(magmaTargets)
	timerMagmaSplash:Start()
end

function mod:EarthShardsTarget()
	local targetname = self:GetBossTarget(40825)
	if not targetname then return end
	warnEarthShards:Show(targetname)
	if targetname == UnitName("player") then
		specWarnEarthShards:Show()
	end
end

function mod:OnCombatStart(delay)
	table.wipe(magmaTargets)
	magmaCount = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 76170 then
		magmaCount = magmaCount + 1
		magmaTargets[#magmaTargets + 1] = args.destName
		self:Unschedule(showMagmaWarning)
		self:Schedule(0.3, showMagmaWarning)
	elseif args.spellId == 76165 then
		warnEmberstrike:Show(args.destName)
	elseif args.spellId == 76207 then
		warnEnslave:Show(args.destName)
	elseif args.spellId == 76307 then
		timerAbsorbMagic:Start()
	elseif args.spellId == 76339 then
		warnAgony:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 76170 then
		magmaCount = magmaCount - 1
		if magmaCount == 0 then
			timerMagmaSplash:Cancel()
		end
	elseif args.spellId == 76616 then
		if args.destName == L.name then
			warnPhase2:Show(2)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 76171 then
		specWarnLavaBolt:Show(args.sourceName)
	elseif args.spellId == 84931 then
		self:ScheduleMethod(0.1, "EarthShardsTarget")
	elseif args.spellId == 76307 then
		specWarnAbsorbMagic:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 76234 then
		warnMindFog:Show()
		timerMindFog:Start()
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 40788 then
		DBM:EndCombat(self)
	end
end

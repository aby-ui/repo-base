local mod	= DBM:NewMod(172, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(43296)
mod:SetEncounterID(1023)
mod:SetZone()
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_ChimaronIntro01.ogg", nil)
--Long: Ah, Chimaeron, truly a living testament to my scientific prowess. I reworked and twisted his form countless times over the years, and the final result is truly something to behold.
--Short: There isn't one

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_HEALTH boss1"
)

mod:RegisterEvents(
	"UNIT_DIED"
)

local warnCausticSlime		= mod:NewTargetAnnounce(82935, 3)
local warnBreak				= mod:NewStackAnnounce(82881, 3, nil, "Tank|Healer")
local warnDoubleAttack		= mod:NewSpellAnnounce(88826, 4, nil, "Tank|Healer")
local warnMassacre			= mod:NewSpellAnnounce(82848, 4)
local warnFeud				= mod:NewSpellAnnounce(88872, 3)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 3)
local warnPhase2			= mod:NewPhaseAnnounce(2)

local specWarnFailure		= mod:NewSpecialWarningSpell(88853, nil, nil, nil, 2)
local specWarnMassacre		= mod:NewSpecialWarningSpell(82848, "Healer")
local specWarnDoubleAttack	= mod:NewSpecialWarningSpell(88826, "Tank")

local timerBreak			= mod:NewTargetTimer(60, 82881)
local timerBreakCD			= mod:NewNextTimer(15, 82881)--Also double attack CD
local timerMassacre			= mod:NewCastTimer(4, 82848)
local timerMassacreNext		= mod:NewNextTimer(30, 82848)
local timerCausticSlime		= mod:NewNextTimer(19, 82935)--always 19 seconds after massacre.
local timerFailure			= mod:NewBuffActiveTimer(26, 88853)
local timerFailureNext		= mod:NewNextTimer(25, 88853)

local berserkTimer			= mod:NewBerserkTimer(450)--Heroic

mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("SetIconOnSlime", false)
mod:AddBoolOption("InfoFrame", "Healer")

local prewarnedPhase2 = false
local phase2 = false
local botOffline = false
local slimeTargets = {}
local slimeTargetIcons = {}
local massacreCast = 0

local function showSlimeWarning()
	warnCausticSlime:Show(table.concat(slimeTargets, "<, >"))
	table.wipe(slimeTargets)
end

-- Chimaeron bots goes offline after massacre 2~3 cast. after 2 massacre casts if not bot goes offline, 3rd massacre cast 100% bot goes offline, this timer supports this.
local function failureCheck()
	if not botOffline and massacreCast >= 2 then 
		timerFailureNext:Start()
	end
end

local function ClearSlimeTargets()
	table.wipe(slimeTargetIcons)
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(DBM:GetUnitFullName(v1)) < DBM:GetRaidSubgroup(DBM:GetUnitFullName(v2))
	end
	function mod:SetSlimeIcons()
		table.sort(slimeTargetIcons, sort_by_group)
		local slimeIcon = 8
		for i, v in ipairs(slimeTargetIcons) do
			self:SetIcon(v, slimeIcon, 3)
			slimeIcon = slimeIcon - 1
		end
		self:Schedule(1.5, ClearSlimeTargets)--Table wipe delay so if icons go out too early do to low fps or bad latency, when they get new target on table, resort and reapplying should auto correct teh icon within .2-.4 seconds at most.
	end
end

function mod:OnCombatStart(delay)
	timerMassacreNext:Start(26-delay)
	timerBreakCD:Start(4.5-delay)
	prewarnedPhase2 = false
	botOffline = false
	massacreCast = 0
	phase2 = false
	table.wipe(slimeTargets)
	table.wipe(slimeTargetIcons)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(6)
	end
	berserkTimer:Start(-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.HealthInfo)
		DBM.InfoFrame:Show(5, "health", 10000)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 82881 then
		if not phase2 then
			warnBreak:Show(args.destName, args.amount or 1)
			timerBreak:Start(args.destName)
			timerBreakCD:Start()
		end
	elseif args.spellId == 88826 then
		warnDoubleAttack:Show()
		specWarnDoubleAttack:Show()
	elseif args.spellId == 88853 then
		botOffline = true
		massacreCast = 0
		specWarnFailure:Show()
		timerFailure:Start()
	elseif not botOffline and args.spellId == 82935 and args:IsDestTypePlayer() then
		slimeTargets[#slimeTargets + 1] = args.destName
		if self.Options.SetIconOnSlime then
			table.insert(slimeTargetIcons, DBM:GetRaidUnitId(args.destName))
			self:UnscheduleMethod("SetSlimeIcons")
			if self:LatencyCheck() then--lag can fail the icons so we check it before allowing.
				self:ScheduleMethod(0.5, "SetSlimeIcons")--Still seems touchy and .3 is too fast even on a 70ms connection in rare cases so back to .5
			end
		end
		self:Unschedule(showSlimeWarning)
		self:Schedule(0.5, showSlimeWarning)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REFRESH(args)
	if args.spellId == 82881 then--Once a tank is at 4 stacks, it just spell aura refreshes instead. Track this so we can keep an accurate CD and debuff timer.
		timerBreak:Start(args.destName)
		timerBreakCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 88853 then
		botOffline = false
	elseif args.spellId == 82881 then
		timerBreak:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 82848 then
		warnMassacre:Show()
		specWarnMassacre:Show()
		timerMassacre:Start()
		timerMassacreNext:Start()
		timerCausticSlime:Start()--Always 19 seconds after massacre.
		timerBreakCD:Start(14)--Massacre resets break timer, although  usualy the CDs line up anyways, they won't for 3rd break.
		massacreCast = massacreCast + 1
		self:Schedule(5, failureCheck)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 88872 then
		warnFeud:Show()
	elseif args.spellId == 82934 then
		phase2 = true
		warnPhase2:Show()
		timerCausticSlime:Cancel()
		timerMassacreNext:Cancel()
		timerFailureNext:Cancel()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 43296 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 40 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 22 and h < 25 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 43296 then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

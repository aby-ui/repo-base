local mod	= DBM:NewMod(1216, "DBM-Party-WoD", 1, 547)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(75927)
mod:SetEncounterID(1678)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 153392 153234",
	"SPELL_AURA_REMOVED 153392 153764",
	"SPELL_CAST_START 153764 154221 157173",
	"SPELL_PERIODIC_DAMAGE 153616 153726",
	"SPELL_ABSORBED 153616 153726",
	"SPELL_SUMMON 164081",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnCurtainOfFlame			= mod:NewTargetAnnounce(153396, 4)
local warnFelLash					= mod:NewTargetAnnounce(153234, 3, nil, "Tank|Healer", 2)
local warnFelPool					= mod:NewSpellAnnounce(153616, 1)

local specWarnCurtainOfFlame		= mod:NewSpecialWarningMoveAway(153396, nil, nil, nil, 1, 2)
local specWarnCurtainOfFlameNear	= mod:NewSpecialWarningClose(153396, nil, nil, nil, 1, 2)
local yellWarnCurtainOfFlame		= mod:NewYell(153396)
local specWarnFelLash				= mod:NewSpecialWarningYou(153234, nil, nil, 2, 1, 2)
local specWarnFelStomp				= mod:NewSpecialWarningDodge(157173, "Melee", nil, 2, 1, 2)
local specWarnClawsOfArgus			= mod:NewSpecialWarningSpell(153764, nil, nil, nil, 1, 2)
local specWarnClawsOfArgusEnd		= mod:NewSpecialWarningEnd(153764, nil, nil, nil, 1, 2)
local specWarnSummonFelguard		= mod:NewSpecialWarningSwitch(164081, "Tank", nil, nil, 1, 2)
local specWarnFelblast				= mod:NewSpecialWarningInterrupt(154221, "HasInterrupt", nil, 2, 1, 2)--Very spammy
local specWarnFelPool				= mod:NewSpecialWarningMove(153616, nil, nil, nil, 1, 8)
local specWarnFelSpark				= mod:NewSpecialWarningMove(153726, nil, nil, nil, 1, 8)

local timerCurtainOfFlameCD			= mod:NewNextTimer(20, 153396, nil, nil, nil, 3, nil, nil, nil, 2, 4)--20sec cd but can be massively delayed by adds phases
local timerFelLash					= mod:NewTargetTimer(7.5, 153234, nil, "Tank|Healer", 2, 5)
local timerClawsOfArgus				= mod:NewBuffActiveTimer(20, 153764, nil, nil, nil, 6)
local timerClawsOfArgusCD			= mod:NewNextTimer(70, 153764, nil, nil, nil, 6, nil, nil, nil, 1, 4)

mod:AddRangeFrameOption(5, 153396)

mod.vb.debuffCount = 0
mod.vb.flamesCast = 2
local curtainDebuff = DBM:GetSpellInfo(153396)
local debuffFilter
do
	debuffFilter = function(uId)
		return DBM:UnitDebuff(uId, curtainDebuff)
	end
end

function mod:OnCombatStart(delay)
	self.vb.debuffCount = 0
	self.vb.flamesCast = 2--Set to 2 on pull to offset first argus
	timerCurtainOfFlameCD:Start(16-delay)
	timerClawsOfArgusCD:Start(34-delay)
	specWarnClawsOfArgus:ScheduleVoice(27.5-delay, "mobsoon")
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 153396 then--if claws of argus is less than 20 seconds away, don't start CurtainOfFlame timer
		self.vb.flamesCast = self.vb.flamesCast + 1
		if self.vb.flamesCast < 3 then
			timerCurtainOfFlameCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 153392 then
		self.vb.debuffCount = self.vb.debuffCount + 1
		local targetname = args.destName
		warnCurtainOfFlame:CombinedShow(0.5, targetname)
		if args:IsPlayer() then
			specWarnCurtainOfFlame:Show()
			yellWarnCurtainOfFlame:Yell()
			specWarnCurtainOfFlame:Play("runout")
		else
			if self:CheckNearby(5, targetname) then
				specWarnCurtainOfFlameNear:Show(targetname)
				specWarnCurtainOfFlameNear:Play("runaway")
			end
		end
		if self.Options.RangeFrame then
			if DBM:UnitDebuff("player", curtainDebuff) then--You have debuff, show everyone
				DBM.RangeCheck:Show(5, nil)
			else--You do not have debuff, only show players who do
				DBM.RangeCheck:Show(5, debuffFilter)
			end
		end
	elseif spellId == 153234 then
		timerFelLash:Start(args.destName)
		if args:IsPlayer() then
			specWarnFelLash:Show()
			specWarnFelLash:Play("targetyou")
		else
			warnFelLash:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 153392 then
		self.vb.debuffCount = self.vb.debuffCount - 1
		if self.Options.RangeFrame and self.vb.debuffCount == 0 then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 153764 then--Claws of Argus ending
		self.vb.flamesCast = 0
		specWarnClawsOfArgusEnd:Show()
		specWarnClawsOfArgusEnd:Play("phasechange")
		timerCurtainOfFlameCD:Start(7)
		timerClawsOfArgusCD:Start()
		specWarnClawsOfArgus:ScheduleVoice(63.5, "mobsoon")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 153764 then
		specWarnClawsOfArgus:Show()
		specWarnClawsOfArgus:Play("killmob")
		timerClawsOfArgus:Start()
	elseif spellId == 154221 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFelblast:Show(args.sourceName)
		if self:IsTank() then
			specWarnFelblast:Play("kickcast")
		else
			specWarnFelblast:Play("helpkick")
		end
	elseif spellId == 157173 then
		specWarnFelStomp:Show()
		specWarnFelStomp:Play("shockwave")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 153616 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnFelPool:Show()
		specWarnFelPool:Play("watchfeet")
	elseif spellId == 153726 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnFelSpark:Show()
		specWarnFelSpark:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_SUMMON(args)
	if args.spellId == 164081 then
		specWarnSummonFelguard:Show()
		specWarnSummonFelguard:Play("bigmob")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 153500 then
		warnFelPool:Show()
	end
end

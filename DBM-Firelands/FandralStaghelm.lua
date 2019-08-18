local mod	= DBM:NewMod(197, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190817195516")
mod:SetCreatureID(52571)
mod:SetEncounterID(1185)
mod:SetZone()
mod:SetUsedIcons(8)
--mod:SetModelSound("Sound\\Creature\\FandralFlameDruid\\VO_FL_FANDRAL_GATE_INTRO_01.ogg", "Sound\\Creature\\FandralFlameDruid\\VO_FL_FANDRAL_KILL_05.ogg")
--Long: Well, well. I admire your tenacity. Baleroc stood guard over this keep for a thousand mortal lifetimes.
--Short: *Laughs, Burn

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 98451",
	"SPELL_CAST_SUCCESS 98476",
	"SPELL_AURA_APPLIED 98374 98379 97238 97235 98535 98584 98450",
	"SPELL_AURA_APPLIED_DOSE 97238 97235 98584",
	"SPELL_AURA_REMOVED 98450"
)

--[[
ability.id = 98451 and type = "begincast"
 or ability.id = 98476 and type = "cast"
 or (ability.id = 98374 or ability.id = 98379 or ability.id = 97238) and (type = "applybuff" or type ="applybuffdose")
--]]
local warnAdrenaline			= mod:NewStackAnnounce(97238, 3)
local warnFury					= mod:NewStackAnnounce(97235, 3)
local warnLeapingFlames			= mod:NewTargetAnnounce(98476, 3)
local warnOrbs					= mod:NewCastAnnounce(98451, 4)

local specWarnLeapingFlamesCast	= mod:NewSpecialWarningYou(98476, nil, nil, nil, 1, 2)
local yellLeapingFlames			= mod:NewYell(98476)
local specWarnLeapingFlamesNear	= mod:NewSpecialWarningClose(98476, nil, nil, nil, 1, 2)
local specWarnLeapingFlames		= mod:NewSpecialWarningMove(98535, nil, nil, nil, 1, 2)
local specWarnSearingSeed		= mod:NewSpecialWarningMoveAway(98450, nil, nil, nil, 3, 2)
local specWarnOrb				= mod:NewSpecialWarningStack(98584, true, 4, nil, nil, 1, 6)

local timerOrbActive			= mod:NewBuffActiveTimer(64, 98451, nil, nil, nil, 6)
local timerOrb					= mod:NewBuffFadesTimer(6, 98584, nil, nil, nil, 5)
local timerSearingSeed			= mod:NewBuffFadesTimer(60, 98450, nil, nil, nil, 3)
local timerNextSpecial			= mod:NewTimer(4, "timerNextSpecial", 97238)--This one stays localized because it's 1 timer used for two abilities

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrameSeeds", true)
mod:AddBoolOption("RangeFrameCat", false)--Diff options for each ability cause seeds strat is pretty universal, don't blow up raid, but leaps may or may not use a stack strategy, plus melee will never want it on by default.
mod:AddSetIconOption("IconOnLeapingFlames", 98476, false, false, {8})

mod.vb.abilityCount = 0
mod.vb.recentlyJumped = false
mod.vb.kitty = false
local leap, swipe, seedsDebuff = DBM:GetSpellInfo(98535), DBM:GetSpellInfo(98474), DBM:GetSpellInfo(98450)

local abilityTimers = {
	[0] = 17.3,--Still The same baseline.
	[1] = 14.4,--Everything here onward nerfed in 4.3+
	[2] = 12,
	[3] = 10.9,
	[4] = 9.6,
	[5] = 8.4,
	[6] = 8.4,
	[7] = 7.2,
	[8] = 7.2,--Everyting up to here confirmed by MANY logs
	[9] = 6.0,
	[10]= 6.0,
	[11]= 6.0,
	[12]= 6.0,
	[13]= 4.9,
	[14]= 4.9,
	[15]= 4.9,
	[16]= 4.9,
	[17]= 4.9,
}
--caps to 3.7 at 18 stacks.

local function clearLeapWarned(self)
	self.vb.recentlyJumped = false
end

function mod:LeapingFlamesTarget(targetname, uId)
	if not targetname then return end
	if self.Options.IconOnLeapingFlames then
		self:SetIcon(targetname, 8, 5)	-- 5seconds should be long enough to notice
	end
	if targetname == UnitName("player") then
		self.vb.recentlyJumped = true--Anti Spam
		specWarnLeapingFlamesCast:Show()
		specWarnLeapingFlamesCast:Play("runaway")
		yellLeapingFlames:Yell()
		self:Schedule(4, clearLeapWarned, self)--So you don't get move warning too from debuff.
	elseif self:CheckNearby(12, targetname) then
		self.vb.recentlyJumped = true--Anti Spam
		specWarnLeapingFlamesNear:Show(targetname)
		specWarnLeapingFlamesNear:Play("runaway")
		self:Schedule(2.5, clearLeapWarned, self)--Clear it a little faster for near warnings though, cause  you definitely don't need 4 seconds to move if it wasn't even on YOU.
	else
		warnLeapingFlames:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	self.vb.abilityCount = 0
	self.vb.kitty = false
end

function mod:OnCombatEnd()
	if self.Options.RangeFrameSeeds or self.Options.RangeFrameCat then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 98451 then
		warnOrbs:Show()
		timerOrbActive:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 98476 then
		self:BossTargetScanner(args.sourceGUID, "LeapingFlamesTarget", 0.05, 16, true, nil, nil, nil, true)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 98374 then		-- Cat Form
		self.vb.kitty = true
		self.vb.abilityCount = 0
		timerNextSpecial:Cancel()
		timerNextSpecial:Start(abilityTimers[self.vb.abilityCount], leap, self.vb.abilityCount+1)
		if self.Options.RangeFrameCat then
			DBM.RangeCheck:Show(10)
		end
	elseif spellId == 98379 then	-- Scorpion Form
		self.vb.kitty = false
		self.vb.abilityCount = 0
		timerNextSpecial:Cancel()
		timerNextSpecial:Start(abilityTimers[self.vb.abilityCount], swipe, self.vb.abilityCount+1)
		if self.Options.RangeFrameCat and not DBM:UnitDebuff("player", seedsDebuff) then--Only hide range finder if you do not have seed.
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 97238 then
		self.vb.abilityCount = (args.amount or 1)--This should change your ability account to his current stack, which is disconnect friendly.
		warnAdrenaline:Show(args.destName, args.amount or 1)
		timerNextSpecial:Start(abilityTimers[self.vb.abilityCount] or 3.7, self.vb.kitty and leap or swipe, self.vb.abilityCount+1)
	elseif spellId == 97235 then
		warnFury:Show(args.destName, args.amount or 1)
	elseif spellId == 98535 and args:IsPlayer() and not self.vb.recentlyJumped then
		specWarnLeapingFlames:Show()--You stood in the fire!
		specWarnLeapingFlames:Play("runaway")
	elseif spellId == 98584 and args:IsPlayer() then
		if (args.amount or 1) >= 4 then
			specWarnOrb:Show(args.amount)
			specWarnOrb:Play("stackhigh")
		end
		timerOrb:Stop()
		timerOrb:Start()
	elseif spellId == 98450 and args:IsPlayer() then
		local _, _, _, _, duration, expires = DBM:UnitDebuff("player", args.spellName)--Find out what our specific seed timer is
		if expires then
			local remaining = expires - GetTime()
			specWarnSearingSeed:Schedule(remaining-5)	-- Show "move away" warning 5secs before explode
			specWarnSearingSeed:ScheduleVoice(remaining-5, "runout")
			timerSearingSeed:Start(remaining)
			if self.Options.RangeFrameSeeds then
				DBM.RangeCheck:Show(12)
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 98450 and args:IsPlayer() then
		specWarnSearingSeed:Cancel()
		specWarnSearingSeed:CancelVoice()
		timerSearingSeed:Cancel()
		if self.Options.RangeFrameSeeds then
			DBM.RangeCheck:Hide()
		end
	end
end

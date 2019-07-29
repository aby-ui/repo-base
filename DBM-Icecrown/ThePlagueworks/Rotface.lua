local mod	= DBM:NewMod("Rotface", "DBM-Icecrown", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(36627)
mod:SetEncounterID(1104)
mod:SetModelID(31005)
mod:SetUsedIcons(7, 8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 69508 69774 69839",
	"SPELL_AURA_APPLIED 69774 69760 69558 69674 72272",
	"SPELL_AURA_APPLIED_DOSE 69558",
	"SPELL_CAST_SUCCESS 72272",
	"SPELL_AURA_REMOVED 69674",
	"CHAT_MSG_MONSTER_YELL"
)

local warnSlimeSpray			= mod:NewSpellAnnounce(69508, 2)
local warnMutatedInfection		= mod:NewTargetAnnounce(69674, 4)
local warnRadiatingOoze			= mod:NewSpellAnnounce(69760, 3)
local warnOozeSpawn				= mod:NewAnnounce("WarnOozeSpawn", 1)
local warnStickyOoze			= mod:NewSpellAnnounce(69774, 1)
local warnUnstableOoze			= mod:NewStackAnnounce(69558, 2)
local warnVileGas				= mod:NewTargetAnnounce(72272, 3)

local specWarnMutatedInfection	= mod:NewSpecialWarningYou(69674, nil, nil, nil, 1, 2)
local specWarnStickyOoze		= mod:NewSpecialWarningMove(69774, nil, nil, nil, 1, 2)
local specWarnOozeExplosion		= mod:NewSpecialWarningDodge(69839, nil, nil, nil, 1, 2)
local specWarnSlimeSpray		= mod:NewSpecialWarningSpell(69508, false, nil, nil, 1, 2)--For people that need a bigger warning to move
local specWarnRadiatingOoze		= mod:NewSpecialWarningSpell(69760, "-Tank", nil, nil, 1, 2)
local specWarnLittleOoze		= mod:NewSpecialWarning("SpecWarnLittleOoze", false, nil, nil, 1, 2)
local specWarnVileGas			= mod:NewSpecialWarningYou(72272, nil, nil, nil, 1, 2)

local timerStickyOoze			= mod:NewNextTimer(16, 69774, nil, "Tank", nil, 5)
local timerWallSlime			= mod:NewNextTimer(20, 69789)
local timerSlimeSpray			= mod:NewNextTimer(21, 69508, nil, nil, nil, 3)
local timerMutatedInfection		= mod:NewTargetTimer(12, 69674, nil, nil, nil, 3)
local timerOozeExplosion		= mod:NewCastTimer(4, 69839, nil, nil, nil, 2)
local timerVileGasCD			= mod:NewNextTimer(30, 72272, nil, nil, nil, 3)

mod:AddBoolOption("RangeFrame", "Ranged")
mod:AddBoolOption("InfectionIcon", true)

local RFVileGasTargets	= {}
local spamOoze = 0
mod.vb.InfectionIcon = 8

local function warnRFVileGasTargets()
	warnVileGas:Show(table.concat(RFVileGasTargets, "<, >"))
	table.wipe(RFVileGasTargets)
	timerVileGasCD:Start()
end

local function WallSlime(self)
	self:Unschedule(WallSlime)
	if self:IsInCombat() then
		timerWallSlime:Start()
		self:Schedule(20, WallSlime, self)
	end
end

function mod:OnCombatStart(delay)
	timerWallSlime:Start(25-delay)
	self:Schedule(25-delay, WallSlime, self)
	self.vb.InfectionIcon = 8
	spamOoze = 0
	if self:IsDifficulty("heroic10", "heroic25") then
		timerVileGasCD:Start(22-delay)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	end
	if not self:IsTrivial(100) then
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE 69761",
			"SPELL_MISSED 69761",
			"SWING_DAMAGE",
			"SWING_MISSED"
		)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 69508 then
		timerSlimeSpray:Start()
		if not self:IsTrivial(100) and self.Options.SpecWarn69508spell then
			specWarnSlimeSpray:Show()
		else
			warnSlimeSpray:Show()
		end
	elseif args.spellId == 69774 then
		timerStickyOoze:Start()
		warnStickyOoze:Show()
	elseif args.spellId == 69839 and not self:IsTrivial(100) then --Unstable Ooze Explosion (Big Ooze)
		if GetTime() - spamOoze < 4 then --This will prevent spam but breaks if there are 2 oozes. GUID work is required
			specWarnOozeExplosion:Cancel()
			specWarnOozeExplosion:CancelVoice()
		end
		if GetTime() - spamOoze < 4 or GetTime() - spamOoze > 5 then --Attempt to ignore a cast that may fire as an ooze is already exploding.
			timerOozeExplosion:Start()
			specWarnOozeExplosion:Schedule(4)
			specWarnOozeExplosion:ScheduleVoice(4, "watchstep")
		end
		spamOoze = GetTime()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 69774 and args:IsPlayer() then
		specWarnStickyOoze:Show()
		specWarnStickyOoze:Play("runaway")
	elseif args.spellId == 69760 then
		warnRadiatingOoze:Show()
	elseif args.spellId == 69558 then
		warnUnstableOoze:Show(args.destName, args.amount or 1)
	elseif args.spellId == 69674 then
		timerMutatedInfection:Start(args.destName)
		if args:IsPlayer() then
			specWarnMutatedInfection:Show()
			specWarnMutatedInfection:Play("movetotank")
		else
			warnMutatedInfection:Show(args.destName)
		end
		if self.Options.InfectionIcon then
			self:SetIcon(args.destName, self.vb.InfectionIcon, 12)
		end
		if self.vb.InfectionIcon == 8 then	-- After ~3mins there is a chance 2 ppl will have the debuff, so we are alternating between 2 icons
			self.vb.InfectionIcon = 7
		else
			self.vb.InfectionIcon = 8
		end
	elseif args.spellId == 72272 and args:IsDestTypePlayer() then	-- Vile Gas(Heroic Rotface only, 25 man spellid the same as 10?)
		RFVileGasTargets[#RFVileGasTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnVileGas:Show()
			specWarnVileGas:Play("scatter")
		end
		self:Unschedule(warnRFVileGasTargets)
		self:Schedule(2.5, warnRFVileGasTargets) -- Yes it does take this long to travel to all 3 targets sometimes, qq.
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 72272 then
		timerVileGasCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 69674 then
		timerMutatedInfection:Cancel(args.destName)
		warnOozeSpawn:Show()
		if self.Options.InfectionIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, _, destGUID, _, _, _, spellId)
	if spellId == 69761 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then
		specWarnRadiatingOoze:Show()
		specWarnRadiatingOoze:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SWING_DAMAGE(sourceGUID, sourceName, sourceFlags, _, destGUID)
	if self:GetCIDFromGUID(sourceGUID) == 36897 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then --Little ooze hitting you
		specWarnLittleOoze:Show()
		specWarnLittleOoze:Play("keepmove")
	end
end
mod.SWING_MISSED = mod.SWING_DAMAGE

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.YellSlimePipes1 or msg:find(L.YellSlimePipes1)) or (msg == L.YellSlimePipes2 or msg:find(L.YellSlimePipes2)) then
		WallSlime(self)
	end
end

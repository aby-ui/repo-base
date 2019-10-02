local mod	= DBM:NewMod("Onyxia", "DBM-Onyxia")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190921192929")
mod:SetCreatureID(10184)
mod:SetEncounterID(1084)
mod:SetZone()
mod:SetModelID(8570)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68958 17086 18351 18564 18576 18584 18596 18609 18617 18435 68959 18431 18500 18392",
	"SPELL_CAST_SUCCESS 19633",
	"SPELL_DAMAGE 68867",
	"UNIT_DIED",
	"UNIT_HEALTH boss1"
)

--local warnWhelpsSoon		= mod:NewAnnounce("WarnWhelpsSoon", 1, 69004)
local warnWingBuffet		= mod:NewSpellAnnounce(18500, 2, nil, "Tank")
local warnKnockAway			= mod:NewTargetNoFilterAnnounce(19633, 2, nil, false)
local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnFireball			= mod:NewTargetNoFilterAnnounce(18392, 2, nil, false)
local warnPhase3			= mod:NewPhaseAnnounce(3)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2)
local warnPhase3Soon		= mod:NewPrePhaseAnnounce(3)

local specWarnBreath		= mod:NewSpecialWarningSpell(18584, nil, nil, nil, 2, 2)
local specWarnBellowingRoar	= mod:NewSpecialWarningSpell(18431, nil, nil, nil, 2, 2)
local yellFireball				= mod:NewYell(18392)
local specWarnBlastNova		= mod:NewSpecialWarningRun(68958, "Melee", nil, nil, 4, 2)
local specWarnAdds			= mod:NewSpecialWarningAdds(68959, "-Healer", nil, nil, 1, 2)

local timerNextFlameBreath	= mod:NewCDTimer(13.3, 18435, nil, "Tank", 2, 5)--13.3-20 Breath she does on ground in frontal cone.
local timerNextDeepBreath	= mod:NewCDTimer(35, 18584, nil, nil, nil, 3)--Range from 35-60seconds in between based on where she moves to.
local timerBreath			= mod:NewCastTimer(8, 18584, nil, nil, nil, 3)
--local timerWhelps			= mod:NewTimer(105, "TimerWhelps", 10697, nil, nil, 1)
local timerBigAddCD			= mod:NewAddsTimer(44.9, 68959, nil, "-Healer")

mod:AddBoolOption("SoundWTF3", true, "sound")

mod.vb.warned_preP2 = false
mod.vb.warned_preP3 = false
mod.vb.phase = 0
--mod.vb.whelpsCount = 0

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	--self.vb.whelpsCount = 0
    self.vb.warned_preP2 = false
	self.vb.warned_preP3 = false
	if self.Options.SoundWTF3 then
		DBM:PlaySoundFile("Interface\\AddOns\\DBM-Onyxia\\sounds\\dps-very-very-slowly.ogg")
		self:Schedule(20, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\hit-it-like-you-mean-it.ogg")
		self:Schedule(30, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\now-hit-it-very-hard-and-fast.ogg")
	end
end

--70, 60,
function mod:Whelps()--Not right, need to fix
	if self:IsInCombat() then
--		self.vb.whelpsCount = self.vb.whelpsCount + 1
--		timerWhelps:Start()
--		warnWhelpsSoon:Schedule(60)
		self:ScheduleMethod(70, "Whelps")
		-- we replay sounds as long as p2 is running
		if self.Options.SoundWTF3 then
			DBM:PlaySoundFile("Interface\\AddOns\\DBM-Onyxia\\sounds\\i-dont-see-enough-dots.ogg")
			self:Schedule(35, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\throw-more-dots.ogg")
		end
	end
end

function mod:FireballTarget(targetname, uId)
	if not targetname then return end
	warnFireball:Show(targetname)
	if targetname == UnitName("player") then
		yellFireball:Yell()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPull and not self:IsInCombat() then
		DBM:StartCombat(self, 0)
	elseif msg == L.YellP2 or msg:find(L.YellP2) then
		self:SendSync("Phase2")
	elseif msg == L.YellP3 or msg:find(L.YellP3) then
		self:SendSync("Phase3")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 68958 then
        specWarnBlastNova:Show()
        specWarnBlastNova:Play("justrun")
	elseif args:IsSpellID(17086, 18351, 18564, 18576) or args:IsSpellID(18584, 18596, 18609, 18617) then	-- 1 ID for each direction
		specWarnBreath:Show()
		specWarnBreath:Play("breathsoon")
		timerBreath:Start()
		timerNextDeepBreath:Start()
	elseif args.spellId == 18435 then        -- Flame Breath (Ground phases)
		timerNextFlameBreath:Start()
	elseif args.spellId == 68959 then--Ignite Weapon (Onyxian Lair Guard spawn)
		specWarnAdds:Show()
		specWarnAdds:Play("bigmob")
		timerBigAddCD:Start()
	elseif args.spellId == 18431 then
		specWarnBellowingRoar:Show()
		specWarnBellowingRoar:Play("fearsoon")
	elseif args.spellId == 18500 then
		warnWingBuffet:Show()
	elseif args.spellId == 18392 then
		self:BossTargetScanner(args.sourceGUID, "FireballTarget", 0.15, 12)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellName = args.spellId
	if spellId == 19633 then
		warnKnockAway:Show(args.destName)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 68867 and destGUID == UnitGUID("player") and self.Options.SoundWTF3 then		-- Tail Sweep
		DBM:PlaySoundFile("Interface\\AddOns\\DBM-Onyxia\\sounds\\watch-the-tail.ogg")
	end
end

function mod:UNIT_DIED(args)
	if self:IsInCombat() and args:IsPlayer() and self.Options.SoundWTF3 then
		DBM:PlaySoundFile("Interface\\AddOns\\DBM-Onyxia\\sounds\\thats-a-fucking-fifty-dkp-minus.ogg")
	end
end

function mod:UNIT_HEALTH(uId)
	if self.vb.phase == 1 and not self.vb.warned_preP2 and self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.70 then
		self.vb.warned_preP2 = true
		warnPhase2Soon:Show()
	elseif self.vb.phase == 2 and not self.vb.warned_preP3 and self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.45 then
		self.vb.warned_preP3 = true
		warnPhase3Soon:Show()
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "Phase2" then
		self.vb.phase = 2
		self.vb.whelpsCount = 0
		warnPhase2:Show()
		--timerBigAddCD:Start(65)
		--timerNextDeepBreath:Start(67)
		timerNextFlameBreath:Cancel()
		self:ScheduleMethod(5, "Whelps")
		if self.Options.SoundWTF3 then
			self:Schedule(10, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\throw-more-dots.ogg")
			self:Schedule(17, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\whelps-left-side-even-side-handle-it.ogg")
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	elseif msg == "Phase3" then
		self.vb.phase = 3
		warnPhase3:Show()
		self:UnscheduleMethod("Whelps")
		--timerWhelps:Stop()
		--timerNextDeepBreath:Stop()
		--timerBigAddCD:Stop()
		--warnWhelpsSoon:Cancel()
		if self.Options.SoundWTF3 then
			DBM:PlaySoundFile("Interface\\AddOns\\DBM-Onyxia\\sounds\\dps-very-very-slowly.ogg")
			self:Schedule(30, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\now-hit-it-very-hard-and-fast.ogg")
   			self:Schedule(40, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\i-dont-see-enough-dots.ogg")
			self:Schedule(50, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\hit-it-like-you-mean-it.ogg")
			self:Schedule(65, DBM.PlaySoundFile, DBM, "Interface\\AddOns\\DBM-Onyxia\\sounds\\throw-more-dots.ogg")
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

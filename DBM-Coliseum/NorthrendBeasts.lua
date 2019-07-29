local mod	= DBM:NewMod("NorthrendBeasts", "DBM-Coliseum")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(34796, 35144, 34799, 34797)
--mod:SetEncounterID(1088)--Buggy, never enable this
mod:SetMinSyncRevision(104)
mod:SetModelID(21601)
mod:SetMinCombatTime(30)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 66331 66759 66823 66869 66758 66636 68335",
	"SPELL_AURA_APPLIED_DOSE 66331 66636",
	"SPELL_CAST_START 66689 66313 66330 66794 66821 66818 66901 66902",
	"SPELL_CAST_SUCCESS 66883 66824 66879",
	"SPELL_DAMAGE 66317 66320 66881",
	"SPELL_MISSED 66317 66320 66881",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

local warnImpaleOn			= mod:NewStackAnnounce(66331, 2, nil, "Tank|Healer")
local warnFireBomb			= mod:NewSpellAnnounce(66317, 3, nil, false)
local warnBreath			= mod:NewSpellAnnounce(66689, 2)
local warnSlimePool			= mod:NewSpellAnnounce(66883, 2, nil, "Melee")
local warnToxin				= mod:NewTargetAnnounce(66823, 3)
local warnBile				= mod:NewTargetAnnounce(66869, 3)
local WarningSnobold		= mod:NewAnnounce("WarningSnobold", 4)
local warnEnrageWorm		= mod:NewSpellAnnounce(68335, 3)
local warnCharge			= mod:NewTargetAnnounce(52311, 4)

local specWarnImpale3		= mod:NewSpecialWarningStack(66331, nil, 3, nil, nil, 1, 6)
local specWarnAnger3		= mod:NewSpecialWarningStack(66636, "Tank|Healer", 3, nil, nil, 1, 6)
local specWarnGTFO			= mod:NewSpecialWarningGTFO(66317, nil, nil, nil, 1, 2)
local specWarnToxin			= mod:NewSpecialWarningMoveTo(66823, nil, nil, nil, 1, 2)
local specWarnBile			= mod:NewSpecialWarningYou(66869, nil, nil, nil, 1, 2)
local specWarnSilence		= mod:NewSpecialWarningSpell(66330, "SpellCaster", nil, nil, 1, 2)
local specWarnCharge		= mod:NewSpecialWarningRun(52311, nil, nil, nil, 4, 2)
local specWarnChargeNear	= mod:NewSpecialWarningClose(52311, nil, nil, nil, 3, 2)
local specWarnTranq			= mod:NewSpecialWarningDispel(66759, "RemoveEnrage", nil, nil, 1, 2)

local enrageTimer			= mod:NewBerserkTimer(223)
local timerCombatStart		= mod:NewCombatTimer(21.5)
local timerNextBoss			= mod:NewTimer(190, "TimerNextBoss", 2457, nil, nil, 1)
local timerSubmerge			= mod:NewTimer(45, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, 6) 
local timerEmerge			= mod:NewTimer(10, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)

local timerBreath			= mod:NewCastTimer(5, 66689, nil, nil, nil, 3)--3 or 5? is it random target or tank?
local timerNextStomp		= mod:NewNextTimer(20, 66330, nil, nil, nil, 2)--Only melee range so targetted color for now
local timerNextImpale		= mod:NewNextTimer(10, 66331, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerRisingAnger      = mod:NewNextTimer(20.5, 66636, nil, nil, nil, 1)
local timerStaggeredDaze	= mod:NewBuffActiveTimer(15, 66758, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerNextCrash		= mod:NewCDTimer(55, 66683, nil, nil, nil, 2)
local timerSweepCD			= mod:NewCDTimer(17, 66794, nil, "Melee", nil, 3)
local timerSlimePoolCD		= mod:NewCDTimer(12, 66883, nil, "Melee", nil, 3)
local timerAcidicSpewCD		= mod:NewCDTimer(21, 66819, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerMoltenSpewCD		= mod:NewCDTimer(21, 66820, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerParalyticSprayCD	= mod:NewCDTimer(21, 66901, nil, nil, nil, 3)
local timerBurningSprayCD	= mod:NewCDTimer(21, 66902, nil, nil, nil, 3)
local timerParalyticBiteCD	= mod:NewCDTimer(25, 66824, nil, "Melee", nil, 3)
local timerBurningBiteCD	= mod:NewCDTimer(15, 66879, nil, "Melee", nil, 3)

mod:AddSetIconOption("SetIconOnChargeTarget", 52311)
mod:AddSetIconOption("SetIconOnBileTarget", 66869, false)
mod:AddBoolOption("ClearIconsOnIceHowl", false)
mod:AddRangeFrameOption("10")

local bileTargets = {}
local bileName = DBM:GetSpellInfo(66869)
local toxinTargets = {}
mod.vb.burnIcon = 8
mod.vb.DreadscaleActive = true
mod.vb.DreadscaleDead = false
mod.vb.AcidmawDead = false
mod.vb.phase = 1

function mod:OnCombatStart(delay)
	table.wipe(bileTargets)
	table.wipe(toxinTargets)
	self.vb.burnIcon = 8
	self.vb.DreadscaleActive = true
	self.vb.DreadscaleDead = false
	self.vb.AcidmawDead = false
	self.vb.phase = 1
	specWarnSilence:Schedule(14-delay)
	specWarnSilence:ScheduleVoice(14-delay, "silencesoon")
	if self:IsDifficulty("heroic10", "heroic25") then
		timerNextBoss:Start(152 - delay)
		timerNextBoss:Schedule(147)
	end
	timerNextStomp:Start(15-delay)
	timerRisingAnger:Start(25-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:warnToxin()
	warnToxin:Show(table.concat(toxinTargets, "<, >"))
	table.wipe(toxinTargets)
end

function mod:warnBile()
	warnBile:Show(table.concat(bileTargets, "<, >"))
	table.wipe(bileTargets)
	self.vb.burnIcon = 8
end

function mod:WormsEmerge()
	timerSubmerge:Show()
	if not self.vb.AcidmawDead then
		if self.vb.DreadscaleActive then
			timerSweepCD:Start(16)
			timerParalyticSprayCD:Start(9)
		else
			timerSlimePoolCD:Start(14)
			timerParalyticBiteCD:Start(5)
			timerAcidicSpewCD:Start(10)
		end
	end
	if not self.vb.DreadscaleDead then
		if self.vb.DreadscaleActive then
			timerSlimePoolCD:Start(14)
			timerMoltenSpewCD:Start(10)
			timerBurningBiteCD:Start(5)
		else
			timerSweepCD:Start(16)
			timerBurningSprayCD:Start(17)
		end
	end	
	self:ScheduleMethod(45, "WormsSubmerge")
end

function mod:WormsSubmerge()
	timerEmerge:Show()
	timerSweepCD:Cancel()
	timerSlimePoolCD:Cancel()
	timerMoltenSpewCD:Cancel()
	timerParalyticSprayCD:Cancel()
	timerBurningBiteCD:Cancel()
	timerAcidicSpewCD:Cancel()
	timerBurningSprayCD:Cancel()
	timerParalyticBiteCD:Cancel()
	self.vb.DreadscaleActive = not self.vb.DreadscaleActive
	self:ScheduleMethod(10, "WormsEmerge")
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66331 then
		timerNextImpale:Start()
		warnImpaleOn:Show(args.destName, 1)
	elseif args.spellId == 66759 then
		specWarnTranq:Show()
		specWarnTranq:Play("trannow")
	elseif args.spellId == 66823 then
		self:UnscheduleMethod("warnToxin")
		toxinTargets[#toxinTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnToxin:Show(bileName)
			specWarnToxin:Play("targetyou")
		end
		self:ScheduleMethod(0.2, "warnToxin")
	elseif args.spellId == 66869 then
		self:UnscheduleMethod("warnBile")
		bileTargets[#bileTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnBile:Show()
			specWarnBile:Play("targetyou")
		end
		if self.Options.SetIconOnBileTarget and self.vb.burnIcon > 0 then
			self:SetIcon(args.destName, self.vb.burnIcon, 15)
			self.vb.burnIcon = self.vb.burnIcon - 1
		end
		self:ScheduleMethod(0.2, "warnBile")
	elseif args.spellId == 66758 then
		timerStaggeredDaze:Start()
	elseif args.spellId == 66636 then
		WarningSnobold:Show(args.destName)
		timerRisingAnger:Show()
	elseif args.spellId == 68335 then
		warnEnrageWorm:Show()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 66331 then
		local amount = args.amount or 1
		timerNextImpale:Start()
		if (amount >= 3) or (amount >= 2 and self:IsDifficulty("heroic10", "heroic25")) then 
			if args:IsPlayer() then
				specWarnImpale3:Show(amount)
				specWarnImpale3:Play("stackhigh")
			else
				warnImpaleOn:Show(args.destName, amount)
			end
		end
	elseif args.spellId == 66636 then
		local amount = args.amount or 1
		WarningSnobold:Show()
		if amount <= 3 then
			timerRisingAnger:Show()
		elseif amount >= 3 then
			specWarnAnger3:Show(amount)
			specWarnAnger3:Play("stackhigh")
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 66689 then
		timerBreath:Start()
		warnBreath:Show()
	elseif args.spellId == 66313 then
		warnFireBomb:Show()
	elseif args.spellId == 66330 then
		timerNextStomp:Start()
		specWarnSilence:Schedule(19)
		specWarnSilence:ScheduleVoice(19, "silencesoon")
	elseif args.spellId == 66794 then
		timerSweepCD:Start()
	elseif args.spellId == 66821 then
		timerMoltenSpewCD:Start()
	elseif args.spellId == 66818 then
		timerAcidicSpewCD:Start()
	elseif args.spellId == 66901 then
		timerParalyticSprayCD:Start()
	elseif args.spellId == 66902 then
		timerBurningSprayCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 66883 then
		warnSlimePool:Show()
		timerSlimePoolCD:Show()
	elseif args.spellId == 66824 then
		timerParalyticBiteCD:Start()
	elseif args.spellId == 66879 then
		timerBurningBiteCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if (spellId == 66317 or spellId == 66320) and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then	-- Fire Bomb (66317 is impact damage, not avoidable but leaving in because it still means earliest possible warning to move. Other 4 are tick damage from standing in it)
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("runaway")
	elseif spellId == 66881 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then							-- Slime Pool
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:match(L.Charge) or msg:find(L.Charge) then
		local target = DBM:GetUnitFullName(target)
		warnCharge:Show(target)
		timerNextCrash:Start()
		if self.Options.ClearIconsOnIceHowl then
			self:ClearIcons()
		end
		if target == UnitName("player") then
			specWarnCharge:Show()
			specWarnCharge:Play("justrun")
		else
			local uId = DBM:GetRaidUnitId(target)
			if uId then
				local inRange = CheckInteractDistance(uId, 2)
				if inRange then
					specWarnChargeNear:Show()
					specWarnChargeNear:Play("runaway")
				end
			end
		end
		if self.Options.SetIconOnChargeTarget then
			self:SetIcon(target, 8, 5)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.CombatStart or msg:find(L.CombatStart) then
		timerCombatStart:Start()
	elseif msg == L.Phase2 or msg:find(L.Phase2) then
		self:ScheduleMethod(17, "WormsEmerge")
		timerCombatStart:Start(15)
		self.vb.phase = 2
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	elseif msg == L.Phase3 or msg:find(L.Phase3) then
		self.vb.phase = 3
		if self:IsDifficulty("heroic10", "heroic25") then
			enrageTimer:Start()
		end
		self:UnscheduleMethod("WormsSubmerge")
		timerNextCrash:Start(45)
		timerNextBoss:Cancel()
		timerSubmerge:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 34796 then
		specWarnSilence:Cancel()
		specWarnSilence:CancelVoice()
		timerNextStomp:Stop()
		timerNextImpale:Stop()
	elseif cid == 35144 then
		self.vb.AcidmawDead = true
		timerParalyticSprayCD:Cancel()
		timerParalyticBiteCD:Cancel()
		timerAcidicSpewCD:Cancel()
		if self.vb.DreadscaleActive then
			timerSweepCD:Cancel()
		else
			timerSlimePoolCD:Cancel()
		end
		if self.vb.DreadscaleDead then
			timerNextBoss:Cancel()
		end
	elseif cid == 34799 then
		self.vb.DreadscaleDead = true
		timerBurningSprayCD:Cancel()
		timerBurningBiteCD:Cancel()
		timerMoltenSpewCD:Cancel()
		if self.vb.DreadscaleActive then
			timerSlimePoolCD:Cancel()
		else
			timerSweepCD:Cancel()
		end
		if self.vb.AcidmawDead then
			timerNextBoss:Cancel()
		end
	elseif cid == 34797 then
		DBM:EndCombat(self)
	end
end

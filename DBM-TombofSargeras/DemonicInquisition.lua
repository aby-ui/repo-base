local mod	= DBM:NewMod(1867, "DBM-TombofSargeras", nil, 875)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(116691, 116689)--Belac (116691), Atrigan (116689)
mod:SetEncounterID(2048)
mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(1, 2, 3, 5)
mod:SetHotfixNoticeRev(16282)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 233426 234015 239401 233983",
	"SPELL_CAST_SUCCESS 233431 233983",
	"SPELL_AURA_APPLIED 233441 235230 233983 233431 236283",
	"SPELL_AURA_APPLIED_DOSE 248713",
	"SPELL_AURA_REMOVED 233441 235230 233983 236283 233431",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2",
	"UNIT_POWER_FREQUENT player"
)

--[[
(ability.id = 233426 or ability.id = 234015 or ability.id = 239401) and type = "begincast"or
(ability.id = 233431 or ability.id = 233983 or ability.id = 233894) and type = "cast" or
(ability.id = 233441) and type = "applydebuff" or
(ability.id = 235230 or ability.id = 233441) and (type = "removebuff" or type = "applybuff")
--]]
--Atrigan
local warnQuills					= mod:NewTargetAnnounce(233431, 2)
--Belac
local warnEchoingAnguish			= mod:NewTargetAnnounce(233983, 3)
local warnSuffocatingDark			= mod:NewSpellAnnounce(233894, 3)
local warnPrison					= mod:NewSpellAnnounce(236283, 2)
--local warnTormentingBurst			= mod:NewCountAnnounce(234015, 2)

--Atrigan
local specWarnScytheSweep			= mod:NewSpecialWarningSpell(233426, "Tank", nil, 2, 1, 2)
local specWarnCalcifiedQuills		= mod:NewSpecialWarningMoveAway(233431, nil, nil, nil, 1, 2)
local yellCalcifiedQuills			= mod:NewYell(233431)
local specWarnAttackAtrigan			= mod:NewSpecialWarningSwitch("ej14645", "Dps", nil, nil, 1, 2)
local specWarnBoneSawMelee			= mod:NewSpecialWarningRun(233441, "Melee", nil, 2, 4, 2)
local specWarnBoneSawEveryoneElse	= mod:NewSpecialWarningReflect(233441, "-Melee", nil, nil, 1, 2)
--Belac
local specWarnPangsofGuilt			= mod:NewSpecialWarningInterruptCount(239401, "HasInterrupt", nil, nil, 1, 3)
local specWarnEchoingAnguish		= mod:NewSpecialWarningMoveAway(233983, nil, nil, nil, 1, 2)
local yellEchoingAnguish			= mod:NewPosYell(233983, DBM_CORE_L.AUTO_YELL_CUSTOM_POSITION2)
local specWarnAttackBelac			= mod:NewSpecialWarningSwitch("ej14646", "Dps", nil, nil, 1, 2)
local specWarnFelSquallMelee		= mod:NewSpecialWarningRun(235230, "Melee", nil, 2, 4, 2)
local specWarnFelSquallEveryoneElse	= mod:NewSpecialWarningReflect(235230, "-Melee", nil, nil, 1, 2)
local specWarnTormentingBurst		= mod:NewSpecialWarningCount(234015, nil, nil, nil, 2, 2)
--Phase
local specWarnSoulCorruption		= mod:NewSpecialWarningStack(248713, nil, 10, nil, nil, 1, 6)--stack guessed
local specWarnTorment				= mod:NewSpecialWarningStack(233104, nil, 75, nil, nil, 1, 6)

--Atrigan
mod:AddTimerLine(DBM:EJ_GetSectionInfo(14645))
local timerScytheSweepCD			= mod:NewCDCountTimer(23, 233426, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerCalcifiedQuillsCD		= mod:NewCDTimer(20.2, 233431, nil, nil, nil, 3)--20.2-20.5 unless delayed by scythe, or bone saw
local timerBoneSawCD				= mod:NewCDCountTimer(45.4, 233441, nil, nil, nil, 2, nil, nil, nil, 1, 4)
local timerBoneSaw					= mod:NewBuffActiveTimer(15, 233441, nil, nil, nil, 2)
--Belac
mod:AddTimerLine(DBM:EJ_GetSectionInfo(14646))
local timerEchoingAnguishCD			= mod:NewCDTimer(22.9, 233983, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)
local timerSuffocatingDarkCD		= mod:NewCDTimer(24, 233894, nil, nil, nil, 3)
local timerTormentingBurstCD		= mod:NewCDCountTimer(17.0, 234015, nil, nil, nil, 2)
local timerFelSquallCD				= mod:NewCDCountTimer(45.7, 235230, nil, nil, nil, 2)
local timerFelSquall				= mod:NewBuffActiveTimer(15, 235230, nil, nil, nil, 2)

local berserkTimer					= mod:NewBerserkTimer(720)--482 in log, rounding to 8 even for now

mod:AddSetIconOption("SetIconOnQuills", 233431, true)
mod:AddSetIconOption("SetIconOnAnguish", 233983, true)
mod:AddInfoFrameOption(233104, true)
mod:AddRangeFrameOption(8, 233983)

mod.vb.burstCount = 0
mod.vb.scytheCount = 0
mod.vb.pangCount = 0
mod.vb.anguishIcon = 1
mod.vb.SoulsRemaining = 0
mod.vb.squallCount = 0
mod.vb.BonesawCount = 0

local function updateAllAtriganTimers(self, ICD, ignoreBoneSaw)
	DBM:Debug("updateAllAtriganTimers running", 3)
	if timerScytheSweepCD:GetRemaining(self.vb.scytheCount+1) < ICD then--4
		local elapsed, total = timerScytheSweepCD:GetTime(self.vb.scytheCount+1)
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerScytheSweepCD extended by: "..extend, 2)
		timerScytheSweepCD:Stop()
		timerScytheSweepCD:Update(elapsed, total+extend, self.vb.scytheCount+1)
	end
	if timerCalcifiedQuillsCD:GetRemaining() < ICD then--5
		local elapsed, total = timerCalcifiedQuillsCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerCalcifiedQuillsCD extended by: "..extend, 2)
		timerCalcifiedQuillsCD:Stop()
		timerCalcifiedQuillsCD:Update(elapsed, total+extend)
	end
	if not ignoreBoneSaw and timerBoneSawCD:GetRemaining(self.vb.BonesawCount+1) < ICD then--16
		local elapsed, total = timerBoneSawCD:GetTime(self.vb.BonesawCount+1)
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerBoneSawCD extended by: "..extend, 2)
		timerBoneSawCD:Stop()
		timerBoneSawCD:Update(elapsed, total+extend, self.vb.BonesawCount+1)
	end
end

local function updateAllBelacTimers(self, ICD, ignoreFelSquall)
	DBM:Debug("updateAllBelacTimers running", 3)
	local anguishRemaining = timerEchoingAnguishCD:GetRemaining()
	if anguishRemaining ~= 0 and anguishRemaining < ICD then--2 (Cast START)
		local elapsed, total = timerEchoingAnguishCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerEchoingAnguishCD extended by: "..extend, 2)
		timerEchoingAnguishCD:Stop()
		timerEchoingAnguishCD:Update(elapsed, total+extend)
	end
	local suffocatingRemaining = timerSuffocatingDarkCD:GetRemaining()
	if suffocatingRemaining ~= 0 and suffocatingRemaining < ICD then--No extend if dark is the cast
		local elapsed, total = timerSuffocatingDarkCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerSuffocatingDarkCD extended by: "..extend, 2)
		timerSuffocatingDarkCD:Stop()
		timerSuffocatingDarkCD:Update(elapsed, total+extend)
	end
	local tormentingRemaining = timerTormentingBurstCD:GetRemaining(self.vb.burstCount+1)
	if tormentingRemaining ~= 0 and tormentingRemaining < ICD then--2 (Cast Start)
		local elapsed, total = timerTormentingBurstCD:GetTime(self.vb.burstCount+1)
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerTormentingBurstCD extended by: "..extend, 2)
		timerTormentingBurstCD:Stop()
		timerTormentingBurstCD:Update(elapsed, total+extend, self.vb.burstCount+1)
	end
	if not ignoreFelSquall and timerFelSquallCD:GetRemaining(self.vb.squallCount+1) < ICD then--16
		local elapsed, total = timerFelSquallCD:GetTime(self.vb.squallCount+1)
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerFelSquallCD extended by: "..extend, 2)
		timerFelSquallCD:Stop()
		timerFelSquallCD:Update(elapsed, total+extend, self.vb.squallCount+1)
	end
end

function mod:OnCombatStart(delay)
	self.vb.burstCount = 0
	self.vb.scytheCount = 0
	self.vb.pangCount = 0
	self.vb.anguishIcon = 1
	self.vb.SoulsRemaining = 0
	self.vb.squallCount = 0
	self.vb.BonesawCount = 0
	timerScytheSweepCD:Start(5.2-delay, 1)
	if not self:IsEasy() then
		timerCalcifiedQuillsCD:Start(8.5-delay)--8.5-11
	end
	timerBoneSawCD:Start(64.5-delay, 1)
--	timerEchoingAnguishCD:Start(1-delay)--6-20
--	timerSuffocatingDarkCD:Start(1-delay)--13-48
--	timerTormentingBurstCD:Start(1-delay, 1)--8-20
	timerFelSquallCD:Start(35-delay, 1)--Always same, at least
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(233104))
		DBM.InfoFrame:Show(8, "playerpower", 5, ALTERNATE_POWER_INDEX)
	end
	--https://www.warcraftlogs.com/reports/JgyrYdDCB63kx8Tb#fight=38&type=summary&pins=2%24Off%24%23244F4B%24expression%24ability.id%20%3D%20248671&view=events
	if not self:IsLFR() then
		berserkTimer:Start(720-delay)--482 technically but 480 sounds better
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 233426 then
		self.vb.scytheCount = self.vb.scytheCount + 1
		specWarnScytheSweep:Show()
		specWarnScytheSweep:Play("shockwave")
		timerScytheSweepCD:Start(nil, self.vb.scytheCount+1)--23 unless affected by something
		updateAllAtriganTimers(self, 4)
	elseif spellId == 234015 then
		self.vb.burstCount = self.vb.burstCount + 1
		specWarnTormentingBurst:Show(self.vb.burstCount)
		specWarnTormentingBurst:Play("aesoon")
		timerTormentingBurstCD:Start(nil, self.vb.burstCount+1)
		updateAllBelacTimers(self, 2)
	elseif spellId == 239401 then
		self.vb.pangCount = self.vb.pangCount + 1
		if self.vb.pangCount == 4 then
			self.vb.pangCount = 1
		end
		if self:CheckInterruptFilter(args.sourceGUID) then
			local kickCount = self.vb.pangCount
			specWarnPangsofGuilt:Show(args.sourceName, kickCount)
			if kickCount == 1 then
				specWarnPangsofGuilt:Play("kick1r")
			elseif kickCount == 2 then
				specWarnPangsofGuilt:Play("kick2r")
			elseif kickCount == 3 then
				specWarnPangsofGuilt:Play("kick3r")
			end
		end
	elseif spellId == 233983 then
		self.vb.anguishIcon = 1
		updateAllBelacTimers(self, 2)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 233431 then
		timerCalcifiedQuillsCD:Start()
		updateAllAtriganTimers(self, 5)
	elseif spellId == 233983 then
		timerEchoingAnguishCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 233441 then
		self.vb.BonesawCount = self.vb.BonesawCount + 1
		--Redundant warnings if still on wrong boss (or tank)
		if UnitGUID("target") == args.sourceGUID then
			specWarnBoneSawMelee:Show()
			specWarnBoneSawEveryoneElse:Show(args.sourceName)
			if self:IsMelee() then
				specWarnBoneSawMelee:Play("runout")
			end
			specWarnBoneSawEveryoneElse:ScheduleVoice(1, "stopattack")
		end
		timerBoneSaw:Start(nil, self.vb.BonesawCount+1)
		updateAllAtriganTimers(self, 16, true)
		for i = 1, 2 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and self:IsTanking("player", bossUnitID, nil, true) then--We are highest threat target
				specWarnBoneSawMelee:Schedule(2, "keepmove")--The active tank doesn't just run out, they keep kiting
				break
			end
		end
	elseif spellId == 235230 then
		self.vb.squallCount = self.vb.squallCount + 1
		--Redundant warnings if still on wrong boss (or tank)
		if UnitGUID("target") == args.sourceGUID then
			specWarnFelSquallMelee:Show()
			specWarnFelSquallEveryoneElse:Show(args.sourceName)
			if self:IsMelee() then
				specWarnFelSquallMelee:Play("runout")
			end
			specWarnFelSquallEveryoneElse:ScheduleVoice(1, "stopattack")
		end
		timerFelSquall:Start(nil, self.vb.squallCount+1)
		updateAllBelacTimers(self, 16, true)
	elseif spellId == 233983 then
		warnEchoingAnguish:CombinedShow(0.3, args.destName)
		local currentIcon = self.vb.anguishIcon
		if args:IsPlayer() then
			specWarnEchoingAnguish:Show()
			specWarnEchoingAnguish:Play("runout")
			yellEchoingAnguish:Yell(currentIcon, args.spellName, currentIcon)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
		if self.Options.SetIconOnAnguish then
			self:SetIcon(args.destName, currentIcon)
		end
		self.vb.anguishIcon = self.vb.anguishIcon + 1
	elseif spellId == 233431 then
		if args:IsPlayer() then
			specWarnCalcifiedQuills:Show()
			specWarnCalcifiedQuills:Play("runout")
			yellCalcifiedQuills:Yell()
		else
			warnQuills:Show(args.destName)
		end
		if self.Options.SetIconOnQuills then
			self:SetIcon(args.destName, 5)
		end
	elseif spellId == 208802 then
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 10 then
			specWarnSoulCorruption:Show(amount)
			specWarnSoulCorruption:Play("stackhigh")
		end
	elseif spellId == 236283 then
		if args:IsPlayer() then
			warnPrison:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 233441 then--Bone Saw
		specWarnAttackAtrigan:Show()
		specWarnAttackAtrigan:Play("targetchange")
		timerBoneSaw:Stop()
		timerBoneSawCD:Start()
	elseif spellId == 233983 then
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
		if self.Options.SetIconOnAnguish then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 235230 then
		specWarnAttackBelac:Show()
		specWarnAttackBelac:Play("targetchange")
		timerFelSquallCD:Start()
	elseif spellId == 233431 then
		if self.Options.SetIconOnQuills then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 236283 then--Prison
		self.vb.SoulsRemaining = self.vb.SoulsRemaining + 1
	end
end

do
	local warned = false
	function mod:UNIT_POWER_FREQUENT(uId, type)
		if type == "ALTERNATE" then
			local playerPower = UnitPower("player", 10)
			if not warned and playerPower >= 75 then
				warned = true
				specWarnTorment:Show(playerPower)
				specWarnTorment:Play("stackhigh")
			elseif warned and playerPower < 30 then
				warned = false
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 117957 then--Tormented Soul
		self.vb.SoulsRemaining = self.vb.SoulsRemaining - 1
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 233895 then
		warnSuffocatingDark:Show()
		timerSuffocatingDarkCD:Start()
	end
end


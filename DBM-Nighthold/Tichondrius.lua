local mod	= DBM:NewMod(1762, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143337")
mod:SetCreatureID(103685)
mod:SetEncounterID(1862)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)--Unknown carrions
mod:SetHotfixNoticeRev(16059)
mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 212997 213238 213531 206365 216034 216723 215988",
	"SPELL_CAST_SUCCESS 212997 212794 208230",
	"SPELL_AURA_APPLIED 206480 212794 208230 216040 206466",
	"SPELL_AURA_APPLIED_DOSE 216024",
	"SPELL_AURA_REMOVED 212794 216040 206480",
	"SPELL_PERIODIC_DAMAGE 216027",
	"SPELL_PERIODIC_MISSED 216027",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)

--TODO, more review on Feast of Blood
--TODO, redo/update LFR/Normal timers since they probably also have phase 2 and phase 3 variations
 --(ability.id = 212997 or ability.id = 213238 or ability.id = 208230 or ability.id = 213531 or ability.id = 206365) and type = "begincast"
local warnCarrionPlague				= mod:NewTargetAnnounce(206480, 3)
local warnBrandOfArgus				= mod:NewTargetAnnounce(212794, 4)
local warnBloodFang					= mod:NewCountAnnounce("ej13528", 1, 24733)
--Nightborne
local warnVolatileWound				= mod:NewStackAnnounce(216024, 3, nil, false, 2)
--The Legion
local warnBurningSoul				= mod:NewTargetAnnounce(216040, 4)
local warnRingOfShadow				= mod:NewSpellAnnounce(216723, 3)

local specWarnCarrionPlague			= mod:NewSpecialWarningMoveAway(206480, nil, nil, nil, 1, 2)
local specWarnSeekerSwarm			= mod:NewSpecialWarningDodge(213238, nil, nil, nil, 2, 6)
local yellSeekerSwarm				= mod:NewYell(213238)--Carrion plague targets yell when it's relevant. On seeker swarm cast
local yellBrandOfArgus				= mod:NewPosYell(212794, 156225)--"Branded" short text
local specWarnFeastOfBlood			= mod:NewSpecialWarningRun(208230, nil, nil, nil, 1, 2)--Move away, or run? neither one really says "get 30 yards from boss"
local specWarnFeastOfBloodOther		= mod:NewSpecialWarningTaunt(208230, nil, nil, nil, 1, 2)
local specWarnEchoesOfVoid			= mod:NewSpecialWarningDodge(213531, nil, nil, nil, 3, 2)
local specWarnCarrionNightmare 		= mod:NewSpecialWarningDodge(215988, nil, nil, nil, 1, 2)
local specWarnAdds					= mod:NewSpecialWarningAdds(216726, "-Healer", nil, nil, 1, 2)
--Nightborne
local specWarnBlastNova				= mod:NewSpecialWarningInterrupt(216034, "HasInterrupt", nil, nil, 2, 2)
local specWarnNetherZoneGTFO		= mod:NewSpecialWarningMove(216027, nil, nil, nil, 2, 2)
--The Legion
local specWarnBurningSoul			= mod:NewSpecialWarningMoveAway(216040, nil, nil, nil, 1, 2)
local yellBurningSoul				= mod:NewYell(216040)

local timerCarrionPlagueCD			= mod:NewNextCountTimer(25, 212997, nil, nil, nil, 3)
local timerSeekerSwarmCD			= mod:NewNextCountTimer(25, 213238, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerBrandOfArgusCD			= mod:NewNextCountTimer(25, 212794, nil, nil, nil, 3)--Concider short timer 156225
local timerFeastOfBloodCD			= mod:NewNextCountTimer(25, 208230, nil, nil, 2, 1, nil, nil, nil, mod:IsTank() and 3, 4)
local timerEchoesOfVoidCD			= mod:NewNextCountTimer(65, 213531, nil, nil, nil, 2, nil, nil, nil, 2, 4)
local timerIllusionaryNightCD		= mod:NewNextCountTimer(125, 206365, nil, nil, nil, 6)
local timerIllusionaryNight			= mod:NewBuffActiveTimer(32, 206365, nil, nil, nil, 6, nil, nil, nil, 1, 10)
local timerAddsCD					= mod:NewAddsTimer(25, 216726, nil, "-Healer")
local timerCarrionNightmare			= mod:NewNextCountTimer(4, 215988, nil, nil, nil, 2)

local berserkTimer					= mod:NewBerserkTimer(463)

mod:AddRangeFrameOption(8, 216040)
mod:AddSetIconOption("SetIconOnBrandOfArgus", 212794, true)
mod:AddInfoFrameOption(212794)

--With more data, the pattern gets distrupted later, but it's ALWAYS disrupted so multiple sequences needed to do it by phase (or just hard code ENTIRE sequence and not do it by phase?
--Carrion Plague: pull:5.0, 25.0, 35.6, 24.4, 75.0, 25.5, 35.6, 26.9, 75.0, 25.6, 40.6, 20.5, 53.6, 25.6
--Seeker Swarm:	  pull:25.0, 25.0, 35.0, 25.0, 75.0, 25.5, 37.5, 25.0, 75.0, 25.6, 36.1, 22.5, 56.1
--Brand of Argus: pull:15.0, 25.0, 35.0, 25.0, 75.0, 25.5, 32.5, 30.0, 75.0, 25.6, 36.1, 22.5, 56.1, 25.6",
--Feast of Blood: pull:20.0, 25.0, 35.0, 25.0, 75.0, 25.5, 37.5, 25.0, 75.1, 25.6, 36.2, 22.5, 56.1, 25.6"
--Carrion Plague, feast of blood, Seeker Swarm, brand of argus All Same in Phase 1
local P1SharedCastTimers = {0, 25, 35, 24.5}
--Phase 2 they start to fragment
local P2CarrionTimers = {0, 25.5, 35.6, 26.9}
local P2SeekerBloodTimers = {0, 25.5, 37.5, 25.0}--Seeker and Feast of Blood
local P2BrandTimers = {0, 25.5, 32.5, 30.0}
--less fragmented in phase 3
local P3CarrionTimers = {0, 25.6, 40.6, 20.5}
local P3SharedCastTimers = {0, 25.6, 36.1, 22.5}--Seeker, Brand, Feast

--Normal/LFR HAD different timers. Normal now matches heroic so assume LFR also does for now
--local sharedCastTimersFaster = {0, 15, 25, 14.5}--Carrion Plague, feast of blood, Seeker Swarm (faster on normal/LFR since no brand of argus)
local argusTargets = {}
local carrionDebuff, argusDebuff, batsName, essenceOfNightDebuff = DBM:GetSpellInfo(206480), DBM:GetSpellInfo(212794), DBM:EJ_GetSectionInfo(13528), DBM:GetSpellInfo(206466)
mod.vb.phase = 1
mod.vb.darkPhase = false
mod.vb.carrionPlagueCast = 0
mod.vb.feastOfBloodCast = 0
mod.vb.seekerSwarmCast = 0
mod.vb.brandOfArgusCast = 0
mod.vb.echoesOfVoidCast = 0
mod.vb.addsCount = 0
mod.vb.carrionNightmare = 0
mod.vb.batsKilled = 0
mod.vb.essenceCount = 0
mod.vb.CarrionPlagueCount = 0

local updateInfoFrame, breakMarks
do
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		table.wipe(lines)
		table.wipe(sortedLines)
		--Counts first, depending on phase
		if mod.vb.darkPhase then
			addLine(batsName, mod.vb.batsKilled)
			addLine(essenceOfNightDebuff, mod.vb.essenceCount)
		else
			addLine(carrionDebuff, mod.vb.CarrionPlagueCount)
		end
		--Argust playername list last
		for i = 1, #argusTargets do
			local name = argusTargets[i]
			local uId = DBM:GetRaidUnitId(name)
			if uId and DBM:UnitDebuff(uId, argusDebuff) then
				addLine(name, i)
			end
		end
		return lines, sortedLines
	end
	local playerName = UnitName("player")
	breakMarks = function (self, spellName)
		table.sort(argusTargets)
		warnBrandOfArgus:Show(table.concat(argusTargets, "<, >"))
		for i = 1, #argusTargets do
			local name = argusTargets[i]
			if not name then break end
			if not DBM:GetRaidUnitId(name) then break end
			if name == playerName then
				yellBrandOfArgus:Yell(i, i, i)
			end
			if self.Options.SetIconOnBrandOfArgus then
				self:SetIcon(name, i)
			end
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.darkPhase = false
	self.vb.carrionPlagueCast = 0
	self.vb.feastOfBloodCast = 0
	self.vb.seekerSwarmCast = 0
	self.vb.brandOfArgusCast = 0
	self.vb.echoesOfVoidCast = 0
	self.vb.addsCount = 0
	self.vb.carrionNightmare = 0
	self.vb.batsKilled = 0
	self.vb.essenceCount = 0
	self.vb.CarrionPlagueCount = 0
	table.wipe(argusTargets)
	timerCarrionPlagueCD:Start(7-delay, 1)--Cast end
	timerFeastOfBloodCD:Start(20-delay, 1)
	timerSeekerSwarmCD:Start(25-delay, 1)
	timerEchoesOfVoidCD:Start(55-delay, 1)
	timerIllusionaryNightCD:Start(130-delay, 1)
	if not self:IsEasy() then
		timerBrandOfArgusCD:Start(15-delay, 1)
		berserkTimer:Start(-delay)
	else
		berserkTimer:Start(523-delay)
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(OVERVIEW)
		DBM.InfoFrame:Show(8, "function", updateInfoFrame, false, false, true)
	end
end

function mod:OnCombatEnd()
--	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 215988 then
		self.vb.carrionNightmare = self.vb.carrionNightmare + 1
		specWarnCarrionNightmare:Show()
		specWarnCarrionNightmare:Play("watchstep")
		if self.vb.carrionNightmare < 6 then
			timerCarrionNightmare:Start(nil, self.vb.carrionNightmare+1)
		end
	elseif spellId == 212997 then
		if self.vb.darkPhase then--He casts it immediately after a Night phase ends
			self.vb.darkPhase = false
			self.vb.phase = self.vb.phase + 1
			self.vb.carrionPlagueCast = 0
			self.vb.feastOfBloodCast = 0
			self.vb.seekerSwarmCast = 0
			self.vb.brandOfArgusCast = 0
			self.vb.echoesOfVoidCast = 0
			self.vb.addsCount = 0
			DBM:Debug("First carrion Swarm after dark phase, Tichondrius returning", 2)
			--Timers same as combat start - 5
			if not self:IsEasy() then
				timerBrandOfArgusCD:Start(10, 1)
			end
			timerFeastOfBloodCD:Start(14.5, 1)
			timerSeekerSwarmCD:Start(20, 1)
			timerAddsCD:Start(20)
			timerIllusionaryNightCD:Start(123, 1)
			if self.vb.phase == 2 then--The Nightborne
				timerEchoesOfVoidCD:Start(50, 1)
			else--The Legion
				timerEchoesOfVoidCD:Start(55, 1)
			end
		end
	elseif spellId == 213238 then
		self.vb.seekerSwarmCast = self.vb.seekerSwarmCast + 1
		specWarnSeekerSwarm:Show(self.vb.seekerSwarmCast)
		local timer
		if self.vb.phase == 1 then
			timer = P1SharedCastTimers[self.vb.seekerSwarmCast+1]
		elseif self.vb.phase == 2 then
			timer = P2SeekerBloodTimers[self.vb.seekerSwarmCast+1]
		else--Assume phase 3+ are same, for now since no further mechancis introduced
			timer = P3SharedCastTimers[self.vb.seekerSwarmCast+1]
		end
		if timer then
			timerSeekerSwarmCD:Start(timer, self.vb.seekerSwarmCast+1)
		end
		if DBM:UnitDebuff("player", carrionDebuff) then
			yellSeekerSwarm:Yell()
			specWarnSeekerSwarm:Play("targetyou")
		else
			specWarnSeekerSwarm:Play("farfromline")
		end
	elseif spellId == 213531 then
		self.vb.echoesOfVoidCast = self.vb.echoesOfVoidCast + 1
		specWarnEchoesOfVoid:Show(self.vb.echoesOfVoidCast)
		specWarnEchoesOfVoid:Play("findshelter")
		if self.vb.echoesOfVoidCast == 1 then
			--Only cast twice per cycle
			if self.vb.phase == 1 then
				timerEchoesOfVoidCD:Start(65, 2)
			elseif self.vb.phase == 2 then
				timerEchoesOfVoidCD:Start(67.5, 2)
			else
				timerEchoesOfVoidCD:Start(59.7, 2)
			end
		end
	elseif spellId == 206365 then--Phase Change
		--stops may not be needed if sharedTimer Table works
		timerCarrionPlagueCD:Stop()
		timerSeekerSwarmCD:Stop()
		timerBrandOfArgusCD:Stop()
		timerFeastOfBloodCD:Stop()
		timerEchoesOfVoidCD:Stop()
		self.vb.darkPhase = true
		self.vb.carrionNightmare = 0
		self.vb.batsKilled = 0
		self.vb.essenceCount = 0
		timerIllusionaryNight:Start()
		timerCarrionNightmare:Start(6, 1)
	elseif spellId == 216034 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBlastNova:Show(args.sourceName)
		specWarnBlastNova:Play("kickcast")
	elseif spellId == 216723 then
		warnRingOfShadow:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 212997 then
		self.vb.carrionPlagueCast = self.vb.carrionPlagueCast + 1
		local timer
		if self.vb.phase == 1 then
			timer = P1SharedCastTimers[self.vb.carrionPlagueCast+1]
		elseif self.vb.phase == 2 then
			timer = P2CarrionTimers[self.vb.carrionPlagueCast+1]
		else
			timer = P3CarrionTimers[self.vb.carrionPlagueCast+1]
		end
		if timer then
			timerCarrionPlagueCD:Start(timer, self.vb.carrionPlagueCast+1)
		end
	elseif spellId == 212794 then
		self.vb.brandOfArgusCast = self.vb.brandOfArgusCast + 1
		local timer
		if self.vb.phase == 1 then
			timer = P1SharedCastTimers[self.vb.brandOfArgusCast+1]
		elseif self.vb.phase == 2 then
			timer = P2BrandTimers[self.vb.brandOfArgusCast+1]
		else
			timer = P3SharedCastTimers[self.vb.brandOfArgusCast+1]
		end
		if timer then 
			timerBrandOfArgusCD:Start(timer, self.vb.brandOfArgusCast+1)
		end
	elseif spellId == 208230 then
		self.vb.feastOfBloodCast = self.vb.feastOfBloodCast + 1
		local timer
		if self.vb.phase == 1 then
			timer = P1SharedCastTimers[self.vb.feastOfBloodCast+1]
		elseif self.vb.phase == 2 then
			timer = P2SeekerBloodTimers[self.vb.feastOfBloodCast+1]
		else
			timer = P3SharedCastTimers[self.vb.feastOfBloodCast+1]
		end
		if timer then
			timerFeastOfBloodCD:Start(timer, self.vb.feastOfBloodCast+1)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 206480 then
		self.vb.CarrionPlagueCount = self.vb.CarrionPlagueCount + 1
		warnCarrionPlague:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnCarrionPlague:Show()
			specWarnCarrionPlague:Play("scatter")
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	elseif spellId == 212794 then
		argusTargets[#argusTargets+1] = args.destName
		self:Unschedule(breakMarks)
		self:Schedule(0.5, breakMarks, self, args.spellName)
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	elseif spellId == 208230 then
		if args:IsPlayer() then
			specWarnFeastOfBlood:Show()
			specWarnFeastOfBlood:Play("runout")
		else
			specWarnFeastOfBloodOther:Show(args.destName)
			specWarnFeastOfBloodOther:Play("tauntboss")
		end
	elseif spellId == 216040 then
		if args:IsPlayer() then
			specWarnBurningSoul:Show()
			yellBurningSoul:Yell()
			specWarnBurningSoul:Play("runout")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		else
			warnBurningSoul:Show(args.destName)
		end
	elseif spellId == 206466 then
		self.vb.essenceCount = self.vb.essenceCount + 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 216024 then
		local amount = args.amount or 1
		if amount % 3 == 0 or amount > 6 then
			warnVolatileWound:Show(args.destName, amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 212794 then
		tDeleteItem(argusTargets, args.destName)
		if self.Options.SetIconOnBrandOfArgus then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	elseif spellId == 216040 and args:IsPlayer() and self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	elseif spellId == 206480 then
		self.vb.CarrionPlagueCount = self.vb.CarrionPlagueCount - 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 216027 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnNetherZoneGTFO:Show()
		specWarnNetherZoneGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 104326 then--Dark Phase bats
		self.vb.batsKilled = self.vb.batsKilled + 1
		if self.vb.batsKilled % 4 == 0 then
			warnBloodFang:Show(self.vb.batsKilled)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, npc, _, _, target)
	if msg == L.Adds1 or msg:find(L.Adds1) or msg == L.Adds2 or msg:find(L.Adds2) then
		self:SendSync("Adds")--Syncing to help unlocalized clients
	end
end

function mod:OnSync(msg, targetname)
	if not self:IsInCombat() then return end
	if msg == "Adds" then
		self.vb.addsCount = self.vb.addsCount + 1
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
		if self.vb.phase == 2 then
			if self.vb.addsCount == 1 then
				timerAddsCD:Start(47)
			end
		else
			if self.vb.addsCount == 1 then
				timerAddsCD:Start(35)--ish, need relogging to confirm
			elseif self.vb.addsCount == 2 then
				timerAddsCD:Start(47)
			end
		end
	end
end

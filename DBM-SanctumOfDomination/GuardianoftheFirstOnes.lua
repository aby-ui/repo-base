local mod	= DBM:NewMod(2446, "DBM-SanctumOfDomination", nil, 1193)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210708015009")
mod:SetCreatureID(175731)
mod:SetEncounterID(2436)
mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20210625000000)--2021-06-25
mod:SetMinSyncRevision(20210625000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 352589 352538 350732 352833 352660 356090 355352 350734",
	"SPELL_AURA_APPLIED 352385 352394 350734 350496 350732",--350534
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 352385 352394 350496",--350534
	"SPELL_PERIODIC_DAMAGE 350455",
	"SPELL_PERIODIC_MISSED 350455",
--	"UNIT_DIED"
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 352589 or ability.id = 352538 or ability.id = 350732 or ability.id = 352833 or ability.id = 352660 or ability.id = 356090 or ability.id = 355352 or ability.id = 350734) and type = "begincast"
 or (ability.id = 352385 or ability.id = 350534) and (type = "applybuff" or type = "removebuff")
--]]
--TODO, fix timers more based around energy or energizing link, whichever one is confirmed to truly affect stuff like Sunder having massive delays
--TODO, do people really need a timer for purging protocol? it's based on bosses energy depletion rate (which is exactly 1 energy per second and visible on infoframe)
--TODO, if combo is random order on mythic, bust out the aggramar shit
--In other words, infoframe energy tracker IS the timer, and his energy is constantly going up and down based on core strategy, timer would need aggressive updates from UNIT_POWER
local warnDisintegration						= mod:NewTargetNoFilterAnnounce(352833, 3)
local warnThreatNeutralization					= mod:NewTargetNoFilterAnnounce(350496, 2)
local warnFormSentry							= mod:NewCountAnnounce(352660, 2)
local warnObliterate							= mod:NewCountAnnounce(355352, 2)

--Cores
local specWarnRadiantEnergy						= mod:NewSpecialWarningMoveTo(350455, nil, nil, nil, 1, 2)
local specWarnMeltdown							= mod:NewSpecialWarningRun(352589, nil, nil, nil, 4, 2)--Change to appropriate text and priority
--Guardian
local specWarnPurgingProtocol					= mod:NewSpecialWarningCount(352538, nil, nil, nil, 2, 2)
local specWarnSunder							= mod:NewSpecialWarningDefensive(350732, nil, nil, nil, 1, 2)
local specWarnSunderTaunt						= mod:NewSpecialWarningTaunt(350732, nil, nil, nil, 1, 2)--Only used on normal/LFR, swaps for heroic and mythic are during Obliterate
local specWarnObliterate						= mod:NewSpecialWarningTaunt(350734, nil, nil, nil, 1, 2)
local specWarnObliterateCount					= mod:NewSpecialWarningCount(350734, false, nil, nil, 1, 2)
local specWarnDisintegration					= mod:NewSpecialWarningDodgeCount(352833, nil, nil, nil, 2, 2)
local yellDisintegration						= mod:NewYell(352833)
local specWarnThreatNeutralization				= mod:NewSpecialWarningMoveAway(350496, nil, nil, nil, 1, 2)
local yellThreatNeutralization					= mod:NewShortPosYell(350496)
local yellThreatNeutralizationFades				= mod:NewIconFadesYell(350496)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

--mod:AddTimerLine(BOSS)
local timerEliminationPatternCD					= mod:NewCDCountTimer(31.6, 350735, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_L.TANK_ICON, true)--Time between casts not known, but link reset kinda works
local timerDisintegrationCD						= mod:NewCDCountTimer(34.6, 352833, nil, nil, nil, 3, nil, nil, true)--Continues whether linked or not
local timerFormSentryCD							= mod:NewCDCountTimer(72.6, 352660, nil, nil, nil, 1, nil, nil, true)--Time between casts not known, but link reset kinda works
local timerThreatNeutralizationCD				= mod:NewCDTimer(11.4, 350496, nil, nil, nil, 3, nil, nil, true)--Continues whether linked or not

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(10, 350496)
mod:AddInfoFrameOption(352394, true)
mod:AddSetIconOption("SetIconOnThreat", 350496, true, false, {1, 2, 3})

local radiantEnergy = DBM:GetSpellInfo(352394)
local playerSafe = false
local playersSafe = {}
local threatTargets = {}
mod.vb.coreActive = false
mod.vb.sentryCount = 0
mod.vb.beamCount = 0
mod.vb.protocolCount = 0
mod.vb.patternCount = 0
mod.vb.comboCount = 0

local updateInfoFrame
do
	local DBM, DBM_CORE_L = DBM, DBM_CORE_L
	local UnitPower, UnitPowerMax, UnitName = UnitPower, UnitPowerMax, UnitName
	local twipe = table.wipe
	local lines, sortedLines = {}, {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		twipe(lines)
		twipe(sortedLines)
		--Boss Power
		local currentPower, maxPower = UnitPower("boss1"), UnitPowerMax("boss1")
		if maxPower and maxPower ~= 0 then
			if currentPower / maxPower * 100 >= 1 then
				addLine(UnitName("boss1"), currentPower)
			end
		end
		--Player safety status
		if mod.vb.coreActive then
			addLine(radiantEnergy, DBM_CORE_L.NOTSAFE)
			for uId in DBM:GetGroupMembers() do
				local unitName = DBM:GetUnitFullName(uId)
				if not playersSafe[unitName] then
					addLine(unitName, "")
				end
			end
		end
		return lines, sortedLines
	end
end

--Ugly as hell, definitely a cleaner logical way of doing it but i'm not smart or patient enough these days
--Code logic is simple (even though it looks like shit). Prio melee before ranged in icon assignments.
--1 melee = star, 2 melee = star and circle. 3 melee is same as 3 ranged since at this point we just assign icons in table order.
--Ranged will get icons 2 and 3 or just 3 after melee got theirs obviously
local isMelee = {[1] = false,[2] = false,[3] = false,}
local playerName = UnitName("player")
local function showthreat(self)
	local nameOne, nameTwo, nameThree = nil, nil, nil
	local meleeCount = 0
	local setIcon = self.Options.SetIconOnThreat
	for i = 1, #threatTargets do
		local name = threatTargets[i]
		local uId = DBM:GetRaidUnitId(name)
		if not uId then return end--Prevent errors if person leaves group
		--Identify number of melee and assign them numbers
		if self:IsMeleeDps(uId) then--Melee
			meleeCount = meleeCount + 1
			isMelee[i] = true
		else
			isMelee[i] = false
		end
		--Now cache names to numbers
		if i == 1 then
			nameOne = name
		elseif i == 2 then
			nameTwo = name
		else
			nameThree = name
		end
	end
	--Now deal with every possible scenario
	if meleeCount == 3 or meleeCount == 0 then--All melee or all ranged, results same either way
		if setIcon then
			self:SetIcon(nameOne, 1)
		end
		if playerName == nameOne then
			specWarnThreatNeutralization:Show()
			specWarnThreatNeutralization:Play("runout")
			yellThreatNeutralization:Yell(1, 1)
			yellThreatNeutralizationFades:Countdown(350496, nil, 1)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if setIcon then
			self:SetIcon(nameTwo, 2)
		end
		if playerName == nameTwo then
			specWarnThreatNeutralization:Show()
			specWarnThreatNeutralization:Play("runout")
			yellThreatNeutralization:Yell(2, 2)
			yellThreatNeutralizationFades:Countdown(350496, nil, 2)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
		if setIcon then
			self:SetIcon(nameThree, 3)
		end
		if playerName == nameThree then
			specWarnThreatNeutralization:Show()
			specWarnThreatNeutralization:Play("runout")
			yellThreatNeutralization:Yell(3, 3)
			yellThreatNeutralizationFades:Countdown(350496, nil, 3)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif meleeCount == 2 then--2 melee, 1 ranged
		local meleeicon = 0--In this set we have only 1 ranged which means up to 2 melee
		if isMelee[1] then
			meleeicon = meleeicon + 1
			if setIcon then
				self:SetIcon(nameOne, meleeicon)
			end
			if playerName == nameOne then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(meleeicon, meleeicon)
				yellThreatNeutralizationFades:Countdown(350496, nil, meleeicon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			if setIcon then
				self:SetIcon(nameOne, 3)
			end
			if playerName == nameOne then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(3, 3)
				yellThreatNeutralizationFades:Countdown(350496, nil, 3)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
		if isMelee[2] then
			meleeicon = meleeicon + 1
			if setIcon then
				self:SetIcon(nameTwo, meleeicon)
			end
			if playerName == nameTwo then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(meleeicon, meleeicon)
				yellThreatNeutralizationFades:Countdown(350496, nil, meleeicon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			if setIcon then
				self:SetIcon(nameTwo, 3)
			end
			if playerName == nameTwo then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(3, 3)
				yellThreatNeutralizationFades:Countdown(350496, nil, 3)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
		if isMelee[3] then
			meleeicon = meleeicon + 1
			if setIcon then
				self:SetIcon(nameThree, meleeicon)
			end
			if playerName == nameThree then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(meleeicon, meleeicon)
				yellThreatNeutralizationFades:Countdown(350496, nil, meleeicon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			if setIcon then
				self:SetIcon(nameThree, 3)
			end
			if playerName == nameThree then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(3, 3)
				yellThreatNeutralizationFades:Countdown(350496, nil, 3)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
	elseif meleeCount == 1 then
		local rangedIcon = 1--In this set we have 1 melee which means up to 2 ranged, icon starts at 1 instead of 0 because of melee reservation
		if isMelee[1] then--Melee will always be icon 1 in this scenario
			if setIcon then
				self:SetIcon(nameOne, 1)
			end
			if playerName == nameOne then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(1, 1)
				yellThreatNeutralizationFades:Countdown(350496, nil, 1)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			rangedIcon = rangedIcon + 1
			if setIcon then
				self:SetIcon(nameOne, 3)
			end
			if playerName == nameOne then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(rangedIcon, rangedIcon)
				yellThreatNeutralizationFades:Countdown(350496, nil, rangedIcon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
		if isMelee[2] then--Melee will always be icon 1 in this scenario
			if setIcon then
				self:SetIcon(nameTwo, 1)
			end
			if playerName == nameTwo then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(1, 1)
				yellThreatNeutralizationFades:Countdown(350496, nil, 1)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			rangedIcon = rangedIcon + 1
			if setIcon then
				self:SetIcon(nameTwo, 3)
			end
			if playerName == nameTwo then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(rangedIcon, rangedIcon)
				yellThreatNeutralizationFades:Countdown(350496, nil, rangedIcon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
		if isMelee[3] then--Melee will always be icon 1 in this scenario
			if setIcon then
				self:SetIcon(nameThree, 1)
			end
			if playerName == nameThree then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(1, 1)
				yellThreatNeutralizationFades:Countdown(350496, nil, 1)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		else--Ranged (only one, so icon always 3)
			rangedIcon = rangedIcon + 1
			if setIcon then
				self:SetIcon(nameThree, 3)
			end
			if playerName == nameThree then
				specWarnThreatNeutralization:Show()
				specWarnThreatNeutralization:Play("runout")
				yellThreatNeutralization:Yell(rangedIcon, rangedIcon)
				yellThreatNeutralizationFades:Countdown(350496, nil, rangedIcon)
				if self.Options.RangeFrame then
					DBM.RangeCheck:Show(10)
				end
			end
		end
	end
	warnThreatNeutralization:Show(table.concat(threatTargets, "<, >"))
end

function mod:OnCombatStart(delay)
	playerSafe = false
	self.vb.sentryCount = 0
	self.vb.beamCount = 0
	self.vb.protocolCount = 0
	self.vb.patternCount = 0--which pattern SET it is
	self.vb.comboCount = 0--Which cast within the pattern set
	timerFormSentryCD:Start(3.6-delay, 1)
	timerThreatNeutralizationCD:Start(self:IsMythic() and 8.3 or 10.9-delay)
	timerDisintegrationCD:Start(15.4-delay, 1)
	timerEliminationPatternCD:Start(25.3-delay, 1)
	--Infoframe setup (might not be needed)
	for uId in DBM:GetGroupMembers() do
		if DBM:UnitDebuff(uId, 352394) then
			local unitName = DBM:GetUnitFullName(uId)
			playersSafe[unitName] = true
		end
	end
	if DBM:UnitAura("boss1", 352385) then
		self.vb.coreActive = true
	else
		self.vb.coreActive = false
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(radiantEnergy)
		DBM.InfoFrame:Show(8, "function", updateInfoFrame, false, false)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:OnTimerRecovery()
	if DBM:UnitDebuff("player", 352394) then
		playerSafe = true
	end
	for uId in DBM:GetGroupMembers() do
		if DBM:UnitDebuff(uId, 352394) then
			local unitName = DBM:GetUnitFullName(uId)
			playersSafe[unitName] = true
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 352589 then
		specWarnMeltdown:Show()
		specWarnMeltdown:Play("justrun")
	elseif spellId == 352538 then
		self.vb.protocolCount = self.vb.protocolCount + 1
		specWarnPurgingProtocol:Show(self.vb.protocolCount)
		specWarnPurgingProtocol:Play("aesoon")
	elseif spellId == 350732 then
		self.vb.comboCount = self.vb.comboCount + 1
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnSunder:Show()
			specWarnSunder:Play("defensive")
		end
	elseif spellId == 352833 then
		self.vb.beamCount = self.vb.beamCount + 1
		specWarnDisintegration:Show(self.vb.beamCount)
		specWarnDisintegration:Play("farfromline")
		timerDisintegrationCD:Start(nil, self.vb.beamCount+1)
	elseif spellId == 352660 then
		self.vb.sentryCount = self.vb.sentryCount + 1
		warnFormSentry:Show(self.vb.sentryCount)
--		timerFormSentryCD:Start(nil, self.vb.sentryCount+1)
	elseif spellId == 356090 then
		isMelee = {[1] = false,[2] = false,[3] = false,}
		table.wipe(threatTargets)
		timerThreatNeutralizationCD:Start()
	elseif spellId == 355352 or spellId == 350734 then--Mythic, Heroic
		self.vb.comboCount = self.vb.comboCount + 1
		local castCount = (self.vb.comboCount == 2) and 1 or 2
		if self.Options.SpecWarn355352count then
			specWarnObliterateCount:Show(castCount)
		else
			warnObliterate:Show(castCount)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 352385 then--Energizing Link
		self.vb.coreActive = true
		self.vb.protocolCount = 0
		if not playerSafe then
			specWarnRadiantEnergy:Show(radiantEnergy)
			specWarnRadiantEnergy:Play("findshelter")
		end
	elseif spellId == 352394 then
		playersSafe[args.destName] = true
		if args:IsPlayer() then
			playerSafe = true
		end
	elseif spellId == 350734 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) and not args:IsPlayer() then
			specWarnObliterate:Show(args.destName)
			specWarnObliterate:Play("tauntboss")
		end
	elseif spellId == 350732 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) and not args:IsPlayer() and self.vb.comboCount == 2 then--Obviously normal/LFR
			specWarnSunderTaunt:Show(args.destName)
			specWarnSunderTaunt:Play("tauntboss")
		end
	elseif spellId == 350496 then
		threatTargets[#threatTargets+1] = args.destName
		self:Unschedule(showthreat)
		if #threatTargets == 3 then
			showthreat(self)
		else
			self:Schedule(0.5, showthreat, self)
		end
	elseif spellId == 350534 then--Purging Protocol Activating
		timerEliminationPatternCD:Stop()--Still probably not most accurate way of doing it, but probably most reliable one given most strategies
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 352385 then--Energizing Link
		self.vb.coreActive = false
		timerFormSentryCD:Start(6.4)
		timerEliminationPatternCD:Start(17.6, self.vb.patternCount+1)
	elseif spellId == 352394 then
		playersSafe[args.destName] = nil
		if args:IsPlayer() then
			playerSafe = false
		end
	elseif spellId == 350496 then
		if self.Options.SetIconOnThreat then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			yellThreatNeutralizationFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
--	elseif spellId == 350534 then--Purging Protocol disabling

	end
end

--"<1155.70 23:16:13> [CHAT_MSG_MONSTER_YELL] Dissection!#Guardian of the First Ones###Champssh##0#0##0#282#nil#0#false#false#false#false", -- [14127]
--"<25.44 22:36:58> [CHAT_MSG_MONSTER_YELL] Dismantle.#Guardian of the First Ones###Tadorz##0#0##0#1980#nil#0#false#false#false#false", -- [305]
function mod:CHAT_MSG_MONSTER_YELL(msg, _, _, _, targetName)
	if msg == L.Dissection or msg:find(L.Dissection) or msg == L.Dismantle or msg:find(L.Dismantle) then
		self:SendSync("Dissection", targetName)
	end
end

function mod:OnSync(msg, target)
	if not self:IsInCombat() then return end
	if msg == "Dissection" then
		local targetName = DBM:GetUnitFullName(target) or target
		if targetName then
			warnDisintegration:Show(targetName)--Everyone needs to dodge it so everyone gets special warning. this is just informative message
			if targetName == UnitName("player") then
				yellDisintegration:Yell()
			end
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 350455 and destGUID == UnitGUID("player") and not playerSafe and self:AntiSpam(2, 3) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--"<34.94 22:37:08> [UNIT_SPELLCAST_SUCCEEDED] Guardian of the First Ones(Shazzw) -Elimination Pattern- [[boss1:Cast-3-2012-2450-6508-350735-0021A819F4:350735]]", -- [464]
--"<34.95 22:37:08> [UNIT_SPELLCAST_START] Guardian of the First Ones(Shazzw) - Sunder - 2s [[boss1:Cast-3-2012-2450-6508-350732-00222819F4:350732]]", -- [465]
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 350735 then--Elimination Pattern
		self.vb.patternCount = self.vb.patternCount + 1
		timerEliminationPatternCD:Start(nil, self.vb.patternCount+1)
	end
end

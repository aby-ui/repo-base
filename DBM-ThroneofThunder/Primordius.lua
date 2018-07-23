local mod	= DBM:NewMod(820, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetCreatureID(69017)--69070 Viscous Horror, 69069 good ooze, 70579 bad ooze (patched out of game, :\)
mod:SetEncounterID(1574)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)--Although if you have 8 viscous horrors up, you are probably doing fight wrong.

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 136216",
	"SPELL_CAST_SUCCESS 136037",
	"SPELL_AURA_APPLIED 136050 137000 136215 136246 136225 136228 136245 136218 140546",
	"SPELL_AURA_APPLIED_DOSE 136050 137000",
	"SPELL_AURA_REMOVED 136050 136215 136246 136225 136245 136218 140546",
	"UNIT_AURA player",
	"UNIT_DIED"
)

local warnDebuffCount				= mod:NewAnnounce("warnDebuffCount", 1, 140546)
local warnMalformedBlood			= mod:NewStackAnnounce(136050, 2, nil, "Tank|Healer")--No cd bars for this because it's HIGHLY variable (lowest priority spell so varies wildly depending on bosses 3 buffs)
local warnPrimordialStrike			= mod:NewSpellAnnounce(136037, 3, nil, "Tank|Healer")
local warnGasBladder				= mod:NewTargetAnnounce(136215, 4)--Stack up in front for (but not too close or cleave will get you)
local warnEruptingPustules			= mod:NewTargetAnnounce(136246, 4)
local warnPathogenGlands			= mod:NewTargetAnnounce(136225, 3)
local warnVolatilePathogen			= mod:NewTargetAnnounce(136228, 4)
local warnMetabolicBoost			= mod:NewTargetAnnounce(136245, 3)--Makes Malformed Blood, Primordial Strike and melee 50% more often
local warnVentralSacs				= mod:NewTargetAnnounce(136210, 2)--This one is a joke, if you get it, be happy.
local warnAcidicSpines				= mod:NewTargetAnnounce(136218, 3)
local warnBlackBlood				= mod:NewStackAnnounce(137000, 2, nil, "Tank|Healer")

local specWarnFullyMutated			= mod:NewSpecialWarningYou(140546)
local specWarnFullyMutatedFaded		= mod:NewSpecialWarningFades(140546)
local specWarnCausticGas			= mod:NewSpecialWarningSpell(136216, nil, nil, nil, 2)--All must be in front for this.
local specWarnVolatilePathogen		= mod:NewSpecialWarningYou(136228)
local specWarnViscousHorror			= mod:NewSpecialWarningCount("ej6969", "Tank")
local specWarnEruptingPustules		= mod:NewSpecialWarningTarget(136246, false)

local timerFullyMutated				= mod:NewBuffFadesTimer(120, 140546)
local timerMalformedBlood			= mod:NewTargetTimer(60, 136050, nil, "Tank|Healer", nil, 5)
local timerPrimordialStrikeCD		= mod:NewCDTimer(24, 136037)
local timerCausticGasCD				= mod:NewCDTimer(14, 136216)
local timerVolatilePathogenCD		= mod:NewCDTimer(27, 136228)
local timerBlackBlood				= mod:NewTargetTimer(60, 137000, nil, "Tank|Healer")
local timerViscousHorrorCD			= mod:NewNextCountTimer(30, "ej6969", nil, nil, nil, 1, 137000)

local berserkTimer					= mod:NewBerserkTimer(480)

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("SetIconOnBigOoze", true)--These very hard to see when spawn. rooms red, boss is red, damn ooze is red.

local metabolicBoost = false
local acidSpinesActive = false--Spread of 5 yards
local postulesActive = false
local goodCount = 0
local badCount = 0
local bigOozeCount = 0
local bigOozeAlive = 0
local bigOozeGUIDS = {}
local good1, good2, good3, good4 = DBM:GetSpellInfo(136180), DBM:GetSpellInfo(136182), DBM:GetSpellInfo(136184), DBM:GetSpellInfo(136186)
local bad1, bad2, bad3, bad4 = DBM:GetSpellInfo(136181), DBM:GetSpellInfo(136183), DBM:GetSpellInfo(136185), DBM:GetSpellInfo(136187)

local function BigOoze()
	bigOozeCount = bigOozeCount + 1
	bigOozeAlive = bigOozeAlive + 1
	specWarnViscousHorror:Show(bigOozeCount)
	timerViscousHorrorCD:Start(30, bigOozeCount+1)
	mod:Schedule(30, BigOoze)
	--This is a means to try and do it without using lots of cpu on an already cpu bad fight. If it's not fast enough or doesn't work well (ie people with assist aren't doing this fast enough). may still have to scan all targets
	if DBM:GetRaidRank() > 0 and mod.Options.SetIconOnBigOoze then--Only register event if option is turned on, otherwise no waste cpu
		mod:RegisterShortTermEvents(
			"PLAYER_TARGET_CHANGED",
			"UPDATE_MOUSEOVER_UNIT"
		)
	end
end

function mod:PLAYER_TARGET_CHANGED()
	local guid = UnitGUID("target")
	if guid and self:IsCreatureGUID(guid) then
		local cId = self:GetCIDFromGUID(guid)
		if cId == 69070 and not bigOozeGUIDS[guid] and not UnitIsDead("target") then
			local icon = 9 - bigOozeAlive--Start with skull for big ooze then subtrack from it based on number of oozes up to choose an unused icon
			bigOozeGUIDS[guid] = true--NOW we add this ooze to the table now that we're done counting old ones
			self:UnregisterShortTermEvents()--Add is marked, unregister events until next ooze spawns
			SetRaidTarget("target", icon)
			self:SendSync("BigOozeGUID", guid)--Make sure we keep everynoes ooze guid ignore list/counts up to date.
		end
	end
end

function mod:UPDATE_MOUSEOVER_UNIT()
	local guid = UnitGUID("mouseover")
	if guid and self:IsCreatureGUID(guid) then
		local cId = self:GetCIDFromGUID(guid)
		if cId == 69070 and not bigOozeGUIDS[guid] and not UnitIsDead("mouseover") then
			local icon = 9 - bigOozeAlive--Start with skull for big ooze then subtrack from it based on number of oozes up to choose an unused icon
			bigOozeGUIDS[guid] = true--NOW we add this ooze to the table now that we're done counting old ones
			self:UnregisterShortTermEvents()--Add is marked, unregister events until next ooze spawns
			SetRaidTarget("mouseover", icon)
			self:SendSync("BigOozeGUID", guid)
		end
	end
end

function mod:OnCombatStart(delay)
	metabolicBoost = false
	acidSpinesActive = false
	postulesActive = false
	goodCount = 0
	badCount = 0
	bigOozeCount = 0
	bigOozeAlive = 0
	table.wipe(bigOozeGUIDS)
	berserkTimer:Start(-delay)
	if self:IsHeroic() then
		timerViscousHorrorCD:Start(11.5-delay, 1)
		self:Schedule(11.5, BigOoze)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 136216 then
		specWarnCausticGas:Show()
		timerCausticGasCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 136037 then
		warnPrimordialStrike:Show()
		if metabolicBoost then--Only issue is updating current bar when he gains buff in between CDs, it does seem to affect it to a degree
			timerPrimordialStrikeCD:Start(20)
		else
			timerPrimordialStrikeCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 136050 then
		warnMalformedBlood:Show(args.destName, args.amount or 1)
		timerMalformedBlood:Start(args.destName)
	elseif spellId == 137000 then
		warnBlackBlood:Show(args.destName, args.amount or 1)
		timerBlackBlood:Start(args.destName)
	elseif spellId == 136215 then
		warnGasBladder:Show(args.destName)
	elseif spellId == 136246 then
		postulesActive = true
		warnEruptingPustules:Show(args.destName)
		if self:IsHeroic() then
			specWarnEruptingPustules:Show(args.destName)
		end
		if self.Options.RangeFrame and not acidSpinesActive then--Check if acidSpinesActive is active, if they are, we should already have range 5 up
			DBM.RangeCheck:Show(3)
		end
	elseif spellId == 136225 then
		warnPathogenGlands:Show(args.destName)
	elseif spellId == 136228 then
		warnVolatilePathogen:Show(args.destName)
		timerVolatilePathogenCD:Start()
		if args:IsPlayer() then
			specWarnVolatilePathogen:Show()
		end
	elseif spellId == 136245 then
		metabolicBoost = true
		warnMetabolicBoost:Show(args.destName)
	elseif spellId == 136210 then
		warnVentralSacs:Show(args.destName)
	elseif spellId == 136218 then
		acidSpinesActive = true
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	elseif spellId == 140546 and args:IsPlayer() then
		specWarnFullyMutated:Show()
		local _, _, _, _, _, expires = DBM:UnitDebuff("player", args.spellName)
		timerFullyMutated:Start(expires-GetTime())
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 136050 then
		timerMalformedBlood:Cancel(args.destName)
	elseif spellId == 136215 then
		timerCausticGasCD:Cancel()
	elseif spellId == 136246 then
		postulesActive = false
		if self.Options.RangeFrame and not acidSpinesActive then--Check if acidSpinesActive is active, if they are, leave range frame alone
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 136225 then
		timerVolatilePathogenCD:Cancel()
	elseif spellId == 136245 then
		metabolicBoost = false
	elseif spellId == 136218 then
		acidSpinesActive = false
		if self.Options.RangeFrame then
			if postulesActive then
				DBM.RangeCheck:Show(3)
			else
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 140546 and args:IsPlayer() and self:IsInCombat() then
		timerFullyMutated:Cancel()--Can be dispeled
		specWarnFullyMutatedFaded:Show(args.spellName)
	end
end

function mod:UNIT_AURA(uId)
	local gcnt, gcnt1, gcnt2, gcnt3, gcnt4, bcnt, bcnt1, bcnt2, bcnt3, bcnt4
	gcnt1 = select(3, DBM:UnitDebuff("player", good1)) or 0
	gcnt2 = select(3, DBM:UnitDebuff("player", good2)) or 0
	gcnt3 = select(3, DBM:UnitDebuff("player", good3)) or 0
	gcnt4 = select(3, DBM:UnitDebuff("player", good4)) or 0
	bcnt1 = select(3, DBM:UnitDebuff("player", bad1)) or 0
	bcnt2 = select(3, DBM:UnitDebuff("player", bad2)) or 0
	bcnt3 = select(3, DBM:UnitDebuff("player", bad3)) or 0
	bcnt4 = select(3, DBM:UnitDebuff("player", bad4)) or 0
	gcnt = gcnt1 + gcnt2 + gcnt3 + gcnt4
	bcnt = bcnt1 + bcnt2 + bcnt3 + bcnt4
	if goodCount ~= gcnt or badCount ~= bcnt then
		goodCount = gcnt
		badCount = bcnt
		warnDebuffCount:Show(goodCount, badCount)
	end
end

function mod:UNIT_DIED(args)
	if bigOozeGUIDS[args.destGUID] then
		bigOozeAlive = bigOozeAlive - 1
		bigOozeGUIDS[args.destGUID] = nil
	end
end

function mod:OnSync(msg, guid)
	if msg == "BigOozeGUID" and guid then
		bigOozeGUIDS[guid] = true
		self:UnregisterShortTermEvents()
	end
end

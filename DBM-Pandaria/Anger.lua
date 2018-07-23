local mod	= DBM:NewMod(691, "DBM-Pandaria", nil, 322)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetCreatureID(60491)
mod:SetEncounterID(1564)
mod:SetReCombatTime(20, 10)
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetZone()

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 119488 119622",
	"SPELL_AURA_APPLIED 119622 119626",
	"SPELL_AURA_REMOVED 119626 119488",
	"UNIT_AURA player"
)

local warnGrowingAnger			= mod:NewTargetAnnounce(119622, 4)--Mind control trigger
local warnAggressiveBehavior	= mod:NewTargetAnnounce(119626, 4)--Actual mind control targets

local specWarnUnleashedWrath	= mod:NewSpecialWarningSpell(119488, nil, nil, nil, 2)--Defaults to tank and healers cause tank probalby want to Cd through this and healers have to heal it, dps just do what they always do and kill stuff.
local specWarnGrowingAnger		= mod:NewSpecialWarningYou(119622)
local specWarnBitterThoughts	= mod:NewSpecialWarningMove(119610)

local timerGrowingAngerCD		= mod:NewCDTimer(32, 119622, nil, nil, nil, 3)--Min 32.6~ Max 67.8
local timerUnleashedWrathCD		= mod:NewCDTimer(53, 119488, nil, nil, nil, 2)--Based on rage, but timing is consistent enough to use a CD bar, might require some perfecting later, similar to xariona's special, if rage doesn't reset after wipes, etc.
local timerUnleashedWrath		= mod:NewBuffActiveTimer(24, 119488, nil, "Tank|Healer")

mod:AddBoolOption("RangeFrame", true)--For Mind control spreading.
mod:AddBoolOption("SetIconOnMC2", false)
mod:AddReadyCheckOption(32099, false)

local bitterThought, growingAnger = DBM:GetSpellInfo(119601), DBM:GetSpellInfo(119622)
local playerMCed = false

local function debuffFilter(uId)
	return DBM:UnitDebuff(uId, growingAnger)
end

function mod:updateRangeFrame()
	if not self.Options.RangeFrame then return end
	if DBM:UnitDebuff("player", growingAnger) then
		DBM.RangeCheck:Show(5, nil)--Show everyone.
	else
		DBM.RangeCheck:Show(5, debuffFilter)--Show only people who have debuff.
	end
end

function mod:OnCombatStart(delay, yellTriggered)
	playerMCed = false
	if yellTriggered then
		timerUnleashedWrathCD:Start(-delay)
		timerGrowingAngerCD:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	playerMCed = false
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 119488 then
		specWarnUnleashedWrath:Show()
		timerUnleashedWrath:Start()
	elseif spellId == 119622 then
		timerGrowingAngerCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 119622 then
		warnGrowingAnger:CombinedShow(1.2, args.destName)
		self:updateRangeFrame()
		if args:IsPlayer() then
			specWarnGrowingAnger:Show()
		end
	elseif spellId == 119626 then
		--Maybe add in function to update icons here in case of a spread that results in more then the original 3 getting the final MC debuff.
		if self.Options.SetIconOnMC2 then--Set icons on first debuff to get an earlier spread out.
			self:SetSortedIcon(1.2, args.destName, 8, 3, true)
		end
		warnAggressiveBehavior:CombinedShow(2.5, args.destName)
		if args:IsPlayer() then
			playerMCed = true
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 119626 and self.Options.SetIconOnMC2 then--Remove them after the MCs break.
		self:SetIcon(args.destName, 0)
		if args:IsPlayer() then
			playerMCed = false
		end
	elseif spellId == 119488 then
		timerUnleashedWrathCD:Start()
	end
end

function mod:UNIT_AURA(uId)
	if DBM:UnitDebuff("player", bitterThought) and self:AntiSpam(2) and not playerMCed then
		specWarnBitterThoughts:Show()
	end
end

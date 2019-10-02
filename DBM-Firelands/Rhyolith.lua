local mod	= DBM:NewMod(193, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190821185238")
mod:SetCreatureID(52558)--or does 53772 die instead?didn't actually varify this fires right unit_died event yet so we'll see tonight
mod:SetEncounterID(1204)
mod:SetZone()
--mod:SetModelSound("Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_AGGRO.ogg", "Sound\\Creature\\RHYOLITH\\VO_FL_RHYOLITH_KILL_02.ogg")
--Long: Blah blah blah Nuisances, Nuisances :)
--Short: So Soft

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 98034 97282",
	"SPELL_CAST_SUCCESS 98493 97225",
	"SPELL_SUMMON 98136 98552",
	"SPELL_AURA_APPLIED 99846",
	"SPELL_AURA_APPLIED_DOSE 98255",
	"UNIT_HEALTH boss1"
)

--[[
(ability.id = 98034 or ability.id = 97282) and type = "begincast"
 or (ability.id = 98493 or ability.id = 97225) and type = "cast"
 or (ability.id = 98136 or ability.id = 98552) and type = "summon"
 or ability.id = 99846 and type = "applybuff"
--]]
local warnHeatedVolcano		= mod:NewSpellAnnounce(98493, 3)
local warnFlameStomp		= mod:NewSpellAnnounce(97282, 3, nil, "Melee")--According to journal only hits players within 20 yards of him, so melee by default?
local warnMoltenArmor		= mod:NewStackAnnounce(98255, 4, nil, "Tank|Healer")	-- Would this be nice if we could show this in the infoFrame? (changed defaults to tanks/healers, if you aren't either it doesn't concern you unless you find stuff to stand in)
local warnDrinkMagma		= mod:NewSpellAnnounce(98034, 4)	-- if you "kite" him to close to magma
local warnFragments			= mod:NewSpellAnnounce("ej2531", 2, 98136)
local warnShard				= mod:NewCountAnnounce("ej2532", 3, 98552)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 2)
local warnPhase2			= mod:NewPhaseAnnounce(2, 3)

local specWarnMagmaFlow		= mod:NewSpecialWarningSpell(97225, nil, nil, nil, 2, 2)

local timerFragmentCD		= mod:NewNextTimer(22.5, "ej2531", nil, nil, nil, 1, 98136, DBM_CORE_DAMAGE_ICON)
local timerSparkCD			= mod:NewNextCountTimer(22.5, "ej2532", nil, nil, nil, 1, 98552, DBM_CORE_DAMAGE_ICON)
local timerHeatedVolcano	= mod:NewNextTimer(25.5, 98493, nil, nil, nil, 5)
local timerFlameStomp		= mod:NewNextTimer(30.5, 97282, nil, nil, nil, 2)
local timerSuperheated		= mod:NewNextTimer(10, 101304, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)		--Add the 10 second party in later at some point if i remember to actually log it better
local timerMoltenSpew		= mod:NewCastTimer(6, 98034, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)		--6secs after Drinking Magma
local timerMagmaFlowActive	= mod:NewBuffActiveTimer(10, 97225)	--10 second buff volcano has, after which the magma line explodes.

mod.vb.phase2Started = false
mod.vb.sparkCount = 0
mod.vb.fragmentCount = 0
mod.vb.prewarnedPhase2 = false

function mod:OnCombatStart(delay)
	timerFragmentCD:Start(-delay)
	timerHeatedVolcano:Start(30-delay)
	timerFlameStomp:Start(16-delay)
	if self:IsHeroic() then
		timerSuperheated:Start(300-delay)--5 min on heroic
	else
		timerSuperheated:Start(360-delay)--6 min on normal
	end
	self.vb.phase2Started = false
	self.vb.sparkCount = 0
	self.vb.fragmentCount = 1--Fight starts out 1 cycle in so only 1 more spawns before pattern reset.
	self.vb.prewarnedPhase2 = false
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 98034 then
		warnDrinkMagma:Show()
		timerMoltenSpew:Start()
	elseif spellId == 97282 then
		warnFlameStomp:Show()
		if not self.vb.phase2Started then
			timerFlameStomp:Start()
		else--13sec cd in phase 2
			timerFlameStomp:Start(13)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 98493 then
		warnHeatedVolcano:Show()
		timerHeatedVolcano:Start(self:IsHeroic() and 25.5 or 40)
	elseif spellId == 97225 then
		specWarnMagmaFlow:Show()
		specWarnMagmaFlow:Play("aesoon")
		timerMagmaFlowActive:Start()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 98136 and self:AntiSpam(5, 2) then
		self.vb.fragmentCount = self.vb.fragmentCount + 1
		warnFragments:Show()
		if self.vb.fragmentCount < 2 then
			timerFragmentCD:Start()
		else--Spark is next start other CD bar and reset count.
			self.vb.fragmentCount = 0
			timerSparkCD:Start(22.5, self.vb.sparkCount+1)
		end
	elseif spellId == 98552 then
		self.vb.sparkCount = self.vb.sparkCount + 1
		warnShard:Show(self.vb.sparkCount)
		timerFragmentCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 99846 and not self.vb.phase2Started then
		self.vb.phase2Started = true
		warnPhase2:Show()
		if timerFlameStomp:GetTime() > 0 then--This only happens if it was still on CD going into phase
			timerFlameStomp:Cancel()
			timerFlameStomp:Start(7)
		else--Else, he uses it right away
			timerFlameStomp:Start(1)
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 98255 and self:GetCIDFromGUID(args.destGUID) == 52558 and args.amount > 10 and self:AntiSpam(5, 1) then
		warnMoltenArmor:Show(args.destName, args.amount)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 52558 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 35 and self.vb.prewarnedPhase2 then
			self.vb.prewarnedPhase2 = false
		elseif h > 28 and h < 22 and not self.vb.prewarnedPhase2 then
			self.vb.prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end

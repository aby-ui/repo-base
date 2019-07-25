local mod	= DBM:NewMod("Freya", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190722195205")

mod:SetCreatureID(32906)
mod:SetEncounterID(1133)
mod:SetModelID(28777)
mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellKill)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62437 62859",
	"SPELL_CAST_SUCCESS 62678 62619 63571 62589 63601",
	"SPELL_AURA_APPLIED 62861 62438 62451 62865",
	"SPELL_AURA_REMOVED 62519 62861 62438 63571 62589",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)

-- Trash: 33430 Guardian Lasher (flower)
-- 33355 (nymph)
-- 33354 (tree)

--
-- Elder Stonebark (ground tremor / fist of stone)
-- Elder Brightleaf (unstable sunbeam)

local warnPhase2			= mod:NewPhaseAnnounce(2, 3)
local warnSimulKill			= mod:NewAnnounce("WarnSimulKill", 1)
local warnFury				= mod:NewTargetAnnounce(63571, 2)
local warnRoots				= mod:NewTargetNoFilterAnnounce(62438, 2)

local specWarnLifebinder	= mod:NewSpecialWarningSwitch(62869, "Dps", nil, nil, 1, 2)
local specWarnFury			= mod:NewSpecialWarningMoveAway(63571, nil, nil, nil, 1, 2)
local yellFury				= mod:NewYell(63571)
local yellRoots				= mod:NewYell(62438)
local specWarnTremor		= mod:NewSpecialWarningCast(62859, "SpellCaster", nil, 2, 1, 2)	-- Hard mode
local specWarnBeam			= mod:NewSpecialWarningMove(62865, nil, nil, nil, 1, 2)	-- Hard mode

local enrage 				= mod:NewBerserkTimer(600)
local timerAlliesOfNature	= mod:NewCDTimer(25, 62678, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--No longer has CD, they spawn instant last set is dead, and not a second sooner, except first set
local timerSimulKill		= mod:NewTimer(12, "TimerSimulKill", nil, nil, nil, 5, DBM_CORE_DAMAGE_ICON)
local timerTremorCD 		= mod:NewCDTimer(22.9, 62859, nil, nil, nil, 2)--22.9-47.8
local timerLifebinderCD 	= mod:NewCDTimer(38.2, 62869, nil, nil, nil, 1)
local timerRootsCD 			= mod:NewCDTimer(29.6, 62859, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnFury", 63571, false)
mod:AddSetIconOption("SetIconOnRoots", 62438, false)
mod:AddRangeFrameOption(8, 63571)

local adds = {}
mod.vb.altIcon = true
mod.vb.iconId = 6
mod.vb.phase = 1

function mod:OnCombatStart(delay)
	self.vb.altIcon = true
	self.vb.iconId = 6
	self.vb.phase = 1
	enrage:Start()
	table.wipe(adds)
	timerAlliesOfNature:Start(10-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62437, 62859) then
		specWarnTremor:Show()
		specWarnTremor:Play("stopcast")
		timerTremorCD:Start()
	end
end 

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 62678 then -- Summon Allies of Nature
		--timerAlliesOfNature:Start()
	elseif args.spellId == 62619 and self:GetUnitCreatureId(args.sourceName) == 33228 then -- Pheromones spell, cast by newly spawned Eonar's Gift second they spawn to allow melee to dps them while protector is up.
		specWarnLifebinder:Show()
		specWarnLifebinder:Play("targetchange")
		timerLifebinderCD:Start()
	elseif args:IsSpellID(63571, 62589) then -- Nature's Fury
		if self.Options.SetIconOnFury then
			self.vb.altIcon = not self.vb.altIcon	--Alternates between Skull and X
			self:SetIcon(args.destName, self.vb.altIcon and 7 or 8, 10)
		end
		if args:IsPlayer() then -- only cast on players; no need to check destFlags
			specWarnFury:Show()
			specWarnFury:Play("runout")
			yellFury:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		else
			warnFury:Show(args.destName)
		end
	elseif args.spellId == 63601 then
		--if self.vb.phase == 2 then
			timerRootsCD:Start()
		--end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62861, 62438) then
		warnRoots:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			yellRoots:Yell()
		end
		self.vb.iconId = self.vb.iconId - 1
		if self.Options.SetIconOnRoots then
			self:SetIcon(args.destName, self.vb.iconId, 15)
		end
	elseif args:IsSpellID(62451, 62865) and args:IsPlayer() then
		specWarnBeam:Show()
		specWarnBeam:Play("runaway")
	end 
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 62519 then
		warnPhase2:Show()
		self.vb.phase = 2
	elseif args:IsSpellID(62861, 62438) then
		if self.Options.SetIconOnRoots then
			self:RemoveIcon(args.destName)
		end
		self.vb.iconId = self.vb.iconId + 1
	elseif args:IsSpellID(63571, 62589) and args:IsPlayer() and self.Options.RangeFrame then -- Nature's Fury
		DBM.RangeCheck:Hide()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 33202 or cid == 32916 or cid == 32919 then
		if self:AntiSpam(17, 1) and not self:IsTrivial(85) then
			timerSimulKill:Start()
			warnSimulKill:Show()
		end
		adds[cid] = nil
		local counter = 0
		for i, v in pairs(adds) do
			counter = counter + 1
		end
		if counter == 0 then
			timerSimulKill:Stop()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SpawnYell then
		adds[33202] = true
		adds[32916] = true
		adds[32919] = true
	end
end

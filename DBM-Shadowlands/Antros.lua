if DBM:GetTOC() < 90200 then return end
local mod	= DBM:NewMod(2468, "DBM-Shadowlands", nil, 1192)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211218180514")
mod:SetCreatureID(182466)
mod:SetEncounterID(2550)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors
--mod:SetMinSyncRevision(11969)

mod:RegisterCombat("combat")
--mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 361209 361387",
	"SPELL_CAST_SUCCESS 361341 361632",
	"SPELL_AURA_APPLIED 361201 361632 361390",
	"SPELL_AURA_APPLIED_DOSE 361201 361390",
	"SPELL_AURA_REMOVED 361201 361632",
	"SPELL_AURA_REMOVED_DOSE 361201",
	"SPELL_PERIODIC_DAMAGE 361335",
	"SPELL_PERIODIC_MISSED 361335"
)

--TODO, target scan furious slam? if it works swap the warnings around
--TODO, adjust tank swap stacks
--TODO, boss creature ID, this mod isn't actually gonna load without it
--local warnFuriousSlam					= mod:NewTargetNoFilterAnnounce(361209, 2)
local warnBanishmentMark				= mod:NewTargetNoFilterAnnounce(361632, 2)
local warnDarkDeterrence				= mod:NewStackAnnounce(361390, 2, nil, "Tank|Healer")

local specWarnFuriousSlam				= mod:NewSpecialWarningDodge(361209, nil, nil, nil, 2, 2)
local specWarnDestructionCores			= mod:NewSpecialWarningDodge(361341, nil, nil, nil, 2, 2)
local specWarnBanishmentMark			= mod:NewSpecialWarningMoveAway(361632, nil, nil, nil, 1, 2)
local yellBanishmentMark				= mod:NewYell(361632)
local specWarnDarkDeterrence			= mod:NewSpecialWarningStack(361390, nil, 3, nil, nil, 1, 6)
local specWarnDarkDeterrenceTaunt		= mod:NewSpecialWarningTaunt(361390, nil, nil, nil, 1, 2)
local specWarnGTFO						= mod:NewSpecialWarningGTFO(361335, nil, nil, nil, 1, 8)

local timerFuriousSlamCD				= mod:NewAITimer(11, 361209, nil, nil, nil, 3)
local timerDestructionCoresCD			= mod:NewAITimer(11, 361341, nil, nil, nil, 3)
local timerBanishmentMarkCD				= mod:NewAITimer(49.7, 361632, nil, nil, nil, 3, nil, DBM_COMMON_L.HEALER_ICON)
local timerDeterrentStrikeCD			= mod:NewAITimer(49.7, 361387, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

mod:AddInfoFrameOption(361201, true)
mod:AddRangeFrameOption(5, 361632)

local CalamityStacks = {}

function mod:OnCombatStart(delay, yellTriggered)
	table.wipe(CalamityStacks)
--	if yellTriggered then
--		timerFuriousSlamCD:Start(1-delay)
--		timerDestructionCoresCD:Start(1-delay)
--		timerBanishmentMarkCD:Start(1-delay)
--		timerDeterrentStrikeCD:Start(1-delay)
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(361201))
		DBM.InfoFrame:Show(10, "table", CalamityStacks, 1)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 338858 then
		specWarnFuriousSlam:Show()
		specWarnFuriousSlam:Play("shockwave")
		timerFuriousSlamCD:Start()
	elseif spellId == 361387 then
		timerDeterrentStrikeCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 361341 then
		specWarnDestructionCores:Show()
		specWarnDestructionCores:Play("watchstep")
		timerDestructionCoresCD:Start()
	elseif spellId == 361632 then
		timerBanishmentMarkCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 361201 then
		local amount = args.amount or 1
		CalamityStacks[args.destName] = amount
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(CalamityStacks, 0.4)
		end
	elseif spellId == 361632 then
		warnBanishmentMark:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnBanishmentMark:Show()
			specWarnBanishmentMark:Play("range5")
			yellBanishmentMark:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(5)
			end
		end
	elseif spellId == 361390 then
		local amount = args.amount or 1
		if amount >= 3 then
			if args:IsPlayer() then
				specWarnDarkDeterrence:Show(amount)
				specWarnDarkDeterrence:Play("stackhigh")
			else
				local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
				local remaining
				if expireTime then
					remaining = expireTime-GetTime()
				end
				if (not remaining or remaining and remaining < 6.7) and not UnitIsDeadOrGhost("player") then--TODO, adjust remaining when Cd known
					specWarnDarkDeterrenceTaunt:Show(args.destName)
					specWarnDarkDeterrenceTaunt:Play("tauntboss")
				else
					warnDarkDeterrence:Show(args.destName, amount)
				end
			end
		else
			warnDarkDeterrence:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361201 then
		CalamityStacks[args.destName] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(CalamityStacks, 0.4)
		end
	elseif spellId == 361632 then
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 361201 then
		CalamityStacks[args.destName] = args.amount or 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(CalamityStacks, 0.4)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 361335 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

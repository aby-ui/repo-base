local mod	= DBM:NewMod(2451, "DBM-Party-Shadowlands", 9, 1194)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(175806)
mod:SetEncounterID(2437)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 347392 347249 347623",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 347481",
	"SPELL_AURA_REMOVED 357189 347152",
	"SPELL_AURA_REMOVED_DOSE 357189 347152"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, room get divided more than once? on timer or health based? Currently just coding an announce and no timer
--TODO, assumed boss loses charge on cast start and not cast finish/interrupt. therefor boss will gain 2 stacks, then near instantly lose 1 of them based on assumption, like oregorger
--TODO, probably correct timers around divide
--TODO, detect hard mode on engage for timers
local warnDeployRelocator			= mod:NewCountAnnounce(347392, 1)
local warnDivide					= mod:NewSpellAnnounce(347249, 3)
local warnQuickblade				= mod:NewSpellAnnounce(347623, 3)

local specWarnShurl					= mod:NewSpecialWarningMoveTo(347481, nil, nil, nil, 4, 2)
local specWarnDoubleTechnique		= mod:NewSpecialWarningInterruptCount(156877, "HasInterrupt", nil, nil, 1, 3)
local specWarnTripleTechnique		= mod:NewSpecialWarningInterruptCount(347152, "HasInterrupt", nil, nil, 1, 3)
--local yellEmbalmingIchor			= mod:NewYell(327664)
--local specWarnHealingBalm			= mod:NewSpecialWarningInterrupt(257397, "HasInterrupt", nil, nil, 1, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(320366, nil, nil, nil, 1, 8)

local timerShurlCD					= mod:NewAITimer(11, 347481, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerDeployRelocatorsCD		= mod:NewAITimer(15.8, 347392, nil, nil, nil, 3)
local timerDoubleTechniqueCD		= mod:NewAITimer(18.5, 357189, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerTripleTechniqueCD		= mod:NewAITimer(18.5, 347152, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerQuickbladeCD				= mod:NewAITimer(15.8, 347623, nil, nil, nil, 3)

mod.vb.relocatorCount = 0

local relocator = DBM:GetSpellInfo(347426)

function mod:OnCombatStart(delay)
	self.vb.relocatorCount = 0
	timerShurlCD:Start(1-delay)
	timerDeployRelocatorsCD:Start(1-delay)
	timerDoubleTechniqueCD:Start(1-delay)
	timerQuickbladeCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 347392 then
		self.vb.relocatorCount = self.vb.relocatorCount + 1
		warnDeployRelocator:Show(self.vb.relocatorCount)
		timerDeployRelocatorsCD:Start()
	elseif spellId == 347249 then
		warnDivide:Show()
	elseif spellId == 347623 then
		warnQuickblade:Show()
		timerQuickbladeCD:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 320359 then

	end
end
--]]

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 347481 then
		specWarnShurl:Show(relocator)
		specWarnShurl:Play("justrun")
		timerShurlCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 357189 then
		local amount = args.amount or 0--amount reported for all (SPELL_AURA_APPLIED_DOSE) but 0 (SPELL_AURA_REMOVED)
		if amount == 1 then
			timerDoubleTechniqueCD:Start()
			specWarnDoubleTechnique:Show(args.sourceName, 1)
			specWarnDoubleTechnique:Play("kick1r")
		elseif amount == 0 then
			specWarnDoubleTechnique:Show(args.sourceName, 2)
			specWarnDoubleTechnique:Play("kick2r")
		end
	elseif spellId == 347152 then--Hard Mode
		local amount = args.amount or 0--amount reported for all (SPELL_AURA_APPLIED_DOSE) but 0 (SPELL_AURA_REMOVED)
		if amount == 2 then
			timerTripleTechniqueCD:Start()
			specWarnTripleTechnique:Show(args.sourceName, 1)
			specWarnTripleTechnique:Play("kick1r")
		elseif amount == 1 then
			specWarnTripleTechnique:Show(args.sourceName, 2)
			specWarnTripleTechnique:Play("kick2r")
		elseif amount == 0 then
			specWarnTripleTechnique:Show(args.sourceName, 3)
			specWarnTripleTechnique:Play("kick2r")
		end
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 320366 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 164578 then

	end
end


function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257453  then

	end
end
--]]

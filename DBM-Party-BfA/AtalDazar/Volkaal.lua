local mod	= DBM:NewMod(2036, "DBM-Party-BfA", 1, 968)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220209045257")
mod:SetCreatureID(122965)
mod:SetEncounterID(2085)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 250585",
	"SPELL_CAST_START 250258",
	"SPELL_CAST_SUCCESS 250368 259572 250241",
	"SPELL_PERIODIC_DAMAGE 250585",
	"SPELL_PERIODIC_MISSED 250585",
	"UNIT_DIED"
)

--ability.id = 250258 and type = "begincast" or (ability.id = 250368 or ability.id = 259572 or ability.id = 250241) and type = "cast" or target.id = 125977 and type = "death"
--TODO, stench says it's interruptable but cannot verify this. When I determine what to do with it, improve warning
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnTotemsLeft				= mod:NewAddsLeftAnnounce(250190, 2, 250192)
--local warnNoxiousStench				= mod:NewSpellAnnounce(250368, 3)

local specWarnLeap					= mod:NewSpecialWarningDodge(250258, nil, nil, nil, 2, 2)
local specWarnNoxiousStench			= mod:NewSpecialWarningInterrupt(250368, "HasInterrupt", nil, nil, 1, 2)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(250585, nil, nil, nil, 1, 8)

local timerLeapCD					= mod:NewCDTimer(5.7, 250258, nil, nil, nil, 3)--6 uness delayed by stentch, then 8
local timerNoxiousStenchCD			= mod:NewCDTimer(18.2, 250368, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON..DBM_COMMON_L.DISEASE_ICON)

mod.vb.totemRemaining = 3

function mod:OnCombatStart(delay)
	self.vb.totemRemaining = 3
	self:SetStage(1)
	timerLeapCD:Start(2-delay)
	timerNoxiousStenchCD:Start(5.7-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 250585 and args:IsPlayer() and self:AntiSpam(3, 1) then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 250258 then
		specWarnLeap:Show()
		specWarnLeap:Play("watchstep")
		timerLeapCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 250368 or spellId == 259572 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnNoxiousStench:Show(args.sourceName)
			specWarnNoxiousStench:Play("kickcast")
		end
		if self.vb.phase == 2 then
			timerNoxiousStenchCD:Start(18.2)
		else
			timerNoxiousStenchCD:Start(20.6)
			timerLeapCD:AddTime(2)--Consistent with early alpha, might use more complex code if this becomes inconsistent
		end
	elseif spellId == 250241 then
		self:SetStage(2)
		timerNoxiousStenchCD:Stop()
		timerLeapCD:Stop()
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
	end
end


function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 250585 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE


function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 125977 then--Reanimation Totem
		self.vb.totemRemaining = self.vb.totemRemaining - 1
		if self.vb.totemRemaining > 0 then
			warnTotemsLeft:Show(self.vb.totemRemaining)
		end
	end
end

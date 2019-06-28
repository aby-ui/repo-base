local mod	= DBM:NewMod(2357, "DBM-Party-BfA", 11, 1178)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041813709")
mod:SetCreatureID(150159)
mod:SetEncounterID(2290)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 297257 297261",
--	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START 297254",
	"SPELL_CAST_SUCCESS 297465"
)

--TODO: Get right event for Rumble
--TODO, add nameplate aura for https://ptr.wowhead.com/spell=297318/powered-up if it's on a unit with nameplate
local warnElectricalCharge			= mod:NewTargetAnnounce(297257, 2)
local warnGetEm						= mod:NewSpellAnnounce(297465, 2)

local specWarnChargedSmash			= mod:NewSpecialWarningSpell(297254, nil, nil, nil, 2, 2)
--local specWarnHowlingFear			= mod:NewSpecialWarningInterrupt(257791, "HasInterrupt", nil, nil, 1, 2)
local specWarnElectricalCharge		= mod:NewSpecialWarningYou(297257, nil, nil, nil, 1, 2)
local yellElectricalCharge			= mod:NewYell(297257, nil, false)
local specWarnRumble				= mod:NewSpecialWarningSpell(297261, nil, nil, nil, 2, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(238028, nil, nil, nil, 1, 8)

--local timerHowlingFearCD			= mod:NewAITimer(13.4, 257791, nil, "HasInterrupt", nil, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerChargedSmashCD			= mod:NewAITimer(31.6, 297254, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)
local timerRumbleCD					= mod:NewAITimer(31.6, 297261, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerGetEmCD					= mod:NewAITimer(31.6, 297465, nil, nil, nil, 1)

--mod:AddRangeFrameOption(5, 194966)

function mod:OnCombatStart(delay)
	timerChargedSmashCD:Start(1-delay)
	timerRumbleCD:Start(1-delay)
	timerGetEmCD:Start(1-delay)
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 297257 then
		if args:IsPlayer() then
			specWarnElectricalCharge:Show()
			specWarnElectricalCharge:Play("targetyou")
			yellElectricalCharge:Yell()
		else
			warnElectricalCharge:Show(args.destName)
		end
	elseif spellId == 297261 then
		specWarnRumble:Show()
		specWarnRumble:Play("aesoon")
		timerRumbleCD:Start()
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 297257 then

	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 297254 then
		specWarnChargedSmash:Show()
		specWarnChargedSmash:Play("helpsoak")
		timerChargedSmashCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 297465 then
		warnGetEm:Show()
		timerGetEmCD:Start()
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228007 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 124396 then

	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257939 then
	end
end
--]]
